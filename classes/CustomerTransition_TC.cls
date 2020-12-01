@isTest
private class CustomerTransition_TC
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
            
            
            
            Account acc1 = new Account ();
            acc1.name = 'SUN Test Account';
            acc1.BillingStreet = '1040 N 326 W';
            acc1.billingcity = 'Orem';
            acc1.BillingState = 'UT';
            acc1.Billingcountry = 'USA';
            acc1.OMX_Primary_Key__c = '123459';
            acc1.Oracle_Party_Id__c = '123459';
            acc1.AOPS_Cust_Id__c = '123459';
            acc1.status__c='Active';
            acc1.Split_Record__c = true;
            acc1.Segment__c='Federal';
            
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
            acc.status__c='Active';
            acc.Split_Record__c = true;
            acc.Segment__c='Federal';
            acc.ParentId=acc1.Id;
            accounts.add(acc);
            
            insert accounts;
              Test.startTest();
            
            for(integer i=0 ;i<10;i++){
            
            
            Account accSite1 = new Account ();
            accSite1.name = 'SUN Test Account21';
            accSite1.recordtypeid=rtMapByName.get('Site').getRecordTypeId(); 
            accSite1.BillingStreet = '1040 N 326 W';
            accSite1.billingcity = 'Orem';
            accSite1.BillingState = 'UT';
            accSite1.Billingcountry = 'USA';
            accSite1.OMX_Primary_Key__c = '123460'+string.valueof(i);
            accSite1.Oracle_Party_Id__c = '123460'+string.valueof(i);
            accSite1.status__c='Active';
            accSite1.Related_Account__c = acc.Id;
            
            sites.add(accSite1);
            
            }
            insert sites;
            
                      
            /*Contact accCntc = new Contact();
            accCntc.LastName='LastNametest1';
            accCntc.email='testemail1@test.com';
            accCntc.AccountId = acc.id;
            accCntc.OMX_Primary_Key__c='4321';
            contacts.add(accCntc);
            
            insert contacts;*/
            
                    

            
            Customer_Transition__c CTParent = new Customer_Transition__c(name='test',account__c = acc1.id,Status__c='On Deck',
            Billing_Frequency_Excptn__c = true,AOPS_Flag__c='Y',OMX_Primary_Key__c='123459',Transition_Status__c='Active');
            insert CTParent ;
                        
            Customer_Transition__c CT = new Customer_Transition__c(name='test',account__c = acc.id,Status__c='ReScheduled',
            Billing_Frequency_Excptn__c = true,AOPS_Flag__c='Y',OMX_Primary_Key__c='123457',Transition_Status__c='Active',
            Parent_Transition_ID__c=CTParent.Id,Written_Core_Request_WRF__c=true,Local_Core__c=true);
            //insert CT;
            ctList.add(CT);
      
            insert ctList;
           
           
           for(Account accREc:sites){
            Customer_Transition_Dtls__c ctCTD1 = new Customer_Transition_Dtls__c(account_Id__c = accREc.id,Customer_Transition_ID__c=CT.id,Status__c='Active',
            OMX_Primary_Key__c=accREc.omx_primary_key__C,recordtypeid=DtlsSiteRcdTypeID,AOPS_Flag__c='Y');
            ctdList.add(ctCTD1);
            }            
            insert ctdList;
            
            //Test.stopTest();
            
            
            ctList.clear();
            
            

            ctList = [Select Id, Final_Split_Decision__c,No_of_Active_Sites__c,Account_Splitting_Required_frmla__c
             from Customer_Transition__c where OMX_Primary_Key__c in ('123457')];
            
            
            ctList[0].Status__c='On Deck';
            ctList[0].Written_Agreement_Custom_Core_Request__c='Create WRF';
                        executeoncetest.customerTransition_beforeUpdate = true;

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

            Test.stopTest();
            

            
            }
        
        }   
        }