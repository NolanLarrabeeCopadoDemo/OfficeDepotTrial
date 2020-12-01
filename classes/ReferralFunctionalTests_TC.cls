/*
 * Functional tests for Referral feature.    
 *
 * @author: Andrew Smith (6/10/2018)
 */ 
 
@isTest
private class ReferralFunctionalTests_TC {
    
    @isTest
    public static void testBSDLeadToTZConvertedOpp(){
		User bsdUser = ReferralTestUtil_TC.createBSDUser();
		User tzUser = ReferralTestUtil_TC.createTZUser();
		Lead srcLead;
		
		System.runAs(bsdUser){
			srcLead = ReferralTestUtil_TC.createLead('BSD');
		}     	
		
		Test.startTest();
		
		Referral__c ref = new Referral__c(); 
		ref.Referred_To__c = 'Tech-Zone';
		ref.Referred_Lead__c = srcLead.Id;
		
		System.runAs(bsdUser){
			insert ref;
		} 

		ref = ReferralTestUtil_TC.getReferral(ref.Id); 

		System.assertEquals(ref.Referred_By__c, 'BSD', 'Referred By is not set to BSD.');
		System.assertEquals(ref.Status__c, 'Working', 'Status is not set to Working.');
		System.assertEquals(ref.Last_Update_Date__c != NULL, TRUE, 'Last Update Date is null.');
		System.assertEquals(ref.Submitted_Date__c != NULL, TRUE, 'Submitted Date is null.');
		
		ReferralTestUtil_TC.validateSrcDestLeadsMatch(ref.Referred_Lead__c, ref.Resulting_Lead__c);	
		ReferralTestUtil_TC.validateReferralRepLeadMatch(ref, ref.Resulting_Lead__c);
		
		//Required to ensure user has access to convert lead (owner may be assigned by other logic)
		Lead ld = new Lead();
		ld.Id = ref.Resulting_Lead__c;
		ld.OwnerId = tzUser.Id;
		update ld;
		
		System.runAs(tzUser){
			Database.LeadConvert lc = new Database.LeadConvert();
			lc.setLeadId(ref.Resulting_Lead__c);
			lc.setConvertedStatus('Converted');
			lc.setDoNotCreateOpportunity(false);
			Database.LeadConvertResult lcr = Database.convertLead(lc);
			System.assert(lcr.isSuccess());
		}  

		Test.stopTest();
		
		ref = ReferralTestUtil_TC.getReferral(ref.Id);
		
		System.assertEquals(ref.Status__c, 'Qualified');
		System.assertEquals(ref.Last_Update_Date__c != NULL, TRUE, 'Last Update Date is null.');
		System.assertEquals(ref.Submitted_Date__c != NULL, TRUE, 'Submitted Date is null.');
		
		ReferralTestUtil_TC.validateReferralDestOppdMatch(ref, ref.Resulting_Opportunity__c);
		ReferralTestUtil_TC.validateReferralRepOppMatch(ref, ref.Resulting_Opportunity__c);
    }
	
	@isTest
	public static void testBSDLeadToTZConvertedNoOpp(){
		User bsdUser = ReferralTestUtil_TC.createBSDUser();
		User tzUser = ReferralTestUtil_TC.createTZUser();
		Lead srcLead;
		
		System.runAs(bsdUser){
			srcLead = ReferralTestUtil_TC.createLead('BSD');
		}     	
		
		Test.startTest();
		
		Referral__c ref = new Referral__c(); 
		ref.Referred_To__c = 'Tech-Zone';
		ref.Referred_Lead__c = srcLead.Id;
		
		System.runAs(bsdUser){
			insert ref;
		} 

		ref = ReferralTestUtil_TC.getReferral(ref.Id); 
		System.assertEquals(ref.Referred_By__c, 'BSD', 'Referred By is not set to BSD.');
		System.assertEquals(ref.Status__c, 'Working', 'Status is not set to Working.');
		System.assertEquals(ref.Last_Update_Date__c != NULL, TRUE, 'Last Update Date is null.');
		System.assertEquals(ref.Submitted_Date__c != NULL, TRUE, 'Submitted Date is null.');
		
		ReferralTestUtil_TC.validateSrcDestLeadsMatch(ref.Referred_Lead__c, ref.Resulting_Lead__c);	
		ReferralTestUtil_TC.validateReferralRepLeadMatch(ref, ref.Resulting_Lead__c);
		
		//Required to ensure user has access to convert lead (owner may have been assigned by other logic)
		Lead ld = new Lead();
		ld.Id = ref.Resulting_Lead__c;
		ld.OwnerId = tzUser.Id;
		update ld;
		
		System.runAs(tzUser){
			Database.LeadConvert lc = new Database.LeadConvert();
			lc.setLeadId(ref.Resulting_Lead__c);
			lc.setConvertedStatus('Converted');
			lc.setDoNotCreateOpportunity(true);
			Database.LeadConvertResult lcr = Database.convertLead(lc);
			System.assert(lcr.isSuccess());
		}  
		
		Test.stopTest();
		
		ref = ReferralTestUtil_TC.getReferral(ref.Id);
		System.assertEquals(ref.Status__c, 'Closed No Action');
	}
	
