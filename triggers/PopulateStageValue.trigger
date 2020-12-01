trigger PopulateStageValue on Opportunity_Tracking_History__c (before insert, before update) {

    List<Opportunity_History_Tracking_Fields__c> StageValues = new List<Opportunity_History_Tracking_Fields__c >();
    StageValues = [SELECT Stage_Name__c, Display_Stage__c FROM Opportunity_History_Tracking_Fields__c WHERE Is_Watson__c = false];
    Map<String, String> st = new Map<String, String>();    
    
    
    Map<String,String> recListMap= new Map<String,String> ();
    List<Product_Subtypes_to_Pillar__c> recList=[select Product__C,Pillar__c,Product_Subtype__c from Product_Subtypes_to_Pillar__c];
    for(Product_Subtypes_to_Pillar__c rec: recList){
    if(rec.Product__C!=null){
        if(rec.Product_Subtype__c==null)
        recListMap.put(rec.Product__C, rec.pillar__C);
        else
        recListMap.put(rec.Product__C+rec.Product_Subtype__c , rec.pillar__C);   
        }
                   System.debug('&&&&&&&&Rec'+rec.Product__C+rec.Product_Subtype__c );

    }
    
    
    for (Opportunity_History_Tracking_Fields__c sv : StageValues) { 
        st.put(sv.Stage_Name__c, sv.Display_Stage__c);
    }
    
    // Map of stages to summary stages
    Map<String, String> summaryStages = new Map<String, String>();
    
    for (Stage_to_Summary_Stage__c sss : [SELECT Stage__c, Summary_Stage_Name__c FROM Stage_to_Summary_Stage__c]) {
        summaryStages.put(sss.Stage__c, sss.Summary_Stage_Name__c);
    }
    
    for (Opportunity_Tracking_History__c hist : Trigger.new) {    
       if(hist.product__C!=null){   
           if(hist.Product_Sub_Type__c!=null){
           hist.pillar__C= recListMap.get(hist.product__C+hist.Product_Sub_Type__c);
               if(hist.pillar__C==null)
               hist.pillar__C= recListMap.get(hist.product__C);   
    
           }
           else{
           hist.pillar__C= recListMap.get(hist.product__C);   
           }
           
           System.debug('&&&&&&&&'+hist.product__C+hist.Product_Sub_Type__c);
       }
    
        if (hist.Stage__c != null) {
            List<String> stagelst = hist.Stage__c.split('-');
            String stagePer = stagelst[0];
            hist.Holistic_Flow_Stage__c = st.get(stagePer);
            
            // Populate old summary stages
            if (hist.PLOC_stage__c != null) {
                hist.Summary_Stage__c = summaryStages.get(hist.PLOC_stage__c);
            }
            
            if (hist.PLOC_Old_Value__c != null) {
                hist.Summary_Stage_Old_Value__c = summaryStages.get(hist.PLOC_Old_Value__c);
            }
        }
        
    }
}