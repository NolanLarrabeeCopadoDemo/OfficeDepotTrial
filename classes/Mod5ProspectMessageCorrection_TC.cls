@isTest
private class Mod5ProspectMessageCorrection_TC {
    
    private static void prepareData() {
        // Account 1
        Account acct = new Account(Name = 'Frank Test Account',
                                   OMX_Primary_Key__c = '0123456');
        insert acct;
        
        // Insert related Customer Transition
        Customer_Transition__c ct = new Customer_Transition__c(Ready_For_Mod_5__c = TRUE,
                                                               Mod5_Ready_To_Launch__c = FALSE,
                                                               Status__c = 'On Deck',
                                                               Account__c = acct.Id,
                                                               OMX_Primary_Key__c = '0123456');
        insert ct;
        
        // Retrieve inserted CT and update values
        ct = [SELECT Ready_For_Mod_5__c, Mod5_Ready_To_Launch__c, Status__c
              FROM Customer_Transition__c
              WHERE Account__c = :acct.Id];
        ct.Status__c = 'On Deck';
        update ct;
        
        System.debug('Mod5ProspectMessageCorrection_TC > prepareData() > ct = ' + ct);
    }
    
    private static void prepareData2() {
        // Account 2
        Account acct2 = new Account(Name = 'Frank Test Account 2',
                                   OMX_Primary_Key__c = '0654321',
                                   Oracle_Party_ID__c = '0654321');
        insert acct2;
        
        // Insert related Customer Transition
        Customer_Transition__c ct2 = new Customer_Transition__c(Ready_For_Mod_5__c = TRUE,
                                                               Mod5_Ready_To_Launch__c = FALSE,
                                                               Status__c = 'On Deck',
                                                               Account__c = acct2.Id,
                                                               OMX_Primary_Key__c = '0654321');
        insert ct2;
        
        // Retrieve inserted CT and update values
        ct2 = [SELECT Ready_For_Mod_5__c, Mod5_Ready_To_Launch__c, Status__c
              FROM Customer_Transition__c
              WHERE Account__c = :acct2.Id];
        ct2.Status__c = 'On Deck';
        update ct2;
        
        System.debug('Mod5ProspectMessageCorrection_TC > prepareData() > ct2 = ' + ct2);
    }

	private static testMethod void testDefaultQuery() {
	    prepareData();

        Mod5ProspectMessageCorrection batch = new Mod5ProspectMessageCorrection(); 
		Database.executebatch(batch, 1);
	}
	
	private static testMethod void testPassQuery() {
	    prepareData();
	    
	    String query = 'SELECT Id, OMX_Primary_Key__c, Account__c ' +
                       'FROM Customer_Transition__c ' +
                       'WHERE OMX_Primary_Key__c = \'0123456\' ';
	    
        Mod5ProspectMessageCorrection batch = new Mod5ProspectMessageCorrection(query); 
		Database.executebatch(batch, 1);
	}
	
	private static testMethod void testElseCase() {
	    prepareData2();
	    
        Mod5ProspectMessageCorrection batch = new Mod5ProspectMessageCorrection(); 
		Database.executebatch(batch, 1);
	}
}