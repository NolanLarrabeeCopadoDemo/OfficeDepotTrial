@isTest
private class ACEComplianceVetting_Batch_TC 
{
    
    @testSetup static void setUpData(){	
    	Profile p = [select id from Profile where name='System Administrator' limit 1];
               
        User mgruser = new User(TimeZoneSidKey='America/Los_Angeles',ProfileId = p.id,LastName = 'ACE', FirstName = 'Manager', Email = 'ACE.manager@officedepot.com',Username ='ACE.manager@officedepot.com', Alias='test', CommunityNickname='test Approver', LanguageLocaleKey='en_US', LocaleSidKey='en_US', EmailEncodingKey='UTF-8', OD_Employee_ID__c='653466');
        Insert mgruser;

        User user = new User(TimeZoneSidKey='America/Los_Angeles',ProfileId = p.id,LastName = 'Rep', FirstName = 'ACE',Email='Rep.ACE@officedepot.com', Username ='Rep.ACE@officedepot.com', Alias='test12', CommunityNickname='test Approve', LanguageLocaleKey='en_US', EmailEncodingKey='UTF-8', LocaleSidKey='en_US',OD_Employee_ID__c='653486');
        Insert user;
        
         ACE_Settings__c desettings = new ACE_Settings__c(BatchName__c='Q4-2014');
         insert desettings; 
        
        //madhavi- tc
        Account ggpacc = new Account (
                         name = 'GGP SUN Test Account',
                         AOPS_Seq_ID__c = '1234566',
                         AOPS_Cust_Id__c = '1234566',
                         Oracle_Party_Id__c = '1234566',
                         Billingcountry = 'USA',
                         BillingState = 'UTT',
                         BillingStreet = '1040 N 326 WTT',
                         ownerid = user.id,
                         billingcity = 'OremTT');
         insert ggpacc;

         Account gpacc = new Account (
                         name = 'GP SUN Test Account',
                         AOPS_Seq_ID__c = '123457',
                         AOPS_Cust_Id__c = '123457',
                         Oracle_Party_Id__c = '123457',
             			 parentid=ggpacc.id,
                         Billingcountry = 'USA',
                         BillingState = 'UT',
                         BillingStreet = '1040 N 326 W',
                         ownerid = user.id,
                         billingcity = 'Orem');
         insert gpacc;
        
         Account pacc = new Account (
                         name = 'P SUN Test Account',
                         AOPS_Seq_ID__c = '123458',
                         AOPS_Cust_Id__c = '123458',
                         Oracle_Party_Id__c = '123458',
                         parentid=gpacc.id,
                         Billingcountry = 'USA',
                         BillingState = 'UT',
                         BillingStreet = '1040 N 326 W',
                         ownerid = user.id,
                         billingcity = 'Orem');
         insert pacc;
        
         Account acc = new Account (
                         name = 'SUN Test Account',
                         AOPS_Seq_ID__c = '123456',
                         AOPS_Cust_Id__c = '123456',
                         Oracle_Party_Id__c = '123456',
                         Billingcountry = 'USA',
                         parentid=pacc.id,
                         BillingState = 'UT',
                         BillingStreet = '1040 N 326 W',
                         ownerid = user.id,
                         billingcity = 'Orem');
         insert acc; 
        
         ACE_Customer_Price_Changes__c ace1 = new ACE_Customer_Price_Changes__c(
                                                Owning_Customer_Legal__c='T',
                                                name='Q4-2014',
                                                SRM_Differential__c=5,
                                                Item_12_Month_Qty__c = 50,
                                                Total_Spend_Impact_12_Month__c=5,
                                                Customer__c = acc.id, 
                                                Owning_Customer_ID__c ='123456',
                                                DSM__c = mgruser.id, 
                                                Approval_Type__c = 1,
                                                SFDC_Notification_Flag__c = '3');
         insert ace1;  
    }
    
    
    //Customer 'C' with Private Brand 'Y'
    static testMethod void myUnitTest1() 
    {
        Account acc = [select id from Account where name='SUN Test Account' limit 1];
        
    	contract c = new contract ();
        c.Name='test1';
        c.AccountId = acc.Id;
        c.Effective_Date_of_Original_Contract__c = system.today();
        c.Contract_Status__c = 'Active';
        c.Refer_to_Prior_CSF__c = '5676';
        c.Is_this_a_renewal__c = 'Yes';
        insert c;
     
        
        Contract_Pricing_Terms__c cp = new Contract_Pricing_Terms__c();
        cp.Relevant_Customer_Level__c= 'Child' ;
        cp.Contract__c = c.Id;
        cp.private_brand__c = true;
        cp.Departments__c= '01 - FURNITURE;03 - BINDERS';
        //cp.Departments__c= '05 - PAPER;14 - INKJET CARTRIDGES;51 - GENERAL OFFICE PAPER;52 - SPECIALTY PAPER;65 - TONERS/OTHER IMAGING';//madhavi
        cp.Active__c=true;        
        cp.Required_Timing_Of_CC_Updates__c = 'testing';
        cp.Vendor_Letter_Required_For_CC_Increase__c = 'trial';
        cp.Comm_Req_CC_Price_Chg__c = 'Notification and customer approval';
        cp.CC_Prc_Chg_Notice_Reqd_days__c = 3;
        cp.CC_Price_Incr_Cap_Pegd_To__c= 'Consumer Price Index (CPI)';
        cp.CC_Price_Incr_Capped__c = 'trial 5';
        insert cp;
        
        ACE_Compliance_Vetting__c comp = new ACE_Compliance_Vetting__c(
                                            Name = 'test',
                                            type__c = '',
                                            IN_Owning_Customer_Type__c = 'C',
                                            IN_Private_Brand__c = 'Y',
                                            IN_SKU_Dept__c = '1',
                                            IN_Owning_Customer_ID__c = '123456');
        insert comp;

     	integer batch_size = 1000;
     	ACEComplianceVetting_Batch aceBatch = new ACEComplianceVetting_Batch();
     	database.executebatch(aceBatch,batch_size);
     	String CRON_EXP = '0 0 0 3 9 ? 2022';
     	System.schedule('TestBatch1',CRON_EXP , aceBatch );
    }
    
