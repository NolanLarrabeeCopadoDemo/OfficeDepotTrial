@IsTest
private class AOPS2SFDCDataSyncService_TC {

    @IsTest
    static void failedServiceCall() {
        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
        req.requestBody = Blob.valueOf('{ }'); // Will fail because of no message type and timestamp.
        RestContext.request = req;
        RestContext.response = res;

        AOPS2SFDCDataSyncService.receiveSyncData();
        
        System.assertEquals(400, res.statusCode);
        System.assertEquals('The AOPS to SFDC sync failed.', res.responseBody.toString());
    }
    
    @IsTest
    static void accountMaster() {
        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
        req.requestBody = Blob.valueOf('{ "CXTF000P_MSG_TYPE": "CXTF000P", "CXTF000P_TIMESTAMP": "2020-03-30-01.03.14.3151", "CXTF000P_AOPS_KEY1": "12345678", "FCU000P_CUSTOMER_ID": "12345678", "CXTF000P_ACTION": "C" }');
        RestContext.request = req;
        RestContext.response = res;

        AOPS2SFDCDataSyncService.receiveSyncData();
        
        System.assertEquals(200, res.statusCode);
        System.assertEquals('The AOPS to SFDC sync data been received and stored in Salesforce successfully.', res.responseBody.toString());
    }

    @IsTest
    static void accountBsdAddendum() {
        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
        req.requestBody = Blob.valueOf('{ "CXTC007F_MSG_TYPE": "CXTC007F", "CXTC007F_TIMESTAMP": "2020-03-30-01.03.14.3151", "CXTC007F_AOPS_KEY1": "12345678", "CXTC007F_ACTION": "C" }');
        RestContext.request = req;
        RestContext.response = res;

        AOPS2SFDCDataSyncService.receiveSyncData();
        
        System.assertEquals(200, res.statusCode);
        System.assertEquals('The AOPS to SFDC sync data been received and stored in Salesforce successfully.', res.responseBody.toString());
    }

    @IsTest
    static void accountPreferences() {
        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
        req.requestBody = Blob.valueOf('{ "CXTF370P_MSG_TYPE": "CXTF370P", "CXTF370P_TIMESTAMP": "2020-03-30-01.03.14.3151", "CXTF370P_AOPS_KEY1": "12345678", "CXTF370P_AOPS_KEY2": "90", "CXTF370P_ACTION": "C" }');
        RestContext.request = req;
        RestContext.response = res;

        AOPS2SFDCDataSyncService.receiveSyncData();
        
        System.assertEquals(200, res.statusCode);
        System.assertEquals('The AOPS to SFDC sync data been received and stored in Salesforce successfully.', res.responseBody.toString());
    }

    @IsTest
    static void addressMaster() {
        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
        req.requestBody = Blob.valueOf('{ "CXTF001P_MSG_TYPE": "CXTF001P", "CXTF001P_TIMESTAMP": "2020-03-30-01.03.14.3151", "CXTF001P_AOPS_KEY1": "12345678", "CXTF001P_AOPS_KEY2": "90", "CXTF001P_ACTION": "C" }');
        RestContext.request = req;
        RestContext.response = res;

        AOPS2SFDCDataSyncService.receiveSyncData();
        
        System.assertEquals(200, res.statusCode);
        System.assertEquals('The AOPS to SFDC sync data been received and stored in Salesforce successfully.', res.responseBody.toString());
    }

    @IsTest
    static void addressBsdAddendum() {
        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
        req.requestBody = Blob.valueOf('{ "CXTC009F_MSG_TYPE": "CXTC009F", "CXTC009F_TIMESTAMP": "2020-03-30-01.03.14.3151", "CXTC009F_AOPS_KEY1": "12345678", "CXTC009F_AOPS_KEY2": "90", "CXTC009F_ACTION": "C" }');
        RestContext.request = req;
        RestContext.response = res;

        AOPS2SFDCDataSyncService.receiveSyncData();
        
        System.assertEquals(200, res.statusCode);
        System.assertEquals('The AOPS to SFDC sync data been received and stored in Salesforce successfully.', res.responseBody.toString());
    }

    @IsTest
    static void accountChildParentRelationship() {
        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
        req.requestBody = Blob.valueOf('{ "CXTF005P_MSG_TYPE": "CXTF005P", "CXTF005P_TIMESTAMP": "2020-03-30-01.03.14.3151", "CXTF005P_AOPS_KEY1": "12345678", "CXTF005P_ACTION": "C" }');
        RestContext.request = req;
        RestContext.response = res;

        AOPS2SFDCDataSyncService.receiveSyncData();
        
        System.assertEquals(200, res.statusCode);
        System.assertEquals('The AOPS to SFDC sync data been received and stored in Salesforce successfully.', res.responseBody.toString());
    }

    @IsTest
    static void accountAddendumCommunity() {
        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
        req.requestBody = Blob.valueOf('{ "CXTC043F_MSG_TYPE": "CXTC043F", "CXTC043F_TIMESTAMP": "2020-03-30-01.03.14.3151", "CXTC043F_AOPS_KEY1": "12345678", "CXTC043F_ACTION": "C" }');
        RestContext.request = req;
        RestContext.response = res;

        AOPS2SFDCDataSyncService.receiveSyncData();
        
        System.assertEquals(200, res.statusCode);
        System.assertEquals('The AOPS to SFDC sync data been received and stored in Salesforce successfully.', res.responseBody.toString());
    }

