// Communities 2.1 - Controller for SPC Card Template Page.

public class com2SPCCardController {
    public String GPOid {get; set;} // GPO Group's number
    public GPO_Group__c selectedGroup {get; set;} // GPO Group
    public GPO_Community_Setup__c commSetup {get; set;} // Custom Setting for Communities v2
    public Account gpoAccount {get; set;}
    public User accountOwner {get; set;}
    public String spcNumber {get; set;}
    public String companyName {get; set;}
    public String fullXML {get; set;}
    public HTTPResponse res {get; set;}

    public PageReference check() {
        //  If no SPC number is available, redirect to error page
        if (spcNumber == '0' || spcNumber == 'Error') {
            return new PageReference(commSetup.URL_Insert__c + 'com2SPCErrorPage?id=' + selectedGroup.AOPS_Cust_ID__c);
        } else {
            return null;
        }
    }

    public com2SPCCardController() {
        String decryptedDataString = '';
        String token = 'XYZ';
        String GPOid_pageid = ApexPages.currentPage().getParameters().get('id');

        GPOid = GPOid_pageid;

        List<TechDepotSetting__c> tech = [Select Id,Crypto_key__C from TechDepotSetting__c where name ='Key'];

        if(!Test.isRunningTest()) {
            Blob cryptoKey =EncodingUtil.base64Decode(tech[0].Crypto_key__c);

            Blob data  = EncodingUtil.base64Decode(GPOid_pageid );
            Blob decryptedData= Crypto.decryptWithManagedIV('AES256', cryptoKey, data);
            // Decode the decrypted data for subsequent use
            List<String> params= decryptedData.toString().split('@');
            GPOid = params[0];
            token = params[1];
        }



        //     if (GPOid.length() < 8)
        //       GPOid = '0' + GPOid;
        system.debug('ID: ' + GPOid);
        selectedGroup =
        [SELECT Community_Name__c, Community_Image__c, Account__c, AOPS_Cust_ID__c,token__C,
         ExpireLink__c FROM GPO_Group__c WHERE Account__r.AOPS_Cust_Id__c =: GPOid Limit 1];
         
        commSetup = gpo_community_setup__c.getValues('com2Settings');
        gpoAccount = [SELECT ownerId,Name FROM Account WHERE id =: selectedGroup.Account__c];
        companyName = gpoAccount.Name;
        accountOwner = [SELECT Name, Email, Phone, System_User__c, isActive FROM User WHERE id =: gpoAccount.ownerId];
        try {
            system.debug('string token: ' + selectedGroup.token__C + ' param2 :' +  token );
            if(selectedGroup.token__C  == token && system.now() < selectedGroup.ExpireLink__c  )
            {
                spcNumber = getSPCNumber(GPOid,companyName);
            }
            else
            {
                spcNumber = 'Error';
            }
        } catch(Exception e) {
            spcNumber = 'Error';
        }
    }

    public String getSPCNumber(String custID,String companyName){
        String soaUser = commsetup.SOA_User__c;
        System.debug(soaUser);
        String[] logins = soaUser.split(':');
        String username = logins[0];
        String password = logins[1];
        String endpoint = commsetup.SPC_Service_URL__c;
        String header =
            '<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:spc="http://eai.officedepot.com/service/SPCCardInfo"><soapenv:Header><wsse:Security soapenv:mustUnderstand="1" xmlns:wsse="http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-wssecurity-secext-1.0.xsd"><wsse:UsernameToken wsu:Id="UsernameToken-4" xmlns:wsu="http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-wssecurity-utility-1.0.xsd"><wsse:Username>';
        String midpoint =
            '</wsse:Username><wsse:Password Type="http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-username-token-profile-1.0#PasswordText">';
        String midpoint2 =
            '</wsse:Password></wsse:UsernameToken></wsse:Security></soapenv:Header><soapenv:Body><spc:getSPCCardInfoRequest><spc:customerId>';
        String footer = '</spc:customerId></spc:getSPCCardInfoRequest></soapenv:Body></soapenv:Envelope>';
        fullXML = header + username + midpoint + password + midpoint2 + custID + footer;
        system.debug(fullxml);
        //CustTransParentChildLevel__c soaSetting = [select soa_user__c from CustTransParentChildLevel__c limit 1];
        //String soaUser = soaSetting.soa_user__c;

        // String encodedusernameandpassword = 'Basic ' + EncodingUtil.base64Encode(Blob.valueOf(soaUser));

        // HTTP call to request the SPC Number.
        Http eaiCall = new Http();
        HttpRequest req = new HttpRequest();
        req.setEndpoint(endPoint);
        req.setMethod('POST');
        req.setBody(fullXML);
        req.setHeader('Content-Type', 'text/xml');
        //req.setHeader('SOAPAction', soapAction);
        //req.setHeader('Authorization', encodedusernameandpassword);
        req.setTimeout(120000);
        spcNumber = 'x';
        if (!Test.isRunningTest()) {
            res = eaiCall.send(req);
            Dom.Document doc = res.getBodyDocument();
            Dom.XMLNode root = doc.getRootElement();
            Dom.XMLNode body = root.getChildElement('Body', 'http://schemas.xmlsoap.org/soap/envelope/' );
            system.debug('BODY = ' + body);
            Dom.XMLNode next1 = body.getChildElement('getSPCCardInfoResponse', 'http://eai.officedepot.com/service/SPCCardInfo' );
            system.debug(next1);
            Dom.XMLNode next2 = next1.getChildElement('spcCardNumber', 'http://eai.officedepot.com/service/SPCCardInfo' );
            system.debug(next2);
            //   Dom.XMLNode next3 = next2.getChildElement('CardDetails', 'http://xmlns.officedepot.com/ODHome/EnterpriseArtifacts/SFDC/GetSPCCardInfoProcess');
            //   Dom.XMLNode next4 = next3.getChildElement('CardNumber', 'http://xmlns.officedepot.com/ODHome/EnterpriseArtifacts/SFDC/GetSPCCardInfoProcess');
            spcNumber = next2.getText();
            system.debug(spcNumber);
        } else {
            spcNumber = 'XXXXXXX';
        }
        return spcNumber;
    }

    // Returns current year
    public Integer getCurrentYear(){
        return System.Today().year();
    }
}