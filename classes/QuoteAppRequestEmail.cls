public class QuoteAppRequestEmail {
    public class quoteinfoWrapper {
        @AuraEnabled
        public CameleonCPQ__QxQuote__c quotqQx { get; set; }
        @AuraEnabled
        public List <CameleonCPQ__QxQuoteLine__c> quotlineQxList { get; set; }
        @AuraEnabled
        public List <complianceinfoWrapper> compList { get; set; }
        @AuraEnabled
        public List <maintennaceinfoWrapper> mainList { get; set; }
        @AuraEnabled
        public List <businessinfoWrapper> busList { get; set; }
        @AuraEnabled
        public List <processinstancestep> pisList { get; set; }
        public quoteinfoWrapper(CameleonCPQ__QxQuote__c quo, List <CameleonCPQ__QxQuoteLine__c> quotlineList, List <processinstancestep> pisList, List <complianceinfoWrapper> compList,
                                List <maintennaceinfoWrapper> mainList, List <businessinfoWrapper> busList) {
                                    this.quotqQx = quo;
                                    this.quotlineQxList = quotlineList;
                                    this.pisList = pisList;
                                    this.compList = compList;
                                    this.mainList = mainList;
                                    this.busList = busList;
                                }
    }
    public class complianceinfoWrapper {
        @AuraEnabled
        public String Name { get; set; }
        @AuraEnabled
        public String Req { get; set; }
        @AuraEnabled
        public String Msg { get; set; }
        
        public complianceinfoWrapper(String Name, String Req, String Msg) {
            this.Name = Name;
            this.Req = Req;
            this.Msg = Msg;
        }
    }
    @AuraEnabled
    public List <complianceinfoWrapper> compList { get; set; }
    public class maintennaceinfoWrapper {
        @AuraEnabled
        public String Name { get; set; }
        @AuraEnabled
        public Decimal Req { get; set; }
        @AuraEnabled
        public String Msg { get; set; }
        
        public maintennaceinfoWrapper(String Name, Decimal Req, String Msg) {
            this.Name = Name;
            this.Req = Req;
            this.Msg = Msg;
        }
    }
    @AuraEnabled
    public List <maintennaceinfoWrapper> mainList { get; set; }
    public class businessinfoWrapper {
        @AuraEnabled
        public String Name { get; set; }
        @AuraEnabled
        public String Req { get; set; }
        @AuraEnabled
        public String Msg { get; set; }
        
        public businessinfoWrapper(String Name, String Req, String Msg) {
            this.Name = Name;
            this.Req = Req;
            this.Msg = Msg;
        }
    }
    @AuraEnabled
    public List <businessinfoWrapper> busList { get; set; }
    @AuraEnabled
    public static quoteinfoWrapper quoteapp(String quo) {
        CameleonCPQ__QxQuote__c quotqQx = new CameleonCPQ__QxQuote__c();
        List <CameleonCPQ__QxQuoteLine__c> quotlineQxList = new List <CameleonCPQ__QxQuoteLine__c>();
        List <complianceinfoWrapper> compList = new List <complianceinfoWrapper>();
        List <maintennaceinfoWrapper> mainList = new List <maintennaceinfoWrapper>();
        List <businessinfoWrapper> busList = new List <businessinfoWrapper>();
        quotqQx = [SELECT id, name, Analyst_Notes__c, Hist_Total_Contract_Sales_Gross__c, CPM_Total_Contract_Sales_Gross__c,
                   Hist_Net_IGM_Customer_Margin_Perc__c, CPM_Net_IGM_Customer_Margin_Perc__c, Hist_Contribution_Margin_Perc__c,
                   CPM_Contribution_Margin_Perc__c, Non_standard_callout_comment_box__c FROM CameleonCPQ__QxQuote__c where id =: quo
                  ];
        for(CameleonCPQ__QxQuoteLine__c prosLineItems :[select id,Name,Recordtype.Name,ES_Ext_Net__c, Violation_Message__c,Violation_Requirement__c,ES_Core_Perc__c,ES_Price_Lock_Days__c,ES_Below_Floor_Count__c,ES_IGM__c,ES_Price_Increases__c,ES_Price_Decreases__c,ES_Additions__c,ES_Deletions__c,ES_Ext_Sell__c,Product_Category__c,Violation_Count__c,Violation_Type__c,CameleonCPQ__QuoteId__c from CameleonCPQ__QxQuoteLine__c where CameleonCPQ__QuoteId__c= :quo ]) {
            if(prosLineItems.Violation_Message__c != null || prosLineItems.Violation_Requirement__c != null || 
               prosLineItems.ES_Below_Floor_Count__c != null || prosLineItems.ES_IGM__c != null || 
               prosLineItems.ES_Price_Increases__c != null ||  prosLineItems.ES_Price_Decreases__c != null || 
               prosLineItems.ES_Additions__c != null  || prosLineItems.ES_Deletions__c != null || 
               prosLineItems.ES_Ext_Sell__c != null || prosLineItems.Product_Category__c != null ||
               prosLineItems.Violation_Count__c != null || prosLineItems.Violation_Type__c != null  ) {
                quotlineQxList.add(prosLineItems);   
               }
        }
        for (CameleonCPQ__QxQuoteLine__c ql: quotlineQxList) {
            if (ql.Violation_Type__c == 'Compliance') {
                complianceinfoWrapper cw = new complianceinfoWrapper(ql.Name, ql.Violation_Requirement__c, ql.Violation_Message__c);
                compList.add(cw);
            }
            if (ql.Violation_Type__c == 'Maintenance') {
                maintennaceinfoWrapper mw = new maintennaceinfoWrapper(ql.Name, ql.Violation_Count__c, ql.Violation_Message__c);
                mainList.add(mw);
            }
            if (ql.Violation_Type__c == 'Business') {
                businessinfoWrapper bw = new businessinfoWrapper(ql.Name, ql.Violation_Requirement__c, ql.Violation_Message__c);
                busList.add(bw);
            }
        }
        
        List <ProcessInstance> plist = [SELECT Id, ProcessDefinitionId, TargetObjectId, Status, LastActorId FROM ProcessInstance where TargetObjectId =: quo ORDER BY createddate desc];
        Set <Id> processInstanceIds = new Set <Id>();
        for (ProcessInstance pi: plist) {
            processInstanceIds.add(pi.Id);
        }
        List <processinstancestep> pisList = [select id, stepstatus, actor.Name, comments, originalactor.name from processinstancestep where processinstanceId IN: processInstanceIds and stepstatus != 'Started' ORDER BY createddate desc ];
        quoteinfoWrapper quop = new quoteinfoWrapper(quotqQx, quotlineQxList, pisList, compList, mainList, busList);
        system.debug(' the wrapper being returned is:'+quotlineQxList);
        return quop;
    }
}