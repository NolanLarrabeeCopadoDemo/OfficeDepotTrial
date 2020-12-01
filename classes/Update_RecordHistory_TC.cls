@isTest
private class Update_RecordHistory_TC
{	
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
		
        static testMethod void myUnitTest()     
        {        	
            Map<String,Schema.RecordTypeInfo> CaseRecType = Schema.SObjectType.Case.getRecordTypeInfosByName(); 
            
            Account acc = [select id from Account where name='Ank Test account1' limit 1];		//Case#00175758-------Hitesh [Aug 11, 2016]
            Case WRFCase = new Case();
            WRFCase.RecordTypeId =CaseRecType.get('Work Request').getRecordTypeId();
            WRFCase.Status='New';
            WRFCase.WRF_Submission_Issue__c='Complete and Accurate';
            WRFCase.WRF_Request_Type__c='Automatic Toner Replenishment (ATR)';
            WRFCase.accountId = acc.id;		//Case#00175758-------Hitesh [Aug 11, 2016]
            insert WRFCase;
            
            Case AccCase = new Case();
            AccCase.RecordTypeId =CaseRecType.get('Account Maintenance').getRecordTypeId();
            AccCase.Status='New';
            AccCase.WRF_Submission_Issue__c='Complete and Accurate';
            AccCase.WRF_Request_Type__c='Automatic Toner Replenishment (ATR)';
            insert AccCase;
             
            Record_History__c Rech = new Record_History__c();
            rech.Start_Date__c=datetime.now();
            rech.No_of_Hours__c=6;
            rech.Case__c = WRFCase.id;
            insert Rech;
             
            Record_History__c Rech1 = new Record_History__c();
            rech1.Start_Date__c=datetime.now();
            rech1.No_of_Hours__c=6;
            rech1.Case__c = AccCase.id;
            insert Rech1;
             
             
            string CRON_EXP= '0 0 0 3 9 ? 2022';   
            businesshours bh = new businesshours();
            System.debug('QUERY---'+[Select id,Start_Date__c,End_Date__c,No_of_Hours__c,Case__r.Recordtypeid from Record_History__c where Start_Date__c!=null and End_Date__c=null]);
            String s='Select id,Start_Date__c,End_Date__c,No_of_Hours__c,Case__r.Recordtypeid from Record_History__c where Start_Date__c!=null and End_Date__c=null';
            Test.startTest();
            Update_RecordHistory assignBatch = new Update_RecordHistory();
            assignBatch.strQuery =s;
            database.executebatch(assignBatch, 100); 
            System.schedule('AssignmentBatch1',CRON_EXP , assignBatch);
            Update_RecordHistory assignBatch1 = new Update_RecordHistory(s);
            System.schedule('Assignment Batch',CRON_EXP , assignBatch1);
            database.executebatch(assignBatch, 100); 
             Test.stopTest();
        }
}