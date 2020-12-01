//Class to validate Split Details 
public class SplitRecordsValidator {
    
 
    public void createSplitDetails(List<Split_Account_Detail__c> splitList) {
    Map<Id,String> mapList= new Map<Id,String>();
    List<string> billList = new List<String>();
    List<string> addList = new List<String>();
    Map<String,Account> billRef= new Map<String,Account>();
    Map<String,Id> billchkRef= new Map<String,Id>();
    Map<String,String> billchkRefCode= new Map<String,String>();

    Map<String,Id> addRef= new Map<String,Id>();
       Id SiteOMX = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Site (OfficeMax)').getRecordTypeId();
       Id Site = Schema.SObjectType.Customer_Transition_Dtls__c.getRecordTypeInfosByName().get('Sites').getRecordTypeId();

    
      for(Split_Account_Detail__c split : splitList){
      if(split.NEW_BILL_TO_OMX_CONSIGNEE__c !=null)
      billList.add(split.NEW_BILL_TO_OMX_CONSIGNEE__c );
      if(split.NEW_MAIN_ACCT_ADDRESS__c!=null)
      addList.add(split.NEW_MAIN_ACCT_ADDRESS__c);
      }
              // Get the Accounts
            if (billList.size() > 0) {
            
           List<Account> accounts=[Select Id,Name,Related_Account__c,Related_Account__r.Id,omx_primary_key__C
                  from account where
                  omx_primary_key__C in:billList
                  and recordtypeId=:SiteOMX ];
                  
        //getting Transition details for the Bill to
        List< Customer_Transition_Dtls__c> custdetails=[select Ship_2_Bill_2_Code__c,omx_primary_key__C  from Customer_Transition_Dtls__c
        where omx_primary_key__C in:billList
                  and recordtypeId=:Site ];

                  
                
                for (Account acc : accounts) 
                {
                    billRef.put(acc.omx_primary_key__C ,acc);
                    if(acc.Related_Account__c!=null) {
                        billchkRef.put(acc.omx_primary_key__C,acc.Related_Account__r.Id);
                    }
                }
                
                 for (Customer_Transition_Dtls__c cust: custdetails) 
                {
                    if(cust.Ship_2_Bill_2_Code__c !='') {
                        billchkRefCode.put(cust.omx_primary_key__C,cust.Ship_2_Bill_2_Code__c );
                    }
                } 
                
                
                
            }
        
        System.debug('&&&&&&&&&&billchkRef'+ billchkRef);
                  // Get the Accounts
            if (addList.size() > 0) {
                for (Account accAdd : [Select Id,omx_primary_key__C  from account where omx_primary_key__C in:addList]) {
                    addRef.put(accAdd.omx_primary_key__C ,accAdd.Id);
                }
            }
            
       System.debug('&&&&&&&&&&addRef'+addRef);
            for(Split_Account_Detail__c split : splitList){
            
            String errorMessage=' ';
                                
                         if(split.AP_CONTACT_LAST_NAME__c ==null || split.AP_CONTACT_LAST_NAME__c =='')
                          errorMessage=errorMessage+' - AP Contact Last Name Missing';
                          if(split.AP_CONTACT_FIRST_NAME__c ==null || split.AP_CONTACT_FIRST_NAME__c =='')
                          errorMessage=errorMessage+' - AP Contact First Name Missing';
                          if(split.NEW_BILLING_TYPE_AT_HEADER_LEVEL__c == null || split.NEW_BILLING_TYPE_AT_HEADER_LEVEL__c == '')
                          errorMessage=errorMessage+' - Billing Type Missing';
                          else if(split.NEW_BILLING_TYPE_AT_HEADER_LEVEL__c != 'DI' && split.NEW_BILLING_TYPE_AT_HEADER_LEVEL__c != 'IS')
                          errorMessage=errorMessage+' - Billing Type Should be either DI or IS';

               
            
                          if(split.NEW_BILL_TO_OMX_CONSIGNEE__c !=null){                                     
                                     System.debug('&&&&&billkey'+billRef.get(split.NEW_BILL_TO_OMX_CONSIGNEE__c ));
                                       if(billRef.get(split.NEW_BILL_TO_OMX_CONSIGNEE__c )==null  )
                                        errorMessage=errorMessage+' - Enter Valid Billing Key';
                                       if(billRef.get(split.NEW_BILL_TO_OMX_CONSIGNEE__c )!=null  ){
                                           if(billchkRef.get(split.NEW_BILL_TO_OMX_CONSIGNEE__c)  !=split.original_account__c){
                                             System.debug('&&&&&&&&billchkRef.get  '+  billchkRef.get(split.NEW_BILL_TO_OMX_CONSIGNEE__c));
                                             System.debug('&&&&&&&&split.original_account__c '+  split.original_account__c );
                                            errorMessage=errorMessage+' - Enter Valid Billing Key in the group';
                                            }
                                            else{
                                             split.New_Header_Billing_Account__c=billRef.get(split.NEW_BILL_TO_OMX_CONSIGNEE__c).Id;
                                             split.New_Header_Billing_Account_Code__C=billchkRefCode.get(split.NEW_BILL_TO_OMX_CONSIGNEE__c);
                                             split.Main_Account_Name__c =billRef.get(split.NEW_BILL_TO_OMX_CONSIGNEE__c).name;
                                            }                               
                                       }
                             }
                             else{
                             split.Main_Account_Name__c =split.OMX_ACCT_NAME__c;
                             }
               
                
                    if(split.Master_Account__c ==null || split.Master_Account__c ==''){
                    errorMessage=errorMessage+' - Please enter NEW OMX ACCOUNT #';
                    }
                    //Find the errors
                    else{
                    
                        if(split.Master_Account__c !=split.OMX_ACCOUNT__c ){
                        System.debug('&&&&&&&&entered');
                        
                          String originalKeyphrase=split.OMX_ACCOUNT__c+'-';
                          if(!(split.Master_Account__c.contains(originalKeyphrase)))
                          errorMessage=errorMessage+' - Please enter New OMX key in format';
                          
                          /*
                          if(split.Main_Account_Name__c ==null || split.Main_Account_Name__c =='')
                          errorMessage=errorMessage+' - NEW OMX ACCOUNT Name Missing';
                          */
                                                       
                             if(split.NEW_MAIN_ACCT_ADDRESS__c!=null){
                               if(addRef.get(split.NEW_MAIN_ACCT_ADDRESS__c)==null)
                                errorMessage=errorMessage+' - Enter Valid Address Key';
                             }
                          
                        }
                    
                    }
                    //Throwing Error 
                    if(errorMessage!=' ')
                    split.adderror(errorMessage);
            
            }

  }
    

    }