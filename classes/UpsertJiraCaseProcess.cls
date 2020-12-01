global  class UpsertJiraCaseProcess {
    
   @InvocableMethod(label='Create or Update Jira Case' description='Create or Update Jira Case on IT Case insert or update')
   public static void UpsertJiraCase(List<Id> caseList)
      {
          Map<id,Jira_Case__c> devJiraMap =  new Map<id,Jira_Case__c> ();
          Map<id,Jira_Case__c> uatJiraMap =  new Map<id,Jira_Case__c> ();
         for(Jira_Case__c s : [SELECT Id,summary__c, Case__c,EpicLink__c,Components__c, Description__c,Case__r.CaseNumber, Jira_ID__c, assigne__c, priority__c,  Issue_Type__c, Found_In__c, Labels__c, Bug_Environment__c,Case_Stage__c,Jira_Sync_Status__c from Jira_Case__c WHERE Case__c = :caseList ])
         {
             
             if(s.Case_Stage__c == 'UAT')
             {
                 uatJiraMap.put(s.Case__c,s);
             }
             else if(s.Case_Stage__c == 'Development')
             {
                 devJiraMap.put(s.Case__c,s);
             }

         }  
         List<Jira_Case__c> jcupdateList = new List<Jira_Case__c>();
          List<Jira_Case__c> jccreateList = new List<Jira_Case__c>();
        for(Case c :[select id,RecordTypeId,Subject,Priority,Description,IT_Classification__c,IT_Environment__c,SPRINT_NAME__c,Jira_Component__C from case  where id=:caseList])
        {
            Jira_Case__c jc = new Jira_Case__c();
            
            jc.Case__c=c.id;
          //  jc.EpicLink__c
          
            
           // jc.priority__c
          //  jc.Issue_Type__c
            
            jc.Jira_Sync_Status__c='';
            //jc.Case_Stage__c 
            if(uatJiraMap.get(c.id)!=null)
            {
                jc.id =uatJiraMap.get(c.id).id;
                jcupdateList.add(jc);
            }
            else if(devJiraMap.get(c.id)!=null)
            {
                jc.id =devJiraMap.get(c.id).id;
                jcupdateList.add(jc);
            }
            else{
                jc.Case_Stage__c='Development';
                jc.summary__c = c.Subject;
                jc.Description__c =c.Description;
                jc.Found_In__c=c.IT_Environment__c;
                jc.Bug_Environment__c=c.IT_Environment__c;
                 jc.Components__c =c.Jira_Component__C;
                jccreateList.add(jc);
            }
        }
      if(jcupdateList.size()>0)
      {
        update jcupdateList;
      }
       if(jccreateList.size()>0)
      {
        insert jccreateList;
      }
   }
}