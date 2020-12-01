public class GPOLookUpController {
    @AuraEnabled
    public static List < String > fetchLookUpValues(String searchKeyWord) {
        
        String searchKey = searchKeyWord + '%';
        String typeKey = '%'+'Parent';
        String Value = 'Other Current GPO';
        
        List < String > returnList = new List < String > ();
      
        
        String sQuery =  'select id, Name from Account where Name LIKE: searchKey and Current_GPO__c=true and RecordType_Name__c LIKE: typeKey';
        List < Account > lstOfRecords = Database.query(sQuery);
        
        
        for (Account obj: lstOfRecords) {
            returnList.add(obj.Name);
        }
        returnList.add(Value);
        system.debug('===returnList=='+returnList);
        return returnList;
    }
}