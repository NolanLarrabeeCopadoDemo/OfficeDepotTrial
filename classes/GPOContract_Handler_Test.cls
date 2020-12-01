/**@@
    #CLASS NAME  :  GPOContract_Handler_Test
    #DESCRIPTION :  Test class for "GPOContract_Handler" 
    #CREATEDDATE :  13-09-2019 (DD-MM-YYYY) 
@@**/
@isTest
public class GPOContract_Handler_Test {
	    
    @isTest
    public static void updateContract(){        	
		List<recordtype> prospectID = [Select id from recordtype where name='Prospect'];
        List<recordtype> custID = [Select id from recordtype where name='Customer'];               
        List<Account> accountList = DataFactory.createAccountTestRecords('Test acc', 5, '');
        Id GPRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('GrandParent').getRecordTypeId();
        accountList[0].name = 'Grand Parent';
        accountList[0].RecordTypeId = GPRecordTypeId;
        
        accountList[1].name = 'parent';
        accountList[1].RecordTypeId = custID[0].id;
        accountList[1].parentid = accountList[0].id;
        
        accountList[2].parentid = accountList[1].id;
        accountList[2].RecordTypeId = custID[0].id;
        
        accountList[3].parentid = accountList[2].id;
        accountList[3].RecordTypeId = prospectID[0].id;
        
        
        accountList[4].parentid = accountList[2].id;
        accountList[4].RecordTypeId = custID[0].id;
        
        update accountList;
        
        if(accountList != null && accountList.size() > 0){
            List<Contract> contractList =  DataFactory.createContractTestRecords('Test contract', accountList[4].id, 5);
                        
            contractList[0].name= '';
            contractList[0].Contract_Status__c = 'Draft'; 
            contractList[0].accountId = accountList[2].id;
            
            contractList[1].name= '';
            contractList[1].Contract_Status__c = 'Draft'; 
            contractList[1].accountId = accountList[3].id;
            
            contractList[2].name= '';
            contractList[2].Contract_Status__c = 'Draft'; 
            contractList[2].accountId = accountList[3].id;
            
            update contractList;
        } 
        List<Account> resultAccountList = [Select id From Account WHERE  Current_GPO__c=true Limit 10];
        System.assertEquals(true, resultAccountList.size()>0 ); 
    }
}