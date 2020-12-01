public class OppTrackingHistoryController {

    public String pipelineWeek {get;set;}
    public String pipelineWeekPdf {get;set;}
    public List<StageWrapper> stageList {get;set;}
    public decimal totalOwned {get;set;}
    public decimal totalTeamed {get;set;}
    public decimal totalOpps {get;set;}

    public void getWatsonValues() {
        getCurrentFiscalWeek();
        pipelineWeekPdf = pipelineWeek;
        
        // Get summary stage and remaining count from Opportunity_Tracking_History__c 
        List<AggregateResult> stageRemainingList = [SELECT Summary_Stage__c, COUNT(Id) Remaining
                                                    FROM Opportunity_Tracking_History__c 
                                                    WHERE Is_Watson__c = true
                                                    AND Pipeline_Week__c = :pipelineWeek
                                                    AND Type__c = 'Weekly'
                                                    AND Summary_Stage__c != NULL
                                                    AND Summary_Stage__c != '10.End-of-Opportunity'
                                                    AND IsClosed__c = false
                                                    GROUP BY Summary_Stage__c
                                                    ORDER BY Summary_Stage__c];
                                                
        Map<String, integer> stageRemainingMap = new Map<String, integer>();
        
        for (AggregateResult ar : stageRemainingList) {
            stageRemainingMap.put((String)ar.get('Summary_Stage__c'), ((decimal)ar.get('Remaining')).intValue());
        }
        
        // Populate list of stage wrapper
        stageList = new List<StageWrapper>();
       
        for (String stageName : stageRemainingMap.keySet()) {
            StageWrapper wrapper = new StageWrapper();
            
            wrapper.stageName = stageName;
            wrapper.remaining = stageRemainingMap.get(stageName);
            
            stageList.add(wrapper);
        }
        
        // Get total for pipeline week
        AggregateResult totalAr = [SELECT COUNT(Id) Total
                                   FROM Opportunity_Tracking_History__c 
                                   WHERE Is_Watson__c = true
                                   AND Pipeline_Week__c = :pipelineWeek
                                   AND Type__c = 'Weekly'
                                   AND Summary_Stage__c != NULL
                                   AND IsClosed__c = false];
                                   
        Integer total = ((decimal)totalAr.get('Total')).intValue();
        
        // Get not ready for week
        List<AggregateResult> notReadyList = [SELECT Previous_Summary_Stage__c, COUNT(Id) Not_Ready
                                              FROM Opportunity_Tracking_History__c 
                                              WHERE Is_Watson__c = true
                                              AND Summary_Stage__c = '10.End-of-Opportunity'
                                              AND Type__c = 'Weekly'
                                              AND Previous_Summary_Stage__c != NULL
                                              AND Pipeline_Week__c = :pipelineWeek
                                              AND IsClosed__c = false
                                              GROUP BY Previous_Summary_Stage__c];
        
        Map<String, Integer> notReadyMap = new Map<String, Integer>();
        
        for (AggregateResult ar : notReadyList) {
            notReadyMap.put((String)ar.get('Previous_Summary_Stage__c'), ((decimal)ar.get('Not_Ready')).intValue());
        }
        
        // Populate total, converted, rate and not ready
        boolean first = true;
        
        for (integer i = 0; i < stageList.size(); i++) {
            // Total
            if (first) {
                stageList[i].total = total;
                first = false;
            }
            else {
                stageList[i].total = stageList[i-1].converted;
            }
            
            // Not ready
            if (notReadyMap.containsKey(stageList[i].stageName)) {
                stageList[i].notReady = notReadyMap.get(stageList[i].stageName);
            }
            else {
                stageList[i].notReady = 0;
            }
            
            // Converted
            stageList[i].converted = stageList[i].total - (stageList[i].remaining + stageList[i].notReady);
            
            // Rate
            if (stageList[i].total != 0) {
                stageList[i].rate = stageList[i].converted * 100 / stageList[i].total;
            }
            else {
                stageList[i].rate = 0;
            }
        }
        
        // Show empty table
        if (stageList.size() == 0) {
            List<AggregateResult> stages = [SELECT Summary_Stage_Name__c
                                            FROM Stage_to_Summary_Stage__c
                                            WHERE Summary_Stage_Name__c != '10.End-of-Opportunity'
                                            GROUP BY Summary_Stage_Name__c];
            
            for (AggregateResult stage : stages) {
                StageWrapper wrapper = new StageWrapper();
            
                wrapper.stageName = (String)stage.get('Summary_Stage_Name__c');
                wrapper.total = 0;
                wrapper.remaining = 0;
                wrapper.converted = 0;
                wrapper.rate = 0;
                wrapper.notReady = 0;
                
                stageList.add(wrapper);
            }
        }
    }

    public void getNonWatsonValues() {
        getCurrentFiscalWeek();
        Integer totalNonWatOwned=0,totalNonWatteam=0;
        

        // Get map of owned and teamed amounts
        List<AggregateResult> ownedTeamedList = [SELECT Holistic_Flow_Stage__c, SUM(ILC_Owned_int__c) Owned, SUM(ILC_Team_Owned_int__c) Teamed
                                                 FROM Opportunity_Tracking_History__c 
                                                 WHERE Is_Watson__c = false
                                                 AND Pipeline_Week__c = :pipelineWeek
                                                 AND Holistic_Flow_Stage__c != null
                                                 AND Type__c = 'Weekly'
                                                 AND IsClosed__c = false
                                                 GROUP BY Holistic_Flow_Stage__c];
        Map<String, AggregateResult> ownedTeamedMap = new Map<String, AggregateResult>();
        
        for (AggregateResult ar : ownedTeamedList) {
            ownedTeamedMap.put((String)ar.get('Holistic_Flow_Stage__c'), ar);
            totalNonWatOwned=totalNonWatOwned+((decimal)ar.get('Owned')).intValue();
            totalNonWatteam=totalNonWatteam+((decimal)ar.get('Teamed')).intValue();

        }                                                         
        
        // Map of owned amount
        List<AggregateResult> ownedAmountList = [SELECT Holistic_Flow_Stage__c, SUM(Amount__c) ownedAmount
                                                 FROM Opportunity_Tracking_History__c 
                                                 WHERE Is_Watson__c = false
                                                 AND Pipeline_Week__c = :pipelineWeek
                                                 AND Is_ILC_Owned__c = true
                                                 AND Holistic_Flow_Stage__c != null
                                                 AND Type__c = 'Weekly'
                                                 AND IsClosed__c = false
                                                 GROUP BY Holistic_Flow_Stage__c];
        
        Map<String, Decimal> ownedAmountMap = new Map<String, Decimal>();
        
        for (AggregateResult ar : ownedAmountList) {
            ownedAmountMap.put((String)ar.get('Holistic_Flow_Stage__c'), (Decimal)ar.get('ownedAmount'));
        } 
        
        // Map of teamed amount                                                     
        List<AggregateResult> teamedAmountList = [SELECT Holistic_Flow_Stage__c, SUM(Amount__c) teamedAmount
                                                  FROM Opportunity_Tracking_History__c 
                                                  WHERE Is_Watson__c = false
                                                  AND Pipeline_Week__c = :pipelineWeek
                                                  AND Is_ILC_Team_Owned__c = true
                                                  AND Holistic_Flow_Stage__c != null
                                                  AND Type__c = 'Weekly'
                                                  AND IsClosed__c = false
                                                  GROUP BY Holistic_Flow_Stage__c];
                                                  
        Map<String, Decimal> teamedAmountMap = new Map<String, Decimal>();
        
        for (AggregateResult ar : teamedAmountList) {
            teamedAmountMap.put((String)ar.get('Holistic_Flow_Stage__c'), (Decimal)ar.get('teamedAmount'));
        }                                          

        // Populate list of wrappers from maps
        stageList = new List<StageWrapper>();
        List<Opportunity_History_Tracking_Fields__c> StageValues = [SELECT Display_Order__c, Display_Stage__c
                                                                    FROM Opportunity_History_Tracking_Fields__c
                                                                    WHERE Is_Watson__c = false
                                                                    ORDER BY Display_Order__c];
        
        for (Opportunity_History_Tracking_Fields__c stage : StageValues) {
            // Stage
            StageWrapper wrapper = new StageWrapper();
            wrapper.stageName = stage.Display_Stage__c;
            
            // Owned and teamed amounts
            AggregateResult ar = ownedTeamedMap.get(stage.Display_Stage__c);
            
            if (ar != null) {
                wrapper.owned = ((decimal)ar.get('Owned')).intValue();
                wrapper.teamed = ((decimal)ar.get('Teamed')).intValue();
            }
            else {
                wrapper.owned = 0;
                wrapper.teamed = 0;
            }
            
            // Owned amount
            if (ownedAmountMap.containsKey(stage.Display_Stage__c)) {
                wrapper.ownedAmount = ownedAmountMap.get(stage.Display_Stage__c);
            }
            else {
                wrapper.ownedAmount = 0;
            }
            
            // Teamed amount
            if (teamedAmountMap.containsKey(stage.Display_Stage__c)) {
                wrapper.teamedAmount = teamedAmountMap.get(stage.Display_Stage__c);
            }
            else {
                wrapper.teamedAmount = 0;
            }
            
            // Add wrapper
            stageList.add(wrapper);
        }             
        
        // Calculate remaining values
        totalOwned = 0;
        totalTeamed = 0;
        totalOpps = 0;

        for (integer i = 0; i < stageList.size(); i++) {
            // Get total
            integer owned = stageList[i].owned;
            integer teamed = stageList[i].teamed;
            stageList[i].total = owned + teamed;           
            
            // Total
            if (i==0) {
                stageList[i].Totalowned = totalNonWatOwned;
                stageList[i].Totalteamed = totalNonWatteam;
                stageList[i].TotalWatson =stageList[i].Totalowned+stageList[i].Totalteamed;
            }
            else {
                stageList[i].Totalowned = stageList[i-1].Totalowned -stageList[i-1].owned;
                stageList[i].Totalteamed = stageList[i-1].Totalteamed -stageList[i-1].teamed;

                stageList[i].TotalWatson = stageList[i-1].converted;
            }
            
            

            
            
     
            // Get converted (based on next stage)
            if (i != stageList.size()-1) {
                owned = stageList[i+1].owned;
                teamed = stageList[i+1].teamed;
                stageList[i].converted =  stageList[i].TotalWatson- stageList[i].total;
            }
            else {
                stageList[i].converted = 0;
            }
            
            
            // Get total $
            stageList[i].totalAmount = stageList[i].ownedAmount + stageList[i].teamedAmount;
            
            // Get conversion rate
            if (stageList[i].TotalWatson == 0) {
                stageList[i].rate = 0;
            }
            else {
                stageList[i].rate = stageList[i].converted * 100 / stageList[i].TotalWatson;
            }
            
            // Keep running totals
            totalOwned += stageList[i].ownedAmount;
            totalTeamed += stageList[i].teamedAmount;
            totalOpps += stageList[i].totalAmount;
        }
        
        StageWrapper wrp = new StageWrapper();
            
            wrp.stageName='TOTAL';
            wrp.ownedAmount = totalOwned;
            wrp.teamedAmount = totalTeamed ;
            wrp.totalAmount  = totalOpps ;
            stageList.add(wrp);
    }
    
    private void getCurrentFiscalWeek() {
        // Determine the fiscal week (must be fiscal year for current year existing in org)
        FiscalYearSettings fiscalYear = [SELECT Id 
                                         FROM FiscalYearSettings 
                                         WHERE Name = :String.valueOf(System.Today().Year()) 
                                         LIMIT 1];
        
        Period per = [SELECT Id, Number 
                      FROM Period 
                      WHERE FiscalYearSettingsId = :fiscalYear.Id 
                      AND Type = 'Week' 
                      AND StartDate <= :System.Today() 
                      AND EndDate >= :System.Today() 
                      LIMIT 1];
        
        String currWeek = System.Today().Year() + '-W' + per.Number;
        
        if (pipelineWeek == '' || pipelineWeek == null) {
            pipelineWeek = currWeek;
        }
    }
    
    public Pagereference createPDF() {
        return new Pagereference('/apex/NonWatsonDBPDF');
    }
    
    public Pagereference createPdfWatson() {
        return new Pagereference('/apex/WatsonPipelinePdf');
    }
    
    public class StageWrapper {
        public String stageName {get; set;}
        public integer owned {get; set;}
        public integer teamed {get; set;}
        public integer Totalowned {get; set;}
        public integer Totalteamed {get; set;}
        public integer TotalWatson {get; set;}
        public integer total {get; set;}
        public integer remaining {get; set;}
        public integer converted {get; set;}
        public decimal ownedAmount {get; set;}
        public decimal teamedAmount {get; set;}
        public decimal totalAmount {get; set;}
        public integer rate {get; set;}
        public integer notReady {get; set;}
    }
}