// Trigger to Over Ride Main account details
trigger afterTriggerSplitDEtails on Split_Account_Detail__c (after update) {

    Set<Id> custList= new Set<Id>();
    List<Customer_transition__C > custUpdate = new List<Customer_transition__C >();
    for (Split_Account_Detail__c eachCTdtls : Trigger.New) {        
    System.debug('&&&&&&&&&&&eachCTdtls.status__c'+eachCTdtls.status__c);
            if(eachCTdtls.status__c=='Uploaded' ){
                if (eachCTdtls.Master_Account__c == eachCTdtls.OMX_ACCOUNT__c){                
                    System.debug('&&&&&&&&&&&Inside');
                    
                 if(!custList.contains(eachCTdtls.Customer_Transition__c)){
                             Customer_transition__C cust= new Customer_transition__C (Id=eachCTdtls.Customer_Transition__c);
                             cust.Split_AR_Contact_First_Name__C=eachCTdtls.AP_CONTACT_FIRST_NAME__c;
                             cust.Split_AR_Contact_Last_Name__C=eachCTdtls.AP_CONTACT_LAST_NAME__c;
                             cust.Split_Billing_Type__C=eachCTdtls.NEW_BILLING_TYPE_AT_HEADER_LEVEL__c;
                             cust.Split_AR_Phone__c =eachCTdtls.AP_CONTACT_TELEPHONE__c;
                             /*cust.Primary_Contact_Email__C=eachCTdtls.AP_CONTACT_EMAIL_ADDRESS__c;
                             cust.Primary_Contact_Fax__C=eachCTdtls.AP_CONTACT_FAX__c;                    
                             cust.Split_Primary_Contact_Phone_Extension__C=eachCTdtls.AP_CONTACT_EXTENSION__c;*/
                             custUpdate .add(cust);
                             custList.add(eachCTdtls.Customer_Transition__c);
                             
                 }
        
             }
            }
  }
  if(custUpdate .size()>0)
  update custUpdate ;
}