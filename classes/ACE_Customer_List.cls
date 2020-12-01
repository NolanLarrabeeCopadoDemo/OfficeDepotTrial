public class ACE_Customer_List
{
    public Boolean RenderRep{get;set;}//Added for "All Impacted Customers View" enhancement
    public String OwnerValue { get; set; }
    public String pageParam{get;set;}
    public String compParam{get;set;}
    public String SearchText { get; set; }
    public String searchWord{get;set;}
    public String batch{get;set;}
    public String expLabel{get;set;} 
    public String SectionTitle{get;set;}
    public List<custListTable> clsCusListTable{get;set;}
    public List<ACE_Customer_Price_Changes__c> custPricechangeList;
    public List<ACE_Customer_Price_Changes__c> custPricechangeList0;
    public List<Ace_Customer_Core_Changes__c> coreList;
    public String status{get;set;}
    public Decimal TotCore{get;set;}    
    public Decimal TotSKU{get;set;}
    public Integer List_size = 30;
    public Integer total_size{get;set;}
    public Integer skuList_size = 10;
    public Integer skutotal_size{get;set;}
    public Integer counter;     
    public Integer skucounter;  
    public Set<ID> passSelected{get;set;}
    public Set<ID> passNotifySelected{get;set;}
    public Set<ID> passRelSelected{get;set;}
    public Boolean hasSelAcct{get;set;}
    public Integer selectedCount{get;set;}
    public Boolean CHECKALL{get;set;}
    public String checkHeader{get;set;}
    public String expandLabel{get;set;}
    public Boolean renderTable{get;set;}
    public Boolean renderPBTable{get;set;}
    public AceReleaseCommon acerel {get;set;}
    public String AnnSpndChnge{get;set;}
    public Decimal perIncrease{get;set;}
    public String SRMImpTotal{get;set;}
    public Boolean tabAsc{get;set;}
    public String fieldName;
    public String sortDirection ;
    public String getFieldName{get;set;}
    list<AceReleaseCommon.releaseResponse> relrespList {get;set;}
    list<AceReleaseCommon.releaseResponse> notrespList {get;set;}
    public String AccessLevel {get;set;}
    public list<ace_customer_sku_changes__c> aceSkus {get;set;}
    public String selectedCustomerName {get;set;}
    public String skuFilterSelection {get;set;}
    public ID selectedCustomer {get;set;}
    public ID selectedCustomer1 {get;set;}
    
    public Boolean RenderIGM{get;set;}
    public Boolean IsRemedy {get;set;}
    public Boolean IsHosted {get;set;}
    public string fileNameRem{get;set;}
    public string fileNameHost{get;set;}
    public Boolean renderErr{get;set;}
    //public string fileToUpload{get;set;}
    public Blob contentFile{get;set;}
     public Blob content{get;set;}
    String[] filelines = new String[]{};
    List<Ace_Customer_SKU_Changes__c> PriceToUpload;
    public Boolean custUploadRender {get;set;}
    public ID selected_Customer {get;set;}
    //public String AccessLevel {get;set;}
    //public Boolean IsRemedy{get;set;}
    
    public ACE_Customer_List() {
       
        RenderRep = false;//Added for "All Impacted Customers View" enhancement
        RenderIGM = false;
        //Set AccessLevel - Starts
          AccessLevel = 'GENERAL';
          
          For (Group g : [select id,name from group where name in ('Remediation Team')]) 
             for (groupMember gm : [SELECT id from groupmember where groupid = :g.id and UserOrGroupId = :userinfo.getUserId()]) {
                AccessLevel = 'REMEDIATION'; 
                IsRemedy = true; 
                IsHosted = false;                
             }
                
                
          For (Group g : [select id,name from group where name in ('Hosted Catalog Team')]) 
             for (groupMember gm : [SELECT id from groupmember where groupid = :g.id and UserOrGroupId = :userinfo.getUserId()]) {
                AccessLevel = 'HOSTED'; 
                IsHosted = true; 
                IsRemedy = false;
             }
                

        // Set AccessLevel - Ends
        
        //Added by Guha - IGM Gross column render logic based on current logged in user short title
        User u = [select id,short_title__c from user where id=:UserInfo.getUserId()];
        String ShortTitle = u.short_title__c;
        
        ACE_Settings__c cs = [select id,Level1Access__c,Level2Access__c,Level3Access__c from ACE_Settings__c limit 1];
        String level1 = cs.Level1Access__c;
        String level2 = cs.Level2Access__c;
        String level3 = cs.Level3Access__c;
        
        if(ShortTitle !=null || ShortTitle== '') {
            if (cs.Level2Access__c != null) 
                if (cs.Level2Access__c.contains(ShortTitle))
                    RenderIGM = true;

            if (cs.Level3Access__c != null && !RenderIGM)
                if (cs.Level3Access__c.contains(ShortTitle))
                    RenderIGM = true;
    
        }                                  
        //code by Guha ends
        
        renderErr = false;
        custUploadRender = false;
        getFieldName = 'srmimpact';
        tabAsc = true;
        sortDirection = 'ASC';
        fieldName = 'SRM_Differential__c';
        searchWord = ApexPages.currentPage().getParameters().get('searchWord');
        counter = 0;  
        skucounter = 0;      
        passSelected = new Set<ID>();
        passNotifySelected  = new Set<ID>();
        passRelSelected = new Set<ID>();
        acerel = new AceReleaseCommon();
        relrespList = new list<AceReleaseCommon.releaseResponse>();
        notrespList = new list<AceReleaseCommon.releaseResponse>();
        expandLabel = '[+] No Requirements';
        selectedCount = 0;
        CHECKALL = false;
        renderTable = false;
        renderPBTable = false;
        checkHeader = 'Check All';
        getURL();        
        
        AggregateResult[] results = [SELECT SUM(SRM_Differential__c) summary,SUM(Item_12_Month_Qty__c) annspnd,SUM(Total_Spend_Impact_12_Month__c) aschnge FROM ACE_Customer_Price_Changes__c where PRICE_NOT_CALCULATED__C = false AND SFDC_Notification_Flag__c = '1' AND Name =:batch];        
        AnnSpndChnge= String.ValueOf(results[0].get('aschnge'));       
        ////Defect Reported by TCOE...Fixed by Madhavi
        if(Integer.ValueOf(results[0].get('aschnge')) != 0)
        	perIncrease = Integer.ValueOf(results[0].get('annspnd'))/Integer.ValueOf(results[0].get('aschnge')) ;
		else
            perIncrease = 0;
        ///Defect Reported by TCOE...Fixed by Madhavi
        SRMImpTotal = String.ValueOf(results[0].get('summary'));
        
        
        
    }
    public void renderUpload(){
        //custUploadRender = true;
        system.debug('>>>>>>>>');
        if (ApexPages.currentPage().getParameters().get('selectedCustomer') != null){
          system.debug('>>>>>>>>'+ApexPages.currentPage().getParameters().get('selectedCustomer'));
          selectedCustomer = ApexPages.currentPage().getParameters().get('selectedCustomer'); 
          custUploadRender = true;          
        }
        //if (ApexPages.currentPage().getParameters().get('selectedCustomerName') != null)
          //selectedCustomerName = ApexPages.currentPage().getParameters().get('selectedCustomerName');
        //aceSkus.clear();
        //return null;
    }
    public void findskus() {
        custUploadRender = false;
        if (ApexPages.currentPage().getParameters().get('selectedCustomer') != null)
          selectedCustomer = ApexPages.currentPage().getParameters().get('selectedCustomer');
        if (ApexPages.currentPage().getParameters().get('selectedCustomerName') != null)
          selectedCustomerName = ApexPages.currentPage().getParameters().get('selectedCustomerName');
        String q = 'select SKU__c,Current_Sell_Price__c,Approved_Proposed_Price__c,Sales_Price_Change_Effective_Date_Approv__c,SKU_Description__c,CoreList_ID__c,Remediation_Hold__c,HostedCatalog_Hold__c from ace_customer_sku_changes__c where ace_customer_core_changes__r.ace_customer_price_changes__r.id=\'' + selectedCustomer + '\'';
        skutotal_size = null;
        
        if (AccessLevel == 'REMEDIATION') {
         if ('Verified'.equals(skuFilterSelection)) {
          q = q + ' and Remediation_Hold__c = false';
          skutotal_size = [select count() from ace_customer_sku_changes__c where ace_customer_core_changes__r.ace_customer_price_changes__r.id= :selectedCustomer and price_not_calculated__c = false and Remediation_Hold__c = false];
         }
         else if ('NotVerified'.equals(skuFilterSelection)){
          q = q + ' and Remediation_Hold__c = true';
          skutotal_size = [select count() from ace_customer_sku_changes__c where ace_customer_core_changes__r.ace_customer_price_changes__r.id= :selectedCustomer and price_not_calculated__c = false and Remediation_Hold__c = true];
         }
        }
        else if (AccessLevel == 'HOSTED') {
         if ('Verified'.equals(skuFilterSelection)) {
          q = q + ' and HostedCatalog_Hold__c = false';
          skutotal_size = [select count() from ace_customer_sku_changes__c where ace_customer_core_changes__r.ace_customer_price_changes__r.id= :selectedCustomer and price_not_calculated__c = false and HostedCatalog_Hold__c = false];
         }
         else if ('NotVerified'.equals(skuFilterSelection)) {
          q = q + ' and HostedCatalog_Hold__c = true';
          skutotal_size = [select count() from ace_customer_sku_changes__c where ace_customer_core_changes__r.ace_customer_price_changes__r.id= :selectedCustomer and price_not_calculated__c = false and HostedCatalog_Hold__c = true];
         }
        }
        aceSkus = database.query(q + ' limit 10 offset :skucounter'); 
        if(skutotal_size == null)
         skutotal_size = [select count() from ace_customer_sku_changes__c where ace_customer_core_changes__r.ace_customer_price_changes__r.id= :selectedCustomer and price_not_calculated__c = false];
        
    }
    
    public PageReference SearchRecords() 
    {   counter = 0; 
        getURL();
        return null;
    }
    public void sortCust() {
        if(getFieldName == 'Customer'){
            fieldName = 'Customer__r.name';}
        else if(getFieldName == 'Cores'){
            fieldName = 'Corecount__c';}
        else if(getFieldName == 'SKU'){
            fieldName = 'SKUcount__c';}
        
        else if(getFieldName == 'annualspend'){
            fieldName = 'Item_12_Month_Qty__c';}
        else if(getFieldName == 'annualspndchange'){
            fieldName = 'Total_Spend_Impact_12_Month__c';}
        
        else if(getFieldName == 'srmimpact'){
            fieldName = 'SRM_Differential__c';}
        else if(getFieldName == 'effectiveDate'){
            fieldName = 'Sales_Price_Change_Effective_Date_Approv__c';}
        else if(getFieldName == 'notifydate'){
            fieldName = 'Customer_Notification_Date_Approved__c';}
        else if(getFieldName == 'customerid'){
            fieldName = 'Owning_Customer_ID__c';}
        else if(getFieldName == 'notifStatus'){
            fieldName = 'Notification_Status3__c';}
        else if(getFieldName == 'pricechangestatus'){
            fieldName = 'Implementation_Status3__c';}
        else if(getFieldName == 'sfdcBucket'){
            fieldName = 'SFDC_Notification_Flag__c';}
        else if(getFieldName == 'NoOfSKUGovernedByActiveWrittenAgreement'){
            fieldName = 'NoOfSKUGovernedByActiveWrittenAgreement__c';}
        else if(getFieldName == 'Reps'){
            fieldName = 'Customer__r.Owner.Name';}
            
            
        //Add. sorting for 00826597
        if(tabAsc){
            sortDirection = 'DESC';
           // fieldName = 'Customer__r.name';
            tabAsc = false;            
        }
        else {
            sortDirection = 'ASC';
          //  fieldName = 'Customer__r.name';
            tabAsc = true;             
        }  
        getURL();  
    }
    public void getURL(){
            String nullsLast = ' nulls last'; //00826597
            
            if (sortDirection == 'ASC')
            {
                nullsLast = '';
            }
            system.debug('^^^^^^^^^^^'+pageParam);        
            SectionTitle = 'Customer List';
            //pageParam = '1';
            batch= ApexPages.currentPage().getParameters().get('batch');            
            //expLabel= ApexPages.currentPage().getParameters().get('expLabel');           
            clsCusListTable = new List<custListTable>();
            List<ACE_Customer_Price_Changes__c> custPricechangeList = new List<ACE_Customer_Price_Changes__c>();
                           
            
            // Heirarchy code
            
            List<User> userList = new List<User>();
            ACE_User_Cust_Hierarchy_Controller obj = new ACE_User_Cust_Hierarchy_Controller();
            UserList = obj.lUserList;
            system.debug('ownerlist:' + UserList);
            Set<ID> ownerList = new Set<ID>();
            for(User u : UserList)
            {
                ownerList.add(u.id);
            }
            
            // Code to handle owner value picklist
            if(OwnerValue == 'All')
            {
                RenderRep = true;//Added for "All Impacted Customers View" enhancement
                ownerList.add(UserInfo.getUserId());    
            }
            else if(OwnerValue == 'Owned by me')
            {
                RenderRep = false;//Added for "All Impacted Customers View" enhancement
                ownerList = new Set<ID>();
                ownerList.add(UserInfo.getUserId());    
            }
             else if (OwnerValue == 'Owned by others' || OwnerValue == 'Owned by my team')
            {
                RenderRep = true;//Added for "All Impacted Customers View" enhancement
                ownerList.remove(UserInfo.getUserId());
            }
            else
            {
                ownerList = new Set<ID>();
                ownerList.add(UserInfo.getUserId());
            }    
            
            Set<ID> sID_ACE_Price_ID = new Set<ID>();
            sID_ACE_Price_ID = obj.CustomerPriceChangeRecs(ownerList,OwnerValue,batch);
            system.debug('Total Customers To Collect:' + sID_ACE_Price_ID.size());
                
            
            // Heirarchy code ends here
            
            
            
            //Changed queryString for 00826584 
           System.debug('Value of Search Txt' +  searchText );
           String selectText = 'select id,customer_notification_date__c,Remedy_Status__c,Owning_Customer_ID__c,Record_Lock__c, Name,HostedCatalog_Hold__c,Remediation_Hold__c,Sales_Price_Change_Effective_Date_Min__c ,Customer__r.name,IsRemediation__c,Hosted_Catalog__c,customer__r.ownerid,Customer__r.Owner.Name,Customer__r.remediation_required__c,Customer__r.id,Item_12_Month_Qty__c,Item_12_Month_Sales__c,Total_Spend_Impact_12_Month__c,SRM_Differential__c,sfdc_notification_flag__c,Exception_Date_Lock__c,Notification_Status__c,Implementation_Status__c,Implementation_Status3__c,implementation_status_code__c,Implementation_Status_Image__c,Notification_Status_Image__c,Notification_Status3__c,requirement_window__c,Sales_Price_Change_Effective_Date_Rep__c,Sales_Price_Change_Effective_Date__c, Sales_Price_Change_Effective_Date_Approv__c, Customer_Notification_Date_Approved__c,Corecount__c,New_Gross_IGM__c,New_Gross_IGM1__c, SKU_Count__c,price_not_calculated__c,Account_Extension__r.Sector__c,customer__R.owner.System_User__c,NoOfSKUGovernedByActiveWrittenAgreement__c from ACE_Customer_Price_Changes__c';
           String queryString = selectText + ' WHERE ID = \'XXXXXXXXXXXXXXXXXX\'';
            if((searchText != null) && (searchText != '') && (searchText != 'null'))
            {      
                
                String textToSearch = searchText.trim() + '%';
                
                if ('GENERAL'.equals(accesslevel)) {
                 queryString = selectText + ' where (Customer__r.name like :textToSearch OR Customer__r.AOPS_Cust_Id__c LIKE :textToSearch) AND price_not_calculated__c = false and Name =:batch AND id in: sID_ACE_Price_ID';
                 total_size = [select count() from ACE_Customer_Price_Changes__c where (Customer__r.name like :textToSearch OR Customer__r.AOPS_Cust_Id__c LIKE :textToSearch) and price_not_calculated__c = false and  Name= :Batch AND id in: sID_ACE_Price_ID];
                }
                else if ('REMEDIATION'.equals(accesslevel)) {
                 if (OwnerValue == 'PendingApproval')
                  queryString = selectText + ' where (Customer__r.name like :textToSearch OR Customer__r.AOPS_Cust_Id__c LIKE :textToSearch) AND price_not_calculated__c = false and Name =:batch AND remedy_status__c = \'Pending\'';
                 else
                  queryString = selectText + ' where (Customer__r.name like :textToSearch OR Customer__r.AOPS_Cust_Id__c LIKE :textToSearch)  and Name =:batch AND (IsRemediation__c = true OR remedy_status__c = \'Pending\' OR price_not_calculated__c = TRUE)';
                  total_size = [select count() from ACE_Customer_Price_Changes__c where (Customer__r.name like :textToSearch OR Customer__r.AOPS_Cust_Id__c LIKE :textToSearch) and  Name= :Batch AND (IsRemediation__c = true OR remedy_status__c = 'Pending' OR price_not_calculated__c = TRUE)];
                }
                else if ('HOSTED'.equals(accesslevel)) {
                 queryString = selectText + ' where (Customer__r.name like :textToSearch OR Customer__r.AOPS_Cust_Id__c LIKE :textToSearch) AND price_not_calculated__c = false and Name =:batch AND Hosted_Catalog__c = true';
                 total_size = [select count() from ACE_Customer_Price_Changes__c where (Customer__r.name like :textToSearch OR Customer__r.AOPS_Cust_Id__c LIKE :textToSearch) and price_not_calculated__c = false and  Name= :Batch AND Hosted_Catalog__c = true];
                }
                system.Debug(' Query String:' + queryString);
                if(fieldName =='Notification_Status3__c' || fieldName =='Customer_Notification_Date_Approved__c' )
                {
                    sortDirection += nullsLast;
                }
                custPricechangeList = Database.query(queryString + ' order by '+fieldName+' '+sortDirection +' limit 10 offset :counter');                                           
                
            }
            else
            {
                if ('GENERAL'.equals(accesslevel)) {
                 queryString = selectText + ' where price_not_calculated__c = false and NAME=\'' +  batch + '\' AND id in: sID_ACE_Price_ID';
                 total_size = [select count() from ACE_Customer_Price_Changes__c where Name= :Batch and id in: sID_ACE_Price_ID and price_not_calculated__c = false];
                }
                else if ('REMEDIATION'.equals(accesslevel)) {
                 if (OwnerValue == 'PendingApproval')
                  queryString = selectText + ' where NAME=\'' +  batch + '\' AND remedy_status__c = \'Pending\' and price_not_calculated__c = false';
                 else
                  queryString = selectText + ' where NAME=\'' +  batch + '\' and (IsRemediation__c = true OR remedy_status__c = \'Pending\' OR price_not_calculated__c = TRUE)';
                  total_size = [select count() from ACE_Customer_Price_Changes__c where Name= :Batch and (IsRemediation__c = true OR remedy_status__c = 'Pending' OR price_not_calculated__c = TRUE)];
                }
                else if ('HOSTED'.equals(accesslevel)) {
                 queryString = selectText + ' where price_not_calculated__c = false and NAME=\'' +  batch + '\' AND Hosted_Catalog__c = true';
                 total_size = [select count() from ACE_Customer_Price_Changes__c where price_not_calculated__c = false and Name= :Batch AND Hosted_Catalog__c = true];
                }
                system.Debug(' Query String:' + queryString);
                //Forcing nulls last on some sorts 00826597
                if(fieldName =='Notification_Status3__c' || fieldName =='Customer_Notification_Date_Approved__c' )
                {
                    sortDirection += nullsLast;
                }
                custPricechangeList = Database.query(queryString + ' ORDER BY '+fieldName+' '+sortDirection + ' limit 30 offset :counter'); 
                
            }
            //Mappings needed for  additional columns on REMEDIATION screen 00826584 
            list<id> cusIDs = new list<id>();
            for(ACE_Customer_Price_Changes__c cus: custPricechangeList){
                cusIDs.add(cus.id);
            }
            
            map<id,case> idWrfCaseMap = new Map<id,case>();
           
            
            for(case iCaseList:[select id,Customer_Core_Price_Changes__c from case where Customer_Core_Price_Changes__c in :cusIDs])
            {
                 idWrfCaseMap.put(iCaseList.Customer_Core_Price_Changes__c, iCaseList);                 
            }
            
            list<id> wrfIDs = new list<id>();
            for(Case cases: idWrfCaseMap.values()) {
                wrfIDs.add(cases.id);
            }
            
            //List of WRFTasks
            List<WRF_Task__c> wrfTaskList = new List<WRF_Task__c>();
            wrfTaskList = [select id,Status__c,Assigned_To_Name__c,WRF__c,Disposition_Code__c from WRF_Task__c where WRF__c  in :wrfIDs];
            
            
            
            system.debug('&&&&&&&&&&'+total_size);
            TotCore = 0;
            TotSKU = 0;
            for(ACE_Customer_Price_Changes__c cus: custPricechangeList){
                
                custListTable c = new custListTable();
                //c.CORES = 0;
                c.ts = cus;
                c.ID = cus.id;
                c.NAME = cus.Name;
                c.CUSTOMER = cus.Customer__r.name;
                c.CORES = cus.Corecount__c;
                TotCore = TotCore + c.CORES;
                c.IMPSTATUSCODE = cus.implementation_status_code__c;
                c.IMPSTATUSIMG = cus.Implementation_Status_Image__c;
                
                c.ANNUALSPEND = cus.Item_12_Month_Qty__c;
                c.ANNSPEND_CHNGEAMNT = cus.Total_Spend_Impact_12_Month__c;
                c.SRMIMPACT = cus.SRM_Differential__c;
                // below if loop is added by guha
                if(cus.New_Gross_IGM__c != null && cus.New_Gross_IGM1__c != null){
                    c.NEWIGMDOLLAR = cus.New_Gross_IGM__c;
                    c.NEWIGMPERCENT = cus.New_Gross_IGM1__c;
                }
                else{
                    c.NEWIGMDOLLAR = 0;
                    c.NEWIGMPERCENT = 0;
                }
                
                c.IMPSTATUS = cus.Implementation_Status3__c; 
                c.NOTSTATUS = cus.Notification_Status__c;
                c.NoOfSKUGovernedByActiveWrittenAgreement = cus.NoOfSKUGovernedByActiveWrittenAgreement__c;
                system.debug('&&&&&&&&&&'+cus.NoOfSKUGovernedByActiveWrittenAgreement__c); //mm
                c.APPROVDDATE = cus.Sales_Price_Change_Effective_Date_Approv__c;
                c.NOTIFYDATE = cus.Customer_Notification_Date_Approved__c;
                //c.TOTCORE = TotCore;
                c.OWNERNAME = cus.Customer__r.Owner.Name;//Added for "All Impacted Customers View " enhancement
                c.ISRELEASEALLOWED = acerel.ReleaseAllowed(cus,Date.Today());
                c.isRemediation = cus.IsRemediation__c;
                c.priceNotCalculated = cus.price_not_calculated__c;
                c.isHosted = cus.Hosted_Catalog__c;
                c.hostedCatalogHold = cus.HostedCatalog_Hold__c;
                c.remediationHold = cus.Remediation_Hold__c;
                c.CustomerNumber = cus.Owning_Customer_ID__c;
                //List<Ace_Customer_Core_Changes__c> coreList= new List<Ace_Customer_Core_Changes__c>();
                //coreList= [select Name,SKUcount__c from Ace_Customer_Core_Changes__c where ACE_Customer_Price_Changes__c =:cus.id];     
                c.SKUs = cus.SKU_Count__c;       
                //for(Ace_Customer_Core_Changes__c cor: coreList){
                //    c.SKUS = c.SKUs + cor.SKUcount__c;
                //    
                //    TotSKU = TotSKU + c.SKUS;
                //}
                c.RELCHECK= false;
                c.NOTCHECK= false;
                c.isCustomerOwnerSystemUser = cus.customer__R.owner.System_User__c;
                if(!passNotifySelected.isEmpty()){
                    if(passNotifySelected.contains(c.ID))
                        c.NOTCHECK= true;
                    else 
                        c.NOTCHECK= false;
                }
                
                if(!passRelSelected.isEmpty()){
                    if(passRelSelected.contains(c.ID))
                        c.RELCHECK= true;
                    else 
                        c.RELCHECK= false; 
                }
                
                //Addtional generation for 00826584 and 
                if(c.ts.SFDC_Notification_Flag__c == '1')
                {
                	c.sfdcBucket = 'No Req.';
                }
                else if(c.ts.SFDC_Notification_Flag__c == '2')
                {
                	c.sfdcBucket = 'Notification Req.';
                }
                else if(c.ts.SFDC_Notification_Flag__c == '3')
                {
                	c.sfdcBucket = 'Approval Req.';
                }
                
                //Request Type status for Remed users 00826584 
                if (c.isRemediation == true) c.requestType = 'Remediation';
                else if (c.priceNotCalculated == true && c.isRemediation == false) c.requestType = 'Compliance';
                else  c.requestType = 'Other';
                
                //Retreving WRF Infomation fo remed users 00826584 
               if(idWrfCaseMap.get(cus.id) != null)
                {
                    Case iCase = idWrfCaseMap.get(cus.id);
                    if(iCase.id != null)
                    {
                        c.wrfID = iCase.id;
                    }
                }
               
                
                //Check Compliance Task Status  00826584
                if(c.requestType == 'Compliance')
                {
                    for(WRF_Task__c iTaskList:wrfTaskList)
                    {
                        if(iTaskList.Disposition_Code__c == 'Remediation' && iTaskList.WRF__c == c.wrfID)
                        {
                            c.remedationTaskAssignee = iTaskList.Assigned_To_Name__c;
                            if(c.remedationTaskAssignee == null)
                            {
                                c.remedationTaskAssignee = 'Not assigned';
                            }
                        }
                        
                        if(iTaskList.Disposition_Code__c == 'Lifecycle' && iTaskList.WRF__c == c.wrfID)
                        {
                            if(iTaskList.Status__c == 'Completed')
                            {
                                c.complianceWrfTaskClosed = 'Yes';
                            }
                            else
                            c.complianceWrfTaskClosed = 'No';
                            
                            	
                        }
                        
                    }
                }
                else
                {
                    
                    for(WRF_Task__c iTaskList:wrfTaskList)
                    {
                        if(iTaskList.Disposition_Code__c == 'Remediation' && iTaskList.WRF__c == c.wrfID)
                        {
                            c.remedationTaskAssignee = iTaskList.Assigned_To_Name__c;
                            if(c.remedationTaskAssignee == null)
                            {
                                c.remedationTaskAssignee = 'Not assigned';
                            }
                        }
                    }
                    
                    c.complianceWrfTaskClosed = '';
                }
                
                c.segment = cus.Account_Extension__r.Sector__c;
                //Additiona for 00826597 and 00826584 end
                if((cus.Total_Spend_Impact_12_Month__c!=null && cus.Total_Spend_Impact_12_Month__c!=0.00) && (cus.Item_12_Month_Sales__c!=null && cus.Item_12_Month_Sales__c!=0.00))
                            c.AVGCHANGE = ((cus.Total_Spend_Impact_12_Month__c/cus.Item_12_Month_Sales__c)*100).setScale(2);  
                        else
                            c.AVGCHANGE = 0.00;
                
                if((cus.Total_Spend_Impact_12_Month__c!=null && cus.Total_Spend_Impact_12_Month__c!=0.00) && (cus.Item_12_Month_Qty__c!=null && cus.Item_12_Month_Qty__c!=0.00))                  
                        c.SPNDIMPACT = (cus.Total_Spend_Impact_12_Month__c/cus.Item_12_Month_Qty__c).setScale(2);
                else
                        c.SPNDIMPACT = 0.00;
                
                if((cus.Remedy_Status__c != null && cus.Remedy_Status__c != '' && cus.Remedy_Status__c == 'Approved' && cus.Remediation_Hold__c == true) || (cus.customer__r.remediation_required__c = true && cus.Remediation_Hold__c == true))
                    c.ShowUD = 'Approved';
                // else if(cus.Remedy_Status__c != null && cus.Remedy_Status__c != '' && cus.Remedy_Status__c == 'Rejected')
                //     c.ShowUD = 'Rejected';
                else if(cus.Remedy_Status__c == 'Pending')
                    c.showUD = 'Gen';    
                
                
                
                if(cus.Remedy_Status__c == null)
                    cus.Remedy_Status__c ='';
                
                //Filters for 00826584 
                if(cus.Remedy_Status__c != 'Rejected')
                {
                    if(OwnerValue != 'Active' && OwnerValue != 'Unassigned')
                    {
                        clsCusListTable.add(c);
                    }
                    else if (OwnerValue == 'Active')
                    {
                        if(c.IMPSTATUSCODE != 'DATA-SUCCESS')
                        {
                            clsCusListTable.add(c);
                        }
                    }
                    else if (OwnerValue == 'Unassigned')
                    {
                        if(c.isCustomerOwnerSystemUser == True)
                        {
                            clsCusListTable.add(c);
                        }
                    }
                    else
                    {
                       clsCusListTable.add(c); 
                    }
                }
            }
        
        
       
                  
    }
    
    public PageReference releaseEarly() {
        
        System.debug('>>>>>>>>>>>>>>>>>>>>In Release Early>>>>>');
        renderErr = false;
        Set<AceReleaseCommon.releaseRequest> relreqList = new Set<AceReleaseCommon.releaseRequest>();
        Set<AceReleaseCommon.releaseRequest> notreqList = new Set<AceReleaseCommon.releaseRequest>();//
        list<ace_customer_price_changes__c> acpcUpd = new list<ace_customer_price_changes__c> ();
        
        //Reconstruct the Selection Set, this is required for the list of records that the Rep is currently viewing
        for (custListTable c: clsCusListTable) {
            if (c.RELCHECK)
               passRelSelected.add(c.ID);
            //if (c.NOTCHECK)// by guha
               //passNotifySelected.add(c.ID);// by guha
        }
        if(passRelSelected.size()>0){ //by guha       
            For (ace_customer_price_changes__c a: [SELECT ID,customer__r.ownerid,Record_Lock__c,requirement_window__c,Sales_Price_Change_Effective_Date_Min__c ,sfdc_notification_flag__c,Sales_Price_Change_Effective_Date_Rep__c from ace_customer_price_changes__c where ID = :passRelSelected]) {
                a.Sales_Price_Change_Effective_Date_Rep__c = Date.Today();
                AceReleaseCommon.releaseRequest relreq = new  AceReleaseCommon.releaseRequest();
                relreq.acp = a;
                relreqList.add(relreq);
            }
        
            /* by guha
            For (ace_customer_price_changes__c a: [SELECT ID,Record_Lock__c,requirement_window__c,Sales_Price_Change_Effective_Date_Min__c ,Sales_Price_Change_Effective_Date_Rep__c from ace_customer_price_changes__c where ID = :passNotifySelected]) {
                //a.Sales_Price_Change_Effective_Date_Rep__c = Date.Today();
                AceReleaseCommon.releaseRequest notreq = new  AceReleaseCommon.releaseRequest();
                notreq.acp = a;
                notreqList.add(notreq);
            }
            */
            
            //commented to avoid accidental release while testing.
            relrespList = acerel.Release(relreqList);  
            notrespList = acerel.Notify(notreqList);//
            
            system.debug('@@@@relrespList@@@@@'+relrespList);
            system.debug('@@@@notrespList@@@@@'+notrespList);
            passRelSelected.clear();
            //passNotifySelected.clear(); by guha
            getURL();
        }
        else{
            renderErr = true;
            system.debug('@@@@renderErr@@@@@'+renderErr);
        }
        
        return null;
        
    }
    
    
    
    
    
    public void processSelected(){     
        selectedCount = 0;   //
               system.debug('>>>>>>>>>');
                    
          for(custListTable cWrapper : clsCusListTable){ 
               //system.debug('>>>>>>>>>84'+cWrapper.RELCHECK);                        
               if(cWrapper.NOTCHECK){                   
                    passNotifySelected.add(cWrapper.ID);                    
                    system.debug('>>>>>>>>>'+passNotifySelected);
               }
               else if(passNotifySelected.contains(cWrapper.ID)){
                   passNotifySelected.remove(cWrapper.ID);
               }
               if(cWrapper.RELCHECK){                   
                    passRelSelected.add(cWrapper.ID);                    
                    system.debug('<<<<<<<<<<'+passRelSelected);
               }
               else if(passRelSelected.contains(cWrapper.ID)){
                   passRelSelected.remove(cWrapper.ID);
               }
               
              
          }
          
          
     }
     
    public String RecSel{get;set;} 
    public PageReference ApproveRec()
    {     
        System.debug('value of customer id' + RecSel);
        PageReference p = new PageReference('/apex/ACE_Customer_List_Page?batch=' + batch);
        List<ACE_Customer_Price_Changes__c> updRecs = new List<ACE_Customer_Price_Changes__c>();
        ace_customer_price_changes__c ap = new ace_customer_price_changes__c (ID = RecSel);
        List<ID> RemedyList = new List<ID>();
        for(custListTable cWrapper : clsCusListTable)
          { 
               if(cWrapper.ts.id == RecSel)
               {                   
                    cWrapper.ShowUD = 'Approved';
                    cWrapper.ts.Remedy_Status__c = 'Approved';
                    cWrapper.ts.isRemediation__c = true;
                    cWrapper.ts.Remediation_Hold__c = true;
                    cWrapper.ts.RemedyResp_User__c = UserInfo.getUserId();
                    updRecs.add(cWrapper.ts);
                    RemedyList.add(cWrapper.ts.id);
               }
           }
           
         if( updRecs  != null)
            update updRecs;
         //added by guha - Remediation WRF case creation.
         if(RemedyList.size() > 0){
             ACEWRFCreation wrfCr = new ACEWRFCreation();
             wrfCr.createWRF(RemedyList,'SFDC Price Change - Remediation');
         }
        
        list<ace_customer_sku_changes__c> skuList = new list<ace_customer_sku_changes__c> ();
       /* for (ace_customer_sku_changes__c s: [select id,remediation_hold__c from ace_customer_sku_changes__c where ace_customer_core_changes__r.ace_customer_price_changes__r.id = :RecSel]) {
            s.remediation_hold__c = true;
            skulist.add(s);
        }*/
          if (skulist.size() > 0)
            update skulist;
        
         p.setRedirect(true);    
         //getURL();  
         return p;
     }
     
     public PageReference RejectRec()
    {     
system.debug('&&&&&&&'+RecSel);      
        List<ACE_Customer_Price_Changes__c> updRecs = new List<ACE_Customer_Price_Changes__c>();
        PageReference p = new PageReference('/apex/ACE_Customer_List_Page?batch=' + batch);
        for(custListTable cWrapper : clsCusListTable)
          { 
               if(cWrapper.ts.id == RecSel)
               {                   
                    cWrapper.ShowUD = 'Rejected';
                    cWrapper.ts.Remedy_Status__c = 'Rejected';
                    cWrapper.ts.isRemediation__c = false;
                    cWrapper.ts.Remediation_Hold__c = false;
                    cWrapper.ts.RemedyResp_User__c = UserInfo.getUserId();
                     updRecs.add(cWrapper.ts);
               }
           }
           
           if( updRecs  != null)
               update updRecs;
               //getURL();
           return p;
        
     }  
   
    public void nextPage(){
        counter = counter+List_size; 
          
        processSelected();//             
        getURL();
        
    }
    public void prevPage(){
        counter = counter-List_size;
        
        processSelected();//                
        getURL();
        
    }
    
    
    public void SkunextPage(){
        skucounter = skucounter+skuList_size; 
        findskus();    
    }
    public void SkuprevPage(){
        skucounter = skucounter-skuList_size;
        findskus();
    }
    
    public Boolean getDisablePrevious() {
     
      if (counter>0) return true; else return false;
    }
    public Boolean getDisableNext() { 
      if (counter + list_size < total_size) return true; else return false;
   }
   
   public Boolean getskuDisablePrevious() {
     
      if (skucounter>0) return true; else return false;
    }
    public Boolean getskuDisableNext() { 
      system.debug('SKU Counter:' + skucounter);
      system.debug('SKU List Size:' + skulist_size);
      system.debug('SKU Total:' + skutotal_size);
      if (skucounter + skulist_size < skutotal_size) return true; else return false;
   }
    
   
    
    public class custListTable  {
        public ACE_Customer_Price_Changes__c  ts{get;set;}
        public Id ID{get;set;}
        public String NAME{get;set;}
        public String CUSTOMER{get;set;}
        public String CustomerNumber {get;set;}
        public Decimal CORES{get;set;}
        public Decimal SKUS{get;set;}
        public Decimal TOTCORE{get;set;}
        public Decimal TOTSKU{get;set;}
        public Boolean CHECKALL{get;set;}
        public String OWNERNAME{get;set;}//Added for "All Impacted Customers View " enhancement
        public Boolean RELCHECK{get;set;}
        public Boolean NOTCHECK{get;set;}
        public Decimal AVGCHANGE{get;set;}
        public Decimal ANNUALSPEND{get;set;}
        public Decimal ANNSPEND_CHNGEAMNT{get;set;}
        public Decimal SPNDIMPACT{get;set;}
        public Decimal SRMIMPACT{get;set;}
        public Decimal NEWIGMDOLLAR{get;set;}
        public Decimal NEWIGMPERCENT{get;set;}
        public String IMPSTATUS{get;set;} 
        public String IMPSTATUSCODE{get;set;}
        public String IMPSTATUSIMG{get;set;}
        public String NOTSTATUS{get;set;}
        public Datetime APPROVDDATE{get;set;} 
        public Datetime NOTIFYDATE{get;set;} 
        public Boolean ISRELEASEALLOWED{get;set;}    
        public Boolean isRemediation {get;set;}
        public Boolean isHosted {get;set;}    
        public Boolean hostedCatalogHold {get;set;}
        public Boolean remediationHold {get;set;}  
        public String showUD{get;set;}
        public String sortOrder{get;set;}
        public String sortedField{get;set;}
        public String sfdcBucket{get;set;}
        public Boolean priceNotCalculated{get;set;}
        public String requestType{get;set;}
        public String wrfID{get;set;}
        public String complianceWrfTaskClosed{get;set;} 
        public String segment{get;set;} 
        public String remedationTaskAssignee{get;set;}
        public Boolean isCustomerOwnerSystemUser{get;set;}
        public Decimal NoOfSKUGovernedByActiveWrittenAgreement{get;set;}
        //Additional fields for 00826584 
         
    }
    
    //method for Uploading remedy files    
    /*public Pagereference Remedy_ReadFile(){
    
        System.debug('>>> content' + contentFile);
        String fileToUpload=contentFile.toString();
        // fileToUpload = contentFile.toString();
        
        if(!''.equals(fileToUpload) && fileToUpload != null)
        filelines = fileToUpload.split('\n');
        filelines.remove(0);
        try{                                                        
            PriceToUpload = new List<Ace_Customer_SKU_Changes__c>();
            for (Integer i=1;i<filelines.size();i++){
                String[] inputvalues = new String[]{};
                inputvalues = filelines[i].split(',');
                system.debug('@@@@@@@selectedCustomer' +selectedCustomer);
        
                if(selectedCustomer == Id.valueOf(inputvalues[0])){ 
                    //Id TempId = Id.valueOf(inputvalues[1]);              
                    Ace_Customer_SKU_Changes__c ace = new Ace_Customer_SKU_Changes__c();
                    system.debug('@@@@@@@inputvalues[1]' +inputvalues[1]);
                    ace = [select id from Ace_Customer_SKU_Changes__c where id=:Id.valueOf(inputvalues[1])];
                    //ace.id = Id.valueOf(inputvalues[1]);
                    //ace.Ace_Customer_Core_Changes__r.ACE_Customer_Price_Changes__r.Owning_Customer_ID__c = String.valueOf(inputvalues[2]);
                    //ace.Ace_Customer_Core_Changes__r.ACE_Customer_Price_Changes__r.Name = String.valueOf(inputvalues[3]);
                    //ace.SKU__c = String.valueOf(inputvalues[4]);
                    //ace.Approved_Proposed_Price__c = Integer.valueOf(inputvalues[5]);
                    String Temp1 = inputvalues[6];                    
                    ace.User_Proposed_Price__c = Integer.valueOf(Temp1); 
                    ace.Customer_Notification_Date__c = Date.valueof(inputvalues[7]);
                    ace.Sales_Price_Change_Effective_Date_Approv__c = Date.valueof(inputvalues[8]);    
                                 
                    if(ace.User_Proposed_Price__c > ace.Current_Sell_Price__c){
                        if(ace.Sales_Price_Change_Effective_Date_Approv__c > ace.Customer_Notification_Date__c){
                            Date earliestdate = Date.Today();
                            if(earliestdate.adddays(integer.valueof(ace.Requirement_Window__c)) < ace.Sales_Price_Change_Effective_Date_Approv__c){
                                PriceToUpload.add(ace);
                            }
                            else{
                                throw new CustException ('Error: Requirement Window is not satisfied for SKU: '+ace.SKU__c+'.');            
                            }                            
                        }
                        else{
                            throw new CustException ('Error: Sku Effective Date is less than notification date for SKU: '+ace.SKU__c+'.');            
                        }                                                                                                   
                    }
                    else{
                        throw new CustException ('Error: Customer Doesnt match with the upload data. Please check the unique Customer Id');            
                    }
                }                
            }                        
        
                upsert PriceToUpload;
        } 
        catch (CustException ce){           
            ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.ERROR,ce.getMessage()));
            return null;
        }                                
        catch (Exception e){
            ApexPages.Message errormsg = new ApexPages.Message(ApexPages.severity.ERROR,'An error has occured. Please check the CSV template or try again later');
            ApexPages.addMessage(errormsg);
        }
          
        
        
        
        //} 
        /*else{
            ApexPages.Message errormsg = new ApexPages.Message(ApexPages.severity.ERROR,'An error has occured. The CSV template has more than 400 records. Upload cannot perform more than 400 records.');
            ApexPages.addMessage(errormsg);
        }//
        return null;
    }
    
    //public string fileToUpload1{get;set;}
    public Blob content1{get;set;}
    String[] filelines1 = new String[]{};
    List<Ace_Customer_Price_Changes__c> DateToUpload;
    public static  String APPROVALNOTREQUIRED = 'This Submission Does Not Require Any Exception Request, Please use Release Functionality';
    public static String DATEEXCEPTIONLOCK = 'LOCK-DATEEXCEPTION';
    public class custException extends Exception{}
    
    //method for Uploading hosted files
    public Pagereference Hosted_ReadFile(){
        String fileToUpload1=content1.toString();
        filelines1 = fileToUpload1.split('\n');
        DateToUpload = new List<Ace_Customer_Price_Changes__c>();
        for (Integer i=1;i<filelines1.size();i++){
            String[] inputvalues = new String[]{};
            inputvalues = filelines[i].split(',');
            
            Ace_Customer_Price_Changes__c ace = new Ace_Customer_Price_Changes__c();            
            ace.Sales_Price_Change_Effective_Date_Approv__c = date.parse(inputvalues[0]);
            ace.Sales_Price_Change_Effective_Date_Rep__c = date.parse(inputvalues[1]);       
             //
             // Validation code starts here
                  Date effectiveDate; 
                  if (ace.Sales_Price_Change_Effective_Date_Approv__c != null && ace.Sales_Price_Change_Effective_Date_Approv__c > ace.Sales_Price_Change_Effective_Date__c)
                      effectiveDate = ace.Sales_Price_Change_Effective_Date_Approv__c;
                  else
                      effectiveDate = ace.Sales_Price_Change_Effective_Date__c;
           
                  if (ace.Sales_Price_Change_Effective_Date_Rep__c <= effectiveDate)
                      throw new custException(APPROVALNOTREQUIRED);  
                
                  ace.record_lock_code__c = DATEEXCEPTIONLOCK;
                  Approval.ProcessResult result;
                  Decimal revImpactForCalculation = 0;
                  if (ace.OD_Revenue_Impact__c != null)
                       revImpactForCalculation = -1 * ace.OD_Revenue_Impact__c;
                  if (revImpactForCalculation >= 1000) 
                  {
                       user u = [select manager.id,manager.manager.id,manager.manager.manager.id from user where id = :userInfo.getUserId()];
                       ace.approval_type__c = 1;
                       // Logic to set Approver Type field - This will drive the approval action step - Starts
                       if (revImpactForCalculation > 75000 && revImpactForCalculation >= 150000) 
                           ace.approval_type__c = 2;
                       else if (revImpactForCalculation > 150000)
                           ace.approval_type__c = 3;
                       
                     Integer datedelay = ace.Sales_Price_Change_Effective_Date_Rep__c.daysbetween(effectiveDate);
                     if (datedelay > 90 && datedelay <= 180 && ace.approval_type__c < 2)
                        ace.approval_type__c = 2; 
                     else if (datedelay > 180 && ace.approval_type__c < 3)
                        ace.approval_type__c = 3; 
                     
                     if(ace.approval_type__c == 1){
                         ace.dsm__c = u.manager.id;
                     }
                     else if(ace.approval_type__c == 2){
                         ace.dsm__c = u.manager.id;
                         ace.rsd__c = u.manager.manager.id;         
                     }
                     else if(ace.approval_type__c == 3){
                         ace.dsm__c = u.manager.id;
                         ace.rsd__c = u.manager.manager.id;
                         ace.vp__c = u.manager.manager.id;
                     }      
                 
                 }
                 else
                   {
                        ace.Sales_Price_Change_Effective_Date_Approv__c = ace.Sales_Price_Change_Effective_Date_Rep__c;
                        system.debug('Approval Not Required');
                   }
                  // Validation code ends here
            
            
            
            DateToUpload.add(ace);
        }
        try{
            upsert DateToUpload;
        }
        catch (Exception e){
            ApexPages.Message errormsg = new ApexPages.Message(ApexPages.severity.ERROR,'An error has occured. Please check the CSV template or try again later');
            ApexPages.addMessage(errormsg);
        }    
        return null;
    }
    */
    
    
}