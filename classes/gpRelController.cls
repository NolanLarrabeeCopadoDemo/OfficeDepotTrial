public class gpRelController {
     public boolean allowGPEdit {get;set;}
     public GP_Rel_History__c gRelHist {get;set;}
     public Account acct {get;set;}
     Public ID acctID {get;set;}
     public class custException extends Exception {}
     
     public gpRelController() {
      try
      {
         system.debug('Inside GP Relationship Controller Constructor');
         
         user u=[select id,GrandParent_User__c from user where id=:userInfo.getUserID()];
         
         if (!u.GrandParent_User__c)
            throw new custException('You are Not Authorized, Please follow up with your User Administrator for Access'); 
         
         acctID=ApexPages.CurrentPage().getParameters().get('AcctId');
         if (acctID != null || acctID != '') {
           acct=new Account();
           gRelHist = new GP_Rel_History__c();
           for (Account a:[select id,parentid,parent.recordtype.DeveloperName,aops_cust_id__C,name from account where id=:acctID]) {
              acct=a;
            }
            
         }
         else {
             throw new custException ('A valid Account ID has not been Passed');
         }
         
         allowGPEdit=true;
         
      }
      catch(custException ce) {
              system.debug('Error:' + ce);
              ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,ce.getMessage()));

      }
       catch(Exception ex){
         ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.ERROR,'Unexpected Exception:' + ex));
        }
     }
     
     public pageReference cancelRecord() {
          return new PageReference('/'+acctID);
     }
     
     public pageReference saveRecord() {
         try {
               Account actOld = [select id,parentid from account where id=:acctID];
               
               if (actOld.parentid != acct.parentId) {
                   
                   for(Account gpAcct:[select id from account where id=:acct.parentId and recordtype.developername!='GrandParent'])
                     throw new CustException('The Parent Being Related Should Be A GrandParent');
                   
                   gRelHist.GrandParent_ID__c=acct.parentID;
                   gRelHist.start_Date__c=DateTime.Now();
                   gRelHist.parent_ID__c=acctID;
                   
                   for (GP_Rel_History__c g:[select id,end_date__c from GP_Rel_History__c where Parent_ID__C=:acctID and end_date__c=null]) {
                        g.end_date__c=DateTime.now();
                        update g;
                   }
                   
                   insert gRelHist;
                   acct.Requestor_Id__c=gRelHist.Requestor__c;
                   user usr=[select id,Name from user where id=:gRelHist.Requestor__c];
                   acct.Requestor_Name__c=usr.Name;
                   update acct;
               }
               
               return new PageReference('/'+acctID);
               
         }
          catch(custException ce) {
              system.debug('Error:' + ce);
              ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,ce.getMessage()));
              return null;

      }
       catch(Exception ex){
         ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.ERROR,'Unexpected Exception:' + ex));
         return null;
        }
         
     }
     
}