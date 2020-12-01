@isTest
private class CT_CascadeStatus_TC
{
    
    static testMethod void validTestMethod()
    {
    
         List<Account> accounts = new List<Account>();
         List<Customer_Transition__c> ctList = new List<Customer_Transition__c>();
         
   
         Profile profileObj = [select id from profile where name='System Administrator'];

         String profId = profileObj.id;
         user usrObj = new user(Username='abc@officedepot.com.uat',FirstName ='Fname', LastName='Lname', Alias='abc', CommunityNickname='abc', LocaleSidKey='en_US', EmailEncodingKey='UTF-8', Profileid = profId, LanguageLocaleKey='en_US', email='abc@officedepot.com.uat',TimeZoneSidKey='America/New_York');
         usrObj.Short_Title__c='';
         Insert usrObj;
        system.runAs(usrObj){
        Sales_Person__c s= new Sales_Person__c();
        s.IsActive__c=true;
        s.Role_Relate_Id__c ='333333';
        s.Primary__c =true;
        s.user__c=usrObj.id;
        insert s;         
                  
      
           
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
            accounts.add(acc);
            
            Account accSite1 = new Account ();
            accSite1.name = 'SUN Test Account21';
            accSite1.BillingStreet = '1040 N 326 W';
            accSite1.billingcity = 'Orem';
            accSite1.BillingState = 'UT';
            accSite1.Billingcountry = 'USA';
            accSite1.OMX_Primary_Key__c = '123460';
            accSite1.Oracle_Party_Id__c = '123460';
            accSite1.AOPS_Cust_Id__c = '123460';
            accSite1.status__c='Active';
            accounts.add(accSite1);
            
            Account accSite2 = new Account ();
            accSite2.name = 'SUN Test Account22';
            accSite2.BillingStreet = '1040 N 326 W';
            accSite2.billingcity = 'Orem';
            accSite2.BillingState = 'UT';
            accSite2.Billingcountry = 'USA';
            accSite2.OMX_Primary_Key__c = '123461';
            accSite2.Oracle_Party_Id__c = '123461';
            accSite2.AOPS_Cust_Id__c = '123461';
            accSite2.status__c='Active';
            accounts.add(accSite2);
            
            Account accSite3 = new Account ();
            accSite3.name = 'SUN Test Account23';
            accSite3.BillingStreet = '1040 N 326 W';
            accSite3.billingcity = 'Orem';
            accSite3.BillingState = 'UT';
            accSite3.Billingcountry = 'USA';
            accSite3.OMX_Primary_Key__c = '123462';
            accSite3.Oracle_Party_Id__c = '123462';
            accSite3.AOPS_Cust_Id__c = '123462';
            accSite3.status__c='Inactive';
            accounts.add(accSite3);
            
            insert accounts;
                  Test.startTest();     
            
            Customer_Transition__c wtCT1 = new Customer_Transition__c(name='test',account__c = acc.id,Status__c='On Deck',Billing_Frequency_Excptn__c = true,AOPS_Flag__c='Y',OMX_Primary_Key__c='123457',Transition_Status__c='Active',Written_Agreement__c =true);
            insert wtCT1;
            Customer_Transition__c CT2 = new Customer_Transition__c(name='test1',account__c = accSite1.id,Status__c='On Deck',Billing_Frequency_Excptn__c = true,AOPS_Flag__c='Y',OMX_Primary_Key__c='123460',Transition_Status__c='Active',Written_Agreement_ID__c=wtCT1.Id );
            ctList.add(CT2);
            Customer_Transition__c CT3 = new Customer_Transition__c(name='test2',account__c = accSite2.id,Status__c='On Deck',Billing_Frequency_Excptn__c = true,AOPS_Flag__c='Y',OMX_Primary_Key__c='123461',Transition_Status__c='Active',Written_Agreement_ID__c=wtCT1.Id );
            ctList.add(CT3);
            Customer_Transition__c CT4 = new Customer_Transition__c(name='test3',account__c = accSite3.id,Status__c='On Deck',Billing_Frequency_Excptn__c = true,AOPS_Flag__c='Y',OMX_Primary_Key__c='123462',Transition_Status__c='Active',Written_Agreement_ID__c=wtCT1.Id );
            ctList.add(CT4);
      
            insert ctList;
            CT_CascadeStatus obj = new CT_CascadeStatus();
            obj.mapCTidrec = new Map<Id,String>();
            obj.mapCTidrec.put(wtCT1.Id,wtCT1.OMX_Primary_Key__c);
            wtCT1.Customer_Disposition__c='Customer going to RFP' ;
            update wtCT1;
            
            wtCT1.Contract_Extension_Complete__c = true;
            wtCT1.Review_Start_Date__c = Date.today();
            update wtCT1;
            Test.stopTest();
        }
                 
    }   
        
}