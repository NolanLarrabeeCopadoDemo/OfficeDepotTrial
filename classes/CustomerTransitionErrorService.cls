global class CustomerTransitionErrorService{

  public static boolean CustomerTransitionErrorServicesRunning = false;
  public class CustomerTransitionErrorServiceException extends Exception {}

  global class CustomerTransitionErrorSynch {
    webservice List<CustomerTransitionHeaderErrorSynch> customerTransitionRecs;
  }
     
  global class CustomerTransitionHeaderErrorSynch{
    webservice String AOPS_Error_Id;    
    webservice String Request_Id;
    webservice String Request_Time_Stamp;    
    webservice String Error_Time_Stamp;
    webservice String Requestor_Name;
    webservice String AOPS_Customer_Id;
    webservice String File_Name;
    webservice String Operation_Type;
    webservice String SFDC_Id;
    webservice String Error_Message;
    webservice String Request_Type;
    webservice String Status;
  }
  
   webservice static boolean CustomerTransitionErrorSync(CustomerTransitionErrorSynch scps) {
      list<Transition_Error_Service_Dump__c> teUpd = new list<Transition_Error_Service_Dump__c>();
      for(CustomerTransitionHeaderErrorSynch synchRec : scps.customerTransitionRecs){
               
               Transition_Error_Service_Dump__c te = new Transition_Error_Service_Dump__c();
               te.AOPS_Error_Id__c = synchRec.AOPS_Error_Id;
               te.Request_Id__c = synchRec.Request_Id;
               te.Request_Time_Stamp__c = synchRec.Request_Time_Stamp;
               te.Error_Time_Stamp__c = synchRec.Error_Time_Stamp;
               te.Requestor_Name__c = synchRec.Requestor_Name;
               te.AOPS_Customer_Id__c = synchRec.AOPS_Customer_Id;
               te.File_Name__c = synchRec.File_Name;
               te.Operation_Type__c = synchRec.Operation_Type;
               te.SFDC_Id__c = synchRec.SFDC_Id;
               te.Error_Message__c = synchRec.Error_Message;
               te.Request_Type__c = synchRec.Request_Type;
               te.Status__c = synchRec.Status;
          
               teUpd.add(te);
          
       }
       
       database.insert(teUpd,false);
       
    /* CustomerTransitionErrorServicesRunning = true;
    
    if(scps.customerTransitionRecs.size() > 0){
      
      Set<Id> CustTransIds = new Set<Id>();
      Set<Id> CustTransDtlIds = new Set<Id>();
      Set<Id> CustTransDtlIds_sites = new Set<Id>();
      Map<ID,ID> sitesIDMap = new Map<ID,ID>();
      
      // Check whether it is Header error or shipto/PO/CC
      for(CustomerTransitionHeaderErrorSynch synchRec : scps.customerTransitionRecs){
         if(synchRec.Operation_Type == 'INITIAL_ACCOUNT_SETUP'){   
            CustTransIds.add(synchRec.SFDC_Id);
          }
         else if(synchRec.Operation_Type != 'INITIAL_ACCOUNT_SETUP'){  
            
             if (synchRec.Operation_Type == 'ADD_SHIP_TO_ADDRESS') {
                 CustTransDtlIds_sites.add(synchRec.SFDC_Id);
             }
             else
                 CustTransDtlIds.add(synchRec.SFDC_Id);
          } 
      }  
      
      // Query all header records in current batch of run
      Map<id,Customer_Transition__c> mCustomerTransition = new Map<ID,Customer_Transition__c>([select id,Status__c,Error_Code__c,AOPS_Error_Id__c,Error_Message__c,Error_Message_Level__c,Error_Message_Type__c from Customer_Transition__c where (id in :CustTransIds)  limit 100]);
      // Query all Shipto/PO/CC records in current batch of run
      Map<id,Customer_Transition_Dtls__c> mCustomerTransitionDtls = new Map<ID,Customer_Transition_Dtls__c>([select id,Error_Code__c,AOPS_Error_Id__c,Customer_Transition_ID__c,Customer_Transition_ID__r.Status__c,Customer_Transition_ID__r.Error_Message__c,Customer_Transition_ID__r.Error_Message_Level__c,Customer_Transition_ID__r.Error_Message_Type__c,Error_Message__c,Error_Message_Level__c,Error_Message_Type__c from Customer_Transition_Dtls__c where (id in :CustTransDtlIds) limit 100]);

      for (Customer_Transition_Dtls__c c:[select id,account_id__c,Error_Code__c,AOPS_Error_Id__c,Customer_Transition_ID__c,Customer_Transition_ID__r.Status__c,Customer_Transition_ID__r.Error_Message__c,Customer_Transition_ID__r.Error_Message_Level__c,Customer_Transition_ID__r.Error_Message_Type__c,Error_Message__c,Error_Message_Level__c,Error_Message_Type__c from Customer_Transition_Dtls__c where (account_id__c in :CustTransDtlIds_sites) limit 100]) {
         mCustomerTransitionDtls.put(c.id,c);
         sitesIDMap.put(c.account_id__c,c.id);
      }
      
      //Set<Id> CustTransIds1 = new Set<Id>();
      // Set<Id> newCusTransIDs = new Set<Id>();
      
      // This map contains a Header record ID and its related Shipto/PO/CC in current batch of run
      Map<ID,List<Customer_Transition_Dtls__c>> map_CustID_lCurDtlRecs = new Map<ID,List<Customer_Transition_Dtls__c>>();
      if(mCustomerTransitionDtls.values() != null){
          for(Customer_Transition_Dtls__c d : mCustomerTransitionDtls.values()){
              if(!map_CustID_lCurDtlRecs.containsKey(d.Customer_Transition_ID__c)){ 
                  List<Customer_Transition_Dtls__c> lTemp = new List<Customer_Transition_Dtls__c>();
                  lTemp.add(d);
                  map_CustID_lCurDtlRecs.put(d.Customer_Transition_ID__c,lTemp);
              }else {
                  List<Customer_Transition_Dtls__c> lTemp = new List<Customer_Transition_Dtls__c>();
                  lTemp = map_CustID_lCurDtlRecs.get(d.Customer_Transition_ID__c);
                  lTemp.add(d);
                  map_CustID_lCurDtlRecs.remove(d.Customer_Transition_ID__c);
                  map_CustID_lCurDtlRecs.put(d.Customer_Transition_ID__c,lTemp);
              }
          }    
      }
      // map ends
      
      // This map contains a Header record ID and its related Shipto/PO/CC error out records in DB
      Map<ID,List<Customer_Transition_Dtls__c>> map_CustTransID_lDtlRecs = new Map<ID,List<Customer_Transition_Dtls__c>>();
      
     
      Map<id,Customer_Transition__c> mCustomerTransition1 = new Map<id,Customer_Transition__c>();
      if(mCustomerTransition.keySet() != null){  
          // This map contains the header of details records which are in current batch 
          mCustomerTransition1 = new Map<ID,Customer_Transition__c>([select id,Error_Code__c,AOPS_Error_Id__c,Error_Message__c,Error_Message_Level__c,Error_Message_Type__c from Customer_Transition__c where (id in :map_CustID_lCurDtlRecs.keyset()) limit 100]); 
          // This map contains a Header record ID and its related Shipto/PO/CC error out records in DB
          for(Customer_Transition_Dtls__c d : [select id,Error_Code__c,AOPS_Error_Id__c,Customer_Transition_ID__c,Customer_Transition_ID__r.Error_Message__c,Customer_Transition_ID__r.Error_Message_Level__c,Customer_Transition_ID__r.Error_Message_Type__c,Error_Message__c,Error_Message_Level__c,Error_Message_Type__c from Customer_Transition_Dtls__c where (Customer_Transition_ID__c in :map_CustID_lCurDtlRecs.keyset() and Error_code__c ='Error') limit 100]) {
             if (!mCustomerTransitionDtls.containsKey(d.id)) {
              if(!map_CustTransID_lDtlRecs.containsKey(d.Customer_Transition_ID__c)){ 
                  List<Customer_Transition_Dtls__c> lTemp = new List<Customer_Transition_Dtls__c>();
                  lTemp.add(d);
                  map_CustTransID_lDtlRecs.put(d.Customer_Transition_ID__c,lTemp);
              }else {
                  List<Customer_Transition_Dtls__c> lTemp = new List<Customer_Transition_Dtls__c>();
                  lTemp = map_CustTransID_lDtlRecs.get(d.Customer_Transition_ID__c);
                  lTemp.add(d);
                  map_CustTransID_lDtlRecs.remove(d.Customer_Transition_ID__c);
                  map_CustTransID_lDtlRecs.put(d.Customer_Transition_ID__c,lTemp);
              }
            }
          }  // Map ends 
      }
              
             
      Map<ID,Customer_Transition__c> updCusTransSynch = new Map<ID,Customer_Transition__c>();
      Map<ID,Customer_Transition_Dtls__c> updCusTransDtlSynch = new Map<ID,Customer_Transition_Dtls__c>();
      Map<ID,Customer_Transition__c> mapUpdCusTransSynch = new Map<Id,Customer_Transition__c>();
      
      Map<String,String> map_OprType = new Map<String,String>();
      map_OprType.put('INITIAL_ACCOUNT_SETUP','Initial Account Setup Failure');
      map_OprType.put('ADD_SHIP_TO_ADDRESS','Address Failure');
      map_OprType.put('ADD_PO','Purchase Order Failure');
      map_OprType.put('ADD_COST_CENTER','Cost Center Failure');
      
      // Processing all the records
      for(CustomerTransitionHeaderErrorSynch synchRec : scps.customerTransitionRecs){
           // Processing Header record which is error out
           if(synchRec.Operation_Type == 'INITIAL_ACCOUNT_SETUP'){
            
             if(mCustomerTransition.get(synchRec.SFDC_Id) != null){
                 Customer_Transition__c cst =  mCustomerTransition.get(synchRec.SFDC_Id);
                 cst.AOPS_Error_Id__c = synchRec.AOPS_Error_Id;
                 // Error Scenario Start Here
                 System.debug('>>>>>>>>>>>>>>At Step 1' + synchRec.Status );
                 if(synchRec.Status =='01'){
                     System.debug('>>>>>>>>>>>>>>At Step 2' + synchRec.Request_Type );
                     if(synchRec.Request_Type =='SY')
                         cst.Error_Message_Type__c = 'System Failure';
                     else if(synchRec.Request_Type =='ER')
                         cst.Error_Message_Type__c = 'Data Failure';    
                     
                     cst.Error_Message__c = synchRec.Error_Message;
                     if(map_OprType.get(synchRec.Operation_Type) != null)
                         cst.Error_Message_Level__c = map_OprType.get(synchRec.Operation_Type);
                     cst.Error_Code__c = 'Error'; 
                    ///// cst.Status__c = 'Error - Launched';  
                  } // Error Scenario End Here
                    // Succes Scenario Start Here  
                  else if(synchRec.Status =='00'){
                  System.debug('>>>>>>>>>>>>>>At Step 3' + synchRec.Status );
                            cst.Error_Message_Type__c = null; 
                            cst.Error_Message__c = null;
                            cst.Error_Message_Level__c = null;
                            cst.Error_code__c ='Success';
                      /////       cst.Status__c = 'Launched';  
                  } // Succes Scenario End Here  
                  updCusTransSynch.put(cst.id,cst); 
               }
            } 
            // Processing Shipto/CC/PO records
            else if(synchRec.Operation_Type != 'INITIAL_ACCOUNT_SETUP'){
            
             ID sfdcid;
             IF (synchRec.Operation_Type == 'ADD_SHIP_TO_ADDRESS')
               sfdcid = sitesIDMap.get(synchRec.SFDC_Id);
             else
                sfdcid = synchRec.SFDC_Id;
            
             if(mCustomerTransitionDtls.get(sfdcid) != null){   
                Customer_Transition_Dtls__c cstD =  mCustomerTransitionDtls.get(sfdcid);
                cstD.AOPS_Error_Id__c = synchRec.AOPS_Error_Id; 
                        // Check Error Scenario Starts here
                        if(synchRec.Status =='01'){
                            if(synchRec.Request_Type =='SY')
                                 cstD.Error_Message_Type__c = 'System Failure';
                            else if(synchRec.Request_Type =='ER')
                                 cstD.Error_Message_Type__c = 'Data Failure';
                            cstD.Error_Message__c = synchRec.Error_Message;
                            if(map_OprType.get(synchRec.Operation_Type) != null)
                                cstD.Error_Message_Level__c = map_OprType.get(synchRec.Operation_Type);
                            cstD.Error_Code__c = 'Error'; 
                            updCusTransDtlSynch.put(cstd.id,cstD); 
                            
                            // As child got error out, set parent as Error
                            Customer_Transition__c cst =  mCustomerTransition1.get(cstD.Customer_Transition_ID__c); 
                                if(synchRec.Request_Type =='SY')
                                     cst.Error_Message_Type__c = 'System Failure';
                                else if(synchRec.Request_Type =='ER')
                                     cst.Error_Message_Type__c = 'Data Failure'; 
                                cst.Error_Message__c = 'Additional Shipto/PO/Cost Center Failure. Please see details';
                                if(map_OprType.get(synchRec.Operation_Type) != null)
                                    cst.Error_Message_Level__c = map_OprType.get(synchRec.Operation_Type);
                                cst.Error_Code__c = 'Error';
                               /////  cst.Status__c = 'Error - Launched';
                                if(!mapUpdCusTransSynch.containsKey(cstD.Customer_Transition_ID__c))
                                    mapUpdCusTransSynch.put(cstD.Customer_Transition_ID__c,cst);
                                else{
                                    mapUpdCusTransSynch.remove(cstD.Customer_Transition_ID__c);
                                    mapUpdCusTransSynch.put(cstD.Customer_Transition_ID__c,cst);
                                }
                         }
                         // Check Success Scenario for Shipto/PO/CC record Starts here
                         else if(synchRec.Status =='00'){
                             cstD.Error_Message_Type__c = null; 
                             cstD.Error_Message__c = null;
                             cstD.Error_Message_Level__c = null;
                             cstD.Error_code__c ='Success';
                             updCusTransDtlSynch.put(cstd.id,cstD); 
                             
                                    // Check if any child record of parent is error, if yes make it error and if not make it success 
                                    Customer_Transition__c cst =  mCustomerTransition1.get(cstD.Customer_Transition_ID__c); 
                                    List<Customer_Transition_Dtls__c> lRecs = new List<Customer_Transition_Dtls__c>();
                                    lRecs = map_CustTransID_lDtlRecs.get(cstD.Customer_Transition_ID__c);
                                    Boolean currentList = false;
                                        if(lRecs!= null)
                                            currentList = true;
                                        else{
                                            if(map_CustID_lCurDtlRecs.get(cstD.Customer_Transition_ID__c)!=null){ 
                                             for(Customer_Transition_Dtls__c l : map_CustID_lCurDtlRecs.get(cstD.Customer_Transition_ID__c)){
                                                 Customer_Transition_Dtls__c cstd1 = updCusTransDtlSynch.get(l.id);
                                                 if(cstd1.error_code__c =='Error')
                                                      currentList = true;
                                             } 
                                            }
                                         }   
                                            if(currentList == true){
                                                 if(synchRec.Request_Type =='SY')
                                                     cst.Error_Message_Type__c = 'System Failure';
                                                 else if(synchRec.Request_Type =='ER')
                                                 cst.Error_Message_Type__c = 'Data Failure'; 
                                                 cst.Error_Message__c = 'Additional Shipto/PO/Cost Center Failure. Please see details';
                                                 cst.Error_Message_Level__c = map_OprType.get(synchRec.Operation_Type);
                                                 cst.Error_Code__c = 'Error';
                                                 ///// cst.Status__c = 'Error - Launched';
                                            }else{
                                                 cst.Error_Message_Type__c = null; 
                                                 cst.Error_Message__c = null;
                                                 cst.Error_Message_Level__c = null;
                                               /////   cst.Status__c = 'Launched';
                                                 cst.Error_code__c ='Success';}                                                       
                                        
                             
                                         if(!mapUpdCusTransSynch.containsKey(cstD.Customer_Transition_ID__c))
                                                mapUpdCusTransSynch.put(cstD.Customer_Transition_ID__c,cst);
                                         else{
                                             mapUpdCusTransSynch.remove(cstD.Customer_Transition_ID__c);
                                             mapUpdCusTransSynch.put(cstD.Customer_Transition_ID__c,cst);}
                              
                        }  // Success scenario ends here 
              } // Null Check for Detail record in map 
           } // Else part of processing Shipto/CC/PO ends here
       }
       
      if(updCusTransSynch.values() != null)
             update updCusTransSynch.values(); 
      if(mapUpdCusTransSynch.values() != null)
          update mapUpdCusTransSynch.values();
      if(updCusTransDtlSynch.values() != null)
             update updCusTransDtlSynch.values();        
      
      
      }*/
    
     
    return true;
  }
  
}