@isTest
public class CWQuoteExtension_TC {

    @isTest
    static void testQuoteExt() {
        
        Id RecordTypeIdAcct = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Tech_Zone_Customer').getRecordTypeId();
        Account testAccount = new Account();
        testAccount.Name='Test Account' ;
        testAccount.RecordTypeId = RecordTypeIdAcct;
        insert testAccount;

        Id RecordTypeIdOppt = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get('Tech_Zone').getRecordTypeId();        
        Opportunity oppt = new Opportunity(Name ='New Test Deal',
                            AccountID = testAccount.ID,
                            StageName = 'Closed Won',
                            Amount = 3000,
                            CloseDate = System.today(),
                            RecordTypeid = RecordTypeIdOppt
                            );
   		insert oppt;
        
        ApexPages.StandardController sc = new ApexPages.StandardController(oppt);
        CWQuoteExtension quoteExt = new CWQuoteExtension(sc);
        quoteExt.getIsOpptContactRoleExist();
    }
}