    @IsTest
    static void accountLegalAddendum() {
        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
        req.requestBody = Blob.valueOf('{ "CXTC044F_MSG_TYPE": "CXTC044F", "CXTC044F_TIMESTAMP": "2020-03-30-01.03.14.3151", "CXTC044F_AOPS_KEY1": "12345678", "CXTC044F_ACTION": "C" }');
        RestContext.request = req;
        RestContext.response = res;

        AOPS2SFDCDataSyncService.receiveSyncData();
        
        System.assertEquals(200, res.statusCode);
        System.assertEquals('The AOPS to SFDC sync data been received and stored in Salesforce successfully.', res.responseBody.toString());
    }

    @IsTest
    static void contactWebUser() {
        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
        req.requestBody = Blob.valueOf('{ "CXTCNTW_MSG_TYPE": "CXTCNTW", "CXTCNTW_TIMESTAMP": "2020-03-30-01.03.14.3151", "CXTCNTW_AOPS_KEY1": "12345678", "CXTCNTW_AOPS_KEY2": "90", "CCU330F_CONTACT_ID": "90", "CXTCNTW_AOPS_KEY3": "10", "CXTCNTW_ACTION": "C" }');
        RestContext.request = req;
        RestContext.response = res;

        AOPS2SFDCDataSyncService.receiveSyncData();
        
        System.assertEquals(200, res.statusCode);
        System.assertEquals('The AOPS to SFDC sync data been received and stored in Salesforce successfully.', res.responseBody.toString());
    }

    @IsTest
    static void contactShipAddress() {
        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
        req.requestBody = Blob.valueOf('{ "CXTCNTS_MSG_TYPE": "CXTCNTS", "CXTCNTS_TIMESTAMP": "2020-03-30-01.03.14.3151", "CXTCNTS_AOPS_KEY1": "12345678", "CXTCNTS_AOPS_KEY2": "90", "CCU310F_CONTACT_ID": "90", "CXTCNTS_AOPS_KEY3": "10", "CXTCNTS_ACTION": "C" }');
        RestContext.request = req;
        RestContext.response = res;

        AOPS2SFDCDataSyncService.receiveSyncData();
        
        System.assertEquals(200, res.statusCode);
        System.assertEquals('The AOPS to SFDC sync data been received and stored in Salesforce successfully.', res.responseBody.toString());
    }

    @IsTest
    static void contactEmail() {
        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
        req.requestBody = Blob.valueOf('{ "CXTCNTE_MSG_TYPE": "CXTCNTE", "CXTCNTE_TIMESTAMP": "2020-03-30-01.03.14.3151", "CXTCNTE_AOPS_KEY1": "12345678", "CXTCNTE_AOPS_KEY2": "90", "CCU340F_CONTACT_ID": "90", "CXTCNTE_AOPS_KEY3": "10", "CCU340F_ADDRESS_SEQ": "10", "CXTCNTE_ACTION": "C" }');
        RestContext.request = req;
        RestContext.response = res;

        AOPS2SFDCDataSyncService.receiveSyncData();
        
        System.assertEquals(200, res.statusCode);
        System.assertEquals('The AOPS to SFDC sync data been received and stored in Salesforce successfully.', res.responseBody.toString());
    }

    @IsTest
    static void contactMaster() {
        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
        req.requestBody = Blob.valueOf('{ "CXTCNTM_MSG_TYPE": "CXTCNTM", "CXTCNTM_TIMESTAMP": "2020-03-30-01.03.14.3151", "CXTCNTM_AOPS_KEY1": "12345678", "CXTCNTM_AOPS_KEY2": "90", "CCU300F_CONTACT_ID": "90", "CXTCNTM_ACTION": "C" }');
        RestContext.request = req;
        RestContext.response = res;

        AOPS2SFDCDataSyncService.receiveSyncData();
        
        System.assertEquals(200, res.statusCode);
        System.assertEquals('The AOPS to SFDC sync data been received and stored in Salesforce successfully.', res.responseBody.toString());
    }

    @IsTest
    static void contactOptIn() {
        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
        req.requestBody = Blob.valueOf('{ "CXTCNTO_MSG_TYPE": "CXTCNTO", "CXTCNTO_TIMESTAMP": "2020-03-30-01.03.14.3151", "CXTCNTO_AOPS_KEY1": "12345678", "CXTCNTO_AOPS_KEY2": "90", "CCU380F_CONTACT_ID": "90", "CXTCNTO_ACTION": "C" }');
        RestContext.request = req;
        RestContext.response = res;

        AOPS2SFDCDataSyncService.receiveSyncData();
        
        System.assertEquals(200, res.statusCode);
        System.assertEquals('The AOPS to SFDC sync data been received and stored in Salesforce successfully.', res.responseBody.toString());
    }

    @IsTest
    static void contactPhone() {
        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
        req.requestBody = Blob.valueOf('{ "CXTCNTP_MSG_TYPE": "CXTCNTP", "CXTCNTP_TIMESTAMP": "2020-03-30-01.03.14.3151", "CXTCNTP_AOPS_KEY1": "12345678", "CCU320F_CUSTOMER_ID": "12345678", "CXTCNTP_AOPS_KEY2": "90", "CCU320F_CONTACT_ID": "90", "CXTCNTP_AOPS_KEY3": "10", "CCU320F_PHONE_SEQ": "10", "CXTCNTP_ACTION": "C" }');
        RestContext.request = req;
        RestContext.response = res;

        AOPS2SFDCDataSyncService.receiveSyncData();
        
        System.assertEquals(200, res.statusCode);
        System.assertEquals('The AOPS to SFDC sync data been received and stored in Salesforce successfully.', res.responseBody.toString());
    }
}