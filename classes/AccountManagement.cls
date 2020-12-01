/**************************************************************
*Name : AccountManagement 
*Created By : Ritesh(Appirio Off)
*Created Date : 11th Oct,2011
*Purpose : Consolidate Account triggers into a single class for better maintainence
           Assumes trigger context is avaliable, will *NOT* work, when invoked outside of trigger
********************************************************************/
public class AccountManagement {

  //Record Types via Map
  private static Map<String,Schema.RecordTypeInfo> rtMapByName = Schema.SObjectType.Account.getRecordTypeInfosByName();
  private static Boolean isBeforeExecuted = false;
  private static string DEFAULT_USER = 'salesforce';
  private static String MPSDUPLICATEERROR ='This related OD account already has a related MPS account, you cannot create another one. ';
  private static String PARENTCANOTBEMPS = 'Can not Relate MPS Account to MPS Customer';
  
  public static void syncAccountowner() {
   
   if (Trigger.isAfter && Trigger.isUpdate) {
     Map<ID,Account> relatedAcctMap = new Map<ID,Account>();
     list<Account> acUpd = new list<Account>();
     for (Account a: (List<Account>)Trigger.new) {
     
       boolean ownermodified = false;
       if ((a.recordtype.DeveloperName == 'Site' ) && a.Related_Account__c != null )
           System.debug('Inside Site : ' +a.AOPS_Seq_ID__c );
           
        if(a.AOPS_Seq_ID__c != null && a.AOPS_Seq_ID__c.contains('-00001')  && (a.OwnerId != a.Related_Account__r.OwnerId || a.Sales_PersonID__c != a.Related_Account__r.Sales_PersonID__c))
            {
                System.debug('Customer Site for  : ' +a.Related_Account__r.AOPS_Cust_ID__c );
                relatedAcctMap.put(a.Related_Account__c,a);
            }/*
         else if(Util.bypassTriggers('AccountTriggers') && a.AOPS_Seq_ID__c == null && a.Primary_Site__c == true  && (a.OwnerId != a.Related_Account__r.OwnerId )) 
            {
                System.debug('Prospect Site for  : ' +a.Related_Account__c );
                relatedAcctMap.put(a.Related_Account__c,a);
            }
            */
            
           
     }
      for (ID i:relatedAcctMap.keySet()) {
        Account act = new Account(ID = i);
        act.ownerid = relatedAcctMap.get(i).ownerid;
        act.Sales_PersonID__c = relatedAcctMap.get(i).Sales_PersonID__c;
        acUpd.add(act);
      }
      database.update(acUpd,false);
   }
  }
  
