public class businessProInfo {

public User bpInfo {get;set;}
//public business_pro_store__c bsInfo {get;set;}
public business_pro_owner__c boInfo {get;set;}
public business_pro_owner__c newBo {get;set;}
public Account acctContext {get;set;}
public boolean displayEdit {get;set;}
public class custException extends Exception{}
public Account aowner {get;set;}
public boolean chgOwner {get;set;}
public list<BusinessProSetup__mdt> bproSetup {get;set;}

public businessProInfo(ApexPages.StandardController controller) {
 bproSetup = [select AccountRecordType__c,AccountRetURL__c,ContactRecordType__c,LeadRecordType__c,noOverrideEditURL__c,OpportunityRecordType__c,PublicGroupName__c from BusinessProSetup__mdt limit 1];
 acctContext= (Account)controller.getRecord();
// bsInfo = new business_pro_store__c();
 boInfo = new business_pro_owner__c();
 chgOwner = false;
 
    if (bproSetup.size() > 0) {
     for (GroupMember g:[SELECT Id from groupMember where group.Name=:bproSetup[0].PublicGroupName__c and UserOrGroupId=:userInfo.getUserId() limit 1]) {
       chgOwner=true;
    }
 
 }
 
 aowner = [select id,ownerId from account where id=:acctContext.id];
 system.debug('@@@@aowner'+ aowner);
  system.debug('@@@@aowner.ownerid'+ aowner.ownerid);

  system.debug('@@@@ acctContext.id'+  acctContext.id);


 list<user> u = [select id,od_employee_id__c,name,Phone,email from user where id=:aowner.ownerid];
 system.debug('@@@@u'+ u);
 if (u.size() > 0) {
   bpinfo = u[0];
 }
 //for(business_pro_store__c b: [select store__r.ID_Number__c from business_pro_store__c where BusinessPro__c=:bpinfo.id and isCurrent__c=true])
   //bsinfo = b;
   
  for(business_pro_owner__c b: [select BusinessPro__r.store__c,start_date__c,end_date__c from business_pro_owner__c where BusinessPro__c=:bpinfo.id and account__c=:aowner.id and isCurrent__C=true])
   boinfo = b;

   displayEdit = false;
   
}

public void changeOwner() {
   displayEdit = true;
   newBo = new Business_Pro_Owner__c();
   newBo.Account__c = acctContext.id;
   newBo.isCurrent__c=true;

}


public void savebpro() {
 try {
  //pageReference p = new PageReference('/'+acctContext.id);
  //p.setRedirect(true);
  
  //validations - start
  if (newbo.start_Date__c > system.today())
   throw new CustException ('Start Date Cannot be in the future');
   
   system.debug('old owner:' + aowner.ownerid);
   system.debug('new owner:' + newBo.BusinessPro__c);
  
  if (aowner.ownerid == newBo.BusinessPro__c)
   throw new custException ('The Business Pro Rep That You Are Selecting Is Already The Current Owner');
  
   for (Business_Pro_Owner__c b:[select id,end_date__c,start_date__c,isCurrent__c,account__c from business_pro_owner__c where account__c=:acctContext.id and isCurrent__c=true]) {
     
     if (newBo.start_date__c < b.start_date__c)
       throw new custException('Previous Owner End Date Cannot Be Less Than Start Date');
   }
    
   
  //validations - end
   insert newBo;
   
   
   
  
   boinfo.start_date__c = newBo.start_date__c;
   boinfo.end_date__c = newBo.end_Date__c;
   
  
   
   list<user> u = [select id,od_employee_id__c,name,Phone,email from user where id=:newBo.BusinessPro__c];
   if (u.size() > 0) {
     bpinfo = u[0];
   }
   aowner = [select id,ownerId from account where id=:acctContext.id];
   displayEdit = false;
   
   //return p;
 }
 catch (DmlException d) {
   ApexPages.addMessages(d);
   //return null;
 }
 catch (CustException ce) {
   ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,ce.getMessage()));
   //return null;
 }
 catch (Exception e) {
   ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Unexpected Exception:' + e));
   //return null;
 }
 
}
public void cancelbpro() {
  displayEdit = false;
}

public businessProInfo() {
  
}


    
}