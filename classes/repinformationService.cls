@RestResource(urlMapping='/repInfo/*')
global with sharing class repinformationService{
   
    global class repinfo {

        Global String aopsId;
        Global String aopsSeqId;
        Global String siteownerFirstName;
        Global String siteownerLastName;
        Global String acctownerFirstName;
        Global String acctownerLastName;
        Global String primaryRep;
        Global String ownerShortTitle;
        Global String ownerEmail;
        Global String ownerPhone;
        Global String ownerPhotoUrl;
        Global String returnStatus;
        Global String errorMessage;
        Global String ownerEmployeeId;

    }  
    
    @HttpGet
    global static list<repinfo> doGet() {
    
      repinfo r = new repinfo();
      list<repinfo> repinfoList = new List<repInfo> ();
      boolean record_found = false;
      string Account_owner_fname,account_owner_lname;
      try
       {
        RestRequest req = RestContext.request;
        String aops_seq_id = req.requestURI.substring(req.requestURI.lastIndexOf('/')+1);
        list<account> acct = [SELECT owner.od_employee_id__c,related_account__r.aops_cust_id__c,aops_seq_id__c,related_account__r.Name,Name,related_account__r.sector__c,related_account__r.segment__c,related_account__r.Sic,related_account__r.owner.firstname,related_account__r.owner.lastname,owner.firstname,owner.lastname,owner.Short_Title__c,owner.Phone,owner.email,owner.FullPhotoUrl FROM account WHERE aops_seq_id__c = :aops_seq_id and owner.isactive = true and owner.title <> ''];
        list<accountteammember> acctmem = [select user.od_employee_id__c,account.aops_cust_id__c,account.aops_seq_id__c,account.owner.firstname,account.owner.lastname,user.firstname,user.lastname,user.Short_Title__c,user.Phone,user.email,user.FullPhotoUrl FROM accountteammember WHERE account.aops_seq_id__c = :aops_seq_id and user.isactive = true and user.title <> ''];
        if (!acct.isEmpty()){
         Account_owner_fname = acct[0].related_account__r.owner.firstname;
         Account_owner_lname = acct[0].related_account__r.owner.lastname;
         
         r.aopsId = acct[0].related_account__r.aops_cust_id__c;
         r.aopsSeqId = acct[0].aops_seq_id__c;
         r.siteownerfirstName = acct[0].owner.firstname;
         r.siteownerlastName = acct[0].owner.lastname;
         r.acctownerfirstName = Account_owner_fname;
         r.acctownerlastName = Account_owner_lname;
         r.ownerShortTitle = acct[0].owner.short_title__c;
         r.ownerEmail = acct[0].owner.email;
         r.ownerPhone = acct[0].owner.Phone;
         r.ownerPhotoUrl = acct[0].owner.fullphotourl + '?oauth_token=' + userinfo.getSessionid();
         r.ownerEmployeeId = acct[0].owner.od_employee_id__c;
         r.returnStatus = 'S';
         r.primaryRep = 'Y';
         record_found = true;
        }
        else {
            r.returnStatus = 'S';
            r.primaryRep = 'Y';
        }
        for (accountteammember am:acctmem) {
         repinfo rinfo = new repinfo();
         rinfo.aopsId = am.account.aops_cust_id__c;
         rinfo.aopsSeqId = am.account.aops_seq_id__c;
         rinfo.siteownerfirstName = am.user.firstname;
         rinfo.siteownerlastName = am.user.lastname;
         rinfo.acctownerfirstName = Account_owner_fname;
         rinfo.acctownerlastName = Account_owner_lname;
         rinfo.ownerShortTitle = am.user.short_title__c;
         rinfo.ownerEmail = am.user.email;
         rinfo.ownerPhone = am.user.Phone;
         rinfo.ownerPhotoUrl = am.user.fullphotourl + '?oauth_token=' + userinfo.getSessionid();
         rinfo.ownerEmployeeId = am.user.od_employee_id__c;
         rinfo.primaryRep = 'N';
         rinfo.returnStatus = 'S';
         record_found = true;
         repinfoList.add(rinfo);
        }
        repinfoList.add(r);
        return repinfoList;
        }
        catch (Exception e) {
          r.returnStatus = 'E';
          r.errorMessage = e.getmessage();
         return repinfoList;
        }
    }
    
    
  
}