/**@@
#CLASS NAME  :  AccountHelper
#DESCRIPTION :  This class will contains all the related methods regrading the opration in Account object
#MODIFIEDDDATE :  27-07-2020 (DD-MM-YYYY) 
#Auther: Sandesh Ganjare
@@**/
public class AccountHelper{
 
    /* @method: populate_GPO_Flag
    *  @param: newAccountList=> new list of updated accounts,
    *  @author: Sandesh Ganjare 
    *  @JIRA/Case: NAIT-131763 / Case # 02900372
    *  @description: To Update the Current_GOP__c Inherit GPO Flag through the Account Hierarchy.
    *  @date: 22-July-2020
    */
	public static void populate_GPO_Flag(List<Account> newAccountList) {
 		Set<String> accountIdsSetToSkip = new Set<String>();
		List<String> exceptionsArray = new List<String>();
		List<Account> accountUpdatedList = new List<Account>();
        
        //Exception Set of records
        Manage_Flag_Exceptions__mdt exceptions = [SELECT Id,Record_18_Digit_Id__c FROM Manage_Flag_Exceptions__mdt WHERE MasterLabel='Current_GPO__c' LIMIT 1];       
        if(exceptions!= null && exceptions.Record_18_Digit_Id__c!= null ){
            if(exceptions.Record_18_Digit_Id__c.contains(',')){
                exceptionsArray = exceptions.Record_18_Digit_Id__c.split(',');
            }else{
                exceptionsArray.add(exceptions.Record_18_Digit_Id__c);
            }
            
        }
        Set<String> exceptionsSet = new Set<String>(exceptionsArray);
        accountIdsSetToSkip.addAll(exceptionsSet);
        System.debug('accountIdsSetToSkip=>'+accountIdsSetToSkip);
        
		if(!newAccountList.isEmpty()){
			for (Account newAccount : newAccountList){
				if (accountIdsSetToSkip.isEmpty() || (!accountIdsSetToSkip.contains(newAccount.id))){
					if(newAccount.Current_GPO__c != newAccount.Parent.Current_GPO__c){
						newAccount.Current_GPO__c = newAccount.Parent.Current_GPO__c;						
						accountUpdatedList.add(newAccount);						
					}					
				}
			}
		}
		System.debug('accountUpdatedList GP=>'+accountUpdatedList);            
		UPDATE accountUpdatedList;
        
    }
}