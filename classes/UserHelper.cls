/*=============================================================================
    HISTORY                                                                  
                                                               
    DATE            DEVELOPER                DESCRIPTION                               
    ====            =========                =========== 
    26-Jun-2012     Sunil Bansal             This apex class is helper class which can be used to  
                                                                                                             
==============================================================================*/
public class UserHelper {
    public static Map<id, User> userInfo = new Map<id,User>();
    public static Map<String, User> userNameMap = new Map<String,User>();
    
    /*
    Method to retrieve the User information.
    @param userIds: Set of User ids for which information is to be retrieved
    */

    public static void allUserData()
    {
        //added to filter users with salesforce license by rohini
          Map<Id,Profile> profileIds = new Map<id,profile>([SELECT Id,UserLicenseId FROM Profile where UserLicenseId  in (SELECT Id FROM UserLicense where name ='Salesforce')]);
        for(User usr: [Select id, Name, OD_Employee_ID__c, Manager__c, Training_Date__c, UserRole.Name, Market__c, Profile.Name, Region__c, LastLoginDate, isActive, Title, Email, District__c, Short_Title__c from User where profileId in:profileIds.Keyset()])
        {
            userInfo.put(usr.Id,usr);
        }
    }

    public static void allActiveUserData()
    {
          Map<Id,Profile> profileIds = new Map<id,profile>([SELECT Id,UserLicenseId FROM Profile where UserLicenseId  in (SELECT Id FROM UserLicense where name ='Salesforce')]);
        for(User usr: [Select id, Name, UserName, OD_Employee_ID__c, Manager__c, Training_Date__c, UserRole.Name, Market__c, Profile.Name, Region__c, LastLoginDate, isActive, Title, Email, District__c, Short_Title__c from User where isActive = true and profileId in:profileIds.Keyset()])
        {
            userInfo.put(usr.Id,usr);
            userNameMap.put(usr.UserName, usr);
        }
    }
    
      public static void allUsrRleChanged()
    {
        
        for(User usr: [Select id, Name, UserName, OD_Employee_ID__c, Manager__c, Manager.Name,Manager.UserRole.Name,Training_Date__c, UserRole.Name, Market__c, Profile.Name, Region__c, LastLoginDate, isActive, Title, Email, District__c, Short_Title__c,isRoleChanged__c,Previous_Title__c, Previous_Manager__c from User where isActive = true and isRoleChanged__c = true])
        {
            userInfo.put(usr.Id,usr);
            userNameMap.put(usr.UserName, usr);
        }
    }
    
    public static Map<String, List<User>> allActiveUsersByRegion(Set<String> setRegion)
    {
        Map<String, List<User>> regionUserMap = new Map<String, List<User>>();
        for(User usr: [Select id, Name, OD_Employee_ID__c, Manager__c, Training_Date__c, UserRole.Name, Market__c, Profile.Name, Region__c, LastLoginDate, isActive, Title, Email, District__c, Short_Title__c from User where isActive = true and Region__c IN :setRegion])
        {
            List<User> usrList = new List<User>();
            if(regionUserMap.containsKey(usr.Region__c))
                usrList = regionUserMap.get(usr.Region__c);
            usrList.add(usr);
            regionUserMap.put(usr.Region__c, usrList);  
            userInfo.put(usr.Id,usr);
        }
        return regionUserMap;
    }

    public static Map<String, List<User>> allActiveUsersByMarket(Set<String> setMarket)
    {
        Map<String, List<User>> marketUserMap = new Map<String, List<User>>();
        for(User usr: [Select id, Name, OD_Employee_ID__c, Manager__c, Training_Date__c, UserRole.Name, Market__c, Profile.Name, Region__c, LastLoginDate, isActive, Title, Email, District__c, Short_Title__c from User where isActive = true and Market__c IN :setMarket])
        {
            List<User> usrList = new List<User>();
            if(marketUserMap.containsKey(usr.Market__c))
                usrList = marketUserMap.get(usr.Market__c);
            usrList.add(usr);
            marketUserMap.put(usr.Market__c, usrList);  
            userInfo.put(usr.Id,usr);
        }
        return marketUserMap;
    }

    public static void retrieveUserData(Set<id> userIds)
    {
        for(User usr: [Select id, Name, OD_Employee_ID__c, Manager__c, Training_Date__c, UserRole.Name, Market__c, Profile.Name, Region__c, LastLoginDate, isActive, Title, Email, District__c, Short_Title__c from User where Id in: userIds])
        {
            userInfo.put(usr.Id,usr);
        }
    }
    
