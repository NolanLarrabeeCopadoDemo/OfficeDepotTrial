global without sharing class DNBIHelper
{
	@future(callout = true)
	WebService static void GetDUNSNumber(String ProspectID, String City, String Country, String State, String Street, String ZIP, String Business)
	{
		List<Account> accs;
		Account acc;

		try
		{
			accs = [SELECT Id, AccountSource, Address1__c, City__c, State__c, Zip__c, Country__c, EIN__c, Name, Phone, Org__c, Duns_Enrichment__c, DNBI_CREDIT_OUTCOME__c, DNBI_MatchScore__c, Payment_Term__c, DNBI_FSS_Score__c, DNB_Status__c, DNBI_Application_ID__c FROM Account WHERE Id =:ProspectID];

			if (!accs.isEmpty())
			{
				acc = accs.get(0);
				City = acc.City__c;
				State = acc.State__c;
				street = acc.Address1__c;
				zip = acc.Zip__c;
				Business = acc.Name;
				Country = acc.Country__c;
			}
			else
			{
				System.debug('DNBIHelper FATAL ERROR GetDUNSNumber: No account found.');
				return;
			}

			DNBI_dtoEaiDnbiCom.AddressDTO addto = new DNBI_dtoEaiDnbiCom.AddressDTO();
			addto.city = City;
			addto.country = Country;
			addto.state = State;
			addto.street = Street;
			addto.zipCode = ZIP;

			DNBI_dtoEaiDnbiCom.BusinessEntityDTO be = new DNBI_dtoEaiDnbiCom.BusinessEntityDTO();
			be.businessName = Business;
			be.address = addto;

			DNBI_dtoEaiDnbiCom.MatchCompanyRequestDTO Req = new DNBI_dtoEaiDnbiCom.MatchCompanyRequestDTO();
			Req.businessInformation = be;

			DNBI_dtoEaiDnbiCom.AuthenticationDTO_element authHead = new DNBI_dtoEaiDnbiCom.AuthenticationDTO_element();
			List<DNBI_Credentials__c> creds = DNBI_Credentials__c.getall().values();
			authHead.LOGIN_ID = creds[0].UserName__c;
			authHead.LOGIN_PASSWORD = creds[0].Password__c;

			DNBI_dtoEaiDnbiCom.CompanySearchResultDTO Response = new DNBI_dtoEaiDnbiCom.CompanySearchResultDTO();
			DNBI_comDnbiEaiServiceCreditapplication.CreditApplicationHttpPort ca = new DNBI_comDnbiEaiServiceCreditapplication.CreditApplicationHttpPort();
			ca.AuthenticationHeader = authHead;

			if (Test.isRunningTest())
			{
				DNBI_businessbureauDtoEaiDnbiCom.BureauCompanyDTO testBureauCompanyDTO = new DNBI_businessbureauDtoEaiDnbiCom.BureauCompanyDTO();
				testBureauCompanyDTO.address = addto;
				testBureauCompanyDTO.bureauIdentifierNumber = 'Test';
				testBureauCompanyDTO.bureauName = 'Test';
				testBureauCompanyDTO.businessName = 'Test';
				testBureauCompanyDTO.locationIndicator = 'Test';
				testBureauCompanyDTO.locationIndicatorExplanation = 'Test';
				testBureauCompanyDTO.matchScore = 8;
				testBureauCompanyDTO.telephone = 'Test';

				DNBI_businessbureauDtoEaiDnbiCom.ArrayOfBureauCompanyDTO testArrayOfBureauCompanyDTO = new DNBI_businessbureauDtoEaiDnbiCom.ArrayOfBureauCompanyDTO();
				testArrayOfBureauCompanyDTO.BureauCompanyDTO = new DNBI_businessbureauDtoEaiDnbiCom.BureauCompanyDTO[] { testBureauCompanyDTO };
				Response.bureauCompanyList = testArrayOfBureauCompanyDTO;

				acc.Duns_Enrichment__c = '012345678';
				acc.DNBI_MatchScore__c = 8;
			}
			else
			{
				Response = ca.matchCompany(Req);
				DNBI_businessbureauDtoEaiDnbiCom.ArrayOfBureauCompanyDTO arrayOfBureauCompanyDTO = response.BureauCompanyList;
				if (String.isBlank(acc.Duns_Enrichment__c))
				{
					acc.Duns_Enrichment__c = arrayOfBureauCompanyDTO.BureauCompanyDTO[0].bureauIdentifierNumber;
				}
				if (acc.DNBI_MatchScore__c == null)
				{
					acc.DNBI_MatchScore__c = Integer.valueOf(arrayOfBureauCompanyDTO.BureauCompanyDTO[0].matchScore);
				}

				if (String.isNotBlank(acc.Duns_Enrichment__c))
				{
					GetCreditApproval(acc, City, Country, State, Street, ZIP, Business);
				}
				else
				{
					acc.DNBI_CREDIT_OUTCOME__c = 'Manually Declined';
					acc.Payment_Term__c = 'Credit Card';
					acc.DNB_Status__c = 'No DUNS # available. Skipped Credit Approval.';
				}
			}
		}
		catch (Exception ex)
		{
			acc.DNBI_CREDIT_OUTCOME__c = 'Manually Declined';
			acc.Payment_Term__c = 'Credit Card';
			if (ex.getMessage().contains('CompanyNotFoundException'))
			{
				acc.DNB_Status__c = 'Company not found.';
			}
			else
			{
				acc.DNB_Status__c = 'Error: ' + ex.getMessage() + '. Line #: ' + ex.getLineNumber();
			}
		}
		finally
		{
			update acc;
		}
	}

	WebService static void GetCreditApproval(Account acc, String City, String Country, String State, String address1, String ZIP, String accname)
	{
		acc.DNBI_CREDIT_OUTCOME__c = 'Requested';
		acc.DNB_Status__c = 'Awaiting Response';

		try
		{
			DNBI_dtoEaiDnbiCom.FieldDTO fdto = new DNBI_dtoEaiDnbiCom.FieldDTO();
			fdto.fieldType = 'GENERAL';
			fdto.label = 'Duns Number';
			fdto.name = 'BizInfo-DUNSNumber';
			fdto.value = acc.Duns_Enrichment__c;

			DNBI_dtoEaiDnbiCom.FieldDTO fdto1 = new DNBI_dtoEaiDnbiCom.FieldDTO();
			fdto1.fieldType = 'GENERAL';
			fdto1.label = 'Business Name';
			fdto1.name = 'BizInfo-BusinessName';
			fdto1.value = accname;

			DNBI_dtoEaiDnbiCom.FieldDTO fdto2 = new DNBI_dtoEaiDnbiCom.FieldDTO();
			fdto2.fieldType = 'GENERAL';
			fdto2.label = 'Country';
			fdto2.name = 'BizInfo-Country';
			fdto2.value = country;

			DNBI_dtoEaiDnbiCom.FieldDTO fdto3 = new DNBI_dtoEaiDnbiCom.FieldDTO();
			fdto3.fieldType = 'GENERAL';
			fdto3.label = 'Street Address';
			fdto3.name = 'BizInfo-StreetAddress';
			fdto3.value = address1;

			DNBI_dtoEaiDnbiCom.FieldDTO fdto4 = new DNBI_dtoEaiDnbiCom.FieldDTO();
			fdto4.fieldType = 'GENERAL';
			fdto4.label = 'City';
			fdto4.name = 'BizInfo-City';
			fdto4.value = city;

			DNBI_dtoEaiDnbiCom.FieldDTO fdto5 = new DNBI_dtoEaiDnbiCom.FieldDTO();
			fdto5.fieldType = 'GENERAL';
			fdto5.label = 'State';
			fdto5.name = 'BizInfo-State';
			fdto5.value = state;

			DNBI_dtoEaiDnbiCom.FieldDTO fdto6 = new DNBI_dtoEaiDnbiCom.FieldDTO();
			fdto6.fieldType = 'GENERAL';
			fdto6.label = 'Zip';
			fdto6.name = 'BizInfo-ZIPCode';
			fdto6.value = zip;

			List<DNBI_dtoEaiDnbiCom.FieldDTO> lfdtto = new List<DNBI_dtoEaiDnbiCom.FieldDTO>();
			lfdtto.add(fdto);
			lfdtto.add(fdto1);
			lfdtto.add(fdto2);
			lfdtto.add(fdto3);
			lfdtto.add(fdto4);
			lfdtto.add(fdto5);
			lfdtto.add(fdto6);

			DNBI_dtoEaiDnbiCom.ArrayOfFieldDTO allFieldList = new DNBI_dtoEaiDnbiCom.ArrayOfFieldDTO();
			allFieldList.FieldDTO = lfdtto;

			DNBI_creditappMessageEaiDnbiCom.ApplyForCreditEnhancedRequest Req = new DNBI_creditappMessageEaiDnbiCom.ApplyForCreditEnhancedRequest();
			Req.allFieldList = allFieldList;

			DNBI_dtoEaiDnbiCom.AuthenticationDTO_element authHead = new DNBI_dtoEaiDnbiCom.AuthenticationDTO_element();
			List<DNBI_Credentials__c> creds = DNBI_Credentials__c.getall().values();
			authHead.LOGIN_ID = creds[0].UserName__c;
			authHead.LOGIN_PASSWORD = creds[0].Password__c;

			DNBI_comDnbiEaiServiceCreditapplication.CreditApplicationHttpPort ca = new DNBI_comDnbiEaiServiceCreditapplication.CreditApplicationHttpPort();
			ca.AuthenticationHeader = authHead;
			ca.timeout_x = 120000;
			DNBI_creditappMessageEaiDnbiCom.ApplyForCreditEnhancedResult Response = new DNBI_creditappMessageEaiDnbiCom.ApplyForCreditEnhancedResult();

			if (Test.isRunningTest())
			{
				acc.DNB_Status__c = '';
				acc.Duns_Enrichment__c = '012345678';
				acc.DNBI_MatchScore__c = 9;
				acc.DNBI_CREDIT_OUTCOME__c = 'Approved';
				acc.DNBI_Application_ID__c = 'FASDERTA';
			}
			else
			{
				Response = ca.applyForCreditEnhanced(Req);
				DNBI_creditappDtoEaiDnbiCom.CreditApplicationECFDTO applicationECF = Response.applicationECF;
				DNBI_dtoEaiDnbiCom.OutcomeDTO decisionOutcome = applicationECF.decisionOutcome;
				DNBI_dtoEaiDnbiCom.ArrayOfAutomatedDecisionReasonDTO x1 = decisionOutcome.andFields;
				DNBI_dtoEaiDnbiCom.AutomatedDecisionReasonDTO[] xx = x1.AutomatedDecisionReasonDTO;

				try
				{
					for (Integer i = 0; i < xx.size(); i++)
					{
						if (xx[i].fieldName == 'Financial Stress Score Class')
						{
							acc.DNBI_FSS_Score__c = Integer.valueOf(xx[i].applicationValue);
							break;
						}
					}
				}
				catch (Exception ex)
				{
					System.debug('DNBIHelper FATAL ERROR GetCreditApproval: No FSS found. Exception: ' + ex.getMessage() + '. Line #: ' + ex.getLineNumber());
					acc.DNB_Status__c = 'Could not retrieve Financial Stress Score.';
				}

				DNBI_creditappDtoEaiDnbiCom.CreditApplicationDTO oCreditApplicationDTO = applicationECF.application;
				acc.DNBI_CREDIT_OUTCOME__c = decisionOutcome.outcome;
				if (acc.DNBI_CREDIT_OUTCOME__c == 'Declined')
				{
					acc.Payment_Term__c = 'Credit Card';
				}
				acc.DNBI_Application_ID__c = oCreditApplicationDTO.applicationId;

				DNBI_creditappDtoEaiDnbiCom.BureauErrorDTO Error = new DNBI_creditappDtoEaiDnbiCom.BureauErrorDTO();
				acc.DNB_Status__c = Error.errorMessage;
			}
		}
		catch (Exception ex)
		{
			acc.DNBI_CREDIT_OUTCOME__c = 'Manually Declined';
			acc.Payment_Term__c = 'Credit Card';
			acc.DNB_Status__c = 'Error: ' + ex.getMessage() + '. Line #: ' + ex.getLineNumber();
		}
		finally
		{
			updatePrimarySite(acc);
		}
	}

	WebService static List<String> GetBSDAccountDUNSNumber(String ProspectID, String City, String Country, String State, String Street, String ZIP, String Business, String phone, String EINNum)
	{
		List<String> dunsResponseLst = new List<String>();
		String headerXML1, headerXML2, detailXML, footerXML, fullXML, endPoint, soapAction = '';
		endPoint = 'https://direct.dnb.com/Company/V4.0';
		headerXML1 = '<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:com="http://services.dnb.com/CompanyServiceV2.0">';
		//Modified By Sandesh Ganjare for Story #NAIT-120472 |  NAIT-122159
		//DNB_Direct_Credentials__c DNBDirectCred = DNB_Direct_Credentials__c.getValues('DNB Direct');

		headerXML2 = '<soapenv:Header>' +
					 '<wsse:Security soapenv:mustUnderstand="0" xmlns:wsse="http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-wssecurity-secext-1.0.xsd" xmlns:wsu="http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-wssecurity-utility-1.0.xsd">' +
					 '<wsse:UsernameToken wsu:Id="UsernameToken-11"><wsse:Username>' + '{!$Credential.UserName}' + '</wsse:Username>' +
					 '<wsse:Password Type="http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-username-token-profile-1.0#PasswordText">' + '{!$Credential.Password}' + '</wsse:Password>' +
					 '</wsse:UsernameToken></wsse:Security>' +
					 '</soapenv:Header>';

		footerXML = '</soapenv:Body></soapenv:Envelope>';

		detailXML = '<soapenv:Body>' +
					'<com:GetCleanseMatchRequest ServiceVersionNumber="4.0"><GetCleanseMatchRequestDetail>' +
					'<InquiryDetail>' +
					'<SubjectName>' + Business + '</SubjectName>' +
					'<Address>' +
					'<StreetAddressLine><LineText>' + Street + '</LineText></StreetAddressLine>' +
					'<PrimaryTownName>' + City + '</PrimaryTownName>' +
					'<CountryISOAlpha2Code>US</CountryISOAlpha2Code>' +
					'<TerritoryName>' + State + '</TerritoryName>' +
					'</Address>' +
					'<TelephoneNumber>' +
					'<TelecommunicationNumber>' + phone + '</TelecommunicationNumber>' +
					'<InternationalDialingCode>1</InternationalDialingCode>' +
					'</TelephoneNumber>' +
					'</InquiryDetail>' +
					'<MatchSpecification>' +
					'<CandidateMaximumQuantity>1</CandidateMaximumQuantity>' +
					'<ConfidenceLowerLevelThresholdValue>7</ConfidenceLowerLevelThresholdValue>' +
					'</MatchSpecification>' +
					'</GetCleanseMatchRequestDetail></com:GetCleanseMatchRequest>';

		soapAction = 'http://services.dnb.com/CompanyService/V4.0/GetCleanseMatch';

		fullXML = headerXML1 + headerXML2 + detailXML + footerXML;

		HttpRequest req = new HttpRequest();
		//req.setEndpoint(endPoint);
		req.setEndpoint('callout:DnBDirect_API/Company/V4.0'); //Modified By Sandesh Ganjare for Story #NAIT-120472 |  NAIT-122159
		req.setMethod('POST');
		req.setBody(fullXML);
		req.setHeader('Content-Type', 'text/xml');
		req.setHeader('SOAPAction', soapAction);
		req.setTimeout(120000);
		Http http = new Http();
		String response;
		HTTPResponse res;

		res = http.send(req);
		response = res.getBody();

		String dunsNumber = '';
		String matchScore = '';

		if (response != null)
		{
			dunsNumber = response.substringBetween('<DUNSNumber>', '</DUNSNumber>');
			matchScore = response.substringBetween('<ConfidenceCodeValue>', '</ConfidenceCodeValue>');

			if (String.isNotBlank(dunsNumber))
			{
				dunsResponseLst.add(dunsNumber);
				dunsResponseLst.add(matchScore);
			}
		}

		if (!String.isNotBlank(dunsNumber))
		{
			if (String.isNotBlank(EINNum))
			{
				dunsNumber = GetDUNSNumberFromFindCompany('US', EINNum);
				dunsResponseLst.add(dunsNumber);
				if (String.isNotBlank(dunsNumber))
				{
					matchScore = '10';
					dunsResponseLst.add(matchScore);
				}
			}
			else
			{
				dunsResponseLst.add('');
			}
			dunsResponseLst.add('0');
		}

		return dunsResponseLst;
	}

	WebService static String GetDUNSNumberFromFindCompany(String countryISOAlpha2Code, String EINNumber)
	{
		String headerXML1, headerXML2, detailXML, footerXML, fullXML, endPoint, soapAction, dunsNumber = '';
		endPoint = 'https://direct.dnb.com/EntityList/V6.1';
		headerXML1 = '<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:ent="http://services.dnb.com/EntityListServiceV2.0">';
		//Modified By Sandesh Ganjare for Story #NAIT-120472 |  NAIT-122159
		//DNB_Direct_Credentials__c DNBDirectCred = DNB_Direct_Credentials__c.getValues('DNB Direct');

		headerXML2 = '<soapenv:Header>' +
					 '<wsse:Security soapenv:mustUnderstand="0" xmlns:wsse="http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-wssecurity-secext-1.0.xsd" xmlns:wsu="http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-wssecurity-utility-1.0.xsd">' +
					 '<wsse:UsernameToken wsu:Id="UsernameToken-11"><wsse:Username>' + '{!$Credential.UserName}' + '</wsse:Username>' +
					 '<wsse:Password Type="http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-username-token-profile-1.0#PasswordText">' + '{!$Credential.Password}' + '</wsse:Password>' +
					 '</wsse:UsernameToken></wsse:Security>' +
					 '</soapenv:Header>';

		footerXML = '</soapenv:Body></soapenv:Envelope>';

		detailXML = '<soapenv:Body>' +
					'<ent:FindCompanyRequest ServiceVersionNumber="6.1">' +
					'<FindCompanyRequestDetail>' +
					'<InquiryDetail>' +
					'<Location>' +
					'<Address>' +
					'<CountryISOAlpha2Code>' + countryISOAlpha2Code + '</CountryISOAlpha2Code>' +
					'</Address>' +
					'</Location>' +
					'<OrganizationIdentificationNumberDetail DNBCodeValue="6863" TypeText="Federal Taxpayer Identification Number (US)">' +
					'<OrganizationIdentificationNumber>' + EINNumber + '</OrganizationIdentificationNumber>' +
					'</OrganizationIdentificationNumberDetail>' +
					'</InquiryDetail>' +
					'<FindSpecification>' +
					'<CandidateMaximumQuantity>' + '1' + '</CandidateMaximumQuantity>' +
					'<CandidatePerPageMaximumQuantity>65</CandidatePerPageMaximumQuantity>' +
					'<SearchModeDescription>Advanced</SearchModeDescription>' +
					'</FindSpecification>' +
					'</FindCompanyRequestDetail>' +
					'</ent:FindCompanyRequest>';

		soapAction = 'http://services.dnb.com/EntityListService/V6.1/FindCompany';

		fullXML = headerXML1 + headerXML2 + detailXML + footerXML;

		HttpRequest req = new HttpRequest();
		//req.setEndpoint(endPoint);
		req.setEndpoint('callout:DnBDirect_API/EntityList/V6.1'); //Modified By Sandesh Ganjare for Story #NAIT-120472 |  NAIT-122159
		req.setMethod('POST');
		req.setBody(fullXML);
		req.setHeader('Content-Type', 'text/xml');
		req.setHeader('SOAPAction', soapAction);
		req.setTimeout(120000);
		Http http = new Http();
		String response;
		HttpResponse res;

		res = http.send(req);
		response = res.getBody();

		if (response != null)
		{
			dunsNumber = response.substringBetween('<DUNSNumber>', '</DUNSNumber>');
		}

		return dunsNumber;
	}

	public static void updatePrimarySite(Account acc)
	{
		try
		{
			Account primarySite = [SELECT Id, Duns_Enrichment__c, DNBI_MatchScore__c, DNB_Status__c,
								   DNBI_CREDIT_OUTCOME__c, DNBI_Application_ID__c, Address1__c,
								   Address2__c, City__c, State__c, Zip__c, Country__c FROM Account WHERE(Related_Account__c =:acc.Id AND Primary_Site__c = true) OR Id =:acc.Id LIMIT 1];
			primarySite.Duns_Enrichment__c = acc.Duns_Enrichment__c;
			primarySite.DNBI_MatchScore__c = acc.DNBI_MatchScore__c;
			primarySite.DNB_Status__c = acc.DNB_Status__c;
			primarySite.DNBI_CREDIT_OUTCOME__c = acc.DNBI_CREDIT_OUTCOME__c;
			primarySite.DNBI_Application_ID__c = acc.DNBI_Application_ID__c;
			update primarySite;
		}
		catch (Exception ex)
		{
			System.debug('DNBIHelper FATAL ERROR updatePrimarySite.');
		}
	}
}