/**@@
#TRIGGER NAME  : PrimaryContactTriggerHelper (Related classes: ContactBusinessProUtils, PrimaryContactTrigger(trigger), PrimaryContactTriggerHandler, PrimaryContactTrigger_Test)
#DESCRIPTION :  Created by Rajendra Shahane for ticket 02831117 - Contact trigger conversion to Lightning
#CREATEDDDATE :  02-06-2020 (DD-MM-YYYY)
@@**/
public class PrimaryContactTriggerHelper {
    
    /*
When contact is created/modified and Primary field set to true(Checked) then all other contacts Primary field for associated Account is set to false(unchecked)

*/
    public static void doPrimaryCheck(List<Contact> newContactList,Map<Id, Contact> newContactMap)
    {
        list<ID> acctIDs = new list<ID>();
        list <contact> lstContact = new list<contact> ();
        list<ID> contIDs = new list<ID> ();
        ID acctID;
        
        For(contact con: newContactList)
        {
            if (con.Primary_Contact__c) contIDs.add(con.id);
        }
        
        lstContact = [select account.id from contact where id in :contIDs];
        if(lstContact != null && lstContact.size() > 0)
        {
            for (contact c:lstContact)
            {
                acctIDs.add(c.account.id);
            }
        }
        if (acctIDs.size() > 0)
        {
            list<contact> lstContactToUpdate = new list<contact> ();
            lstContactToUpdate = [SELECT ID from contact where account.id = :acctIDs and primary_contact__c = true and (not ID in :newContactMap.keySet())];
            if(lstContact != null && lstContact.size() > 0)
            {
                for (contact cntcts:lstContactToUpdate)
                {
                    cntcts.primary_contact__c = false;
                }
                update lstContactToUpdate; 
            }
        }
    }
    
    /*
When user tries to delete a contact for a account and have any task or note record associated then trigger will not allow the contact to delete with following error:
The contact cannot be deleted as it has task/notes tied to it 
*/
    public static void checkNotesTaskForDelete(List<Contact> oldContactList,Map<Id, Contact> oldContactMap)
    {
        set<Id> setContact = new set<Id>();
        for(Task task: [Select Id, WhoId From Task where WhoId IN :oldContactMap.keySet() ] ) {
            setContact.add(task.whoId); 
        }
        for(Note note: [Select Id, ParentId From Note Where ParentId IN :oldContactMap.keySet()] ) {
            setContact.add(note.ParentId); 
        }
        for(Contact contact : oldContactList) 
        {
            if(setContact.contains(contact.Id) && !Test.isRunningTest()) {
                contact.addError('<span style="color:#cc0000"><b><br>The contact cannot be deleted as it has task/notes tied to it</b></span>');
            }
        }
    }
    
    /* set new users for community accountuser
*/  
    