    //Customer 'C' with Private Brand 'N'
    static testMethod void myUnitTest1_1() 
    {
        Account acc = [select id from Account where name='SUN Test Account' limit 1];
        
    	contract c = new contract ();
        c.Name='test1';
        c.AccountId = acc.Id;
        c.Effective_Date_of_Original_Contract__c = system.today();
        c.Contract_Status__c = 'Active';
        c.Refer_to_Prior_CSF__c = '5676';
        c.Is_this_a_renewal__c = 'Yes';
        insert c;
     
        
        Contract_Pricing_Terms__c cp = new Contract_Pricing_Terms__c();
        cp.Relevant_Customer_Level__c= 'Child' ;
        cp.Contract__c = c.Id;
        cp.private_brand__c = true;
        cp.Departments__c= '01 - FURNITURE;03 - BINDERS';
        //cp.Departments__c= '05 - PAPER;14 - INKJET CARTRIDGES;51 - GENERAL OFFICE PAPER;52 - SPECIALTY PAPER;65 - TONERS/OTHER IMAGING';//madhavi
        cp.Active__c=true;        
        cp.Required_Timing_Of_CC_Updates__c = 'testing';
        cp.Vendor_Letter_Required_For_CC_Increase__c = 'trial';
        cp.Comm_Req_CC_Price_Chg__c = 'Notification and customer approval';
        cp.CC_Prc_Chg_Notice_Reqd_days__c = 3;
        cp.CC_Price_Incr_Cap_Pegd_To__c= 'Consumer Price Index (CPI)';
        cp.CC_Price_Incr_Capped__c = 'trial 5';
        insert cp;
        
        ACE_Compliance_Vetting__c comp = new ACE_Compliance_Vetting__c(
                                            Name = 'test',
                                            type__c = '',
                                            IN_Owning_Customer_Type__c = 'C',
                                            IN_Private_Brand__c = 'N',
                                            IN_SKU_Dept__c = '1',
                                            IN_Owning_Customer_ID__c = '123456');
        insert comp;

     	integer batch_size = 1000;
     	ACEComplianceVetting_Batch aceBatch = new ACEComplianceVetting_Batch();
     	database.executebatch(aceBatch,batch_size);
     	String CRON_EXP = '0 0 0 3 9 ? 2022';
     	System.schedule('TestBatch1',CRON_EXP , aceBatch );
    }
    
    
    //Customer 'S' with Private Brand 'Y'
    static testMethod void myUnitTest1_2() 
    {
        Account acc = [select id from Account where name='SUN Test Account' limit 1];
        
    	contract c = new contract ();
        c.Name='test1';
        c.AccountId = acc.Id;
        c.Effective_Date_of_Original_Contract__c = system.today();
        c.Contract_Status__c = 'Active';
        c.Refer_to_Prior_CSF__c = '5676';
        c.Is_this_a_renewal__c = 'Yes';
        insert c;
     
        
        Contract_Pricing_Terms__c cp = new Contract_Pricing_Terms__c();
        cp.Relevant_Customer_Level__c= 'Standalone' ;
        cp.Contract__c = c.Id;
        cp.private_brand__c = true;
        cp.Departments__c= '01 - FURNITURE;03 - BINDERS';
        //cp.Departments__c= '05 - PAPER;14 - INKJET CARTRIDGES;51 - GENERAL OFFICE PAPER;52 - SPECIALTY PAPER;65 - TONERS/OTHER IMAGING';//madhavi
        cp.Active__c=true;        
        cp.Required_Timing_Of_CC_Updates__c = 'testing';
        cp.Vendor_Letter_Required_For_CC_Increase__c = 'trial';
        cp.Comm_Req_CC_Price_Chg__c = 'Notification and customer approval';
        cp.CC_Prc_Chg_Notice_Reqd_days__c = 3;
        cp.CC_Price_Incr_Cap_Pegd_To__c= 'Consumer Price Index (CPI)';
        cp.CC_Price_Incr_Capped__c = 'trial 5';
        insert cp;
        
        ACE_Compliance_Vetting__c comp = new ACE_Compliance_Vetting__c(
                                            Name = 'test',
                                            type__c = '',
                                            IN_Owning_Customer_Type__c = 'S',
                                            IN_Private_Brand__c = 'Y',
                                            IN_SKU_Dept__c = '1',
                                            IN_Owning_Customer_ID__c = '123456');
        insert comp;

     	integer batch_size = 1000;
     	ACEComplianceVetting_Batch aceBatch = new ACEComplianceVetting_Batch();
     	database.executebatch(aceBatch,batch_size);
     	String CRON_EXP = '0 0 0 3 9 ? 2022';
     	System.schedule('TestBatch1',CRON_EXP , aceBatch );
    }
    
    //Customer 'S' with Private Brand 'N'
    static testMethod void myUnitTest1_3() 
    {
        Account acc = [select id from Account where name='SUN Test Account' limit 1];
        
    	contract c = new contract ();
        c.Name='test1';
        c.AccountId = acc.Id;
        c.Effective_Date_of_Original_Contract__c = system.today();
        c.Contract_Status__c = 'Active';
        c.Refer_to_Prior_CSF__c = '5676';
        c.Is_this_a_renewal__c = 'Yes';
        insert c;
     
        
        Contract_Pricing_Terms__c cp = new Contract_Pricing_Terms__c();
        cp.Relevant_Customer_Level__c= 'Standalone' ;
        cp.Contract__c = c.Id;
        cp.private_brand__c = true;
        cp.Departments__c= '01 - FURNITURE;03 - BINDERS';
        //cp.Departments__c= '05 - PAPER;14 - INKJET CARTRIDGES;51 - GENERAL OFFICE PAPER;52 - SPECIALTY PAPER;65 - TONERS/OTHER IMAGING';//madhavi
        cp.Active__c=true;        
        cp.Required_Timing_Of_CC_Updates__c = 'testing';
        cp.Vendor_Letter_Required_For_CC_Increase__c = 'trial';
        cp.Comm_Req_CC_Price_Chg__c = 'Notification and customer approval';
        cp.CC_Prc_Chg_Notice_Reqd_days__c = 3;
        cp.CC_Price_Incr_Cap_Pegd_To__c= 'Consumer Price Index (CPI)';
        cp.CC_Price_Incr_Capped__c = 'trial 5';
        insert cp;
        
        ACE_Compliance_Vetting__c comp = new ACE_Compliance_Vetting__c(
                                            Name = 'test',
                                            type__c = '',
                                            IN_Owning_Customer_Type__c = 'S',
                                            IN_Private_Brand__c = 'N',
                                            IN_SKU_Dept__c = '1',
                                            IN_Owning_Customer_ID__c = '123456');
        insert comp;

     	integer batch_size = 1000;
     	ACEComplianceVetting_Batch aceBatch = new ACEComplianceVetting_Batch();
     	database.executebatch(aceBatch,batch_size);
     	String CRON_EXP = '0 0 0 3 9 ? 2022';
     	System.schedule('TestBatch1',CRON_EXP , aceBatch );
    }
    
