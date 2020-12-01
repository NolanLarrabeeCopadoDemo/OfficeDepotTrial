/**
* @description This class is used to process account setup requests submitted throug the CustomerDetails.cmp. Partial coverage is provided by AccountSetUpController_Test.
*/
public class AccountSetUpController {
    @testVisible
    class ASRException extends Exception {}
    
    static Id ASR_RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Account Setup Requested').getRecordTypeId();
    static Id Customer_RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Customer').getRecordTypeId();
    static Id Account_Site_RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Site').getRecordTypeId();
    static Id DR_RecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Deployment Request').getRecordTypeId();
    //prasad changed
    static Id OPP_PPE_RecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('PPE-CBFS').getRecordTypeId();
    static Id Prospect_RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Prospect').getRecordTypeId();
    //prasad change complete
    static Id SCOE_RecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('SCOE').getRecordTypeId();
    //static Id SCOE_RecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('SCOE').getRecordTypeId();
    static String genericError = 'Sorry, we experienced an error while processing your account setup request. For support, please open a ticket with the account information by emailing salesforce@officedepot.com.';
    
    /*
* @description  Gets the account associated with the opportunity and verifies that the necessary fields are populated.
* @author Adam A
* @createddate 04-December-2018
*/
    @testVisible()
    static void validateAccount(Account myAccount)
    {
        if (myAccount == null)
            throw new ASRException('Site Account does not have a related Account');
        //return 'Site Account does not have a related Account';
        else if (myAccount.RecordTypeId == Customer_RecordTypeId)
            throw new ASRException('Account setup cannot continue as Opportunity is already tied to a customer');
        //return 'Account setup cannot continue as Opportunity is already tied to a customer';
        else if (myAccount.RecordTypeId == ASR_RecordTypeId)
            throw new ASRException('Account setup cannot continue as Opportunity is already tied to an Account that is currently being setup');
        //return 'Account setup cannot continue as Opportunity is already tied to an Account that is currently being setup';
        
        else if (myAccount.Oracle_Party_ID__c == null && myAccount.MPS_Parent_Account__c == null)
        {
            String errorMsg1 = 'This prospect is not yet ready for Customer Setup. If you just created this Prospect please wait a few minutes for replication before requesting Customer Setup.\n';
            String errorMsg2 = 'If its been over 30min since creation and you are receiving this error - please put in a Support Ticket with the subject: Request customer setup is not functioning';
            throw new ASRException(errorMsg1 + errorMsg2);
            //return 'This prospect is not yet ready for Customer Setup. If you just created this Prospect please wait a few minutes for replication before requesting Customer Setup.\n' +
            //'If its been over 30min since creation and you are receiving this error - please put in a Support Ticket with the subject: Request customer setup is not functioning';
        }
        else if (myAccount.Industry_OD_SIC_Rep__c == null)
            throw new ASRException('Please complete the Industry field on the account page before submitting for customer setup');
        //return 'Please complete the Industry field on the account page before submitting for customer setup';
        else if (myAccount.Sector__c == null)
            throw new ASRException('Please complete the Sector field on the account page before submitting for customer setup');
        //return 'Please complete the Sector field on the account page before submitting for customer setup';
        else if (myAccount.Segment__c == null)
            throw new ASRException('Please complete the Segment field on the account page before submitting for customer setup');
        //return 'Please complete the Segment field on the account page before submitting for customer setup';
        else if (myAccount.Est_Spend__c == null)
            throw new ASRException('Please complete the Account Potential field on the account page before submitting for customer setup');
        //return 'Please complete the Account Potential field on the account page before submitting for customer setup';
        else if (myAccount.Pricing_template_cd__c == null)
            throw new ASRException('Please complete the Pricing Template field on the account page before submitting for customer setup');
        //return 'Please complete the Pricing Template field on the account page before submitting for customer setup';
        else if (myAccount.Sales_PersonID__c == null || myAccount.Sales_PersonID__r.Name == 'Awaiting SalesID')
            throw new ASRException('Please ensure an active and primary Sales Person Id is associated with the account you are trying to set up.');
        //return 'Please complete the Pricing Template field on the account page before submitting for customer setup';
        else
            return;
    }
    
    /*******************************************************************************************************
* @author Adam A
* @date 04-December-2018
* @description Takes the list of contacts associated with the opportunity and validates them.
*/
    @testVisible()
    static String validateContacts(List <Contact> myContacts)
    {
        if (myContacts.size() == 0)
            return 'You must have a primary contact selected before continuing.  If you have added a contact please remember to flag it as primary by selecting the "primary contact" checkbox';
        else if (myContacts.size() > 1)
            return 'You currently have 2 or more contacts flagged as primary - you must SELECT only one of these as the primary in order to request a customer setup';
        else
            return 'ok';
    }
    
    /*******************************************************************************************************
* @author Adam A, adam.albright@officedepot.com
* @date
* @description Processes the form data submitted by the rep and attempts to kick of the
* account setup process. The Account Setup Request or ASR is used to store the progress of the
* rep as they are entering information and once the rep submitts, it is validated.
*/
    @testVisible()
    static void validateOpportunity(Opportunity Opp)
    {
        //List<CameleonCPQ__QxQuote__c> my_pros_quote = [SELECT Id FROM CameleonCPQ__QxQuote__c WHERE OpportunityId__c =:Opp.Id];
        
        if (Opp.AccountId == null)
            throw new ASRException('Opportunity is not associated with an Account');
        else if (Opp.Stagename == 'Lost' || Opp.stagename == 'Walkaway' || Opp.stagename == 'Duplicate/Cancelled')
            throw new ASRException('Opportunity must be in an Open Stage to Proceed');
          /*  else if (my_pros_quote.size() < 1)
            throw new ASRException('Orion Quote required'); */
        else
            return;
    }
    
    /*******************************************************************************************************
* @author Adam Albright
* @date 16 December 2018
* @description Validates the data on the objects needed to set up an account. If there is an issue, the rep will be notified
* and a log will be generated.
*/
    @AuraEnabled
    public static void getDataValidate(String OppId)
    {
        try
        {
            validateDataForAccountSetup(OppId);
        }
        catch (ASRException e)
        {
            makeLog('ERROR', e.getMessage());
            makeLog('ERROR', e.getStackTraceString());
            throw new AuraHandledException(e.getMessage());
        }
        catch (Exception e)
        {
            makeLog('ERROR', e.getMessage());
            makeLog('ERROR', e.getStackTraceString());
            throw new AuraHandledException(genericError);
        }
    }
    
    @testVisible
    private static Account map_opportunity_data_to_account(Opportunity my_opportunity, Account my_account)
    {
        my_account.Initial_Opportunity_Annual_Amount__c = my_opportunity.Amount;
        return my_account;
    }
    
