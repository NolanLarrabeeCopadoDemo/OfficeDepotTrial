public without sharing class OwnerOverrideController
{
	public Account obj;
	public OwnerOverrideController(ApexPages.StandardController controller)
	{
		obj = (Account) controller.getRecord();
	}

	public PageReference redirPage()
	{
		Boolean shouldRedirect = true;
		List<Profile> currentUserProfile = [SELECT Id, Name FROM Profile WHERE Id =:UserInfo.getProfileId() LIMIT 1];
		List<No_Redirect_Account_Profile__c> profilesToNotRedirect = [SELECT Id, Name FROM No_Redirect_Account_Profile__c WHERE Name = :currentUserProfile[0].Name];
		User currentUser = [SELECT Id, GrandParent_User__c FROM User WHERE Id =:UserInfo.getUserId()];

		if (profilesToNotRedirect.size() > 0)
		{
			shouldRedirect = false;
		}

		if (currentUser.GrandParent_User__c == false)
		{
			if (shouldRedirect == true)
			{
				return Page.ProspectNewCreation;
			}
			else
			{
				return Page.ProspectSetup;
				// return new PageReference('/setup/ui/recordtypeselect.jsp?ent=Account&nooverride=1&save_new_url=%2F001%2Fe');
			}
		}
		else
		{
			Id recId = null;
			recId = ApexPages.currentPage().getParameters().get('RecordType');
			if (recId == null)
			{
				return new PageReference('/setup/ui/recordtypeselect.jsp?ent=Account&nooverride=1&save_new_url=%2F001%2Fe');
			}
			else
			{
				return new PageReference('/001/e?retURL=%2F001%2Fo&ent=Account&nooverride=1&RecordType=' + recId);
			}
		}
	}
}