  //===========================================================================================//
  //Code that is to fire, during both Account Insert and Update
  //===========================================================================================//
  public static void BeforeAccountInsertAndUpdate() {
    // Prevent user from changing owner
    if(Trigger.isUpdate){
        if(!preventOwnerChange()){
            //Set the static variable to true,so that the trigger is not rexecuted
            isBeforeExecuted = true;
            return;
        }
    }
    
    //If the code has already been executed once, don't run it again
    if(isBeforeExecuted) return;
    
    Id propsectRecordTypeId = getRecordTypeId('Prospect');
    Id siteRecordTypeID = getRecordTypeId('Site');
    Id ProspectOmx = getRecordtypeId('Prospect (OfficeMax)');

    // Added by Kishore on 08/08/2014 for fetching recordtypes for buying account
    /*
    Id custodpRecordTypeId = getRecordTypeId('Customer');
    Id siteodpRecordTypeID = getRecordTypeId('Site');
    Id customxRecordTypeId = getRecordTypeId('Customer (OfficeMax)');
    Id siteomxRecordTypeID = getRecordTypeId('Site (OfficeMax)'); 
    //Date currYear = System.ThisYear();   
    Date firstDate =  date.newInstance(System.Today().year(), 1, 1);
    System.Debug('January First of Current Year is - ' + firstDate);
    */

    
    List<Account> lstProspectAccount = new List<Account>();
    List<Account> lstSiteAccount = new List<Account>();
    List<Account> lstOwnerAssignment = new List<Account>();
    List<Account> lstSiteOwnerAssignment = new List<Account>();  
    
     //This is for the MPS Parent Account Uniqueness -- Mohan
    Map<String,Account> mps_ParentAccount = new Map<String,Account>();
    for(Account mpsParentlist :[SELECT id, MPS_Parent_Account__c FROM account where MPS_Parent_Account__c!='' and Primary_Product__c='MPS']) {  
       mps_ParentAccount.put(mpsParentlist.MPS_Parent_Account__c,mpsParentlist);
    } 
    //End 
    
     
    for(Account account :(List<Account>)Trigger.New) {
      Account oldAccount = Trigger.isUpdate ? (Account)Trigger.oldMap.get(account.Id) : null;
      
      if(Trigger.isUpdate){ 
      //Account a = (Account)Trigger.OldMap.get(account.Id);  
      /*
      if(account.RecordtypeId != propsectRecordTypeId && account.Related_Account_Record_Type__c != 'Prospect' && account.recordtypeid != ProspectOmx  && account.Related_Account_Record_Type__c !='Prospect (OfficeMax)'){
          if(((account.YTD_Sales_LY__c == null || account.YTD_Sales_LY__c == 0) && (account.YTD_Sales_TY__c ==null || account.YTD_Sales_TY__c ==0) && account.Open_Opp_count__c ==0)){
            account.Buying_Account__c = false;
          }
          else{
              if(((account.YTD_Sales_LY__c != null && account.YTD_Sales_LY__c != 0) && (account.YTD_Sales_TY__c !=null && account.YTD_Sales_TY__c !=0) && account.Open_Opp_count__c !=0)){
                account.Buying_Account__c = true;
              }
          }
      } 
      */ 
      //Set Buying flag for Office Depot Legacy Customers and Sites
      
      /*
      if((account.RecordtypeId == custodpRecordTypeId) ||
         (account.RecordtypeId == siteodpRecordTypeId && account.Related_Account_Record_Type__c == 'Customer')
        ) 
      {
        // If the account is created in the current calendar year or has last year sales or 
        // has current year sales then set buying account true else false
        if((account.Createddate >= firstDate) ||
           (account.YTD_Sales_LY__c != null && account.YTD_Sales_LY__c > 0) || 
           (account.YTD_Sales_TY__c != null && account.YTD_Sales_TY__c > 0)
          )
          account.Buying_Account__c = true;
        else
          account.Buying_Account__c = false;
      } 
      // Set Buying flag for Office Max Legacy Customers and Sites
      else { 
        if((account.RecordtypeId == customxRecordTypeId) ||
           (account.RecordtypeId == siteomxRecordTypeId && account.Related_Account_Record_Type__c == 'Customer (OfficeMax)')
          ) 
        {
          // If the account is created in the current calendar year or has last year sales or 
          // has current year sales then set buying account true else false
          if((account.Legacy_CreatedDate__c >= firstDate) ||
             (account.YTD_Sales_LY__c != null && account.YTD_Sales_LY__c > 0) || 
             (account.YTD_Sales_TY__c != null && account.YTD_Sales_TY__c > 0)
            )
            account.Buying_Account__c = true;
          else
            account.Buying_Account__c = false;
        }
        else 
          account.Buying_Account__c = false;
      }
      */  
      if(mps_ParentAccount.get(account.MPS_Parent_Account__c)!= null && account.MPS_Parent_Account__c!= oldAccount.MPS_Parent_Account__c ){
        account.addError(MPSDUPLICATEERROR);
      }
      
      
     }
     
     if(Trigger.isInsert){
      /*if((account.YTD_Sales_LY__c !=null && account.YTD_Sales_LY__c !=0) || (account.YTD_Sales_TY__c !=null && account.YTD_Sales_TY__c !=0) ){
        account.Buying_Account__c = true;
      }*/
      if(mps_ParentAccount.get(account.MPS_Parent_Account__c)!= null ){
        account.addError(MPSDUPLICATEERROR);
      }
      
     }
      //End
      
      //Check if a Prospect Type Account   
      if(account.RecordTypeId == propsectRecordTypeId && IsValidAccountForPrimarySalesPersonID(account,oldAccount)){
        lstProspectAccount.add(account);
      }  
      if(account.RecordTypeId == propsectRecordTypeId && IsValidAccountForOwnerAssignment(account,oldAccount)) {
        lstOwnerAssignment.add(account);
      }
      
      //Check if Record Type is Site 
      if(account.RecordTypeId == siteRecordTypeID && account.Related_Account__c != null) {        
        lstSiteAccount.add(account);
        if(trigger.isInsert) {
          lstSiteOwnerAssignment.add(account);              
        }                      
      }
    }
    
    //Populate Sales Person ID for valid Prospect Accounts
    PopulateSalesPersonID(lstProspectAccount,null);
    //Prevent Update to sites record of Customers
    PreventUpdatesToSite(lstSiteAccount);
    //Populate Primary Owner
    PopulatePrimaryOwner(lstOwnerAssignment);
    
    PopulateSitePrimaryOwner(lstSiteOwnerAssignment);
    PopulateSalesPersonID(lstSiteOwnerAssignment,null);
    //Mark the static variable as true, so that trigger is not executed again for any workflow updates
    isBeforeExecuted = true;
  }
  
 // ==================================================================
  //Set Buying flag for Office Depot Legacy Customers and Sites
  //Added by Jasmeet-Offshore
 // ==================================================================
  
