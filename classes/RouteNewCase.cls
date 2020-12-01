public class RouteNewCase {
    public String scoeFlowUrl = '/flow/SCOE_Button_Seismic_Checkpoint';
    public String defaultCaseCreationUrl = '/setup/ui/recordtypeselect.jsp?ent=Case&nooverride=1&retURL=%2F500%2Fo&save_new_url=%2F500%2Fe%3FretURL%3D%252F500%252Fo';
    
    PageReference scoeFlowPageReference = new PageReference(scoeFlowUrl);
    PageReference defaultCaseCreationPageReference = new PageReference(defaultCaseCreationUrl);
    
    public RouteNewCase(ApexPages.StandardController controller)
    {}

    public RouteNewCase()
    {}
    
    public PageReference OnPageLoad()
    {
        // Get the profile of the current user
        Profile profileOfCurrentUser = [SELECT Name
                                        FROM Profile
                                        WHERE Id = :UserInfo.getProfileId()];
        
        
        // From the profiles that don't need to be routed to SCOE, get the one that matches this one
        List<Profile_Not_Routed_to_SCOE__mdt> profileNotRoutedToSCOE = [SELECT MasterLabel
                                                                        FROM Profile_Not_Routed_to_SCOE__mdt
                                                                        WHERE MasterLabel = :profileOfCurrentUser.Name];
        
        // If we found a result, that means this profile does not get routed to SCOE
        if (profileNotRoutedToSCOE.size() > 0)
        {
            System.debug('RouteNewCase: ' + profileNotRoutedToSCOE);
            return defaultCaseCreationPageReference;
        }
        
        // Otherwise send this profile to SCOE
        System.debug('RouteNewCase: ' + profileNotRoutedToSCOE);
        return scoeFlowPageReference;
    }
}