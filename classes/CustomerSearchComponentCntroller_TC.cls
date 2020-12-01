@isTest
public class CustomerSearchComponentCntroller_TC {
    private static testMethod void MyunitTest() { 
        string acc;
        Account testAccount = new Account();
        testAccount.Name='test' ;
        testAccount.Account_Type__c='Prospect';
        testAccount.Country__c='USA';
        testAccount.State__c='LA';
        insert testAccount;
        Profile p4 = [SELECT Id FROM profile WHERE name = 'GT - Field Sales' limit 1];
        User u1 = new User(alias = 'test123 ', email='proxy@proxy456.officedepot.com',OD_Employee_ID__c='123886',emailencodingkey='UTF-8', lastname='test123',languagelocalekey='en_US',localesidkey='en_US', profileid = p4.Id,timezonesidkey='America/Los_Angeles',username='proxy@7895.com',isactive=true);
        insert u1;
        Lead leads=new Lead();
        leads.LastName='Test name';
        leads.FirstName='Test name2';
        leads.Status='Open';
        leads.Company='Test Company';
        insert leads;
        CustomerSearchComponentCntroller.validateLeadData(leads.Id);
        system.runAs(u1){
            CustomerSearchComponentCntroller.validateLeadData(leads.Id);
            CustomerSearchComponentCntroller.getStateList(acc,testAccount.Country__c, testAccount.State__c, testAccount.Country__c);
            CustomerSearchComponentCntroller.ValidateRequiredFields(leads.Id);
            
        }
    }
 
    private static testMethod void MyunitTest2(){
        Lead leads=new Lead();
        leads.LastName='Test name';
        leads.FirstName='Test name2';
        leads.Status='Open';
        leads.Company='Test Company';
        leads.RecordTypeId='012E000000093HIIAY';
        leads.Country__c='USA';
        leads.State__c='LA';
        insert leads;
        
        Id bizBoxId = Schema.SObjectType.Lead.getRecordTypeInfosByName().get('Lead (BizBox)').getRecordTypeId();
        Id techZoneId = Schema.SObjectType.Lead.getRecordTypeInfosByName().get('Lead (Tech-Zone)').getRecordTypeId();
        Id canadaId = Schema.SObjectType.Lead.getRecordTypeInfosByName().get('Lead (Canada)').getRecordTypeId();
        Id businessProId = Schema.SObjectType.Lead.getRecordTypeInfosByName().get('Lead (Business Pro)').getRecordTypeId();
        Id dealsId = Schema.SObjectType.Lead.getRecordTypeInfosByName().get('Lead (Deals)').getRecordTypeId();
        
        Lead ld2 = new Lead(LastName='ld2', Company='ld2', Zip__c='12345', RecordTypeId=bizBoxId);
        Lead ld3 = new Lead(LastName='ld3', Company='ld3', Zip__c='12345', RecordTypeId=techZoneId);
        Lead ld4 = new Lead(LastName='ld4', Company='ld4', Zip__c='12345', RecordTypeId=canadaId);
        Lead ld5 = new Lead(LastName='ld5', Company='ld5', Zip__c='12345', RecordTypeId=businessProId);
        Lead ld6 = new Lead(LastName='ld6', Company='ld6', Zip__c='12345', RecordTypeId=dealsId);
        
        CustomerSearchComponentCntroller.validateLeadData(leads.Id);
        CustomerSearchComponentCntroller.getAccountInstance(leads.Id);
        CustomerSearchComponentCntroller.getAccountInstance(ld2.Id);
        CustomerSearchComponentCntroller.getAccountInstance(ld3.Id);
        CustomerSearchComponentCntroller.getAccountInstance(ld4.Id);
        CustomerSearchComponentCntroller.getAccountInstance(ld5.Id);
        CustomerSearchComponentCntroller.getAccountInstance(ld6.Id);
    }
    
    private static testMethod void MyunitTest3(){
        Map<String, String> responseMapping = new Map<String, String>();
        responseMapping.put('/lookup/search/account/', '[{"test": "test"}]');
        Map<String, Integer> statusCodeMapping = new Map<String, Integer>();
        statusCodeMapping.put('/lookup/search/account/', 200);
        Test.setMock(HttpCalloutMock.class, new AggroService_Mock(responseMapping, statusCodeMapping));
        
        Test.startTest(); 
        CustomerSearchComponentCntroller.searchCustInformation('{"Sales_PersonID__c":"a0A1k000000dUNjEAM","Country__c":"USA","Status__c":"Active","RecordTypeId":"012E00000008dTbIAI","State__c":"C","Name":"PUBLIC SAFETY, COLORADO DEPARTMENT OF","Address1__c":"15075 S GOLDEN RD","Zip__c":"80401","City__c":"Golden","Location_Decision_Making__c":"Yes","Type":"Prospect","Website":null,"Sector__c":"Private","Org_WCW_Count_Rep__c":"0","Segment__c":"Medium $75K-$150K","Est_Spend__c":"17","Buying_Group__c":"Buying Groups Medium $75K-$150K","Payment_Term__c":"Credit Card","Pricing_template_cd__c":"Arthur J Gallagher Risk Mgmt","Primary_Product__c":"Furniture","Industry_OD_SIC_Rep__c":"Engineering/Architecture/Consulting"}');
		//CustomerSearchComponentCntroller.searchCustInformation('');
        Test.stopTest();
    }
    
