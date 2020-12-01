global class Mod5ProspectMessageCorrection implements Database.Batchable<sObject>, Schedulable, Database.Stateful {

    private final String DEFAULT_QUERY = 'SELECT Id, OMX_Primary_Key__c, Account__c, Ready_For_Mod_5__c ' +
                                         'FROM Customer_Transition__c ' +
                                         'WHERE Ready_For_Mod_5__c = TRUE ' +
                                         'AND Mod5_Ready_To_Launch__c = FALSE ' +
                                         'AND Status__c = \'On Deck\' ' +
                                         'AND Split_Launching_Status__c = NULL ';
    private String passedQuery;
    
    // Default constructor
    public Mod5ProspectMessageCorrection() {
    }
    
    // Overloaded constructor to run a specific query
    public Mod5ProspectMessageCorrection(String passedQuery) {
        this.passedQuery = passedQuery;
    }
    
    global Database.QueryLocator start(Database.BatchableContext bc) {
        if (passedQuery != null) {
            return Database.getQueryLocator(passedQuery);
        }
        else {
		    return Database.getQueryLocator(DEFAULT_QUERY);
        }
    }
    
    global void execute(Database.BatchableContext bc, List<Customer_Transition__c> scope) {
        // Get OMX Primary Key for original account
        System.debug('Mod5ProspectMessageCorrection > execute() > scope = ' + scope);
        String omxPrimaryKey = scope[0].OMX_Primary_Key__c + '%';
        
        // Get accounts where Oracle Party IDs are not populated
        List<Account> nullPartyIds = [SELECT Id, OMX_Primary_Key__c
                                      FROM Account
                                      WHERE OMX_Primary_Key__c LIKE :omxPrimaryKey
                                      AND Oracle_Party_ID__c = null
                                      AND Oracle_Party_Site_ID__c = null];
        // If account doesn't have all Oracle IDs populated                              
        if (nullPartyIds.size() > 0) {
            // Resubmit prospect message
            Id accountId = scope[0].Account__c;
            
            List<Prospect_Message__c> pms = [SELECT Message_Complete__c 
                                             FROM Prospect_Message__c 
                                             WHERE Account__c = :accountId];
            if (pms.size() > 0) {
                Prospect_Message__c first = pms[0];
                first.Message_Complete__c = 'NP';
                update first;
            }
        }
        // If account has all Oracle IDs but still doesn't split and launch
        else {
           // Retrigger Mod 5 - will only work with Salesforce user
           scope[0].Ready_For_Mod_5__c = false;
           
           if (!Test.isRunningTest()) {
               update scope;
           }
               
           scope[0].Ready_For_Mod_5__c = true;
           update scope;
        }
    }
    
    global void finish(Database.BatchableContext bc) {
    }

	global void execute(SchedulableContext sc) {
	    // Always run with batch size 1
		Mod5ProspectMessageCorrection batch = new Mod5ProspectMessageCorrection(); 
		Database.executebatch(batch, 1);
    }
}