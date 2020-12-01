@isTest
public class AccountTriggers_TC
{
    @testSetup
    public static void testSetup1()
	{
		RecordType rr = [select id from recordtype where sobjecttype='Account' and developername='Prospect'];
		Account acc = new Account();
		acc.name='test1';
		acc.recordtypeId=rr.id;
		acc.Oracle_Party_ID__c='test12asdq';
        acc.Duns_Enrichment__c='asdaxz';
        acc.DNBI_CREDIT_OUTCOME__c='mzlkas';
		Insert acc;
    }
    
    @isTest
    public static void test()
	{
        RecordType rpros = [select id from recordtype where sobjecttype='Account' and developername='Prospect'];
        sales_person__c  SP=New sales_person__c();
        SP.Name='Test Sales Person';
        SP.User__c=userinfo.getuserid();
        Insert SP;
        
        DNBI_Credentials__c dnbi = new DNBI_Credentials__c(Name = 'Test123',DnB_Active__c=true);
		insert dnbi;

        Account acct = Test_Utils.CreateAccount('Customer');
        acct.recordtypeid=rpros.id;
        acct.oracle_party_id__c='1234';
        executeoncetest.DNBItrigger = true;
        insert acct;
        
        executeoncetest.DNBItrigger = true;
        update acct;
        
        RecordType r = [select id from recordtype where sobjecttype='Account' and developername='GrandParent'];
        RecordType r2 = [select id from recordtype where sobjecttype='Account' and developername='Site'];
		List<Account> accountsToInsert = new List<Account>();
        Account accgp = new Account();
		accgp.name='testGP';
		accgp.recordtypeId=r.id;
		accgp.description='old desc';
		accgp.aops_cust_id__c='1001';
		accgp.status__c='Active';
		accgp.Sales_PersonID__c=SP.id;
		accountsToInsert.add(accgp);
		
		Account accgp2 = new Account();
		accgp2.name='testGP2';
		accgp2.recordtypeId=r.id;
		accgp2.description='old desc';
		accountsToInsert.add(accgp2);

		Account accgp3 = new Account();
		accgp3.name='testGP3';
		accgp3.recordtypeId=r2.id;
		accgp3.description='old desc';
		accgp3.Primary_Site__c=true;
		accountsToInsert.add(accgp3);

		insert accountsToInsert;
		
		accgp.description='new desc';
		accgp.status__c='Inactive';
		accgp.implementation_manager__c=userinfo.getuserid();
		update accgp;
    }

    @isTest
    public static void test1()
	{
        sales_person__c  SP=New sales_person__c();
        SP.Name='Test Sales Person';
        SP.User__c=userinfo.getuserid();
        Insert SP;
        
        DNBI_Credentials__c dnbi = new DNBI_Credentials__c(Name = 'Test123',DnB_Active__c=true);
		insert dnbi;
              
		account acc = [select id,Disposition__c from account limit 1];
		acc.Disposition__c='test1as';
        update acc;
    }
}