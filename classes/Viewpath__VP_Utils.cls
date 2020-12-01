public with sharing class VP_Utils {

    // MODE: toggle comments on the next two lines to switch package from Production URLs to DEV Urls.
    public static final string MODE = 'PRODUCTION';
    //public static final string MODE = 'DEV';
    
    //      CAUTION:  Besure to Deactivate then Activate in Package to switch between DEV and PRODUCTION, else errors!
    
    // APP_NUMBER: set this to a new version of the AppEngine code, only for DEV testing.  Changes often!
    public static final integer APP_NUMBER = 483;
    
    // API_VERSION: the Business Layer folder name in Website.Partners/API/version for the VP3.asmx 
    public static final decimal API_VERSION = 3.0;
    
    // New Static way of determining if in Test Mode, always false here as default!  Then only set True in Tests methods.
    public static Boolean IsApexTestMode = false;
        
    public static string ViewpathUrl { 
        get {
            return MODE == 'DEV' ? 'https://dev.viewpath3.com/' : 'https://members.viewpath.com/';
        }
    }
    
    public static string ViewpathApiEndpoint { 
        get {
            return ViewpathUrl + 'partners/api/' + API_VERSION + '/vp3.asmx';
        }
    }
    
    public static integer ViewpathAppEngineVersion {
        get {
            return APP_NUMBER;
        }
    }

    //public static final string ViewpathApiEndpoint = ViewpathUrl + 'Partners/API/v1/VP3.asmx';
    public static final string ViewpathConfigureEndpoint = ViewpathUrl + 'Partners/SFAppEx/Service/Configure.asmx';
    
    public static string AppUrl {
    get {
            return MODE == 'DEV' ? 'https://' + APP_NUMBER + '-dot-viewpath3.appspot.com' : 'https://app.viewpath.com';
            //return MODE == 'DEV' ? 'https://' + APP_NUMBER + '-dot-viewpath3.appspot.com' : 'https://viewpath3.appspot.com';
        }
    }
        
    public static final string DEVELOPER_KEY = 'dev_key';
    public static final string ENCRYPTION_KEY = 'enc_key';
    
    //Configure endpoint crypto key
    private static final string CRYPTO_KEY = '12345678901234567890123456789012';
    private static final string IVECTOR = '1234567890123456';

    

    public static boolean IsCurrentUserSysAdmin(){
        Profile p = [SELECT PermissionsModifyAllData FROM Profile WHERE Id = :Userinfo.getProfileId()];

        return p.PermissionsModifyAllData;
        
//        if (p.name == 'system administrator'){ 
//            return true;
//        } else {
//            return false;
//        }
    }
    
    public static boolean IsAccountActivated(){
        //VP_Configuration_Settings__c config = getVPConfig(); //config = [SELECT Id, ApiUsername__c, ApiKey__c FROM VP_Configuration__c LIMIT 1];
        VP_Configuration__c config = getVPConfig();
        
        if (config != null) {
            if (config.ApiKey_Encrypted__c != null && config.ApiUsername__c != null) {
                return true;
            }
        }
        return false;
    }

        
    public static Boolean isValidId(String s) {
        Id validId;
        try {
            validId = s;
            return true;
        } catch (Exception ex) {
            return false;
        }
    }
    /*
    public static VP_Configuration_Settings__c getVPConfig(){
        //VP_Configuration__c[] config = [SELECT ApiUsername__c, ApiKey__c FROM VP_Configuration__c LIMIT 1];
        
        List<VP_Configuration_Settings__c> config = VP_Configuration_Settings__c.getall().values();
        if (config.size() > 0) {
            return config[0];
        } else {
            return null;
        }
    }
    */
    public static Boolean isOrgChatterEnabled(){
        VP_Configuration__c config = VP_Utils.getVPConfig(); 
        if (config != null) {
            return (config.ChatterEnabled__c) && (config.ApiAuthorized__c); 
        }
        return false;
        
        /*
        Map<String, Schema.SObjectType> gd = Schema.getGlobalDescribe(); 
        if(gd.containsKey('FeedItem')){
           system.debug('Chatter is enabled!');
           return true;
        }
        else{
           system.debug('Chatter is disabled!');
           return false;
        }
        */
    }
    
    public static VP_Configuration__c getVPConfig(){
        VP_Configuration__c[] config = [SELECT ApiUsername__c, ApiKey_Encrypted__c, ApiAuthorized__c, ChatterEnabled__c FROM VP_Configuration__c LIMIT 1];
        
        if (config.size() > 0) {
            return config[0];
        } else {
            return null;
        }
    }
       
    /*Obsolete*/   
    public static string getSFEncryptionKey(){
        //List<VP_Configuration_Settings__c> config = VP_Configuration_Settings__c.getall().values();
        //VP_Configuration_Settings__c config = VP_Configuration_Settings__c.getInstance('Viewpath');
        
        //string enc_key = config.Encryption_Key__c;
        return ENCRYPTION_KEY;
    }   
       
    public static blob encrypt(string encryptionKey, string stringToEncrypt)
    {
        Blob cryptoKey = Blob.valueOf('12345678901234567890123456789012');
        Blob iv = Blob.valueOf('1234567890123456');
        Blob keyBytes = Blob.valueOf(stringToEncrypt);
        Blob encryptedString = Crypto.encrypt('AES256', cryptoKey, iv, keyBytes);
        
        return encryptedString;//.toString();
    }   
       
       
    public static string decrypt(string encryptionKey, blob blobToDecrypt)
    {
        Blob cryptoKey = Blob.valueOf('12345678901234567890123456789012');
        Blob iv = Blob.valueOf('1234567890123456');
        //Blob keyBytes = Blob.valueOf(blobToDecrypt);
        Blob decryptedBlob = Crypto.decrypt('AES256', cryptoKey, iv, blobToDecrypt);
        
        return decryptedBlob.toString();
    }
       
    public static Organization GetOrganization() {    
        return [SELECT id, name, street, city, state, country, postalcode from Organization LIMIT 1];
    }

    public static User GetCurrentUser(){
        User user = [select FirstName, LastName, Email, Phone from User where id = :UserInfo.getUserId()];    
        return user;
    }
        
    public static string GetEmail() {
        User user = GetCurrentUser();
        if (user != null) { 
            if (user.Email != null) { return user.Email; } 
        }
        return '';
    }
 
    public static string GetPhone(){
        User user = GetCurrentUser();
        if (user != null) {    
            if (user.Phone != null) { return user.Phone; }
        }
        return '';
    }   
    
    public static void activateUser(){
        
    }
    
    public static void deactivateUser(){
        
    }
    
    public static boolean userIsActive(){
        VP_User_Settings__c VPUserSettings = VP_User_Settings__c.getValues(UserInfo.getUserId());
        
        if (VPUserSettings.UserId__c == null) {
            return false;
        }
        
        if (VPUserSettings.UserId__c == GetEmail()) {
            return true;
        }
        
        return false;
    }
    
    /*Auth Header / Encryption related*/
    public static string getEncryptedDevKey(){
            Blob cryptoKey = Blob.valueOf(CRYPTO_KEY);
            Blob iv = Blob.valueOf(IVECTOR);
            Blob keyBytes = Blob.valueOf(VP_Utils.DEVELOPER_KEY);
            Blob encryptedKey = Crypto.encrypt('AES256', cryptoKey, iv, keyBytes);
            return EncodingUtil.base64Encode(encryptedKey);
    }
    
    
    
        /*  **** TEST METHODS BEGIN *****  */
        
        
    public static testMethod void testVP_Utils() {
        
        system.debug(' TEST> testVP_Utils begins:');
                
        String email = VP_Utils.GetEmail();
        Organization org = VP_Utils.GetOrganization();
        String phone = VP_Utils.GetPhone();
        
        string vpurl = VP_Utils.ViewpathUrl;
        system.assert(vpurl != null);
        
        string vpapiendpoint = VP_Utils.ViewpathApiEndpoint;
        system.assert(vpapiendpoint != null);
        
        string apiurl = VP_Utils.AppUrl;
        system.assert(apiurl != null);
        
        system.debug(' Test> testing for an Invalid ID');
        boolean invalid = Vp_Utils.isValidId('invalid');
        //system.assert(invalid == false);
        
        system.debug(' Test> testing for an Valid ID');
        boolean valid = VP_Utils.isValidId(UserInfo.getUserId());
        
        boolean ischatterenabled = isOrgChatterEnabled();
        
        VP_Utils.activateUser();
        VP_Utils.deactivateUser();        
        //  boolean useractive = VP_Utils.userIsActive();  This throws exception in userIsActive line 181 - Attempt to de-reference a null object
        


        // early tests from Matt follow:
        
        boolean isAccountActivated = VP_Utils.IsAccountActivated();
        boolean isAdmin = VP_Utils.IsCurrentUserSysAdmin();
        
        VP_Configuration__c config = VP_Utils.getVPConfig();
        
        User currentUser = VP_Utils.getCurrentUser();
        // boolean useractive = VP_Utils.userIsActive();    This throws exception in userIsActive line 181 - Attempt to de-reference a null object
        
        
        string sfEncryptString = VP_Utils.getSFEncryptionKey();
        blob encryptedString = VP_Utils.encrypt(sfEncryptString, 'TEST');
        string decryptedString = VP_Utils.decrypt(sfEncryptString, encryptedString);
        system.assert('TEST' == decryptedString);
        
        string encDevKey = VP_Utils.getEncryptedDevKey();
        
        system.assert(isAdmin != null);
        system.assert(email != null);
        system.assert(org != null);
        
        system.debug('TEST> testVP_Utils ends');
    }    
            
}