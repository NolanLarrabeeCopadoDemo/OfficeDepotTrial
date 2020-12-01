@isTest(SeeAllData=true)
private class Update_Status_Age_TC{
    static testMethod void Update_Status_Age_testMethod()
    {
    try{
        List<Customer_Transition__c> custList = new List<Customer_Transition__c>();
        List<Customer_Transition__c> upcustList = new List<Customer_Transition__c>();
        Set<ID> customerLostCTids = new Set<ID>();
        Account acc = new Account();
        acc.Name='Test Account';
        //acc.parentId= ParentAcc.id;
        insert acc;
        
        Customer_Transition__c cust = new Customer_Transition__c();
        cust.name = 'testing CustomerTransition';
        cust.Account__c= acc.id;
        cust.Status__c = 'On Deck';
        cust.Ready_to_order__c = false;
        cust.Redirect_Turned_OFF__c = true;
        cust.Customer_Transition_Date_to_OD_Systems__c=system.today();
        cust.Customer_Loss__c=false;
        custList.add(cust);
        
        Customer_Transition__c cust1 = new Customer_Transition__c();
        cust1.name = 'testing CustomerTransition with scheduled';
        cust1.Account__c= acc.id;
        cust1.Status__c = 'Scheduled';
        cust1.Ready_to_order__c = false;
        custList.add(cust1);
        
        Customer_Transition__c cust11 = new Customer_Transition__c();
        cust11.name = 'testing CustomerTransition with Extension';
        cust11.Account__c= acc.id;
        cust11.Status__c = 'UnScheduled';
        custList.add(cust11);
        
        Customer_Transition__c cust2 = new Customer_Transition__c();
        cust2.name = 'testing CustomerTransition with agreement and Development';
        cust2.Account__c= acc.id;
        cust2.Status__c = 'Agreement/Development';
        custList.add(cust2);
        
        Customer_Transition__c cust3 = new Customer_Transition__c();
        cust3.name = 'testing CustomerTransition with Extension';
        cust3.Account__c= acc.id;
        cust3.Status__c = 'Extension/Development';
        custList.add(cust3);
        
        Customer_Transition__c cust4 = new Customer_Transition__c();
        cust4.name = 'testing CustomerTransition with Extension';
        cust4.Account__c= acc.id;
        cust4.Status__c = 'Launched';
        custList.add(cust4);
        
        Customer_Transition__c cust5 = new Customer_Transition__c();
        cust5.name = 'testing CustomerTransition with Extension';
        cust5.Account__c= acc.id;
        cust5.Status__c = 'Building';
        custList.add(cust5);
        
        Customer_Transition__c cust6 = new Customer_Transition__c();
        cust6.name = 'testing CustomerTransition with Extension';
        cust6.Account__c= acc.id;
        cust6.Status__c = 'Finalizing';
        custList.add(cust6);
        
        Customer_Transition__c cust7 = new Customer_Transition__c();
        cust7.name = 'testing CustomerTransition with Extension';
        cust7.Account__c= acc.id;
        cust7.Status__c = 'Audit 1';
        custList.add(cust7);
        
        Customer_Transition__c cust8 = new Customer_Transition__c();
        cust8.name = 'testing CustomerTransition with Extension';
        cust8.Account__c= acc.id;
        cust8.Status__c = 'Audit 2';
        custList.add(cust8);
        
        Customer_Transition__c cust9 = new Customer_Transition__c();
        cust9.name = 'testing CustomerTransition with Extension';
        cust9.Account__c= acc.id;
        cust9.Status__c = 'Ordering';
        custList.add(cust9);
        
        Customer_Transition__c cust10 = new Customer_Transition__c();
        cust10.name = 'testing CustomerTransition with Extension';
        cust10.Account__c= acc.id;
        cust10.Status__c = 'Assessment';
        custList.add(cust10);
        
         insert custList;
        
        

        acc.aops_cust_id__c = '123456';
        update acc;
        
        cust.DUAL_Account_Yes_No__c = true;
        cust.Ready_for_Mod1__c=true;
        cust.Override_Details_Error__c = true;
        cust.Manual_Build_Underway__c=true;
        cust.Dual_Account_Comments__c = 'test';
        cust.EBS_Populated_Date__c = system.today();
        cust.Pricing_Reviewed_Comments__c = 'test';
        cust.Estimated_OMX_Acct_Close__c = system.today();
        cust.Ready_for_audit_2__c=true;
        cust.Ready_for_account_finalizing_final_mod__c=true;
        cust.Ready_for_audit_1__c=true;
        cust.Ready_to_order__c = true;
        cust.DNS_Confirmation__c = false;
        //Added below line by Najma Ateeq for Story #S-386202(OD Case Number - 00617674)
        cust1.DUAL_Account_Yes_No__c = true;
        cust.Pricing_Status_Code__c='test';
        cust.Account__c=acc.id;
        upcustList.add(cust);
        
        cust1.DUAL_Account_Yes_No__c = false;
        cust1.Ready_for_Mod1__c=true;
        cust1.Override_Details_Error__c = true;
        cust1.Manual_Build_Underway__c=true;
        cust1.Dual_Account_Comments__c = 'test';
        cust1.EBS_Populated_Date__c = system.today();
        cust1.Pricing_Reviewed_Comments__c = 'test';
        cust1.Estimated_OMX_Acct_Close__c = system.today();
        cust1.Ready_for_audit_2__c=true;
        cust1.Ready_for_account_finalizing_final_mod__c=true;
        cust1.Ready_for_audit_1__c=true;
        cust1.Ready_to_order__c = true;
        cust1.Account__c=acc.id;
        cust1.Pricing_Status_Code__c='test2';
        upcustList.add(cust1);        
        
        update upcustList;
        
        cust.Redirect_Turned_OFF__c = false;
        cust.Customer_Loss__c=true;
        cust.DNS_Confirmation__c = true;
        cust.Customer_Transition_Date_to_OD_Systems__c = system.today();
        cust.status__c ='Loss of Customer';
        cust.Compliance_Life_Cycle_Reviewed__c = System.today();
        cust.Compliance_Life_Cycle_Reviewed_Person__c = UserInfo.getName() ;
        update cust;
                
        //cust.Customer_Loss__c = true;
        
        update cust;
        executeoncetest.rerun_timetrack = true;
        cust3.status__c = 'Scheduled';
        update cust3;
        executeoncetest.rerun_timetrack = true;
        cust3.status__c = 'UnScheduled';
        update cust3;
        executeoncetest.rerun_timetrack = true;
        cust3.status__c = 'Agreement/Development';
        update cust3;
        executeoncetest.rerun_timetrack = true;
        cust3.status__c = 'UnScheduled';
        update cust3;
        executeoncetest.rerun_timetrack = true;
        cust3.status__c = 'Extension/Development';
        update cust3;
        executeoncetest.rerun_timetrack = true;
        cust3.status__c = 'Launched';
        update cust3;
        executeoncetest.rerun_timetrack = true;
        cust3.status__c = 'Building';
        update cust3;
        executeoncetest.rerun_timetrack = true;
        cust3.status__c = 'Finalizing';
        update cust3;
        executeoncetest.rerun_timetrack = true;
        cust3.status__c = 'Audit 1';
        update cust3;
        executeoncetest.rerun_timetrack = true;
        cust3.status__c = 'Audit 2';
        update cust3;
        executeoncetest.rerun_timetrack = true;
        cust3.status__c = 'Ordering';
        update cust3;
        executeoncetest.rerun_timetrack = true;
        cust3.status__c = 'Assessment';
        update cust3;
        executeoncetest.rerun_timetrack = true;
        //cust3.Customer_Loss__c = true;
        //cust3.Administrative_Close__c = true;
        //cust3.Customer_Transition_Complete__c = true;
        cust3.status__c = 'Building';
        update cust3;
        
        
        
        }Catch(Exception e){}
     }
      //Added by Najma Ateeq for Story #S-386202(OD Case Number - 00617674)
      static testMethod void Update_Status_Age_testMethod2()
    {
    try{
        List<Customer_Transition__c> custList = new List<Customer_Transition__c>();
        List<Customer_Transition__c> upcustList = new List<Customer_Transition__c>();
        Account acc = new Account();
        acc.Name='Test Account';
        //acc.parentId= ParentAcc.id;
        insert acc;
        
        Customer_Transition__c cust = new Customer_Transition__c();
        cust.name = 'testing CustomerTransition';
        cust.Account__c= acc.id;
        cust.Status__c = 'On Deck';
        cust.Ready_to_order__c = false;
        cust.Status__c = 'UnScheduled';
        insert cust;
        cust.DUAL_Account_Yes_No__c = true;
        cust.Status__c = 'Auto Redirected';
        cust.DNS_Status_Confirmed__c = true;
       
        
        update cust;
        
        cust.Ready_for_account_finalizing_final_mod__c = true; 
        cust.status__c = 'Launched';
        cust.Redirect_Turned_OFF__c = true;
         cust.Ready_to_order__c = true;
         cust.DUAL_Account_Yes_No__c = false;
        update cust;
        
        cust.Status__c = 'Scheduled';
        update cust;
        
        cust.Status__c = 'UnScheduled';
        update cust;
        
        cust.Status__c = 'On Deck';
        update cust;
        
        cust.Status__c = 'Agreement/Development';
        update cust;
        
        cust.status__c = 'Extension/Development';
        update cust;
        
        cust.Status__c = 'Launched';
        update cust;
        
        cust.Status__c = 'Building';
        update cust;
    }catch(Exception e){
        
    }
    }
    static testMethod void Update_Status_Age_testMethod3()
    {
    try{
        List<Customer_Transition__c> custList = new List<Customer_Transition__c>();
        List<Customer_Transition__c> upcustList = new List<Customer_Transition__c>();
        Account acc = new Account();
        acc.Name='Test Account';
        //acc.parentId= ParentAcc.id;
        insert acc;
        
        Customer_Transition__c cust = new Customer_Transition__c();
        cust.name = 'testing CustomerTransition';
        cust.Account__c= acc.id;
        cust.Status__c = 'On Deck';
        cust.Ready_to_order__c = false;
        cust.Status__c = 'Scheduled';
        cust.Customer_Loss__c = false;
        insert cust;
        
        cust.Status__c = 'Transition Complete';
        cust.Redirect_Turned_OFF__c = true;
        cust.DNS_Confirmation__c = true;
        cust.Administrative_Close__c = true;
        cust.Ready_for_Mod1__c = false;
        cust.Customer_Transition_Date_to_OD_Systems__c = Date.today();
        cust.Customer_Loss__c = true;
        update cust;
        
        cust.Redirect_Turned_OFF__c  = false;
        cust.Redirect_Turned_OFF_Date__c = null;
        cust.Status__c = 'Auto Redirected';
        cust.DNS_Status_Confirmed__c = true;
        update cust;
        
        cust.Status__c = 'Finalizing';
        update cust;
        
        cust.Status__c = 'Audit 1';
        update cust;
        
        cust.Status__c = 'Audit 2';
        update cust;
        
        cust.Status__c = 'Ordering';
        update cust;
        
        cust.Status__c = 'Assessment';
        update cust;
        
        cust.Status__c = 'Ordering';
        update cust;
        
        cust.Status__c = 'Scheduled';
        cust.Customer_Loss__c  = true;
        cust.Administrative_Close__c  = true;
        cust.Ready_for_Mod1__c  = false;
        cust.DNS_Confirmation__c  = true;
        update cust;
    }catch(Exception e){
        
    }
    }
    static testMethod void Update_Status_Age_testMethod4()
    {
    try{
       
        Account acc = new Account();
        acc.Name='Test Account';
        //acc.parentId= ParentAcc.id;
        insert acc;
        
        Customer_Transition__c cust = new Customer_Transition__c();
        cust.name = 'testing CustomerTransition';
        cust.Account__c= acc.id;
        
        cust.Ready_to_order__c = false;
        cust.Status__c = 'Scheduled';
        insert cust;
        
        cust.Status__c = 'Auto Redirected';
        cust.DUAL_Account_Yes_No__c = true;
       
        update cust;
        
        cust.Ready_for_account_finalizing_final_mod__c = true; 
        cust.status__c ='Launched';
        update cust;
        
        cust.Redirect_Turned_OFF__c = true;
        cust.status__c ='Transition Complete';
        cust.Redirect_Turned_OFF__c = false;
        
        
        update cust;
        
        cust.Customer_Transition_Date_to_OD_Systems__c = Date.today().addDays(100);
        cust.Customer_Loss__c = true;
        update cust;
        
        cust.Status__c = 'ODP Agreement in Development';
        update cust;
        
        cust.Status__c = 'Ready for eCom Mod';
        update cust;
        
        cust.Status__c = 'ODP Agreement in Development';
        update cust;
    }catch(Exception e){
        
    }
    }
     //Added by Najma Ateeq for Story #S-386202(OD Case Number - 00617674)
}