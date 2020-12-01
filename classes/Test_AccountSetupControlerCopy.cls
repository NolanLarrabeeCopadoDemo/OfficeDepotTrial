@isTest
public class Test_AccountSetupControlerCopy {
    @isTest
    private static void test_getDataValidate() {
        Account prospectAccount = Test_Utils.CreateAccount('Prospect');
        insert prospectAccount;    
        Account siteAccount = Test_Utils.CreateAccount('Site');
        siteAccount.primary_site__c = true;
        siteAccount.Related_Account__c = prospectAccount.id; 
        insert siteAccount;   
        id rec=[Select Id from recordtype where name='Field Sales (US)'].id;
        Opportunity opportunity = new Opportunity(Name = 'TEST',CloseDate = System.today(),StageName = 'Open',Amount = 200,AccountId = prospectAccount.id ,recordtypeid=rec);
        insert opportunity;
        Contact contact = Test_Utils.CreateContact(prospectAccount.id);  
        contact.primary_contact__c = true;
        update contact;
        Sales_Person__c s = new Sales_Person__c();
        s.User__c = [Select Id,isActive FROM User WHERE Profile.Name = 'System Administrator' AND isActive = true LIMIT 1].Id;
        s.Primary__c = true;
        s.ExtIDSalesPerson__c = 'TEMPID';
        insert s;
        Quote Quoterec = new Quote(Name = 'TEST',OpportunityId=opportunity.id,status = 'Accepted by Customer');
        insert Quoterec;
        Account_Setup_Request__c  AccRec = new Account_Setup_Request__c (Account__c=prospectAccount.id);
        insert AccRec;
        String rec1='{"Id":"'+AccRec.id+'","IsAccountSetUpSubmitted__c":false,"Account__c":"'+prospectAccount.id+'","BillTo_Name__c":"NO CHECK","Primary_Contact_Email__c":"dee@test.com","Primary_Contact_First_Name__c":"Deepak","Primary_Contact_Last_Name__c":"bharadwaj","Primary_Contact_Phone__c":"(222) 222-2222","Account_Phone__c":"(123) 123-1234","Street_Address_Bill__c":"BOCA RATON","Street_Address_2_Bill__c":"Hyd","State_Bill__c":"FL","Zip_Bill__c":"33496","City_Bill__c":"BOCA RATON","BILL_COUNTRY__c":"USA","ShipTo_Name__c":"NO CHECK","Street_Address_Ship__c":"BOCA RATON","Street_Address_2_Ship__c":"Hyd","State_Ship__c":"FL","Zip_Ship__c":"33496","City_Ship__c":"BOCA RATON","SHIP_COUNTRY__c":"USA","Does_your_Customer_have_any_ordering_pr__c":"No","Special_Delivery_Requirements__c":"No","EDI_or_Punch_Out__c":"No","Billing_Delivery_Method_Media_type__c":"Paper","AP_Contact_First_Name__c":"Thiru","AP_Contact_Last_Name__c":"Thiru","AP_Contact_Email__c":"rohi@fmail.com","AP_Contact_Phone__c":"(123) 456-1234","PD_Incl_Backup_Inc__c":"No","Billing_Frequency__c":"Weekly","Tax_Exempt__c":"Yes","Tax_Exempt_States__c":"ID,LA,NJ,OK","Why_are_you_tax_exempt__c":"0","IsAccountSetUp__c":true,"PD_Doc_Name__c":"Standard Invoice","DML__c":"EXPEDITORS","Show_Net_30_Question__c":false,"Show_Net_20__c":true,"IsAccountSetUp__c":false}';
        String rec2='{"Account__c":"'+prospectAccount.id+'","BillTo_Name__c":"NO CHECK","Primary_Contact_Email__c":"dee@test.com","Primary_Contact_First_Name__c":"Deepak","Primary_Contact_Last_Name__c":"bharadwaj","Primary_Contact_Phone__c":"(222) 222-2222","Account_Phone__c":"(123) 123-1234","Street_Address_Bill__c":"BOCA RATON","Street_Address_2_Bill__c":"Hyd","State_Bill__c":"FL","Zip_Bill__c":"33496","City_Bill__c":"BOCA RATON","BILL_COUNTRY__c":"USA","ShipTo_Name__c":"NO CHECK","Street_Address_Ship__c":"BOCA RATON","Street_Address_2_Ship__c":"Hyd","State_Ship__c":"FL","Zip_Ship__c":"33496","City_Ship__c":"BOCA RATON","SHIP_COUNTRY__c":"USA","Does_your_Customer_have_any_ordering_pr__c":"No","Special_Delivery_Requirements__c":"No","EDI_or_Punch_Out__c":"No","Billing_Delivery_Method_Media_type__c":"Paper","AP_Contact_First_Name__c":"Thiru","AP_Contact_Last_Name__c":"Thiru","AP_Contact_Email__c":"rohi@fmail.com","AP_Contact_Phone__c":"(123) 456-1234","PD_Incl_Backup_Inc__c":"No","Billing_Frequency__c":"Weekly","Tax_Exempt__c":"Yes","Tax_Exempt_States__c":"ID,LA,NJ,OK","Why_are_you_tax_exempt__c":"0","IsAccountSetUp__c":true,"PD_Doc_Name__c":"Standard Invoice","DML__c":"EXPEDITORS","Show_Net_30_Question__c":false,"Show_Net_20__c":true,"IsAccountSetUp__c": false}';
        AccountSetUpController.getAccountData(opportunity.id);
        //AccountSetUpController.SubmitProspect(rec1);
        AccountSetUpController.SubmitProspectOnClose(rec2);
        Test.startTest();
        Test.stopTest();    
    }
    @isTest
    private static void test_getDataValidate1() {
        Sales_Person__c s = new Sales_Person__c();
        s.User__c = [Select Id,isActive FROM User WHERE Profile.Name = 'System Administrator' AND isActive = true LIMIT 1].Id;
        s.Primary__c = true;
        s.ExtIDSalesPerson__c = 'TEMPID';
        insert s;
        id Accrec=[Select Id from recordtype where name='Prospect'].id;
        Account account = new Account(Name = 'TEST',
                                      ShippingStreet = 'ABC',
                                      ShippingState = 'ABC',
                                      ShippingCity = 'ABC',
                                      Ranking__c = 100,
                                      Rep_call_date__c = date.today(),
                                      //account.Opportunity_Amt__c = 100
                                      Country__c = 'USA',
                                      RecordTypeId =Accrec,
                                      //account.Primary_Contact_Phone__c = '(999) 999-9999'
                                      Sales_PersonID__c = s.Id,
                                      //Assign_Specific_Owner__c = usr.id,
                                      // account.Auto_Assign__c = true;
                                      Auto_Assign__c = false,
                                      Oracle_Party_ID__c=null,
                                      Industry_OD_SIC_Rep__c=null,
                                      Sector__c=null,Segment__c=null
                                     );
        insert account;
        
        Account siteAccount = Test_Utils.CreateAccount('Site');
        siteAccount.primary_site__c = true;
        siteAccount.Related_Account__c = account.id; 
        insert siteAccount;   
        id rec=[Select Id from recordtype where name='Field Sales (US)'].id;
        Opportunity opportunity = new Opportunity(Name = 'TEST',CloseDate = System.today(),StageName = 'Open',Amount = 200,AccountId = account.id ,recordtypeid=rec);
        insert opportunity;
        Contact contact = Test_Utils.CreateContact(account.id);  
        contact.primary_contact__c = true;
        update contact;
        String errorMessage = '';
        Quote Quoterec = new Quote(Name = 'TEST',OpportunityId=opportunity.id,status = 'Accepted by Customer');
        insert Quoterec;
        AccountSetUpController.getDataValidate(opportunity.id);
        Test.startTest();
        Test.stopTest();    
    }
    
