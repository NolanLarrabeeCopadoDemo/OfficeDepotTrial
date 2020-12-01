public with sharing class CustomAccountLookupController {

  public List<Customer_Transition__c> results{get;set;} // search results
  //public List<Account> results{get;set;} // search results
  public string searchString{get;set;} // search keyword
  public set<id> CTIds = new Set<id>();    
  public CustomAccountLookupController() {
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
  private List<Customer_Transition__c> performSearch(string searchString) {
  //private List<Account> performSearch(string searchString) {
  for(Customer_Transition_Dtls__c DtlErrors : [Select id,Customer_Transition_ID__c,Customer_Transition_ID__r.OMX_Primary_Key__c  from Customer_Transition_Dtls__c where Error_Code__c = 'Error'])
      {
      CTIds.add(DtlErrors.Customer_Transition_ID__c);
      }
  for(Customer_Transition__c MasterErrors : [Select id,OMX_Primary_Key__c  from Customer_Transition__c where Error_Code__c = 'Error'])
      {
      CTIds.add(MasterErrors.id);
      }
      //String soql = 'select id, name from account ';
    //String soql = 'Select id,name,account__c,account__r.name,Account__r.OMX_Primary_Key__c from Customer_Transition__c where Error_Message__c !=null';
   String soql = 'Select id,name,account__c,account__r.name,OMX_Primary_Key__c from Customer_Transition__c where id in:CTIds';
    if(searchString != '' && searchString != null)
      soql +=  ' and (account__r.name LIKE \'%'+searchString+'%\' or OMX_Primary_Key__c LIKE \'%'+searchString+'%\')'; //where name
      //soql += ' limit 25';
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