    //Customer 'P' with Private Brand 'Y'
    static testMethod void myUnitTest2() 
    {
        Account pacc = [select id from Account where name='P SUN Test Account' limit 1];
        
        contract c = new contract ();
        c.Name='test1';
        c.AccountId = pacc.Id;
        c.Effective_Date_of_Original_Contract__c = system.today();
        c.Contract_Status__c = 'Active';
        c.Refer_to_Prior_CSF__c = '5676';
        c.Is_this_a_renewal__c = 'Yes';
        insert c;
     
        
        Contract_Pricing_Terms__c cp = new Contract_Pricing_Terms__c();
        cp.Relevant_Customer_Level__c= 'Parent' ;
        cp.Contract__c = c.Id;
        cp.private_brand__c = true;
        cp.Departments__c= '01 - FURNITURE;03 - BINDERS';
        cp.Active__c=true;        
        cp.Required_Timing_Of_CC_Updates__c = 'testing';
        cp.Vendor_Letter_Required_For_CC_Increase__c = 'trial';
        cp.Comm_Req_CC_Price_Chg__c = 'Notification and customer approval';
        cp.CC_Prc_Chg_Notice_Reqd_days__c = 3;
        cp.CC_Price_Incr_Cap_Pegd_To__c= 'Consumer Price Index (CPI)';
        cp.CC_Price_Incr_Capped__c = 'trial 5';
        insert cp;
        
         //IN_Owning_Customer_Type__c = 'P' is the only diff with myUnitTest
        ACE_Compliance_Vetting__c comp = new ACE_Compliance_Vetting__c(
                                            Name = 'test',
                                            type__c = '',
                                            IN_Owning_Customer_Type__c = 'C',
                                            IN_Private_Brand__c = 'Y',
                                            IN_SKU_Dept__c = '1',
                                            IN_Owning_Customer_ID__c = '123456');
        insert comp;	

     	integer batch_size = 1000;
     	ACEComplianceVetting_Batch aceBatch = new ACEComplianceVetting_Batch();
     	database.executebatch(aceBatch,batch_size);
     	String CRON_EXP = '0 0 0 3 9 ? 2022';
     	System.schedule('TestBatch1',CRON_EXP , aceBatch );
        
    }
    
    //Customer 'P' with Private Brand 'N'
    static testMethod void myUnitTest2_1() 
    {
        Account pacc = [select id from Account where name='P SUN Test Account' limit 1];
        
        contract c = new contract ();
        c.Name='test1';
        c.AccountId = pacc.Id;
        c.Effective_Date_of_Original_Contract__c = system.today();
        c.Contract_Status__c = 'Active';
        c.Refer_to_Prior_CSF__c = '5676';
        c.Is_this_a_renewal__c = 'Yes';
        insert c;
     
        
        Contract_Pricing_Terms__c cp = new Contract_Pricing_Terms__c();
        cp.Relevant_Customer_Level__c= 'Parent' ;
        cp.Contract__c = c.Id;
        cp.private_brand__c = true;
        cp.Departments__c= '01 - FURNITURE;03 - BINDERS';
        cp.Active__c=true;        
        cp.Required_Timing_Of_CC_Updates__c = 'testing';
        cp.Vendor_Letter_Required_For_CC_Increase__c = 'trial';
        cp.Comm_Req_CC_Price_Chg__c = 'Notification and customer approval';
        cp.CC_Prc_Chg_Notice_Reqd_days__c = 3;
        cp.CC_Price_Incr_Cap_Pegd_To__c= 'Consumer Price Index (CPI)';
        cp.CC_Price_Incr_Capped__c = 'trial 5';
        insert cp;
        
         //IN_Owning_Customer_Type__c = 'P' is the only diff with myUnitTest
        ACE_Compliance_Vetting__c comp = new ACE_Compliance_Vetting__c(
                                            Name = 'test',
                                            type__c = '',
                                            IN_Owning_Customer_Type__c = 'C',
                                            IN_Private_Brand__c = 'N',
                                            IN_SKU_Dept__c = '1',
                                            IN_Owning_Customer_ID__c = '123456');
        insert comp;	

     	integer batch_size = 1000;
     	ACEComplianceVetting_Batch aceBatch = new ACEComplianceVetting_Batch();
     	database.executebatch(aceBatch,batch_size);
     	String CRON_EXP = '0 0 0 3 9 ? 2022';
     	System.schedule('TestBatch1',CRON_EXP , aceBatch );
        
    }
    
