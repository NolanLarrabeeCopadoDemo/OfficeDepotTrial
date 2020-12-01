/**@@
#CLASS NAME  :  PrimaryAccountTrigger_Test(Related classes: AccountTriggerHandler, AccountTriggerHelper, PrimaryAccountTrigger_Test)
#DESCRIPTION :  Test class for PrimaryAccountTrigger, AccountTriggerHandler and AccountTriggerHandlerHelper. 02831114 - Account triggers conversion to Lightning
#CREATEDDATE :  26-05-2020 (DD-MM-YYYY) 
@@**/
@isTest(SeeAllData=false)
public class PrimaryAccountTrigger_Test
{
	@TestSetup public static void setup()
    {
        List<Sales_Person__c> lstSalesPersons = new List<Sales_Person__c>();
        Sales_Person__c s1= new Sales_Person__c();
        s1.Name = 'SP1';
        s1.IsActive__c=true;
        s1.Role_Relate_Id__c ='222222';
        s1.Primary__c =true;
        s1.user__c = UserInfo.getUserId();
        lstSalesPersons.add(s1);
        Sales_Person__c s2= new Sales_Person__c();
        s2.Name = 'SP2';
        s2.IsActive__c=true;
        s2.Role_Relate_Id__c ='333333';
        s2.Primary__c =true;
        s2.user__c = UserInfo.getUserId();
        lstSalesPersons.add(s2);
        insert lstSalesPersons;
        insert new DNBI_Credentials__c(Name = 'Test123',DnB_Active__c= true);
        insert new Pricing_Template__c(name='BIO');
        Profile profileObj = [select id from profile where name='System Administrator'];

         String profId = profileObj.id;
         user usrObj = new user(Username='abc123@officedepot.com.uat',FirstName ='Fname',
          LastName='Lname', Alias='abc123', CommunityNickname='abc123', LocaleSidKey='en_US', EmailEncodingKey='UTF-8', 
         Profileid = profId, LanguageLocaleKey='en_US', email='abc123@officedepot.com.uat',TimeZoneSidKey='America/New_York');
         usrObj.Short_Title__c='';
         Insert usrObj;
        
        
        list<string> lstrecordtypeId = new list<string>();
        Id Parent_RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Parent').getRecordTypeId();
        Id CustBizProTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Customer (Business Pro)').getRecordTypeId();
        Id GPRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('GrandParent').getRecordTypeId();
		Id GGPRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Great Grandparent').getRecordTypeId();
        Id SiteTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Site').getRecordTypeId();
        Id CustTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Customer').getRecordTypeId();
        Id ProspectTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Prospect').getRecordTypeId();
        Id SiteGTTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Site (GT)').getRecordTypeId();
        Id CustGTTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Customer (GT)').getRecordTypeId();
        Id ProspectGTTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Prospect (GT)').getRecordTypeId();
        //Id TypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('').getRecordTypeId();
		lstrecordtypeId.add(Parent_RecordTypeId);
        lstrecordtypeId.add(GPRecordTypeId);
        //lstrecordtypeId.add(GGPRecordTypeId);
        lstrecordtypeId.add(CustBizProTypeId);
        lstrecordtypeId.add(SiteTypeId);
        lstrecordtypeId.add(CustTypeId);
        lstrecordtypeId.add(ProspectTypeId);
        lstrecordtypeId.add(SiteGTTypeId);
        lstrecordtypeId.add(CustGTTypeId);
        lstrecordtypeId.add(ProspectGTTypeId);
        List<Account> lstParent = DataFactory.createAccountTestRecords('Test Account', 1, '');
        Account accParent;
        List<Account> lstAcc = DataFactory.createSpecificAccountRecords('Test Acc', lstParent[0].id, lstrecordtypeId);
        for(Account acc:lstAcc )
        {
            if(acc.RecordTypeId == Parent_RecordTypeId)	accParent = acc;
            //if(acc.RecordTypeId == SiteTypeId)	accSite = acc;
        }
        
        if(accParent != null)// && accSite != null)
        {
            Account accSite = new account(Related_Account__c = accParent.Id,Primary_Site__c = true, Name = 'site acc');
            insert accSite;
            
        }
        //insert new account(recordtypeid=GGPRecordTypeId, Name = 'GGP acc');
        
    }
    
