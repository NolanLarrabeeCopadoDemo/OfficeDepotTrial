@isTest
private class siteSearchC_TC {

	private static testMethod void test() {
	    Account newacct = new Account (name='testacct',address1__c='6600 n militarty trl',city__c='boca raton',state__c='FL',zip__c='33496',aops_cust_id__c='12345678');
	    insert newacct;
	    Account newacct2 = new Account (name='testacct2',address1__c='6600 n militarty trl',city__c='boca raton',state__c='FL',zip__c='33496',related_account__c=newacct.id);
	    insert newacct2;
	    siteSearchC sc = siteSearchC.doinit();
	    list<account> acts = siteSearchC.searchSites('123');
        acts = siteSearchC.searchsdata('123',null,null,null,'12345678');
        acts = siteSearchC.searchsdata(null,'123',null,null,null);
        acts = siteSearchC.searchsdata(null,null,'123',null,null);
        acts= siteSearchC.searchsdata(null,null,null,'123',null);
        acts = siteSearchC.searchsdata(null,null,null,null,'12345678');
        
	    list<account> actsnew = new list<account> ();
	    actsnew.add(newacct);
        Account aupd = siteSearchC.ActivateSite(newacct);
        list<Account> aupdlist = siteSearchC.UpdateMSites(actsnew,'Active');
        aupd = siteSearchC.DeactivateSite(newacct);
	}

}