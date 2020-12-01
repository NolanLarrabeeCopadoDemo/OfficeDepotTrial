@IsTest
private class DNBIHelper_TC
{
    @TestSetup
	static void makeData()
	{
        List<DNBI_Credentials__c> dnb_credentials = new List<DNBI_Credentials__c>{
            new DNBI_Credentials__c(Name='test', UserName__c='sample@officedepot.com', Password__c='12345', DnB_Active__c=true)
        };
		insert dnb_credentials;
		
        List<DNB_Direct_Credentials__c> dnb_direct_credentials = new List<DNB_Direct_Credentials__c>{ 
			new DNB_Direct_Credentials__c( Name='DNB Direct', UserName__c='sample@officedepot.com', Password__c='12345')
        };
		insert dnb_direct_credentials;
		
		Org__c o = new Org__c(
			Business_Name__c = 'GORMAN MANUFACTURING COMPANY, INC.',
			Address_1__c = '492 KOLLER STREET',
			City__c = 'SAN FRANCISCO',
			State__c = 'CA',
			Zip__c = '94110'
		);
		insert o;

        Account prospect =  new Account(
            Name = o.Business_Name__c,
            BillingStreet = o.Address_1__c,
            BillingCity = o.City__c,
            BillingState = o.State__c,
            BillingCountry = 'USA',
            BillingPostalCode = o.Zip__c,
            Zip__c = o.Zip__c,
            Address1__c = o.Address_1__c,
            Address2__c = '12345',
            City__c = o.City__c,
            State__c = o.State__c,
            Country__c = 'USA',
            Phone = '1234321234',
            Oracle_Party_Id__c = '94110',
			Industry='Government',
			Org__c = o.Id
        );
        insert prospect;

        Account site = new Account(
            Name = 'GORMAN MANUFACTURING COMPANY, INC.',
            BillingStreet = '492 KOLLER STREET',
            BillingCity = 'SAN FRANCISCO',
            BillingPostalCode = '94110',
            Zip__c = '94110',
            Address1__c = '492 KOLLER STREET',
            Address2__c = '12345',
            City__c = 'SAN FRANCISCO',
            State__c = 'CA',
            Country__c = 'USA',
            BillingState = 'CA',
            Billingcountry = 'USA',
            Oracle_Party_Id__c = '122357',
            Industry='Government',
            Phone = '1234321234',
            Related_Account__c=prospect.Id,
            Primary_Site__c=true
        );
        insert site;
    }

