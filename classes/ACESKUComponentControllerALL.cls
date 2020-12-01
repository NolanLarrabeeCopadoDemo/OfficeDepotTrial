public class ACESKUComponentControllerALL{                 //MM ROM Item A
    public String ocIds;
    public Integer counter = 0;
    //00826589 
    public Integer List_size = 40; 
    public Integer total_size{get;set;}
    public String oType{get;set;}
    public String aId {get;set;}
    public String DataRange{get;set;}
    public Decimal Customer_12_spend{get;set;}
    public Decimal Customer_9_spend{get;set;}
    public Decimal Customer_6_spend{get;set;}
    public Decimal Customer_3_spend{get;set;}
    public List<CustomerSKUDataResponse> oCustSkuDataResponse {get;set;}
    public Ace_Customer_Price_Changes__c aceCustPriceChanges_np {get;set;}
    public Decimal Customer_Spend{get;set;}
    public String Customer_Spend_label{get;set;}
    public boolean showPageBlockTable {get;set;}
    public Decimal Annual_Usage{get;set;}
    public Decimal Annual_SKU_Spend{get;set;}
    public Decimal Annual_Spend_Change_Amt{get;set;}
    public Decimal Total_Spend_Impact{get;set;}
    public Decimal Total_SRM_Impact{get;set;}
    public Decimal Per_change_Amount{get;set;}
    public Integer NoOfCores {get;set;} 
    Public String callType {get;set;}
    public Boolean renderCore{get;set;}
    public String dataPeriod {get;set;}
    public String passThruSkuId{get;set;}
    public Decimal altchangePrice{get;set;}
    public String passThruBatchId{get;set;}
    public Boolean passThruDelSKU{get;set;}
    public String osalesforceSKUID{get;set;}
    public Decimal Total_New_Price{get;set;}
    public Decimal Total_Current_Price{get;set;}
    public String passThruSkuId1{get;set;}
    public String SKUSearch{get;set;}
    
    //for Sort functionality
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
    
    public string view_all{get;set;}  
    
    
    public void setOcIds (String s) {
        system.debug('>>>>>>>>>>>>>>>>>s:'+s);
        String[] callvalues = s.split(';');       
        aId = callvalues[0].substring(0,15);
        callType = callValues[1];
        if(callType=='CustomerPricing_np')
            renderCore = true;
        else
            renderCore = false;
        
       if(aId != null){
            system.debug('%%%%%%%%'+DataRange);
            system.debug('%%%%%%%%'+aId);
            //////00826578
            ///if( SKUSearch  ==null)
            generateDataforRange(DataRange);
        }else{
             ApexPages.addmessage(new ApexPages.message(ApexPages.severity.WARNING,'Id is invalid--')); 
       }              
    }
    
    public String getOcIds() {
        return ocIds;
    }    
    
    public Boolean CheckStdCoreUser(){
        List<GroupMember> grpMemList = [Select id,UserOrGroupId From GroupMember Where group.name='ACE Standard Group'];
        system.debug('grpMemList >>>>>>>>>>>>>>>>>>'+grpMemList );
        Set<ID> UserSet = new Set<ID>();
        
        for(GroupMember GM :grpMemList){
            UserSet.add(gm.UserOrGroupId);
        }
        system.debug('UserSet>>>>>'+UserSet+'>>>>>UserInfo.getUserId()>>>>>>'+UserInfo.getUserId());
        if(UserSet.contains(UserInfo.getUserId()))
            return true;
        else 
            return False;
    }   
    
//constructor
    public ACESKUComponentControllerALL(){
        view_all = 'false';
        Customer_Spend_label = 'Customer Annual Spend';
        counter = 0;
        showPageBlockTable = false;
        Total_SRM_Impact = 0;
        Total_New_Price = 0;
        Total_Current_Price = 0;
        DataRange = '12-Months';// Component Defaults to 12-Months             
        //for sort        
                tabAsc = true;
                tabAsc_notify = true;
                tabAsc_noreq = true;
                sortDirection = 'ASC';
                sortDirection_notify = 'ASC';
                sortDirection_noreq = 'ASC';
                
                getFieldName = 'SKUNum';
                getFieldName_notify = 'SKUNum';
                getFieldName_noreq = 'SKUNum';
                fieldName = 'SKU__c';
                fieldName_notify = 'SKU__c';
                fieldName_noreq = 'SKU__c';
                
                view_all = System.currentPageReference().getParameters().get('view_all');
    }
    public PageReference calcRange(){
        generateDataforRange(DataRange);
        return null;
    }   
    /*
    public PageReference gotoSkuException(){
        String urlID = ApexPages.currentPage().getParameters().get('id');
        system.debug('@@@@@@@@@@@@@@@@'+passThruDelSKU);
        if(passThruDelSKU){ // loop added by guha for deleted sku with alt - the redirected page should have only few options visible on ui.
            system.debug('@@@@@@@@@@@@@@@@'+urlID);
            PageReference pr = new PageReference('/apex/SKU_Execption?skuID='+passThruSkuId+'&custName='+passThruBatchId+'&ID='+urlID+'&period='+DataRange+'&DelSKUALT='+passThruDelSKU);       
            pr.setRedirect(true);
            return pr;
        }
        else{
            system.debug('@@@@@@@@@@@@@@@@'+urlID);
            PageReference pr = new PageReference('/apex/SKU_Execption?skuID='+passThruSkuId+'&custName='+passThruBatchId+'&ID='+urlID+'&period='+DataRange);       
            pr.setRedirect(true);
            return pr;
        }
    }
    */    
        public PageReference gotoSkuException(){
        String urlID = ApexPages.currentPage().getParameters().get('id');
        system.debug('@@@@@@@@@@@@@@@@'+passThruDelSKU+' :');
        if(passThruDelSKU){ // loop added by guha for deleted sku with alt - the redirected page should have only few options visible on ui.
            system.debug('@@@@@@@@@@@@@@@@'+urlID);
            PageReference pr = new PageReference('/apex/SKU_Exception_Price?skuID='+passThruSkuId+'&custName='+passThruBatchId+'&ID='+urlID+'&period='+DataRange+'&DelSKUALT='+passThruDelSKU+'&viewall='+'true');       
            pr.setRedirect(true);
            return pr;
        }
        else{
            system.debug('@@@@@@@@@@@@@@@@'+urlID);
            PageReference pr = new PageReference('/apex/SKU_Exception_Price?skuID='+passThruSkuId+'&custName='+passThruBatchId+'&ID='+urlID+'&period='+DataRange+'&viewall='+'true');       
            pr.setRedirect(true);
            return pr;
        }
        }    
    
        public void generateDataforRange(String range){
        oCustSkuDataResponse = new List<CustomerSKUDataResponse>();
            system.debug('>>>>>>>>>>>>>>>>>aId:'+aId);
        List<Ace_Customer_SKU_Changes__c > csku = getskusforCustomer(aId);        
            
        if(range == '12-Months'){
            if (csku.size() >0) {
            Customer_Spend = csku[0].Ace_Customer_Core_Changes__r.Ace_Customer_Price_Changes__r.Customer__r.Rolling_12_month_sales__c; 
            Customer_Spend_label = 'Customer Annual Spend';
            } else{
            Customer_Spend = 0;
            Customer_Spend_label = 'Customer Annual Spend';
            }
        }
        if(range == '9-Months'){
            if (csku.size() >0) {
            Customer_Spend = csku[0].Ace_Customer_Core_Changes__r.Ace_Customer_Price_Changes__r.Customer__r.Rolling_9_month_sales__c;
            Customer_Spend_label = 'Customer 9-Months Spend';
            } else{
            Customer_Spend = 0;
            Customer_Spend_label = 'Customer 9-Months Spend';
            }
        }
        if(range == '6-Months'){
            if (csku.size() >0) {
            Customer_Spend = csku[0].Ace_Customer_Core_Changes__r.Ace_Customer_Price_Changes__r.Customer__r.Rolling_6_month_sales__c;
            Customer_Spend_label = 'Customer 6-Months Spend';
            } else{
            Customer_Spend = 0;
            Customer_Spend_label = 'Customer 6-Months Spend';
            }
        }
        if(range == '3-Months'){
            if (csku.size() >0) {
            Customer_Spend = csku[0].Ace_Customer_Core_Changes__r.Ace_Customer_Price_Changes__r.Customer__r.Rolling_3_month_sales__c;
            Customer_Spend_label = 'Customer 3-Months Spend';
            } else{
            Customer_Spend = 0;
            Customer_Spend_label = 'Customer 3-Months Spend';
            }            
        }        
        
        if(csku.size()>0){
         showPageBlockTable = true;// This is to render the table
         Total_SRM_Impact = 0;
         Total_New_Price = 0;
         Total_Current_Price = 0;
        for(Ace_Customer_SKU_Changes__c acsc : csku){    
            
                   CustomerSKUDataResponse c = new CustomerSKUDataResponse();
                        c.SalesforceSKUID = acsc.id;
                        c.SKUID = acsc.SKU__c;
                        c.CORE=acsc.Ace_Customer_Core_Changes__r.name.replace('CL-','');
                        if(c.CORE.contains('-'))
                        c.CORE=c.CORE.replace('-','');

                        c.skuLastDate = acsc.SKU_Last_Update__c;
                        c.COREID = acsc.Ace_Customer_Core_Changes__r.name;
                        System.debug('&&&&&&&&&&&& CoreId'+c.COREID);
                        c.COREIDLINK = acsc.Ace_Customer_Core_Changes__c;
                        c.VENDOR  = acsc.Core_s_SKU_Vendor_Name__c;
                        c.CURRENTPRICE = acsc.Current_Sell_Price__c;
                        if (acsc.Current_Sell_Price__c != null)
                          Total_Current_Price = Total_Current_Price + acsc.Current_Sell_Price__c;
                        c.NEWPRICE = acsc.Approved_Proposed_Price__c;
                        if (acsc.Approved_Proposed_Price__c != null)
                          Total_New_Price = Total_New_Price + acsc.Approved_Proposed_Price__c;
                         
                        c.CHANGEAMOUNT = acsc.Change_Amount__c;
                        c.CHANGEAMOUTPER = acsc.ChangeAmount_per__c;
                        c.SRMIMPACT = acsc.SRM_Differential__c;
                        if (acsc.SRM_Differential__c != null) 
                          Total_SRM_Impact = Total_SRM_Impact+acsc.SRM_Differential__c;
                        c.PriceChangesType = acsc.Price_Changes_Type__c;
                        
                        if(acsc.price_Changes_Type__c != null)
                            {
                                if(acsc.price_Changes_Type__c == 'C')
                                    c.ChangeType = 'Cost';
                                else if(acsc.price_Changes_Type__c == 'M' && acsc.Margin_Play__c == 'S'){
                                    c.ChangeType = 'Margin Swap';
                                }
                                else if(acsc.price_Changes_Type__c == 'M' && acsc.Margin_Play__c == 'A'){
                                    c.ChangeType = 'Assortment Swap';
                                }
                                else if(acsc.price_Changes_Type__c == 'M' && acsc.Margin_Play__c == 'L'){
                                    c.ChangeType = 'Margin Lift';
                                }    
                                else if(acsc.price_Changes_Type__c == 'A')
                                    c.ChangeType = 'Alternate';
                                else if(acsc.price_Changes_Type__c == 'D')
                                    c.ChangeType = 'Discontinued';
                            }    
                        
                        c.BATCHID = acsc.batchId__c;
                        c.status=acsc.status__C;
                        c.ISALT =   acsc.Alt_SKU__c; //added by guha
                        c.ISLOCK = acsc.Record_Locked__c;//added by guha
                        c.skuDescription = acsc.sku_description__c;
                        c.STDCore=false;
                        
                        c.AltReplace=false;
                        if(acsc.SKU_Alt__c != null && acsc.Alternate_Chosen_Flag__c == true)
                        c.AltReplace =true;
                                                                        
                        if (acsc.SKU_Alt__c != null && acsc.Alternate_Chosen_Flag__c == false){
                         c.AltExists = true;    
                         c.SKUALT =acsc.SKU_Alt__c;    
                         
                         System.debug('&&&&&&&&before'+acsc.SKU_Alt__c+acsc.Ace_Customer_Core_Changes__c + acsc.Ace_Customer_Core_Changes__r.ACE_Customer_Price_Changes__r.id );
                         try{
                             Ace_Customer_SKU_Changes__c  SKU_ALT = [select id,QPU__c,Proposed_SRM_with_Cap1__c,Proposed_Price_with_Cap__c,
                             Current_Sell_Price__c,sku_description__c,Ace_Customer_Core_Changes__r.ACE_Customer_Price_Changes__r.Owning_Customer_ID__c ,                                                      
                             Cap_Amount__c ,Approved_Proposed_Price__c ,UOM__c 
                             from Ace_Customer_SKU_Changes__c where SKU__c=:acsc.SKU_Alt__c and 
                             Ace_Customer_Core_Changes__c= :acsc.Ace_Customer_Core_Changes__c and 
                             Ace_Customer_Core_Changes__r.ACE_Customer_Price_Changes__r.id = :acsc.Ace_Customer_Core_Changes__r.ACE_Customer_Price_Changes__r.id LIMIT 1];     
                             if(SKU_ALT != null) {
                                 if(SKU_ALT.Ace_Customer_Core_Changes__r.ACE_Customer_Price_Changes__r.Owning_Customer_ID__c.contains('99999ACE'))
                                 c.STDCore = true;
                             c.SKUALTAPPPRICE =SKU_ALT.Approved_Proposed_Price__c  ;
                             c.SKUALTCAPAMOUNT =SKU_ALT.Cap_Amount__c ;
                             c.SKUALTPRICE = SKU_ALT.Proposed_Price_with_Cap__c;
                             c.skuAltDescription=sku_alt.sku_description__c;
                             //c.altQPU=' ';
                             //if(sku_alt.QPU__c!=null)
                             c.altQPU=sku_alt.QPU__c;
                             c.altUOM=sku_alt.UOM__c;
                             }
                             System.debug('&&&&&&&&after'+c.SKUALTPRICE );
                         }
                         catch (Exception e){}                  
                        }                      
                         
                        c.CHECKROLLING = false;
                        c.CHECKROLLINGNew = false;
                        c.CHECKROLLINGREVERT= false;
                        c.CHECKROLLINGALT=false;
                        
                        if (acsc.ace_customer_core_changes__r.ace_customer_price_changes__r.remedy_status__c != 'Pending' && !acsc.ace_customer_core_changes__r.ace_customer_price_changes__r.record_lock__c &&  !acsc.ace_customer_core_changes__r.ace_customer_price_changes__r.IsRemediation__c)
                        {                        
                        // c.CHECKROLLING = true;
                         if (acsc.Owning_Customer_Legal__c == 'T'){
                           c.CHECKROLLING = true;
                           c.CHECKROLLINGNEW = true;
                           c.CHECKROLLINGREVERT= true;
                           c.CHECKROLLINGALT=true;
                           }
                         else {
                              if(acsc.Ace_Customer_Core_Changes__r.Ace_Customer_Price_Changes__r.Customer__r.Rolling_12_month_sales__c != null){
                               //DataRange = '12-Months';
                                c.CHECKROLLINGNEW = true;
                                c.CHECKROLLINGREVERT= true;
                                c.CHECKROLLINGALT=true;

                                if(acsc.Ace_Customer_Core_Changes__r.Ace_Customer_Price_Changes__r.Customer__r.Rolling_12_month_sales__c >= 75000.00)
                                   c.CHECKROLLING = true;     
                                }                
                              else if(acsc.Ace_Customer_Core_Changes__r.Ace_Customer_Price_Changes__r.Customer__r.Rolling_9_month_sales__c != null){
                               //DataRange = '9-Months';
                               c.CHECKROLLINGNEW = true;
                               c.CHECKROLLINGREVERT= true;
                               c.CHECKROLLINGALT=true;

                               if(acsc.Ace_Customer_Core_Changes__r.Ace_Customer_Price_Changes__r.Customer__r.Rolling_9_month_sales__c*(4/3) >= 75000.00)
                                   c.CHECKROLLING = true;   
                               }
                              else if(acsc.Ace_Customer_Core_Changes__r.Ace_Customer_Price_Changes__r.Customer__r.Rolling_6_month_sales__c != null){
                               //DataRange = '6-Months';
                              c.CHECKROLLINGNEW = true;
                              c.CHECKROLLINGREVERT= true;
                              c.CHECKROLLINGALT=true;

                               if(acsc.Ace_Customer_Core_Changes__r.Ace_Customer_Price_Changes__r.Customer__r.Rolling_6_month_sales__c*2 >= 75000.00)
                                   c.CHECKROLLING = true;
                               }
                              else if(acsc.Ace_Customer_Core_Changes__r.Ace_Customer_Price_Changes__r.Customer__r.Rolling_3_month_sales__c != null){
                               //DataRange = '6-Months';
                               c.CHECKROLLINGREVERT= true;
                               c.CHECKROLLINGNEW = true;
                               c.CHECKROLLINGREVERT= true;
                               c.CHECKROLLINGALT=true;

                               if(acsc.Ace_Customer_Core_Changes__r.Ace_Customer_Price_Changes__r.Customer__r.Rolling_3_month_sales__c*4 >= 75000.00)
                                   c.CHECKROLLING = true;
                               }
                          }
                        }
                        system.debug('%%%%%%%CHECK 2'+c.CHECKROLLING+c.CHECKROLLINGNEW);                        
                        
                        if (acsc.Status__c == 'Deleted' && acsc.Price_Changes_Type__c != 'D') {
                            c.DELSKU = true; //identify that its a deleted sku - used for exception link rendering.                            
                            c.CHECKROLLING = false;
                            c.CHECKROLLINGNEW = false;

                        }   
                        else if(acsc.Status__c == 'Deleted'){   //loop added  by guha.
                            c.DELSKU = true; //identify that its a deleted sku - used for exception link rendering.                            
                            c.CHECKROLLING = false;
                            c.CHECKROLLINGNEW = false;

                            System.debug('Value of  AltExists' + c.AltExists);
                            if(c.AltExists != null && c.AltExists == true && acsc.Alternate_Chosen_Flag__c == false){
                                c.DELSKU = false;
                                c.DELSKUALT = true; //deleted sku which has an alternative
                                c.CHECKROLLING = true;
                                //c.CHECKROLLINGNEW = true;
                            }                             
                        }                         
                        
                        system.debug('%%%%%%%ROLLING'+c.CHECKROLLING);
                        system.debug('%%%%%%%CHECK 3'+c.CHECKROLLING+c.CHECKROLLINGNEW);                        

                        if (c.ISALT ){ 
                                c.CHECKROLLING = false;
                        }
                        
                        if (c.CHECKROLLING && acsc.price_changes_type__c == 'D' && acsc.sku_alt__c == null)
                          c.CHECKROLLING = false;
                         
                        c.APPROVALSTATUS = acsc.Approval_status__c; //Approval Status
                        
                        if(c.APPROVALSTATUS == 'Pending')
                            c.CHECKROLLING = false;
                        
                        /// this check should be last and it check for std core user group    
                        if((c.CHECKROLLING && acsc.ace_customer_core_changes__r.ace_customer_price_changes__r.customer__r.ownerid != userinfo.getuserid())){
                            if(CheckStdCoreUser()){                            
                                if(!acsc.ace_customer_core_changes__r.ace_customer_price_changes__r.Owning_Customer_ID__c.contains('99999ACE')){
                                    c.CHECKROLLING = false;  
                                    c.CHECKROLLINGNEW = false;
                                    c.CHECKROLLINGREVERT= false;
                                    c.CHECKROLLINGALT=false;                                  
                                }    
                            }
                            else{
                                c.CHECKROLLING = false; 
                                    c.CHECKROLLINGNEW = false;
                                    c.CHECKROLLINGREVERT= false;
                                    c.CHECKROLLINGALT=false;                                   
                            }
                        }
                        
                       //ROM-25 -- If remediation or compliance (price_not_calculated flag = true) WRF is created-- we should restrict the functonalities to salesRep.
                       if(acsc.ace_customer_core_changes__r.ace_customer_price_changes__r.IsRemediation__c || acsc.ace_customer_core_changes__r.ace_customer_price_changes__r.PRICE_NOT_CALCULATED__c){
                                c.CHECKROLLINGNEW = false;
                                c.CHECKROLLINGREVERT= false;
                                c.CHECKROLLINGALT=false;
                                c.CHECKROLLING = false;                                                         
                        }//end of if ROM-25                                                   
                    
                  system.debug('%%%%%%%CHECK 4'+c.CHECKROLLING+c.CHECKROLLINGNEW);                                                      
                            
                    // Data from the Range 12 Months
                    if(range == '12-Months'){     
                        if (acsc.Item_12_Month_Qty__c != null)                                        
                         c.ANNUALUSAGE = math.abs(acsc.Item_12_Month_Qty__c);
                        if (acsc.Item_12_Month_Sales__c != null)
                         c.ANNUALSKUSPEND = math.abs(acsc.Item_12_Month_Sales__c);
                        if (acsc.Total_Spend_Impact_12_Month__c != null)
                         c.ANNUALSPENDCHANGEAMT = math.abs(acsc.Total_Spend_Impact_12_Month__c);
                        
                        // Below line commented by Mohit
                        //if (Customer_Spend != null && Customer_Spend != 0 && acsc.Total_Spend_Impact_12_Month__c != null)
                        //    c.TOTALSPENDIMPACT = math.abs(((acsc.Total_Spend_Impact_12_Month__c/Customer_Spend)*100).setScale(2));
                        
                        // Added below condition by Mohit
                        if (acsc.Item_12_Month_Sales__c != null && acsc.Item_12_Month_Sales__c != 0 && acsc.Total_Spend_Impact_12_Month__c != null)
                            c.TOTALSPENDIMPACT = math.abs(((acsc.Total_Spend_Impact_12_Month__c/acsc.Item_12_Month_Sales__c)*100).setScale(2));
                        //Math.round
                                                
                        //Headers
                        dataPeriod  = 'Annual';
                    }

                    if(range == '9-Months'){
                        if (acsc.Item_9_Month_Qty__c != null)
                         c.ANNUALUSAGE = math.abs(acsc.Item_9_Month_Qty__c);
                        if (acsc.Item_9_Month_Sales__c != null)
                         c.ANNUALSKUSPEND = math.abs(acsc.Item_9_Month_Sales__c);
                        if (acsc.Total_Spend_Impact_9_Month__c != null)
                         c.ANNUALSPENDCHANGEAMT = math.abs(acsc.Total_Spend_Impact_9_Month__c);
                        
                        // Below line commented by Mohit
                        // if (Customer_Spend != null && Customer_Spend != 0 && acsc.Total_Spend_Impact_9_Month__c != null)
                        //  c.TOTALSPENDIMPACT = math.abs(((acsc.Total_Spend_Impact_9_Month__c/Customer_Spend)*100).setScale(2));
                        
                        // Added below condition by Mohit
                        if (acsc.Item_9_Month_Sales__c != null && acsc.Item_9_Month_Sales__c != 0 && acsc.Total_Spend_Impact_9_Month__c != null)
                            c.TOTALSPENDIMPACT = math.abs(((acsc.Total_Spend_Impact_9_Month__c/acsc.Item_9_Month_Sales__c)*100).setScale(2));
                                            
                    //Headers                        
                        dataPeriod  = '9-Months';                    
                    }
                    if(range == '6-Months'){
                        
                        if (acsc.Item_6_Month_Qty__c != null)
                         c.ANNUALUSAGE = math.abs(acsc.Item_6_Month_Qty__c);
                        if (acsc.Item_6_Month_Sales__c != null)
                         c.ANNUALSKUSPEND = math.abs(acsc.Item_6_Month_Sales__c);
                        if (acsc.Total_Spend_Impact_6_Month__c != null)
                         c.ANNUALSPENDCHANGEAMT = math.abs(acsc.Total_Spend_Impact_6_Month__c);
                       
                       // Below line commented by Mohit
                       // if (Customer_Spend != null && Customer_Spend != 0 && acsc.Total_Spend_Impact_6_Month__c != null)
                       //  c.TOTALSPENDIMPACT = math.abs(((acsc.Total_Spend_Impact_6_Month__c/Customer_Spend)*100).setScale(2));
                         
                         // Added below condition by Mohit
                         if (acsc.Item_6_Month_Sales__c != null && acsc.Item_6_Month_Sales__c != 0 && acsc.Total_Spend_Impact_6_Month__c != null)
                            c.TOTALSPENDIMPACT = math.abs(((acsc.Total_Spend_Impact_6_Month__c/acsc.Item_6_Month_Sales__c)*100).setScale(2));                         
                    //Headers 
                        dataPeriod  = '6-Months';
                    }
                    if(range == '3-Months'){                       
                        if (acsc.Item_3_Month_Qty__c != null)
                         c.ANNUALUSAGE = math.abs(acsc.Item_3_Month_Qty__c);
                        if (acsc.Item_3_Month_Sales__c != null)
                         c.ANNUALSKUSPEND = math.abs(acsc.Item_3_Month_Sales__c);
                        if (acsc.Total_Spend_Impact_3_Month__c != null)
                         c.ANNUALSPENDCHANGEAMT = math.abs(acsc.Total_Spend_Impact_3_Month__c);
                        
                        // Below line commented by Mohit
                        // if (Customer_Spend != null && Customer_Spend != 0)
                        //   c.TOTALSPENDIMPACT = math.abs(((acsc.Total_Spend_Impact_3_Month__c/Customer_Spend)*100).setScale(2));
                        
                        if (acsc.Item_3_Month_Sales__c != null && acsc.Item_3_Month_Sales__c != 0 && acsc.Total_Spend_Impact_3_Month__c != null)
                            c.TOTALSPENDIMPACT = math.abs(((acsc.Total_Spend_Impact_3_Month__c/acsc.Item_3_Month_Sales__c)*100).setScale(2));  
                       // Added below condition by Mohit   
                    //Headers
                        dataPeriod  = '3-Months';                   
                    }
                            
                oCustSkuDataResponse.add(c);
        }    
            generateSummaryRow(csku, range);
        }
           if (total_current_price != null && total_current_price != 0)
             Per_change_Amount = ((total_new_price-total_current_price)/total_current_price)*100;    
    }    
       public List<Ace_Customer_SKU_Changes__c > getskusforCustomer(Id Accid){
       
       String Status='InActive';
       String SKUSearch1= '%'+SKUSearch+'%';
       if(SKUSearch==null  ||  SKUSearch=='') 
       total_size = [select count() from Ace_Customer_SKU_Changes__c where Ace_Customer_Core_Changes__r.ACE_Customer_Price_Changes__c =:Accid 
       AND Status__c != 'InActive' AND Update_Timing_Action__c = 'T'];  //ROM-37 - to not showup in detail page for Update_Timing_Action__c = 'F'
       else
       total_size = [select count() from Ace_Customer_SKU_Changes__c where Ace_Customer_Core_Changes__r.ACE_Customer_Price_Changes__c =:Accid 
       AND Status__c != 'InActive' AND Update_Timing_Action__c = 'T' and sku__C like :SKUSearch1];  //ROM-37 - to not showup in detail page for Update_Timing_Action__c = 'F'
   
      system.debug('&&&&&&RErender Page'+SKUSearch);      
      
             String queryString ='select Id,SKU__c, Approval_status__c, Ace_Customer_Core_Changes__r.name, Ace_Customer_Core_Changes__c,Price_Changes_Type__c,Margin_Play__c, Core_s_SKU_Vendor_Name__c,Current_Sell_Price__c,'
                 +'Approved_Proposed_Price__c,New_List_Price__c,Proposed_Price__c, Change_Amount__c, ChangeAmount_per__c,SKU_Last_Update__c,Item_12_Month_Qty__c,Item_9_Month_Qty__c,Item_6_Month_Qty__c,Item_3_Month_Qty__c,Annual_Usage__c,'
                 +'Item_12_Month_Sales__c,Item_9_Month_Sales__c,Item_6_Month_Sales__c,Item_3_Month_Sales__c,'
                 +'Total_Spend_Impact_12_Month__c,Total_Spend_Impact_9_Month__c,Total_Spend_Impact_6_Month__c,Total_Spend_Impact_3_Month__c,SRM_Differential__c,batchId__c, Alt_SKU__c,'
                 +'ace_customer_core_changes__r.ace_customer_price_changes__r.remedy_status__c,SKU_Description__c,'
                 +'SKU_Alt__c,Record_Locked__c,Status__c,Alternate_Chosen_Flag__c,Owning_Customer_Legal__c ,Ace_Customer_Core_Changes__r.ACE_Customer_Price_Changes__r.sfdc_notification_flag__c,'
                 +'Ace_Customer_Core_Changes__r.ACE_Customer_Price_Changes__r.record_lock__c,ace_customer_core_changes__r.ace_customer_price_changes__r.IsRemediation__c,Ace_Customer_Core_Changes__r.Ace_Customer_Price_Changes__r.Customer__r.Rolling_12_month_sales__c,'
                 +'Ace_Customer_Core_Changes__r.Ace_Customer_Price_Changes__r.Customer__r.Rolling_9_month_sales__c,Ace_Customer_Core_Changes__r.Ace_Customer_Price_Changes__r.Customer__r.Rolling_6_month_sales__c,'
                 +'Ace_Customer_Core_Changes__r.Ace_Customer_Price_Changes__r.Customer__r.Rolling_3_month_sales__c,ace_customer_core_changes__r.ace_customer_price_changes__r.customer__r.ownerid,ace_customer_core_changes__r.ace_customer_price_changes__r.Owning_Customer_ID__c,ace_customer_core_changes__r.ace_customer_price_changes__r.PRICE_NOT_CALCULATED__c'
                 +' from Ace_Customer_SKU_Changes__c where '
                 +'  Status__c != :Status';
       
       if(callType =='CustomerPricing_np'){ 
       system.debug('$$$$$$$$$$$');
       
              System.debug('&&&&&&&&&&queryString 1'+queryString   ); 
              System.debug('&&&&&&&&&&fieldName'+fieldName_notify );
              System.debug('&&&&&&&&&&sortDirection '+sortDirection_notify );              
              
       queryString =queryString + ' and Ace_Customer_Core_Changes__r.ACE_Customer_Price_Changes__c = : Accid';
       queryString =queryString + ' and Update_Timing_Action__c = \'T\'';//ROM-37 - to not showup in detail page for Update_Timing_Action__c = 'F'
              
       // if Search is null
       if(SKUSearch==null  ||  SKUSearch=='') {       
       if(fieldName_notify !=null  && sortDirection_notify != null)
       queryString =queryString + ' order by '+fieldName_notify +' '+ sortDirection_notify +' NULLS LAST  limit :List_size OFFSET :counter'; 
       else  
       queryString =queryString + ' limit :List_size OFFSET :counter';        
        System.debug('&&&&&&&&&&queryString 2'+queryString );
           
       return (Database.query(queryString) );       
        /* return [
         select Id,
                 SKU__c, //SKU
                 Approval_status__c, //Approval Status
                 Ace_Customer_Core_Changes__r.name, //CORE
                 Ace_Customer_Core_Changes__c,//Core Link 
                 Price_Changes_Type__c,//Change Type
                 Margin_Play__c, //MArgin Play
                 Core_s_SKU_Vendor_Name__c, //Vendor
                 Current_Sell_Price__c,//Current Price
                 Approved_Proposed_Price__c,//New_List_Price__c,//Proposed_Price__c,// New Price
                 Change_Amount__c,//Change Amount
                 ChangeAmount_per__c, //Chnage Amount %
                 SKU_Last_Update__c,Item_12_Month_Qty__c,Item_9_Month_Qty__c,Item_6_Month_Qty__c,Item_3_Month_Qty__c,//Annual_Usage__c,//Annual Usage
                 Item_12_Month_Sales__c,Item_9_Month_Sales__c,Item_6_Month_Sales__c,Item_3_Month_Sales__c,//Annual SKU Spend
                 Total_Spend_Impact_12_Month__c,Total_Spend_Impact_9_Month__c,Total_Spend_Impact_6_Month__c,Total_Spend_Impact_3_Month__c,//Annual Spend Change Amt
                 SRM_Differential__c, //SRM_Impact
                 batchId__c, // Customer Name for Url parameter
                 Alt_SKU__c,// ALT SKU
                 ace_customer_core_changes__r.ace_customer_price_changes__r.remedy_status__c,
                 SKU_Description__c,
                 SKU_Alt__c,Record_Locked__c,Status__c,
                 Alternate_Chosen_Flag__c,Owning_Customer_Legal__c ,
                 Ace_Customer_Core_Changes__r.ACE_Customer_Price_Changes__r.sfdc_notification_flag__c,
                 Ace_Customer_Core_Changes__r.ACE_Customer_Price_Changes__r.record_lock__c,
                 ace_customer_core_changes__r.ace_customer_price_changes__r.IsRemediation__c,
                 Ace_Customer_Core_Changes__r.Ace_Customer_Price_Changes__r.Customer__r.Rolling_12_month_sales__c,
                 Ace_Customer_Core_Changes__r.Ace_Customer_Price_Changes__r.Customer__r.Rolling_9_month_sales__c,
                 Ace_Customer_Core_Changes__r.Ace_Customer_Price_Changes__r.Customer__r.Rolling_6_month_sales__c,
                 Ace_Customer_Core_Changes__r.Ace_Customer_Price_Changes__r.Customer__r.Rolling_3_month_sales__c,
                 ace_customer_core_changes__r.ace_customer_price_changes__r.customer__r.ownerid,
                 ace_customer_core_changes__r.ace_customer_price_changes__r.Owning_Customer_ID__c
                 //Total Spend Impact
                 //SRM Impact
                 from Ace_Customer_SKU_Changes__c where Ace_Customer_Core_Changes__r.ACE_Customer_Price_Changes__c =:Accid
                  AND Status__c != 'InActive'
                 limit :List_size OFFSET :counter];                 
                 */
                 }
                 else{                 
                         /* return [
         select Id,
                 SKU__c, //SKU
                 Approval_status__c, //Approval Status
                 Ace_Customer_Core_Changes__r.name, //CORE
                 Ace_Customer_Core_Changes__c,//Core Link 
                 Price_Changes_Type__c,//Change Type
                 Margin_Play__c, //MArgin Play
                 Core_s_SKU_Vendor_Name__c, //Vendor
                 Current_Sell_Price__c,//Current Price
                 Approved_Proposed_Price__c,//New_List_Price__c,//Proposed_Price__c,// New Price
                 Change_Amount__c,//Change Amount
                 ChangeAmount_per__c, //Chnage Amount %
                 SKU_Last_Update__c,Item_12_Month_Qty__c,Item_9_Month_Qty__c,Item_6_Month_Qty__c,Item_3_Month_Qty__c,//Annual_Usage__c,//Annual Usage
                 Item_12_Month_Sales__c,Item_9_Month_Sales__c,Item_6_Month_Sales__c,Item_3_Month_Sales__c,//Annual SKU Spend
                 Total_Spend_Impact_12_Month__c,Total_Spend_Impact_9_Month__c,Total_Spend_Impact_6_Month__c,Total_Spend_Impact_3_Month__c,//Annual Spend Change Amt
                 SRM_Differential__c, //SRM_Impact
                 batchId__c, // Customer Name for Url parameter
                 Alt_SKU__c,// ALT SKU
                 ace_customer_core_changes__r.ace_customer_price_changes__r.remedy_status__c,
                 SKU_Description__c,
                 SKU_Alt__c,Record_Locked__c,Status__c,
                 Alternate_Chosen_Flag__c,Owning_Customer_Legal__c ,
                 Ace_Customer_Core_Changes__r.ACE_Customer_Price_Changes__r.sfdc_notification_flag__c,
                 Ace_Customer_Core_Changes__r.ACE_Customer_Price_Changes__r.record_lock__c,
                 ace_customer_core_changes__r.ace_customer_price_changes__r.IsRemediation__c,
                 Ace_Customer_Core_Changes__r.Ace_Customer_Price_Changes__r.Customer__r.Rolling_12_month_sales__c,
                 Ace_Customer_Core_Changes__r.Ace_Customer_Price_Changes__r.Customer__r.Rolling_9_month_sales__c,
                 Ace_Customer_Core_Changes__r.Ace_Customer_Price_Changes__r.Customer__r.Rolling_6_month_sales__c,
                 Ace_Customer_Core_Changes__r.Ace_Customer_Price_Changes__r.Customer__r.Rolling_3_month_sales__c,
                 ace_customer_core_changes__r.ace_customer_price_changes__r.customer__r.ownerid,
                 ace_customer_core_changes__r.ace_customer_price_changes__r.Owning_Customer_ID__c
                 //Total Spend Impact
                 //SRM Impact
                 from Ace_Customer_SKU_Changes__c where sku__C like :SKUSearch1
                 and 
                 Ace_Customer_Core_Changes__r.ACE_Customer_Price_Changes__c =:Accid AND Status__c != 'InActive'
                 limit :List_size OFFSET :counter];
                 */               
               queryString =queryString + ' and sku__C like :SKUSearch1 ';
               
               if(fieldName_notify !=null  && sortDirection_notify != null)
                  queryString =queryString + ' order by '+fieldName_notify +' '+ sortDirection_notify +' NULLS LAST  limit :List_size OFFSET :counter'; 
               else  
                  queryString =queryString + ' limit :List_size OFFSET :counter';        
                System.debug('&&&&&&&&&&queryString 2'+queryString );        
                return (Database.query(queryString) );                        
                 }                 
              }                
                 else{ system.debug('$$$$$$$$$$$');                 
                 queryString =queryString + ' and Ace_Customer_Core_Changes__c =:Accid';
                 queryString =queryString + ' and Update_Timing_Action__c = \'T\'';//ROM-37 - to not showup in detail page for Update_Timing_Action__c = 'F'
                 
                 if(SKUSearch==null  ||  SKUSearch=='') 
                 total_size = [select count() from Ace_Customer_SKU_Changes__c where Ace_Customer_Core_Changes__c =:Accid AND
                  Status__c != 'InActive' AND Update_Timing_Action__c = 'T'];  //ROM-37 - to not showup in detail page for Update_Timing_Action__c = 'F'
                  else
                  total_size = [select count() from Ace_Customer_SKU_Changes__c where Ace_Customer_Core_Changes__c =:Accid AND
                  Status__c != 'InActive' AND Update_Timing_Action__c = 'T' and sku__C like :SKUSearch1];  //ROM-37 - to not showup in detail page for Update_Timing_Action__c = 'F'
                 
                if(SKUSearch==null  ||  SKUSearch=='') {                                
                   if(fieldName_notify !=null  && sortDirection_notify != null)
                      queryString =queryString + ' order by '+fieldName_notify +' '+ sortDirection_notify +' NULLS LAST  limit :List_size OFFSET :counter'; 
                   else  
                      queryString =queryString + ' limit :List_size OFFSET :counter';        
                    System.debug('&&&&&&&&&&queryString 2'+queryString );        
                    return (Database.query(queryString) );                  
                 /*
                 return [select Id,ace_customer_core_changes__r.ACE_Customer_Price_Changes__r.Remedy_Status__c,
                 SKU__c, //SKU
                 Approval_status__c, //Approval Status                 
                 Ace_Customer_Core_Changes__r.name, //CORE
                 Ace_Customer_Core_Changes__c,//Core Link 
                 Price_Changes_Type__c,//Change Type
                 Margin_Play__c, //MArgin Play
                 Core_s_SKU_Vendor_Name__c, //Vendor
                 Current_Sell_Price__c,//Current Price
                 Approved_Proposed_Price__c,//New_List_Price__c,//Proposed_Price__c,// New Price
                 Change_Amount__c,//Change Amount
                 ChangeAmount_per__c, //Chnage Amount %
                 SKU_Last_Update__c,Item_12_Month_Qty__c,Item_9_Month_Qty__c,Item_6_Month_Qty__c,Item_3_Month_Qty__c,//Annual_Usage__c,//Annual Usage
                 Item_12_Month_Sales__c,Item_9_Month_Sales__c,Item_6_Month_Sales__c,Item_3_Month_Sales__c,//Annual SKU Spend
                 Total_Spend_Impact_12_Month__c,Total_Spend_Impact_9_Month__c,Total_Spend_Impact_6_Month__c,Total_Spend_Impact_3_Month__c,//Annual Spend Change Amt
                 SRM_Differential__c, //SRM_Impact
                 batchId__c, // Customer Name for Url parameter                                        
                 Alt_SKU__c,// ALT SKU
                 SKU_Description__c,Owning_Customer_Legal__c ,
                 SKU_Alt__c,Record_Locked__c,Status__c,
                 Alternate_Chosen_Flag__c,
                         Ace_Customer_Core_Changes__r.ACE_Customer_Price_Changes__r.sfdc_notification_flag__c,
                 Ace_Customer_Core_Changes__r.ACE_Customer_Price_Changes__r.record_lock__c,
                 ace_customer_core_changes__r.ace_customer_price_changes__r.IsRemediation__c,
                 Ace_Customer_Core_Changes__r.Ace_Customer_Price_Changes__r.Customer__r.Rolling_12_month_sales__c,
                 Ace_Customer_Core_Changes__r.Ace_Customer_Price_Changes__r.Customer__r.Rolling_9_month_sales__c,
                 Ace_Customer_Core_Changes__r.Ace_Customer_Price_Changes__r.Customer__r.Rolling_6_month_sales__c,
                 Ace_Customer_Core_Changes__r.Ace_Customer_Price_Changes__r.Customer__r.Rolling_3_month_sales__c,
                 ace_customer_core_changes__r.ace_customer_price_changes__r.customer__r.ownerid,
                 ace_customer_core_changes__r.ace_customer_price_changes__r.Owning_Customer_ID__c
                 //Total Spend Impact
                 //SRM Impact
                 from Ace_Customer_SKU_Changes__c where Ace_Customer_Core_Changes__c =:Accid AND 
                 Status__c != 'InActive'
                 limit :List_size OFFSET :counter];
                 */                 
                 }
                 else{
                 /*
                 return [select Id,ace_customer_core_changes__r.ACE_Customer_Price_Changes__r.Remedy_Status__c,
                 SKU__c, //SKU
                 Approval_status__c, //Approval Status                 
                 Ace_Customer_Core_Changes__r.name, //CORE
                 Ace_Customer_Core_Changes__c,//Core Link 
                 Price_Changes_Type__c,//Change Type
                 Margin_Play__c, //MArgin Play
                 Core_s_SKU_Vendor_Name__c, //Vendor
                 Current_Sell_Price__c,//Current Price
                 Approved_Proposed_Price__c,//New_List_Price__c,//Proposed_Price__c,// New Price
                 Change_Amount__c,//Change Amount
                 ChangeAmount_per__c, //Chnage Amount %
                 SKU_Last_Update__c,Item_12_Month_Qty__c,Item_9_Month_Qty__c,Item_6_Month_Qty__c,Item_3_Month_Qty__c,//Annual_Usage__c,//Annual Usage
                 Item_12_Month_Sales__c,Item_9_Month_Sales__c,Item_6_Month_Sales__c,Item_3_Month_Sales__c,//Annual SKU Spend
                 Total_Spend_Impact_12_Month__c,Total_Spend_Impact_9_Month__c,Total_Spend_Impact_6_Month__c,Total_Spend_Impact_3_Month__c,//Annual Spend Change Amt
                 SRM_Differential__c, //SRM_Impact
                 batchId__c, // Customer Name for Url parameter                                        
                 Alt_SKU__c,// ALT SKU
                 SKU_Description__c,Owning_Customer_Legal__c ,
                 SKU_Alt__c,Record_Locked__c,Status__c,
                 Alternate_Chosen_Flag__c,
                         Ace_Customer_Core_Changes__r.ACE_Customer_Price_Changes__r.sfdc_notification_flag__c,
                 Ace_Customer_Core_Changes__r.ACE_Customer_Price_Changes__r.record_lock__c,
                 ace_customer_core_changes__r.ace_customer_price_changes__r.IsRemediation__c,
                 Ace_Customer_Core_Changes__r.Ace_Customer_Price_Changes__r.Customer__r.Rolling_12_month_sales__c,
                 Ace_Customer_Core_Changes__r.Ace_Customer_Price_Changes__r.Customer__r.Rolling_9_month_sales__c,
                 Ace_Customer_Core_Changes__r.Ace_Customer_Price_Changes__r.Customer__r.Rolling_6_month_sales__c,
                 Ace_Customer_Core_Changes__r.Ace_Customer_Price_Changes__r.Customer__r.Rolling_3_month_sales__c,
                 ace_customer_core_changes__r.ace_customer_price_changes__r.customer__r.ownerid,
                 ace_customer_core_changes__r.ace_customer_price_changes__r.Owning_Customer_ID__c
                 //Total Spend Impact
                 //SRM Impact
                 from Ace_Customer_SKU_Changes__c where Ace_Customer_Core_Changes__c =:Accid AND 
                 sku__C like :SKUSearch1 and
                 Status__c != 'InActive'
                 limit :List_size OFFSET :counter];
                 */
                 queryString =queryString + ' and sku__C like :SKUSearch1 ';               
                   if(fieldName_notify !=null  && sortDirection_notify != null)
                      queryString =queryString + ' order by '+fieldName_notify +' '+ sortDirection_notify +' NULLS LAST  limit :List_size OFFSET :counter'; 
                   else  
                      queryString =queryString + ' limit :List_size OFFSET :counter';        
                    System.debug('&&&&&&&&&&queryString 2'+queryString );        
                 return (Database.query(queryString) );                 
                 }              
              }   
    }
    
     public void generateSummaryRow(List<Ace_Customer_SKU_Changes__c > lst_sku, String range){
       Decimal AU = 0;
       Decimal ASKUSpend = 0.00;
       Decimal AnnualSpendChangeAmt = 0.00;        
       
        for(Ace_Customer_SKU_Changes__c sku: lst_sku){
            if(range == '12-Months'){
                
                if(sku.Item_12_Month_Qty__c != null)
                    AU = AU+ sku.Item_12_Month_Qty__c;
                if(sku.Item_12_Month_Sales__c != null)
                    ASKUSpend= ASKUSpend + sku.Item_12_Month_Sales__c;
                if(sku.Total_Spend_Impact_12_Month__c != null)
                    AnnualSpendChangeAmt = AnnualSpendChangeAmt+sku.Total_Spend_Impact_12_Month__c;                  
             }   
            if(range == '9-Months'){
                
                if(sku.Item_9_Month_Qty__c != null)
                    AU = AU+ sku.Item_9_Month_Qty__c;
                if(sku.Item_9_Month_Sales__c != null)
                    ASKUSpend= ASKUSpend + sku.Item_9_Month_Sales__c;
                if(sku.Total_Spend_Impact_9_Month__c != null)
                    AnnualSpendChangeAmt = AnnualSpendChangeAmt+sku.Total_Spend_Impact_9_Month__c;
            }
            if(range == '6-Months'){
                
                if(sku.Item_6_Month_Qty__c != null)
                    AU = AU+ sku.Item_6_Month_Qty__c;
                if(sku.Item_6_Month_Sales__c != null)
                    ASKUSpend= ASKUSpend + sku.Item_6_Month_Sales__c;
                if(sku.Total_Spend_Impact_6_Month__c != null)
                    AnnualSpendChangeAmt = AnnualSpendChangeAmt+sku.Total_Spend_Impact_6_Month__c;
            }
            if(range == '3-Months'){
                if(sku.Item_3_Month_Qty__c != null)
                    AU = AU+ sku.Item_3_Month_Qty__c;
                if(sku.Item_3_Month_Sales__c != null)
                    ASKUSpend= ASKUSpend + sku.Item_3_Month_Sales__c;
                if(sku.Total_Spend_Impact_3_Month__c != null)
                    AnnualSpendChangeAmt = AnnualSpendChangeAmt+sku.Total_Spend_Impact_3_Month__c;
            }

        }
        
        if (AU != null)
         Annual_Usage = math.abs(AU);
        if (ASKUSpend != null)
         Annual_SKU_Spend = math.abs(ASKUSpend);//Util_Numbers.CurrencyToString(ASKUSpend,'$');  
        if (AnnualSpendChangeAmt != null)      
         Annual_Spend_Change_Amt = math.abs(AnnualSpendChangeAmt);
        Per_change_Amount = 0;
        
        // if (Customer_Spend != null && Customer_Spend != 0 && Annual_Spend_Change_Amt != null)
        // Total_Spend_Impact = (Annual_Spend_Change_Amt/Customer_Spend)*100;
         
        if (ASKUSpend != null && ASKUSpend != 0 && Annual_Spend_Change_Amt != null)
         Total_Spend_Impact = (Annual_Spend_Change_Amt/ASKUSpend)*100; 
        if (ASKUSpend != null && ASKUSpend != 0 && AnnualSpendChangeAmt != null)
         Per_change_Amount = ((AnnualSpendChangeAmt/ASKUSpend)*100).setScale(2);
         
        NoOfCores = lst_sku.size();
    
    }
    
    public void nextPage(){
        counter = counter+List_size; 
          
        generateDataforRange(DataRange);
        
    }
    
    public void prevPage(){
        counter = counter-List_size;
        
        generateDataforRange(DataRange);
        
    }
    
    public Boolean getDisablePrevious() {
     
      if (counter>0) return true; else return false;
    }
    
    public Boolean getDisableNext() { 
      if (counter + list_size < total_size) return true; else return false;
    }
    
    public class CustomerSKUDataResponse{
        public String SalesforceSKUID{get;set;}
        public String SKUID{get;set;}
        public String APPROVALSTATUS{get;set;}
        public String COREID{get;set;}
        public String PriceChangesType{get;set;}
        public String VENDOR{get;set;}
        public Decimal CURRENTPRICE{get;set;}
        public Decimal NEWPRICE{get;set;}
        public Decimal CHANGEAMOUNT{get;set;}
        public Decimal CHANGEAMOUTPER{get;set;}
        public Decimal ANNUALUSAGE{get;set;}
        public Decimal ANNUALSKUSPEND{get;set;}
        public Decimal ANNUALSPENDCHANGEAMT{get;set;}
        public Decimal TOTALSPENDIMPACT{get;set;}
        public Decimal SRMIMPACT{get;set;}
        public String COREIDLINK{get;set;}
        public String BATCHID{get;set;}
        public Boolean CHECKROLLING{get;set;}
        public Boolean CHECKROLLINGNEW{get;set;}
        public Boolean CHECKROLLINGREVERT{get;set;}
        public Boolean CHECKROLLINGALT{get;set;}
        public Boolean ISALT{get;set;}
        public Boolean ISLOCK {get;set;}
        public Boolean DELSKU {get;set;}
        public Boolean DELSKUALT {get;set;}
        public Boolean AltExists {get;set;}
        public Boolean AltReplace {get;set;}
        public String skuDescription {get;set;}
        public String ChangeType {get;set;}
        public Date skuLastDate{get;set;}
        public String Status{get;set;}
        public String SKUALT {get;set;}
        public Decimal SKUALTPRICE {get;set;}
        public String SKUALTDESCRIPTION{get;set;}
        public String altQPU{get;set;}
        public String altUOM{get;set;}

        public String CORE{get;set;}
        public Boolean STDCore {get;set;}
        public Decimal SKUALTAPPPRICE {get;set;}
        public Decimal SKUALTCAPAMOUNT {get;set;}
    }
        
    //Added for 00826591 
    
        public PageReference deleteSKU(){
        PageReference pr;
        
            Ace_Customer_SKU_Changes__c selectedSKU = new Ace_Customer_SKU_Changes__c();
            selectedSKU =[select Id, status__c ,Ace_Customer_Core_Changes__r.ACE_Customer_Price_Changes__r.id from 
            Ace_Customer_SKU_Changes__c   where Id=:passThruSkuId];
            selectedSKU.status__c = 'Deleted';            
            update selectedSKU;
           
            pr = new PageReference('/apex/ACE_CustomerSKUList?id='+aId);
            pr.setRedirect(true);
            return pr;      
        }
        
        //00826594  Reverting the delete
        public PageReference RevertdeleteSKU(){
            PageReference pr;        
            Ace_Customer_SKU_Changes__c selectedSKU = new Ace_Customer_SKU_Changes__c();
            selectedSKU =[select Id, status__c ,Ace_Customer_Core_Changes__r.ACE_Customer_Price_Changes__r.id from 
            Ace_Customer_SKU_Changes__c   where Id=:passThruSkuId];
            selectedSKU.status__c = 'Active';            
            update selectedSKU;
            
           
            pr = new PageReference('/apex/ACE_CustomerSKUList?id='+aId);
            pr.setRedirect(true);
            return pr;      
        }
        
        // Revert Replace target with ALT sku
        public PageReference RevertReplaceALTSKU(){
            PageReference pr;
            Ace_Customer_SKU_Changes__c selectedSKU = new Ace_Customer_SKU_Changes__c();
            selectedSKU =[select Id, status__c ,Ace_Customer_Core_Changes__r.ACE_Customer_Price_Changes__r.id,
            Proposed_SRM_with_Cap1__c ,SKU_Alt__c ,Ace_Customer_Core_Changes__c  from 
            Ace_Customer_SKU_Changes__c   where Id=:passThruSkuId];
            selectedSKU.status__c = 'Active';   
            selectedSKU.Alternate_Chosen_Flag__c = false; 
            Ace_Customer_SKU_Changes__c altSKUREc = new Ace_Customer_SKU_Changes__c();
            
            try{
            if(selectedSKU.SKU_Alt__c  != null){
            altSKUREc = [select id,QPU__c,Proposed_SRM_with_Cap1__c,Proposed_Price_with_Cap__c,
                       status__c ,Alt_SKU__c,
                       Current_Sell_Price__c,sku_description__c from Ace_Customer_SKU_Changes__c where SKU__c=:selectedSKU.SKU_Alt__c
                       and  Ace_Customer_Core_Changes__c = :selectedSKU.Ace_Customer_Core_Changes__c and 
                       Ace_Customer_Core_Changes__r.ACE_Customer_Price_Changes__r.id = :selectedSKU.Ace_Customer_Core_Changes__r.ACE_Customer_Price_Changes__r.id LIMIT 1];     
                       System.debug('Inside here 2' );

                selectedSKU.Alternate_Margin__c =null;                   
            }
          
                if(altSKUREc != null){
                System.debug('Inside here 3'+ altSKUREc  );
                altSKUREc.status__c = 'Inactive';
                altSKUREc.Alt_SKU__c= false;      
                //altSKUREc.Approved_Proposed_Price__c = null;              
                update altSKUREc ;
                }
             }
             catch(Exception e){} 
             update selectedSKU;

            pr = new PageReference('/apex/ACE_CustomerSKUList?id='+aId);
            pr.setRedirect(true);
            return pr;           
        }
        
         // Replace target with ALT sku
         public PageReference passStringToController(){
         
         ///passThruSkuId=Apexpages.currentPage().getParameters().get('p2');
         //altchangePrice=Decimal.valueof(Apexpages.currentPage().getParameters().get('p1'));
         System.debug('Inside here altchangePrice'+ altchangePrice);
         System.debug('Inside here passThruSkuId'+ passThruSkuId);
        
            Ace_Customer_SKU_Changes__c selectedSKU = new Ace_Customer_SKU_Changes__c();
            selectedSKU =[select Id, status__c ,Ace_Customer_Core_Changes__r.ACE_Customer_Price_Changes__r.id,
            Proposed_SRM_with_Cap1__c ,SKU_Alt__c ,Ace_Customer_Core_Changes__c  from 
            Ace_Customer_SKU_Changes__c   where Id=:passThruSkuId];
            selectedSKU.status__c = 'Deleted';   
            selectedSKU.Alternate_Chosen_Flag__c = true; 
            
            Ace_Customer_SKU_Changes__c altSKUREc = new Ace_Customer_SKU_Changes__c();
            
                     System.debug('Inside here 1'+ selectedSKU.SKU_Alt__c);
                     System.debug('Inside here 1'+ altchangePrice);
            try{
            if(selectedSKU.SKU_Alt__c  != null){
            altSKUREc = [select id,QPU__c,Proposed_SRM_with_Cap1__c,Proposed_Price_with_Cap__c,
                       status__c ,Alt_SKU__c,
                       Current_Sell_Price__c,sku_description__c from Ace_Customer_SKU_Changes__c where SKU__c=:selectedSKU.SKU_Alt__c
                       and  Ace_Customer_Core_Changes__c = :selectedSKU.Ace_Customer_Core_Changes__c and 
                       Ace_Customer_Core_Changes__r.ACE_Customer_Price_Changes__r.id = :selectedSKU.Ace_Customer_Core_Changes__r.ACE_Customer_Price_Changes__r.id LIMIT 1];     
                       System.debug('Inside here 2' );

                selectedSKU.Alternate_Margin__c = altSKUREc.Proposed_SRM_with_Cap1__c;                   
            }
          
                if(altSKUREc != null){
                                       System.debug('Inside here 3'+ altSKUREc  );

                altSKUREc.status__c = 'Active';
                altSKUREc.Alt_SKU__c= true;      
                altSKUREc.Approved_Proposed_Price__c = altchangePrice;              
                update altSKUREc ;
                }
             }
             catch(Exception e){} 
               
            update selectedSKU;
                       System.debug('&&&&&&&&&&&Inside redirect enter');
             return null;
        }        
        
        public PageReference refreshPage(){
            PageReference pr;
            System.debug('&&&&&&&&&&&Inside redirect'+ passThruSkuId1);
            Ace_Customer_SKU_Changes__c selectedSKU = new Ace_Customer_SKU_Changes__c();
            selectedSKU =[select Id, status__c ,Ace_Customer_Core_Changes__r.ACE_Customer_Price_Changes__r.id,
            Proposed_SRM_with_Cap1__c ,SKU_Alt__c ,Ace_Customer_Core_Changes__c  from 
            Ace_Customer_SKU_Changes__c   where Id=:passThruSkuId1];
            // pagereference pr= new PageReference('https://www.google.com');
            //pagereference  pr = new PageReference('/'+selectedSKU.Ace_Customer_Core_Changes__r.ACE_Customer_Price_Changes__r.id);        
            pr = new PageReference('/apex/ACE_CustomerSKUList?id='+aId);
            System.debug('&&&&&&&&&&&Inside redirect'+ pr);
            pr.setRedirect(true);
            return pr;
        }
    
      //00826578
      public PageReference searchSKU() {
      
        Customer_Spend_label = 'Customer Annual Spend';
        counter = 0;
        showPageBlockTable = false;
        Total_SRM_Impact = 0;
        Total_New_Price = 0;
        Total_Current_Price = 0;
      
      generateDataforRange(DataRange);

      /*System.debug('&&&&&&&&&&SKUSearch'+SKUSearch);
      List<CustomerSKUDataResponse> newList=oCustSkuDataResponse;
      oCustSkuDataResponse= new List<CustomerSKUDataResponse> ();
      for(integer i=0;i<newList.size();i++){
         if(newList[i].SKUID.contains(SKUSearch))
         oCustSkuDataResponse.add(newList[i]);
      }
      */
      return null;
      }     
          
        public Integer getPageNumber() {
        return counter/list_size + 1;
        }

        public Integer getTotalPages() {
        if (math.mod(total_size, list_size) > 0) {
            return total_size/list_size + 1;
        } else {
          return (total_size/list_size);
        }
      }

     public void sortCust_notify() 
     {
     System.debug('&&&&&Inside getFieldName_notify '+getFieldName_notify );
          System.debug('&&&&&Inside tabAsc_notify'+tabAsc_notify);

         if(getFieldName_notify == 'ChangeAmount'){
            fieldName_notify = 'Change_Amount__c';}
            else if(getFieldName_notify == 'NewPrice'){
            fieldName_notify = 'Approved_Proposed_Price__c';}
            else if(getFieldName_notify == 'CurrentPrice'){
            fieldName_notify = 'Current_Sell_Price__c';}
            else if(getFieldName_notify == 'Vendor'){
            fieldName_notify = 'Core_s_SKU_Vendor_Name__c';}
            else if(getFieldName_notify == 'ChangeT'){
            fieldName_notify = 'price_Changes_Type__c';}
            else if(getFieldName_notify == 'Description'){
            fieldName_notify = 'sku_description__c';}
            else if(getFieldName_notify == 'SKUNum'){
            fieldName_notify = 'SKU__c';}
            else if(getFieldName_notify == 'LastUpdate'){
            fieldName_notify = 'SKU_Last_Update__c';}
            else if(getFieldName_notify == 'SRMImpact'){
            fieldName_notify = 'SRM_Differential__c';}
            
         if(tabAsc_notify){
         System.debug('&&&&&&Inside1');
            sortDirection_notify = 'DESC';
            tabAsc_notify = false;            
        }
        else {
                 System.debug('&&&&&&Inside2');
            sortDirection_notify = 'ASC';
            tabAsc_notify = true;             
        }
                 System.debug('&&&&&&Inside3'+sortDirection_notify );          
        generateDataforRange(DataRange); 
    }      
}