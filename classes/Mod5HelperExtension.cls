public class Mod5HelperExtension{

//code to create existing Contacts of Original account with new accounts
// code to update the LinkedTransition in split details table

public static List<Contact> eachConInsertList = new List<Contact>();

/*
public static void futureInsertCon(String inputConStr) {

system.debug('inputConStr@@@'+inputConStr);
List<Contact> conToInsert = new List<Contact>();
List <String>   eachContactLists = inputConStr.split('@##@');

if(eachContactLists!=NULL && eachContactLists.size() > 0){
    system.debug('eachContactLists@@@'+eachContactLists);
    for(String eachConStr : eachContactLists){
    if(eachConStr != '' && eachConStr != NULL){
    system.debug('eachConStr@@@'+eachConStr);
    String [] tmpConDetails = eachConStr.split('@::@');
    system.debug('tmpConDetails@@@'+tmpConDetails);
    Contact eachCon = new Contact();

        if(!tmpConDetails[0].equals('::::'))
        eachCon.firstname = tmpConDetails[0];

        if(!tmpConDetails[1].equals('::::'))
        eachCon.lastname = tmpConDetails[1];
       
            //if(!tmpConDetails[2].equals('true'))
            eachCon.Override_duplicate_check__c = true;
            //else
            //eachCon.Override_duplicate_check__c = false;
        
        if(!tmpConDetails[3].equals('::::'))
        eachCon.accountId = tmpConDetails[3];
        if(!tmpConDetails[4].equals('::::'))
        eachCon.email = tmpConDetails[4];
        if(!tmpConDetails[5].equals('::::'))
        eachCon.phone = tmpConDetails[5];
        if(!tmpConDetails[6].equals('::::'))
        eachCon.fax = tmpConDetails[6];
        system.debug('@@@eachCon'+eachCon);
        conToInsert.add(eachCon);
        }
    }

    System.debug('@@@@conToInsert '+conToInsert.size()+' '+conToInsert);
    
    if(conToInsert.size() > 0)
    insert conToInsert;
}
}

@future
 public static void insertContact(Map<Id,Id> accMap,List<Id> accId) {
  String  contInsert = '';
  List<String> contInsertList = new List<String>();
  List < Contact > contList=[Select firstname,lastname, email,AccountId,phone,fax  from Contact where AccountId in :accId];
  List<String> contactLists = new List<String>();
  System.debug('@@@@accId '+accId);
  
   for (Id recordId : accMap.keySet()){   
    System.debug('@@@@contList '+contList.size());
    integer countSize = 0;
      for(integer i=0;i<contList.size();i++){
      system.debug('contList '+i+'@@@'+contList[i]);
        //Contact contnew= new Contact(firstname=contList[i].firstname,lastname=contList[i].lastname,
                                    //Override_duplicate_check__c = true,accountId=recordId ,
                                    //email =contList[i].email, phone=contList[i].phone,fax=contList[i].fax);
        
        String contnew = '';
        
        if(contList[i].firstname != NULL)
        contnew=contList[i].firstname+'@::@';
        else
        contnew='::::'+'@::@';
        
        if(contList[i].lastname != NULL)
        contnew=contnew + contList[i].lastname+'@::@';
        else
        contnew=contnew + '::::'+'@::@';
        
        //For Override_duplicate_check__c
        contnew=contnew + 'true'+'@::@';
                
        if(recordId != NULL)
        contnew=contnew + recordId+'@::@';
        else
        contnew=contnew + '::::'+'@::@';
        
        if(contList[i].email != NULL)
        contnew=contnew + contList[i].email+'@::@';
        else
        contnew=contnew + '::::'+'@::@';
        
        if(contList[i].phone != NULL)
        contnew=contnew + contList[i].phone+'@::@';
        else
        contnew=contnew + '::::'+'@::@';
        
        if(contList[i].fax != NULL)
        contnew=contnew + contList[i].fax+'@::@';
        else
        contnew=contnew + '::::'+'@::@';
        
        contInsert = contInsert + contnew  + '@##@';
        
        countSize = countSize + 1;
  
        if(countSize >9999)
        {
        String tmpStr = contInsert;
        contactLists.add(tmpStr);
        contInsert = '';
        countSize = 0;
        }
      }
      String tmpStr = contInsert;
      contactLists.add(tmpStr);
  
      
  }
 
  System.debug('@@@@accId '+accId);
  System.debug('@@@@contactLists '+contactLists.size());
  System.debug('@@@@contactLists '+contactLists);
  if(contactLists.size()>0)
  {
      for(String  eachContactLists : contactLists)
      {
        System.debug('@@@@eachContactLists '+eachContactLists.length());
        
        futureInsertCon(eachContactLists);
        //eachConInsertList.clear();
      }
  }
 
 }
*/

// code to update the LinkedTransition in split details table
 public void updateLinkedTransition(List<Customer_Transition__c> mod5List,Map<String,Id> custMap,Map<String,Id> accMapList) {
             executeoncetest.mod5extnhlpr = false;

          //  Map<Id,Id> newtoOldMap= new Map<Id,Id>(); 
           Map<Id,Id> newtoOldMapaccnt= new Map<Id,Id>();               
           List<Id> accId= new List<Id>(); 
           List<Customer_Transition_Dtls__c > insertDetailList= new List<Customer_Transition_Dtls__c >();
            
            //get the split details Records
            List<Split_Account_Detail__c>    splitDetail=[Select Linked_Customer_Transition__c,Master_Account__c,OMX_ACCOUNT__c,
            Linked_Customer_Transition__r.account__C,Customer_Transition__r.account__C,
            Customer_Transition__c,New_Header_Billing_Account__r.Related_Account__c,
            NEW_BILL_TO_OMX_CONSIGNEE__c,Original_Account__c,
            New_Header_Billing_Account__r.Name,New_Header_Billing_Account__r.address1__c,
            New_Header_Billing_Account__r.address2__c,New_Header_Billing_Account__r.city__c,
            New_Header_Billing_Account__r.state__c,New_Header_Billing_Account__r.recordtypeId,
            New_Header_Billing_Account__r.ownerId,
            New_Header_Billing_Account__r.Sales_PersonID__c,New_Header_Billing_Account_Code__C
            from Split_Account_Detail__c
            where Customer_Transition__c in:mod5List  order by NEW_BILL_TO_OMX_CONSIGNEE__c desc];  
             
         List<Account> accList= new  List<Account>();
         List<Customer_Transition_Dtls__c > DetailList = new List<Customer_Transition_Dtls__c > ();
         Map<String,Id> MapDetail  = new  Map<String,Id>  ();
         Integer Count=1 ;   
         Map<String,String> BilltoListMap  = new  Map<String,String>  ();
         Map<String,String> OMXKeyMap= new  Map<String,String>  ();
          
          
            System.debug('&&&&&&&&&&&AccMapList'+accMapList);
          
          
          
          
                      
            // update The Launched Transition
            for(integer i=0;i<splitDetail.size();i++){
             
               if(!accMapList.keyset().contains( splitDetail[i].OMX_ACCOUNT__c))
               accMapList.put(  splitDetail[i].OMX_ACCOUNT__c,splitDetail[i].Original_Account__c ); 
               
               if(!custMap.keyset().contains( splitDetail[i].OMX_ACCOUNT__c))
               custMap.put(  splitDetail[i].OMX_ACCOUNT__c,splitDetail[i].Customer_Transition__c ); 
               
               
               
                           
               if(!OMXKeyMap.keyset().contains( splitDetail[i].Master_Account__c)){
               OMXKeyMap.put(  splitDetail[i].Master_Account__c,splitDetail[i].Master_Account__c ); 
                  
                   //get the new transition to Old Transition Map
                 //  if(!newtoOldMap.keyset().contains(splitDetail[i].Linked_Customer_Transition__c)   )
                 //  newtoOldMap.put(   splitDetail[i].Linked_Customer_Transition__c, splitDetail[i].Customer_Transition__c);  
                        
                                    
                System.debug('&&&&&&&&&&&Original account'+    accMapList.get(splitDetail[i].Master_Account__c));
                System.debug('&&&&&&&&&&&Bill to account'+    splitDetail[i].New_Header_Billing_Account__r.Related_Account__c);   
                
                
                        // Logic to Create New Build to accounts
                      if(splitDetail[i].New_Header_Billing_Account__r.Related_Account__c!=null  &&
                      ( splitDetail[i].New_Header_Billing_Account__r.Related_Account__c!=accMapList.get(splitDetail[i].Master_Account__c)
                      ))
                      {
                      
                      System.debug('&&&&&&&&entered here');
                      
                      
                      if(!BilltoListMap.keyset().contains(splitDetail[i].NEW_BILL_TO_OMX_CONSIGNEE__c)){
                      BilltoListMap.put(splitDetail[i].NEW_BILL_TO_OMX_CONSIGNEE__c,splitDetail[i].NEW_BILL_TO_OMX_CONSIGNEE__c);
                      count=1;
                      }
                      
                      String countSeq= String.valueof(count);
                      if(count<10)
                      countSeq ='0'+countSeq;                  
                      String OMXKey=splitDetail[i].NEW_BILL_TO_OMX_CONSIGNEE__c+'-OMX-A'+countSeq;
                
                  
                          Account acc=new Account (                       
                            name=splitDetail[i]. New_Header_Billing_Account__r.Name,
                            Related_Account__c=accMapList.get(splitDetail[i].Master_Account__c),
                            omx_primary_key__C=OMXKey,
                            OMX_Mainframe_Account_Number__c=splitDetail[i].Master_Account__c,
                            OMX_Mainframe_Consignee_ID__c=OMXKey,
                            address1__c=splitDetail[i].New_Header_Billing_Account__r.address1__c,
                            address2__c=splitDetail[i].New_Header_Billing_Account__r.address2__c,
                            city__C=splitDetail[i].New_Header_Billing_Account__r.city__c,
                            ownerId=splitDetail[i].New_Header_Billing_Account__r.ownerId,
                            Sales_PersonID__c=splitDetail[i].New_Header_Billing_Account__r.Sales_PersonID__c,                        
                            state__c=splitDetail[i].New_Header_Billing_Account__r.state__c,Split_Record__c=true,
                            recordtypeId=splitDetail[i].New_Header_Billing_Account__r.recordtypeId, Primary_BillTo__C=true);
                            
                            accList.add(acc); 
                            
                             Id Site = Schema.SObjectType.Customer_Transition_Dtls__c.getRecordTypeInfosByName().get('Sites').getRecordTypeId();
                            
                            //Creating the records for Tranistion details for New Billing Account
                            Customer_Transition_Dtls__c custNew= new Customer_Transition_Dtls__c (
                            omx_primary_key__C=OMXKey,
                            recordtypeId=Site ,
                            Reference_Account__c=accMapList.get(splitDetail[i].Master_Account__c),
                            aops_flag__c='Y',
                           // Ship_2_Bill_2_Code__c ='B',
                           Ship_2_Bill_2_Code__c =splitDetail[i].New_Header_Billing_Account_Code__C,
                            Status__c='Active',
                            Customer_Transition_ID__c=custMap.get(splitDetail[i].Master_Account__c));  
                            DetailList .add( custNew);   
                            
                           
                            count=count+1;                                                    
                      }
                   
                  } 
                   if(splitDetail[i].Master_Account__c !=splitDetail[i].OMX_ACCOUNT__c){
                       splitDetail[i].Linked_Customer_Transition__c= custMap.get(splitDetail[i].Master_Account__c); 
                       //get the new account to Old account Map
                       if(!newtoOldMapaccnt.keyset().contains( accMapList.get(splitDetail[i].Master_Account__c))   ){                  
                       system.debug('>>>>newtoOldMapaccnt>>>>>'+newtoOldMapaccnt);
                       newtoOldMapaccnt.put(  accMapList.get(splitDetail[i].Master_Account__c),splitDetail[i].Customer_Transition__r.account__C ); 
                       accId.add(splitDetail[i].Customer_Transition__r.account__C);
                       }      
                   }
            }
            
            
            
            
          //Call the Contact Method to Insert the Contacts  
          if(  newtoOldMapaccnt.size()>0){
          //insertContact(newtoOldMapaccnt,accId);
          
          
           Mod5InsertCntcBatch mod5InsertCntcBatchObj = new Mod5InsertCntcBatch(newtoOldMapaccnt,accId);
           database.executebatch(mod5InsertCntcBatchObj, 10);
          }
            
       if(splitDetail.size()>0)
       update splitDetail;
       
       // Insering the new billing accounts and create Transition Detail Records for them
       if(accList.size()>0){
       executeoncetest.isMod5Launch = true;
       insert accList; 
       System.debug('&&&&&&&&&&&&&&&  accList'+accList);       
       for(integer i=0;i<accList.size();i++){
       MapDetail.put(accList[i].omx_primary_key__C,accList[i].Id);
       System.debug('&&&&&&&&&&&&&&&  accList.Id'+accList[i].Id);       
       } 
       for(integer k=0;k<DetailList.size();k++){
       DetailList [k].Account_ID__c=  MapDetail.get(DetailList [k].omx_primary_key__C);
       } 
       insert  DetailList ;  
       System.debug('&&&&&&&&&&&&&&&  DetailList'+DetailList);       
 
       }
       


       
       
       // Code to Insert Customer Transition details for New Billing account
       
      //code to update Billing Type and AP contact Details
      
    
      
      SplitDetailsUpdateExtension.updateTransition(custMap.values());
       
     
      
 }

}