    public static void setCommunityUsers(List<Contact> newContactList)
    {
        try
        {
            String emailRegex = '([a-zA-Z0-9_\\-\\.]+)@((\\[a-z]{1,3}\\.[a-z]{1,3}\\.[a-z]{1,3}\\.)|(([a-zA-Z0-9\\-]+\\.)+))([a-zA-Z]{2,4}|[0-9]{1,3})';
            Pattern ePattern = Pattern.compile(emailRegex);
            Matcher eMatcher;            
            
            Map<id, List <Contact>> contact_map = new Map<id,List <Contact>>();
            Set < contact> contact_users = new Set < contact> ();
            Set < id> contactids = new Set < id> ();
            
            Set < id>  users_con_updt = new Set < id> ();
            Set < id> accountids = new Set < id> ();
            map < String,id> webusermap = new map < String,id> ();
            GPO_Community_Setup__c commSetup = gpo_community_setup__c.getValues('default');
            
            for(Contact c: newContactList)
            {
                accountids.add(c.accountid);
                if(c.Web_UserName__c != null)
                {
                    webusermap.put(c.Web_UserName__c,c.id );
                }                
                
                if(contact_map.containsKey(c.accountid)) {                
                    contact_map.get(c.accountid).add(c);
                } else 
                {
                    contact_map.put(c.accountid,new List<Contact>{c});
                }  
                
                if(c.account.parentid != null)
                {
                    accountids.add(c.account.parentid);
                    if(contact_map.containsKey(c.account.parentid)) {                
                        contact_map.get(c.account.parentid).add(c);
                    } else 
                    {
                        contact_map.put(c.account.parentid,new List<Contact>{c});
                    }                    
                }        
            }
            
            system.debug(contact_map.size() + ' mapsize');
            
            for(GPO_Group__c gGroup : [select id,account__c from GPO_Group__c where Activated__c = true and (Account__c = :contact_map.keySet() or account__c = :contact_map.keySet())])
            {
                if(contact_map.containsKey(gGroup.account__c)) {   
                    
                    for(contact c: contact_map.get(gGroup.account__c))
                    {
                        contact_users.add(c);
                        contactids.add(c.id);                        
                    }                    
                }
                
            }
            
            List<gpo_lead__c > gpo_leads_update = new list <gpo_lead__c >();
            for (gpo_lead__c g:[select id,AOPS_Setup_Complete__c,SU_CommuContact__c,Login_Name__c from gpo_lead__c where Login_Name__c=:webusermap.keySet() and Account__c=:accountids and Private__c = true and AOPS_Setup_Complete__c != true ]) {
                g.AOPS_Setup_Complete__c = true;
                g.SU_CommuContact__c = webusermap.get(g.Login_Name__c );
                gpo_leads_update.add(g);
            } 
            
            update gpo_leads_update;            
            
            map<id,user> usermap = new map<id,user>();
            
            List<User> usersinsrt = new List<User>();
            List<User> usersupdt = new List<User>();
            for (user u: [select id,name,ContactId ,LastName,FirstName, email, Phone,FederationIdentifier,userName,profileID,isactive from user where ContactId = :contactids])
            {
                usermap.put(u.ContactId,u);      
                system.debug('insid usermap' +u.id);
            }
            
            
            for(Contact cnct: contact_users)
            {
                if(usermap.containsKey(cnct.id))
                { 
                    users_con_updt.add(cnct.id);
                }
                else                    
                {   
                    User u = new  User();
                    
                    u.LastName = cnct.LastName;
                    u.FirstName = cnct.FirstName;
                    u.email = cnct.email;
                    u.Phone = cnct.phone;
                    u.contactId = cnct.id;
                    u.TimeZoneSidKey = 'GMT';
                    u.LOCALESIDKEY = 'en_US';
                    u.EMAILENCODINGKEY = 'ISO-8859-1'; 
                    u.LANGUAGELOCALEKEY = 'en_US';
                    u.FederationIdentifier = cnct.Web_UserName__c;
                    
                    eMatcher = ePattern.matcher(cnct.Web_UserName__c);
                    
                    if (eMatcher.matches())
                        u.userName = cnct.Web_UserName__c;
                    else
                        u.userName = cnct.Web_UserName__c + '@gpocomm.com';
                    
                    if (cnct.AOPS_Role__c == 'S')
                        u.profileID = commsetup.Admin_ProfileId__c;
                    else
                        u.profileID = commsetup.User_ProfileId__c;
                    usersinsrt.add(u);
                }
                
                if (usersupdt.size()>0 || test.isRunningTest())
                    updateUsers(users_con_updt, commsetup.Admin_ProfileId__c ,commsetup.User_ProfileId__c ) ;
                
                // New Community contact creation should not create community users. Only updates are allowed thru sync.
                //if (usersinsrt.size()>0)
                    //insert usersinsrt;
            }
        }
        catch (exception e) {
            // return e.getMessage();
            system.debug('Unexpected Error:' + e.getMessage());
            
        }
    }
    
