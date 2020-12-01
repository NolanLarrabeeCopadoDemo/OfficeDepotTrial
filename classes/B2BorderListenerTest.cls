@isTest
public class B2BorderListenerTest {
    @isTest
    public static void testRestService() {
         RecordType rtCust   = [SELECT Id FROM RecordType WHERE sObjectType = 'Account' AND Name = 'Customer'];
        RecordType rtSite   = [SELECT Id FROM RecordType WHERE sObjectType = 'Account' AND Name = 'Site'];
        
        Account acc = new Account();
        acc.Name='Test Acc';
        acc.RecordtypeId=rtCust.Id;
        insert acc;
        Account siteAcc1     = new Account(Name='Siteacc1', RecordtypeId=rtSite.Id, related_Account__c=acc.id);
        Account siteAcc2     = new Account(Name='Siteacc2', RecordtypeId=rtSite.Id, related_Account__c=acc.id);
        List<Account> accounts   = new List<Account>{ siteAcc1, siteAcc2 };
            insert accounts;
        
        Opportunity opp = new Opportunity();
        opp.AccountId = acc.Id;
        opp.name = 'testOpp';
        opp.status__c = 'open';
        opp.stagename = 'Qualify';
        opp.CloseDate = System.today().adddays(100);
        insert opp;
        
        Quote q=new Quote(Name = 'TestQ');
        q.name = 'testQ';
        q.OpportunityId= opp.Id;
        q.Quote_Id__c = '112233';
        q.Bill_To_Account__c = siteAcc1.Id;
        q.ship_to_account__c=siteAcc2.Id;
        insert q;
        
        contact c = new contact(lastname='giltest',firstName='lortes',Email='lor.gil@tesss.com',Phone='7521489632');
        c.Override_Duplicate_Check__c = true;
        c.accountId = acc.Id;
        insert c;
        
        SiteContacts__c sc = new SiteContacts__c();
        sc.Account__c = acc.Id;
        sc.Contact__c = c.Id;
        insert sc;
        
        Order_Header__c r = new Order_Header__c() ;
        r.Quote_ID__c = q.id;
        r.Salesforce_Quote_ID__c = '124kkk';
        r.Vendor_Account_Number__c = 'lk7455';
        insert r; 
                test.startTest();

        String myJson = '{ "ODPurchaseOrder" : { "@timeStamp" : "2020-02-14 00:53:06.476", "@documentid" : "'+r.Id+'", "Header" : { "CustomerID" : "33168058" }, "Response" : { "Status" : { "Code" : "00", "Description" : "success" }, "OrderReference" : { "PONumber" : "SFDC_TEST" }, "Detail" : [ { "Totals" : { "SubTotal" : "300.0", "Tax" : { "*body" : "21.0" }, "Delivery" : "0.0", "Misc" : "0.0", "Total" : "321.0" }, "OrderDetails" : { "OrderNumber" : "413601575", "OrderSub" : "001", "OrderStatus" : "Held, Sent to Item Server", "OrderDate" : "02/14/2020", "DeliveryDate" : "02/21/2020" } } ] } } }';
        RestRequest request = new RestRequest();
        RestResponse response = new RestResponse();
        request.requestUri ='https://officedepot--oduat.lightning.force.com/webhook/services/apexrest/B2BMessages/';
        request.httpMethod = 'POST';
        request.addHeader('Content-Type', 'application/json'); 
        request.requestBody = Blob.valueof(myJson);
        RestContext.request = request;
        RestContext.response=response;

        B2BOrderListener.getOrderStatus();
        test.stopTest();
    }
        
}