  Public static Void Set_Buying_Account(){
    
    Id propsectRecordTypeId = getRecordTypeId('Prospect');
    Id siteRecordTypeID = getRecordTypeId('Site');
    Id ProspectOmx = getRecordtypeId('Prospect (OfficeMax)');

    // Added by Kishore on 08/08/2014 for fetching recordtypes for buying account
    Id custodpRecordTypeId = getRecordTypeId('Customer');
    Id siteodpRecordTypeID = getRecordTypeId('Site');
    Id customxRecordTypeId = getRecordTypeId('Customer (OfficeMax)');
    Id siteomxRecordTypeID = getRecordTypeId('Site (OfficeMax)'); 
    
    Id custGTRecordTypeId = getRecordTypeId('Customer (GT)');
    system.debug('@@@@@@@@@@@cust'+custGTRecordTypeId );
    Id siteGTRecordTypeId = getRecordTypeId('Site (GT)');
    
    //Date currYear = System.ThisYear();   
    Date firstDate =  date.newInstance(System.Today().year(), 1, 1);
    System.Debug('January First of Current Year is - ' + firstDate);
      if(Trigger.IsUpdate){   
          List<Account> accObj = [select related_account__r.recordtypeid from account where id in: Trigger.New];
          for(Account account :(List<Account>)Trigger.New) {
              
              for(Account relatedAcc : accObj ) { 
                  if((account.RecordtypeId == custodpRecordTypeId) ||
                     (account.RecordtypeId == siteodpRecordTypeId && account.Related_Account_Record_Type__c == 'Customer'))
                  { 
                      account.Buying_Account__c = true;                
                  }  
                  
                  else if((account.RecordTypeId == custGTRecordTypeId) ||
                     (account.RecordTypeId == siteGTRecordTypeId && relatedAcc.related_account__r.recordtypeid  == custGTRecordTypeId)
                    ) 
                  { 
                      account.Buying_Account__c = true;        
                      system.debug('@@@@@@@@@@@In else if');
                  } 
                  // Set Buying flag for Office Max Legacy Customers and Sites
                  else { 
                    if((account.RecordtypeId == customxRecordTypeId) ||
                       (account.RecordtypeId == siteomxRecordTypeId && account.Related_Account_Record_Type__c == 'Customer (OfficeMax)')
                      ) 
                    {
                      // If the account is created in the current calendar year or has last year sales or 
                      // has current year sales then set buying account true else false
                      if((account.Legacy_CreatedDate__c >= firstDate) ||
                         (account.YTD_Sales_LY__c != null && account.YTD_Sales_LY__c > 0) || 
                         (account.YTD_Sales_TY__c != null && account.YTD_Sales_TY__c > 0)
                        )
                        account.Buying_Account__c = true;
                      else
                        account.Buying_Account__c = false;
                    }
                    else 
                      account.Buying_Account__c = false;
                  }
              }
          }
       }   
       if(Trigger.IsInsert){
           List<Account> accObj = new List<Account>();
           if(Trigger.New!= null)
           accObj = [select related_account__r.recordtypeid from account where id in: Trigger.New];
           
           for(Account account: (List<Account>)Trigger.New){
               for(Account relatedAcc : accObj ) {
                   if((account.RecordtypeId == custodpRecordTypeId) ||
                     (account.RecordtypeId == siteodpRecordTypeId && account.Related_Account_Record_Type__c == 'Customer') 
                     )
                    
                    {
                        account.buying_account__c = true;
                    }
                    else if((account.RecordTypeId == custGTRecordTypeId) ||
                     (account.RecordTypeId == siteGTRecordTypeId && relatedAcc.related_account__r.recordtypeid == custGTRecordTypeId)
                    ) 
                    { 
                          account.Buying_Account__c = true;                
                    }
                    else { 
                        if((account.RecordtypeId == customxRecordTypeId) ||
                           (account.RecordtypeId == siteomxRecordTypeId && account.Related_Account_Record_Type__c == 'Customer (OfficeMax)')
                          ) 
                        {
                          // If the account is created in the current calendar year or has last year sales or 
                          // has current year sales then set buying account true else false
                          if((account.Legacy_CreatedDate__c >= firstDate) ||
                             (account.YTD_Sales_LY__c != null && account.YTD_Sales_LY__c > 0) || 
                             (account.YTD_Sales_TY__c != null && account.YTD_Sales_TY__c > 0)
                            )
                            account.Buying_Account__c = true;
                        }
                    }    
               }
           }
       }
  }
  
  
  
  //==============================================================================================//
  //if Account.Auto_Assign__c == False prevent user from changing owner
  //============================================================================================//
  private static Boolean preventOwnerChange(){
     Boolean isValidationPassed = true;
     for(Account account :(List<Account>)Trigger.New) {
         Account oldAccount = (Account)Trigger.oldMap.get(account.Id);
         system.debug('Old ownerid-->'+oldAccount.OwnerId);
         system.debug('New ownerid-->'+account.OwnerId);
         //Bifurcated the check for canada prospects
         if(account.recordtypeid!=rtMapByName.get('Prospect (GT)').getRecordTypeId() && account.recordtypeid!=rtMapByName.get('Site (GT)').getRecordTypeId())
         {
             if(account.Auto_Assign__c == false && account.OwnerId != oldAccount.OwnerId)
             {
             System.debug('&&&&&&&&&&&&&&&&&&&&&&&&&&ERROR');
                //account.addError('You do not have permission to change the owner of this record - all changes need to occur in TOPPS"');
                isValidationPassed = false;
             }
         }
     }
     return isValidationPassed;
  }
  
  //==============================================================================================//
  //Set the boolean variable to false, so that trigger executes again especially useful for test class
  //============================================================================================//
  public static void ResetExecution() {
    isBeforeExecuted = false;
  }
  
  
  /**********************************************Populate Primary Owner ***********************************************************/
  private static Boolean IsValidAccountForOwnerAssignment(Account account,Account oldAccount){
    //Update Case
    
    if(oldAccount != null){
      //Account Auto assign checkbox has been clicked
      if(oldAccount.Auto_Assign__c != account.Auto_Assign__c && account.Auto_Assign__c) {
        return true;
      }
      //Zip has changed 
      if(oldAccount.zip__c != account.zip__c && account.auto_assign__c) {
        return true;    
      }
      //Assign Rules Look has changed
      if(oldAccount.AssignRulesWCWLookup__c != account.AssignRulesWCWLookup__c && account.auto_assign__c){
        return true;   
      } 
      //Indusy od code has changed
      if(oldAccount.Industry_OD_SIC_Rep_Code__c != account.Industry_OD_SIC_Rep_Code__c && account.auto_assign__c) {
        return true;
      }
      //Nothing has changed, to need to do anything  
      return false;
    }
    
    //Insert case
    return account.Auto_Assign__c;
  }
  
