public with sharing class AccountPrimaryOwnerUpdate{

    public void UpdatePrimary(Set<Id> assignmentIds ){
       
          Integer inactiveEmpCount = 0;

             /*****************************Update Primary Assignement Logic********************************/     
                
            //Query back because to Update the Status of the Record after updating the Primary Rep    
            Set<String> setRoleRelatedIds = new Set<String>(); // set of Role related ids
            Set<String> setEmpIds = new Set<String>(); // this set to store OD employee Id to select user records 
            Set<String> setPartyIds = new Set<String>(); // Party Ids from the Assignments Batch
            Set<String> setPartySiteIds = new Set<String>(); // Party Site Ids from the Assignments Batch
            Set<String> setAopsCustIds = new Set<String>(); // AOPS Cust Ids from the Assignments Batch
            Set<String> setAopsSeqIds = new Set<String>(); // AOPS Seq Ids from the Assignments Batch
            List<AccountAssignments__c> oaa = [Select Id, AccountId__c, AccountType__c, Entity_Type__c, Entity_Id__c, PrimaryEmpId__c, PrimaryEmpRole__c,Status__c, Error_Message__c  FROM AccountAssignments__c WHERE Id IN: assignmentIds ];
           
            //Run to Update the Primary Assignment
            for (AccountAssignments__c objAssignment: oaa){
         
         
               if(objAssignment.Entity_Id__c != null && objAssignment.Entity_Id__c != ''){
    // Added logic for the case 00294900            
   if(objAssignment.Entity_Id__c.contains('-OMX')){              
          if(objAssignment.AccountType__c == 'S'){
          setPartySiteIds.add(objAssignment.AccountId__c);
          }
          
          else{
            setPartyIds.add(objAssignment.AccountId__c);
          }      
    }
    
    else{ 
               
                   if(objAssignment.AccountType__c == 'A' && objAssignment.Entity_Type__c == 'PROSPECT') // Prospect Account record so Party Id of Account
                                setPartyIds.add(objAssignment.Entity_Id__c);
                   else if(objAssignment.AccountType__c == 'S' && objAssignment.Entity_Type__c == 'PROSPECT') //Prospect Site record so Party Site Id of Account
                        setPartySiteIds.add(objAssignment.Entity_Id__c);
                   if(objAssignment.AccountType__c == 'A' && objAssignment.Entity_Type__c == 'CUSTOMER') // Customer Account record so AOPS cust id of Account
                        setAopsCustIds.add(objAssignment.Entity_Id__c);
                   else if(objAssignment.AccountType__c == 'S' && objAssignment.Entity_Type__c == 'CUSTOMER') //Customer Site record so AOPS seq Id of Account
                        setAopsSeqIds.add(objAssignment.Entity_Id__c);
                        
                        
          }              
                        
        System.debug('&&&&&&&&&&&&&&&&&&&&  setPartySiteIds'+setPartySiteIds);              
               
                     // Sales Person Id, to be set on Account record
                    if(objAssignment.PrimaryEmpRole__c != null && objAssignment.PrimaryEmpRole__c != '')
                        setRoleRelatedIds.add(objAssignment.PrimaryEmpRole__c);
                    
                    //Add Primary rep Id to the Set 
                    if(objAssignment.PrimaryEmpId__c != null && objAssignment.PrimaryEmpId__c != '')
                        setEmpIds.add(objAssignment.PrimaryEmpId__c);
                 
                }
                
            }
            
                Map<String,Sales_Person__c> mapId2SalesPersons = new Map<String,Sales_Person__c>();                  
                for(Sales_Person__c sRep: [select id, Role_Relate_Id__c From Sales_Person__c  where Role_Relate_Id__c in :setRoleRelatedIds]) 
                {
                    mapId2SalesPersons.put(sRep.Role_Relate_Id__c,sRep);
                }
              
                
                Map<String, User> mapEmpId2User = new Map<String, User>(); // Map to store OD employee Id as Key and User record as value        
                for(User usr: [select id, OD_Employee_ID__c from User where OD_Employee_ID__c in :setEmpIds and isActive = true])
                {
                    mapEmpId2User.put(usr.OD_Employee_ID__c, usr);
                }

                Map<ID, Account> mapAccounts = new Map<ID, Account>([select id,Sales_PersonID__c, ownerId, RecordTypeId, Oracle_Party_Id__c, Oracle_Party_Site_Id__c, AOPS_Cust_Id__c, AOPS_Seq_ID__c from Account where 
                Oracle_Party_Id__c in : setPartyIds OR Oracle_Party_Site_Id__c in :setPartySiteIds OR AOPS_Cust_Id__c in :setAopsCustIds OR
                  AOPS_Seq_ID__c in :setAopsSeqIds 

            
                  ]);
                
                Map<String, Account> mapPartyId2Account = new map<String, Account>(); // so easy to find Account record based on PartyID
                Map<String, Account> mapPartySiteId2Account = new map<String, Account>();// so easy to find Account record based on PartySiteID
                Map<String, Account> mapCustId2Account = new map<String, Account>(); // so easy to find Account record based on AOPS Cust Id
                Map<String, Account> mapSeqId2Account = new map<String, Account>();// so easy to find Account record based on AOPS Seq Id
                
                
                for(Account acc: mapAccounts.values())
                {        
                    if(acc.Oracle_Party_ID__c != null && acc.Oracle_Party_ID__c != '')
                        mapPartyId2Account.put(acc.Oracle_Party_ID__c, acc);
                    if(acc.Oracle_Party_Site_Id__c != null && acc.Oracle_Party_Site_Id__c != '')
                        mapPartySiteId2Account.put(acc.Oracle_Party_Site_Id__c, acc);
                    if(acc.AOPS_Cust_Id__c != null && acc.AOPS_Cust_Id__c != '')
                        mapCustId2Account.put(acc.AOPS_Cust_Id__c, acc);
                    if(acc.AOPS_Seq_ID__c != null && acc.AOPS_Seq_ID__c != '')
                        mapSeqId2Account.put(acc.AOPS_Seq_ID__c, acc);
                }
                
                List<Account> accountOwnerUpdate = new List<Account>(); // List fo Accounts for which Account Owner is getting updated by Primary Rep
                Map<Id, Map<Id, AccountTeamMember>> acctId2UserTeamMap = new Map<Id, Map<Id, AccountTeamMember>>(); // map of Account Id as key & map of UserId/ AccountTeamMember
                
                List<AccountAssignments__c> updateAssignments = new List<AccountAssignments__c>(); // List to hold assigment records to update status
                Map<Id,Id> accIdOwnerIdMap = new Map<Id,Id>();
                  
                
               for(AccountAssignments__c objAssignment: oaa)
               {
                inactiveEmpCount = 1;
                String strErrorMessage = '';
                Account acct;
                // If by chance AccounId__c field is null or blank, skip the record
                if(objAssignment.Entity_Id__c != null && objAssignment.Entity_Id__c != '')
                {
                
                
    // Added logic for the case 00294900            
   if(objAssignment.Entity_Id__c.contains('-OMX')){              
          if(objAssignment.AccountType__c == 'S'){
           acct = mapPartySiteId2Account.get(objAssignment.AccountId__c);
          }
          
          else{
            acct = mapPartyId2Account.get(objAssignment.AccountId__c);
          }      
    }
    
    else{ 
                
                   
                    if(objAssignment.AccountType__c == 'A' && objAssignment.Entity_Type__c == 'PROSPECT') // Prospect Account record so Account Id
                        acct = mapPartyId2Account.get(objAssignment.Entity_Id__c);
                    else if(objAssignment.AccountType__c == 'S' && objAssignment.Entity_Type__c == 'PROSPECT') //Prospect  Site record so Site Id
                        acct = mapPartySiteId2Account.get(objAssignment.Entity_Id__c);
                    if(objAssignment.AccountType__c == 'A' && objAssignment.Entity_Type__c == 'CUSTOMER') // Customer Account record so Account Id
                        acct = mapCustId2Account.get(objAssignment.Entity_Id__c);
                    else if(objAssignment.AccountType__c == 'S' && objAssignment.Entity_Type__c == 'CUSTOMER') //Customer Site record so Site Id
                        acct = mapSeqId2Account.get(objAssignment.Entity_Id__c);
     }                   
                   
                    if(acct != null)
                    {
                        accIdOwnerIdMap.put(acct.id, acct.OwnerId); // new code to avoid deleting old accocunt owner share record
                        // Sales Person Id, to be set on Account record
                        
                        //Add Primary rep Id to the Set 
                        User empUser;                        
                        if(objAssignment.PrimaryEmpId__c != null && objAssignment.PrimaryEmpId__c != '')
                            empUser = mapEmpId2User.get(objAssignment.PrimaryEmpId__c);
                        
                        if(empUser != null)
                        {
                         if(mapId2SalesPersons.get(objAssignment.PrimaryEmpRole__c) != null)   
                            {
                            if(acct.OwnerId != empUser.Id || acct.Sales_PersonID__c != mapId2SalesPersons.get(objAssignment.PrimaryEmpRole__c).id)
                            {
                            
                            System.debug('&&&&&&&&&&&&&&&&&empUser.Id'+empUser.Id);
                            
                                acct.OwnerId = empUser.Id;
                              Sales_Person__c sPerson;
                                if(objAssignment.PrimaryEmpRole__c != null && objAssignment.PrimaryEmpRole__c != '')
                                    sPerson = mapId2SalesPersons.get(objAssignment.PrimaryEmpRole__c);
                                
                                if(sPerson != null)
                                    acct.Sales_PersonID__c = sPerson.Id;
                                else
                                    strErrorMessage += ' '+'Not able to find Sales Person Id for Primary Rep Role Related Id '+objAssignment.PrimaryEmpRole__c+'.';
    
                                // add to list for account to update owner id
                                System.debug('&&&&&&&&&&&&&&&&&acct.OwnerId'+acct.OwnerId); 
                                accountOwnerUpdate.add(acct);   
                            }
                            }
                            else 
                            {
                               strErrorMessage += ' '+'Not able to find Sales Person Id for Primary Rep Role Related Id '+objAssignment.PrimaryEmpRole__c+'.';
                            }
                        }
                        else
                            strErrorMessage += ' '+'Account Owner was not updated as not able to find User record for Primary Rep Id '+objAssignment.PrimaryEmpId__c+', user may be inactive.';

   
                    }
                    else
                    {
//                        if(objAssignment.AccountType__c == 'A')
  //                          strErrorMessage += ' '+'Not able to find SFDC Account record for AccuntId '+objAssignment.AccountId__c+'.';
    //                    else
      //                      strErrorMessage += ' '+'Not able to find SFDC Account record for SiteId '+objAssignment.AccountId__c+'.';
                        strErrorMessage += ' '+'Not able to find SFDC Account record for Entity Id.';
                        
                    }
                }
                
                strErrorMessage = strErrorMessage.trim();
                System.debug('ERROR IF ANY == '+strErrorMessage);
                
                //populate the Account ID into the Lookup field -- mohan --10834
                if(acct != null){                   
                    objAssignment.Account__c = acct.Id;
                }
                
                
                if(strErrorMessage.trim() == '')
                { 
                  objAssignment.Status__c = 'Quick - Processed';                   
                }    
                else
                {
                    objAssignment.Error_Message__c = strErrorMessage+'\n';
                    
                    if(acct != null && acctId2UserTeamMap.get(acct.Id) != null && acctId2UserTeamMap.get(acct.Id).size() > 0)
                    {                       
                        objAssignment.Status__c = 'Partially Processed';
                        objAssignment.Error_Type__c='USER-ERROR';
                    }    
                    else
                    {                       
                       objAssignment.Status__c = 'Error';                       
                       objAssignment.Error_Type__c='CUSTOMER-ERROR';
                    }    
                }
                updateAssignments.add(objAssignment);
            }                
                
                
            Database.update(accountOwnerUpdate,false);
            System.debug('&&&&&&&&&&&&&&&&&&&&&&&&&accountOwnerUpdate'+    accountOwnerUpdate);
            Database.update(updateAssignments,false);

    }
}