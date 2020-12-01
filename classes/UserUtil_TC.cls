@isTest
private class UserUtil_TC{
    static testMethod void testWebService(){
        user u=[SELECT id,ProfileId FROM USER WHERE id =:UserInfo.getUserId()];
        user u1 = new user(Username='Saleuser@nikea.com',FirstName ='test', LastName='SalesUserNIKe', Alias='bun', CommunityNickname='ab', LocaleSidKey='en_US', EmailEncodingKey='UTF-8',FederationIdentifier='123412', ProfileId=u.ProfileId,IsActive=true, LanguageLocaleKey='en_US');
        
        UserUtils util = new UserUtils();
        Set<ID> IdSts = UserUtils.getAllmyReportees(u.Id);
    }
}