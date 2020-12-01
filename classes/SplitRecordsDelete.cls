// Class to create Split Details 
public class SplitRecordsDelete {
    private List<Customer_Transition__c> mod5List;
        
    public void deletesplitDetails(List<Customer_Transition__c> mod5List) {   
     List<Split_Account_Detail__c> splitAccounts = new List<Split_Account_Detail__c>(); 
     splitAccounts =[Select Id from Split_Account_Detail__c WHERE Customer_Transition__c =:mod5List ];    
                                                                       
        if(splitAccounts.size()>0)
        delete splitAccounts;
    }

}