/*
 * Test utility for ReferralFunctionalTests_TC class.  
 *
 * @author: Andrew Smith (6/10/2018)
 */ 

@isTest
public class ReferralTestUtil_TC {
    
    public static void validateSrcDestLeadsMatch(ID sourceLeadId, ID destinationLeadId){
        Referral__c src = loadLeadAsReferral(sourceLeadId, true);
        Referral__c dest = loadLeadAsReferral(destinationLeadId, false);
        
        compareSourceDestRecords(src, dest);
    }
    
    public static void validateSrcContactDestLeadMatch(ID sourceContactId, ID destinationLeadId){
        Referral__c src = loadContactAsReferral(sourceContactId);
        Referral__c dest = loadLeadAsReferral(destinationLeadId, false);
        
        compareSourceDestRecords(src, dest);
    }
    
    public static void validateReferralDestOppdMatch(Referral__c ref, ID oppId){
        Opportunity destOpp = getOpp(oppId);
        
        System.assertEquals(ref.Opportunity_Amount__c, destOpp.Amount, 'Referral Opp Amount does not match Opp Amount.');
		System.assertEquals(ref.Opportunity_Stage__c, destOpp.StageName, 'Referral Opp Stage does not match Opp Stage.');
		System.assertEquals(ref.Opportunity_Close_Date__c, destOpp.CloseDate, 'Referral Opp Close Date does not match Opp Close Date.');
		
		if(destOpp.Loss_Reason__c == NULL){
			System.assertEquals(ref.Loss_No_Action_Reason__c, destOpp.Close_Reason__c, 'Referral Loss/No Action Reason does not match opp field Close Reason.');
		}
		else{
			System.assertEquals(ref.Loss_No_Action_Reason__c, destOpp.Loss_Reason__c, 'Referral Loss/No Action Reason does not match opp field Loss Reason.');
		}
    }
    
    public static void validateReferralRepLeadMatch(Referral__c ref, Id leadId){
    	Lead ld = getLead(leadId);
    	
    	//Checking for owner outside the test data set.  External logic changing the owner to a queue.
    	if(ld.Owner.Name != NULL){
	    	System.assertEquals(ref.Rep_Name__c, ld.Owner.Name);
	    	System.assertEquals(ref.Rep_Phone__c, ld.Owner.Phone);
	    	System.assertEquals(ref.Rep_Email__c, ld.Owner.Email);
    	}
    }
    
    public static void validateReferralRepOppMatch(Referral__c ref, Id oppId){
    	Opportunity opp = getOpp(oppId);
    	
    	System.assertEquals(ref.Rep_Name__c, opp.Owner.Name);
    	System.assertEquals(ref.Rep_Phone__c, opp.Owner.Phone);
    	System.assertEquals(ref.Rep_Email__c, opp.Owner.Email);
    }
    
    public static Opportunity getOpp(ID oppId){
    	return [SELECT ID, CloseDate, Amount, StageName, Loss_Reason__c, Close_Reason__c, Owner.Name, Owner.Phone, Owner.Email    					
    			FROM Opportunity 
    			WHERE ID = :oppId];
    }
    
    public static Referral__c getReferral(ID refId){
    	return [SELECT ID, Resulting_Lead__c, Resulting_Opportunity__c, Referred_Lead__c, Referred_Contact__c, Referred_By__c, Referred_To__c,
    					Status__c, Loss_No_Action_Reason__c, 
    					Opportunity_Amount__c, Opportunity_Close_Date__c, Opportunity_Stage__c,  
    					Rep_Name__c, Rep_Phone__c, Rep_Email__c,
    					Last_Update_Date__c, Submitted_Date__c, Referrer_Name__c
    			FROM Referral__c 
    			WHERE ID = :refId];
    }
    
    public static Lead getLead(ID leadId){
    	return [SELECT Id, FirstName, LastName, Company, Title, Phone, Email, LeadSource, Referral_Origin__c, Referral_Lead_Source__c, Referral_Client_Type__c,
                      RecordTypeId, OwnerId, NumberOfEmployees, WCW_Count__c, Owner.Name, Owner.Phone, Owner.Email, Owner.Type, 
                      Employee_Name__c, Referrer_Phone__c, Referrer_Email__c, Employee_ID__c,
                      Street, City, State, PostalCode, Country,
                      Address1__c, City__c, State__c, Zip__c, Country__c
                FROM Lead 
                WHERE ID = :leadId];
    }
    
