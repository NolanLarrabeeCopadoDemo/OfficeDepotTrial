global class CCPA_Request_Sync_Batch implements Database.Batchable<Sobject>, Schedulable {
    
    private String query;

    public CCPA_Request_Sync_Batch() {
        query = 'SELECT Id, Request_ID__c, Key_Name__c, Key_Value__c, Key_Value_2__c FROM CCPA_Action_Staging__c';
    }

    global CCPA_Request_Sync_Batch(String query) {
        this.query = query;
    }

    global Database.QueryLocator start(Database.BatchableContext bc) {
        return Database.getQueryLocator(query);
    }

    global void execute(Database.BatchableContext bc, SObject[] scope) {
        Savepoint sp = Database.setSavepoint();
        try {
            List<CCPA_Action_Staging__c> stagedActions = scope;
            syncStagedRecords(stagedActions);
        } catch(Exception e) {
            Database.rollback(sp);
            throw e;
        }
    }

    /**
     * Given the set of staging records, creates CCPA Requests and Actions, and deletes the staging records.
     */
    private void syncStagedRecords(List<CCPA_Action_Staging__c> stagedActions) {
        List<CCPA_Action_Staging__c> stagedActionsWithoutDuplicates = getStagedActionsWithoutDuplicates(stagedActions);

        List<CCPA_Request__c> requests = generateRequests(stagedActionsWithoutDuplicates);
        insert requests;

        List<CCPA_Action__c> actions = generateActions(stagedActionsWithoutDuplicates, requests);
        insert actions;

        delete stagedActions;
    }

    /**
     * Returns a list of staging actions with duplicates removed. Records filtered include duplicates of existing actions,
     * as well as duplicates within the list itself (i.e. more than one of the same record exists in the list)
     */
    private List<CCPA_Action_Staging__c> getStagedActionsWithoutDuplicates(List<CCPA_Action_Staging__c> stagedActions) {
        List<CCPA_Action_Staging__c> filteredStagedActions = getStagedActionsFilteredByExistingActions(stagedActions);
        filteredStagedActions = getStagedActionsWithListDuplicatesFiltered(filteredStagedActions);
        return filteredStagedActions;
    }

    /**
     * Returns a list of staging actions with duplicates of existing actions removed.
     */
    private List<CCPA_Action_Staging__c> getStagedActionsFilteredByExistingActions(List<CCPA_Action_Staging__c> stagedActions) {
        List<String> requestIds = getRequestIdsFromStagedActions(stagedActions);
        List<CCPA_Action__c> existingActions = [SELECT Id, Request_ID__c, Key_Name__c, Key_Value__c, Key_Value_2__c
                                                FROM CCPA_Action__c WHERE Request_ID__c IN: requestIds];
        Set<String> stringifiedExistingActions = getStringifiedActions(existingActions);

        List<CCPA_Action_Staging__c> filteredStagedActions = new List<CCPA_Action_Staging__c>();
        for(CCPA_Action_Staging__c stagedAction : stagedActions) {
            if(stringifiedExistingActions.contains(getStringifiedStagedAction(stagedAction)) == false) {
                filteredStagedActions.add(stagedAction);
            }
        }
        return filteredStagedActions;
    }

    /**
     * Returns a list of the request IDs on the provided staging actions. No de-duplication is done.
     */
    private List<String> getRequestIdsFromStagedActions(List<CCPA_Action_Staging__c> stagedActions) {
        List<String> requestIds = new List<String>();
        for(CCPA_Action_Staging__c stagedAction : stagedActions) {
            requestIds.add(stagedAction.Request_ID__c);
        }
        return requestIds;
    }

    /**
     * Returns the list of actions as Strings. The String representation is made by concatenating fields together.
     */
    private Set<String> getStringifiedActions(List<CCPA_Action__c> actions) {
        Set<String> stringifiedActions = new Set<String>();
        for(CCPA_Action__c action : actions) {
            stringifiedActions.add(getStringifiedAction(action));
        }
        return stringifiedActions;
    }

    /**
     * Returns a list of staging actions with internal duplicates removed.
     */
    private List<CCPA_Action_Staging__c> getStagedActionsWithListDuplicatesFiltered(List<CCPA_Action_Staging__c> stagedActions) {
        Map<String, CCPA_Action_Staging__c> stagingActionsMappedAsStrings = new Map<String, CCPA_Action_Staging__c>();
        for(CCPA_Action_Staging__c stagedAction : stagedActions) {
            String stringifiedStagedAction = getStringifiedStagedAction(stagedAction);
            stagingActionsMappedAsStrings.put(stringifiedStagedAction, stagedAction);
        }
        return stagingActionsMappedAsStrings.values();
    }

    private String getStringifiedAction(CCPA_Action__c action) {
        return action.Request_ID__c + action.Key_Name__c + action.Key_Value__c + action.Key_Value_2__c;
    }

    private String getStringifiedStagedAction(CCPA_Action_Staging__c stagedAction) {
        return stagedAction.Request_ID__c + stagedAction.Key_Name__c + stagedAction.Key_Value__c + stagedAction.Key_Value_2__c;
    }

    /**
     * Returns a list of CCPA requests, using the Request IDs on the provided staging actions.
     */
    private List<CCPA_Request__c> generateRequests(List<CCPA_Action_Staging__c> stagedActions) {
        Set<String> requestIds = new Set<String>();
        for(CCPA_Action_Staging__c stagedAction : stagedActions) {
            requestIds.add(stagedAction.Request_ID__c);
        }

        List<CCPA_Request__c> requests = new List<CCPA_Request__c>();
        for(String requestId : requestIds) {
            CCPA_Request__c request = new CCPA_Request__c(Request_ID__c=requestId);
            requests.add(request);
        }
        return requests;
    }

    /**
     * Returns a list of actions using the provided staging actions. A reference
     * is made on each action to the request with the corresponding Request ID.
     */
    private List<CCPA_Action__c> generateActions(List<CCPA_Action_Staging__c> stagedActions, List<CCPA_Request__c> requests) {
        Map<String, String> requestIdsMappedToSfdcIds = getRequestIdsMappedToSfdcIds(requests);

        List<CCPA_Action__c> actions = new List<CCPA_Action__c>();
        for(CCPA_Action_Staging__c stagedAction : stagedActions) {
            CCPA_Action__c action = new CCPA_Action__c(
                Request_ID__c=stagedAction.Request_ID__c,
                Key_Name__c=stagedAction.Key_Name__c,
                Key_Value__c=stagedAction.Key_Value__c,
                Key_Value_2__c=stagedAction.Key_Value_2__c,
                CCPA_Request__c=requestIdsMappedToSfdcIds.get(stagedAction.Request_ID__c)
            );
            actions.add(action);
        }
        return actions;
    }

    private Map<String, String> getRequestIdsMappedToSfdcIds(List<CCPA_Request__c> requests) {
        Map<String, String> requestIdsMappedToSfdcIds = new Map<String, String>();
        for(CCPA_Request__c request : requests) {
            requestIdsMappedToSfdcIds.put(request.Request_ID__c, request.Id);
        }
        return requestIdsMappedToSfdcIds;
    }

    global void finish(Database.BatchableContext bc) {}

    global void execute(SchedulableContext sc) {
        Database.executeBatch(new CCPA_Request_Sync_Batch(), 2000);
    }
}