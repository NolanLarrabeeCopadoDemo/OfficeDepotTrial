/**
 * This class contains unit tests for validating the behavior of Apex classes
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
private class DupProspects_Customers_TC {
   public static testMethod void myUnitTest() {
   
      /*  Sales_Person__c sp = new Sales_Person__c();
        sp.name = 'System';
        sp.ExtIDSalesPerson__c = 'System';
        sp.isactive__c = true;
        sp.primary__c = true;
        sp.role_relate_id__c = '000000';
        sp.user__c = '005E0000000lNbV';
        insert sp;*/
 
       /*Account Creation*/ 
       Account acc = new Account ();
       acc.name = 'Ank Test Account';
       acc.BillingStreet = '1040 N 326 W';
       acc.billingcity = 'Orem';
       acc.BillingState = 'UT';
       acc.Billingcountry = 'USA';
       acc.Buying_Group__c = 'Buying Groups Federal';
       acc.Sector__c = 'Public';
       acc.Segment__c = 'Federal';
       acc.Oracle_Party_Id__c = 'testdata';
       acc.AOPS_Cust_Id__c = '123456';
       acc.AOPS_Seq_ID__c = '123456';
       acc.OwnerID = '005E0000000lNbV';// This is the salesforce User ID
       acc.Sales_PersonID__c = 'a0AE0000000GGMn'; //Sales person Id for the Salesforce USer
       insert acc;
        
       Account accSite = new Account ();
       accSite.name = 'Ank Test Account1';
       accSite.BillingStreet = '1040 N 326 W';
       accSite.billingcity = 'Orem';
       accSite.BillingState = 'UT';
       accSite.Billingcountry = 'US';
       accSite.Address1__c = '4785 S Citation Drive';
       accSite.Address2__c = '202';
       accSite.City__c = 'Delray Beach';
       accSite.State__c = 'FL';
       accSite.zip__c ='33351';
       accSite.Country__c = 'USA';
       accSite.County__c = 'US';
       accSite.Related_Account__c = acc.id;
       accSite.Primary_Site__c= true;
       accSite.Oracle_Party_Site_Id__c = 'testdata';
       accSite.AOPS_Cust_Id__c = '12345678';
       accSite.AOPS_Seq_ID__c = '12345678';
       insert accSite;
        
        Test.Starttest();
       ApexPages.currentPage().getParameters().put('id',acc.id);                   
      ApexPages.StandardController controller=new ApexPages.StandardController(accSite);    

        //PageReference pageRefDupProspects_Customers = Page.DupProspects_Customers;
        //Test.setCurrentPage(pageRefDupProspects_Customers);      
        DupProspects_Customers Dupprospects = new DupProspects_Customers (controller);
        Dupprospects.getwrap();
        Dupprospects.cancel();
        Test.Stoptest();
        
        
    }
}