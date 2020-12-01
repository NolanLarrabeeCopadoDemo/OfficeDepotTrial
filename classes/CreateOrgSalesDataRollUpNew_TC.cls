@isTest(seealldata=true)
public class CreateOrgSalesDataRollUpNew_TC {
static testMethod void testMethod2()
{
            
    Org__c org= new Org__c();
    org.Business_Name__c='New Org';
    //org.SalesDataBatch__c= true;
    org.Batch_Org_Sales__C=true;
    insert org;
    
    Org__C org1 = new Org__c();
    org1.Business_Name__c='last Org'; 
    //org1.SalesDataBatch__c= true;
    org1.Batch_Org_Sales__C=true;
    org1.Parent_Org__c = org.id;
    insert org1; 
    
    /*org__c org2 = new Org__c();
    org1.Business_Name__c='last2 Org';
    org2.Batch_Org_Sales__C=false;
    org1.Parent_Org__c = org1.id;
    insert org2;*/
    
    Sales_Data__C sd1 = new Sales_Data__C();
    sd1.copiers__C = 12225;
    sd1.org__C = org.id;
    sd1.Parent_Org__c = org1.id ;
    sd1.Account_Type__c = 'Org';
    sd1.BatchProcessed__c = true;
    insert sd1;
    
    //String DEFAULT_QUERY ='Select id ,Batch_Org_Sales__C,Parent_Org__c FROM Org__c WHERE  Batch_Org_Sales__C=true  Limit 50000'; 
    test.startTest();
    CreateOrgSalesDataRollUpNew SentDNSProcessingBatchObj = new CreateOrgSalesDataRollUpNew();
    database.executebatch(SentDNSProcessingBatchObj);
    test.stopTest(); 
}
}