public class AccountDiagnostics{
	/**
	
	*/


	@AuraEnabled
	public static Map<String, Object> GetAccountInformation(String accountId){
		System.debug(LoggingLevel.INFO, 'Account Id is: ' + accountId);

		Account myAccount;
		Account_Message__c my_account_message;
		Account_Setup_Request__c my_account_setup_request;
		Account_Service_Data__c my_account_service_data;

		try{
			myAccount = [SELECT Id, Name, RecordTypeId, Address1__c, Address2__c, City__c, State__c, Zip__c FROM Account WHERE Id=:accountId];
		} catch(DmlException e){
			System.debug(LoggingLevel.ERROR, 'Account SOQL Failed: ' + e);
			return null;
		}
		

		Map<String, Object> myMap = new Map<String, Object>();
		myMap.put('myAccount', myAccount);
		myMap.put('AccountMessage', getAccountMessage(myAccount.Id));
		myMap.put('AccountSetupRequest', getAccountSetupRequest(myAccount.Id));
		myMap.put('AccountServiceData', getAccountServiceData(myAccount.Id));

		return myMap;
	}

	@TestVisible
	private static Account_Message__c getAccountMessage(String accountId){
		List<Account_Message__c> myAccountMessage = new List<Account_Message__c>();
		try{
			myAccountMessage.addAll([SELECT Id, ACCT_ID_SFDC_ACCOUNT_ID__c, CreatedDate, LastModifiedBy.Name FROM Account_Message__c WHERE ACCT_ID_SFDC_ACCOUNT_ID__c=:accountId LIMIT 1]);
		} catch(DmlException e){
			System.debug(LoggingLevel.ERROR, 'Account_Message__c SOQL Failed: ' + e);
		}

		if(myAccountMessage.size() != 0){
			return myAccountMessage[0];
		}
		return null;
	}

	@TestVisible
	private static Account_Setup_Request__c getAccountSetupRequest(String accountId){
		List<Account_Setup_Request__c> my_account_setup_request = new List<Account_Setup_Request__c>();
		
		try{
			my_account_setup_request.addAll([SELECT Id, Account__c, CreatedDate, Status__c, LastModifiedBy.Name FROM Account_Setup_Request__c WHERE Account__c=:accountId LIMIT 1]);
		} catch(DmlException e){
			System.debug(LoggingLevel.ERROR, 'Account_Setup_Request__c SOQL Failed: ' + e);
		}

		if(my_account_setup_request.size() != 0){
			return my_account_setup_request[0];
		}
		return null;
	}

	@TestVisible
	private static Account_Service_Data__c getAccountServiceData(String accountId){
		List<Account_Service_Data__c> my_account_service_data = new List<Account_Service_Data__c>();
		
		try{
			my_account_service_data.addAll([SELECT Id, ACCOUNT_NAME__c, Batch_Processed__c, Status__c, CreatedDate, AOPS_CUSTOMER_ID__c, SFDC_CUSTOMER_ID__c FROM Account_Service_Data__c WHERE SFDC_CUSTOMER_ID__c=:accountId LIMIT 1]);
		} catch(DmlException e){
			System.debug(LoggingLevel.ERROR, 'Account_Service_Data__c SOQL Failed: ' + e);
		}

		if(my_account_service_data.size() != 0){
			return my_account_service_data[0];
		}
		return null;
	}

}