    @isTest
    private static void test_CreateDMLOption() {
        DML__C dml = new DML__C(DECISION_MAKER_NM__c='tst',Effective_Start_Date__c=system.today());
        insert dml;
        Org__C org = new Org__C(Business_Name__c = 'TEST',GLOBAL_ULTIMATE_DUNS_NUM__c='1234567');
        insert org;
        List<String> AllStates = new List<String> {'AL', 'AK', 'AZ', 'AR', 'CA', 'CO', 'CT', 'DC', 'DE', 'FL'};
            String selectedStates ='{"ID,LA,NJ,OK"}';
        DML_Relation__c dmlr = new DML_Relation__c(DML__C=dml.id,org__C=org.id,CUSTOMERID__c='123456',Effective_Start_Date__c=system.today());
        insert dmlr;
        Account prospectAccount = Test_Utils.CreateAccount('Prospect');
        insert prospectAccount;   
        prospectAccount.Org__c=org.id;
        update prospectAccount;
        Account siteAccount = Test_Utils.CreateAccount('Site');
        siteAccount.primary_site__c = true;
        siteAccount.Related_Account__c = prospectAccount.id; 
        insert siteAccount;   
        id rec=[Select Id from recordtype where name='Field Sales (US)'].id;
        Opportunity opportunity = new Opportunity(Name = 'TEST',CloseDate = System.today(),StageName = 'Open',Amount = 200,AccountId = prospectAccount.id ,recordtypeid=rec);
        insert opportunity;
        Contact contact = Test_Utils.CreateContact(prospectAccount.id);  
        contact.primary_contact__c = true;
        update contact;
        String dmlrec ='{"sobjectType":"DML__c","DECISION_MAKER_NM__c":"Rhi","Notes__c":"hi check json","Reason_for_Creation__c":"Picklist1"}';
        AccountSetUpController.getDMLData(opportunity.id);
        Alternate_DML__c altdml=new Alternate_DML__c();
        altdml.ZIP_CODE__c='123123';
        altdml.BUSINESS_NAME__c='Test';
        altdml.STREET_ADDR__c='Street 2';
        altdml.CITY__c='Hyderabad';
        altdml.STATE__c='Telangana';
        altdml.OPERATIONAL_DUNS_NUM__c='897898789';
        altdml.GLOBAL_ULTIMATE_DUNS_NUM__c=org.GLOBAL_ULTIMATE_DUNS_NUM__c;
        insert altdml;
        
        Test.startTest();
        AccountSetUpController.CreateDMLOption(opportunity.id, dmlrec);
        AccountSetUpController.getStatesMap(AllStates,selectedStates);
        AccountSetUpController.getAccountData(opportunity.id);
        AccountSetUpController.getAltDML(opportunity.id);
        AccountSetUpController.CreateAltDML(altdml.Id);
        AccountSetUpController.CreateSugAltDML(altdml.Id);
        Test.stopTest();    
        
    }
       
    
    
}