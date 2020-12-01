/**@@
#CLASS NAME  :  AccountTriggerHelper(Related classes: AccountTriggerHandler, AccountTriggerHelper, PrimaryAccountTrigger_Test)
#DESCRIPTION :  Modified by Rajendra Shahane for ticket 02831114 - Account triggers conversion to Lightning
#MODIFIEDDDATE :  22-05-2020 (DD-MM-YYYY)
   @@**/
public class AccountTriggerHelper
{
	/*
	   1) If current recordtype of account is 'Site (GT)' and is modified to 'Customer (GT)' then following fields on acount are set to blank(null):
	   Related Account, Primary Contact,Site Contact2,Site Contact3,Site Contact4,Site Contact5,Site Contact6" Note:The logic is no more needed

	   2) If current recordtype of account is 'Site (GT)' and Realted Account is modified then
	    2a) If Related Account is not same as the Primary Contact Account then Primary Contact for current Account is set to blank(null)
	    2b) If Related Account is not same as the Site Contact2 Account then Site Contact2 for current Account is set to blank(null)
	    2c) If Related Account is not same as the Site Contact3 Account then Site Contact3 for current Account is set to blank(null)
	    2d) If Related Account is not same as the Site Contact4 Account then Site Contact4 for current Account is set to blank(null)
	    2e) If Related Account is not same as the Site Contact5 Account then Site Contact5 for current Account is set to blank(null)
	    2f) If Related Account is not same as the Site Contact6 Account then Site Contact6 for current Account is set to blank(null)

	   3) If current recordtype of account is 'Prospect (GT)' and Account Owner is modified then the Sales Person ID for account is
	   updated with the new Owners Sales Person ID
	 */
	public static void setGTSoldToChange(List<Account> newAccountList, Map<Id, Account> newAccountMap, Map<Id, Account> oldAccountMap)
	{
		List<Id> accId = new List<Id>();
		Set<Id> accSet = new Set<Id>(); // case-00719296

		for ( Account acc: newAccountList)
		{
			/* The below logic is no more needed
			   if(oldAccountMap.get(acc.ID).recordtypeId ==Label.Site_GT_Record_Type  && acc.recordtypeId==Label.Customer_GT_Record_Type)
			   {
			    acc.Related_Account__c=null;
			    acc.Site_Primary_Contact__c=null;
			    acc.Site_Contact2__c=null;
			    acc.Site_Contact3__c=null;
			    acc.Site_Contact4__c=null;
			    acc.Site_Contact5__c=null;
			    acc.Site_Contact6__c=null;
			   }*/
			if (acc.recordtypeId==Label.Site_GT_Record_Type)
			{
				if (oldAccountMap.get(acc.ID).Related_Account__c != newAccountMap.get(acc.ID).Related_Account__c )
				{
					accId.add(acc.Id);
				}
			}
			//Start-00719296
			if (acc.recordtypeid==Label.GT_Prospect && acc.OwnerId != oldAccountMap.get(acc.Id).OwnerId)
				accset.add(acc.OwnerId);
		}

		List<Sales_Person__c> splist = new List<Sales_Person__c> ();
		Map<id, Sales_Person__c> spMap = new Map<id, Sales_Person__c>();

		if (accset.size()>0)
		{
			splist = [select id, User__c, IsActive__c, Name, primary__c from Sales_Person__c where
					  User__c IN:accset and primary__c = true and IsActive__c = true];
			for (Sales_person__c sp : splist)
			{
				spmap.put(sp.user__c, sp);

			}
		}
		// End-00719296
		if (accId!= null && accId.size()>0)
		{
			Map<ID, Account> accUpdate = new Map<ID, Account>([SELECT Id, Site_Primary_Contact__r.accountId,
															   Site_Contact2__r.accountId, Site_Contact3__r.accountId, Site_Contact4__r.accountId,
															   Site_Contact5__r.accountId, Site_Contact6__r.accountId
															   FROM Account where id in: accId]);

			for ( Account acc: newAccountList)
			{
				if (acc.recordtypeId==Label.Site_GT_Record_Type)
				{
					if (oldAccountMap.get(acc.ID).Related_Account__c != newAccountMap.get(acc.ID).Related_Account__c )
					{
						if (acc.Related_Account__c!=accUpdate.get(acc.Id).Site_Primary_Contact__r.accountId)
							acc.Site_Primary_Contact__c = null;
						if (acc.Related_Account__c!=accUpdate.get(acc.Id).Site_Contact2__r.accountId)
							acc.Site_Contact2__c = null;
						if (acc.Related_Account__c!=accUpdate.get(acc.Id).Site_Contact3__r.accountId)
							acc.Site_Contact3__c = null;
						if (acc.Related_Account__c!=accUpdate.get(acc.Id).Site_Contact4__r.accountId)
							acc.Site_Contact4__c = null;
						if (acc.Related_Account__c!=accUpdate.get(acc.Id).Site_Contact5__r.accountId)
							acc.Site_Contact5__c = null;
						if (acc.Related_Account__c!=accUpdate.get(acc.Id).Site_Contact6__r.accountId)
							acc.Site_Contact6__c = null;
					}
				}
			}
		}
		//Start-00719296
		for (Account acc: newAccountList )
		{
			if (acc.recordtypeid==Label.GT_Prospect && acc.OwnerId != oldAccountMap.get(acc.Id).OwnerId)
			{
				if (spmap.get(acc.Ownerid)!=null)
				{
					acc.Sales_PersonID__c = spmap.get(acc.Ownerid).id;
				}
				else
				{
					acc.Sales_PersonID__c = null;
				}
			}
		}
		// End-00719296
	}

	/*
	   When Account record is inserted/created and its Primary_Site__c checkbox is checked and Related Account is set to a value then the
	   Related Account's Primary Site ID value is set to the current(being created) account id.
	 */
	public static void setRelatedAccountPrimarySiteID(List<Account> newAccountList)
	{
		List<Account> updateAccount = new List<Account>();
		Map<Id, Id> mapSite = new  Map<Id, Id>();
		Set<Id> accId = new  Set<Id>();

		for (Account acc: newAccountList)
		{
			if (acc.Primary_Site__c ==true && acc.Related_Account__c  !=null)
			{
				mapSite.put(acc.Related_Account__c, acc.Id);
				if (!accId.contains(acc.Related_Account__c))
					accId.add(acc.Related_Account__c);
			}
		}
		for (Id accNew:  accId)
		{
			Account newAcc = new account();
			newAcc.Id = accNew;
			newAcc.Primary_Site_ID__c = mapSite.get(accNew);
			updateAccount.add(newAcc);
		}

		if (updateAccount.size()>0)
			update updateAccount;
	}

	/*
	   When the current account is updated and the 'AOPS Id' is modified with new value then the 'CUSTOMER ID' value on related 'DML Relationship'
	    object record is set to current accounts AOPS Id.
	 */
	public static void updateDMLRelationshipAOPSId(List<Account> newAccountList, Map <Id, Account> newAccountMap, Map <Id, Account> oldAccountMap)
	{
		List<DML_Relation__c>  DMLRList = new List<DML_Relation__c>();
		Map<Id, Account> AccId = new Map<Id, Account>();
		for (Account recid:newAccountList)
		{
			if ((oldAccountMap.get(recid.Id).Aops_cust_id__c != newAccountMap.get(recid.Id).Aops_cust_id__C) && newAccountMap.get(recid.Id).Aops_cust_id__C!=null)
				AccId.put(recid.Id, recid);
		}
		if (!AccId.isEmpty())
		{
			for (DML_Relation__c dr : [select id, CUSTOMERID__c, Account__c from DML_Relation__c where Account__C =:AccId.keyset()])
			{
				dr.CUSTOMERID__c = AccId.get(dr.Account__c).AOPS_Cust_Id__c;
				DMLRList.add(dr);
			}
			if (DMLRList.size()>0)
				update DMLRList;
		}
	}

