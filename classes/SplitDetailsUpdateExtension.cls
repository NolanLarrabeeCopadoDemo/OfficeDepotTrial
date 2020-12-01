public class SplitDetailsUpdateExtension {
    
    // Update Billing Type and AP contact Details
    @future
    public static void updateTransition(List<Id> mod5List) {
        System.debug('&&&&&&&&&&&SplitDetailsUpdateExtensionhere1'+mod5List);
        List<Customer_Transition__c> updateList= new List<Customer_Transition__c>();
        
        // Get the split details Records
        List<Split_Account_Detail__c> splitDetail = [SELECT Linked_Customer_Transition__c, AP_CONTACT_FIRST_NAME__c, AP_CONTACT_LAST_NAME__c, AP_CONTACT_TELEPHONE__c,
                                                     NEW_BILLING_TYPE_AT_HEADER_LEVEL__c, Customer_Transition__r.AR_Flag__c, Customer_Transition__c 
                                                     FROM Split_Account_Detail__c
                                                     WHERE Linked_Customer_Transition__c IN :mod5List];  
            
        for (Id record : mod5List) {
            for (Split_Account_Detail__c split : splitDetail) {
                if (record == split.Linked_Customer_Transition__c) {
                    Customer_Transition__c cust = new Customer_Transition__c(Id = record,
                                                                            Original_Customer_Transition__c = split.Customer_Transition__c,                        
                                                                            AR_Primary_Contact_First_Name__c = split.AP_CONTACT_FIRST_NAME__c,
                                                                            AR_Primary_Contact_Last_Name__c = split.AP_CONTACT_LAST_NAME__c,
                                                                            AR_Phone__c = split.AP_CONTACT_TELEPHONE__c,  
                                                                            Ship_2_Bill_2_Code__c = 'N', 
                                                                            AOPS_Flag__c = 'Y',
                                                                            Final_Split_Decision__c ='No',
                                                                            Transition_Status__c ='Active',
                                                                            status__C ='On Deck',
                                                                            Billing_Type__c = split.NEW_BILLING_TYPE_AT_HEADER_LEVEL__c
                                                                            // Start - Story #00888275
                                                                            
                                                                            // Commenting out default value assignment
                                                                            // AR_Flag__c = 'Y',
                                                                            // Billing_Document_Type__c = 'S',
                                                                            // Billing_Frequency__c = 'W',
                                                                            // Billing_Type_Flag__c = 'P',
                                                                            
                                                                            // End - Story #00888275
                                                                            );

                    updateList.add(cust);
                }
            }
        }
        
        System.debug('&&&&&&&&&&&SplitDetailsUpdateExtensionhere2'+updateList);
        List<Customer_Transition__c> setupdate = new List<Customer_Transition__c>();
        Set<id> setid = new Set<Id>();
        
        if (updateList.size() > 0) {
            for (Customer_Transition__c ct : updateList) {
                if (!setid.contains(ct.id)) {
                    setid.add(ct.id);
                    setupdate.add(ct);
                }
            }
            update setupdate;
        }
    }
}