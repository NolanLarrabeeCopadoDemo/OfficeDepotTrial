// Functionality to Submit request for Reassigning Account (Prospect)
public class ApproveRejectProspect
{
//variable declaration
ID loggedinUser;
List<Reassignment_Queue__c> accList= new List<Reassignment_Queue__c>();
public List<wrapper> ReassignList = new List<wrapper> ();
@TestVisible  String typeofView;
public Boolean showSuccess{get;set;}
public Boolean showError{get;set;}
public string scriptvar{get;set;}
public string ReportLink{get;set;}

public ApproveRejectProspect() {
        loggedinUser=UserInfo.getUserId();
        showSuccess=false;
        showError=false;
    //Adding to Wrapper
   typeofView='My Approvals';
       accList= [Select Id, Account__c,Approve_Reject_Date__c,Approver__c,New_Owner__C,   Requestor__c,Status__c
       from Reassignment_Queue__c where Approver__c=:loggedinUser and status__C='Pending Approval'    
       order by createddate desc limit 1000] ;

        for(Reassignment_Queue__c   rec: accList){
                       ReassignList.add(new wrapper(rec));            
        }
        System.debug('&&&&&&&&&&&ReassignList'+ReassignList);
}

//get the data according to selection
public void refreshView(){
showSuccess=false;
showError=false;
    ReassignList = new List<wrapper> ();
    if(typeofView=='My Approvals')
    {
           accList= [Select Id, Account__c,Approve_Reject_Date__c,Approver__c,New_Owner__C,   Requestor__c,Status__c
           from Reassignment_Queue__c where Approver__c=:loggedinUser and status__C='Pending Approval'    
           order by createddate desc limit 1000] ;
    }
    else{
          accList= [Select Id, Account__c,Approve_Reject_Date__c,Approver__c,New_Owner__C,   Requestor__c,Status__c
           from Reassignment_Queue__c where Requestor__c=:loggedinUser and status__C='Pending Approval'    
           order by createddate desc limit 1000] ;
    }
    for(Reassignment_Queue__c   rec: accList){
                       ReassignList.add(new wrapper(rec));            
     }
}


public void ProcessRecords(String process){

List<Id > approveList = new List<Id >();
list<ReassignUtils.AppRejData> approveResponse = new list<ReassignUtils.AppRejData>();
ReassignUtils approveInstance = new ReassignUtils();
 System.debug('&&&&&&&&&&&&values'+getReassignList());
 for(wrapper cCon:  getReassignList()) {
 System.debug('&&&&&&&&&&&&Inside');
            if(cCon.selected == true) {
                approveList.add(cCon.con.Id);
            }
        }
        
        System.debug('&&&&&&&approveList'+approveList);
        if(approvelist.size()>0){
        
                approveResponse =approveInstance.ApproveRej(approveList,process);
                   System.debug('&&&&&&&approveResponse'+approveResponse);
                for(integer i=0;i< approveResponse.size();i++){
                  if(approveResponse[i].status_code=='E'){
                  showError=true;
                  }
                }
                if(showError!=true)
                showSuccess=true;
        }
      
      if(process=='A' || process== 'R'){
           accList= [Select Id, Account__c,Approve_Reject_Date__c,Approver__c,New_Owner__C,   Requestor__c,Status__c
           from Reassignment_Queue__c where Approver__c=:loggedinUser and status__C='Pending Approval'    
           order by createddate desc limit 1000] ;
           }
           else{
           accList= [Select Id, Account__c,Approve_Reject_Date__c,Approver__c,New_Owner__C,   Requestor__c,Status__c
           from Reassignment_Queue__c where Requestor__c=:loggedinUser and status__C='Pending Approval'    
           order by createddate desc limit 1000] ;
           }
           ReassignList = new List<wrapper> ();
               for(Reassignment_Queue__c   rec: accList){
                       ReassignList.add(new wrapper(rec));            
               }


}

public String getReportLink(){
  ReassignUtils ru = new ReassignUtils();
        String ReportLink = ru.ReassignMetadata.Approval_error_Link__c;
return reportLink;
}

public PageReference Approve(){
showSuccess=false;
showError=false;
ProcessRecords('A');
return null;
}

public PageReference Reject(){
showSuccess=false;
showError=false;
ProcessRecords('R');
return null;
}

public PageReference Cancel(){
showSuccess=false;
showError=false;
ProcessRecords('C');
return null;
}



//get the options to select 
    public List<SelectOption> getoptions() {
        List<SelectOption> options = new List<SelectOption>();
        options.add(new SelectOption('My Requests','My Requests'));
        options.add(new SelectOption('My Approvals','My Approvals'));
        return options;
    }

    public String gettypeofView() {
        return typeofView;
    }
    public void settypeofView(String typeofView) {
        this.typeofView= typeofView;
    }


    public class wrapper{
        public Reassignment_Queue__c  con {get; set;}
        public Boolean selected {get; set;}
        public wrapper(Reassignment_Queue__c   c) {
            con = c;
            selected = false;
        }
    }



    public List<wrapper> getReassignList() {   
    Return ReassignList;   
    }


}