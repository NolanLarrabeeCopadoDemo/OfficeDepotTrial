@isTest
public with sharing class RouteNewCase_Test {
    @isTest
    public static void test_redirect_to_default()
    {
        List<Profile_Not_Routed_to_SCOE__mdt> profiles_not_routed_to_SCOE_mdt = [SELECT MasterLabel FROM Profile_Not_Routed_to_SCOE__mdt];
        List<String> profiles_not_routed_to_SCOE_string = new List<String>();
        
        for (Profile_Not_Routed_to_SCOE__mdt profile : profiles_not_routed_to_SCOE_mdt)
        {
            profiles_not_routed_to_SCOE_string.add(profile.MasterLabel);
        }
        
        Profile profile_not_routed_to_scoe = [SELECT Id, Name FROM Profile WHERE Name IN :profiles_not_routed_to_SCOE_string LIMIT 1];
        
        User not_routed_user = new User(
            Username            = 'not_routed_user@officedepot.com',
            FirstName           = 'Not Routed User',
            LastName            = 'Not Routed User',
            Email               = 'not_routed_user@officedepot.com',
            Alias               = 'nrusr',
            LocaleSidKey        = 'en_US',
            LanguageLocaleKey   = 'en_US',
            TimeZoneSidKey      = 'America/Los_Angeles',
            ProfileId           = profile_not_routed_to_scoe.Id
        );
        insert not_routed_user;
        
        System.runAs(not_routed_user)
        {                                                     
            RouteNewCase route_new_case      = new RouteNewCase();
            PageReference returned_reference = route_new_case.OnPageLoad();
            
            System.debug('RouteNewCase_Test: ' + profile_not_routed_to_scoe.Name);
            System.debug('RouteNewCase_Test: ' + returned_reference.getUrl());
            System.assert(returned_reference.getUrl().contains('/setup')); 
        }
    }
    
    @isTest
    public static void test_redirect_to_scoe()
    {
        List<Profile_Not_Routed_to_SCOE__mdt> profiles_not_routed_to_SCOE_mdt = [SELECT MasterLabel FROM Profile_Not_Routed_to_SCOE__mdt];
        List<String> profiles_not_routed_to_SCOE_string = new List<String>();
        
        for (Profile_Not_Routed_to_SCOE__mdt profile : profiles_not_routed_to_SCOE_mdt)
        {
            profiles_not_routed_to_SCOE_string.add(profile.MasterLabel);
        }
        
        Profile profile_routed_to_scoe = [SELECT Id, Name FROM Profile WHERE Name NOT IN :profiles_not_routed_to_SCOE_string LIMIT 1];
        
        User routed_user = new User(
            Username            = 'routed_user@officedepot.com',
            FirstName           = 'Routed User',
            LastName            = 'Routed User',
            Email               = 'routed_user@officedepot.com',
            Alias               = 'ruser',
            LocaleSidKey        = 'en_US',
            LanguageLocaleKey   = 'en_US',
            TimeZoneSidKey      = 'America/Los_Angeles',
            ProfileId           = profile_routed_to_scoe.Id
        );
        insert routed_user;
        
        System.runAs(routed_user)
        {                                                     
            RouteNewCase route_new_case      = new RouteNewCase();
            PageReference returned_reference = route_new_case.OnPageLoad();
            
            System.debug('RouteNewCase_Test: ' + profile_routed_to_scoe.Name);
            System.debug('RouteNewCase_Test: ' + returned_reference.getUrl());
            System.assert(returned_reference.getUrl().contains('/flow')); 
        }
    }
}