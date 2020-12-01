@isTest
private class UserFederationIds_TC{
    static testMethod void testWebService(){
        user u=[SELECT id,ProfileId FROM USER WHERE id =:UserInfo.getUserId()];
        user u1 = new user(Username='Saleuser@nike.com',FirstName ='test', LastName='SalesUser', Alias='bu', CommunityNickname='ab', LocaleSidKey='en_US', EmailEncodingKey='UTF-8',FederationIdentifier='1234', ProfileId=u.ProfileId,IsActive=true, LanguageLocaleKey='en_US');
        List<String> fedId=UserFederationIds.ReturnIds();
        
        soapUserFederationIds fed =new soapUserFederationIds();
        soapUserFederationIds.LogInfo logInf= new soapUserFederationIds.LogInfo();
        soapUserFederationIds.AllowFieldTruncationHeader_element all= new soapUserFederationIds.AllowFieldTruncationHeader_element();
        soapUserFederationIds.DebuggingHeader_element deb= new soapUserFederationIds.DebuggingHeader_element();
        soapUserFederationIds.CallOptions_element Opt = new soapUserFederationIds.CallOptions_element();
        soapUserFederationIds.ReturnIdsResponse_element ret = new soapUserFederationIds.ReturnIdsResponse_element();
        soapUserFederationIds.SessionHeader_element sess= new soapUserFederationIds.SessionHeader_element();
        soapUserFederationIds.DebuggingInfo_element debinf = new soapUserFederationIds.DebuggingInfo_element();
        soapUserFederationIds.UserFederationIds userfed = new soapUserFederationIds.UserFederationIds();
        soapUserFederationIds.ReturnIds_element retId = new soapUserFederationIds.ReturnIds_element();
        
        
    }

}