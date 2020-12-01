// This class is to Auto Launch the list of Records Loaded in the Transition Launch Object
Global class OpportunityHistoryPopulateWeekly implements database.Batchable<Sobject>,Database.Stateful,Schedulable
{
       global String strQuery; //this variable used to set query from test class or from shceduler if required
       public String DEFAULT_QUERY;

      
    /* Default Constructor*/
    global OpportunityHistoryPopulateWeekly( )
    {  
           DEFAULT_QUERY ='Select Id,accountId,Previous_Summary_Stage__c, CloseDate,Stage_Age__c, Watson_Door_Opener__c,Summary_Stage__c,amount, PLOC_Opportunity_Stage__c,stagename,product__C,Product_Subtype__c ,ownerId, Watson__c,Watson_Notes__C,isclosed'
                                   +' FROM Opportunity'
                                   +' WHERE    (Is_Opportunity_Owner_ILC__C= true  or  K12_Team__C=true ) '; 
    
    
          
        this.strQuery = DEFAULT_QUERY;


    }
    /* This method prepares the scope of the batch program based on the query result */
    global Database.QueryLocator start(Database.BatchableContext BC)
    {
        system.debug('strQuery@@@'+strQuery);
        return Database.getQueryLocator(strQuery);
    }
     /* This method processes query result in batches */
    global void execute(Database.BatchableContext BC, SObject[] scope)
    {
        List<Opportunity> newLst  = scope;
        List<Opportunity_Tracking_History__c> historyRecordsToInsert = new List<Opportunity_Tracking_History__c>();
        List<Opportunity_Tracking_History__c> deleteList = new List<Opportunity_Tracking_History__c>();


        
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
      
      
        Set<Id> ilcSet = new  Set<Id> ();
        Set<Id> teamSet = new Set<Id>();
        Map< Id, String > MemberList= new Map< Id, String >();
        Set<Id> OppidSet = new Set<Id>();
        
        for(opportunity ids :newLst)
        {
            oppidset.add(ids.id);
            
        }
        
        
        
    //to store ILC users
        List< Instructional_Lead_Consultant__c> iLCList= [SELECT Id, User__c FROM Instructional_Lead_Consultant__c];
        for(Instructional_Lead_Consultant__c i: iLCList ){
         ilcSet.add (i.User__C); // store User of ILC object
        }

    //list to store team members related to this opportunity
    List<OpportunityTeamMember> teamMembers = [SELECT Id, OpportunityId,userId FROM OpportunityTeamMember
     WHERE OpportunityId IN: oppidset
     // and TeamMemberRole='Team Member'
     and UserId  in :ilcSet];
     
     System.debug('&&&&&&&&&&&&&&&&'+  teamMembers.size());
     system.debug('oppidset'+oppidset);
     system.debug('ilcSet'+ilcSet);
    for( OpportunityTeamMember rec: teamMembers ){    
         if( !(teamSet.contains(rec.OpportunityId )))
         teamSet.add (rec.OpportunityId);
         
     
          System.debug('&&&&&&&&&&&&&&&&Inside here'+  teamSet.size());
          String userList='';
          
         
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
 
          System.debug('&&&&&&&&&&&&&&&&MemberList'+  MemberList);
           Date tod=system.today();

        // delete the data already present for that fiscal week
        deleteList=[select Id from Opportunity_Tracking_History__c where   
           ( Pipeline_Week__c=:currWeek and type__c='Weekly' and createddate < :tod  
           /// and Opportunity__C in :oppidset 
           ) 
            ];
        if(deleteList.size()>0)
            system.debug('deleteList'+deleteList);
            delete deleteList;
        
        
            for( Opportunity OppRec :newLst  ){


            // Monthly Data Maintaining
            Opportunity_Tracking_History__c newRec = new Opportunity_Tracking_History__c();
            newRec.Opportunity__c  = OppRec.Id;
            newRec.Pipeline_Week__c=currWeek ;
            newRec.Amount__c= OppRec.Amount;
            newRec.PLOC_stage__c=OppRec.PLOC_Opportunity_Stage__c;
            newRec.PLOC_Old_Value__c=OppRec.PLOC_Opportunity_Stage__c;
            newRec.Stage_Old_Value__c=OppRec.stageName;

            newRec.stage__C=OppRec.stageName;
            newRec.Opportunity_Owner__c=OppRec.ownerId;
            newRec.Is_Watson__c=OppRec.Watson__c;
            newRec.Product__c=OppRec.Product__c ;
            newRec.Product_Sub_Type__c=oppRec.Product_Subtype__c ;
            newRec.Watson_Notes__C =OppRec.Watson_Notes__C;
            newRec.IsClosed__C=  OppRec.isclosed;
            newRec.Fiscal_Month__c=currMonth;
            newRec.type__c='Weekly';
            newRec.fiscal_year__C=currYear;
            newRec.Summary_Stage__c=OppRec.Summary_Stage__c;
            newRec.Opportunity_Team_Member__c=MemberList.get(OppRec.Id);
            newRec.Close_Date__c= OppRec.CloseDate;
            newRec.Watson_Door_Opener__c= OppRec.Watson_Door_Opener__c;
            newRec.Stage_Age__c=OppRec.Stage_Age__c;
            newRec.Account__c= OppRec.AccountId;
            newRec.Previous_Summary_Stage__c = OppRec.Previous_Summary_Stage__c;


            // check if its ILC ore ILC team
            if( ilcSet.contains(OppRec.ownerId))
            newRec.Is_ILC_Owned__c=true;
            //else{
               if( teamSet.contains(OppRec.Id))
               newRec.Is_ILC_Team_Owned__c=true;
            //}

            
            historyRecordsToInsert.add(newRec);

        }

    //insert opp history tracking records 
    if(!historyRecordsToInsert.isEmpty()){
        system.debug('historyRecordsToInsert'+historyRecordsToInsert);
      insert historyRecordsToInsert;
    }      
                                                                                 
     }
   
   
      /* This method is to execute to relase some resources if any*/
    global void finish(Database.BatchableContext BC)
    {   
    }     
        
    global void execute(SchedulableContext sc)
    {
        String strQuery = '';
        OpportunityHistoryPopulateWeekly PopulateOppHistoryWeekly= new OpportunityHistoryPopulateWeekly ( );
        database.executebatch(PopulateOppHistoryWeekly, 9000);
        
    } 
          
}