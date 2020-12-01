/**********************************************************

Class Name : soapUserFederationIds_TC
Created Date : May 25th, 2015
Created By : Mohit Batwada
Purpoae : Test Class for soapUserFederationIds 

***********************************************************/

@isTest
public class soapUserFederationIds_TC {
    static testMethod void testSoapUserFederationId(){
        soapUserFederationIds sfI = new soapUserFederationIds();
        soapUserFederationIds.LogInfo lI = new soapUserFederationIds.LogInfo();
        soapUserFederationIds.AllowFieldTruncationHeader_element allow= new soapUserFederationIds.AllowFieldTruncationHeader_element();
        soapUserFederationIds.DebuggingHeader_element de = new soapUserFederationIds.DebuggingHeader_element();
        soapUserFederationIds.CallOptions_element call = new soapUserFederationIds.CallOptions_element();
        soapUserFederationIds.ReturnIdsResponse_element rir = new soapUserFederationIds.ReturnIdsResponse_element();
        soapUserFederationIds.SessionHeader_element  sess = new soapUserFederationIds.SessionHeader_element();
        soapUserFederationIds.DebuggingInfo_element die = new soapUserFederationIds.DebuggingInfo_element();
        soapUserFederationIds.ReturnIds_element rie =new  soapUserFederationIds.ReturnIds_element();
        soapUserFederationIds.UserFederationIds ufi = new soapUserFederationIds.UserFederationIds();
    }


}