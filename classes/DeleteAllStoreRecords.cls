global class DeleteAllStoreRecords implements Database.Batchable<SObject> {

  global Database.QueryLocator start(Database.BatchableContext c) {
    return Database.getQueryLocator('SELECT id FROM store__c');
  }
  
  global void execute(Database.BatchableContext c, List<Sobject> objects) {
    List<store__c> listToDelete = new List<store__c>();
    for (SObject s : objects) {
      listToDelete.add((store__c)s);
    }
    delete listToDelete;
  }
  
  global void finish(Database.BatchableContext c) {
  }
  
  
  
  @isTest
  // To test Store__c deletion
  private static void DeleteAllStroes() {
  	Test.startTest();
  	
  	List<Store__c> storeList = new List<Store__c> ();
  	// Insert 5 Stores 
  	for (Integer i = 0; i<5; i++){
		Store__c store = new Store__c();
		storeList.add(store);
	}
	insert storeList;
	
	// Verify that 5 stores inserted
	List<Store__c> storeListBeforeDelete = [SELECT id FROM Store__c];
	System.assertEquals(storeListBeforeDelete.size(), 5);
	
  	DeleteAllStoreRecords deleteAllStores = new DeleteAllStoreRecords(); 
  	ID batchprocessid = Database.executeBatch(deleteAllStores);
  	Test.stopTest();
  	
  	// Verify that after deletion all 5 stores are deleted
  	List<Store__c> storeListAfterDelete = [SELECT id FROM Store__c];
  	System.assertEquals(storeListAfterDelete.size(), 0);	
  }

}