@isTest
public class OrderCreation_TC {
    
    public class B2BServiceMock implements HttpCalloutMock {
        final String good_authorization_response = '{"access_token": "some_big_token____.........", "token_type": "bearer"}';
        
        private Map<String, String> good_response_map = new Map<String, String>{
            '/health' => '{"status": "ok"}',
            '/api/v1/login/access-token' => good_authorization_response
        };

                
        private Map<String, Integer> status_code_mapping = new Map<String, Integer>();

        // Default
        public B2BServiceMock() {
        }

        public HTTPResponse respond(HTTPRequest request) {
            HttpResponse response = new HttpResponse();
            System.debug(LoggingLevel.INFO, request.getEndpoint());
            String endpoint = request.getEndpoint();

            response.setHeader('Content-Type', 'application/json');

                response.setStatusCode(200); 
                // Set a default status code.
                // If the endpoint ends with one of the mapped URLs, set the status code.
                for(String url_endpoint : good_response_map.keySet()) {
                    if(endpoint.contains(url_endpoint)) {
                        response.setBody(good_response_map.get(url_endpoint));
                        return response;
                    }
                }

            
            // The below code only runs if a URL mapping was not found for the response body.
            System.debug(LoggingLevel.INFO, 'Endpoint is ' + request.getEndpoint());
            response.setBody('{"error": "Resource not found"}');
            response.setStatusCode(404);
            return response;
        }
    }
    
    
    
    
    @TestSetup
    static void makeData() {
        User owner          = [SELECT Id FROM User WHERE Profile.Name = 'System Administrator' AND IsActive = true LIMIT 1];
        RecordType rtCust   = [SELECT Id FROM RecordType WHERE sObjectType = 'Account' AND Name = 'Customer'];
        RecordType rtSite   = [SELECT Id FROM RecordType WHERE sObjectType = 'Account' AND Name = 'Site'];

        Account acc             = new Account(Name='TestAcc1', OwnerId=owner.Id, RecordtypeId=rtCust.Id, Aops_Cust_Id__c='1');
        insert acc;
        Account siteAcc1        = new Account(Name='Siteacc1', OwnerId=owner.Id, RecordtypeId=rtSite.Id, related_Account__c=acc.id, Aops_Cust_Id__c='2', aops_seq_id__c='2-2');
        Account siteAcc2        = new Account(Name='Siteacc2', OwnerId=owner.Id, RecordtypeId=rtSite.Id, related_Account__c=acc.id, Aops_Cust_Id__c='3', aops_seq_id__c='3-2');
        List<Account> accounts  = new List<Account>{ siteAcc1, siteAcc2 };
        insert accounts;

        Opportunity opp = new Opportunity(Name='TestOpp1', StageName='Verbal Win', CloseDate=Date.today(), AccountId=acc.Id);
        insert opp;
        
        Id standardPBID = Test.getStandardPricebookId();
        
        Quote q1            = new Quote(Name='TestQuote1', Pricebook2Id=standardPBID, OpportunityId=opp.Id, OwnerId=owner.Id, Bill_to_account__c=siteAcc1.Id, ship_to_account__c=siteAcc2.Id, Status='Draft');
        //Quote q2          = new Quote(Name='TestQuote2', Pricebook2Id=standardPBID, OpportunityId=opp.Id, OwnerId=owner.Id, Bill_to_account__c=siteAcc1.Id, ship_to_account__c=siteAcc2.Id, Status='Draft');
        //Quote q3          = new Quote(Name='TestQuote3', Pricebook2Id=standardPBID, OpportunityId=opp.Id, OwnerId=owner.Id, Bill_to_account__c=siteAcc1.Id, ship_to_account__c=siteAcc2.Id, Status='Completed');
        //List<Quote> quotes    = new List<Quote>{ q1, q2, q3 };
        //insert quotes;
        insert q1;
        
        Product2 pro = new Product2(Name = 'iPhone X', Family = 'Mobile');
        Insert pro;
         
        //Instantiate the Pricebook2 record with StandardPricebookId
        Pricebook2 standardPricebook = new Pricebook2(
            Id = Test.getStandardPricebookId(),
            IsActive = true
        );
         
        //Execute an update DML on the Pricebook2 record, to make IsStandard to true
        Update standardPricebook;
         
        //Query for the Pricebook2 record, to check IsStandard field
        standardPricebook = [SELECT Id, IsStandard FROM Pricebook2 WHERE Id = :standardPricebook.Id];
        
        //Create the PricebookEntry
        PricebookEntry pbe = new PricebookEntry(
            Pricebook2Id = standardPricebook.Id,
            Product2Id = pro.Id,
            UnitPrice = 1020,
            IsActive = true
        );
        Insert pbe;
        
        QuoteLineItem item = new QuoteLineItem();
        item.quoteId = q1.Id;
        item.OD_Item_Number__c = '1234';
        item.Vendor_Part_Number__c = 'VP1';
        item.Description = 'Test product';
        item.Cost__c = 12;
        item.Quantity = 2;
        item.Vendor_Name__c = 'DNH';
        item.Vendor_Number__c = '123';
        item.Vendor_Quote_Number__c = 'q123';
        item.PricebookEntryId = pbe.Id;
        item.UnitPrice = 10;
        item.Product2Id = pro.Id;
        item.Shipping_Handling__c = 10;
        item.Total_Cost__c = 100;

        insert item;
        
        QuoteLineItem item2 = new QuoteLineItem();
        item2.quoteId = q1.Id;
        item2.OD_Item_Number__c = '12345';
        item2.Vendor_Part_Number__c = 'VP2';
        item2.Description = 'Test product2';
        item2.Cost__c = 12;
        item2.Quantity = 2;
        item2.Vendor_Name__c = 'DNH';
        item2.Vendor_Number__c = '8765';
        item2.Vendor_Quote_Number__c = '';
        item2.PricebookEntryId = pbe.Id;
        item2.list_price__c = 150;
        item2.UnitPrice = 120;
        item2.Product2Id = pro.Id;
        item2.Shipping_Handling__c = 10;
        item2.Total_Cost__c = 100;
        
        insert item2;
        
        QuoteLineItem item3 = new QuoteLineItem();
        item3.quoteId = q1.Id;
        item3.Item_Type__c = 'ITEM6';
        item3.Is_virtual_Warehouse_Item__c = false;
        item3.OD_Item_Number__c = '12345';
        item3.Vendor_Part_Number__c = 'VP2';
        item3.Description = 'Test product2';
        item3.Cost__c = 12;
        item3.Quantity = 2;
        item3.Vendor_Name__c = 'DNH';
        item3.Vendor_Number__c = '8765';
        item3.Vendor_Quote_Number__c = '';
        item3.PricebookEntryId = pbe.Id;
        item3.list_price__c = 150;
        item3.UnitPrice = 120;
        item3.Product2Id = pro.Id;
        item3.Shipping_Handling__c = 10;
        item3.Total_Cost__c = 100;
        
        insert item3;
        
        Vendor_Mapping__c vm1 = new Vendor_Mapping__c(Name='SYNNEX CORP', IsActive__c=true, Source_Vendor_ID__c='8765', Target_Vendor_ID__c='8765', APP_ID__c='TECHSALENC');
        Vendor_Mapping__c vm2 = new Vendor_Mapping__c(Name='TECH DATA CORP', IsActive__c=true, Source_Vendor_ID__c='3612', Target_Vendor_ID__c='994289', APP_ID__c='TECHSALENC');
        
        insert vm1;
        insert vm2;
        
        Vendor__c v1 = new Vendor__c(Active__c=true, Email__c='test@od.com', Vendor_Number__c=8765, Is_EDI_Enabled__c=true);
        Vendor__c v2 = new Vendor__c(Active__c=true, Email__c='test@od.com', Vendor_Number__c=994289, Is_EDI_Enabled__c=true);
        insert v1;
        insert v2;
    }
    
    @IsTest
    public static void runOrderCreationTest() {
        Quote q = [SELECT Id FROM Quote WHERE Name = 'TestQuote1'];
        
        Test.startTest();
        TriggerHandler.bypass('CaseMessageTriggerHandler');
        OrderCreation.QuoteOrderInfo qo = OrderCreation.getQuoteOrderInfo(q.id);
        String JSONString = JSON.serialize(qo.custOrderList);
        OrderCreation.placeOrder(JSONString, 'automatic');
        //OrderCreation.placeOrder(JSONString, 'manual');
        
        q.status = 'Customer Review Complete';
        update q;
        
        OrderCreation.getQuoteOrderInfo(q.id);
                
        TriggerHandler.clearBypass('CaseMessageTriggerHandler');
        Test.stopTest();
    }

}