	public class DNBI_Service_Mock implements HttpCalloutMock
	{
        String xml_response = '<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/">'
            +'<soap-env:Body xmlns:soap-env="http://schemas.xmlsoap.org/soap/envelope/">'
            +'<com:GetCleanseMatchResponse ServiceVersionNumber="4.0" xmlns:com="http://services.dnb.com/CompanyServiceV2.0">'
            +'<TransactionDetail>'
            +'<ServiceTransactionID>Id-19443abe51de84f012fb3a53-1</ServiceTransactionID>'
            +'<TransactionTimestamp>2013-07-11T06:12:01</TransactionTimestamp>'
            +'</TransactionDetail>'
            +'<TransactionResult>'
            +'<SeverityText>Information</SeverityText>'
            +'<ResultID>CM000</ResultID>'
            +'<ResultText>Success</ResultText>'
            +'</TransactionResult>'
            +'<GetCleanseMatchResponseDetail>'
            +'<InquiryDetail>'
            +'<SubjectName>Gorman Manufacturing</SubjectName>'
            +'<Address>'
            +'<CountryISOAlpha2Code>US</CountryISOAlpha2Code>'
            +'<TerritoryName>CA</TerritoryName>'
            +'</Address>'
            +'</InquiryDetail>'
            +'<MatchResponseDetail>'
            +'<MatchDataCriteriaText>Name and Address Lookup</MatchDataCriteriaText>'
            +'<CandidateMatchedQuantity>24</CandidateMatchedQuantity>'
            +'<MatchCandidate>'
            +'<DUNSNumber>804735132</DUNSNumber>'
            +'<OrganizationPrimaryName>'
            +'<OrganizationName>GORMAN MANUFACTURING COMPANY, INC.</OrganizationName>'
            +'</OrganizationPrimaryName>'
            +'<PrimaryAddress>'
            +'<StreetAddressLine>'
            +'<LineText>492 KOLLER STREET</LineText>'
            +'</StreetAddressLine>'
            +'<PrimaryTownName>SAN FRANCISCO</PrimaryTownName>'
            +'<CountryISOAlpha2Code>US</CountryISOAlpha2Code>'
            +'<PostalCode>94110</PostalCode>'
            +'<TerritoryAbbreviatedName>CA</TerritoryAbbreviatedName>'
            +'<UndeliverableIndicator>false</UndeliverableIndicator>'
            +'</PrimaryAddress>'
            +'<MailingAddress>'
            +'<CountryISOAlpha2Code>US</CountryISOAlpha2Code>'
            +'<UndeliverableIndicator>false</UndeliverableIndicator>'
            +'</MailingAddress>'
            +'<TelephoneNumber>'
            +'<TelecommunicationNumber>6505550000</TelecommunicationNumber>'
            +'<UnreachableIndicator>false</UnreachableIndicator>'
            +'</TelephoneNumber>'
            +'<OperatingStatusText>Active</OperatingStatusText>'
            +'<FamilyTreeMemberRole>'
            +'<FamilyTreeMemberRoleText>Headquarters</FamilyTreeMemberRoleText>'
            +'</FamilyTreeMemberRole>'
            +'<StandaloneOrganizationIndicator>false</StandaloneOrganizationIndicator>'
            +'<MatchQualityInformation>'
            +'<ConfidenceCodeValue>6</ConfidenceCodeValue>'
            +'<MatchBasis>'
            +'<EndIndicator>false</EndIndicator>'
            +'<SubjectTypeText>Business</SubjectTypeText>'
            +'<SeniorPrincipalIndicator>false</SeniorPrincipalIndicator>'
            +'<MatchBasisText>Primary Name</MatchBasisText>'
            +'</MatchBasis>'
            +'<MatchBasis>'
            +'<EndIndicator>false</EndIndicator>'
            +'<SubjectTypeText>Business</SubjectTypeText>'
            +'<SeniorPrincipalIndicator>false</SeniorPrincipalIndicator>'
            +'<MatchBasisText>Primary Address</MatchBasisText>'
            +'</MatchBasis>'
            +'<MatchGradeText>AZZZAZZZFFZ</MatchGradeText>'
            +'<MatchGradeComponentCount>11</MatchGradeComponentCount>'
            +'<MatchGradeComponent>'
            +'<MatchGradeComponentTypeText>Name</MatchGradeComponentTypeText>'
            +'<MatchGradeComponentRating>A</MatchGradeComponentRating>'
            +'<MatchGradeComponentScore>100.0</MatchGradeComponentScore>'
            +'</MatchGradeComponent>'
            +'<MatchGradeComponent>'
            +'<MatchGradeComponentTypeText>Street Number</MatchGradeComponentTypeText>'
            +'<MatchGradeComponentRating>Z</MatchGradeComponentRating>'
            +'<MatchGradeComponentScore>0</MatchGradeComponentScore>'
            +'</MatchGradeComponent>'
            +'<MatchGradeComponent>'
            +'<MatchGradeComponentTypeText>Street Name</MatchGradeComponentTypeText>'
            +'<MatchGradeComponentRating>Z</MatchGradeComponentRating>'
            +'<MatchGradeComponentScore>0</MatchGradeComponentScore>'
            +'</MatchGradeComponent>'
            +'<MatchGradeComponent>'
            +'<MatchGradeComponentTypeText>City</MatchGradeComponentTypeText>'
            +'<MatchGradeComponentRating>Z</MatchGradeComponentRating>'
            +'<MatchGradeComponentScore>0</MatchGradeComponentScore>'
            +'</MatchGradeComponent>'
            +'<MatchGradeComponent>'
            +'<MatchGradeComponentTypeText>State</MatchGradeComponentTypeText>'
            +'<MatchGradeComponentRating>A</MatchGradeComponentRating>'
            +'<MatchGradeComponentScore>100.0</MatchGradeComponentScore>'
            +'</MatchGradeComponent>'
            +'<MatchGradeComponent>'
            +'<MatchGradeComponentTypeText>PO Box</MatchGradeComponentTypeText>'
            +'<MatchGradeComponentRating>Z</MatchGradeComponentRating>'
            +'<MatchGradeComponentScore>0</MatchGradeComponentScore>'
            +'</MatchGradeComponent>'
            +'<MatchGradeComponent>'
            +'<MatchGradeComponentTypeText>Phone</MatchGradeComponentTypeText>'
            +'<MatchGradeComponentRating>Z</MatchGradeComponentRating>'
            +'<MatchGradeComponentScore>0</MatchGradeComponentScore>'
            +'</MatchGradeComponent>'
            +'<MatchGradeComponent>'
            +'<MatchGradeComponentTypeText>Postal Code</MatchGradeComponentTypeText>'
            +'<MatchGradeComponentRating>Z</MatchGradeComponentRating>'
            +'<MatchGradeComponentScore>0</MatchGradeComponentScore>'
            +'</MatchGradeComponent>'
            +'<MatchGradeComponent>'
            +'<MatchGradeComponentTypeText>Density</MatchGradeComponentTypeText>'
            +'<MatchGradeComponentRating>F</MatchGradeComponentRating>'
            +'<MatchGradeComponentScore>0.0</MatchGradeComponentScore>'
            +'</MatchGradeComponent>'
            +'<MatchGradeComponent>'
            +'<MatchGradeComponentTypeText>Uniqueness</MatchGradeComponentTypeText>'
            +'<MatchGradeComponentRating>F</MatchGradeComponentRating>'
            +'<MatchGradeComponentScore>12.5</MatchGradeComponentScore>'
            +'</MatchGradeComponent>'
            +'<MatchGradeComponent>'
            +'<MatchGradeComponentTypeText>Sic</MatchGradeComponentTypeText>'
            +'<MatchGradeComponentRating>Z</MatchGradeComponentRating>'
            +'<MatchGradeComponentScore>0</MatchGradeComponentScore>'
            +'</MatchGradeComponent>'
            +'<MatchDataProfileText>0099999900999899000000009898</MatchDataProfileText>'
            +'<MatchDataProfileComponentCount>14</MatchDataProfileComponentCount>'
            +'<MatchDataProfileComponent>'
            +'<MatchDataProfileComponentTypeText>Name</MatchDataProfileComponentTypeText>'
            +'<MatchDataProfileComponentValue>00</MatchDataProfileComponentValue>'
            +'</MatchDataProfileComponent>'
            +'<MatchDataProfileComponent>'
            +'<MatchDataProfileComponentTypeText>Street Number</MatchDataProfileComponentTypeText>'
            +'<MatchDataProfileComponentValue>99</MatchDataProfileComponentValue>'
            +'</MatchDataProfileComponent>'
            +'<MatchDataProfileComponent>'
            +'<MatchDataProfileComponentTypeText>Street Name</MatchDataProfileComponentTypeText>'
            +'<MatchDataProfileComponentValue>99</MatchDataProfileComponentValue>'
            +'</MatchDataProfileComponent>'
            +'<MatchDataProfileComponent>'
            +'<MatchDataProfileComponentTypeText>City</MatchDataProfileComponentTypeText>'
            +'<MatchDataProfileComponentValue>99</MatchDataProfileComponentValue>'
            +'</MatchDataProfileComponent>'
            +'<MatchDataProfileComponent>'
            +'<MatchDataProfileComponentTypeText>State</MatchDataProfileComponentTypeText>'
            +'<MatchDataProfileComponentValue>00</MatchDataProfileComponentValue>'
            +'</MatchDataProfileComponent>'
            +'<MatchDataProfileComponent>'
            +'<MatchDataProfileComponentTypeText>PO Box</MatchDataProfileComponentTypeText>'
            +'<MatchDataProfileComponentValue>99</MatchDataProfileComponentValue>'
            +'</MatchDataProfileComponent>'
            +'<MatchDataProfileComponent>'
            +'<MatchDataProfileComponentTypeText>Phone</MatchDataProfileComponentTypeText>'
            +'<MatchDataProfileComponentValue>98</MatchDataProfileComponentValue>'
            +'</MatchDataProfileComponent>'
            +'<MatchDataProfileComponent>'
            +'<MatchDataProfileComponentTypeText>Postal Code</MatchDataProfileComponentTypeText>'
            +'<MatchDataProfileComponentValue>99</MatchDataProfileComponentValue>'
            +'</MatchDataProfileComponent>'
            +'<MatchDataProfileComponent>'
            +'<MatchDataProfileComponentTypeText>DUNS</MatchDataProfileComponentTypeText>'
            +'<MatchDataProfileComponentValue>00</MatchDataProfileComponentValue>'
            +'</MatchDataProfileComponent>'
            +'<MatchDataProfileComponent>'
            +'<MatchDataProfileComponentTypeText>SIC</MatchDataProfileComponentTypeText>'
            +'<MatchDataProfileComponentValue>00</MatchDataProfileComponentValue>'
            +'</MatchDataProfileComponent>'
            +'<MatchDataProfileComponent>'
            +'<MatchDataProfileComponentTypeText>Density</MatchDataProfileComponentTypeText>'
            +'<MatchDataProfileComponentValue>00</MatchDataProfileComponentValue>'
            +'</MatchDataProfileComponent>'
            +'<MatchDataProfileComponent>'
            +'<MatchDataProfileComponentTypeText>Uniqueness</MatchDataProfileComponentTypeText>'
            +'<MatchDataProfileComponentValue>00</MatchDataProfileComponentValue>'
            +'</MatchDataProfileComponent>'
            +'<MatchDataProfileComponent>'
            +'<MatchDataProfileComponentTypeText>National ID</MatchDataProfileComponentTypeText>'
            +'<MatchDataProfileComponentValue>98</MatchDataProfileComponentValue>'
            +'</MatchDataProfileComponent>'
            +'<MatchDataProfileComponent>'
            +'<MatchDataProfileComponentTypeText>URL</MatchDataProfileComponentTypeText>'
            +'<MatchDataProfileComponentValue>98</MatchDataProfileComponentValue>'
            +'</MatchDataProfileComponent>'
            +'</MatchQualityInformation>'
            +'<DisplaySequence>1</DisplaySequence>'
            +'</MatchCandidate>'
            +'<MatchCandidate>'
            +'<DUNSNumber>009175688</DUNSNumber>'
            +'<OrganizationPrimaryName>'
            +'<OrganizationName>GORMAN MFG CO INC</OrganizationName>'
            +'</OrganizationPrimaryName>'
            +'<PrimaryAddress>'
            +'<StreetAddressLine>'
            +'<LineText>8129 JUNIPERO ST STE A</LineText>'
            +'</StreetAddressLine>'
            +'<PrimaryTownName>SACRAMENTO</PrimaryTownName>'
            +'<CountryISOAlpha2Code>US</CountryISOAlpha2Code>'
            +'<PostalCode>95828</PostalCode>'
            +'<PostalCodeExtensionCode>1603</PostalCodeExtensionCode>'
            +'<TerritoryAbbreviatedName>CA</TerritoryAbbreviatedName>'
            +'<UndeliverableIndicator>false</UndeliverableIndicator>'
            +'</PrimaryAddress>'
            +'<MailingAddress>'
            +'<StreetAddressLine>'
            +'<LineText>PO BOX 756</LineText>'
            +'</StreetAddressLine>'
            +'<PrimaryTownName>WOODLAND</PrimaryTownName>'
            +'<CountryISOAlpha2Code>US</CountryISOAlpha2Code>'
            +'<PostalCode>95776</PostalCode>'
            +'<TerritoryAbbreviatedName>CA</TerritoryAbbreviatedName>'
            +'<UndeliverableIndicator>false</UndeliverableIndicator>'
            +'</MailingAddress>'
            +'<TelephoneNumber>'
            +'<TelecommunicationNumber>5306620211</TelecommunicationNumber>'
            +'<UnreachableIndicator>false</UnreachableIndicator>'
            +'</TelephoneNumber>'
            +'<OperatingStatusText>Out of Business</OperatingStatusText>'
            +'<StandaloneOrganizationIndicator>true</StandaloneOrganizationIndicator>'
            +'<MatchQualityInformation>'
            +'<ConfidenceCodeValue>6</ConfidenceCodeValue>'
            +'<MatchBasis>'
            +'<EndIndicator>false</EndIndicator>'
            +'<SubjectTypeText>Business</SubjectTypeText>'
            +'<SeniorPrincipalIndicator>false</SeniorPrincipalIndicator>'
            +'<MatchBasisText>Primary Name</MatchBasisText>'
            +'</MatchBasis>'
            +'<MatchBasis>'
            +'<EndIndicator>false</EndIndicator>'
            +'<SubjectTypeText>Business</SubjectTypeText>'
            +'<SeniorPrincipalIndicator>false</SeniorPrincipalIndicator>'
            +'<MatchBasisText>Primary Address</MatchBasisText>'
            +'</MatchBasis>'
            +'<MatchGradeText>AZZZAZZZFFZ</MatchGradeText>'
            +'<MatchGradeComponentCount>11</MatchGradeComponentCount>'
            +'<MatchGradeComponent>'
            +'<MatchGradeComponentTypeText>Name</MatchGradeComponentTypeText>'
            +'<MatchGradeComponentRating>A</MatchGradeComponentRating>'
            +'<MatchGradeComponentScore>100.0</MatchGradeComponentScore>'
            +'</MatchGradeComponent>'
            +'<MatchGradeComponent>'
            +'<MatchGradeComponentTypeText>Street Number</MatchGradeComponentTypeText>'
            +'<MatchGradeComponentRating>Z</MatchGradeComponentRating>'
            +'<MatchGradeComponentScore>0</MatchGradeComponentScore>'
            +'</MatchGradeComponent>'
            +'<MatchGradeComponent>'
            +'<MatchGradeComponentTypeText>Street Name</MatchGradeComponentTypeText>'
            +'<MatchGradeComponentRating>Z</MatchGradeComponentRating>'
            +'<MatchGradeComponentScore>0</MatchGradeComponentScore>'
            +'</MatchGradeComponent>'
            +'<MatchGradeComponent>'
            +'<MatchGradeComponentTypeText>City</MatchGradeComponentTypeText>'
            +'<MatchGradeComponentRating>Z</MatchGradeComponentRating>'
            +'<MatchGradeComponentScore>0</MatchGradeComponentScore>'
            +'</MatchGradeComponent>'
            +'<MatchGradeComponent>'
            +'<MatchGradeComponentTypeText>State</MatchGradeComponentTypeText>'
            +'<MatchGradeComponentRating>A</MatchGradeComponentRating>'
            +'<MatchGradeComponentScore>100.0</MatchGradeComponentScore>'
            +'</MatchGradeComponent>'
            +'<MatchGradeComponent>'
            +'<MatchGradeComponentTypeText>PO Box</MatchGradeComponentTypeText>'
            +'<MatchGradeComponentRating>Z</MatchGradeComponentRating>'
            +'<MatchGradeComponentScore>0</MatchGradeComponentScore>'
            +'</MatchGradeComponent>'
            +'<MatchGradeComponent>'
            +'<MatchGradeComponentTypeText>Phone</MatchGradeComponentTypeText>'
            +'<MatchGradeComponentRating>Z</MatchGradeComponentRating>'
            +'<MatchGradeComponentScore>0</MatchGradeComponentScore>'
            +'</MatchGradeComponent>'
            +'<MatchGradeComponent>'
            +'<MatchGradeComponentTypeText>Postal Code</MatchGradeComponentTypeText>'
            +'<MatchGradeComponentRating>Z</MatchGradeComponentRating>'
            +'<MatchGradeComponentScore>0</MatchGradeComponentScore>'
            +'</MatchGradeComponent>'
            +'<MatchGradeComponent>'
            +'<MatchGradeComponentTypeText>Density</MatchGradeComponentTypeText>'
            +'<MatchGradeComponentRating>F</MatchGradeComponentRating>'
            +'<MatchGradeComponentScore>0.0</MatchGradeComponentScore>'
            +'</MatchGradeComponent>'
            +'<MatchGradeComponent>'
            +'<MatchGradeComponentTypeText>Uniqueness</MatchGradeComponentTypeText>'
            +'<MatchGradeComponentRating>F</MatchGradeComponentRating>'
            +'<MatchGradeComponentScore>12.5</MatchGradeComponentScore>'
            +'</MatchGradeComponent>'
            +'<MatchGradeComponent>'
            +'<MatchGradeComponentTypeText>Sic</MatchGradeComponentTypeText>'
            +'<MatchGradeComponentRating>Z</MatchGradeComponentRating>'
            +'<MatchGradeComponentScore>0</MatchGradeComponentScore>'
            +'</MatchGradeComponent>'
            +'<MatchDataProfileText>0099999900999899000000009898</MatchDataProfileText>'
            +'<MatchDataProfileComponentCount>14</MatchDataProfileComponentCount>'
            +'<MatchDataProfileComponent>'
            +'<MatchDataProfileComponentTypeText>Name</MatchDataProfileComponentTypeText>'
            +'<MatchDataProfileComponentValue>00</MatchDataProfileComponentValue>'
            +'</MatchDataProfileComponent>'
            +'<MatchDataProfileComponent>'
            +'<MatchDataProfileComponentTypeText>Street Number</MatchDataProfileComponentTypeText>'
            +'<MatchDataProfileComponentValue>99</MatchDataProfileComponentValue>'
            +'</MatchDataProfileComponent>'
            +'<MatchDataProfileComponent>'
            +'<MatchDataProfileComponentTypeText>Street Name</MatchDataProfileComponentTypeText>'
            +'<MatchDataProfileComponentValue>99</MatchDataProfileComponentValue>'
            +'</MatchDataProfileComponent>'
            +'<MatchDataProfileComponent>'
            +'<MatchDataProfileComponentTypeText>City</MatchDataProfileComponentTypeText>'
            +'<MatchDataProfileComponentValue>99</MatchDataProfileComponentValue>'
            +'</MatchDataProfileComponent>'
            +'<MatchDataProfileComponent>'
            +'<MatchDataProfileComponentTypeText>State</MatchDataProfileComponentTypeText>'
            +'<MatchDataProfileComponentValue>00</MatchDataProfileComponentValue>'
            +'</MatchDataProfileComponent>'
            +'<MatchDataProfileComponent>'
            +'<MatchDataProfileComponentTypeText>PO Box</MatchDataProfileComponentTypeText>'
            +'<MatchDataProfileComponentValue>99</MatchDataProfileComponentValue>'
            +'</MatchDataProfileComponent>'
            +'<MatchDataProfileComponent>'
            +'<MatchDataProfileComponentTypeText>Phone</MatchDataProfileComponentTypeText>'
            +'<MatchDataProfileComponentValue>98</MatchDataProfileComponentValue>'
            +'</MatchDataProfileComponent>'
            +'<MatchDataProfileComponent>'
            +'<MatchDataProfileComponentTypeText>Postal Code</MatchDataProfileComponentTypeText>'
            +'<MatchDataProfileComponentValue>99</MatchDataProfileComponentValue>'
            +'</MatchDataProfileComponent>'
            +'<MatchDataProfileComponent>'
            +'<MatchDataProfileComponentTypeText>DUNS</MatchDataProfileComponentTypeText>'
            +'<MatchDataProfileComponentValue>00</MatchDataProfileComponentValue>'
            +'</MatchDataProfileComponent>'
            +'<MatchDataProfileComponent>'
            +'<MatchDataProfileComponentTypeText>SIC</MatchDataProfileComponentTypeText>'
            +'<MatchDataProfileComponentValue>00</MatchDataProfileComponentValue>'
            +'</MatchDataProfileComponent>'
            +'<MatchDataProfileComponent>'
            +'<MatchDataProfileComponentTypeText>Density</MatchDataProfileComponentTypeText>'
            +'<MatchDataProfileComponentValue>00</MatchDataProfileComponentValue>'
            +'</MatchDataProfileComponent>'
            +'<MatchDataProfileComponent>'
            +'<MatchDataProfileComponentTypeText>Uniqueness</MatchDataProfileComponentTypeText>'
            +'<MatchDataProfileComponentValue>00</MatchDataProfileComponentValue>'
            +'</MatchDataProfileComponent>'
            +'<MatchDataProfileComponent>'
            +'<MatchDataProfileComponentTypeText>National ID</MatchDataProfileComponentTypeText>'
            +'<MatchDataProfileComponentValue>98</MatchDataProfileComponentValue>'
            +'</MatchDataProfileComponent>'
            +'<MatchDataProfileComponent>'
            +'<MatchDataProfileComponentTypeText>URL</MatchDataProfileComponentTypeText>'
            +'<MatchDataProfileComponentValue>98</MatchDataProfileComponentValue>'
            +'</MatchDataProfileComponent>'
            +'</MatchQualityInformation>'
            +'<DisplaySequence>2</DisplaySequence>'
            +'</MatchCandidate>'
            +'<MatchCandidate>'
            +'<DUNSNumber>199650169</DUNSNumber>'
            +'<OrganizationPrimaryName>'
            +'<OrganizationName>GORMAN, DENNIS</OrganizationName>'
            +'</OrganizationPrimaryName>'
            +'<TradeStyleName>'
            +'<OrganizationName>GORMAN MANUFACTURING</OrganizationName>'
            +'</TradeStyleName>'
            +'<PrimaryAddress>'
            +'<StreetAddressLine>'
            +'<LineText>12 W KENTUCKY AVE</LineText>'
            +'</StreetAddressLine>'
            +'<PrimaryTownName>WOODLAND</PrimaryTownName>'
            +'<CountryISOAlpha2Code>US</CountryISOAlpha2Code>'
            +'<PostalCode>95695</PostalCode>'
            +'<PostalCodeExtensionCode>5837</PostalCodeExtensionCode>'
            +'<TerritoryAbbreviatedName>CA</TerritoryAbbreviatedName>'
            +'<UndeliverableIndicator>false</UndeliverableIndicator>'
            +'</PrimaryAddress>'
            +'<MailingAddress>'
            +'<CountryISOAlpha2Code>US</CountryISOAlpha2Code>'
            +'<UndeliverableIndicator>false</UndeliverableIndicator>'
            +'</MailingAddress>'
            +'<TelephoneNumber>'
            +'<TelecommunicationNumber>5306627750</TelecommunicationNumber>'
            +'<UnreachableIndicator>false</UnreachableIndicator>'
            +'</TelephoneNumber>'
            +'<OperatingStatusText>Out of Business</OperatingStatusText>'
            +'<StandaloneOrganizationIndicator>true</StandaloneOrganizationIndicator>'
            +'<MatchQualityInformation>'
            +'<ConfidenceCodeValue>6</ConfidenceCodeValue>'
            +'<MatchBasis>'
            +'<EndIndicator>false</EndIndicator>'
            +'<SubjectTypeText>Business</SubjectTypeText>'
            +'<SeniorPrincipalIndicator>false</SeniorPrincipalIndicator>'
            +'<MatchBasisText>Trade style</MatchBasisText>'
            +'</MatchBasis>'
            +'<MatchBasis>'
            +'<EndIndicator>false</EndIndicator>'
            +'<SubjectTypeText>Business</SubjectTypeText>'
            +'<SeniorPrincipalIndicator>false</SeniorPrincipalIndicator>'
            +'<MatchBasisText>Primary Address</MatchBasisText>'
            +'</MatchBasis>'
            +'<MatchGradeText>AZZZAZZZBFZ</MatchGradeText>'
            +'<MatchGradeComponentCount>11</MatchGradeComponentCount>'
            +'<MatchGradeComponent>'
            +'<MatchGradeComponentTypeText>Name</MatchGradeComponentTypeText>'
            +'<MatchGradeComponentRating>A</MatchGradeComponentRating>'
            +'<MatchGradeComponentScore>100.0</MatchGradeComponentScore>'
            +'</MatchGradeComponent>'
            +'<MatchGradeComponent>'
            +'<MatchGradeComponentTypeText>Street Number</MatchGradeComponentTypeText>'
            +'<MatchGradeComponentRating>Z</MatchGradeComponentRating>'
            +'<MatchGradeComponentScore>0</MatchGradeComponentScore>'
            +'</MatchGradeComponent>'
            +'<MatchGradeComponent>'
            +'<MatchGradeComponentTypeText>Street Name</MatchGradeComponentTypeText>'
            +'<MatchGradeComponentRating>Z</MatchGradeComponentRating>'
            +'<MatchGradeComponentScore>0</MatchGradeComponentScore>'
            +'</MatchGradeComponent>'
            +'<MatchGradeComponent>'
            +'<MatchGradeComponentTypeText>City</MatchGradeComponentTypeText>'
            +'<MatchGradeComponentRating>Z</MatchGradeComponentRating>'
            +'<MatchGradeComponentScore>0</MatchGradeComponentScore>'
            +'</MatchGradeComponent>'
            +'<MatchGradeComponent>'
            +'<MatchGradeComponentTypeText>State</MatchGradeComponentTypeText>'
            +'<MatchGradeComponentRating>A</MatchGradeComponentRating>'
            +'<MatchGradeComponentScore>100.0</MatchGradeComponentScore>'
            +'</MatchGradeComponent>'
            +'<MatchGradeComponent>'
            +'<MatchGradeComponentTypeText>PO Box</MatchGradeComponentTypeText>'
            +'<MatchGradeComponentRating>Z</MatchGradeComponentRating>'
            +'<MatchGradeComponentScore>0</MatchGradeComponentScore>'
            +'</MatchGradeComponent>'
            +'<MatchGradeComponent>'
            +'<MatchGradeComponentTypeText>Phone</MatchGradeComponentTypeText>'
            +'<MatchGradeComponentRating>Z</MatchGradeComponentRating>'
            +'<MatchGradeComponentScore>0</MatchGradeComponentScore>'
            +'</MatchGradeComponent>'
            +'<MatchGradeComponent>'
            +'<MatchGradeComponentTypeText>Postal Code</MatchGradeComponentTypeText>'
            +'<MatchGradeComponentRating>Z</MatchGradeComponentRating>'
            +'<MatchGradeComponentScore>0</MatchGradeComponentScore>'
            +'</MatchGradeComponent>'
            +'<MatchGradeComponent>'
            +'<MatchGradeComponentTypeText>Density</MatchGradeComponentTypeText>'
            +'<MatchGradeComponentRating>B</MatchGradeComponentRating>'
            +'<MatchGradeComponentScore>51.0</MatchGradeComponentScore>'
            +'</MatchGradeComponent>'
            +'<MatchGradeComponent>'
            +'<MatchGradeComponentTypeText>Uniqueness</MatchGradeComponentTypeText>'
            +'<MatchGradeComponentRating>F</MatchGradeComponentRating>'
            +'<MatchGradeComponentScore>12.5</MatchGradeComponentScore>'
            +'</MatchGradeComponent>'
            +'<MatchGradeComponent>'
            +'<MatchGradeComponentTypeText>Sic</MatchGradeComponentTypeText>'
            +'<MatchGradeComponentRating>Z</MatchGradeComponentRating>'
            +'<MatchGradeComponentScore>0</MatchGradeComponentScore>'
            +'</MatchGradeComponent>'
            +'<MatchDataProfileText>0299999900999899000000009898</MatchDataProfileText>'
            +'<MatchDataProfileComponentCount>14</MatchDataProfileComponentCount>'
            +'<MatchDataProfileComponent>'
            +'<MatchDataProfileComponentTypeText>Name</MatchDataProfileComponentTypeText>'
            +'<MatchDataProfileComponentValue>02</MatchDataProfileComponentValue>'
            +'</MatchDataProfileComponent>'
            +'<MatchDataProfileComponent>'
            +'<MatchDataProfileComponentTypeText>Street Number</MatchDataProfileComponentTypeText>'
            +'<MatchDataProfileComponentValue>99</MatchDataProfileComponentValue>'
            +'</MatchDataProfileComponent>'
            +'<MatchDataProfileComponent>'
            +'<MatchDataProfileComponentTypeText>Street Name</MatchDataProfileComponentTypeText>'
            +'<MatchDataProfileComponentValue>99</MatchDataProfileComponentValue>'
            +'</MatchDataProfileComponent>'
            +'<MatchDataProfileComponent>'
            +'<MatchDataProfileComponentTypeText>City</MatchDataProfileComponentTypeText>'
            +'<MatchDataProfileComponentValue>99</MatchDataProfileComponentValue>'
            +'</MatchDataProfileComponent>'
            +'<MatchDataProfileComponent>'
            +'<MatchDataProfileComponentTypeText>State</MatchDataProfileComponentTypeText>'
            +'<MatchDataProfileComponentValue>00</MatchDataProfileComponentValue>'
            +'</MatchDataProfileComponent>'
            +'<MatchDataProfileComponent>'
            +'<MatchDataProfileComponentTypeText>PO Box</MatchDataProfileComponentTypeText>'
            +'<MatchDataProfileComponentValue>99</MatchDataProfileComponentValue>'
            +'</MatchDataProfileComponent>'
            +'<MatchDataProfileComponent>'
            +'<MatchDataProfileComponentTypeText>Phone</MatchDataProfileComponentTypeText>'
            +'<MatchDataProfileComponentValue>98</MatchDataProfileComponentValue>'
            +'</MatchDataProfileComponent>'
            +'<MatchDataProfileComponent>'
            +'<MatchDataProfileComponentTypeText>Postal Code</MatchDataProfileComponentTypeText>'
            +'<MatchDataProfileComponentValue>99</MatchDataProfileComponentValue>'
            +'</MatchDataProfileComponent>'
            +'<MatchDataProfileComponent>'
            +'<MatchDataProfileComponentTypeText>DUNS</MatchDataProfileComponentTypeText>'
            +'<MatchDataProfileComponentValue>00</MatchDataProfileComponentValue>'
            +'</MatchDataProfileComponent>'
            +'<MatchDataProfileComponent>'
            +'<MatchDataProfileComponentTypeText>SIC</MatchDataProfileComponentTypeText>'
            +'<MatchDataProfileComponentValue>00</MatchDataProfileComponentValue>'
            +'</MatchDataProfileComponent>'
            +'<MatchDataProfileComponent>'
            +'<MatchDataProfileComponentTypeText>Density</MatchDataProfileComponentTypeText>'
            +'<MatchDataProfileComponentValue>00</MatchDataProfileComponentValue>'
            +'</MatchDataProfileComponent>'
            +'<MatchDataProfileComponent>'
            +'<MatchDataProfileComponentTypeText>Uniqueness</MatchDataProfileComponentTypeText>'
            +'<MatchDataProfileComponentValue>00</MatchDataProfileComponentValue>'
            +'</MatchDataProfileComponent>'
            +'<MatchDataProfileComponent>'
            +'<MatchDataProfileComponentTypeText>National ID</MatchDataProfileComponentTypeText>'
            +'<MatchDataProfileComponentValue>98</MatchDataProfileComponentValue>'
            +'</MatchDataProfileComponent>'
            +'<MatchDataProfileComponent>'
            +'<MatchDataProfileComponentTypeText>URL</MatchDataProfileComponentTypeText>'
            +'<MatchDataProfileComponentValue>98</MatchDataProfileComponentValue>'
            +'</MatchDataProfileComponent>'
            +'</MatchQualityInformation>'
            +'<DisplaySequence>3</DisplaySequence>'
            +'</MatchCandidate>'
            +'</MatchResponseDetail>'
            +'<CleanseAndStandardizeResponseDetail>'
            +'<StandardizedName>'
            +'<OrganizationName>Gorman Manufacturing</OrganizationName>'
            +'</StandardizedName>'
            +'<StandardizedAddress>'
            +'<TerritoryAbbreviatedName>CA</TerritoryAbbreviatedName>'
            +'<TerritoryName>California</TerritoryName>'
            +'<CountryISOAlpha2Code>US</CountryISOAlpha2Code>'
            +'<CountryName>United States</CountryName>'
            +'<DeliveryPointValidationDetail>'
            +'<StatusValue>No DPV Address</StatusValue>'
            +'<CMRAValue>No DPV Address</CMRAValue>'
            +'</DeliveryPointValidationDetail>'
            +'<AddressTypeValue>Unknown</AddressTypeValue>'
            +'<InexactAddressIndicator>false</InexactAddressIndicator>'
            +'</StandardizedAddress>'
            +'</CleanseAndStandardizeResponseDetail>'
            +'<InquiryReferenceDetail/>'
            +'</GetCleanseMatchResponseDetail>'
            +'</com:GetCleanseMatchResponse>'
            +'</soap-env:Body>'
            +'</soapenv:Envelope>';

