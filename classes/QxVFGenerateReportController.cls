public class QxVFGenerateReportController {
    
    /** Number of iterations to wait for report actions to be loaded */
    private static final Integer GET_REPORT_ACTIONS_MAX_RETRIES = 3;
    
    /** Number of seconds to wait between each iteration */
    private static final Integer GET_REPORT_STATE_RETRIES_DELAY = 2;
    
    /** Number of iterations to wait for a report to be in "Ready" state after creation */
    private static final Integer GET_REPORT_STATE_MAX_RETRIES = 10;
    
    /** User's locale */    
    private static final String LOCALE = UserInfo.getLocale();
    
    /*public static String reportId;

public static String sessionId;*/
    
    
    @future(callout = true)
    public static void generateReport(String quoteId, String label){
        
        String sessionId = '';
        if(!Test.isRunningTest())
           sessionId = createSession();
        String language =  LOCALE.substring(0, 2);
        String country =  LOCALE.substring(3, 5);
        List<CameleonCPQ.QxApiClient.QuoteAction> actions = getQuoteReportActions(sessionId,quoteId,language, country);
       	List<CameleonCPQ.QxApiClient.GetQuoteReportResponse> reportLst = new List<CameleonCPQ.QxApiClient.GetQuoteReportResponse>();
        List<Id> qtIds = new List<Id>();
        List<String> actionList = new List<String>();
        for(CameleonCPQ.QxApiClient.QuoteAction qa : actions){
            System.debug('Action :'+qa.Label);
            if(qa.label == label){
                CameleonCPQ.QxApiClient.GenerateQuoteReportResponse response = new CameleonCPQ.QxApiClient.GenerateQuoteReportResponse ();
                response = createReport(sessionId, quoteId, qa.name);
                String reportId = response.reportId;
                System.debug('Action2 :'+qa.name);
                CameleonCPQ.QxApiClient.GetQuoteReportStatusResponse gqrStatusResponse = getReportStatus(sessionId, quoteId, reportId);
                if(CameleonCPQ.QxApiClient.ReportStatus.Ready.name().equalsIgnoreCase(gqrStatusResponse.status))
                {
                    CameleonCPQ.QxApiClient.GetQuoteReportResponse report = getQuoteReport(sessionId, quoteId, reportId);
                    reportLst.add(report);
                    qtIds.add(quoteId);
                    actionList.add(qa.label);
                 //   createAttachment( report.reportBody,quoteId, report.fileType, '');
                    /*if(fileContentVersion !== new ContentVersion())
{
createDocumentLink(quoteId, fileContentVersion);
}*/
                }
            }
        }
        for(Integer i=0;i<qtIds.size();i++){
            ContentVersion fileContentVersion = createAttachment( reportLst[i].reportBody,qtIds[i], reportLst[i].fileType, actionList[i]);
                if(fileContentVersion !== new ContentVersion())
                {
                    createDocumentLink(qtIds[i], fileContentVersion);
                }
        }
    }
    
    public static List<CameleonCPQ.QxApiClient.QuoteAction> getQuoteReportActions(String qxSessionId, String quoteId, String language, String country){
        CameleonCPQ.QxApiClient.QuoteActionType.values();
        final CameleonCPQ.QxApiClient.GetQuoteActionsRequest apiRARequest = new CameleonCPQ.QxApiClient.GetQuoteActionsRequest();
        final CameleonCPQ.QxApiClient.QxRequestContext qxRequestContext = new CameleonCPQ.QxApiClient.QxRequestContext();
        //final CameleonCPQ.QxApiClient.QuoteActionType actionType = new CameleonCPQ.QxApiClient.QuoteActionType();
        qxRequestContext.crmQuoteId = quoteId;
        qxRequestContext.sessionId = qxSessionId;
        qxRequestContext.locale = language+'_'+country;
        apiRARequest.qxReqCtx = qxRequestContext;
        apiRARequest.actionType = CameleonCPQ.QxApiClient.QuoteActionType.REPORT;
        //apiRARequest.language = language;
        //apiRARequest.country = country;
        Integer retries = 0;
        while (retries++ < GET_REPORT_ACTIONS_MAX_RETRIES) {
            final CameleonCPQ.QxApiClient.GetQuoteActionsResponse apiRAResponse = CameleonCPQ.QxApiClient.getQuoteActions(apiRARequest);
            
            if (apiRAResponse.statusCode==200) {
                system.debug('ACTIONS ' + apiRAResponse.actions);
                
                return apiRAResponse.actions;
            }
            else {
                sleep(GET_REPORT_STATE_RETRIES_DELAY * 1000);
                System.debug(LoggingLevel.INFO, 'Retrying...('+retries+')');
            }    
        }
        return null;
        // throw new QuoteReportException('getQuoteState() max retries limit exceeded'); 
    }
    
    public static CameleonCPQ.QxApiClient.GenerateQuoteReportResponse createReport(String sessionId, String quoteId, String actionName) {
        final CameleonCPQ.QxApiClient.GenerateQuoteReportBody apiRequestForReport = new CameleonCPQ.QxApiClient.GenerateQuoteReportBody();
        apiRequestForReport.actionName = actionName;
        final CameleonCPQ.QxApiClient.QxRequestContext qxRequestContext = new CameleonCPQ.QxApiClient.QxRequestContext();
        qxRequestContext.crmQuoteId = quoteId;
        qxRequestContext.sessionId = sessionId;
        final CameleonCPQ.QxApiClient.GenerateQuoteReportRequest apiCRRequest = new CameleonCPQ.QxApiClient.GenerateQuoteReportRequest();
        apiCRRequest.qxReqCtx = qxRequestContext;
        apiCRRequest.requestBody = apiRequestForReport;
        final CameleonCPQ.QxApiClient.GenerateQuoteReportResponse apiCRResponse = CameleonCPQ.QxApiClient.generateQuoteReport(apiCRRequest);
        System.debug('Action-2');
        if (apiCRResponse.statusCode!=200) {
            //throw new QuoteReportException(apiCRResponse.qxException);
            System.debug('ERROR :'+apiCRResponse);
        }
        //reportId = apiCRResponse.reportId;
        return apiCRResponse;
    }
    
    public static CameleonCPQ.QxApiClient.GetQuoteReportStatusResponse getReportStatus(String sessionId, String quoteId, String reportId) {
        final CameleonCPQ.QxApiClient.GetQuoteReportStatusRequest apiRSRequest = new CameleonCPQ.QxApiClient.GetQuoteReportStatusRequest();
        final CameleonCPQ.QxApiClient.QxRequestContext qxRequestContext = new CameleonCPQ.QxApiClient.QxRequestContext();
        qxRequestContext.crmQuoteId = quoteId;
        qxRequestContext.sessionId = sessionId;
        apiRSRequest.qxReqCtx = qxRequestContext;
        apiRSRequest.reportId = reportId;
        Integer retries = 0;
        System.debug('Action-3');
        while (retries++ < GET_REPORT_STATE_MAX_RETRIES) {
            final CameleonCPQ.QxApiClient.GetQuoteReportStatusResponse apiRSResponse = CameleonCPQ.QxApiClient.getQuoteReportStatus(apiRSRequest);
            
            if (apiRSResponse.statusCode==200) {
                if(CameleonCPQ.QxApiClient.ReportStatus.Ready.name().equalsIgnoreCase(apiRSResponse.status)) {
                    return apiRSResponse;
                }
                sleep(GET_REPORT_STATE_RETRIES_DELAY * 1000);
                System.debug(LoggingLevel.INFO, 'Retrying...('+retries+')');
            }
            else {
                //throw new CameleonCPQ.QuoteReportException(apiRSResponse.qxException);
            }    
        }
        return null;
        //throw new CameleonCPQ.QuoteReportException('getQuoteReportStatus() max retries limit exceeded');
    }  
    
    public static CameleonCPQ.QxApiClient.GetQuoteReportResponse getQuoteReport(String qxSessionId, String quoteId, String reportId) {
        final CameleonCPQ.QxApiClient.GetQuoteReportRequest apiGRRequest = new CameleonCPQ.QxApiClient.GetQuoteReportRequest();
        final CameleonCPQ.QxApiClient.QxRequestContext qxRequestContext = new CameleonCPQ.QxApiClient.QxRequestContext();
        qxRequestContext.crmQuoteId = quoteId;
        qxRequestContext.sessionId = qxSessionId;
        apiGRRequest.qxReqCtx = qxRequestContext;
        apiGRRequest.reportId = reportId;
        final CameleonCPQ.QxApiClient.GetQuoteReportResponse apiGRResponse =CameleonCPQ.QxApiClient.getQuoteReport(apiGRRequest);
        if (apiGRResponse.statusCode!=200) {
            // throw new CameleonCPQ.QuoteReportException(apiGRResponse.qxException);
        }
        return apiGRResponse;
    }
    
   // @future(callout = true)
    public static ContentVersion createAttachment(Blob fileContent, String recordId, String fileType, String actionName){
        CameleonCPQ__QxQuote__c nameOfQuote= [Select Name,Customer_communication_requirements__c FROM CameleonCPQ__QxQuote__c WHERE id=:recordId LIMIT: 1];
        
        String UniqueName = nameOfQuote.Name + ' ' + actionName + ' ' + DateTime.now().format('yyyy-MM-dd');
        UniqueName = UniqueName.trim();
        ContentVersion contentVersion = new contentVersion();
        contentVersion.Title = UniqueName;
        contentVersion.PathOnClient = UniqueName + fileType.removeEnd('"');
        System.debug('Action-1 :'+UniqueName + fileType);
        string paramvalue = EncodingUtil.base64Encode(fileContent);
        Blob afterblob = EncodingUtil.base64Decode(paramvalue);
       // system.debug(afterblob);
      //  system.debug(paramvalue);
        contentVersion.VersionData = afterblob;
        contentVersion.IsMajorVersion = true;
        try
        {
            System.debug('Action-1 :'+actionName+'  '+fileType.contains('pdf'));
           insert contentVersion;
          //  insert contentVersion;
             /*if(nameOfQuote.Customer_communication_requirements__c == 'Notification'){
                 System.debug('PDF-4');
                if(fileType.contains('pdf') && actionName == 'Customer Notification'){
                    System.debug('PDF-1');
                	nameOfQuote.Customer_Doc_ID__c = contentVersion.Id;
                }
            }
            else if(nameOfQuote.Customer_communication_requirements__c == 'Notification & Approval'){
                System.debug('PDF-5');
                 if(fileType.contains('pdf') && actionName == 'Customer Approval'){
                     System.debug('PDF-2');
                 	nameOfQuote.Customer_Doc_ID__c = contentVersion.Id;
                }
            }
            else{
                System.debug('PDF-7 '+fileType.contains('pdf')+'   '+actionName);
                if(fileType.contains('pdf') && actionName == 'Core Exhibit'){
                    System.debug('PDF-3');
                	nameOfQuote.Customer_Doc_ID__c = contentVersion.Id;
                }
            }*/            
            System.debug('PDF-7 '+fileType.contains('pdf')+'   '+actionName);
            if(fileType.contains('pdf') && actionName == 'Customer Copy'){
                System.debug('PDF-3');
                //nameOfQuote.Customer_Doc_ID__c = contentVersion.Id;
            }
            
           // nameOfQuote.Customer_Doc_ID__c = contentVersion.Id;
            
           // update nameOfQuote;
            return contentVersion;
        }
        catch(DmlException e)
        {
            System.debug('Exception :'+e);
            System.debug('Exception :'+e.getStackTraceString());
            return new ContentVersion();
        }
        
       
    }
    
    public static void createDocumentLink(String recordId, ContentVersion contentVersion)
    {
         try
        {
            Id contentDoc = [SELECT ContentDocumentId FROM ContentVersion Where Id =:contentVersion.Id].ContentDocumentId;
            
            ContentDocumentLink contentDocumentLink = new ContentDocumentLink();
            contentDocumentLink.LinkedEntityId = recordId;
            contentDocumentLink.ContentDocumentId = contentDoc;
            contentDocumentLink.ShareType = 'I';
            contentDocumentLink.Visibility = 'AllUsers';
            
            insert contentDocumentLink;
        }
        catch(DmlException e)
        {
            
        }
        
    }
    
    public static String createSession(){
        CameleonCPQ.QxApiClient.InitSessionResponse session = CameleonCPQ.QxApiClient.initSession(new CameleonCPQ.QxApiClient.InitSessionRequest());
        //sessionId = session.sessionId;
        return session.sessionId;
    }
    
    public static void sleep(final Integer milliseconds) {
        final Long delayStart = System.now().getTime();
        while (System.now().getTime() < delayStart + milliseconds) {}
    }
}