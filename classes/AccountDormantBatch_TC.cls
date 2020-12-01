@isTest
private class AccountDormantBatch_TC {

	private static testMethod void test() {
	   Account newacct = new Account (name='testacct',address1__c='6600 n militarty trl',city__c='boca raton',state__c='FL',zip__c='33496');
	   insert newacct;
	   
	   
	   Note n = new note(Parentid=newacct.id,Title='test',Body='test');
	   attachment ac = new attachment(Parentid=newacct.id,name='test',body=blob.valueof('test'));
	   insert n;
	   insert ac;
	   
       Account_Dedup_Staging__c DS = NEW Account_Dedup_Staging__c();

       DS.sfdc_id__c=newacct.id;
       DS.Dormant_Change__c='I';
       
       insert DS;
       
        test.startTest();
        
 		
 		string DEFAULT_QUERY='select Sfdc_Id__c from Account_Dedup_Staging__c  where Dormant_Change__c=\'I\'';
 		
 		AccountDormantBatch dbatch2 = new  AccountDormantBatch(DEFAULT_QUERY);      
 		database.executeBatch(dbatch2);
 		
 		//Check scheduled execution
 		
 		AccountDormantBatch sh1 = new  AccountDormantBatch('');      
        String sch = '0 0 23 * * ?';
        system.schedule('Test check', sch, sh1);
 		
       test.stopTest();
	   
	}

}