    /*@AuraEnabled
    public static void getSpclOppCheck(String OppId)
    {
        try
        {
            
            toProspectForSpclOpp(OppId);
        }
        catch (ASRException e)
        {
            makeLog('ERROR', e.getMessage());
            makeLog('ERROR', e.getStackTraceString());
            throw new AuraHandledException(e.getMessage());
        }
        catch (Exception e)
        {
            makeLog('ERROR', e.getMessage());
            makeLog('ERROR', e.getStackTraceString());
            throw new AuraHandledException(genericError);
        }
    }
    
    private static void toProspectForSpclOpp(String opportunityId)
    {
        Opportunity myOpp = [
            SELECT
            Id,
            AccountId,
            Account.Id,
            Account.pricing_template_cd__c,
            Stagename,
            Amount,
            recordtypeid
            FROM Opportunity
            WHERE Id =:opportunityId
        ];
        
        if (myOpp.recordtypeid == OPP_PPE_RecordTypeId)
        {
            Account custAccount = [
                
                SELECT id,
                recordtypeid,
                RecordType.Name,
                DNBI_CREDIT_OUTCOME__c,
                Name,
                Est_Spend__c,
                Org_WCW_Count_Rep__c,
                Sic,
                org__c,
                OwnerId,
                Sales_PersonID__r.name,
                Sales_PersonID__c,
                Owner.name,
                Duns_Number__c,
                Ultimate_Duns_Number__c,
                Phone,
                Phone_Ext__c,
                setup_url1__c,
                Related_Account__c,
                Oracle_Party_ID__c,
                Industry_OD_SIC_Rep__c,
                Segment__c,
                Sector__c,
                Pricing_template_cd__c,
                Related_Pricing_Template_Account__r.Cust_Id__c,
                Payment_Term__c,
                Related_Parent_Account__c
                
                FROM Account WHERE id =:myOpp.AccountId
            ];
            
            if (custAccount.recordtypeid == Customer_RecordTypeId)
            {
                Account a = new Account();
                a.name = custAccount.name;
                a.org__c = custAccount.org__c;
                a.recordtypeid = Prospect_RecordTypeId;
                a.DNBI_CREDIT_OUTCOME__c = custAccount.DNBI_CREDIT_OUTCOME__c;
                
                if (custAccount.Est_Spend__c != NULL)
                {
                    a.Est_Spend__c = custAccount.Est_Spend__c;
                }
                else
                {
                    a.Est_Spend__c = 0;
                }
                
                a.Org_WCW_Count_Rep__c = custAccount.Org_WCW_Count_Rep__c;
                a.Sic = custAccount.Sic;
                a.Duns_Number__c = custAccount.Duns_Number__c;
                a.Ultimate_Duns_Number__c = custAccount.Ultimate_Duns_Number__c;
                a.Phone = custAccount.Phone;
                a.Phone_Ext__c = custAccount.Phone_Ext__c;
                a.MPS_Parent_Account__c = custAccount.id;
                a.Industry_OD_SIC_Rep__c = custAccount.Industry_OD_SIC_Rep__c;
                a.Segment__c = custAccount.Segment__c;
                a.Sector__c = custAccount.Sector__c;
                a.Pricing_template_cd__c = custAccount.Pricing_template_cd__c;
                a.Related_Pricing_Template_Account__c = custAccount.Related_Pricing_Template_Account__c;
                a.Payment_Term__c = custAccount.Payment_Term__c;
                a.Related_Parent_Account__c = custAccount.Related_Parent_Account__c;
                insert a;
                
                Contact primaryContact = new Contact();
                Contact primaryContactold = [SELECT id, Salutation, FirstName, LastName, Title, Phone, Fax, Email, role__c, MobilePhone
                                             FROM Contact WHERE AccountId =:myOpp.AccountId AND Primary_Contact__c = true limit 1        ];
                
                primaryContact.Salutation = primaryContactold.Salutation;
                primaryContact.FirstName = primaryContactold.FirstName;
                primaryContact.LastName = primaryContactold.LastName;
                primaryContact.Title = primaryContactold.Title;
                primaryContact.Phone = primaryContactold.Phone;
                primaryContact.Fax = primaryContactold.Fax;
                primaryContact.Email = primaryContactold.Email;
                primaryContact.role__c = primaryContactold.role__c;
                primaryContact.MobilePhone = primaryContactold.MobilePhone;
                primaryContact.Primary_Contact__c = true;
                primaryContact.AccountId = a.id;
                insert primaryContact;
                Account primarySiteAccount = new Account();
                Account accountSite = [
                    SELECT id, Name, Oracle_Party_Site_ID__c, Address1__c, Address2__c, City__c, State__c, Zip__c, Country__c
                    FROM Account
                    WHERE RecordTypeId =:Account_Site_RecordTypeId AND Primary_Site__c = true AND Related_Account__c =:myOpp.AccountId limit 1
                ];
                
                primarySiteAccount.Name = accountSite.name;
                primarySiteAccount.Address1__c = accountSite.Address1__c;
                primarySiteAccount.Address2__c = accountSite.Address2__c;
                primarySiteAccount.City__c = accountSite.City__c;
                primarySiteAccount.State__c = accountSite.State__c;
                primarySiteAccount.Zip__c = accountSite.Zip__c;
                primarySiteAccount.Country__c = accountSite.Country__c;
                primarySiteAccount.Related_Account__c = a.id;
                primarySiteAccount.Primary_Site__c = true;
                primarySiteAccount.RecordTypeId = Account_Site_RecordTypeId;
                insert primarySiteAccount;
                myOpp.AccountId = a.id;
                update myOpp;
            }
        }
        
    }*/
    
    private static void validateDataForAccountSetup(String opportunityId)
    {
        List<SObject> objects_to_commit = new List<SObject>();
        Opportunity myOpp = [
            SELECT
            Id,
            AccountId,
            Account.Id,
            Account.pricing_template_cd__c,
            Stagename,
            Amount,
            recordtypeid
            FROM Opportunity
            WHERE Id =:opportunityId
        ];
        
        
        validateOpportunity(myOpp);
        
        //  Account accountToSetup = new Account();
        Account accountToSetup = [
            SELECT
            RecordType.Name,
            DNBI_CREDIT_OUTCOME__c,
            Name,
            Est_Spend__c,
            Org_WCW_Count_Rep__c,
            Sic,
            OwnerId,
            Sales_PersonID__r.name,
            Sales_PersonID__c,
            Owner.name,
            Duns_Number__c,
            Ultimate_Duns_Number__c,
            Phone,
            Phone_Ext__c,
            setup_url1__c,
            Related_Account__c,
            Oracle_Party_ID__c,
            Industry_OD_SIC_Rep__c,
            Segment__c,
            Sector__c,
            Pricing_template_cd__c,
            Related_Pricing_Template_Account__r.Cust_Id__c,
            Payment_Term__c,
            Related_Parent_Account__c,
            MPS_Parent_Account__c
            FROM Account WHERE id =:myOpp.AccountId
        ];
        
        // Throws an exception is there is an issue.
        validateAccount(accountToSetup);
        //If the account and opportunity and valid, Run opportunity to account map.
        objects_to_commit.add(map_opportunity_data_to_account(myOpp, accountToSetup));
        List <Contact> primaryContacts = [
            SELECT
            Id
            FROM Contact
            WHERE AccountId =:accountToSetup.Id
            AND primary_contact__c = true
        ];
        validateContacts(primaryContacts);
        
        if ('Custom - Self Service'.equals(myOpp.account.Pricing_template_cd__c))
        {
            AggregateResult qaccepted_total = [
                SELECT count(id) tot_accepted
                FROM quote
                WHERE OpportunityId =:opportunityId
                AND status = 'Accepted by Customer'
            ];
            
            if (decimal.valueof(string.valueof(qaccepted_total.get('tot_accepted'))) < 1)
            {
                throw new ASRException('Opportunity should have at least One Accepted Quote');
            }
        }
        
        List <Sales_Person__c> SalesPersons = [
            SELECT Name, ExtIDSalesPerson__c
            FROM Sales_Person__c WHERE User__c =:accountToSetup.OwnerId
            AND User_Status__c = 'Active'
            AND Primary__c = true
        ];
        if (SalesPersons.size() == 0)
        {
            throw new ASRException('Currently, you are missing a sales Rep Id, please Contact your manager. If you have just been assigned a new ID, please wait 24 hours for the changes to take place.');
        }
        else if (SalesPersons[0].ExtIDSalesPerson__c == 'TEMPID' || SalesPersons[0].ExtIDSalesPerson__c == 'Awaiting SalesID')
        {
            throw new ASRException('You do not have valid SalesRep ID. Please contact your Manager');
        }
        
        update objects_to_commit;
        return;
    }
    
    /*******************************************************************************************************
* @author
* @date
* @description Processes the form data submitted by the rep and attempts to kick of the
* account setup process. The Account Setup REquest or ASR is used to store the progress of the
* rep as they are entering information and once the rep submitts, it is validated.
*/
    @AuraEnabled
    public static void SubmitProspect(String updatedRecords,string fileName,string base64Data,string contentType)
    {
        try
        {
            submitProspectForAccountSetup(updatedRecords,fileName, base64Data, contentType);
        }
        catch (ASRException e)
        {
            makeLog('ERROR', e.getStackTraceString());
            throw new AuraHandledException(e.getMessage());
        }
        catch (Exception e)
        {
            makeLog('ERROR', e.getStackTraceString());
            throw new AuraHandledException(genericError);
        }
    }
    
