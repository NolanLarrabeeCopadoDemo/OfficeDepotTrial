/*************************************************************
*Name : AccountOverrideController
*Created By : Sandesh Ganjare
*Created Date : 04-17-2020
*Purpose : 02885348 - Lightning - Record Types Pointing to the Correct Flow.
*JIRA: NAIT-130081s
****************************************************************/
public with sharing class AccountOverrideController {
    /*public AccountOverrideController() {

    }*/
    public class DataWrapper{
        @AuraEnabled
        public boolean shouldRedirect;   
        @AuraEnabled 
        public String redirectPage;   
        @AuraEnabled
        public List<recordTypeWrapper> recordTypes;
      }
    
    public class recordTypeWrapper{
        @AuraEnabled
        public String Id;
        @AuraEnabled
        public String label;
    }

    @AuraEnabled(cacheable=true)
    public static DataWrapper getRecordTypeData() {
        DataWrapper data = new DataWrapper();
        List<recordTypeWrapper> recordTypeList = new List<recordTypeWrapper>();
        List<Profile> currentUserProfile = [SELECT Id, Name FROM Profile WHERE Id =:UserInfo.getProfileId() LIMIT 1];
        List<Redirect_Profile__c> profilesToNotRedirect = [SELECT Id, Name,Redirect_Page__c FROM Redirect_Profile__c WHERE Name = :currentUserProfile[0].Name limit 1] ;
        User currentUser = [SELECT Id, GrandParent_User__c FROM User WHERE Id =:UserInfo.getUserId()];

        if (profilesToNotRedirect.size() > 0){
            data.shouldRedirect = true;
            data.redirectPage = profilesToNotRedirect[0].Redirect_Page__c;
        }else{
            data.shouldRedirect = false;
        }
        System.debug('data.shouldRedirect =>'+data.shouldRedirect );
        //Map<String,String> recordTypesMap = new Map<String,String>();
        for(RecordTypeInfo info: Account.SObjectType.getDescribe().getRecordTypeInfos()) {
            if(info.isAvailable() && info.getName() !='Master') {
                //recordTypesMap.put(info.getRecordTypeId(), info.getName());
                recordTypeWrapper rtw = new recordTypeWrapper();
                rtw.Id=info.getRecordTypeId();
                rtw.label=info.getName();
                recordTypeList.add(rtw);
            }
        }
        System.debug('recordTypeList=>'+recordTypeList);
        data.recordTypes = recordTypeList;

        return data;
    }
}