@isTest
private class GenerateWebLead_TC
{
    static testMethod void myUnitTest()
    {
    Lead lead = Test_Utils.GenerateLead('12346', 100, null, 'LName1', false);
    insert lead;
    ApexPages.StandardController sc = new ApexPages.standardController(lead);
    GenerateWebLead gn = new GenerateWebLead(sc);
    gn.getLead();
    gn.getWCBcount();
    gn.setWCBcount('5');
    PageReference pr = gn.save();
    System.assertEquals(ApexPages.getMessages().isEmpty(), false);
    }

    static testMethod void myUnitTest1()
    {
    Lead lead = Test_Utils.GenerateLead('12346', 100, null, 'LName1', false);
    lead.email='abc@wipro.com';
    lead.phone='9876524251';
    lead.Chamber_of_Commerce_Member__c = 'Yes';//S-420975 (OD 00731428) [Hemant 7/1/2016] - Increase code coverage

    ApexPages.StandardController sc = new ApexPages.standardController(lead);
    GenerateWebLead gn = new GenerateWebLead(sc);
    gn.getLead();
    gn.getWCBcount();
    gn.setWCBcount('56-');
    PageReference pr = gn.save();
    System.assertEquals(ApexPages.getMessages().isEmpty(), true);
    //START S-420975 (OD 00731428) [Hemant 7/1/2016] - Increase code coverage
    //For exception coverage
    gn.setWCBcount('56+');
    pr = gn.save();
    //END S-420975 (OD 00731428) [Hemant 7/1/2016] - Increase code coverage
    }

    //Modified By Vipul for Story #S-445693(00802435 - BP Enhancement - Digital Lead Form) on October 26, 2016
    //START
    static testMethod void myUnitTest2(){
    List<User> lstUser= [select id, roleId__c,isActive,Profile.Name from user where isActive = true And profile.userLicense.name = 'Salesforce' AND Profile.Name='Business Pro Rep' limit 1];
    system.debug('====>'+lstUser[0].isActive+'===='+lstUser[0].Profile.Name);
    test.startTest();
    Store__c store = new Store__c();
    store.OwnerId = lstUser[0].id;
    store.ID__c = '001234';
    store.City__c='FL';
    store.Name = '001234:TEST';
    insert store;
    system.debug('===='+store.Id);
    Lead lead = Test_Utils.GenerateLead('12346', 100, null, 'LName1', false);
    lead.Lead_Source__c = 'Business Pro';
    lead.email='abc@wipro.com';
    lead.phone='9876524251';
    lead.Employee_Name__c = 'Test';
    lead.Chamber_of_Commerce_Member__c = 'Yes';
    ApexPages.StandardController sc = new ApexPages.standardController(lead);
    GenerateWebLead gn = new GenerateWebLead(sc);
    gn.getLead();
    gn.getWCBcount();
    gn.setWCBcount('56-');
    gn.lead.Lead_Source__c = 'Business Pro';
    gn.lead.store__c = store.id;
    PageReference pr = gn.save();
    System.assertEquals(ApexPages.getMessages().isEmpty(), true);
    gn.setWCBcount('56+');
    pr = gn.save();
    //
    User user2 = new User();
 //   user2.Name = 'Rod Phillips';
    gn.lead.Lead_Source__c = 'FOS';
    pr = gn.save();
    //
    test.stopTest();
    }
    //END

}