    public static Lead createLead(String leadType){
    	Lead ld = new Lead();
    	
    	ld.RecordTypeId = ReferralUtility.getLeadRecordTypeID(leadType);
    	ld.FirstName = 'testFirstName';
    	ld.LastName = 'testLastName';
    	ld.Company = 'testCompany';
    	ld.Phone = '(555) 444-3333';
    	ld.Email = 'johndoe@od.com';
    	ld.Title = 'testTitle';
    	ld.LeadSource = 'testLeadSource';
    	
    	if(leadType != 'Tech-Zone'){
            ld.WCW_Count__c = 100000;
            ld.Address1__c = '123 Any Street';
            ld.City__c = 'Austin';
            ld.State__c = 'Texas';
            ld.Zip__c = '44443-3333';
            ld.Country__c = 'United States';
        }
        else{
            ld.NumberOfEmployees = 20000;
            ld.Street = '123 Any Street';
            ld.City = 'Austin';
            ld.State = 'Texas';
            ld.PostalCode = '55555-4444';
            ld.Country = 'United States'; 
        }
    	
    	insert ld;
    	
    	return ld; 
    }
    
    public static Contact createContact(String contactType, ID accountID){           	
    	Contact ct = new Contact();	 
    	
    	ct.RecordTypeId = ReferralUtility.getContactRecordTypeID(contactType);
    	ct.AccountId = accountID;
    	ct.FirstName = 'testFirstName1';
    	ct.LastName = 'testLastName1';
    	ct.Email = 'johndoe1@od.com';
    	ct.Title = 'testTitle1';
    	ct.LeadSource = 'testLeadSource1';

		if(contactType != 'Tech-Zone'){
 			ct.Phone1_Rep__c = '555-444-1111';
 		}
 		else{
 			ct.Phone = '(555) 444-1111';
 		}
    	
    	insert ct;
    	
    	return ct; 
    }
    
    public static Account createAccount(){
    	Account acct = new Account();
    	acct.Name = 'testAccountName';
    	acct.NumberOfEmployees = 30000;
    	acct.Org_WCW_Count_Rep__c = 4000;
    	acct.BillingStreet = '789 Any Street';
    	acct.BillingCity = 'Dallas';
        acct.BillingState = 'Texas';
        acct.BillingPostalCode = '99999-4444';
        acct.BillingCountry = 'Canada'; 
        acct.Address1__c = '567 Any Street';
        acct.City__c = 'Miami';
        acct.State__c = 'FL';
        acct.Zip__c = '44444-3333';
        acct.Country__c = 'USA';
        
        insert acct;
           	
    	return acct; 
    }
    
    public static Opportunity createOpp(ID accountId){
    	Opportunity opp = new Opportunity();
		opp.Name = 'foo';
		opp.StageName = 'Prospecting';
		opp.Amount = 100;
		opp.CloseDate = System.Today() - 1;
		opp.AccountId = accountId;
		insert opp;	
           	
    	return opp; 
    }
    
    public static User createBSDUser(){
    	return createUser('Field Sales');
    }
    
    public static User createTZUser(){
    	return createUser('TZ Standard User');  	
    }
    
    public static User createUser(String profileName){
    	User usr = new User();
    	 
    	usr.Alias = 'standt1'; 
    	usr.Email = 'standarduser@officedepot.com';
        usr.EmailEncodingKey = 'UTF-8';
        usr.LastName = 'Testing' + profileName; 
        usr.LanguageLocaleKey = 'en_US';
        usr.LocaleSidKey = 'en_US'; 
        usr.ProfileId = getProfileIDByLabel(profileName); 
        usr.TimeZoneSidKey = 'America/Los_Angeles'; 
        usr.UserName = Integer.valueOf(math.rint(math.random()*1000000)) + '@testorg3214.com';
    	
    	insert usr;
    	return usr;
    }
    
    public static ID getProfileIDByLabel(String name){
    	Profile p = [SELECT ID FROM Profile WHERE Name = :name];
    	return p.Id;    	
    }
    
