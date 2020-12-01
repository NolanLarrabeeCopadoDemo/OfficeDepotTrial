@isTest
public class CreateProspectCmpController_TC {
    private static testMethod void MyunitTest() {
        User oUser = [select id,Name,TimeZoneSidKey,Username,Alias,Country,Email,FirstName,LastName,IsActive,IsPortalEnabled 
                      FROM User Where id =: userInfo.getUserId()];
        String recid =  [select id from recordtype where name = 'Prospect (BizBox)' Limit 1].Id;
        CreateProspectCmpController.getRecordTypeNamesAndIds(recid);
        //  String acctype = 'select id from recordtype where name ='Prospect (BizBox)' Limit 1';
        
        system.runAs(oUser)
        {
            recordtype rc1 = [SELECT Id FROM RecordType WHERE SObjectType = 'Opportunity' and name='Field Sales (US)' limit 1];
            //Creating org record
            Org__c Org = new Org__c();
            Org.Business_Name__c = 'NewOrg';
            Org.SalesDataBatch__c = true;
            insert Org;
            
            // Create a test account
            Account testAcct = new Account(Name = 'My Test Account');
            testAcct.Account_Type__c= 'Prospect';
            insert testAcct;
            
            // Create opportunity
            Opportunity oppt = new Opportunity(Name = 'New mAWS Deal',
                                               AccountID = testAcct.ID,
                                               StageName = 'Qualify',                           
                                               ownerId=oUser.id,  
                                               RecordTypeId = rc1.id,
                                               Amount = 3000,
                                               CloseDate = System.today(),
                                               Watson_Door_Opener__c=true,
                                               PLOC_Opportunity_Stage__c='Identify Prospect (1.0)',
                                               Product_Subtype__c='Other Equipment',      
                                               Watson_Notes__C='My text');
            insert oppt;
            
            //Creating contact  
            Contact con1 = new Contact();
            con1.LastName = 'Test1';
            con1.Decision_Maker__c = 'No';
            con1.AccountId = testAcct.id;
            insert con1;
            CreateProspectCmpController.getProspectAndOpp();  
        }
    }
    
    private static testMethod void MyunitTest1() {
        String recid =  [select id from recordtype where name = 'Prospect (Tech-Zone)' Limit 1].Id;
        CreateProspectCmpController.getRecordTypeNamesAndIds(recid);
        User oUser = [select id,Name,TimeZoneSidKey,Username,Alias,Country,Email,FirstName,LastName,IsActive,IsPortalEnabled 
                      FROM User Where id =: userInfo.getUserId()];
        system.runAs(oUser){ 
            //creating lead
            Lead leads=new Lead();
            leads.LastName='Test name';
            leads.FirstName='Test name2';
            leads.Status='Open';
            leads.Company='Test Company';
            insert leads;
            CreateProspectCmpController.onloadAccPicklistVaues(leads.id);
            CreateProspectCmpController.onLoadData(leads.Id);
            CreateProspectCmpController.getAssignSpecificOwnerName(userInfo.getUserId());
            
        }
        
    }
    private static testMethod void MyunitTest2() {
        String pObjName='test';
        String pControllingFieldName='Test 2';
        String pDependentFieldName='Test 3';
        String ctrlPicklistVal='Test 4';
        CreateProspectCmpController.getAccVericalPickValues(pObjName, pControllingFieldName, pDependentFieldName, ctrlPicklistVal);
    }
    
