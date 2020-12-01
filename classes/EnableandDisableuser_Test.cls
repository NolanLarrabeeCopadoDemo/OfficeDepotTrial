@isTest
public class EnableandDisableuser_Test{

    static testmethod void method1(){
    
        UserRole r = new UserRole(name = 'TEST ROLE');
        insert r;
      
        Profile prof1 = [SELECT Id FROM Profile WHERE Name = 'System Administrator'];
        
        User u1 = new User(Alias = 'standt', Email = 'EnableandDisableuser_Test@officedepot.com',
                EmailEncodingKey = 'UTF-8', LastName = 'Testing', LanguageLocaleKey = 'en_US',
                LocaleSidKey = 'en_US', ProfileId = prof1.Id, userroleid = r.Id,
                TimeZoneSidKey = 'America/Los_Angeles', UserName = 'EnableandDisableuser_Test@officedepot.com');

        insert u1;
        
        Profile profileId = [SELECT Id FROM Profile WHERE (Name = 'Partner Community User Custom') LIMIT 1];
        //String strRecordTypeId = [Select Id From RecordType Where SobjectType = 'Account'].Id;

        // Running as Newly Created Admin User
        system.runAs(u1) {
        
            Account acc = new Account();
            acc.Name = 'test';
            //acc.RecordTypeId = strRecordTypeId;
            Insert acc;
            
            
            Account acc1 = new Account();
            acc1.Name = 'test';
            //acc.RecordTypeId = strRecordTypeId;
            Insert acc1;
            
            Contact c = new contact();
            c.firstName = 'FN';
            c.lastName = 'LN';
            c.Email = 'EnableandDisableuser_Test@officedepot.com';
            c.AccountId = acc.Id;
            Insert c;
            
            
            Contact c1 = new contact();
            c1.firstName = 'FN';
            c1.lastName = 'LN';
            c1.Email = 'EnableandDisableuser1_Test@officedepot.com';
            c1.AccountId = acc1.Id;
            Insert c1;
            
           user portalUser= new user(LastName = 'LN',
                    FirstName = 'FN', Alias = 'jliv',
                    Email = 'EnableandDisableuser_Test@officedepot.com',
                    Username = 'EnableandDisableuser_Test1@officedepot.com',
                    ProfileId = profileId.id,  
                    ContactId = c.id,
                    IsActive = true,           
                    TimeZoneSidKey = 'America/Los_Angeles',
                    LanguageLocaleKey = 'en_US',
                    EmailEncodingKey = 'UTF-8',
                    LocaleSidKey = 'en_US'
            );
            insert portalUser;
            
            
           user portalUser1= new user(LastName = 'LN',
                    FirstName = 'FN', Alias = 'jliv',
                    Email = 'EnableandDisableuser_Test@officedepot.com',
                    Username = 'EnableandDisableuser_Test2@officedepot.com',
                    ProfileId = profileId.id,  
                    ContactId = c1.id,
                    IsActive = false,           
                    TimeZoneSidKey = 'America/Los_Angeles',
                    LanguageLocaleKey = 'en_US',
                    EmailEncodingKey = 'UTF-8',
                    LocaleSidKey = 'en_US'
            );
            insert portalUser1;
            
            Try{
            Test.startTest();
            EnableandDisableuser  enadisUser = new EnableandDisableuser();
            EnableandDisableuser.initHelperMeth(c.id);
            EnableandDisableuser.deactivateUser(portalUser.id);
            EnableandDisableuser.enableUser(portalUser.id);
            
            
            EnableandDisableuser.deactivateUser(portalUser1.id);
            EnableandDisableuser.enableUser(portalUser1.id);
            test.StopTest();
            }
            catch(Exception e){
                system.debug('==>e' +e);
            }
            
    }
    
}

  static testmethod void method2(){
  
        UserRole r = new UserRole(name = 'TEST ROLE');
        insert r;
      
        Profile prof1 = [SELECT Id FROM Profile WHERE Name = 'System Administrator'];
        
        User u1 = new User(Alias = 'standt', Email = 'EnableandDisableuser_Test@officedepot.com',
                EmailEncodingKey = 'UTF-8', LastName = 'Testing', LanguageLocaleKey = 'en_US',
                LocaleSidKey = 'en_US', ProfileId = prof1.Id, userroleid = r.Id,
                TimeZoneSidKey = 'America/Los_Angeles', UserName = 'EnableandDisableuser2_Test@officedepot.com');

        insert u1;
        
        Profile profileId = [SELECT Id FROM Profile WHERE (Name = 'Partner Community User Custom') LIMIT 1];
        //String strRecordTypeId = [Select Id From RecordType Where SobjectType = 'Account'].Id;

        // Running as Newly Created Admin User
        system.runAs(u1) {
        
            Account acc = new Account();
            acc.Name = 'test';
            //acc.RecordTypeId = strRecordTypeId;
            Insert acc;
            
            Contact c = new contact();
            c.firstName = 'FN';
            c.lastName = 'LN';
            c.Email = 'EnableandDisableuser_Test@officedepot.com';
            c.AccountId = acc.Id;
            Insert c;
            
           user portalUser= new user(LastName = 'LN',
                    FirstName = 'FirstName', Alias = 'jliv',
                    Email = 'EnableandDisableuser_Test@officedepot.com',
                    Username = 'EnableandDisableuser_Test2@officedepot.com',
                    ProfileId = profileId.id,  
                    ContactId = c.id,
                    IsActive = false,           
                    TimeZoneSidKey = 'America/Los_Angeles',
                    LanguageLocaleKey = 'en_US',
                    EmailEncodingKey = 'UTF-8',
                    LocaleSidKey = 'en_US'
            );
            insert portalUser;
            
            EnableandDisableuser  enadisUser = new EnableandDisableuser();
            Try{
                test.startTest();
                EnableandDisableuser.initHelperMeth(c.id);
                test.stoptest();
            }
            catch(exception e){
                system.debug('==>e2'+ e);
           
            }
            
        }
  
  }
}