    public static Referral__c loadLeadAsReferral(ID leadId, Boolean isSource){
        //Uses Referral object as a generic way to store attributes since the fields used differ by lead/contact record type (aka organization).
        Referral__c ref = new Referral__c();
        User referringUser;
        
        Lead ld = getLead(leadId);
        
        String orgName = ReferralUtility.getValidLeadRecordTypesByID().get(ld.RecordTypeId);
        
        ref.First_Name__c = ld.FirstName;
        ref.Last_Name__c = ld.LastName;
        ref.Company__c = ld.Company;
        ref.Phone__c = ld.Phone;
        ref.Email__c = ld.Email;
        ref.Title__c = ld.Title;
        
        
        if(isSource){
            if(orgName != 'Tech-Zone'){
                //Get lead owner
                referringUser = [SELECT Id, Name, Phone, Email, Region__c, OD_Employee_ID__c FROM User WHERE ID = :ld.OwnerId];
            }
            else{
                //Get running user.  This should be the user who created the referral (must use with RunAs to achieve context).
                referringUser = [SELECT Id, Name, Phone, Email, Region__c, OD_Employee_ID__c FROM User WHERE ID = :UserInfo.getUserId()];
            }
            
            ref.Referred_By__c = orgName;
            ref.Referrer_Name__c = referringUser.Name;
            ref.Referrer_Phone__c = referringUser.Phone;
            ref.Referrer_Email__c = referringUser.Email;    
            ref.Referrer_Employee_ID__c = referringUser.OD_Employee_ID__c;   
            ref.Lead_Source__c = ld.LeadSource; 
        }
        else{
            ref.Referred_By__c = ld.Referral_Origin__c;             
            ref.Referrer_Name__c = ld.Employee_Name__c;
            ref.Referrer_Phone__c = ld.Referrer_Phone__c;
            ref.Referrer_Email__c = ld.Referrer_Email__c;   
            ref.Referrer_Employee_ID__c = ld.Employee_ID__c;  
            ref.Lead_Source__c = ld.Referral_Lead_Source__c;    
        }

        if(orgName != 'Tech-Zone'){
            ref.Employees__c = ld.WCW_Count__c;
            ref.Street__c = ld.Address1__c;
            ref.City__c = ld.City__c;
            ref.State__c = ld.State__c;
            ref.Postal_Code__c = ld.Zip__c;
            ref.Country__c = ld.Country__c;
            ref.Phone__c = ld.Phone;
        }
        else{
            ref.Employees__c = ld.NumberOfEmployees;
            ref.Street__c = ld.Street;
            ref.City__c = ld.City;
            ref.State__c = ld.State;
            ref.Postal_Code__c = ld.PostalCode;
            ref.Country__c = ld.Country; 
            ref.Phone__c = ld.Phone;
        }   
        
        return ref; 
    }
    
