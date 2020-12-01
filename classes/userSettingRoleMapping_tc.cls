@isTest
private class userSettingRoleMapping_tc{
    static testMethod void userSettingRoleMappingTest (){
    
        User_Setting__c usrSetting = new User_Setting__c(Name = 'USSTO:000540:');
        insert usrSetting;
        User_Setting__c usrSetting2 = new User_Setting__c(Name = '000019');
        insert usrSetting2;
        List<User_Staging__c> userStagingList = new List<User_Staging__c>();
        
        User_Staging__c usrStaging = new User_Staging__c(Email__c='abcd@officedepot.com',OD_Employee_Number__c='282043',Title__c='USSTO:000540:Sales Consultant-Print Serv');
        //usrStaging.TermDate__c= 2014-07-13;
        userStagingList.add(usrStaging);
        
        User_Staging__c stagingObj = new User_Staging__c();
        
        stagingObj.City__c = 'Boca Raton';
        //stagingObj.TermDate__c = '#N/A';
        stagingObj.Division__c = '#N/A';
        stagingObj.Local__c = 'en_US';
        stagingObj.Email__c = 'test1@officedepot.com';
        stagingObj.UserName__c = 'test1@officedepot.com';
        stagingObj.Country__c = 'USA';
        stagingObj.Language__c = 'en_US';
        stagingObj.Cell__c = '561/202-7556';
        //stagingObj.Name = '';
        stagingObj.Title__c = 'USCOR:008698:Manager, Sr. SC Training';
        stagingObj.Manager_Employee_Number__c = '45454';
        stagingObj.Postal_Code__c = '33496-2434';
        stagingObj.State__c = 'FL';
        stagingObj.OD_Employee_Number__c = '19';
        stagingObj.Comapny_Name__c = 'Office Depot';
        stagingObj.Address__c = '6600 N Military Trail';
        stagingObj.Phone__c = '561/438-4013';
        stagingObj.Federation_Identifier__c = '19';
        stagingObj.HireDate__c = Date.today();
        stagingObj.Fax__c  = '#N/A';
        stagingObj.Last_Name__c = 'User';
        
        userStagingList.add(stagingObj);
        
        User_Staging__c stagingObj1 = new User_Staging__c();
        
        stagingObj1.City__c = 'Boca Raton';
        //stagingObj1.TermDate__c = '#N/A';
        stagingObj1.Division__c = 'A';
        stagingObj1.Local__c = 'en_US';
        stagingObj1.Email__c = 'test2@officedepot.com';
        stagingObj1.UserName__c = 'test2@officedepot.com';
        stagingObj1.Country__c = 'USA';
        stagingObj1.Language__c = 'en_US';
        stagingObj1.Cell__c = '562/202-7556';
        //stagingObj1.Name = '';
        stagingObj1.Title__c = 'USCOR:008698:Manager, Sr. SC Training';
        stagingObj1.Manager_Employee_Number__c = '40454';
        stagingObj1.Postal_Code__c = '33496-2434';
        stagingObj1.State__c = 'FL';
        stagingObj1.OD_Employee_Number__c = '18';
        stagingObj1.Comapny_Name__c = 'Office Depot';
        stagingObj1.Address__c = '6600 N Military Trail';
        stagingObj1.Phone__c = '562/438-4013';
        stagingObj1.Federation_Identifier__c = '18';
        stagingObj1.HireDate__c = Date.today();
        stagingObj1.Fax__c  = '#N/A';
        stagingObj1.Last_Name__c = 'User2';
        
        userStagingList.add(stagingObj1);
        
        System.Debug('@@@BeforeInsert-userStagingList@@@'+userStagingList);
        
        insert userStagingList;
        
        Set<ID> ids = new Set<ID>();
        for(User_Staging__c us : userStagingList)
        ids.add(us.id);
        
         List<User_Staging__c> UpdatedStagingObj = [select Division__c,Fax__c,OD_Employee_Number__c,Federation_Identifier__c,Manager_Employee_Number__c from User_Staging__c where id in :ids];
        
        System.Debug('@@@AfterInsert-UpdatedStagingObj@@@'+UpdatedStagingObj);
        
    }
}