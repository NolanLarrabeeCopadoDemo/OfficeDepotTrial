public class ItemCrossRef {
 
    @AuraEnabled
    public static void saveFile(Id idParent, String strFileName, String base64Data) {
        
        System.debug('in save file ....' + strFileName);
        String fileContent = base64Data;
        try {
            String parentId = idParent;
            Blob base64Content;
            HttpRequest req = new HttpRequest();
    		if (Test.isRunningTest()) {
                base64Content = Blob.valueof('Some random String');
            } else {
                base64Content = EncodingUtil.base64Decode(EncodingUtil.urlDecode(fileContent, 'UTF-8'));
            }
            String attachmentBody =  fileContent;           
            String formattedDateString = Datetime.now().formatGMT('EEE, dd MMM yyyy HH:mm:ss z');
            String dateString = Datetime.now().format('ddMMYYYYHHmmss');  
            strFileName = strFileName.replace(' ','-');
            String filename =  strFileName +'_' + parentId + '_' + dateString;
            String method = 'PUT';
            String fileType = 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet';
                
            req.setMethod(method);
            req.setEndpoint('callout:AWS_Service_account/sfdc_xref/' + filename);
            req.setHeader('x-amz-server-side-encryption' , 'aws:kms');
            req.setHeader('Access-Control-Allow-Origin', '*');
            req.setHeader('Content-Length', String.valueOf(attachmentBody.length()));
            req.setHeader('Content-Encoding', 'UTF-8');
            req.setHeader('Content-type', fileType);
            req.setHeader('Connection', 'keep-alive');
            req.setHeader('Date', formattedDateString); 
            req.setBodyAsBlob(base64Content);
            
            Http http = new Http();
            HTTPResponse res = null;
            
            if (Test.isRunningTest()) {
                HttpCalloutMock mock = new ItemCrossRefMock('saveFile');
                res = mock.respond(req);
            } else {
                res = http.send(req);
            }
            
            System.debug('*Resp:' + String.ValueOF(res.getBody()));
            System.debug('RESPONSE STRING: ' + res.toString());
            System.debug('RESPONSE STATUS: ' + res.getStatus());
            System.debug('STATUS_CODE: ' + res.getStatusCode());
            
            ControlRecord rec = new ControlRecord();
            rec.quote_id = idParent;
            rec.file_id = filename;
            rec.file_name = filename;
            rec.file_source = 's3';
            rec.status = 'Processing';
            rec.created_by_id = UserInfo.getName();//getUserId();
                        
            String ctrlRecJson = addControlRecord(rec);
            ControlRecord controlRecord = (ControlRecord)JSON.deserialize( ctrlRecJson , ControlRecord.class);
            system.debug('control record = ' + controlRecord.reference_id);
            
            sendRefIdToProcessMatch(controlRecord.reference_id);
            
    	} catch (Exception ex) {	
        	System.debug('exception is ' + ex.getMessage());
        }
    }
    
    private static String addControlRecord(ControlRecord cRec) {
        
		String controlRecJson = JSON.serialize(cRec);
        String receivedAccessToken;
            if(Test.isRunningTest()){
                receivedAccessToken = 'aereroe--Some long text';
            }
            else
                receivedAccessToken = CrossRefGetAccessToken.getAccessToken();           
        if(receivedAccessToken != null) 
        {
            HttpRequest req = new HttpRequest();
           // req.setEndpoint('https://dev-internal.odplabs.com/services/dev-sfdc-alternates-service/api/v1/control/');
            req.setEndpoint('callout:SFDC_Alternates/api/v1/control/');
            req.setMethod('POST');
            req.setHeader('Authorization', 'Bearer ' + receivedAccessToken);
            req.setBody(controlRecJson);
            
            Http http = new Http();
            HTTPResponse res = http.send(req);
            system.debug('test result post-->'+res);
            
            String controlListResponse = res.getBody();
            return controlListResponse;
         }
          else
           	 return null;
    }

    @AuraEnabled
    public static List<ControlRecord> getControlRecordsByQuoteId(Id quoteId){
        String receivedAccessToken;
            if(Test.isRunningTest()){
                receivedAccessToken = 'aereroe--Some long text';
            }
            else
                receivedAccessToken = CrossRefGetAccessToken.getAccessToken();           
        if(receivedAccessToken != null) 
        {
            HttpRequest req = new HttpRequest();
            req.setEndpoint('callout:SFDC_Alternates/api/v1/control/quote_id/'+ quoteId);
            req.setMethod('GET');
            req.setHeader('Authorization', 'Bearer ' + receivedAccessToken);
            
            Http http = new Http();
            HTTPResponse res = null;            
            
            if (Test.isRunningTest()) {
                HttpCalloutMock mock = new ItemCrossRefMock('saveFile');
                res = mock.respond(req);
            } else {
                res = http.send(req);
            }
            
            String controlListResponse = res.getBody();
            system.debug('test result get-->'+controlListResponse);
            
            List<ControlRecord> controlRecordList = (List<ControlRecord>)JSON.deserialize( controlListResponse , List<ControlRecord>.class);
            for(ControlRecord ctrlRec : controlRecordList){
                
                ctrlRec.resultLink = '/c/CrossMatchResultsApp.app?reference_id='+ctrlRec.reference_id+'&FileName='+ctrlRec.file_name.substringBefore('_');
                //ctrlRec.statusLink = ctrlRec.status + '; ' + 'Failed due to wrong file type.';
                if (ctrlRec.file_name != null){
                	ctrlRec.file_name = ctrlRec.file_name.substringBefore('_');
                    ctrlRec.sys_created_date = ctrlRec.sys_created_date.substringBefore('.');
                }
                if (ctrlRec.reason != null){
                    ctrlRec.reason = ctrlRec.reason.replace('***%ERROR%***','');
                }
                
            } 	
            
            return controlRecordList;
         }
          else
           	 return null;
       
    }
    
    @AuraEnabled
    public static String sendRefIdToProcessMatch(String referenceId){
   
        String receivedAccessToken;
            if(Test.isRunningTest()){
                receivedAccessToken = 'aereroe--Some long text';
            }
            else
                receivedAccessToken = CrossRefGetAccessToken.getAccessToken();          
        if(receivedAccessToken != null){
         	HttpRequest req = new HttpRequest();
            req.setEndpoint('callout:SFDC_Alternates/api/v1/control/process/reference_id/'+ referenceId);   
            req.setMethod('POST');
            req.setHeader('Authorization', 'Bearer ' + receivedAccessToken);
            Http http = new Http();
            HTTPResponse res = http.send(req);            
           
            String sendRefId = res.getBody();
             system.debug('test -->'+ sendRefId);
            return sendRefId;
        }
        
        
        else
           	 return null;
        
    }
        
 
    public class ControlRecord {
        @AuraEnabled public String quote_id;
        @AuraEnabled public String file_id;
        @AuraEnabled public String file_name;
        @AuraEnabled public String file_source;
        @AuraEnabled public String status;
        @AuraEnabled public String created_by_id;
        @AuraEnabled public String sys_created_date;
        @AuraEnabled public String reference_id;
        @AuraEnabled public String resultLink;
        @AuraEnabled public String reason;
       // @AuraEnabled public String statusLink;
        
    }  
          
}