  private static void PopulatePrimaryOwner(List<Account> lstAccount){
    Map<String,Assignment_Rule__c> mpTerritoryKey = new Map<String,Assignment_Rule__c>();
    Set<String> accountKeys = new Set<String>();
    Map<Id,Account> mpProspectAccount = new Map<Id,Account>();
    for(Account account :lstAccount) {     
      /*accountKeys.add(generateZipWCWIndustryKey(account));
      accountKeys.add(generateZipWCWKey(account));                      
      accountKeys.add(generateZipIndustryKey(account));*/
      if(account.Zip__c != null) {
        //changes to handle 9 digit zip codes -- modified by ivarada
        String zipCode = account.Zip__c;
        if(zipCode.length()>5) 
           accountKeys.add(zipCode.substring(0,5));
        else
           accountKeys.add(account.Zip__c);
      }      
    }
    QueryAssignmentRuleNew(mpTerritoryKey,accountKeys);
    // Map<Id,List<Account>> mpRelatedAccount = PopulateRelatedAccount(lstAccount);
    Map<String,Sales_Person__c> mpSalesRep = LoadSalesPersonById(mpTerritoryKey.values());
    
    //List<User> lstDefaultUser = [select Id from User where lastname = :DEFAULT_USER AND IsActive = true Limit 1]; 
    Id lstDefaultUserId= Label.Salesforce_User;
    List<Account> defaultSalesPersonIds = new List<Account>();
    for(Account account : lstAccount) {
      if(mpTerritoryKey.containsKey(generateZipWCWIndustryKey(account))) {
        //System.debug('Mapterritory 1========'+mpTerritoryKey);
        assignOwner(account,mpTerritoryKey.get(generateZipWCWIndustryKey(account)),mpSalesRep,mpProspectAccount);
        continue;
      }
      if(mpTerritoryKey.containsKey(generateZipWCWKey(account))) {
        //System.debug('Mapterritory 2========'+mpTerritoryKey);
        assignOwner(account,mpTerritoryKey.get(generateZipWCWKey(account)),mpSalesRep,mpProspectAccount); 
        continue;
      }
      if(mpTerritoryKey.containsKey(generateZipIndustryKey(account))) {
        //System.debug('Mapterritory 3========'+mpTerritoryKey);
        assignOwner(account,mpTerritoryKey.get(generateZipIndustryKey(account)),mpSalesRep,mpProspectAccount); 
        continue;
      }
      
      //changes to handle 9 digit zip codes -- modified by ivarada
      String zipcode = account.zip__c;
      if (zipCode != null) {
        if (zipCode.length()>5)
          zipcode = zipCode.substring(0,5);
      }
      if(mpTerritoryKey.containsKey(zipcode )) {
        System.debug('Mapterritory 4========'+mpTerritoryKey);
        assignOwner(account,mpTerritoryKey.get(zipcode),mpSalesRep,mpProspectAccount); 
        continue;
      }
      if(lstDefaultUserId !=null ) {
        account.OwnerId = lstDefaultUserId ;
        account.Auto_Assign__c = false; 
        defaultSalesPersonIds.add(account);
      }
    }   
    PopulateSalesPersonID(defaultSalesPersonIds,mpProspectAccount);  
    updateChildSiteANDContact(mpProspectAccount);   
  }
  
  
  //======================================================================================================//
  //Update child sites and contact records of parent prospect
  //======================================================================================================//
  public static void updateChildSiteANDContact(Map<Id,Account> mpProspectAccount) {
    if(mpProspectAccount.size() == 0) {
      return ;
    }
    Id siteRecordTypeID = getRecordTypeId('Site');
    List<Account> lstRelatedSites = new List<Account>();
    List<Contact> lstRelatedContacts = new List<Contact>();
    for(Account account : [select id,OwnerId,auto_assign__c,Sales_PersonID__c,Related_Account__c from Account where RecordTypeId = :siteRecordTypeID AND Related_Account__c IN :mpProspectAccount.keySet()]) {
      Account siteAccount = new Account(Id = account.id,auto_assign__c=true,OwnerId = mpProspectAccount.get(account.Related_Account__c).OwnerId,Sales_PersonID__c = mpProspectAccount.get(account.Related_Account__c).Sales_PersonID__c);
      lstRelatedSites.add(siteAccount);
    }
    for(Contact contact : [select id,OwnerId,AccountId from Contact where AccountId IN :mpProspectAccount.keySet()]) {
      Contact relContact = new Contact(Id = contact.id,OwnerId = mpProspectAccount.get(contact.AccountId).OwnerId);
      lstRelatedContacts.add(relContact);
    }
    if(lstRelatedSites.size() > 0) {
      update lstRelatedSites;
    }
    if(lstRelatedContacts.size() > 0) {
      update lstRelatedContacts;
    }
  }
  
  
  //======================================================================================================//
  //Load Sales Reps based on external Sales Rep Id
  //======================================================================================================//
  private static Map<String,Sales_Person__c> LoadSalesPersonById(List<Assignment_Rule__c> lstAssignmentRule){
    Map<String,Sales_Person__c> mpSalesPerson = new Map<String,Sales_Person__c>();
    for(Assignment_Rule__c assignmentRule :lstAssignmentRule) {
      mpSalesPerson.put(assignmentRule.User__c,null);
    }
    if(mpSalesPerson.keyset()!=null){
    for(Sales_Person__c salesPerson :[SELECT Id,User__c,ExtIDSalesPerson__c, user__r.isactive, user__r.ManagerId FROM Sales_Person__c WHERE Primary__c = true AND IsActive__c = true
                                      AND User__c IN :mpSalesPerson.keyset()]) {
    
      mpSalesPerson.put(salesPerson.User__c,salesPerson);
    } 
    }
    return mpSalesPerson;
  }
  
  
  //============================================================================================================//
  //Assign Owner to Account and the related Site Accounts according to Assignment Rule
  //===========================================================================================================//
  public static void AssignOwner(Account account,Assignment_Rule__c rule,Map<String,Sales_Person__c> mpSalesRep,Map<Id,Account> mpProspectAccount){
    Sales_Person__c salesPerson = mpSalesRep.get(rule.User__c);
    
    if (salesPerson != null) {
        if (salesPerson.user__r.isactive == false) {
          account.OwnerId = salesPerson.User__r.ManagerId;
          account.Sales_PersonID__c = salesPerson.Id;
          account.Auto_Assign__c = false;
        }
        else{
            account.OwnerId = salesPerson.User__c;
            account.Sales_PersonID__c = salesPerson.Id;
            account.Auto_Assign__c = false;
        }
    }
    
    if(account.Id != null) {
      mpProspectAccount.put(account.Id,account);
    }

  }
 
  
  /*
  private static void QueryAssignmentRule(Map<String,Assignment_Rule__c> mpTerritoryKey,Set<String> accountKeys){    
    system.debug('------------>' + accountKeys);
    for(Assignment_Rule__c rule : [select Zip_Code__c,ZipIndustry__c,ZipRangeGroup__c,ZipRange__c,Sales_Rep_ID__c
                                   //Rep_Id__c,Rep_Id__r.User__c 
                                   FROM Assignment_Rule__c 
                                   where Sales_Rep_ID__c != null //And Rep_Id__r.Primary__c = true AND Rep_Id__r.IsActive__c = true AND Rep_Id__r.User__c != null 
                                   And ZipRangeGroup__c != null 
                                   And ZipRange__c != null AND Zip_Code__c != null And (ZipRangeGroup__c IN :accountKeys OR ZipRange__c IN :accountKeys OR ZipIndustry__c IN :accountKeys OR Zip_Code__c IN :accountKeys)]) {    
      mpTerritoryKey.put(rule.ZipRangeGroup__c,rule);    
      mpTerritoryKey.put(rule.ZipRange__c,rule);
      mpTerritoryKey.put(rule.ZipIndustry__c,rule);
      mpTerritoryKey.put(rule.Zip_Code__c,rule);        
    }
  }*/
  //============================================================//
  //Query and Populate Assignment Rules
  //============================================================//
  private static void QueryAssignmentRuleNew(Map<String,Assignment_Rule__c> mpTerritoryKey,Set<String> accountKeys){    
    System.debug(':::Account Keys :::'+accountKeys);

    //for(Assignment_Rule__c rule : [select Zip_Code__c,Industry_Group__c,WCW_Count__c ,Sales_Rep_ID__c   FROM Assignment_Rule__c   where Sales_Rep_ID__c != null   AND Zip_Code__c != null And Zip_Code__c IN :accountKeys]) 
      if(accountKeys!= null)
      for(Assignment_Rule__c rule : [select Zip_Code__c,Industry_Group__c,WCW_Count__c,User__c, user__r.isactive, user__r.ManagerId FROM Assignment_Rule__c   where  Zip_Code__c != null And Zip_Code__c IN :accountKeys]) {
      /*String ZipRangeGroup= null;
      if(rule.WCW_Count__c!=null && rule.WCW_Count__c !=''){
        mpTerritoryKey.put(rule.Zip_Code__c+rule.WCW_Count__c,rule);
        ZipRangeGroup =  rule.Zip_Code__c+rule.WCW_Count__c;
      }
           
      if(rule.Industry_Group__c != null && rule.Industry_Group__c !=''){
        mpTerritoryKey.put(rule.Zip_Code__c+rule.Industry_Group__c,rule);
        if(ZipRangeGroup != null){
          ZipRangeGroup += rule.Industry_Group__c;
         mpTerritoryKey.put(ZipRangeGroup,rule);
        }
      }
      mpTerritoryKey.put(rule.Zip_Code__c,rule); */
//      System.debug('QueryAssignmentRule==== '+rule);
        String ZipRangeGroup= null;
        
        if((rule.WCW_Count__c!=null && rule.WCW_Count__c !='') && (rule.Industry_Group__c != null && rule.Industry_Group__c !=''))
        {           
            mpTerritoryKey.put(rule.Zip_Code__c+rule.WCW_Count__c+rule.Industry_Group__c,rule);        
        }
        else if(rule.WCW_Count__c!=null && rule.WCW_Count__c !='')
        {           
            mpTerritoryKey.put(rule.Zip_Code__c+rule.WCW_Count__c,rule);            
            ZipRangeGroup = rule.Zip_Code__c+rule.WCW_Count__c;
        }
        
        else if(rule.Industry_Group__c != null && rule.Industry_Group__c !='')
        {           
            mpTerritoryKey.put(rule.Zip_Code__c+rule.Industry_Group__c,rule);          
            if(ZipRangeGroup != null)
            {
                ZipRangeGroup += rule.Industry_Group__c;
                mpTerritoryKey.put(ZipRangeGroup,rule);            
            }
        }
        else 
        {
                mpTerritoryKey.put(rule.Zip_Code__c,rule);              
        }
      System.debug('QueryAssignmentRule==== '+rule);
        System.debug('Mapterritory 5========'+mpTerritoryKey);
         
    }
  }
  
  
  //--------------------------------------------------------//
  //return key based on only postal and wcw count 
  //--------------------------------------------------------// 
  private static string generateZipWCWKey(Account account) {
    String key='';
    String zipCode = account.zip__c;
    if(zipCode.length()>5)
        zipCode = zipCode.substring(0,5);
    key += account.zip__c == NULL?'':zipCode ;   
    //key += account.zip__c == NULL?'':account.zip__c ;
    key += account.AssignRulesWCWLookup__c == NULL?'-':account.AssignRulesWCWLookup__c;
    System.debug('Key 1========'+key);
    return key;
  }
  
