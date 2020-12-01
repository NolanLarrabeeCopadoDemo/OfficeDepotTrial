/*************************************************************
*Name : BulkProspectUploadController
*Created By : Sandesh Ganjare
*Created Date :
*Purpose : Bulk upload functionality.
*JIRA:
****************************************************************/
public with sharing class BulkProspectUploadController {
    static String genericError = 'Sorry, we experienced an error while processing your account setup request. For support, please open a ticket with the account information by emailing salesforce@officedepot.com.';
    static Id ASR_RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Account Setup Requested').getRecordTypeId();
    @AuraEnabled(cacheable=true)    
    public static Map<String,List<Org__c>>  searchCustInformation(String prospectData)
    { 
        List<Org__c> searchResults= new List<Org__c>();
        List<Org__c> finalSearchResults= new List<Org__c>();
        Map<String,List<Org__c>> mapOfSearchResults = new Map<String,List<Org__c>>();
        Org__c orgNotFound= new Org__c();
        orgNotFound.Business_Name__c ='None Of the Above';
        //String businessname;
        system.debug('prospectData----'+prospectData);
        List<Account> lstProspect= (List<Account>) JSON.deserialize(prospectData, List<Account>.class);
		Set<String> setName = new Set<String>();
		Set<String> setCity = new Set<String>();
		Set<String> setStreet = new Set<String>();
		Set<String> setState = new Set<String>();
		Set<String> setZip = new Set<String>();
		
		if(lstProspect!=null && !lstProspect.isEmpty()){
			for(integer i=0;i<lstProspect.size();i++){
				setName.add(lstProspect[i].Name);
				setCity.add(lstProspect[i].City__c);
				setStreet.add(lstProspect[i].Address1__c);
				setState.add(lstProspect[i].State__c);
				setZip.add(lstProspect[i].Zip__c);
			}

			String soql ='Select Id,Business_Name__c, Address_1__c,Zip__c, city__C,state__C,D_B_ID__c,DUNS_Number__c,LOB__c ,Website__c ,IsCustomerExist__c  from Org__C Where Business_Name__c != null';
        
            if(!setName.isEmpty() && setName!=null){
                soql += ' AND ( Business_Name__c IN  :setName';
            } 
            if(!setStreet.isEmpty() && setStreet!=null){
                soql += ' AND Address_1__c IN :setStreet';
            }
            if(!setCity.isEmpty() && setCity!=null){
                soql += ' AND city__C IN :setCity';
            }
            if(!setState.isEmpty() && setState!=null){
                soql += ' AND state__C IN :setState';
            }
			if(!setZip.isEmpty() && setZip!=null){
				soql += ' AND Zip__c IN :setZip )';
			}
            System.debug('soql......'+soql);
            searchResults = Database.query(soql);
			//searchResults.addAll(searchAggroService(currentProspect.name, currentProspect.Address1__c, '', currentProspect.City__c, currentProspect.State__c, currentProspect.Zip__c));
        }
        System.debug('searchResults......'+searchResults.size());
        if(!lstProspect.isEmpty()){
            for(integer i=0;i<lstProspect.size();i++){
                List<Org__c> lstTempOrg = new List<Org__c>();
                if(!searchResults.isEmpty()){
                    for(integer j=0;j<searchResults.size();j++){                
                        if(searchResults[j].Business_Name__c == lstProspect[i].Name 
                            && searchResults[j].Zip__c == lstProspect[i].Zip__c
                            && searchResults[j].City__c == lstProspect[i].City__c
                            && searchResults[j].State__c== lstProspect[i].State__c
                            && searchResults[j].Address_1__c== lstProspect[i].Address1__c){
                            //finalSearchResults.add(searchResults[j]);
                            lstTempOrg.add(searchResults[j]);
                        }
                    }
                }
                System.debug('lstTempOrg......'+lstTempOrg); 
                mapOfSearchResults.put(lstProspect[i].Name+'-'+lstProspect[i].Zip__c,lstTempOrg);
            }
            
        }
             
        System.debug('mapOfSearchResults......'+mapOfSearchResults.size());  
        System.debug('mapOfSearchResults......'+mapOfSearchResults);  
        
        
        if(!mapOfSearchResults.isEmpty())
        {
           for(String key : mapOfSearchResults.keySet())
            {
                System.debug('key==>'+key);
                System.debug('value==>'+mapOfSearchResults.get(key));  // errror at this line
                List<Org__c> lstOrgResults = mapOfSearchResults.get(key);
                Boolean DoExtrnlSrch = True;
                if(!lstOrgResults.isEmpty()){
                    for(Org__c vOrg: mapOfSearchResults.get(key))
                    {
                        if(vOrg.DUNS_Number__c != '' && vOrg.DUNS_Number__c != null)
                        {
                            DoExtrnlSrch =False;
                            break;
                        }
                    }
                }                 
                if( !DoExtrnlSrch ){
                    List<Org__c> lstOrg = new List<Org__c>();
                    lstOrg.addAll(mapOfSearchResults.get(key));
                    lstOrg.add(orgNotFound);
                    mapOfSearchResults.put(key,lstOrg);
                    //return searchResults;
                    //break;
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
                        
                        HTTPResponse response = DNBAPICallouts.getAccessToken(DnB_API_Settings.AuthAPI__c,accessValue);    
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
                    Account currentProspect;
                    for(integer i=0;i<lstProspect.size();i++){
                        if(lstProspect[i].Name+'-'+lstProspect[i].Zip__c == key){
                            currentProspect = lstProspect[i];
                            break;
                        }
                    }
                    //Account currentProspect = lstProspect[0];
                   // DNB_API_Setting__c DnB_API_Settings= DNB_API_Setting__c.getValues('DNB API Value');
                    //system.debug('access_token ------->'+access_token );
                    system.debug('DnB_API_Settings ------->'+DnB_API_Settings.AccessToken__c +':'+ DnB_API_Settings.Timestamp__c );                     
                    String business_Name ='';
                    String address ='';
                    String cityName ='';
                    String StateName ='';
                    String postalCode ='';
                    integer pageSize = 25;
                    String pageSizeJson = '';
                    
                    String response_status;
                    String response_status_code;
                    DNBCriteriaSearchResult  companyRes;
                    if(currentProspect!=null){
                        if(String.isNotBlank(currentProspect.name))
                            business_Name= '"searchTerm":"'+ currentProspect.name +'"';
                        
                        if(String.isNotBlank(currentProspect.Address1__c))
                            address= '"streetAddressLine1": "'+ currentProspect.Address1__c +'"';
                        
                        
                        if(String.isNotBlank(currentProspect.Address2__c)){
                            if(String.isBlank(address)){                        
                                address= '"streetAddressLine1": "'+ currentProspect.Address2__c +'"';
                            }
                        }
                        
                        if(String.isNotBlank(currentProspect.City__c))
                            cityName= '"addressLocality": "'+ currentProspect.City__c +'"';
                        
                        if(String.isNotBlank(currentProspect.State__c))
                            StateName= '"addressRegion": "'+ currentProspect.State__c +'"';  
                        
                        if(String.isNotBlank(currentProspect.Zip__c))
                            postalCode = '"postalCode": "'+ currentProspect.Zip__c +'"'   ;//+   ', "locationRadius":{"postalCode":'+currentProspect.Zip__c +',"radius":5,"unit":"km"}';
                        
                        pageSizeJson = '"pageSize": '+ pageSize; 
                    }
                    
                    
                    
                    String content = getBusinessNameAddressJson(business_Name, address, cityName, StateName, postalCode, pageSizeJson);
                    System.debug('content ========>' + content);
                    DNBCriteriaSearchResult companyResult = getDNBCriteriaSearchResult(DnB_API_Settings.SearchAPI__c,access_token,content);
                    System.debug('company result ==='+ companyResult);
                    
                    if(companyResult == null || companyResult.searchCandidates == null || companyResult.searchCandidates.size() == 0) {
                        //content = getBusinessAddressJson(address, cityName, StateName, postalCode, pageSizeJson);
                        System.debug('content2 ========>' + content);
                        //companyResult = getDNBCriteriaSearchResult(DnB_API_Settings.SearchAPI__c,access_token,content);
                        
                        if(companyResult == null || companyResult.searchCandidates == null || companyResult.searchCandidates.size() == 0) {
                            //content = getBusinessPartialAddressJson(address, cityName, StateName, postalCode, pageSizeJson);
                            System.debug('content3 ========>' + content);
                            //companyResult = getDNBCriteriaSearchResult(DnB_API_Settings.SearchAPI__c,access_token,content);
                            
                            if(companyResult == null || companyResult.searchCandidates == null || companyResult.searchCandidates.size() == 0) {
                                //content = getBusinessNameJson(business_Name, pageSizeJson);
                                System.debug('content4 ========>' + content);
                                //companyResult = getDNBCriteriaSearchResult(DnB_API_Settings.SearchAPI__c,access_token,content);
                            }
                        }
                    }
                    
                    if(companyResult != null && companyResult.searchCandidates != null && companyResult.searchCandidates.size()>0){
                    Set<String> DUNSset = new Set<String>();
                    Map<String,Org__c> mapOfDUNSwithOrg = new Map<String,Org__c>();
                    /*for(DNBCriteriaSearchResult.cls_searchCandidates result : companyResult.searchCandidates){
                        DUNSset.add(result.organization.duns);
                    }*/
                    /*List<Org__c> OrgList = [select id,DUNS_Number__c ,D_B_ID__c ,Business_Name__c ,Address_1__c ,City__c ,Zip__c ,State__c,Employee_Count__c , Annual_sales__c ,LOB__c ,Website__c,IsCustomerExist__c  from org__c where DUNS_Number__c IN :DUNSset];
                    if(OrgList != null && !OrgList.isEmpty()){
                        for(Org__c org:OrgList){
                            mapOfDUNSwithOrg.put(org.DUNS_Number__c,org);
                        }
                    }*/
                    
                    
                    for(DNBCriteriaSearchResult.cls_searchCandidates result : companyResult.searchCandidates){
                        Org__c orgRec = new Org__c();
                        /*if( !mapOfDUNSwithOrg.isEmpty() && mapOfDUNSwithOrg.get(result.organization.duns) != null ){
                            orgRec = mapOfDUNSwithOrg.get(result.organization.duns);
                        }else{
                            orgRec = new Org__c();
                        }*/
                                        
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
                            //searchResults.add(orgRec);
                            //List<Org__c> lstOrg = mapOfSearchResults.get(key);
                            lstOrgResults.add(orgRec);
                            
                        } catch(NullPointerException e){
                            System.debug(LoggingLEvel.ERROR, 'Avention Search failed with null pointer exception.' + e.getMessage());
                        }catch(Exception e){
                            System.debug(LoggingLEvel.ERROR, 'Avention Search failed with exception.' + e.getMessage());
                        }
                    
                    }
                    }
                    lstOrgResults.add(orgNotFound);
                    mapOfSearchResults.put(key,lstOrgResults);
                    System.debug('mapOfSearchResults===>'+mapOfSearchResults.size());
                    /*if(searchResults.size()>0)
                    {
                        searchResults.add(orgNotFound);
                    
                    } */ 
                    if(updateCS){
                
                        //UPDATE DnB_API_Settings;
                    }      
                
                }
            }
        } 
        return mapOfSearchResults;  
    }

    private static String getBusinessNameAddressJson(String business_Name, String address, String cityName, String StateName, String postalCode, String pageSizeJson) {
        
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
                content=  content+postalCode +',';
        	if(pageSizeJson !='')
                content=  content+pageSizeJson;
                
            content=  content+  ',"countryISOAlpha2Code":"US"'+ '}';
        return content;
    }
    /*
    private static String getBusinessAddressJson(String address, String cityName, String stateName, String postalCode, String pageSizeJson) {
        
        String content = '{';            
            if(address !='')
                content=  content+address +',';
            if(cityName !='')
                content=  content+cityName +',';
            if(stateName !='')
                content=  content+StateName +',';
            if(postalCode !='')
                content=  content+postalCode +',';
        	if(pageSizeJson !='')
                content=  content+pageSizeJson;
                
            content=  content+  ',"countryISOAlpha2Code":"US"'+ '}';
        return content;
    }
    
    private static String getBusinessPartialAddressJson(String address, String cityName, String stateName, String postalCode, String pageSizeJson) {
        
        String fieldName = '';
        String addrValue = '';
        if (String.isNotBlank(address)) {
            String[] addrStrList = address.split(':');
            fieldName = addrStrList[0];
	        addrValue = addrStrList[1];
            if (String.isNotBlank(addrValue)) {
            	addrStrList = addrValue.trim().split(' ');
	        	addrValue = addrStrList[0];  
            }
        }
        
        address = fieldName + ':' + addrValue +'"';
        
        String content = '{';            
            if(address !='')
                content=  content+address +',';
            if(cityName !='')
                content=  content+cityName +',';
            if(stateName !='')
                content=  content+StateName +',';
            if(postalCode !='')
                content=  content+postalCode +',';
        	if(pageSizeJson !='')
                content=  content+pageSizeJson;
                
            content=  content+  ',"countryISOAlpha2Code":"US"'+ '}';
        return content;
    }*/
    
    private static DNBCriteriaSearchResult getDNBCriteriaSearchResult(String SearchAPI, String access_token, String content) {
        
        HTTPResponse resp = DNBAPICallouts.getSearchResults(SearchAPI,access_token,content);
        String response_status = resp.getStatus();
        system.debug('resp-------'+resp);
        String response_status_code = String.ValueOf(resp.getStatusCode());
        system.debug('resp.getBody()-------'+resp.getBody());
        DNBCriteriaSearchResult companyResult = new DNBCriteriaSearchResult();
        
        //companyResult = (DNBCriteriaSearchResult)JSON.deserialize(resp.getBody(), DNBCriteriaSearchResult.class);
        companyResult = DNBCriteriaSearchResult.parse(resp.getBody());
        return companyResult;
    }

    class DNBAuthResponse{
        public String access_token;
        public Double expiresIn;
    }


     /*******************************************************************************************************
     * @author Sandesh Ganjare,
     * @date 19-June-2020
     * @description Aura Wrapper for retrieving DML Data
     * @param 
     */
    @AuraEnabled(cacheable=true) 
    public static Map < Id, String > getDMLData(String AccId){
        try{
            return retrieveDMLData(AccId);
        } catch(Exception e){
            //makeLog('ERROR', e.getMessage());
           // makeLog('ERROR', e.getStackTraceString());
            throw new AuraHandledException(genericError);
        }
    }

    static Map < Id, String > retrieveDMLData(String AccId) {
        System.debug('test check' + AccId);
        Map < Id, String > dmlList = new Map < Id, String > ();
        List < DML_Relation__c > dmlRelatedList = new List < DML_Relation__c > ();
        
        Id orgId = [SELECT Org__c FROM Account WHERE Id =: AccId].org__c;
        System.debug('orgId:'+orgId);
        Id ParentOrg = [SELECT org__r.parent_org__C FROM Account WHERE Id =: AccId].org__r.parent_org__C;
        System.debug('ParentOrg:'+ParentOrg);
        if (ParentOrg != null && orgId != null) {
            System.debug('frstloop');
            dmlRelatedList = [SELECT Decision_Maker_Name__c, DML__c, DML_Details__c FROM DML_Relation__c WHERE Org__c =: orgId OR Org__c =: ParentOrg];
            System.debug('dmlRelatedList' + dmlRelatedList);
            for (DML_Relation__c rec: dmlRelatedList) {
                if (!dmlList.containskey(rec.DML__c))
                    dmlList.put(rec.DML__c, rec.DML_Details__c);
            }
        } else if (orgId != null) {
            System.debug('secondloop');
            dmlRelatedList = [SELECT Decision_Maker_Name__c, DML__c, DML_Details__c FROM DML_Relation__c WHERE Org__c =: orgId];
            System.debug('dmlRelatedList2' + dmlRelatedList);

            for (DML_Relation__c rec: dmlRelatedList) {
                if (!dmlList.containskey(rec.DML__c))
                    dmlList.put(rec.DML__c, rec.DML_Details__c);
            }
        }
        System.debug('mapdmlmap1' + dmlList);
        return dmlList;
    }

    /*******************************************************************************************************
     * @author Sandesh Ganjare,
     * @date 19-June-2020
     * @description Logs a fatal error and throws an exception. 
     * @param String Criticality How big of an issue is it?
     * @param String message The message to log
     */
    public static void makeLog(String criticality, String full_message) {
        EventLog__e myEventLog = new EventLog__e(
        Source__c = 'BulkProspectUploadController',
        Full_Message__c = full_message,
        Log_Level__c = criticality
        );
        Database.SaveResult sr = EventBus.publish(myEventLog);
        // Inspect publishing result 
        if (sr.isSuccess()) {
            System.debug('Successfully published event.');
        } else {
            for(Database.Error err : sr.getErrors()) {
                System.debug('Error returned: ' +
                    err.getStatusCode() +
                    ' - ' +
                    err.getMessage());
            }
        }
    }

    /*******************************************************************************************************
     *@author Sandesh Ganjare,
     * @date 19-June-2020
     * @description Saves the AccountSetupRequest__c on close.
     * @param String updatedRecords A json string representing the AccountSetupRequest__c
     *
     */
    @AuraEnabled
    public static void commitAccountSetupRequests(String accountSetupRequests){
        Boolean error = true;
        Savepoint sp = Database.setSavepoint();
        try{
            saveAccountSetupRequest(accountSetupRequests);
            error = false;
        } catch (Exception e) {
            Database.rollback( sp );
            makeLog('ERROR', e.getMessage());
            makeLog('ERROR', e.getStackTraceString());
            throw new AuraHandledException(genericError);
        }
    }

    private static void saveAccountSetupRequest(String accountSetupRequests) {
        System.debug('Account Setup Save: ' + accountSetupRequests);
        List<Account_Setup_Request__c> accSetupReqList = (List<Account_Setup_Request__c>) JSON.deserialize(accountSetupRequests, List<Account_Setup_Request__c>.class);
        System.debug('Account Setup Save: ' + accSetupReqList);
        List<Account> accountProspectList = new List<Account>();
        if(!accSetupReqList.isEmpty()){
            Set<Id> prospectsIdsSet = new Set<Id>();
            for(Integer k=0;k<accSetupReqList.size();k++){
                prospectsIdsSet.add(accSetupReqList[k].ACCOUNT__c);
                Account myASR_Account = new Account();
                myASR_Account.Id = accSetupReqList[k].ACCOUNT__c;
                myASR_Account.RecordTypeId = ASR_RecordTypeId;
                accountProspectList.add(myASR_Account);
            }
            UPDATE accountProspectList;


            Map<ID, Account> mapIdWithPrspects = new Map<ID, Account>([SELECT Id, Name,Oracle_Party_ID__c,OwnerId,Oracle_Party_Site_ID__c,Segment__c,Duns_Number__c,Ultimate_Duns_Number__c,Payment_Term__c,Est_Spend__c,Sales_PersonID__c,Sales_PersonID__r.name,Pricing_template_cd__c FROM Account WHERE Id IN :prospectsIdsSet LIMIT 1000]); //Ideally there will be 100 prospects at time.
            Map<String, Pricing_Template__c> mapOfPricingTemplates = new Map<String, Pricing_Template__c>();
            List < Pricing_Template__c > pricingTemplates = [
                SELECT Id, Name,Template__c, Parent_Id__c, Off_Contract_Code__c, Off_Contract_Percent__c,
                Off_Wholesale_Code__c, Off_Wholesale_percent__c, GP_Floor_Percernt__c, Price_Plan_Id__c,
                Exclude_Universal_Pricing__c, Loyalty__c, Minimum_Order_Value__c, Delivery_Code__c, Contract_Number_1__c,
                Priority_1__c, Contract_Number_2__c, Priority_2__c, Contract_Number_3__c, Priority_3__c, Contract_Number_4__c,
                Priority_4__c, Contract_Number_5__c, Priority_5__c, Contract_Number_6__c, Priority_6__c, Contract_Number_7__c,
                Priority_7__c, Contract_Number_8__c, Priority_8__c, Contract_Number_9__c, Priority_9__c, Contract_Number_10__c,
                Priority_10__c, Revenue_Band__c, Freight_Charge__c, Cust_Prod_Xref__c, Acct_Auto_Setup__c, Account_Setup_Notes_c__c
                FROM Pricing_Template__c LIMIT 1000
            ]; //WHERE Template__c =: accountToSetup.Pricing_template_cd__c
            if(!pricingTemplates.isEmpty()){
                for(Integer k=0;k<pricingTemplates.size();k++){
                    mapOfPricingTemplates.put(pricingTemplates[k].Template__c,pricingTemplates[k]);
                }
            }
            System.debug('mapOfPricingTemplates: ' + mapOfPricingTemplates);
            if(!mapIdWithPrspects.isEmpty()){
                for(Integer i=0;i<accSetupReqList.size();i++){
                    if(mapIdWithPrspects.get(accSetupReqList[i].ACCOUNT__c) != null){
                        if(mapIdWithPrspects.get(accSetupReqList[i].ACCOUNT__c).Oracle_Party_ID__c == null ||
                            mapIdWithPrspects.get(accSetupReqList[i].ACCOUNT__c).Oracle_Party_ID__c ==''){
                                genericError = 'Sorry, Oracle Party Id is not received for all propsects. For support, please open a ticket with the account information by emailing salesforce@officedepot.com.';
                                throw new AuraHandledException(genericError);
                                //return;
                        }
                        accSetupReqList[i].ORACLE_PARTY_ID__c = mapIdWithPrspects.get(accSetupReqList[i].ACCOUNT__c).Oracle_Party_ID__c;
                        accSetupReqList[i].Account_Owner__c = mapIdWithPrspects.get(accSetupReqList[i].ACCOUNT__c).OwnerId;
                        //accSetupReqList[i].Segment__c = mapIdWithPrspects.get(accSetupReqList[i].ACCOUNT__c).Segment__c;
                        accSetupReqList[i].Duns_Number__c = mapIdWithPrspects.get(accSetupReqList[i].ACCOUNT__c).Duns_Number__c;
                        accSetupReqList[i].Ultimate_Duns_Number__c = mapIdWithPrspects.get(accSetupReqList[i].ACCOUNT__c).Ultimate_Duns_Number__c;
                        accSetupReqList[i].Invoice_Payment_Method__c = mapIdWithPrspects.get(accSetupReqList[i].ACCOUNT__c).Payment_Term__c;
                        accSetupReqList[i].SHIPTO_ORACLE_PARTY_SITE_ID__c = mapIdWithPrspects.get(accSetupReqList[i].ACCOUNT__c).Oracle_Party_Site_ID__c;
                        //accSetupReqList[i].Est_Spend__c = mapIdWithPrspects.get(accSetupReqList[i].ACCOUNT__c).Est_Spend__c;
                        if(mapIdWithPrspects.get(accSetupReqList[i].ACCOUNT__c).Sales_PersonID__c != null){
                            accSetupReqList[i].Rep_ID__c = mapIdWithPrspects.get(accSetupReqList[i].ACCOUNT__c).Sales_PersonID__r.name;
                        }
                        
                        //Adds Pricing template information to an account setup request
                        String priceTemplate = mapIdWithPrspects.get(accSetupReqList[i].ACCOUNT__c).Pricing_template_cd__c;
                        Pricing_Template__c myPricingTemplate = mapOfPricingTemplates.get(priceTemplate);
                        if (myPricingTemplate.Minimum_Order_Value__c != null)
                            accSetupReqList[i].Minimum_Order_Value__c = Decimal.valueOf(myPricingTemplate.Minimum_Order_Value__c);

                        accSetupReqList[i].Off_Contract__c = myPricingTemplate.Off_Contract_Code__c;
                        accSetupReqList[i].Off_Contract_Percent__c = myPricingTemplate.Off_Contract_Percent__c;
                        accSetupReqList[i].Off_Wholesale__c = myPricingTemplate.Off_Wholesale_Code__c;
                        accSetupReqList[i].Off_Wholesale_percent__c = myPricingTemplate.Off_Wholesale_percent__c;
                        accSetupReqList[i].GP_Floor__c = myPricingTemplate.GP_Floor_Percernt__c;
                        accSetupReqList[i].Price_Plan__c = myPricingTemplate.Price_Plan_Id__c;
                        accSetupReqList[i].Exclude_Account_from_Universal_Pricing__c = myPricingTemplate.Exclude_Universal_Pricing__c;
                        accSetupReqList[i].Loyalty_Type__c = myPricingTemplate.Loyalty__c;
                        accSetupReqList[i].Deliver_Charge_Code__c = myPricingTemplate.Delivery_Code__c;
                        accSetupReqList[i].Core_Item_Price_List_Priority_Code_1__c = myPricingTemplate.Priority_1__c;
                        accSetupReqList[i].Core_Item_Price_List_Priority_Code_2__c = myPricingTemplate.Priority_2__c;
                        accSetupReqList[i].Core_Item_Price_List_Priority_Code_3__c = myPricingTemplate.Priority_3__c;
                        accSetupReqList[i].Core_Item_Price_List_Priority_Code_4__c = myPricingTemplate.Priority_4__c;
                        accSetupReqList[i].Core_Item_Price_List_Priority_Code_5__c = myPricingTemplate.Priority_5__c;
                        accSetupReqList[i].Core_Item_Price_List_Priority_Code_6__c = myPricingTemplate.Priority_6__c;
                        accSetupReqList[i].Core_Item_Price_List_Priority_Code_7__c = myPricingTemplate.Priority_7__c;
                        accSetupReqList[i].Core_Item_Price_List_Priority_Code_8__c = myPricingTemplate.Priority_8__c;
                        accSetupReqList[i].Core_Item_Price_List_Priority_Code_9__c = myPricingTemplate.Priority_9__c;
                        accSetupReqList[i].Core_Item_Price_List_Priority_Code_10__c = myPricingTemplate.Priority_10__c;
                        accSetupReqList[i].Revenue_Band__c = myPricingTemplate.Revenue_Band__c;
                        accSetupReqList[i].Core_Item_Price_List_ID_1__c = myPricingTemplate.Contract_Number_1__c;
                        accSetupReqList[i].Core_Item_Price_List_ID_2__c = myPricingTemplate.Contract_Number_2__c;
                        accSetupReqList[i].Core_Item_Price_List_ID_3__c = myPricingTemplate.Contract_Number_3__c;
                        accSetupReqList[i].Core_Item_Price_List_ID_4__c = myPricingTemplate.Contract_Number_4__c;
                        accSetupReqList[i].Core_Item_Price_List_ID_5__c = myPricingTemplate.Contract_Number_5__c;
                        accSetupReqList[i].Core_Item_Price_List_ID_6__c = myPricingTemplate.Contract_Number_6__c;
                        accSetupReqList[i].Core_Item_Price_List_ID_7__c = myPricingTemplate.Contract_Number_7__c;
                        accSetupReqList[i].Core_Item_Price_List_ID_8__c = myPricingTemplate.Contract_Number_8__c;
                        accSetupReqList[i].Core_Item_Price_List_ID_9__c = myPricingTemplate.Contract_Number_9__c;
                        accSetupReqList[i].Core_Item_Price_List_ID_10__c = myPricingTemplate.Contract_Number_10__c;
                        accSetupReqList[i].Off_Contract_percent__c = myPricingTemplate.Off_Contract_Percent__c;
                        accSetupReqList[i].OPERATION__c = myPricingTemplate.Acct_Auto_Setup__c;
                        accSetupReqList[i].Cross_Reference_Number__c = myPricingTemplate.Cust_Prod_Xref__c;
                        accSetupReqList[i].Small_Order_Fee_Flag__c = myPricingTemplate.Freight_Charge__c;
                        accSetupReqList[i].Rep_Comments__c = myPricingTemplate.Account_Setup_Notes_c__c;
                        accSetupReqList[i].IsAccountSetUpSubmitted__c = true;

                    }
                    
                }
            }
            Map<Integer, DML__c> mapofDML = new Map<Integer, DML__c>();          
            for(Integer i=0;i<accSetupReqList.size();i++){
                //System.debug('DML: ' + );
                if(accSetupReqList[i].DML__c != null && (accSetupReqList[i].DML__c).length()>18){ //DML__c object wrapper .containsOnly('{}') 
                    System.debug('DML: ' + accSetupReqList[i].DML__c);
                    DML__c dml = (DML__c) JSON.deserialize(accSetupReqList[i].DML__c, DML__c.class);
                    dml.Effective_Start_Date__c = Date.today();
                    mapofDML.put(i,dml);
                }
            }
            System.debug('mapofDML: ' + mapofDML);

            if(!mapofDML.isEmpty()){
                INSERT mapofDML.values();

                for (Integer index : mapofDML.keySet() ){
                    system.debug('DML: '+ mapofDML.get(index));
                    system.debug('DML: '+ mapofDML.get(index).Id);
                    accSetupReqList[index].DML__c = mapofDML.get(index).Id;
                } 
            }                      
        }
        // TODO: Fix this messy junk...
        INSERT accSetupReqList;
    }   

     /*******************************************************************************************************
     *@author Sandesh Ganjare,
     * @date 19-June-2020
     * @description Saves the Account and Org__C on close.
     * @param String updatedRecords A json string representing the Account and Orgs
     *
     */
    @AuraEnabled
    public static Map<String, String> commitProspects(String prospects, String orgs){
        Savepoint sp = Database.setSavepoint();
        Boolean error = true;
        try{
            error = false;
            return saveProspects(prospects,orgs);
            
        } catch (Exception e) {
            Database.rollback( sp );
            makeLog('ERROR', e.getMessage());
            makeLog('ERROR', e.getStackTraceString());
            throw new AuraHandledException(genericError);
        }
    }

    public class orgWrapper{
        public String key;
        public Org__c value;

    }
    public class prospectWrapper{
        public String Index;  
        public String Name;
        public String Address1;
        public String Address2;
        public String City;
        public String Country;
        public String State;
        public String Zip;

        public String FirstName;
        public String LastName;
        public String Email;
        public String Title;
        public String Department;
        public String Phone1_Rep;
        public String Phone_Type1;
        public String Decision_Maker;
        public String Phone_Ext;
        public List<String> Role;
        public List<String> Product_Focus;

        public String Phone;
        public String Sector;
        public String Segment;
        public String Buying_Group;
        public String Pricing_template_cd;
        public String Industry_OD_SIC_Rep;
        public String Website;
        public Decimal Org_WCW_Count_Rep;
        public Decimal Est_Spend;
        public String Payment_Term;
        public String Primary_Product;
        public Date Rep_Call_Date;
        public String Location_Type;
        public String Related_Pricing_Template_Account;
        public String MPS_Parent_Account;
        public String Sales_PersonID;
    }

    private static Map<String, String>  saveProspects(String prospects, String orgs) {
        System.debug('prospects: ' + prospects);
        System.debug('orgs: ' + orgs);
        //Map<String, Object> meta = (Map<String, Object>) JSON.deserializeUntyped(orgs);
        List<orgWrapper> orgsList = (List<orgWrapper>) JSON.deserialize(orgs, List<orgWrapper>.class);      
        System.debug('orgsList: ' + orgsList);
        Map<String, Org__c> mapOfOrg = new Map<String, Org__c>(); 
        Map<String, String> mapOfExistingOrg = new Map<String, String>();
        
        if(!orgsList.isEmpty()){
            Set<String> orgsDunsSet = new Set<String>();
            for(integer i=0;i<orgsList.size();i++){
                if(orgsList[i] != null && orgsList[i].value != null && orgsList[i].value.DUNS_Number__c != null){
                    orgsDunsSet.add(orgsList[i].value.DUNS_Number__c); 
                }
                //orgList.add(orgsList[i].value);
                //mapOfExistingOrg.put(orgsList[i].key,orgsList[i].value);
            }
            System.debug('orgsDunsSet: ' + orgsDunsSet);
            List<Org__c> existingOrgsList= [Select Id,D_B_ID__c,DUNS_Number__c from Org__C Where DUNS_Number__c IN :orgsDunsSet];
            System.debug('existingOrgsList: ' + existingOrgsList);
            if(!existingOrgsList.isEmpty()){
                for(integer i=0;i<existingOrgsList.size();i++){
                    mapOfExistingOrg.put(existingOrgsList[i].DUNS_Number__c,existingOrgsList[i].Id);
                }
            }    
            System.debug('mapOfExistingOrg: ' + mapOfExistingOrg);

            for(integer i=0;i<orgsList.size();i++){
                if(mapOfExistingOrg.get(orgsList[i].value.DUNS_Number__c) != null){
                    orgsList[i].value.Id = mapOfExistingOrg.get(orgsList[i].value.DUNS_Number__c);
                }
                mapOfOrg.put(orgsList[i].key,orgsList[i].value);
            }
            System.debug('mapOfOrg: ' + mapOfOrg);
            UPSERT mapOfOrg.values();
        }
        System.debug('prospects: ' + prospects);
        String prospects1  = prospects.replace('__c', '');
        System.debug('prospects1: ' + prospects1);
        String prospects2  = prospects1.replace('__C', '');
        System.debug('prospects2: ' + prospects2);
        List<prospectWrapper> prospectList = (List<prospectWrapper>) JSON.deserialize(prospects2, List<prospectWrapper>.class);
        System.debug('prospectList: ' + prospectList);
        String accProspectRecId  = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Prospect').getRecordTypeId();
        Map<String, Account> mapAccounts = new Map<String, Account>();
        List<Contact> contactList = new List<Contact>();
        if(!prospectList.isEmpty()){
            Set<String> setRepIds = new Set<String>();
            for(integer j=0;j<prospectList.size();j++){
                setRepIds.add(prospectList[j].Sales_PersonID);
            }
            List<Sales_Person__c> listSalesPerson = [SELECT Id, Name, User__c FROM Sales_Person__c Where Name IN:setRepIds LIMIT 1000];
            Map<String, Sales_Person__c> mapOfSalesPerson = new Map<String, Sales_Person__c>();
            if(!listSalesPerson.isEmpty()){
                for(integer i=0;i<listSalesPerson.size();i++){
                    mapOfSalesPerson.put(listSalesPerson[i].Name,listSalesPerson[i]);
                }
            }
            System.debug('mapOfSalesPerson: ' + mapOfSalesPerson);

            for(integer i=0;i<prospectList.size();i++){
                Account newacc = new Account();

                newacc.RecordTypeId = accProspectRecId;
                if(mapOfOrg.get(prospectList[i].Name+'-'+prospectList[i].Zip) != null){
                    newacc.Org__c = mapOfOrg.get(prospectList[i].Name+'-'+prospectList[i].Zip).Id;
                }
                
                newacc.Name = prospectList[i].Name;
                newacc.Address1__c = prospectList[i].Address1;
                newacc.Address2__c = prospectList[i].Address2;
                newacc.City__c = prospectList[i].City;
                newacc.Country__c = prospectList[i].Country;
                newacc.State__c = prospectList[i].State;
                newacc.Zip__c = prospectList[i].Zip;
                System.debug('Sales_PersonID: ' + mapOfSalesPerson.get(prospectList[i].Sales_PersonID));
                newacc.Sales_PersonID__c = mapOfSalesPerson.get(prospectList[i].Sales_PersonID).Id;
                newacc.OwnerId = mapOfSalesPerson.get(prospectList[i].Sales_PersonID).User__c;
                newacc.Phone = prospectList[i].Phone;
                newacc.Sector__c = prospectList[i].Sector;
                newacc.Segment__c = prospectList[i].Segment;
                newacc.Buying_Group__c = prospectList[i].Buying_Group;
                newacc.Pricing_template_cd__c = prospectList[i].Pricing_template_cd;
                newacc.Industry_OD_SIC_Rep__c = prospectList[i].Industry_OD_SIC_Rep;
                newacc.Website = prospectList[i].Website;
                newacc.Org_WCW_Count_Rep__c = prospectList[i].Org_WCW_Count_Rep;
                newacc.Est_Spend__c = prospectList[i].Est_Spend;
                newacc.Payment_Term__c = prospectList[i].Payment_Term;
                newacc.Primary_Product__c = prospectList[i].Primary_Product;
                newacc.Rep_Call_Date__c = prospectList[i].Rep_Call_Date;
                newacc.Location_Type__c = prospectList[i].Location_Type;
                newacc.Related_Pricing_Template_Account__c = prospectList[i].Related_Pricing_Template_Account;
                newacc.MPS_Parent_Account__c = prospectList[i].MPS_Parent_Account;

                mapAccounts.put(prospectList[i].Index,newacc);
                System.debug('mapAccounts: ' + mapAccounts);
            }
            INSERT mapAccounts.values();

            String contactUSRecId  = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('Contact(US)').getRecordTypeId();
            for(integer j=0;j<prospectList.size();j++){
                Contact newcon = new Contact();
                newcon.RecordTypeId = contactUSRecId;
                newcon.AccountId = mapAccounts.get(prospectList[j].Index).Id;
                newcon.FirstName = prospectList[j].FirstName;
                newcon.LastName = prospectList[j].LastName;
                newcon.Email = prospectList[j].Email;
                newcon.Title = prospectList[j].Title;
                newcon.Department = prospectList[j].Department;
                newcon.Phone1_Rep__c = prospectList[j].Phone1_Rep;
                newcon.Phone_Type1__c = prospectList[j].Phone_Type1;
                newcon.Decision_Maker__c = prospectList[j].Decision_Maker;
                newcon.Phone_Ext__c = prospectList[j].Phone_Ext;
                List<String> roleList = prospectList[j].Role;
                String roleStr;// = new String();
                if(roleList != null && !roleList.isEmpty()){
                    for(integer i=0;i<roleList.size();i++){
                        roleStr = roleStr+roleList[i];
                        if(i<roleList.size()-1){
                            roleStr = roleStr + ',';
                        }
                    }
                }               
                newcon.Role__c = roleStr;

                List<String> productFocusList = prospectList[j].Product_Focus;
                String productFocusStr;// = new String();
                if(productFocusList != null && !productFocusList.isEmpty()){
                    for(integer i=0;i<productFocusList.size();i++){
                        productFocusStr = productFocusStr+productFocusList[i];
                        if(i<productFocusList.size()-1){
                            productFocusStr = productFocusStr + ',';
                        }
                    }
                }

                newcon.Product_Focus__c = productFocusStr;
                newcon.Primary_Contact__c = true;
                contactList.add(newcon);
                System.debug('contactList: ' + contactList);
            }
         
            INSERT contactList;            
        }
        System.debug('prospectList: ' + prospectList);
        //INSERT prospectList;
        Map<String, String> returnMap = new Map<String, String>(); 
        if(!mapAccounts.isEmpty()){
            for(String aID : mapAccounts.keySet() ){
                //system.debug(loggingLevel.debug, mapAccounts.get(aID));
                returnMap.put(aID,String.valueOf(mapAccounts.get(aID).Id));
            }
            
        }
        return returnMap;
    }
}