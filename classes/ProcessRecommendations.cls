public class ProcessRecommendations {
    
    @AuraEnabled(cacheable=true)
    public static String getAllRecommendations(){       
        
        String accessToken;
        if(Test.isRunningTest()){
            accessToken = 'aereroe--Some long text';
        }
        else
            accessToken = CrossRefGetAccessToken.getAccessToken();
        if(accessToken != null) 
        {
            HttpRequest request = new HttpRequest();
            request.setEndpoint('callout:SFDC_Alternates/api/v1/control/recoms');
            request.setMethod('GET');
            request.setHeader('Authorization', 'Bearer ' + accessToken);
            
            Http http = new Http();
            HTTPResponse response = http.send(request);
            system.debug(response);
            
            String recomResponse = response.getBody();
            return recomResponse;
         }
          else
           	 return null;
    }
    
    @AuraEnabled(cacheable=true)
    public static String processRecommendations(String recommendations){
        system.debug(recommendations);
        
        List<Recommendation> recoms = (List<Recommendation>) JSON.deserialize(recommendations, List<Recommendation>.class);
        
        system.debug(recoms);
        
        if (recoms.size() > 0) {
            String accessToken;
            if(Test.isRunningTest()){
                accessToken = 'aereroe--Some long text';
            }
            else
                accessToken = CrossRefGetAccessToken.getAccessToken();
            if(accessToken != null) {
                for (Recommendation recommendation : recoms) {
		            HttpRequest request = new HttpRequest();
                    request.setEndpoint('callout:SFDC_Alternates/api/v1/control/recom/update/' + recommendation.recommendation_id);
                    request.setMethod('PUT');
                    request.setHeader('Authorization', 'Bearer ' + accessToken);
                    request.setBody(JSON.serialize(recommendation));
                    
                    Http http = new Http();
                    HTTPResponse response = http.send(request);
                    system.debug(response);
                    
                    String recomResponse = response.getBody();                    
                }
            }
        }
        
        recommendations = getAllRecommendations();
        return recommendations;
    }
    
    public class Recommendation
    {
        @AuraEnabled public String reference_id{get;set;}
        @AuraEnabled public String recommendation_id{get;set;}
        @AuraEnabled public String competitor_product_id{get;set;}
        @AuraEnabled public String competitor_description{get;set;}
        @AuraEnabled public String competitor_uom{get;set;}
        @AuraEnabled public String customer_qpu{get;set;}
        @AuraEnabled public String competitor_usage{get;set;}
        @AuraEnabled public String competitor_price{get;set;}
        @AuraEnabled public String xref_type{get;set;}
        @AuraEnabled public String od_sku{get;set;}
        @AuraEnabled public String od_sku_description{get;set;}
        @AuraEnabled public String od_sku_uom{get;set;}
        @AuraEnabled public String od_sku_qpu{get;set;}
        @AuraEnabled public String od_sku_vpn{get;set;}
        @AuraEnabled public String od_sku_mfg{get;set;}
        @AuraEnabled public String status{get;set;}
        @AuraEnabled public String last_update_id{get;set;}
        @AuraEnabled public String sys_modified_date{get;set;}
        
        /*public Recommendation(String reference_id,String recommendation_id,String competitor_product_id,String competitor_description,String competitor_uom,String customer_qpu,String competitor_usage,String competitor_price,String xref_type,String od_sku,String od_sku_description,String od_sku_uom,String od_sku_vpn,String od_sku_mfg,String status)
        {
            reference_id            =   reference_id            ;            
            recommendation_id       =   recommendation_id       ;
            competitor_product_id   =   competitor_product_id   ;
            competitor_description  =   competitor_description  ;
            competitor_uom          =   competitor_uom          ;
            customer_qpu            =   customer_qpu            ;
            competitor_usage        =   competitor_usage        ;
            competitor_price        =   competitor_price        ;
            xref_type               =   xref_type               ;
            od_sku                  =   od_sku                  ;
            od_sku_description      =   od_sku_description      ;
            od_sku_uom              =   od_sku_uom              ;
            od_sku_vpn              =   od_sku_vpn              ;
            od_sku_mfg              =   od_sku_mfg              ;
            status                  =   status                  ;
        }*/
    }

}