    public static Referral__c loadContactAsReferral(ID contactId){
        //Uses Referral object as a generic way to store attributes since the fields used differ by lead/contact record type (aka organization).
        Referral__c ref = new Referral__c();
        
        Contact ct = [SELECT Id, FirstName, LastName, 
                      Account.Name, Account.RecordTypeId, RecordTypeId, Account.OwnerId, Account.NumberOfEmployees, Account.Org_WCW_Count_Rep__c,
                      Account.BillingStreet, Account.BillingCity, Account.BillingState, Account.BillingPostalCode, Account.BillingCountry,
                      Account.Address1__c, Account.City__c, Account.State__c, Account.Zip__c, Account.Country__c,   
                      Title, Phone, Phone1_Rep__c, Email, LeadSource, OwnerId 
                FROM Contact 
                WHERE ID = :contactId];
        
        String orgName = ReferralUtility.getValidContactRecordTypesByID().get(ct.RecordTypeId);
        
        ref.First_Name__c = ct.FirstName;
        ref.Last_Name__c = ct.LastName;
        ref.Company__c = ct.Account.Name;
        ref.Email__c = ct.Email;
        ref.Title__c = ct.Title;
        ref.Lead_Source__c = ct.LeadSource; 
        ref.Referred_By__c = orgName; 
        
        User referringUser;
            
        if(orgName != 'Tech-Zone'){
            //Get account owner
            referringUser = [SELECT Id, Name, Phone, Email, Region__c, OD_Employee_ID__c FROM User WHERE ID = :ct.Account.OwnerId];
        }
        else{
            //Get running user.  This should be the user who created the referral (must use with RunAs to achieve context).
            referringUser = [SELECT Id, Name, Phone, Email, Region__c, OD_Employee_ID__c FROM User WHERE ID = :UserInfo.getUserId()];
        }
            
        ref.Referrer_Name__c = referringUser.Name;
        ref.Referrer_Phone__c = referringUser.Phone;
        ref.Referrer_Email__c = referringUser.Email;    
        ref.Referrer_Employee_ID__c = referringUser.OD_Employee_ID__c;   

        if(orgName != 'Tech-Zone'){
            ref.Employees__c = ct.Account.Org_WCW_Count_Rep__c;
            ref.Street__c = ct.Account.Address1__c;
            ref.City__c = ct.Account.City__c;
            ref.State__c = ct.Account.State__c;
            ref.Postal_Code__c = ct.Account.Zip__c;
            ref.Country__c = ct.Account.Country__c;
            ref.Phone__c = ct.Phone1_Rep__c;
        }
        else{
            ref.Employees__c = ct.Account.NumberOfEmployees;
            ref.Street__c = ct.Account.BillingStreet;
            ref.City__c = ct.Account.BillingCity;
            ref.State__c = ct.Account.BillingState;
            ref.Postal_Code__c = ct.Account.BillingPostalCode;
            ref.Country__c = ct.Account.BillingCountry; 
            ref.Phone__c = ct.Phone;
        }   
        
        return ref; 
    }
    
    public static void compareSourceDestRecords(Referral__c src, Referral__c dest){
        //If source is referred by Tech-Zone, the destination is always an organization that doesn't support insert of these fields (excluding CompuCom).
        if(src.Referred_By__c == 'Tech-Zone'){
            src.Street__c = NULL;
            src.State__c = NULL;
            src.Country__c = NULL;
        }
        
        System.assertEquals(src.First_Name__c, dest.First_Name__c, 'First name does not match.');
        System.assertEquals(src.Last_Name__c, dest.Last_Name__c, 'Last name does not match.');
        System.assertEquals(src.Company__c, dest.Company__c, 'Company does not match.');
        System.assertEquals(src.Phone__c, dest.Phone__c, 'Phone does not match.');
        System.assertEquals(src.Email__c, dest.Email__c, 'Email does not match.');
        System.assertEquals(src.Title__c, dest.Title__c, 'Title does not match.');
        System.assertEquals(src.Lead_Source__c, dest.Lead_Source__c, 'Original lead source does not match.');
        System.assertEquals(src.Referred_By__c, dest.Referred_By__c, 'Source (referred by) does not match resulting record.');
        System.assertEquals(src.Referrer_Name__c, dest.Referrer_Name__c, 'Referrer name does not match.');
        System.assertEquals(src.Referrer_Phone__c, dest.Referrer_Phone__c, 'Referrer phone does not match.');
        System.assertEquals(src.Referrer_Email__c, dest.Referrer_Email__c, 'Referrer email does not match.');
        System.assertEquals(src.Referrer_Employee_ID__c, dest.Referrer_Employee_ID__c, 'Referrer employee ID does not match.');
        System.assertEquals(src.Referrer_Region__c, dest.Referrer_Region__c, 'Referrer region does not match.');
        System.assertEquals(src.Employees__c, dest.Employees__c, 'Number of employees does not match.');
        System.assertEquals(src.Street__c, dest.Street__c, 'Street address does not match.');
        System.assertEquals(src.City__c, dest.City__c, 'City does not match.');
        System.assertEquals(src.State__c, dest.State__c, 'State does not match.');
        System.assertEquals(src.Postal_Code__c, dest.Postal_Code__c, 'Zip does not match.');
        System.assertEquals(src.Phone__c, dest.Phone__c, 'Phone does not match.');
        
        //Cannot assert Country due to default picklist logic (see GT).
        //System.assertEquals(src.Country__c, dest.Country__c, 'Country does not match.');
        
        //Clear Country due to above comment.  All other values should match in assert below.
        src.Country__c = NULL;
        dest.Country__c = NULL;
        
        System.assertEquals(src, dest, 'An additional field of the two leads being compared does not match.');
    }
}