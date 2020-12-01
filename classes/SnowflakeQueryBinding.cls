public with sharing class SnowflakeQueryBinding {
    public String knownType {get;set;} 
	public String tableName {get;set;} 
	public String columnName {get;set;} 
	public String value {get;set;} 
    public SnowflakeQueryBinding(String tableName,String columnName, String value){
        this.tableName=tableName;
        this.columnName=columnName;
        this.value=value;
    }

    public SnowflakeQueryBinding(String knownType, String val){
        this.knownType=knownType;
        value=val;
    }
    
    public boolean hasKnownType(){
        return knownType!=null;
    }
}