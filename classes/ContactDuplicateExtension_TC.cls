@isTest
private class ContactDuplicateExtension_TC {

	private static testMethod void test() {
	    Account a = Test_Utils.createAccount('Customer');
	    insert a;
	    
        Contact c = new Contact(LastName = 'TEST', AccountId = a.Id, MailingCountry = 'USA', Master__c = true);
        insert c;
        
        c.Duplicate_Of__c = c.Id;
        update c;
        
        Contact c2 = new Contact(LastName = 'TEST', AccountId = a.Id, MailingCountry = 'USA', Master__c = false, Duplicate_Of__c = c.Id, 
            Override_Duplicate_Check__c = true);
        insert c2;
        
        ApexPages.StandardController stdCon = new ApexPages.StandardController(c);
        PageReference pageRef = Page.ContactDuplicate;
        pageRef.getParameters().put('id', String.valueOf(c.Id));
        Test.setCurrentPage(pageRef);
        
        ContactDuplicateExtension controller = new ContactDuplicateExtension(stdCon);
	}

}