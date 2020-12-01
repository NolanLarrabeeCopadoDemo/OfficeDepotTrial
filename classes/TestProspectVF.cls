@istest()
public class TestProspectVF
{
    private static testmethod void TestProspectVFmethod()
    {
        Profile profileObj = [select id from profile where name='System Administrator'];        
        String profId = profileObj.id;
        user usrObj = new user(Username='abc@officedepot.com.uat',FirstName ='Fname', LastName='Lname', Alias='abc', CommunityNickname='abc', LocaleSidKey='en_US', EmailEncodingKey='UTF-8', Profileid = profId, LanguageLocaleKey='en_US', email='abc@officedepot.com.uat',TimeZoneSidKey='America/New_York');
        usrObj.Short_Title__c='';
        Insert usrObj;
        Redirect_Profile__c setting = new Redirect_Profile__c();
        setting.Name = 'System Administrator';
        setting.Profile_Name__c = 'System Administrator';
        insert setting;
        System.runAs(usrObj)
        {            
            Account obj = new Account(Name ='Test');
            insert obj;            
            PageReference pageRef = Page.ProspectNewCreation;
            Test.setCurrentPage(pageRef);
            ApexPages.StandardController sc = new ApexPages.StandardController(obj);
            OwnerOverrideController testAccPlan = new OwnerOverrideController(sc);
            testAccPlan.redirPage();
        }
    }
}