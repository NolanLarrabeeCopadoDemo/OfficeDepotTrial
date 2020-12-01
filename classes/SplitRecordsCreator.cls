// Class to create Split Details 
public class SplitRecordsCreator {

    public void createSplitDetails(List<Id> mod5List) {
        system.debug('creating split details');
        set<string> Dtlomxkey = new set<string>();
        List<Split_Account_Detail__c> splitAccounts = new List<Split_Account_Detail__c>();
        List<customer_transition_dtls__c> transDetailsUpdate= new List<customer_transition_dtls__c> ();
        
        System.debug('SplitRecordsCreator > createSplitDetails() > mod5List = ' + mod5List);
        List<customer_transition_dtls__c> transDetails = [SELECT Id, OMX_Primary_Key__c, Account_ID__c, Customer_Transition_ID__c, Customer_Transition_ID__r.Account__C,
                                                          Bill_To_Account__c, AP_CONTACT_FIRST_NAME__c, AP_CONTACT_LAST_NAME__c, AP_CONTACT_TELEPHONE__c, Credit_Limit__c,
                                                          Payment_Term_Description__c, Print_Daily_Invoice__c, Summary_Bill_Cycle__c, Credit_Card_AR__c, Summary_Bill__c,
                                                          EC_Bill_Cycle__c
                                                          FROM Customer_Transition_Dtls__c
                                                          WHERE Customer_Transition_ID__c IN :mod5List 
                                                          AND RecordType.name='Sites'
                                                          AND Aops_Flag__C='Y'];
                                                          
                                                          
                                                            system.debug('&&&&transDetails'+transDetails);  
    //Inserting into split details table
    Integer count=1;
        for (customer_transition_dtls__c detail : transDetails) { 
            if(!Dtlomxkey.contains(detail.OMX_Primary_Key__c)){
            
            // To Identify the split driven Consignees
            
               customer_transition_dtls__c cust= new customer_transition_dtls__c(Id=detail.Id,Split_Driven__c=true);
               detail.Split_Driven__c=true;
               transDetailsUpdate.add(cust);
               string CountSplit=string.valueof(count);
                      if(count<10)
                      CountSplit='0'+CountSplit;                  

                Split_Account_Detail__c sad = new Split_Account_Detail__c(Name = 'Split Acct Details Name',
                                                 Original_Account__c = detail.Customer_Transition_ID__r.Account__C,
                                                 Customer_Transition__c=detail.Customer_Transition_ID__c,
                                                 Ship_To_Account__c=detail.Account_ID__c,
                                                 Billing_Account__c=detail.Bill_To_Account__c,
                                                 BILL_TO_AP_CONTACT_FIRST_NAME_c__c=detail.AP_CONTACT_FIRST_NAME__c,
                                                 BILL_TO_AP_CONTACT_LAST_NAME__c=detail.AP_CONTACT_LAST_NAME__c,
                                                 count__C=CountSplit,                                                 
                                                 BILL_TO_AP_CONTACT_TELEPHONE__c=detail.AP_CONTACT_TELEPHONE__c,
                                                 Customer_Transition_Detail_Id__c=detail .Id,
                                                 Credit_Limit__c = detail.Credit_Limit__c ,
                                                 Payment_Term_Description__c = detail.Payment_Term_Description__c , 
                                                 Print_Daily_Invoice__c = detail.Print_Daily_Invoice__c , 
                                                 Summary_Bill_Cycle__c = detail.Summary_Bill_Cycle__c , 
                                                 Credit_Card_AR__c = detail.Credit_Card_AR__c , 
                                                 Summary_Bill__c = detail.Summary_Bill__c ,
                                                 EC_Bill_Cycle__c = detail.EC_Bill_Cycle__c 
                                                );
                Dtlomxkey.add(detail.OMX_Primary_Key__c);
                splitAccounts.add(sad);
                count=count+1;
            }
        }
        system.debug('>size>>>>>>'+splitAccounts.size()+'>>>splitAccounts>>>>>'+splitAccounts);
        if(splitAccounts.size()>0)
        insert splitAccounts;
        if(transDetailsUpdate.size()>0)
        update transDetailsUpdate;
    }

}