@isTest
private class gpRelController_TC {
    static User testUser;
	private static testMethod void Reltest() {
	    
	      profile p=[select id from profile where name='GrandParent Maintenance'];
	      
         
          testUser = Test_Utils.createTestUser('test11','999654');
          testUser.GrandParent_User__c=true;
          testUser.profileId=p.id;
          PageReference pr;
          System.RunAs(testUser){
              
              RecordType r = [select id from recordtype where sobjecttype='Account' and developername='GrandParent'];
              RecordType rp = [select id from recordtype where sobjecttype='Account' and developername='Customer'];
              
              Account acc = new Account();
              acc.name='test';
              insert acc;
              
              Account accgp = new Account();
              accgp.name='testGP';
              accgp.recordtypeId=r.id;
              insert accgp;
              
              Account accgp2 = new Account();
              accgp2.name='testGP';
              accgp2.recordtypeId=r.id;
              insert accgp2;
              
              Account accp = new Account();
              accp.name='testParent';
              accp.recordtypeId=rp.id;
              insert accp;
              
              gpRelController gc2 = new gpRelController();
              ApexPages.currentPage().getParameters().put('AcctId', acc.id);
              gpRelController gc = new gpRelController();
              
              gc.acct.parentid=accgp.id;
              pr=gc.cancelRecord();
              pr=gc.saveRecord();
              
              gc.acct.parentid=accgp2.id;
              pr=gc.saveRecord();
              
               gc.acct.parentid=accp.id;
               pr=gc.saveRecord();
              
              
              
          }
	}

}