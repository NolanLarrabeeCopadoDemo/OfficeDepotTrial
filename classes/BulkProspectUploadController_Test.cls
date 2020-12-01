/*************************************************************
*Name : BulkProspectUploadController_Test
*Created By : Sandesh Ganjare
*Created Date :
*Purpose : Test class for BulkProspectUploadController.
*JIRA:
****************************************************************/
@istest
public with sharing class BulkProspectUploadController_Test {
    public BulkProspectUploadController_Test() {

    }
    @TestSetup public static void setup(){
        List<User> userList = DataFactory.createUserTestRecords('Test', 1);
        List<Org__c> OrgList = DataFactory.createOrgTestRecords('Test acc', 5, '');
        Pricing_Template__c Pricing = Test_Utils.createPricingTemplate();
        INSERT Pricing;
        //OrgList[0].
        //OrgList[0].

        Recordtype rcd =  [select id from recordtype where name = 'Prospect'];
        List<Account> accountList = DataFactory.createAccountTestRecords('Test acc', 5, '');
        accountList[0].Oracle_Party_Id__c = '123456';           
        accountList[0].OwnerId=userList[0].id;
        accountList[0].recordtypeid = rcd.id;
        accountList[0].Industry_OD_SIC_Rep__c = 'Accounting';
        accountList[0].Org_WCW_Count_DB__c =11112234;
        accountList[0].Org_WCW_Count_Rep__c = 55 ;
        accountList[0].ZIP__C = '111111';
        accountList[0].AccountNumber ='223112';
        //accountList[0].Sales_PersonID__c = salesPerson.id; //Sales person Id for the Salesforce USer
        accountList[0].Org__c = OrgList[0].Id;
        UPDATE accountList;

        
        List<DML__c> DMLList = DataFactory.createDMLTestRecords('Test acc', 5, '');

        DML_Relation__c dmlr = new DML_Relation__c();
        dmlr.DML__c=DMLList[0].Id;
        dmlr.Org__c=OrgList[0].Id;
        dmlr.Account__c=accountList[0].Id; 
        dmlr.Effective_Start_Date__c= Date.today();
        INSERT dmlr;

        DNB_API_Setting__c dnbApiSetting = new DNB_API_Setting__c();
        dnbApiSetting.Name = 'DNB API Value';
        dnbApiSetting.ConsumerKey__c = 'test';
        dnbApiSetting.ConsumerSecret__c = 'test';
        dnbApiSetting.Timestamp__c = '2020-04-17 10:38:51';
        dnbApiSetting.AuthAPI__c = 'https://plus.dnb.com/v2/token';
        dnbApiSetting.AccessToken__c = 'test';
        dnbApiSetting.SearchAPI__c = 'https://plus.dnb.com/v1/search/criteria';
        insert dnbApiSetting;


       
    
        Sales_Person__c s= new Sales_Person__c();
        s.Name='ES10305';
        s.IsActive__c=true;
        s.Role_Relate_Id__c ='333333';
        s.Primary__c =true;
        s.user__c=userList[0].id;
        insert s; 
                        
    }
    private class RestMock implements HttpCalloutMock {

        public HTTPResponse respond(HTTPRequest req) {
            String fullJson = '{"transactionDetail":{"transactionID": "rrt-0c0248b9801629bb1-a-se-4529-15800907-12","transactionTimestamp": "2020-07-02T08:00:24.671Z","inLanguage": "en-US","serviceVersion": "1"},"inquiryDetail": {"countryISOAlpha2Code": "FL","searchTerm": "Uptown Pizza","pageNumber": 1,"returnNavigators": true,"postalCode": "33444","tradeStyleName": "Uptown Pizza","pageSize": 10,"primaryName": "Uptown Pizza","addressLocality": "Delray Beach","addressRegion": "Delray Beach","streetAddressLine1": "2235 Seacrest Blvd"},"candidatesReturnedQuantity": 2,"candidatesMatchedQuantity": 23,';
            fullJson = fullJson+ '"searchCandidates": [{"displaySequence": 1,"organization": {"duns": "804735132","dunsControlStatus": {"isOutOfBusiness": false,"isMarketable": false,"isTelephoneDisconnected": false,"isMailUndeliverable": false,"isDelisted": true},"primaryName": "Gorman Manufacturing Company, Inc.","primaryAddress": {';
            fullJson = fullJson+ '"addressCountry": {"isoAlpha2Code": "US"},"addressLocality": {"name": "San Francisco"},"addressRegion": {"name": "California","abbreviatedName": "CA"},"postalCode": "94110","streetAddress": {"line1": "492 Koller St"},"latitude": 37.777709,"longitude": -122.404624,"isManufacturingLocation": true},"primaryIndustryCodes":';
             fullJson = fullJson+   '[{"usSicV4": "2752","usSicV4Description": "Lithographic commercial printing"}],"corporateLinkage": {"isBranch": false,"globalUltimateFamilyTreeMembersCount": 7,"globalUltimate": {"duns": "804735132","primaryName": "Gorman Manufacturing Company, Inc."}},"numberOfEmployees": [{"value": 120,"informationScopeDescription":';
              fullJson = fullJson+  '"Headquarters Only (Employs Here)","informationScopeDnBCode": 9068,"reliabilityDescription": "Actual","reliabilityDnBCode": 9092}],"industryCodes": [{"code": "323111","description": "Commercial Printing (except Screen and Books)",';
              fullJson = fullJson+  '"typeDescription": "North American Industry Classification System 2017","typeDnbCode": 30832,"priority": 1}],"businessEntityType": {"dnbCode": 451,"description": "Corporation"},"isStandalone": false}}]}';
            HTTPResponse res = new HTTPResponse();
            res.setHeader('Content-Type', 'application/json');
            res.setBody(fullJson);
            res.setStatusCode(200);
            return res;
        }
    }

    Static testMethod void searchCustInformation_Method(){
        Test.setMock(HttpCalloutMock.class, new RestMock());
        Map<String,List<Org__c>> mapOfSearchResults = new Map<String,List<Org__c>>();
        String str = '[{"Index":"0","Name":"Uptown Pizza1","Address1__c":"2235 Seacrest Blvd1","Address2__c":"","City__c":"Delray Beach","Country__c":"USA","State__c":"FL","Zip__c":"33444","Phone":"1111222233","FirstName":"Sandesh","LastName":"Test","Title":"","Decision_Maker__c":"Yes","Email":"test@test.com","Department":"","Phone1_Rep__c":"1222233333","Sector__c":"","Segment__c":"","Pricing_template_cd__c":"Standard Web Match Test","Industry_OD_SIC_Rep__c":"","Org_WCW_Count_Rep__c":"","Est_Spend__c":"","Payment_Term__c":"","Primary_Product__c":""},{"Index":"1","Name":"Associated Wholesale Grocers","Address1__c":"5000 Kansas Ave.","Address2__c":"","City__c":"Kansas City","Country__c":"USA","State__c":"KS","Zip__c":"66106-1135","Phone":"1111222233","FirstName":"Test","LastName":"Testing","Title":"","Decision_Maker__c":"No","Email":"best@best.com","Department":"","Phone1_Rep__c":"4444333322","Sector__c":"","Segment__c":"","Pricing_template_cd__c":"","Industry_OD_SIC_Rep__c":"","Org_WCW_Count_Rep__c":"","Est_Spend__c":"","Payment_Term__c":"","Primary_Product__c":""}]';               
        Test.StartTest();           
            mapOfSearchResults = BulkProspectUploadController.searchCustInformation(str);         
        Test.StopTest();
        
        System.assertEquals(true, mapOfSearchResults != null);
     }

     Static testMethod void getDMLData_Method(){
        Map < Id, String > mapOfDMLResults = new Map < Id, String >();
        Account account = [SELECT Id, Name FROM Account Where Oracle_Party_Id__c='123456' LIMIT 1];              
        Test.StartTest();           
            mapOfDMLResults = BulkProspectUploadController.getDMLData(String.ValueOf(account.id));         
        Test.StopTest();
        
        System.assertEquals(true, mapOfDMLResults != null);
     }

     Static testMethod void commitAccountSetupRequests_Method(){
        List<Account> lstAcc = [Select id from Account LIMIT 1];
        String jsonASP = '[{"BillTo_Name__c":"Associated Wholesale Grocers","Street_Address_Bill__c":"5000 Kansas Ave.","Street_Address_2_Bill__c":"","City_Bill__c":"Kansas City","State_Bill__c":"KS","BILL_COUNTRY__c":"USA","Zip_Bill__c":"66106-1135","Account_Phone__c":"1111222233","Street_Address_Ship__c":"5000 Kansas Ave.","Street_Address_2_Ship__c":"","City_Ship__c":"Kansas City","State_Ship__c":"KS","SHIP_COUNTRY__c":"USA","Zip_Ship__c":"66106-1135","Primary_Contact_First_Name__c":"Test","Primary_Contact_Last_Name__c":"Testing","Primary_Contact_Phone__c":"4444333322","Primary_Contact_Fax__c":"","Primary_Contact_Email__c":"best@best.com","Does_your_Customer_have_any_ordering_pr__c":"No","PO__c":"","Desktop__c":"","Cost_Center__c":"","Release__c":"","Rename_Purchase_Order__c":"","Rename_Desktop__c":"","Rename_Cost_Center__c":"","Rename_Release__c":"","Minimum_Order_Value__c":"","Budgets_CC_PO__c":"","Special_Delivery_Requirements__c":"No","Print_Invoice__c":"","Display_Purchase_Orders__c":"","Display_Payment_Method__c":"","Display_Prices__c":"","Backorders_displayed_on_packing_list__c":"","Rename_Packlist__c":"","EDI_or_Punch_Out__c":"No","Employer_TIN__c":"","Is_IRS_W9_Required_for_AP__c":"","Tax_Exempt__c":"","Tax_Exempt_States__c":"","Why_are_you_tax_exempt__c":"","Goverment_Branch__c":"","DML__c":"","Rep_Comments__c":"tested","ACCOUNT__c":"'+lstAcc[0].id+'"}]';              
        Test.StartTest();           
            BulkProspectUploadController.commitAccountSetupRequests(jsonASP);         
        Test.StopTest();
        List<Account_Setup_Request__c> result = [select id from Account_Setup_Request__c];
        System.assertEquals(true, result != null);
     }

     Static testMethod void commitProspects_Method(){
        Map<String, String> mapResults = new Map<String, String>();
        String prospectjson = '[{"Index":"0","Name":"Uptown Pizza1","Address1":"2235 Seacrest Blvd1","Address2":"","City":"Delray Beach","Country":"USA","State":"FL","Zip":"33444","Phone":"1111222233","FirstName":"Sandesh","LastName":"Test","Title":"","Decision_Maker":"Yes","Email":"test@test.com","Department":"","Phone1_Rep":"1222233333","Phone_Type1":"Work","Sector":"Private","Segment":"Small < $10K","Pricing_template_cd":"Air Force","Industry_OD_SIC_Rep":"Accounting","Org_WCW_Count_Rep":"22","Est_Spend":"3333333","Payment_Term":"Credit Card","Primary_Product":"CBS","Sales_PersonID":"ES10305"}]';
        String orgjson = '[{"value":{"Business_Name__c":"Uptown Pizza Inc.","D_B_ID__c":"006558405","DUNS_Number__c":"006558405","Address_1__c":"2235 Seacrest Blvd","City__c":"Delray Beach","State__c":"FL","Zip__c":"33444-4205","Company_Phone__c":"5612785634","Website__c":"uptownpizzadelray.com","LOB__c":"Limited-Service Restaurants","Employee_Count__c":10,"Annual_sales__c":288108},"key":"Uptown Pizza1-33444"},{"value":{"Business_Name__c":"None Of the Above"},"key":"Associated Wholesale Grocers-66106-1135"}]';
        Test.StartTest();           
           mapResults = BulkProspectUploadController.commitProspects(prospectjson,orgjson);         
        Test.StopTest();
        
        System.assertEquals(true, mapResults != null);
     }

}