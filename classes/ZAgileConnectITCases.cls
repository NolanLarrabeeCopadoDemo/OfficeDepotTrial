public class ZAgileConnectITCases {
     @invocablemethod
    public static void zagileConcatenateDescription(List<Id> lstOfCaseids) {
    system.debug('-->caseid'+lstOfCaseids);
    List<Case> caseLst=new List<Case>();
    for(Case c:[select id,IT_Impact__c,CaseNumber,Subject,Description,Jira_Description__c,IT_Sprint_Numb__c,Jira_Subject__c,IT_Resolution__c,IT_Status__c,Project__R.Name from Case where Id IN:lstOfCaseids]) { 
       c.Jira_Subject__c=c.CaseNumber+' - '+c.Subject;
       c.Jira_Description__c=('DESCRIPTION: '+ c.Description+'\n IMPACT DESCRIPTION: '+c.IT_Impact__c+'\n IT STATUS: '+C.IT_Status__c+'\n PROJECT: '+c.Project__R.Name+'\n AGILE STAGE: '+C.IT_Sprint_Numb__c+'\n Resolution: '+C.IT_Resolution__c).remove('null');
       caseLst.add(c);  
     }  
     system.debug('-->case is'+caseLst);
     update caseLst;
    }
}