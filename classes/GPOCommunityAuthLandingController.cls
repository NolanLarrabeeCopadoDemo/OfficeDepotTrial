/**
 * Controller for GPO Member Landing Page
 * Logic in this Controller should general and not contain any template specific details
 * Template details should be contained in a template specific Extention
 */
 
public without sharing class GPOCommunityAuthLandingController {

    public User communityUser {get; set;}   // logged in user
    public Contact communityContact  {get; set;}   // logged in user contact
    public GPO_Group__c selectedGroup {get; set;}  //GPO group, either Contact Defaul Community, or admin specified in case of site switcher
    public User accountOwner {get; set;}  //Owner of the Account associated with the GPO community
    public Account gpoAccount {get; set;}  // Account associated with the GPO community
    public GPO_Template__c selectedTemplate {get; set;}  // Templated defined by the GPO community
    public GPO_Group__c newEnabledGroup {get; set;}
    public GPO_Group__c defaultTemplateGroup {get; set;}
    public String defaultTemplateID  {get; set;}
    public Map<Id,GPO_Group__c> activeNodesMap {get; set;} //Map of active nodes below the grandparent, three levels down
    public List<Account> childGPOAccounts {get; set;}
    public Attachment brandImage {get; set;}
    public Set<ID> enabledAccountIDs {get; set;}
    public GPO_Group__c ultimateparentgroup {get; set;}
    public List<ChildAccountDetail> childAccountDetails {get; set;}
    public List<ChildAccountDetail> childAccountDetails2 {get; set;}
    public Static ID gpoLeadID {get;set;}
    public Static String gpoApprovalType {get;set;}
    public static String leadSource {get;set;}
    public GPO_Community_Setup__c commSetup {get;set;}
    public String pageID {get;set;}
    public String logOutCM {get;set;}
    public String keepAliveURL {get;set;}
    public static String keepAliveInterval {get;set;}
    public String displayAppForm {get;set;}
    public String displayNoAppMsg {get;set;}
    Public String displayApprovalLink {get;set;}
    
    /*
     * Class used to hold Child Account Details
     * This details are used to display the account hierarchy
     */
    public class ChildAccountDetail
    {
        public String childAccountName {get; set;}
        public String childAccountId  {get; set;}
        public list<ChildAccountDetail> grandChildren {get; set;}
        public boolean enabled {get; set;}
    
        public ChildAccountDetail(Account anAccount, list<ChildAccountDetail> grandchildrendetails, boolean isenabled)
        {
            childAccountName = anAccount.Name;
            childAccountId = anAccount.Id;
            enabled = isenabled;
            grandChildren = grandchildrendetails;        
        }
    }
    
    // Returns GPO_Group values from active Nodes Map
    public List<GPO_Group__c> getActiveNodes() {
        if(activeNodesMap != null) {
          return activeNodesMap.values();
        } else {
          return new List<GPO_Group__c>();
        }
    }
    @RemoteAction
    public Static void keepAliveChk() {
        system.debug('Keep Alive Call');
    }
    
    // Returns of GPO defined template is used or standard template
    public boolean getGPOTempateUsed() {
        return false;  //TODO - Implement this logic
    }
    
    // Returns if user is an admin and if the admin header should be displayes
    public boolean getAdminHeader(){
        //TODO: remove hard code and add to custom setting
        //if(communityUser.ProfileID == '00ec0000000DxKH') {
        if(communityUser.ProfileID == commSetup.Admin_ProfileId__c) {
            return true;
        } else {
            return false;
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
        return commSetup.member_page__C;
    }
    
    //Returns core GPO Community Home Page
    public String getHomePage() {
        //TODO - Pull from custom setting
        return commSetup.home_page__c;
    }
    
     //Return default path to use for community images
    public String getImageRootPath(){   
        //TODO - Pull from custom setting
        return commSetup.image_path__c;
    }
    
    
    public boolean getIsImageDefined(){
        
        Attachment brandImage3;
        if( selectedGroup.Community_Image__c == null ) {
            return false;
        } else if (selectedGroup.Community_Image__c == '') {
            return false;
        }
        
        try {
            brandImage3 = [SELECT id from Attachment where id =: selectedGroup.Community_Image__c ];
        } catch(Exception e) {
            return false;
        }
        
        return true;
    }
     
    // Default constructor
    public GPOCommunityAuthLandingController() {   
         initConstructor();  
        
        if (getMyApprovals().size() == 0) {
            displayAppForm = 'none';
            displayNoAppMsg = 'block';
        }
        else {
            displayAppForm = 'block';
            displayNoAppMsg = 'none';
        }
    }
    
    private void initConstructor(){
        
        // Community user from the logged in user. 
        commSetup = gpo_community_setup__c.getValues('default'); 
        displayApprovalLink = 'none'; 
        communityUser = [Select Id, ContactID, profileID,IsPortalEnabled from User where id =: userinfo.getUserId()];
        pageID = 'CommPostlogin';
        keepAliveURL=commSetup.Keep_Alive_URL__c;
        keepAliveInterval= commSetup.Keep_Alive_Interval__c;
        
        //brandImage = new Attachment();
        //TODO - handle internal user
        
        // Contact assiciated with the Community User
        if (communityUser.IsPortalEnabled)
         communityContact = [Select id, Name, GPOCommunityID__c, GPO_Community__c, Admin_Context__c from Contact where id =: communityUser.ContactID];
        
        //TODO - This currently on works for community users who are assigned a GPO_Community__c.  We need to handle the case
        // were their user is not configured.  This should display some default content and a message that their account is 
        // not properly configured.  And how to correct.  (If communityContact.GPO_Community__c is null )

        //TODO - remove hard coded profile id and moved to custome setting
        // If not admin user, then use the Contact assigned community, else if admin user and this user has an admin context use that community, else use admin default community
        
        //TODO - This should be one query and the if , else if , else should just determine the where clause value, SOQL should be after
        //if(!'00ec0000000DxKHAA0'.equals(String.valueOf(communityUser.ProfileID))) {
        if (communityUser.IsPortalEnabled) {
         if(!commSetup.Admin_ProfileId__c.equals(String.valueOf(communityUser.ProfileID))) {
            selectedGroup = [SELECT Id, private__c,Activated__c, Ultimate_Parent2__c, GPO_Template__c, Welcome_Title__c, Welcome_Message__c, LastModifiedDate,  Community_Image__c, Account__c, Community_Name__c FROM GPO_Group__c 
                   WHERE Account__c = :communityContact.GPO_Community__c];
          }    else if ( ''.equals(String.valueOf(communityContact.Admin_Context__c)) || null == communityContact.Admin_Context__c ){
             selectedGroup = [SELECT Id, private__c,Activated__c, Ultimate_Parent2__c, GPO_Template__c, Welcome_Title__c, Welcome_Message__c, LastModifiedDate, Community_Image__c, Account__c, Community_Name__c FROM GPO_Group__c 
                   WHERE Account__c = :communityContact.GPO_Community__c];
          } else {
            selectedGroup = [SELECT Id,  private__c,Activated__c, Ultimate_Parent2__c, GPO_Template__c, Welcome_Title__c, Welcome_Message__c, LastModifiedDate, Community_Image__c, Account__c, Community_Name__c FROM GPO_Group__c 
                   WHERE Account__c = :communityContact.Admin_Context__c];
          }
          system.debug('Before admin context update:' + communityContact.Admin_Context__c);
        }
        else {
            selectedGroup = [SELECT Id,  private__c,Activated__c, Ultimate_Parent2__c, GPO_Template__c, Welcome_Title__c, Welcome_Message__c, LastModifiedDate, Community_Image__c, Account__c, Community_Name__c FROM GPO_Group__c 
                   WHERE id= :ApexPages.currentPage().getParameters().get('gpoGroupid')];
        }
        
        if (selectedGroup != null) {
            if (selectedGroup.Private__c)
                 displayApprovalLink = 'block';
            if (selectedGroup.Community_Name__c != null) {
              pageID = 'CommPostlogin_' + selectedGroup.Community_Name__c.replaceAll( '\\s+', '');  
              LogOutCM = 'Communities-_-CommPostlogin_'+selectedGroup.Community_Name__c.replaceAll( '\\s+', '')+'-_-Logout';
            }
        }
        
      /*  if (communityContact.Admin_Context__c != null) {
          system.debug('Inside admin context update');
          communityContact.Admin_Context__c = null;
          update communityContact;
        }
        */
                
        //TODO - add logic to check that the community that a user is trying to load. They are authorized to do so.  It is not clear what the 
        // business rules for this would be.  But we should add a security check here as well.  
        
        // Account associated with GPO Community
        gpoAccount = [Select id, Name, OwnerID, (select name,id from ChildAccounts limit 2) from Account where id =: selectedGroup.Account__c];
        
        // GPO associated Account Owner
        accountOwner = [Select id, ISACTIVE, Name, Email, Phone, FullPhotoUrl, MobilePhone from User where id =: gpoAccount.ownerId ];   
        
        //Template Defined by GPO Group
        selectedTemplate = [Select id, Template_Name__c, Home_Page__c, Member_Page__c from GPO_Template__c where id =: selectedGroup.GPO_Template__c];   
        
        //TODO - only call initAdminDetails if user is admin user
        system.debug('XXXXXXXXX');  
        if(getAdminHeader()){
            system.debug('XXXXXXXXX');  
            initAdminDetails(); 
        }
        
    }
    
    public void initAdminDetails() {
        system.debug('XXXXXXXXX');    

        enabledAccountIDs = new Set<ID>();
        childAccountDetails = new List<ChildAccountDetail>();
        childAccountDetails2 = new List<ChildAccountDetail>();

        // Pulls brand image to be used for admin updated
       try {
            brandImage = [SELECT id, Name, Body from Attachment where id =: selectedGroup.Community_Image__c ];
        } catch(Exception e) {}
        //TODO Tag with parent and grand parent instead of ultimate parent 2.  Then just filter for an community that 
        // matches this
        
        //TODO this logic needs to change to.  We simple need to look down to levels and pull all active communities
         // Identifies the grandparent
        try{
        ultimateparentgroup = [SELECT id, Current__c, Community_Name__c from GPO_Group__c where  Account__c =: communityContact.GPO_Community__c];
        //ultimateparentgroup = selectedGroup;
        } catch(Exception e) {}
        
        
         System.debug('XXXXXXXXX - '+selectedGroup.Account__c );    
        // List of all enabled GPO Communities under the ultimateparentgroup (grandparent)
        try{
        activeNodesMap =  new Map<ID, GPO_Group__c>([Select id, Current__c, Community_Name__c, Account__c from GPO_Group__c where (Parent__c =: communityContact.GPOCommunityID__c or GrandParent__c =: communityContact.GPOCommunityID__c  or GreatGrandParent__c =: communityContact.GPOCommunityID__c) and activated__c = true]);
        } catch(Exception e) {}
            //String accountid = String.valueOf(selectedGroup.Account__c);
       // activeNodesMap =  new Map<ID, GPO_Group__c>([Select id, Name, Community_Name__c, Account__c from GPO_Group__c where GrandParent__c =: selectedGroup.AccountID__c]);
        System.debug('XXXXXXXXX - '+selectedGroup.Account__c );       
         //if(activeNodesMap.size() > 0) {
        // Collection of all enabled GPO communities
        // 
        if(activeNodesMap != null && activeNodesMap.size() > 0) {
            For(GPO_Group__c thenode: activeNodesMap.values() ){
                enabledAccountIDs.add(thenode.Account__c);
            }   
           
            // remove the selected group from the active nodes map (which will remove from the site switcher drop down)
            //activeNodesMap.remove(selectedGroup.ID);
            // remove the grandparent from the active nodes map (which will remove from the site switcher drop down)
            //activeNodesMap.remove(ultimateparentgroup.ID);
            
            // Get grandchildern for each parent
            // TODO - this will not scale and needs to be updated to relect the UI selected to show the account hierarchy
            childGPOAccounts = [Select id, Name, (select name,id from ChildAccounts limit 2) from Account where id IN :gpoAccount.ChildAccounts];
            
            // Construct the Account Details Object
            For(Account a: childGPOAccounts){
                List<ChildAccountDetail> gcAccountDetails = new List<ChildAccountDetail>();
                For(Account gc: a.ChildAccounts){
                    ChildAccountDetail gcAccountDetail = new ChildAccountDetail(gc, new List<ChildAccountDetail>(), enabledAccountIDs.contains(gc.id));
                    gcAccountDetails.add(gcAccountDetail);
                }
                childAccountDetails.add(new ChildAccountDetail(a, gcAccountDetails, enabledAccountIDs.contains(a.id)));     
            }
                
        }
         
    }
  
    // Create community with base information, no details, details are provided in the site template extension
    public PageReference enablecommunity(){
        
       //TODO - add security check to validate that the right GPO admin is requesting the enable community function.  
       //otherwise an error should be returned.  Also this should check that the user is a GPO admin based on profile.  
        
       // TODO this should be a look up from a custom setting, this is the default template to use for communities      
       //String defaultTemplateID = 'a2nc0000000Ib2pAAC';
         String defaultTemplateID = commSetup.defaultTemplate__c;
       if ( ApexPages.currentPage().getParameters().get('id') == null || ApexPages.currentPage().getParameters().get('up') == null) {
           // TODO - Display meanifull error message to user, this should redirect to one of the site standard error pages instead of returning null
          return null;
          
       } else {
        
          defaultTemplateGroup = [SELECT id,Community_Image__c, Welcome_Message__c, Welcome_Title__c from GPO_Group__c where GPO_Template__c =: defaultTemplateID AND RecordTypeID = :commSetup.defaultRecordType__c];
          Account gpoAccount = [Select id, name from Account where id =: ApexPages.currentPage().getParameters().get('id')];
       
          Attachment templateImage = [Select id, name, body from Attachment where id =: defaultTemplateGroup.Community_Image__c];
         
          Attachment newImage = new Attachment();
          newImage.name = templateImage.Name;
          newImage.body = templateImage.Body;
          
          
          newEnabledGroup = new GPO_Group__c();
          newEnabledGroup.Account__c = ApexPages.currentPage().getParameters().get('id');
          newEnabledGroup.Community_Image__c= 'NA'; 
          newEnabledGroup.GPO_Template__c = defaultTemplateID;
          newEnabledGroup.Welcome_Message__c = defaultTemplateGroup.Welcome_Message__c; 
          newEnabledGroup.Community_Name__c = String.valueOf(gpoAccount.Name); 
          newEnabledGroup.Welcome_Title__c = defaultTemplateGroup.Welcome_Title__c; 
          //newEnabledGroup.Ultimate_Parent2__c = ApexPages.currentPage().getParameters().get('up'); 
          //newEnabledGroup.Name = String.valueOf(gpoAccount.Name)+String.valueOf(gpoAccount.ID);
          
          //TODO - pull record type ID from custom setting, this is the record ID for GPO enabled groups
          //newEnabledGroup.RecordTypeID = '012c00000000iugAAA';
          newEnabledGroup.RecordTypeID = commSetup.enabled_group_recordtypeid__c;
          
          insert newEnabledGroup;

          newImage.parentID = newEnabledGroup.ID;
          insert newImage;
          
          newEnabledGroup.Community_Image__c= newImage.ID; 
          upsert newEnabledGroup;

          return new PageReference(getMemberPage());
          
          
       }
    }
    
    public PageReference activateCommunity() {
        //TODO - Validate that the user is an amdin, and that they have permission to activate this community
        
        selectedGroup.Activated__c = true;
        update selectedGroup;
        
        List<Contact> accountContacts = [Select id, GPO_Community__c FROM Contact WHERE AccountID =: selectedGroup.Account__c];
        For (Contact aContact: accountContacts){
            aContact.GPO_Community__c = selectedGroup.Account__c;
        }
        update accountContacts;
        
        //TODO update link on all contact in account
        
        return new PageReference(getMemberPage());
    }
    
    
    
     public PageReference switchSite(){
        
       if ( ApexPages.currentPage().getParameters().get('id') == null)  {
          // TODO - Display meanifull error message to user, this should redirect to one of the site standard error pages instead of returning null
          return null;

       } else {
          // TODO - Validate that the user is an admin, and that they have permission to administer this community
          communityUser = [Select Id, ContactID, profileID from User where id =: userinfo.getUserId()];
          communityContact = [Select id, Name, GPOCommunityID__c, GPO_Community__c, Admin_Context__c from Contact where id =: communityUser.ContactID];
          communityContact.Admin_Context__c = ApexPages.currentPage().getParameters().get('id');
          update communityContact;
          return new PageReference(getMemberPage());
       }
     
     }
     
     
       //Each should have it's own save and be but at the right controller or extension which ownes it
    public  PageReference save() {
        //System.debug('xxxxxxxxxxxxxxxxxxxxxx');
        //if (brandImage != null){
             //System.debug('xxxxxxxxxxxxxxxxxxxxxx inside');
            //brandImage.parentID = selectedGroup.id;
            upsert brandImage;
        //}
       
       update selectedGroup;
       
       return new PageReference(getMemberPage());
    }
    
    public ApexPages.StandardSetController setCon {
        get {
            if(setCon == null) {
                setCon = new ApexPages.StandardSetController(Database.getQueryLocator(               
                    [Select id, Name from Account where id IN : gpoAccount.ChildAccounts]));         
            }
            return setCon;
        }
        set;
    }

    // Initialize setCon and return a list of records
    public List<ChildAccountDetail> getPagedAccounts() {
          List<Account> currentAccountSet = setCon.getRecords();
           // Construct the Account Details Object
            For(Account a: currentAccountSet){
                List<ChildAccountDetail> gcAccountDetails = new List<ChildAccountDetail>();
                For(Account gc: a.ChildAccounts){
                    
                    ChildAccountDetail gcAccountDetail = new ChildAccountDetail(gc, new List<ChildAccountDetail>(), enabledAccountIDs.contains(gc.id));
                    gcAccountDetails.add(gcAccountDetail);
                }   
                childAccountDetails2.add(new ChildAccountDetail(a, gcAccountDetails, enabledAccountIDs.contains(a.id)));    
            }           
            return childAccountDetails2;
    }
    
     // displays the selected items
     public PageReference process() {
         /*for (CategoryWrapper cw : categories) {
             if (cw.checked)
                 ApexPages.addMessage(new ApexPages.message(ApexPages.severity.INFO,cw.cat.name));
         }*/
         return null;
     }

    // indicates whether there are more records after the current page set.
    public Boolean hasNext {
        get {
            return setCon.getHasNext();
        }
        set;
    }

    // indicates whether there are more records before the current page set.
    public Boolean hasPrevious {
        get {
            return setCon.getHasPrevious();
        }
        set;
    }

    // returns the page number of the current page set
    public Integer pageNumber {
        get {
            return setCon.getPageNumber();
        }
        set;
    }

    // returns the first page of records
     public void first() {
         setCon.first();
     }

     // returns the last page of records
     public void last() {
         setCon.last();
     }

     // returns the previous page of records
     public void previous() {
         setCon.previous();
     }

     // returns the next page of records
     public void next() {
         setCon.next();
     }

     // returns the PageReference of the original page, if known, or the home page.
     public void cancel() {
         setCon.cancel();
     }
    
     @RemoteAction
    public static void ApproveLe(String[] sIds,String appType) {
        system.debug('SelectedIds:' + sIds);
        
        if (appType == 'R') {
          for(integer i=0;i<sIds.size();i++) {
             if (sIds[i] != 'on') {
               gpoLeadID = sIds[i];
               gpoApprovalType = appType;
               approvalResponse();
             }
          }
        }
        
        list<Gpo_lead__c> glead = [select id,status__c from gpo_lead__c where id = :sIds];
            for (gpo_lead__c g:glead) {
              if (appType == 'A')
                g.status__c = 'Approved';
              else if (appType == 'R')
                g.status__c = 'Rejected';
            }
            update glead;
        
        
        
        //return string.valueof(ApexPages.currentPage().getURL());
    }
     
     public void ActionVariables() {
       gpoLeadID = ApexPages.currentPage().getParameters().get('gpoLeadId');
       gpoApprovalType = ApexPages.currentPage().getParameters().get('appType');
     }
    
    public static void approvalResponse() {
       system.debug('In Loop approval response');
       GPO_Community_Setup__c commSetupL;
       for (gpo_lead__c g:[select id,status__c,address1__c,address2__c,city__c,state__c,URL__c,Business_Name__c,DUNS__C,Email__c,first_name__c,Last_Name__c,Notes__c,Phone__c,WCW_Range__c,zip__c from gpo_lead__c where id=:gpoLeadID limit 1]) {
          if (gpoApprovalType == 'R') {
             partnerSoapSforceCom.Soap sp = new partnerSoapSforceCom.Soap();
             partnerSoapSforceCom.LoginResult loginResult;
             
             if (!Test.isRunningTest()){
                 
                 commSetupL = gpo_community_setup__c.getValues('default'); 
        
                 String serviceUserL = commsetupL.serviceuser__c;
                 //system.debug('Before Service User:' + serviceUserL);
                 
                 String[] sUserinfo = serviceUserL.split('/');
                 system.debug('After Service User');
                 loginResult = sp.login(sUserinfo[0], sUserinfo[1]);
             }

             soapSforceComSchemasClassLeadservic.LeadService  l = new soapSforceComSchemasClassLeadservic.LeadService ();
             soapSforceComSchemasClassLeadservic.LeadInformation linfo = new soapSforceComSchemasClassLeadservic.LeadInformation();
             soapSforceComSchemasClassLeadservic.SessionHeader_element sessionHeader = new soapSforceComSchemasClassLeadservic.SessionHeader_element();
             sessionHeader.sessionId = loginResult.sessionId;
               decimal WCW;
               if (g.WCW_Range__c != null) {
                if (g.WCW_Range__c.contains('-'))
                  WCW = decimal.valueOf(g.WCW_Range__c.substring(0,g.WCW_Range__c.indexOf('-')));
                else if (g.WCW_Range__c.contains('+'))
                  WCW = decimal.valueOf(g.WCW_Range__c.substring(0,g.WCW_Range__c.indexOf('+')));
               }
             
             l.timeout_x = 120000;
             l.SessionHeader = sessionHeader;
             linfo.COMPANY = g.Business_Name__c;
             linfo.EMAIL = g.Email__c;
             linfo.PHONE = g.Phone__c;
             linfo.FIRSTNAME = g.first_name__c;
             linfo.LASTNAME = g.last_name__C;
             linfo.DESCRIPTION = g.Notes__c;
             linfo.ADDRESS1 = g.Address1__c;
             linfo.ADDRESS2 = g.Address2__c;
             linfo.CITY = g.City__c;
             linfo.STATE = g.state__c;
             linfo.DUNS = g.DUNS__c;
             linfo.WCW = WCW;
             linfo.ZIP = g.zip__c;
             //linfo.LEADSOURCE = 'BSD NET';
             linfo.LEADSOURCE = commSetupL.lead_source__c;
             linfo.ErrorMessage = g.URL__c;
             
             linfo = l.insertLead(linfo);
             system.debug('Lead Creation Error Message:' + linfo.ErrorMessage);
         }

       }
     }
    
    
     public list<gpo_lead__c> getMyApprovals() {
      
      list<GPO_Group__c> gGroup = new list<GPO_Group__c>();
      //list<GPO_Lead__c> gLead = new list<GPO_Lead__c>();
      
      IF (selectedGroup != null) {
       gGroup = [select Account__c from GPO_Group__c where ID = :selectedGroup.id];
      }
      if (gGroup.size() > 0)
       return [SELECT Id, Name, CreatedDate, first_name__c, Last_Name__c, Phone__c, Email__c, Business_Name__c, Zip__c, WCW_Range__c, Notes__c, Status__c, Account__c from gpo_lead__C where account__c = :gGroup[0].account__c and status__C = 'Pending' order by first_name__c];
      else
       return null;
     }

}