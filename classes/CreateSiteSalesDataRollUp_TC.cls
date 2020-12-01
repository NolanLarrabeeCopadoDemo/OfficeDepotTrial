@isTest(seealldata=false)
public class CreateSiteSalesDataRollUp_TC {

private static testMethod void MyunitTest() {  
    
    CustTransParentChildLevel__c PCLevel2 = new CustTransParentChildLevel__c ();
    PCLevel2 .name='Test';
    PCLevel2.SentDNSProcessingBatchInterval__c=100;
            insert PCLevel2 ;
    
    
    
    Org__c Org = new Org__c();
    Org.Business_Name__c='NewOrg';
    Org.SalesDataBatch__c=true;
    insert Org;
    
    Sales_Data__C SD = new Sales_Data__C();
    SD.org__C = Org.id;
    SD.account_Type__c='Site';
    insert SD;
    
     test.startTest();
        String strQuery = '';
        CreateSiteSalesDataRollUp testRec= new CreateSiteSalesDataRollUp (strQuery);
        database.executebatch(testRec, 100);
    test.stopTest();
    
 }
}