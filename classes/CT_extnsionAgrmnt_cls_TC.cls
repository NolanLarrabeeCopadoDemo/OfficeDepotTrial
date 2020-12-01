@istest

public class CT_extnsionAgrmnt_cls_TC
    {
        static testMethod void Method1()
        
    {
    try{
      List<Account> accList = new List<Account>();
      List<Customer_Transition__c> custList = new List<Customer_Transition__c>();     
      
      
      Profile profileObj = [select id from profile where name='System Administrator']; 
      
       String profId = profileObj.id;
       user usrObj = new user(Username='abc@officedepot.com.uat',FirstName ='Fname', LastName='Lname', Alias='abc', CommunityNickname='abc', LocaleSidKey='en_US', EmailEncodingKey='UTF-8', Profileid = profId, LanguageLocaleKey='en_US', email='abc@officedepot.com.uat',TimeZoneSidKey='America/New_York');
       usrObj.Short_Title__c='';
       Insert usrObj;   
       
       Sales_Person__c sales= new Sales_Person__c();
       sales.IsActive__c=true;
       sales.Role_Relate_Id__c ='333333';
       sales.Primary__c =true;
       sales.user__c=usrObj.id;
       insert sales;
       
       
        System.runAs(usrObj)
        {
            Test.startTest();
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
            accList.add(acc);
            insert accList; //S-407207 [OD Case # 00678706] - [Hemant 5/6/2016]
                       
          Customer_Transition__c CusTrans = new Customer_Transition__c();
          CusTrans.name='test';
          CusTrans.Account__c=acc.id;
          CusTrans.Status__c='On Deck';
          CusTrans.Billing_Frequency_Excptn__c=true;
          CusTrans.AOPS_Flag__c='Y';
          CusTrans.OMX_Primary_Key__c='123457';
          CusTrans.Transition_Status__c='Active';
          CusTrans.Written_Agreement__c = true;
                   
          custList.add(CusTrans); 
        
          Customer_Transition__c CusTrans1 = new Customer_Transition__c();
          CusTrans1.name='test1';
          CusTrans1.Account__c=acc.id;
          CusTrans1.Status__c='On Deck';
          CusTrans1.Billing_Frequency_Excptn__c=true;
          CusTrans1.AOPS_Flag__c='Y';
          CusTrans1.OMX_Primary_Key__c='123456';
          CusTrans1.Transition_Status__c='Active';
          CusTrans1.Written_Agreement__c = true;        
          custList.add(CusTrans1);
            
         
          insert custList; //S-407207 [OD Case # 00678706] - [Hemant 5/6/2016]
          
          CusTrans.Customer_Disposition__c='Extend current OMX Agreement'; 
          CusTrans1.Customer_Disposition__c='Customer RFP Received';
            custList.clear();
            custList.add(CusTrans); 
            custList.add(CusTrans1);
          // update custList;
           //Added by Najma Ateeq for Story #S-386202(OD Case Number - 00617674)
            Map<String,String> testMap = new Map<String,String>();
            testMap.put('123456','Test');
            
            CT_extnsionAgrmnt_cls.setExtAgrmnt(testMap);
            //Added by Najma Ateeq for Story #S-386202(OD Case Number - 00617674) 
          
          test.stoptest();
           }
           }catch(Exception e){}
           
        }
  }