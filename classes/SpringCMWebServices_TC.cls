// 
// (c) 2015 Appirio, Inc.
//
//
// 23 September 2016     Connor Flynn S-440217 (OD 00816640)
@isTest
private class SpringCMWebServices_TC {


            static testMethod void SpringCMWebServices_TC()
            {
                    test.startTest();
                    Test.setMock(WebServiceMock.class, new SpringCMWebMockImpl()); // Comment Removed by Mohit for Story S-350563
                    SpringCMWebServices.SCMDocument doc = new SpringCMWebServices.SCMDocument();
                    SpringCMWebServices.DocumentCreateCommit_element ele = new SpringCMWebServices.DocumentCreateCommit_element();
                    SpringCMWebServices.Delete_element deleteElement = new SpringCMWebServices.Delete_element(); //Added By Mohit for Story S-350563
                    
                    //SpringCMWebServices.RemoveDelete_element rem = new SpringCMWebServices.RemoveDelete_element();
                    SpringCMWebServices.SetPermission_element seel = new SpringCMWebServices.SetPermission_element();
                    SpringCMWebServices.DocumentGetByIdResponse_element docel = new SpringCMWebServices.DocumentGetByIdResponse_element();
                    SpringCMWebServices.FolderSave_element folele = new SpringCMWebServices.FolderSave_element();
                    SpringCMWebServices.DocumentGetPathResponse_element docget  = new SpringCMWebServices.DocumentGetPathResponse_element();
                    
                    SpringCMWebServices.ParsePathResponse_element parse = new SpringCMWebServices.ParsePathResponse_element();
                    SpringCMWebServices.FolderCreate_element folcreate = new SpringCMWebServices.FolderCreate_element();
                    SpringCMWebServices.DocumentCreateCancelResponse_element docres = new SpringCMWebServices.DocumentCreateCancelResponse_element();
                    SpringCMWebServices.DocumentCreateBeginWithFolder_element docfol = new SpringCMWebServices.DocumentCreateBeginWithFolder_element();
                    SpringCMWebServices.FolderGetContents_element getfol = new SpringCMWebServices.FolderGetContents_element();
                    SpringCMWebServices.ArrayOfSCMMetadata arrMeta = new SpringCMWebServices.ArrayOfSCMMetadata();
                    SpringCMWebServices.SCMMetadata scmmeta = new SpringCMWebServices.SCMMetadata ();
                    SpringCMWebServices.FolderGetById_element folget = new SpringCMWebServices.FolderGetById_element();
                    SpringCMWebServices.FolderGetContentsResponse_element folcon = new SpringCMWebServices.FolderGetContentsResponse_element();
                    SpringCMWebServices.FolderSaveResponse_element folsave = new SpringCMWebServices.FolderSaveResponse_element();
                    SpringCMWebServices.SCMPath scmpth = new SpringCMWebServices.SCMPath();
                    SpringCMWebServices.DocumentDownloadResponse_element docmtnele = new SpringCMWebServices.DocumentDownloadResponse_element();
                    SpringCMWebServices.FolderCreateResponse_element foldrele = new SpringCMWebServices.FolderCreateResponse_element();
                    SpringCMWebServices.Move_element movele = new SpringCMWebServices.Move_element();
                    
                    
                    
                    /*SpringCMWebServices.SpringCMServiceSoap  soap1 = new SpringCMWebServices.SpringCMServiceSoap();
                    soap1.ParsePath('String','String','String',true);
                    soap1.DocumentCreateUploadChunk('String','String',5,6,'String','String');
                    soap1.DocumentDownload();
                    */
                    
                    SpringCMWebServices.DocumentCreateFilesCommit_element obj1=new SpringCMWebServices.DocumentCreateFilesCommit_element();
                    SpringCMWebServices.SCMFolder  obj2=new SpringCMWebServices.SCMFolder ();
                    SpringCMWebServices.ArrayOfString  obj3=new SpringCMWebServices.ArrayOfString ();
                    SpringCMWebServices.MoveResponse_element obj4=new SpringCMWebServices.MoveResponse_element();
                    SpringCMWebServices.DocumentCreateCheckin_element obj5=new SpringCMWebServices.DocumentCreateCheckin_element();
                    SpringCMWebServices.DocumentGetById_element obj6=new SpringCMWebServices.DocumentGetById_element();
                    SpringCMWebServices.FolderGetPathResponse_element obj7=new SpringCMWebServices.FolderGetPathResponse_element();
                    SpringCMWebServices.AuthenticateNonDefaultResponse_element obj8=new SpringCMWebServices.AuthenticateNonDefaultResponse_element();
                    SpringCMWebServices.ArrayOfPermission  obj9=new SpringCMWebServices.ArrayOfPermission ();
                    SpringCMWebServices.SetPermissionResponse_element obj10=new SpringCMWebServices.SetPermissionResponse_element();
                    SpringCMWebServices.ParsePath_element obj11=new SpringCMWebServices.ParsePath_element();
                    SpringCMWebServices.ArrayOfSCMDocument  obj12=new SpringCMWebServices.ArrayOfSCMDocument ();
                    SpringCMWebServices.BPMInitiateWorkflowResponse_element  obj13=new SpringCMWebServices.BPMInitiateWorkflowResponse_element ();
                    SpringCMWebServices.DocumentDownload_element obj14=new SpringCMWebServices.DocumentDownload_element();
                    SpringCMWebServices.SCMSearchDocument  obj15=new SpringCMWebServices.SCMSearchDocument ();
                    SpringCMWebServices.FolderGetPath_element obj16=new SpringCMWebServices.FolderGetPath_element();
                    SpringCMWebServices.AuthenticateSSOResponse_element  obj17=new SpringCMWebServices.AuthenticateSSOResponse_element ();
                    SpringCMWebServices.ArrayOfSCMDocumentCopyResult obj18=new SpringCMWebServices.ArrayOfSCMDocumentCopyResult();
                    SpringCMWebServices.BPMInitiateWorkflow_element  obj19=new SpringCMWebServices.BPMInitiateWorkflow_element ();
                    SpringCMWebServices.SCMDocumentPager  obj20=new SpringCMWebServices.SCMDocumentPager ();
                    SpringCMWebServices.FolderGetByIdResponse_element obj21=new SpringCMWebServices.FolderGetByIdResponse_element();
                    SpringCMWebServices.ArrayOfSetPermissionResult  obj22=new SpringCMWebServices.ArrayOfSetPermissionResult ();
                    SpringCMWebServices.SetPermissionResult  obj23=new SpringCMWebServices.SetPermissionResult ();
                    SpringCMWebServices.DeleteResponse_element obj24=new SpringCMWebServices.DeleteResponse_element();
                    SpringCMWebServices.SCMList  obj25=new SpringCMWebServices.SCMList ();
                    SpringCMWebServices.Copy_element obj26=new SpringCMWebServices.Copy_element();
                    SpringCMWebServices.DocumentSearchResponse_element obj27=new SpringCMWebServices.DocumentSearchResponse_element();
                    SpringCMWebServices.ArrayOfSCMFolderCopyResult  obj28=new SpringCMWebServices.ArrayOfSCMFolderCopyResult ();
                    SpringCMWebServices.BPMInitiateWorkflowWithDocuments_element obj29=new SpringCMWebServices.BPMInitiateWorkflowWithDocuments_element();
                    SpringCMWebServices.DocumentCreateCancel_element obj30=new SpringCMWebServices.DocumentCreateCancel_element();
                    SpringCMWebServices.DocumentCreateUploadChunkResponse_element obj31=new SpringCMWebServices.DocumentCreateUploadChunkResponse_element();
                    SpringCMWebServices.AuthenticateNonDefault_element obj32=new SpringCMWebServices.AuthenticateNonDefault_element();
                    SpringCMWebServices.DocumentCreateCommitResponse_element obj33=new SpringCMWebServices.DocumentCreateCommitResponse_element();
                    SpringCMWebServices.DocumentSaveResponse_element obj34=new SpringCMWebServices.DocumentSaveResponse_element();
                    SpringCMWebServices.DocumentCreateFilesBeginResponse_element  obj35=new SpringCMWebServices.DocumentCreateFilesBeginResponse_element ();
                    SpringCMWebServices.DocumentCreateBeginWithFolderResponse_element obj36=new SpringCMWebServices.DocumentCreateBeginWithFolderResponse_element();
                    SpringCMWebServices.DocumentCreateFilesBegin_element obj37=new SpringCMWebServices.DocumentCreateFilesBegin_element();
                    SpringCMWebServices.FindOrCreateEOSFolder_element obj38=new SpringCMWebServices.FindOrCreateEOSFolder_element();
                    SpringCMWebServices.AuthenticateSSO_element obj39=new SpringCMWebServices.AuthenticateSSO_element();
                    SpringCMWebServices.SCMFolderCopyResult  obj40=new SpringCMWebServices.SCMFolderCopyResult ();
                    SpringCMWebServices.DocumentCreateBeginResult  obj41=new SpringCMWebServices.DocumentCreateBeginResult ();
                    SpringCMWebServices.Permission  obj42=new SpringCMWebServices.Permission ();
                    SpringCMWebServices.FindOrCreateEOSFolderResponse_element obj43=new SpringCMWebServices.FindOrCreateEOSFolderResponse_element();
                    SpringCMWebServices.CopyResponse_element obj44=new SpringCMWebServices.CopyResponse_element();
                    SpringCMWebServices.DocumentSave_element obj45=new SpringCMWebServices.DocumentSave_element();
                    SpringCMWebServices.DocumentCreateCheckinResponse_element obj46=new SpringCMWebServices.DocumentCreateCheckinResponse_element();
                    SpringCMWebServices.BPMInitiateWorkflowWithDocumentsResponse_element obj47=new SpringCMWebServices.BPMInitiateWorkflowWithDocumentsResponse_element();
                    SpringCMWebServices.DocumentGetPath_element obj48=new SpringCMWebServices.DocumentGetPath_element();
                    SpringCMWebServices.DocumentCreateFilesCommitResponse_element obj49=new SpringCMWebServices.DocumentCreateFilesCommitResponse_element();
                    SpringCMWebServices.SCMDocumentCopyResult  obj50=new SpringCMWebServices.SCMDocumentCopyResult ();
                    SpringCMWebServices.DocumentSearch_element obj51=new SpringCMWebServices.DocumentSearch_element();
                    SpringCMWebServices.ArrayOfSCMFolder  obj52=new SpringCMWebServices.ArrayOfSCMFolder ();
                    SpringCMWebServices.SCMCopyResults  obj53=new SpringCMWebServices.SCMCopyResults ();
                    SpringCMWebServices.DocumentCreateUploadChunk_element obj54=new SpringCMWebServices.DocumentCreateUploadChunk_element();
                    SpringCMWebServices.DeleteResponse_element obj55=new SpringCMWebServices.DeleteResponse_element();
                    SpringCMWebServices.SetPermissionResult  obj56=new SpringCMWebServices.SetPermissionResult ();
                    SpringCMWebServices.ArrayOfSetPermissionResult  obj57=new SpringCMWebServices.ArrayOfSetPermissionResult ();
                    SpringCMWebServices.FolderGetByIdResponse_element obj58=new SpringCMWebServices.FolderGetByIdResponse_element();
                    
                    
                    SpringCMWebServices.SpringCMServiceSoap  soap = new SpringCMWebServices.SpringCMServiceSoap();
                    // START : Added by Mohit for Story S-350563 //
                    soap.AuthenticateSSO('String','String','String','String','String'); 
                    soap.ParsePath('testToken','testFolderId','testPath',true);
                    soap.SetPermission('testToken',obj9);
                    soap.FindOrCreateEOSFolder('testToken','testObj','testObjType','testFolder','testFolderPath',true);
                    soap.DocumentCreateCommit('testToken','testFileId',doc);
                    soap.FolderCreate('testToken',obj2);
                    soap.DocumentCreateUploadChunk('testToken','testFileId',0,2,'test','testCode');
                    soap.DocumentGetPath('testToken','testDoc');
                    soap.BPMInitiateWorkflow('testToken','testName','testData');
                    soap.FolderGetContents('testToken','testFolder',true,obj20);
                    soap.FolderGetPath('testToken','testFolderId');
                    soap.DocumentSearch('testToken',obj15,true);
                    soap.Copy('testToken','testType','testId','testDestId');
                    soap.FolderGetById('testToken','testFolderId',true);
                    soap.AuthenticateNonDefault('testUN','testPwd','testAcc','testKey');
                    soap.DocumentCreateCancel('testToken','testFileId');
                    soap.DocumentCreateFilesBegin('testToken',doc,'testCode',1234,'testpdf',4321,'testContent');
                    soap.SCMDelete('testToken','testType','testId');
                    soap.FolderSave('testToken',obj2);
                    soap.DocumentCreateBeginWithFolder('testToken',doc,'testCode');
                    soap.DocumentCreateFilesCommit('testToken',obj41,doc);
                    // End //

                    //Connor Flynn S-440217 (OD 00816640) Start
                    soap.DocumentGetById('Test', 'test2', false);
                    soap.Move('test', 'test', 'test', 'test');
                    SpringCMWebServices.ArrayOfString tmpArrayOfString = new SpringCMWebServices.ArrayOfString();
                    soap.BPMInitiateWorkflowWithDocuments('test', 'test', tmpArrayOfString);
                    soap.DocumentCreateCheckin('test', 'test', 'test', false);
                    SpringCMWebServices.SCMDocument tmpSCMDocument = new SpringCMWebServices.SCMDocument();
                    soap.DocumentSave('test', tmpSCMDocument);
                    Long i,j = 0;
                    soap.DocumentDownload('Test', 'test', i, j, 'test');
                    //Connor Flynn S-440217 (OD 00816640) End
                    test.stopTest();
            }

}