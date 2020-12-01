@isTest(SeeAllData=true)
private class Test_Upd_Status_Age{
  static testMethod void Test_Info(){
      Date d = Date.today();
  Account a = new Account(Name='Test_27');
    insert a;
  Customer_Transition__c cT = new Customer_Transition__c(name='CT_Test_27', Account__c = a.id);
    insert cT;
      ct.Review_Start_Date__c = d.addDays(67);
    update cT;
      ct.Review_Start_Date__c = d.addDays(10);
    update cT;
    /*
      cT.Agreement_Development__c = True;
    update cT;
      cT.Manual_Build_Underway__c = True;
    update cT;      
      cT.Non_WA_in_Assessment__c = True;
    update cT;
      cT.Ready_for_Mod1__c = True;
    update cT;
      cT.Ready_for_account_finalizing_final_mod__c = True;
    update cT;
      cT.Ready_for_audit_1__c = True;
    update cT;
      cT.Ready_for_audit_2__c = True;
    update cT;
      cT.Ready_to_order__c = True;
    update cT;
      cT.Customer_Transition_Date_to_OD_Systems__c = d.addDays(999);
    update cT;
      cT.Administrative_Close__c = True;
    update cT;
     */
 // delete cT;
   }
}