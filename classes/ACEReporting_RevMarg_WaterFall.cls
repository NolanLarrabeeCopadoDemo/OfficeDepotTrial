public class ACEReporting_RevMarg_WaterFall 
{

    public PageReference SearchRecords() {
        if(reportType=='Notification' || reportType=='Response' ||reportType=='Compliance'){ //sfdc 00910713 - added compliance
            loadCustomerNotifyResponseData();
        }
        else if(reportType == 'ChangeType'){
            loadChangeTypeDataCustomerList();
        }
        else if(reportType == 'Summary'){//sfdc 861332:changed the report name
            CustListOverviewReportData();
        }
        else if(ErosionType=='Price'){
                loadErosionPriceData();
        }
        else if(ErosionType=='Date'){
                loadErosionDateData(); 
        }
        else if(reportType=='Customer Not Receiving Full Increase'){
            loadDataCustNotFullInc();
        }   
        else if(reportType=='Summary By Region' || reportType=='Summary by Sector/Segment' || reportType=='Summary by Participation (Buying Group/GPO)' || reportType=='Summary by Industry/Vertical Market'){////sfdc 910700,910698,910696,910703,910701,910703 - changed the report NAME
            loadCustomerListData();       
        }
        else if(reportType=='Remediation'){
            RemediationReportCustList();
        }
        else if(reportType=='Hosted Catalog'){
            HostedCatalogReportCustList();
        }
        else if(reportType=='Process Progress/PipeLine'){
            CustListProcssProgReportData();      
        }
        else if(reportType=='Exception'){
            ExceptionReportCustList();      
        }
        
        return null;
    }
    
    private static Map<String,Schema.RecordTypeInfo> CaseRecType = Schema.SObjectType.Case.getRecordTypeInfosByName();
    public id caseRecordType = CaseRecType.get('Work Request').getRecordTypeId();
    public String Searchtype{get;set;}
    public String searchWord { get; set; }
    public String searchWordSKU { get; set; }

    public class changeTypeData{
         public String formatType {get;set;}
         Public String UrlType{get;set;}
         public String dataType {get;set;}
         
         public Transient Decimal Proposed{get;set;}
         public Transient Decimal MargProp{get;set;}
         public Transient Decimal Executed{get;set;}
         public Transient Decimal MargExecuted{get;set;}
         public Transient Decimal AltSelected{get;set;}
         public Transient Decimal MargIncAlt{get;set;}
         public Transient Decimal TotMargInc{get;set;}
    }
    
    public Transient list<changeTypeData> ctd {get;set;}
    //public Map<String,String> fmt; 
    public Transient Boolean renderChangeType {get;set;}   
  
    public String getFieldName{get;set;}
    public String sortfieldName{get;set;}
    public Boolean tabAsc{get;set;}
    public String sortDirection {get;set;}
    public Integer Counter{get;set;}
    public Integer List_size = 20;
    public Integer total_size{get;set;}
    public Integer total_size_price{get;set;}
    
    public Transient List<String> sSectors {get;set;}  
    public Transient Set<String> sTempSectors {get;set;}  
    public Transient List<ReportDataCls> ovd {get;set;}
    public Transient Map<String,String> fmt;
   
    public String AccessLevel{get;set;}
    public String quarterValue{get;set;}
    public string compStatus{get;set;}//sfdc 910713
    public string SKUDownload{get;set;}//sfdc 910711
   
    public String expandLabel{ get; set; }
    public String OwnerValue{ get; set; }
    public String reportType{get;set;}
    // public String DDName{get;set;}
    public String SegmentName{get;set;}
    public String SegmentType{get;set;}
    public String ReportName{get;set;}
    public String Rptyp{get;set;}
    
    public String RowName{get;set;}
    public String quarter{get;set;}
    public String ErosionType{ get; set; }
    public String ColumnVal{get;set;}
    public String listType{get;set;}
    
    public Transient List<ACE_Customer_Price_Changes__c> custList{get;set;}
    public Transient List<ReportDataCls> lFinalReportData{get;set;}
    public ACEReporting_RevMarg_WaterFall()
    { 
        sortfieldName = 'Customer__r.name';
        sortDirection = 'ASC';
        Counter = 0;
        tabAsc = false;
        searchWord ='';
        system.debug('>>>>>><<<<<<<<'+quarterValue);
        ACE_Batches__c bt = [SELECT Id, Batch__c FROM ACE_Batches__c order by CreatedDate desc limit 1];
        quarterValue = bt.Batch__c; 
        compStatus = 'All';//sfdc 910713
        reportType = ApexPages.CurrentPage().getParameters().get('reportType');
        SegmentName = ApexPages.CurrentPage().getParameters().get('Segment');
        SegmentType = ApexPages.CurrentPage().getParameters().get('SegmentType');
        ReportName = ApexPages.CurrentPage().getParameters().get('Val');
        ErosionType = ApexPages.CurrentPage().getParameters().get('ErosionType');
        quarter = ApexPages.CurrentPage().getParameters().get('quarter');
        ColumnVal = ApexPages.CurrentPage().getParameters().get('Column');
        rowname = ApexPages.CurrentPage().getParameters().get('rowName');
        listType =ApexPages.CurrentPage().getParameters().get('listtype');
        Rptyp=ApexPages.CurrentPage().getParameters().get('Rptyp');       
        
         
        system.debug('>>>>>><<<<<<<<'+rowName);
        if(reportType == 'Notification' || reportType == 'Response' ||reportType=='Compliance'){ //sfdc 00910713 - added compliance
            getFieldName = 'CustomerId';
            sortfieldName = 'Customer__r.Cust_ID__c';
            sortDirection = 'ASC';
        }
        
        
        if(ErosionType == 'Date')
        {
            getFieldName = 'Customer';
            sortfieldName = 'Customer__r.name';             
        }
        else if(ErosionType == 'Price')
        {
            getFieldName = 'SKU';
            sortfieldName = 'SKU__c'; 
        }
        else if(reportType == 'Vendavo')
        {                      
            getFieldName = 'TransmissionDate';
            sortfieldName = 'Sales_Price_Change_Effective_Date_Approv__c'; 
            system.debug('%%%%%%%%%%'+getFieldName);
            sortDirection = 'ASC';
            
            //sfdc 910711
        	Searchtype = ApexPages.currentPage().getParameters().get('Searchtype');
        	searchWord = ApexPages.currentPage().getParameters().get('searchWord');
        	searchWordSKU = ApexPages.currentPage().getParameters().get('searchWordSKU');
            SKUDownload = ApexPages.currentPage().getParameters().get('SKUDownload');
        	//sfdc 910711
        }
        //Setting Access Level
        AccessLevel = 'General';
        renderChangeType  = false;
        
        //User Hierarchy code - Starts
        For (Group g : [select id,name from group where name in ('Sales Ops Team')]){ 
            system.debug('<<<<<<<<<<<<>>>>>>>>>>');
             for (groupMember gm : [SELECT id from groupmember where groupid = :g.id and UserOrGroupId = :userinfo.getUserId()]) {
                AccessLevel = 'SalesOps';
                renderChangeType = true; 
                system.debug('Sales Ops Team user:userinfo.getUserId():'+userinfo.getUserId());      
             }
        }
        system.debug('<<<<<<<<<<<<Quarter>>>>>>>>>>'+quarterValue);
       
        if(quarter != null && quarter != '')
        {
            quarterValue = quarter;
        }             
           
       // if(ReportName == 'Erosion')
       //      loadErosionData();
       // else if(reportType == 'Exception')
       //     loadExceptionData();
       // else    
       //     loadData();                                              
    }
    
    public List<ACE_Customer_Price_Changes__c> getACECustomerList()
    {
        custList = new List<ACE_Customer_Price_Changes__c>();  
         boolean userExistsinRemediation = false;
        
        For (Group g : [select id,name from group where name in ('Remediation Team')]){ 
            system.debug('<<<<<<<<<<<<>>>>>>>>>>');
            for (groupMember gm : [SELECT id from groupmember where groupid = :g.id and UserOrGroupId = :userinfo.getUserId()]){                
                system.debug('Remediation user:userinfo.getUserId():'+userinfo.getUserId());
                userExistsinRemediation = true;}
        }      
        system.debug('userinfo.getUserId():'+userinfo.getUserId());       
        if(AccessLevel == 'General')
        { 
            if (reportType == 'Remediation' && userExistsinRemediation)
              custList = [select id from ACE_Customer_Price_Changes__c where Name=: quarterValue and PRICE_NOT_CALCULATED__c = false];
            else {
            system.debug('<<<<<<<<<<<<GENERAL>>>>>>>>>>'); 
            List<User> userList = new List<User>();
            ACE_User_Cust_Hierarchy_Controller obj = new ACE_User_Cust_Hierarchy_Controller();
            UserList = obj.lUserList;//list of loggedin user(sobject) or users(sobjects) under a loggedin manager           
            system.debug('ownerlist:' + UserList);
            Set<ID> ownerList = new Set<ID>();
            for(User u : UserList)
            {
                ownerList.add(u.id);
            }                    
            
            //Collection of customers
            Set<ID> sID_ACE_Price_ID = new Set<ID>(); 
            system.debug('Total Users:' + ownerlist.size());
            sID_ACE_Price_ID = obj.CustomerPriceChangeRecs(ownerList,'All',quarterValue);
            system.debug('Total Customers To Collect:' + sID_ACE_Price_ID.size());
                
            //sfdc 910713 - added Compliance type in the below if condition
            if(reportType=='Exception'||reportType=='Notification'||reportType=='Response' || reportType=='Compliance' || reportType=='Customer Not Receiving Full Increase' || reportType=='Remediation' || reportType=='Hosted Catalog'){
                custList = [select id from ACE_Customer_Price_Changes__c where id in:sID_ACE_Price_ID and PRICE_NOT_CALCULATED__c = false]; 
            }            
            else{
                custList = [select id from ACE_Customer_Price_Changes__c where id in:sID_ACE_Price_ID];
            }
           }
        }
        else
        {
            system.debug('<<<<<<<<<<<<SALES OPS>>>>>>>>>>');
            //sfdc 910713 - added Compliance type in the below if condition
            if(reportType=='Exception'||reportType=='Notification'||reportType=='Response' || reportType=='Compliance' || reportType=='Customer Not Receiving Full Increase' || reportType=='Remediation' || reportType=='Hosted Catalog'){
                custList = [select id from ACE_Customer_Price_Changes__c where Name=: quarterValue and PRICE_NOT_CALCULATED__c = false]; 
            }
            else{
                custList = [select id from ACE_Customer_Price_Changes__c where Name=: quarterValue]; 
            }    
            
        }
        
        if(reportType == 'Hosted Catalog')
        {
            CS = new ACE_Settings__c();
            CS = [select Domain_URL__c from ACE_Settings__c order by CreatedDate Desc limit 1];
            lStringHostedCustURL= new List<String>();
            if(CS.Domain_URL__c != null){
                for(ACE_Customer_Price_Changes__c cus: custlist)
                {
                    lStringHostedCustURL.add(''+ CS.Domain_URL__c +'/'+ cus.id);
                }
            }
        }
        
        system.debug('custlist.size():'+custlist.size());
        return custlist;
        
    }
    
    public List<String> lStringHostedCustURL{get;set;}
    public ACE_Settings__c CS{get;set;}
    //Code Starts  - Change Type Reporting
    
    public List<ACE_Customer_SKU_Changes__c> lChangeTypeReportDataList {get;set;}
    public PageReference loadChangeTypeDataCustomerList()
    {
        //for initial Customr list
        sortfieldName = 'Ace_Customer_core_changes__r.ACE_Customer_Price_Changes__r.Customer__r.name';
        getACECustomerList();
        system.debug('<<<<<<<<<<<<Quarter>>>>>>>>>>'+SegmentName);
        system.debug('Customers Returned from Hierarchy:' + custList.size());
        //User hierarchy code - ends
        
        lChangeTypeReportDataList = new List<ACE_Customer_SKU_Changes__c>();
        
        String ResQuery= '';
        String FieldName = '';

        //Proposed
        if(listtype =='Vendor Cost Increase-Proposed')
                ResQuery = 'Select id,Ace_Customer_core_changes__r.ACE_Customer_Price_Changes__r.New_Gross_IGM__c,Ace_Customer_core_changes__r.ACE_Customer_Price_Changes__r.Total_Spend_Impact_12_Month__c , Reporting_Approved_Price__c,SKU_Description__c ,SKU__c,Reporting_Erosion_Margin_Field_MarkDown__c,Reporting_Erosion_Field_MarkDown__c,Approved_Proposed_Price__c,Proposed_Price_with_Cap__c,Current_Sell_Price__c,Ace_Customer_core_changes__r.ACE_Customer_Price_Changes__r.Customer__r.id,Ace_Customer_core_changes__r.ACE_Customer_Price_Changes__r.Customer__r.Name,Ace_Customer_core_changes__r.ACE_Customer_Price_Changes__r.Customer__r.Aops_Cust_id__c from ACE_Customer_SKU_Changes__c where Price_Changes_Type__c = \'C\' and Ace_Customer_Core_Changes__r.Ace_Customer_Price_Changes__r.Name=: quarterValue'; //+quarterValue;
       
        if(listtype =='Margin Lifts-Proposed')
                ResQuery = 'Select id,Ace_Customer_core_changes__r.ACE_Customer_Price_Changes__r.New_Gross_IGM__c,Ace_Customer_core_changes__r.ACE_Customer_Price_Changes__r.Total_Spend_Impact_12_Month__c , Reporting_Approved_Price__c,SKU_Description__c ,SKU__c,Reporting_Erosion_Margin_Field_MarkDown__c,Reporting_Erosion_Field_MarkDown__c,Approved_Proposed_Price__c,Proposed_Price_with_Cap__c,Current_Sell_Price__c,Ace_Customer_core_changes__r.ACE_Customer_Price_Changes__r.Customer__r.id,Ace_Customer_core_changes__r.ACE_Customer_Price_Changes__r.Customer__r.Name,Ace_Customer_core_changes__r.ACE_Customer_Price_Changes__r.Customer__r.Aops_Cust_id__c from ACE_Customer_SKU_Changes__c where Price_Changes_Type__c = \'M\' and Margin_Play__c = \'L\' and Ace_Customer_Core_Changes__r.Ace_Customer_Price_Changes__r.Name =: quarterValue';//+quarterValue;
       
        if(listtype =='Margin Swaps-Proposed')
                ResQuery = 'Select id,Ace_Customer_core_changes__r.ACE_Customer_Price_Changes__r.New_Gross_IGM__c,Ace_Customer_core_changes__r.ACE_Customer_Price_Changes__r.Total_Spend_Impact_12_Month__c , Reporting_Approved_Price__c,SKU_Description__c ,SKU__c,Reporting_Erosion_Margin_Field_MarkDown__c,Reporting_Erosion_Field_MarkDown__c,Approved_Proposed_Price__c,Proposed_Price_with_Cap__c,Current_Sell_Price__c,Ace_Customer_core_changes__r.ACE_Customer_Price_Changes__r.Customer__r.id,Ace_Customer_core_changes__r.ACE_Customer_Price_Changes__r.Customer__r.Name,Ace_Customer_core_changes__r.ACE_Customer_Price_Changes__r.Customer__r.Aops_Cust_id__c from ACE_Customer_SKU_Changes__c where Price_Changes_Type__c = \'M\' and Margin_Play__c = \'S\' and Ace_Customer_Core_Changes__r.Ace_Customer_Price_Changes__r.Name =: quarterValue';//+quarterValue;
        
        if(listtype =='Discontinued SKUs-Proposed')
                ResQuery = 'Select id,Ace_Customer_core_changes__r.ACE_Customer_Price_Changes__r.New_Gross_IGM__c,Ace_Customer_core_changes__r.ACE_Customer_Price_Changes__r.Total_Spend_Impact_12_Month__c , Reporting_Approved_Price__c,SKU_Description__c ,SKU__c,Reporting_Erosion_Margin_Field_MarkDown__c,Reporting_Erosion_Field_MarkDown__c,Approved_Proposed_Price__c,Proposed_Price_with_Cap__c,Current_Sell_Price__c,Ace_Customer_core_changes__r.ACE_Customer_Price_Changes__r.Customer__r.id,Ace_Customer_core_changes__r.ACE_Customer_Price_Changes__r.Customer__r.Name,Ace_Customer_core_changes__r.ACE_Customer_Price_Changes__r.Customer__r.Aops_Cust_id__c from ACE_Customer_SKU_Changes__c where Price_Changes_Type__c = \'D\' and Ace_Customer_Core_Changes__r.Ace_Customer_Price_Changes__r.Name =: quarterValue';//+quarterValue;

        //Executed
        if(listtype =='Margin Lifts-Executed')
                ResQuery = 'Select id,Ace_Customer_core_changes__r.ACE_Customer_Price_Changes__r.New_Gross_IGM__c,Ace_Customer_core_changes__r.ACE_Customer_Price_Changes__r.Total_Spend_Impact_12_Month__c , Reporting_Approved_Price__c,SKU_Description__c ,SKU__c,Reporting_Erosion_Margin_Field_MarkDown__c,Reporting_Erosion_Field_MarkDown__c,Approved_Proposed_Price__c,Proposed_Price_with_Cap__c,Current_Sell_Price__c,Ace_Customer_core_changes__r.ACE_Customer_Price_Changes__r.Customer__r.id,Ace_Customer_core_changes__r.ACE_Customer_Price_Changes__r.Customer__r.Name,Ace_Customer_core_changes__r.ACE_Customer_Price_Changes__r.Customer__r.Aops_Cust_id__c from ACE_Customer_SKU_Changes__c where ace_customer_core_changes__r.ace_customer_price_changes__r.Implementation_Status_Code__c = \'DATA-SUCCESS\' and status__c != \'Inactive\' and Price_Changes_Type__c = \'M\' and Margin_Play__c = \'L\' and Ace_Customer_Core_Changes__r.Ace_Customer_Price_Changes__r.Name =: quarterValue';//+quarterValue;
       
        if(listtype =='Vendor Cost Increase-Executed')
                ResQuery = 'Select id,Ace_Customer_core_changes__r.ACE_Customer_Price_Changes__r.New_Gross_IGM__c,Ace_Customer_core_changes__r.ACE_Customer_Price_Changes__r.Total_Spend_Impact_12_Month__c , Reporting_Approved_Price__c,SKU_Description__c ,SKU__c,Reporting_Erosion_Margin_Field_MarkDown__c,Reporting_Erosion_Field_MarkDown__c,Approved_Proposed_Price__c,Proposed_Price_with_Cap__c,Current_Sell_Price__c,Ace_Customer_core_changes__r.ACE_Customer_Price_Changes__r.Customer__r.id,Ace_Customer_core_changes__r.ACE_Customer_Price_Changes__r.Customer__r.Name,Ace_Customer_core_changes__r.ACE_Customer_Price_Changes__r.Customer__r.Aops_Cust_id__c from ACE_Customer_SKU_Changes__c where ace_customer_core_changes__r.ace_customer_price_changes__r.Implementation_Status_Code__c = \'DATA-SUCCESS\' and status__c != \'Inactive\' and Price_Changes_Type__c = \'C\' and Ace_Customer_Core_Changes__r.Ace_Customer_Price_Changes__r.Name=: quarterValue';//+quarterValue;
       
        if(listtype =='Margin Swaps-Executed')
                ResQuery = 'Select id,Ace_Customer_core_changes__r.ACE_Customer_Price_Changes__r.New_Gross_IGM__c,Ace_Customer_core_changes__r.ACE_Customer_Price_Changes__r.Total_Spend_Impact_12_Month__c , Reporting_Approved_Price__c,SKU_Description__c ,SKU__c,Reporting_Erosion_Margin_Field_MarkDown__c,Reporting_Erosion_Field_MarkDown__c,Approved_Proposed_Price__c,Proposed_Price_with_Cap__c,Current_Sell_Price__c,Ace_Customer_core_changes__r.ACE_Customer_Price_Changes__r.Customer__r.id,Ace_Customer_core_changes__r.ACE_Customer_Price_Changes__r.Customer__r.Name,Ace_Customer_core_changes__r.ACE_Customer_Price_Changes__r.Customer__r.Aops_Cust_id__c from ACE_Customer_SKU_Changes__c where ace_customer_core_changes__r.ace_customer_price_changes__r.Implementation_Status_Code__c = \'DATA-SUCCESS\'  and status__c != \'Inactive\' and Price_Changes_Type__c = \'M\' and Margin_Play__c = \'S\' and Ace_Customer_Core_Changes__r.Ace_Customer_Price_Changes__r.Name =: quarterValue';//+ quarterValue;
        
        if(listtype =='Discontinued SKUs-Executed')
                ResQuery = 'Select id,Ace_Customer_core_changes__r.ACE_Customer_Price_Changes__r.New_Gross_IGM__c,Ace_Customer_core_changes__r.ACE_Customer_Price_Changes__r.Total_Spend_Impact_12_Month__c , Reporting_Approved_Price__c,SKU_Description__c ,SKU__c,Reporting_Erosion_Margin_Field_MarkDown__c,Reporting_Erosion_Field_MarkDown__c,Approved_Proposed_Price__c,Proposed_Price_with_Cap__c,Current_Sell_Price__c,Ace_Customer_core_changes__r.ACE_Customer_Price_Changes__r.Customer__r.id,Ace_Customer_core_changes__r.ACE_Customer_Price_Changes__r.Customer__r.Name,Ace_Customer_core_changes__r.ACE_Customer_Price_Changes__r.Customer__r.Aops_Cust_id__c from ACE_Customer_SKU_Changes__c where ace_customer_core_changes__r.ace_customer_price_changes__r.Implementation_Status_Code__c = \'DATA-SUCCESS\' and status__c != \'Inactive\' and Price_Changes_Type__c = \'D\' and Ace_Customer_Core_Changes__r.Ace_Customer_Price_Changes__r.Name =: quarterValue';//+quarterValue;

        //Alts Selected
        if(listtype =='Margin Lifts-AltsSelected')
                ResQuery = 'Select id,Ace_Customer_core_changes__r.ACE_Customer_Price_Changes__r.New_Gross_IGM__c,Ace_Customer_core_changes__r.ACE_Customer_Price_Changes__r.Total_Spend_Impact_12_Month__c , Reporting_Approved_Price__c,SKU_Description__c ,SKU__c,Reporting_Erosion_Margin_Field_MarkDown__c,Reporting_Erosion_Field_MarkDown__c,Approved_Proposed_Price__c,Proposed_Price_with_Cap__c,Current_Sell_Price__c,Ace_Customer_core_changes__r.ACE_Customer_Price_Changes__r.Customer__r.id,Ace_Customer_core_changes__r.ACE_Customer_Price_Changes__r.Customer__r.Name,Ace_Customer_core_changes__r.ACE_Customer_Price_Changes__r.Customer__r.Aops_Cust_id__c from ACE_Customer_SKU_Changes__c where Alternate_Chosen_Flag__c = true and Price_Changes_Type__c = \'M\' and Margin_Play__c = \'L\' and Ace_Customer_Core_Changes__r.Ace_Customer_Price_Changes__r.Name =: quarterValue';//+quarterValue;
       
        if(listtype =='Vendor Cost Increase-AltsSelected')
                ResQuery = 'Select id,Ace_Customer_core_changes__r.ACE_Customer_Price_Changes__r.New_Gross_IGM__c,Ace_Customer_core_changes__r.ACE_Customer_Price_Changes__r.Total_Spend_Impact_12_Month__c , Reporting_Approved_Price__c,SKU_Description__c ,SKU__c,Reporting_Erosion_Margin_Field_MarkDown__c,Reporting_Erosion_Field_MarkDown__c,Approved_Proposed_Price__c,Proposed_Price_with_Cap__c,Current_Sell_Price__c,Ace_Customer_core_changes__r.ACE_Customer_Price_Changes__r.Customer__r.id,Ace_Customer_core_changes__r.ACE_Customer_Price_Changes__r.Customer__r.Name,Ace_Customer_core_changes__r.ACE_Customer_Price_Changes__r.Customer__r.Aops_Cust_id__c from ACE_Customer_SKU_Changes__c where Alternate_Chosen_Flag__c = true and Price_Changes_Type__c = \'M\' and Margin_Play__c = \'S\' and Ace_Customer_Core_Changes__r.Ace_Customer_Price_Changes__r.Name =: quarterValue';//+quarterValue;
       
        if(listtype =='Margin Swaps-AltsSelected')
                ResQuery = 'Select id,Ace_Customer_core_changes__r.ACE_Customer_Price_Changes__r.New_Gross_IGM__c,Ace_Customer_core_changes__r.ACE_Customer_Price_Changes__r.Total_Spend_Impact_12_Month__c , Reporting_Approved_Price__c,SKU_Description__c ,SKU__c,Reporting_Erosion_Margin_Field_MarkDown__c,Reporting_Erosion_Field_MarkDown__c,Approved_Proposed_Price__c,Proposed_Price_with_Cap__c,Current_Sell_Price__c,Ace_Customer_core_changes__r.ACE_Customer_Price_Changes__r.Customer__r.id,Ace_Customer_core_changes__r.ACE_Customer_Price_Changes__r.Customer__r.Name,Ace_Customer_core_changes__r.ACE_Customer_Price_Changes__r.Customer__r.Aops_Cust_id__c from ACE_Customer_SKU_Changes__c where Alternate_Chosen_Flag__c = true and Price_Changes_Type__c = \'C\' and Ace_Customer_Core_Changes__r.Ace_Customer_Price_Changes__r.Name =: quarterValue';//+ quarterValue;
        
        if(listtype =='Discontinued SKUs-AltsSelected')
                ResQuery = 'Select id,Ace_Customer_core_changes__r.ACE_Customer_Price_Changes__r.New_Gross_IGM__c,Ace_Customer_core_changes__r.ACE_Customer_Price_Changes__r.Total_Spend_Impact_12_Month__c , Reporting_Approved_Price__c,SKU_Description__c ,SKU__c,Reporting_Erosion_Margin_Field_MarkDown__c,Reporting_Erosion_Field_MarkDown__c,Approved_Proposed_Price__c,Proposed_Price_with_Cap__c,Current_Sell_Price__c,Ace_Customer_core_changes__r.ACE_Customer_Price_Changes__r.Customer__r.id,Ace_Customer_core_changes__r.ACE_Customer_Price_Changes__r.Customer__r.Name,Ace_Customer_core_changes__r.ACE_Customer_Price_Changes__r.Customer__r.Aops_Cust_id__c from ACE_Customer_SKU_Changes__c where Alternate_Chosen_Flag__c = true and Price_Changes_Type__c = \'D\' and Ace_Customer_Core_Changes__r.Ace_Customer_Price_Changes__r.Name =: quarterValue';//+ quarterValue;

        

       if(ResQuery!='' && ResQuery!= null){
            if((searchWord != null) && (searchWord != '') && (searchWord != 'null'))
            {      
                String textToSearch = searchWord + '%';
                ResQuery = ResQuery+ ' and (SKU__c LIKE \'' + textToSearch + '\' or Ace_Customer_core_changes__r.ACE_Customer_Price_Changes__r.Customer__r.name LIKE \'' + textToSearch + '\') ';
            }

        System.debug('>>>>>>>>>>>>>>>>>>>Query' + ResQuery );
        List<ACE_Customer_SKU_Changes__c> lTotal = new List<ACE_Customer_SKU_Changes__c>();
        lTotal = Database.query(ResQuery);
        total_size= lTotal.size();
        ResQuery = ResQuery + ' order by '+ sortfieldName+' '+sortDirection+' limit :List_size offset :counter';
        lChangeTypeReportDataList = database.query(ResQuery);
        }   
       // for(ACE_Customer_SKU_Changes__c  c: lCustRecs)
       // {
       //         if(c.Approved_Proposed_Price__c < c.Proposed_Price_with_Cap__c)
       //            lErosionPriceReportDataList.add(c); 
       // }
        
        return null;
    }
    
    public void loadChangeTypeData(){    
        system.debug('&&&&&&&&');     
        if(renderChangeType){                           
            ctd = new list<changeTypeData>();
            Map<String,changeTypeData> MAP_ReportData = new Map<String,changeTypeData>();// added by guha        
            
            AggregateResult[] MargLift1= [select count(id) skuCnt, SUM(Proposed_SRM_with_Cap1__c) marg_prop
                                                                   from ace_customer_sku_changes__c 
                                                                   where Price_Changes_Type__c = 'M' and Margin_Play__c = 'L'
                                                                   and Ace_Customer_Core_Changes__r.Ace_Customer_Price_Changes__r.Name =: quarterValue];          
            
            AggregateResult[] MargSwap1= [select count(id) skuCnt, SUM(Proposed_SRM_with_Cap1__c) marg_prop
                                                                   from ace_customer_sku_changes__c 
                                                                   where Price_Changes_Type__c = 'M' and Margin_Play__c = 'S' //SKU_Alt__c != null
                                                                   and Ace_Customer_Core_Changes__r.Ace_Customer_Price_Changes__r.Name =: quarterValue];  
            
            AggregateResult[] VendorCost1= [select count(id) skuCnt, SUM(Proposed_SRM_with_Cap1__c) marg_prop
                                                                   from ace_customer_sku_changes__c 
                                                                   where Price_Changes_Type__c = 'C' 
                                                                   and Ace_Customer_Core_Changes__r.Ace_Customer_Price_Changes__r.Name =: quarterValue];          
            
            AggregateResult[] DiscontSku1= [select count(id) skuCnt, SUM(Proposed_SRM_with_Cap1__c) marg_prop
                                                                   from ace_customer_sku_changes__c 
                                                                   where Price_Changes_Type__c = 'D' 
                                                                   and Ace_Customer_Core_Changes__r.Ace_Customer_Price_Changes__r.Name =: quarterValue] ;         
            
            
            Decimal Proposed1 = Double.valueof(MargLift1[0].get('skuCnt'));
            Decimal MargProposed1 = Double.valueof(MargLift1[0].get('marg_prop'));
            
            Decimal Proposed2 = Double.valueof(VendorCost1[0].get('skuCnt'));
            Decimal MargProposed2 = Double.valueof(VendorCost1[0].get('marg_prop'));
            
            Decimal Proposed3 = Double.valueof(MargSwap1[0].get('skuCnt'));
            Decimal MargProposed3 = Double.valueof(MargSwap1[0].get('marg_prop'));
            
            Decimal Proposed4 = Double.valueof(DiscontSku1[0].get('skuCnt'));
            Decimal MargProposed4 = 0;
            
            
            AggregateResult[] MargLift2= [select count(id) skuCnt, SUM(Proposed_SRM_with_Cap1__c) marg_prop
                                                                   from ace_customer_sku_changes__c 
                                                                   where ace_customer_core_changes__r.ace_customer_price_changes__r.Implementation_Status_Code__c = 'DATA-SUCCESS' 
                                                                   and status__c != 'Inactive'
                                                                   and Price_Changes_Type__c = 'M' and Margin_Play__c = 'L' //SKU_Alt__c = null
                                                                   and Ace_Customer_Core_Changes__r.Ace_Customer_Price_Changes__r.Name =: quarterValue];          
            
            AggregateResult[] MargSwap2= [select count(id) skuCnt, SUM(Proposed_SRM_with_Cap1__c) marg_prop
                                                                   from ace_customer_sku_changes__c 
                                                                   where ace_customer_core_changes__r.ace_customer_price_changes__r.Implementation_Status_Code__c = 'DATA-SUCCESS' 
                                                                   and status__c != 'Inactive'
                                                                   and Price_Changes_Type__c = 'M' and Margin_Play__c = 'S' //SKU_Alt__c != null
                                                                   and Ace_Customer_Core_Changes__r.Ace_Customer_Price_Changes__r.Name =: quarterValue];          
            
            
            AggregateResult[] VendorCost2= [select count(id) skuCnt, SUM(Proposed_SRM_with_Cap1__c) marg_prop
                                                                   from ace_customer_sku_changes__c 
                                                                   where ace_customer_core_changes__r.ace_customer_price_changes__r.Implementation_Status_Code__c = 'DATA-SUCCESS' 
                                                                   and status__c != 'Inactive'
                                                                   and Price_Changes_Type__c = 'C'
                                                                   and Ace_Customer_Core_Changes__r.Ace_Customer_Price_Changes__r.Name =: quarterValue];
            
            AggregateResult[] DiscontSku2= [select count(id) skuCnt, SUM(Proposed_SRM_with_Cap1__c) marg_prop
                                                                   from ace_customer_sku_changes__c 
                                                                   where ace_customer_core_changes__r.ace_customer_price_changes__r.Implementation_Status_Code__c = 'DATA-SUCCESS' 
                                                                   and status__c != 'Inactive'
                                                                   and Price_Changes_Type__c = 'D'
                                                                   and Ace_Customer_Core_Changes__r.Ace_Customer_Price_Changes__r.Name =: quarterValue];        
            
            Decimal Executed1= Double.valueof(MargLift2[0].get('skuCnt'));
            Decimal MargExecuted1 = Double.valueof(MargLift2[0].get('marg_prop'));
                        
            Decimal Executed2= Double.valueof(VendorCost2[0].get('skuCnt'));
            Decimal MargExecuted2 = Double.valueof(VendorCost2[0].get('marg_prop'));
            
            Decimal Executed3= Double.valueof(MargSwap2[0].get('skuCnt'));
            Decimal MargExecuted3 = Double.valueof(MargSwap2[0].get('marg_prop'));
            
            Decimal Executed4= Double.valueof(DiscontSku2[0].get('skuCnt'));
            Decimal MargExecuted4 = 0;
            
            
            AggregateResult[] AltSKU1= [select count(id) skuCnt, SUM(Alternate_Margin__c) altMarg 
                                                                    from ace_customer_sku_changes__c 
                                                                    where Alternate_Chosen_Flag__c = true
                                                                    and Price_Changes_Type__c = 'M'
                                                                    and Margin_Play__c = 'L'
                                                                    and Ace_Customer_Core_Changes__r.Ace_Customer_Price_Changes__r.Name =: quarterValue];
            AggregateResult[] AltSKUS= [select count(id) skuCnt, SUM(Alternate_Margin__c) altMarg 
                                                                    from ace_customer_sku_changes__c 
                                                                    where Alternate_Chosen_Flag__c = true
                                                                    and Price_Changes_Type__c = 'M'
                                                                    and Margin_Play__c = 'S'
                                                                    and Ace_Customer_Core_Changes__r.Ace_Customer_Price_Changes__r.Name =: quarterValue];
            AggregateResult[] AltSKU2= [select count(id) skuCnt, SUM(Alternate_Margin__c) altMarg 
                                                                    from ace_customer_sku_changes__c 
                                                                    where Alternate_Chosen_Flag__c = true
                                                                    and Price_Changes_Type__c = 'C'
                                                                    and Ace_Customer_Core_Changes__r.Ace_Customer_Price_Changes__r.Name =: quarterValue];
            AggregateResult[] AltSKU4= [select count(id) skuCnt, SUM(Alternate_Margin__c) altMarg 
                                                                    from ace_customer_sku_changes__c 
                                                                    where Alternate_Chosen_Flag__c = true
                                                                    and Price_Changes_Type__c = 'D'
                                                                    and Ace_Customer_Core_Changes__r.Ace_Customer_Price_Changes__r.Name =: quarterValue];
            Decimal AltSkuCnt1 = Double.valueof(AltSKU1[0].get('skuCnt'));
            Decimal AltSkuMarg1 = Double.valueof(AltSKU1[0].get('altMarg'));
            
            Decimal AltSkuCntS = Double.valueof(AltSKUS[0].get('skuCnt'));
            Decimal AltSkuMargS = Double.valueof(AltSKUS[0].get('altMarg'));
            
            Decimal AltSkuCnt2 = Double.valueof(AltSKU2[0].get('skuCnt'));
            Decimal AltSkuMarg2 = Double.valueof(AltSKU2[0].get('altMarg'));
            
            Decimal AltSkuCnt3 = 0;
            Decimal AltSkuMarg3 = 0;
            
            Decimal AltSkuCnt4 = Double.valueof(AltSKU4[0].get('skuCnt'));
            Decimal AltSkuMarg4 = Double.valueof(AltSKU4[0].get('altMarg'));
            
            
            
            list<String> dTypes = new list<String> {'Vendor Cost Increase','Margin Lifts','Margin Swaps','Discontinued SKUs'};                     
            
             
            //Margin lift
            changeTypeData o1 = new changeTypeData();            
            o1.Proposed = Proposed1;
            if(MargProposed1!=null) {
                o1.MargProp = MargProposed1;
            }
            else{
                o1.MargProp = 0;
            }
            o1.Executed = Executed1;
            if(MargExecuted1!=null) {
                o1.MargExecuted = MargExecuted1;
            }
            else{
                o1.MargExecuted = 0;
            }
            o1.AltSelected = AltSkuCnt1;
            if(AltSkuMarg1!=null){
                o1.MargIncAlt = AltSkuMarg1;
            }
            else{
                o1.MargIncAlt = 0;
            }
            if(o1.MargExecuted!=null && o1.MargIncAlt!=null)
                o1.TotMargInc = o1.MargExecuted + o1.MargIncAlt ;
            else
                o1.TotMargInc = 0;
            MAP_ReportData.put('Margin Lifts',o1);
             
            //Vendor Cost Increase
            changeTypeData o2 = new changeTypeData();
            o2.Proposed = Proposed2;
            if(MargProposed2!=null) {
                o2.MargProp = MargProposed2;
            }
            else{
                o2.MargProp = 0;
            }
            o2.Executed = Executed2;
            if(MargExecuted2!=null) {
                o2.MargExecuted = MargExecuted2;
            }
            else{
                o2.MargExecuted = 0;
            }
            o2.AltSelected = AltSkuCnt2;
            if(AltSkuMarg2!=null){
                o2.MargIncAlt = AltSkuMarg2;
            }
            else{
                o2.MargIncAlt = 0;
            }
            if(o2.MargExecuted!=null && o2.MargIncAlt!=null)
                o2.TotMargInc = o2.MargExecuted + o2.MargIncAlt ;
            else
                o2.TotMargInc = 0;
            MAP_ReportData.put('Vendor Cost Increase',o2);                
            
            
            //Margin Swaps
            changeTypeData o3 = new changeTypeData();
            o3.Proposed = Proposed3;
            if(MargProposed3!=null) {
                o3.MargProp = MargProposed3;
            }
            else{
                o3.MargProp = 0;
            }
            o3.Executed = Executed3;
            
            if(MargExecuted3!=null) {
                o3.MargExecuted = MargExecuted3;
            }
            else{
                o3.MargExecuted = 0;
            }
            o3.AltSelected = AltSkuCntS;
            //o3.MargIncAlt = 0;
            if(AltSkuMargs!=null){
                o3.MargIncAlt = AltSkuMargs;
            }
            else{
                o3.MargIncAlt = 0;
            }
            
            if(o3.MargExecuted!=null && o3.MargIncAlt!=null)
                o3.TotMargInc = o3.MargExecuted + o3.MargIncAlt ;
            else
                o3.TotMargInc = 0;
            MAP_ReportData.put('Margin Swaps',o3);
            
            //Discontinued SKUs
            changeTypeData o4 = new changeTypeData();
            o4.Proposed = Proposed4;
            if(MargProposed4!=null) {
                o4.MargProp = MargProposed4;
            }
            else{
                o4.MargProp = 0;
            }
            o4.Executed = Executed4;
            //o4.MargExecuted = MargExecuted4;
            if(MargExecuted4!=null) {
                o4.MargExecuted = MargExecuted4;
            }
            else{
                o4.MargExecuted = 0;
            }
            o4.AltSelected = AltSkuCnt4;
            if(AltSkuMarg4!=null){
                o4.MargIncAlt = AltSkuMarg4;
            }
            else{
                o4.MargIncAlt = 0;
            }
            if(o4.MargExecuted!=null && o4.MargIncAlt!=null)
                o4.TotMargInc = o4.MargExecuted + o4.MargIncAlt ;
            else
                o4.TotMargInc = 0;
            MAP_ReportData.put('Discontinued SKUs',o4);
                                   
            // UI table wrapper 
            For (String s: dTypes ) {          
              changeTypeData o = new changeTypeData();
              o.dataType = s;
              o.Proposed = MAP_ReportData.get(s).Proposed;
              o.MargProp = MAP_ReportData.get(s).MargProp ;
              o.Executed = MAP_ReportData.get(s).Executed ;
              o.MargExecuted = MAP_ReportData.get(s).MargExecuted ;
              o.AltSelected = MAP_ReportData.get(s).AltSelected ;
              o.MargIncAlt = MAP_ReportData.get(s).MargIncAlt ;
              o.TotMargInc = MAP_ReportData.get(s).TotMargInc ;         
              ctd.add(o);
              system.debug('>>>>>>>ctd'+ctd);         
            }                  
        }
    }    
    //Code Ends  - Change Type Reporting
    
    
    
    
    /*
    //Customer List  - customer response / notification  by guha  
    public List<ACE_Customer_Price_Changes__c> lCustomerListNotifyResponse {get;set;}
    public PageReference loadCustomerNotifyResponseData()
    {
        //for initial Customr list
        getACECustomerList();      
        system.debug('Customers Returned from Hierarchy:' + custList.size());
        //User hierarchy code - ends
        
        lCustomerListNotifyResponse = new List<ACE_Customer_Price_Changes__c>();        
        String ResQuery= '';
        String FieldName = 'CustomerId';
        List<ACE_Customer_MailOut__c> CustList2 = new List<ACE_Customer_MailOut__c>();
        if(reportType == 'Notification')
        {
            if(sortfieldName == '' || sortfieldName == null)
                sortfieldName = 'Customer__r.Cust_ID__c';
            if(sortDirection == '' || sortDirection ==  null)
                sortDirection = 'ASC';
            if((ColumnVal != '' || ColumnVal != null) && ColumnVal == 'B3'){    
                CustList2 = [Select Customer_Core_Price_Changes__r.id from ACE_Customer_MailOut__c where Customer_Core_Price_Changes__c in:custList and Email_Template_Code__c = '3'];
            }
            else if((ColumnVal != '' || ColumnVal != null) && ColumnVal == 'B2'){
                CustList2 = [Select Customer_Core_Price_Changes__r.id from ACE_Customer_MailOut__c where Customer_Core_Price_Changes__c in:custList and Email_Template_Code__c = '2'];
            }
            else if((ColumnVal != '' || ColumnVal != null) && ColumnVal == 'B1'){
                CustList2 = [Select Customer_Core_Price_Changes__r.id from ACE_Customer_MailOut__c where Customer_Core_Price_Changes__c in:custList and Email_Template_Code__c = '1'];
            }
            else{
                CustList2 = [Select Customer_Core_Price_Changes__r.id from ACE_Customer_MailOut__c where Customer_Core_Price_Changes__c in:custList];
            }
        }
        else if(reportType == 'Response')
        {
            if(sortfieldName == '' || sortfieldName == null)
                sortfieldName = 'Customer__r.Cust_ID__c';
            if(sortDirection == '' || sortDirection ==  null)
                sortDirection = 'ASC';
            if((ColumnVal != '' || ColumnVal != null) && ColumnVal == 'B3'){  
                CustList2 = [Select Customer_Core_Price_Changes__r.id from ACE_Customer_MailOut__c where Customer_Core_Price_Changes__c in:custList and Email_Template_Code__c =:'3'];
            }
            else if((ColumnVal != '' || ColumnVal != null) && ColumnVal == 'callreq'){  
                CustList2 = [Select Customer_Core_Price_Changes__r.id from ACE_Customer_MailOut__c where Customer_Core_Price_Changes__c in:custList and Customer_Core_Price_Changes__r.CallMeRequest__c = true and Email_Template_Code__c =:'3'];
            }
            else if((ColumnVal != '' || ColumnVal != null) && ColumnVal == 'callme'){  
                CustList2 = [Select Customer_Core_Price_Changes__r.id from ACE_Customer_MailOut__c where Customer_Core_Price_Changes__c in:custList and Customer_Core_Price_Changes__r.CallMeRequest__c = true and Customer_Core_Price_Changes__r.Customer_Response__c = 'Call Me' and Email_Template_Code__c =:'3'];
            }
            else if((ColumnVal != '' || ColumnVal != null) && ColumnVal == 'Approved'){  
                CustList2 = [Select Customer_Core_Price_Changes__r.id from ACE_Customer_MailOut__c where Customer_Core_Price_Changes__c in:custList and Customer_Core_Price_Changes__r.Customer_Response__c = 'Approved' and Email_Template_Code__c =:'3'];
            }
            else{                
                CustList2 = [Select Customer_Core_Price_Changes__r.id from ACE_Customer_MailOut__c where Customer_Core_Price_Changes__c in:custList and Email_Template_Code__c =:'3'];
            }
        }
        if(CustList2.size()>0){
            //List<ID> CustList2 = Database.query(ResQuery);
            Set<ID> CustSet = new set<ID>();
            for(ACE_Customer_MailOut__c MO: CustList2){
                CustSet.add(MO.Customer_Core_Price_Changes__r.id);
            }
            String ResQuery1 = 'select Customer__r.Name,Customer__r.Cust_ID__c from ACE_Customer_Price_Changes__c where id in:CustSet';               
            
             //searchWord = searchWord.deleteWhitespace();
            if((searchWord != null) && (searchWord != '') && (searchWord != 'null'))
            {      
                String textToSearch = searchWord + '%';
                ResQuery1 = ResQuery1+ ' and (Owning_Customer_ID__c LIKE \'' + textToSearch + '\' or Customer__r.name LIKE \'' + textToSearch + '\') ';
            }
            
            List<ACE_Customer_Price_Changes__c> lTotal = new List<ACE_Customer_Price_Changes__c>();
            lTotal = Database.query(ResQuery1);
            total_size = lTotal.size();
            
            ResQuery1 = ResQuery1 + ' order by '+ sortfieldName+' '+sortDirection+' limit : List_size offset :counter';
            System.debug('>>>>>>>>>>>>>>>>>>>Query2' + ResQuery1 );
            
            lCustomerListNotifyResponse = database.query(ResQuery1);        
        }
        return null;
    }
    //End of Customer List  - customer response / notification by guha
    */
    //Start of Customer List - Overview Report - Added by Guha.   
    public List<ACE_Customer_Price_Changes__c> lCustListOverviewReportData {get;set;}
    public PageReference CustListOverviewReportData1(){
        getFieldName = 'Customer';
        tabAsc = true;
        CustListOverviewReportData();
        return null;
    }
    
    //sfdc 073477 added below function
    public set<id> custListfromskuobj;
    public void getACECustomerListfromskuobj(){
       	getACECustomerList();
        system.debug('<<<<<<<<<<<<Quarter>>>>>>>>>>'+listType );
        system.debug('Customers Returned from Hierarchy:' + custList.size());
        //User hierarchy code - ends
        custListfromskuobj = new set<id>();     
        AggregateResult[] customersfromskuobj;
        if(listType == 'Initial'){            
            if(rowname == 'Customers with Increases')
                customersfromskuobj = [select ace_customer_core_changes__r.ace_customer_price_changes__r.id cid
                                      				from Ace_Customer_SKU_Changes__c 
                                      				where batchid__c =: quarterValue and
                                      				Ace_Customer_Core_Changes__r.ACE_Customer_Price_Changes__c in:custList                                      				
                                      				group by Ace_Customer_Core_Changes__r.ACE_Customer_Price_Changes__r.id];            
            else if(rowname == 'Revenue Pass Through (Cost Increase)')
                customersfromskuobj = [select ace_customer_core_changes__r.ace_customer_price_changes__r.id cid
                                      				from Ace_Customer_SKU_Changes__c 
                                      				where batchid__c =: quarterValue and Price_Change_Type__c = 'C' and
                                      				Ace_Customer_Core_Changes__r.ACE_Customer_Price_Changes__c in:custList                                      				
                                      				group by Ace_Customer_Core_Changes__r.ACE_Customer_Price_Changes__r.id];
            else if(rowname == 'Revenue Pass Through (Margin Play)')
                customersfromskuobj = [select ace_customer_core_changes__r.ace_customer_price_changes__r.id cid
                                      				from Ace_Customer_SKU_Changes__c 
                                      				where batchid__c =: quarterValue and Price_Change_Type__c = 'M' and
                                      				Ace_Customer_Core_Changes__r.ACE_Customer_Price_Changes__c in:custList                                      				
                                      				group by Ace_Customer_Core_Changes__r.ACE_Customer_Price_Changes__r.id];
            else if(rowname == '100PercentPricePassThru (Cost Increase)')
                customersfromskuobj = [select ace_customer_core_changes__r.ace_customer_price_changes__r.id cid
                                      				from Ace_Customer_SKU_Changes__c 
                                      				where batchid__c =: quarterValue and Price_Change_Type__c = 'C' and
                                      				Ace_Customer_Core_Changes__r.ACE_Customer_Price_Changes__c in:custList and
                                      				ace_customer_core_changes__r.ace_customer_price_changes__r.Report_isSKU_Exception__c=false
                                      				group by Ace_Customer_Core_Changes__r.ACE_Customer_Price_Changes__r.id];
            else if(rowname == '100PercentPricePassThru (Margin Play)')
                customersfromskuobj = [select ace_customer_core_changes__r.ace_customer_price_changes__r.id cid
                                      				from Ace_Customer_SKU_Changes__c 
                                      				where batchid__c =: quarterValue and Price_Change_Type__c = 'M' and
                                      				Ace_Customer_Core_Changes__r.ACE_Customer_Price_Changes__c in:custList and
                                      				ace_customer_core_changes__r.ace_customer_price_changes__r.Report_isSKU_Exception__c=false
                                      				group by Ace_Customer_Core_Changes__r.ACE_Customer_Price_Changes__r.id];
            else if(rowname == '100PercentTimePassThru')  
        		customersfromskuobj = [select ace_customer_core_changes__r.ace_customer_price_changes__r.id cid
                                      				from Ace_Customer_SKU_Changes__c 
                                      				where batchid__c =: quarterValue and Price_Change_Type__c = 'C' and
                                      				Ace_Customer_Core_Changes__r.ACE_Customer_Price_Changes__c in:custList and
                                      				ace_customer_core_changes__r.ace_customer_price_changes__r.EffectiveDate_IsDifferent__c=false
                                      				group by Ace_Customer_Core_Changes__r.ACE_Customer_Price_Changes__r.id];           
        	             
    	}
        else if(listType == 'ErosionDuetoContractTerms'){
            if(rowname == 'Customers with Increases')                
                customersfromskuobj = [select ace_customer_core_changes__r.ace_customer_price_changes__r.id cid
                                      	from Ace_Customer_SKU_Changes__c 
                                      	where batchid__c =: quarterValue and
                                      	Ace_Customer_Core_Changes__r.ACE_Customer_Price_Changes__c in:custList and
                                      	(Ace_Customer_Core_Changes__r.ACE_Customer_Price_Changes__r.PRICE_NOT_CALCULATED__c= true or 
                                       	Ace_Customer_Core_Changes__r.ACE_Customer_Price_Changes__r.Update_Timing_Action__c = 'F')
                                       group by Ace_Customer_Core_Changes__r.ACE_Customer_Price_Changes__r.id];           	                        
            else if(rowname == 'Revenue Pass Through (Cost Increase)')
                customersfromskuobj = [select ace_customer_core_changes__r.ace_customer_price_changes__r.id cid
                                      	from Ace_Customer_SKU_Changes__c 
                                      	where batchid__c =: quarterValue and Price_Change_Type__c = 'C' and 
                                     	(Ace_Customer_Core_Changes__r.ACE_Customer_Price_Changes__r.PRICE_NOT_CALCULATED__c= true  or 
                                      	Ace_Customer_Core_Changes__r.ACE_Customer_Price_Changes__r.Update_Timing_Action__c = 'F')
                                      	and Ace_Customer_Core_Changes__r.ACE_Customer_Price_Changes__c in:custList
                                        group by Ace_Customer_Core_Changes__r.ACE_Customer_Price_Changes__r.id]; 
            else if(rowname == 'Revenue Pass Through (Margin Play)')
                customersfromskuobj = [select ace_customer_core_changes__r.ace_customer_price_changes__r.id cid
                                      	from Ace_Customer_SKU_Changes__c 
                                       	where batchid__c =: quarterValue and Price_Change_Type__c = 'M' and 
                                     	(Ace_Customer_Core_Changes__r.ACE_Customer_Price_Changes__r.PRICE_NOT_CALCULATED__c= true  or 
                                      	Ace_Customer_Core_Changes__r.ACE_Customer_Price_Changes__r.Update_Timing_Action__c = 'F')
                                      	and Ace_Customer_Core_Changes__r.ACE_Customer_Price_Changes__c in:custList
                                        group by Ace_Customer_Core_Changes__r.ACE_Customer_Price_Changes__r.id]; 
            else if(rowname == '100PercentPricePassThru (Cost Increase)')
                customersfromskuobj = [select ace_customer_core_changes__r.ace_customer_price_changes__r.id cid
                                      	from Ace_Customer_SKU_Changes__c 
                                        where batchid__c =: quarterValue and Price_Change_Type__c = 'C' and 
                                     	(Ace_Customer_Core_Changes__r.ACE_Customer_Price_Changes__r.PRICE_NOT_CALCULATED__c= true  or 
                                      	Ace_Customer_Core_Changes__r.ACE_Customer_Price_Changes__r.Update_Timing_Action__c = 'F')
                                      	and Ace_Customer_Core_Changes__r.ACE_Customer_Price_Changes__c in:custList and
                                      	ace_customer_core_changes__r.ace_customer_price_changes__r.Report_isSKU_Exception__c=false
                                        group by Ace_Customer_Core_Changes__r.ACE_Customer_Price_Changes__r.id]; 
            else if(rowname == '100PercentPricePassThru (Margin Play)')
                customersfromskuobj = [select ace_customer_core_changes__r.ace_customer_price_changes__r.id cid
                                      	from Ace_Customer_SKU_Changes__c
                                        where batchid__c =: quarterValue and Price_Change_Type__c = 'M' and 
                                     	(Ace_Customer_Core_Changes__r.ACE_Customer_Price_Changes__r.PRICE_NOT_CALCULATED__c= true  or 
                                      	Ace_Customer_Core_Changes__r.ACE_Customer_Price_Changes__r.Update_Timing_Action__c = 'F')
                                      	and Ace_Customer_Core_Changes__r.ACE_Customer_Price_Changes__c in:custList and
                                      	ace_customer_core_changes__r.ace_customer_price_changes__r.Report_isSKU_Exception__c=false
                                        group by Ace_Customer_Core_Changes__r.ACE_Customer_Price_Changes__r.id]; 
            else if(rowname == '100PercentTimePassThru')
                customersfromskuobj = [select ace_customer_core_changes__r.ace_customer_price_changes__r.id cid
                                      	from Ace_Customer_SKU_Changes__c
                                        where batchid__c =: quarterValue and Price_Change_Type__c = 'C' and 
                                     	(Ace_Customer_Core_Changes__r.ACE_Customer_Price_Changes__r.PRICE_NOT_CALCULATED__c= true  or 
                                      	Ace_Customer_Core_Changes__r.ACE_Customer_Price_Changes__r.Update_Timing_Action__c = 'F')
                                      	and Ace_Customer_Core_Changes__r.ACE_Customer_Price_Changes__c in:custList and
                                      	ace_customer_core_changes__r.ace_customer_price_changes__r.EffectiveDate_IsDifferent__c=false
                                        group by Ace_Customer_Core_Changes__r.ACE_Customer_Price_Changes__r.id]; 

        }
        else if(listType == 'EligibleCustomers'){
            if(rowname == 'Customers with Increases')
                customersfromskuobj = [select ace_customer_core_changes__r.ace_customer_price_changes__r.id cid
                                      	from Ace_Customer_SKU_Changes__c where batchid__c =: quarterValue and
                                        Ace_Customer_Core_Changes__r.ACE_Customer_Price_Changes__c in:custList and
                                        (Ace_Customer_Core_Changes__r.ACE_Customer_Price_Changes__r.Update_Timing_Action__c = 'T' and 
                                        Ace_Customer_Core_Changes__r.ACE_Customer_Price_Changes__r.PRICE_NOT_CALCULATED__c= false)
                                        group by Ace_Customer_Core_Changes__r.ACE_Customer_Price_Changes__r.id];
            else if(rowname == 'Revenue Pass Through (Cost Increase)')
                customersfromskuobj = [select ace_customer_core_changes__r.ace_customer_price_changes__r.id cid
                                      	from Ace_Customer_SKU_Changes__c where batchid__c =: quarterValue 
                                        and Price_Change_Type__c = 'C' and 
                                        (Ace_Customer_Core_Changes__r.ACE_Customer_Price_Changes__r.Update_Timing_Action__c = 'T' and 
                                        Ace_Customer_Core_Changes__r.ACE_Customer_Price_Changes__r.PRICE_NOT_CALCULATED__c= false) 
                                        and Ace_Customer_Core_Changes__r.ACE_Customer_Price_Changes__c in:custList
                                        group by Ace_Customer_Core_Changes__r.ACE_Customer_Price_Changes__r.id];
            else if(rowname == 'Revenue Pass Through (Margin Play)')
                customersfromskuobj = [select ace_customer_core_changes__r.ace_customer_price_changes__r.id cid
                                      	from Ace_Customer_SKU_Changes__c where batchid__c =: quarterValue 
                                        and Price_Change_Type__c = 'M' and 
                                        (Ace_Customer_Core_Changes__r.ACE_Customer_Price_Changes__r.Update_Timing_Action__c = 'T' and 
                                        Ace_Customer_Core_Changes__r.ACE_Customer_Price_Changes__r.PRICE_NOT_CALCULATED__c= false)
                                        and Ace_Customer_Core_Changes__r.ACE_Customer_Price_Changes__c in:custList
                                        group by Ace_Customer_Core_Changes__r.ACE_Customer_Price_Changes__r.id];
            else if(rowname == '100PercentPricePassThru (Cost Increase)')
                customersfromskuobj = [select ace_customer_core_changes__r.ace_customer_price_changes__r.id cid
                                      	from Ace_Customer_SKU_Changes__c where batchid__c =: quarterValue 
                                         and Price_Change_Type__c = 'C' and 
                                         (Ace_Customer_Core_Changes__r.ACE_Customer_Price_Changes__r.Update_Timing_Action__c = 'T' and
                                          Ace_Customer_Core_Changes__r.ACE_Customer_Price_Changes__r.PRICE_NOT_CALCULATED__c= false) 
                                         and Ace_Customer_Core_Changes__r.ACE_Customer_Price_Changes__c in:custList and
                                         ace_customer_core_changes__r.ace_customer_price_changes__r.Report_isSKU_Exception__c=false
                                         group by Ace_Customer_Core_Changes__r.ACE_Customer_Price_Changes__r.id];
            else if(rowname == '100PercentPricePassThru (Margin Play)')
                customersfromskuobj = [select ace_customer_core_changes__r.ace_customer_price_changes__r.id cid
                                      	from Ace_Customer_SKU_Changes__c where batchid__c =: quarterValue 
                                        and Price_Change_Type__c = 'M' and 
                                        (Ace_Customer_Core_Changes__r.ACE_Customer_Price_Changes__r.Update_Timing_Action__c = 'T' and
                                        Ace_Customer_Core_Changes__r.ACE_Customer_Price_Changes__r.PRICE_NOT_CALCULATED__c= false) 
                                        and Ace_Customer_Core_Changes__r.ACE_Customer_Price_Changes__c in:custList and
                                        ace_customer_core_changes__r.ace_customer_price_changes__r.Report_isSKU_Exception__c=false
                                        group by Ace_Customer_Core_Changes__r.ACE_Customer_Price_Changes__r.id];
            else if(rowname == '100PercentTimePassThru')
                customersfromskuobj = [select ace_customer_core_changes__r.ace_customer_price_changes__r.id cid
                                      	from Ace_Customer_SKU_Changes__c where batchid__c =: quarterValue 
                                        and Price_Change_Type__c = 'C' and 
                                        (Ace_Customer_Core_Changes__r.ACE_Customer_Price_Changes__r.Update_Timing_Action__c = 'T' and
                                        Ace_Customer_Core_Changes__r.ACE_Customer_Price_Changes__r.PRICE_NOT_CALCULATED__c= false) 
                                        and Ace_Customer_Core_Changes__r.ACE_Customer_Price_Changes__c in:custList and
                                        ace_customer_core_changes__r.ace_customer_price_changes__r.EffectiveDate_IsDifferent__c=false
                                        group by Ace_Customer_Core_Changes__r.ACE_Customer_Price_Changes__r.id];
        }
        else if(listType == 'ErosionduetoSalesDecisions'){
            if(rowname == 'Customers with Increases')
                customersfromskuobj = [select ace_customer_core_changes__r.ace_customer_price_changes__r.id cid
                                      	from Ace_Customer_SKU_Changes__c
                                        where batchid__c =: quarterValue and
                                      	Ace_Customer_Core_Changes__r.ACE_Customer_Price_Changes__c in:custList and
                                        (ace_customer_core_changes__r.ace_customer_price_changes__r.Report_isSKU_Exception__c=true 
                                        OR ace_customer_core_changes__r.ace_customer_price_changes__r.EffectiveDate_IsDifferent__c =true)
                                        group by Ace_Customer_Core_Changes__r.ACE_Customer_Price_Changes__r.id];
            else if(rowname == 'Revenue Pass Through (Cost Increase)')
                customersfromskuobj = [select ace_customer_core_changes__r.ace_customer_price_changes__r.id cid
                                      	from Ace_Customer_SKU_Changes__c
                                        where batchid__c =: quarterValue and 
                                        Ace_Customer_Core_Changes__r.ACE_Customer_Price_Changes__c in:custList and
                                        Price_Change_Type__c = 'C' and
                                        (ace_customer_core_changes__r.ace_customer_price_changes__r.Report_isSKU_Exception__c=true 
                                        OR ace_customer_core_changes__r.ace_customer_price_changes__r.EffectiveDate_IsDifferent__c =true)
                                        group by Ace_Customer_Core_Changes__r.ACE_Customer_Price_Changes__r.id];
            else if(rowname == 'Revenue Pass Through (Margin Play)')
                customersfromskuobj = [select ace_customer_core_changes__r.ace_customer_price_changes__r.id cid
                                      	from Ace_Customer_SKU_Changes__c
                                        where batchid__c =: quarterValue and 
                                        Ace_Customer_Core_Changes__r.ACE_Customer_Price_Changes__c in:custList and
                                        Price_Change_Type__c = 'M' and
                                        (ace_customer_core_changes__r.ace_customer_price_changes__r.Report_isSKU_Exception__c=true 
                                        OR ace_customer_core_changes__r.ace_customer_price_changes__r.EffectiveDate_IsDifferent__c =true)
                                        group by Ace_Customer_Core_Changes__r.ACE_Customer_Price_Changes__r.id];
            else if(rowname == '100PercentPricePassThru (Cost Increase)')
                customersfromskuobj = [select ace_customer_core_changes__r.ace_customer_price_changes__r.id cid
                                      	from Ace_Customer_SKU_Changes__c
                                        where batchid__c =: quarterValue and 
                                        Ace_Customer_Core_Changes__r.ACE_Customer_Price_Changes__c in:custList and
                                        Price_Change_Type__c = 'C' and
                                        //(ace_customer_core_changes__r.ace_customer_price_changes__r.Report_isSKU_Exception__c=true or//price exception 
                                        ace_customer_core_changes__r.ace_customer_price_changes__r.EffectiveDate_IsDifferent__c =true and//date exception
                                        ace_customer_core_changes__r.ace_customer_price_changes__r.Report_isSKU_Exception__c=false//no price exception
                                        group by Ace_Customer_Core_Changes__r.ACE_Customer_Price_Changes__r.id];
            else if(rowname == '100PercentPricePassThru (Margin Play)')
                customersfromskuobj = [select ace_customer_core_changes__r.ace_customer_price_changes__r.id cid
                                      	from Ace_Customer_SKU_Changes__c
                                        where batchid__c =: quarterValue and 
                                        Ace_Customer_Core_Changes__r.ACE_Customer_Price_Changes__c in:custList and
                                        Price_Change_Type__c = 'M' and
                                        //(ace_customer_core_changes__r.ace_customer_price_changes__r.Report_isSKU_Exception__c=true or//price exception 
                                        ace_customer_core_changes__r.ace_customer_price_changes__r.EffectiveDate_IsDifferent__c =true and//date exception
                                        ace_customer_core_changes__r.ace_customer_price_changes__r.Report_isSKU_Exception__c=false//no price exception         
                                        group by Ace_Customer_Core_Changes__r.ACE_Customer_Price_Changes__r.id];
            else if(rowname == '100PercentTimePassThru')
                customersfromskuobj = [select ace_customer_core_changes__r.ace_customer_price_changes__r.id cid
                                      	from Ace_Customer_SKU_Changes__c
                                        where batchid__c =: quarterValue and 
                                        Ace_Customer_Core_Changes__r.ACE_Customer_Price_Changes__c in:custList and
                                        Price_Change_Type__c = 'C' and
                                        ace_customer_core_changes__r.ace_customer_price_changes__r.Report_isSKU_Exception__c=true and//price exception 
                                        //OR ace_customer_core_changes__r.ace_customer_price_changes__r.EffectiveDate_IsDifferent__c =true) and//date exception
                                        ace_customer_core_changes__r.ace_customer_price_changes__r.EffectiveDate_IsDifferent__c=false//no date exception        
                                        group by Ace_Customer_Core_Changes__r.ACE_Customer_Price_Changes__r.id];
        	}             
        else if(listType == 'ErosionduetoRemediationAndSalesPricingDecisions'){
            if(rowname == 'Customers with Increases')
                customersfromskuobj = [select ace_customer_core_changes__r.ace_customer_price_changes__r.id cid
                                      	from Ace_Customer_SKU_Changes__c
                                        where batchid__c =: quarterValue and
                                      	Ace_Customer_Core_Changes__r.ACE_Customer_Price_Changes__c in:custList and
                                        ace_customer_core_changes__r.ace_customer_price_changes__r.Report_isSKU_Exception__c=true
                                        group by Ace_Customer_Core_Changes__r.ACE_Customer_Price_Changes__r.id];
            else if(rowname == 'Revenue Pass Through (Cost Increase)')
                customersfromskuobj = [select ace_customer_core_changes__r.ace_customer_price_changes__r.id cid
                                      	from Ace_Customer_SKU_Changes__c
                                        where batchid__c =: quarterValue and 
                                        Ace_Customer_Core_Changes__r.ACE_Customer_Price_Changes__c in:custList and
                                        Price_Change_Type__c = 'C' and
                                        ace_customer_core_changes__r.ace_customer_price_changes__r.Report_isSKU_Exception__c=true
                                        group by Ace_Customer_Core_Changes__r.ACE_Customer_Price_Changes__r.id];
            else if(rowname == 'Revenue Pass Through (Margin Play)')
                customersfromskuobj = [select ace_customer_core_changes__r.ace_customer_price_changes__r.id cid
                                      	from Ace_Customer_SKU_Changes__c
                                        where batchid__c =: quarterValue and 
                                        Ace_Customer_Core_Changes__r.ACE_Customer_Price_Changes__c in:custList and
                                        Price_Change_Type__c = 'M' and
                                        ace_customer_core_changes__r.ace_customer_price_changes__r.Report_isSKU_Exception__c=true
                                        group by Ace_Customer_Core_Changes__r.ACE_Customer_Price_Changes__r.id];
            //else if(rowname == '100PercentPricePassThru (Cost Increase)') //it will be always 0                                                     
            //else if(rowname == '100PercentPricePassThru (Margin Play)') //it will be always 0 
            else if(rowname == '100PercentTimePassThru')
                customersfromskuobj = [select ace_customer_core_changes__r.ace_customer_price_changes__r.id cid
                                      	from Ace_Customer_SKU_Changes__c
                                        where batchid__c =: quarterValue and 
                                        Ace_Customer_Core_Changes__r.ACE_Customer_Price_Changes__c in:custList and
                                        Price_Change_Type__c = 'C' and
                                        ace_customer_core_changes__r.ace_customer_price_changes__r.Report_isSKU_Exception__c=true and //price exception
                                        ace_customer_core_changes__r.ace_customer_price_changes__r.EffectiveDate_IsDifferent__c=false//no date exception
                                        group by Ace_Customer_Core_Changes__r.ACE_Customer_Price_Changes__r.id];
        }
        else if(listType == 'Implemented'){
            if(rowname == 'Customers with Increases')
                customersfromskuobj = [select ace_customer_core_changes__r.ace_customer_price_changes__r.id cid
                                      from Ace_Customer_SKU_Changes__c
                                      where batchid__c =: quarterValue and
                                      Ace_Customer_Core_Changes__r.ACE_Customer_Price_Changes__c in:custList and
                                      (ace_customer_core_changes__r.ace_customer_price_changes__r.Update_Timing_Action__c = 'T' and 
                                      ace_customer_core_changes__r.ace_customer_price_changes__r.PRICE_NOT_CALCULATED__c= false) and
                                      ace_customer_core_changes__r.ace_customer_price_changes__r.Report_SKU_Count__c < 1
                                      group by Ace_Customer_Core_Changes__r.ACE_Customer_Price_Changes__r.id];
            else if(rowname == 'Revenue Pass Through (Cost Increase)')
                customersfromskuobj = [select ace_customer_core_changes__r.ace_customer_price_changes__r.id cid
                                      from Ace_Customer_SKU_Changes__c
                                      where batchid__c =: quarterValue and 
                                      Ace_Customer_Core_Changes__r.ACE_Customer_Price_Changes__c in:custList and
                                      Price_Change_Type__c = 'C' and
                                      (ace_customer_core_changes__r.ace_customer_price_changes__r.Update_Timing_Action__c = 'T' and 
                                      ace_customer_core_changes__r.ace_customer_price_changes__r.PRICE_NOT_CALCULATED__c= false) and
         							  ace_customer_core_changes__r.ace_customer_price_changes__r.Report_SKU_Count__c < 1
                                      group by Ace_Customer_Core_Changes__r.ACE_Customer_Price_Changes__r.id];
            else if(rowname == 'Revenue Pass Through (Margin Play)')
                customersfromskuobj = [select ace_customer_core_changes__r.ace_customer_price_changes__r.id cid
                                      from Ace_Customer_SKU_Changes__c
                                      where batchid__c =: quarterValue and 
                                      Ace_Customer_Core_Changes__r.ACE_Customer_Price_Changes__c in:custList and
                                      Price_Change_Type__c = 'M' and
                                      (ace_customer_core_changes__r.ace_customer_price_changes__r.Update_Timing_Action__c = 'T' and 
                                      ace_customer_core_changes__r.ace_customer_price_changes__r.PRICE_NOT_CALCULATED__c= false) and
         							  ace_customer_core_changes__r.ace_customer_price_changes__r.Report_SKU_Count__c < 1
                                      group by Ace_Customer_Core_Changes__r.ACE_Customer_Price_Changes__r.id];
            else if(rowname == '100PercentPricePassThru (Cost Increase)')
                customersfromskuobj = [select ace_customer_core_changes__r.ace_customer_price_changes__r.id cid
                                      from Ace_Customer_SKU_Changes__c
                                      where batchid__c =: quarterValue and 
                                      Ace_Customer_Core_Changes__r.ACE_Customer_Price_Changes__c in:custList and
                                      Price_Change_Type__c = 'C' and
                                      (ace_customer_core_changes__r.ace_customer_price_changes__r.Update_Timing_Action__c = 'T' and 
                                      ace_customer_core_changes__r.ace_customer_price_changes__r.PRICE_NOT_CALCULATED__c= false) and
         							  ace_customer_core_changes__r.ace_customer_price_changes__r.Report_SKU_Count__c < 1 and
                                      ace_customer_core_changes__r.ace_customer_price_changes__r.Report_isSKU_Exception__c=false
                                      group by Ace_Customer_Core_Changes__r.ACE_Customer_Price_Changes__r.id];
            else if(rowname == '100PercentPricePassThru (Margin Play)')
                customersfromskuobj = [select ace_customer_core_changes__r.ace_customer_price_changes__r.id cid
                                      from Ace_Customer_SKU_Changes__c
                                      where batchid__c =: quarterValue and 
                                      Ace_Customer_Core_Changes__r.ACE_Customer_Price_Changes__c in:custList and
                                      Price_Change_Type__c = 'M' and
                                      (ace_customer_core_changes__r.ace_customer_price_changes__r.Update_Timing_Action__c = 'T' and 
                                      ace_customer_core_changes__r.ace_customer_price_changes__r.PRICE_NOT_CALCULATED__c= false) and
         							  ace_customer_core_changes__r.ace_customer_price_changes__r.Report_SKU_Count__c < 1 and
                                      ace_customer_core_changes__r.ace_customer_price_changes__r.Report_isSKU_Exception__c=false
                                      group by Ace_Customer_Core_Changes__r.ACE_Customer_Price_Changes__r.id];
            else if(rowname == '100PercentTimePassThru')
                 customersfromskuobj = [select ace_customer_core_changes__r.ace_customer_price_changes__r.id cid
                                      	from Ace_Customer_SKU_Changes__c
                                        where batchid__c =: quarterValue and 
                                        Ace_Customer_Core_Changes__r.ACE_Customer_Price_Changes__c in:custList and
                                        Price_Change_Type__c = 'C' and
                                        (ace_customer_core_changes__r.ace_customer_price_changes__r.Update_Timing_Action__c = 'T' and 
                                        ace_customer_core_changes__r.ace_customer_price_changes__r.PRICE_NOT_CALCULATED__c= false) and
         								ace_customer_core_changes__r.ace_customer_price_changes__r.Report_SKU_Count__c < 1 and
                                        ace_customer_core_changes__r.ace_customer_price_changes__r.EffectiveDate_IsDifferent__c=false
                                        group by Ace_Customer_Core_Changes__r.ACE_Customer_Price_Changes__r.id];
        }
        
        if(customersfromskuobj != null)
        	for (AggregateResult ar : customersfromskuobj){
            	custListfromskuobj.add((id)ar.get('cid'));
        	}         
        
    }
    
    public PageReference CustListOverviewReportData(){                
        
        //sfdc 073477
        getACECustomerListfromskuobj();
        String ResQuery='';
        //String FieldName='';
        //getFieldName == 'Customer';
        system.debug('~~~~~~~~~~~~~'+tabAsc);
        system.debug('~~~~~~~~~~~~~'+getFieldName);        
        lCustListOverviewReportData = new List<ACE_Customer_Price_Changes__c>();        
        
        ResQuery = 'select Customer__r.id,Customer__r.name,Report_Total_Spend_Impact_12_Month_ACE__c,Report_Total_Spend_Impact_12_Month_C_Typ__c, Report_Total_Spend_Impact_12_Month_M_Typ__c from ACE_Customer_Price_Changes__c where Name=: quarterValue and id in:custListfromskuobj';              
   
        
        // searchWord = searchWord.deleteWhitespace();
        if((searchWord != null) && (searchWord != '') && (searchWord != 'null'))
        {      
        	String textToSearch = searchWord + '%';
            ResQuery = ResQuery+ ' and (Owning_Customer_ID__c LIKE \'' + textToSearch + '\' or Customer__r.name LIKE \'' + textToSearch + '\') ';
        }
            
        List<ACE_Customer_Price_Changes__c> lTotal = new List<ACE_Customer_Price_Changes__c>();
        lTotal = Database.query(ResQuery);
        total_size = lTotal.size();
        ResQuery = ResQuery + ' order by '+ sortfieldName+' '+sortDirection+' limit ' +List_size+ 'offset '+counter;
        System.debug('>>>>>>>>>>>>>>>>>>>Query' + ResQuery );        
                
        lCustListOverviewReportData = database.query(ResQuery);        
        return null;
        
    }
  /*  public PageReference CustListOverviewReportData(){
        getACECustomerList();
        system.debug('<<<<<<<<<<<<Quarter>>>>>>>>>>'+listType );
        system.debug('Customers Returned from Hierarchy:' + custList.size());
        //User hierarchy code - ends
        
        String ResQuery='';
        //String FieldName='';
        //getFieldName == 'Customer';
        system.debug('~~~~~~~~~~~~~'+tabAsc);
        system.debug('~~~~~~~~~~~~~'+getFieldName);        
        lCustListOverviewReportData = new List<ACE_Customer_Price_Changes__c>();
        
        if(listType == 'Initial'){                     
            	ResQuery = 'select Customer__r.id,Customer__r.name,Report_Total_Spend_Impact_12_Month_ACE__c,Report_New_Gross_IGM_ACE__c, Total_Spend_Impact_12_Month__c,New_Gross_IGM__c from ACE_Customer_Price_Changes__c where Name=: quarterValue and id in:custList';              
        }
        else if(listType == 'ErosionDuetoContractTerms'){           
            ResQuery = 'select Customer__r.id,Customer__r.name,Report_Total_Spend_Impact_12_Month_ACE__c,Report_New_Gross_IGM_ACE__c, Total_Spend_Impact_12_Month__c,New_Gross_IGM__c from ACE_Customer_Price_Changes__c where Name=: quarterValue and id in:custList and PRICE_NOT_CALCULATED__c = true';  
        }
        else if(listType == 'ErosionduetoSalesDecisions'){
            if(rowname == '100PercentPricePassThru'){
                //removed this where condition (and PRICE_NOT_CALCULATED__c = false) from below line---sfdc 861332
                ResQuery = 'select Customer__r.id,Customer__r.name,Report_Total_Spend_Impact_12_Month_ACE__c,Report_New_Gross_IGM_ACE__c, Total_Spend_Impact_12_Month__c,New_Gross_IGM__c from ACE_Customer_Price_Changes__c where Name=: quarterValue and id in:custList and Report_isSKU_Exception__c=true';                
            }
            else if(rowname == '100PercentTimePassThru'){
                //removed this where condition (and PRICE_NOT_CALCULATED__c = false) from below line---sfdc 861332
                ResQuery = 'select Customer__r.id,Customer__r.name,Report_Total_Spend_Impact_12_Month_ACE__c,Report_New_Gross_IGM_ACE__c, Total_Spend_Impact_12_Month__c,New_Gross_IGM__c from ACE_Customer_Price_Changes__c where Name=: quarterValue and id in:custList and EffectiveDate_IsDifferent__c =true';              
            }
            else if(rowname == 'Exposure Days'){
                //removed this where condition (and PRICE_NOT_CALCULATED__c = false) from below line---sfdc 861332
                ResQuery = 'select Customer__r.id,Customer__r.name, Report_Total_Spend_Impact_12_Month_ACE__c,Report_New_Gross_IGM_ACE__c,Total_Spend_Impact_12_Month__c,New_Gross_IGM__c from ACE_Customer_Price_Changes__c where Name=: quarterValue and id in:custList and Reporting_Exposure_Days_Sale_Erosion__c>0 and (Report_isSKU_Exception__c=true OR EffectiveDate_IsDifferent__c =true)';              
            }
            else if(rowname == 'Exposure Reduction from Early Release'){
                //removed this where condition (and PRICE_NOT_CALCULATED__c = false) from below line---sfdc 861332
                ResQuery = 'select Customer__r.id,Customer__r.name,Report_Total_Spend_Impact_12_Month_ACE__c,Report_New_Gross_IGM_ACE__c, Total_Spend_Impact_12_Month__c,New_Gross_IGM__c from ACE_Customer_Price_Changes__c where Name=: quarterValue and id in:custList and Reporting_ExposureDaysEarly_Sale_Erosion__c>0 and (Report_isSKU_Exception__c=true OR EffectiveDate_IsDifferent__c =true)';              
            }
            //sfdc 861332---added below else condition--start
            else if(rowname == 'Exposure Increases from Date Exception'){
                ResQuery = 'select Customer__r.id,Customer__r.name,Report_Total_Spend_Impact_12_Month_ACE__c,Report_New_Gross_IGM_ACE__c, Total_Spend_Impact_12_Month__c,New_Gross_IGM__c from ACE_Customer_Price_Changes__c where Name=: quarterValue and id in:custList and Reporting_ExposureDays_DateExcep_Erosion__c>0 and (EffectiveDate_IsDifferent__c =true)';              
            }//sfdc 861332---End
            else{
                ResQuery = 'select Customer__r.id,Customer__r.name,Report_Total_Spend_Impact_12_Month_ACE__c,Report_New_Gross_IGM_ACE__c, Total_Spend_Impact_12_Month__c,New_Gross_IGM__c from ACE_Customer_Price_Changes__c where Name=: quarterValue and id in:custList and (Report_isSKU_Exception__c=true OR EffectiveDate_IsDifferent__c =true)';//sfdc 861332
                //and Report_SKU_Count__c < 1 and PRICE_NOT_CALCULATED__c = false'; sfdc 861332             
            }
        }    
        else if(listType == 'Implemented'){
            if(rowname == '100PercentPricePassThru'){
                ResQuery = 'select Customer__r.id,Customer__r.name,Report_Total_Spend_Impact_12_Month_ACE__c,Report_New_Gross_IGM_ACE__c, Total_Spend_Impact_12_Month__c,New_Gross_IGM__c from ACE_Customer_Price_Changes__c where Name=: quarterValue and id in:custList and Report_isSKU_Exception__c=false';//and PRICE_NOT_CALCULATED__c = falseand Report_SKU_Count__c > 1'; //sfdc 861332            
            }
            else if(rowname == '100PercentTimePassThru'){
                ResQuery = 'select Customer__r.id,Customer__r.name,Report_Total_Spend_Impact_12_Month_ACE__c,Report_New_Gross_IGM_ACE__c, Total_Spend_Impact_12_Month__c,New_Gross_IGM__c from ACE_Customer_Price_Changes__c where Name=: quarterValue and id in:custList and EffectiveDate_IsDifferent__c =false';//and PRICE_NOT_CALCULATED__c = false and Report_SKU_Count__c > 1';//sfdc 861332              
            }
            else if(rowname == 'Exposure Days'){
                ResQuery = 'select Customer__r.id,Customer__r.name,Report_Total_Spend_Impact_12_Month_ACE__c,Report_New_Gross_IGM_ACE__c, Total_Spend_Impact_12_Month__c,New_Gross_IGM__c from ACE_Customer_Price_Changes__c where Name=: quarterValue and id in:custList and Reporting_Exposure_Days_Sale_Erosion__c>0 and (Report_isSKU_Exception__c=true OR EffectiveDate_IsDifferent__c =true)';//and Report_SKU_Count__c > 1 and PRICE_NOT_CALCULATED__c = false ;//sfdc 861332              
            }
            else if(rowname == 'Exposure Reduction from Early Release'){
                ResQuery = 'select Customer__r.id,Customer__r.name,Report_Total_Spend_Impact_12_Month_ACE__c,Report_New_Gross_IGM_ACE__c, Total_Spend_Impact_12_Month__c,New_Gross_IGM__c from ACE_Customer_Price_Changes__c where Name=: quarterValue and id in:custList and Reporting_ExposureDaysEarly_Sale_Erosion__c>0 and (Report_isSKU_Exception__c=true OR EffectiveDate_IsDifferent__c =true)';//sfdc 861332
            }
            //sfdc 861332---added below else condition--start
            else if(rowname == 'Exposure Increases from Date Exception'){
                ResQuery = 'select Customer__r.id,Customer__r.name,Report_Total_Spend_Impact_12_Month_ACE__c,Report_New_Gross_IGM_ACE__c, Total_Spend_Impact_12_Month__c,New_Gross_IGM__c from ACE_Customer_Price_Changes__c where Name=: quarterValue and id in:custList and Reporting_ExposureDays_DateExcep_Erosion__c>0 and EffectiveDate_IsDifferent__c = true';
            }//sfdc 861332---End
            else{
                ResQuery = 'select Customer__r.id,Customer__r.name,Report_Total_Spend_Impact_12_Month_ACE__c,Report_New_Gross_IGM_ACE__c, Total_Spend_Impact_12_Month__c,New_Gross_IGM__c from ACE_Customer_Price_Changes__c where Name=: quarterValue and id in:custList and Report_isSKU_Exception__c=false and EffectiveDate_IsDifferent__c =false';
                //and Report_SKU_Count__c > 1 and PRICE_NOT_CALCULATED__c = false';//sfdc 861332              
            }            
        }
        //sfdc 861332-----start
        else if(listType == 'EligibleCustomers'){
            if(rowname == '100PercentPricePassThru'){
                ResQuery = 'select Customer__r.id,Customer__r.name,Report_Total_Spend_Impact_12_Month_ACE__c,Report_New_Gross_IGM_ACE__c, Total_Spend_Impact_12_Month__c,New_Gross_IGM__c from ACE_Customer_Price_Changes__c where Name=: quarterValue and id in:custList and Update_Timing_Action__c = \'T\' and Report_isSKU_Exception__c=true';
            }
            else if(rowname == '100PercentTimePassThru'){
                ResQuery = 'select Customer__r.id,Customer__r.name,Report_Total_Spend_Impact_12_Month_ACE__c,Report_New_Gross_IGM_ACE__c, Total_Spend_Impact_12_Month__c,New_Gross_IGM__c from ACE_Customer_Price_Changes__c where Name=: quarterValue and id in:custList  and Update_Timing_Action__c = \'T\' and EffectiveDate_IsDifferent__c =true';
            }                                         
            else{
                ResQuery = 'select Customer__r.id,Customer__r.name,Report_Total_Spend_Impact_12_Month_ACE__c,Report_New_Gross_IGM_ACE__c, Total_Spend_Impact_12_Month__c,New_Gross_IGM__c from ACE_Customer_Price_Changes__c where Name=: quarterValue and id in:custList and Update_Timing_Action__c = \'T\'';//sfdc 861332
            }      
        }
        else if(listType == 'ErosionduetoRemediationAndSalesPricingDecisions'){        	
            if(rowname == '100PercentTimePassThru'){
                ResQuery = 'select Customer__r.id,Customer__r.name,Report_Total_Spend_Impact_12_Month_ACE__c,Report_New_Gross_IGM_ACE__c, Total_Spend_Impact_12_Month__c,New_Gross_IGM__c from ACE_Customer_Price_Changes__c where Name=: quarterValue and id in:custList  and (Report_isSKU_Exception__c=true or EffectiveDate_IsDifferent__c =true)';//sfdc 861332
            }
            else if(rowname == 'Exposure Days'){
                ResQuery = 'select Customer__r.id,Customer__r.name,Report_Total_Spend_Impact_12_Month_ACE__c,Report_New_Gross_IGM_ACE__c, Total_Spend_Impact_12_Month__c,New_Gross_IGM__c from ACE_Customer_Price_Changes__c where Name=: quarterValue and id in:custList and Report_isSKU_Exception__c=true and Reporting_Exposure_Days_Sale_Erosion__c>0';              
            }
            else if(rowname == 'Exposure Reduction from Early Release'){
                ResQuery = 'select Customer__r.id,Customer__r.name,Report_Total_Spend_Impact_12_Month_ACE__c,Report_New_Gross_IGM_ACE__c, Total_Spend_Impact_12_Month__c,New_Gross_IGM__c from ACE_Customer_Price_Changes__c where  Name=: quarterValue andid in:custList and Report_isSKU_Exception__c=true and Reporting_ExposureDaysEarly_Sale_Erosion__c>0';              
            }
            else if(rowname == 'Exposure Increases from Date Exception'){
                ResQuery = 'select Customer__r.id,Customer__r.name,Report_Total_Spend_Impact_12_Month_ACE__c,Report_New_Gross_IGM_ACE__c, Total_Spend_Impact_12_Month__c,New_Gross_IGM__c from ACE_Customer_Price_Changes__c where Name=: quarterValue and id in:custList and Report_isSKU_Exception__c=true and Reporting_ExposureDays_DateExcep_Erosion__c>0';
            }
            else{
                ResQuery = 'select Customer__r.id,Customer__r.name,Report_Total_Spend_Impact_12_Month_ACE__c,Report_New_Gross_IGM_ACE__c, Total_Spend_Impact_12_Month__c,New_Gross_IGM__c from ACE_Customer_Price_Changes__c where Name=: quarterValue and id in:custList and Report_isSKU_Exception__c=true';
            }         
        } 
        //sfdc 861332-----start
        
        // searchWord = searchWord.deleteWhitespace();
            if((searchWord != null) && (searchWord != '') && (searchWord != 'null'))
            {      
                String textToSearch = searchWord + '%';
                ResQuery = ResQuery+ ' and (Owning_Customer_ID__c LIKE \'' + textToSearch + '\' or Customer__r.name LIKE \'' + textToSearch + '\') ';
            }
            
        List<ACE_Customer_Price_Changes__c> lTotal = new List<ACE_Customer_Price_Changes__c>();
        lTotal = Database.query(ResQuery);
        total_size = lTotal.size();
        ResQuery = ResQuery + ' order by '+ sortfieldName+' '+sortDirection+' limit ' +List_size+ 'offset '+counter;
        System.debug('>>>>>>>>>>>>>>>>>>>Query' + ResQuery );        
                
        lCustListOverviewReportData = database.query(ResQuery);        
        return null; 
    }*/
    //End of Customer List - Overview Report - Added by Guha.
    
    //Customer List  - customer response / notification  by guha  
    public List<ACE_Customer_Price_Changes__c> lCustomerListNotifyResponse {get;set;}
    public List<CustListReportDataCls> lCustListReportData {get;set;}
    public PageReference loadCustomerNotifyResponseData()
    {
        //for initial Customr list
        getACECustomerList();      
        system.debug('Customers Returned from Hierarchy:' + custList.size());
        //User hierarchy code - ends
        
        lCustomerListNotifyResponse = new List<ACE_Customer_Price_Changes__c>();        
        String ResQuery= '';
        //String FieldName = 'CustomerId';
        
        List<ACE_Customer_MailOut__c> CustList2 = new List<ACE_Customer_MailOut__c>();
        if(reportType == 'Notification')
        {
            if(sortfieldName == '' || sortfieldName == null)
                sortfieldName = 'Customer__r.Cust_ID__c';
            if(sortDirection == '' || sortDirection ==  null)
                sortDirection = 'ASC';
            if((ColumnVal != '' || ColumnVal != null) && ColumnVal == 'B3'){
                //changed email template code from 3 to 1-sfdc 910713.
                CustList2 = [Select Customer_Core_Price_Changes__r.id,Reporting_Accept_Time__c,Notification_Date__c,Reporting_Accepted_Date__c  from ACE_Customer_MailOut__c where Customer_Core_Price_Changes__c in:custList and Email_Template_Code__c = '1' order by CreatedDate asc];
            }
            else if((ColumnVal != '' || ColumnVal != null) && ColumnVal == 'B2'){
                CustList2 = [Select Customer_Core_Price_Changes__r.id,Reporting_Accept_Time__c,Notification_Date__c,Reporting_Accepted_Date__c  from ACE_Customer_MailOut__c where Customer_Core_Price_Changes__c in:custList and Email_Template_Code__c = '2' order by CreatedDate asc];
            }
            else if((ColumnVal != '' || ColumnVal != null) && ColumnVal == 'B1'){
                //changed email template code from 1 to 3-sfdc 910713.
                CustList2 = [Select Customer_Core_Price_Changes__r.id,Reporting_Accept_Time__c,Notification_Date__c,Reporting_Accepted_Date__c  from ACE_Customer_MailOut__c where Customer_Core_Price_Changes__c in:custList and Email_Template_Code__c = '3' order by CreatedDate asc];
            }
            else{
                CustList2 = [Select Customer_Core_Price_Changes__r.id,Reporting_Accept_Time__c,Notification_Date__c,Reporting_Accepted_Date__c  from ACE_Customer_MailOut__c where Customer_Core_Price_Changes__c in:custList order by CreatedDate asc];
            }
        }
        else if(reportType == 'Response')
        {
            if(sortfieldName == '' || sortfieldName == null)
                sortfieldName = 'Customer__r.Cust_ID__c';
            if(sortDirection == '' || sortDirection ==  null)
                sortDirection = 'ASC';
            if((ColumnVal != '' || ColumnVal != null) && ColumnVal == 'B3'){
                //changed email template code from 3 to 1-sfdc 910713.
                CustList2 = [Select Customer_Core_Price_Changes__r.id,Reporting_Accept_Time__c,Notification_Date__c,Reporting_Accepted_Date__c from ACE_Customer_MailOut__c where Customer_Core_Price_Changes__c in:custList and Email_Template_Code__c =:'1' order by CreatedDate asc];
            }
            else if((ColumnVal != '' || ColumnVal != null) && ColumnVal == 'callreq'){ 
                //changed email template code from 3 to 1-sfdc 910713.
                CustList2 = [Select Customer_Core_Price_Changes__r.id,Reporting_Accept_Time__c,Notification_Date__c,Reporting_Accepted_Date__c from ACE_Customer_MailOut__c where Customer_Core_Price_Changes__c in:custList and Customer_Core_Price_Changes__r.CallMeRequest__c = true and Email_Template_Code__c =:'1' order by CreatedDate asc];
            }
            else if((ColumnVal != '' || ColumnVal != null) && ColumnVal == 'callme'){
                //changed email template code from 3 to 1-sfdc 910713.                
                CustList2 = [Select Customer_Core_Price_Changes__r.id,Reporting_Accept_Time__c,Notification_Date__c,Reporting_Accepted_Date__c from ACE_Customer_MailOut__c where Customer_Core_Price_Changes__c in:custList and Customer_Core_Price_Changes__r.CallMeRequest__c = true and Customer_Core_Price_Changes__r.Customer_Response__c = 'Call Me' and Email_Template_Code__c =:'1' order by CreatedDate asc];
            }
            else if((ColumnVal != '' || ColumnVal != null) && ColumnVal == 'Approved'){
                //changed email template code from 3 to 1-sfdc 910713.
                CustList2 = [Select Customer_Core_Price_Changes__r.id,Reporting_Accept_Time__c,Notification_Date__c,Reporting_Accepted_Date__c from ACE_Customer_MailOut__c where Customer_Core_Price_Changes__c in:custList and Customer_Core_Price_Changes__r.Customer_Response__c = 'Approved' and Email_Template_Code__c =:'1' and Reporting_Accepted_Date__c!=null order by CreatedDate asc];
            }
            else{
				//changed email template code from 3 to 1-sfdc 910713.                
                CustList2 = [Select Customer_Core_Price_Changes__r.id,Reporting_Accept_Time__c,Notification_Date__c,Reporting_Accepted_Date__c from ACE_Customer_MailOut__c where Customer_Core_Price_Changes__c in:custList and Email_Template_Code__c =:'1' and Customer_Core_Price_Changes__r.Customer_Response__c = 'Approved' and Reporting_Accepted_Date__c!=null order by CreatedDate asc];
            }
        }
        else if(reportType == 'Compliance')//end of sfdc 00910713
        {
            
            if(sortfieldName == '' || sortfieldName == null)
                sortfieldName = 'Customer__r.Cust_ID__c';
            if(sortDirection == '' || sortDirection ==  null)
                sortDirection = 'ASC';
            
            if((ColumnVal != '' || ColumnVal != null) && ColumnVal == 'compapprovalcust'){
                if(compStatus == 'All'){
                    //changed email template code from 3 to 1-sfdc 910713.
                    CustList2 = [Select Customer_Core_Price_Changes__r.id,Notification_Date__c,Customer_Core_Price_Changes__r.Notification_Status3__c,Customer_Core_Price_Changes__r.Customer_Response__c,Reporting_Accepted_Date__c  from ACE_Customer_MailOut__c where Customer_Core_Price_Changes__c in:custList and Email_Template_Code__c = '1' order by CreatedDate asc];
                }
                else if(compStatus == 'Compliance Pending'){
                    //changed email template code from 3 to 1-sfdc 910713.
                    CustList2 = [Select Customer_Core_Price_Changes__r.id,Notification_Date__c,Customer_Core_Price_Changes__r.Notification_Status3__c,Customer_Core_Price_Changes__r.Customer_Response__c,Reporting_Accepted_Date__c  from ACE_Customer_MailOut__c where Customer_Core_Price_Changes__c in:custList and Email_Template_Code__c = '1' and (Customer_Core_Price_Changes__r.Notification_Status3__c != 'Sent' or Customer_Core_Price_Changes__r.Customer_Response__c != 'Approved') order by CreatedDate asc];           
                    
                }
                else if(compStatus == 'Compliance Approved'){
                    //changed email template code from 3 to 1-sfdc 910713.                    
                    CustList2 = [Select Customer_Core_Price_Changes__r.id,Notification_Date__c,Customer_Core_Price_Changes__r.Notification_Status3__c,Customer_Core_Price_Changes__r.Customer_Response__c,Reporting_Accepted_Date__c  from ACE_Customer_MailOut__c where Customer_Core_Price_Changes__c in:custList and Email_Template_Code__c = '1' and Customer_Core_Price_Changes__r.Notification_Status3__c = 'Sent' and Customer_Core_Price_Changes__r.Customer_Response__c = 'Approved' order by CreatedDate asc];           
                }                              
            }
            else if((ColumnVal != '' || ColumnVal != null) && ColumnVal == 'compnotifycust'){
                if(compStatus == 'All'){ 
                    CustList2 = [Select Customer_Core_Price_Changes__r.id,Notification_Date__c,Customer_Core_Price_Changes__r.Notification_Status3__c,Customer_Core_Price_Changes__r.Customer_Response__c,Reporting_Accepted_Date__c  from ACE_Customer_MailOut__c where Customer_Core_Price_Changes__c in:custList and Email_Template_Code__c = '2' order by CreatedDate asc];
                }
                else if(compStatus == 'Compliance Pending'){
                    custList2 = [Select Customer_Core_Price_Changes__r.id,Notification_Date__c,Customer_Core_Price_Changes__r.Notification_Status3__c,Customer_Core_Price_Changes__r.Customer_Response__c,Reporting_Accepted_Date__c  from ACE_Customer_MailOut__c where Customer_Core_Price_Changes__c in:custList and Email_Template_Code__c = '2' and Customer_Core_Price_Changes__r.Notification_Status3__c != 'Sent'  order by CreatedDate asc];
                }
                else if(compStatus == 'Compliance Approved'){ 
                    CustList2 = [Select Customer_Core_Price_Changes__r.id,Notification_Date__c,Customer_Core_Price_Changes__r.Notification_Status3__c,Customer_Core_Price_Changes__r.Customer_Response__c,Reporting_Accepted_Date__c  from ACE_Customer_MailOut__c where Customer_Core_Price_Changes__c in:custList and Email_Template_Code__c = '2' and Customer_Core_Price_Changes__r.Notification_Status3__c = 'Sent'  order by CreatedDate asc];           
                }   
            }
        }//end of sfdc 00910713 
        
        lCustListReportData = new List<CustListReportDataCls>();//moved here from inside of if //sfdc 910713
             
        if(CustList2.size()>0){
            //List<ID> CustList2 = Database.query(ResQuery);
                              
            map<ID,ACE_Customer_MailOut__c> mapCustAccpt = new map<ID,ACE_Customer_MailOut__c>();
            Set<ID> CustSet = new set<ID>();
            for(ACE_Customer_MailOut__c MO: CustList2)
            {
                CustSet.add(MO.Customer_Core_Price_Changes__r.id);
                if(!mapCustAccpt.containsKey(MO.Customer_Core_Price_Changes__r.id)){
                    mapCustAccpt.put(MO.Customer_Core_Price_Changes__r.id, MO);
                }
            }
            
            //sfdc 00910713 - added Notification_Status3__c,Customer_Response__c in the below query
            String ResQuery1 = 'select id,Customer__r.Name,Customer__r.Cust_ID__c,Customer__r.owner.name,Notification_Status3__c,Customer_Response__c from ACE_Customer_Price_Changes__c where id in:CustSet';               
            
            List<ACE_Customer_Price_Changes__c> lTotal = new List<ACE_Customer_Price_Changes__c>();
            lTotal = Database.query(ResQuery1);
            total_size = lTotal.size();
            
            ///sfdc -- 910713
            if(total_size < List_size){
                counter = 0;
            }
            
            ResQuery1 = ResQuery1 + ' order by '+ sortfieldName+' '+sortDirection+' limit : List_size offset :counter';
            System.debug('>>>>>>>>>>>>>>>>>>>Query2' + ResQuery1 );
            system.debug('counter:'+counter);
            system.debug('List_size:'+List_size);
            system.debug('total_size:'+total_size);
                      
            lCustomerListNotifyResponse = database.query(ResQuery1);
           // lCustListReportData = new List<CustListReportDataCls>(); moved before if //sfdc 910713
            
            for(ACE_Customer_Price_Changes__c LC: lCustomerListNotifyResponse){                
                CustListReportDataCls rec = new CustListReportDataCls(); 
                rec.IDCust= LC.id;               
                rec.CustID= LC.Customer__r.Cust_ID__c;
                rec.CustName= LC.Customer__r.Name;               
                rec.CustNotifyDate=  mapCustAccpt.get(LC.id).Notification_Date__c;

                if(reportType == 'Notification' || reportType == 'Response'){//sfdc 00910713
                  rec.repName= LC.Customer__r.owner.name;   
                }//sfdc 00910713
                
                if(reportType == 'Response'){
                    rec.AcceptedDate=mapCustAccpt.get(LC.id).Reporting_Accepted_Date__c;
                    rec.AcceptTime= mapCustAccpt.get(LC.id).Reporting_Accept_Time__c;                    
                }
                
                if(reportType == 'Compliance')//sfdc 00910713 --start
                {                                 
                   rec.CustNotifyStatus = LC.Notification_Status3__c;
                   rec.AcceptedDate=mapCustAccpt.get(LC.id).Reporting_Accepted_Date__c;
                   rec.CustApprovalStatus = LC.Customer_Response__c;
                    
                }//sfdc 00910713-- end
                
                lCustListReportData.add(rec);
            }
             
           
        }
        else if(CustList2.size() == 0){//if there are no data to show cleanup the global lists and global variables//sfdc 910713 start 
                if(!lCustListReportData.isempty()){
                       lCustListReportData.clear();        
                }
                total_size = 0;
        } //sfdc 910713 end
        
        return null;
    }
    public class CustListReportDataCls{
        public ID IDCust{get;set;}
        public String CustID{get;set;}
        public String CustName{get;set;}
        public Decimal AcceptTime{get;set;}
        public String repName{get;set;}
        public Datetime AcceptedDate{get;set;}
        Public Datetime CustNotifyDate{get;set;}
        public string CustNotifyStatus{get;set;}//sfdc 00910713
        public string CustApprovalStatus{get;set;}//sfdc 00910713
    }
    //End of Customer List  - customer response / notification by guha
    
    
    // Revenue and Margin Customer List DateException Report Code Start here
    public List<ACE_Customer_Price_Changes__c> lCustomerListReportData {get;set;}
    public PageReference loadCustomerListData()
    {
        getACECustomerList();
        system.debug('<<<<<<<<<<<<Quarter>>>>>>>>>>'+SegmentName);
        system.debug('Customers Returned from Hierarchy:' + custList.size());
        //User hierarchy code - ends
        
        String ResQuery='';
        String FieldName='';
        lCustomerListReportData = new List<ACE_Customer_Price_Changes__c>();
        System.debug('>>>>>>>>>>>>>>>>>>>Query' + reportType);    
        if(reportType =='Summary by Sector/Segment') //sfdc 910698, 910700
        {
           if((segmentType != null) && (SegmentType != ''))
                {
                     //sfdc 910696 - removed PRICE_NOT_CALCULATED__c= false where clause from below queries.
                    ResQuery = 'Select id,Report_SKU_Count__c,Report_New_Gross_IGM_ACE__c,Report_Total_Spend_Impact_12_Month_ACE__c,New_Gross_IGM__c,Total_Spend_Impact_12_Month__c ,cUSTOMER__r.name,customer__r.id,Customer__r.sector__c,Customer__r.segment__c from ACE_Customer_Price_Changes__c where Customer__r.segment__c= \'' + SegmentType + '\' and Customer__r.sector__c= \'' + SegmentName + '\' and id in :custList';
                }
           else 
               ResQuery = 'Select id,Report_SKU_Count__c,Report_New_Gross_IGM_ACE__c,Report_Total_Spend_Impact_12_Month_ACE__c,New_Gross_IGM__c,Total_Spend_Impact_12_Month__c ,cUSTOMER__r.name,customer__r.id from ACE_Customer_Price_Changes__c where  Customer__r.sector__c= \'' + SegmentName + '\' and id in :custList';       
               
            if(rowName == 'Value of Increases Passed to Customers')
            {
               ResQuery = ResQuery + ' and (Report_isSKU_Exception__c=false and EffectiveDate_IsDifferent__c =false)';
                //' and Report_SKU_Count__c >= 1 ';//sfdc 861332
            }
           
        }       
        else if(reportType == 'Summary By Region')//sfdc 910696
        {    
            //sfdc 910696 - removed PRICE_NOT_CALCULATED__c= false where clause from below queries.
            ////and added 'Other' condition for non industry specified customer accounts.
            if(SegmentName == 'Other') 
            	ResQuery = 'Select id,Report_SKU_Count__c,Report_New_Gross_IGM_ACE__c,Report_Total_Spend_Impact_12_Month_ACE__c,New_Gross_IGM__c,cUSTOMER__r.name,customer__r.id,name,Total_Spend_Impact_12_Month__c from ACE_Customer_Price_Changes__c where id in :custList and (Customer__r.Owner.Region__c = null OR Customer__r.Owner.Region__c = \'Other\')';          
            else
                ResQuery = 'Select id,Report_SKU_Count__c,Report_New_Gross_IGM_ACE__c,Report_Total_Spend_Impact_12_Month_ACE__c,New_Gross_IGM__c,cUSTOMER__r.name,customer__r.id,name,Total_Spend_Impact_12_Month__c from ACE_Customer_Price_Changes__c where id in :custList and Customer__r.Owner.Region__c = \'' + SegmentName + '\'';          
            
            if(rowName == 'Value of Increases Passed to Customers')
            {
               ResQuery = ResQuery + 'and (Report_isSKU_Exception__c=false and EffectiveDate_IsDifferent__c =false)';
               //' and Report_SKU_Count__c >= 1 ';//sfdc 861332
            }
          //  ResQuery = 'Select id,Reporting_sales_price_Effective_Change__c,cUSTOMER__r.name,customer__r.id,Customer__r.Owner.Region__c, Customer_Category__c,Sales_Price_Change_Effective_Date__c,Sales_Price_Change_Effective_Date_Min__c,Reporting_Erosion_Field_Delay__c,Reporting_Erosion_Margin_Field_Delay__c,Customer__r.sector__c,Customer__r.segment__c from ACE_Customer_Price_Changes__c where Reporting_sales_price_Effective_Change__c=true and Customer__r.Owner.Region__c = \'' + SegmentName + '\' and id in :custList ';       
        }
        else if(reportType == 'Summary by Industry/Vertical Market')//910703 - changed the report NAME
        {
            FieldName = 'Customer__r.Industry_OD_SIC_Rep__c';
            //sfdc 910696 - removed PRICE_NOT_CALCULATED__c= false where clause from below queries.
            //and added 'Other' condition for non industry specified customer accounts.
            if(SegmentName == 'Other')                
                ResQuery = 'Select id,Report_SKU_Count__c,Report_New_Gross_IGM_ACE__c,Report_Total_Spend_Impact_12_Month_ACE__c,New_Gross_IGM__c,Total_Spend_Impact_12_Month__c ,cUSTOMER__r.name,customer__r.id,Customer__r.sector__c,Customer__r.segment__c from ACE_Customer_Price_Changes__c where (Customer__r.Industry_OD_SIC_Rep__c = null OR Customer__r.Industry_OD_SIC_Rep__c = \'Other\') and id in :custList ';       			                          
            else 
            	ResQuery = 'Select id,Report_SKU_Count__c,Report_New_Gross_IGM_ACE__c,Report_Total_Spend_Impact_12_Month_ACE__c,New_Gross_IGM__c,Total_Spend_Impact_12_Month__c ,cUSTOMER__r.name,customer__r.id,Customer__r.sector__c,Customer__r.segment__c from ACE_Customer_Price_Changes__c where Customer__r.Industry_OD_SIC_Rep__c = \'' + SegmentName + '\' and id in :custList ';       
            
            if(rowName == 'Value of Increases Passed to Customers')
            {
               ResQuery = ResQuery + 'and (Report_isSKU_Exception__c=false and EffectiveDate_IsDifferent__c =false)';
               //' and Report_SKU_Count__c >= 1 ';//sfdc 861332
            }
        }
        else if(reportType == 'Summary by Participation (Buying Group/GPO)')
        {
            FieldName  = 'Customer__r.Buying_Group__c';
            //sfdc 910696 - removed PRICE_NOT_CALCULATED__c= false where clause from below queries.
            if(SegmentName == 'Other'){
                //SegmentName = null;
                ResQuery = 'Select id,Report_SKU_Count__c,Report_New_Gross_IGM_ACE__c,Report_Total_Spend_Impact_12_Month_ACE__c,New_Gross_IGM__c,Total_Spend_Impact_12_Month__c ,cUSTOMER__r.name,customer__r.id,Customer__r.sector__c,Customer__r.segment__c from ACE_Customer_Price_Changes__c where Customer__r.Buying_Group__c = null and id in :custList ';       
				               
            }
            else                
            	ResQuery = 'Select id,Report_SKU_Count__c,Report_New_Gross_IGM_ACE__c,Report_Total_Spend_Impact_12_Month_ACE__c,New_Gross_IGM__c,Total_Spend_Impact_12_Month__c ,cUSTOMER__r.name,customer__r.id,Customer__r.sector__c,Customer__r.segment__c from ACE_Customer_Price_Changes__c where Customer__r.Buying_Group__c like \'' + SegmentName + '%\' and id in :custList ';       
            
            //----------
            if(rowName == 'Value of Increases Passed to Customers')
            {
               ResQuery = ResQuery + 'and (Report_isSKU_Exception__c=false and EffectiveDate_IsDifferent__c =false)';
                //' and Report_SKU_Count__c >= 1 ';//sfdc 861332
                 //ResQuery = ResQuery + ' and Report_SKU_Count__c >= 1 ';
            }
        }         
        
        // searchWord = searchWord.deleteWhitespace();
            if((searchWord != null) && (searchWord != '') && (searchWord != 'null'))
            {      
                String textToSearch = searchWord + '%';
                ResQuery = ResQuery+ ' and (Owning_Customer_ID__c LIKE \'' + textToSearch + '\' or Customer__r.name LIKE \'' + textToSearch + '\') ';
            }
            
        System.debug('>>>>>>>>>>>>>>>>>>>Query' + ResQuery );
        List<ACE_Customer_Price_Changes__c> lTotal = new List<ACE_Customer_Price_Changes__c>();
        lTotal = Database.query(ResQuery);
        total_size = lTotal.size();
        ResQuery = ResQuery + ' order by '+ sortfieldName+' '+sortDirection+' limit : List_size offset :counter';
        // ResQuery = ResQuery +' limit 999';
        System.debug('>>>>>>>>>>>>>>>>>>>Query2' + ResQuery );
        System.debug('madhavi-total_size:'+total_size);
        lCustomerListReportData = database.query(ResQuery);
        
        return null;
    }
    
    
    // Erosion DateException Report Code Start here
    public List<ACE_Customer_Price_Changes__c> lErosionDateReportDataList {get;set;}
    public PageReference loadErosionDateData()
    {
        //for initial Customr list
        getACECustomerList();
        system.debug('<<<<<<<<<<<<Quarter>>>>>>>>>>'+SegmentName);
        system.debug('Customers Returned from Hierarchy:' + custList.size());
        //User hierarchy code - ends
        
        lErosionDateReportDataList = new List<ACE_Customer_Price_Changes__c>();
        
        String ResQuery= '';
        String FieldName = '';
        //sfdc 910698, 910700,910701,910703 --- Removed PRICE_NOT_CALCULATED__c= false from all the queries below  
        if(reportType =='Summary by Sector/Segment')//sfdc 910698, 910700
        {
            if((segmentType != null) && (SegmentType != ''))
            {
                //handling the ivalid customers to show as other on reporting - madhavi
            	if(SegmentName == 'Other')
                	SegmentName = null;
                ResQuery = 'Select id,Reporting_sales_price_Effective_Change__c,cUSTOMER__r.name,customer__r.id,Customer_Category__c,Sales_Price_Change_Effective_Date__c,Sales_Price_Change_Effective_Date_Min__c,Reporting_Erosion_Field_Delay__c,Reporting_Erosion_Margin_Field_Delay__c,Customer__r.sector__c,Customer__r.segment__c from ACE_Customer_Price_Changes__c where (Report_isSKU_Exception__c=true OR EffectiveDate_IsDifferent__c =true) and Reporting_sales_price_Effective_Change__c=true and  Customer__r.segment__c= \'' + SegmentType + '\' and Customer__r.sector__c= \'' + SegmentName + '\' and id in :custList ';
            }
            else{
                 //handling the ivalid customers to show as other on reporting - madhavi
            	if(SegmentName == 'Other')
                	SegmentName = null;
                 ResQuery = 'Select id,Reporting_sales_price_Effective_Change__c,cUSTOMER__r.name,customer__r.id,Customer_Category__c,Sales_Price_Change_Effective_Date__c,Sales_Price_Change_Effective_Date_Min__c,Reporting_Erosion_Field_Delay__c,Reporting_Erosion_Margin_Field_Delay__c,Customer__r.sector__c,Customer__r.segment__c from ACE_Customer_Price_Changes__c where (Report_isSKU_Exception__c=true OR EffectiveDate_IsDifferent__c =true) and Reporting_sales_price_Effective_Change__c=true and Customer__r.sector__c= \'' + SegmentName + '\' and id in :custList ';       
            }
        }   
        else if(reportType == 'Summary By Region')//sfdc 910696
        {
            //handling the ivalid customers to show as other on reporting - madhavi
            if(SegmentName == 'Other')
                	SegmentName = null;
            ResQuery = 'Select id,Reporting_sales_price_Effective_Change__c,cUSTOMER__r.name,customer__r.id,Customer__r.Owner.Region__c, Customer_Category__c,Sales_Price_Change_Effective_Date__c,Sales_Price_Change_Effective_Date_Min__c,Reporting_Erosion_Field_Delay__c,Reporting_Erosion_Margin_Field_Delay__c,Customer__r.sector__c,Customer__r.segment__c from ACE_Customer_Price_Changes__c where (Report_isSKU_Exception__c=true OR EffectiveDate_IsDifferent__c =true) and Reporting_sales_price_Effective_Change__c=true and Customer__r.Owner.Region__c = \'' + SegmentName + '\' and id in :custList ';       
    	}
        else if(reportType == 'Summary by Industry/Vertical Market')//910703 - changed the report NAME
        {
            FieldName = 'Customer__r.Industry_OD_SIC_Rep__c';
            //handling the ivalid customers to show as other on reporting - madhavi
            //if(SegmentName == 'Other')
               //	SegmentName = null;
            ResQuery = 'Select id,Reporting_sales_price_Effective_Change__c,cUSTOMER__r.name,customer__r.id,Customer__r.Industry_OD_SIC_Rep__c,Customer__r.Owner.Region__c, Customer_Category__c,Sales_Price_Change_Effective_Date__c,Sales_Price_Change_Effective_Date_Min__c,Reporting_Erosion_Field_Delay__c,Reporting_Erosion_Margin_Field_Delay__c,Customer__r.sector__c,Customer__r.segment__c from ACE_Customer_Price_Changes__c where (Report_isSKU_Exception__c=true OR EffectiveDate_IsDifferent__c =true) and Reporting_sales_price_Effective_Change__c=true and Customer__r.Industry_OD_SIC_Rep__c = \'' + SegmentName + '\' and id in :custList ';       
        }
        else if(reportType == 'Summary by Participation (Buying Group/GPO)')
        {
            FieldName  = 'Customer__r.Buying_Group__c';
            //handling the ivalid customers to show as other on reporting - madhavi
            if(SegmentName == 'Other')
               ResQuery = 'Select id,Reporting_sales_price_Effective_Change__c,cUSTOMER__r.name,customer__r.id,Customer__r.Industry_OD_SIC_Rep__c,Customer__r.Owner.Region__c, Customer_Category__c,Sales_Price_Change_Effective_Date__c,Sales_Price_Change_Effective_Date_Min__c,Reporting_Erosion_Field_Delay__c,Reporting_Erosion_Margin_Field_Delay__c,Customer__r.sector__c,Customer__r.segment__c from ACE_Customer_Price_Changes__c where (Report_isSKU_Exception__c=true OR EffectiveDate_IsDifferent__c =true) and Reporting_sales_price_Effective_Change__c=true and Customer__r.Buying_Group__c  = null and id in :custList ';       
            else
            	ResQuery = 'Select id,Reporting_sales_price_Effective_Change__c,cUSTOMER__r.name,customer__r.id,Customer__r.Industry_OD_SIC_Rep__c,Customer__r.Owner.Region__c, Customer_Category__c,Sales_Price_Change_Effective_Date__c,Sales_Price_Change_Effective_Date_Min__c,Reporting_Erosion_Field_Delay__c,Reporting_Erosion_Margin_Field_Delay__c,Customer__r.sector__c,Customer__r.segment__c from ACE_Customer_Price_Changes__c where (Report_isSKU_Exception__c=true OR EffectiveDate_IsDifferent__c =true) and Reporting_sales_price_Effective_Change__c=true and Customer__r.Buying_Group__c like \'' + SegmentName + '%\' and id in :custList ';       
        }         
        //searchWord = searchWord.deleteWhitespace();
            if((searchWord != null) && (searchWord != '') && (searchWord != 'null'))
            {      
                String textToSearch = searchWord + '%';
                ResQuery = ResQuery+ ' and (Owning_Customer_ID__c LIKE \'' + textToSearch + '\' or Customer__r.name LIKE \'' + textToSearch + '\') ';
            }
        
        System.debug('>>>>>>>>>>>>>>>>>>>Query' + sortfieldName);
        List<ACE_Customer_Price_Changes__c> lTotal = new List<ACE_Customer_Price_Changes__c>();
        lTotal = Database.query(ResQuery);
        total_size = lTotal.size();
        ResQuery = ResQuery + ' order by '+ sortfieldName+' '+sortDirection+' limit : List_size offset :counter';
        
        System.debug('>>>>>>>>>>>>>>>>>>>Query2' + ResQuery );
        
         lErosionDateReportDataList = database.query(ResQuery);
            
        //for(ACE_Customer_Price_Changes__c  c: lCustRecs)
        //{
               // if(c.Sales_Price_Change_Effective_Date_Min__c > c.Sales_Price_Change_Effective_Date__c)
        //           lErosionDateReportDataList.add(c); 
        //}
        
        return null;
    }
    
    
    // Erosion Date Exception Report Code End here
    
    // Erosion Price Exception Report Code Start here
    public List<ACE_Customer_SKU_Changes__c> lErosionPriceReportDataList {get;set;}
    public PageReference loadErosionPriceData()
    {
        //for initial Customr list
        getACECustomerList();
        system.debug('<<<<<<<<<<<<Quarter>>>>>>>>>>'+SegmentName);
        system.debug('Customers Returned from Hierarchy:' + custList.size());
        //User hierarchy code - ends
        
        lErosionPriceReportDataList = new List<ACE_Customer_SKU_Changes__c>();
        
        String ResQuery= '';
        String FieldName = '';
        if(reportType =='Summary by Sector/Segment')//sfdc 910698, 910700
        {
            if((segmentType != null) && (SegmentType != ''))
            {
                //handling the ivalid customers to show as other on reporting - madhavi
            	if(SegmentName == 'Other')
               		SegmentName = null;
                ResQuery = 'Select id, Reporting_Approved_Price__c,SKU_Description__c ,SKU__c,Reporting_Erosion_Margin_Field_MarkDown__c,Reporting_Erosion_Field_MarkDown__c,Approved_Proposed_Price__c,Proposed_Price_with_Cap__c,Current_Sell_Price__c,Ace_Customer_core_changes__r.ACE_Customer_Price_Changes__r.Customer__r.id,Ace_Customer_core_changes__r.ACE_Customer_Price_Changes__r.Customer__r.Name,Ace_Customer_core_changes__r.ACE_Customer_Price_Changes__r.Customer__r.Aops_Cust_id__c from ACE_Customer_SKU_Changes__c where PRICE_NOT_CALCULATED__c= false and Reporting_Approved_Price__c=true and Ace_Customer_core_changes__r.ACE_Customer_Price_Changes__r.Customer__r.segment__c= \'' + SegmentType + '\' and Ace_Customer_core_changes__r.ACE_Customer_Price_Changes__r.Customer__r.sector__c= \'' + SegmentName + '\' and Ace_Customer_core_changes__r.ACE_Customer_Price_Changes__r.id in :custList and (Ace_Customer_core_changes__r.ACE_Customer_Price_Changes__r.Report_isSKU_Exception__c=true OR  Ace_Customer_core_changes__r.ACE_Customer_Price_Changes__r.EffectiveDate_IsDifferent__c =true)';
            }
            else{
                //handling the ivalid customers to show as other on reporting - madhavi
            	if(SegmentName == 'Other')
               		SegmentName = null;
                ResQuery = 'Select id,Reporting_Approved_Price__c,SKU_Description__c , SKU__c,Reporting_Erosion_Margin_Field_MarkDown__c,Reporting_Erosion_Field_MarkDown__c,Approved_Proposed_Price__c,Proposed_Price_with_Cap__c,Current_Sell_Price__c,Ace_Customer_core_changes__r.ACE_Customer_Price_Changes__r.Customer__r.id,Ace_Customer_core_changes__r.ACE_Customer_Price_Changes__r.Customer__r.Name,Ace_Customer_core_changes__r.ACE_Customer_Price_Changes__r.Customer__r.Aops_Cust_id__c from ACE_Customer_SKU_Changes__c  where PRICE_NOT_CALCULATED__c= false and Reporting_Approved_Price__c=true and Ace_Customer_core_changes__r.ACE_Customer_Price_Changes__r.Customer__r.sector__c= \'' + SegmentName + '\' and Ace_Customer_core_changes__r.ACE_Customer_Price_Changes__r.id in :custList and (Ace_Customer_core_changes__r.ACE_Customer_Price_Changes__r.Report_isSKU_Exception__c=true OR Ace_Customer_core_changes__r.ACE_Customer_Price_Changes__r.EffectiveDate_IsDifferent__c =true)';       
            }
        }   
        else if(reportType == 'Summary By Region')//sfdc 910696
        {
            //handling the ivalid customers to show as other on reporting - madhavi
            if(SegmentName == 'Other')
               	SegmentName = null;
            ResQuery = 'Select id,Reporting_Approved_Price__c,SKU_Description__c , SKU__c,Reporting_Erosion_Margin_Field_MarkDown__c,Reporting_Erosion_Field_MarkDown__c,Approved_Proposed_Price__c,Proposed_Price_with_Cap__c,Current_Sell_Price__c,Ace_Customer_core_changes__r.ACE_Customer_Price_Changes__r.Customer__r.id,Ace_Customer_core_changes__r.ACE_Customer_Price_Changes__r.Customer__r.Name,Ace_Customer_core_changes__r.ACE_Customer_Price_Changes__r.Customer__r.Aops_Cust_id__c from ACE_Customer_SKU_Changes__c  where PRICE_NOT_CALCULATED__c= false and Reporting_Approved_Price__c=true and Ace_Customer_core_changes__r.ACE_Customer_Price_Changes__r.Customer__r.Owner.Region__c = \'' + SegmentName + '\' and Ace_Customer_core_changes__r.ACE_Customer_Price_Changes__r.id in :custList and (Ace_Customer_core_changes__r.ACE_Customer_Price_Changes__r.Report_isSKU_Exception__c=true OR  Ace_Customer_core_changes__r.ACE_Customer_Price_Changes__r.EffectiveDate_IsDifferent__c =true)';       
        }
        else if(reportType == 'Summary by Industry/Vertical Market')//910703 - changed the report NAME
        {
            FieldName = 'Customer__r.Industry_OD_SIC_Rep__c';
            //handling the ivalid customers to show as other on reporting - madhavi
            if(SegmentName == 'Other')
               	SegmentName = null;
            ResQuery = 'Select id,Reporting_Approved_Price__c,SKU_Description__c , SKU__c,Reporting_Erosion_Margin_Field_MarkDown__c,Reporting_Erosion_Field_MarkDown__c,Approved_Proposed_Price__c,Proposed_Price_with_Cap__c,Current_Sell_Price__c,Ace_Customer_core_changes__r.ACE_Customer_Price_Changes__r.Customer__r.id,Ace_Customer_core_changes__r.ACE_Customer_Price_Changes__r.Customer__r.Name,Ace_Customer_core_changes__r.ACE_Customer_Price_Changes__r.Customer__r.Aops_Cust_id__c from ACE_Customer_SKU_Changes__c  where PRICE_NOT_CALCULATED__c= false and Reporting_Approved_Price__c=true and Ace_Customer_core_changes__r.ACE_Customer_Price_Changes__r.Customer__r.Industry_OD_SIC_Rep__c = \'' + SegmentName + '\' and Ace_Customer_core_changes__r.ACE_Customer_Price_Changes__r.id in :custList and (Ace_Customer_core_changes__r.ACE_Customer_Price_Changes__r.Report_isSKU_Exception__c=true OR  Ace_Customer_core_changes__r.ACE_Customer_Price_Changes__r.EffectiveDate_IsDifferent__c =true)';       
        }
        else if(reportType == 'Summary by Participation (Buying Group/GPO)')
        {
            FieldName  = 'Customer__r.Buying_Group__c';
            //handling the ivalid customers to show as other on reporting - madhavi
            if(SegmentName == 'Other')               
            	ResQuery = 'Select id,Reporting_Approved_Price__c,SKU_Description__c , SKU__c,Reporting_Erosion_Margin_Field_MarkDown__c,Reporting_Erosion_Field_MarkDown__c,Approved_Proposed_Price__c,Proposed_Price_with_Cap__c,Current_Sell_Price__c,Ace_Customer_core_changes__r.ACE_Customer_Price_Changes__r.Customer__r.id,Ace_Customer_core_changes__r.ACE_Customer_Price_Changes__r.Customer__r.Name,Ace_Customer_core_changes__r.ACE_Customer_Price_Changes__r.Customer__r.Aops_Cust_id__c from ACE_Customer_SKU_Changes__c  where PRICE_NOT_CALCULATED__c= false and  Reporting_Approved_Price__c=true and Ace_Customer_core_changes__r.ACE_Customer_Price_Changes__r.Customer__r.Buying_Group__c  = null and Ace_Customer_core_changes__r.ACE_Customer_Price_Changes__r.id in :custList and (Ace_Customer_core_changes__r.ACE_Customer_Price_Changes__r.Report_isSKU_Exception__c=true OR  Ace_Customer_core_changes__r.ACE_Customer_Price_Changes__r.EffectiveDate_IsDifferent__c =true)'; 
            else
                ResQuery = 'Select id,Reporting_Approved_Price__c,SKU_Description__c , SKU__c,Reporting_Erosion_Margin_Field_MarkDown__c,Reporting_Erosion_Field_MarkDown__c,Approved_Proposed_Price__c,Proposed_Price_with_Cap__c,Current_Sell_Price__c,Ace_Customer_core_changes__r.ACE_Customer_Price_Changes__r.Customer__r.id,Ace_Customer_core_changes__r.ACE_Customer_Price_Changes__r.Customer__r.Name,Ace_Customer_core_changes__r.ACE_Customer_Price_Changes__r.Customer__r.Aops_Cust_id__c from ACE_Customer_SKU_Changes__c  where PRICE_NOT_CALCULATED__c= false and  Reporting_Approved_Price__c=true and Ace_Customer_core_changes__r.ACE_Customer_Price_Changes__r.Customer__r.Buying_Group__c like \'' + SegmentName + '%\' and Ace_Customer_core_changes__r.ACE_Customer_Price_Changes__r.id in :custList and (Ace_Customer_core_changes__r.ACE_Customer_Price_Changes__r.Report_isSKU_Exception__c=true OR  Ace_Customer_core_changes__r.ACE_Customer_Price_Changes__r.EffectiveDate_IsDifferent__c =true)';           
        } 
        
        //searchWord = searchWord.deleteWhitespace();
            if((searchWord != null) && (searchWord != '') && (searchWord != 'null'))
            {      
                String textToSearch = searchWord + '%';
                ResQuery = ResQuery+ ' and (SKU__c LIKE \'' + textToSearch + '\' or Ace_Customer_core_changes__r.ACE_Customer_Price_Changes__r.Customer__r.name LIKE \'' + textToSearch + '\') ';
            }
        System.debug('>>>>>>>>>>>>>>>>>>>Query' + ResQuery );
        List<ACE_Customer_SKU_Changes__c> lTotal = new List<ACE_Customer_SKU_Changes__c>();
        lTotal = Database.query(ResQuery);
        total_size= lTotal.size();
        ResQuery = ResQuery + ' order by '+ sortfieldName+' '+sortDirection+' limit :List_size offset :counter';
        lErosionPriceReportDataList = database.query(ResQuery);
            
       // for(ACE_Customer_SKU_Changes__c  c: lCustRecs)
       // {
       //         if(c.Approved_Proposed_Price__c < c.Proposed_Price_with_Cap__c)
       //            lErosionPriceReportDataList.add(c); 
       // }
        
        return null;
    }
    
    
    // Erosion Price Exception Report Code End here
    
    // Exception Customer List Code Start Here
    public List<ACE_Customer_Price_Changes__c> lExceptionReportCustList {get;set;}
    public List<ACE_Customer_SKU_Changes__c> lExceptionReportSKUList {get;set;}
    public PageReference ExceptionReportCustList() 
    {
        getACECustomerList();
        system.debug('<<<<<<<<<<<<Quarter>>>>>>>>>>'+listType );
        system.debug('Customers Returned from Hierarchy:' + custList.size());
        //User hierarchy code - ends
        
        String ResQuery='';
        String FieldName='';
        lExceptionReportCustList = new List<ACE_Customer_Price_Changes__c>();
        lExceptionReportSKUList = new List<ACE_Customer_SKU_Changes__c>();
         if(listType == 'Date-Requested')
        {
            ResQuery = 'select Customer__r.id,Customer__r.name, Owning_Customer_ID__c,Total_Spend_Impact_12_Month__c,New_Gross_IGM__c from ACE_Customer_Price_Changes__c where id in:custList and Approval_Satus__c!=null';  
        } 
        else  if(listType == 'Date-Rejected')
        {
            ResQuery = 'select Customer__r.id,Customer__r.name, Owning_Customer_ID__c,Total_Spend_Impact_12_Month__c,New_Gross_IGM__c from ACE_Customer_Price_Changes__c where id in:custList and Approval_Satus__c=\'Rejected\' ';  
        } 
        else  if(listType == 'Date-Modified')
        {
            ResQuery = 'select Customer__r.id,Customer__r.name, Owning_Customer_ID__c,Total_Spend_Impact_12_Month__c,New_Gross_IGM__c from ACE_Customer_Price_Changes__c where id in:custList and Approval_Satus__c = \'Approved\' and Reporting_Date_Modified_By_Approver__c = true ';  
        } 
        else  if(listType == 'Date-Approved')
        {
            ResQuery = 'select Customer__r.id,Customer__r.name, Owning_Customer_ID__c,Total_Spend_Impact_12_Month__c,New_Gross_IGM__c from ACE_Customer_Price_Changes__c where id in:custList and Approval_Satus__c = \'Approved\' and Reporting_Date_Modified_By_Approver__c = false ';  
        } 
     
        if(listType == 'Price-Requested')
        {
            ResQuery = 'select Ace_Customer_core_changes__r.ACE_Customer_Price_Changes__r.Customer__r.id,Ace_Customer_core_changes__r.ACE_Customer_Price_Changes__r.Customer__r.name, Ace_Customer_core_changes__r.ACE_Customer_Price_Changes__r.Total_Spend_Impact_12_Month__c, Ace_Customer_core_changes__r.ACE_Customer_Price_Changes__r.Owning_Customer_ID__c,Ace_Customer_core_changes__r.ACE_Customer_Price_Changes__r.New_Gross_IGM__c from ACE_Customer_SKU_Changes__c  where Ace_Customer_core_changes__r.ACE_Customer_Price_Changes__r.id in :custList and Approval_status__c != null ';  
        } 
        else  if(listType == 'Price-Rejected')
        {
            ResQuery = 'select Ace_Customer_core_changes__r.ACE_Customer_Price_Changes__r.Owning_Customer_ID__c,Ace_Customer_core_changes__r.ACE_Customer_Price_Changes__r.Customer__r.id,Ace_Customer_core_changes__r.ACE_Customer_Price_Changes__r.Customer__r.name, Ace_Customer_core_changes__r.ACE_Customer_Price_Changes__r.Total_Spend_Impact_12_Month__c, Ace_Customer_core_changes__r.ACE_Customer_Price_Changes__r.New_Gross_IGM__c from ACE_Customer_SKU_Changes__c  where Ace_Customer_core_changes__r.ACE_Customer_Price_Changes__r.id in :custList and Approval_status__c =\'Rejected\' ';  
        } 
        else  if(listType == 'Price-Modified')
        {
            ResQuery = 'select Ace_Customer_core_changes__r.ACE_Customer_Price_Changes__r.Owning_Customer_ID__c,Ace_Customer_core_changes__r.ACE_Customer_Price_Changes__r.Customer__r.id,Ace_Customer_core_changes__r.ACE_Customer_Price_Changes__r.Customer__r.name, Ace_Customer_core_changes__r.ACE_Customer_Price_Changes__r.Total_Spend_Impact_12_Month__c, Ace_Customer_core_changes__r.ACE_Customer_Price_Changes__r.New_Gross_IGM__c from ACE_Customer_SKU_Changes__c  where Ace_Customer_core_changes__r.ACE_Customer_Price_Changes__r.id in :custList and Approval_status__c = \'Approved\' and Reporting_Price_Modified_By_Approver__c= true ';  
        } 
        else  if(listType == 'Price-Approved')
        {
            ResQuery = 'select Ace_Customer_core_changes__r.ACE_Customer_Price_Changes__r.Owning_Customer_ID__c,Ace_Customer_core_changes__r.ACE_Customer_Price_Changes__r.Customer__r.id,Ace_Customer_core_changes__r.ACE_Customer_Price_Changes__r.Customer__r.name, Ace_Customer_core_changes__r.ACE_Customer_Price_Changes__r.Total_Spend_Impact_12_Month__c, Ace_Customer_core_changes__r.ACE_Customer_Price_Changes__r.New_Gross_IGM__c from ACE_Customer_SKU_Changes__c  where Ace_Customer_core_changes__r.ACE_Customer_Price_Changes__r.id in :custList and Approval_status__c = \'Approved\' and Reporting_Price_Modified_By_Approver__c = false ';  
        } 
      
        
        
        //searchWord = searchWord.deleteWhitespace();
            if((searchWord != null) && (searchWord != '') && (searchWord != 'null'))
            {      
                String textToSearch = searchWord.trim() + '%';
                if(listType == 'Date-Requested' || listType == 'Date-Rejected' || listType == 'Date-Modified' || listType == 'Date-Approved')
                    ResQuery = ResQuery+ ' and (Owning_Customer_ID__c LIKE \'' + textToSearch + '\' or Customer__r.name LIKE \'' + textToSearch + '\') ';
                if(listType == 'Price-Requested' || listType == 'Price-Rejected' || listType == 'Price-Modified' || listType == 'Price-Approved')
                    ResQuery = ResQuery+ ' and (Ace_Customer_core_changes__r.ACE_Customer_Price_Changes__r.Owning_Customer_ID__c LIKE \'' + textToSearch + '\' or Ace_Customer_core_changes__r.ACE_Customer_Price_Changes__r.Customer__r.name LIKE \'' + textToSearch + '\') ';    
            }
            
        if(listType == 'Date-Requested' || listType == 'Date-Rejected' || listType == 'Date-Modified' || listType == 'Date-Approved'){
            List<ACE_Customer_Price_Changes__c> lTotal = new List<ACE_Customer_Price_Changes__c>();
            lTotal = Database.query(ResQuery);
            total_size = lTotal.size();
            ResQuery = ResQuery + ' order by '+ sortfieldName+' '+sortDirection+' limit : List_size offset :counter';
            System.debug('>>>>>>>>>>>>>>>>>>>Query' + ResQuery );
            lExceptionReportCustList = database.query(ResQuery);
        }
        else if(listType == 'Price-Requested' || listType == 'Price-Rejected' || listType == 'Price-Modified' || listType == 'Price-Approved'){
            sortfieldName = 'Ace_Customer_core_changes__r.ACE_Customer_Price_Changes__r.Customer__r.name';
            List<ACE_Customer_SKU_Changes__c>  lTotal = new List<ACE_Customer_SKU_Changes__c>();
            lTotal = Database.query(ResQuery);
            total_size = lTotal.size();
            ResQuery = ResQuery + ' order by '+ sortfieldName+' '+sortDirection+' limit : List_size offset :counter';
            System.debug('>>>>>>>>>>>>>>>>>>>Query' + ResQuery );
            lExceptionReportSKUList = database.query(ResQuery);
        }
        
       
        return null;
    }

    
    // Code Ends Here 
    
    //Exception Report Code Starts Here
    public List<ExceptionReportDataCls> lExceptionFinalReportData {get;set;}
    public List<ExceptionReportDataCls> lExceptionFinalReportData2 {get;set;}
    public PageReference loadExceptionData()
    {
        //for initial Customr list
        getACECustomerList();
        system.debug('<<<<<<<<<<<<Quarter>>>>>>>>>>'+SegmentName);
        system.debug('Customers Returned from Hierarchy:' + custList.size());
        //User hierarchy code - ends
        String FieldName = '';
        String CustQuery = '';
        String skuQuery = '';
        Decimal CustModApp = 0;
        Decimal skuModApp = 0;
        Decimal CustApp = 0;
        Decimal skuApp = 0;                
        
        //list<String> dTypes = new list<String> {'Amount lost due to WA Timing Restrictions','Amount lost due to WA Vendor Letter Requirements','Amount lost due to WA Cap Restrictions','Amount lost due to Field Delay','Amount lost due to Field Markdown'};         
        
        if(reportType == 'Exception')
        {
            FieldName = '';
            CustQuery = 'select COUNT(id) reqcnt, Approval_Satus__c status, SUM(Reporting_Exception_Revenue_Field_Delay__c) RevReqDateVal, SUM(Reporting_Exception_Margin_Field_Delay__c) MargReqDateVal, SUM(Reporting_Erosion_Field_Delay__c) RevAppDateVal, SUM(Reporting_Erosion_Margin_Field_Delay__c) MargAppDateVal from ACE_Customer_Price_Changes__c  where id in :custList group by Approval_Satus__c';       
            skuQuery = 'select COUNT(id) reqcnt, Approval_status__c status, SUM(Reporting_Exception_Field_MarkDown__c) RevReqPriceVal, SUM(Reporting_Exception_Mgn_Field_MarkDown__c) MargReqPriceVal, SUM(Reporting_Erosion_Field_MarkDown__c) RevAppPriceVal, SUM(Reporting_Erosion_Margin_Field_MarkDown__c) MargAppPriceVal  from ACE_Customer_SKU_Changes__c  where Ace_Customer_core_changes__r.ACE_Customer_Price_Changes__r.id in :custList and Approval_status__c != null group by Approval_status__c ';       
            
            CustModApp = [Select count() from ACE_Customer_Price_Changes__c  where id in :custList and Approval_Satus__c = 'Approved' and Reporting_Date_Modified_By_Approver__c = true];       
            skuModApp = [Select count() from ACE_Customer_SKU_Changes__c  where Ace_Customer_core_changes__r.ACE_Customer_Price_Changes__r.id in :custList and Approval_status__c = 'Approved' and Reporting_Price_Modified_By_Approver__c = true];     
            
            CustApp = [Select count() from ACE_Customer_Price_Changes__c  where id in :custList and Approval_Satus__c = 'Approved' and Reporting_Date_Modified_By_Approver__c = false];       
            skuApp = [Select count() from ACE_Customer_SKU_Changes__c  where Ace_Customer_core_changes__r.ACE_Customer_Price_Changes__r.id in :custList and Approval_status__c = 'Approved' and Reporting_Price_Modified_By_Approver__c = false];      
        }
        AggregateResult[] DateRes = DataBase.query(CustQuery);
        AggregateResult[] PriceRes = DataBase.query(skuQuery);
        
        Decimal custrequested = 0;
        Decimal skurequested = 0;
        Decimal custRejected = 0;
        Decimal skuRejected = 0;
        
        Decimal RevDateVal = 0;
        Decimal RevPriceVal = 0;
        Decimal RevDateRejVal =0;
        Decimal RevPriceRejVal =0;
        
        Decimal MargDateVal = 0;
        Decimal MargPriceVal = 0;
        Decimal MargDateRejVal =0;
        Decimal MargPriceRejVal =0;
        
        Decimal RevDateAppVal =0;
        Decimal RevPriceAppVal =0;
        Decimal MargDateAppVal =0;
        Decimal MargPriceAppVal =0;
                                   
        for (AggregateResult ar : DateRes ){            
            if(ar.get('reqcnt')!=null){
                if((String)ar.get('status') == 'Rejected' || (String)ar.get('status') == 'Approved' ||(String)ar.get('status') == 'Pending')
                custrequested = custrequested + double.valueof(ar.get('reqcnt'));
                RevDateVal = RevDateVal + double.valueof(ar.get('RevReqDateVal'));
                MargDateVal = MargDateVal + double.valueof(ar.get('MargReqDateVal'));
            }
            if((String)ar.get('status') == 'Rejected'){
                custRejected = custRejected + double.valueof(ar.get('reqcnt'));
                RevDateRejVal = double.valueof(ar.get('RevReqDateVal'));
                MargDateRejVal = double.valueof(ar.get('MargReqDateVal'));
                System.debug('~~~~~~~~~~~'+ar);
            }
            if((String)ar.get('status') == 'Approved'){                
                RevDateAppVal = double.valueof(ar.get('RevReqDateVal'));
                MargDateAppVal = double.valueof(ar.get('MargReqDateVal'));
                System.debug('~~~~~~~~~~~'+ar);
            }
                        
        }
        for (AggregateResult ar1 : PriceRes ){
            if(ar1.get('reqcnt')!=null){
                if((String)ar1.get('status') == 'Rejected' || (String)ar1.get('status') == 'Approved' || (String)ar1.get('status') == 'Pending')
                skurequested = skurequested + double.valueof(ar1.get('reqcnt'));
                RevPriceVal = RevPriceVal + double.valueof(ar1.get('RevReqPriceVal'));
                MargPriceVal = MargPriceVal + double.valueof(ar1.get('MargReqPriceVal'));
            }
            if((String)ar1.get('status') == 'Rejected'){
                skuRejected = double.valueof(ar1.get('reqcnt'));
                RevPriceRejVal = double.valueof(ar1.get('RevReqPriceVal'));
                MargPriceRejVal = double.valueof(ar1.get('MargReqPriceVal'));
                System.debug('~~~~~~~~~~~'+ar1);
            }
            if((String)ar1.get('status') == 'Approved'){                
                RevPriceAppVal = double.valueof(ar1.get('RevReqPriceVal'));
                MargPriceAppVal = double.valueof(ar1.get('MargReqPriceVal'));
                System.debug('~~~~~~~~~~~'+ar1);
            }
        }
         
        lExceptionFinalReportData = new List<ExceptionReportDataCls>();      
        lExceptionFinalReportData2 = new List<ExceptionReportDataCls>();      
        
        //Revenue Data//    
        ExceptionReportDataCls rec = new ExceptionReportDataCls();        
        rec.dataType ='Date';
        rec.Requested = custrequested;
        rec.RequestedValue = RevDateVal ;
        rec.Rejected= custRejected;
        rec.RejectedValue = RevDateRejVal;
        rec.Modified= CustModApp;        
        rec.Approved= CustApp;
        rec.ApprovedValue = RevDateAppVal;
        
        ExceptionReportDataCls rec2 = new ExceptionReportDataCls();
        rec2.dataType ='Price';
        rec2.Requested = skurequested;
        rec2.RequestedValue = RevPriceVal;
        rec2.Rejected= skuRejected;
        rec2.RejectedValue = RevPriceRejVal;
        rec2.Modified= skuModApp;        
        rec2.Approved= skuApp;
        rec2.ApprovedValue = RevPriceAppVal;
        
        //Margin Data//  
        ExceptionReportDataCls rec3 = new ExceptionReportDataCls();
        rec3.dataType ='Date';
        rec3.Requested = custrequested;
        rec3.RequestedValue = MargDateVal;
        rec3.Rejected= custRejected;
        rec3.RejectedValue = MargDateRejVal;
        rec3.Modified= CustModApp;        
        rec3.Approved= CustApp;
        rec3.ApprovedValue = MargDateAppVal;
        
        ExceptionReportDataCls rec4 = new ExceptionReportDataCls();
        rec4.dataType ='Price';
        rec4.Requested = skurequested;
        rec4.RequestedValue = MargPriceVal;
        rec4.Rejected= skuRejected;
        rec4.RejectedValue = MargPriceRejVal;
        rec4.Modified= skuModApp;        
        rec4.Approved= skuApp;
        rec2.ApprovedValue = MargPriceAppVal ;
        
        lExceptionFinalReportData.add(rec); 
        lExceptionFinalReportData.add(rec2);
        lExceptionFinalReportData2.add(rec3); 
        lExceptionFinalReportData2.add(rec4); 
        
        return null;
    }
    
    public class ExceptionReportDataCls 
    {
     public String formatType {get;set;}
     public String dataType {get;set;}
         
     public Decimal Requested{get;set;}
     public Decimal RequestedValue{get;set;}
     public Decimal Rejected{get;set;}
     public Decimal RejectedValue{get;set;}
     public Decimal Modified{get;set;}
     public Decimal ModifiedValue{get;set;}
     public Decimal Approved{get;set;}
     public Decimal ApprovedValue{get;set;}
     
     public String ReportName{get;set;}
     
    }
    
    // Exception Report Code End here
    
    
    // ACE Vendavo Report Code Start here
    //public Transient List<Ace_Customer_SKU_Changes__c> lVendSKUListReportData {get;set;}
    //public Transient Map<String,Decimal> map_ID_SKU{get;set;}
    //public Transient Map<String,Decimal> map_SKU_current_vendvo_price{get;set;}//sfdc-901711
  	  
    
    public void vendavoRep_searchBtnclick(){
        counter = 0;
        //VendSKUListReportData();
        VendSKUListReportData_1();
    }
    // ACE Vendavo Report Code ends here
    
    // Customer Not Full Increase Report Code Start here
    public List<Ace_Customer_SKU_Changes__c> lSKUListReportData {get;set;}
    
    public PageReference loadDataCustNotFullInc()
    {
        sortfieldName = 'SKU__c';
        getACECustomerList();
        lSKUListReportData = new List<Ace_Customer_SKU_Changes__c>();
        
        String ResQuery='';
        ResQuery = 'select id, Alt_SKU__c, Status__c, Reporting_Passed_Margin__c,Reporting_Prosposed_Margin__c,Current_Margin_12_Month__c,approved_proposed_price__c,proposed_price_without_cap__c,Current_Sell_Price__c,proposed_price_with_cap__c, SFDC_Notification_Flag__c,Ace_customer_core_changes__r.ace_customer_price_changes__r.Customer__r.owner.name,Ace_customer_core_changes__r.ace_customer_price_changes__r.Customer__r.Name,Ace_customer_core_changes__r.ace_customer_price_changes__r.Owning_Customer_ID__c,SKU__c from Ace_Customer_SKU_Changes__c where Ace_customer_core_changes__r.ace_customer_price_changes__r.id in:custList and PRICE_NOT_CALCULATED__c = false and Reporting_Approved_Without_Cap_Price__c = true and status__c != \'Inactive\' ';  
        
        //searchWord = searchWord.deleteWhitespace();
            if((searchWord != null) && (searchWord != '') && (searchWord != 'null'))
            {      
                String textToSearch = searchWord.trim() + '%';
                ResQuery = ResQuery+ ' and (SKU__c LIKE \'' + textToSearch + '\' or Ace_Customer_core_changes__r.ACE_Customer_Price_Changes__r.Customer__r.name LIKE \'' + textToSearch + '\') ';
            }
        
        List<Ace_Customer_SKU_Changes__c> lTotal = new List<Ace_Customer_SKU_Changes__c>();
        lTotal = Database.query(ResQuery);
        total_size = lTotal.size();
        ResQuery = ResQuery + ' order by '+ sortfieldName+' '+sortDirection+' limit : List_size offset :counter';
        System.debug('>>>>>>>>>>>>>>>>>>>Query' + ResQuery );
        
        
        lSKUListReportData = database.query(ResQuery);
        return null;
    
    }
    
    
    
    // Process Progress/Pipeline Customer List Report Code Start here
    public List<ACE_Customer_Price_Changes__c> lCustListProcssProgReportData {get;set;}
    public PageReference CustListProcssProgReportData()
    {
        getACECustomerList();
        
        system.debug('<<<<<<<<<<<<sortfieldName>>>>>>>>>>'+ sortfieldName );
        system.debug('<<<<<<<<<<<<sortDirection >>>>>>>>>>'+ sortDirection );
        system.debug('Customers Returned from Hierarchy:' + custList.size());
        //User hierarchy code - ends
        
        String ResQuery='';
        String FieldName='';
        lCustListProcssProgReportData = new List<ACE_Customer_Price_Changes__c>();
        if(listType == 'Customers with Increases')
        {
            ResQuery = 'select Owning_Customer_ID__c,Customer__r.id,Customer__r.name, Total_Spend_Impact_12_Month__c,New_Gross_IGM__c from ACE_Customer_Price_Changes__c where id in:custList ';  
        } 
        else if(listType == 'Eligible Customers')
        {
            ResQuery = 'select Owning_Customer_ID__c,Customer__r.id,Customer__r.name, Total_Spend_Impact_12_Month__c,New_Gross_IGM__c from ACE_Customer_Price_Changes__c where id in:custList and Report_SKU_Count__c > 0 and PRICE_NOT_CALCULATED__c= false';  
        }   
        else if(listType == 'Customers Auto-Routed to Remediation')
        {
            ResQuery = 'select Owning_Customer_ID__c,Customer__r.id,Customer__r.name, Total_Spend_Impact_12_Month__c,New_Gross_IGM__c from ACE_Customer_Price_Changes__c where id in:custList and Report_SKU_Count__c > 0 and PRICE_NOT_CALCULATED__c= false and IsRemediation__c = true and (Remedy_Status__c = \'\' or Remedy_Status__c = null)';  
        } 
        else if(listType == 'Customers Approved for Remediation')
        {
            ResQuery = 'select Owning_Customer_ID__c,Customer__r.id,Customer__r.name, Total_Spend_Impact_12_Month__c,New_Gross_IGM__c from ACE_Customer_Price_Changes__c where id in:custList and Report_SKU_Count__c > 0 and PRICE_NOT_CALCULATED__c= false and IsRemediation__c = true and (Remedy_Status__c = \'Approved\')';  
        }
        else if(listType == 'Customers w/Hosted Catalog')
        {
            ResQuery = 'select Owning_Customer_ID__c,Customer__r.id,Customer__r.name, Total_Spend_Impact_12_Month__c,New_Gross_IGM__c from ACE_Customer_Price_Changes__c where id in:custList and Report_SKU_Count__c > 0 and PRICE_NOT_CALCULATED__c= false and Hosted_Catalog__c = true';  
        }
        else if(listType == 'In-Process Customers')
        {
            ResQuery = 'select Owning_Customer_ID__c,Customer__r.id,Customer__r.name, Total_Spend_Impact_12_Month__c,New_Gross_IGM__c from ACE_Customer_Price_Changes__c where id in:custList and Report_SKU_Count__c > 0 and IsRemediation__c = false and Hosted_Catalog__c = false  and PRICE_NOT_CALCULATED__c= false';  
        }
        else if(listType == 'Awaiting Approval Request Push')
        {
            ResQuery = 'select Owning_Customer_ID__c,Customer__r.id,Customer__r.name, Total_Spend_Impact_12_Month__c,New_Gross_IGM__c from ACE_Customer_Price_Changes__c where id in:custList and SFDC_Notification_Flag__c = \'3\' and Notification_Status_Code__c <> \'NOTIFY-DELIVERED\' and IsRemediation__c <> true and Hosted_Catalog__c <> true and Report_SKU_Count__c > 0 and PRICE_NOT_CALCULATED__c= false';  
        }
        else if(listType == 'Awating Customer Approval')
        {
            ResQuery = 'select Owning_Customer_ID__cCustomer__r.id,Customer__r.name, Total_Spend_Impact_12_Month__c,New_Gross_IGM__c from ACE_Customer_Price_Changes__c where id in:custList and SFDC_Notification_Flag__c = \'3\' and Notification_Status_Code__c = \'NOTIFY-DELIVERED\' and Customer_Response__c <> \'Approved\' and IsRemediation__c <> true and Hosted_Catalog__c <> true and Report_SKU_Count__c > 0 and PRICE_NOT_CALCULATED__c= false';  
        }
        else if(listType == 'Awaiting Notification Push')
        {
            ResQuery = 'select Owning_Customer_ID__c,Customer__r.id,Customer__r.name, Total_Spend_Impact_12_Month__c,New_Gross_IGM__c from ACE_Customer_Price_Changes__c where id in:custList and SFDC_Notification_Flag__c = \'2\' and Notification_Status_Code__c <> \'NOTIFY-DELIVERED\' and IsRemediation__c <> true and Hosted_Catalog__c <> true and Report_SKU_Count__c > 0 and PRICE_NOT_CALCULATED__c= false';  
        }
        else if(listType == 'Awaiting Default Implementation')
        {
            ResQuery = 'select Owning_Customer_ID__c,Customer__r.id,Customer__r.name, Total_Spend_Impact_12_Month__c,New_Gross_IGM__c from ACE_Customer_Price_Changes__c where id in:custList and ( ((SFDC_Notification_Flag__c = \'1\') or (SFDC_Notification_Flag__c = \'2\' and Notification_Status_Code__c = \'NOTIFY-DELIVERED\')) or (SFDC_Notification_Flag__c = \'3\' and Customer_Response__c = \'Approved\')) and IsRemediation__c <> true and Hosted_Catalog__c <> true and Report_SKU_Count__c > 0 and PRICE_NOT_CALCULATED__c= false';  
        }
        else if(listType == 'In-Process Customers Not Implemented')
        {
            ResQuery = 'select Owning_Customer_ID__c,Customer__r.id,Customer__r.name, Total_Spend_Impact_12_Month__c,New_Gross_IGM__c from ACE_Customer_Price_Changes__c where id in:custList and Implementation_Status_Code__c <> \'DATA-SUCCESS\' and IsRemediation__c <> true and Hosted_Catalog__c <> true and Report_SKU_Count__c > 0 and PRICE_NOT_CALCULATED__c= false';  
        }
        else if(listType == 'In-Process Customers Implemented')
        {
            ResQuery = 'select Owning_Customer_ID__c,Customer__r.id,Customer__r.name, Total_Spend_Impact_12_Month__c,New_Gross_IGM__c from ACE_Customer_Price_Changes__c where id in:custList and Implementation_Status_Code__c = \'DATA-SUCCESS\' and IsRemediation__c <> true and Hosted_Catalog__c <> true and Report_SKU_Count__c > 0 and PRICE_NOT_CALCULATED__c= false';  
        }
         //searchWord = searchWord.deleteWhitespace();
            if((searchWord != null) && (searchWord != '') && (searchWord != 'null'))
            {      
                String textToSearch = searchWord.trim() + '%';
                ResQuery = ResQuery+ ' and (Owning_Customer_ID__c LIKE \'' + textToSearch + '\' or Customer__r.name LIKE \'' + textToSearch + '\') ';
            }
        
        List<ACE_Customer_Price_Changes__c> lTotal = new List<ACE_Customer_Price_Changes__c>();
        lTotal = Database.query(ResQuery);
        total_size = lTotal.size();
        ResQuery = ResQuery + ' order by '+ sortfieldName+' '+sortDirection+' limit : List_size offset :counter';
        System.debug('>>>>>>>>>>>>>>>>>>>Query' + ResQuery );
        
        
        lCustListProcssProgReportData = database.query(ResQuery);
        
        return null;
    }
    
    // Remediation Customer List Code Start Here
    public List<ACE_Customer_Price_Changes__c> lRemediationReportCustList {get;set;}
    public PageReference RemediationReportCustList() 
    {
        getACECustomerList();
        system.debug('<<<<<<<<<<<<Quarter>>>>>>>>>>'+listType );
        system.debug('Customers Returned from Hierarchy:' + custList.size());
        //User hierarchy code - ends
        
        String ResQuery='';
        String FieldName='';
        lRemediationReportCustList = new List<ACE_Customer_Price_Changes__c>();
        //if(listType == 'Auto-Routes')//<!--SfDC 00910708-->
        if(listType == 'Pre-Quals')//<!--SfDC 00910708-->
        {
            ResQuery = 'select Owning_Customer_ID__c,Customer__r.id,Customer__r.name, Total_Spend_Impact_12_Month__c,New_Gross_IGM__c from ACE_Customer_Price_Changes__c where PRICE_NOT_CALCULATED__c= false and id in:custList and IsRemediation__c = true and (Remedy_Status__c = \'\' or Remedy_Status__c = null)';  
        } 
        //else if(listType == 'Completed-Auto-Routes')//<!--SfDC 00910708-->
        else if(listType == 'Completed-Pre-Quals')//<!--SfDC 00910708-->
        {
            ResQuery = 'select Owning_Customer_ID__c,Customer__r.id,Customer__r.name, Total_Spend_Impact_12_Month__c,New_Gross_IGM__c from ACE_Customer_Price_Changes__c where PRICE_NOT_CALCULATED__c= false and id in:custList and Remediation_Hold__c = false and IsRemediation__c = true and (Remedy_Status__c = \'\' or Remedy_Status__c = null)';  
        }
        else if(listType == 'Sales-Support')
        {
            ResQuery = 'select Owning_Customer_ID__c,Customer__r.id,Customer__r.name, Total_Spend_Impact_12_Month__c,New_Gross_IGM__c from ACE_Customer_Price_Changes__c where PRICE_NOT_CALCULATED__c= false and id in:custList and (Remedy_Status__c != \'\' and Remedy_Status__c != null)';  
        }
        else if(listType == 'Rejected-Requests')
        {
            ResQuery = 'select Owning_Customer_ID__c,Customer__r.id,Customer__r.name, Total_Spend_Impact_12_Month__c,New_Gross_IGM__c from ACE_Customer_Price_Changes__c where PRICE_NOT_CALCULATED__c= false and id in:custList and (Remedy_Status__c = \'Rejected\')';  
        }
        else if(listType == 'Approved-Requests')
        {
            ResQuery = 'select Owning_Customer_ID__c,Customer__r.id,Customer__r.name, Total_Spend_Impact_12_Month__c,New_Gross_IGM__c from ACE_Customer_Price_Changes__c where PRICE_NOT_CALCULATED__c= false and id in:custList and (Remedy_Status__c = \'Approved\')';  
        }
        else if(listType == 'Completed-Requests')
        {
            ResQuery = 'select Owning_Customer_ID__c,Customer__r.id,Customer__r.name, Total_Spend_Impact_12_Month__c,New_Gross_IGM__c from ACE_Customer_Price_Changes__c where PRICE_NOT_CALCULATED__c= false and id in:custList and Remediation_Hold__c = false and (Remedy_Status__c = \'Approved\')';  
        }
        
        //searchWord = searchWord.deleteWhitespace();
            if((searchWord != null) && (searchWord != '') && (searchWord != 'null'))
            {      
                String textToSearch = searchWord.trim() + '%';
                ResQuery = ResQuery+ ' and (Owning_Customer_ID__c LIKE \'' + textToSearch + '\' or Customer__r.name LIKE \'' + textToSearch + '\') ';
            }
        
        List<ACE_Customer_Price_Changes__c> lTotal = new List<ACE_Customer_Price_Changes__c>();
        lTotal = Database.query(ResQuery);
        total_size = lTotal.size();
        ResQuery = ResQuery + ' order by '+ sortfieldName+' '+sortDirection+' limit : List_size offset :counter';
        System.debug('>>>>>>>>>>>>>>>>>>>Query' + ResQuery );
        
        
        lRemediationReportCustList = database.query(ResQuery);
        return null;
    }

    
    // Code Ends Here
    
   
    
    // Remediation Report code starts here
    public List<RemediationDataCls> lRemediationDataCls {get;set;}
    public PageReference loadDataRemediation() 
    {    
        //for initial Customr list
        getACECustomerList();
        AggregateResult[] ResultsAutoRoutes = [select count(id) custCnt  
                                                               from ACE_Customer_Price_Changes__c where  id in:custList and Customer__r.Remediation_Required__c = true  and IsRemediation__c = true and (Remedy_Status__c = '' or Remedy_Status__c = null)];          
       
        
        AggregateResult[] ResultsCompAutoRoutes = [select count(id) custCnt, AVG(Remediation_Time__c) RemTime 
                                                               from ACE_Customer_Price_Changes__c where id in:custList  and Customer__r.Remediation_Required__c = true and Remediation_Hold__c = false and IsRemediation__c = true and (Remedy_Status__c = '' or Remedy_Status__c = null)];          
       
        
        AggregateResult[] ResultsSalesSupport = [select count(id) custCnt 
                                                               from ACE_Customer_Price_Changes__c where id in:custList  and (Remedy_Status__c != '' and Remedy_Status__c != null)];          
       
       
        AggregateResult[] ResultsRejReq = [select count(id) custCnt 
                                                               from ACE_Customer_Price_Changes__c where id in:custList and (Remedy_Status__c = 'Rejected')];          
        
        AggregateResult[] ResultsAppReq = [select count(id) custCnt
                                                               from ACE_Customer_Price_Changes__c where id in:custList  and (Remedy_Status__c = 'Approved')];          
       
        AggregateResult[] ResultsCompReq = [select count(id) custCnt, AVG(Remediation_Time__c) RemReqTime 
                                                               from ACE_Customer_Price_Changes__c where id in:custList and Remediation_Hold__c = false and (Remedy_Status__c = 'Approved')];          
       
        RemediationDataCls rem = new RemediationDataCls();
        rem.AutoRouteRecCount = Double.ValueOf(ResultsAutoRoutes[0].get('custCnt'));
        rem.CompletedRouteRecCount = Double.ValueOf(ResultsCompAutoRoutes[0].get('custCnt'));
        rem.SalesSupportReq = Double.ValueOf(ResultsSalesSupport[0].get('custCnt'));
        rem.RejectedReq= Double.ValueOf(ResultsRejReq[0].get('custCnt'));
        rem.ApprovedReq= Double.ValueOf(ResultsAppReq[0].get('custCnt'));
        rem.CompletedReq= Double.ValueOf(ResultsCompReq[0].get('custCnt'));
        if(Double.Valueof(ResultsCompAutoRoutes[0].get('RemTime'))!=null)
            rem.AvgTimeAutoRoutes = Double.Valueof(ResultsCompAutoRoutes[0].get('RemTime'));
        else
            rem.AvgTimeAutoRoutes = 0;
        if(Double.Valueof(ResultsCompReq[0].get('RemReqTime'))!=null)
            rem.AvgTimeCompReq = Double.Valueof(ResultsCompReq[0].get('RemReqTime'));
        else
            rem.AvgTimeCompReq = 0;
        lRemediationDataCls = new List<RemediationDataCls>();
        lRemediationDataCls.add(rem);
        return null;
    }
    
    public class RemediationDataCls 
    {
         public String formatType {get;set;}
         public String dataType {get;set;}
         public Decimal AutoRouteRecCount{get;set;}
         public Decimal CompletedRouteRecCount{get;set;}
         public Decimal SalesSupportReq{get;set;}
         public Decimal RejectedReq{get;set;}
         public Decimal ApprovedReq{get;set;}
         public Decimal CompletedReq{get;set;}
         public Decimal AvgTimeAutoRoutes{get;set;}
         public Decimal AvgTimeCompReq{get;set;}
    }
    // Remediation Report code ends here
    
     // Hosted Catalog Customer List Code Start Here
    public Boolean HostedCatalogCaseList{get;set;} 
    public List<ACE_Customer_Price_Changes__c> lHostedCatalogReportCustList {get;set;}
    public List<Case> lHostedCatalogReportCaseList {get;set;}
    public PageReference HostedCatalogReportCustList() 
    {
        getACECustomerList();
        system.debug('<<<<<<<<<<<<Quarter>>>>>>>>>>'+listType );
        system.debug('Customers Returned from Hierarchy:' + custList.size());
        //User hierarchy code - ends
        
        String ResQuery='';
        String FieldName='';
        lHostedCatalogReportCustList = new List<ACE_Customer_Price_Changes__c>();
        lHostedCatalogReportCaseList = new List<Case>();
        if(listType == 'ImpactedCustomer')
        {
            ResQuery = 'select Owning_Customer_ID__c ,Customer__r.id,Customer__r.name, Total_Spend_Impact_12_Month__c,New_Gross_IGM__c from ACE_Customer_Price_Changes__c where PRICE_NOT_CALCULATED__c= false and id in:custList and Hosted_Catalog__c = true ';  
            if((searchWord != null) && (searchWord != '') && (searchWord != 'null'))
            {      
                String textToSearch = searchWord.trim() + '%';
                ResQuery = ResQuery+ ' and (Owning_Customer_ID__c LIKE \'' + textToSearch + '\' or Customer__r.name LIKE \'' + textToSearch + '\') ';
            }
            List<ACE_Customer_Price_Changes__c> lTotal = new List<ACE_Customer_Price_Changes__c>();
            lTotal = Database.query(ResQuery);
            total_size = lTotal.size();
            ResQuery = ResQuery + ' order by '+ sortfieldName+' '+sortDirection+' limit : List_size offset :counter';
            System.debug('>>>>>>>>>>>>>>>>>>>Query' + ResQuery );
            lHostedCatalogReportCustList = database.query(ResQuery);
        }
        else if(listType == 'WRFCaseCount')
        {
            HostedCatalogCaseList = true;
            ResQuery = '';
            ResQuery = 'Select id,caseNumber from Case where Price_Change_Link__c in :lStringHostedCustURL and RecordTypeId=: caseRecordType and Price_Change_Link__c != null and WRF_Request_Type__c = \'BSD Pricing\'';   
            List<Case> lTotal = new List<Case>();
            lTotal = Database.query(ResQuery);
            total_size = lTotal.size();
            ResQuery = ResQuery + ' order by CaseNumber ' +sortDirection+' limit : List_size offset :counter';
            System.debug('>>>>>>>>>>>>>>>>>>>Query' + ResQuery );
            lHostedCatalogReportCaseList = database.query(ResQuery);
        }
        else if(listType == 'WRFCompletedCaseCount')
        {
            HostedCatalogCaseList = true;
            ResQuery = ''; 
            ResQuery = 'Select id,caseNumber from Case where Price_Change_Link__c in :lStringHostedCustURL and RecordTypeId=: caseRecordType  and Price_Change_Link__c != null and IT_Action_Taken__c=\'Completed\' and Status = \'Closed\' and WRF_Request_Type__c = \'BSD Pricing\'';  
            List<Case> lTotal = new List<Case>();
            lTotal = Database.query(ResQuery);
            total_size = lTotal.size();
            ResQuery = ResQuery + ' order by CaseNumber ' +sortDirection+' limit : List_size offset :counter';
            System.debug('>>>>>>>>>>>>>>>>>>>Query' + ResQuery );
            lHostedCatalogReportCaseList = database.query(ResQuery);
        }
        else if((listType == 'RevenueTotal') || (listType == 'MarginTotal'))
        {
            
            AggregateResult[] ResultsCaseClosedGrpID = [select count(id) custCnt ,Price_Change_Link__c nm
                                                                from Case where Price_Change_Link__c in :lStringHostedCustURL and RecordTypeId=: caseRecordType and Price_Change_Link__c != null and WRF_Request_Type__c = 'BSD Pricing' and IT_Action_Taken__c='Completed' and Status = 'Closed' group by Price_Change_Link__c];          
            Set<String> sCustIDs = new Set<String>();
            for (AggregateResult ar : ResultsCaseClosedGrpID )
                    {
                        if((String)ar.get('nm') != null) 
                        {
                            String[] temp = ((String)ar.get('nm')).split(CS.Domain_URL__c +'/');
                            sCustIDs.add(temp[1]); 
                        }
                    }
                    
            
            ResQuery = 'select Owning_Customer_ID__c,Customer__r.id,Customer__r.name, Total_Spend_Impact_12_Month__c,New_Gross_IGM__c from ACE_Customer_Price_Changes__c where PRICE_NOT_CALCULATED__c= false and id in:sCustIDs and Hosted_Catalog__c = true ';  
            
 //searchWord = searchWord.deleteWhitespace();
            if((searchWord != null) && (searchWord != '') && (searchWord != 'null'))
            {      
                String textToSearch = searchWord.trim() + '%';
                ResQuery = ResQuery+ ' and (Owning_Customer_ID__c LIKE \'' + textToSearch + '\' or Customer__r.name LIKE \'' + textToSearch + '\') ';
            }
            
            List<ACE_Customer_Price_Changes__c> lTotal = new List<ACE_Customer_Price_Changes__c>();
            lTotal = Database.query(ResQuery);
            total_size = lTotal.size();
            ResQuery = ResQuery + ' order by '+ sortfieldName+' '+sortDirection+' limit : List_size offset :counter';
            System.debug('>>>>>>>>>>>>>>>>>>>Query' + ResQuery );
            lHostedCatalogReportCustList = database.query(ResQuery);
        }
        else if((listType == 'RevenueCount') || (listType == 'MarginCount'))
        {
            ResQuery = 'select Owning_Customer_ID__c,Customer__r.id,Customer__r.name, Total_Spend_Impact_12_Month__c,New_Gross_IGM__c from ACE_Customer_Price_Changes__c where PRICE_NOT_CALCULATED__c= false and Hosted_Catalog__c = true ';  
            if((searchWord != null) && (searchWord != '') && (searchWord != 'null'))
            {      
                String textToSearch = searchWord.trim() + '%';
                ResQuery = ResQuery+ ' and (Owning_Customer_ID__c LIKE \'' + textToSearch + '\' or Customer__r.name LIKE \'' + textToSearch + '\') ';
            }
            List<ACE_Customer_Price_Changes__c> lTotal = new List<ACE_Customer_Price_Changes__c>();
            lTotal = Database.query(ResQuery);
            total_size = lTotal.size();
            ResQuery = ResQuery + ' order by '+ sortfieldName+' '+sortDirection+' limit : List_size offset :counter';
            System.debug('>>>>>>>>>>>>>>>>>>>Query' + ResQuery );
            lHostedCatalogReportCustList = database.query(ResQuery);
        }
        
        return null;
    }

    
    // Code Ends Here
    
    
    //  Hosted Catalog Report code starts here
    public List<HostedCatalogDataCls> lHostedCatalogDataCls {get;set;}
    public PageReference loadDataHostedCatalog() 
    {    
        //for initial Customr list        
        getACECustomerList();
        
            
        system.debug('custList-madhavi'+custList.size());    
        AggregateResult[] ResultsImpHostedCust = [select count(id) custCnt 
                                                               from ACE_Customer_Price_Changes__c where  id in:custList  and Hosted_Catalog__c = true];          
       
        AggregateResult[] ResultsCaseCount = [select count(id) custCnt 
                                                               from Case where Price_Change_Link__c in :lStringHostedCustURL and RecordTypeId=: caseRecordType and Price_Change_Link__c != null and WRF_Request_Type__c = 'BSD Pricing' ];          
       
        AggregateResult[] ResultsCaseClosed = [select count(id) custCnt 
                                                                from Case where Price_Change_Link__c in :lStringHostedCustURL and RecordTypeId=: caseRecordType and Price_Change_Link__c != null and IT_Action_Taken__c='Completed' and WRF_Request_Type__c = 'BSD Pricing' and Status = 'Closed'];          
        
        AggregateResult[] ResultsCaseClosedGrpID = [select count(id) custCnt ,Price_Change_Link__c nm
                                                                from Case where Price_Change_Link__c in :lStringHostedCustURL and RecordTypeId=: caseRecordType and Price_Change_Link__c != null and IT_Action_Taken__c='Completed' and WRF_Request_Type__c = 'BSD Pricing' and Status = 'Closed' group by Price_Change_Link__c];          
        
        Set<String> sCustIDs = new Set<String>();
        for (AggregateResult ar : ResultsCaseClosedGrpID )
                {
                    if((String)ar.get('nm') != null) 
                    {
                        String[] temp = ((String)ar.get('nm')).split(CS.Domain_URL__c +'/');
                        sCustIDs.add(temp[1]); 
                    }
                }
                    
        
        AggregateResult[] ResultsRevenue = [select count(id) custCnt, SUM(Total_Spend_Impact_12_Month__c) Rev_PassThru,
                                                                SUM(New_Gross_IGM__c) marg_PassThru  
                                                               from ACE_Customer_Price_Changes__c where id in:sCustIDs and Hosted_Catalog__c = true];          
       
       AggregateResult[] ResultsRevenue2 = [select count(id) custCnt, SUM(Total_Spend_Impact_12_Month__c) Rev_PassThru2,
                                                                SUM(New_Gross_IGM__c) marg_PassThru2  
                                                               from ACE_Customer_Price_Changes__c where id in :custList and  Hosted_Catalog__c = true];          
        
        HostedCatalogDataCls rem = new HostedCatalogDataCls();
        rem.ImpCustCount = Double.ValueOf(ResultsImpHostedCust[0].get('custCnt'));
        system.debug('custCnt:'+ResultsImpHostedCust[0].get('custCnt'));
        rem.CaseCount = Double.ValueOf(ResultsCaseCount[0].get('custCnt'));
        rem.CaseClosedCount = Double.ValueOf(ResultsCaseClosed[0].get('custCnt'));
        if(Double.ValueOf(ResultsRevenue2[0].get('Rev_PassThru2')) != null)
            rem.RevenueTotal = Double.ValueOf(ResultsRevenue2[0].get('Rev_PassThru2'));
        else
            rem.RevenueTotal = 0;
            
        if(Double.ValueOf(ResultsRevenue2[0].get('marg_PassThru2')) != null)
            rem.MarginTotal = Double.ValueOf(ResultsRevenue2[0].get('marg_PassThru2'));
        else
            rem.MarginTotal = 0;
            
            
            
        if(Double.ValueOf(ResultsRevenue[0].get('Rev_PassThru')) != null)
            rem.RevenueComp = Double.ValueOf(ResultsRevenue[0].get('Rev_PassThru'));
        else
            rem.RevenueComp = 0;
            
        if(Double.ValueOf(ResultsRevenue[0].get('marg_PassThru')) != null)
            rem.MarginComp = Double.ValueOf(ResultsRevenue[0].get('marg_PassThru'));
        else
            rem.MarginComp = 0;    
            
        lHostedCatalogDataCls = new List<HostedCatalogDataCls>();
        system.debug('@@@@@@');
        lHostedCatalogDataCls.add(rem);
        ResultsImpHostedCust.size();
        ResultsCaseCount.size();
        ResultsCaseClosed.size();
        ResultsCaseClosedGrpID.size();
        ResultsRevenue.size();
        ResultsRevenue2.size();
        return null;
    }
    
    public class HostedCatalogDataCls 
    {
         public String formatType;
         public String dataType;
         public Transient Decimal ImpCustCount{get;set;}
         public Transient Decimal CaseCount {get;set;}
         public Transient Decimal CaseClosedCount {get;set;}
         public Transient Decimal RevenueTotal {get;set;}
         public Transient Decimal MarginTotal {get;set;}
         public Transient Decimal RevenueComp {get;set;}
         public Transient Decimal MarginComp {get;set;}
     }
    
    // Hosted Catalog Report code starts here
    
    
    
    
    // Process Progress Pipeline Code Start Here
    public List<ProgPipeReportDataCls> lProgPipeReportDataCls{get;set;}
    public PageReference loadDataProcessPipeline() 
    {
        //for initial Customr list
        getACECustomerList();
        
        lProgPipeReportDataCls = new List<ProgPipeReportDataCls>();
        AggregateResult[] Results = [select count(id) custCnt, SUM(Total_Spend_Impact_12_Month__c) Rev_PassThru,
                                                               SUM(New_Gross_IGM__c) marg_PassThru
                                                               from ACE_Customer_Price_Changes__c where id in:custList ];          
        AggregateResult[] SKUDeletedCust = [select count(id) cnt,
                                                                SUM(Total_Spend_Impact_12_Month__c) Rev_PassThru,
                                                                SUM(New_Gross_IGM__c) marg_PassThru
                                                                 from ACE_Customer_Price_Changes__c where id in:custList and Report_SKU_Count__c < 1 and PRICE_NOT_CALCULATED__c= false];
        
        AggregateResult[] ResultsSKU = [select count(id) custCnt, SUM(Total_Spend_Impact_12_Month__c) Rev_PassThru,
                                                               SUM(New_Gross_IGM__c) marg_PassThru
                                                               from ACE_Customer_Price_Changes__c where id in:custList and Report_SKU_Count__c > 0 and PRICE_NOT_CALCULATED__c= false];     
                                                               
        AggregateResult[] ResultsAutoReme = [select count(id) custCnt, SUM(Total_Spend_Impact_12_Month__c) Rev_PassThru,
                                                               SUM(New_Gross_IGM__c) marg_PassThru
                                                               from ACE_Customer_Price_Changes__c where id in:custList and Report_SKU_Count__c > 0 and IsRemediation__c = true and (Remedy_Status__c = '' or Remedy_Status__c = null) and PRICE_NOT_CALCULATED__c= false];          
        
        AggregateResult[] ResultsApprovedReme = [select count(id) custCnt, SUM(Total_Spend_Impact_12_Month__c) Rev_PassThru,
                                                               SUM(New_Gross_IGM__c) marg_PassThru
                                                               from ACE_Customer_Price_Changes__c where id in:custList and Report_SKU_Count__c > 0 and IsRemediation__c = true and (Remedy_Status__c = 'Approved') and PRICE_NOT_CALCULATED__c= false];          
        
        AggregateResult[] ResultsHostedCatelog = [select count(id) custCnt, SUM(Total_Spend_Impact_12_Month__c) Rev_PassThru,
                                                               SUM(New_Gross_IGM__c) marg_PassThru
                                                               from ACE_Customer_Price_Changes__c where id in:custList and Report_SKU_Count__c > 0 and Hosted_Catalog__c = true and PRICE_NOT_CALCULATED__c= false];          

       AggregateResult[] ResultsInProcess = [select count(id) custCnt, SUM(Total_Spend_Impact_12_Month__c) Rev_PassThru,
                                                               SUM(New_Gross_IGM__c) marg_PassThru
                                                               from ACE_Customer_Price_Changes__c where id in:custList 
                                                               and Report_SKU_Count__c > 0 and IsRemediation__c = false 
                                                               and Hosted_Catalog__c = false  and PRICE_NOT_CALCULATED__c= false];          
        

        AggregateResult[] ResultsAwReqApprPush = [select count(id) custCnt, SUM(Total_Spend_Impact_12_Month__c) Rev_PassThru,
                                                               SUM(New_Gross_IGM__c) marg_PassThru
                                                               from ACE_Customer_Price_Changes__c where id in:custList and SFDC_Notification_Flag__c = '3' 
                                                               and Notification_Status_Code__c <> 'NOTIFY-DELIVERED' and IsRemediation__c <> true
                                                               and Hosted_Catalog__c <> true and Report_SKU_Count__c > 0 and PRICE_NOT_CALCULATED__c= false]; 
        
        AggregateResult[] ResultsAwCustAppr = [select count(id) custCnt, SUM(Total_Spend_Impact_12_Month__c) Rev_PassThru,
                                                               SUM(New_Gross_IGM__c) marg_PassThru
                                                               from ACE_Customer_Price_Changes__c where id in:custList and SFDC_Notification_Flag__c = '3' 
                                                               and Notification_Status_Code__c = 'NOTIFY-DELIVERED' and Customer_Response__c <> 'Approved'
                                                               and IsRemediation__c <> true and Hosted_Catalog__c <> true and Report_SKU_Count__c > 0 and PRICE_NOT_CALCULATED__c= false];                                                                                                                                   
        
        AggregateResult[] ResultsNotificationpush  = [select count(id) custCnt, SUM(Total_Spend_Impact_12_Month__c) Rev_PassThru,
                                                               SUM(New_Gross_IGM__c) marg_PassThru
                                                               from ACE_Customer_Price_Changes__c where id in:custList and SFDC_Notification_Flag__c = '2' 
                                                               and Notification_Status_Code__c <> 'NOTIFY-DELIVERED'
                                                               and IsRemediation__c <> true and Hosted_Catalog__c <> true and Report_SKU_Count__c > 0 and PRICE_NOT_CALCULATED__c= false];                                                                                                                                   
        
        AggregateResult[] ResultsDefaultImp  = [select count(id) custCnt, SUM(Total_Spend_Impact_12_Month__c) Rev_PassThru,
                                                               SUM(New_Gross_IGM__c) marg_PassThru
                                                               from ACE_Customer_Price_Changes__c where id in:custList 
                                                               and ( ((SFDC_Notification_Flag__c = '1') or (SFDC_Notification_Flag__c = '2' and Notification_Status_Code__c = 'NOTIFY-DELIVERED')) or
                                                               (SFDC_Notification_Flag__c = '3' and Customer_Response__c = 'Approved'))
                                                               and IsRemediation__c <> true and Hosted_Catalog__c <> true and Report_SKU_Count__c > 0 and PRICE_NOT_CALCULATED__c= false];                                                                                                                                   
        
        
        AggregateResult[] ResultsCustNotImp  = [select count(id) custCnt, SUM(Total_Spend_Impact_12_Month__c) Rev_PassThru,
                                                               SUM(New_Gross_IGM__c) marg_PassThru
                                                               from ACE_Customer_Price_Changes__c where id in:custList
                                                               and Implementation_Status_Code__c <> 'DATA-SUCCESS' 
                                                               and IsRemediation__c <> true and Hosted_Catalog__c <> true and Report_SKU_Count__c > 0 and PRICE_NOT_CALCULATED__c= false];                                                                                                                                   
        
        AggregateResult[] ResultsCustImp  = [select count(id) custCnt, SUM(Total_Spend_Impact_12_Month__c) Rev_PassThru,
                                                               SUM(New_Gross_IGM__c) marg_PassThru
                                                               from ACE_Customer_Price_Changes__c where id in:custList
                                                               and Implementation_Status_Code__c = 'DATA-SUCCESS' 
                                                               and IsRemediation__c <> true and Hosted_Catalog__c <> true and Report_SKU_Count__c > 0 and PRICE_NOT_CALCULATED__c= false];                                                                                                                                   
        // In Process Count Calculation
        Decimal EligibleCount =0;
        Decimal AutoCount =0;
        Decimal ApprCount =0;
        Decimal HostedCount =0;
        
        if(Double.ValueOf(ResultsSKU[0].get('custCnt')) != null)
            EligibleCount = Double.ValueOf(ResultsSKU[0].get('custCnt'));
            
        if(Double.ValueOf(ResultsAutoReme[0].get('custCnt')) != null)
            AutoCount = Double.ValueOf(ResultsAutoReme[0].get('custCnt'));

        if(Double.ValueOf(ResultsApprovedReme[0].get('custCnt')) != null)
            ApprCount = Double.ValueOf(ResultsApprovedReme[0].get('custCnt'));
            
        if(Double.ValueOf(ResultsHostedCatelog[0].get('custCnt')) != null)
            HostedCount = Double.ValueOf(ResultsHostedCatelog[0].get('custCnt'));    
            
        // In Process Revenue Calculation
        Decimal EligibleRevenue =0;
        Decimal AutoRevenue =0;
        Decimal ApprRevenue =0;
        Decimal HostedRevenue =0;
        
        if(Double.ValueOf(ResultsSKU[0].get('Rev_PassThru')) != null)
            EligibleRevenue = Double.ValueOf(ResultsSKU[0].get('Rev_PassThru'));
            
        if(Double.ValueOf(ResultsAutoReme[0].get('Rev_PassThru')) != null)
            AutoRevenue  = Double.ValueOf(ResultsAutoReme[0].get('Rev_PassThru'));

        if(Double.ValueOf(ResultsApprovedReme[0].get('Rev_PassThru')) != null)
            ApprRevenue  = Double.ValueOf(ResultsApprovedReme[0].get('Rev_PassThru'));
            
        if(Double.ValueOf(ResultsHostedCatelog[0].get('Rev_PassThru')) != null)
            HostedRevenue = Double.ValueOf(ResultsHostedCatelog[0].get('Rev_PassThru'));    
        
        // In Process Margin Calculation
        Decimal EligibleMargin =0;
        Decimal AutoMargin =0;
        Decimal ApprMargin =0;
        Decimal HostedMargin =0;
        
        if(Double.ValueOf(ResultsSKU[0].get('marg_PassThru')) != null)
            EligibleMargin = Double.ValueOf(ResultsSKU[0].get('marg_PassThru'));
            
        if(Double.ValueOf(ResultsAutoReme[0].get('marg_PassThru')) != null)
            AutoMargin = Double.ValueOf(ResultsAutoReme[0].get('marg_PassThru'));

        if(Double.ValueOf(ResultsApprovedReme[0].get('marg_PassThru')) != null)
            ApprMargin = Double.ValueOf(ResultsApprovedReme[0].get('marg_PassThru'));
            
        if(Double.ValueOf(ResultsHostedCatelog[0].get('marg_PassThru')) != null)
            HostedMargin = Double.ValueOf(ResultsHostedCatelog[0].get('marg_PassThru')); 
            
        // Decimal ImplementedMargin = Double.ValueOf(Results[0].get('marg_PassThru')) - Double.ValueOf(SKUDeletedCust[0].get('marg_PassThru'));
        
        PipelineWrapperList('Customers with Increases','',Double.ValueOf(Results[0].get('custCnt')),Double.ValueOf(Results[0].get('Rev_PassThru')),Double.ValueOf(Results[0].get('marg_PassThru')));
        PipelineWrapperList('Eligible Customers','',Double.ValueOf(ResultsSKU[0].get('custCnt')),Double.ValueOf(ResultsSKU[0].get('Rev_PassThru')),Double.ValueOf(ResultsSKU[0].get('marg_PassThru')) );
        PipelineWrapperList('Customers Auto-Routed to Remediation','Eligible Customers',Double.ValueOf(ResultsAutoReme[0].get('custCnt')),Double.ValueOf(ResultsAutoReme[0].get('Rev_PassThru')),Double.ValueOf(ResultsAutoReme[0].get('marg_PassThru')) );
        PipelineWrapperList('Customers Approved for Remediation','Eligible Customers',Double.ValueOf(ResultsApprovedReme[0].get('custCnt')),Double.ValueOf(ResultsApprovedReme[0].get('Rev_PassThru')),Double.ValueOf(ResultsApprovedReme[0].get('marg_PassThru')));
        PipelineWrapperList('Customers w/Hosted Catalog','Eligible Customers',Double.ValueOf(ResultsHostedCatelog[0].get('custCnt')),Double.ValueOf(ResultsHostedCatelog[0].get('Rev_PassThru')),Double.ValueOf(ResultsHostedCatelog[0].get('marg_PassThru')));
        
       // PipelineWrapperList('In-Process Customers','',(EligibleCount - (AutoCount + ApprCount + HostedCount)),(EligibleRevenue - (AutoRevenue + ApprRevenue + HostedRevenue)),(EligibleMargin - (AutoMargin + ApprMargin + HostedMargin)));
        PipelineWrapperList('In-Process Customers','',Double.ValueOf(ResultsInProcess[0].get('custCnt')),Double.ValueOf(ResultsInProcess[0].get('Rev_PassThru')),Double.ValueOf(ResultsInProcess[0].get('marg_PassThru')));
         
        PipelineWrapperList('Awaiting Approval Request Push','In-Process Customers',Double.ValueOf(ResultsAwReqApprPush[0].get('custCnt')),Double.ValueOf(ResultsAwReqApprPush[0].get('Rev_PassThru')),Double.ValueOf(ResultsAwReqApprPush[0].get('marg_PassThru')));
        PipelineWrapperList('Awating Customer Approval','In-Process Customers',Double.ValueOf(ResultsAwCustAppr[0].get('custCnt')),Double.ValueOf(ResultsAwCustAppr[0].get('Rev_PassThru')),Double.ValueOf(ResultsAwCustAppr[0].get('marg_PassThru')));
        PipelineWrapperList('Awaiting Notification Push','In-Process Customers',Double.ValueOf(ResultsNotificationpush[0].get('custCnt')),Double.ValueOf(ResultsNotificationpush[0].get('Rev_PassThru')),Double.ValueOf(ResultsNotificationpush[0].get('marg_PassThru')));
        PipelineWrapperList('Awaiting Default Implementation','In-Process Customers',Double.ValueOf(ResultsDefaultImp[0].get('custCnt')),Double.ValueOf(ResultsDefaultImp[0].get('Rev_PassThru')),Double.ValueOf(ResultsDefaultImp[0].get('marg_PassThru')));
        PipelineWrapperList('In-Process Customers Not Implemented','',Double.ValueOf(ResultsCustNotImp[0].get('custCnt')),Double.ValueOf(ResultsCustNotImp[0].get('Rev_PassThru')),Double.ValueOf(ResultsCustNotImp[0].get('marg_PassThru')));
        PipelineWrapperList('In-Process Customers Implemented','',Double.ValueOf(ResultsCustImp[0].get('custCnt')),Double.ValueOf(ResultsCustImp[0].get('Rev_PassThru')),Double.ValueOf(ResultsCustImp[0].get('marg_PassThru')));
        
        return null;
        
    }
    
    public class ProgPipeReportDataCls 
    {
         public String formatType {get;set;}
         public String dataType {get;set;}
         public Decimal RecCount{get;set;}
         public Decimal RevenueValue{get;set;}
         public Decimal MarginValue{get;set;}
         public String ParentName{get;set;}
    }
    
    public void PipelineWrapperList(String datatype,String ParentName, Decimal RecCount,Decimal RevenueValue,Decimal MarginValue)
    {
        ProgPipeReportDataCls rec = new ProgPipeReportDataCls ();        
        rec.dataType = datatype;
        rec.RecCount = RecCount;
        rec.RevenueValue = RevenueValue;
        rec.MarginValue = MarginValue;
        rec.ParentName = ParentName;
        lProgPipeReportDataCls.add(rec);    
    }
    
    // Process Progress Pipeline Code End Here
    
    // Erosion Report Code
    public Map<String,Decimal> m_RollingTotal{get;set;}
    public Map<String,Decimal> m_RollingTotal_Margin{get;set;}
    public List<ErosionReportDataCls> lErosionFinalReportData {get;set;}
    
    public PageReference loadErosionData()
    {
        //for initial Customr list
        getACECustomerList();
        system.debug('<<<<<<<<<<<<Quarter>>>>>>>>>>'+SegmentName);
        system.debug('Customers Returned from Hierarchy:' + custList.size());
        //User hierarchy code - ends
        
        list<String> dTypes = new list<String> {'Amount lost due to WA Timing Restrictions','Amount lost due to WA Vendor Letter Requirements','Amount lost due to WA Cap Restrictions','Amount lost due to Field Delay','Amount lost due to Field Markdown'};         
        
        lErosionFinalReportData = new List<ErosionReportDataCls>();      
        m_RollingTotal = new Map<String,Decimal>();
        m_RollingTotal.put('Amount lost due to WA Timing Restrictions', 0);
        m_RollingTotal.put('Amount lost due to WA Vendor Letter Requirements', 0);
        m_RollingTotal.put('Amount lost due to WA Cap Restrictions', 0);
        m_RollingTotal.put('Amount lost due to Field Delay',0);
        m_RollingTotal.put('Amount lost due to Field Markdown',0);
        
        m_RollingTotal_Margin = new Map<String,Decimal>();
        m_RollingTotal_Margin.put('Amount lost due to WA Timing Restrictions', 0);
        m_RollingTotal_Margin.put('Amount lost due to WA Vendor Letter Requirements', 0);
        m_RollingTotal_Margin.put('Amount lost due to WA Cap Restrictions', 0);
        m_RollingTotal_Margin.put('Amount lost due to Field Delay',0);
        m_RollingTotal_Margin.put('Amount lost due to Field Markdown',0);
        
        String ResQuery= '';
        String FieldName = '';
        //sfdc 910696, 910700, 910701,910703 - removed PRICE_NOT_CALCULATED__c= false from all queries below.
        if(reportType =='Summary by Sector/Segment')//sfdc 910698, 910700
        {
            if((segmentType != null) && (SegmentType != ''))
            {
                FieldName = 'Customer__r.segment__c'; 
                //handling the ivalid customers to show as other on reporting - madhavi
            	if(SegmentName == 'Other')
                	SegmentName = null;
                ResQuery = 'Select Customer__r.segment__c sg ,  count(id) custCnt,SUM(Reporting_Erosion_Margin_Field_MarkDown__c) Amt_ErsFieldMdownMargin, SUM(Reporting_Erosion_Margin_Field_Delay__c) Amt_ErsFieldDelayMargin,  SUM(Reporting_Erosion_Margin_CAP__c) Amt_ErsMrgCapMargin,SUM(Reporting_Erosion_Margin_Vendor_Letter__c) Amt_RepVenLetterMargin , SUM(Reporting_Erosion_Margin_WA_Timing__c) Amt_WATimeResMargin,SUM(Reporting_Erosion_Field_MarkDown__c) Amt_ErsFieldMdown, SUM(Reporting_Erosion_Field_Delay__c) Amt_ErsFieldDelay, SUM(Reporting_Erosion_Revenue_CAP__c) Amt_ErsMrgCap,SUM(Reporting_Erosion_Revenue_WA_Timing__c) Amt_WATimeRes, SUM(Reporting_Erosion_Revenue_Vendor_Letter__c) Amt_RepVenLetter from ACE_Customer_Price_Changes__c where (Report_isSKU_Exception__c=true OR EffectiveDate_IsDifferent__c =true) and Customer__r.segment__c = \'' + SegmentType + '\' and Customer__r.sector__c= \'' + SegmentName + '\' and id in :custList  group by '+ FieldName;          
            }
            else 
            {
                FieldName = 'Customer__r.sector__c';
                //handling the ivalid customers to show as other on reporting - madhavi
            	if(SegmentName == 'Other')
                	SegmentName = null;
                ResQuery = 'Select ' + FieldName + ' nm, count(id) custCnt,SUM(Reporting_Erosion_Margin_Field_MarkDown__c) Amt_ErsFieldMdownMargin, SUM(Reporting_Erosion_Margin_Field_Delay__c) Amt_ErsFieldDelayMargin,  SUM(Reporting_Erosion_Margin_CAP__c) Amt_ErsMrgCapMargin,SUM(Reporting_Erosion_Margin_Vendor_Letter__c) Amt_RepVenLetterMargin , SUM(Reporting_Erosion_Margin_WA_Timing__c) Amt_WATimeResMargin,SUM(Reporting_Erosion_Field_MarkDown__c) Amt_ErsFieldMdown, SUM(Reporting_Erosion_Field_Delay__c) Amt_ErsFieldDelay, SUM(Reporting_Erosion_Revenue_CAP__c) Amt_ErsMrgCap,SUM(Reporting_Erosion_Revenue_WA_Timing__c) Amt_WATimeRes, SUM(Reporting_Erosion_Revenue_Vendor_Letter__c) Amt_RepVenLetter from ACE_Customer_Price_Changes__c where (Report_isSKU_Exception__c=true OR EffectiveDate_IsDifferent__c =true) and Customer__r.sector__c= \'' + SegmentName + '\' and id in :custList  group by '+ FieldName;          
            }
        }
        else if(reportType == 'Summary By Region')//sfdc 910696
        {
            FieldName = 'Customer__r.Owner.Region__c';
            //handling the ivalid customers to show as other on reporting - madhavi
            if(SegmentName == 'Other')
                SegmentName = null;
            ResQuery = 'Select ' + FieldName + ' nm, count(id) custCnt,SUM(Reporting_Erosion_Margin_Field_MarkDown__c) Amt_ErsFieldMdownMargin, SUM(Reporting_Erosion_Margin_Field_Delay__c) Amt_ErsFieldDelayMargin,SUM(Reporting_Erosion_Margin_CAP__c) Amt_ErsMrgCapMargin,SUM(Reporting_Erosion_Margin_Vendor_Letter__c) Amt_RepVenLetterMargin , SUM(Reporting_Erosion_Margin_WA_Timing__c) Amt_WATimeResMargin,SUM(Reporting_Erosion_Field_MarkDown__c) Amt_ErsFieldMdown, SUM(Reporting_Erosion_Field_Delay__c) Amt_ErsFieldDelay, SUM(Reporting_Erosion_Revenue_CAP__c) Amt_ErsMrgCap,SUM(Reporting_Erosion_Revenue_WA_Timing__c) Amt_WATimeRes, SUM(Reporting_Erosion_Revenue_Vendor_Letter__c) Amt_RepVenLetter from ACE_Customer_Price_Changes__c where (Report_isSKU_Exception__c=true OR EffectiveDate_IsDifferent__c =true) and Customer__r.Owner.Region__c = \'' + SegmentName + '\' and id in :custList  group by '+ FieldName;          
        }
        else if(reportType == 'Summary by Industry/Vertical Market')//910703 - changed the report NAME
        {
            FieldName = 'Customer__r.Industry_OD_SIC_Rep__c';
            //handling the ivalid customers to show as other on reporting - madhavi
            //if(SegmentName == 'Other')
               // SegmentName = null;
            
            ResQuery = 'Select ' + FieldName + ' nm, count(id) custCnt,SUM(Reporting_Erosion_Margin_Field_MarkDown__c) Amt_ErsFieldMdownMargin, SUM(Reporting_Erosion_Margin_Field_Delay__c) Amt_ErsFieldDelayMargin,SUM(Reporting_Erosion_Margin_CAP__c) Amt_ErsMrgCapMargin,SUM(Reporting_Erosion_Margin_Vendor_Letter__c) Amt_RepVenLetterMargin , SUM(Reporting_Erosion_Margin_WA_Timing__c) Amt_WATimeResMargin,SUM(Reporting_Erosion_Field_MarkDown__c) Amt_ErsFieldMdown, SUM(Reporting_Erosion_Field_Delay__c) Amt_ErsFieldDelay, SUM(Reporting_Erosion_Revenue_CAP__c) Amt_ErsMrgCap,SUM(Reporting_Erosion_Revenue_WA_Timing__c) Amt_WATimeRes, SUM(Reporting_Erosion_Revenue_Vendor_Letter__c) Amt_RepVenLetter from ACE_Customer_Price_Changes__c where (Report_isSKU_Exception__c=true OR EffectiveDate_IsDifferent__c =true) and Customer__r.Industry_OD_SIC_Rep__c = \'' + SegmentName + '\' and id in :custList  group by '+ FieldName;          
        }
        else if(reportType == 'Summary by Participation (Buying Group/GPO)')
        {
            FieldName  = 'Customer__r.Buying_Group__c';
            //handling the ivalid customers to show as other on reporting - madhavi
            if(SegmentName == 'Other')
                ResQuery = 'Select ' + FieldName + ' nm, count(id) custCnt,SUM(Reporting_Erosion_Margin_Field_MarkDown__c) Amt_ErsFieldMdownMargin, SUM(Reporting_Erosion_Margin_Field_Delay__c) Amt_ErsFieldDelayMargin,SUM(Reporting_Erosion_Margin_CAP__c) Amt_ErsMrgCapMargin,SUM(Reporting_Erosion_Margin_Vendor_Letter__c) Amt_RepVenLetterMargin , SUM(Reporting_Erosion_Margin_WA_Timing__c) Amt_WATimeResMargin,SUM(Reporting_Erosion_Field_MarkDown__c) Amt_ErsFieldMdown, SUM(Reporting_Erosion_Field_Delay__c) Amt_ErsFieldDelay, SUM(Reporting_Erosion_Revenue_CAP__c) Amt_ErsMrgCap,SUM(Reporting_Erosion_Revenue_WA_Timing__c) Amt_WATimeRes, SUM(Reporting_Erosion_Revenue_Vendor_Letter__c) Amt_RepVenLetter from ACE_Customer_Price_Changes__c where (Report_isSKU_Exception__c=true OR EffectiveDate_IsDifferent__c =true) and Customer__r.Buying_Group__c = null and id in :custList  group by '+ FieldName;          
            //sfdc 910701
            else
            	ResQuery = 'Select ' + FieldName + ' nm, count(id) custCnt,SUM(Reporting_Erosion_Margin_Field_MarkDown__c) Amt_ErsFieldMdownMargin, SUM(Reporting_Erosion_Margin_Field_Delay__c) Amt_ErsFieldDelayMargin,SUM(Reporting_Erosion_Margin_CAP__c) Amt_ErsMrgCapMargin,SUM(Reporting_Erosion_Margin_Vendor_Letter__c) Amt_RepVenLetterMargin , SUM(Reporting_Erosion_Margin_WA_Timing__c) Amt_WATimeResMargin,SUM(Reporting_Erosion_Field_MarkDown__c) Amt_ErsFieldMdown, SUM(Reporting_Erosion_Field_Delay__c) Amt_ErsFieldDelay, SUM(Reporting_Erosion_Revenue_CAP__c) Amt_ErsMrgCap,SUM(Reporting_Erosion_Revenue_WA_Timing__c) Amt_WATimeRes, SUM(Reporting_Erosion_Revenue_Vendor_Letter__c) Amt_RepVenLetter from ACE_Customer_Price_Changes__c where (Report_isSKU_Exception__c=true OR EffectiveDate_IsDifferent__c =true) and Customer__r.Buying_Group__c like \'' + SegmentName + '%\' and id in :custList  group by '+ FieldName;          
        }    
        
        System.debug('>>>>>>>>>>>>>>>>>> value of ResQuery' + ResQuery);
           
        Map<String,Decimal> map_Sect_Val = new Map<String,Decimal>();
        map_Sect_Val.put('Amount lost due to WA Timing Restrictions', 0);
        map_Sect_Val.put('Amount lost due to WA Vendor Letter Requirements', 0);
        map_Sect_Val.put('Amount lost due to WA Cap Restrictions', 0);
        map_Sect_Val.put('Amount lost due to Field Delay',0);
        map_Sect_Val.put('Amount lost due to Field Markdown',0);
        
        Decimal totalValue = 0;
        Decimal totalValue2 = 0; 
        
        Map<String,Decimal> map_Sect_Val_Margin = new Map<String,Decimal>();
        map_Sect_Val_Margin.put('Amount lost due to WA Timing Restrictions', 0);
        map_Sect_Val_Margin.put('Amount lost due to WA Vendor Letter Requirements', 0);
        map_Sect_Val_Margin.put('Amount lost due to WA Cap Restrictions', 0);
        map_Sect_Val_Margin.put('Amount lost due to Field Delay',0);
        map_Sect_Val_Margin.put('Amount lost due to Field Markdown',0);
       
        Decimal totalValue_Margin = 0;
        Decimal totalValue2_Margin = 0; 
               
        
        AggregateResult[] Results = DataBase.query(ResQuery);
        if(results.size() > 0)
        {
            //=======Revenue Report=========
            if((Decimal)results[0].get('Amt_WATimeRes') != null)
            {    map_Sect_Val.put('Amount lost due to WA Timing Restrictions', (Decimal)results[0].get('Amt_WATimeRes'));
             	 totalValue = totalValue + (Decimal)results[0].get('Amt_WATimeRes');
            }    
            else
                map_Sect_Val.put('Amount lost due to WA Timing Restrictions', 0);
     
            if((Decimal)results[0].get('Amt_RepVenLetter') != null)         
            {
                map_Sect_Val.put('Amount lost due to WA Vendor Letter Requirements',(Decimal)results[0].get('Amt_RepVenLetter'));
                totalValue = totalValue + (Decimal)results[0].get('Amt_RepVenLetter');
            }    
            else 
                map_Sect_Val.put('Amount lost due to WA Vendor Letter Requirements',0);
            
            if((Decimal)results[0].get('Amt_ErsMrgCap') != null)    
            {
                map_Sect_Val.put('Amount lost due to WA Cap Restrictions',(Decimal)results[0].get('Amt_ErsMrgCap'));
                totalValue = totalValue + (Decimal)results[0].get('Amt_RepVenLetter');
            }            
            else 
                map_Sect_Val.put('Amount lost due to WA Cap Restrictions',0);   
                 
            if((Decimal)results[0].get('Amt_ErsFieldDelay') != null)
            {
                map_Sect_Val.put('Amount lost due to Field Delay',(Decimal)results[0].get('Amt_ErsFieldDelay'));
                totalValue2 = totalValue2 + (Decimal)results[0].get('Amt_ErsFieldDelay');
            }
            else 
                map_Sect_Val.put('Amount lost due to Field Delay',0);
             
            if((Decimal)results[0].get('Amt_ErsFieldMdown') != null)     
            {
                map_Sect_Val.put('Amount lost due to Field Markdown',(Decimal)results[0].get('Amt_ErsFieldMdown'));
                totalValue2 = totalValue2 + (Decimal)results[0].get('Amt_ErsFieldMdown');
            }
            else 
                map_Sect_Val.put('Amount lost due to Field Markdown',0);
            
            ///-------Margin Report------------------
            if((Decimal)results[0].get('Amt_WATimeResMargin') != null)
            {    map_Sect_Val_Margin.put('Amount lost due to WA Timing Restrictions', (Decimal)results[0].get('Amt_WATimeResMargin'));
             	 totalValue_Margin = totalValue_Margin + (Decimal)results[0].get('Amt_WATimeResMargin');
            }    
            else
                map_Sect_Val_Margin.put('Amount lost due to WA Timing Restrictions', 0);
     
            if((Decimal)results[0].get('Amt_RepVenLetterMargin') != null)         
            {
                map_Sect_Val_Margin.put('Amount lost due to WA Vendor Letter Requirements',(Decimal)results[0].get('Amt_RepVenLetterMargin'));
                totalValue_Margin = totalValue_Margin + (Decimal)results[0].get('Amt_RepVenLetterMargin');
            }    
            else 
                map_Sect_Val_Margin.put('Amount lost due to WA Vendor Letter Requirements',0);
            
            if((Decimal)results[0].get('Amt_ErsMrgCapMargin') != null)    
            {
                map_Sect_Val_Margin.put('Amount lost due to WA Cap Restrictions',(Decimal)results[0].get('Amt_ErsMrgCapMargin'));
                totalValue_Margin = totalValue_Margin + (Decimal)results[0].get('Amt_RepVenLetterMargin');
            }            
            else 
                map_Sect_Val_Margin.put('Amount lost due to WA Cap Restrictions',0);
            
            if((Decimal)results[0].get('Amt_ErsFieldDelayMargin') != null)
            {
                map_Sect_Val_Margin.put('Amount lost due to Field Delay',(Decimal)results[0].get('Amt_ErsFieldDelayMargin'));
                totalValue2_Margin = totalValue2_Margin + (Decimal)results[0].get('Amt_ErsFieldDelayMargin');
            }
            else 
                map_Sect_Val_Margin.put('Amount lost due to Field Delay',0);
            
            if((Decimal)results[0].get('Amt_ErsFieldMdownMargin') != null)     
            {
                map_Sect_Val_Margin.put('Amount lost due to Field Markdown',(Decimal)results[0].get('Amt_ErsFieldMdownMargin'));
                totalValue2_Margin = totalValue2_Margin + (Decimal)results[0].get('Amt_ErsFieldMdownMargin');
            }
            else 
                map_Sect_Val_Margin.put('Amount lost due to Field Markdown',0);
            
            Decimal TempTotal = 0;
            Decimal TempTotalMargin = 0;
            for(String s : dTypes)
            {
                Decimal val = map_Sect_Val.get(s);
                TempTotal = TempTotal + val;
                m_RollingTotal.put(s,tempTotal);
                
                Decimal val2 = map_Sect_Val_Margin.get(s);
                TempTotalMargin = TempTotalMargin + val2;
                m_RollingTotal_Margin.put(s,tempTotalMargin);
                
            }
        }    
        ErosionReportDataCls rec = new ErosionReportDataCls();
        rec.formatType = '{0, number, ###,###,###,###.00}';
        rec.lColNames = new list<string>{'Amount lost due to WA Timing Restrictions','Amount lost due to WA Vendor Letter Requirements','Amount lost due to WA Cap Restrictions'};
        rec.map_Sect_Val = map_Sect_Val;
        rec.ReportName = 'Revenue';
        rec.TotalValue = totalValue;
        
        ErosionReportDataCls rec2 = new ErosionReportDataCls();
        rec2.formatType = '{0, number, ###,###,###,###.00}';
        rec2.lColNames = new list<string>{'Amount lost due to Field Delay','Amount lost due to Field Markdown'};
        rec2.map_Sect_Val = map_Sect_Val;
        rec2.ReportName = 'Revenue';
        rec2.TotalValue = totalValue2;
        
        ErosionReportDataCls rec3 = new ErosionReportDataCls();
        rec3.formatType = '{0, number, ###,###,###,###.00}';
        rec3.lColNames = new list<string>{'Amount lost due to WA Timing Restrictions','Amount lost due to WA Vendor Letter Requirements','Amount lost due to WA Cap Restrictions'};
        rec3.map_Sect_Val = map_Sect_Val_Margin;
        rec3.ReportName = 'Margin';
        rec3.TotalValue = totalValue_Margin;
        
        ErosionReportDataCls rec4 = new ErosionReportDataCls();
        rec4.formatType = '{0, number, ###,###,###,###.00}';
        rec4.lColNames = new list<string>{'Amount lost due to Field Delay','Amount lost due to Field Markdown'};
        rec4.map_Sect_Val = map_Sect_Val_Margin;
        rec4.ReportName = 'Margin';
        rec4.TotalValue = totalValue2_Margin;
        
        system.debug('rec.map_Sect_Val:'+rec.map_Sect_Val);
        lErosionFinalReportData.add(rec); 
        lErosionFinalReportData.add(rec2); 
        lErosionFinalReportData.add(rec3); 
        lErosionFinalReportData.add(rec4); 
        
        return null;
    }
    
    //Notification Report Code Starts Here
    public List<NotificationReportDataCls> lNotificationReportDataCls{get;set;}    
    public PageReference loadNotificationData()
    {
        //for initial Customr list
        getACECustomerList();
        system.debug('Customers Returned from Hierarchy:' + custList.size());
        //User hierarchy code - ends
        String FieldName = '';
        String CustQuery = '';
        
        Decimal Custbucket1= 0;
        Decimal Custbucket2= 0;
        Decimal Custbucket3= 0;
        
        Decimal CustCount= 0;
        Decimal CustCallReq= 0;
        Decimal CustCallPend= 0;
        Decimal CustAccepted= 0;
        Decimal CusAvgTime= 0;
        
        if(reportType == 'Notification' || reportType == 'Compliance')//sfdc 910713 --added Compliance
        {
            FieldName = 'Email_Template_Code__c';
            CustQuery = 'select Email_Template_Code__c sfdcFlag from ACE_Customer_MailOut__c where Customer_Core_Price_Changes__c in:custList group by Email_Template_Code__c,Customer_Core_Price_Changes__c';
            //CustQuery = 'select COUNT(id) custcnt,Email_Template_Code__c sfdcFlag from ACE_Customer_MailOut__c where id in :cusset group by Email_Template_Code__c';       
            system.debug('>>>>>>>>'+CustQuery );        

            AggregateResult[] CustResults= DataBase.query(CustQuery);        
                                               
            for (AggregateResult cr : CustResults){            
                    if((String)cr.get('sfdcFlag') == '1'){//changed email template code from 3 to 1-sfdc 910713.
                        system.debug('$$$$$$$3'+cr);
                        Custbucket3++; 
                    }
                    else if((String)cr.get('sfdcFlag') == '2'){
                        system.debug('$$$$$$$$2'+cr);
                        Custbucket2++; 
                    }
                    else if((String)cr.get('sfdcFlag') == '3'){//changed email template code from 1 to 3-910713.
                        system.debug('$$$$$$$$1'+cr);
                        Custbucket1++; 
                    }                                                                        
            }
            lNotificationReportDataCls = new List<NotificationReportDataCls>();          
                     
            NotificationReportDataCls rec = new NotificationReportDataCls();  
            rec.Label3 = 'Customers With Pushed Approval Request';             
            rec.Bucket3= Custbucket3;
            rec.Label2 = 'Customers With Pushed Notification';
            rec.Bucket2= Custbucket2;
            
            if(reportType == 'Notification'){//sfdc 910713 
            rec.Label1 = 'Additional Customers Sent Optional Notification';
            rec.Bucket1= Custbucket1;
            rec.LabelTot = 'Total Customers Receiving Notification';
            rec.Total= Custbucket3 + Custbucket2 + Custbucket1; 
            }
            
            lNotificationReportDataCls.add(rec);
            
                     
        }   
        
        if(reportType == 'Response'){
            FieldName = 'Email_Template_Code__c';
            List<ACE_Customer_MailOut__c> CustResults2 = [select Customer_Core_Price_Changes__r.Customer_Response__c,
                                                    Reporting_Accepted_Date__c
                                                    from ACE_Customer_MailOut__c 
                                                    where (Reporting_Accepted_Date__c!=NULL and Email_Template_Code__c =:'1' and Customer_Core_Price_Changes__c in:custList)]; //changed email template code from 3 to 1-sfdc 910713.
            AggregateResult[] CustResults = [select count(id) cnt, 
                                                    Customer_Core_Price_Changes__r.CallMeRequest__c CallReq ,
                                                    Customer_Core_Price_Changes__r.Customer_Response__c CustResp
                                                    from ACE_Customer_MailOut__c 
                                                    where (Email_Template_Code__c ='1' and Customer_Core_Price_Changes__c in:custList) //changed email template code from 3 to 1-sfdc 910713
                                                    group by Customer_Core_Price_Changes__c,Customer_Core_Price_Changes__r.CallMeRequest__c,Customer_Core_Price_Changes__r.Customer_Response__c]; 
            AggregateResult[] AvgTime = [select avg(Reporting_Accept_Time__c) custAccptTime 
                                                    from ACE_Customer_MailOut__c 
                                                    where (Reporting_Accepted_Date__c!=NULL and Email_Template_Code__c =:'1' and Customer_Core_Price_Changes__c in:custList)];//changed email template code from 3 to 1-sfdc 910713.
            system.debug('>>>>>>>>'+CustQuery );        

            //AggregateResult[] CustResults= DataBase.query(CustQuery);        
                                               
            for (AggregateResult cr : CustResults){
                    system.debug('$$$$$$$:'+cr);
                    CustCount++;
                    if((boolean)cr.get('CallReq')!=null && (boolean)cr.get('CallReq')) //requested for call me
                        CustCallReq++;
                    if((boolean)cr.get('CallReq')!=null && (boolean)cr.get('CallReq') && (String)cr.get('CustResp')== 'Call Me') // requested call me and pending 
                        CustCallPend++;
                    
                    //below is commented because we have logic in below loop
                    //if((String)cr.get('CustResp')== 'Approved') // Approved by customer
                        //CustAccepted++;
                                                                                          
            }
            
            for (ACE_Customer_MailOut__c cr2 : CustResults2){
                    system.debug('$$$$$$$:'+cr2);
                    if(cr2.Customer_Core_Price_Changes__r.Customer_Response__c== 'Approved' && cr2.Reporting_Accepted_Date__c!=null) // Approved by customer
                        CustAccepted++;                                                                                          
            }
            
            if(AvgTime[0].get('custAccptTime')!=null)
                CusAvgTime = (Decimal)AvgTime[0].get('custAccptTime');
                
            lNotificationReportDataCls = new List<NotificationReportDataCls>();                               
            NotificationReportDataCls rec = new NotificationReportDataCls();  
            
            rec.CustRespCount= CustCount;            
            rec.CustCallMeReq= CustCallReq;            
            rec.CustCallMePend= CustCallPend;            
            rec.CustAccepted= CustAccepted;
            rec.CustAvgTime = CusAvgTime;
                                    
            lNotificationReportDataCls.add(rec);
        }            
        return null;
    }
    
    public class NotificationReportDataCls 
    {
     public Decimal CustRespCount{get;set;}
     public Decimal CustCallMeReq{get;set;}
     public Decimal CustCallMePend{get;set;}
     public Decimal CustAccepted{get;set;}
     public Decimal CustAvgTime{get;set;}
     
     public String LabelTot{get;set;}
     public String Label1{get;set;}
     public String Label2{get;set;}
     public String Label3{get;set;}    
     public Decimal Bucket3{get;set;}
     public Decimal Bucket2{get;set;}
     public Decimal Bucket1{get;set;}
     public Decimal Total{get;set;} 
        
     public decimal custapprovalrequired{get;set;}//sfdc 00910713
     public decimal custnotifyrequired{get;set;}//sfdc 00910713
    }
    
    // Notification Report Code End here
    
    public class ErosionReportDataCls 
    {
     public String formatType {get;set;}
     // public String dataType {get;set;}
     public Map<String,Decimal> map_Sect_Val{get;set;}
     public String ReportName{get;set;}
     public List<String> lColNames{get;set;}
     public Decimal TotalValue{get;set;}
     public String Segment{get;set;}
     public String SegmentType{get;set;}
    }
    
    public PageReference loadData()
    {
        getACECustomerList();            
        //for initial Customr list
        system.debug('<<<<<<<<<<<<SegmentName>>>>>>>>>>'+SegmentName);
        system.debug('Customers Returned from Hierarchy:' + custList.size());
        //User hierarchy code - ends
        
        ovd = new list<ReportDataCls>();
        lFinalReportData = new List<ReportDataCls>(); // added by guha        
        
        list<String> dTypes = new list<String> {'# Customers Receiving Increases','Original Value of Increases','Erosion','Value of Increases Passed to Customers'};         
        fmt = new Map<String,String> ();
        fmt.put('# Customers Receiving Increases','{0, number, ###,###}');
        fmt.put('Original Value of Increases','{0, number, ###,###,###,###.00}');
        fmt.put('Erosion','{0, number, ###,###,###,###.00}');
        fmt.put('Value of Increases Passed to Customers','{0, number, ###,###,###,###.00}');
        
        Map<String,Decimal> map_Sect_value = new Map<String,decimal> ();
        
        Map<String,Decimal> map_Sect_RevValue = new Map<String,decimal> ();
        Map<String,Decimal> map_Sect_ErsValue = new Map<String,decimal>();
        Map<String,Decimal> map_Sect_ImpValue = new Map<String,decimal>();
          
        Map<String,Decimal> map_Sect_perRevValue = new Map<String,decimal> ();
        Map<String,Decimal> map_Sect_perErsValue = new Map<String,decimal>();
        Map<String,Decimal> map_Sect_perImpValue = new Map<String,decimal>();
         
        Map<String,Decimal> map_Sect_RevValue_M = new Map<String,decimal>();
        Map<String,Decimal> map_Sect_ErsValue_M = new Map<String,decimal>();
        Map<String,Decimal> map_Sect_ImpValue_M = new Map<String,decimal>();
            
        Map<String,Decimal> map_Sect_perRevValue_M = new Map<String,decimal>();
        Map<String,Decimal> map_Sect_perErsValue_M = new Map<String,decimal>();
        Map<String,Decimal> map_Sect_perImpValue_M = new Map<String,decimal>();
        
        //sfdc 910701
        Map<String,string> map_buying_grp = new Map<String,string>();
        
        String FieldName = '';
        sTempSectors = new Set<String>();
        if((reportType == 'Summary by Sector/Segment') && (SegmentName == null))//sfdc 910698, 910700
        {
            sSectors= new List<String>();
            Schema.DescribeFieldResult fieldResult = Account.Sector__c.getDescribe();
            List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
            for( Schema.PicklistEntry f : ple)
            {
                sSectors.add(f.getValue());
                sTempSectors.add(f.getValue());
                map_Sect_value.put(f.getValue(),0);
                map_Sect_RevValue.put(f.getValue(),0);
                map_Sect_ErsValue.put(f.getValue(),0);
                map_Sect_ImpValue.put(f.getValue(),0);
                
                map_Sect_RevValue_M.put(f.getValue(),0);
                map_Sect_ErsValue_M.put(f.getValue(),0);
                map_Sect_ImpValue_M.put(f.getValue(),0);
                
            }
            
            sSectors.add('BSD Total');
            FieldName  = 'Customer__r.sector__c';
        
        }
        else if((reportType == 'Summary by Sector/Segment') && (SegmentName != null))//sfdc 910698, 910700
        {
            sSectors= new List<String>();
            //sfdc 910698,910700 --start
            if(SegmentName =='Public' || SegmentName =='Private')
            {
                Schema.DescribeFieldResult fieldResult = Account.segment__c.getDescribe();
            	List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
                for( Schema.PicklistEntry f : ple)
                {
                    sSectors.add(f.getValue());
                    sTempSectors.add(f.getValue());
                    map_Sect_value.put(f.getValue(),0);
                    map_Sect_RevValue.put(f.getValue(),0);
                    map_Sect_ErsValue.put(f.getValue(),0);
                    map_Sect_ImpValue.put(f.getValue(),0);
                    
                    map_Sect_RevValue_M.put(f.getValue(),0);
                    map_Sect_ErsValue_M.put(f.getValue(),0);
                    map_Sect_ImpValue_M.put(f.getValue(),0);
                    
                }
                //sfdc 910698,910700 --end
            }
                         
            sSectors.add('BSD Total');
            FieldName  = 'Customer__r.segment__c';
        
        }
        else if(reportType == 'Summary By Region')//sfdc 910696
        {
            /*sSectors= new List<String>{'North','South','East','Central'};
            sTempSectors = new Set<String>{'North','South','East','Central'};
            for(String f : sSectors)
            {
                map_Sect_value.put(f,0);
                map_Sect_RevValue.put(f,0);
                map_Sect_ErsValue.put(f,0);
                map_Sect_ImpValue.put(f,0);
                
                map_Sect_RevValue_M.put(f,0);
                map_Sect_ErsValue_M.put(f,0);
                map_Sect_ImpValue_M.put(f,0);
                
            }*/
            
            //sfdc 910696---start
            sSectors= new List<String>();
            AggregateResult[] regions = [SELECT count(id) cnt, region__c region from user group by region__c];
            for(AggregateResult ur:regions){
                if(ur.get('region') != null){
                	sSectors.add((string)ur.get('region'));
                	sTempSectors.add((string)ur.get('region'));
                }
                else{
                    sSectors.add('Other');
                	sTempSectors.add('Other');
                }
            }
            
            system.debug('sSectors.size:'+sSectors.size());
            
             for(String f : sSectors)
            {
                map_Sect_value.put(f,0);
                map_Sect_RevValue.put(f,0);
                map_Sect_ErsValue.put(f,0);
                map_Sect_ImpValue.put(f,0);
                
                map_Sect_RevValue_M.put(f,0);
                map_Sect_ErsValue_M.put(f,0);
                map_Sect_ImpValue_M.put(f,0);
                
            }
            //sfdc 910696---end
            
            system.debug('sSectors.size including Others:'+sSectors.size());
            
            sSectors.add('BSD Total');
            FieldName  = 'Customer__r.Owner.Region__c';
            
        }               
        else if(reportType == 'Summary by Participation (Buying Group/GPO)')
        {
            //sfdc 910701---start
        	//sSectors = new List<String>{'Buying Group','Healthcare GPO','Standalone'};//new List<String>();/
            //sTempSectors = new Set<String>{'Buying Group','Healthcare GPO','Standalone'}; //= new Set<String>();
        	 sSectors = new List<String>();
             sTempSectors = new Set<String>();
        	 for(Buying_Group__mdt b_grp:[select MasterLabel from Buying_Group__mdt])
             {
                sSectors.add(b_grp.MasterLabel);
                sTempSectors.add(b_grp.MasterLabel);
                string substr = b_grp.MasterLabel.substring(0,6);
                map_buying_grp.put(substr, b_grp.MasterLabel);
             }
            
            sSectors.add('Other');
            sTempSectors.add('Other');
            map_buying_grp.put('Other', 'Other');
        	//sfdc 910701---end
        	
            
            for(String f : sSectors)
            {
                map_Sect_value.put(f,0);
                map_Sect_RevValue.put(f,0);
                map_Sect_ErsValue.put(f,0);
                map_Sect_ImpValue.put(f,0);
                
                map_Sect_RevValue_M.put(f,0);
                map_Sect_ErsValue_M.put(f,0);
                map_Sect_ImpValue_M.put(f,0);
                
            }
            
            sSectors.add('BSD Total');
            FieldName  = 'Customer__r.Buying_Group__c';
        }    
       else if(reportType == 'Summary by Industry/Vertical Market')//910703 - changed the report NAME
        {
            sSectors= new List<String>();
            Schema.DescribeFieldResult fieldResult = Account.Industry_OD_SIC_Rep__c.getDescribe();
            List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
            for( Schema.PicklistEntry f : ple)
            {
                sSectors.add(f.getValue());
                sTempSectors.add(f.getValue());
                map_Sect_value.put(f.getValue(),0);
                map_Sect_RevValue.put(f.getValue(),0);
                map_Sect_ErsValue.put(f.getValue(),0);
                map_Sect_ImpValue.put(f.getValue(),0);
                
                map_Sect_RevValue_M.put(f.getValue(),0);
                map_Sect_ErsValue_M.put(f.getValue(),0);
                map_Sect_ImpValue_M.put(f.getValue(),0);
               
            }
            
            sSectors.add('BSD Total');
            FieldName  = 'Customer__r.Industry_OD_SIC_Rep__c';
        }   
         
            String ResQuery= '';
            String SKUDeletedCustQuery ='';
            if(SegmentName == null)
            {
            //sfdc 910696 - removed PRICE_NOT_CALCULATED__c= false where clause from below queries.
            //ALL these reports should match with overview report queries, so Removed thise where condition
            system.debug('Madhavi-custList:'+custList.size());             
            ResQuery = 'Select ' + FieldName + ' nm, count(id) custCnt, SUM(Report_Total_Spend_Impact_12_Month_ACE__c) Rev_PassThru,SUM(Report_New_Gross_IGM_ACE__c) marg_PassThru from ACE_Customer_Price_Changes__c where  id in :custList group by '+ FieldName;  
            SKUDeletedCustQuery = 'select ' +  FieldName+ ' nm, count(id) cnt,SUM(Report_Total_Spend_Impact_12_Month_ACE__c) Rev_PassThru, SUM(Report_New_Gross_IGM_ACE__c) marg_PassThru from ACE_Customer_Price_Changes__c where id in:custList and (Report_isSKU_Exception__c=true OR EffectiveDate_IsDifferent__c =true) group by '+ FieldName; //sfdc-861332...removed this where clause Report_SKU_Count__c < 1          
            }
            else 
            {
                if(reportType =='Summary by Sector/Segment')//sfdc 910698, 910700
                {
                    //sfdc 910696 - removed PRICE_NOT_CALCULATED__c= false where clause from below queries.
                    //ALL these reports should match with overview report queries, so Removed thise where condition      
                    ResQuery = 'Select ' + FieldName + ' nm, count(id) custCnt, SUM(Report_Total_Spend_Impact_12_Month_ACE__c) Rev_PassThru,SUM(Report_New_Gross_IGM_ACE__c) marg_PassThru from ACE_Customer_Price_Changes__c where Customer__r.sector__c= \'' + SegmentName + '\' and id in :custList  group by '+ FieldName+'';          
                    SKUDeletedCustQuery = 'select ' +  FieldName+ ' nm, count(id) cnt,SUM(Report_Total_Spend_Impact_12_Month_ACE__c) Rev_PassThru, SUM(Report_New_Gross_IGM_ACE__c) marg_PassThru from ACE_Customer_Price_Changes__c where Customer__r.sector__c= \'' + SegmentName + '\' and id in:custList and (Report_isSKU_Exception__c=true OR EffectiveDate_IsDifferent__c =true) group by '+ FieldName;//sfdc-861332 removed this where clause..Report_SKU_Count__c < 1            
                }
            }
            
            System.debug('Value of Query>>>>>>>>' +  SKUDeletedCustQuery );
           
            AggregateResult[] Results = DataBase.query(ResQuery);
            AggregateResult[] SKUDeletedCust = DataBase.query(SKUDeletedCustQuery);
            
            Integer TotalCustCount = 0;
            Decimal TotalRevCount = 0;
            Decimal TotalErsCount = 0;
            Decimal TotalImpCount = 0;
            
            //Decimal TotalRevCount_M = 0;
            //Decimal TotalErsCount_M = 0;
            //Decimal TotalImpCount_M = 0;             	
        	
        	
                for (AggregateResult ar : Results)
                {
                    String KeyValue = '';//sfdc 910703- to hanlde the accounts without Industry or region mentioned        	
                    if((String)ar.get('nm') != null) 
                    {
                        KeyValue = ((String)ar.get('nm'));
                        system.debug('KeyValue:'+KeyValue);
                        if(reportType == 'Summary by Participation (Buying Group/GPO)')
                        {
                            
                            String temp = ((String)ar.get('nm')).substring(0,6); 
                            System.debug('Value of temp>>>>>>>>' +  temp);
                            
                            //sfdc 910701
                            if(temp == 'Buying' || temp == 'Health' || temp == 'Standa')
                                keyValue = map_buying_grp.get(temp);
                            /*if(temp == 'Buying')
                               keyValue = 'Buying Group'; 
                            else if(temp == 'Health')
                                keyValue = 'Healthcare GPO';
                            else if(temp == 'Standa')
                                keyValue = 'Standalone';*/
                        }                                                                	                        
                    }
                    //sfdc 910703- to hanlde the accounts without Industry or region mentioned        	
                    else{
                         
                        KeyValue = ((String)ar.get('nm'));                        
                        if(reportType == 'Summary by Region' || reportType ==  'Summary by Industry/Vertical Market' ||
                          reportType == 'Summary by Participation (Buying Group/GPO)')
                        {
                            if(keyValue == null || keyValue == ''){
                                keyValue = 'Other';
                                system.debug('KeyValue with null:'+keyValue);
                            }                                                       
                        }
                    }//end of sfdc 910703, 910696
                    
                    if(sTempSectors.contains(keyValue)) 
                    {
                         	// for Revenue report                                              
                        	decimal rValue = (Decimal)ar.get('Rev_PassThru');
                        	decimal mValue = (Decimal)ar.get('marg_PassThru');
                        
                        	if(rValue == null)
                            	rValue = 0;
                        	if(mValue == null)
                            	mValue = 0;
                            
                        	decimal sectVal = map_Sect_value.get(keyValue);
                        	sectVal = sectVal + (Integer)ar.get('custCnt');
                        	map_Sect_value.remove(keyValue);
                        	map_Sect_value.put(keyValue,sectVal);
                        
                        	Decimal revVal = map_Sect_revvalue.get(keyValue);
                        	revVal = revVal + rValue;   // (Decimal)ar.get('Rev_PassThru');
                        	map_Sect_RevValue.remove(keyValue);
                        	map_Sect_RevValue.put(keyValue,revval);
                                                   
                            Decimal impVal = map_Sect_ImpValue.get(keyValue);
                            impVal = impVal + rValue;   // (Decimal)ar.get('Rev_PassThru');
                            map_Sect_ImpValue.remove(keyValue);
                            map_Sect_ImpValue.put(keyValue,impVal);
                        
                            TotalCustCount =  TotalCustCount + (Integer)ar.get('custCnt');
                            TotalRevCount =  TotalRevCount + rValue;   // (Decimal)ar.get('Rev_PassThru');
                            TotalImpCount = TotalImpCount + rValue;   // (Decimal)ar.get('Rev_PassThru');
                            
                            Integer c = (Integer)ar.get('custCnt');
                            String n = keyValue;
                            
                            System.debug('Value of region/sector>>>>>>' + n);
                            System.debug('Value of count>>>>>>' +  c);
                            System.debug('Value of TotalCustCount >>>>>>' +  TotalCustCount );
                            System.debug('Value of rValue:'+rValue);
                            System.debug('Value of mValue:'+mValue);
                            
                            // for Margin report
                            // //sfdc 910701 - added below code
                            //decimal revVal_m=map_Sect_RevValue_M.get(keyValue);
                            //revVal_m = revVal_m+mValue;
                            //map_Sect_RevValue_M.remove(keyValue);
                            //map_Sect_RevValue_M.put(keyValue,revVal_m); //   (Decimal)ar.get('marg_PassThru'));
                            //-------------------
                            /*map_Sect_RevValue_M.remove(keyValue);
                            map_Sect_RevValue_M.put(keyValue,mValue); */   //(Decimal)ar.get('marg_PassThru'));
                            
                            //map_Sect_ImpValue_M.remove(keyValue);
                            //map_Sect_ImpValue_M.put(keyValue,revVal_m);//sfdc 910701
                            //map_Sect_ImpValue_M.put(keyValue,mValue); //  (Decimal)ar.get('marg_PassThru'));
                            
                            //TotalRevCount_M =  TotalRevCount_M + mValue; //  (Decimal)ar.get('marg_PassThru');
                            //TotalImpCount_M = TotalImpCount_M + mValue; //  (Decimal)ar.get('marg_PassThru');
                   } //end of if(sTempSectors.contains(keyValue))
                }
                
                System.debug('Value of TotalCustCount f>>>>>>' +  TotalCustCount );
            
                for (AggregateResult ar : SKUDeletedCust)
                {
                    String KeyValue = '';//sfdc 910703- to hanlde the accounts without Industry or region mentioned        	
                    if((String)ar.get('nm') != null) 
                    {
                    
                        KeyValue = ((String)ar.get('nm'));
                        if(reportType == 'Summary by Participation (Buying Group/GPO)')
                        {
                            String temp = ((String)ar.get('nm')).substring(0,6); 
                            System.debug('Value of temp>>>>>>>>' +  temp);
                            
                            if(temp == 'Buying' || temp == 'Health' || temp == 'Standa')
                                keyValue = map_buying_grp.get(temp);//'Buying Group';
                            /*else if(temp == 'Health')
                                keyValue = 'Healthcare GPO';
                            else if(temp == 'Standa')
                                keyValue = 'Standalone';*/
                        }                                            	
                        
                    }
                    //sfdc 910703- to hanlde the accounts without Industry or region mentioned        	
                    else{
                         
                        KeyValue = ((String)ar.get('nm'));                        
                        if(reportType == 'Summary by Region' || reportType ==  'Summary by Industry/Vertical Market' ||
                          reportType == 'Summary by Participation (Buying Group/GPO)')
                        {
                            if(keyValue == null || keyValue == ''){
                                keyValue = 'Other';
                                system.debug('KeyValue with null:'+keyValue);
                            }                                                       
                        }
                    }//end of sfdc 910703, 910696
                    
                    if(sTempSectors.contains(keyValue)) 
                    	{
                            decimal rValue = (Decimal)ar.get('Rev_PassThru');
                            decimal mValue = (Decimal)ar.get('marg_PassThru');
                            
                            if(rValue == null)
                                rValue = 0;
                            if(mValue == null)
                                mValue = 0;
                            
                            // for Revenue report
                            Decimal ersVal = map_Sect_ErsValue.get(keyValue);
                            ersVal = ersVal + rValue; //(Decimal)ar.get('Rev_PassThru');
                            
                            map_Sect_ErsValue.remove(keyValue);
                            map_Sect_ErsValue.put(keyValue,ersVal);
                            if((Decimal)ar.get('Rev_PassThru') != null)
                            {
                                Decimal val = map_Sect_ImpValue.get(keyValue);
                                map_Sect_ImpValue.remove(keyValue);
                                map_Sect_ImpValue.put(keyValue,(val - rValue)); //(Decimal)ar.get('Rev_PassThru')));
                                TotalImpCount = TotalImpCount - val  + (val - rValue); //(Decimal)ar.get('Rev_PassThru'));
                            }
                            
                            TotalErsCount =  TotalErsCount + rValue; // (Decimal)ar.get('Rev_PassThru');
                            
                            // for margin report
                            //map_Sect_ErsValue_M.remove(keyValue);
                            //map_Sect_ErsValue_M.put(keyValue,mValue); //(Decimal)ar.get('marg_PassThru'));
                            //if((Decimal)ar.get('marg_PassThru') != null)
                            //{
                             //   Decimal val = map_Sect_ImpValue_M.get(keyValue);
                             //   map_Sect_ImpValue_M.remove(keyValue);
                             //   map_Sect_ImpValue_M.put(keyValue,(val - mValue)); // (Decimal)ar.get('marg_PassThru')));
                             //   TotalImpCount_M = TotalImpCount_M - val  + (val - mValue); //(Decimal)ar.get('marg_PassThru'));
                            //}
                            
                            //TotalErsCount_M =  TotalErsCount_M + mValue; // (Decimal)ar.get('marg_PassThru');
                       	} 
                }
                
                map_Sect_Value.put('BSD Total', TotalCustCount);
                map_Sect_RevValue.put('BSD Total', TotalRevCount);
                map_Sect_ErsValue.put('BSD Total', TotalErsCount );
                map_Sect_ImpValue.put('BSD Total', TotalImpCount);
                
                //map_Sect_RevValue_M.put('BSD Total', TotalRevCount_M);
                //map_Sect_ErsValue_M.put('BSD Total', TotalErsCount_M );
                //map_Sect_ImpValue_M.put('BSD Total', TotalImpCount_M);
                
        		//=====% calculations
                for( String f : sSectors)
                {
                    map_Sect_perRevValue.put(f,100);
                    ///==============================
                    if(map_Sect_RevValue.get(f) != null && map_Sect_RevValue.get(f) != 0)
                    {
                        Decimal ErsPerVal = (map_Sect_ErsValue.get(f)/ map_Sect_RevValue.get(f)) * 100;
                        map_Sect_perErsValue.put(f,ErsPerVal);
                    }
                    else
                        map_Sect_perErsValue.put(f,0);
                    
                    //==========================
                    if(map_Sect_RevValue.get(f) != null && map_Sect_RevValue.get(f) != 0)
                    {    
                    Decimal ImpPerVal = (map_Sect_ImpValue.get(f)/ map_Sect_RevValue.get(f)) * 100;
                    map_Sect_perImpValue.put(f,ImpPerVal);
                    }
                    else
                       map_Sect_perImpValue.put(f,0);
                    
                    ///=================================
                    /*map_Sect_perRevValue_M.put(f,100);
                    if(map_Sect_RevValue_M.get(f) != null && map_Sect_RevValue_M.get(f) != 0)
                    {    
                    	Decimal ErsPerVal_M = (map_Sect_ErsValue_M.get(f)/ map_Sect_RevValue_M.get(f)) * 100;
                    	map_Sect_perErsValue_M.put(f,ErsPerVal_M);
                    }
                    else
                        map_Sect_perErsValue_M.put(f,0);
                        
                    //////====================================  
                    if(map_Sect_RevValue_M.get(f) != null && map_Sect_RevValue_M.get(f) != 0)
                    {
                    Decimal ImpPerVal_M = (map_Sect_ImpValue_M.get(f)/ map_Sect_RevValue_M.get(f)) * 100;
                    map_Sect_perImpValue_M.put(f,ImpPerVal_M);
                    }
                    else
                        map_Sect_perImpValue_M.put(f,0);*/
                    
                }
            
                
                AddReportData('# Customers Receiving Increases','Revenue',TotalCustCount,map_Sect_value,map_Sect_value);
                AddReportData('Original Value of Increases','Revenue',TotalRevCount,map_Sect_RevValue,map_Sect_perRevValue);
                AddReportData('Erosion','Revenue',TotalErsCount ,map_Sect_Ersvalue,map_Sect_perErsValue);
                AddReportData('Value of Increases Passed to Customers','Revenue',TotalImpCount,map_Sect_ImpValue,map_Sect_perImpValue);
                
                //AddReportData('# Customers Receiving Increases','Margin',TotalCustCount,map_Sect_value,map_Sect_value);
                //AddReportData('Original Value of Increases','Margin',TotalRevCount_M,map_Sect_RevValue_M,map_Sect_perRevValue_M);
                //AddReportData('Erosion','Margin',TotalErsCount_M ,map_Sect_Ersvalue_M,map_Sect_perErsValue_M);
                //AddReportData('Value of Increases Passed to Customers','Margin',TotalImpCount_M,map_Sect_ImpValue_M,map_Sect_perImpValue_M);                    
        
        
        ovd = lFinalReportData;                
        System.debug('Value of ovd  f>>>>>>' +  ovd );
        return null;
    }
    
    public class ReportDataCls 
    {
     public String formatType {get;set;}
     public String dataType {get;set;}
     public Map<String,Decimal> map_Sect_Val{get;set;}
     public Map<String,Decimal> map_Sect_Per{get;set;}
     public String ReportName{get;set;}
     
    }
    
    public void AddReportData(String Datatype, String ReportName, Decimal TotalValue, Map<String, Decimal> map_Sect_Value, Map<String, Decimal> map_Sect_Per)
    {
                    ReportDataCls o = new ReportDataCls ();
                    o.ReportName = ReportName;
                    o.dataType = Datatype;
                    o.formatType = fmt.get(Datatype);
                    
                    o.map_Sect_Val = map_Sect_Value;
                    o.map_Sect_per = map_Sect_per;

                    lFinalReportData.add(o);
        			system.debug('ReportDataCls:'+o);
    }
    
    public List<selectOption> getQtrs() 
    {
           List<selectOption> options = new List<selectOption>();
            for (ACE_Batches__c bt : [SELECT Id, Batch__c FROM ACE_Batches__c order by CreatedDate desc]) {
                   options.add(new selectOption(bt.Batch__c, bt.Batch__c));
           }
           return options;
    }
    
    //sfdc 910713
    public List<selectOption> getcompstatuslist() 
    {
           List<selectOption> options = new List<selectOption>();
           options.add(new selectOption('All','All'));
           options.add(new selectOption('Compliance Pending', 'Compliance Pending'));
           options.add(new selectOption('Compliance Approved', 'Compliance Approved'));
           return options;
    }
    
    public string getcompStatus(){        
        return compStatus;
    }
    
    public void setcompStatus(string compStatus){        
        this.compStatus = compStatus;
    }
    
    

      
    public PageReference doExpand() {
        return null;
    }

    public void sortCust() 
    {
        system.debug('%%%%%%%%%%'+getFieldName);
        if(getFieldName == 'CustomerId')
        {
            sortfieldName = 'Customer__r.Cust_ID__c'; 
            system.debug('%%%%%%%%%%'+getFieldName);
        }
        else if(getFieldName == 'Customer')
        {
            sortfieldName = 'Customer__r.name'; 
            system.debug('%%%%%%%%%%'+getFieldName);
        }
        else if(getFieldName == 'Rep')
        {
            
            sortfieldName = 'Customer__r.owner.name'; 
            system.debug('%%%%%%%%%%'+getFieldName);
              
        }        
        else if(getFieldName == 'Category')
        {
            sortfieldName = 'Customer_Category__c'; 
            system.debug('%%%%%%%%%%'+getFieldName);
        }
        else if(getFieldName == 'Original Date')
        {
            sortfieldName = 'Sales_Price_Change_Effective_Date__c'; 
            system.debug('%%%%%%%%%%'+getFieldName);
        }
        else if(getFieldName == 'Delay Approved')
        {
            sortfieldName = 'Sales_Price_Change_Effective_Date_min__c'; 
            system.debug('%%%%%%%%%%'+getFieldName);
        }
        else if(getFieldName == 'Revenue Lost')
        {
            sortfieldName = 'Reporting_Erosion_Field_Delay__c'; 
            system.debug('%%%%%%%%%%'+getFieldName);
        }
        else if(getFieldName == 'Margin Lost')
        {
            sortfieldName = 'Reporting_Erosion_Margin_Field_Delay__c'; 
            system.debug('%%%%%%%%%%'+getFieldName);
        }
        else if(getFieldName == 'NotifyDate')
        {
            sortfieldName = 'Customer_Notification_Date_Approved__c'; 
            system.debug('%%%%%%%%%%'+getFieldName);
        }
        else if(getFieldName == 'TransmissionDate')
        {
            sortfieldName = 'Sales_Price_Change_Effective_Date_Approv__c'; 
            system.debug('%%%%%%%%%%'+getFieldName);
        }        
        else if(getFieldName == 'ImpStatus')
        {
            sortfieldName = 'Implementation_Status__c'; 
            system.debug('%%%%%%%%%%'+getFieldName);
        }
        
        else if(getFieldName == 'VCustNo')
        {
            sortfieldName = 'Ace_customer_core_changes__r.ace_customer_price_changes__r.Owning_Customer_ID__c'; 
            system.debug('%%%%%%%%%%'+getFieldName);
        }
        else if(getFieldName == 'VCustName')
        {
            sortfieldName = 'Ace_customer_core_changes__r.ace_customer_price_changes__r.Customer__r.name'; 
            system.debug('%%%%%%%%%%'+getFieldName);
        }
        else if(getFieldName == 'VCoreId')//sfdc 910711
        {
            sortfieldName = 'Ace_customer_core_changes__r.Name'; 
            system.debug('%%%%%%%%%%'+getFieldName);
        }
        else if(getFieldName == 'VSkuId')//sfdc 910711
        {
            sortfieldName = 'SKU__c'; 
            system.debug('%%%%%%%%%%'+getFieldName);
        }
        /*else if(getFieldName == 'AcceptDate')//sfdc 910713
        {
            sortfieldName = 'Customer_Response__c'; 
            system.debug('%%%%%%%%%%'+getFieldName);
        }*/
        else if(getFieldName == 'Approval Status')//sfdc 910713
        {
            sortfieldName = 'Customer_Response__c'; 
            system.debug('%%%%%%%%%%'+getFieldName);
        }
         
        if(tabAsc){
            sortDirection = 'DESC';
            tabAsc = false;            
        }
        else {
            sortDirection = 'ASC';
            tabAsc = true;             
        }  
        system.debug('get url call3');
        
        if(reportType=='Notification' || reportType=='Response' ||reportType=='Compliance'){ //sfdc 00910713 - added compliance
            loadCustomerNotifyResponseData();
        }
        else if(reportType == 'Summary'){//sfdc 861332:changed the report name
            CustListOverviewReportData();
        }
        else if(ErosionType=='Price')
                loadErosionPriceData();
        else if(ErosionType=='Date')
                loadErosionDateData(); 
        else if(reportType=='Customer Not Receiving Full Increase')
            loadDataCustNotFullInc();
        else if(reportType=='Summary By Region' || reportType=='Summary by Sector/Segment' || reportType=='Summary by Participation (Buying Group/GPO)' || reportType=='Summary by Industry/Vertical Market')////sfdc 910701,910703 910698,910700,910696,910703 - changed the report NAME
            loadCustomerListData();    
        else if(reportType=='Remediation')
            RemediationReportCustList();
        else if(reportType=='Hosted Catalog')
            HostedCatalogReportCustList();     
        else if(reportType=='Vendavo')
            //VendSKUListReportData();
            VendSKUListReportData_1();//sfdc 861332
        else if(reportType=='Process Progress/PipeLine')
            CustListProcssProgReportData();        
      //  else{
      //      loadErosionDateData();              
      //  }
          
    }
    
    
    
    public void nextPage(){
        counter = counter+List_size;
        if(reportType=='Notification' || reportType=='Response'|| reportType=='Compliance'){ //sfdc 00910713 - added compliance
            loadCustomerNotifyResponseData();
        }
        else if(reportType == 'Summary'){//sfdc 861332:changed the report name
            CustListOverviewReportData();
        }
        else if(ErosionType=='Price')
                loadErosionPriceData();
        else if(ErosionType=='Date')
                loadErosionDateData(); 
        else if(reportType=='Customer Not Receiving Full Increase')
            loadDataCustNotFullInc();
        else if(reportType=='Summary By Region' || reportType=='Summary by Sector/Segment' || reportType=='Summary by Participation (Buying Group/GPO)' || reportType=='Summary by Industry/Vertical Market')////sfdc 910701,910703,910696,910703,910700,910698 - changed the report NAME
            loadCustomerListData();    
        else if(reportType=='Remediation')
            RemediationReportCustList();
        else if(reportType=='Hosted Catalog')
            HostedCatalogReportCustList();    
        else if(reportType=='Vendavo')
            //VendSKUListReportData();
            VendSKUListReportData_1();//sfdc 861332
        else if(reportType=='Process Progress/PipeLine')
            CustListProcssProgReportData();  
        else if(reportType=='Exception')
            ExceptionReportCustList();   
        else if(reportType == 'ChangeType')
            loadChangeTypeDataCustomerList();       
              
    }
    public void prevPage(){
        counter = counter-List_size;
        if(reportType=='Notification' || reportType=='Response'||reportType=='Compliance'){ //sfdc 00910713 - added compliance
            loadCustomerNotifyResponseData();
        }
        else if(reportType == 'Summary'){//sfdc 861332:changed the report name
            CustListOverviewReportData();
        }
        else if(ErosionType=='Price')
                loadErosionPriceData();
        else if(ErosionType=='Date')
                loadErosionDateData(); 
        else if(reportType=='Customer Not Receiving Full Increase')
            loadDataCustNotFullInc();
        else if(reportType=='Summary By Region' || reportType=='Summary by Sector/Segment' || reportType=='Summary by Participation (Buying Group/GPO)' || reportType=='Summary by Industry/Vertical Market')////sfdc 910701,910703,910698,910700,910696,910703 - changed the report NAME
            loadCustomerListData();       
        else if(reportType=='Vendavo')
            //VendSKUListReportData();
        	VendSKUListReportData_1();//sfdc 861332
        else if(reportType=='Remediation')
            RemediationReportCustList();
        else if(reportType=='Hosted Catalog')
            HostedCatalogReportCustList();
        else if(reportType=='Process Progress/PipeLine')
            CustListProcssProgReportData();      
        else if(reportType=='Exception')
            ExceptionReportCustList(); 
        else if(reportType == 'ChangeType')
            loadChangeTypeDataCustomerList();
                 
        
    }
    
   
    public Boolean getDisablePrevious() {
     
      if (counter>0) return true; else return false;
    }
    public Boolean getDisableNext() { 
     if (counter + list_size < total_size) return true; else return false;
    // return true;
   }
   
    public void sortCustPrice() 
    {
        system.debug('%%%%%%%%%%'+getFieldName);
        if(getFieldName == 'SKU')
        {
            sortfieldName = 'SKU__c'; 
            system.debug('%%%%%%%%%%'+getFieldName);
        }
        else if(getFieldName == 'Customer')
        {
            sortfieldName = 'Ace_Customer_core_changes__r.ACE_Customer_Price_Changes__r.Customer__r.AOPS_Cust_Id__c'; 
            system.debug('%%%%%%%%%%'+getFieldName);
        }
        else if(getFieldName == 'Customer Name')
        {
            sortfieldName = 'Ace_Customer_core_changes__r.ACE_Customer_Price_Changes__r.Customer__r.name';  
            system.debug('%%%%%%%%%%'+getFieldName);
        }
        else if(getFieldName == 'Current Price')
        {
            sortfieldName = 'Current_Sell_Price__c'; 
            system.debug('%%%%%%%%%%'+getFieldName);
        }
        else if(getFieldName == 'Original Price')
        {
            sortfieldName = 'Proposed_Price_with_Cap__c'; 
            system.debug('%%%%%%%%%%'+getFieldName);
        }
        else if(getFieldName == 'Price Approved')
        {
            sortfieldName = 'Approved_Proposed_Price__c'; 
            system.debug('%%%%%%%%%%'+getFieldName);
        }
        else if(getFieldName == 'Revenue Lost')
        {
            sortfieldName = 'Reporting_Erosion_Field_MarkDown__c'; 
            system.debug('%%%%%%%%%%'+getFieldName);
        }
        else if(getFieldName == 'Margin Lost')
        {
            sortfieldName = 'Reporting_Erosion_Margin_Field_MarkDown__c'; 
            system.debug('%%%%%%%%%%'+getFieldName);
        }
        
         
        if(tabAsc){
            sortDirection = 'DESC';
            tabAsc = false;            
        }
        else {
            sortDirection = 'ASC';
            tabAsc = true;             
        }  
        system.debug('get url call3');
        loadErosionPriceData();
    }
    
    // ACE Vendavo Report Code Start here //sfdc 861332
    public List<VendavoReportSKUClass> lVendSKUListReportData_1{get;set;}    
    public PageReference VendSKUListReportData_1()
    {
        Map<String,Decimal> map_ID_SKU_1 = new Map<String,Decimal>();
        Map<String,Decimal> map_SKU_current_vendvo_price_1 = new Map<string,Decimal>();
    	Map<String,Date> map_SKU_current_vendvo_EffDate_1 =  new Map<string,Date>();
        
        lVendSKUListReportData_1 = new List<VendavoReportSKUClass>();		       
        
       	//============Sorting Fields=============sfdc 910711        
        if(getFieldName == null){//For Exporting SKUs
                getFieldName = 'TransmissionDate';
            	sortfieldName = 'Sales_Price_Change_Effective_Date_Approv__c'; 
            	system.debug('getFieldNameinside%%%%%%%%%%'+getFieldName);
            	sortDirection = 'ASC';
        }       
        
        //=======================sfdc 910711
        
        //Get the Customers list based on the user hierarchy(SaleRep, DSM...etc)
        getACECustomerList(); 
        
        //////=================
        System.debug('>>>>>>>>>>>>>Searchtype:' + Searchtype);
        System.debug('>>>>>>>>>>>>>searchWord:' + searchWord);
        System.debug('>>>>>>>>>>>>>searchWordSKU:' + searchWordSKU);
        System.debug('>>>>>>>>>>>>>Reporttype:' + reportType);        
        
        String ResQuery=''; 
        ///Queries to pull based on access level (public group in sfdc:SalesOps)
        if(Searchtype == 'Customer')
        {   
            searchWord = searchWord.deleteWhitespace();
            if((searchWord != null) && (searchWord != '') && (searchWord != 'null'))
            {      
                String textToSearch = searchWord + '%';
                if (AccessLevel == 'SalesOps')
                 ResQuery = 'select id,price_change_type__c,Sales_Price_Change_Effective_Date_Approv__c,Current_Sell_Price__c ,Proposed_Price_with_Cap__c,Approved_Proposed_Price__c,Price_Changes_Type__c,Alternate_Chosen_Flag__c,SKU_Alt__c,Alt_SKU__c, Status__c, Reporting_Passed_Margin__c,Ace_customer_core_changes__r.name,Ace_customer_core_changes__r.id,Sales_Price_Change_Effective_Date__c,Implementation_Status_Code__c,Implementation_Message__c,  Implementation_Status__c,SFDC_Notification_Flag__c,Ace_customer_core_changes__r.ace_customer_price_changes__r.Customer__r.owner.name,Ace_customer_core_changes__r.ace_customer_price_changes__r.Customer__r.Name,Ace_customer_core_changes__r.ace_customer_price_changes__r.Owning_Customer_ID__c,SKU__c from Ace_Customer_SKU_Changes__c where Owning_Customer_ID__c LIKE \'' + textToSearch + '\' and batchid__c=:quarterValue  and  PRICE_NOT_CALCULATED__c = false and price_changes_type__c != \'A\' and status__c != \'Inactive\' and hosted_catalog__c = false ';
                 
                else
                 ResQuery = 'select id,price_change_type__c,Sales_Price_Change_Effective_Date_Approv__c,Current_Sell_Price__c ,Proposed_Price_with_Cap__c,Approved_Proposed_Price__c,Price_Changes_Type__c,Alternate_Chosen_Flag__c,SKU_Alt__c,Alt_SKU__c, Status__c, Reporting_Passed_Margin__c,Ace_customer_core_changes__r.name,Ace_customer_core_changes__r.id,Sales_Price_Change_Effective_Date__c,Implementation_Status_Code__c,Implementation_Message__c,  Implementation_Status__c,SFDC_Notification_Flag__c,Ace_customer_core_changes__r.ace_customer_price_changes__r.Customer__r.owner.name,Ace_customer_core_changes__r.ace_customer_price_changes__r.Customer__r.Name,Ace_customer_core_changes__r.ace_customer_price_changes__r.Owning_Customer_ID__c,SKU__c from Ace_Customer_SKU_Changes__c where Owning_Customer_ID__c LIKE \'' + textToSearch + '\' and ace_customer_core_changes__r.ace_customer_price_changes__c in:custlist  and  PRICE_NOT_CALCULATED__c = false and price_changes_type__c != \'A\' and status__c != \'Inactive\' and hosted_catalog__c = false ';  
                
            }
            else
            {
            if (AccessLevel == 'SalesOps')
             ResQuery = 'select id,price_change_type__c,Sales_Price_Change_Effective_Date_Approv__c,Current_Sell_Price__c ,Proposed_Price_with_Cap__c,Approved_Proposed_Price__c,Price_Changes_Type__c,Alternate_Chosen_Flag__c,SKU_Alt__c,Alt_SKU__c, Status__c, Reporting_Passed_Margin__c,Ace_customer_core_changes__r.name,Ace_customer_core_changes__r.id,Sales_Price_Change_Effective_Date__c,Implementation_Status_Code__c,Implementation_Message__c,  Implementation_Status__c,SFDC_Notification_Flag__c,Ace_customer_core_changes__r.ace_customer_price_changes__r.Customer__r.owner.name,Ace_customer_core_changes__r.ace_customer_price_changes__r.Customer__r.Name,Ace_customer_core_changes__r.ace_customer_price_changes__r.Owning_Customer_ID__c,SKU__c from Ace_Customer_SKU_Changes__c where batchid__c=:quarterValue  and  PRICE_NOT_CALCULATED__c = false and price_changes_type__c != \'A\' and status__c != \'Inactive\' and hosted_catalog__c = false ';  
            
            else
             ResQuery = 'select id,price_change_type__c,Sales_Price_Change_Effective_Date_Approv__c,Current_Sell_Price__c ,Proposed_Price_with_Cap__c,Approved_Proposed_Price__c,Price_Changes_Type__c,Alternate_Chosen_Flag__c,SKU_Alt__c,Alt_SKU__c, Status__c, Reporting_Passed_Margin__c,Ace_customer_core_changes__r.name,Ace_customer_core_changes__r.id,Sales_Price_Change_Effective_Date__c,Implementation_Status_Code__c,Implementation_Message__c,  Implementation_Status__c,SFDC_Notification_Flag__c,Ace_customer_core_changes__r.ace_customer_price_changes__r.Customer__r.owner.name,Ace_customer_core_changes__r.ace_customer_price_changes__r.Customer__r.Name,Ace_customer_core_changes__r.ace_customer_price_changes__r.Owning_Customer_ID__c,SKU__c from Ace_Customer_SKU_Changes__c where ace_customer_core_changes__r.ace_customer_price_changes__c in:custlist  and  PRICE_NOT_CALCULATED__c = false and price_changes_type__c != \'A\' and status__c != \'Inactive\' and hosted_catalog__c = false ';
             
            Searchtype = '';
            }    
        }
        else if(Searchtype == 'SKU')
        {    searchWordSKU = searchWordSKU.deleteWhitespace();
            if((searchWordSKU != null) && (searchWordSKU != '') && (searchWordSKU != 'null'))
            {      
                String textToSearch = searchWordSKU + '%';
                if (AccessLevel == 'SalesOps')
                 ResQuery = 'select id,price_change_type__c,Sales_Price_Change_Effective_Date_Approv__c,Current_Sell_Price__c ,Proposed_Price_with_Cap__c,Approved_Proposed_Price__c,Price_Changes_Type__c,Alternate_Chosen_Flag__c,SKU_Alt__c,Alt_SKU__c, Status__c, Reporting_Passed_Margin__c,Ace_customer_core_changes__r.name,Ace_customer_core_changes__r.id,Sales_Price_Change_Effective_Date__c,Implementation_Status_Code__c,Implementation_Message__c,  Implementation_Status__c,SFDC_Notification_Flag__c,Ace_customer_core_changes__r.ace_customer_price_changes__r.Customer__r.owner.name,Ace_customer_core_changes__r.ace_customer_price_changes__r.Customer__r.Name,Ace_customer_core_changes__r.ace_customer_price_changes__r.Owning_Customer_ID__c,SKU__c from Ace_Customer_SKU_Changes__c where Sku__c like \'' + textToSearch + '\' and batchid__c=:quarterValue  and  PRICE_NOT_CALCULATED__c = false and price_changes_type__c != \'A\' and status__c != \'Inactive\' and hosted_catalog__c = false ';  
                
                else
                 ResQuery = 'select id,price_change_type__c,Sales_Price_Change_Effective_Date_Approv__c,Current_Sell_Price__c ,Proposed_Price_with_Cap__c,Approved_Proposed_Price__c,Price_Changes_Type__c,Alternate_Chosen_Flag__c,SKU_Alt__c,Alt_SKU__c, Status__c, Reporting_Passed_Margin__c,Ace_customer_core_changes__r.name,Ace_customer_core_changes__r.id,Sales_Price_Change_Effective_Date__c,Implementation_Status_Code__c,Implementation_Message__c,  Implementation_Status__c,SFDC_Notification_Flag__c,Ace_customer_core_changes__r.ace_customer_price_changes__r.Customer__r.owner.name,Ace_customer_core_changes__r.ace_customer_price_changes__r.Customer__r.Name,Ace_customer_core_changes__r.ace_customer_price_changes__r.Owning_Customer_ID__c,SKU__c from Ace_Customer_SKU_Changes__c where Sku__c like \'' + textToSearch + '\' and ace_customer_core_changes__r.ace_customer_price_changes__c in:custlist  and  PRICE_NOT_CALCULATED__c = false and price_changes_type__c != \'A\' and status__c != \'Inactive\' and Ace_customer_core_changes__r.ace_customer_price_changes__r.hosted_catalog__c = false ';
                
            }
            else
            {
            if (AccessLevel == 'SalesOps')
             ResQuery = 'select id,price_change_type__c,Sales_Price_Change_Effective_Date_Approv__c,Current_Sell_Price__c ,Proposed_Price_with_Cap__c,Approved_Proposed_Price__c,Price_Changes_Type__c,Alternate_Chosen_Flag__c,SKU_Alt__c,Alt_SKU__c, Status__c, Reporting_Passed_Margin__c,Ace_customer_core_changes__r.name,Ace_customer_core_changes__r.id,Sales_Price_Change_Effective_Date__c,Implementation_Status_Code__c,Implementation_Message__c,  Implementation_Status__c,SFDC_Notification_Flag__c,Ace_customer_core_changes__r.ace_customer_price_changes__r.Customer__r.owner.name,Ace_customer_core_changes__r.ace_customer_price_changes__r.Customer__r.Name,Ace_customer_core_changes__r.ace_customer_price_changes__r.Owning_Customer_ID__c,SKU__c from Ace_Customer_SKU_Changes__c where batchid__c=:quarterValue  and  PRICE_NOT_CALCULATED__c = false and price_changes_type__c != \'A\' and status__c != \'Inactive\' and hosted_catalog__c = false ';  
             
            else
             ResQuery = 'select id,price_change_type__c,Sales_Price_Change_Effective_Date_Approv__c,Current_Sell_Price__c ,Proposed_Price_with_Cap__c,Approved_Proposed_Price__c,Price_Changes_Type__c,Alternate_Chosen_Flag__c,SKU_Alt__c,Alt_SKU__c, Status__c, Reporting_Passed_Margin__c,Ace_customer_core_changes__r.name,Ace_customer_core_changes__r.id,Sales_Price_Change_Effective_Date__c,Implementation_Status_Code__c,Implementation_Message__c,  Implementation_Status__c,SFDC_Notification_Flag__c,Ace_customer_core_changes__r.ace_customer_price_changes__r.Customer__r.owner.name,Ace_customer_core_changes__r.ace_customer_price_changes__r.Customer__r.Name,Ace_customer_core_changes__r.ace_customer_price_changes__r.Owning_Customer_ID__c,SKU__c from Ace_Customer_SKU_Changes__c where ace_customer_core_changes__r.ace_customer_price_changes__c in:custlist  and  PRICE_NOT_CALCULATED__c = false and price_changes_type__c != \'A\' and status__c != \'Inactive\' and hosted_catalog__c = false ';
            
            Searchtype ='';
            
            }    
        }
        else
        {
            if (AccessLevel == 'SalesOps')
             ResQuery = 'select id,price_change_type__c,Current_Sell_Price__c ,Sales_Price_Change_Effective_Date_Approv__c,Proposed_Price_with_Cap__c,Approved_Proposed_Price__c,Price_Changes_Type__c,Alternate_Chosen_Flag__c,SKU_Alt__c,Alt_SKU__c, Status__c, Reporting_Passed_Margin__c,Ace_customer_core_changes__r.name,Ace_customer_core_changes__r.id,Sales_Price_Change_Effective_Date__c,Implementation_Status_Code__c,Implementation_Message__c,  Implementation_Status__c,SFDC_Notification_Flag__c,Ace_customer_core_changes__r.ace_customer_price_changes__r.Customer__r.owner.name,Ace_customer_core_changes__r.ace_customer_price_changes__r.Customer__r.Name,Ace_customer_core_changes__r.ace_customer_price_changes__r.Owning_Customer_ID__c,SKU__c from Ace_Customer_SKU_Changes__c where batchid__c=:quarterValue  and  PRICE_NOT_CALCULATED__c = false and price_changes_type__c != \'A\' and status__c != \'Inactive\' and hosted_catalog__c = false ';  
             
            else
             ResQuery = 'select id,price_change_type__c,Current_Sell_Price__c ,Sales_Price_Change_Effective_Date_Approv__c,Proposed_Price_with_Cap__c,Approved_Proposed_Price__c,Price_Changes_Type__c,Alternate_Chosen_Flag__c,SKU_Alt__c,Alt_SKU__c, Status__c, Reporting_Passed_Margin__c,Ace_customer_core_changes__r.name,Ace_customer_core_changes__r.id,Sales_Price_Change_Effective_Date__c,Implementation_Status_Code__c,Implementation_Message__c,  Implementation_Status__c,SFDC_Notification_Flag__c,Ace_customer_core_changes__r.ace_customer_price_changes__r.Customer__r.owner.name,Ace_customer_core_changes__r.ace_customer_price_changes__r.Customer__r.Name,Ace_customer_core_changes__r.ace_customer_price_changes__r.Owning_Customer_ID__c,SKU__c from Ace_Customer_SKU_Changes__c where ace_customer_core_changes__r.ace_customer_price_changes__c in:custlist  and  PRICE_NOT_CALCULATED__c = false and price_changes_type__c != \'A\' and status__c != \'Inactive\' and hosted_catalog__c = false ';  
             
        }               
        
        //To calculate the page size for nextpage and previous pages.
        List<Ace_Customer_SKU_Changes__c> lskulist_1 = new List<Ace_Customer_SKU_Changes__c>(); 
        List<Ace_Customer_SKU_Changes__c> lTotal = new List<Ace_Customer_SKU_Changes__c>();
        if (ResQuery != null && ResQuery != '')
        {
            //==================================
        	String QueryForCount = ResQuery + ' limit 1000';
        	System.debug('>>>>>>>>>>>>>>>>>>>Count Query' + QueryForCount);
        	lTotal = Database.query(QueryForCount); 
        	total_size = lTotal.size();
        	//=====================================                       
            
            if(SKUDownload == 'Yes')
                ResQuery = ResQuery + ' order by '+ sortfieldName+' '+sortDirection+' offset :counter';
            else
         		ResQuery = ResQuery + ' order by '+ sortfieldName+' '+sortDirection+' limit : List_size offset :counter';         
         	
         	System.debug('>>>>>>>>>>>>>>>>>>>Query' + ResQuery );            
            
         	lskulist_1 = database.query(ResQuery);
            
            system.debug('SKUDownload:'+SKUDownload);
            system.debug('lskulist_1.size():'+lskulist_1.size());
        }
        
        //==============Collecting ALTSKU info------------Start
        set<string> altsku = new set<string>();
        for (ace_customer_sku_changes__c ac:[select sku_alt__c from ace_customer_sku_changes__c where id=:lskulist_1 and sku_alt__c <> null])
            altsku.add(ac.sku_alt__c);        
        
        for(ACE_Customer_SKU_Changes__c ac :[select id,price_change_type__c,CoreList_ID__c,Owning_Customer_ID__c,Alternate_Chosen_Flag__c, Current_Sell_Price__c,SKU_Alt__c,Alt_SKU__c, Status__c,Reporting_Passed_Margin__c,Ace_customer_core_changes__r.name,Ace_customer_core_changes__r.id,Sales_Price_Change_Effective_Date__c,Implementation_Status_Code__c,Implementation_Message__c,  Implementation_Status__c,SFDC_Notification_Flag__c,Ace_customer_core_changes__r.ace_customer_price_changes__r.Customer__r.owner.name,Ace_customer_core_changes__r.ace_customer_price_changes__r.Customer__r.Name,Ace_customer_core_changes__r.ace_customer_price_changes__r.Owning_Customer_ID__c,SKU__c,Proposed_Price_with_Cap__c,Approved_Proposed_Price__c from Ace_Customer_SKU_Changes__c where sku__c=:altsku  and price_changes_type__c = 'A' and batchid__c = :quarterValue and ace_customer_core_changes__r.ace_customer_price_changes__c in:custlist])
        {
            map_ID_SKU_1.put(ac.SKU__c+ac.corelist_id__c+ac.owning_customer_id__c,ac.Approved_Proposed_Price__c);                       
        }//=============Collecting ALTSKU info------------End
        system.debug('map_ID_SKU_1.size():'+map_ID_SKU_1.size());
        
        //===========Collecting Current vendavo price-----start
        set<string> sreportskulist = new set<String>();
        for (ace_customer_sku_changes__c ac1:[select CoreList_ID__c,sku__c from ace_customer_sku_changes__c where id=:lskulist_1]){
            string sku_uniqueid = ac1.CoreList_ID__c+ac1.SKU__c;
            sreportskulist.add(sku_uniqueid);                    
        }
        system.debug('sreportskulist.size():'+sreportskulist.size());
        
        for (ACE_Vendavo_SKU_Prices__c ac2:[select CoreList_ID__c,SKU__c,Vendavo_Price__c,Vendavo_Effective_Date__c  from ACE_Vendavo_SKU_Prices__c where Identifier__c=:sreportskulist]){
           map_SKU_current_vendvo_price_1.put(ac2.CoreList_ID__c+ac2.SKU__c, ac2.Vendavo_Price__c);
           map_SKU_current_vendvo_EffDate_1.put(ac2.CoreList_ID__c+ac2.SKU__c, ac2.Vendavo_Effective_Date__c);
        }
        system.debug('map_SKU_current_vendvo_price_1.size():'+map_SKU_current_vendvo_price_1.size());
        //===========Collecting Current vendavo price-----end
                      
        
        //Loading into into list to use in VendavoReport.vfp
        for (ACE_Customer_SKU_Changes__c vrsku : lskulist_1)
        {         
        	VendavoReportSKUClass rec = new VendavoReportSKUClass();
            
            string date_1 = ''+vrsku.Sales_Price_Change_Effective_Date_Approv__c;
            rec.TransmissionDate_str = date_1;
        	rec.TransmissionDate = vrsku.Sales_Price_Change_Effective_Date_Approv__c;
            
        	//==========Status==========
            if(vrsku.Implementation_Status_Code__c == 'DATA-SUCCESS'){
                rec.Status = 'Executed';               
            }
            else if(vrsku.Implementation_Status_Code__c == 'DATA-FAILED'){
                rec.Status = 'Failed';               
            }    
            else if(vrsku.Implementation_Status_Code__c == 'DATA-SENT'){
                rec.Status = 'Transmitted';            	
        	}
            else if(vrsku.Implementation_Status_Code__c == 'SCH' && 
                   ((vrsku.Proposed_Price_with_Cap__c==vrsku.Approved_Proposed_Price__c && vrsku.Alt_SKU__c == false && vrsku.Status__c <> 'Deleted') || 
                    (vrsku.Price_Changes_Type__c == 'D' && vrsku.SKU_Alt__c == '')) ){
                rec.Status = 'No Change - No Need to Transmit';               
            }
    		else if(vrsku.Implementation_Status_Code__c == 'SCH' || vrsku.Implementation_Status_Code__c == 'SCH-PEN'){
                rec.Status = 'Not Yet Transmitted';                
    		}
        	else{
                rec.Status = vrsku.Implementation_Status_Code__c;              
            }
        	//===========status===========
        	
        	rec.StatusDetails = vrsku.Implementation_Message__c;
        	
        	if(vrsku.Implementation_Status_Code__c == 'DATA-SUCCESS'){
                if(map_SKU_current_vendvo_EffDate_1.containskey(vrsku.Ace_customer_core_changes__r.name+vrsku.SKU__c))
            		rec.StatusDetails = ''+map_SKU_current_vendvo_EffDate_1.get(vrsku.Ace_customer_core_changes__r.name+vrsku.SKU__c);
        	}
        	            
        	rec.CustomerNum = vrsku.Ace_customer_core_changes__r.ace_customer_price_changes__r.Owning_Customer_ID__c;
        	rec.CustomerName = vrsku.Ace_customer_core_changes__r.ace_customer_price_changes__r.Customer__r.name;
        	rec.CoreId = vrsku.Ace_customer_core_changes__r.name;
        	rec.SKUNum = vrsku.SKU__c;
            
            //==========SKUAction==========
            if((vrsku.Alternate_Chosen_Flag__c == false && vrsku.Status__c =='Deleted') || vrsku.Price_Changes_Type__c == 'D')
                rec.SKUAction = 'SKU Delete';
            else if(vrsku.Alternate_Chosen_Flag__c == true && vrsku.Status__c =='Deleted')
                rec.SKUAction = 'SKU Replace';
            else if(vrsku.Status__c == 'Active' && vrsku.Price_Changes_Type__c != 'D')
                rec.SKUAction = 'Price Change';
            //sfdc-910711
            else if(vrsku.Status__c == 'Active' && vrsku.Sales_Price_Change_Effective_Date__c != vrsku.Sales_Price_Change_Effective_Date_Approv__c)
                rec.SKUAction = 'Date Change';
            //sfdc 910711
            else if(vrsku.Status__c == 'Active' && vrsku.Price_Changes_Type__c != 'D' && vrsku.Sales_Price_Change_Effective_Date__c != vrsku.Sales_Price_Change_Effective_Date_Approv__c)
                rec.SKUAction = 'Price & Date Change';                    	
        	//==========SKUAction===========
        	
        	rec.SKUPrice = vrsku.Approved_Proposed_Price__c;
        	rec.SKUAlt = vrsku.SKU_Alt__c;//need to put conditions
            
            //=================
            if(vrsku.Alternate_Chosen_Flag__c == true && vrsku.Status__c =='Deleted' && vrsku.SKU_Alt__c != null && vrsku.SKU_Alt__c != '')
            {
                if(map_ID_SKU_1.containskey(vrsku.SKU_Alt__c+vrsku.Ace_customer_core_changes__r.name+vrsku.Ace_customer_core_changes__r.ace_customer_price_changes__r.Owning_Customer_ID__c))
                	rec.SKUAltPrice = map_ID_SKU_1.get(vrsku.SKU_Alt__c+vrsku.Ace_customer_core_changes__r.name+vrsku.Ace_customer_core_changes__r.ace_customer_price_changes__r.Owning_Customer_ID__c);                            
            }
            //==================       	
        	
            //=========vendavo price========
            if(map_SKU_current_vendvo_price_1.containsKey(vrsku.Ace_customer_core_changes__r.name+vrsku.SKU__c)){
        		rec.VendavoCurrentPrice = map_SKU_current_vendvo_price_1.get(vrsku.Ace_customer_core_changes__r.name+vrsku.SKU__c);
            	//system.debug('map_SKU_current_vendvo_price_1['+ );
        	}
            rec.skuId = vrsku.id;
            rec.CoreNumId = vrsku.Ace_customer_core_changes__r.id ;
            rec.CustomerNameId = vrsku.Ace_customer_core_changes__r.ace_customer_price_changes__r.id;
            
            lVendSKUListReportData_1.add(rec);
        }                    
        
        return null;
    } 
    
  
    //sfdc - 910711---start     
    public Class VendavoReportSKUClass
    {
        //TransmissionDate,Status,StatusDetails,CustomerNum,CustomerName,CoreId,SKUNum,SKUAction,SKUPrice,SKUAlt,SKUAltPrice,VendavoCurrentPrice
        //Transmission Date,Status,Status Details,Customer #,Customer Name,Core #,SKU,SKU Action,SKU Price,SKU Alt #,SKU Alt Price,Vendavo Current Price        
        public Date  TransmissionDate{get;set;}
        public string  TransmissionDate_str{get;set;}
        public String  Status{get;set;}
        public string  StatusDetails {get;set;}
        public String  CustomerNum {get;set;}
        public string  CustomerName {get;set;}
        public String  CoreId{get;set;}
        public String  SKUNum{get;set;}
        public String  SKUAction {get;set;}
        public Decimal SKUPrice {get;set;}
        public String  SKUAlt{get;set;}
        
        public Decimal SKUAltPrice{get;set;}
        public Decimal VendavoCurrentPrice{get;set;}
        
        public id skuId{get;set;}
        public id CoreNumId{get;set;}
        public id CustomerNameId{get;set;}
         
    }    
    //sfdc - 910711---end
}