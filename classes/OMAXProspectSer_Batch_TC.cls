/*****************************************************************
/* Name : OMAXProspectSer_Batch_TC
/* Modified By :VIPUL JAIN
/* Modified Date :15 OCT 2015
/* Story :357928
/******************************************************************/
@isTest(seeAllData = false)
private class OMAXProspectSer_Batch_TC
{
	public static String CRON_EXP = '0 0 23 * * ?';

    static testmethod void method() {

    	List<Account> accList =new List<Account>();
		Account acc,acc1 = new Account();
		acc = Test_Utils.CreateAccount('Customer (OfficeMax)');
		acc.OMXIsUpdated__c = true;
		acc.Split_Record__c =false;
		acc.omx_primary_key__C = 'OMX003';
		accList.add(acc);
		/*acc1 = Test_Utils.CreateAccount('Site (OfficeMax)');
		acc1.OMXIsUpdated__c = true;
		acc1.Split_Record__c =false;
		acc1.omx_primary_key__C = 'OMX004';
		accList.add(acc1);*/

		if (accList.size()>0){
			insert accList;
		}

        Test.startTest() ;

		String jobId = System.schedule('OMAXProspectSer_Batch',
		                        CRON_EXP,
		                        new OMAXProspectSer_Batch());
		Test.stopTest() ;
    }
    static testmethod void method1() {

    	List<Account> accList =new List<Account>();
		Account acc,acc1 = new Account();
		acc = Test_Utils.CreateAccount('Customer (OfficeMax)');
		acc.OMXIsUpdated__c = true;
		acc.Split_Record__c =false;
		acc.omx_primary_key__C = 'OMX003';
		accList.add(acc);
		/*acc1 = Test_Utils.CreateAccount('Site (OfficeMax)');
		acc1.OMXIsUpdated__c = true;
		acc1.Split_Record__c =false;
		acc1.omx_primary_key__C = 'OMX004';
		accList.add(acc1);*/

		if (accList.size()>0){
			insert accList;
		}

        OMAXProspectSer_Batch omxBatch = new OMAXProspectSer_Batch();
        Test.startTest() ;

        database.executebatch(omxBatch, 10);
        Test.stopTest() ;
        Prospect_Message__c prosmsg = [SELECT ID, Account__c FROM Prospect_Message__c WHERE Account__c =:accList.get(0).id ];
		system.assertEquals(prosmsg.Account__c, accList.get(0).id);

    }
}