    @testVisible
    private static void submitProspectForAccountSetup(String updatedRecords,string fileName,string base64Data,string contentType )
    {
        Savepoint ASR_Savepoint = Database.setSavepoint();
        Account_Setup_Request__c myASR = (Account_Setup_Request__c) JSON.deserialize(updatedRecords, Account_Setup_Request__c.class);
        Id AccountId = myASR.Account__c;
        Account myASR_Account = new Account();
        myASR_Account = [SELECT id, org__c, recordtypeid FROM Account WHERE id =:AccountId];
        Id submissionId;
        DML__c related_DML = new DML__c();
        DML_Relation__c DML_Relation_Record;
        Contact primaryContact = [SELECT Id FROM Contact WHERE AccountId = :myASR_Account.Id AND Primary_Contact__c = true LIMIT 1];
        primaryContact.Created_With_Account_Setup__c = true;
        update primaryContact;
        
        try
        {
            if (myASR == null)
                throw new ASRException('The Account Setup Request Object is null and setup cannot proceed. \nPlease contact IT');
            if (myASR.IsAccountSetUpSubmitted__c == true)
                throw new ASRException('This account appears to have already been set up. If you believe this message is an error, please submit a ticket to IT.');
            
            String myDmlId = myASR.DML__c;
            
            if (myASR.Id == null)
            {
                myASR.Id = [SELECT Id FROM Account_Setup_Request__c WHERE Account__c =:myASR.Account__c LIMIT 1].Id;  // OPERATION__c added by Moe
            }
            
            if (myASR.PD_Doc_Name__c == null)
            {
                myASR.PD_Doc_Name__c = 'Standard Invoice';
                myASR.Billing_Frequency__c = 'Weekly';
            }
            
            // If we have some myDmlId
            if (String.isNotBlank(myDmlId))
            {
                // Get that dml id
                related_DML = [SELECT id, DECISION_MAKER_NM__c, Status__c FROM DML__c WHERE id =:myDmlId LIMIT 1];
                // If we got a dml with that id...
                if (related_DML != null)
                {
                    // If the status is not draft and not rejected...
                    if (related_DML.Status__c != 'Draft' && related_DML.Status__c != 'Rejected')
                    {
                        // Create a new DML Relation, Add A check here to see if we have a relation already.
                        DML_Relation_Record = new DML_Relation__c(Org__c = myASR_Account.org__c, Account__c = myASR_Account.id, DML__c = related_DML.id, Effective_Start_Date__c = Date.today());
                        Insert DML_Relation_Record;
                    }
                    myASR_Account.Related_DML__C = related_DML.id;
                }
            }
            
            myASR_Account.RecordTypeId = ASR_RecordTypeId;
            myASR_Account.Account_Setup_Operation__c = myASR.OPERATION__c; // Added by Moe
            Update myASR_Account;
            
            myASR.IsAccountSetUpSubmitted__c = true;
            Upsert myASR;
            
            //Start: by Rajendra Shahane for NAIT-135726 02931356 - Allow Reps to Attach Tax Exemption Form - Account Setup
            if(myASR.Tax_Exempt__c != null && myASR.Tax_Exempt__c == 'Yes' && fileName != null && fileName != '' && base64Data != null && base64Data != '' && contentType != null && contentType != '')
                createSCOECaseForTaxExemp(myASR,fileName, base64Data, contentType);
            //End: by Rajendra Shahane for NAIT-135726 02931356 - Allow Reps to Attach Tax Exemption Form - Account Setup  
            //Start: by Roselin Gorllapati for https://officedepot.atlassian.net/browse/NAIT-144599  03017345 - Ability to Capture the Payment Method in the Account Setup Process
            if(myASR.What_is_the_payment_method__c !=null && myASR.What_is_the_payment_method__c == 'ACH')
                createSCOECaseForPaymentMethodACH(myASR); //,oppId 
            //End: by Roselin Gorllapati for https://officedepot.atlassian.net/browse/NAIT-144599  03017345 - Ability to Capture the Payment Method in the Account Setup Process        
        } catch (Exception e)
        {
            Database.rollback(ASR_Savepoint);
            throw e;
        }
    }
    
    //Start: by Rajendra Shahane for NAIT-135726 02931356 - Allow Reps to Attach Tax Exemption Form - Account Setup
    @testVisible
    private static void createSCOECaseForTaxExemp(Account_Setup_Request__c myASR,string fileName,string base64Data,string contentType)
    {
        List<Group> lstGroup = [SELECT Id FROM Group WHERE Type = 'Queue' AND DeveloperNAME = 'BSD_Tax_Exemption_Queue' Limit 1];
        if(!lstGroup.isEmpty()){
            Case scoe_Tax_case = new Case();
            scoe_Tax_case.RecordTypeId = SCOE_RecordTypeId;
            scoe_Tax_case.Priority = '3-Medium';
            scoe_Tax_case.Description = 'n/a';
            scoe_Tax_case.SCOE_Issue_Type__c = 'Tax';
            scoe_Tax_case.SCOE_Support_Type__c = 'Tax';
            string strAccName = '';
            if(myASR.BillTo_Name__c != null && myASR.BillTo_Name__c != '') strAccName = myASR.BillTo_Name__c + ' - ';
            scoe_Tax_case.Subject = strAccName + 'Tax Exemption Certificate';
            scoe_Tax_case.New_Request__c = '';
            if(myASR.Tax_Exempt__c != null && myASR.Tax_Exempt__c == 'Yes')
            {
                scoe_Tax_case.New_Request__c += 'Is your Customer Tax Exempt? ' + myASR.Tax_Exempt__c + '\n';
                if(myASR.Tax_Exempt_States__c != null && myASR.Tax_Exempt_States__c != '') scoe_Tax_case.New_Request__c += 'Which State? - ' + myASR.Tax_Exempt_States__c + '\n';
                else scoe_Tax_case.New_Request__c += 'Which State? - \n';
                if(myASR.Why_are_you_tax_exempt__c != null && myASR.Why_are_you_tax_exempt__c != '') scoe_Tax_case.New_Request__c += 'Type of Tax Exemption - ' + myASR.Why_are_you_tax_exempt__c + '\n';
                else scoe_Tax_case.New_Request__c += 'Type of Tax Exemption - \n';
                if(myASR.Employer_TIN__c != null && myASR.Employer_TIN__c != '') scoe_Tax_case.New_Request__c += 'TIN - ' + myASR.Employer_TIN__c ;
                else scoe_Tax_case.New_Request__c += 'TIN - ';
            }
            scoe_Tax_case.AccountId = myASR.Account__c;            
            scoe_Tax_case.ownerid = lstGroup[0].Id;
            system.debug('scoe_case=>'+scoe_Tax_case);
            INSERT scoe_Tax_case;
            
            if(scoe_Tax_case.Id != null)
            {
                /*Attachment taxAttachment = new Attachment();
                taxAttachment.ParentId = scoe_Tax_case.Id;
                taxAttachment.Name = fileName;
                taxAttachment.ContentType = contentType;
                taxAttachment.Body = EncodingUtil.base64Decode(base64Data);
                insert taxAttachment;
                */
                    
                ContentVersion contentVersionRec = new ContentVersion();  
                contentVersionRec.Title = fileName;  
                contentVersionRec.PathOnClient = '/' + fileName;  
                contentVersionRec.FirstPublishLocationId = scoe_Tax_case.Id;  
                contentVersionRec.VersionData = EncodingUtil.base64Decode(base64Data);  
                contentVersionRec.IsMajorVersion = true;  
                INSERT contentVersionRec;
            }    
    }
    }
        //End: by Rajendra Shahane for NAIT-135726 02931356 - Allow Reps to Attach Tax Exemption Form - Account Setup    
        
/**********************************************************************************************************************/
 //Start: by Roselin Gorllapati for https://officedepot.atlassian.net/browse/NAIT-144599  03017345 - Ability to Capture the Payment Method in the Account Setup Process
    @testVisible
    private static void createSCOECaseForPaymentMethodACH(Account_Setup_Request__c myASR)  //,Id oppId
    {
        // System.debug('oppId ACH:' + oppId);
        //List<Opportunity> lstOpp = [SELECT Id, AccountId, Account.Name FROM Opportunity WHERE Id=: oppId];
        List<Group> lstGroup = [SELECT Id FROM Group WHERE Type = 'Queue' AND DeveloperNAME = 'ACH_Request' Limit 1];// && !lstOpp.isEmpty()
        if(!lstGroup.isEmpty()) {                             
            Case scoe_paymentMethod_ACH_case = new Case();             
                scoe_paymentMethod_ACH_case.SCOE_Issue_Type__c = 'ACH Request';
                scoe_paymentMethod_ACH_case.Description = 'n/a';
                scoe_paymentMethod_ACH_case.Subject = myASR.BillTo_Name__c +' - ACH Request';//Account__c
                scoe_paymentMethod_ACH_case.RecordTypeId = SCOE_RecordTypeId;
                scoe_paymentMethod_ACH_case.Priority = '3-Medium';
                scoe_paymentMethod_ACH_case.Status = 'New';
                scoe_paymentMethod_ACH_case.Support_Requester__c = userinfo.getuserId();
                scoe_paymentMethod_ACH_case.AccountId = myASR.Account__c;            //myASR.Account__r.name;
                scoe_paymentMethod_ACH_case.ownerid = lstGroup[0].Id;
                String accountName = myASR.BillTo_Name__c;//myASR.Account__r.name;
                String salesRepName = UserInfo.getName();
                String salesRepEmail = UserInfo.getUserEmail();
                if(myASR.AP_Contact_First_Name__c == null){
                    myASR.AP_Contact_First_Name__c = '';
                }
                if(myASR.AP_Contact_Last_Name__c == null){
                    myASR.AP_Contact_Last_Name__c = '';
                }
                if(myASR.AP_Contact_Phone__c == null){
                   myASR.AP_Contact_Phone__c =''; 
                }
                if(myASR.AP_Contact_Email__c == null){
                    myASR.AP_Contact_Email__c = '';
                }
                scoe_paymentMethod_ACH_case.New_Request__c =  'Account Name : ' + accountName + '\n'+'Cust Ap Name : ' + myASR.AP_Contact_First_Name__c + ' '+ myASR.AP_Contact_Last_Name__c +'\n'+ 'Cust AP Phone : ' + myASR.AP_Contact_Phone__c +'\n'+ 'Cust AP Email : ' + myASR.AP_Contact_Email__c +'\n'+ 'Sales Rep Name : ' + salesRepName+'\n' + 'Sales Rep Email : ' + salesRepEmail +'\n'+'CTX-820 or Email Remittance : ' + myASR.CTX_820_or_Email_Remittance__c;  
            //'Account# : ' + lstOpp[0].Customer_ID__c
            INSERT scoe_paymentMethod_ACH_case;               
            system.debug('scoe_paymentMethod_ACH_case=>'+scoe_paymentMethod_ACH_case);
        }
    }

//End: by Roselin Gorllapati for https://officedepot.atlassian.net/browse/NAIT-144599  03017345 - Ability to Capture the Payment Method in the Account Setup Process
/**********************************************************************************************************************         
* @author
* @date
* @description Saves the AccountSetupRequest__c on close.
* @param String updatedRecords A json string representing the AccountSetupRequest__c
*
*/
        @AuraEnabled
        public static void commitAccountSetupRequest(String updatedRecords)
        {
            Boolean error = true;
            String message = '';
            Integer linenumber = 0;
            String dump = '';
            
            try
            {
                saveAccountSetupRequest(updatedRecords);
                error = false;
            }
            catch (ASRException e)
            {
                makeLog('ERROR', e.getMessage());
                makeLog('ERROR', e.getStackTraceString());
                throw new AuraHandledException(e.getMessage());
            }
            catch (Exception e)
            {
                makeLog('ERROR', e.getMessage());
                makeLog('ERROR', e.getStackTraceString());
                throw new AuraHandledException(genericError);
            }
        }
        
