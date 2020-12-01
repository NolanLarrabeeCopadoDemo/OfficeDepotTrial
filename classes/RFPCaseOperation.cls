public class RFPCaseOperation
{
     //Variable Declaration
     static Map<String,Schema.RecordTypeInfo> CaseRecType = Schema.SObjectType.Case.getRecordTypeInfosByName();    
     static List<Customer_Transition__c> CTlistToUpdate = new List<Customer_Transition__c>();
     static Set<String> wtOmxKeySet = new Set<String>();
     static Map<String,ID> wrfMap = new Map<String,ID>(); // Omx Primary Key to AccId
        
public static void updateCTrepDesp(Map<ID,ID> wrfAccMap)
{
  
   // system.debug('wrfAccMap@@@'+wrfAccMap);
    System.debug(LoggingLevel.Info,'wrfAccMap '+wrfAccMap );
    if(wrfAccMap != null && wrfAccMap.size() > 0)
    {
        // Story - 00511627 - Fetching Parent WT CT records
        for(Customer_Transition__c eachCT : [select id,OMX_Primary_Key__c,Account__c from Customer_Transition__c where IsWritten_Parent__c = 'Y' and Status__c='Awaiting RFP' and Account__c in :wrfAccMap.keySet()])
        {
        wtOmxKeySet.add(eachCT.OMX_Primary_Key__c); //14617
        wrfMap.put(eachCT.OMX_Primary_Key__c,wrfAccMap.get(eachCT.Account__c));
        }
        System.debug(LoggingLevel.Info,'wtOmxKeySet@@@'+wtOmxKeySet );
        //system.debug('wtOmxKeySet@@@'+wtOmxKeySet);
        if(wtOmxKeySet != null && wtOmxKeySet.size() > 0)
        {
        // Story - 00511627 - Fetching whole hierarchy CT records - Updating hierarchy status to On Deck and updating WRF
            for(Customer_Transition__c eachCT : [select id,Status__c,OMX_Primary_Key__c,Written_Agreement_Customer_No__c,Related_WRF_Case__c from Customer_Transition__c where Written_Agreement_Customer_No__c in :wtOmxKeySet])
            {
            executeoncetest.isMod5Launch = true;
            if(eachCT.Written_Agreement_Customer_No__c==eachCT.OMX_Primary_Key__c)
            eachCT.Status__c = 'On Deck';
            eachCT.Customer_Disposition__c ='Customer RFP Received';
            eachCT.Related_WRF_Case__c = null;
            if(wrfMap != null && wrfMap.size() > 0 && wrfMap.containsKey(eachCT.OMX_Primary_Key__c))
            eachCT.Related_WRF_Case__c = wrfMap.get(eachCT.Written_Agreement_Customer_No__c);
            CTlistToUpdate.add(eachCT);
            }
            system.debug('CTlistToUpdate@@@'+CTlistToUpdate);
        }
    }

    // Updating CT records
    if(CTlistToUpdate != null && CTlistToUpdate.size() > 0)
    update CTlistToUpdate;
 }   
}