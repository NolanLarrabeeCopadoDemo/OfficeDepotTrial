@isTest
private class scheduleAccountProfileTaxDelete_TC {
  static testmethod void test1() {
    Test.startTest();
    String CRON_EXP = '0 0 0 15 3 ? 2022';
    String jobId = System.schedule('scheduleAccountProfileTaxDelete',CRON_EXP,new scheduleAccountProfileTaxDelete());
    CronTrigger ct = [SELECT Id, CronExpression, TimesTriggered,NextFireTime FROM CronTrigger WHERE id = :jobId];
    System.assertEquals(CRON_EXP,ct.CronExpression);
    System.assertEquals(0, ct.TimesTriggered);
    System.assertEquals('2022-03-15 00:00:00',String.valueOf(ct.NextFireTime));
    Test.stopTest();
   }
}