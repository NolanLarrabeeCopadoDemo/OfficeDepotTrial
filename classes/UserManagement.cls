public class UserManagement {

    @future
    public static void deactivate(String userId) {
        User u = [SELECT isActive, OD_Employee_Id__c, FederationIdentifier, Username, Email, Deactivation_Error__c
                  FROM User
                   WHERE Id = :userId];
    
        u.isActive = false;
        u.OD_Employee_Id__c = 'zzz' + u.OD_Employee_Id__c;
        u.FederationIdentifier = 'zzz' + u.FederationIdentifier;
        u.Username = 'zzz' + u.Username;
        u.Email = 'zzz' + u.Email;
        u.Deactivation_Error__c = 'Processing';
    
       Database.SaveResult sr = Database.update(u, false);
                
        // Get errors
        String error = '';
        Boolean firstError = true;
            
        for (Database.Error err : sr.getErrors()) {
            if (!firstError) {
                error += ' - ';
            }
            error += err.getMessage();
            firstError = false;
        }
        
        // Update errors
        User uErrors = [SELECT Deactivation_Error__c
                        FROM User
                        WHERE Id = :userId];
                             
        uErrors.Deactivation_Error__c = error;
        
        update uErrors;
    }
}