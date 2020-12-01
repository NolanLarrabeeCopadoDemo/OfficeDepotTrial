public class GPOLead {

public gpo_lead__c glead {get;set;}
public boolean successMsg {get;set;}
public boolean errorMsg {get;set;}
public boolean showForm {get;set;}
public String errorText {get;set;}
public String parentAccid {get;set;}

public GPOLead() {
   system.debug('test2');
   glead = new GPO_Lead__c();
   successMsg = false;
   errorMsg = false;
   showForm=true;
   
}

public GPOLead(GPOCommunityLandingController controller) {
system.debug('No Code');
  
}

public void newLead() {
   system.debug('Inside Lead Create');
   glead = new GPO_Lead__c();
   successMsg = false;
   errorMsg = false;
   showForm=true;
}

public void saveLead() {

try
{
parentAccid = ApexPages.currentPage().getParameters().get('id');
if (glead.first_name__c == null || glead.last_name__c == null || glead.Phone__c == null || glead.Email__c == null || glead.Business_Name__c == null 
     || glead.Zip__c == null || glead.WCW_Range__c == null) {
  errorText = 'Error: Please Enter All the Required Fields';
  errorMsg = true;
  successMsg = false;
}
else {
system.debug('Successful');
 if (parentAccid != null) {
    list<account> acc = [select id from account where id = :parentAccid];
    if (acc.size() > 0)
     glead.Account__c = parentAccid;
 }
 glead.status__c = 'New';
 insert glead;
 successMsg = true;
 errorMsg=false;
 showForm=false;
}
 }
 catch(Exception e) {
  system.debug('Unexpected Error:' + e);
  errorText = 'Error: Lead Submission Failed, Please contact Administractor.';
  errorMsg = true;
  successMsg = false;
 }
}

}