public class DMLTrigger_Handler {
    
    // This functionality is to make sure DML will not be allowed to change end Date if DML Relationship exits with valid end date
    Public Static void beforeupdate(list<DML__c> dmllist,  Map<id,DML__C> olddml)
    {
        Map<Id,Date> dmlmap = new Map<Id,Date>();
        Set<Id> dmlids = new Set<Id>();
        for (DML__c d :dmllist)
        {      
            if((olddml.get(d.Id).Effective_End_Date__c != d.Effective_End_Date__c)  && d.Effective_End_Date__c!=null)
            { 
                dmlmap.put(d.id,d.Effective_End_Date__c);
            }
        }
        // Get all existing Relationships for the DML which are active
        for(DML_Relation__c dr : [select id, Effective_End_Date__c,DML__C from DML_Relation__c where DML__c=:dmlmap.keyset()])
        {
            if(dr.Effective_End_Date__c > dmlmap.get(dr.dml__C)  ||  dr.Effective_End_Date__c==null )
            {
                dmlids.add(dr.dml__C);
            }
            
        }
        System.debug('dmlids'+dmlids);
        
        //Throw error if active  DML Relationship  exist
        for (DML__c d :dmllist)
        {
            if(dmlids.contains(d.id))  
            {
                d.adderror('Active DML relations exist');
            }
            
        }
        
    }
    
    public static void DMLHistoryPopulate(Map < Id, DML__C > NewMap, Map<Id,DML__C> oldMap )
    {
        List<DML_History__c> DMLHistoryInsertList= new List<DML_History__c>();
        List<DML__C> DMLList= new List<DML__C>();          
        for (String DrecStr: NewMap.keyset()) 
        {       
            System.debug('Forloop');
            if(NewMap.get(DrecStr).ProcessNew_Request__c == true)
            {                
                 System.debug('Ifloop');
                DML__C Drec = new DML__C();
                Drec.Id = NewMap.get(DrecStr).Id;
                if(NewMap.get(DrecStr).Proposed_DML_Sales_Rep_ID__c!=null)
                    Drec.Decision_Maker_Rep__c=NewMap.get(DrecStr).Proposed_DML_Sales_Rep_ID__c;
                if(NewMap.get(DrecStr).Proposed_DML_Teaming_Rep_ID__c!=null)
                    Drec.DML_Teaming_Sales_ID__c=NewMap.get(DrecStr).Proposed_DML_Teaming_Rep_ID__c;
                if(NewMap.get(DrecStr).Proposed_Segment__c!=null)
                    Drec.DECISION_MAKER_SEGMENT__c=NewMap.get(DrecStr).Proposed_Segment__c;
                if(NewMap.get(DrecStr).Proposed_Effective_Start_Date__c!=null)
                    Drec.Effective_Start_Date__c=NewMap.get(DrecStr).Proposed_Effective_Start_Date__c;
                Drec.ProcessNew_Request__c=false;
                Drec.Proposed_DML_Sales_Rep_ID__c=null;
                Drec.Proposed_DML_Teaming_Rep_ID__c=null;
                Drec.Proposed_Segment__c=null;
                Drec.Proposed_Effective_Start_Date__c=null;
                DMLList.add(Drec);
                DML_History__c DHistoryRec = new DML_History__c();
                DHistoryRec.DML__c= oldMap.get(Drec.id).id;
                DHistoryRec.Decision_Maker_Rep__c=oldMap.get(Drec.id).Decision_Maker_Rep__c;
                DHistoryRec.DML_Segment_Description__c=oldMap.get(Drec.id).DECISION_MAKER_SEGMENT__c;
                DHistoryRec.DML_Teaming_Sales_ID__c=oldMap.get(Drec.id).DML_Teaming_Sales_ID__c;
                DHistoryRec.Effective_End_Date__c=oldMap.get(Drec.id).Effective_End_Date__c;
                DHistoryRec.Effective_Start_Date__c=oldMap.get(Drec.id).Effective_Start_Date__c;            
                DMLHistoryInsertList.add(DHistoryRec);
            }
        }
        if(DMLList.size()>0)
            update DMLList;
        if(DMLHistoryInsertList.size()>0)
            insert DMLHistoryInsertList;    
    }  
    
}