    private static testMethod void MyunitTest3() {
    Test.startTest();
         String recid1 =  [select id from recordtype where name = 'Customer (Business Pro)' Limit 1].Id;
        CreateProspectCmpController.getRecordTypeNamesAndIds(recid1);
        
            String recid =  [select id from recordtype where name = 'Prospect (GT)' Limit 1].Id;
        CreateProspectCmpController.getRecordTypeNamesAndIds(recid);
        CreateProspectCmpController.setCtAndOppRT(recid);
        User oUser = [select id,Name,Username,Alias,Country,Email,FirstName,LastName,IsActive,IsPortalEnabled 
                      FROM User Where id =: userInfo.getUserId()];
        recordtype ld= [SELECT id FROM RecordType where name='Lead (US)' limit 1];
        recordtype accre= [SELECT id FROM RecordType where name='Prospect' limit 1];
        system.runAs(oUser){
            
            Lead leads = new Lead();
            leads.LastName='Test name';
            leads.FirstName='Test name2';
            leads.Status='Open';
            leads.Company='Test Company';
            leads.city__c='Bangalore';
            leads.state__c='LA';
            leads.zip__c='123123';
            leads.RecordTypeId=ld.id;
            leads.Decision_Maker__c='No';
            insert leads;
            String leadId=''+leads.Id;
            system.debug('leadId'+leadId);
            String leadData='{"LastName":"Test name","FirstName":"Test name2","Status":"Open","Company":"Test Company","city__c":"Bangalore","State__c":"LA","zip__c":"123123","RecordTypeId":"'+ld.id+'","Decision_Maker__c":"No"}';
            system.debug('leadata'+leadData);
            
            String newOrFamiliyOrgRecData='[{"Business_Name__c":"Test Org ","SalesDataBatch__c":true}]';
            system.debug('newOrFamiliyOrgRecData'+newOrFamiliyOrgRecData);
            
            String decisionMaking='No';
            
            String parentOrgData='[{"Business_Name__c":"Test Org1","SalesDataBatch__c":true,"DUNS_Number__c":"1234567","D_B_ID__c":"1234567"}]';
            System.debug('parentOrgData'+parentOrgData);
            Org__c org1 =new Org__c();
            org1.Business_Name__c = 'Test Org1';
            org1.SalesDataBatch__c = true;
            insert org1;
            String parentOrgSFId='' + org1.Id;
            
            String contactData1='{"LastName":"Test1","Decision_Maker__c":"No"}';
            //String contactData1= ''+[select id,LastName,Decision_Maker__c from contact where id=:contactData.Id];
            System.debug('contactData1'+contactData1);
            
            String prospectData='{"name":"Test acc","Phone":"1231231234","RecordTypeId":"'+accre.Id+'","address1__c":"Address1","city__c":"Hyderabad","state__c":"LA","Country__c":"USA","zip__c":"123123"}';
            system.debug('prospectData'+prospectData);
            
            
            CreateProspectCmpController.populateparentaccount('Test',prospectData);

            Pricing_Template__c  PT = New Pricing_Template__c(Name='Test Template',Parent_Id__c='22089559');
            Insert PT;
            
            Test.stopTest();
            Account testAcct = new Account(Name = 'My Test Account');
            testAcct.Account_Type__c= 'Prospect';
            insert testAcct;
            // Parent_Id__c is null 
             CreateProspectCmpController.populateparentaccount(PT.Name,prospectData);
             
              testAcct.AOPS_Cust_Id__c=PT.Parent_Id__c;
              Update testAcct;
            // Parent_Id__c not null
             CreateProspectCmpController.populateparentaccount(PT.Name,prospectData);
             // PricingTemplate is null
             CreateProspectCmpController.populateparentaccount(null,prospectData);
             
             
            /*Opportunity opp=new Opportunity();
Opportunity oppt = new Opportunity(Name = 'New mAWS Deal',
AccountID = prospectrec.ID,
StageName = 'Qualify',                           
ownerId=oUser.id,  
RecordTypeId = '012E000000093HNIAY',
Amount = 3000,
CloseDate = System.today(),
Watson_Door_Opener__c=true,
PLOC_Opportunity_Stage__c='Identify Prospect (1.0)',
Product_Subtype__c='Other Equipment',      
Watson_Notes__C='My text'); */
            // String oppRec='{"AccountID":"0011k00000D74m6AAB","StageName":"Qualify","ownerId":"0051k000000eWdk","RecordTypeId":"012E000000093HNIAY","Amount":"3000","CloseDate":"'+system.today()+'","Watson_Door_Opener__c":true,"PLOC_Opportunity_Stage__c":"Identify Prospect (1.0)","Product_Subtype__c":"Other Equipment","Watson_Notes__C":"My text"}';
            String oppRec='';
            Boolean isCreateOppRec=false;
            CreateProspectCmpController.onloadAccPicklistVaues(leads.id);
            CreateProspectCmpController.saveProspect(prospectData, contactData1, parentOrgData,
                                                     newOrFamiliyOrgRecData, decisionMaking, parentOrgSFId
                                                     , leadId,  leadData);
            leadId='';
            decisionMaking='Yes';
            newOrFamiliyOrgRecData='{"Business_Name__c":"Test Org ","SalesDataBatch__c":true}';
            CreateProspectCmpController.saveProspect(prospectData, contactData1, parentOrgData,
                                                     newOrFamiliyOrgRecData, decisionMaking, parentOrgSFId, 
                                                     leadId,  leadData);
                                                     
            
        } 
        
    }
    
    private static testMethod void MyunitTest4() {
        Lead ld=new Lead();
        ld.LastName='Test name';
        ld.FirstName='Test name2';
        ld.Status='Open';
        ld.Company='Test Company';
        ld.city__c='Bangalore';
        ld.state__c='LA';
        ld.zip__c='123123';
        ld.Decision_Maker__c='No';
        insert ld;
        CreateProspectCmpController.getLeadConvert(ld);
    }  
    
}