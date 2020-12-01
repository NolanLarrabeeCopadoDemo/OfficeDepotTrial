// 
// (c) 2015 Appirio, Inc.
//
// Tier1_Extension Test Class
//
// 10 Feb 2015     Luke Slevin       Original
//
@isTest
private class Tier1_BatchTest {
    public static String CRON_EXP = '0 0 0 15 3 ? 2022';

    @isTest static void test_Tier1Batch() {
       
        String jobId = System.schedule('Tier 10 Batch',CRON_EXP,new Tier1_Batch());
        
        System.runAs(new user(ID = UserInfo.getUserID())){
        
        Profile p = [SELECT Id FROM Profile WHERE Name='Standard User']; 
        
        User u = new User(Alias = 'standt', Email='standarduserODAppirio@officedepot.com', 
            EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
            LocaleSidKey='en_US', ProfileId = p.Id, 
            TimeZoneSidKey='America/Los_Angeles', UserName='standarduserODAppirio@officedepot.com');
        
        User uNot = new User(Alias = 'standt', Email='usernotODAppirio@officedepot.com', 
            EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
            LocaleSidKey='en_US', ProfileId = p.Id, 
            TimeZoneSidKey='America/Los_Angeles', UserName='usernotODAppirio@officedepot.com');

        User uDM = new User(Alias = 'sndt', Email='dMODAppirio@officedepot.com', 
            EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
            LocaleSidKey='en_US', ProfileId = p.Id, 
            TimeZoneSidKey='America/Los_Angeles', UserName='dmODAppirio@officedepot.com');

        insert u;
        insert uNot;
        insert uDM;
        
        ID cGiD = '0F9E0000000AQrbKAG'; // Production ID
        ///ID cGiD = '0F9f0000000CwEXCA0'; // ODUAT ID
        //List<CollaborationGroup> LcGiD = New List<CollaborationGroup>([Select Id from CollaborationGroup where Name = 'Tier 1 Owners']);
           
        MAP<String, String> MapRT = New MAp<String,String>();
        For (RecordType Rt : [select Id, Name from RecordType where SobjectType in ('Account','Opportunity')] ) {
            MapRT.put(Rt.Name, RT.ID);
        }
        
        CollaborationGroupMember cgm = New CollaborationGroupMember();
            cgm.CollaborationGroupId = cGiD;
            cgm.MemberId = uNot.Id;
            cgm.NotificationFrequency = 'D';
        insert cgm;

        
        Partner__c partner = new Partner__c();
        partner.name = 'Appirio Supply, Inc.';
        partner.OwnerId = u.id;
        partner.Current_Product_Offering__c = 'All Supplies';
        partner.Exclusive_Partner__c = true;
        partner.Partner_Migration_Status__c = 'Not Ready for Migration';
        partner.Partner_Legacy_Realtionship__c = 'Office Depot South';
        partner.State__c = 'TX';
        insert partner;

        Partner__c partner2 = new Partner__c();
        partner2.name = 'Appirio Industries, Inc.';
        partner2.OwnerId = u.id;
        partner2.Partner_Migration_Status__c = 'Ready for Migration';
        partner2.Diversity_Manager__c = uDM.id;
        insert partner2;

        Account acc = new Account();
        acc.Name = 'Test Tier 1 Account';
        acc.RecordTypeID = MapRT.get('Customer');
        acc.OwnerId = u.Id;
        acc.MTD_Sales_TY__c = 12;
        acc.MTD_Sales_TY_IMU__c = 62;
        acc.MTD_Sales_LY__c = 12;
        acc.MTD_Sales_LY_IMU__c = 42;
        acc.QTD_Sales_TY__c = 12;
        acc.QTD_Sales_TY_IMU__c = 12;
        acc.QTD_Sales_LY__c = 22;
        acc.QTD_Sales_LY_IMU__c = 12;
        acc.YTD_Sales_TY__c = 42;
        acc.YTD_Sales_TY_IMU__c =112;
        acc.YTD_Sales_LY__c = 12;
        acc.YTD_Sales_LY_IMU__c = 12;
        acc.Paper_LY__c = 12;
        acc.Paper_TY__c = 12;
        acc.Ink_Toner_LY__c = 42;
        acc.Ink_Toner_TY__c = 12;
        acc.Furniture_LY__c = 12;
        acc.Furniture_TY__c = 12;
        acc.CBS_LY__c = 77;
        acc.CBS_TY__c =332;
        acc.CPD_TY__c = 32;
        acc.CPD_LY__c = 12;
        acc.Tech_LY__c =12;
        acc.Tech_TY__c =52;
        acc.Filing_Binding_LY__c =12;
        acc.Filing_Binding_TY__c =12;
        acc.Labels_Forms_LY__c =21;
        acc.Labels_Forms_TY__c = 112;
        acc.Writing_Drafting_LY__c = 112;
        acc.Writing_Drafting_TY__c =34;
        acc.Office_Essentials_LY__c = 42;
        acc.Office_Essentials_TY__c = 76;
        acc.MPS_LY__c = 92;
        acc.MPS_TY__c =212;
        acc.Miscellaneous_LY__c =212;
        acc.Miscellaneous_TY__c =612;
        acc.Tier_1_Partner__c = partner.Id;
        insert acc;
        Test.startTest();
        Account acc2 = new Account();
        acc2.Name = 'Test Tier 1 Account';
        acc2.RecordTypeID =  MapRT.get('Customer');
        acc2.OwnerId = u.Id;
        acc2.MTD_Sales_TY__c = 12;
        acc2.MTD_Sales_TY_IMU__c = 62;
        acc2.MTD_Sales_LY__c = 12;
        acc2.MTD_Sales_LY_IMU__c = 42;
        acc2.QTD_Sales_TY__c = 12;
        acc2.QTD_Sales_TY_IMU__c = 12;
        acc2.QTD_Sales_LY__c = 22;
        acc2.QTD_Sales_LY_IMU__c = 12;
        acc2.YTD_Sales_TY__c = 42;
        acc2.YTD_Sales_TY_IMU__c =112;
        acc2.YTD_Sales_LY__c = 12;
        acc2.YTD_Sales_LY_IMU__c = 12;
        acc2.Paper_LY__c = 12;
        acc2.Paper_TY__c = 12;
        acc2.Ink_Toner_LY__c = 42;
        acc2.Ink_Toner_TY__c = 12;
        acc2.Furniture_LY__c = 12;
        acc2.Furniture_TY__c = 12;
        acc2.CBS_LY__c = 77;
        acc2.CBS_TY__c =332;
        acc2.CPD_TY__c = 32;
        acc2.CPD_LY__c = 12;
        acc2.Tech_LY__c =12;
        acc2.Tech_TY__c =52;
        acc2.Filing_Binding_LY__c =12;
        acc2.Filing_Binding_TY__c =12;
        acc2.Labels_Forms_LY__c =21;
        acc2.Labels_Forms_TY__c = 112;
        acc2.Writing_Drafting_LY__c = 112;
        acc2.Writing_Drafting_TY__c =34;
        acc2.Office_Essentials_LY__c = 42;
        acc2.Office_Essentials_TY__c = 76;
        acc2.MPS_LY__c = 92;
        acc2.MPS_TY__c =212;
        acc2.Miscellaneous_LY__c =212;
        acc2.Miscellaneous_TY__c =612;
        acc2.Tier_1_Partner__c = partner.Id;
        insert acc2;
        
        Account acc3 = new Account();
        acc3.Name = 'Test Tier 1 Account';
        acc3.RecordTypeID = MapRT.get('Customer (OfficeMax)');
        acc3.OwnerId = uNot.Id;
        Insert acc3;        
             
        
        Customer_Transition__c ct1 = new Customer_Transition__c();
        ct1.Name = 'Customer Transition of Acc2';
        ct1.Account__c = acc2.id;
        ct1.Partner_Migration_Readiness__c = null;
        ct1.Diversity_Manager__c = null; 
        ct1.Diversity_Partner__c = null;
        insert ct1;
        
        Customer_Transition__c ct2 = new Customer_Transition__c();
        ct2.Name = 'Customer Transition of Acc3';
        ct2.Account__c = acc2.id;
        ct2.Partner_Migration_Readiness__c = null;
        ct2.Diversity_Manager__c = null; 
        ct2.Diversity_Partner__c = null;
        insert ct2;
        
        Customer_Transition__c ct3 = new Customer_Transition__c();
        ct3.Name = 'Customer Transition of Acc3';
        ct3.Account__c = acc3.id;
        ct3.Partner_Migration_Readiness__c = 'Remove';
        ct3.Diversity_Manager__c = u.id; 
        ct3.Diversity_Partner__c = null;
        insert ct3;
        
        Opportunity opp = new Opportunity();
        opp.Name = 'Test Tier 1 Opportunity ';
        opp.RecordTypeID =  MapRT.get('Field Sales (US)');
        opp.OwnerId = u.Id;
        opp.Amount = 6500;
        opp.StageName = '1%-Qualifying Prospect';
        opp.CloseDate = Date.ValueOf(system.today().addDays(30));
        opp.AccountId = acc.ID;
        insert opp;
        
        Tier_1_Certificates__c tc1 = new Tier_1_Certificates__c();
        tc1.Ceritificate_Scope__c = 'National';
        tc1.Certificate__c = 'CAMSC';
        tc1.Tier_1_Partner__c = partner.Id;
        insert tc1;

        Tier_1_Certificates__c tc2 = new Tier_1_Certificates__c();
        tc2.Ceritificate_Scope__c = 'Regional';
        tc2.Certificate__c = 'HUBZone';
        tc2.Tier_1_Partner__c = partner2.Id;
        insert tc2;
        
        
        }
    
            Tier1_Batch tb = new Tier1_Batch();
            database.executeBatch(tb);
        Test.stopTest();

    }
}