public class GPOUserReg
{
	String HeaderXML, fullXML, RequestXML, ResponseXML, domain, endPoint, soapAction, response;

	public class GPOUserRegResponse
	{
		public String StatusCode;
		public String StatusDescription;
		public String AOPSID;
	}

	public class GPOUserRefRequest
	{
		public String Firstname;
		public String LastName;
		public String Email;
		public String Phone;
		public String Password;
		public String LoginName;
		public String address1;
		public String address2;
		public String City;
		public String State;
		public String Zip;
		public String AopsCustId;
		public String CompanyName;
		public String PONumber;
		public String CCenter;
		public String Release;
		public String Desktop;
		public String SSO_Id;
		public String CustomCatalogCode;
		public String RegisterSPC;
		public String ReqPrintedSPC;

	}

	public GPOUserRegResponse executeUserReg(GPOUserRefRequest gReq)
	{
		GPOUserRegResponse gRes = new GPOUserRegResponse();
		GPO_Community_Setup__c commSetup = gpo_community_setup__c.getValues('com2Settings');

		try
		{
			domain = commSetup.SOA_EndPoint__c;
			endPoint = domain + 'osb-infra/AccountManagement';
			HeaderXML = '<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:acc="http://eai.officedepot.com/service/AccountManagement" xmlns:tran="http://www.officedepot.com/model/transaction" xmlns:acc1="http://eai.officedepot.com/model/Account" xmlns:esb="http://www.officedepot.com/model/Common/ESBCommon">'
						+ '<soapenv:Header/>'
						+ '<soapenv:Body>';
			RequestXML = '<acc:createContactWebUserRequest     xmlns:tran="http://www.officedepot.com/model/transaction" xmlns:acc="http://eai.officedepot.com/service/AccountManagement" xmlns:acc1="http://eai.officedepot.com/model/Account" xmlns:esb="http://www.officedepot.com/model/Common/ESBCommon">'
						 + '<tran:transactionHeader>'
						 + '<tran:consumer>'
						 + '<tran:consumerName>SFDC</tran:consumerName>'
						 + '<tran:consumerTransactionID>sfdcTrans</tran:consumerTransactionID>'
						 + '</tran:consumer>'
						 + '</tran:transactionHeader>'
						 + '<acc:createContactWebUser>'
						 + '<acc:accountNumber>' + gReq.AopsCustId + '</acc:accountNumber>'
						 + '<acc:name>'
						 + '<esb:firstName>' + gReq.FirstName + '</esb:firstName>'
						 + '<esb:middleName></esb:middleName>'
						 + '<esb:lastName>' + gReq.Lastname + '</esb:lastName>'
						 + '<esb:fullName>' + gReq.FirstName + ' ' + gReq.LastName + '</esb:fullName>'
						 + '</acc:name>'
						 + '<acc:companyName>' + gReq.companyName + '</acc:companyName>'
						 + '<acc:phone>' + gReq.Phone + '</acc:phone>'
						 + '<acc:emailAddress>' + gReq.Email + '</acc:emailAddress>'
						 + '<acc:wcwCount></acc:wcwCount>'
						 + '<acc:notes></acc:notes>'
						 + '<acc:shippingAddress>'
						 + '<esb:addressLine1>' + gReq.Address1 + '</esb:addressLine1>'
						 + '<esb:addressLine2>' + gReq.Address2 + '</esb:addressLine2>'
						 + '<esb:addressLine3></esb:addressLine3>'
						 + '<esb:city>' + gReq.City + '</esb:city>'
						 + '<esb:region>' + gReq.State + '</esb:region>'
						 + '<esb:postalCode>' + gReq.Zip + '</esb:postalCode>'
						 + '<esb:country>US</esb:country>'
						 + '</acc:shippingAddress>'
						 + '<acc:userId>' + gReq.LoginName + '</acc:userId>'
						 + '<acc:password>'
						 + '<acc1:password>' + gReq.Password + '</acc1:password>'
						 + '</acc:password>'
						 + '<acc:poNumber>' + greq.PONumber + '</acc:poNumber>'
						 + '<acc:costCenterNumber>' + greq.CCenter + '</acc:costCenterNumber>'
						 + '<acc:desktop>' + greq.Desktop + '</acc:desktop>'
						 + '<acc:releaseNumber>' + greq.Release + '</acc:releaseNumber>'
						 + '<acc:spcRequired>' + greq.RegisterSPC + '</acc:spcRequired>'
						 + '<acc:printRequired>' + greq.ReqPrintedSPC + '</acc:printRequired>'
						 + '<acc:ssoId>' + greq.SSO_Id + '</acc:ssoId>'
						 + '<acc:catalogueCode>' + greq.CustomCatalogCode + '</acc:catalogueCode>'
						 + '</acc:createContactWebUser>'
						 + '</acc:createContactWebUserRequest>'
						 + '</soapenv:Body>'
						 + '</soapenv:Envelope>';
			soapAction = '"createContactWebUser"';
			fullXML = HeaderXML + RequestXML;

			String myData = commSetup.SOA_User__c;
			String encodedusernameandpassword = 'Basic ' + EncodingUtil.base64Encode(Blob.valueOf(myData));
			Http http = new Http();
			HTTPResponse res;
			HttpRequest req = new HttpRequest();
			req.setEndpoint(endPoint);
			req.setMethod('POST');
			req.setBody(fullXML);
			req.setHeader('Content-Type', 'text/xml');
			req.setHeader('SOAPAction', soapAction);
			req.setHeader('Authorization', encodedusernameandpassword);
			req.setTimeout(120000);

			if (!Test.isRunningTest())
			{
				res = http.send(req);
				response = res.getBody();
			}
			else
			{
				response = '<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/"><soapenv:Body><acc:createContactWebUserResponse     xmlns:acc="http://eai.officedepot.com/service/AccountManagement"><tran:transactionHeader    xmlns:tran="http://www.officedepot.com/model/transaction"><tran:consumer><tran:consumerName>SFDC</tran:consumerName><tran:consumerTransactionID>UUID</tran:consumerTransactionID></tran:consumer></tran:transactionHeader><acc:response><acc1:statusCode    xmlns:acc1="http://eai.officedepot.com/model/Account">00</acc1:statusCode><acc1:statusDescription   xmlns:acc1="http://eai.officedepot.com/model/Account">WebUser created successfully</acc1:statusDescription></acc:response></acc:createContactWebUserResponse></soapenv:Body></soapenv:Envelope>';
			}

			if (response != null)
			{
				Dom.Document doc = new Dom.Document();
				doc.load(response);
				Dom.XMLNode Envelope = doc.getRootElement();
				Dom.XMLNode Body = Envelope.getChildElements()[0];
				for (Dom.XMLNode child : Body.getChildElements())
				{
					for (Dom.XMLNode subchild : child.getChildElements())
					{
						for (Dom.XMLNode subchild2 : subchild.getChildElements())
						{
							if (subchild2.getname() == 'statusCode')
							{
								gRes.statusCode = subchild2.getText();
							}
							else if (subchild2.getname() == 'statusDescription')
							{
								gRes.statusDescription = subchild2.getText();
							}
							else if (subchild2.getname() == 'contactId')
							{
								try
								{
									gRes.AOPSId = String.valueOf(Integer.valueOf(subchild2.getText()));
								}
								catch (Exception ex)
								{
									System.debug('Run into an exception. ' + ex.getMessage());
								}
							}
						}
					}
				}
			}

			if (gRes.statusCode == null)
			{
				gRes.statusCode = '02';
				gRes.statusDescription = 'Error:Unexpected Error in Service Call - ' + res;
			}

			return gRes;
		}
		catch (Exception e)
		{
			gres.statusCode = '02';
			gres.statusDescription = 'Error:Unexpected Error in Service Call';
			return gres;
		}
	}
}