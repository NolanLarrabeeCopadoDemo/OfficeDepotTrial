@isTest
public class AddContactController_Test{

    static testmethod void method1(){
    
        UserRole r = new UserRole(name = 'TEST ROLE');
        insert r;
       
        
        Profile prof1 = [SELECT Id FROM Profile WHERE Name = 'System Administrator'];
        User u1 = new User(Alias = 'standt', Email = 'AddContactController_Test_U1@officedepot.com',
                EmailEncodingKey = 'UTF-8', LastName = 'Testing', LanguageLocaleKey = 'en_US',
                LocaleSidKey = 'en_US', ProfileId = prof1.Id, userroleid = r.Id,
                TimeZoneSidKey = 'America/Los_Angeles', UserName = 'AddContactController_Test_U1@officedepot.com');

        insert u1;
        
        Profile profileId = [SELECT Id FROM Profile WHERE (Name = 'Partner Community User Custom') LIMIT 1];
        //String strRecordTypeId = [Select Id From RecordType Where SobjectType = 'Account'].Id;

        // Running as Newly Created Admin User
        system.runAs(u1) {
        
            Account acc = new Account();
            acc.Name = 'test';
            //acc.RecordTypeId = strRecordTypeId;
            acc.OwnerId = u1.Id;

            Insert acc;
            
            
            Account acc1 = new Account();
            acc1.Name = 'test1';
            //acc.RecordTypeId = strRecordTypeId;
            acc1.OwnerId = u1.Id;
            Insert acc1;
            
            Account acc2 = new Account();
            acc2.Name = 'test2';
            //acc.RecordTypeId = strRecordTypeId;
            acc2.OwnerId = u1.Id;
            Insert acc2;

            
            Contact c = new contact();
            c.firstName = 'FN';
            c.lastName = 'LN';
            c.AccountId = acc.Id;
            Insert c;
            
            contact con2 = new contact();
            con2.firstName = 'FirstName';
            con2.lastName = 'LastName';
            con2.AccountId = acc1.Id;
            con2.Email = 'Contact@officedepot.com';
            Insert con2;
            
            
            contact con3 = new contact();
            con3.firstName = 'FirstName';
            con3.lastName = 'LastName';
            con3.AccountId = acc2.Id;
            con3.Email = 'Contact3@officedepot.com';
            Insert con3;
            
           user portalUser= new user(LastName = 'LIVESTON',
                    FirstName = 'JASON', Alias = 'jliv',
                    Email = 'AddContactController_Test@officedepot.com',
                    Username = 'AddContactController_Test@officedepot.com',
                    ProfileId = profileId.id,  
                    ContactId = c.id,
                                 
                    TimeZoneSidKey = 'America/Los_Angeles',
                    LanguageLocaleKey = 'en_US',
                    EmailEncodingKey = 'UTF-8',
                    LocaleSidKey = 'en_US'
            );
            insert portalUser;
            
            System.RunAs(portalUser){
                AddContactController  addController = new AddContactController();
            
                AddContactController.getAccountName();
                test.StartTest();
                
                Try{
                    AddContactController.saveContact(con2,r.name);
                 }
                catch(Exception e){
                    system.debug('==>Exception'+ e);
                }
            
            test.StopTest();
                }
                  
            }
        }
    
    static testmethod void method2(){
        
        
        UserRole r = new UserRole(name = 'TEST ROLE');
        insert r;
        
        UserRole r1 = new UserRole(name = 'test Partner User', PortalType = 'None');
        insert r1;
      
        Profile prof1 = [SELECT Id FROM Profile WHERE Name = 'System Administrator'];
        
        User u1 = new User(Alias = 'standt', Email = 'EnableandDisableuser_Test@officedepot.com',
                EmailEncodingKey = 'UTF-8', LastName = 'Testing', LanguageLocaleKey = 'en_US',
                LocaleSidKey = 'en_US', ProfileId = prof1.Id, userroleid = r.Id,
                TimeZoneSidKey = 'America/Los_Angeles', UserName = 'EnableandDisableuser2_Test@officedepot.com');

        insert u1;
        
        Profile profileId = [SELECT Id FROM Profile WHERE (Name = 'Partner Community User Custom') LIMIT 1];

        system.runAs(u1) {
        
            Account acc = new Account();
            acc.Name = 'test';
            //acc.RecordTypeId = strRecordTypeId;
            acc.OwnerID = u1.id;
            Insert acc;
            
            Contact c = new contact();
            c.firstName = 'FN';
            c.lastName = 'LN';
            c.Email = 'EnableandDisableuser_Test4@officedepot.com';
            c.AccountId = acc.Id;
            Insert c;
            
            Try{
                Test.StartTest();
                AddContactController.addUser(c.Id, 'Worker');
                test.Stoptest();
                
            }
            Catch(Exception e){
                system.debug('==>e' +e);
            }
    
        }
    }
 }