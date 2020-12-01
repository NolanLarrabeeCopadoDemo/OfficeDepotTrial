@isTest
private class setRessaignOpportunity_TC 
{

    static testMethod void setRessaignOpportunityUnitTest() 
    {
    
        Profile profileObj = [select id from profile where name='System Administrator'];
        String profId = profileObj.id;
        
        string managerEmpId = '123654';
        string managerEmail = 'bcd@officedepot.com.uat';
        string managerUserName=managerEmail;
        string[] managerName = managerUserName.split('@');
        user managerUsr = new user(Username=managerUserName,FirstName =managerName[1], LastName=managerName[0], Alias=managerName[0], CommunityNickname=managerUserName, LocaleSidKey='en_US', EmailEncodingKey='UTF-8', Profileid = profId, LanguageLocaleKey='en_US');
        managerUsr.email=managerEmail;
        managerUsr.MB_Expiration_Date__c = System.now().addminutes(1);
        managerUsr.OD_Employee_ID__c =managerEmpId;
        managerUsr.IsActive=True;
        managerUsr.TimeZoneSidKey='America/Los_Angeles';
        Insert managerUsr;
        
        string empId = '456123';
        string email = 'abc@officedepot.com.uat';
        string userName=email;
        string[] name = userName.split('@');
        user u = new user(Username=userName,FirstName =name[1], LastName=name[0], Alias=name[0], CommunityNickname=userName, LocaleSidKey='en_US', EmailEncodingKey='UTF-8', Profileid = profId, LanguageLocaleKey='en_US');
        u.email=email;
        u.Managerid=managerUsr.id;
        u.MB_Expiration_Date__c = System.now().addminutes(1);
        u.OD_Employee_ID__c =empId;
        u.IsActive=False;
        u.TimeZoneSidKey='America/Los_Angeles';
        Insert u;
        
        test.startTest();
        u.isActive = True;
        update u;
        managerUsr.isActive = False;
        update managerUsr;
        test.stopTest();
        
        u = [SELECT Id, isManager__c, Reassgin_Opportunity__c FROM User WHERE Id =: u.Id];
        System.assertEquals(False, u.isManager__c);
        System.assertEquals('C', u.Reassgin_Opportunity__c);
        
        managerUsr = [SELECT Id, isManager__c, Reassgin_Opportunity__c FROM User WHERE Id =: managerUsr.Id];
        System.assertEquals(True, managerUsr.isManager__c);
        System.assertEquals('NP', managerUsr.Reassgin_Opportunity__c);
        
        /*test.starttest();
        managerUsr.IsActive=true;
        update managerUsr;
        test.stoptest();
        u.IsActive=false;
        update u;

        u.IsActive=true;
        update u;
        
        user odsfaUser = [select id,name from user where id ='005E0000000nAh9IAE' limit 1];
        
        System.runAs(odsfaUser)
        {
        managerUsr.IsActive=false;
        update managerUsr;
        
        u.IsActive=false;
        update u;
        
        }
        
        */
    }
}