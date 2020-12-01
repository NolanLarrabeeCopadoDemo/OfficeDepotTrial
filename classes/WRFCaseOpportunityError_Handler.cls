Public Class WRFCaseOpportunityError_Handler
{
    Public Static void getWRFCaseRecords(List<Case> NewCases,Map<Id,Case> OldCases)
    {
        Map<String,Schema.RecordTypeInfo> CaseRecType = Schema.SObjectType.Case.getRecordTypeInfosByName();
        id WRFRecordTypeId = CaseRecType.get('Work Request').getRecordTypeId(); 
        Map<String,Integer> mOppIds=New Map<String,Integer>();
        
        for(Case C:NewCases)
        {
            if(C.WRF_Opportunity__c!=Null && 
               C.RecordTypeId==WRFRecordTypeId &&
               C.WRF_Opportunity__c<>oldCases.get(C.Id).WRF_Opportunity__c)
                mOppIds.Put(C.WRF_Opportunity__c,0);
        }
        
       if(!mOppIds.isEmpty()) 
       {
           AggregateResult[]  AgrList= [SELECT Count(Id) C,WRF_Opportunity__c Opp
                                              FROM Case 
                                              WHERE RecordTypeId=:WRFRecordTypeId 
                                              AND WRF_Opportunity__c=: mOppIds.keyset() 
                                              GROUP BY WRF_Opportunity__c ];
           if(!AgrList.isEmpty()) 
           {                                  
                for (AggregateResult ar :AgrList )  
                {
                     mOppIds.Put(String.valueof(ar.get('Opp')),Integer.valueof(ar.get('C')));
                }  
                
                for(Case C:NewCases)
                {
                    if(C.WRF_Opportunity__c!=Null && 
                       C.RecordTypeId==WRFRecordTypeId &&
                       mOppIds.get(c.WRF_Opportunity__c)>0 )
                       {    
                               c.WRF_Opportunity__c.addError('Work Request already exists for this Opportunity');
        
                       }
                 }   
            }             
      }
    }
}