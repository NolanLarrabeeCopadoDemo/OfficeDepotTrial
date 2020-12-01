/*************************************************************
*Name           : RequestCustomerOpportunitySetupExtension
*Created By     : Appirio Off
*Created Date   : 10 Feb, 2012
*Purpose        : To request customer setup if prospect account has one primary contact and one primary site account related to it.
****************************************************************/
public class RequestCustomerOpportunitySetupExtension {

  private Opportunity opportunity;
  public Account siteAccount{get;set;}
  public Contact primaryContact{get;set;}
  public Contact NewPayable{get;set;}
  public Contact NewEbilling{get;set;}
  public Boolean isValid{get;set;}
  public Pricing_Template__c pricingTemp{get;set;}
  public Account relevantAccount {get;set;}

  private String instance1ID = null;
  private String instance2ID = null;  // not currently used

  //Added for S-425883[Case#00744549]
  final String CLICK_TOOL_SURVEY_ID ='Account Setup Request';
  //END S-425883[Case#00744549]

  public RequestCustomerOpportunitySetupExtension(ApexPages.StandardController controller) {

    opportunity = (Opportunity)controller.getRecord();
    isValid = true;

    //Added by Deepak - Case#00002765 Begins
    Opportunity lopp = [SELECT id,account.id,account.pricing_template_cd__c from opportunity where id = :opportunity.id];

    if ('Custom - Self Service'.equals(lopp.account.Pricing_template_cd__c)) {
      AggregateResult qaccepted_total = [SELECT count(id) tot_accepted from quote where OpportunityId = :opportunity.id and status = 'Accepted by Customer'];
      if (decimal.valueof(string.valueof(qaccepted_total.get('tot_accepted'))) < 1) {
        isValid = false;
        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Opportunity should have atleast One Accepted Quote'));
        return;
      }
    }
   // Removing WRF validation as per case#00003978
  /* else if ('Custom - WRF'.equals(lopp.account.Pricing_template_cd__c)) {
        AggregateResult case_total = [SELECT count(id) tot_closed from case where accountid = :lopp.account.id and Status = 'Closed' and recordtypeid = '012E00000008dkDIAQ'];
        if (decimal.valueof(string.valueof(case_total.get('tot_closed'))) < 1) {
          isValid = false;
          ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Opportunity should have atleast One Closed WRF Request'));
          return;
        }
    }*/
    //Added by Deepak - Case#00002765 Ends

    if(opportunity.AccountId == null) {
      isValid = false;
      ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Opportunity is not associated with an Account'));
      return;
    }

    this.relevantAccount = GetRelevantOpportunityAccount();

    if(this.relevantAccount == null) {
        isValid = false;
      ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Site Account doesnot have a related Account'));
      return;
    }

    findValidContact();

    findValidSiteAccount();

    findAccountsPayableContact();
    findEbillContact();

    if(this.relevantAccount.RecordType.Name == 'Customer') {
        isValid = false;
      ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Account setup cannot be done as Opportunity is already tied to a customer'));
     return;

    }
    if(this.relevantAccount.RecordType.Name == 'Account Setup Requested') {
        isValid = false;
      ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Account setup cannot be done as Opportunity is already tied to an Account that is currently being setup'));
     return;

    }

    if(primaryContact == null) {
      isValid = false;
    }
    if(opportunity.stagename != 'Close'  && opportunity.stagename !=  'Verbal Win') {
      ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Opportunity Stage must be set to "Verbal Win" or "Close" to request Customer setup.'));
      isValid = false;
    }
    if(this.relevantAccount.Oracle_Party_ID__c == null) {
      ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'This prospect is not yet ready for Customer Setup. If you just created this Prospect please wait a few minutes for replication before requesting Customer Setup. If its been over 30min since creation and you are receiving this error - please put in a Support Ticket with the subject: Request customer setup is not functioning'));
      isValid = false;
    }
     if(this.relevantAccount.Industry_OD_SIC_Rep__c == null) {
      ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Please complete the Industry field on the account page before submitting for customer setup'));
      isValid = false;
    }
     if(this.relevantAccount.Sector__c == null) {
      ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Please complete the Sector field on the account page before submitting for customer setup'));
      isValid = false;
    }
     if(this.relevantAccount.Segment__c == null) {
      ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Please complete the Segment field on the account page before submitting for customer setup.'));
      isValid = false;
    }
    //If Account Potential is null  01351292
      if(this.relevantAccount.Est_Spend__c== null) {
      ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Please complete the Account Potential field on the account page before submitting for customer setup.'));
      isValid = false;
    }

     if(this.relevantAccount.Pricing_template_cd__c == null) {
     ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Please complete the Pricing Template field on the account page before submitting for customer setup.'));
         isValid = false;
     }
    /* if(this.relevantAccount.Approved_for_Setup__c == false && this.relevantAccount.DNBI_CREDIT_OUTCOME__c =='Declined') {
      ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Requested account does not have enough credibility limit.'));
      isValid = false;
    }*/


      list<sales_person__C> spids = [ select name,ExtIDSalesPerson__c from sales_person__C where user__C = :this.relevantAccount.ownerid and User_Status__c = 'Active' and Primary__c = true ];
    if(spids.size()>0){
     if(spids[0].ExtIDSalesPerson__c == 'TEMPID' || spids[0].ExtIDSalesPerson__c == 'Awaiting SalesID'){
     ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'You do not have valid SalesRep ID. Please contact your Manager '));
         isValid = false;
     }}
     else
     {
        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Currently, you are missing a sales Rep Id, please Contact your manager. If you have just been assigned a new ID, please wait 24 hours for the changes to take place.'));
         isValid = false;
     }