  //--------------------------------------------------------//
  //return key based on only postal and wcw count 
  //--------------------------------------------------------// 
  private static string generateZipIndustryKey(Account account) {
    String key='';
    String zipCode = account.zip__c;
    if(zipCode.length()>5)
    zipCode = zipCode.substring(0,5);
    key += account.zip__c == NULL?'':zipCode ;    
   //key += account.zip__c == NULL?'':account.zip__c ;    
    key += account.Industry_OD_SIC_Rep_Code__c == NULL?'-':account.Industry_OD_SIC_Rep_Code__c ;
    System.debug('Key 2========'+key);    
    return key;
  }
  
  //----------------------------------------------------------------//
  //return key based on postal code, wcw count and industry sic code// 
  //----------------------------------------------------------------// 
  private static string generateZipWCWIndustryKey(Account account) {
    String key='';
    
    /*key += account.zip__c == NULL?'':account.zip__c ;
    key += account.AssignRulesWCWLookup__c == NULL?'-':account.AssignRulesWCWLookup__c;  
    key += account.Industry_OD_SIC_Rep_Code__c == NULL?'-':account.Industry_OD_SIC_Rep_Code__c ;*/
    
    String zipCode = account.zip__c;
     if(zipCode   !=null && zipCode !=''){
    if(zipCode.length()>5)
    zipCode = zipCode.substring(0,5);
    key += account.zip__c == NULL?'':zipCode;   
    key += account.AssignRulesWCWLookup__c == NULL?'':account.AssignRulesWCWLookup__c; 
    if ((account.Industry_OD_SIC_Rep_Code__c == 'GV' || account.Industry_OD_SIC_Rep_Code__c == 'ES') && account.AssignRulesWCWLookup__c == '20to999999')
      key += account.Industry_OD_SIC_Rep_Code__c == NULL?'':account.Industry_OD_SIC_Rep_Code__c ; 
      System.debug('Key 3========'+key); 
    } 
    return key;
  }  
  
