@isTest
public class OwnerOverrideController_TC {

    public static testMethod void testmethod1(){
         RecordType rr = [select id from recordtype where sobjecttype='Account' and developername='Prospect'];
              Account acc = new Account();
              acc.name='test1';
              acc.recordtypeId=rr.id;
			acc.Oracle_Party_ID__c='test12asdq';
        acc.Duns_Enrichment__c='asdaxz';
        acc.DNBI_CREDIT_OUTCOME__c='mzlkas';
       
            Insert acc;
        ApexPages.StandardController sc = new ApexPages.StandardController(acc);
        OwnerOverrideController ooc = new OwnerOverrideController(sc);
         profile p=[select id from profile where name='GrandParent Maintenance'];
        
         ApexPages.currentPage().getParameters().put('RecordType', null);
          user testUser = Test_Utils.createTestUser('test12','999654');
          testUser.GrandParent_User__c=true;
          testUser.profileId=p.id;
          PageReference pr;
        System.RunAs(testUser){
            Redirect_Profile__c rp = new Redirect_Profile__c();
            rp.Name='test';
            insert rp;
            ooc.redirPage();
        }
        testUser.GrandParent_User__c =false;
        update testUser;
        System.RunAs(testUser){
             ApexPages.currentPage().getParameters().put('RecordType',rr.id);
            ooc.redirPage();
        }
    }
}