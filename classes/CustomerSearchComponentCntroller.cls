public class CustomerSearchComponentCntroller{
    public class custException extends Exception{}
    
    public class AccountData{
        @AuraEnabled  
        public Account accRec { get; set; }
        @AuraEnabled  
        public String defaultAccRecordType { get; set; }
        @AuraEnabled 
        public Map<String,String> accRTMap {get;set;}
        @AuraEnabled 
        public List<String> countryList {get;set;}
        @AuraEnabled 
        public List<String> stateList {get;set;}
       
        public AccountData(Account accRec,String defaultAccRecordType, Map<String,String> accRTMap, List<String> countryList, List<String> stateList){
            this.accRec =  accRec;
            this.defaultAccRecordType =  defaultAccRecordType;
            this.accRTMap = accRTMap;
            this.countryList =  countryList;
            this.stateList = stateList;
        }
    }
    
    @AuraEnabled 
    public static string validateLeadData(String leadId){
        Boolean result;
        String errorMessage = '';
        String OId='';
        String prefix = '00G';
        Account account;
        Lead leads;
        List<Sales_Person__c> SalesPersonId = new List<Sales_Person__c>();
        User current_user = [Select id,profile.Name from User where id=:Userinfo.getuserid()];
        set<Id> SubordinateUsers = RoleUtils.getRoleSubordinateUsers(current_user.id);
        
        if(String.isNotBlank(leadId)){
            leads =  [select id,Name,Account__c,Address1__c,Address2__c,City__c,Zip__c,State__c,RecordType.Name,Company,LastName,Phone,
                      RecordTypeId,Business_Pro_Loyalty_Account_Number__c,OwnerId,Account__r.OwnerId,Sales_Person_ID__c,Employee_ID__c,LeadSource,Country__c
                      FROM Lead Where id =: leadId];
            
            OId=leads.OwnerId;
            Boolean result1 = OId.startsWith(prefix);
            if(result1){
                errormessage = 'Lead Owner can not be a Queue for conversion';
                //return errorMessage;
            }
            if(errorMessage==null ||  errorMessage==''){
                if( !SubordinateUsers.contains(leads.ownerid) &&  (leads.ownerid != current_user.id) && (!current_user.Profile.Name.contains('System Administrator'))){  //current_user.Profile.Name !='System Administrator'                                             
                    errormessage = 'You are not the owner of this Lead. Only the primary owner can covert this lead.';
                    return errorMessage;
                }
                if(errorMessage==null ||  errorMessage==''){
                    errorMessage=ValidateRequiredFields(Leads.Id);
                    //return errorMessage;
                }
                
            }
            
            //validate required fields
            // errorMessage=ValidateRequiredFields(Leads.Id);
         /*   
            //to validate required fields when account is null
            if(leads.Account__c == null && (errorMessage=='' || errorMessage==null)){
                system.debug('InACC');
                boolean validatelead=ValidateLeadIfAccountBlank(Leads.Id);               
                if(!validatelead){
                    if(leads.Country__c!='MEX')
                        errorMessage='Required fields not be null.'+'Please go back to lead page and enter First Name, Last Name, Address1,Phone,City,State,Zip,Country,Opportunity Amount,Company and White Collar Workers';
                    else
                        errorMessage='Required fields not be null.'+'Please go back to lead page and enter First Name, Last Name, Address1,Phone,City,Zip,Country,Opportunity Amount,Company and White Collar Workers';
                    
                    //return errorMessage;
                }
            }
            //to validate FirstName,LastName and Amount fields when account is prescent
            if(errorMessage==null ||  errorMessage==''){                        
                
                if(leads.Account__c != null){
                    boolean validatelead= ValidateIfAccountPresent(Leads.Id);
                    if(!validatelead){
                        errorMessage='FirstName,LastName and Amount are required';
                        //return errorMessage;
                    }
                }
            }   */
            
            /// check for permission for Lead convert
            if(errorMessage==null ||  errorMessage==''){                        
                //if((leads.OwnerId != System.UserInfo.getUserId())&& (leads.Account__c != null)&&(leads.OwnerId != leads.Account__r.OwnerId)&&(current_user.Profile.Name !='System Administrator')&&(!SubordinateUsers.contains(leads.OwnerId)))
                if((leads.OwnerId != System.UserInfo.getUserId())&& (leads.Account__c != null)&&(leads.OwnerId != leads.Account__r.OwnerId)&&(!current_user.Profile.Name.contains('System Administrator'))&&(!SubordinateUsers.contains(leads.OwnerId)))
                {
                    system.debug('inif'+leadId); 
                    errorMessage='To convert a lead, you must be the owner of the lead';
                    //return errorMessage;    
                }
            }
            
            if(leads.RecordType.Name=='Lead (Canada)' && String.isBlank(leads.Sales_Person_ID__c)){
                SalesPersonId = [select id,name,ExtIDSalesPerson__c from Sales_Person__c where user__c =:UserInfo.getUserId()  And IsActive__c=True And Primary__c=True limit 1];
                
                if(SalesPersonId.isEmpty()){
                    errorMessage='User creating Account does not have a valid SalesPerson ID';
                    //return errorMessage;
                }
            }
            
       /*     if(leads.RecordType.Name=='Lead (Business Pro)'){
                if(leads.Company == null || leads.LastName == null || leads.Phone == null ){
                    errorMessage='LastName,Company and Phone are required';
                    //return errorMessage;
                }
            }  */
        }
        return errorMessage;   
    }
    
   /*@AuraEnabled
    public static string validateBusProLeadData(String leadId){
        String errorMessage = '';
        Account acc =new Account();
        Lead leads;
        List<Sales_Person__c> SalesPersonId = new List<Sales_Person__c>();
        User current_user = [Select id,profile.Name from User where id=:Userinfo.getuserid()];
        set<Id> SubordinateUsers = RoleUtils.getRoleSubordinateUsers(current_user.id);
        
        if(String.isNotBlank(leadId)){
            
            leads =  [select id,Name,Account__c,Address1__c,Address2__c,City__c,Zip__c,State__c,RecordType.Name,
                      RecordTypeId,Business_Pro_Loyalty_Account_Number__c,OwnerId,Account__r.OwnerId,Sales_Person_ID__c,Employee_ID__c,LeadSource
                      FROM Lead Where id =: leadId];
            
            
            acc.Name = leads.Company;
            acc.Address1__c = leads.Address1__c;
            acc.address2__c = leads.address2__c;
            acc.City__c = leads.City__c;
            acc.State__c =leads.State__c;
            acc.Zip__c = leads.Zip__c;
            acc.Contact_Initiation_Type__c = leads.LeadSource;
            acc.Employee_Contractor_ID__c = leads.Employee_ID__c;
            acc.Loyatly_Number__c = leads.Business_Pro_Loyalty_Account_Number__c;
            acc.OwnerId  = leads.OwnerId;
            acc.Org_WCW_Count_Rep__c = leads.WCW_Count__c;
            acc.Sales_PersonID__c  =  leads.Sales_Person_ID__c;
            
        }
        Account acc3;
        
        acc3= [select id,loyatly_number__c from account where recordtype.name='Customer (Business Pro)'and loyatly_number__c=:acc.loyatly_number__c limit 1];
        
        if(leads.RecordType.Name=='Lead (Business Pro)'){
            if (string.isEmpty(acc.loyatly_number__c)&& acc.BSD_Account_number__c == null) {
                errorMessage='BSD Account Number or Loyalty Account Number Has to be Entered';
                return errorMessage;
            }
            if (string.isEmpty(acc.loyatly_number__c)&& acc.BSD_Account_number__c != null){
                errorMessage='Both BSD Account Number and Loyalty Account Number Cannot be Entered';
                return errorMessage;
            }
            if (!string.isEmpty(acc.loyatly_number__c)){
                if(SalesPersonId.isEmpty())
                    errorMessage='Loyalty Number Cannot be Duplicated';
                return errorMessage;
            }
            return errorMessage;  
        }
        
        return errorMessage;
    }*/
    
  /*  @AuraEnabled
    Public static Boolean ValidateLeadIfAccountBlank(Id leadId) {  
        boolean result;
        Lead lead1 =  [select id,Name,Account__c,Address1__c,Address2__c,FirstName,Zip__c,State__c,Phone,
                       Company,amount__c,City__c,OwnerId,country__c,LastName,WCW_Count__c,RecordType.Name
                       FROM Lead Where id =: leadId];
        if(lead1.RecordType.Name!='Lead (Business Pro)'){
             if(lead1.Country__c!='MEX'){
            if(lead1.Company == null || lead1.amount__c == null || lead1.FirstName == null || lead1.LastName == null || lead1.address1__c == null || 
               lead1.City__c == null || lead1.State__c == null || lead1.zip__c == null || lead1.Phone == null || lead.WCW_Count__c == null ||  lead1.country__c == null) { 
                  return false; 
               }
        }
        else{
            if(lead1.Company == null || lead1.amount__c == null || lead1.FirstName == null || lead1.LastName == null || lead1.address1__c == null || 
               lead1.City__c == null || lead1.zip__c == null || lead1.Phone == null || lead.WCW_Count__c == null ||  lead1.country__c == null) { 
                  return false; 
               }
        }
        }
        return true; 
    }    
    
    @AuraEnabled
    public static Boolean ValidateIfAccountPresent(Id leadId) {
        Lead lead2 =  [select id,Name,Account__c,FirstName,amount__c,LastName,RecordType.Name
                       FROM Lead Where id =: leadId];
        if(lead2.FirstName == null || lead2.amount__c== null || lead2.LastName == null ) {
            return false;
        }
        return true;
    }
    */

    @AuraEnabled
    public static string ValidateRequiredFields(Id leadId) {
        String errorMessage = '';
        Lead lead2 =  [select id,Name,Account__c,FirstName,LastName,Company,Phone,WCW_Count__c,Amount__c,Industry,Current_Supplier__c,Address1__c,
                       City__c,State__c,Zip__c,Country__c,Decision_Maker__c,RecordType.Name
                       FROM Lead Where id =: leadId];
     
     /*   
        if(lead2.RecordType.Name =='Lead (US)'){
            if(lead2.Country__c!='MEX'){
                if(lead2.LastName == null || lead2.Company== null || lead2.Phone == null || lead2.WCW_Count__c== null || lead2.Amount__c == null
                   || lead2.Industry == null || lead2.Current_Supplier__c== null || lead2.Address1__c == null || lead2.City__c == null || 
                   lead2.State__c== null || lead2.Zip__c == null || lead2.Country__c== null || lead2.Decision_Maker__c == null) {
                       
                       errorMessage='Please go back to lead and enter data in LastName,Company,Phone,White Collar Workers,Opportunity Amount,Industry,Current Supplier,Address1,City,State/Province,Zip/Postal Code,Country and Decision Maker.' ; 
                       return errorMessage;
                   }
                return errorMessage;
            }
            else{
                if(lead2.LastName == null || lead2.Company== null || lead2.Phone == null || lead2.WCW_Count__c== null || lead2.Amount__c == null
                   || lead2.Industry == null || lead2.Current_Supplier__c== null || lead2.Address1__c == null || lead2.City__c == null || 
                   lead2.Zip__c == null || lead2.Country__c== null || lead2.Decision_Maker__c == null) {
                       
                       errorMessage='Please go back to lead and enter data in LastName,Company,Phone,White Collar Workers,Opportunity Amount,Industry,Current Supplier,Address1,City,Zip/Postal Code,Country and Decision Maker.' ; 
                       return errorMessage;
                   }  
            }
            return errorMessage;
        }
        
        if(lead2.RecordType.Name =='Lead (Canada)'){
            if(lead2.Country__c!='MEX'){
                if(lead2.FirstName == null || lead2.LastName == null || lead2.Company== null || lead2.Phone == null || lead2.WCW_Count__c== null || lead2.Amount__c == null
                   || lead2.Address1__c == null || lead2.City__c == null || 
                   lead2.State__c== null || lead2.Zip__c == null || lead2.Country__c== null ) {
                       
                       errorMessage='Please go back to lead and enter data in FirstName,LastName,Company,Phone,White Collar Workers,Opportunity Amount,Address1,City,State/Province,Zip/Postal Code and Country.' ; 
                       return errorMessage;
                   }
                //return errorMessage;
            }
            else{
                system.debug('inrequire----');
                if(lead2.FirstName == null || lead2.LastName == null || lead2.Company== null || lead2.Phone == null || lead2.WCW_Count__c== null || lead2.Amount__c == null
                   || lead2.Address1__c == null || lead2.City__c == null || 
                   lead2.Zip__c == null || lead2.Country__c== null ) {
                       errorMessage='Please go back to lead and enter data in FirstName,LastName,Company,Phone,White Collar Workers,Opportunity Amount,Address1,City,Zip/Postal Code and Country.' ; 
                       return errorMessage;
                   }
               // return errorMessage;
            }
        }
        system.debug('inerror----'+errorMessage); 
        */


        return errorMessage;

    }  
    
    @AuraEnabled    
    public static AccountData getAccountInstance(String leadId)
    { 
        Account acc = new Account();
        String leadRT ;
        String defaultAccRecType;
        List<Sales_Person__c> salesPersonList = new List<Sales_Person__c>();
            salesPersonList = [select id,name,user__r.name from Sales_Person__c where user__r.id=:Userinfo.getuserid()];
        if(!salesPersonList.isEmpty()){
            acc.Sales_PersonID__c = salesPersonList[0].id;
        }
        
        Lead lead = new Lead();
        if(String.isNotBlank(leadId)){
            lead =  [select id,Name,Address1__c,Address2__c,Country__c,City__c,Zip__c,State__c,RecordType.Name,Company,WCW_Count__c,Sales_Person_ID__c,
                     RecordTypeId,Business_Pro_Loyalty_Account_Number__c,Employee_ID__c,LeadSource,OwnerId,Industry,Lead_Page_Source__c
                     FROM Lead Where id =: leadId];
            //acc.Name = l.Name;
            acc.Name = lead.Company;
            acc.Address1__c = lead.Address1__c;
            acc.address2__c = lead.address2__c;
            acc.City__c = lead.City__c;
            acc.Country__c =lead.Country__c;
            acc.State__c =lead.State__c;
            acc.Zip__c = lead.Zip__c;
            acc.Employee_Contractor_ID__c = lead.Employee_ID__c;
            acc.Loyatly_Number__c = lead.Business_Pro_Loyalty_Account_Number__c;
            acc.OwnerId  = lead.OwnerId;
            acc.Org_WCW_Count_Rep__c = lead.WCW_Count__c;
            if(lead.RecordType.Name != 'Lead (Canada)'){
               acc.Sales_PersonID__c  =  lead.Sales_Person_ID__c;
               acc.Industry_OD_SIC_Rep__c  = lead.Industry;
               acc.AccountSource = lead.LeadSource;
               acc.Account_Page_Source__c = lead.Lead_Page_Source__c;
               acc.Employee_Contractor_ID__c = lead.Employee_ID__c;
               acc.Loyatly_Number__c = lead.Business_Pro_Loyalty_Account_Number__c;
           }
           acc.status__c = 'Active';
           leadRT = lead.RecordType.Name;
        }else{
            acc.Country__c = 'USA';
            acc.status__c = 'Active';
        }
        
        //Get Record Type dynamically using Schema
        Map<String,String> accRTMap = new Map<String,String>();
        Schema.DescribeSObjectResult sobjectResult = Schema.getGlobalDescribe().get('Account').getDescribe();
        if(sobjectResult != null)
        {
            List<Schema.RecordTypeInfo> recordTypeInfo = sobjectResult.getRecordTypeInfos();
            for(Schema.RecordTypeInfo info : recordTypeInfo){
                    if((info.getName().contains('Prospect') && info.getName() != 'Prospect (OfficeMax)') || info.getName() == 'Customer (Business Pro)')
                        if(info.isAvailable())
                        accRTMap.put(info.getName(),info.getRecordTypeId());
             }
        }
        
        //Mapping Lead RT to Account RT
        if(leadRT != null){
            if(leadRT == 'Lead (BizBox)'){
                defaultAccRecType = 'Prospect (BizBox)';
                acc.RecordTypeId = accRTMap.get(defaultAccRecType);
            }else if(leadRT == 'Lead (Tech-Zone)'){
                defaultAccRecType = 'Prospect (Tech-Zone)';
                acc.RecordTypeId = accRTMap.get(defaultAccRecType);
            }else if(leadRT == 'Lead (Canada)'){
                defaultAccRecType = 'Prospect (GT)';
                acc.RecordTypeId = accRTMap.get(defaultAccRecType);
            }else if(leadRT == 'Lead (US)'){
                defaultAccRecType = 'Prospect';
                acc.RecordTypeId = accRTMap.get(defaultAccRecType);
            }else if(leadRT == 'Lead (Business Pro)'){
                defaultAccRecType = 'Customer (Business Pro)';
                acc.RecordTypeId = accRTMap.get(defaultAccRecType);
            }else{
                defaultAccRecType = 'Prospect';
                acc.RecordTypeId = accRTMap.get(defaultAccRecType);
            }
        }else{
            defaultAccRecType = 'Prospect';
            if(accRTMap.containsKey('Prospect')){
                acc.RecordTypeId = accRTMap.get(defaultAccRecType);
            }else{
                String defRT;
                for(String rt : accRTMap.keyset()){
                    defRT = accRTMap.get(rt);
                }
                acc.RecordTypeId = defRT;
            }
        }
        
        List<String> countryList = new List<String>();
        List<String> stateList = new List<String>();
        
        Schema.DescribeFieldResult fieldResult = Schema.getGlobalDescribe().get('Account').getDescribe().fields.getMap().get('Country__c').getDescribe();    
        List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();          
        for(Schema.PicklistEntry f : ple){  
            countryList.add(f.getValue());
        }
        if(String.isNotBlank(leadId)){
            stateList = InputDependantSelectController.getDependentValForCtrlPickVal('Account', 'Country__c', 'State__c',acc.Country__c); 
        }else{
            stateList = InputDependantSelectController.getDependentValForCtrlPickVal('Account', 'Country__c', 'State__c','USA');
        }
        
        
        AccountData accData= new AccountData(acc, defaultAccRecType, accRTMap,countryList,stateList);
        return accData;
    }
    
    
    @AuraEnabled
    public static List<String> getStateList(String pObjName, String pControllingFieldName, String pDependentFieldName,String ctrlPicklistVal){
        return InputDependantSelectController.getDependentValForCtrlPickVal(pObjName, pControllingFieldName, pDependentFieldName,ctrlPicklistVal);
    }

    @AuraEnabled
    public static List<Org__c> searchAggroService(String name, String street_1, String street_2, String city, String state, String zip) {
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
    @AuraEnabled    
    public static List<Org__C>  searchCustInformation(String prospectData)
    { 
        List<Org__c> searchResults= new List<Org__c>();
        Org__c orgNotFound= new Org__c();
        orgNotFound.Business_Name__c ='None Of the Above';
        String businessname;
        system.debug('prospectData----'+prospectData);
        Account currentProspect= (Account) JSON.deserialize(prospectData, Account.class);
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
         searchResults.addAll(searchAggroService(currentProspect.name, currentProspect.Address1__c, '', currentProspect.City__c, currentProspect.State__c, currentProspect.Zip__c));
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
            return searchResults;
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
          
            system.debug('access_token ------->'+access_token );
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
                
                /*
                if(String.isNotBlank(currentProspect.Address2__c)){
                    if(String.isNotBlank(address)){
                        address= '"streetAddressLine1": "'+ address + ' '+ currentProspect.Address2__c +'"';
                    }else{
                        address= '"streetAddressLine1": "'+ currentProspect.Address2__c +'"';
                    }
                }
                */  
                
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
            
            
            
            /*
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
          */
            
            String content = getBusinessNameAddressJson(business_Name, address, cityName, StateName, postalCode, pageSizeJson);
            System.debug('content ========>' + content);
            DNBCriteriaSearchResult companyResult = getDNBCriteriaSearchResult(DnB_API_Settings.SearchAPI__c,access_token,content);
            System.debug('company result ==='+ companyResult);
            
            if(companyResult == null || companyResult.searchCandidates == null || companyResult.searchCandidates.size() == 0) {
            	content = getBusinessAddressJson(address, cityName, StateName, postalCode, pageSizeJson);
                System.debug('content2 ========>' + content);
                companyResult = getDNBCriteriaSearchResult(DnB_API_Settings.SearchAPI__c,access_token,content);
                
                if(companyResult == null || companyResult.searchCandidates == null || companyResult.searchCandidates.size() == 0) {
                    content = getBusinessPartialAddressJson(address, cityName, StateName, postalCode, pageSizeJson);
                    System.debug('content3 ========>' + content);
                    companyResult = getDNBCriteriaSearchResult(DnB_API_Settings.SearchAPI__c,access_token,content);
                    
                    if(companyResult == null || companyResult.searchCandidates == null || companyResult.searchCandidates.size() == 0) {
                        content = getBusinessNameJson(business_Name, pageSizeJson);
                        System.debug('content4 ========>' + content);
                        companyResult = getDNBCriteriaSearchResult(DnB_API_Settings.SearchAPI__c,access_token,content);
                    }
            	}
            }
            
            
            /*
            HTTPResponse resp = DNBAPICallouts.getSearchResults(DnB_API_Settings.SearchAPI__c,access_token,content);
            response_status = resp.getStatus();
            system.debug('resp-------'+resp);
            response_status_code = String.ValueOf(resp.getStatusCode());
            system.debug('resp.getBody()-------'+resp.getBody());
            DNBCriteriaSearchResult companyResult = new DNBCriteriaSearchResult();
			
            //companyResult = (DNBCriteriaSearchResult)JSON.deserialize(resp.getBody(), DNBCriteriaSearchResult.class);
            companyResult = DNBCriteriaSearchResult.parse(resp.getBody());
			*/
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
            return searchResults;  
        }
    }
    
    private static String getBusinessNameJson(String business_Name, String pageSizeJson) {
        
        String content = '{';
            if(business_Name !='')
                content=  content+business_Name +',';
        		if(pageSizeJson !='')
                	content=  content+pageSizeJson;
                
            content=  content+  ',"countryISOAlpha2Code":"US"'+ '}';
        return content;
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
    }
    
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
}