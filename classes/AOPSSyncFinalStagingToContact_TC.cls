@IsTest
public class AOPSSyncFinalStagingToContact_TC {
    @IsTest
    public static void makeData() {
        Map<String, Contact_Final_Staging__c> stagingRecsMap = new Map<String, Contact_Final_Staging__c>();
        Map<String, Account> accountsMappedByAopsId = new Map<String, Account>();
        List<Contact_Final_Staging__c> finalStagingRec = new List<Contact_Final_Staging__c>{
            new Contact_Final_Staging__c  (Email1_AOPS_Seq__c='663282',Is_Contact_Master_Changed__c=true,Email2_AOPS_Seq__c='154364337',AOPS_Contact_Number__c='111111111' ,AOPS_Account_Number__c='124666',Unique_Record_ID__c='111111111124666',Email2__c='hfhfhf@ii.com',Email2_Type__c='WEM'),
                new Contact_Final_Staging__c   (Is_Contact_Master_Changed__c=true,Email1_AOPS_Seq__c='8475858',Email1__c='',Email1_Type__c='',AOPS_Contact_Number__c='111111112' ,AOPS_Account_Number__c='75638474',Unique_Record_ID__c='11111111275638474'),
                new Contact_Final_Staging__c   (Is_Contact_Master_Changed__c=true,Email1_AOPS_Seq__c='7447498',AOPS_Contact_Number__c='111111113' ,AOPS_Account_Number__c='75759859',Unique_Record_ID__c='11111111375759859')};
                    insert finalStagingRec;
        Account acc = new Account();
        acc.Aops_seq_id__c='124666';
        acc.Name='Realted';
        insert acc;
        
        Account acc1 = new Account();
        acc1.Name='TestAcc';
        acc1.Aops_seq_id__c='124666-111';
        acc1.Related_account__c = acc.Id;
        acc1.Name='Test';
        insert acc1;               
        Account acc2 = new Account();
        acc2.Aops_seq_id__c='75638474';
        acc2.Name='Realted';
        insert acc2;
        
        Account acc3 = new Account();
        acc3.Name='TestAcc3';
        acc3.Aops_seq_id__c='75638474-111';
        acc3.Related_account__c = acc2.Id;
        insert acc3;  
        List<Contact> conLst = new List<Contact> () ;
        contact c = new contact();
		c.AccountId = acc.ID;
		c.LastName = 'Smith';
        c.AOPS_Contact_Number__c = '111111111';
        c.Override_Duplicate_Check__c = true;
		c.Email_1_AOPS_Seq__c='663282';
		c.Title = 'Office Supply Buyer';
		c.Primary_Contact__c = false;
		c.AOPS_Role__c = 'SLS';
		c.Authorized_Buyer__c = 'Y';
		c.Status__c = 'Active';
        conLst.add(c);

        contact c1 = new contact();
        c1.AccountID= acc2.ID;
        c1.AOPS_Contact_number__C = '111111112';
		c1.Override_Duplicate_Check__c = true;
		c1.LastName = 'Davis';
		c1.Title = 'Office Supply Buyer';
		c1.Primary_Contact__c = false;
		c1.AOPS_Role__c = 'SLS';
		c1.Authorized_Buyer__c = 'Y';
		c1.Status__c = 'Active';
        conLst.add(c1);
        insert  conLst;
        for(Contact_Final_Staging__c cfs : finalStagingRec) {
            stagingRecsMap.put(cfs.AOPS_Contact_Number__c,cfs);  
        }
        Set<String> aopsIds = new Set<String>();
        for(Contact_Final_Staging__c stagingRecs : finalStagingRec) {
            aopsIds.add(stagingRecs.AOPS_Account_Number__c);
            
        }
        system.debug('the aopsids are:'+aopsIds);
        List<Account> accts = [SELECT Id, AOPS_Cust_ID__c, OwnerId FROM Account WHERE AOPS_Cust_ID__c IN: aopsIds];
        for(Account acct : accts) {
            accountsMappedByAopsId.put(acct.AOPS_Cust_ID__c, acct);
        }
                system.debug('the accountsMappedByAopsId are:'+accountsMappedByAopsId);

        test.startTest();
        AOPSSyncFinalStagingToContact asfc = new AOPSSyncFinalStagingToContact(finalStagingRec);
        test.stopTest();
	}
	
