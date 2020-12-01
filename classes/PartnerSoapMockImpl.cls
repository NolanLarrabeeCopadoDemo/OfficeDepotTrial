/*************************************
Name : PartnerSoapMockImpl
Description : This is the Mock class which is use in PartnerSoapSforceCom class.
Created By : Mohit Batwada
Created Date : Sept 14,2015
*************************************/
@isTest
global class PartnerSoapMockImpl implements WebServiceMock {
    
    public static Integer typeOfResp = 0;

   global void doInvoke(
           Object stub,
           Object request,
           Map<String, Object> response,
           String endpoint,
           String soapAction,
           String requestName,
           String responseNS,
           String responseName,
           String responseType) {
           
           
       if(typeOfResp == 0) {
            partnerSoapSforceCom.describeAvailableQuickActionsResponse_element respElement = new partnerSoapSforceCom.describeAvailableQuickActionsResponse_element();
            response.put('response_x', respElement);
            typeOfResp = 1;
        }else if(typeOfResp == 1) {
            partnerSoapSforceCom.describeGlobalResponse_element respElement = new partnerSoapSforceCom.describeGlobalResponse_element();
            response.put('response_x', respElement);
            typeOfResp = 2;
        }else if(typeOfResp == 2) {
            partnerSoapSforceCom.retrieveResponse_element respElement = new partnerSoapSforceCom.retrieveResponse_element();
            response.put('response_x', respElement);
            typeOfResp = 3;
        }else if(typeOfResp == 3) {
            partnerSoapSforceCom.describeLayoutResponse_element respElement = new partnerSoapSforceCom.describeLayoutResponse_element();
            response.put('response_x', respElement);
            typeOfResp = 4;
        }else if(typeOfResp == 4) {
            partnerSoapSforceCom.emptyRecycleBinResponse_element respElement = new partnerSoapSforceCom.emptyRecycleBinResponse_element();
            response.put('response_x', respElement);
            typeOfResp = 5;
        }else if(typeOfResp == 5) {
            partnerSoapSforceCom.logoutResponse_element respElement = new partnerSoapSforceCom.logoutResponse_element();
            response.put('response_x', respElement);
            typeOfResp = 6;
        }else if(typeOfResp == 6) {
            partnerSoapSforceCom.invalidateSessionsResponse_element respElement = new partnerSoapSforceCom.invalidateSessionsResponse_element();
            response.put('response_x', respElement);
            typeOfResp = 7;
        }else if(typeOfResp == 7) {
            partnerSoapSforceCom.getUserInfoResponse_element respElement = new partnerSoapSforceCom.getUserInfoResponse_element();
            response.put('response_x', respElement);
            typeOfResp = 8;
        }else if(typeOfResp == 8) {
            partnerSoapSforceCom.getServerTimestampResponse_element respElement = new partnerSoapSforceCom.getServerTimestampResponse_element();
            response.put('response_x', respElement);
            typeOfResp = 9;
        }else if(typeOfResp == 9) {
            partnerSoapSforceCom.describeSearchLayoutsResponse_element respElement = new partnerSoapSforceCom.describeSearchLayoutsResponse_element();
            response.put('response_x', respElement);
            typeOfResp = 10;
        }else if(typeOfResp == 10) {
            partnerSoapSforceCom.describeQuickActionsResponse_element respElement = new partnerSoapSforceCom.describeQuickActionsResponse_element();
            response.put('response_x', respElement);
            typeOfResp = 11;
        }else if(typeOfResp == 11) {
            partnerSoapSforceCom.setPasswordResponse_element respElement = new partnerSoapSforceCom.setPasswordResponse_element();
            response.put('response_x', respElement);
            typeOfResp = 12;
        }else if(typeOfResp == 12) {
            partnerSoapSforceCom.sendEmailMessageResponse_element respElement = new partnerSoapSforceCom.sendEmailMessageResponse_element();
            response.put('response_x', respElement);
            typeOfResp = 13;
        }else if(typeOfResp == 13) {
            partnerSoapSforceCom.deleteResponse_element respElement = new partnerSoapSforceCom.deleteResponse_element();
            response.put('response_x', respElement);
            typeOfResp = 14;
        }else if(typeOfResp == 14) {
            partnerSoapSforceCom.describeTabsResponse_element respElement = new partnerSoapSforceCom.describeTabsResponse_element();
            response.put('response_x', respElement);
            typeOfResp = 15;
        }else if(typeOfResp == 15) {
            partnerSoapSforceCom.loginResponse_element respElement = new partnerSoapSforceCom.loginResponse_element();
            response.put('response_x', respElement);
            typeOfResp = 16;
        }else if(typeOfResp == 16) {
            partnerSoapSforceCom.searchResponse_element respElement = new partnerSoapSforceCom.searchResponse_element();
            response.put('response_x', respElement);
            typeOfResp = 17;
        }else if(typeOfResp == 17) {
            partnerSoapSforceCom.queryMoreResponse_element respElement = new partnerSoapSforceCom.queryMoreResponse_element();
            response.put('response_x', respElement);
            typeOfResp = 18;
        }else if(typeOfResp == 18) {
            partnerSoapSforceCom.describeSearchScopeOrderResponse_element respElement = new partnerSoapSforceCom.describeSearchScopeOrderResponse_element();
            response.put('response_x', respElement);
            typeOfResp = 19;
        }else if(typeOfResp == 19) {
            partnerSoapSforceCom.describeSoftphoneLayoutResponse_element respElement = new partnerSoapSforceCom.describeSoftphoneLayoutResponse_element();
            response.put('response_x', respElement);
            typeOfResp = 20;
        }else if(typeOfResp == 20) {
            partnerSoapSforceCom.queryAllResponse_element respElement = new partnerSoapSforceCom.queryAllResponse_element();
            response.put('response_x', respElement);
            typeOfResp = 21;
        }else if(typeOfResp == 21) {
            partnerSoapSforceCom.resetPasswordResponse_element respElement = new partnerSoapSforceCom.resetPasswordResponse_element();
            response.put('response_x', respElement);
            typeOfResp = 22;
        }else if(typeOfResp == 22) {
            partnerSoapSforceCom.queryResponse_element respElement = new partnerSoapSforceCom.queryResponse_element();
            response.put('response_x', respElement);
            typeOfResp = 23;
        }else if(typeOfResp == 23) {
            partnerSoapSforceCom.undeleteResponse_element respElement = new partnerSoapSforceCom.undeleteResponse_element();
            response.put('response_x', respElement);
            typeOfResp = 24;
        }else if(typeOfResp == 24) {
            partnerSoapSforceCom.getUpdatedResponse_element respElement = new partnerSoapSforceCom.getUpdatedResponse_element();
            response.put('response_x', respElement);
            typeOfResp = 25;
        }else if(typeOfResp == 25) {
            partnerSoapSforceCom.getDeletedResponse_element respElement = new partnerSoapSforceCom.getDeletedResponse_element();
            response.put('response_x', respElement);
            typeOfResp = 26;
        }else {
            system.debug('.............typeOfResp = ' + String.valueOf(typeOfResp) + '.  Invalid typeOfResp value.');
        }
   }
}