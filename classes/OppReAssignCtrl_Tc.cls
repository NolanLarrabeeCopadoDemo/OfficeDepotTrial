@IsTest
private class OppReAssignCtrl_Tc{  

    static testMethod void oppTest(){
        Profile p4 = [SELECT Id FROM profile WHERE name='System Administrator'];   
        User u1 = new User(alias = 'test121', email='proxy@proxy56654.officedepot.com',OD_Employee_ID__c='225886',emailencodingkey='UTF-8', lastname='teOfficedepo',languagelocalekey='en_US',localesidkey='en_US',short_title__c = 'TSR', profileid = p4.Id,timezonesidkey='America/Los_Angeles',username='proxy@7878.com',isactive=true);
        insert u1; 
		system.runas(u1)
        {
        Account acc = new Account();
            acc.Aops_seq_id__c='12345';
            acc.Name='Realted';
            insert acc;
            Account acc1 = new Account();
            acc1.Name='TestAcc';
            acc1.Aops_seq_id__c='12345-111';
            acc1.Related_account__c = acc.Id;
            acc1.Name='Test';
            insert acc1;
            Account acc2 = new Account();
            acc2.Name='Test';
            insert acc2;
        opportunity opp = new Opportunity();
            opp.accountid=  acc1.id;
            opp.Name='Test';
            opp.product__c = 'tech';
            opp.StageName='90%-Execute';
            opp.CloseDate=System.today();
            insert opp;
        Admin_Config__c ad= new Admin_Config__c();
            ad.name ='Default';
            ad.Tech_Depot_Title__c = 'TSR';
            ad.Tech_Depot_Auto_Assign_Opp__c =true;
            ad.Tech_Depot_User__c ='salesforce';
            ad.BatchSize__c ='100';
            insert ad;
        AccountTeamMember atm = new AccountTeamMember();
        atm.UserId = u1.Id;
        atm.AccountId = acc1.Id;
        insert atm;    
        Test.setCurrentPage(Page.OpportunityReAssign);
        ApexPages.currentPage().getParameters().put('id', opp.id);
        //ApexPages.StandardController controller = new ApexPages.StandardController();
        OppReAssignCtrl ctrl = new OppReAssignCtrl(new ApexPages.StandardController(opp));
        List<selectOption> lst = ctrl.getaccts() ;
        ctrl.selected = 'ATMUSers';
        ctrl.CheckSelection();
        ctrl.selected = 'Auto';
        ctrl.CheckSelection();
        ctrl.selected = 'AllUsers';
        ctrl.CheckSelection();
        ctrl.AutoAsgn();
        ctrl.TeamMembers();
        OppReAssignCtrl.sWrapper sw = new OppReAssignCtrl.sWrapper(U1,TRUE);
        CTRL.cancleButn();
        CTRL.UpdateOwner();
        ctrl.UpdateATMOwner();
    }
   
    }

}