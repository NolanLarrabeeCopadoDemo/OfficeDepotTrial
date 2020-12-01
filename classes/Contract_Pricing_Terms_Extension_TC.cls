@isTest
private class Contract_Pricing_Terms_Extension_TC
{
      static testMethod  void Contract_Pricing_Terms_Extension_TC (){
       Profile p4 = [SELECT Id FROM profile WHERE name='System Administrator'];   
         User us1 = new User(alias = 'us_1', email='proxy@proxy1456.officedepot.com',OD_Employee_ID__c='113456',emailencodingkey='UTF-8', lastname='lastnam1',languagelocalekey='en_US',localesidkey='en_US', profileid = p4.Id,timezonesidkey='America/Los_Angeles',username='12proxy@proxy456.com');
         insert us1;
          system.runAs(us1){
      Account acc = new Account ();
        acc.name = 'Tehlaka2';
          insert acc;
          
    contract c = new contract ();
    c.Name='test1';
    c.AccountId = acc.Id;
    insert c;
 
    
    Contract_Pricing_Terms__c cp = new Contract_Pricing_Terms__c();
    cp.Relevant_Customer_Level__c= 'abc' ;
    cp.Contract__c = c.Id;
    cp.Departments__c= 'test';
    cp.Active__c=true;
    cp.Required_Timing_Of_CC_Updates__c = 'testing';
    cp.Vendor_Letter_Required_For_CC_Increase__c = 'trial';
    cp.Comm_Req_CC_Price_Chg__c = 'Notification and customer approval';
    cp.CC_Prc_Chg_Notice_Reqd_days__c = 3;
    cp.CC_Price_Incr_Cap_Pegd_To__c= 'Consumer Price Index (CPI)';
    cp.CC_Price_Incr_Capped__c = 'trial 5';
    insert cp;
    
    Merch_Dept_Group__c md = new Merch_Dept_Group__c();
    //md.Name= 'test2';
    md.Department__c = cp.Departments__c ;
    md.Dept_Group_Name__c = 'Select All';
    md.Active__c = true; 
    insert md;
  
    test.startTest();
     System.runAs(us1)
         {
    //List<string> pageUrl = ApexPages.currentPage().getUrl().split('\\?');        
    //Id id='';
    ApexPages.currentPage().getParameters().Put('id','\\?'+cp.Id);
    ApexPages.StandardController con = new ApexPages.StandardController(cp);    
    Contract_Pricing_Terms_Extension cpt = new Contract_Pricing_Terms_Extension(new ApexPages.StandardController(cp));
    

    cpt.PopulateCheckBox();
    cpt.disableDepartment();
      cpt.saveAndNew() ;
    cpt.backToContract();
    cpt.saveRecord();
    
     cpt.Populatevalue();

    cp.Required_Timing_Of_CC_Updates__c = null;
     update cp;
   


    cp.Vendor_Letter_Required_For_CC_Increase__c = null;
     update cp;
     

    cp.Comm_Req_CC_Price_Chg__c = null;
     update cp;
    

    cp.CC_Prc_Chg_Notice_Reqd_days__c = null;
     update cp;
     

    cp.CC_Price_Incr_Cap_Pegd_To__c= null;
     update cp;
    
    cp.CC_Price_Incr_Capped__c =null;
     update cp;
   

    cp.Relevant_Customer_Level__c = null;
    update cp;
    cpt.saveRecord();
        
    ApexPages.currentPage().getParameters().Put('clone','1');    
    cpt.saveRecord();
    cp.Department_Groups__c = 'Select All';
    update cp;
    
    cpt.PopulateCheckBox();
    
    
    cp.CC_Price_Incr_Cap_Pegd_To__c= 'Yes';
    update cp;
    cpt.Populatevalue();
    //Added by Lalit for S-399112 START
    cpt.conditionaldisplay();
    cpt.Deleterecord();
    List<Contract_Pricing_Terms__c> fetchedCP = new List<Contract_Pricing_Terms__c>();
    fetchedCP = [select id from Contract_Pricing_Terms__c where id = :cp.id];
    System.assert(fetchedCP.size() == 0);
    //Added by Lalit for S-399112 END
    }
    test.stopTest();
    }
      }

}