// Call Pricing Template data
    findValidPriceTempAccount();

    try {
        //Modified for S-425883[Case#00744549]
        Click_Tool_Links__c ctl = Click_Tool_Links__c.getInstance(CLICK_TOOL_SURVEY_ID);
        instance1ID = ((ctl != null && ctl.Value__c != null)?((ctl.Value__c).indexOf('iv=') != -1 ? ctl.Value__c.subString((ctl.Value__c).indexOf('iv=')+3, (ctl.Value__c).length()) :''):'');
        //End S-425883[Case#00744549]

        If ((instance1ID == null) || (instance1ID == '')) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'INTERNAL ERROR: Unable to get Clciktools survey ID.'));
            isValid = false;
        }
    } catch(Exception ex) {
        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'INTERNAL ERROR: Unable to get Clciktools survey ID. Err=' + ex));
        isValid = false;
    }



  }

  /**
   * This method will be called from the action page
   */
  public PageReference getRedir() {

    if (!isValid || (this.relevantAccount.setup_url1__c != null)) {  // no longer used:   && this.relevantAccount.setup_url2__c != null)) {
      return null;
    }

    CTRestInteractor.uniqueURLCreator(opportunity.AccountId, instance1ID, instance2ID);

    return null;
  }

  @RemoteAction
  public static String[] checkUrls(String acctId){

    String[] urls = new String[]{null,null};
    Account account = [SELECT setup_url1__c FROM Account WHERE id = :acctId];

    String url1 = EncodingUtil.urlEncode(account.setup_url1__c, 'UTF-8');
    //  no longer used:  String url2 = EncodingUtil.urlEncode(account.setup_url2__c, 'UTF-8');

    if(url1 != null && !url1.equals('')) {  // no longer used:  && url2 != null && !url2.equals('')){
      urls[0] = url1;
      urls[1] = null;  // no longer used  url2;
    }

    return urls;
  }


  //----------------------------------------------//
  //To find only valid primary contact for account
  //----------------------------------------------//
  private void findValidContact() {
    List<Contact> lstContact = [SELECT id,Salutation,FirstName,LastName,Title,Phone,Fax,Email, role__c FROM Contact WHERE AccountId = :this.relevantAccount.Id AND primary_contact__c = true];

    if(lstContact.size() == 0) {
      ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'You must have a primary contact selected before continuing.  If you have added a contact please remember to flag it as primary by selecting the "primary contact" checkbox'));
    }
    if(lstContact.size() > 1) {
      ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'You currently have 2 or more contacts flagged as primary - you must select only one of these as the primary in order to request a customer setup'));
    }
    if(lstContact.size() == 1) {
      primaryContact = lstContact[0];
    }
  }


  //----------------------------------------------//
  // To get AccountPayableContact (most recent)
  //----------------------------------------------//
  public Void findAccountsPayableContact(){
    List<Contact> AccountsPayable = [SELECT id,Salutation,FirstName,LastName,Title,Phone,Fax,Email,Role__c FROM Contact WHERE AccountId = :this.relevantAccount.Id
                                                                AND role__c includes ('Accounts Payable') ORDER BY lastmodifieddate DESC Limit 1];
    if(AccountsPayable.size() == 0){

    }
    if(AccountsPayable.size() == 1){

   //     ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Jen Accounts Payable test'));
     NewPayable = AccountsPayable[0];

    }
  }

  //----------------------------------------------//
  // To get EbillContact (most recent)
  //----------------------------------------------//
  public Void findEbillContact(){
    List<Contact> Ebilling =  [SELECT id,Salutation,FirstName,LastName,Title,Phone,Fax,Email,Role__c FROM Contact WHERE AccountId = :this.relevantAccount.Id
                                                            AND role__c includes ('eBilling') ORDER BY lastmodifieddate DESC Limit 1];
    if(Ebilling.size() == 0){

    }
    else{
         Newebilling = Ebilling[0];
    }
  }

  //----------------------------------------------//
  //To find only valid primary site account for the prospect account
  //----------------------------------------------//
  private void findValidSiteAccount() {
         List<RecordType> lstRecordType = [SELECT Id FROM RecordType WHERE Name = 'Site'];
    if(lstRecordType.size() == 0 ) {
      ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Record Type "Site" not found for Account object'));
      return ;
    }

    List<Account> lstAccount = [SELECT id,Name,Oracle_Party_Site_ID__c, Address1__c,Address2__c,City__c,State__c,Zip__c, Country__c FROM Account WHERE RecordTypeId = :lstRecordType[0].Id AND primary_site__c = true AND Related_Account__c = :opportunity.AccountId];
     System.debug('****************************************************************************lstAccount'+lstAccount);

  //  If(relavantAccount.RecordType.Name == 'prospect'){
  //  List<Account> lstAccount = [SELECT id,Name,Oracle_Party_Site_ID__c, Address1__c,Address2__c,City__c,State__c,Zip__c, Country__c FROM Account WHERE RecordTypeId = :lstRecordType[0].Id AND primary_site__c = true AND Related_Account__c = :opportunity.AccountId];
  //  List<Account> lstAccount = [SELECT id,Name,Oracle_Party_Site_ID__c, Address1__c,Address2__c,City__c,State__c,Zip__c, Country__c FROM Account WHERE RecordTypeId = :lstRecordType[0].Id AND primary_site__c = true AND Related_Account__c = :opportunity.AccountId];
  //  System.debug('****************************************************************************lstAccount'+lstAccount);
  // }

    if(lstAccount.size() == 0) {
      ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'You must have a primary site selected before continuing. If you have added a site please remember to flag it as primary by selecting the "primary site" checkbox'));
    }
    if(lstAccount.size() > 1) {
      ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'You currently have 2 or more sites flagged as primary - you must select only one of these as the primary in order to request a customer setup'));
    }
    if(lstAccount.size() == 1) {

      siteAccount = lstAccount[0];
    }
  }

   //----------------------------------------------//
  //To find valid account for validations for according to record type
 //----------------------------------------------//
  public Account GetRelevantOpportunityAccount() {
         Account relavantAccount = [SELECT RecordType.Name,DNBI_CREDIT_OUTCOME__c,Name,Est_Spend__c,Org_WCW_Count_Rep__c,Sic,ownerid,Sales_PersonID__r.name,Owner.name,Duns_Number__c,Ultimate_Duns_Number__c,Phone,Phone_Ext__c,setup_url1__c,Related_Account__c,Oracle_Party_ID__c,Industry_OD_SIC_Rep__c,Segment__c,Sector__c, Pricing_template_cd__c, Related_Pricing_Template_Account__r.Cust_Id__c, Payment_Term__c, Related_Parent_Account__c FROM Account WHERE id =:opportunity.AccountId];

   /* If(relavantAccount.RecordType.Name == 'prospect'){
        return relavantAccount;
    }*/
  //  If(relavantAccount.RecordType.Name == 'site'){
  //      List<Account> lstAccount = [SELECT RecordType.Name,Name,Est_Spend__c,Org_WCW_Count_Rep__c,Sic,Sales_PersonID__r.name,ownerid,Owner.name,Duns_Number__c,Ultimate_Duns_Number__c,Phone,Phone_Ext__c,setup_url1__c,Oracle_Party_ID__c,Industry_OD_SIC_Rep__c,Segment__c,Sector__c FROM Account
  //                      WHERE id = :relavantAccount.Related_Account__c];
  //      system.debug('****>' + lstAccount);
  //      if(lstAccount.size() > 0) {
  //        return lstAccount[0];
  //      }
  //  }
    return relavantAccount;
  }


  private void  findValidPriceTempAccount()
  {
   //adding Exclude_Universal_Pricing__c in the below query  for the Defect NO : 12356 -- Mohan
    List<Pricing_Template__c> lstTemplate = [ SELECT Id, Name, Loyalty__c, revenue_band__c, delivery_code__c, Template__c, Price_Plan_Id__c, Price_Plain_Id_Question__c, Contract_Number_1__c, Contract_Number_1_Question__c,
     Contract_Desc_1__c, Contract_Desc_1_Question__c, Priority_1__c, Priority_1_Question__c, Contract_Number_2__c, Contract_Number_2_Question__c, Contract_Desc_2__c, Contract_Desc_2_Question__c, Priority_2__c, Priority_2_Question__c, Contract_Number_3__c,
      Contract_Number_3_Question__c, Contract_Desc_3__c, Contract_Desc_3_Question__c, Priority_3__c, Priority_3_Question__c, Contract_Number_4__c, Contract_Number_4_Question__c, Contract_Desc_4__c, Contract_Desc_4_Question__c, Priority_4__c, Priority_4_Question__c,
       Contract_Number_5__c, Contract_Number_5_Question__c, Contract_Desc_5__c, Contract_Desc_5_Question__c, Priority_5__c, Priority_5_Question__c, Contract_Number_6__c, Contract_Number_6_Question__c, Contract_Desc_6__c, Contract_Desc_6_Question__c, Priority_6__c,
       Priority_6_Question__c, Contract_Number_7__c, Contract_Number_7_Question__c, Contract_Desc_7__c, Contract_Desc_7_Question__c, Priority_7__c, Priority_7_Question__c, Contract_Number_8__c, Contract_Number_8_Question__c, Contract_Desc_8__c, Contract_Desc_8_Question__c,
       Priority_8__c, Priority_8_Question__c, Contract_Number_9__c, Contarct_Number_9_Question__c, Contract_Desc_9__c, Contract_Desc_9_Question__c, Priority_9__c, Priority_9_Question__c, Contract_Number_10__c, Contract_Number_10_Question__c, Contract_Desc_10__c,
       Contract_Desc_10_Question__c, Priority_10__c, Priority_10_Question__c, Sales_Role__c, Cust_Prod_Xref__c, Cust_Prod_Xref_Question__c, Parent_Id__c, Parent_Id_Question__c, Off_Contract_Code__c, Off_Contract_Code_Question__c, Off_Contract_Percent__c,
       Off_Contract_Percent_Question__c, Off_Wholesale_Code__c, Off_Wholesale_Code_Question__c, Off_Wholesale_Percent__c, Off_Wholesale_Percent_Question__c, GP_Floor_Percernt__c, Freight_Charge__c, PO_Label__c, Desktop_Label__c, CostCenter_label__c, Release_Label__c,
       SMDeliveryFee__c, Back_Orders_Allowed__c, Substitutions_Allowed__c, Block_TechDepot__c, Block_PrintOnDemand__c, Online_Orders__c, Template_code__c, Minimum_order_value__c,Exclude_Universal_Pricing__c,Account_Setup_Notes_c__c, Acct_Auto_Setup__c from Pricing_Template__c where Template__c = :this.relevantAccount.Pricing_template_cd__c];

    if(lstTemplate.size() == 0) {
      ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'You must have a Pricing Template selected before continuing.'));
    }
    if(lstTemplate.size() > 1) {
      ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'You currently have 2 or more contract Templates for the select value. Please contact your System Administartor. '));
    }
    if(lstTemplate.size() == 1) {
      pricingTemp = lstTemplate[0];
    }
  }
}