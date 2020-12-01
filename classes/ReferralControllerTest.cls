@isTest
private class ReferralControllerTest {

@isTest(seeAllData = True)
static void saveReferralTest(){

RecordType rt = [select id,Name from RecordType where SobjectType='Account' and DeveloperName='Customer' Limit 1];

Account acc = new Account();
acc.Name = 'TestAccount';
insert acc;

Account acc1 = new Account();
acc1.Name = 'TestAccount';
acc1.recordTypeID= rt.id;
insert acc1;

Contact con1 = new contact();
con1.FirstName = 'ConFirstName';
con1.LastName = 'ConLastName';
con1.AccountID = acc.id;
con1.Email = 'Test@gmail.com';
insert con1;

Contact con2 = new contact();
con2.FirstName = 'ConFirstName2';
con2.LastName = 'ConLastName2';
con2.AccountID = acc1.id;
con2.Email = 'Test2@gmail.com';
insert con2;

String s = Con2.id;

Third_Party_Referrals__c TPR = new Third_Party_Referrals__c();



ReferralController.initHelperMeth(con1.id);
ReferralController.saveReferral(TPR, s);



}



}