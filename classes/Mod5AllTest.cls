@isTest
private class Mod5AllTest 
{
    
        static testMethod void validTestMethod()
        {
        
        // executeoncetest.bypassAccountExtension = true;
        
         List<Account> accounts = new List<Account>();
         List<Account> sites = new List<Account>();
         List<Contact> contacts = new List<Contact>();
         List<Customer_Transition__c> ctList = new List<Customer_Transition__c>();
         List<Customer_Transition_Dtls__c> ctdList = new List<Customer_Transition_Dtls__c>();
         
         // CustTransParentChildLevel__c Custom Setting record
            CustTransParentChildLevel__c custSettingRecord = new CustTransParentChildLevel__c();
            custSettingRecord.name = 'Parent';
            custSettingRecord.Mod5LaunchBatchInterval__c = 600;
            insert custSettingRecord;
         
         Schema.DescribeSObjectResult d1 = Schema.SObjectType.Account; 
         Map<String,Schema.RecordTypeInfo> rtMapByName = d1.getRecordTypeInfosByName(); 
         Id DtlsSiteRcdTypeID = Schema.SObjectType.Customer_Transition_Dtls__c.getRecordTypeInfosByName().get('Sites').getRecordTypeId();
         Id DtlsPOsRcdTypeID = Schema.SObjectType.Customer_Transition_Dtls__c.getRecordTypeInfosByName().get('Purchase Order').getRecordTypeId();
         Id DtlsCCsRcdTypeID = Schema.SObjectType.Customer_Transition_Dtls__c.getRecordTypeInfosByName().get('Cost Center').getRecordTypeId();
         
         Profile profileObj = [select id from profile where name='System Administrator'];

         String profId = profileObj.id;
         user usrObj = new user(Username='abc@officedepot.com.uat',FirstName ='Fname', LastName='Lname', Alias='abc', CommunityNickname='abc', LocaleSidKey='en_US', EmailEncodingKey='UTF-8', Profileid = profId, LanguageLocaleKey='en_US', email='abc@officedepot.com.uat',TimeZoneSidKey='America/New_York');
         usrObj.Short_Title__c='';
         Insert usrObj;
                  
        Sales_Person__c s= new Sales_Person__c();
        s.IsActive__c=true;
        s.Role_Relate_Id__c ='333333';
        s.Primary__c =true;
        s.user__c=usrObj.id;
        insert s;         
                  
        System.runAs(usrObj)
        {
            
            Account acc = new Account ();
            acc.name = 'SUN Test Account';
            acc.BillingStreet = '1040 N 326 W';
            acc.billingcity = 'Orem';
            acc.BillingState = 'UT';
            acc.Billingcountry = 'USA';
            acc.OMX_Primary_Key__c = '123457';
            acc.Oracle_Party_Id__c = '123457';
            acc.AOPS_Cust_Id__c = '123457';
            acc.status__c='Active';
            acc.Split_Record__c = true;
            acc.Segment__c='Federal';
            acc.Sales_PersonID__c=s.id;
            accounts.add(acc);
            
            insert accounts;
            
            Account accSite1 = new Account ();
            accSite1.name = 'SUN Test Account21';
            accSite1.recordtypeid=rtMapByName.get('Site').getRecordTypeId(); 
            accSite1.BillingStreet = '1040 N 326 W';
            accSite1.billingcity = 'Orem';
            accSite1.BillingState = 'UT';
            accSite1.Billingcountry = 'USA';
            accSite1.OMX_Primary_Key__c = '123460';
            accSite1.Oracle_Party_Id__c = '123460';
            accSite1.AOPS_Cust_Id__c = '123460';
            accSite1.status__c='Active';
            accSite1.Related_Account__c = acc.Id;
            sites.add(accSite1);
            
            Account accSite2 = new Account ();
            accSite2.name = 'SUN Test Account22';
            accSite2.recordtypeid=rtMapByName.get('Site').getRecordTypeId(); 
            accSite2.BillingStreet = '1040 N 326 W';
            accSite2.billingcity = 'Orem';
            accSite2.BillingState = 'UT';
            accSite2.Billingcountry = 'USA';
            accSite2.OMX_Primary_Key__c = '123461';
            accSite2.Oracle_Party_Id__c = '123461';
            accSite2.AOPS_Cust_Id__c = '123461';
            accSite2.status__c='Active';
            accSite2.Related_Account__c = acc.Id;
            sites.add(accSite2);
            
            Account accSite3 = new Account ();
            accSite3.name = 'SUN Test Account23';
            accSite3.recordtypeid=rtMapByName.get('Site').getRecordTypeId(); 
            accSite3.BillingStreet = '1040 N 326 W';
            accSite3.billingcity = 'Orem';
            accSite3.BillingState = 'UT';
            accSite3.Billingcountry = 'USA';
            accSite3.OMX_Primary_Key__c = '123462';
            accSite3.Oracle_Party_Id__c = '123462';
            accSite3.AOPS_Cust_Id__c = '123462';
            accSite3.status__c='Inactive';
            accSite3.Related_Account__c = acc.Id;
            sites.add(accSite3);
            
            insert sites;
            
            //Test.startTest();
                      
            Contact accCntc = new Contact();
            accCntc.LastName='LastNametest1';
            accCntc.email='testemail1@test.com';
            accCntc.AccountId = acc.id;
            accCntc.OMX_Primary_Key__c='4321';
            contacts.add(accCntc);
            
            insert contacts;
            
            Customer_Transition__c CT = new Customer_Transition__c(name='test',account__c = acc.id,Status__c='On Deck',Billing_Frequency_Excptn__c = true,AOPS_Flag__c='Y',OMX_Primary_Key__c='123457',Transition_Status__c='Active');
            //insert CT;
            ctList.add(CT);
      
            insert ctList;
           
            Customer_Transition_Dtls__c ctCTD1 = new Customer_Transition_Dtls__c(account_Id__c = acc.id,Customer_Transition_ID__c=CT.id,Status__c='Active',OMX_Primary_Key__c='543456',recordtypeid=DtlsSiteRcdTypeID,AOPS_Flag__c='Y');
            Customer_Transition_Dtls__c ctCTD2 = new Customer_Transition_Dtls__c(account_Id__c = acc.id,Customer_Transition_ID__c=CT.id,Status__c='Active',OMX_Primary_Key__c='543457',recordtypeid=DtlsSiteRcdTypeID,AOPS_Flag__c='Y');
            Customer_Transition_Dtls__c ctCTD3 = new Customer_Transition_Dtls__c(account_Id__c = acc.id,Customer_Transition_ID__c=CT.id,Status__c='Active',OMX_Primary_Key__c='543458',recordtypeid=DtlsSiteRcdTypeID,AOPS_Flag__c='N');
            
          
            
            ctdList.add(ctCTD1);
            ctdList.add(ctCTD2);
            ctdList.add(ctCTD3);
                       
            insert ctdList;
            
            //Test.stopTest();
            
            system.debug('###Accounts'+accounts);
            system.debug('###Sites'+sites);
            system.debug('###Contacts'+contacts);
            system.debug('###ctList'+ctList);
            system.debug('###ctdList'+ctdList);
            
            ctList.clear();
            
            ctList = [Select Id, Final_Split_Decision__c,No_of_Active_Sites__c,Account_Splitting_Required_frmla__c from Customer_Transition__c where OMX_Primary_Key__c in ('123457')];
            
            system.debug('###ctListNo_of_Active_Sites__c'+ctList[0].No_of_Active_Sites__c);
            
            
            system.debug('###Account_Splitting_Required_frmla__c'+ctList[0].Account_Splitting_Required_frmla__c);
            
            
            ctList[0].Status__c='On Deck';
            update ctList;
            
            system.debug('###ctList'+ctList);
            
            ctList[0].Final_Split_Decision__c = 'Yes' ;    
            system.debug('###ctListBeforeUpdate'+ctList);           
          //  executeoncetest.customerTransition_beforeUpdate = true;
            update ctList;
            system.debug('###ctListAfterUpdate'+ctList);      


            ctList[0].Final_Split_Decision__c = 'No' ;    
            system.debug('###ctListBeforeUpdate'+ctList);           
          //  executeoncetest.customerTransition_beforeUpdate = true;
            update ctList;
            system.debug('###ctListAfterUpdate'+ctList);      

            ctList[0].Final_Split_Decision__c = 'Yes' ;    
            system.debug('###ctListBeforeUpdate'+ctList);           
          //  executeoncetest.customerTransition_beforeUpdate = true;
            update ctList;
            system.debug('###ctListAfterUpdate'+ctList);                
            
            //Updated SAD with new Master OMX
            List<Split_Account_Detail__c> sads= [Select Id, Customer_Transition__c,Linked_Customer_Transition__c, Original_Account__c, OMX_ACCOUNT__c,Master_Account__c,status__c,
            Main_Account_Name__c,
            NEW_BILL_TO_OMX_CONSIGNEE__c,
            NEW_MAIN_ACCT_ADDRESS__c,
            AP_CONTACT_FIRST_NAME__c,
            AP_CONTACT_LAST_NAME__c,
            NEW_BILLING_TYPE_AT_HEADER_LEVEL__c
            from Split_Account_Detail__c where OMX_ACCOUNT__c = '123457' and Master_Account__c=''];
            
            system.debug('###sads'+sads);
            
            List<Split_Account_Detail__c> upSads = new  List<Split_Account_Detail__c> ();
            integer i=1;
                for(Split_Account_Detail__c sad : sads)
                {
                sad.Master_Account__c='123457-'+i;
                String name = 'SUN Test Account';
                sad.Main_Account_Name__c=name+'-'+i;
                sad.NEW_BILL_TO_OMX_CONSIGNEE__c = '123462';
                sad.NEW_MAIN_ACCT_ADDRESS__c = '123461';
                sad.AP_CONTACT_FIRST_NAME__c = 'First' ;
                sad.AP_CONTACT_LAST_NAME__c = 'Last';
                sad.NEW_BILLING_TYPE_AT_HEADER_LEVEL__c = 'DI';
                upSads.add(sad);
                i=i+1;
                }
            
            update upSads;
                        
            ctList[0].Ready_For_Mod_5__c = true ;
            
           // executeoncetest.customerTransition_beforeUpdate = true;
            update ctList;
            
            accounts.clear();
            Test.startTest();
            accounts = [select id,Mod_5_EBS_Sync_Status__c,OMX_Primary_Key__c from account where OMX_Primary_Key__c in ('123457-1','123457-2') ];
            List<Account> updateAcc = new List<Account>();
            for(Account eachNewAcc : accounts)
            {
            eachNewAcc.Mod_5_EBS_Sync_Status__c = 'SUCCESS';
            updateAcc.add(eachNewAcc);
            }
            update updateAcc;
            system.debug('###sads'+updateAcc);
            

            /*String strQuery = '';
            Mod5LaunchBatchClass  Mod5LaunchBatchObj = new Mod5LaunchBatchClass (strQuery);
            database.executebatch(Mod5LaunchBatchObj, 1);*/
            //Test.startTest();
            Mod5LaunchBatchClassBulk m = new Mod5LaunchBatchClassBulk();
            Database.QueryLocator ql = m.start(null);
            m.execute(null,ctList);
            m.Finish(null);
            Test.stopTest();
            
            }
        
        }   
        
