@isTest
Private class ggpRelController_TC {
    static User testUser;
  Private static testMethod void Reltest() {
      
        profile p=[select id from profile where name='GrandParent Maintenance'];
        
         
          testUser = Test_Utils.createTestUser('test12','999654');
          testUser.GrandParent_User__c=true;
          testUser.profileId=p.id;
          PageReference pr;
          System.RunAs(testUser){
              
              RecordType rr = [select id from recordtype where sobjecttype='Account' and developername='Great_Grandparent'];
              RecordType rp = [select id from recordtype where sobjecttype='Account' and developername='Customer'];
              
              Account acc = new Account();
              acc.name='test1';
              acc.recordtypeId=rr.id;
              Insert acc;
              //Database.insert(acc,false);
              
              Account accggp = new Account(name='accgp1',recordtypeId=rr.id);
              //accggp.name='accgp';
              //accggp.recordtypeId=r.id;
             //Database.SaveResult srList= Database.insert(accggp,false);
            //system.assertequals(srList.isSuccess(),true);
              //insert accggp;
              
              Account accgp2 = new Account();
              accgp2.name='testGP1';
              accgp2.recordtypeId=rr.id;
              Database.insert(accgp2,false);
              //insert accgp2;
              
              Account accp = new Account();
              accp.name='testParent1';
              accp.recordtypeId=rp.id;
              Database.insert(accp,false);

             // insert accp;
              
              ggpRelController ggc2 = new ggpRelController();
              ApexPages.currentPage().getParameters().put('AcctId', acc.id);
              ggpRelController ggc = new ggpRelController();
              
              ggc.acct.parentid=accggp.id;
              pr=ggc.cancelRecord();
              pr=ggc.saveRecord();
              
              ggc.acct.parentid=accgp2.id;
              pr=ggc.saveRecord();
              
              
               ggc.acct.parentid=accp.id;
               pr=ggc.saveRecord();
               
           
             
              
              
              
          }
  }
      Private static testMethod void Reltest1() {
      
        profile p=[select id from profile where name='GrandParent Maintenance'];
        
         
          testUser = Test_Utils.createTestUser('test12','999654');
          testUser.GrandParent_User__c=false;
          testUser.profileId=p.id;
          PageReference pr;
          System.RunAs(testUser){
              
              RecordType rr = [select id from recordtype where sobjecttype='Account' and developername='Great_Grandparent'];
              RecordType rp = [select id from recordtype where sobjecttype='Account' and developername='Customer'];
              
              Account acc = new Account();
              acc.name='test1';
              acc.recordtypeId=rr.id;
              Insert acc;
              //Database.insert(acc,false);
              
              Account accggp = new Account(name='accgp1',recordtypeId=rr.id);
              //accggp.name='accgp';
              //accggp.recordtypeId=r.id;
             //Database.SaveResult srList= Database.insert(accggp,false);
            //system.assertequals(srList.isSuccess(),true);
              //insert accggp;
              
              Account accgp2 = new Account();
              accgp2.name='testGP1';
              accgp2.recordtypeId=rr.id;
              Database.insert(accgp2,false);
              //insert accgp2;
              
              Account accp = new Account();
              accp.name='testParent1';
              accp.recordtypeId=rp.id;
              Database.insert(accp,false);

             // insert accp;
              
              ggpRelController ggc2 = new ggpRelController();
              ApexPages.currentPage().getParameters().put('AcctId', acc.Id);
              ggpRelController ggc = new ggpRelController();
              
             /* ggc.acct.parentid=acc.id;
              pr=ggc.cancelRecord();
              pr=ggc.saveRecord();
              
              ggc.acct.parentid=accgp2.id;
              pr=ggc.saveRecord();
              
              
               ggc.acct.parentid=accp.id;
               pr=ggc.saveRecord();*/
               
           
             
              
              
              
          }
  }

}