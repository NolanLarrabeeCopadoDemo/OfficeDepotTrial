/**@@
    #CLASS NAME  :  CSFController_Test 
    #DESCRIPTION :  Test class for "CSFController" 
    #CREATEDDATE :  04-27-2020 (DD-MM-YYYY) 
@@**/

@IsTest
public class CSFController_Test {

    static testMethod void getselectOptions_Method(){
        Contract con = new Contract();
        CSFController.getselectOptions(con,'Customer_fees__c');
    }
}