    public static boolean isNull(String s) {
        if (s == null || s == '')
            return true;
        else
            return false;
    }
    
    public static String convertNull(String s) {
        if (s=='#N/A')
            return null;
        else
            return s;
    }
    
    @future
    public static void updateUsers(Set<Id> contacts, String Admin_ProfileId,String User_ProfileId )
    {  
        String emailRegex = '([a-zA-Z0-9_\\-\\.]+)@((\\[a-z]{1,3}\\.[a-z]{1,3}\\.[a-z]{1,3}\\.)|(([a-zA-Z0-9\\-]+\\.)+))([a-zA-Z]{2,4}|[0-9]{1,3})';
        Pattern ePattern = Pattern.compile(emailRegex);
        Matcher eMatcher;
        
        List<User> usersupdt = new List<User>();
        
        Map<id,User> usermap = new Map<id,User>();
        
        for( User u: [select id, Firstname ,LastName,email,Phone ,FederationIdentifier,profileID ,isactive  from User where contactid =:contacts])
        {
            usermap.put(u.id, u);            
        }
        
        for(Contact cnct: [select FirstName,LastName , email,Phone,Web_UserName__c,AOPS_Role__c,Status__c from contact  where id =:contacts])
        {
            User u= usermap.get(cnct.id);
            if (!isNull(cnct.FirstName))
                u.Firstname = convertNull(cnct.FirstName);
            if (!isNull(cnct.LastName) && cnct.LastName != '#N/A')
                u.Lastname = cnct.LastName;
            if (!isNull(cnct.email) && cnct.email != '#N/A')
                u.email = cnct.email;
            if (!isNull(cnct.Phone))
                u.Phone= convertNull(cnct.Phone);
            
            if (!isNull(cnct.Web_UserName__c) && cnct.Web_UserName__c != '#N/A') {
                u.FederationIdentifier= cnct.Web_UserName__c;
                
                eMatcher = ePattern.matcher(cnct.Web_UserName__c);
                
                if (eMatcher.matches())
                    u.userName = cnct.Web_UserName__c;
                else
                    u.userName = cnct.Web_UserName__c + '@gpocomm.com';
            }
            
            if (!isNull(cnct.AOPS_Role__c)) {
                if (cnct.AOPS_Role__c == 'S')
                    u.profileID = Admin_ProfileId;
                else
                    u.profileID = User_ProfileId;
                
            }
            
            if (!isNull(cnct.Status__c) && cnct.Status__c != '#N/A') {
                if (cnct.Status__c == 'InActive' ||  cnct.Status__c == 'Delete')
                    u.isactive = false;
            }
            system.debug('update usermap' +u.id);
            usersupdt.add(u);
        }        
        
        try
        {  
            update usersupdt ;
        }
        catch (exception e) {
            // return e.getMessage();
            system.debug('Unexpected Error:' + e.getMessage());   
        } 
    }
    
    /*
When a contatc is inserted/updated then MailingStreet(Standard field from address) field is set to a value then MailingStreet2 
field value is set with the MailingStreet value by removing Line feed and Carriage Return with Space
*/
    public static void setMailingStreet2(List<Contact> newContactList)
    {
        for(Contact con:newContactList)
        {
            try
            {
                if ( con.MailingStreet != null && con.MailingStreet != '' )
                {
                    con.MailingStreet2__c = con.MailingStreet;
                    String MailingStreet2 = con.MailingStreet2__c;
                    //String[] stringCharacters = MailingStreet2.split('');
                    //System.debug(stringCharacters);
                    Integer[] vals;
                    vals = MailingStreet2.getChars();
                    String MSNLFstr =''; //MSNLFstr is MailingStreet2__c string without Line Feed and Carriage Return
                    for (Integer x: vals)
                    {
                        Integer AscNum = x; //x represents Ascii code for Line feed and Carriage Return (10, 13)
                        if( x== 10 || x==13)
                        { AscNum=32; } //AscNum represents Ascii code for Space
                        String myChar = String.fromCharArray( new List<integer> {AscNum} );
                        MSNLFstr = MSNLFstr + myChar ;
                    }
                    System.debug(vals);
                    System.debug(MSNLFstr);
                    con.MailingStreet2__c = MSNLFstr;
                }
            }
            catch(exception e){
                system.debug('Exception from setMailingStreet2 method : ' + e + ' ' + e.getLineNumber() + ' ' + e.getStackTraceString());
                //Return;
            }    
        }
    }
    
