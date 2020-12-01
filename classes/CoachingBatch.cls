// Case 00995018
//03/21/2017
// This Batch Class capture whether or not a rep is meeting attainment goals in SFDC on the 'Coaching' object
global class CoachingBatch implements Database.Batchable<sObject> , Schedulable {
    
    final String DEFAULT_QUERY = 'SELECT Id, Name, Sales_Rep__c, Attainment_of_Pursue_Target__c, Attainment_of_Propose_Target__c, Target_Verbal_Wins__c, Yearly_Goal__c, Pursuit_Presentation_Monthly_Target__c, Proposal_Presentation_Monthly_Target__c, Qualify_Monthly_Target__c, Attainment_of_Sales_Advancing_Event_Targ__c, Sales_Advancing_Event_Target__c, Attainment_of_Contacts_Expansion_Target__c, Contacts_Expansion_Target__c, Attainment_of_Positive_Prism_Plays_Targe__c, Positive_Prism_Plays_Target__c, Attainment_of_Retention_Cadence_Task_Tar__c, Retention_Cadence_Task_Target__c from Coaching__c';
    
    
    global Database.QueryLocator start(Database.BatchableContext bc) {
        return Database.getQueryLocator(DEFAULT_QUERY);
    }
    
    
    global void execute(Database.BatchableContext bc, List<Coaching__c> scope) {

            Map<Id,Coaching__c> useridMap = new Map<Id,Coaching__c>();
            Map<String,Decimal> ownerstageMap = new Map<String,Decimal>();
            
            // Adding users (Sales Person) from Coaching to the user_id Set
            For (Coaching__c c: scope) {
                useridMap.put(c.Sales_Rep__c,c);
                c.Attainment_of_Verbal_Win_Target__c = 0;
                c.Attainment_of_Propose_Target__c = 0;
                c.Attainment_of_Pursue_Target__c = 0;
            }
            
            // AggregateResult List to get the TotalAmount and OwnerId From Opportunity 
            List<AggregateResult> groupedResults = [SELECT OwnerId, StageName,SUM(Opportunity_Amount__c) TotalAmount
                                  FROM Opportunity
                                  WHERE StageName IN ('Pursue','Propose','Verbal Win')
                                  AND OwnerId IN :useridMap.keySet()
                                 // AND Coaching__c != Null
                                  //Case - 01071590
                                  AND closedate>= 2017-01-01 and closedate <= 2018-12-31
                                  //AND CreatedDate = LAST_N_DAYS:30
                                  //AND OwnerId = '005E0000000nAnR'
                                  GROUP BY OwnerId,StageName];
            
            For (AggregateResult pm: groupedResults)   {
                //Setting up the key and value for ownerstageMap where the key will be opportunity OwnerId+StageName & value will be TotalAmount of the opportunities related the same user 
                ownerstageMap.put((String)pm.get('OwnerId')+(String)pm.get('StageName'),(Decimal)pm.get('TotalAmount'));
            }               
            
            
            For (AggregateResult pl: groupedResults) {
                String ownerId = (String)pl.get('OwnerId');
                String oppStage = (String)pl.get('StageName');
                if (useridMap.containsKey(ownerId)) {
                   Coaching__c c = useridMap.get(ownerId);  
                   //Check Pursue
                   if (ownerstageMap.containsKey(ownerId+'Pursue')) {
                       purSueCalc(c,ownerstageMap.get(ownerId+'Pursue'));
                   }
                   
                   // Check Propose
                   if (ownerstageMap.containsKey(ownerId+'Propose')) {
                       proposeCalc(c,ownerstageMap.get(ownerId+'Propose'));
                   }
                   
                   // Check Verbal Win
                   if (ownerstageMap.containsKey(ownerId+'Verbal Win')) {
                       verbalwinCalc(c,ownerstageMap.get(ownerId+'Verbal Win'));
                   }
                }
            } 
        
            // Mapping Owners to Sum                      
            /*Map<Id, Decimal> ownerTosum = new Map<Id, Decimal>();
            
            For (AggregateResult gr: groupedResults) {
                // Adding the OwnerId and TotalAmount to the Map Key and Value
                ownerTosum.put((Id)gr.get('OwnerId'), (decimal)gr.get('TotalAmount'));
            }*/
            
           
           //Event List Change case#01068308 -- IVARADA Begins
            
            list<ID> wIDs = new list<ID>();                      
            for (AggregateResult a:[SELECT whatId
                                   FROM Event
                                   WHERE OwnerId IN :useridMap.keySet()
                                   AND CreatedDate = LAST_N_DAYS:30
                                   GROUP BY whatId]) {
             wIDs.add((ID)a.get('whatId'));                                                    
           }
            Map<ID,String> OIDpursue = new Map<ID,String>();
            Map<ID,String> OIDpropose = new Map<ID,String>();             
            for (Opportunity o: [select id,stageName from Opportunity where StageName IN ('Pursue','Propose') and ID = :wIDs]) {
              if (o.stageName == 'Pursue')
                OIDpursue.put(o.id,o.stageName);
              if (o.stageName == 'Propose')
                OIDpropose.put(o.id,o.stageName);
            }



             // AggregateResult List to get the EventOppCount and WhatId From Event                 
             List<AggregateResult> EventResultsPursue = [SELECT Count(Id) EventOppCount, OwnerId
                                   FROM Event
                                   WHERE WhatId IN :OIDpursue.keySet()
                                   AND OwnerId IN :useridMap.keySet()
                                   AND CreatedDate = LAST_N_DAYS:30
                                   GROUP BY OwnerId];
              List<AggregateResult> EventResultsPropose = [SELECT Count(Id) EventOppCount, OwnerId
                                   FROM Event
                                   WHERE WhatId IN :OIDpropose.keySet()
                                   AND OwnerId IN :useridMap.keySet()
                                   AND CreatedDate = LAST_N_DAYS:30
                                   GROUP BY OwnerId];
                                   
             Map<ID,Decimal> AttainPursue = new Map<ID,Decimal>();
             Map<ID,Decimal> AttainPropose = new Map<ID,Decimal>();
             
             For (AggregateResult er: EventResultsPursue) {
                 AttainPursue.put((ID)er.get('OwnerId'),(Decimal)er.get('EventOppCount')); 
             }
            For (AggregateResult er: EventResultsPropose) {
                 AttainPropose.put((ID)er.get('OwnerId'),(Decimal)er.get('EventOppCount'));  
             }
             
             For (Coaching__c c1: scope) {
                 
                 Id coachingOwner= c1.Sales_Rep__c;
                 //Id coachingWhatId = c1.Id;
                 Decimal totalEventcountPursue = AttainPursue.get(coachingOwner);
                 Decimal totalEventcountPropose = AttainPropose.get(coachingOwner);
                // Decimal totalEventcountQualify = ownerEventMap.get('Qualify'+coachingOwner);
                 if (totalEventcountPursue >= c1.Pursuit_Presentation_Monthly_Target__c) {
                     c1.Attainment_of_Pursue_Event_Target__c = 1;
                 }
                 else {
                     c1.Attainment_of_Pursue_Event_Target__c = 0;
                 }
                 
                 if (totalEventcountPropose >= c1.Proposal_Presentation_Monthly_Target__c) {
                     c1.Attainment_of_Propose_Event_Target__c = 1;
                 }
                 else {
                     c1.Attainment_of_Propose_Event_Target__c = 0;
                 }
                 
                 /*if (totalEventcountQualify >= c1.Qualify_Monthly_Target__c) {
                     c1.Attainment_of_Qualify_Event_Target__c = 1;
                 }
                 else {
                     c1.Attainment_of_Qualify_Event_Target__c = 0;
                 }*/
             }
             
           //Event List Change case#01068308 -- IVARADA Ends
             
          //Event List Change case#01068308 -- IVARADA Begins
             
            // oppIdStages List include ID's for all Opportunities with StageName Not In ('Pursue','Propose') 
            List<ID> OIDs = new List<ID>();
            for (Opportunity o: [SELECT Id FROM Opportunity WHERE StageName NOT IN ('Pursue','Propose') AND ID=:WIDs]) {
                  OIDs.add(o.id);            
            }

            
            // AggregateResult List to get the EventCount and WhatId From Event with Opp where StageName Not In ('Pursue','Propose')             
             List<AggregateResult> EventResultsNPP = [SELECT Count(Id) EventOppCount, OwnerId
                                   FROM Event
                                   WHERE WhatId IN :OIDpursue.keySet()
                                   AND OwnerId IN :useridMap.keySet()
                                   AND CreatedDate = LAST_N_DAYS:30
                                   GROUP BY OwnerId];
                                   
            
            Map<ID,Decimal> AttainEventNPP = new Map<ID,Decimal>();
            For (AggregateResult er: EventResultsNPP) {
              AttainEventNPP.put((ID)er.get('OwnerId'),(Decimal)er.get('EventOppCount')); 
            }
            
            
            // AggregateResult List to get the TaskCount and WhatId From Task with Opp where StageName Not In ('Pursue','Propose') 
            List<AggregateResult> TaskResultsNPP = [SELECT Count(Id) TaskCountStages, OwnerId
                                   FROM Task
                                   WHERE WhatId IN :OIDpursue.keySet()
                                   AND OwnerId IN :useridMap.keySet()
                                   AND CreatedDate = LAST_N_DAYS:30
                                   GROUP BY OwnerId];
                                 
            Map<ID,Decimal> AttainTaskNPP = new Map<ID,Decimal>();
            For (AggregateResult er: TaskResultsNPP) {
                 AttainTaskNPP.put((ID)er.get('OwnerId'),(Decimal)er.get('TaskCountStages'));  
            }
            
            
            
            For (Coaching__c c6: scope) {
                
                c6.Attainment_of_Qualify_Event_Target__c = 0;
                Id coachingOwner = c6.Sales_Rep__c;
                Decimal totalEventcountStages = 0;
                Decimal totalTaskcountStages = 0;
                
                if (AttainEventNPP.containskey(coachingOwner))
                 totalEventcountStages = AttainEventNPP.get(coachingOwner);
                if (AttainTaskNPP.containskey(coachingOwner))
                 totalTaskcountStages = AttainTaskNPP.get(coachingOwner);
                 
                Decimal TotalEventTask = totalEventcountStages + totalTaskcountStages ; 
                
                if (c6.Qualify_Monthly_Target__c != null) {
                  if (TotalEventTask >= c6.Qualify_Monthly_Target__c) {
                     c6.Attainment_of_Qualify_Event_Target__c = 1;
                   }
                }
            }
            
             //Event List Change case#01068308 -- IVARADA Ends
            
             // AggregateResult List to get the EventCount and WhatId From Event                 
             List<AggregateResult> EventTotalCount = [SELECT Count(Id) EventCount, OwnerId
                                   FROM Event
                                   //WHERE WhatId IN :scope
                                   WHERE OwnerId IN :useridMap.keySet()
                                   AND RecordType.DeveloperName = 'Sales_Advancing_Event' //RecordType Id for 'Sales Advancing Events' on Event Production recordtype '01244000000VkyP'
                                   AND Call_Disposition__c IN ('Advancing Opportunity', 'Business Review', 'Contract Lifecycle', 'Facility Tour', 'Key Executive','Other') //Disposition picklist 
                                   AND CreatedDate = LAST_N_DAYS:30
                                   GROUP BY OwnerId];
                                   
             
            // Mapping Owners to EventCount                      
            Map<Id, Decimal> whatIdToeventCount = new Map<Id, Decimal>();
            
            For (AggregateResult ec: EventTotalCount) {
                // Adding the OwnerId and TotalAmount to the Map Key and Value
                whatIdToeventCount.put((Id)ec.get('OwnerId'), (Decimal)ec.get('EventCount'));
            }
                                   
             For (Coaching__c c2: scope) {
                 
                 Decimal CountofEvent = whatIdToeventCount.get(c2.Sales_Rep__c);
                 Decimal SalesAdvTgt = c2.Sales_Advancing_Event_Target__c; //Sales_Advancing_Event_Target__c
                 // Checking if Sales Advancing Event Target is not null otherwise field won't updated
                 if (SalesAdvTgt != null) {
                     if (CountofEvent >= SalesAdvTgt) {
                         c2.Attainment_of_Sales_Advancing_Event_Targ__c = 1;
                     }
                     else {
                         c2.Attainment_of_Sales_Advancing_Event_Targ__c = 0;
                     }
                 }
             }
             
             
             List<AggregateResult> ContactTotalCount = [SELECT Count(Id) ContactCount, CreatedById
                                   FROM Contact
                                   WHERE CreatedById IN :useridMap.keySet()
                                   //AND CreatedById != '005E0000000R7xz' DataLoaderUser
                                   AND CreatedDate = LAST_N_DAYS:30
                                   GROUP BY CreatedById];
                                   
             Map<Id, Decimal> ownerTocontactCount = new Map<Id, Decimal>();
             
             For (AggregateResult cc: ContactTotalCount) {
                 // Adding the CreatedById and Contact to the Map Key and Value
                 ownerTocontactCount.put((Id)cc.get('CreatedById'), (Decimal)cc.get('ContactCount'));
             }
             
             For (Coaching__c c3: scope) {
                 
                 Decimal CountofContact = ownerTocontactCount.get(c3.Sales_Rep__c);
                 Decimal ContExpTgt = c3.Contacts_Expansion_Target__c;
                 
                 if (ContExpTgt != null) {
                     
                     if (CountofContact >= ContExpTgt) {
                         c3.Attainment_of_Contacts_Expansion_Target__c = 1;
                     }
                     else {
                         c3.Attainment_of_Contacts_Expansion_Target__c = 0;
                     }
                 }
             } 
             
             System.Debug ('+++++++++++++++++++++++++++'+scope);
             List<AggregateResult> TaskTotalCount = [SELECT Count(Id) TaskCount, OwnerId
                                   FROM Task
                                   WHERE OwnerId IN :useridMap.keySet()
                                   AND RecordType.DeveloperName = 'Retention_Cadence_Task' // RecordType Id for 'Retention Cadence Task' on Task Production Recordtype'01244000000VkyU'
                                   AND Disposition_Code__c NOT IN ('salesPRISM - Unqualified' , 'salesPRISM - Not Interested')
                                   // AND Task_Type__c = 'SalesPRISM Play'
                                   AND (Task_Type__c LIKE 'Sales%')
                                   GROUP BY OwnerId];
                                   
             Map<Id, Decimal> whatIdTotaskCount = new Map<Id, Decimal>();

             For (AggregateResult tc: TaskTotalCount) {
                 // Adding the WhatId and TaskCount to the Map Key and Value
                 whatIdTotaskCount.put((Id)tc.get('OwnerId'), (decimal)tc.get('TaskCount'));
             }
             
             For (Coaching__c c4: scope) {
                 
                 Decimal CountofTask = whatIdTotaskCount.get(c4.Sales_Rep__c);
                 Decimal PosPrismPlays = c4.Positive_Prism_Plays_Target__c;
                 
                 if (PosPrismPlays != null) {
                    
                    if (CountofTask >= PosPrismPlays) {
                        c4.Attainment_of_Positive_Prism_Plays_Targe__c = 1;
                    }
                    else {
                        c4.Attainment_of_Positive_Prism_Plays_Targe__c = 0;
                    }
                 }
             }
             
             
             // AggregateResult List to get the Task Count and WhatId From Tasks with Recordtype is 'Retention Cadence Task' and Call Disposition not Null 
             List<AggregateResult> TaskCountAllDisposition = [SELECT Count(Id) TaskCountDisposition, OwnerId
                                   FROM Task
                                   WHERE OwnerId IN :useridMap.keySet()
                                   AND RecordType.DeveloperName = 'Retention_Cadence_Task' // RecordType Id for 'Retention Cadence Task' on Task
                                   // AND Call_Disposition__c != null
                                   AND Call_Disposition__c IN ('\'Did You Know\' Informational Email', 'CBFS Portal Piece', 'MarketBuilder Piece', 'Personalized Note', 'SAVO Marketing Piece','Other')
                                   AND CreatedDate = LAST_N_DAYS:30
                                   GROUP BY OwnerId];
                                   
             Map<Id, Decimal> whatIdtoAllDispTask = new Map<Id, Decimal>();
             
             For (AggregateResult cdt: TaskCountAllDisposition) {
                 // Adding the WhatId and TaskCount for all dispositions to the Map Key and Value
                 whatIdtoAllDispTask.put((Id)cdt.get('OwnerId'), (decimal)cdt.get('TaskCountDisposition'));
             }
             
             For (Coaching__c c5: scope) {
                 
                 Decimal CountofTaskAllDisp = whatIdtoAllDispTask.get(c5.Sales_Rep__c);
                 Decimal RetCadTask = c5.Retention_Cadence_Task_Target__c;
                 
                 if (RetCadTask != null) {
                    
                    if (CountofTaskAllDisp >= RetCadTask) {
                        c5.Attainment_of_Retention_Cadence_Task_Tar__c = 1;
                    }
                    else {
                        c5.Attainment_of_Retention_Cadence_Task_Tar__c = 0;
                    }
                 }
             }
            /*For (AggregateResult tc: EventResults) {
                ownerstageMap.put((String)tc.get('OwnerId')+(String)tc.get('StageName'),(Decimal)tc.get('EventCount'));
            }*/
            
            // Checking if there is a match between Opp OwnerId and Coahing Sales Person
            /* For (Coaching__c c2: scope) {
                Decimal YearlyGoal = 3*c2.Yearly_Goal__c; // YearlyGoal = 3xYearly Goal
                Decimal YearlyGoal2 = (3/4)*c2.Yearly_Goal__c; //YearlyGoal2 = 3/4xYearly Goal
                Decimal YearlyGoal3 = c2.Target_Verbal_Wins__c; //YearlyGoal3 = Target Verbal Wins
                Decimal OppTotalAmount = ownerTosum.get(c2.Sales_Rep__c); // OppTotalAmount represent the Sales Person from Coaching based on ownerTosum Map
                if (OppTotalAmount >= YearlyGoal) {
                    c2.Attainment_of_Pursue_Target__c = 1;
                }
                else {
                    c2.Attainment_of_Pursue_Target__c = 0;
                }
                if (OppTotalAmount >= YearlyGoal2) {
                    c2.Attainment_of_Propose_Target__c = 1;
                }
                else {
                    c2.Attainment_of_Propose_Target__c = 0;
                }
                if (OppTotalAmount >= YearlyGoal3) {
                    c2.Target_Verbal_Wins__c = 1;
                }
                else {
                    c2.Target_Verbal_Wins__c = 0;
                }
            }
            */
            
            // Partialy saves data
             //update scope;
            Database.update(scope,false);
    }
    
    public void pursueCalc(Coaching__c c,Decimal oppSum) {
        if (c.Yearly_Goal__c != null) {
        Decimal YearlyGoal = 3*c.Yearly_Goal__c; // YearlyGoal = 3xYearly Goal
        if (oppSum >= YearlyGoal) {
            c.Attainment_of_Pursue_Target__c = 1;
         }
         else {
            c.Attainment_of_Pursue_Target__c = 0;
         }
       }
    }
    
    public void proposeCalc(Coaching__c c,Decimal oppSum) {
        if (c.Yearly_Goal__c != null) {
        Decimal YearlyGoal2 = 0.75*c.Yearly_Goal__c; //YearlyGoal2 = 3/4xYearly Goal
        if (oppSum >= YearlyGoal2) {
            c.Attainment_of_Propose_Target__c = 1;
         }
         else {
            c.Attainment_of_Propose_Target__c = 0;
         }
       }
    }
    
    public void verbalwinCalc(Coaching__c c,Decimal oppSum) {
        if (c.Yearly_Goal__c != null) {
        //Decimal TargetWins = c.Target_Verbal_Wins__c; //YearlyGoal3 = Target Verbal Wins
        Decimal TargetWins = 1.4*c.Yearly_Goal__c;
        if (oppSum >= TargetWins) {
            c.Attainment_of_Verbal_Win_Target__c = 1;
         }
         else {
            c.Attainment_of_Verbal_Win_Target__c = 0;
         }
       }
    }
    
    global void finish(Database.BatchableContext bc)
    {
        
    }
    
    global void execute(SchedulableContext sc) {
		CoachingBatch batch = new CoachingBatch(); 
		Database.executebatch(batch, 10);
    }
}