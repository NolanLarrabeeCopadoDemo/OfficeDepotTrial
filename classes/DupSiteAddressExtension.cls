/******************************************************************
*Apex Class :DupSiteAddressExtension
*Created By : Appirio Off (Akash,14th Sep,2011)
*Purpose : Acts as the controller for DupSiteAddress page, which finds matching duplicate sites,related to this account AddGroupID
Psuedo code: Uses a dyanmic query to sort out the columns,
*******************************************************************/
public class DupSiteAddressExtension {
  
  //Private variables for the class
  private final Account account;    
  private List<Account> lstMatchingAccount;
  public Boolean showList {get;set;}
  
  //=============================================================//
  //Constructor,Initialize Sorting variables
  //=============================================================//
  public DupSiteAddressExtension(ApexPages.StandardController controller) {
    this.account = (Account)controller.getRecord();
    this.lstMatchingAccount = new List<Account>();
    InitializeSort();
    Search();
  }
    
  //========================================================================//
  //Put default values in properties so that sorting works properly
  //========================================================================//
  private void InitializeSort() {
    this.sortField = 'Name';
    showList = true;
    isAscending = true;
  }
  
  //==============================================================//
  //Public Property,that is used by VF page, to show the matching accounts
  //=============================================================//
  public List<Account> getMatchingAccounts() {
    return lstMatchingAccount;
  }
  
  //====================================================================//
  //Utility method, to generate hyperlink that links back to this page 
  //====================================================================//
  private String getHyperLink() {
    return null; //'<a href="/apex/DupSiteAddress?addressgroupid=' + this.account.Add_Group_ID__c + '&Id=' + this.account.Id + '">';
  }
  
  //====================================================================//
  //To return address group Id 
  //====================================================================//
  public String getAddressGroup() {
    return null; //this.account.Add_Group_ID__c;
  }
  
  //====================================================================//
  //To return current account Id
  //====================================================================//
  public String getAccountId() {
    return this.account.Id;
  }
  /************************************************ PAGE REFERENCE Methods***************************************************/
  //================================================================//
  //Called after user has clicked on Sorting a column
  //=================================================================//
  public PageReference Sort() {
    Search();
    return null;
  }
  
  /* Not being called now
  //============================================================================//
  //Marks the account, as duplicate, which is passed by the parameter in command link
  //============================================================================//
  public PageReference FlagDuplicate() {
    
    String accountID = ApexPages.currentPage().getParameters().get('flagAccountID');
    //Safety check
    if(accountID == null || accountID == '') {
      return null;
    }
    
    try {
      Account account = new Account(Id = accountId,Status__c = 'Delete');
      update account;   
      
      String message = 'Thank you - the site has been flagged for removal. To go back to prior duplicate site list ' + getHyperlink() + 'Click here</a>';
      ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Confirm,message));
      //don't show the search list now
      showList = false;
    }
    catch(DmlException ex) {
      ApexPages.addMessages(ex);
      return null;
    }
    return null;
  }
  */
      
  /******************************************************SORTING AND SEARCHING METHODS*********************************************/
  private string previousSortField = null;
  
  //Properties used on Page
  public Boolean isAscending {get;set;}
  public string sortField {get;
    set {
      this.previousSortField = sortField;
      this.sortField = value;
      setAscendingStatus();
    }
  } 

  
  private String getSortOrder() {
    return isAscending ? ' ASC' : ' DESC';
  }
   
  private void setAscendingStatus() {
    if(previousSortField == sortField) {
      isAscending = !isAscending;
      return;
    }
    this.isAscending = true;  
  }
  
  
  //Function name is for legacy reasons,sort account on basis of field
  public void Search() {
    QueryAccounts(sortField); 
  }
  
  
  //====================================================================================================//
  //Query Account and Contact records,using dynamic query
  //=====================================================================================================//
  public void QueryAccounts(String sortField){
    //String addGroupID = this.account.Add_Group_ID__c;
    //LSLEVIN 2.10.16 S-376887 Updated query below to not include X360_View__c
    String query = 'SELECT Name,Address1__c,city__c,state__c,YTD_Sales_TY__c,Ranking__c,Rep_call_date__c,Opportunity_Amt__c,LastActivitydate, ' +
                   'status__c,CreatedDate,LastModifiedDate' +
                   ' FROM Account ' +
                   //' WHERE add_group_id__c = :addGroupID ' +
                   ' WHERE (RecordType.Name = \'Site\' OR RecordType.Name = \'Site (OfficeMax)\')' +  
                   ' ORDER BY ' + sortField  + ' ' + getSortOrder() + 
                   ' LIMIT 1000';    
    this.lstMatchingAccount = (List<Account>)Database.query(query);
  }
  
  
}