        //added for the story #S-418600 (00715635) #START
        static testMethod void validTestMethod1()
        {
            
        // executeoncetest.bypassAccountExtension = true;
        
         List<Account> accounts = new List<Account>();
         List<Account> sites = new List<Account>();
         List<Contact> contacts = new List<Contact>();
         List<Customer_Transition__c> ctList = new List<Customer_Transition__c>();
         List<Customer_Transition_Dtls__c> ctdList = new List<Customer_Transition_Dtls__c>();
         
         // CustTransParentChildLevel__c Custom Setting record
            CustTransParentChildLevel__c custSettingRecord = new CustTransParentChildLevel__c();
            custSettingRecord.name = 'Parent';
            custSettingRecord.Mod5LaunchBatchInterval__c = 600;
            insert custSettingRecord;
         
         Schema.DescribeSObjectResult d1 = Schema.SObjectType.Account; 
         Map<String,Schema.RecordTypeInfo> rtMapByName = d1.getRecordTypeInfosByName(); 
         Id DtlsSiteRcdTypeID = Schema.SObjectType.Customer_Transition_Dtls__c.getRecordTypeInfosByName().get('Sites').getRecordTypeId();
         Id DtlsPOsRcdTypeID = Schema.SObjectType.Customer_Transition_Dtls__c.getRecordTypeInfosByName().get('Purchase Order').getRecordTypeId();
         Id DtlsCCsRcdTypeID = Schema.SObjectType.Customer_Transition_Dtls__c.getRecordTypeInfosByName().get('Cost Center').getRecordTypeId();
         
         Profile profileObj = [select id from profile where name='System Administrator'];

         String profId = profileObj.id;
         user usrObj = new user(Username='abc@officedepot.com.uat',FirstName ='Fname', LastName='Lname', Alias='abc', CommunityNickname='abc', LocaleSidKey='en_US', EmailEncodingKey='UTF-8', Profileid = profId, LanguageLocaleKey='en_US', email='abc@officedepot.com.uat',TimeZoneSidKey='America/New_York');
         usrObj.Short_Title__c='';
         Insert usrObj;
                  
        Sales_Person__c s= new Sales_Person__c();
        s.IsActive__c=true;
        s.Role_Relate_Id__c ='333333';
        s.Primary__c =true;
        s.user__c=usrObj.id;
        insert s;         
                  
        System.runAs(usrObj)
        {
            
            Account acc = new Account ();
            acc.name = 'SUN Test Account';
            acc.BillingStreet = '1040 N 326 W';
            acc.billingcity = 'Orem';
            acc.BillingState = 'UT';
            acc.Billingcountry = 'USA';
            acc.OMX_Primary_Key__c = '123457';
            acc.Oracle_Party_Id__c = '123457';
            acc.AOPS_Cust_Id__c = '123457';
            acc.status__c='Active';
            acc.Split_Record__c = true;
            acc.Segment__c='Federal';
            acc.Sales_PersonID__c=s.id;
            accounts.add(acc);
            
            insert accounts;
            
            Account accSite1 = new Account ();
            accSite1.name = 'SUN Test Account21';
            accSite1.recordtypeid=rtMapByName.get('Site').getRecordTypeId(); 
            accSite1.BillingStreet = '1040 N 326 W';
            accSite1.billingcity = 'Orem';
            accSite1.BillingState = 'UT';
            accSite1.Billingcountry = 'USA';
            accSite1.OMX_Primary_Key__c = '123460';
            accSite1.Oracle_Party_Id__c = '123460';
            accSite1.AOPS_Cust_Id__c = '123460';
            accSite1.status__c='Active';
            accSite1.Related_Account__c = acc.Id;
            sites.add(accSite1);
            
            Account accSite2 = new Account ();
            accSite2.name = 'SUN Test Account22';
            accSite2.recordtypeid=rtMapByName.get('Site').getRecordTypeId(); 
            accSite2.BillingStreet = '1040 N 326 W';
            accSite2.billingcity = 'Orem';
            accSite2.BillingState = 'UT';
            accSite2.Billingcountry = 'USA';
            accSite2.OMX_Primary_Key__c = '123461';
            accSite2.Oracle_Party_Id__c = '123461';
            accSite2.AOPS_Cust_Id__c = '123461';
            accSite2.status__c='Active';
            accSite2.Related_Account__c = acc.Id;
            sites.add(accSite2);
            
            Account accSite3 = new Account ();
            accSite3.name = 'SUN Test Account23';
            accSite3.recordtypeid=rtMapByName.get('Site').getRecordTypeId(); 
            accSite3.BillingStreet = '1040 N 326 W';
            accSite3.billingcity = 'Orem';
            accSite3.BillingState = 'UT';
            accSite3.Billingcountry = 'USA';
            accSite3.OMX_Primary_Key__c = '123462';
            accSite3.Oracle_Party_Id__c = '123462';
            accSite3.AOPS_Cust_Id__c = '123462';
            accSite3.status__c='Inactive';
            accSite3.Related_Account__c = acc.Id;
            sites.add(accSite3);
            
            insert sites;
            
            //Test.startTest();
                      
            Contact accCntc = new Contact();
            accCntc.LastName='LastNametest1';
            accCntc.email='testemail1@test.com';
            accCntc.AccountId = acc.id;
            accCntc.OMX_Primary_Key__c='4321';
            contacts.add(accCntc);
            
            insert contacts;
            
            Customer_Transition__c CT = new Customer_Transition__c(name='test',account__c = acc.id,Status__c='On Deck',Billing_Frequency_Excptn__c = true,AOPS_Flag__c='Y',OMX_Primary_Key__c='123457',Transition_Status__c='Active');
            //insert CT;
            ctList.add(CT);
      
            insert ctList;
           
            Customer_Transition_Dtls__c ctCTD1 = new Customer_Transition_Dtls__c(account_Id__c = acc.id,Customer_Transition_ID__c=CT.id,Status__c='Active',OMX_Primary_Key__c='543456',recordtypeid=DtlsSiteRcdTypeID,AOPS_Flag__c='Y');
            Customer_Transition_Dtls__c ctCTD2 = new Customer_Transition_Dtls__c(account_Id__c = acc.id,Customer_Transition_ID__c=CT.id,Status__c='Active',OMX_Primary_Key__c='543457',recordtypeid=DtlsSiteRcdTypeID,AOPS_Flag__c='Y');
            Customer_Transition_Dtls__c ctCTD3 = new Customer_Transition_Dtls__c(account_Id__c = acc.id,Customer_Transition_ID__c=CT.id,Status__c='Active',OMX_Primary_Key__c='543458',recordtypeid=DtlsSiteRcdTypeID,AOPS_Flag__c='N');
            
          
            
            ctdList.add(ctCTD1);
            ctdList.add(ctCTD2);
            ctdList.add(ctCTD3);
                       
            insert ctdList;
            
            //Test.stopTest();
            
            system.debug('###Accounts'+accounts);
            system.debug('###Sites'+sites);
            system.debug('###Contacts'+contacts);
            system.debug('###ctList'+ctList);
            system.debug('###ctdList'+ctdList);
            
            ctList.clear();
            
            ctList = [Select Id, Final_Split_Decision__c,No_of_Active_Sites__c,Account_Splitting_Required_frmla__c from Customer_Transition__c where OMX_Primary_Key__c in ('123457')];
            
            system.debug('###ctListNo_of_Active_Sites__c'+ctList[0].No_of_Active_Sites__c);
            
            
            system.debug('###Account_Splitting_Required_frmla__c'+ctList[0].Account_Splitting_Required_frmla__c);
            
            
            ctList[0].Status__c='On Deck';
            update ctList;
            
            system.debug('###ctList'+ctList);
            
            ctList[0].Final_Split_Decision__c = 'Yes' ;    
            system.debug('###ctListBeforeUpdate'+ctList);           
           // executeoncetest.customerTransition_beforeUpdate = true;
            update ctList;
            system.debug('###ctListAfterUpdate'+ctList);      


            ctList[0].Final_Split_Decision__c = 'No' ;    
            system.debug('###ctListBeforeUpdate'+ctList);           
            //executeoncetest.customerTransition_beforeUpdate = true;
            update ctList;
            system.debug('###ctListAfterUpdate'+ctList);      

            ctList[0].Final_Split_Decision__c = 'Yes' ;    
            system.debug('###ctListBeforeUpdate'+ctList);           
            //executeoncetest.customerTransition_beforeUpdate = true;
            update ctList;
            system.debug('###ctListAfterUpdate'+ctList);                
            
            //Updated SAD with new Master OMX
            List<Split_Account_Detail__c> sads= [Select Id, Customer_Transition__c,Linked_Customer_Transition__c, Original_Account__c, OMX_ACCOUNT__c,Master_Account__c,status__c,
            Main_Account_Name__c,
            NEW_BILL_TO_OMX_CONSIGNEE__c,
            NEW_MAIN_ACCT_ADDRESS__c,
            AP_CONTACT_FIRST_NAME__c,
            AP_CONTACT_LAST_NAME__c,
            NEW_BILLING_TYPE_AT_HEADER_LEVEL__c
            from Split_Account_Detail__c where OMX_ACCOUNT__c = '123457' and Master_Account__c=''];
            
            system.debug('###sads'+sads);
            
            List<Split_Account_Detail__c> upSads = new  List<Split_Account_Detail__c> ();
            integer i=1;
                for(Split_Account_Detail__c sad : sads)
                {
                sad.Master_Account__c='123457-'+i;
                String name = 'SUN Test Account';
                sad.Main_Account_Name__c=name+'-'+i;
                sad.NEW_BILL_TO_OMX_CONSIGNEE__c = '123462';
                sad.NEW_MAIN_ACCT_ADDRESS__c = '123461';
                sad.AP_CONTACT_FIRST_NAME__c = 'First' ;
                sad.AP_CONTACT_LAST_NAME__c = 'Last';
                sad.NEW_BILLING_TYPE_AT_HEADER_LEVEL__c = 'DI';
                upSads.add(sad);
                i=i+1;
                }
            
            update upSads;
                        
            ctList[0].Ready_For_Mod_5__c = true ;
            
           // executeoncetest.customerTransition_beforeUpdate = true;
            update ctList;
            
            accounts.clear();
            Test.startTest();
            accounts = [select id,Mod_5_EBS_Sync_Status__c,OMX_Primary_Key__c from account where OMX_Primary_Key__c in ('123457-1','123457-2') ];
            List<Account> updateAcc = new List<Account>();
            for(Account eachNewAcc : accounts)
            {
            eachNewAcc.Mod_5_EBS_Sync_Status__c = 'SUCCESS';
            updateAcc.add(eachNewAcc);
            }
            update updateAcc;
            system.debug('###sads'+updateAcc);
            

            /*String strQuery = '';
            Mod5LaunchBatchClass  Mod5LaunchBatchObj = new Mod5LaunchBatchClass (strQuery);
            database.executebatch(Mod5LaunchBatchObj, 1);*/
            //Test.startTest();
            Mod5LaunchBatchClassBulk m = new Mod5LaunchBatchClassBulk();
            Database.QueryLocator ql = m.start(null);
            m.execute(null,ctList);
            m.Finish(null);
            Test.stopTest();
            
            }
        
        }   
        
