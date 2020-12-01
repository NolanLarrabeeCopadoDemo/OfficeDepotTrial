@isTest
public class AccountDiagnostics_Test{
	/**
	
	*/


	@isTest(SeeAllData=true)
	public static void testGetAccountInformation(){

		Account foo = [SELECT Id, Name, RecordTypeId FROM Account WHERE RecordType.developername='customer' LIMIT 1];
		Test.startTest();
		AccountDiagnostics.getAccountInformation(foo.Id);
		Test.stopTest();
	}

	@isTest(SeeAllData=true)
	public static void testgetAccountMessage(){
		Account foo = [SELECT Id, Name, RecordTypeId FROM Account WHERE RecordType.developername='customer' LIMIT 1];
		Test.startTest();
		AccountDiagnostics.getAccountMessage(foo.Id);
		Test.stopTest();
	}

	@isTest(SeeAllData=true)
	public static void testgetAccountSetupRequest(){
		Account foo = [SELECT Id, Name, RecordTypeId FROM Account WHERE RecordType.developername='customer' LIMIT 1];
		Test.startTest();
		AccountDiagnostics.getAccountSetupRequest(foo.Id);
		Test.stopTest();
	}

	@isTest(SeeAllData=true)
	public static void testgetAccountServiceData(){
		Account foo = [SELECT Id, Name, RecordTypeId FROM Account WHERE RecordType.developername='customer' LIMIT 1];
		Test.startTest();
		AccountDiagnostics.getAccountServiceData(foo.Name);
		Test.stopTest();
	}
}