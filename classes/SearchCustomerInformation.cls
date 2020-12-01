global class SearchCustomerInformation {
    public SearchCustomerInformation() {}

    @InvocableMethod
    global static List<List<Org__C>> searchCustInformation(List<List<Account>> prospects) {
        List<Org__c> searchResults= new List<Org__c>();
        Org__c orgNotFound= new Org__c();
        orgNotFound.Business_Name__c ='None of the Above';
        String businessname;
        Account currentProspect= prospects.get(0).get(0);
        String soql ='Select Id,Business_Name__c, Address_1__c, city__C,state__C,D_B_ID__c,DUNS_Number__c,LOB__c ,Website__c ,IsCustomerExist__c  from Org__C Where Business_Name__c != null';
        if(currentProspect!=null){
            if(String.isNotBlank(currentProspect.name)){
                soql += ' and Business_Name__c LIKE \''+String.escapeSingleQuotes(currentProspect.name)+'%\'';
            } 
            if(String.isNotBlank(currentProspect.Address1__c)){
                soql += ' and Address_1__c LIKE \''+String.escapeSingleQuotes(currentProspect.Address1__c)+'%\'';
            }
            System.debug('soql......'+soql);
            searchResults = Database.query(soql);
                soql += ' and Zip__c LIKE \''+String.escapeSingleQuotes(currentProspect.Zip__c)+'%\'';
            if(Test.isRunningTest() == false) {
         		searchResults.addAll(searchAggroService(currentProspect.name, currentProspect.Address1__c, '', currentProspect.City__c, String.valueOf(currentProspect.State__c), currentProspect.Zip__c));
            }
        }
        Boolean DoExtrnlSrch = True;
        
        if(!searchResults.isEmpty())
        {
         for(Org__c vOrg: searchResults)
         {
             if(vOrg.DUNS_Number__c != '' && vOrg.DUNS_Number__c != null)
             {
                 DoExtrnlSrch =False;
                 break;
             }
         }
         
        
        }
        if( !DoExtrnlSrch ){
            searchResults.add(orgNotFound);
            return  new List<List<Org__C>> { searchResults };
        }
        else
        {
            
            //Store Accces_Token_TimeStamp into custom setting
            //DateTime Accces_Token_TimeStamp = //get this value
            Boolean updateCS = false; 
            String access_token = '';
            DNB_API_Setting__c DnB_API_Settings= DNB_API_Setting__c.getValues('DNB API Value');
            Blob myBlob = Blob.valueof(DnB_API_Settings.ConsumerKey__c+':'+DnB_API_Settings.ConsumerSecret__c);//Consumer Key:Consumer Secret
            system.debug('base64Encode------->'+EncodingUtil.base64Encode(myBlob));
            String accessValue = EncodingUtil.base64Encode(myBlob);
            DNBAuthResponse authResult = new DNBAuthResponse();
            DateTime Accces_Token_TimeStamp;
            Long dt1Long, hours =24 ;
            if(DnB_API_Settings.Timestamp__c != null){
                Accces_Token_TimeStamp = DateTime.ValueOf(DnB_API_Settings.Timestamp__c);//get this value
                dt1Long  = Accces_Token_TimeStamp.getTime();
                Long dt2Long = DateTime.now().getTime();
                Long milliseconds = dt2Long - dt1Long;
                Long seconds = milliseconds / 1000;
                Long minutes = seconds / 60;
                hours = minutes / 60;
                System.debug('minutes===>'+minutes);
            }
            
             System.debug('hours===>'+hours);
           if(DnB_API_Settings.Timestamp__c == null || hours >= 23){ //Safer site take 1 hr before
                //Accces Token is valid for 24 hrs
                //Authorization request to get access 
                
                HTTPResponse response = new HTTPResponse();
               if(Test.isRunningTest() == true) {
                   response.setBody('{}');
               } else {
                	response = DNBAPICallouts.getAccessToken(DnB_API_Settings.AuthAPI__c,accessValue);
               }
                system.debug('resp.getBody()-------'+response.getBody());
                authResult = (DNBAuthResponse)JSON.deserialize(response.getBody(), DNBAuthResponse.class);
                access_token = authResult.access_token;
                //Update the API key and Time into Custom setting
                updateCS = true;
                DnB_API_Settings.AccessToken__c = access_token;
                DnB_API_Settings.Timestamp__c= String.ValueOf(Datetime.now());
           
          }else{
                access_token = DnB_API_Settings.AccessToken__c;
            }
          
            system.debug('access_token ------->'+access_token );
              system.debug('DnB_API_Settings ------->'+DnB_API_Settings.AccessToken__c +':'+ DnB_API_Settings.Timestamp__c );                     
            String business_Name ='';
            String address ='';
            String cityName ='';
            String StateName ='';
            String postalCode ='';
            
            String response_status;
            String response_status_code;
            DNBCriteriaSearchResult  companyRes;
            if(currentProspect!=null){
                if(String.isNotBlank(currentProspect.name))
                    business_Name= '"searchTerm":"'+ currentProspect.name +'"';
                
                if(String.isNotBlank(currentProspect.Address1__c))
                    address= '"streetAddressLine1": "'+ currentProspect.Address1__c +'"';
                
                if(String.isNotBlank(currentProspect.Address2__c)){
                    if(String.isNotBlank(address)){
                        address= '"streetAddressLine1": "'+ address + ' '+ currentProspect.Address2__c +'"';
                    }else{
                        address= '"streetAddressLine1": "'+ currentProspect.Address2__c +'"';
                    }
                }
                    
                
                if(String.isNotBlank(currentProspect.City__c))
                    cityName= '"addressLocality": "'+ currentProspect.City__c +'"';
                
                if(String.isNotBlank(String.valueOf(currentProspect.State__c)))
                    StateName= '"addressRegion": "'+ String.valueOf(currentProspect.State__c) +'"';  
                
                if(String.isNotBlank(currentProspect.Zip__c))
                    postalCode = '"postalCode": "'+ currentProspect.Zip__c +'"'   ;//+   ', "locationRadius":{"postalCode":'+currentProspect.Zip__c +',"radius":5,"unit":"km"}';
            }
            
            
            
            String content = '{';
            if(business_Name !='')
                content=  content+business_Name +',';
            if(address !='')
                content=  content+address +',';
            if(cityName !='')
                content=  content+cityName +',';
            if(StateName !='')
                content=  content+StateName +',';
            if(postalCode !='')
                content=  content+postalCode;
                
            content=  content+  ',"countryISOAlpha2Code":"US"'+ '}';
           // content= '{"searchTerm":"mcdonalds","countryISOAlpha2Code":"US","streetAddressLine1": "2140 N Federal Hwy","postalCode": "33431"}';
            system.debug('Body---->'+content);
          
            HTTPResponse resp = new HTTPResponse();
            if(Test.isRunningTest() == true) {
                resp.setStatus('OK');
                resp.setStatusCode(200);
                resp.setBody('{ "searchCandidates": [{ "displaySequence": 1, "organization": { "duns": "12345678", "primaryAddress": { "streetAddress": {}, "addressLocality": {}, "addressRegion": {} } } }] }');
            } else {
            	resp = DNBAPICallouts.getSearchResults(DnB_API_Settings.SearchAPI__c,access_token,content);
            }
            response_status = resp.getStatus();
            system.debug('resp-------'+resp);
            response_status_code = String.ValueOf(resp.getStatusCode());
            system.debug('resp.getBody()-------'+resp.getBody());
            DNBCriteriaSearchResult companyResult = new DNBCriteriaSearchResult();
            //companyResult = (DNBCriteriaSearchResult)JSON.deserialize(resp.getBody(), DNBCriteriaSearchResult.class);
            companyResult = DNBCriteriaSearchResult.parse(resp.getBody());
            if(companyResult != null && companyResult.searchCandidates != null && companyResult.searchCandidates.size()>0){
            Set<String> DUNSset = new Set<String>();
            Map<String,Org__c> mapOfDUNSwithOrg = new Map<String,Org__c>();
            for(DNBCriteriaSearchResult.cls_searchCandidates result : companyResult.searchCandidates){
                DUNSset.add(result.organization.duns);
            }
            List<Org__c> OrgList = [select id,DUNS_Number__c ,D_B_ID__c ,Business_Name__c ,Address_1__c ,City__c ,Zip__c ,State__c,Employee_Count__c , Annual_sales__c ,LOB__c ,Website__c,IsCustomerExist__c  from org__c where DUNS_Number__c IN :DUNSset];
            if(OrgList != null && !OrgList.isEmpty()){
                for(Org__c org:OrgList){
                    mapOfDUNSwithOrg.put(org.DUNS_Number__c,org);
                }
            }
            
            
            for(DNBCriteriaSearchResult.cls_searchCandidates result : companyResult.searchCandidates){
                Org__c orgRec;
                if( !mapOfDUNSwithOrg.isEmpty() && mapOfDUNSwithOrg.get(result.organization.duns) != null ){
                    orgRec = mapOfDUNSwithOrg.get(result.organization.duns);
                }else{
                    orgRec = new Org__c();
                }
                                
                orgRec.Business_Name__c = result.organization.primaryName;
                orgRec.D_B_ID__c=  result.organization.duns;
                orgRec.DUNS_Number__c = result.organization.duns;
                //orgRec.Type__c = result.entityType.name;                            
                orgRec.Address_1__c =  result.organization.primaryAddress.streetAddress.line1;
                orgRec.City__c = result.organization.primaryAddress.addressLocality.name;
                orgRec.State__c = result.organization.primaryAddress.addressRegion.abbreviatedName;
                orgRec.Zip__c=result.organization.primaryAddress.postalCode;
                if(result.organization.tradeStyleNames!= null && result.organization.tradeStyleNames.size()>0)
                {
                
                orgRec.Alt_Business_Name_1__c = result.organization.tradeStyleNames[0].name;
                }
                if(result.organization.corporateLinkage != null)
                {
                 if(result.organization.corporateLinkage.globalUltimate != null)
                 {
                 orgRec.GLOBAL_ULTIMATE_DUNS_NUM__c=result.organization.corporateLinkage.globalUltimate.duns;
                                  
                 }
                 
                if(result.organization.corporateLinkage.headQuarter != null)
                 {
                 orgRec.Headquarters_DUNS__c=result.organization.corporateLinkage.headQuarter.duns;
                                  
                 }
                
                }
                if(result.organization.telephone != null && result.organization.telephone.size()>0)
                {
                   orgRec.Company_Phone__c =result.organization.telephone[0].telephoneNumber;
                }
                
                if(result.organization.domain!= null )
                {
                orgRec.Website__c=result.organization.domain;
                    
               }
                
                if(result.organization.industryCodes != null && result.organization.industryCodes.size()>0){
                    orgRec.LOB__c = result.organization.industryCodes[0].description;
                }
                if(result.organization.numberOfEmployees != null && result.organization.numberOfEmployees.size()>0){
                    orgRec.Employee_Count__c = result.organization.numberOfEmployees[0].value;
                }
                if(result.organization.financials != null && result.organization.financials.size()>0){
                    if(result.organization.financials[0].yearlyRevenue != null && result.organization.financials[0].yearlyRevenue.size()>0){
                        orgRec.Annual_sales__c = result.organization.financials[0].yearlyRevenue[0].value;
                    }
                }                
                System.debug('orgRec===>'+orgRec);
                try{
                    searchResults.add(orgRec);
                } catch(NullPointerException e){
                    System.debug(LoggingLEvel.ERROR, 'Avention Search failed with null pointer exception.' + e.getMessage());
                }catch(Exception e){
                    System.debug(LoggingLEvel.ERROR, 'Avention Search failed with exception.' + e.getMessage());
                }
            
            }
            }
            System.debug('searchResults===>'+searchResults);
            System.debug('searchResults..' + searchResults.size());
            if(searchResults.size()>0)
            {
                searchResults.add(orgNotFound);
            
            }
            if(updateCS){
           
                UPDATE DnB_API_Settings;
            }           
            return new List<List<Org__C>> { searchResults };  
        }
    }
    
    private static List<Org__c> searchAggroService(String name, String street_1, String street_2, String city, String state, String zip) {
        //String duns, String name, String street_1, String street_2, String city, String state, String zip_5
        String json_result_string = AggroService.getAccountsWithToken(name, street_1, street_2, city, state, zip);

        // Serialize our result
        AggroSearchDeserializer serialized_aggro_results = new AggroSearchDeserializer();
        serialized_aggro_results = AggroSearchDeserializer.parse(json_result_string);

        return serialized_aggro_results.toOrgList();
    }
    
    class DNBAuthResponse{
        public String access_token;
        public Double expiresIn;
    }
}