         //added for the story #S-418600 (00715635) #END

       /* static testMethod void invalidTestMethod()
        {
        
         List<Account> accounts = new List<Account>();
         List<Account> sites = new List<Account>();
         List<Contact> contacts = new List<Contact>();
         List<Customer_Transition__c> ctList = new List<Customer_Transition__c>();
         List<Customer_Transition_Dtls__c> ctdList = new List<Customer_Transition_Dtls__c>();
         
         // CustTransParentChildLevel__c Custom Setting record
            CustTransParentChildLevel__c custSettingRecord = new CustTransParentChildLevel__c();
            custSettingRecord.name = 'Parent';
            custSettingRecord.Mod5LaunchBatchInterval__c = 600;
            insert custSettingRecord;
         
         Schema.DescribeSObjectResult d1 = Schema.SObjectType.Account; 
         Map<String,Schema.RecordTypeInfo> rtMapByName = d1.getRecordTypeInfosByName(); 
         Id DtlsSiteRcdTypeID = Schema.SObjectType.Customer_Transition_Dtls__c.getRecordTypeInfosByName().get('Sites').getRecordTypeId();
         Id DtlsPOsRcdTypeID = Schema.SObjectType.Customer_Transition_Dtls__c.getRecordTypeInfosByName().get('Purchase Order').getRecordTypeId();
         Id DtlsCCsRcdTypeID = Schema.SObjectType.Customer_Transition_Dtls__c.getRecordTypeInfosByName().get('Cost Center').getRecordTypeId();
         
         Profile profileObj = [select id from profile where name='System Administrator'];

         String profId = profileObj.id;
         user usrObj = new user(Username='abc@officedepot.com.uat',FirstName ='Fname', LastName='Lname', Alias='abc', CommunityNickname='abc', LocaleSidKey='en_US', EmailEncodingKey='UTF-8', Profileid = profId, LanguageLocaleKey='en_US', email='abc@officedepot.com.uat',TimeZoneSidKey='America/New_York',IsActive=true);
         usrObj.Short_Title__c='';
         Insert usrObj;
         
         //Added for the Story #S-355233 #START
         Sales_Person__c s= new Sales_Person__c();
         s.name = 'Awaiting SalesID';
         s.IsActive__c=true;
         s.Role_Relate_Id__c ='333333';
         s.Primary__c =true;
         s.user__c=usrObj.id;
         insert s;
         //Added for the Story #S-355233 #END
                  
        System.runAs(usrObj)
        {
            
            
            Test.startTest();
            Account acc1 = new Account ();
            acc1.name = 'SUN Test Account1';
            acc1.BillingStreet = '1041 N 326 W';
            acc1.billingcity = 'Ore';
            acc1.BillingState = 'US';
            acc1.Billingcountry = 'US';
            acc1.OMX_Primary_Key__c = '223457';
            acc1.Oracle_Party_Id__c = '223457';
            acc1.AOPS_Cust_Id__c = '223457';
            acc1.status__c='Inactive';
            acc1.Split_Record__c = true;
            acc1.Segment__c='Other';
            insert acc1;
            
            
            Account acc = new Account ();
            acc.name = 'SUN Test Account';
            acc.BillingStreet = '1040 N 326 W';
            acc.billingcity = 'Orem';
            acc.BillingState = 'UT';
            acc.Billingcountry = 'USA';
            acc.OMX_Primary_Key__c = '123457';
            acc.Oracle_Party_Id__c = '123457';
            acc.AOPS_Cust_Id__c = '123457';
            acc.status__c='Inactive';
            acc.Split_Record__c = true;
            acc.Segment__c= null; // updated for the story #S-355233
            acc.Sales_PersonID__c = s.id; // added for the story #S-355233
            acc.OMX_Mainframe_Account_Level__c = 'Main Account'; // added for the story #S-355233
            acc.Parent = acc1;
            accounts.add(acc);
            
            Account acc2 = new Account ();
            acc2.name = 'SUN Test Account2';
            acc2.BillingStreet = '1042 N 326 W';
            acc2.billingcity = 'Or';
            acc2.BillingState = 'US';
            acc2.Billingcountry = 'US';
            acc2.OMX_Primary_Key__c = '323457';
            acc2.Oracle_Party_Id__c = '323457';
            acc2.AOPS_Cust_Id__c = '323457';
            acc2.status__c='Inactive';
            acc2.Split_Record__c = true;
            acc2.Segment__c='Other';
            acc2.Sales_PersonID__c = null; // added for the story #S-355233
            acc.OMX_Mainframe_Account_Level__c = 'Main Account'; // added for the story #S-355233
            accounts.add(acc2);
            
            
            
            insert accounts;
            
            Account accSite1 = new Account ();
            accSite1.name = 'SUN Test Account1';
            accSite1.recordtypeid=rtMapByName.get('Site').getRecordTypeId(); 
            accSite1.BillingStreet = '1040 N 326 W';
            accSite1.billingcity = 'Orem';
            accSite1.BillingState = 'UT';
            accSite1.Billingcountry = 'USA';
            accSite1.OMX_Primary_Key__c = '123460';
            accSite1.Oracle_Party_Id__c = '123460';
            accSite1.AOPS_Cust_Id__c = '123460';
            accSite1.status__c='Active';
            accSite1.Related_Account__c = acc.Id;
            sites.add(accSite1);
            
            Account accSite2 = new Account ();
            accSite2.name = 'SUN Test Account2';
            accSite2.recordtypeid=rtMapByName.get('Site').getRecordTypeId(); 
            accSite2.BillingStreet = '1040 N 326 W';
            accSite2.billingcity = 'Orem';
            accSite2.BillingState = 'UT';
            accSite2.Billingcountry = 'USA';
            accSite2.OMX_Primary_Key__c = '123461';
            accSite2.Oracle_Party_Id__c = '123461';
            accSite2.AOPS_Cust_Id__c = '123461';
            accSite2.status__c='Active';
            accSite2.Related_Account__c = acc.Id;
            sites.add(accSite2);
            
            Account accSite3 = new Account ();
            accSite3.name = 'SUN Test Account3';
            accSite3.recordtypeid=rtMapByName.get('Site').getRecordTypeId(); 
            accSite3.BillingStreet = '1040 N 326 W';
            accSite3.billingcity = 'Orem';
            accSite3.BillingState = 'UT';
            accSite3.Billingcountry = 'USA';
            accSite3.OMX_Primary_Key__c = '123462';
            accSite3.Oracle_Party_Id__c = '123462';
            accSite3.AOPS_Cust_Id__c = '123462';
            accSite3.status__c='Inactive';
            accSite3.Related_Account__c = acc.Id;
            sites.add(accSite3);
            
            Account accSite12 = new Account ();
            accSite12.name = 'SUN Test Account21';
            accSite12.recordtypeid=rtMapByName.get('Site').getRecordTypeId(); 
            accSite12.BillingStreet = '1040 N 326 W';
            accSite12.billingcity = 'Orem';
            accSite12.BillingState = 'UT';
            accSite12.Billingcountry = 'USA';
            accSite12.OMX_Primary_Key__c = '223460';
            accSite12.Oracle_Party_Id__c = '223460';
            accSite12.AOPS_Cust_Id__c = '223460';
            accSite12.status__c='Active';
            accSite12.Related_Account__c = acc2.Id; // updated for the story #S-355233
            sites.add(accSite12);
            
            Account accSite22 = new Account ();
            accSite22.name = 'SUN Test Account22';
            accSite22.recordtypeid=rtMapByName.get('Site').getRecordTypeId(); 
            accSite22.BillingStreet = '1040 N 326 W';
            accSite22.billingcity = 'Orem';
            accSite22.BillingState = 'UT';
            accSite22.Billingcountry = 'USA';
            accSite22.OMX_Primary_Key__c = '223461';
            accSite22.Oracle_Party_Id__c = '223461';
            accSite22.AOPS_Cust_Id__c = '223461';
            accSite22.status__c='Active';
            accSite22.Related_Account__c = acc2.Id; // updated for the story #S-355233
            sites.add(accSite22);
            
            Account accSite23 = new Account ();
            accSite23.name = 'SUN Test Account23';
            accSite23.recordtypeid=rtMapByName.get('Site').getRecordTypeId(); 
            accSite23.BillingStreet = '1040 N 326 W';
            accSite23.billingcity = 'Orem';
            accSite23.BillingState = 'UT';
            accSite23.Billingcountry = 'USA';
            accSite23.OMX_Primary_Key__c = '223462';
            accSite23.Oracle_Party_Id__c = '223462';
            accSite23.AOPS_Cust_Id__c = '223462';
            accSite23.status__c='Inactive';
            accSite23.Related_Account__c = acc2.Id; // updated for the story #S-355233
            sites.add(accSite23);
            
            
            
            insert sites;
                      
            Contact accCntc = new Contact();
            accCntc.LastName='LastNametest1';
            accCntc.email='testemail1@test.com';
            accCntc.AccountId = acc.id;
            accCntc.OMX_Primary_Key__c='4321';
            contacts.add(accCntc);
            
            insert contacts;

            Customer_Transition__c CT1 = new Customer_Transition__c(name='test',account__c = acc.id,Status__c='On Deck',Billing_Frequency_Excptn__c = true,AOPS_Flag__c='Y',OMX_Primary_Key__c='223457',Transition_Status__c='Inactive');
            insert CT1;
            
            
            Customer_Transition__c CT = new Customer_Transition__c(name='test',account__c = acc.id,Status__c='On Deck',Billing_Frequency_Excptn__c = true,AOPS_Flag__c='Y',OMX_Primary_Key__c='123457',Transition_Status__c='Inactive',Parent_Transition_ID__c=CT1.Id);
            //insert CT;
            ctList.add(CT);
            
            Customer_Transition__c CT2 = new Customer_Transition__c(name='test',account__c = acc.id,Status__c='On Deck',Billing_Frequency_Excptn__c = true,AOPS_Flag__c='Y',OMX_Primary_Key__c='323457',Transition_Status__c='Inactive',Parent_Transition_ID__c=CT1.Id);
            //insert CT;
            ctList.add(CT2);
      
            insert ctList;
           
            Customer_Transition_Dtls__c ctCTD1 = new Customer_Transition_Dtls__c(account_Id__c = acc.id,Customer_Transition_ID__c=CT.id,Status__c='Active',OMX_Primary_Key__c='543456',recordtypeid=DtlsSiteRcdTypeID,AOPS_Flag__c='Y');
            Customer_Transition_Dtls__c ctCTD2 = new Customer_Transition_Dtls__c(account_Id__c = acc.id,Customer_Transition_ID__c=CT.id,Status__c='Active',OMX_Primary_Key__c='543457',recordtypeid=DtlsSiteRcdTypeID,AOPS_Flag__c='Y');
            Customer_Transition_Dtls__c ctCTD3 = new Customer_Transition_Dtls__c(account_Id__c = acc.id,Customer_Transition_ID__c=CT.id,Status__c='Active',OMX_Primary_Key__c='543458',recordtypeid=DtlsSiteRcdTypeID,AOPS_Flag__c='N');
            
            Customer_Transition_Dtls__c ct2CTD1 = new Customer_Transition_Dtls__c(account_Id__c = acc.id,Customer_Transition_ID__c=CT2.id,Status__c='Active',OMX_Primary_Key__c='643456',recordtypeid=DtlsSiteRcdTypeID,AOPS_Flag__c='Y');
            Customer_Transition_Dtls__c ct2CTD2 = new Customer_Transition_Dtls__c(account_Id__c = acc.id,Customer_Transition_ID__c=CT2.id,Status__c='Active',OMX_Primary_Key__c='643457',recordtypeid=DtlsSiteRcdTypeID,AOPS_Flag__c='Y');
            Customer_Transition_Dtls__c ct2CTD3 = new Customer_Transition_Dtls__c(account_Id__c = acc.id,Customer_Transition_ID__c=CT2.id,Status__c='Active',OMX_Primary_Key__c='643458',recordtypeid=DtlsSiteRcdTypeID,AOPS_Flag__c='N');
            
          
            
            ctdList.add(ctCTD1);
            ctdList.add(ctCTD2);
            ctdList.add(ctCTD3);
            
            ctdList.add(ct2CTD1);
            ctdList.add(ct2CTD2);
            ctdList.add(ct2CTD3);
                       
            insert ctdList;
            
            Test.stopTest();
            
            system.debug('###Accounts'+accounts);
            system.debug('###Sites'+sites);
            system.debug('###Contacts'+contacts);
            system.debug('###ctList'+ctList);
            system.debug('###ctdList'+ctdList);
            
            ctList.clear();
            
            ctList = [Select Id, Final_Split_Decision__c,No_of_Active_Sites__c,Account_Splitting_Required_frmla__c from Customer_Transition__c where OMX_Primary_Key__c in ('123457')];
            
             List<Customer_Transition__c> tmpCtList = [Select Id, Final_Split_Decision__c,No_of_Active_Sites__c,Account_Splitting_Required_frmla__c from Customer_Transition__c where OMX_Primary_Key__c in ('323457')];
             
            tmpCtList[0].Status__c='On Deck';
            update tmpCtList;
            
            tmpCtList[0].Final_Split_Decision__c = 'Yes' ;  
            tmpCtList[0].Ready_For_Mod_5__c =true;
            tmpCtList[0].Split_Launching_Status__c= null;
            update tmpCtList;           
            system.debug('###ctListNo_of_Active_Sites__c'+ctList[0].No_of_Active_Sites__c);
            
            
            system.debug('###Account_Splitting_Required_frmla__c'+ctList[0].Account_Splitting_Required_frmla__c);
            
            
            ctList[0].Status__c='On Deck';
            update ctList;
            
            system.debug('###ctList'+ctList);
            
            ctList[0].Final_Split_Decision__c = 'Yes' ;    
            system.debug('###ctListBeforeUpdate'+ctList);           
            executeoncetest.customerTransition_beforeUpdate = true;
            update ctList;
            system.debug('###ctListAfterUpdate'+ctList);      


            ctList[0].Final_Split_Decision__c = 'No' ;    
            system.debug('###ctListBeforeUpdate'+ctList);           
            executeoncetest.customerTransition_beforeUpdate = true;
            update ctList;
            system.debug('###ctListAfterUpdate'+ctList);      

            ctList[0].Final_Split_Decision__c = 'Yes' ;    
            system.debug('###ctListBeforeUpdate'+ctList);           
            executeoncetest.customerTransition_beforeUpdate = true;
            update ctList;
            system.debug('###ctListAfterUpdate'+ctList);                
            
            //Updated SAD with new Master OMX
            List<Split_Account_Detail__c> sads= [Select Id, Customer_Transition__c,Linked_Customer_Transition__c, Original_Account__c, OMX_ACCOUNT__c,Master_Account__c,status__c,
            Main_Account_Name__c,
            NEW_BILL_TO_OMX_CONSIGNEE__c,
            NEW_MAIN_ACCT_ADDRESS__c,
            AP_CONTACT_FIRST_NAME__c,
            AP_CONTACT_LAST_NAME__c,
            NEW_BILLING_TYPE_AT_HEADER_LEVEL__c
            from Split_Account_Detail__c where OMX_ACCOUNT__c = '123457' and Master_Account__c=''];
            
            system.debug('###sads'+sads);
            
            List<Split_Account_Detail__c> upSads = new  List<Split_Account_Detail__c> ();
            integer i=1;
                for(Split_Account_Detail__c sad : sads)
                {
                sad.Master_Account__c='123457-'+i;
                String name = 'SUN Test Account';
                sad.Main_Account_Name__c=name+'-'+i;
                sad.NEW_BILL_TO_OMX_CONSIGNEE__c = '223462';
                sad.NEW_MAIN_ACCT_ADDRESS__c = '543458';
                sad.AP_CONTACT_FIRST_NAME__c = 'First' ;
                sad.AP_CONTACT_LAST_NAME__c = 'Last';
                sad.NEW_BILLING_TYPE_AT_HEADER_LEVEL__c = 'DI';
                upSads.add(sad);
                i=i+1;
                }
            
            update upSads;
                        
            ctList[0].Ready_For_Mod_5__c = true ;
            
            executeoncetest.customerTransition_beforeUpdate = true;
            update ctList;
            
            accounts.clear();
            
            accounts = [select id,Mod_5_EBS_Sync_Status__c,OMX_Primary_Key__c from account where OMX_Primary_Key__c in ('123457-1','123457-2') ];
            List<Account> updateAcc = new List<Account>();
            for(Account eachNewAcc : accounts)
            {
            eachNewAcc.Mod_5_EBS_Sync_Status__c = 'SUCCESS';
            updateAcc.add(eachNewAcc);
            }
            update updateAcc;
            system.debug('###sads'+updateAcc);
            

            String strQuery = '';
            Mod5LaunchBatchClass  Mod5LaunchBatchObj = new Mod5LaunchBatchClass (strQuery);
            database.executebatch(Mod5LaunchBatchObj, 1);
            
            // Added for the story #S-355233 #START
            
            String query1 ='Select omx_primary_key__c '
                                   +' FROM Customer_Transition__c '
                                   +'WHERE MOD5_Ready_To_Launch__c = true  Limit 2'; 
                                   
            Mod5LaunchBatchClass  Mod5LaunchBatchObj1 = new Mod5LaunchBatchClass (query1);
            database.executebatch(Mod5LaunchBatchObj1, 1);
            
            // Added for the story #S-355233 #END    
            
            }
        
        }   
        
        // Added for the story #S-355233 #START
     static testMethod void invalidTestMethod1() {
        
         List<Account> accounts = new List<Account>();
         List<Account> sites = new List<Account>();
         List<Contact> contacts = new List<Contact>();
         List<Customer_Transition__c> ctList = new List<Customer_Transition__c>();
         List<Customer_Transition_Dtls__c> ctdList = new List<Customer_Transition_Dtls__c>();
         
         // CustTransParentChildLevel__c Custom Setting record
            CustTransParentChildLevel__c custSettingRecord = new CustTransParentChildLevel__c();
            custSettingRecord.name = 'Parent';
            custSettingRecord.Mod5LaunchBatchInterval__c = 600;
            insert custSettingRecord;
         
         Schema.DescribeSObjectResult d1 = Schema.SObjectType.Account; 
         Map<String,Schema.RecordTypeInfo> rtMapByName = d1.getRecordTypeInfosByName(); 
         Id DtlsSiteRcdTypeID = Schema.SObjectType.Customer_Transition_Dtls__c.getRecordTypeInfosByName().get('Sites').getRecordTypeId();
         Id DtlsPOsRcdTypeID = Schema.SObjectType.Customer_Transition_Dtls__c.getRecordTypeInfosByName().get('Purchase Order').getRecordTypeId();
         Id DtlsCCsRcdTypeID = Schema.SObjectType.Customer_Transition_Dtls__c.getRecordTypeInfosByName().get('Cost Center').getRecordTypeId();
         
         Profile profileObj = [select id from profile where name='System Administrator'];

         String profId = profileObj.id;
         user usrObj = new user(Username='abc@officedepot.com.uat',FirstName ='Fname', LastName='Lname', Alias='abc', CommunityNickname='abc', LocaleSidKey='en_US', EmailEncodingKey='UTF-8', Profileid = profId, LanguageLocaleKey='en_US', email='abc@officedepot.com.uat',TimeZoneSidKey='America/New_York',IsActive=true);
         usrObj.Short_Title__c='';
         Insert usrObj;
         
        System.runAs(usrObj)
        {
            Account acc1 = new Account ();
            acc1.name = 'SUN Test Account1';
            acc1.BillingStreet = '1041 N 326 W';
            acc1.billingcity = 'Ore';
            acc1.BillingState = 'US';
            acc1.Billingcountry = 'US';
            acc1.OMX_Primary_Key__c = '223457';
            acc1.Oracle_Party_Id__c = '223457';
            acc1.AOPS_Cust_Id__c = '223457';
            acc1.status__c='Inactive';
            acc1.Split_Record__c = true;
            acc1.Segment__c='Other';
            insert acc1;
            
            
            Account acc = new Account ();
            acc.name = 'SUN Test Account';
            acc.BillingStreet = '1040 N 326 W';
            acc.billingcity = 'Orem';
            acc.BillingState = 'UT';
            acc.Billingcountry = 'USA';
            acc.OMX_Primary_Key__c = '123457';
            acc.Oracle_Party_Id__c = '123457';
            acc.AOPS_Cust_Id__c = '123457';
            acc.status__c='Inactive';
            acc.Split_Record__c = true;
            acc.Segment__c= 'Other'; 
            acc.Sales_PersonID__c = null; 
            acc.OMX_Mainframe_Account_Level__c = 'Main Account'; 
            acc.Parent = acc1;
            acc.Related_Account__c = acc1.id;
            acc.OMX_ACCOUNT__c = '123457';
            accounts.add(acc);
            
            Account acc2 = new Account ();
            acc2.name = 'SUN Test Account2';
            acc2.BillingStreet = '1042 N 326 W';
            acc2.billingcity = 'Or';
            acc2.BillingState = 'US';
            acc2.Billingcountry = 'US';
            acc2.OMX_Primary_Key__c = '323457';
            acc2.Oracle_Party_Id__c = '323457';
            acc2.AOPS_Cust_Id__c = '323457';
            acc2.status__c='Inactive';
            acc2.Split_Record__c = true;
            acc2.Segment__c='Other';
            acc2.Sales_PersonID__c = null; 
            acc2.OMX_Mainframe_Account_Level__c = 'Main Account'; 
            acc2.Related_Account__c = acc1.id;
            accounts.add(acc2);
            
            
            
            insert accounts;
            
            Account accSite1 = new Account ();
            accSite1.name = 'SUN Test Account1';
            accSite1.recordtypeid=rtMapByName.get('Site').getRecordTypeId(); 
            accSite1.BillingStreet = '1040 N 326 W';
            accSite1.billingcity = 'Orem';
            accSite1.BillingState = 'UT';
            accSite1.Billingcountry = 'USA';
            accSite1.OMX_Primary_Key__c = '123460';
            accSite1.Oracle_Party_Id__c = '123460';
            accSite1.AOPS_Cust_Id__c = '123460';
            accSite1.status__c='Active';
            accSite1.Related_Account__c = acc.Id;
            sites.add(accSite1);
            
            Account accSite2 = new Account ();
            accSite2.name = 'SUN Test Account2';
            accSite2.recordtypeid=rtMapByName.get('Site').getRecordTypeId(); 
            accSite2.BillingStreet = '1040 N 326 W';
            accSite2.billingcity = 'Orem';
            accSite2.BillingState = 'UT';
            accSite2.Billingcountry = 'USA';
            accSite2.OMX_Primary_Key__c = '123461';
            accSite2.Oracle_Party_Id__c = '123461';
            accSite2.AOPS_Cust_Id__c = '123461';
            accSite2.status__c='Active';
            accSite2.Related_Account__c = acc.Id;
            sites.add(accSite2);
            
            Account accSite3 = new Account ();
            accSite3.name = 'SUN Test Account3';
            accSite3.recordtypeid=rtMapByName.get('Site').getRecordTypeId(); 
            accSite3.BillingStreet = '1040 N 326 W';
            accSite3.billingcity = 'Orem';
            accSite3.BillingState = 'UT';
            accSite3.Billingcountry = 'USA';
            accSite3.OMX_Primary_Key__c = '123462';
            accSite3.Oracle_Party_Id__c = '123462';
            accSite3.AOPS_Cust_Id__c = '123462';
            accSite3.status__c='Inactive';
            accSite3.Related_Account__c = acc.Id;
            sites.add(accSite3);
            
            Account accSite12 = new Account ();
            accSite12.name = 'SUN Test Account21';
            accSite12.recordtypeid=rtMapByName.get('Site').getRecordTypeId(); 
            accSite12.BillingStreet = '1040 N 326 W';
            accSite12.billingcity = 'Orem';
            accSite12.BillingState = 'UT';
            accSite12.Billingcountry = 'USA';
            accSite12.OMX_Primary_Key__c = '223460';
            accSite12.Oracle_Party_Id__c = '223460';
            accSite12.AOPS_Cust_Id__c = '223460';
            accSite12.status__c='Active';
            accSite12.Related_Account__c = acc2.Id; 
            sites.add(accSite12);
            
            Account accSite22 = new Account ();
            accSite22.name = 'SUN Test Account22';
            accSite22.recordtypeid=rtMapByName.get('Site').getRecordTypeId(); 
            accSite22.BillingStreet = '1040 N 326 W';
            accSite22.billingcity = 'Orem';
            accSite22.BillingState = 'UT';
            accSite22.Billingcountry = 'USA';
            accSite22.OMX_Primary_Key__c = '223461';
            accSite22.Oracle_Party_Id__c = '223461';
            accSite22.AOPS_Cust_Id__c = '223461';
            accSite22.status__c='Active';
            accSite22.Related_Account__c = acc2.Id; 
            sites.add(accSite22);
            
            Account accSite23 = new Account ();
            accSite23.name = 'SUN Test Account23';
            accSite23.recordtypeid=rtMapByName.get('Site').getRecordTypeId(); 
            accSite23.BillingStreet = '1040 N 326 W';
            accSite23.billingcity = 'Orem';
            accSite23.BillingState = 'UT';
            accSite23.Billingcountry = 'USA';
            accSite23.OMX_Primary_Key__c = '223462';
            accSite23.Oracle_Party_Id__c = '223462';
            accSite23.AOPS_Cust_Id__c = '223462';
            accSite23.status__c='Inactive';
            accSite23.Related_Account__c = acc2.Id; 
            sites.add(accSite23);
            
            
            
            insert sites;
                      
            Contact accCntc = new Contact();
            accCntc.LastName='LastNametest1';
            accCntc.email='testemail1@test.com';
            accCntc.AccountId = acc.id;
            accCntc.OMX_Primary_Key__c='4321';
            contacts.add(accCntc);
            
            insert contacts;

            Customer_Transition__c CT1 = new Customer_Transition__c(name='test',account__c = acc.id,Status__c='On Deck',Billing_Frequency_Excptn__c = true,AOPS_Flag__c='Y',OMX_Primary_Key__c='223457',Transition_Status__c='Inactive');
            insert CT1;
            
            
            Customer_Transition__c CT = new Customer_Transition__c(name='test',account__c = acc.id,Status__c='On Deck',Billing_Frequency_Excptn__c = true,AOPS_Flag__c='Y',OMX_Primary_Key__c='123457',Transition_Status__c='Inactive',Parent_Transition_ID__c=CT1.Id);
            //insert CT;
            ctList.add(CT);
            
            Customer_Transition__c CT2 = new Customer_Transition__c(name='test',account__c = acc.id,Status__c='On Deck',Billing_Frequency_Excptn__c = true,AOPS_Flag__c='Y',OMX_Primary_Key__c='323457',Transition_Status__c='Inactive',Parent_Transition_ID__c=CT1.Id);
            //insert CT;
            ctList.add(CT2);
      
            insert ctList;
           
            Customer_Transition_Dtls__c ctCTD1 = new Customer_Transition_Dtls__c(account_Id__c = acc.id,Customer_Transition_ID__c=CT.id,Status__c='Active',OMX_Primary_Key__c='543456',recordtypeid=DtlsSiteRcdTypeID,AOPS_Flag__c='Y');
            Customer_Transition_Dtls__c ctCTD2 = new Customer_Transition_Dtls__c(account_Id__c = acc.id,Customer_Transition_ID__c=CT.id,Status__c='Active',OMX_Primary_Key__c='543457',recordtypeid=DtlsSiteRcdTypeID,AOPS_Flag__c='Y');
            Customer_Transition_Dtls__c ctCTD3 = new Customer_Transition_Dtls__c(account_Id__c = acc.id,Customer_Transition_ID__c=CT.id,Status__c='Active',OMX_Primary_Key__c='543458',recordtypeid=DtlsSiteRcdTypeID,AOPS_Flag__c='N');
            
            Customer_Transition_Dtls__c ct2CTD1 = new Customer_Transition_Dtls__c(account_Id__c = acc.id,Customer_Transition_ID__c=CT2.id,Status__c='Active',OMX_Primary_Key__c='643456',recordtypeid=DtlsSiteRcdTypeID,AOPS_Flag__c='Y');
            Customer_Transition_Dtls__c ct2CTD2 = new Customer_Transition_Dtls__c(account_Id__c = acc.id,Customer_Transition_ID__c=CT2.id,Status__c='Active',OMX_Primary_Key__c='643457',recordtypeid=DtlsSiteRcdTypeID,AOPS_Flag__c='Y');
            Customer_Transition_Dtls__c ct2CTD3 = new Customer_Transition_Dtls__c(account_Id__c = acc.id,Customer_Transition_ID__c=CT2.id,Status__c='Active',OMX_Primary_Key__c='643458',recordtypeid=DtlsSiteRcdTypeID,AOPS_Flag__c='N');
            
          
            
            ctdList.add(ctCTD1);
            ctdList.add(ctCTD2);
            ctdList.add(ctCTD3);
            
            ctdList.add(ct2CTD1);
            ctdList.add(ct2CTD2);
            ctdList.add(ct2CTD3);
                       
            insert ctdList;
            
            system.debug('###Accounts'+accounts);
            system.debug('###Sites'+sites);
            system.debug('###Contacts'+contacts);
            system.debug('###ctList'+ctList);
            system.debug('###ctdList'+ctdList);
            
            ctList.clear();
            
            Test.startTest();
            
            ctList = [Select Id, Final_Split_Decision__c,No_of_Active_Sites__c,Account_Splitting_Required_frmla__c from Customer_Transition__c where OMX_Primary_Key__c in ('123457')];
            
             List<Customer_Transition__c> tmpCtList = [Select Id, Final_Split_Decision__c,No_of_Active_Sites__c,Account_Splitting_Required_frmla__c from Customer_Transition__c where OMX_Primary_Key__c in ('323457')];
             
            tmpCtList[0].Status__c='On Deck';
            update tmpCtList;
            
            tmpCtList[0].Final_Split_Decision__c = 'Yes' ;  
            tmpCtList[0].Ready_For_Mod_5__c =true;
            tmpCtList[0].Split_Launching_Status__c= null;
            update tmpCtList;           
            system.debug('###ctListNo_of_Active_Sites__c'+ctList[0].No_of_Active_Sites__c);
            
            
            system.debug('###Account_Splitting_Required_frmla__c'+ctList[0].Account_Splitting_Required_frmla__c);
            
            
            ctList[0].Status__c='On Deck';
            update ctList;
            
            system.debug('###ctList'+ctList);
            
            ctList[0].Final_Split_Decision__c = 'Yes' ;    
            system.debug('###ctListBeforeUpdate'+ctList);           
            executeoncetest.customerTransition_beforeUpdate = true;
            update ctList;
            system.debug('###ctListAfterUpdate'+ctList);      


            ctList[0].Final_Split_Decision__c = 'No' ;    
            system.debug('###ctListBeforeUpdate'+ctList);           
            executeoncetest.customerTransition_beforeUpdate = true;
            update ctList;
            system.debug('###ctListAfterUpdate'+ctList);      

            ctList[0].Final_Split_Decision__c = 'Yes' ;    
            system.debug('###ctListBeforeUpdate'+ctList);           
            executeoncetest.customerTransition_beforeUpdate = true;
            update ctList;
            system.debug('###ctListAfterUpdate'+ctList);                
            
            //Updated SAD with new Master OMX
            List<Split_Account_Detail__c> sads= [Select Id, Customer_Transition__c,Linked_Customer_Transition__c, Original_Account__c, OMX_ACCOUNT__c,Master_Account__c,status__c,
            Main_Account_Name__c,
            NEW_BILL_TO_OMX_CONSIGNEE__c,
            NEW_MAIN_ACCT_ADDRESS__c,
            AP_CONTACT_FIRST_NAME__c,
            AP_CONTACT_LAST_NAME__c,
            NEW_BILLING_TYPE_AT_HEADER_LEVEL__c,
            New_Header_Billing_Account__r.Related_Account__c
            from Split_Account_Detail__c where OMX_ACCOUNT__c = '123457' and Master_Account__c=''];
            
            system.debug('###sads'+sads);
            
            List<Split_Account_Detail__c> upSads = new  List<Split_Account_Detail__c> ();
            integer i=1;
                for(Split_Account_Detail__c sad : sads)
                {
                sad.Master_Account__c='123457-'+i;
                String name = 'SUN Test Account';
                sad.Main_Account_Name__c=name+'-'+i;
                //sad.NEW_BILL_TO_OMX_CONSIGNEE__c = '223462';
                sad.NEW_BILL_TO_OMX_CONSIGNEE__c = '';	//Added for the story #S-355234
                sad.NEW_MAIN_ACCT_ADDRESS__c = '543458';
                sad.AP_CONTACT_FIRST_NAME__c = 'First' ;
                sad.AP_CONTACT_LAST_NAME__c = 'Last';
                sad.NEW_BILLING_TYPE_AT_HEADER_LEVEL__c = 'DI';
                sad.New_Header_Billing_Account__c = acc.id;
                sad.Linked_Customer_Transition__c = ctList[0].Id;	//Added for the story #S-355234
                upSads.add(sad);
                i=i+1;
                
                }
            
            update upSads;
            
            List<Customer_Transition__c> tmpCtList1 = [Select Id, Final_Split_Decision__c,No_of_Active_Sites__c,Account_Splitting_Required_frmla__c from Customer_Transition__c where OMX_Primary_Key__c in ('123457')];
            update tmpCtList1;
            
            ctList[0].Ready_For_Mod_5__c = true ;
            
            executeoncetest.customerTransition_beforeUpdate = true;
            update ctList;
            
            accounts.clear();
            
            accounts = [select id,Mod_5_EBS_Sync_Status__c,OMX_Primary_Key__c from account where OMX_Primary_Key__c in ('123457-1','123457-2') ];
            List<Account> updateAcc = new List<Account>();
            for(Account eachNewAcc : accounts)
            {
            eachNewAcc.Mod_5_EBS_Sync_Status__c = 'SUCCESS';
            updateAcc.add(eachNewAcc);
            }
            update updateAcc;
            system.debug('###sads'+updateAcc);
            

            String strQuery = '';
            Mod5LaunchBatchClass  Mod5LaunchBatchObj = new Mod5LaunchBatchClass (strQuery);
            database.executebatch(Mod5LaunchBatchObj, 1);
            
            CT1.AOPS_Flag__c = 'N';
            update CT1;
            
            Mod5LaunchBatchClass  Mod5LaunchBatchObj1 = new Mod5LaunchBatchClass (strQuery);
            database.executebatch(Mod5LaunchBatchObj1, 1);
            
            Test.stopTest();
            
            }
            
        }  
        // Added for the story #S-355233 #END    
        
     // Added for the story #S-355234 #START
     static testMethod void invalidTestMethod2() {
        
         List<Account> accounts = new List<Account>();
         List<Account> sites = new List<Account>();
         List<Contact> contacts = new List<Contact>();
         List<Customer_Transition__c> ctList = new List<Customer_Transition__c>();
         List<Customer_Transition_Dtls__c> ctdList = new List<Customer_Transition_Dtls__c>();
         
         // CustTransParentChildLevel__c Custom Setting record
            CustTransParentChildLevel__c custSettingRecord = new CustTransParentChildLevel__c();
            custSettingRecord.name = 'Parent';
            custSettingRecord.Mod5LaunchBatchInterval__c = 600;
            insert custSettingRecord;
         
         Schema.DescribeSObjectResult d1 = Schema.SObjectType.Account; 
         Map<String,Schema.RecordTypeInfo> rtMapByName = d1.getRecordTypeInfosByName(); 
         Id DtlsSiteRcdTypeID = Schema.SObjectType.Customer_Transition_Dtls__c.getRecordTypeInfosByName().get('Sites').getRecordTypeId();
         Id DtlsPOsRcdTypeID = Schema.SObjectType.Customer_Transition_Dtls__c.getRecordTypeInfosByName().get('Purchase Order').getRecordTypeId();
         Id DtlsCCsRcdTypeID = Schema.SObjectType.Customer_Transition_Dtls__c.getRecordTypeInfosByName().get('Cost Center').getRecordTypeId();
         
         Profile profileObj = [select id from profile where name='System Administrator'];

         String profId = profileObj.id;
         user usrObj = new user(Username='abc@officedepot.com.uat',FirstName ='Fname', LastName='Lname', Alias='abc', CommunityNickname='abc', LocaleSidKey='en_US', EmailEncodingKey='UTF-8', Profileid = profId, LanguageLocaleKey='en_US', email='abc@officedepot.com.uat',TimeZoneSidKey='America/New_York',IsActive=true);
         usrObj.Short_Title__c='';
         Insert usrObj;
         
        System.runAs(usrObj)
        {
            Account acc1 = new Account ();
            acc1.name = 'SUN Test Account1';
            acc1.BillingStreet = '1041 N 326 W';
            acc1.billingcity = 'Ore';
            acc1.BillingState = 'US';
            acc1.Billingcountry = 'US';
            acc1.OMX_Primary_Key__c = '223457';
            acc1.Oracle_Party_Id__c = '223457';
            acc1.AOPS_Cust_Id__c = '223457';
            acc1.status__c='Inactive';
            acc1.Split_Record__c = true;
            acc1.Segment__c='Other';
            insert acc1;
            
            
            Account acc = new Account ();
            acc.name = 'SUN Test Account';
            acc.BillingStreet = '1040 N 326 W';
            acc.billingcity = 'Orem';
            acc.BillingState = 'UT';
            acc.Billingcountry = 'USA';
            acc.OMX_Primary_Key__c = '123457';
            acc.Oracle_Party_Id__c = '123457';
            acc.AOPS_Cust_Id__c = '123457';
            acc.status__c='Inactive';
            acc.Split_Record__c = true;
            acc.Segment__c= 'Other'; 
            acc.Sales_PersonID__c = null; 
            acc.OMX_Mainframe_Account_Level__c = 'Main Account'; 
            acc.Parent = acc1;
            acc.Related_Account__c = acc1.id;
            acc.OMX_ACCOUNT__c = '123457';
            accounts.add(acc);
            
            Account acc2 = new Account ();
            acc2.name = 'SUN Test Account2';
            acc2.BillingStreet = '1042 N 326 W';
            acc2.billingcity = 'Or';
            acc2.BillingState = 'US';
            acc2.Billingcountry = 'US';
            acc2.OMX_Primary_Key__c = '323457';
            acc2.Oracle_Party_Id__c = '323457';
            acc2.AOPS_Cust_Id__c = '323457';
            acc2.status__c='Inactive';
            acc2.Split_Record__c = true;
            acc2.Segment__c='Other';
            acc2.Sales_PersonID__c = null; 
            acc2.OMX_Mainframe_Account_Level__c = 'Main Account'; 
            acc2.Related_Account__c = acc1.id;
            accounts.add(acc2);
            
            
            
            insert accounts;
            
            Account accSite1 = new Account ();
            accSite1.name = 'SUN Test Account1';
            accSite1.recordtypeid=rtMapByName.get('Site').getRecordTypeId(); 
            accSite1.BillingStreet = '1040 N 326 W';
            accSite1.billingcity = 'Orem';
            accSite1.BillingState = 'UT';
            accSite1.Billingcountry = 'USA';
            accSite1.OMX_Primary_Key__c = '123460';
            accSite1.Oracle_Party_Id__c = '123460';
            accSite1.AOPS_Cust_Id__c = '123460';
            accSite1.status__c='Active';
            accSite1.Related_Account__c = acc.Id;
            sites.add(accSite1);
            
            Account accSite2 = new Account ();
            accSite2.name = 'SUN Test Account2';
            accSite2.recordtypeid=rtMapByName.get('Site').getRecordTypeId(); 
            accSite2.BillingStreet = '1040 N 326 W';
            accSite2.billingcity = 'Orem';
            accSite2.BillingState = 'UT';
            accSite2.Billingcountry = 'USA';
            accSite2.OMX_Primary_Key__c = '123461';
            accSite2.Oracle_Party_Id__c = '123461';
            accSite2.AOPS_Cust_Id__c = '123461';
            accSite2.status__c='Active';
            accSite2.Related_Account__c = acc.Id;
            sites.add(accSite2);
            
            Account accSite3 = new Account ();
            accSite3.name = 'SUN Test Account3';
            accSite3.recordtypeid=rtMapByName.get('Site').getRecordTypeId(); 
            accSite3.BillingStreet = '1040 N 326 W';
            accSite3.billingcity = 'Orem';
            accSite3.BillingState = 'UT';
            accSite3.Billingcountry = 'USA';
            accSite3.OMX_Primary_Key__c = '123462';
            accSite3.Oracle_Party_Id__c = '123462';
            accSite3.AOPS_Cust_Id__c = '123462';
            accSite3.status__c='Inactive';
            accSite3.Related_Account__c = acc.Id;
            sites.add(accSite3);
            
            Account accSite12 = new Account ();
            accSite12.name = 'SUN Test Account21';
            accSite12.recordtypeid=rtMapByName.get('Site').getRecordTypeId(); 
            accSite12.BillingStreet = '1040 N 326 W';
            accSite12.billingcity = 'Orem';
            accSite12.BillingState = 'UT';
            accSite12.Billingcountry = 'USA';
            accSite12.OMX_Primary_Key__c = '223460';
            accSite12.Oracle_Party_Id__c = '223460';
            accSite12.AOPS_Cust_Id__c = '223460';
            accSite12.status__c='Active';
            accSite12.Related_Account__c = acc2.Id; 
            sites.add(accSite12);
            
            Account accSite22 = new Account ();
            accSite22.name = 'SUN Test Account22';
            accSite22.recordtypeid=rtMapByName.get('Site').getRecordTypeId(); 
            accSite22.BillingStreet = '1040 N 326 W';
            accSite22.billingcity = 'Orem';
            accSite22.BillingState = 'UT';
            accSite22.Billingcountry = 'USA';
            accSite22.OMX_Primary_Key__c = '223461';
            accSite22.Oracle_Party_Id__c = '223461';
            accSite22.AOPS_Cust_Id__c = '223461';
            accSite22.status__c='Active';
            accSite22.Related_Account__c = acc2.Id; 
            sites.add(accSite22);
            
            Account accSite23 = new Account ();
            accSite23.name = 'SUN Test Account23';
            accSite23.recordtypeid=rtMapByName.get('Site').getRecordTypeId(); 
            accSite23.BillingStreet = '1040 N 326 W';
            accSite23.billingcity = 'Orem';
            accSite23.BillingState = 'UT';
            accSite23.Billingcountry = 'USA';
            accSite23.OMX_Primary_Key__c = '223462';
            accSite23.Oracle_Party_Id__c = '223462';
            accSite23.AOPS_Cust_Id__c = '223462';
            accSite23.status__c='Inactive';
            accSite23.Related_Account__c = acc2.Id; 
            sites.add(accSite23);
            
            
            
            insert sites;
                      
            Contact accCntc = new Contact();
            accCntc.LastName='LastNametest1';
            accCntc.email='testemail1@test.com';
            accCntc.AccountId = acc.id;
            accCntc.OMX_Primary_Key__c='4321';
            contacts.add(accCntc);
            
            insert contacts;

            Customer_Transition__c CT1 = new Customer_Transition__c(name='test',account__c = acc.id,Status__c='On Deck',Billing_Frequency_Excptn__c = true,AOPS_Flag__c='Y',OMX_Primary_Key__c='223457',Transition_Status__c='Inactive');
            insert CT1;
            
            
            Customer_Transition__c CT = new Customer_Transition__c(name='test',account__c = acc.id,Status__c='On Deck',Billing_Frequency_Excptn__c = true,AOPS_Flag__c='Y',OMX_Primary_Key__c='123457',Transition_Status__c='Inactive',Parent_Transition_ID__c=CT1.Id);
            //insert CT;
            ctList.add(CT);
            
            Customer_Transition__c CT2 = new Customer_Transition__c(name='test',account__c = acc.id,Status__c='On Deck',Billing_Frequency_Excptn__c = true,AOPS_Flag__c='Y',OMX_Primary_Key__c='323457',Transition_Status__c='Inactive',Parent_Transition_ID__c=CT1.Id);
            //insert CT;
            ctList.add(CT2);
      
            insert ctList;
           
            Customer_Transition_Dtls__c ctCTD1 = new Customer_Transition_Dtls__c(account_Id__c = acc.id,Customer_Transition_ID__c=CT.id,Status__c='Active',OMX_Primary_Key__c='543456',recordtypeid=DtlsSiteRcdTypeID,AOPS_Flag__c='Y');
            Customer_Transition_Dtls__c ctCTD2 = new Customer_Transition_Dtls__c(account_Id__c = acc.id,Customer_Transition_ID__c=CT.id,Status__c='Active',OMX_Primary_Key__c='543457',recordtypeid=DtlsSiteRcdTypeID,AOPS_Flag__c='Y');
            Customer_Transition_Dtls__c ctCTD3 = new Customer_Transition_Dtls__c(account_Id__c = acc.id,Customer_Transition_ID__c=CT.id,Status__c='Active',OMX_Primary_Key__c='543458',recordtypeid=DtlsSiteRcdTypeID,AOPS_Flag__c='N');
            
            Customer_Transition_Dtls__c ct2CTD1 = new Customer_Transition_Dtls__c(account_Id__c = acc.id,Customer_Transition_ID__c=CT2.id,Status__c='Active',OMX_Primary_Key__c='643456',recordtypeid=DtlsSiteRcdTypeID,AOPS_Flag__c='Y');
            Customer_Transition_Dtls__c ct2CTD2 = new Customer_Transition_Dtls__c(account_Id__c = acc.id,Customer_Transition_ID__c=CT2.id,Status__c='Active',OMX_Primary_Key__c='643457',recordtypeid=DtlsSiteRcdTypeID,AOPS_Flag__c='Y');
            Customer_Transition_Dtls__c ct2CTD3 = new Customer_Transition_Dtls__c(account_Id__c = acc.id,Customer_Transition_ID__c=CT2.id,Status__c='Active',OMX_Primary_Key__c='643458',recordtypeid=DtlsSiteRcdTypeID,AOPS_Flag__c='N');
            
            ctCTD1.Ship_2_Bill_2_Code__c = 'B';
          	ctCTD2.Ship_2_Bill_2_Code__c = 'SB';
            
            ctdList.add(ctCTD1);
            ctdList.add(ctCTD2);
            ctdList.add(ctCTD3);
            
            ctdList.add(ct2CTD1);
            ctdList.add(ct2CTD2);
            ctdList.add(ct2CTD3);
                       
            insert ctdList;
            
            system.debug('###Accounts'+accounts);
            system.debug('###Sites'+sites);
            system.debug('###Contacts'+contacts);
            system.debug('###ctList'+ctList);
            system.debug('###ctdList'+ctdList);
            
            ctList.clear();
            
            Test.startTest();
            
            ctList = [Select Id, Final_Split_Decision__c,No_of_Active_Sites__c,Account_Splitting_Required_frmla__c from Customer_Transition__c where OMX_Primary_Key__c in ('123457')];
            
             List<Customer_Transition__c> tmpCtList = [Select Id, Final_Split_Decision__c,No_of_Active_Sites__c,Account_Splitting_Required_frmla__c from Customer_Transition__c where OMX_Primary_Key__c in ('323457')];
             
            tmpCtList[0].Status__c='On Deck';
            update tmpCtList;
            
            tmpCtList[0].Final_Split_Decision__c = 'Yes' ;  
            tmpCtList[0].Ready_For_Mod_5__c =true;
            tmpCtList[0].Split_Launching_Status__c= null;
            update tmpCtList;           
            system.debug('###ctListNo_of_Active_Sites__c'+ctList[0].No_of_Active_Sites__c);
            
            
            system.debug('###Account_Splitting_Required_frmla__c'+ctList[0].Account_Splitting_Required_frmla__c);
            
            
            ctList[0].Status__c='On Deck';
            update ctList;
            
            system.debug('###ctList'+ctList);
            
            ctList[0].Final_Split_Decision__c = 'Yes' ;    
            system.debug('###ctListBeforeUpdate'+ctList);           
            executeoncetest.customerTransition_beforeUpdate = true;
            update ctList;
            system.debug('###ctListAfterUpdate'+ctList);      


            ctList[0].Final_Split_Decision__c = 'No' ;    
            ctList[0].Ready_For_Mod_5__c =false;
            ctList[0].Ready_for_Mod1__c = false;
            system.debug('###ctListBeforeUpdate'+ctList);           
            executeoncetest.customerTransition_beforeUpdate = true;
            update ctList;
            system.debug('###ctListAfterUpdate'+ctList);      

            ctList[0].Final_Split_Decision__c = 'Yes' ;    
            ctList[0].Ready_for_Mod1__c = true;
            system.debug('###ctListBeforeUpdate'+ctList);           
            executeoncetest.customerTransition_beforeUpdate = true;
            update ctList;
            system.debug('###ctListAfterUpdate'+ctList);                
            
            //Updated SAD with new Master OMX
            List<Split_Account_Detail__c> sads= [Select Id, Customer_Transition__c,Linked_Customer_Transition__c, Original_Account__c, OMX_ACCOUNT__c,Master_Account__c,status__c,
            Main_Account_Name__c,
            NEW_BILL_TO_OMX_CONSIGNEE__c,
            NEW_MAIN_ACCT_ADDRESS__c,
            AP_CONTACT_FIRST_NAME__c,
            AP_CONTACT_LAST_NAME__c,
            NEW_BILLING_TYPE_AT_HEADER_LEVEL__c,
            New_Header_Billing_Account__r.Related_Account__c
            from Split_Account_Detail__c where OMX_ACCOUNT__c = '123457' and Master_Account__c=''];
            
            system.debug('###sads'+sads);
            
            List<Split_Account_Detail__c> upSads = new  List<Split_Account_Detail__c> ();
            integer i=1;
                for(Split_Account_Detail__c sad : sads)
                {
                sad.Master_Account__c='123457-'+i;
                String name = 'SUN Test Account';
                sad.Main_Account_Name__c=name+'-'+i;
                sad.NEW_BILL_TO_OMX_CONSIGNEE__c = '';	
                sad.NEW_MAIN_ACCT_ADDRESS__c = '543458';
                sad.AP_CONTACT_FIRST_NAME__c = 'First' ;
                sad.AP_CONTACT_LAST_NAME__c = 'Last';
                sad.NEW_BILLING_TYPE_AT_HEADER_LEVEL__c = 'DI';
                sad.New_Header_Billing_Account__c = acc.id;
                sad.Linked_Customer_Transition__c = ctList[0].Id;	
                upSads.add(sad);
                i=i+1;
                
                }
            
            update upSads;
            
            List<Customer_Transition__c> tmpCtList1 = [Select Id, Final_Split_Decision__c,No_of_Active_Sites__c,Account_Splitting_Required_frmla__c from Customer_Transition__c where OMX_Primary_Key__c in ('123457')];
            update tmpCtList1;
            
            ctList[0].Ready_For_Mod_5__c = true ;
            
            executeoncetest.customerTransition_beforeUpdate = true;
            update ctList;
            
            accounts.clear();
            
            accounts = [select id,Mod_5_EBS_Sync_Status__c,OMX_Primary_Key__c from account where OMX_Primary_Key__c in ('123457-1','123457-2') ];
            List<Account> updateAcc = new List<Account>();
            for(Account eachNewAcc : accounts)
            {
            eachNewAcc.Mod_5_EBS_Sync_Status__c = 'SUCCESS';
            updateAcc.add(eachNewAcc);
            }
            update updateAcc;
            system.debug('###sads'+updateAcc);
            

            String strQuery = '';
            Mod5LaunchBatchClass  Mod5LaunchBatchObj = new Mod5LaunchBatchClass (strQuery);
            database.executebatch(Mod5LaunchBatchObj, 1);
            
            Test.stopTest();
            
            }
            
        }  
        // Added for the story #S-355234 #END */
}