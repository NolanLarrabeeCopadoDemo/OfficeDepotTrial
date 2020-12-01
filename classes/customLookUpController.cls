public class customLookUpController {
    @AuraEnabled
    public static List <sObject> fetchLookUpValues(String searchKeyWord,String fieldsToShow, String searchField, String lookupFilter, String orderByField, String ObjectName) {        
        String searchKey = searchKeyWord + '%';        
        List < sObject > returnList = new List < sObject > ();      
        String[] searchFields = searchField.split(',');
        string searchString = '';
        for(String field : searchFields){
            if(searchString ==''){
                 searchString = field + ' LIKE: searchKey';
            }
            else{
                 searchString += ' OR ' + field + ' LIKE: searchKey';
            }           
        }
        searchString = '(' + searchString + ')';
        String sQuery =  'select id,' + fieldsToShow + ' from ' +ObjectName + ' where ' + searchString;
        if(lookupFilter != ''){
            sQuery =  sQuery + ' AND '+ lookupFilter;    
        }  
        if(orderByField != ''){
             sQuery =  sQuery + ' order by '+ orderByField + ' ASC ';                
        }
        sQuery = sQuery + ' LIMIT 10';        
        system.debug('sQuery==>' + sQuery);
        List < sObject > lstOfRecords = Database.query(sQuery);        
        for (sObject obj: lstOfRecords) {
            returnList.add(obj);
        }
        return returnList;
    }
}