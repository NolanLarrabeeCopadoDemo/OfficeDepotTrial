/*****************************************************************
*Apex Class : AccountSiteContactExtension
*Purpose : Queries the contact associated with Sites and shows them as related list
           on Account page layout
*******************************************************************/

public with sharing class AccountSiteContactExtension {
  
  private Account account;
  private  List<Contact> lstContact;
    public Map<ID,Boolean> contactPrimaryMap {get;set;}
    public Map<ID,ID> contactSiteMap {get;set;}
  public List<String> ProfileNames= new List<String>();
  public List<Profile> profilePin= new List<Profile>();
  public Boolean displaypin{get;set;}
    public ID selectedsiteContact {get;set;}
    public String ActionCode {get;set;}
    
  
  //===============================================================//
  //Constructor
  //===============================================================//
  public AccountSiteContactExtension(ApexPages.StandardController controller) {
    displaypin=false;

    contactPrimaryMap = new Map<ID,Boolean>();
    contactSiteMap = new Map<ID,ID>();
    //Contact_Pin_Profiles__c is the custom settings where we kept the name of profiles that needs to see the Pin field of contact.
    /// Removing as part of cleaning process
    /*List<Contact_Pin_Profiles__c> ASMReminderDate=Contact_Pin_Profiles__c.getall().values(); 
    for(Contact_Pin_Profiles__c alias:ASMReminderDate)
    {
        ProfileNames.add(alias.Profile_Name__c);
    }
    system.debug('The profiles are-->'+ProfileNames);
    */
    profilePin = [select id, name from Profile where id=:userinfo.getprofileid() and name IN:ProfileNames];
    system.debug('The size-->'+profilePin.size());
    if(profilePin.size()>0)
    {
        displaypin=true;
    }
    this.account = (Account)controller.getRecord();
    PopulateContactDetails(populateSiteContactId());
  }
  
  public List<Contact> getSiteContacts() {
    return this.lstContact;
  }
  
  //========================================================================//
  //Query and populate details
  //=======================================================================//
  private void PopulateContactDetails(Set<Id> setContactId) {
    this.lstContact = [Select Name,Email,lastactivitydate, Phone_Ext__c, primary_contact__c,Phone,Title,Decision_Maker__c,Role__c,MobilePhone,Pin__c from Contact where ID IN :setContactId order by Name];
  }
  
  
  //=====================================================================//
  //Contact Ids to be retrieved, if any Id is null,no worries, the query won't pick up
  //=====================================================================//
  private Set<Id> populateSiteContactId() {
    Set<Id> setContactId = new Set<Id>();
    
      for (SiteContacts__c sc:[select id,contact__c,primary__c from SiteContacts__c where account__c=:account.id]) {
         setContactId.add(sc.contact__c);
         contactPrimaryMap.put(sc.contact__c,sc.primary__c);
         contactSiteMap.put(sc.contact__c,sc.id);
      }
   //Commented - Replaced with Junction Object 
   /*setContactId.add(account.Site_Primary_Contact__c);
    setContactId.add(account.Site_Contact2__c);
    setContactId.add(account.Site_Contact3__c);
    setContactId.add(account.Site_Contact4__c);
    setContactId.add(account.Site_Contact5__c);
    setContactId.add(account.Site_Contact6__c);
    */
    
    return setContactId;
  }
    
    public void siteContactUpd() {
        system.debug('Actions:'+ ActionCode+'ID:'+selectedSiteContact);
        SiteContacts__c sc = [select id,account__c,contact__c,primary__C from SiteContacts__c where ID=:selectedSiteContact];
        list<SiteContacts__c> sclist = new list<SiteContacts__c>();
        if (ActionCode == 'P') {
            
            sc.primary__c=true;
            sclist.add(sc);
            for (siteContacts__c s:[select id,primary__c from siteContacts__c where account__c=:sc.account__c and primary__c=true and id!=:sc.id]) {
                s.primary__c=false;
                sclist.add(s);
            }
            
            if (sclist.size() > 0)
                update sclist;
        }
        if (ActionCode == 'D') {
            delete sc;
        }
        PopulateContactDetails(populateSiteContactId());
        
    }
  
  
}