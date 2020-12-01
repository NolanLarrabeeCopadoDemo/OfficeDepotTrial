/* this is the controller for the Application Launch from Project page 1/12/13 */


public with sharing class VP_Launch_Application{

    public void VP_Launch_Application(){
        
    }

    protected string QueryString = '';
    protected Blob cryptoKey;// = Blob.valueOf('12345678901234567890123456789012');  
    protected Blob iv;// = Blob.valueOf('1234567890123456');
    protected Blob emailBytes;// = Blob.valueOf(email);
    protected Blob keyBytes;// = Blob.valueOf(developerKey);

    public PageReference RedirectToApp(){
        string email = [select Email from User where id = :UserInfo.getUserId()].Email;
        string developerKey = 'dev_key'; 
        
        cryptoKey = Blob.valueOf('12345678901234567890123456789012');    // Fix these 
        iv = Blob.valueOf('1234567890123456');                           // Fix these - match is in BL - AESCrypto.cs
        emailBytes = Blob.valueOf(email);
        keyBytes = Blob.valueOf(developerKey);
        

        string firstName = UserInfo.getFirstName();
        string lastName = UserInfo.getLastName();
        string orgName = UserInfo.getOrganizationName();
        string orgId = UserInfo.getOrganizationId();
        string userType = UserInfo.getUserType();
        string userId = UserInfo.getUserId();
        
        Blob bFirstName = bEncrypt(firstName);
        Blob bLastName = bEncrypt(lastName);
        Blob bOrgName = bEncrypt(orgName);
        Blob bOrgId = bEncrypt(orgId);
        Blob bUserType = bEncrypt(userType);
        Blob bEmail = bEncrypt(email);        
        Blob bDevkey = bEncrypt(developerKey);
        Blob bUserId = bEncrypt(userId);
        
        buildQueryString('fn',bFirstName);
        buildQueryString('ln',bLastName);
        buildQueryString('cn',bOrgName);
        buildQueryString('oid',bOrgId);
        buildQueryString('ut',bUserType);
        buildQueryString('dk',bDevKey);
        buildQueryString('e',bEmail);
        buildQueryString('sfuid',bUserId);
        
        finishQueryString();

        //add in project id        
        string projectId = ApexPages.currentPage().getParameters().get('ProjectId');
    
        if (projectId != null && projectId != '')
            QueryString = QueryString + '&p='+projectId;
                    
        system.debug('Redirecting to app');
        
        Blob encryptedEmail = Crypto.encrypt('AES256', cryptoKey, iv, emailBytes);
        Blob encryptedKey = Crypto.encrypt('AES256', cryptoKey, iv, keyBytes);

        string urlEmail = EncodingUtil.urlEncode(EncodingUtil.base64Encode(encryptedEmail), 'UTF-8');
        string urlKey = EncodingUtil.urlEncode(EncodingUtil.base64Encode(encryptedKey), 'UTF-8');

        //PageReference V3App = new PageReference('http://localhost:3652/SFAppEx/Service/LaunchApplication.aspx?e='+urlEmail+'&p='+projectId+'&dk='+urlKey);
        //PageReference V3App = new PageReference('https://dev3.viewpaths.com/Partners/SFAppEx/Service/LaunchApplication.aspx?e='+urlEmail+'&p='+projectId+'&dk='+urlKey);
        //PageReference V3App = new PageReference('https://staging3.viewpaths.com/Partners/SFAppEx/Service/LaunchApplication.aspx?e='+urlEmail+'&p='+projectId+'&dk='+urlKey);
        //PageReference V3App = new PageReference('https://members.viewpath.com/Partners/SFAppEx/Service/LaunchApplication.aspx?e='+urlEmail+'&p='+projectId+'&dk='+urlKey);

        string url = VP_Utils.ViewpathUrl + 'Partners/SFAppEx/Service/LaunchApplication.aspx';
        system.debug('Final Querystring::'+QueryString);
        
        PageReference V3App = new PageReference(url+QueryString);
        
        V3App.setRedirect(true);
        return V3App;
    }
    
    private Blob bEncrypt(string s) {
        if (s == null || s == '') { 
            return null;
        } else {
            return Crypto.encrypt('AES256', cryptoKey, iv, Blob.valueOf(s));
        }
    }

    private void buildQueryString(string k, Blob v){
        if (v != null) {
            QueryString = QueryString + '&' + k + '=' + EncodingUtil.urlEncode(EncodingUtil.base64Encode(v), 'UTF-8');
            system.debug('building::'+QueryString);
        }
    }
    
    private void finishQueryString(){
        if (QueryString.startsWith('&')){
            QueryString = QueryString.subString(1);
        }
        QueryString = '?' + QueryString;
        system.debug('finished::'+QueryString);
    }


    
   
    
    /*  **** TEST METHODS BEGIN *****  */

    public static testMethod void testLaunchApplication(){
    	
    	system.debug(' TEST> testLaunchApplication begins:');
    	
		// Set the static variable IsApexTestMode, required to prevent API calls in tests, must do before any of the Extension controllers are created.
        //VP_Utils.IsApexTestMode = true; 
        
        VP_Launch_Application la = new VP_Launch_Application();
        PageReference p = la.RedirectToApp();
        System.Assert(p!=null);
        
        // test for null on invalid blop
        Blob b = la.bEncrypt('');
        
    }
    


}