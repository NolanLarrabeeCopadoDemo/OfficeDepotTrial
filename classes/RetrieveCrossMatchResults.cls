global with sharing class RetrieveCrossMatchResults {
    
    
    @AuraEnabled(cacheable=true)
    public static List<WrapperClass> getJSONData(String Reference_Id,String Page,String PageNumber) {
        String receivedAccessToken;
        if(Test.isRunningTest()){
            receivedAccessToken = 'aereroe--Some long text';
        }
        else
            receivedAccessToken = CrossRefGetAccessToken.getAccessToken();
        
        if(receivedAccessToken != null) 
        {
            system.debug('access token -->'+receivedAccessToken);
            HttpRequest req = new HttpRequest();
            //req.setEndpoint('callout:Cross_Ref_Results/api/v1/control/exact/'+Reference_Id+'/'+PageNumber+'/'+Page);//'/'+Page+'/'+PageNumber
            req.setEndpoint('callout:SFDC_Alternates/api/v1/control/exact/'+Reference_Id+'/'+PageNumber+'/'+Page);//'/'+Page+'/'+PageNumber
            req.setMethod('GET');
            //req.setClientCertificateName('AuthCert2019');
            req.setHeader('Content-Type','application/json');
            req.setHeader('Authorization', 'Bearer ' + receivedAccessToken);
            system.debug('Before time set test result-->'+req);
            req.settimeout(120000);
            system.debug('After time set test result-->');
            Http http = new Http();
            
            HTTPResponse res = http.send(req);
            
            system.debug('test result-->'+res);
            
            String testResponse;
            // res.getStatus()
            
            List<WrapperClass> finalList = new List<WrapperClass>();
            testResponse = res.getBody();            
            
            List<WrapperClass> finaList = (List<WrapperClass>)
                JSON.deserialize(testResponse, List<WrapperClass>.class);
            system.debug('result-->'+finaList);
            system.debug('I am here');
           
            return finaList;
        }
        else
            return null;
    }
    
    @AuraEnabled(cacheable=true)
    public static List<WrapperClass> getFilteredRecordsData(String Reference_Id,String Page,String PageNumber,String selectedFilter) {
        String receivedAccessToken;
        system.debug('Filter Type -->'+selectedFilter);
        if(Test.isRunningTest()){
            receivedAccessToken = 'aereroe--Some long text';
        }
        else
            receivedAccessToken = CrossRefGetAccessToken.getAccessToken();
        
        if(receivedAccessToken != null) 
        {
            system.debug('access token -->'+receivedAccessToken);
            HttpRequest req = new HttpRequest();
            //req.setEndpoint('callout:Cross_Ref_Results/api/v1/control/getFilterResults/'+Reference_Id+'/'+PageNumber+'/'+Page+'/'+selectedFilter);//'/'+Page+'/'+PageNumber
            req.setEndpoint('callout:SFDC_Alternates/api/v1/control/getFilterResults/'+Reference_Id+'/'+PageNumber+'/'+Page+'/'+selectedFilter);//'/'+Page+'/'+PageNumber
            req.setMethod('GET');
            //req.setClientCertificateName('AuthCert2019');
            req.setHeader('Content-Type','application/json');
            req.setHeader('Authorization', 'Bearer ' + receivedAccessToken);
            req.settimeout(120000);
            Http http = new Http();
            system.debug('test req-->'+ req);
            HTTPResponse res = http.send(req);
            system.debug('test result-->'+res);
            
            String testResponse;
            // res.getStatus()
            
            List<WrapperClass> finalList = new List<WrapperClass>();
            testResponse = res.getBody();            
            
            List<WrapperClass> finaList = (List<WrapperClass>)
                JSON.deserialize(testResponse, List<WrapperClass>.class);
            system.debug('result-->'+finaList);
            system.debug('I am here');
           
            return finaList;
        }
        else
            return null;
    }
    
    @AuraEnabled(cacheable=true)
    public static List<HitRateData> getHitRateData(String Reference_Id) {
        String receivedAccessToken;
        if(Test.isRunningTest()){
            receivedAccessToken = 'aereroe--Some long text';
        }
        else
            receivedAccessToken = CrossRefGetAccessToken.getAccessToken();
        
        if(receivedAccessToken != null) 
        {
            system.debug('access token -->'+receivedAccessToken);
            HttpRequest req = new HttpRequest();
            //req.setEndpoint('callout:Cross_Ref_Results/api/v1/control/exact/getHitRates/'+Reference_Id);//'/'+Page+'/'+PageNumber
            req.setEndpoint('callout:SFDC_Alternates/api/v1/control/exact/getHitRates/'+Reference_Id);//'/'+Page+'/'+PageNumber
            req.setMethod('GET');
            //req.setClientCertificateName('AuthCert2019');
            req.setHeader('Content-Type','application/json');
            req.setHeader('Authorization', 'Bearer ' + receivedAccessToken);
            req.settimeout(120000);
            Http http = new Http();
            HTTPResponse res = http.send(req);
            system.debug('test result-->'+res);
            
            String testResponse;
            // res.getStatus()
            
            testResponse = res.getBody();
            
            
            List<HitRateData> finaList = (List<HitRateData>)
                JSON.deserialize(testResponse, List<HitRateData>.class);
            system.debug('result-->'+finaList);
            return finaList;
        }
        else
            return null;
        
        
    }
    
    @AuraEnabled(cacheable=true)
    public static String addRecommendations(String payLoad) {
        
        String receivedAccessToken;
        if(Test.isRunningTest()){
            receivedAccessToken = 'aereroe--Some long text';
        }
        else
            receivedAccessToken = CrossRefGetAccessToken.getAccessToken();   
        system.debug('Test Payload-->'+payLoad);
        if(receivedAccessToken != null) 
        {
            system.debug('access token -->'+receivedAccessToken);
            HttpRequest req = new HttpRequest();
            //req.setEndpoint('callout:Cross_Ref_Results/api/v1/control/recom/add');
            req.setEndpoint('callout:SFDC_Alternates/api/v1/control/recom/add');
            req.setMethod('PUT');
            //req.setClientCertificateName('AuthCert2019');
            req.setHeader('Content-Type','application/json');
            req.setHeader('Authorization', 'Bearer ' + receivedAccessToken);
            req.setBody(payLoad);
            
            Http http = new Http();
            HTTPResponse res = http.send(req);
            system.debug('test result-->'+res);
            
            String testResponse;
            testResponse = res.getBody();
            
            system.debug('Test Resp-->'+testResponse);  
            if(testResponse.contains('duplicate key value violates unique constraint'))
                return 'Error';
            else
                return 'Success'; 
                
                
                }
        else
            return 'Error';
        
        
    }
    
    @AuraEnabled(cacheable=true)
    public static String updateRecommendations(String payLoad,String refId) {
        
        String receivedAccessToken;
        if(Test.isRunningTest()){
            receivedAccessToken = 'aereroe--Some long text';
        }
        else
            receivedAccessToken = CrossRefGetAccessToken.getAccessToken();   
        system.debug('Test Payload-->'+payLoad);
        if(receivedAccessToken != null) 
        {
            system.debug('payLoad -->'+payLoad);
             List<WrapperClass> finaList = (List<WrapperClass>)
                JSON.deserialize('['+ payLoad + ']', List<WrapperClass>.class);
            
            for(WrapperClass wc: finaList){
                system.debug(' competitor_uom  = ' + wc.competitor_uom + ', customer_qpu = ' +  wc.customer_qpu);
            }
            HttpRequest req = new HttpRequest();
            //req.setEndpoint('callout:Cross_Ref_Results/api/v1/control/exact/update/'+refId);
            req.setEndpoint('callout:SFDC_Alternates/api/v1/control/exact/update/'+refId);
            req.setMethod('PUT');
            //req.setClientCertificateName('AuthCert2019');
            req.setHeader('Content-Type','application/json');
            req.setHeader('Authorization', 'Bearer ' + receivedAccessToken);
            req.setBody(payLoad);
            
            Http http = new Http();
            HTTPResponse res = http.send(req);
            system.debug('test result-->'+res);
            
            String testResponse;
            testResponse = res.getBody();
            
            system.debug('Test Resp-->'+testResponse);  
            if(testResponse != 'null')
                return 'Error';
            else
                return 'Success'; 
                
                
                }
        else
            return 'Error';
        
        
    }
    
    @AuraEnabled
    public static List<ErrorMessageRecord> getStatus(String referenceId){
   
        String receivedAccessToken;
        if(Test.isRunningTest()){
            receivedAccessToken = 'aereroe--Some long text';
        }
        else
            receivedAccessToken = CrossRefGetAccessToken.getAccessToken();
        List<ErrorMessageRecord> errorMessageData= new List<ErrorMessageRecord>();
		String statusReceived;        
        if(receivedAccessToken != null){
         	HttpRequest req = new HttpRequest();
            req.setEndpoint('callout:SFDC_Alternates/api/v1/control/process/reference_id/'+ referenceId);   
            req.setMethod('GET');
            req.setHeader('Authorization', 'Bearer ' + receivedAccessToken);
            Http http = new Http();
            HTTPResponse res = http.send(req);            
           
            String testResponse = res.getBody();
             system.debug('test -->'+ testResponse);
            
            List<ControlRecord> finaList = (List<ControlRecord>)
                JSON.deserialize(testResponse, List<ControlRecord>.class);
            
            if(finaList.size() > 0 && finaList.size() == 1)
                statusReceived = finaList[0].status;
            
            if((statusReceived == 'Failed' || statusReceived == 'ERROR')  && statusReceived != null)
            {
                errorMessageData = getErrorMessages(referenceId);
                if(errorMessageData != null)
                    return errorMessageData;
                else
                    return null;
            }
            else
                return null;
         
        }
        else
           	 return null;
        
    }
    
    @AuraEnabled
    public static List<ErrorMessageRecord> getErrorMessages(String referenceId){
   
        String receivedAccessToken;
        if(Test.isRunningTest()){
            receivedAccessToken = 'aereroe--Some long text';
        }
        else
            receivedAccessToken = CrossRefGetAccessToken.getAccessToken();  
		String statusReceived;        
        if(receivedAccessToken != null){
         	HttpRequest req = new HttpRequest();
            req.setEndpoint('callout:SFDC_Alternates/api/v1/control/validationErrors/'+ referenceId);   
            req.setMethod('GET');
            req.setHeader('Authorization', 'Bearer ' + receivedAccessToken);
            Http http = new Http();
            HTTPResponse res = http.send(req);            
           
            String testResponse = res.getBody();
             system.debug('test -->'+ testResponse);
            
            List<ErrorMessageRecord> finaList = (List<ErrorMessageRecord>)
                JSON.deserialize(testResponse, List<ErrorMessageRecord>.class);
            
            return finaList;
        }
        else
           	 return null;
        
    }
    
     @AuraEnabled
    public static boolean getNetCostVisibilityFlag() {
        List<CrosRef_Net_Cost_Visibilty__mdt> metadataList = [Select Id,Profile_Id__c From CrosRef_Net_Cost_Visibilty__mdt where Profile_Id__c = :UserInfo.getProfileId()];
        if (metadataList != null && metadataList.size() >= 1){
            return false;
        } else 
            return true;
    }
    
   /*  //Retrieve recommended Item Attributes
    @AuraEnabled
    public static List<RecommendedWrapperClass> getrecommendedItemAttributes(String recommendations){
        String receivedAccessToken;
        if(Test.isRunningTest()){
            receivedAccessToken = 'aereroe--Some long text';
        }
        else
            receivedAccessToken = CrossRefGetAccessToken.getAccessToken();  
		String statusReceived;        
        if(receivedAccessToken != null){
         	HttpRequest req = new HttpRequest();
           // recommendations = '(\'690243\',\'500564\')';
          // recommendations = '(\'690243\')';
            req.setEndpoint('callout:SFDC_Alternates/api/v1/control/display/recomItemAttributes/'+ recommendations);   
            req.setMethod('GET');
            req.setHeader('Authorization', 'Bearer ' + receivedAccessToken);
            Http http = new Http();
            HTTPResponse res = http.send(req);            
           
            String testResponse = res.getBody();
             system.debug('test Recommend-->'+ testResponse);
            
            List<RecommendedWrapperClass> finaList = (List<RecommendedWrapperClass>)
                JSON.deserialize(testResponse, List<RecommendedWrapperClass>.class);
            
            return finaList;
        }
        else
           	 return null;
        
    }*/

    
    public class WrapperClass
    {
        @AuraEnabled public Double reference_id{get;set;}
        @AuraEnabled public String competitor_product_id{get;set;}
        @AuraEnabled public String competitor_description{get;set;}
        @AuraEnabled public String competitor_uom{get;set;}
        @AuraEnabled public String customer_qpu{get;set;} 		//Double
        @AuraEnabled public String orig_competitor_uom{get;set;}
        @AuraEnabled public String orig_customer_qpu{get;set;}
        @AuraEnabled public Double customer_usage{get;set;}
        @AuraEnabled public Double competitor_price{get;set;}
        //@AuraEnabled public String xref_notes{get;set;}
        @AuraEnabled public String competitor_source{get;set;}
        @AuraEnabled public String xref_type{get;set;}
        @AuraEnabled public String od_sku{get;set;}
        @AuraEnabled public String od_sku_description{get;set;}
        @AuraEnabled public String od_sku_uom{get;set;}
        @AuraEnabled public String od_sku_vpn{get;set;}
        @AuraEnabled public String od_sku_mfg{get;set;}
        @AuraEnabled public Double wtd_net_cost{get;set;}
        @AuraEnabled public Double wtd_tdc_cost{get;set;}
        @AuraEnabled public Double department_code{get;set;}
        @AuraEnabled public String department_name{get;set;}
        @AuraEnabled public String vendor_source{get;set;}
        @AuraEnabled public Double rownum{get;set;}
        @AuraEnabled public Double stg_rownum{get;set;}
        @AuraEnabled public Integer results_uid{get;set;}
        @AuraEnabled public String sku_availability_flag{get;set;} 
        @AuraEnabled public String sku_availability_flag_reason{get;set;}
        @AuraEnabled public String stocking_strategy{get;set;}
        @AuraEnabled public String recommendations{get;set;}
        @AuraEnabled public String od_sku_qpu{get;set;}
        @AuraEnabled public Double uom_multiplier{get;set;}
        @AuraEnabled public String sys_created_date{get;set;}
        @AuraEnabled public String sys_modified_date{get;set;}
        
        
    
        /*
        public wrapperclass(Double refId,String compProduct,String compDes,String compUOM,Double custQPU,Double custUsage,Double compPrice,String xrefNotes,String compSource,String xrefType,String OdSku,String ODSkuDesc,String ODSkuUom,String ODSkuVpn,String ODSkuMFG,String rec)
        {
            reference_id = refId;
            competitor_product_id = compProduct;
            competitor_description = compDes;
            competitor_uom = compUOM;
            customer_qpu = custQpu;
            customer_usage = custUsage;
            competitor_price = compPrice;
            xref_notes = xrefNotes;
            competitor_source = compSource;
            xref_type = xrefType;
            od_sku = OdSku;
            od_sku_description = ODSkuDesc;
            od_sku_uom = ODSkuUom;
            od_sku_vpn = ODSkuVpn;
            od_sku_mfg = ODSkuMFG;
            recommendations = rec;
            
        }*/
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
        @AuraEnabled public String last_update_id;
        @AuraEnabled public String statusLink;
        
    } 
    
    public class ErrorMessageRecord {
        @AuraEnabled public String reference_id;
        @AuraEnabled public String status;
        @AuraEnabled public String message;
        
    } 
    
    public class HitRateData {
        @AuraEnabled public String noOfMatches;
        @AuraEnabled public String noOfNoMatches;
        @AuraEnabled public String hitrate;
        
    } 
    
     public class RecommendedWrapperClass
     {
        @AuraEnabled public String sku_num{get;set;}
        @AuraEnabled public String item_desc{get;set;}
        @AuraEnabled public String corr_uom{get;set;}
        @AuraEnabled public String mfg_vpn{get;set;}
        @AuraEnabled public Integer corr_qpu{get;set;} 
        @AuraEnabled public String orig_item{get;set;}
        @AuraEnabled public String recommendations{get;set;} 
     }
    
}