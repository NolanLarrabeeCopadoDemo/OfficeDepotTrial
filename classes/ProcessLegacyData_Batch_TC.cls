@Istest
private class ProcessLegacyData_Batch_TC
{
static testMethod void ProcessLegacyData_Batch_TC()
{


Account acc = new Account();
acc.AOPS_Cust_Id__c ='6583';
acc.OMX_primary_key__c='271991';
acc.Name='Test';
insert acc;

contact c1 = new Contact();
c1.LastName='LastNametest';
c1.email='testemail@test.com';
c1.AccountId = acc.id;
insert c1;
Account acc1 = new Account();
acc1.AOPS_Seq_ID__c = '6583-0087';
acc1.Related_Account__c = acc.id;
acc1.Name='Test';
insert acc1;


Legacy_Delta__c LD= new Legacy_Delta__c();
LD.N_Body__c='ASDFGH';
LD.N_Legacy_Created_Date__c='';
LD.N_ISPRIVATE__c=False;
LD.N_ParentId__c='271991';
LD.N_ParentId_Type__c='Account';
LD.N_Title__c='';
LD.T_CallType__c='';
LD.T_RecurrenceDayOfMonth__c=5;
LD.T_Subject__c='aseryttr';
LD.T_CallDurationInSeconds__c=15;
LD.T_RecurrenceTimeZoneSidKey__c='';
LD.T_CallObject__c ='';
LD.LastModifiedByName__c='Niraj';
LD.status__c='open';  
LD.SFDC_ID__c='';
LD.T_WhoId__c=acc.id; 
LD.T_WhoId_Type__c='Account';
LD.T_WhatId__c=acc.id;
LD.T_WhatId_Type__c='Account';
LD.OMX_primary_key__c='271991';
LD.OwnerRepNumber__c='6351';


insert LD;

Legacy_Delta__c LD1= new Legacy_Delta__c();
LD1.N_Body__c='ASDFGH';
LD1.N_Legacy_Created_Date__c='';
LD1.N_ISPRIVATE__c=False;
LD1.N_ParentId__c='271991';
LD1.N_ParentId_Type__c='Account';
LD1.N_Title__c='';
LD1.T_CallType__c='';
LD1.T_RecurrenceDayOfMonth__c=5;
LD1.T_Subject__c='aseryttr';
LD1.T_CallDurationInSeconds__c=15;
LD1.T_RecurrenceTimeZoneSidKey__c='';
LD1.T_CallObject__c ='';
LD1.LastModifiedByName__c='Niraj';
LD1.status__c='open';  
LD1.SFDC_ID__c='';
LD1.T_WhoId__c=acc.id; 
LD1.T_WhoId_Type__c='Account';
LD1.T_WhatId__c='';
LD1.T_WhatId_Type__c='';
//LD.OMX_primary_key__c='271991';
LD1.OwnerRepNumber__c='6351';


insert LD1;
test.starttest();
ProcessLegacyData_Batch cab = new ProcessLegacyData_Batch();
String qry='Select id,N_Body__c,OMX_primary_key__c,N_Legacy_Created_Date__c,N_ISPRIVATE__c,N_ParentId__c,N_ParentId_Type__c,N_Title__c,T_CallType__c ,T_ReminderDateTime__c ,T_RecurrenceDayOfMonth__c ,T_Subject__c ,T_CallDurationInSeconds__c ,T_RecurrenceTimeZoneSidKey__c ,T_CallObject__c ,LastModifiedByName__c ,LastModifiedDate__c ,T_CallDisposition__c ,T_IsRecurrence__c ,T_RecurrenceDayOfWeekMask__c ,T_IsReminderSet__c ,createdDate__c ,T_Status__c ,T_RecurrenceInterval__c ,T_RecurrenceInstance__c ,T_ActivityDate__c ,T_RecurrenceType__c ,T_RecurrenceEndDateOnly__c ,T_RecurrenceMonthOfYear__c ,T_RecurrenceStartDateOnly__c ,CreatedByName__c ,T_Priority__c ,E_Description__c , T_WhoId_Type__c,T_WhoId__c,T_WhatId__c,T_WhatId_Type__c,OwnerRepNumber__c,SFDC_ID__c  from Legacy_Delta__c where status__c =\'Open\' and SFDC_ID__c=null';

ProcessLegacyData_Batch cab1 = new ProcessLegacyData_Batch(qry);
database.executebatch(cab1);

String CRON_EXP = '0 0 0 3 9 ? 2022';    
System.schedule('Assignment Batch',CRON_EXP , cab1 );

test.stoptest();
}
}