	/*
	   When current account's record type is updated from 'Account Setup Requested GT' to 'Customer (GT)' then all the Primary Contacts(Contact.Primary = true)
	    under the current account are deleted.
	 */
	public static void deletePrimaryContactsForAccountSetupReqGT(List<Account> newAccountList, Map <Id, Account> newAccountMap, Map <Id, Account> oldAccountMap)
	{
		String currentUserId = UserInfo.getUserId().substring(0, 15);
		boolean currentUserIsDL = false;

		List<Dataloader_User__c> dataloaderUsers = Dataloader_User__c.getall().values();
		for (Dataloader_User__c dlu : dataloaderUsers)
		{
			if (currentUserId == dlu.User_ID__c)
			{
				currentUserIsDL = true;
			}
		}

		// Execute trigger once
		if (executeoncetest.notTriggered_GT_DeleteContacts_after || currentUserIsDL)
		{
			//executeoncetest.notTriggered_GT_DeleteContacts_after = false;
			List<Id> accountId = new List<Id>();
			List<contact> contactId = new List<contact> ();
			List<contact> updatecontactId = new List<contact> ();

			for (Account accounts: newAccountList)
			{

				if (  (oldAccountMap.get(accounts.Id).recordtypeId!= newAccountMap.get(accounts.Id).recordtypeId) &&
				      // old recordtype is account set up requested
					  oldAccountMap.get(accounts.Id).recordtypeId==Label.Account_Setup_Record_Type &&
				      // new recordtype is Customer GT
					  newAccountMap.get(accounts.Id).recordtypeId ==Label.Customer_GT_Record_Type
					  )
				{
					accountId.add( accounts.Id);
				}
			}
			// get the primary contacts associated for deletion
			if (accountId!=null && accountId.size()>0)
			{
				contactId = [Select Id from contact where AccountId in:accountId and Primary_Contact__c = true];
			}
			if (contactId.size()>0)
				delete contactId;
			// get the other contacts associated for dummy update
			if (accountId!=null && accountId.size()>0)
			{
				updatecontactId = [Select Id from contact where AccountId in:accountId and Primary_Contact__c = false];
			}
			if (updatecontactId.size()>0)
				update updatecontactId;
		}
	}

	/*
	   If current account recordtype is 'Customer (Business Pro)' then a 'Business Pro Owner History' record is created for the current account.
	 */
	public static void createBusinessProOwnerHistory(List<Account> newAccountList)
	{
		Recordtype rtype = [select id from recordtype where sobjecttype = 'Account' and recordtype.name = 'Customer (Business Pro)' limit 1];
		list<business_pro_owner__c> bproUpd = new list<business_pro_owner__c>();
		for (account a:newAccountList)
		{
			if (a.recordtypeid == rtype.id)
			{
				business_pro_owner__c bo = new business_pro_owner__c();
				bo.account__c = a.id;
				bo.BusinessPro__c = a.ownerid;
				bo.start_date__c = system.today();
				bo.iscurrent__c = true;
				bproUpd.add(bo);
			}
		}
		if (bproUpd.size() > 0)
		{
			list<database.SaveResult> sr = database.insert(bproUpd, false);
		}
	}

	/*
	   If for current account the field 'Org/Company' is modified to a new value then the field 'OrgChildUpdate' is set to TRUE(checked)
	 */
	public static void setOrgChildUpdate(List<Account> newAccountList, Map <Id, Account> oldAccountMap)
	{
		// If there is an Org change update checkbox to true to get triggered by batch class
		for (Account rec : newAccountList)
		{
			if (rec.Org__C  !=null && (rec.Org__C != oldAccountMap.get(rec.id).org__C))
				rec.OrgChildUpdate__C = true;
		}
	}

	/*
	   If current account record type is 'Great Grandparent' or 'GrandParent' then accounts Owner is set to Sales Person User
	 */
	Public Static void updateGPorGGPOwnerOnInsert(List<Account> newAccountList)
	{
		Id GGPRTId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Great Grandparent').getRecordTypeId();
		Id GPRTId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('GrandParent').getRecordTypeId();
		Set<Id> salesPersonIds = new Set<Id>();
		for (Account acc : newAccountList)
		{
			if (acc.RecordTypeId==GGPRTId || acc.RecordTypeId==GPRTId )
				salesPersonIds.add(acc.Sales_PersonID__c);
		}

		if (!salesPersonIds.isEmpty())
		{
			Map<Id, Sales_Person__c> mSPids = New Map<Id, Sales_Person__c>([Select id, User__c from Sales_Person__c where id in : salesPersonIds]);
			for (Account acc : newAccountList)
			{

				if (mSPids.containsKey(acc.Sales_PersonID__c))
				{
					acc.OwnerId = mSPids.get(acc.Sales_PersonID__c).User__c;
				}
			}
		}
	}

	/*
	   1) Id account recordtype is 'Parent' and 'Oracle Party ID' is modified by seting a value then a 'Account Setup Request' record is
	   created with current account Primary Contact and Primary Site Related Account for current account.
	 */
	public static void createAccountSetupOnUpdate(list<Account> newAccountList, map<id, account> oldAccountMap)
	{
		Id Parent_RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Parent').getRecordTypeId();
		Set<Id>  Accids = New Set<Id>();
		Map<Id, Account>  mAccounts = New Map<Id, Account>();
		for (Account ac: newAccountList)
		{
			if (ac.Recordtypeid==Parent_RecordTypeId
				&& ac.ORACLE_PARTY_ID__c!=null
				&& ac.ORACLE_PARTY_ID__c != oldAccountMap.get(ac.id).ORACLE_PARTY_ID__c)
			{
				mAccounts.put(Ac.id, Ac);
			}
		}

		if (!mAccounts.isEmpty())
		{
			Map<Id, Account> mAccPrimarySiteid = New Map<Id, Account>();
			List<Account_Setup_Request__c> ASRlist = New List<Account_Setup_Request__c>();
			Map<Id, Contact>  mContacts = New Map<Id, Contact>();

			for (Contact Con:[Select Id, FirstName, LastName, Email, Phone, Role__c, Accountid FROM Contact Where Accountid =:mAccounts.Keyset() and Primary_Contact__c = true])
			{
				mContacts.put(Con.AccountId, Con);
				Con.Created_With_Account_Setup__c = true;
				update Con;
			}

			for (Account AccSite:[SELECT Id, Related_Account__c, Oracle_Party_Site_ID__c FROM Account WHERE Primary_Site__c = true and Related_Account__c =:mAccounts.keyset()])
			{
				mAccPrimarySiteid.put(AccSite.Related_Account__c, AccSite);
			}

			for (Account A:mAccounts.values())
			{
				ASRlist.add(accountsetuprecord(A, mAccPrimarySiteid.get(A.id).Id, mAccPrimarySiteid.get(A.id).Oracle_Party_Site_ID__c, mContacts.get(A.Id)));
            }
            
			insert ASRlist;
		}
	}

