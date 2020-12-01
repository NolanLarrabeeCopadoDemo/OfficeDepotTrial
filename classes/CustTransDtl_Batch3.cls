global class CustTransDtl_Batch3 implements database.Batchable<Sobject>,Schedulable,Database.AllowsCallouts
{

    public String strQuery;
    public String accountid;
    public Integer batchCount = 0; 

    
    //private String DEFAULT_QUERY = 'SELECT id,Fax_back_phone_number__c,aops_flag__c,BO_Allowed_Cancel__c,recordtype.name,recordtypeid,Account_ID__c,Dept_Dollar_Limit__c,Dept_Addtl_Instructions__c,Dept_Description__c,Dept_Key__c,Cost_Center_ID__c,Cost_Center_Descr__c,PO_Limit__c,PO_Comment__c,PO_Expiration_Date__c, PO_Number__c,PO_ID__c,Customer_assigned_location__c,MIPAL_alternate_location_flag__c,Drop_Ship__c, Customer_Transition_ID__r.Status__c, Customer_Transition_ID__r.account__r.AOPS_Cust_Id__c FROM Customer_Transition_Dtls__c where Customer_Transition_ID__r.account__r.AOPS_Cust_Id__c 
    //!= null and Status__c=\'Active\' and Customer_Transition_ID__r.Status__c=\'Launched\' and (Error_Code__c = \'Error\' or Error_Code__c = \'\' or Error_Code__c = null) limit 100000';   
     //S-333095 [Hemant 7/1/2015] - Adding field Tax_Exemption__c
    private String DEFAULT_QUERY = 'SELECT id, Fax_back_phone_number__c, aops_flag__c, BO_Allowed_Cancel__c, recordtype.name, recordtypeid, Account_ID__c, Dept_Dollar_Limit__c, Dept_Addtl_Instructions__c, Dept_Description__c, Dept_Key__c, Cost_Center_ID__c, Cost_Center_Descr__c, PO_Limit__c, PO_Comment__c, PO_Expiration_Date__c, PO_Number__c, PO_ID__c, Customer_assigned_location__c, MIPAL_alternate_location_flag__c, Drop_Ship__c, Customer_Transition_ID__r.Status__c, Customer_Transition_ID__r.account__r.AOPS_Cust_Id__c, Customer_Transition_ID__r.Ready_For_Mod_5__c, Tax_Exemption__c, Split_Driven__c, Customer_Transition_ID__r.Final_Split_Decision__c ' 
                                 + 'FROM Customer_Transition_Dtls__c ' 
                                 + 'WHERE Customer_Transition_ID__r.account__r.AOPS_Cust_Id__c != null '
                                 + 'AND Status__c=\'Active\' '
                                 + 'AND Customer_Transition_ID__r.Ready_for_Mod1__c = true '
                                 //+ 'AND (Error_Code__c = \'Error\' or Error_Code__c = \'\' or Error_Code__c = null) '
                                 + 'AND (Error_Code__c = \'\' or Error_Code__c = null) '
                                 + 'AND (recordtype.name=\'Cost Center\' or recordtype.name = \'Purchase Order\' or ( (recordtype.name = \'Sites\' and aops_flag__c = \'Y\') '
                                 + 'AND (Customer_Transition_ID__r.Final_Split_Decision__c = \'No\'   or Customer_Transition_ID__r.Final_Split_Decision__c = null OR (Customer_Transition_ID__r.Final_Split_Decision__c = \'Yes\' AND Split_Driven__c = true)))) ' 
                                 + 'LIMIT 300000';
    /* Default Constructor*/
    global CustTransDtl_Batch3()
    {
        this.strQuery = DEFAULT_QUERY;
    }
    /*This costructor is called from the Batch Schedule method*/
    global CustTransDtl_Batch3(String query)
    {
        //System.debug('QUERY IS---->'+query);
        if(query != null && query != '')
            this.strQuery = query;
        else
            this.strQuery = DEFAULT_QUERY;
    }
    // This method prepares the scope of the batch program based on the query result 
    global Database.QueryLocator start(Database.BatchableContext BC)
    {
        return Database.getQueryLocator(strQuery);
    }
    
    // This method processes query result in batches 
    global void execute(Database.BatchableContext BC, SObject[] scope){
        String headerXML1,headerXML2,requestType,parentXML,detailXML,footerXML,fullXML,endPoint,soapAction,domain,user;
        
        //ExtIDSalesPerson__c from Custom Setting
        Map<String, EXT_Sales_Person_IDs__c> ExtSPID = EXT_Sales_Person_IDs__c.getAll();
        Set<String> setExtSPID = new Set<String>();
        if(ExtSPID != NULL)
        setExtSPID = ExtSPID.keySet();
        System.Debug('setExtSPID@@@'+setExtSPID);
        
        CustTransParentChildLevel__c PCLevel2 = [select SOA_EndPoint__c,soa_user__c from CustTransParentChildLevel__c limit 1];
        system.debug('Debug PCLevel2 >>>>>>'+PCLevel2.SOA_EndPoint__c  );
        If (PCLevel2.SOA_EndPoint__c != null) {
          system.debug('Debug trace1>>>>>>');
          domain = PCLevel2.SOA_EndPoint__c;
          user = PCLevel2.soa_user__c;
        }
        else
          domain = 'https://osbuat01.officedepot.com/';
        endPoint = domain + 'osb-infra/B2BAccountAttributesService';

        batchCount = batchCount +1;
        List<Customer_Transition_dtls__c> listCustDtl = scope; 
        
        Set<ID> sAccIDs = new Set<ID>();
        for(Customer_Transition_dtls__c ctd : listCustDtl){
            
            if(ctd.Customer_Transition_ID__r.account__c != null)
                sAccIDs.add(ctd.Customer_Transition_ID__r.account__c);
            if(ctd.Account_ID__c != null)
                sAccIDs.add(ctd.Account_ID__c);
        }    
        
        Map<ID,Account_Setup_Request__c> map_ID_accSetupReq = new Map<ID,Account_Setup_Request__c>(); //
        for(Account_Setup_Request__c acs : [Select id,lastmodifiedby.name,LastModifieddate, Account_Setup_Request_Number__c,name,Account__c  from Account_Setup_Request__c where Account__c in :sAccIDs ])
     
            map_ID_accSetupReq.put(acs.Account__c,acs);
        
        Map<ID,Account> map_ID_Account = new Map<ID,Account>([Select id,ownerid,Sales_PersonID__r.name,Duns_Number__c,Status__c,OMX_Primary_Key__c,Oracle_Party_Site_Id__c,AOPS_Seq_ID__c,address1__c,address2__c,city__c,Zip__c,Zip_5digit__c,Country__c,state__c,AOPS_Cust_Id__c, name from Account where id in :sAccIDs ]);
        
        Set<ID> ownerIDs = new Set<ID>();
        Map<ID,String> ownerToRep = new Map<ID,String>();
        
        for (Account a:map_ID_Account.values())
           ownerIDs.add(a.ownerid); 
        
        For (sales_person__c s:[Select user__c,ExtIDSalesPerson__c from sales_person__c where user__c = :ownerIDs and IsActive__c = true and Primary__c = true and ExtIDSalesPerson__c not in :setExtSPID ])
           ownerToRep.put(s.user__c,s.ExtIDSalesPerson__c);
        
        List<Id> stopTransmission = new List<Id>();
        
        for(Customer_Transition_dtls__c ctd : listCustDtl){
           
           headerXML1=null;
           headerXML2=null;
           requestType=null;
           parentXML=null;
           detailXML=null;
           footerXML=null;
           fullXML=null;
           
           headerXML1 = '<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:acc="http://www.officedepot.com/model/accountattributes" xmlns:tran="http://www.officedepot.com/model/transaction">'
                       + '<soapenv:Header/>'
                       + '<soapenv:Body>';
                      // + '<costCentersRequest xmlns="http://www.officedepot.com/model/accountattributes" '
            footerXML = '</soapenv:Body>'
                        + '</soapenv:Envelope>';
                       
            Account_Setup_Request__c accSetReqRec = map_ID_accSetupReq.get(ctd.Customer_Transition_ID__r.account__c);
            Account masterAcc = map_ID_Account.get(ctd.Customer_Transition_ID__r.account__c);
            
            //Changed Line 116 Case # 00738854
            //if(accSetReqRec.LastModifieddate!=null)
            String dt;
            dt= String.valueOf(DateTime.Now());
            String[] dtArr = dt.split(' ');
            String timeStamp = dtArr[0]+'T'+dtArr[1]+'-04:00';
            system.debug('@@@dt' + dt);
            system.debug('@@@timeStamp' + timeStamp);
                    
            parentXML = '<accountHeader>' //
                         + '<requestID>'+accSetReqRec.Account_Setup_Request_Number__c+'</requestID>'
                         + '<requestTimeStamp>'+timeStamp+'</requestTimeStamp>'
                         + '<requestorID>'+accSetReqRec.lastmodifiedby.name+'</requestorID>'
                         + '<actionCodeCUD>C</actionCodeCUD>'
                         + '<customerID>'+masterAcc.AOPS_Cust_Id__c+'</customerID>'
                         + '</accountHeader>';
            
            string deptDollarLimit ='';
            
            if (ctd.Dept_Dollar_Limit__c != null)
                deptDollarLimit = String.valueOf(ctd.Dept_Dollar_Limit__c); 
                    
            if(ctd.recordtype.name=='Cost Center') {
            
                 soapAction = '"'+domain+'B2BAccountAttributesService/20140822/addCostCenter"';
                 headerXML2 = '<costCentersRequest xmlns="http://www.officedepot.com/model/accountattributes" '
                       + 'xmlns:env="http://schemas.xmlsoap.org/soap/envelope/" '
                       + 'xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">'
                       + '<transactionHeader xmlns="http://www.officedepot.com/model/transaction">'
                       + '<consumer>'
                       + '<consumerName>SFDC</consumerName>'
                       + '<consumerTransactionID>'+ctd.id+'</consumerTransactionID>'
                       + '</consumer>'
                       + '</transactionHeader>';
                 detailXML =   '<costCenters><costCenter>' + parentXML
                             + '<costCenterID>'+ctd.Id+'</costCenterID>'
                             + '<deptKey>'+nvlString(ctd.Cost_Center_ID__c)+'</deptKey>'
                             + '<deptDesc>'+nvlString(splChar(ctd.Cost_Center_Descr__c))+'</deptDesc>'
                             + '<deptAddInstructions>'+nvlString(ctd.Dept_Addtl_Instructions__c)+'</deptAddInstructions>'
                             + '<deptDollarLimit>0</deptDollarLimit>'
                             + '</costCenter>'
                             + '</costCenters>'
                             + '</costCentersRequest>';
                             
            }
            else if (ctd.recordtype.name == 'Purchase Order') {
                 soapAction = '"'+domain+'B2BAccountAttributesService/20140822/addPurchaseOrder"';
                 headerXML2 = '<acc:purchaseOrderRequest>'
                       + '<tran:transactionHeader>'
                       + '<tran:consumer>'
                       + '<tran:consumerName>SFDC</tran:consumerName>'
                       + '<tran:consumerTransactionID>'+ctd.id+'</tran:consumerTransactionID>'
                       + '</tran:consumer>'
                       + '</tran:transactionHeader>';
                 parentXML = 
                           '<acc:accountHeader>' //
                         + '<acc:requestID>'+accSetReqRec.Account_Setup_Request_Number__c+'</acc:requestID>'
                         + '<acc:requestTimeStamp>'+timeStamp+'</acc:requestTimeStamp>'
                         + '<acc:requestorID>'+accSetReqRec.lastmodifiedby.name+'</acc:requestorID>'
                         + '<acc:actionCodeCUD>C</acc:actionCodeCUD>'
                         + '<acc:customerID>'+masterAcc.AOPS_Cust_Id__c+'</acc:customerID>'
                         + '</acc:accountHeader>';
                 string expirationDate='',polimit='';
                 
                 if (ctd.PO_Expiration_Date__c != null)
                   expirationDate = String.valueOf(ctd.PO_Expiration_Date__c);
                 if (ctd.PO_Limit__c != null)
                   polimit = String.valueOf(ctd.PO_Limit__c);
                   
                 detailXML =   '<acc:purchaseOrders><acc:purchaseOrder>' + parentXML
                             + '<acc:poNumber>'+nvlString(ctd.PO_Number__c)+'</acc:poNumber>'
                             + '<acc:poID>'+nvlString(ctd.ID)+'</acc:poID>'
                             //+ '<acc:expirationDate>'+expirationDate+'</acc:expirationDate>'
                             //+ '<acc:comment>'+nvlString(ctd.PO_Comment__c)+'</acc:comment>'
                             + '<acc:poLimit>0</acc:poLimit>'
                             + '</acc:purchaseOrder>'
                             + '</acc:purchaseOrders>'
                             + '</acc:purchaseOrderRequest>';
            }
            else if (ctd.recordtype.name == 'Sites' && ctd.aops_flag__c == 'Y' && map_ID_Account.get(ctd.account_id__c) != null) {
                 
                 String faxbck;
                 
                  
                 if (ctd.Fax_back_phone_number__c == null)
                   faxbck = '9999999999';
                 else
                  faxbck = ctd.Fax_back_phone_number__c;
                 
                 soapAction = '"'+domain+'B2BAccountAttributesService/20140822/addShipToAddresses"';
                 headerXML1 = '<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:acc="http://www.officedepot.com/model/accountattributes" xmlns:tran="http://www.officedepot.com/model/transaction" xmlns:esb="http://www.officedepot.com/model/Common/ESBCommon">'
                       + '<soapenv:Header/>'
                       + '<soapenv:Body>';
               headerXML2 = '<acc:shipToAddressRequest>'
                       + '<tran:transactionHeader>'
                       + '<tran:consumer>'
                       + '<tran:consumerName>SFDC</tran:consumerName>'
                       + '<tran:consumerTransactionID>'+ctd.id+'</tran:consumerTransactionID>'
                       + '</tran:consumer>'
                       + '</tran:transactionHeader>';                       
                       
                       
                 parentXML = 
                           '<acc:accountHeader>' // 
                         + '<acc:requestID>'+accSetReqRec.Account_Setup_Request_Number__c+'</acc:requestID>'
                         + '<acc:requestTimeStamp>'+timeStamp+'</acc:requestTimeStamp>'
                         + '<acc:requestorID>'+accSetReqRec.lastmodifiedby.name+'</acc:requestorID>'
                         + '<acc:actionCodeCUD>C</acc:actionCodeCUD>'
                         + '<acc:customerID>'+masterAcc.AOPS_Cust_Id__c+'</acc:customerID>'
                         + '</acc:accountHeader>';
                 Account childAcc = map_ID_Account.get(ctd.account_id__c);
                 if (childAcc != null)
                 {
                 String locreqCode = '';
                 string accKey;
                 if(childAcc.OMX_Primary_Key__c !=null){
                 integer lengthstr= childAcc.OMX_Primary_Key__c.length();             
                 acckey=childAcc.OMX_Primary_Key__c.substring(7,lengthstr);
                 
                 }
                 
                 if (ctd.Customer_assigned_location__c != null)
                   locreqCode = String.valueOf(ctd.Customer_assigned_location__c);
                 detailXML =   '<acc:shipToAddresses><acc:shipToAddress>' + parentXML
                             + '<acc:address>'
                             + '<esb:addressLine1>'+nvlString(splChar(childAcc.address1__c))+'</esb:addressLine1>'
                             + '<esb:addressLine2>'+nvlString(splChar(childAcc.address2__c))+'</esb:addressLine2>'
                             + '<esb:city>'+nvlString(childAcc.city__c)+'</esb:city>'
                             + '<esb:region></esb:region>'
                             + '<esb:postalCode>'+nvlString(childAcc.zip__c)+'</esb:postalCode>'
                             + '<esb:companyName>'+trunc30(splChar(childAcc.name))+'</esb:companyName>'
                             + '<acc:state>'+nvlString(childAcc.state__c)+'</acc:state>'
                             + '<acc:province></acc:province>'
                             + '<acc:countryCode>'+nvlString(childAcc.Country__c)+'</acc:countryCode>'
                             //+ '<acc:addressSeq>1</acc:addressSeq>'
                             + '<acc:addressID>'+ctd.Account_ID__c+'</acc:addressID>'
                             + '<acc:oracleShipToSiteID>'+nvlString(childAcc.Oracle_Party_Site_Id__c)+'</acc:oracleShipToSiteID>'
                             + '<acc:omaxShipToSiteID>'+nvlString(splChar(childAcc.OMX_Primary_Key__c))+'</acc:omaxShipToSiteID>'
                             + '<acc:addressKey>'+accKey+'</acc:addressKey>'
                             + '</acc:address>'
                             + '<acc:addressStatus>'+nvlString(childAcc.Status__c)+'</acc:addressStatus>'
                             + '<acc:billToAddress>N</acc:billToAddress>'
                             + '<acc:shipToAddress>Y</acc:shipToAddress>'
                             + '<acc:addressDUNSID>'+nvlNumeric(childAcc.Duns_Number__c)+'</acc:addressDUNSID>'
                             + '<acc:backOrderAllowed>'+nvlYN(ctd.BO_Allowed_Cancel__c)+'</acc:backOrderAllowed>'
                             + '<acc:locationReqCode>'+locreqCode+'</acc:locationReqCode>';
                             
                             if (ownerToRep.containskey(childAcc.ownerid))
                                detailXML = detailXML + '<acc:salesPersonID>'+nvlString(ownerToRep.get(childAcc.ownerid))+'</acc:salesPersonID>';
                             
                             detailXML = detailXML + '<acc:excludeDropShip>'+nvlString(ctd.Drop_Ship__c)+'</acc:excludeDropShip>'
                             + '<acc:excludeAlternateSourcing>'+nvlString(ctd.MIPAL_alternate_location_flag__c)+'</acc:excludeAlternateSourcing>'    
                             + '<acc:faxNumber>'+faxbck+'</acc:faxNumber>'
                             + '<acc:taxExemptFlag>'+ctd.Tax_Exemption__c+'</acc:taxExemptFlag>'

                             + '</acc:shipToAddress>'
                             + '</acc:shipToAddresses>'
                             + '</acc:shipToAddressRequest>';
                }
            }
            
          if (detailXML != null)     
          {   
           fullXML = headerXML1+headerXML2+detailXML+footerXML;
           System.debug('Generated XML:' + fullXML);
           system.debug('EndPoint:' + endPoint);
           system.debug('SOAP Action:' + soapAction);
           //Authentication
          // String myData = 'development:development123';     
           String myData = user;
           system.debug('>>>>user'+user);
           String encodedusernameandpassword = 'Basic ' + EncodingUtil.base64Encode(Blob.valueOf(myData));
           HttpRequest req = new HttpRequest();
           req.setEndpoint(endPoint);
           req.setMethod('POST');
           req.setBody(fullXML);
           req.setHeader('Content-Type', 'text/xml');
           req.setHeader('SOAPAction', soapAction);
           req.setHeader('Authorization', encodedusernameandpassword);
           req.setTimeout(120000);
           Http http = new Http();
           system.debug('Request:' + req);
           //HTTPResponse res = http.send(req);
           String response;
        
           if (!Test.isRunningTest()){
           HTTPResponse res = http.send(req);
           
           response = res.getBody();
           }
           if (Test.isRunningTest()){
               response = 'Dummy response';
           }
           
           if (response  != null) {
             if (response.length() > 30000)
               ctd.SOA_Response__c = response.substring(0,30000);
             else
               ctd.SOA_Response__c = response;
           }
           
           ctd.Error_Code__c = 'Processing';
         }
         else {
            system.debug('Detail XML Not Found for Recordtype:' + ctd.recordtype.name);
            ctd.SOA_Response__c = 'Detail XML Not Found';  
         }    
 
        }
        
        update listCustDtl;
    }
    
    // This method is to execute to relase some resources if any
    global void finish(Database.BatchableContext BC){
    
      CustTransParentChildLevel__c PCLevel2 = [select Transition_lnterval_DTL__c,Parent_Child_Level__c,CronID_DTL__c from CustTransParentChildLevel__c limit 1];
      integer interval = 900;        
     if (PCLevel2.CronID_DTL__c <> null) {
                      for (CronTrigger t: [SELECT Id FROM CronTrigger where ID=:PCLevel2.CronID_DTL__c])
                         system.abortJob(t.id);
            }
            if (PCLevel2.Transition_lnterval_DTL__c != null)
              interval = integer.valueof(PCLevel2.Transition_lnterval_DTL__c);
              
            DateTime sysTime = System.now().addSeconds(interval);
            String chronExpression = '' + sysTime.second() + ' ' + sysTime.minute() + ' ' + sysTime.hour() + ' ' + sysTime.day() + ' ' + sysTime.month() + ' ? ' + sysTime.year();
    
            CustTransDtl_Batch3 scheduledBatch = new CustTransDtl_Batch3();
            ID cronid = System.schedule( 'CustTransDtl_Batch3' + sysTime, chronExpression, scheduledBatch );
            
            PCLevel2.CronID_DTL__c = cronid;
            
            update PCLevel2; 
    
     //TODO:Logic Needs to be Modified for PROD, this is facilitate SIT and UAT
        /*DateTime sysTime = System.now().addSeconds(120);
        String chronExpression = '' + sysTime.second() + ' ' + sysTime.minute() + ' ' + sysTime.hour() + ' ' + sysTime.day() + ' ' + sysTime.month() + ' ? ' + sysTime.year();
        CustTransDtl_Batch3 scheduledBatch = new CustTransDtl_Batch3();
        System.schedule( 'CustTransDtl_Batch3' + sysTime, chronExpression, scheduledBatch );*/
     //Logic for SIT and UAT Begins
     
     //Logic for SIT and UAT Ends
        
      /*   Integer jobs = [Select count() From AsyncApexJob Where JobType = 'BatchApex' and ( Status = 'Queued' or Status = 'Processing' or Status = 'Preparing' )];
        if( jobs > 4 ){
           // try again in a 5 minutes
            Datetime sysTime;
            if(batchCount > 200){
                sysTime = System.now().addSeconds(300);
                batchCount = 0;
            }    
            String chronExpression = '' + sysTime.second() + ' ' + sysTime.minute() + ' ' + sysTime.hour() + ' ' + sysTime.day() + ' ' + sysTime.month() + ' ? ' + sysTime.year();
            //This batch will always be processed with a batch size of 1
            CustTransDtl_Batch scheduledBatch = new CustTransDtl_Batch();
            System.schedule( 'CustTransDtl_Batch' + sysTime, chronExpression, scheduledBatch );
                 
        }
        else{
            CustTransDtl_Batch3 assignBatch = new CustTransDtl_Batch3(strQuery);
            database.executebatch(assignBatch, 10);
        } */
        
        
    }
    /**
        This method must be there to implement Schedulable interface
    **/
    global void execute(SchedulableContext sc){
        String strQuery = '';
        CustTransDtl_Batch3 assignBatch = new CustTransDtl_Batch3(strQuery);
        database.executebatch(assignBatch, 1);
        
    } 
    
    public String trunc30(String val) {
      if (val == null)
        return '';
      else {
          if(val.length()>30)
                return val.substring(0,30);
          else
            return val;
      }  
    }
    
    public String nvlString(String val) {
        if (val == null)
          return '';
        else
          return val;
    }
    
    public String nvlYN(String val) {
       if (val == null)
         return 'N';
       else
         return val;
    }
    
    public String nvlNumeric(String val) {
        if (val == null)
          return '0';
        else
          return val;
    }
    
    
    public String splChar(String val) {
        String modVal = val;
        if (modVal != null)
        {
        if (val.contains('&'))
           modval = modVal.replace('&','&amp;');
        if (val.contains('<'))
           modval = modVal.replace('<','&lt;');
        if (val.contains('>'))
           modval = modVal.replace('>','&gt;');
        if (val.contains('"'))
           modval = modVal.replace('"','&quot;');
        if (val.contains('\''))
           modval = modVal.replace('\'','&apos;');   
         }
         return modval;
    }
}