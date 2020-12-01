@IsTest
public with sharing class ACEPricingInformation_Test
{
    private final static String remediationTeamBatchName = 'Q1-2020';
    private final static String hostedCatalogTeamBatchName = 'Q2-2020';
    private final static String otherTeamBatchName = 'Q3-2020';

	private static void makeAceData()
	{
		User currentUser = [SELECT Id FROM User WHERE Id =:UserInfo.getUserId()];
		System.runAs(currentUser)
		{
			ACE_Settings__c aceSettings = new ACE_Settings__c
										  (
											  BatchName__c = 'Q4-2014',
											  Trigger_By_Pass__c = String.valueOf(UserInfo.getUserId())
										  );
			insert aceSettings;

			Account acc = new Account (name = 'moe test account',
									   AOPS_Seq_ID__c = '123456',
									   AOPS_Cust_Id__c = '123456',
									   Oracle_Party_Id__c = '123456',
									   Billingcountry = 'USA',
									   BillingState = 'UT',
									   BillingStreet = '1040 N 326 W',
									   billingcity = 'Orem');
            insert acc;
		}
	}

	private static void makeOtherData()
	{
		User currentUser = [SELECT Id FROM User WHERE Id =:UserInfo.getUserId()];
		System.runAs(currentUser)
		{
			Profile fieldSalesProfile = [SELECT Id, Name FROM Profile WHERE Name = 'Field Sales'];

			Group remediationTeamGroup = new Group(Name = 'Remediation Team');
			insert remediationTeamGroup;
			Group hostedCatalogTeamGroup = new Group(Name = 'Hosted Catalog Team');
			insert hostedCatalogTeamGroup;

			User remediationTeamUser = new User
									   (
										   Alias = 'rtu', Email = 'rtu@officedepot.com',
										   EmailEncodingKey = 'UTF-8', LastName = 'rtu', LanguageLocaleKey = 'en_US',
										   LocaleSidKey = 'en_US', ProfileId = fieldSalesProfile.Id,
										   TimeZoneSidKey = 'America/Los_Angeles', UserName = 'rtu@officedepot.com'
									   );
			insert remediationTeamUser;
			User hostedCatalogTeamUser = new User
										 (
											 Alias = 'hctu', Email = 'hctu@officedepot.com',
											 EmailEncodingKey = 'UTF-8', LastName = 'hctu', LanguageLocaleKey = 'en_US',
											 LocaleSidKey = 'en_US', ProfileId = fieldSalesProfile.Id,
											 TimeZoneSidKey = 'America/Los_Angeles', UserName = 'hctu@officedepot.com'
										 );
			insert hostedCatalogTeamUser;
			User randomUser = new User
							  (
								  Alias = 'rumoe', Email = 'rumoe@officedepot.com',
								  EmailEncodingKey = 'UTF-8', LastName = 'rumoe', LanguageLocaleKey = 'en_US',
								  LocaleSidKey = 'en_US', ProfileId = fieldSalesProfile.Id,
								  TimeZoneSidKey = 'America/Los_Angeles', UserName = 'rumoe@officedepot.com'
							  );
			insert randomUser;

			GroupMember remediationTeamMember = new GroupMember
												(
													GroupId = remediationTeamGroup.Id,
													UserOrGroupId = remediationTeamUser.Id
												);
			insert remediationTeamMember;
			GroupMember hostedCatalogTeamMember = new GroupMember
												  (
													  GroupId = hostedCatalogTeamGroup.Id,
													  UserOrGroupId = hostedCatalogTeamUser.Id
												  );
			insert hostedCatalogTeamMember;
		}
	}

	@TestSetup
	static void makeData()
	{
		makeAceData();
		makeOtherData();
	}

	@IsTest
	public static void testIsCurrentUserValidTeamMemberTrue()
	{
		User remediationTeamUser = [SELECT Id FROM User WHERE LastName = 'rtu'];
		Boolean isValidTeamMember = false;

		Test.startTest();
		System.runAs(remediationTeamUser)
		{
			isValidTeamMember = ACEPricingInformation.isCurrentUserValidTeamMember();
		}
		Test.stopTest();
		System.assertEquals(true, isValidTeamMember);
	}

	@IsTest
	public static void testIsCurrentUserValidTeamMemberFalse()
	{
		User remediationTeamUser = [SELECT Id FROM User WHERE LastName = 'rumoe'];
		Boolean isValidTeamMember = false;

		Test.startTest();
		System.runAs(remediationTeamUser)
		{
			isValidTeamMember = ACEPricingInformation.isCurrentUserValidTeamMember();
		}
		Test.stopTest();
		System.assertEquals(false, isValidTeamMember);
	}

	@IsTest
	public static void testGetPricingInformationRemediationSuccess()
	{
		User currentUser = [SELECT Id FROM User WHERE Id =:UserInfo.getUserId()];
		User remediationTeamUser = [SELECT Id FROM User WHERE LastName = 'rtu'];
		List<Map<String, Object> > aceBatchesPricingInformation = new List<Map<String, Object> >();

		System.runAs(currentUser)
		{
            Account acc = [SELECT Id, Name FROM Account WHERE Name = 'moe test account'];
			ACE_Customer_Price_Changes__c cpc1 = new ACE_Customer_Price_Changes__c
												 (
													 Name = remediationTeamBatchName,
													 SRM_Differential__c = 1,
													 Item_12_Month_Qty__c = 1,
													 Total_Spend_Impact_12_Month__c = 1,
                                                     Current_Sell_Price__c = 1,
													 Customer__c = acc.id,
                                                     Owning_Customer_ID__c = '1',
                                                     IsRemediation__c = true,
                                                     Hosted_Catalog__c = false
												 );
			insert cpc1;
			ACE_Batches__c batch1 = new ACE_Batches__c
									(
										Name = cpc1.Name,
										Batch__c = cpc1.Name
									);
			insert batch1;
        }

		Test.startTest();
		System.runAs(remediationTeamUser)
		{
			aceBatchesPricingInformation = ACEPricingInformation.getPricingInformationByGroup();
		}
        Test.stopTest();
        System.assertEquals(1, aceBatchesPricingInformation.size());
        Map<String, Object> aceBatchPricingInformation = aceBatchesPricingInformation.get(0);
        System.assertEquals(remediationTeamBatchName, aceBatchPricingInformation.get('batch'));
    }
    
	// @IsTest
	// public static void testGetPricingInformationRemediationWrongGroup()
	// {
	// 	User currentUser = [SELECT Id FROM User WHERE Id =:UserInfo.getUserId()];
	// 	User hostedCatalogTeamUser = [SELECT Id FROM User WHERE LastName = 'hctu'];
	// 	List<Map<String, Object> > aceBatchesPricingInformation = new List<Map<String, Object> >();

	// 	System.runAs(currentUser)
	// 	{
    //         Account acc = [SELECT Id, Name FROM Account WHERE Name = 'moe test account'];
	// 		ACE_Customer_Price_Changes__c cpc1 = new ACE_Customer_Price_Changes__c
	// 											 (
	// 												 Name = remediationTeamBatchName,
	// 												 SRM_Differential__c = 1,
	// 												 Item_12_Month_Qty__c = 1,
	// 												 Total_Spend_Impact_12_Month__c = 1,
    //                                                  Current_Sell_Price__c = 1,
	// 												 Customer__c = acc.id,
    //                                                  Owning_Customer_ID__c = '1',
    //                                                  IsRemediation__c = true
	// 											 );
	// 		insert cpc1;
	// 		ACE_Batches__c batch1 = new ACE_Batches__c
	// 								(
	// 									Name = cpc1.Name,
	// 									Batch__c = cpc1.Name
	// 								);
	// 		insert batch1;
    //     }

	// 	Test.startTest();
	// 	System.runAs(hostedCatalogTeamUser)
	// 	{
	// 		aceBatchesPricingInformation = ACEPricingInformation.getPricingInformationByGroup();
	// 	}
    //     Test.stopTest();
    //     System.assertEquals(0, aceBatchesPricingInformation.size());
	// }
}