	public static Account_Setup_Request__c accountsetuprecord(Account ac, Id AccSiteId, String oraclePartysite, Contact cont)
	{
		Account_Setup_Request__c ASR = New Account_Setup_Request__c();
		ASR.Account__C = ac.Id;
		ASR.Street_Address_Bill__c = ac.Address1__c;
		ASR.Street_Address_2_Bill__c = ac.Address2__c;
		ASR.State_Bill__c = ac.State__c;
		ASR.BILL_COUNTRY__c = ac.Country__c;
		ASR.Zip_Bill__c = ac.Zip__c;
		ASR.City_Bill__c = ac.City__c;
		ASR.Survey_Complete__c = true;
		ASR.BillTo_Name__c = ac.name;
		ASR.ShipTo_Name__c = ac.name;

		ASR.AUTO_BACK_FAX_OR_EMAIL_ADDR__c = '9999999999';
		ASR.AUTO_BACK_FAX_EMAIL__c = 'F';
		ASR.Back_Orders_Flag__c = 'Y';
		ASR.Billing_Delivery_Method_Media_type__c = 'PRINT';
		ASR.Ultimate_Duns_Number__c = '0';
		ASR.Loyalty_Type__c = 'RG';
		ASR.Display_Payment_Method__c = 'N';
		ASR.Display_Prices__c = 'N';
		ASR.Duns_Number__c = '0';
		ASR.Y_N_exclude_Alternate_Sourcing__c = 'N';
		ASR.Y_N_exclude_Vendor_Drop_Ship__c = 'N';
		ASR.GP_Floor__c = '0';
		ASR.INV_NUM_OF_COPIES__c = 1;
		ASR.Minimum_Order_Value__c = 0;
		ASR.Off_Contract_percent__c = '0';
		ASR.Off_Contract__c = 'R';
		ASR.Off_Wholesale_percent__c = '0';
		ASR.Off_Wholesale__c = 'L';
		ASR.Max_Order_Amount__c = 1;
		ASR.PARENT_CODE__c = 'P';
		ASR.Add_Parent_ID__c = '0';
		ASR.Invoice_Payment_Method__c = 'Credit Card';
		ASR.PO__c = 'H';
		ASR.Rename_Cost_Center__c = '';
		ASR.Rename_desktop__C = '';
		ASR.Rename_purchase_order__c = '';
		ASR.Cost_Center__c = 'H';
		ASR.Desktop__c = 'H';
		ASR.PO__c = 'H';

		ASR.Rename_release__c = '';

		ASR.PD_Detail__c = 'Y';
		ASR.Price_Plan__c = '7200000-300';
		ASR.PROMO_FLAG_EMAIL__c = 'Y';
		ASR.PROMO_FLAG_FLYER__c = 'Y';
		ASR.PROMO_FLAG_PHONE__c = 'Y';
		ASR.PROSPECT_SOURCE__c = 'SFDC';
		ASR.Release__c = 'H';
		ASR.Rep_ID__c = ac.Sales_Person_ExtID__c;
		ASR.Revenue_Band__c = 'STANDARD';
		ASR.PD_Doc_Name__c = 'Standard Invoice';
		//ASR.Primary_Contact_Fax__c='0';
		// ASR.Primary_Contact_Mobile_Phone__c='0';
		ASR.PD_Incl_Backup_Inc__c = 'N';
		ASR.Billing_Frequency__c = 'Weekly';
		ASR.SHIP_COUNTRY__c = 'USA';
		ASR.Small_Order_Fee_Flag__c = 'N';
		ASR.TAX_EXCEPTION_FLAG__c = 'N';
		ASR.Cross_Reference_number__c = '0';
		ASR.Fax_Order_Flag__c = 'Y';
		ASR.Backorders_displayed_on_packing_list__c = 'Y';
		ASR.Display_Purchase_Orders__c = 'Y';
		ASR.Tax_Exempt__c = 'N';
		ASR.Print_invoice__c = 'Y';
		ASR.Rename_Packlist__c = '';
		ASR.SHIPTO_ORACLE_PARTY_SITE_ID__c = oraclePartysite;
		ASR.City_Ship__c = ac.City__c;
		ASR.State_Ship__c = ac.State__c;
		ASR.Zip_Ship__c = ac.Zip__c;
		ASR.SHIP_COUNTRY__c = ac.Country__c;
		ASR.Street_Address_Ship__c = ac.Address1__c;
		ASR.SFDC_SHIPTO_ID__c = AccSiteId;
		asr.ORACLE_PARTY_ID__c = ac.Oracle_Party_ID__c;
		asr.Parent_Creation__C = true;
		//asr.Account_Phone__c=Ac.Phone;
		asr.Primary_Contact_Phone__c = cont.phone;
		asr.Primary_Contact_Mobile_Phone__c = cont.phone;
		asr.Primary_Contact_First_Name__c = cont.firstname;
		asr.Primary_Contact_Last_Name__c = cont.LastName;
		asr.Primary_Contact_Email__c = cont.Email; //'test@officedepot.com';
		asr.Primary_contact_role__c = 'SALES';
		//cont.Role__c;
		asr.Report_Loc__c = '';

		asr.OPERATION__c = 'E';

		Return ASR;

	}

	/*
	   1) If the account recordtype is 'Parent' OR 'GrandParent' OR 'Great Grandparent' then 'DML' record is created for current Account and
	   'Related DML' field is updated with created DML record id. And a case of recordtype 'Deployment Request' is created for the current account
	   and newly created DML record.
	 */
	public static void createDMLRelationship(List<Account> newAccountList)
	{
		List<DML__C> dmlList = new List<DML__C>();
		List<DML_Relation__c> dmlRelList = new List<DML_Relation__c>();
		List<Case> caseList = new List<Case>();
		List<Account> accupList = new List<Account>();
		Map<id, DML__C> accDmlMap = new Map<id, DML__C>();
        
        for (Account a:newAccountList)
		{
			Id PrentId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Parent').getRecordTypeId();
			Id GPrentId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('GrandParent').getRecordTypeId();
			Id GGPrentId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Great Grandparent').getRecordTypeId();
            
            if (a.recordtypeId==PrentId || a.recordtypeId==GPrentId || a.recordtypeId==GGPrentId )
			{
				DML__C dmlrec = new DML__C();
				dmlrec.DML_City__c = a.City__c;
				dmlrec.DML_State__c = a.State__c;
				dmlrec.DECISION_MAKER_ZIP_CD__c = a.Zip__c;
				dmlrec.DECISION_MAKER_SEGMENT__c = a.Segment__c;
				dmlrec.DECISION_MAKER_NM__c = a.Name;
				dmlrec.Status__c = 'Draft';
				dmlrec.Effective_Start_Date__c = Date.today();
				//dmlrec.Reason_for_Creation__c='';
				dmlList.add(dmlrec);
				accDmlMap.put(a.id, dmlrec);

			}
		}
		if (dmlList != null && dmlList.Size() >0)
			insert dmlList;

		List<Account> acc = [Select id, name, Related_DML__C, Related_DML__r.Id from Account where id in:accDmlMap.keySet()];
		if (acc != null && acc.Size() >0)
		{
			for (Account a:acc)
			{
				a.Related_DML__C = accDmlMap.get(a.Id).Id;
				accupList.add(a);
			}
		}
		if (accupList != null && accupList.Size() >0)
		{
			update accupList;
			Id DR_RecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Deployment Request').getRecordTypeId();
            
            for (Account a:accupList)
			{
				Case newCase = new Case();
				newCase.accountId = a.Id;
				newCase.Support_Type__c = 'Deployment';
				newCase.Support_Sub_Type__c = 'New DML Exception';
				newCase.subject = a.Name;
				newCase.RecordTypeId = DR_RecordTypeId;
				DML__c d = accDmlMap.get(a.Id);
				//newCase.Comments = newDMLRecord.Notes__c;
				//newCase.Description = 'Account Name :' + ' ' + a.Name + '\n' + 'Request Type: New DML Exception' + '\n' + 'Reason For DML Creation:' + ' ' + a.Related_DML__r.Reason_for_Creation__c + '\n' + 'Please check the DML by clicking this link:' + '  ' + System.Label.DML_Link + a.Related_DML__r.id;
				newCase.Description = 'Account Name :' + ' ' + a.Name + '\n' + 'Request Type: New DML Exception' + '\n' + 'Please check the DML by clicking this link:' + '  ' + System.Label.DML_Link + d.Id;
				caseList.add(newCase);
			}
            
            insert caseList;
		}
	}

