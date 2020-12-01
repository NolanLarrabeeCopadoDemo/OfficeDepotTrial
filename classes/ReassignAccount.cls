// Functionality to Submit request for Reassigning Account (Prospect)
public class ReassignAccount{
//variable declaration
ID Acid,currentOwner ;
List<Reassignment_Queue__c> accList= new List<Reassignment_Queue__c>();
public Boolean showRow{get;set;}
public Boolean showNew{get;set;}
public Boolean showCancel{get;set;}

public ReassignAccount(ApexPages.StandardController controller) {
    //get Account Id
    Acid =ApexPages.currentPage().getParameters().get('ID');
    currentOwner=[select ownerId from account where Id=:Acid ].ownerId;
    accList=[Select Id, Account__c,Approve_Reject_Date__c,Approver__c,New_Owner__C,New_Owner__r.name,
    Requestor__c,Status__c,Requestor__r.name,Approver__r.name  from Reassignment_Queue__c where Account__c=:Acid order by createddate desc ];
    showRow=false;
    showNew=true;
    showCancel=false;
}

// Loading Data
public List<Reassignment_Queue__c> getaccList(){
return accList;
}

public PageReference CancelRec(){
showRow=false;
showNew=true;
showCancel=false;

accList=[Select Id, Account__c,Approve_Reject_Date__c,Approver__c,New_Owner__C,New_Owner__r.name,
    Requestor__c,Status__c,Requestor__r.name,Approver__r.name  from Reassignment_Queue__c where Account__c=:Acid order by createddate desc ];
return null;
}

public PageReference createAssignment(){
showCancel=true;
// check whether the logged in user is authorized to do transfers
ReassignUtils res= new ReassignUtils ();
boolean authorizeReassign= res.ReassignAllowed();
if(authorizeReassign==true){
showRow=true;
Reassignment_Queue__c createRow = new Reassignment_Queue__c ();
createRow.Account__c=Acid ;
//createRow.status__C='Pending Approval';
createRow.Requestor__c=UserInfo.getUserId();
List<Reassignment_Queue__c> accListTemp= new List<Reassignment_Queue__c>();
accListTemp=accList;
accList= new List<Reassignment_Queue__c>();
accList.add(createRow );
for(integer i=0;i<accListTemp.size();i++)
accList.add(accListTemp[i]);
showNew=false;
}
else{
            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,'Error: Not Authorized to Do Reassignment.');
            ApexPages.addMessage(myMsg);
showNew=false;
}
return null;
}
public PageReference SaveRecord(){
//check teh new user is in hierarchy
ReassignUtils res= new ReassignUtils ();
ReassignUtils.ReassignData createRec= new ReassignUtils.ReassignData ();
List<ReassignUtils.ReassignData> createRecList= new List<ReassignUtils.ReassignData> ();

createRec.AccountID= accList[0].Account__c;
createRec.toUserID=accList[0].New_Owner__C;
createRecList.add(createRec);
List<ReassignUtils.ReassignData > response =res.ReassignAccounts(createRecList);

if(response [0].status_code=='E'){
            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,response [0].status_msg);
            ApexPages.addMessage(myMsg);

}


showRow=false;
showNew=true;
showCancel=false;

accList=[Select Id, Account__c,Approve_Reject_Date__c,Approver__c,New_Owner__C,New_Owner__r.name,
    Requestor__c,Requestor__r.name,Approver__r.name, Status__c from Reassignment_Queue__c where Account__c=:Acid order by createddate desc ];
return null;
}


}