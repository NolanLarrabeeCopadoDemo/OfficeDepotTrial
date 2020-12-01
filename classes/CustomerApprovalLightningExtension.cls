public without sharing class  CustomerApprovalLightningExtension {
    @AuraEnabled 
    public static CameleonCPQ__QxQuote__c  getInitHelper (String recordId) {
        List<CameleonCPQ__QxQuote__c> lstOfProsQuo = new List<CameleonCPQ__QxQuote__c>();
        CameleonCPQ__QxQuote__c QuoRec =[SELECT Id,Customer_email__c,Document_Downloadable_URL__c,Send_for_Customer_Approval__c,OpportunityId__c,Customer_Approval_Received_Date__c,
                                         OpportunityId__r.AccountId,Core_Id__c,Customer_Approval_Status__c,CameleonCPQ__Status__c,Customer_approval_is_received__c,
                                         Primary_Quote__c,Customer_Approval_is_Required__c ,Approved_By_Rejected_By__c,Approval_Rejection_Comments__c,
                                         CameleonCPQ__AccountId__c ,Quote_Number__c,CameleonCPQ__AccountId__r.Name,CameleonCPQ__AccountId__r.Cust_ID__c,DOA_Approval_Status__c,Customer_communication_requirements__c,LastModifiedById, 
                                         Send_for_Customer_Notification__c, Customer_Approval_1st_reminder__c, Customer_Approval_2nd_reminder__c,
                                         Send_Date_for_Customer_Approval__c,Count_Line_For_Customer_Copy__c, Customer_Response__c,Customer_Doc_ID__c
                                         FROM CameleonCPQ__QxQuote__c 
                                         WHERE id =: recordId];        
        if(QuoRec.Customer_Doc_ID__c  != null)    {
            system.debug('the customer doc id is not null');
            contentdistribution c= [select contentdocumentid,ContentDownloadUrl,DistributionPublicUrl from contentdistribution where contentdocumentid = : QuoRec.Customer_Doc_ID__c limit 1];
            if(c!=null) {
                QuoRec.Document_Downloadable_URL__c=c.DistributionPublicUrl;
                lstOfProsQuo.add(QuoRec);      
            }
        } else
        {
            system.debug('the customer doc id is null');
            contentdocumentlink contntDocmntLnk = [select Id,ContentDocumentId from contentdocumentlink where LinkedEntityId = :QuoRec.Id order by SystemModstamp desc limit 1];    
            contentdistribution c= [select contentdocumentid,ContentDownloadUrl,DistributionPublicUrl from contentdistribution where contentdocumentid = : contntDocmntLnk.ContentDocumentId limit 1];
            QuoRec.Document_Downloadable_URL__c=c.DistributionPublicUrl;
            lstOfProsQuo.add(QuoRec);
        }
        update lstOfProsQuo;
        system.debug('the quote is:'+QuoRec);
        return QuoRec;
    }
    @AuraEnabled 
    public static CameleonCPQ__QxQuote__c  getProsDetails (String recordId) {
        CameleonCPQ__QxQuote__c pros = [select id ,Customer_approval_is_received__c,Count_Line_For_Customer_Copy__c,Customer_Approval_Status__c,Customer_Response__c,Default_Parent__r.Name,Default_Grandparent__r.Name,Default_Great_Grandparent__r.Name,DOA_Custom_Price_Increase_Flag__c,DOA_Custom_Price_More_Inherited_Flag__c,DOA_Price_Freeze_Violation__c,Documentation_required_to_participate__c,Customer_communication_requirements__c,Grandparent__r.Name,Great_Grandparent__r.Name ,Parent__r.Name ,CameleonCPQ__AccountId__r.Name , CameleonCPQ__AccountId__r.AOPS_Cust_Id__c from CameleonCPQ__QxQuote__c where  id= :recordId];
        system.debug('the pros is:'+pros);
        return pros;
    }
    
    @AuraEnabled
    public Static String Save(String recordId, String CustResp) {
        system.debug('approval is:'+CustResp);
        CameleonCPQ__QxQuote__c cqrec= [Select id,Customer_Approval_Status__c,OpportunityId__c,Customer_Response__c from CameleonCPQ__QxQuote__c where id=:recordId];
        cqrec.Customer_Approval_Status__c ='Approved';
        cqrec.Customer_Response__c = CustResp;
        cqrec.Customer_approval_is_received__c = 'Approved';
        if(cqrec.OpportunityId__c !=null)
        {
            String opi = String.valueOf(cqrec.OpportunityId__c).substring(0, 15);
            List<Opportunity> Opp = [select Id, Account.OwnerId from Opportunity where id=:opi];
            system.debug('Opp is :'+ Opp);
            if(Opp.size()>0){
                Id AccownerId =Opp[0].Account.OwnerId;
                system.debug('AccOwnerId :' + AccownerId);
                List<User> U=[SELECT Id,IsActive,ManagerId FROM User Where id=:AccownerId];
                system.debug('isactive :'+ U[0].IsActive);
                system.debug('mngr Id :'+ U[0].ManagerId);
                if(!U.isEmpty())  
                    cqrec.CustomerApproverRepMail__c= U[0].IsActive?AccownerId:U[0].ManagerId;
            }
        }
        update cqrec;
        return 'SUCCESS';
    }
    @AuraEnabled
    public static String reject (String recordId,String CustResp) {
        CameleonCPQ__QxQuote__c cqrec= [Select id,Customer_Approval_Status__c,Customer_Response__c from CameleonCPQ__QxQuote__c where id=:recordId];
        cqrec.Customer_Approval_Status__c ='Rejected';
        cqrec.Customer_Response__c = CustResp;
        update cqrec;
        return 'Rejected';
    }
    @AuraEnabled
    public static String  requestInformation (String recordId,String CustResp) {
        CameleonCPQ__QxQuote__c cqrec= [Select id,Customer_Approval_Status__c,Customer_Response__c from CameleonCPQ__QxQuote__c where id=:recordId];
        cqrec.Customer_Approval_Status__c ='Requested to be Contacted';
        cqrec.Customer_Response__c = CustResp;
        update cqrec;
        system.debug('cqrec.Customer_Approval_Status__c'+cqrec.Customer_Approval_Status__c);
        return 'Requested to be Contacted';
    }
}