@isTest
private class AccountTestClasses
{

    static testMethod void AccountTestClassesUnitTest() 
    {
         Profile profileObj = [select id from profile where name='System Administrator'];
     Id CustOMX = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Customer (OfficeMax)').getRecordTypeId();



         String profId = profileObj.id;
         user usrObj = new user(Username='abc123@officedepot.com.uat',FirstName ='Fname',
          LastName='Lname', Alias='abc123', CommunityNickname='abc123', LocaleSidKey='en_US', EmailEncodingKey='UTF-8', 
         Profileid = profId, LanguageLocaleKey='en_US', email='abc123@officedepot.com.uat',TimeZoneSidKey='America/New_York');
         usrObj.Short_Title__c='';
         Insert usrObj;
        system.runAs(usrObj){
        Sales_Person__c s= new Sales_Person__c();
        s.IsActive__c=true;
        s.Role_Relate_Id__c ='777777';
        s.Primary__c =true;
        s.user__c=usrObj.id;
        insert s;


        Account oldRelatedAcc = new Account ();
        oldRelatedAcc.recordtypeId=CustOMX ;
        //oldRelatedAcc.Related_Account__c=acc;
        oldRelatedAcc.name = 'SUN Test Account1';
        oldRelatedAcc.BillingStreet = '1039 N 326 W';
        oldRelatedAcc.billingcity = 'Orem';
        oldRelatedAcc.BillingState = 'UT';
        oldRelatedAcc.Billingcountry = 'USA';
        oldRelatedAcc.Oracle_Party_Id__c = '123457';
        oldRelatedAcc.AOPS_Cust_Id__c = '123457';
        oldRelatedAcc.omx_primary_key__C= '123457';

        oldRelatedAcc.OwnerID = usrObj.Id;// This is the salesforce User ID
        oldRelatedAcc.Sales_PersonID__c = s.Id; //Sales person Id for the Salesforce USer
        insert oldRelatedAcc;

        
        /*Account_Extension__c rec = new Account_Extension__c();
        rec.omx_primary_key__C= '123457';
        rec.name = 'SUN Test Account1';
        rec.Original_Account_ID__c=oldRelatedAcc.Id;
        insert rec;*/
        
        Account_Extension__c  rec=[select Id from Account_Extension__c  where Account__c=:oldRelatedAcc.Id];
        
        
        Account_Dormant__c  recnew= new Account_Dormant__c ();
        recnew.AccountExtension__c=rec.Id;
        recnew.Original_Account_ID__c=oldRelatedAcc.Id;
        recnew.Name= 'SUN Test Account1';
        insert recnew;
         Test.startTEst();
        
        Customer_transition__C CT=[select Id from Customer_transition__C  where account__C=:oldRelatedAcc.Id];
        delete CT;
        delete oldRelatedAcc;
        
        Account oldRelatedAcc1 = new Account ();
        oldRelatedAcc1.recordtypeId=CustOMX ;
        //oldRelatedAcc1.Related_Account__c=acc;
        oldRelatedAcc1.name = 'SUN Test Account1';
        oldRelatedAcc1.BillingStreet = '1039 N 326 W';
        oldRelatedAcc1.billingcity = 'Orem';
        oldRelatedAcc1.BillingState = 'UT';
        oldRelatedAcc1.Billingcountry = 'USA';
        oldRelatedAcc1.Oracle_Party_Id__c = '123457';
        oldRelatedAcc1.AOPS_Cust_Id__c = '123457';
        oldRelatedAcc1.omx_primary_key__C= '123457';

        oldRelatedAcc1.OwnerID = usrObj.Id;// This is the salesforce User ID
        oldRelatedAcc1.Sales_PersonID__c = s.Id; //Sales person Id for the Salesforce USer
        insert oldRelatedAcc1;
        
      
            Id BusinessPro= Schema.SObjectType.Account.getRecordTypeInfosByName().get('Customer (Business Pro)').getRecordTypeId();

        Account BusinnessProaccount= new Account ();
        BusinnessProaccount.recordtypeId=BusinessPro;
        //oldRelatedAcc1.Related_Account__c=acc;
        BusinnessProaccount.name = 'BusinnessProaccount';
        BusinnessProaccount.Loyatly_Number__c='123';
        insert BusinnessProaccount;
       
       
       TEst.stoptest();
        }
        
        }
        
        }