	@isTest
	public static void testBBLeadToTZConvertedLost(){
		User tzUser = ReferralTestUtil_TC.createTZUser();
		Lead srcLead = ReferralTestUtil_TC.createLead('BizBox');
		     			
		Referral__c ref = new Referral__c(); 
		ref.Referred_To__c = 'Tech-Zone';
		ref.Referred_Lead__c = srcLead.Id;
		insert ref;

		ref = ReferralTestUtil_TC.getReferral(ref.Id); 
		System.assertEquals(ref.Referred_By__c, 'BizBox', 'Referred By is not set to BSD.');
		System.assertEquals(ref.Status__c, 'Working', 'Status is not set to Working.');
		System.assertEquals(ref.Last_Update_Date__c != NULL, TRUE, 'Last Update Date is null.');
		System.assertEquals(ref.Submitted_Date__c != NULL, TRUE, 'Submitted Date is null.');
		
		ReferralTestUtil_TC.validateSrcDestLeadsMatch(ref.Referred_Lead__c, ref.Resulting_Lead__c);	
		ReferralTestUtil_TC.validateReferralRepLeadMatch(ref, ref.Resulting_Lead__c);
		
		//Required to ensure user has access to convert lead (owner may have been assigned by other logic)
		Lead ld = new Lead();
		ld.Id = ref.Resulting_Lead__c;
		ld.OwnerId = tzUser.Id;
		update ld;
		
		Test.startTest();
		
		System.runAs(tzUser){
			Database.LeadConvert lc = new Database.LeadConvert();
			lc.setLeadId(ref.Resulting_Lead__c);
			lc.setConvertedStatus('Converted');
			lc.setDoNotCreateOpportunity(false);
			Database.LeadConvertResult lcr = Database.convertLead(lc);
			System.assert(lcr.isSuccess());
		}  
		
		ref = ReferralTestUtil_TC.getReferral(ref.Id);	
		
		Opportunity opp = new Opportunity();
		opp.Id = ref.Resulting_Opportunity__c;
		opp.StageName = 'Dead - Lost';
		
		System.runAs(tzUser){
			update opp;
		}
		
		Test.stopTest();
		
		ref = ReferralTestUtil_TC.getReferral(ref.Id);	
		System.assertEquals(ref.Status__c, 'Closed Lost');
		ReferralTestUtil_TC.validateReferralRepOppMatch(ref, ref.Resulting_Opportunity__c);
		ReferralTestUtil_TC.validateReferralDestOppdMatch(ref, ref.Resulting_Opportunity__c);
	}	
	
	@isTest
	public static void testBBLeadToBSDNotConvertedUnqualied(){
		User bsdUser = ReferralTestUtil_TC.createBSDUser();
		Lead srcLead = ReferralTestUtil_TC.createLead('BizBox');
		
		Test.startTest(); 
		    			
		Referral__c ref = new Referral__c(); 
		ref.Referred_To__c = 'BSD';
		ref.Referrer_Comments__c = 'This is a comment on the referral';
		ref.Referred_Lead__c = srcLead.Id;
		insert ref;

		ref = ReferralTestUtil_TC.getReferral(ref.Id); 
		System.assertEquals(ref.Referred_By__c, 'BizBox', 'Referred By is not set to BSD.');
		System.assertEquals(ref.Status__c, 'Working', 'Status is not set to Working.');
		System.assertEquals(ref.Last_Update_Date__c != NULL, TRUE, 'Last Update Date is null.');
		System.assertEquals(ref.Submitted_Date__c != NULL, TRUE, 'Submitted Date is null.');
		
		ReferralTestUtil_TC.validateSrcDestLeadsMatch(ref.Referred_Lead__c, ref.Resulting_Lead__c);	
		ReferralTestUtil_TC.validateReferralRepLeadMatch(ref, ref.Resulting_Lead__c);

		//Required to ensure user has access to convert lead (owner may have been assigned by other logic)
		Lead ld = new Lead();
		ld.Id = ref.Resulting_Lead__c;
		ld.OwnerId = bsdUser.Id;
		ld.Status = 'Closed';
		ld.Close_Reason__c = 'Foo';
		ld.Sub_Status__c = 'Unable to Contact';
		ld.Closed_Date__c = System.Today();
		update ld;
		
		Test.stopTest();
		  
		ref = ReferralTestUtil_TC.getReferral(ref.Id);
		System.assertEquals(ref.Status__c, 'Closed No Action');
		System.assertEquals(ref.Loss_No_Action_Reason__c, ld.Close_Reason__c);
	}	
	
