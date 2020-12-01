trigger OpportunityOwner_Insert on Opportunity (Before insert, Before update) 
{
               // added for ticket 01474559
       if (Trigger.New != null) {
         for (Opportunity myOpp: Trigger.new) {
          if (Util.bizBoxRTIdsByObject('Opportunity').contains(myOpp.RecordTypeId)) {
           return;
          }
         }
        }

    Boolean IsTech = false;
        for(opportunity op:Trigger.New){
            if((op.product__c == 'tech')  && (op.LeadSource != 'GMILLquote') && (op.LeadSource != 'BSDNETquote')){
                IsTech = true;
                break;
            }    
        }
    If(Trigger.IsInsert)
    {   
        Set<String> TitleSet= new Set<String>();
        Set<Id> AccountIdSet = new Set<Id>();
        map<Opportunity,Id> mapOppAccId = new map<Opportunity,Id>();
        //List<TechDepotSetting__c> tech = [Select Id,User_Title__c,Auto_Assign__c from TechDepotSetting__c where name ='Title & Auto Assign'];
        List<Admin_Config__c> tech = [Select Id,Tech_Depot_Title__c,Tech_Depot_Auto_Assign_Opp__c,Tech_Depot_User__c from Admin_Config__c where name ='Default'];
        if((tech.size() >0)){
            for(String s:tech[0].Tech_Depot_Title__c.split(',')){
                TitleSet.add(s);
            }
        }    
        for(Opportunity opp:Trigger.New)
        {
            if(opp.recordtypeId == Label.Opportunity_US_Record_Type) {
                if(tech.size() > 0 && opp.product__c == 'tech' )  //checking checkbox value n custom setting
                {
                   if(tech[0].Tech_Depot_Auto_Assign_Opp__c == true)
                   {
                           AccountIdSet.add(opp.AccountId);
                           mapOppAccId.put(opp,opp.AccountId); 
                   }    
                }
            }
        }
        System.Debug('mapOppAccId '+mapOppAccId);
        //List<TechDepotSetting__c> techAutoAssign = [Select Id,Auto_Assign__c from TechDepotSetting__c where name ='AutoAssign'];
        //List<User> OppOwner = [SELECT id FROM User where Name = 'Salesforce'];
        List<User> OppOwner = new List<User>();
        if(tech.size()>0)
        {
           OppOwner = [SELECT id FROM User where Name =: tech[0].Tech_Depot_User__c ];
        }
        List<AccountTeamMember> ATMLst=[Select UserId,AccountId from AccountTeamMember where AccountId IN: AccountIdSet];
        System.Debug('ATMLst '+ATMLst);
        Set<Id> ATM_Id=new Set<Id>();
        for(AccountTeamMember a:ATMLst)
        {
            ATM_Id.add(a.UserId);
        }
        System.Debug('ATM User Id'+ATM_Id);
        List<User> usrLst =  new List<User>();
        if(tech.size() > 0)  //checking checkbox value n custom setting
        {
            usrLst=[Select Id from user where short_title__c IN:TitleSet AND Id IN: ATM_Id];
        }
        System.Debug('usrLst '+usrLst);
        map<Id,Id> mapUsrIdAccId = new map<Id,Id>();
        map<Id,Id> mapAccIdUsrIdNu = new map<Id,Id>();
        for(AccountTeamMember at:ATMLst)
        {
            mapUsrIdAccId.put(at.UserId,at.AccountId);    
        }
        System.Debug('mapUsrIdAccId'+mapUsrIdAccId);
        for(User u: usrlst)
        {
             mapAccIdUsrIdNu.put(mapUsrIdAccId.get(u.Id),u.Id);
             break;
        }
        System.Debug('mapAccIdUsrIdNu'+mapAccIdUsrIdNu);
                
        for(Opportunity Opps: Trigger.New)
        {
            if(Opps.recordtypeId == Label.Opportunity_US_Record_Type) {
                if(tech.size() > 0 && opps.product__c == 'tech')  //checking checkbox value n custom setting
                    {
                        if(tech[0].Tech_Depot_Auto_Assign_Opp__c)
                        {
                            Id AccId = mapOppAccId.get(opps);
                            System.Debug('t1'+AccId);
                            System.Debug('t1'+mapAccIdUsrIdNu.get(AccId));
                            if(String.ValueOf(mapAccIdUsrIdNu.get(AccId)) != null && String.ValueOf(mapAccIdUsrIdNu.get(AccId)) !='')
                            {                
                                Opps.ownerId =  mapAccIdUsrIdNu.get(AccId) ; 
                            }
                            else 
                            {
                                Opps.OwnerId = OppOwner[0].Id ;
                            }
                        }
                        if(!tech[0].Tech_Depot_Auto_Assign_Opp__c)
                        {
                            Opps.OwnerId = OppOwner[0].Id ;
                        }
                }
            }
        }
    }
    
    
 /**********Added for the case no. #00139816 ****************/
   if (Trigger.isUpdate  && trigger.isBefore) {
    list<opportunity> opppt= new list<opportunity>();
   
    for(Opportunity opp:Trigger.New)
    {
        // Get the old Snapshot of the record
        Opportunity oldOppty = Trigger.oldMap.get(opp.Id);
                  if ((oldOppty.status__c=='closed') && (oldOppty.stagename=='0%-Lost' || oldOppty.stagename=='0%-Walkaway' || oldOppty.stagename=='0%-Duplicate/Cancelled' || oldOppty.stagename=='100%-Won') && opp.stagename!= oldOppty.stagename) {

           opp.status__c='open'; 

         opppt.add(opp); }
    }
    //insert opppt;
    }
    /***************************End of the code added for case no 00139816********/
}