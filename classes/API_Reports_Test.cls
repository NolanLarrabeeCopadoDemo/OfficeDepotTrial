@isTest
public class API_Reports_Test {

    Public Static testmethod void  API_Reports_Method()
    {
        
        Test.startTest();
            List<String> Dates= API_Reports_Test.getDateformats();
            
            // Report Name : GetLinkageAccountsByDateRange
            
            API_Reports_Test.Http_Callout_Method ('GetLinkageAccountsByDateRange',Dates[0],Dates[1]);
            API_Reports.doGet();
            
            // Report Name: GetLinkageAccountContactsByDateRange
            API_Reports_Test.Http_Callout_Method ('GetLinkageAccountContactsByDateRange',Dates[0],Dates[1]);
            API_Reports.doGet();
            
            String sQueueName=API_Reports_Test.CreateGroupQueue();
            
            // Report Name :GetCasesByTypeAndStatus
            API_Reports_Test.Http_Callout_GetCasesByTypeAndStatus(sQueueName,'Open','BILL MAINT');
            API_Reports.doGet();
            
           
           // Report Name: UpdateCaseStatusByID
            System.runAs ( new User(Id = UserInfo.getUserId()) ){
               API_Reports.UpdateCaseStatusById_Post('UpdateCaseStatusByID',API_Reports_Test.InsertCase().Id,'Open',sQueueName,'Test sSupportComments');
           }
            
        Test.stopTest();   
    }
    
    
    Public Static void Http_Callout_Method(String sReportName,String sFromDate,String sTodate)
    {
          
            RestRequest req = new RestRequest(); 
            RestResponse res = new RestResponse();
            req.requestURI = '/services/apexrest/api/Reports'; 
            req.params.put('Report_Name', sReportName);
            req.params.put('FromDate', sFromDate);
            req.params.put('ToDate', sTodate);
            req.httpMethod = 'GET';
            req.addHeader('Content-Type', 'application/json'); 
            RestContext.request = req;
            RestContext.response = res;
    }
    
    Public Static void Http_Callout_GetCasesByTypeAndStatus(String sQueueName,String sStatus,String sType)
    {
            RestRequest req = new RestRequest(); 
            RestResponse res = new RestResponse();
            req.requestURI = '/services/apexrest/api/Reports'; 
            req.params.put('Report_Name', 'GetCasesByTypeAndStatus');
            req.params.put('QueueName', sQueueName);
            req.params.put('Type', sType);
            req.params.put('Status', sStatus);
            req.httpMethod = 'GET';
            req.addHeader('Content-Type', 'application/json'); 
            RestContext.request = req;
            RestContext.response = res;
    }
    
    Public Static List<String> getDateformats()
    {
        String Fromdate = Datetime.now().format('MM/dd/yyyy');
        String Enddate = Datetime.now().adddays(2).format('MM/dd/yyyy');
        Return New List<String>{Fromdate,Enddate};
        
    }
    
    Public Static String CreateGroupQueue()
    {
            Group g1 = new Group(Name='BILLING BOT', type='Queue');
            insert g1;
            QueuesObject q1 = new QueueSObject(QueueID = g1.id, SobjectType = 'Case');
            insert q1;
            
            Return g1.Name;
            
    }
    
    Public Static Case InsertCase()
    {
         Case C=New Case();
            c.Status='Open';
            c.Type='Extension';
            c.Subject='Test Subject';
            c.Description='Test Description';
         Insert C;
         Return C;
    }
}