        private static void saveAccountSetupRequest(String myAccountSetupRequest)
        {
            Account_Setup_Request__c accRec = (Account_Setup_Request__c) JSON.deserialize(myAccountSetupRequest, Account_Setup_Request__c.class);
            
            // TODO: Fix this messy junk...
            if (accRec != null && String.isNotBlank(accRec.Id))
            {
                Update accRec;
            }
            else if (accRec != null && accRec.IsAccountSetUp__c == false)
            {
                Insert accRec;
                makeLog('INFO', 'New Account_Setup_Request__c Commited: Account_Setup_Request__c: ' + myAccountSetupRequest);
            }
            else
            {
                Account_Setup_Request__c NewRec = [SELECT Id FROM Account_Setup_Request__c WHERE Account__C =:accRec.Account__c limit 1];
                accRec.id = NewRec.id;
                Update accRec;
            }
        }
        
        /*******************************************************************************************************
* @author Adam Albright, adam.albright@officedepot.com
* @date 12-December-2018
* @description Adds Pricing template information to an account setup request.
* @param Account_Setup_Request__c myASR The source Account_Setup_Request__c
* @param Pricing_Template__c myPricingTemplate The source Pricing_Template__c
*/
        @testVisible()
        static Account_Setup_Request__c addPricingTemplateInfo(Account_Setup_Request__c myASR, Pricing_Template__c myPricingTemplate)
        {
            if (myASR == null || myPricingTemplate == null)
                throw new ASRException(genericError);
            
            if (myPricingTemplate.Minimum_Order_Value__c != null)
                myASR.Minimum_Order_Value__c = Decimal.valueOf(myPricingTemplate.Minimum_Order_Value__c);
            
            myASR.Off_Contract__c = myPricingTemplate.Off_Contract_Code__c;
            myASR.Off_Contract_Percent__c = myPricingTemplate.Off_Contract_Percent__c;
            myASR.Off_Wholesale__c = myPricingTemplate.Off_Wholesale_Code__c;
            myASR.Off_Wholesale_percent__c = myPricingTemplate.Off_Wholesale_percent__c;
            myASR.GP_Floor__c = myPricingTemplate.GP_Floor_Percernt__c;
            myASR.Price_Plan__c = myPricingTemplate.Price_Plan_Id__c;
            myASR.Exclude_Account_from_Universal_Pricing__c = myPricingTemplate.Exclude_Universal_Pricing__c;
            myASR.Loyalty_Type__c = myPricingTemplate.Loyalty__c;
            myASR.Deliver_Charge_Code__c = myPricingTemplate.Delivery_Code__c;
            myASR.Core_Item_Price_List_Priority_Code_1__c = myPricingTemplate.Priority_1__c;
            myASR.Core_Item_Price_List_Priority_Code_2__c = myPricingTemplate.Priority_2__c;
            myASR.Core_Item_Price_List_Priority_Code_3__c = myPricingTemplate.Priority_3__c;
            myASR.Core_Item_Price_List_Priority_Code_4__c = myPricingTemplate.Priority_4__c;
            myASR.Core_Item_Price_List_Priority_Code_5__c = myPricingTemplate.Priority_5__c;
            myASR.Core_Item_Price_List_Priority_Code_6__c = myPricingTemplate.Priority_6__c;
            myASR.Core_Item_Price_List_Priority_Code_7__c = myPricingTemplate.Priority_7__c;
            myASR.Core_Item_Price_List_Priority_Code_8__c = myPricingTemplate.Priority_8__c;
            myASR.Core_Item_Price_List_Priority_Code_9__c = myPricingTemplate.Priority_9__c;
            myASR.Core_Item_Price_List_Priority_Code_10__c = myPricingTemplate.Priority_10__c;
            myASR.Revenue_Band__c = myPricingTemplate.Revenue_Band__c;
            myASR.Core_Item_Price_List_ID_1__c = myPricingTemplate.Contract_Number_1__c;
            myASR.Core_Item_Price_List_ID_2__c = myPricingTemplate.Contract_Number_2__c;
            myASR.Core_Item_Price_List_ID_3__c = myPricingTemplate.Contract_Number_3__c;
            myASR.Core_Item_Price_List_ID_4__c = myPricingTemplate.Contract_Number_4__c;
            myASR.Core_Item_Price_List_ID_5__c = myPricingTemplate.Contract_Number_5__c;
            myASR.Core_Item_Price_List_ID_6__c = myPricingTemplate.Contract_Number_6__c;
            myASR.Core_Item_Price_List_ID_7__c = myPricingTemplate.Contract_Number_7__c;
            myASR.Core_Item_Price_List_ID_8__c = myPricingTemplate.Contract_Number_8__c;
            myASR.Core_Item_Price_List_ID_9__c = myPricingTemplate.Contract_Number_9__c;
            myASR.Core_Item_Price_List_ID_10__c = myPricingTemplate.Contract_Number_10__c;
            myASR.Off_Contract_percent__c = myPricingTemplate.Off_Contract_Percent__c;
            myASR.OPERATION__c = myPricingTemplate.Acct_Auto_Setup__c;
            myASR.Cross_Reference_Number__c = myPricingTemplate.Cust_Prod_Xref__c;
            myASR.Small_Order_Fee_Flag__c = myPricingTemplate.Freight_Charge__c;
            myASR.Rep_Comments__c = myPricingTemplate.Account_Setup_Notes_c__c;
            
            return myASR;
        }
        
