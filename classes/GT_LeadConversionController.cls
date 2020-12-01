/**************************************************************
*Name           : GT_LeadConversionController
*Created By     : Wipro Technologies
*Created Date   : 20th September 2014
*Purpose        : To convert lead for Canada
********************************************************************/
public with sharing class GT_LeadConversionController{
    private final Lead lead = null;
    public Boolean isLeadValidationSuccessful {get;set;}
    public List<Account> lstMatchingAccount {get;set;}
    public List<Contact> lstMatchingContact {get;set;}
    public Boolean isCreateNewProspect{get;set;}
    public Boolean isCreateNewContact{get;set;}
    public Boolean isUseExistingContact{get;set;}
    public String isProspect{get;set;}
    public boolean buttonRenderer{get;set;}
    public boolean isCreateOpportunity{get;set;}
    public Boolean notvalidadd{get;set;}  
    public Boolean addressValidation; 
    public string addressValidationMsg;
    Public string SalesPersonId1{get;set;}
    Public List <Sales_Person__c> SalesPersonId{get;set;}
    public Boolean GTLead; 
    public id salesPersonSFDCId;
    
    //Canada
    public List<Account> lstMatchingGTAccount {get;set;}
    
    //Changes for case - 114344 begins
    public Account tmpAccount {get;set;}
    public boolean displayInputData {get;set;}
   
    public void setAdditionalInput() {
        displayInputData = true;
    }
    
    public void unsetAdditionalInput() {
        displayInputData = false;
    }
    
    //Changes for case - 114344 ends
    
    // Constructor
    public GT_LeadConversionController(ApexPages.StandardController controller) {
        //Changes for case - 114344 begins
        tmpAccount = new Account();
        Recordtype rt = [SELECT id FROM recordtype where name = 'Prospect (GT)' and SobjectType = 'Account'];
        tmpAccount.recordtypeid = rt.id;
        displayInputData = true;
        //Changes for case - 114344 ends
        
        isCreateNewProspect = true;
        //isCreateNewContact = false;
        isCreateNewContact = true;
        isUseExistingContact = false;
        isLeadValidationSuccessful = false;
        buttonRenderer = false;
        isProspect = 'false'; 
        isCreateOpportunity = true; 
        addressValidation = false;
        //addressValidationMsg = 'Address outside USA';
        lead = (Lead)controller.getRecord();
        Recordtype Leadrt = [SELECT id FROM recordtype where name = 'Lead (Canada)' and SobjectType = 'Lead'];
        
        
        lstMatchingGTAccount = getMatchingGTAccounts();
        system.debug('@@@@@@@lstMatchingGTAccount '+lstMatchingGTAccount );
        if (lstMatchingGTAccount.size() > 0)
          displayInputData = false;  
            
        lstMatchingAccount = getMatchingAccounts();
        if (lstMatchingAccount.size() > 0)
          displayInputData = false;
        
        if(lead.Account__c != null){ 
          selectedAccountId = lead.Account__c;       
        }
       
        if(lead.recordtypeid==Leadrt.id){
        GTLead = true;}
        
        if(lead.Sales_Person_ID__c == null)
        {
        try {
        SalesPersonId = [select id,name,ExtIDSalesPerson__c from Sales_Person__c where user__c =:UserInfo.getUserId()  And IsActive__c=True And Primary__c=True limit 1];
        }
        catch(Exception ex) {
            system.debug('Exception'+ex);
        }
        
          if(SalesPersonID==null && salesPersonId.isEmpty()){
              ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error,'User creating Account does not have a valid SalesPerson ID')); }
           if( SalesPersonID!=null && !SalesPersonId.isEmpty()){
              SalesPersonID1=SalesPersonID[0].ExtIDSalesPerson__c;
              salesPersonSFDCId = SalesPersonID[0].id;
           }
        
        }
      
        lstMatchingContact = getMatchingContacts();
        if(lead.Account__c != null && lstMatchingContact.size() == 0 ){
          buttonRenderer = true;
        }
        else if(lead.Account__c == null && lstMatchingAccount.size() == 0){
          buttonRenderer = true;
        }
        else if(lead.Account__c == null && lstMatchingGTAccount.size() == 0){
          buttonRenderer = true;
        }
    }
    
    /******************************************Generate records*******************************************************/
    
    
    /************************************************************Validation Address*****************************************************/
    public Boolean validateAddress()
        {
            try{
                // instantiate webservice 
                //Addressvalidation.AOPS_G1_AddressValidation avws = new Addressvalidation.AOPS_G1_AddressValidation();
                
                // instantiate response variable
                //Addressvalidation.AOPS_G1_AddressValidationProcessResponse_element result =new Addressvalidation.AOPS_G1_AddressValidationProcessResponse_element();
                G1AddressValidation.G1AddressValidationService_pt   av = new G1AddressValidation.G1AddressValidationService_pt  ();
                G1AddressValidation.CustomerResponseType result= new G1AddressValidation.CustomerResponseType();                
                
                //New change for the Security
                av.inputHttpHeaders_x = new Map<String, String>();
                String myData = 'sfdcuser:sfdcuser123';       
                
                String encodedusernameandpassword = EncodingUtil.base64Encode(Blob.valueOf(myData));
                av.inputHttpHeaders_x.put('Authorization', 'Basic '+ encodedusernameandpassword);
                
                //End New change for the Security

                
                G1AddressValidation.CustomerType ct = new G1AddressValidation.CustomerType();
                G1AddressValidation.AddressType oAddress = new G1AddressValidation.AddressType();
                  
                        oAddress.StreetNameOne = lead.address1__c;
                        oAddress.StreetNameTwo = ''; 
                        oAddress.PostOfficeBox = '';
                        oAddress.CityName = lead.City__c;
                        oAddress.StateName = lead.state__c;
                        oAddress.ZipCode = lead.zip__c;
                        oAddress.Province ='';
                        oAddress.Country=lead.country__c;
                        oAddress.GeographicalCodeOne=0;
                        oAddress.GeographicalCodeTwo=0;
                        oAddress.CountyName='';
                        oAddress.Urbanization='';
                        oAddress.DeliveryPointCode='';
                        oAddress.ResidentialDeliveryIndicator='';
                
                        ct.ClientName = 'G';
                        ct.ApplicationName = 'AM';
                        ct.BusinessName = lead.name;
                        ct.ValidateAddress = 'Y';
                        ct.DetailGeographicalCode = 'N';
                        ct.IfMultipleOriginReturnOrigin = 'N';
                        ct.AddressValidated = 'N';
                        ct.AddressOverriden = 'N';
                        ct.MiscellaneousDataCleanup = 'Y';
                        ct.Address = oAddress;
                        System.debug('>>>>>>>>>>>>>>>>>>>>ALL GOOD');
                        result= av.process(ct);
                        System.debug('result**'+result);
                        
                // execute Web service.
                notvalidadd=false;
                
                lead.zip__c =  result.Address.ZipCode;
                lead.address1__c = result.Address.StreetNameOne ;
                lead.City__c = result.Address.CityName;
                lead.state__c =   result.Address.StateName ;
                lead.Country__c = result.Address.Country;
                //lead.name= result.BUSINESS_NAME;
                
                String  adrRc = string.valueof(result.AddressReturnCode);
                String  adrErrMsg = result.ErrorMessage.AddressErrorMessage;
                system.debug('adrErrMsg: ' +adrErrMsg ) ;
                system.debug('adrErrMsg:' +  adrRc  ) ;
               // lead.Address_Validation_Error__c  = adrErrMsg ;
                //lead.Address_Validated__c = true;
                
                
                if(!adrRc.equals('0') )
                {
                        system.debug('adrErrMsg: ' +adrErrMsg ) ;
                        ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.ERROR,'INVALID ADDRESS--'+adrErrMsg));
                        //lead.Account__r.Address_Validated__c = false;
                        //account.Address_Validated__c = false;
                        addressValidationMsg = adrErrMsg;
                        notvalidadd=true;
                }else{
                    addressValidation = true;
                    addressValidationMsg = adrErrMsg;
                }
                system.debug('The variable-->'+notvalidadd);
                //system.debug('After : ' +name + street1  + city +state +  zip  + country  ) ;
                return notvalidadd;
            }catch(Exception ex){
                System.debug('------------'+ex.getMessage()+' Line '+ex.getLineNumber());
                ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.ERROR,'INVALID ADDRESS '));//+ex.getMessage()+' Line '+ex.getLineNumber()));
                return true;
            } 
                
         }
         
         /*******************************************************End**********************************************************/
         
    public String selectedAccountId {get;set;}
    public String selectedContactId {get;set;}
    private boolean selectedAccountTypeIsSite = false;  
    //Account siteAccount = null;
    
    public boolean checkRequiredFields() {
        if (lead.Company == null || lead.LastName == null || lead.Address1__c == null
         || lead.City__c == null || lead.State__c == null || lead.Zip__c == null || lead.Country__c == null || lead.Phone == null ||
         lead.WCW_Count__c == null || lead.Amount__c == null || lead.Industry == null || 
         //tmpAccount.Sector__c == null ||
         tmpAccount.Segment__c == null || tmpAccount.Buying_Group__c == null)
             return false;
             
         return true;
    }
    
    public PageReference GenerateRecords() {
        try{
            //Check if ready to convert lead,  
            
            //Changes for case - 114344 begins 
            system.debug ('Input Data Display:' + displayInputData);
            //if (displayInputData) 
              update lead;   

            //Changes for case - 114344 ends
            
            if(!ValidateLeadConversion()) {                      
                return null;
            }        
            
            Database.LeadConvert leadConvert = getLeadConvert();
            if(lead.Account__c == null) {       
                PopulateLeadConvertIfLeadAccountBlank(leadConvert);
            }
            else{
                PopulateLeadConvertIfLeadAccountNotBlank(leadConvert/*, selectedAccountId*/);
            }           
                        
            //if is Create Opportunity is set to false, don't create an opportunity      
            leadConvert.setDoNotCreateOpportunity(!isCreateOpportunity);            
                    
            Database.LeadConvertResult leadConvertResult = Database.ConvertLead(leadConvert); 
            
            //Changes for case - 114344 begins

            if (isCreateNewProspect) {
              ID acctid = leadConvertResult.getAccountId();
              Account lacct = [SELECT ID,sector__c,segment__c,Buying_Group__c,
              Verticals__c,
              //GT_Segment__c,
              Industry_OD_SIC_Rep__c from Account where ID = :acctid];
              
             // lacct.Sector__c = tmpAccount.Sector__c;
                lacct.GT_Segment__c= tmpAccount.GT_Segment__c;
                lacct.Location_Type__c = tmpAccount.Location_Type__c;

              lacct.Industry_OD_SIC_Rep__c = tmpAccount.Industry_OD_SIC_Rep__c ;

              lacct.Verticals__c= tmpAccount.Verticals__c;

             
              lacct.Segment__c = tmpAccount.Segment__c;
              lacct.Buying_Group__c = tmpAccount.Buying_Group__c;
              update lacct;
             }
            //Changes for case - 114344 ends
            return new PageReference('/'+ProcessResult(leadConvertResult)); 
        }
        catch(DmlException ex){       
            ApexPages.addMessages(ex);  
            return null;    
        }
        return null;
    }  
  
    /******************************************Generate records*******************************************************/
    private  Database.LeadConvert getLeadConvert() {
        Database.LeadConvert leadConvert = new Database.LeadConvert();
        leadConvert.setLeadId(this.lead.Id);
      
        List<LeadStatus> lstLeadStatus = [Select Id, MasterLabel From LeadStatus where IsConverted = true];
        if(lstLeadStatus.size() > 0) {
            leadConvert.setConvertedStatus(lstLeadStatus[0].MasterLabel); 
        }    
        return leadConvert;
    }  
  
  
    //==============================================================================//
    // Process the result
    //==============================================================================//
    private Id ProcessResult(Database.LeadConvertResult result) {       
        Id accountToRedirectAfterConversion;         
        if(lead.Account__c == null){
            if(isCreateNewProspect){        
                accountToRedirectAfterConversion = CreateProspectAndSiteRecord(result.getAccountId(), result.getContactId(), result.getOpportunityId()).Id;
            }
            else if(selectedAccountId != null){         
                CreateContactAndOpportunity(result.getAccountId(), result.getContactId(), result.getOpportunityId());
                accountToRedirectAfterConversion = result.getAccountId();
            }
            // There are no matching accounts found.
            else{
                accountToRedirectAfterConversion = CreateProspectAndSiteRecord(result.getAccountId(), result.getContactId(), result.getOpportunityId()).Id;
            }          
        }
        // Lead account != null
        else{
            CreateContactAndOpportunity(result.getAccountId(), result.getContactId(), result.getOpportunityId());
            if(lstMatchingContact.size() == 0){             
                if(result.getOpportunityId() != null){
                    accountToRedirectAfterConversion = result.getOpportunityId();
                }
                else{
                    accountToRedirectAfterConversion = result.getAccountId();
                }
            }
            else{               
                accountToRedirectAfterConversion = result.getAccountId();
            }
        }
        return accountToRedirectAfterConversion;
    } 
    
    //==============================================================================//
    // Get account id to be set for lead conversion
    //==============================================================================//
    private Id getAccountIdToBeSet(String accountId){
      // If selected account is of type site then set accountId = related_account__c
      if(isSiteAccountType(accountId)){
        selectedAccountTypeIsSite = true;        
        Account account = [Select id, related_account__c From Account Where Id =:selectedAccountId];
        return account.related_account__c;
      }
      // Set accountId = selectedAccountID(As it's Prospect/Customer account)
      else{
        return selectedAccountId;
      }   
    }
       
    
    //==============================================================================//
    // Populate lead convert when account is blank
    //==============================================================================//
    private void PopulateLeadConvertIfLeadAccountBlank(Database.LeadConvert leadConvert){
        if(!isCreateNewProspect && selectedAccountId != null){
            lead.Override_Duplicate_Check__c = true;
            update lead;
            // String prospectAccountId = getAccountIdToBeSet();
            leadConvert.setAccountId(getAccountIdToBeSet(selectedAccountId));        
            Contact contact;          
            if(selectedContactId != null){              
                isUseExistingContact = true;                       
                contact = [Select Id, AccountId From Contact Where Id = :selectedContactId];            
                leadConvert.setAccountId(contact.AccountId);
                leadConvert.setContactId(contact.Id);
            }                 
        }
    }
    
    //==============================================================================//
    // Populate lead convert when account is not blank
    //==============================================================================//
    private void PopulateLeadConvertIfLeadAccountNotBlank(Database.LeadConvert leadConvert){
        if(selectedAccountId != null && lstMatchingContact.size() > 0) {            
            leadConvert.setAccountId(getAccountIdToBeSet(selectedAccountId));         
            Contact contact;
            if(selectedContactId != null){
                isUseExistingContact = true;
                contact = [Select Id, AccountId From Contact Where Id = :selectedContactId];          
                leadConvert.setAccountId(contact.AccountId);
                leadConvert.setContactId(contact.Id);
            }
            else if(isCreateNewContact){
                lead.Override_Duplicate_Check__c = true;
                update lead;
            }
        }
        // No contacts found, create contact and opportunity
        else if(selectedAccountId != null){          
            leadConvert.setAccountId(getAccountIdToBeSet(selectedAccountId));           
            lead.Override_Duplicate_Check__c = true;
            update lead;
        }
    }
  
  
    //==============================================================================//
    // Create contact and opportunity
    //==============================================================================//
    private void CreateContactAndOpportunity(Id accountId, Id contactId, Id opportunityId){          
        // if isUseExistingContact then only create opportunity
        if(isUseExistingContact){     
            UpdateOpportunity(accountId, opportunityId );        
        }
        // if isCreateNewContact then create contact and opportunity
        else if(isCreateNewContact){
            UpdateContact(accountId, contactId);
        }
        else{                     
            UpdateContact(accountId, contactId);
            UpdateOpportunity(accountId, opportunityId );
        }     
    }
  
    
    //==============================================================================//
    // To Get is prospect new value
    //==============================================================================//
    public PageReference  changeIsProspectValue() {      
        return null;
    }
    
    //==============================================================================//
    // if user click on createNewContact radio button then we have to make selected
    // contact null
    //==============================================================================//
    public PageReference  makeSelectedContactNull() {
        selectedContactId = null;
        return null;
    }
    
    
    //==============================================================================//
    // Get matching accounts list
    //==============================================================================//
    public List<Account>  getMatchingAccounts() {
        return [Select Id,Related_Account__c,Name, Owner.name, Zip_5digit__c, Zip__c, Related_Account__r.Name,RecordType.Name,RecordTypeId,Related_Account__r.Id, 
                Related_Account__r.RecordTypeId, Address1__c, State__c, AOPS_Seq_Id__c, City__c, Cust_Id__c, OwnerId, YTD_Sales_TY__c From Account Where 
             //    (RecordTypeId = :GetRecordType('Customer') OR RecordTypeId = :GetRecordType('Prospect'))And
              name = :lead.Company And Zip_5digit__c = :lead.Zip__c order by Name];
    }
    
    //==============================================================================//
    // Get matching accounts list
    //==============================================================================//
    public List<Account>  getMatchingGTAccounts() {
    string custRTId = GetRecordType('Customer (GT)'); 
    string prospectRTId = GetRecordType('Prospect (GT)');
    Set<String> rtSet = new Set<String>();
    rtSet.add(custRTId );
    rtSet.add(prospectRTId);
    system.debug('@@@@@@@@@@@@@@rtSet'+rtSet);
        return [Select Id, Related_Account__c,Name, Owner.name, Zip_5digit__c, Zip__c, Related_Account__r.Name,RecordType.Name,RecordTypeId,Related_Account__r.Id, 
                Related_Account__r.RecordTypeId, Address1__c, State__c, AOPS_Seq_Id__c, City__c, Cust_Id__c, OwnerId, YTD_Sales_TY__c From Account Where RecordTypeId in: rtSet  and name = :lead.Company And Zip__c = :lead.Zip__c order by Name];
                
    }
    
    //==============================================================================//
    // Get matching accounts list
    //==============================================================================//
    public PageReference  selectedContact() {        
        return null;
    }
    
    
    //==============================================================================//
    // Get related contacts
    //==============================================================================//
    public PageReference  changeMatchingContacts() {      
        if(selectedAccountId != null){        
            lstMatchingContact =  [Select Id, AccountId, Name, FirstName, LastName, Mobilephone, Phone, MailingCity, MailingStreet, MailingState, 
                        MailingPostalCode, MailingCountry from Contact Where lastName = :lead.lastName And AccountId = :selectedAccountId];
            isCreateNewProspect = false;
            isCreateNewContact = false;
        }     
        return null;
    }
    
    //==============================================================================//
    // Hide contacts if user select isCreateNewProspect radio button
    //==============================================================================//
     public PageReference  hideContacts() {      
        lstMatchingContact = new List<Contact>();      
        return null;
     }
    
    //==============================================================================//
    // Get related contacts
    //==============================================================================//
    public List<Contact>  getMatchingContacts() {
        List <Contact> contactList;
        if(selectedAccountId != null){        
            contactList =  [Select Id, AccountId, Name, FirstName, LastName, mobilephone, Phone, MailingCity, MailingStreet, MailingState, 
                            MailingPostalCode, MailingCountry from Contact Where lastName = :lead.lastName And AccountId = :selectedAccountId];
        }
        else{
            contactList = new List<Contact>();
        }
        return contactList;
    }
    
    //==============================================================================//
    // Run Checks on Existing lead, to ensure its a proper candidate for conversion
    //==============================================================================//
    public PageReference ValidateLead() {
        //Check if the Account is null, if. account is null, separate validation needs to run,
        String message = '';
        User current_user = [Select id,profile.Name from User where id=:Userinfo.getuserid()];
        // All the Users below the Logged in User -- Mohan
        set<Id> SubordinateUsers = RoleUtils.getRoleSubordinateUsers(current_user.id);
        if(!SubordinateUsers.contains(lead.ownerid) && (lead.ownerid != current_user.id)&& (current_user.Profile.Name !='System Administrator')){        
                isLeadValidationSuccessful = false;
               message = 'You are not the owner of this Lead. Only the primary owner can covert this lead.';
        }
        else if(lead.Account__c == null)
        {
            isLeadValidationSuccessful = ValidateLeadIfAccountBlank();
            message = 'Please make sure the Amount, Company, First Name, Last Name,  Address Fields, Phone, and WCW Count are set before trying to convert.';
        }
        else
        {
            isLeadValidationSuccessful = ValidateIfAccountPresent();
            message = 'Please make sure to enter an Amount, First Name, and Last Name before trying to convert.';
        }
        if(isLeadValidationSuccessful){
            //calling Address validation webservices if the country is USA 
            if((lead.country__c).trim()=='USA'){
                string ProceedLeadCoversion = ApexPages.currentPage().getParameters().get('ProceedCoversion');
                if(ProceedLeadCoversion==null || !boolean.valueof(ProceedLeadCoversion)){    
                    system.debug('ProceedLeadCoversion1**'+ProceedLeadCoversion+'**notvalidadd**'+notvalidadd);        
                   /* if(validateAddress()){
                            system.debug('Error**'+validateAddress());
                            isLeadValidationSuccessful = validateAddress();
                            return null;
                    }  */  
                }            
                if(ProceedLeadCoversion!=null && boolean.valueof(ProceedLeadCoversion)){
                    notvalidadd = false;
                    system.debug('ProceedLeadCoversion2**'+ProceedLeadCoversion+'**notvalidadd**'+notvalidadd);  
                }
            }
            // -------End--------------
        }
        //If the validation fails, add the message for everyone to see
        if(!isLeadValidationSuccessful) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.FATAL,message));
        }
        return null;
    }
    
    
    //==============================================================================//
    // Run Checks on Existing lead, to ensure Account and Lead Owner is same
    //==============================================================================// 
    private Boolean ValidateLeadConversion() {          
        String message = '';
        Account account;
        if(!isCreateNewProspect){
            // Gets account ownerid
            if(lead.Account__c != null) {
                account = [Select Id, owner.name, OwnerId From Account Where Id = :lead.Account__c];
            }
            else if(selectedAccountId != null){
                account = [Select Id, owner.name, OwnerId From Account Where Id = :selectedAccountId];
            }            
            // check ownerid
            
             User current_user = [Select id,profile.Name from User where id=:Userinfo.getuserid()];
        // All the Users below the Logged in User  -- Mohan
        set<Id> SubordinateUsers = RoleUtils.getRoleSubordinateUsers(current_user.id);
    
            if((lead.Account__c != null || selectedAccountId != null) && (lead.OwnerId != account.OwnerId)&&(!SubordinateUsers.contains(lead.ownerid))&&(current_user.Profile.Name !='System Administrator')){
                message = 'You are not the owner of the existing account therefore you do not have permission to convert this lead please reassign the lead to <b>'+ account.Owner.name+'</b>.';
                ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.FATAL, message)); 
                return false;       
            }
        }
        return true;    
    }
    
    //==============================================================================//
    // Do nothing return back to page
    //==============================================================================//
    public PageReference returnBack(){
        return null;
    }
    
    
    
    //==========================================================================//
    // Validate lead required fields if account is null
    //========================================================================//  
    /*private String retrieveSelectedRelatedAccount() {   
      for(Account account :lstMatchingAccount) {      
        if(ApexPages.currentPage().getParameters().get(account.Id) == account.Id ) {
          this.selectedAccountId = account.Id;        
          return selectedAccountId;    
        }
      }  
      this.selectedAccountId = null;     
      return null;
    }*/ 
  
    //==========================================================================//
    // Validate lead required fields if account is null
    //========================================================================//    
    private Boolean ValidateLeadIfAccountBlank() {      
        if(lead.Company == null || lead.amount__c == null || lead.FirstName == null || lead.LastName == null || lead.address1__c == null || 
            lead.City__c == null || lead.State__c == null || lead.zip__c == null || lead.Phone == null || lead.WCW_Count__c == null || lead.country__c == null) { 
            return false;      
        }
        else
            return true;
    }
   
    //=======================================================================//
    //If account is present, check if firstname, lastname is present.
    //======================================================================//
    private Boolean ValidateIfAccountPresent() {
        if(lead.FirstName == null || lead.amount__c== null || lead.LastName == null ) {
            return false;
        }
        return true;
    }
  
   
    //==============================================================================//
    // Create accounts, contact and opportunity
    //==============================================================================//
    private Account CreateProspectAndSiteRecord(Id accountID, Id contactID, Id opportunityID){        
        Account prospectAccount = UpdateProspectAccount(accountID);         
        //siteAccount = CreateSiteAccount (accountID);
        Contact contact = UpdateContact(accountID, contactID);      
        //siteAccount.Site_Primary_Contact__c = contact.id;
        //update siteAccount;    
        UpdateOpportunity(accountID, opportunityID /*, siteAccount.Id*/);    
        return prospectAccount;   
    }
  
  
    //==============================================================================//
    // Update Contact Account
    //==============================================================================//
    private Contact UpdateContact(Id accountId, Id contactId){
        Contact contact = new Contact(Id = contactId);
        contact.FirstName = lead.FirstName;
        contact.LastName =  lead.LastName;
        contact.OwnerId = lead.OwnerId;
        contact.Title = lead.Title;
        contact.mailingstreet = lead.address1__c;
        contact.mailingcity = lead.city__c;
        contact.mailingstate = lead.state__c;
        contact.mailingpostalcode = lead.zip__c;
        contact.AccountId = accountId;     
        contact.Phone = lead.Phone;     
        contact.primary_contact__c = true;
        contact.Override_Duplicate_Check__c = true;
        
        
        update contact;
        return contact;   
    }
  
    //==============================================================================//
    // Create Site Account
    //==============================================================================//
    /*private Account CreateSiteAccount(Id accountId){ 
        Account siteAccount = new Account(  Related_Account__c = accountId,
                                            OwnerId = Lead.ownerID,
                                            status__c='Active', 
                                            Primary_Site__c=true, 
                                            Name = lead.Company, 
                                            Industry_OD_SIC_Rep__c = lead.Industry, 
                                            Address1__c = lead.address1__c, 
                                            address2__c = lead.address2__c,
                                            City__c = lead.City__c,
                                            Address_Validated__c=addressValidation,
                                            Address_Validation_Error__c=addressValidationMsg,
                                            State__c = lead.State__c, 
                                            Zip__c = lead.zip__c, 
                                            country__c=lead.country__c,
                                            Org_WCW_Count_Rep__c = lead.WCW_Count__c,
                                            location_type__c = tmpAccount.location_type__c );
                if (Lead.Sales_Person_ID__c == null)
                {
                         siteAccount.sales_personId__c = salesPersonSFDCId;
                 }
                 else
                 { siteAccount.Sales_PersonID__c=Lead.Sales_Person_ID__c ;}
                                            
                                            
     Account   rt1 = [SELECT id,recordtypeid,recordtype.name FROM account where id=:accountId limit 1];
             // Recordtype rt2 = [SELECT id FROM recordtype where name = 'Prospect (GT)' and SobjectType = 'Account'];
  if(rt1.recordtypeid=='012E00000008dTbIAI')//prospet
 {
  siteAccount.recordtypeid='012E00000008dTcIAI';}
  else
  {
  siteAccount.recordtypeid='012M00000004kurIAA';
  }
  
        system.debug('@@@@@@@siteAccount.Sales_PersonID__c'+siteAccount.Sales_PersonID__c);
        system.debug('---->'+siteAccount.RecordTypeId);
        insert siteAccount;
        return siteAccount;    
    } 
    */
    //==============================================================================//
    // Update Prospect Account
    //==============================================================================//
    private Account UpdateProspectAccount(Id accountId){        
        Account prospectAccount = new Account(Id = accountID);
        if(GTLead == true){
        prospectAccount.RecordtypeId = GetRecordType('Prospect (GT)');}
        else
       { prospectAccount.RecordtypeId = GetRecordType('Prospect');}
       system.debug('---->'+prospectAccount.RecordtypeId);
        prospectAccount.Name = lead.Company;
        prospectAccount.OwnerId = lead.ownerId;
        prospectAccount.address1__c = lead.address1__c;
        prospectAccount.address2__c = lead.address2__c;
        prospectAccount.city__c = lead.city__c;
        prospectAccount.state__c = lead.state__c;
        prospectAccount.zip__c = lead.zip__c;
        prospectAccount.country__c = lead.country__c;
        prospectAccount.Org_WCW_Count_Rep__c = lead.WCW_Count__c;
        prospectAccount.GT_Segment__c= tmpAccount.GT_Segment__c;
        prospectAccount.Location_Type__c=tmpAccount.Location_Type__c;

              prospectAccount.Industry_OD_SIC_Rep__c = tmpAccount.Industry_OD_SIC_Rep__c ;

              prospectAccount.Verticals__c= tmpAccount.Verticals__c;                      
                 
                   
                if (Lead.Sales_Person_ID__c == null)
                {
                        if(SalesPersonId.size()>0){
                         prospectAccount.Sales_PersonID__c=SalesPersonID[0].id;}
                 }
                 else
                 { prospectAccount.Sales_PersonID__c=Lead.Sales_Person_ID__c ;}
       
        if(GTLead != true)
        prospectAccount.Industry_OD_SIC_Rep__c = lead.Industry;
        prospectAccount.Address_Validated__c=addressValidation;
        prospectAccount.Address_Validation_Error__c=addressValidationMsg;
        prospectAccount.status__c = 'Active';
        update prospectAccount; 
        system.debug('---->'+prospectAccount);    
        return prospectAccount;    
    }
    
    //==============================================================================//
    // Update opportunity
    //==============================================================================//
    private void UpdateOpportunity(Id accountId, Id opportunityId ){
        if(opportunityId != null){
            Opportunity opportunity = new Opportunity(Id = opportunityId);            
            opportunity.accountId = accountId;      
            /*if(siteAccount != null){
                opportunity.related_site__c = siteAccount.Id;               
            }*/
            if(lead.Account__c != null){                
                if(isSiteAccountType(lead.Account__c)){
                    opportunity.Related_Site__c = lead.Account__c;                                      
                }                
            }
            else{               
                if(selectedAccountTypeIsSite){
                    opportunity.Related_Site__c = selectedaccountid;
                }               
            }
            opportunity.OwnerId= lead.OwnerId;
            opportunity.LeadSource = lead.LeadSource;             
            opportunity.Primary_Competitor_1__c = Lead.Current_Supplier__c;
            opportunity.StageName = 'Qualify';
            opportunity.Store__c = lead.Store__c;
            opportunity.Product__c = lead.Product__c;
            opportunity.Amount = lead.amount__c;
            opportunity.Amount_CAD__c= lead.amount__c;
            
         
       
            update opportunity;
        }
    }
    
    
   //======================================================================//
   //To check lead account record type
   //======================================================================//
   private Boolean isSiteAccountType(String accountId){
        //Get recordtype ids
        Id prospectRecordTypeId = [Select Id From RecordType Where SobjectType = 'Account' And (Name = 'Prospect' Or Name = 'Customer') limit 1].get(0).id;
        Id siteRecordTypeId = [Select Id From RecordType Where SobjectType = 'Account' And Name = 'Site' limit 1].get(0).id;
        Account account = [Select id, owner.name, RecordTypeId From Account Where Id = :accountId ];
        if(account.RecordTypeId == siteRecordTypeId){
            return true;
        }    
        else{
            return false;
        }       
   }
   
   //======================================================================//
   //To get account record type id
   //======================================================================//
   private Id GetRecordType(String recordType){
        Schema.DescribeSObjectResult descSchema = Schema.SObjectType.Account;    
        Map<String,Schema.RecordTypeInfo> rtMapByName = descSchema.getRecordTypeInfosByName();
        Schema.RecordTypeInfo rtByName = rtMapByName.get(recordType);
        return rtByName.getRecordTypeId();
   }
}