	 @istest
	 public static void PhoneFields() {

		Map<String, Account> accountsMappedByAopsId = new Map<String, Account>();
		Map<String, Contact_Final_Staging__c> stagingRecsMap = new Map<String, Contact_Final_Staging__c>();

		List<Contact_Final_Staging__c> NewFinalStagingRec = new List<Contact_Final_Staging__c> {
			new Contact_Final_Staging__c (AOPS_Contact_Number__c = '11112325', AOPS_Account_Number__c = '55455241', Fax__c = '5475521478', Phone1_AOPS_Seq__c = '5214478569', Phone1__c= '20014049', Phone_EXT__c = '200', Phone1_Type__c = 'Work', Default_Phone1__c = 'Y', Unique_Record_ID__c='111111111124777'),
			new Contact_Final_Staging__c (AOPS_Contact_Number__c = '11112328', AOPS_Account_Number__c = '55455242', Fax__c = '5475521477', Phone1_AOPS_Seq__c = '5214478567', Phone1__c= '20014041', Phone_EXT__c = '201', Phone1_Type__c = 'Work', Default_Phone1__c = 'N', Unique_Record_ID__c='111111111124888')};
			insert NewFinalStagingRec;
		
		
		Account acc4 = new Account();
        acc4.Aops_cust_id__c='124666';
        acc4.Name='Google';
		insert acc4;
		
		Contact c4 = new Contact();
		c4.AccountID = acc4.Id;
		c4.AOPS_Contact_number__C = '111111112';
		c4.LastName = 'Davis';
		insert c4;


		for(Contact_Final_Staging__c cfs : NewFinalStagingRec) {
            stagingRecsMap.put(cfs.AOPS_Contact_Number__c,cfs);  
        }
        Set<String> aopsIds = new Set<String>();
        for(Contact_Final_Staging__c stagingRecs : NewFinalStagingRec) {
            aopsIds.add(stagingRecs.AOPS_Account_Number__c);
            
        }
        system.debug('the aopsids are:'+aopsIds);
        List<Account> accts = [SELECT Id, AOPS_Cust_ID__c, OwnerId FROM Account WHERE AOPS_Cust_ID__c IN: aopsIds];
        for(Account acct : accts) {
            accountsMappedByAopsId.put(acct.AOPS_Cust_ID__c, acct);
        }

		
		test.startTest();
		AOPSSyncFinalStagingToContact asfc = new AOPSSyncFinalStagingToContact(NewFinalStagingRec);
		asfc.setPhoneFields(c4,NewFinalStagingRec.get(0));
        test.stopTest();
		}

		@istest
		public static void EmailFields() {
		
			Map<String, Account> accountsMappedByAopsId = new Map<String, Account>();
			Map<String, Contact_Final_Staging__c> stagingRecsMap = new Map<String, Contact_Final_Staging__c>();

			List<Contact_Final_Staging__c> NewEmailFinalStagingRec = new List<Contact_Final_Staging__c> {
				new Contact_Final_Staging__c (AOPS_Contact_Number__c = '11112325', AOPS_Account_Number__c = '55455241', Email1_AOPS_Seq__c = '2001218896', Email1__c = 'test@officedepot.com', Email1_Type__c = 'WEM', Default_Email1__c = 'Y', Unique_Record_ID__c='111111111124111'),
				new Contact_Final_Staging__c (AOPS_Contact_Number__c = '11112325', AOPS_Account_Number__c = '55455241', Email1_AOPS_Seq__c = '2001218897', Email1__c = 'noreply@officedepot.com', Email1_Type__c = 'WEM', Default_Email1__c = 'N', Unique_Record_ID__c='111111111124555')};
				insert NewEmailFinalStagingRec;


				Account acc5 = new Account();
				acc5.Aops_cust_id__c='124666';
				acc5.Name='Google';
				insert acc5;
				
				Contact c5 = new Contact();
				c5.AccountID = acc5.Id;
				c5.AOPS_Contact_number__C = '111111112';
				c5.LastName = 'Davis';
				insert c5;
		
		
				for(Contact_Final_Staging__c cfs : NewEmailFinalStagingRec) {
					stagingRecsMap.put(cfs.AOPS_Contact_Number__c,cfs);  
				}
				Set<String> aopsIds = new Set<String>();
				for(Contact_Final_Staging__c stagingRecs : NewEmailFinalStagingRec) {
					aopsIds.add(stagingRecs.AOPS_Account_Number__c);					
				}
				system.debug('the aopsids are:'+aopsIds);
				List<Account> accts = [SELECT Id, AOPS_Cust_ID__c, OwnerId FROM Account WHERE AOPS_Cust_ID__c IN: aopsIds];
				for(Account acct : accts) {
					accountsMappedByAopsId.put(acct.AOPS_Cust_ID__c, acct);
				}

		test.startTest();
		AOPSSyncFinalStagingToContact asfc = new AOPSSyncFinalStagingToContact(NewEmailFinalStagingRec);
		asfc.setEmailFields(c5,NewEmailFinalStagingRec.get(0));
        test.stopTest();
		}