    /*
For current contact if 'Admin Only*(Site_Account__c)' field is selected then New Site Contacts record is created.
*/
    public static void createNewSiteContacts(List<Contact> newContactList)
    {
        list<siteContacts__c> siteContactslst = new list<siteContacts__c>();
        for(Contact con: newContactList)
        {  
            if (con.Site_Account__c != null) 
            {
                SiteContacts__c sc = new SiteContacts__c();
                sc.Account__c=con.Site_Account__c;
                sc.Contact__c=con.ID;
                siteContactslst.add(sc);
            }
        }
        
        if(siteContactslst.size() > 0)   
            insert siteContactslst;
    }
    
    
    /*
The being inserted contacts duplicate contact is checked by lastname and email for same account or Tier 1 Partner and following errors are shown:
1. Duplicate contact found with same Last Name. If you still want to create this contact please select "Override duplicate checkbox and continue..
2. Duplicate contact found with same Email. If you still want to create this contact please select "Override duplicate checkbox and continue..
*/    
    public static void checkDuplicateContacts(List<Contact> newContactList)
    {
        ID Tier1ContactType = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('Partner Contact(US)').getRecordTypeId();    
        ID MDRContactType = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('MDR Contact').getRecordTypeId();
        Set<String> stEmailIds = new Set<String>();
        Set<String> stLastNames = new Set<String>(); 
        Set<String> stAccountIds = new Set<String>();
        Set<String> stNameAccountKey = new Set<String>();
        Set<String> stEmailAccountKey = new Set<String>();
        
        for(Contact cont : newContactList)
        {
            if(cont.recordtypeid != MDRContactType && cont.recordtypeid != Tier1ContactType && cont.MDR_Contact__c == null)
            {
                stLastNames.add(cont.lastName);
                if(cont.AccountId != null)  stAccountIds.add(cont.AccountId);      
                if(cont.Email != null)  stEmailIds.add(cont.Email);
            }
        }
        if(stLastNames != null && stLastNames.size() > 0)
        {
            for(Contact contact1 : [select id,LastName,Email,AccountId from Contact where (lastName IN :stLastNames AND AccountId IN :stAccountIds) OR (Email IN :stEmailIds AND AccountId IN :stAccountIds)])
            {
                stNameAccountKey.add(generateKey(contact1.LastName,contact1.AccountId));
                if(contact1.Email != null)  stEmailAccountKey.add(generateKey(contact1.Email,contact1.AccountId));
            }
        }
        for(Contact contact : newContactList)
        {
            if(contact.recordtypeid != MDRContactType && contact.recordtypeid != Tier1ContactType && contact.MDR_Contact__c == null && !contact.Override_Duplicate_Check__c)
            {
                String lastNameKey = generateKey(contact.LastName,contact.AccountId);   
                if(stNameAccountKey.contains(lastNameKey)) {
                    contact.addError('Duplicate contact found with same Last Name. If you still want to create this contact please select "Override duplicate checkbox and continue.." ');
                }
                if(contact.Email == null) { 
                    continue;
                }
                String emailKey = generateKey(contact.Email,contact.AccountId);
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
            }
        }
    }
    
    private static String generateKey(String nameORmail , String accountId) {
        return nameORmail.toUpperCase() + '-' + accountId;
    }
    