        String entity_eml_response = '<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/">'
            +'<soapenv:Body xmlns:ent="http://services.dnb.com/EntityListServiceV2.0">'
            +'<ent:FindCompanyResponse ServiceVersionNumber="6.4">'
            +'<TransactionDetail>'
            +'<ApplicationTransactionID>Id-c642a96852729e470dcb742e-1</ApplicationTransactionID>'
            +'<ServiceTransactionID>Id-c642a96852729e470dcb742e-1</ServiceTransactionID>'
            +'<TransactionTimestamp>2013-10-31T14:15:36</TransactionTimestamp>'
            +'</TransactionDetail>'
            +'<TransactionResult>'
            +'<SeverityText>Information</SeverityText>'
            +'<ResultID>CM000</ResultID>'
            +'<ResultText>Success</ResultText>'
            +'</TransactionResult>'
            +'<FindCompanyResponseDetail>'
            +'<CandidateMatchedQuantity>1618</CandidateMatchedQuantity>'
            +'<CandidateReturnedQuantity>1</CandidateReturnedQuantity>'
            +'<FindCandidate>'
            +'<DUNSNumber>804735132</DUNSNumber>'
            +'<OrganizationPrimaryName>'
            +'<OrganizationName>Gorman Manufacturing Company, Inc.</OrganizationName>'
            +'</OrganizationPrimaryName>'
            +'<PrimaryAddress>'
            +'<StreetAddressLine>'
            +'<LineText>492 Koller St</LineText>'
            +'</StreetAddressLine>'
            +'<PrimaryTownName>San Francisco</PrimaryTownName>'
            +'<CountryISOAlpha2Code>US</CountryISOAlpha2Code>'
            +'<PostalCode>94110</PostalCode>'
            +'<PostalCodeExtensionCode>1190</PostalCodeExtensionCode>'
            +'<TerritoryOfficialName>California</TerritoryOfficialName>'
            +'<TerritoryAbbreviatedName>CA</TerritoryAbbreviatedName>'
            +'<CountryOfficialName>United States</CountryOfficialName>'
            +'<MetropolitanStatisticalAreaUSCensusCode>47900</MetropolitanStatisticalAreaUSCensusCode>'
            +'</PrimaryAddress>'
            +'<TelephoneNumber>'
            +'<TelecommunicationNumber>6505550000</TelecommunicationNumber>'
            +'</TelephoneNumber>'
            +'<StandaloneOrganizationIndicator>false</StandaloneOrganizationIndicator>'
            +'<ConsolidatedEmployeeDetails>'
            +'<TotalEmployeeQuantity>153</TotalEmployeeQuantity>'
            +'</ConsolidatedEmployeeDetails>'
            +'<SalesRevenueAmount CurrencyISOAlpha3Code="USD" UnitOfSize="Million">0.11</SalesRevenueAmount>'
            +'<DisplaySequence>1</DisplaySequence>'
            +'</FindCandidate>'
            +'</FindCompanyResponseDetail>'
            +'</ent:FindCompanyResponse>'
            +'</soapenv:Body>'
            +'</soapenv:Envelope>';

