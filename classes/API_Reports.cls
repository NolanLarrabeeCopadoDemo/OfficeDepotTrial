// This class contains web service methods thats called to return Account and Case Information
@RestResource(urlMapping='/api/Reports/*')
global class API_Reports {

    //This methods takes parameter on which report is needed and calls the method accordingly. Its a Get call
     @HttpGet
    global static List<sObject>  doGet() 
    {
         RestRequest req = RestContext.request;
         RestResponse res = RestContext.response;
         String ReportName = req.params.get('Report_Name');
         //for report GetLinkageAccountsByDateRange
         if(ReportName=='GetLinkageAccountsByDateRange')
         {
             Date FromDate = Date.Parse(req.params.get('FromDate'));
             Date ToDate   = Date.Parse(req.params.get('ToDate'));
             Return  API_Reports.GetLinkageAccountsByDateRange(FromDate,ToDate);
         }
        //for report GetLinkageAccountContactsByDateRange
         if(ReportName=='GetLinkageAccountContactsByDateRange')
         {
             Date FromDate = Date.Parse(req.params.get('FromDate'));
             Date ToDate   = Date.Parse(req.params.get('ToDate'));
             Return  API_Reports.GetLinkageAccountContactsByDateRange(FromDate,ToDate);
         }
         //for report GetCasesByTypeAndStatus       
         if(ReportName=='GetCasesByTypeAndStatus')
         {
             String QueueName = req.params.get('QueueName');
             String Type      = req.params.get('Type');
             String Status    = req.params.get('Status');
             Return  API_Reports.GetCasesByTypeAndStatus(QueueName,Status,Type);
         }
         
        Return null;
    }
    //This methods calls method to update Case Data .Its a Post call
    @HttpPost
    global static String UpdateCaseStatusById_Post(String Report_Name,String CaseId,String Status,String QueueName,String SupportComments) {
      
       if(Report_Name=='UpdateCaseStatusByID')
          Return API_Reports.UpdateCaseStatusByID(CaseId,Status,QueueName,SupportComments);
        
        Return Null;  
    }
    
    Public static List<Account> GetLinkageAccountsByDateRange(Date FromDate,Date ToDate) {
      Return [SELECT  Oracle_Party_ID__c,AOPS_Cust_Id__c,Name,Address1__c,Address2__c,City__c,State__c,
                      Zip_5digit__c,Open_Opp_Amt__c,
                      (SELECT Name FROM Accounts3__r 
                        WHERE (OPERATION__c = 'E') OR ( OPERATION__c ='S') 
                                                   OR ( OPERATION__c ='I')
                        ) 
             FROM account 
             WHERE Payment_Term__c='Account Billing' 
                 AND AOPS_Cust_Id__c != null 
                 AND Oracle_Party_ID__c != null 
                 AND CreatedDate >=:FromDate
                 AND CreatedDate<=:ToDate];
    }
   //This methods gets the linked Contracts for the account for a given range 
    Public static List<Account> GetLinkageAccountContactsByDateRange(Date FromDate,Date ToDate) {        
         Return [SELECT Oracle_Party_ID__c,AOPS_Cust_Id__c,Name,
                     (SELECT ContractNumber,Payment_Terms__c 
                       FROM Contracts) 
                 FROM account 
                 WHERE Payment_Term__c='Account Billing' 
                    AND AOPS_Cust_Id__c != null 
                    AND Oracle_Party_ID__c != null 
                    AND CreatedDate >=:FromDate
                    AND CreatedDate<=:ToDate];
                    
    }
    //This methods gets the Cases by queried Parameters   
    Public Static List<Case> GetCasesByTypeAndStatus(String sQueueName,String sStatus,String sType)
    {
        
        Return [SELECT CaseNumber,Type,Status,Subject,Description,Account.AOPS_Cust_Id__c,Support_Type__c,Support_Sub_Type__c 
                FROM Case 
                WHERE //Type=:sType
                 Status=:sStatus
                AND Ownerid IN (SELECT Id 
                              FROM Group 
                              WHERE  Type = 'Queue' 
                               AND NAME =:sQueueName)];
                
    }
     //This methods Updates the Case   
    Public Static  String UpdateCaseStatusByID(String CaseId,String sStatus,String sQueueName,String sSupportComments)
    {
      
        Set<String> sStatusProcess=New Set<String>{'New','Case Review','In Progress', 'Closed'};
        
        
        if((sQueueName=='AR Billing Bot Queue' || sQueueName=='AR Credit Queue') &&  !sStatusProcess.Contains(sStatus))
                  Return 'Not a Valid Input Status';   
        else
        {  
       
            List<Group> QueueId=[SELECT Id from Group WHERE Type = 'Queue' AND NAME =:sQueueName];
            
            
             if(QueueId.size()>0)
             {
                 Case C=[SELECT Id,Status,OwnerId
                        FROM Case 
                        WHERE Id=:CaseId];
                        
                 C.Status=sStatus;
                 C.OwnerId=QueueId[0].Id;
                 
                 Update C;
              
                 if(String.isNotEmpty(sSupportComments))
                 {
                        CaseComment CC=New CaseComment();
                        CC.CommentBody=sSupportComments;
                        CC.ParentId = C.Id;
                        Insert CC;
                     
                 }
            
             }
             else
                  Return 'Invalid Queue Name'; 
          }
         Return Null;
         
        
    }
}