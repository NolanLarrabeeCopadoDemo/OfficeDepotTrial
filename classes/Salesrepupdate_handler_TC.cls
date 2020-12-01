@istest
public class Salesrepupdate_handler_TC 
{
    @TestSetup
    private static void init(){
        CameleonCPQ__QxSetup__c  c = new CameleonCPQ__QxSetup__c(Name='Master',CameleonCPQ__QuoteModelName__c='OfficeDepot',CameleonCPQ__MappingSetName__c='New_Written_Agreement',CameleonCPQ__LinesManagementPolicy__c=1);
        insert c;
        
        PROS_Access_Custom_Setting__c pacs1 = new PROS_Access_Custom_Setting__c(Name='In Review_VIEW', Profiles__c='Field Sales');
        PROS_Access_Custom_Setting__c pacs2 = new PROS_Access_Custom_Setting__c(Name='Draft_VIEW', Profiles__c='Field Sales');
        insert new List<PROS_Access_Custom_Setting__c> { pacs1, pacs2 };

        Account acc= Test_Utils.CreateAccount('Prospect');
        acc.AOPS_Cust_Id__c = '213213';
        insert acc;
        
        Account acc1= Test_Utils.CreateAccount('GrandParent');
        acc1.AOPS_Cust_Id__c = '21321312';
        insert acc1;
        
        Opportunity opp = new Opportunity(); 
            opp.Name = 'Test';             
            opp.StageName = 'Prospecting'; 
            opp.CloseDate = Date.today().addDays(1); 
            //opp.Partner_Sub_Agent_Account__c = acc.Id;
            opp.accountId=acc.Id;
       insert opp;

        CameleonCPQ__QxQuote__c Cp = new CameleonCPQ__QxQuote__c();
        Cp.name='Testing sales'; 
        Cp.CameleonCPQ__AccountId__c=acc.id;
        Cp.Grandparent__c= acc1.id;
        Cp.Sales_Rep__c=acc.ownerId;
        Cp.Customer_Approval_Status__c='Requested to be Contacted';
        cp.OpportunityId__c= opp.id;
        insert Cp;

    }
    public static testmethod void Salesrepupdate1()
    {
        
        List<CameleonCPQ__QxQuote__c> lst = [Select id, CameleonCPQ__AccountId__c, Sales_Rep__c, Customer_Approval_Status__c, OpportunityId__c from CameleonCPQ__QxQuote__c LIMIT 10];
        Test.StartTest();
            Salesrepupdate_handler.AccOwner(lst);
        Test.StopTest();
        
        //System.assertEquals(); 
    }
    public static testmethod void Salesrepupdate1m()
    {
        
        List<CameleonCPQ__QxQuote__c> lst = [Select id, CameleonCPQ__AccountId__c, Sales_Rep__c, Customer_Approval_Status__c, OpportunityId__c from CameleonCPQ__QxQuote__c LIMIT 10];
        lst[0].CameleonCPQ__AccountId__c = null;
        update lst;
        Test.StartTest();
            Salesrepupdate_handler.AccOwner(lst);
        Test.StopTest();
        
        //System.assertEquals(); 
    }
    
    public static testmethod void Salesrepopp()
    {
        List<CameleonCPQ__QxQuote__c> lst = [Select id, CameleonCPQ__AccountId__c, Sales_Rep__c, Customer_Approval_Status__c, OpportunityId__c from CameleonCPQ__QxQuote__c LIMIT 10];
        Map<ID, CameleonCPQ__QxQuote__c> m = new Map<ID, CameleonCPQ__QxQuote__c>([Select id, CameleonCPQ__AccountId__c, Sales_Rep__c, Customer_Approval_Status__c, OpportunityId__c from CameleonCPQ__QxQuote__c LIMIT 10]);
            
        Test.StartTest();
            Salesrepupdate_handler.Taskfrrep(lst,m);
        Test.StopTest();
    }

    public static testmethod void Salesrepupdate2()
    {
        
        List<CameleonCPQ__QxQuote__c> lst = [Select id,Quote_Number__c,Great_Grandparent__c,Name, Parent__c,Parent__r.Name,Parent__r.AOPS_Cust_Id__c, CameleonCPQ__AccountId__r.AOPS_Cust_Id__c,CameleonCPQ__AccountId__r.Name,OwnerId,CameleonCPQ__AccountId__c, Sales_Rep__c, Customer_Approval_Status__c, OpportunityId__c from CameleonCPQ__QxQuote__c LIMIT 10];
        Test.StartTest();
            Salesrepupdate_handler.createSCOEParent(lst);
        Test.StopTest();
        
        //System.assertEquals(); createSCOEGrandParent
    }
    public static testmethod void Salesrepupdate4()
    {
        
        List<CameleonCPQ__QxQuote__c> lst = [Select id,Quote_Number__c,Name,Great_Grandparent__c,Great_Grandparent__r.Name,Great_Grandparent__r.AOPS_Cust_Id__c,CameleonCPQ__AccountId__r.AOPS_Cust_Id__c,CameleonCPQ__AccountId__r.Name, OwnerId,CameleonCPQ__AccountId__c, Sales_Rep__c, Customer_Approval_Status__c, OpportunityId__c from CameleonCPQ__QxQuote__c  LIMIT 10];
        Test.StartTest();
            Salesrepupdate_handler.createSCOEGreatGrandParent(lst);
        Test.StopTest();
        
        //System.assertEquals(); 
    }
    public static testmethod void Salesrepupdate5()
    {
        
        List<CameleonCPQ__QxQuote__c> lst = [Select id,Quote_Number__c,Name,Great_Grandparent__c,Great_Grandparent__r.Name,Grandparent__r.Name,Great_Grandparent__r.AOPS_Cust_Id__c,Grandparent__r.AOPS_Cust_Id__c,CameleonCPQ__AccountId__r.AOPS_Cust_Id__c,CameleonCPQ__AccountId__r.Name, OwnerId,CameleonCPQ__AccountId__c, Sales_Rep__c, Customer_Approval_Status__c, OpportunityId__c from CameleonCPQ__QxQuote__c  LIMIT 10];
        Test.StartTest();
            Salesrepupdate_handler.createSCOEGrandParent(lst);
            //Salesrepupdate_handler.approvalProcessPros();
        Test.StopTest();
        
        //System.assertEquals(); 
    }
    

}