/**
 * CreatedBy:Shravya Channamadhavuni
 * Date:11/14/2018
 * Description: Enable/disable the user.
 */
public without sharing class EnableandDisableuser {
    
    //method to get user status and user id
    @Auraenabled
    public static List<String> initHelperMeth(String recordId) {
        List<String> retvalues= new List<String>();
        String usrstatus;
        try {
            system.debug('==>Contact id from which the button is clicked:'+recordId);
            // retreieve the contact from which the button is clicked
            contact cnt = [select id, email, FirstName, LastName from contact where id = :recordId];
            //retreieve the user based on email , firstname and last name
            List<user> usr = [select id, email, isActive from user where FirstName = :cnt.FirstName AND LastName = :cnt.LastName AND (email = :cnt.Email OR username=:cnt.Email)]; 
            if(usr.isEmpty()) {
                string errmsg = 'There is no User record for this Contact. This record corresponds to a bad data';
                    AuraHandledException ex = new AuraHandledException(errmsg);
                    ex.setMessage(errmsg);
                    throw ex;
            }
            // sending the status of user to lighting controller
            if(usr[0].IsActive) { 
                usrstatus = 'TRUE'; 
            } else {
                usrstatus = 'FALSE';  
            }
            //adding user status and user id to list
            retvalues.add(usrstatus);
            retvalues.add(usr[0].Id);  
            system.debug('==>Return Values:'+retvalues);
        } 
        catch (Exception ex) {
            throw new AuraHandledException(ex.getMessage()); 
        }
        return retvalues;
    }
    
    // deactivating the user
    @Auraenabled
    public static String deactivateUser(String ouserid) {  
        List<user> usrlsttbupdtd = new List<User> ();
        try {
            //  making isActive to false 
            for(User usr : [select id, Email,Manually_Reactivated__c,IsActive from User where id = :ouserid]) {
                if(usr.IsActive) {
                    usr.IsActive = FALSE;
                    usr.Manually_Reactivated__c=FALSE;
                }
                // bulkifying
                usrlsttbupdtd.add(usr);
            }
            update usrlsttbupdtd;  
        } 
        catch (Exception ex) {
            throw new AuraHandledException(ex.getMessage());    
        }
        return 'success';
    }
    
    //method to activate user
    @Auraenabled
    public static String enableUser(String oouserid) {
        List<user> usrlsttbupdtd = new List<User> ();
        try {
            //making isActive to true   
            for(User usr : [select id, Email,Manually_Reactivated__c,IsActive from User where id = :oouserid]) {
                if(usr.IsActive == false) {
                    usr.IsActive = true;
                    usr.Manually_Reactivated__c=true;
                }
                //bulkifying   
                usrlsttbupdtd.add(usr);
            }
            update usrlsttbupdtd;
        }
        catch (Exception ex) {            
            throw new AuraHandledException(ex.getMessage());               
        }
        return 'success';   
    }   
}