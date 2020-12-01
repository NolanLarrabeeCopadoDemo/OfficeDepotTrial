// 
// (c) 2011 Appirio, Inc., Office Depot, Inc
//
// Apex Utility Functions 
//
// Review Status: @DRAFT
//
// 2011-07-11     JoeK       Initial Version
//
//  Modification : Added Method CheckRT to filter Tech Zone RT  
//  By : Wipro Offshore - Rohini
//  Date : 19 Apr 2018


public class Util {


  // @TODO:  Add custom setting that disables and enables service logging -- JoeK
  public static Id LOG(string service, integer status, string message) {
  
    Log__c log = new Log__c(service_name__c = service, status__c = status, message__c = message);
    try {
      insert log;
    } catch (Exception e) {
      // never throw an exception when logging to prevent looping and exausting governor
      // use sendEmail to collect diagnostics when needed at this point.
    }
    return log.id;
  }
  
  
  public static void DEBUG(string message) {
      system.debug('\n\nUtil.DEBUG: ' + message + '\n');
  }
  
  
  public static string to15CharStr(Id id) {
    String idStr = '' + id;
    // Use only 15 char id for comparison
    if (idStr.length() > 15) {
        idStr = idStr.substring(0, 15);
    }
    return idStr;
  }


  public static boolean bypassTriggers(string triggerKeyName, string configKey, String userIdStr) {
    
    Admin_Config__c conf = Admin_Config__c.getValues(configKey);
    if(conf == null) {    // to return false if custom setting  
      return false;       // value are not found 
    }    
    String[] exemptIdStrs = conf.Bypass_Triggers__c == null ? new List<String>() : conf.Bypass_Triggers__c.split(';\\s*');
    Set<String> exemptIdSet = new Set<String>(exemptIdStrs);
    boolean ans = exemptIdSet.contains(userIdStr);
    return ans;
  }
  
  
  public static boolean bypassTriggers(string triggerName, string configKey) {
    String userIdStr = to15CharStr(UserInfo.getUserId());
    return bypassTriggers(triggerName, configKey, userIdStr);
  }


  public static boolean bypassTriggers(string triggerKeyName) {
     return bypassTriggers(triggerKeyName, 'Default');
  }
  
  //---------------------------------------------------//
  //  Get set of account ids from account team member
  //---------------------------------------------------//
  public static Set<Id> setOfAccountIdsFromAccountTeamMember(String loggedInUserId){
    List<AccountTeamMember> accountTeamMemberList = [SELECT id, AccountId FROM AccountTeamMember WHERE UserId = :loggedInUserId ];
    Set<Id> setOfAccountIds = new Set<Id>();
    System.debug('****===>****Account TEam List Count =>' + accountTeamMemberList);
    for(AccountTeamMember accountTeamMember : accountTeamMemberList ){
        setOfAccountIds.add(accountTeamMember.AccountId);
    }
    return setOfAccountIds;
  }
  
  //=================================================//
  //get Current Page Name
  //=================================================//
  public static String getCurrentPageName() {
    URL currentPageURL = URL.getCurrentRequestUrl();
    return currentPageURL.getPath().replace('/apex/','');
  }
  
  
//  =================================================================//
//  Read the custom setting 
//  ==================================================================//
  public static Id getCurrentDashboardUserId(String pageName) {     
    String dashboardAPI = null;
    for(Dashboard_VF_Mapping__c dashboardVFMapping :Dashboard_VF_Mapping__c.getAll().values()) {
        if(dashboardVFMapping.Visualforce_Page__c == pageName) {
          dashboardAPI = dashboardVFMapping.Dashboard_API_Name__c;
          break;
        }
    }
    
    System.debug('****===>Dashboard API***' + dashboardAPI);
    
    if(dashboardAPI == null) {
      return UserInfo.getUserId();
    }
    
    List<Dashboard> lstDashboard = [SELECT RunningUserId FROM Dashboard WHERE DeveloperName = :dashboardAPI];
    System.debug('****===>Dashboard List***' + lstDashboard);
   
    if(lstDashboard.size() == 0) {
      return UserInfo.getUserId();
    }
    return lstDashboard[0].RunningUserId;
 }
  public static Set<ID> bizBoxRTIdsByObject(String sObjectName)
  {
    Set<ID> resp = new Set<ID>();
      resp.add(Label.Task_BizBox_RT);
      resp.add(Label.Lead_BizBox_RT);
      resp.add(Label.Contact_BizBox_RT);
      resp.add(Label.Customer_BizBox_RT);
      resp.add(Label.Opportunity_BizBox_RT);
      resp.add(Label.Prospect_BizBox_RT);
      
      resp.add(Label.partner_account);
      resp.add(Label.partner_lead);
       // TechzOne RT Acc,Contact,Lead,Opp,task,Event
      resp.add(Label.TechZoneAccRTProspect);
      resp.add(Label.TechZoneAccRTCustomer);
      resp.add(Label.TechZoneContactRT);
      resp.add(Label.TechZoneLeadRT); 
      resp.add(Label.TechZoneOppRT);
      resp.add(Label.TechZoneTaskRT);
      resp.add(Label.TechZoneEventRT);
      return resp;
    /*/*List<RecordType> rtList;
    Set<ID> resp = new Set<ID>();
    if( sObjectName != null)
    {
      rtList = [SELECT Id from RecordType where SObjectType=:sObjectName and DeveloperName like '%BizBox%'];
    }
    if(rtList != null)
    {
      for (RecordType rt : rtList) {
        resp.add(rt.id);

      }
    }
    return resp;*/
      //Added below code by Naga as SOQL in the loop and getting a limit exception.
    /*set<Id> recordTypeIds = new set<Id>();
    Schema.DescribeSObjectResult sobjectResult = Schema.getGlobalDescribe().get(sObjectName).getDescribe();
    if(sobjectResult != null)
    {
    List<Schema.RecordTypeInfo> recordTypeInfo = sobjectResult.getRecordTypeInfos();
    if(recordTypeInfo != null)
    {
    for(Schema.RecordTypeInfo info : recordTypeInfo){
        if(info.getName().contains('BizBox')){
             recordTypeIds.add(info.getRecordTypeId());
       }
    }
    }
    }
     return recordTypeIds;
  }*/
  }
    
    //  =================================================================//
// Get set of RecordType ids if RecordType Name contains (Tech Zone)
//  ==================================================================//
    Public static Set<Id> checkRT( String sObjectName)
    {
        set<Id> recordTypeIds = new set<Id>();
        Schema.DescribeSObjectResult sobjectResult = Schema.getGlobalDescribe().get(sObjectName).getDescribe();
        if(sobjectResult != null)
        {
            List<Schema.RecordTypeInfo> recordTypeInfo = sobjectResult.getRecordTypeInfos();
            if(recordTypeInfo != null)
            {
                for(Schema.RecordTypeInfo info : recordTypeInfo)
                {
                    if(info.getName().contains('(Tech-Zone)'))
                    {
                        recordTypeIds.add(info.getRecordTypeId());
                    }
                }
            }
        }
        system.debug('recordtypes'+recordTypeIds);
        return recordTypeIds;
    }

}