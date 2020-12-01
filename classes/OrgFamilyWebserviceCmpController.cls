public class OrgFamilyWebserviceCmpController {
    @AuraEnabled    
    public static List<Org__c> familyTree_WB(String orgData)
       
    {
        List<Org__c> searchResults= new List<Org__c>();
        List<Org__c>  orgRecList= (List<Org__c>) JSON.deserialize(orgData, List<Org__c>.class);
        
        if(!orgRecList.isEmpty()){
            if(String.isNotBlank(orgRecList[0].D_B_ID__c)){
                system.debug('orgRec.D_B_ID__c.....'+orgRecList[0].D_B_ID__c);
                String url =  'https://api.avention.com/api/v1/company/'+orgRecList[0].D_B_ID__c+'/family/search?type=keyword&size=50&api_key=aa0a9e7c-b8f4-4cb1-95a4-e1545bf06e45';
                
                HTTPRequest req = new HTTPRequest();
                req.setEndPoint(url);
                req.setHeader('Content-Type', 'application/json');
                req.setHeader('Accept', 'application/json');
                req.setMethod('GET');
                HTTP h = new HTTP();
                HTTPResponse resp = h.send(req);
                //system.debug('resp............'+resp.getBody());
                AventionFamilyJSON companyResult = new AventionFamilyJSON();
                companyResult = (AventionFamilyJSON)JSON.deserialize(resp.getBody(), AventionFamilyJSON.class);
                System.debug('Fail------'+companyResult);
                for(AventionFamilyJSON.Results result : companyResult.Results){
                    Org__c orgRec = new Org__c();
                    orgRec.Business_Name__c = result.companyName; 
                    orgRec.Type__c = result.entityType.name;
                    orgRec.LOB__c = result.primaryIndustry.shortDescription;
                    if(String.isNotBlank(result.numEmployees)){
                         orgRec.Employee_Count__c = Integer.valueof(result.numEmployees);
                    }
                   
                    orgRec.Website__c = result.primaryUrl;
                    orgRec.D_B_ID__c=  String.valueOf(result.keyId);
                    for(AventionFamilyJSON.Addresses  addres :result.addresses){
                        //if(addres.country.iso2 == 'US'){
                        //Org__c orgRec = new Org__c();
                        orgRec.Address_1__c =  addres.addressType;
                        orgRec.city__c = addres.city;
                        orgRec.state__c = addres.state.name;
                        /*orgRec.Business_Name__c = result.companyName; 
                          orgRec.Type__c = result.entityType.name;
                          orgRec.LOB__c = result.primaryIndustry.shortDescription;
                          orgRec.Employee_Count__c = result.numEmployees;
                          orgRec.Website__c = result.primaryUrl;
                          orgRec.D_B_ID__c=  String.valueOf(result.keyId);*/
                        //system.debug('orgRec...'+orgRec);
                        searchResults.add(orgRec);
                        // }
                    }
                }
            }
        }
        return searchResults; 
    }
}