    @isTest (SeeAllData=false)
    public static void testAccountInsert()
    {
        
        List<Sales_Person__c> lstSalesPersons = [select id from Sales_Person__c limit 2];
        list<Account> lstAccount = [select Id from Account limit 1];
        Id GPRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('GrandParent').getRecordTypeId();
        test.startTest();
        Account topAccount = new Account (name = 'GP SUN Test - Top Account',
                                          AOPS_Seq_ID__c = '942114',
                                          AOPS_Cust_Id__c = '942114',
                                          Oracle_Party_Id__c = '942114',
                                          recordtypeid=GPRecordTypeId,
                                          Billingcountry = 'USA',
                                          BillingState = 'UT',
                                          Primary_Site__c = true,
                                          Related_Account__c = lstAccount[0].id,
                                          Ownerid=UserInfo.getUserId(),
                                          Duns_Enrichment__c = '12345', 
                                          DNBI_CREDIT_OUTCOME__c = 'Approved',
                                          BillingStreet = '1040 N 326 W',
                                          billingcity = 'Orem',
                                          OMX_Primary_Key__c = 'Test_OMX_1111', //S-367255 [12/10/2015]- Fix test class 
                                          address2__c='8351 United States, 8207 Niaga',
                                          Sales_PersonID__c = lstSalesPersons[0].id);
        insert topAccount;
        system.assertEquals(lstAccount[0].id,topAccount.Related_Account__c);
        test.stopTest();
    }
    
     @isTest(SeeAllData=false)
    public static void testAccountUpdate()
    {
        list<user> lstUser = [select Id from user where Id != :userinfo.getUserId() limit 1];
        Id GPRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('GrandParent').getRecordTypeId();
        Id SiteGTTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Site (GT)').getRecordTypeId();
        Id SiteTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Site').getRecordTypeId();
        Id CustGTTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Customer (GT)').getRecordTypeId();
        Id ProspectGTTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Prospect (GT)').getRecordTypeId();
        Id Parent_RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Parent').getRecordTypeId();
        list<Account> lstAccount = [select Id,recordtypeid from Account ];
        Id ProspectTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Prospect').getRecordTypeId();
        List<Account> lstParent = [select Id,recordtypeid from Account where recordtypeid = :ProspectTypeId];
        integer iAllAccounts = 0;
        for(Account acc: lstAccount)
        {
            iAllAccounts += 1;
            if(acc.recordtypeid == SiteGTTypeId)	acc.recordtypeid = CustGTTypeId;
            else if(acc.recordtypeid == Parent_RecordTypeId)	
            {
                acc.Oracle_Party_ID__c = '1234';
                 acc.Aops_cust_id__C  = '123456889';
                insert new Contact(lastname='test cont',Accountid=acc.id,Primary_Contact__c=true);
            }
            else if(lstUser != null && lstUser.size() > 0 && acc.recordtypeid ==ProspectGTTypeId)	acc.ownerid= lstUser[0].id;
            else
            {
                acc.ownerid= lstUser[0].id;
                acc.DNBI_CREDIT_OUTCOME__c = 'Approved'; acc.Potential_Duplicate__c = false;
                acc.AccountSource = 'BSD Auto Account Setup';
                acc.Pricing_template_cd__c = 'BIO';
                if(acc.recordtypeid == SiteTypeId)	acc.Related_Account__c = lstParent[0].id;
                acc.DNBI_MatchScore__c = 6.0;
            }
        }
        test.startTest();
        
        update lstAccount;
        system.assertEquals(iAllAccounts,lstAccount.size());
        test.stopTest();
    }
    
    @isTest (SeeAllData=false)
    public static void testAccountDelete()
    {
        list<Account> lstAccount = [select id from Account limit 1];
        
        delete lstAccount[0];
        database.undelete(lstAccount);
    }
}