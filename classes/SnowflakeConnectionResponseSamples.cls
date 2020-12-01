@isTest
public with sharing class SnowflakeConnectionResponseSamples {
    
    private static String standardParameters='[{"name":"TIMESTAMP_OUTPUT_FORMAT","value":"YYYY-MM-DD HH24:MI:SS.FF3 TZHTZM"},'+
                                       '{"name":"CLIENT_SESSION_CLONE","value":false},'+
                                       '{"name":"CLIENT_TIMESTAMP_TYPE_MAPPING","value":"TIMESTAMP_LTZ"},'+
                                       '{"name":"CLIENT_TELEMETRY_ENABLED","value":true},'+
                                       '{"name":"CLIENT_RESULT_PREFETCH_SLOTS","value":2},'+
                                       '{"name":"CLIENT_DISABLE_INCIDENTS","value":false},'+
                                       '{"name":"DATE_OUTPUT_FORMAT","value":"YYYY-MM-DD"},'+
                                       '{"name":"CLIENT_SESSION_KEEP_ALIVE_HEARTBEAT_FREQUENCY","value":3600},'+
                                       '{"name":"BINARY_OUTPUT_FORMAT","value":"HEX"},'+
                                       '{"name":"TIMESTAMP_NTZ_OUTPUT_FORMAT","value":"YYYY-MM-DD HH24:MI:SS.FF3"},'+
                                       '{"name":"CLIENT_MEMORY_LIMIT","value":1536},'+
                                       '{"name":"CLIENT_METADATA_REQUEST_USE_CONNECTION_CTX","value":false},'+
                                       '{"name":"CLIENT_PREFETCH_THREADS","value":4},'+
                                       '{"name":"AUTOCOMMIT","value":true},'+
                                       '{"name":"TIMESTAMP_LTZ_OUTPUT_FORMAT","value":""},'+
                                       '{"name":"CLIENT_STAGE_ARRAY_BINDING_THRESHOLD","value":65280},'+
                                       '{"name":"CLIENT_CONSENT_CACHE_ID_TOKEN","value":false},'+
                                       '{"name":"CLIENT_HONOR_CLIENT_TZ_FOR_TIMESTAMP_NTZ","value":true},'+
                                       '{"name":"CLIENT_SESSION_KEEP_ALIVE","value":false},'+
                                       '{"name":"CLIENT_RESULT_CHUNK_SIZE","value":160},'+
                                       '{"name":"CLIENT_RESULT_PREFETCH_THREADS","value":1},'+
                                       '{"name":"CLIENT_RESULT_COLUMN_CASE_INSENSITIVE","value":false},'+
                                       '{"name":"CLIENT_USE_V1_QUERY_API","value":true},'+
                                       '{"name":"TIMESTAMP_TZ_OUTPUT_FORMAT","value":""},'+
                                       '{"name":"TIMEZONE","value":"Australia/Sydney"},'+
                                       '{"name":"TIME_OUTPUT_FORMAT","value":"HH24:MI:SS"} ]';
    
	public static String infoSchemaTempTableCreated='{'+
        '     "data" : {'+
        '     "parameters" : '+standardParameters+','+
        '     "rowtype" : [{"name":"status","database":"","schema":"","table":"","type":"text","scale":null,"byteLength":16777216,"nullable":true,"precision":null,"length":16777216} ],'+
        '     "rowset" : [["Table SFDC_COLS_IN_SCHEMA successfully created."] ],'+
        '     "total" : 1,'+
        '     "returned" : 1,'+
        '     "queryId" : "529f2dba-68a9-47a3-997b-eeffe536335f",'+
        '     "databaseProvider" : null,'+
        '     "finalDatabaseName" : null,'+
        '     "finalSchemaName" : null,'+
        '     "finalWarehouseName" : "DATA_UPLOAD",'+
        '     "finalRoleName" : "SYSADMIN",'+
        '     "numberOfBinds" : 0,'+
        '     "arrayBindSupported" : false,'+
        '     "statementTypeId" : 24849,'+
        '     "version" : 1,'+
        '     "sendResultTime" : 1546591117287'+
        '   },'+
        '   "message" : null,'+
        '   "code" : null,'+
        '   "success" : true'+
        '}';
    
    
	public static String errorResponse='{'+
        '     "data" : {'+
        '     "internalError" : true,'+
        '     "errorCode" : "abcd",'+
        '     "age" : 50,'+
        '     "sqlState" : "RUINED",'+
        '     "queryId" : "abcd1234",'+
        '     "line" : 5,'+
        '     "pos" : 30,'+
        '     "type" : "BAD_ONE"'+
        '   },'+
        '   "message" : "SYNTAX ERROR IN WHAT YOU GAVE ME",'+
        '   "code" : "abcd1234",'+
        '   "success" : false'+
        '}';

    public static String infoSchema='{'+
        '     "data" : {'+
        '     "parameters" : '+standardParameters+','+
			'"rowtype" : [{"name":"TABLE_CATALOG","database":"","schema":"","table":"","scale":null,"byteLength":16777216,"length":16777216,"type":"text","nullable":true,"precision":null},'+
				'{"name":"TABLE_SCHEMA","database":"","schema":"","table":"","scale":null,"byteLength":16777216,"length":16777216,"type":"text","nullable":true,"precision":null},'+
				'{"name":"TABLE_NAME","database":"NIBAU_DEV","schema":"PUBLIC","table":"SFDC_COLS_IN_SCHEMA","scale":null,"byteLength":16777216,"length":16777216,"type":"text","nullable":true,"precision":null},'+
				'{"name":"COLUMN_NAME","database":"NIBAU_DEV","schema":"PUBLIC","table":"SFDC_COLS_IN_SCHEMA","scale":null,"byteLength":16777216,"length":16777216,"type":"text","nullable":true,"precision":null},'+
				'{"name":"DATA_TYPE","database":"NIBAU_DEV","schema":"PUBLIC","table":"SFDC_COLS_IN_SCHEMA","scale":null,"byteLength":16777216,"length":16777216,"type":"text","nullable":true,"precision":null},'+
				'{"name":"IS_NULLABLE","database":"","schema":"","table":"","scale":null,"byteLength":12,"length":3,"type":"text","nullable":true,"precision":null},'+
				'{"name":"CHARACTER_MAXIMUM_LENGTH","database":"NIBAU_DEV","schema":"PUBLIC","table":"SFDC_COLS_IN_SCHEMA","scale":null,"byteLength":16777216,"length":16777216,"type":"text","nullable":true,"precision":null},'+
				'{"name":"NUMERIC_PRECISION","database":"NIBAU_DEV","schema":"PUBLIC","table":"SFDC_COLS_IN_SCHEMA","scale":null,"byteLength":16777216,"length":16777216,"type":"text","nullable":true,"precision":null},'+
				'{"name":"NUMERIC_SCALE","database":"NIBAU_DEV","schema":"PUBLIC","table":"SFDC_COLS_IN_SCHEMA","scale":null,"byteLength":16777216,"length":16777216,"type":"text","nullable":true,"precision":null},'+
				'{"name":"DATETIME_PRECISION","database":"NIBAU_DEV","schema":"PUBLIC","table":"SFDC_SFDC_COLS_IN_SCHEMA","scale":null,"byteLength":16777216,"length":16777216,"type":"text","nullable":true,"precision":null} ],'+
			'"rowset" : [["NIBAU_DEV","PUBLIC","CUSTOMER_WEB_LOGS","TIMESTAMP","TIMESTAMP_NTZ","YES","0","0","0","9"],'+
			'   ["NIBAU_DEV","PUBLIC","CUSTOMER_WEB_LOGS","USER_AGENT","TEXT","YES","1000","0","0","0"],'+
			'   ["NIBAU_DEV","PUBLIC","CUSTOMER_WEB_LOGS","SITE","TEXT","YES","255","0","0","0"],'+
			'   ["NIBAU_DEV","PUBLIC","CUSTOMER_WEB_LOGS","ExternalId","TEXT","YES","255","0","0","0"],'+
			'   ["NIBAU_DEV","PUBLIC","CUSTOMER_WEB_LOGS","PATH","TEXT","YES","1000","0","0","0"],'+
			'   ["NIBAU_DEV","PUBLIC","CUSTOMER_WEB_LOGS","SESSION_ID","TEXT","YES","255","0","0","0"],'+
			'   ["NIBAU_DEV","PUBLIC","CUSTOMER_WEB_LOGS","CUSTOMER_ID","NUMBER","YES","0","38","0","0"],'+
			'   ["NIBAU_DEV","PUBLIC","CUSTOMER_WEB_SESSIONS","ExternalId","TEXT","YES","255","0","0","0"],'+
			'   ["NIBAU_DEV","PUBLIC","CUSTOMER_WEB_SESSIONS","FIRST_HIT","TIMESTAMP_NTZ","YES","0","0","0","9"],'+
			'   ["NIBAU_DEV","PUBLIC","CUSTOMER_WEB_SESSIONS","PAGE_HITS","NUMBER","YES","0","18","0","0"],'+
			'   ["NIBAU_DEV","PUBLIC","CUSTOMER_WEB_SESSIONS","CUSTOMER_ID","NUMBER","YES","0","38","0","0"],'+
			'   ["NIBAU_DEV","PUBLIC","CUSTOMER_WEB_SESSIONS","LAST_HIT","TIMESTAMP_NTZ","YES","0","0","0","9"] ],'+
		'     "total" : 12,'+
		'     "returned" : 12,'+
        '     "queryId" : "529f2dba-68a9-47a3-997b-eeffe536335f",'+
        '     "databaseProvider" : null,'+
        '     "finalDatabaseName" : null,'+
        '     "finalSchemaName" : null,'+
        '     "finalWarehouseName" : "DATA_UPLOAD",'+
        '     "finalRoleName" : "SYSADMIN",'+
        '     "numberOfBinds" : 0,'+
        '     "arrayBindSupported" : false,'+
        '     "statementTypeId" : 24849,'+
        '     "version" : 1,'+
        '     "sendResultTime" : 1546591117287'+
        '   },'+
        '   "message" : null,'+
        '   "code" : null,'+
        '   "success" : true'+
        '}';
    
    
    public static String dataTypeResponse='{'+
        '     "data" : {'+
        '     "parameters" : '+standardParameters+','+
			'"rowtype" : [{"name":"DATA_TYPE","database":"NIBAU_DEV","schema":"INFORMATION_SCHEMA","table":"COLUMNS","type":"text","scale":null,"byteLength":16777216,"nullable":true,"precision":null,"length":16777216} ],'+
			'"rowset" : [["NUMBER"] ],'+
		'     "total" : 1,'+
		'     "returned" : 1,'+
        '     "queryId" : "529f2dba-68a9-47a3-997b-eeffe536335f",'+
        '     "databaseProvider" : null,'+
        '     "finalDatabaseName" : null,'+
        '     "finalSchemaName" : null,'+
        '     "finalWarehouseName" : "DATA_UPLOAD",'+
        '     "finalRoleName" : "SYSADMIN",'+
        '     "numberOfBinds" : 0,'+
        '     "arrayBindSupported" : false,'+
        '     "statementTypeId" : 24849,'+
        '     "version" : 1,'+
        '     "sendResultTime" : 1546591117287'+
        '   },'+
        '   "message" : null,'+
        '   "code" : null,'+
        '   "success" : true'+
        '}';
    
    public static String rowCountResponse='{'+
        '     "data" : {'+
        '     "parameters" : '+standardParameters+','+
			'"rowtype" : [{"name":"ROWCOUNT","database":"","schema":"","table":"","type":"fixed","scale":0,"byteLength":null,"nullable":false,"precision":18,"length":null} ],'+
			'"rowset" : [["1"] ],'+
		'     "total" : 1,'+
		'     "returned" : 1,'+
        '     "queryId" : "529f2dba-68a9-47a3-997b-eeffe536335f",'+
        '     "databaseProvider" : null,'+
        '     "finalDatabaseName" : null,'+
        '     "finalSchemaName" : null,'+
        '     "finalWarehouseName" : "DATA_UPLOAD",'+
        '     "finalRoleName" : "SYSADMIN",'+
        '     "numberOfBinds" : 0,'+
        '     "arrayBindSupported" : false,'+
        '     "statementTypeId" : 24849,'+
        '     "version" : 1,'+
        '     "sendResultTime" : 1546591117287'+
        '   },'+
        '   "message" : null,'+
        '   "code" : null,'+
        '   "success" : true'+
        '}';
    
    
    public static String rowResponse='{'+
        '     "data" : {'+
        '     "parameters" : '+standardParameters+','+
		'	  "rowtype" : [{"name":"TO_VARCHAR(CONVERT_TIMEZONE(\'UTC\',\\"FIRST_HIT\\"), \'YYYY-MM-DD HH:MI:SS\')","database":"","schema":"","table":"","type":"text","scale":null,"byteLength":16777216,"nullable":true,"precision":null,"length":16777216},{"name":"CUSTOMER_ID","database":"NIBAU_DEV","schema":"PUBLIC","table":"CUSTOMER_WEB_SESSIONS","type":"fixed","scale":0,"byteLength":null,"nullable":true,"precision":38,"length":null},{"name":"ExternalId","database":"NIBAU_DEV","schema":"PUBLIC","table":"CUSTOMER_WEB_SESSIONS","type":"text","scale":null,"byteLength":1020,"nullable":true,"precision":null,"length":255},{"name":"TO_VARCHAR(CONVERT_TIMEZONE(\'UTC\',\\"LAST_HIT\\"), \'YYYY-MM-DD HH:MI:SS\')","database":"","schema":"","table":"","type":"text","scale":null,"byteLength":16777216,"nullable":true,"precision":null,"length":16777216},{"name":"PAGE_HITS","database":"NIBAU_DEV","schema":"PUBLIC","table":"CUSTOMER_WEB_SESSIONS","type":"fixed","scale":0,"byteLength":null,"nullable":true,"precision":18,"length":null} ],'+
		'     "rowset" : [["2018-08-06 17:34:21","73153","016513f379490014311277123bf40307100350690086e","2018-12-10 00:29:01","1079"],'+
        				'["2018-07-30 06:48:20","73153","0164ed97b89b000766fe1c8bbef901077001706f00fb8","2018-07-30 08:08:21","26"],'+
        				'["2018-06-15 02:38:20","73153","0163987edcb93979387edbc9e7897097edee7e7987333","2018-06-15 02:45:30","20"] ],'+
		'     "total" : 3,'+
		'     "returned" : 3,'+
        '     "queryId" : "529f2dba-68a9-47a3-997b-eeffe536335f",'+
        '     "databaseProvider" : null,'+
        '     "finalDatabaseName" : null,'+
        '     "finalSchemaName" : null,'+
        '     "finalWarehouseName" : "DATA_UPLOAD",'+
        '     "finalRoleName" : "SYSADMIN",'+
        '     "numberOfBinds" : 0,'+
        '     "arrayBindSupported" : false,'+
        '     "statementTypeId" : 24849,'+
        '     "version" : 1,'+
        '     "sendResultTime" : 1546591117287'+
        '   },'+
        '   "message" : null,'+
        '   "code" : null,'+
        '   "success" : true'+
        '}';
    
    
}