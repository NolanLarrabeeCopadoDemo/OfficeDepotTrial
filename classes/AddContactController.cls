/**
 * CreatedBy: Shravya Channamadhavuni
 * Date:11/14/2018
 * Description: Partner adding new contacts.
 */
public without sharing class AddContactController {
    
    //This method is to autopopulate the Accountname and to get the loggedin user's role
    @Auraenabled
    public static Map<string,String> getAccountName() {
        try {
            Map<String,String> returnMap = new Map<String,String>();
            //Retrieve the accountid and role
            User usr = [select id, contact.accountid, Userrole.portalrole from user where id = :UserInfo.getUserId() limit 1];
            //Retrieve the accountname using accountid
            Account acct = [select id, Name from Account where id = :usr.contact.accountid];
            //Add accountname and role to a map and return it to lightning controller
            returnMap.put('accountname', acct.Name);
            returnMap.put('portalrole', usr.Userrole.portalrole);
            system.debug('==>this method returns:'+returnMap);
            return returnMap;     
        } catch(Exception ex) {
            throw new AuraHandledException(ex.getMessage());   
        }
    }
    
    //This method is to insert the contact and call method to insert user
    @Auraenabled
    public static Contact saveContact(Contact objContact, String ouserrole) {
        try {
            //Query to get the accountid
            User usr = [select id, contact.accountid,Profileid from user where id = :UserInfo.getUserId() limit 1]; 
            //Query to get the recordtype id Partner contact
            RecordType objRecType = [SELECT Id, Name, SobjectType FROM RecordType where DeveloperName = 'Partner_Contact' And sobjectType = 'Contact' limit 1]; 
            for(User ousr:[select id from user where Email=:objContact.Email OR Username=:objContact.Email]) {
                    string errmsg = 'A User with same Email already exists';
                    AuraHandledException ex = new AuraHandledException(errmsg);
                    ex.setMessage(errmsg);
                    throw ex;
            }
             system.debug('==>Recordtype id is:'+objRecType+'==>User Role from lightning controller:'+ouserrole+'==>Fields entered:'+objContact);
             objContact.Override_Duplicate_Check__c= TRUE;
             objContact.RecordTypeId = objRecType.Id;
             objContact.AccountId = usr.contact.accountid;  
             insert objContact; 
        } catch(Exception ex) {
            throw new AuraHandledException(ex.getMessage());
        }
        
        // To create user
        addUser(objContact.id, ouserrole);
        // retunr objcontact
        return objContact;
    }
    
    @future
    public static void addUser(Id objContactid, String ouserrole) {
        try {            
            List<User> usrlst = new List<User>();
            List<String> usrids = new List<String>();
            //Retrieve the contact thats just created
            contact cntct = [select id, FirstName, LastName, email, Phone, Account.Name from contact where id = :objContactid];
            //Retrieve profile id
            Profile prf = [select id, name from profile where name = 'Partner community User custom'];
            // calling concatenateAccRole method to generate the role which is combination of account name and portal role
            String fuserrole = concatenateAccRole(ouserrole, cntct.Account.Name);
            // userrole returned from abouve method's id is retrieved
            Userrole us = [select id, Name from Userrole where Name =:fuserrole limit 1];
            system.debug('==>Profile id is:'+prf.Id+'==>User role is:'+fuserrole+'==>userrole id is:'+us.Id);
            User usr=new User();
            usr = getUserFromContact(cntct);
            usr.contactid = objContactid;  
            usr.ProfileId = prf.Id; 
            usr.UserRoleid=us.Id; 
            usrlst.add(usr); 
            //bulkifying
            insert usrlst;             
        } catch(Exception ex) {            
            throw new AuraHandledException(ex.getMessage());    
        }
    }
    
    //method called in above method
    private static String concatenateAccRole(String userrole,String accname) {
        if(userrole== 'Worker') {
          userrole='User';  
        }
        String partnerrole = accname + ' ' + 'Partner' + ' '+userrole;
        return partnerrole;
    }
    
    private static User getUserFromContact(Contact cntct) {
        User usr = new User();
        usr.FirstName = cntct.FirstName;
        usr.LastName = cntct.LastName;
        usr.Email = cntct.Email;
        usr.Alias = cntct.FirstName.substring(1,2) + cntct.LastName.substring(0,1);
        system.debug('==>Alias comes like this:'+usr.Alias);
        usr.LocaleSidKey = 'en_US';
        usr.LanguageLocaleKey = 'en_US';
        usr.Phone = cntct.Phone;
        usr.Username = cntct.Email;
        usr.EmailEncodingKey = 'UTF-8';
        usr.TimeZoneSidKey = 'America/New_York';
         return usr;
    }
}