global class TableMetadataCache implements Cache.CacheBuilder {
    
    private Map<String,List<SnowflakeColumnMetadata>> columnMetadata = new Map<String,List<SnowflakeColumnMetadata>>();
    private SnowflakeConnection snowflakeConnection;
    
    public TableMetadataCache(SnowflakeConnection snowflakeConn){
        SnowflakeConnection = snowflakeConn;
    }
    /**
     * Takes a string of the form (table)|(metadata), for example CUSTOMER|FIRST_NAME and
     * returns a SnowflakeColumnMetadata object, which is the metadata from the Snowflake INFORMATION_SCHEMA database.
     */ 
    public Object doLoad(String tablePipeColumn) {
        System.debug('--- TableMetadataCache doLoad start');
        List<String> tablePipeColumnSplit=tablePipeColumn.split('\\|');
        String tableName = tablePipeColumnSplit.get(0);
        String columnName = tablePipeColumnSplit.get(1);
        List<SnowflakeColumnMetadata> tableData = columnMetadata.get(tableName);
        if (tableData==null){
            fetchMetadata();
            tableData = columnMetadata.get(tableName);
            if (tableData==null){
                throw new ExternalObjectException('Unable to retrieve metadata for '+tablePipeColumn+' from Snowflake (missing whole table)');
            }
        }
        SnowflakeColumnMetadata theColumn = getColumnFromList(tableData,columnName);
        if (theColumn==null){
            fetchMetadata();
            theColumn = getColumnFromList(tableData,columnName);
            if (theColumn==null){
                throw new ExternalObjectException('Unable to retrieve metadata for '+tablePipeColumn+' from Snowflake (missing column)');
            }
        }
        System.debug('--- TableMetadataCache doLoad end');
        return theColumn;
    }
    
    private SnowflakeColumnMetadata getColumnFromList(List<SnowflakeColumnMetadata> tableData, String columnName){
        System.debug('--- TableMetadataCache SnowflakeColumnMetadata start');
        for (SnowflakeColumnMetadata col : tableData){
            if (col.columnName==columnName){
                return col;
            }
        }
        System.debug('--- TableMetadataCache SnowflakeColumnMetadata stop');
        return null;
    }
    
    public Map<String,List<SnowflakeColumnMetadata>> fetchAll(){
        System.debug('--- TableMetadataCache fetchAll start');
        fetchMetadata();
        System.debug('--- TableMetadataCache fetchAll end');
        return columnMetadata;
    }
    
    private void fetchMetadata(){
        
        System.debug('--- TableMetadataCache fetchMetadata start');
        List<SnowflakeQueryBinding> bindings = new List<SnowflakeQueryBinding>();
        
        String createColsQuery=
          //'create or replace temporary table IDENTIFIER(?) as'+
                           // '('+
                                'select TABLE_CATALOG,TABLE_SCHEMA,TABLE_NAME,COLUMN_NAME,DATA_TYPE,IS_NULLABLE,'+
                                    'TO_VARCHAR(COALESCE(CHARACTER_MAXIMUM_LENGTH,0)) as CHARACTER_MAXIMUM_LENGTH,'+
                                    'TO_VARCHAR(COALESCE(NUMERIC_PRECISION,0)) as NUMERIC_PRECISION,'+
                                    'TO_VARCHAR(COALESCE(NUMERIC_SCALE,0)) as NUMERIC_SCALE,'+
                                    'TO_VARCHAR(COALESCE(DATETIME_PRECISION,0)) as DATETIME_PRECISION, ORDINAL_POSITION '+
                            'from IDENTIFIER(?) '+
                            'where TABLE_CATALOG=? and TABLE_SCHEMA=? limit 1';
                            //');';
      //  bindings.add(new SnowflakeQueryBinding('TEXT','"'+snowflakeConnection.urlParams.get('database')+'"."'+snowflakeConnection.urlParams.get('schema')+'".COLS_IN_SCHEMA'));
        bindings.add(new SnowflakeQueryBinding('TEXT','"'+snowflakeConnection.urlParams.get('database')+'".INFORMATION_SCHEMA.COLUMNS'));
        bindings.add(new SnowflakeQueryBinding('TEXT',snowflakeConnection.urlParams.get('database')));
        bindings.add(new SnowflakeQueryBinding('TEXT',snowflakeConnection.urlParams.get('schema')));
        System.debug('--- TableMetadataCache before responseBody 1st qry' );
        String responseBody=snowflakeConnection.snowflakeQueryWithErrorHandling(createColsQuery, bindings, null);
        System.debug('--- TableMetadataCache responseBody 1st qry' + responseBody);
         bindings = new List<SnowflakeQueryBinding>();
        String tableListQuery='select TABLE_CATALOG,TABLE_SCHEMA,TABLE_NAME,COLUMN_NAME,DATA_TYPE,IS_NULLABLE,'+
        'TO_VARCHAR(COALESCE(CHARACTER_MAXIMUM_LENGTH,0)) as CHARACTER_MAXIMUM_LENGTH,'+
        'TO_VARCHAR(COALESCE(NUMERIC_PRECISION,0)) as NUMERIC_PRECISION,'+
                                    'TO_VARCHAR(COALESCE(NUMERIC_SCALE,0)) as NUMERIC_SCALE,'+
                                    'TO_VARCHAR(COALESCE(DATETIME_PRECISION,0)) as DATETIME_PRECISION  ' +
                            'from IDENTIFIER(?) '+
                            'where TABLE_CATALOG=? and TABLE_SCHEMA=? '+
                            'and TABLE_NAME in (select  TABLE_NAME from IDENTIFIER(?)  where COLUMN_NAME = \'ExternalId\' and DATA_TYPE= \'TEXT\') ' +
                            'order by TABLE_NAME, ORDINAL_POSITION'         ;
        bindings.add(new SnowflakeQueryBinding('TEXT','"'+snowflakeConnection.urlParams.get('database')+'".INFORMATION_SCHEMA.COLUMNS'));
       // bindings.add(new SnowflakeQueryBinding('TEXT','"'+snowflakeConnection.urlParams.get('database')+'"."'+snowflakeConnection.urlParams.get('schema')+'".SFDC_COLS_IN_SCHEMA'));
        bindings.add(new SnowflakeQueryBinding('TEXT',snowflakeConnection.urlParams.get('database')));
        bindings.add(new SnowflakeQueryBinding('TEXT',snowflakeConnection.urlParams.get('schema')));
        bindings.add(new SnowflakeQueryBinding('TEXT','"'+snowflakeConnection.urlParams.get('database')+'".INFORMATION_SCHEMA.COLUMNS'));
        //bindings.add(new SnowflakeQueryBinding('TEXT','"'+snowflakeConnection.urlParams.get('database')+'"."'+snowflakeConnection.urlParams.get('schema')+'".SFDC_COLS_IN_SCHEMA'));
        System.debug('--- TableMetadataCache before responseBody 2st qry' );
         responseBody=snowflakeConnection.snowflakeQueryWithErrorHandling(tableListQuery, bindings, null);
         System.debug('--- TableMetadataCache responseBody 2st qry' + responseBody);
         
        SnowflakeSchemaResponse r = SnowflakeSchemaResponse.parse(responseBody);
       
        List<SnowflakeColumnMetadata> colMetadata = new List<SnowflakeColumnMetadata>();
        for (List<String> rowset : r.data.rowset) {
            SnowflakeColumnMetadata meta = SnowflakeColumnMetadata.fromInformationSchemaQuery(rowset);
            
            if (columnMetadata.get(meta.tableName)==null){
                columnMetadata.put(meta.tableName,new List<SnowflakeColumnMetadata>());
            }
            columnMetadata.get(meta.tableName).add(meta);
        }
        System.debug('--- TableMetadataCache fetchMetadata end');
    }
}