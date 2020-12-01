/**
 * @Author: Shravya Channamadhavuni
 * @Description: Functionality to handle Referral from Third Party.
 */
public class ReferralController {
    //Returns some of the pre defined Values from Contact
    @Auraenabled
    public static Map<String,String> initHelperMeth(String recordId) {
        Map<String,String> mapOfValues= new Map<String,String> ();
        String message;
        system.debug('Record Id of the contact is:'+recordId);
        //Query on Contact from where the button is clicked
        contact c= [select id, Name,AccountId, Account.Name,Email,Account.Cust_ID__c,Phone from contact where id=:recordId] ;
        //Query on User who is referring
        user u=[select Name,OD_Employee_ID__c,Phone from user where id=:UserInfo.getUserId()]; 
        //Checking if the Referral already exists for that Account
        for (Third_Party_Referrals__c thrd:[select id,Customer_Name__c from Third_Party_Referrals__c where Customer_Name__c=:c.AccountId limit 1]) {
            message='exists';   
        }
        // If the referral doesn't exist then add the values into map
        if(message != null) {
            mapOfValues.put('message',message);    
        }
        else
        {
            mapOfValues.put('customer',c.Account.Name); 
            mapOfValues.put('contactname',c.Name); 
            mapOfValues.put('contactphone',c.Phone); 
            mapOfValues.put('contactemail',c.email); 
            mapOfValues.put('custid',c.Account.Cust_ID__c); 
            mapOfValues.put('employeename',u.Name);
            mapOfValues.put('emplyeephone',u.Phone);
            mapOfValues.put('employeeid',u.OD_Employee_ID__c);        
        }
        system.debug('Map of Values returned is :'+mapOfValues);
        return mapOfValues;
    }
    //Saving the Referral information into the Object
    @AuraEnabled
    public static String saveReferral(Third_Party_Referrals__c ref,String recordId) {
        //Query to get Account and Contact Id and to populate on the record
        contact c= [select id,AccountId from contact where id=:recordId] ;
        ref.Customer_Name__c =c.Accountid;
        ref.Contact_Name__c=c.id;
        ref.Status__c= 'Open';
        insert ref;
        return ref.Id;
    }
    
}