  private static void PopulateSitePrimaryOwner(List<Account> lstAccount) {
    Map<Id,Id> mpProspectOwner = new Map<Id,Id>();
    for(Account account : lstAccount) {
      mpProspectOwner.put(account.Related_Account__c,null);
    }
    if(mpProspectOwner.keySet()!= null){
    for(Account account : [select Id,OwnerId from Account where Id IN : mpProspectOwner.keySet() AND RecordType.Name = 'Prospect']) {
      mpProspectOwner.put(account.Id,account.OwnerId);
    }
    }
    for(Account account : lstAccount) { 
      if(mpProspectOwner.containsKey(account.Related_Account__c) && mpProspectOwner.get(account.Related_Account__c) != null) {
        account.OwnerId = mpProspectOwner.get(account.Related_Account__c);
      }       
    }
  }
  
  /********************************************SALES PERSON POPULATION LOGIC********************************************************/ 
  //---------------------------------------------------------------------------------------------------------//
  // when recordtype=prospect and account.owner has changed and auto_assign is not checked                   //
  // Set account.sales_personid__c = sales_person_id__c.id where  Sales_person_id__c.user__c = account.owner // 
  // and sales_person_id__c.primary__c = checked                                                             // 
  //-------------------------------------------------------------------------------------------------------- //
  public static void PopulateSalesPersonID(List<Account> lstAccount, Map<Id,Account> mpProspectAccount) {
 
    if(lstAccount.size() == 0) return;
    
    Set<Id> setUserID = new Set<ID>();
    for(Account account :lstAccount){
      setUserID.add(account.OwnerId);
    }

    //START S-350562 [Hemant 9/15/2015] - Assign to Mgr if active Sales_Person__c record not found
    //Store mappings of User to its Mgr ID
    Map<Id, Id> userMgrIdMap = new Map<Id, Id>();
    for(User usr : [Select Id,IsActive, ManagerId from User
                              Where Id IN: setUserID
                              AND ManagerId != null]){
        userMgrIdMap.put(usr.Id, usr.ManagerId);
    }
    setUserID.addAll(userMgrIdMap.values());
    //END S-350562

    //Store mappings of User to its corresponding Sales Person ID
    Map<Id,Sales_Person__c> mpUserToSalesPerson = new Map<Id,Sales_Person__c>();
    
    //Query Data where Primary is checked and User is linked with ownerID
   /* system.debug('Deepak3:' + setUserID);
    list<Sales_Person__c> sp = [SELECT Id FROM Sales_Person__c];
    list<cpm_data__c> cpm = [select id from cpm_data__c];
    list<user> usr = [Select ID from user]; */
    /*for(Sales_Person__c salesPerson :[SELECT Id,User__c FROM Sales_Person__c WHERE User__c IN :setUserID
                                      AND Primary__c = true AND IsActive__c = true]){
      mpUserToSalesPerson.put(salesPerson.User__c,salesPerson);
    }*/

    for(Sales_Person__c salesPerson :[SELECT Id,User__c, User__r.IsActive FROM Sales_Person__c WHERE User__c IN :setUserID
                                      AND Primary__c = true]){
      mpUserToSalesPerson.put(salesPerson.User__c,salesPerson);

    }
    
    //Populate Sales Person ID based on User ID
    for(Account account :lstAccount){
      
      Sales_Person__c salesPerson = mpUserToSalesPerson.get(account.OwnerId);


      //START S-350562 [Hemant 9/15/2015] - Assign to Mgr if active Sales_Person__c record not found
      if(salesPerson == null){
        salesPerson = mpUserToSalesPerson.get(userMgrIdMap.get(account.OwnerId)); //get SP for mgr if salesperson is null
      }
      //END S-350562
      if(salesPerson != null) {
       
        account.sales_personid__c = salesPerson.Id;
        if(mpProspectAccount != null && account.Id != null) {
          mpProspectAccount.put(account.Id,account);
        }
      }else if(account.Assign_Specific_Owner__c == null && !account.Auto_Assign__c){
           if(!test.isrunningtest())
           account.addError('The person creating does not have valid Sales Rep ID - Please reassign to someone else or choose "Auto-Assign"');
      }
    } 
  }
  
