/******************************************************************************
Name            :  OpportunityTriggerHandler
Created by      :  Hemant 11/5/2015
Story #         :  S-359752 [OD case # 00541429]
Description     :  To handle all trigger events of Opportunity object,see OpportunityOwner_Insert_TC for coverage
Modifications   : 

  Nick Sharp    S-404782    4.20.2016     Added checkForChangedValues method 
******************************************************************************/
public class OpportunityTriggerHandler {
  
  /****************************************************************************
    Method : Call on Before Insert on Opportunity 
  ****************************************************************************/
  public static void onBeforeInsert(List<Opportunity> newOppLst) {
    populateOppFields(newOppLst, null);
  }
  
  /****************************************************************************
  Method : Call on Before Update on Opportunity 
  ****************************************************************************/
  public static void onBeforeUpdate(List<Opportunity> newOppLst, Map<Id, Opportunity> oppOldmap) {
    populateOppFields(newOppLst, oppOldmap);
  }
  
  //method to populate the Opp fields
  private static void populateOppFields(List<Opportunity> oppLst, Map<Id, Opportunity> oppOldmap){
    
    String newExchangeRate;
    if(!Test.isRunningTest()){
        newExchangeRate=[Select Rate__c from Exchange_Rate__c Limit 1].Rate__c ;
    }
    if(Test.isRunningTest()){
        newExchangeRate = '1.08';
    }
    for(Opportunity opptToUpdate: oppLst){
      
      if(opptToUpdate.recordtypeid==Label.GTOpportunity){
        if(opptToUpdate.Committed_Forecast_CAD__c != null || opptToUpdate.Amount_CAD__c != null) {
        if(opptToUpdate.Amount_CAD__c != null)
        opptToUpdate.Amount = Double.valueof(opptToUpdate.Amount_CAD__c) / Double.valueof(newExchangeRate);
        if(opptToUpdate.Committed_Forecast_CAD__c!= null)
        opptToUpdate.Committed_Forecast__c = Double.valueof(opptToUpdate.Committed_Forecast_CAD__c) / Double.valueof(newExchangeRate); 
        }
      }//end outer if
      
      /**********Added for the case no. #00139816 ****************/
      // Get the old Snapshot of the record
      if(oppOldmap != null){ //run only for befor update event
        
        Opportunity oldOppty = oppOldmap.get(opptToUpdate.Id);
        if ((oldOppty.status__c == Constants.STATUS_CLOSED) 
            && (oldOppty.stagename == Constants.STAGENAME_0_PERCENT_LOST || oldOppty.stagename == Constants.STAGENAME_0_PERCENT_WALKAWAY 
                || oldOppty.stagename == Constants.STAGENAME_0_PERCENT_DUPLICATE_CANCELLED || oldOppty.stagename == Constants.STAGENAME_100_PERCENT_WON) 
            && opptToUpdate.stagename!= oldOppty.stagename) {
          
          opptToUpdate.status__c = Constants.STATUS_OPEN;
        }
      } 
      /***************************End of the code added for case no 00139816********/
          
    }//end for
  }