	/*
	   1) If current account Account Source is 'BSD Auto Account Setup' and 'DNBI Credit Outcome' is modified to 'Approved' and
	   Primary Site , Potential Duplicate fields set to FALSE then 'Account Setup Request' record for current account is created.
	   For current Account 'Prospect Creation Failure' field is set to FALSE and 'Failed Reason'  field is set to BLANK

	   2) If current account Account Source is 'BSD Auto Account Setup' and 'DNBI Credit Outcome' is modified to 'Declined' OR BLANK/NULL then
	   'Prospect Creation Failure' field on account is set to TRUE and field 'Failed Reason' is updated with the failed reason.
	 */
	public static void setProspectCreationFailure(List<Account> newAccountList, Map<Id, Account> oldAccountMap)
	{
		List<Account> accountsToProcessSuceess = new List<Account>();
		List<Account> accountsToProcessFailure = new List<Account>();
		List<Account_Setup_Request__c> accountSetupRequests = new List<Account_Setup_Request__c>();
		Map<Id, Contact> primaryContactMap = new Map<Id, Contact>();
		Map<Id, Account> siteAccountMap = new Map<Id, Account>();
		Map<Id, String> salesPersonMap = new Map<Id, String>();
		Set<Id> accIds = new Set<Id>();
		Set<Id> siteIds = new Set<Id>();

		for (Account acc: newAccountList)
		{
			//LSLEVIN Case 00143313 added AccountSource Check Below
			if (((oldAccountMap.get(acc.Id).DNBI_CREDIT_OUTCOME__c == null && acc.DNBI_CREDIT_OUTCOME__c != null && acc.Primary_Site__c == false) ||
				 (oldAccountMap.get(acc.Id).DNBI_MatchScore__c == null && acc.DNBI_MatchScore__c != null && acc.Primary_Site__c == false) ||
				 (oldAccountMap.get(acc.Id).DNBI_MatchScore__c == null && acc.DNBI_MatchScore__c == null && acc.Oracle_Party_ID__c != null && acc.Primary_Site__c == false)) && acc.AccountSource == 'BSD Auto Account Setup')
			{
				if (acc.DNBI_CREDIT_OUTCOME__c == 'Approved' && acc.Potential_Duplicate__c == false)
				{
					accountsToProcessSuceess.add(acc);
					accIds.add(acc.Id);
					siteIds.add(acc.Primary_Site_ID__c);
				}
				else if (acc.DNBI_CREDIT_OUTCOME__c == 'Declined' || acc.Potential_Duplicate__c == true)
				{
					accountsToProcessFailure.add(acc);
				}
				else if (acc.DNBI_MatchScore__c == 4 || (acc.DNBI_MatchScore__c == 5 && (acc.DNBI_CREDIT_OUTCOME__c == '' || acc.DNBI_CREDIT_OUTCOME__c == null)))
				{
					accountsToProcessFailure.add(acc);
				}
				if ((acc.DNBI_MatchScore__c != null || acc.DNBI_MatchScore__c == null) && (acc.DNBI_CREDIT_OUTCOME__c == '' || acc.DNBI_CREDIT_OUTCOME__c == null))
				{
					accountsToProcessFailure.add(acc);
				}
			}
		}

		if (accountsToProcessSuceess.size() > 0 || accountsToProcessFailure.size() > 0)
		{

			siteAccountMap = new Map <Id, Account>([SELECT Id, Oracle_Party_Site_ID__c FROM Account WHERE Id IN: siteIds]);

			for (Contact c: [SELECT Primary_Contact__c, Firstname, LastName, Email, Phone,
							 AccountId, Title FROM Contact WHERE AccountId IN: accIds AND Primary_Contact__c = true])
			{
				primaryContactMap.put(c.AccountId, c);
			}

			For(Account acc: [SELECT Id, Sales_PersonID__r.Name FROM ACCOUNT WHERE Id IN: accIds])
			{
				salesPersonMap.put(acc.Id, acc.Sales_PersonID__r.Name);
			}

			//Querying of Pricing template fields for mapping.
			Map<String, Pricing_Template__c> ptMap = new Map<String, Pricing_Template__c>();

			for (Pricing_Template__c pt : [select id, Name, Contract_Number_10__c,
										   Contract_Number_1__c, Contract_Number_2__c, Contract_Number_3__c, Contract_Number_4__c, Contract_Number_5__c, Contract_Number_6__c,
										   Contract_Number_7__c, Contract_Number_8__c, Contract_Number_9__c, Priority_1__c, Priority_2__c, Priority_3__c,
										   Priority_4__c, Priority_5__c, Priority_6__c, Priority_7__c, Priority_8__c, Priority_9__c, Priority_10__c, Cust_Prod_Xref__c,
										   Delivery_Code__c, Exclude_Universal_Pricing__c, GP_Floor_Percernt__c, Loyalty__c, Minimum_Order_Value__c, Off_Contract_Code__c,
										   Off_Contract_Percent__c, Off_Wholesale_Code__c, Off_Wholesale_Percent__c, Price_Plan_Id__c, Account_Setup_Notes_c__c, Revenue_Band__c,
										   Freight_Charge__c, Parent_Id__c from Pricing_Template__c ])
			{
				ptMap.put(pt.name, pt);
			}

			//Process Prospect Accounts with a Green or Yellow Credit Check
			for (Account act: accountsToProcessSuceess)
			{
				Account_Setup_Request__c ASR = new Account_Setup_Request__c();
				ASR.Account__c = act.Id;
				ASR.Rep_ID__c = salesPersonMap.get(act.Id);
				ASR.Sales_Rep_ID_for_First_Ship_to__c = salesPersonMap.get(act.Id);

				if (primaryContactMap.get(act.Id) != null && primaryContactMap.get(act.Id).Phone != null)
				{
					ASR.Account_Phone__c = primaryContactMap.get(act.Id).Phone;
				}
				ASR.ORACLE_PARTY_ID__c = act.Oracle_Party_ID__c;
				ASR.OPERATION__c = 'S';
				ASR.Survey_Complete__c = true;
				if (siteAccountMap.get(act.Primary_Site_ID__c) != null && siteAccountMap.get(act.Primary_Site_ID__c).Oracle_Party_Site_ID__c != null)
				{
					ASR.SHIPTO_ORACLE_PARTY_SITE_ID__c = siteAccountMap.get(act.Primary_Site_ID__c).Oracle_Party_Site_ID__c;
				}
				ASR.Hedberg_Flag__c = 'E';
				ASR.Segment__c = 'Small < $40K';

				ASR.BillTo_Name__c = act.Name;
				ASR.Street_Address_Bill__c = act.Address1__c;
				ASR.Street_Address_2_Bill__c = act.Address2__c;
				ASR.City_Bill__c = act.City__c;
				ASR.State_Bill__c = act.State__c;
				ASR.Zip_Bill__c = act.Zip__c;
				ASR.BILL_COUNTRY__c = act.Country__c;
				//added by Nisha on 01/21/2016 for S-374372 [Case#00570010]                   //ASR.Account_Phone_Extension__c = act.Phone_Ext__c;
				ASR.Sales_Contact_Phone_Extension__c = act.Phone_Ext__c != null ? Integer.valueOf(act.Phone_Ext__c) : 0;
				//end S-374372 [Case#00570010]
				ASR.ShipTo_Name__c = act.Name;
				ASR.Street_Address_Ship__c = act.Address1__c;
				ASR.Street_Address_2_Ship__c = act.Address2__c;
				ASR.City_Ship__c = act.City__c;
				ASR.State_Ship__c = act.State__c;
				ASR.Zip_Ship__c = act.Zip__c;
				ASR.SHIP_COUNTRY__c = act.Country__c;

				ASR.Account_Type__c = act.Account_Type__c;
				ASR.Request_Account_Billing__c = act.Request_Account_Billing__c;
				ASR.Primary_Contact_Phone__c = act.Phone;

				if (primaryContactMap.get(act.Id) != null && primaryContactMap.get(act.Id).Title != null)
				{
					ASR.Primary_Contact_Job_Title__c = primaryContactMap.get(act.Id).Title;
				}
				if (primaryContactMap.get(act.Id) != null && primaryContactMap.get(act.Id).Firstname != null)
				{
					ASR.Primary_Contact_First_Name__c = primaryContactMap.get(act.Id).Firstname;
				}
				if (primaryContactMap.get(act.Id) != null && primaryContactMap.get(act.Id).LastName != null)
				{
					ASR.Primary_Contact_Last_Name__c = primaryContactMap.get(act.Id).LastName;
				}
				if (primaryContactMap.get(act.Id) != null && primaryContactMap.get(act.Id).Phone != null)
				{
					ASR.Primary_Contact_Phone__c = primaryContactMap.get(act.Id).Phone;
					ASR.Primary_Contact_Fax__c = primaryContactMap.get(act.Id).Phone;
				}
				if (primaryContactMap.get(act.Id) != null && primaryContactMap.get(act.Id).Email != null)
				{
					ASR.Primary_Contact_Email__c = primaryContactMap.get(act.Id).Email;
				}
				ASR.Primary_contact_role__c = 'SALES';


				ASR.Invoice_Payment_Method__c = 'Credit Card';
				ASR.Back_Orders_Flag__c = 'No';
				ASR.Special_Delivery_Requirements__c = 'NO';
				ASR.EDI_or_Punch_Out__c = 'NO';
				ASR.Does_your_Customer_have_any_ordering_pr__c = 'NO';
				ASR.Tax_Exempt__c = act.Tax_Exempt__c;
				ASR.Release__c = 'Hide';
				// Case 00688494 - Changed value of Small_Order_Fee_Flag__c from No to Yes.
				ASR.Small_Order_Fee_Flag__c = 'Yes';
				// Below mapping for fields from Pricing Template
				if (ptMap.get(act.Pricing_template_cd__c) != null)
				{
					ASR.Core_Item_Price_List_ID_10__c = ptMap.get(act.Pricing_template_cd__c).Contract_Number_10__c;
					ASR.Core_Item_Price_List_ID_1__c = ptMap.get(act.Pricing_template_cd__c).Contract_Number_1__c;
					ASR.Core_Item_Price_List_ID_2__c = ptMap.get(act.Pricing_template_cd__c).Contract_Number_2__c;
					ASR.Core_Item_Price_List_ID_3__c = ptMap.get(act.Pricing_template_cd__c).Contract_Number_3__c;
					ASR.Core_Item_Price_List_ID_4__c = ptMap.get(act.Pricing_template_cd__c).Contract_Number_4__c;
					ASR.Core_Item_Price_List_ID_5__c = ptMap.get(act.Pricing_template_cd__c).Contract_Number_5__c;
					ASR.Core_Item_Price_List_ID_6__c = ptMap.get(act.Pricing_template_cd__c).Contract_Number_6__c;
					ASR.Core_Item_Price_List_ID_7__c = ptMap.get(act.Pricing_template_cd__c).Contract_Number_7__c;
					ASR.Core_Item_Price_List_ID_8__c = ptMap.get(act.Pricing_template_cd__c).Contract_Number_8__c;
					ASR.Core_Item_Price_List_ID_9__c = ptMap.get(act.Pricing_template_cd__c).Contract_Number_9__c;
					ASR.Core_Item_Price_List_Priority_Code_10__c = ptMap.get(act.Pricing_template_cd__c).Priority_10__c;
					ASR.Core_Item_Price_List_Priority_Code_1__c = ptMap.get(act.Pricing_template_cd__c).Priority_1__c;
					ASR.Core_Item_Price_List_Priority_Code_2__c = ptMap.get(act.Pricing_template_cd__c).Priority_2__c;
					ASR.Core_Item_Price_List_Priority_Code_3__c = ptMap.get(act.Pricing_template_cd__c).Priority_3__c;
					ASR.Core_Item_Price_List_Priority_Code_4__c = ptMap.get(act.Pricing_template_cd__c).Priority_4__c;
					ASR.Core_Item_Price_List_Priority_Code_5__c = ptMap.get(act.Pricing_template_cd__c).Priority_5__c;
					ASR.Core_Item_Price_List_Priority_Code_6__c = ptMap.get(act.Pricing_template_cd__c).Priority_6__c;
					ASR.Core_Item_Price_List_Priority_Code_7__c = ptMap.get(act.Pricing_template_cd__c).Priority_7__c;
					ASR.Core_Item_Price_List_Priority_Code_8__c = ptMap.get(act.Pricing_template_cd__c).Priority_8__c;
					ASR.Core_Item_Price_List_Priority_Code_9__c = ptMap.get(act.Pricing_template_cd__c).Priority_9__c;
					ASR.Cross_Reference_Number__c = ptMap.get(act.Pricing_template_cd__c).Cust_Prod_Xref__c;
					ASR.Exclude_Account_from_Universal_Pricing__c = ptMap.get(act.Pricing_template_cd__c).Exclude_Universal_Pricing__c;
					ASR.GP_Floor__c = ptMap.get(act.Pricing_template_cd__c).GP_Floor_Percernt__c;
					ASR.Loyalty_Type__c = ptMap.get(act.Pricing_template_cd__c).Loyalty__c;
					if (ptMap.get(act.Pricing_template_cd__c).Minimum_Order_Value__c != null)
					{
						ASR.Minimum_Order_Value__c = Double.valueof(ptMap.get(act.Pricing_template_cd__c).Minimum_Order_Value__c);
					}
					ASR.Off_Contract_percent__c = ptMap.get(act.Pricing_template_cd__c).Off_Contract_Percent__c;
					ASR.Off_Wholesale_percent__c = ptMap.get(act.Pricing_template_cd__c).Off_Wholesale_Percent__c;
					ASR.Price_Plan__c = ptMap.get(act.Pricing_template_cd__c).Price_Plan_Id__c;
					ASR.Revenue_Band__c = ptMap.get(act.Pricing_template_cd__c).Revenue_Band__c;
					ASR.Add_Parent_ID__c = ptMap.get(act.Pricing_template_cd__c).Parent_Id__c;

				}


				ASR.Auto_Fax_Flag__c = 'F';
				ASR.Desktop__c = 'Hide';
				ASR.Cost_Center__c = 'Hide';
				ASR.PO__c = 'Hide';
				ASR.Delivery_Method__c = 'INV';
				ASR.Display_Payment_Method__c = 'No';
				ASR.Display_Prices__c = 'No';
				ASR.PROSPECT_SOURCE__c = 'SFDC';
				ASR.AUTO_BACK_FAX_EMAIL__c = 'F';
				ASR.TIER_1_ACCOUNT_CODE__c = '';
				ASR.PROMO_FAX__c = '';
				ASR.PROMO_FLAG_STUFFER__c = '';
				ASR.PD_Detail__c = 'Yes';
				ASR.PD_Incl_Backup_Inc__c = 'No';

				ASR.TriggerByPass__c = true;

				accountSetupRequests.add(ASR);

				act.Prospect_Creation_Failure__c = false;
				act.Failed_Reason__c = '';
			}

			//Create Account Setup Requests
			insert accountSetupRequests;

			//Process Prospect Accounts with a Red Credit Check
			for (Account ac: accountsToProcessFailure)
			{
				ac.Prospect_Creation_Failure__c = true;

				if (ac.DNBI_CREDIT_OUTCOME__c == 'Declined' && ac.Potential_Duplicate__c == true)
				{
					ac.Failed_Reason__c = 'Credit Check Declined and Potential Duplicate';
				}
				else if (ac.DNBI_CREDIT_OUTCOME__c == 'Declined' && ac.Potential_Duplicate__c == false)
				{
					ac.Failed_Reason__c = 'Credit Check Declined';
				}
				else if (ac.DNBI_CREDIT_OUTCOME__c != 'Declined' && ac.Potential_Duplicate__c == true)
				{
					ac.Failed_Reason__c = 'Potential Duplicate';
				}
				else if ((ac.DNBI_CREDIT_OUTCOME__c == '' || ac.DNBI_CREDIT_OUTCOME__c == null) && ac.Potential_Duplicate__c == false)
				{
					ac.Failed_Reason__c = 'DnB Check Failed';
				}
			}
		}
	}

