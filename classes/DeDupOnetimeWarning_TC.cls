/**
 * Created by Najma Ateeq for Story #S-331356
 */
@isTest
private class DeDupOnetimeWarning_TC {
	static Opportunity opp = new Opportunity();
	static Contact cnt = new Contact();
    static testMethod void myUnitTest() {
       createTestData();
       DeDupOnetimeWarning.getFieldValues(opp.Id);
       DeDupOnetimeWarning.getFieldValues(cnt.Id);
       DeDupOnetimeWarning.SetNullValues(opp.Id);
       DeDupOnetimeWarning.SetNullValues(cnt.Id);
    }
    public  static void createTestData(){
    	 Map<String,Schema.RecordTypeInfo> AccRecType = Schema.SObjectType.Account.getRecordTypeInfosByName();
    	 
    	 Account acc = new Account ();
        acc.name = 'SUN Test Account';
        acc.BillingStreet = '1040 N 326 W';
        acc.billingcity = 'Orem';
        acc.BillingState = 'UT';
        acc.Billingcountry = 'USA';
        acc.Oracle_Party_Id__c = '123456';
        acc.AOPS_Cust_Id__c = '123456';
        acc.RecordtypeId = AccRecType.get('Prospect').getRecordTypeId();
        acc.AOPS_Seq_ID__c = '123456';
       // acc.OwnerID = '005E0000000lNbV';// This is the salesforce User ID
        //acc.Sales_PersonID__c = 'a0AE0000000GGMn'; //Sales person Id for the Salesforce USer
        insert acc;
        
	    opp.accountid =  acc.id;
	    opp.Name = acc.Name;
	    opp.product__c = 'tech';
	    opp.StageName = '90%-Execute';
	    opp.CloseDate = System.today().addDays(1);
	    insert opp;
	    
	    DMND_Potential_Warning__c pdw = new DMND_Potential_Warning__c(Warning_Key__c = 'test');
        insert pdw;
	    DMND_Duplicate__c dup3 = new DMND_Duplicate__c(Potential_Duplicate_Warning__c = pdw.id, Disposition__c = 'Delete', Opportunity__c = opp.id);
        insert dup3;
        
        cnt = new contact(lastname= 'test',AccountId = acc.id);
        insert cnt;
        
        DMND_Duplicate__c dup2 = new DMND_Duplicate__c(Potential_Duplicate_Warning__c = pdw.id, Disposition__c = 'Merge', Contact__c = cnt.id);
        insert dup2;
    }
}