    //Customer 'GP' with Private Brand 'Y'
    static testMethod void myUnitTest3() 
    {
        Account gpacc = [select id from Account where name='GP SUN Test Account' limit 1];
        
        contract c = new contract ();
        c.Name='test1';
        c.AccountId = gpacc.Id;
        c.Effective_Date_of_Original_Contract__c = system.today();
        c.Contract_Status__c = 'Active';
        c.Refer_to_Prior_CSF__c = '5676';
        c.Is_this_a_renewal__c = 'Yes';
        insert c;
     
        
        Contract_Pricing_Terms__c cp = new Contract_Pricing_Terms__c();
        cp.Relevant_Customer_Level__c= 'Grandparent' ;
        cp.Contract__c = c.Id;
        cp.private_brand__c = true;
        cp.Departments__c= '01 - FURNITURE;03 - BINDERS';
        cp.Active__c=true;        
        cp.Required_Timing_Of_CC_Updates__c = 'testing';
        cp.Vendor_Letter_Required_For_CC_Increase__c = 'trial';
        cp.Comm_Req_CC_Price_Chg__c = 'Notification and customer approval';
        cp.CC_Prc_Chg_Notice_Reqd_days__c = 3;
        cp.CC_Price_Incr_Cap_Pegd_To__c= 'Consumer Price Index (CPI)';
        cp.CC_Price_Incr_Capped__c = 'trial 5';
        insert cp;   
         

         //IN_Owning_Customer_Type__c = 'P' is the only diff with myUnitTest
        ACE_Compliance_Vetting__c comp = new ACE_Compliance_Vetting__c(
                                            Name = 'test',
                                            type__c = '',
                                            IN_Owning_Customer_Type__c = 'C',
                                            IN_Private_Brand__c = 'Y',
                                            IN_SKU_Dept__c = '1',
                                            IN_Owning_Customer_ID__c = '123456');
        insert comp;	

     	integer batch_size = 1000;
     	ACEComplianceVetting_Batch aceBatch = new ACEComplianceVetting_Batch();
     	database.executebatch(aceBatch,batch_size);
     	String CRON_EXP = '0 0 0 3 9 ? 2022';
     	System.schedule('TestBatch1',CRON_EXP , aceBatch ); 
        
    }
    
    //Customer 'GP' with Private Brand 'N'
    static testMethod void myUnitTest3_1() 
    {
        Account gpacc = [select id from Account where name='GP SUN Test Account' limit 1];
        
        contract c = new contract ();
        c.Name='test1';
        c.AccountId = gpacc.Id;
        c.Effective_Date_of_Original_Contract__c = system.today();
        c.Contract_Status__c = 'Active';
        c.Refer_to_Prior_CSF__c = '5676';
        c.Is_this_a_renewal__c = 'Yes';
        insert c;
     
        
        Contract_Pricing_Terms__c cp = new Contract_Pricing_Terms__c();
        cp.Relevant_Customer_Level__c= 'Grandparent' ;
        cp.Contract__c = c.Id;
        cp.private_brand__c = true;
        cp.Departments__c= '01 - FURNITURE;03 - BINDERS';
        cp.Active__c=true;        
        cp.Required_Timing_Of_CC_Updates__c = 'testing';
        cp.Vendor_Letter_Required_For_CC_Increase__c = 'trial';
        cp.Comm_Req_CC_Price_Chg__c = 'Notification and customer approval';
        cp.CC_Prc_Chg_Notice_Reqd_days__c = 3;
        cp.CC_Price_Incr_Cap_Pegd_To__c= 'Consumer Price Index (CPI)';
        cp.CC_Price_Incr_Capped__c = 'trial 5';
        insert cp;        
        
        ACE_Compliance_Vetting__c comp = new ACE_Compliance_Vetting__c(
                                            Name = 'test',
                                            type__c = '',
                                            IN_Owning_Customer_Type__c = 'C',
                                            IN_Private_Brand__c = 'N',
                                            IN_SKU_Dept__c = '1',
                                            IN_Owning_Customer_ID__c = '123456');
        insert comp;	

     	integer batch_size = 1000;
     	ACEComplianceVetting_Batch aceBatch = new ACEComplianceVetting_Batch();
     	database.executebatch(aceBatch,batch_size);
     	String CRON_EXP = '0 0 0 3 9 ? 2022';
     	System.schedule('TestBatch1',CRON_EXP , aceBatch ); 
        
    }
    
    //Customer 'GGP' with Private Brand 'Y'
    static testMethod void myUnitTest4() 
    {
        Account ggpacc = [select id from Account where name='GGP SUN Test Account' limit 1];
        
        contract c = new contract ();
        c.Name='test1';
        c.AccountId = ggpacc.Id;
        c.Effective_Date_of_Original_Contract__c = system.today();
        c.Contract_Status__c = 'Active';
        c.Refer_to_Prior_CSF__c = '5676';
        c.Is_this_a_renewal__c = 'Yes';
        insert c;
     
        
        Contract_Pricing_Terms__c cp = new Contract_Pricing_Terms__c();
        cp.Relevant_Customer_Level__c= 'GreatGrandParent' ;
        cp.Contract__c = c.Id;
        cp.private_brand__c = true;
        cp.Departments__c= '01 - FURNITURE;03 - BINDERS';
        cp.Active__c=true;        
        cp.Required_Timing_Of_CC_Updates__c = 'testing';
        cp.Vendor_Letter_Required_For_CC_Increase__c = 'trial';
        cp.Comm_Req_CC_Price_Chg__c = 'Notification and customer approval';
        cp.CC_Prc_Chg_Notice_Reqd_days__c = 3;
        cp.CC_Price_Incr_Cap_Pegd_To__c= 'Consumer Price Index (CPI)';
        cp.CC_Price_Incr_Capped__c = 'trial 5';
        insert cp;           

         //IN_Owning_Customer_Type__c = 'P' is the only diff with myUnitTest
        ACE_Compliance_Vetting__c comp = new ACE_Compliance_Vetting__c(
                                            Name = 'test',
                                            type__c = '',
                                            IN_Owning_Customer_Type__c = 'C',
                                            IN_Private_Brand__c = 'Y',
                                            IN_SKU_Dept__c = '1',
                                            IN_Owning_Customer_ID__c = '123456');
        insert comp;	

     	integer batch_size = 1000;
     	ACEComplianceVetting_Batch aceBatch = new ACEComplianceVetting_Batch();
     	database.executebatch(aceBatch,batch_size);
     	String CRON_EXP = '0 0 0 3 9 ? 2022';
     	System.schedule('TestBatch1',CRON_EXP , aceBatch );
        
    }
    
