/**************************************************************************
*Created By :Wipro Offshore team
*Created Date : 11/07/2012
*Purpose :Update Contract Message status on the related case.

Last Modified       :
Last Modified By    :
Last Modified Reason:
***************************************************************************/
trigger ContractMessage_Case_Status on ContractMessage__c (After update) {


Set<Id> caseid=new Set<Id>();
List<Case> update_Case_list= new List<Case>();
for(ContractMessage__c cm:Trigger.new)
{
    caseid.add(cm.Support__c);
}

Map<Id,Case> map_id_case=new Map<Id,Case>([Select id,Contract_Message_Status__c from Case where id in:caseid]);

for(ContractMessage__c cm1:Trigger.new)
{
        Case case_alias= new Case();
        case_alias=map_id_case.get(cm1.Support__c);
        if(cm1.Status__c!=null)
        {
            case_alias.Contract_Message_Status__c=cm1.Status__c;
        }
        update_Case_list.add(case_alias);
    
}
if(update_Case_list.size()>0)
{
    update update_Case_list;
}

}