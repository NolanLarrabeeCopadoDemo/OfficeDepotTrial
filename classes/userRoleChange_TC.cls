@isTest(SeeAllData=false)

private class userRoleChange_TC {

    static testMethod void myUnitTest() {
    
       System.runAs(new User(Id = UserInfo.getUserId())){//Sales - West - Alberta Reps
             role_details__c roleDetails = new role_details__c(role__c = 'CRM Leadership', region__c='Asia',district__c='abc',market__c='pqr');
           try{
               insert roleDetails;
           }
           catch(exception ex){
               
           }
        }
       UserRole ur = [SELECT Id
                             FROM UserRole where developername =:'Sales_West'];
         UserRole ur1 = [SELECT Id
                             FROM UserRole where developername =:'Sales_West_Alberta'];
         UserRole ur2 = [SELECT Id
                             FROM UserRole where developername =:'Sales_West_Alberta_Reps'];
        
        
        user u = new user(userroleid=ur.Id,managerid='005E0000000nAShIAM',
                          LocaleSidKey='en_US',EmailEncodingKey='ISO-8859-1',
                          LanguageLocaleKey='en_US',
                          profileid='00eE0000000HzxrIAC',
                          lastname='test',alias='test',OD_Employee_ID__c='996734',
                          Username='996734@officedepot.com.uat',
                          TimeZoneSidKey = 'America/Los_Angeles', 
                          email='996734@officedepot.com');
       //  try{
              insert u;
         //  }
           ////catch(exception ex){
               
           //}
      
        
        user u2 = new user(userroleid=ur1.Id,
                           managerid=u.Id,
                           LocaleSidKey='en_US',
                           EmailEncodingKey='ISO-8859-1',
                           LanguageLocaleKey='en_US',
                           profileid='00eE0000000HzxrIAC',
                           lastname='testt',alias='testt',
                           OD_Employee_ID__c='996731',
                           Username='996731@officedepot.com.uat',
                           TimeZoneSidKey = 'America/Los_Angeles',email='996731@officedepot.com');
        //try{
              insert u2;
          // }
           //catch(exception ex){
               
           //}
        
        u.userroleid = ur2.Id;
        u.managerid = '005E0000001FuZdIAK';
         //try{
              update u;
          // }
           //catch(exception ex){
               
           //}
       
     }
   
   }