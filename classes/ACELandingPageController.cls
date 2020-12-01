public class ACELandingPageController{
    List<ACE_Batches__c> BatchList = new List<ACE_Batches__c>();
    public Integer ListSize{get;set;}
    public List<String> BatchNames{get;set;}
    public Set<String> BatchSet{get;set;}
    public List<custListTable> clsCusListTable{get;set;}
    public Boolean IsRemedyOrHosted{get;set;}
    public String AccessLevel{get;set;}
    public Decimal UnlockedAccounts {get;set;}
    
    public class custListTable{
        public ACE_Customer_Price_Changes__c  ts{get;set;}
        public String BATCH{get;set;}                                        
        public Decimal ANNSPND{get;set;}
        public Decimal PERCENTINC{get;set;}
        public Decimal SRMTOT{get;set;} 
        public Integer CUSCOUNT{get;set;}       
    }
    
    public ACELandingPageController(){
        //Set AccessLevel - Starts
          AccessLevel = 'GENERAL';
          
          UnlockedAccounts = [select count() from ACE_Customer_Price_Changes__c where Record_Unlock__c = true and customer__r.ownerID =: UserInfo.getUserID()];                                       
          
          For (Group g : [select id,name from group where name in ('Remediation Team')]) 
             for (groupMember gm : [SELECT id from groupmember where groupid = :g.id and UserOrGroupId = :userinfo.getUserId()])
                AccessLevel = 'REMEDIATION';
                
          For (Group g : [select id,name from group where name in ('Hosted Catalog Team')]) 
             for (groupMember gm : [SELECT id from groupmember where groupid = :g.id and UserOrGroupId = :userinfo.getUserId()])
                AccessLevel = 'HOSTED';
        
        if(AccessLevel == 'HOSTED' || AccessLevel == 'REMEDIATION')
            IsRemedyOrHosted = true;
        else
            IsRemedyOrHosted = false;
            
        // Set AccessLevel - Ends
        clsCusListTable = new List<custListTable>();
        BatchSet = new Set<String>();
        List<ACE_Batches__c> blist;
        bList = [SELECT Batch__c FROM ACE_Batches__c order by createddate desc];
        
       /* for(ACE_Batches__c b:bList){ 
            //to remove duplicates   
            system.debug('Batches11:' + b.batch__c);       
            BatchSet.add(b.Batch__c);            
            
        }*/       
        
        for(Ace_Batches__c B: bList){
        	system.debug('Batches22:' + b); 
            custListTable c = new custListTable();
            c.BATCH = B.batch__c;
            AggregateResult[] results;
            if (AccessLevel == 'REMEDIATION') {
                
                results = [SELECT count(id)cnt,SUM(SRM_Differential__c) summary,
                                                SUM(Item_12_Month_Qty__c) annspnd,
                                                SUM(Approved_Proposed_Price__c) nPrice,
                                                SUM(Current_Sell_Price__c) cPrice,
                                                SUM(Total_Spend_Impact_12_Month__c) aschnge 
                                                FROM ACE_Customer_Price_Changes__c where Name =:B.batch__c and (isremediation__c = true or Remedy_Status__c = 'Pending')];
            }
            else if (AccessLevel == 'HOSTED') {
                
                results = [SELECT count(id)cnt,SUM(SRM_Differential__c) summary,
                                                SUM(Item_12_Month_Qty__c) annspnd,
                                                SUM(Approved_Proposed_Price__c) nPrice,
                                                SUM(Current_Sell_Price__c) cPrice,
                                                SUM(Total_Spend_Impact_12_Month__c) aschnge 
                                                FROM ACE_Customer_Price_Changes__c where Name =:B.batch__c and hosted_catalog__c = true];
            }
            else {
           
            results = [SELECT count(id)cnt,SUM(SRM_Differential__c) summary,
                                                SUM(Item_12_Month_Qty__c) annspnd,
                                                SUM(Approved_Proposed_Price__c) nPrice,
                                                SUM(Current_Sell_Price__c) cPrice,
                                                SUM(Total_Spend_Impact_12_Month__c) aschnge 
                                                FROM ACE_Customer_Price_Changes__c where Name =:B.batch__c and Customer__r.OwnerId=:Userinfo.getUserId() and sfdc_notification_flag__c <> null];//ROM-38 AND Price_Not_Calculated__c = false
            }
            
            system.debug('madhavi:'+Userinfo.getUserId());
            
            for(AggregateResult ar : results){ 
                system.debug('madhavi:'+results[0].get('cnt'));
            	system.debug('madhavi1:'+results[0].get('aschnge'));
            	system.debug('madhavi2:'+results[0].get('cPrice'));
                system.debug('madhavi3:'+results[0].get('summary'));
            }
            //AnnSpndChnge= String.ValueOf(results[0].get('aschnge'));
            //perIncrease = Integer.ValueOf(results[0].get('annspnd'))/Integer.ValueOf(results[0].get('aschnge')) ;       
            //SRMImpTotal = String.ValueOf(results[0].get('summary'));
            if(null == results[0].get('aschnge'))
                c.ANNSPND = 0;
            else
                c.ANNSPND = math.abs(Integer.ValueOf(results[0].get('aschnge')));
                
            /*    
            if(null == results[0].get('annspnd'))
                c.PERCENTINC = 0;
            else    
                c.PERCENTINC = math.abs((Integer.ValueOf(results[0].get('annspnd'))/Integer.ValueOf(results[0].get('cnt')))/100);
            */
                                   
            if(results[0].get('cPrice') != null && Double.ValueOf(results[0].get('cPrice')) != 0)
                    c.PERCENTINC = (((Double.ValueOf(results[0].get('nPrice')) - (Double.ValueOf(results[0].get('cPrice')))) * 100) / (Double.ValueOf(results[0].get('cPrice')))); 
                else
                    c.PERCENTINC =0;

            
                 
            if(null == results[0].get('summary'))
                c.SRMTOT = 0;
            else
                c.SRMTOT = math.abs(Integer.ValueOf(results[0].get('summary')));
                
            c.CUSCOUNT = Integer.ValueOf(results[0].get('cnt'));
            clsCusListTable.add(c);
        }
    }
    
    
    
}