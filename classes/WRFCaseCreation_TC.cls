/**
 * This class contains unit tests for validating the behaviour of Apex classes
 * and triggers.
 *
 * Unit tests are class methods that verify whether a particular piece
 * of code is working properly. Unit test methods take no arguments,
 * commit no data to the database, and are flagged with the testMethod
 * keyword in the method definition.
 *
 * All test methods in an organization are executed whenever Apex code is deployed
 * to a production organization to confirm correctness, ensure code
 * coverage, and prevent regressions. All Apex classes are
 * required to have at least 75% code coverage in order to be deployed
 * to a production organization. In addition, all triggers must have some code coverage.
 * 
 * The @isTest class annotation indicates this class only contains test
 * methods. Classes defined with the @isTest annotation do not count against
 * the organization size limit for all Apex scripts.
 *
 * See the Apex Language Reference for more information about Testing and Code Coverage.
 */
@isTest
private class WRFCaseCreation_TC {
    //Case#00175758----START----Hitesh [Aug 11, 2016]
        @testSetup static void setUpData(){         
            Account acc1 = new Account();
              acc1.name = 'Ank Test account1';
              acc1.BillingStreet = '1040 N 326 W';
              acc1.billingcity = 'Orem';
              acc1.BillingState = 'UT';
              acc1.Billingcountry = 'USA';
              acc1.Buying_Group__c = 'Buying Groups Federal';
              acc1.Sector__c = 'Public';
              acc1.Segment__c = 'Federal';
              acc1.Oracle_Party_Id__c = 'testdata';
              acc1.AOPS_Cust_Id__c = '123456';
              acc1.AOPS_Seq_ID__c = '123456';
              insert acc1; 
        }
        //Case#00175758----END----Hitesh [Aug 11, 2016]
    
    //Case#00175758----START----Hitesh [Aug 11, 2016]
    // below test method has been splitted into additional methods
    //  to avoid soql limit error
    static testMethod void myUnitTest() {
        Map<String,Schema.RecordTypeInfo> CaseRecType = Schema.SObjectType.Case.getRecordTypeInfosByName();    
        Account acc = [select id from Account where name='Ank Test account1' limit 1];      //Case#00175758-------Hitesh [Aug 11, 2016]
        List<case> cases = new List<case>();
        
        Case cs = new Case();
        cs.recordTypeId = CaseRecType.get('Work Request').getRecordTypeId();
        cs.WRF_Request_Type__c = 'Transition';
        cs.accountId = acc.id;      //Case#00175758-------Hitesh [Aug 11, 2016]
        cases.add(cs);
                
        Test.startTest();       //Case#00175758-------Hitesh [Aug 11, 2016]
        insert cases;
        Test.stopTest();        //Case#00175758-------Hitesh [Aug 11, 2016]
    }
    
    static testMethod void myUnitTest_1() {
        Map<String,Schema.RecordTypeInfo> CaseRecType = Schema.SObjectType.Case.getRecordTypeInfosByName();    
        Account acc = [select id from Account where name='Ank Test account1' limit 1];      //Case#00175758-------Hitesh [Aug 11, 2016]
        List<case> cases = new List<case>();
                
        Case cs1 = new Case();
        cs1.recordTypeId = CaseRecType.get('Work Request').getRecordTypeId();
        cs1.WRF_Request_Type__c = 'Transition';
        cs1.subject = 'Customer RFP Received Disposition Request';
        cs1.accountId = acc.id;     //Case#00175758-------Hitesh [Aug 11, 2016]
        cases.add(cs1);
                
        Test.startTest();           //Case#00175758-------Hitesh [Aug 11, 2016]
        insert cases;
        Test.stopTest();            //Case#00175758-------Hitesh [Aug 11, 2016]
    }
    
    static testMethod void myUnitTest_2() {
        Map<String,Schema.RecordTypeInfo> CaseRecType = Schema.SObjectType.Case.getRecordTypeInfosByName();    
        Account acc = [select id from Account where name='Ank Test account1' limit 1];      //Case#00175758-------Hitesh [Aug 11, 2016]
        List<case> cases = new List<case>();               
        
        Case cs2 = new Case();
        cs2.recordTypeId = CaseRecType.get('Work Request').getRecordTypeId();
        cs2.WRF_Request_Type__c = 'Transition';
        cs2.subject = 'Extend current OMX Agreement Disposition Request';
        cs2.accountId = acc.id;     //Case#00175758-------Hitesh [Aug 11, 2016]
        cases.add(cs2);
        
        Test.startTest();           //Case#00175758-------Hitesh [Aug 11, 2016]
        insert cases;
        Test.stopTest();            //Case#00175758-------Hitesh [Aug 11, 2016]
        // creating object of class WRFtaskCreation and then calling a function createCustomCoreRequest which will accept List of cases.
        WRFtaskCreation obj1=new WRFtaskCreation();  // Added by Jasvinder for Story S-437501 and OD- 00800276
        System.assert(obj1 != null , 'object should not be null');
        obj1.createCustomCoreRequest(cases); // Added by Jasvinder for Story S-437501 and OD- 00800276
        obj1.hostedWrfCreation(cases);
    }
    //Case#00175758----END----Hitesh [Aug 11, 2016]
    
    
    //Case#00978146 Start UnitTest
    static testMethod void myUnitTest_3() {
        Map<String,Schema.RecordTypeInfo> CaseRecType = Schema.SObjectType.Case.getRecordTypeInfosByName();    
        Account acc = [select id from Account where name='Ank Test account1' limit 1];
        List<case> cases = new List<case>();
        List<WRF_Task__c> wrf = new List<WRF_Task__c>();
        
        Case cs = new Case();
        cs.recordTypeId = CaseRecType.get('Work Request').getRecordTypeId();
        cs.WRF_Request_Type__c = 'Hosted Catalog Creation/Update';
        cs.accountId = acc.id;
        cases.add(cs);
        
        WRF_Task__c w = new WRF_Task__c();
        w.Disposition_Code__c = 'Hosted Catalog';
        w.Assignment_Group__c = 'BSD Pricing';
        w.WRF__c = '500E000000MSgL9IAL';
        w.Status__c = 'Not Started';
        w.Due_Date__c = system.today();
        w.Priority__c = 'Normal';
        wrf.add(w);
                
        Test.startTest();       
        insert cases;
        insert wrf;
        Test.stopTest();        
    }
    //Case#00978146 End UnitTest 
    
        //Case#NAIT-109874 Start
        static testMethod void myUnitTest_4() {
        Map<String,Schema.RecordTypeInfo> CaseRecType = Schema.SObjectType.Case.getRecordTypeInfosByName();    
        Account acc = [select id from Account where name='Ank Test account1' limit 1];
        List<case> cases = new List<case>();
        
        Case cs = new Case();
        cs.recordTypeId = CaseRecType.get('Work Request').getRecordTypeId();
        cs.WRF_Request_Type__c = 'Leader/Follower SKU Change';
        cs.accountId = acc.id;
        cases.add(cs);
                
        Test.startTest();
        insert cases;
        Test.stopTest();
    }
    //Case#NAIT-109874 Start
}