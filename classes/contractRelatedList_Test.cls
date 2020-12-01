/**@@
    #CLASS NAME  :  contractRelatedList_Test
    #DESCRIPTION :  Test class for "contractRelatedList" 
    #CREATEDDATE :  10-09-2019 (DD-MM-YYYY) 
@@**/

@isTest
private class contractRelatedList_Test
{
      
      @TestSetup public static void setup(){
        List<recordtype> prospectID = [Select id from recordtype where name='Prospect'];
        List<recordtype> custID = [Select id from recordtype where name='Customer'];
        //List<Account> accountUpdateList =  new List<Account>();
        List<Account> accountList = DataFactory.createAccountTestRecords('Test acc', 5, '');
        
        
        accountList[0].name = 'Grand Parent';
        accountList[0].RecordTypeId = custID[0].id;
        
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
        
        ///List<Account> childAccountList = DataFactory.createAccountTestRecords('Test acc', 1, accountList[0].id);
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
      }
      
      static testMethod  void contractRelatedList_Test (){
               List<Account> accountList = [Select id From Account  ORDER BY id Limit 10];
               List<Contract> contractList = [Select id From Contract ORDER BY id Limit 10];
               String s;
               
               Test.StartTest();
                   ApexPages.currentPage().getParameters().Put('id',accountList[2].id);
                   ApexPages.StandardController con = new ApexPages.StandardController(accountList[2]);
                   contractRelatedList controller = new contractRelatedList(con);
                   contractRelatedList.WrapperClass wrap = new contractRelatedList.WrapperClass(s,contractList[0],accountList[2]);                 
                   ApexPages.currentPage().getParameters().Put('selectedRecord',contractList[0].id);                  
                   List<contractRelatedList.wrapperclass> lst1 = controller.getwrapperlist();
                   controller.setwrapperlist();
                Test.StopTest(); 
                 System.debug('Conlistdisplay=>'+controller.Conlistdisplay);
                 
                 System.debug('lst1=>'+lst1);
                System.assertEquals(true, controller.Conlistdisplay != null );
                System.assertEquals(true, lst1.size()>0 );  
               
        }
        
        static testMethod  void contractRelatedList_Test2 (){
               List<Account> accountList = [Select id From Account  ORDER BY id Limit 10];
               List<Contract> contractList = [Select id From Contract ORDER BY id Limit 10];
               String s;
               
               Test.StartTest();
                   ApexPages.currentPage().getParameters().Put('id',accountList[3].id);
                   ApexPages.StandardController con = new ApexPages.StandardController(accountList[3]);
                   contractRelatedList controller = new contractRelatedList(con);
                   contractRelatedList.WrapperClass wrap = new contractRelatedList.WrapperClass(s,contractList[1],accountList[3]);                   
                   ApexPages.currentPage().getParameters().Put('selectedRecord',contractList[1].id);
                   pagereference pg = controller.deleteContractItem();
                Test.StopTest(); 
            System.assertEquals(true, pg != null);  
               
        }

        static testMethod  void contractRelatedList_Test3 (){
               List<Account> accountList = [Select id From Account  ORDER BY id Limit 10];
               List<Contract> contractList = [Select id From Contract ORDER BY id Limit 10];
               String s;
               
               Test.StartTest();
                   ApexPages.currentPage().getParameters().Put('id',accountList[4].id);
                   ApexPages.StandardController con = new ApexPages.StandardController(accountList[4]);
                   contractRelatedList controller = new contractRelatedList(con);
                   contractRelatedList.WrapperClass wrap = new contractRelatedList.WrapperClass(s,contractList[2],accountList[3]);                   
                   ApexPages.currentPage().getParameters().Put('selectedRecord',contractList[2].id);
                   pagereference pg = controller.deleteContractItem();
                Test.StopTest(); 
            System.assertEquals(true, pg != null);  
               
        }
 
}