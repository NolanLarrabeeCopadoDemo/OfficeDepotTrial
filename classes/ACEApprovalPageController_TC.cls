@isTest
private class ACEApprovalPageController_TC
{
 static testMethod void ACEApprovalPageController_method(){
 ACEApprovalPageController AAPC= new ACEApprovalPageController();
 AAPC.ApproveFunc();
 AAPC.RejectFunc();
 AAPC.Cancel();
 }
 }