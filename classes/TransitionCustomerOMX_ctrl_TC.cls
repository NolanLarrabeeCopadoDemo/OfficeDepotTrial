@isTest
Public class TransitionCustomerOMX_ctrl_TC
{
    static testmethod void method1()
    {
    
        
        Account pacc = new Account ();
        pacc.name = 'SUN Test Account1';
        pacc.BillingStreet = '1040 N 326 W';
        pacc.billingcity = 'Orem';
        pacc.BillingState = 'UT';
        pacc.Billingcountry = 'USA';
        pacc.Oracle_Party_Id__c = '543456';
        pacc.AOPS_Cust_Id__c = '003456';
        insert pacc;
        
        Account acc = new Account ();
        acc.name = 'SUN Test Account';
        acc.BillingStreet = '1040 N 326 W';
        acc.billingcity = 'Orem';
        acc.BillingState = 'UT';
        acc.Billingcountry = 'USA';
        acc.Oracle_Party_Id__c = '123456';
        acc.AOPS_Cust_Id__c = '123456';
        acc.parentid=pacc.id;
        insert acc;   
        
        Customer_Transition__c CT = new Customer_Transition__c(name='test',Status__c='Scheduled',Error_Message_Level__c='Cost Center Failure',Error_Message_Type__c='Data Failure',Error_Message__c='Error',Account__c=acc.id,OMX_Primary_Key__c='omxTest1');
        insert CT;
        
        Customer_Transition_Dtls__c CTD = new Customer_Transition_Dtls__c(Error_Message_Level__c='Cost Center Failure',Error_Message_Type__c='Data Failure',Customer_Transition_ID__c=CT.id,Error_Message__c='Error',OMX_Primary_Key__c=CT.OMX_Primary_Key__c);
        insert CTD;
        
        ApexPages.currentPage().getParameters().put('id',CT.id);
        
        Test.startTest(); // added for the story #S-418600 (00715635)

        TransitionCustomerOMX_ctrl con = new TransitionCustomerOMX_ctrl();
        
        // added for the story #S-418600 (00715635) #START
        
        TransitionCustomerOMX_ctrl.sortingField = 'name'; 
        TransitionCustomerOMX_ctrl.sortDir = 'limit 12'; 
        con.accountName = 'testAccount';
        con.custAccountName = 'testCusAccName';
        con.recordTypeValue = 'testValue';
        
        // added for the story #S-418600 (00715635) #END
        
        con.ErrorMessageLevelValue = 'Cost Center Failure';
        con.ErrorMessageTypeValue = 'Data Failure';
        
        con.Search();
        con.populateOMX();
        con.first();
        con.last();
        con.previous();
        con.next();
        
        // added for the story #S-418600 (00715635) #START
        
        Boolean result = con.hasNext;
        result = con.hasPrevious;
        Integer pageNumber = con.pageNumber; 
        
        Test.stopTest(); 
        
        // added for the story #S-418600 (00715635) #END 
        
    }
}