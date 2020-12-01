trigger ProcessAOPSflags on AOPS_Flag__c (after insert) {
Set<string> AopsCustId= new Set<string> ();
for( AOPS_Flag__c  rec: Trigger.New){
    if(!AopsCustId .contains( rec.AopsId__c) )
    AopsCustId.add(rec.AopsId__c);
  }
  System.debug('&&&&AopsCustId'+AopsCustId);
  
  //get Transition records
List<Customer_transition__C > custList= new List<Customer_transition__C >();
Map<String,Customer_transition__C > mapList = new Map<String,Customer_transition__C >();
Map<String,Customer_transition__C > mapListProcess = new Map<String,Customer_transition__C >();
               
               //get CT records
               custList= [select Id,DBStampMillisec__C,AOPS_DB_TimeStamp__C,UserSetUpFlag__C,
               ReadyToOrderFlag__C,RedirectFlag__C,
               DNSFlag__C,CSLSetUpFlag__C,OrderSetUpFlag__C,AOPS_Assigned_AOPS_Account_ID__c ,DBStamp__C
               from Customer_transition__C 
               where AOPS_Assigned_AOPS_Account_ID__c in :AopsCustId];
               

  for(Customer_transition__C rec : custList){
  mapList.put(rec.AOPS_Assigned_AOPS_Account_ID__c ,rec);
  }
  
    System.debug('&&&&mapList'+mapList);


  for( AOPS_Flag__c  rec: Trigger.New){
     if(mapList.containskey(rec.AopsId__c)){    
         System.debug('&&&&Inside Maplist');
             if( ! mapListProcess.containskey(rec.AopsId__c)){
                      System.debug('&&&&Inside loop1' +mapList.get(rec.AopsId__c).AOPS_DB_TimeStamp__C);
                                 if(mapList.get(rec.AopsId__c).AOPS_DB_TimeStamp__C ==null || mapList.get(rec.AopsId__c).AOPS_DB_TimeStamp__C<rec.AOPS_DB_TimeStamp__C){
                                     System.debug('&&&&Inside loop2');
                                   Customer_transition__C cust= new Customer_transition__C ();
                                   cust.Id=mapList.get(rec.AopsId__c).Id;
                                   cust.AOPS_DB_TimeStamp__C =rec.AOPS_DB_TimeStamp__C;
                                   if(rec.DBStampMillisec__C!=null && rec.DBStampMillisec__C!='')
                                   cust.DBStampMillisec__C=rec.DBStampMillisec__C;
                                   cust.UserSetUpFlag__C=rec.UserSetUpFlag__C;
                                   cust.OrderSetUpFlag__C=rec.OrderSetUpFlag__C;   
                                   cust.CSLSetUpFlag__C=rec.CSLSetUpFlag__C;
                                   cust.ReadyToOrderFlag__C=rec.ReadyToOrderFlag__C;
                                   cust.RedirectFlag__C=rec.RedirectFlag__C;
                                   cust.DNSFlag__C =rec.DNSFlag__C ;  
                                   cust.DBStamp__C=rec.DBStamp__C;
                                   mapListProcess.put(rec.AopsId__c,cust);
                                 }              
             }
             else{
               System.debug('&&&&Inside loop3  AOPS_DB_TimeStamp__C'+rec.AOPS_DB_TimeStamp__C);
               System.debug('&&&&Inside loop3  mapListProcess.get(rec.AopsId__c).AOPS_DB_TimeStamp__C'+mapListProcess.get(rec.AopsId__c).AOPS_DB_TimeStamp__C);

               if(  (rec.AOPS_DB_TimeStamp__C>  mapListProcess.get(rec.AopsId__c).AOPS_DB_TimeStamp__C ) ||
                  ( (rec.AOPS_DB_TimeStamp__C == mapListProcess.get(rec.AopsId__c).AOPS_DB_TimeStamp__C) 
                   /////&& (rec.DBStampMillisec__C  >mapListProcess.get(rec.AopsId__c).DBStampMillisec__C  )
                   )
               ){
               
               Integer currSec=0;
               Integer PrSec=0;
               if(rec.DBStamp__C !=null){
               List<string> str=rec.DBStamp__C.split(':');
               System.debug('&&&str'+ str);
               System.debug('&&&str2'+ str[2]);
               String  str2=str[2];
               string temp=str2.substring(0,2);
               currSec= Integer.valueof(temp);              
               }
               
               if(mapListProcess.get(rec.AopsId__c).DBStamp__C !=null){
               List<string> strPr=mapListProcess.get(rec.AopsId__c).DBStamp__C.split(':');
               String  str2Pr=strPr[2];
               string tempPr=str2Pr.substring(0,2);
               PrSec= Integer.valueof(tempPr);
               }
                              
               System.debug('&&&&Inside loop4currSec' +currSec);
               System.debug('&&&&Inside loop4 PrSec' +PrSec);

               
               if(   
               
               (rec.AOPS_DB_TimeStamp__C>  mapListProcess.get(rec.AopsId__c).AOPS_DB_TimeStamp__C )
               
                ||
               (   (rec.AOPS_DB_TimeStamp__C == mapListProcess.get(rec.AopsId__c).AOPS_DB_TimeStamp__C) 
               
                         &&    
              ( (currSec>  PrSec)  ||  
                (  (currSec== PrSec ) && (rec.DBStampMillisec__C  >mapListProcess.get(rec.AopsId__c).DBStampMillisec__C  ) )  ) 
                )
                )
                
              {
                             System.debug('&&&&Inside loop5');

                  mapListProcess.remove(rec.AopsId__c);
                                   Customer_transition__C cust= new Customer_transition__C ();
                                   cust.Id=mapList.get(rec.AopsId__c).Id;
                                   cust.AOPS_DB_TimeStamp__C =rec.AOPS_DB_TimeStamp__C;
                                   if(rec.DBStampMillisec__C!=null && rec.DBStampMillisec__C!='')
                                   cust.DBStampMillisec__C=rec.DBStampMillisec__C;
                                   cust.UserSetUpFlag__C=rec.UserSetUpFlag__C;
                                   cust.OrderSetUpFlag__C=rec.OrderSetUpFlag__C;   
                                   cust.CSLSetUpFlag__C=rec.CSLSetUpFlag__C;
                                   cust.ReadyToOrderFlag__C=rec.ReadyToOrderFlag__C;
                                   cust.RedirectFlag__C=rec.RedirectFlag__C;
                                   cust.DNSFlag__C =rec.DNSFlag__C ;  
                                   cust.DBStamp__C=rec.DBStamp__C;
                                   cust.ProcessFlag__C=true;
                                   mapListProcess.put(rec.AopsId__c,cust);
                                   
                 }                  

               }
            }  //end of else
             
             
         }
     }// end of for loop
     
                    System.debug('&&&&Inside mapListProcess'+mapListProcess);

  List<Customer_transition__C> updateList= new List<Customer_transition__C>();
    if(mapListProcess.size()>0){
       for(Customer_transition__C  target : mapListProcess.values()) {
          updateList.add(target);
       }
       update updateList;    
    }
}