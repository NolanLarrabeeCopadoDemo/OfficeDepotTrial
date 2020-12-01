@isTest()
public class MedalliaIntegrationBulkFromContactsTest {
    public static testMethod void testOutboundMessageWithBasicAuth() {
        Account a = new Account();
        a.Name = 'Acc';
		insert a;
        
        List<Account> aList = new List<Account>();
        aList.add(a);
        
        MedalliaBulkedInvitationsFromContacts.surveyPayload sp = new MedalliaBulkedInvitationsFromContacts.surveyPayload();
        sp.endpoint = 'https://instance.medallia.com/company.feed';
        sp.fieldSet = 'medalliaOutbound_createSurvey';
        sp.service = 'sfdc_test';
        sp.password = 'Medallia123';
        sp.accountsToSurvey = aList;

        Contact c = new Contact();
        c.FirstName = 'Con';
        c.LastName = 'tact';
        c.Email = Crypto.getRandomInteger()+'cont@contac.test.com.medalliadev';
        c.Title = 'test maker';
		c.AccountId = a.Id;
        c.Medallia_Include_in_surveys__c = true;

        insert c;

        List<MedalliaBulkedInvitationsFromContacts.surveyPayload> splist = new List<MedalliaBulkedInvitationsFromContacts.surveyPayload>();
        splist.add(sp);
        MedalliaBulkedInvitationsFromContacts.sendToMedallia(splist);

    }
    public static testMethod void testOutboundMessageWithoutBasicAuth() {
        Account a = new Account();
        a.Name = 'Acc';
		insert a;
        
        List<Account> aList = new List<Account>();
        aList.add(a);
        
        MedalliaBulkedInvitationsFromContacts.surveyPayload sp = new MedalliaBulkedInvitationsFromContacts.surveyPayload();
        sp.endpoint = 'https://instance.medallia.com/company.feed';
        sp.fieldSet = 'medalliaOutbound_createSurvey';
        sp.service = 'sfdc_test';
        sp.accountsToSurvey = aList;

        Contact c = new Contact();
        c.FirstName = 'Con';
        c.LastName = 'tact';
        c.Email = Crypto.getRandomInteger()+'cont@contac.test.com.medalliadev';
        c.Title = 'test maker';
        c.AccountId = a.Id;
        c.Medallia_Include_in_surveys__c = true;

        insert c;

        List<MedalliaBulkedInvitationsFromContacts.surveyPayload> splist = new List<MedalliaBulkedInvitationsFromContacts.surveyPayload>();
        splist.add(sp);
        MedalliaBulkedInvitationsFromContacts.sendToMedallia(splist);

    }
    
    public static testMethod void testOutboundMessageNegative() {
        Account a = new Account();
        a.Name = 'Acc';
		insert a;
        
        List<Account> aList = new List<Account>();
        aList.add(a);
        
        MedalliaBulkedInvitationsFromContacts.surveyPayload sp = new MedalliaBulkedInvitationsFromContacts.surveyPayload();
        sp.endpoint = 'https://instance.medallia.com/company.feed';
        sp.fieldSet = 'fail_medalliaOutbound_createSurvey';
        sp.service = 'sfdc_test';
        sp.accountsToSurvey = aList;

        Contact c = new Contact();
        c.FirstName = 'Con';
        c.LastName = 'tact';
        c.Email = Crypto.getRandomInteger()+'cont@contac.test.com.medalliadev';
        c.Title = 'test maker';
        c.AccountId = a.Id;
        c.Medallia_Include_in_surveys__c = true;

        insert c;

        List<MedalliaBulkedInvitationsFromContacts.surveyPayload> splist = new List<MedalliaBulkedInvitationsFromContacts.surveyPayload>();
        splist.add(sp);
        MedalliaBulkedInvitationsFromContacts.sendToMedallia(splist);

    }
}