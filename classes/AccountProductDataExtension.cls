/*************************************************************
*Name : accountProductDataExtension
*Created By : Akash (Appirio Off)
*Created Date : 27th july,2011
*Purpose : To calculate product data related to current shippTo
****************************************************************/
public with sharing class AccountProductDataExtension {
  
  //The current Account record,on which processing is going on
  private Account account = null;
  
  //A place holder object, to store the total sum of lineItems
  public Account opportunitySumAccount {get;set;}
  
  //Mapping of Category and the sum of opportunity lineItems, we are using account.Year_Goal__c as a place holder
  //this will ensure that the formatting on the VF page is proper
  public Map<String,Account> mpCategoryAmount{get;set;}
  
  public decimal tickInterval{get;set;} 
  List<String> lstCategory = new List<String>{'CBS','CBFS','Office Essentials','Filing & Binding','Furniture',
                                              'Tech','Labels & Forms','CPD-Print','CPD-Promo','Paper','Miscellaneous',
                                              'Writing Drafting','Ink Toner','CPD','MPS'};
  
  list<String> lstFieldApi = new List<String>{'CPD_','Office_Essentials_','Filing_Binding_','Furniture_',
                                              'Tech_','Labels_Forms_','CBS_','Paper_','MPS_','Miscellaneous_',
                                              'Writing_Drafting_','Ink_Toner_'};
 
  //---------------------------------------------------//
  //  constructor to buid initial page
  //---------------------------------------------------//
  public AccountProductDataExtension(ApexPages.StandardController controller) {
    account = (Account)controller.getRecord();    
    opportunitySumAccount = new Account(Year_Goal__c = 0);
    tickInterval = 100;
    populateDefaultsCategory();
    populateOpportunityAmount();        
    calculateMaximum();
  }
  
  //================================================================//
  //To calculate the total amount from opportunity and populate the map
  //================================================================//
  private void populateOpportunityAmount() {        
    for(Opportunity opportunity : [SELECT Amount,Product__c 
                                   FROM Opportunity WHERE AccountId = :account.Id AND isClosed = false]) {                                                                          
         
      //T-10417 : Now we do not need to calculate Total line items Amount ,instead calculate from Opportunity itself
      ProcessOpportunity(opportunity);
      
    } // end of outer for
    mpCategoryAmount.get('CPD').Year_Goal__c = mpCategoryAmount.get('CPD-Print').Year_Goal__c + mpCategoryAmount.get('CPD-Promo').Year_Goal__c;
    
  } //end of function
  
  
  //=====================================================================//
  //Process Opportunity 
  //====================================================================//
  private void ProcessOpportunity(Opportunity opportunity) {
    //If any product code, doesn't already exists,please put it in.  
    if(opportunity.Product__c != null && !mpCategoryAmount.containsKey(opportunity.Product__c)) {
      mpCategoryAmount.put(opportunity.Product__c,new Account(Year_Goal__c = 0));
    }  
    
    //Add the total price
    if(opportunity.Amount != null && mpCategoryAmount.containsKey(opportunity.Product__c)) {  
      mpCategoryAmount.get(opportunity.Product__c).Year_Goal__c += opportunity.Amount;
      opportunitySumAccount.Year_Goal__c += opportunity.Amount;
    }
  }
  
  private void calculateMaximum() {
    decimal max = 0; 
    for(String feildApi : lstFieldApi) {
      if(account.get(feildApi+'LY__c') != null && (decimal)account.get(feildApi+'LY__c') > max) {        
        max = (decimal)account.get(feildApi+'LY__c');
      }
      if(account.get(feildApi+'TY__c') != null && (decimal)account.get(feildApi+'TY__c') > max) {
        max = (decimal)account.get(feildApi+'TY__c');
      }
      if(account.get(feildApi+'Pot__c') != null && (decimal)account.get(feildApi+'Pot__c') > max) {
        max = (decimal)account.get(feildApi+'Pot__c');
      }
    }    
    
    for(String category : lstCategory) {
      if(mpCategoryAmount.get(category).Year_Goal__c > max) {
        max = mpCategoryAmount.get(category).Year_Goal__c;
      }  
    }
    /*
    if(max != null) {       
      max = max / 1000;   
      tickInterval = max / 7;
    }*/
    System.debug(':::Max IS ::'+max);
    
    /* Commented out by Ritesh,throwing error when deploying..     
    if(Math.mod((Integer)max ,100) != 0) {      
      max = max + (100 - Math.mod((Integer)max ,100));   
    }
    tickInterval = max + 200 ;    
    */
    
    Integer maxInt = Integer.valueOf(max);
    if(Math.mod(maxInt,100) != 0) {
      maxInt = maxInt + (100 - Math.mod(maxInt,100)); 
    }
    tickInterval = maxInt + 200 ; 
    
  }
  
  
  //================================================================//
  //To populate the default catgories in the map,put the initial value as zero
  //===============================================================//
  private void populateDefaultsCategory() {     
    mpCategoryAmount = new Map<String,Account>();     
    for(String category : lstCategory) {
      mpCategoryAmount.put(category,new Account(Year_Goal__c = 0));
    }     
  }  
  
  //Created a new Test Class 'Test_AccountProductDataExtension'
 /* @isTest 
  private static void testAccountProductDataExtension() {
    Account account =  Test_Utils.CreateAccount();
    account.CPD_LY__c = 10;
    account.CPD_TY__c = 20;
    account.CPD_Pot__c = 40;
    update account;      
   // Opportunity opportunity = Test_Utils.CreateOpportunityWAccountWithoutSite(true,account.id);    
    ApexPages.StandardController controller = new ApexPages.StandardController(account);
    AccountProductDataExtension extension = new AccountProductDataExtension(controller);           
  } */
}