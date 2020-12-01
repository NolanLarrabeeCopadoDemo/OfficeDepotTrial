public class CT_extnsionAgrmnt_cls
{
    //Variables Declaration
    public static Id WRFRequestID = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Work Request').getRecordTypeId();    
    
     public static void setExtAgrmnt(Map<String,String> mapCTdesp)
    {
        //Variables Declaration
        Set<String> extAgrmntCTIDs = mapCTdesp.keySet();
        Set<Case> wrfSet = new Set<Case>();
        List<Case> wrfList;
        List<Customer_Transition__c> waCTs = new List<Customer_Transition__c>();
        List<Customer_Transition__c> updateChildCT = new List<Customer_Transition__c>();
        List<Customer_Transition__c> updatedChildCT = new List<Customer_Transition__c>();
        Map<Id,Customer_Transition__c> acct2Wa = new Map<Id,Customer_Transition__c>();
        Map<Id,Id> wa2Case = new Map<Id,Id>();
        
        if((extAgrmntCTIDs != null) & (extAgrmntCTIDs.size() > 0))
        {
        //Written agreement List with required details
         waCTs = [select id, account__c,account__r.ownerID,status__c,Written_Agreement_ID__c,Related_WRF_Case__c,OMX_Primary_Key__c,Written_Agreement_Customer_No__c from Customer_Transition__c where OMX_Primary_Key__c in :extAgrmntCTIDs or Written_Agreement_Customer_No__c in :extAgrmntCTIDs];
            system.debug('@@waCTs '+waCTs);
            if(waCTs != NULL && !(waCTs.isEmpty()))
            {
                for(Customer_Transition__c waCT: waCTs)
                {   
                    if(extAgrmntCTIDs.contains(waCT.OMX_Primary_Key__c))
                    {
                    acct2Wa.put(waCT.account__c,waCT);
                    //eachLockCT.Related_WRF_Case__c = null;
                    //eachLockCT.Related_WRF_Case__c = (Id)wa2Case.get(eachLockCT.Written_Agreement_Customer_No__c);
                    //New WRF Creation
                    Case eachWRF = New Case( Accountid = waCT.account__c,
                    WRF_Requestor__c =  waCT.account__r.ownerID,
                    Reason = 'WRF Request', 
                    Priority = '3-Medium',
                    Subject = mapCTdesp.get(waCT.OMX_Primary_Key__c)+' Disposition Request',
                    Status = 'Open',
                    RecordTypeId = WRFRequestID,  //Work Request 
                    WRF_Request_Type__c = 'Transition', 
                    CPM_Required__c= True, 
                    WRF_Finance__c = FALSE);
                    system.debug('@@eachWRF '+eachWRF);
                    if(!wrfSet.contains(eachWRF))
                    {
                    wrfSet.add(eachWRF);
                    }
                    }
                }
                system.debug('@@wrfSet '+wrfSet);
                //WRF insertion
                if(wrfSet.size()>0)
                {
                wrfList = new List<Case>(wrfSet);
                insert wrfList;
                }
                //WRF mapping in Written Agreements
                for(Case eachWRF: wrfList)
                {   
                //acct2Wa.get(eachWRF.Accountid).Related_WRF_Case__c = null;
                //acct2Wa.get(eachWRF.Accountid).Related_WRF_Case__c = eachWRF.ID;
                wa2Case.put(acct2Wa.get(eachWRF.Accountid).ID,eachWRF.ID);
                //Mapping WRF in original Parent Record
                Customer_Transition__c WaCTrecord = (Customer_Transition__c)Trigger.newMap.get(acct2Wa.get(eachWRF.Accountid).ID);
                WaCTrecord.Related_WRF_Case__c = null; 
                WaCTrecord.Related_WRF_Case__c = eachWRF.ID;
                }
                //WA child record status and WRF mapping
                for(Customer_Transition__c eachChildCT : waCTs)
                {   
                    if(!extAgrmntCTIDs.contains(eachChildCT.OMX_Primary_Key__c))
                    {
                        eachChildCT.Status__c = 'OMX Extension in Development';
                        eachChildCT.Customer_Disposition__c = mapCTdesp.get(eachChildCT.Written_Agreement_Customer_No__c);
                        if(eachChildCT.Customer_Disposition__c =='Customer RFP Received')
                        {
                        eachChildCT.status__c='On Deck';
                        executeoncetest.isMod5Launch = true;
                        }
                        //Updating WRF on Child Records
                        eachChildCT.Related_WRF_Case__c = null;
                        eachChildCT.Related_WRF_Case__c = wa2Case.get(eachChildCT.Written_Agreement_ID__c);
                        updatedChildCT.add(eachChildCT);
                    }
                }
                //WA CT Child insertion
                if(updatedChildCT.size()>0)
                {
                update updatedChildCT;
                }
            }
        }
    }
}