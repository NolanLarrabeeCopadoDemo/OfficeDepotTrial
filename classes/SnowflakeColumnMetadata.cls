public with sharing class SnowflakeColumnMetadata {
    
    public String tableName{get;set;} 
    public String columnName{get;set;} 
    public String dataType{get;set;} 
    public Integer characterMaxLength{get;set;} 
    public Integer numericPrecision{get;set;} 
    public Integer numericScale{get;set;} 
    public Integer dateTimePrecision{get;set;} 
    
    public static SnowflakeColumnMetadata fromInformationSchemaQuery(List<String> row){
        System.debug('--- SnowflakeColumnMetadata fromInformationSchemaQuery ---' );

      //  custlog__c x = new custlog__c();
	//	x.baddata__c = '0: '+ row.get(0) + ' 1: '+ row.get(1)+ ' 2: '+ row.get(2)+ ' 3: '+ row.get(3)+ ' 4: '+ row.get(4)+ ' 5: '+ row.get(5)+ ' 6: '+ row.get(6)+ ' 7: '+ row.get(7)+ ' 8: '+ row.get(8) +' 9: '+ row.get(9) ;
    //	insert x;
    

        SnowflakeColumnMetadata newObject=new SnowflakeColumnMetadata();
        newObject.tableName = row.get(2);
        newObject.columnName = row.get(3);
        newObject.dataType = row.get(4);
        newObject.characterMaxLength = Integer.valueOf(row.get(6));
        newObject.numericPrecision = Integer.valueOf(row.get(7));
        newObject.numericScale = Integer.valueOf(row.get(8));
       
            newObject.dateTimePrecision = Integer.valueOf(row.get(9));
        
        return newObject;
    }
}