global class SpringCMHelperUAT {
 
@future(callout=true)
WebService static void StartWorkflow(string wfName, string ssoUrl, string apiKey, string accountId, string sfId, string sfType, string sessionid)
{
    User currentUser = [Select email from User where Id = : UserInfo.getUserId()];
    String userSessionID = sessionid;  
    SpringCMEos.SpringCMUtilities.EOSObject retObj = SpringCMEos.SpringCMUtilities.createEOSObject(sfId, sfType);
     
    string xml = '<eos><id>' + retObj.getSfId() + '</id><sfType>Salesforce.' + retObj.getSfType() + '</sfType><name>' +retObj.getFoldername() +  '</name><path>' + (retObj.getPath()).escapeXml() + '</path></eos>';
    System.debug('XML>>:'+xml);
   /*System.debug('SessionID>>:'+userSessionID);
    System.debug('currentUser.email>>:'+currentUser.email);
    System.debug('ssoUrl>>:'+ssoUrl);
    System.debug('apiKey>>:'+apiKey);
    System.debug('accountId>>:'+accountId);*/

    SpringCMWebServices.SpringCMServiceSoap service = new SpringCMWebServices.SpringCMServiceSoap();
    if (!System.Test.isRunningTest())
    {   System.debug('ALL GOOD' );
        System.debug('SessionID>>:'+userSessionID);
        System.debug('currentUser.email>>:'+currentUser.email);
        System.debug('ssoUrl>>:'+ssoUrl);
        System.debug('apiKey>>:'+apiKey);
        System.debug('accountId>>:'+accountId);
        string token = service.AuthenticateSSO(currentUser.email, userSessionID , ssoUrl, apiKey, accountId);
        System.debug('Spring CM Token >>:'+token );
        service.BPMInitiateWorkflow(token, wfName, xml);
    }
}

@future(callout=true)
WebService static void DeleteFolder(string FolderName, string FolderPath, string ssoUrl, string apiKey, string accountId, string sfId, string sfType, string sessionid)
{
    User currentUser = [Select email from User where Id = : UserInfo.getUserId()];
    String userSessionID = sessionid; 
    SpringCMWebServices.SpringCMServiceSoap service = new SpringCMWebServices.SpringCMServiceSoap();
    if (!System.Test.isRunningTest())
    { System.debug('ALL GOOD' );
    System.debug('SessionID>>:'+userSessionID);
        System.debug('currentUser.email>>:'+currentUser.email);
        System.debug('ssoUrl>>:'+ssoUrl);
        System.debug('apiKey>>:'+apiKey);
        System.debug('accountId>>:'+accountId);
        string token = service.AuthenticateSSO(currentUser.email, userSessionID , ssoUrl, apiKey, accountId);
        System.debug('Spring CM Token >>:'+token );
        SpringCMWebServices.SCMFolder retFolder = service.FindOrCreateEOSFolder(token, sfId, sfType, folderName, folderPath, true);
        System.debug('Spring CM Folder >>:'+retFolder.Id);  
        System.debug('Spring CM SFType >>:'+sfType); 
        if (retFolder != null)  {
          sfType = 'Folder';
          service.SCMDelete(token,sfType,retFolder.Id); 
        }
        else
          System.debug('Folder does not exist');     
    }
}

}