/* This is the controller for the VP Configuration tab */


public with sharing class VP_Configuration{
	

        /*Members*/
        //private final transient VP_Configuration_Settings__c Config {get; private set;}
        private VP_Configuration__c Config {get; private set;}
        public VP_Web_Services_Configure.OrgConfig RemoteConfig {get; set;}
        public string View {get; private set;}
        public string Mode {get; set;}
        
        public string ViewpathUrl {get; private set;}
        public string ViewpathEndpoint {get; private set;}
        
        public integer ViewpathAppEngineVersion {
	    	get {
	    		return VP_Utils.APP_NUMBER;
	    	}
    	}
    
        public boolean ApiAuthorized {
            get {
                if (Config != null) {
                    return Config.ApiAuthorized__c;
                } else {
                    return false;
                }
            }
        }
        public boolean IsApexTest = false;
        public string OrganizationId {get; set;}
        public string OrganizationName {get; set;}
        public String OrganizationCountry { get; set; }
        public string AdministratorName {get; set;}
        public string AdministratorEmail {get; set;}
        public string AdministratorPhone {get; set;}
        public boolean chatterEnabled {get {return true; } set; }
        public string ChatterNotificationsDestination {get; set;}
        
        /*End Members*/
                
        /*Getter/Setter*/
        public string getOrganizationId(){
              return UserInfo.getOrganizationId();
        }
        /*End Getter/Setter*/
                
        /*Constructor*/
        public VP_Configuration() {
                
            //set debug vars
            ViewpathUrl = VP_Utils.ViewpathUrl;
            ViewpathEndpoint = VP_Utils.ViewpathApiEndpoint;
            
            //Setup debug mode
            if (ApexPages.CurrentPage().getParameters().get('mode') != null) { 
                mode = EncodingUtil.urlEncode(ApexPages.CurrentPage().getParameters().get('mode'), 'UTF-8');  // Oct 2013: Security Change to prevent XSS
            }
                    
            //Get the Config
            if (VP_Utils.getVPConfig() != null) {
                Config = VP_Utils.getVPConfig();
            } else {
                Config = null;
            }
                
            //If API Authorized, grab the remote config from Viewpath, for chatter settings
            //GetRemoteConfig();
 
 			// Only load the ORG stuff if an Admin, else an error to the non-admin
			if (VP_Utils.IsCurrentUserSysAdmin())
			{
	            //Get the rest of the user/org info
	            OrganizationId = UserInfo.GetOrganizationId();
	            OrganizationName = UserInfo.GetOrganizationName();
	            OrganizationCountry = VP_Utils.GetOrganization().Country;
	            AdministratorName = UserInfo.GetName();
	            AdministratorEmail = VP_Utils.GetEmail();
	            AdministratorPhone = VP_Utils.GetPhone();
 			}
 				            
	        ChatterNotificationsDestination = 'GROUP';

            //Set View; which Blocks out everyone but admin
            SetView();
        }
        /*End Constructor*/
        
        public void initialize(){
            if (Config != null) {
                if(Config.ApiAuthorized__c == true && RemoteConfig == null) {
                    GetRemoteConfig();
                } 
            }
        }
        
        /*Public Methods*/
        //Check to see if activation is complete. This can be faked by an admin setting these fields by hand, but
        //this will only cause an error on the API calls. Suckas!
        public boolean ActivationComplete(){
        Config = VP_Utils.getVPConfig();
            if (Config != null) {
                if (Config.ApiKey_Encrypted__c != null && Config.ApiUsername__c != null){
                        return true;
                }
            }
            return false;
        }
        
        
        public PageReference UpdateOrgConfig(){
            VP_Web_Services_Configure.ApiCredentials apiCredentials;
            VP_Web_Services_Configure.ConfigureSoap stub = new VP_Web_Services_Configure.ConfigureSoap();
            stub.IsApexTest = IsApexTest;
            VP_Web_Services_Configure.AuthHeader AuthHeader = new VP_Web_Services_Configure.AuthHeader();
            AuthHeader.DevKey = VP_Utils.getEncryptedDevKey();
           
            if (config != null) {
                AuthHeader.apiUsername = VP_Utils.decrypt(VP_Utils.getSFEncryptionKey(), EncodingUtil.base64Decode(config.ApiUsername__c));
                AuthHeader.apiPassword = VP_Utils.decrypt(VP_Utils.getSFEncryptionKey(), EncodingUtil.base64Decode(config.ApiKey_Encrypted__c));
            } else {
                AuthHeader.apiUsername = 'TestUsername';
                AuthHeader.apiPassword = 'TestPass';
            }
            stub.AuthHeader = AuthHeader;
            try{
                stub.UpdateOrgConfig(RemoteConfig); //Stub now returns an org config on update to prevent an additional call. w00t!
                Config.ChatterEnabled__c = RemoteConfig.ChatterEnabled;
                update(Config);
            } catch(exception e) {
            
            }
            return ApexPages.currentPage();
        }
        
        public void GetRemoteConfig() {
            VP_Web_Services_Configure.ApiCredentials apiCredentials;
            VP_Web_Services_Configure.ConfigureSoap stub = new VP_Web_Services_Configure.ConfigureSoap();
            stub.IsApexTest = IsApexTest;
            VP_Web_Services_Configure.AuthHeader AuthHeader = new VP_Web_Services_Configure.AuthHeader();

            //Define auth header
            AuthHeader.DevKey = VP_Utils.getEncryptedDevKey();
           
            try {
                if (config != null) {
                    AuthHeader.apiUsername = VP_Utils.decrypt(VP_Utils.getSFEncryptionKey(), EncodingUtil.base64Decode(config.ApiUsername__c));
                    AuthHeader.apiPassword = VP_Utils.decrypt(VP_Utils.getSFEncryptionKey(), EncodingUtil.base64Decode(config.ApiKey_Encrypted__c));
                } else {
                    AuthHeader.apiUsername = 'TestUsername';
                    AuthHeader.apiPassword = 'TestPass';
                }
                
                stub.AuthHeader = AuthHeader;
                
                RemoteConfig = stub.GetOrgConfig();
                Config.ChatterEnabled__c = RemoteConfig.ChatterEnabled;
                update(Config);
            }
            catch (exception ex)
            {
            
            }
            //RemoteConfig = new VP_Web_Services_Configure.OrgConfig();
            //RemoteConfig.OrgId = '123456';
            //RemoteConfig.ChatterEnabled = false;
            //RemoteConfig.NotificationDestination = 'BOTH';
        }
        
        public PageReference Activate() {
            //Setup web services
            Config = VP_Utils.getVPConfig();
            if (Config == null) {
                Config = new VP_Configuration__c();
            }
            
            VP_Web_Services_Configure.ApiCredentials apiCredentials;
            VP_Web_Services_Configure.ConfigureSoap stub = new VP_Web_Services_Configure.ConfigureSoap();
            stub.IsApexTest = IsApexTest;
            VP_Web_Services_Configure.AuthHeader AuthHeader = new VP_Web_Services_Configure.AuthHeader();

            /*Send Encrypted dev key; no point in encrypting for now, but it paves the way*/
            AuthHeader.DevKey = VP_Utils.getEncryptedDevKey();
            
            //Define auth header
            stub.AuthHeader = AuthHeader;
            
            system.debug('obsolete' + OrganizationId + OrganizationName + OrganizationCountry + AdministratorName + AdministratorEmail + AdministratorPhone);
            if (!isApexTest) {
                apiCredentials = stub.ActivateAccount('obsolete',OrganizationId,OrganizationName,OrganizationCountry,AdministratorName,AdministratorEmail,AdministratorPhone);
            } else {
                apiCredentials = new VP_Web_Services_Configure.ApiCredentials();
                apiCredentials.apiUsername = 'test';
                apiCredentials.apiKey= 'test';
            }
        
            //Get the APIKey and Username from the response, decrypt them, then store them
            blob apiKey = VP_Utils.encrypt(VP_Utils.getSFEncryptionKey(),apiCredentials.apiKey);
            blob apiUsername = VP_Utils.encrypt(VP_Utils.getSFEncryptionKey(),apiCredentials.apiUsername);       
            Config.ApiKey_Encrypted__c = EncodingUtil.base64Encode(apiKey); //'TempKey';
            Config.ApiUsername__c = EncodingUtil.base64Encode(apiUsername);//'TempName';
           
            //Save config settings
            Upsert(Config);

            SetView();
            return ApexPages.currentPage();
        }
        
        public PageReference Deactivate() {
            Config = VP_Utils.getVPConfig();
            if (Config != null) {
                Delete(Config);
            }
            SetView('activate');
            return ApexPages.currentPage();
        }
    
        public List<SelectOption> getChatterOptions_Destination() {
            List<SelectOption> options = new List<SelectOption>();
            options.add(new SelectOption('Group','Group'));
            options.add(new SelectOption('Project','Project'));
            options.add(new SelectOption('Both','Both (This will cause redundant notifications)'));
            return options;
        }
        
        public List<SelectOption> getChatterOptions_Enabled() {
            List<SelectOption> options = new List<SelectOption>();
            options.add(new SelectOption('true','Group'));
            return options;
        }

        public List<SelectOption> getChatterOptions_ToggleFilter() {
            List<SelectOption> options = new List<SelectOption>();
            options.add(new SelectOption('false','Show all notifications'));
            options.add(new SelectOption('true','Filter changes by:'));
            return options;
        }
        
        /*End Public Methods*/
        
        /*Private Methods*/     
        private void SetView(string v){
            View = v;
        }
        
        private void SetView(){
            if ((!VP_Utils.IsCurrentUserSysAdmin()) && Mode != 'activate') {
                View = 'unauthorized';
            } else {
                if (ActivationComplete()) {
                    View = 'configure';
                } else {
                    View = 'activate';
                }
            }
        }
        /*End Private Methods*/



    /*  **** TEST METHODS BEGIN *****  */
     
    public static testMethod void testViewpathConfigure(){
    	
    	system.debug(' TEST> testViewpathConfigure begins:');
    	    	
        // Set the static variable IsApexTestMode, required to prevent API calls in tests, must do before any of the Extension controllers are created.
        //VP_Utils.IsApexTestMode = true; 
    	
        PageReference p = Page.VP_Configuration;
        Test.setCurrentPage(p);
        
        
        VP_Configuration vpc = new VP_Configuration();
        vpc.isApexTest = true;
        vpc.initialize();
        
        vpc.OrganizationId = '123456';
        vpc.OrganizationName = 'TestOrg';
        vpc.OrganizationCountry = 'US';
        vpc.AdministratorName = 'Admin Name';
        vpc.AdministratorEmail = 'Admin@email.com';
        vpc.AdministratorPhone = '253-632-7823';
        
        string orgid = vpc.getOrganizationId();
        boolean authorized = vpc.ApiAuthorized;
        
        vpc.Activate();
        vpc.Deactivate();
        
        vpc.UpdateOrgConfig();
        vpc.GetRemoteConfig();
        
        List<SelectOption> lst = vpc.getChatterOptions_ToggleFilter();
        
        vpc.getChatterOptions_Destination();
        vpc.getChatterOptions_Enabled();
        
        //system.Assert(config.size() > 0, 'Config object not created');

        system.Assert(p != null);
        
        system.debug('TEST> testViewpathConfigure ends');
        
    }

}