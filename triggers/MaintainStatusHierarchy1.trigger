trigger MaintainStatusHierarchy1 on Customer_Transition__c (after update, before update,after insert,before insert)
{
    Set<Id> setAccCasID = new Set<Id>(); // Pick up Accounts
    Set<Id> setAccReSchID = new Set<Id>(); // Pick up Accounts
    Set<Id> setaccid = new Set<Id>(); // Pick up Accounts
    Set<Id> setErrorCheckID = new Set<Id>(); // Pick up Accounts
    Map<String,String> mapCTID_Status = new Map<String,String>();
    Map<String,boolean> mapCTID_ReadySetup = new Map<String,Boolean>();
    Map<String,date> mapCTID_reviewdate = new Map<String,date>();
    Map<Id,Customer_Transition__c> mapofCT = new Map<Id,Customer_Transition__c>();
    Map<Id,Customer_Transition__c> mapofParentCT = new Map<Id,Customer_Transition__c>();
    List<Customer_Transition__c> updateCusTranFwd = new List<Customer_Transition__c>();
    List<Customer_Transition__c> updateCusTranBack= new List<Customer_Transition__c>();
    List<Customer_Transition__c> newtrigger = new List<Customer_Transition__c>();
    Customer_Transition__c oldrec = new Customer_Transition__c();
    Boolean iscascade = false;
    Customer_Transition_History__c history = new Customer_Transition_History__c();
    List<Customer_Transition_History__c> CTH = new List<Customer_Transition_History__c>();
    List<Customer_Transition__c> CTHistory = new List<Customer_Transition__c>();
     
    // Set<String> sString = new Set<String>{'UnScheduled','Scheduled','On Deck','Launched'};
    
    
    
        //Populating the Parent Transition on the new record as per case # 00259476 
    if(trigger.isbefore && trigger.isinsert){
    system.debug('<<<<populate parent>>>>');
        map<id,id> mapCTacc= new map<id,id>();
        
        // Adding the Parent Account Id's in set
        for(customer_transition__c c:trigger.new){
            if(c.Parent_ID__c!= null)
            setaccid.add(c.Parent_ID__c);
        }
    system.debug('****setaccid>>>>>'+setaccid);
        
        // Populate a MAP of the Parent Account and its Customer Transition
        for(customer_transition__c ctlist : [select id,account__c,account__r.parent.id,Parent_Transition_ID__c from customer_transition__c where account__c in : setaccid]){
            mapCTacc.put(ctlist.account__c,ctlist.id);
            system.debug('mapCTacc>>>>&&&>>>>'+mapCTacc);
        }
        
        // Assigning the Parent Customer Transition record to the Parent Transition Field
        for(customer_transition__c ct: trigger.new){
            system.debug('mapCTacc.get(ct.Parent_ID__c)>>'+mapCTacc.get(ct.Parent_ID__c)+'<<<<Parent Account>>>>'+ct.Parent_ID__c+'<<<<mapCTacc>>>>'+mapCTacc.containskey(ct.Parent_ID__c));
            if(mapCTacc.containskey(ct.Parent_ID__c)){ 
                system.debug('mapCTacc.get(ct.Parent_ID__c)>>>>>'+mapCTacc.get(ct.Parent_ID__c));
                ct.Parent_Transition_ID__c = mapCTacc.get(ct.Parent_ID__c);
            }
            system.debug('//ct.Parent_Transition_ID__c>>>>>>******>>>>'+ct.Parent_Transition_ID__c);
        }
    }      
    

    
    
        if(Trigger.IsUpdate   &&  trigger.isbefore)
        {
    
             for (Customer_Transition__c CT : Trigger.New) {
               if (CT.Ready_for_Mod1__c  && !(Trigger.oldmap.get(CT.ID).Ready_for_Mod1__c  ))
                 CT.status__C = 'Launched';
                                  
             }
        }

    
                system.debug('<<<<<Entering InsertConstantsExt.bypassCTMaintTrigger>>>>>'+ConstantsExt.bypassCTMaintTrigger);

    
if(ConstantsExt.bypassCTMaintTrigger==true){    
    
    
    
    if(Trigger.IsInsert && Trigger.IsAfter){
        for(Customer_Transition__c CT : Trigger.New){
            system.debug('<<<<<Entering Insert>>>>>');
            if(CT.Review_Start_Date__c!= null && executeoncetest.OnceExecuted == true)
            {
                history.Review_Start_Date__c = CT.Review_Start_Date__c;
                history.Related_Customer_Transition__c = CT.id;
                CTH.add(history);
                executeoncetest.OnceExecuted = false;
            }
        }
        insert CTH;
    }
    
    if(Trigger.IsUpdate)
    {
    
      
        if(trigger.isafter){
        for (Customer_Transition__c CT : Trigger.New) 
        {
               // Customer_Transition__c oldrec= Trigger.oldMap.get(CT.id);
                system.debug('>>>>>>>>'+Trigger.New);
                oldrec= Trigger.oldMap.get(CT.id);
                System.debug('oldrec-->'+oldrec.Status__c);
                system.debug('<<<iscascade>>>>'+iscascade);
                system.debug('executeoncetest.cascadeReviewDate>>>>'+executeoncetest.cascadeReviewDate);
                if(CT.Account__c!=null)
                {
                    setaccid.add(CT.Account__c); 
                    system.debug('AcctStatus>>>>:'+ CT.Account__c+CT.Status__c);
                    mapCTID_Status.put(CT.Account__c,CT.Status__c);
                    mapCTID_ReadySetup.put(CT.Account__c,CT.Ready_for_Mod1__c);
                    mapCTID_reviewdate.put(CT.Account__c,CT.Review_Start_Date__c);
                    system.debug('Has an Account????');
                    // Forward Case
                    if(((CT.Status__c == 'UnScheduled' || CT.Status__c == 'Scheduled' || 
                       CT.Status__c == 'ReScheduled' || CT.Status__c == 'On Deck' || 
                       CT.Status__c == 'Assessment' || CT.Status__c == 'Launched' )
                       //&& oldrec.Status__c != 'Launched' && 
                       //oldrec.Status__c != CT.Status__c &&                        
                       && (executeoncetest.cascadedown==false)) || executeoncetest.cascadeReviewDate==false){
                       system.debug('@@@@@@@'+CT.Account__c);
                       setAccCasID.add(CT.Account__c);
                       system.debug('@@@@@setAccCasID@@@@@@@'+setAccCasID);
                       }
                       
                       system.debug('>>>>>>setAccCasID>>>'+setAccCasID);
                       
                    // Forward Case Code Ends
                    
                    // Backward Case
                    
                    if(oldrec.Status__c=='Launched' && CT.Status__c!='Launched' && executeoncetest.cascadeReviewDate != false) //&& oldrec.Status__c != CT.Status__c
                    {
                    //00709835 commenting below line
                        /////////////setAccReSchID.add(CT.Account__c);
                        //if(executeoncetest.cascadedown==false)
                        //setAccCasID.add(CT.Account__c);
                        
                    }   
                    // Backward Case Code Ends
                    if(CT.Status__c=='Launched' && executeoncetest.cascadeReviewDate != false)//&& oldrec.Status__c != CT.Status__c
                    {
                        setErrorCheckID.add(CT.Account__c);
                    }
                    
                }
                system.debug('@oldrec.Review_Start_Date__c'+oldrec.Review_Start_Date__c);
                system.debug('@CT.Review_Start_Date__c'+CT.Review_Start_Date__c);
                system.debug('executeoncetest.OnceExecuted>>>>>>>'+executeoncetest.OnceExecuted);
                if(oldrec.Review_Start_Date__c!=CT.Review_Start_Date__c)
                {
                    CTHistory.add(CT);
                    system.debug('CTHistory>>>>>>????>>>>>'+CTHistory);
                /*    system.debug('<<<<<<Entering Existing record condition>>>>>>>');
                    history.Review_Start_Date__c = CT.Review_Start_Date__c;
                    history.Related_Customer_Transition__c = CT.id;
                    CTH.add(history);
                    executeoncetest.OnceExecuted = false;*/
                }
                
        } // For Loop for setting the initial map
        
        for(Customer_Transition__c c:CTHistory){
                system.debug('executeoncetest.OnceExecuted>>>>>>>'+executeoncetest.OnceExecuted);
                if(executeoncetest.OnceExecuted == true)
                {
                    //if(c.id!=null || c.id!='')
                    executeoncetest.recCTset.add(c.id);
                    system.debug('<<<<<<Entering Existing record condition>>>>>>>');
                    history.Review_Start_Date__c = C.Review_Start_Date__c;
                    history.Related_Customer_Transition__c = C.id;
                    CTH.add(history);
                    if(executeoncetest.recCTset.contains(c.id))
                    executeoncetest.OnceExecuted = false;
                    else
                    executeoncetest.OnceExecuted = true;
                }       
        }
        insert CTH;
        }
        
        if(trigger.isbefore){
        // Cascade down is always false
        for(Customer_Transition__c newCT: Trigger.New)
          {
                if(newCT.Cascade_Down__c == true)
                {
                executeoncetest.cascadedown = false;
                newCT.Cascade_Down__c = false;
                }
                if(newCT.Cascade_Review_Start_Date__c == true)
                {
                system.debug('executeoncetest.cascadeReviewDate#######'+executeoncetest.cascadeReviewDate);
                executeoncetest.cascadeReviewDate = false;
                newCT.Cascade_Review_Start_Date__c = false;
                }
          }
        }
        // Error Scenario Start Here
            if(setErrorCheckID.size()>0 && executeoncetest.updateonceCustransErr)
            {
                system.debug('In loop 1');
                Set<ID> sChildIDs = new Set<ID>();   
                system.debug('@@setErrorCheckID '+setErrorCheckID );
               
                List<Account> l3Accounts = [Select id,parentID,parent.parentID,name from Account where id in : setErrorCheckID and parentID != null and parent.parentID != null];
                system.debug('@@l3Accounts'+l3Accounts);
                Set<ID> sParentID = new Set<ID>();
                Set<ID> sGParentID = new Set<ID>();
                for(Account acc : l3Accounts){
                       sChildIDs.add(acc.id); 
                       sParentID.add(acc.parentId);
                       sGParentID.add(acc.parent.parentId);
                }
                
                system.debug('In loop 2');
                //system.debug('sChildIDs'+sChildIDs);
                system.debug('sParentID'+sParentID);
                //system.debug('sGParentID'+sGParentID);
                system.debug('setErrorCheckID '+setErrorCheckID );
                
                List<Account> l2Accounts = [Select id,parentID,parent.parentID,name from Account where id in: setErrorCheckID and id not in :sParentID and parentID != null and parent.parentID = null];
                Set<ID> s2ParentID = new Set<ID>();
                for(Account acc : l2Accounts)
                  {     sChildIDs.add(acc.id); 
                          s2ParentID.add(acc.parentId);
                    }
                
                system.debug('In loop 3'  + s2ParentID);
                //system.debug('sChildIDs'+sChildIDs);
                //system.debug('s2ParentID'+sParentID);
                
                List<Account> l1Accounts = [Select id,parentID,parent.parentID,name from Account where id in: setErrorCheckID and id not in :sParentID and id not in :s2ParentID and id not in :sGParentID and parentID = null and parent.parentID = null];
                for(Account acc: l1Accounts)
                    sChildIDs.add(acc.id); 
                
                system.debug('In loop 4'  + sChildIDs);
                
                //For a child record to be scheduled, the parent must be Scheduled or must already be tresent in the AOPS server
                for(Customer_Transition__c CT_Alias : [Select id,Account__r.parentID,Parent_Transition_ID__r.Account__r.AOPS_Cust_Id__c,Parent_Transition_ID__r.Status__c,Account__c,Parent_Transition_ID__c,Parent_Transition_ID__r.Account__c from Customer_Transition__c where  account__c in: sChildIDs ])
                    MapofCT.put(CT_Alias.Account__c,CT_Alias);
                
                //For a child record to be scheduled, the parent must be Scheduled or must already be tresent in the AOPS server
                for(Customer_Transition__c CT_Alias : [Select id,Account__r.AOPS_Cust_Id__c,Status__c,Account__c,Parent_Transition_ID__c,Parent_Transition_ID__r.Account__c from Customer_Transition__c where  account__c in: sParentID or account__c in: s2ParentID])
                    mapofParentCT.put(CT_Alias.Account__c,CT_Alias);
                 
                
                system.debug('In loop MapofCT'  + MapofCT);
                system.debug('In loop mapofParentCT'  + mapofParentCT);
                
                Map<ID,Account> map_ID_Acc = new Map<ID,Account>([Select id, name, parentID from Account where id in: setaccid]);
                  
                system.debug('The map-->'+MapofCT);
                for(Customer_Transition__c newCT: Trigger.New)
                {
                    system.debug('@@newCT.Status__c'+newCT.Status__c);
                    system.debug('@@'+Trigger.OldMap.get(newCT.id).Status__c);
                    if(newCT.Status__c=='Launched' && Trigger.OldMap.get(newCT.id).Status__c != newCT.Status__c)
                    {
                        system.debug('@@newCT.Account__c'+newCT.Account__c);
                        Customer_Transition__c ErrorCT= MapofCT.get(newCT.Account__c);
                        if(ErrorCT!=null)
                        {
                            system.debug('In loop 5'  + ErrorCT);
                            Account ac = map_ID_Acc.get(newCT.Account__c); 
                            if(ac != null){
                                if(ac.parentid != null){
                                Customer_Transition__c ErrorParentCT= mapofParentCT.get(ac.parentid);
                                if(ErrorParentCT != null){
                                    system.debug('In loop 6'  + ErrorParentCT );
                                    if((ErrorParentCT.Account__r.AOPS_Cust_Id__c==null || ErrorParentCT.Account__r.AOPS_Cust_Id__c=='') && ErrorParentCT.Status__c!='Launched')
                                    {
                                      //////////  newCT.adderror('ERROR: The Parent record must be Launched Or must be present in AOPS');
                                    }
                                }}
                            }
                        }
                    }
                }
                
                 executeoncetest.updateonceCustransErr=false;
                //End....    
            }
        // Error Scenario Ends Here
        
        
        // Forward Scenario
        Set<Id> childinLoad=new Set<Id>();
        if(setAccCasID.size()>0 && executeoncetest.updateonceCustrans)//
        {
            //Cascade down the status of parent to it's below levels.....
            List<Customer_Transition__c> updateHierarchy= [Select id,Status__c,Account__r.parentid,Account__r.parent.parentid from Customer_Transition__c /*where (Account__r.parentid in : setAccCasID OR Account__r.parent.parentid in : setAccCasID)*/];
            
            Map<ID,List<Customer_Transition__c>> map_ACCID_lCust = new Map<ID,List<Customer_Transition__c>>();
            Map<ID,List<Customer_Transition__c>> map_GPACCID_lCust = new Map<ID,List<Customer_Transition__c>>();
            
            system.debug('updateHierarchy--@@--'+updateHierarchy );

            System.debug('### ' + setAccCasID);

            if(updateHierarchy != null){
                for(Customer_Transition__c CT1:updateHierarchy)
                {
                    if(!map_ACCID_lCust.containsKey(CT1.Account__r.parentid))
                    {
                        List<Customer_Transition__c> lCust = new List<Customer_Transition__c>();
                        lCust.add(CT1);
                        map_ACCID_lCust.put(CT1.Account__r.parentid,lCust);
                    }
                    else
                    {
                        List<Customer_Transition__c> lCust = new List<Customer_Transition__c>();
                        lCust = map_ACCID_lCust.get(CT1.Account__r.parentid);
                        lCust.add(CT1);
                        map_ACCID_lCust.remove(CT1.Account__r.parentid);
                        map_ACCID_lCust.put(CT1.Account__r.parentid,lCust);
                    }
                    
                    if(!map_GPACCID_lCust.containsKey(CT1.Account__r.parent.parentid))
                    {
                        List<Customer_Transition__c> lCust = new List<Customer_Transition__c>();
                        lCust.add(CT1);
                        map_GPACCID_lCust.put(CT1.Account__r.parent.parentid,lCust);
                    }
                    else
                    {
                        List<Customer_Transition__c> lCust = new List<Customer_Transition__c>();
                        lCust = map_GPACCID_lCust.get(CT1.Account__r.parent.parentid);
                        lCust.add(CT1);
                        map_GPACCID_lCust.remove(CT1.Account__r.parent.parentid);
                        map_GPACCID_lCust.put(CT1.Account__r.parent.parentid,lCust);
                    }
                    
                  
                }   
            }  
            
            for(ID s : setAccCasID )
            {
                String stat = mapCTID_Status.get(s);
                boolean readysetup = mapCTID_ReadySetup.get(s);
                system.debug('IDSTAT>>>>:'+s+stat);
                Date review = mapCTID_reviewdate.get(s);
                List<Customer_Transition__c> lChildCust = new List<Customer_Transition__c>();
                List<Customer_Transition__c> lGChildCust = new List<Customer_Transition__c>();
                
                if(map_ACCID_lCust.get(s) != null){    
                    lChildCust = map_ACCID_lCust.get(s);}
                
                if(map_GPACCID_lCust.get(s) != null)
                    lGChildCust = map_GPACCID_lCust.get(s);
                
                if(lChildCust != null){     
                for(Customer_Transition__c CT1:lChildCust)
                {
                    // Processing All childs
                    
                    //Childs in the current Trigger.new load
                    if(setaccid.contains(CT1.Account__c)) {
                        childinLoad.add(CT1.Account__c);
                        
                    }
                    else
                    {
                        //Childs outside the load
                        if(executeoncetest.cascadedown==false){
                        //executeoncetest.OnceExecuted = false;
                        CT1.Status__c = Stat;
                        //CT1.Ready_for_Mod1__c = readysetup;
                       
                        
                        }
                        if(executeoncetest.cascadeReviewDate==false){
                        executeoncetest.OnceExecuted = true;
                        CT1.Review_Start_Date__c = review;
                        }
                        //CT1.Status__c = Stat;
                        updateCusTranFwd.add(CT1);
                    }
                }
                }
                
                if(lGChildCust!= null){ 
                for(Customer_Transition__c CT1:lGChildCust)
                {
                    // Processing All Grand childs
                    
                    //Childs in the current Trigger.new load
                    if(setaccid.contains(CT1.Account__c))
                        childinLoad.add(CT1.Account__c);
                    else
                    {
                        //Childs outside the load
                       
                        if(executeoncetest.cascadedown==false){
                        CT1.Status__c = Stat;
                        //CT1.Ready_for_Mod1__c = readysetup;
                      
                          
                        //executeoncetest.OnceExecuted = true;
                        }
                        
                        if(executeoncetest.cascadeReviewDate==false){
                        CT1.Review_Start_Date__c = review;
                        executeoncetest.OnceExecuted = true;
                        }
                        //CT1.Status__c = Stat;
                        updateCusTranFwd.add(CT1);
                    }
                }
                }
            
                for(Customer_Transition__c newCT: Trigger.New)
                {
                   
                    if(childinLoad.contains(newCT.Account__c))
                        
                        if(executeoncetest.cascadedown==false) {
                          newCT.Status__c = Stat;
                          newCT.Ready_for_Mod1__c = readysetup;
                          
                        }
                        
                        //if(executeoncetest.cascadeReviewDate==false)
                        //executeoncetest.OnceExecuted = true;
                        //newCT.Review_Start_Date__c = review;
                        //newCT.Status__c = Stat;
                        
                }
              }
              
            executeoncetest.updateonceCustrans=false;
            if(updateCusTranFwd.size()>0) {
                system.debug('RecordDetails>>>>' + updateCusTranFwd[0].id + updateCusTranFwd[0].status__c + updateCusTranFwd[0].Ready_for_Mod1__c);
                update updateCusTranFwd;
             }
            
            //End.....
        }
        // Forward Scenario Code Ends
        
       
        
        
        // Backward Scenario
        Set<Id> childinLoad1 =new Set<Id>();
        /*
        if(setAccReSchID.size()>0 && executeoncetest.updateonceCustrans1)
        {
          
            //Cascade down the status of parent to it's below levels.....
            List<Customer_Transition__c> updateHierarchy= [Select id,Status__c,Account__r.parentid,Account__r.parent.parentid from Customer_Transition__c where Status__c='Launched' and (Account__r.parentid in : setAccReSchID OR Account__r.parent.parentid in : setAccReSchID)];
            
            Map<ID,List<Customer_Transition__c>> map_ACCID_lCust = new Map<ID,List<Customer_Transition__c>>();
            Map<ID,List<Customer_Transition__c>> map_GPACCID_lCust = new Map<ID,List<Customer_Transition__c>>();
            
                if(updateHierarchy != null){
                for(Customer_Transition__c CT1:updateHierarchy)
                {
                    if(!map_ACCID_lCust.containsKey(CT1.Account__r.parentid))
                    {
                        List<Customer_Transition__c> lCust = new List<Customer_Transition__c>();
                        lCust.add(CT1);
                        map_ACCID_lCust.put(CT1.Account__r.parentid,lCust);
                    }
                    else
                    {
                        List<Customer_Transition__c> lCust = new List<Customer_Transition__c>();
                        lCust = map_ACCID_lCust.get(CT1.Account__r.parentid);
                        lCust.add(CT1);
                        map_ACCID_lCust.remove(CT1.Account__r.parentid);
                        map_ACCID_lCust.put(CT1.Account__r.parentid,lCust);
                    }
                    
                    if(!map_GPACCID_lCust.containsKey(CT1.Account__r.parent.parentid))
                    {
                        List<Customer_Transition__c> lCust = new List<Customer_Transition__c>();
                        lCust.add(CT1);
                        map_GPACCID_lCust.put(CT1.Account__r.parent.parentid,lCust);
                    }
                    else
                    {
                        List<Customer_Transition__c> lCust = new List<Customer_Transition__c>();
                        lCust = map_GPACCID_lCust.get(CT1.Account__r.parent.parentid);
                        lCust.add(CT1);
                        map_GPACCID_lCust.remove(CT1.Account__r.parent.parentid);
                        map_GPACCID_lCust.put(CT1.Account__r.parent.parentid,lCust);
                    }
                    
                  
                }   
                }  
            
            for(ID s : setAccReSchID)
            {
                String stat = mapCTID_Status.get(s);
                boolean readysetup = mapCTID_ReadySetup.get(s);
                system.debug('idstat>>:'+s+stat);
                List<Customer_Transition__c> lChildCust = new List<Customer_Transition__c>();
                List<Customer_Transition__c> lGChildCust = new List<Customer_Transition__c>();
                
                if(map_ACCID_lCust.get(s) != null){    
                    lChildCust = map_ACCID_lCust.get(s);}
                
                if(map_GPACCID_lCust.get(s) != null)
                    lGChildCust = map_GPACCID_lCust.get(s);
                
                if(lChildCust != null){     
                for(Customer_Transition__c CT1:lChildCust)
                {
                    // Processing All childs
                    
                    //Childs in the current Trigger.new load
                    if(setaccid.contains(CT1.Account__c))
                        childinLoad1.add(CT1.Account__c);
                    else
                    {
                        //Childs outside the load
                        
                        CT1.Status__c = Stat;
                        //CT1.Ready_for_Mod1__c = readysetup;
                       
                          
                        updateCusTranBack.add(CT1);
                    }
                }
                }
                
                if(lGChildCust != null){  
                for(Customer_Transition__c CT1:lGChildCust)
                {
                    // Processing All Grand childs
                    
                    //Childs in the current Trigger.new load
                    if(setaccid.contains(CT1.Account__c))
                        childinLoad1.add(CT1.Account__c);
                    else
                    {
                        //Childs outside the load
                       
                        CT1.Status__c = Stat;
                        //CT1.Ready_for_Mod1__c = readysetup;
                        
                        updateCusTranBack.add(CT1);
                    }
                }
                }
            
                for(Customer_Transition__c newCT: Trigger.New)
                {
                    if(childinLoad1.contains(newCT.Account__c)) {
                        newCT.Status__c = Stat;
                        newCT.Ready_for_Mod1__c = readysetup;
                       
                        
                    }
                }
              }
            executeoncetest.updateonceCustrans1=false;
            if(updateCusTranBack.size()>0)
                update updateCusTranBack;
            
            //End.....
        }
        
        */
       system.debug('Account id-->'+setaccid); 
        
        
    }  // Trigger.IsUpdate
    
   }
}