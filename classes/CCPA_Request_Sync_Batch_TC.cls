@IsTest
private class CCPA_Request_Sync_Batch_TC {

    @TestSetup
    static void makeData() {
        CCPA_Action_Staging__c stagedAction1 = new CCPA_Action_Staging__c(Request_ID__c='111', Key_Name__c='112', Key_Value__c='113', Key_Value_2__c='114');
        CCPA_Action_Staging__c stagedAction2 = new CCPA_Action_Staging__c(Request_ID__c='211', Key_Name__c='212', Key_Value__c='213', Key_Value_2__c='214');
        CCPA_Action_Staging__c stagedAction3 = new CCPA_Action_Staging__c(Request_ID__c='211', Key_Name__c='222', Key_Value__c='223', Key_Value_2__c='224');
        CCPA_Action_Staging__c stagedAction4 = new CCPA_Action_Staging__c(Request_ID__c='311', Key_Name__c='312', Key_Value__c='313', Key_Value_2__c='314');
        insert new List<CCPA_Action_Staging__c> { stagedAction1, stagedAction2, stagedAction3, stagedAction4 };
    }
    
    @IsTest
    static void testCreatesActions() {
        Test.startTest();
        CCPA_Request_Sync_Batch crsb = new CCPA_Request_Sync_Batch();
        Database.executeBatch(crsb, 2000);
        Test.stopTest();

        List<CCPA_Action__c> actions = [SELECT Id, Request_ID__c, Key_Name__c, Key_Value__c, Key_Value_2__c FROM CCPA_Action__c];
        System.assertEquals(4, actions.size());
        System.assertEquals(true, containsAction(actions, '111', '112', '113', '114'));
        System.assertEquals(true, containsAction(actions, '211', '212', '213', '214'));
        System.assertEquals(true, containsAction(actions, '211', '222', '223', '224'));
        System.assertEquals(true, containsAction(actions, '311', '312', '313', '314'));
    }

    @IsTest
    static void testDuplicateActions() {
        CCPA_Action__c duplicate1 = new CCPA_Action__c(Request_ID__c='111', Key_Name__c='112', Key_Value__c='113', Key_Value_2__c='114');
        CCPA_Action__c duplicate2 = new CCPA_Action__c(Request_ID__c='311', Key_Name__c='312', Key_Value__c='313', Key_Value_2__c='314');
        insert new List<CCPA_Action__c> { duplicate1, duplicate2 };

        Test.startTest();
        CCPA_Request_Sync_Batch crsb = new CCPA_Request_Sync_Batch();
        Database.executeBatch(crsb, 2000);
        Test.stopTest();

        List<CCPA_Action__c> actions = [SELECT Id, Request_ID__c, Key_Name__c, Key_Value__c, Key_Value_2__c FROM CCPA_Action__c];
        System.assertEquals(4, actions.size());
        System.assertEquals(true, containsAction(actions, '111', '112', '113', '114'));
        System.assertEquals(true, containsAction(actions, '211', '212', '213', '214'));
        System.assertEquals(true, containsAction(actions, '211', '222', '223', '224'));
        System.assertEquals(true, containsAction(actions, '311', '312', '313', '314'));
    }

    @IsTest
    static void testDuplicateStagedActions() {
        CCPA_Action_Staging__c duplicate1 = new CCPA_Action_Staging__c(Request_ID__c='111', Key_Name__c='112', Key_Value__c='113', Key_Value_2__c='114');
        CCPA_Action_Staging__c duplicate2 = new CCPA_Action_Staging__c(Request_ID__c='311', Key_Name__c='312', Key_Value__c='313', Key_Value_2__c='314');
        insert new List<CCPA_Action_Staging__c> { duplicate1, duplicate2 };

        Test.startTest();
        CCPA_Request_Sync_Batch crsb = new CCPA_Request_Sync_Batch();
        Database.executeBatch(crsb, 2000);
        Test.stopTest();

        List<CCPA_Action__c> actions = [SELECT Id, Request_ID__c, Key_Name__c, Key_Value__c, Key_Value_2__c FROM CCPA_Action__c];
        System.assertEquals(4, actions.size());
        System.assertEquals(true, containsAction(actions, '111', '112', '113', '114'));
        System.assertEquals(true, containsAction(actions, '211', '212', '213', '214'));
        System.assertEquals(true, containsAction(actions, '211', '222', '223', '224'));
        System.assertEquals(true, containsAction(actions, '311', '312', '313', '314'));
    }

    @IsTest
    static void testDeleteStagingRecords() {
        CCPA_Action_Staging__c duplicate1 = new CCPA_Action_Staging__c(Request_ID__c='111', Key_Name__c='112', Key_Value__c='113', Key_Value_2__c='114');
        CCPA_Action_Staging__c duplicate2 = new CCPA_Action_Staging__c(Request_ID__c='311', Key_Name__c='312', Key_Value__c='313', Key_Value_2__c='314');
        insert new List<CCPA_Action_Staging__c> { duplicate1, duplicate2 };

        Test.startTest();
        CCPA_Request_Sync_Batch crsb = new CCPA_Request_Sync_Batch();
        Database.executeBatch(crsb, 2000);
        Test.stopTest();

        List<CCPA_Action_Staging__c> stagedActions = [SELECT Id, Request_ID__c, Key_Name__c, Key_Value__c, Key_Value_2__c FROM CCPA_Action_Staging__c];
        System.assertEquals(0, stagedActions.size());
    }

    @IsTest
    static void testCreateRequests() {
        Test.startTest();
        CCPA_Request_Sync_Batch crsb = new CCPA_Request_Sync_Batch();
        Database.executeBatch(crsb, 2000);
        Test.stopTest();

        List<CCPA_Request__c> requests = [SELECT Id, Request_ID__c FROM CCPA_Request__c];
        System.assertEquals(3, requests.size());
        System.assertEquals(true, containsRequest(requests, '111'));
        System.assertEquals(true, containsRequest(requests, '211'));
        System.assertEquals(true, containsRequest(requests, '311'));
    }

    @IsTest
    static void testRequestsAddedToActions() {
        Test.startTest();
        CCPA_Request_Sync_Batch crsb = new CCPA_Request_Sync_Batch();
        Database.executeBatch(crsb, 2000);
        Test.stopTest();

        List<CCPA_Action__c> actions = [SELECT Id, Request_ID__c, CCPA_Request__r.Request_ID__c FROM CCPA_Action__c];
        for(CCPA_Action__c action : actions) {
            System.assertEquals(action.Request_ID__c, action.CCPA_Request__r.Request_ID__c);
        }
    }

    private static Boolean containsAction(List<CCPA_Action__c> actions, String requestId, String keyName, String keyValue, String keyValue2) {
        for(CCPA_Action__c action : actions) {
            if(action.Request_ID__c == requestId && action.Key_Name__c == keyName && action.Key_Value__c == keyValue && action.Key_Value_2__c == keyValue2) {
                return true;
            }
        }
        return false;
    }

    private static Boolean containsRequest(List<CCPA_Request__c> requests, String requestId) {
        for(CCPA_Request__c request : requests) {
            if(request.Request_ID__c == requestId) {
                return true;
            }
        }
        return false;
    }
}