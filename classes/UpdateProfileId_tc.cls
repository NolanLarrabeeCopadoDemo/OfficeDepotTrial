@isTest(SeeAllData=true)
private class UpdateProfileId_tc{
    static testMethod void UpdateProfileIdMethod (){
        User_Setting__c usrSetting = new User_Setting__c (name='987654',
                                                          Profile_Name__c='Operations');
        insert usrSetting ;
    }
}