/**
 * @author Adam Albright, adam.albright@officedepot.com
 * @date 3/16/2018
 *
 * @group Utility
 * @group-content /ApexDocContent/Index.htmz
 *
 * @description This is a general utility class for Org__c Objects.
 *
 * */
public class MyUtils_Org {

	public static Org__c GenerateOrg(Integer counter){
		return new Org__c(
				Address_1__c = '12' + counter + ' North Military Trail',
				Address_2__c = 'Suite ' + counter,
				Business_Name__c = 'Great Company ' + counter,
				City__c = 'Boca Raton',
				State__c = 'FL',
				Zip__c = '33496',
				Alt_Business_Name_1__c = 'Great Biz' + counter,
				DUNS_Number__c = '7263527' +counter );
	}

	public static List<Org__c> GenerateOrgList(Integer Count){
		List<Org__c> myOrgs = new List<Org__c>();
		for(Integer i = 0; i < Count; i++){
			myOrgs.add(GenerateOrg(i));
		}

		return myOrgs;
	}

}