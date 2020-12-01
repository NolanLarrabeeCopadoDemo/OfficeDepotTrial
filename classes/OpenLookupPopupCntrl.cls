//Created By Vipul Jain for Story#S-442659 (00796006 - Opportunity Mass Reassignment for Active or Inactive Users by U.S. DSMs and Above) on October 24,2016
public without sharing class OpenLookupPopupCntrl {
 public User User {get;set;} // new User to create
      public List<User> results{get;set;} // search results
      public string searchString{get;set;} // search keyword

      public OpenLookupPopupCntrl() {
        User = new User();
        // get the current search string
        searchString = System.currentPageReference().getParameters().get('lksrch');
        runSearch();
      }

      // performs the keyword search
      public PageReference search() {
        runSearch();
        return null;
      }

      // prepare the query and issue the search command
      private void runSearch() {
        // TODO prepare query string for complex serarches & prevent injections
        results = performSearch(searchString);
      }

      // run the search and return the records found.
      private List<User> performSearch(string searchString) {

        String soql = 'select Name,id, IsActive, ProfileId, Market__c,MobilePhone,Phone, Manager__c, ManagerId, LastLoginDate,'+
        				'UserRole.Name, Profile.Name from User';
        if(searchString != '' && searchString != null)
          soql = soql +  ' where name LIKE \'%' + searchString +'%\'';
        soql = soql + ' limit 50';
        System.debug(soql);
        return database.query(soql);

      }


      // used by the visualforce page to send the link to the right dom element
      public string getFormTag() {
        return System.currentPageReference().getParameters().get('frm');
      }

      // used by the visualforce page to send the link to the right dom element for the text box
      public string getTextBox() {
        return System.currentPageReference().getParameters().get('txt');
      }
}