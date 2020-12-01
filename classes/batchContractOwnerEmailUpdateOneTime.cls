global class batchContractOwnerEmailUpdateOneTime implements Database.Batchable<sObject> {

// Start Method

    global Database.QueryLocator start(Database.BatchableContext BC) {

        String query = 'SELECT Id,Contract_Owner__c,Contract_Owner_Email__c FROM Contract where contract_owner_email__c = NULL';

        return Database.getQueryLocator(query);

    }

   // Execute method

    global void execute(Database.BatchableContext BC, List<Contract> scope) {

         for(Contract con : scope)

         {
		 
		 if( con.Contract_Owner__c =='Anthony Falbo'){
		 con.Contract_Owner_Email__c = 'anthony.falbo@officedepot.com';
		 
		 }else if( con.Contract_Owner__c =='Jean Davis'){
		 con.Contract_Owner_Email__c = 'jean.davis@officedepot.com';
		 
		 }else if( con.Contract_Owner__c =='Denise DeFerrari'){
		 con.Contract_Owner_Email__c = 'denise.deferrari@officedepot.com';
		 
		 }else if( con.Contract_Owner__c =='Pricing Compliance Queue'){
		 con.Contract_Owner_Email__c = 'contract.lifecycle@officedepot.com';
		 
		 }
		       

         }

         update scope;

    }   

    // Finish Method

    global void finish(Database.BatchableContext BC) {

    }

}