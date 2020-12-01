@isTest
public class WebCollectRestRequest_Test {
    public static testMethod void testPrimaryAccountToTrue() {
        executeoncetest.BypassAccountTrigger=true;
      ProspectSynchService.prospectSynchServiceRunning=true;
     String  accSiteRecId  = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Site').getRecordTypeId();
      Account acc = new Account();
      acc.Name = 'Test Account';
      acc.recordTypeId = accSiteRecId;
      acc.Primary_Site__c = false;
      acc.AOPS_Seq_ID__c  = '02581234-00001';
      acc.AOPS_Cust_ID__c = '33168058';
      insert acc;
        WebCollect__c wc=new WebCollect__c();
        wc.Name='Service Details';
        wc.GetAuthorizationEndpoint__c='test';
        wc.Username__c='test';
        wc.Password__c='test';
        wc.WebCollectServiceEndpoint__c='test';
        insert wc;
      Test.StartTest();
         Map < String, Object > mp = new Map < String, Object > ();
      	mp.put('recordId', acc.Id);
        WebCollectRestRequest.GetAccountOps(mp);
        Test.setMock(HttpCalloutMock.class, new MockHttpResponseGeneratorWebCollect());
        WebCollectRestRequest.WebCollectCallout(mp);
        Test.stopTest(); 

    }
    public static testMethod void testPrimaryAccountToTrue1() {
        executeoncetest.BypassAccountTrigger=true;
      ProspectSynchService.prospectSynchServiceRunning=true;
      String  accSiteRecId  = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Site').getRecordTypeId();
      Account acc = new Account();
      acc.Name = 'Test Account';
      acc.recordTypeId = accSiteRecId;
      acc.Primary_Site__c = false;
      acc.AOPS_Seq_ID__c  = '02581234-00001';
      acc.AOPS_Cust_ID__c = '33168058';
      insert acc;
         WebCollect__c wc=new WebCollect__c();
        wc.Name='Service Details';
        wc.GetAuthorizationEndpoint__c='test';
        wc.Username__c='test';
        wc.Password__c='test';
        wc.WebCollectServiceEndpoint__c='test';
        insert wc;
      Test.StartTest();
         Map < String, Object > mp = new Map < String, Object > ();
      	mp.put('recordId', acc.Id);
        WebCollectRestRequest.GetAccountOps(mp);
        Test.setMock(HttpCalloutMock.class, new MockHttpResponseGeneratorWebCollect.MockHttpResponseGeneratorWebCollect1());
        WebCollectRestRequest.WebCollectCallout(mp);
        Test.stopTest(); 

    }
        public static testMethod void testPrimaryAccountToTrue2() {
        executeoncetest.BypassAccountTrigger=true;
      ProspectSynchService.prospectSynchServiceRunning=true;
      String  accSiteRecId  = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Site').getRecordTypeId();
      Account acc = new Account();
      acc.Name = 'Test Account';
      acc.recordTypeId = accSiteRecId;
      acc.Primary_Site__c = false;
      acc.AOPS_Seq_ID__c  = '02581234-00001';
      acc.AOPS_Cust_ID__c = '33168058';
      insert acc;
             WebCollect__c wc=new WebCollect__c();
        wc.Name='Service Details';
        wc.GetAuthorizationEndpoint__c='test';
        wc.Username__c='test';
        wc.Password__c='test';
        wc.WebCollectServiceEndpoint__c='test';
        insert wc;
      Test.StartTest();
         Map < String, Object > mp = new Map < String, Object > ();
      	mp.put('recordId', acc.Id);
        WebCollectRestRequest.GetAccountOps(mp);
        Test.setMock(HttpCalloutMock.class, new MockHttpResponseGeneratorWebCollect.MockHttpResponseGeneratorWebCollect2());
        WebCollectRestRequest.WebCollectCallout(mp);
        Test.stopTest(); 

    }
        public static testMethod void testPrimaryAccountToTrue3() {
        // executeoncetest.BypassAccountTrigger=true;
      //ProspectSynchService.prospectSynchServiceRunning=true;
      //String  accSiteRecId  = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Site').getRecordTypeId();
      Account acc = new Account();
      acc.Name = 'Test Account';
      //acc.recordTypeId = accSiteRecId;
      // acc.Primary_Site__c = false;
      // acc.AOPS_Seq_ID__c  = '02581234-00001';
      acc.AOPS_Cust_ID__c = '33168058';
      insert acc;
             WebCollect__c wc=new WebCollect__c();
        wc.Name='Service Details';
        wc.GetAuthorizationEndpoint__c='test';
        wc.Username__c='test';
        wc.Password__c='test';
        wc.WebCollectServiceEndpoint__c='test';
        insert wc;
      Test.StartTest();
         Map < String, Object > mp = new Map < String, Object > ();
      	mp.put('recordId', acc.Id);
        WebCollectRestRequest.GetAccountOps(mp);
        Test.setMock(HttpCalloutMock.class, new MockHttpResponseGeneratorWebCollect.MockHttpResponseGeneratorWebCollect3());
        WebCollectRestRequest.WebCollectCallout(mp);
        Test.stopTest(); 

    }
  public static testMethod void testPrimaryAccountToTrue4() {
        // executeoncetest.BypassAccountTrigger=true;
      //ProspectSynchService.prospectSynchServiceRunning=true;
      //String  accSiteRecId  = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Site').getRecordTypeId();
      Account acc = new Account();
      acc.Name = 'Test Account';
      //acc.recordTypeId = accSiteRecId;
      // acc.Primary_Site__c = false;
      // acc.AOPS_Seq_ID__c  = '02581234-00001';
      acc.AOPS_Cust_ID__c = null;
      insert acc;
       WebCollect__c wc=new WebCollect__c();
        wc.Name='Service Details';
        wc.GetAuthorizationEndpoint__c='test';
        wc.Username__c='test';
        wc.Password__c='test';
        wc.WebCollectServiceEndpoint__c='test';
        insert wc;
      Test.StartTest();
         Map < String, Object > mp = new Map < String, Object > ();
      	mp.put('recordId', acc.Id);
        WebCollectRestRequest.GetAccountOps(mp);
        Test.setMock(HttpCalloutMock.class, new MockHttpResponseGeneratorWebCollect.MockHttpResponseGeneratorWebCollect3());
        WebCollectRestRequest.WebCollectCallout(mp);
        Test.stopTest(); 

    }


}