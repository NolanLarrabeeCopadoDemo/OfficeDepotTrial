public class SiteContactCtrl {
    public ID AccountID {get;set;}
    public ID SiteID {get;set;}
    public list<Contact> contactMatches {get;set;}
    public contactSearch cSearch {get;set;}
    public boolean searchRender {get;set;}
    public ID SelectedContact {get;set;}
    public Account siteAcct {get;set;}
    
    public class contactSearch {
        public String firstName {get;set;}
        public String lastName {get;set;}
        public String email {get;set;}
        public String phone {get;set;}
    }
    
    public SiteContactCtrl(ApexPages.StandardController controller) {
        
        searchRender=false;
        system.debug('Constructor Call');
        cSearch = new contactSearch();
        contactMatches = new list<Contact>();
        AccountID = ApexPages.currentPage().getParameters().get('AccountID');
        SiteID = ApexPages.currentPage().getParameters().get('SiteID');
        siteAcct = [select Account.Related_Account__c,NAME,ID,Address1__c,City__c,State__c,Zip__c,Country__c FROM ACCOUNT WHERE ID=:SiteID];
    }
    
    public void populateMatchingContacts() {
        String searchSQL = 'Select id,firstname,lastname,email,phone from contact where accountId=\'' + AccountID+'\'';
        if (cSearch.firstName != null && cSearch.firstName != '') {
              searchSQL = SearchSQL+' and firstname like \''+cSearch.firstName+'%\'';
        }           
        if (cSearch.LastName !=null && cSearch.LastName != '') {
            searchSQL = searchSQL+ ' and lastname like \''+cSearch.lastName+'%\'';
        }
        if (cSearch.email != null && cSearch.email != '') {
            searchSQL=searchSQL+ ' and email like \''+csearch.email+'%\'';
        }
        if (cSearch.phone != null && cSearch.phone != '') {
            searchSQL=searchSQL+' and phone like \''+csearch.phone+'%\'';
        }
        
        searchSQL = searchSQL + ' limit 100';
        system.debug('Search SQL:' + searchSQL);
        
        contactMatches = (list<Contact>) Database.query(searchSQL);
        if (contactMatches.size() > 0)
            searchRender = true;
        else
            searchRender = false;
    }
    

    
    public pageReference addContact() {
        AccountID = ApexPages.currentPage().getParameters().get('contactID');
        system.debug('Add Contact:'+SelectedContact);
        for (SiteContacts__c sc:[select id from SiteContacts__c where Account__c=:siteId and Contact__c=:selectedContact limit 1]) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'The Selected Contact Already Exists For This Site'));
            return null;
        }
            
        //Relate The Contact to the Site
        SiteContacts__c sc = new SiteContacts__c();
        sc.Account__c=siteId;
        sc.Contact__c=selectedContact;
        insert sc;
        return new PageReference('/'+SiteId); 
    }
    
    
}