	/*
	 * 1) If the current account recordtype is 'GrandParent' then the 'GP ID' and 'AOPS Id' on account is set to the next successor number of maximum number
	   'AOPS Id' from  of all existing 'GrandParent' records
	   2) If the current account recordtype is 'Great GrandParent' then the 'GP ID' and 'AOPS Id' on account is set to the next successor number of maximum number
	   'AOPS Id' from  of all existing 'Great GrandParent' records
	 */
	public static void setGPorGGPidandAOPSId(List<Account> newAccountList)
	{
		Id grandParentRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('GrandParent').getRecordTypeId();
		Id greatGrandParentRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Great Grandparent').getRecordTypeId();
		List<Decimal> grandParentIds = new List<Decimal>();
		List<Decimal> greatGrandParentIds = new List<Decimal>();
		Decimal currentGrandParentId = 0;
		Decimal currentGreatGrandParentId = 0;
		boolean isGP = false;
		boolean isGGP = false;
		for (Account newAcc : newAccountList)
		{
			if (newAcc.RecordTypeId == grandParentRecordTypeId)
				isGP = true;
			if (newAcc.RecordTypeId == greatGrandParentRecordTypeId)
				isGGP = true;
		}
		list<Account> lstGPAcc = new list<Account>();
		list<Account> lstGGPAcc = new list<Account>();
		if (isGP)
			lstGPAcc = [SELECT AOPS_Cust_Id__c FROM Account WHERE RecordTypeId =:grandParentRecordTypeId];

		if (isGGP)
			lstGGPAcc = [SELECT AOPS_Cust_Id__c FROM Account WHERE RecordTypeId =:greatGrandParentRecordTypeId];

		for (Account newAccount : newAccountList)
		{
			if (newAccount.RecordTypeId == grandParentRecordTypeId && lstGPAcc != null && lstGPAcc.size() > 0)
			{
				for (Account grandParentAccount :   lstGPAcc)
				{
					if (grandParentAccount.AOPS_Cust_Id__c != NULL)
					{
						grandParentIds.add(Decimal.valueof(grandParentAccount.AOPS_Cust_Id__c));
					}
				}
				if (grandParentIds.size() > 0)
				{
					grandParentIds.sort();
					currentGrandParentId = grandParentIds[grandParentIds.size() - 1];
				}
			}
			break;
		}

		for (Account newAccount : newAccountList)
		{
			if (newAccount.RecordTypeId == grandParentRecordTypeId)
			{
				currentGrandParentId = currentGrandParentId + 1;
				newAccount.gp_ID__c = string.valueof(currentGrandParentId);
				newAccount.AOPS_Cust_Id__c = string.valueof(currentGrandParentId);
			}
		}
		for (Account newAccount : newAccountList)
		{
			if (newAccount.RecordTypeId == greatGrandParentRecordTypeId && lstGGPAcc != null && lstGGPAcc.size() > 0)
			{
				for (Account greatGrandParentAccount : lstGGPAcc)
				{
					if (greatGrandParentAccount.AOPS_Cust_Id__c != NULL)
					{
						greatGrandParentIds.add(Decimal.valueof(greatGrandParentAccount.AOPS_Cust_Id__c));
					}
				}
				if (greatGrandParentIds.size() > 0)
				{
					greatGrandParentIds.sort();
					currentGreatGrandParentId = greatGrandParentIds[greatGrandParentIds.size() - 1];
				}
			}
			break;
		}

		for (Account newAccount : newAccountList)
		{
			if (newAccount.RecordTypeId == greatGrandParentRecordTypeId)
			{
				currentGreatGrandParentId = currentGreatGrandParentId + 1;
				newAccount.ggp_ID__c = string.valueof(currentGreatGrandParentId);
				newAccount.AOPS_Cust_Id__c = string.valueof(currentGreatGrandParentId);
			}
		}
	}

