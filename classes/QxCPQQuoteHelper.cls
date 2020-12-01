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
public without sharing class QxCPQQuoteHelper {
    public static final String ERROR_MSG_FLAG_WITH_ACCEPTED_PRIMARY_QUOTE = 'You cannot flag a primary quote when another Accepted/Fully Approved primary quote (Pending Publish) exists in the opportunity';
    public static final String ERROR_MSG_UNFLAG_PRIMARY_QUOTE = 'You cannot unflag a primary quote, please flag another quote from the same opportunity as primary quote instead';
    
    public static final String PUBLIC_ACCOUNT_SEGMENT = 'CG;Federal;Higher-Ed;K-12;LG;Local;Non-Profit;SG;State';
    public static final String WEST_REGION_STATES     = 'WA;OR;ID;MT;WY;UT;CO;NV;CA;HI;AK';
    public static final String MIDWEST_REGION_STATES  = 'ND;SD;MN;WI;NE;IA;IL;IN;OH;MI;KS;MO';
    public static final String SOUTHWEST_REGION_STATES= 'AZ;NM;OK;TX';
    public static final String SOUTHEAST_REGION_STATES= 'AR;LA;MS;TN;KY;AL;GA;WV;DC;VA;NC;SC;FL;PR';
    public static final String NORTHEAST_REGION_STATES= 'NY;PA;MD;DE;NJ;CT;RI;MA;NH;ME;VT;AE;AP;BC;MB;ON;VI';
    public static final String REGION_WEST            = 'West';
    public static final String REGION_MIDWEST         = 'MidWest';
    public static final String REGION_SOUTHWEST       = 'SouthWest';
    public static final String REGION_SOUTHEAST       = 'SouthEast';
    public static final String REGION_NORTHEAST       = 'NorthEast';
    
    public static final String DUMMY_CORE             = 'DUMMYCORE';
    
    public static final String RECORDTYPE_CASE_WORKREQUEST = 'Work Request';
    public static final String RECORDTYPE_QUOTE_AMENDMENT_WA = 'Amendment Written Agreement';
    public static final String RECORDTYPE_QUOTE_AMENDMENT_NON_WA = 'Amendment Non Written Agreement';
    public static final String RECORDTYPE_QUOTE_NEW_WA = 'New Written Agreement';
    public static final String RECORDTYPE_QUOTE_NEW_NON_WA = 'New Non Written Agreement';
    
    public static final String DOA_VIOLATION_COUNT_BELOW_FLOOR = 'Business violation: Item priced below Floor';
    public static final String DOA_VIOLATION_CUSTOM_DECREASE_INHERITED = 'Custom decrease on inherited core SKU';
    public static final String DOA_VIOLATION_CUSTOM_INCREASE_INHERITED = 'Custom increase on inherited core SKU';
    public static final String DOA_VIOLATION_FORCED_INHERITANCE = 'Forced inheritance (no custom cores)';
    public static final String DOA_VIOLATION_CUSTOM_NO_MORE_INHERITED = 'Custom core pricing should not be more than inherited core pricing';
    public static final String DOA_VIOLATION_CUSTOM_NO_LESS_INHERITED = 'Custom core pricing should not be less than inherited core pricing';
    public static final String DOA_VIOLATION_COUNT_CUSTOM_CORE = 'Custom core item count (above limit)';
    public static final String DOA_VIOLATION_PRICE_FREEZE_DECREASE= 'Custom decrease - price freeze';
    public static final String DOA_VIOLATION_PRICE_FREEZE_INCREASE= 'Custom increase - price freeze';
    public static final String DOA_VIOLATION_VENDOR_LETTER_REQUIRED = 'Vendor letter required';
    public static final String DOA_VIOLATION_CUSTOMER_COMM_REQ = 'Customer communication requirements';
    
    public static final String DOA_VIOLATION_CUSTOMER_COMM_REQ_MESSAGE = 'Agreement Alert:  Pricing action in this quote requires customer communication.  Customer communication will be completed after all Sales approvals are complete.';
    
    /** PROS CPQ Custom Settings */
    private static final CameleonCPQ__QxSettings__c QX_SETTINGS = CameleonCPQ__QxSettings__c.getInstance();
    
    /*
     * CHeck if initial primary quote flagging is authorized and deactivate other opportunity. Also Flag quote as primary if no opportunity assigned,no other primary quote associated with opportunity
     */
    public static void checkAndAutoSetPrimaryQuoteFlag(CameleonCPQ__QxQuote__c quote){
        if (quote.CameleonCPQ__AccountId__c != null){
            List<CameleonCPQ__QxQuote__c> primaryQuotes =[SELECT Id,Name,Primary_Quote__c,CameleonCPQ__Status__c,PROSAgreement__AgreementStatus__c,Pros_Quote_Owner_Name__c,Quote_Number__c FROM CameleonCPQ__QxQuote__c WHERE CameleonCPQ__AccountId__c=: quote.CameleonCPQ__AccountId__c  AND Primary_Quote__c = TRUE  LIMIT 10];
            if(quote.Primary_Quote__c == false){
                if (primaryQuotes.size() <= 0){
                   // quote.Primary_Quote__c = true;  /* Pavani commented to make it false during clone*/  
                } 
            }else{
 					List<CameleonCPQ__QxQuote__c> otherPrimaryQuotesToUpdate = new  List<CameleonCPQ__QxQuote__c>();
                    for(CameleonCPQ__QxQuote__c otherPrimaryQuote : primaryQuotes)
                    {
						/*try{
							ProcessInstanceWorkitem[] workItems = [
								SELECT Id
								FROM ProcessInstanceWorkitem 
								WHERE ProcessInstance.TargetObjectId = :otherPrimaryQuote.Id
								AND ProcessInstance.Status = 'Pending'];
							//Recall Approval Process if one is pending
							if(workItems.size()>0){
								Approval.ProcessWorkitemRequest pwr = new Approval.ProcessWorkitemRequest();
								pwr.setAction('Removed');
								pwr.setComments('Approval process recalled as quote is no longer primary quote');
								pwr.setWorkItemId(workItems[0].id);
								Approval.ProcessResult result = Approval.process(pwr);
								
								//Set Status to inactive
								if( otherPrimaryQuote.CameleonCPQ__Status__c != 'Draft' ||  otherPrimaryQuote.CameleonCPQ__Status__c != 'Fully Approved')
									otherPrimaryQuote.CameleonCPQ__Status__c = 'Inactive';
							}
							otherPrimaryQuote.Primary_Quote__c = false;
							otherPrimaryQuote.Is_Primary_Quote_Removable__c = true;                            

							otherPrimaryQuotesToUpdate.add(otherPrimaryQuote);
						}catch(Exception e){
							quote.addError('Could not unflag/recall following quote "' + otherPrimaryQuote.Id + '". Please contact quote owner to manually recall it : ' + otherPrimaryQuote.Pros_Quote_Owner_Name__c + '.');
							
						}*/ 
                        ProcessInstanceWorkitem[] workItems = [
                            SELECT Id
                            FROM ProcessInstanceWorkitem 
                            WHERE ProcessInstance.TargetObjectId = :otherPrimaryQuote.Id
                            AND ProcessInstance.Status = 'Pending'];
                        //Recall Approval Process if one is pending
                        if(workItems.size()>0){
                            quote.addError('Could not unflag/recall following quote "' + otherPrimaryQuote.Quote_Number__c + '". Please contact quote owner to manually recall it : ' + otherPrimaryQuote.Pros_Quote_Owner_Name__c + '.');
                        }else{
                            otherPrimaryQuote.Primary_Quote__c = false;
                            otherPrimaryQuote.Is_Primary_Quote_Removable__c = true;                            
                            
                            otherPrimaryQuotesToUpdate.add(otherPrimaryQuote);  
                        }
                    }
                    update otherPrimaryQuotesToUpdate;  
            }
        }else{
            //quote.Primary_Quote__c = true; /* Pavani commented to make it false during clone*/  
        }
    }
    
    /*
     * Detect Primary Quote Flag Update with a quote before and after update and check for authorization, other quotes deflagging
     */
    public static void processPrimaryQuoteFlagUpdate(CameleonCPQ__QxQuote__c quoteOld, CameleonCPQ__QxQuote__c quoteNew){
        if(quoteNew.CameleonCPQ__AccountId__c !=null){
              //Check if Primary Quote Flag was unchecked which is prohibited
            if (quoteOld.Primary_Quote__c == true && quoteNew.Primary_Quote__c ==false && quoteNew.Is_Primary_Quote_Removable__c == false)
            {
                //quoteNew.addError(ERROR_MSG_UNFLAG_PRIMARY_QUOTE);
            }
            else if (quoteOld.Primary_Quote__c == false && quoteNew.Primary_Quote__c ==true){
                //Deflag other quotes from opportunity unless one of those is already Accepted
                List<CameleonCPQ__QxQuote__c> otherPrimaryQuotes = [SELECT Id,Name,Primary_Quote__c,CameleonCPQ__Status__c,PROSAgreement__AgreementStatus__c,Pros_Quote_Owner_Name__c,Quote_Number__c  FROM CameleonCPQ__QxQuote__c WHERE CameleonCPQ__AccountId__c=: quoteNew.CameleonCPQ__AccountId__c  AND Primary_Quote__c = TRUE AND Id !=: quoteNew.Id LIMIT 10];
                if (otherPrimaryQuotes.size() >0) 
                {
                    List<CameleonCPQ__QxQuote__c> otherPrimaryQuotesToUpdate = new  List<CameleonCPQ__QxQuote__c>();
                    for(CameleonCPQ__QxQuote__c otherPrimaryQuote : otherPrimaryQuotes)
                    {
                        /*try{
							ProcessInstanceWorkitem[] workItems = [
								SELECT Id
								FROM ProcessInstanceWorkitem 
								WHERE ProcessInstance.TargetObjectId = :otherPrimaryQuote.Id
								AND ProcessInstance.Status = 'Pending'];
							//Recall Approval Process if one is pending
							if(workItems.size()>0){
								Approval.ProcessWorkitemRequest pwr = new Approval.ProcessWorkitemRequest();
								pwr.setAction('Removed');
								pwr.setComments('Approval process recalled as quote is no longer primary quote');
								pwr.setWorkItemId(workItems[0].id);
								Approval.ProcessResult result = Approval.process(pwr);
								
								//Set Status to inactive
								if( otherPrimaryQuote.CameleonCPQ__Status__c != 'Draft' ||  otherPrimaryQuote.CameleonCPQ__Status__c != 'Fully Approved')
									otherPrimaryQuote.CameleonCPQ__Status__c = 'Inactive';
							}
							otherPrimaryQuote.Primary_Quote__c = false;
							otherPrimaryQuote.Is_Primary_Quote_Removable__c = true;                            

							otherPrimaryQuotesToUpdate.add(otherPrimaryQuote);
						}catch(Exception e){
							quoteNew.addError('Could not unflag/recall following quote "' + otherPrimaryQuote.Name + '". Please contact quote owner to manually recall it : ' + otherPrimaryQuote.Pros_Quote_Owner_Name__c + '.');
							
						}*/
                        ProcessInstanceWorkitem[] workItems = [
                            SELECT Id
                            FROM ProcessInstanceWorkitem 
                            WHERE ProcessInstance.TargetObjectId = :otherPrimaryQuote.Id
                            AND ProcessInstance.Status = 'Pending'];
                        //Recall Approval Process if one is pending
                        if(workItems.size()>0 || otherPrimaryQuote.CameleonCPQ__Status__c == 'In Review Internally (Post-Customer)' || otherPrimaryQuote.CameleonCPQ__Status__c == 'Awaiting Account ID'){
                            quoteNew.addError('Could not unflag/recall following quote "' + otherPrimaryQuote.Quote_Number__c + '". Please contact quote owner to manually recall it : ' + otherPrimaryQuote.Pros_Quote_Owner_Name__c + '.');
                        }else{
                            otherPrimaryQuote.Primary_Quote__c = false;
                            otherPrimaryQuote.Is_Primary_Quote_Removable__c = true;                            
                            
                            otherPrimaryQuotesToUpdate.add(otherPrimaryQuote);  
                        }

                        
                    }
                    update otherPrimaryQuotesToUpdate;
                }       
            }
            quoteNew.Is_Primary_Quote_Removable__c = false;
        }else{
            //Check if Primary Quote Flag was unchecked which is prohibited
            if (quoteOld.Primary_Quote__c == true && quoteNew.Primary_Quote__c ==false && quoteNew.Is_Primary_Quote_Removable__c == false)
            {
                quoteNew.addError(ERROR_MSG_UNFLAG_PRIMARY_QUOTE);
            } 
        }
    }
    
/*
    * Init Quote Account lookups based at of the opportunity
    */ 
    public static void initAccountLookUps(CameleonCPQ__QxQuote__c quote){
        //Retrieve in a map The list of RecordType Id associated to the Developper names of the account recordTypes 
        List<RecordType> accountRecordTypes = [SELECT Id, Name, DeveloperName, NamespacePrefix, Description, BusinessProcessId, SobjectType, IsActive, CreatedById, CreatedDate, LastModifiedById, LastModifiedDate, SystemModstamp from recordtype  where SobjectType ='Account' and developername  in ('Prospect','Customer', 'Parent','GrandParent','Great_Grandparent')];
        Map<String,Id> accountRecordTypeIdByName = new Map<String,Id>();
        for(RecordType rt : accountRecordTypes){
            accountRecordTypeIdByName.put(rt.DeveloperName,rt.Id);
        }
        
        //Retrieve initial account id from the opportunity or directly from lookup if quote cerated from the account
        Id currentAccountId;
        Id currentAccountParentId;
        Boolean isLegalCustomer = false;
        if (quote.OpportunityId__c != null)  {
            Opportunity opp = [SELECT Id,Name,Account.Id,Account.ParentId,Account.Legal_Flag__c FROM Opportunity WHERE Id=: quote.OpportunityId__c];
            currentAccountId = opp.Account.Id;
            List<Account> currentAccs = [Select Id,Name,RecordTypeId,ParentId,Hierarchy__c,Legal_Flag__c FROM Account WHERE id=: currentAccountId];
            if(currentAccs.size()>0)
                quote.Core_Name__c = currentAccs[0].Name + ' Core';
            currentAccountParentId = opp.Account.ParentId;
            if(opp.Account.Legal_Flag__c!=null)
            	isLegalCustomer = opp.Account.Legal_Flag__c.equalsIgnoreCase('Y');
        }else if (quote.CameleonCPQ__AccountId__c!=null){            
            currentAccountId = quote.CameleonCPQ__AccountId__c;
           List<Account> currentAccs = [Select Id,Name,RecordTypeId,ParentId,Hierarchy__c,Legal_Flag__c FROM Account WHERE id=: currentAccountId];
            if(currentAccs.size()>0){
                currentAccountParentId = currentAccs[0].ParentId;
                quote.Core_Name__c = currentAccs[0].Name + ' Core';
                if(currentAccs[0].Legal_Flag__c!=null)
                    isLegalCustomer = currentAccs[0].Legal_Flag__c.equalsIgnoreCase('Y');
            } 
            	
        }
        
        //Assign Legal Customer Flag
        quote.Amendment_Addendum__c = isLegalCustomer;
        
        //Build Accounts lookups based on initial account Id
        if(currentAccountId!=null){
            //Populate Default & Active Account
            quote.Default_Account__c=currentAccountId;
            quote.CameleonCPQ__AccountId__c=currentAccountId;
			
            if(currentAccountParentId  !=null){
                List<Account> parentAccounts = [Select Id,Name,RecordTypeId,ParentId,Hierarchy__c FROM Account WHERE id=: currentAccountParentId AND Hierarchy__c='P'];
				
                //Use Case - Parent is parent Hierarchy - Determine if Parent Exists and populate lookups
                if(parentAccounts.size()>0 && (parentAccounts[0].RecordTypeId == accountRecordTypeIdByName.get('Parent') || parentAccounts[0].RecordTypeId == accountRecordTypeIdByName.get('Customer'))){
                    quote.Default_Parent__c= parentAccounts[0].Id;
                    quote.Parent__c= parentAccounts[0].Id;
                    //Determine if Grand Parent Exists and populate lookups
                    System.debug('1');
                    if(parentAccounts[0].ParentId != null){
                        
                        List<Account> gpAccounts = [Select Id,Name,RecordTypeId,ParentId,Hierarchy__c FROM Account WHERE id=: parentAccounts[0].ParentId AND Hierarchy__c='GP'];
                        System.debug('2 :'+parentAccounts[0].ParentId);
                        if(gpAccounts.size()>0 && gpAccounts[0].RecordTypeId == accountRecordTypeIdByName.get('GrandParent')){
                            quote.Default_Grandparent__c= gpAccounts[0].Id;
                            quote.Grandparent__c= gpAccounts[0].Id;
                            //Determine if Great Grand Parent Exists and populate lookups
                            if(gpAccounts[0].ParentId != null){
                                System.debug('3');
                                List<Account> ggpAccounts = [Select Id,Name,RecordTypeId,ParentId FROM Account WHERE id=: gpAccounts[0].ParentId AND (Hierarchy__c='GGP' OR Hierarchy__c='GP' OR Hierarchy__c='GG')];
                                if(ggpAccounts.size()>0 && ggpAccounts[0].RecordTypeId == accountRecordTypeIdByName.get('Great_Grandparent')){
                                    quote.Default_Great_Grandparent__c= ggpAccounts[0].Id;
                                    quote.Great_Grandparent__c= ggpAccounts[0].Id;
                                }
                            }
                        }
                    }
                    
                }else{				
					List<Account> gpAccounts = [Select Id,Name,RecordTypeId,ParentId,Hierarchy__c FROM Account WHERE id=: currentAccountParentId AND Hierarchy__c='GP'];
                    System.debug('4');
                    //Use Case - Parent is Grand Parent Hierarchy - Look for Grand Parent
                    if(gpAccounts.size()>0 && gpAccounts[0].RecordTypeId == accountRecordTypeIdByName.get('GrandParent')){
                        quote.Default_Grandparent__c= gpAccounts[0].Id;
                        quote.Grandparent__c= gpAccounts[0].Id;
                        //Determine if Great Grand Parent Exists and populate lookups
                        if(gpAccounts[0].ParentId != null){
                            System.debug('5');
                            List<Account> ggpAccounts = [Select Id,Name,RecordTypeId,ParentId FROM Account WHERE id=: gpAccounts[0].ParentId AND (Hierarchy__c='GGP' OR Hierarchy__c='GP' OR Hierarchy__c='GG')];
                            if(ggpAccounts.size()>0 && ggpAccounts[0].RecordTypeId == accountRecordTypeIdByName.get('Great_Grandparent')){
                                quote.Default_Great_Grandparent__c= ggpAccounts[0].Id;
                                quote.Great_Grandparent__c= ggpAccounts[0].Id;
                            }
                        }
                    }else{
                        System.debug('6');
                        List<Account> ggpAccounts = [Select Id,Name,RecordTypeId,ParentId FROM Account WHERE id=: currentAccountParentId AND (Hierarchy__c='GGP' OR Hierarchy__c='GP' OR Hierarchy__c='GG')];
                        
                        //Use Case - Parent is Great Grand Parent Hierarchy - Look for Great Grand Parent
                        if(ggpAccounts.size()>0 && ggpAccounts[0].RecordTypeId == accountRecordTypeIdByName.get('Great_Grandparent')){
                            quote.Default_Great_Grandparent__c= ggpAccounts[0].Id;
                            quote.Great_Grandparent__c= ggpAccounts[0].Id;
                        }
                        
                    }
				}  			
			
			}         
        }   

    }
    
   // @future
    public static void initAccountLookupUpdate(CameleonCPQ__QxQuote__c quote, CameleonCPQ__QxQuote__c quoteOld){
        Boolean activateValidation = true;
        if(quote.CameleonCPQ__AccountId__c != quoteOld.CameleonCPQ__AccountId__c){
            System.debug('Test :'+1);
            initAccountLookUps(quote);
        }
        else if(quote.Default_Account__c != quoteOld.Default_Account__c && quote.Account_Level__c == 'C' ){
            System.debug('Test :'+2);
            quote = changeParentLookup(quote);
        }
        else if(quote.Default_Parent__c != quoteOld.Default_Parent__c && quote.Account_Level__c == 'C'){
            System.debug('Test :'+3);
            quote.Deactivate_Validation_Rules__c = true;
            activateValidation = false;
            quote = changeGPLookup(quote);
        }
        else if(quote.Account_Level__c != 'C'){
            quote.Deactivate_Validation_Rules__c = false;
        }
        
        if(quote.Default_Grandparent__c != quoteOld.Default_Grandparent__c && quote.Account_Level__c == 'P'){
            System.debug('Test :'+5);
            quote.Deactivate_Validation_Rules__c = true;
            activateValidation = false;
            quote = changeGGPLookup(quote);
        }
        else if(quote.Account_Level__c != 'P' && activateValidation){
            quote.Deactivate_Validation_Rules__c = false;
        }
       // quote.Default_Grandparent__c = '';
        	//update quote;
    }
    
    public static CameleonCPQ__QxQuote__c changeParentLookup(CameleonCPQ__QxQuote__c quote){
        List<Account> acc = [SELECT Id,Name,ParentId FROM Account WHERE Id =: quote.Default_Account__c];
        if(acc != null && acc.size()>0 )
        quote.Default_Parent__c = acc[0].ParentId;
        else
         quote.Default_Parent__c = null;   
        quote = changeGPLookup(quote);
        return quote;
    }
    
    public static CameleonCPQ__QxQuote__c changeGPLookup(CameleonCPQ__QxQuote__c quote){

        List<Account> acc = [SELECT Id,Name,ParentId FROM Account WHERE Id =: quote.Default_Parent__c];
        if(acc != null && acc.size()>0 )
        quote.Default_Grandparent__c = acc[0].ParentId;
        else
            quote.Default_Grandparent__c = null;
        quote = changeGGPLookup(quote);
        return quote;
    }
    public static CameleonCPQ__QxQuote__c changeGGPLookup(CameleonCPQ__QxQuote__c quote){
        List<Account> acc = [SELECT Id,Name,ParentId FROM Account WHERE Id =: quote.Default_Grandparent__c];
        if(acc != null && acc.size()>0 )
        quote.Default_Great_Grandparent__c = acc[0].ParentId;
        else
            quote.Default_Great_Grandparent__c = null;
        return quote;
    }
    

    @future
    public static void enableValidationRules(Id qtId){
        List<CameleonCPQ__QxQuote__c> qt = [SELECT Id,Name FROM CameleonCPQ__QxQuote__c WHERE Id =: qtId];
        if(qt != null && qt.size()>0){
            qt[0].Deactivate_Validation_Rules__c = false;
            update qt;
        }
    }
    	/*
	* Assign Region to Quote based on related Account State
	*/
	public static void assignQuoteRegion(CameleonCPQ__QxQuote__c quote){
		if(quote.CameleonCPQ__AccountId__c != null){
			List<Account> accounts = [SELECT Id,Name,State__c,Segment__c FROM Account WHERE id=: quote.CameleonCPQ__AccountId__c];
		
            if(accounts.size()> 0){
                 //Assign State
                 if(accounts[0].State__c != null){
                     String accountState = accounts[0].State__c;
                     if(WEST_REGION_STATES.containsIgnoreCase(accountState)){
                         quote.Region__c=REGION_WEST;
                     }else if(MIDWEST_REGION_STATES.containsIgnoreCase(accountState)){
                         quote.Region__c=REGION_MIDWEST;
                     }else if(SOUTHWEST_REGION_STATES.containsIgnoreCase(accountState)){
                         quote.Region__c=REGION_SOUTHWEST;
                     }else if(SOUTHEAST_REGION_STATES.containsIgnoreCase(accountState)){
                         quote.Region__c=REGION_SOUTHEAST;
                     }else if(NORTHEAST_REGION_STATES.containsIgnoreCase(accountState)){
                         quote.Region__c=REGION_NORTHEAST;
                     }
				}

                //Assign Segment
                /*if(accounts[0].Segment__c != null){
                    if(PUBLIC_ACCOUNT_SEGMENT.containsIgnoreCase(accounts[0].Segment__c)){
                        quote.Segment__c=accounts[0].Segment__c;
                    }else{
                        quote.Segment__c='Private';
                    }
                }*/
                
			}
		}
    }
    /*
     * Assign Region & Segment
     */
    public static void assignCaseValues(CameleonCPQ__QxQuote__c quote){
        Case myCase = null;
        List<Case> oppCases = new List<Case>();
        //Check only 'Work Request' Case RecordType
        Id workRequestCaseRecordType = Schema.SObjectType.Case.getRecordTypeInfosByName().get(RECORDTYPE_CASE_WORKREQUEST).getRecordTypeId();
        //Check quote related opportunity first
        if(quote.OpportunityId__c!=null){
            oppCases = [SELECT  Id,Related_Acct_State__c,ACCT_Business_Segment__c ,WRF_Opportunity__c,AccountId,CDM__c,Sales_Rep_Opportunity_Notes__c FROM Case WHERE WRF_Opportunity__c=:quote.OpportunityId__c AND RecordTypeId=: workRequestCaseRecordType];
        }
        
        if(oppCases.size()>0){
            myCase = oppCases[0];
        }else{
            //Check quote related Account if no Opportunity Case is found ==> No Case if not from Opportunity
            /*if(quote.CameleonCPQ__AccountId__c!=null){
                List<Case> accCases = [SELECT  Id,Related_Acct_State__c,ACCT_Business_Segment__c ,WRF_Opportunity__c,AccountId,CDM__c,Sales_Rep_Opportunity_Notes__c FROM Case WHERE AccountId=:quote.CameleonCPQ__AccountId__c AND RecordTypeId=: workRequestCaseRecordType];
                if(accCases.size()>0){
                    myCase = accCases[0];
                }
            }*/
        }  
        
        
        
        if(myCase!=null){
            //Assign Region by Case State
            /*if(myCase.Related_Acct_State__c != null){
                if(WEST_REGION_STATES.containsIgnoreCase(myCase.Related_Acct_State__c)){
                    quote.Region__c=REGION_WEST;
                }else if(MIDWEST_REGION_STATES.containsIgnoreCase(myCase.Related_Acct_State__c)){
                    quote.Region__c=REGION_MIDWEST;
                }else if(SOUTHWEST_REGION_STATES.containsIgnoreCase(myCase.Related_Acct_State__c)){
                    quote.Region__c=REGION_SOUTHWEST;
                }else if(SOUTHEAST_REGION_STATES.containsIgnoreCase(myCase.Related_Acct_State__c)){
                    quote.Region__c=REGION_SOUTHEAST;
                }else if(NORTHEAST_REGION_STATES.containsIgnoreCase(myCase.Related_Acct_State__c)){
                    quote.Region__c=REGION_NORTHEAST;
                }
            }*/
            
            /*Assign Segment by Case Segment
            if(myCase.ACCT_Business_Segment__c != null){
                if(PUBLIC_ACCOUNT_SEGMENT.containsIgnoreCase(myCase.ACCT_Business_Segment__c)){
                    quote.Segment__c=myCase.ACCT_Business_Segment__c;
                }else{
                    quote.Segment__c='Private';
                }
            }*/
        
            //Assign other values to quote from Case
            quote.CDM__c=myCase.CDM__c;
            quote.Sales_Rep_Opportunity_Notes__c=myCase.Sales_Rep_Opportunity_Notes__c;
        }
        if(quote.CameleonCPQ__AccountId__c!=null){
            //List<DML_Relation__c> dmlList = [SELECT  Id,Name,Account__c,DML_ID__c FROM DML_Relation__c WHERE Account__c=:quote.CameleonCPQ__AccountId__c];
            List<DML_Relation__c> dmlList = [SELECT ID, 
                                             DML_ID__c, 
                                             DML_RepID__c, 
                                             DML_Segment__c, 
                                             DML_Segment_Code__c, 
                                             Decision_Maker_Level_1_Manager_ID__c,
                                             Effective_End_Date__c, 
                                             Effective_Start_Date__c, 
                                             DML__r.Effective_End_Date__c,
                                             DML__r.Effective_Start_Date__c, 
                                             DML__r.Status__c, 
                                             DML__r.DML_Teaming_Sales_ID__c 
                                             FROM DML_Relation__c 
                                             WHERE isdeleted = false 
                                             AND Account__c =:quote.CameleonCPQ__AccountId__c 
                                             AND (Effective_End_Date__c = null OR Effective_End_Date__c >TODAY) 
                                             AND Effective_Start_Date__c<= TODAY 
                                             AND (DML__r.Effective_End_Date__c = null OR DML__r.Effective_End_Date__c >TODAY) 
                                             AND DML__r.Effective_Start_Date__c <= TODAY ];
                                             //AND DML__r.Status__c ='Approved' 
                                            //];
            
            if(dmlList.size()>0)
                quote.DML_Relationship__c= dmlList[0].Id;
        }
        
    }

    /*
     * Proceed With Clone Process before Inserting clone quote
     */
    public static void cloneQuoteProcess(CameleonCPQ__QxQuote__c original, CameleonCPQ__QxQuote__c clone){
        //Pull Contract information
        //checkProfileAccess(clone);
        //QxCPQQuoteHelper.pullAgreementTermsFromContract(clone);

        //Empty Validation Dates & DOA Approval Info
        clone.Validity_End__c=null;
        clone.Validity_Start__c=null;
        clone.DOA_Approval_Status__c = null;
        clone.DOA_Approval_Rejection_Date__c = null;
        clone.Approval_Rejection_Comments__c = '';
        clone.Approved_By_Rejected_By__c = null;
        clone.Compliance_Pre_Approval_Comments__c = '';
        
        //Assign Clone Parent Id
        clone.Clone_Parent__c=original.Id;
        
        clone.Core_Id__c=null;
        
        //Status Reverted to Draft
        clone.CameleonCPQ__Status__c='Draft';
        //Reset Synchronization status
        clone.CameleonCPQ__SyncStatus__c='Drafting';
        
        //Reset Accepted quote TimeStamp
        clone.Quote_Accepted_Timestamp__c=null;
        
        //Reset Customer Approval Info
        clone.Customer_Approval_Status__c=null;
        clone.Customer_Response__c=null;
        clone.Customer_Approval_is_Required__c=false;   
        clone.Customer_Approval_Received_Date__c=null;
        clone.Customer_approval_is_received__c=null;
        clone.Customer_email__c=null;
        clone.Send_Date_for_Customer_Approval__c=null;
        clone.Send_for_Customer_Approval__c=false;
        clone.Send_for_Customer_Notification__c=false;
        
        //Reset Go-Live Date
        clone.Go_Live_Date__c=null;

        
        //Reset Fully approved primary quote
        clone.Fully_approved_primary_quote__c=false;
        
        //Reset Pricing analyst
        clone.PricingAnalyst__c = null;
        
        //Reset New contract Amendment
        clone.New_Contract_Amendment_DOA__c = false;
        
        //Reset Compliance Approval Status
        //clone.Compliance_Approval_Status__c = '';
        
        //Reset B2B Integration Approval Status
        //clone.B2B_Integration_Approval_Status__c = '';
        
        //Reset BSD Integration Approval Status
        //clone.BSD_Pricing_Approval_Status__c = '';
        
        //Reset Date Sent to Control
        clone.Published_Date__c = null;
        
        //Reset Compliance Rejection date
        clone.Compliance_Rejection_date__c = null;
        
        //Reset Sales Owner Info
        clone.SalesOwner_Approved_Rejected_By__c = null;
        clone.SalesOwner_Approval_Rejection_date__c = null;
        clone.SalesOwner_Approval_Rejection_Comments__c	= null;
        clone.Sales_Rep_Opportunity_Notes__c = null;

        
        //Reset Pricing Refresh Date
        clone.Pricing_Refresh_Date__c = null;
        
        //Reset Compliance Approval Info
        clone.Compliance_Approval_Rejection_Comments__c = '';
        clone.Compliance_Approval_Status__c = null;
        clone.Compliance_Rejection_date__c	 = null;
        clone.Compliance_Approved_Rejected_By__c	= null;
        clone.Next_Steps__c = '';
       
        //Customer COpy Link
        clone.Customer_Doc_ID__c=null;
        
        //Reset BSD Pricing Approval Rejection Comments
        clone.BSD_Pricing_Approval_Rejection_Comments__c = '';
        clone.BSD_Pricing_Approval_Status__c=null;
        clone.BSD_Pricing_Approval_Rejection_date__c=null;
        clone.BSD_Pricing_Approved_Rejected_By__c=null;
        
        //Reset B2B Integration Approve Reject Comments
        clone.B2B_Integration_Approve_Reject_Comments__c = '';
        clone.B2B_Integration_Approval_Status__c=null;
        clone.B2B_Integration_Approved_Rejected_Date__c=null;
        clone.B2B_Integration_Approved_Rejected_By__c=null;
        
        //Reset Approvers info
        clone.DOA_Approver_L1__c=null;
        clone.DOA_Approver_L2__c=null;
        clone.DOA_Approver_L3__c=null;
        clone.DOA_Approver_L4__c=null;
        clone.DOA_Approver_L5__c=null;
        clone.DOA_Approver_L6__c=null;
        clone.DOA_Approver_L7__c=null;
        clone.DOA_Approver_L8__c=null;
        clone.B2B_Integration_Queue__c=false;
        clone.BSD_Queue__c=false;
        clone.Contract_Queue__c=false;
        clone.Finance_Queue__c=false;
        clone.Compliance__c=false;
        clone.CBFS_Director__c=null;
        clone.CPD_Director__c=null;
        clone.Managing_Director__c=null;
        clone.Senior_Director__c=null;
        clone.CDM_Approver__c=null;
        clone.VP__c=null;
        clone.SVP_OPS__c=null;
        clone.SVP__c=null;
        clone.EVP__c=null;
        clone.CBFS_VP__c=null;
        clone.CFO__c=null;
        
        //Reset Customer Approval Received Date
        clone.Customer_Approval_Received_Date__c = null;
        
        //Reset Contract Pricing Terms Refresh Trigger
        clone.Contract_Term_Refresh_Trigger__c=false;
        
        //Reset BSD Pricing Approval Rejection Date
        clone.BSD_Pricing_Approval_Rejection_date__c = null;
        
        //Reset B2B Integration Approved Rejection Date
        clone.B2B_Integration_Approved_Rejected_Date__c = null;
        
        //Clear Primary Quote Flag
        clone.Primary_Quote__c=false;
        
        //Resetting agreement data
        clone.PROSAgreement__AgreementError__c=null;
        clone.PROSAgreement__AgreementStatus__c='Drafting';
        clone.PROSAgreement__Agreement_Changeset_Id__c=null;
        clone.PROSAgreement__StartDate__c=null;
        clone.PROSAgreement__EndDate__c=null;
        clone.PROSAgreement__ContractId__c=null;
        clone.PROSAgreement__Agreement_Id__c=null;
        
    }

    /*
     * Assign Appropriate RecordType; true true if quote is an amendment, false if not
     *
    public static Boolean assignRecordType(CameleonCPQ__QxQuote__c quote){
        Boolean isAmendment = false;
        if(quote.CameleonCPQ__AccountId__c!=null){
            RecordType quoteRT = [SELECT Id,Name FROM RecordType WHERE Id=: quote.RecordTypeId];
            
            Account myAccount = [SELECT Id,Name,Written_Agreement__c FROM Account WHERE Id=:quote.CameleonCPQ__AccountId__c];
            
            if(myAccount.Written_Agreement__c){
                if(quoteRT.Name.containsIgnoreCase('Amendment')){
                    quote.RecordTypeId = Schema.SObjectType.CameleonCPQ__QxQuote__c.getRecordTypeInfosByName().get(RECORDTYPE_QUOTE_AMENDMENT_WA).getRecordTypeId();
                    isAmendment = true;
                }else{
                    quote.RecordTypeId = Schema.SObjectType.CameleonCPQ__QxQuote__c.getRecordTypeInfosByName().get(RECORDTYPE_QUOTE_NEW_WA).getRecordTypeId();
                }
            }else{
                if(quoteRT.Name.containsIgnoreCase('Amendment')){
                    quote.RecordTypeId = Schema.SObjectType.CameleonCPQ__QxQuote__c.getRecordTypeInfosByName().get(RECORDTYPE_QUOTE_AMENDMENT_NON_WA).getRecordTypeId();
                    isAmendment = true;
                }else{
                    quote.RecordTypeId = Schema.SObjectType.CameleonCPQ__QxQuote__c.getRecordTypeInfosByName().get(RECORDTYPE_QUOTE_NEW_NON_WA).getRecordTypeId();
                }               
            }
            
        }
        return isAmendment;
    }*/
    
    /*
     * Create Quote Agreement Object
     */
    public static void createAgreementObject(CameleonCPQ__QxQuote__c quote, Boolean activeFlag){
        PROS_Agreement__c agreement = new PROS_Agreement__c(Name='Agreement ' + quote.Name,Quote__c=quote.Id);
        
        //Implement each field
        agreement.Active__c = activeFlag;
        agreement.Nb_of_items_allowed_on_the_core__c=quote.Nb_of_items_allowed_on_the_core__c;
        agreement.Agreement_Term__c=quote.Modeled_Agreement_Term__c;
        agreement.CBFS_Price_Cap__c=quote.CBFS_Price_Cap__c;
        agreement.CBFS_Price_Lock_days__c=quote.CBFS_Price_Lock_days__c;
        agreement.Committed_Revenue__c=quote.Committed_Revenue__c;
        agreement.Core_Id__c=quote.Core_Id__c;
        agreement.Core_Name__c=quote.Core_Name__c;
        agreement.Cost_Basis__c=quote.Cost_Basis__c;
        agreement.Cost_Basis_Other__c=quote.Cost_Basis_Other__c;
        agreement.Less_Inherited_Pricing__c=quote.Less_Inherited_Pricing__c;
        agreement.More_Inherited_Pricing__c=quote.More_Inherited_Pricing__c;
        agreement.Customer_communication_requirements__c=quote.Customer_communication_requirements__c;
        agreement.Delivery_Method__c=quote.Delivery_Method__c;
        agreement.Desktop_Delivery_as_a_of_orders__c=quote.Desktop_Delivery_as_a_of_orders__c;
        agreement.Documentation_required_to_participate__c=quote.Documentation_required_to_participate__c;
        agreement.Follower_relationship__c=quote.Follower_relationship__c;
        agreement.Forced_inheritance_no_custom_cores__c=quote.Forced_inheritance_no_custom_cores__c;
        agreement.Hosted__c=quote.Hosted__c;
        agreement.MFN__c=quote.MFN__c;
        agreement.No_customization_on_inherited_core_sku__c=quote.No_customization_on_inherited_core_sku__c;
        agreement.Non_standard_callout_comment_box__c=quote.Non_standard_callout_comment_box__c;
        agreement.Office_Supplies_Price_Cap__c=quote.Office_Supplies_Price_Cap__c;
        agreement.Office_Supplies_Price_Lock_days__c=quote.Office_Supplies_Price_Lock_days__c;
        agreement.Paper_Price_Cap__c=quote.Paper_Price_Cap__c;
        agreement.Paper_Price_Lock_days__c=quote.Paper_Price_Lock_days__c;
        agreement.Payment_Term_Type__c=quote.Payment_Term_Type__c;
        agreement.Proposed_NCC__c=quote.Proposed_NCC__c;
        agreement.Renewal_Options__c=quote.Renewal_Options__c;
        agreement.Out_Clause__c=quote.Out_Clause__c;
        agreement.Toner_Price_Cap__c=quote.Toner_Price_Cap__c;
        agreement.Toner_Price_Lock_days__c=quote.Toner_Price_Lock_days__c;
        agreement.Furniture_Price_Cap__c=quote.Furniture_Price_Cap__c;
        agreement.Furniture_Price_Lock_days__c=quote.Furniture_Price_Lock_days__c;
        agreement.Technology_Price_Cap__c=quote.Technology_Price_Cap__c;
        agreement.Technology_Price_Lock_days__c=quote.Technology_Price_Lock_days__c;
        agreement.CPD_Price_Cap__c=quote.CPD_Price_Cap__c;
        agreement.CPD_Price_Lock_days__c=quote.CPD_Price_Lock_days__c;
        agreement.Small_Order_Fee__c=quote.Small_Order_Fee__c;
        agreement.Minimum_Order_Fee__c=quote.Minimum_Order_Fee__c;
        agreement.Furniture_Delivery_Fee__c=quote.Furniture_Delivery_Fee__c;
        agreement.Desktop_Delivery__c=quote.Is_Desktop_Delivery__c;
        
        agreement.CheckBox_Agreement_Term__c=quote.CheckBox_Agreement_Term__c;
        agreement.CheckBox_Committed_Revenue__c=quote.CheckBox_Committed_Revenue__c;
        agreement.CheckBox_Cost_Basis__c=quote.CheckBox_Cost_Basis__c;
        agreement.CheckBox_Cost_Basis_Other__c=quote.CheckBox_Cost_Basis_Other__c;
        agreement.CheckBox_Customer_comm_requirements__c=quote.CheckBox_Customer_comm_requirements__c;
        agreement.CheckBox_Doc_required_to_participate__c= quote.CheckBox_Doc_required_to_participate__c;
        agreement.CheckBox_Follower_relationship__c= quote.CheckBox_Follower_relationship__c;
        agreement.CheckBox_Forced_inheritance__c= quote.CheckBox_Forced_inheritance__c;
        agreement.CheckBox_Furniture_Delivery_Fee__c= quote.CheckBox_Furniture_Delivery_Fee__c;
        agreement.CheckBox_Is_Desktop_Delivery__c= quote.CheckBox_Is_Desktop_Delivery__c;
        agreement.CheckBox_Less_Inherited_Pricing__c= quote.CheckBox_Less_Inherited_Pricing__c;
        agreement.CheckBox_MFN__c= quote.CheckBox_MFN__c;
        agreement.CheckBox_Minimum_Order_Fee__c= quote.CheckBox_Minimum_Order_Fee__c;
        agreement.CheckBox_More_Inherited_Pricing__c= quote.CheckBox_More_Inherited_Pricing__c;
        agreement.CheckBox_Nb_allowed_on_the_core__c= quote.CheckBox_Nb_allowed_on_the_core__c;
        agreement.CheckBox_No_custom_inherited__c= quote.CheckBox_No_custom_inherited__c;
        agreement.CheckBox_Non_standard_callout__c= quote.CheckBox_Non_standard_callout__c;
        agreement.CheckBox_Out_Clause__c= quote.CheckBox_Out_Clause__c;
        agreement.CheckBox_Payment_Term_Type__c= quote.CheckBox_Payment_Term_Type__c;
        agreement.CheckBox_Renewal_Options__c= quote.CheckBox_Renewal_Options__c;
        agreement.CheckBox_Small_Order_Fee__c= quote.CheckBox_Small_Order_Fee__c;
        
        agreement.Custom_Core_Item_Count_Tier_1__c= quote.Custom_Core_Item_Count_Tier_1__c;
        agreement.Custom_Core_Item_Count_Tier_2__c= quote.Custom_Core_Item_Count_Tier_2__c;
        agreement.Custom_Core_Item_Count_Tier_3__c= quote.Custom_Core_Item_Count_Tier_3__c;
        agreement.Custom_Core_Item_Count_Tier_4__c= quote.Custom_Core_Item_Count_Tier_4__c;
        agreement.Custom_Core_Item_Count_Tier_5__c= quote.Custom_Core_Item_Count_Tier_5__c;
        agreement.Custom_Core_Item_Count_Lower_Bracket_1__c= quote.Custom_Core_Item_Count_Lower_Bracket_1__c;
        agreement.Custom_Core_Item_Count_Upper_Bracket_1__c= quote.Custom_Core_Item_Count_Upper_Bracket_1__c;
        agreement.Custom_Core_Item_Count_Upper_Bracket_2__c= quote.Custom_Core_Item_Count_Upper_Bracket_2__c;
        agreement.Custom_Core_Item_Count_Upper_Bracket_3__c= quote.Custom_Core_Item_Count_Upper_Bracket_3__c;
        agreement.Custom_Core_Item_Count_Upper_Bracket_4__c= quote.Custom_Core_Item_Count_Upper_Bracket_4__c;
        agreement.Custom_Core_Item_Count_Upper_Bracket_5__c= quote.Custom_Core_Item_Count_Upper_Bracket_5__c;
        
        insert agreement;
        
        
        Id rebateLineRT = Schema.SObjectType.CameleonCPQ__QxQuoteLine__c.getRecordTypeInfosByName().get('Rebate').getRecordTypeId();
        Id cptLineRT = Schema.SObjectType.CameleonCPQ__QxQuoteLine__c.getRecordTypeInfosByName().get('CPT').getRecordTypeId();
        
        List<CameleonCPQ__QxQuoteLine__c> quoteLines = [SELECT Id,Name,RecordTypeId,CameleonCPQ__LineTemplateId__c FROM CameleonCPQ__QxQuoteLine__c WHERE CameleonCPQ__QuoteId__c=:quote.Id AND(RecordTypeId=:rebateLineRT OR RecordTypeId=:cptLineRT)];
        for(CameleonCPQ__QxQuoteLine__c quoteLine : quoteLines){
            if(quoteLine.RecordTypeId==cptLineRT){
                quoteLine.CPT_Agreement__c=agreement.Id;
            }else{
                quoteLine.Rebate_Agreement__c=agreement.Id;
            }
        }
        update quoteLines;   
            
    }
    
    public static void computeContractTerms(CameleonCPQ__QxQuote__c quote){
       //Set<String> contractTerms = new Set<String>{''}
       
        //Retrieve all fields for Contract & CPTs records
        final Map<String, Schema.SObjectField> flds = Schema.SObjectType.Contract.fields.getMap();
        final Map<String, Schema.SObjectField> fldsCPT = Schema.SObjectType.Contract_Pricing_Terms__c.fields.getMap();
        final List<String> fieldList = new List<String>();
        final List<String> cptFieldList = new List<String>();
        fieldList.addAll(flds.keySet());
        cptFieldList.addAll(fldsCPT.keySet());
        //Get Contracts
        String contractFlds = '';
        for(integer i=0; i<fieldList.size(); i++)
            if (flds.get(fieldList[i]).getDescribe().IsCreateable() || fieldList[i] == 'What_type_of_customer_communication_is_r__c')
            contractFlds = contractFlds + (contractFlds.length()>0?', ':'') + fieldList[i];
        
        Map<Id,String> accountIds =new Map<Id,String>();
        //if(quote.Default_Account__c!=null)
        accountIds.put(quote.Default_Account__c,'account');
        //accountIds.put(quote.Default_Parent__c,'account');
        //accountIds.put(quote.Default_Grandparent__c,'account');
        //accountIds.put(quote.Default_Great_Grandparent__c,'account');
        

        String accountList = '(';
        if(quote.Default_Account__c!=null)
            accountList += '\'' + quote.Default_Account__c + '\',';
        if(quote.Default_Parent__c!=null)
            accountList += '\'' + quote.Default_Parent__c + '\',';
        if(quote.Default_Grandparent__c!=null)
            accountList += '\'' + quote.Default_Grandparent__c + '\',';
        if(quote.Default_Great_Grandparent__c!=null)
            accountList += '\'' + quote.Default_Great_Grandparent__c + '\',';
        accountList = accountList.removeEnd(',');
        accountList += ')';
        
        //final String qry = 'SELECT '+contractFlds+' FROM Contract where Contract_Status__c=\'Active\' AND (AccountId=\''+quote.Default_Account__c+'\' OR AccountId=\''+quote.Default_Parent__c+'\' OR AccountId=\''+quote.Default_Grandparent__c+ '\' OR AccountId=\''+quote.Default_Great_Grandparent__c +'\' )'; 
        //final String qry = 'SELECT '+contractFlds+',Customer_Number__c,Customer_Name__c,ContractNumber FROM Contract where primary__c=true AND Relevant_Customer_Level__c = ' + relevantCustomerLevel + ' AND AccountId IN ' + accountList ;
         String qry = 'SELECT Contract.Minimum_Annual_Spend_Commitment_Amount__c,Contract.Account_Recordtype__c,'+
            'Contract.Other_cost_basis__c, Contract.Cost_basis__c, Contract.Termination_clause__c,'+
            'Contract.AccountId,Contract.Contract_Term__c, Contract.Contract_Extensions__c,Customer_Number__c,'+
            'Customer_Name__c,ContractNumber,Contract.Desktop_delivery__c,'+
            'Contract.Is_there_a_Most_Favored_Customer_claus__c,Contract.Forced_inheritance_no_custom_cores__c,'+
            'Contract.No_customization_on_inherited_core_sku__c,Contract.Documentation_confirmation_required_to_p__c,'+
            'Contract.Nonstandard_language__c,Contract.Custom_pricing_should_not_be_more_or_les__c, Contract.Payment_Terms__c,'+
            'Contract.Contract_allow_for_dependent_pricing_rel__c, Contract.Contract_state_a_Small_Order_Fee_charge__c,'+
            'Contract.Item_count_threshold_tier_Count1__c,Contract.Item_count_threshold_tier_To1__c, Contract.Item_count_threshold_tier_From1__c,'+
			'Contract.Item_count_threshold_tier_Count2__c,Contract.Item_count_threshold_tier_To2__c, Contract.Item_count_threshold_tier_From2__c,'+
			'Contract.Item_count_threshold_tier_Count3__c,Contract.Item_count_threshold_tier_To3__c, Contract.Item_count_threshold_tier_From3__c,'+
			'Contract.Item_count_threshold_tier_Count4__c,Contract.Item_count_threshold_tier_To4__c, Contract.Item_count_threshold_tier_From4__c,'+
			'Contract.Item_count_threshold_tier_Count5__c,Contract.Item_count_threshold_tier_To5__c, Contract.Item_count_threshold_tier_From5__c,'+
            'Contract.Contract_State_Minimum_Order__c,Contract.Contract_state_a_furniture_delivery_fee__c,Contract.What_type_of_customer_communication_is_r__c,Contract.Participation_requirement__c'+
            ' FROM Contract where primary__c=true AND AccountId IN ' + accountList ;

        if(Test.isRunningTest())
            qry = qry.replace('true','false');
        //Run Contract Query
        SObject[] queryObjects;
        try {
            if(accountList != '()')
            queryObjects = Database.query(qry);    
            System.debug('Account List : ' + queryObjects);
        }
        catch(Exception e) {
            queryObjects = new SObject[0];
             System.debug('Exception Contract retrieval query  : ' + e.getMessage());
        }
        
       Contract currentContract = null;
       Contract existingContract = null;
       Contract activeContract = null;
       Contract activeCPTContract =null;
        
       Contract activeContract_Owned =null;
       Contract activeContract_Parent = null;
       Contract activeContract_GP = null;
       Contract activeContract_GGP = null;
        
	   String agTermOrigin = '';        
       Boolean foundAtParent = false;
       Boolean foundAtGP = false;
       Boolean ownsAgreement = false;
       Boolean inheritsAgreement = false;
       Map<Id,String> contractIds = new  Map<Id,String>();
       Map<Id,String> customerNbs = new  Map<Id,String>();
       Map<Id,String> customerNames = new  Map<Id,String>(); 
       Map<Id,String> contractNbs = new  Map<Id,String>();
       Map<Id,String> contractAccountLevels = new Map<Id,String>();
       for(SObject contractSObject : queryObjects){
           currentContract = (Contract)contractSObject;
           customerNbs.put(currentContract.Id,currentContract.Customer_Number__c);
           customerNames.put(currentContract.Id,currentContract.Customer_Name__c);
           contractNbs.put(currentContract.Id,currentContract.ContractNumber);
           contractAccountLevels.put(currentContract.Id,currentContract.Account_Recordtype__c);
          System.debug('contractSObject : ' + currentContract.AccountId);
           System.debug('Default_Account__c : ' + quote.Default_Account__c);
           System.debug('Default_Parent__c : ' + quote.Default_Parent__c);
           System.debug('Default_Grandparent__c : ' + quote.Default_Grandparent__c);
           System.debug('Default_Great_Grandparent__c : ' + quote.Default_Great_Grandparent__c);
           if(currentContract.AccountId==quote.Default_Account__c){
               //Current Contract is From current account
               activeContract = currentContract; 
               activeContract_Owned = currentContract;
               
               contractIds.put(currentContract.Id,'Child');
               customerNbs.put(currentContract.Id,currentContract.Customer_Number__c);
               customerNames.put(currentContract.Id,currentContract.Customer_Name__c);
               contractNbs.put(currentContract.Id,currentContract.ContractNumber);
               contractAccountLevels.put(currentContract.Id,currentContract.Account_Recordtype__c);
               
               //Specify Quote owns active agreement
               ownsAgreement=true;
               
               break;
           }else if(currentContract.AccountId==quote.Default_Parent__c){
               //Current Contract is From current parent account
               activeContract = currentContract;
               activeContract_Parent = currentContract;
               
               contractIds.put(currentContract.Id,'Parent');
               
               //Specify Quote inherits active agreement
               inheritsAgreement=true;
               
               foundAtParent = true;
           }else if(currentContract.AccountId==quote.Default_Grandparent__c && !foundAtParent){
               //Current Contract is From current grand parent account
               activeContract = currentContract;
               activeContract_GP = currentContract;
               contractIds.put(currentContract.Id,'GP');
               
               //Specify Quote inherits active agreement
               inheritsAgreement=true;
               
               foundAtGP = true;
           }else if(currentContract.AccountId==quote.Default_Great_Grandparent__c && !foundAtParent && !foundAtGP){
               //Current Contract is From current great grand parent account
               activeContract = currentContract;
               activeContract_GGP = currentContract;
               contractIds.put(currentContract.Id,'GGP');
               
               //Specify Quote inherits active agreement
               inheritsAgreement=true;
           }        
           
       }
        quote.Owns_Agreement__c=ownsAgreement;
        quote.Inherits_Agreement__c=inheritsAgreement;

		//Resetting fields
		quote.Modeled_Agreement_Term__c = null;
		quote.Origin_Agreement_Term__c = null;
		quote.Renewal_Options__c= null;
		quote.Origin_Renewal_Options__c= null;
		quote.Out_Clause__c= false;
		quote.Origin_Out_Clause__c= null;
		quote.Cost_Basis__c= null;
		quote.Origin_Cost_Basis__c= null; 
		quote.Cost_Basis_Other__c= null;
		quote.Origin_Cost_Basis_Other__c= null;
		quote.Committed_Revenue__c= null;
		quote.Origin_Committed_Revenue__c= null;
		quote.Existing_Customer_com_requirements__c = null;
		quote.Custom_Core_Item_Count_Tier_1__c = null;
		quote.Custom_Core_Item_Count_Upper_Bracket_1__c = null;
		quote.Custom_Core_Item_Count_Lower_Bracket_1__c = null;
		quote.Origin_CC_Item_Count__c = null;
		quote.Custom_Core_Item_Count_Tier_2__c = null;
		quote.Custom_Core_Item_Count_Upper_Bracket_2__c = null;
		quote.Custom_Core_Item_Count_Tier_3__c = null;
		quote.Custom_Core_Item_Count_Upper_Bracket_3__c = null;
		quote.Custom_Core_Item_Count_Tier_4__c = null;
		quote.Custom_Core_Item_Count_Upper_Bracket_4__c = null;
		quote.Custom_Core_Item_Count_Tier_5__c  = null;
		quote.Custom_Core_Item_Count_Upper_Bracket_5__c = null;
		quote.Is_Desktop_Delivery__c=false;
		quote.Origin_Is_Desktop_Delivery__c = null;
		quote.MFN__c=false;
		quote.Origin_MFN__c=agTermOrigin;
		quote.Forced_inheritance_no_custom_cores__c = false;
		quote.Origin_Forced_inheritance_no_custom_co__c = null;
		quote.No_customization_on_inherited_core_sku__c=false;
		quote.Origin_No_custo_inherited__c = null;
		quote.Origin_Doc_required_to_participate__c = null;
		quote.Documentation_required_to_participate__c = null;
		quote.Non_standard_callout_comment_box__c = null;
		quote.Origin_StandardCallout__c = null;
		quote.Origin_More_Inherited_Pricing__c = null;
		quote.Origin_Less_Inherited_Pricing__c = null;
		quote.Payment_Term_Type__c = null;
		quote.Origin_Payment_Term_Type__c = null;
		quote.Follower_relationship__c = false;
		quote.Origin_Follower_relationship__c = null;
		quote.Small_Order_Fee__c = null;
		quote.Origin_Small_Order_Fee__c = null;
		quote.Minimum_Order_Fee__c = null;
		quote.Origin_Minimum_Order_Fee__c = null;
		quote.Furniture_Delivery_Fee__c = null;
		quote.Origin_Furniture_Delivery_Fee__c = null;        
       
       //Map Contract Term Fields if Active Contract was found
       if(activeContract!=null){
           
           //Set up current Agreement Term origin to active contract
           agTermOrigin = activeContract.Customer_Number__c + ' - ' +  activeContract.Customer_Name__c  + ' - ' + activeContract.ContractNumber;
           
           //Agreement Terms
           quote.Modeled_Agreement_Term__c = activeContract.Contract_Term__c;
           quote.Origin_Agreement_Term__c = agTermOrigin;
           
           //Renewal Options
           quote.Renewal_Options__c=activeContract.Contract_Extensions__c;
           quote.Origin_Renewal_Options__c= agTermOrigin;
           
           //Termination Clause
           quote.Out_Clause__c= activeContract.Termination_Clause__c;
           quote.Origin_Out_Clause__c= agTermOrigin;
           
           //Cost Basis
           quote.Cost_Basis__c=activeContract.Cost_basis__c;
		   quote.Origin_Cost_Basis__c= agTermOrigin;     
           
           //Cost Basis - Other ??
           quote.Cost_Basis_Other__c=activeContract.Other_cost_basis__c;
           quote.Origin_Cost_Basis_Other__c= agTermOrigin;
           
           //Commited Revenue
           if(activeContract.Minimum_Annual_Spend_Commitment_Amount__c != null && activeContract.Minimum_Annual_Spend_Commitment_Amount__c>0){
               quote.Committed_Revenue__c=activeContract.Minimum_Annual_Spend_Commitment_Amount__c;
               quote.Origin_Committed_Revenue__c=agTermOrigin;
           }
               
           //Customer Communication Requirement
			if(activeContract.What_type_of_customer_communication_is_r__c != null){
				if(activeContract.What_type_of_customer_communication_is_r__c.equalsIgnoreCase('Notification and customer approval')){
					quote.Existing_Customer_com_requirements__c = 'Notification & Approval';
				}else if(activeContract.What_type_of_customer_communication_is_r__c.equalsIgnoreCase('Notification only')){
					quote.Existing_Customer_com_requirements__c = 'Notification';
				}else{
					quote.Existing_Customer_com_requirements__c = 'None';
				}
			}
                         
           //Item Count Grid
           //Inherited = Yes -> First inherited "Item count restrictions =  Yes" grid found, Inherited = N -> Bypass, else first found
           currentContract = activeContract;
           if(inheritsAgreement){
               if(activeContract_Parent!=null && activeContract_Parent.Item_count_threshold_tier_From1__c != null){
                   currentContract = activeContract_Parent;
               }else if(activeContract_GP!=null && activeContract_GP.Item_count_threshold_tier_From1__c != null){
                   currentContract = activeContract_GP;
               }else if(activeContract_GGP!=null && activeContract_GGP.Item_count_threshold_tier_From1__c != null){
                   currentContract = activeContract_GGP;
               }
           }
           if (currentContract.Item_count_threshold_tier_From1__c != null && currentContract.Item_count_threshold_tier_From1__c >=0 && currentContract.Item_count_threshold_tier_To1__c!=null && activeContract.Item_count_threshold_tier_To1__c>0 && activeContract.Item_count_threshold_tier_Count1__c!=null && activeContract.Item_count_threshold_tier_Count1__c >0){
               //Tier 1 active & valid
               quote.Custom_Core_Item_Count_Tier_1__c =currentContract.Item_count_threshold_tier_Count1__c;
               quote.Custom_Core_Item_Count_Upper_Bracket_1__c = currentContract.Item_count_threshold_tier_To1__c;
               quote.Custom_Core_Item_Count_Lower_Bracket_1__c = currentContract.Item_count_threshold_tier_From1__c;
               quote.Origin_CC_Item_Count__c= currentContract.Customer_Number__c + ' - ' +  currentContract.Customer_Name__c  + ' - ' + currentContract.ContractNumber;
               if(currentContract.Item_count_threshold_tier_To2__c!=null && currentContract.Item_count_threshold_tier_To2__c>currentContract.Item_count_threshold_tier_To1__c && currentContract.Item_count_threshold_tier_Count2__c!=null && activeContract.Item_count_threshold_tier_Count2__c >0){
                   //Tier 2 active & valid
                   quote.Custom_Core_Item_Count_Tier_2__c =currentContract.Item_count_threshold_tier_Count2__c;
                   quote.Custom_Core_Item_Count_Upper_Bracket_2__c = currentContract.Item_count_threshold_tier_To2__c;
                   if(currentContract.Item_count_threshold_tier_To3__c!=null && currentContract.Item_count_threshold_tier_To3__c>currentContract.Item_count_threshold_tier_To2__c && currentContract.Item_count_threshold_tier_Count3__c!=null && activeContract.Item_count_threshold_tier_Count3__c >0){
                       //Tier 3 active & valid
                       quote.Custom_Core_Item_Count_Tier_3__c =currentContract.Item_count_threshold_tier_Count3__c;
                       quote.Custom_Core_Item_Count_Upper_Bracket_3__c = currentContract.Item_count_threshold_tier_To3__c;
                       if(currentContract.Item_count_threshold_tier_To4__c!=null && currentContract.Item_count_threshold_tier_To4__c>currentContract.Item_count_threshold_tier_To3__c && currentContract.Item_count_threshold_tier_Count4__c!=null && activeContract.Item_count_threshold_tier_Count4__c >0){
                           //Tier 4 active & valid
                           quote.Custom_Core_Item_Count_Tier_4__c =currentContract.Item_count_threshold_tier_Count4__c;
                           quote.Custom_Core_Item_Count_Upper_Bracket_4__c = currentContract.Item_count_threshold_tier_To4__c;
                           if(currentContract.Item_count_threshold_tier_To5__c!=null && currentContract.Item_count_threshold_tier_To5__c>currentContract.Item_count_threshold_tier_To4__c && currentContract.Item_count_threshold_tier_Count5__c!=null && activeContract.Item_count_threshold_tier_Count5__c >0){
                               //Tier 5 active & valid
                               quote.Custom_Core_Item_Count_Tier_5__c =currentContract.Item_count_threshold_tier_Count5__c;
                               quote.Custom_Core_Item_Count_Upper_Bracket_5__c = currentContract.Item_count_threshold_tier_To5__c;
                           }
                       }
                   }
               }
           }
           
           //Is Desktop Delivery
           quote.Is_Desktop_Delivery__c=false;
          if (activeContract.Desktop_delivery__c != null && activeContract.Desktop_delivery__c.equalsIgnoreCase('Yes')){
               quote.Is_Desktop_Delivery__c=true;
           }
           quote.Origin_Is_Desktop_Delivery__c=agTermOrigin;
           
           
            //Most Favored Customer
           quote.MFN__c=false;
           if(activeContract.Is_there_a_Most_Favored_Customer_claus__c != null && activeContract.Is_there_a_Most_Favored_Customer_claus__c.equalsIgnoreCase('Yes')){
               quote.MFN__c=true;
           }
           quote.Origin_MFN__c=agTermOrigin;
           
           //Forced Inheritance
           quote.Forced_inheritance_no_custom_cores__c=activeContract.Forced_inheritance_no_custom_cores__c;
           quote.Origin_Forced_inheritance_no_custom_co__c=agTermOrigin;
           
           
           //No Customization on inherited SKUs
           //Inherited = Yes -> First inherited "Customization on inherited core sku" value found, Inherited = N ->  Bypass, else first found
           currentContract = activeContract;
           if(inheritsAgreement){
               if(activeContract_Parent!=null && activeContract_Parent.No_customization_on_inherited_core_sku__c != null){
                   currentContract = activeContract_Parent;
               }else if(activeContract_GP!=null && activeContract_GP.No_customization_on_inherited_core_sku__c != null){
                   currentContract = activeContract_GP;
               }else if(activeContract_GGP!=null && activeContract_GGP.No_customization_on_inherited_core_sku__c != null){
                   currentContract = activeContract_GGP;
               }
           }
           quote.No_customization_on_inherited_core_sku__c=false;
           if(currentContract.No_customization_on_inherited_core_sku__c != null && currentContract.No_customization_on_inherited_core_sku__c.equalsIgnoreCase('Yes')){
               quote.No_customization_on_inherited_core_sku__c=true;
           }
           quote.Origin_No_custo_inherited__c = currentContract.Customer_Number__c + ' - ' +  currentContract.Customer_Name__c  + ' - ' + currentContract.ContractNumber;
           
           
           //Document required to participate
           //Inherited = Yes -> First inherited "Documentation/confirmation required to participate in program?" = Yes but take "Participation requirement" value found, Inherited = N ->  Bypass, else first found
           currentContract = activeContract;
           if(inheritsAgreement){
               if(activeContract_Parent!=null && activeContract_Parent.Documentation_confirmation_required_to_p__c != null  && activeContract_Parent.Documentation_confirmation_required_to_p__c.equalsIgnoreCase('Yes')){
                   currentContract = activeContract_Parent;
               }else if(activeContract_GP!=null && activeContract_GP.Documentation_confirmation_required_to_p__c != null  && activeContract_GP.Documentation_confirmation_required_to_p__c.equalsIgnoreCase('Yes')){
                   currentContract = activeContract_GP;
               }else if(activeContract_GGP!=null && activeContract_GGP.Documentation_confirmation_required_to_p__c != null  && activeContract_GGP.Documentation_confirmation_required_to_p__c.equalsIgnoreCase('Yes')){
                   currentContract = activeContract_GGP;
               }
           }  
           if(currentContract!=null && currentContract.Documentation_confirmation_required_to_p__c != null  && currentContract.Documentation_confirmation_required_to_p__c.equalsIgnoreCase('Yes')){
                quote.Documentation_required_to_participate__c=currentContract.Participation_requirement__c;
                quote.Origin_Doc_required_to_participate__c = currentContract.Customer_Number__c + ' - ' +  currentContract.Customer_Name__c  + ' - ' + currentContract.ContractNumber;
           }else{
               quote.Documentation_required_to_participate__c='No requirement';
           }
           
           //Non-Standard Terms
           if(activeContract.Nonstandard_language__c!=null){
               quote.Non_standard_callout_comment_box__c=activeContract.Nonstandard_language__c;
               quote.Origin_StandardCallout__c=agTermOrigin;
           }
           //Custom_pricing_should_not_be_more_or_less than inherited
           //Inherited = Yes -> First inherited "Custom pricing should not be more or less than inherited pricing" value found, Inherited = N ->  Bypass, else first found
           currentContract = activeContract;
           if(inheritsAgreement){
               if(activeContract_Parent!=null && activeContract_Parent.Custom_pricing_should_not_be_more_or_les__c != null){
                   currentContract = activeContract_Parent;
               }else if(activeContract_GP!=null && activeContract_GP.Custom_pricing_should_not_be_more_or_les__c != null){
                   currentContract = activeContract_GP;
               }else if(activeContract_GGP!=null && activeContract_GGP.Custom_pricing_should_not_be_more_or_les__c != null){
                   currentContract = activeContract_GGP;
               }
           }           
           quote.More_Inherited_Pricing__c=false;
           quote.Less_Inherited_Pricing__c=false;
           if(currentContract.Custom_pricing_should_not_be_more_or_les__c != null){
               if(currentContract.Custom_pricing_should_not_be_more_or_les__c.equalsIgnoreCase('Cannot be more')){
                   quote.More_Inherited_Pricing__c=true;
               }else if(currentContract.Custom_pricing_should_not_be_more_or_les__c.equalsIgnoreCase('Cannot be less')){
                   quote.Less_Inherited_Pricing__c=true;
               }
           }
           quote.Origin_More_Inherited_Pricing__c= currentContract.Customer_Number__c + ' - ' +  currentContract.Customer_Name__c  + ' - ' + currentContract.ContractNumber;
           quote.Origin_Less_Inherited_Pricing__c= currentContract.Customer_Number__c + ' - ' +  currentContract.Customer_Name__c  + ' - ' + currentContract.ContractNumber;
           
           //Payment Term Type
           if(activeContract.Payment_Terms__c!=null && activeContract.Payment_Terms__c!='None'){
               quote.Payment_Term_Type__c= activeContract.Payment_Terms__c;
               quote.Origin_Payment_Term_Type__c=agTermOrigin;
           }else{
               //quote.Payment_Term_Type__c= 'Net 20';
           }
           
            //Contract Allows Dependent pricing relationship
           if(activeContract_Owned != null && activeContract_Owned.Contract_allow_for_dependent_pricing_rel__c!=null && !activeContract_Owned.Contract_allow_for_dependent_pricing_rel__c.equalsIgnoreCase('Needs validation')){
               quote.Follower_relationship__c=activeContract_Owned.Contract_allow_for_dependent_pricing_rel__c.containsIgnoreCase('Yes');
           	   quote.Origin_Follower_relationship__c= activeContract_Owned.Customer_Number__c + ' - ' +  activeContract_Owned.Customer_Name__c  + ' - ' + activeContract_Owned.ContractNumber;
           }else if(activeContract_Parent != null && activeContract_Parent.Contract_allow_for_dependent_pricing_rel__c!=null && !activeContract_Parent.Contract_allow_for_dependent_pricing_rel__c.equalsIgnoreCase('Needs validation')){
               quote.Follower_relationship__c=activeContract_Parent.Contract_allow_for_dependent_pricing_rel__c.containsIgnoreCase('Yes');
               quote.Existing_Follower_relationship__c=quote.Follower_relationship__c;
               quote.Origin_Follower_relationship__c= activeContract_Parent.Customer_Number__c + ' - ' +  activeContract_Parent.Customer_Name__c  + ' - ' + activeContract_Parent.ContractNumber;
           }else if(activeContract_GP != null && activeContract_GP.Contract_allow_for_dependent_pricing_rel__c!=null && !activeContract_GP.Contract_allow_for_dependent_pricing_rel__c.equalsIgnoreCase('Needs validation')){
               quote.Follower_relationship__c=activeContract_GP.Contract_allow_for_dependent_pricing_rel__c.containsIgnoreCase('Yes');
               quote.Existing_Follower_relationship__c=quote.Follower_relationship__c;
               quote.Origin_Follower_relationship__c= activeContract_GP.Customer_Number__c + ' - ' +  activeContract_GP.Customer_Name__c  + ' - ' + activeContract_GP.ContractNumber;
           }else if(activeContract_GGP != null && activeContract_GGP.Contract_allow_for_dependent_pricing_rel__c!=null && !activeContract_GGP.Contract_allow_for_dependent_pricing_rel__c.equalsIgnoreCase('Needs validation')){
               quote.Follower_relationship__c=activeContract_GGP.Contract_allow_for_dependent_pricing_rel__c.containsIgnoreCase('Yes');
               quote.Existing_Follower_relationship__c=quote.Follower_relationship__c;
               quote.Origin_Follower_relationship__c= activeContract_GGP.Customer_Number__c + ' - ' +  activeContract_GGP.Customer_Name__c  + ' - ' + activeContract_GGP.ContractNumber;
           }else{
               quote.Follower_relationship__c=false;
               quote.Existing_Follower_relationship__c=quote.Follower_relationship__c;
           }
            
           //Small Order Fee
            if(activeContract.Contract_state_a_Small_Order_Fee_charge__c != null /*&& !activeContract.Contract_state_a_Small_Order_Fee_charge__c.equalsIgnoreCase('Contract Silent')*/){
               quote.Small_Order_Fee__c=activeContract.Contract_state_a_Small_Order_Fee_charge__c;
               quote.Origin_Small_Order_Fee__c=agTermOrigin;
           }else{
               //quote.Small_Order_Fee__c='Yes - Optional';
           }
           
           //Minimum Order Value
           if(activeContract.Contract_State_Minimum_Order__c != null /*&& !activeContract.Contract_State_Minimum_Order__c.equalsIgnoreCase('Contract Silent')*/){
               quote.Minimum_Order_Fee__c=activeContract.Contract_State_Minimum_Order__c;
               quote.Origin_Minimum_Order_Fee__c=agTermOrigin;
           }else{
               //quote.Minimum_Order_Fee__c='Yes - Optional';
           }
           
           //Furniture Delivery Fee
           if(activeContract.Contract_state_a_furniture_delivery_fee__c != null /*&& !activeContract.Contract_state_a_furniture_delivery_fee__c.equalsIgnoreCase('Contract Silent')*/){
               quote.Furniture_Delivery_Fee__c=activeContract.Contract_state_a_furniture_delivery_fee__c;
               quote.Origin_Furniture_Delivery_Fee__c=agTermOrigin;
           }else{
               //quote.Furniture_Delivery_Fee__c='Yes - Compulsory';
           }
           //Handles Existing Contract Terms
           quote.Existing_Agreement_Term__c=quote.Modeled_Agreement_Term__c;
           quote.Existing_Renewal_Options__c=quote.Renewal_Options__c;
           quote.Existing_Cost_Basis__c= quote.Cost_Basis__c;
           quote.Existing_Cost_Basis_Other__c= quote.Cost_Basis_Other__c;
           quote.Existing_Committed_Revenue__c= quote.Committed_Revenue__c;
           quote.Existing_CC_Item_Count_Tier_1__c= quote.Custom_Core_Item_Count_Tier_1__c;
           quote.Existing_CC_Item_Count_Lower_Bracket_1__c= quote.Custom_Core_Item_Count_Lower_Bracket_1__c;
           quote.Existing_CC_Item_Count_Upper_Bracket_1__c= quote.Custom_Core_Item_Count_Upper_Bracket_1__c;
           quote.Existing_CC_Item_Count_Tier_2__c= quote.Custom_Core_Item_Count_Tier_2__c;
           quote.Existing_CC_Item_Count_Upper_Bracket_2__c= quote.Custom_Core_Item_Count_Upper_Bracket_2__c;
           quote.Existing_CC_Item_Count_Tier_3__c= quote.Custom_Core_Item_Count_Tier_3__c;
           quote.Existing_CC_Item_Count_Upper_Bracket_3__c= quote.Custom_Core_Item_Count_Upper_Bracket_3__c;
           quote.Existing_CC_Item_Count_Tier_4__c= quote.Custom_Core_Item_Count_Tier_4__c;
           quote.Existing_CC_Item_Count_Upper_Bracket_4__c= quote.Custom_Core_Item_Count_Upper_Bracket_4__c;
           quote.Existing_CC_Item_Count_Tier_5__c= quote.Custom_Core_Item_Count_Tier_5__c;
           quote.Existing_CC_Item_Count_Upper_Bracket_5__c= quote.Custom_Core_Item_Count_Upper_Bracket_5__c;
           quote.Existing_MFN__c= quote.MFN__c;
           quote.Existing_Forced_inheritance_no_custom_co__c= quote.Forced_inheritance_no_custom_cores__c;
           quote.Existing_No_custo_inherited__c= quote.No_customization_on_inherited_core_sku__c;
           quote.Existing_Doc_required_to_participate__c= quote.Documentation_required_to_participate__c;
           //quote.Existing_StandardCallout= null;
           quote.Existing_More_Inherited_Pricing__c= quote.More_Inherited_Pricing__c;
           quote.Existing_Less_Inherited_Pricing__c= quote.Less_Inherited_Pricing__c;
           quote.Existing_Payment_Term_Type__c= quote.Payment_Term_Type__c;
           quote.Existing_Follower_relationship__c= quote.Follower_relationship__c;
           quote.Existing_Small_Order_Fee__c= quote.Small_Order_Fee__c;
           quote.Existing_Minimum_Order_Fee__c= quote.Minimum_Order_Fee__c;
           quote.Existing_Furniture_Delivery_Fee__c= quote.Furniture_Delivery_Fee__c;
           quote.Existing_Is_Desktop_Delivery__c= quote.Is_Desktop_Delivery__c;
           //quote.Existing_Customer_com_requirements__c=quote.Customer_communication_requirements__c;  
           quote.Existing_Out_Clause__c=quote.Out_Clause__c;
      
       
       }

       //Map CPTs
        if(quote.CameleonCPQ__ExternalQuoteId__c!=null){
            //Get All CPTs accroos all contracts linked to current Account
            // Content Button issue
            Map<String, Schema.SObjectField> fieldMap = Contract_Pricing_Terms__c.sObjectType.getDescribe().fields.getMap();
            String cptFlds = '';
            
                        /* for(integer i=0; i<cptFieldList.size(); i++)
            if (fldsCPT.get(cptFieldList[i]).getDescribe().IsCreateable())
            cptFlds = cptFlds + (cptFlds.length()>0?', ':'') + cptFieldList[i];
            */
            List<String> fieldNames = new List<String>();
            for(String st : fieldMap.keySet()){
                fieldNames.add(st);
            }
            cptFlds = String.join(fieldNames, ',');
            String contractIdsString = String.join(new List<Id>(contractIds.keySet()), '\',\'');
            contractIdsString = '(\'' + contractIdsString + '\')';
            
            
            //Determine CPT Hierarchy
            String relevantCustomerLevel = '';
            if(quote.Account_Level__c != null){
                if(quote.Account_Level__c.equalsIgnoreCase('C')){
                    relevantCustomerLevel = 'Child';
                }else if(quote.Account_Level__c.equalsIgnoreCase('P')){
                    relevantCustomerLevel = 'Parent';
                }else if(quote.Account_Level__c.equalsIgnoreCase('GP')){
                    relevantCustomerLevel = 'Grandparent';
                }else if(quote.Account_Level__c.equalsIgnoreCase('GG')){
                    relevantCustomerLevel = 'GreatGrandParent';
                }
            } 
            relevantCustomerLevel = '\'' + relevantCustomerLevel + '\'';
            
            /*final String cptQry = 'SELECT '+cptFlds+',Account_Level__c,Price_Incr_Cap_Amt__c,Department_Groups__c,'+
'Departments__c,CC_Pricing_Update_Frequency_in_days__c,CC_Prc_Chg_Notice_Reqd_days__c,Comm_Req_CC_Price_Chg__c,'+
'Comm_Req_CC_Price_Chg__c,CameleonCPQ__QxQuote__c.Default_Account__c'+
'  FROM Contract_Pricing_Terms__c where Active__c=true AND Relevant_Customer_Level__c = ' + relevantCustomerLevel + ' AND Contract__c IN ' + contractIdsString; */
            final String cptQry = 'SELECT '+cptFlds+' FROM Contract_Pricing_Terms__c WHERE Active__c=true AND Relevant_Customer_Level__c = ' + relevantCustomerLevel + ' AND Contract__c IN ' + contractIdsString;
            System.debug('CPTs Relevant Customer Level : ' + relevantCustomerLevel);
            System.debug('CPTs Contrat List : ' + contractIdsString);
            //Run CPT Query
            SObject[] queryCPTObjects;
            try {
                queryCPTObjects = Database.query(cptQry);       
            }
            catch(Exception e) {
                System.debug('Error Querying CPTs: ' + e.getMessage());
            }
            
            Contract_Pricing_Terms__c currentCPT = null;
            Map<String,List<Contract_Pricing_Terms__c>> cptMap = new  Map<String,List<Contract_Pricing_Terms__c>>();
            cptMap.put('Child',new List<Contract_Pricing_Terms__c>());
            cptMap.put('Parent',new List<Contract_Pricing_Terms__c>());
            cptMap.put('GP',new List<Contract_Pricing_Terms__c>());
            cptMap.put('GGP',new List<Contract_Pricing_Terms__c>());
            cptMap.put('',new List<Contract_Pricing_Terms__c>());
            Boolean cptAtChildLevel =false;
            Boolean cptAtParentLevel =false;
            Boolean cptAtGPLevel =false;
            Boolean cptAtGGPLevel =false;  
            System.debug('queryCPTObjects :'+queryCPTObjects);
            if(queryCPTObjects != null)
                for(SObject cptSObject : queryCPTObjects){
                    currentCPT = (Contract_Pricing_Terms__c) cptSObject;
                    if(contractIds.get(currentCPT.Contract__c).equalsIgnoreCase('Child')){
                        cptAtChildLevel =true;
                        cptMap.get('Child').add(currentCPT);
                    }else if(contractIds.get(currentCPT.Contract__c).equalsIgnoreCase('Parent')){
                        cptAtParentLevel =true;
                        cptMap.get('Parent').add(currentCPT);
                    }else if(contractIds.get(currentCPT.Contract__c).equalsIgnoreCase('GP')){
                        cptAtGPLevel =true;
                        cptMap.get('GP').add(currentCPT);
                    }else if(contractIds.get(currentCPT.Contract__c).equalsIgnoreCase('GGP')){
                        cptAtGGPLevel =true;
                        cptMap.get('GGP').add(currentCPT);
                    }
                }
            
            //Complete Mapping based on CPT Contract level CHild/Parent/GP/GPP
            String cptLevel = cptAtChildLevel ? 'Child' : cptAtParentLevel ? 'Parent' : cptAtGPLevel ? 'GP' : cptAtGGPLevel ? 'GGP' : '';
            //if(cptLevel != '' && quote.Clone_Parent__c == null && quote.CameleonCPQ__ExternalQuoteId__c!=null)
            if(/*cptLevel != ''  &&*/ !Test.isRunningTest() && quote.CameleonCPQ__ExternalQuoteId__c!=null)
                generateInheritedCPTs(quote, cptMap.get(cptLevel),customerNbs,customerNames,contractAccountLevels,contractNbs);
        
    	}
   }

    public static void generateInheritedCPTs(CameleonCPQ__QxQuote__c quote, List<Contract_Pricing_Terms__c> cpts,Map<Id,String> customerNbs,Map<Id,String> customerNames,Map<Id,String> contractAccountLevels,Map<Id,String> contractNbs){
        
        //Build Deletion JSON
        String jsonDeletionString = QxCPQImportQuoteData.buildJsonFormatDeletion(quote);
        
        //Generate Json Import File for Inherited CPTs
        String jsonString = QxCPQImportQuoteData.buildJsonFormat(cpts,customerNbs,customerNames,contractAccountLevels,contractNbs);

        System.debug('Generating Inherited CPTs...');
        QxCPQImportQuoteData.execute(quote.Id,quote.CameleonCPQ__ExternalQuoteId__c,'CPQ Import Initial',jsonString,jsonDeletionString);  

    }

    public static void processViolationsToDOA(CameleonCPQ__QxQuote__c quote, List<CameleonCPQ__QxQuoteLine__c> compViolationQlis, List<CameleonCPQ__QxQuoteLine__c> productQlis){
        boolean violationCountGreaterThanZero =false;
        String customerCommunication = 'Contract silent';
        // Reset DOA qutoe flags prior to execution of summary process
        quote.DOA_Custom_Price_Decrease_Flag__c=false;
        quote.DOA_Custom_Price_Increase_Flag__c=false;
        quote.DOA_Custom_Price_Less_Inherited_Flag__c=false;
        quote.DOA_Custom_Price_More_Inherited_Flag__c=false;
        quote.DOA_Forced_Inheritance_Flag__c=false;
        quote.DOA_Item_Count_Violation__c=false;
        quote.DOA_Price_Freeze_Violation__c=false;
        quote.DOA_SKU_Below_Floor_Flag__c=false;
        quote.DOA_Vendor_letter_required__c=false;
        quote.DOA_No_custo_on_inherited_core_sku__c=false;
        for (CameleonCPQ__QxQuoteLine__c cvQli : compViolationQlis){
            //Loop through every required, present violation with a violation count >0
            if(cvQli.Violation_Requirement__c !=null && (cvQli.Violation_Requirement__c.equalsIgnoreCase('Yes') || (!cvQli.Violation_Requirement__c.equalsIgnoreCase('No') && !cvQli.Violation_Requirement__c.equalsIgnoreCase('') && !cvQli.Violation_Requirement__c.equalsIgnoreCase('None')))){
               
                //Check COunt of violations
                /*if ( cvQli.Violation_Count__c!=null){
                    violationCountGreaterThanZero =cvQli.Violation_Count__c.isNumeric() && Decimal.ValueOf(cvQli.Violation_Count__c)>0;
                }else{
                    violationCountGreaterThanZero =false;
                }*/
                if ( cvQli.Violation_Count__c!=null ){
                    violationCountGreaterThanZero =cvQli.Violation_Count__c>0;
                }else {
                    violationCountGreaterThanZero =false;  
                }
                //Flag each violation (quote line) at the quote level with DOA flags
                if(cvQli.Name.equalsIgnoreCase(DOA_VIOLATION_COUNT_BELOW_FLOOR) && violationCountGreaterThanZero){
                    quote.DOA_SKU_Below_Floor_Flag__c=true;
                }else if(cvQli.Name.equalsIgnoreCase(DOA_VIOLATION_CUSTOM_DECREASE_INHERITED) && violationCountGreaterThanZero){
                    quote.DOA_Custom_Price_Decrease_Flag__c=true;
                    quote.DOA_No_custo_on_inherited_core_sku__c=true;
                }else if(cvQli.Name.equalsIgnoreCase(DOA_VIOLATION_CUSTOM_INCREASE_INHERITED) && violationCountGreaterThanZero ){
                    quote.DOA_Custom_Price_Increase_Flag__c=true;
                    quote.DOA_No_custo_on_inherited_core_sku__c=true;
                }else if(cvQli.Name.equalsIgnoreCase(DOA_VIOLATION_FORCED_INHERITANCE) && violationCountGreaterThanZero){
                     quote.DOA_Forced_Inheritance_Flag__c=true;
                }else if(cvQli.Name.equalsIgnoreCase(DOA_VIOLATION_CUSTOM_NO_MORE_INHERITED) && violationCountGreaterThanZero){
                    quote.DOA_Custom_Price_More_Inherited_Flag__c=true;
                }else if(cvQli.Name.equalsIgnoreCase(DOA_VIOLATION_CUSTOM_NO_LESS_INHERITED) && violationCountGreaterThanZero){
                    quote.DOA_Custom_Price_Less_Inherited_Flag__c=true;
                }else if(cvQli.Name.equalsIgnoreCase(DOA_VIOLATION_COUNT_CUSTOM_CORE) && violationCountGreaterThanZero){
                    quote.DOA_Item_Count_Violation__c=true;
                }else if(violationCountGreaterThanZero && (cvQli.Name.equalsIgnoreCase(DOA_VIOLATION_PRICE_FREEZE_DECREASE) || cvQli.Name.equalsIgnoreCase(DOA_VIOLATION_PRICE_FREEZE_INCREASE))){
                    quote.DOA_Price_Freeze_Violation__c=true;
                    
                    //Handle 'Initial Freeze Period' price increase customer communication requirement
                    if (cvQli.Name.equalsIgnoreCase(DOA_VIOLATION_PRICE_FREEZE_INCREASE))
                        customerCommunication = 'Notification and customer approval';
                        
                }else if(cvQli.Name.equalsIgnoreCase(DOA_VIOLATION_VENDOR_LETTER_REQUIRED)){
                    quote.DOA_Vendor_letter_required__c=true;
                }
                
            }
        
        	//Check if any products were added/deleted or if they had prices increased or decreased
        	
        }
        Boolean increaseFlag = false;
        Boolean decreaseFlag = false;
        Boolean additionFlag = false;
        Boolean deletionFlag = false;
        for (CameleonCPQ__QxQuoteLine__c prQli : productQlis){
            if(!increaseFlag && prQli.Change_Increases__c>0)
                increaseFlag =true;
            if(!decreaseFlag && prQli.Change_Decreases__c>0)
                decreaseFlag =true;
            if(!additionFlag && prQli.Change_Addition__c>0)
                additionFlag =true;
            if(!deletionFlag && prQli.Change_Deletion__c>0)
                deletionFlag =true;
            if(prQli.Customer_Comm__c!= null){
                if(!customerCommunication.equalsIgnoreCase('Notification and customer approval') && prQli.Customer_Comm__c.equalsIgnoreCase('Notification and customer approval')){
                    customerCommunication = prQli.Customer_Comm__c;
                }else if (!customerCommunication.containsIgnoreCase('Notification') && prQli.Customer_Comm__c.equalsIgnoreCase('Notification only')){
                    customerCommunication = prQli.Customer_Comm__c;
                }   
            }
           
        }
        
        //Handled additionnal Customer Communication requirements
        if (!customerCommunication.equalsIgnoreCase('Notification and customer approval')){
			
			if(quote.DOA_Custom_Price_Increase_Flag__c ==true || //Handle 'No Customization on inherited sku' use case
               quote.DOA_Custom_Price_More_Inherited_Flag__c ==true || //Handle 'Custom core pricing should not be more than inherited core pricing' use case
              (quote.Documentation_required_to_participate__c != null && quote.Documentation_required_to_participate__c.equalsIgnoreCase('Written confirmation')))//Handle 'Documentation required for approval' use case
				customerCommunication = 'Notification and customer approval';
		}
        
        //quote.Customer_communication_requirements__c = customerCommunication;
        //quote.Addition_Flag__c=additionFlag;
        //quote.Deletion_Flag__c=deletionFlag;
        //quote.Increase_Flag__c=increaseFlag;
        //quote.Decrease_Flag__c=decreaseFlag;
        
		//Update Customer Communication REquirements in Compliance Violation list
		/*List<CameleonCPQ__QxQuoteLine__c> ccrQlis = [SELECT Id,Name,CameleonCPQ__QuoteId__c,Violation_Requirement__c,Violation_Count__c,Violation_Message__c FROM CameleonCPQ__QxQuoteLine__c WHERE CameleonCPQ__QuoteId__c=:quote.Id AND CameleonCPQ__LineTemplateId__c ='ComplianceViolationLT' AND Name = 'Customer communication requirements' AND Violation_Requirement__c !=: customerCommunication];

        if(ccrQlis.size()>0){
            ccrQlis[0].Violation_Requirement__c =  customerCommunication;
            if (!customerCommunication.equalsIgnoreCase('Contract Silent'))
                ccrQlis[0].Violation_Message__c = DOA_VIOLATION_CUSTOMER_COMM_REQ_MESSAGE;
            update ccrQlis[0];
        }*/
    }

    public static void assignAmendmentValues(CameleonCPQ__QxQuote__c quote){
        Id accountId = quote.CameleonCPQ__AccountId__c;
        if(accountId != null){
            List<PROS_Agreement__c> activeAgreements = [SELECT Id,Name,Quote__r.CameleonCPQ__AccountId__c FROM PROS_Agreement__c WHERE Quote__r.CameleonCPQ__AccountId__c =: accountId];
            if(activeAgreements.size()>0){
                //List<CameleonCPQ__QxQuote__c> agreementQuotes = [SELECT Id,Name FROM CameleonCPQ__QxQuote__c WHERE Id =: activeAgreements[0].Quote__c];
                
                //if(agreementQuotes.size()>0){
                   /* quote.PROSAgreement__Agreement_Id__c			= agreementQuotes[0].PROSAgreement__Agreement_Id__c;
                    quote.PROSAgreement__Agreement_CRM_Id__c		= agreementQuotes[0].PROSAgreement__Agreement_CRM_Id__c;
                    quote.PROSAgreement__AgreementStatus__c 		= null;
                    quote.PROSAgreement__ContractId__c				= agreementQuotes[0].PROSAgreement__ContractId__c;
                    quote.PROSAgreement__ParentContractId__c		= agreementQuotes[0].PROSAgreement__ContractId__c;
                    quote.PROSAgreement__StartDate__c				= agreementQuotes[0].PROSAgreement__StartDate__c;
                    quote.PROSAgreement__EndDate__c					= agreementQuotes[0].PROSAgreement__EndDate__c;
                    quote.PROSAgreement__PreviousStartDate__c		= agreementQuotes[0].PROSAgreement__StartDate__c;
                    quote.PROSAgreement__PreviousEndDate__c			= agreementQuotes[0].PROSAgreement__EndDate__c;
                    quote.PROSAgreement__PreviousAgreementId__c		= agreementQuotes[0].PROSAgreement__Agreement_Id__c;
                    quote.PROSAgreement__Quote_Type__c				= 'Amendment';
                    quote.PROSAgreement__Agreement_Changeset_Id__c	= agreementQuotes[0].PROSAgreement__Agreement_Changeset_Id__c;*/
                    
                //}
            }
        
        }
    }


    public static void setAgreementContractRecordType(Id contractId){
        List<Contract> contracts = [SELECT Id,Name FROM Contract WHERE Id =: contractId];
        if(contracts.size()>0){
           	contracts[0].RecordTypeId = Schema.SObjectType.Contract.getRecordTypeInfosByName().get('Agreement').getRecordTypeId();
		
            update contracts[0];
        }
    }
    
    public static void setQuoteStatus(CameleonCPQ__QxQuote__c quoteOld,CameleonCPQ__QxQuote__c quoteNew){
        String inReviewInternallyPostCustomer = 'In Review Internally (Post-Customer)';
        //Detect a change in DOA  Status
        if(quoteOld.DOA_Approval_Status__c != quoteNew.DOA_Approval_Status__c || 
          quoteOld.Customer_Approval_Status__c != quoteNew.Customer_Approval_Status__c ||
          quoteOld.Compliance_Approval_Status__c != quoteNew.Compliance_Approval_Status__c ||
          quoteOld.BSD_Pricing_Approval_Status__c != quoteNew.BSD_Pricing_Approval_Status__c ||
          quoteOld.B2B_Integration_Approval_Status__c != quoteNew.B2B_Integration_Approval_Status__c)
        {
              
              if(quoteNew.Customer_Approval_Status__c != null && quoteNew.Customer_Approval_Status__c.equalsIgnoreCase('Rejected')){
				  //Use case for quote to be rejected by customer
                  quoteNew.CameleonCPQ__Status__c = 'Rejected by Customer';
              }else if ((quoteNew.DOA_Approval_Status__c != null && quoteNew.DOA_Approval_Status__c.equalsIgnoreCase('Rejected')) || (quoteNew.Compliance_Approval_Status__c != null && quoteNew.Compliance_Approval_Status__c.equalsIgnoreCase('Rejected')) || (quoteNew.BSD_Pricing_Approval_Status__c != null && quoteNew.BSD_Pricing_Approval_Status__c.equalsIgnoreCase('Rejected')) || (quoteNew.B2B_Integration_Approval_Status__c != null && quoteNew.B2B_Integration_Approval_Status__c.equalsIgnoreCase('Rejected'))){
                  //Use Case for quote to be rejected internally
                  quoteNew.CameleonCPQ__Status__c = 'Rejected Internally';
              }else if (quoteNew.DOA_Approval_Status__c != null && quoteNew.Customer_Approval_Status__c != null && quoteNew.DOA_Approval_Status__c.equalsIgnoreCase('Approved') && quoteNew.Customer_Approval_Status__c.equalsIgnoreCase('Approved')
                        && (quoteNew.Compliance__c == false || (quoteNew.Compliance__c ==  true && quoteNew.Compliance_Approval_Status__c != null && quoteNew.Compliance_Approval_Status__c.equalsIgnoreCase('Approved')))
                        && (quoteNew.B2B_Integration_Queue__c == false || (quoteNew.B2B_Integration_Queue__c ==  true && quoteNew.B2B_Integration_Approval_Status__c != null && quoteNew.B2B_Integration_Approval_Status__c.equalsIgnoreCase('Approved')))
                        && (quoteNew.BSD_Queue__c == false || (quoteNew.BSD_Queue__c ==  true && quoteNew.BSD_Pricing_Approval_Status__c != null && quoteNew.BSD_Pricing_Approval_Status__c.equalsIgnoreCase('Approved')))){
                  if(quoteNew.Customer_Id__c == null || quoteNew.Customer_Id__c == ''){
                      //Use Case when quote is Awaiting Account ID (Prospect Account)
                      quoteNew.CameleonCPQ__Status__c = 'Awaiting Account ID';  
                  //}else if(quoteNew.Customer_Approval_Status__c != quoteOld.Customer_Approval_Status__c){
                      //Customer Approval approved through custom VF page, switch to Fully Approved quote status through workflow to avoid contract creation error
                      //quoteNew.Switch_To_Fully_Approved__c=true;
                      
                      //Send Notification Status will shortly change to Sales Rep/Pricing Analyst
                      //sendStatusChangeEmail(quoteNew);
                      
                  }else{
                      //Use Case when quote is Fully Approved
                      quoteNew.CameleonCPQ__Status__c = 'Fully Approved';    
                  }

			  }else if ((quoteNew.BSD_Pricing_Approval_Status__c != null && quoteNew.BSD_Pricing_Approval_Status__c.equalsIgnoreCase('Submitted')) || (quoteNew.B2B_Integration_Approval_Status__c != null && quoteNew.B2B_Integration_Approval_Status__c.equalsIgnoreCase('Submitted')) || (quoteNew.Compliance_Approval_Status__c != null && quoteNew.Compliance_Approval_Status__c.equalsIgnoreCase('Submitted'))){
				  //Use Case when quote is in Review internally (Post customer)
				  quoteNew.CameleonCPQ__Status__c = inReviewInternallyPostCustomer;
			  }else if (quoteNew.Customer_Approval_Status__c !=null && !quoteOld.CameleonCPQ__Status__c.equalsIgnoreCase(inReviewInternallyPostCustomer) && quoteNew.Customer_Approval_Status__c.equalsIgnoreCase('Approved')){
				  //Use Case when quote is Customer accepted
				  quoteNew.CameleonCPQ__Status__c = 'Accepted by Customer';	
                  //Set up Go-Live Date
                  if(quoteNew.Go_Live_Date__c == null || quoteNew.Go_Live_Date__c < Date.today())
                      quoteNew.Go_Live_Date__c=Date.today();
			  }else if (quoteNew.Customer_Approval_Status__c !=null && !quoteOld.CameleonCPQ__Status__c.equalsIgnoreCase(inReviewInternallyPostCustomer) && quoteNew.Customer_Approval_Status__c.equalsIgnoreCase('Submitted')){
				  //Use Case when quote is presented to customer accepted
				  quoteNew.CameleonCPQ__Status__c = 'Presented to Customer';				  
			  }else if (quoteNew.DOA_Approval_Status__c !=null && !quoteOld.CameleonCPQ__Status__c.equalsIgnoreCase(inReviewInternallyPostCustomer) && quoteNew.DOA_Approval_Status__c.equalsIgnoreCase('Approved')){
				  //Use Case when quote is Approved Internally
				  quoteNew.CameleonCPQ__Status__c = 'Approved Internally';
                  
                  //Set up Go-Live Date
                  if(quoteNew.Go_Live_Date__c == null || quoteNew.Go_Live_Date__c < Date.today())
                      quoteNew.Go_Live_Date__c=Date.today();                  
                  
			  }else if (quoteNew.DOA_Approval_Status__c !=null && !quoteOld.CameleonCPQ__Status__c.equalsIgnoreCase(inReviewInternallyPostCustomer) && quoteNew.DOA_Approval_Status__c.equalsIgnoreCase('Approval Submitted')){
				  //Use Case when quote is In Review Internally
				  quoteNew.CameleonCPQ__Status__c = 'In Review Internally';	
			  }
              
          }
         System.debug('In setQuoteStatus() - Quote Id/Name - ' + quoteNew.Id + ' / ' + quoteNew.Name);
        System.debug('In setQuoteStatus() - Old DOA_Approval_Status__c Status - ' + quoteOld.DOA_Approval_Status__c);
        System.debug('In setQuoteStatus() - Old Customer_Approval_Status__c Status - ' + quoteOld.Customer_Approval_Status__c);
        System.debug('In setQuoteStatus() - Old Compliance_Approval_Status__c Status - ' + quoteOld.Compliance_Approval_Status__c);
        System.debug('In setQuoteStatus() - Old BSD_Pricing_Approval_Status__c Status - ' + quoteOld.BSD_Pricing_Approval_Status__c);
        System.debug('In setQuoteStatus() - Old B2B_Integration_Approval_Status__cStatus - ' + quoteOld.B2B_Integration_Approval_Status__c);
        System.debug('In setQuoteStatus() - Old Status - ' + quoteOld.CameleonCPQ__Status__c);
        System.debug('In setQuoteStatus() - New DOA_Approval_Status__c Status - ' + quoteNew.DOA_Approval_Status__c);
        System.debug('In setQuoteStatus() - New Customer_Approval_Status__c Status - ' + quoteNew.Customer_Approval_Status__c);
        System.debug('In setQuoteStatus() - New Compliance_Approval_Status__c Status - ' + quoteNew.Compliance_Approval_Status__c);
        System.debug('In setQuoteStatus() - New BSD_Pricing_Approval_Status__c Status - ' + quoteNew.BSD_Pricing_Approval_Status__c);
        System.debug('In setQuoteStatus() - New B2B_Integration_Approval_Status__cStatus - ' + quoteNew.B2B_Integration_Approval_Status__c);
        System.debug('In setQuoteStatus() - New Status - ' + quoteNew.CameleonCPQ__Status__c);
    }
    
	public static void setQuoteDOAApprovers(CameleonCPQ__QxQuote__c quote){
		
		List<ProcessInstance> pis = [SELECT Id, Status,ProcessDefinitionId, CreatedDate, CompletedDate, TargetObjectId,
										(SELECT Id, StepStatus, Actor.Name, ElapsedTimeInDays, ElapsedTimeInMinutes,
										 CreatedDate, ProcessNodeId, ProcessNode.Name, Comments
										 FROM StepsAndWorkitems order by CreatedDate) from ProcessInstance WHERE TargetObjectId =: quote.Id ]; //AND Status='Approved'];
		If(pis.size()>0){
            //It displays submitted record approval Status
            Integer i = 0;
            for(ProcessInstanceHistory p:pis[0].StepsAndWorkitems)
            {
                if(p.StepStatus == 'Started' || p.StepStatus == 'Approved'){
                    system.debug('stepName='+p.ProcessNode.Name+'stepStatus='+p.StepStatus+' approver='+p.Actor.Name);
                    i++;
                    Switch on i{
                        when 1 {
                            quote.DOA_Approver_L1__c = p.Actor.Name;
                        }
                        when 2 {
                            quote.DOA_Approver_L2__c = p.Actor.Name;
                        }
                        when 3 {
                            quote.DOA_Approver_L3__c = p.Actor.Name;
                        }
                        when 4 {
                            quote.DOA_Approver_L4__c = p.Actor.Name;
                        }
                        when 5 {
                            quote.DOA_Approver_L5__c = p.Actor.Name;
                        }
                        when 6 {
                            quote.DOA_Approver_L6__c = p.Actor.Name;
                        }
                        when 7 {
                            quote.DOA_Approver_L7__c = p.Actor.Name;
                        }
                        when else {
                            quote.DOA_Approver_L8__c = p.Actor.Name;
                        }
                    }  
                }

            }
		}
	}
    @future (callout=true)  
    public static void refreshQuoteContext(String quoteId, String qxQuoteId){
        //Get Init Session Id
		String sessionid = null;
		final CameleonCPQ.QxApiClient.InitSessionResponse apiResponse1 = CameleonCPQ.QxApiClient.InitSession(new CameleonCPQ.QxApiClient.InitSessionRequest());
        if (apiResponse1.statusCode==200) {
           sessionid = apiResponse1.sessionId;
        }
		System.debug('Refreshing Quote Context...');
        System.debug('Refreshing Quote Context - sessionId : ' + sessionId);
        System.debug('Refreshing Quote Context - crmQuoteId : ' + quoteId);
        System.debug('Refreshing Quote Context - qxQuoteId : '+ qxQuoteId);
		//Generate Qx Session Id
		MyQxSessionContext qxSessionCtx = new MyQxSessionContext();
		qxSessionCtx.sessionId = sessionId;
		qxSessionCtx.crmQuoteId = quoteId;
		qxSessionCtx.qxQuoteId = qxQuoteId;
		
        // Step 2 :Propagate the new quote currency to quote-x
        /*final CameleonCPQ.QxApiClient.SetQuoteFieldRequest apiRequest2 = new CameleonCPQ.QxApiClient.SetQuoteFieldRequest();
        final CameleonCPQ.QxApiClient.QxRequestContext qxReqCtx = new CameleonCPQ.QxApiClient.QxRequestContext();
        qxReqCtx.sessionId = apiResponse1.sessionId;
        qxReqCtx.crmQuoteId = quoteId;
        apiRequest2.qxReqCtx = qxReqCtx;
        apiRequest2.fieldId = 'DOA_Approver_L1';
        StringGridValue curValue = new StringGridValue('Test123');
        final Map<String,Object> inputValue = new Map<String,Object>();
        inputValue.put('inputValue', curValue);
        apiRequest2.requestBody = inputValue;
        
        final CameleonCPQ.QxApiClient.SetQuoteFieldResponse apiResponse2 = CameleonCPQ.QxApiClient.setQuoteField(apiRequest2);
        if (apiResponse2.statusCode >= 400) {
            System.debug('Error occured during currency propagation :'+apiResponse2.qxException);
        }
        waitCommandCompletion(qxReqCtx, apiResponse2.id);*/
        
		String qxSessionCtxStr = JSON.serialize(qxSessionCtx);
		//Cannot use JSON.serialization on MP object, do it ourselves
		//JSONGenerator gen = JSON.createGenerator(false);
        //gen.writeStartObject();
        //gen.writeStringField('sessionId', sessionId);
        //gen.writeStringField('crmQuoteId', quoteId);
        //gen.writeStringField('qxQuoteId', qxQuoteId);
		//gen.writeEndObject();
		//String qxSessionCtxStr = gen.getAsString();
        
		//Call Quote refresh Quote
		CameleonCPQ.QxAuraQuoteProcessController.RefreshContextResponse refreshResponse = CameleonCPQ.QxAuraQuoteProcessController.refreshContext(qxSessionCtxStr, null);
    	System.debug('Refreshing Quote Context - success : '+ refreshResponse.success);
        //if(refreshResponse.success){
            //System.debug('Publishing Quote...');
            //Trigger Agreement Publishing
            /*List<CameleonCPQ__QxQuote__c> currentQuotes = [SELECT Id,Name FROM CameleonCPQ__QxQuote__c WHERE Id=:quoteId];
            if (currentQuotes.size()>0){
                currentQuotes[0].PROSAgreement__AgreementStatus__c = 'PendingPublish';
                update currentQuotes[0];
            }*/
            //System.debug('Publishing Quote Completed');
//}
    }
    
    @future (callout=true)  
    public static void refreshQuote(String quoteId, String qxQuoteId){
        
        // Step 1 :Initialize the quote-x session
		String sessionid = null;
        String authToken = null;
		final CameleonCPQ.QxApiClient.InitSessionResponse apiResponse1 = CameleonCPQ.QxApiClient.InitSession(new CameleonCPQ.QxApiClient.InitSessionRequest());
        if (apiResponse1.statusCode==200) {
            sessionid = apiResponse1.sessionId;
            authToken = apiResponse1.authToken;
        }
        
		System.debug('Refresh & Sync Quote...');
        System.debug('Refresh & Sync - sessionId : ' + sessionId);
        System.debug('Refresh & Sync - crmQuoteId : ' + quoteId);
        System.debug('Refresh & Sync - qxQuoteId : '+ qxQuoteId);
        System.debug('Refresh & Sync - authToken : '+ authToken);
        
        //Build Context Object
        final CameleonCPQ.QxApiClient.QxRequestContext qxReqCtx = new CameleonCPQ.QxApiClient.QxRequestContext();
        qxReqCtx.sessionId = sessionid;
        qxReqCtx.authToken = authToken;
        qxReqCtx.crmQuoteId = quoteId;
        qxReqCtx.qxQuoteId = qxQuoteId;
         
        // Step 2 :Refresh the context
        final CameleonCPQ.QxApiClient.RefreshContextRequest apiRequest2 = new CameleonCPQ.QxApiClient.RefreshContextRequest();
		apiRequest2.qxReqCtx = qxReqCtx;
        final CameleonCPQ.QxApiClient.RefreshContextResponse apiResponse2 = CameleonCPQ.QxApiClient.refreshContext(apiRequest2);
        if (apiResponse2.statusCode>=400) {
            throw new MyException(apiResponse2.qxException);
        }
        
        // Step 3 :Refresh the quote
        final CameleonCPQ.QxApiClient.ExecuteQuoteActionRequest apiRequest3 = new CameleonCPQ.QxApiClient.ExecuteQuoteActionRequest();
        apiRequest3.qxReqCtx = qxReqCtx;
        apiRequest3.actionType = CameleonCPQ.QxApiClient.QuoteActionType.REFRESH;
        apiRequest3.actionName = 'REFRESH_ALL_HIDDEN';
        final CameleonCPQ.QxApiClient.ExecuteQuoteActionResponse apiResponse3 = CameleonCPQ.QxApiClient.executeQuoteAction(apiRequest3);
        if (apiResponse3.statusCode>=400) {
            throw new MyException('Unable to refresh quote',apiResponse3.qxException);
        }

        // Step 4 :Synchronize the quote
        /*final CameleonCPQ.QxApiClient.ExecuteQuoteActionRequest apiRequest4 = new CameleonCPQ.QxApiClient.ExecuteQuoteActionRequest();
        apiRequest4.qxReqCtx = qxReqCtx;
        apiRequest4.actionType = CameleonCPQ.QxApiClient.QuoteActionType.SYNCHRONIZE;
        apiRequest4.actionName = 'SYNCHRO_SFDC';
        final CameleonCPQ.QxApiClient.ExecuteQuoteActionResponse apiResponse4 = CameleonCPQ.QxApiClient.executeQuoteAction(apiRequest4);
        
        if (apiResponse4.statusCode>=400) {
            throw new MyException('Unable to synchronize the quote',apiResponse4.qxException);
        }*/
    }
    
    public class MyException extends Exception {}
    
    public class MyQxSessionContext {
    
        /** The session identifier */
        public String sessionId { get; set; }
    
        /** The last quote-x operation identifier */
        public String lastOperationId { get; set; }
    
        /** The CRM quote object identifier */
        public String crmQuoteId { get; set; }
    
        /** The quote-x quote identifier */
        public String qxQuoteId { get; set; }
    
        /** The CPQx quote model identifier */
        public String qxModelId { get; set; }
    

        /** The data locale */
        public String locale { get; set; }
        
    
    }
    
        /**
     * Wait until the change currency command return ready or error status.
     * @param qxReqCtx The request context.
     * @param correlationId  The correlation identifier of the command.
     * @throws CurrencyPropagationException If the currency command is in error or has timed out.
     */
    public static boolean waitCommandCompletion(CameleonCPQ.QxApiClient.QxRequestContext qxReqCtx, String correlationId) {

        Integer retries = 0;
        final CameleonCPQ.QxApiClient.GetCommandStatusRequest apiRequest = new CameleonCPQ.QxApiClient.GetCommandStatusRequest();
        apiRequest.qxReqCtx = qxReqCtx;
        apiRequest.correlationId = correlationId;

        while (retries++ < 15) {
           final CameleonCPQ.QxApiClient.GetCommandStatusResponse apiResponse = CameleonCPQ.QxApiClient.getCommandStatus(apiRequest);
           if (apiResponse.statusCode==200) {
             if(CameleonCPQ.QxApiClient.CommandStatus.Ready.name().equalsIgnoreCase(apiResponse.status)) {
                return true;
             }
             else if(CameleonCPQ.QxApiClient.CommandStatus.Failed.name().equalsIgnoreCase(apiResponse.status)) {
                System.debug('Error occured during currency propagation :'+apiResponse.errorMessage);
             }
               final Long delayStart = System.now().getTime();
               while (System.now().getTime() < delayStart + 3000) {}
             System.debug('Waiting for command completion...('+retries+')');
           }
           else {
               return false;
           }    
        }
        return false;

    }

        /**
     * A CPQx Public API Grid String Value.
     *
     * @author dev_sfdc
     */ 
    public class StringGridValue extends GridValue
    {
        /** The value */
        public String value {public get; private set;}

        /** 
         * Constructor.
         *
         * @param value The value.
         */        
        public StringGridValue(String value)
        {
            this.valueType = 'String';
            this.value = value;
        }
    }
    
        /**
     * A CPQx Public API Grid Value.
     *
     * @author dev_sfdc
     */ 
    public abstract class GridValue
    {
        /** The value type (String, BigDecimal, Boolean, Business, Currency, DateTime, Integer, Json, LocalDate, Locale, Long, Monetary, Multiple, Percentage, UnitOfMeasure, Xml) */
        public String valueType {public get; private set;}
    }

    public static void sendStatusChangeEmail(CameleonCPQ__QxQuote__c quoteNew){
        
        // First, reserve email capacity for the current Apex transaction to ensure
        // that we won't exceed our daily email limits when sending email after
        // the current transaction is committed.
        Messaging.reserveSingleEmailCapacity(2);
        
        // Processes and actions involved in the Apex transaction occur next,
        // which conclude with sending a single email.
        
        // Now create a new single email message object
        // that will send out a single email to the addresses in the To, CC & BCC list.
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        
        // Strings to hold the email addresses to which you are sending the email.
        String[] toAddresses = new String[] {}; 
            Set<Id> userIds = new Set<Id>();
        userIds.add(quoteNew.Sales_Rep__c);
        userIds.add(quoteNew.PricingAnalyst__c);
        
        List<User> emailUsers = [SELECT Id,Name,Email FROM User WHERE Id IN: userIds];
        for(User us : emailUsers){
            if(us.Email != null)
                toAddresses.add(us.Email);
        }
        
        
        if(toAddresses.size()>0){
            // Assign the addresses for the To and CC lists to the mail object.
            mail.setToAddresses(toAddresses);
            
            // Specify the address used when the recipients reply to the email. 
            mail.setReplyTo('support@salesforce.com');
            
            // Specify the name used as the display name.
            mail.setSenderDisplayName('Salesforce Support');
            
            // Specify the subject line for your email address.
            mail.setSubject('Following quote in process to be fully approved : ' + quoteNew.Quote_Number__c + ' - ' + quoteNew.Name);
            
            // Set to True if you want to BCC yourself on the email.
            mail.setBccSender(false);
            
            // Optionally append the salesforce.com email signature to the email.
            // The email address of the user executing the Apex Code will be used.
            mail.setUseSignature(false);
            
            // Specify the text content of the email.
            mail.setPlainTextBody('Your quote ' + quoteNew.Quote_Number__c + ' - ' + quoteNew.Name + ' has entered a process to be automatically Fully Approved. Quote status would be changed shortly (Process takes around 25hrs if account was a prospect)');
            
            
            // Send the email you have created.
            Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
        }
    }


    /**
     * 
    Build Json format for Quote Line import
    */
    public static string buildJsonFormat(List<Contract_Pricing_Terms__c> cpts,Map<Id,String> customerNbs,Map<Id,String> customerNames,Map<Id,String> contractAccountLevels,Map<Id,String> contractNbs){
        String jsonReturn = '';
        
        JSONGenerator jsonGen = JSON.createGenerator(true);
        //Start writting Json Object
        jsonGen.writeStartObject();
        
        /***Generation Definition****/
        jsonGen.writeFieldName('definition');
        
        //Build ColumnDefinitions
        buildJsonColumnDefinitions(jsonGen);
 
        /***Fields Values****/
        jsonGen.writeFieldName('fields');
        jsonGen.writeStartObject();
        jsonGen.writeEndObject();
        
        /***UserInput Fields Values****/
        jsonGen.writeFieldName('userInputfields');
        jsonGen.writeStartObject();
        jsonGen.writeEndObject();
        
        /***Row Values****/
        jsonGen.writeFieldName('rows');
        
        //Define all rows to be imported in a Json Array
        jsonGen.writeStartArray();
        
        //Loop through all CPT line item to write them into Json Import
        Integer count  = 0;
        For(Contract_Pricing_Terms__c cpt : cpts){
            //Import CPT at the Department Group level
            count++;
            buildJsonRowValues_InheritedPerDeptGrp(jsonGen, count, cpt,customerNbs,customerNames,contractAccountLevels,contractNbs);
            
            //Import as well CPT lines at the department level
            List<Map<String,Object>> deptLevelCpts = expandCPTAtDeptLevel(cpt);
            
            for(Map<String,Object> deptLevelCpt : deptLevelCpts){
                count++;
                buildJsonRowValues_InheritedPerDept(jsonGen, count, deptLevelCpt,customerNbs,customerNames,contractAccountLevels,contractNbs);
            }
        }
        //buildJsonRowValues(jsonGen, 1, null);
        
        jsonGen.writeEndArray();
        //END : Row Array
        
        jsonGen.writeEndObject();
        //END  : Json Object
        
        jsonReturn = jsonGen.getAsString();
        System.debug('FINAL JSON : ' + jsonReturn);
        
        //Close JsonGenerator instance
        jsonGen.close();
        
        return jsonReturn;        
    }
    
    public static void buildJsonColumnDefinitions(JSONGenerator jsonGen){
        
        jsonGen.writeStartObject();
        // 1 - columnDefinitions
        jsonGen.writeFieldName('columnDefinitions');
        
        //Define all columns to be imported in a Json Array
        jsonGen.writeStartArray();
        
        //Name
        jsonGen.writeStartObject();
        jsonGen.writeStringField('id', '_SYS_ROW_ITEM');
        jsonGen.writeStringField('translation', 'Name'); 
        jsonGen.writeStringField('type', 'BUSINESS'); 
        jsonGen.writeBooleanField('multiple', false); 
        jsonGen.writeBooleanField('computed', false);
        jsonGen.writeBooleanField('userInput', true);
        jsonGen.writeEndObject();
        
        //Row Type
        jsonGen.writeStartObject();
        jsonGen.writeStringField('id', '_SYS_ROW_TYPE');
        jsonGen.writeStringField('translation', 'Row type'); 
        jsonGen.writeStringField('type', 'STRING'); 
        jsonGen.writeBooleanField('multiple', false); 
        jsonGen.writeBooleanField('computed', false);
        jsonGen.writeBooleanField('userInput', true);
        jsonGen.writeEndObject();
        
        //Row Template
        jsonGen.writeStartObject();
        jsonGen.writeStringField('id', '_SYS_ROW_TEMPLATE');
        jsonGen.writeStringField('translation', 'Row template'); 
        jsonGen.writeStringField('type', 'STRING'); 
        jsonGen.writeBooleanField('multiple', false); 
        jsonGen.writeBooleanField('computed', false);
        jsonGen.writeBooleanField('userInput', true);
        jsonGen.writeEndObject();
        
        
        //Comp_Effective_date_of_this_language
        jsonGen.writeStartObject();
        jsonGen.writeStringField('id', 'Comp_Effective_date_of_this_language');
        jsonGen.writeStringField('translation', 'First Column'); 
        jsonGen.writeStringField('type', 'STRING'); 
        jsonGen.writeBooleanField('multiple', false); 
        jsonGen.writeBooleanField('computed', false);
        jsonGen.writeBooleanField('userInput', true);
        jsonGen.writeEndObject();
        
        //Department Group
        jsonGen.writeStartObject();
        jsonGen.writeStringField('id', 'Comp_Department_Group');
        jsonGen.writeStringField('translation', 'Department Group'); 
        jsonGen.writeStringField('type', 'STRING'); 
        jsonGen.writeBooleanField('multiple', false); 
        jsonGen.writeBooleanField('computed', true);
        jsonGen.writeBooleanField('userInput', true);
        jsonGen.writeEndObject();
        
        //Price Lock
        jsonGen.writeStartObject();
        jsonGen.writeStringField('id', 'Comp_Initial_Freeze_Period');
        jsonGen.writeStringField('translation', 'Price Lock'); 
        jsonGen.writeStringField('type', 'STRING'); 
        jsonGen.writeBooleanField('multiple', false); 
        jsonGen.writeBooleanField('computed', true);
        jsonGen.writeBooleanField('userInput', true);
        jsonGen.writeEndObject();
        
        //Addition communication requirements
        jsonGen.writeStartObject();
        jsonGen.writeStringField('id', 'Comp_Addition_Communication_req');
        jsonGen.writeStringField('translation', 'Addition communication requirements'); 
        jsonGen.writeStringField('type', 'STRING'); 
        jsonGen.writeBooleanField('multiple', false); 
        jsonGen.writeBooleanField('computed', true);
        jsonGen.writeBooleanField('userInput', true);
        jsonGen.writeEndObject();
        
        //Deletion communication requirements
        jsonGen.writeStartObject();
        jsonGen.writeStringField('id', 'Comp_Deletion_Communication_req');
        jsonGen.writeStringField('translation', 'Deletion communication requirements'); 
        jsonGen.writeStringField('type', 'STRING'); 
        jsonGen.writeBooleanField('multiple', false); 
        jsonGen.writeBooleanField('computed', true);
        jsonGen.writeBooleanField('userInput', true);
        jsonGen.writeEndObject();
        
        //Alternate restrictions
        jsonGen.writeStartObject();
        jsonGen.writeStringField('id', 'Comp_Alternate_Restrictions');
        jsonGen.writeStringField('translation', 'Alternate restrictions'); 
        jsonGen.writeStringField('type', 'STRING'); 
        jsonGen.writeBooleanField('multiple', false); 
        jsonGen.writeBooleanField('computed', true);
        jsonGen.writeBooleanField('userInput', true);
        jsonGen.writeEndObject();
        
        //DISCO communication requirements
        jsonGen.writeStartObject();
        jsonGen.writeStringField('id', 'Comp_DISCO_Communication_req');
        jsonGen.writeStringField('translation', 'DISCO communication requirements'); 
        jsonGen.writeStringField('type', 'STRING'); 
        jsonGen.writeBooleanField('multiple', false); 
        jsonGen.writeBooleanField('computed', true);
        jsonGen.writeBooleanField('userInput', true);
        jsonGen.writeEndObject();
        
        //Additional DISCO action
        jsonGen.writeStartObject();
        jsonGen.writeStringField('id', 'Comp_Additional_Disco_act');
        jsonGen.writeStringField('translation', 'Additional DISCO action'); 
        jsonGen.writeStringField('type', 'STRING'); 
        jsonGen.writeBooleanField('multiple', false); 
        jsonGen.writeBooleanField('computed', true);
        jsonGen.writeBooleanField('userInput', true);
        jsonGen.writeEndObject();
        
        //Are Price increase capped?
        jsonGen.writeStartObject();
        jsonGen.writeStringField('id', 'Comp_Is_Price_Increase_Capped');
        jsonGen.writeStringField('translation', 'Are Price increase capped?'); 
        jsonGen.writeStringField('type', 'BOOLEAN'); 
        jsonGen.writeBooleanField('multiple', false); 
        jsonGen.writeBooleanField('computed', true);
        jsonGen.writeBooleanField('userInput', true);
        jsonGen.writeEndObject();
        
        //Cap Type
        jsonGen.writeStartObject();
        jsonGen.writeStringField('id', 'Comp_Cap_Type');
        jsonGen.writeStringField('translation', 'Cap Type'); 
        jsonGen.writeStringField('type', 'STRING'); 
        jsonGen.writeBooleanField('multiple', false); 
        jsonGen.writeBooleanField('computed', false);
        jsonGen.writeBooleanField('userInput', true);
        jsonGen.writeEndObject();
        
         //Cap percentage
        jsonGen.writeStartObject();
        jsonGen.writeStringField('id', 'Comp_Cap_Perc');
        jsonGen.writeStringField('translation', 'Cap percentage'); 
        jsonGen.writeStringField('type', 'PERCENTAGE'); 
        jsonGen.writeBooleanField('multiple', false); 
        jsonGen.writeBooleanField('computed', true);
        jsonGen.writeBooleanField('userInput', true);
        jsonGen.writeEndObject();
        
        //Required Timing of CC Updates
        jsonGen.writeStartObject();
        jsonGen.writeStringField('id', 'Comp_Req_Timing_CC_Updates');
        jsonGen.writeStringField('translation', 'Required Timing of CC Updates'); 
        jsonGen.writeStringField('type', 'INTEGER'); 
        jsonGen.writeBooleanField('multiple', false); 
        jsonGen.writeBooleanField('computed', false);
        jsonGen.writeBooleanField('userInput', true);
        jsonGen.writeEndObject();
        
        //Vendor letter required for core increase?
        jsonGen.writeStartObject();
        jsonGen.writeStringField('id', 'Comp_Vendor_Letter_Req');
        jsonGen.writeStringField('translation', 'Vendor letter required for core increase?'); 
        jsonGen.writeStringField('type', 'STRING'); 
        jsonGen.writeBooleanField('multiple', false); 
        jsonGen.writeBooleanField('computed', true);
        jsonGen.writeBooleanField('userInput', true);
        jsonGen.writeEndObject();
        
         //Vendor letter required for core increase?
        jsonGen.writeStartObject();
        jsonGen.writeStringField('id', 'Comp_Vendor_Letter_Req');
        jsonGen.writeStringField('translation', 'Vendor letter required for core increase?'); 
        jsonGen.writeStringField('type', 'STRING'); 
        jsonGen.writeBooleanField('multiple', false); 
        jsonGen.writeBooleanField('computed', true);
        jsonGen.writeBooleanField('userInput', true);
        jsonGen.writeEndObject();
        
        //Price Change Notice (in days)
        jsonGen.writeStartObject();
        jsonGen.writeStringField('id', 'Comp_CC_Price_Change_Reqd');
        jsonGen.writeStringField('translation', 'Price Change Notice (in days)'); 
        jsonGen.writeStringField('type', 'BOOLEAN'); 
        jsonGen.writeBooleanField('multiple', false); 
        jsonGen.writeBooleanField('computed', true);
        jsonGen.writeBooleanField('userInput', true);
        jsonGen.writeEndObject();
        
        //Communication Req'd for Price Changes?
        jsonGen.writeStartObject();
        jsonGen.writeStringField('id', 'Comp_Is_Comm_Reqd');
        jsonGen.writeStringField('translation', 'Communication Req\'d for Price Changes?'); 
        jsonGen.writeStringField('type', 'STRING'); 
        jsonGen.writeBooleanField('multiple', false); 
        jsonGen.writeBooleanField('computed', true);
        jsonGen.writeBooleanField('userInput', true);
        jsonGen.writeEndObject();
                                 
        //Decrease communication requirements
        jsonGen.writeStartObject();
        jsonGen.writeStringField('id', 'Comp_Decrease_Communication_req');
        jsonGen.writeStringField('translation', 'Decrease communication requirements'); 
        jsonGen.writeStringField('type', 'STRING'); 
        jsonGen.writeBooleanField('multiple', false); 
        jsonGen.writeBooleanField('computed', true);
        jsonGen.writeBooleanField('userInput', true);
        jsonGen.writeEndObject();

        jsonGen.writeEndArray();
        //END : Define all columns to be imported in a Json Array
        
        jsonGen.writeEndObject();
        //END  : 1 - columnDefinitions
    }
    
    public static void buildJsonRowValues_InheritedPerDeptGrp(JSONGenerator jsonGen, Integer count, Contract_Pricing_Terms__c cpt,Map<Id,String> customerNbs,Map<Id,String> customerNames,Map<Id,String> contractAccountLevels,Map<Id,String> contractNbs){
        Date effDate = null;
        
        //Write Row Value in Object        
        jsonGen.writeStartObject();
        
        //Write Header values
        jsonGen.writeStringField('rowId', String.valueOf(count));
        jsonGen.writeStringField('lineItemTemplateId', 'InheritedComplianceLT'); 
        jsonGen.writeStringField('rowParentId', '0'); 

        //Write Cells Values
        jsonGen.writeFieldName('cells');
        jsonGen.writeStartObject();
        
        //Name        
        jsonGen.writeFieldName('_SYS_ROW_ITEM');
        jsonGen.writeStartObject();
        
        jsonGen.writeFieldName('business');
        jsonGen.writeStartObject();
        jsonGen.writeStringField('name', cpt.Name);
        jsonGen.writeStringField('type', 'SPECIFIC'); 
        jsonGen.writeStringField('description', cpt.Name); 
        jsonGen.writeEndObject();
        
        jsonGen.writeEndObject();
        //END - Name
        
        //Row Template
        jsonGen.writeFieldName('_SYS_ROW_TEMPLATE');
        jsonGen.writeStartObject();
        jsonGen.writeStringField('string', 'InheritedComplianceLT');       
        jsonGen.writeEndObject();
        //END - Row Template
        
        //Row Type
        jsonGen.writeFieldName('_SYS_ROW_TYPE');
        jsonGen.writeStartObject();
        jsonGen.writeStringField('string', 'SPECIFIC');       
        jsonGen.writeEndObject();
        //END - Row Type
        
        
        //Comp_Cap_Perc
        jsonGen.writeFieldName('Comp_Cap_Perc');
        jsonGen.writeStartObject();
        jsonGen.writeNumberField('percentage', ((cpt.Price_Incr_Cap_Amt__c != null && cpt.Price_Incr_Cap_Type_Unit__c=='%' ) ? cpt.Price_Incr_Cap_Amt__c/100 : 0));       
        jsonGen.writeEndObject();
        //END - Comp_Cap_Perc
        
        //Comp_Initial_Freeze_Period
        jsonGen.writeFieldName('Comp_Initial_Freeze_Period');
        jsonGen.writeStartObject();
        jsonGen.writeNumberField('integer', cpt.CC_Initial_Freeze_Period_in_days__c != null ? cpt.CC_Initial_Freeze_Period_in_days__c : 0);       
        jsonGen.writeEndObject();
        //END - Comp_Initial_Freeze_Period
        
        //Comp_Department_Group
        if(cpt.Department_Groups__c != null && cpt.Department_Groups__c != ''){
            jsonGen.writeFieldName('Comp_Department_Group');
            jsonGen.writeStartObject();
            jsonGen.writeStringField('string', cpt.Department_Groups__c != null ? cpt.Department_Groups__c : '' );       
            jsonGen.writeEndObject(); 
        }
        //END - Comp_Department_Group

        //Comp_Department
        if(cpt.Departments__c != null && cpt.Departments__c != ''){
            jsonGen.writeFieldName('Comp_Department');
            jsonGen.writeStartObject();
            //if(cpt.Departments__c != null && cpt.Departments__c.length() >= 254){
            //   jsonGen.writeStringField('string', cpt.Departments__c.substring(0,254));      
            //}else{
               jsonGen.writeStringField('string', cpt.Departments__c != null ? cpt.Departments__c : '' );      
            //}              
            jsonGen.writeEndObject();
        }
        //END - Comp_Department
        
        //Increase frequency (in days)
        jsonGen.writeFieldName('Comp_Freq_Price_Increases');
        jsonGen.writeStartObject();
        jsonGen.writeNumberField('integer', cpt.In_days__c != null ? cpt.In_days__c : 0);       
        jsonGen.writeEndObject();
        //END - Increase frequency (in days)
        
        //Price Change Notice (in days)
        jsonGen.writeFieldName('Comp_CC_Price_Change_Reqd');
        jsonGen.writeStartObject();
        jsonGen.writeNumberField('integer', cpt.CC_Prc_Chg_Notice_Reqd_days__c != null ? cpt.CC_Prc_Chg_Notice_Reqd_days__c : 0);       
        jsonGen.writeEndObject();
        //END - Price Change Notice (in days)
        
        //Communication Req'd For CC Price Change
        jsonGen.writeFieldName('Comp_Is_Comm_Reqd');
        jsonGen.writeStartObject();
        jsonGen.writeStringField('string', cpt.Comm_Req_CC_Price_Chg__c != null ? cpt.Comm_Req_CC_Price_Chg__c : '');       
        jsonGen.writeEndObject();
        //END - Communication Req'd For CC Price Chang
        
        //Addition communication requirements
        jsonGen.writeFieldName('Comp_Addition_Communication_req');
        jsonGen.writeStartObject();
        jsonGen.writeStringField('string', cpt.Addition_communication_requirements__c != null ? cpt.Addition_communication_requirements__c : '');       
        jsonGen.writeEndObject();
        //END - Addition communication requirements
        
        //Deletion communication requirements
        jsonGen.writeFieldName('Comp_Deletion_Communication_req');
        jsonGen.writeStartObject();
        jsonGen.writeStringField('string', cpt.Deletion_communication_requirements__c != null ? cpt.Deletion_communication_requirements__c : '');       
        jsonGen.writeEndObject();
        //END - Deletion communication requirements
        
        //Vendor Letter Required For C Increase
        jsonGen.writeFieldName('Comp_Vendor_Letter_Req');
        jsonGen.writeStartObject();
        jsonGen.writeStringField('string', cpt.Vendor_Letter_Required_For_CC_Increase__c != null ? cpt.Vendor_Letter_Required_For_CC_Increase__c : '');       
        jsonGen.writeEndObject();
        //END - Vendor Letter Required For CC Increase
        
        //Are price increases capped?
        jsonGen.writeFieldName('Comp_Is_Price_Increase_Capped');
        jsonGen.writeStartObject();
        jsonGen.writeBooleanField('boolean', cpt.CC_Price_Incr_Capped__c!= null && cpt.CC_Price_Incr_Capped__c.equalsIgnoreCase('Yes') ? true: false);       
        jsonGen.writeEndObject();
        //END - Are price increases capped?
        
        //Cap Type
        jsonGen.writeFieldName('Comp_Cap_Type');
        jsonGen.writeStartObject();
        jsonGen.writeStringField('string', 'Other');  //TODO : Find mapping     
        jsonGen.writeEndObject();
        //END - Cap Type
        
        //Cap Level
		if (cpt.Price_Incr_Cap_App_Level__c != null &&  !cpt.Price_Incr_Cap_App_Level__c.equalsIgnoreCase('')){
			jsonGen.writeFieldName('Comp_Cap_Level');
			jsonGen.writeStartObject();
			jsonGen.writeStringField('string', cpt.Price_Incr_Cap_App_Level__c != null ? cpt.Price_Incr_Cap_App_Level__c : '');       
			jsonGen.writeEndObject();
		}

        //END - Cap Level

        //Account Level
        jsonGen.writeFieldName('Comp_Account_Level');
        jsonGen.writeStartObject();
        jsonGen.writeStringField('string', contractAccountLevels.get(cpt.Contract__c) != null ? contractAccountLevels.get(cpt.Contract__c) : '');       
        jsonGen.writeEndObject();
        //END - Account Level

        
        //Owning Customer #
        jsonGen.writeFieldName('Comp_Owning_Customer_Nb');
        jsonGen.writeStartObject();
        jsonGen.writeStringField('string', customerNbs.get(cpt.Contract__c));       
        jsonGen.writeEndObject();
        //END - Owning Customer #
        
        //Owning Customer Name
        jsonGen.writeFieldName('Comp_Owning_Customer_Name');
        jsonGen.writeStartObject();
        jsonGen.writeStringField('string', customerNames.get(cpt.Contract__c));         
        jsonGen.writeEndObject();
        //END - Owning Customer Name
        
        //Contract Nb
        jsonGen.writeFieldName('Comp_Contract_Nb');
        jsonGen.writeStartObject();
        jsonGen.writeStringField('string', contractNbs.get(cpt.Contract__c));         
        jsonGen.writeEndObject();        
        //END - Contract Nb
        
        //Effective Date of this language
        if(cpt.Effective_Date_of_this_language__c!= null){
            effDate = cpt.Effective_Date_of_this_language__c;
            jsonGen.writeFieldName('Comp_Effective_date_of_this_language_From_CRM');
            jsonGen.writeStartObject();
            jsonGen.writeStringField('string', DateTime.newInstance(effDate.year() ,effDate.month() ,effDate.day(),0,0,0).format('yyyy-MM-dd'));         
            jsonGen.writeEndObject();
        } 

        
        //END - Write Cells Values
        jsonGen.writeEndObject();
        
        //UserInputCells
        jsonGen.writeFieldName('userInputCells');
        jsonGen.writeStartObject();  
        
                //Name        
        jsonGen.writeFieldName('_SYS_ROW_ITEM');
        jsonGen.writeStartObject();
        
        jsonGen.writeFieldName('business');
        jsonGen.writeStartObject();
        jsonGen.writeStringField('name', cpt.Name);
        jsonGen.writeStringField('type', 'SPECIFIC'); 
        jsonGen.writeStringField('description', cpt.Name); 
        jsonGen.writeEndObject();
        
        jsonGen.writeEndObject();
        //END - Name
        
        //Row Template
        jsonGen.writeFieldName('_SYS_ROW_TEMPLATE');
        jsonGen.writeStartObject();
        jsonGen.writeStringField('string', 'InheritedComplianceLT');       
        jsonGen.writeEndObject();
        //END - Row Template
        
        //Row Type
        jsonGen.writeFieldName('_SYS_ROW_TYPE');
        jsonGen.writeStartObject();
        jsonGen.writeStringField('string', 'SPECIFIC');       
        jsonGen.writeEndObject();
        //END - Row Type
        
        
        //Comp_Cap_Perc
        jsonGen.writeFieldName('Comp_Cap_Perc');
        jsonGen.writeStartObject();
        jsonGen.writeNumberField('percentage', ((cpt.Price_Incr_Cap_Amt__c != null && cpt.Price_Incr_Cap_Type_Unit__c=='%') ? cpt.Price_Incr_Cap_Amt__c/100 : 0));       
        jsonGen.writeEndObject();
        //END - Comp_Cap_Perc
        
        //Comp_Initial_Freeze_Period
        jsonGen.writeFieldName('Comp_Initial_Freeze_Period');
        jsonGen.writeStartObject();
        jsonGen.writeNumberField('integer', cpt.CC_Initial_Freeze_Period_in_days__c != null ? cpt.CC_Initial_Freeze_Period_in_days__c : 0);       
        jsonGen.writeEndObject();
        //END - Comp_Initial_Freeze_Period
        
        //Comp_Department_Group
        if(cpt.Department_Groups__c != null && cpt.Department_Groups__c != ''){
            jsonGen.writeFieldName('Comp_Department_Group');
            jsonGen.writeStartObject();
            jsonGen.writeStringField('string', cpt.Department_Groups__c != null ? cpt.Department_Groups__c : '' );       
            jsonGen.writeEndObject(); 
        }
        //END - Comp_Department_Group

        //Comp_Department
        if(cpt.Departments__c != null && cpt.Departments__c != ''){
            jsonGen.writeFieldName('Comp_Department');
            jsonGen.writeStartObject();
            //if(cpt.Departments__c != null && cpt.Departments__c.length() >= 254){
            //   jsonGen.writeStringField('string', cpt.Departments__c.substring(0,254));      
            //}else{
               jsonGen.writeStringField('string', cpt.Departments__c != null ? cpt.Departments__c : '' );      
            //}
            jsonGen.writeEndObject();
        }
        //END - Comp_Department
        
                
        //Increase frequency (in days)
        jsonGen.writeFieldName('Comp_Freq_Price_Increases');
        jsonGen.writeStartObject();
        jsonGen.writeNumberField('integer', cpt.In_days__c != null ? cpt.In_days__c : 0);       
        jsonGen.writeEndObject();
        //END - Increase frequency (in days)
        
        //Price Change Notice (in days)
        jsonGen.writeFieldName('Comp_CC_Price_Change_Reqd');
        jsonGen.writeStartObject();
        jsonGen.writeNumberField('integer', cpt.CC_Prc_Chg_Notice_Reqd_days__c != null ? cpt.CC_Prc_Chg_Notice_Reqd_days__c : 0);       
        jsonGen.writeEndObject();
        //END - Price Change Notice (in days)
        
        //Communication Req'd For CC Price Change
        jsonGen.writeFieldName('Comp_Is_Comm_Reqd');
        jsonGen.writeStartObject();
        jsonGen.writeStringField('string', cpt.Comm_Req_CC_Price_Chg__c != null ? cpt.Comm_Req_CC_Price_Chg__c : '');       
        jsonGen.writeEndObject();
        //END - Communication Req'd For CC Price Chang
        
        //Addition communication requirements
        jsonGen.writeFieldName('Comp_Addition_Communication_req');
        jsonGen.writeStartObject();
        jsonGen.writeStringField('string', cpt.Addition_communication_requirements__c != null ? cpt.Addition_communication_requirements__c : '');       
        jsonGen.writeEndObject();
        //END - Addition communication requirements
        
        //Deletion communication requirements
        jsonGen.writeFieldName('Comp_Deletion_Communication_req');
        jsonGen.writeStartObject();
        jsonGen.writeStringField('string', cpt.Deletion_communication_requirements__c != null ? cpt.Deletion_communication_requirements__c : '');       
        jsonGen.writeEndObject();
        //END - Deletion communication requirements
        
        //Vendor Letter Required For C Increase
        jsonGen.writeFieldName('Comp_Vendor_Letter_Req');
        jsonGen.writeStartObject();
        jsonGen.writeStringField('string', cpt.Vendor_Letter_Required_For_CC_Increase__c != null ? cpt.Vendor_Letter_Required_For_CC_Increase__c : '');       
        jsonGen.writeEndObject();
        //END - Vendor Letter Required For CC Increase
        
        //Are price increases capped?
        jsonGen.writeFieldName('Comp_Is_Price_Increase_Capped');
        jsonGen.writeStartObject();
        jsonGen.writeBooleanField('boolean', cpt.CC_Price_Incr_Capped__c!= null && cpt.CC_Price_Incr_Capped__c.equalsIgnoreCase('Yes') ? true: false);       
        jsonGen.writeEndObject();
        //END - Are price increases capped?
        
        //Cap Type
        jsonGen.writeFieldName('Comp_Cap_Type');
        jsonGen.writeStartObject();
        jsonGen.writeStringField('string', 'Other');  //TODO : Find mapping     
        jsonGen.writeEndObject();
        //END - Cap Type
        
        //Cap Level
		if (cpt.Price_Incr_Cap_App_Level__c != null &&  !cpt.Price_Incr_Cap_App_Level__c.equalsIgnoreCase('')){
			jsonGen.writeFieldName('Comp_Cap_Level');
			jsonGen.writeStartObject();
			jsonGen.writeStringField('string', cpt.Price_Incr_Cap_App_Level__c != null ? cpt.Price_Incr_Cap_App_Level__c : '');       
			jsonGen.writeEndObject();
		}
        //END - Cap Level
        
        //Account Level
        jsonGen.writeFieldName('Comp_Account_Level');
        jsonGen.writeStartObject();
        jsonGen.writeStringField('string', contractAccountLevels.get(cpt.Contract__c) != null ? contractAccountLevels.get(cpt.Contract__c) : '');       
        jsonGen.writeEndObject();
        //END - Account Level

        
        //Owning Customer #
        jsonGen.writeFieldName('Comp_Owning_Customer_Nb');
        jsonGen.writeStartObject();
        jsonGen.writeStringField('string', customerNbs.get(cpt.Contract__c));       
        jsonGen.writeEndObject();
        //END - Owning Customer #
        
        //Owning Customer Name
        jsonGen.writeFieldName('Comp_Owning_Customer_Name');
        jsonGen.writeStartObject();
        jsonGen.writeStringField('string', customerNames.get(cpt.Contract__c));         
        jsonGen.writeEndObject();
        //END - Owning Customer Name
        
        //Contract Nb
        jsonGen.writeFieldName('Comp_Contract_Nb');
        jsonGen.writeStartObject();
        jsonGen.writeStringField('string', contractNbs.get(cpt.Contract__c));         
        jsonGen.writeEndObject();
        //END - Contract Nb
        
        //Effective Date of this language
        if(cpt.Effective_Date_of_this_language__c!= null){
            effDate = cpt.Effective_Date_of_this_language__c;
            jsonGen.writeFieldName('Comp_Effective_date_of_this_language_From_CRM');
            jsonGen.writeStartObject();
            jsonGen.writeStringField('string', DateTime.newInstance(effDate.year() ,effDate.month() ,effDate.day(),0,0,0).format('yyyy-MM-dd'));         
            jsonGen.writeEndObject();
        } 
        
         //END - Write User Input Cells Values
        jsonGen.writeEndObject();    
        
        //Grid Row Type
        jsonGen.writeStringField('gridRowType', 'SPECIFIC');

        
        //END - Write Row Value in Object
        jsonGen.writeEndObject();
    }
    
    public static void buildJsonRowValues_InheritedPerDept(JSONGenerator jsonGen, Integer count, Map<String,Object> mapDeptCpt,Map<Id,String> customerNbs,Map<Id,String> customerNames,Map<Id,String> contractAccountLevels,Map<Id,String> contractNbs){
        Date effDate = null;
        
        //Write Row Value in Object        
        jsonGen.writeStartObject();
        
        //Write Header values
        jsonGen.writeStringField('rowId', String.valueOf(count));
        jsonGen.writeStringField('lineItemTemplateId', 'InheritedCompliancePerDeptLT'); 
        jsonGen.writeStringField('rowParentId', '0'); 

        //Write Cells Values
        jsonGen.writeFieldName('cells');
        jsonGen.writeStartObject();
        
        //Name        
        jsonGen.writeFieldName('_SYS_ROW_ITEM');
        jsonGen.writeStartObject();
        
        jsonGen.writeFieldName('business');
        jsonGen.writeStartObject();
        jsonGen.writeStringField('name', (String)mapDeptCpt.get('Name'));
        jsonGen.writeStringField('type', 'SPECIFIC'); 
        jsonGen.writeStringField('description', (String)mapDeptCpt.get('Name')); 
        jsonGen.writeEndObject();
        
        jsonGen.writeEndObject();
        //END - Name
        
        //Row Template
        jsonGen.writeFieldName('_SYS_ROW_TEMPLATE');
        jsonGen.writeStartObject();
        jsonGen.writeStringField('string', 'InheritedCompliancePerDeptLT');       
        jsonGen.writeEndObject();
        //END - Row Template
        
        //Row Type
        jsonGen.writeFieldName('_SYS_ROW_TYPE');
        jsonGen.writeStartObject();
        jsonGen.writeStringField('string', 'SPECIFIC');       
        jsonGen.writeEndObject();
        //END - Row Type
        
        
        //Comp_Cap_Perc
        jsonGen.writeFieldName('Comp_Cap_Perc');
        jsonGen.writeStartObject();
        jsonGen.writeNumberField('percentage', (DECIMAL)mapDeptCpt.get('Comp_Cap_Perc'));       
        jsonGen.writeEndObject();
        //END - Comp_Cap_Perc
        
        //Comp_Initial_Freeze_Period
        jsonGen.writeFieldName('Comp_Initial_Freeze_Period');
        jsonGen.writeStartObject();
        jsonGen.writeNumberField('integer', (Integer)mapDeptCpt.get('Comp_Initial_Freeze_Period'));       
        jsonGen.writeEndObject();
        //END - Comp_Initial_Freeze_Period
        
        //Comp_Department_Group
        if((String)mapDeptCpt.get('Comp_Department_Group') != ''){
            jsonGen.writeFieldName('Comp_Department_Group');
            jsonGen.writeStartObject();
            jsonGen.writeStringField('string', (String)mapDeptCpt.get('Comp_Department_Group'));       
            jsonGen.writeEndObject();   
        }
        //END - Comp_Department_Group

        //Comp_Department
        if((String)mapDeptCpt.get('Comp_Department') != ''){
            jsonGen.writeFieldName('Comp_Department');
            jsonGen.writeStartObject();
            jsonGen.writeStringField('string', (String)mapDeptCpt.get('Comp_Department'));       
            jsonGen.writeEndObject();
        }
        //END - Comp_Department
        
        //Increase frequency (in days)
        jsonGen.writeFieldName('Comp_Freq_Price_Increases');
        jsonGen.writeStartObject();
        jsonGen.writeNumberField('integer', (Integer)mapDeptCpt.get('Comp_Freq_Price_Increases'));       
        jsonGen.writeEndObject();
        //END - Increase frequency (in days)
        
        //Price Change Notice (in days)
        jsonGen.writeFieldName('Comp_CC_Price_Change_Reqd');
        jsonGen.writeStartObject();
        jsonGen.writeNumberField('integer', (Integer)mapDeptCpt.get('Comp_CC_Price_Change_Reqd'));       
        jsonGen.writeEndObject();
        //END - Price Change Notice (in days)
        
        //Communication Req'd For CC Price Change
        jsonGen.writeFieldName('Comp_Is_Comm_Reqd');
        jsonGen.writeStartObject();
        jsonGen.writeStringField('string', (String)mapDeptCpt.get('Comp_Is_Comm_Reqd'));       
        jsonGen.writeEndObject();
        //END - Communication Req'd For CC Price Chang
        
        //Addition communication requirements
        jsonGen.writeFieldName('Comp_Addition_Communication_req');
        jsonGen.writeStartObject();
        jsonGen.writeStringField('string', (String)mapDeptCpt.get('Comp_Addition_Communication_req'));       
        jsonGen.writeEndObject();
        //END - Addition communication requirements
        
        //Deletion communication requirements
        jsonGen.writeFieldName('Comp_Deletion_Communication_req');
        jsonGen.writeStartObject();
        jsonGen.writeStringField('string', (String)mapDeptCpt.get('Comp_Deletion_Communication_req'));       
        jsonGen.writeEndObject();
        //END - Deletion communication requirements
        
        //Vendor Letter Required For C Increase
        jsonGen.writeFieldName('Comp_Vendor_Letter_Req');
        jsonGen.writeStartObject();
        jsonGen.writeStringField('string', (String)mapDeptCpt.get('Comp_Vendor_Letter_Req'));       
        jsonGen.writeEndObject();
        //END - Vendor Letter Required For CC Increase
        
        //Are price increases capped?
        jsonGen.writeFieldName('Comp_Is_Price_Increase_Capped');
        jsonGen.writeStartObject();
        jsonGen.writeBooleanField('boolean', (Boolean)mapDeptCpt.get('Comp_Is_Price_Increase_Capped'));       
        jsonGen.writeEndObject();
        //END - Are price increases capped?
        
        //Cap Type
        jsonGen.writeFieldName('Comp_Cap_Type');
        jsonGen.writeStartObject();
        jsonGen.writeStringField('string', 'Other');  //TODO : Find mapping     
        jsonGen.writeEndObject();
        //END - Cap Type
        
        //Cap Level
		String capLevel = (String)mapDeptCpt.get('Comp_Cap_Level');
		if (capLevel != null &&  !capLevel.equalsIgnoreCase('')){
			jsonGen.writeFieldName('Comp_Cap_Level');
			jsonGen.writeStartObject();
			jsonGen.writeStringField('string', capLevel);       
			jsonGen.writeEndObject();
		}
        //END - Cap Level
        
        //Account Level
        jsonGen.writeFieldName('Comp_Account_Level');
        jsonGen.writeStartObject();
        jsonGen.writeStringField('string', contractAccountLevels.get((String)mapDeptCpt.get('ContractId')));       
        jsonGen.writeEndObject();
        //END - Account Level

        
        //Owning Customer #
        jsonGen.writeFieldName('Comp_Owning_Customer_Nb');
        jsonGen.writeStartObject();
        jsonGen.writeStringField('string', customerNbs.get((String)mapDeptCpt.get('ContractId')));       
        jsonGen.writeEndObject();
        //END - Owning Customer #
        
        //Owning Customer Name
        jsonGen.writeFieldName('Comp_Owning_Customer_Name');
        jsonGen.writeStartObject();
        jsonGen.writeStringField('string', customerNames.get((String)mapDeptCpt.get('ContractId')));       
        jsonGen.writeEndObject();
        //END - Owning Customer Name
        
        //Contract Nb
        jsonGen.writeFieldName('Comp_Contract_Nb');
        jsonGen.writeStartObject();
        jsonGen.writeStringField('string', contractNbs.get((String)mapDeptCpt.get('ContractId')));       
        jsonGen.writeEndObject();
        //END - Contract Nb
        
        //Effective Date of this language
        if(mapDeptCpt.get('Effective_Date_of_this_language')!= null){
            effDate = (Date)mapDeptCpt.get('Effective_Date_of_this_language');
            jsonGen.writeFieldName('Comp_Effective_date_of_this_language_From_CRM');
            jsonGen.writeStartObject();
            jsonGen.writeStringField('string', DateTime.newInstance(effDate.year() ,effDate.month() ,effDate.day(),0,0,0).format('yyyy-MM-dd'));         
            jsonGen.writeEndObject();
        }
        
        //END - Write Cells Values
        jsonGen.writeEndObject();
        
        //UserInputCells
        jsonGen.writeFieldName('userInputCells');
        jsonGen.writeStartObject();  
        
                 //Name        
        jsonGen.writeFieldName('_SYS_ROW_ITEM');
        jsonGen.writeStartObject();
        
        jsonGen.writeFieldName('business');
        jsonGen.writeStartObject();
        jsonGen.writeStringField('name', (String)mapDeptCpt.get('Name'));
        jsonGen.writeStringField('type', 'SPECIFIC'); 
        jsonGen.writeStringField('description', (String)mapDeptCpt.get('Name')); 
        jsonGen.writeEndObject();
        
        jsonGen.writeEndObject();
        //END - Name
        
        //Row Template
        jsonGen.writeFieldName('_SYS_ROW_TEMPLATE');
        jsonGen.writeStartObject();
        jsonGen.writeStringField('string', 'InheritedCompliancePerDeptLT');       
        jsonGen.writeEndObject();
        //END - Row Template
        
        //Row Type
        jsonGen.writeFieldName('_SYS_ROW_TYPE');
        jsonGen.writeStartObject();
        jsonGen.writeStringField('string', 'SPECIFIC');       
        jsonGen.writeEndObject();
        //END - Row Type
        
        
        //Comp_Cap_Perc
        jsonGen.writeFieldName('Comp_Cap_Perc');
        jsonGen.writeStartObject();
        jsonGen.writeNumberField('percentage', (DECIMAL)mapDeptCpt.get('Comp_Cap_Perc'));       
        jsonGen.writeEndObject();
        //END - Comp_Cap_Perc
        
        //Comp_Initial_Freeze_Period
        jsonGen.writeFieldName('Comp_Initial_Freeze_Period');
        jsonGen.writeStartObject();
        jsonGen.writeNumberField('integer', (Integer)mapDeptCpt.get('Comp_Initial_Freeze_Period'));       
        jsonGen.writeEndObject();
        //END - Comp_Initial_Freeze_Period
        
        //Comp_Department_Group
        if((String)mapDeptCpt.get('Comp_Department_Group') != ''){
            jsonGen.writeFieldName('Comp_Department_Group');
            jsonGen.writeStartObject();
            jsonGen.writeStringField('string', (String)mapDeptCpt.get('Comp_Department_Group'));       
            jsonGen.writeEndObject();   
        }
        //END - Comp_Department_Group

        //Comp_Department
        if((String)mapDeptCpt.get('Comp_Department') != ''){
            jsonGen.writeFieldName('Comp_Department');
            jsonGen.writeStartObject();
            jsonGen.writeStringField('string', (String)mapDeptCpt.get('Comp_Department'));       
            jsonGen.writeEndObject();
        }
        //END - Comp_Department
        
        //Increase frequency (in days)
        jsonGen.writeFieldName('Comp_Freq_Price_Increases');
        jsonGen.writeStartObject();
        jsonGen.writeNumberField('integer', (Integer)mapDeptCpt.get('Comp_Freq_Price_Increases'));       
        jsonGen.writeEndObject();
        //END - Increase frequency (in days)
        
        //Price Change Notice (in days)
        jsonGen.writeFieldName('Comp_CC_Price_Change_Reqd');
        jsonGen.writeStartObject();
        jsonGen.writeNumberField('integer', (Integer)mapDeptCpt.get('Comp_CC_Price_Change_Reqd'));       
        jsonGen.writeEndObject();
        //END - Price Change Notice (in days)
        
        //Communication Req'd For CC Price Change
        jsonGen.writeFieldName('Comp_Is_Comm_Reqd');
        jsonGen.writeStartObject();
        jsonGen.writeStringField('string', (String)mapDeptCpt.get('Comp_Is_Comm_Reqd'));       
        jsonGen.writeEndObject();
        //END - Communication Req'd For CC Price Chang
        
        //Addition communication requirements
        jsonGen.writeFieldName('Comp_Addition_Communication_req');
        jsonGen.writeStartObject();
        jsonGen.writeStringField('string', (String)mapDeptCpt.get('Comp_Addition_Communication_req'));       
        jsonGen.writeEndObject();
        //END - Addition communication requirements
        
        //Deletion communication requirements
        jsonGen.writeFieldName('Comp_Deletion_Communication_req');
        jsonGen.writeStartObject();
        jsonGen.writeStringField('string', (String)mapDeptCpt.get('Comp_Deletion_Communication_req'));       
        jsonGen.writeEndObject();
        //END - Deletion communication requirements
        
        //Vendor Letter Required For C Increase
        jsonGen.writeFieldName('Comp_Vendor_Letter_Req');
        jsonGen.writeStartObject();
        jsonGen.writeStringField('string', (String)mapDeptCpt.get('Comp_Vendor_Letter_Req'));       
        jsonGen.writeEndObject();
        //END - Vendor Letter Required For CC Increase
        
        //Are price increases capped?
        jsonGen.writeFieldName('Comp_Is_Price_Increase_Capped');
        jsonGen.writeStartObject();
        jsonGen.writeBooleanField('boolean', (Boolean)mapDeptCpt.get('Comp_Is_Price_Increase_Capped'));       
        jsonGen.writeEndObject();
        //END - Are price increases capped?
        
        //Cap Type
        jsonGen.writeFieldName('Comp_Cap_Type');
        jsonGen.writeStartObject();
        jsonGen.writeStringField('string', 'Other');  //TODO : Find mapping     
        jsonGen.writeEndObject();
        //END - Cap Type
        
        //Cap Level
		capLevel = (String)mapDeptCpt.get('Comp_Cap_Level');
		if (capLevel != null &&  !capLevel.equalsIgnoreCase('')){
			jsonGen.writeFieldName('Comp_Cap_Level');
			jsonGen.writeStartObject();
			jsonGen.writeStringField('string', capLevel);       
			jsonGen.writeEndObject();
		}
        //END - Cap Level
        
        //Account Level
        jsonGen.writeFieldName('Comp_Account_Level');
        jsonGen.writeStartObject();
        jsonGen.writeStringField('string', contractAccountLevels.get((String)mapDeptCpt.get('ContractId')));       
        jsonGen.writeEndObject();
        //END - Account Level

        
        //Owning Customer #
        jsonGen.writeFieldName('Comp_Owning_Customer_Nb');
        jsonGen.writeStartObject();
        jsonGen.writeStringField('string', customerNbs.get((String)mapDeptCpt.get('ContractId')));       
        jsonGen.writeEndObject();
        //END - Owning Customer #
        
        //Owning Customer Name
        jsonGen.writeFieldName('Comp_Owning_Customer_Name');
        jsonGen.writeStartObject();
        jsonGen.writeStringField('string', customerNames.get((String)mapDeptCpt.get('ContractId')));       
        jsonGen.writeEndObject();
        //END - Owning Customer Name
        
        //Contract Nb
        jsonGen.writeFieldName('Comp_Contract_Nb');
        jsonGen.writeStartObject();
        jsonGen.writeStringField('string', contractNbs.get((String)mapDeptCpt.get('ContractId')));       
        jsonGen.writeEndObject();
        //END - Contract Nb
        
        //Effective Date of this language
        if(mapDeptCpt.get('Effective_Date_of_this_language')!= null){
            effDate = (Date)mapDeptCpt.get('Effective_Date_of_this_language');
            jsonGen.writeFieldName('Comp_Effective_date_of_this_language_From_CRM');
            jsonGen.writeStartObject();
            jsonGen.writeStringField('string', DateTime.newInstance(effDate.year() ,effDate.month() ,effDate.day(),0,0,0).format('yyyy-MM-dd'));         
            jsonGen.writeEndObject();
        }
        
         //END - Write User Input Cells Values
        jsonGen.writeEndObject();    
        
        //Grid Row Type
        jsonGen.writeStringField('gridRowType', 'SPECIFIC');

        
        //END - Write Row Value in Object
        jsonGen.writeEndObject();
    }
    
    public static List<Map<String,Object>> expandCPTAtDeptLevel(Contract_Pricing_Terms__c cpt){
        List<Map<String,Object>> deptLevelCpts = new List<Map<String,Object>>();
        String[] departments;
        String departmentCode;
        
        //Generate a Map for each department in the CPT that will contain all CPT information then return Map as result
        if(cpt.Departments__c != null){
            departments = cpt.Departments__c.split(';');
            for(String department : departments){
                //Get Department Code Ex: 89
                departmentCode = department.split(' - ')[0];
                //Add prefix to match CPQ data : DP - 89
                departmentCode = 'DP - ' + departmentCode;
                //Convert 2 characters one digit code into 1 character one digit code (Ex: DP - 01 ==> DP - 1)
                departmentCode = departmentCode.replaceFirst('DP - 0', 'DP - ');
                
                Map<String,Object> deptLevelCpt = new Map<String,Object>();
                
                //Populate Map with current CPT info
                deptLevelCpt.put('Name', cpt.Name);
                deptLevelCpt.put('Comp_Department', departmentCode);
                deptLevelCpt.put('Comp_Department_Group', cpt.Department_Groups__c != null ? cpt.Department_Groups__c : '');
                deptLevelCpt.put('Comp_Initial_Freeze_Period', cpt.CC_Initial_Freeze_Period_in_days__c != null ? cpt.CC_Initial_Freeze_Period_in_days__c.intValue() : 0);
                deptLevelCpt.put('Comp_Freq_Price_Increases', cpt.In_days__c != null ? cpt.In_days__c.intValue() : 0);
                deptLevelCpt.put('Comp_CC_Price_Change_Reqd', cpt.CC_Prc_Chg_Notice_Reqd_days__c != null ? cpt.CC_Prc_Chg_Notice_Reqd_days__c.intValue() : 0);
                deptLevelCpt.put('Comp_Is_Comm_Reqd', cpt.Comm_Req_CC_Price_Chg__c != null ? cpt.Comm_Req_CC_Price_Chg__c : '');
                deptLevelCpt.put('Comp_Vendor_Letter_Req', cpt.Vendor_Letter_Required_For_CC_Increase__c != null ? cpt.Vendor_Letter_Required_For_CC_Increase__c : '');
                deptLevelCpt.put('Comp_Addition_Communication_req', cpt.Addition_communication_requirements__c != null ? cpt.Addition_communication_requirements__c : '');
                deptLevelCpt.put('Comp_Deletion_Communication_req', cpt.Deletion_communication_requirements__c != null ? cpt.Deletion_communication_requirements__c : '');
                deptLevelCpt.put('Comp_Is_Price_Increase_Capped', cpt.CC_Price_Incr_Capped__c!= null && cpt.CC_Price_Incr_Capped__c.equalsIgnoreCase('Yes') ? true: false);
                deptLevelCpt.put('Comp_Cap_Type', 'Other');
                deptLevelCpt.put('Comp_Cap_Perc', ((cpt.Price_Incr_Cap_Amt__c != null  && cpt.Price_Incr_Cap_Type_Unit__c=='%')? cpt.Price_Incr_Cap_Amt__c/100 : 0));
                deptLevelCpt.put('Comp_Cap_Level', cpt.Price_Incr_Cap_App_Level__c != null ? cpt.Price_Incr_Cap_App_Level__c : '');
                //deptLevelCpt.put('Comp_Account_Level', cpt.Account_Level__c != null ? cpt.Account_Level__c : '');
                deptLevelCpt.put('ContractId', cpt.Contract__c);
                deptLevelCpt.put('Effective_Date_of_this_language', cpt.Effective_Date_of_this_language__c);
                
                //Add Department CPT Map to List
                deptLevelCpts.add(deptLevelCpt);
                
            }
        }
        return deptLevelCpts;
    }
    
    /**
     * Exception class.
     */
    public class QxImportQuoteDataException extends Exception {}


}