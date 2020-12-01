/*******************************************************************************************************
 * @author Adam Albright, adam.albright@officedepot.com
 * @date 01-July-2019
 * @description This class sets up a new sandbox in terms of minimun necessary data.
 */

global with sharing class SandBoxSetup implements SandboxPostCopy {
    global static void runApexClass(SandboxContext context) {
        System.debug('Org ID: ' + context.organizationId());
        System.debug('Sandbox ID: ' + context.sandboxId());
        System.debug('Sandbox Name: ' + context.sandboxName());

        // Set up Sales_Persons.
        setUpSalesPersons();
        setUpPrimaryCompetitors();
        setUpExchangeRate();
        setUpPricingTemplate();


        // Insert logic here to prepare the sandbox for use.

    }

    global static void runSetup(){
        // Set up Sales_Persons.
        setUpSalesPersons();
        setUpPrimaryCompetitors();
        setUpExchangeRate();
        setUpExchangeRate();

        // Insert logic here to prepare the sandbox for use.
    }

    /*******************************************************************************************************
     * @author Adam Albright, adam.albright@officedepot.com
     * @date 01-July-2019
     * @description Gets System Admin and test users and creates SalesPersons for them.
     */
    static void setUpSalesPersons(){
        List<User> system_admins_and_test =
        [SELECT Id FROM USER Where Profile.Name IN ('System Administrator', 'System Administrator 2', 'Testing Field Sales', 'System Administrator API')
         AND IsActive = true];

        List<Sales_Person__c> my_sales_persons = new List<Sales_Person__c>();
        Integer index = 0;

        for(User my_user: system_admins_and_test) {
            my_sales_persons.add(new Sales_Person__c(
                                     IsActive__c = true,
                                     Primary__c = true,
                                     Name = 'TSP100' + String.valueOf(index),
                                     User__c = my_user.Id
                                     ));

            index += 1;
        }
        insert my_sales_persons;
    }

    static void setUpPrimaryCompetitors(){
        List<OpportunityCompetitor__c> my_competitor = new List<OpportunityCompetitor__c>();

        my_competitor.add(new OpportunityCompetitor__c(
                              Name='Staples'
                              ));
        my_competitor.add(new OpportunityCompetitor__c(
                              Name='Amazon'
                              ));
        insert my_competitor;
    }

    static void setUpExchangeRate(){
        List<Exchange_Rate__c> my_exchange_rates = new List<Exchange_Rate__c>();

        my_exchange_rates.add(new Exchange_Rate__c(
                                  Rate__c='1.08'
                                  ));
        my_exchange_rates.add(new Exchange_Rate__c(
                                  Rate__c='1.1'
                                  ));
        insert my_exchange_rates;
    }

    static void setUpPricingTemplate(){
        List<Pricing_Template__c> my_pricing_template_objects = new List<Pricing_Template__c>();


        Account my_parent = new Account(
            Name = 'OD Flex 15 Test Parent',
            AOPS_Cust_Id__c = '12345678',
            Hierarchy__c = 'P',
            RecordTypeId =  Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Parent').getRecordTypeId()
            );


        insert my_parent;
        

        my_pricing_template_objects.add( 
            new Pricing_Template__c(
                Name='OD Flex 15',
                Freight_Charge__c = 'Yes',
                Parent_Id__c = '12345678',
                Revenue_Band__c = 'STANDARD',
                Template__c = 'OD Flex 15',
                Template_code__c = '820',
                Account_Setup_Notes_c__c = 'This account will be auto setup within 10 mins. Comments will not be read.',
                Acct_Auto_Setup__c ='E'
            )
        );
        insert my_pricing_template_objects;
    }
}