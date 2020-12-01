/*-------------------------------------------------------------------------------
*Name           : Edit_Navigation_Extention
*Created By     : Abinaya
*Purpose        : To redirect the page based on recordtype
---------------------------------------------------------------------------------*/

public with sharing class Edit_Navigation_Extention {
    public Account account;
    public list<BusinessProSetup__mdt> bproSetup {get;set;}
    public Edit_Navigation_Extention(ApexPages.StandardController stdController) {  
        this.account = (Account)stdController.getRecord();  
        bproSetup = [select AccountRecordType__c,AccountRetURL__c,ContactRecordType__c,LeadRecordType__c,noOverrideEditURL__c,OpportunityRecordType__c,PublicGroupName__c from BusinessProSetup__mdt limit 1];
    }
    // Redirect the page based on selected record type
    public PageReference redirectToPage() {
      String selectedRecordType = account.RecordTypeId;//ApexPages.currentPage().getParameters().get('RecordType');
      system.debug('selectedRecordType***'+selectedRecordType);
      string RecordTypeName = [select name, id from recordtype where id=:selectedRecordType].Name;
      String prosRecType= 'Prospect';
      String siteRecType= 'Site';
      
      //BusinessPro Addition - starts
        if (bproSetup.size() > 0) {
         String bproRecType = bproSetup[0].AccountRecordType__c;
         if (RecordTypeName == bproRecType) {
          return new PageReference('/'+account.ID+bproSetup[0].noOverrideEditURL__c+account.ID);
         }
        }
      // BusinessPro Addition - Ends
      
      
       id prosRecordTypeId = [select name, id from recordtype where Name=:prosRecType].id;
        id siteRecordTypeId = [select name, id from recordtype where Name=:siteRecType].id;
      system.debug('RecordTypeName***'+RecordTypeName );
      if (RecordTypeName == 'Prospect')
        return new PageReference('/apex/prospect_edit?id='+ account.Id);
      else if (RecordTypeName == 'Prospect (OfficeMax)')
      {
      system.debug('RecordTypeName*** Prospect_OfficeMax');
       account.RecordTypeId=prosRecordTypeId;
      update account;
        List <Account> sites = new List <Account>();
       for(Account site :[select id,RecordTypeId from account where Related_Account__c =:account.Id]){    
           system.debug(' ProspectSite' +site.id);
           site.RecordTypeId=  siteRecordTypeId;
           sites.add(site);
        }
     update sites;
     
        return new PageReference('/apex/prospect_edit?id='+ account.Id);
      }
      
      else 
      {//Update by Mohan for the Case #00142652
      
       //return new PageReference('/'+account.id+'/e?nooverride=1');
        return new PageReference('/'+account.id+'/e?nooverride=0&retURL=%2F'+account.id);
       // return new PageReference('/'+account.id+'/e?nooverride=0&RecordType='+ApexPages.currentPage().getParameters().get('RecordType')+'&retURL=%2F'+account.id);
       
       }
    }
    // ------End-----
    /*@isTest
    private static void Edit_Navigation_Extention_Test() {
        Id rcid =Schema.SObjectType.Account.getRecordTypeInfosByName().get('Prospect').getRecordTypeId();
        Id omaxrcid =Schema.SObjectType.Account.getRecordTypeInfosByName().get('Prospect (OfficeMax)').getRecordTypeId();
        
        Profile profile = [select id from profile where name='System Administrator'];
        
        User TestUser = new User(alias = 'standt', email='standarduser@wipro.com', 
                           emailencodingkey='UTF-8',IsActive =true, lastname='Testing', languagelocalekey='en_US', 
                           localesidkey='en_US', profileid = profile.Id,OD_Employee_ID__c = '670065', 
                           timezonesidkey='America/Los_Angeles',username='testKam@wipro.com.od.uat');
                           
        insert TestUser;
        system.runAs(TestUser){
        
        Sales_Person__c salesID = new Sales_Person__c(ExtIDSalesPerson__c='243445',IsActive__c = true,Primary__c = true,User__c=TestUser.id,Name='76348');
        
        Account acc = new Account ();
        acc.name = 'SUN Test Account1';
        acc.BillingStreet = '1040 N 326 W';
        acc.billingcity = 'Orem';
        acc.zip__c = '123';
        acc.address1__c = 'abc';
        acc.City__c = 'Oklahama';
        acc.state__c = 'FL';
        acc.Country__c = 'USA';
        acc.BillingState = 'UT';
        acc.Billingcountry = 'USA';
        acc.Oracle_Party_Id__c = '123456';
        acc.AOPS_Cust_Id__c = '123456';
        acc.AOPS_Seq_ID__c = '123456';        
        acc.Assign_Specific_Owner__c = TestUser.id;
        acc.RecordTypeId = rcid;
        insert acc;
        ApexPages.StandardController stdController = new ApexPages.StandardController(acc);     
        Edit_Navigation_Extention EditN = new Edit_Navigation_Extention(stdController );
        EditN.redirectToPage();
        
        Account acc1 = new Account ();
        acc1.name = 'SUN Test Account2';
        acc1.BillingStreet = '1040 N 326 W';
        acc1.billingcity = 'Orem';
        acc1.zip__c = '123';
        acc1.address1__c = 'abc';
        acc1.City__c = 'Oklahama';
        acc1.state__c = 'FL';
        acc1.Country__c = 'USA';
        acc1.BillingState = 'UT';
        acc1.Billingcountry = 'USA';
        //acc.Oracle_Party_Id__c = '123456';
        //acc.AOPS_Cust_Id__c = '123456';
        //acc.AOPS_Seq_ID__c = '123456';        
        acc1.Assign_Specific_Owner__c = TestUser.id;
        acc1.RecordTypeId = omaxrcid ;
        insert acc1;
        ApexPages.StandardController stdController1 = new ApexPages.StandardController(acc1);     
        Edit_Navigation_Extention EditN1 = new Edit_Navigation_Extention(stdController1 );
        EditN1.redirectToPage();
    }
    }
    */
}