    private static testMethod void MyunitTest4(){
        Map<String, String> responseMapping = new Map<String, String>();
        responseMapping.put('/lookup/search/dnb/', '[{"duns_no": "1234"}]');
        Map<String, Integer> statusCodeMapping = new Map<String, Integer>();
        statusCodeMapping.put('/lookup/search/dnb/', 200);
        Test.setMock(HttpCalloutMock.class, new AggroService_Mock(responseMapping, statusCodeMapping));
        
        Test.startTest(); 
        //CustomerSearchComponentCntroller.searchDNBInformation('{"Sales_PersonID__c":"a0A1k000000dUNjEAM","Country__c":"USA","Status__c":"Active","RecordTypeId":"012E00000008dTbIAI","State__c":"C","Name":"PUBLIC SAFETY, COLORADO DEPARTMENT OF","Address1__c":"15075 S GOLDEN RD","Zip__c":"80401","City__c":"Golden","Location_Decision_Making__c":"Yes","Type":"Prospect","Website":null,"Sector__c":"Private","Org_WCW_Count_Rep__c":"0","Segment__c":"Medium $75K-$150K","Est_Spend__c":"17","Buying_Group__c":"Buying Groups Medium $75K-$150K","Payment_Term__c":"Credit Card","Pricing_template_cd__c":"Arthur J Gallagher Risk Mgmt","Primary_Product__c":"Furniture","Industry_OD_SIC_Rep__c":"Engineering/Architecture/Consulting"}');
		//CustomerSearchComponentCntroller.searchDNBInformation('');
        Test.stopTest();
    }
    
    private static testMethod void MyunitTest5() {
        Map<String, String> responseMapping = new Map<String, String>();
        responseMapping.put('/lookup/search/account/', '[{"test": "test"}]');
        Map<String, Integer> statusCodeMapping = new Map<String, Integer>();
        statusCodeMapping.put('/lookup/search/account/', 200);
        Test.setMock(HttpCalloutMock.class, new AggroService_Mock(responseMapping, statusCodeMapping));
        
        Lead ld = new Lead(LastName='ld', Company='ld', Zip__c='12345');
        insert ld;
        
        Test.startTest(); 
        //CustomerSearchComponentCntroller.searchCustInformationWithLeadId(ld.Id);
        //CustomerSearchComponentCntroller.searchCustInformationWithLeadId('');
		Test.stopTest();
    }
    
    private static testMethod void MyunitTest6() {
        Map<String, String> responseMapping = new Map<String, String>();
        responseMapping.put('/lookup/search/dnb/', '[{"test": "test"}]');
        Map<String, Integer> statusCodeMapping = new Map<String, Integer>();
        statusCodeMapping.put('/lookup/search/dnb/', 200);
        Test.setMock(HttpCalloutMock.class, new AggroService_Mock(responseMapping, statusCodeMapping));
        
        Lead ld = new Lead(LastName='ld', Company='ld', Zip__c='12345');
        insert ld;
        
        Test.startTest(); 
        //CustomerSearchComponentCntroller.searchDNBInformationWithLeadId(ld.Id);
        //CustomerSearchComponentCntroller.searchDNBInformationWithLeadId('');
		Test.stopTest();
    }
    
    @testsetup static void setupdata(){
        /*
        Address_Search__c obj = new Address_Search__c();
        obj.name ='URL';
        obj.EndPointUrl__c = 'https://api.avention.com/api/v1/company/match?api_key=aa0a9e7c-b8f4-4cb1-95a4-e1545bf06e45';
        insert obj;
        */
        
        Address_Search__c obj = new Address_Search__c();
        obj.name ='URL';
        obj.EndPointUrl__c = 'https://api.avention.com/api/v1/company/match?api_key=aa0a9e7c-b8f4-4cb1-95a4-e1545bf06e45';
        insert obj;
        
        DNB_API_Setting__c DnBSettings = new DNB_API_Setting__c();
        DnBSettings.AuthAPI__c='https://plus.dnb.com/v2/token';
        DnBSettings.ConsumerKey__c='WvXVeWOMmt7L6IAaXUEVe0Oo4I8bZ0Ao';
        DnBSettings.ConsumerSecret__c='GLuu1GbZo4KvXxAG';
        DnBSettings.Timestamp__c = '2019-12-19 08:48:28';
        DnBSettings.SearchAPI__c='https://plus.dnb.com/v1/search/criteria';
        DnBSettings.Name='DNB API Value';
        INSERT DnBSettings;
    }

}