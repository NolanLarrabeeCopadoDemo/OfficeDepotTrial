/*************************************************************
*Name : OpportunityOverrideController
*Created By : Himanshu Sharma
*Created Date : 04-24-2020
*Purpose :02903377- New Opportunity Button Pointing to Qualifying Deal Creation.
*JIRA: NAIT-131982 
****************************************************************/
public with sharing class OpportunityOverrideController {

    @AuraEnabled(cacheable=true)
    public static Boolean getCorrectProfileName() {
     	boolean shouldRedirect; 
        List<Profile> currentUserProfile = [SELECT Id, Name FROM Profile WHERE Id =:UserInfo.getProfileId() LIMIT 1];
        List<Profile__c> currentProfileInUse=[SELECT id,Name from Profile__c where Name = :currentUserProfile[0].Name];
		
        if (currentProfileInUse.size() > 0){
            shouldRedirect = true;
        }else{
            shouldRedirect = false;
        }
        System.debug('data.shouldRedirect =>'+shouldRedirect );
      
        return shouldRedirect;
    }
}