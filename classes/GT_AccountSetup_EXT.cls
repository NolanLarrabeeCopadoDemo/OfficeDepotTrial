public class GT_AccountSetup_EXT {
   
   public static String masterSetupVar{get;set;}
   public String conditionalSetupVar{get;set;}
   public integer varTypeInt;
   
   
   public PageReference basicAuthCallout(){
        String oppId = ApexPages.currentPage().getParameters().get('oppId');
        Opportunity oppObj;
        Account acc;
        Contact conObj = new Contact();
        if(masterSetupVar == '1' && conditionalSetupVar=='2Y'){
             varTypeInt=1;
             system.debug('Setup type1....!!');}
             else if(masterSetupVar == '1' && conditionalSetupVar=='2N'){
             varTypeInt=2;
             system.debug('Setup type2....!!');}
             else if(masterSetupVar == '3'){
             varTypeInt=3;
             system.debug('Setup type3....!!');
         }
         else {
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error,'Please input valid selection'));
        }
        
        
        if(oppId!=null) {
            oppObj = getOpportunityDetails(oppId);
        }    
        
        if(oppObj!=null) {
            acc = getAccountDetails(oppObj.accountId);
            try {
              conObj = [select id,firstname, lastname, phone, email, Birthdate, LastCURequestDate, LastCUUpdateDate, LeadSource,Site_Account__c, Contact_Source__c, title
               ,Language__c,Phone_Ext__c
                from Contact where accountid=:oppObj.accountId and Primary_Contact__c = true];
            }
            catch(Exception e) {
                system.debug('Exception occured. Failed to fetch primary contact'+e);
            }
        }
        string salesrep=acc.owner.OMX_Rep_Number__c;
        
        if(!String.isblank(salesrep)) {
            salesrep=salesrep.replace('-SM','');
        }  
        string accountpot;
        if(acc.Est_Spend_CAD__c!=null){
        Integer accntpotential= integer.valueof(acc.Est_Spend_CAD__c);
        accountpot= string.valueof(accntpotential);
        }
        string parentId=acc.parent.omx_primary_key__c;
        if(parentId!=null)
        parentId=parentId.substring(0,6);
        String language=UserInfo.getLanguage();
        if(language.contains('en'))
        language='English';
        else
        language='French';
        String encodedAddr2='';
        if(acc.Address2__c!=null){
            encodedAddr2 = acc.Address2__c.escapexml();
        }
        system.debug('&&&&&lang'+language);
        //CustomSettingName__c mc = CustomSettingName__c.getInstance('00eE0000000XX1I');
        List<UserPass__c> codelist = UserPass__c.getAll().values();
        system.debug('codelist'+codelist );
        String reqXML = '<?xml version="1.0" encoding="UTF-8" ?><fc_request><fc_auth><username>'+codelist[0].Username__c+'</username><password>'+codelist[0].Password__c+'</password><session_id>'+UserInfo.getSessionId()+'</session_id><userLanguage>'+language+'</userLanguage></fc_auth><fc_body><ACCOUNT_SETUP_TYPE>'+varTypeInt+'</ACCOUNT_SETUP_TYPE><AccountName>'+acc.name.escapexml()+'</AccountName><SFDC_PROSPECTID>'+acc.id+'</SFDC_PROSPECTID><ParentOMX>'+parentId+'</ParentOMX><WhiteCollarWorkers>'+acc.Org_WCW_Count_Rep__c+'</WhiteCollarWorkers><PhoneExtension>'+acc.Phone_Ext__c+'</PhoneExtension><TotalEmployees>'+acc.Org_WCW_Count_Rep__c+'</TotalEmployees><AccountPotential>'+accountpot+'</AccountPotential><SALESREPNUMBER>'+salesrep+'</SALESREPNUMBER><PRIMARYADDRESS><ADDRESS_LINE1>'+acc.Address1__c.escapexml()+'</ADDRESS_LINE1><ADDRESS_LINE2>'+encodedAddr2+'</ADDRESS_LINE2><CITY>'+acc.city__c+'</CITY><Province>'+acc.state__c+'</Province><POSTALCODE>'+acc.zip__c+'</POSTALCODE></PRIMARYADDRESS><CONTACT><FNAME>'+conObj.firstname.escapexml()+'</FNAME><LNAME>'+conObj.lastname.escapexml()+'</LNAME><PHONE>'+conObj.phone+'</PHONE><ext>'+conObj.Phone_Ext__c+'</ext><Title>'+conObj.title.escapexml()+'</Title><Language>'+conObj.language__c+'</Language><LastCURequestDate>'+conObj.LastCURequestDate+'</LastCURequestDate><LastCUUpdateDate>'+conObj.LastCUUpdateDate+'</LastCUUpdateDate><AdminOnly>'+conObj.Site_Account__c+'</AdminOnly><Birthdate>'+conObj.Birthdate+'</Birthdate><EMAIL>'+conObj.email+'</EMAIL></CONTACT></fc_body></fc_request>';
        //tempReqXML = tempReqXML.replaceAll('&','&amp;');
        //tempReqXML = tempReqXML.replaceAll('"','&quot;');
        //tempReqXML = tempReqXML.replaceAll('\'','&apos;');
        //string reqXML = tempReqXML;
        system.debug('@@@@@@@@@@@@@@@@@@@reqXML '+reqXML );

        HttpRequest req = new HttpRequest();
        HttpResponse res = new HttpResponse();
        Http http = new Http();
        String endpointUrl = codelist[0].EndpointURL__c;
        req.setEndpoint(endpointUrl);
     
     //req.setEndpoint('https://www.grandandtoy.com/sites/salesforce/fc/processSFfcApplication.aspx');
     
     ////  req.setEndpoint('https://stage.officemaxcanada.com/sites/salesforce/fc/processSFfcApplication.aspx');

       //// req.setEndpoint('https://www.officemaxcanada.com/sites/salesforce/fc/processSFfcApplication.aspx');

        req.setMethod('POST');
        req.setBody(reqXML);
        
        PageReference FC;

        try {
            if (Test.isRunningTest()) { 
             HttpResponse testRes = new HttpResponse();
             testRes.setStatus('OK');
             testRes.setStatusCode(200);
             testRes.setBody('@@@@<target_url>http://Officemaxcanada.com</target_url>@@@@');
             res = testRes;
            }
            else
            {
            res = http.send(req);
            }  
            String s1=res.getBody();
                      
            if(s1.contains('<target_url>')){            
            List<String>redirectURLList=s1.split('<target_url>');           
            String redirectURL=redirectURLList[1];
            List<String>redirectURLList1=redirectURL.split('</target_url>');
            redirectURL=redirectURLList1[0];
            System.debug('&&&&&redirectURL'+redirectURL);
            redirectURL=redirectURL.replace('&amp;','&');
                        System.debug('&&&&&redirectURL'+redirectURL);

            FC = new PageReference(redirectURL);
            }
            else{
            FC = new PageReference('http://Officemaxcanada.com');
            } 
           FC.setRedirect(true);
            return fc;
            
        
        } catch(System.CalloutException e) {
            System.debug('Callout error: '+ e);
            System.debug(res.getBody());
        }
        return null;     
     
   }
  
  public Opportunity getOpportunityDetails(String oppId) {
      Opportunity oppObj = new Opportunity();
      try {
          oppObj  = [select id, accountId from Opportunity where id=:oppId];
          if(oppObj!=null) {
              return oppObj ;
          }
      }
      catch(Exception ex) {
          system.debug('Exception occured. Failed to fetch Opportunity record.'+ex);
      }
      
      return null;
  }
  public Account getAccountDetails(String accountId) {
      Account accObj = new Account();
      try {
          accObj = [select id,name,Org_WCW_Count_Rep__c,Phone_Ext__c,Est_Spend_CAD__c, parent.omx_primary_key__c, owner.OMX_Rep_Number__c,Address1__c, Address2__c, City__c, State__c, Zip__c,GT_Segment__c from Account where id=:accountId];
          if(accObj!=null) {
              return accObj;
          }
      }
      catch(Exception ex) {
          system.debug('Exception occured. Failed to fetch account record.'+ex);
      }
      
      return null;
  }
  
}