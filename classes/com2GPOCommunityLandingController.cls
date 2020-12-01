/**
 * Controller for GPO Home Landing Page
 * Logic in this Controller should general and not contain any template specific details
 * Template details should be contained in a template specific Extention
 */
public without sharing class com2GPOCommunityLandingController {
    public string cip {get; set;}
    public GPO_Group__c selectedGroup {get; set;}  //GPO Group whos content should be displayed on the home page
    public Account gpoAccount {get; set;} //GPO Group Account
    public User accountOwner {get; set;}  //GPO Group Account Owner
    public GPO_Template__c selectedTemplate {get; set;} //GPO Template assigned to the GPO Group
    // public boolean GPOTemplateUsed {get; set;} // Defined if GPO Template is Used
    public gpo_lead__c glead {get; set;}
    public boolean successMsg {get; set;}
    public boolean errorMsg {get; set;}
    public boolean showForm {get; set;}
    public String errorText {get; set;}
    public String parentAccid {get; set;}
    public GPO_Community_Setup__c commSetup {get; set;}
    private String privateKey {get; set;}
    public class custException extends Exception {}
    public String leadPassword {get; set;}
    public String pageID {get; set;}
    public String step1PageID {get; set;}
    public String step2PageID {get; set;}
    public String step3PageID {get; set;}
    public String PageId1 {get; set;}
    public String PageIdtoken {get; set;}
    public String hideSectionsList {get; set;}
    //Communities 2.1
    public GPO_Group__c defaultGroup {get; set;}
    public String newWelcomeMessage {get; set;}
    public boolean showGeneric {get; set;}
    //added by ivarada - 4/9/2018 - starts
    public boolean splOverride {get; set;}
    //added by ivarada - 4/9/2018 - ends
    public boolean systemUser {get; set;}
    public List<SelectOption> options {get; set;}
    public List<GPO_Link__c> pageLinks {get; set;}
    public List<GPO_Link__c> pageLinksAll {get; set;}
    //  public String GPOId {get;set;}

    public List<GPO_Link__c> defaultInvoiceFieldsList {get; set;}
    public Map<String,String> InvoiceFieldsMap {get; set;}
    public List<GPO_Link__c> invoiceFieldsList {get; set;}

    public List<GPO_Link__c> defaultUserRegistrationFieldsList {get; set;}
    public Map<String,String> UserRegistrationFieldsMap {get; set;}
    public List<GPO_Link__c> userRegistrationFieldsList {get; set;}

    //----NAIT-21026 AND NAIT-21075-------------
    public List<GPO_Link__c> defaultInvoiceUserRegFieldsList {get; set;}
    public Map<String,String> InvoiceUserRegFieldsMap {get; set;}
    public List<GPO_Link__c> InvoiceUserRegFieldsList {get; set;}

    //----NAIT-21026 AND NAIT-21075-------------

    public Case invoiceCase {get; set;}
    public List<GPO_Link__c> hiddenFields {get; set;}
    public boolean hideWebsite {get; set;}
    public boolean hideNotes {get; set;}
    public boolean hideExtension {get; set;}
    public boolean hideCompanyName {get; set;}
    public boolean hideEmployees {get; set;}
    public List<GPO_Group_Detail__c> messages {get; set;}
    public String selectedMessage {get; set;}
    public GPO_Group_Detail__c defaultMessage {get; set;}
    public String welcomeMessage {get; set;}
    public GPO_Group_Detail__c insertMessage {get; set;}
    // Communities 2.2
    public Boolean hideSPCdownloadLink {get; set;}
    public Boolean hideRegisterLink {get; set;}
    public Boolean hideLoginOption {get; set;}//Added by Rajendra shahane for NAIT-155579 Remove the login option from the following community pages.
    public GPO_Group__c parentGroup {get; set;}
    public GPO_Group__c UsingGroup {get; set;}

    //--NAIT-21026-------------------sTART--------->
    public boolean Grp_PO_Num_Setting {get; set;}
    public boolean Grp_CCenter_Setting {get; set;}
    public boolean Grp_Release_Setting {get; set;}
    public boolean Grp_Desktop_Setting {get; set;}

    public list<GPO_Soft_Headers__c> Grp_PO_Num {get; set;}
    public list<GPO_Soft_Headers__c> Grp_CCenter {get; set;}
    public list<GPO_Soft_Headers__c> Grp_Release {get; set;}
    public list<GPO_Soft_Headers__c> Grp_Desktop {get; set;}

    public list<SelectOption> Grp_PO_Num_str_list {get; set;}
    public list<SelectOption> Grp_CCenter_str_list {get; set;}
    public list<SelectOption> Grp_Release_str_list {get; set;}
    public list<SelectOption> Grp_Desktop_str_list {get; set;}

    public boolean Grp_PO_Num_Flag {get; set;}
    public boolean Grp_CCenter_Flag {get; set;}
    public boolean Grp_Release_Flag {get; set;}
    public boolean Grp_Desktop_Flag {get; set;}

    public boolean hideGrp_PO_Num_Flag {get; set;}
    public boolean hideGrp_CCenter_Flag {get; set;}
    public boolean hideGrp_Release_Flag {get; set;}
    public boolean hideGrp_Desktop_Flag {get; set;}
    public boolean MultihideGrp_PO_Num_Flag {get; set;}
    public boolean MultihideGrp_CCenter_Flag {get; set;}
    public boolean MultihideGrp_Release_Flag {get; set;}
    public boolean MultihideGrp_Desktop_Flag {get; set;}
    public boolean hideMultipleShipTo_Flag {get; set;}
    public boolean hideSSO_Id_Flag {get; set;}//NAIT-21040
    public boolean hideCustomCatalogCode_Flag {get; set;}//NAIT-21040

    public boolean DefaulthideGrp_PO_Num_Flag {get; set;}
    public boolean DefaulthideGrp_CCenter_Flag {get; set;}
    public boolean DefaulthideGrp_Release_Flag {get; set;}
    public boolean DefaulthideGrp_Desktop_Flag {get; set;}
    public boolean DefaultMultihideGrp_PO_Num_Flag {get; set;}
    public boolean DefaultMultihideGrp_CCenter_Flag {get; set;}
    public boolean DefaultMultihideGrp_Release_Flag {get; set;}
    public boolean DefaultMultihideGrp_Desktop_Flag {get; set;}

    public boolean DefaultHideMultipleShipTo_Flag {get; set;}//NAIT-21034
    public boolean DefaultHideSSO_Id_Flag {get; set;}//NAIT-21040
    public boolean DefaultHideCustomCatalogCode_Flag {get; set;}//NAIT-21040
    public decimal grp_CustomCatalogCode  {get; set;}//NAIT-21040
    public boolean grp_CustomCatalogCode_Val_Flag {get; set;}//NAIT-21040

    //NAIT-21032------------Start
    public boolean grp_Allow_ShipTo_Address_Selection_Flag  {get; set;}
    public String inpVal {get; set;}
    public list<String> dlist {get; set;}
    public list<String> alist {get; set;} // Account selection typeahead feature
    public boolean Check_Address2_Val {get; set;}
    //NAIT-21032------------End

    public boolean DefaulthideCreditCard_Flag {get; set;}//NAIT-21075
    public boolean hideCreditCard_Flag  {get; set;}//NAIT-21075
    //--NAIT-21026-------------------End------------->
    public String parentId {get; set;}
    //--NAIT-11785----------
    public String Account_SPC_Allowed_Flag {get; set;}
    public Boolean User_Register_For_SPC {get; set;}
    public Boolean showCostCenter {get; set;}
    public Boolean showRegForm {get; set;}
    public Boolean showAccountSelection {get; set;}
    public Boolean showApproverSection {get; set;}
    public Boolean showAdditionalCostCenters {get; set;}
    public Boolean showAdditionalAddresses {get; set;}

    public string status {get; set;}
    public string token ='';
    Datetime expDateTime =  System.now().addMinutes(20);
    DateTime dt=Datetime.now();

    // The keys you get by signing up for reCAPTCHA for your domain
    public String publicKey {
        get {
            return commSetup.captcha_publicKey__c;
        }
    }


    // Simple form fields for the example form
    public String myName { get; set; }
    public String myEmail { get; set; }


    //NAIT-21032------------Start
    public void loadtypeahead() {
		if (usingGroup == null)
		{
			return;
		}
		
        dlist = new list<String>(); // addresses
        alist = new list<String>(); // accounts

        string page_aops_id = ApexPages.currentPage().getParameters().get('id');
        //system.debug('loadtypeahead: ' + ApexPages.currentPage().getParameters().get('id'));



        List<TechDepotSetting__c> tech = [Select Id,Crypto_key__C from TechDepotSetting__c where name ='Key'];
        Blob cryptoKey =EncodingUtil.base64Decode(tech[0].Crypto_key__c);

        token = EncodingUtil.convertToHex(Crypto.generateDigest('MD5',Blob.valueOf('U' + Crypto.getRandomInteger())));
        System.Debug('token chk'+token);
        if(usingGroup.ExpireLink__c !=  null )
        {
            if(System.now() <= usingGroup.ExpireLink__c)
            {
                token = usingGroup.token__c;
            }
        }


        GPO_Group__c token_group = [select id,token__C,ExpireLink__c from GPO_Group__c where aops_cust_id__c = :page_aops_id  ];
        token_group.token__C= token;
        token_group.ExpireLink__c= expDateTime;
        try{
            update token_group;

        }
        catch(Exception e)
        {
        }
        system.debug('Exp  ' +token_group.ExpireLink__c);
        system.debug('Token ' +token);

        token = usingGroup.aops_cust_id__c+'@'+token_group.token__C;
        // token = u.OD_Employee_ID__c;
        Blob data = Blob.valueOf(token);
// Encrypt the data and have Salesforce.com generate the initialization vector
        Blob encryptedData = Crypto.encryptWithManagedIV('AES256', cryptoKey, data);
// Decrypt the data - the first 16 bytes contain the initialization vector
        system.debug('encryptedData ' +encryptedData );



        System.Debug('Check' +token);
        token =EncodingUtil.base64Encode(encryptedData);
        System.Debug('Check1' +token);


        system.debug('encryptedtoken ' +token );
        token= EncodingUtil.URLENCODE(token,'UTF-8');
        //u.Token_Market_Builder__c = token;
        // update u;
        PageIdtoken =token;

        //prasad





        if (page_aops_id != null || page_aops_id == '') {
            
            // Krishna added start
            GPO_Group__c tempGroup = [select hidesections__c from GPO_Group__c where aops_cust_id__c = :page_aops_id  ];
            hideSectionsList = tempGroup.hideSections__c;
      // Krishna added end
            
            
            
            for (account a:
                 [select Address1__c, Address2__c, City__c, State__c, Address__c,
                  zip__c from account where related_account__r.aops_cust_id__c=:page_aops_id and GPO_Site_Status__c = 'Active']) {
                if (a.Address__c != null && a.Address__c != '') {
                    String s = '\''+a.Address__c.replace('\'','')+'\'';
                    //dlist.add(s);
                }

                String Addr_full, s1,s2,s3,s4,s5;

                if (a.Address1__c != null && a.Address1__c != '') {
                    s1 = a.Address1__c.replace('\'','');
                    s1 = a.Address1__c.replace('  ',' ');
                }
                if (a.Address2__c != null && a.Address2__c != '') {
                    s2 = a.Address2__c.replace('\'','');
                    s2 = a.Address2__c.replace('  ',' ');
                }
                if (a.City__c != null && a.City__c != '') {
                    s3 = a.City__c.replace('\'','');
                    s3 = a.City__c.replace('  ',' ');
                }
                if (a.State__c != null && a.State__c != '') {
                    s4 = a.State__c.replace('\'','');
                    s4 = a.State__c.replace('  ',' ');
                }
                if (a.zip__c != null && a.zip__c != '') {
                    string ss = a.zip__c.replace('\'','');
                    s5 = ss.substring(0,5);
                }

                if(s2 == null || s2=='') {
                    Addr_full = '\''+s1+'  '+s3+'  '+s4+'  '+s5+'\'';
                    Check_Address2_Val = false;
                }
                else{
                    Check_Address2_Val = true;
                    Addr_full = '\''+s1+'  '+s2+'  '+s3+'  '+s4+'  '+s5+'\'';
                }
                dlist.add(Addr_full);
                //  alist.add('\'02526864 - acct1\'');

            }
            system.debug('PARENT ' + parentId);
            for (GPO_Group__c g :
                 [SELECT account__r.aops_cust_id__c,
                  Account__r.Name FROM GPO_Group__c WHERE Account__r.ParentId =: parentId AND Activated__c = true AND Account_Selection_Disabled__c =
                      false limit 30000]) {
                if (g.Account__r.Name != null) {
                    g.Account__r.Name = g.Account__r.Name.replace(' - ','');
                }

                alist.add('\'' + g.account__r.aops_cust_id__c + ' - ' + g.Account__r.Name + '\'');
            }
        }

    }

    // Create properties for the non-VF component input fields generated by the reCAPTCHA JavaScript.
    public String challenge {
        get {
            system.debug('recaptcha_challenge_field' +ApexPages.currentPage().getParameters().get('recaptcha_challenge_field'));
            return ApexPages.currentPage().getParameters().get('recaptcha_challenge_field');

        }
    }
    public String response  {
        get {
            system.debug('recaptcha_response_field' +ApexPages.currentPage().getParameters().get('recaptcha_response_field'));
            return ApexPages.currentPage().getParameters().get('recaptcha_response_field');

        }
    }

    public PageReference reset() {
        return null;
    }


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
        System.debug('in com2control checkuser');
        if(logedInUser.Profile.Name==commsetup.user_profile__c) {
            return null;
        } else {
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
        return commsetup.member_page__c;
    }

    //Returns core GPO Community Home Page
    public String getHomePage() {
        return commsetup.home_page__c;
    }

    //Return default path to use for community images
    public String getImageRootPath(){
        return commsetup.image_path__c;
    }

    // Communities 2.1
    // Create a new Case with Invoice Form Submit
    @RemoteAction
    public static String createCase(Case caseObject, String groupId) {
        String errorText;
        boolean errorMsg;
        boolean successMsg;
        String contactName;
        GPO_Group__c gpogroup =
        [SELECT aops_cust_id__c, Account__C, Account__r.Name,Account__r.Account_Owner__c,
         Community_Name__c FROM GPO_Group__c WHERE id = :groupId limit 1];
        Account acct = [SELECT id,OwnerId FROM Account WHERE id =: gpogroup.Account__C];
        Id queueId = [select Id from Group where Type = 'Queue' and Name = 'Communities Queue' limit 1][0].Id;
        User accountOwner = [Select id, Name, Email, Phone, MobilePhone from User where id =: acct.OwnerId LIMIT 1];

        if (caseObject.subject == null || caseObject.subject == '') {
            errorText = 'Error: Please Validate Captcha';
            errorMsg = true;
            successMsg = false;
            return errorText;
        } else {
            caseObject.Subject = 'Communities Portal Account Creation - ' + gpogroup.aops_cust_id__c;
            caseObject.WRF_Request_Type__c = 'Portal Request';
            caseObject.AccountId = gpogroup.Account__c;
            caseObject.recordTypeid = Schema.SobjectType.Case.getRecordTypeInfosByName().get('AM Communities').getRecordTypeId();
            caseObject.ownerId = queueId;
            caseObject.WRF_Current_GPO_Tier__c = gpogroup.Community_Name__c; //used in email template
            contactName = (String)gpogroup.Account__r.Account_Owner__c; //used in email template
            caseObject.AM_Contact_First_Name__c = contactName.stripHtmlTags(); //used in email template
            caseObject.AM_Contact_Phone__c = accountOwner.MobilePhone; //used in email template
            try {
                if(!Test.isRunningTest()) {
                    insert caseObject;
                }
            } catch(exception e) {
                return e.getMessage();
            }
            return 'Success';
        }
    }


    //-------------NAIT-21028------------
    // Create a new Case with user registration Form Submit if any of multiindicators is checked
    public static String MultipleInd_createCase(GPO_Lead__c gpolead, Id account, Id UserId, string Request_Type) {
        String errorText;
        boolean errorMsg;
        boolean successMsg;
        system.debug('In MultipleInd_createCase : accId:'+ account );
        system.debug('In MultipleInd_createCase : Request_Type:' + Request_Type);


        GPO_Group__c gpogroup = [SELECT aops_cust_id__c, Account__C, Account__r.Name FROM GPO_Group__c WHERE Account__C  = :account limit 1];
        //Id communitiesQueueId = [select Id from Group where Type = 'Queue' and Name = 'Communities Queue' limit 1][0].Id;

        Case caseObject = new Case();
        //caseObject.Subject = 'Communities User Multiple Soft-Header Request - ' + gpogroup.aops_cust_id__c;
        caseObject.WRF_Request_Type__c = Request_Type;
        caseObject.AccountId = account;
        caseObject.recordTypeid = Schema.SobjectType.Case.getRecordTypeInfosByName().get('AM Communities').getRecordTypeId();
        //caseObject.ownerId = communitiesQueueId;
        caseObject.Multiple_PO_Numbers__c = gpolead.Multiple_PO_Numbers__c;
        caseObject.Multiple_Cost_Centers__c = gpolead.Multiple_Cost_Centers__c;
        caseObject.Multiple_Releases__c = gpolead.Multiple_Releases__c;
        caseObject.Multiple_Desktops__c = gpolead.Multiple_Desktops__c;
        caseObject.Multiple_Ship_To__c = gpolead.MultipleShipTo__c;//NAIT-21037
        caseObject.Support_Requester__c = UserId;//sfdc user record
        caseObject.GPO_User_Registration__c = gpolead.id;//sfdc GPO user record

        //system.debug('communitiesQueueId:' + communitiesQueueId);
        try {
            if(!Test.isRunningTest()) {
                system.debug('In MultipleInd_createCase: Inserting Case for the AccountId:'+ account);
                insert caseObject;
            }
        } catch(exception e) {
            return e.getMessage();
        }

        return 'Success';

    }//end of function MultipleInd_createCase

    // Used in footer to update year
    public Integer getCurrentYear(){
        return System.Today().year();
    }

    /*
       public String getTest2(){
        PostScriptIndicatorService psis = new PostScriptIndicatorService();
       test1 = psis.getScriptIndicator(ApexPages.currentPage().getParameters().get('id'));
       system.debug('scriptflag -> ' + test1);
        return test1;
       }

       public String getspcTest(){
        com2SPCCardController s1 = new com2SPCCardController();
        spcTest = s1.getSPCNumber('01277596');
        system.debug('NUMBER - > ' + spcTest);
        return spcTest;
       }
     */

    // Sends customized message for groups
    public String getWelcomeMessage1() {
        if (selectedGroup.Selected_Message__c == null) {
            insertMessage =
            [SELECT Greeting_Message__c FROM GPO_Group_Detail__c WHERE GPO_Group__c =: defaultGroup.id AND Name =: 'Standard Message 1' LIMIT 1];
            insertMessage = defaultMessage;
        }
        else {
            insertMessage = [SELECT Greeting_Message__c FROM GPO_Group_Detail__c WHERE ID =: selectedGroup.Selected_Message__c LIMIT 1];
        }
        if (insertMessage.Greeting_Message__c == null) { //If the message has no content, it will populate the default message instead
            insertMessage.Greeting_Message__c = defaultMessage.Greeting_Message__c;
        }
        selectedMessage = insertMessage.Greeting_Message__c.replace('COMMUNITYNAME',selectedGroup.Community_Name__c );

        return selectedMessage;
    }

    // Controls the multi picklist
    public void getElements() {
        Schema.DescribeFieldResult dfr = GPO_Group__c.hideSections__c.getDescribe();
        List<Schema.PicklistEntry> picklistEntries = dfr.getPicklistValues();
        options = new List<SelectOption>();
        for (Schema.PicklistEntry ple : picklistEntries) {
            options.add(new SelectOption(ple.getValue(),ple.getValue()));
        }
    }


// Methods newLead and saveLead added to support Lead creation
    public void newLead() {
        system.debug('Inside Lead Create');
        glead = new GPO_Lead__c();
        successMsg = false;
        errorMsg = false;
        showForm=true;

    }

// Sets up the default group GPO that contains default form field names and Standard Greeting Messages that are shared with all communities.
    public void setDefaults() {
        defaultGroup = [SELECT Id, Name FROM GPO_Group__c where Community_Name__c = 'Default Group'];
        // Default Invoice Form
        defaultInvoiceFieldsList =
        [SELECT Id, Label__c,
         Invoice_Form_Fields__c FROM GPO_Link__c WHERE GPO_Group__c =: defaultGroup.Id AND Type__c = 'Invoice Request Form Field'];
        InvoiceFieldsMap = new Map<string,string>();
        for(GPO_Link__c field : defaultInvoiceFieldsList) {
            if (field.Invoice_Form_Fields__c != null)
                InvoiceFieldsMap.put(field.Invoice_Form_Fields__c, field.Label__c);
        }
        // Default Registration Form
        UserRegistrationFieldsMap = new Map<string,string>();
        defaultUserRegistrationFieldsList =
        [SELECT Id, Label__c,
         User_Registration_Fields__c FROM GPO_Link__c WHERE GPO_Group__c =: defaultGroup.Id AND Type__c = 'User Registration Field'];
        for(GPO_Link__c field : defaultUserRegistrationFieldsList) {
            if (field.User_Registration_Fields__c != null)
                UserRegistrationFieldsMap.put(field.User_Registration_Fields__c, field.Label__c);
        }

        //----NAIT-21026 AND NAIT-21075-------------
        InvoiceUserRegFieldsMap = new Map<string,string>();
        defaultInvoiceUserRegFieldsList =
        [SELECT Id, Label__c,
         Invoice_UserReg_Fields__c FROM GPO_Link__c WHERE GPO_Group__c =: defaultGroup.Id AND Type__c = 'Invoice_UserReg_Form_Field'];
        for(GPO_Link__c field : defaultInvoiceUserRegFieldsList) {
            if (field.Invoice_UserReg_Fields__c != null)
                InvoiceUserRegFieldsMap.put(field.Invoice_UserReg_Fields__c, field.Label__c);
        }

        // Greeting Messages
        messages =
        [SELECT id, Type__c, Greeting_Message__c FROM GPO_Group_Detail__c WHERE GPO_Group__c =: defaultGroup.id AND Type__c = 'Greeting Message'];
        defaultMessage =
        [SELECT Greeting_Message__c,GPO_Group__c,
         Name FROM GPO_Group_Detail__c WHERE GPO_Group__c =: defaultGroup.id AND Name =: 'Standard Message 1' LIMIT 1];
        selectedMessage = defaultMessage.Greeting_Message__c;



    }


//Changes by ivarada 4/9/2018 to method signature, additional param "splaops"

    @RemoteAction
    public static String  insertLeads(GPO_Lead__c gpoleads, String aopsID,String splaops, String pwd, string ccenter) {
        list<account> acc;
        String errorText;
        boolean errorMsg;
        boolean successMsg;
        boolean showForm;
        GPO_Community_Setup__c commuSetup = gpo_community_setup__c.getValues('com2Settings');
        Id Userid_for_case;
        system.debug('gpoleads: ' + gpoleads+'aopsID:'+aopsID+'pwd:'+pwd+'ccenter:'+ccenter);

        try
        {
            GPO_Lead__c glead = gpoleads;
            String parentAccid;
            GPO_Group__c g;
            Account groupAccount;
            //Changes by ivarada 4/9/2018 - starts
            system.debug('splaops: ' + splaops+'aops is:'+aopsID);
            /********** Code Change for SI 473/02501714*******************************
            if (aopsID != null && aopsID != '') {
            
                try {
                    g =
                    [select id, private__c, account__c, PO_Number_Setup__c,Cost_Center_Setup__c,Release_Setup__c,
                     Desktop_Setup__c from gpo_group__c where account__r.aops_cust_id__c like '%\'' + :aopsID + '\'%'];
                    groupAccount = [SELECT id, aops_cust_id__c, SPC_Allowed__c FROM Account WHERE aops_cust_id__c = :aopsID];
                    parentAccid = g.account__c;
                    glead.GPO_Group__c = g.id;
                } catch(Exception e) {
                    aopsID = aopsID.leftPad(8, '0');
                    g =
                    [select id, private__c, account__c, PO_Number_Setup__c,Cost_Center_Setup__c,Release_Setup__c,
                     Desktop_Setup__c from gpo_group__c where account__r.aops_cust_id__c = :aopsID];
                    groupAccount = [SELECT id, aops_cust_id__c, SPC_Allowed__c FROM Account WHERE aops_cust_id__c = :aopsID];
                    parentAccid = g.account__c;
                    glead.GPO_Group__c = g.id;
                }
            }
            else if (splaops != null && splaops != '') {
                try
                {
                    groupAccount = [SELECT id, aops_cust_id__c, SPC_Allowed__c FROM Account WHERE aops_cust_id__c = :splaops];
                    parentAccid = groupAccount.id;
                }
                catch (Exception ex) {
                    throw new custException('Error: Invalid Account Selection');
                }
            }*/
            
            if (aopsID != null && aopsID != '' && aopsID.isNumeric()) {
            
                try {
                    integer iaopsID = integer.valueof(aopsID);
                    string straopsID =  string.valueof(aopsID) ;
                    list<gpo_group__c> lstgpogroup = [select id, private__c,account__r.aops_cust_id__c, account__c, PO_Number_Setup__c,Cost_Center_Setup__c,Release_Setup__c,
                     Desktop_Setup__c from gpo_group__c where account__r.aops_cust_id__c like :straopsID];
                     system.debug('straopsID+++++'+straopsID);
                    if(lstgpogroup != null && lstgpogroup.size() > 0)
                    {
                        for(gpo_group__c gr:lstgpogroup)
                        {
                            if(gr.account__c != null && gr.account__r.aops_cust_id__c != null && gr.account__r.aops_cust_id__c != '' && 
                              gr.account__r.aops_cust_id__c.isnumeric() && integer.valueOf(gr.account__r.aops_cust_id__c) == iaopsID)
                            {
                                g = gr;
                                parentAccid = gr.account__c;
                                 glead.GPO_Group__c = gr.id;
                            }
                        }
                    }
                    
                    list<Account> lstAcc = [SELECT id, aops_cust_id__c, SPC_Allowed__c FROM Account WHERE aops_cust_id__c like :straopsID];
                    {
                        if(lstAcc != null && lstAcc.size() > 0)
                        {
                            for(Account a:lstAcc)
                            {
                                if(a.aops_cust_id__c != null && a.aops_cust_id__c != '' && a.aops_cust_id__c.isnumeric() && integer.valueOf(a.aops_cust_id__c) == iaopsID)
                                {
                                    groupAccount = a;
                                }
                            }
                        }
                    }                    
                   
                } catch(Exception e) {
                    throw new custException('Error: Invalid Account Selection');
                }
            }
            /*******************************Code change ended for the SI-473/02501714*************************************/
            else if (splaops != null && splaops != '') {
                try
                {
                    groupAccount = [SELECT id, aops_cust_id__c, SPC_Allowed__c FROM Account WHERE aops_cust_id__c = :splaops];
                    parentAccid = groupAccount.id;
                }
                catch (Exception ex) {
                    throw new custException('Error: Invalid Account Selection');
                }
            }

            //Changes by ivarada 4/9/2018 - ends
            String captchaResponse = glead.Recaptcha__c;
            if (captchaResponse == null || captchaResponse == '') {
                errorText = 'Error: Please Validate Captcha';
                errorMsg = true;
                successMsg = false;
            }
            else if (glead.first_name__c == null || glead.last_name__c == null || glead.Phone__c == null || glead.Email__c == null ||
                     glead.Business_Name__c == null
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

                //Changes by ivarada 4/9/2018 - starts

                if (g != null)
                {
                    if (!g.private__c)
                        glead.status__c = 'Approved';
                    else
                        glead.status__c = 'Pending';
                }
                //Changes by ivarada 4/9/2018 - ends

                for (User u : [select id,username from user where username = :glead.login_name__c])
                    throw new CustException ('Error: User Already Exists for This Account');


                //Logic to Create Salesforce Contact & User - Starts
                //Changes by ivarada 4/9/2018 - starts
                boolean executePublicFlow = false;

                if (g==null) {
                    executePublicFlow=true;
                }
                else if (!g.private__c) {
                    executePublicFlow=true;
                }


                if (executePublicFlow) {
                    //Changes by ivarada 4/9/2018 - ends

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
                    greq.Password = pwd;

                    //--NAIT-21026-------------------sTART--------->
                    greq.PONumber = glead.PO_Number__c;

                    if(ccenter != null && ccenter != '')
                        greq.CCenter  = ccenter;
                    else
                        greq.CCenter = glead.Cost_Center__c;

                    greq.Release  = glead.Release__c;
                    greq.Desktop  = glead.Desktop__c;
                    //--NAIT-21026-------------------End----------->

                    greq.SSO_Id = glead.SSO_Id__c;
                    greq.CustomCatalogCode = glead.CustomCatalogCode__c;

                    if (greq.CustomCatalogCode.length() < 5)
                        greq.CustomCatalogCode = greq.CustomCatalogCode.leftPad(5,'0');


                    if (groupAccount.SPC_Allowed__c == 'Y' && glead.User_Register_For_SPC__c == true)
                        greq.RegisterSPC = 'Y';
                    else
                        greq.RegisterSPC = 'N';
                    if (glead.Request_Printed_SPC__c == true)
                        greq.ReqPrintedSPC = 'Y';
                    else
                        greq.ReqPrintedSPC = 'N';

                    gpoUserReg.GPOUserRegResponse gRes;
                    if (!Test.isRunningTest()) {
                        gRes = gU.executeUserReg(greq);

                        if (gRes.StatusCode != '00')
                            throw new CustException(gRes.statusDescription);
                    }
                    //Call SOA to Create User in AOPS - Ends


                    //Call to create Salesforce USer Record starts
                    //Changes by ivarada 4/9/2018 - starts
                    if (g != null)
                    {
                        //Changes by ivarada 4/9/2018 - ends
                        partnerSoapSforceCom.Soap sp = new partnerSoapSforceCom.Soap();
                        partnerSoapSforceCom.LoginResult loginResult;
                        if (!Test.isRunningTest()) {
                            String[] sUserinfo = commuSetup.serviceuser__c.split('/');
                            loginResult = sp.login(sUserinfo[0], sUserinfo[1]);
                        }
                        soapSforceComSchemasClassLeadservic.LeadService l = new soapSforceComSchemasClassLeadservic.LeadService ();
                        soapSforceComSchemasClassLeadservic.LeadInformation linfo = new soapSforceComSchemasClassLeadservic.LeadInformation();
                        soapSforceComSchemasClassLeadservic.SessionHeader_element sessionHeader =
                            new soapSforceComSchemasClassLeadservic.SessionHeader_element();
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
                        system.debug('linfo.USERID: ' + linfo.USERID);
                        Userid_for_case = linfo.USERID;
                        glead.SU_CommuContact__c = linfo.CONTACTID;
                        system.debug('Lead Creation Error Message:' + linfo.ErrorMessage);
                        if (linfo.ErrorMessage != null && linfo.ErrorMessage != '')
                        {
                            system.debug('Custom Exception:' + linfo.ErrorMessage);
                            throw new custException('Error:' + +linfo.ErrorMessage);
                        }
                        //Call to create Salesforce USer Record Ends

                        //Changes by ivarada 4/9/2018 - starts
                    } //end if g!= null
                      //Changes by ivarada 4/9/2018 - starts

                }
                //Logic to Create Salesforce Contact & User - Ends


                //insert GPO_Lead record in salesforce

                //Changes by ivarada 4/9/2018 - starts
                if (g!= null)
                {
                    //Changes by ivarada 4/9/2018 - ends
                    glead.GPO_Group__c = g.id;

                    //NAIT-21064-----Start
                    glead.PO_Number_User_Setting__c = g.PO_Number_Setup__c;
                    glead.Cost_Center_User_Setting__c = g.Cost_Center_Setup__c;
                    glead.Release_User_Setting__c = g.Release_Setup__c;
                    glead.Desktop_User_Setting__c = g.Desktop_Setup__c;
                    //NAIT-21064-------End
                    insert glead;
                    //Changes by ivarada 4/9/2018 - starts
                }



                if (executePublicFlow && g!=null) {//CReating cases for public communities
                    //Changes by ivarada 4/9/2018 - ends

                    GPO_Lead__c gpolead_rec_for_case =
                    [select Id, OwnerId,  Name, RecordTypeId, Account__c, Address1__c, Address2__c, Business_Name__c,
                     City__c, DUNS__c, Email__c, Last_Name__c, Login_Name__c, Notes__c, Phone__c, Private__c,
                     Recaptcha__c, State__c, Status__c, URL__c,
                     User_Name__c, WCW_Range__c, Zip__c, first_name__c, SU_CommuContact__c, AOPS_Cust_ID__c,
                     AOPS_Setup_Complete__c, PO_Number__c,
                     Cost_Center__c, Release__c, Desktop__c, Multiple_PO_Numbers__c, Multiple_Cost_Centers__c,
                     Multiple_Releases__c, Multiple_Desktops__c, MultipleShipTo__c, SSO_Id__c,
                     CustomCatalogCode__c, GPO_Group__c
                     from GPO_Lead__c where Login_Name__c =:glead.Login_Name__c ];

                    //NAIT-21028------CASE CREATION If any muplie soft headers are checked------------
                    if ((glead.Multiple_PO_Numbers__c == true) || (glead.Multiple_Cost_Centers__c == true) ||
                        (glead.Multiple_Releases__c == true) || (glead.Multiple_Desktops__c == true) )

                    {

                        MultipleInd_createCase(gpolead_rec_for_case, g.account__c, Userid_for_case,  'Communities - Multiple Soft Headers Request');
                    }

                    //NAIT-21037-------Case for Multiple Ship To---
                    system.debug('glead.MultipleShipTo__c:' + glead.MultipleShipTo__c);
                    if(glead.MultipleShipTo__c == true)
                        MultipleInd_createCase(gpolead_rec_for_case, g.account__c, Userid_for_case,'Communities - MultipleShipTo Address Request');
                }



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

// For Toll Brothers Template
    @remoteAction
    public static String insertUserRegistration(GPO_Lead__c newUser, String aopsID) {
        Account groupAccount = new Account();
        groupAccount = [SELECT id, aops_cust_id__c FROM Account WHERE aops_cust_id__c = :aopsID limit 1];
        newUser.Account__c = groupAccount.id;
        try {
            if(!Test.isRunningTest()) {
                insert newUser;
            }
        } catch(exception e) {
            return e.getMessage();
        }
        return 'Success';
    }

    public com2GPOCommunityLandingController() {
        system.debug('In com2controller constructor');
        commSetup = gpo_community_setup__c.getValues('com2Settings');


        privateKey = commSetup.captcha_privateKey__c;
        //  GPOTemplateUsed = true;  // Set GPO template to true, it will be flipped to false if not used
        // added by ivarada - Defaults for lead form
        successMsg = false;
        errorMsg = false;
        showForm=true;
        leadPassword = null;

        pageID = 'CommPrelogin';
        step1PageID='CommRegistration1__Next1of3';
        step2PageID='CommRegistration2__Next2of3';
        step3PageID='CommRegistration3__Next3of3';

        //NAIT-21026---21027--------
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
        DefaultMultihideGrp_PO_Num_Flag = true;
        DefaultMultihideGrp_CCenter_Flag = true;
        DefaultMultihideGrp_Release_Flag = true;
        DefaultMultihideGrp_Desktop_Flag = true;
        DefaultHideMultipleShipTo_Flag = true;//NAIT-21034
        DefaultHideSSO_Id_Flag = true;//NAIT-21040
        DefaultHideCustomCatalogCode_Flag = true;//NAIT-21040
        DefaulthideCreditCard_Flag = true;//NAIT-21075

        //added by ivarada - 4/9/2018 starts
        splOverride = false;
        //added by ivarada - 4/9/2018 ends

        setDefaults();
        showGeneric = (ApexPages.currentPage().getParameters().get('id') == null || ApexPages.currentPage().getParameters().get('id') == '');
        PageId1 =  ApexPages.currentPage().getParameters().get('Id');
        Boolean SecNotRequired  = true;
        for (GPO_Security__mdt gpoSec :
             [SELECT Account_Number__c,Key_Name__c,Key_Value__c FROM GPO_Security__mdt WHERE Account_Number__c =: PageId1]) {
            cip = ApexPages.currentPage().getHeaders().get(gpoSec.Key_Name__c);
            if (cip != gpoSec.Key_Value__c) {
                SecNotRequired = false;
            }

        }

        //Added by ivarada - 4/9/2018 - starts
        String aops =  ApexPages.currentPage().getParameters().get('a');
        if(ApexPages.currentPage().getParameters().get('a') != null && ApexPages.currentPage().getParameters().get('a') != '') {
            initDefaultGPO();
            if (SecNotRequired) {
                hideRegisterLink = false;
                splOverride = true;
            }
        }
        //Added by ivarada - 4/9/2018 ends
        else if(ApexPages.currentPage().getParameters().get('id') == null || ApexPages.currentPage().getParameters().get('id') == '' ||
                !SecNotRequired ) {
            initDefaultGPO();
        }
        else {
            Boolean gpoGroupNotFound = false;
            //  GPOId=ApexPages.currentPage().getParameters().get('id');
            // Try to find the gpo group with the account id as given. If it fails, try again with padded zeros.
            try {
                selectedGroup =
                [SELECT Id, private__c,GPO_Template__c, Selected_Message__c, aops_cust_id__c, Welcome_Title__c, hideSections__c, Community_Name__c,
                 Welcome_Message__c, Community_Image__c, Account__c,Account__r.aops_cust_id__c, LastModifiedDate,
                 inheritParentLogo__c,inheritParentFields__c,inheritParentGreetingMessage__c,inheritParentPageComponents__c,
                 inheritParentPageLinks__c,Hide_SPC_Download_Link_Prelogin__c,Hide_Register_Link__c,Account_Selection__c,
                 Restrict_Login__c,//Added by Rajendra shahane for NAIT-155579 Remove the login option from the following community pages.
                 Approver_Information_Section__c,
                 Additional_Cost_Centers__c,Additional_Addresses__c,token__c,ExpireLink__c
                 FROM GPO_Group__c WHERE Account__r.aops_cust_id__c = :PageId1 Limit 1];

                if (selectedGroup.Community_Name__c != null) {
                    pageID = 'CommPrelogin_' + selectedGroup.Community_Name__c.replaceAll( '\\s+', '');
                    step1pageID = 'CommRegistration1_' +  selectedGroup.Community_Name__c.replaceAll( '\\s+', '') + '_Next1of3';
                    step2pageID = 'CommRegistration2_' +  selectedGroup.Community_Name__c.replaceAll( '\\s+', '') + '_Next2of3';
                    step2pageID = 'CommRegistration3_' +  selectedGroup.Community_Name__c.replaceAll( '\\s+', '') + '_Next3of3';
                }
            } catch (Exception e ) {
                // If group not found, try to pad with zeroes to total eight digits and try again
                try{
                    PageId1 = PageId1.leftPad(8, '0');
                    selectedGroup =
                    [SELECT Id, private__c,GPO_Template__c, Selected_Message__c, aops_cust_id__c, Welcome_Title__c, hideSections__c,
                     Community_Name__c,
                     Welcome_Message__c, Community_Image__c, Account__c,Account__r.aops_cust_id__c, LastModifiedDate,
                     inheritParentLogo__c,inheritParentFields__c,inheritParentGreetingMessage__c,inheritParentPageComponents__c,
                     inheritParentPageLinks__c,Hide_SPC_Download_Link_Prelogin__c,Hide_Register_Link__c,Account_Selection__c,
                     Restrict_Login__c,//Added by Rajendra shahane for NAIT-155579 Remove the login option from the following community pages.
                     Approver_Information_Section__c,
                     Additional_Cost_Centers__c,Additional_Addresses__c,token__c,ExpireLink__c
                     FROM GPO_Group__c WHERE Account__r.aops_cust_id__c = :PageId1 Limit 1];
                } catch(Exception ex) {
                    //The ID passed as parameter was not found in GPO Groups
                    gpoGroupNotFound = true;
                }
            }

            //If GPO Group was not found load default GPO, else continue to load the selected GPO group based on the request parameter id
            if(gpoGroupNotFound)    {
                initDefaultGPO();
            } else { //Load GPO Group's information to use on the page
                gpoAccount = [Select id, OwnerID,cust_id__c,Name,ParentId,SPC_Allowed__c from Account where id =: selectedGroup.Account__c];
                accountOwner =
                [Select id, ISACTIVE, contactID, Name, Email, Phone, FullPhotoUrl, MobilePhone,
                 system_user__c from User where id =: gpoAccount.ownerId ];
                selectedTemplate =
                [Select id, Template_Name__c, Home_Page__c, Member_Page__c from GPO_Template__c where id =: selectedGroup.GPO_Template__c];
                usingGroup = selectedGroup;
                parentId = gpoAccount.parentId;



                //prasad


                //--NAIT-11785----------
                Account_SPC_Allowed_Flag = gpoAccount.SPC_Allowed__c;
                hideSPCdownloadLink = selectedGroup.Hide_SPC_Download_Link_Prelogin__c;
                hideRegisterLink = selectedGroup.Hide_Register_Link__c;
                hideLoginOption = selectedGroup.Restrict_Login__c;//Added by Rajendra shahane for NAIT-155579 Remove the login option from the following community pages.
                showAccountSelection = selectedGroup.Account_Selection__c;
                //   if (selectedGroup.private__c == true){
                showApproverSection = selectedGroup.Approver_Information_Section__c;
                showAdditionalCostCenters = selectedGroup.Additional_Cost_Centers__c;
                showAdditionalAddresses = selectedGroup.Additional_Addresses__c;
                //    }
                //Communities 2.2 - Inherit from Parent
                if(gpoAccount.ParentId != null) {
                    try {
                        parentGroup =
                        [SELECT id,Community_Image__c,hideSections__c,
                         Selected_Message__c FROM GPO_Group__c WHERE Account__r.Id =: gpoAccount.ParentId];
                    }
                    catch(Exception e) {
                        system.debug('PARENT GROUP NOT FOUND');
                    }
                }
                if(parentGroup != null) {
                    if(selectedGroup.inheritParentLogo__c == true) {
                        usingGroup.Community_Image__c = parentGroup.Community_Image__c;
                    }
                    if(selectedGroup.inheritParentPageComponents__c == true) {
                        usingGroup.hideSections__c = parentGroup.hideSections__c;
                    }
                    if(selectedGroup.inheritParentGreetingMessage__c == true) {
                        selectedGroup.Selected_Message__c = parentGroup.Selected_Message__c;
                    }
                }
                system.debug('usingGroup.hideSections__c        '+ usingGroup.hideSections__c);
                if(parentGroup != null && selectedGroup.inheritParentPageLinks__c == true) {
                    pageLinks =
                    [SELECT id, Name, URL_Address__c, Label__c,
                     Active__c FROM GPO_Link__c WHERE GPO_Group__c =: parentGroup.Id AND Type__c = 'Link' LIMIT 25];
                    for (GPO_Link__c link :
                         [SELECT id, Name, URL_Address__c, Label__c,
                          Active__c FROM GPO_Link__c WHERE GPO_Group__c =: selectedGroup.Id AND Type__c = 'Link' LIMIT 25]) {
                        pageLinks.add(link);
                    }
                }
                else {
                    pageLinks =
                    [SELECT id, Name, URL_Address__c, Label__c,
                     Active__c FROM GPO_Link__c WHERE GPO_Group__c =: selectedGroup.Id AND Type__c = 'Link' LIMIT 25];
                }

                // Custom Invoice and Registration Form Fields
                if(parentGroup != null && selectedGroup.inheritParentFields__c == true) {
                    usingGroup.id = ParentGroup.id;
                }

                invoiceFieldsList =
                [SELECT id, Label__c, Invoice_Form_Fields__c, Active__c,
                 Hide__c FROM GPO_Link__c WHERE GPO_Group__c =: UsingGroup.Id AND Type__c = 'Invoice Request Form Field' AND Active__c = true];
                userRegistrationFieldsList =
                [SELECT id, Label__c, User_Registration_Fields__c,
                 Active__c FROM GPO_Link__c WHERE GPO_Group__c =: UsingGroup.Id AND Type__c = 'User Registration Field' AND Active__c = true];

                //----NAIT-21026 AND NAIT-21075-------------
                InvoiceUserRegFieldsList =
                [SELECT id, Label__c, Invoice_UserReg_Fields__c,
                 Active__c FROM GPO_Link__c WHERE GPO_Group__c =: UsingGroup.Id AND Type__c = 'Invoice_UserReg_Form_Field' AND Active__c = true];

                hiddenFields =
                [SELECT Hide__c,User_Registration_Fields__c,Invoice_Form_Fields__c,
                 Invoice_UserReg_Fields__c FROM GPO_Link__c WHERE GPO_Group__c =: UsingGroup.Id AND Hide__c = true AND Active__c = true];

                //----NAIT-21026 AND NAIT-21075-------------
                for(GPO_Link__c field : InvoiceUserRegFieldsList) {

                    if (field.Invoice_UserReg_Fields__c != null && field.Label__c != null)
                        InvoiceUserRegFieldsMap.put(field.Invoice_UserReg_Fields__c, field.Label__c);

                    //Flags for hiding by defalult--NAIT-21075--
                    if(field.Invoice_UserReg_Fields__c == 'PO Number') {
                        DefaulthideGrp_PO_Num_Flag = false;
                    }
                    if(field.Invoice_UserReg_Fields__c == 'Cost Center') {
                        DefaulthideGrp_CCenter_Flag = false;
                    }
                    if(field.Invoice_UserReg_Fields__c == 'Release') {
                        DefaulthideGrp_Release_Flag = false;
                    }
                    if(field.Invoice_UserReg_Fields__c == 'Desktop') {
                        DefaulthideGrp_Desktop_Flag = false;
                    }
                }


                for(GPO_Link__c field : InvoiceFieldsList) {
                    if (field.Invoice_Form_Fields__c != null && field.Label__c != null)
                        InvoiceFieldsMap.put(field.Invoice_Form_Fields__c, field.Label__c);

                    if(field.Invoice_Form_Fields__c == 'I would prefer to pay by Credit Card')
                        DefaulthideCreditCard_Flag = false;
                }



                for(GPO_Link__c field : userRegistrationFieldsList) {
                    if (field.User_Registration_Fields__c != null && field.Label__c != null) {
                        UserRegistrationFieldsMap.put(field.User_Registration_Fields__c, field.Label__c);
                        //system.debug('field.User_Registration_Fields__c: ' + field.User_Registration_Fields__c);
                    }

                    //Flags for hiding by defalult--NAIT-21027---------
                    if(field.User_Registration_Fields__c == 'Multiple PO Numbers') {
                        DefaultMultihideGrp_PO_Num_Flag = false;
                    }
                    if(field.User_Registration_Fields__c == 'Multiple Cost Centers') {
                        DefaultMultihideGrp_CCenter_Flag = false;
                    }
                    if(field.User_Registration_Fields__c == 'Multiple Releases') {
                        DefaultMultihideGrp_Release_Flag = false;
                    }
                    if(field.User_Registration_Fields__c == 'Multiple Desktops') {
                        DefaultMultihideGrp_Desktop_Flag = false;
                    }//--NAIT-21026--------21027-----------End--------->
                    if(field.User_Registration_Fields__c == 'Multiple Ship To') {
                        DefaultHideMultipleShipTo_Flag = false;
                    }
                    if(field.User_Registration_Fields__c == 'SSO Id') {
                        DefaultHideSSO_Id_Flag = false;
                    }
                    if(field.User_Registration_Fields__c == 'Custom Catalog Code') {
                        DefaultHideCustomCatalogCode_Flag = false;
                    }


                }

                //Hide-able Fields on forms
                for(GPO_Link__c field: hiddenFields) {
                    if(field.User_Registration_Fields__c == 'Website') {
                        hideWebsite = true;
                    }
                    if(field.User_Registration_Fields__c == 'Notes') {
                        hideNotes = true;
                    }
                    if(field.User_Registration_Fields__c == 'Company Name') {
                        hideCompanyName = true;
                    }
                    if(field.User_Registration_Fields__c == 'Number of Employees') {
                        hideEmployees = true;
                    }
                    if(field.User_Registration_Fields__c == 'Multiple PO Numbers') {
                        MultihideGrp_PO_Num_Flag = true;
                    }
                    if(field.User_Registration_Fields__c == 'Multiple Cost Centers') {
                        MultihideGrp_CCenter_Flag = true;
                    }
                    if(field.User_Registration_Fields__c == 'Multiple Releases') {
                        MultihideGrp_Release_Flag = true;
                    }
                    if(field.User_Registration_Fields__c == 'Multiple Desktops') {
                        MultihideGrp_Desktop_Flag = true;
                    }
                    if(field.User_Registration_Fields__c == 'Multiple Ship To') {
                        hideMultipleShipTo_Flag = true;
                    }
                    if(field.User_Registration_Fields__c == 'SSO Id') {
                        hideSSO_Id_Flag = true;
                    }
                    if(field.User_Registration_Fields__c == 'Custom Catalog Code') {
                        hideCustomCatalogCode_Flag = true;
                    }


                    if(field.Invoice_Form_Fields__c == 'Business Extension') {
                        hideExtension = true;
                    }
                    if(field.Invoice_Form_Fields__c == 'I would prefer to pay by Credit Card') {
                        hideCreditCard_Flag = true;
                    }
                    //--NAIT-21075------------sTART--------->
                    if(field.Invoice_UserReg_Fields__c == 'PO Number') {
                        hideGrp_PO_Num_Flag = true;
                    }
                    if(field.Invoice_UserReg_Fields__c == 'Cost Center') {
                        hideGrp_CCenter_Flag = true;
                    }
                    if(field.Invoice_UserReg_Fields__c == 'Release') {
                        hideGrp_Release_Flag = true;
                    }
                    if(field.Invoice_UserReg_Fields__c == 'Desktop') {
                        hideGrp_Desktop_Flag = true;
                    }

                }

                //--NAIT-21026--------21027----------------->
                initDefaultSoftHeaders(usingGroup.Id);

                //NAIT-21040-------------
                GPO_Group__c grp_cccode =
                [SELECT Id, Custom_Catalog_Code__c, Allow_Ship_To_Address_Selection__c from GPO_Group__c where id =:UsingGroup.Id limit 1];
                if(grp_cccode.Custom_Catalog_Code__c == null) {
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
                if((hideGrp_PO_Num_Flag == false && DefaulthideGrp_PO_Num_Flag == true) ||
                   (hideGrp_PO_Num_Flag == true && DefaulthideGrp_PO_Num_Flag == false))
                    MultihideGrp_PO_Num_Flag = true;
                if((hideGrp_CCenter_Flag == false && DefaulthideGrp_CCenter_Flag == true) ||
                   (hideGrp_CCenter_Flag == true && DefaulthideGrp_CCenter_Flag == false))
                    MultihideGrp_CCenter_Flag = true;
                if((hideGrp_Release_Flag == false && DefaulthideGrp_Release_Flag == true)  ||
                   (hideGrp_Release_Flag == true && DefaulthideGrp_Release_Flag == false))
                    MultihideGrp_Release_Flag = true;
                if((hideGrp_Desktop_Flag == false && DefaulthideGrp_Desktop_Flag == true)  ||
                   (hideGrp_Desktop_Flag == true && DefaulthideGrp_Desktop_Flag == false))
                    MultihideGrp_Desktop_Flag = true;

            }
        }
        getElements(); //for multipicklist feature


    }

// Load the default GPO.  Either an id was not provided or the ID did not map to an existing GPO_Group
    private void initDefaultGPO() {
        showGeneric = true;
        String defaultTemplateID = commSetup.defaultTemplate__c;

        //Load default GPO Group
        selectedGroup =
        [SELECT id,private__c,Community_Image__c, Welcome_Message__c, Selected_Message__c, Welcome_Title__c, LastModifiedDate, Community_Name__c,
         hideSections__c from GPO_Group__c where Community_Name__c = 'Default Group' LIMIT 1];

        //Load template spefified in GPO Group
        selectedTemplate = [Select id, Template_Name__c, Home_Page__c, Member_Page__c from GPO_Template__c where Name = 'Communities v2' LIMIT 1];
        gpoAccount = new Account();
        accountOwner = new User();


    }

    //--NAIT-21026-------------------sTART--------->
    private void initDefaultSoftHeaders(id grpid_found_for_softheaders) {

        //-------------------------------Start of SH Setting flags-----------------
        GPO_Group__c Grp_SH_Setting =
        [SELECT Id, PO_Number_Setup__c, Cost_Center_Setup__c, Release_Setup__c,
         Desktop_Setup__c from GPO_Group__c where id =:grpid_found_for_softheaders limit 1];

        if( Grp_SH_Setting.PO_Number_Setup__c == 'S (--Select Any---)') {
            system.debug('PO_Number_Setup__c:' + Grp_SH_Setting.PO_Number_Setup__c);
            Grp_PO_Num_Setting = true;
        }
        else if( Grp_SH_Setting.PO_Number_Setup__c == 'D (--Default Only---)')
            Grp_PO_Num_Setting = false;
        //-------------------

        if( Grp_SH_Setting.Cost_Center_Setup__c == 'S (--Select Any---)') {
            system.debug('Cost_Center_Setup__c:' + Grp_SH_Setting.Cost_Center_Setup__c);
            Grp_CCenter_Setting = true;
        }
        else if( Grp_SH_Setting.Cost_Center_Setup__c == 'D (--Default Only---)')
            Grp_CCenter_Setting = false;
        //-------------------
        if( Grp_SH_Setting.Release_Setup__c == 'S (--Select Any---)') {
            system.debug('Release_Setup__c:' + Grp_SH_Setting.Release_Setup__c);
            Grp_Release_Setting = true;
        }
        else if( Grp_SH_Setting.Release_Setup__c == 'D (--Default Only---)')
            Grp_Release_Setting = false;
        //-------------------
        if( Grp_SH_Setting.Desktop_Setup__c == 'S (--Select Any---)') {
            system.debug('Grp_Desktop_Setting:' + Grp_SH_Setting.Desktop_Setup__c);
            Grp_Desktop_Setting = true;
        }
        else if( Grp_SH_Setting.Desktop_Setup__c == 'D (--Default Only---)')
            Grp_Desktop_Setting = false;
        //-----------------------------------end of SH Setting flags-----------------

        //--NAIT-21026-------------------sTART--------->

        Grp_PO_Num =
        [SELECT SoftHeader_Value__c from GPO_Soft_Headers__c where GPO_Group__c =:grpid_found_for_softheaders and SoftHeader_Type__c =
             'PO Number' order by SoftHeader_Value__c asc];

        Grp_PO_Num_str_list = new List<SelectOption>();
        //Grp_PO_Num_str_list.add(new SelectOption('','None'));

        if (Grp_PO_Num.size() > 0) {
            system.debug('defaultGrp_PO_Num:' + Grp_PO_Num.size());
            Grp_PO_Num_Flag = true;

            for(GPO_Soft_Headers__c sh:Grp_PO_Num)
            {

                Grp_PO_Num_str_list.add(new SelectOption('',sh.SoftHeader_Value__c));
                system.debug('PO_Number_Values__c:' + sh.SoftHeader_Value__c);
            }
            system.debug('Grp_PO_Num_str_list.size():' + Grp_PO_Num_str_list.size());
        }
        else
            Grp_PO_Num_Flag = false;


        //-----------------------------------
        Grp_CCenter =
        [SELECT SoftHeader_Value__c from GPO_Soft_Headers__c where GPO_Group__c =: grpid_found_for_softheaders and SoftHeader_Type__c =
             'Cost Center' order by SoftHeader_Value__c asc];
        Grp_CCenter_str_list = new List<SelectOption>();
        //Grp_CCenter_str_list.add(new SelectOption('','None'));

        if (Grp_CCenter.size() > 0) {
            system.debug('defaultGrp_CCenter:' + Grp_CCenter.size());
            Grp_CCenter_Flag = true;

            for(GPO_Soft_Headers__c sh:Grp_CCenter)
            {

                Grp_CCenter_str_list.add(new SelectOption('',sh.SoftHeader_Value__c));
                system.debug('Cost_Center_Values__c:' + sh.SoftHeader_Value__c);
            }
            system.debug('Grp_CCenter_str_list.size():' + Grp_CCenter_str_list.size());
        }
        else
            Grp_CCenter_Flag = false;

        /*if(Grp_CCenter_Setting == false && Grp_CCenter_Flag == false && hideGrp_CCenter_Flag == false){
            Grp_CCenter_str_list = new List<SelectOption>();
            Grp_CCenter_str_list.add(new SelectOption('','-None-'));
            system.debug('All 3 CC flags are false:' + Grp_CCenter_str_list.size()) ;
           }*/
        //------------------------------
        Grp_Release =
        [SELECT SoftHeader_Value__c from GPO_Soft_Headers__c where GPO_Group__c =: grpid_found_for_softheaders and SoftHeader_Type__c =
             'Release' order by SoftHeader_Value__c asc];

        Grp_Release_str_list = new List<SelectOption>();
        //Grp_Release_str_list.add(new SelectOption('','None'));

        if (Grp_Release.size() > 0) {
            system.debug('defaultGrp_Release:' + Grp_Release.size());
            Grp_Release_Flag = true;

            for(GPO_Soft_Headers__c sh:Grp_Release)
            {

                Grp_Release_str_list.add(new SelectOption('',sh.SoftHeader_Value__c));
                system.debug('Release_Values__c:' + sh.SoftHeader_Value__c);
            }
            system.debug('Grp_Release_str_list.size():' + Grp_Release_str_list.size());
        }
        else
            Grp_Release_Flag = false;

        /*if(Grp_Release_Setting == false && Grp_Release_Flag == false && hideGrp_Release_Flag == false){
            Grp_Release_str_list = new List<SelectOption>();
            Grp_Release_str_list.add(new SelectOption('','-None-'));
            system.debug('All 3 Release flags are false:' + Grp_Release_str_list.size()) ;
           }*/

        //--------------------------

        Grp_Desktop =
        [SELECT SoftHeader_Value__c from GPO_Soft_Headers__c where GPO_Group__c =: grpid_found_for_softheaders and SoftHeader_Type__c =
             'Desktop' order by SoftHeader_Value__c asc];

        Grp_Desktop_str_list = new List<SelectOption>();
        //Grp_Desktop_str_list.add(new SelectOption('','None'));

        if (Grp_Desktop.size() > 0) {
            system.debug('defaultGrp_Desktop:' + Grp_Desktop.size());
            Grp_Desktop_Flag = true;

            for(GPO_Soft_Headers__c sh:Grp_Desktop)
            {

                Grp_Desktop_str_list.add(new SelectOption('',sh.SoftHeader_Value__c));
                system.debug('Desktop_Values__c:' + sh.SoftHeader_Value__c);
            }
            system.debug('Grp_Desktop_str_list.size():' + Grp_Desktop_str_list.size());
        }
        else
            Grp_Desktop_Flag = false;

        /*if(Grp_Desktop_Setting == false && Grp_Desktop_Flag == false && hideGrp_Desktop_Flag == false){
            Grp_Desktop_str_list = new List<SelectOption>();
            Grp_Desktop_str_list.add(new SelectOption('','-None-'));
            system.debug('All 3 Desktop flags are false:' + Grp_Desktop_str_list.size()) ;
           }*/

        //--NAIT-21026-------------------End--------->

    }

    // Legacy code used in the OLD Template
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
}