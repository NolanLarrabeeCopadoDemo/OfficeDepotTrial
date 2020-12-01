@isTest(SeeAllData=true)
public class Prospect_AddValidation_Batch_TC
{

public static testMethod void Prospect_AddValidation_Batch_TC()
{
    Schema.DescribeSObjectResult d1 = Schema.SObjectType.Account; 
    Map<String,Schema.RecordTypeInfo> RecType = d1.getRecordTypeInfosByName();
    
       Account acc=new Account();
       acc.name = 'Ank Test Account1';
       acc.RecordTypeId=RecType.get('Prospect').getRecordTypeId();
       acc.Address1__c = '4785 S Citation Drive';
       acc.Address2__c = '202';
       acc.City__c = 'Delray Beach';
       acc.State__c = 'FL';
       acc.zip__c ='33351';
       acc.Country__c = 'USA';
       acc.Address_Validation_Error__c='No';
       acc.Address_Validated__c=true;
       acc.Auto_Assign__c=true;
       insert acc;  
       
       String q ='select id, Name,address1__c,Address_Validation_Error__c,Address_Validated__c,address2__c,City__c,state__c,country__c,zip__c from Account Where RecordType.Name =\'Prospect\' limit 10';
       Prospect_AddValidation_Batch obj = new Prospect_AddValidation_Batch(q);
       Database.executeBatch(obj,10);
       String CRON_EXP = '0 0 0 3 9 ? 2022';  
       System.schedule('Assignment Batch',CRON_EXP , obj );

}
}