// (c) 2016 Appirio, Inc.
//
// Batch class to update three fields on the Customer Transition Object each day
//
// 6 Oct 2016     Luke Slevin       Original S-440213/S-440215

global class BatchUpdateCustomerTransition implements Database.Batchable<sObject> {

    global Database.QueryLocator start(Database.BatchableContext BC) {
        String query =  'SELECT Id, Enterprise_Account_Owner_Email__c,Enterprise_Managing_Director_Email__c,Enterprise_RVP_Emai__c,'+
                        'Enterprise_Account_Owner__c,Enterprise_Managing_Director__c,Enterprise_RVP__c,'+
                        'Customer_Transition_Type2__c,Account__r.Owner.Email, Account__r.Parent.Owner.Email,'+
                        'Account__r.Parent.Parent.Owner.Email, Account__r.Owner.Manager.Email,Account__r.Parent.Owner.Manager.Email,'+
                        'Account__r.Parent.Parent.Owner.Manager.Email,Account__r.Owner.Manager.Manager.Email,Account__r.Parent.Owner.Manager.Manager.Email,'+
                        'Account__r.Parent.Parent.Owner.Manager.Manager.Email,Account__r.Owner.Name,Account__r.Owner.Manager.Name,Account__r.Owner.Manager.Manager.Name '+
                        'FROM Customer_Transition__c';
        return Database.getQueryLocator(query);

    }

    global void execute(Database.BatchableContext BC, List<Customer_Transition__c> scope) {

        for(Customer_Transition__c ct : scope)  {
            if(ct.Customer_Transition_Type2__c == 'Grandparent')    {
                ct.Enterprise_Account_Owner_Email__c = ct.Account__r.Owner.Email;
                ct.Enterprise_Account_Owner__c = ct.Account__r.Owner.Name;
            }
            else if(ct.Customer_Transition_Type2__c == 'Parent')    {
                ct.Enterprise_Account_Owner_Email__c = ct.Account__r.Parent.Owner.Email;
                ct.Enterprise_Account_Owner__c = ct.Account__r.Owner.Name;
            }
            else if(ct.Customer_Transition_Type2__c == 'Child') {
                ct.Enterprise_Account_Owner_Email__c = ct.Account__r.Parent.Parent.Owner.Email;
                ct.Enterprise_Account_Owner__c = ct.Account__r.Owner.Name;
            }
            else    {
                ct.Enterprise_Account_Owner_Email__c = '';
                ct.Enterprise_Account_Owner__c = '';
            }

            if (ct.Customer_Transition_Type2__c == 'Grandparent')   {
                ct.Enterprise_Managing_Director_Email__c = ct.Account__r.Owner.Manager.Email;
                ct.Enterprise_Managing_Director__c = ct.Account__r.Owner.Manager.Name;
            }
            else if (ct.Customer_Transition_Type2__c == 'Parent')   {
                ct.Enterprise_Managing_Director_Email__c = ct.Account__r.Parent.Owner.Manager.Email;
                ct.Enterprise_Managing_Director__c = ct.Account__r.Owner.Manager.Name;
            }
            else if (ct.Customer_Transition_Type2__c == 'Child')    {
                ct.Enterprise_Managing_Director_Email__c = ct.Account__r.Parent.Parent.Owner.Manager.Email;
                ct.Enterprise_Managing_Director__c = ct.Account__r.Owner.Manager.Name;
            }
            else    {
                ct.Enterprise_Managing_Director_Email__c = '';
                ct.Enterprise_Managing_Director__c = '';
            }

            if (ct.Customer_Transition_Type2__c == 'Grandparent')   {
                ct.Enterprise_RVP_Emai__c = ct.Account__r.Owner.Manager.Manager.Email;
                ct.Enterprise_RVP__c = ct.Account__r.Owner.Manager.Manager.Name;
            }
            else if (ct.Customer_Transition_Type2__c == 'Parent')   {
                ct.Enterprise_RVP_Emai__c = ct.Account__r.Parent.Owner.Manager.Manager.Email;
                ct.Enterprise_RVP__c = ct.Account__r.Owner.Manager.Manager.Name;
            }
            else if (ct.Customer_Transition_Type2__c == 'Child')    {
                ct.Enterprise_RVP_Emai__c = ct.Account__r.Parent.Parent.Owner.Manager.Manager.Email;
                ct.Enterprise_RVP__c = ct.Account__r.Owner.Manager.Manager.Name;
            }
            else    {
                ct.Enterprise_RVP_Emai__c  = '';
                ct.Enterprise_RVP__c = '';
            }
        }
        update scope;
    }

    global void finish(Database.BatchableContext BC) {

    }

}