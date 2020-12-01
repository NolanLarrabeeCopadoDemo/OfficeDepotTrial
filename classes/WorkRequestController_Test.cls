@IsTest
public class WorkRequestController_Test {
    @TestSetup public static void setup(){
        List<recordtype> prospectID = [Select id from recordtype where name='Prospect'];
        List<recordtype> custID = [Select id from recordtype where name='Customer'];
        //List<Account> accountUpdateList =  new List<Account>();
        List<Account> AccountRecord = DataFactory.createAccountTestRecords('Test acc', 1, '');
        AccountRecord[0].name = 'Grand Parent';
        AccountRecord[0].RecordTypeId = custID[0].id;
        update AccountRecord;
        
        Opportunity OppRecord = new Opportunity();
        OppRecord.Name = 'Test opp';
        OppRecord.AccountId = AccountRecord[0].id;
        OppRecord.StageName = 'Open';
        OppRecord.CloseDate = date.today().adddays(5);
        insert OppRecord;
        
        
        
    }
    
    static testMethod void TestgetData(){
        
        List<Account> accountList = [Select id From Account  ORDER BY id Limit 10];
        List<Contract> contractList = [Select id From Contract ORDER BY id Limit 10];
        WorkRequestController.getData(accountList[0].id);
    }
    
    static testMethod void TestgetData2(){
        
        List<Opportunity> OppList = [Select id From Opportunity  ORDER BY id Limit 10];
        WorkRequestController.getData(OppList[0].id);
    }
}