global class ContactInboundAOPS {
//
// (c) 2015 Appirio, Inc.
//
// Accept Contacts from AOPS
//
// 6 Mar 2015     Appirio CM (JGUPTA) - S-294658 (Office Depot Case 340885)
//
//  Indra Varada - Code Modified to handle BSD User Communities
    
    // ===================== WRAPPER CLASS: to store contact details ====================
    global class ContactInboundWrapper {
        webservice string fName;
        webservice string lName;
        webservice string phone;
        webservice string email;
        webservice string webUserName;
        webservice string role;
        webservice String status;
        webservice string aopsCntId;
        webservice string aopsActId;
        webservice string aopsSequenceNum;
    }
    global class processResponse {
        webservice String statusCode;
        webservice String statusDescription;
        webservice String salesforceID;
    }
    
    //===================== Method to upsert Single contact at a time =========================
    webservice static processResponse upsertContact(ContactInboundWrapper preq) {
        //Grab SFDC Account ID
        
        

        
        String emailRegex = '([a-zA-Z0-9_\\-\\.]+)@((\\[a-z]{1,3}\\.[a-z]{1,3}\\.[a-z]{1,3}\\.)|(([a-zA-Z0-9\\-]+\\.)+))([a-zA-Z]{2,4}|[0-9]{1,3})';
        Pattern ePattern = Pattern.compile(emailRegex);
        Matcher eMatcher;
        
        string operation;
        processResponse pres = new processResponse();
        
        if (preq.aopsCntId == null || preq.aopsActId == null) {
          pres.statuscode = '01';
          pres.statusDescription = 'AOPS Account Number and AOPS Contact Number are required';
          return pres;
        }
        
        GPO_Community_Setup__c commSetup = gpo_community_setup__c.getValues('default');
        List<Account> sfActList = new List<Account>([select id, name,AOPS_Cust_Id__c from account  where AOPS_Cust_Id__c = :preq.aopsActId order by CreatedDate DESC limit 1]);
        System.debug('====='+sfActList);
        Account sfAct ;
        String commGroupAcct;
        if(sfActList.size() > 0) {
            sfAct = sfActList.get(0);
        } else {
            //return 'No account found with matching aops acct id.' ;
            pres.statuscode = '01';
            pres.statusDescription = 'No Account found with the matching aops acct id';
            return pres;
        }
        
        try {
            // Fetch existing SF contact on the basis of aopsCntId value
            List<Contact> sfConList = new List<Contact>([Select Id,AccountId,FirstName,LastName,Phone,Email,Role__c,Web_UserName__c,AOPS_Contact_Number__c,AOPS_Account_Number__c,AOPS_Sequence_Number__c 
                                                        from Contact where AOPS_Contact_Number__c = :preq.aopsCntId order by CreatedDate DESC limit 1]);
            contact cnt ;
            list<account> acc = new list<account> ([select id,parentid from account where aops_cust_id__c = :preq.aopsActId]);
            
            if (acc.size() > 0) {
              list<gpo_group__c> gGroup = new list<gpo_group__c>();
              system.debug('checkpoint1');
              system.debug('checkpoint1x');
              if (acc[0].parentid != null) {
              system.debug('checkpoint9');
                gGroup = [select id,account__c from GPO_Group__c where Activated__c = true and (Account__c = :acc[0].id or account__c = :acc[0].parentid)];
              system.debug('checkpoint10');
              }
              else {
                system.debug('checkpoint11');
                gGroup = [select id,account__c from GPO_Group__c where Activated__c = true and Account__c = :acc[0].id];
                system.debug('checkpoint12');
              }
              if (gGroup.size() > 0) {  
                for (gpo_group__c g : gGroup) {
                  system.debug('checkpoint3');
                  commGroupAcct = g.account__c;
                  system.debug('checkpoint4');
                  if (acc[0].id == g.account__c) {
                    break;
                    system.debug('checkpoint5');
                  }
                }
              }
            }
            system.debug('checkpoint2');
            if(sfConList.size() > 0) {
                cnt = sfConList.get(0) ; // Update existing contact if found
                operation = 'U';
            } else {
                cnt = new contact (); // else create new one
                operation = 'C';
            }
            //Populate Data 
            if (operation == 'C' && (isNull(preq.lname) || isnull(preq.email) || isnull(preq.webUserName) || isnull(preq.role))) {
              system.debug('Error:One or More Required Values FirstName,LastName,Email,UserName,Role not passed');
              pres.statuscode = '01';
              pres.statusDescription = 'One or More Required Values FirstName,LastName,Email,UserName,Role not passed';
              return pres;
            }
            
            if (operation == 'C') {
             cnt.Firstname = preq.fname;
             cnt.Lastname =preq.lname;
             cnt.Phone = preq.phone;
             cnt.Email = preq.email;
             //cnt.Web_Username__c = preq.webUserName;
             //cnt.Role__c = preq.role;
            }
            else {
              if (!isNull(preq.fname))
                cnt.Firstname = convertNull(preq.fname);
              if (!isNull(preq.lname))
                cnt.Lastname = convertNull(preq.lname);
              if (!isNull(preq.phone))
                cnt.Phone = convertNull(preq.phone);
              if (!isNull(preq.email))
                cnt.Email = convertNull(preq.email);
            }
            cnt.AOPS_Contact_Number__c = preq.aopsCntId;
            //cnt.AOPS_Account_Number__c = preq.aopsActId;
            //cnt.AOPS_Sequence_Number__c = preq.aopsSequenceNum;
            cnt.AccountId = sfAct.Id;
            
            if (commGroupAcct != null)
              cnt.GPO_Community__c = commGroupAcct;

            //Perform Upsert and Reuturn ID
            if (operation == 'C') {
             system.debug('Before Contact Creation');
             upsert cnt;
             system.debug('&&&---'+preq.email+' '+sfAct.Name);
             system.debug('&&&---'+[select id,AOPS_Setup_Complete__c from gpo_lead__c where email__c=:preq.email and Account__c=:sfAct.id and Private__c = true limit 1]);
             if (sfAct != null) {
              for (gpo_lead__c g:[select id,AOPS_Setup_Complete__c,SU_CommuContact__c from gpo_lead__c where Login_Name__c=:preq.webUserName and Account__c=:sfAct.id and Private__c = true limit 1]) {
                      g.AOPS_Setup_Complete__c = true;
                      g.SU_CommuContact__c = cnt.id;
                      update g;
               }
             }  
             
           }
            
            User u;
            boolean newUser = false;
            list<user> ulist = new list<user> ([select id,name from user where ContactId = :cnt.id]);
            
            if (ulist.size() > 0) {
              u = ulist.get(0);
            }
            else {
             u = new User();
             newUser = true;
            }
            
            if (newUser) {
             u.LastName = preq.lname;
             u.FirstName = preq.fname;
             u.email = preq.email;
             u.Phone = preq.phone;
             u.contactId = cnt.id;
             u.TimeZoneSidKey = 'GMT';
             u.LOCALESIDKEY = 'en_US';
             u.EMAILENCODINGKEY = 'ISO-8859-1'; 
             u.LANGUAGELOCALEKEY = 'en_US';
             u.FederationIdentifier = preq.webUserName;
             
             eMatcher = ePattern.matcher(preq.webUserName);
             
             if (eMatcher.matches())
              u.userName = preq.webUserName;
             else
              u.userName = preq.webUserName + '@gpocomm.com';
             
             if (preq.role == 'S')
              u.profileID = commsetup.Admin_ProfileId__c;
             else
              u.profileID = commsetup.User_ProfileId__c;
            
            }
            else {
              if (!isNull(preq.fname))
                u.Firstname = convertNull(preq.fname);
              if (!isNull(preq.lname) && preq.lname != '#N/A')
                u.Lastname = preq.lname;
              if (!isNull(preq.email) && preq.email != '#N/A')
                u.email = preq.email;
              if (!isNull(preq.Phone))
                u.Phone= convertNull(preq.Phone);
              
              if (!isNull(preq.webUserName) && preq.webUserName != '#N/A') {
                u.FederationIdentifier= preq.webUserName;
                
                eMatcher = ePattern.matcher(preq.webUserName);
                
                if (eMatcher.matches())
                 u.userName = preq.webUserName;
                else
                  u.userName = preq.webUserName + '@gpocomm.com';
              }
             
              if (!isNull(preq.role)) {
                if (preq.role == 'S')
                  u.profileID = commsetup.Admin_ProfileId__c;
                else
                  u.profileID = commsetup.User_ProfileId__c;
                  
              }
              
              if (!isNull(preq.status) && preq.status != '#N/A') {
                if (preq.status == 'I')
                  u.isactive = false;
              }
                 
              
            }
            
           
            system.debug('Profile:' + u.userName+ ':' + u.profileID);
            
            
            if (newUser)
             insert u;
            else
             update u;
            
           //TODO: Update on Contact not allowed
           //if (operation == 'U')
           //  upsert cnt;
             

            //return 'Success - Contact Id:' + cnt.Id;
           pres.statuscode = '00';
           pres.salesforceID= cnt.id;
           return pres;
        }

        catch (exception e) {
               // return e.getMessage();
               system.debug('Unexpected Error:' + e.getMessage());
               pres.statuscode = '01';
               pres.statusDescription = e.getMessage();
               return pres;

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

    //===================== Method to upsert List of contacts at a time =========================
    // The below Method is Obsolete and should not be used.
    
    webservice static list<processResponse> upsertContactList(List<ContactInboundWrapper> contactDetail) {
        //Create Map of account id and aopsaccount id 
        Map<String,String> accountIDMap = new Map<String,String>();
        list<processResponse> presl = new list<processResponse>();
        Set<String> aopsAccIds = new Set<String>();
        for(ContactInboundWrapper cw : contactDetail) {
            aopsAccIds.add(cw.aopsActId);
        }
        // Fetch related accounts
        for(Account acc : [Select Id,AOPS_Cust_Id__c from Account where AOPS_Cust_Id__c IN : aopsAccIds]) {
            accountIDMap.put(acc.AOPS_Cust_Id__c,acc.Id) ;
            aopsAccIds.remove(acc.AOPS_Cust_Id__c);
        }
        
        //Create Map of contact id and aopsCntId
        Map<String,String> contactIDMap = new Map<String,String>();
        Set<String> aopsConIds = new Set<String>();
        for(ContactInboundWrapper cw : contactDetail) {
            aopsConIds.add(cw.aopsCntId);
        }
        // Fetch related contacts
        for(Contact con : [Select Id,AOPS_Contact_Number__c from Contact where AOPS_Contact_Number__c IN : aopsConIds]) {
            contactIDMap.put(con.AOPS_Contact_Number__c,con.Id) ;
        }
        
        try {
            List<Contact> conListToUpdate = new List<Contact>();
            //Populate Data 
            for(ContactInboundWrapper cow : contactDetail) {
                contact cnt ;
                if(contactIDMap.containsKey(cow.aopsCntId)) {
                    cnt = new Contact(Id = contactIDMap.get(cow.aopsCntId));
                } else {
                    cnt = new contact ();
                }
                cnt.Firstname = cow.fname;
                cnt.Lastname =cow.lname;
                cnt.Phone = cow.phone;
                cnt.Email = cow.email;
                cnt.Web_Username__c = cow.webUserName;
                cnt.Role__c = cow.role;
                cnt.AOPS_Contact_Number__c = cow.aopsCntId;
                cnt.AOPS_Account_Number__c = cow.aopsActId;
                cnt.AOPS_Sequence_Number__c = cow.aopsSequenceNum;
                cnt.AccountId = accountIDMap.get(cow.aopsActId);
                conListToUpdate.add(cnt);
            }
            //Perform Upsert and Reuturn ID
            upsert conListToUpdate;
            // Show error if atleast 1 account is not found with the provided aopsaccids and do not perform any operation
            string retMessage = '' ;
            if(aopsAccIds.size() > 0) {
                List<String> aopsaccidList = new List<String>();
                aopsaccidList.addAll(aopsAccIds);
                retMessage += 'No account found with matching aops acct id:' + String.join(aopsaccidList,',');
            }
            retMessage += '\nSuccess - Contact Ids:' + conListToUpdate;
            
            //return retMessage ;
            return presl;
        }

        catch (exception e) {
                //return e.getMessage();
                return presl;

        }
    }
}