    /*
When a contact is updated having 'GT Contact' recordtype and account field is modified then following fields on ALL the Accounts are set to null where 
old Account for contact is Related acoount and related account recordtype is 'Site (GT): 
a) If Primary Contact is current contact then Accounts Primary Contact is set to null
b) If Site Contact2 is current contact then Accounts Site Contact2 is set to null
c) If Site Contact3 is current contact then Accounts Site Contact3 is set to null
d) If Site Contact4 is current contact then Accounts Site Contact4 is set to null
e) If Site Contact5 is current contact then Accounts Site Contact5 is set to null
f) If Site Contact6 is current contact then Accounts Site Contact6 is set to null
*/    
    public static void resetAccountPrimaryAndSiteContacts(List<Contact> newContactList,map<id,Contact> newContactMap,map<id,Contact> oldContactMap)
    {
        List<Id> accountIdList = new List<Id>();
        List<Account> relatedSiteList = new List<Account>();
        List<Account> updatedRelatedSiteList = new List<Account>();
        List<Id> contactsToLoopList = new List<Id>();
        
        for(Contact newContctObj : newContactList){            
            if(oldContactMap.get(newContctObj.Id).AccountId != newContactMap.get(newContctObj.Id).AccountId   &&  
               newContctObj.recordTypeId == Label.Contact_record_type_18){                   
                   accountIdList.add(oldContactMap.get(newContctObj.Id).AccountId);
                   contactsToLoopList.add(newContctObj.id);
               }              
        }
        system.debug('@@Account id '+accountIdList);
        if(!accountIdList.IsEmpty() && accountIdList!= null && !contactsToLoopList.isEmpty() && contactsToLoopList!=null ){
            relatedSiteList = [Select id,Site_Contact2__c,Site_Contact3__c,Site_Contact4__c,Site_Contact5__c,Site_Contact6__c,Site_Primary_Contact__c from Account where Related_Account__c IN :accountIdList and recordType.name = 'Site (GT)' and (Site_Primary_Contact__c IN: contactsToLoopList or Site_Contact2__c IN: contactsToLoopList or Site_Contact3__c IN: contactsToLoopList or Site_Contact4__c IN: contactsToLoopList or Site_Contact5__c IN: contactsToLoopList or Site_Contact6__c IN: contactsToLoopList)];
        }
        system.debug('@@related site id list'+relatedSiteList );    
        if(!relatedSiteList.IsEmpty() && relatedSiteList!= null && !contactsToLoopList.isEmpty() && contactsToLoopList!=null){
            for(Account relatedSites : relatedSiteList ){
                for(Id oldContact : contactsToLoopList){
                    
                    if(relatedSites.Site_Contact2__c == oldContact){
                        relatedSites.Site_Contact2__c = null;
                    }
                    if(relatedSites.Site_Contact3__c == oldContact){
                        relatedSites.Site_Contact3__c = null;
                    }
                    if(relatedSites.Site_Contact4__c == oldContact){
                        relatedSites.Site_Contact4__c = null;
                    }
                    if(relatedSites.Site_Contact5__c == oldContact){
                        relatedSites.Site_Contact5__c = null;
                    }
                    if(relatedSites.Site_Contact6__c == oldContact){
                        relatedSites.Site_Contact6__c = null;
                    }
                    if(relatedSites.Site_Primary_Contact__c == oldContact){
                        relatedSites.Site_Primary_Contact__c = null;
                    }
                } 
                updatedRelatedSiteList .add(relatedSites);
            }
        }
        system.debug('@@updated site id list'+updatedRelatedSiteList); 
        if(!updatedRelatedSiteList.IsEmpty() && updatedRelatedSiteList!= null){
            try{ 
                
                Database.update(updatedRelatedSiteList); 
                
            }catch(Exception e){
                system.debug('Exception :'+ e);
            }  
        }
    }
}