        /*******************************************************************************************************
* @author Adam Albright, adam.albright@officedepot.com
* @date 12-December-2018
* @description Ads the Primary Site information to the account setup request.
* @param Account_Setup_Request__c myASR The source Account_Setup_Request__c
* @param Account myPrimarySite The source PrimarySiteAccount
* @return Account_Setup_Request__c with primary account site information added.
*/
        @testVisible
        static Account_Setup_Request__c addPrimarySiteInformation(Account_Setup_Request__c myASR, Account myPrimarySite)
        {
            if (myASR == null || myPrimarySite == null)
                throw new ASRException(genericError);
            
            //Bill to DEtails
            myASR.Street_Address_Bill__c = myPrimarySite.Address1__c;
            myASR.Street_Address_2_Bill__c = myPrimarySite.Address2__c;
            myASR.State_Bill__c = myPrimarySite.State__c;
            myASR.Zip_Bill__c = myPrimarySite.zip__c;
            myASR.City_Bill__c = myPrimarySite.City__c;
            myASR.BILL_COUNTRY__c = myPrimarySite.Country__c;
            // Ship to DEtails
            myASR.ShipTo_Name__c = myPrimarySite.Name;
            myASR.Street_Address_Ship__c = myPrimarySite.Address1__c;
            myASR.Street_Address_2_Ship__c = myPrimarySite.Address2__c;
            myASR.State_Ship__c = myPrimarySite.State__c;
            myASR.Zip_Ship__c = myPrimarySite.Zip__c;
            myASR.City_Ship__c = myPrimarySite.City__c;
            myASR.SHIP_COUNTRY__c = myPrimarySite.Country__c;
            myASR.SHIPTO_ORACLE_PARTY_SITE_ID__c = myPrimarySite.Oracle_Party_Site_ID__c;
            return myASR;
        }
        
        /*******************************************************************************************************
* @author Adam Albright, adam.albright@officedepot.com
* @date 12-December-2018
* @description Adds the primary contact information to the account setup request
* @param Account_Setup_Request__c myASR The source Account_Setup_Request__c
* @param Contact myPrimaryContact The source Primary Contact.
* @return Account_Setup_Request__c with primary account site information added.
*
*/
        @testVisible
        static Account_Setup_Request__c addPrimaryContactInformation(Account_Setup_Request__c myASR, Contact myPrimaryContact)
        {
            if (myASR == null || myPrimaryContact == null)
                throw new ASRException(genericError);
            
            myASR.Primary_Contact_Email__c = myPrimaryContact.Email;
            myASR.Primary_Contact_Fax__c = myPrimaryContact.Fax;
            myASR.Primary_Contact_First_Name__c = myPrimaryContact.FirstName;
            myASR.Primary_Contact_Job_Title__c = myPrimaryContact.Title;
            myASR.Primary_Contact_Last_Name__c = myPrimaryContact.LastName;
            myASR.Primary_Contact_Mobile_Phone__c = myPrimaryContact.MobilePhone;
            myASR.Primary_Contact_Phone__c = myPrimaryContact.Phone;
            //myASR.Primary_contact_role__c = myPrimaryContact.Role__c;
            myASR.Primary_Contact_Salutation__c = myPrimaryContact.Salutation;
            return myASR;
        }
        
        /*******************************************************************************************************
* @author Adam Albright, adam.albright@officedepot.com
* @date 12-December-2018
*
* @description Adds the primary contact information to the account setup request
* @param Account_Setup_Request__c myASR The source Account_Setup_Request__c
* @param Contact myPrimaryContact The source Primary Contact.
* @return Account_Setup_Request__c with primary account site information added.
*
*/
        @testVisible
        static Account_Setup_Request__c addAccountInformation(Account_Setup_Request__c myASR, Account myAccountToSetup)
        {
            // Get Details From Account Object
            
            if (myASR == null || myAccountToSetup == null)
                throw new ASRException(genericError);
            
            myASR.Add_Parent_ID__c = myAccountToSetup.Related_Pricing_Template_Account__r.AOPS_Cust_Id__c;
            myASR.Account__c = myAccountToSetup.Id;
            myASR.BillTo_Name__c = myAccountToSetup.Name;
            myASR.Account_Owner__c = myAccountToSetup.OwnerId;
            myASR.Account_Phone__c = myAccountToSetup.Phone;
            myASR.Segment__c = myAccountToSetup.Segment__c;
            myASR.Duns_Number__c = myAccountToSetup.Duns_Number__c;
            myASR.Ultimate_Duns_Number__c = myAccountToSetup.Ultimate_Duns_Number__c;
            myASR.Invoice_Payment_Method__c = myAccountToSetup.Payment_Term__c;
            myASR.Est_Spend__c = myAccountToSetup.Est_Spend__c;
            myASR.ORACLE_PARTY_ID__c = myAccountToSetup.Oracle_Party_ID__c;
            myASR.Rep_ID__c = myAccountToSetup.Sales_PersonID__r.name;
            
            if (myAccountToSetup.Org_WCW_Count_Rep__c == null || myAccountToSetup.Org_WCW_Count_Rep__c < 0)
            {
                myASR.Number_of_WCW_employees__c = '0'; // TODO: Check with Jayna Marshal/ Business
            }
            else
            {
                myASR.Number_of_WCW_employees__c = String.valueOf(myAccountToSetup.Org_WCW_Count_Rep__c);
            }
            
            
            if (myAccountToSetup.Est_Spend__c > 250000 && myAccountToSetup.Payment_Term__c == 'Account Billing')
            {
                myASR.Show_Net_30_Question__c = true;
                myASR.Show_Net_20__c = true;
            }
            else if (myAccountToSetup.Payment_Term__c == 'Credit Card')
            {
                myASR.Show_Net_20__c = false;
                myASR.Show_Net_30_Question__c = false;
            }
            else
            {
                myASR.Show_Net_30_Question__c = false;
                myASR.Show_Net_20__c = true;
            }
            
            return myASR;
        }
        
        /*******************************************************************************************************
* @author Adam Albright, adam.albright@officedepot.com
* @date 10-December-2018
*
* @description Gets the account data and sets up an account setup request.
* @param String OppId The Id of the opportunity we are using to setup the account.
*/
        @AuraEnabled
        public static Account_Setup_Request__c getAccountData(String OppId)
        {
            try
            {
                Account_Setup_Request__c myASR = makeAccountSetupRequest(OppId);
                return myASR;
            }
            catch (ASRException e)
            {
                makeLog('ERROR', e.getMessage());
                makeLog('ERROR', e.getStackTraceString());
                throw new AuraHandledException(e.getMessage());
            }
            catch (Exception e)
            {
                makeLog('ERROR', e.getMessage());
                makeLog('ERROR', e.getStackTraceString());
                throw new AuraHandledException(genericError);
            }
        }
        
