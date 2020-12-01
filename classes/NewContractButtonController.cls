public class NewContractButtonController {
    public static Map<Id, String> recordtypemap {get;set;}
    
   @AuraEnabled        
    public static List<String> fetchRecordTypeValues(){
        List<Schema.RecordTypeInfo> recordtypes = Contract.SObjectType.getDescribe().getRecordTypeInfos();    
        recordtypemap = new Map<Id, String>();
        for(RecordTypeInfo rt : recordtypes){
            
            if(rt.getName() == 'Master' || rt.getName() == 'Beverage Service Agreement' || rt.getName() == 'Agreement')
            {
                
            }
            else
            {
                recordtypemap.put(rt.getRecordTypeId(), rt.getName());
            }
            	
        }        
        return recordtypemap.values();
    }
    
    @AuraEnabled
    public static String getRecTypeId(String recordTypeLabel){
        String recid = Schema.SObjectType.Contract.getRecordTypeInfosByName().get(recordTypeLabel).getRecordTypeId();        
        return recid;
    }      
}