  //====================================================================================//
  //Check if the Account owner has changed and Auto assign is not checked
  //====================================================================================//
  private static Boolean IsValidAccountForPrimarySalesPersonID(Account account,Account oldAccount){
    if(oldAccount != null) {
      //If OwnerID has not changed,consider this account has invalid
      
      if(account.OwnerId == oldAccount.OwnerID) {
        return false;
      }
    }
    
    //if account is marked as Auto Assign, do nothing
    if(account.Auto_Assign__c) {     
      return false;
    }
    //Owner has changed and auto assign is not marked
    return true;
  }
  
  /*******************************************Prevent Updates To Site**************************************************************/
  //==================================================================================//
  //on Accounts for update/save of an account record that has an account.recordtype="Site" 
  //and the Account.Related_account__r.Recordtype name = Customer.  
  //Prevent insert or update and give user error message   
  //==================================================================================//
  public static void PreventUpdatesToSite(List<Account> lstSiteAccount){
    if(lstSiteAccount.size() == 0) return;
   
    Set<ID> relatedAccountID = new Set<Id>();
    for(Account account :lstSiteAccount){
      relatedAccountID.add(account.Related_Account__c);
    }
  /*  Map<ID,Account> mpRelatedAccount = new Map<Id,Account>([Select RecordTypeId from Account where 
                                                            ID IN :relatedAccountID AND RecordType.Name = 'Customer']); 
    //Loop over the Selected Site Accounts
    for(Account account :lstSiteAccount) {
     if(!IsSiteAllowedToBeEdited(account,mpRelatedAccount)) {
       account.addError('You cannot edit core fields on a site record that is related to a customer account.  You cannot create a new site record against a customer accounts - please follow proper account maintenance procedures');
     }  
    }*/  
  }
  
  //==============================================================================================//
  //If a user tries to edit an existing site (Update site) that is tied to a customer account and tries to edit some of special
  //of the fields above -- they should receive the same error message and not be allowed to save. 
  //Any other fields other than special fields are ok.  
  //Also they still cannot add any new site (insert site) onto a customer accoun
  //==============================================================================================//
  /*
  private static Boolean IsSiteAllowedToBeEdited(Account siteAccount, Map<ID,Account> mpRelatedAccount) {
     Account relatedAccount = mpRelatedAccount.get(siteAccount.Related_Account__c);
     //If the related Account doesn't exist or is not of type 'Customer',don't bother allow edits     
     if(relatedAccount == null) 
       return true;
     
     //We don't allow creating new sites 
     if(Trigger.isInsert)        
        return false;
     
     Account oldSiteAccount = (Account)Trigger.oldMap.get(siteAccount.Id);
         
     //Check if core fields are edited , Name and other host of other fields
     if(oldSiteAccount.Name != siteAccount.Name) {return false;}
     if(oldSiteAccount.Related_Account__c != siteAccount.Related_Account__c) {return false;}
     if(oldSiteAccount.Est_Spend__c != siteAccount.Est_Spend__c) {return false;}
     if(oldSiteAccount.Address1__c != siteAccount.Address1__c) {return false;}
     if(oldSiteAccount.address2__c != siteAccount.address2__c) {return false;}
     if(oldSiteAccount.city__c != siteAccount.city__c) {return false;}
     if(oldSiteAccount.state__c != siteAccount.state__c){return false;}
     if(oldSiteAccount.country__c != siteAccount.country__c) {return false;}
     if(oldSiteAccount.Auto_assign__c != siteAccount.Auto_assign__c){return false;}
     
     //Hoops, if someone has taken the trouble to come here, we must respect him, allow him editing
     return true;
  }
 */
 
  /***************************************Account Setup Request Updation***************************************************/
  //-----------------------------------------------------------------------------------------------------------------------//
  //After account update/insert if Account.AOPS_cust_id__c goes from null to notnull then update related child Account_Setup_request__c  records 
  //that are related >> specifically update the Account_setup_request__c.AOPS_ID1__c = Account.AOPS_Cust_Id__c
  //--------------------------------------------------------------------------------------------------------------//
  public static void PropagateChangesToAccountSetupRequest() {
    Set<Id> accountIds = getAccountIds();
    if(accountIds.size() == 0){
        return;
    }
    
    for(List<Account_setup_request__c> accountSetupRequestList :[Select account__c, AOPS_ID1__c FROM Account_setup_request__c 
                                                                  WHERE account__c IN :accountIds]) {
          for(Account_setup_request__c accountSetupRequest : accountSetupRequestList){
              Account account = (Account)Trigger.NewMap.get(accountSetupRequest.Account__c);
              if(account != null) {
                accountSetupRequest.AOPS_ID1__c = account.AOPS_Cust_Id__c;
                accountsetuprequest.ownerid = account.ownerid;
              }
          }
          update accountSetupRequestList;
    } 
  }
  
