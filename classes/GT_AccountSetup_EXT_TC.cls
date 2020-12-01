@isTest
private class GT_AccountSetup_EXT_TC 
{

    static testMethod void myUnitTest() 
    {
    
    Schema.DescribeSobjectResult ar = Schema.SobjectType.Account;
    Map<String,schema.RecordtypeInfo> AccRecType = ar.getRecordTypeInfosByName();
    Id customerRecId = AccRecType.get('Customer').getRecordTypeId();
    Id siteRecId=AccRecType.get('Site').getRecordTypeId();
    
    User u1 = GT_TestDataUtility.getTestUser('System Administrator','abc@officedepot.com.uat','6122071234');
	System.runas(new user(ID = UserInfo.getUserID())){    
    Account acc1 = GT_TestDataUtility.getTestAccount(u1,'123654');

    acc1.RecordtypeId = customerRecId;
    upsert acc1;
    
    Contact c1 = new Contact();
    c1.LastName='LastNametest';
    c1.email='testemail@test.com';
    c1.AccountId = acc1.id;
    c1.firstname='first';
    c1.OMX_primary_key__c='1234';
    c1.title = 'Manager';
    c1.Primary_Contact__c = true;
    
    insert c1;

    Account acc2 = new Account();
    acc2.RecordtypeId = siteRecId;
    acc2.AOPS_Seq_ID__c = '6583-0087';
    acc2.OMX_Primary_Key__c='271991';
    acc2.Site_Primary_Contact__c = c1.id;
    acc2.Site_Contact2__c = c1.id;
    acc2.Site_Contact3__c = c1.id;
    acc2.Site_Contact4__c = c1.id;
    acc2.Site_Contact5__c = c1.id;
    acc2.Site_Contact6__c = c1.id;
    acc2.Related_Account__c = acc1.id;
    acc2.Name=acc1.Name;
    insert acc2;

    opportunity opp = new Opportunity();
    opp.accountid =  acc1.id;
    opp.Name = acc1.Name;
    opp.product__c = 'tech';
    opp.StageName = '90%-Execute';
    opp.CloseDate = System.today().addDays(1);
    insert opp;

    Admin_Config__c ad= new Admin_Config__c();
    ad.name ='Default';
    ad.Tech_Depot_Title__c = 'TSR';
    ad.Tech_Depot_Auto_Assign_Opp__c =true;
    ad.Tech_Depot_User__c ='salesforce';
    ad.BatchSize__c ='100';
    insert ad;

    AccountTeamMember atm = new AccountTeamMember();
    atm.UserId = u1.Id;
    atm.AccountId = acc1.Id;
    insert atm; 
    
    List<UserPass__c> uplist = new list<UserPass__c>();
    UserPass__c up = new UserPass__c();
    up.name='credentials1';
    up.Username__c='test1';
    up.Password__c='pass2';
    up.EndpointURL__c='https://www.test.com'; 
    uplist.add(up);
    insert uplist;
    
    Test.setCurrentPage(Page.GT_AccountSetup);
    ApexPages.currentPage().getParameters().put('oppId', opp.id);
    
    GT_AccountSetup_EXT gta1 = new GT_AccountSetup_EXT();
    GT_AccountSetup_EXT.masterSetupVar = '1';
    gta1.conditionalSetupVar = '2Y';
        
    GT_AccountSetup_EXT gta2 = new GT_AccountSetup_EXT();
    gta2.conditionalSetupVar = '2N';
        
    GT_AccountSetup_EXT gta3 = new GT_AccountSetup_EXT();
    gta3.conditionalSetupVar = '2Y';
    
    Test.startTest();
    Test.setMock(HttpCalloutMock.class, new FakeCalloutMock());
    gta1.basicAuthCallout();
    gta2.basicAuthCallout();
    GT_AccountSetup_EXT.masterSetupVar = '3';
   gta3.basicAuthCallout();
    GT_AccountSetup_EXT.masterSetupVar = '4';
    gta3.basicAuthCallout();
    Test.stopTest();
    }
    }
    
}