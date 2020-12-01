/**
* @author Adam Albright, adam.albright@officedepot.com
* @date 2/28/2018
*
* @group Utility
* @group-content /ApexDocContent/Index.htm
*
* @description This is a general utility class setup to make other actions within the organization easier.
* members of this class should work for any object. Object specific utility methods should be placed in their
* respective MyUtils_[ObjectName] class.
*/
public class MyUtils {

    /*******************************************************************************************************
    * @description Gets the SuperUser User.
    * @return The user object with the name SuperUser. SuperUser is an SystemAdmin API and can write to just about any recordtype.
    */
    public static User SuperUser(){
        User su;
        try{
            su = [SELECT Id, Name, Alias, Username FROM USER WHERE Name='Dataloader' AND Alias='data' LIMIT 1];
        } catch (QueryException e){
            System.debug('Message: ' + e.getMessage());
            System.debug('Line number: ' + e.getLineNumber());
            System.debug('Stack trace: ' + e.getStackTraceString());
        }
        return su;
    }

    /*******************************************************************************************************
    * @description Gets the Super User_BizBox User Object.
    * @return The user object with the Alias su_BBox. Super User_BizBox is an SystemAdmin API with bizbox recordtypes as default.
    */
    public static User SuperUser_BizBox(){
        User su;
        try{
             su = [SELECT Id, Name, Alias, Username FROM USER WHERE Name='Dataloader' AND Alias='data' LIMIT 1];
        } catch (QueryException e){
            System.debug('Message: ' + e.getMessage());
            System.debug('Line number: ' + e.getLineNumber());
            System.debug('Stack trace: ' + e.getStackTraceString());
        }
        return su;
    }

    /*******************************************************************************************************
    * @description Gets the Super User_BusPro UserObject.
    * @return The user object with the Alias su_BPro. Super User_BusPro is an SystemAdmin API with BusinessPro recordtypes as default.
    */
    public static User SuperUser_BusPro(){
        User su;
        try{
             su = [SELECT Id, Name, Alias, Username FROM USER WHERE Name='Dataloader' AND Alias='data' LIMIT 1];
        } catch (QueryException e){
            System.debug('Message: ' + e.getMessage());
            System.debug('Line number: ' + e.getLineNumber());
            System.debug('Stack trace: ' + e.getStackTraceString());
        }
        return su;
    }



    // TODO: Add a direction flag.
    /*******************************************************************************************************
    * @description Returns a map of picklist values and labels for a specified object and picklist field name.
    * @param MyObject The sObject for which a picklist map needs to be retrieved.
    * @param FieldName The Picklist field name on the sObject.
    * @return A map of pick list values to labels.
    */
    public static Map<String, String> GetSelectOptionsMap(SObject MyObject, String FieldName){
        Map<String, String> MyOptions = new Map<String, String>();
        Schema.sObjectType MySObjectType = MyObject.getSObjectType();
        Schema.DescribeSObjectResult MySObject_Describe = MySObjectType.getDescribe();
        Map<String, Schema.SObjectField> MyFieldMap = MySObject_Describe.fields.getMap();

        List<Schema.PicklistEntry> MyPickListValues = MyFieldMap.get(FieldName).getDescribe().getPickListValues();

        for(Schema.PicklistEntry entry: MyPickListValues) {
            MyOptions.put(entry.getValue(), entry.getLabel());
        }
        return MyOptions;
    }

    /*******************************************************************************************************
     * @author Adam Albright, adam.albright@officedepot.com
     * @date 21-December-2018
     *
     * @description Gets the Recordtypes available for the calling user. 
     * @param 
     *
     */
    public static Map<String, Id> GetAvailableRecordTypeNamesForSObject(Schema.SObjectType objType) {
        Map<String, Id> nameIdMap = new Map<String, Id>();
        List<RecordTypeInfo> infos = objType.getDescribe().getRecordTypeInfos();
        // If there are 2 or more RecordTypes...
        if (infos.size() > 1) {
            for (RecordTypeInfo rt : infos) {
               if (rt.isAvailable() && !rt.isMaster())
                nameIdMap.put(rt.getName(), rt.getRecordTypeId());
            }
        } 
        // Otherwise there's just the Master record type,
        // so add it in, since it MUST always be available
        else nameIdMap.put(infos[0].getName(), '');
        return nameIdMap;
    }

    
    /*******************************************************************************************************
    * @author Adam Albright, adam.albright@officedepot.com, 14 October 2019
    * @description Used to generate a list of mock ids for a salesforce object.
    */
    public static List<Id> generate_id_list(String sobject_name, Integer count){
        List<Id> my_ids = new List<Id>();

        String prefix = Schema.getGlobalDescribe().get(sobject_name).getDescribe().getKeyPrefix();
        for(Integer i=1; i <= count; i++)
            my_ids.add(Id.valueOf(prefix + integer_to_base62(i).leftpad(12, '0')));
        return my_ids;
    }


    /*******************************************************************************************************
    * @author Adam Albright, adam.albright@officedepot.com, 14 October 2019
    * @description Converts an integer to base62.
    * @param The input number to update. 
    */
    public static String integer_to_base62(Integer input_number){

        String base62 = '0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz';
        String final_result = '';

        Integer base = 62;
        Integer input = Math.abs(input_number);
        Integer remainder;
        while (input >= base) {
            remainder = Math.mod(input, base);
            final_result += String.fromCharArray( new List<integer> { base62.charAt(remainder) });
            input = input/base;
        }
        final_result += String.fromCharArray( new List<integer> { base62.charAt(input) } );

        if(input_number < 0)
            return '-' + final_result.reverse();
        
        return final_result.reverse();
    }

    /*******************************************************************************************************
    * @author Adam Albright, adam.albright@officedepot.com
    * @date 29-April-2020
    * @description Get the URL
    */

    @AuraEnabled
    public static string getHostURL(){
        return URL.getSalesforceBaseUrl().toExternalForm();
    }

    public static Schema.RecordTypeInfo getRecordTypeInfo(String sObjectName, String recordTypeDeveloperName){
        return Schema.getGlobalDescribe().get(sObjectName).getDescribe().getRecordTypeInfosByDeveloperName().get(recordTypeDeveloperName);
    }

    /*******************************************************************************************************
    * @author Adam Albright, adam.albright@officedepot.com
    * @date 23-June-2020
    * @description Get the URL
    */

    @AuraEnabled
    public static SObject getFieldsFromObject(String sObjectName, String recordId, List<String> fields){
        try{
            return new Query(sObjectName).selectFields(fields).byId(recordId).fetch();
        } catch(Exception e) {
            System.debug(LoggingLevel.ERROR, e);
            throw new AuraHandledException(
                'Error Occured while retrieving record data: SObject Name<' 
                + sObjectName + '>, RecordId: <'
                + recordId + '>, Fields: <' + fields +'>');
        }
    }
}