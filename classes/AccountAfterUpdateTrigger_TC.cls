@isTest(SeeAllData=true)
public class AccountAfterUpdateTrigger_TC {
  
    public static testmethod void AccountAfterUpdate()
    {
        Org__c OG = new Org__c();
        OG.Business_Name__c = 'Test';
        insert OG;
        
        Account acc= Test_Utils.CreateAccount('Prospect');
        acc.Org__c= OG.Id;
        insert acc;
        
        DML__C DL = new DML__C();
        DL.DECISION_MAKER_ID__c = '2345';
        DL.Effective_Start_Date__c=system.today()+4;
        insert DL;
        
        DML_Relation__c DR = new DML_Relation__c();
        DR.CUSTOMERID__c = '1230045';
        DR.DECISIONMAKERID__c ='2345';
        //DR.Effective_End_Date__c=system.today();
        DR.Effective_Start_Date__c=system.today()+8;
        DR.Account__c = acc.id;
        insert DR;
        
        acc.AOPS_Cust_Id__c='123456';
        update acc;
        
        Account acc2= new Account(name='Test',related_account__C=acc.Id,IsProspectLightning__C=true);
        insert acc2;
    }

}