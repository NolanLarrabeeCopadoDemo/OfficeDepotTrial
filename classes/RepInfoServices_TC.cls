@isTest()

private class RepInfoServices_TC {   
 static testMethod void myUnitTest()  
    {
     Test.startTest();
//Insert the User record
Profile p=new Profile();

p=[select id from profile where name= 'System administrator'];
User u1 = new User(Alias= 'newUser', Email='shradha.jain1@wipro.com', EmailEncodingKey='UTF-8', OD_Employee_ID__c= '12', FirstName= 'test', LastName='Testing', LanguageLocaleKey='en_US', 
Short_Title__c= 'test title', title='Mr',  Phone= '1234', LocaleSidKey='en_US', ProfileId = p.Id, TimeZoneSidKey='America/Los_Angeles', UserName='demo1@wipro.com',Country='india'); 
insert u1;
        system.runas(u1){
Account re= new Account(aops_cust_id__c='1178664', name='test1', sector__c= 'test sectr', segment__c='test segment', Sic='test' );
insert re;

Account acct=new Account(related_account__c=re.id, name='test2', aops_seq_id__c='12345' );

insert acct;
accountteammember accountTeam= new accountteammember(AccountId = acct.Id, UserId =u1.Id );
insert accountTeam;
list<repinformationService.repinfo> result = repinformationService.doGet();
repinformationService ris = new repinformationService();
RestRequest req = new RestRequest(); 
RestResponse res = new RestResponse();

req.requestURI = 'https://officedepot--uat.cs7.my.salesforce.com/repInfo/'+acct.aops_seq_id__c;  
req.httpMethod = 'GET';
RestContext.request = req;
RestContext.response = res;

list<repinformationService.repinfo> results  =repinformationService.doGet();

 Test.stopTest();
        }
}
}