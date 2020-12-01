/* Added By Mohit Bansal
This class is not required, as the logic is changed and code is added on Pending approval Page only */


public class ACEApprovalPageController 
{
    public String BatchName{get;set;}
    public String CustID{get;set;}
    public String Comments{get;set;}
    
    public ACEApprovalPageController()
    {
        batchName = ApexPages.currentPage().getParameters().get('batchname');
        CustID = ApexPages.currentPage().getParameters().get('custid');
        
    }
    
    public PageReference ApproveFunc()
    {
        ACE_RECALL_APPROVAL_PROCESS.ACEApprRejMethod(CustID,Comments,'Approve');
        
        // PageReference pg = new PageReference('/apex/ACE_Summary_Grid_New?batch=' +batchname);
        PageReference pg = new PageReference('/apex/ACE_Landing_Page');
            
        pg.setRedirect(true);
        return pg;
    }
    
    public PageReference RejectFunc()
    {
        ACE_RECALL_APPROVAL_PROCESS.ACEApprRejMethod(CustID,Comments,'Reject');
        
        // PageReference pg = new PageReference('/apex/ACE_Summary_Grid_New?batch=' +batchname);
        PageReference pg = new PageReference('/apex/ACE_Landing_Page');
        pg.setRedirect(true);
        return pg;
    }
     
     
    public PageReference Cancel()
    {
        // PageReference pg = new PageReference('/apex/ACE_Summary_Grid_New?batch=' +batchname);
        PageReference pg = new PageReference('/apex/ACE_Landing_Page');
        pg.setRedirect(true);
        return pg;
    }
      
    
}