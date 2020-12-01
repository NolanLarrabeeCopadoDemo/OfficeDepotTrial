@RestResource(urlMapping = '/WebUserMgr/*')
global without sharing class WebUserMgr {
    class ErrorResponse{
        String message;
        String statusCode;
        public ErrorResponse(String message, String statusCode){
            this.message = message;
            this.statusCode = statusCode;
        }
    }
    public class custException extends Exception {}
    @HttpPost
    global static void doPost(
        String FirstName, 
        String LastName, 
        String Email, 
        String Phone, 
        String LoginName, 
        String Address1, 
        String Address2, 
        String City, 
        String State, 
        String Zip, 
        String AopsCustId, 
        String pwd, 
        String PONumber, 
        String ccenter, 
        String Release, 
        String Desktop, 
        String SSO_Id, 
        String CustomCatalogCode
    ) {
        GPOUserReg gU = new GPOUserReg();
        gpoUserReg.GPOUserRefRequest gReq = new gpoUserReg.GPOUserRefRequest();
        gReq.FirstName = FirstName;
        gReq.LastName = LastName;
        gReq.Email = Email;
        gReq.Phone = Phone;
        gReq.LoginName = LoginName;
        greq.Address1 = Address1;
        greq.Address2 = Address2;
        greq.City = City;
        greq.state = state;
        greq.zip = zip;
        greq.AopsCustId = AopsCustId;
        greq.Password = pwd;

        //--NAIT-21026-------------------sTART--------->

        if (PONumber != null && PONumber != '')
            greq.PONumber = PONumber;

        if (ccenter != null && ccenter != '')
            greq.CCenter = ccenter;

        greq.Release = Release;
        greq.Desktop = Desktop;
        //--NAIT-21026-------------------End----------->

        greq.SSO_Id = SSO_Id;
        greq.CustomCatalogCode = CustomCatalogCode;

        if (greq.CustomCatalogCode.length() < 5)
            greq.CustomCatalogCode = greq.CustomCatalogCode.leftPad(5, '0');


        greq.RegisterSPC = 'N';

        greq.ReqPrintedSPC = 'N';

        gpoUserReg.GPOUserRegResponse gRes;
        
        
        RestRequest req = RestContext.request;
        RestResponse res = Restcontext.response;
        res.headers.put('Content-Type', 'application/json');
        if (Test.isRunningTest()) {
            Test.setMock(HttpCalloutMock.class, new SingleRequestMock());
        }
        gRes = gU.executeUserReg(greq);
        if (gRes.StatusCode != '00'){
            System.debug(JSON.serialize(gRes));
            System.debug(gRes.StatusCode);
            res.responseBody = Blob.valueOf(JSON.serialize(new ErrorResponse(gRes.statusDescription, gRes.StatusCode)));
            res.statusCode = 500;
            return;
        } 
        res.responseBody = Blob.valueOf(JSON.serialize(gRes));
        res.statusCode = 200;
    }
}