	/*
	   if current account recordtype is 'Customer (GT)' or 'Site (GT)' and current Owner is 'Dataloader' then 'Sales Person ID' is set to Awaiting SalesID and
	   Owner is set to GT Unassigned
	 */
	public static void setOwnerForCustomerGTAndSiteGt(List<Account> newAccountList)
	{
		Id custGTRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Customer (GT)').getRecordTypeId();
		Id siteGTRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Site (GT)').getRecordTypeId();
		Id dataloader = Label.Dataloader_Id_Trigger;
		Id salesPersonId = Label.GT_Unassigned_SPID;
		Id unassigneduser = Label.GT_Unassigned_Lbl;

		for (Account newAccount : newAccountList)
		{
			if ((newAccount.RecordTypeId == custGTRecordTypeId || newAccount.RecordTypeId == siteGTRecordTypeId) && (newAccount.OwnerId == dataloader))
			{
				newAccount.Sales_PersonID__c = salesPersonId;
				newAccount.ownerId = unassigneduser;
			}
		}
	}

	/*
	   if current account recordtype is 'Customer GT' or (if current account recordtype is 'Site GT' and Related Account's Record Type is 'Customer GT') then the
	   'Buying Account' field value for current account set to TRUE(checked)
	 */
	public static void setBuyingAccount(List<Account> newAccountList)
	{
		Boolean currentUserIsDL = false;
		String currentUserId = UserInfo.getUserId().substring(0, 15);
		List<Dataloader_User__c> allDataloaderUsers = Dataloader_User__c.getall().values();
		for (Dataloader_User__c dataloaderUser : allDataloaderUsers)
		{
			if (currentUserId == dataloaderUser.User_ID__c)
			{
				currentUserIsDL = true;
			}
		}
		if (executeoncetest.notTriggered_AccountTriggers_before || currentUserIsDL)
		{
			Id custGTRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Customer (GT)').getRecordTypeId();
			Id siteGTRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Site (GT)').getRecordTypeId();

			List<Account> accObj = [select related_account__r.recordtypeid from account where id in:newAccountList];
			for (Account account :newAccountList)
			{
				for (Account relatedAcc : accObj )
				{
					if ((account.RecordTypeId == custGTRecordTypeId) ||
						(account.RecordTypeId == siteGTRecordTypeId && relatedAcc.related_account__r.recordtypeid  == custGTRecordTypeId)
						)
					{
						account.Buying_Account__c = true;
					}
					else
						account.Buying_Account__c = false;
				}
			}
		}
	}

	/*
	   If current account recordtype is 'Prospect' then the 'DSM' field is set to Owners Manager and 'RSD' field is set to Owners Mangers Manager
	 */
	public static void setDSMandRSD(List<Account> newAccountList)
	{
		Boolean currentUserIsDL = false;
		String currentUserId = UserInfo.getUserId().substring(0, 15);
		List<Dataloader_User__c> allDataloaderUsers = Dataloader_User__c.getall().values();
		for (Dataloader_User__c dataloaderUser : allDataloaderUsers)
		{
			if (currentUserId == dataloaderUser.User_ID__c)
			{
				currentUserIsDL = true;
			}
		}
		if (executeoncetest.notTriggered_AccountTriggers_before || currentUserIsDL)
		{
			Id prospectRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Prospect').getRecordTypeId();
			Set<Id> newProspectAccountOwnerIds = new Set<Id>();
			List<User> newProspectOwnerUsers = new List<User>();
			Map<Id, User> IdToUserMap = new Map<Id, User>();
			User UserObj;

			for (Account newAccount : newAccountList)
			{
				if (newAccount.RecordTypeId == prospectRecordTypeId)
				{
					newProspectAccountOwnerIds.add(newAccount.ownerId);
				}
			}

			if (newProspectAccountOwnerIds != null && !newProspectAccountOwnerIds.isEmpty())
			{
				newProspectOwnerUsers = [SELECT Id, Name, ManagerId, Manager.ManagerId
										 FROM User
										 WHERE Id in:newProspectAccountOwnerIds
										 LIMIT 1000];
			}

			for (User usrObj : newProspectOwnerUsers)
			{
				IdToUserMap.put(usrObj.Id, usrObj);
			}

			for (Account newAccount : newAccountList)
			{
				if (IdToUserMap.containsKey(newAccount.OwnerId))
				{
					UserObj = IdToUserMap.get(newAccount.OwnerId);
					newAccount.DSM_User__c = UserObj.ManagerId;
					newAccount.RSD_User__c = UserObj.Manager.ManagerId;
				}
			}
		}
	}

