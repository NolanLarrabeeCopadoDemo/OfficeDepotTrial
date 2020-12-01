/**************************************************************
*Name           : LeadMatchingAccountExtension
*Created By     : Dheeraj(Appirio Off)
*Created Date   : 11th April,2012
*Purpose        : To get matching account for lead
********************************************************************/
public with sharing class LeadMatchingAccountExtension {
  private final Lead lead = null;
  public List<Account> lstMatchingAccount {get;set;}
  public List<Lead> lstMatchingLead {get;set;}
  public List<Contact> lstMatchingContact {get;set;}
  public Boolean isLeadValidationSuccessful {get;set;}
  
  // Constructor
  public LeadMatchingAccountExtension(ApexPages.StandardController controller) {
    lead = (Lead)controller.getRecord();
    lstMatchingAccount = getMatchingAccounts();
    lstMatchingLead = getMatchingLeads();
    lstMatchingContact = getMatchingContacts(); 
    isLeadValidationSuccessful = true;
  }
    
  //==============================================================================//
  // Get matching accounts list
  //==============================================================================//
  public List<Account>  getMatchingAccounts() {    
    return [Select Id, Name,Industry_OD_SIC_Rep__c,OwnerId, phone, cust_id__c, ytd_Sales_ty__c, stage__c, Owner.Name, RecordTypeId, address1__c, 
                last_order_date__c, City__c, State__c From Account Where Name = :lead.Company AND account.Zip_5digit__c = :lead.Zip_5digit__c];        
  }  
  
  //==============================================================================//
  // Get matching leads list
  //==============================================================================//
  public List<Lead>  getMatchingLeads() {   
    return [Select Id, phone, Name,industry,company, address1__c, city__c, state__c, zip__c, createddate, ownerid, Owner.Name From Lead 
                        Where (company = :lead.Company AND lead.Zip_5digit__c = :lead.Zip_5digit__c) OR lead.phone = :Lead.phone]; 
  }
  
  //==============================================================================//
  // Get matching contacts list
  //==============================================================================//
  public List<contact>  getMatchingContacts() {
  	List<Contact> listContact = new List<Contact>();
  	if(lead.Phone != null){
      listContact = [Select Id, phone, Name, email, accountid, mobilephone,account.name, mailingcity, mailingstreet, mailingstate, mailingpostalcode, 
                		createddate, ownerid, Owner.Name From contact Where contact.phone = :lead.phone ];
  	}
  	return listContact;             
  }
    
  //==============================================================================//
  // Go back to lead
  //==============================================================================//
  public PageReference  BackToLead() {        
    return new PageReference('/'+lead.Id);
  }
  
  //==============================================================================//
  // Run Checks on Existing lead, to ensure lead has company, zip and phone
  //==============================================================================//
  public PageReference ValidateLead() {  		
	String message = '';	
	if(lead.company == null || lead.zip__c == null || lead.phone == null) {
      message = 'In order to check for existing matches in the system the following fields need to be completed:  Company Name, Phone & Zip';
      ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.FATAL,message));
      isLeadValidationSuccessful = false;
  	}  	
  	return null;
  }
}