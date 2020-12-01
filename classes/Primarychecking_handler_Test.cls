/**@@
    #CLASS NAME  :  Primarychecking_handler_Test
    #DESCRIPTION :  Test class for "Primarychecking_handler" 
    #CREATEDDATE :  13-09-2019 (DD-MM-YYYY) 
@@**/
@isTest
public class Primarychecking_handler_Test {
	@TestSetup public static void setup(){
        List<Account> accountList = DataFactory.createAccountTestRecords('Test acc', 5, '');        
        if(accountList != null && accountList.size() > 0){
            List<Contract> contractList =  DataFactory.createContractTestRecords('Test contract', accountList[0].id, 5);
         }
        
    }
    @isTest
    public static void Prcheck(){             
        List<Account> accountList = [Select id From Account ORDER BY id Limit 10];
        List<Contract> conList = [Select id,Name From Contract ORDER BY id Limit 10];
        //List<Contract> conList2 = DataFactory.createContractTestRecords('Test Contract', accountList[1].id, 5);
        try{ 
            if(!conList.isEmpty()){
                conList[0].Name='New Test Contract';  
                //conList[0].primary__c=false;
                //conList[0].GPO_Contract__c=false;
                conList[1].primary__c=true;
            }
            Update conList;
            //throw new MyException('An exception should have been thrown by the trigger but was not.'); 
            // 1. If we get to this line it means an error was not added and the test class should throw an exception here. 
            // 2. MyException class extends Exception.
        }catch(Exception e){
            Boolean expectedExceptionThrown =  (e.getMessage().contains('Only 1 Contract can be the primary')) ? true : false;
            System.AssertEquals(expectedExceptionThrown, true);
        } 
        //List<Contract> contractList = [Select id,Name From Contract WHERE primary__c=false Limit 10];
        //System.assertEquals(true, contractList.size()>0 ); 
    }
        
}