@isTest
Public class WRFCaseOpportunityError_TC
{
    Public Static testmethod void WRFCaseOpportunityError()
    {
        Account acc = new Account();
        acc.name='test';
        insert acc;
        
        Profile p4 = [SELECT Id FROM profile WHERE name='System Administrator'];   
        User u1 = new User(alias = 'test121', email='proxy@proxy56654.officedepot.com',OD_Employee_ID__c='225886',emailencodingkey='UTF-8', lastname='teOfficedepo',languagelocalekey='en_US',localesidkey='en_US',short_title__c = 'TSR', profileid = p4.Id,timezonesidkey='America/Los_Angeles',username='proxy@7878.com',isactive=true);
        insert u1;
        
        Opportunity opp = new opportunity();
        opp.accountid=  acc.id;
        opp.Name='Testopp';
        opp.product__c = 'K-12 Growth';
        opp.StageName='90%-Execute';
        opp.CloseDate=System.today();
        opp.Last_Stage_Change__c=DateTime.newInstanceGMT(2016,5, 29, 2, 2, 3);
        opp.Watson_Door_Opener__c=true;
        opp.amount=123.45;
        opp.PLOC_Opportunity_Stage__c='Identify Prospect (1.0)';
        opp.Product_Subtype__c='Other Equipment';
        opp.ownerId=u1.id;          
        opp.Watson_Notes__C='My text';
        insert opp;
        
         Map<String,Schema.RecordTypeInfo> CaseRecType = Schema.SObjectType.Case.getRecordTypeInfosByName();
        id WRFRecordTypeId = CaseRecType.get('Work Request').getRecordTypeId(); 
        
        Case C= New Case();
        C.RecordTypeId=WRFRecordTypeId;
        Insert C;
        
        Case C1= New Case();
        C1.RecordTypeId=WRFRecordTypeId;
        C1.WRF_Opportunity__c =Opp.Id;
        Insert C1;
        
        C.WRF_Opportunity__c =Opp.Id;
        try
        {
        Update C;
        }
        catch(Exception e)
        {}
        
    }
}