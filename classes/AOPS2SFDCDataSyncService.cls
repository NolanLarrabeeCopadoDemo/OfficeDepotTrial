@RestResource(urlMapping='/AOPS2SFDCDataSyncService/*')
global with sharing class AOPS2SFDCDataSyncService {

    /**
     * Receive a REST request with data for updating a single staging record.
     * Determines what type of staging record is intended and upserts that record.
     */
	@HttpPost  
    global static void receiveSyncData() {
        RestRequest req = RestContext.request;
        RestResponse res = RestContext.response;

        try {
            Boolean success = processRequest(req);
            if(success == true) {
                res.statusCode = 200;
                res.responseBody= Blob.valueOf('The AOPS to SFDC sync data been received and stored in Salesforce successfully.');
            } else {
                res.statusCode = 400;
                res.responseBody = Blob.valueOf('The AOPS to SFDC sync failed.');
            }
        } catch(Exception e) {
            res.statusCode = 400;
            res.responseBody = Blob.valueOf('The AOPS to SFDC sync failed with error: ' + e.getMessage() + ' ' + e.getStackTraceString());
        }
    }

    /**
     * Determines and calls the proper processor method for the given request.
     */
    private static boolean processRequest(RestRequest req) {
        String jsonString = req.requestBody.toString();
        Map<String,Object> resultMap = (Map<String,Object>)JSON.deserializeUntyped(jsonString);

        String messageType = getMessageType(resultMap);
        
        switch on messageType {
            when 'CXTF000P' { // Account Master
                return AOPSAccountMasterProcessor.process(resultMap);
            }  
            when 'CXTCNTM' { // Contact Master
                return AOPSContactMasterProcessor.process(resultMap);
            }
            when 'CXTCNTO' { // Contact Opt-in
                return AOPSContactOptInProcessor.process(resultMap);
            }
            when 'CXTCNTP' { // Contact Phone
                return AOPSContactPhoneProcessor.process(resultMap);
            }
            when 'CXTC007F' { // Account BSD Addendum
                return AOPSAccountBSDAddendumProcessor.process(resultMap);
            }
            when 'CXTC043F' { // Account Addendum (Community flag)
                return AOPSAccountAddendumCommunityProcessor.process(resultMap);
            }
            when 'CXTC044F' { // Account Addendum (Legal flag)
                return AOPSAccountLegalAddendumProcessor.process(resultMap);
            }
            when 'CXTF370P' { // Account Preferences
                return AOPSAccountPreferencesProcessor.process(resultMap);
            }
            when 'CXTF001P' { // Address Master
                return AOPSAddressMasterProcessor.process(resultMap);
            }
            when 'CXTC009F' { // Address BSD Addendum
                return AOPSAddressBSDAddendumProcessor.process(resultMap);
            }
            when 'CXTF005P' { // Account Child Parent Relationship
                return AOPSAccountChildParentRelProcessor.process(resultMap);
            }
            when 'CXTCNTW' { // Contact Web User
                return AOPSContactWebUserProcessor.process(resultMap);
            }
            when 'CXTCNTS' { // Contact Ship Address
                return AOPSContactShipAddressProcessor.process(resultMap);
            }
            when 'CXTCNTE' { //Contact E-mail
                return AOPSContactEmailProcessor.process(resultMap);
            }
            when 'CXTCNTBND' {
                // Not currently used, just return true to indicate success.
                return true;
            }
            when else {
            }
        }

        return false;
    }

    private static String getMessageType(Map<String, Object> resultMap) {
        String messageType = (String) resultMap.get('CXTF000P_MSG_TYPE'); // Account Master
        if (String.isEmpty(messageType)) {
            messageType = (String) resultMap.get('CXTCNTM_MSG_TYPE'); // Contact Master
        }
        if (String.isEmpty(messageType)) {
            messageType = (String) resultMap.get('CXTCNTO_MSG_TYPE'); // Contact Opt-in
        }
        if (String.isEmpty(messageType)) {
            messageType = (String) resultMap.get('CXTCNTP_MSG_TYPE'); // Contact Phone
        }
        if (String.isEmpty(messageType)) {
            messageType = (String) resultMap.get('CXTC007F_MSG_TYPE'); // Account BSD Addendum
        }
        if (String.isEmpty(messageType)) { // Account Addendum (has Community flag)
            messageType = (String) resultMap.get('CXTC043F_MSG_TYPE'); // Account BSD Addendum
        }
        if (String.isEmpty(messageType)) { // Account Addendum (has Community flag)
            messageType = (String) resultMap.get('CXTC044F_MSG_TYPE'); // Account Addendum Legal
        }
        if (String.isEmpty(messageType)) {
            messageType = (String) resultMap.get('CXTF370P_MSG_TYPE'); // Account Preferences
        }
        if (String.isEmpty(messageType)) {
            messageType = (String) resultMap.get('CXTF001P_MSG_TYPE'); // Address Master
        }
        if (String.isEmpty(messageType)) {
            messageType = (String) resultMap.get('CXTC009F_MSG_TYPE'); // Address BSD Addendum
        }
        if (String.isEmpty(messageType)) {
            messageType = (String) resultMap.get('CXTF005P_MSG_TYPE'); // Account Child Parent Relationship
        }
        if (String.isEmpty(messageType)) {
            messageType = (String) resultMap.get('CXTCNTW_MSG_TYPE'); // Contact Web User
        }
        if (String.isEmpty(messageType)) {
            messageType = (String) resultMap.get('CXTCNTS_MSG_TYPE'); // Contact Ship Address
        }
        if(String.isEmpty(messageType)) {
            messageType = (String) resultMap.get('CXTCNTE_MSG_TYPE'); // Contact Email
        }
        if(String.isEmpty(messageType)) {
            messageType = (String) resultMap.get('CXTCNTB_MSG_TYPE'); // Contact Bundle
        }
        return messageType;
    }
}