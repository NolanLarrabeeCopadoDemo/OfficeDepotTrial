@isTest
private class contractRelatedList_TC
{
      static testMethod  void contractRelatedList_TC (){

        String s;
        //List<account> accounts = new List<account>();
        List<contract> contracts = new List<contract>();
        
        List<recordtype> prospectID = [Select id from recordtype where name='Prospect'];
        List<recordtype> custID = [Select id from recordtype where name='Customer'];
        
        Account grandParent = new Account();
        grandParent.name = 'Grand Parent';
        grandParent.RecordTypeId = custID[0].id;
        insert grandParent;
        
        Account parent = new Account();
        parent.name = 'parent';
        parent.RecordTypeId = custID[0].id;
        parent.parentid = grandParent.id;
        insert parent;
        
        Account acc = new Account ();
        acc.name = 'SUN Test Account';
        acc.BillingStreet = '1040 N 326 W';
        acc.billingcity = 'Orem';
        acc.BillingState = 'UT';
        acc.Billingcountry = 'USA';
        acc.Oracle_Party_Id__c = '123456';
        acc.AOPS_Cust_Id__c = '123456';
        acc.AOPS_Seq_ID__c = '123456';
        acc.parentid = parent.id;
        acc.RecordTypeId = custID[0].id;
        insert acc;
        
        Account accChild = new Account ();
        accChild.name = 'SUN Test Account1';
        accChild.BillingStreet = '1039 N 326 W';
        accChild.billingcity = 'Orem';
        accChild.BillingState = 'UT';
        accChild.Billingcountry = 'USA';
        accChild.Oracle_Party_Id__c = '123457';
        accChild.AOPS_Cust_Id__c = '123457';
        accChild.AOPS_Seq_ID__c = '123457';
        accChild.parentid = acc.id;
        accChild.RecordTypeId = prospectID[0].id;
        insert accChild;
        
        Account prospectAccChild = new Account ();
        prospectAccChild.name = 'SUN Test Account1';
        prospectAccChild.BillingStreet = '1038 N 326 W';
        prospectAccChild.billingcity = 'Orem';
        prospectAccChild.BillingState = 'UT';
        prospectAccChild.Billingcountry = 'USA';
        prospectAccChild.Oracle_Party_Id__c = '123458';
        prospectAccChild.AOPS_Cust_Id__c = '123458';
        prospectAccChild.AOPS_Seq_ID__c = '123458';
        prospectAccChild.parentid = acc.id;
        prospectAccChild.RecordTypeId = custID[0].id;
        insert prospectAccChild;
        
        //insert accounts;

        contract grandParent_cntr = new contract();
        grandParent_cntr.name= '';
        grandParent_cntr.accountId = grandParent.id;
        contracts.add(grandParent_cntr);
        
        contract parent_cntr = new contract();
        parent_cntr.name= '';
        parent_cntr.accountId = parent.id;
        contracts.add(parent_cntr);
        
        contract cntr = new contract();
        cntr.name= '';
        cntr.accountId = acc.id;
        contracts.add(cntr);
        
        contract accChild_cntr = new contract();
        accChild_cntr.name= '';
        accChild_cntr.accountId = accChild.id;
        contracts.add(accChild_cntr);
        
        contract prospectAccChild_cntr = new contract();
        prospectAccChild_cntr.name= '';
        prospectAccChild_cntr.accountId = prospectAccChild.id;
        contracts.add(prospectAccChild_cntr);
        
        insert contracts;
        
       ApexPages.currentPage().getParameters().Put('id',acc.id);
       ApexPages.StandardController con = new ApexPages.StandardController(acc);
       contractRelatedList controller = new contractRelatedList(con);
       contractRelatedList.WrapperClass wrap = new contractRelatedList.WrapperClass(s,cntr,acc);
       //controller.getCont();
       ApexPages.currentPage().getParameters().Put('selectedRecord',cntr.id);
       controller.deleteContractItem();
       List<contractRelatedList.wrapperclass> lst1 = controller.getwrapperlist();
       controller.setwrapperlist();
       
       ApexPages.currentPage().getParameters().Put('id',accChild.id);
       ApexPages.StandardController con1 = new ApexPages.StandardController(accChild);
       contractRelatedList controller1 = new contractRelatedList(con1);
       contractRelatedList.WrapperClass wrap1 = new contractRelatedList.WrapperClass(s,accChild_cntr,accChild);
       //controller.getCont();
       ApexPages.currentPage().getParameters().Put('selectedRecord',accChild_cntr.id);
       controller1.deleteContractItem();
       List<contractRelatedList.wrapperclass> lst2 = controller1.getwrapperlist();
       controller1.setwrapperlist();
       
       ApexPages.currentPage().getParameters().Put('id',prospectAccChild.id);
       ApexPages.StandardController con2 = new ApexPages.StandardController(prospectAccChild);
       contractRelatedList controller2 = new contractRelatedList(con2);
       contractRelatedList.WrapperClass wrap2 = new contractRelatedList.WrapperClass(s,prospectAccChild_cntr,prospectAccChild);
       //controller.getCont();
       ApexPages.currentPage().getParameters().Put('selectedRecord',prospectAccChild_cntr.id);
       controller2.deleteContractItem();
       List<contractRelatedList.wrapperclass> lst3 = controller2.getwrapperlist();
       controller2.setwrapperlist();


        }
}