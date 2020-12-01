Global class ACE_Summary_Grid_New 
{
    public String backPageLink{get;set;}
    public AceReleaseCommon acerel {get;set;}
    list<AceReleaseCommon.releaseResponse> relrespList {get;set;}
    
    public String OwnerValue { get; set; }
    
    public String searchText{get;set;}
    public String Notify_searchText{get;set;}
    public String Noreq_searchText{get;set;}
    
    public String searchWord{get;set;}
    public String Batch{get;set;}
    public Boolean renderCustList{get;set;}
    public String OwnerTypeSel;
    public Integer List_size = 10;
    
    public Integer total_size{get;set;}
    public Integer custCount{get;set;}
    public Integer total_size_notify{get;set;}
    public Integer custCount_notify{get;set;}
    public Integer total_size_noreq{get;set;}
    public Integer custCount_noreq{get;set;}
    public String pageParam{get;set;}
    public List<User> UserList;
    
    // public Set<ID> ownerList;
    // public String SectionTitle{get;set;}
    
    public String fieldName{get;set;}
    public String getFieldName{get;set;}
    
    public String fieldName_notify{get;set;}
    public String getFieldName_notify{get;set;}
    
    public String fieldName_noreq{get;set;}
    public String getFieldName_noreq{get;set;}
    
    public String sortDirection ;
    public String sortDirection_notify ;
    public String sortDirection_noreq ;
    
    public Boolean tabAsc{get;set;}
    public Boolean tabAsc_notify{get;set;}
    public Boolean tabAsc_noreq{get;set;}
    
    
    public Decimal TotCore{get;set;}
    public Decimal TotSKU{get;set;}
    public String expandLabel{get;set;}
    public String Notify_expandLabel{get;set;} 
    public Boolean renderTable{get;set;}
    public Boolean Notify_renderTable{get;set;}
    public String Noreq_expandLabel{get;set;} 
    public Boolean Noreq_renderTable{get;set;}
    
    
    public Integer selectedCount{get;set;}
    public List<custListTable> clsCusListTable{get;set;}
    public List<custListTable> clsCusListTable_notify{get;set;}
    public List<custListTable> clsCusListTable_noreq{get;set;}
    public Set<ID> passSelected{get;set;}
    public Set<ID> passRelSelected{get;set;}
    public Set<ID> passSelected_notify{get;set;}
    public Set<ID> passRelSelected_notify{get;set;}
    public Set<ID> passSelected_noreq{get;set;}
    public Set<ID> passRelSelected_noreq{get;set;}
    
    public Decimal perIncrease{get;set;}
    public Decimal AnnSpndChnge{get;set;}
    public Decimal AnnSpndImpact{get;set;}
    public Decimal SRMImpTotal{get;set;}
    
    public Decimal perIncrease_notify{get;set;}
    public Decimal AnnSpndChnge_notify{get;set;}
    public Decimal AnnSpndImpact_notify{get;set;}
    public Decimal SRMImpTotal_notify{get;set;}
    
    public Decimal perIncrease_noreq{get;set;}
    public Decimal AnnSpndChnge_noreq{get;set;}
    public Decimal AnnSpndImpact_noreq{get;set;}
    public Decimal SRMImpTotal_noreq{get;set;}
        
    public String Total_SRM{get;set;}
    public Boolean RenderRep{get;set;}
    public Boolean RenderIGM{get;set;}
    
    public Boolean renderError{get;set;}
    public Boolean renderRelConfirm{get;set;}
    public Boolean renderNotConfirm{get;set;}
    public Boolean renderBothConfirm{get;set;}
    
    list<AceReleaseCommon.releaseResponse> notrespList {get;set;}
    public Set<ID> passNotifySelected{get;set;}
    
    
    public PageReference showCustList(){
        PageReference pr1;                      
        pr1 = new PageReference('/apex/ACE_Customer_List_Page?batch='+batch);        
        pr1.setRedirect(true);
        return pr1;
    }
    
    public void setOwnerTypeSel(String OwnerTypeSel)
    {
        this.OwnerTypeSel = OwnerTypeSel;
    }
    public String getOwnerTypeSel()
    {
        return OwnerTypeSel;
    }
    
    public Set<ID> sID_ACE_Price_ID {get;set;}
    
    public ACE_Summary_Grid_New() { 
                backPageLink = '<< Back To Customer Price Changes ';
                RenderIGM = false;
                getFieldName = 'annualspndchange';
                getFieldName_notify = 'annualspndchange';
                getFieldName_noreq = 'annualspndchange';
                fieldName = 'Total_Spend_Impact_12_Month__c';
                fieldName_notify = 'Total_Spend_Impact_12_Month__c';
                fieldName_noreq = 'Total_Spend_Impact_12_Month__c';
                searchWord = ApexPages.currentPage().getParameters().get('searchWord');
                batch= ApexPages.currentPage().getParameters().get('batch');
                // OwnerValue = ApexPages.currentPage().getParameters().get('ownerValue');
                OwnerValue = 'Owned by me';
                RenderRep = false;
                renderCustList = false;
                renderTable = false;
                Notify_renderTable = false;
                Noreq_renderTable = false;
                passSelected = new Set<ID>();
                passRelSelected = new Set<ID>();
                
                passSelected_notify = new Set<ID>();
                passRelSelected_notify = new Set<ID>();
                
                passSelected_noreq = new Set<ID>();
                passRelSelected_noreq = new Set<ID>();
                passNotifySelected  = new Set<ID>();
               
                counter=0;
                counter_notify=0;
                counter_noreq=0;
                
                selectedCount=0;
                tabAsc = true;
                tabAsc_notify = true;
                tabAsc_noreq = true;
                sortDirection = 'ASC';
                sortDirection_notify = 'ASC';
                sortDirection_noreq = 'ASC';
                
                expandLabel = '[+] Approval Required Per Written Agreement';
                Notify_expandLabel = '[+] Notification Required Per Written Agreement';
                Noreq_expandLabel = '[+] No Requirements';
                acerel = new AceReleaseCommon();
                relrespList = new list<AceReleaseCommon.releaseResponse>();
                notrespList = new list<AceReleaseCommon.releaseResponse>();
                
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
                
           
                constructDataList();
                getURL();
    }
    
    public void constructDataList() {
         userList = new List<User>();
            ACE_User_Cust_Hierarchy_Controller obj = new ACE_User_Cust_Hierarchy_Controller();
            UserList = obj.lUserList;
            system.debug('ownerlist:' + UserList);
            Set<ID> ownerList = new Set<ID>();
            for(User u2 : UserList)
            {
                ownerList.add(u2.id);
            }
            // Code to handle owner value picklist
            if(OwnerValue == 'All')
            {
                RenderRep = true;
                ownerList.add(UserInfo.getUserId());    
            }
            else if(OwnerValue == 'Owned by me')
            {
                RenderRep = false;
                ownerList = new Set<ID>();
                ownerList.add(UserInfo.getUserId());    
            }
             else if (OwnerValue == 'Owned by others' || OwnerValue == 'Owned by my team')
            {
                RenderRep = true;
                ownerList.remove(UserInfo.getUserId());
            }
            else
            {
                ownerList = new Set<ID>();
                ownerList.add(UserInfo.getUserId());
            }
            
            sID_ACE_Price_ID = new Set<ID>();
            sID_ACE_Price_ID = obj.CustomerPriceChangeRecs(ownerList,OwnerValue,batch );
            system.debug('Total Customers To Collect:' + sID_ACE_Price_ID.size());
    }
    
    public PageReference SearchRecords()
    {
        searchtext = '';
        notify_searchtext = '';
        noreq_searchtext = '';
        counter_notify = 0;
        counter_noreq = 0;
        counter = 0;
        System.debug('Value of OwnerValue' + OwnerValue);
        constructDataList();
        getURL();
        return null;
    }
    
    public PageReference SearchRecords_sec()
    {   
        //processSelected_noreq();
        //processSelected();
        //processSelected_notify();
        counter_notify = 0;
        counter_noreq = 0;
        counter = 0;
        constructDataList();
        getURL();
        return null;
    }

    public void doExpand()
    {
        if(expandLabel == '[-] Approval Required Per Written Agreement')
        {
            expandLabel = '[+] Approval Required Per Written Agreement';
            renderTable = false;
        }
        else
        {
            expandLabel = '[-] Approval Required Per Written Agreement';
            renderTable = true;
        }
    }

    public void Notify_doExpand()
    {
        if(Notify_expandLabel == '[-] Notification Required Per Written Agreement')
        {
            Notify_expandLabel = '[+] Notification Required Per Written Agreement';
            Notify_renderTable = false;
        }
        else
        {
            Notify_expandLabel = '[-] Notification Required Per Written Agreement';
            Notify_renderTable = true;
        }
    }
    
    public void Noreq_doExpand()
    {
        if(Noreq_expandLabel == '[-] No Requirements')
        {
            Noreq_expandLabel = '[+] No Requirements';
            Noreq_renderTable = false;
        }
        else
        {
            Noreq_expandLabel = '[-] No Requirements';
            Noreq_renderTable = true;
        }
    }

    
    public void nextPage(){
        counter = counter+List_size; 
        //checkall();
        //getURL();  
        processSelected();//    
        system.debug('get url call4');         
        getURL();
        
    }
    public void prevPage(){
        counter = counter-List_size;
        //checkall();
        //getURL();
        processSelected();//   
        system.debug('get url call5');             
        getURL();
        
    }
    
   
    
    public void nextPage_notify(){
        counter_notify = counter_notify +List_size; 
          
        processSelected_notify();//             
        getURL();
        
    }
    public void prevPage_notify(){
        counter_notify = counter_notify -List_size;
        
        processSelected_notify();//                
        getURL();
        
    }
    
    public Boolean getDisablePrevious_notify() {
     
      if (counter_notify >0) return true; else return false;
    }
    public Boolean getDisableNext_notify() { 
      if (counter_notify + list_size < total_size_notify) return true; else return false;
   }
    
    public void nextPage_noreq(){
        counter_noreq = counter_noreq +List_size; 
          
        processSelected_noreq();//             
        getURL();
        
    }
    public void prevPage_noreq(){
        counter_noreq  = counter_noreq -List_size;
        
        processSelected_noreq();//                
        getURL();
        
    }
    public Boolean getDisablePrevious_noreq() {
     
      if (counter_noreq > 0) return true; else return false;
    }
    public Boolean getDisableNext_noreq() { 
      if (counter_noreq + list_size < total_size_noreq) return true; else return false;
    }
    
    public Integer counter; 
    public Integer counter_notify;
    public Integer counter_noreq;    
    public Boolean getDisablePrevious() {
     
      if (counter>0) return true; else return false;
    }
    public Boolean getDisableNext() { 
      if (counter + list_size < total_size) return true; else return false;
   }
   
   public static String sortByField{get;set;}
    
    global class custListTable implements Comparable
    {
        public ACE_Customer_Price_Changes__c  ts{get;set;}
        public Id ID{get;set;}
        public String NAME{get;set;}
        public String CUSTOMER{get;set;}
        public String CUSTOMERNUM{get;set;}        
        public String OWNERNAME{get;set;}
        public Decimal CORES{get;set;}
        public Decimal SKUS{get;set;}
        public Decimal NoOfSKUGovernedByActiveWrittenAgreement{get;set;} //ROM Item 10B
        public String SKUS_val{get;set;}
        public Decimal TOTCORE{get;set;}
        public Decimal TOTSKU{get;set;}
        public Boolean CHECKALL{get;set;}
        public Boolean RELCHECK{get;set;}
        public Boolean NOTIFYCHECK{get;set;}
        public Decimal AVGCHANGE{get;set;}
        public Boolean NOTCHECK{get;set;}
        public Decimal ANNUALSPEND{get;set;}
        public Decimal ANNSPEND_CHNGEAMNT{get;set;}
        public Decimal SPNDIMPACT{get;set;}
        public Decimal SRMIMPACT{get;set;}
        public Decimal NEWIGMDOLLAR{get;set;}
        public Decimal NEWIGMPERCENT{get;set;}
        public String IMPSTATUS{get;set;}
        public Datetime APPROVDDATE{get;set;} 
        public Datetime NOTIFYDATE{get;set;} 
        public Boolean ISRELEASEALLOWED{get;set;}      
        public Boolean CHECKOWNER{get;set;}
        public String IMPSTATUSCODE{get;set;}
        public String IMPSTATUSIMG{get;set;}
        public String NOTSTATUS{get;set;}
        public Boolean isSTDCore{get;set;}
        
        
        
        global Integer compareTo(Object objToCompare)
         {
                if(sortByfield.equals('SKUS'))
                   // return SKUS_val.compareTo(((custListTable)objToCompare).SKUS_val);      
                   return Integer.valueOf(SKUS - ((custListTable)objToCompare).SKUS);
                else  if(sortByfield.equals('AVGCHANGE'))
                    return SKUS_val.compareTo(((custListTable)objToCompare).SKUS_val);      
                else
                    return -1;
         }                                 
    }
    
    public void getURL()
    {
            System.debug('^^^^^^^^^^^'+pageParam);            
            // Code to handle owner value picklist ends
            clsCusListTable = new List<custListTable>();
            clsCusListTable_Notify = new List<custListTable>();
            clsCusListTable_Noreq = new List<custListTable>();
            
            if(sID_ACE_Price_ID != null)
            {
                clsCusListTable = getPriceRecs(sID_ACE_Price_ID,'Approval Required Per Written Agreement', '3', counter, fieldName ,sortDirection);
                clsCusListTable_Notify = getPriceRecs(sID_ACE_Price_ID,'Notification Required Per Written Agreement', '2',counter_notify,fieldName_notify ,sortDirection_notify);
                clsCusListTable_Noreq = getPriceRecs(sID_ACE_Price_ID,'No Requirement', '1',counter_noreq,fieldName_noreq ,sortDirection_noreq);
                
            }
        }
        
        public List<custListTable> getPriceRecs(Set<ID> sID_ACE_Price_ID,String SectionTitle, String Pp, Integer counter,String fieldName ,String sortDirection)
        {
         
          //  String SectionTitle = SectionTitle;
            String pageParam = pp; 
            batch= ApexPages.currentPage().getParameters().get('batch');
            string selectionString = 'select id,Customer_Annual_Spend__c,Price_Not_Calculated__c,customer__r.remediation_required__c,Owning_Customer_ID__c,Customer_Notification_Date__c,remedy_status__c,Sales_Price_Change_Effective_Date_Min__c, Name,Customer__r.name,Record_Lock__c,Customer__r.OwnerId,Customer__r.Owner.Name,Customer__r.Owner.short_title__c,Customer__r.id,Item_12_Month_Qty__c,Item_12_Month_Sales__c,Total_Spend_Impact_12_Month__c,SRM_Differential__c,sfdc_notification_flag__c,Exception_Date_Lock__c,Notification_Status__c,Implementation_Status__c,Implementation_Status3__c,implementation_status_code__c,Implementation_Status_Image__c,Notification_Status_Image__c,Notification_Status3__c,requirement_window__c,Sales_Price_Change_Effective_Date_Rep__c,Sales_Price_Change_Effective_Date__c, Sales_Price_Change_Effective_Date_Approv__c, Customer_Notification_Date_Approved__c,Corecount__c,New_Gross_IGM__c,New_Gross_IGM1__c,IsRemediation__c,NoOfSKUGovernedByActiveWrittenAgreement__c'; //ROM Item 10B
            List<ACE_Customer_Price_Changes__c> custPricechangeList = new List<ACE_Customer_Price_Changes__c>();
                        
            system.debug('>>>>>>>>>>>>>>>>>>>>>Field Name:' + fieldName);
            
            system.debug('>>>>>>>>>>>>>>>>>>>>>getFieldName:' + getFieldName);
            
            
            //ROM Item 27 Adding Rep search 00826597
            if(pageParam == '3') 
            {
                custCount = [select count() from ACE_Customer_Price_Changes__c where SFDC_Notification_Flag__c = :pageParam AND id in: sID_ACE_Price_ID AND name = :batch];//ROM-38 AND Price_Not_Calculated__c = false];
                if((searchText != null) && (searchText != '') && (searchText != 'null'))
                {      
                    String textToSearch = searchText.trim() + '%';
                    
                    String queryString = selectionString + ' from ACE_Customer_Price_Changes__c where (Customer__r.name like :textToSearch OR Customer__r.AOPS_Cust_Id__c LIKE :textToSearch OR Customer__r.Owner.Name LIKE :textToSearch) AND (SFDC_Notification_Flag__c = \'' + pageParam + '\' AND Name = \'' + batch + '\') AND id in: sID_ACE_Price_ID';//ROM-38 AND Price_Not_Calculated__c = false';// and  (remedy_status__c = \'Pending\' or  remedy_status__c = \'Rejected\')';
                    custPricechangeList = Database.query(queryString + ' order by '+fieldName+' '+sortDirection+' NULLS LAST limit 10 offset :counter');                            
                    total_size = [select count() from ACE_Customer_Price_Changes__c where (Customer__r.name like :textToSearch OR Customer__r.AOPS_Cust_Id__c LIKE :textToSearch) and SFDC_Notification_Flag__c = :pageParam AND id in: sID_ACE_Price_ID AND name = :batch];//ROM-38 AND Price_Not_Calculated__c = false]; // and  (remedy_status__c = 'Pending' or  remedy_status__c = 'Rejected')];                      
                }
                else if((searchWord != null) && (searchWord != '') && (searchWord != 'null'))
                {      
                        String textToSearch = searchWord.trim() + '%';
                         
                        String queryString = selectionString + ' from ACE_Customer_Price_Changes__c where (Customer__r.name like :textToSearch OR Customer__r.AOPS_Cust_Id__c LIKE :textToSearch OR Customer__r.Owner.Name LIKE :textToSearch) AND (SFDC_Notification_Flag__c = \'' + pageParam + '\' AND Name = \'' + batch + '\') AND id in: sID_ACE_Price_ID'; // ROM-38 AND Price_Not_Calculated__c = false'; //and  (remedy_status__c = \'Pending\' or  remedy_status__c = \'Rejected\')';
                        custPricechangeList = Database.query(queryString + ' order by '+fieldName+' '+sortDirection+' NULLS LAST  limit 10 offset :counter');                                         
                        if((custPricechangeList.size() > 0) && (pageParam == '3'))
                        {
                            expandLabel = '[-] Approval Required Per Written Agreement';
                            renderTable = true;
                        }
                        SearchText = ''; 
                        total_size = [select count() from ACE_Customer_Price_Changes__c where (Customer__r.name like :textToSearch OR Customer__r.AOPS_Cust_Id__c LIKE :textToSearch) and SFDC_Notification_Flag__c = :pageParam AND id in: sID_ACE_Price_ID AND name = :batch]; //ROM-38 AND Price_Not_Calculated__c = false]; // and  (remedy_status__c = 'Pending' or  remedy_status__c = 'Rejected')];                      
                 }
                 else
                 {
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            
                        String queryString = selectionString + ' from ACE_Customer_Price_Changes__c where SFDC_Notification_Flag__c =\''+ pageParam + '\' AND NAME=\'' +  batch + '\' AND id in: sID_ACE_Price_ID'; //ROM-38 AND Price_Not_Calculated__c = false';
                       // String queryString = 'select id, Name,Customer__r.name,Customer__r.id,Item_12_Month_Qty__c,Item_12_Month_Sales__c,Total_Spend_Impact_12_Month__c,SRM_Differential__c,sfdc_notification_flag__c,Exception_Date_Lock__c,Notification_Status__c,Implementation_Status__c,Implementation_Status3__c,implementation_status_code__c,Implementation_Status_Image__c,Notification_Status_Image__c,Notification_Status3__c,requirement_window__c,Sales_Price_Change_Effective_Date_Rep__c,Sales_Price_Change_Effective_Date__c, Sales_Price_Change_Effective_Date_Approv__c, Customer_Notification_Date_Approved__c,Corecount__c from ACE_Customer_Price_Changes__c where SFDC_Notification_Flag__c =\''+ pageParam + '\' AND NAME=\'' +  batch + '\'';
                        system.debug('Query to Execute:' + queryString);
                        custPricechangeList = Database.query(queryString + ' ORDER BY '+fieldName+' '+sortDirection+' NULLS LAST  limit 10 offset :counter'); 
                        //system.debug('deepak');
                        system.debug('Customer size'+sID_ACE_Price_ID.size());                      
                        total_size = [select count() from ACE_Customer_Price_Changes__c where SFDC_Notification_Flag__c = :pageParam AND id in: sID_ACE_Price_ID AND name = :batch]; //ROM-38 AND Price_Not_Calculated__c = false]; //and  (remedy_status__c = 'Pending' or  remedy_status__c = 'Rejected')];
                 }
                
            }
            else if(pageParam == '2')
            {
                custCount_notify = [select count() from ACE_Customer_Price_Changes__c where SFDC_Notification_Flag__c = :pageParam AND id in: sID_ACE_Price_ID AND name = :batch];//ROM-38 AND Price_Not_Calculated__c = false];
                if((Notify_searchText != null) && (Notify_searchText != '') && (Notify_searchText != 'null'))
                {      
                    String textToSearch = Notify_searchText.trim() + '%';
                    
                    String queryString = selectionString +  + ' from ACE_Customer_Price_Changes__c where (Customer__r.name like :textToSearch OR Customer__r.AOPS_Cust_Id__c LIKE :textToSearch OR Customer__r.Owner.Name LIKE :textToSearch) AND (SFDC_Notification_Flag__c = \'' + pageParam + '\' AND Name = \'' + batch + '\') AND id in: sID_ACE_Price_ID'; //ROM-38 AND Price_Not_Calculated__c = false'; //and  (remedy_status__c = \'Pending\' or  remedy_status__c = \'Rejected\')';
                    custPricechangeList = Database.query(queryString + ' order by '+fieldName+' '+sortDirection+' NULLS LAST  limit 10 offset :counter');                            
                    total_size_notify = [select count() from ACE_Customer_Price_Changes__c where (Customer__r.name like :textToSearch OR Customer__r.AOPS_Cust_Id__c LIKE :textToSearch) and SFDC_Notification_Flag__c = :pageParam AND id in: sID_ACE_Price_ID AND name = :batch]; //ROM-38 AND Price_Not_Calculated__c = false]; //and  (remedy_status__c = 'Pending' or  remedy_status__c = 'Rejected')];
                }
                else if((searchWord != null) && (searchWord != '') && (searchWord != 'null'))
                {      
                        String textToSearch = searchWord.trim() + '%';
                         
                        String queryString = selectionString + ' from ACE_Customer_Price_Changes__c where (Customer__r.name like :textToSearch OR Customer__r.AOPS_Cust_Id__c LIKE :textToSearch OR Customer__r.Owner.Name LIKE :textToSearch) AND (SFDC_Notification_Flag__c = \'' + pageParam + '\' AND Name = \'' + batch + '\') AND id in: sID_ACE_Price_ID';//ROM-38 AND Price_Not_Calculated__c = false'; //and  (remedy_status__c = \'Pending\' or  remedy_status__c = \'Rejected\')';
                        custPricechangeList = Database.query(queryString + ' order by '+fieldName+' '+sortDirection+' NULLS LAST  limit 10 offset :counter');                                         
                        if((custPricechangeList.size() > 0) && (pageParam == '2'))
                        {
                            Notify_expandLabel = '[-] Notification Required Per Written Agreement';
                            Notify_renderTable = true;
                        }
                        Notify_SearchText = '';                       
                        total_size_notify = [select count() from ACE_Customer_Price_Changes__c where (Customer__r.name like :textToSearch OR Customer__r.AOPS_Cust_Id__c LIKE :textToSearch) and SFDC_Notification_Flag__c = :pageParam AND id in: sID_ACE_Price_ID AND name = :batch]; //ROM-38 AND Price_Not_Calculated__c = false]; //and  (remedy_status__c = 'Pending' or  remedy_status__c = 'Rejected')];                        
                 }
                 else
                 {
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            
                        String queryString = selectionString + ' from ACE_Customer_Price_Changes__c where SFDC_Notification_Flag__c =\''+ pageParam + '\' AND NAME=\'' +  batch + '\' AND id in: sID_ACE_Price_ID';//ROM-38AND Price_Not_Calculated__c = false'; //and  (remedy_status__c = \'Pending\' or  remedy_status__c = \'Rejected\')';
                       // String queryString = 'select id, Name,Customer__r.name,Customer__r.id,Item_12_Month_Qty__c,Item_12_Month_Sales__c,Total_Spend_Impact_12_Month__c,SRM_Differential__c,sfdc_notification_flag__c,Exception_Date_Lock__c,Notification_Status__c,Implementation_Status__c,Implementation_Status3__c,implementation_status_code__c,Implementation_Status_Image__c,Notification_Status_Image__c,Notification_Status3__c,requirement_window__c,Sales_Price_Change_Effective_Date_Rep__c,Sales_Price_Change_Effective_Date__c, Sales_Price_Change_Effective_Date_Approv__c, Customer_Notification_Date_Approved__c,Corecount__c from ACE_Customer_Price_Changes__c where SFDC_Notification_Flag__c =\''+ pageParam + '\' AND NAME=\'' +  batch + '\'';
                        custPricechangeList = Database.query(queryString + ' ORDER BY '+fieldName+' '+sortDirection+' NULLS LAST  limit 10 offset :counter'); 
                        total_size_notify = [select count() from ACE_Customer_Price_Changes__c where SFDC_Notification_Flag__c = :pageParam AND id in: sID_ACE_Price_ID AND name = :batch];//ROM-38 AND Price_Not_Calculated__c = false]; //and  (remedy_status__c = 'Pending' or  remedy_status__c = 'Rejected')];                         
                 }
                
            }
            else if(pageParam == '1')
            {
                custCount_noreq = [select count() from ACE_Customer_Price_Changes__c where SFDC_Notification_Flag__c = :pageParam AND id in: sID_ACE_Price_ID AND name = :batch];//ROM-38 AND Price_Not_Calculated__c = false];    
                if((Noreq_searchText != null) && (Noreq_searchText != '') && (Noreq_searchText != 'null'))
                {      
                    String textToSearch = Noreq_searchText.trim() + '%';
                    
                    String queryString = selectionString +  + ' from ACE_Customer_Price_Changes__c where (Customer__r.name like :textToSearch OR Customer__r.AOPS_Cust_Id__c LIKE :textToSearch OR Customer__r.Owner.Name LIKE :textToSearch) AND (SFDC_Notification_Flag__c = \'' + pageParam + '\' AND Name = \'' + batch + '\') AND id in: sID_ACE_Price_ID';//ROM-38 AND Price_Not_Calculated__c = false'; //and  (remedy_status__c = \'Pending\' or  remedy_status__c = \'Rejected\')';
                    custPricechangeList = Database.query(queryString + ' order by '+fieldName+' '+sortDirection+' NULLS LAST  limit 10 offset :counter');                            
                    total_size_noreq = [select count() from ACE_Customer_Price_Changes__c where (Customer__r.name like :textToSearch OR Customer__r.AOPS_Cust_Id__c LIKE :textToSearch) and SFDC_Notification_Flag__c = :pageParam AND id in: sID_ACE_Price_ID AND name = :batch];//ROM-38 AND Price_Not_Calculated__c = false]; //and  (remedy_status__c = 'Pending' or  remedy_status__c = 'Rejected')];
                }
                else if((searchWord != null) && (searchWord != '') && (searchWord != 'null'))
                {      
                        String textToSearch = searchWord.trim() + '%';
                         
                        String queryString = selectionString + ' from ACE_Customer_Price_Changes__c where (Customer__r.name like :textToSearch OR Customer__r.AOPS_Cust_Id__c LIKE :textToSearch OR Customer__r.Owner.Name LIKE :textToSearch) AND (SFDC_Notification_Flag__c = \'' + pageParam + '\' AND Name = \'' + batch + '\') AND id in: sID_ACE_Price_ID';//ROM-38 AND Price_Not_Calculated__c = false'; //and  (remedy_status__c = \'Pending\' or  remedy_status__c = \'Rejected\')';
                        custPricechangeList = Database.query(queryString + ' order by '+fieldName+' '+sortDirection+' NULLS LAST  limit 10 offset :counter');                                         
                        if((custPricechangeList.size() > 0) && (pageParam == '1'))
                        {
                            Noreq_expandLabel = '[-] No Requirements';
                            Noreq_renderTable = true;
                        }
                        Noreq_SearchText = '';  
                        total_size_noreq = [select count() from ACE_Customer_Price_Changes__c where (Customer__r.name like :textToSearch OR Customer__r.AOPS_Cust_Id__c LIKE :textToSearch) and SFDC_Notification_Flag__c = :pageParam AND id in: sID_ACE_Price_ID AND name = :batch];//ROM-38 AND Price_Not_Calculated__c = false];                     
                 }
                 else
                 {
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            
                        String queryString = selectionString + ' from ACE_Customer_Price_Changes__c where SFDC_Notification_Flag__c =\''+ pageParam + '\' AND NAME=\'' +  batch + '\' AND id in: sID_ACE_Price_ID';//ROM-38 AND Price_Not_Calculated__c = false';
                       // String queryString = 'select id, Name,Customer__r.name,Customer__r.id,Item_12_Month_Qty__c,Item_12_Month_Sales__c,Total_Spend_Impact_12_Month__c,SRM_Differential__c,sfdc_notification_flag__c,Exception_Date_Lock__c,Notification_Status__c,Implementation_Status__c,Implementation_Status3__c,implementation_status_code__c,Implementation_Status_Image__c,Notification_Status_Image__c,Notification_Status3__c,requirement_window__c,Sales_Price_Change_Effective_Date_Rep__c,Sales_Price_Change_Effective_Date__c, Sales_Price_Change_Effective_Date_Approv__c, Customer_Notification_Date_Approved__c,Corecount__c from ACE_Customer_Price_Changes__c where SFDC_Notification_Flag__c =\''+ pageParam + '\' AND NAME=\'' +  batch + '\'';
                        custPricechangeList = Database.query(queryString + ' ORDER BY '+fieldName+' '+sortDirection+' NULLS LAST  limit 10 offset :counter'); 
                        total_size_noreq = [select count() from ACE_Customer_Price_Changes__c where SFDC_Notification_Flag__c = :pageParam AND id in: sID_ACE_Price_ID AND name = :batch]; //ROM-38 AND Price_Not_Calculated__c = false]; //and  (remedy_status__c = 'Pending' or  remedy_status__c = 'Rejected')];
                                                 
                 }
                
            }
            
              
           if(pageParam == '3')
            {  
               //total_size = [select count() from ACE_Customer_Price_Changes__c where SFDC_Notification_Flag__c = :pageParam AND id in: sID_ACE_Price_ID AND name = :batch AND IsRemediation__c = false];
               //Total_SRM= [select SUM(SRM_Differential__c) from ACE_Customer_Price_Changes__c where SFDC_Notification_Flag__c = '3'];
                AggregateResult[] results = [SELECT SUM(SRM_Differential__c) summary,
                                                    SUM(Item_12_Month_Qty__c) annspnd,
                                                    AVG(Total_Spend_Impact_Percent__c) annspndImpact,
                                                    SUM(Total_Spend_Impact_12_Month__c) aschnge,
                                                    SUM(Approved_Proposed_Price__c) nPrice,
                                                    SUM(Current_Sell_Price__c) cPrice
                                                    FROM ACE_Customer_Price_Changes__c 
                                                    where SFDC_Notification_Flag__c = '3' AND ID IN : sID_ACE_Price_ID AND Name =:batch];//ROM-38 AND Price_Not_Calculated__c = false]; //and  (remedy_status__c = 'Pending' or  remedy_status__c = 'Rejected')];
                System.debug('3>>>' + results[0].get('aschnge'));
                System.debug('3>>>' + results[0].get('annspnd'));
                System.debug('3>>>' + results[0].get('summary'));
                if(results[0].get('aschnge') != null)
                    AnnSpndChnge = math.abs(Integer.ValueOf(results[0].get('aschnge')));
                else 
                    AnnSpndChnge =0;
                    
                if(results[0].get('annspndImpact') != null)
                    AnnSpndImpact = (Double.ValueOf(results[0].get('annspndImpact')));
                else 
                    AnnSpndImpact = 0;    
                
                if(results[0].get('cPrice') != null && double.valueof(results[0].get('cPrice')) != 0){ system.debug('>>>>'+double.valueof(results[0].get('cPrice')));
                    perIncrease = (((Double.ValueOf(results[0].get('nPrice')) - (Double.ValueOf(results[0].get('cPrice')))) * 100) / (Double.ValueOf(results[0].get('cPrice')))); }
                else{
                    perIncrease =0;}
                    
                if(results[0].get('summary') != null && results[0].get('summary') != 0)              
                    SRMImpTotal = math.abs(Integer.ValueOf(results[0].get('summary')));
                else
                    SRMImpTotal = 0;
                system.debug('Total Count of Approval Req:' + total_size);
            }
            if(pageParam == '2')
            {
               //total_size_notify = [select count() from ACE_Customer_Price_Changes__c where SFDC_Notification_Flag__c = :pageParam AND id in: sID_ACE_Price_ID AND name = :batch AND IsRemediation__c = false];
               AggregateResult[] results = [SELECT SUM(SRM_Differential__c) summary,
                                                    SUM(Item_12_Month_Qty__c) annspnd,
                                                    SUM(Total_Spend_Impact_12_Month__c) aschnge,
                                                    AVG(Total_Spend_Impact_Percent__c) annspndImpact,
                                                    SUM(Approved_Proposed_Price__c) nPrice,
                                                    SUM(Current_Sell_Price__c) cPrice 
                                                    FROM ACE_Customer_Price_Changes__c 
                                                    where SFDC_Notification_Flag__c = '2' AND ID IN : sID_ACE_Price_ID AND Name =:batch];//ROM-38 AND Price_Not_Calculated__c = false]; //and  (remedy_status__c = 'Pending' or  remedy_status__c = 'Rejected')];
                System.debug('2>>>' + results[0].get('aschnge'));
                System.debug('2>>>' + results[0].get('annspnd'));
                System.debug('2>>>' + results[0].get('summary'));
                if(results[0].get('aschnge') != null)
                    AnnSpndChnge_notify = math.abs(Integer.ValueOf(results[0].get('aschnge')));
                else 
                    AnnSpndChnge_notify =0;
                
                if(results[0].get('annspndImpact') != null)
                    AnnSpndImpact_notify = (Double.ValueOf(results[0].get('annspndImpact')));
                else 
                    AnnSpndImpact_notify = 0;  
                
                if(results[0].get('cPrice') != null && double.valueof(results[0].get('cPrice')) != 0)
                    perIncrease_notify = (((Double.ValueOf(results[0].get('nPrice')) - (Double.ValueOf(results[0].get('cPrice')))) * 100) / (Double.ValueOf(results[0].get('cPrice')))); 
                else
                    perIncrease_notify =0;
                    
                if(results[0].get('summary') != null && results[0].get('summary') != 0)              
                    SRMImpTotal_notify = math.abs(Integer.ValueOf(results[0].get('summary')));
                else
                    SRMImpTotal_notify = 0;
               // AnnSpndChnge_notify = math.abs(Integer.ValueOf(results[0].get('aschnge')));
               // perIncrease_notify = math.abs(Integer.ValueOf(results[0].get('annspnd')));       
               // SRMImpTotal_notify = math.abs(Integer.ValueOf(results[0].get('summary')));
            }
            if(pageParam == '1')
            {
               //total_size_noreq = [select count() from ACE_Customer_Price_Changes__c where SFDC_Notification_Flag__c = :pageParam AND id in: sID_ACE_Price_ID AND name = :batch AND IsRemediation__c = false];
               //total_size_noreq = custPricechangeList.size();
               AggregateResult[] results = [SELECT SUM(SRM_Differential__c) summary,
                                                    SUM(Item_12_Month_Qty__c) annspnd,
                                                    SUM(Total_Spend_Impact_12_Month__c) aschnge,
                                                    AVG(Total_Spend_Impact_Percent__c) annspndImpact,
                                                    SUM(Approved_Proposed_Price__c) nPrice,
                                                    SUM(Current_Sell_Price__c) cPrice  
                                                    FROM ACE_Customer_Price_Changes__c 
                                                    where SFDC_Notification_Flag__c = '1' AND ID IN : sID_ACE_Price_ID AND Name =:batch];//ROM-38 AND Price_Not_Calculated__c = false];  //and  (remedy_status__c = 'Pending' or  remedy_status__c = 'Rejected')];
                System.debug('1>>>' + results[0].get('aschnge'));
                System.debug('1>>>' + results[0].get('annspnd'));
                System.debug('1>>>' + results[0].get('summary'));
                if(results[0].get('aschnge') != null)
                    AnnSpndChnge_Noreq = math.abs(Integer.ValueOf(results[0].get('aschnge')));
                else 
                    AnnSpndChnge_Noreq =0;
                
                if(results[0].get('annspndImpact') != null)
                    AnnSpndImpact_Noreq = (Double.ValueOf(results[0].get('annspndImpact')));
                else 
                    AnnSpndImpact_Noreq = 0;  
                    
                if(results[0].get('cPrice') != null && Double.valueof(results[0].get('cPrice')) != 0)
                    perIncrease_noreq = (((Double.ValueOf(results[0].get('nPrice')) - (Double.ValueOf(results[0].get('cPrice')))) * 100) / (Double.ValueOf(results[0].get('cPrice')))); 
                else
                    perIncrease_noreq =0;
                    
                if(results[0].get('summary') != null && results[0].get('summary') != 0)              
                    SRMImpTotal_Noreq = math.abs(Integer.ValueOf(results[0].get('summary')));
                else
                    SRMImpTotal_Noreq = 0;
               // AnnSpndChnge_Noreq = math.abs(Integer.ValueOf(results[0].get('aschnge')));
               // perIncrease_Noreq = math.abs(Integer.ValueOf(results[0].get('annspnd')));       
               // SRMImpTotal_Noreq = math.abs(Integer.ValueOf(results[0].get('summary')));
               system.debug('Total Count of No Req:' + total_size_noreq);
            }
            
            //total_change_amt= [select SUM(Total_Spend_Impact_12_Month__c) from ACE_Customer_Price_Changes__c where SFDC_Notification_Flag__c = :pageParam ];
            system.debug('&&&&&&&&&&'+total_size);
            TotCore = 0;
            TotSKU = 0;
            // Added By Deepak - starts
              list<id> custpids = new list<id> ();
              for (ACE_Customer_Price_Changes__c cus: custPricechangeList)
                 custpids.add(cus.id);
              AggregateResult[] corecounts = [SELECT ACE_Customer_Price_Changes__c,count(id) total_cores,sum(SKUcount__c) total_skus from Ace_Customer_Core_Changes__c  where ACE_Customer_Price_Changes__c in :custpids /*ROM-38 AND ACE_Customer_Price_Changes__r.Price_Not_Calculated__c = false*/
                                              group by ACE_Customer_Price_Changes__c];
              Map<ID,Integer> customer_with_core_counts = new Map<ID,Integer> ();
              Map<ID,Integer> customer_with_sku_counts = new Map<ID,Integer> ();
              for (integer i=0; i< corecounts.size(); i++) {
                  customer_with_core_counts.put((ID)corecounts[i].get('ACE_Customer_Price_Changes__c'),Integer.valueof(corecounts[i].get('total_cores')));
                  customer_with_sku_counts.put((ID)corecounts[i].get('ACE_Customer_Price_Changes__c'),Integer.valueof(corecounts[i].get('total_skus')));
              }
              
              System.debug('Cores Fetched:' + customer_with_core_counts.size());
              // Added By Deepak - Ends
              
              
              List<custListTable> clsCusListTable1 = new List<custListTable>();
              if(custPricechangeList != null)
              {
               for(ACE_Customer_Price_Changes__c cus: custPricechangeList)
               {
                custListTable c = new custListTable();
                //c.CORES = 0;
                c.ts = cus;
                c.ID = cus.id;
                c.NAME = cus.Name;
                c.CUSTOMER = cus.Customer__r.name;
                c.CUSTOMERNUM = cus.Owning_Customer_ID__c;
                c.CORES = cus.Corecount__c;
                TotCore = TotCore + c.CORES;
                   
                c.NoOfSKUGovernedByActiveWrittenAgreement = cus.NoOfSKUGovernedByActiveWrittenAgreement__c;   //ROM 10B
                
                //c.ANNUALSPEND = cus.Item_12_Month_Qty__c;
                c.ANNUALSPEND = cus.Customer_Annual_Spend__c;
                c.ANNSPEND_CHNGEAMNT = cus.Total_Spend_Impact_12_Month__c;
                c.SRMIMPACT = cus.SRM_Differential__c;
                c.IMPSTATUS = cus.Implementation_Status3__c; 
                
                c.IMPSTATUSCODE = cus.implementation_status_code__c;
                c.IMPSTATUSIMG = cus.Implementation_Status_Image__c;
                c.NOTSTATUS = cus.Notification_Status__c;
  
                c.APPROVDDATE = cus.Sales_Price_Change_Effective_Date_Min__c;
                c.NOTIFYDATE = cus.Customer_Notification_Date_Approved__c;
                c.TOTCORE = TotCore;                               
                c.OWNERNAME = cus.Customer__r.Owner.Name;
                
                if(cus.Owning_Customer_ID__c.contains('99999ACE'))
                    c.isSTDCore = true;
                else
                    c.isSTDCore = false;
                
                if(cus.New_Gross_IGM__c != null && cus.New_Gross_IGM1__c != null){
                    c.NEWIGMDOLLAR = cus.New_Gross_IGM__c;
                    c.NEWIGMPERCENT = cus.New_Gross_IGM1__c;
                }
                else{
                    c.NEWIGMDOLLAR = 0;
                    c.NEWIGMPERCENT = 0;
                }
                
                c.ISRELEASEALLOWED = acerel.ReleaseAllowed(cus, Date.Today());
                List<Ace_Customer_Core_Changes__c> coreList= new List<Ace_Customer_Core_Changes__c>();
                 

                 if(customer_with_sku_counts.get(cus.id) != null)
                     c.SKUS = customer_with_sku_counts.get(cus.id);
                 else
                     c.SKUS = 0;
                 
                // c.SKUS_val = '' + customer_with_core_counts.get(cus.id);
                // Commented by Deepak - Query in Loop, need to be replaced - ends
                
                    c.RELCHECK= false;
                    c.NOTCHECK= false;
                    c.NOTIFYCHECK= false;
                    
                    
                    
                    if(pageParam == '3')
                    {
                        if(!passRelSelected.isEmpty()){
                            if(passRelSelected.contains(c.ID))
                            c.RELCHECK= true;
                        else 
                            c.RELCHECK= false;
                        }
                    }
                    
                    if(pageParam == '2')
                    {
                        if(!passRelSelected_notify.isEmpty()){
                            if(passRelSelected_notify.contains(c.ID))
                                c.RELCHECK= true;
                            else 
                                c.RELCHECK= false;
                        }
                    }
                    
                    if(pageParam == '1')
                    {
                        if (cus.Customer_Notification_Date_Approved__c == Date.Today())
                           c.NOTIFYCHECK= true;
                           
                        if(!passNotifySelected.isEmpty()){
                            if(passNotifySelected.contains(c.ID))
                                c.NOTCHECK= true;
                            else 
                                c.NOTCHECK= false;
                        }
                        
                        if(!passRelSelected_noreq.isEmpty()){
                                if(passRelSelected_noreq.contains(c.ID))
                                    c.RELCHECK= true;
                            else 
                                c.RELCHECK= false;
                        }
                    }
               
                if((cus.Total_Spend_Impact_12_Month__c!=null && cus.Total_Spend_Impact_12_Month__c!=0.00) && (cus.Item_12_Month_Sales__c!=null && cus.Item_12_Month_Sales__c!=0.00))
                            c.AVGCHANGE = ((cus.Total_Spend_Impact_12_Month__c/cus.Item_12_Month_Sales__c)*100).setScale(2);  
                        else
                            c.AVGCHANGE = 0.00;
                
                if((cus.Total_Spend_Impact_12_Month__c!=null && cus.Total_Spend_Impact_12_Month__c!=0.00) && (cus.Item_12_Month_Qty__c!=null && cus.Item_12_Month_Qty__c!=0.00))                  
                        c.SPNDIMPACT = (cus.Total_Spend_Impact_12_Month__c/cus.Item_12_Month_Qty__c).setScale(2);
                else
                        c.SPNDIMPACT = 0.00;
                 
                clsCusListTable1.add(c);
            }
          }  
         
         System.debug('value of getfieldName ' + getfieldName);
         
         if((getfieldName_noreq == 'SKU') || (getfieldName_notify == 'SKU') || (getfieldName == 'SKU'))
         {
             sortByField = 'SKUS';
             //clsCusListTable1.sort();
         }
         
         return clsCusListTable1;
    }
    
    public PageReference SubmitRelease()
    {
        try{
        releaseEarly_common('3', passRelSelected,passNotifySelected,clsCusListTable);
        passRelSelected.clear();
        geturl();
        }
        catch(Exception e)
        {
            System.debug('value of error' + e.getMessage());
        }
         
        return null;
    }
    
    public PageReference  SubmitRelease_notify()
    {
        releaseEarly_common('2', passRelSelected_notify,passNotifySelected,clsCusListTable_notify);
        passRelSelected_notify.clear();
        geturl();
                return null;
    }

    public PageReference  SubmitRelease_noreq()
    {
        releaseEarly_common('1', passRelSelected_noreq,passNotifySelected,clsCusListTable_noreq);
        passRelSelected_noreq.clear();
        passNotifySelected.clear();
        geturl();
                return null;
    }
    
    public PageReference  releaseEarly_common(String PageParam, Set<ID> passRelSelected1 ,Set<ID> passNotifySelected1, List<custListTable> clsCusListTable) 
    {
        
        Set<AceReleaseCommon.releaseRequest> relreqList = new Set<AceReleaseCommon.releaseRequest>();
        Set<AceReleaseCommon.releaseRequest> notreqList = new Set<AceReleaseCommon.releaseRequest>();//
        list<ace_customer_price_changes__c> acpcUpd = new list<ace_customer_price_changes__c> ();
        
        //Reconstruct the Selection Set, this is required for the list of records that the Rep is currently viewing
        for (custListTable c: clsCusListTable) 
        {
            if (c.RELCHECK)
               passRelSelected1.add(c.ID);
            
            if(PageParam == '1')   
            {
                 if (c.NOTCHECK)//
                   passNotifySelected1.add(c.ID);
            }       
        }
        if(passRelSelected1.size() <=0 && passNotifySelected.size() <=0){
              renderError = true;
          }
        if(passRelSelected1.size() >0){
            renderRelConfirm = true;
        }
        if(passNotifySelected1.size() >0){
            renderNotConfirm = true;
        }
        if(renderRelConfirm==true && renderRelConfirm==true){
            renderBothConfirm = true;
        }  
        //if() guha
        
        System.debug('>>>>>>>>>>>>>>>>' + passRelSelected1);
        if(pageparam != '1')
        {
            For (ace_customer_price_changes__c a: [SELECT ID,customer__r.remediation_required__c,customer_Notification_Date_Approved__c,customer__r.ownerid,requirement_window__c,Sales_Price_Change_Effective_Date_Rep__c,Sales_Price_Change_Effective_Date_Min__c,Sales_Price_Change_Effective_Date_Approv__c from ace_customer_price_changes__c where ID = :passRelSelected1 AND IsRemediation__c = false]) 
            {
                a.customer_notification_date_rep__c = Date.Today();
                AceReleaseCommon.releaseRequest relreq = new  AceReleaseCommon.releaseRequest();
                relreq.acp = a;
                relreqList.add(relreq);
            }
            
            // relrespList = acerel.Release(relreqList); 
            if (relreqList.size()  > 0) 
                    {
                     relrespList = acerel.Release(relreqList); 
                     for (AceReleaseCommon.releaseResponse rsp : relrespList) 
                     {
                        if (!rsp.returnstatus) 
                        {  
                            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,rsp.errorMessage));
                            
                            return null;
                          break;
                        }  
                     }
                    }
        }
        else
        {
                For (ace_customer_price_changes__c a: [SELECT ID,customer__r.remediation_required__c,customer_Notification_Date_Approved__c,customer__r.ownerid,requirement_window__c,sfdc_notification_flag__c,Sales_Price_Change_Effective_Date_Min__c,Sales_Price_Change_Effective_Date_Approv__c,Sales_Price_Change_Effective_Date_Rep__c from ace_customer_price_changes__c where ID = :passRelSelected1 AND IsRemediation__c = false]) 
                {
                    a.Sales_Price_Change_Effective_Date_Rep__c = Date.Today();
                    AceReleaseCommon.releaseRequest relreq = new  AceReleaseCommon.releaseRequest();
                    relreq.acp = a;
                    relreqList.add(relreq);
                }
                For (ace_customer_price_changes__c a: [SELECT ID,customer_Notification_Date_Approved__c,requirement_window__c,Sales_Price_Change_Effective_Date_Rep__c from ace_customer_price_changes__c where ID = :passNotifySelected1 AND IsRemediation__c = false]) 
                {
                        //a.Sales_Price_Change_Effective_Date_Rep__c = Date.Today();
                        AceReleaseCommon.releaseRequest notreq = new  AceReleaseCommon.releaseRequest();
                        notreq.acp = a;
                        notreqList.add(notreq);
                        
                        
                }
            
                    //commented to avoid accidental release while testing.
                    if (relreqList.size()  > 0) 
                    {
                     relrespList = acerel.Release(relreqList); 
                     for (AceReleaseCommon.releaseResponse rsp : relrespList) 
                     {
                        if (!rsp.returnstatus) 
                        {  
                            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,rsp.errorMessage));
                            
                            return null;
                          break;
                        }  
                     }
                    }
                    if (notreqList.size() > 0)
                     notrespList = acerel.Notify(notreqList);//
        
        }
        
        
        
        
        System.debug('>>>>>relrespList >>>>>>>>>>>' + relrespList );
        
        passRelSelected1.clear();
        passNotifySelected1.clear();
       return null;
    }
    
   
    
    
    public void processSelected()
    {     
          selectedCount = 0;
               system.debug('>>>>>>>>>');
                    
          for(custListTable cWrapper : clsCusListTable)
          { 
              if(cWrapper.RELCHECK)
              {                   
                    passRelSelected.add(cWrapper.ID);                    
                    System.debug('<<<<<<<<<<'+passRelSelected);
              }
              else if(passRelSelected.contains(cWrapper.ID))
              {
                   passRelSelected.remove(cWrapper.ID);
              }
          }
          
          selectedCount = passSelected.size();
          
    }
    
    
     public void processSelected_notify(){     
        selectedCount = 0;   //
               system.debug('>>>>>>>>>');
                    
          for(custListTable cWrapper : clsCusListTable_notify){ 
               //system.debug('>>>>>>>>>84'+cWrapper.RELCHECK); 
               if(cWrapper.RELCHECK){                   
                    passRelSelected_notify.add(cWrapper.ID);                    
                    system.debug('<<<<<<<<<<'+passRelSelected_notify);
               }
               else if(passRelSelected_notify.contains(cWrapper.ID)){
                   passRelSelected_notify.remove(cWrapper.ID);
               }
                                      
                 
          }
          selectedCount = passSelected_notify.size();
          if(selectedCount <=0){
              renderError = true;
          }
     }
    
    public void processSelected_noreq(){     
        selectedCount = 0;   //
               system.debug('>>>>>>>>>');
                    
          for(custListTable cWrapper : clsCusListTable_noreq){ 
               //system.debug('>>>>>>>>>84'+cWrapper.RELCHECK);                        
               if(cWrapper.NOTCHECK){                   
                    passNotifySelected.add(cWrapper.ID);                    
                    system.debug('>>>>>>>>>'+passNotifySelected);
               }
               else if(passNotifySelected.contains(cWrapper.ID)){
                   passNotifySelected.remove(cWrapper.ID);
               }
               if(cWrapper.RELCHECK){                   
                    passRelSelected_noreq.add(cWrapper.ID);                    
                    system.debug('<<<<<<<<<<'+passRelSelected_noreq);
               }
               else if(passRelSelected_noreq.contains(cWrapper.ID)){
                   passRelSelected_noreq.remove(cWrapper.ID);
               }
           }   
           if(passRelSelected_noreq.size() <= 0 && passNotifySelected.size() <= 0){
              renderError = true;
           } 
     }
    
    
    
    

    
    public void sortCust() 
    {
        
        system.debug('%%%%%%%%%%'+getFieldName);
        if(getFieldName == 'Customer'){
            fieldName = 'Customer__r.name'; 
            system.debug('%%%%%%%%%%'+getFieldName);
            }
        else if(getFieldName == 'Cores'){
            fieldName = 'Corecount__c'; }
        else if(getFieldName == 'SKU'){
            fieldName = 'SKUcount__c';}
        
        else if(getFieldName == 'NoOfSKUGovernedByActiveWrittenAgreement'){
            fieldName = 'NoOfSKUGovernedByActiveWrittenAgreement__c';}       //ROM Item 10B  
        
        else if(getFieldName == 'annualspend'){
            fieldName = 'Item_12_Month_Qty__c'; }
        else if(getFieldName == 'annualspndchange'){
            fieldName = 'Total_Spend_Impact_12_Month__c';}
        
        else if(getFieldName == 'srmimpact'){
            fieldName = 'SRM_Differential__c'; }
        else if(getFieldName == 'effectiveDate'){
            fieldName = 'Sales_Price_Change_Effective_Date_Min__c'; }
        else if(getFieldName == 'notifydate'){
            fieldName = 'Customer_Notification_Date_Approved__c'; }
        else if(getFieldName == 'Reps'){
            fieldName = 'Customer__r.Owner.Name';}
        
        if(tabAsc){
            sortDirection = 'DESC';
            tabAsc = false;            
        }
        else {
            sortDirection = 'ASC';
            tabAsc = true;             
        }  
        system.debug('get url call3');
        
        if(!Test.isRunningTest()){ 
        getURL();  
        }
    }
    
     public void sortCust_notify() 
     {
         if(getFieldName_notify == 'Customer'){
            fieldName_notify = 'Customer__r.name';}
        else if(getFieldName_notify == 'Cores'){
            fieldName_notify = 'Corecount__c';}
        else if(getFieldName_notify == 'SKU'){
            fieldName_notify = 'SKUcount__c';}
         
        else if(getFieldName_notify == 'NoOfSKUGovernedByActiveWrittenAgreement'){
            fieldName_notify = 'NoOfSKUGovernedByActiveWrittenAgreement__c';}       //ROM Item 10B   
        
        else if(getFieldName_notify == 'annualspend'){
            fieldName_notify = 'Item_12_Month_Qty__c';}
        else if(getFieldName_notify == 'annualspndchange'){
            fieldName_notify = 'Total_Spend_Impact_12_Month__c';}
        
        else if(getFieldName_notify == 'srmimpact'){
            fieldName_notify = 'SRM_Differential__c';}
        else if(getFieldName_notify == 'effectiveDate'){
            fieldName_notify = 'Sales_Price_Change_Effective_Date_Min__c';}
        else if(getFieldName_notify == 'notifydate'){
            fieldName_notify = 'Customer_Notification_Date_Approved__c';}
         else if(getFieldName_notify == 'Reps'){
            fieldName_notify = 'Customer__r.Owner.Name';}
            
        if(tabAsc_notify){
            sortDirection_notify = 'DESC';
            tabAsc_notify = false;            
        }
        else {
            sortDirection_notify = 'ASC';
            tabAsc_notify = true;             
        }
          
        if(!Test.isRunningTest()){ 
        getURL();  
        }
    }
    
    public void sortCust_noreq() {
        if(getFieldName_noreq == 'Customer'){
            fieldName_noreq = 'Customer__r.name';}
        else if(getFieldName_noreq == 'Cores'){
            fieldName_noreq = 'Corecount__c';}
       else if(getFieldName_noreq == 'SKU'){
            fieldName_noreq = 'SKUcount__c';}
        
        else if(getFieldName_noreq == 'NoOfSKUGovernedByActiveWrittenAgreement'){
            fieldName_noreq = 'NoOfSKUGovernedByActiveWrittenAgreement__c';}        //ROM Item 10B
        
        else if(getFieldName_noreq == 'annualspend'){
            fieldName_noreq = 'Item_12_Month_Qty__c';}
        else if(getFieldName_noreq == 'annualspndchange'){
            fieldName_noreq = 'Total_Spend_Impact_12_Month__c';}
        
        else if(getFieldName_noreq == 'srmimpact'){
            fieldName_noreq = 'SRM_Differential__c';}
        else if(getFieldName_noreq == 'effectiveDate'){
            fieldName_noreq = 'Sales_Price_Change_Effective_Date_Min__c';}
        else if(getFieldName_noreq == 'notifydate'){
            fieldName_noreq = 'Customer_Notification_Date_Approved__c';}
        else if(getFieldName_noreq == 'Reps'){
            fieldName_noreq = 'Customer__r.Owner.Name';}
        
        
        if(tabAsc_noreq){
            sortDirection_noreq = 'DESC';            
            tabAsc_noreq = false;            
        }
        else {
            sortDirection_noreq = 'ASC';            
            tabAsc_noreq = true;             
        }  
        if(!Test.isRunningTest()){ 
        getURL();  
        }
    }
    
    
}