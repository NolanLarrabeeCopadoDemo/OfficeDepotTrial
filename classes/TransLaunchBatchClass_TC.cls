/**
 * This class contains unit tests for validating the behaviour of Apex classes
 * TransLaunchBatchClass.
 *
*/
@isTest
private class TransLaunchBatchClass_TC {

     static testMethod void myUnitTest() {
         List<Account> accounts = new List<Account>();
         List<Customer_Transition__c> ctList = new List<Customer_Transition__c>();
         List<Transition_Launch__c> tranLaunchList = new List<Transition_Launch__c>();
         Schema.DescribeSObjectResult d1 = Schema.SObjectType.Account; 
         Map<String,Schema.RecordTypeInfo> rtMapByName = d1.getRecordTypeInfosByName();
   
   
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
            Account pacc = new Account ();
            pacc.name = 'SUN Test Account Parent';
            pacc.BillingStreet = '1041 N 325 W';
            pacc.billingcity = 'Orem1';
            pacc.BillingState = 'UA';
            pacc.Billingcountry = 'USA';
            pacc.OMX_Primary_Key__c = '123464';
            pacc.Oracle_Party_Id__c = '123464';
            pacc.AOPS_Cust_Id__c = '123464';
            pacc.status__c='Active';
            pacc.Segment__c='Federal';
            pacc.Sales_PersonID__c = s.id;
            insert pacc;
            
            system.debug('pacc@@@'+pacc);
            
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
            acc.Segment__c='Federal';
            acc.parentid=pacc.id;
            acc.Sales_PersonID__c = s.id;
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
            system.debug('accounts@@@'+accounts);
            
            Customer_Transition__c parentwtCT1 = new Customer_Transition__c(name='Customer Transition Parent of test1',account__c = pacc.id,Status__c='On Deck',Billing_Frequency_Excptn__c = true,AOPS_Flag__c='Y',OMX_Primary_Key__c='123464',Transition_Status__c='Active',Written_Agreement__c =true,Review_Start_Date__c = Date.Today(),Ready_for_Mod1__c=false);
            insert parentwtCT1;
            Customer_Transition__c wtCT1 = new Customer_Transition__c(name='Customer Transition Parent of test',account__c = acc.id,Status__c='On Deck',Billing_Frequency_Excptn__c = true,AOPS_Flag__c='Y',OMX_Primary_Key__c='123457',Transition_Status__c='Active',Written_Agreement_ID__c=parentwtCT1.Id,Parent_Transition_ID__c=parentwtCT1.Id,Review_Start_Date__c = Date.Today());
            insert wtCT1;
            
            Customer_Transition__c CT2 = new Customer_Transition__c(name='test1',account__c = accSite1.id,Status__c='On Deck',Billing_Frequency_Excptn__c = true,AOPS_Flag__c='Y',OMX_Primary_Key__c='123460',Transition_Status__c='Active',Written_Agreement_ID__c=parentwtCT1.Id,Parent_Transition_ID__c=parentwtCT1.Id,Review_Start_Date__c = Date.Today());
            ctList.add(CT2);
            Customer_Transition__c CT3 = new Customer_Transition__c(name='test2',account__c = accSite2.id,Status__c='On Deck',Billing_Frequency_Excptn__c = true,AOPS_Flag__c='Y',OMX_Primary_Key__c='123461',Transition_Status__c='Active',Written_Agreement_ID__c=parentwtCT1.Id,Parent_Transition_ID__c=parentwtCT1.Id ,Review_Start_Date__c = Date.Today());
            ctList.add(CT3);
            Customer_Transition__c CT4 = new Customer_Transition__c(name='test3',account__c = accSite3.id,Status__c='On Deck',Billing_Frequency_Excptn__c = true,AOPS_Flag__c='Y',OMX_Primary_Key__c='123462',Transition_Status__c='Active',Written_Agreement_ID__c=parentwtCT1.Id,Parent_Transition_ID__c=parentwtCT1.Id ,Review_Start_Date__c = Date.Today());
            ctList.add(CT4);
            
            insert ctList;
            
            system.debug('parentwtCT1&&&'+parentwtCT1);
            system.debug('ctList&&&'+ctList);
            ctList.clear();
            
            parentwtCT1.Status__c='On Deck';
            wtCT1.Status__c='On Deck';
            CT2.Status__c='On Deck';
            CT3.Status__c='On Deck';
            CT4.Status__c='On Deck';
            
            ctList.add(parentwtCT1);
            ctList.add(wtCT1);
            ctList.add(CT2);
            ctList.add(CT3);
            ctList.add(CT4);
            update ctList;
            system.debug('ctList-OnDeck&&&'+ctList);
            
            Transition_Launch__c  rec = new Transition_Launch__c(OMX_Key__c='123457',Status__c = 'Submit',Type__c = 'Parent');
            Transition_Launch__c  rec1 = new Transition_Launch__c(OMX_Key__c='123460',Status__c = 'Submit',Type__c = 'Parent');
            Transition_Launch__c  rec2 = new Transition_Launch__c(OMX_Key__c='123461',Status__c = 'ReSubmit',Type__c = 'Parent');
            Transition_Launch__c  rec3 = new Transition_Launch__c(OMX_Key__c='123462',Status__c = 'ReSubmit',Type__c = 'Parent');
            
            tranLaunchList.add(rec);
            tranLaunchList.add(rec1);
            tranLaunchList.add(rec2);
            tranLaunchList.add(rec3);
            
            insert tranLaunchList;
            system.debug('tranLaunchList&&&'+tranLaunchList);
            
            TransLaunchBatchClass batchObj = new TransLaunchBatchClass();
            Database.executeBatch(batchObj,10);
                      
            String DEFAULT_QUERY ='Select OMX_Key__c'
                                   +' FROM Transition_Launch__c'
                                   +' WHERE TYpe__c = \'Parent\'  and   (Status__c = \'Submit\' or Status__c = \'ReSubmit\' ) Limit 500'; 
            
            TransLaunchBatchClass batchObj2 = new TransLaunchBatchClass(DEFAULT_QUERY);
            Database.executeBatch(batchObj2,10);
            
            Test.stopTest();
        }
    }
     static testMethod void myUnitTest1() {
           List<Account> accounts = new List<Account>();
         List<Customer_Transition__c> ctList = new List<Customer_Transition__c>();
         List<Transition_Launch__c> tranLaunchList = new List<Transition_Launch__c>();
         Schema.DescribeSObjectResult d1 = Schema.SObjectType.Account; 
         Map<String,Schema.RecordTypeInfo> rtMapByName = d1.getRecordTypeInfosByName();
   
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
            Account pacc = new Account ();
            pacc.name = 'SUN Test Account Parent';
            pacc.BillingStreet = '1041 N 325 W';
            pacc.billingcity = 'Orem1';
            pacc.BillingState = 'UA';
            pacc.Billingcountry = 'USA';
            pacc.OMX_Primary_Key__c = '123464';
            pacc.Oracle_Party_Id__c = '123464';
            pacc.AOPS_Cust_Id__c = '123464';
            pacc.status__c='Active';
            pacc.Segment__c='Federal';
            pacc.Sales_PersonID__c = s.id;
            insert pacc;
            
            system.debug('pacc@@@'+pacc);
            
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
            acc.Segment__c='Federal';
            acc.parentid=pacc.id;
            acc.Sales_PersonID__c = s.id;
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
            system.debug('accounts@@@'+accounts);
            
            Customer_Transition__c parentwtCT1 = new Customer_Transition__c(name='Customer Transition Parent of test1',account__c = pacc.id,Status__c='On Deck',Billing_Frequency_Excptn__c = true,AOPS_Flag__c='Y',OMX_Primary_Key__c='123464',Transition_Status__c='Active',Written_Agreement__c =true,Review_Start_Date__c = Date.Today(),Ready_for_Mod1__c=false);
            insert parentwtCT1;
            Customer_Transition__c wtCT1 = new Customer_Transition__c(name='Customer Transition Parent of test',account__c = acc.id,Status__c='On Deck',Billing_Frequency_Excptn__c = true,AOPS_Flag__c='Y',OMX_Primary_Key__c='123457',Transition_Status__c='Active',Written_Agreement_ID__c=parentwtCT1.Id,Parent_Transition_ID__c=parentwtCT1.Id,Review_Start_Date__c = Date.Today());
            insert wtCT1;
            
            Customer_Transition__c CT2 = new Customer_Transition__c(name='test1',account__c = accSite1.id,Status__c='On Deck',Billing_Frequency_Excptn__c = true,AOPS_Flag__c='Y',OMX_Primary_Key__c='123460',Transition_Status__c='Active',Written_Agreement_ID__c=parentwtCT1.Id,Parent_Transition_ID__c=parentwtCT1.Id,Review_Start_Date__c = Date.Today());
            ctList.add(CT2);
            Customer_Transition__c CT3 = new Customer_Transition__c(name='test2',account__c = accSite2.id,Status__c='On Deck',Billing_Frequency_Excptn__c = true,AOPS_Flag__c='Y',OMX_Primary_Key__c='123461',Transition_Status__c='Active',Written_Agreement_ID__c=parentwtCT1.Id,Parent_Transition_ID__c=parentwtCT1.Id ,Review_Start_Date__c = Date.Today());
            ctList.add(CT3);
            Customer_Transition__c CT4 = new Customer_Transition__c(name='test3',account__c = accSite3.id,Status__c='On Deck',Billing_Frequency_Excptn__c = true,AOPS_Flag__c='Y',OMX_Primary_Key__c='123462',Transition_Status__c='Active',Written_Agreement_ID__c=parentwtCT1.Id,Parent_Transition_ID__c=parentwtCT1.Id ,Review_Start_Date__c = Date.Today());
            ctList.add(CT4);
            
            insert ctList;
            
            system.debug('parentwtCT1&&&'+parentwtCT1);
            system.debug('ctList&&&'+ctList);
            ctList.clear();
            
            parentwtCT1.Status__c='On Deck';
            wtCT1.Status__c='On Deck';
            CT2.Status__c='On Deck';
            CT3.Status__c='On Deck';
            CT4.Status__c='On Deck';
            
            ctList.add(parentwtCT1);
            ctList.add(wtCT1);
            ctList.add(CT2);
            ctList.add(CT3);
            ctList.add(CT4);
            update ctList;
            system.debug('ctList-OnDeck&&&'+ctList);
            
            Transition_Launch__c  rec = new Transition_Launch__c(OMX_Key__c='123457',Status__c = 'Submit',Type__c = 'Parent');
            Transition_Launch__c  rec1 = new Transition_Launch__c(OMX_Key__c='123460',Status__c = 'Submit',Type__c = 'Parent');
            Transition_Launch__c  rec2 = new Transition_Launch__c(OMX_Key__c='123461',Status__c = 'ReSubmit',Type__c = 'Parent');
            Transition_Launch__c  rec3 = new Transition_Launch__c(OMX_Key__c='123462',Status__c = 'ReSubmit',Type__c = 'Parent');
            
            tranLaunchList.add(rec);
            tranLaunchList.add(rec1);
            tranLaunchList.add(rec2);
            tranLaunchList.add(rec3);
            
            insert tranLaunchList;
            system.debug('tranLaunchList&&&'+tranLaunchList);
            
            TransLaunchBatchClass batchObj = new TransLaunchBatchClass();
            Database.executeBatch(batchObj,10);
            
            String DEFAULT_QUERY ='Select OMX_Key__c'
                                   +' FROM Transition_Launch__c'
                                   +' WHERE TYpe__c = \'Parent\'  and   (Status__c = \'Submit\' or Status__c = \'ReSubmit\' ) Limit 500';
                                   
            TransLaunchBatchClass batchObj1 = new TransLaunchBatchClass();
            Database.executeBatch(batchObj1,10);
            
            
            parentwtCT1.Status__c='Loss of Customer';
            wtCT1.Status__c='Loss of Customer';
            CT2.Status__c='Loss of Customer';
            CT3.Status__c='Loss of Customer';
            CT4.Status__c='Loss of Customer';
            
            parentwtCT1.Transition_Status__c='Inactive';
            wtCT1.Transition_Status__c='Inactive';
            CT2.Transition_Status__c='Inactive';
            CT3.Transition_Status__c='Inactive';
            CT4.Transition_Status__c='Inactive';
            
            //parentwtCT1.Final_Split_Decision__c='Yes';
            //wtCT1.Final_Split_Decision__c='Yes';
            //CT2.Final_Split_Decision__c='Yes';
            //CT3.Final_Split_Decision__c='Yes';
            //CT4.Final_Split_Decision__c='Yes';
            
            parentwtCT1.AOPS_Flag__c='N';
            wtCT1.AOPS_Flag__c='N';
            CT2.AOPS_Flag__c='N';
            CT3.AOPS_Flag__c='N';
            CT4.AOPS_Flag__c='N';
            
            acc.Segment__c=null;

            Sales_Person__c s1= new Sales_Person__c();
            s1.IsActive__c=true;
            s1.Role_Relate_Id__c ='';
            s1.name='Awaiting SalesID';
            s1.Primary__c =true;
            s1.user__c=usrObj.id;
            insert s1;  
            
            //pacc.OwnerID = inactvUsrObj.id;
           pacc.Sales_PersonID__c = s1.id;
            
            //acc.OwnerID = inactvUsrObj.id;
            acc.Sales_PersonID__c = s1.id;
            
            pacc.split_record__C = true;
            acc.split_record__C = true;
            
            pacc.status__c = 'Inactive';
            acc.status__c = 'Inactive';
            pacc.OMX_Mainframe_Account_Level__c = 'Main Account';
            acc.OMX_Mainframe_Account_Level__c = 'Main Account';
            
            ctList.clear();
            accounts.clear();
            
            ctList.add(parentwtCT1);
            ctList.add(wtCT1);
            ctList.add(CT2);
            ctList.add(CT3);
            ctList.add(CT4);
            update ctList;  
            system.debug('ctList-OnDeck&&&'+ctList);
            
            accounts.add(pacc);
            accounts.add(acc);
            
            update accounts;
                                               
            TransLaunchBatchClass batchObj2 = new TransLaunchBatchClass(DEFAULT_QUERY);
            Database.executeBatch(batchObj2,10);
            
            TransLaunchBatchClass batchObj3 = new TransLaunchBatchClass();
            Database.executeBatch(batchObj3,10);
            
            DateTime sysTime = System.now().addSeconds(300);
            String chronExpression = '' + sysTime.second() + ' ' + sysTime.minute() + ' ' + sysTime.hour() + ' ' + sysTime.day() + ' ' + sysTime.month() + ' ? ' + sysTime.year();
    
            TransLaunchBatchClass batchObj4 = new TransLaunchBatchClass();
            ID cronid = System.schedule( 'TransLaunchBatchClass' + sysTime, chronExpression, batchObj4 );    
        
            Test.stopTest();
        }
    }

}