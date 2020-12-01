@Istest
private class ContactDeltaAssignments_Batch_TC
{
static testMethod void ContactDeltaAssignments_Batch_TC()
{

List<Contact_Delta_Assignment__c> List_contactAss = new List<Contact_Delta_Assignment__c>();
List<Account> List_Acc = new List<Account>();
Account A2 = new Account();
A2.Name='Test';
A2.AOPS_Cust_Id__c ='123';
insert A2;


Account acc = new Account();
acc.AOPS_Cust_Id__c ='6583';
acc.OMX_Primary_Key__c='271991';
acc.Name='Test';
insert acc;

List<Contact> CL = new List <Contact>();

Contact c1 = new Contact();
c1.LastName='LastNametest';
c1.email='testemail@test.com';
c1.AccountId = acc.id;
c1.OMX_primary_key__c='271991';
//c1.Pin__c='349';
insert c1;
Account acc1 = new Account();
acc1.AOPS_Seq_ID__c = '6583-0087';
acc1.OMX_Primary_Key__c='271901';
acc1.Site_Primary_Contact__c = c1.id;
acc1.Site_Contact2__c = c1.id;
acc1.Site_Contact3__c = c1.id;
acc1.Site_Contact4__c = c1.id;
acc1.Site_Contact5__c = c1.id;
acc1.Site_Contact6__c = c1.id;
acc1.Related_Account__c = acc.id;
acc1.Name='Test';
insert acc1;


Contact c2 = new Contact();
c2.LastName='LastiytrNametest';
c2.email='testeml@test.com';
c2.AccountId = acc.id;
c2.OMX_primary_key__c='271990';
c2.Pin__c='';
//insert c2;
CL.add(c2);
Contact c3 = new Contact();
c3.LastName='LastiytrNametest1';
c3.email='testeml@test1.com';
c3.AccountId = acc.id;
c3.OMX_primary_key__c='271992';
//insert c3;
CL.add(c3);

Contact c4 = new Contact();
c4.LastName='LatrNametest1';
c4.email='testempol@test1.com';
c4.AccountId = acc.id;
c4.OMX_primary_key__c='271993';
//insert c4;
CL.add(c4);

Contact c5 = new Contact();
c5.LastName='Lametest1';
c5.email='testemkel@test1.com';
c5.AccountId = acc.id;
c5.OMX_primary_key__c='271994';
//insert c4;
CL.add(c5);

Contact c6 = new Contact();
c6.LastName='Lameteskweqt1';
c6.email='testnekel@test1.com';
c6.AccountId = acc.id;
c6.OMX_primary_key__c='271995';
//insert c4;
CL.add(c6);

Contact c7 = new Contact();
c7.LastName='Llseskweqt1';
c7.email='temqkel@test1.com';
c7.AccountId = acc.id;
c7.OMX_primary_key__c='271800';
//insert c4;
CL.add(c7);



Contact_Delta_Assignment__c cda1 = new Contact_Delta_Assignment__c();
cda1.OMX_Site_key__c='271901';
cda1.OMX_Site_Contact1__c='271990';
cda1.OMX_Site_Contact2__c='1111';
cda1.OMX_Site_Contact3__c='1111';
cda1.OMX_Site_Contact4__c='1111';
cda1.OMX_Site_Contact5__c='1111';
cda1.OMX_Site_Contact6__c='1111';
cda1.OMX_Site_Contact7__c='1111';
cda1.OMX_Site_Contact8__c='1111';
cda1.OMX_Site_Contact9__c='1111';
cda1.OMX_Site_Contact10__c='1111';
cda1.Status__c='open'; 
   insert cda1;
   
Contact_Delta_Assignment__c cda = new Contact_Delta_Assignment__c();
cda.OMX_Site_key__c='271900';
cda.OMX_Site_Contact1__c='271800';
cda.Status__c='open'; 
   insert cda;
Contact_Delta_Assignment__c cda2 = new Contact_Delta_Assignment__c();
cda2.OMX_Site_key__c='271901';
cda2.OMX_Site_Contact1__c='271990';
cda2.OMX_Site_Contact2__c='271992';
cda2.Status__c='open'; 
   insert cda2;
Contact_Delta_Assignment__c cda3 = new Contact_Delta_Assignment__c();
cda3.OMX_Site_key__c='271901';
cda3.OMX_Site_Contact1__c='271990';
cda3.OMX_Site_Contact2__c='271992';
cda3.OMX_Site_Contact3__c='271993';
cda3.Status__c='open'; 
   insert cda3;

Contact_Delta_Assignment__c cda4 = new Contact_Delta_Assignment__c();
cda4.OMX_Site_key__c='271901';
cda4.OMX_Site_Contact1__c='271990';
cda4.OMX_Site_Contact2__c='271992';
cda4.OMX_Site_Contact3__c='271993';
cda4.OMX_Site_Contact4__c='271994';
cda4.Status__c='open'; 
   insert cda4;
   
Contact_Delta_Assignment__c cda5 = new Contact_Delta_Assignment__c();
cda5.OMX_Site_key__c='271901';
cda5.OMX_Site_Contact1__c='271990';
cda5.OMX_Site_Contact2__c='271992';
cda5.OMX_Site_Contact3__c='271993';
cda5.OMX_Site_Contact4__c='271994';
cda5.OMX_Site_Contact4__c='271995';
cda5.Status__c='open'; 
   insert cda5;
   
Contact_Delta_Assignment__c cda6 = new Contact_Delta_Assignment__c();
cda6.OMX_Site_key__c='271901';
cda6.Status__c='open'; 
   insert cda6;

/*Contact_Delta_Assignment__c cda2 = new Contact_Delta_Assignment__c();
cda2.OMX_Site_key__c='271990';
cda2.OMX_Site_Contact1__c=c2.id;
cda2.OMX_Site_Contact2__c=c2.id;
cda2.OMX_Site_Contact3__c=c2.id;
cda2.OMX_Site_Contact4__c=c2.id;
cda2.OMX_Site_Contact5__c=c2.id;
cda2.OMX_Site_Contact6__c=c2.id;
cda2.Status__c='open'; 
   insert cda2;*/

//insert List_Acc;
//insert List_contactAss;
Insert CL;
test.starttest();
ContactDeltaAssignments_Batch cab = new ContactDeltaAssignments_Batch ();
String qry='Select Id,OMX_Site_key__c,OMX_Site_Contact1__c,OMX_Site_Contact2__c,OMX_Site_Contact3__c,OMX_Site_Contact4__c,OMX_Site_Contact5__c,OMX_Site_Contact6__c,Status__c,' 
    +' Error__c from Contact_Delta_Assignment__c where Status__c != \'Processed\'';

ContactDeltaAssignments_Batch cab1 = new ContactDeltaAssignments_Batch(qry);
database.executebatch(cab1);

String CRON_EXP = '0 0 0 3 9 ? 2022';    
System.schedule('Assignment Batch',CRON_EXP , cab1 );

test.stoptest();
}
}