        static Account_Setup_Request__c makeAccountSetupRequest(String OppId)
        {
            if (OppId == null || OppId == '')
            {
                throw new ASRException('Opportunity Id is invalid or could not be found, please put in a Support Ticket with the subject: Request customer setup is not functioning.');
            }
            
            Id myAccountId;
            Account accountToSetup = new Account();
            Contact primaryContact = new Contact();
            Account_Setup_Request__c newSetupRequest = new Account_Setup_Request__c();
            
            myAccountId = [SELECT AccountId FROM Opportunity WHERE Id =:OppId].AccountId;
            
            
            accountToSetup = [
                SELECT
                RecordType.Name,
                DNBI_CREDIT_OUTCOME__c,
                Name,
                Est_Spend__c,
                Org_WCW_Count_Rep__c,
                Sic,
                ownerid,
                Sales_PersonID__r.name,
                Owner.name,
                Duns_Number__c,
                Ultimate_Duns_Number__c,
                Phone,
                Phone_Ext__c,
                setup_url1__c,
                Related_Account__c,
                Oracle_Party_ID__c,
                Industry_OD_SIC_Rep__c,
                Segment__c, Sector__c,
                Pricing_template_cd__c,
                Related_Pricing_Template_Account__r.Cust_Id__c,
                Payment_Term__c,
                Related_Parent_Account__c,
                Related_Pricing_Template_Account__r.AOPS_Cust_Id__c
                FROM Account WHERE id =:myAccountId
            ];
            
            List <Account_Setup_Request__c> myOldSetupRequests = new List <Account_Setup_Request__c> ();
            
            myOldSetupRequests = [SELECT Id, BillTo_Name__c, Account_Phone__c, Street_Address_Bill__c, Street_Address_2_Bill__c, City_Bill__c, State_Bill__c,
                                  Zip_Bill__c, BILL_COUNTRY__c, Street_Address_Ship__c, Street_Address_2_Ship__c, City_Ship__c, State_Ship__c, Zip_Ship__c, ShipTo_Name__c,
                                  SHIP_COUNTRY__c, Primary_Contact_First_Name__c, Primary_Contact_Last_Name__c, Primary_Contact_Phone__c, Primary_Contact_Fax__c,
                                  Primary_Contact_Email__c, Does_your_Customer_have_any_ordering_pr__c, Special_Delivery_Requirements__c, Off_Contract_percent__c,
                                  EDI_or_Punch_Out__c, Billing_Delivery_Method_Media_type__c, AP_Contact_Salutation__c, AP_Contact_First_Name__c,
                                  AP_Contact_Last_Name__c, AP_Contact_Email__c, AP_Contact_Phone__c, AP_Contact_Fax__c, eBilling_Contact_Salutation__c, eBilling_Contact_First_Name__c,
                                  eBilling_Contact_Last_Name__c, eBilling_Contact_Phone__c, eBilling_Contact_Email__c, Monthly_eStatement_Email__c, eBilling_Contact_Salutation2__c,
                                  eBilling_Contact_First_Name2__c, eBilling_Contact_Last_Name2__c, eBilling_Contact_Phone2__c, eBilling_Contact_Email2__c, eBilling_Contact_Fax2__c,
                                  PD_Incl_Backup_Inc__c, Monthly_eStatements__c, Early_Pay_Discount_Needed__c, PD_multiple_bill_to_locations__c, Billing_Frequency__c,
                                  Employer_TIN__c, What_is_the_payment_method__c, CTX_820_or_Email_Remittance__c, Is_IRS_W9_Required_for_AP__c, Tax_Exempt__c, Tax_Exempt_States__c, Why_are_you_tax_exempt__c, Goverment_Branch__c,
                                  Rep_Comments__c, Account__c, ACCOUNT_ID__c, Account__r.name, IsAccountSetUpSubmitted__c, IsAccountSetUp__c,
                                  PO__c, Desktop__c, Rename_Cost_Center__c, Rename_Release__c, Cost_Center__c, Release__c, Rename_Purchase_Order__c,
                                  Rename_Desktop__c, Minimum_Order_Value__c, Budgets_CC_PO__c, Print_Invoice__c, Display_Purchase_Orders__c,
                                  Display_Payment_Method__c, Display_Prices__c, Backorders_displayed_on_packing_list__c, Rename_Packlist__c, Show_Net_30_Question__c,
                                  Account__r.Est_Spend__c, Account__r.Payment_Term__c, Show_Net_20__c,
                                  PD_Doc_Name__c, DML__c, Segment__c
                                  FROM Account_Setup_Request__c WHERE Account__c =:myAccountId ORDER BY LastModifiedDate DESC
                                 ];
            
            
            // IF we have multiple request already, log warning and net the new request to the first entry of the list.
            if (myOldSetupRequests.size() > 1)
            {
                // Log Warning/Info
                makeLog('WARNING', 'Multiple Account Setup requests associated with account: ' + myAccountId);
                newSetupRequest = myOldSetupRequests[0];
                
                // If we have already set all this up before, we do not have to set it up again.
                return newSetupRequest;
            }
            else if (myOldSetupRequests.size() == 1)
            {
                // Dont need to this...
                newSetupRequest = myOldSetupRequests[0];
            }
            
            
            //Get Account information for the account we want to set up.
            newSetupRequest = addAccountInformation(newSetupRequest, accountToSetup);
            
            /*******************************
* GEt the Primary site account for address information.
*/
            Account primarySiteAccount = new Account();
            List <Account> accountSites = [
                SELECT id, Name, Oracle_Party_Site_ID__c, Address1__c, Address2__c, City__c, State__c, Zip__c, Country__c
                FROM Account
                WHERE RecordTypeId =:Account_Site_RecordTypeId AND Primary_Site__c = true AND Related_Account__c =:myAccountId
            ];
            
            if (accountSites.size() == 0)
            {
                // Looks like we have no primary sites. Log Error and Abort
                throw new ASRException('You must have a primary site selected before continuing. If you have added a site please remember to flag it as primary by selecting the "primary site" checkbox.');
                
            }
            else if (accountSites.size() > 1)
            {
                throw new ASRException('You currently have 2 or more sites flagged as primary - you must SELECT only one of these as the primary in order to request a customer setup.');
            }
            
            primarySiteAccount = accountSites[0];
            
            //Bill to Details
            newSetupRequest = addPrimarySiteInformation(newSetupRequest, primarySiteAccount);
            
            /*******************************
* Look for primary contacts
*/
            List <Contact> primaryContactList = [SELECT id, Salutation, FirstName, LastName, Title, Phone, Fax, Email, role__c, MobilePhone
                                                 FROM Contact WHERE AccountId =:myAccountId AND Primary_Contact__c = true
                                                ];
            
            if (primaryContactList.size() == 1)
            {
                makeLog('INFO', 'Primary Contact with Id: ' + primaryContactList[0].Id + ' Linked');
            }
            // If We get to many, we need to error and abort.
            else if (primaryContactList.size() > 1)
            {
                // Looks like we have multiple primary contacts. Log and abort
                throw new ASRException('Multiple Primary contacts found. Please only one contact is active and primary.');
            }
            else if (primaryContactList.size() == 0)
            {
                throw new ASRException('No primary Contact found');
            }
            primaryContact = primaryContactList[0];
            
            // Add Primary Contact Information
            newSetupRequest = addPrimaryContactInformation(newSetupRequest, primaryContact);
            
            // Get the pricing template from the pricing template code on the account we want to set up.
            Pricing_Template__c pricingTemp = new Pricing_Template__c();
            
            List <Pricing_Template__c> pricingTemplates = [
                SELECT Id, Name, Parent_Id__c, Off_Contract_Code__c, Off_Contract_Percent__c,
                Off_Wholesale_Code__c, Off_Wholesale_percent__c, GP_Floor_Percernt__c, Price_Plan_Id__c,
                Exclude_Universal_Pricing__c, Loyalty__c, Minimum_Order_Value__c, Delivery_Code__c, Contract_Number_1__c,
                Priority_1__c, Contract_Number_2__c, Priority_2__c, Contract_Number_3__c, Priority_3__c, Contract_Number_4__c,
                Priority_4__c, Contract_Number_5__c, Priority_5__c, Contract_Number_6__c, Priority_6__c, Contract_Number_7__c,
                Priority_7__c, Contract_Number_8__c, Priority_8__c, Contract_Number_9__c, Priority_9__c, Contract_Number_10__c,
                Priority_10__c, Revenue_Band__c, Freight_Charge__c, Cust_Prod_Xref__c, Acct_Auto_Setup__c, Account_Setup_Notes_c__c
                FROM Pricing_Template__c WHERE Template__c =:accountToSetup.Pricing_template_cd__c
            ];
            
            if (pricingTemplates.size() == 0)
            {
                throw new ASRException('A pricing template is not linked for this prospect, ' + accountToSetup.Name + '. Please select a pricing template for this prospect.');
            }
            else
            {
                pricingTemp = pricingTemplates[0];
                newSetupRequest = addPricingTemplateInfo(newSetupRequest, pricingTemp);
            }
            
            makeLog('INFO', 'New Account Setup Request created: ' + JSON.serialize(newSetupRequest));
            return newSetupRequest;
        }
        
