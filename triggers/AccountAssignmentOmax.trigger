trigger AccountAssignmentOmax on AccountAssignments__c (after Insert) {
    Set<String> aaccIds = new Set<String>();
    Set<String> saccIds = new Set<String>(); 
    Set<String> entityIds = new Set<String>();
    Set<Id> assignmentIds = new Set<Id>();
    Set<Id> assignmentIds_toDelete = new Set<Id>();
    List<AccountAssignments__c>ODAccountAssignmentLst = new List<AccountAssignments__c>();
    List<AccountAssignments__c>OMXAccountAssignmentLst = new List<AccountAssignments__c>();
    Map<String,Schema.RecordTypeInfo> assignmentrecordtype = Schema.SObjectType.AccountAssignments__c.getRecordTypeInfosByName();
    Id OMXRecId = [Select Id,name from recordType where Name ='officemax'].Id;
    Id ODRecId = [Select Id,name from recordType where Name ='OfficeDepot'].Id;

    /* Added for Primary Site Assignment */
    Set<String> overlayRepids = new Set<String>();
    Set<String> omxAcctids = new Set<String>();
    Map<String,User> overlayMap = new map<String,User>();
    Map<String,Sales_Person__c> overlaySrep = new map<String,Sales_Person__c>();  
    Map<String,AccountAssignments__c> relatedAcctAsgnmnt = new map<String,AccountAssignments__c>();  
    /* End OMX Primary Site Assignment Variables */
    
    System.Debug('Start OMX Account Assignment trigger');

    for(AccountAssignments__c aa: Trigger.new){
        if(aa.RecordTypeId == OMXRecId ) {
            OMXAccountAssignmentLst.add(aa);
            // Add OMX Customer Assignments only for primary site assignment
            if((aa.AccountType__c == 'A')) {
                relatedAcctAsgnmnt.put(aa.AccountId__c, aa);
                omxAcctids.add(aa.AccountId__c);
                // Add the primary Rep to the rep list
                if((aa.PrimaryEmpId__c != null) &&
                   (aa.PrimaryEmpId__c != '')
                  )
                {
                    overlayRepids.add(aa.PrimaryEmpId__c);
                }
                // Add overlay Reps to the rep list
                for(Integer i =1;i<=30;i++)
                {                            
                    String OverlayEMPID = 'OverlayEmpID'+i+'__c';
                    if((aa.get(OverlayEMPID) != null) &&
                       (aa.get(OverlayEMPID) != '')
                      )
                    {
                        overlayRepids.add(String.valueOf(aa.get(OverlayEMPID)));
                    } 
                }                
            } 
        }  
        
        // Add OD accounts to the list      
        if(aa.RecordTypeId == ODRecId )
            ODAccountAssignmentLst.add(aa);    
    }
    
    // Prepare Primary OMX site assignment user map
    System.Debug('Overlay User List : ' + overlayRepids.Size());
    if (overlayRepids.Size() > 0) {
        // Populate Overlay User Map
        for (User ouser : [Select id, Short_Title__c, OMX_Rep_Number__c from User Where OMX_Rep_Number__c in :overlayRepids and isactive = true]) {
            overlayMap.put(ouser.OMX_Rep_Number__c, ouser);
        }
        // Populate Overlay Primary Sales Person Map
        for (Sales_Person__c srep : [Select Id, ExtIDSalesPerson__c, OMX_Rep_ID__c, Primary__c, IsActive__c from Sales_Person__c Where OMX_Rep_ID__c in :overlayRepids and IsActive__c = true and Primary__c = true]) {
            overlaySrep.put(srep.OMX_Rep_ID__c, srep);
        }
        
    }

    
    // Get All the primary sites for OMX customers    
    List<Account>omxPrimarySiteLst = new List<Account>([Select id, name, ownerId, OMX_Mainframe_Consignee_ID__c, Sales_PersonID__c, OMX_Mainframe_Account_Number__c From Account Where Related_Account__r.omx_primary_key__c IN :omxAcctids and primary_site__c = true and OMX_Mainframe_Consignee_ID__c = 'OMX001']);
    List<Account>updOmxPrimarySiteLst = new List<Account>();
    
    for(Account ps : omxPrimarySiteLst) {
        // Get the related account assignment
        AccountAssignments__c rasgnmnt = relatedAcctAsgnmnt.get(ps.OMX_Mainframe_Account_Number__c); 
        User pa;
        Sales_Person__c sp;
        Boolean ownerFound = false;
        // Check the roles for overlay assignments
        if((rasgnmnt.PrimaryEmpId__c != null) && (rasgnmnt.PrimaryEmpId__c != '')) { 
            pa = overlayMap.get(rasgnmnt.PrimaryEmpId__c);
            //System.Debug('primary User Short Title : ' + pa.short_Title__c);
            if (pa != null) {
              if ((pa.short_Title__c != null) && (pa.short_Title__c != '')) {
                if(pa.short_Title__c.contains('BDM')) {
                    //System.Debug('primary User Short Title contains BDM : ' + pa.short_Title__c);
                    ps.ownerId = pa.Id;
                    // Get the corresponding Primary salesrep
                    sp = overlaySrep.get(rasgnmnt.PrimaryEmpId__c);
                    if(sp != null) {
                        ps.Sales_PersonID__c = sp.Id;
                    }
                    updOmxPrimarySiteLst.add(ps);
                    ownerFound = true;     
                }
                else {
                    ownerFound = false;
                }
              }
            }        
        }                
        if (!ownerFound) {
            for(Integer i =1;i<=30;i++)
            {                            
                String OverlayEMPID = 'OverlayEmpID'+i+'__c';
                if((rasgnmnt.get(OverlayEMPID) != null) &&
                   (rasgnmnt.get(OverlayEMPID) != '')                        
                  )
                {                    
                    pa = overlayMap.get(String.valueOf(rasgnmnt.get(OverlayEMPID)));                        
                    if (pa != null) {
                      if ((pa.short_Title__c != null) && (pa.short_Title__c != '')) {
                        if(pa.short_Title__c.contains('BDM')) {
                            ps.ownerId = pa.Id;
                            // Get the corresponding Primary salesrep
                            sp = overlaySrep.get(String.valueOf(rasgnmnt.get(OverlayEMPID)));
                            if(sp != null) {
                                ps.Sales_PersonID__c = sp.Id;
                            }                            
                            updOmxPrimarySiteLst.add(ps);
                            break;     
                        }                        
                    }
                  }
                } 
            }                                                     
        }     
                
    }
    
    //System.Debug('Update List Size : ' + updOmxPrimarySiteLst.size());
    //System.Debug('Update List Size : ' + updOmxPrimarySiteLst);
    // Finally Update the Primary Site Owners
   
    if(updOmxPrimarySiteLst.size() > 0)
        update updOmxPrimarySiteLst;        
    
    Map<Id,String> trimvals= new map<Id,String>();
    for(AccountAssignments__c ata : ODAccountAssignmentLst){
        
        String eid=  ata.Entity_Id__c;            
        boolean zeroflag =false;
         if(ata.recordTypeId == assignmentrecordtype.get('OfficeDepot').getRecordTypeId() && ata.Entity_Type__c != 'ODN Customer')
         {
            System.Debug('Removing zeros');
            while(eid.startsWith('0')){ 
                eid = eid.substring(1);
                zeroflag = true;
            } 
         }             
        if(zeroflag ){
           trimvals.put(ata.Id,eid );
        }
        assignmentIds.add(ata.Id);
        if((ata.AccountType__c=='A') )
           aaccIds.add(ata.Accountid__c);
        else
           saccIds.add(ata.Accountid__c);
           entityIds.add(eid); 

    }
    
   //Code commented to remove trigger functionality for OD Assignments
   /* AccountPrimaryOwnerUpdate up = new AccountPrimaryOwnerUpdate(); 
    up.UpdatePrimary(assignmentIds);*/
    
    /* Adding the OMX Account Assignment records here to avoid Primary Owner Assignment */
    
    for(AccountAssignments__c ata : OMXAccountAssignmentLst){
        
        String eid=  ata.Entity_Id__c;            
        trimvals.put(ata.Id,eid );        
        assignmentIds.add(ata.Id);
        if((ata.AccountType__c=='A') )
           aaccIds.add(ata.Accountid__c);
        else
           saccIds.add(ata.Accountid__c);
           entityIds.add(eid); 

    }
    /* Adding ends here*/
    System.Debug('Assign Ids'+AssignmentIds);
    //List<AccountAssignments__c> aassignments_List = [Select Id, Entity_Id__c from AccountAssignments__c where Entity_Id__c IN :entityIds and Accountid__c IN :aaccIds and AccountType__c = 'A' and Status__c != 'Processed' and IsDeleted = false and Id NOT IN :assignmentIds];
    //List<AccountAssignments__c> sassignments_List = [Select Id, Entity_Id__c from AccountAssignments__c where Entity_Id__c IN :entityIds and Accountid__c IN :saccIds and AccountType__c = 'S' and Status__c != 'Processed' and IsDeleted = false and Id NOT IN :assignmentIds];
    //Changes made to the above line to below line to avoid the skip when the entity Id changes from Oracle Id to AOPS ID's
    
    //Code commented to remove trigger functionality for OD Assignments
    /*List<AccountAssignments__c> aassignments_List = [Select Id, Entity_Id__c from AccountAssignments__c where  Accountid__c IN :aaccIds and AccountType__c = 'A'  and IsDeleted = false and Id NOT IN :assignmentIds];
    List<AccountAssignments__c> sassignments_List = [Select Id, Entity_Id__c from AccountAssignments__c where  Accountid__c IN :saccIds and AccountType__c = 'S'  and IsDeleted = false and Id NOT IN :assignmentIds];*/
    
    List<AccountAssignments__c> trimassign_List = [Select Id from AccountAssignments__c where  Id IN :trimvals.keySet()];      
    for(AccountAssignments__c updateAssignment: trimassign_List ){
        updateAssignment.Entity_Id__c = trimvals.get(updateAssignment.Id);               
    }
   //Deleting the List Because we have a New entry in the today's List
   
    //Code commented to remove trigger functionality for OD Assignments
    /*if(aassignments_List.size()>0){
        for(AccountAssignments__c a :aassignments_List){
            assignmentIds_toDelete.add(a.id); 
        }
    }
        //delete aassignments_List;
    if(sassignments_List.size()>0){
        for(AccountAssignments__c b :sassignments_List){
            assignmentIds_toDelete.add(b.id); 
            System.Debug('deleting list'+assignmentIds_toDelete );
        }
    }
    System.debug('TO BE DELETED:::'+assignmentIds_toDelete);
    if(assignmentIds_toDelete.size()>0){
         List<AccountAssignments__c> dlist = [Select Id from AccountAssignments__c where id In :assignmentIds_toDelete ];
         System.debug('TO BE DELETED22222:::'+dlist);
         delete dlist ;
    }*/
     //END Deleting the List Because we have a New entry in the today's List
    
    // delete sassignments_List;
    if(trimassign_List.size()>0)
         Database.update(trimassign_List,false);

    //As per Prod Fix # 00414868 -- No longer required with new Synygy Optymyze (2/19/2016)
   /* list<AccountAssignments__c> primaryassign = new list<AccountAssignments__c>();
     List<AccountAssignments__c> ATs = new List<AccountAssignments__c>();
         for(AccountAssignments__c aa: Trigger.new){
            system.debug('recrdtype>>>>>'+aa.Account__c);
            if(aa.entity_id__c.contains('OMX001'))
                primaryassign.add(aa);
        }
        if(primaryassign.size()>0)
           ATs = Accountassignmnet_primaryclass.cloneupsert(primaryassign);
        
        system.debug('<<<class return>>>>'+ATs);
        Database.upsert(ATs,Schema.AccountAssignments__c.AccountId__c,false);
  */
}