@isTest
public with sharing class TypeMappingsTest {
	public static testMethod void testSnowflakeBindTypeFromSalesforceType() {
        System.assertEquals('REAL', TypeMappings.getSnowflakeBindTypeFromSalesforceType(DataSource.DataType.NUMBER_TYPE), 'Number type should map to REAL');
        System.assertEquals('VARIANT', TypeMappings.getSnowflakeBindTypeFromSalesforceType(DataSource.DataType.DATETIME_TYPE), 'Datetime type should map to VARIANT');
        System.assertEquals('BOOLEAN', TypeMappings.getSnowflakeBindTypeFromSalesforceType(DataSource.DataType.BOOLEAN_TYPE), 'Boolean type should map to BOOLEAN');
        System.assertEquals(null,TypeMappings.getSnowflakeBindTypeFromSalesforceType(DataSource.DataType.EXTERNAL_LOOKUP_TYPE), 'EXTERNAL_LOOKUP_TYPE should map to null');
        System.assertEquals(null,TypeMappings.getSnowflakeBindTypeFromSalesforceType(DataSource.DataType.INDIRECT_LOOKUP_TYPE), 'INDIRECT_LOOKUP_TYPE should map to null');
        System.assertEquals(null,TypeMappings.getSnowflakeBindTypeFromSalesforceType(DataSource.DataType.LOOKUP_TYPE), 'LOOKUP_TYPE should map to null');
    }
}