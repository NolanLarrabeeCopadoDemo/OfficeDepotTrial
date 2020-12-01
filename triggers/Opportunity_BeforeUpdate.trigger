trigger Opportunity_BeforeUpdate on Opportunity (before insert, before update) {
    //Story#01514722 - Below Piece of code is used to skip RecordType (Tech Zone)
    for(Opportunity o: trigger.new)
    {
        if(util.checkRT('Opportunity').contains(o.recordtypeId))
            return;
    }
    Map<String, Id> stageList = new Map<String, String>();
    Map<String, String> stageToSummaryStage = new Map<String, String>();
    List<Stage_to_Summary_Stage__c> recList = [SELECT Id, Stage__c, Summary_Stage_Name__c FROM Stage_to_Summary_Stage__c];
    FiscalYearSettings fiscalYear= new FiscalYearSettings ();
    Integer currentMonth;
    Period perMonth = new Period ();
    
           // added for ticket 01474559
       if (Trigger.New != null) {
         for (Opportunity myOpp: Trigger.new) {
          if (Util.bizBoxRTIdsByObject('Opportunity').contains(myOpp.RecordTypeId)) {
           return;
          }
         }
        }
        

    
    if (Trigger.isInsert) {
    
    //FiscalYearSettingsId =: fiscalYear.Id 

        perMonth = [SELECT Id, Number,FiscalYearSettingsId,FiscalYearSettings.name  FROM Period WHERE                            
        Type = 'Month' AND StartDate <=: System.Today() AND EndDate >=: System.Today() LIMIT 1];
        currentMonth = perMonth.Number;
        //fiscalYear = [SELECT Id,name  FROM FiscalYearSettings WHERE Id= :perMonth.FiscalYearSettingsId   LIMIT 1];    

    }
    
    for (Stage_to_Summary_Stage__c rec : recList) {
        stageList.put(rec.Stage__c, rec.Id);
        stageToSummaryStage.put(rec.Stage__c, rec.Summary_Stage_Name__c);
    }  
    
    for (Opportunity opp : Trigger.new) {
        //00668192        
                if (Trigger.isInsert) {
                  opp.Created_Fiscal_Month__c=String.valueof(currentMonth); 
                  opp.Fiscal_Year__c= string.valueof(perMonth.FiscalYearSettings.name);              
                }

        if (Trigger.isUpdate) {
            if (opp.PLOC_Opportunity_Stage__c != Trigger.oldMap.get(opp.Id).PLOC_Opportunity_Stage__c) {
                opp.Last_Stage_Change__C = System.now();
                opp.Stage_Summary_Stage__C = stageList.get(opp.PLOC_Opportunity_Stage__c);
                
                // Store previous values
                opp.Previous_PLOC_Opportunity_Stage__c = Trigger.oldMap.get(opp.Id).PLOC_Opportunity_Stage__c;
                
                if (stageList.containsKey(opp.Previous_PLOC_Opportunity_Stage__c)) {
                    opp.Previous_Summary_Stage__c = stageToSummaryStage.get(opp.Previous_PLOC_Opportunity_Stage__c);
                }
            }
        }
    }
}