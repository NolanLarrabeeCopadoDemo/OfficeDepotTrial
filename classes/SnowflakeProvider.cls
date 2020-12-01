global with sharing class SnowflakeProvider extends DataSource.Provider{
    
    override global List<DataSource.AuthenticationCapability> getAuthenticationCapabilities() {
        System.debug('--- SnowflakeProvider getAuthenticationCapabilities start');
        List<DataSource.AuthenticationCapability> capabilities = new List<DataSource.AuthenticationCapability>();
        //capabilities.add(DataSource.AuthenticationCapability.ANONYMOUS);
        //capabilities.add(DataSource.AuthenticationCapability.OAUTH);
        capabilities.add(DataSource.AuthenticationCapability.BASIC);
        System.debug('--- SnowflakeProvider getAuthenticationCapabilities end');
        return capabilities;
    }
    
    override global List<DataSource.Capability> getCapabilities() {
        System.debug('--- SnowflakeProvider getCapabilities start');
        List<DataSource.Capability> capabilities =  new List<DataSource.Capability>();
        capabilities.add(DataSource.Capability.QUERY_PAGINATION_SERVER_DRIVEN);
        capabilities.add(DataSource.Capability.QUERY_TOTAL_SIZE);
        capabilities.add(DataSource.Capability.REQUIRE_ENDPOINT);
        capabilities.add(DataSource.Capability.REQUIRE_HTTPS);
        //capabilities.add(DataSource.Capability.ROW_CREATE);
        //capabilities.add(DataSource.Capability.ROW_DELETE);
        capabilities.add(DataSource.Capability.ROW_QUERY);
        //capabilities.add(DataSource.Capability.ROW_UPDATE);
        //capabilities.add(DataSource.Capability.SEARCH);
        System.debug('--- SnowflakeProvider getCapabilities end');
        return capabilities;
    }
    
    
    override global DataSource.Connection getConnection(DataSource.ConnectionParams connectionParams) {
        System.debug('--- SnowflakeProvider getConnection start');
        return new SnowflakeConnection(connectionParams);
    }
    
}