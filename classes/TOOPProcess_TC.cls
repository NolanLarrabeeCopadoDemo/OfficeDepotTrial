@isTest
private class TOOPProcess_TC{

    static testMethod void validTestMethod(){
    
     List<Account> accounts = new List<Account>();
     List<Customer_Transition__c> ctList = new List<Customer_Transition__c>();
     List<OfficeMax_OfficeDepot_CrossReference__c> toopListObj = new List<OfficeMax_OfficeDepot_CrossReference__c>();
     //TOOPProcess toopProcessObj = new TOOPProcess(); 
    
       System.runAs(new user(ID = UserInfo.getUserID())){
        
    
    
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
                  
       
            Test.startTest();
            Account acc = new Account ();
            acc.name = 'SUN Test Account';
            acc.BillingStreet = '1040 N 326 W';
            acc.billingcity = 'Orem';
            acc.BillingState = 'UT';
            acc.Billingcountry = 'USA';
            acc.OMX_Primary_Key__c = '123457890';
            acc.Oracle_Party_Id__c = '123457';
            acc.AOPS_Cust_Id__c = '123457';
            acc.status__c='Active';
            acc.Split_Record__c = true;
            acc.Segment__c='Federal';
            accounts.add(acc);
            
            insert accounts;
             
            Customer_Transition__c CT = new Customer_Transition__c(name='test',account__c = acc.id,Status__c='TOOP',Billing_Frequency_Excptn__c = true,AOPS_Flag__c='Y',OMX_Primary_Key__c='123457890',Transition_Status__c='Active');
            insert CT;
            //ctList.add(CT);
      
            insert ctList;
            
            OfficeMax_OfficeDepot_CrossReference__c crossRefObj = new OfficeMax_OfficeDepot_CrossReference__c();
            crossRefObj.Source__c= 'O';
            crossRefObj.OMX_Key__c = '123457890';
            toopListObj.add(crossRefObj);
            
            insert toopListObj;
            
            //toopProcessObj.updateTOOP(toopListObj);
    }
    }
}