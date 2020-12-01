global with sharing class SnowflakeConnection extends DataSource.Connection {
    String baseUrl;
    public Map<String, String> urlParams;
    WebRequester webRequester;
    String accountName;
    // Stores the Snowflake session token
    String sessionToken;
    /**
     * Constructor, authenticates to Snowflake to create a session
     */
    global SnowflakeConnection(DataSource.ConnectionParams connectionParams) {
        this(connectionParams.endpoint,connectionParams.username, connectionParams.password, new WebRequester());
    }
    
    global SnowflakeConnection(String endpointString,String username,String password,WebRequester requester){
        System.debug('--- SnowflakeConnection construct start endpoint ' +endpointString);
        webRequester=requester;
        // break the provided URL into its components
        Url endpoint=new Url(endpointString);
        baseUrl=endpoint.getProtocol()+'://'+endpoint.getHost();
        urlParams = new Map<String, String>();
        if (endpoint.getQuery()==null){
            throw new ExternalObjectException('In the Snowflake connection URL\'s query string, you must specify \'database\', \'schema\', \'role\' and \'warehouse\'');
        }
        for (String param : endpoint.getQuery().split('\\&')) {
            String[] keyValue=param.split('=');
            urlParams.put(keyValue[0],keyValue[1]);
        }
        if (urlParams.get('database')==null){
            throw new ExternalObjectException('In the Snowflake connection URL\'s query string, you must specify \'database\'');
        }
        if (urlParams.get('schema')==null){
            throw new ExternalObjectException('In the Snowflake connection URL\'s query string, you must specify \'schema\'');
        }
        if (urlParams.get('role')==null){
            throw new ExternalObjectException('In the Snowflake connection URL\'s query string, you must specify \'role\'');
        }
        if (urlParams.get('warehouse')==null){
            throw new ExternalObjectException('In the Snowflake connection URL\'s query string, you must specify \'warehouse\'');
        }
        accountName=endpoint.getHost().split('\\.')[0];
        
        // authenticate to Snowflake
        authenticate(username,password);
    }
    
    /**
     * sync method, retrieves table information from Snowflake and returns it to Salesforce in order to create external objects.
     * This is called from the UI so we can provide feedback and errors with ApexPages.addmessage
     */
    override global List<DataSource.Table> sync() {
        System.debug('--- SnowflakeConnection sync start');
        
        TableMetadataCache cache = new TableMetadataCache(this);
        Map<String,List<SnowflakeColumnMetadata>> allMetadata = cache.fetchAll();
        
        
        Map<String, List<DataSource.Column>> tableColumns = new Map<String, List<DataSource.Column>>();
        
        for (String key : allMetadata.keySet()){
            for (SnowflakeColumnMetadata meta : allMetadata.get(key)){
                if (!tableColumns.containsKey(meta.tableName)){
                    tableColumns.put(meta.tableName,new List<DataSource.Column>());
                    tableColumns.get(meta.tableName).add(DataSource.Column.url('DisplayUrl'));
                }
                tableColumns.get(meta.tableName).add(TypeMappings.buildSalesforceColumnFromSnowflakeRowset(meta.columnName, meta.dataType, 
                                        meta.characterMaxLength, meta.numericPrecision, meta.numericScale, meta.dateTimePrecision));
            }
        }
        
        List<DataSource.Table> tables = new List<DataSource.Table>();
        for (String table : tableColumns.keySet()){
            tables.add(DataSource.Table.get(table, table, tableColumns.get(table)));
        }
        System.debug('--- SnowflakeConnection sync end');
        return tables;
    }
    
    /**
     * Authenticates to Snowflake by calling the login-request endpoint.
     * TOOO: Store session in Org cache?
     */
    private void authenticate(String username,String password){
        System.debug('--- SnowflakeConnection authenticate start');
        JSONGenerator gen = JSON.createGenerator(true); 
        gen.writeStartObject();
        gen.writeFieldName('data');
        gen.writeStartObject();
        gen.writeStringField('ACCOUNT_NAME', accountName);
        gen.writeStringField('LOGIN_NAME', username);
        gen.writeStringField('PASSWORD', password);
        gen.writeStringField('CLIENT_APP_ID', 'Salesforce Lightning Connect Provider');
        gen.writeStringField('CLIENT_APP_VERSION', '20181201193000');
        gen.writeFieldName('CLIENT_ENVIRONMENT');
        gen.writeStartObject();
        gen.writeStringField('BROWSER_VERSION', 'N/A');
        gen.writeStringField('OS_VERSION', 'Salesforce runtime');
        gen.writeEndObject();
        gen.writeEndObject();
        gen.writeEndObject();
        
        String jsonS = gen.getAsString();
        System.debug('--- SnowflakeConnection authenticate jsonS' + jsonS);
        webRequester.setHeader('Content-Type', 'application/json');
        String responseBody=webRequester.post(baseUrl+'/session/v1/login-request?roleName='+urlParams.get('role')+'&warehouse='+urlParams.get('warehouse'), jsonS);
        JSONParser parser = JSON.createParser(responseBody);
        System.debug('--- SnowflakeConnection authenticate parser ---' );
        String masterToken = null;
        String token = null;
        while (parser.nextToken() != null && (masterToken == null || token == null)) {
            if ((parser.getCurrentToken() == JSONToken.FIELD_NAME) && 
                (parser.getText() == 'masterToken')) {
                parser.nextToken();
                masterToken = parser.getText();
            }
            else if ((parser.getCurrentToken() == JSONToken.FIELD_NAME) && 
                (parser.getText() == 'token')) {
                parser.nextToken();
                token = parser.getText();
                sessionToken = token;
            }
        }  
        
        System.debug('--- SnowflakeConnection authenticate parser end ---' );
    }
    
    private DataSource.Column getColumnByName(String columnName,DataSource.QueryContext context){
        System.debug('--- SnowflakeConnection getColumnByName ---' );
        for (DataSource.Column column : context.metadata.get(0).columns){
            if (column.name==columnName){
                return column;
            }
        }
        throw new ExternalObjectException('Column "'+columnName+'" not found in context metadata');
        
    }
    
    /*
     * Sends an SQL query to Snowflake, uses bindings for user-configurable values.
     * Sometimes needs to query Snowflake first to determine the data type of a column.
     * It would be good to keep data types in the Org cache, for better performance.
     */
    private String snowflakeQuery(String query, List<SnowflakeQueryBinding> queryBindings,DataSource.QueryContext context){
        String url=baseUrl+'/queries/v1/query-request?requestId='+new Uuid().getValue();
        System.debug('--- url  --- ' + url);
        System.debug('--- query  --- ' + query);
        JSONGenerator gen = JSON.createGenerator(true); 
        gen.writeStartObject();   
        gen.writeStringField('sqlText', query);
        gen.writeFieldName('bindings');
        gen.writeStartObject();
        Integer index = 1;
        
        TableMetadataCache cache = new TableMetadataCache(this);
        
        if (queryBindings!=null && queryBindings.size() > 0){
            for (SnowflakeQueryBinding binding : queryBindings){
                gen.writeFieldName(''+index);
                gen.writeStartObject();
                
                if (binding.hasKnownType()){
                    gen.writeStringField('type',TypeMappings.snowflakeBindingFromSnowflakeType(binding.knownType));
                }
                else{
                    SnowflakeColumnMetadata columnType=(SnowflakeColumnMetadata) cache.doLoad(binding.tableName+'|'+binding.columnName);
                    String bindType=TypeMappings.snowflakeBindingFromSnowflakeType(columnType.dataType);
                    gen.writeStringField('type',TypeMappings.snowflakeBindingFromSnowflakeType(bindType));
                }
                
                gen.writeStringField('value',''+binding.value);
                gen.writeEndObject();
                index++;
            }
        }
        gen.writeEndObject();
        gen.writeBooleanField('disableOfflineChunks', true);
        gen.writeFieldName('parameters');
        gen.writeStartObject();
        gen.writeBooleanField('ui_mode', false);
        gen.writeBooleanField('ui_internal_mode', false);
        gen.writeEndObject();
        gen.writeBooleanField('isInternal', false);
        gen.writeEndObject();
        webRequester.clear();
        webRequester.setHeader('Content-Type', 'application/json');
        webRequester.setHeader('Accept', 'application/snowflake');
        webRequester.setHeader('Authorization', 'Snowflake Token="'+sessionToken+'"');
        String responseBody=webRequester.post(url, gen.getAsString());
        System.debug('--- responseBody  --- ' + responseBody);
        return responseBody;
    }
    
    /**
     * query method called by Salesforce when the user requests data.
     * Builds a query and executes it twice - once to count the total (without limits),
     * then again to retrieve the data.
     */
    override global DataSource.TableResult query(DataSource.QueryContext context) {
        System.debug('--- SnowflakeConnection query start');
        System.debug('Query context:'+context);
        Integer rowCount=fetchRowCount(context);
        SnowflakeSchemaResponse r = fetchData(context);
        List<List<String>> rowset = r.data.rowset;
        List<Map<String, Object>> rows = new List<Map<String, Object>>();
        for (List<String> row : rowset){
            Map<String, Object> columnValues=new Map<String, Object>();
            for (Integer i = 0; i < row.size(); i++) {
                columnValues.put(context.tableSelection.columnsSelected[i].columnName,row[i]);
            }
            rows.add(columnValues);
        }
        if (rowCount < rows.size()){
            rowCount=rows.size(); // workaround for Snowflake bug in materialized views
        }
        System.debug('--- SnowflakeConnection query end');
        return DataSource.TableResult.get(true, null, context.tableSelection.tableSelected, rows,rowCount);
    }
    
    private Integer fetchRowCount(DataSource.QueryContext context){
        List<SnowflakeQueryBinding> bindings = new List<SnowflakeQueryBinding>();
        DataSource.Filter filter = context.tableSelection.filter;
        // count total rows first
        String selectCountClause='select count(*) as ROWCOUNT';
         String fromClause='from IDENTIFIER(?) ';
        bindings.add(new SnowflakeQueryBinding('TEXT','"'+urlParams.get('database')+'"."'+urlParams.get('schema')+'"."'+context.tableSelection.tableSelected+'"'));
            
        String whereClause='';
        if (filter!=null){
            whereClause='where '+buildWhereClause(filter,bindings);
        }
        String rowCountQuery=selectCountClause+' '+fromClause+' '+whereClause;
        System.debug('Row Count Query :'+rowCountQuery);        
        String responseBody=snowflakeQueryWithErrorHandling(rowCountQuery,bindings,context);
        SnowflakeSchemaResponse r = SnowflakeSchemaResponse.parse(responseBody);
        List<List<String>> rowset = r.data.rowset;
        String totalRows=rowset.get(0).get(0);
        Integer totalRowsInt=Integer.valueOf(totalRows);
        return totalRowsInt;
    }
    
    private SnowflakeSchemaResponse fetchData(DataSource.QueryContext context){
        List<SnowflakeQueryBinding> bindings = new List<SnowflakeQueryBinding>();
        DataSource.Filter filter = context.tableSelection.filter;
        
        String selectColumnsClause=buildSelectClause(context.tableSelection.columnsSelected,context.metadata.get(0).columns,bindings);
        
        String fromClause='from IDENTIFIER(?) ';
        bindings.add(new SnowflakeQueryBinding('TEXT','"'+urlParams.get('database')+'"."'+urlParams.get('schema')+'"."'+context.tableSelection.tableSelected+'"'));
            
        String whereClause='';
        if (filter!=null){
            whereClause='where '+buildWhereClause(filter,bindings);
        }
        String orderByClause='';
        if (context.tableSelection.order!=null && context.tableSelection.order.size()>0){
            orderByClause='order by '+buildOrderByClause(context.tableSelection.order, bindings);
        }
        String limitClause='';
        if (context.maxResults!=null){
            if (context.maxResults==0){
                limitClause='limit 1'; // not sure why, but I've observed salesforce pass in a limit 0 when asking for a record
            }else{
                limitClause='limit '+context.maxResults;
            }
        }
        String offsetClause='';
        if (context.offset!=null){
            offsetClause='offset '+context.offset;
        }
        String dataQuery=selectColumnsClause+' '+fromClause+' '+whereClause+' '+orderByClause+' '+limitClause+' '+offsetClause;
        System.debug('Data Query :'+dataQuery);
        String responseBody=snowflakeQueryWithErrorHandling(dataQuery,bindings,context);
        return SnowflakeSchemaResponse.parse(responseBody);
    }
    
    /**
     * Wraps around the snowflakeQuery method and provides error handling.
     * Checks the success flag in the body from Snowflake, and throws an Exception that Salesforce can understand.
     */ 
    public String snowflakeQueryWithErrorHandling(String query, List<SnowflakeQueryBinding> queryBindings,DataSource.QueryContext context){
        
       
        String responseBody=snowflakeQuery(query,queryBindings,context);
        System.debug('raw response:'+responseBody);
        SnowflakeQuerySuccess sqs = SnowflakeQuerySuccess.parse(responseBody);
        
        if (!sqs.success){
            Decimal block = 1/0;
            SnowflakeErrorDetail sed = SnowflakeErrorDetail.parse(responseBody);
            
            throw new ExternalObjectException('Error while executing "'+query+'" with bindings "'+queryBindings+'": '+sed.message);
        }
        return responseBody;
    }
    
    /**
     * Converts the Salesforce List<DataSource.ColumnSelection> into a SELECT clause
     */
    private String buildSelectClause(List<DataSource.ColumnSelection> columnsSelected,List<DataSource.Column> columnsMetadata,List<SnowflakeQueryBinding> bindings){
        String query='select ';
        for (DataSource.ColumnSelection columnSelection : columnsSelected){
            DataSource.Column columnMetadata;
            for (DataSource.Column column : columnsMetadata){
                if (column.name==columnSelection.columnName){
                    columnMetadata=column;
                    break;
                }
            }
            if (columnMetadata.type==DataSource.DataType.DATETIME_TYPE){
                // Salesforce like to receive the format yyyy-MM-dd HH:mm:ss in UTC timezone
                
                query=query+'TO_VARCHAR(CONVERT_TIMEZONE(\'UTC\',"'+String.escapeSingleQuotes(columnSelection.columnName)+'"), \'YYYY-MM-DD HH:MI:SS\'),';
                //bindings.add(new SnowflakeQueryBinding('TEXT',columnSelection.columnName));
            }else if(columnSelection.columnName=='DisplayUrl'){
                query=query+'\'N/A\' as "DisplayUrl",';
            }else{
                query=query+'"'+String.escapeSingleQuotes(columnSelection.columnName)+'",';
                //bindings.add(new SnowflakeQueryBinding('TEXT',columnSelection.columnName));
            }
        }
        query=query.substringBeforeLast(',');
        System.debug('inside buildSelectClause Query :'+query); 
        return query;
    }
    
    /**
     * Converts the Salesforce List<DataSource.Order> into a ORDER BY clause
     */
    private String buildOrderByClause(List<DataSource.Order> orders,List<SnowflakeQueryBinding> bindings){
        String clause='';
        for (DataSource.Order order : orders){
            String direction='DESC';
            if (order.direction==DataSource.OrderDirection.ASCENDING){
                direction='ASC';
            }
            //clause=clause+'IDENTIFIER(?) '+direction+',';
            clause=clause+'"'+String.escapeSingleQuotes(order.columnName)+'" '+direction+',';
            //bindings.add(new SnowflakeQueryBinding('TEXT',order.columnName));
        }
        clause=clause.substringBeforeLast(',');
        return clause;
    }
    
    /**
     * Converts the Salesforce DataSource.Filter into a WHERE clause
     */
    public String buildWhereClause(DataSource.Filter filter,List<SnowflakeQueryBinding> bindings){
        if (filter.subfilters!=null && filter.subfilters.size()==1){
            return '('+buildWhereClause(filter.subfilters.get(0),bindings)+')';
        }
        switch on filter.type {
            when NOT_ {
                return 'NOT '+buildWhereClause(filter.subfilters.get(0),bindings);
            }
            when AND_ {
                return '('+buildWhereClause(filter.subfilters.get(0),bindings)+') and ('+buildWhereClause(filter.subfilters.get(1),bindings)+')';
            }
            when OR_ {
                return '('+buildWhereClause(filter.subfilters.get(0),bindings)+') or ('+buildWhereClause(filter.subfilters.get(1),bindings)+')';
            }
            when CONTAINS {
                bindings.add(new SnowflakeQueryBinding(filter.tableName,filter.columnName,'%'+filter.columnValue+'%'));
                return '"'+String.escapeSingleQuotes(filter.columnName)+'" like ?';
            }
            when ENDS_WITH {
                bindings.add(new SnowflakeQueryBinding(filter.tableName,filter.columnName,'%'+filter.columnValue));
                return '"'+String.escapeSingleQuotes(filter.columnName)+'" like ?';
            }
            when STARTS_WITH {
                bindings.add(new SnowflakeQueryBinding(filter.tableName,filter.columnName,filter.columnValue+'%'));
                return '"'+String.escapeSingleQuotes(filter.columnName)+'" like ?';
            }
            when EQUALS {
                bindings.add(new SnowflakeQueryBinding(filter.tableName,filter.columnName,''+filter.columnValue));
                return '"'+String.escapeSingleQuotes(filter.columnName)+'" = ?';
            }
            when NOT_EQUALS {
                bindings.add(new SnowflakeQueryBinding(filter.tableName,filter.columnName,''+filter.columnValue));
                return '"'+String.escapeSingleQuotes(filter.columnName)+'" != ?';
            }
            when GREATER_THAN {
                bindings.add(new SnowflakeQueryBinding(filter.tableName,filter.columnName,''+filter.columnValue));
                return '"'+String.escapeSingleQuotes(filter.columnName)+'" > ?';
            }
            when GREATER_THAN_OR_EQUAL_TO {
                bindings.add(new SnowflakeQueryBinding(filter.tableName,filter.columnName,''+filter.columnValue));
                return '"'+String.escapeSingleQuotes(filter.columnName)+'" >= ?';
            }
            when LESS_THAN {
                bindings.add(new SnowflakeQueryBinding(filter.tableName,filter.columnName,''+filter.columnValue));
                return '"'+String.escapeSingleQuotes(filter.columnName)+'" < ?';
            }
            when LESS_THAN_OR_EQUAL_TO {
                bindings.add(new SnowflakeQueryBinding(filter.tableName,filter.columnName,''+filter.columnValue));
                return '"'+String.escapeSingleQuotes(filter.columnName)+'" <= ?';
            }
            when LIKE_ {
                bindings.add(new SnowflakeQueryBinding(filter.tableName,filter.columnName,'%'+filter.columnValue+'%'));
                return '"'+String.escapeSingleQuotes(filter.columnName)+'" like ?';
            }
        }
        return '';
    }
    
    override global List<DataSource.TableResult> search(DataSource.SearchContext c) {    
        throw new ExternalObjectException('The "search" method is not supported by the Snowflake provider');
    }

    global override List<DataSource.UpsertResult> upsertRows(DataSource.UpsertContext
            context) {
        throw new ExternalObjectException('The "upsertRows" method is not supported by the Snowflake provider');
    }
         
    global override List<DataSource.DeleteResult> deleteRows(DataSource.DeleteContext 
            context) {
        throw new ExternalObjectException('The "deleteRows" method is not supported by the Snowflake provider');
    }
     
}