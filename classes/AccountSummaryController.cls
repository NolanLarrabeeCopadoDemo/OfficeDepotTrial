public with sharing class AccountSummaryController{
    @AuraEnabled
    public static Account getAccount(Id AcctId) {
        // Id AcctId = '001E000000EElvu';
        Account acct = [SELECT Id, name, Address1__c , Address2__c , City__c, State__c, Zip__c , Phone, Org__r.Id, Org__r.Business_Name__c, Org__r.Address_1__c, Org__r.Address_2__c, Org__r.City__c, Org__r.State__c, Org__r.Zip__c, Org__r.Employee_Count__c, Org__r.DUNS_Number__c, Org__r.Website__c, Org__r.Primary_Industry__c, Org__r.Company_Phone__c, Org__r.Type__c, Org__r.Parent_Org__c, Org__r.Alt_Business_Name_1__c, Org__r.Alt_Business_Name_2__c, Org__r.Alt_Business_Name_3__c,   Org__r.Corporate_Hierarchy_Type__c, Org__r.Location__Latitude__s, Org__r.Location__Longitude__s, 
                        Org__r.SITE_EMPLOYEE_CNT__c, Org__r.SITE_SALES_AMT__c, Org__r.GLOBAL_ULTIMATE_DUNS_NUM__c, Org__r.GLOBAL_ULTIMATE_SALES_AMT__c, Org__r.LOB__c, Org__r.SECONDARY_NAME__c, Org__r.HQ_Org__c, Org__r.D_B_ID__c, Org__r.Count_of_Customers__c, Org__r.Customer_YTD_Sales_LY__c, Org__r.Customer_YTD_Sales_TY__c,Org__r.Annual_sales__c, Org__r.Market_value__c, Org__r.Total_assets__c, Org__r.Creditworthiness__C,
                        Related_Account__c,Related_DML__r.DECISION_MAKER_ID__c,Related_DML__r.DECISION_MAKER_ZIP_CD__c,Related_DML__r.DECISION_MAKER_NM__c,
                        Related_DML__r.Duns_Number__c,Related_DML__r.Effective_End_Date__c,Related_DML__r.Effective_Start_Date__c,Related_DML__r.Status__c,
                        Related_DML__r.Reason_for_Creation__c,Org__r.Parent_Org__r.Business_Name__c, Org__r.Parent_Org__r.Address_1__c, Org__r.Parent_Org__r.Address_2__c, Org__r.Parent_Org__r.Parent_Org__r.City__c, Org__r.Parent_Org__r.State__c, Org__r.Parent_Org__r.Zip__c
                         FROM Account where id =:AcctId];
        return acct;
    }
    @AuraEnabled
    public static Org__C getOrg(Id OrgId) {
        Org__C org = [SELECT Id, Business_Name__c, Address_1__c, Address_2__c, City__c, State__c, Zip__c, Employee_Count__c, DUNS_Number__c, Website__c, Primary_Industry__c, Company_Phone__c, Type__c, Parent_Org__c, Alt_Business_Name_1__c, Alt_Business_Name_2__c, Alt_Business_Name_3__c, Temp_Account_ID__c, DML__c, FullAddress__c, Corporate_Hierarchy_Type__c, Location__Latitude__s, Location__Longitude__s, SITE_EMPLOYEE_CNT__c, SITE_SALES_AMT__c, GLOBAL_ULTIMATE_DUNS_NUM__c, GLOBAL_ULTIMATE_SALES_AMT__c, LOB__c, SECONDARY_NAME__c, HQ_Org__c, D_B_ID__c, Primary_DML__c, DML_1__c, DML2__c, Alternative_Relationship_1__c, Alternative_Relationship_2__c, Alternative_Relationship_3__c, BatchProcessed__c, Count_of_Customers__c, Customer_YTD_Sales_LY__c, Customer_YTD_Sales_TY__c, BatchTemp__c, Annual_sales__c, Market_value__c, Total_assets__c, Creditworthiness__c FROM org__C where id =:OrgId]; 
        return org ;
            }
  /*  @AuraEnabled
    public static List <Account> getAccounts() {
        id x ='001E000000EElvu';
        return [SELECT Id, name, industry, Type, NumberOfEmployees, TickerSymbol, Phone FROM Account where id =:x];
    }*/
    @AuraEnabled
    public static List<Org__C> findAll(Id OrgId) {        
        System.debug('&&&&&&OrgId'+OrgId);
        List<Org__C> top_accts= new List<Org__C>();
        Set<id> orgSet = new Set<id> ();
        Set<Id> parent_acc_ids = new Set<Id>();
        //get ParentId's of the current Org Id
        Org__C orgRec=[select Id, Parent_Org__C ,Parent_Org__r.Parent_Org__C,Parent_Org__r.Parent_Org__r.Parent_Org__C from Org__C 
                       where Id=:OrgId];
        if(orgRec.Parent_Org__r.Parent_Org__r.Parent_Org__C  !=null)
            top_accts=[ Select Id, Business_name__C from Org__C where Id=:orgRec.Parent_Org__r.Parent_Org__r.Parent_Org__C];
        else if(orgRec.Parent_Org__r.Parent_Org__C!=null)
            top_accts=[ Select Id, Business_name__C from Org__C where Id=:orgRec.Parent_Org__r.Parent_Org__C];
        else if(orgRec.Parent_Org__C!=null)
            top_accts=[ Select Id, Business_name__C from Org__C where Id=:orgRec.Parent_Org__C];
        else
            top_accts=[ Select Id, Business_name__C from Org__C where Id=:OrgId];        
        System.debug('&&&&&&top_accts'+top_accts);        
        for (Org__C a : top_accts) {
            orgSet.add(a.Id);            
            parent_acc_ids.add(a.Id);
        }
                while (parent_acc_ids.size() > 0) {
            Map<Id,Org__C> subordinate_accounts =
                new Map<Id,Org__C>([
                    SELECT Id, Parent_Org__c, Business_Name__c
                    FROM Org__c
                    WHERE Parent_Org__c IN :parent_acc_ids
                ]);                        
            parent_acc_ids = subordinate_accounts.keySet();
                        for (Org__C acc : subordinate_accounts.values()) {
                if(!orgSet.contains(acc.Id))             
                    orgSet.add(acc.Id);                               
            }
        }
        return [SELECT id, name,business_name__C, Location__Latitude__s, Location__Longitude__s
                FROM Org__C
                WHERE  Id in :orgSet and 
                Location__Latitude__s != NULL AND Location__Longitude__s != NULL
                LIMIT 50];
    }
    
    @AuraEnabled
    public static DML__C  getdml(String OrgId)
    {
                Account acc =[select id,related_dml__c from Account where id =:OrgId];
        //List<Account> DMLListacc = new List<Account>();
        Set<Id> Accid = new Set<Id>();
        Set<Id> AccountId= new Set<Id>();       
        List<Account> DMLListacc = new List<Account>();
        List<DML__c> DMLLists= new List<DML__c>();
        List<DML_Relation__C> DMLList= new List<DML_Relation__C>();
        DML_Relation__c  dmlRec= new DML_Relation__c  ();
        DML__c  dmlR= new DML__c  ();
        Id DMLId;
        try{
        dmlRec= [select id,DML__C
                 from DML_Relation__c where Account__C =:acc.id and 
                 (Effective_End_Date__c=null  or Effective_End_Date__c>=today)   order by createddate desc limit 1];
        }
        Catch(Exception e){
            
        }
        if(dmlRec !=null)
            DMLId=dmlRec.DML__C;
                List<DML_Relation__c  > relatedRecords= new List<DML_Relation__c  >();
        
        if(DMLId !=null){
            dmlR = [Select id , name,DECISION_MAKER_ID__c,DECISION_MAKER_ZIP_CD__c,DECISION_MAKER_NM__c,Duns_Number__c,Effective_Start_Date__c,Effective_End_Date__c,Status__c,Reason_for_Creation__c,DML_State__c,Decision_Maker_Rep_Name__c from DML__C where id=:DMLId];
            relatedRecords=[select Account__C from DML_Relation__c where dml__C =:DMLId and 
                            (Effective_End_Date__c=null  or Effective_End_Date__c>=today)   order by createddate desc];
            for(  DML_Relation__c rec :relatedRecords){
                if(  !AccountId.contains (rec.account__C))
                    AccountId.add((rec.account__C));               
            }
            List<Account > relatedAccounts = new List<Account > ();
            if(accountId.size()>0){
                relatedAccounts =[select Id,name  from account where Id in :accountId];
            }            
        }
        return dmlR;
    }    
    
       @AuraEnabled
    public static String  getAccid(String AcctId)
    {
                Account acc =[select id,related_dml__c from Account where id =:AcctId];
          List<Account > relatedAccounts = new List<Account> ();
        //List<Account> DMLListacc = new List<Account>();
        List<Id >  AccountId= new List<Id > ();
        Set<Id> Accid = new Set<Id>();
        List<Account> DMLListacc = new List<Account>();
        List<DML__c> DMLLists= new List<DML__c>();
        List<DML_Relation__C> DMLList= new List<DML_Relation__C>();
        DML_Relation__c  dmlRec= new DML_Relation__c  ();
        DML__c  dmlR= new DML__c  ();
        Id DMLId;
        String Accids;
        try{
        dmlRec= [select id,DML__C
                 from DML_Relation__c where Account__C =:acc.id and 
                 (Effective_End_Date__c=null  or Effective_End_Date__c>=today)   order by createddate desc limit 1];
        }
        Catch(Exception e){
            
        }
        if(dmlRec !=null)
            DMLId=dmlRec.DML__C;
                List<DML_Relation__c  > relatedRecords= new List<DML_Relation__c  >();
             
        if(DMLId !=null){
            dmlR = [Select id , name,DECISION_MAKER_ID__c,DECISION_MAKER_ZIP_CD__c,DECISION_MAKER_NM__c,Duns_Number__c,Effective_Start_Date__c,Effective_End_Date__c,Status__c,Reason_for_Creation__c,DML_State__c,Decision_Maker_Rep_Name__c from DML__C where id=:DMLId];
            relatedRecords=[select Account__C from DML_Relation__c where dml__C =:DMLId and 
                            (Effective_End_Date__c=null  or Effective_End_Date__c>=today) and account__C!=null order by createddate desc];
            for(  DML_Relation__c rec :relatedRecords){
                if(  !AccountId.contains (rec.account__C))
                    AccountId.add((rec.account__C));               
            }
          
            if(accountId.size()>0){
                relatedAccounts =[select Id  from account where Id in :accountId];
                Accids=string.join(AccountId,',');
                
            }            
        }
        system.debug('Accids'+Accids);
        return Accids;
    }    
}