@isTest 

private class GNT_Contact_Batch_Test{
static testMethod void validate_GNT_Contact_Batch()
{
 GTContact_Delta__c gtc = new GTContact_Delta__c();
    gtc.name='Niraj';
    gtc.processed_status__c='Open';
    gtc.Account_OMX_Primary_Key__c='NZE-11051';
    gtc.Contact_OMX_primary_key__c='NZE-10051';         
 insert gtc; 
 
 GTContact_Delta__c gtc1 = new GTContact_Delta__c();
    gtc1.name='Abha';
    gtc1.processed_status__c='Error';
    gtc1.Account_OMX_Primary_Key__c='NZE-12451';
    gtc1.Contact_OMX_primary_key__c='NZE-12451';         
 insert gtc1; 
 
  GTContact_Delta__c gtcMAX = new GTContact_Delta__c();
    gtcMAX.name='Test Contact';
    gtcMAX.processed_status__c='Open';
    gtcMAX.Account_OMX_Primary_Key__c='NZE-11051';
    gtcMAX.Contact_Source__c= 'MAX'  ;      
 insert gtcMAX ; 
 
 
 
 
 Account acc= new Account();
        acc.OMX_Primary_Key__c='NZE-11051';
      //  acc.Related_Account__c=
        acc.name = 'SUN Test Account';
        acc.BillingStreet = '1040 N 326 W';
        acc.billingcity = 'Orem';
        acc.BillingState = 'UT';
        acc.Billingcountry = 'USA';
        acc.Oracle_Party_Id__c = '123456';
        acc.AOPS_Cust_Id__c = '123456';
        acc.AOPS_Seq_ID__c = '123456';
        acc.OwnerID = '005E0000000lNbV';// This is the salesforce User ID
        acc.Sales_PersonID__c = 'a0AE0000000GGMn'; //Sales person Id for the Salesforce USer   
 insert acc;
 
  Account acc1= new Account();
        acc1.OMX_Primary_Key__c='NZE-11000';
        acc1.Related_Account__c=acc.id;
        acc1.name = 'SUN Test Account';
        acc1.BillingStreet = '1040 N 326 W';
        acc.billingcity = 'Orem';
        acc1.BillingState = 'UT';
        acc1.Billingcountry = 'USA';
       
      //  acc.OwnerID = '005E0000000lNbV';// This is the salesforce User ID
       // acc1.Sales_PersonID__c = 'a0AE0000000GGMn'; //Sales person Id for the Salesforce USer   
 insert acc1;
 
 GTContact_Delta__c gtc9 = new GTContact_Delta__c();
    gtc9.name='Nirajabc';
    gtc9.SFDC_Id__c =''; 
    gtc9.processed_status__c='Process Max';
    gtc9.Account_OMX_Primary_Key__c='NZE-11000';
    gtc9.Contact_OMX_primary_key__c='NZE-12441';         
 insert gtc9;
 
 Contact con = new Contact();
    con.lastname='Sinha';
    con.OMX_Primary_Key__c='NZE-10051';
    con.AccountId = acc.id;                
 insert con;
 
 Contact con1 = new Contact();
    con1.lastname='Rani';
    con1.OMX_Primary_Key__c='NZE-12451';
    con1.AccountId = acc.id;                
 insert con1;
 Contact con2 = new Contact();
    con2.lastname='Rani';
    con2.OMX_Primary_Key__c='NZE-12441';
    con2.AccountId = acc.id;                
// insert con2;
 
 
 
 GTContact_Delta__c gtc2 = new GTContact_Delta__c();
    gtc2.name='Niraj';
    gtc2.SFDC_Id__c =''; 
    gtc2.processed_status__c='Open';
    gtc2.Account_OMX_Primary_Key__c='NZE-11051';
    gtc2.Contact_OMX_primary_key__c='NZE-12441';         
 insert gtc2;
 
 GTContact_Delta__c gtc3 = new GTContact_Delta__c();
    gtc3.name='Niraj';
    gtc3.SFDC_Id__c =con1.id; 
    gtc3.processed_status__c='Open';
    gtc3.Account_OMX_Primary_Key__c='NZE-11051';
    gtc3.Contact_OMX_primary_key__c='NZE-12441';         
 insert gtc3;  
 
 account acc2= new account();
 acc2.OMX_Primary_Key__c='NZE-11251';
        acc2.name = 'SUN Test account';
        acc2.BillingStreet = '1040 N 326 W';
        acc2.billingcity = 'Orem';
        acc2.BillingState = 'UT';
        acc2.Billingcountry = 'USA';
        acc2.Oracle_Party_Id__c = '1234567';
        acc2.AOPS_Cust_Id__c = '1234567';
        acc2.AOPS_Seq_ID__c = '1234567';
        acc2.OwnerID = '005E0000000lNbV';// This is the salesforce User ID
        acc2.Sales_PersonID__c = 'a0AE0000000GGMn'; //Sales person Id for the Salesforce USer
   
 insert acc2;
 
 
 /*Contact con2 = new Contact();
    con2.lastname='Sinha';
    con2.OMX_Primary_Key__c=null;
    con2.AccountId = acc2.id;                  
 insert con2;*/
 
 
 
        Datetime dt = System.now();
        String scheduleString='0';
        scheduleString+=' '+ dt.minute();
        scheduleString+=' '+ dt.hour();
        scheduleString+=' '+ dt.day();
        scheduleString+=' '+ dt.month();
        scheduleString+=' ?';
        scheduleString+=' '+ dt.year();     
        System.debug('currently scheduled.' + scheduleString); 

        String CRON_EXP = '0 0 0 3 9 ? 2022';    
           
       String QURY = 'SELECT Id, Name,Site_OMX_primary_key__c,Contact_OMX_primary_key__c, '+
     'LastActivityDate, Title__c, MailingCountry__c, MailingState__c, '+
     'MailingCity__c, Street__c, MailingPostalCode__c, Email__c, Phone__c, Phone_Ext__c, Fax__c, First_Name__c, Legacy_LastModifiedDate__c, '+
     'Legacy_CreatedDate__c, Account_OMX_Primary_Key__c,  Last_Order_Date_Of_Contact__c, Salutation__c, Language__c, Role__c, '+
     'Email_Permission_Flag_c__c, SFDC_Id__c, Error_Message__c,Contact_Source__c, ContactStatus__c, Processed_Status__c from GTContact_Delta__c '+
     'where Processed_Status__c!=\'Processed\'';
     
     
Test.startTest();
GNT_Contact_Batch gcb2=new GNT_Contact_Batch();
GNT_Contact_Batch gcb1=new GNT_Contact_Batch('');
GNT_Contact_Batch gcb=new GNT_Contact_Batch(QURY);
database.executebatch(gcb, 100);
System.schedule('Assignment error Batch',CRON_EXP , gcb);
Test.stopTest();



}
}