public without sharing class WebCollectRestRequest
{
	public static String GetAuthorizationToken(WebCollect__c wc)
	{
		Http http = new Http();
		HttpRequest req = new HttpRequest();
		req.setEndpoint(wc.GetAuthorizationEndpoint__c);
		req.setMethod('POST');
		req.setTimeout(120000);
		req.setHeader('Content-Type', 'application/x-www-form-urlencoded');
		String username = wc.Username__c;
		String password = wc.Password__c;
		String clientId = 'OfficeDepot';
		String clientsecret = 'T03g3ter789$';
		String payload = 'grant_type=password' + '&client_id=' + EncodingUtil.urlEncode(clientId, 'UTF-8') + '&client_secret=' + EncodingUtil.urlEncode(clientsecret, 'UTF-8') + '&username=' + EncodingUtil.urlEncode(username, 'UTF-8') + '&password=' + EncodingUtil.urlEncode(password, 'UTF-8') + '&scope=authorize';
		req.setBody(payload);
		HTTPResponse res = http.send(req);
		TokenResponse restoken = (TokenResponse)System.JSON.deserialize(res.getBody(), TokenResponse.class);
		return restoken.access_token;
	}

	@AuraEnabled
	public static WebCollectResponse WebCollectCallout(Map<String, Object> params)
	{
		WebCollect__c wc = WebCollect__c.getInstance('Service Details');
		String recordId = (String) params.get('recordId');
		String aopsCustId = (String) params.get('aopsCustId');
		HTTPResponse res = New HTTPResponse();

		if (aopsCustId == null)
		{
			if (recordId != null)
			{
				aopsCustId = [SELECT Id, AOPS_Cust_Id__c FROM Account WHERE Id = :recordId].AOPS_Cust_Id__c;
			}
			else
			{
				WebCollectResponse resBody = new WebCollectResponse();
				resBody.StatusCode = 0;
				resBody.ErrorMessage = 'Account has no Customer ID';
				return resBody;
			}
		}

		Http http = new Http();
		HttpRequest req1 = new HttpRequest();
		String str = 'Bearer ' + GetAuthorizationToken(wc);

		req1.setEndpoint(wc.WebCollectServiceEndpoint__c + aopsCustId );
		req1.setMethod('GET');
		req1.setHeader('Authorization', str);
		req1.setHeader('Content-Type', 'application/JSON');
		req1.setHeader('accept', 'application/JSON');
		req1.setTimeout(120000);
		res = http.send(req1);

		if (res.getStatusCode() == 200)
		{
			WebCollectResponse resBody = (WebCollectResponse)System.JSON.deserialize(res.getBody(), WebCollectResponse.class);
			resBody.StatusCode = 200;
			resBody.ErrorMessage = 'Success';
			return resBody;
		}
		else if (res.getStatusCode() == 404)
		{
			WebCollectResponse resBody = new WebCollectResponse();
			resBody.StatusCode = 404;
			resBody.ErrorMessage = 'Record not found';
			return resBody;
		}
		else if (res.getStatusCode() == 401)
		{
			WebCollectResponse resBody = new WebCollectResponse();
			resBody.StatusCode = 401;
			resBody.ErrorMessage = 'Invalid or expired tokens';
			return resBody;
		}
		else if (res.getStatusCode() == 503)
		{
			WebCollectResponse resBody = new WebCollectResponse();
			resBody.StatusCode = 503;
			resBody.ErrorMessage = 'Service unavailable';
			return resBody;
		}
		else
		{
			return null;
		}
	}

	@AuraEnabled
	public static string GetAccountOps(Map<String, Object> params)
	{
		String recordId = (String) params.get('recordId');
		if (recordId != null)
		{
			return [SELECT Id, AOPS_Cust_ID__c FROM Account WHERE Id = : recordId].AOPS_Cust_ID__c;
		}
		else
		{
			return null;
		}
	}

	public class WebCollectResponse {
		@AuraEnabled public String cus_coll_name;
		@AuraEnabled public String cus_coll_phn;
		@AuraEnabled public String cus_coll_email;
		@AuraEnabled public String cus_lead_name;
		@AuraEnabled public String cus_lead_phn;
		@AuraEnabled public String cus_lead_email;
		@AuraEnabled public String cus_mgr_name;
		@AuraEnabled public String cus_mgr_phn;
		@AuraEnabled public String cus_mgr_email;
		@AuraEnabled public Integer StatusCode;
		@AuraEnabled public String ErrorMessage;
	}

	public class TokenResponse {
		@AuraEnabled  public String access_token;
		@AuraEnabled  public String token_type;
	}
}