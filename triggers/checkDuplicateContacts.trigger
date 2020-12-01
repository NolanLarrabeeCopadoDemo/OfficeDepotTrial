/*************************************************************
*Name : checkDuplicateContacts
*Created By : Akash (Appirio Off)
*Purpose : To find the duplicate contacts by lastname and email for same account befrore inserting the account
           and to populate site account's contacts that were create using create new site contact button on site account layout
           
*Updated Oct 4th : Added Bypassing logic for DataLoader user  
                  
****************************************************************/
trigger checkDuplicateContacts on Contact ( before insert, after insert) {
        //Story#01514722 - Below Piece of code is used to skip RecordType (Tech Zone)
    for(Contact c: trigger.new)
    {system.debug('c.recordtypeId**'+c.recordtypeId);
        if(util.checkRT('Contact').contains(c.recordtypeId))
            return;
    }
    // added for ticket 01474559
       if (Trigger.New != null) {
         for (Contact myCont: Trigger.new) {
          if (Util.bizBoxRTIdsByObject('Contact').contains(myCont.RecordTypeId)) {
           return;
          }
         }
        }

  //Bybass for Mod5Contact Batch
  if(executeoncetest.mod5ByPass==false)
  return;
    

    
    
//Added for Support Ticket: 00532318 1 line below
    ID Tier1ContactType = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('Partner Contact(US)').getRecordTypeId();    
    ID MDRContactType = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('MDR Contact').getRecordTypeId();
    
  //--------------------------------------------//
  // To Bypass trigger code on certain condition
  //-------------------------------------------//
  if (Util.bypassTriggers('checkDuplicateContacts')) {
    Util.DEBUG('Bypassing trigger checkDuplicateContacts');
      return;
  }

  Set<String> stEmailIds = new Set<String>();
    
  Set<String> stLastNames = new Set<String>(); 
  Set<String> stAccountIds = new Set<String>(); 
  list<SiteContacts__c> siteContactslst = new list<SiteContacts__c>();
  
  for(Contact contact : trigger.new) {      
    if(trigger.isAfter && contact.Site_Account__c != null) {
      stAccountIds.add(contact.Site_Account__c);
      continue;
    }
    if(contact.Override_duplicate_check__c) {
      continue;
    }
      
//Added for Support Ticket: 00532318 and MDR
        if(contact.recordtypeid == MDRContactType || contact.recordtypeid == Tier1ContactType || contact.MDR_Contact__c != null) {
            continue;
        } ELSE {
//End of Add      
    stLastNames.add(contact.lastName);       
    stAccountIds.add(contact.AccountId);   
            
    if(contact.Email != null) {
      stEmailIds.add(contact.Email);
    }
  }
      
  }
  
  Set<String> stNameAccountKey = new Set<String>();
  Set<String> stEmailAccountKey = new Set<String>();
 // Map<Id,Account> mpSiteAccounts;
  
  queryExistingDuplicateContacts();  
  //querySiteAccounts();   
  
  //-----------------------------------------//
  // To loop over all the contacts and either populate the site account's data()(if after insert trigger) OR 
  // check for duplicates in the existing data
  //-----------------------------------------//
  map<id, Contact> mapCnt_SiteAccount= new map<id, Contact>();       
  for(Contact contact : trigger.new) {      
    if(trigger.isAfter && contact.Site_Account__c != null) {         
      populateSiteAccountContacts(contact,siteContactslst);
      continue;
    }
    if(contact.Override_duplicate_check__c) {
      continue;
    }
        
    String lastNameKey = generateKey(contact.LastName,contact.AccountId);   
    if(stNameAccountKey.contains(lastNameKey)) {
      contact.addError('Duplicate contact found with same Last Name. If you still want to create this contact please select "Override duplicate checkbox and continue.." ');
    }
    if(contact.Email == null) { 
      continue;
    }
    String emailKey = generateKey(contact.Email,contact.AccountId);
      system.debug('stEmailAccountKey***'+stEmailAccountKey);
    if(stEmailAccountKey.contains(emailKey)) {
      contact.addError('Duplicate contact found with same Email. If you still want to create this contact please select "Override duplicate checkbox and continue.." ');
    } 
//Added for Support Ticket: 00532318       
      String Tier1lastNameKey = generateKey(contact.LastName,contact.Tier_1_Partner__c);
      String Tier1emailKey = generateKey(contact.Email,contact.Tier_1_Partner__c);    
    if(stNameAccountKey.contains(Tier1lastNameKey)) {
      contact.addError('Duplicate contact found with same Last Name. If you still want to create this contact please select "Override duplicate checkbox and continue.." ');
    }
    if(stEmailAccountKey.contains(Tier1emailKey)) {
      contact.addError('Duplicate contact found with same Email. If you still want to create this contact please select "Override duplicate checkbox and continue.." ');
    }
/*MDR Add - Support Ticket:       
      String MDRlastNameKey = generateKey(contact.LastName,contact.MDR_Contact__c);
      String MDRemailKey = generateKey(contact.Email,contact.MDR_Contact__c);    
    if(stNameAccountKey.contains(MDRlastNameKey)) {
      contact.addError('Duplicate contact found with same Last Name. If you still want to create this contact please select "Override duplicate checkbox and continue.." ');
    }
    if(stEmailAccountKey.contains(MDRemailKey)) {
      contact.addError('Duplicate contact found with same Email. If you still want to create this contact please select "Override duplicate checkbox and continue.." ');
    }
*/
//End of Add        
  }
  
  if(trigger.isAfter && siteContactslst.size() > 0) {    
    insert siteContactslst;
  }    
        
  //-----------------------------------------//
  //To query existing contacts to check duplicate for the same account before inserting the contact
  //-----------------------------------------//      
  private void queryExistingDuplicateContacts() {   
    if(trigger.isAfter) {
      return;
    }
   // for(Contact contact : [select id,LastName,Email,AccountId from Contact where lastName IN :stLastNames OR Email IN :stEmailIds OR AccountId IN :stAccountIds]) {
   for(Contact contact : [select id,LastName,Email,AccountId from Contact where (lastName IN :stLastNames AND AccountId IN :stAccountIds) OR (Email IN :stEmailIds AND AccountId IN :stAccountIds)]) {
      stNameAccountKey.add(generateKey(contact.LastName,contact.AccountId));
      if(contact.Email != null) {
        stEmailAccountKey.add(generateKey(contact.Email,contact.AccountId));
      }  
       
    }  
  }
  
  //-----------------------------------------//
  //To query site Accounts to be updated
  //-----------------------------------------//      
 /* private void querySiteAccounts() { 
    if(trigger.isBefore) {
      return;
    }
    mpSiteAccounts = new Map<Id,Account>([select id,Site_Primary_Contact__c,Site_Contact2__c,Site_Contact3__c,Site_Contact4__c,Site_Contact5__c,Site_Contact6__c from Account where Id IN :stAccountIds]);      
  }*/
  
  //-----------------------------------------//
  //To populate site (Account) primary contacts
  //-----------------------------------------//
  private void populateSiteAccountContacts(Contact contact,list<siteContacts__c> sclist) {
    Account account;
     SiteContacts__c sc = new SiteContacts__c();
          if (contact.Site_Account__c != null) {
              sc.Account__c=contact.Site_Account__c;
              sc.Contact__c=contact.ID;
              sclist.add(sc);
          }  
    /*if(mpSiteAccounts.containsKey(contact.Site_Account__c)) {
      account = mpSiteAccounts.get(contact.Site_Account__c);
    }    
    if((account.Site_Primary_Contact__c == null) ) { 
      account.Site_Primary_Contact__c = contact.Id;      
      return;
    }
    if(account.Site_Contact2__c == null) {      
      account.Site_Contact2__c = contact.Id;
      return;
    }
    
    if(account.Site_Contact3__c == null) {
      account.Site_Contact3__c = contact.Id;
      return;
    }
    if(account.Site_Contact4__c == null) {
      account.Site_Contact4__c = contact.Id;
      return;
    }
    if(account.Site_Contact5__c == null) {
      account.Site_Contact5__c = contact.Id;
      return;
    }
    if(account.Site_Contact6__c == null) {
      account.Site_Contact6__c = contact.Id;
      return;
    } */
  }
    
  //-----------------------------------------//
  //To generate key to be used for mapping
  //-----------------------------------------//
  private String generateKey(String nameORmail , String accountId) {
    return nameORmail.toUpperCase() + '-' + accountId;
  }  
  
}