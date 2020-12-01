/**
* @author Adam Albright, adam.albright@officedepot.com
* @date 3/4/2018
*
* @group Lead Conversion
* @group-content /ApexDocContent/Index.htm
*
* @description This Class is a wrapper for converting Bizbox and Business pro leads from a Override or button.
*
*/
public class Convert_Lead_BizBox_BusPro_Wrapper {

	/*******************************************************************************************************
    * @description Converts a lead according to it's RecordTypeId.
    * Currently, it supports converting BizBox Leads and Business Pro Leads and it supports RecordType preservation through conversion.
    * @param LeadId The Id of the lead to be converted. If the lead cannot be found or it is already converted, a QueryException or a
    * LeadConversionException are thrown for their respective errors.
    * @return A map of a string to sObject where 'Account' Maps to the converted account and 'Contact' maps to the generated account.
    */
	public static Map<String, sObject> ConvertLead(Id LeadId){
		Lead UnConvertedLead;
		Map<String, sObject> ConversionResultMap;

		try{ // can we find the lead we are looking for.
			UnConvertedLead = [SELECT 	Id,
					Name,
					Products__c,
					Phone,
					Business_Pro_Loyalty_Account_Number__c,
					RecordTypeId,
					OwnerId,
					Company,
					IsConverted FROM Lead WHERE Id=:LeadId LIMIT 1];
		} catch (System.QueryException e){
			System.debug(LoggingLevel.ERROR, 'The Lead could not be retrieved for Id = ' + LeadId + '.');
		}

		try{
			if(UnConvertedLead.RecordTypeId == MyUtils_Lead.BizBoxRecordTypeId
					&& UnConvertedLead.Business_Pro_Loyalty_Account_Number__c == null ){
				UnConvertedLead.Business_Pro_Loyalty_Account_Number__c = '00zx01' +Datetime.now().millisecond();
				update UnConvertedLead;
			}
		} catch (DmlException e){
			throw new MyUtils_Lead.LeadConversionException(e.getMessage() , e);
		}

		if(UnConvertedLead.OwnerId != System.UserInfo.getUserId()){
			throw new MyUtils_Lead.LeadConversionException('VALIDATION_EXCEPTION, To convert a lead, you must be the owner of the lead.');
		}


		// Is lead unconverted?
		if(UnConvertedLead.IsConverted)
			throw new MyUtils_Lead.LeadConversionException('The Lead with Id: ' + LeadId + ' has already been converted and cannot be converted again through this method.');


		// Did we get an expected record type?
		if(UnConvertedLead.RecordTypeId == Convert_Lead_BizBox.AcceptedRecordTypeId){
			ConversionResultMap = Convert_Lead_BizBox.ConvertLead(UnConvertedLead);
		} else if(UnConvertedLead.RecordTypeId == Convert_Lead_BusPro.AcceptedRecordTypeId){
			ConversionResultMap = Convert_Lead_BusPro.ConvertLead(UnConvertedLead);
		}else{
			throw new MyUtils_Lead.LeadConversionException('Unexpected record type passed. This conversion '
					+ 'method only sopports BizBox and Business Pro Leads.');
		}

		return ConversionResultMap;
	}

}