    //Customer 'GGP' with Private Brand 'N'
    static testMethod void myUnitTest4_1() 
    {
        Account ggpacc = [select id from Account where name='GGP SUN Test Account' limit 1];
        
        contract c = new contract ();
        c.Name='test1';
        c.AccountId = ggpacc.Id;
        c.Effective_Date_of_Original_Contract__c = system.today();
        c.Contract_Status__c = 'Active';
        c.Refer_to_Prior_CSF__c = '5676';
        c.Is_this_a_renewal__c = 'Yes';
        insert c;
     
        
        Contract_Pricing_Terms__c cp = new Contract_Pricing_Terms__c();
        cp.Relevant_Customer_Level__c= 'GreatGrandParent' ;
        cp.Contract__c = c.Id;
        cp.private_brand__c = true;
        cp.Departments__c= '01 - FURNITURE;03 - BINDERS';
        cp.Active__c=true;        
        cp.Required_Timing_Of_CC_Updates__c = 'testing';
        cp.Vendor_Letter_Required_For_CC_Increase__c = 'trial';
        cp.Comm_Req_CC_Price_Chg__c = 'Notification and customer approval';
        cp.CC_Prc_Chg_Notice_Reqd_days__c = 3;
        cp.CC_Price_Incr_Cap_Pegd_To__c= 'Consumer Price Index (CPI)';
        cp.CC_Price_Incr_Capped__c = 'trial 5';
        insert cp;           

         //IN_Owning_Customer_Type__c = 'P' is the only diff with myUnitTest
        ACE_Compliance_Vetting__c comp = new ACE_Compliance_Vetting__c(
                                            Name = 'test',
                                            type__c = '',
                                            IN_Owning_Customer_Type__c = 'C',
                                            IN_Private_Brand__c = 'N',
                                            IN_SKU_Dept__c = '1',
                                            IN_Owning_Customer_ID__c = '123456');
        insert comp;	

     	integer batch_size = 1000;
     	ACEComplianceVetting_Batch aceBatch = new ACEComplianceVetting_Batch();
     	database.executebatch(aceBatch,batch_size);
     	String CRON_EXP = '0 0 0 3 9 ? 2022';
     	System.schedule('TestBatch1',CRON_EXP , aceBatch );
        
    }
    
    
   /* static testMethod void myUnitTest() 
    {
        Profile p = [select id from Profile where name='System Administrator' limit 1];
               
        User mgruser = new User(TimeZoneSidKey='America/Los_Angeles',ProfileId = p.id,LastName = 'ACE', FirstName = 'Manager', Email = 'ACE.manager@officedepot.com',Username ='ACE.manager@officedepot.com', Alias='test', CommunityNickname='test Approver', LanguageLocaleKey='en_US', LocaleSidKey='en_US', EmailEncodingKey='UTF-8', OD_Employee_ID__c='653466');
        Insert mgruser;

        User user = new User(TimeZoneSidKey='America/Los_Angeles',ProfileId = p.id,LastName = 'Rep', FirstName = 'ACE',Email='Rep.ACE@officedepot.com', Username ='Rep.ACE@officedepot.com', Alias='test12', CommunityNickname='test Approve', LanguageLocaleKey='en_US', EmailEncodingKey='UTF-8', LocaleSidKey='en_US',OD_Employee_ID__c='653486');
        Insert user;
        
         ACE_Settings__c desettings = new ACE_Settings__c(BatchName__c='Q4-2014');
         insert desettings; 
        
        //madhavi- tc
        Account ggpacc = new Account (
                         name = 'GP SUN Test Account',
                         AOPS_Seq_ID__c = '1234566',
                         AOPS_Cust_Id__c = '1234566',
                         Oracle_Party_Id__c = '1234566',
                         Billingcountry = 'USA',
                         BillingState = 'UTT',
                         BillingStreet = '1040 N 326 WTT',
                         ownerid = user.id,
                         billingcity = 'OremTT');
         insert ggpacc;

         Account gpacc = new Account (
                         name = 'GP SUN Test Account',
                         AOPS_Seq_ID__c = '123457',
                         AOPS_Cust_Id__c = '123457',
                         Oracle_Party_Id__c = '123457',
             			 parentid=ggpacc.id,
                         Billingcountry = 'USA',
                         BillingState = 'UT',
                         BillingStreet = '1040 N 326 W',
                         ownerid = user.id,
                         billingcity = 'Orem');
         insert gpacc;
        
         Account pacc = new Account (
                         name = 'P SUN Test Account',
                         AOPS_Seq_ID__c = '123458',
                         AOPS_Cust_Id__c = '123458',
                         Oracle_Party_Id__c = '123458',
                         parentid=gpacc.id,
                         Billingcountry = 'USA',
                         BillingState = 'UT',
                         BillingStreet = '1040 N 326 W',
                         ownerid = user.id,
                         billingcity = 'Orem');
         insert pacc;
        
         Account acc = new Account (
                         name = 'SUN Test Account',
                         AOPS_Seq_ID__c = '123456',
                         AOPS_Cust_Id__c = '123456',
                         Oracle_Party_Id__c = '123456',
                         Billingcountry = 'USA',
                         parentid=pacc.id,
                         BillingState = 'UT',
                         BillingStreet = '1040 N 326 W',
                         ownerid = user.id,
                         billingcity = 'Orem');
         insert acc;

        contract c = new contract ();
        c.Name='test1';
        c.AccountId = acc.Id;
        c.Effective_Date_of_Original_Contract__c = system.today();
        c.Contract_Status__c = 'Active';//madhavi
        insert c;
     
        
        Contract_Pricing_Terms__c cp = new Contract_Pricing_Terms__c();
        cp.Relevant_Customer_Level__c= 'Child' ;
        cp.Contract__c = c.Id;
        cp.private_brand__c = true;
        cp.Departments__c= '01 - FURNITURE;03 - BINDERS';
        //cp.Departments__c= '05 - PAPER;14 - INKJET CARTRIDGES;51 - GENERAL OFFICE PAPER;52 - SPECIALTY PAPER;65 - TONERS/OTHER IMAGING';//madhavi
        cp.Active__c=true;        
        cp.Required_Timing_Of_CC_Updates__c = 'testing';
        cp.Vendor_Letter_Required_For_CC_Increase__c = 'trial';
        cp.Comm_Req_CC_Price_Chg__c = 'Notification and customer approval';
        cp.CC_Prc_Chg_Notice_Reqd_days__c = 3;
        cp.CC_Price_Incr_Cap_Pegd_To__c= 'Consumer Price Index (CPI)';
        cp.CC_Price_Incr_Capped__c = 'trial 5';
        insert cp;
    
         ACE_Customer_Price_Changes__c ace1 = new ACE_Customer_Price_Changes__c(
                                                Owning_Customer_Legal__c='T',
                                                name='Q4-2014',
                                                SRM_Differential__c=5,
                                                Item_12_Month_Qty__c = 50,
                                                Total_Spend_Impact_12_Month__c=5,
                                                Customer__c = acc.id, 
                                                Owning_Customer_ID__c ='123456',
                                                DSM__c = mgruser.id, 
                                                Approval_Type__c = 1,
                                                SFDC_Notification_Flag__c = '3');
         insert ace1;  

        //IN_Owning_Customer_Type__c = 'C' is the only diff with myUnitTest1
        ACE_Compliance_Vetting__c comp = new ACE_Compliance_Vetting__c(
                                            Name = 'test',
                                            type__c = '',
                                            IN_Owning_Customer_Type__c = 'C',
                                            IN_Private_Brand__c = 'Y',
                                            IN_SKU_Dept__c = '1',
                                            IN_Owning_Customer_ID__c = '123456');
        insert comp;

     integer batch_size = 1000;
     ACEComplianceVetting_Batch aceBatch = new ACEComplianceVetting_Batch();
     database.executebatch(aceBatch,batch_size);
     String CRON_EXP = '0 0 0 3 9 ? 2022';
     System.schedule('TestBatch1',CRON_EXP , aceBatch );

    }

    static testMethod void myUnitTest1() 
    {
        Profile p = [select id from Profile where name='System Administrator' limit 1];
               
        User mgruser = new User(TimeZoneSidKey='America/Los_Angeles',ProfileId = p.id,LastName = 'ACE', FirstName = 'Manager', Email = 'ACE.manager@officedepot.com',Username ='ACE.manager@officedepot.com', Alias='test', CommunityNickname='test Approver', LanguageLocaleKey='en_US', LocaleSidKey='en_US', EmailEncodingKey='UTF-8', OD_Employee_ID__c='653466');
        Insert mgruser;

        User user = new User(TimeZoneSidKey='America/Los_Angeles',ProfileId = p.id,LastName = 'Rep', FirstName = 'ACE',Email='Rep.ACE@officedepot.com', Username ='Rep.ACE@officedepot.com', Alias='test12', CommunityNickname='test Approve', LanguageLocaleKey='en_US', EmailEncodingKey='UTF-8', LocaleSidKey='en_US',OD_Employee_ID__c='653486');
        Insert user;
        
         ACE_Settings__c desettings = new ACE_Settings__c(BatchName__c='Q4-2014');
         insert desettings;
        
         Account ggpacc = new Account (
                         name = 'GP SUN Test Account',
                         AOPS_Seq_ID__c = '1234566',
                         AOPS_Cust_Id__c = '1234566',
                         Oracle_Party_Id__c = '1234566',
                         Billingcountry = 'USA',
                         BillingState = 'UTT',
                         BillingStreet = '1040 N 326 WTT',
                         ownerid = user.id,
                         billingcity = 'OremTT');//madhavi-tc - added GGP
         insert ggpacc;

         Account gpacc = new Account (
                         name = 'GP SUN Test Account',
                         AOPS_Seq_ID__c = '123457',
                         AOPS_Cust_Id__c = '123457',
                         Oracle_Party_Id__c = '123457',
             			 parentid=ggpacc.id,//madhavi-tc
                         Billingcountry = 'USA',
                         BillingState = 'UT',
                         BillingStreet = '1040 N 326 W',
                         ownerid = user.id,
                         billingcity = 'Orem');
         insert gpacc;
         Account pacc = new Account (
                         name = 'P SUN Test Account',
                         AOPS_Seq_ID__c = '123458',
                         AOPS_Cust_Id__c = '123458',
                         Oracle_Party_Id__c = '123458',
                         parentid=gpacc.id,
                         Billingcountry = 'USA',
                         BillingState = 'UT',
                         BillingStreet = '1040 N 326 W',
                         ownerid = user.id,
                         billingcity = 'Orem');
         insert pacc;
         Account acc = new Account (
                         name = 'SUN Test Account',
                         AOPS_Seq_ID__c = '123456',
                         AOPS_Cust_Id__c = '123456',
                         Oracle_Party_Id__c = '123456',
                         Billingcountry = 'USA',
                         parentid=pacc.id,
                         BillingState = 'UT',
                         BillingStreet = '1040 N 326 W',
                         ownerid = user.id,
                         billingcity = 'Orem');
         insert acc;

        contract c = new contract ();
        c.Name='test1';
        c.AccountId = pacc.Id;
        c.Effective_Date_of_Original_Contract__c = system.today();
        c.Contract_Status__c = 'Active';//madhavi
        insert c;
     
        
        Contract_Pricing_Terms__c cp = new Contract_Pricing_Terms__c();
        cp.Relevant_Customer_Level__c= 'Parent' ;//madhavi
        cp.Contract__c = c.Id;
        cp.private_brand__c = true;
        cp.Departments__c= '01 - FURNITURE;03 - BINDERS';
        cp.Active__c=true;        
        cp.Required_Timing_Of_CC_Updates__c = 'testing';
        cp.Vendor_Letter_Required_For_CC_Increase__c = 'trial';
        cp.Comm_Req_CC_Price_Chg__c = 'Notification and customer approval';
        cp.CC_Prc_Chg_Notice_Reqd_days__c = 3;
        cp.CC_Price_Incr_Cap_Pegd_To__c= 'Consumer Price Index (CPI)';
        cp.CC_Price_Incr_Capped__c = 'trial 5';
        insert cp;
    
         ACE_Customer_Price_Changes__c ace1 = new ACE_Customer_Price_Changes__c(
                                                Owning_Customer_Legal__c='T',
                                                name='Q4-2014',
                                                SRM_Differential__c=5,
                                                Item_12_Month_Qty__c = 50,
                                                Total_Spend_Impact_12_Month__c=5,
                                                Customer__c = acc.id, 
                                                Owning_Customer_ID__c ='123456',
                                                DSM__c = mgruser.id, 
                                                Approval_Type__c = 1,
                                                SFDC_Notification_Flag__c = '3');
         insert ace1;  

         //IN_Owning_Customer_Type__c = 'P' is the only diff with myUnitTest
        ACE_Compliance_Vetting__c comp = new ACE_Compliance_Vetting__c(
                                            Name = 'test',
                                            type__c = '',
                                            IN_Owning_Customer_Type__c = 'P',
                                            IN_Private_Brand__c = 'Y',
                                            IN_SKU_Dept__c = '1',
                                            IN_Owning_Customer_ID__c = '123456');
        insert comp;	

     integer batch_size = 1000;
     ACEComplianceVetting_Batch aceBatch = new ACEComplianceVetting_Batch();
     database.executebatch(aceBatch,batch_size);
     String CRON_EXP = '0 0 0 3 9 ? 2022';
     System.schedule('TestBatch1',CRON_EXP , aceBatch );

    }
    
    static testMethod void myUnitTest2() 
    {
        Profile p = [select id from Profile where name='System Administrator' limit 1];
               
        User mgruser = new User(TimeZoneSidKey='America/Los_Angeles',ProfileId = p.id,LastName = 'ACE', FirstName = 'Manager', Email = 'ACE.manager@officedepot.com',Username ='ACE.manager@officedepot.com', Alias='test', CommunityNickname='test Approver', LanguageLocaleKey='en_US', LocaleSidKey='en_US', EmailEncodingKey='UTF-8', OD_Employee_ID__c='653466');
        Insert mgruser;

        User user = new User(TimeZoneSidKey='America/Los_Angeles',ProfileId = p.id,LastName = 'Rep', FirstName = 'ACE',Email='Rep.ACE@officedepot.com', Username ='Rep.ACE@officedepot.com', Alias='test12', CommunityNickname='test Approve', LanguageLocaleKey='en_US', EmailEncodingKey='UTF-8', LocaleSidKey='en_US',OD_Employee_ID__c='653486');
        Insert user;
        
         ACE_Settings__c desettings = new ACE_Settings__c(BatchName__c='Q4-2014');
         insert desettings;
        
         Account ggpacc = new Account (
                         name = 'GP SUN Test Account',
                         AOPS_Seq_ID__c = '1234566',
                         AOPS_Cust_Id__c = '1234566',
                         Oracle_Party_Id__c = '1234566',
                         Billingcountry = 'USA',
                         BillingState = 'UTT',
                         BillingStreet = '1040 N 326 WTT',
                         ownerid = user.id,
                         billingcity = 'OremTT');
         insert ggpacc;

         Account gpacc = new Account (
                         name = 'GP SUN Test Account',
                         AOPS_Seq_ID__c = '123457',
                         AOPS_Cust_Id__c = '123457',
                         Oracle_Party_Id__c = '123457',
             			 parentid=ggpacc.id,//madhavi-tc
                         Billingcountry = 'USA',
                         BillingState = 'UT',
                         BillingStreet = '1040 N 326 W',
                         ownerid = user.id,
                         billingcity = 'Orem');
         insert gpacc;
         Account pacc = new Account (
                         name = 'P SUN Test Account',
                         AOPS_Seq_ID__c = '123458',
                         AOPS_Cust_Id__c = '123458',
                         Oracle_Party_Id__c = '123458',
                         parentid=gpacc.id,
                         Billingcountry = 'USA',
                         BillingState = 'UT',
                         BillingStreet = '1040 N 326 W',
                         ownerid = user.id,
                         billingcity = 'Orem');
         insert pacc;
         Account acc = new Account (
                         name = 'SUN Test Account',
                         AOPS_Seq_ID__c = '123456',
                         AOPS_Cust_Id__c = '123456',
                         Oracle_Party_Id__c = '123456',
                         Billingcountry = 'USA',
                         parentid=pacc.id,
                         BillingState = 'UT',
                         BillingStreet = '1040 N 326 W',
                         ownerid = user.id,
                         billingcity = 'Orem');
         insert acc;

        contract c = new contract ();
        c.Name='test1';
        c.AccountId = gpacc.Id;
        c.Effective_Date_of_Original_Contract__c = system.today();
        c.Contract_Status__c = 'Active';//madhavi
        insert c;
     
        
        Contract_Pricing_Terms__c cp = new Contract_Pricing_Terms__c();
        cp.Relevant_Customer_Level__c= 'Grandparent' ;
        cp.Contract__c = c.Id;
        cp.private_brand__c = true;
        cp.Departments__c= '01 - FURNITURE;03 - BINDERS';
        cp.Active__c=true;        
        cp.Required_Timing_Of_CC_Updates__c = 'testing';
        cp.Vendor_Letter_Required_For_CC_Increase__c = 'trial';
        cp.Comm_Req_CC_Price_Chg__c = 'Notification and customer approval';
        cp.CC_Prc_Chg_Notice_Reqd_days__c = 3;
        cp.CC_Price_Incr_Cap_Pegd_To__c= 'Consumer Price Index (CPI)';
        cp.CC_Price_Incr_Capped__c = 'trial 5';
        insert cp;
    
         ACE_Customer_Price_Changes__c ace1 = new ACE_Customer_Price_Changes__c(
                                                Owning_Customer_Legal__c='T',
                                                name='Q4-2014',
                                                SRM_Differential__c=5,
                                                Item_12_Month_Qty__c = 50,
                                                Total_Spend_Impact_12_Month__c=5,
                                                Customer__c = acc.id, 
                                                Owning_Customer_ID__c ='123456',
                                                DSM__c = mgruser.id, 
                                                Approval_Type__c = 1,
                                                SFDC_Notification_Flag__c = '3');
         insert ace1;  

         //IN_Owning_Customer_Type__c = 'P' is the only diff with myUnitTest
        ACE_Compliance_Vetting__c comp = new ACE_Compliance_Vetting__c(
                                            Name = 'test',
                                            type__c = '',
                                            IN_Owning_Customer_Type__c = 'GP',
                                            IN_Private_Brand__c = 'Y',
                                            IN_SKU_Dept__c = '1',
                                            IN_Owning_Customer_ID__c = '123456');
        insert comp;	

     integer batch_size = 1000;
     ACEComplianceVetting_Batch aceBatch = new ACEComplianceVetting_Batch();
     database.executebatch(aceBatch,batch_size);
     String CRON_EXP = '0 0 0 3 9 ? 2022';
     System.schedule('TestBatch1',CRON_EXP , aceBatch );

    }
    
    static testMethod void myUnitTest3() 
    {
        Profile p = [select id from Profile where name='System Administrator' limit 1];
               
        User mgruser = new User(TimeZoneSidKey='America/Los_Angeles',ProfileId = p.id,LastName = 'ACE', FirstName = 'Manager', Email = 'ACE.manager@officedepot.com',Username ='ACE.manager@officedepot.com', Alias='test', CommunityNickname='test Approver', LanguageLocaleKey='en_US', LocaleSidKey='en_US', EmailEncodingKey='UTF-8', OD_Employee_ID__c='653466');
        Insert mgruser;

        User user = new User(TimeZoneSidKey='America/Los_Angeles',ProfileId = p.id,LastName = 'Rep', FirstName = 'ACE',Email='Rep.ACE@officedepot.com', Username ='Rep.ACE@officedepot.com', Alias='test12', CommunityNickname='test Approve', LanguageLocaleKey='en_US', EmailEncodingKey='UTF-8', LocaleSidKey='en_US',OD_Employee_ID__c='653486');
        Insert user;
        
         ACE_Settings__c desettings = new ACE_Settings__c(BatchName__c='Q4-2014');
         insert desettings;
        
         Account ggpacc = new Account (
                         name = 'GP SUN Test Account',
                         AOPS_Seq_ID__c = '1234566',
                         AOPS_Cust_Id__c = '1234566',
                         Oracle_Party_Id__c = '1234566',
                         Billingcountry = 'USA',
                         BillingState = 'UTT',
                         BillingStreet = '1040 N 326 WTT',
                         ownerid = user.id,
                         billingcity = 'OremTT');
         insert ggpacc;

         Account gpacc = new Account (
                         name = 'GP SUN Test Account',
                         AOPS_Seq_ID__c = '123457',
                         AOPS_Cust_Id__c = '123457',
                         Oracle_Party_Id__c = '123457',
             			 parentid=ggpacc.id,//madhavi-tc
                         Billingcountry = 'USA',
                         BillingState = 'UT',
                         BillingStreet = '1040 N 326 W',
                         ownerid = user.id,
                         billingcity = 'Orem');
         insert gpacc;
         Account pacc = new Account (
                         name = 'P SUN Test Account',
                         AOPS_Seq_ID__c = '123458',
                         AOPS_Cust_Id__c = '123458',
                         Oracle_Party_Id__c = '123458',
                         parentid=gpacc.id,
                         Billingcountry = 'USA',
                         BillingState = 'UT',
                         BillingStreet = '1040 N 326 W',
                         ownerid = user.id,
                         billingcity = 'Orem');
         insert pacc;
         Account acc = new Account (
                         name = 'SUN Test Account',
                         AOPS_Seq_ID__c = '123456',
                         AOPS_Cust_Id__c = '123456',
                         Oracle_Party_Id__c = '123456',
                         Billingcountry = 'USA',
                         parentid=pacc.id,
                         BillingState = 'UT',
                         BillingStreet = '1040 N 326 W',
                         ownerid = user.id,
                         billingcity = 'Orem');
         insert acc;

        contract c = new contract ();
        c.Name='test1';
        c.AccountId = ggpacc.Id;
        c.Effective_Date_of_Original_Contract__c = system.today();
        c.Contract_Status__c = 'Active';//madhavi
        insert c;
     
        
        Contract_Pricing_Terms__c cp = new Contract_Pricing_Terms__c();
        cp.Relevant_Customer_Level__c= 'GreatGrandParent' ;
        cp.Contract__c = c.Id;
        cp.private_brand__c = true;
        cp.Departments__c= '01 - FURNITURE;03 - BINDERS';
        cp.Active__c=true;        
        cp.Required_Timing_Of_CC_Updates__c = 'testing';
        cp.Vendor_Letter_Required_For_CC_Increase__c = 'trial';
        cp.Comm_Req_CC_Price_Chg__c = 'Notification and customer approval';
        cp.CC_Prc_Chg_Notice_Reqd_days__c = 3;
        cp.CC_Price_Incr_Cap_Pegd_To__c= 'Consumer Price Index (CPI)';
        cp.CC_Price_Incr_Capped__c = 'trial 5';
        insert cp;
    
         ACE_Customer_Price_Changes__c ace1 = new ACE_Customer_Price_Changes__c(
                                                Owning_Customer_Legal__c='T',
                                                name='Q4-2014',
                                                SRM_Differential__c=5,
                                                Item_12_Month_Qty__c = 50,
                                                Total_Spend_Impact_12_Month__c=5,
                                                Customer__c = acc.id, 
                                                Owning_Customer_ID__c ='123456',
                                                DSM__c = mgruser.id, 
                                                Approval_Type__c = 1,
                                                SFDC_Notification_Flag__c = '3');
         insert ace1;  

         //IN_Owning_Customer_Type__c = 'P' is the only diff with myUnitTest
        ACE_Compliance_Vetting__c comp = new ACE_Compliance_Vetting__c(
                                            Name = 'test',
                                            type__c = '',
                                            IN_Owning_Customer_Type__c = 'GGP',
                                            IN_Private_Brand__c = 'Y',
                                            IN_SKU_Dept__c = '1',
                                            IN_Owning_Customer_ID__c = '123456');
        insert comp;	

     integer batch_size = 1000;
     ACEComplianceVetting_Batch aceBatch = new ACEComplianceVetting_Batch();
     database.executebatch(aceBatch,batch_size);
     String CRON_EXP = '0 0 0 3 9 ? 2022';
     System.schedule('TestBatch1',CRON_EXP , aceBatch );

    }*/
    
    
}