        /*******************************************************************************************************
* @author Adam Albright, adam.albright@officedepot.com
* @date 15-January-2019
* @description Aura Wrapper for retrieving the states map.
* @param
*/
        @AuraEnabled
        public static Map <String, Boolean> getStatesMap(List <String> allStates, String selectedStates)
        {
            try
            {
                return retrieveStatesMap(allStates, selectedStates);
            }
            catch (Exception e)
            {
                makeLog('ERROR', e.getMessage());
                makeLog('ERROR', e.getStackTraceString());
                throw new AuraHandledException(genericError);
            }
        }
        
        static Map <String, Boolean> retrieveStatesMap(List <String> allStates, String selectedStates)
        {
            Map <String, Boolean> map_states = new map <String, Boolean> ();
            for (String state: allStates)
            {
                map_states.put(state, false);
            }
            
            if (selectedStates != null)
            {
                selectedStates = (String) JSON.deserialize(selectedStates, String.class);
                for (String state: selectedStates.split(','))
                {
                    map_states.put(state, true);
                }
            }
            
            return map_states;
        }
        
        /*******************************************************************************************************
* @author Adam Albright, adam.albright@officedepot.com
* @date 15-January-2019
* @description Aura Wrapper for retrieving DML Data
* @param
*/
        @AuraEnabled
        public static Map <Id, String> getDMLData(String OppId)
        {
            try
            {
                return retrieveDMLData(OppId);
            }
            catch (Exception e)
            {
                makeLog('ERROR', e.getMessage());
                makeLog('ERROR', e.getStackTraceString());
                throw new AuraHandledException(genericError);
            }
        }
        
        static Map <Id, String> retrieveDMLData(String OppId)
        {
            Map <Id, String> dmlList = new Map <Id, String> ();
            List <DML_Relation__c> dmlRelatedList = new List <DML_Relation__c> ();
            Id orgId = [SELECT account.org__C FROM Opportunity WHERE Id =:OppId].account.org__C;
            Id ParentOrg = [SELECT account.org__r.parent_org__C FROM Opportunity WHERE Id =:OppId].account.org__r.parent_org__C;
            
            if (ParentOrg != null && orgId != null)
            {
                dmlRelatedList = [SELECT Decision_Maker_Name__c, DML__c, DML_Details__c FROM DML_Relation__c WHERE Org__c =:orgId OR Org__c =:ParentOrg];
                for (DML_Relation__c rec: dmlRelatedList)
                {
                    if (!dmlList.containskey(rec.DML__c))
                        dmlList.put(rec.DML__c, rec.DML_Details__c);
                }
            }
            else if (orgId != null)
            {
                dmlRelatedList = [SELECT Decision_Maker_Name__c, DML__c, DML_Details__c FROM DML_Relation__c WHERE Org__c =:orgId];
                for (DML_Relation__c rec: dmlRelatedList)
                {
                    if (!dmlList.containskey(rec.DML__c))
                        dmlList.put(rec.DML__c, rec.DML_Details__c);
                }
            }
            
            return dmlList;
        }
        
        /*******************************************************************************************************
* @author Adam Albright, adam.albright@officedepot.com
* @date 15-January-2019
* @description Wrapper for newDMLOption
* @param
*/
        @AuraEnabled
        public static Map <Id, String> CreateDMLOption(String OppId, String jsonDMLRecord)
        {
            try
            {
                return newDMLOption(OppId, jsonDMLRecord);
            }
            catch (Exception e)
            {
                makeLog('ERROR', e.getMessage());
                makeLog('ERROR', e.getStackTraceString());
                throw new AuraHandledException(genericError);
            }
        }
        
        static Map <Id, String> newDMLOption(String OppId, String jsonDMLRecord)
        {
            DML__c newDMLRecord;
            try
            {
                newDMLRecord = (DML__c) JSON.deserialize(jsonDMLRecord, DML__c.class);
            }
            catch (JSONException e)
            {
                throw new ASRException(genericError);
            }
            catch (NullPointerException e)
            {
                throw new ASRException(genericError);
            }
            
            Map <Id, String> dmlList = new Map <Id, String> ();
            String getLabelName = Label.DML_Link;
            Org__c org;
            Id orgId = [SELECT Account.org__C FROM Opportunity WHERE Id =:OppId].Account.org__C;
            if (orgId != null)
            {
                org = [SELECT Employee_Count__c, Global_Ultimate_Employee_Count__c FROM Org__c WHERE Id =:orgId];
            }
            Id accId = [SELECT AccountId FROM Opportunity WHERE Id =:OppId].AccountId;
            Account accountToSetup = new Account();
            if (newDMLRecord == null)
            {
                return dmlList;
            }
            newDMLRecord.Status__c = 'Draft';
            newDMLRecord.Effective_Start_Date__c = Date.today();
            if (org != null)
            {
                if (org.Global_Ultimate_Employee_Count__c != null)
                    newDMLRecord.Employee_Count__c = decimal.valueof(org.Global_Ultimate_Employee_Count__c);
                else
                    newDMLRecord.Employee_Count__c = org.Employee_Count__c;
            }
            Insert newDMLRecord;
            dmlList.put(newDMLRecord.id, newDMLRecord.DECISION_MAKER_NM__c);
            List <Account> acclist = [SELECT id, name FROM Account WHERE id =:accid];
            Account acc = new Account();
            acc.Id = accId;
            acc.Related_DML__C = newDMLRecord.Id;
            Update acc;
            Case newCase = new Case();
            newCase.accountId = accId;
            newCase.Support_Type__c = 'Deployment';
            newCase.Support_Sub_Type__c = 'New DML Exception';
            newCase.subject = acclist[0].Name;
            newCase.RecordTypeId = DR_RecordTypeId;
            newCase.Comments = newDMLRecord.Notes__c;
            newCase.Description = 'Account Name :' + ' ' + acclist[0].Name + '\n' + 'Request Type: New DML Exception' + '\n' + 'Reason For DML Creation:' + ' ' + newDMLRecord.Reason_for_Creation__c + '\n' + 'Please check the DML by clicking this link:' + '  ' + System.Label.DML_Link + newDMLRecord.id;
            Insert newCase;
            newDMLRecord.Notes__c = '';
            Update newDMLRecord;
            return dmlList;
        }
        
        /*******************************************************************************************************
* @author Adam Albright, adam.albright@officedepot.com
* @date 15-January-2019
* @description Wrapper for retrieveAltDML
* @param
*/
        @AuraEnabled
        public static Map <String, String> getAltDML(String OppId)
        {
            try
            {
                return retrieveAltDML(OppId);
            }
            catch (Exception e)
            {
                makeLog('ERROR', e.getMessage());
                makeLog('ERROR', e.getStackTraceString());
                throw new AuraHandledException(genericError);
            }
        }
        
