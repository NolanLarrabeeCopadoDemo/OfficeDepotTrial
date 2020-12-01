public class TechSalesRestRequest {
    
    /*
    @AuraEnabled
    public static List<SupplierResponse> ProductResultsCallout12(Map<String, Object>  params) {
        if(params!=null){
            String searchKey=params.containsKey('searchKey') ? (String)params.get('searchKey') : null;
            System.debug('Test '+searchKey);
            String[] arrTest = searchKey.split('=');
            System.debug(arrTest);
            if(arrTest.size()>1&&arrTest[1]!=null && arrTest[1]!='' && arrTest[1]!='undefined')
            {
                HttpResponse result=doCallOut(searchKey);
                List<SupplierResponse> res = (List<SupplierResponse>) JSON.deserializeUntyped(result.getBody());
                if(res.size()>0)
                {
                    for(Integer i=0;i<20;i++){
                        res.add(res[0]);
                    }
                }
        
                return res;
            }
            else
            {
                return null;
            }
        }
        else
        {
            return null;
        }
    }
    
    public static HttpResponse doCallOut(String searchKey)
    {
        Http http = new Http();
        HttpRequest request = new HttpRequest();
        String URL='https://dev.odplabs.com/services/sfdc-mock-rest-services-node/search?'+searchKey;
        request.setEndpoint(URL);
        request.setMethod('GET');        
        HttpResponse response = http.send(request);
        System.debug('res '+response);
        System.debug(response.getBody());
        return response;  
    }
    */
    
    public virtual class CustomerResponse {
        @AuraEnabled public String collectionId;
        @AuraEnabled public String manufacturerName;
        @AuraEnabled public String odSkuNumber;
        @AuraEnabled public String listPrice;
        @AuraEnabled public String mfgPartNumber;
        @AuraEnabled public String vendorPartNumber;
        @AuraEnabled public String keyword;
        @AuraEnabled public String itemDescription;
        @AuraEnabled public String supplierCostPOCost;
        @AuraEnabled public String supplierName;
        @AuraEnabled public String price;
        @AuraEnabled public String manufacturer;
        @AuraEnabled public String upcCode;
        @AuraEnabled public String supplierPartNumber;
        @AuraEnabled public List<SupplierResponse> results;
    }
    
    public class SupplierResponse
    {
        @AuraEnabled  public String Id;
        @AuraEnabled  public String Supplier;
        @AuraEnabled  public String Description;
        @AuraEnabled  public String SupplierPart;
        @AuraEnabled  public Double Cost;
        @AuraEnabled  public Double CustomerPrice;
        @AuraEnabled  public Double TotalPrice;
        @AuraEnabled  public Double AdjustedPrice;
        @AuraEnabled  public Integer Quantity;
        @AuraEnabled  public Integer Percentage;
    }
}