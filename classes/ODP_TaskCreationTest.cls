@isTest
 public class ODP_TaskCreationTest {

    
    
    private static testmethod void testTaskCreation(){
        LBI__LatticeApplicationRegion__c defaultRegion = (LBI__LatticeApplicationRegion__c) Schema.getGlobalDescribe().get('LBI__LatticeApplicationRegion__c').newSObject(null, true) ;
        defaultRegion.LBI__IsDefault__c = true;
        defaultRegion.LBI__Locale__c = 'en_US';
        defaultRegion.LBI__ApplicationOrRegionName__c = 'Customer Growth';
        defaultRegion.LBI__Type__c = 'Customer Growth';
        insert defaultRegion;

        List<Account> accounts = new List<Account>();
        accounts.add(new Account(Name = 'Test Account 1', AccountNumber = '1'));
        accounts.add(new Account(Name = 'Test Account 2', AccountNumber = '2'));
        insert accounts;
    
        LBI__LatticeWorkflowSetting__c workflow = new LBI__LatticeWorkflowSetting__c(LBI__LatticeApplicationRegion__c = defaultRegion.Id, LBI__Type__c = BISCONSTANTS.WORKFLOWTYPE_RECOMMENDATION);
        insert workflow;
    
        LBI__PlayType__c playtype = new LBI__PlayType__c(LBI__Workflow__c = 'Recommendation', LBI__ExternalId__c = '0', LBI__LatticeWorkflowSetting__c = workflow.id);
        insert playtype;
    
        List<LBI__Play__c> plays = new List<LBI__Play__c>();
        plays.add(new LBI__Play__c(LBI__PlayType__c = playtype.id, LBI__PlayID__c = '1', LBI__DisplayName__c = 'Play 1'));
        plays.add(new LBI__Play__c(LBI__PlayType__c = playtype.id, LBI__PlayID__c = '2', LBI__DisplayName__c = 'Play 2'));
        insert plays;
    
        List<LBI__PlayRun__c> playRuns = new List<LBI__PlayRun__c>();
        playRuns.add(new LBI__PlayRun__c(LBI__Play__c = plays[0].id, LBI__LatticeWorkflowSetting__c = workflow.id, LBI__ExternalId__c = '1', LBI__StatsComplete__c = false));
        playRuns.add(new LBI__PlayRun__c(LBI__Play__c = plays[0].id, LBI__LatticeWorkflowSetting__c = workflow.id, LBI__ExternalId__c = '2', LBI__StatsComplete__c = false));
        playRuns.add(new LBI__PlayRun__c(LBI__Play__c = plays[1].id, LBI__LatticeWorkflowSetting__c = workflow.id, LBI__ExternalId__c = '3', LBI__StatsComplete__c = false));
        insert playRuns;
    
        List<LBI__Recommendation__c> recommendations = new List<LBI__Recommendation__c>();
        recommendations.add(new LBI__Recommendation__c(LBI__Account__c = accounts[0].Id, LBI__PreLeadId__c = '01', LBI__PlayRun__c = playRuns[0].id, LBI__Play__c = plays[0].id, LBI__Rank__c = 'A', LBI__Status__c = BISCONSTANTS.RECOMMENDATIONSTATUS_OPEN));
        recommendations.add(new LBI__Recommendation__c(LBI__Account__c = accounts[1].Id, LBI__PreLeadId__c = '02', LBI__PlayRun__c = playRuns[1].id, LBI__Play__c = plays[0].id, LBI__Rank__c = 'A', LBI__Status__c = BISCONSTANTS.RECOMMENDATIONSTATUS_OPEN));
        recommendations.add(new LBI__Recommendation__c(LBI__Account__c = accounts[1].Id, LBI__PreLeadId__c = '03', LBI__PlayRun__c = playRuns[2].id, LBI__Play__c = plays[1].id, LBI__Rank__c = 'A', LBI__Status__c = BISCONSTANTS.RECOMMENDATIONSTATUS_EXPIRED));
        insert recommendations;
        
        test.StartTest();
        
            // Create Activity Record
            LBI__Activity__c activity = new LBI__Activity__c();
            activity.lbi__action__c = 'Status Change';
            activity.LBI__ActivityType__c = 'Disqualify';
            activity.LBI__Status__c = 'Disqualified';
            insert activity;
        
            LBI__ActivityRecommendation__c activityRec = new LBI__ActivityRecommendation__c();
            activityRec.LBI__Account__c = recommendations[0].LBI__Account__c;
            activityRec.LBI__DisqualificationReason__c = 'Interested - Previous Opp';
            activityRec.LBI__DisqualificationReasonDetails__c = 'More info';
            activityRec.LBI__OldStatus__c = 'Open';
            activityRec.LBI__Recommendation__c = recommendations[0].id;
            activityRec.LBI__StatusChange__c = true;
            activityRec.LBI__WorkflowType__c = 'Recommendation';
            activityRec.LBI__Activity__c = activity.id;
            insert activityRec;
        
        Test.stopTest();
        
    }
    
    private static testmethod void testQualifiedRec(){
        LBI__LatticeApplicationRegion__c defaultRegion = (LBI__LatticeApplicationRegion__c) Schema.getGlobalDescribe().get('LBI__LatticeApplicationRegion__c').newSObject(null, true) ;
        defaultRegion.LBI__IsDefault__c = true;
        defaultRegion.LBI__Locale__c = 'en_US';
        defaultRegion.LBI__ApplicationOrRegionName__c = 'Customer Growth';
        defaultRegion.LBI__Type__c = 'Customer Growth';
        insert defaultRegion;

        List<Account> accounts = new List<Account>();
        accounts.add(new Account(Name = 'Test Account 1', AccountNumber = '1'));
        accounts.add(new Account(Name = 'Test Account 2', AccountNumber = '2'));
        insert accounts;
    
        LBI__LatticeWorkflowSetting__c workflow = new LBI__LatticeWorkflowSetting__c(LBI__LatticeApplicationRegion__c = defaultRegion.Id, LBI__Type__c = BISCONSTANTS.WORKFLOWTYPE_RECOMMENDATION);
        insert workflow;
    
        LBI__PlayType__c playtype = new LBI__PlayType__c(LBI__Workflow__c = 'Recommendation', LBI__ExternalId__c = '0', LBI__LatticeWorkflowSetting__c = workflow.id);
        insert playtype;
    
        List<LBI__Play__c> plays = new List<LBI__Play__c>();
        plays.add(new LBI__Play__c(LBI__PlayType__c = playtype.id, LBI__PlayID__c = '1', LBI__DisplayName__c = 'Play 1'));
        plays.add(new LBI__Play__c(LBI__PlayType__c = playtype.id, LBI__PlayID__c = '2', LBI__DisplayName__c = 'Play 2'));
        insert plays;
    
        List<LBI__PlayRun__c> playRuns = new List<LBI__PlayRun__c>();
        playRuns.add(new LBI__PlayRun__c(LBI__Play__c = plays[0].id, LBI__LatticeWorkflowSetting__c = workflow.id, LBI__ExternalId__c = '1', LBI__StatsComplete__c = false));
        playRuns.add(new LBI__PlayRun__c(LBI__Play__c = plays[0].id, LBI__LatticeWorkflowSetting__c = workflow.id, LBI__ExternalId__c = '2', LBI__StatsComplete__c = false));
        playRuns.add(new LBI__PlayRun__c(LBI__Play__c = plays[1].id, LBI__LatticeWorkflowSetting__c = workflow.id, LBI__ExternalId__c = '3', LBI__StatsComplete__c = false));
        insert playRuns;
    
        List<LBI__Recommendation__c> recommendations = new List<LBI__Recommendation__c>();
        recommendations.add(new LBI__Recommendation__c(LBI__Account__c = accounts[0].Id, LBI__PreLeadId__c = '01', LBI__PlayRun__c = playRuns[0].id, LBI__Play__c = plays[0].id, LBI__Rank__c = 'A', LBI__Status__c = BISCONSTANTS.RECOMMENDATIONSTATUS_OPEN));
        recommendations.add(new LBI__Recommendation__c(LBI__Account__c = accounts[1].Id, LBI__PreLeadId__c = '02', LBI__PlayRun__c = playRuns[1].id, LBI__Play__c = plays[0].id, LBI__Rank__c = 'A', LBI__Status__c = BISCONSTANTS.RECOMMENDATIONSTATUS_OPEN));
        recommendations.add(new LBI__Recommendation__c(LBI__Account__c = accounts[1].Id, LBI__PreLeadId__c = '03', LBI__PlayRun__c = playRuns[2].id, LBI__Play__c = plays[1].id, LBI__Rank__c = 'A', LBI__Status__c = BISCONSTANTS.RECOMMENDATIONSTATUS_EXPIRED));
        insert recommendations;
        
        test.StartTest();
        
            // Create Activity Record
            LBI__Activity__c activity = new LBI__Activity__c();
            activity.lbi__action__c = 'Status Change';
            activity.LBI__ActivityType__c = 'Qualified';
            activity.LBI__Status__c = 'Qualified';
            insert activity;
        
            LBI__ActivityRecommendation__c activityRec = new LBI__ActivityRecommendation__c();
            activityRec.LBI__Account__c = recommendations[0].LBI__Account__c;
            activityRec.LBI__OldStatus__c = 'Open';
            activityRec.LBI__Recommendation__c = recommendations[0].id;
            activityRec.LBI__StatusChange__c = true;
            activityRec.LBI__WorkflowType__c = 'Recommendation';
            activityRec.LBI__Activity__c = activity.id;
            insert activityRec;
        
        Test.stopTest();
        
            LBI__Recommendation__c rec = [select id, LBI__DisqualificationReason__c from LBI__Recommendation__c where id=:recommendations[0].id];
            system.assertEquals('New Opportunity' ,rec.LBI__DisqualificationReason__c);
    }
     
     
    private static testmethod void testAccountTrigger(){
        Map<String, Schema.RecordTypeInfo> recordTypes = Schema.SObjectType.Account.getRecordTypeInfosByName();
        id custRT = recordTypes.get('Customer').getRecordTypeId();
        id siteRT = recordTypes.get('Site').getRecordTypeId();

        Account parent = new Account(Name = 'Test Account 2', AccountNumber = '2', Type='Customer', Rolling_12_Month_Sales__c = 12345.23, Status__c = 'Active', recordTypeID = custRT);
        insert parent;
        
        Account site = new Account(Name = 'Test Account 1', AccountNumber = '1', Type='Site', Related_Account__c = parent.id, RecordTypeID = siteRT);
        insert site;
        
        
        test.StartTest();
        
        	Opportunity o = new Opportunity();
        	o.AccountID = site.id;
        	o.name='Test 1235';
        	o.CloseDate = system.today() + 10;
        	o.StageName = 'New';
        	insert o;
        
        Test.stopTest();
        
        	o = [select id, AccountID from Opportunity where id =: o.id];
        	system.assertEquals(parent.id, o.AccountID);
    }

}