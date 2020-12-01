@isTest
private class updateHierarchy_TC
{
    static testMethod void updateHierarchyUnitTest()
    {
        List<Id> parentId= new List<Id>();
        List<Customer_Transition__c > parentRecord= [ Select Id,Account__c from Customer_Transition__c  where Account__c  in:parentId ];
        Map<Id,Id> custMap= new  Map<Id,Id>();
        Account ParentAcc = new Account();
        ParentAcc.Name='Parent Test Account';
        insert ParentAcc;
        
        Account acc = new Account();
        acc.Name='Test Account';
        acc.parentId= ParentAcc.id;
        insert acc;
        
        Customer_Transition__c cust = new Customer_Transition__c();
        cust.name='Testing1';
        cust.Account__c= acc.id;
        
        cust.updateHierachy__c= false;
        cust.Parent_Transition_ID__c = cust.id;
        cust.Written_Agreement_ID__c = cust.id;
        cust.Written_Agreement__c = false;
        cust.ODS_WA_EXECUTED__c = false;
        insert cust;
        
        Customer_Transition__c cust2 = new Customer_Transition__c();
        cust2.name='Testing10';
        cust2.Account__c= acc.id;
        
        cust2.updateHierachy__c= true;
        cust2.Parent_Transition_ID__c = cust2.id;
        cust2.Written_Agreement_ID__c = cust2.id;
        cust2.Written_Agreement__c = true;
        cust.ODS_WA_EXECUTED__c = false;
        cust.status__c = 'ReScheduled';
        //cust.Related_WRF_Case__c = null;
        cust.Parent_Transition_ID__c = null;
        //cust.Parent_ID__c = null;
        insert cust2;
        
        
        
        Customer_Transition__c cust1 = new Customer_Transition__c();
        cust1.Account__c = ParentAcc.id;
        cust1.name='TestingHier';
        insert cust1;
        
        cust.updateHierachy__c= true;
        update cust;
        
        cust.Review_Start_Date__c = Date.Today();
        cust.status__c = 'ReScheduled';
        update cust;
        cust.Review_Start_Date__c = Date.Today().addDays(2);
        update cust;
        cust.Review_Start_Date__c = null;
        cust.Customer_Response__c = 'Test Response';
        update cust;
        
        //Added for story S-355236 #Start
        cust.Customer_Response__c = 'Test Response1';
        update cust;
        //Added for story S-355236 #End
        
        cust.Parent_Transition_ID__c = cust1.id;
        cust.Written_Agreement_ID__c = cust1.id;
        cust.Written_Agreement__c = true;
        cust.ODS_WA_EXECUTED__c = false;
        cust.status__c = 'Scheduled';
        //cust.Parent_ID__c = null;
        //cust.Related_WRF_Case__c = cust1.Related_WRF_Case__c;
        update cust;
        
        
        cust.Parent_Transition_ID__c = cust1.id;
        cust.Written_Agreement_ID__c = cust1.id;
        cust.Written_Agreement__c = false;
        //cust.Parent_ID__c = null;
        cust.Parent_Transition_ID__c = null;
        cust.status__c = 'Scheduled';
        cust.Related_WRF_Case__c = cust1.Related_WRF_Case__c;
        update cust;
        
        Account a = new Account();
        Customer_Transition__c cust3 = new Customer_Transition__c();
        cust3.Account__c = cust1.Account__c; //'001E000000EFMhB';
        cust3.Parent_Transition_ID__c = cust1.id;
        cust3.status__c = 'Scheduled';
        cust3.Written_Agreement_ID__c = null;
        cust3.Written_Agreement__c = false;
        cust3.ODS_WA_EXECUTED__c = false;
        insert cust3;

        }  
    }