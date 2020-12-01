/**
* @author Adam Albright, adam.albright@officedepot.com
* @date 3/4/2018
*
* @group Lead Conversion Testing
* @group-content /ApexDocContent/Index.htm
* @description This Class Interfaces with the Biz_Box_BPro_Convert lightning component to provide conversion functionality. It is covered by Convert_Lead_BizBox_BusPro_Wrapper_TC;
*
*/
public class BizBox_BusPro_Lead_Convert_Aura {


	@AuraEnabled
	public static Lead startInit(Id LeadId){
		return [SELECT Id, Name, Email, Company, IsConverted, RecordTypeId, ConvertedAccountId, ConvertedContactId FROM Lead WHERE Id=:LeadId];
	}

	@AuraEnabled
	public static Map<String, Object> ConvertLead(Id LeadId){
		System.debug(LoggingLevel.INFO, 'Starting Lead Conversion.');

		Map<String, Object> MyMap = new Map<String, Object>();
		Map<String, sObject> Results = new Map<String, sObject>();

		MyMap.put('Status', 'Error Message Here.');
		try{
			Results = Convert_Lead_BizBox_BusPro_Wrapper.ConvertLead(LeadId);
			MyMap.put('StatusCode', 0);
			MyMap.put('Status', 'All Systems Go.');
			MyMap.put('Account', Results.get('Account'));
			MyMap.put('Contact', Results.get('Contact'));

		}catch( MyUtils_Lead.LeadConversionException e){
			MyMap.put('Status', e.getMessage());
			MyMap.put('StatusCode', -1);
		}




		return  MyMap;
	}
}