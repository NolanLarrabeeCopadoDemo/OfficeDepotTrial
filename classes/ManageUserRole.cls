public with sharing class ManageUserRole {

public String slctedRole { get; set; }

public PageReference ChgRoleVal() {
     if(updateUsrList.size() > 0){
          for(integer  j =0;j<updateUsrList.size();j++) 
          {
                updateUsrList[j].isRoleChanged__c=false;
                updateUsrList[j].UserRoleId=slctedRole ;
                System.debug('usernamejjjjjH'+updateUsrList[j].Name );
         
          }
        Database.update(updateUsrList);
        }
        
             buildUserMaps();
     return page.ManageUserRole;
     }

public PageReference cancelRlchg() {  
            buildUserMaps();
     return page.ManageUserRole;
     }

public List<UserRole> UserTemp = new List<UserRole>();
    public boolean bUserCols {get;set;}
    public boolean bRegionCol {get;set;}
    public boolean bMarketCol {get;set;}
    public boolean bDistrictCol {get;set;}
    public boolean bTitleCol {get;set;}
    public boolean bRoleCol {get;set;}
    public boolean bUserCol {get;set;}
    public String selectedProfile {get;set;}
    public String selectedRegion {get;set;}
    public String selectedMarket {get;set;}
    public String selectedDistrict {get;set;}
    public String selectedTitle {get;set;}
    
    private Map<String, Integer> regionUserMap = new Map<String, Integer>();
    private Map<String, Integer> marketUserMap = new Map<String, Integer>();
    private Map<String, Integer> districtUserMap = new Map<String, Integer>();
    private Map<String, Integer> titleUserMap = new Map<String, Integer>();
    
    private Set<String> regionSet = new Set<String>();
    private Set<String> marketSet = new Set<String>();    
    private Set<String> districtSet = new Set<String>();
    private Set<String> titleSet = new Set<String>();
    
      // this is to display data in VF page from wrapper class
    public List<UserActivityData> userDataList = new List<UserActivityData>();
        List<User> updateUsrList = new List<User>();
        List<UserActivityData> ulist ;
        List<String> userIDList = new List<String>();
    
    public ManageUserRole()
    {
       buildUserMaps();
    }
   /* public ManageUserRole(ApexPages.StandardController controller)
    {
        buildUserMaps();
    }*/
     private void buildUserMaps()
    {
      updateUsrList.clear(); 
         userDataList = new List<UserActivityData>();
              Map<Id, UserActivityData> userIdActivityMap = new Map<Id, UserActivityData>();
        UserHelper.allUsrRleChanged();
        for(User usr: UserHelper.userInfo.values())
        {
            if(usr.Profile.Name != 'Ideation User'){
                UserActivityData activityData;
                activityData = new UserActivityData(); 
                activityData.userName = usr.Name ;
                activityData.userProfile = usr.Profile.Name ;
                activityData.userRole = usr.UserRole.Name ;
                activityData.userRegion = usr.Region__c ;
                activityData.userMarket = usr.Market__c ;
                activityData.userDistrict = usr.District__c;
                activityData.userTitle = usr.Short_Title__c;
                activityData.userLastLogin = usr.LastLoginDate ;
                activityData.uid=usr.Id;
                activityData.isRoleChanged = usr.isRoleChanged__c;
                activityData.ManagerName = usr.Manager.Name;
                activityData.PreviousTitle = usr.Previous_Title__c; 
                activityData.PreviousManager = usr.Previous_Manager__c;
                activityData.managerRole =usr.Manager.UserRole.Name;
                userDataList.add( activityData);
          
            }
        }
    }
        // User defined internal wrapper class to display data on VF page
    public class UserActivityData
    {
        public String userName {get;set;}
        public String userProfile {get;set;}
        public string userRegion {get;set;}
        public String userMarket {get;set;}
        public string userDistrict {get;set;}
        public string userTitle {get;set;}
        public String userRole {get;set;}
        public string uid{get;set;}
        public Boolean isRoleChanged {get;set;}
        public Boolean isRoleSelected {get;set;}
        public DateTime userLastLogin {get;set;}
        public String ManagerName {get;set;}
        public String PreviousTitle {get;set;}
        public String PreviousManager {get;set;}
        public String managerRole {get;set;}
        
    }
      public List<UserActivityData> getUserActivitiesData()
    {
        return userDataList;
    }
    
    
    public void loadSelected()
    {
        System.debug('oooooooooooooooooooooooo'+getUserActivitiesData());
        ulist = getUserActivitiesData();
        System.debug('SIIIIIIIIIIIIIIIIIIIII'+ulist.size() );
          
    for (UserActivityData p: ulist )  {
        if (p.isRoleSelected) {
          if (p.uid != null) 
          userIDList.add(p.uid);
         }
     
        }
      updateUsrList = [select Id,Name from user where id =:userIDList ]  ;
      System.debug('HHHHHHHHHHHHHHHHHHHHHHHHHHHHHHH'+updateUsrList.size() );
    
    }
    public PageReference allUserRole()
    { buildUserMaps();
    return null;}
    public PageReference ChgRole()
    {
        loadSelected();
        return page.UpdateRoleConfirmation;
    }
    public PageReference ChgFlag()
    {
        loadSelected();
         if(updateUsrList.size() > 0){
          for(integer  j =0;j<updateUsrList.size();j++) 
          {
                updateUsrList[j].isRoleChanged__c=false;
                System.debug('usernamejjjjjH'+updateUsrList[j].Name );
         
          }
        Database.update(updateUsrList);
        }
        
         buildUserMaps();
            return null;
    
    }
    public List<SelectOption> UserList
    {
        get
        {
            UserTemp = [Select  u.Id, u.Name From UserRole u];
            
            UserList = new List<SelectOption>();
            
            for(UserRole temp : UserTemp)
            {
                UserList.add(new SelectOption(temp.Id, temp.Name));
            }
            return UserList;
        }
        set;
    }
    
}