		@istest
		public static void OptInFields() {
		
			Map<String, Account> accountsMappedByAopsId = new Map<String, Account>();
			Map<String, Contact_Final_Staging__c> stagingRecsMap = new Map<String, Contact_Final_Staging__c>();

			List<Contact_Final_Staging__c> NewOptInFinalStagingRec = new List<Contact_Final_Staging__c> {
				new Contact_Final_Staging__c (AOPS_Contact_Number__c = '11112321', AOPS_Account_Number__c = '55455242', Unique_Record_ID__c='111111111124333', P_OptIn1__c = 'Y', P_OptIn2__c = 'N', P_OptIn3__c = 'Y', E_OptIn1__c = 'Y', E_OptIn2__c = 'Y', E_OptIn3__c = 'Y', Mail_OptIn__c = 'N'),
				new Contact_Final_Staging__c (AOPS_Contact_Number__c = '11112325', AOPS_Account_Number__c = '55455241', Unique_Record_ID__c='111111111124111', P_OptIn1__c = 'Y', P_OptIn2__c = 'N', P_OptIn3__c = 'N', E_OptIn1__c = 'Y', E_OptIn2__c = 'Y', E_OptIn3__c = 'Y', Mail_OptIn__c = 'N')};
				insert NewOptInFinalStagingRec;


				Account acc6 = new Account();
				acc6.Aops_cust_id__c='124666';
				acc6.Name='Google';
				insert acc6;
				
				Contact c6 = new Contact();
				c6.AccountID = acc6.Id;
				c6.AOPS_Contact_number__C = '111111112';
				c6.LastName = 'Davis';
				insert c6;
		
		
				for(Contact_Final_Staging__c cfs : NewOptInFinalStagingRec) {
					stagingRecsMap.put(cfs.AOPS_Contact_Number__c,cfs);  
				}
				Set<String> aopsIds = new Set<String>();
				for(Contact_Final_Staging__c stagingRecs : NewOptInFinalStagingRec) {
					aopsIds.add(stagingRecs.AOPS_Account_Number__c);					
				}
				system.debug('the aopsids are:'+aopsIds);
				List<Account> accts = [SELECT Id, AOPS_Cust_ID__c, OwnerId FROM Account WHERE AOPS_Cust_ID__c IN: aopsIds];
				for(Account acct : accts) {
					accountsMappedByAopsId.put(acct.AOPS_Cust_ID__c, acct);
				}

		test.startTest();
		AOPSSyncFinalStagingToContact asfc = new AOPSSyncFinalStagingToContact(NewOptInFinalStagingRec);
		asfc.setOptInFields(c6,NewOptInFinalStagingRec.get(0));
        test.stopTest();
		}

