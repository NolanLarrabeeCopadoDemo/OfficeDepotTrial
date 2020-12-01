@isTest
public class MyUtilsDataFactory {
    /*
     * @description This class is used to Generate Test Data
     *
     * @author Adam A
     * @datecreated 2018-11-1
     *
     * @changes Log any modifications here...
     */

    public static List<Account> makeAccounts(Integer acctNum) {
        //make some Accounts
        List<Account> testAccts = new List<Account>();
        for (Integer x = 0; x < acctNum; x++) {
            Account a = new Account();
            a.Name = 'Test Account' + x;
            testAccts.add(a);
        }
        return testAccts;
    }

    public static List<Contact> makeContacts(Integer contactNum) {
        List<Contact> testContacts = new List<Contact>();
        for (Integer x = 0; x < contactNum; x++) {
            Contact c = new Contact();
            c.FirstName = 'Testing' + x;
            c.LastName = 'Contact' + x;
            c.MailingCity = 'Test City' + x;
            c.MailingStreet = 'Test City Ave' + x;
            c.MailingState = Math.mod(x, 2) == 0 ? null : (Math.mod(x, 3) ==
            0 ? 'NY' : 'OR');
            c.MailingPostalCode = Math.mod(x, 2) == 0 ? '1011 AJ' : (Math.mod(
                x,
                3
            ) ==
            0 ? '10006' : '97230');
            c.MailingCountry = Math.mod(x, 2) ==
            0 ? 'Amsterdam' : 'United States';
            testContacts.add(c);
        }
        return testContacts;
    }

    public static List<User> makeUsers(Integer userNumber) {
        List<User> testUsers = new List<User>();
        for (Integer x = 0; x < userNumber; x++) {
            testUsers.add(
                new User(
                    Username = 'tusr' + x + '@officedepot.com',
                    FirstName = 'testing_user',
                    LastName = '' + x,
                    Alias = 'tuserfct',
                    Email = 'tusr' + x + '@officedepot.com',
                    IsActive = true,
                    LocaleSidKey = 'en_US',
                    LanguageLocaleKey = 'en_US'
                )
            );
        }
        return testUsers;
    }

    /*******************************************************************************************************
     * @author Adam, adam.albright@officedepot.com, 22 March 2019
     * @description Generates Leads without saving them.
     * @param
     */
    public static List<Lead> makeLeads(Integer leadCount) {
        List<Lead> testLeads = new List<Lead>();
        Id dataloaderId = MyUtils.SuperUser().Id;
        Id leadRecordTypeId = Schema.SObjectType.Lead.getRecordTypeInfosByDeveloperName().get(
            'Lead_US'
        ).getRecordTypeId();
        for (Integer x = 0; x < leadCount; x++) {
            Lead led = new Lead();
            led.Inactive__c = false;
            led.FirstName = 'TestClassLead';
            led.LastName = 'Tested' + x;
            led.Phone = '321234534' + Math.mod(x, 3);
            led.Company = 'My Company ' + Math.mod(x, 9);
            led.OwnerId = dataloaderId;
            led.RecordTypeId = leadRecordTypeId;
            testLeads.add(led);
        }
        return testLeads;
    }
}