@isTest
private class GetBase64AttachmentWebService_Test {

    
    static Id case_id;
    static User soa_connection_user = [SELECT Id, Name FROM User WHERE Name='Soa Connection'];
    static List<Case_Message_Route__mdt>  message_routes = [
            SELECT 
                Id, 
                Queue_Developer_Name__c, 
                Remote_Destination__c, 
                Remote_Destination_Id__c 
            FROM Case_Message_Route__mdt
        ];
    
    @isTest public static void requestWithNoAttachmentId() {
        RestRequest request = new RestRequest();
        RestResponse response = new RestResponse();
        
        request.requestURI = '/';
        request.httpMethod = 'GET';
        
        RestContext.request = request;
        RestContext.response = response;
        
        GetBase64AttachmentWebService.doGet();
    }
    
    @isTest public static void requestWithAttachmentId() {
        RestRequest request = new RestRequest();
        RestResponse response = new RestResponse();
        
        request.requestURI = '/' + createTestRecord();
        request.httpMethod = 'GET';
        
        RestContext.request = request;
        RestContext.response = response;
        
        GetBase64AttachmentWebService.doGet();
    }
    
    @isTest public static void requestWithAttachmentIdAndHeaders() {
        RestRequest request = new RestRequest();
        RestResponse response = new RestResponse();
        
        request.requestURI = '/' + createTestRecord();
        request.addHeader('Accept', 'application/xml');
        request.httpMethod = 'GET';
        
        RestContext.request = request;
        RestContext.response = response;
        
        GetBase64AttachmentWebService.doGet();
    }
    
    @isTest public static void generateQueryException() {
        RestRequest request = new RestRequest();
        RestResponse response = new RestResponse();
        
        request.requestURI = '/GenerateAQueryException';
        request.httpMethod = 'GET';
        
        RestContext.request = request;
        RestContext.response = response;
        
        GetBase64AttachmentWebService.doGet();
    }
    
    @isTest public static void generateNullPointerException() {
        RestRequest request = new RestRequest();
        
        request.requestURI = '/GenerateAQueryException';
        request.httpMethod = 'GET';
        
        RestContext.request = request;
        
        boolean throwsException = false;
        try {
        	GetBase64AttachmentWebService.doGet();
        } catch(NullPointerException e) {
            throwsException = true;
        }
        
        System.assertEquals(true, throwsException);
    }
          
    static Id createTestRecord() {

        Set<String> freshdesk_queue_names = new Set<String>();
        Set<String> ocx_queue_names = new Set<String>();
        for(Case_Message_Route__mdt route: message_routes)
            if(route.Remote_Destination__c == 'FRESHDESK')
                freshdesk_queue_names.add(route.Queue_Developer_Name__c);
            else if(route.Remote_Destination__c == 'ORACLECX')
                ocx_queue_names.add(route.Queue_Developer_Name__c);


        List<Group> freshdesk_groups = [SELECT Id, Name, DeveloperName FROM Group WHERE DeveloperName IN :freshdesk_queue_names];
        List<Group> ocx_groups = [SELECT Id, Name, DeveloperName FROM Group WHERE DeveloperName IN :ocx_queue_names];
        
        Case my_case = new Case(
            Subject='Some Test Case',
            Description='This is a big test description.',
            LastModifiedById = UserInfo.getUserId(),
            Remote_Destination__c = 'ORACLECX',
            OracleCX_Id__c = 3,
            OwnerId = ocx_groups[0].Id
        );

        insert my_case;

        Attachment attachmentTest = new Attachment(
            ParentId = my_case.Id,
            Name = 'QConNotes.pdf',
            IsPrivate = false,
            Description = null,
            ContentType = 'application/pdf',
            Body = Blob.valueOf('Hello'));
        insert attachmentTest;
        return attachmentTest.Id;
    }  
}