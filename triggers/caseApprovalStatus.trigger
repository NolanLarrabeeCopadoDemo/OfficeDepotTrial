// Trigger to Update Case approval based on CPM approval
// Modified  - S-401328- commented code body to remove inactive trigger from coverage class
trigger caseApprovalStatus on CPM__c (after insert, after update) 
{
 
         /* Set<ID> casesIds = new Set<ID>();
            for(CPM__c wtsk : (List<CPM__c>)Trigger.new)
            {
            casesIds.add(wtsk.support_number__c);
            }
            
           List<Case> casesList = [Select id,Approval_Status__c  from case where id in :casesIds];
           List<Case> updatedcasesList = new List<Case>();
           List<cpm__c> cpms=[SELECT support_number__c,id,name,Scenario__c , Version__c,Approval_Status__c FROM cpm__c where support_number__c in :casesIds order by version__c desc];          
           Map<id,List<cpm__c>> cpmCases = new Map<id,List<cpm__c>> ();
           
           if(!(cpms.isEmpty()))
           {
               for(cpm__c eachCpm: cpms)
               {
               List<cpm__c> cpmList= new List<cpm__c>();
               cpmList.add(eachCpm);
                if (cpmCases.containsKey(eachCpm.support_number__c)){
                cpmCases.get(eachCpm.support_number__c).add(eachCpm);
                }
                else{
                cpmCases.put(eachCpm.support_number__c,cpmList);
                }
               }
               
               for(Case eachCase: casesList)
               {
                List<cpm__c> eachCpmList= cpmCases.get(eachCase.id);
                Map<String,String> updatedVersion = new Map<String,String>();
                
                    for(cpm__c eachCpm : eachCpmList)
                    {
                        if (updatedVersion.containsKey(String.valueOf(eachCpm.Scenario__c))){
                        List<String>status = updatedVersion.get(String.valueOf(eachCpm.Scenario__c)).split(' - ');
                        Integer ver=Integer.valueOf(status[0]);
                        if(eachCpm.Version__c > ver)
                        {
                        updatedVersion.put(String.valueOf(eachCpm.Scenario__c),eachCpm.Version__c+' - '+eachCpm.Approval_Status__c);
                        }
                        }
                        else
                        updatedVersion.put(String.valueOf(eachCpm.Scenario__c),eachCpm.Version__c+' - '+eachCpm.Approval_Status__c);
                    }
                    List<String>allStatus = updatedVersion.values();
                    Set<String> statusSet = new Set<String>();
                    String finalCaseStatus = '';
                      if(!(allStatus.isEmpty()))
                    {
                        for(String stat : allStatus)
                        {
                        List<String>stats = stat.split(' - ');
                        statusSet.add(stats[1]);
                        }
                        // To Update various status
                        if(statusSet.contains('Approved')&&(statusSet.size()==1))
                        finalCaseStatus = 'Approved';
                        if(statusSet.contains('Pending Approval') || statusSet.contains('') || statusSet.contains(null))
                        finalCaseStatus = 'Pending Approval';
                        if(statusSet.contains('Rejected'))
                        finalCaseStatus = 'Rejected';
                        
                        eachCase.Approval_Status__c = finalCaseStatus;
                        updatedcasesList.add(eachCase);
                        
                        
                    }
                }
                System.debug('Update Case Approval Status @@@@'+updatedcasesList);
                if(!(updatedcasesList.isEmpty()))
                update updatedcasesList;
            }*/
}