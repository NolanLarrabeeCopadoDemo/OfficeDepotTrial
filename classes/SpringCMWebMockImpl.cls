/*************************************
Name : SpringCMWebMockImpl
Description : This is the Mock class which is use in SpringCMWebService class.
Created By : Mohit Batwada
Created Date : Sept 14,2015

Modified 23 September 2016     Connor Flynn S-440217 (OD 00816640)
*************************************/
@isTest
global class SpringCMWebMockImpl implements WebServiceMock {
    
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
           
           if (typeOfResp == 0) {
            SpringCMWebServices.AuthenticateSSOResponse_element respElement = new SpringCMWebServices.AuthenticateSSOResponse_element();
            response.put('response_x', respElement);
            typeOfResp = 1;
        } else if (typeOfResp == 1) {
            SpringCMWebServices.ParsePathResponse_element respElement = new SpringCMWebServices.ParsePathResponse_element();
            response.put('response_x', respElement);
            typeOfResp = 2;
        }else if (typeOfResp == 2) {
            SpringCMWebServices.SetPermissionResponse_element respElement = new SpringCMWebServices.SetPermissionResponse_element();
            response.put('response_x', respElement);
            typeOfResp = 3;
        }else if (typeOfResp == 3) {
            SpringCMWebServices.FindOrCreateEOSFolderResponse_element respElement = new SpringCMWebServices.FindOrCreateEOSFolderResponse_element();
            response.put('response_x', respElement);
            typeOfResp = 4;
        }else if (typeOfResp == 4) {
            SpringCMWebServices.DocumentCreateCommitResponse_element respElement = new SpringCMWebServices.DocumentCreateCommitResponse_element();
            response.put('response_x', respElement);
            typeOfResp = 5;
        }else if (typeOfResp == 5) {
            SpringCMWebServices.FolderCreateResponse_element respElement = new SpringCMWebServices.FolderCreateResponse_element();
            response.put('response_x', respElement);
            typeOfResp = 6;
        }else if (typeOfResp == 6) {
            SpringCMWebServices.DocumentCreateUploadChunkResponse_element respElement = new SpringCMWebServices.DocumentCreateUploadChunkResponse_element();
            response.put('response_x', respElement);
            typeOfResp = 7;
        }else if (typeOfResp == 7) {
            SpringCMWebServices.DocumentGetPathResponse_element respElement = new SpringCMWebServices.DocumentGetPathResponse_element();
            response.put('response_x', respElement);
            typeOfResp = 8;
        }else if (typeOfResp == 8) {
            SpringCMWebServices.BPMInitiateWorkflowResponse_element respElement = new SpringCMWebServices.BPMInitiateWorkflowResponse_element();
            response.put('response_x', respElement);
            typeOfResp = 9;
        }else if (typeOfResp == 9) {
            SpringCMWebServices.FolderGetContentsResponse_element respElement = new SpringCMWebServices.FolderGetContentsResponse_element();
            response.put('response_x', respElement);
            typeOfResp = 10;
        }else if (typeOfResp == 10) {
            SpringCMWebServices.FolderGetPathResponse_element respElement = new SpringCMWebServices.FolderGetPathResponse_element();
            response.put('response_x', respElement);
            typeOfResp = 11;
        }else if (typeOfResp == 11) {
            SpringCMWebServices.DocumentSearchResponse_element respElement = new SpringCMWebServices.DocumentSearchResponse_element();
            response.put('response_x', respElement);
            typeOfResp = 12;
        }else if (typeOfResp == 12) {
            SpringCMWebServices.CopyResponse_element respElement = new SpringCMWebServices.CopyResponse_element();
            response.put('response_x', respElement);
            typeOfResp = 13;
        }else if (typeOfResp == 13) {
            SpringCMWebServices.FolderGetByIdResponse_element respElement = new SpringCMWebServices.FolderGetByIdResponse_element();
            response.put('response_x', respElement);
            typeOfResp = 14;
        }else if (typeOfResp == 14) {
            SpringCMWebServices.AuthenticateNonDefaultResponse_element respElement = new SpringCMWebServices.AuthenticateNonDefaultResponse_element();
            response.put('response_x', respElement);
            typeOfResp = 15;
        }else if (typeOfResp == 15) {
            SpringCMWebServices.DocumentCreateCancelResponse_element respElement = new SpringCMWebServices.DocumentCreateCancelResponse_element();
            response.put('response_x', respElement);
            typeOfResp = 16;
        }else if (typeOfResp == 16) {
            SpringCMWebServices.DocumentCreateFilesBeginResponse_element respElement = new SpringCMWebServices.DocumentCreateFilesBeginResponse_element();
            response.put('response_x', respElement);
            typeOfResp = 17;
        }else if (typeOfResp == 17) {
            SpringCMWebServices.DeleteResponse_element respElement = new SpringCMWebServices.DeleteResponse_element();
            response.put('response_x', respElement);
            typeOfResp = 18;
        }else if (typeOfResp == 18) {
            SpringCMWebServices.FolderSaveResponse_element respElement = new SpringCMWebServices.FolderSaveResponse_element();
            response.put('response_x', respElement);
            typeOfResp = 19;
        }else if (typeOfResp == 19) {
            SpringCMWebServices.DocumentCreateBeginWithFolderResponse_element respElement = new SpringCMWebServices.DocumentCreateBeginWithFolderResponse_element();
            response.put('response_x', respElement);
            typeOfResp = 20;
        }else if (typeOfResp == 20) {
            SpringCMWebServices.DocumentCreateFilesCommitResponse_element respElement = new SpringCMWebServices.DocumentCreateFilesCommitResponse_element();
            response.put('response_x', respElement);
            typeOfResp = 21;
        } 
        //Connor Flynn S-440217 (OD 00816640) Start
        else if(typeOfResp == 21){
            typeOfResp = 22;
            SpringCMWebServices.DocumentGetByIdResponse_element respElement = new SpringCMWebServices.DocumentGetByIdResponse_element();
            response.put('response_x', respElement);
        } else if(typeOfResp == 22){
            typeOfResp = 23;
            SpringCMWebServices.MoveResponse_element respElement = new SpringCMWebServices.MoveResponse_element();
            response.put('response_x', respElement);
        } else if(typeOfResp == 23){
            typeOfResp = 24;
            SpringCMWebServices.BPMInitiateWorkflowWithDocumentsResponse_element respElement = new SpringCMWebServices.BPMInitiateWorkflowWithDocumentsResponse_element();
            response.put('response_x', respElement);
        } else if(typeOfResp == 24){
            typeOfResp = 25;
            SpringCMWebServices.DocumentCreateCheckinResponse_element respElement = new SpringCMWebServices.DocumentCreateCheckinResponse_element();
            response.put('response_x', respElement);
        } else if(typeofResp == 25){
            typeOfResp = 26;
            SpringCMWebServices.DocumentSaveResponse_element respElement = new SpringCMWebServices.DocumentSaveResponse_element();
            response.put('response_x', respElement);
        } else if(typeOfResp ==26){
            typeOfResp = 27;
            SpringCMWebServices.DocumentDownloadResponse_element respElement = new SpringCMWebServices.DocumentDownloadResponse_element();
            response.put('response_x', respElement);
        }
        //Connor Flynn S-440217 (OD 00816640) End
        else {
            system.debug('.............typeOfResp = ' + String.valueOf(typeOfResp) + '.  Invalid typeOfResp value.');

        }
   }
}