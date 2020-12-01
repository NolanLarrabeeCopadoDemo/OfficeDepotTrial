@isTest
public class QuoteAppRequestEmail_TC {
    @isTest
    public static void testmethod1(){
        Account masterAccount = new Account(Name='master account'); 
        masterAccount.Sharing_Group__c = 'Master Account Share'; 
        insert masterAccount; 
        
        Recordtype custAccRT = [Select id, Sobjecttype from recordtype where name = 'Customer' and Sobjecttype = 'Account']; 
        Account account1 = new Account(Name='Test Account');
        account1.RecordTypeId = custAccRT.Id; 
        account1.ParentId = masterAccount.Id; 
        insert account1; 
        
        Contact con = new Contact(LastName='userName', AccountId = account1.Id);
        insert con; 
        
        Contact con2 = new Contact(LastName='userName2', AccountId = account1.Id);
        insert con2; 
        

        Opportunity opp1 = new Opportunity(); 
        opp1.Name = 'Test';   
        opp1.Product__c = 'Furniture - Catalog';
        opp1.StageName = 'Prospecting'; 
        opp1.CloseDate = Date.today().addDays(1);
        opp1.AccountId = account1.Id;
        opp1.Amount=10000000;
        opp1.Primary_Competitor1_DonotInUse__c = 'comp1';
        //system.debug('opp '+ opp1);
        insert opp1;
        
        CameleonCPQ__QxSetup__c  c = new CameleonCPQ__QxSetup__c(Name='Master',CameleonCPQ__QuoteModelName__c='OfficeDepot',CameleonCPQ__MappingSetName__c='New_Written_Agreement',CameleonCPQ__LinesManagementPolicy__c=1);
        insert c;

        PROS_Access_Custom_Setting__c pacs1 = new PROS_Access_Custom_Setting__c(Name='In Review_VIEW', Profiles__c='Field Sales');
        PROS_Access_Custom_Setting__c pacs2 = new PROS_Access_Custom_Setting__c(Name='Draft_VIEW', Profiles__c='Field Sales');
        insert new List<PROS_Access_Custom_Setting__c> { pacs1, pacs2 };

         Id cptRTId = Schema.SObjectType.CameleonCPQ__QxQuoteLine__c.getRecordTypeInfosByName().get('CPT').getRecordTypeId();
        
         CameleonCPQ__QxQuote__c testQuote1 = new CameleonCPQ__QxQuote__c(Name='TEST 1',CameleonCPQ__Status__c='Accepted',OpportunityId__c=opp1.id);
        insert testQuote1; 
        List<CameleonCPQ__QxQuoteLine__c> qlineList=new List<CameleonCPQ__QxQuoteLine__c>();
        CameleonCPQ__QxQuoteLine__c qline1=new CameleonCPQ__QxQuoteLine__c();
        qline1.Violation_Type__c='Compliance';
        qline1.Violation_Message__c='test';
        qline1.recordtypeId = cptRTId;
        qline1.CameleonCPQ__QuoteId__c=testQuote1.id;
        qlineList.add(qline1);
        CameleonCPQ__QxQuoteLine__c qline2=new CameleonCPQ__QxQuoteLine__c();
        qline2.Violation_Type__c='Maintenance';
        qline2.Violation_Message__c='test';
        qline2.recordtypeId = cptRTId;
        qline2.CameleonCPQ__QuoteId__c=testQuote1.id;
        qlineList.add(qline2);
        CameleonCPQ__QxQuoteLine__c qline3=new CameleonCPQ__QxQuoteLine__c();
        qline3.Violation_Type__c='Business';
        qline3.Violation_Message__c='test';
        qline3.CameleonCPQ__QuoteId__c=testQuote1.id;
        qline3.recordtypeId = cptRTId;
        qlineList.add(qline3);
            insert qlineList;
        QuoteAppRequestEmail.quoteapp(testQuote1.Id);
    }
}