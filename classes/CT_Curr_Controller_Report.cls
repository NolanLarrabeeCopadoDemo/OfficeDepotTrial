public with sharing class CT_Curr_Controller_Report {

    public Summary[] Summaries { get; set; }
	
    //private string nll;
    
    
    public CT_Curr_Controller_Report() {        
        
        AggregateResult[] results = [select Calendar_Year(Review_Start_Date__C) RSYr, 
		Calendar_Month(Review_Start_Date__C) RSMnth, SUM(WA_Count__c) WA, Sum(NWA_Count__c) NWA,
        SUM(Top_Lvl_WA_Cnt__c) pWA, Sum(Top_Lvl_NWA_Count__c) pNWA,
		count(id) RecCnt 
		from Customer_Transition__c 
		Where Transition_Status__c = 'Active'
		Group by  Calendar_Year(Review_Start_Date__C), Calendar_Month(Review_Start_Date__C)
        Order by Calendar_Year(Review_Start_Date__C), Calendar_Month(Review_Start_Date__C) ];
        Summaries = new List<Summary>();
        for (AggregateResult ar : results) {
            Summaries.add(new Summary(ar));
        }
    }

    // wrapper class to hold aggregate data
    public class Summary {
        public String sYr { get; private set; }
        public String Mnth { get; private set; }
        public Integer Wa { get; private set; }
        public Integer NWa { get; private set; }
        public Integer pWa { get; private set; }
        public Integer pNWa { get; private set; }
        public Integer CTCnt { get; private set; }

        public Summary(AggregateResult ar) {
            
            sYr = (String) Right(String.Valueof(ar.get('RSYr')),2);
        	Mnth = (String) String.Valueof(ar.get('RSMnth'));            
            WA = (Integer) Integer.ValueOf(ar.get('WA'));
            NWA = (Integer) Integer.ValueOf(ar.get('NWA'));
            pWA = (Integer) Integer.ValueOf(ar.get('pWA'));
            pNWA = (Integer) Integer.ValueOf(ar.get('pNWA'));            
            CTCnt = (Integer) ar.get('RecCnt');
        }
public String right(String s, Integer i) {
	if (s == null || s == '' || i <=0 ) {
        return '';} 
    		else if (i >= s.length()) {	
        return s;}
    		else {
        return s.subString(s.length() - i, s.length());}
}

    }
                                     
 
 
 
}