/**
 * Controller for GPO Home Landing Page
 * Logic in this Controller should general and not contain any template specific details
 * Template details should be contained in a template specific Extention
 */
public without sharing class GPOCommunityLandingController {

    
    public GPO_Group__c selectedGroup {get; set;}  //GPO Group whos content should be displayed on the home page
    public Account gpoAccount {get; set;} //GPO Group Account
    public User accountOwner {get; set;}  //GPO Group Account Owner
    public GPO_Template__c selectedTemplate {get; set;} //GPO Template assigned to the GPO Group
    public boolean GPOTemplateUsed {get; set;} // Defined if GPO Template is Used
    public gpo_lead__c glead {get;set;}
    public boolean successMsg {get;set;}
    public boolean errorMsg {get;set;}
    public boolean showForm {get;set;}
    public String errorText {get;set;}
    public String parentAccid {get;set;}
    public GPO_Community_Setup__c commSetup {get;set;}
    private String privateKey {get;set;}
    public class custException extends Exception{}
    public String leadPassword {get;set;}
    public String pageID {get;set;}
    public String step1PageID {get;set;}
    public String step2PageID {get;set;}
    public String step3PageID {get;set;}
    
    // Captcha Code (starts) - TODO: Need to remove hardcoded keys
      // private static String baseUrl = 'https://www.google.com/recaptcha/api/verify'; 

    // The keys you get by signing up for reCAPTCHA for your domain
    //private String privateKey = '6Lc38AQTAAAAAJCT62Y_HF9sv3Cadyyvj3UznDbk';
    //private String privateKey = commSetup.captcha_privateKey__c;
    public String publicKey { 
        get { 
          //return '6Lc38AQTAAAAAKynztg9AZWXYB1a5h-YDj7EXKQi'; 
          return commSetup.captcha_publicKey__c;
        }
    } 

    /* Implementation */
    
    // Simple form fields for the example form
    public String myName { get; set; }
    public String myEmail { get; set; }
    
    // Create properties for the non-VF component input fields generated
    // by the reCAPTCHA JavaScript.
    public String challenge { 
        get {
            return ApexPages.currentPage().getParameters().get('recaptcha_challenge_field');
        }
    }
    public String response  { 
        get {
            return ApexPages.currentPage().getParameters().get('recaptcha_response_field');
        }
    }
    
    // Whether the submission has passed reCAPTCHA validation or not
   /* public Boolean verified { get; set; }
    
    
    public PageReference verify() {
        System.debug('reCAPTCHA verification attempt');
        // On first page load, form is empty, so no request to make yet
        if ( challenge == null || response == null ) { 
            System.debug('reCAPTCHA verification attempt with empty form');
            return null; 
        }
                    
        HttpResponse r = makeRequest(baseUrl,
            'privatekey=' + privateKey + 
            '&remoteip='  + remoteHost + 
            '&challenge=' + challenge +
            '&response='  + response
        );
        
        if ( r!= null ) {
            this.verified = (r.getBody().startsWithIgnoreCase('true'));
        }
        
        if(this.verified) {
            // If they pass verification, you might do something interesting here
            // Or simply return a PageReference to the "next" page
            return null;
        }
        else {
            // stay on page to re-try reCAPTCHA
            return null; 
        }
    } */

    public PageReference reset() {
        return null; 
    }   

    /* Private helper methods */
    
    /*private static HttpResponse makeRequest(string url, string body)  {
        HttpResponse response = null;
        HttpRequest req = new HttpRequest();   
        req.setEndpoint(url);
        req.setMethod('POST');
        req.setBody (body);
        try {
            Http http = new Http();
            response = http.send(req);
            System.debug('reCAPTCHA response: ' + response);
            System.debug('reCAPTCHA body: ' + response.getBody());
        } catch(System.Exception e) {
            System.debug('ERROR: ' + e);
        }
        return response;
    }   
        
    private String remoteHost { 
        get { 
            String ret = '127.0.0.1';
            // also could use x-original-remote-host 
            Map<String, String> hdrs = ApexPages.currentPage().getHeaders();
            if (hdrs.get('x-original-remote-addr')!= null)
                ret =  hdrs.get('x-original-remote-addr');
            else if (hdrs.get('X-Salesforce-SIP')!= null)
                ret =  hdrs.get('X-Salesforce-SIP');
            return ret;
        }
    }*/


    // Captcha Code (Ends)
    
    /*
     * Action method for Home page
     * Checks to see if the user making the request is in the Public Commnity Profie.
     * Users in the Public Community Profie are not authenticated and will be shown the Home page content.
     * Users in other profies are authenticated and have a authenticated profile.  These users
     * will be redirected to the Member page.  As they do not need to register or re-login.  
     */
    public PageReference checkUser() {
        String userId = UserInfo.getUserid(); 
        User logedInUser = [Select u.Profile.Name, u.Profile.Id, u.ProfileId From User u where id=:userId]; 
        
        //TODO - Group Purchasing Organizations Profile needs to be moved to a custom setting
        if(logedInUser.Profile.Name==commsetup.user_profile__c)
        {
               return null;
        }    
        
        else 
        {
          //TODO - Home and Member pages should be moved to a custom setting
          return new PageReference(commsetup.member_page__c);
        }
    }
    
    //Returns Template Home Page for selected GPO Group
    public PageReference getTemplateHomePage() {
        PageReference pageRef = new PageReference(selectedTemplate.Home_Page__c);
        return pageRef;   
    }
    
    //Returns Template Member Page for selected GPO Group
    public PageReference getTemplateMemberPage() {
        PageReference pageRef = new PageReference(selectedTemplate.Member_Page__c);
        return pageRef;
    }
    
    //Returns core GPO Community Member Page
    public String getMemberPage() {
        //TODO - Pull from custom setting
        return commsetup.member_page__c;
    }
    
    //Returns core GPO Community Home Page
    public String getHomePage() {
        //TODO - Pull from custom setting
        return commsetup.home_page__c;
    }
    
    //Return default path to use for community images
    public String getImageRootPath(){   
        //TODO - Pull from custom setting
        return commsetup.image_path__c;
    }
    
    public boolean getIsImageDefined(){
        
        Attachment brandImage;
        if( selectedGroup.Community_Image__c == null ) {
            return false;
        } else if (selectedGroup.Community_Image__c == '') {
            return false;
        }
        
        try {
            brandImage = [SELECT id from Attachment where id =: selectedGroup.Community_Image__c ];
        } catch(Exception e) {
            return false;
        }
        
        return true;
    }
    
    // Boolean return if generic template has been selected
    // True - Templated from GPO Group Used
    // False - Default template used
    public boolean getGPOTempateUsed() {
        return GPOTemplateUsed;
    }
    
    // Methods newLead and saveLead added to support Lead creation
    public void newLead() {
       system.debug('Inside Lead Create');
       glead = new GPO_Lead__c();
       successMsg = false;
       errorMsg = false;
       showForm=true;
       
    }
    
  /*  public  void saveLead() {
        list<account> acc;
    try
    {
      GPO_Group__c g = [select account__c from gpo_group__c where account__r.aops_cust_id__c = :ApexPages.currentPage().getParameters().get('id')];
      //parentAccid = ApexPages.currentPage().getParameters().get('id');
      parentAccid = g.account__c;
      String captchaResponse = ApexPages.currentPage().getParameters().get('g-recaptcha-response');
      system.debug('Captcha Respone:' + ApexPages.currentPage().getParameters().get('g-recaptcha-response'));
      
      if (captchaResponse == null || captchaResponse == '') {
        errorText = 'Error: Please Validate Captcha';
        errorMsg = true;
        successMsg = false;
      }
      else if (glead.first_name__c == null || glead.last_name__c == null || glead.Phone__c == null || glead.Email__c == null || glead.Business_Name__c == null 
       || glead.Zip__c == null || glead.WCW_Range__c == null) {
          errorText = 'Error: Please Enter All the Required Fields';
          errorMsg = true;
          successMsg = false;
      }
      else {
         system.debug('Successful');
         if (parentAccid != null) {
           acc = [select id,aops_cust_id__c from account where id = :parentAccid limit 1];
           if (acc.size() > 0)
             glead.Account__c = parentAccid;
           else
             throw new custException ('Error:Invalid Customer Number');
            }
           else {
            throw new custException ('Error:Invalid Customer Number');
           }
           if (!selectedGroup.private__c)
            glead.status__c = 'Approved';
           else
            glead.status__c = 'Pending';
            
            for (User u : [select id,username from user where username = :glead.login_name__c])
               throw new CustException ('Error: User Already Exists for This Account');
            
            
           //Logic to Create Salesforce Contact & User - Starts
          if (!selectedGroup.private__c) {
            
            // Call SOA to create User in AOPS - Starts
             GPOUserReg gU = new GPOUserReg();
             gpoUserReg.GPOUserRefRequest gReq = new gpoUserReg.GPOUserRefRequest();
             gReq.FirstName = glead.first_name__c;
             gReq.LastName  = glead.last_name__c;
             gReq.Email     = glead.email__c;
             gReq.Phone     = glead.Phone__c;
             gReq.LoginName = glead.login_name__c;
             greq.Address1  = glead.address1__c;
             greq.Address2  = glead.address2__c;
             greq.City      = glead.city__c;
             greq.state     = glead.state__c;
             greq.zip       = glead.zip__c;
             greq.AopsCustId = acc[0].aops_cust_id__c;
             //TOTO - Map Password
             greq.Password = leadPassword;
             gpoUserReg.GPOUserRegResponse gRes = gU.executeUserReg(greq);
             
             if (gRes.StatusCode != '00')
              throw new CustException(gRes.statusDescription);
            //Call SOA to Create User in AOPS - Ends
            
            partnerSoapSforceCom.Soap sp = new partnerSoapSforceCom.Soap();
            partnerSoapSforceCom.LoginResult loginResult;
            if (!Test.isRunningTest()){
                 String[] sUserinfo = commsetup.serviceuser__c.split('/');
                 loginResult = sp.login(sUserinfo[0], sUserinfo[1]);
             }
             soapSforceComSchemasClassLeadservic.LeadService  l = new soapSforceComSchemasClassLeadservic.LeadService ();
             soapSforceComSchemasClassLeadservic.LeadInformation linfo = new soapSforceComSchemasClassLeadservic.LeadInformation();
             soapSforceComSchemasClassLeadservic.SessionHeader_element sessionHeader = new soapSforceComSchemasClassLeadservic.SessionHeader_element();
             sessionHeader.sessionId = loginResult.sessionId; 
             l.timeout_x = 120000;
             l.SessionHeader = sessionHeader;
             linfo.EMAIL = glead.Email__c;
             linfo.PHONE = glead.Phone__c;
             linfo.FIRSTNAME = glead.first_name__c;
             linfo.LASTNAME = glead.last_name__C;
             linfo.LOGINNAME = glead.Login_Name__c;
             linfo.PROFILEID = commsetup.User_ProfileId__c;
             linfo.AOPSID = gRes.AOPSID;
             linfo = l.createUser(linfo,glead.Account__c);
             system.debug('Lead Creation Error Message:' + linfo.ErrorMessage);
             if (linfo.ErrorMessage != null && linfo.ErrorMessage != '') {
                system.debug('Custom Exception:' + linfo.ErrorMessage);
                throw new custException('Error: User Already Exists for This Account');
             }
          }
           //Logic to Create Salesforce Contact & User - Ends
           insert glead;
           successMsg = true;
           errorMsg=false;
           showForm=false;
      }
 }
 catch(custException ce) {
  errorText = ce.getMessage();
  errorMsg = true;
  successMsg = false;
 }
 catch(Exception e) {
  system.debug('Unexpected Error:' + e);
  errorText = 'Error: Lead Submission Failed, Please contact Administractor.' + e;
  errorMsg = true;
  successMsg = false;
 }
}*/


@RemoteAction 
public static String  insertLeads(GPO_Lead__c gpoleads, String aopsID,String pwd) {
         /*
        //GPO_Community_Setup__c commuSetup=new GPO_Community_Setup__c();  
        GPO_Community_Setup__c commuSetup = gpo_community_setup__c.getValues('default'); 
        if (aopsID.startsWith('0000')) {
            aopsID=aopsID.substring(4);
        } 
        
    
        GPO_Group__c g = [select account__c, private__c from gpo_group__c where account__r.aops_cust_id__c = :aopsID];
        System.debug('GPO Lead - Insert New Lead');
       
        for (GPO_Lead__c c : gpoleads)    {

        //TO DO
        //for (User u : [select id,username from user where username = :c.login_name__c]
        //throw new CustException ('Error: User Already Exists for This Account');
    
        c.account__c=g.account__c;
        if (!g.private__c)
            c.status__c = 'Approved';
        else
            c.status__c = 'Pending';


       //// BEGIN Call SOA to Create User in AOPS
       //      //Logic to Create Salesforce Contact & User - Starts
       if (!g.private__c) {

          // Call SOA to create User in AOPS - Starts
          GPOUserReg gU = new GPOUserReg();
          gpoUserReg.GPOUserRefRequest gReq = new gpoUserReg.GPOUserRefRequest();
          gReq.FirstName = c.first_name__c;
          gReq.LastName  = c.last_name__c;
          gReq.Email     = c.email__c;
          gReq.Phone     = c.Phone__c;
          gReq.LoginName = c.login_name__c;
          greq.Address1  = c.address1__c;
          greq.Address2  = c.address2__c;
          greq.City      = c.city__c;
          greq.state     = c.state__c;
          greq.zip       = c.zip__c;
          greq.AopsCustId = aopsID;
          //TODO - Map Password
          greq.Password = 'test';
          gpoUserReg.GPOUserRegResponse gRes = gU.executeUserReg(greq);

          if (gRes.StatusCode != '00')
          //throw new CustException(gRes.statusDescription);
          //Call SOA to Create User in AOPS - Ends
          
          system.debug('Before Split');
          partnerSoapSforceCom.Soap sp = new partnerSoapSforceCom.Soap();
          partnerSoapSforceCom.LoginResult loginResult;
          if (!Test.isRunningTest()){
              // TODO -- Get&Set "commuSetup"
              String[] sUserinfo = commuSetup.serviceuser__c.split('/');
              loginResult = sp.login(sUserinfo[0], sUserinfo[1]);

          }
          system.debug('After Split');

          soapSforceComSchemasClassLeadservic.LeadService  l = new soapSforceComSchemasClassLeadservic.LeadService ();
          soapSforceComSchemasClassLeadservic.LeadInformation linfo = new soapSforceComSchemasClassLeadservic.LeadInformation();
          soapSforceComSchemasClassLeadservic.SessionHeader_element sessionHeader = new soapSforceComSchemasClassLeadservic.SessionHeader_element();
          sessionHeader.sessionId = loginResult.sessionId; 
          l.timeout_x = 120000;
          l.SessionHeader = sessionHeader;
          linfo.EMAIL = c.Email__c;
          linfo.PHONE = c.Phone__c;
          linfo.FIRSTNAME = c.first_name__c;
          linfo.LASTNAME = c.last_name__C;
          linfo.LOGINNAME = c.Login_Name__c;

              // TODO -- Get&Set "commuSetup"         
          linfo.PROFILEID = commuSetup.User_ProfileId__c;
          linfo = l.createUser(linfo,c.Account__c);
          system.debug('Lead Creation Error Message:' + linfo.ErrorMessage);

          if (linfo.ErrorMessage != null && linfo.ErrorMessage != '') {
              system.debug('Custom Exception:' + linfo.ErrorMessage);
              //throw new custException('Error: User Already Exists for This Account');
          }
      }
//// END Call SOA to Create User in APOS       
                        
        }
        
        insert gpoleads; */
   
     list<account> acc;
     String errorText;
     boolean errorMsg;
     boolean successMsg;
     boolean showForm;
     GPO_Community_Setup__c commuSetup = gpo_community_setup__c.getValues('default'); 

    try
    {
      GPO_Lead__c glead = gpoleads;
      GPO_Group__c g = [select private__c, account__c from gpo_group__c where account__r.aops_cust_id__c = :aopsID];
      //parentAccid = ApexPages.currentPage().getParameters().get('id');
      String parentAccid = g.account__c;
        
      //TODO recapthca needs to be passed as a parameter
      //String captchaResponse = ApexPages.currentPage().getParameters().get('g-recaptcha-response');
      String captchaResponse = glead.Recaptcha__c;
      
      system.debug('Captcha Respone:' + glead.Recaptcha__c);
          
      if (captchaResponse == null || captchaResponse == '') {
        errorText = 'Error: Please Validate Captcha';
        errorMsg = true;
        successMsg = false;
      }
      else if (glead.first_name__c == null || glead.last_name__c == null || glead.Phone__c == null || glead.Email__c == null || glead.Business_Name__c == null 
       || glead.Zip__c == null || glead.WCW_Range__c == null) {
          errorText = 'Error: Please Enter All the Required Fields';
          errorMsg = true;
          successMsg = false;
      }
      else {
         system.debug('Successful');
         if (parentAccid != null) {
           acc = [select id,aops_cust_id__c from account where id = :parentAccid limit 1];
           if (acc.size() > 0)
             glead.Account__c = parentAccid;
           else
             throw new custException ('Error:Invalid Customer Number');
            }
           else {
            throw new custException ('Error:Invalid Customer Number');
           }
           if (!g.private__c)
            glead.status__c = 'Approved';
           else
            glead.status__c = 'Pending';
            
            for (User u : [select id,username from user where username = :glead.login_name__c])
               throw new CustException ('Error: User Already Exists for This Account');
            
            
           //Logic to Create Salesforce Contact & User - Starts
          if (!g.private__c) {
            
            // Call SOA to create User in AOPS - Starts
             GPOUserReg gU = new GPOUserReg();
             gpoUserReg.GPOUserRefRequest gReq = new gpoUserReg.GPOUserRefRequest();
             gReq.FirstName = glead.first_name__c;
             gReq.LastName  = glead.last_name__c;
             gReq.Email     = glead.email__c;
             gReq.Phone     = glead.Phone__c;
             gReq.LoginName = glead.login_name__c;
             greq.Address1  = glead.address1__c;
             greq.Address2  = glead.address2__c;
             greq.City      = glead.city__c;
             greq.state     = glead.state__c;
             greq.zip       = glead.zip__c;
             greq.AopsCustId = acc[0].aops_cust_id__c;
             //TOTO - Map Password
             //greq.Password = 'test';
             greq.Password = pwd;
             gpoUserReg.GPOUserRegResponse gRes;
              if (!Test.isRunningTest()) {
               gRes = gU.executeUserReg(greq);
             
             if (gRes.StatusCode != '00')
              throw new CustException(gRes.statusDescription);
          }
            //Call SOA to Create User in AOPS - Ends
            
            partnerSoapSforceCom.Soap sp = new partnerSoapSforceCom.Soap();
            partnerSoapSforceCom.LoginResult loginResult;
            if (!Test.isRunningTest()){
                 String[] sUserinfo = commuSetup.serviceuser__c.split('/');
                 loginResult = sp.login(sUserinfo[0], sUserinfo[1]);
             }
             soapSforceComSchemasClassLeadservic.LeadService  l = new soapSforceComSchemasClassLeadservic.LeadService ();
             soapSforceComSchemasClassLeadservic.LeadInformation linfo = new soapSforceComSchemasClassLeadservic.LeadInformation();
             soapSforceComSchemasClassLeadservic.SessionHeader_element sessionHeader = new soapSforceComSchemasClassLeadservic.SessionHeader_element();
             if (!Test.isRunningTest())
              sessionHeader.sessionId = loginResult.sessionId; 
             l.timeout_x = 120000;
             l.SessionHeader = sessionHeader;
             linfo.EMAIL = glead.Email__c;
             linfo.PHONE = glead.Phone__c;
             linfo.FIRSTNAME = glead.first_name__c;
             linfo.LASTNAME = glead.last_name__C;
             linfo.LOGINNAME = glead.Login_Name__c;
             linfo.PROFILEID = commuSetup.User_ProfileId__c;
             if (!Test.isRunningTest())
              linfo.AOPSID = gRes.AOPSId; 
             if (!Test.isRunningTest())
              linfo = l.createUser(linfo,glead.Account__c);
              glead.SU_CommuContact__c = linfo.CONTACTID;
             system.debug('Lead Creation Error Message:' + linfo.ErrorMessage);
             if (linfo.ErrorMessage != null && linfo.ErrorMessage != '') {
                system.debug('Custom Exception:' + linfo.ErrorMessage);
                throw new custException('Error:' + + linfo.ErrorMessage);
             }
          }
           //Logic to Create Salesforce Contact & User - Ends
           
           insert glead;
           successMsg = true;
           errorMsg=false;
           showForm=false;
      }


      
      return 'Success';

 }
 catch(custException ce) {
  errorText = ce.getMessage();
  errorMsg = true;
  successMsg = false;
     throw new CustException (ce.getMessage());
     return 'Error';
     
 }
 catch(Exception e) {
  system.debug('Unexpected Error:' + e);
  errorText = 'Error: Lead Submission Failed, Please contact Administractor.' + e;
  errorMsg = true;
  successMsg = false;
     throw new CustException ('Error: Unexpected Error, Please contact system administrator:' + E);
     
 }


  
    
    
    
}

    public GPOCommunityLandingController() {    
        system.debug('CheckPoint1'); 
        GPOTemplateUsed = true;  // Set GPO template to true, it will be flipped to false if not used
        // added by ivarada - Defaults for lead form
        successMsg = false;
        errorMsg = false;
        showForm=true;
        leadPassword = null;
        //this.verified = false;
        commSetup = gpo_community_setup__c.getValues('default');    
        privateKey = commSetup.captcha_privateKey__c;
        String GPOId;
        pageID = 'CommPrelogin';  
        step1PageID='CommRegistration1__Next1of3';   
        step2PageID='CommRegistration2__Next2of3'; 
        step3PageID='CommRegistration3__Next3of3';
        
        
        // start for Case 638512 
        String PageId1 =  ApexPages.currentPage().getParameters().get('Id');
        if(PageId1 != null)
        {
            if(PageId1.startswith('0'))
            {
            string newstring = PageId1.removeStart('0'); 
            ApexPages.currentPage().getParameters().put('Id',newstring);
            //return pgref;
            }
        }
       //End for Case 638512       
        //If an account ID is not passed use a default GPO Group else load the GPO Group for the account ID passed in the id parameter
        if(ApexPages.currentPage().getParameters().get('id') == null || ApexPages.currentPage().getParameters().get('id') == '') {
              
              initDefaultGPO(); 
        } else {
            Boolean gpoGroupNotFound = false;
            GPOId=ApexPages.currentPage().getParameters().get('id');
            // start for Case 638512 

            /*if (GPOId.startsWith('0000')) {
                GPOId=GPOId.substring(4);
            }   */   
                   //End for Case 638512          
            try {
            /*selectedGroup = [SELECT Id, private__c,GPO_Template__c, Welcome_Title__c, Welcome_Message__c, Community_Image__c, Account__c, LastModifiedDate FROM GPO_Group__c 
                   WHERE Account__c = :ApexPages.currentPage().getParameters().get('id') Limit 1]; */
            /*selectedGroup = [SELECT Id, private__c,GPO_Template__c, Welcome_Title__c, Community_Name__c, Welcome_Message__c, Community_Image__c, Account__c, LastModifiedDate FROM GPO_Group__c 
                   WHERE Account__r.aops_cust_id__c = :ApexPages.currentPage().getParameters().get('id') Limit 1];*/
                

            selectedGroup = [SELECT Id, private__c,GPO_Template__c, Welcome_Title__c, Community_Name__c, Welcome_Message__c, Community_Image__c, Account__c,Account__r.aops_cust_id__c, LastModifiedDate FROM GPO_Group__c 
                   WHERE Account__r.aops_cust_id__c = :GPOId Limit 1];                 
            
            if (selectedGroup.Community_Name__c != null) {
               pageID = 'CommPrelogin_' + selectedGroup.Community_Name__c.replaceAll( '\\s+', '');
               step1pageID = 'CommRegistration1_' +  selectedGroup.Community_Name__c.replaceAll( '\\s+', '') + '_Next1of3';
               step2pageID = 'CommRegistration2_' +  selectedGroup.Community_Name__c.replaceAll( '\\s+', '') + '_Next2of3';
               step2pageID = 'CommRegistration3_' +  selectedGroup.Community_Name__c.replaceAll( '\\s+', '') + '_Next3of3';
             }
            } catch (Exception e ) {
                //The ID passed as parameter was not found in GPO Groups
                gpoGroupNotFound = true;
            }      
             
            //If GPO Group was not found load default GPO, else continue to load the selected GPO group based on the request parameter id 
            if(gpoGroupNotFound)    {
                initDefaultGPO();   
            } else {
                gpoAccount = [Select id, OwnerID from Account where id =: selectedGroup.Account__c];    
                accountOwner = [Select id, ISACTIVE, contactID, Name, Email, Phone, FullPhotoUrl, MobilePhone from User where id =: gpoAccount.ownerId ];       
                selectedTemplate = [Select id, Template_Name__c, Home_Page__c, Member_Page__c from GPO_Template__c where id =: selectedGroup.GPO_Template__c];  
            }
        }        
    }
    
    
    // Load the default GPO.  Either an id was not provided or the ID did not map to an existing GPO_Group  
    private void initDefaultGPO() {
        GPOTemplateUsed = false;
        
        // TODO - default template ID needs to be moved to a custom setting
        String defaultTemplateID = commSetup.defaultTemplate__c;
               
        //Load default GPO Group
        //TODO - template record type id needs to be moved to a custom setting
        selectedGroup = [SELECT id,private__c,Community_Image__c, Welcome_Message__c, Welcome_Title__c, LastModifiedDate, Community_Name__c from GPO_Group__c where GPO_Template__c =: defaultTemplateID AND RecordTypeID = :commSetup.defaultRecordType__c LIMIT 1];
               
        //Load template spefified in GPO Group
       selectedTemplate = [Select id, Template_Name__c, Home_Page__c, Member_Page__c from GPO_Template__c where id =: defaultTemplateID LIMIT 1];
       gpoAccount = new Account();
       accountOwner = new User();
    }
   
    //TODO - This will return the chatter photo for the account owner.  
    // From talking with Krina, we can use this photo but
    // we need to communitate to the Account Execs that they must 
    // update their chatter photo with their profesional photo.  
    // Each rep should have one they can use alredy.  
   
}