/*
Created By: Sunil Bansal
Created Date: 17-Aug-2012
Created reason: case # 6542 ( To fix the 'Pratially Processed' records flipping Account Wonership)

Modified By: Sunil Bansal
Modified Date: 30-Aug-2012
Modify Reason: Changed query as per suggestion, comparing Ids instead of Created Date

***  Test coverage of this will be covered by AccountAssignments_Batch_TC class ***
Modified - NBOCK - 12.4.2015 - S-366881: commented out code so inactive trigger doesn't count against code coverage
*/
trigger AccountAssignments_Insert on AccountAssignments__c (after insert) 
{       
      /*  Set<String> aaccIds = new Set<String>();
        Set<String> saccIds = new Set<String>();
        Set<String> entityIds = new Set<String>();
        Set<Id> assignmentIds = new Set<Id>();
        Map<Id,String> trimvals= new map<Id,String>();
        for(AccountAssignments__c ata : Trigger.New)
        {
            String eid=  ata.Entity_Id__c;
             System.debug('>>>>>before removing leading zeros>>>'+eid);
             boolean zeroflag =false;
            while(eid.startsWith('0'))
             { 
                 eid = eid.substring(1);
                zeroflag =true;
             }  
             System.debug('>>>>>After removing leading zeros>>>'+eid);
            if( zeroflag )
            {
                trimvals.put(ata.Id,eid );
            }
                          
            assignmentIds.add(ata.Id);
               if((ata.AccountType__c=='A') )
                   aaccIds.add(ata.Accountid__c);
                else
                    saccIds.add(ata.Accountid__c);
            entityIds.add(eid); 
        }
        
        //List<AccountAssignments__c> assignments_List = [Select Id, Entity_Id__c from AccountAssignments__c where Entity_Id__c IN :entityIds and Status__c != 'Open' and IsDeleted = false and CreatedDate < today];
        List<AccountAssignments__c> aassignments_List = [Select Id, Entity_Id__c from AccountAssignments__c where Entity_Id__c IN :entityIds and Accountid__c IN :aaccIds and AccountType__c = 'A' and Status__c != 'Processed' and IsDeleted = false and Id NOT IN :assignmentIds];
        List<AccountAssignments__c> sassignments_List = [Select Id, Entity_Id__c from AccountAssignments__c where Entity_Id__c IN :entityIds and Accountid__c IN :saccIds and AccountType__c = 'S' and Status__c != 'Processed' and IsDeleted = false and Id NOT IN :assignmentIds];
        List<AccountAssignments__c> trimassign_List = [Select Id from AccountAssignments__c where  Id IN :trimvals.keySet()];
        //and Status__c != 'Open'
        for(AccountAssignments__c updateAssignment: aassignments_List )
        {
            updateAssignment.Status__c = 'Processed';
                        
        }
          for(AccountAssignments__c updateAssignment: sassignments_List )
        {
            updateAssignment.Status__c = 'Processed';
                        
        }
               for(AccountAssignments__c updateAssignment: trimassign_List )
        {
            updateAssignment.Entity_Id__c = trimvals.get(updateAssignment.Id);
                        
        }
   
        if(aassignments_List.size()>0)
        update aassignments_List;
        if(sassignments_List.size()>0)
        update sassignments_List;
        if(trimassign_List.size()>0)
        update trimassign_List ;
*/
}