public class InputDependantSelectController {
    @AuraEnabled
    public static Map<String,List<String>> getDependentOptions(String pObjName, String pControllingFieldName, String pDependentFieldName){
        system.debug('pObjName...'+pObjName);
        system.debug('pControllingFieldName...'+pControllingFieldName);
        system.debug('pDependentFieldName...'+pDependentFieldName);
        return TStringUtils.GetDependentOptions(pObjName, pControllingFieldName, pDependentFieldName);
    }
    @AuraEnabled
    public static List<String> getDependentValForCtrlPickVal(String pObjName, String pControllingFieldName, String pDependentFieldName,String ctrlPicklistVal){
        Map<String,List<String>> dependentMap = new Map<String,List<String>>();
        List<String> dependentVal = new List<String>();
        dependentMap =  InputDependantSelectController.getDependentOptions(pObjName, pControllingFieldName, pDependentFieldName);
        system.debug('dependentMap........'+dependentMap);
        system.debug('ctrlPicklistVal........'+ctrlPicklistVal);
        system.debug('ctrlPicklistVal*****'+dependentMap.get(ctrlPicklistVal));
        if(dependentMap.containsKey(ctrlPicklistVal)){
            dependentVal = dependentMap.get(ctrlPicklistVal);
        }
        return dependentVal;
    }
}