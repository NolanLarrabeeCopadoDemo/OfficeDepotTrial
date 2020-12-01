@isTest
Public class DMLRelationHistoryClass_TC
{
    Public Static testmethod void DMLRelationHistoryClass()
    {
            
            DML_Relation__c DR=New DML_Relation__c(CUSTOMERID__c='54321',DECISIONMAKERID__c='1234',Effective_Start_Date__c=system.today(),Effective_End_Date__c=system.today().adddays(2));
            Insert DR;
           
              DML_Relation_History__c DRHold=New DML_Relation_History__c(DML_Relationship__c = DR.id,Effective_Start_Date__c=system.today().adddays(-2));
                    
              Insert DRHold;
             Datetime yesterday = Datetime.now().addDays(-1);
             Test.setCreatedDate(DRHold.Id, yesterday);
            
            DML_Relation_History__c DRH=New DML_Relation_History__c(DML_Relationship__c = DR.id,Effective_Start_Date__c=system.today());
                    
            Insert DRH;
    }
}