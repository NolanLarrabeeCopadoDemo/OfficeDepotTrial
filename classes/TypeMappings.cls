public with sharing class TypeMappings {
    
    public static String getSnowflakeBindTypeFromSalesforceType(DataSource.DataType type){
        switch on type {
            when NUMBER_TYPE{
                return 'REAL';
            }
            when DATETIME_TYPE{
                return 'VARIANT';
            }
            when BOOLEAN_TYPE{
                return 'BOOLEAN';
            }
            when EXTERNAL_LOOKUP_TYPE{
                return null;
            }
            when INDIRECT_LOOKUP_TYPE{
                return null;
            }
            when LOOKUP_TYPE{
                return null;
            }
            when else {
                return 'TEXT';
            }
        }
    }
    
    public static String snowflakeBindingFromSnowflakeType(String dataType){
        switch on dataType {
            when 'BOOLEAN'{
                return 'BOOLEAN';              
            }
            when 'NUMBER'{
                return 'REAL';              
            }
            when 'DATE'{
                return 'VARIANT';              
            }
            when 'TIME'{
                return 'VARIANT';              
            }
            when 'TIMESTAMP_NTZ'{
                return 'VARIANT';              
            }
            when 'TIMESTAMP_LTZ'{
                return 'VARIANT';              
            }
            when else {
                return 'TEXT';
            }
        }
    }
    
    
    public static DataSource.Column buildSalesforceColumnFromSnowflakeRowset(String columnName, String dataType, 
            Integer characterMaxLength, Integer numericPrecision, Integer numericScale, Integer dateTimePrecision) {
        
        //Cache.Session.put('snowflake.tables.'+rowset.get(2)+'.bindtypes_added', 'true');
        if (columnName=='ExternalId'){
                //Cache.Session.put('snowflake.tables.'+rowset.get(2)+'.columns.'+columnName+'.bindtype', 'TEXT');
                return DataSource.Column.text(columnName, 255);
        }
        switch on dataType {
            when 'NUMBER'{
                //Cache.Session.put('snowflake.tables.'+rowset.get(2)+'.columns.'+columnName+'.bindtype', 'REAL');
                // numeric precision has maximum of 18, if it's greater than this then make it a string
                if (numericPrecision > 18){
                    return DataSource.Column.text(columnName, numericPrecision+1);
                }else{
                    return DataSource.Column.number(columnName, numericPrecision, numericScale);
                }                
            }
            when 'BOOLEAN'{
                //Cache.Session.put('snowflake.tables.'+rowset.get(2)+'.columns.'+columnName+'.bindtype', 'BOOLEAN');
                return DataSource.Column.boolean(columnName);
            }
            when 'DATE'{
                //Cache.Session.put('snowflake.tables.'+rowset.get(2)+'.columns.'+columnName+'.bindtype', 'VARIANT');
                return DataSource.Column.get(columnName, columnName, columnName, true, true, DataSource.DataType.DATETIME_TYPE, dateTimePrecision);
            }
            when 'TIME'{
                //Cache.Session.put('snowflake.tables.'+rowset.get(2)+'.columns.'+columnName+'.bindtype', 'VARIANT');
                return DataSource.Column.get(columnName, columnName, columnName, true, true, DataSource.DataType.DATETIME_TYPE, dateTimePrecision);
            }
            when 'TIMESTAMP_NTZ'{
                //Cache.Session.put('snowflake.tables.'+rowset.get(2)+'.columns.'+columnName+'.bindtype', 'VARIANT');
                return DataSource.Column.get(columnName, columnName, columnName, true, true, DataSource.DataType.DATETIME_TYPE, dateTimePrecision);
            }
            when 'TIMESTAMP_LTZ'{
                //Cache.Session.put('snowflake.tables.'+rowset.get(2)+'.columns.'+columnName+'.bindtype', 'VARIANT');
                return DataSource.Column.get(columnName, columnName, columnName, true, true, DataSource.DataType.DATETIME_TYPE, dateTimePrecision);
            }
            when else {       // default block, optional
                //Cache.Session.put('snowflake.tables.'+rowset.get(2)+'.columns.'+columnName+'.bindtype', 'TEXT');
                return DataSource.Column.text(columnName, characterMaxLength);
            }
        }
    }
}