@isTest
private class Update_WRFAging_Batch_TC {
    
    //Case#00175758----START----Hitesh [Aug 11, 2016]
        @testSetup static void setUpData(){         
            Account acc1 = new Account();
              acc1.name = 'Ank Test account1';
              acc1.BillingStreet = '1040 N 326 W';
              acc1.billingcity = 'Orem';
              acc1.BillingState = 'UT';
              acc1.Billingcountry = 'USA';
              acc1.Buying_Group__c = 'Buying Groups Federal';
              acc1.Sector__c = 'Public';
              acc1.Segment__c = 'Federal';
              acc1.Oracle_Party_Id__c = 'testdata';
              acc1.AOPS_Cust_Id__c = '123456';
              acc1.AOPS_Seq_ID__c = '123456';
              insert acc1; 
        }
    //Case#00175758----END----Hitesh [Aug 11, 2016]

    static testMethod void Update_WRFAging_Batch_TC() 
    {
           System.runAs(new user(ID = UserInfo.getUserID())){
           
        Profile p4 = [SELECT Id FROM profile WHERE name='System Administrator'];   
        User u1 = new User(alias = 'test123 ', email='proxy@proxy456.officedepot.com',OD_Employee_ID__c='133446',emailencodingkey='UTF-8', lastname='test123',languagelocalekey='en_US',localesidkey='en_US', profileid = p4.Id,timezonesidkey='America/Los_Angeles',username='proxy@proxy456.com');
        insert u1; 
        Account acc = [select id from Account where name='Ank Test account1' limit 1];      //Case#00175758-------Hitesh [Aug 11, 2016]
        
        Schema.DescribeSObjectResult d1 = Schema.SObjectType.Case; 
        Map<String,Schema.RecordTypeInfo> rtMapByName = d1.getRecordTypeInfosByName(); 
        
        BusinessHours Bhours=new BusinessHours();  
        Bhours.IsDefault=true;
        
        List<Case> InsrtCseList = new List<Case>();
        
        Case ca1 = new case ();
        ca1.Description = 'Case Test';
        ca1.Subject = 'Case Test';
        ca1.Status='Open';
        ca1.RecordTypeId = rtMapByName.get('Work Request').getRecordTypeId();       
        ca1.Hours_Awtng_Info_Current__c=13;
        ca1.WRF_Hours_Compliance__c=15;
        ca1.WRF_Hours_DSM__c=16;
        ca1.WRF_Hours_Strtgy_Dir__c=17;
        ca1.WRF_Hours_RSD__c=18;
        ca1.WRF_Hours_Finance__c=19;
        ca1.WRF_Hours_Sr_Strtgy_Dir__c=20;
        ca1.WRF_Hours_RVP__c=21;
        ca1.WRF_Hours_VP_Sales_Ops__c=22;
        ca1.WRF_Hours_Dir_Finance__c=23;
        ca1.WRF_Hours_VP_Field_Sales__c=34;
        ca1.WRF_Hours_SVP__c=35;
        ca1.WRF_Date_Time_Awaiting_Info__c=System.today();  
        ca1.Approval_Start_Time__C=System.today();
        ca1.WRF_Date_CPM_Launched__C=System.today();
        ca1.Approval_Status__c='Pending Approval';
        ca1.Current_Approver__C='Public Sector VP';
        ca1.current_Approval_Start__C=System.today();
        ca1.accountId = acc.id;             //Case#00175758-------Hitesh [Aug 11, 2016]
        insert ca1;
        
        }
        //InsrtCseList.add(ca1);
               
        //insert InsrtCseList;
        
        
        Update_WRFAging_Batch reassign1=new Update_WRFAging_Batch();
        Database.executebatch(reassign1);
        
        //Update_WRFAging_Batch reassign=new Update_WRFAging_Batch();
        String DEFAULT_QUERY = 'Select id,Approval_Start_time__c,Status, Auto_Close_Date__c,Total_Hours_Approval__c,Approval_Status__c,Hours_Pending_Approval__c,Recordtypeid,' + 
                                   'CreatedDate,' +
                                   'WRF_Date_CPM_Launched__c,'+
                                   'Current_Approver__c, Current_Approval_Start__c' +                                                                                                        
                                   ' FROM Case ' +
                                   'Where RecordType.Name =\'Work Request\''+
                                   ' and Status NOT IN (\'Cancelled\', \'Closed\') ' +
                                   'Order By LastModifiedDate asc';                                                                       
        
        Update_WRFAging_Batch reassign2=new Update_WRFAging_Batch(DEFAULT_QUERY);
        Database.executebatch(reassign2);

        String CRON_EXP = '0 0 0 3 9 ? 2022'; 
         System.schedule('Test Update_WRFAging_Batch',CRON_EXP , reassign1);
        
    }
}