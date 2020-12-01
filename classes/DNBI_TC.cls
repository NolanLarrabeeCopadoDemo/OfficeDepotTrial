@IsTest
private with sharing class DNBI_TC
{
    private class DNBIWebServiceMockImpl1 implements WebServiceMock
    {
        public void doInvoke(
            Object stub, Object request, Map<String, Object> response,
            String endpoint, String soapAction, String requestName,
            String responseNS, String responseName, String responseType)
        {
            if(request instanceof DNBI_comDnbiEaiServiceCreditapplication.matchCompany_element)
                response.put('response_x', new DNBI_comDnbiEaiServiceCreditapplication.matchCompanyResponse_element());
             
            //START S-420975 (OD 00731428) [Hemant 7/1/2016] - Increase code coverage    
            if(request instanceof DNBI_comDnbiEaiServiceCreditapplication.getApplication_element)
                response.put('response_x', new DNBI_comDnbiEaiServiceCreditapplication.getApplicationResponse_element());
            if(request instanceof DNBI_comDnbiEaiServiceCreditapplication.updateCreditApplication_element)
                response.put('response_x', new DNBI_comDnbiEaiServiceCreditapplication.updateCreditApplicationResponse_element());
            if(request instanceof DNBI_comDnbiEaiServiceCreditapplication.getApplicationList_element)
                response.put('response_x', new DNBI_comDnbiEaiServiceCreditapplication.getApplicationListResponse_element());
            if(request instanceof DNBI_comDnbiEaiServiceCreditapplication.applyForCredit_element)
                response.put('response_x', new DNBI_comDnbiEaiServiceCreditapplication.applyForCreditResponse_element());
            if(request instanceof DNBI_comDnbiEaiServiceCreditapplication.applyForCreditEnhanced_element)
                response.put('response_x', new DNBI_comDnbiEaiServiceCreditapplication.applyForCreditEnhancedResponse_element());
            if(request instanceof DNBI_comDnbiEaiServiceCreditapplication.performECFAction_element)
                response.put('response_x', new DNBI_comDnbiEaiServiceCreditapplication.performECFActionResponse_element());        
            //END S-420975 (OD 00731428) [Hemant 7/1/2016] - Increase code coverage
            return;
        }
        
    }
    private static testMethod void coverTypes()
    {
        new DNBI_businessbureauDtoEaiDnbiCom.BureauCompanyDTO();
        new DNBI_businessbureauDtoEaiDnbiCom.ArrayOfBureauCompanyDTO();
        
        new DNBI_comDnbiEaiServiceCreditapplication.getApplication_element();
        new DNBI_comDnbiEaiServiceCreditapplication.getApplicationResponse_element();
        new DNBI_comDnbiEaiServiceCreditapplication.getApplicationListResponse_element();
        new DNBI_comDnbiEaiServiceCreditapplication.getApplicationList_element();
        new DNBI_comDnbiEaiServiceCreditapplication.applyForCreditEnhancedResponse_element();
        new DNBI_comDnbiEaiServiceCreditapplication.applyForCredit_element();
        new DNBI_comDnbiEaiServiceCreditapplication.ArrayOfString();
        new DNBI_comDnbiEaiServiceCreditapplication.updateCreditApplication_element();
        new DNBI_comDnbiEaiServiceCreditapplication.performECFAction_element();
        new DNBI_comDnbiEaiServiceCreditapplication.matchCompany_element();
        new DNBI_comDnbiEaiServiceCreditapplication.performECFActionResponse_element();
        new DNBI_comDnbiEaiServiceCreditapplication.updateCreditApplicationResponse_element();
        new DNBI_comDnbiEaiServiceCreditapplication.applyForCreditResponse_element();
        new DNBI_comDnbiEaiServiceCreditapplication.applyForCreditEnhanced_element();
        new DNBI_comDnbiEaiServiceCreditapplication.matchCompanyResponse_element();
        
        //START S-420975 (OD 00731428) [Hemant 7/1/2016] - Increase code coverage
        DNBI_Credentials__c dnb = new DNBI_Credentials__c(Name='test',UserName__c='sample@officedepot.com',Password__c='12345',DnB_Active__c=true);
        insert dnb;
        Test.startTest();
        
        Test.setMock(WebServiceMock.class, new DNBIWebServiceMockImpl1());
        
        DNBI_comDnbiEaiServiceCreditapplication.CreditApplicationHttpPort CAHP = new DNBI_comDnbiEaiServiceCreditapplication.CreditApplicationHttpPort();
        CAHP.matchCompany(new DNBI_dtoEaiDnbiCom.MatchCompanyRequestDTO());
        
        CAHP.getApplication('String in0');
        CAHP.updateCreditApplication(new DNBI_creditappDtoEaiDnbiCom.UpdateCreditApplicationRequestDTO());
        CAHP.getApplicationList(new DNBI_creditappDtoEaiDnbiCom.GetListOfApplicationsRequestDTO());
        CAHP.applyForCredit(new DNBI_dtoEaiDnbiCom.ArrayOfFieldDTO(), true);
        CAHP.applyForCreditEnhanced(new DNBI_creditappMessageEaiDnbiCom.ApplyForCreditEnhancedRequest());
        CAHP.performECFAction(new DNBI_creditappDtoEaiDnbiCom.PerformECFActionRequestDTO());
        Test.stopTest();
        //END S-420975 (OD 00731428) [Hemant 7/1/2016] - Increase code coverage
        
        new DNBI_dtoEaiDnbiCom.BureauIdDTO();
        new DNBI_dtoEaiDnbiCom.OutcomeDTO();
        new DNBI_dtoEaiDnbiCom.ArrayOfAutomatedDecisionReasonDTO();
        new DNBI_dtoEaiDnbiCom.ArrayOfBureauIdDTO();
        new DNBI_dtoEaiDnbiCom.AuthenticationDTO_element();
        new DNBI_dtoEaiDnbiCom.FieldDTO();
        new DNBI_dtoEaiDnbiCom.CompanySearchResultDTO();
        new DNBI_dtoEaiDnbiCom.ScoreDTO();
        new DNBI_dtoEaiDnbiCom.BusinessEntityDTO();
        new DNBI_dtoEaiDnbiCom.ArrayOfFieldErrorDTO();
        new DNBI_dtoEaiDnbiCom.ArrayOfFieldDTO();
        new DNBI_dtoEaiDnbiCom.CreditTermsDTO();
        new DNBI_dtoEaiDnbiCom.MatchCompanyRequestDTO();
        new DNBI_dtoEaiDnbiCom.AddressDTO();
        new DNBI_dtoEaiDnbiCom.AutomatedDecisionReasonDTO();
        new DNBI_dtoEaiDnbiCom.ArrayOfScoreDTO();
        new DNBI_dtoEaiDnbiCom.FieldErrorDTO();
        
        new DNBI_langJava.Throwable();

        new DNBI_serviceEaiDnbiCom.CreditApplicationNotFoundError();
        new DNBI_serviceEaiDnbiCom.MessageProcessingFailureError();

        new DNBI_faultEaiDnbiCom.ApplicationNumberNotFoundError();
        new DNBI_faultEaiDnbiCom.DUNSNumberNotFoundError();
        new DNBI_faultEaiDnbiCom.MatchNotFoundError();
        new DNBI_faultEaiDnbiCom.EmptyInputStringError();
        new DNBI_faultEaiDnbiCom.IncompleteMatchListReturnedError();
        new DNBI_faultEaiDnbiCom.InvalidWorkflowStatusError();
        new DNBI_faultEaiDnbiCom.ActionAlreadyTakenError();
        new DNBI_faultEaiDnbiCom.ApplicationIDNotProvidedError();
        new DNBI_faultEaiDnbiCom.MandatoryFieldsMissingError();
        new DNBI_faultEaiDnbiCom.CompanyNotFoundError();
        new DNBI_faultEaiDnbiCom.FieldErrorCode();
        new DNBI_faultEaiDnbiCom.ApplicationIDNotFoundError();
        new DNBI_faultEaiDnbiCom.ApplicationAlreadyExistsInspecifiedStateError();
        new DNBI_faultEaiDnbiCom.BureauNotConfiguredError();
        new DNBI_faultEaiDnbiCom.ActionNotExistsError();
        new DNBI_faultEaiDnbiCom.InvalidApplicationIDError();
        new DNBI_faultEaiDnbiCom.ExactMatchNotFoundError();
        new DNBI_faultEaiDnbiCom.BusinessNameNotProvidedError();
        new DNBI_faultEaiDnbiCom.BureauNotAvailableError();
        
        new DNBI_creditappDtoEaiDnbiCom.CompanyInfoDTO();
        new DNBI_creditappDtoEaiDnbiCom.GetListOfApplicationsRequestDTO();
        new DNBI_creditappDtoEaiDnbiCom.ArrayOfCreditApplicationDTO();
        new DNBI_creditappDtoEaiDnbiCom.GetCreditApplicationsResultDTO();
        new DNBI_creditappDtoEaiDnbiCom.CreditApplicationDTO();
        new DNBI_creditappDtoEaiDnbiCom.PerformECFActionRequestDTO();
        new DNBI_creditappDtoEaiDnbiCom.CreditApplicationECFDTO();
        new DNBI_creditappDtoEaiDnbiCom.BureauErrorDTO();
        new DNBI_creditappDtoEaiDnbiCom.UpdateCreditApplicationRequestDTO();
        new DNBI_creditappDtoEaiDnbiCom.CorporateLinkageDTO();


        new DNBI_creditappMessageEaiDnbiCom.ApplyForCreditEnhancedResult();
        new DNBI_creditappMessageEaiDnbiCom.ApplyForCreditResult();
        new DNBI_creditappMessageEaiDnbiCom.ApplyForCreditEnhancedRequest();
        new DNBI_creditappMessageEaiDnbiCom.UpdateCreditApplicationResult();
        

    }
}