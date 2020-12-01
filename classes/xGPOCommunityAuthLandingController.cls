/**
 * Controller for GPO Member Landing Page
 * Logic in this Controller should general and not contain any template specific details
 * Template details should be contained in a template specific Extention
 */
 
public without sharing class xGPOCommunityAuthLandingController {

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
    
    public boolean showGeneric {get;set;}
   // public String aopsFlag {get;set;}
    public List<GPO_Link__c> pageLinks {get;set;}
  //  public PageReference pageReturn {get;set;}
    public String GPOid {get;set;}
    public boolean showForm {get;set;}
    public GPO_Group__c defaultGroup {get;set;}
    public List<GPO_Link__c> defaultInvoiceFieldsList {get;set;}
    public List<GPO_Link__c> invoiceFieldsList {get;set;}
    public Map<String,String> defaultInvoiceFieldsMap {get;set;}
    public List<GPO_Link__c> hiddenFields {get;set;}
    public boolean hideExtension {get;set;}
    public boolean hideWebsite {get;set;}
    public boolean hideNotes {get;set;}
    public GPO_Group_Detail__c[] messages {get;set;}
    public GPO_Group_Detail__c[] customMessage {get;set;}
    public String selected {get;set;}
    public GPO_Group_Detail__c selectedMessage {get;set;}
    public Id messageId ;
    //Communities v2.2
    public Boolean spcRegistrationLink {get;set;}
    public GPO_Group__c parentGroup {get;set;}
    public GPO_Group__c usingGroup {get;set;}
    public Boolean useParentImage {get;set;}
    public String imageId {get;set;}
    public Boolean hideSPCdownloadLink {get;set;}
    public String Account_SPC_Allowed_Flag {get;set;}
    
    //NAIT-21075--START-------
    public boolean DefaulthideGrp_PO_Num_Flag {get;set;}
    public boolean DefaulthideGrp_CCenter_Flag {get;set;}
    public boolean DefaulthideGrp_Release_Flag {get;set;}
    public boolean DefaulthideGrp_Desktop_Flag {get;set;}
    
    public boolean hideGrp_PO_Num_Flag {get;set;}
    public boolean hideGrp_CCenter_Flag {get;set;}
    public boolean hideGrp_Release_Flag {get;set;}
    public boolean hideGrp_Desktop_Flag {get;set;}
    
    public boolean Grp_PO_Num_Setting {get;set;}
    public boolean Grp_CCenter_Setting {get;set;}
    public boolean Grp_Release_Setting {get;set;}
    public boolean Grp_Desktop_Setting {get;set;}
    
    public list<GPO_Soft_Headers__c> Grp_PO_Num {get;set;}
    public list<GPO_Soft_Headers__c> Grp_CCenter {get;set;}
    public list<GPO_Soft_Headers__c> Grp_Release {get;set;}
    public list<GPO_Soft_Headers__c> Grp_Desktop {get;set;}
    
    public boolean Grp_PO_Num_Flag {get;set;}
    public boolean Grp_CCenter_Flag {get;set;}
    public boolean Grp_Release_Flag {get;set;}
    public boolean Grp_Desktop_Flag {get;set;}
    
    public list<SelectOption> Grp_PO_Num_str_list {get;set;}
    public list<SelectOption> Grp_CCenter_str_list {get;set;}
    public list<SelectOption> Grp_Release_str_list {get;set;}
    public list<SelectOption> Grp_Desktop_str_list {get;set;}
    
    public List<GPO_Link__c> defaultInvoiceUserRegFieldsList {get;set;}
    public Map<String,String> InvoiceUserRegFieldsMap {get;set;}
    public List<GPO_Link__c> InvoiceUserRegFieldsList {get;set;}
    
    public boolean DefaulthideCreditCard_Flag {get;set;}//NAIT-21075
    public boolean hideCreditCard_Flag  {get;set;}//NAIT-21075
    
    //NAIT-21075--END-------
    public List<GPO_Link__c> defaultUserRegistrationFieldsList {get;set;}
    public Map<String,String> UserRegistrationFieldsMap {get;set;}
    public List<GPO_Link__c> userRegistrationFieldsList {get;set;}
    //--NAIT-21026-------------------sTART--------->
    
    public boolean MultihideGrp_PO_Num_Flag {get;set;}
    public boolean MultihideGrp_CCenter_Flag {get;set;}
    public boolean MultihideGrp_Release_Flag {get;set;}
    public boolean MultihideGrp_Desktop_Flag {get;set;}
    public boolean hideMultipleShipTo_Flag {get;set;}
    public boolean hideSSO_Id_Flag {get;set;}//NAIT-21040
    public boolean hideCustomCatalogCode_Flag {get;set;}//NAIT-21040
    
    public boolean DefaultMultihideGrp_PO_Num_Flag {get;set;}
    public boolean DefaultMultihideGrp_CCenter_Flag {get;set;}
    public boolean DefaultMultihideGrp_Release_Flag {get;set;}
    public boolean DefaultMultihideGrp_Desktop_Flag {get;set;}
    
    public boolean DefaultHideMultipleShipTo_Flag {get;set;}//NAIT-21034
    public boolean DefaultHideSSO_Id_Flag {get;set;}//NAIT-21040
    public boolean DefaultHideCustomCatalogCode_Flag {get;set;}//NAIT-21040
    public decimal grp_CustomCatalogCode  {get;set;}//NAIT-21040
    public boolean grp_CustomCatalogCode_Val_Flag {get;set;}//NAIT-21040
    public boolean grp_Allow_ShipTo_Address_Selection_Flag  {get;set;}//NAIT-21032
    //--NAIT-21026-------------------End------------->
    
    //--NAIT-11785----------
    public Boolean User_Register_For_SPC {get;set;}
    public Boolean userMaintenanceAllowed {get;set;}
    
    /*
    // Calls AOPS to check if this Community is Post Script or NonPost Script
    public PageReference checkUser2() {
        PostScriptIndicatorService psis = new PostScriptIndicatorService();
        aopsFlag = psis.getScriptIndicator(selectedGroup.Account__r.cust_id__c);
        System.debug('AOPSFLAG = ' + aopsFlag);
       
        if (aopsFlag == 'P'){
            pageReturn = new PageReference(commSetup.shop_link__c + '?cm_sp=Communities-_-' + pageID + '-_-ShopNow');
        } else if (aopsFlag == 'N') {
            pageReturn = new PageReference(selectedTemplate.Member_Page__c);
        } else {
            pageReturn = new PageReference('apex/pagenotfound');
           
        }
        System.debug('PAGERETURN = ' + pageReturn);
        
        return pageReturn;
        pageReturn = new PageReference(selectedTemplate.Member_Page__c);
        return pageReturn;
        
    } */
    
    // Communities 2.1 
    // Create a new Case with Invoice Form Submit
    @RemoteAction
    public static String createCase(Case caseObject, String groupId) {
       // String errorText;
       // boolean errorMsg;
       // boolean successMsg;
        System.Debug('groupid ' + groupId);
        system.debug('caseObject:' + caseObject);
        
        String contactName; // for email template
        GPO_Group__c gpogroup = [SELECT aops_cust_id__c, Account__C, Account__r.Name,Account__r.Account_Owner__c,Community_Name__c FROM GPO_Group__c WHERE aops_cust_id__c  = :groupId limit 1];
        Account acct = [SELECT id,OwnerId FROM Account WHERE id =: gpogroup.Account__C];
        User accountOwner = [Select id, Name, Email, Phone, MobilePhone from User where id =: acct.OwnerId LIMIT 1];
        Id queueID = [select Id from Group where Type = 'Queue' and Name = 'Communities Queue' limit 1][0].Id;
    
        caseObject.Subject = 'Communities Portal Account Creation - ' + gpogroup.aops_cust_id__c;
        caseObject.WRF_Request_Type__c = 'Portal Request';
        caseObject.AccountId = gpogroup.Account__c;
        caseObject.recordTypeid = Schema.SobjectType.Case.getRecordTypeInfosByName().get('AM Communities').getRecordTypeId();
        caseObject.ownerId = queueID;
        caseObject.WRF_Current_GPO_Tier__c = gpogroup.Community_Name__c; //used in email template
        contactName = (String)gpogroup.Account__r.Account_Owner__c; //used in email template
        caseObject.AM_Contact_First_Name__c = contactName.stripHtmlTags(); //used in email template
        caseObject.AM_Contact_Phone__c = accountOwner.MobilePhone; //used in email template
        try {
            if (!Test.isRunningTest()) {
                insert caseObject;
            }
        } catch(exception e){
            return e.getMessage();
            system.debug(e);
        }
        return 'Error';
   //   }
    }
    
    @RemoteAction
    public static String insertMaint(GPO_Lead__c gpoleads, String aopsID) {
        Case caseObject = new Case();
        Id queueID = [select Id from Group where Type = 'Queue' and Name = 'Communities Queue' limit 1][0].Id;
        GPO_Group__c gpogroup = [SELECT id, aops_cust_id__c, Account__C,Public_Page_View__c, Account__r.Name,Account__r.Account_Owner__c,Community_Name__c FROM GPO_Group__c WHERE aops_cust_id__c  = :aopsID limit 1];
        Account acct = [SELECT id,OwnerId FROM Account WHERE id =: gpogroup.Account__C];
        User accountOwner = [Select id, Name, Email, Phone, MobilePhone from User where id =: acct.OwnerId LIMIT 1];
        
        GPO_Lead__c userMaint = gpoleads;
        userMaint.Name = gpogroup.Community_Name__c;
        userMaint.Notes__c = gpoleads.Notes__c;
        userMaint.GPO_Group__c = gpogroup.id;
        userMaint.Account__c = acct.id;
        userMaint.User_Maintenance_Form__c = true;
        userMaint.Community_Home_Page__c = gpogroup.Public_Page_View__c;
        
        caseObject.ownerId = queueID;
        caseObject.recordTypeid = Schema.SobjectType.Case.getRecordTypeInfosByName().get('AM Communities').getRecordTypeId();
        caseObject.Subject = 'Communities User Maintenance Request';
        //caseObject.WRF_Request_Type__c = 'Portal Request';
        caseObject.AccountId = gpogroup.Account__c;
        caseObject.Description = gpoleads.Login_Name__c;
        caseObject.AM_Contact_First_Name__c = gpoleads.first_name__c;
        caseObject.AM_Contact_Last_Name__c = gpoleads.last_name__c;
        caseObject.AM_Contact_Email__c = gpoleads.email__c;
        caseObject.AM_Contact_Phone__c = gpoleads.Phone__c;
        caseObject.AM_Ship_To_Address_1__c = gpoleads.address1__c;
        caseObject.AM_Ship_To_Address_2__c = gpoleads.address2__c;
        caseObject.AM_Ship_To_City__c = gpoleads.city__c;
        caseObject.AM_Ship_To_State__c = gpoleads.state__c;
        caseObject.AM_Ship_To_Zip__c = gpoleads.zip__c;
        caseObject.WRF_Website_URL__c = gpoleads.URL__c;
        caseObject.AM_New_Business_Name__c = gpoleads.Business_Name__c;
        caseObject.IT_QA_Notes__c = gpoleads.Notes__c;
        caseObject.PO_Number__c = gpoleads.PO_Number__c;
        caseObject.CostCenter__c = gpoleads.Cost_Center__c;
        caseObject.Release__c = gpoleads.Release__c;
        caseObject.Desktop__c = gpoleads.Desktop__c;
        caseObject.Multiple_PO_Numbers__c = gpoleads.Multiple_PO_Numbers__c;
        caseObject.Multiple_Cost_Centers__c = gpoleads.Multiple_Cost_Centers__c;
        caseObject.Multiple_Releases__c = gpoleads.Multiple_Releases__c;
        caseObject.Multiple_Desktops__c = gpoleads.Multiple_Desktops__c;
        caseObject.Multiple_Ship_To__c = gpoleads.MultipleShipTo__c;
      //  caseObject gpoleads.SSO_Id__c;
        
        try {
            if (!Test.isRunningTest()) {
                system.debug(gpoleads);
                insert userMaint;
                caseObject.GPO_User_Registration__c = userMaint.id;
                insert caseObject;
            }
        } catch(exception e) {
            return e.getMessage();
        }
        return 'Successfully inserted User Maintenance record';
    }
    
    // Custom Message will be added to picklist through here 
    public List<SelectOption> getItems() {
        List<SelectOption> options = new List<SelectOption>();
        for(GPO_Group_Detail__c theMessage : messages) {
            if(theMessage.Greeting_Message__c != null) {
                options.add(new SelectOption(theMessage.id,theMessage.Name));
            }
        }
        for(GPO_Group_Detail__c newMessage: customMessage) {
            if (newMessage.Greeting_Message__c != null) {
                options.add(new SelectOption(newMessage.id,'Custom Greeting Message'));
            }
        }
        return options;
    }
    
    public String getmessageId() {
        messageId = selectedMessage.id;
        return messageId;
    }
    public void setmessageId(id messageId) {
        if (messageId != null) {
             this.messageId = messageId;
             selectedGroup.selected_message__c = messageId;
             selectedMessage = [SELECT Greeting_Message__c FROM GPO_Group_Detail__c WHERE id =: selectedGroup.selected_message__c];
            // selected = selectedMessage.Greeting_Message__c.replace('COMMUNITYNAME',selectedGroup.Community_Name__c );
             selected = selectedMessage.Greeting_Message__c;
        }
    }
    
    // The keys you get by signing up for reCAPTCHA for your domain
    public String publicKey { 
        get { 
          return commSetup.captcha_publicKey__c;
        }
    } 
    
    
    
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
    
    // Returns if user is an admin and if the admin header should be displayes
    public boolean getAdminHeader(){
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
        return commSetup.member_page__C;
    }
    
    //Returns core GPO Community Home Page
    public String getHomePage() {
        return commSetup.home_page__c;
    }
    
     //Return default path to use for community images
    public String getImageRootPath(){   
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
    
    public Integer getCurrentYear(){
        return System.Today().year();
    }
     
    // Default constructor
    public xGPOCommunityAuthLandingController() {   
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
        commSetup = gpo_community_setup__c.getValues('com2Settings'); 
        displayApprovalLink = 'none'; 
        communityUser = [Select Id, ContactID, profileID,IsPortalEnabled,Name,FederationIdentifier from User where id =: userinfo.getUserId()];
        showGeneric = (ApexPages.currentPage().getParameters().get('id') == null || ApexPages.currentPage().getParameters().get('id') == '');
        pageID = 'CommPostlogin';
        keepAliveURL=commSetup.Keep_Alive_URL__c;
        keepAliveInterval= commSetup.Keep_Alive_Interval__c;
        showForm = true; //Is this used on this page? Doesn't seem like it...
        usingGroup = new GPO_Group__c();
        spcRegistrationLink = true;
        useParentImage = false;
         //Communities 2.1 - Default Fields
        defaultGroup = [SELECT Id, Name FROM GPO_Group__c where Community_Name__c = 'Default Group'];
        // Default Invoice Form
        defaultInvoiceFieldsList = [SELECT Id, Label__c, Invoice_Form_Fields__c, Active__c FROM GPO_Link__c WHERE GPO_Group__c =: defaultGroup.Id AND Type__c = 'Invoice Request Form Field'];
        defaultInvoiceFieldsMap = new Map<string,string>();
        for(GPO_Link__c field : defaultInvoiceFieldsList){
            if (field.Invoice_Form_Fields__c != null)
                defaultInvoiceFieldsMap.put(field.Invoice_Form_Fields__c, field.Label__c);
        }
        // Default Registration Form
        UserRegistrationFieldsMap = new Map<string,string>();
        defaultUserRegistrationFieldsList = [SELECT Id, Label__c, User_Registration_Fields__c FROM GPO_Link__c WHERE GPO_Group__c =: defaultGroup.Id AND Type__c = 'User Registration Field'];
        for(GPO_Link__c field : defaultUserRegistrationFieldsList){
            if (field.User_Registration_Fields__c != null)
                UserRegistrationFieldsMap.put(field.User_Registration_Fields__c, field.Label__c);
        }
        
        //--NAIT-21075----start
        Grp_PO_Num_Setting = true;
        Grp_CCenter_Setting = true;
        Grp_Release_Setting = true;
        Grp_Desktop_Setting = true;
    
        hideGrp_PO_Num_Flag  = false;
        hideGrp_CCenter_Flag  = false;
        hideGrp_Release_Flag  = false;
        hideGrp_Desktop_Flag  = false;
        MultihideGrp_PO_Num_Flag = false;
        MultihideGrp_CCenter_Flag = false;
        MultihideGrp_Release_Flag = false;
        MultihideGrp_Desktop_Flag = false;
        hideMultipleShipTo_Flag = false;//NAIT-21034
        hideSSO_Id_Flag = false;//NAIT-21040
        hideCustomCatalogCode_Flag = false;//NAIT-21040
        
        DefaulthideGrp_PO_Num_Flag  = true;
        DefaulthideGrp_CCenter_Flag  = true;
        DefaulthideGrp_Release_Flag  = true;
        DefaulthideGrp_Desktop_Flag  = true;
        DefaulthideCreditCard_Flag = true;
        DefaultMultihideGrp_PO_Num_Flag = true;
        DefaultMultihideGrp_CCenter_Flag = true;
        DefaultMultihideGrp_Release_Flag = true;
        DefaultMultihideGrp_Desktop_Flag = true;
        DefaultHideMultipleShipTo_Flag = true;//NAIT-21034
        DefaultHideSSO_Id_Flag = true;//NAIT-21040
        DefaultHideCustomCatalogCode_Flag = true;//NAIT-21040
        DefaulthideCreditCard_Flag = true;//NAIT-21075
    
        
        InvoiceUserRegFieldsMap = new Map<string,string>();
        defaultInvoiceUserRegFieldsList = [SELECT Id, Label__c, Invoice_UserReg_Fields__c  FROM GPO_Link__c WHERE GPO_Group__c =: defaultGroup.Id AND Type__c = 'Invoice_UserReg_Form_Field'];
        for(GPO_Link__c field : defaultInvoiceUserRegFieldsList){
            if (field.Invoice_UserReg_Fields__c != null)
                InvoiceUserRegFieldsMap.put(field.Invoice_UserReg_Fields__c, field.Label__c);
        }
        //--NAIT-21075----end
        
        if (communityUser.IsPortalEnabled) {
            communityContact = [Select id, Name, GPOCommunityID__c, GPO_Community__c, Admin_Context__c from Contact where id =: communityUser.ContactID];
            if(!commSetup.Admin_ProfileId__c.equals(String.valueOf(communityUser.ProfileID))) {
                selectedGroup = [SELECT Id, aops_cust_id__c, private__c,Activated__c, Ultimate_Parent2__c, hideSections__c,hideSectionsPost__c, GPO_Template__c, Welcome_Title__c, 
                    Welcome_Message__c, LastModifiedDate,  Community_Image__c, Account__c, Community_Name__c, Account__r.cust_id__c,inheritParentLogo__c,inheritParentFields__c,
                    inheritParentPageComponents__c,inheritParentPageLinks__c,Hide_SPC_Download_Link_PostLogin__c,User_Maintenance_Allowed__c FROM GPO_Group__c WHERE Account__c = :communityContact.GPO_Community__c];
            usingGroup = [SELECT Id, aops_cust_id__c, private__c,Activated__c, Ultimate_Parent2__c, hideSections__c,hideSectionsPost__c, GPO_Template__c, Welcome_Title__c, 
                    Welcome_Message__c, LastModifiedDate,  Community_Image__c, Account__c, Community_Name__c, Account__r.cust_id__c,inheritParentLogo__c,inheritParentFields__c,
                    inheritParentPageComponents__c,inheritParentPageLinks__c,Hide_SPC_Download_Link_PostLogin__c,User_Maintenance_Allowed__c FROM GPO_Group__c WHERE Account__c = :communityContact.GPO_Community__c];
            
                
            } else if ( ''.equals(String.valueOf(communityContact.Admin_Context__c)) || null == communityContact.Admin_Context__c ){
                selectedGroup = [SELECT Id, private__c,Activated__c, Ultimate_Parent2__c,aops_cust_id__c,  GPO_Template__c, hideSections__c, hideSectionsPost__c, Welcome_Title__c, 
                    Welcome_Message__c, LastModifiedDate, Community_Image__c, Account__c, Community_Name__c,inheritParentLogo__c,inheritParentFields__c,
                    inheritParentPageComponents__c,inheritParentPageLinks__c,Hide_SPC_Download_Link_PostLogin__c,User_Maintenance_Allowed__c  FROM GPO_Group__c WHERE Account__c = :communityContact.GPO_Community__c];
            usingGroup = [SELECT Id, private__c,Activated__c, Ultimate_Parent2__c,aops_cust_id__c,  GPO_Template__c, hideSections__c, hideSectionsPost__c, Welcome_Title__c, 
                    Welcome_Message__c, LastModifiedDate, Community_Image__c, Account__c, Community_Name__c,inheritParentLogo__c,inheritParentFields__c,
                    inheritParentPageComponents__c,inheritParentPageLinks__c,Hide_SPC_Download_Link_PostLogin__c,User_Maintenance_Allowed__c  FROM GPO_Group__c WHERE Account__c = :communityContact.GPO_Community__c];
           
                
                
            } else {          
                selectedGroup = [SELECT Id,  private__c,Activated__c,aops_cust_id__c,  Ultimate_Parent2__c, GPO_Template__c, hideSections__c, hideSectionsPost__c, Welcome_Title__c, 
                    Welcome_Message__c, LastModifiedDate, Community_Image__c, Account__c, Community_Name__c,inheritParentLogo__c,inheritParentFields__c,
                    inheritParentPageComponents__c,inheritParentPageLinks__c,Hide_SPC_Download_Link_PostLogin__c,User_Maintenance_Allowed__c  FROM GPO_Group__c WHERE Account__c = :communityContact.Admin_Context__c];
           usingGroup = [SELECT Id,  private__c,Activated__c,aops_cust_id__c,  Ultimate_Parent2__c, GPO_Template__c, hideSections__c, hideSectionsPost__c, Welcome_Title__c, 
                    Welcome_Message__c, LastModifiedDate, Community_Image__c, Account__c, Community_Name__c,inheritParentLogo__c,inheritParentFields__c,
                    inheritParentPageComponents__c,inheritParentPageLinks__c,Hide_SPC_Download_Link_PostLogin__c,User_Maintenance_Allowed__c  FROM GPO_Group__c WHERE Account__c = :communityContact.Admin_Context__c];
          
                
                
            }
          system.debug('Before admin context update:' + communityContact.Admin_Context__c);
        }
        else {
            system.debug('gpoGroupid: ' + ApexPages.currentPage().getParameters().get('gpoGroupid'));
            selectedGroup = [SELECT Id,  private__c, aops_cust_id__c, Activated__c, Ultimate_Parent2__c, GPO_Template__c, hideSections__c, hideSectionsPost__c, Welcome_Title__c, 
                    Welcome_Message__c, LastModifiedDate, Community_Image__c, Account__c, Community_Name__c,inheritParentLogo__c,inheritParentFields__c,
                    inheritParentPageComponents__c,inheritParentPageLinks__c,Hide_SPC_Download_Link_PostLogin__c, User_Maintenance_Allowed__c FROM GPO_Group__c WHERE id= :ApexPages.currentPage().getParameters().get('gpoGroupid')];
         usingGroup = [SELECT Id,  private__c, aops_cust_id__c, Activated__c, Ultimate_Parent2__c, GPO_Template__c, hideSections__c, hideSectionsPost__c, Welcome_Title__c, 
                    Welcome_Message__c, LastModifiedDate, Community_Image__c, Account__c, Community_Name__c,inheritParentLogo__c,inheritParentFields__c,
                    inheritParentPageComponents__c,inheritParentPageLinks__c,Hide_SPC_Download_Link_PostLogin__c, User_Maintenance_Allowed__c FROM GPO_Group__c WHERE id= :ApexPages.currentPage().getParameters().get('gpoGroupid')];
       
       
       
        }
        
        if (selectedGroup != null) {
            if (selectedGroup.Private__c)
                 displayApprovalLink = 'block';
            if (selectedGroup.Community_Name__c != null) {
              pageID = 'CommPostlogin_' + selectedGroup.Community_Name__c.replaceAll( '\\s+', '');  
              LogOutCM = 'Communities-_-CommPostlogin_'+selectedGroup.Community_Name__c.replaceAll( '\\s+', '')+'-_-Logout';
            }
        }
        
     
        // Account associated with GPO Community
        gpoAccount = [Select id, Name, aops_cust_id__c, cust_id__c, SPC_Allowed__c, OwnerID, (select name,id from ChildAccounts limit 2),ParentId from Account where id =: selectedGroup.Account__c];
        system.debug('gpoAccount ' + gpoAccount);
        
        //--NAIT-11785----------
        Account_SPC_Allowed_Flag = gpoAccount.SPC_Allowed__c;
        hideSPCdownloadLink = selectedGroup.Hide_SPC_Download_Link_PostLogin__c;
        userMaintenanceAllowed = selectedGroup.User_Maintenance_Allowed__c;
        // GPO associated Account Owner
        accountOwner = [Select id, ISACTIVE, Name, Email, Phone, FullPhotoUrl, MobilePhone, system_user__c from User where id =: gpoAccount.ownerId ];   
        //Template Defined by GPO Group
        selectedTemplate = [Select id, Template_Name__c, Home_Page__c, Member_Page__c from GPO_Template__c where id =: selectedGroup.GPO_Template__c];   
         
        if(getAdminHeader()){
            system.debug('XXXXXXXXX');  
            initAdminDetails(); 
        }
        //Communities v2
     //   usingGroup = selectedGroup;
       //         imageId = selectedGroup.Community_Image__c;
        //Inherit from Parent
        if(gpoAccount.ParentId != null){
            try {
                parentGroup = [SELECT id,Community_Image__c,hideSectionsPost__c,Selected_Message__c FROM GPO_Group__c WHERE Account__r.Id =: gpoAccount.ParentId];
            }
            catch(Exception e){
                system.debug('PARENT GROUP NOT FOUND');
            }
        }
        if(parentGroup != null){
            if(selectedGroup.inheritParentLogo__c == true){
                usingGroup.Community_Image__c = parentGroup.Community_Image__c;
            }
            if(selectedGroup.inheritParentPageComponents__c == true){
                usingGroup.hideSectionsPost__c = parentGroup.hideSectionsPost__c;
            }
        }
    //    if(parentGroup != null && selectedGroup.inheritParentLogo__c == true){
     //       selectedGroup.Community_Image__c = parentGroup.Community_Image__c;
      //  }
    
        // Page Links
        if(parentGroup != null && selectedGroup.inheritParentPageLinks__c == true){
            pageLinks = [SELECT id, Name, URL_Address__c, Label__c, Active__c FROM GPO_Link__c WHERE GPO_Group__c =: parentGroup.Id AND Type__c = 'Link' LIMIT 25];
            for (GPO_Link__c link : [SELECT id, Name, URL_Address__c, Label__c, Active__c FROM GPO_Link__c WHERE GPO_Group__c =: selectedGroup.Id AND Type__c = 'Link' LIMIT 25]){
                pageLinks.add(link);
            }
        }
        else {
            pageLinks = [SELECT id, Name, URL_Address__c, Label__c, Active__c FROM GPO_Link__c WHERE GPO_Group__c =: selectedGroup.Id AND Type__c = 'Link' LIMIT 25];
        }
        // Fields
        if(parentGroup != null && selectedGroup.inheritParentFields__c == true){
            usingGroup.id = ParentGroup.id;
        }
        
        
        invoiceFieldsList = [SELECT id, Label__c, Invoice_Form_Fields__c, Active__c, Hide__c FROM GPO_Link__c WHERE GPO_Group__c =: usingGroup.Id 
            AND Type__c = 'Invoice Request Form Field' AND Active__c = true];
        userRegistrationFieldsList = [SELECT id, Label__c, User_Registration_Fields__c, Active__c FROM GPO_Link__c 
            WHERE GPO_Group__c =: UsingGroup.Id AND Type__c = 'User Registration Field' AND Active__c = true];
                
        for(GPO_Link__c field : InvoiceFieldsList){
            if (field.Invoice_Form_Fields__c != null && field.Label__c != null)
                defaultInvoiceFieldsMap.put(field.Invoice_Form_Fields__c, field.Label__c);
                
             if(field.Invoice_Form_Fields__c == 'I would prefer to pay by Credit Card')
                        DefaulthideCreditCard_Flag = false;
        }
        for(GPO_Link__c field : userRegistrationFieldsList){
            if (field.User_Registration_Fields__c != null && field.Label__c != null){
                UserRegistrationFieldsMap.put(field.User_Registration_Fields__c, field.Label__c);
                //system.debug('field.User_Registration_Fields__c: ' + field.User_Registration_Fields__c);
            }
            if(field.User_Registration_Fields__c == 'Multiple PO Numbers'){
                DefaultMultihideGrp_PO_Num_Flag = false;
            }
            if(field.User_Registration_Fields__c == 'Multiple Cost Centers'){
                DefaultMultihideGrp_CCenter_Flag = false;
            }
            if(field.User_Registration_Fields__c == 'Multiple Releases'){
                DefaultMultihideGrp_Release_Flag = false;
            }
            if(field.User_Registration_Fields__c == 'Multiple Desktops'){
                DefaultMultihideGrp_Desktop_Flag = false;
            }//--NAIT-21026--------21027-----------End--------->
            if(field.User_Registration_Fields__c == 'Multiple Ship To'){
                DefaultHideMultipleShipTo_Flag = false;
            }
            if(field.User_Registration_Fields__c == 'SSO Id'){
                DefaultHideSSO_Id_Flag = false;
            }
            if(field.User_Registration_Fields__c == 'Custom Catalog Code'){
                DefaultHideCustomCatalogCode_Flag = false;
            }
        }
        
        //----NAIT-21075------start-------
        InvoiceUserRegFieldsList = [SELECT id, Label__c, Invoice_UserReg_Fields__c , Active__c FROM GPO_Link__c WHERE GPO_Group__c =: UsingGroup.Id AND Type__c = 'Invoice_UserReg_Form_Field' AND Active__c = true];

        for(GPO_Link__c field : InvoiceUserRegFieldsList){
            
            if (field.Invoice_UserReg_Fields__c != null && field.Label__c != null)
                InvoiceUserRegFieldsMap.put(field.Invoice_UserReg_Fields__c, field.Label__c);
                
            //Flags for hiding by defalult--NAIT-21075--
            if(field.Invoice_UserReg_Fields__c == 'PO Number'){
                DefaulthideGrp_PO_Num_Flag = false;
            }
            if(field.Invoice_UserReg_Fields__c == 'Cost Center'){
                DefaulthideGrp_CCenter_Flag = false;
            }
            if(field.Invoice_UserReg_Fields__c == 'Release'){
                DefaulthideGrp_Release_Flag = false;
            }
            if(field.Invoice_UserReg_Fields__c == 'Desktop'){
                DefaulthideGrp_Desktop_Flag = false;
            }
        }
        //----NAIT-21075------end--------------

        hiddenFields = [SELECT Hide__c,Invoice_Form_Fields__c,Invoice_UserReg_Fields__c,User_Registration_Fields__c  FROM GPO_Link__c WHERE GPO_Group__c =: usingGroup.Id AND Hide__c = true AND Active__c = true];
        for(GPO_Link__c field: hiddenFields)
        {
            if(field.User_Registration_Fields__c == 'Website'){
                hideWebsite = true;
            }
            if(field.User_Registration_Fields__c == 'Notes'){
                hideNotes = true;
            }
            if(field.Invoice_Form_Fields__c == 'Business Extension'){
                hideExtension = true;
            }
            //--NAIT-21075------------sTART--------->
            if(field.Invoice_UserReg_Fields__c == 'PO Number'){
                hideGrp_PO_Num_Flag = true;
            }
            if(field.Invoice_UserReg_Fields__c == 'Cost Center'){
                hideGrp_CCenter_Flag = true;
            }
            if(field.Invoice_UserReg_Fields__c == 'Release'){
                hideGrp_Release_Flag = true;
            }
            if(field.Invoice_UserReg_Fields__c == 'Desktop'){
                hideGrp_Desktop_Flag = true;
            }
            if(field.Invoice_Form_Fields__c == 'I would prefer to pay by Credit Card'){
                        hideCreditCard_Flag = true;
            }
            if(field.User_Registration_Fields__c == 'Multiple PO Numbers'){
                MultihideGrp_PO_Num_Flag = true;
            }
            if(field.User_Registration_Fields__c == 'Multiple Cost Centers'){
                MultihideGrp_CCenter_Flag = true;
            }
            if(field.User_Registration_Fields__c == 'Multiple Releases'){
                MultihideGrp_Release_Flag = true;
            }
            if(field.User_Registration_Fields__c == 'Multiple Desktops'){
                MultihideGrp_Desktop_Flag = true;
            }
            if(field.User_Registration_Fields__c == 'Multiple Ship To'){
                hideMultipleShipTo_Flag = true;
            }
            if(field.User_Registration_Fields__c == 'SSO Id'){
                hideSSO_Id_Flag = true;
            }
            if(field.User_Registration_Fields__c == 'Custom Catalog Code'){
                hideCustomCatalogCode_Flag = true;
            }
            //--NAIT-21075------------end--------->
        }
        
        //--NAIT-21075------------
        initDefaultSoftHeaders(usingGroup.Id);
        //NAIT-21040-------------
        GPO_Group__c grp_cccode = [SELECT Id, Custom_Catalog_Code__c, Allow_Ship_To_Address_Selection__c from GPO_Group__c where id =:UsingGroup.Id limit 1];
        if(grp_cccode.Custom_Catalog_Code__c == null){
            grp_CustomCatalogCode_Val_Flag = false;
            //system.debug('grp_CustomCatalogCode null:' + grp_CustomCatalogCode);
        }
        else{
            grp_CustomCatalogCode_Val_Flag = true;
            grp_CustomCatalogCode = grp_cccode.Custom_Catalog_Code__c;
            //system.debug('grp_CustomCatalogCode not null:' + grp_CustomCatalogCode);
        }
        //NAIT-21032----ADD ShipTO address Selection---start
        grp_Allow_ShipTo_Address_Selection_Flag = grp_cccode.Allow_Ship_To_Address_Selection__c;
        
        //NAIT-21032----ADD ShipTO address Selection---endGrp_PO_Num_Flag
        //---NAIT-21027- Each soft-header indicator is hidden by default and, if selected to make visible, 
        //the indicator will ONLY be displayed on the form IF the related soft-header field is visible on the form
        system.debug('DefaulthideGrp_PO_Num_Flag:' + DefaulthideGrp_PO_Num_Flag);
        system.debug('hideGrp_PO_Num_Flag:' + hideGrp_PO_Num_Flag);
        if((hideGrp_PO_Num_Flag == false && DefaulthideGrp_PO_Num_Flag == true) || (hideGrp_PO_Num_Flag == true && DefaulthideGrp_PO_Num_Flag == false))
            MultihideGrp_PO_Num_Flag = true;
        if((hideGrp_CCenter_Flag == false && DefaulthideGrp_CCenter_Flag == true) || (hideGrp_CCenter_Flag == true && DefaulthideGrp_CCenter_Flag == false))
            MultihideGrp_CCenter_Flag = true;
        if((hideGrp_Release_Flag == false && DefaulthideGrp_Release_Flag == true)  || (hideGrp_Release_Flag == true && DefaulthideGrp_Release_Flag == false))
            MultihideGrp_Release_Flag = true;
        if((hideGrp_Desktop_Flag == false && DefaulthideGrp_Desktop_Flag == true)  || (hideGrp_Desktop_Flag == true && DefaulthideGrp_Desktop_Flag == false))
            MultihideGrp_Desktop_Flag = true;
        
        
        
        
        // Greeting Message Selection
        messages = [SELECT id, Type__c, Greeting_Message__c,Name FROM GPO_Group_Detail__c WHERE GPO_Group__c =: defaultGroup.id AND Type__c = 'Greeting Message' ORDER BY CreatedDate];
        gpo_group__c selectedGroup2 = [SELECT id, selected_message__c,Welcome_Message__c FROM GPO_Group__c WHERE id =: selectedGroup.Id];
        customMessage = [SELECT id, Type__c, Greeting_Message__c,Name FROM GPO_Group_Detail__c WHERE GPO_Group__c =: selectedGroup2.id AND Type__c = 'Greeting Message' ORDER BY Createddate];
        if (selectedGroup2.selected_message__c == null) {
            selectedMessage = [SELECT Greeting_Message__c FROM GPO_Group_Detail__c WHERE GPO_Group__c =: defaultGroup.id AND Name =: 'Standard Message 1' LIMIT 1];
        } else {
            selectedMessage = [SELECT id, Greeting_Message__c FROM GPO_Group_Detail__c WHERE id =: selectedGroup2.selected_message__c];
        }
        selected = selectedMessage.Greeting_Message__c;
    }
    
    //--NAIT-21075-------------------sTART--------->
    private void initDefaultSoftHeaders(id grpid_found_for_softheaders)
    {
            
            system.debug('grpid_found_for_softheaders: ' + grpid_found_for_softheaders);
            
            
            //-------------------------------Start of SH Setting flags-----------------
            GPO_Group__c Grp_SH_Setting = [SELECT Id, PO_Number_Setup__c, Cost_Center_Setup__c, Release_Setup__c, Desktop_Setup__c from GPO_Group__c where id =:grpid_found_for_softheaders limit 1];
            
            if( Grp_SH_Setting.PO_Number_Setup__c == 'S (--Select Any---)'){
                system.debug('PO_Number_Setup__c:' + Grp_SH_Setting.PO_Number_Setup__c);
                Grp_PO_Num_Setting = true;
            }
            else
                Grp_PO_Num_Setting = false;
            //-------------------    
            
            if( Grp_SH_Setting.Cost_Center_Setup__c == 'S (--Select Any---)'){
                system.debug('Cost_Center_Setup__c:' + Grp_SH_Setting.Cost_Center_Setup__c);
                Grp_CCenter_Setting = true;
            }
            else
                Grp_CCenter_Setting = false;
            //-------------------    
            if( Grp_SH_Setting.Release_Setup__c == 'S (--Select Any---)'){
                system.debug('Release_Setup__c:' + Grp_SH_Setting.Release_Setup__c);
                Grp_Release_Setting = true;
            }
            else
                Grp_Release_Setting = false;
            //-------------------    
            if( Grp_SH_Setting.Desktop_Setup__c == 'S (--Select Any---)'){
                system.debug('Grp_Desktop_Setting:' + Grp_SH_Setting.Desktop_Setup__c);
                Grp_Desktop_Setting = true;
            }
            else
                Grp_Desktop_Setting = false;
            //-----------------------------------end of SH Setting flags-----------------
            
            //--NAIT-21075-------------------sTART--------->
            Grp_PO_Num = [SELECT SoftHeader_Value__c from GPO_Soft_Headers__c where GPO_Group__c =:grpid_found_for_softheaders  and SoftHeader_Type__c = 'PO Number' order by SoftHeader_Value__c asc];
            if (Grp_PO_Num.size() > 0){
                system.debug('defaultGrp_PO_Num:' + Grp_PO_Num.size());
                Grp_PO_Num_Flag = true;
                
                Grp_PO_Num_str_list = new List<SelectOption>();
            //    Grp_PO_Num_str_list.add(new SelectOption('','-None-'));
                for(GPO_Soft_Headers__c sh:Grp_PO_Num)
                {
                    
                    Grp_PO_Num_str_list.add(new SelectOption('',sh.SoftHeader_Value__c));
                    system.debug('PO_Number_Values__c:' + sh.SoftHeader_Value__c);
                }
                system.debug('Grp_PO_Num_str_list.size():' + Grp_PO_Num_str_list.size());
            }
            else
               Grp_PO_Num_Flag = false; 
               
            if(Grp_PO_Num_Setting == false && Grp_PO_Num_Flag == false && hideGrp_PO_Num_Flag == false){
                Grp_PO_Num_str_list = new List<SelectOption>();
            //    Grp_PO_Num_str_list.add(new SelectOption('','-None-'));
                system.debug('All 3 PO flags are false:' + Grp_PO_Num_str_list.size()) ;
            }
                
            
            //-----------------------------------
            Grp_CCenter = [SELECT SoftHeader_Value__c from GPO_Soft_Headers__c where GPO_Group__c =: grpid_found_for_softheaders and SoftHeader_Type__c = 'Cost Center' order by SoftHeader_Value__c asc];
            if (Grp_CCenter.size() > 0){
                system.debug('defaultGrp_CCenter:' + Grp_CCenter.size());
                Grp_CCenter_Flag = true;
                
                
                Grp_CCenter_str_list = new List<SelectOption>();
            //    Grp_CCenter_str_list.add(new SelectOption('','-None-'));
                for(GPO_Soft_Headers__c sh:Grp_CCenter)
                {
                    
                    Grp_CCenter_str_list.add(new SelectOption('',sh.SoftHeader_Value__c));
                    system.debug('Cost_Center_Values__c:' + sh.SoftHeader_Value__c);
                }
                system.debug('Grp_CCenter_str_list.size():' + Grp_CCenter_str_list.size());
            }
            else
                Grp_CCenter_Flag = false;
                
            if(Grp_CCenter_Setting == false && Grp_CCenter_Flag == false && hideGrp_CCenter_Flag == false){
                Grp_CCenter_str_list = new List<SelectOption>();
           //     Grp_CCenter_str_list.add(new SelectOption('','-None-'));
                system.debug('All 3 CC flags are false:' + Grp_CCenter_str_list.size()) ;
            }
            //------------------------------
            Grp_Release = [SELECT SoftHeader_Value__c from GPO_Soft_Headers__c where GPO_Group__c =: grpid_found_for_softheaders and SoftHeader_Type__c = 'Release' order by SoftHeader_Value__c asc];
            if (Grp_Release.size() > 0){
                system.debug('defaultGrp_Release:' + Grp_Release.size());
                Grp_Release_Flag = true;
                
                
                Grp_Release_str_list = new List<SelectOption>();
           //     Grp_Release_str_list.add(new SelectOption('','-None-'));
                for(GPO_Soft_Headers__c sh:Grp_Release)
                {
                    
                    Grp_Release_str_list.add(new SelectOption('',sh.SoftHeader_Value__c));
                    system.debug('Release_Values__c:' + sh.SoftHeader_Value__c);
                }
                system.debug('Grp_Release_str_list.size():' + Grp_Release_str_list.size());
            }
            else
                Grp_Release_Flag = false;
                
            if(Grp_Release_Setting == false && Grp_Release_Flag == false && hideGrp_Release_Flag == false){
                Grp_Release_str_list = new List<SelectOption>();
           //     Grp_Release_str_list.add(new SelectOption('','-None-'));
                system.debug('All 3 Release flags are false:' + Grp_Release_str_list.size()) ;
            }
            
            //--------------------------
            Grp_Desktop = [SELECT SoftHeader_Value__c from GPO_Soft_Headers__c where GPO_Group__c =: grpid_found_for_softheaders and SoftHeader_Type__c = 'Desktop' order by SoftHeader_Value__c asc];
            if (Grp_Desktop.size() > 0){
                system.debug('defaultGrp_Desktop:' + Grp_Desktop.size());
                Grp_Desktop_Flag = true;
                
                
                Grp_Desktop_str_list = new List<SelectOption>();
             //   Grp_Desktop_str_list.add(new SelectOption('','-None-'));
                for(GPO_Soft_Headers__c sh:Grp_Desktop)
                {
                    
                    Grp_Desktop_str_list.add(new SelectOption('',sh.SoftHeader_Value__c));
                    system.debug('Desktop_Values__c:' + sh.SoftHeader_Value__c);
                }
                system.debug('Grp_Desktop_str_list.size():' + Grp_Desktop_str_list.size());
            }
            else
                Grp_Desktop_Flag = false;
                
            if(Grp_Desktop_Setting == false && Grp_Desktop_Flag == false && hideGrp_Desktop_Flag == false){
                Grp_Desktop_str_list = new List<SelectOption>();
            //    Grp_Desktop_str_list.add(new SelectOption('','-None-'));
                system.debug('All 3 Desktop flags are false:' + Grp_Desktop_str_list.size()) ;
            }
            
          //--NAIT-21075-------------------End--------->
        
    }
    
    public void initAdminDetails() {
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