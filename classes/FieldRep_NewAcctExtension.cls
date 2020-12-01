/*************************************************************
*Name           : FieldRep_NewAcctExtension
*Created By     : Virendra (Appirio Off)
*Created Date   : 15 Nov 2011
*Purpose        : To show top 20 Accounts of Current User for YTD Sales TY
****************************************************************/
public with sharing class FieldRep_NewAcctExtension {
    
   public List<Account> topAccounts {get;set;}
    
   public FieldRep_NewAcctExtension() {
      topAccounts = searchTopAccounts();
   }        
   
   private List<Account> searchTopAccounts(){
      List<Account> accounts = [Select Id,YTD_Sales_TY__c, recordtype.name, Weeks_Since_Last_Order__c,Stage__c, Num_of_Orders_Since_Start__c, Name From Account
                                where  OwnerId =: UserInfo.getUserId() and Stage__c = 'LOY' and YTD_Sales_TY__c <> null and recordtype.name= 'Customer' order by YTD_Sales_TY__c desc limit 35 ];
      return accounts;                          
   }
   
    //========================================================//
    //To test FieldRep_NewAcctExtension class
    //========================================================//
    @isTest 
   private static void testFieldRep_NewAcctExtension() {
     User testUser = Test_Utils.createTestUser('Tst','112233');
     insert testUser;
    
     System.RunAs(testUser){          
       // Create test account with record type equals to customer
       Account account = Test_Utils.CreateAccount('Customer');
       account.Stage__c = 'LOY';
       account.YTD_Sales_TY__c = 100;
       insert account;
       
       // Create test account with record type equals to customer
       Account account1 = Test_Utils.CreateAccount('Customer');
       account1.Stage__c = 'LOY';
       account1.YTD_Sales_TY__c =10.00;
       insert account1;
                  
          Test.startTest();
        FieldRep_NewAcctExtension extension = new FieldRep_NewAcctExtension(); 
       List<Account> topAccountList = extension.topAccounts;
              
       //Test that two accounts added of customer record type
       System.assertEquals(topAccountList.size(), 2); 
       
       //Test that returning result is ordered by YTD_Sales_TY__c
       if(topAccountList.size() > 0) {            
         system.assertEquals(topAccountList[0].YTD_Sales_TY__c, 100);
       } 
       Test.stopTest();
     }
   }
   
}