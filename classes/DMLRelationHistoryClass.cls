public Class DMLRelationHistoryClass{

// update the start dates and end dates logic Method
  public static void updateDates( List <DML_Relation_History__c> recList){
  Set<Id>  DMLId= new Set<Id>();
  Map<Id, Date> mapRec=  new Map<Id, Date>();
  Map<Id, Date> mapRecEnd=  new Map<Id, Date>();

  List<DML_Relation_History__c> oldRecords = new List<DML_Relation_History__c>();

  // get all Relation records
     for( DML_Relation_History__c  rec :recList){
        if(rec.DML_Relationship__c!=null)
        DMLId.add(rec.DML_Relationship__c);
     }
     if(DMLId.size()>0){
     oldRecords=[select Id, Effective_Start_Date__c, Effective_end_Date__c,DML_Relationship__c  from DML_Relation_History__c
     where DML_Relationship__c in :DMLId];
     
     
     // get start dates
     List<DML_Relation__c> relationList=[select Id,Effective_Start_Date__c,Effective_end_Date__c from DML_Relation__c where
     Id in :DMLId];
        for( DML_Relation__c recNew:  relationList){
        mapRec.put(recNew.Id, recNew.Effective_Start_Date__c);
        mapRecEnd.put(recNew.Id, recNew.Effective_end_Date__c);

        }
        
     
       if(mapRec.size()>0){
       
                   //processing current Inserted record
                     for( DML_Relation_History__c  rec :recList){
                                if( rec.Effective_end_Date__c==null  &&  mapRecEnd.get(rec.DML_Relationship__c)==null)
                                rec.Effective_end_Date__c=System.today();
                                
                                if(rec.DML_Relationship__c!=null){
                                  if(rec.Effective_Start_Date__c  >  mapRec.get(rec.DML_Relationship__c)){
                                  rec.Effective_end_Date__c = rec.Effective_Start_Date__c ;
                                  }
                                  if( rec.Effective_end_Date__c>mapRec.get(rec.DML_Relationship__c)  && rec.Effective_Start_Date__c <mapRec.get(rec.DML_Relationship__c))
                                  rec.Effective_end_Date__c=mapRec.get(rec.DML_Relationship__c);
                                }

                      }

       
                   
                     //processing old Inserted record
                     for( DML_Relation_History__c  rec :oldRecords){
                                if(rec.DML_Relationship__c!=null){
                                  if(rec.Effective_Start_Date__c  >  mapRec.get(rec.DML_Relationship__c)){
                                  rec.Effective_end_Date__c = rec.Effective_Start_Date__c ;
                                  }
                                  if( rec.Effective_end_Date__c>mapRec.get(rec.DML_Relationship__c)  && rec.Effective_Start_Date__c <mapRec.get(rec.DML_Relationship__c))
                                  rec.Effective_end_Date__c=mapRec.get(rec.DML_Relationship__c);
                                }

                      }
                      if(oldRecords.size()>0)
                      update oldRecords;
       
       }
     }
  }
}