		private Map<String, String> responseMapping = new Map<String, String>
		{
            '/Company/V4.0' => xml_response,
            '/EntityList/V6.1' => entity_eml_response
        };

        public DNBI_Service_Mock() {
        }

		public DNBI_Service_Mock(Map<String, String> responseMapping)
		{
            this.responseMapping.putAll(responseMapping);
        }

		public HTTPResponse respond(HTTPRequest request)
		{
            HttpResponse response = new HttpResponse();
            String endpoint = request.getEndpoint();

            response.setStatusCode(200);

            // If the endpoint ends with one of the mapped URLs, return the associated response.
			for(String url_endpoint: responseMapping.keySet())
			{
				if (endpoint.endsWith(url_endpoint))
				{
                    response.setBody(responseMapping.get(url_endpoint));
                    return response;
                }
            }

            response.setBody('{"error": "Resource not found"}');
            response.setStatusCode(404);
            return response;
        }
    }

    @isTest
	static void method1()
	{
        Test.setMock(HttpCalloutMock.class, new DNBI_Service_Mock());
        Test.startTest();
        Account my_account = [SELECT Id, Name, Address1__c, City__c, State__c, Zip__c, Country__c, Phone FROM Account WHERE Name = 'GORMAN MANUFACTURING COMPANY, INC.' LIMIT 1];
		my_account.Duns_Enrichment__c = '123456782';
		my_account.DNBI_MatchScore__c = 3;
		DNBIHelper.GetCreditApproval(my_account, my_account.City__c, my_account.Country__c, my_account.State__c, my_account.Address1__c, my_account.Zip__c, my_account.Name);
        Test.stopTest();
    }

