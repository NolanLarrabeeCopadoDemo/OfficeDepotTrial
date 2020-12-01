global class LeadService{

 global class LeadInformation {
    webservice String COMPANY;
    webservice String EMAIL;
    webservice String PHONE;
    webservice String FIRSTNAME;
    webservice String LASTNAME;
    webservice String DESCRIPTION;
    webservice Decimal WCW;
    webservice String ADDRESS1;
    webservice String ADDRESS2;
    webservice String CITY;
    webservice String STATE;
    webservice String LOGINNAME;
    webservice String ZIP;
    webservice String DUNS;
    webservice String PROFILEID;
    webservice String LEADSOURCE;
    webservice boolean STATUS;
    webservice String ErrorMessage;
    webservice String CONTACTID;
    webservice String USERID;
    webservice String AOPSID;
  }
    
 webservice static LeadInformation createUser(LeadInformation l, ID Acct) {
     Savepoint sp = Database.setSavepoint();
     String emailRegex = '([a-zA-Z0-9_\\-\\.]+)@((\\[a-z]{1,3}\\.[a-z]{1,3}\\.[a-z]{1,3}\\.)|(([a-zA-Z0-9\\-]+\\.)+))([a-zA-Z]{2,4}|[0-9]{1,3})';
     Pattern ePattern = Pattern.compile(emailRegex);
     Matcher eMatcher;
     
    try {
       
       Contact c = new Contact (
            AccountId = Acct,
            GPO_Community__c = Acct,
            FirstName = l.FIRSTNAME,
            LastName  = l.LASTNAME,
            Phone     = l.PHONE,
            Email     = l.EMAIL,
            AOPS_Contact_Number__c = l.AOPSID
       );
       insert c;
        
        String Alias;
        
        if (l.LASTNAME.length() > 8)
          Alias = l.LASTNAME.substring(0, 8);
        else
          Alias = l.LASTNAME;
          
         eMatcher = ePattern.matcher(l.LOGINNAME);
         
         String uname;
           
         if (eMatcher.matches()) {
              uname = l.LOGINNAME;
              
         }
         else 
            uname= l.LOGINNAME + '@gpocomm.com';
        
        string fedname = l.LOGINNAME;
        if (fedname != null)
          fedname = fedname.toUpperCase();
        
        User u = new User(
            ContactId = c.id,
            FirstName = l.FIRSTNAME,
            LastName  = l.LASTNAME,
            Username  = uname,
            Alias     = Alias,
            Email     = l.EMAIL,
            Phone     = l.PHONE,
            TimeZoneSidKey = 'GMT',
            LOCALESIDKEY = 'en_US',
            EMAILENCODINGKEY = 'ISO-8859-1', 
            LANGUAGELOCALEKEY = 'en_US',
            ProfileId = l.PROFILEID,
            FederationIdentifier = fedname
           
        );
        Insert u;
       l.status = true;
       l.CONTACTID = c.id;
       l.USERID = u.id;
       return l;
      }
    catch(Exception e) {
       l.STATUS = false;
       l.ErrorMessage = e.getMessage();
       Database.rollback(sp);
       return l;
     }
       
   }
  
  
   webservice static LeadInformation insertLead(LeadInformation l) {
    try
    {
      GPO_Community_Setup__c commSetup = gpo_community_setup__c.getValues('default');
      Lead ld = new Lead(Company  = l.COMPANY,
                           Email = l.EMAIL,
                           FirstName= l.FIRSTNAME,
                           LastName= l.LASTNAME,
                           Description= l.DESCRIPTION,
                           Phone= l.PHONE,
                           WCW_Count__c = l.WCW,
                           Address1__c = l.ADDRESS1,
                           Address2__c = l.ADDRESS2,
                           City__c     = l.CITY,
                           State__c    = l.STATE,
                           Duns_Number__c = l.DUNS,
                           ZIP__C= l.ZIP,
                           Lead_Page_Source__c = commSetup.Lead_Page_Source__c,
                           LeadSource= l.LEADSOURCE,
                           website = l.ErrorMessage
                        );
      insert ld;
      l.errorMessage = null;
      l.STATUS = true;
      return l;
     }
     catch(Exception e) {
       l.STATUS = false;
       l.ErrorMessage = e.getMessage();
       return l;
     }
   }
  
  }