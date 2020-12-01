/***
Description: This Batch validates the address of the prospects.
Created By: Subhrajyoti
Created Date: 23-July-2013

Modified By:
Modified Date:

Modify Reason: 
**/
Global class Prospect_AddValidation_Batch implements database.Batchable<Sobject>,Schedulable,Database.AllowsCallouts
{
    public String strQuery; //this variable used to set query from test class or from shceduler if required
    public List<Account> prospectListobj = new List<Account>();
    //Prospect_Batch_Execution_Details__c  prospectBatch= Prospect_Batch_Execution_Details__c.getOrgDefaults();
    //Datetime Previousday = prospectBatch.Prospect_Batch_Execution_Date__c.addHours(4);//Date.today().addDays(-1);  
    //public String Previousday1= Previousday.format('yyyy-MM-dd\'T\'HH:mm:ss.SSS\'Z\'');
     // Below is set a default query in case not set in test class or in scheduler
     //private String DEFAULT_QUERY ='select id, Name,address1__c,Address_Validation_Error__c,Address_Validated__c,address2__c,City__c,state__c,country__c,zip__c from Account Where lastmodifieddate >'+Previousday1+' and RecordType.Name =\'Prospect\'';
     private String DEFAULT_QUERY ='select id, Name,address1__c,Address_Validation_Error__c,Address_Validated__c,address2__c,City__c,state__c,country__c,zip__c from Account Where lastmodifieddate > yesterday and RecordType.Name =\'Prospect\'';
      /* Default Constructor*/
    global Prospect_AddValidation_Batch()
    {
        this.strQuery = DEFAULT_QUERY;
    }
        /*This costructor is called from the Batch Schedule method*/
    global Prospect_AddValidation_Batch(String query)
    {
        //System.debug('QUERY IS---->'+query);
        if(query != null && query != '')
            this.strQuery = query;
        else
            this.strQuery = DEFAULT_QUERY;
    }
        /* This method prepares the scope of the batch program based on the query result */
    global Database.QueryLocator start(Database.BatchableContext BC)
    {
        return Database.getQueryLocator(strQuery);
    }
     /* This method processes query result in batches */
    global void execute(Database.BatchableContext BC, SObject[] scope)
    {  
        List<Account> addvalidateprospect= scope;
        integer count = 0;
        for(Account objprospect:addvalidateprospect)  
        {
            if(objprospect.country__c=='USA' && objprospect.address1__c!=null && objprospect.City__c!=null && objprospect.state__c!=null && objprospect.zip__c!=null)
            {
            count = count + 1;
            system.debug('count---->'+count);
            system.debug('Account information--->'+objprospect.Name+'---'+objprospect.id);
                try{
                
                G1AddressValidation.G1AddressValidationService_pt   av = new G1AddressValidation.G1AddressValidationService_pt  ();
                G1AddressValidation.CustomerResponseType result= new G1AddressValidation.CustomerResponseType();                
                
                //New change for the Security
                av.inputHttpHeaders_x = new Map<String, String>();
                String myData = 'sfdcuser:sfdcuser123';       
                
                String encodedusernameandpassword = EncodingUtil.base64Encode(Blob.valueOf(myData));
                av.inputHttpHeaders_x.put('Authorization', 'Basic '+ encodedusernameandpassword);
                
                //End New change for the Security
                
                G1AddressValidation.CustomerType ct = new G1AddressValidation.CustomerType();
                G1AddressValidation.AddressType oAddress = new G1AddressValidation.AddressType();
                  
                        oAddress.StreetNameOne = objprospect.address1__c;
                        oAddress.StreetNameTwo = ''; 
                        oAddress.PostOfficeBox = '';
                        oAddress.CityName = objprospect.City__c;
                        oAddress.StateName = objprospect.state__c;
                        oAddress.ZipCode = objprospect.zip__c;
                        oAddress.Province ='';
                        oAddress.Country=objprospect.country__c;
                        oAddress.GeographicalCodeOne=0;
                        oAddress.GeographicalCodeTwo=0;
                        oAddress.CountyName='';
                        oAddress.Urbanization='';
                        oAddress.DeliveryPointCode='';
                        oAddress.ResidentialDeliveryIndicator='';
                
                        ct.ClientName = 'G';
                        ct.ApplicationName = 'AM';
                        ct.BusinessName = objprospect.name;
                        ct.ValidateAddress = 'Y';
                        ct.DetailGeographicalCode = 'N';
                        ct.IfMultipleOriginReturnOrigin = 'N';
                        ct.AddressValidated = 'N';
                        ct.AddressOverriden = 'N';
                        ct.MiscellaneousDataCleanup = 'Y';
                        ct.Address = oAddress;
                        System.debug('>>>>>>>>>>>>>>>>>>>>ALL GOOD');
                        result= av.process(ct);
                        System.debug('result**'+result);
                        
                        
                objprospect.zip__c =  result.Address.ZipCode;
                objprospect.address1__c = result.Address.StreetNameOne ;
                objprospect.City__c = result.Address.CityName;
                objprospect.state__c =  result.Address.StateName ;
                objprospect.Country__c = result.Address.Country;
                //lead.name= result.BusinessName;
                
                //notvalidadd=false;
                String  adrRc = string.valueof(result.AddressReturnCode);
                String  adrErrMsg = result.ErrorMessage.AddressErrorMessage;//AddressValidationReturnCode;//AddressErrorMessage;
                
                
                objprospect.Address_Validation_Error__c  = adrErrMsg ;
                objprospect.Address_Validated__c = true;
                // If address is not valid, display error message which is generated by websrvice
                if(!adrRc.equals('0') )
                {
                        //system.debug('adrErrMsg: ' +adrErrMsg ) ;
                        //ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.ERROR,'INVALID ADDRESS--'+adrErrMsg));
                        objprospect.Address_Validated__c = false;
                        //account.Address_Validated__c = false;
                        //notvalidadd=true;
                }
                else
                {
                    objprospect.Address_Validation_Error__c  = null ;
                    objprospect.Address_Validated__c = true;
                }
                //system.debug('The variable-->'+notvalidadd);
               // system.debug('After : ' +name + street1  + city +state +  zip  + country  ) ;
                //return notvalidadd;
                prospectListobj.add(objprospect);
                             
            }
                catch(Exception ex)
                {
                    
                } 
            }
        }  
        update prospectListobj;    
        
    }
    /* This method is to execute to relase some resources if any*/
    global void finish(Database.BatchableContext BC)
    {
        //prospectBatch.Prospect_Batch_Execution_Date__c = system.now();//.addHours(3);
        //upsert prospectBatch;
    }
     /**
        This method must be there to implement Schedulable interface
    **/
    global void execute(SchedulableContext sc)
    {
        String strQuery = '';
        Prospect_AddValidation_Batch assignBatch = new Prospect_AddValidation_Batch(strQuery);
        database.executebatch(assignBatch, 10);
        
    } 

}