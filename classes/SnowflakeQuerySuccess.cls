//
// Generated by JSON2Apex http://json2apex.herokuapp.com/
//

public with sharing class SnowflakeQuerySuccess {

	public Boolean success;

	
	public static SnowflakeQuerySuccess parse(String json) {
		system.System.debug('json to parse'+ json);
	

		
		return (SnowflakeQuerySuccess) System.JSON.deserialize(json, SnowflakeQuerySuccess.class);
	}
}