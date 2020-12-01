public class GetSPCCardInfoProcessService
{
	@AuraEnabled
	public static GetSPCCardInfoProcessService.SPCCardInfoOutput[] processMethod(Map<String, Object>  params)
	{
		String recordId = (String) params.get('recordId');
		String aopsCustId = (String) params.get('aopsCustId');
		Account acc;

		if (recordId != null)
		{
			acc = [SELECT Id, AOPS_Cust_ID__c FROM Account WHERE Id =:recordId];
		}
		else if (aopsCustId != null)
		{
			acc = [SELECT Id, AOPS_Cust_ID__c FROM Account WHERE AOPS_Cust_ID__c =:aopsCustId LIMIT 1];
		}

		if (acc.AOPS_Cust_ID__c != null)
		{
			GetSPCCardInfoABCS.execute_pt obj = new GetSPCCardInfoABCS.execute_pt();
			obj.timeout_x = 13000;
			String JSONString = JSON.serialize(obj.execute(acc.AOPS_Cust_ID__c));
            GetSPCCardInfoProcessService.SPCCardInfoOutput[] obj1 = (List<GetSPCCardInfoProcessService.SPCCardInfoOutput>) System.JSON.deserialize(JSONString, List<GetSPCCardInfoProcessService.SPCCardInfoOutput>.class);
            
            if (obj1 != null)
            {
                // Only keep the last 4 digits of all SPC cards
                for (GetSPCCardInfoProcessService.SPCCardInfoOutput currentSPCCard : obj1)
                {
                    for (GetSPCCardInfoProcessService.CardDetails cardDetail : currentSPCCard.CardDetails)
                    {
                        if (cardDetail.CardNumber.length() > 4)
                        {
                            cardDetail.CardNumber = cardDetail.CardNumber.substring(cardDetail.CardNumber.length() - 4);
                        }
                    }
                }
            }

			return obj1;
		}
		else
		{
			return null;
		}
    }
    
	@AuraEnabled
	public static boolean SendEmailMessage(Object spclist, String emailString)
	{
		if (emailString != null && emailString != 'undefined' && emailString != '' && spclist != null && spclist != 'undefined' && spclist != '')
		{
			String generatedCSVFile = '';
			String fileRow = '';
			List<String> queryFields = new List<String> {'Card Number', 'Create Date', 'SPC Card Holder Name', 'Card Holder Phone', 'Daily Dollar Limit', 'Order Limit'};
			for (String str:queryFields)
			{
				fileRow = fileRow + ',' + str;
			}
			fileRow = fileRow.replaceFirst(',', '');
			generatedCSVFile = generatedCSVFile + fileRow + '\n';
			String JSONString = JSON.serialize(spclist);
			GetSPCCardInfoProcessService.SPCCardInfoOutput[] obj1 = (List<GetSPCCardInfoProcessService.SPCCardInfoOutput>)System.JSON.deserialize(JSONString, List<GetSPCCardInfoProcessService.SPCCardInfoOutput>.class);
			for (GetSPCCardInfoProcessService.SPCCardInfoOutput spc: obj1)
			{
				fileRow = '';
				for (GetSPCCardInfoProcessService.CardDetails crd:spc.CardDetails)
				{
					fileRow = fileRow + ',' + crd.CardNumber;
					fileRow = fileRow + ',' + crd.CreateDate;
				}
				for (GetSPCCardInfoProcessService.ContactInfo crd:spc.ContactInfo)
				{
					fileRow = fileRow + ',' + crd.SPCCardHolderName;
					fileRow = fileRow + ',' + crd.CardholderPhone;
				}
				for (GetSPCCardInfoProcessService.CardLimitDetails crd:spc.CardLimitDetails)
				{
					fileRow = fileRow + ',' + crd.DailyDollarLimit;
					fileRow = fileRow + ',' + crd.OrderLimit;
				}
				fileRow = fileRow.replaceFirst(',', '');
				generatedCSVFile = generatedCSVFile + fileRow + '\n';
			}
			Messaging.EmailFileAttachment csvAttachment = new Messaging.EmailFileAttachment();
			Blob csvBlob = blob.valueOf(generatedCSVFile);
			String csvName = 'Test.csv';
			csvAttachment.setFileName(csvName);
			csvAttachment.setBody(csvBlob);
			Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();
			string stremail = emailString + '@officedepot.com';
			String[] toAddresses = new String[] {stremail};
			String subject = 'CUSTOMER SPC INFORMATION';
			email.setSubject(subject);
			email.setToAddresses(toAddresses);
			email.setPlainTextBody('DOWNLOAD CUSTOMER SPC INFORMATION  for request ID.Open with EXCEL');
			email.setFileAttachments(new Messaging.EmailFileAttachment[] {csvAttachment});
			Messaging.SendEmailResult[] r = Messaging.sendEmail(new Messaging.SingleEmailMessage[] {email});

            return true;
		}
        else
        {
			return false;
        }
    }
    
	public class SendCustomerReportInput {
		@AuraEnabled public String custID;
		@AuraEnabled public String emailAddress;
		@AuraEnabled public String from_source;
		@AuraEnabled public String[] custID_type_info = new String[] {'custID', 'http://xmlns.officedepot.com/ODHome/EnterpriseArtifacts/SFDC/GetSPCCardInfoProcess', null, '1', '1', 'true'};
		@AuraEnabled public String[] emailAddress_type_info = new String[] {'emailAddress', 'http://xmlns.officedepot.com/ODHome/EnterpriseArtifacts/SFDC/GetSPCCardInfoProcess', null, '1', '1', 'true'};
		@AuraEnabled public String[] from_source_type_info = new String[] {'from_source', 'http://xmlns.officedepot.com/ODHome/EnterpriseArtifacts/SFDC/GetSPCCardInfoProcess', null, '1', '1', 'true'};
		@AuraEnabled public String[] apex_schema_type_info = new String[] {'http://xmlns.officedepot.com/ODHome/EnterpriseArtifacts/SFDC/GetSPCCardInfoProcess', 'true', 'true'};
		@AuraEnabled public String[] field_order_type_info = new String[] {'custID', 'emailAddress', 'from_source'};
	}
	public class getCustomerCardInfoInput {
		@AuraEnabled public String custID;
		@AuraEnabled public String[] custID_type_info = new String[] {'custID', 'http://xmlns.officedepot.com/ODHome/EnterpriseArtifacts/SFDC/GetSPCCardInfoProcess', null, '1', '1', 'true'};
		@AuraEnabled public String[] apex_schema_type_info = new String[] {'http://xmlns.officedepot.com/ODHome/EnterpriseArtifacts/SFDC/GetSPCCardInfoProcess', 'true', 'true'};
		@AuraEnabled public String[] field_order_type_info = new String[] {'custID'};
	}
	public class faultmessage {
		@AuraEnabled public String code;
		@AuraEnabled public String message;
		@AuraEnabled public String detail;
		@AuraEnabled public String[] code_type_info = new String[] {'code', 'http://xmlns.officedepot.com/ODHome/EnterpriseArtifacts/SFDC/GetSPCCardInfoProcess', null, '1', '1', 'true'};
		@AuraEnabled public String[] message_type_info = new String[] {'message', 'http://xmlns.officedepot.com/ODHome/EnterpriseArtifacts/SFDC/GetSPCCardInfoProcess', null, '1', '1', 'true'};
		@AuraEnabled public String[] detail_type_info = new String[] {'detail', 'http://xmlns.officedepot.com/ODHome/EnterpriseArtifacts/SFDC/GetSPCCardInfoProcess', null, '1', '1', 'true'};
		@AuraEnabled public String[] apex_schema_type_info = new String[] {'http://xmlns.officedepot.com/ODHome/EnterpriseArtifacts/SFDC/GetSPCCardInfoProcess', 'true', 'true'};
		@AuraEnabled public String[] field_order_type_info = new String[] {'code', 'message', 'detail'};
	}
	public class SPCCardInfoOutput {
		@AuraEnabled public GetSPCCardInfoProcessService.CardDetails[] CardDetails;
		@AuraEnabled public GetSPCCardInfoProcessService.ContactInfo[] ContactInfo;
		@AuraEnabled public GetSPCCardInfoProcessService.CardLimitDetails[] CardLimitDetails;
		@AuraEnabled public String[] CardDetails_type_info = new String[] {'CardDetails', 'http://xmlns.officedepot.com/ODHome/EnterpriseArtifacts/SFDC/GetSPCCardInfoProcess', null, '0', '-1', 'false'};
		@AuraEnabled public String[] ContactInfo_type_info = new String[] {'ContactInfo', 'http://xmlns.officedepot.com/ODHome/EnterpriseArtifacts/SFDC/GetSPCCardInfoProcess', null, '0', '-1', 'false'};
		@AuraEnabled public String[] CardLimitDetails_type_info = new String[] {'CardLimitDetails', 'http://xmlns.officedepot.com/ODHome/EnterpriseArtifacts/SFDC/GetSPCCardInfoProcess', null, '0', '-1', 'false'};
		@AuraEnabled public String[] apex_schema_type_info = new String[] {'http://xmlns.officedepot.com/ODHome/EnterpriseArtifacts/SFDC/GetSPCCardInfoProcess', 'true', 'true'};
		@AuraEnabled public String[] field_order_type_info = new String[] {'CardDetails', 'ContactInfo', 'CardLimitDetails'};
	}
	public class ContactInfo {
		@AuraEnabled public String SPCCardHolderName;
		@AuraEnabled public String AddressSequence;
		@AuraEnabled public String CardholderPhone;
		@AuraEnabled public String DepartmentSequence;
		@AuraEnabled public String DepartmentDescription;
		@AuraEnabled public String PONumber;
		@AuraEnabled public String CreditCode;
		@AuraEnabled  public String[] SPCCardHolderName_type_info = new String[] {'SPCCardHolderName', 'http://xmlns.officedepot.com/ODHome/EnterpriseArtifacts/SFDC/GetSPCCardInfoProcess', null, '1', '1', 'true'};
		@AuraEnabled public String[] AddressSequence_type_info = new String[] {'AddressSequence', 'http://xmlns.officedepot.com/ODHome/EnterpriseArtifacts/SFDC/GetSPCCardInfoProcess', null, '1', '1', 'true'};
		@AuraEnabled public String[] CardholderPhone_type_info = new String[] {'CardholderPhone', 'http://xmlns.officedepot.com/ODHome/EnterpriseArtifacts/SFDC/GetSPCCardInfoProcess', null, '1', '1', 'true'};
		@AuraEnabled public String[] DepartmentSequence_type_info = new String[] {'DepartmentSequence', 'http://xmlns.officedepot.com/ODHome/EnterpriseArtifacts/SFDC/GetSPCCardInfoProcess', null, '1', '1', 'true'};
		@AuraEnabled public String[] DepartmentDescription_type_info = new String[] {'DepartmentDescription', 'http://xmlns.officedepot.com/ODHome/EnterpriseArtifacts/SFDC/GetSPCCardInfoProcess', null, '1', '1', 'true'};
		@AuraEnabled public String[] PONumber_type_info = new String[] {'PONumber', 'http://xmlns.officedepot.com/ODHome/EnterpriseArtifacts/SFDC/GetSPCCardInfoProcess', null, '1', '1', 'true'};
		@AuraEnabled public String[] CreditCode_type_info = new String[] {'CreditCode', 'http://xmlns.officedepot.com/ODHome/EnterpriseArtifacts/SFDC/GetSPCCardInfoProcess', null, '1', '1', 'true'};
		@AuraEnabled public String[] apex_schema_type_info = new String[] {'http://xmlns.officedepot.com/ODHome/EnterpriseArtifacts/SFDC/GetSPCCardInfoProcess', 'true', 'true'};
		@AuraEnabled public String[] field_order_type_info = new String[] {'SPCCardHolderName', 'AddressSequence', 'CardholderPhone', 'DepartmentSequence', 'DepartmentDescription', 'PONumber', 'CreditCode'};
	}
	public class CardLimitDetails {
		@AuraEnabled public String DailyDollarLimit;
		@AuraEnabled public String OrderLimit;
		@AuraEnabled public String DailyTransactionLimit;
		@AuraEnabled public String[] DailyDollarLimit_type_info = new String[] {'DailyDollarLimit', 'http://xmlns.officedepot.com/ODHome/EnterpriseArtifacts/SFDC/GetSPCCardInfoProcess', null, '1', '1', 'true'};
		@AuraEnabled public String[] OrderLimit_type_info = new String[] {'OrderLimit', 'http://xmlns.officedepot.com/ODHome/EnterpriseArtifacts/SFDC/GetSPCCardInfoProcess', null, '1', '1', 'true'};
		@AuraEnabled public String[] DailyTransactionLimit_type_info = new String[] {'DailyTransactionLimit', 'http://xmlns.officedepot.com/ODHome/EnterpriseArtifacts/SFDC/GetSPCCardInfoProcess', null, '1', '1', 'true'};
		@AuraEnabled public String[] apex_schema_type_info = new String[] {'http://xmlns.officedepot.com/ODHome/EnterpriseArtifacts/SFDC/GetSPCCardInfoProcess', 'true', 'true'};
		@AuraEnabled public String[] field_order_type_info = new String[] {'DailyDollarLimit', 'OrderLimit', 'DailyTransactionLimit'};
	}
	public class CustomerInfoOutput {
		@AuraEnabled public GetSPCCardInfoProcessService.SPCCardInfoOutput[] SPCCardInfoOutput;
		@AuraEnabled public String[] SPCCardInfoOutput_type_info = new String[] {'SPCCardInfoOutput', 'http://xmlns.officedepot.com/ODHome/EnterpriseArtifacts/SFDC/GetSPCCardInfoProcess', null, '0', '-1', 'false'};
		@AuraEnabled public String[] apex_schema_type_info = new String[] {'http://xmlns.officedepot.com/ODHome/EnterpriseArtifacts/SFDC/GetSPCCardInfoProcess', 'true', 'true'};
		@AuraEnabled public String[] field_order_type_info = new String[] {'SPCCardInfoOutput'};
	}
	public class CardDetails {
		@AuraEnabled public String CardNumber;
		@AuraEnabled public String CreateDate;
		@AuraEnabled public String[] CardNumber_type_info = new String[] {'CardNumber', 'http://xmlns.officedepot.com/ODHome/EnterpriseArtifacts/SFDC/GetSPCCardInfoProcess', null, '1', '1', 'true'};
		@AuraEnabled public String[] CreateDate_type_info = new String[] {'CreateDate', 'http://xmlns.officedepot.com/ODHome/EnterpriseArtifacts/SFDC/GetSPCCardInfoProcess', null, '1', '1', 'true'};
		@AuraEnabled public String[] apex_schema_type_info = new String[] {'http://xmlns.officedepot.com/ODHome/EnterpriseArtifacts/SFDC/GetSPCCardInfoProcess', 'true', 'true'};
		@AuraEnabled public String[] field_order_type_info = new String[] {'CardNumber', 'CreateDate'};
	}
}