// Mass create new communities from the GPO_Category__c staging object
global class CommunitiesBulkUpload implements Database.Batchable<sObject>,Schedulable {
    private string DEFAULT_QUERY = 'SELECT id,AOPS_Number__c,Company_Name__c,Private__c FROM GPO_Category__c';

    global Database.QueryLocator start(Database.BatchableContext bc) {
        return Database.getQueryLocator(DEFAULT_QUERY);
    }
    
    global void execute(Database.BatchableContext bc, sObject[] scope) {
        List<GPO_Category__c> stagingTable = scope;
        List<GPO_Group__c> groupUpload = new List<GPO_Group__c>();
        List<Account> groupAccounts = new List<Account>();
        List<String> accountAopsIds = new List<String>();
        Map<String, Id> accountMap = new Map<String, Id>();
        GPO_Template__c template = new GPO_Template__c();
        template = [SELECT id,Name FROM GPO_Template__c WHERE Name = 'Communities v2'];
        GPO_Group_Detail__c selectedMessage = new GPO_Group_Detail__c();
        selectedMessage = [SELECT id FROM GPO_Group_Detail__c WHERE Name = 'Standard Message 3'];
        List<GPO_Link__c> linkUpload = new List<GPO_Link__c>();
        
        for(GPO_Category__c c : stagingTable) {
            accountAopsIds.add(c.AOPS_Number__c); 
        }

        groupAccounts = [SELECT id,AOPS_Cust_Id__c FROM Account WHERE AOPS_Cust_Id__c IN :accountAopsIds];
        for (Account acct : groupAccounts) {
            accountMap.put(acct.AOPS_Cust_Id__c, acct.id);
        }
     
        for(GPO_Category__c c : stagingTable) {
            GPO_Group__c newGroup = new GPO_Group__c();
            newGroup.Community_Name__c = c.Company_Name__c;
            newGroup.GPO_Template__c = template.id;
            newGroup.Welcome_Title__c = c.Company_Name__c;
            newGroup.Selected_Message__c = selectedMessage.id;
            newGroup.Activated__c = true;
            newGroup.Private__c = false;
            newGroup.Account__c = accountMap.get(c.AOPS_Number__c);
            newGroup.hideSections__c = 'Request an Account';
            groupUpload.add(newGroup);
        }
        insert groupUpload;
        
        for(GPO_Group__c g : groupUpload) {
            GPO_Link__c newLink = new GPO_Link__c(Type__c = 'Link', Label__c = 'Find a Store', Active__c = true, URL_Address__c = 'https://www.officedepot.com/storelocator/findStore.do');
            newLink.GPO_Group__c = g.id;
            linkUpload.add(newLink);
        }
        insert linkUpload;
        
        
        /*
        List<GPO_Group__c> updateGroups = new List<GPO_Group__c>();
        updateGroups = [select id, hideSections__c FROM GPO_Group__c WHERE AOPS_Cust_ID__c IN :accountAopsIds];
        for(GPO_Group__c c : updateGroups) {
                c.hideSections__c = 'Request an Account; Important Downloads';
        }
        update updateGroups;
        */
        
        
        
        delete stagingTable;
    }
    
    global void execute(SchedulableContext sc) {
     //Batch size set for each iteration
     integer batch_size = 200;
     CommunitiesBulkUpload newBatch = new CommunitiesBulkUpload();     
     database.executebatch(newBatch,batch_size); 
     
    }
    
    global void finish(Database.BatchableContext bc)
    {
        // not required
    }
}