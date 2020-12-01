@isTest
public class OMXMod2Status_TC
{
    static testMethod void testMehod1()
    {
        DateTime dt = System.today();
        string AopsId = '12345';
        Account acc = new Account();
        acc.AOPS_Cust_Id__c = '12345';
        acc.name = 'TestAccount';
        insert acc;
        
        Customer_transition__C cust = new Customer_transition__C();
        cust.Account__c = acc.id;
        insert cust;
        OMXMod2Status omxModObj = new OMXMod2Status();
        OMXMod2Status.getMod2Status('12345','1233',null,'C','C','True','N','N','N');
   
   Datetime dt1=System.now();     
   
   List<AOPS_Flag__c > recList= new List<AOPS_Flag__c > ();
   
    AOPS_Flag__c rec1 = new AOPS_Flag__c();
   rec1.AopsId__c='12345';
   rec1.AopsSeqId__c=null;
   rec1.CSLSetUpFlag__c='C';
   rec1.DBStamp__c='2016-11-09T10:45:07.094992';
   rec1.DNSFlag__c='N';
   rec1.OrderSetUpFlag__c='C';
   rec1.ReadyToOrderFlag__c='N';
   rec1.RedirectFlag__c='N';
   rec1.UserSetUpFlag__c='C';
   rec1.AOPS_DB_TimeStamp__C =dt1;
   rec1.DBStampMillisec__C='094992';
   recList.add(rec1);

   
   AOPS_Flag__c rec = new AOPS_Flag__c();
   rec.AopsId__c='12345';
   rec.AopsSeqId__c=null;
   rec.CSLSetUpFlag__c='W';
   rec.DBStamp__c='2016-11-09T10:45:06.368064';
   rec.DNSFlag__c='N';
   rec.OrderSetUpFlag__c='W';
   rec.ReadyToOrderFlag__c='N';
   rec.RedirectFlag__c='N';
   rec.UserSetUpFlag__c='C';
   rec.AOPS_DB_TimeStamp__C =dt1;
   rec.DBStampMillisec__C='368064';
   recList.add(rec);
   
   
   insert recList;


Test.starttest();

        Account acc1 = new Account();
        acc1.AOPS_Cust_Id__c = '123456';
        acc1.name = 'TestAccount';
        insert acc1;
        
        Customer_transition__C cust1 = new Customer_transition__C();
        cust1.Account__c = acc1.id;
        cust1.B2B_MOD_2_Date__c=System.today();
        insert cust1;
   
   Datetime dt2=System.now();     
   
   
    AOPS_Flag__c rec2 = new AOPS_Flag__c();
   rec2.AopsId__c='123456';
   rec2.AopsSeqId__c=null;
   rec2.CSLSetUpFlag__c='C';
   rec2.DBStamp__c='2016-11-09T10:45:07.094992';
   rec2.DNSFlag__c='N';
   rec2.OrderSetUpFlag__c='P';
   rec2.ReadyToOrderFlag__c='N';
   rec2.RedirectFlag__c='N';
   rec2.UserSetUpFlag__c='C';
   rec2.AOPS_DB_TimeStamp__C =dt2;
   rec2.DBStampMillisec__C='094992';
insert rec2;


CustTransParentChildLevel__c PCLevel2 = new CustTransParentChildLevel__c ();
PCLevel2.AOPSFlagInterval__C =100;
PCLevel2.name='Test';
insert PCLevel2;


        UpdateAOPSFlag SentAOPSObj = new UpdateAOPSFlag();
        database.executebatch(SentAOPSObj , 99);


test.stoptest();
        
        

        //OMXMod2Status.getMod2Status('12345','1233',dt.format('yyyy-mm-dd\'T\'hh:mm:ss'),'C','C','True','N','N','N');
    }
}