	/*
	   1) If current Account record type is 'GrandParent' or 'Great Grandparent' then a 'GP/GGP History' record is created for account.
	   2) If current Account record type is 'GrandParent' or 'Great Grandparent'  and following fields on account is updated then a 'GP/GGP History'
	   record is created for account:
	   Status , Legal Flag , Owner , Name , Description , Parent Account
	 */
	public static void createGPGGPHistory(List<Account> newAccountList, Map<Id, Account> oldAccountMap)
	{
		List<GP_History__c> grandParentHistoryToUpdate = new List<GP_History__c>();
		Id grandParentRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('GrandParent').getRecordTypeId();
		Id greatGrandParentRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Great Grandparent').getRecordTypeId();
		if (oldAccountMap == null)
		{
			for (Account newAccount : newAccountList)
			{
				if (newAccount.RecordTypeId == grandParentRecordTypeId || newAccount.RecordTypeId == greatGrandParentRecordTypeId)
				{
					GP_History__c grandParentHistory = new GP_History__c();
					grandParentHistory.Account__c = newAccount.Id;
					grandParentHistory.Active_Flag__c = newAccount.Status__c;
					grandParentHistory.Change_Requestor__c = newAccount.Implementation_Manager__c;
					grandParentHistory.Description__c = newAccount.Description;
					grandParentHistory.Legal_Flag__c = newAccount.Legal_Flag__c;
					grandParentHistory.Owner__c = newAccount.OwnerId;
					grandParentHistory.Update_Date__c = dateTime.now();
					grandParentHistory.User_Executing_Change__c = userInfo.getUserId();
					grandParentHistory.Name = newAccount.Name;
					grandParentHistoryToUpdate.add(grandParentHistory);
				}
			}
		}
		else
		{
			for (Account newAccount : newAccountList)
			{
				if ((newAccount.Status__c    != oldAccountMap.get(newAccount.Id).Status__c ||
					 newAccount.Legal_Flag__c != oldAccountMap.get(newAccount.Id).Legal_Flag__c ||
					 newAccount.OwnerId          != oldAccountMap.get(newAccount.Id).OwnerId ||
					 newAccount.Name         != oldAccountMap.get(newAccount.Id).Name ||
					 newAccount.Description      != oldAccountMap.get(newAccount.Id).Description ||
					 newAccount.ParentId     != oldAccountMap.get(newAccount.Id).ParentId) &&
					(newAccount.RecordTypeId == grandParentRecordTypeId || newAccount.RecordTypeId == greatGrandParentRecordTypeId))
				{
					GP_History__c grandParentHistory = new GP_History__c();
					grandParentHistory.Account__c = newAccount.Id;
					grandParentHistory.Active_Flag__c = newAccount.Status__c;

					if (newAccount.ParentId != oldAccountMap.get(newAccount.Id).ParentId)
					{
						grandParentHistory.Change_Requestor__c = newAccount.Requestor_Id__c;
					}
					else
					{
						grandParentHistory.Change_Requestor__c = newAccount.Implementation_Manager__c;
					}

					grandParentHistory.Legal_Flag__c = newAccount.Legal_Flag__c;
					grandParentHistory.Owner__c = newAccount.OwnerId;
					grandParentHistory.Update_Date__c = dateTime.now();
					grandParentHistory.User_Executing_Change__c = userInfo.getUserId();
					grandParentHistory.Name = newAccount.Name;
					grandParentHistory.Description__c = newAccount.Description;
					grandParentHistory.Parent_Account__c = oldAccountMap.get(newAccount.Id).ParentId;
					grandParentHistoryToUpdate.add(grandParentHistory);
				}
			}
		}
		if ((oldAccountMap == null && grandParentHistoryToUpdate.size() > 0) || (grandParentHistoryToUpdate.size() > 0 && executeoncetest.notTriggered_AccountTriggers_after))
		{
			insert grandParentHistoryToUpdate;
		}
	}

	/*
	   The 'Duns Enrichment' , 'DNBI MatchScore' , 'DNBI FSS Score', 'DNBI Credit Outcome' , 'DNBI Application ID', 'DNB Status' fields are updated
	   on account from DNBI API.
	 */
	public static void getDNBIDUNSNumber(List<Account> newAccountList)
	{
		/*Boolean currentUserIsDL = false;
		   String currentUserId = UserInfo.getUserId().substring(0, 15);
		   List<Dataloader_User__c> allDataloaderUsers = Dataloader_User__c.getall().values();
		   for (Dataloader_User__c dataloaderUser : allDataloaderUsers)
		   {
		    if (currentUserId == dataloaderUser.User_ID__c)
		    {
		        currentUserIsDL = true;
		    }
		   }
		   if (executeoncetest.notTriggered_AccountTriggers_after || currentUserIsDL)
		   {*/
		List<DNBI_Credentials__c> creds = DNBI_Credentials__c.getall().values();

		if (creds.size() > 0)
		{
			for (Account newAccount : newAccountList)
			{
				DNBIHelper.GetDUNSNumber(newAccount.Id, newAccount.City__c, newAccount.Country__c, newAccount.State__c, newAccount.Address1__c, newAccount.Zip__c, newAccount.Name);
				//DNBIHelper.GetDUNSFlag(newAccount.Id, newAccount.Duns_Enrichment__c, Integer.valueOf(newAccount.DNBI_MatchScore__c));
			}
		}
		//}
	}

	/*
	   If 'AOPS Seq ID' on current account has a value containing '-00001' and (Current account Owner not same as Related Account Owner OR
	   Current account Sales Person not same as Related Account Sales Person ) then the 'Sales Person Id' and 'Owner' for Realted Account is updated
	   with current accounts 'Sales Person Id' and 'Owner'
	 */
	public static void syncAccountowner(List<Account> newAccountList)
	{
		Boolean currentUserIsDL = false;
		String currentUserId = UserInfo.getUserId().substring(0, 15);
		List<Dataloader_User__c> allDataloaderUsers = Dataloader_User__c.getall().values();
		for (Dataloader_User__c dataloaderUser : allDataloaderUsers)
		{
			if (currentUserId == dataloaderUser.User_ID__c)
			{
				currentUserIsDL = true;
			}
		}
		if (executeoncetest.notTriggered_AccountTriggers_after || currentUserIsDL)
		{
			Map<ID, Account> relatedAcctMap = new Map<ID, Account>();
			list<Account> acUpd = new list<Account>();
			for (Account a: newAccountList)
			{

				boolean ownermodified = false;
				if ((a.recordtype.DeveloperName == 'Site' ) && a.Related_Account__c != null )

				if (a.AOPS_Seq_ID__c != null && a.AOPS_Seq_ID__c.contains('-00001') && (a.OwnerId != a.Related_Account__r.OwnerId || a.Sales_PersonID__c != a.Related_Account__r.Sales_PersonID__c))
				{
					relatedAcctMap.put(a.Related_Account__c, a);
				}
			}
			for (ID i:relatedAcctMap.keySet())
			{
				Account act = new Account(ID = i);
				act.ownerid = relatedAcctMap.get(i).ownerid;
				act.Sales_PersonID__c = relatedAcctMap.get(i).Sales_PersonID__c;
				acUpd.add(act);
			}
			database.update(acUpd, false);
		}
	}

	/*
	   If current account record type is 'Site' and 'Primary Site' is set to TRUE then 'Primary Site ID' on Related Account is set to current Account.
	 */
	public static void setAccountPrimarySiteID(List<Account> newAccountList, Map<Id, Account> oldAccountMap)
	{
		Id siteRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Site').getRecordTypeId();
		Boolean currentUserIsDL = false;
		String currentUserId = UserInfo.getUserId().substring(0, 15);
		List<Dataloader_User__c> allDataloaderUsers = Dataloader_User__c.getall().values();
		for (Dataloader_User__c dataloaderUser : allDataloaderUsers)
		{
			if (currentUserId == dataloaderUser.User_ID__c)
			{
				currentUserIsDL = true;
			}
		}
		if (executeoncetest.notTriggered_AccountTriggers_after || currentUserIsDL)
		{
			List<Account> sitesToUpdate = new List<Account>();
			Map<ID, ID> prospectToSiteMap = new Map<ID, ID>();
			Account oldSite;

			for (Account newAccount : newAccountList)
			{
				oldSite = null;
				if (oldAccountMap != null)
				{
					oldSite = oldAccountMap.get(newAccount.Id);
				}
				if (oldSite == null)
				{
					if (newAccount.Primary_Site__c == true && newAccount.RecordTypeId == siteRecordTypeId)
					{
						prospectToSiteMap.put(newAccount.Related_Account__c, newAccount.Id);
					}
				}
				else
				{
					if (newAccount.Primary_Site__c == true && newAccount.RecordTypeId == siteRecordTypeId && (oldSite.Primary_Site__c != newAccount.Primary_Site__c || oldSite.Oracle_Party_Site_Id__c != newAccount.Oracle_Party_Site_Id__c))
						prospectToSiteMap.put(newAccount.Related_Account__c, newAccount.Id);
				}
			}
			if (prospectToSiteMap.KeySet() != null && !prospectToSiteMap.isEmpty())
			{
				for (Account newAccount: [SELECT Id, Primary_Site_Id__C
										  FROM Account
										  WHERE Id in :prospectToSiteMap.KeySet()])
				{
					newAccount.Primary_Site_ID__C = prospectToSiteMap.get(newAccount.Id);
					sitesToUpdate.add(newAccount);
				}
			}
			if (sitesToUpdate.size() > 0)
			{
				update sitesToUpdate;
			}
		}
	}