	@isTest
    public static void testTZContactToBSD(){
		User bsdUser = ReferralTestUtil_TC.createBSDUser();
		User tzUser = ReferralTestUtil_TC.createTZUser();
		Contact srcContact;
		
		System.runAs(tzUser){
			Account acct = ReferralTestUtil_TC.createAccount();
			srcContact = ReferralTestUtil_TC.createContact('Tech-Zone', acct.Id);
		}     	
		
		Test.startTest();
		
		Referral__c ref = new Referral__c(); 
		
		System.runAs(tzUser){
			ref.Referred_To__c = 'BSD';
			ref.Referred_Contact__c = srcContact.Id;
			insert ref;
		} 
		
		Test.stopTest();

		ref = ReferralTestUtil_TC.getReferral(ref.Id); 
		System.assertEquals(ref.Referred_By__c, 'Tech-Zone', 'Referred By is not set to Tech-Zone.');
		System.assertEquals(ref.Status__c, 'Working', 'Status is not set to Working.');
		System.assertEquals(ref.Last_Update_Date__c != NULL, TRUE, 'Last Update Date is null.');
		System.assertEquals(ref.Submitted_Date__c != NULL, TRUE, 'Submitted Date is null.');
		
		//Must run as tzUser to ensure logic pulls TZ as referrer of Contact.
		System.runAs(tzUser){
			ReferralTestUtil_TC.validateSrcContactDestLeadMatch(ref.Referred_Contact__c, ref.Resulting_Lead__c);
		}	
    }

	@isTest
	public static void testChangingOppOnReferral(){
		User tzUser = ReferralTestUtil_TC.createTZUser();
		Account acct;
		Opportunity opp;
		
		System.runAs(tzUser){
			acct = ReferralTestUtil_TC.createAccount();
			opp = ReferralTestUtil_TC.createOpp(acct.Id);
		}		
		
		Test.startTest();
		
		Referral__c ref = new Referral__c(); 
		ref.Referred_To__c = 'Tech-Zone';
		ref.Status__c = 'Working';
		ReferralUtility.setSubmittedRecordType(new List<Referral__c>{ref});		
		ref.Resulting_Opportunity__c = opp.Id;
		insert ref;

		ref = ReferralTestUtil_TC.getReferral(ref.Id);		
		
		System.assertEquals('Qualified', ref.Status__c);
		System.assertEquals(tzUser.LastName, ref.Rep_Name__c);
		System.assertEquals(tzUser.Phone, ref.Rep_Phone__c);
		System.assertEquals(tzUser.Email, ref.Rep_Email__c);
		System.assertEquals(opp.Amount, ref.Opportunity_Amount__c);
		System.assertEquals(opp.StageName, ref.Opportunity_Stage__c);
		System.assertEquals(opp.CloseDate, ref.Opportunity_Close_Date__c);
		
		Opportunity opp2;
		
		System.runAs(tzUser){
			opp2 = ReferralTestUtil_TC.createOpp(acct.Id);
			opp2.StageName = 'Closed Won';
			opp2.Amount = 555;
			opp2.CloseDate = System.Today();
			update opp2;
		}
	
		ref.Resulting_Opportunity__c = opp2.Id;
		update ref;
		
		Test.stopTest();
		
		ref = ReferralTestUtil_TC.getReferral(ref.Id);		
		
		System.assertEquals('Closed Won', ref.Status__c);
		System.assertEquals(opp2.Amount, ref.Opportunity_Amount__c);
		System.assertEquals(opp2.StageName, ref.Opportunity_Stage__c);
		System.assertEquals(opp2.CloseDate, ref.Opportunity_Close_Date__c);		
	}	
	
	@isTest
	public static void testChangingLeadOnReferral(){
		User tzUser = ReferralTestUtil_TC.createTZUser();
		Lead tzLead1 = ReferralTestUtil_TC.createLead('BSD');
		
		Referral__c ref = new Referral__c(); 
		ref.Referred_To__c = 'Tech-Zone';
		ref.Resulting_Lead__c = tzLead1.Id;
		ref.Status__c = 'Working';
		ReferralUtility.setSubmittedRecordType(new List<Referral__c>{ref});
		insert ref;
		
		Lead tzLead2 = ReferralTestUtil_TC.createLead('Tech-Zone');
		tzLead2.Status = 'Unqualified';
		tzLead2.OwnerId = tzUser.Id;
		update tzLead2;
		
		ref.Resulting_Lead__c = tzLead2.Id;
		update ref;

		ref = ReferralTestUtil_TC.getReferral(ref.Id);		
		tzLead2 = ReferralTestUtil_TC.getLead(tzLead2.Id);
		
		System.assertEquals('Closed No Action', ref.Status__c);
		System.assertEquals(tzLead2.Owner.Name, ref.Rep_Name__c);
		System.assertEquals(tzLead2.Owner.Phone, ref.Rep_Phone__c);
		System.assertEquals(tzLead2.Owner.Email, ref.Rep_Email__c);
	}	
    
}