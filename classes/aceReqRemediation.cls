public class aceReqRemediation{
    public ID aceCustomerPriceChangesID;
    public ACE_Customer_Price_Changes__c custRec;
    public String CustName{get;set;}
    public String CustNum{get;set;}
    public String ReqReason{get;set;}
    public String Comments{get;set;}
    
    public aceReqRemediation(ApexPages.StandardController controller){
    
        aceCustomerPriceChangesID = ApexPages.CurrentPage().getParameters().get('pid');
        
        custRec = new  ACE_Customer_Price_Changes__c();
        custRec = [select id,   Remediation_Request_User__c,Customer__r.AOPS_Cust_Id__c,Customer__r.Name,IsRemediation__c,Remedy_Status__c from ACE_Customer_Price_Changes__c where id=:aceCustomerPriceChangesID];
        
        CustName = custRec.Customer__r.Name;
        CustNum = custRec.Customer__r.AOPS_Cust_Id__c;
    }
    
    public PageReference ReqRemediation(){     
        PageReference pr;   
        //custRec.IsRemediation__c = true;
        custRec.Remedy_Status__c = 'Pending';
        custRec.L1_Mgr_Approval_Start_Date__c = date.today();
        custRec.Remediation_Request_User__c = UserInfo.getUserId();
        update custRec;
        pr = new PageReference('/'+aceCustomerPriceChangesID);        
        pr.setRedirect(true);
        return pr;
    }
}