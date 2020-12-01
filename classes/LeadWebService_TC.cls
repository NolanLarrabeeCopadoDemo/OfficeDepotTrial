@IsTest
public class LeadWebService_TC {
    static recordtype getProsRTs = [
                SELECT Id
                from recordtype
                where SobjectType = 'Account'
                and developername = 'Prospect_BizBox'
                limit 1
        ];
        static ID prospectBizBox = getProsRTs.id;
        static RecordType getCustRTs = [
                SELECT Id
                from recordtype
                where SobjectType = 'Account'
                and developername = 'Customer_BizBox'
                limit 1
        ];
        static ID customerBizBox = getCustRTs.Id;

    testmethod static void testLeadStaging() {
       //Insert Lead record
        Lead lead_rec = new Lead();
        lead_rec.LastName = 'Test Lead';
        lead_rec.Company = 'Test Company';
        lead_rec.email = 'test@test.com';
        lead_rec.recordTypeId = Schema.SObjectType.Lead.getRecordTypeInfosByName().get('Lead (BizBox)').getRecordTypeId();
        lead_rec.Status = 'Open';
        lead_rec.Products__c = 'Logo_Design';
        insert lead_rec;
        
        //Insert LeadStaging records
        List<LeadStaging__c> leadStagingList = new List<LeadStaging__c>();
        
        LeadStaging__c leadStageRec1 =new LeadStaging__c();
        leadStageRec1.email__c = 'test@test1.com';
        leadStageRec1.Product__c = 'Test Prod';
        
        LeadStaging__c leadStageRec2 =new LeadStaging__c();
        leadStageRec2.email__c = 'test@test.com';
        leadStageRec2.Last_Name__c = 'Test Last';
        leadStageRec2.first_name__c = 'Test First';
        leadStageRec2.company__c = 'Test Company';
        leadStageRec2.address1__c = 'North Military Trail';
        leadStageRec2.address2__c = 'North Military Trail';
        leadStageRec2.city__c = 'Boca Raton';
        leadStageRec2.state__c = 'FL';
        leadStageRec2.zip__c = '33496';
        leadStageRec2.phone__c = '541) 754-3010';
        leadStageRec2.Product__c = 'Test Prod';
            
        leadStagingList.add(leadStageRec1);
        leadStagingList.add(leadStageRec2);
        Test.startTest();
        insert leadStagingList;
        Test.stopTest(); 
    }
    
    @isTest static void testCreateLead() {
        // Call the method to test
        String myFirstName = 'TestFirst';
        ID thisLeadStagingId = LeadWebService.createLead(myFirstName, 'TestLast', 'TestBizName',
                'test@test.com', 'BizBox Web', '123 Main Street', '', 'Testland Park', 'FL', '12345','' ,'','','','','');
        
        LeadStaging__c leadStageRec =new LeadStaging__c();
        leadStageRec.email__c = 'test@test.com';
        insert leadStageRec;
        //Insert Lead record
        Lead lead_rec = new Lead();
        lead_rec.LastName = 'Test Lead';
        lead_rec.Company = 'Test Company';
        lead_rec.email = 'test@test.com';
        lead_rec.recordTypeId = Schema.SObjectType.Lead.getRecordTypeInfosByName().get('Lead (BizBox)').getRecordTypeId();
        lead_rec.Status = 'Open';
        insert lead_rec;
        // Verify results
        System.assert(thisLeadStagingId != null);
        LeadStaging__c thisLead = [SELECT Id,First_Name__c FROM LeadStaging__c WHERE Id = :thisLeadStagingId];

        System.assert(thisLead != null);
        System.assertEquals(thisLead.First_Name__c, myFirstName);
    }

    @isTest static void testCreateLead_InvalidEmail() {
        // Call the method to test
        String myFirstName = 'TestFirst';
        ID thisLeadStagingId = LeadWebService.createLead(myFirstName, 'TestLast', 'TestBizName',
                'testtest.com', 'BizBox Web', '123 Main Street', '', 'Testland Park', 'FL', '12345','','','','','','');
        // Verify results
        System.assert(thisLeadStagingId != null);
        LeadStaging__c thisLead = [SELECT Id,First_Name__c FROM LeadStaging__c WHERE Id = :thisLeadStagingId];

        System.assert(thisLead != null);
        System.assertEquals(thisLead.First_Name__c, myFirstName);
    }
    
    @isTest static void testCreateLead_NullSource() {
        // Call the method to test
        String myFirstName = 'TestFirst';
        ID thisLeadStagingId = LeadWebService.createLead(myFirstName, 'TestLast', 'TestBizName',
                'testtest.com', null, '123 Main Street', '', 'Testland Park', 'FL', '12345','','','','','','');
        // Verify results
        System.assert(thisLeadStagingId != null);
        LeadStaging__c thisLead = [SELECT Id,First_Name__c FROM LeadStaging__c WHERE Id = :thisLeadStagingId];

        System.assert(thisLead != null);
        System.assertEquals(thisLead.First_Name__c, myFirstName);
    }
    @isTest static void testCreateTask() {
        Task newTask = new Task();
        Lead lead_rec = new Lead();
        lead_rec.LastName = 'Test Lead';
        lead_rec.Company = 'Test Company';
        lead_rec.email = 'test@test.com';
        lead_rec.recordTypeId = Schema.SObjectType.Lead.getRecordTypeInfosByName().get('Lead (BizBox)').getRecordTypeId();
        lead_rec.Status = 'Open';
        lead_rec.Products__c = 'Logo_Design';
        insert lead_rec;
        newTask.WhoID = lead_rec.Id;
        newTask.Subject = 'TestSub';
        newTask.Description = 'Duplicate Lead received based on email, provided information :';
        insert newTask;
        newTask.Subject = 'Update';
        update newTask;
    }
    @isTest static void testCreateLead_ExistingAccount() {
        // Call the method to test
        Account iBBProspect = new Account(
            RecordTypeID = prospectBizBox,
            BizBox_Email__c = 'iamanemail@email.com',
            Name = 'My Test Account'
        );
        LeadStaging__c myLS = new LeadStaging__c(
            Last_Name__c = 'LastName',
            Email__c = 'iamanemail@email.com'
        );
        test.startTest();
        insert iBBProspect;
        insert myLS;
        test.stopTest();
    }

}