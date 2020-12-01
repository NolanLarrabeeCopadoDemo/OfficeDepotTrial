public with sharing class GetAccountCntlr {
string aid;
public boolean renderMsg{get;set;}
     
      public GetAccountCntlr() {
    
             renderMsg = true;
             
    }
    
    public PageReference frwd() {
        try{
             if(ApexPages.currentPage().getparameters().get('odpid') != null || ApexPages.currentPage().getparameters().get('odpid') != '')
             {
                 string odpid= ApexPages.currentPage().getparameters().get('odpid');
                 system.debug(odpid +'odpid');
                 if(odpid != null){
                 Account a = [select id from Account where AOPS_Cust_Id__c = :odpid  or AOPS_Seq_ID__c = :odpid limit 1 ];
                 aid = a.id;
                system.debug(aid+ aid);
                                  }
                 
            
             }
             
              if(ApexPages.currentPage().getparameters().get('omxid') != null || ApexPages.currentPage().getparameters().get('omxid') != '')
             {
                 string omxid= ApexPages.currentPage().getparameters().get('omxid');
                  system.debug(omxid+'omxid');
                   if(omxid != null){
                 Account a = [select id from Account where OMX_Primary_Key__c= :omxid  limit 1];
                 aid = a.id;
                 
                 system.debug(aid);
            
                 } 
                 
            
             }
     system.debug('inside pg');
     Account account = [select id from account where id =:aid];
     PageReference acctPage = new ApexPages.StandardController(account).view();
        acctPage.setRedirect(true);
        return acctPage;
        }
        catch(Exception e)
        {
        ApexPages.Message errorMsg = new ApexPages.Message(ApexPages.Severity.ERROR,'Account record not found.');
        ApexPages.addMessage(errorMsg);
        renderMsg = false;
        return null;
        }
        
     /*PageReference pageRef = new PageReference('/'+aid);
     pageRef.setRedirect(true);
     system.debug(pageRef+'');
                 return pageRef;
                 */
                 }
    }