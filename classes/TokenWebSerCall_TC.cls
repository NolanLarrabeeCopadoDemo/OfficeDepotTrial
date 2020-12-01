@isTest
private class TokenWebSerCall_TC{

    static testMethod void testWebSvc(){
        user u2=[SELECT id,ProfileId FROM USER WHERE id =:UserInfo.getUserId()];
    
    
        user u1 = new user(Username='jas@acme.com',FirstName ='test', LastName='abc', Alias='b', CommunityNickname='ab', LocaleSidKey='en_US', EmailEncodingKey='UTF-8', ProfileId=u2.ProfileId, LanguageLocaleKey='en_US');
        //u.name = 'abc';
        u1.email='xyz@officedepot.com';
        u1.MB_Expiration_Date__c = System.now().addminutes(1);
        u1.OD_Employee_ID__c ='xxyy123457';
        u1.Token_Market_Builder__c ='abc';
        u1.TimeZoneSidKey = 'America/Los_Angeles';
        Insert u1;
    
        user u = new user(Username='jasmeet@acme.com',FirstName ='test', LastName='xyz', Alias='a', CommunityNickname='aa', LocaleSidKey='en_US', EmailEncodingKey='UTF-8', ProfileId=u2.ProfileId, LanguageLocaleKey='en_US');
        //u.name = 'abc';
        u.email='abc@officedepot.com';
        u.MB_Expiration_Date__c = System.now().addminutes(1);
        //LSLEVIN 2.10.16 S-376887 updated below lines employee id to include OD
        u.OD_Employee_ID__c ='OD123456';
        u.Manager = u1;
        u.TimeZoneSidKey = 'America/Los_Angeles';
        u.Token_Market_Builder__c ='abc';
        Insert u;
        
        
        TokenWebSerCall.TokenWebSerCallInput inp = new  TokenWebSerCall.TokenWebSerCallInput();
        inp.Token = 'abc';
        inp.EmpId='xxyy123456';
        TokenWebSerCall.TokenWebSerCallResponse outp = new TokenWebSerCall.TokenWebSerCallResponse();
         
        TokenWebSerCall ws =new TokenWebSerCall();
        
        TokenWebSerCall.methodCall(inp);        
        u.Token_Market_Builder__c ='xyz';
        update u;
        
        TokenWebSerCall.methodCall(inp);
        
        
    }

}