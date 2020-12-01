trigger aceCustomerPriceChanges on ACE_Customer_Price_Changes__c (after update, before insert, before update)
{

	List<ACE_Settings__c> desettings = [SELECT Id, trigger_by_pass__c FROM ACE_Settings__c LIMIT 1];

	if (desettings.size() > 0 && desettings[0] != null)
	{
		if (desettings[0].trigger_by_pass__c != null)
		{
			boolean userByPass = desettings[0].trigger_by_pass__c.contains(userInfo.getUserId());
			if (userByPass)
			{
				return;
			}
		}
	}

	if (Trigger.isBefore && (Trigger.isInsert || Trigger.isUpdate))
	{

		// Assign Account Extension
		List<Id> acctIds = new List<Id>();

		for (ACE_Customer_Price_Changes__c ace : Trigger.new)
		{
			Id acctId = ace.Customer__c;

			if (acctId != null)
			{
				acctIds.add(acctId);
			}
		}

		Map<Id, Id> accountIdToExtensionId = (new AccountExtensionHelper()).getAccountExtensionIds(acctIds);

		for (ACE_Customer_Price_Changes__c ace : Trigger.new)
		{
			Id acctId = ace.Customer__c;
			ace.Account_Extension__c = accountIdToExtensionId.get(acctId);
		}
	}

	if (Trigger.isAfter && Trigger.isUpdate)
	{
		List<Audit_History__c> aHist = new List<Audit_History__c> ();

		for (ACE_Customer_Price_Changes__c c:Trigger.new)
		{

			if (c.Sales_Price_Change_Effective_Date_Min__c != Trigger.OldMap.get(c.id).Sales_Price_Change_Effective_Date_Min__c
				|| c.Customer_Notification_Date_Approved__c   != Trigger.OldMap.get(c.id).Customer_Notification_Date_Approved__c
				|| c.Sales_Price_Change_Effective_Date_Rep__c != Trigger.OldMap.get(c.id).Sales_Price_Change_Effective_Date_Rep__c
				|| c.Record_Lock_Code__c != Trigger.OldMap.get(c.id).Record_Lock_Code__c
				)
			{
				Audit_History__c ah = new Audit_History__c();

				ah.ACE_Customer_Price_Changes__c = c.ID;
				ah.new_SalesPrice_ChangeEffectiveDateApprov__c = c.Sales_Price_Change_Effective_Date_Min__c;
				ah.Old_SalesPriceChangeEffectiveDateApprov__c = Trigger.OldMap.get(c.id).Sales_Price_Change_Effective_Date_Min__c;

				ah.New_Customer_Notification_Date_Approved__c = c.Customer_Notification_Date_Approved__c;
				ah.Old_Customer_Notification_Date_Approved__c = Trigger.OldMap.get(c.id).Customer_Notification_Date_Approved__c;

				ah.NewSales_Price_Change_Effective_Date_Rep__c = c.Sales_Price_Change_Effective_Date_Rep__c;
				ah.Old_SalesPrice_Change_Effective_Date_Rep__c = Trigger.OldMap.get(c.id).Sales_Price_Change_Effective_Date_Rep__c;

				ah.New_Record_Lock_Code__c = c.Record_Lock_Code__c;
				ah.Old_Record_Lock_Code__c = Trigger.OldMap.get(c.id).Record_Lock_Code__c;

				aHist.add(ah);
			}

			if (c.Record_Unlock_Status__c != Trigger.OldMap.get(c.id).Record_Unlock_Status__c)
			{
				Audit_History__c ah = new Audit_History__c();

				ah.ACE_Customer_Price_Changes__c = c.ID;
				ah.Customer_Name__c = c.Customer_Name__c;
				ah.Record_Unlock_Status__c = c.Record_Unlock_Status__c;
				aHist.add(ah);
			}

			if (c.sfdc_notification_flag__c == '3' && c.Customer_Response__c != Trigger.OldMap.get(c.id).Customer_Response__c)
			{
				Audit_History__c ah = new Audit_History__c();
				if (c.Customer_Response__c == 'Approved')
				{
					ah.ACE_Customer_Price_Changes__c = c.ID;
					ah.Customer_Name__c = c.Customer_Name__c;
					ah.Customer_Response__c = c.Customer_Response__c;
					aHist.add(ah);
				}
				if (c.Customer_Response__c == 'Call Me')
				{
					ah.ACE_Customer_Price_Changes__c = c.ID;
					ah.Customer_Name__c = c.Customer_Name__c;
					ah.Customer_Response__c = c.Customer_Response__c;
					aHist.add(ah);
				}
			}
		}

		insert ahist;
	}

	if (Trigger.isBefore && Trigger.isUpdate)
	{
		for (ACE_Customer_Price_Changes__c c : Trigger.new)
		{
			if ( (c.Notification_Error__c != Trigger.OldMap.get(c.id).Notification_Error__c || c.Exception_Date_Lock__c != Trigger.OldMap.get(c.id).Exception_Date_Lock__c || c.SKU_Approval_Pending__c != Trigger.OldMap.get(c.id).SKU_Approval_Pending__c || c.Record_Unlock__c != Trigger.OldMap.get(c.id).Record_Unlock__c || c.Customer_Response__c != Trigger.OldMap.get(c.id).Customer_Response__c) || (c.Hosted_Catalog__c != Trigger.OldMap.get(c.id).Hosted_Catalog__c) || (c.isRemediation__c != Trigger.OldMap.get(c.id).isRemediation__c) || (c.Remediation_Hold__c != Trigger.OldMap.get(c.id).Remediation_Hold__c) )
			{
				c.Update_Vendavo_Date__c = true;
			}

			if (c.Sales_Price_Change_Effective_Date_Min__c != Trigger.OldMap.get(c.id).Sales_Price_Change_Effective_Date_Min__c )
			{

				if (c.Sales_Price_Change_Effective_Date_Min__c > Trigger.OldMap.get(c.id).Sales_Price_Change_Effective_Date_Min__c && c.Reschduled_For_Reminder__c)
				{
					c.effective_date_difference__c = Trigger.OldMap.get(c.id).Sales_Price_Change_Effective_Date_Min__c.daysbetween(c.Sales_Price_Change_Effective_Date_Min__c);
				}

				c.Effective_Date_Modified__c = true;

				if (c.sfdc_notification_flag__c == '3' && c.customer_response__c == 'Approved')
				{
					c.customer_response__c = 'Pending';
					c.customer_comments__c = null;
					c.customer_response_email__c = null;
				}
			}

			if (c.lastmodifiedbyId != Trigger.OldMap.get(c.id).lastmodifiedbyId)
			{
				if (c.Approval_Satus__c == 'Pending' && c.LastModifiedBy.FirstName == c.DSM__r.FirstName)
				{
					c.L1_Mgr_Approval_End_Date__c = system.now();
				}
				if (c.Approval_Satus__c == 'Pending' && c.LastModifiedBy.FirstName == c.RSD__r.FirstName)
				{
					c.L2_Mgr_Approval_End_Date__c = system.now();
				}
				if (c.Approval_Satus__c == 'Pending' && c.LastModifiedBy.FirstName == c.VP__r.FirstName)
				{
					c.L3_Mgr_Approval_End_Date__c = system.now();
				}
			}
		}
	}
}