  public void processOpportunityHistory(List<Opportunity> OpptyList, Map<Id,Opportunity> oldMap ){
   
  List<Opportunity> newLst= new List<Opportunity> ();
    List<Id> DeleteId= new List<Id> ();
 
        for ( Opportunity opp: OpptyList){  
        // Delete the records from Weekly data of this week if the record no longer matches the criteria for ILC      
           if(Trigger.isUpdate   &&  ( (opp.K12_Team__C!= oldMap.get(Opp.id).K12_Team__C)  || (opp.ownerId!= oldMap.get(opp.id).ownerId  ) &&
           opp.Is_Opportunity_Owner_ILC__C== false  &&  opp.K12_Team__C==false)
            )
           {
                                DeleteId.add(opp.Id);           
           }
         // If the record is owned by ILC or teamed by ILC it gets inserted to History Table
                 // checking if the record is K-12 teamed
          if( opp.Is_Opportunity_Owner_ILC__C== true  ||  opp.K12_Team__C==true ){
                    if(trigger.isInsert){
                    newLst.add(opp);
                    }
                    else{
                    // if stage changes for Non watson or ploc stage changes for watson or owner changes
                        if  ( ( opp.Watson__c==true &&  ( opp.PLOC_Opportunity_Stage__c!= oldMap.get(opp.id).PLOC_Opportunity_Stage__c))  ||
                            ( opp.Watson__c==false&&  ( opp.StageName!= oldMap.get(opp.id).StageName))   ||
                              opp.ownerId!= oldMap.get(opp.id).ownerId    
                              /////////|| (opp.K12_Team__C==true)
                           ||  (   opp.K12_Team__C!= oldMap.get(Opp.id).K12_Team__C )
                                                         
                              ){                         
                        newLst.add(opp);
                        }
                    }
               
               }
        }
 
// variable declarations
    List<Opportunity_Tracking_History__c> historyRecordsToInsert = new List<Opportunity_Tracking_History__c>();
    List<Opportunity_Tracking_History__c> deleteList = new List<Opportunity_Tracking_History__c>();
    Set<Id> ilcSet = new  Set<Id> ();
    Set<Id> teamSet = new Set<Id>();
        Map< Id, String > MemberList= new Map< Id, String >();
        Set<Id> OppidSet = new Set<Id>();
     // Looping over the Changed Records        
        for(opportunity ids :newLst)
        {
            oppidset.add(ids.id);
            
        }

    //determine the fiscal week (must be fiscal year for current year existing in org)
    //FiscalYearSettings fiscalYear = [SELECT Id FROM FiscalYearSettings WHERE name =: String.valueOf(System.Today().Year()) LIMIT 1];
    Period per = [SELECT Id, Number  FROM Period WHERE 
    //FiscalYearSettingsId =: fiscalYear.Id AND 
    Type = 'Week' AND StartDate <=: System.Today() AND EndDate >=: System.Today() LIMIT 1];
    
     String currWeek= System.Today().Year()+'-W'+per.Number;    
     Period perMonth = [SELECT Id, Number,FiscalYearSettings.name FROM Period WHERE 
     //FiscalYearSettingsId =: fiscalYear.Id  AND 
    Type = 'Month' AND StartDate <=: System.Today() AND EndDate >=: System.Today() LIMIT 1];

      String currMonth =string.valueof(perMonth.Number);
      String currYear=string.valueof(perMonth.FiscalYearSettings.name);

    //to store ILC users
        List< Instructional_Lead_Consultant__c> iLCList= [SELECT Id, User__c FROM Instructional_Lead_Consultant__c];
        for(Instructional_Lead_Consultant__c i: iLCList ){
         ilcSet.add (i.User__C);
        }

    //list to store team members related to this opportunity
    List<OpportunityTeamMember> teamMembers = [SELECT Id, OpportunityId,userId FROM OpportunityTeamMember
     WHERE OpportunityId IN: oppidset  and UserId  in :ilcSet];
     
     System.debug('&&&&&&&&&&&&&&&&teamMembers '+teamMembers );
    for( OpportunityTeamMember rec: teamMembers ){    
     if( !(teamSet .contains(rec.OpportunityId )))
     teamSet.add (rec.OpportunityId);
     
               String userList='';
          
         // finding the team members
                  if (MemberList.containsKey(rec.OpportunityId)){
                     string currUser=MemberList.get(rec.OpportunityId);                    
                     userList=currUser+ rec.userId+',';
                     MemberList.remove(rec.OpportunityId);
                     MemberList.put(rec.OpportunityId,userList);
                  }
                  else{       
                  String recData=  rec.userId+',';        
                  MemberList.put(rec.OpportunityId,recData);
                  }

    }
    
         System.debug('&&&&&&&&&&&&&&&&MemberList'+MemberList);

    // delete the data already present for that fiscal week
        deleteList=[select Id from Opportunity_Tracking_History__c where  Pipeline_Week__c=:currWeek and type__c='Weekly' and 
        (Opportunity__c  in:newLst   or  Opportunity__c  in : DeleteId)        
        and fiscal_year__c=:curryear];
        if(deleteList.size()>0)
        delete deleteList;
               
   for ( Opportunity OppRec: OpptyList){
                 // checking if the record is K-12
               if( (OppRec.Is_Opportunity_Owner_ILC__C== true  ||  OppRec.K12_Team__C==true )
                 &&
                   (trigger.isInsert  ||
                          ( TRigger.IsUpdate && 
                          ( OppRec.Watson__c==true &&  ( OppRec.PLOC_Opportunity_Stage__c!= oldMap.get(OppRec.id).PLOC_Opportunity_Stage__c))  ||
                            ( OppRec.Watson__c==false&&  ( OppRec.StageName!= oldMap.get(OppRec.id).StageName))   ||
                              (OppRec.ownerId!= oldMap.get(OppRec.id).ownerId)    
                              ////|| (OppRec.K12_Team__C==true) 
                           || (   OppRec.K12_Team__C!= oldMap.get(OppRec.id).K12_Team__C )
                               )
                              )
                               )
                               
                               {                                                              
                          // for Watson stage changes We insert into the Opportunity history table with Type  "Watson Stage change"
            if (OppRec.Watson__c == true) {
                if (Trigger.isInsert ||                 
                 (Trigger.IsUpdate && 
                //( (OppRec.PLOC_Opportunity_Stage__c != oldMap.get(OppRec.id).PLOC_Opportunity_Stage__c) 
                                ( (OppRec.Summary_Stage__c != oldMap.get(OppRec.id).Summary_Stage__c) 
                     || (oldMap.get(OppRec.id).K12_Team__C== false && oldMap.get(OppRec.id).Is_Opportunity_Owner_ILC__C==false)
                 
                             //  || (   (OppRec.K12_Team__C!= oldMap.get(OppRec.id).K12_Team__C)  && OppRec.K12_Team__C==true )
                              //                 ||
                             // (OppRec.ownerId!= oldMap.get(OppRec.id).ownerId)                  
                ) ) ){
                
                ///System.debug('&&&old stage'+oldMap.get(OppRec.id).Summary_Stage__c);
               /// System.debug('&&&new stage'+OppRec.Summary_Stage__c);

                
                
                                Opportunity_Tracking_History__c newRec1 = new Opportunity_Tracking_History__c();
                                newRec1 .Opportunity__c = OppRec.Id;
                                newRec1.Pipeline_Week__c = currWeek ;
                                newRec1.Amount__c = OppRec.Amount;
                                newRec1.PLOC_stage__c = OppRec.PLOC_Opportunity_Stage__c;
                                newRec1.stage__C = OppRec.stageName;
                    
                                if (Trigger.IsUpdate && (OppRec.PLOC_Opportunity_Stage__c != oldMap.get(OppRec.id).PLOC_Opportunity_Stage__c)) {
                                    newRec1.PLOC_Old_Value__c=oldMap.get(OppRec.id).PLOC_Opportunity_Stage__c;
                                }
                                else {
                                    newRec1.PLOC_Old_Value__c = OppRec.PLOC_Opportunity_Stage__c;
                                }       
                                                               
                                            newRec1.Opportunity_Owner__c = OppRec.ownerId;
                                            newRec1.Is_Watson__c = OppRec.Watson__c;
                                            newRec1.Product__c = OppRec.Product__c ;
                                            newRec1.Product_Sub_Type__c = oppRec.Product_Subtype__c ;
                                            newRec1.Watson_Notes__C = OppRec.Watson_Notes__C;
                                            newRec1.IsClosed__C = OppRec.isclosed;
                                            newRec1.Fiscal_Month__c = currMonth;
                                            newRec1.Type__c = 'WatsonStageChange';
                                            newRec1.fiscal_year__C = currYear;
                                            newRec1.Summary_Stage__c = OppRec.Summary_Stage__c;                       
                                            newRec1.Opportunity_Team_Member__c = MemberList.get(OppRec.Id);
                                            newRec1.Close_Date__c = OppRec.CloseDate;
                                            newRec1.Watson_Door_Opener__c = OppRec.Watson_Door_Opener__c;
                                            newRec1.Stage_Age__c = OppRec.Stage_Age__c;
                                            newRec1.Account__c = OppRec.AccountId;
                                            newRec1.Previous_Summary_Stage__c = OppRec.Previous_Summary_Stage__c;
                                            newRec1.LaterChange__C=true;
                                                        // check if its ILC ore ILC team
                                            if (ilcSet.contains(OppRec.ownerId)) {
                                                newRec1.Is_ILC_Owned__c = true;
                                            }
                                               if (teamSet.contains(OppRec.Id)) {
                                                   newRec1.Is_ILC_Team_Owned__c = true;
                                               }
                                            
                                            
                                                historyRecordsToInsert.add(newRec1);
                                
                                     

                }   
           }
                                                                                                                                          
            Opportunity_Tracking_History__c newRec = new Opportunity_Tracking_History__c();
            newRec .Opportunity__c = OppRec.Id;
            newRec.Pipeline_Week__c = currWeek ;
            newRec.Amount__c = OppRec.Amount;
            newRec.PLOC_stage__c = OppRec.PLOC_Opportunity_Stage__c;
            newRec.stage__C = OppRec.stageName;
            
            // for Watson stage changes
            if (OppRec.Watson__c == true) {
                if (Trigger.IsUpdate && (OppRec.PLOC_Opportunity_Stage__c != oldMap.get(OppRec.id).PLOC_Opportunity_Stage__c)) {
                    newRec.PLOC_Old_Value__c=oldMap.get(OppRec.id).PLOC_Opportunity_Stage__c;
                }
                else {
                    newRec.PLOC_Old_Value__c = OppRec.PLOC_Opportunity_Stage__c;
                }            
            } 
            else {            
                if (Trigger.IsUpdate && (OppRec.stagename!= oldMap.get(OppRec.id).stagename)) {
                    newRec.Stage_Old_Value__c = oldMap.get(OppRec.id).stagename;
                }
                else {
                    newRec.Stage_Old_Value__c = OppRec.stageName;
                }                          
            }            
            
            newRec.Opportunity_Owner__c = OppRec.ownerId;
            newRec.Is_Watson__c = OppRec.Watson__c;
            newrec.Product__c = OppRec.Product__c ;
            newRec.Product_Sub_Type__c = oppRec.Product_Subtype__c ;
            newREc.Watson_Notes__C = OppRec.Watson_Notes__C;
            newREc.IsClosed__C = OppRec.isclosed;
            newRec.Fiscal_Month__c = currMonth;
            newRec.Type__c = 'Weekly';
            newRec.fiscal_year__C = currYear;
            newRec.Summary_Stage__c = OppRec.Summary_Stage__c;                       
            newRec.Opportunity_Team_Member__c = MemberList.get(OppRec.Id);
            System.debug('&&&&&&&&&&&&&&&Member'+ MemberList.get(OppRec.Id));
            newRec.Close_Date__c = OppRec.CloseDate;
            newRec.Watson_Door_Opener__c = OppRec.Watson_Door_Opener__c;
            newRec.Stage_Age__c = OppRec.Stage_Age__c;
            newRec.Account__c = OppRec.AccountId;
            newRec.Previous_Summary_Stage__c = OppRec.Previous_Summary_Stage__c;

            // check if its ILC ore ILC team
            if (ilcSet.contains(OppRec.ownerId)) {
                newRec.Is_ILC_Owned__c = true;
            }
           // else {
               if (teamSet.contains(OppRec.Id)) {
                   newRec.Is_ILC_Team_Owned__c = true;
               }
            //}
            
                historyRecordsToInsert.add(newRec);
            }
        } // end of for loop

        // Insert opp history tracking records 
        if (!historyRecordsToInsert.isEmpty()) {
            insert historyRecordsToInsert;
        }
    }
    
    public static void onBeforeUpsert(List<Opportunity> oppList) {
        System.debug('OpportunityTriggerHandler > onBeforeUpsert()');
        System.debug('OpportunityTriggerHandler > oppList.size() = ' + oppList.size());
        
        // Assign Account Extension
        List<Id> acctIds = new List<Id>();

        for (Opportunity opp : oppList) {
            Id acctId = opp.AccountId;
            
            if (acctId != null) {
                System.debug('OpportunityTriggerHandler > acctId = ' + acctId);
                acctIds.add(acctId);
            }
        }
        
        System.debug('OpportunityTriggerHandler > acctIds.size() = ' + acctIds.size());
        Map<Id, Id> accountIdToExtensionId = (new AccountExtensionHelper()).getAccountExtensionIds(acctIds); 
        System.debug('OpportunityTriggerHandler > accountIdToExtensionId.size() = ' + accountIdToExtensionId.size());
        
        for (Opportunity opp : oppList) {
            Id acctId = opp.AccountId;
            opp.Account_Extension_Name__c = accountIdToExtensionId.get(acctId);
        }
    }
}