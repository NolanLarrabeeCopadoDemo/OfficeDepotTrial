public class itemsToApprove
{
    public String Comments { get; set; }
    public String priceComments { get; set; }
    public String UnlockComments { get; set; }
    public String CustID{get;set;}
    public String BatchName { get; set; }
    public String PriceCustID{get;set;}
    public String PriceBatchName { get; set; }
    public List<Id> SKUProcessList2;
    public map<id,boolean> customerswithDTException {get;set;}
    public boolean disableDateButton{get;set;}
    public boolean disablePriceButton{get;set;}
    public Integer checkBoxDateLimit{Get;set;}
    public Integer checkBoxPriceLimit{get;set;}
    
  //  public Boolean PriceSKURefresh { get; set; }
    public PageReference AssignFunc()
    {
         return null;
    }
    
    public PageReference CancelFunc()
    {
        batchname='';
        priceComments = '';
        UnlockComments = '';
        custid = null;
        Pricebatchname='';
        Pricecustid = null;
        pricetype = '';
        type = '';
        comments = '';
        dateVal = '';
        priceVal = '';
        return null;
    }
    public PageReference ApproveFunc()
    {
       // PriceSKURefresh = false;
        System.debug('Inside ApproveFunc');
        System.debug('>>>>>>>a>>>>>>>>>>>>>CUstid' + custID);
        System.debug('>>>>>>a>>>>>>>>>>>>>>comment' + comments);
        System.debug('>>>>>>a>>>>>>>>>>>>>>pricecomments' + pricecomments);
        System.debug('>>>>>>a>>>>>>>>>>>>>>BatchName ' + BatchName );
        System.debug('>>>>>>>a>>>>>>>>>>>>>pricecustid' + pricecustid);
        System.debug('>>>>>>>a>>>>>>>>>>>>>pricebatchname' + pricebatchname);
        System.debug('>>>>>>>a>>>>>>>>>>>>>PriceType ' + PriceType );
        System.debug('>>>>>>>a>>>>>>>>>>>>>type' + type);
        
        if(PriceType =='Date' || PriceType == 'Price') 
        {
            custid = pricecustid;
           // Comments = priceComments;
        }
        
        if(type=='Date' || PriceType == 'Date') 
        {
            if(UnlockComments != null && UnlockComments != '')
                comments = UnlockComments;
                
            approveDateWithChange();
            ACE_RECALL_APPROVAL_PROCESS.ACEApprRejMethod(CustID,Comments,'Approve');
            
        }
        if(type=='Price' || PriceType == 'Price')
        {
            approvePriceWithChange();
            ACE_RECALL_APPROVAL_PROCESS.ACEApprRejMethod(CustID,priceComments,'Approve');
           // PriceSKURefresh = true;
        }
        
        custdueFilter = 'all';
        priceComments = '';
        UnlockComments = '';
        batchname='';
        custid = null;
        comments = '';
        Pricebatchname='';
        Pricecustid = null;
        type='';
        priceType = '';
        constructorCall();
        clickFunction();
        dateVal = '';
        priceVal = '';
        
        
        // PageReference pg = new PageReference('/apex/ACE_Summary_Grid_New?batch=' +batchname);
         //PageReference pg = new PageReference('/apex/ACE_Landing_Page');
         //PageReference pg = new PageReference('/apex/ACE_Landing_Page');
         //pg.setRedirect(true);
         //return pg;
         System.debug('>>>>>>>>>>>>>aRerender SKU>>>>' + renderSKU);
        // System.debug('>>>>>>>>>>>>>aRerender PriceSKURefresh >>>>' + PriceSKURefresh );
         return null;
    }
    
    public PageReference RejectFunc()
    {
       // PriceSKURefresh = false;
        System.debug('>>>>>>>r>>>>>>>>>>>>>CUstid' + custID);
        System.debug('>>>>>>r>>>>>>>>>>>>>>comment' + comments);
        System.debug('>>>>>>r>>>>>>>>>>>>>>BatchName ' + BatchName );
        System.debug('>>>>>>>r>>>>>>>>>>>>>pricecustid' + pricecustid);
        System.debug('>>>>>>>r>>>>>>>>>>>>>pricebatchname' + pricebatchname);
        System.debug('>>>>>>>r>>>>>>>>>>>>>PriceType ' + PriceType );
        System.debug('>>>>>>>r>>>>>>>>>>>>>type' + type);
        
        if(PriceType =='Date' || PriceType == 'Price') 
            custid = pricecustid;
        
        if(type=='Date' || PriceType == 'Date') 
        {
           if(UnlockComments != null && UnlockComments != '')
                comments = UnlockComments;
            
           // approveDateWithChange();
            system.debug('Approver Comments:' + comments);
            ACE_RECALL_APPROVAL_PROCESS.ACEApprRejMethod(CustID,Comments,'Reject');
        }
        else if(type=='Price' || PriceType == 'Price')
        {
           // approvePriceWithChange();
            ACE_RECALL_APPROVAL_PROCESS.ACEApprRejMethod(CustID,priceComments,'Reject');
           // PriceSKURefresh = true;
        }    
            
        custdueFilter = 'all';
        batchname='';
        priceComments = '';
        UnlockComments = '';
        custid = null;
        comments = '';
        
        Pricebatchname='';
        Pricecustid = null;
        type='';
        priceType = '';
        constructorCall();
        clickFunction();
        priceVal = '';
        dateVal = '';
        // PageReference pg = new PageReference('/apex/ACE_Summary_Grid_New?batch=' +batchname);
       //  PageReference pg = new PageReference('/apex/ACE_Landing_Page');
       //  pg.setRedirect(true);
       //  return pg;
       
       System.debug('>>>>>>>>>>>>>rRerender SKU>>>>' + renderSKU);
       return null;
    }
    //00826596
    public PageReference approveDateBulk()
    {
        List<wrapperAppPendList> selectedDateList = new List<wrapperAppPendList>();
        for(Integer i = 0; i < UIList1.size(); i++)
        {
             if(UIList1[i].isSelected == true)
             {
                 System.debug(UIList1[i].custid + ' selected, added to approval date list');
                 selectedDateList.add(UIList1[i]);
                 UIList1[i].isSelected = false;
             }
        }
        list<ID> dateIDs = new list<ID>();
        for(Integer i = 0; i < selectedDateList.size(); i++)
        {
             if(selectedDateList[i].custid != null)
             {
               System.debug('Approving' + selectedDateList[i].custid + ' in approveDateBulk');
               dateIDs.add(selectedDateList[i].custid);
             }
        }
        ACE_RECALL_APPROVAL_PROCESS.ACEApprRejMethodBulk(dateIDs,'','Approve');
        constructorCall();
        return null;
    }
    
    public PageReference approvePriceBulk()
    {
        disablePriceButton = true;
        disableDateButton = true;
        List<skuListTable> selectedPriceList = new List<skuListTable>();
        for(Integer i = 0; i < clsSKUListTable.size(); i++)
        {
             if(clsSKUListTable[i].isSelected == true)
             {
                 System.debug(clsSKUListTable[i].ts.id + ' selected, added to approval price list');
                 selectedPriceList.add(clsSKUListTable[i]);
                 clsSKUListTable[i].isSelected = false;
             }
        }
        list<ID> priceIDs = new list<ID>();
        for(Integer i = 0; i < selectedPriceList.size(); i++)
        {
             if(selectedPriceList[i].ts.id != null)
             {
               System.debug('Approving' + selectedPriceList[i].ts.id + ' in approvePriceBulk');
               priceIDs.add(selectedPriceList[i].ts.id);
             }
        }
        ACE_RECALL_APPROVAL_PROCESS.ACEApprRejMethodBulk(priceIDs,'','Approve');
        constructorCall();
        //Adjusted to Bulk method to prevent trigger error. 00826596
        return null;
    }

    public Integer List_size = 10;
    public Integer total_size{get;set;}
    public Integer counter = 0;
    public Integer SKUtot;
    public Set<ID> sIDs;
    public String dueFilter{get;set;}
    public String custdueFilter{get;set;}
    public List<Ace_Customer_Core_Changes__c> lCustomerCoreChanges ;
    public ID custPriceChangesID;
    public ID CurrentUser{get;set;}
    public List<wrapperAppPendList> UIApprovalList{get;set;}
    public List<wrapperAppPendList> UIList{get;set;}
    public List<wrapperAppPendList> UIList1{get;set;}    
    public Map<ID,ID> IDWorkItemMap {get;set;}
    public Map<ID,Datetime> IDWorkItemMapDate {get;set;}
    public String redirectURL {get;set;}
    public boolean Redirect {get;set;}
    public List<Ace_Customer_SKU_Changes__c> skuList{get;set;} 
    public List<skuListTable> clsSKUListTable{get;set;}

    public Boolean renderSKU{get;set;}
    public Boolean renderCUST{get;set;}
    public ID passthruCustID{get;set;}   
    public String skuCustName{get;set;}
    public String skuCustNumber{get;set;}
    public String outputLabelSKU{get;set;}
    public Decimal ModPropPrice{get;set;}
    public Id passThruId{get;set{passThruId=value;}}
    public Decimal TotImpact{get;set;}
    public Decimal RevImpact{get;set;}
    public Decimal PrevImpact{get;set;}
    public Date ModDate{get;set{ModDate=value;}}
    public Map<ID,String> custDateMap {get;set;}
    public Map<ID,String> custPriceMap {get;set;}
    public Decimal TotRevImpact{get;set;}
    public Decimal ApprovalDays{get;set;}
    public ID loggedUserId{get;set;}
    public Integer Offset{get;set;}
    public boolean nullCheck{get;set;}
    public  ACE_Customer_Price_Changes__c pchangeOb {get;set;}
    public String dateVal{get;set;}
    public String priceVal{get;set;}
    public String type{get;set;}
    public String Pricetype{get;set;}

    
    public class wrapperAppPendList{
    
        public ACE_Customer_Price_Changes__c ts {get;set;}
        public ID CUSTID{get;set;}
        public String CUSTNAME{get;set;}
        public String BatchNAME{get;set;}
        
        public String JS_CUSTNAME{get;set;}
        public String CUSTNUMBER{get;set;}
        public String APPREJ{get;set;}
        public Boolean ENABLEBTN{get;set;}
        public Date CURRDATE{get;set;}
        public Date PROPDATE{get;set;}
        public Date MODDATE{get;set;}
        public String REPNAME{get;set;}
        public Boolean CheckSKU{get;set;}
        public Boolean DATETYPE{get;set;}
        public Boolean ENABLEPD{get;set;}
        public Decimal REVIMPACT{get;set;} 
        public String DESCR{get;set;}
        public Boolean CHANGERED{get;set;}
        public Boolean UNLOCKREQ{get;set;}
        public Date RQDATE{get;set;}
        public Boolean isSelected {get;set;}
        public Boolean dateCheckboxDisabled {get;set;}
    }
    
    public itemsToApprove(){ 
        //nullCheck =false;  
        customerswithDTException = new map<id,boolean>() ;
        custdueFilter = 'all';
       // CustID = '';
        batchname='';
        disableDateButton = true;
        disablePriceButton = true;
        checkBoxDateLimit = 1;
        checkBoxPriceLimit = 1;
        constructorCall();
    }   
    
    public void constructorCall(){  
              
        Offset = 0;
        clsSKUListTable = new List<skuListTable>();
        loggedUserId = UserInfo.getUserId();
        ACE_Settings__c CS = [select id,ApprovalDays__c from ACE_Settings__c limit 1];
        if(CS.ApprovalDays__c != null)
            ApprovalDays = CS.ApprovalDays__c;
        else
            ApprovalDays = 0;
        
        renderCUST = false;
        renderSKU = false;      
        Redirect = false;    
        custDateMap = new Map<ID,String> ();  
        custPriceMap = new Map<ID,String> ();
       // outputLabelSKU = 'Please click on the link for any Customer name to view a list of the corresponding SKUs.';
        CurrentUser = UserInfo.getUserID();// to get current logged in user
        //pending customer approavals 
        List<ProcessInstanceWorkitem> custprocessList1= new List<ProcessInstanceWorkitem>();
        //New code - ivarada 2/5/2015 - begins
        List<ProcessInstanceWorkitem> custprocessListDT= new List<ProcessInstanceWorkitem>();
        //New code - ivarada 2/5/2015 - ends
        IDWorkItemMap = new Map<ID,ID> ();
        IDWorkItemMapDate = new Map<ID,DateTime> ();
        custprocessList1= [SELECT ID,createdDate,
                                 ProcessInstance.TargetObjectId 
                            FROM ProcessInstanceWorkitem 
                            where ActorId =: CurrentUser    
                            AND (ProcessInstance.TargetObject.Name LIKE  'Q%')];
        //New code - ivarada 2/5/2015 - begins
        List<Id> CustomerProcessListDT = new list<id>();
        for (ProcessInstanceWorkitem cp: [SELECT ID,createdDate,
                                 ProcessInstance.TargetObjectId 
                            FROM ProcessInstanceWorkitem 
                            where ActorId <> : CurrentUser    
                            AND (ProcessInstance.TargetObject.Name LIKE  'Q%') LIMIT 50000]) {
           CustomerProcessListDT.add(cp.ProcessInstance.TargetObjectId);  
           //map<id,boolean> customerswithDTException = new map<id,boolean>();
           for(ACE_Customer_Price_Changes__c a: [select id from ACE_Customer_Price_Changes__c where id in :CustomerProcessListDT AND Record_Unlock_Status__c != 'Pending']) {
               customerswithDTException.put(a.id,true);           
           }         
        }
        
        //New code - ivarada 2/5/2015 - ends
        
        //to generate list of ids of the customer records
        List<Id> CustomerProcessList2= new List<Id>();
        for(ProcessInstanceWorkitem cp: custprocessList1){ 
            CustomerProcessList2.add(cp.ProcessInstance.TargetObjectId);
            IDWorkItemMap.put(cp.ProcessInstance.TargetObjectId,cp.ID);
            IDWorkItemMapDate.put(cp.ProcessInstance.TargetObjectId,cp.createdDate); 
        }
        
        
        
        // to pull out the list of customer records with exception details
        List<ACE_Customer_Price_Changes__c> custPricechangeList = new List<ACE_Customer_Price_Changes__c>();
        custPricechangeList = [select id, Name,Customer__r.name,Customer__r.id,Customer__r.Owner.Name,Date_Exception_Additional_Comments__c,
                               Sales_Price_Change_Effective_Date_Rep__c,Sales_Price_Change_Effective_Date_Approv__c,
                               OD_Revenue_Impact__c, batchId__c,
                               L1_Mgr_Approval_Start_Date__c,L2_Mgr_Approval_Start_Date__c,L3_Mgr_Approval_Start_Date__c,
                               DSM__c,RSD__c,VP__c, Owning_Customer_ID__c , SKU_Revenue_Impact__c 
                               from ACE_Customer_Price_Changes__c where id in:CustomerProcessList2 AND Record_Unlock_Status__c != 'Pending'
                               order by Customer__r.name]; 
                               
        //Code by guha - Unlock pending list
        List<ACE_Customer_Price_Changes__c> custUnlockList = new List<ACE_Customer_Price_Changes__c>();
        custUnlockList = [select id, Name,Customer__r.name,Customer__r.id,Customer__r.Owner.Name,Date_Exception_Additional_Comments__c,
                               Sales_Price_Change_Effective_Date_Rep__c,Sales_Price_Change_Effective_Date_Approv__c,
                               OD_Revenue_Impact__c, Owning_Customer_ID__c, SKU_Revenue_Impact__c,
                               L1_Mgr_Approval_Start_Date__c,L2_Mgr_Approval_Start_Date__c,L3_Mgr_Approval_Start_Date__c,
                               DSM__c,RSD__c,VP__c,batchId__c 
                               from ACE_Customer_Price_Changes__c where id in:CustomerProcessList2 AND Record_Unlock_Status__c = 'Pending'
                               order by Customer__r.name]; 
        //end of code by guha. 
         
        system.debug('@@@@@@@@@@'+custprocessList1); 
        system.debug('@@@@@@@@@@'+CustomerProcessList2);
        system.debug('@@@@@@@@@@'+custPricechangeList);        
        //Below block for SKU and corresponding cutomer records
        // below line to pull out all the skus pending for approval
        List<ProcessInstanceWorkitem> skuprocessList1= new List<ProcessInstanceWorkitem>();
        skuprocessList1= [SELECT ID,createdDate,
                                 ProcessInstance.TargetObjectId 
                            FROM ProcessInstanceWorkitem 
                            where ActorId =: CurrentUser    
                            AND (NOT ProcessInstance.TargetObject.Name LIKE  'Q%')]; 
        //To pull out all sku ids                     
        SKUProcessList2= new List<Id>();
        for(ProcessInstanceWorkitem cp: skuprocessList1){ 
            SKUProcessList2.add(cp.ProcessInstance.TargetObjectId);
            IDWorkItemMapDate.put(cp.ProcessInstance.TargetObjectId,cp.createdDate); 
        }
        //Pulling out records that match the list of SKUs  
        skuList = new List<Ace_Customer_SKU_Changes__c>();             
        
        skuList = [select id,SKU__c,
                   Ace_Customer_Core_Changes__r.Ace_Customer_Price_Changes__r.Sales_Price_Change_Effective_Date_Rep__c,
                   Ace_Customer_Core_Changes__r.Ace_Customer_Price_Changes__r.Sales_Price_Change_Effective_Date_Approv__c,
                   Ace_Customer_Core_Changes__r.Ace_Customer_Price_Changes__r.Customer__r.name,
                   Ace_Customer_Core_Changes__r.Ace_Customer_Price_Changes__r.Customer__r.Owner.Name,
                   Ace_Customer_Core_Changes__r.Ace_Customer_Price_Changes__r.OD_Revenue_Impact__c,
                   Ace_Customer_Core_Changes__r.Ace_Customer_Price_Changes__r.Owning_Customer_ID__c,
                   Ace_Customer_Core_Changes__r.Ace_Customer_Price_Changes__r.SKU_Revenue_Impact__c,
                   Ace_Customer_Core_Changes__r.Ace_Customer_Price_Changes__r.batchId__c, 
                   L1_Mgr_Approval_Start_Date__c,L2_Mgr_Approval_Start_Date__c,L3_Mgr_Approval_Start_Date__c,
                   DSM__c,RSD__c,VP__c,name,
                   Ace_Customer_Core_Changes__r.Ace_Customer_Price_Changes__r.id
                          from Ace_Customer_SKU_Changes__c   where id in:SKUProcessList2 ORDER BY Ace_Customer_Core_Changes__r.Ace_Customer_Price_Changes__r.Customer__r.name  ];
        
        
         
        for(Ace_Customer_SKU_Changes__c s: skulist)
          custPriceMap.put(s.id,'');
        
        system.debug('#########'+skuList); 
        system.debug('#########'+SKUProcessList1);
        system.debug('#########'+SKUProcessList2);    
        //
        //List<Ace_Customer_SKU_Changes__c> templist1 = new List<Ace_Customer_SKU_Changes__c>();
        TotRevImpact = 0;        
        //
        // to generate Customer records pending for approval    
        UIApprovalList = new List<wrapperAppPendList>();
        Map<ID,wrapperAppPendList> map_custID_temp = new Map<Id,wrapperAppPendList>();
        TotRevImpact =0.0;
        for(ACE_Customer_Price_Changes__c cus: custPricechangeList)
        {
            
            if(!map_custID_temp.containsKey(cus.id))
            {
            wrapperAppPendList uiCust = new wrapperAppPendList(); 
            uiCust.CUSTID = cus.id;
            uiCust.ts = cus;
            uiCust.CUSTNAME= cus.Customer__r.name;
            uiCust.BatchNAME = cus.batchId__c;
            uiCust.JS_CUSTNAME= cus.Customer__r.name.replace('\'','%');
            uiCust.CUSTNUMBER = cus.Owning_Customer_ID__c; 
            uiCust.CURRDATE= cus.Sales_Price_Change_Effective_Date_Approv__c;
            uiCust.PROPDATE= cus.Sales_Price_Change_Effective_Date_Rep__c;
            uiCust.REPNAME= cus.Customer__r.Owner.Name;
            uiCust.REVIMPACT = 0.0;
            if(cus.OD_Revenue_Impact__c != null && cus.SKU_Revenue_Impact__c != null)
                uiCust.REVIMPACT = cus.OD_Revenue_Impact__c + cus.SKU_Revenue_Impact__c;
            else if(cus.OD_Revenue_Impact__c != null && cus.SKU_Revenue_Impact__c == null)
                uiCust.REVIMPACT = cus.OD_Revenue_Impact__c;
            else if(cus.OD_Revenue_Impact__c == null && cus.SKU_Revenue_Impact__c != null)
                uiCust.REVIMPACT = cus.SKU_Revenue_Impact__c;
                
                
            uiCust.DESCR = cus.Date_Exception_Additional_Comments__c;
            if(uiCust.REVIMPACT != null)
                TotRevImpact = TotRevImpact + uiCust.REVIMPACT;
            // else 
            //    TotRevImpact = 0.00;
            uiCust.ENABLEBTN= true; 
            uiCust.CHANGERED = false;                              
            uiCust.MODDATE = null;  
            
            if(IDWorkItemMapDate.containsKey(cus.id))
            {
                uiCust.RQDATE = IDWorkItemMapDate.get(cus.id).date();
            }
                //To check if the Change Type is both P&D - Deepak to suggest on optimizing this approach
                List<Ace_Customer_SKU_Changes__c> templist1 = new List<Ace_Customer_SKU_Changes__c>();
                List<Ace_Customer_Core_Changes__c> lCustomerCoreChanges = [Select id from Ace_Customer_Core_Changes__c where ACE_Customer_Price_Changes__c =:cus.id];
                Set<ID> sIDs = new Set<ID>();
                for(Ace_Customer_Core_Changes__c l: lCustomerCoreChanges){
                    sIDs.add(l.id);
                }                       
                templist1 = [select id 
                           from Ace_Customer_SKU_Changes__c 
                           where Ace_Customer_Core_Changes__c in: sIDs  AND Approval_status__c = 'Pending' and id in:SKUProcessList2];
            
                if(templist1 != null && templist1.size() > 0)
                    uiCust.ENABLEPD = true;
                else
                    uiCust.ENABLEPD = false;
                //   
           //Code for Dropdown logic - All / Overdue      
               //if(custdueFilter == 'PastDue')
               //{
                 
                 System.debug('>>>>>>>>>>>>>>>>Approvaltart Date' + cus.L3_Mgr_Approval_Start_Date__c);
                 
                   if(cus.VP__c == UserInfo.getUserID() && cus.L3_Mgr_Approval_Start_Date__c != null 
                   && (Integer.valueOf((system.Now().getTime() - cus.L3_Mgr_Approval_Start_Date__c.getTime())/(1000*60*60*24))) >= ApprovalDays){
                        uiCust.CHANGERED = true;
                        map_custID_temp.put(cus.id,uiCust);
                   }
                   else if(cus.RSD__c == UserInfo.getUserID() && cus.L2_Mgr_Approval_Start_Date__c != null 
                   && (Integer.valueOf((system.Now().getTime() - cus.L2_Mgr_Approval_Start_Date__c.getTime())/(1000*60*60*24))) >= ApprovalDays){
                        uiCust.CHANGERED = true;
                        map_custID_temp.put(cus.id,uiCust);
                   }
                   else if(cus.DSM__c == UserInfo.getUserID() && cus.L1_Mgr_Approval_Start_Date__c != null 
                   && (Integer.valueOf((system.Now().getTime() - cus.L1_Mgr_Approval_Start_Date__c.getTime())/(1000*60*60*24))) >= ApprovalDays){
                   
                        uiCust.CHANGERED = true;
                        system.debug('Time Diff1:' + Integer.valueOf((system.Now().getTime() - cus.L1_Mgr_Approval_Start_Date__c.getTime())/(1000*60*60*24)));
                        map_custID_temp.put(cus.id,uiCust);
                   }
                   else{
                       map_custID_temp.put(cus.id,uiCust);
                   }
               //} 
               //else{
                   map_custID_temp.put(cus.id,uiCust);
               //}                              
            // UIApprovalList.add(uiCust);                       
            //map_custID_temp.put(cus.id,uiCust);
            }
        }
        
        System.debug('>>>>>>>>>>>>>>>>>>Point 1' + map_custID_temp.size());
        System.debug('>>>>>>>>>>>>>>>>>>Point 2' + map_custID_temp);
        
        for(ACE_Customer_Price_Changes__c unReq: custUnlockList ){
           
            wrapperAppPendList uiCust = new wrapperAppPendList(); 
            uiCust.CUSTID = unReq.id;
            uiCust.ts = unReq;
           
            uiCust.CUSTNAME= unReq.Customer__r.name;
            uiCust.BatchNAME = unReq.batchId__c;
            uiCust.JS_CUSTNAME= unReq.Customer__r.name.replace('\'','%');
            uiCust.CUSTNUMBER = unReq.Owning_Customer_ID__c; 
            uiCust.CURRDATE= unReq.Sales_Price_Change_Effective_Date_Approv__c;            
            uiCust.REPNAME= unReq.Customer__r.Owner.Name;
            uiCust.DESCR = unReq.Date_Exception_Additional_Comments__c;
            // uiCust.DESCR = 'Customer record Submitted for Unlock Request';
            uiCust.REVIMPACT = 0.0;
            if(unReq.OD_Revenue_Impact__c != null && unReq.SKU_Revenue_Impact__c != null)
                uiCust.REVIMPACT = unReq.OD_Revenue_Impact__c + unReq.SKU_Revenue_Impact__c;
             else if(unReq.OD_Revenue_Impact__c != null && unReq.SKU_Revenue_Impact__c == null)
                uiCust.REVIMPACT = unReq.OD_Revenue_Impact__c;
             else if(unReq.OD_Revenue_Impact__c == null && unReq.SKU_Revenue_Impact__c != null)
                uiCust.REVIMPACT =  unReq.SKU_Revenue_Impact__c;
            
            if(uiCust.REVIMPACT != null)
                TotRevImpact = TotRevImpact + uiCust.REVIMPACT;
                    
            uiCust.ENABLEBTN= false; 
            uiCust.CHANGERED = false;                              
            uiCust.MODDATE = null;                  
            uiCust.ENABLEPD = false;
            uicust.UNLOCKREQ = true;
            if(IDWorkItemMapDate.containsKey(unReq.id))
            {
                uiCust.RQDATE = IDWorkItemMapDate.get(unReq.id).date();
            }
           //Code for Dropdown logic - All / Overdue      
               if(custdueFilter == 'PastDue'){
                   if(unReq.VP__c == UserInfo.getUserID() && unReq.L3_Mgr_Approval_Start_Date__c.getTime() != null 
                   && (Integer.valueOf((system.Now().getTime() - unReq.L3_Mgr_Approval_Start_Date__c.getTime())/(1000*60*60*24))) >= ApprovalDays){
                        uiCust.CHANGERED = true;
                        map_custID_temp.put(unReq.id,uiCust);
                   }
                   else if(unReq.RSD__c == UserInfo.getUserID() && unReq.L2_Mgr_Approval_Start_Date__c.getTime() != null 
                   && (Integer.valueOf((system.Now().getTime() - unReq.L2_Mgr_Approval_Start_Date__c.getTime())/(1000*60*60*24))) >= ApprovalDays){
                        uiCust.CHANGERED = true;
                        map_custID_temp.put(unReq.id,uiCust);
                   }
                   else if(unReq.DSM__c == UserInfo.getUserID() && unReq.L1_Mgr_Approval_Start_Date__c.getTime() != null 
                   && (Integer.valueOf((system.Now().getTime() - unReq.L1_Mgr_Approval_Start_Date__c.getTime())/(1000*60*60*24))) >= ApprovalDays){
                   
                        uiCust.CHANGERED = true;
                        system.debug('Time Diff1:' + Integer.valueOf((system.Now().getTime() - unReq.L1_Mgr_Approval_Start_Date__c.getTime())/(1000*60*60*24)));
                        map_custID_temp.put(unReq.id,uiCust);
                   }
               } 
               else{
                   map_custID_temp.put(unReq.id,uiCust);
               }                                                      
        }
        
        System.debug('>>>>>>>>>>>>>>>>>>Point 3' + map_custID_temp.size());
        System.debug('>>>>>>>>>>>>>>>>>>Point 4' + map_custID_temp);
        
        for(Ace_Customer_SKU_Changes__c cl: skuList)
        {    system.debug('#########'+skuList);
           
            if(!map_custID_temp.containsKey(cl.Ace_Customer_Core_Changes__r.Ace_Customer_Price_Changes__r.id))
            {
            wrapperAppPendList uiCust = new wrapperAppPendList(); system.debug('#########'+skuList);
            uiCust.CUSTID = cl.Ace_Customer_Core_Changes__r.Ace_Customer_Price_Changes__r.id;
            uiCust.BatchNAME = cl.Ace_Customer_Core_Changes__r.Ace_Customer_Price_Changes__r.batchId__c;
            uiCust.CUSTNUMBER = cl.Ace_Customer_Core_Changes__r.Ace_Customer_Price_Changes__r.Owning_Customer_ID__c; 
            uiCust.CUSTNAME= cl.Ace_Customer_Core_Changes__r.Ace_Customer_Price_Changes__r.Customer__r.name;
            uiCust.JS_CUSTNAME= cl.Ace_Customer_Core_Changes__r.Ace_Customer_Price_Changes__r.Customer__r.name.replace('\'','%');
            uiCust.CURRDATE= cl.Ace_Customer_Core_Changes__r.Ace_Customer_Price_Changes__r.Sales_Price_Change_Effective_Date_Approv__c;
            uiCust.PROPDATE= cl.Ace_Customer_Core_Changes__r.Ace_Customer_Price_Changes__r.Sales_Price_Change_Effective_Date_Rep__c;
            uiCust.REPNAME= cl.Ace_Customer_Core_Changes__r.Ace_Customer_Price_Changes__r.Customer__r.Owner.Name;
            uiCust.ENABLEBTN= false; 
            uiCust.DESCR = '';
            uiCust.CHANGERED = false; 
            if(IDWorkItemMapDate.containsKey(cl.id))
            {
                uiCust.RQDATE = IDWorkItemMapDate.get(cl.id).date();
            }
            if(cl.Ace_Customer_Core_Changes__r.Ace_Customer_Price_Changes__r.OD_Revenue_Impact__c != null && cl.Ace_Customer_Core_Changes__r.Ace_Customer_Price_Changes__r.SKU_Revenue_Impact__c != null)
                uiCust.REVIMPACT = cl.Ace_Customer_Core_Changes__r.Ace_Customer_Price_Changes__r.OD_Revenue_Impact__c + cl.Ace_Customer_Core_Changes__r.Ace_Customer_Price_Changes__r.SKU_Revenue_Impact__c;
            else if(cl.Ace_Customer_Core_Changes__r.Ace_Customer_Price_Changes__r.OD_Revenue_Impact__c != null && cl.Ace_Customer_Core_Changes__r.Ace_Customer_Price_Changes__r.SKU_Revenue_Impact__c == null)
                uiCust.REVIMPACT = cl.Ace_Customer_Core_Changes__r.Ace_Customer_Price_Changes__r.OD_Revenue_Impact__c; 
            else if(cl.Ace_Customer_Core_Changes__r.Ace_Customer_Price_Changes__r.OD_Revenue_Impact__c == null && cl.Ace_Customer_Core_Changes__r.Ace_Customer_Price_Changes__r.SKU_Revenue_Impact__c != null)
                uiCust.REVIMPACT = cl.Ace_Customer_Core_Changes__r.Ace_Customer_Price_Changes__r.SKU_Revenue_Impact__c;
                
                
                
                            
            //uiCust.REVIMPACT = cl.Ace_Customer_Core_Changes__r.Ace_Customer_Price_Changes__r.OD_Revenue_Impact__c;   
            if(uiCust.REVIMPACT != null)
                TotRevImpact = TotRevImpact + uiCust.REVIMPACT;      
            
            //uiCust.MODDATE = null;
               //if(custdueFilter == 'PastDue'){
                   if(cl.VP__c == UserInfo.getUserID() && cl.L3_Mgr_Approval_Start_Date__c.getTime() != null 
                   && (Integer.valueOf((system.Now().getTime() - cl.L3_Mgr_Approval_Start_Date__c.getTime())/(1000*60*60*24))) >= ApprovalDays){
                        uiCust.CHANGERED = true;
                        map_custID_temp.put(cl.Ace_Customer_Core_Changes__r.Ace_Customer_Price_Changes__r.id,uiCust);
                   }
                   else if(cl.RSD__c == UserInfo.getUserID() && cl.L2_Mgr_Approval_Start_Date__c.getTime() != null 
                   && (Integer.valueOf((system.Now().getTime() - cl.L2_Mgr_Approval_Start_Date__c.getTime())/(1000*60*60*24))) >= ApprovalDays){
                        uiCust.CHANGERED = true;
                        map_custID_temp.put(cl.Ace_Customer_Core_Changes__r.Ace_Customer_Price_Changes__r.id,uiCust);
                   }
                   else if(cl.DSM__c == UserInfo.getUserID() && cl.L1_Mgr_Approval_Start_Date__c.getTime() != null 
                   && (Integer.valueOf((system.Now().getTime() - cl.L1_Mgr_Approval_Start_Date__c.getTime())/(1000*60*60*24))) >= ApprovalDays){
                        uiCust.CHANGERED = true;
                        map_custID_temp.put(cl.Ace_Customer_Core_Changes__r.Ace_Customer_Price_Changes__r.id,uiCust);
                   }
                   else{
                        map_custID_temp.put(cl.Ace_Customer_Core_Changes__r.Ace_Customer_Price_Changes__r.id,uiCust);
                   }
               //} 
               //else{
               //    map_custID_temp.put(cl.Ace_Customer_Core_Changes__r.Ace_Customer_Price_Changes__r.id,uiCust);
               //}
            
            //map_custID_temp.put(cl.Ace_Customer_Core_Changes__r.Ace_Customer_Price_Changes__r.id,uiCust);
            }
           // UIApprovalList.add(uiCust);
        }
        UIApprovalList = map_custID_temp.values();                                 
      
        Set<wrapperAppPendList> tempSet = new Set<wrapperAppPendList>();
        UIList = new List<wrapperAppPendList>();
        // Below is to remove duplicates
        tempSet.addALL(UIApprovalList); 
        //UIApprovalList.clear();                          
        system.debug('@@@@@@'+tempSet);        
        UIList.addAll(tempSet);
        system.debug('#######'+UIList);
        //UIList.sort();
        
        
        UIList1 = new List<wrapperAppPendList>();
        Integer j = 1;
        TotRevImpact =0;
        
            for(wrapperAppPendList w : UIApprovalList )
            {
               
                if((Offset == 0) && (j <= offset + 10))
                {    
                    UIList1.add(w); 
                    if(w.REVIMPACT != null)
                        TotRevImpact = TotRevImpact + w.REVIMPACT;
                    if(j == offset + 10)
                        break;
                }
                    
                 if(offset > 0)
                 {
                     if((j > offset) && (j <= offset + 10))        
                     {     
                        UIList1.add(w);
                        if(w.REVIMPACT != null)
                            TotRevImpact = TotRevImpact + w.REVIMPACT;
                        if(j == offset + 10)
                            break;      
                     }
                 }
                     
                j++;
            }
        
        //UIList1.sort(); 
        if(UIList1.size() > 0) {
             renderCUST = true; // to render customer level table
       
       // New code added by deepak to add SKU workitems - starts
           //system.debug('DEEPAK0:' + CustomerProcessList2);
           list<ID> customerPchangeIDs = new list<ID>();
           for (wrapperAppPendList u:UIList) {
             customerPchangeIDs.add(u.CUSTID);
             custDateMap.put(u.custid,'');
           }
 
           list<Ace_Customer_SKU_Changes__c> skuItems = [select id from Ace_Customer_SKU_Changes__c where Ace_Customer_Core_Changes__r.Ace_Customer_Price_Changes__c in :customerPchangeIDs  AND Approval_status__c = 'Pending'];
           system.debug('Check Point1:' + skuitems.size());
           List<ProcessInstanceWorkitem> skuApprovalList = [SELECT ID,
                                                                 ProcessInstance.TargetObjectId 
                                                            FROM ProcessInstanceWorkitem 
                                                            where ActorId =: CurrentUser
                                                            and ProcessInstance.TargetObjectId in :skuItems];
           system.debug('Approval SKU:' + skuApprovalList.size());                                              
           for(ProcessInstanceWorkitem cp: skuApprovalList) {
            IDWorkItemMap.put(cp.ProcessInstance.TargetObjectId,cp.ID);
           }
           
        // New code added by deepak to add SKU workitems - ends
       
        }
        //if(skuList.size() > 0) 
             //renderSKU = true;  // to render sku leveltable
    
    }
    
    public void custdueFilterLogic(){
        constructorCall();
    }
    
    public Boolean getDisablePrevious1() {     
      if (Offset>0) return true; else return false;      
    }
    public Boolean getDisableNext1() { 
      if (Offset+ 10 < UIList.size()) return true; else return false;      
    }
    
    public void nextbtn(){
        disableDateButton = true;
        for(Integer i = 0; i < UIList1.size(); i++)
        {
         if(UIList1[i].isSelected == true)
         {
             UIList1[i].isSelected = false;
         }
        }
        outputLabelSKU = ''; 
        Offset = Offset + 10;
        renderSKU = false;    
        counter = 0;    
        SKUtot = 0;
        UIList1 = new List<wrapperAppPendList>();
        Integer j = 1;
        TotRevImpact =0;
            for(wrapperAppPendList w : UIApprovalList ){
               
                if((Offset == 0) && (j <= offset + 10)){    
                    UIList1.add(w);  
                    if(w.REVIMPACT != null)
                        TotRevImpact = TotRevImpact + w.REVIMPACT;                   
                    if(j == offset + 10)
                        break;
                }
                    
                if(offset > 0){
                     if((j > offset) && (j <= offset + 10)){     
                        UIList1.add(w);
                        if(w.REVIMPACT != null)
                        TotRevImpact = TotRevImpact + w.REVIMPACT;
                        if(j == offset + 10)
                            break;      
                     }
                }     
                j++;
            }
            //UIList1.sort();
            
    }
    
    public void prevbtn(){
        disableDateButton = true;
        for(Integer i = 0; i < UIList1.size(); i++)
        {
         if(UIList1[i].isSelected == true)
         {
             UIList1[i].isSelected = false;
         }
        }
        outputLabelSKU = '';        
        Offset = Offset - 10;
        counter = 0;  
        SKUtot = 0;
        renderSKU = false;        
        UIList1 = new List<wrapperAppPendList>();
        Integer j = 1;
        TotRevImpact =0;
            for(wrapperAppPendList w : UIApprovalList ){
               
                if((Offset == 0) && (j <= offset + 10)){    
                    UIList1.add(w);
                    if(w.REVIMPACT != null)
                        TotRevImpact = TotRevImpact + w.REVIMPACT;                     
                    if(j == offset + 10)
                        break;
                }
                    
                if(offset > 0){
                     if((j > offset) && (j <= offset + 10)){     
                        UIList1.add(w);
                        if(w.REVIMPACT != null)
                        TotRevImpact = TotRevImpact + w.REVIMPACT;
                        if(j == offset + 10)
                            break;      
                     }
                }     
                j++;
            }
            //UIList1.sort();
            
    }
    
    
     public class skuListTable{
        public ACE_Customer_SKU_Changes__c  ts{get;set;}
        public ID SKUID{get;set;}        
        public String SKU{get;set;}                                        
        public String DESCRP{get;set;}
        public String CHANGETYP{get;set;}
        public Decimal CURRPRICE{get;set;}
        public Decimal APPPRICE{get;set;}                        
        public Decimal PROPPRICE{get;set;}
        public String COMMENTS{get;set;}
        public Decimal REVIMPACT{get;set;}
        public Decimal PREVIMPACT{get;set;}
        public Decimal TOTIMPACT{get;set;}
        public String CUSTNAME{get;set;}
        public String JS_CUSTNAME{get;set;}
        public String REPNAME{get;set;}
        public Boolean CHANGERED{get;set;}
        public boolean linkvisible {get;set;}
        public boolean isSelected {get;set;}
                  
    }
    
    public void clickFunction(){
        //On click funtionality to rerender the SKU table - pulling out only related SKUs
        counter = 0;
        SKUtot = 0;
        skuList.clear();
        //clsSKUListTable.clear();
        dueFilter = 'all';
        lCustomerCoreChanges = new List<Ace_Customer_Core_Changes__c>();
        lCustomerCoreChanges = [Select id from Ace_Customer_Core_Changes__c where ACE_Customer_Price_Changes__c =: passthruCustID];
        sIDs = new Set<ID>();
        for(Ace_Customer_Core_Changes__c l: lCustomerCoreChanges){
            sIDs.add(l.id);
        }
        
        SKUtot = [select count() from Ace_Customer_SKU_Changes__c 
                   where Ace_Customer_Core_Changes__c in: sIDs  AND Approval_status__c = 'Pending'];
                   
        generateSKU();             
    }
    
    public void generateSKU(){                                        
        
        TotImpact = 0.00;    
        RevImpact = 0.00;
        PrevImpact = 0.00;        
          
        if(dueFilter == 'PastDue'){
            clsSKUListTable.clear();                
            system.debug('>>>>>>>>'+dueFilter );   
            if(!Test.isRunningTest()){                                                 
            skuList = [select id,SKU__c,Proposed_Price__c, Current_Sell_Price__c,price_Changes_Type__c,Price_Exception_Revenue_Impact__c,
                        Previous_Exception_Impact__c, Total_Impact__c, Approved_Proposed_Price__c,//LastModifiedBy,
                       Ace_Customer_Core_Changes__r.Ace_Customer_Price_Changes__r.Sales_Price_Change_Effective_Date_Rep__c,
                       Ace_Customer_Core_Changes__r.Ace_Customer_Price_Changes__r.Sales_Price_Change_Effective_Date_Approv__c,
                       Ace_Customer_Core_Changes__r.Ace_Customer_Price_Changes__r.Customer__r.name,
                       Ace_Customer_Core_Changes__r.Ace_Customer_Price_Changes__r.Customer__r.Owner.Name,
                       Ace_Customer_Core_Changes__r.Ace_Customer_Price_Changes__r.id,
                       Additional_Comments__c,SKU_Description__c, name,
                       L3_Mgr_AppReject_Time_c__c,L2_Mgr_AppReject_Time_c__c,L1_Mgr_AppReject_Time_c__c,
                       L1_Mgr_Approval_Start_Date__c,L2_Mgr_Approval_Start_Date__c,L3_Mgr_Approval_Start_Date__c,
                       DSM__c,RSD__c,VP__c                    
                       from Ace_Customer_SKU_Changes__c 
                       where Ace_Customer_Core_Changes__c in: sIDs  AND Approval_status__c = 'Pending'  and id in:SKUProcessList2                     
                       limit 10 offset :counter];                                      
            }
            else{
            skuList = [select id,SKU__c,Proposed_Price__c, Current_Sell_Price__c,price_Changes_Type__c,Price_Exception_Revenue_Impact__c,
                        Previous_Exception_Impact__c, Total_Impact__c, Approved_Proposed_Price__c,//LastModifiedBy,
                       Ace_Customer_Core_Changes__r.Ace_Customer_Price_Changes__r.Sales_Price_Change_Effective_Date_Rep__c,
                       Ace_Customer_Core_Changes__r.Ace_Customer_Price_Changes__r.Sales_Price_Change_Effective_Date_Approv__c,
                       Ace_Customer_Core_Changes__r.Ace_Customer_Price_Changes__r.Customer__r.name,
                       Ace_Customer_Core_Changes__r.Ace_Customer_Price_Changes__r.Customer__r.Owner.Name,
                       Ace_Customer_Core_Changes__r.Ace_Customer_Price_Changes__r.id,
                       Additional_Comments__c,SKU_Description__c, name,
                       L3_Mgr_AppReject_Time_c__c,L2_Mgr_AppReject_Time_c__c,L1_Mgr_AppReject_Time_c__c,
                       L1_Mgr_Approval_Start_Date__c,L2_Mgr_Approval_Start_Date__c,L3_Mgr_Approval_Start_Date__c,
                       DSM__c,RSD__c,VP__c                    
                       from Ace_Customer_SKU_Changes__c   
                       limit 10 offset :counter];                                      
            }
            for(Ace_Customer_SKU_Changes__c s:skuList){
                skuListTable skl = new skuListTable();
                skl.SKUID = s.id;
                skl.ts = s;
                skl.SKU  = s.SKU__c;
                skl.linkvisible = true;
                if (customerswithDTException.containskey(s.Ace_Customer_Core_Changes__r.Ace_Customer_Price_Changes__r.id))
                 skl.linkvisible = false;
                skl.DESCRP = s.SKU_Description__c;
                skl.CUSTNAME= s.Ace_Customer_Core_Changes__r.Ace_Customer_Price_Changes__r.Customer__r.name;
                skl.JS_CUSTNAME= s.Ace_Customer_Core_Changes__r.Ace_Customer_Price_Changes__r.Customer__r.name.replace('\'','%');
                skl.REPNAME= s.Ace_Customer_Core_Changes__r.Ace_Customer_Price_Changes__r.Customer__r.Owner.Name;
            
                if(s.price_Changes_Type__c == 'C')
                    skl.CHANGETYP = 'Cost';
                else if(s.price_Changes_Type__c == 'M')
                    skl.CHANGETYP = 'Margin';
                else if(s.price_Changes_Type__c == 'A')
                    skl.CHANGETYP = 'Alternate';
                else if(s.price_Changes_Type__c == 'D')
                    skl.CHANGETYP = 'Discontinued';
                    
                // skl.CHANGETYP = s.price_Changes_Type__c;
                skl.CURRPRICE = s.Current_Sell_Price__c;
                skl.APPPRICE = s.Approved_Proposed_Price__c;
                skl.PROPPRICE = s.Proposed_Price__c;
                skl.COMMENTS = s.Additional_Comments__c;
                
                if(s.Price_Exception_Revenue_Impact__c != null)
                    skl.REVIMPACT = s.Price_Exception_Revenue_Impact__c;
                else
                    skl.REVIMPACT = 0.00;
                    
                if(s.Previous_Exception_Impact__c != null)
                    skl.PREVIMPACT = s.Previous_Exception_Impact__c;
                else
                    skl.PREVIMPACT = 0.00;
                    
                //skl.PREVIMPACT = s.Previous_Exception_Impact__c;
                if(s.Total_Impact__c != null)
                    skl.TOTIMPACT = s.Total_Impact__c;
                else
                    skl.TOTIMPACT = 0.00;
                //skl.TOTIMPACT = s.Total_Impact__c;
                
                skl.CHANGERED = false;
               if(s.VP__c == UserInfo.getUserID() && s.L3_Mgr_Approval_Start_Date__c.getTime() != null 
               && (Integer.valueOf((system.Now().getTime() - s.L3_Mgr_Approval_Start_Date__c.getTime())/(1000*60*60*24))) >= ApprovalDays){
                    skl.CHANGERED = true;
                    clsSKUListTable.add(skl);
               }
               else if(s.RSD__c == UserInfo.getUserID() && s.L2_Mgr_Approval_Start_Date__c.getTime() != null 
               && (Integer.valueOf((system.Now().getTime() - s.L2_Mgr_Approval_Start_Date__c.getTime())/(1000*60*60*24))) >= ApprovalDays){
                    skl.CHANGERED = true;
                    clsSKUListTable.add(skl);
               }
               else if(s.DSM__c == UserInfo.getUserID() && s.L1_Mgr_Approval_Start_Date__c.getTime() != null 
               && (Integer.valueOf((system.Now().getTime() - s.L1_Mgr_Approval_Start_Date__c.getTime())/(1000*60*60*24))) >= ApprovalDays){
                    skl.CHANGERED = true;
                    clsSKUListTable.add(skl);
               }
               //else{
                  // clsSKUListTable.add(skl);
               //}
            
            }
                       
        }
        else{
            clsSKUListTable.clear();
            system.debug('<<<<<<<<<'+dueFilter );
            skuList = [select id,SKU__c,Proposed_Price__c, Current_Sell_Price__c,price_Changes_Type__c,Price_Exception_Revenue_Impact__c,
                        Previous_Exception_Impact__c, Total_Impact__c, Approved_Proposed_Price__c,//LastModifiedBy,
                       Ace_Customer_Core_Changes__r.Ace_Customer_Price_Changes__r.Sales_Price_Change_Effective_Date_Rep__c,
                       Ace_Customer_Core_Changes__r.Ace_Customer_Price_Changes__r.Sales_Price_Change_Effective_Date_Approv__c,
                       Ace_Customer_Core_Changes__r.Ace_Customer_Price_Changes__r.Customer__r.name,
                       Ace_Customer_Core_Changes__r.Ace_Customer_Price_Changes__r.Customer__r.Owner.Name,
                       Ace_Customer_Core_Changes__r.Ace_Customer_Price_Changes__r.id,name,
                       Additional_Comments__c,SKU_Description__c, 
                       L3_Mgr_AppReject_Time_c__c,L2_Mgr_AppReject_Time_c__c,L1_Mgr_AppReject_Time_c__c,
                       L1_Mgr_Approval_Start_Date__c,L2_Mgr_Approval_Start_Date__c,L3_Mgr_Approval_Start_Date__c,
                       DSM__c,RSD__c,VP__c                    
                       from Ace_Customer_SKU_Changes__c 
                       where Ace_Customer_Core_Changes__c in: sIDs  AND Approval_status__c = 'Pending' and id in:SKUProcessList2
                       limit 10 offset :counter];
                       
            for(Ace_Customer_SKU_Changes__c s:skuList){
                skuListTable skl = new skuListTable();
                skl.SKUID = s.id;
                skl.ts = s;
                skl.SKU  = s.SKU__c;
                skl.DESCRP = s.SKU_Description__c;
                
                skl.linkvisible = true;
                if (customerswithDTException.containskey(s.Ace_Customer_Core_Changes__r.Ace_Customer_Price_Changes__r.id))
                 skl.linkvisible = false;
                
                skl.CUSTNAME= s.Ace_Customer_Core_Changes__r.Ace_Customer_Price_Changes__r.Customer__r.name;
                skl.JS_CUSTNAME= s.Ace_Customer_Core_Changes__r.Ace_Customer_Price_Changes__r.Customer__r.name.replace('\'','%');
                skl.REPNAME= s.Ace_Customer_Core_Changes__r.Ace_Customer_Price_Changes__r.Customer__r.Owner.Name;
                
                if(s.price_Changes_Type__c == 'C')
                    skl.CHANGETYP = 'Cost';
                else if(s.price_Changes_Type__c == 'M')
                    skl.CHANGETYP = 'Margin';
                else if(s.price_Changes_Type__c == 'A')
                    skl.CHANGETYP = 'Alternate';
                else if(s.price_Changes_Type__c == 'D')
                    skl.CHANGETYP = 'Discontinued';
                // skl.CHANGETYP = s.price_Changes_Type__c;
                skl.CURRPRICE = s.Current_Sell_Price__c;
                skl.APPPRICE = s.Approved_Proposed_Price__c;
                skl.PROPPRICE = s.Proposed_Price__c;
                skl.COMMENTS = s.Additional_Comments__c;
                skl.REVIMPACT = s.Price_Exception_Revenue_Impact__c;
                skl.PREVIMPACT = s.Previous_Exception_Impact__c;
                skl.TOTIMPACT = s.Total_Impact__c;
                
                skl.CHANGERED = false;
               
               if(s.L3_Mgr_Approval_Start_Date__c != null)
               { 
               if(s.VP__c == UserInfo.getUserID() && s.L3_Mgr_Approval_Start_Date__c.getTime() != null 
               && (Integer.valueOf((system.Now().getTime() - s.L3_Mgr_Approval_Start_Date__c.getTime())/(1000*60*60*24))) >= ApprovalDays){
                    skl.CHANGERED = true;
               }
               }
               else if(s.L2_Mgr_Approval_Start_Date__c != null)
               {
               if(s.RSD__c == UserInfo.getUserID() && s.L2_Mgr_Approval_Start_Date__c.getTime() != null 
               && (Integer.valueOf((system.Now().getTime() - s.L2_Mgr_Approval_Start_Date__c.getTime())/(1000*60*60*24))) >= ApprovalDays){
                    skl.CHANGERED = true;
               }}
               
               else if(s.L1_Mgr_Approval_Start_Date__c != null)
               { 
               if(s.DSM__c == UserInfo.getUserID() && s.L1_Mgr_Approval_Start_Date__c.getTime() != null 
               && (Integer.valueOf((system.Now().getTime() - s.L1_Mgr_Approval_Start_Date__c.getTime())/(1000*60*60*24))) >= ApprovalDays){
                    skl.CHANGERED = true;
               }}
                clsSKUListTable.add(skl);
            
            }
        }
        skuCustName =  skuCustName ;  
        skuCustNumber =  skuCustNumber ;  
                            
        if(clsSKUListTable.size()>0){
        //if(skuList.size() > 0){
             renderSKU = true;
             for(Ace_Customer_SKU_Changes__c sk: skuList){                            
                    if (sk.Total_Impact__c != null)
                     TotImpact = TotImpact + sk.Total_Impact__c;
                    if (sk.Price_Exception_Revenue_Impact__c != null) 
                     RevImpact = RevImpact + sk.Price_Exception_Revenue_Impact__c;
                    if (sk.Previous_Exception_Impact__c != null) 
                     PrevImpact = PrevImpact + sk.Previous_Exception_Impact__c;
             }                                       
        }
        else{
            renderSKU = false;
            outputLabelSKU = 'There are no Price Exceptions pending Approval for the selected customer.';
        }
        //}
    }
    
    public void nextPage(){
        counter = counter+list_size;
        disablePriceButton = true;
        generateSKU();                       
    }
    public void prevPage(){
        counter = counter-list_size;
        disablePriceButton = true;
        generateSKU();        
    }
    
    public Boolean getDisablePrevious() {     
      if (counter>0) return true; else return false;
    }
    public Boolean getDisableNext() { 
      if (counter + list_size < SKUtot) return true; else return false;
   }
   
   public void dueFilterLogic(){  
       generateSKU();
       system.debug('^^^^^^'+dueFilter );
   }
    
    public void approvePriceWithChange()
    {
        System.debug('>>>>>>>>>>>>>. type '+ type);
        System.debug('>>>>>>>>>>>>>. modify price '+ priceVal);
        
        passThruId = custid;
        system.debug('%%%%%'+passThruId);
        
        /* if (custPriceMap.get(passThruId) == '' || custPriceMap.get(passThruId) == null){
            ModPropPrice = null; 
            system.debug('%%%%%'+nullCheck );
            nullCheck = true;
        }    
        else{    
            ModPropPrice = decimal.valueof(custPriceMap.get(passThruId));
            system.debug('%%%%%'+nullCheck );
            nullCheck = false;
        }  
        */
        if (priceVal == null || priceVal == ''){
            ModPropPrice = null; 
            system.debug('%%%%%1-'+nullCheck );
            nullCheck = true;
        }    
        else{    
            ModPropPrice = decimal.valueof(priceVal);
            system.debug('%%%%%2-'+nullCheck );
            nullCheck = false;
        }  
          
        system.debug('%%%%%ModPropPrice -'+ModPropPrice );
        //passThruId=ApexPages.currentPage().getParameters().get('passthru');
        Ace_Customer_SKU_Changes__c ls = new Ace_Customer_SKU_Changes__c();
        if(passThruId!= null){
            ls = [select id,HomePage_Approval_History__c,
                         Approved_Proposed_Price__c,
                         Current_Sell_Price__c,
                         SKU__c,Proposed_Price__c,
                         Item_3_Month_Qty__c,
                         Item_6_Month_Qty__c,
                         Item_9_Month_Qty__c,
                         Item_12_Month_Qty__c, Reporting_Price_Modified_By_Approver__c                         
                         from Ace_Customer_SKU_Changes__c where id=: passThruId];
            
            if(ModPropPrice != 0.00 && ModPropPrice != 0 && ModPropPrice != null) {
                if(ModPropPrice >= ls.Current_Sell_Price__c && ModPropPrice <= ls.Approved_Proposed_Price__c){ //need to verify with deepak.
                    Audit_History__c AH = new Audit_History__c();
                    AH.Ace_Customer_SKU_Changes__c = ls.id;
                    AH.Old_Approval_Status__c = 'A_Pending';
                    AH.New_Approval_Status__c = 'Modification';
                    AH.New_User_Proposed_Price__c = ModPropPrice;
                    AH.SKU__c = ls.SKU__c;
                    AH.Old_User_Proposed_Price__c = ls.Proposed_Price__c;
                    
                    ls.Proposed_Price__c = ModPropPrice;
                    ls.Reporting_Price_Modified_By_Approver__c = true;                
                    Decimal annualUsage; 
                    Decimal updateRevImpact;
                    if (ls.Item_12_Month_Qty__c != null) 
                      annualUsage = ls.Item_12_Month_Qty__c;
                    else if (ls.Item_9_Month_Qty__c != null)
                      annualUsage = ls.Item_9_Month_Qty__c * (4/3);
                    else if (ls.Item_6_Month_Qty__c != null)
                      annualUsage = ls.Item_6_Month_Qty__c * 2;
                    else if (ls.Item_3_Month_Qty__c != null)
                      annualUsage = ls.Item_3_Month_Qty__c * 4;
                    else
                      annualUsage = 0;   
                    if(annualUsage != null && ls.Approved_Proposed_Price__c != null)
                       updateRevImpact = (annualUsage*(ModPropPrice-ls.Approved_Proposed_Price__c));
                    if (updateRevImpact != null)    
                        ls.Price_Exception_Revenue_Impact__c = updateRevImpact;  
                    
                    
                    insert AH;         
                }
            }   
            update ls;          
                                 
        }
                   
    }
    
    public void updateDate() {
        system.debug('Made A Call!'+passthruCustID + '::' + ModDate);
        
    }
    
    public void approveDateWithChange()
    {
       // system.debug('%%%%%'+custDateMap.get(passthruCustID));    
         
        passthruCustID=ApexPages.currentPage().getParameters().get('custId2');
        passthruCustID = CustID;
        
        /* if (custDateMap.get(passthruCustID) == '' || custDateMap.get(passthruCustID) == null)
        {
          ModDate = null;  
          
          nullCheck = true; 
          system.debug('%%%%%'+nullCheck );     
        } else{
          ModDate = date.parse(custDateMap.get(passthruCustID));
          
          nullCheck = false;
          system.debug('%%%%%'+nullCheck );
        }
        */
        
        if(dateval == '' || dateVal == null)
        {
          ModDate = null;  
          nullCheck = true; 
          system.debug('%%%%%'+nullCheck );     
        } else{
          ModDate = date.parse(dateVal);
          
          nullCheck = false;
          system.debug('%%%%%'+nullCheck );
        }
        
        system.debug('%%%%%'+ModDate);
        
        Ace_Customer_Price_Changes__c ds = new Ace_Customer_Price_Changes__c();
        if(passthruCustID!= null){
            ds = [select id,
                  Sales_Price_Change_Effective_Date_Approv__c,
                  Sales_Price_Change_Effective_Date_Rep__c,
                  Total_Spend_Impact_12_Month__c, Reporting_Date_Modified_By_Approver__c 
                     from Ace_Customer_Price_Changes__c where id=: passthruCustID];
                                   
            if(ModDate!= null){
                system.debug('@@@@@@'+ModDate);
                
             /*   Audit_History__c AH = new Audit_History__c();
                AH.Ace_Customer_Price_Changes__c = ds.id;
                AH.Old_Approval_Status__c = 'A_Pending';
                AH.New_Approval_Status__c = 'Modification';
                AH.NewSales_Price_Change_Effective_Date_Rep__c = ModDate;                
                //AH.SKU__c = ds.SKU__c;
                AH.Old_SalesPrice_Change_Effective_Date_Rep__c = ds.Sales_Price_Change_Effective_Date_Rep__c;
              */  
                ds.Sales_Price_Change_Effective_Date_Rep__c = ModDate;
                ds.Reporting_Date_Modified_By_Approver__c = true;
                system.debug('@@@@@@'+ds.Sales_Price_Change_Effective_Date_Rep__c);
                Decimal revImpact = 0;
                //Decimal revenueImpact =  
                system.debug('@@@@@@Total_Spend_Impact_12_Month__c'+ds.Total_Spend_Impact_12_Month__c);
                if (ds.Total_Spend_Impact_12_Month__c != null && ds.Sales_Price_Change_Effective_Date_Rep__c != null && ds.Sales_Price_Change_Effective_Date_Approv__c != null) {
                   Decimal totaldays = ds.Sales_Price_Change_Effective_Date_Rep__c.daysBetween(ds.Sales_Price_Change_Effective_Date_Approv__c);
                   revImpact = ds.Total_Spend_Impact_12_Month__c/365 * totaldays;
                     revImpact = revImpact.setScale(2);
                     ds.OD_Revenue_Impact__c = revImpact;                                
                }
                
                
               // insert AH;
                
            update ds;
                                
            }
          
                
    }
    
    
}
 public void disablebtn() {
     Boolean disableDateButtonBool = true;
     Boolean disablePriceButtonBool = true;
     Integer dateCount = 0;
     for(Integer i = 0; i < UIList1.size(); i++)
     {
         if(UIList1[i].isSelected == true)
         {
             disableDateButtonBool = false;
             dateCount++;
         }
     }
     
     //Code to disable boxes if needed.
     /*for(Integer i = 0; i < UIList1.size(); i++)
     {
         if(dateCount >= checkBoxDateLimit)
         {
             if(UIList1[i].isSelected == false)
             {
                 UIList1[i].dateCheckboxDisabled = true;
             }
         }
         else
         {
             UIList1[i].dateCheckboxDisabled = false;
         }
         
     }*/
     
     
     for(Integer i = 0; i < clsSKUListTable.size(); i++)
     {
         if(clsSKUListTable[i].isSelected == true)
         {
             disablePriceButtonBool = false;
         }
     }
     
     
     disableDateButton=disableDateButtonBool;
     disablePriceButton=disablePriceButtonBool;
   }
    
    
   
    
}