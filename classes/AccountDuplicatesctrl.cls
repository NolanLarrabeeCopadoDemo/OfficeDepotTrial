public class AccountDuplicatesctrl {
    
    Public Decimal totalDormantAcctDuplicatesHeaders {get;set;}
    Public Decimal totalDormantAcctDuplicatesSites {get;set;}
    Public Decimal totalActiveAcctDuplicatesHeaders {get;set;}
    Public Decimal totalActiveAcctDuplicatesSites {get;set;}
    Public Decimal totalLeadDuplicates {get;set;}
    public Decimal totalLYSalesHeaders {get;set;}
    public Decimal totalTYSalesHeaders {get;set;}
    public Decimal totalLYSalesSites {get;set;}
    public Decimal totalTYSalesSites {get;set;}
    public ID AccountID {get;set;}
    //public salesDataImpact sdImpact {get;set;}            
    
      
    public class slsDataImpact {
        public String Category {get;set;}
        public Decimal TYSales {get;set;}
        public Decimal LYSales {get;set;}
    }
    
    public  list<Account_Duplicate_Junction__c> activeAcctDuplicatesLstHeaders {get;set;}
    public  list<Account_Duplicate_Junction__c> activeAcctDuplicatesLstSites {get;set;}
    public  list<Account_Duplicate_Junction__c> dormantAcctDuplicatesLstHeaders {get;set;}
    public  list<Account_Duplicate_Junction__c> dormantAcctDuplicatesLstSites {get;set;}
    public  list<Account_Duplicate_Junction__c> leadDuplicateslst {get;set;}
    public list<String> categories {get;set;}
    
    public list<Account_Duplicate_Junction__c> accDuplst {get;set;}
    public list<slsDataImpact> slsDataImpactlstHeaders {get;set;}
    public list<slsDataImpact> slsDataImpactlstSites {get;set;}
    public Map<String,String> catMap {get;set;}
    public boolean categoryHeaders {get;set;}
    public boolean categorySites {get;set;}
    public boolean activeAccounts {get;set;}
    public boolean activeSites {get;set;}
    public boolean dormantAccounts {get;set;}
    public boolean dormantSites {get;set;}
    public boolean leads {get;set;}

    
    public void displayHeaderCategory() {
        categoryHeaders = true;
    }
    
    public void hideHeaderCategory() {
        categoryHeaders = false;
    }
    
    public void displaySiteCategory() {
        categorySites = true;
    }
    
     public void hideSiteCategory() {
        categorySites = false;
    }
    
     public void displayAcitveAccts() {
         activeAccounts = true;
     }
    
    public void hideAcitveAccts() {
        activeAccounts = false;
     }
    
    public void displayAcitveSites() {
        activeSites = true;
     }
    
    public void hideAcitveSites() {
        activeSites = false;
     }
    
     public void displaydormantAccts() {
         dormantAccounts = true;
     }
    
    public void hidedormantAccts() {
        dormantAccounts = false;
     }
    
     public void displaydormantSites() {
         dormantSites = true;
     }
    
    public void hideDormantSites() {
        dormantSites = false;
     }
    
     public void displayleads() {
         leads = true;
     }
    
    public void hideleads() {
        leads = false;
     }
    
    public AccountDuplicatesctrl(ApexPages.StandardController controller) {
        categoryHeaders = false;
        categorySites = false;
        activeAccounts = false;
        activeSites = false;
        dormantAccounts = false;
        dormantSites = false;
        leads = false;
        activeAcctDuplicatesLstHeaders = new list<Account_Duplicate_Junction__c>();
        activeAcctDuplicatesLstSites = new list<Account_Duplicate_Junction__c>();
        dormantAcctDuplicatesLstHeaders = new list<Account_Duplicate_Junction__c>();
        dormantAcctDuplicatesLstSites = new list<Account_Duplicate_Junction__c>();
        leadDuplicateslst = new list<Account_Duplicate_Junction__c>();
        slsDataImpactlstHeaders = new list<slsDataImpact>();
        slsDataImpactlstSites = new list<slsDataImpact>();
        //sdImpact = new salesDataImpact();
        totalDormantAcctDuplicatesHeaders = 0;
        totalDormantAcctDuplicatesSites = 0;
        totalActiveAcctDuplicatesHeaders = 0;
        totalActiveAcctDuplicatesSites = 0;
        totalLeadDuplicates = 0;
        totalTYSalesHeaders=0;
        totalLYSalesHeaders=0;
        totalTYSalesSites=0;
        totalLYSalesSites=0;
        
        Account a = (Account)controller.getRecord();
        AccountID = a.id;
        
        
        categories = new list<String> {'Paper','Ink Toner','Furniture','CBS','CPD','Tech','Filing & Binding','Labels & Forms','Writing Drafting','Office Essentials','MPS','Miscellaneous'};
            catMap = new Map<String,String> {'Paper' => 'Paper', 'Ink Toner' => 'Ink', 'Furniture' => 'Furniture', 'CBS'=>'CBS','CPD'=>'CPD','Tech'=>'Tech','Filing & Binding' => 'fb',
                                             'Labels & Forms' => 'lf','Writing Drafting'=>'wd','Office Essentials'=>'oe','MPS'=>'MPS','Miscellaneous'=>'misc'};
    }
    
    public void loadData() {
        //AccountID = ApexPages.currentPage().getParameters().get('AccountID'); 
        list<Account_Duplicate_Junction__c> dups = new list<Account_Duplicate_Junction__c>();
        dups = [select id,Account_Dormant_Dup__c,Account_Dup__c,Contact_Dup__c,Lead_Dup__c,Duplicate_Reason__c,Duplicate_Type__c,lead_dup__r.Name,
                       Account_Dormant_Dup__r.AccountExtension__r.name,Account_Dormant_Dup__r.AccountExtension__r.Address1__c,Account_Dormant_Dup__r.AccountExtension__r.Address2__c,Account_Dormant_Dup__r.AccountExtension__r.City__c,
                       Account_Dormant_Dup__r.AccountExtension__r.state__c,Account_Dormant_Dup__r.AccountExtension__r.zip__c,Account_Dormant_Dup__r.AccountExtension__r.aops_cust_id__c,Account_Dormant_Dup__r.AccountExtension__r.Legacy_CreatedDate__c,
                       Account_Dormant_Dup__r.AccountExtension__r.recordtype.developername,Account_Dup__r.aops_cust_id__c,Account_Dup__r.Legacy_CreatedDate__c,
                       Account_Dup__r.recordtype.developername,
                       Account_Dormant_Dup__r.AccountExtension__r.recordtype.name,
                       Account_Dup__r.recordtype.name,
                       lead_dup__r.firstName,lead_dup__r.lastName,Account_dup__r.name,Account_dup__r.Address1__c,
                       Account_dup__r.Address2__c,Account_dup__r.city__c,Account_dup__r.state__c,Account_dup__r.zip__c,
                       lead_dup__r.address1__c,lead_dup__r.address2__c,lead_dup__r.city__c,lead_dup__r.state__c,lead_dup__r.zip__c,
                       Account_Dup__r.oracle_party_id__c,
                       Account_Dup__r.oracle_party_site_id__c,
                       Account_Dup__r.aops_seq_id__c,
                       Account_Dup__r.omx_primary_key__c,
                       Account_Extension_Dup__c,
                       Account_Dormant_Dup__r.AccountExtension__r.Account_Name__c,
                       Account_Dormant_Dup__r.AccountExtension__r.oracle_party_id__c,
                       Account_Dormant_Dup__r.AccountExtension__r.oracle_party_site_id__c,
                       Account_Dormant_Dup__r.AccountExtension__r.aops_seq_id__c,
                       Account_Dormant_Dup__r.AccountExtension__r.omx_primary_key__c,
                       account_master__c,account_master__r.aops_cust_id__c,account_master__r.Legacy_CreatedDate__c,account_master__r.recordtype.name,account_master__r.name,account_master__r.Address1__c,account_master__r.Address2__c,account_master__r.city__c,account_master__r.state__c,account_master__r.zip__c,account_master__r.oracle_party_id__c,account_master__r.oracle_party_site_id__c,account_master__r.aops_seq_id__c,account_master__r.omx_primary_key__c
                                                     from Account_Duplicate_Junction__c
                                                     where account_master__c = :AccountID limit 49000];
        
        if (dups.size() == 0) {
            for (Account_Duplicate_Junction__c dj: [select account_master__c from account_duplicate_junction__c where account_dup__c=:AccountID LIMIT 1]) {
                dups = [select id,Account_Dormant_Dup__c,Account_Dup__c,Contact_Dup__c,Lead_Dup__c,Duplicate_Reason__c,Duplicate_Type__c,lead_dup__r.Name,
                       Account_Dormant_Dup__r.AccountExtension__r.name,Account_Dormant_Dup__r.AccountExtension__r.Address1__c,Account_Dormant_Dup__r.AccountExtension__r.Address2__c,Account_Dormant_Dup__r.AccountExtension__r.City__c,
                       Account_Dormant_Dup__r.AccountExtension__r.state__c,Account_Dormant_Dup__r.AccountExtension__r.zip__c,Account_Dormant_Dup__r.AccountExtension__r.aops_cust_id__c,Account_Dormant_Dup__r.AccountExtension__r.Legacy_CreatedDate__c,
                       Account_Dormant_Dup__r.AccountExtension__r.recordtype.developername,Account_Dup__r.aops_cust_id__c,Account_Dup__r.Legacy_CreatedDate__c,
                       Account_Dup__r.recordtype.developername,
                       Account_Dormant_Dup__r.AccountExtension__r.recordtype.name,
                       Account_Dup__r.recordtype.name,
                       lead_dup__r.firstName,lead_dup__r.lastName,Account_dup__r.name,Account_dup__r.Address1__c,
                       Account_dup__r.Address2__c,Account_dup__r.city__c,Account_dup__r.state__c,Account_dup__r.zip__c,
                       lead_dup__r.address1__c,lead_dup__r.address2__c,lead_dup__r.city__c,lead_dup__r.state__c,lead_dup__r.zip__c,
                       Account_Dup__r.oracle_party_id__c,
                       Account_Dup__r.oracle_party_site_id__c,
                       Account_Dup__r.aops_seq_id__c,
                       Account_Dup__r.omx_primary_key__c,
                       Account_Extension_Dup__c,
                       Account_Dormant_Dup__r.AccountExtension__r.Account_Name__c,
                       Account_Dormant_Dup__r.AccountExtension__r.oracle_party_id__c,
                       Account_Dormant_Dup__r.AccountExtension__r.oracle_party_site_id__c,
                       Account_Dormant_Dup__r.AccountExtension__r.aops_seq_id__c,
                       Account_Dormant_Dup__r.AccountExtension__r.omx_primary_key__c,
                       account_master__c,account_master__r.aops_cust_id__c,account_master__r.Legacy_CreatedDate__c,account_master__r.recordtype.name,account_master__r.name,account_master__r.Address1__c,account_master__r.Address2__c,account_master__r.city__c,account_master__r.state__c,account_master__r.zip__c,account_master__r.oracle_party_id__c,account_master__r.oracle_party_site_id__c,account_master__r.aops_seq_id__c,account_master__r.omx_primary_key__c
                                                     from Account_Duplicate_Junction__c
                                                     where account_master__c = :dj.account_master__c limit 49000];
            }
        }
        
          decimal dormantH=0;
            decimal dormantS=0;
            decimal activeH=0;
            decimal activeS=0;
            decimal leadH=0;
        if (dups.size() > 0) {
          
             
            for (Account_Duplicate_Junction__c dj: dups) {
                if (dj.lead_dup__c != null) {
                    if (leadDuplicateslst.size() <= 20)
                     leadDuplicateslst.add(dj);
                    
                    dormantH++;
                }
                if (dj.account_dup__c != null && (dj.account_dup__r.recordtype.developername=='Customer' || dj.account_dup__r.recordtype.developername=='Customer_OfficeMax' || dj.account_dup__r.recordtype.developername=='Prospect')) {
                    if (activeAcctDuplicatesLstHeaders.size() <= 20)
                      activeAcctDuplicatesLstHeaders.add(dj);
                      
                      activeH++;
                }
                if (dj.account_dup__c != null && (dj.account_dup__r.recordtype.developername=='Site' || dj.account_dup__r.recordtype.developername=='Site_OfficeMax')) {
                    if (activeAcctDuplicatesLstSites.size() <= 20)
                      activeAcctDuplicatesLstSites.add(dj);
                      
                      activeS++;
                }
                    
                if (dj.Account_Dormant_Dup__c != null && (dj.Account_Dormant_Dup__r.AccountExtension__r.recordtype.developername=='Customer' || dj.Account_Dormant_Dup__r.AccountExtension__r.recordtype.developername=='Customer_OfficeMax' || dj.Account_Dormant_Dup__r.AccountExtension__r.recordtype.developername=='Prospect')) {
                    if (dormantAcctDuplicatesLstHeaders.size() <= 20)
                      dormantAcctDuplicatesLstHeaders.add(dj);
                      
                      dormantH++;
                }
                if (dj.Account_Dormant_Dup__c != null && (dj.Account_Dormant_Dup__r.AccountExtension__r.recordtype.developername=='Site' || dj.Account_Dormant_Dup__r.AccountExtension__r.recordtype.developername=='Site_OfficeMax')) {
                    if (dormantAcctDuplicatesLstSites.size() <= 20)
                      dormantAcctDuplicatesLstSites.add(dj);
                      
                      dormantS++;
                }
             }
           /*  for (Account_Duplicate_Junction__c dj:dups) {
                if (dj.account_master__c != null && (dj.account_master__r.recordtype.name=='Customer' || dj.account_master__r.recordtype.name=='Customer (OfficeMax)' || dj.account_master__r.recordtype.name=='Prospect')) {
                    activeAcctDuplicatesLstHeaders.add(dj);
                }
                if (dj.account_master__c != null && (dj.account_master__r.recordtype.name=='Site' || dj.account_master__r.recordtype.name=='Site (OfficeMax)')) {
                    activeAcctDuplicatesLstSites.add(dj);
                }
                break;
             }*/
        }
        
        totalDormantAcctDuplicatesHeaders = dormantH;
        totalDormantAcctDuplicatesSites = dormantS;
        totalActiveAcctDuplicatesHeaders = activeH;
        totalActiveAcctDuplicatesSites = activeS;
        totalLeadDuplicates = leadH;
        
        
        
        // Calculate Total Sales - Starts
        if (activeAcctDuplicatesLstHeaders.size() > 0) {
           list<ID> acctIDs = new list<ID>();
           for (Account_duplicate_junction__c d: activeAcctDuplicatesLstHeaders) {
            if (d.account_dup__c != null)
             acctIDs.add(d.account_dup__c);
           }

            slsDataImpactlstHeaders = calculateRollup(acctIDs,'Acct');
        }
        
        if (activeAcctDuplicatesLstSites.size() > 0) {
           list<ID> siteIDs = new list<ID>();
           for (Account_duplicate_junction__c d: activeAcctDuplicatesLstSites) {
            if (d.account_dup__c != null)
             siteIDs.add(d.account_dup__c);
           }

            slsDataImpactlstHeaders = calculateRollup(siteIDs,'Site');
        }
        // Calculate Total Sales - Ends
        
             
    }
    
    public list<slsDataImpact> calculateRollup (list<ID> acctIDs,String type) {
        
        list<slsDataImpact> slsImpactlst = new list<slsDataImpact>();
        
        AggregateResult[] salesTotal = [select SUM(Total_LY_Sales_to_Date__c) total_sales_ly,
                                                  SUM(Total_TY_Sales_to_Date__c) total_sales_ty,
                                                  SUM(Paper_LY__c) paper_ly,
                                                  SUM(Paper_TY__c) paper_ty,
                                                  SUM(Ink_Toner_TY__c) ink_ty,
                                                  SUM(Ink_Toner_LY__c) ink_ly,
                                                  SUM(Furniture_TY__c) furniture_ty,
                                                  SUM(Furniture_LY__c) furniture_ly,
                                                  SUM(CBS_TY__c) cbs_ty,
                                                  SUM(CBS_LY__c) cbs_ly,
                                                  SUM(CPD_TY__c) cpd_ty,
                                                  SUM(CPD_LY__c) cpd_ly,
                                                  SUM(Tech_TY__c) tech_ty,
                                                  SUM(Tech_LY__c) tech_ly,
                                                  SUM(Filing_Binding_TY__c) fb_ty,
                                                  SUM(Filing_Binding_LY__c) fb_ly,
                                                  SUM(Labels_Forms_TY__c) lf_ty,
                                                  SUM(Labels_Forms_LY__c) lf_ly,
                                                  SUM(Writing_Drafting_TY__c) wd_ty,
                                                  SUM(Writing_Drafting_LY__c) wd_ly,
                                                  SUM(Office_Essentials_TY__c) oe_ty,
                                                  SUM(Office_Essentials_LY__c) oe_ly,
                                                  SUM(MPS_TY__c) mps_ty,
                                                  SUM(MPS_LY__c) mps_ly,
                                                  SUM(Miscellaneous_TY__c) misc_ty,
                                                  SUM(Miscellaneous_LY__c) misc_ly
                                           FROM ACCOUNT where id=:acctIDs] ;
            
            
            for (String s:categories) {
                slsDataImpact simpact = new slsDataImpact();
                simpact.category=s;
                simpact.TYSales=(decimal)salesTotal[0].get(catMap.get(s)+'_ty');
                simpact.LYSales=(decimal)salesTotal[0].get(catMap.get(s)+'_ly');
                
                if (type == 'Acct' && simpact.LYSales != null && simpact.TYSales != null) {
                    totalLYSalesHeaders=totalLYSalesHeaders+simpact.LYSales;
                    totalTYSalesHeaders=totalTYSalesHeaders+simpact.TYSales;
                }
                 else if (type == 'Site' && simpact.LYSales != null && simpact.TYSales != null) {
                    totalLYSalesSites=totalLYSalesSites+simpact.LYSales;
                    totalTYSalesSites=totalTYSalesSites+simpact.TYSales;
                }
                
                
                slsImpactlst.add(simpact);
            }
        
            return slsImpactlst;
    }

}