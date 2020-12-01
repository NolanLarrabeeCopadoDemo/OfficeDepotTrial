public class CustomerSearchComponentControllerCopy {
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
                if( !SubordinateUsers.contains(leads.ownerid) &&  (leads.ownerid != current_user.id) && (current_user.Profile.Name !='System Administrator')){                                               
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
                if((leads.OwnerId != System.UserInfo.getUserId())&& (leads.Account__c != null)&&(leads.OwnerId != leads.Account__r.OwnerId)&&(current_user.Profile.Name !='System Administrator')&&(!SubordinateUsers.contains(leads.OwnerId)))
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
        system.debug('inerror----'+errorMessage); */
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
    public static List<Org__C>  searchCustInformation(String prospectData)
    { 
        List<Org__c> searchResults= new List<Org__c>();
        String businessname;
        system.debug('prospectData----'+prospectData);
        Account currentProspect= (Account) JSON.deserialize(prospectData, Account.class);
        String soql ='Select Id,Business_Name__c, Address_1__c, city__C,state__C,D_B_ID__c from Org__C Where Business_Name__c != null';
        if(currentProspect!=null){
            if(String.isNotBlank(currentProspect.name)){
                soql += ' and Business_Name__c LIKE \'%'+String.escapeSingleQuotes(currentProspect.name)+'%\'';
            } 
            if(String.isNotBlank(currentProspect.Address1__c)){
                soql += ' and Address_1__c LIKE \'%'+String.escapeSingleQuotes(currentProspect.Address1__c)+'%\'';
            }
            if(String.isNotBlank(currentProspect.Address2__c)){
                soql += ' and Address_2__c LIKE \'%'+String.escapeSingleQuotes(currentProspect.Address2__c)+'%\'';
            }
            if(String.isNotBlank(currentProspect.City__c)){
                soql += ' and City__c LIKE \'%'+String.escapeSingleQuotes(currentProspect.City__c)+'%\'';
            }
            if(String.isNotBlank(currentProspect.State__c)){
                soql += ' and State__c LIKE \'%'+String.escapeSingleQuotes(currentProspect.State__c)+'%\'';
            }
            if(String.isNotBlank(currentProspect.Zip__c)){
                soql += ' and Zip__c LIKE \'%'+String.escapeSingleQuotes(currentProspect.Zip__c)+'%\'';
            }
            System.debug('soql......'+soql);
            searchResults = Database.query(soql);
            // searchResults=[Select Id,Business_Name__c, Address_1__c, city__C,state__C,D_B_ID__c from Org__C where Business_Name__c=: businessname];
        }
        if(!searchResults.isEmpty()){
            return searchResults;
        }
        else
        {
            String business_Name ='';
            String address ='';
            String cityName ='';
            String StateName ='';
            String postalCode ='';
            
            String response_status;
            String response_status_code;
            AventionMatchJSON  companyRes;
            if(currentProspect!=null){
                if(String.isNotBlank(currentProspect.name))
                    business_Name= '{"field": "company.companyName", "value":"'+ currentProspect.name +'" }';
                if(String.isNotBlank(currentProspect.Address1__c))
                    address= '{"field": "company.addresses.address1","value": "'+ currentProspect.Address1__c +'" }';
                
                if(String.isNotBlank(currentProspect.Address2__c))
                    address= '{"field": "company.addresses.address2","value": "'+ currentProspect.Address2__c +'" }';
                
                if(String.isNotBlank(currentProspect.City__c))
                    cityName= '{"field": "company.addresses.cityName", "value": "'+ currentProspect.City__c +'" }';
                
                if(String.isNotBlank(currentProspect.State__c))
                    StateName= '{"field": "company.addresses.stateOrProvinceName", "value": "'+ currentProspect.State__c +'" }';  
                
                if(String.isNotBlank(currentProspect.Zip__c))
                    postalCode = '{"field":"company.addresses.postalCode","value": "'+ currentProspect.Zip__c +'" }';  
            }
            
            String content = '{ "size": 50, "matchBy": [   ';
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
            content=  content+ '{"field": "company.addresses.countryName","value": "United States"}]}';
            system.debug('content----'+content);
            String url = 'https://api.avention.com/api/v1/company/match?api_key=aa0a9e7c-b8f4-4cb1-95a4-e1545bf06e45';
            
            HTTPRequest req = new HTTPRequest();
            req.setEndPoint(url);
            req.setHeader('Content-Type', 'application/json');
            req.setHeader('Accept', 'application/json');
            req.setMethod('POST');
            req.setBody(content);
            HTTP h = new HTTP();
            HTTPResponse resp = h.send(req);
            response_status = resp.getStatus();
            system.debug('resp-------'+resp);
            response_status_code = String.ValueOf(resp.getStatusCode());
             system.debug('resp.getBody()-------'+resp.getBody());
            AventionMatchJSON companyResult = new AventionMatchJSON();
            companyResult = (AventionMatchJSON)JSON.deserialize(resp.getBody(), AventionMatchJSON.class);
            companyRes  =companyResult;
            response_status  = String.ValueOf(companyResult.size);
            System.debug('response_status......'+response_status);
            for(AventionMatchJSON.result result : companyResult.result){
                Org__c orgRec = new Org__c();
                orgRec.Business_Name__c = result.companyName;
                orgRec.D_B_ID__c=  String.valueOf(result.keyId);
                orgRec.Type__c = result.entityType.name;
                orgRec.LOB__c = result.primaryIndustry.shortDescription;
                orgRec.Website__c = result.primaryUrl;
                for(AventionMatchJSON.Addresses  addres :result.Addresses){
                    //orgRec.Address_1__c =  addres.addressType;
                    orgRec.City__c = addres.city;
                    orgRec.State__c = addres.state.abbreviation;
                }
                searchResults.add(orgRec);
            }
             system.debug('searchResults..'+searchResults.size());
            return searchResults;  
        }
    }
}