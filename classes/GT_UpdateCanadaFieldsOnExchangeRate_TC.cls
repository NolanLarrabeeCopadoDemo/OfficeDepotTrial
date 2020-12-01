@isTest
public class GT_UpdateCanadaFieldsOnExchangeRate_TC
{
    
    public static testMethod void GT_UpdateCanadaFieldsOnExchangeRate_Test() 
    {
    
    Exchange_Rate__c newExRate = new Exchange_Rate__c();
    newExRate.Rate__c = '10';
    insert newExRate;
    
    Lead testLead = new Lead();
    Opportunity testOppt = new Opportunity();
    //testLead.name = 'Test Lead';
    testLead.Amount_CAD__c = 1300;
    testLead.Amount__c = 14;
    //Recordtype leadCanadaRecType = [select id,name from recordtype where name='Lead (Canada)'];
    testLead.recordtypeid = Label.GTLead;
    testLead.isConverted = false;
    testLead.LastName = 'Test Last Name';
    testLead.Company = 'Test Company Name';
    insert testLead;
    
    testOppt.name = 'Test Oppt';
    testOppt.Committed_Forecast_CAD__c = 1200;
    testOppt.Committed_Forecast__c = 15;
    testOppt.Amount_CAD__c = 1100;
    testOppt.Amount = 16;
    Recordtype OpptRecType = [select id,name,sobjecttype from recordtype where name='GT Field Sales' and SobjectType='Opportunity'];
    testOppt.recordtypeid = OpptRecType.id;
    testOppt.status__c = 'Open';
    testOppt.StageName = '90%-Execute';
    Date yesterday = Date.Today();
    yesterday = yesterday.addDays(-1);
    testOppt.CloseDate = yesterday;
    insert testOppt;
    

    GT_UpdateCanadaFieldsOnExchangeRate.updateLead('100');
    GT_UpdateCanadaFieldsOnExchangeRate.updateOpportunity('100');
    }
}