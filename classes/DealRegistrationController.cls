/**
 * @Author: Krishna Gorllapati
 * @Description: Functionality to handle Lead deal registration.
 */
public class DealRegistrationController {

    @AuraEnabled
    public static Lead saveLeadDeal(Lead leadRec) {

        RecordType objRecType = [SELECT Id, Name, SobjectType FROM RecordType where developername = 'Lead_Deals' and SobjectType = 'Lead' limit 1];
        if(objRecType != null) {
            leadRec.recordTypeId = objRecType.Id; 
        }
        insert leadRec;
        return leadRec;
    }
    
    @AuraEnabled
    public static List<String> getPicklistValues(sObject objObject, String fieldName) 
    {
        return ODCommonUtilityMethods.getPicklistOptions(objObject, fieldName);
    }
}