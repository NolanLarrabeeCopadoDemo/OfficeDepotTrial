trigger AccountAssignmentBeforeTrigger on AccountAssignments__c (before Insert, before Update)
{ 
//Prevent the record update if there is no change in overlay
Id currentUser=UserInfo.getUserId();

List<AccountAssignments__c > assignList= new List<AccountAssignments__c >();

// Logic to load account extension records
Set<String> accSet = new Set<String>();
       Map<String,Account_Extension__c> accMap = new Map<String,Account_Extension__c>();
       Map<String,Account_Extension__c> accMapCust = new Map<String,Account_Extension__c>();
       Map<String,Account_Extension__c> accMapOMX = new Map<String,Account_Extension__c>();


for(AccountAssignments__c rec:Trigger.New){
if(  (Trigger.IsInsert )  ||
(Trigger.IsUpdate &&  rec.Account_Extension__C==null)  ){
                if(rec.Entity_Id__c!=null  && rec.RecordTypeId ==Label.Office_depot_Record_Type)
                accSet.add(rec.Entity_Id__c);
}
}

if( accSet.size()>0){
        for(Account_Extension__c acc : [select id,OMX_Primary_Key__c,AOPS_Seq_ID__c,AOPS_Cust_Id__c
         from Account_Extension__c where 
        ( AOPS_Seq_ID__c in :accSet  or  OMX_Primary_Key__c in :accSet  or  AOPS_Cust_Id__c  in  :accSet)  ])
            {
            if(acc.AOPS_Seq_ID__c!=null)
            accMap.put(acc.AOPS_Seq_ID__c,acc);
            else if(acc.OMX_Primary_Key__c!=null)
            accMapOMX.put(acc.OMX_Primary_Key__c,acc);
            else
            accMapCust.put(acc.OMX_Primary_Key__c,acc);
            }
                            system.debug('accMap'+accMap);
                            system.debug('accMapOMX'+accMapOMX);
                            system.debug('accMapCust'+accMapCust);


}


for(AccountAssignments__c rec:Trigger.New){
if(  (Trigger.IsInsert )  ||
(Trigger.IsUpdate &&  rec.Account_Extension__C==null)  ){
                if(rec.Entity_Id__c!=null &&  rec.RecordTypeId ==Label.Office_depot_Record_Type){
                        if(rec.Entity_Type__c == 'ODN Customer' && accMapOMX.containsKey(rec.Entity_Id__c) ){
                        rec.Account_Extension__C =   accMapOMX.get(rec.Entity_Id__c).Id; 
                        }
                        else if(rec.Entity_Type__c == 'ODS Customer' && accMap.containsKey(rec.Entity_Id__c) ){
                        rec.Account_Extension__C =   accMap.get(rec.Entity_Id__c).Id; 
                        }
                        else if(rec.Entity_Type__c == 'ODS Customer' && accMapCust.containsKey(rec.Entity_Id__c) ){
                        rec.Account_Extension__C =   accMapCust.get(rec.Entity_Id__c).Id; 
                        }


                }
}
}


if(Trigger.isUpdate){
for(AccountAssignments__c a:Trigger.New){
 if  (    (a.OverlayEmpID1__c== trigger.oldMap.get(a.id).OverlayEmpID1__c)  &&
  (a.OverlayEmpID2__c== trigger.oldMap.get(a.id).OverlayEmpID2__c)   &&
    (a.OverlayEmpID3__c== trigger.oldMap.get(a.id).OverlayEmpID3__c)  &&
        (a.OverlayEmpID4__c== trigger.oldMap.get(a.id).OverlayEmpID4__c)  &&
    (a.OverlayEmpID5__c== trigger.oldMap.get(a.id).OverlayEmpID5__c)  &&
    (a.OverlayEmpID6__c== trigger.oldMap.get(a.id).OverlayEmpID6__c)  &&
    (a.OverlayEmpID7__c== trigger.oldMap.get(a.id).OverlayEmpID7__c)  &&
    (a.OverlayEmpID8__c== trigger.oldMap.get(a.id).OverlayEmpID8__c)  &&
    (a.OverlayEmpID9__c== trigger.oldMap.get(a.id).OverlayEmpID9__c)  &&
    (a.OverlayEmpID10__c== trigger.oldMap.get(a.id).OverlayEmpID10__c)  &&
    (a.OverlayEmpID11__c== trigger.oldMap.get(a.id).OverlayEmpID11__c)  &&
    (a.OverlayEmpID12__c== trigger.oldMap.get(a.id).OverlayEmpID12__c)  &&
    (a.OverlayEmpID13__c== trigger.oldMap.get(a.id).OverlayEmpID13__c)  &&
    (a.OverlayEmpID14__c== trigger.oldMap.get(a.id).OverlayEmpID14__c)  &&
    (a.OverlayEmpID15__c== trigger.oldMap.get(a.id).OverlayEmpID15__c)  &&
    (a.OverlayEmpID16__c== trigger.oldMap.get(a.id).OverlayEmpID16__c)  &&
    (a.OverlayEmpID17__c== trigger.oldMap.get(a.id).OverlayEmpID17__c)  &&
    (a.OverlayEmpID18__c== trigger.oldMap.get(a.id).OverlayEmpID18__c)  &&
    (a.OverlayEmpID19__c== trigger.oldMap.get(a.id).OverlayEmpID19__c)  &&
    (a.OverlayEmpID20__c== trigger.oldMap.get(a.id).OverlayEmpID20__c)  &&
    (a.OverlayEmpID21__c== trigger.oldMap.get(a.id).OverlayEmpID21__c)  &&
    (a.OverlayEmpID22__c== trigger.oldMap.get(a.id).OverlayEmpID22__c)  &&
    (a.OverlayEmpID23__c== trigger.oldMap.get(a.id).OverlayEmpID23__c)  &&
    (a.OverlayEmpID24__c== trigger.oldMap.get(a.id).OverlayEmpID24__c)  &&
    (a.OverlayEmpID25__c== trigger.oldMap.get(a.id).OverlayEmpID25__c)  &&
    (a.OverlayEmpID26__c== trigger.oldMap.get(a.id).OverlayEmpID26__c)  &&
    (a.OverlayEmpID27__c== trigger.oldMap.get(a.id).OverlayEmpID27__c)  &&
    (a.OverlayEmpID28__c== trigger.oldMap.get(a.id).OverlayEmpID28__c)  &&
    (a.OverlayEmpID29__c== trigger.oldMap.get(a.id).OverlayEmpID29__c)  &&
    (a.OverlayEmpID30__c== trigger.oldMap.get(a.id).OverlayEmpID30__c)  &&
    (a.RecordTypeId ==Label.Office_depot_Record_Type)&&
    (currentuser==Label.Dataloader_Id_Trigger)

      )
 {
      System.debug('&&&&&&&inside if loop');
      a.adderror( 'There is no change in overlay assignments');
 }
 else{
     System.debug('&&&&&&&inside else  loop');
  AssignList.add(a);
 }
}

}

     System.debug('&&&&&&&AssignList'+AssignList.size());

//Class to update the Party sites Id's and create customer Record
   AccountAssignmentUpdatingSitesClass assign= new AccountAssignmentUpdatingSitesClass ();
   if(Trigger.isInsert){
   assign.updateAssignData(Trigger.New);
   }
   else{
   if(AssignList.size()>0  && currentuser==Label.Dataloader_Id_Trigger)
   assign.updateAssignData(AssignList);
   }
}