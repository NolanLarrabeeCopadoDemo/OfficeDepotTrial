global class scheduleAccountProfileTaxDelete implements Schedulable {
  global void execute(SchedulableContext sc) {
    ID taxCertRecType = [SELECT Id FROM recordtype where sObjectType ='Account_Profile__c' and name = 'TaxCertStatus'].Id;
    String query = 'SELECT Id FROM Account_Profile__c ' +
                   'WHERE RecordTypeId = \'' + taxCertRecType + '\' and LastModifiedDate <= Yesterday LIMIT 100';
    batchDeleteRecords bdr = new batchDeleteRecords(query);
    Database.executeBatch(bdr);
  }  
}