        static Map <String, String> retrieveAltDML(String OppId)
        {
            Map <Id, String> AltDMLMap = new Map <Id, String> ();
            Map <String, String> MapAggr = new Map <String, String> ();
            List <Alternate_DML__c> AltDML = new List <Alternate_DML__c> ();
            Id orgId = [SELECT account.org__C FROM Opportunity WHERE Id =:OppId].account.org__C;
            if (orgId != null)
            {
                String Duns = [SELECT GLOBAL_ULTIMATE_DUNS_NUM__c FROM Org__c WHERE id =:orgId LIMIT 1].GLOBAL_ULTIMATE_DUNS_NUM__c;
                if (Duns != null)
                {
                    List <AggregateResult> AltaggList = [SELECT Id, OPERATIONAL_DUNS_NUM__c, OPERATIONAL_ULTIMATE_DUNS_NUM__c, BUSINESS_NAME__c, STREET_ADDR__c, CITY__c, STATE__c, ZIP_CODE__c FROM Alternate_DML__c WHERE GLOBAL_ULTIMATE_DUNS_NUM__c =:duns
                                                         group by Id, OPERATIONAL_DUNS_NUM__c, OPERATIONAL_ULTIMATE_DUNS_NUM__c, BUSINESS_NAME__c, STREET_ADDR__c, CITY__c, STATE__c, ZIP_CODE__c];
                    for (AggregateResult ar: AltaggList)
                    {
                        String KepMaptask = (String) ar.get('Id');
                        String str1 = (String) ar.get('BUSINESS_NAME__c');
                        String str2 = (String) ar.get('STREET_ADDR__c');
                        String str3 = (String) ar.get('ZIP_CODE__c');
                        String str4 = (String) ar.get('CITY__c');
                        String str5 = (String) ar.get('STATE__c');
                        String str6 = (String) ar.get('OPERATIONAL_DUNS_NUM__c');
                        String ValMap;
                        
                        if (str1 != null && str2 != null && str3 != null && str4 != null && str5 != null && str6 != null)
                        {
                            ValMap = str1 + '--' + str2 + '--' + str3 + '--' + str4 + '--' + str5 + '--' + str6;
                        }
                        else if (str1 != null && str2 != null)
                        {
                            ValMap = str1 + '--' + str2;
                        }
                        else if (str2 != null && str3 != null)
                        {
                            ValMap = str2 + '--' + str3;
                        }
                        else if (str1 != null && str3 != null)
                        {
                            ValMap = str1 + '--' + str3;
                        }
                        else
                        {
                            ValMap = str1 + '--' + str6;
                        }
                        MapAggr.put(KepMaptask, ValMap);
                    }
                }
            }
            return MapAggr;
        }
        
        /*******************************************************************************************************
* @author Adam Albright, adam.albright@officedepot.com, 19 January 2019
* @description
* @param
*/
        @AuraEnabled
        public static String CreateAltDML(String AltDMLId)
        {
            try
            {
                return makeAltDML(AltDMLId);
            }
            catch (Exception e)
            {
                makeLog('ERROR', e.getMessage());
                makeLog('ERROR', e.getStackTraceString());
                throw new AuraHandledException('An error occured while setting up the new DML. Please create a ticket with message "Account Setup is not working."');
            }
        }
        
        static String makeAltDML(String AltDMLId)
        {
            Alternate_DML__c AltDML = [SELECT id, Alternative_DML_Details__c, BUSINESS_NAME__c, ZIP_CODE__c, STREET_ADDR__c FROM Alternate_DML__c WHERE id =:AltDMLId];
            DML__c alternateDMLRecord = new DML__c();
            alternateDMLRecord.DECISION_MAKER_NM__c = AltDML.BUSINESS_NAME__c;
            alternateDMLRecord.DECISION_MAKER_ZIP_CD__c = AltDML.ZIP_CODE__c;
            alternateDMLRecord.DML_City__c = AltDML.STREET_ADDR__c;
            alternateDMLRecord.Effective_Start_Date__c = Date.today();
            Insert alternateDMLRecord;
            return alternateDMLRecord.DECISION_MAKER_NM__c;
        }
        
        @AuraEnabled
        public static Alternate_DML__c CreateSugAltDML(String AltDMLId)
        {
            Alternate_DML__c AltDML = [SELECT Id, Alternative_DML_Details__c, BUSINESS_NAME__c, ZIP_CODE__c, STREET_ADDR__c FROM Alternate_DML__c WHERE id =:AltDMLId];
            Return AltDML;
        }
        
        /*******************************************************************************************************
* @author Adam Albright, adam.albright@officedepot.com
* @date 12-December-2018
* @description Logs a fatal error and throws an exception.
* @param String Criticality How big of an issue is it?
* @param String message The message to log
*/
        public static void makeLog(String criticality, String full_message)
        {
            EventLog__e myEventLog = new EventLog__e
                (
                    Source__c = 'AccountSetUpController',
                    Full_Message__c = full_message,
                    Log_Level__c = criticality
                );
            
            Database.SaveResult sr = EventBus.publish(myEventLog);
            
            if (!sr.isSuccess())
            {
                for (Database.Error err : sr.getErrors())
                {
                    System.debug('Error returned: ' +
                                 err.getStatusCode() +
                                 ' - ' +
                                 err.getMessage());
                }
            }
        }
        
    /*******************************************************************************************************
    * @author Sandesh Ganjare 03 August 2020
    * @description Create SCOE type case (NAIT-142291)
    * @param newrequest=> Q/A note,oppId=> Opportunity, file=>File content, fileName=> Name of attachment
    */        
    @AuraEnabled
    public static void CreateSCOETicket(string newrequest, Id oppId, string file, string fileName){
        System.debug('newrequest:' + newrequest);
        System.debug('oppId:' + oppId);
        Savepoint case_Savepoint;
        try{
            case_Savepoint = Database.setSavepoint();
            List<Opportunity> lstOpp = [SELECT Id, AccountId, Account.Name FROM Opportunity WHERE Id=: oppId];
            List<Group> lstGroup = [SELECT Id FROM Group WHERE Type = 'Queue' AND DeveloperNAME = 'Implementation_Support_Queue' Limit 1];
            if(!lstGroup.isEmpty() && !lstOpp.isEmpty()){
                Case scoe_case = new Case();
                scoe_case.RecordTypeId = SCOE_RecordTypeId;
                scoe_case.Priority = '3-Medium';
                scoe_case.Description = 'n/a';
                scoe_case.SCOE_Issue_Type__c = 'Implementation/Field eCommerce Request';
                scoe_case.SCOE_Support_Type__c = 'Onboard new customer business';
                scoe_case.Subject = lstOpp[0].Account.Name+'- Onboard new customer business';
                scoe_case.New_Request__c = newrequest;
                scoe_case.Support_Type__c = 'Salesforce.com';
                scoe_case.AccountId = lstOpp[0].AccountId;
                scoe_case.Support_Requester__c = userinfo.getuserId();
                scoe_case.ownerid = lstGroup[0].Id;
                system.debug('scoe_case=>'+scoe_case);
                INSERT scoe_case;
                
                if(file != null && file != ''){
                    String base62File = EncodingUtil.urlDecode(file, 'UTF-8');     
                    ContentVersion contentVersionRec = new ContentVersion();  
                    contentVersionRec.Title = fileName;  
                    contentVersionRec.PathOnClient = '/' + fileName;  
                    contentVersionRec.FirstPublishLocationId = scoe_case.Id;  
                    contentVersionRec.VersionData = EncodingUtil.base64Decode(base62File);  
                    contentVersionRec.IsMajorVersion = true;  
                    INSERT contentVersionRec;
                }
            }
        }catch(exception e){
            Database.rollback(case_Savepoint);
            throw new ASRException(genericError);
        }       
    }

     /*******************************************************************************************************
     * @author Sandesh Ganjare
     * @date 13-August-2020
     * @description By pass the Account Setup Questions for set of profiles for aaccount setup process (NAIT-148117)
     * @param 
     */
    @AuraEnabled
    public static Boolean getProfileCheck(){
        try{            
            Boolean showQuestions = true;
            Account_Setup_Settings__c mc = Account_Setup_Settings__c.getValues('Bypass Implementation Questions');
            if(mc != null){
                String Profiles = mc.Values__c;
                List<Profile> currentUserProfile = [SELECT Id, Name FROM Profile WHERE Id =:UserInfo.getProfileId() LIMIT 1];
                if(Profiles!= null && !currentUserProfile.isEmpty()){
                    if(Profiles.indexOf(',') > -1){
                        List<String> ProfileList = Profiles.split(',');
                        for(Integer i=0;i<ProfileList.size();i++){
                            if(currentUserProfile[0].Name == ProfileList[i].trim()){
                                showQuestions = false;
                                break;
                            }
                        }
                    }else{
                        if(currentUserProfile[0].Name == Profiles.trim()){
                            showQuestions = false;
                        }
                    }                
                }
            }                       
            return showQuestions;
        } catch(Exception e){
            makeLog('ERROR', e.getMessage());
            makeLog('ERROR', e.getStackTraceString());
            throw new AuraHandledException(genericError);
        }
    }    
}