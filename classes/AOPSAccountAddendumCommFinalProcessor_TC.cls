@IsTest
public class AOPSAccountAddendumCommFinalProcessor_TC {
    @isTest
    static void makeData() {
        List<AOPS_Account_Addendum_Community__c> lst = new List<AOPS_Account_Addendum_Community__c>{
          new AOPS_Account_Addendum_Community__c  (CCU043F_AECUST__c='857958585',CXTC043F_ACTION__c='C',CCU043F_AECD10__c='P',Unique_Record_ID__c='84948594'),
          new AOPS_Account_Addendum_Community__c  (CCU043F_AECUST__c='09284848',CXTC043F_ACTION__c='U',CCU043F_AECD10__c='P',Unique_Record_ID__c='2637427')};
    insert lst;
                                                   List<Account_Final_Staging__c> fnlLSt = new List<Account_Final_Staging__c>{
                                                       new Account_Final_Staging__c(AOPS_Cust_Id__c='857958585' ,Community_Postscript__c='P',Action__c='U'),
                                                      new Account_Final_Staging__c (AOPS_Cust_Id__c='09284848' ,Community_Postscript__c='P',Action__c='U')};

                                       insert     fnlLSt;
    test.startTest();
    system.enqueueJob(new AOPSAccountAddendumCommFinalProcessor(lst));
    test.stopTest();
    }
    
}