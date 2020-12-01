@isTest
private class OMXAccountTrigger_TC 
{
    
        static testMethod void validTestMethod()
        {
        
         executeoncetest.bypassAccountExtension = true;
        
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
            acc.Sales_PersonID__c = s.id;
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
                  
            
            Test.startTest();
                      
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
            
            ctList = [Select Id, Final_Split_Decision__c,isaccountowneractive__C,No_of_Active_Sites__c,Account_Splitting_Required_frmla__c,Ready_For_Mod_5__c from Customer_Transition__c where OMX_Primary_Key__c in ('123457')];
            
            system.debug('###ctListNo_of_Active_Sites__c'+ctList[0].No_of_Active_Sites__c);
            system.debug('###Ready_For_Mod_5__c'+ctList[0].Ready_For_Mod_5__c);
             system.debug('###Ready_For_Mod_5__c'+ctList[0].isaccountowneractive__C);
            
            
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
            

            Test.stopTest();
            
            }
        
        }   
        }