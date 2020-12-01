@isTest
public with sharing class SnowflakeProviderTest {
        
    public static testMethod void invokeAll() {
        // the provider class is just flags, no point proper testing
        SnowflakeProvider provider = new SnowflakeProvider();
        
        provider.getCapabilities();
        System.assertEquals(1, provider.getAuthenticationCapabilities().size());
    }   
}