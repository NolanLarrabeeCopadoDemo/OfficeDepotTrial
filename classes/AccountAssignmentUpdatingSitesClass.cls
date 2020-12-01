//Class to update the Party sites Id's and create customer Record

public class AccountAssignmentUpdatingSitesClass {  
    
    public void updateAssignData(List<AccountAssignments__c > currentRecords) {
       Set<String> accSet = new Set<String>();
       Map<String,Account> accMap = new Map<String,Account>();
       Map<String,Account> accMapOMX = new Map<String,Account>();

       List<AccountAssignments__c> accupsertList= new List<AccountAssignments__c>();

        for(AccountAssignments__c accAssgnmntObj : currentRecords)
        {
           // Take the Site Records
                if(  (accAssgnmntObj.Entity_Type__c == 'ODN Customer'  || accAssgnmntObj.Entity_Type__c == 'ODS Customer')  && accAssgnmntObj.AccountType__c =='S' )
                {
                accSet.add(accAssgnmntObj.Entity_Id__c);
                system.debug('in entity id');
                }
        }
        //get Party Site Id's and Account Id's for the account
        for(Account acc : [select id,OMX_Primary_Key__c,AOPS_Seq_ID__c,Oracle_Party_Site_ID__c ,Primary_Site__c,Related_Account__c,
        Related_Account__r.Oracle_Party_ID__c,Related_Account__r.OMX_Primary_Key__c,Related_Account__r.AOPS_Cust_Id__c
         from Account where 
        ( AOPS_Seq_ID__c in :accSet  or  OMX_Primary_Key__c in :accSet )  ])
            {
            if(acc.AOPS_Seq_ID__c!=null)
            accMap.put(acc.AOPS_Seq_ID__c,acc);
            else
            accMapOMX.put(acc.OMX_Primary_Key__c,acc);
            }
                           system.debug('accMap'+accMap);
                            system.debug('accMapOMX'+accMapOMX);

           for(AccountAssignments__c accAssgnmntObj : currentRecords)
            {
           // Take the Site Records
                if(  (accAssgnmntObj.Entity_Type__c == 'ODN Customer'  || accAssgnmntObj.Entity_Type__c == 'ODS Customer')  && 
                accAssgnmntObj.AccountType__c =='S' )
                {
                  // check if its a primary Site or not   
                  
                                            system.debug('Inside loop2');
                        if(accAssgnmntObj.Entity_Type__c == 'ODN Customer' && accMapOMX.containsKey(accAssgnmntObj.Entity_Id__c) ){
                        accAssgnmntObj.AccountId__c = accMapOMX.get(accAssgnmntObj.Entity_Id__c).Oracle_Party_Site_ID__c;  
                        accAssgnmntObj.Account__c =   accMapOMX.get(accAssgnmntObj.Entity_Id__c).Id; 
                        }
                        else if(accAssgnmntObj.Entity_Type__c == 'ODS Customer' && accMap.containsKey(accAssgnmntObj.Entity_Id__c) ){
                        accAssgnmntObj.AccountId__c = accMap.get(accAssgnmntObj.Entity_Id__c).Oracle_Party_Site_ID__c;  
                        accAssgnmntObj.Account__c =   accMap.get(accAssgnmntObj.Entity_Id__c).Id; 
                        }

            
                  if((accAssgnmntObj.Entity_Type__c == 'ODS Customer'  && accMap.containsKey(accAssgnmntObj.Entity_Id__c) && accMap.get(accAssgnmntObj.Entity_Id__c).Primary_Site__c== true ) ||
                  (accAssgnmntObj.Entity_Type__c == 'ODN Customer'  && accMapOMX.containsKey(accAssgnmntObj.Entity_Id__c) && accMapOMX.get(accAssgnmntObj.Entity_Id__c).Primary_Site__c== true ) ){
                      AccountAssignments__c accupsert= new AccountAssignments__c();
                        accupsert.AccountType__c ='A';
                        accupsert.Status__c='Open';
                        if(accAssgnmntObj.Entity_Type__c == 'ODN Customer' ){
                        accupsert.Entity_Type__c = 'ODN Customer' ;
                        accupsert.Entity_Id__c=accMapOMx.get(accAssgnmntObj.Entity_Id__c).Related_Account__r.omx_primary_key__C;
                        accupsert.Ex_Id__c=accMapOMx.get(accAssgnmntObj.Entity_Id__c).Related_Account__r.omx_primary_key__C;
                        accupsert.AccountId__c =accMapOMX.get(accAssgnmntObj.Entity_Id__c).Related_Account__r.Oracle_Party_ID__c;
                        accupsert.account__C=accMapOMX.get(accAssgnmntObj.Entity_Id__c).Related_Account__c;
                        }
                        else if(accAssgnmntObj.Entity_Type__c == 'ODS Customer' ){
                        accupsert.Entity_Type__c = 'ODS Customer' ;
                        accupsert.Entity_Id__c=accMap.get(accAssgnmntObj.Entity_Id__c).Related_Account__r.AOPS_Cust_Id__c;
                        accupsert.Ex_Id__c=accMap.get(accAssgnmntObj.Entity_Id__c).Related_Account__r.AOPS_Cust_Id__c;
                        accupsert.AccountId__c =accMap.get(accAssgnmntObj.Entity_Id__c).Related_Account__r.Oracle_Party_ID__c;
                        accupsert.account__C=accMap.get(accAssgnmntObj.Entity_Id__c).Related_Account__c;
                        }
                       
                                                accupsert.OverlayEmpID1__c= accAssgnmntObj .OverlayEmpID1__c;
                                                accupsert.OverlayEmpID2__c= accAssgnmntObj .OverlayEmpID2__c;
                                                accupsert.OverlayEmpID3__c= accAssgnmntObj .OverlayEmpID3__c;
                                                accupsert.OverlayEmpID4__c= accAssgnmntObj .OverlayEmpID4__c;
                                                accupsert.OverlayEmpID5__c= accAssgnmntObj .OverlayEmpID5__c;
                                                accupsert.OverlayEmpID6__c= accAssgnmntObj .OverlayEmpID6__c;
                                                accupsert.OverlayEmpID7__c= accAssgnmntObj .OverlayEmpID7__c;
                                                accupsert.OverlayEmpID8__c= accAssgnmntObj .OverlayEmpID8__c;
                                                accupsert.OverlayEmpID9__c= accAssgnmntObj .OverlayEmpID9__c;
                                                accupsert.OverlayEmpID10__c= accAssgnmntObj .OverlayEmpID10__c;
                                                accupsert.OverlayEmpID11__c= accAssgnmntObj .OverlayEmpID2__c;
                                                accupsert.OverlayEmpID12__c= accAssgnmntObj .OverlayEmpID12__c;
                                                accupsert.OverlayEmpID13__c= accAssgnmntObj .OverlayEmpID13__c;
                                                accupsert.OverlayEmpID14__c= accAssgnmntObj .OverlayEmpID14__c;
                                                accupsert.OverlayEmpID15__c= accAssgnmntObj .OverlayEmpID15__c;
                                                accupsert.OverlayEmpID16__c= accAssgnmntObj .OverlayEmpID16__c;
                                                accupsert.OverlayEmpID17__c= accAssgnmntObj .OverlayEmpID17__c;
                                                accupsert.OverlayEmpID18__c= accAssgnmntObj .OverlayEmpID18__c;
                                                accupsert.OverlayEmpID19__c= accAssgnmntObj .OverlayEmpID19__c;
                                                accupsert.OverlayEmpID20__c= accAssgnmntObj .OverlayEmpID20__c;
                                                accupsert.OverlayEmpID21__c= accAssgnmntObj .OverlayEmpID21__c;
                                                accupsert.OverlayEmpID22__c= accAssgnmntObj .OverlayEmpID22__c;
                                                accupsert.OverlayEmpID23__c= accAssgnmntObj .OverlayEmpID23__c;
                                                accupsert.OverlayEmpID24__c= accAssgnmntObj .OverlayEmpID24__c;
                                                accupsert.OverlayEmpID25__c= accAssgnmntObj .OverlayEmpID25__c;
                                                accupsert.OverlayEmpID26__c= accAssgnmntObj .OverlayEmpID26__c;
                                                accupsert.OverlayEmpID27__c= accAssgnmntObj .OverlayEmpID27__c;
                                                accupsert.OverlayEmpID28__c= accAssgnmntObj .OverlayEmpID28__c;
                                                accupsert.OverlayEmpID29__c= accAssgnmntObj .OverlayEmpID29__c;
                                                accupsert.OverlayEmpID30__c= accAssgnmntObj .OverlayEmpID30__c;
                                                accupsert.OverlayEmpRole1__c= accAssgnmntObj .OverlayEmpRole1__c;
                                                accupsert.OverlayEmpRole2__c= accAssgnmntObj .OverlayEmpRole2__c;
                                                accupsert.OverlayEmpRole3__c= accAssgnmntObj .OverlayEmpRole3__c;
                                                accupsert.OverlayEmpRole4__c= accAssgnmntObj .OverlayEmpRole4__c;
                                                accupsert.OverlayEmpRole5__c= accAssgnmntObj .OverlayEmpRole5__c;
                                                accupsert.OverlayEmpRole6__c= accAssgnmntObj .OverlayEmpRole6__c;
                                                accupsert.OverlayEmpRole7__c= accAssgnmntObj .OverlayEmpRole7__c;
                                                accupsert.OverlayEmpRole8__c= accAssgnmntObj .OverlayEmpRole8__c;
                                                accupsert.OverlayEmpRole9__c= accAssgnmntObj .OverlayEmpRole9__c;
                                                accupsert.OverlayEmpRole10__c= accAssgnmntObj .OverlayEmpRole10__c;
                                                accupsert.OverlayEmpRole11__c= accAssgnmntObj .OverlayEmpRole2__c;
                                                accupsert.OverlayEmpRole12__c= accAssgnmntObj .OverlayEmpRole12__c;
                                                accupsert.OverlayEmpRole13__c= accAssgnmntObj .OverlayEmpRole13__c;
                                                accupsert.OverlayEmpRole14__c= accAssgnmntObj .OverlayEmpRole14__c;
                                                accupsert.OverlayEmpRole15__c= accAssgnmntObj .OverlayEmpRole15__c;
                                                accupsert.OverlayEmpRole16__c= accAssgnmntObj .OverlayEmpRole16__c;
                                                accupsert.OverlayEmpRole17__c= accAssgnmntObj .OverlayEmpRole17__c;
                                                accupsert.OverlayEmpRole18__c= accAssgnmntObj .OverlayEmpRole18__c;
                                                accupsert.OverlayEmpRole19__c= accAssgnmntObj .OverlayEmpRole19__c;
                                                accupsert.OverlayEmpRole20__c= accAssgnmntObj .OverlayEmpRole20__c;
                                                accupsert.OverlayEmpRole21__c= accAssgnmntObj .OverlayEmpRole21__c;
                                                accupsert.OverlayEmpRole22__c= accAssgnmntObj .OverlayEmpRole22__c;
                                                accupsert.OverlayEmpRole23__c= accAssgnmntObj .OverlayEmpRole23__c;
                                                accupsert.OverlayEmpRole24__c= accAssgnmntObj .OverlayEmpRole24__c;
                                                accupsert.OverlayEmpRole25__c= accAssgnmntObj .OverlayEmpRole25__c;
                                                accupsert.OverlayEmpRole26__c= accAssgnmntObj .OverlayEmpRole26__c;
                                                accupsert.OverlayEmpRole27__c= accAssgnmntObj .OverlayEmpRole27__c;
                                                accupsert.OverlayEmpRole28__c= accAssgnmntObj .OverlayEmpRole28__c;
                                                accupsert.OverlayEmpRole29__c= accAssgnmntObj .OverlayEmpRole29__c;
                                                accupsert.OverlayEmpRole30__c= accAssgnmntObj .OverlayEmpRole30__c;
                                                accupsert.PrimaryEmpId__c= accAssgnmntObj .PrimaryEmpId__c;
                                                accupsert.PrimaryEmpRole__c= accAssgnmntObj.PrimaryEmpRole__c;

                                                
                  accupsertList.add(accupsert);                              
                  }
                }
            }// end of for loop
         if(accupsertList.size()>0)
         upsert accupsertList Ex_Id__c;
    }
     
    
    

}