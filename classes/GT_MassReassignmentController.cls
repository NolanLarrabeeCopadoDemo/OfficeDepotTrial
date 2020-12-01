public class GT_MassReassignmentController {    
    public string radioButtonInput {get;set;}
    public Account prospectToUpdate {get;set;}
    public Account prospectToBeUpdated {get;set;}
    public boolean isProspectDisplayed {get;set;}
    public boolean isOpportunityDisplayed {get;set;}
    public boolean isSelectedOpportunityCheckbox {get;set;}
    public boolean isRecordSuccess{get;set;}
    public boolean isRecordError{get;set;}
    public boolean isQuerySectionVisible{get;set;}
    public boolean isProspectTableVisible{get;set;}
    public boolean isOpportunityTableVisible{get;set;}
    public List<DisplayWrapperClass> prospectWrapperList = new List<DisplayWrapperClass>();
    public List<DisplayWrapperClass> opportunityWrapperList = new List<DisplayWrapperClass>();
    public Set<Id> selectedOpptyIdSet  = new Set<Id>();
    public Set<Id> selectedAccountIdSet = new Set<Id>();
    public List<Opportunity> opptyToBeUpdatedList = new List<Opportunity>();
    public List<Account> accountsToBeUpdatedList = new List<Account>();
    public List<Task> tasksTobeUpdatedList = new List<Task>();
    public List<Event> eventsTobeUpdatedList = new List<Event>();
    public Set<Id> selectedProspectsSet = new Set<Id>();
    List<Account> prospectToBeUpdatedList = new List<Account>();
    public List<Task> relatedOpptyTaskToBeUpdatedList = new List<Task>();
    List<Id> prospectSuccessIdsList;
    List<Id> inputProspectIdsList;
    List<Id> prospectErrorIdsList;
    List<Id> opptySuccessIdsList;
    List<Id> inputOpptyIdsList;
    List<Id> opptyErrorIdsList;
    Set<Id> relatedOpptyIdSet;
    DateTime currentDateTime= System.now();
    public List<account> accountErrorList {get;set;}
    public List<Opportunity> opptyErrorsList {get;set;}
    public String uid;
    public User cUser;
    //Modified By Vipul Jain for Story#S-442659 (00796006 - Opportunity Mass Reassignment for Active or Inactive Users by U.S. DSMs and Above) on October 24,2016
    public boolean isShortTitleMatched{get;set;}
    public set<String> prospectsSet = new set<String>();
    //END
    public GT_MassReassignmentController () {
        isQuerySectionVisible = true;
        //oppToUpdate = new Opportunity();
        if(userinfo.getOrganizationName() == 'Grand & Toy')
        radioButtonInput = 'pros';
        else
        radioButtonInput = 'opp';
        prospectToUpdate = new Account();
        prospectToBeUpdated = new Account();
        // compare the logged user Name with Names is 'User_Short_Title__mdt
                        //Modified By Vipul Jain for Story#S-442659 (00796006 - Opportunity Mass Reassignment for Active or Inactive Users by U.S. DSMs and Above) on October 24,2016
        isShortTitleMatched = false;
        User usr = [Select Id, Short_Title__c from user where id=:Userinfo.getUserID()];
        for (User_Short_Title__mdt repQueueUser:[SELECT MasterLabel, DeveloperName, Id from User_Short_Title__mdt]){
            if(repQueueUser.MasterLabel == usr.Short_Title__c){
                isShortTitleMatched = true;
            }
        }
        prospectsSet.add(Constants.Prospect_OfficeMax);
        prospectsSet.add(Constants.CustomerProspect);
        prospectsSet.add(Constants.ProspectAccount);
        prospectsSet.add(Constants.Customer_OfficeMax);
        //END
        
    }
    
    public List<DisplayWrapperClass> getProspectWrapperList() {
        return prospectWrapperList;
    }
    public List<DisplayWrapperClass> setProspectWrapperList() {
        return prospectWrapperList;
    }
    
    public void setProspectWrapperList(DisplayWrapperClass prospect) {
        prospectWrapperList.add(prospect);
    }
    
    public List<DisplayWrapperClass> getOpportunityWrapperList() {
        return opportunityWrapperList;
    }
    public List<DisplayWrapperClass> setOpportunityWrapperList() {
        return opportunityWrapperList;
    }
    public void setOpportunityWrapperList(DisplayWrapperClass opportunity) {
        opportunityWrapperList.add(opportunity);
    }
    
    
    public String getRadioButtonInput() {
        return radioButtonInput;
    }
    
    public void setRadioButtonInput(String radioButtonInput) {
        this.radioButtonInput = radioButtonInput;
    }
    
    public Class DisplayWrapperClass {
        public Boolean isSelectedOpportunity{get;set;}
        public Boolean isSelectedAccount{get;set;}
        public Opportunity selectedOpportunity{get;set;}
        public Account selectedAccount{get;set;}
        public Account selectedAccountWithoutOpp{get;set;}
        public String selectedAccountOwner{get;set;}
        public String selectedOpportunityOwner{get;set;}
        public String status{get;set;}
        public String errorReason{get;set;}
        public DisplayWrapperClass (Boolean isSelectedOpp, Opportunity selectedOpp, Account selectedAcc, String selectedOwner) {
            isSelectedOpportunity = isSelectedOpp;
            selectedOpportunity = selectedOpp;
            selectedAccount = selectedAcc;
            selectedOpportunityOwner = selectedOwner;
        }
        
        public DisplayWrapperClass (Boolean isSelectedAcc, Account selectedAcc, String selectedOwner) {
            isSelectedAccount = isSelectedAcc;
            selectedAccountWithoutOpp = selectedAcc;
            selectedAccountOwner = selectedOwner;
        }
    }
    
    public List<SelectOption> getRecordOptions() {
        String cuid = Userinfo.getUserID();
        User cu = [select companyname from User where id=:cuid ];
        List<SelectOption> options = new List<SelectOption>(); 
        
        if(cu.companyname=='Grand & Toy'){
            options.add(new SelectOption('pros','Prospect')); 
            options.add(new SelectOption('opp','Opportunity'));
        }
        else{
            options.add(new SelectOption('opp','Opportunity'));
        }
        return options;  
    }
    
    public void queryRecords() {  
        reset();
       
        Map<Id,Id> userIdMap = new Map<Id,Id>();
        List<Account> prospectsList = new List<Account>();
        List<Opportunity> opptyList = new List<Opportunity>();
        List<Opportunity> opptyToDisplay = new List<Opportunity>();
        Set<Id> relatedAccountIdSet = new Set<Id>();
        Map<Id, Account> relatedAccountsMap = new Map<Id, Account>();
        if(radioButtonInput=='pros'){
            isProspectDisplayed = true;
            prospectWrapperList.clear();
            if(prospectToUpdate !=null) {
            system.debug('prospectToUpdate@@@'+prospectToUpdate.recordtype);
            system.debug('prospectToUpdate@@@'+prospectToUpdate.owner);
            system.debug('prospectToUpdate@@@'+prospectToUpdate.ownerid);
            cUser = [select companyname from User where id=:prospectToUpdate.ownerId];
            if(cUser.companyname=='Grand & Toy'){
                prospectsList = [Select id,name,recordtype.name, owner.name from account where ownerid=:prospectToUpdate.ownerid and recordtype.name = 'Prospect (GT)' order by name   limit 1000 ];
            }
            else{
                //Modified By Vipul Jain for Story#S-442659 (00796006 - Opportunity Mass Reassignment for Active or Inactive Users by U.S. DSMs and Above) on October 24,2016
                prospectsList = [Select id,name,recordtype.name, owner.name from account where ownerid=:prospectToUpdate.ownerid and recordtype.name in : prospectsSet order by name   limit 1000 ];
                //END
            }
            system.debug('prospectsList@@@'+prospectsList);
            }
            if(prospectsList!=null && !prospectsList.isEmpty()){
                for(Account prosObj : prospectsList){
                    DisplayWrapperClass dwcObj = new DisplayWrapperClass(false,prosObj,prosObj.owner.name);
                    prospectWrapperList.add(dwcObj);
                }
            }
        }
        else if(radioButtonInput=='opp'){
            isOpportunityDisplayed = true;
            opportunityWrapperList.clear();
            if(prospectToUpdate !=null) {
                cUser = [select companyname from User where id=:prospectToUpdate.ownerId];
                system.debug('prospectToUpdate.Ownerid>>>>>>>>'+prospectToUpdate.Ownerid+'>>>>>cUser.companyname>>>>>>'+cUser.companyname);
                if(cUser.companyname=='Grand & Toy'){    
                    opptylist = [Select id,name,accountid,account.recordtype.name,ownerid,account.ownerid, owner.name from Opportunity where account.ownerid=:prospectToUpdate.Ownerid and isClosed=false and recordtype.name = 'GT Field Sales' order by name limit 1000];
                }
                else{
                    opptylist = [Select id,name,accountid,account.recordtype.name,ownerid,account.ownerid, owner.name from Opportunity where account.ownerid=:prospectToUpdate.Ownerid and isClosed=false and recordtype.name = 'Field Sales (US)' order by name limit 1000];                
                }
                List<ID> accountIdList = new List<ID>();
                for(Opportunity opp : opptyList){
                     accountIdList.add(opp.accountid);
                }
                system.debug('@@accountIdList'+accountIdList);
                List<AccountTeamMember> atmList = new List<AccountTeamMember>();
                system.debug(':::::accountIdList:::::'+accountIdList+'prospectToBeUpdated.Ownerid >>>>>>>'+prospectToBeUpdated.Ownerid );
                if(accountIdList.size()>0)
                atmList = [select Id, accountId , userId from AccountTeamMember where accountId in:accountIdList and userid =:prospectToBeUpdated.Ownerid ];
                system.debug('@@atmList '+atmList );
                for (AccountTeamMember atm: atmlist){ 
                        system.debug('@@atm'+atm);
                        userIdMap.put(atm.id ,atm.accountId);                    
                }
                //opptylist.clear();
                //opptylist = [Select id,name,accountid,account.recordtype.name,ownerid,account.ownerid, owner.name from Opportunity where (ownerid=:prospectToUpdate.Ownerid or ownerId in :userIdList)and isClosed=false and recordtype.name = 'GT Field Sales' order by name limit 1000];
            }
          List<Account>accountList = new List<Account>();   
          List<Id> accOwnerIdList = new List<Id>();
          accountList = [select ownerId,Id from Account where Id IN: userIdMap.values()];
          for(Account accList :accountList){
              accOwnerIdList.add(accList.ownerId);
          }
           //changes made for extra filter condition
           system.debug('@@userIdMap'+userIdMap);
           system.debug('@@accountList '+accountList );
           if(cUser.companyname=='Grand & Toy'){ 
               opptyToDisplay = [Select id,name,accountid,account.recordtype.name,ownerid,account.ownerid, owner.name from Opportunity where ownerid=:prospectToUpdate.Ownerid and (account.ownerid=:prospectToBeUpdated.Ownerid or account.ownerid IN :accOwnerIdList) and isClosed=false and recordtype.name = 'GT Field Sales' order by name limit 1000];
           }
           else{
               opptyToDisplay = [Select id,name,accountid,account.recordtype.name,ownerid,account.ownerid, owner.name from Opportunity where ownerid=:prospectToUpdate.Ownerid and (account.ownerid=:prospectToBeUpdated.Ownerid or account.ownerid IN :accOwnerIdList) and isClosed=false and recordtype.name = 'Field Sales (US)' order by name limit 1000];
           }
           system.debug('@@opptyToDisplay '+opptyToDisplay );
           if(opptyToDisplay!=null && !opptyToDisplay.isEmpty()) {
                for(Opportunity opp:opptyToDisplay){
                    relatedAccountIdSet.add(opp.accountid);
                }
                if(relatedAccountIdSet!=null && !relatedAccountIdSet.isEmpty()){
                    if(cUser.companyname=='Grand & Toy'){     
                        for(Account accObj : [Select id,ownerid from Account where id in : relatedAccountIdSet and recordtype.name='Prospect (GT)']) {
                            relatedAccountsMap.put(accObj.id, accObj);
                        }
                    }
                    else{
                        //Modified By Vipul Jain for Story#S-442659 (00796006 - Opportunity Mass Reassignment for Active or Inactive Users by U.S. DSMs and Above) on October 24,2016
                        for(Account accObj : [Select id,ownerid from Account where id in : relatedAccountIdSet and recordtype.name in : prospectsSet]) {
                        //END
                            relatedAccountsMap.put(accObj.id, accObj);
                        }
                    
                    }
                    for(Opportunity opptyObj : opptyToDisplay) {
                        Account accObj = relatedAccountsMap.get(opptyObj.accountid);
                        if(accObj !=null) {
                            DisplayWrapperClass dwcObj = new DisplayWrapperClass(false, opptyObj, accObj, opptyObj.owner.name );
                            opportunityWrapperList.add(dwcObj);
                        }
                    }   
                }
            }/*else{
                opptyToDisplay = [Select id,name,accountid,account.recordtype.name,ownerid,account.ownerid, owner.name from Opportunity where ownerid=:prospectToUpdate.Ownerid and account.ownerid IN:userIdList and isClosed=false and recordtype.name = 'GT Field Sales' order by name limit 1000];
                if(opptyToDisplay!=null && !opptyToDisplay.isEmpty()) {
                for(Opportunity opp:opptyToDisplay){
                    relatedAccountIdSet.add(opp.accountid);
                }
                if(relatedAccountIdSet!=null && !relatedAccountIdSet.isEmpty()){
                    for(Account accObj : [Select id,ownerid from Account where id in : relatedAccountIdSet and recordtype.name='Prospect (GT)']) {
                        relatedAccountsMap.put(accObj.id, accObj);
                    }
                    for(Opportunity opptyObj : opptyToDisplay) {
                        Account accObj = relatedAccountsMap.get(opptyObj.accountid);
                        if(accObj !=null) {
                            DisplayWrapperClass dwcObj = new DisplayWrapperClass(false, opptyObj, accObj, opptyObj.owner.name );
                            opportunityWrapperList.add(dwcObj);
                        }
                    }   
                }
            }
            }*/
            /*if(opptyList!=null && !opptyList.isEmpty()) {
                for(Opportunity opp:opptylist){
                    relatedAccountIdSet.add(opp.accountid);
                }
                if(relatedAccountIdSet!=null && !relatedAccountIdSet.isEmpty()){
                    for(Account accObj : [Select id,ownerid from Account where id in : relatedAccountIdSet and recordtype.name='Prospect (GT)']) {
                        relatedAccountsMap.put(accObj.id, accObj);
                    }
                    for(Opportunity opptyObj : opptyList) {
                        Account accObj = relatedAccountsMap.get(opptyObj.accountid);
                        if(accObj !=null) {
                            DisplayWrapperClass dwcObj = new DisplayWrapperClass(false, opptyObj, accObj, opptyObj.owner.name );
                            opportunityWrapperList.add(dwcObj);
                        }
                    }   
                }
            }*/
            
            
        }
    }
    
     
    
    public void updateOpportunityOwner(){
         Map<Id,List<Task>> relatedOpptyTaskMap= new Map<Id,List<Task>>();
         Map<Id,List<Task>> relatedAccountTaskMap= new Map<Id,List<Task>>();
         Map<Id,List<Event>> relatedAccountEventMap= new Map<Id,List<Event>>();
         Map<Id,List<Event>> relatedOpptyEventMap= new Map<Id,List<Event>>();
         User ownerToBeUpdated = [Select id,CompanyName from User where id=:prospectToBeUpdated.Ownerid];
         DateTime currentDateTime = System.now();

         for(DisplayWrapperClass dwcObj : opportunityWrapperList)
         {
             if(dwcObj.isSelectedOpportunity == true)
                 {
                     selectedOpptyIdSet.add(dwcObj.selectedOpportunity.id);
                     selectedAccountIdSet.add(dwcObj.selectedOpportunity.accountid);
                 }
         }
         
         
        //To take all the tasks associated with opportunity
        for(Task taskObj:[Select id,whatid,ownerid from task where ownerId=:prospectToUpdate.ownerid and whatid IN:selectedOpptyIdSet and Status!='Completed'])
        {
            List<Task> tasksList= new List<Task>();
            if(relatedOpptyTaskMap.containskey(taskObj.whatid))
            {                  
                tasksList= relatedOpptyTaskMap.get(taskObj.whatid);
                relatedOpptyTaskMap.remove(taskObj.whatid);
                tasksList.add(taskObj);
                relatedOpptyTaskMap.put(taskObj.whatid,tasksList);
            }
            else
            {
                tasksList.add(taskObj);
                relatedOpptyTaskMap.put(taskObj.whatid,tasksList);
            } 

        }
        
         //To take all the events associated with opportunity
        for(Event eventObj:[Select id,whatid,ownerid from Event where ownerId=:prospectToUpdate.ownerid and whatid IN:selectedOpptyIdSet and EndDateTime>:currentDateTime])
        {
            List<Event> eventsList= new List<Event>();
            if(relatedOpptyEventMap.containskey(eventObj.whatid))
            {                  
                eventsList= relatedOpptyEventMap.get(eventObj.whatid);
                relatedOpptyEventMap.remove(eventObj.whatid);
                eventsList.add(eventObj);
                relatedOpptyEventMap.put(eventObj.whatid,eventsList);
            }
            else
            {
                eventsList.add(eventObj);
                relatedOpptyEventMap.put(eventObj.whatid,eventsList);
            } 

        }
        if(selectedAccountIdSet!=null && !selectedAccountIdSet.isEmpty()){
            for(Task taskObj:[Select id,whatid,ownerid from task where ownerId=:prospectToUpdate.ownerid and accountid IN:selectedAccountIdSet and Status!='Completed']) {
                List<Task> tasksList= new List<Task>();
                if(relatedAccountTaskMap.containskey(taskObj.whatid)) {                  
                    tasksList= relatedAccountTaskMap.get(taskObj.whatid);
                    relatedAccountTaskMap.remove(taskObj.whatid);
                    tasksList.add(taskObj);
                    relatedAccountTaskMap.put(taskObj.whatid,tasksList);
                }
                else {
                    tasksList.add(taskObj);
                    relatedAccountTaskMap.put(taskObj.whatid,tasksList);
                } 
    
            }
        
        //To take all the events associated with Account
            for(Event eventObj:[Select id,whatid,ownerid from Event where ownerId=:prospectToUpdate.ownerid and accountid IN : selectedAccountIdSet and EndDateTime>:currentDateTime]) {
                List<Event> eventsList= new List<Event>();
                if(relatedAccountEventMap.containskey(eventObj.whatid)) {                  
                    eventsList= relatedAccountEventMap.get(eventObj.whatid);
                    relatedAccountEventMap.remove(eventObj.whatid);
                    eventsList.add(eventObj);
                    relatedAccountEventMap.put(eventObj.whatid,eventsList);
                }
                else {
                    eventsList.add(eventObj);
                    relatedAccountEventMap.put(eventObj.whatid,eventsList);
                } 
    
            }
        }
         
        
        // The actual update logic begins here....
         if(ownerToBeUpdated!=null)
         {
                 for(DisplayWrapperClass dwcObj : opportunityWrapperList)
                 {
                     if(dwcObj.isSelectedOpportunity==true)
                     {
                         //This snippet is for Prospect GT where onwer change happens for Prospect,Opp and it's related entities(No eligibility criteria)
                         //Modified By Vipul Jain for Story#S-442659 (00796006 - Opportunity Mass Reassignment for Active or Inactive Users by U.S. DSMs and Above) on October 24,2016
                         if(dwcObj.selectedOpportunity.account.recordtype.name=='Prospect (GT)' ||dwcObj.selectedOpportunity.account.recordtype.name==Constants.Prospect_OfficeMax ||dwcObj.selectedOpportunity.account.recordtype.name==Constants.CustomerProspect || dwcObj.selectedOpportunity.account.recordtype.name==Constants.ProspectAccount || dwcObj.selectedOpportunity.account.recordtype.name==Constants.Customer_OfficeMax)
                         //END -Vipul
                         {
                                //Update prospect GT owner
                                dwcObj.selectedAccount.ownerid= prospectToBeUpdated.ownerid;
                                accountsToBeUpdatedList.add(dwcObj.selectedAccount);
                                
                                list<Task> accTasksList= relatedAccountTaskMap.get(dwcObj.selectedOpportunity.accountid);
                                if(accTasksList!=null)
                                {
                                    for(Task t:accTasksList)
                                    {
                                        //Update open acc task owner
                                        t.ownerid= prospectToBeUpdated.ownerid;
                                        tasksTobeUpdatedList.add(t);
                                    }
                                }
                                list<Event> relatedAccountEventsList= relatedAccountEventMap.get(dwcObj.selectedOpportunity.accountid);
                                if(relatedAccountEventsList!=null)
                                {
                                    for(Event t:relatedAccountEventsList)
                                    {
                                        //Update open acc Event owner
                                        t.ownerid= prospectToBeUpdated.ownerid;
                                        eventsTobeUpdatedList.add(t);
                                    }
                                } 
                               
                                //update opp owner
                                dwcObj.selectedOpportunity.ownerid= prospectToBeUpdated.ownerid;                               
                                opptyToBeUpdatedList.add(dwcObj.selectedOpportunity);
                                list<Task> relatedTasksOpptyList= relatedOpptyTaskMap.get(dwcObj.selectedOpportunity.id);
                                if(relatedTasksOpptyList!=null)
                                {
                                    for(Task t:relatedTasksOpptyList)
                                    {
                                        //Update open opp task owner
                                        t.ownerid= prospectToBeUpdated.ownerid;
                                        tasksTobeUpdatedList.add(t);
                                    }
                                }
                                list<Event> relatedOpptyEventsList= relatedOpptyEventMap.get(dwcObj.selectedOpportunity.id);
                                if(relatedOpptyEventsList!=null)
                                {
                                    for(Event t:relatedOpptyEventsList)
                                    {
                                        //Update open opp Event owner
                                        t.ownerid= prospectToBeUpdated.ownerid;
                                        eventsTobeUpdatedList.add(t);
                                    }
                                } 
                                //dwcObj.Status='Success';
                         }
                         //Prospect GT ends here 
                     }
                 }
             }
                                 
         
            Map<Id,String> fetchOpportunityUpdateErrorMap= new Map<Id,String>();
            Map<Id,String> fetchAccountUpdateErrorMap= new Map<Id,String>();
             
            try {
                Database.SaveResult[] srList;
                if(opptyToBeUpdatedList!=null && !opptyToBeUpdatedList.isEmpty() )  {                             
                    try {
                        srList = Database.Update(opptyToBeUpdatedList, false);
                    }
                    catch(Exception e){
                        system.debug('Exception'+e);
                    }
                    // Iterate through each returned result
                    for (Database.SaveResult sr : srList) 
                    {
                        if (sr.isSuccess()) {
                            // Operation was successful, so get the ID of the record that was processed
                            isQuerySectionVisible = false;
                            isOpportunityDisplayed = false;
                            isRecordSuccess = true;
                            System.debug('Successfully updated opportunity ' + sr.getId());
                            System.debug('Success Status-->'+sr.isSuccess());
                        }
                        else {
                            // Operation failed, so get all errors                
                            isQuerySectionVisible = false;
                            isOpportunityDisplayed = false;
                            isRecordSuccess = false;
                            isRecordError = true;
                            isOpportunityTableVisible = true;
                            inputOpptyIdsList = new List<Id>();
                            for(Opportunity opp: opptyToBeUpdatedList) {
                                inputOpptyIdsList.add(opp.id);
                            }
                            if(opptySuccessIdsList==null || opptySuccessIdsList.isEmpty()){
                                opptyErrorIdsList = new List<Id>();
                                for(Opportunity opp: opptyToBeUpdatedList){
                                    opptyErrorIdsList.add(opp.id);
                                }
                            }
                            else {
                                opptyErrorIdsList = new List<Id>();
                                for(integer i=0; i<inputOpptyIdsList.size();i++) {
                                    for(integer j=0;j<opptySuccessIdsList.size();j++) {
                                        if(inputOpptyIdsList[i]==opptySuccessIdsList[j]){
                                            opptyErrorIdsList.add(inputOpptyIdsList[i]);
                                        }
                                    }
                                }
                            }
                            if(opptyErrorIdsList!=null && !opptyErrorIdsList.isEmpty()) {
                                opptyErrorsList = new List<Opportunity>();
                                opptyErrorsList = [select id, name, owner.name from Opportunity where id in : opptyErrorIdsList];
                            }
                            
                            for(Database.Error err : sr.getErrors()) {
                                fetchOpportunityUpdateErrorMap.put(sr.getId(),err.getMessage());
                                System.debug('The following error has occurred.');                    
                                System.debug(err.getStatusCode() + ': ' + err.getMessage());
                                System.debug('opportunity error field: ' + err.getFields());
                            }
                        }
                    }
                }
                if(accountsToBeUpdatedList!=null && !accountsToBeUpdatedList.isEmpty()) {
                    Database.SaveResult[] srList1 = Database.Update(accountsToBeUpdatedList, True);
        
                    // Iterate through each returned result
                    for (Database.SaveResult sr : srList1) {
                        if (sr.isSuccess()) {
                            // Operation was successful, so get the ID of the record that was processed
                            isRecordSuccess = true;
                            isQuerySectionVisible = false;
                            isRecordError = false;
                            System.debug('Successfully updated account' + sr.getId());
                            System.debug('Success Status-->'+sr.isSuccess());
                        }
                        else {
                            // Operation failed, so get all errors                
                            isQuerySectionVisible = false;
                            isOpportunityDisplayed = false;
                            isRecordSuccess = false;
                            isRecordError = true;
                            isProspectTableVisible = true;
                            for(Database.Error err : sr.getErrors()) {
                                fetchAccountUpdateErrorMap.put(sr.getId(),err.getMessage());
                                System.debug('The following error has occurred.');                    
                                System.debug(err.getStatusCode() + ': ' + err.getMessage());
                                System.debug('account error field: ' + err.getFields());
                            }
                        }
                    }
                }
                if(eventsTobeUpdatedList!=null && !eventsTobeUpdatedList.isEmpty()){
                    database.update(eventsTobeUpdatedList);
                }
                if(tasksTobeUpdatedList!=null && !tasksTobeUpdatedList.isEmpty()){
                    database.update(tasksTobeUpdatedList);
                }
                   
           }
           catch(Exception e){
               //Database.rollback(sp);
               ApexPages.addMessages(e); 
           }
    
   }
   
    public void updateProspectOwners() {
         User ownerToBeUpdated = [Select id,CompanyName from User where id=:prospectToBeUpdated.Ownerid];
         DateTime currentdatetime= System.now();
         relatedOpptyIdSet = new Set<Id>();
        for(DisplayWrapperClass dwcObj:prospectWrapperList)
         {
             if(dwcObj.isSelectedAccount==true) {
                     selectedProspectsSet.add(dwcObj.selectedAccountWithoutOpp.id);
             }
         }
        
        
        
        //To take all the Opportunity associated with Prospect GT
        for(Opportunity oppObj:[Select id, ownerid, accountId from Opportunity where ownerId=:prospectToUpdate.ownerId and accountId IN:selectedProspectsSet and isClosed=false])
        {
            oppObj.ownerid = prospectToBeUpdated.Ownerid;
            opptyToBeUpdatedList.add(oppObj);
            relatedOpptyIdSet.add(oppObj.id);

        }
        if(relatedOpptyIdSet!=null && !relatedOpptyIdSet.isEmpty()){
            for(Task taskOpptyObj : [Select id,whatid,ownerid from task where ownerId=:prospectToUpdate.ownerid and whatid IN : relatedOpptyIdSet and isclosed = false]){
                taskOpptyObj.ownerId = prospectToBeUpdated.Ownerid;
                relatedOpptyTaskToBeUpdatedList.add(taskOpptyObj);
            }
        }
        
        
        //To take all the tasks associated with Prospect GT
        for(Task taskObj:[Select id,whatid,ownerid from task where ownerId=:prospectToUpdate.ownerid and accountId IN : selectedProspectsSet and Status!='Completed'])
        {
            taskObj.ownerId = prospectToBeUpdated.Ownerid;
            tasksToBeUpdatedList.add(taskObj);

        }
        
        
         //To take all the events associated with Prospect GT
        for(Event eventObj:[Select id,whatid,ownerid from Event where ownerId=:prospectToUpdate.ownerid and accountId IN:selectedProspectsSet and EndDateTime>:currentdatetime])
        {
            eventObj.ownerId = prospectToBeUpdated.Ownerid;
            eventsTobeUpdatedList.add(eventObj);
        }
 
         for(DisplayWrapperClass dwcObj : prospectWrapperList)
         {
             if(dwcObj.isSelectedAccount) {
                 selectedProspectsSet.add(dwcObj.selectedAccountWithoutOpp.id);
                 dwcObj.selectedAccountWithoutOpp.ownerid = prospectToBeUpdated.ownerid;
                 prospectToBeUpdatedList.add(dwcObj.selectedAccountWithoutOpp);
             }
         }
           
              if(prospectToBeUpdatedList!=null && !prospectToBeUpdatedList.isEmpty()) {
                    prospectSuccessIdsList = new List<Id>();
                    Database.SaveResult[] srList1;
                    try {
                        srList1 = Database.Update(prospectToBeUpdatedList, false);
                        for (Database.SaveResult sr : srList1) {
                            if (sr.isSuccess()) {
                                prospectSuccessIdsList.add(sr.getId());
                                isQuerySectionVisible = false;
                                isProspectDisplayed = false;
                                isRecordSuccess = true;
                                // Operation was successful, so get the ID of the record that was processed
                                System.debug('Successfully updated account' + sr.getId());
                                System.debug('Success Status-->'+sr.isSuccess());
                            }
                        }
                    }   
                    catch(Exception e) {
                        system.debug('Exception'+e);
                    }
        
                    // Iterate through each returned result
                    system.debug('%%%%%%%%%%%%%5'+srlist1);
                    for (Database.SaveResult sr : srList1) {
                        if (sr.isSuccess()) {
                            isQuerySectionVisible = false;
                            isProspectDisplayed = false;
                            isRecordSuccess = true;
                            // Operation was successful, so get the ID of the record that was processed
                            System.debug('Successfully updated account' + sr.getId());
                            System.debug('Success Status-->'+sr.isSuccess());
                        }
                        else {
                            // Operation failed, so get all errors                
                            isQuerySectionVisible = false;
                            isProspectDisplayed = false;
                            isRecordSuccess = false;
                            isRecordError = true;
                            isProspectTableVisible = true;
                            inputProspectIdsList = new List<Id>();
                            for(Account acc: prospectToBeUpdatedList) {
                                inputProspectIdsList.add(acc.id);
                            }
                            system.debug('@@@@@@@@@prospectSuccessIdsList'+prospectSuccessIdsList);
                            if(prospectSuccessIdsList==null || prospectSuccessIdsList.isEmpty()){
                                prospectErrorIdsList = new List<Id>();
                                for(Account acc: prospectToBeUpdatedList){
                                    prospectErrorIdsList.add(acc.id);
                                }
                                system.debug('#######prospectErrorIdsList'+prospectErrorIdsList);
                            }
                            //system.debug('@@@@@@@@@@@@@@@@@@inputProspectIdsList'+inputProspectIdsList);
                            else {
                                prospectErrorIdsList = new List<Id>();
                                for(integer i=0; i<inputProspectIdsList.size();i++) {
                                    for(integer j=0;j<prospectSuccessIdsList.size();j++) {
                                        if(inputProspectIdsList[i]==prospectSuccessIdsList[j]){
                                            prospectErrorIdsList.add(inputProspectIdsList[i]);
                                        }
                                    }
                                }
                            }
                        if(prospectErrorIdsList!=null && !prospectErrorIdsList.isEmpty()) {
                            accountErrorList = new List<account>();
                            accountErrorList = [select id, name, owner.name from Account where id in : prospectErrorIdsList];
                        }
                        system.debug('@@@@@@@prospectErrorIdsList'+prospectErrorIdsList);
                            for(Database.Error err : sr.getErrors()) {
                                                
                                System.debug('@@@@@@@@@'+err.getStatusCode() + ': ' + err.getMessage());
                                System.debug('@@@@@@@@@account error field: ' + err.getFields());
                            }
                        }
                    }
               }
           
            
         try {
         
             if(opptyToBeUpdatedList!=null && !opptyToBeUpdatedList.isEmpty()) {
                 update opptyToBeUpdatedList;
             }
                 
             if(tasksToBeUpdatedList!=null && !tasksToBeUpdatedList.isEmpty()) {
                 update tasksToBeUpdatedList;
             }
             if(eventsTobeUpdatedList!=null && !eventsTobeUpdatedList.isEmpty()) {
                 update eventsTobeUpdatedList;
             }
             if(relatedOpptyTaskToBeUpdatedList!=null && !relatedOpptyTaskToBeUpdatedList.isEmpty()) {
                 update relatedOpptyTaskToBeUpdatedList;
             }
             
         }
          catch(Exception e) {
              System.debug(e);
          }   
    }
    
    public void reset(){
        prospectWrapperList.clear();
        opportunityWrapperList.clear();
        isProspectDisplayed = false;
        isOpportunityDisplayed = false;
    }
    
    public PageReference backBtnOnClick(){
        PageReference reDirect = new PageReference('/apex/GT_MassReassignment');
        reDirect.setRedirect(true);
        return reDirect;
    }
}