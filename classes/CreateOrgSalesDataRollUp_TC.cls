@isTest(seealldata=true)

public class CreateOrgSalesDataRollUp_TC {
static testMethod void testMethod1()
{
    Org__c lko = new Org__c();
    insert lko;
    
   	Sales_Data__C sd = new Sales_Data__C();
    sd.copiers__C = 12345;
    sd.org__C = lko.id;
    sd.Parent_Org__c = lko.id ;
    sd.Account_Type__c = 'Org';
    sd.BatchProcessed__c = true;
    insert sd;
    
    test.startTest();
    CreateOrgSalesDataRollUp SentDNSProcessingBatchObj = new CreateOrgSalesDataRollUp ();
        database.executebatch(SentDNSProcessingBatchObj);
    test.stopTest();
}
}