@isTest
private class Prospect_Edit_Extension_TC 
{

    static testMethod void myUnitTest() 
    {
    
    Profile p = [SELECT Id FROM Profile WHERE Name='System Administrator']; 
      User u = new User(Alias = 'Standar', Email='standarduser@officedepot.com', 
      EmailEncodingKey='UTF-8', LastName='Tester', LanguageLocaleKey='en_US', 
      LocaleSidKey='en_US', ProfileId = p.Id, 
      TimeZoneSidKey='America/Los_Angeles', UserName='standardusr@officedepot.com');
    
        Schema.DescribeSobjectResult ar = Schema.SobjectType.Account;
        Map<String,schema.RecordtypeInfo> AccRecType = ar.getRecordTypeInfosByName();
        Id customerRecId=AccRecType.get('Customer').getRecordTypeId();
        Id siteRecId=AccRecType.get('Site').getRecordTypeId();    
        Id ProspectId=AccRecType.get('Prospect').getRecordTypeId();  
       System.runAs(u) 
       { 
        Account accpro= new Account();
        accpro.RecordtypeId = ProspectId;
        accpro.name = 'SUN Test Prospect';
        accpro.BillingStreet = '1040 N 326 W';
        accpro.billingcity = 'Orem';
        accpro.zip__c = '123456';
        accpro.address1__c = 'abc';
        accpro.City__c = 'Oklahama';
        accpro.state__c = 'FL';
        accpro.Country__c = 'USA';
        accpro.BillingState = 'UT';
        accpro.Billingcountry = 'USA';
        accpro.Oracle_Party_Id__c = '122356';
        insert accpro;

        Prospect_Message__c Pmessage = new Prospect_Message__c();
        Pmessage.Name = 'Test';
        Pmessage.Account__c = accpro.id;
        Pmessage.Message_Complete__c = 'NP';
        insert Pmessage; 

        Account acc1 = new Account ();
        acc1.name = 'SUN Test Account';
        acc1.BillingStreet = '1040 N 326 W';
        acc1.billingcity = 'Orem';
        acc1.zip__c = '123456';
        acc1.address1__c = 'abc';
        acc1.City__c = 'Oklahama';
        acc1.state__c = 'FL';
        acc1.Country__c = 'USA';
        acc1.BillingState = 'UT';
        acc1.Billingcountry = 'USA';
        acc1.Oracle_Party_Id__c = '123457';
        acc1.AOPS_Cust_Id__c = '000057';
        acc1.AOPS_Seq_ID__c = '003457';
        acc1.RecordtypeId = customerRecId;
        acc1.Pricing_template_cd__c = 'BIO';
        insert acc1;

        Account acc = new Account ();
        acc.name = 'SUN Test Account';
        acc.BillingStreet = '1040 N 326 W';
        acc.billingcity = 'Orem';
        acc.zip__c = '123456';
        acc.address1__c = 'abc';
        acc.City__c = 'Oklahama';
        acc.state__c = 'FL';
        acc.Country__c = 'USA';
        acc.BillingState = 'UT';
        acc.Billingcountry = 'USA';
        acc.Oracle_Party_Id__c = '123456';
        acc.AOPS_Cust_Id__c = '123456';
        acc.AOPS_Seq_ID__c = '123456';
        acc.Pricing_template_cd__c = 'Elite $50K to $75K';
        acc.ParentId = acc1.id;
        acc.RecordtypeId = customerRecId;
        acc.Potential_DeDuplicate__c = true;
        insert acc;
        system.debug('Before update'+acc.City__c);
        
        Account accsite= new Account();
        accsite.RecordtypeId = siteRecId;
        accsite.AOPS_Seq_ID__c = '123456-0087';
       // accsite.Site_Primary_Contact__c = c1.id;
        accsite.Related_Account__c = acc.id;
        accsite.Primary_Site__c = true;
        accsite.Name='Test';
        insert accsite;

        
        Pricing_template__c temp = new Pricing_template__c(name = 'Elite $50K to $75K' ,Parent_Id__c = '123456');
        insert temp;
        
        Pricing_template__c temp1 = new Pricing_template__c(name = 'BIO' ,Parent_Id__c = '123456' );
        insert temp1;

        DMND_Potential_Warning__c pdw = new DMND_Potential_Warning__c(Warning_Key__c = 'test');
        //DMND_Potential_Warning__c pdw = new DMND_Potential_Warning__c();
        insert pdw;
        DMND_Duplicate__c dup = new DMND_Duplicate__c(Potential_Duplicate_Warning__c = pdw.id, Disposition__c = 'Inactive', Account__c = acc.id);
        insert dup;

        DMND_Duplicate__c dup1 = new DMND_Duplicate__c(Potential_Duplicate_Warning__c = pdw.id, Disposition__c = 'Inactive', Account__c = acc1.id);
        insert dup1; 
        
        
        test.starttest();
        PageReference pageRef = ApexPages.currentPage();
        Test.setCurrentPage(pageRef);
        ApexPages.StandardController con = new ApexPages.StandardController(acc);
        ApexPages.currentPage().getParameters().Put('id',acc.id);
        Prospect_Edit_Extension controller = new Prospect_Edit_Extension(con);
        controller.populateparentaccount();
        
        //test.starttest();
       // Test.setMock(HttpCalloutMock.class, new G1AddressValidation());
        
        ApexPages.StandardController con1 = new ApexPages.StandardController(acc1);
        ApexPages.currentPage().getParameters().Put('id',acc1.id);
        Prospect_Edit_Extension controller1 = new Prospect_Edit_Extension(con1);
        controller1.populateparentaccount();
        controller.filllookup();
        controller.openlookup(); 
        controller.Search();
        controller.validateAddress();
        controller.duCheck();
        controller.closeLookupSection();
        acc.Related_Parent_Account__c=acc1.id;
        controller.SaveAllData();
        acc.Related_Parent_Account__c='';
        controller.customerid=false;
        controller.SaveAllData();
        controller.pricingTempNotMatching=true;
        controller.SaveAllData();
        controller.updateDeDup =true;
        controller.SaveAllData();
        
        
        acc.name = 'SUN Test Account';
        acc.BillingStreet = '1040 N 326 W';
        acc.billingcity = 'Orem';
        acc.zip__c = '1235';
        acc.address1__c = 'abc5';
        acc.state__c = 'FL';
        acc.Country__c = 'IND';
        acc.City__c = 'Ohama5';
        controller.SaveAllData();
        
        acc.name = 'SUN Test Account';
        acc.BillingStreet = '10900 W Oakland Park Blvd';
        acc.billingcity = 'Orem';
        acc.zip__c = '33351';
        acc.address1__c = '10900 W Oakland Park Blvd';
        acc.state__c = 'FL';
        acc.Country__c = 'USA';
        acc.City__c = 'Sunrise';
        ApexPages.currentPage().getParameters().Put('id',acc.id);
        controller.SaveAllData();
        controller.filllookup();
        controller.openlookup() ;  
        controller.validateAddress();
        controller.duCheck();
        controller.closeLookupSection();
        update acc;
        controller1.SaveAllData();
        test.stoptest();
        
        /*
        controller1.PTList.clear();
        controller1.customerId=false;
        controller1.populateparentaccount();
        //controller.populateparentaccount();
        controller.customerid=true;
        controller.recordCatergory ='GP';
        controller.SaveAllData();
        controller.recordCatergory ='No Account';
        controller.SaveAllData();
        system.debug('After update'+acc.City__c);
        temp.Parent_Id__c = null;
        update temp;
        temp1.Parent_Id__c = null;
        update temp1;
        */
        //controller1.populateparentaccount();
        //controller.openlookup() ;
        
        
      }
       
        
    }
}