  //================================================================================//
  //make ids of account for accountSetupRequest  
  //================================================================================//
  public static Set<id> getAccountIds(){
    Set<Id> accountIds = new Set<Id>();
    
    for(Account account :(List<Account>)Trigger.New) {
        //Insert case, when the field is not null
        if(Trigger.isInsert && account.AOPS_Cust_Id__c != null) {
            accountIds.add(account.Id);
            continue;
        }
        
        if(Trigger.isUpdate) {
          Account oldAccount = (Account)Trigger.oldMap.get(account.Id);
          //new Account value is not null and the old account was null, add account to be processed
          if(account.AOPS_Cust_Id__c != null && oldAccount.AOPS_Cust_Id__c == null) {
            accountIds.add(account.Id);
          }
        }
    } 
    return accountIds;  
  }
  
    
  /***********************************Utils Method************************************************************************/
  
  //================================================================================//
  //Get Record Type Id from record Type Name
  //================================================================================//
  public static  Id getRecordTypeId(String recordTypeName) {
    RecordTypeInfo siteRecordType = rtMapByName.get(recordTypeName); 
    if(siteRecordType == null) return null;
    
    return siteRecordType.getRecordTypeId();
  }
  
  
  /***********************************Email Method************************************************************************
  //======================================================================================================================
  // Account Owner Assignment Notifiaction sending email
  /*======================================================================================================================*/  
/*
  public static void NotifyRepOwner(List<Account> AccountLSt,map<Id,Account> OldAccountMap){
     Messaging.reserveSingleEmailCapacity(trigger.size);
     List<Messaging.SingleEmailMessage> emails = new List<Messaging.SingleEmailMessage>();
     List<Profile> ProfLst = [Select Id from Profile where Name = 'Inside Sales' ];
     List<OrgWideEmailAddress> OrgAddress= [SELECT Id FROM OrgWideEmailAddress WHERE DisplayName = 'Office Depot'];      
     if(ProfLst.size() > 0){
     if(Trigger.IsInsert){
          Set<Id> accountOwnerIds = new Set<Id>();
          for (Account a : AccountLst) {
            if(a.OwnerId != null) {
                accountOwnerIds.add(a.OwnerId);
            }
         }   
         Map<Id, User> userMap = new Map<Id,User>();
         for(User u:[select id,Name,email,ProfileId from User where Id IN :accountOwnerIds]){
             userMap.put(u.Id,u);
         }
         for(Account acc1:AccountLSt){
             if(userMap.get(acc1.OwnerId).ProfileId!=null && userMap.get(acc1.OwnerId).ProfileId == ProfLst[0].Id){
                 Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();
                 email.setToAddresses(new String[] {Usermap.get(acc1.ownerId).email});
                 //email.setToAddresses(new String[] {'jasmeez7@gmail.com'});
                 email.setReplyTo('no-reply@oficedepot.com');
                 email.setOrgWideEmailAddressId(OrgAddress[0].Id);
                 email.setSenderDisplayName(acc1.owner.FirstName);
                 email.setSubject('Account Assignment notification');
                 email.setPlainTextBody('Hi ,'+'\n You have been assigned an Account with below metioned details: ' + 
                       '\n Account Name : ' +  acc1.Name +
                       '\n Cust ID : ' + acc1.Cust_ID__c) ;                   
                                   
                 emails.add(email);
             }
         }
     }
     If(Trigger.IsUpdate){
         Set<Id> accountOwnerIds = new Set<Id>();
         for (Account a : OldAccountMap.values() ) {
            if(a.OwnerId != null) {
                accountOwnerIds.add(a.OwnerId);
            }
         }
         for (Account a : AccountLst) {
            if(a.OwnerId != null) {
                accountOwnerIds.add(a.OwnerId);
            }
         }
         
         
         Map<Id, User> userMap = new Map<Id,User>();
         for(User u:[select id,Name,email,ProfileId from User where Id IN :accountOwnerIds]){
             userMap.put(u.Id,u);
          }
         
         for(Account acc1: AccountLSt){
             Account oldAcc = OldAccountMap.get(acc1.Id);
             if(oldAcc.OwnerId != acc1.OwnerId && userMap.get(acc1.OwnerId).ProfileId == ProfLst[0].Id){
                 Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();
                 email.setOrgWideEmailAddressId(OrgAddress[0].Id);
                 email.setSenderDisplayName('Office Depot');
                 email.setToAddresses(new String[] {userMap.get(acc1.OwnerId).email});
                 //email.setToAddresses(new String[] {'jasmeez7@gmail.com'});
                 email.setSenderDisplayName(acc1.owner.FirstName);
                 email.setSubject('Account Assignment notification');
                 email.setPlainTextBody('Hi ,'+'\n You have been assigned an Account with below metioned details: ' + 
                       '\n Account Name : ' +  acc1.Name +
                       '\n Previous Owner : ' + userMap.get(OldAcc.ownerId).Name  +
                       '\n Cust ID : ' + acc1.Cust_ID__c) ;    
                 emails.add(email);
             }
         } 
         
     
     }
        if(emails.size() > 0)
        Messaging.sendEmail(emails);
    }
  
  }
*/
}