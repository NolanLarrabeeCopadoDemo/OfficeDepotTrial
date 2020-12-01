global class UserFederationIds{

    webservice static List<String> ReturnIds(){
        List<String> ActiveFederationIds = new List<string>();
        
//added to filter users with salesforce license by rohini
          Map<Id,Profile> profileIds = new Map<id,profile>([SELECT Id,UserLicenseId FROM Profile where UserLicenseId  in (SELECT Id FROM UserLicense where name ='Salesforce')]);
        for(user usr:[Select Id,FederationIdentifier from user where IsActive = true  and profileId in:profileIds.Keyset()]){
            ActiveFederationIds.add(usr.FederationIdentifier);
        }
        //if(ActiveFederationIds.size() > 0)
        return ActiveFederationIds ;
    }    
}