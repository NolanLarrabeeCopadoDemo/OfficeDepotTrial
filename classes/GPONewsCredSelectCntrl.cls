public class GPONewsCredSelectCntrl{
COM_NewsCredInfo nci= new COM_NewsCredInfo();
public List<COM_NewsCredInfo.NewsCredHdr> preNewsCredHdrs {get;set;}
public List<COM_NewsCredInfo.NewsCredHdr> postNewsCredHdrs {get;set;}
public String pageNewsID {get;set;}
    
public GPONewsCredSelectCntrl()
  {
    GPO_Community_Setup__c commSetup = gpo_community_setup__c.getValues('default'); 
    User communityUser;
    if (!Test.isRunningTest())    
     communityUser = [Select Id, ContactID, profileID,IsPortalEnabled from User where id =: userinfo.getUserId()];
    else
     communityUser = [Select Id, ContactID, profileID,IsPortalEnabled from User where IsPortalEnabled = true limit 1];
     
    pageNewsID = 'CommPostlogin';
    Contact communityContact;
    GPO_Group__c selectedGroup;
      
    if (communityUser.IsPortalEnabled)
         communityContact = [Select id, Name, GPOCommunityID__c, GPO_Community__c, Admin_Context__c from Contact where id =: communityUser.ContactID];
    
      if (communityUser.IsPortalEnabled) {
         if(!commSetup.Admin_ProfileId__c.equals(String.valueOf(communityUser.ProfileID))) {
            selectedGroup = [SELECT Id, Activated__c, Ultimate_Parent2__c, GPO_Template__c, Welcome_Title__c, Welcome_Message__c, LastModifiedDate,  Community_Image__c, Account__c, Community_Name__c FROM GPO_Group__c 
                   WHERE Account__c = :communityContact.GPO_Community__c];
          }    else if ( ''.equals(String.valueOf(communityContact.Admin_Context__c)) || null == communityContact.Admin_Context__c ){
             selectedGroup = [SELECT Id, Activated__c, Ultimate_Parent2__c, GPO_Template__c, Welcome_Title__c, Welcome_Message__c, LastModifiedDate, Community_Image__c, Account__c, Community_Name__c FROM GPO_Group__c 
                   WHERE Account__c = :communityContact.GPO_Community__c];
          } else {
            selectedGroup = [SELECT Id,  Activated__c, Ultimate_Parent2__c, GPO_Template__c, Welcome_Title__c, Welcome_Message__c, LastModifiedDate, Community_Image__c, Account__c, Community_Name__c FROM GPO_Group__c 
                   WHERE Account__c = :communityContact.Admin_Context__c];
          }
          system.debug('Before admin context update:' + communityContact.Admin_Context__c);
        }
      
       if (selectedGroup != null) {
            if (selectedGroup.Community_Name__c != null)
              pageNewsID = 'CommPostlogin_' + selectedGroup.Community_Name__c.replaceAll( '\\s+', '');  
        }
      
    postNewsCredHdrs = getNewsPost();
    //preNewsCredHdrs = getNewsPre(); 
  }

// popultes post login newscred
public List<COM_NewsCredInfo.NewsCredHdr> getNewsPost()  {
List<COM_NewsCredInfo.NewsCredHdr> newsCredHdrs = new List<COM_NewsCredInfo.NewsCredHdr>();
GPO_Community_Setup__c commSetup = gpo_community_setup__c.getValues('default'); 
integer i=0; 
   for(GPO_Group_Detail__c gdl : [SELECT id, Value1__c from GPO_Group_Detail__c where GPO_Group__r.name like :commsetup.Default_Group_Name__c and type__c ='NEWSCRED' and isDeleted = false order by value2__c])
    {
        i++;
        COM_NewsCredInfo.NewsCredHdr news1=  new COM_NewsCredInfo.NewsCredHdr();
        news1 =nci.getAndParse(gdl.Value1__c,pageNewsID,i);
        newsCredHdrs .add(news1);
    }

return newsCredHdrs;
}

// popultes pre login newscred
/*public List<COM_NewsCredInfo.NewsCredHdr> getNewsPre()  {
List<COM_NewsCredInfo.NewsCredHdr> newsCredHdrs = new List<COM_NewsCredInfo.NewsCredHdr>();
integer i=0;
    
   for(GPO_Group_Detail__c gdl : [SELECT id, Value1__c from GPO_Group_Detail__c where GPO_Group__r.name like 'Default Group' and type__c ='NEWSCREDPRE' and isDeleted = false order by value2__c])
    {
        i++;
        COM_NewsCredInfo.NewsCredHdr news1=  new COM_NewsCredInfo.NewsCredHdr();
        news1 =nci.getAndParse(gdl.Value1__c,pageNewsID,i);
        newsCredHdrs .add(news1);
    }

return newsCredHdrs;
}*/



}