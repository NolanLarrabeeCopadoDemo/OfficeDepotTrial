@IsTest
public class AOPSAccountBSDAddendumFinalProcessor_tc{
    @IsTest
    static  void testProcess() {
        List<AOPS_Account_BSD_Addendum__c> lst = new List<AOPS_Account_BSD_Addendum__c> ();
        List<Account_Final_Staging__c> finalStagingRecs = new List<Account_Final_Staging__c>();
        List<Account_Final_Staging__c> failedStageRecList = new List<Account_Final_Staging__c>();
        AOPS_Account_BSD_Addendum__c a = new AOPS_Account_BSD_Addendum__c();
        a.Unique_Record_ID__c = '12345' ;
        a.CCU007F_CUSTOMER_ID__c ='5364558';
        a.CXTC007F_ACTION__c ='C';
        a.CCU007F_FREIGHT_CHG_REQ_FLAG__c ='N';
        a.CCU007F_DEPT_REQUIRED_CODE__c='N';
        a.CCU007F_LOCATION_REQ_CODE__c='N';
        a.CCU007F_PO_REQUIRED_CODE__c ='Y';
        a.CCU007F_RELEASE_REQUIRED_CODE__c ='N';
        a.CCU007F_FILLER__c='RP';
        a.CXTC007F_TIMESTAMP__c ='2020-07-09-10.13.12.954464';
        a.CCU007F_FORMS_FLAG__c ='N';
        a.CCU007F_ORDER_LIMIT__c='1234567';
        lst.add(a);

        AOPS_Account_BSD_Addendum__c ab = new AOPS_Account_BSD_Addendum__c();
        ab.Unique_Record_ID__c = '98765' ;
        ab.CCU007F_CUSTOMER_ID__c ='9859595';
        ab.CXTC007F_ACTION__c ='C';
        ab.CCU007F_FREIGHT_CHG_REQ_FLAG__c ='N';
        ab.CCU007F_DEPT_REQUIRED_CODE__c='N';
        ab.CCU007F_LOCATION_REQ_CODE__c='N';
        ab.CCU007F_PO_REQUIRED_CODE__c ='Y';
        ab.CCU007F_RELEASE_REQUIRED_CODE__c ='N';
        ab.CCU007F_FILLER__c='RP';
        ab.CXTC007F_TIMESTAMP__c ='2020-07-09-10.13.12.954464';
        ab.CCU007F_FORMS_FLAG__c ='Y';
        ab.CCU007F_ORDER_LIMIT__c='987654';

        ab.CXTC007F_ACTION__c='D';
        ab.Record_Updated__c=true ;
        lst.add(ab);
        insert lst;
        Test.startTest();
   
        System.enqueueJob(new AOPSAccountBSDAddendumFinalProcessor(lst));
        Test.stopTest();
    }
}