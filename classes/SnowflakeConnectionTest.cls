@isTest
public with sharing class SnowflakeConnectionTest {
    static String endpoint='https://test123.ap-southeast-2.snowflakecomputing.com';
    static String Username = 'username';
    static String password = 'password';
    static String database = 'SAMPLE_DATA';
    static String role = 'PUBLIC';
    static String schema = 'PUBLIC';
	static String warehouse = 'COMPUTE_WH';
        
    public static testMethod void testBadSnowflakeConnectionString1() {
        String url = endpoint;
        try{
	        SnowflakeConnection connection = new SnowflakeConnection(url,username,password, new FakeWebRequester());       
            System.assert(false,'Expected an exception from bad connection string');
        }
        catch(Exception e){
            System.assert(e.getMessage().contains('you must specify'), 'Error message was not as expected');
        }
    }
   
    public static testMethod void testBadSnowflakeConnectionString2() {
        String url = endpoint+'?database=yeah';
        try{
	        SnowflakeConnection connection = new SnowflakeConnection(url,username,password, new FakeWebRequester());       
            System.assert(false,'Expected an exception from bad connection string');
        }
        catch(Exception e){
            System.assert(e.getMessage().contains('you must specify'), 'Error message was not as expected');
        }
    }
    
    public static testMethod void testSnowflakeErrorParser() {
		SnowflakeErrorDetail error = SnowflakeErrorDetail.parse(SnowflakeConnectionResponseSamples.errorResponse);
        System.assertEquals(error.success, false,'Expected to get success flag');
    }

    public static testMethod void testSnowflakeSync() {
        FakeWebRequester fakeWebRequester = new FakeWebRequester();
        String url = endpoint+'?database='+database+'&schema='+schema+'&role='+role+'&warehouse='+warehouse;
        
        fakeWebRequester.queueResponse('{"masterToken":"abcde","token":"1234"}');
        
	    SnowflakeConnection connection = new SnowflakeConnection(url,username,password, fakeWebRequester);
        fakeWebRequester.queueResponse(SnowflakeConnectionResponseSamples.infoSchemaTempTableCreated);
        fakeWebRequester.queueResponse(SnowflakeConnectionResponseSamples.infoSchema);
        List<DataSource.Table> tables = connection.sync();
        System.assertEquals(tables.size(), 2,'Expected 2 tables in metadata response');
        System.assertEquals(tables.get(0).columns.size(), 8,'Expected 8 columns in first table in metadata response');
        System.assertEquals(tables.get(0).columns.get(0).description, 'DisplayUrl','Expected columns 1 in first table to have description "DisplayUrl"');
        System.assertEquals(tables.get(0).columns.get(1).description, 'TIMESTAMP','Expected columns 1 in first table to have description "TIMESTAMP"');
        System.assertEquals(tables.get(0).columns.get(2).description, 'USER_AGENT','Expected columns 1 in first table to have description "USER_AGENT"');
        System.assertEquals(tables.get(0).columns.get(3).description, 'SITE','Expected columns 1 in first table to have description "SITE"');
        System.assertEquals(tables.get(0).columns.get(4).description, 'ExternalId','Expected columns 1 in first table to have description "ExternalId"');
        System.assertEquals(tables.get(0).columns.get(5).description, 'PATH','Expected columns 1 in first table to have description "PATH"');
        System.assertEquals(tables.get(0).columns.get(6).description, 'SESSION_ID','Expected columns 1 in first table to have description "SESSION_ID"');
        System.assertEquals(tables.get(0).columns.get(7).description, 'CUSTOMER_ID','Expected columns 1 in first table to have description "CUSTOMER_ID"');
        System.assertEquals(tables.get(0).description, 'CUSTOMER_WEB_LOGS','Expected first table to have description "CUSTOMER_WEB_LOGS"');
    }
    
    public static testMethod void testSnowflakeQuery1() {
        FakeWebRequester fakeWebRequester = new FakeWebRequester();
        String url = endpoint+'?database='+database+'&schema='+schema+'&role='+role+'&warehouse='+warehouse;
        fakeWebRequester.clear();
        
        fakeWebRequester.queueResponse('{"masterToken":"abcde","token":"1234"}');
        
	    SnowflakeConnection connection = new SnowflakeConnection(url,username,password, fakeWebRequester);
	    fakeWebRequester.queueResponse(SnowflakeConnectionResponseSamples.infoSchemaTempTableCreated);
        fakeWebRequester.queueResponse(SnowflakeConnectionResponseSamples.infoSchema);
        fakeWebRequester.queueResponse(SnowflakeConnectionResponseSamples.rowCountResponse);
	    fakeWebRequester.queueResponse(SnowflakeConnectionResponseSamples.infoSchemaTempTableCreated);
        fakeWebRequester.queueResponse(SnowflakeConnectionResponseSamples.infoSchema);
        fakeWebRequester.queueResponse(SnowflakeConnectionResponseSamples.rowResponse);
        //(DataSource.QueryContext context)
        DataSource.QueryContext queryContext = new DataSource.QueryContext();
		List<DataSource.Table> metadata = new List<DataSource.Table>();
        DataSource.Column col1=new DataSource.Column();
        col1.name='CUSTOMER_ID';
        col1.type=DataSource.DataType.INDIRECT_LOOKUP_TYPE;
        DataSource.Column col2=new DataSource.Column();
        col2.name='DisplayUrl';
        col2.type=DataSource.DataType.URL_TYPE;
        DataSource.Column col3=new DataSource.Column();
        col3.name='ExternalId';
        col3.type=DataSource.DataType.STRING_SHORT_TYPE;
        DataSource.Column col4=new DataSource.Column();
        col4.name='FIRST_HIT';
        col4.type=DataSource.DataType.DATETIME_TYPE;
        DataSource.Column col5=new DataSource.Column();
        col5.name='LAST_HIT';
        col5.type=DataSource.DataType.DATETIME_TYPE;
        DataSource.Column col6=new DataSource.Column();
        col6.name='PAGE_HITS';
        col6.type=DataSource.DataType.DATETIME_TYPE;
        List<DataSource.Column> columns=new List<DataSource.Column>();
        DataSource.Table table1=new DataSource.Table();
        table1.name='CUSTOMER_WEB_SESSIONS';
        table1.nameColumn='ExternalId';
        columns.add(col1);
        columns.add(col2);
        columns.add(col3);
        columns.add(col4);
        columns.add(col5);
        columns.add(col6);
        table1.columns=columns;
        metadata.add(table1);
        queryContext.metadata=metadata;
        queryContext.offset=0;
        DataSource.TableSelection tableSelection=new DataSource.TableSelection();
        List<DataSource.ColumnSelection> columnSelection=new List<DataSource.ColumnSelection>();
		DataSource.ColumnSelection cs1=new DataSource.ColumnSelection();
        cs1.columnName='FIRST_HIT';
		cs1.tableName='CUSTOMER_WEB_SESSIONS';
		DataSource.ColumnSelection cs2=new DataSource.ColumnSelection();
        cs2.columnName='CUSTOMER_ID';
		cs2.tableName='CUSTOMER_WEB_SESSIONS';
		DataSource.ColumnSelection cs3=new DataSource.ColumnSelection();
        cs3.columnName='ExternalId';
		cs3.tableName='CUSTOMER_WEB_SESSIONS';
		DataSource.ColumnSelection cs4=new DataSource.ColumnSelection();
        cs4.columnName='LAST_HIT';
		cs4.tableName='CUSTOMER_WEB_SESSIONS';
		DataSource.ColumnSelection cs5=new DataSource.ColumnSelection();
        cs5.columnName='PAGE_HITS';
		cs5.tableName='CUSTOMER_WEB_SESSIONS';
        columnSelection.add(cs1);
        columnSelection.add(cs2);
        columnSelection.add(cs3);
        columnSelection.add(cs4);
        columnSelection.add(cs5);
        tableSelection.columnsSelected=columnSelection;
        DataSource.Filter filter = new DataSource.Filter();
        List<DataSource.Filter> subFilters = new List<DataSource.Filter>();
        DataSource.Filter subFilter = new DataSource.Filter();
        subFilter.columnName='CUSTOMER_ID';
        subFilter.columnValue=73153;
        subFilter.tableName='CUSTOMER_WEB_SESSIONS';
        subFilter.type=DataSource.FilterType.EQUALS;
        subFilters.add(subFilter);
        filter.subFilters=subFilters;
        filter.type=DataSource.FilterType.OR_;
        List<DataSource.Order> orders=new List<DataSource.Order>();
        DataSource.Order order1=new DataSource.Order();
        order1.columnName='FIRST_HIT';
        order1.direction=DataSource.OrderDirection.DESCENDING;
        order1.tableName='CUSTOMER_WEB_SESSIONS';
        DataSource.Order order2=new DataSource.Order();
        order2.columnName='ExternalId';
        order2.direction=DataSource.OrderDirection.ASCENDING;
        order2.tableName='CUSTOMER_WEB_SESSIONS';
        orders.add(order1);
        orders.add(order2);
        tableSelection.filter=filter;
        tableSelection.order=orders;
        queryContext.tableSelection=tableSelection;
        queryContext.maxResults=10;
        queryContext.offset=0;
        
        
        DataSource.TableResult result = connection.query(queryContext);
		System.assertEquals(result.rows.size(), 3,'Incorrect number of rows in response');
        System.assertEquals(result.rows.get(0).get('CUSTOMER_ID'), '73153','Expected row 1 to have CUSTOMER_ID 73153');
        System.assertEquals(result.rows.get(0).get('ExternalId'), '016513f379490014311277123bf40307100350690086e','Expected row 1 to have ExternalId 016513f379490014311277123bf40307100350690086e');
        System.assertEquals(result.rows.get(0).get('FIRST_HIT'), '2018-08-06 17:34:21','Expected row 1 to have FIRST_HIT 2018-08-06 17:34:21');
        System.assertEquals(result.rows.get(0).get('LAST_HIT'), '2018-12-10 00:29:01','Expected row 1 to have LAST_HIT 2018-12-10 00:29:01');
        System.assertEquals(result.rows.get(0).get('PAGE_HITS'), '1079','Expected row 1 to have PAGE_HITS 1079');
        
        System.assertEquals(result.rows.get(1).get('CUSTOMER_ID'), '73153','Expected row 2 to have CUSTOMER_ID 73153');
        System.assertEquals(result.rows.get(1).get('ExternalId'), '0164ed97b89b000766fe1c8bbef901077001706f00fb8','Expected row 1 to have ExternalId 0164ed97b89b000766fe1c8bbef901077001706f00fb8');
        System.assertEquals(result.rows.get(1).get('FIRST_HIT'), '2018-07-30 06:48:20','Expected row 2 to have FIRST_HIT 2018-07-30 06:48:20');
        System.assertEquals(result.rows.get(1).get('LAST_HIT'), '2018-07-30 08:08:21','Expected row 2 to have LAST_HIT 2018-07-30 08:08:21');
        System.assertEquals(result.rows.get(1).get('PAGE_HITS'), '26','Expected row 1 to have PAGE_HITS 26');
        System.assertEquals(result.success, true,'Expected success to be true');
        
        System.assertEquals(result.rows.get(2).get('CUSTOMER_ID'), '73153','Expected row 2 to have CUSTOMER_ID 73153');
        System.assertEquals(result.rows.get(2).get('ExternalId'), '0163987edcb93979387edbc9e7897097edee7e7987333','Expected row 1 to have ExternalId 0164ed97b89b000766fe1c8bbef901077001706f00fb8');
        System.assertEquals(result.rows.get(2).get('FIRST_HIT'), '2018-06-15 02:38:20','Expected row 3 to have FIRST_HIT 2018-07-30 06:48:20');
        System.assertEquals(result.rows.get(2).get('LAST_HIT'), '2018-06-15 02:45:30','Expected row 3 to have LAST_HIT 2018-07-30 08:08:21');
        System.assertEquals(result.rows.get(2).get('PAGE_HITS'), '20','Expected row 3 to have PAGE_HITS 20');
        System.assertEquals(result.success, true,'Expected success to be true');
        
        System.assertEquals(result.totalSize, 3,'Incorrect total size value');
    }
    
}