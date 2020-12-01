public class CT_OnDeck_WRF_cls
 {
    //Variables Declaration
    public static Id WRFRequestID = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Work Request').getRecordTypeId();    
    public static string ThisID;
    public static Map<Id,string> Acct2Case = new Map<Id,string>(); // Trigger CT ID as Key and Top Parent Account id as value;
    public static Map<Id,string> acctOwner = new Map<Id,string>(); // Trigger CT ID as Key and Top Parent Account Owner id as value;
    public static Map<Id,Id> ctToCase = new Map<Id,Id>(); // Trigger CT ID as Key and Case id as value;
    public static string WA_ID;
    public static string WA;
    public static Map<Id,Id> topCT = new Map<Id,Id>(); // Top Parent ID as Key and Trigger CT id as value
    public static Map<Id,Customer_Transition__c> mappedCT = new Map<Id,Customer_Transition__c>();  // Trigger CT id as Key and Trigger CT as value
    public static Map<Id,Id> allCTtoMappedCT = new Map<Id,Id>(); // All Child CT id as Key and Trigger CT id as value
    public static Map<Id,Id> childCTtoMappedCT = new Map<Id,Id>(); // All Child CT id as Key and Trigger CT id as value
    public static List<Customer_Transition__c> updatedCT = new List<Customer_Transition__c> ();
    public static List<Customer_Transition__c> allCT = new List<Customer_Transition__c> ();
    public static Set<ID> checkDuplicate = new Set<Id>();
    
    public static Set<Id> checkDupCase = new Set<Id>();
    public static Set<ID> wrfUpdateSet = new Set<Id>();
    
    
    
    public static void futureUpdateWRF(Set<ID> wrfSet,Id WRFReqID) 
    {
        List<Case> updateCase = new List<Case>();
            for(Id eachCaseID : new List<Id>(wrfSet))
            {
            Case eachCase = new Case();
            eachCase.id = eachCaseID;
            eachCase.Reason = 'WRF Request';
            eachCase.Priority = '3-Medium';
            eachCase.Status = 'Open';
            eachCase.RecordTypeId = WRFReqID;  //Work Request 
            eachCase.WRF_Request_Type__c = 'Transition';
            eachCase.CPM_Required__c= True;
            eachCase.WRF_Finance__c = FALSE;
            eachCase.WRF_Written_Agreement__c = WA;
            eachCase.Approved_for_Analyst_Assignment__c = true;
            updateCase.add(eachCase);
            }
        if(!(updateCase.isEmpty())&&(updateCase.size() > 0))    
        update updateCase;
    }
    
    public static void getCustLostHeir(Set<ID> CTids)
    {
     List <Customer_Transition__C> getChild = [Select ID,
                                                 Parent_transition_ID__c,
                                                 Parent_transition_ID__r.Parent_transition_ID__c,
                                                 Parent_transition_ID__r.Parent_transition_ID__r.Parent_transition_ID__c
                                                 FROM customer_Transition__c 
                                                 Where 
                                                 (Parent_transition_ID__r.Parent_transition_ID__r.Parent_transition_ID__c in :CTids or
                                                 Parent_transition_ID__r.Parent_transition_ID__c in :CTids or
                                                 Parent_transition_ID__c in :CTids) and 
                                                 (Account__r.QTD_Sales_TY__c  <= 0 or
                                                 Account__r.QTD_Sales_TY__c = null)];
                                                 
     if(!(getChild.isEmpty())&&(getChild!=NULL))
     {
        for (Customer_Transition__c eachRecord : getChild)
            {
            IF (CTids.contains(eachRecord.Parent_transition_ID__r.Parent_transition_ID__r.Parent_transition_ID__c))
                {
                         childCTtoMappedCT.put(eachRecord.Id,eachRecord.Parent_transition_ID__r.Parent_transition_ID__r.Parent_transition_ID__c);                       
                }
                Else IF (CTids.contains(eachRecord.Parent_transition_ID__r.Parent_transition_ID__c))
                {
                         childCTtoMappedCT.put(eachRecord.Id,eachRecord.Parent_transition_ID__r.Parent_transition_ID__c);                       
                }
                Else IF (CTids.contains(eachRecord.Parent_transition_ID__c))
                {
                         childCTtoMappedCT.put(eachRecord.Id,eachRecord.Parent_transition_ID__c);                       
                }
            }
     }
    }
    
    public static void getAllInHeirarchy(Set<ID> CTids)
    {
        
        List <Customer_Transition__C> getParent = [Select ID, Parent_transition_ID__c,
                                                 Account__c,Account__r.OwnerId,
                                                 Parent_transition_ID__r.Parent_transition_ID__c,
                                                 Parent_transition_ID__r.Parent_transition_ID__r.Parent_transition_ID__c,
                                                 Parent_transition_ID__r.Account__c,
                                                 Parent_transition_ID__r.Account__r.OwnerId,
                                                 Parent_transition_ID__r.Parent_transition_ID__r.Account__c,
                                                 Parent_transition_ID__r.Parent_transition_ID__r.Account__r.OwnerId,
                                                 Parent_transition_ID__r.Parent_transition_ID__r.Parent_transition_ID__r.Account__c,
                                                 Parent_transition_ID__r.Parent_transition_ID__r.Parent_transition_ID__r.Account__r.OwnerId
                                                 FROM customer_Transition__c 
                                                 Where ID in :CTids];
        if(!(getParent.isEmpty()))
        {
        //Going to Top Level to access Account and Owner Details
            for (Customer_Transition__c eachRecord : getParent)
            {
                IF (eachRecord.Parent_transition_ID__r.Parent_transition_ID__r.Parent_transition_ID__c != Null)
                {
                         Acct2Case.put(eachRecord.Id,eachRecord.Parent_transition_ID__r.Parent_transition_ID__r.Parent_transition_ID__r.Account__c);                       
                         acctOwner.put(eachRecord.Id,eachRecord.Parent_transition_ID__r.Parent_transition_ID__r.Parent_transition_ID__r.Account__r.OwnerId);                   
                         topCT.put(eachRecord.Parent_transition_ID__r.Parent_transition_ID__r.Parent_transition_ID__c,eachRecord.Id);
                }
                Else IF (eachRecord.Parent_transition_ID__r.Parent_transition_ID__c != Null)
                {
                         Acct2Case.put(eachRecord.Id,eachRecord.Parent_transition_ID__r.Parent_transition_ID__r.Account__c);                       
                         acctOwner.put(eachRecord.Id,eachRecord.Parent_transition_ID__r.Parent_transition_ID__r.Account__r.OwnerId);                       
                         topCT.put(eachRecord.Parent_transition_ID__r.Parent_transition_ID__c,eachRecord.Id);
                }
                Else IF (eachRecord.Parent_transition_ID__c != Null)
                {
                         Acct2Case.put(eachRecord.Id,eachRecord.Parent_transition_ID__r.Account__c);                       
                         acctOwner.put(eachRecord.Id,eachRecord.Parent_transition_ID__r.Account__r.OwnerId);                       
                         topCT.put(eachRecord.Parent_transition_ID__c,eachRecord.Id);
                }
                else
                {
                         Acct2Case.put(eachRecord.Id,eachRecord.Account__c);                       
                         acctOwner.put(eachRecord.Id,eachRecord.Account__r.OwnerId);                       
                         topCT.put(eachRecord.id,eachRecord.Id);
                }
            }
        }
        Set<id> topIDs = new Set<id>(topCT.keySet());
        allCT = [Select ID,Status__c, Related_WRF_Case__c,Written_Agreement__c,Customer_Transition_Date_to_OD_Systems__c,Customer_Loss__c,Administrative_Close__c,Parent_transition_ID__r.Parent_transition_ID__r.Parent_transition_ID__c,Parent_transition_ID__r.Parent_transition_ID__c,Parent_transition_ID__c FROM customer_Transition__c 
        Where (id in :topIDs or Parent_transition_ID__c in :topIDs or 
        Parent_transition_ID__r.Parent_transition_ID__c in :topIDs or 
        Parent_transition_ID__r.Parent_transition_ID__r.Parent_transition_ID__c in :topIDs)];
        for(customer_Transition__c eachRecord: allCT)
        {
            IF ((eachRecord.Parent_transition_ID__r.Parent_transition_ID__r.Parent_transition_ID__c != Null)&&(topCT.containsKey(eachRecord.Parent_transition_ID__r.Parent_transition_ID__r.Parent_transition_ID__c)))
            {
                    allCTtoMappedCT.put(eachRecord.id,topCT.get(eachRecord.Parent_transition_ID__r.Parent_transition_ID__r.Parent_transition_ID__c));
            }
            Else IF ((eachRecord.Parent_transition_ID__r.Parent_transition_ID__c != Null)&&(topCT.containsKey(eachRecord.Parent_transition_ID__r.Parent_transition_ID__c)))
            {
                    allCTtoMappedCT.put(eachRecord.id,topCT.get(eachRecord.Parent_transition_ID__r.Parent_transition_ID__c));
            }
            Else IF ((eachRecord.Parent_transition_ID__c != Null)&&(topCT.containsKey(eachRecord.Parent_transition_ID__c)))
            {
                    allCTtoMappedCT.put(eachRecord.id,topCT.get(eachRecord.Parent_transition_ID__c));
            } 
            Else IF (topCT.containsKey(eachRecord.id))
            {
                    allCTtoMappedCT.put(eachRecord.id,topCT.get(eachRecord.id));
            } 
        }
        
    }

    public static void initial(List<Customer_Transition__c> CTs,String strWA)
    {    
        if(strWA=='nonWA')
        {
            nonWrittenAgreementCT(CTs);
        }
        else if(strWA=='WA')
        {
            WrittenAgreementCT(CTs);
        }
        else if(strWA=='Status')
        {
            statuschangeCT(CTs);
        }
    }                      

    public static void nonWrittenAgreementCT(List<Customer_Transition__c> CTs)
    {
        Set<ID> CTids = new Set<ID>();
        for(Customer_Transition__c CT : CTs)
        {
            CTids.add(CT.Id);
        }

        if(!(CTids.isEmpty()))
        {
            getAllInHeirarchy(CTids);
            Set<ID> lockCT = new Set<ID>(allCTtoMappedCT.keySet());
            List<Customer_Transition__c> updateCT = [select id,Written_Agreement_ID__c,Customer_Loss__c,Administrative_Close__c,Customer_Transition_Date_to_OD_Systems__c,status__c,Compliance_Life_Cycle_Reviewed_Person__c,Compliance_Life_Cycle_Reviewed__c,Written_Agreement__c,Ready_for_Mod1__c from Customer_Transition__c where id in :lockCT];
            for(Customer_Transition__c eachLockCT : updateCT)
            {
                if((eachLockCT.Written_Agreement_ID__c == null) && (eachLockCT.status__c != 'Launched') && (eachLockCT.Ready_for_Mod1__c != true))
                {
                System.debug('&&&&&&&&&&&&&&&&&&&&&&&&&&IS1');
                eachLockCT.Status__c = 'On Deck'; 
                    if(!(checkDuplicate.contains(eachLockCT.Id)))
                    {
                        //Updating hierarchy as On Deck
                        updatedCT.Add(eachLockCT);         
                        checkDuplicate.add(eachLockCT.Id);
                    }
                }
            }
        }
    }                    
 
 
   public static void WrittenAgreementCT(List<Customer_Transition__c> CTs)
    {
        Set<ID> CTids = new Set<ID>();
        Map<Id,String> triggerCTtoWARecord= new Map<Id,String>();
        Map<String,Id> acct4Cases = new Map<String,Id>();
        Map<Id,String> acct2Wa = new Map<Id,String>();
        Map<String,Id> wa2Case = new Map<String,Id>();
        Map<String,Id> acctOwners = new Map<String,Id>();
        List<Customer_Transition__c> waCTs = new List<Customer_Transition__c>();

        for(Customer_Transition__c CT : CTs)
        {
            CTids.add(CT.Id);
            triggerCTtoWARecord.put(CT.id,CT.Written_Agreement_Customer_No__c);
        }
        system.debug('@@triggerCTtoWARecord '+triggerCTtoWARecord);
        if(!(CTids.isEmpty()))
        {
            Set <String> allWAid = new Set <String>(triggerCTtoWARecord.values());
            system.debug('@@allWAid '+allWAid);
            waCTs = [select id, account__c,account__r.ownerID,status__c,Ready_for_Mod1__c,Written_Agreement_ID__c,Related_WRF_Case__c,Written_Agreement_Customer_No__c from Customer_Transition__c where OMX_Primary_Key__c in :allWAid]; //Written agreement List
            system.debug('@@waCTs '+waCTs);
            if(waCTs != NULL && !(waCTs.isEmpty()))
            {
                for(Customer_Transition__c waCT: waCTs)
                {
                    acct4Cases.put(waCT.Written_Agreement_Customer_No__c,waCT.account__c);
                    acctOwners.put(waCT.Written_Agreement_Customer_No__c,waCT.account__r.ownerID);
                    acct2Wa.put(waCT.account__c,waCT.Written_Agreement_Customer_No__c);
                }
                system.debug('@@acct4Cases '+acct4Cases);
                system.debug('@@acctOwners '+acctOwners);
                system.debug('@@acct2Wa '+acct2Wa);
                List<Case> cases = new List<Case>();
                               
                for(String eachCTid : triggerCTtoWARecord.values())
                {
                if((acct4Cases.get(eachCTid)!=null && acctOwners.get(eachCTid)!=null) && (!(checkDupCase.contains(acct4Cases.get(eachCTid)))))
                {
                    Case Ca = New Case( Accountid = acct4Cases.get(eachCTid),
                    WRF_Requestor__c =  acctOwners.get(eachCTid));
                    
                    
                    //Moved to Future method futureUpdateWRF
                    //Reason = 'WRF Request', 
                    //Priority = '3-Medium', 
                    //Status = 'Open',
                    //RecordTypeId = WRFRequestID,  //Work Request 
                    //WRF_Request_Type__c = 'Transition', 
                    //CPM_Required__c= True, 
                    //WRF_Finance__c = FALSE, 
                    //WRF_Written_Agreement__c = WA,
                    
                    Ca.Reason = 'WRF Request';
                    Ca.Priority = '3-Medium';
                    Ca.Status = 'Open';
                    Ca.RecordTypeId = WRFRequestID;  //Work Request 
                    Ca.WRF_Request_Type__c = 'Transition';
                    Ca.CPM_Required__c= True;
                    Ca.WRF_Finance__c = False;
                    Ca.WRF_Written_Agreement__c = WA;
                    Ca.Approved_for_Analyst_Assignment__c = true;

                    cases.add(Ca);
                    checkDupCase.add(acct4Cases.get(eachCTid));
                    system.debug('@@Ca '+Ca);
                    
                }
                }
                system.debug('@@casesout '+cases);
                if(!cases.isEmpty()){
                insert cases;
                system.debug('@@cases '+cases);
                for(Case ca : Cases)
                {
                    if(acct2Wa.containsKey(ca.AccountId))
                    {
                        wa2Case.put(acct2Wa.get(ca.AccountId),ca.Id);
                        wrfUpdateSet.add(ca.Id);
                    }
                }
                }
                List<Customer_Transition__c> updateCT = [select id,status__c,Related_WRF_Case__c, Written_Agreement__c,Written_Agreement_ID__c,Ready_for_Mod1__c,Written_Agreement_Customer_No__c from Customer_Transition__c where Written_Agreement_Customer_No__c in :allWAid and Ready_for_Mod1__c = false and status__c != 'Launched'];
                system.debug('@@updateCT '+updateCT );
                for(Customer_Transition__c eachLockCT : updateCT)
                {
                    if((eachLockCT.Written_Agreement_Customer_No__c != null) && (eachLockCT.status__c != 'Launched') && (eachLockCT.Ready_for_Mod1__c != true))
                    {
                    
                    System.debug('&&&&&&&&&&&&&&&&&&&&&&&&&&IS2');
                        eachLockCT.Status__c = 'On Deck';
                        //Updating WRF on Child Records
                        if(wa2Case.containsKey(eachLockCT.Written_Agreement_Customer_No__c))
                        {
                            eachLockCT.Related_WRF_Case__c = null;
                            eachLockCT.Related_WRF_Case__c = (Id)wa2Case.get(eachLockCT.Written_Agreement_Customer_No__c);
                        }
                        if(!(checkDuplicate.contains(eachLockCT.Id)))
                        {
                            //Updating hierarchy as On Deck 
                            updatedCT.Add(eachLockCT);        
                            checkDuplicate.add(eachLockCT.Id);
                        }
                    }
                }
                //if(!wrfUpdateSet.isEmpty() && wrfUpdateSet.size() > 0)
                //futureUpdateWRF(wrfUpdateSet,WRFRequestID);
            }
        }
    }
public static void statuschangeCT(List<Customer_Transition__c> CTs)
    {   
        system.debug('Status Method@@@@');
        Set<ID> CTids = new Set<ID>();
        Map<Id,String> triggerCTtoWARecord= new Map<Id,String>();
        Set<String> waRecordToCheckbox= new Set<String>();
        //set<ID> closeWrfList = new set<ID>();
        List<Customer_Transition__c> waCTs = new List<Customer_Transition__c>();

            system.debug('CTs@@@@'+CTs);
        for(Customer_Transition__c CT : CTs)
        {   
            CTids.add(CT.Id);
            triggerCTtoWARecord.put(CT.id,CT.Written_Agreement_Customer_No__c);
            
            if(ct.Agreement_Development__c == true)
            waRecordToCheckbox.add(CT.Written_Agreement_Customer_No__c+'-aggdev');

            if(ct.Agreement_Complete__c== true)
            waRecordToCheckbox.add(CT.Written_Agreement_Customer_No__c+'-aggcmplt');
            system.debug('>>>>waRecordToCheckbox>>>>'+waRecordToCheckbox);

        }
        if(!(CTids.isEmpty()))
        {
            Set <String> allWAid = new Set <String>(triggerCTtoWARecord.values());
            system.debug('allWAid@@@@'+allWAid);
            if(allWAid != NULL && !(allWAid.isEmpty()))
            {
                
                List<Customer_Transition__c> updateCT = [select id,status__c,Related_WRF_Case__c,
                                                        Written_Agreement_ID__c,Ready_for_Mod1__c,
                                                        Agreement_Development__c,Agreement_Complete__c, Contract_Extension_Complete__c,Extension_in_Development__c,Written_Agreement_Customer_No__c
                                                        from Customer_Transition__c where Written_Agreement_Customer_No__c in :allWAid];
                                                        system.debug('updateCT@@@@'+updateCT);
                for(Customer_Transition__c eachLockCT : updateCT)
                {
                    if(eachLockCT.status__c!='Launched' && eachLockCT.status__c!='Loss of Customer' && eachLockCT.status__c!='Administrative Close' && eachLockCT.Ready_for_Mod1__c != true){
                    
                        if(eachLockCT.Written_Agreement_Customer_No__c != null && eachLockCT.Related_WRF_Case__c != null){
                        if(waRecordToCheckbox.contains(eachLockCT.Written_Agreement_Customer_No__c+'-aggdev'))
                        eachLockCT.Agreement_Development__c=true;
                        if(waRecordToCheckbox.contains(eachLockCT.Written_Agreement_Customer_No__c+'-aggcmplt'))
                        eachLockCT.Agreement_Complete__c=true;
                        if(waRecordToCheckbox.contains(eachLockCT.Written_Agreement_Customer_No__c+'-extdev'))
                        eachLockCT.Extension_in_Development__c= true;
                        }
                        system.debug('$$$waRecordToCheckbox$$$'+eachLockCT.Id);
                        
                        if(!(checkDuplicate.contains(eachLockCT.Id)))
                        {
                            updatedCT.Add(eachLockCT);        
                            checkDuplicate.add(eachLockCT.Id);
                        }
                        system.debug('updatedCT@@@@'+updatedCT);
                    }
                }
            }
        }
    }
    
     //Closing Related WRF when Updating Written Agreement Level to Blank
     public static void closeWrf(Set<ID> closeWrfSet,Map<String,String> closeWAMap,Set<ID> ctWRFCloseSet)
    { 
        List<Case> updatedCases = new List<Case>();
        List<Customer_Transition__c> tempCTlist = new List<Customer_Transition__c>();
        List<Customer_Transition__c> updatedCTCloseWRF = new List<Customer_Transition__c>();
        Set<string> waWRFCloseSet = new Set<string>();
        if((!closeWAMap.isEmpty()) && closeWAMap.size() > 0)
        waWRFCloseSet = closeWAMap.keyset();
        
        String queryStr =''; 
        if((!closeWrfSet.isEmpty()) && closeWrfSet.size() > 0)
        {
            //Updating WRF Status and Action Taken
            for(Case eachCase : [Select id, status,IT_Action_Taken__c from case where Account.omx_primary_key__c in :waWRFCloseSet])
            {
            eachCase.status='Closed';
            eachCase.IT_Action_Taken__c = 'Cancelled';
            updatedCases.add(eachCase);
            }
        }
        
        if(((!waWRFCloseSet.isEmpty()) && waWRFCloseSet.size() > 0) && ((!ctWRFCloseSet.isEmpty()) && ctWRFCloseSet.size() > 0))
        queryStr =queryStr+'Select id,Related_WRF_Case__c,Review_Start_Date__c,status__c from Customer_Transition__c where Written_Agreement_Customer_No__c in :waWRFCloseSet or id in :ctWRFCloseSet';
        else if((!waWRFCloseSet.isEmpty()) && waWRFCloseSet.size() > 0)
        queryStr =queryStr+'Select id,Related_WRF_Case__c,Review_Start_Date__c,status__c from Customer_Transition__c where Written_Agreement_Customer_No__c in :waWRFCloseSet';
        else if((!ctWRFCloseSet.isEmpty()) && ctWRFCloseSet.size() > 0)
        queryStr =queryStr+'Select id,Related_WRF_Case__c,Review_Start_Date__c,status__c from Customer_Transition__c where id in :ctWRFCloseSet';
        system.debug(queryStr);
        if(queryStr != null && queryStr != '')
        {
        tempCTlist  = Database.query(queryStr);
        }
        if((!tempCTlist.isEmpty()) && tempCTlist.size() > 0)
        {
            //Updating CT record's Review Start Date, WRF Number and Status
            for(Customer_Transition__c eachCT : tempCTlist)
            {
            eachCT.status__c='Unscheduled';
            eachCT.Review_Start_Date__c=null;
            eachCT.Related_WRF_Case__c=null;

            updatedCTCloseWRF.add(eachCT);
            }
        }
        
        if((!updatedCTCloseWRF.isEmpty()) && updatedCTCloseWRF.size() > 0)
            update updatedCTCloseWRF;
            
        if((!updatedCases.isEmpty()) && updatedCases.size() > 0)
            update updatedCases;
    }
    
}