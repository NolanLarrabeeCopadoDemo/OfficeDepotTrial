@isTest
public class customLookUpController_TC {
    
    static testMethod void testFetchLookUpValues() {
        String searchKeyWord= 'Name';
        String fieldsToShow='';
        String searchField='Name';
        String lookupFilter='';
        String orderByField='';
        String ObjectName='DML__c';
    customLookUpController.fetchLookUpValues(searchKeyWord,searchKeyWord,searchField,lookupFilter,orderByField,ObjectName);
            
    }

}