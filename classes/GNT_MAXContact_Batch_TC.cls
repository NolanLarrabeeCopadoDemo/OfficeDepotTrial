@isTest 

private class GNT_MAXContact_Batch_TC {
static testMethod void validate_GNT_Contact_Batch()
{
List<GTContact_Delta__c > gtInsert = new List<GTContact_Delta__c >();
 GTContact_Delta__c gtc = new GTContact_Delta__c();
    gtc.First_Name__c='Test';
    gtc.name='Contact';
    gtc.Processed_Status__c= 'Process MAX' ;
    gtc.Account_OMX_Primary_Key__c='057329-GT';
    gtc.UniqueId__c='057329-GTTestContact';
  gtInsert.add(gtc);
  
  GTContact_Delta__c gtc1 = new GTContact_Delta__c();
    gtc1.First_Name__c='Test';
    gtc1.name='Contact';
    gtc1.Processed_Status__c= 'Process MAX' ;
    gtc1.Account_OMX_Primary_Key__c='057329-GT';
    gtc1.SITE_OMX_Primary_Key__c='329096-GT';
    gtc.UniqueId__c='057329-GTTestContact';
  gtInsert.add(gtc1);
   
     GTContact_Delta__c gtc2 = new GTContact_Delta__c();
    gtc2.First_Name__c='Test';
    gtc2.name='Contact';
    gtc2.Processed_Status__c= 'Process MAX' ;
    gtc2.Account_OMX_Primary_Key__c='057329-GT';
    gtc2.SITE_OMX_Primary_Key__c='812687-GT';
 gtc.UniqueId__c='057329-GTTestContact';
  gtInsert.add(gtc2);
            
 insert gtInsert; 
 
 
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
             
Test.startTest();

 //GNT_MAXContact_Batch assignBatch1 = new GNT_MAXContact_Batch ();
      //  database.executebatch(assignBatch1);


GNT_MAXContact_Batch gcb=new GNT_MAXContact_Batch ();

//GNT_Contact_Batch gcb=new GNT_Contact_Batch(QURY);
//database.executebatch(gcb2);
System.schedule('Assignment error Batch',CRON_EXP , gcb);
Test.stopTest();
}
}