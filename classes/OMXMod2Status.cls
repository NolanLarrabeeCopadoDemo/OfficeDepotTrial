// Class to set the status of Mod 2 from AOPS to SFDC
global class OMXMod2Status {
 
 webservice static boolean getMod2Status (String AopsId,String AopsSeqId,String DBStamp,String UserSetUpFlag,String OrderSetUpFlag, String CSLSetUpFlag, String ReadyToOrderFlag,String RedirectFlag, String DNSFlag) {
   
       String millisec='';
       Datetime DBStamptime;
             if (DBStamp != null) {
             String dt = DBStamp.substring(0,DBStamp.indexof('T'));
             String tm = DBStamp.substring(DBStamp.indexof('T')+1,DBStamp.indexof('.'));
             DBStamptime= dateTime.valueOf(dt+' '+tm);
             List<String> timeString = DBStamp.split('\\.');            
             millisec=timeString [1];
             } 

   AOPS_Flag__c rec = new AOPS_Flag__c();
   rec.AopsId__c=AopsId;
   rec.AopsSeqId__c=AopsSeqId;
   rec.CSLSetUpFlag__c=CSLSetUpFlag;
   rec.DBStamp__c=DBStamp;
   rec.DNSFlag__c=DNSFlag;
   rec.OrderSetUpFlag__c=OrderSetUpFlag;
   rec.ReadyToOrderFlag__c=ReadyToOrderFlag;
   rec.RedirectFlag__c=RedirectFlag;
   rec.UserSetUpFlag__c=UserSetUpFlag;
   rec.AOPS_DB_TimeStamp__C =DBStamptime;
   rec.DBStampMillisec__C=millisec ;
   insert rec;
   
   /*
   
   System.debug('&&&&&&&&&Inside'+AopsId+'&&&&&&&&'+DBStamp);
   integer count=0;
   String millisec='';
   Datetime DBStamptime;
             if (DBStamp != null) {
             String dt = DBStamp.substring(0,DBStamp.indexof('T'));
             String tm = DBStamp.substring(DBStamp.indexof('T')+1,DBStamp.indexof('.'));
             DBStamptime= dateTime.valueOf(dt+' '+tm);
             List<String> timeString = DBStamp.split('\\.');            
             millisec=timeString [1];
             } 
                 
           count=[select count() from Customer_transition__C 
           where AOPS_Assigned_AOPS_Account_ID__c=:AopsId];
           
           if(count>0){
               Customer_transition__C cust= [select Id,DBStampMillisec__C,AOPS_DB_TimeStamp__C,UserSetUpFlag__C,
               ReadyToOrderFlag__C,RedirectFlag__C,
               DNSFlag__C,CSLSetUpFlag__C,OrderSetUpFlag__C
               from Customer_transition__C 
               where AOPS_Assigned_AOPS_Account_ID__c=:AopsId];
               
               if(cust.AOPS_DB_TimeStamp__C ==null || cust.AOPS_DB_TimeStamp__C<DBStamptime){
               cust.AOPS_DB_TimeStamp__C =DBStamptime;
                 if(millisec !=null && millisec!='')
                 cust.DBStampMillisec__C=millisec ;
               cust.UserSetUpFlag__C=UserSetUpFlag;
               cust.OrderSetUpFlag__C=OrderSetUpFlag;   
               cust.CSLSetUpFlag__C=CSLSetUpFlag;
               cust.ReadyToOrderFlag__C=ReadyToOrderFlag;
               cust.RedirectFlag__C=RedirectFlag;
               cust.DNSFlag__C =DNSFlag;  
               update cust;
               }
               if(cust.AOPS_DB_TimeStamp__C ==DBStamptime){
                if(millisec>cust.DBStampMillisec__C){
                               cust.AOPS_DB_TimeStamp__C =DBStamptime;
                               cust.DBStampMillisec__C=millisec ;
               cust.UserSetUpFlag__C=UserSetUpFlag;
               cust.OrderSetUpFlag__C=OrderSetUpFlag;   
               cust.CSLSetUpFlag__C=CSLSetUpFlag;
               cust.ReadyToOrderFlag__C=ReadyToOrderFlag;
               cust.RedirectFlag__C=RedirectFlag;
               cust.DNSFlag__C =DNSFlag;  
               update cust;

               }
               }
                              
           }
           */
   
   return true;
 }
 
}