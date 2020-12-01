trigger GTContactDeltaTrigger on GTContact_Delta__c (before insert)
{

List<String> AccountOMXPrimaryKeyMap = new List<String>();

    for(GTContact_Delta__c GT : Trigger.new)
    {
        if(GT.Processed_Status__c== 'Process Max')
        {
           GT.uniqueid__C=GT.Account_OMX_Primary_Key__c+GT.name+GT.first_name__C;
           GT.Contact_Source__c='MAX';
            AccountOMXPrimaryKeyMap.add(GT.Account_OMX_Primary_Key__c);
    
        }
    }

    List<account> AccountList = [Select id,Related_Account__r.OMX_Primary_Key__c,OMX_Primary_Key__c from account where 
    Related_Account__c !=null  AND OMX_Primary_Key__c in :AccountOMXPrimaryKeyMap];
    for(GTContact_Delta__c GT : Trigger.new)
    {
      if(GT.Processed_Status__c== 'Process Max')
        {
            for(Account acc : AccountList )
            {
              if(GT.Account_OMX_Primary_Key__c==acc.OMX_Primary_Key__c){
               GT.SITE_OMX_Primary_Key__C=acc.OMX_Primary_Key__c;
               GT.Account_OMX_Primary_Key__c=acc.Related_Account__r.OMX_Primary_Key__c;
               GT.uniqueid__C=GT.Account_OMX_Primary_Key__c+GT.name+GT.first_name__C;
              }           
            }
        }
    }    

    



}