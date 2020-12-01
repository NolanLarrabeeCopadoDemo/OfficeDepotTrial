/***
desc Sales_Person__c
SELECT Ownerid, Name FROM Sales_Person__c WHERE IsActive__c=true AND Primary__c=true AND ownerid!='005E0000000R7xzIAC'
SELECT id, name, ownerid FROM Account WHERE recordtype.name='GrandParent' LIMIT 10


Description:    This Is a batch Apex program for verifying and correcting the Sales Person Associated Object with the grandparent accounts.

                Each Sales Person Object and Account has an owner associated with it. The Sales Person Object will have
                a sub-Salesperson (SPid__c) associated with is that is flagged as active and primary. Unfortunately, when a sub-salesperson goes inactive or non-primary,
                it does not get reflected in the grandparent account object.

                Write a batch process to update the sub-salesperson associated with the Grandparent Account Object to the sub-salesperson that
                is flagged as both active and primary.

                Map the ownerIds of both the queries.

Created By: Adam Albright
Created Date: 12-Jan-2018

**/
global class Acc_Grandparent_Owner_Update_Batch implements Database.Batchable<sObject>,Schedulable{

    global String dataLoader_Id;
    global String my_query;
    global String my_query_2;
    // Build our query and Get the records.
  global Database.QueryLocator start(Database.BatchableContext bc) {
        // Get the Data loader ID.
      System.debug(System.LoggingLevel.INFO, 'Starting Batch.');
        User dataloader_user = Database.query('SELECT id, name FROM user where name=\'dataloader\' LIMIT 1');
        dataLoader_Id = dataloader_user.id;

        my_query = 'SELECT id, Sales_PersonID__c, ownerid FROM account WHERE Sales_PersonID__c!=\'\' AND recordtype.name=\'GrandParent\' AND ownerid!=\''
                + dataLoader_Id + '\' AND Sales_PersonID__r.user__C!=\''
                + dataLoader_Id + '\' AND  ( (Sales_PersonID__r.isactive__c=false OR Sales_PersonID__r.Primary__c=false)  or   (  Is_Sales_Rep_Owner__C=false  ) ) LIMIT 5000';
      return Database.getQueryLocator(my_query);
    }

    global void execute(Database.BatchableContext bc, List<Account> records){

        List<String> Users_With_Incorrect_Sales_People = new List<String>();

        // Make a list of the Owner IDs.
        for (Account acc: records){
            Users_With_Incorrect_Sales_People.add(acc.OwnerId);
        }
        System.debug(LoggingLevel.Error, 'Incorrect IDs found: ' + Users_With_Incorrect_Sales_People.size());
        /*
            This query gets Sales people that 
            
            SOQL with variables:
            https://developer.salesforce.com/docs/atlas.en-us.apexcode.meta/apexcode/langCon_apex_SOQL_variables.htm
        */
        List<Sales_Person__c> SalesPeople = [SELECT id, name, User__c
                                            FROM Sales_Person__c
                                            WHERE User__c IN :Users_With_Incorrect_Sales_People
                                            AND IsActive__c=true AND Primary__c=true];

        // Updated_Grandparent_Accounts holds the accounts that need to be updated.
        List<Account> updated_Grandparent_Accounts = new List<Account>();

        // Here we are mapping salesperson to their associated Owner ID. This list will include only active and primary salespersons.
        Map<String, Sales_Person__c> OwnersToSalesPersons = new Map<String, Sales_Person__c>();
        for(Sales_Person__c sp: SalesPeople) {
            System.debug(LoggingLevel.INFO, sp.User__c + ' mapped to ' + sp.Id +'\t' +sp.Name);
            OwnersToSalesPersons.put(sp.User__c, sp);
        }
        
        
        // Change to pick latest sales Rep if primary not found
        
                List<Sales_Person__c> SalesPeopleExt = [SELECT id, name, User__c
                                            FROM Sales_Person__c
                                            WHERE User__c IN :Users_With_Incorrect_Sales_People
                                            AND IsActive__c=true order by createddate desc];

        // Here we are mapping salesperson to their associated Owner ID. This list will include only active and primary salespersons.
        Map<String, Sales_Person__c> OwnersToSalesPersonsExt = new Map<String, Sales_Person__c>();
        for(Sales_Person__c sp: SalesPeopleExt) {
            //System.debug(LoggingLevel.INFO, sp.User__c + ' mapped to ' + sp.Id +'\t' +sp.Name);
            OwnersToSalesPersonsExt.put(sp.User__c, sp);
        }

        


        //How many accounts do we have to go through.
        System.debug(LoggingLevel.INFO,'Accounts Retrieved: ' + records.size());
        System.debug(LoggingLevel.INFO,'Sales People Retrieved: ' + SalesPeople.size());
        System.debug(LoggingLevel.INFO,'Sales People Mapped to User IDs: ' + OwnersToSalesPersons.size());

        /*
            Iterate through the returned accounts and for each account,
            see if an associated ownerID has an associated active and primary salesperson.
        */
        for (Account ac : records) {

            if(OwnersToSalesPersons.get(ac.OwnerId) != null){
                // We have a sales person we can use to update the account.
                ac.Sales_PersonID__c = OwnersToSalesPersons.get(ac.OwnerId).Id;
                updated_Grandparent_Accounts.add(ac);
            }
            else {
                System.debug(LoggingLevel.INFO,'No Corresponding Owner and sales person found.');
                
                
                if(OwnersToSalesPersonsExt.get(ac.OwnerId) != null){
                // We have a sales person we can use to update the account.
                ac.Sales_PersonID__c = OwnersToSalesPersonsExt.get(ac.OwnerId).Id;
                updated_Grandparent_Accounts.add(ac);
                
                }

                
                
            }

        }
        //If the list of accounts to be updated is empty, we are done.
        if (!updated_Grandparent_Accounts.isEmpty()){

            update updated_Grandparent_Accounts;
        }
    }

    global void finish(Database.BatchableContext bc){
        // execute any post-processing operations
        System.debug(LoggingLevel.INFO,'Hi, we are done... Granparent Accounts have had their owner IDs updated.');
    }
    
    
        global void execute(SchedulableContext sc)
    {
        Acc_Grandparent_Owner_Update_Batch  CreateOrgSummaryBatchObj = new Acc_Grandparent_Owner_Update_Batch ();
        database.executebatch(CreateOrgSummaryBatchObj , 1);
    } 
    

}