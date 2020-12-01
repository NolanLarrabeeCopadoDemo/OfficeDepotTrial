/*
 * Copyright (c) 2018 by PROS, Inc.  All Rights Reserved.
 * This software is the confidential and proprietary information of
 * PROS, Inc. ("Confidential Information").
 * You may not disclose such Confidential Information, and may only
 * use such Confidential Information in accordance with the terms of
 * the license agreement you entered into with PROS.
 *
 *
 *@author : Romain Derval 
 */
public without sharing class QxCPQQuoteTriggerHandler {

    /**
    * Main method called on a before insert trigger on the CameleonCPQ__QxQuote__c object (PROS Quote)
    */
    public void handleBeforeInsert(List<CameleonCPQ__QxQuote__c > quotes)
    {
        List<Id> accountIds = new List<Id>();
        for(CameleonCPQ__QxQuote__c quote : quotes){
            if(quote.CameleonCPQ__AccountId__c == null && quote.OpportunityId__c ==null){
                quote.addError('Cannot create a quote without a related account or an opportunity.');
            }else{
                //Setup Agreement End Date
                //quote.PROSAgreement__EndDate__c=Date.today().addYears(1);
                if(quote.CameleonCPQ__AccountId__c != null){
                    accountIds.add(quote.CameleonCPQ__AccountId__c);
                }
                
                //Init Account Lookups (not for clones)
                if(quote.Clone_Parent__c == null)
                	QxCPQQuoteHelper.initAccountLookUps(quote);            
                
                //Process initial flagging of quote before insertion
                QxCPQQuoteHelper.checkAndAutoSetPrimaryQuoteFlag(quote);
    
                
                //Assign Case Values
                QxCPQQuoteHelper.assignCaseValues(quote);
                
                //Assign RecortType to Quote
                //Boolean isAmendment = QxCPQQuoteHelper.assignRecordType(quote); 
                
                //If quote is an amendment; assign the appropriate values from active agreement
                //if(isAmendment)
                     //QxCPQQuoteHelper.assignAmendmentValues(quote);
                
                //Assign Quote Region
                QxCPQQuoteHelper.assignQuoteRegion(quote); 
                
                //Compute Contract Terms only (not CPT for no clone quote insert)
                if(quote.Clone_Parent__c == null)
                	QxCPQQuoteHelper.computeContractTerms(quote);
                
                quote.Customer_communication_requirements__c = '';
                
                quote.Go_Live_Date__c=Date.today();
                quote.PROSAgreement__StartDate__c = DateTime.newInstance(Date.today().year() ,Date.today().month() ,Date.today().day(),0,0,0).format('yyyy-MM-dd') ;
                quote.PROSAgreement__EndDate__c = DateTime.newInstance(2999 ,12 ,31).format('yyyy-MM-dd') ;
                quote.Application_Date__c=null;
                    
                //Reset Switch to Fully Approved Flag
                quote.Switch_To_Fully_Approved__c=false;
                quote.Switch_To_Fully_Approved_Prospect__c = false;
    		
            }

        }
        
        //QxCPQQuoteCheckAccess.checkHostedFlag(quotes, accountIds);
        
    }
    
    /**
    * Main method called on a before update trigger on the CameleonCPQ__QxQuote__c object (PROS Quote)
    */
    public void handleBeforeUpdate(List<CameleonCPQ__QxQuote__c> quotesOld, List<CameleonCPQ__QxQuote__c> quotesNew){
        for (CameleonCPQ__QxQuote__c quoteNew : quotesNew) {
            System.debug('TEST Before');
            quoteNew.Deactivate_Validation_Rules__c = true;
            
            for (CameleonCPQ__QxQuote__c quoteOld : quotesOld)
            {
                if(quoteOld.Id==quoteNew.Id){
                    
                    if(quoteOld.CameleonCPQ__AccountId__c != quoteNew.CameleonCPQ__AccountId__c)
                        quoteNew.Core_Name__c = quoteNew.Account_Name__c + ' Core';
                    
                    //Detect & process primary quote flag update
                    QxCPQQuoteHelper.processPrimaryQuoteFlagUpdate(quoteOld,quoteNew);
                        QxCPQQuoteHelper.initAccountLookupUpdate(quoteNew,quoteOld);

                    //Assign Legal Customer Flag
                    if(quoteOld.Is_Written_Agreement__c != quoteNew.Is_Written_Agreement__c)
                    	quoteNew.Amendment_Addendum__c = quoteNew.Is_Written_Agreement__c;
                    
                    //Check for DOA Status Changes
                    QxCPQQuoteHelper.setQuoteStatus(quoteOld,quoteNew);
                   
                    //Populating Approved Quote Look ups
                    if(quoteNew.CameleonCPQ_Approval_AccountId__c == null && quoteNew.CameleonCPQ__Status__c=='Fully Approved'){
                        quoteNew.CameleonCPQ_Approval_AccountId__c =quoteNew.CameleonCPQ__AccountId__c;
                    }else if(quoteNew.CameleonCPQ_Approval_AccountId__c != null && quoteNew.CameleonCPQ__Status__c!='Fully Approved'){
                        quoteNew.CameleonCPQ_Approval_AccountId__c =null;						
                    }
                             
                    //Status Change Process
                    if (quoteNew.CameleonCPQ__Status__c != quoteOld.CameleonCPQ__Status__c){
                        List<CameleonCPQ__QxQuoteLine__c> lineItems = [SELECT Id,Name,Error_Message__c,Pricing_Type__c,Core_Ineligible__c,Sync_Proposed__c FROM CameleonCPQ__QxQuoteLine__c WHERE CameleonCPQ__QuoteId__c =:quoteNew.Id  AND (Core_Ineligible__c='Y' OR Sync_Proposed__c < 0.01) LIMIT 5000];
                        Profile userProfile = [SELECT Id,Name FROm Profile WHERE Id =: UserInfo.getProfileId()];
                        if(lineItems != null && lineItems.size()>0){
                            for(CameleonCPQ__QxQuoteLine__c li : lineItems){
                                //if(li.Error_Message__c != '' && li.Error_Message__c != null){ && (quoteNew.RecordType.Name == 'Default' || userProfile.Name == 'System Administrator' || userProfile.Name == 'QA UAT Testing')){
                                if((li.Pricing_Type__c == 'Core' && li.Core_Ineligible__c=='Y') || li.Sync_Proposed__c < 0.01){
                                	quoteNew.addError('Cannot change status because Quote line has error message :'+li.Name +' has error');
                                }
                            }
                        }
                        if(quoteNew.CameleonCPQ__Status__c=='Accepted' || quoteNew.CameleonCPQ__Status__c=='Fully Approved'){
                            if(quoteNew.CameleonCPQ__SyncStatus__c=='COMPLETE'){

                                if(quoteNew.Go_Live_Date__c == null || quoteNew.Go_Live_Date__c < Date.today())
                                	quoteNew.Go_Live_Date__c=Date.today();
                                //Set Agreement Dates
                                quoteNew.PROSAgreement__StartDate__c = DateTime.newInstance(quoteNew.Go_Live_Date__c.year() ,quoteNew.Go_Live_Date__c.month() ,quoteNew.Go_Live_Date__c.day(),0,0,0).format('yyyy-MM-dd') ;
                                if(quoteNew.PROSAgreement__EndDate__c == null)
                                    quoteNew.PROSAgreement__EndDate__c = DateTime.newInstance(2999 ,12 ,31).format('yyyy-MM-dd') ;
                                quoteNew.Custom_Core_Item_Count_Approved__c = quoteNew.Nb_Of_Items_on_Custom_Core__c;  
                                
                                
                                if (quoteNew.Core_Id__c == null || quoteNew.Core_Id__c == 'NA'){
                                	quoteNew.addError('Custom Core Id being generated, please wait until process is completed before fully approving quote');
                                 }
                                
                                if(quoteNew.Customer_Id__c == null || quoteNew.Customer_Id__c == ''){
                                    quoteNew.addError('Quote account still considered Prospect, please generate Account AOPS Id'); 
                                }                                
                                                                
                                //Set Timestamp when quote is accepted
                                quoteNew.Quote_Accepted_Timestamp__c=DateTime.now();

                                //Publish the quote
                                //quoteNew.PROSAgreement__AgreementStatus__c = 'PendingPublish';

                            }else{
                                quoteNew.addError('Wait until Synchronization is complete, before fully approving the quote');
                            }
                            
                        }else if(quoteNew.CameleonCPQ__Status__c=='Inactive'){
                            //Lock Record if quote becomes Inactive
                            Approval.lock(quoteNew);
                        }else if(quoteOld.CameleonCPQ__Status__c=='Inactive'){
                            //Unlock Record if quote is not Inactive anymore
                            Approval.unlock(quoteNew);
                        }else if(quoteNew.CameleonCPQ__Status__c=='Approved Internally'){
                            //Set Validity Dates
                            quoteNew.Validity_Start__c = Date.Today();
                            quoteNew.Validity_End__c =Date.Today().addDays(90);
                            
							//Set up Quote Approver
                            QxCPQQuoteHelper.setQuoteDOAApprovers(quoteNew);
						}else if (quoteOld.CameleonCPQ__Status__c=='Draft' || quoteNew.CameleonCPQ__Status__c=='Draft'){
							//Any change of status to and From 'Draft' reverts Call Trigger to avoid refresh upon CPQ quote reentry
							quoteNew.Call_Trigger__c = (quoteNew.Call_Trigger__c != null && quoteNew.Call_Trigger__c =='Y') ? 'N' : 'Y';
							
                            //Set/Reset Application Date
                            if(quoteOld.CameleonCPQ__Status__c=='Draft'){
                                quoteNew.Application_Date__c=Date.today();
                            }else{
                                quoteNew.Application_Date__c=null;
                            }
                            QxCPQQuoteHelper.refreshQuoteContext(quoteNew.Id,quoteNew.CameleonCPQ__ExternalQuoteId__c);
						}
                    }
                    else{
                        QxCPQQuoteCheckAccess.checkQuoteStatus(quoteNew);
                    }
                    
                   	//Changing Prospect account to Customer Account ==> Quote status change
                    if((quoteNew.CameleonCPQ__Status__c != quoteOld.CameleonCPQ__Status__c || quoteNew.AOPS_Account_is_valid__c != quoteOld.AOPS_Account_is_valid__c) && quoteNew.AOPS_Account_is_valid__c == true && quoteNew.CameleonCPQ__Status__c =='Awaiting Account ID'){
                        //quoteNew.CameleonCPQ__Status__c = 'Fully Approved';
                        quoteNew.Switch_To_Fully_Approved_Prospect__c = true;
                        
                        //Send Notification Status will shortly change to Sales Rep/Pricing Analyst
                        QxCPQQuoteHelper.sendStatusChangeEmail(quoteNew);
                        
                    }
                    
                    /*if(quoteNew.PricingAnalyst__c != null)
                    QxCPQQuoteCheckAccess.checkPricingAnalyst(quoteNew);*/
                    //Detect successful end of CPQ synchronization process
                    if (quoteNew.CameleonCPQ__SyncStatus__c != quoteOld.CameleonCPQ__SyncStatus__c && quoteNew.CameleonCPQ__SyncStatus__c=='COMPLETE'){
                        //If Quote is synched and status is Draft Call Trigger is switched to refresh RTPE calls upon CPQ Quote reentry
                        if(quoteNew.CameleonCPQ__Status__c=='Draft')
                            quoteNew.Call_Trigger__c = (quoteNew.Call_Trigger__c != null && quoteNew.Call_Trigger__c =='Y') ? 'N' : 'Y';
                        
                        //Retrieve Complete list of compliance violation quote Line items for current quote
                        List<CameleonCPQ__QxQuoteLine__c> compViolationQlis = [SELECT Id,Name,CameleonCPQ__QuoteId__c,Violation_Requirement__c,Violation_Count__c,Violation_Message__c FROM CameleonCPQ__QxQuoteLine__c WHERE CameleonCPQ__QuoteId__c=:quoteNew.Id AND CameleonCPQ__LineTemplateId__c ='ComplianceViolationLT'];
                        
                        //Retrieve Complete list of productquote Line items for current quote
                        //List<CameleonCPQ__QxQuoteLine__c> productQlis = [SELECT Id,Name,CameleonCPQ__QuoteId__c,Change_Increases__c,Change_Decreases__c,Change_Addition__c,Change_Deletion__c,Customer_Comm__c FROM CameleonCPQ__QxQuoteLine__c WHERE CameleonCPQ__QuoteId__c=:quoteNew.Id AND CameleonCPQ__LineTemplateId__c ='ProductLineTemplate'];
                        List<CameleonCPQ__QxQuoteLine__c> productQlis = new List<CameleonCPQ__QxQuoteLine__c>();
                        
                        //Compute Compliance Violation to fill DOA Summary values
                        QxCPQQuoteHelper.processViolationsToDOA(quoteNew,compViolationQlis,productQlis);
                        
                        //Update Customer Comminucation REquirements in Compliance Violation list
                        //QxCPQQuoteHelper.updateComplianceViolationCustomerCommRequirements(quoteNew,compViolationQlis);
                    }
                    
                    //Spreasheet is created (SFDC Quote Creation) & the SFDC quote is not a clone nor an amendment quote
                    if(/*quoteOld.CameleonCPQ__ExternalQuoteId__c==null &&*/ quoteNew.CameleonCPQ__ExternalQuoteId__c!=quoteOld.CameleonCPQ__ExternalQuoteId__c && !quoteNew.PROSAgreement__Quote_Type__c.equalsIgnoreCase('Amendment')) {
                        //Import initial Compliance Violation, Executive Summary and Pricing Construct lines. (for new quotes only)
                        if(quoteNew.Clone_Parent__c == null)
                       		QxCPQImportQuoteData.execute(quoteNew.Id,quoteNew.CameleonCPQ__ExternalQuoteId__c,'CPQ Import Initial','','');   
                        
                        //Compute Contract Terms for current quote
                        QxCPQQuoteHelper.computeContractTerms(quoteNew);  
                        
                    }
                    
                    //If There is a change in account hierarchy, recompute Contract Terms
                    if (quoteNew.Default_Parent__c != quoteOld.Default_Parent__c || quoteNew.Default_Grandparent__c != quoteOld.Default_Grandparent__c || quoteNew.Default_Great_Grandparent__c != quoteOld.Default_Great_Grandparent__c || quoteOld.Contract_Term_Refresh_Trigger__c != quoteNew.Contract_Term_Refresh_Trigger__c){
                        if(quoteNew.CameleonCPQ__SyncStatus__c=='COMPLETE' || quoteNew.CameleonCPQ__SyncStatus__c=='Drafting'){
							//Compute Contract Terms for current quote
							QxCPQQuoteHelper.computeContractTerms(quoteNew);
						}else{
							quoteNew.addError('Please wait until quote synchronization is completed before recomputing contract terms and/or changing account hierarchy. Refresh Page to check on Synchronization Status.');
						}                      
                    }
                    
                    //If There is a modification of the Program hierachy                      
                    if (quoteNew.Default_Parent__c != quoteNew.Parent__c || quoteNew.Default_Grandparent__c != quoteNew.Grandparent__c || quoteNew.Default_Great_Grandparent__c != quoteNew.Great_Grandparent__c){
                        //Flag Program Change
                        quoteNew.DOA_Program_Update__c=true;
                        
                        //Customer Communication Requirements Update
                        if (quoteNew.Documentation_required_to_participate__c == 'Written confirmation' && quoteNew.Customer_communication_requirements__c != 'Notification & Approval' ){
                            quoteNew.Customer_communication_requirements__c = 'Notification & Approval';
                        }
                    }else{
                        quoteNew.DOA_Program_Update__c=false;
                    }
                    
                    //Fill up Date when Price is published
                    if (quoteOld.PROSAgreement__AgreementStatus__c != quoteNew.PROSAgreement__AgreementStatus__c && quoteNew.PROSAgreement__AgreementStatus__c.equalsIgnoreCase('Published')){
                        quoteNew.Published_Date__c=DateTime.now();
                    }
                              
                }

            }
        }
    }
    

    /**
    * Main method called on an after update trigger on the CameleonCPQ__QxQuote__c object (PROS Quote)
    */
    public void handleAfterUpdate(List<CameleonCPQ__QxQuote__c> quotesOld, List<CameleonCPQ__QxQuote__c> quotesNew){
          
        for (CameleonCPQ__QxQuote__c quoteNew : quotesNew) {
            //Init Account Lookups
               if(!System.isFuture() && !System.isBatch())
			QxCPQQuoteHelper.enableValidationRules(quoteNew.Id);
            for (CameleonCPQ__QxQuote__c quoteOld : quotesOld)
            {
                if(quoteOld.Id==quoteNew.Id){
                    
                    //CLone after spreadsheet creation Change Process OR Change of Go-Live_Date OR Publish Failure
                    if ((quoteNew.Clone_Parent__c != null && quoteOld.CameleonCPQ__ExternalQuoteId__c != quoteNew.CameleonCPQ__ExternalQuoteId__c) || (quoteNew.Go_Live_Date__c != quoteOld.Go_Live_Date__c) || (quoteNew.PROSAgreement__AgreementStatus__c != quoteOld.PROSAgreement__AgreementStatus__c &&  quoteNew.PROSAgreement__AgreementStatus__c!=null && quoteNew.PROSAgreement__AgreementStatus__c.containsIgnoreCase('FAIL'))){
                        //Triggger Context refresh for Core ID , DOA Approvers,...
                        if(!Test.isRunningTest())
                        	QxCPQQuoteHelper.refreshQuote(quoteNew.Id,quoteNew.CameleonCPQ__ExternalQuoteId__c);
                    }
                    //Status Change Process
                    if (quoteNew.CameleonCPQ__Status__c != quoteOld.CameleonCPQ__Status__c){
                       
                        if(quoteNew.CameleonCPQ__Status__c=='Accepted' || quoteNew.CameleonCPQ__Status__c=='Fully Approved' ){
                            //Refresh Quote before publishing & Agreement creation
                            QxCPQQuoteHelper.refreshQuote(quoteNew.Id,quoteNew.CameleonCPQ__ExternalQuoteId__c);
                                                       
                            List<PROS_Agreement__c> activeAgreements = [SELECT Id,Name,Quote__r.CameleonCPQ__AccountId__c,Active__c FROM PROS_Agreement__c WHERE Active__c = true AND Quote__r.CameleonCPQ__AccountId__c =: quoteNew.CameleonCPQ__AccountId__c];
                            update activeAgreements;
                            //Create Agreement Object if not created already
                            if(quoteNew.Agreement_Count__c<=0 && activeAgreements.size()<=0){
                                QxCPQQuoteHelper.createAgreementObject(quoteNew, true);
                            }else if(quoteNew.Agreement_Count__c<=0) {
                                QxCPQQuoteHelper.createAgreementObject(quoteNew, false);
                            }
                            
                            //Trigger Agreement Publishing
                            List<CameleonCPQ__QxQuote__c> currentQuotes = [SELECT Id,Name,CameleonCPQ__AccountId__r.AOPS_Cust_Id__c,Core_Id__c FROM CameleonCPQ__QxQuote__c WHERE Id=:quoteNew.Id];
                            if (currentQuotes.size()>0 && currentQuotes[0].CameleonCPQ__AccountId__r.AOPS_Cust_Id__c != null && currentQuotes[0].Core_Id__c != null){
                                String profileName=[Select Id,Name from Profile where Id=:userinfo.getProfileId()].Name;
                                system.debug('Current user profile : '+profileName);
                                if(profileName != 'PROSQuoteApproval Profile'){
                                    currentQuotes[0].PROSAgreement__AgreementStatus__c = 'PendingPublish';
                                    update currentQuotes[0];
                                }

                            }
                        }else{
                            //Triggger Context refresh for Core ID , DOA Approvers,...
							if(!Test.isRunningTest())
								QxCPQQuoteHelper.refreshQuoteContext(quoteNew.Id,quoteNew.CameleonCPQ__ExternalQuoteId__c);
                        }
                        
                        if((quoteOld.CameleonCPQ__Status__c == 'Draft')&& 
                           (quoteNew.CameleonCPQ__Status__c=='In Review Internally' || quoteNew.CameleonCPQ__Status__c=='Approved Internally')){
                               QxVFGenerateReportController.generateReport(quoteNew.Id, 'Core Exhibit (Excel)');
                           }
                        if(quoteNew.CameleonCPQ__Status__c=='Approved Internally'){
                            QxVFGenerateReportController.generateReport(quoteNew.Id, 'Customer Copy');
                        }
                    }
                    
                    //Set up OD Agreement Record Type to Agreement contract once created
                    /*if(quoteNew.PROSAgreement__ContractId__c != null && quoteOld.PROSAgreement__ContractId__c == null){
                        QxCPQQuoteHelper.setAgreementContractRecordType(quoteNew.PROSAgreement__ContractId__c);
                    }*/

                    //Detect successful end of CPQ synchronization process; if quote is approved internally and not
                    if(quoteOld.CameleonCPQ__Status__c != quoteNew.CameleonCPQ__Status__c || quoteOld.CameleonCPQ__SyncStatus__c != quoteNew.CameleonCPQ__SyncStatus__c){
                        if (quoteNew.CameleonCPQ__SyncStatus__c=='COMPLETE' && quoteNew.CameleonCPQ__Status__c.containsIgnoreCase('Approved') && (quoteNew.Core_Id__c == null || quoteNew.Core_Id__c == 'NA')){
                            //Generate Core Id if not existing unflag readonly bypass if not 
                            if(quoteNew.CameleonCPQ__AccountId__c != null && quoteNew.Addition_Flag__c==true){
                                //List<CameleonCPQ__QxQuote__c> qts = [SELECT Id,CameleonCPQ__AccountId__c,CameleonCPQ__Status__c,CameleonCPQ__AccountId__r.Custom_Core_Id__c FROM CameleonCPQ__QxQuote__c WHERE Id =: quoteNew.Id];
                                //System.debug('Qts :'+qts);
                                //if(qts != null && qts[0].CameleonCPQ__AccountId__r.Custom_Core_Id__c == null ){
                                    QxCCoreIdCallout.getQueryResults(quoteNew.Id);
                                //}
                            }else{
                                //Use Dummy Core if no products are added to Core and custoemr does not own a Custom core (COmpliance update on customer)
                                List<CameleonCPQ__QxQuote__c> currentQuotes = [SELECT Id,Name,CameleonCPQ__AccountId__r.AOPS_Cust_Id__c,Core_Id__c FROM CameleonCPQ__QxQuote__c WHERE Id=:quoteNew.Id];
                                if (currentQuotes.size()>0){
                                    currentQuotes[0].Core_Id__c = QxCPQQuoteHelper.DUMMY_CORE;
                                    update currentQuotes[0];
                                }
                                
                            }
                        }
                    }
                    
                }
            }
        }
    }


    /**
    * Main method called on a after insert trigger on the CameleonCPQ__QxQuote__c object (PROS Quote)
    */
    public void handleAfterInsert(List<CameleonCPQ__QxQuote__c> quotes){
        //Update Core Id from Account if it exists
		/*System.debug('quotes :'+quotes);
        if(quotes[0].CameleonCPQ__AccountId__c != null){
            List<CameleonCPQ__QxQuote__c> qts = [SELECT Id,CameleonCPQ__AccountId__c,CameleonCPQ__Status__c,CameleonCPQ__AccountId__r.Custom_Core_Id__c FROM CameleonCPQ__QxQuote__c WHERE Id =: quotes[0].Id];
            if(qts[0].CameleonCPQ__AccountId__r.Custom_Core_Id__c != null ){
                System.debug('QTS :'+qts[0].CameleonCPQ__AccountId__r.Custom_Core_Id__c);
                System.debug('QTS :'+qts[0].Id);
                QxCCoreIdCallout.updateCustomCoreId(qts[0].Id);
            }
                
        }*/
    }
    public void handleBeforeDelete(List<CameleonCPQ__QxQuote__c> quotes){
        for(CameleonCPQ__QxQuote__c quote : quotes){
        QxCPQQuoteCheckAccess.checkQuoteStatus(quote);
            
    }
    }
}