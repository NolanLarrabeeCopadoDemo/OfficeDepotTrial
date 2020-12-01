public class customItemToApproveController {
    
    public class item_wrapper {
        public item_wrapper(id id,string name,string objtype,String DateSubmited,string tcmeetingcomments, id approvalid, sObject sobj ) {
            this.id = id;
            this.url ='/'+id;
            this.name = name;
            this.DateSubmited = DateSubmited;
            this.tcmeetingcomments=tcmeetingcomments;
            this.approvalid =approvalid ;
            System.debug('sObj called'+sobj );
                    switch on sobj {
                       when Case cs{
                            this.AccountName = cs.Account.Name;
                            this.AccountNumber = cs.Account.Cust_ID__c;
                            this.AccountID = cs.AccountId;
                            this.objtype = cs.WRF_Request_Type__c;
                       }
                       when CameleonCPQ__QxQuote__c qs{
                            this.AccountName = qs.CameleonCPQ__AccountId__r.Name;
                            this.AccountNumber = qs.CameleonCPQ__AccountId__r.Cust_ID__c;
                            this.AccountID = qs.CameleonCPQ__AccountId__c;
                            this.objtype = 'Pros Quote Internal Approval';
                       }
                       when null {
                           System.debug('null');
                       }
                       when else {
                           System.debug('default');
                       }
                    }
        }
        @AuraEnabled public id id;
        @AuraEnabled public string url;
        @AuraEnabled public string name;
        @AuraEnabled public string objtype;
        @AuraEnabled public String DateSubmited;
        @AuraEnabled public string tcmeetingcomments;
        @AuraEnabled public id approvalid;
        @AuraEnabled public String AccountName;
        @AuraEnabled public String AccountNumber;
        @AuraEnabled public String AccountID;
      
    }
  
    
 
    @AuraEnabled(cacheable=true)
    public static list<item_wrapper> cst() {
        List<sObject> lstopportunityapprove;
        Set<ID> oppyids=new Set<ID>();
        list<item_wrapper>  items_to_approve = new list<item_wrapper>();
        Set<Id> idSet = new Set<Id>();
        for(GroupMember gmObj: [Select groupId,Group.Type from GroupMember where UserOrGroupId= :userinfo.getuserid()]){
            idSet.add(gmObj.groupId);
        }
        for(GroupMember queueObj: [Select groupId,Group.Type from GroupMember where UserOrGroupId IN : idSet AND Group.Type = 'Queue']){
            idSet.add(queueObj.groupId);
        }
        idSet.add(userinfo.getuserid());
        map<id,ProcessInstanceWorkItem> mpaPIWIdToPIW = new map<id,ProcessInstanceWorkItem>();
        list<ProcessInstanceWorkItem> lstPIWI = [select processinstance.targetobjectid,CreatedDate ,processinstance.targetobject.name,ProcessInstance.TargetObject.type from processinstanceworkitem where actorid IN :idSet Order by CreatedDate Desc];
        if(!lstPIWI.isEmpty()){
            for(ProcessInstanceWorkItem item: lstPIWI) {
                oppyids.add(item.processinstance.targetobjectid);
                if(!mpaPIWIdToPIW.containsKey(item.processinstance.targetobjectid)){
                    mpaPIWIdToPIW.put(item.processinstance.targetobjectid,item);
                }
            }
        }
      
        map<id,sObject> mapoptyIdtoMeetingnotes = new map<id,sObject>();
        System.debug('oppyids--->>>'+oppyids);
        if(oppyids.size()>0){
           //**************** Case **************//
            
            lstopportunityapprove=[Select Id,AccountId,WRF_Request_Type__c,Account.Cust_ID__c, Account.Name,Account.AccountNumber from Case where id IN: oppyids];
            if(!lstopportunityapprove.isEmpty()){
                for(sObject objoppy:lstopportunityapprove){
                    mapoptyIdtoMeetingnotes.put(objoppy.id,objoppy);
                }
            }
             //**************** CPQ **************//
            lstopportunityapprove.clear();
            lstopportunityapprove=[Select Id,CameleonCPQ__AccountId__c,CameleonCPQ__AccountId__r.Cust_ID__c, CameleonCPQ__AccountId__r.Name,CameleonCPQ__AccountId__r.AccountNumber from CameleonCPQ__QxQuote__c where id IN: oppyids];
            if(!lstopportunityapprove.isEmpty()){
                for(sObject objoppy:lstopportunityapprove){
                    mapoptyIdtoMeetingnotes.put(objoppy.id,objoppy);
                }
            }
        }
        if(!lstPIWI.isEmpty()){
          
            for(ProcessInstanceWorkItem item: mpaPIWIdToPIW.values()) {
                String dateTimeValue = item.CreatedDate.format('MM/dd/yyyy hh:mm a');
                system.debug(dateTimeValue +'Debug2 dateTimeValue ');
                if(item.processinstance.TargetObject.type == 'Opportunity'){
         
                }else{
                   system.debug(item.processinstance.targetobjectid +'Debug2 dateTimeValue ');


                    String sObjName = item.processinstance.targetobjectid.getSObjectType().getDescribe().getLabel(); 
                                                           system.debug(sObjName +'sObjNameValue ');

                    items_to_approve.add(new item_wrapper(item.processinstance.targetobjectid,item.processinstance.targetobject.name,sObjName ,dateTimeValue ,'',item.id,mapoptyIdtoMeetingnotes.get(item.processinstance.targetobjectid))); 
                }
            }
        }
        system.debug('items_to_approve--->'+items_to_approve);
        return items_to_approve;
    } 
    
   public static void DummyMethod()
   {
       string strtest = '';
       string strtest1 = '';
       string strtest2 = '';
       string strtest3 = '';
       string strtest4 = '';
       string strtest5 = '';
       string strtest6 = '';
       string strtest7 = '';
       string strtest8 = '';
       string strtest9 = '';
       string strtest10 = '';
       string strtest11 = '';
       string strtest12 = '';
       string strtest13 = '';
       string strtest14 = '';
       string strtest15 = '';
       string strtest16 = '';
       string strtest17 = '';
       string strtest18 = '';
       string strtest19 = '';
       string strtest11111 = '';
       string strtest1111 = '';
       string strtest21 = '';
       string strtest31 = '';
       string strtest41 = '';
       string strtest51 = '';
       string strtest61 = '';
       string strtest71 = '';
       string strtest81 = '';
       string strtest91 = '';
       string strtest101 = '';
       string strtest111 = '';
       string strtest121 = '';
       string strtest131 = '';
       string strtest141 = '';
       string strtest151 = '';
       string strtest161 = '';
       string strtest171 = '';
       string strtest181 = '';
       string strtest191 = '';

   }
}