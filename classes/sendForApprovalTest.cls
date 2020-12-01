@isTest
public class sendForApprovalTest {
    
    private static void testData(){
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
        
        //Content Distribution data
        
        QuoteDocument qdoc = New QuoteDocument();
        qdoc.Document = Blob.toPdf('Test Document'); 
        qdoc.QuoteId = q.Id;
        system.debug('qdoc.QuoteId ---> ' + qdoc.QuoteId);
        insert qdoc;
        
        ContentVersion contentVersion = new ContentVersion(
            Title = 'Test Content',
            PathOnClient = 'TestContent.jpg',
            VersionData = Blob.valueOf('Test Content')
        );
        insert contentVersion;    
        
        List<ContentDocument> documents = [SELECT Id FROM ContentDocument];
        
        //create ContentDocumentLink  record 
        ContentDocumentLink cdl = New ContentDocumentLink();
        cdl.LinkedEntityId = acc.id;
        cdl.ContentDocumentId = documents[0].Id;
        cdl.shareType = 'V';
        insert cdl;
        
        ContentDistribution myPublicContent = new ContentDistribution();
        myPublicContent.ContentVersionId = contentVersion.Id;
        myPublicContent.Name = 'My_Test_Doc';
        myPublicContent.PreferencesAllowOriginalDownload = false;
        myPublicContent.PreferencesAllowPDFDownload = false;
        myPublicContent.PreferencesAllowViewInBrowser = true;
        insert myPublicContent;
    }
    
    @isTest
    private static void getContactsTest(){
        testData();
        List<Quote> quotes = [Select Id from Quote];
        sendForApproval.getContacts(quotes[0].Id);
    }
    
    @isTest
    private static void getDocumentsTest(){
        testData();
        QuoteDocument q = [Select ID from QuoteDocument LIMIT 1];
        sendForApproval.getDocuments(q.Id);
    }
    
    @isTest
    private static void sendEmailTest(){
        testData();
        Quote q = [Select Id from Quote where Name = 'TestQ' LIMIT 1];
        ContentDistribution cd = [Select Id, contentversionid from ContentDistribution LIMIT 1];
        Contact c = [Select Id from Contact LIMIT 1];
        sendForApproval.sendEmail(c.Id, q.Id, cd.contentversionid);
    }
    
    
    @isTest
    private static void searchForContactsTest(){
        testData();
        Quote q = [Select Id from Quote where Name = 'TestQ' LIMIT 1];  
        sendForApproval.searchForContacts('lortes','giltest','lor.gil@tesss.com','7521489632',String.valueOf(q.Id));
    }
    
    @isTest
    private static void savecontactTest(){
        testData();
        Quote q = [Select Id,AccountId from Quote where Name = 'TestQ' LIMIT 1];
        system.debug('q  ----> ' + q);
        sendForApproval.savecontact('TestFirstName','TestLastName','test@gmail.com','9856321470',String.valueOf(q.Id));
        Contact c= [select id,AccountId from contact where lastname='TestLastName' limit 1];
        sendForApproval.saveSitecon(c.Id,q.AccountId);
        
    }
}