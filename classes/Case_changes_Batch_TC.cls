/***
Description: The test Class  for the ase_AccountDetails_update_Batch classes.
Created By: Ankur Pradhan
Created Date: 10-May-2012

Modified By:
Modified Date:

Modify Reason:
**/
@isTest()
private class Case_changes_Batch_TC
{

    public static testMethod void Case_AccountDetails_update_Batch_TC() 
    
    {
       try {
       id aid;
       map <case,id> Caseid_Accid_map = new map <case,id>();// Map of Case and Account ID
       list <case> Caseid_Accid_lst = new list <case>();// list of Case 
       Update_Cust_Prosp_detailsonCase Update_detailsonCase= new Update_Cust_Prosp_detailsonCase();
       
         Profile p4 = [SELECT Id FROM profile WHERE name='System Administrator'];   
         User u1 = new User(alias = 'test123 ', email='proxy@proxy456.officedepot.com',OD_Employee_ID__c='123466',emailencodingkey='UTF-8', lastname='test123',languagelocalekey='en_US',localesidkey='en_US', profileid = p4.Id,timezonesidkey='America/Los_Angeles',username='proxy@proxy456.com',isactive=true);
         insert u1; 
         
          Schema.DescribeSObjectResult CR = Schema.SObjectType.Case; 
         Map<String,Schema.RecordTypeInfo> CRMapByName = CR.getRecordTypeInfosByName();
       
       // RecordType WRFRecType       = [select id from recordtype where name = 'Work Request' AND SobjectType = 'Case'];
        
         Schema.DescribeSObjectResult AR = Schema.SObjectType.account; 
         Map<String,Schema.RecordTypeInfo> ARMapByName = AR.getRecordTypeInfosByName();
         
       
        System.runAs(u1)
        {
        
           Test.StartTest(); 
           List<Sobject> InsrtAccList = new List<Sobject>();
           Account acc = new Account ();
           acc.name = 'Ank Test Account';
           acc.BillingStreet = '1040 N 326 W';
           acc.billingcity = 'Orem';
           acc.BillingState = 'UT';
           acc.Billingcountry = 'USA';
           acc.Buying_Group__c = 'Buying Groups Federal';
           acc.Sector__c = 'Public';
           acc.Segment__c = 'Federal';
           acc.recordtypeid= ARMapByName.get('Customer').getRecordTypeId();
           acc.type = 'Customer';        
           acc.Implementation_Manager__c= u1.id;
           //acc.Oracle_Party_Id__c = 'testdata';
           acc.AOPS_Cust_Id__c = '123456';
           acc.AOPS_Seq_ID__c = '123456';
           InsrtAccList.add(acc);
           //insert acc;
           
           
           aid = acc.id;
           Account acc1 = new Account ();
           acc1.name = 'Ank Test Account2';
           acc1.BillingStreet = '1040 N 326 W';
           acc1.billingcity = 'Orem';
           acc1.BillingState = 'UT';
           acc1.Billingcountry = 'USA';
           acc1.Buying_Group__c = 'Buying Groups Federal';
           acc1.Sector__c = 'Public';
           acc1.Segment__c = 'Federal';
           acc1.Oracle_Party_Id__c = 'testdata1';
           //acc1.AOPS_Cust_Id__c = '123456';
           //acc1.AOPS_Seq_ID__c = '123456';
           //insert acc1;
           InsrtAccList.add(acc1);

           
            Account acc2=new Account();
             acc2.name='abcde';
             acc2.recordtypeid= ARMapByName.get('Prospect').getRecordTypeId();
             acc2.type = 'Prospect';
             //acc2.AOPS_Cust_Id__c ='12345';
             acc2.Oracle_Party_Id__c ='987654';
             //insert acc2;
             InsrtAccList.add(acc2);
             
             Account acc3=new Account();
             acc3.name='abcd';
             acc3.recordtypeid= ARMapByName.get('Customer').getRecordTypeId();
             acc3.type = 'Customer';
             acc3.AOPS_Cust_Id__c ='78905';
             //acc1.Implementation_Manager__c= u1.id;
             acc1.Oracle_Party_Id__c ='987656';
             //insert acc3;
             InsrtAccList.add(acc3);
            
            insert InsrtAccList;
            
           Case ca1 = new case ();
           ca1.Description = 'Case Test';
           ca1.Subject = 'Case Test';
           ca1.recordTypeId = CRMapByName.get('Account Maintenance').getRecordTypeId();
           ca1.DUP_Acct_Type__c = 'Current Customer';
           ca1.DUP_Acct_ID__c = '123456';
           ca1.IT_Track__c = 'Production Fix';
           insert ca1;      
            
           Case ca2 = new case ();
           ca2.Description = 'Case Test1';
           ca2.Subject = 'Case Test1';
           ca2.RecordTypeId =CRMapByName.get('Work Request').getRecordTypeId();
           ca2.DUP_Acct_Type__c = 'New Prospect';
           ca2.DUP_Acct_ID__c = 'testdata1';
           ca2.IT_Track__c = 'Production Fix';
           insert ca2;
           Caseid_Accid_lst.add(ca1);
           Caseid_Accid_lst.add(ca2);
           //insert Caseid_Accid_lst;
           
           String strQuery = '';
           
           
           //Executing Address Change
           strQuery = 'Select RecordTypeId, LastModifiedDate, Id, DUP_Requestor_Name__c, DUP_Requestor_ID__c, DUP_Acct_Type__c, DUP_Acct_Name__c, DUP_Acct_ID__c, ContactId, AccountId, ParentId, Related_Case_Number__c, WRF_Requestor__c  From Case where id = \''+ca2.id+'\'OR id =\''+ca1.id+'\'';
           Case_AccountDetails_update_Batch Case_update_Batch = new Case_AccountDetails_update_Batch(strQuery);
           Database.executeBatch(Case_update_Batch,200);
           
           Datetime dt = System.today();
           String scheduleString='0';//0 seconds
           scheduleString+=' '+ dt.minute();
           scheduleString+=' '+ dt.hour();
           scheduleString+=' '+ dt.day();
           scheduleString+=' '+ dt.month();
           scheduleString+=' ?';
           scheduleString+=' '+ dt.year();     
           System.debug('currently scheduled. time for education eduMasterGroup  ' + scheduleString); 
           String CRON_EXP = '0 0 0 3 9 ? 2022';                                  
           String mappingQuery = '';
           Case_AccountDetails_update_Batch assignBatch = new Case_AccountDetails_update_Batch(mappingQuery);
           System.schedule('Case AccountDetails update Batch',CRON_EXP , assignBatch);
           
           Caseid_Accid_map = Update_detailsonCase.Cust_prosp_Updateoncase(Caseid_Accid_lst);
            
           Test.StopTest();
           
          /*********************
          String jobId = System.schedule('testBasicScheduledApex',
          TestScheduledApexFromTestMethod.CRON_EXP, 
             new TestScheduledApexFromTestMethod());
           ***************************/       
        }
        }catch(Exception e){}
       
    }
}