		@istest
		public static void WebuserFields() {
		
			Map<String, Account> accountsMappedByAopsId = new Map<String, Account>();
			Map<String, Contact_Final_Staging__c> stagingRecsMap = new Map<String, Contact_Final_Staging__c>();

			List<Contact_Final_Staging__c> NewWebUserFinalStagingRec = new List<Contact_Final_Staging__c> {
				new Contact_Final_Staging__c (AOPS_Contact_Number__c = '11112327', AOPS_Account_Number__c = '55455249', Unique_Record_ID__c='111111111124000', Web_User_Acct_Code__c = 'AV', Acct_Code_Value__c = '00', Web_Username__c = '01665941-CXML', Web_User_Seq__c = '72546228', User_Type__c = 'S', AB_Flag__c = '1', Default_Postal_Code__c = '836425995', Last_Website_Visit__c = System.now(), Legacy_CreatedDate__c = System.now()),
				new Contact_Final_Staging__c (AOPS_Contact_Number__c = '11112325', AOPS_Account_Number__c = '55455241', Unique_Record_ID__c='111111111124111', Web_User_Acct_Code__c = 'AV', Acct_Code_Value__c = '00', Web_Username__c = '01665943-CXML', Web_User_Seq__c = '72546224', User_Type__c = 'S', AB_Flag__c = '1')};
				insert NewWebUserFinalStagingRec;


				Account acc7 = new Account();
				acc7.Aops_cust_id__c='124666';
				acc7.Name='Google';
				insert acc7;
				
				Contact c7 = new Contact();
				c7.AccountID = acc7.Id;
				c7.AOPS_Contact_number__C = '111111112';
				c7.LastName = 'Davis';
				insert c7;
		
		
				for(Contact_Final_Staging__c cfs : NewWebUserFinalStagingRec) {
					stagingRecsMap.put(cfs.AOPS_Contact_Number__c,cfs);  
				}
				Set<String> aopsIds = new Set<String>();
				for(Contact_Final_Staging__c stagingRecs : NewWebUserFinalStagingRec) {
					aopsIds.add(stagingRecs.AOPS_Account_Number__c);					
				}
				system.debug('the aopsids are:'+aopsIds);
				List<Account> accts = [SELECT Id, AOPS_Cust_ID__c, OwnerId FROM Account WHERE AOPS_Cust_ID__c IN: aopsIds];
				for(Account acct : accts) {
					accountsMappedByAopsId.put(acct.AOPS_Cust_ID__c, acct);
				}

		test.startTest();
		AOPSSyncFinalStagingToContact asfc = new AOPSSyncFinalStagingToContact(NewWebUserFinalStagingRec);
		asfc.setWebUserFields(c7,NewWebUserFinalStagingRec.get(0));
        test.stopTest();
		}

		@istest
		public static void OptInInfoSetup() {
			//test.startTest();
			Account a = new Account();
			a.aops_cust_id__c = '01234567';
			a.name = 'Apple Inc';
			insert a;

			Account a1 = new Account();
			a1.aops_cust_id__c = '01234568';
			a1.name = 'Microsoft';
			insert a1;
			// List<Contact> cl = new List<Contact> {
			// 	new Contact (AccountID = a.ID, LastName = 'Smith', AOPS_Contact_number__C = '111111115'),
			// 	new Contact (AccountID = a1.ID, LastName = 'James', AOPS_Contact_number__C = '111111116')};
			// 	insert cl;
			Contact c7 = new Contact();
			c7.AccountID = a.Id;
			c7.AOPS_Contact_number__C = '111111112';
			c7.LastName = 'Davis';
			insert c7;	

			AOPSContactOptInOut__c acp = new AOPSContactOptInOut__c();
			acp.Contact_ID__c = c7.Id;
			acp.Email_1_Opt_Date__c = System.now();
			acp.Email_2_Opt_Date__c = System.now();
			acp.Email_3_Opt_Date__c = System.now();
			acp.Email_1_OptIn_AOPS__c = 'N';
			acp.Email_2_OptIn_AOPS__c = 'N';
			acp.Email_3_OptIn_AOPS__c = 'N';
			acp.Phone_1_Opt_Date__c = System.now();
			acp.Phone_2_Opt_Date__c = System.now();
			acp.Phone_3_Opt_Date__c = System.now();
			acp.Phone_1_OptIn_AOPS__c = 'Y';
			acp.Phone_2_OptIn_AOPS__c = 'Y';
			acp.Phone_3_OptIn_AOPS__c = 'Y';
			acp.Mobile_1_Opt_Date__c = System.now();
			acp.Mobile_2_Opt_Date__c = System.now();
			acp.Mobile_3_Opt_Date__c = System.now();
			acp.Mail_Opt_Date__c = System.now();
			acp.Mail_OptIn_AOPS__c = 'Y';
			acp.M_OptIn1__c = 'Y';
			acp.M_OptIn2__c = 'Y';
			acp.M_OptIn3__c = 'Y';
			//insert acp;
		
		 test.startTest();
		// AOPSSyncFinalStagingToContact asfc = new AOPSSyncFinalStagingToContact(AOPSContactOptInOut__c acp);
		// asfc.OptInInfoSetup(acp);
		insert acp;
        test.stopTest();
		}

	}