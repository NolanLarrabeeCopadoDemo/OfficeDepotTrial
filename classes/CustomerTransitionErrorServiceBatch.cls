Global class CustomerTransitionErrorServiceBatch implements database.Batchable<Sobject>,Database.Stateful,Schedulable
{
    global String strQuery; //this variable used to set query from test class or from shceduler if required
    
    
    // Below is set a default query in case not set in test class or in scheduler
    private String DEFAULT_QUERY = 'Select id,Request_Type__c,AOPS_Error_Id__c ,SFDC_Id__c,AOPS_Customer_Id__c,Error_Message__c,Error_Time_Stamp__c,Request_Id__c ,Request_Time_Stamp__c,Requestor_Name__c ,File_Name__c ,Operation_Type__c ,status__C from Transition_Error_Service_Dump__c WHERE Processing_Status__c!= \'Processed\''; 
 /* Default Constructor*/
    global CustomerTransitionErrorServiceBatch()
    {        
        this.strQuery = DEFAULT_QUERY;
    }
    
 /* This method prepares the scope of the batch program based on the query result */
    global Database.QueryLocator start(Database.BatchableContext BC)
    {
        system.debug('strQuery@@@'+strQuery);
        return Database.getQueryLocator(strQuery);
    }
     /* This method processes query result in batches */
    global void execute(Database.BatchableContext BC, Transition_Error_Service_Dump__c[] scope)
    {
        Set<string> Ids  =new set<string>();
         map<String,Customer_Transition_Dtls__c> mCustomerTransitionDtls= new map<String,Customer_Transition_Dtls__c>();
         map<String,Customer_Transition__c> mCustomerTransition= new map<string,Customer_Transition__c>();
         
      Map<String,String> map_OprType = new Map<String,String>();
      map_OprType.put('INITIAL_ACCOUNT_SETUP','Initial Account Setup Failure');
      map_OprType.put('ADD_SHIP_TO_ADDRESS','Address Failure');
      map_OprType.put('ADD_PO','Purchase Order Failure');
      map_OprType.put('ADD_COST_CENTER','Cost Center Failure');


        for(Transition_Error_Service_Dump__c trd :scope){
            Ids.add(trd.SFDC_Id__c);
        }

        List<Transition_Error_Service_Dump__c> transtnErrList = new List<Transition_Error_Service_Dump__c>();


        for(Customer_Transition__c synchRec : [select id from Customer_Transition__c where id in: Ids]){
            mCustomerTransition.put(synchRec.id,synchRec);
        }

        for(Customer_Transition_Dtls__c synchRec : [select id from Customer_Transition_Dtls__c where id in: Ids]){
            mCustomerTransitionDtls.put(synchRec.id,synchRec);
        }
        
        List<Customer_Transition__c > updateCustList= new List<Customer_Transition__c >();
        List<Customer_Transition_Dtls__c > UpdateCstDetailList= new List<Customer_Transition_Dtls__c >();
     
        
       for (Customer_Transition_Dtls__c c:[select id,account_id__c,Error_Code__c,AOPS_Error_Id__c,Customer_Transition_ID__c,
       Customer_Transition_ID__r.Status__c,Customer_Transition_ID__r.Error_Message__c,Customer_Transition_ID__r.Error_Message_Level__c,
       Customer_Transition_ID__r.Error_Message_Type__c,Error_Message__c,Error_Message_Level__c,Error_Message_Type__c from 
       Customer_Transition_Dtls__c where (account_id__c in :Ids) ]) {
                  mCustomerTransitionDtls.put(c.account_id__c,c);
      }

        
        
        
        
        for(Transition_Error_Service_Dump__c synchRec:scope){
                 
          // Processing Header record which is error out
          if(synchRec.Operation_Type__C == 'INITIAL_ACCOUNT_SETUP'){
            
             if(mCustomerTransition.get(synchRec.SFDC_Id__C) != null){
                 Customer_Transition__c cst =  mCustomerTransition.get(synchRec.SFDC_Id__c);
                 cst.AOPS_Error_Id__c = synchRec.AOPS_Customer_Id__c ;
                 // Error Scenario Start Here
                 if(synchRec.Status__c =='01'){
                     System.debug('>>>>>>>>>>>>>>At Step 2' + synchRec.Request_Type__c );
                     if(synchRec.Request_Type__c =='SY')
                         cst.Error_Message_Type__c = 'System Failure';
                     else if(synchRec.Request_Type__c =='ER')
                         cst.Error_Message_Type__c = 'Data Failure';                           
                        cst.Error_Message__c = synchRec.Error_Message__c ;
                     if(map_OprType.get(synchRec.Operation_Type__c ) != null)
                         cst.Error_Message_Level__c = map_OprType.get(synchRec.Operation_Type__c );
                     cst.Error_Code__c = 'Error'; 
                    ///// cst.Status__c = 'Error - Launched';  
                  } // Error Scenario End Here
                    // Succes Scenario Start Here  
                  else if(synchRec.Status__C =='00'){
                  System.debug('>>>>>>>>>>>>>>At Step 3' + synchRec.Status__c );
                            cst.Error_Message_Type__c = null; 
                            cst.Error_Message__c = null;
                            cst.Error_Message_Level__c = null;
                            cst.Error_code__c ='Success';
                      /////       cst.Status__c = 'Launched';  
                  } // Succes Scenario End Here  
                  UpdateCustList.add(cst); 
               }
       
            }
            
                    // Processing Shipto/CC/PO records
            else if(synchRec.Operation_Type__c != 'INITIAL_ACCOUNT_SETUP'){            
             ID sfdcid;
             sfdcid = synchRec.SFDC_Id__c;
            
             if(mCustomerTransitionDtls.get(sfdcid) != null){   
                Customer_Transition_Dtls__c cstD =  mCustomerTransitionDtls.get(sfdcid);
                cstD.AOPS_Error_Id__c = synchRec.AOPS_Error_Id__c; 
                        // Check Error Scenario Starts here
                        if(synchRec.Status__C =='01'){
                            if(synchRec.Request_Type__c =='SY')
                                 cstD.Error_Message_Type__c = 'System Failure';
                            else if(synchRec.Request_Type__C =='ER')
                                 cstD.Error_Message_Type__c = 'Data Failure';
                            cstD.Error_Message__c = synchRec.Error_Message__C;
                            if(map_OprType.get(synchRec.Operation_Type__C) != null)
                                cstD.Error_Message_Level__c = map_OprType.get(synchRec.Operation_Type__C);
                            cstD.Error_Code__c = 'Error'; 
                            
                         }
                         // Check Success Scenario for Shipto/PO/CC record Starts here
                         else if(synchRec.Status__C =='00'){
                             cstD.Error_Message_Type__c = null; 
                             cstD.Error_Message__c = null;
                             cstD.Error_Message_Level__c = null;
                             cstD.Error_code__c ='Success';
                         }                             
    
            UpdateCstDetailList.add(cstD );
            }
      }      
            
            
               synchRec.Processing_Status__c= 'Processed';
               transtnErrList.add(synchRec);
            
        }
        if(transtnErrList.size()>0){
        //update transtnErrList;
        delete transtnErrList;
        }
        if(UpdateCustList.size()>0)
        update UpdateCustList;
        if(UpdateCstDetailList.size()>0)
        update UpdateCstDetailList;
    }
    /* This method is to execute to relase some resources if any*/
    global void finish(Database.BatchableContext BC)
    {
        CustTransParentChildLevel__c PCLevel2 = [select CustomerTransitionError__c,CustomerTransition_Interval__c from CustTransParentChildLevel__c limit 1];
        integer interval = 300;
        if (PCLevel2.CustomerTransitionError__c <> null) {
                      for (CronTrigger t: [SELECT Id FROM CronTrigger where ID=:PCLevel2.CustomerTransitionError__c])
                         system.abortJob(t.id);
            }
            if (PCLevel2.CustomerTransition_Interval__c!= null)    interval = integer.valueof(PCLevel2.CustomerTransition_Interval__c);
            DateTime sysTime = System.now().addSeconds(interval);
            String chronExpression = '' + sysTime.second() + ' ' + sysTime.minute() + ' ' + sysTime.hour() + ' ' + sysTime.day() + ' ' + sysTime.month() + ' ? ' + sysTime.year();
    
            CustomerTransitionErrorServiceBatch scheduledBatch = new CustomerTransitionErrorServiceBatch();
            ID cronid = System.schedule( 'CustomerTransitionErrorServiceSch' + sysTime, chronExpression, scheduledBatch );
            
            PCLevel2.CustomerTransitionError__c= cronid;
            
            update PCLevel2; 
            
       // CustomerTransitionErrorServiceBatch assignBatchError = new CustomerTransitionErrorServiceBatch();
        // database.executebatch(assignBatchError , 1);

    }
     global void execute(SchedulableContext sc){
       
        CustomerTransitionErrorServiceBatch assignBatch = new CustomerTransitionErrorServiceBatch();
        database.executebatch(assignBatch, 1);
        
    } 

}