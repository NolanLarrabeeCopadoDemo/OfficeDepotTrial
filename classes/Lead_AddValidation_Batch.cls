/***
Description: This Batch validates the address of the leads.
Created By: Subhrajyoti
Created Date: 19-July-2013

Modified By:Abinaya
Modified Date:22-July-2013

Modify Reason: To make dynamic query
**/
Global class Lead_AddValidation_Batch implements database.Batchable<Sobject>,Schedulable,Database.AllowsCallouts
{
    public String strQuery; //this variable used to set query from test class or from shceduler if required
    public List<Lead> leadListobj = new List<Lead>();
    //Lead_Batch_Execution_Details__c  leadBatch= Lead_Batch_Execution_Details__c.getOrgDefaults();
    //Datetime Previousday = leadBatch.Lead_Batch_Execution_Date__c.addHours(4);
   // public String Previousday1= Previousday.format('yyyy-MM-dd\'T\'HH:mm:ss.SSS\'Z\'');//Date.today().addDays(-1);
     // Below is set a default query in case not set in test class or in scheduler
     //private String DEFAULT_QUERY ='select id, Name,address1__c,Address_Validation_Error__c,Address_Validated__c,address2__c,City__c,state__c,country__c,zip__c from Lead Where IsConverted = false and lastmodifieddate >'+Previousday1+'';//Address_Changed_from__c =\'Batch\'
      private String DEFAULT_QUERY ='select id, Name,address1__c,Address_Validation_Error__c,Address_Validated__c,address2__c,City__c,state__c,country__c,zip__c from Lead Where IsConverted = false and lastmodifieddate > yesterday';//Address_Changed_from__c =\'Batch\'
      /* Default Constructor*/
    global Lead_AddValidation_Batch()
    {
   // system.debug('Previousday **'+Previousday+'**query**'+DEFAULT_QUERY );
        this.strQuery = DEFAULT_QUERY;
    }
        /*This costructor is called from the Batch Schedule method*/
    global Lead_AddValidation_Batch(String query)
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
        List<Lead> addvalidatelead= scope;
        integer count = 0;
        for(Lead objlead:addvalidatelead)  
        {
            if(objlead.country__c=='USA' && objlead.address1__c!=null && objlead.City__c!=null && objlead.state__c!=null && objlead.zip__c!=null)
            {
            count = count + 1;
            system.debug('count----'+count);
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
                  
                        oAddress.StreetNameOne = objlead.address1__c;
                        oAddress.StreetNameTwo = ''; 
                        oAddress.PostOfficeBox = '';
                        oAddress.CityName = objlead.City__c;
                        oAddress.StateName = objlead.state__c;
                        oAddress.ZipCode = objlead.zip__c;
                        oAddress.Province ='';
                        oAddress.Country=objlead.country__c;
                        oAddress.GeographicalCodeOne=0;
                        oAddress.GeographicalCodeTwo=0;
                        oAddress.CountyName='';
                        oAddress.Urbanization='';
                        oAddress.DeliveryPointCode='';
                        oAddress.ResidentialDeliveryIndicator='';
                
                        ct.ClientName = 'G';
                        ct.ApplicationName = 'AM';
                        ct.BusinessName = objlead.name;
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
                        
                        
                objlead.zip__c =  result.Address.ZipCode;
                objlead.address1__c = result.Address.StreetNameOne ;
                objlead.City__c = result.Address.CityName;
                objlead.state__c =  result.Address.StateName ;
                objlead.Country__c = result.Address.Country;
                //lead.name= result.BusinessName;
                
                //notvalidadd=false;
                String  adrRc = string.valueof(result.AddressReturnCode);
                String  adrErrMsg = result.ErrorMessage.AddressErrorMessage;//AddressValidationReturnCode;//AddressErrorMessage;
                
                
                objlead.Address_Validation_Error__c  = adrErrMsg ;
                objlead.Address_Validated__c = true;
                // If address is not valid, display error message which is generated by websrvice
                if(!adrRc.equals('0') )
                {
                        //system.debug('adrErrMsg: ' +adrErrMsg ) ;
                        //ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.ERROR,'INVALID ADDRESS--'+adrErrMsg));
                        objlead.Address_Validated__c = false;
                        //account.Address_Validated__c = false;
                        //notvalidadd=true;
                }
                else
                {
                    objlead.Address_Validation_Error__c  = null ;
                    objlead.Address_Validated__c = true;
                }
                //system.debug('The variable-->'+notvalidadd);
               // system.debug('After : ' +name + street1  + city +state +  zip  + country  ) ;
                //return notvalidadd;
                //objlead.Address_Changed_from__c = 'UI';
                leadListobj.add(objlead);
                             
            }
                catch(Exception ex)
                {
                    
                } 
            }
        }  
        update leadListobj;    
        
    }
    /* This method is to execute to relase some resources if any*/
    global void finish(Database.BatchableContext BC)
    {
        //leadBatch.Lead_Batch_Execution_Date__c = system.now();//.addHours(3);
        //upsert leadBatch;
    }
     /**
        This method must be there to implement Schedulable interface
    **/
    global void execute(SchedulableContext sc)
    {
        String strQuery = '';
        Lead_AddValidation_Batch assignBatch = new Lead_AddValidation_Batch(strQuery);
        database.executebatch(assignBatch, 10);
        
    } 

}