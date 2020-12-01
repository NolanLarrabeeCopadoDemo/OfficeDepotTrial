@IsTest
private class VendorsController_TC {

    @TestSetup
    static void makeData() {
        
        User owner 			= [SELECT Id FROM User WHERE Profile.Name = 'System Administrator' AND IsActive = true LIMIT 1];
        RecordType rtCust 	= [SELECT Id FROM RecordType WHERE sObjectType = 'Account' AND Name = 'Customer'];
		RecordType rtSite 	= [SELECT Id FROM RecordType WHERE sObjectType = 'Account' AND Name = 'Site'];

        Account acc 			= new Account(Name='TestAcc1', OwnerId=owner.Id, RecordtypeId=rtCust.Id, Aops_Cust_Id__c='1');
		insert acc;
        Account siteAcc1 		= new Account(Name='Siteacc1', OwnerId=owner.Id, RecordtypeId=rtSite.Id, related_Account__c=acc.id, Aops_Cust_Id__c='2', aops_seq_id__c='2-2');
		Account siteAcc2 		= new Account(Name='Siteacc2', OwnerId=owner.Id, RecordtypeId=rtSite.Id, related_Account__c=acc.id, Aops_Cust_Id__c='3', aops_seq_id__c='3-2');
		List<Account> accounts 	= new List<Account>{ siteAcc1, siteAcc2 };
		insert accounts;

        Opportunity opp = new Opportunity(Name='TestOpp1', StageName='Propose', CloseDate=Date.today(), AccountId=acc.Id);
        insert opp;
        
		Id standardPBID = Test.getStandardPricebookId();
        
		Quote q1 			= new Quote(Name='TestQuote1', Pricebook2Id=standardPBID, OpportunityId=opp.Id, OwnerId=owner.Id, Bill_to_account__c=siteAcc1.Id, ship_to_account__c=siteAcc2.Id, Status='Draft');
        //Quote q2 			= new Quote(Name='TestQuote2', Pricebook2Id=standardPBID, OpportunityId=opp.Id, OwnerId=owner.Id, Bill_to_account__c=siteAcc1.Id, ship_to_account__c=siteAcc2.Id, Status='Draft');
        //Quote q3 			= new Quote(Name='TestQuote3', Pricebook2Id=standardPBID, OpportunityId=opp.Id, OwnerId=owner.Id, Bill_to_account__c=siteAcc1.Id, ship_to_account__c=siteAcc2.Id, Status='Completed');
		//List<Quote> quotes 	= new List<Quote>{ q1, q2, q3 };
		//insert quotes;
		insert q1;
        //Create List of Vendors
        Vendor__c v1 = new Vendor__c (Vendor_Number__c = decimal.valueOf('123456'), Name = 'VendorTest1', Rep_Comment__c = 'Test1', Email__c = 'test@test.com', Active__c = true, OwnerId = owner.Id);
        Vendor__c v2 = new Vendor__c (Vendor_Number__c = decimal.valueOf('456789'), Name = 'VendorTest2', Rep_Comment__c = 'Test2', Email__c = 'test@test.com', Active__c = true, OwnerId = owner.Id);
        List<Vendor__c> vs = new List<Vendor__c>();
        vs.add(v1);
        vs.add(v2);
        insert vs;
    }

     @IsTest
    public static void testInsertVendorCase(){
        Quote q = [SELECT Id FROM Quote WHERE Name = 'TestQuote1'];
        String qid = String.valueOf(q.id);
        String comm = 'This is a test comment';
        Vendor__c v1 = [Select id, name, Rep_Comment__c from Vendor__c WHERE name = 'VendorTest1'];
        Vendor__c v2 =  [Select id, name, Rep_Comment__c from Vendor__c WHERE name = 'VendorTest2'];
        List<String> vs = new List<String>();
        List<Map<String, Object>> vss = new List<Map<String, Object>>();
        Map<String,Object> m = new Map<String,Object>();
        m.put('Id', String.valueof(v1.id));
        m.put('Id', String.valueof(v2.id));
        m.put('Comment', v1.Rep_Comment__c);
        m.put('Comment', v2.Rep_Comment__c);
        //vs.add(String.valueof(v1.id));
        //vs.add(String.valueof(v2.id));
        //vs.add(String.valueof(v1.Rep_Comment__c));
        //vs.add(String.valueof(v2.Rep_Comment__c));
        vss.add(m);
        Test.startTest();
        VendorsController.VendorCaseCreate(qid,vss,comm);
        
        VendorsController.getVendorList(qid);
        
        Test.stopTest();
    } 
}