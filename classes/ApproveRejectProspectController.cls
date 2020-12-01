/*************************************************************
*Name : ApproveRejectProspectController
*Created By : Sandesh Ganjare
*Created Date :
*Purpose : 
*JIRA: 
****************************************************************/
public with sharing class ApproveRejectProspectController {
    public ApproveRejectProspectController() {

    }
    //Id loggedinUser;
    public class ApproveRejectWrapper{
        @AuraEnabled
        public Id id;
        @AuraEnabled
        public Reassignment_Queue__c  Reassignment_Queue;               
    }

    public class ResponseWrapper{
        @AuraEnabled
        public List<ApproveRejectWrapper> data;
        @AuraEnabled
        public boolean error;
        @AuraEnabled
        public String reportLink;
    }

    @AuraEnabled(cacheable=true)
    public static List<ApproveRejectWrapper> getApproveRejectData(String type) {
        System.debug('=>'+type);
        ID loggedinUser = UserInfo.getUserId();
        List<Reassignment_Queue__c> accList= new List<Reassignment_Queue__c>();
        List<ApproveRejectWrapper> ReassignList = new List<ApproveRejectWrapper>();
       //Adding to Wrapper
       if(type=='My Approvals'){
            accList= [Select Id, Account__c,Account__r.Name, Approve_Reject_Date__c,Approver__c, Approver__r.Name,New_Owner__C,New_Owner__r.Name,   Requestor__c, Requestor__r.Name,Status__c
            from Reassignment_Queue__c where Approver__c=:loggedinUser and status__C='Pending Approval'    
            order by createddate desc limit 1000] ;
       }
       else{
            accList= [Select Id, Account__c,Account__r.Name, Approve_Reject_Date__c,Approver__c, Approver__r.Name,New_Owner__C,New_Owner__r.Name,   Requestor__c, Requestor__r.Name,Status__c
            from Reassignment_Queue__c where Requestor__c=:loggedinUser and status__C='Pending Approval'    
            order by createddate desc limit 1000] ;
       }
       if(!accList.isEmpty() && accList.size() >0){
            for(Reassignment_Queue__c   rec: accList){
                ApproveRejectWrapper arw = new ApproveRejectWrapper();
                arw.Reassignment_Queue = rec;
                arw.id = rec.id;
                ReassignList.add((arw));            
            }
            System.debug('&&&&&&&&&&&ReassignList'+ReassignList);
       }       
    return ReassignList;
    }

    @AuraEnabled
    public static ResponseWrapper ProcessRecords(String process, String reassigndata){
        ID loggedinUser = UserInfo.getUserId();
        ResponseWrapper rs = new ResponseWrapper();
        Boolean error = false;
        String reportLink;
        List<Reassignment_Queue__c> accList= new List<Reassignment_Queue__c>();
        List<ApproveRejectWrapper> ReassignList = new List<ApproveRejectWrapper>();
        List<ApproveRejectWrapper> lstApproveReject = (List<ApproveRejectWrapper>)JSON.deserialize(reassigndata, List<ApproveRejectWrapper>.class);
        System.debug('&&&&&&&&&&&&lstApproveReject:'+lstApproveReject);
        List<Id > approveList = new List<Id >();
        List<ReassignUtils.AppRejData> approveResponse = new List<ReassignUtils.AppRejData>();
        ReassignUtils approveInstance = new ReassignUtils();
        reportLink = approveInstance.ReassignMetadata.Approval_error_Link__c;
        System.debug('&&&&&&&&&&&&values'+reportLink );
         for(ApproveRejectWrapper cCon:  lstApproveReject) {
                System.debug('&&&&&&&&&&&&Inside'+cCon.id);
                //if(cCon.selected == true) {
                    approveList.add(cCon.id);
                //}
            }
            System.debug('&&&&&&&approveList'+approveList);
                if(!approvelist.isEmpty() && approvelist.size()>0){                  
                    approveResponse =approveInstance.ApproveRej(approveList,process);
                    System.debug('&&&&&&&approveResponse'+approveResponse);
                    if(!approvelist.isEmpty() && approvelist.size()>0){
                        for(integer i=0;i< approveResponse.size();i++){
                            if(approveResponse[i].status_code=='E'){
                                error=true;
                            }
                        }
                        if(error!=true)
                        error=false;
                    }
                   
                }

                if(process=='A' || process== 'R'){
                    accList= [Select Id, Account__c,Account__r.Name, Approve_Reject_Date__c,Approver__c, Approver__r.Name,New_Owner__C,New_Owner__r.Name,   Requestor__c, Requestor__r.Name,Status__c
                    from  Reassignment_Queue__c where Approver__c=:loggedinUser and status__C='Pending Approval'    
                    order by createddate desc limit 1000] ;
                }
                else{
                    accList= [Select Id, Account__c,Account__r.Name, Approve_Reject_Date__c,Approver__c, Approver__r.Name,New_Owner__C,New_Owner__r.Name,   Requestor__c, Requestor__r.Name,Status__c
                    from Reassignment_Queue__c where Requestor__c=:loggedinUser and status__C='Pending Approval'    
                    order by createddate desc limit 1000] ; 
                }

                if(!accList.isEmpty() && accList.size() >0){
                    for(Reassignment_Queue__c   rec: accList){
                        ApproveRejectWrapper arw = new ApproveRejectWrapper();
                        arw.Reassignment_Queue = rec;
                        arw.id = rec.id;
                        ReassignList.add((arw));            
                    }
                    System.debug('&&&&&&&&&&&ReassignList'+ReassignList);
               }                   
            rs.error = error;
            rs.reportLink = reportLink;
            rs.data =ReassignList;
            return rs;         
        }
}