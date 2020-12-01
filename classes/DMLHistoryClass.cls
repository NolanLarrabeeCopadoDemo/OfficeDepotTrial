public class DMLHistoryClass {
    // update the start dates and end dates logic Method
  public static void updateDates( List <DML_History__c> recList){
  Set<Id>  DMLId= new Set<Id>();
  Map<Id, Date> mapRec=  new Map<Id, Date>();
  Map<Id, Date> mapRecEnd=  new Map<Id, Date>();

  List<DML_History__c> oldRecords = new List<DML_History__c>();

  // get all DML records
     for( DML_History__c  rec :recList){
        if(rec.DML__c!=null)
        DMLId.add(rec.DML__c);
     }
     if(DMLId.size()>0){
     oldRecords=[select Id, Effective_Start_Date__c, Effective_end_Date__c,DML__c  from DML_History__c
     where DML__c in :DMLId];
     
     
     // get start dates
     List<DML__c> dmlList=[select Id,Effective_Start_Date__c,Effective_end_Date__c from DML__c where
     Id in :DMLId];
        for( DML__c recNew:  dmlList){
        mapRec.put(recNew.Id, recNew.Effective_Start_Date__c);
        mapRecEnd.put(recNew.Id, recNew.Effective_end_Date__c);

        }
        
     
       if(mapRec.size()>0){
       
                   //processing current Inserted record
                     for( DML_History__c  rec :recList){
                                if( rec.Effective_end_Date__c==null  &&  mapRecEnd.get(rec.DML__c)==null)
                                rec.Effective_end_Date__c=System.today();
                                
                                if(rec.DML__c!=null){
                                  if(rec.Effective_Start_Date__c  >  mapRec.get(rec.DML__c)){
                                  rec.Effective_end_Date__c = rec.Effective_Start_Date__c ;
                                  }
                                  if( rec.Effective_end_Date__c>mapRec.get(rec.DML__c)  && rec.Effective_Start_Date__c <mapRec.get(rec.DML__c))
                                  rec.Effective_end_Date__c=mapRec.get(rec.DML__c);
                                }

                      }

       
                   
                     //processing old Inserted record
                     for( DML_History__c  rec :oldRecords){
                                if(rec.DML__c!=null){
                                  if(rec.Effective_Start_Date__c  >  mapRec.get(rec.DML__c)){
                                  rec.Effective_end_Date__c = rec.Effective_Start_Date__c ;
                                  }
                                  if( rec.Effective_end_Date__c>mapRec.get(rec.DML__c)  && rec.Effective_Start_Date__c <mapRec.get(rec.DML__c))
                                  rec.Effective_end_Date__c=mapRec.get(rec.DML__c);
                                }

                      }
                      if(oldRecords.size()>0)
                      update oldRecords;
       
       }
     }
  }

}