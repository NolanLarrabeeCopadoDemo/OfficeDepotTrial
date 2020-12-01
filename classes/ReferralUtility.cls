/*
 * Utility used by multiple classes related to the Referrals functionality.
 *
 * @author: Andrew Smith (6/10/2018)
 */ 

public without sharing class ReferralUtility {
		
    public static List<Referral__c> getSourceReferrals(List<Referral__c> recs){
    	List<Referral__c> sourceReferrals =  new List<Referral__c>();
    	
    	for(Referral__c rec : recs){
    		if(!isSourceExternal(rec)){
				sourceReferrals.add(rec);
    		}
		}
		
		return sourceReferrals;
    }
    
    public static List<Referral__c> getDestinationReferrals(List<Referral__c> recs){
    	List<Referral__c> destinationReferrals = new List<Referral__c>();
    	
    	for(Referral__c rec : recs){
    		if(!isDestinationExternal(rec)){
				destinationReferrals.add(rec);
    		}
		}
		
		return destinationReferrals;
    }
    
    public static List<Referral__c> getAllSubmittedReferrals(List<Referral__c> recs){
    	List<Referral__c> allSubmittedReferrals = new List<Referral__c>();
    	
    	for(Referral__c rec : recs){
    		if(rec.Submitted__c){
				allSubmittedReferrals.add(rec);
    		}
		}
				
		return allSubmittedReferrals;
    }
    
    public static List<Referral__c> getUnsubmittedReferrals(List<Referral__c> recs){
    	List<Referral__c> unsubmittedReferrals = new List<Referral__c>();
    	
    	for(Referral__c rec : recs){
    		if(!rec.Submitted__c){
				unsubmittedReferrals.add(rec);
    		}
		}
				
		return unsubmittedReferrals;
    }
    
    public static List<Referral__c> getNewSubmittedReferrals(List<Referral__c> recs){
    	List<Referral__c> newSubmittedReferrals = new List<Referral__c>();
    	
    	for(Referral__c rec : recs){
    		if(rec.Status__c == 'Submitted'){
				newSubmittedReferrals.add(rec);
    		}
		}
				
		return newSubmittedReferrals;
    }
    
    public static List<Referral__c> getReadyToSubmitReferrals(List<Referral__c> recs){
    	List<Referral__c> readyReferrals = new List<Referral__c>();
    	
    	for(Referral__c rec : recs){
    		if(rec.Status__c == NULL || rec.Status__c  == 'Ready to Submit'){
				readyReferrals.add(rec);
    		}
		}
				
		return readyReferrals;
    }
    
    public static void setSubmittedStatus(List<Referral__c> recs){
    	for(Referral__c ref : recs){
			ref.Status__c = 'Submitted';
		}
    }
    
    public static void setLockedRecordType(List<Referral__c> recs){
    	for(Referral__c ref : recs){
			ref.RecordTypeId = Schema.SObjectType.Referral__c.getRecordTypeInfosByDeveloperName().get('Locked').getRecordTypeId();
		}
    }
    
    public static void setSubmittedRecordType(List<Referral__c> recs){
    	for(Referral__c ref : recs){
			if(isSourceExternal(ref)){
				ref.RecordTypeId = Schema.SObjectType.Referral__c.getRecordTypeInfosByDeveloperName().get('Submitted_External_Source').getRecordTypeId();
			}
			else if(isDestinationExternal(ref)){
				ref.RecordTypeId = Schema.SObjectType.Referral__c.getRecordTypeInfosByDeveloperName().get('Submitted_External_Destination').getRecordTypeId();
			}
			else{
				ref.RecordTypeId = Schema.SObjectType.Referral__c.getRecordTypeInfosByDeveloperName().get('Submitted_Internal').getRecordTypeId();
			}
		}
    }
    
    public static void setLastUpdateDate(List<Referral__c> recs){
    	for(Referral__c ref : recs){
			ref.Last_Update_Date__c = System.Now();
		}
    }
    
    public static void setSubmittedDate(List<Referral__c> recs){
    	for(Referral__c ref : recs){
			ref.Submitted_Date__c = System.Now();
		}
    }
    
    public static Boolean isCustomerAccount(Account acct){
    	Set<ID> custAccountRecordTypeIds = new Set<ID>();
    	
    	//RT Label: Customer (Tech-Zone)
		custAccountRecordTypeIds.add(Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Tech_Zone_Customer').getRecordTypeId() );
		//RT Label: Customer
		custAccountRecordTypeIds.add(Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Customer').getRecordTypeId() );
		//RT Label: Customer (GT)
		custAccountRecordTypeIds.add(Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Customer_GT').getRecordTypeId() );
		//RT Label: Customer(BizBox)
		custAccountRecordTypeIds.add(Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Customer_BizBox').getRecordTypeId() );
		
		return custAccountRecordTypeIds.contains(acct.RecordTypeId);
    }
    
    public static Boolean isDestinationExternal(Referral__c ref){
    	Boolean isExternal = false;
    	
    	if(ref.Referred_To__c == 'CompuCom'){
    		isExternal = true;
    	}
    	
    	return isExternal;
    }
    
    public static Boolean isSourceExternal(Referral__c ref){
    	Boolean isExternal = false;
    	
    	if(ref.Referred_By__c == 'CompuCom'){
    		isExternal = true;
    	}
    	
    	return isExternal;
    }
    
    //Map of record type IDs supported to the org names (same list as Referered By/To picklist)
    public static Map<ID, String> getValidLeadRecordTypesByID(){
    	Map<ID, String> recordTypeSourceMap = new Map <ID, String>();
    	
    	//RT Label: Lead (Tech-Zone)
		recordTypeSourceMap.put(Schema.SObjectType.Lead.getRecordTypeInfosByDeveloperName().get('Tech_Zone').getRecordTypeId(), 'Tech-Zone' );
		//RT Label: Lead (US)
		recordTypeSourceMap.put(Schema.SObjectType.Lead.getRecordTypeInfosByDeveloperName().get('Lead_US').getRecordTypeId(), 'BSD' );
		//RT Label: Lead (Canada)
		recordTypeSourceMap.put(Schema.SObjectType.Lead.getRecordTypeInfosByDeveloperName().get('Lead_Canada').getRecordTypeId(), 'Grand & Toy' );
		//RT Label: Lead (BizBox)
		recordTypeSourceMap.put(Schema.SObjectType.Lead.getRecordTypeInfosByDeveloperName().get('Lead_BizBox').getRecordTypeId(), 'BizBox' );
		
		return recordTypeSourceMap;
    }
    
    //Map of record type IDs supported to the org names (same list as Referered By/To picklist)
    public static Map<ID, String> getValidContactRecordTypesById(){
    	Map<ID, String> recordTypeSourceMap = new Map <ID, String>();
    	
    	//RT Label: Contact (Tech-Zone)
		recordTypeSourceMap.put(Schema.SObjectType.Contact.getRecordTypeInfosByDeveloperName().get('Tech_Zone').getRecordTypeId(), 'Tech-Zone' );
		//RT Label: Contact (US)
		recordTypeSourceMap.put(Schema.SObjectType.Contact.getRecordTypeInfosByDeveloperName().get('Contact_US').getRecordTypeId(), 'BSD' );
		//RT Label: GT Contact	
		recordTypeSourceMap.put(Schema.SObjectType.Contact.getRecordTypeInfosByDeveloperName().get('GT_Contact').getRecordTypeId(), 'Grand & Toy' );
		//RT Label: Contact(BizBox)
		recordTypeSourceMap.put(Schema.SObjectType.Contact.getRecordTypeInfosByDeveloperName().get('Contact_BizBox').getRecordTypeId(), 'BizBox' );
		
		return recordTypeSourceMap;
    }
    
    public static Map<String, ID> getValidLeadRecordTypeIdsByOrgName(){
    	Map<String, ID> nameMap = new Map <String, ID>();
    
    	Map<ID, String> idMap = getValidLeadRecordTypesById();
    	
    	for(ID rtId : idMap.keySet()){
    		nameMap.put(idMap.get(rtId), rtId);
    	}
    	
    	return nameMap;    	
    }
    
    public static Map<String, ID> getValidContactRecordTypeIdsByOrgName(){
   	 	Map<String, ID> nameMap = new Map <String, ID>();
    
    	Map<ID, String> idMap = getValidContactRecordTypesById();
    	
    	for(ID rtId : idMap.keySet()){
    		nameMap.put(idMap.get(rtId), rtId);
    	}
    	
    	return nameMap;    	
    }
    
    public static ID getLeadRecordTypeID(String orgName){
    	return getValidLeadRecordTypeIdsByOrgName().get(orgName);    	
    }
    
    public static ID getContactRecordTypeID(String orgName){
    	return getValidContactRecordTypeIdsByOrgName().get(orgName);    	
    }
 
}