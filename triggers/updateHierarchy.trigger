// update Hierachy of the customer transition 
trigger updateHierarchy on Customer_Transition__c (before update) {
List<Id> parentId= new List<Id>();
//start of 00703602 
Map<Id,Customer_Transition__c > parentMap= new  Map<Id,Customer_Transition__c >();
// end of  00703602  

   for( Customer_Transition__c cust: Trigger.new){
   
           //start of 00703602 
       if( cust.Written_Agreement__c!=Trigger.oldmap.get(cust.Id).Written_Agreement__c   && cust.Written_Agreement__c==true)
       {
           if(cust.Parent_Transition_ID__c!=null){
                       parentId.add(cust.Parent_ID__c);

           }
       }
      // end of  00703602  
   
   if( cust.updateHierachy__c==true ){
   //System.debug('&&&&&&&&&&&&&&&Inside');
            if(cust.Parent_ID__c!=null)
            parentId.add(cust.Parent_ID__c);
    } 
    // WRF to NULL when status Changing from Scheduled/ReScheduled to UnScheduled
    if( cust.Review_Start_Date__c == null && Trigger.oldmap.get(cust.ID).Review_Start_Date__c != null 
        && cust.Ready_for_Mod1__c != true && cust.status__c == 'UnScheduled'){
        cust.Related_WRF_Case__c = null;
    }  
    
    // Status to Scheduled when review start date is updated to a date from null
    if( cust.Review_Start_Date__c != null && Trigger.oldmap.get(cust.ID).Review_Start_Date__c == null 
        && cust.Ready_for_Mod1__c != true){
        cust.status__c = 'Scheduled';
        // WRF to NULL when status Changing from UnScheduled to Scheduled
        cust.Related_WRF_Case__c = null;
    }  
    // Status to ReScheduled when review start date is changed from a date to another date
    if( cust.Review_Start_Date__c != null && Trigger.oldmap.get(cust.ID).Review_Start_Date__c != cust.Review_Start_Date__c 
        && cust.Ready_for_Mod1__c != true && Trigger.oldmap.get(cust.ID).Review_Start_Date__c != null && Trigger.oldmap.get(cust.ID).status__c == 'Scheduled'){
        cust.status__c = 'ReScheduled';
        // WRF to NULL when status Changing from Scheduled to ReScheduled
        cust.Related_WRF_Case__c = null;
    } 
    // WRF to NULL when status Changing from ReScheduled to ReScheduled
    if( cust.Review_Start_Date__c != null && Trigger.oldmap.get(cust.ID).Review_Start_Date__c != cust.Review_Start_Date__c 
        && cust.Ready_for_Mod1__c != true && Trigger.oldmap.get(cust.ID).Review_Start_Date__c != null && Trigger.oldmap.get(cust.ID).status__c == 'ReScheduled'){
        cust.status__c = 'ReScheduled';
        // WRF to NULL when status Changing from ReScheduled to ReScheduled
        cust.Related_WRF_Case__c = null;
    }   
   
   }
  Map<Id,Id> custMap= new  Map<Id,Id>();
  //system.debug('@@parentId'+parentId);
  
   //start of 00703602 
   try{
   // get the transition record of new parent
           if(parentId.size()>0){
           List<Customer_Transition__c > parentRecord= [ Select Id,Account__c  ,Written_Agreement__c    ,Written_Agreement_ID__c,
           Written_Agreement_Customer_No__c,omx_primary_key__C
           from Customer_Transition__c  where Account__c  in:parentId ];
          // system.debug('@@@parentrecord'+parentRecord);
                 for( integer i=0;i<parentRecord.size();i++) {  
                 custMap.put(parentRecord[i].Account__c  , parentRecord[i].Id);
                 parentMap.put(parentRecord[i].Id  , parentRecord[i]);
                 }
           }
       }
   catch(Exception e){}
   
   // end of 00703602 
   
 for( Customer_Transition__c cust: Trigger.new){
   if(  cust.updateHierachy__c==true ){    
     //system.debug('Inside loop1'); 
     
     if(cust.Parent_ID__c!=null){
              if(custMap.containsKey(cust.Parent_ID__c)) {
               ///system.debug('Inside loop2');
              cust.Parent_Transition_ID__c= custMap.get(cust.Parent_ID__c);}
              else
              cust.Parent_Transition_ID__c= null;
     }                      
     else{
      cust.Parent_Transition_ID__c= null;
     }  
      cust.updateHierachy__c=false;                     
    } 

   // Getting the customer response audited
   if(cust.Customer_Response__c != Trigger.oldMap.get(cust.Id).Customer_Response__c ){
   String firstname =' ';
   if(UserInfo.getFirstName()!=null)
   firstname=UserInfo.getFirstName();
   
       if(Trigger.oldMap.get(cust.Id).Customer_Response__c == null)
        cust.Customer_Response_TextArea__c = cust.Customer_Response__c+'-'+firstname+' '+UserInfo.getLastName()+'-'+cust.lastmodifieddate.format();
       else
        cust.Customer_Response_TextArea__c = 
        cust.Customer_Response__c+'-'+firstname+' '+UserInfo.getLastName()+'-'+cust.lastmodifieddate.format()+
        ' \r\n' + Trigger.oldMap.get(cust.Id).Customer_Response_TextArea__c;

    }
    
        //start of 00703602 
    if( cust.Written_Agreement__c!=Trigger.oldmap.get(cust.Id).Written_Agreement__c   && cust.Written_Agreement__c==true)
    {
           if(cust.Parent_Transition_ID__c!=null  &&  parentmap.get( cust.Parent_Transition_ID__c).Written_Agreement__c==true){
              if(parentmap.get( cust.Parent_Transition_ID__c).Written_Agreement_ID__c!=null)
               cust.Written_Agreement_ID__c=  parentmap.get( cust.Parent_Transition_ID__c).Written_Agreement_ID__c;  
               else
               cust.Written_Agreement_ID__c=  parentmap.get( cust.Parent_Transition_ID__c).Id;         
           }
    }
      if( cust.Written_Agreement__c!=Trigger.oldmap.get(cust.Id).Written_Agreement__c   && cust.Written_Agreement__c==false)
    {
               cust.Written_Agreement_ID__c=  null;         
           
    }    
    //end of 00703602 
    
    
    //start of 00659767
    if( cust.Parent_Transition_ID__c!=Trigger.oldmap.get(cust.Id).Parent_Transition_ID__c)
    {
    
    // if new Parent transition is blank    
        if (cust.Parent_Transition_ID__c == null) {
            cust.Written_Agreement_ID__c = null;
            cust.Written_Agreement__c = false;
            cust.ODS_WA_EXECUTED__c = false; // Field add for Production Support #01063234
         }
         else if (parentmap.get(cust.Parent_Transition_ID__c) != null) {
             // If the new parent is not a written agreement customer
            if (parentmap.get(cust.Parent_Transition_ID__c).Written_Agreement_Customer_No__c == null) {
                cust.Written_Agreement__c = false;
                cust.Written_Agreement_ID__c = null;            
            }
            // if New parent is written highest level 
            else if (parentmap.get(cust.Parent_Transition_ID__c).Written_Agreement_Customer_No__c != null && 
                (parentmap.get(cust.Parent_Transition_ID__c).Written_Agreement_Customer_No__c == parentmap.get(cust.Parent_Transition_ID__c).omx_primary_key__C)) {
                cust.Written_Agreement__c = true;
                cust.Written_Agreement_ID__c = cust.Parent_Transition_ID__c;
            }
            // if New parent is not a written highest level       
            else if (parentmap.get(cust.Parent_Transition_ID__c).Written_Agreement_Customer_No__c !=null && 
                (parentmap.get(cust.Parent_Transition_ID__c).Written_Agreement_Customer_No__c != parentmap.get(cust.Parent_Transition_ID__c).omx_primary_key__C)) {
                cust.Written_Agreement__c = true;
                cust.Written_Agreement_ID__c = parentmap.get(cust.Parent_Transition_ID__c).Written_Agreement_ID__c;
            }
         }
    }
    // end of  00659767
   }
}