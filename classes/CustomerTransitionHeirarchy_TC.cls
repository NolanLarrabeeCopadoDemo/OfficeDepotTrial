@isTest
Public class CustomerTransitionHeirarchy_TC
{
    static testmethod void method1()
    {
        Account pacc = new Account ();
        pacc.name = 'SUN Test Account1';
        pacc.BillingStreet = '1040 N 326 W';
        pacc.billingcity = 'Orem';
        pacc.BillingState = 'UT';
        pacc.Billingcountry = 'USA';
        pacc.Oracle_Party_Id__c = '543456';
        pacc.AOPS_Cust_Id__c = '003456';
        insert pacc;
        
        Account acc = new Account ();
        acc.name = 'SUN Test Account';
        acc.BillingStreet = '1040 N 326 W';
        acc.billingcity = 'Orem';
        acc.BillingState = 'UT';
        acc.Billingcountry = 'USA';
        acc.Oracle_Party_Id__c = '123456';
        acc.AOPS_Cust_Id__c = '123456';
        acc.parentid=pacc.id;
        insert acc;   
        
        Customer_Transition__c CT = new Customer_Transition__c(name='test',account__c = pacc.id,Status__c='Scheduled');
        CT.Account__c = acc.id;
        insert CT;
        
        CT.name='testupdate';
        CT.Status__c='Scheduled';
      //  update CT;
        
        String strQuery = '';
        CustomerTransitionHeirarchy cth = new CustomerTransitionHeirarchy (strQuery);
        database.executebatch(cth, 100);   
    }
     static testmethod void method2()
    {
    List <Account> AccList=new List <Account>();
    List <Customer_Transition__c> CTList=new List <Customer_Transition__c>();
     Account Gpacc = new Account ();
        Gpacc.name = 'SUN Test Account1';
        Gpacc.BillingStreet = '1040 N 326 W';
        Gpacc.billingcity = 'Orem';
        Gpacc.BillingState = 'UT';
        Gpacc.Billingcountry = 'USA';
        Gpacc.Oracle_Party_Id__c = '345156';
        Gpacc.AOPS_Cust_Id__c = '090456';
       // insert pacc;
       AccList.add(Gpacc);
        Account pacc = new Account ();
        pacc.name = 'SUN Test Account1';
        pacc.BillingStreet = '1040 N 326 W';
        pacc.parentid=Gpacc.id;
        pacc.billingcity = 'Orem';
        pacc.BillingState = 'UT';
        pacc.Billingcountry = 'USA';
        pacc.Oracle_Party_Id__c = '543456';
        pacc.AOPS_Cust_Id__c = '003456';
       // insert pacc;
       AccList.add(pacc);
        
        Account acc = new Account ();
        acc.name = 'SUN Test Account';
        acc.BillingStreet = '1040 N 326 W';
        acc.billingcity = 'Orem';
        acc.BillingState = 'UT';
        acc.Billingcountry = 'USA';
        acc.Oracle_Party_Id__c = '123456';
        acc.AOPS_Cust_Id__c = '123456';
        acc.parentid=pacc.id;
        //insert acc;
         AccList.add(acc);   
        insert AccList;
        Customer_Transition__c CT = new Customer_Transition__c(name='test',account__c = acc.id,Status__c='Launched',Cascade_Down__c=true);
        //insert CT;
        CTList.add(CT);
        insert CTList;
        
        CT.name='testupdate';
        CT.Status__c='Scheduled';
        CT.Cascade_Down__c=true;
        update CTList;
        
         CT.Status__c='Launched';
        
       // CTlist.add(CT);
        update CTList;
       // update CT;
       String CRON_EXP = '0 0 0 3 9 ? 2022';
       String strQuery = 'SELECT id,Account__r.parentID, Account__c,Parent_Transition_ID__c FROM Customer_Transition__c';
       CustomerTransitionHeirarchy cth = new CustomerTransitionHeirarchy (strQuery);
       String jobId = System.schedule('testBasicScheduledApex',CRON_EXP ,new CustomerTransitionHeirarchy());
       CustomerTransitionHeirarchy cthc = new CustomerTransitionHeirarchy ();
        
}
}