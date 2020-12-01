Trigger Update_Status_Age on Customer_Transition__c (before update,after update) 
{

     if(executeoncetest.mod5ByPass==true || Test.isRunningTest()){


if(Trigger.IsBefore){
    for (Customer_Transition__c CT : Trigger.new) 
    {
    // Logic got update to change the status from Lunched to Ready to Order.

    If((CT.Ready_to_order__c) && !(Trigger.oldmap.get(CT.ID).Ready_to_order__c)){
       CT.Ready_To_Order_By__c = UserInfo.getName();
       CT.Ready_to_Order_Date__c = Date.today();
        
    }
    /////////////////////////////////////////////////////////Mod2///////////////////////////////////////////
    If((CT.Ready_for_audit_2__c == true && !(Trigger.oldmap.get(CT.ID).Ready_for_audit_2__c )))
    {
        CT.Status__c = 'Audit 2';   
    }
    
    ///Move the code here from below  00778970
    
        If((CT.Status__c == 'Auto Redirected' && (Trigger.oldmap.get(CT.ID).Status__c !='Auto Redirected')  && ( CT.DUAL_Account_Yes_No__c) ))
    {
        ////////////CT.DUAL_Account_Yes_No__c= false;
        CT.Automatic_Redirect__c= Date.today();
        system.debug('>>>>CT.id>>>>'+CT.id);
        CustTransitionAOPSCallOut.basicAuthCallout(CT.id,CT.AOPS_Assigned_AOPS_Account_ID__c,'REDIRECT','R');  
    }
    
    //end of Move the code here from below  00778970

  
    If( ((CT.Ready_to_order__c) && !(Trigger.oldmap.get(CT.ID).Ready_to_order__c) )  && ( CT.DUAL_Account_Yes_No__c)){
    CT.Status__c = 'Ready to Order';
        system.debug('>>>>CT.id>>>>'+CT.id);
    CustTransitionAOPSCallOut.basicAuthCallout(CT.id,CT.AOPS_Assigned_AOPS_Account_ID__c,'PLACE OD ORD','Y');
    }

    If( ((CT.Ready_to_order__c) && !(Trigger.oldmap.get(CT.ID).Ready_to_order__c) )  && ( CT.DUAL_Account_Yes_No__c==false)){
        system.debug('>>>>CT.id>>>>'+CT.id);
    CustTransitionAOPSCallOut.basicAuthCallout(CT.id,CT.AOPS_Assigned_AOPS_Account_ID__c,'PLACE OD ORD','Z');
    CT.Status__c = 'Auto Redirected';

     CT.DUAL_Account_Yes_No__c= false;
     CT.Automatic_Redirect__c= Date.today();
    }
    If((CT.DNS_Status_Confirmed__c== true && !(Trigger.oldmap.get(CT.ID).DNS_Status_Confirmed__c )))
    {
        system.debug('>>>>CT.id>>>>'+CT.id);
        
       //start of 00639911 reverting Redirect stopped
        if(CT.Redirect_Turned_OFF__c == false)
        CT.BatchProcessSentDNS__c = true;
        // end of 00639911 
      // CustTransitionAOPSCallOut.basicAuthCallout(CT.id,CT.AOPS_Assigned_AOPS_Account_ID__c,'DNS','Y');
    }



    system.debug('>>>>status>>>>'+CT.status__C);
    system.debug('>>>>Ready_for_account_finalizing_final_mod__c >>>>'+CT.Ready_for_account_finalizing_final_mod__c );
    system.debug('>>>>Trigger.oldmap.get(CT.ID).Ready_for_account_finalizing_final_mod__c >>>>'+Trigger.oldmap.get(CT.ID).Ready_for_account_finalizing_final_mod__c );



    If(CT.Ready_for_account_finalizing_final_mod__c == true && Trigger.oldmap.get(CT.ID).Ready_for_account_finalizing_final_mod__c ==false  &&  ( CT.status__c =='Launched'  ||  CT.status__c =='Error - Launched'))
    {
        CT.Status__c = 'Ready for eCom Mod';
        CT.B2B_MOD_2_Date__c = Date.today();
        system.debug('>>>>CT.id>>>>'+CT.id);
        CustTransitionAOPSCallOut.basicAuthCallout(CT.id,CT.AOPS_Assigned_AOPS_Account_ID__c,'WEB USER','S');
    }

    // Logic Added per Case: 318546
    If ((CT.Redirect_Turned_OFF__c == true && !(Trigger.oldmap.get(CT.ID).Redirect_Turned_OFF__c)))
    {
        // change made to enter Revert redirect turn off  00778970 
        
        
        if(CT.Estimated_OMX_Acct_Close__c==null|| (CT.Estimated_OMX_Acct_Close__c==Trigger.oldmap.get(CT.ID).Estimated_OMX_Acct_Close__c)){
        CT.adderror('Please enter Estimated Close Date or Change the date');
        }
        else{
            CT.IsRedirectStopped__c=true;
            CT.Redirect_Turned_OFF_Date__c = Date.today();
            CT.Automatic_Redirect__c= null;

            CT.Status__c = 'Redirect Stopped';
            system.debug('>>>>CT.id>>>>'+CT.id);
            //start of 00639911  Redirect stopped
            CustTransitionAOPSCallOut.basicAuthCallout(CT.id,CT.AOPS_Assigned_AOPS_Account_ID__c,'REDIRECT','N');
            CustTransitionAOPSCallOut.basicAuthCallout(CT.id,CT.AOPS_Assigned_AOPS_Account_ID__c,'DNS','N');  
            CT.DNS_Status_Confirmed__c=false;
            CT.DNS_Sent_Date__c=null;                             
            // end of 00639911
        } 
        // end of  change made to enter Revert redirect turn off  00778970 
 
    }
        //start of 00639911,00778970  reverting Redirect stopped
    If (CT.Redirect_Turned_OFF__c == false &&  Trigger.oldmap.get(CT.ID).Redirect_Turned_OFF__c==TRUE){
    
            sYSTEM.DEBUG('&&&&&&&&&&&INSIDE THIS LOOP');
            CT.Redirect_Turned_OFF_Date__c = null;
            CT.Status__c = 'Auto Redirected';
            CT.Automatic_Redirect__c= Date.today();

          CustTransitionAOPSCallOut.basicAuthCallout(CT.id,CT.AOPS_Assigned_AOPS_Account_ID__c,'REDIRECT','R');
          CustTransitionAOPSCallOut.basicAuthCallout(CT.id,CT.AOPS_Assigned_AOPS_Account_ID__c,'DNS','N');                               

         /* if(CT.DNS_Status_Confirmed__c== true)
          CustTransitionAOPSCallOut.basicAuthCallout(CT.id,CT.AOPS_Assigned_AOPS_Account_ID__c,'DNS','Y');                               
          else
          CustTransitionAOPSCallOut.basicAuthCallout(CT.id,CT.AOPS_Assigned_AOPS_Account_ID__c,'DNS','N');                               
        */
    }
  //end of 00639911,00778970  
//when it is Redirection turn off and Transition completed
    If((CT.Status__c == 'Transition Complete' && (Trigger.oldmap.get(CT.ID).Status__c !='Transition Complete')  && ( CT.Redirect_Turned_OFF__c) ))
    {

        CustTransitionAOPSCallOut.basicAuthCallout(CT.id,CT.AOPS_Assigned_AOPS_Account_ID__c,'REDIRECT','R');  
    }
    
    //when it is Redirection turn off and reverted
    If( (Trigger.oldmap.get(CT.ID).Redirect_Turned_OFF__c !=CT.Redirect_Turned_OFF__c)  &&  ( CT.Redirect_Turned_OFF__c==false))
    {

        CustTransitionAOPSCallOut.basicAuthCallout(CT.id,CT.AOPS_Assigned_AOPS_Account_ID__c,'REDIRECT','R');  
    }

    If ((CT.DNS_Confirmation__c == true && !(Trigger.oldmap.get(CT.ID).DNS_Confirmation__c )))
    {
        CT.DNS_Status_Confirmed_Date__c = Date.today();
    }

        
        //Start for Case 00574414 
        
        //commenting as per Case 00689457
        /*
        if(CT.Administrative_Close__c == True &&  (Trigger.oldMap.get(CT.Id).Administrative_Close__c!=CT.Administrative_Close__c) && (CT.Ready_for_Mod1__c == false   &&  ( CT.DNS_Confirmation__c == true || CT.DNS_Status_Confirmed__c == true)))
        {
            CT.status__c='Administrative Close';
        }
        else if (CT.Administrative_Close__c == True &&  (Trigger.oldMap.get(CT.Id).Administrative_Close__c!=CT.Administrative_Close__c) && (CT.Ready_for_Mod1__c == true || ( CT.DNS_Confirmation__c == false && CT.DNS_Status_Confirmed__c == false)))
        {
            CT.addError('Can not select Administrative Close check box when record is already launched OR DNS Confirmation/DNS Status Confirmed is not checked');
        }       
        
        */
        if(CT.Administrative_Close__c == True &&  Trigger.oldMap.get(CT.Id).Administrative_Close__c!=CT.Administrative_Close__c)
         CT.status__c='Administrative Close';
        // end of 00689457
        //End for Case 00574414
    }
        
    }
}

if((Trigger.IsAfter)&&(executeoncetest.Update_Status_Age_check || Test.isRunningTest())) //Customer Loss & Administrative Close Functionality
    {
    system.debug('executeoncetest.Update_Status_Age_check@@@'+executeoncetest.Update_Status_Age_check);
    Set<ID> CTids = new Set<ID>();
    Set<ID> customerLostCTids = new Set<ID>();
    
    Set<ID> lockCT = new Set<ID>();
    Map<Id,Date> closeDate = new Map<Id,Date>();
    
    List<Customer_Transition__c> updatedCT = new List<Customer_Transition__c>();
    List<Customer_Transition__c> updateCTCustLost = new List<Customer_Transition__c>();
      
        for(Customer_Transition__c CTs : Trigger.new) 
        {
        IF (CTs.Customer_Transition_Date_to_OD_Systems__c != null)
            {
                IF ( CTs.Customer_Loss__c == True   &&  (Trigger.oldMap.get(CTs.Id).Customer_Loss__c!=CTs.Customer_Loss__c)  )
                {
                customerLostCTids.add(CTs.id);
                closeDate.put(CTs.id,CTs.Customer_Transition_Date_to_OD_Systems__c);
                CT_OnDeck_WRF_cls.childCTtoMappedCT.put(CTs.id,CTs.id);
                }
                /* Moved to Before insert method
                //Added "CTs.Ready_for_Mod1__c == false && (CTs.DNS_Confirmation__c == true || CTs.DNS_Status_Confirmed__c == true)" Case # 00574414
                IF (CTs.Administrative_Close__c == True &&  (Trigger.oldMap.get(CTs.Id).Administrative_Close__c!=CTs.Administrative_Close__c) && 
                CTs.Ready_for_Mod1__c == false && (CTs.DNS_Confirmation__c == true || CTs.DNS_Status_Confirmed__c == true))
                {
                    CTids.add(CTs.id);
                }*/ 
                executeoncetest.Update_Status_Age_check=false;
            }
        }
        system.debug('executeoncetest.Update_Status_Age_check@@@'+executeoncetest.Update_Status_Age_check);
    
     //Status Update for CT records having Administrative_Close__c checked
     /* Moved to Before insert method
     if((!CTids.isEmpty()) && CTids!=NULL)
     {
     
     List<Customer_Transition__c> updateCT = [select id,Customer_Loss__c,Administrative_Close__c,Customer_Transition_Date_to_OD_Systems__c,status__c,Compliance_Life_Cycle_Reviewed_Person__c,Compliance_Life_Cycle_Reviewed__c from Customer_Transition__c where id in :CTids];
     
        if((!updateCT.isEmpty()) && updateCT!=NULL)
        {
            for(Customer_Transition__c eachLockCT : updateCT)
            {
                if(eachLockCT.Administrative_Close__c)
                 {
                 eachLockCT.status__c='Administrative Close';
                 updatedCT.add(eachLockCT);
                 }
            }
        }
     }*/
    
    //take all records below in hierarchy where QTD_Sales_TY__c  <=0  or null for Customer Lost
     if((!customerLostCTids.isEmpty()) && customerLostCTids!=NULL)
     {
     CT_OnDeck_WRF_cls.getCustLostHeir(customerLostCTids);
     lockCT =  new Set<ID>(CT_OnDeck_WRF_cls.childCTtoMappedCT.keySet());
     updateCTCustLost = [select id,Customer_Loss__c,Administrative_Close__c,Customer_Transition_Date_to_OD_Systems__c,status__c,Compliance_Life_Cycle_Reviewed_Person__c,Compliance_Life_Cycle_Reviewed__c from Customer_Transition__c where id in :lockCT or id in :customerLostCTids];
     }
     
     

        //Populating Compliance_Life_Cycle_Reviewed__c & Compliance_Life_Cycle_Reviewed_Person__c for CT records having Customer_Loss__c checked
        if((!updateCTCustLost.isEmpty()) && updateCTCustLost!=NULL)
        {
        for(Customer_Transition__c eachLockCT : updateCTCustLost)
            {
                 eachLockCT.Customer_Loss__c=true;
                 eachLockCT.Customer_Transition_Date_to_OD_Systems__c=closeDate.get(CT_OnDeck_WRF_cls.childCTtoMappedCT.get(eachLockCT.Id));
                 eachLockCT.status__c='Loss of Customer';
                 eachLockCT.Compliance_Life_Cycle_Reviewed__c = System.today();
                 eachLockCT.Compliance_Life_Cycle_Reviewed_Person__c = UserInfo.getName() ;
                 updatedCT.add(eachLockCT);
            }
        }
        try 
        {   //Updating Complete Customer List Heir and Administrative Close Records
            if((!updatedCT.isEmpty()) && updatedCT!=NULL)
            {
                update updatedCT;
            }
        
        //Locking CT records having Customer_Loss__c checked
        List<Approval.ProcessSubmitRequest> lstprocess=new List<Approval.ProcessSubmitRequest>();
        for(Customer_Transition__c eachLockCT : updateCTCustLost)
            {
                //Lock the record for editing
                  Approval.ProcessSubmitRequest appReq = new Approval.ProcessSubmitRequest();
                  appReq.setComments('Automatic record lock.');
                  appReq.setObjectId(eachLockCT.id);
                // Submit the approval request for the account
                  //Approval.ProcessResult proResult = Approval.process(appReq);
                  lstprocess.add(appReq);
            }
            List<Approval.ProcessResult> resultlist = Approval.process(lstprocess);
        }   
        catch(Exception e)
        {
            for(Customer_Transition__c CTs : Trigger.new) 
            {
            CTs.addError('Record cannot be saved due to exception in hierarchy.');
            }
        }
    }
       
    
}