    @isTest
	static void test_GetDUNSNumber()
	{
        Test.setMock(HttpCalloutMock.class, new DNBI_Service_Mock());
        Test.startTest();
        Account my_account = [SELECT Id, Name, Address1__c, City__c, State__c, Zip__c, Country__c, Phone FROM Account WHERE Name = 'GORMAN MANUFACTURING COMPANY, INC.' LIMIT 1];
		DNBIHelper.GetDUNSNumber(my_account.id, my_account.City__c, my_account.Country__c, my_account.State__c, my_account.Address1__c, my_account.Zip__c, my_account.Name);
		my_account = [SELECT Duns_Enrichment__c FROM Account WHERE Name = 'GORMAN MANUFACTURING COMPANY, INC.' LIMIT 1];
		System.assertEquals('012345678', my_account.Duns_Enrichment__c);
        Test.stopTest();
    }

    @isTest
	static void test_GetDUNSNumberFROMFindCompany()
	{
        Test.setMock(HttpCalloutMock.class, new DNBI_Service_Mock());
        Test.startTest();
        String result_duns = DNBIHelper.GetDUNSNumberFROMFindCompany('US', '123456789');
        System.assertEquals('804735132', result_duns);
        Test.stopTest();
    }

    @isTest
	static void test_GetBSDAccountDUNSNumber()
	{
        Test.setMock(HttpCalloutMock.class, new DNBI_Service_Mock());
        Test.startTest();
        Account my_account = [SELECT Id, Name, Address1__c, City__c, State__c, Zip__c, Country__c, Phone FROM Account WHERE Name = 'GORMAN MANUFACTURING COMPANY, INC.' LIMIT 1];
        List<String> result_duns = DNBIHelper.GetBSDAccountDUNSNumber(
            my_account.Id, 
            my_account.City__c,
            my_account.Country__c,
            my_account.State__c,
            my_account.Address1__c,
            my_account.Zip__c, 
            my_account.Name, 
            my_account.Phone, 
            '12321232');
        System.assertEquals('804735132', result_duns[0]);
        Test.stopTest();
    }
}