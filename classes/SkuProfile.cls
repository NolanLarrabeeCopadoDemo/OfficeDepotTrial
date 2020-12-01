public class SkuProfile {

    @AuraEnabled(cacheable=true)
    public static String searchBySku(String sku_num){       
        
        String accessToken;
        
        if(Test.isRunningTest()){
            accessToken = 'Bearer token mock text';
        } else {
            accessToken = CrossRefGetAccessToken.getAccessToken();
        }
        
        if(accessToken != null) 
        {
            HttpRequest request = new HttpRequest();
            request.setEndpoint('callout:SFDC_Alternates/api/v1/control/item_search/' + sku_num);
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
    public static String findAlternates(String sku_num){       
        
        String accessToken;
        
        if(Test.isRunningTest()){
            accessToken = 'Bearer token mock text';
        } else {
            accessToken = CrossRefGetAccessToken.getAccessToken();
        }
        
        if(accessToken != null) 
        {
            HttpRequest request = new HttpRequest();
            request.setEndpoint('callout:SFDC_Alternates/api/v1/control/item/alternates/' + sku_num);
            request.setMethod('GET');
            request.setHeader('Authorization', 'Bearer ' + accessToken);
            //request.setBody('{"skus":["'+sku_num+'"],"match_criteria" : "Exact"}');
            
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
    public static String getStockingStrategy(String sku_num){       
        
        String accessToken;
        
        if(Test.isRunningTest()){
            accessToken = 'Bearer token mock text';
        } else {
            accessToken = CrossRefGetAccessToken.getAccessToken();
        }        
        if(accessToken != null) 
        {
            HttpRequest request = new HttpRequest();
            request.setEndpoint('callout:SFDC_Alternates/api/v1/control/item/stockingstrategy/' + sku_num);
            request.setMethod('GET');
            request.setHeader('Authorization', 'Bearer ' + accessToken);
            //request.setBody('{"skus":["'+sku_num+'"],"match_criteria" : "Exact"}');
            
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
    public static String getCompPricing(String sku_num){       
        
        String accessToken;
        
        if(Test.isRunningTest()){
            accessToken = 'Bearer token mock text';
        } else {
            accessToken = CrossRefGetAccessToken.getAccessToken();
        }
        
        if(accessToken != null) 
        {
            HttpRequest request = new HttpRequest();
            request.setEndpoint('callout:SFDC_Alternates/api/v1/control/item/comppricing/' + sku_num);
            request.setMethod('GET');
            request.setHeader('Authorization', 'Bearer ' + accessToken);
            //request.setBody('{"skus":["'+sku_num+'"],"match_criteria" : "Exact"}');
            
            Http http = new Http();
            HTTPResponse response = http.send(request);
            system.debug(response);
            
            String recomResponse = response.getBody();
            return recomResponse;
         }
          else
           	 return null;
    }    

    public class SearchCriteria
    {
        @AuraEnabled public String sku_num{get;set;}
        
        public SearchCriteria(String sku_num)
        {
            sku_num            =   sku_num            ;            
        }
    }



}