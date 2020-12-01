public with sharing class CrossRefMaster {

    @AuraEnabled(cacheable=true)
    public static List<CrossRefRecords> getCrossRefRecords(String searchCriteria){       
        
        String accessToken;
        if(Test.isRunningTest()){
            accessToken = 'aereroe--Some long text';
        }
        else
            accessToken = CrossRefGetAccessToken.getAccessToken(); 
        
        if(accessToken != null) 
        {
            HttpRequest request = new HttpRequest();
            request.setEndpoint('callout:SFDC_Alternates/api/v1/control/xref/masterSearch');
            request.setMethod('PUT');
            request.setHeader('Content-Type','application/json');
            request.setHeader('Authorization', 'Bearer ' + accessToken);
            request.setBody(searchCriteria);
            
            system.debug('Test Body-->'+searchCriteria);
            Http http = new Http();
            HTTPResponse response = http.send(request);
            
            String crossRefMasterResponse = response.getBody();
            system.debug('Test Response-->'+crossRefMasterResponse);
            
            List<CrossRefRecords> crossRefRecord = (List<CrossRefRecords>)JSON.deserialize( crossRefMasterResponse , List<CrossRefRecords>.class);
            return crossRefRecord;
         }
          else
           	 return null;
    }
    
    
    @AuraEnabled(cacheable=true)
    public static String addCrossRefRecords(String payLoad){       
        
        String accessToken;
        if(Test.isRunningTest()){
            accessToken = 'aereroe--Some long text';
        }
        else
            accessToken = CrossRefGetAccessToken.getAccessToken(); 
        
        if(accessToken != null) 
        {
            HttpRequest request = new HttpRequest();
            request.setEndpoint('callout:SFDC_Alternates/api/v1/control/xref/masterAdd');
            request.setMethod('PUT');
            request.setHeader('Content-Type','application/json');
            request.setHeader('Authorization', 'Bearer ' + accessToken);
            system.debug('Test-->'+payLoad);
            request.setBody(payLoad);
            
            Http http = new Http();
            HTTPResponse response = http.send(request);
            
            String crossRefMasterResponse = response.getBody(); 
            
            
            if(crossRefMasterResponse.contains('duplicate key value violates unique constraint') || crossRefMasterResponse.contains('Unconsumed column names') || crossRefMasterResponse.contains('violates not-null constraint') || response.getStatusCode() == 500)
            {
                if(crossRefMasterResponse.contains('duplicate key value violates unique constraint'))
                    return 'Duplicate Key Violation';
                else if(crossRefMasterResponse.contains('Unconsumed column names'))
                    return 'Unconsumed Columns';
                else if(crossRefMasterResponse.contains('violates not-null constraint'))
                    return 'Source,CustomerQPU,CustomerUOM,Od_Xref,CrossMatchDetails and Competitor Name cannot be Null';
                else
                    return 'Error Occurred';
            }
            else
                return 'Success'; 
         }
          else
           	 return null;
    }
    
    @AuraEnabled(cacheable=true)
    public static String deleteCrossRefRecords(String payLoad){       
        
        String accessToken;
        if(Test.isRunningTest()){
            accessToken = 'aereroe--Some long text';
        }
        else
            accessToken = CrossRefGetAccessToken.getAccessToken(); 
        
        if(accessToken != null) 
        {
            HttpRequest request = new HttpRequest();
            request.setEndpoint('callout:SFDC_Alternates/api/v1/control/xref/masterDelete');
            request.setMethod('DELETE');
            request.setHeader('Content-Type','application/json');
            request.setHeader('Authorization', 'Bearer ' + accessToken);
            system.debug('Test-->'+payLoad);
            request.setBody(payLoad);
            
            Http http = new Http();
            HTTPResponse response = http.send(request);
            
            String crossRefMasterResponse = response.getBody(); 
            
            
            if(response.getStatusCode() == 500)
            	return 'Error';
            else
                return 'Success'; 
         }
          else
           	 return null;
    }
    
    
    @AuraEnabled(cacheable=true)
    public static String updateCrossRefRecords(String payLoad){       
        
        String accessToken;
        if(Test.isRunningTest()){
            accessToken = 'aereroe--Some long text';
        }
        else
            accessToken = CrossRefGetAccessToken.getAccessToken();  
        
        if(accessToken != null) 
        {
            HttpRequest request = new HttpRequest();
            request.setEndpoint('callout:SFDC_Alternates/api/v1/control/xref/masterEdit');
            request.setMethod('PUT');
            request.setHeader('Content-Type','application/json');
            request.setHeader('Authorization', 'Bearer ' + accessToken);
            request.setBody(payLoad);
            system.debug('Test-->'+payLoad);
            
            Http http = new Http();
            HTTPResponse response = http.send(request);
            
            String crossRefMasterResponse = response.getBody(); 
            
            
            if(response.getStatusCode() == 500)
                return 'Error';
            else
                return 'Success'; 
         }
          else
           	 return null;
    }


//File Upload to s3
//Developer:Roselin; Dt:5/15/2020
//Application: Item Xref - Master Maintenance

    @AuraEnabled
    public static void saveFile(String strFileName, String base64Data) {
            
            String fileContent = base64Data;
            try {
                //String parentId = idParent;
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
                String filename =  strFileName +'_' + dateString;
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
                HTTPResponse res = http.send(req);
        
                System.debug('*Resp:' + String.ValueOF(res.getBody()));
                System.debug('RESPONSE STRING: ' + res.toString());
                System.debug('RESPONSE STATUS: ' + res.getStatus());
                System.debug('STATUS_CODE: ' + res.getStatusCode());
                
                ControlRecord rec = new ControlRecord();
                rec.file_id = filename;
                rec.file_name = filename;
                rec.file_source = 's3';
                rec.status = 'Processing';
                rec.created_by_id = UserInfo.getName();
                            
                String ctrlRecJson = addControlRecord(rec);
                ControlRecord controlRecord = (ControlRecord)JSON.deserialize( ctrlRecJson , ControlRecord.class);
                system.debug('control record = ' + controlRecord.reference_id);
                
                sendRefIdToProcessMaster(controlRecord.reference_id);
                
            	}   
        catch  (Exception ex) {
               System.debug('exception is ' + ex.getMessage());
               }
    }
    
    //Add control record to the Maintenance table
    @AuraEnabled    
    public static String addControlRecord(ControlRecord cRec) {
            
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
                req.setEndpoint('callout:SFDC_Alternates/api/v1/control/master/upload/');
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
    
    //Get the uploaded file list to display
    @AuraEnabled
        public static List<ControlRecord> getControlRecords(){
                  
            String receivedAccessToken;
            if(Test.isRunningTest()){
                receivedAccessToken = 'aereroe--Some long text';
            }
            else
                receivedAccessToken = CrossRefGetAccessToken.getAccessToken();           
            if(receivedAccessToken != null) 
            {
                HttpRequest req = new HttpRequest();
                req.setEndpoint('callout:SFDC_Alternates/api/v1/control/masterfileuploadlist/'); 
                req.setMethod('GET');
                req.setHeader('Authorization', 'Bearer ' + receivedAccessToken);
                Http http = new Http();
                HTTPResponse res = http.send(req);            
                String controlListResponse = res.getBody();
                system.debug('test result get-->'+controlListResponse);
                
                List<ControlRecord> controlRecordList = (List<ControlRecord>)JSON.deserialize( controlListResponse , List<ControlRecord>.class);
                	for(ControlRecord ctrlRec : controlRecordList){
                       //ctrlRec.resultLink = ctrlRec.reference_id; 
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
    
    //Send the reference Id to  process
    
    @AuraEnabled
    public static String sendRefIdToProcessMaster(String referenceId){
   
        String receivedAccessToken;
            if(Test.isRunningTest()){
                receivedAccessToken = 'aereroe--Some long text';
            }
            else
                receivedAccessToken = CrossRefGetAccessToken.getAccessToken();           
        if(receivedAccessToken != null){
         	HttpRequest req = new HttpRequest();
            req.setEndpoint('callout:SFDC_Alternates/api/v1/control/process/master/reference_id/'+ referenceId);   
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
    
    @AuraEnabled
    public static List<ErrorMessageRecord> getErrorRecords(String referenceId){
   		System.debug('referenceId============='+ referenceId);
        String receivedAccessToken;
        if(Test.isRunningTest()){
            receivedAccessToken = 'aereroe--Some long text';
        }
        else
            receivedAccessToken = CrossRefGetAccessToken.getAccessToken();  
		String statusReceived;        
        if(receivedAccessToken != null){
         	HttpRequest req = new HttpRequest();
            req.setEndpoint('callout:SFDC_Alternates/api/v1/control/MastervalidationErrors/'+ referenceId);   
            req.setMethod('GET');
            req.setHeader('Authorization', 'Bearer ' + receivedAccessToken);
            Http http = new Http();
            HTTPResponse res = http.send(req);            
           
            String testResponse = res.getBody();
             system.debug('test -->'+ testResponse);
            
            List<ErrorMessageRecord> finaList = (List<ErrorMessageRecord>)
                JSON.deserialize(testResponse, List<ErrorMessageRecord>.class);
            system.debug('test -->'+ 'Error');
            return finaList;
        }
        else
           	 return null;
        
    }
   /* 
     @AuraEnabled
    public static boolean getisMasterMaintAllowed() {
        List<Master_Maintenance_Visibility__mdt> metadataList = [Select Id,Profile_Id__c From Master_Maintenance_Visibility__mdt where Profile_Id__c = :UserInfo.getProfileId()];
        if (metadataList != null && metadataList.size() >= 1){
            return false;
        } else 
            return true;
    }
   */ 
      
    //Variables for file upload     
    public class ControlRecord {
            @AuraEnabled public String file_id;
            @AuraEnabled public String file_name;
            @AuraEnabled public String file_source;
            @AuraEnabled public String status;
            @AuraEnabled public String created_by_id;
            @AuraEnabled public String sys_created_date;
            @AuraEnabled public String reference_id;
            @AuraEnabled public String resultLink;
            @AuraEnabled public String reason;
    }
    
    public class ErrorMessageRecord {
        @AuraEnabled public String reference_id;
        @AuraEnabled public String status;
        @AuraEnabled public String message;
        
    } 
    
    public class CrossRefRecords {
            @AuraEnabled public String orig_item;
            @AuraEnabled public String competitor;
            @AuraEnabled public String customer_uom;
            @AuraEnabled public String customer_qpu;
            @AuraEnabled public String vendor_source;
            @AuraEnabled public String cross_match_type;
            @AuraEnabled public String od_xref;
            @AuraEnabled public String corr_uom;
            @AuraEnabled public Integer corr_qpu;
            @AuraEnabled public String cross_notes_detail;
        	@AuraEnabled public String last_updated_id;
            @AuraEnabled public String sys_modified_date;
    }      
}