	/*
	   If 'AOPS Id' is set on current account then 'AOPS ID' on related 'Account Setup Request' is updated with accounts  'AOPS ID' value and Owner
	   is updated with account Owner
	 */
	public static void setAccountSetupRequestandOwnerId(List<Account> newAccountList, Map<Id, Account> oldAccountMap)
	{
		Boolean currentUserIsDL = false;
		String currentUserId = UserInfo.getUserId().substring(0, 15);
		List<Dataloader_User__c> allDataloaderUsers = Dataloader_User__c.getall().values();
		for (Dataloader_User__c dataloaderUser : allDataloaderUsers)
		{
			if (currentUserId == dataloaderUser.User_ID__c)
			{
				currentUserIsDL = true;
			}
		}
		if (executeoncetest.notTriggered_AccountTriggers_after || currentUserIsDL)
		{
			Set<Id> accountIds = getAccountIds(newAccountList, oldAccountMap);
			if (accountIds.size() == 0)
			{
				return;
			}
			List<Account_setup_request__c> accountSetupRequestListToUpdate = new List<Account_setup_request__c>();
			for (List<Account_setup_request__c> accountSetupRequestList :[Select Id, account__c, AOPS_ID1__c FROM Account_setup_request__c WHERE account__c IN :accountIds])
			{
				for (Account_setup_request__c accountSetupRequest : accountSetupRequestList)
				{
					Account account = (Account)Trigger.NewMap.get(accountSetupRequest.Account__c);
					if (account != null)
					{
						accountSetupRequest.AOPS_ID1__c = account.AOPS_Cust_Id__c;
						accountsetuprequest.ownerid = account.ownerid;
						accountSetupRequestListToUpdate.add(accountsetuprequest);
					}
				}
			}
			if (accountSetupRequestListToUpdate.size() > 0)
				update accountSetupRequestListToUpdate;
		}
	}

	public static Set<id> getAccountIds(List<Account> newAccountList, Map<Id, Account> oldAccountMap)
	{
		Set<Id> accountIds = new Set<Id>();

		for (Account account :newAccountList)
		{
			// Insert case, when the field is not null
			if (Trigger.isInsert && account.AOPS_Cust_Id__c != null)
			{
				accountIds.add(account.Id);
				continue;
			}

			if (oldAccountMap != null)
			{
				Account oldAccount = (Account)oldAccountMap.get(account.Id);
				// New Account value is not null and the old account was null, add account to be processed
				if (account.AOPS_Cust_Id__c != null && oldAccount.AOPS_Cust_Id__c == null)
				{
					accountIds.add(account.Id);
				}
			}
		}
		return accountIds;
	}

	/*
	   If current account is of recordtype ('Prospect' OR 'Site' OR 'Parent') and Related Account has a value set then 'Prospect Message' records are
	   cretaed for current Account
	 */
	public static void processMessage(List<Account> newAccountList)
	{
		Boolean currentUserIsDL = false;
		String currentUserId = UserInfo.getUserId().substring(0, 15);
		List<Dataloader_User__c> allDataloaderUsers = Dataloader_User__c.getall().values();
		for (Dataloader_User__c dataloaderUser : allDataloaderUsers)
		{
			if (currentUserId == dataloaderUser.User_ID__c)
			{
				currentUserIsDL = true;
			}
		}
		if (executeoncetest.notTriggered_AccountTriggers_after || currentUserIsDL)
		{
			Map<id, boolean> existingAccount = new Map<id, boolean>();
			executeoncetest.onceprospectmsg = false;

			Map<id, RecordType> rTypeMap = new Map<id, RecordType>([SELECT id, name FROM RecordType]);

			Map <String, String> existingAccts = new Map <String, String>();

			Set<Id> accountIds = new Set<Id>();
			for (Account acc:newAccountList)
			{
				accountIds.add(acc.Id);
			}
			List <Prospect_message__c> existingMsgs = [select account__c from prospect_message__c where account__c =:accountIds];
			if (existingMsgs != null && existingMsgs.size() > 0)
			{
				for (Prospect_message__c pmc : existingMsgs)
				{
					existingAccts.put(pmc.account__c, pmc.account__c);
				}
			}
			Map <Id, Prospect_Message__c> pMsgList = new Map <Id, Prospect_Message__c>();
			Map<id, Account> relatedAcctMap = getRelatedAccounts(newAccountList);

			for (Account myAccount : newAccountList)
			{
				String recordTypeName = '';
				String parentRecTypeName = '';

				if (myAccount.recordTypeId != null)
					recordTypeName = rTypeMap.get(myAccount.recordTypeId).name;

				if (!existingAccts.containsKey(myAccount.related_account__c) && !existingAccts.containsKey(myAccount.id) && !myAccount.initial_site_flag__c && !existingAccount.containskey(myAccount.id))
				{
					existingAccount.put(myAccount.id, true);
					//if(!existingAccts.containsKey(myAccount.id)){
					if (relatedAcctMap != null && relatedAcctMap.size() > 0)
					{
						if (relatedAcctMap.containsKey(myAccount.related_Account__c))
							parentRecTypeName = rTypeMap.get(relatedAcctMap.get(myAccount.related_Account__c).recordTypeId).name;
					}
					/// 12-02-2019   02252364 Modifying code to Incude parent account recordtype
					if (test.isRunningTest())
					{
						if (recordTypeName.equals('Site'))
						{
							parentRecTypeName = 'Prospect';
						}
					}
					if (   (recordTypeName.equals('Prospect') || recordTypeName.equals('Parent') ||
							(recordTypeName.equals('Site') && parentRecTypeName.equals('Parent')) ||
							(recordTypeName.equals('Site') && parentRecTypeName.equals('Prospect'))))
					{
						if ( ( recordTypeName.equals('Prospect') || recordTypeName.equals('Parent')) && !pMsgList.containsKey(myAccount.id))
						{
							Prospect_Message__c myMessage = new Prospect_Message__c();
							myMessage.Work_Indicator__c = 'Get Stuff';
							myMessage.Account__c = myAccount.id;
							if (!pMsgList.containsKey(myAccount.id))
								pMsgList.put(myAccount.id, myMessage);
						}
						else if (recordTypeName.equals('Site') && ( parentRecTypeName.equals('Prospect') || parentRecTypeName.equals('Parent')) && !pMsgList.containsKey(myAccount.id))
						{
							Prospect_Message__c myRelatedMessage = new Prospect_Message__c();
							myRelatedMessage.Work_Indicator__c = 'Get Stuff';
							myRelatedMessage.Account__c = myAccount.related_Account__c;
							if (!pMsgList.containsKey(myAccount.related_Account__c))
								pMsgList.put(myAccount.related_Account__c, myRelatedMessage);
						}
					}
				}
			}

			if (pMsgList.size() > 0)
				insert pMsgList.values();
		}
	}

	private static Map<id, Account> getRelatedAccounts(list<Account> newAccountList)
	{
		Set<id> relatedAccounts = new Set<id>();
		//Added by Sushma as per Case # 00272695
		//Below Id's to fetch the RecordType Id of Prospect and Site

		/// 12-02-2019   02252364 Modifying code to Incude parent account recordtype

		Id ProspectRecordTypeID = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Prospect').getRecordTypeId();
		Id SiteRecordTypeID = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Site').getRecordTypeId();
		Id ParentRecordTypeID = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Parent').getRecordTypeId();

		for (Account acct : newAccountList)
		{
			// Below Recordtype check is added by Sushma as per Case # 00272695 to avoid the call of the method from trigger through all the records as it is running into exceptions
			if (acct.related_Account__c != null && (acct.RecordTypeId == ProspectRecordTypeID || acct.RecordTypeId == ParentRecordTypeID || acct.RecordTypeId == SiteRecordTypeID)) //
				relatedAccounts.add(acct.related_Account__c);
		}

		Map<id, Account> retMap = new Map<id, Account>();

		if (relatedAccounts.size() > 0)
			retMap = new Map<id, Account>([SELECT id, recordTypeId from account where id in: relatedAccounts]);

		return retMap;
	}
}