    public static void retrieveUserData(Set<string> userIds)
    {
        for(User usr: [Select id, Name, OD_Employee_ID__c, Manager__c, Training_Date__c, UserRole.Name, Market__c, Profile.Name, Region__c, LastLoginDate, isActive, Title, Email, District__c, Short_Title__c from User where Id in: userIds])
        {
            userInfo.put(usr.Id,usr);
        }
    }
    
    /*
    Method to retrieve the User information by name.
    @param userName: Name of the User
    */

    public static void retrieveUserDataFromNames(set<String> userNames)
    {
        for(User usr: [Select id, Name, OD_Employee_ID__c, Manager__c, Training_Date__c, UserRole.Name, Market__c, Profile.Name, Region__c, LastLoginDate, isActive, Title, Email, District__c, Short_Title__c from User where Name in: userNames ])
        {
            userInfo.put(usr.Id,usr);
        }
    }

    
    /*
    Method return true/false depending on user is active or inactive.
    @param userRecordId: User record Id for which info is required.
    */
    public static Boolean isActiveUserId(id userRecordId)
    {
        if(userInfo.size() < 1 || userInfo.get(userRecordId) == null)
        {
            Set<id> userIds = new Set<id>();
            userIds.add(userRecordId);
            retrieveUserData(userIds);
        }

        if(userInfo.get(userRecordId) != null)
        {
            return userInfo.get(userRecordId).IsActive;
        }
        else
        {
            return false;
        }
    }
    
    public static Boolean isValidUserId(id userRecordId)
    {
        if(userInfo.size() < 1 || userInfo.get(userRecordId) == null)
        {
            Set<id> userIds = new Set<id>();
            userIds.add(userRecordId);
            retrieveUserData(userIds);
        }

        if(userInfo.get(userRecordId) != null)
        {
            return true;
        }
        else
        {
            return false;
        }
    }
    

    /*
    Method return User Record depending on userRecordId passed is valid/invalid.
    @param userRecordId: User record Id for which info is required.
    */
    public static User getUserRecord(id userRecordId)
    {
        if(userInfo.size() < 1 || userInfo.get(userRecordId) == null)
        {
            Set<id> userIds = new Set<id>();
            userIds.add(userRecordId);
            retrieveUserData(userIds);
        }

        if(userInfo.get(userRecordId) != null)
        {
            return userInfo.get(userRecordId);
        }
        return null;
    }

    /*
    Method return Map of User Records depending on userIds passed
    @param userIds: User record Ids for which info is required.
    */
    public static Map<Id,User> getUserRecords(Set<id> userIds)
    {
        Map<id, User> users = new Map<id,User>();
        system.debug(userInfo.keyset().containsAll(userIds));
        if(userInfo.keyset().containsAll(userIds) == false)
        {
            /*//.debug();
            set<id> existingIds = userIds.clone();
            existingIds.retainAll(userInfo.keyset());
            system.debug('existingIds'+existingIds);
            set<id> newIds = userIds.clone();
            newIds.removeAll(existingIds);
            system.debug('newIds'+newIds);*/
            retrieveUserData(userIds);
        }
        system.debug('userIds'+userIds);
        for(id i : userIds )
        {
            if(userInfo.get(i) != null)
              users.put(i, userInfo.get(i));
        }
              
        return users;
    }


/*    
    public static Id retrieveUserId(String name)
    {
        if(userNameMap.size() < 1 || userNameMap.get(name) == null)
        {
            Set<String> userNames = new Set<String>();
            userNames.add(name);
            retrieveUserDataFromNames(userNames);
        }
        
        if(userNameMap.get(name) != null)
        {
            return userNameMap.get(name).Id;
        }
        else
        {
            return null;
        }
    }
    
    public static Boolean isActiveUserName(String userName)
    {
        if(userNameMap.size() < 1 || userNameMap.get(userName) == null)
        {
            Set<String> userNames = new Set<String>();
            userNames.add(userName);
            retrieveUserDataFromNames(userNames);
        }

        if(userNameMap.get(userName) != null)
        {
            return userNameMap.get(userName).IsActive;
        }
        else
        {
            return false;
        }
    }

    public static Boolean isValidUserName(String userName)
    {
        if(userNameMap.size() < 1 || userNameMap.get(userName) == null)
        {
            Set<String> userNames = new Set<String>();
            userNames.add(userName);
            retrieveUserDataFromNames(userNames);
        }

        if(userNameMap.get(userName) != null)
        {
            return true;
        }
        else
        {
            return false;
        }
    }
*/
}