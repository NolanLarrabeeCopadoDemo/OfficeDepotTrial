/*
-- +=======================================================================+
-- | Office Depot                                                          |
-- +=======================================================================+
-- | Name : ContractEvents                                                 |
-- |                                                                       |
-- | Description : After a CSF/Contract is deleted a web service is called |
-- |               to delete the folder for the contract in SpringCM.      |
-- |                                                                       |
-- |Change History:                                                        |
-- |---------------                                                        |
-- |                                                                       |
-- |Version Date        Author          Remarks                            |
-- |------- ----------- --------------- -----------------------------------|
-- |1       13-Nov-2013 Kishore Jena    Initial Version                    |
-- +=======================================================================+
*/

trigger ContractEvents on Contract (after delete) {

  if (Util.bypassTriggers('ContractEvents')) {
    Util.DEBUG('Bypassing trigger CaseEvents');
    return;
  }

  // Set parameters for the Web Service Call from UAT by default
  //String URL = 'https://officedepot--UAT.cs14.my.salesforce.com/services/Soap/u/28.0/00Dc0000001gD43';
  //String URL = 'https://cs14.my.salesforce.com/services/Soap/u/28.0/00Dc0000001gD43';
  String URL = 'https://cs7.my.salesforce.com/services/Soap/u/28.0/00DM00000012qOi';
  String APIKey = '37EA6375-371B-42AD-87D0-1C6086550C80';
  String SCM_ACCID = '7180';
  String StsfId = '111111111';
  String sfType = 'Salesforce.Contract';
  String userSessionID = UserInfo.getSessionId();

  //Overwrite if called from Production Org
  if(UserInfo.getOrganizationId() == '00DE0000000J4oSMAS'){
    URL = 'https://officedepot.my.salesforce.com/services/Soap/u/{version}/00DE0000000J4oS'; 
    
    APIKey = '2155AD71-F164-4B7D-AC88-698548B6EDDF';
    SCM_ACCID = '13083';
  }
  
  // Save all the related account Ids
  Set<id> acctIds = new Set<id>();
  for(Contract cntrct:Trigger.Old) 
         acctIds.add(cntrct.AccountId);
         
  // Create a map so that Account is locatable by its Id (key)
   Map<id, Account> acctMap = new Map<id, Account>(
          [SELECT Id, Name, Cust_Id__c FROM Account WHERE Id IN :acctIds]);
         
    
  for(Contract newcntrct:Trigger.Old) {
    Account acctrec = acctMap.get(newcntrct.AccountId);
    System.Debug('Account Record - ' + acctrec);
    if (acctrec != null) { 
      String targetFolder = ('/'+ acctrec.Cust_Id__c + '-' + acctrec.Name + '/Contracts');
      System.Debug('Folder Path - ' + targetFolder);
    
      // Call Web Service to delete the folder in SpringCM
      
      SpringCMHelperUAT.DeleteFolder(newcntrct.ContractNumber, 
                                     targetFolder, 
                                     URL, 
                                     APIKey, 
                                     SCM_ACCID, 
                                     newcntrct.Id, 
                                     //'Salesforce.Contract', 
                                     sfType,
                                     userSessionID
                                    );
      system.debug('TargetFolder:' + targetFolder);
      system.debug('URL:' + URL);
      system.debug('APIKey:' + APIKey);
      system.debug('SCM_ACCID:' + SCM_ACCID);
      system.debug('ContractId:' + newcntrct.Id);
      system.debug('SFTYPE:' + sfType);
      system.debug('UserSessionId:' + userSessionID);
    }
  }
}