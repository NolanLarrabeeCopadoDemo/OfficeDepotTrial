public class ACECustomerCoreController
{
    //public String DataRange{get;set;}
    public String saId{get;set;}
    public String aId {get;set;}
    
    public Integer counter = 0;
    public Integer List_size = 5;
    
    public Integer total_size{get;set;}
    public Date dateRelease{get;set;}
    public List<CustomerCoreDataResponse> oCustCoreDataResponse {get;set;}
    public List<Ace_Customer_Core_Changes__c> csku {get;set;}
    public boolean showPageBlockTable {get;set;}
    public Decimal Annual_Usage{get;set;}
    public Decimal Annual_SKU_Spend{get;set;}
    public Decimal Annual_Spend_Change_Amt{get;set;}
    public Decimal Customer_12_spend{get;set;}
    public Decimal Customer_9_spend{get;set;}
    public Decimal Customer_6_spend{get;set;}
    public Decimal Customer_3_spend{get;set;}
    public Decimal Total_Spend_Impact{get;set;}
    public Decimal Total_SRM_Impact{get;set;}
    public String AnnualUsage_header{get;set;}
    public String AnnualSKUSpend_header{get;set;}
    public String AnnualSpendChangeAmt_header{get;set;}
    public Decimal Avg_Change{get;set;}
    public Decimal Customer_Spend{get;set;}
    public String Customer_Spend_label{get;set;}
    public String id {get;set;}
    public String aName {get;set;}
    public String period{get;set;}
    public Boolean renderCoreFooter{get;set;} 
    public List<Ace_Customer_Core_Changes__c> conList{get;set;}
    
    public ACECustomerCoreController(){
        //utilNum_Format.commaSeparator('1000000.00'); // testing purpose for util class
        Customer_Spend_label = 'Customer Annual Spend';
        showPageBlockTable = false;
        Annual_Usage = 0;
        Total_SRM_Impact = 0;
        period = '12-Months';// Component Defaults to 12-Months
        Customer_12_spend = 4000000;// Need to change this -- this might comes from customer
        Customer_9_spend = 3000000;// Need to change this -- this might comes from customer
        Customer_6_spend = 2000000;// Need to change this -- this might comes from customer
        Customer_3_spend = 1000000;// Need to change this -- this might comes from customer
        //aId = saId;
        aId = ApexPages.currentPage().getParameters().get('id');
        System.debug('>>>>>>' + aid);
        list<ACE_Customer_Price_Changes__c> coreList;
        if(aId != null){
           coreList = [select id,Name,customer__r.rolling_12_month_sales__c,customer__r.rolling_9_month_sales__c,customer__r.rolling_6_month_sales__c,customer__r.rolling_3_month_sales__c from ACE_Customer_Price_Changes__c where id= :aId];
           Customer_12_spend = coreList[0].customer__r.rolling_12_month_sales__c;// Need to change this -- this might comes from customer
           Customer_9_spend = coreList[0].customer__r.rolling_9_month_sales__c;// Need to change this -- this might comes from customer
           Customer_6_spend = coreList[0].customer__r.rolling_6_month_sales__c;// Need to change this -- this might comes from customer
           Customer_3_spend = coreList[0].customer__r.rolling_3_month_sales__c;// Need to change this -- this might comes from customer
           if((coreList != null)&&(coreList.size()>0)){
               aName = coreList[0].name;
           }   
        }
        if(aId == null || coreList == null || !(coreList.size()>0)){          
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.WARNING,'Account Id is invalid'));                
        }
        else{
            conList = getskusforCustomer(aid);
            generateDataforRange(period);
            system.debug('>>>>>>>>>>>' +aName +'<<<<<<<<<<'+conList);
       }
    }

    public void generateDataforRange(String range){
        Total_SRM_Impact = 0;
        Total_Spend_Impact = 0;
        Avg_Change = 0;
        Annual_Spend_Change_Amt = 0;
        Annual_SKU_Spend = 0;
        Annual_Usage = 0;
        try{    
            //Integer coreCount = 0;
            oCustCoreDataResponse = new List<CustomerCoreDataResponse>();
            List<Ace_Customer_Core_Changes__c > csku = getskusforCustomer(aId);
            if(range == '12-Months'){
                if(Customer_12_spend != null && Customer_12_spend != 0){
                Customer_Spend = Customer_12_spend; 
                Customer_Spend_label = 'Customer Annual Spend';
                }
                else{
                    Customer_Spend = 0.00; 
                    Customer_Spend_label = 'Customer Annual Spend';
                }
            }
            if(range == '9-Months'){
                if(Customer_9_spend != null && Customer_9_spend != 0){
                Customer_Spend = Customer_9_spend;
                Customer_Spend_label = 'Customer 9-Months Spend';
                }
                else{
                    Customer_Spend = 0; 
                    Customer_Spend_label = 'Customer 9-Months Spend';
                }
            }
            if(range == '6-Months'){
                if(Customer_6_spend != null && Customer_6_spend != 0){
                Customer_Spend = Customer_6_spend;
                Customer_Spend_label = 'Customer 6-Months Spend';
                }
                else{
                    Customer_Spend = 0; 
                    Customer_Spend_label = 'Customer 6-Months Spend';
                }
            }
            if(range == '3-Months'){
                if(Customer_3_spend != null && Customer_3_spend != 0){
                 Customer_Spend = Customer_3_spend;
                Customer_Spend_label = 'Customer 3-Months Spend';
                }
                else{
                    Customer_Spend = 0; 
                    Customer_Spend_label = 'Customer 3-Months Spend';
                }
            }
            

            if(csku.size()>0){
                
                for(Ace_Customer_Core_Changes__c acsc : csku){  
                    List<Ace_Customer_SKU_Changes__c> skuCountList = new List<Ace_Customer_SKU_Changes__c>();  
                    skuCountList = [SELECT Id FROM Ace_Customer_SKU_Changes__c where Ace_Customer_Core_Changes__r.ACE_Customer_Price_Changes__c =:aId AND CoreList_ID__c =:acsc.CoreID__c AND Status__c!='InActive' AND Update_Timing_Action__c='T'];//ROM-37                               
                    
                    //if (skuCountList != null)                    
                    if(skuCountList.size() < 1)
                        continue;//This is to skip the particular core if the SKU is Zero
                               
                    CustomerCoreDataResponse c = new CustomerCoreDataResponse();
                    c.SKUCOUNT = skuCountList.size();
                    c.SalesforceCOREID = acsc.id;            
                    c.COREID = acsc.CoreID__c;
                    c.CoreDescription = acsc.Core_Description__c;                         
                    c.NEWPRICE = acsc.Proposed_SRM_with_Cap1__c;                            
                    c.SRMIMPACT = acsc.SRM_Differential__c;    
                    if (acsc.SRM_Differential__c != null)
                      Total_SRM_Impact = Total_SRM_Impact+acsc.SRM_Differential__c;                      
                    showPageBlockTable = true;// This is to render the table
                    if(range == '12-Months'){                                                                     
                        c.ANNUALUSAGE = acsc.Item_12_Month_Qty__c;
                        c.ANNUALSKUSPEND = acsc.Item_12_Month_Sales__c;
                        c.ANNUALSPENDCHANGEAMT = acsc.Total_Spend_Impact_12_Month__c;
                        
                        // Below line commented by mohit
                        // if(acsc.Total_Spend_Impact_12_Month__c!=null && Customer_Spend != null && Customer_Spend != 0)
                        //    c.TOTALSPENDIMPACT = ((acsc.Total_Spend_Impact_12_Month__c/Customer_Spend)*100).setScale(2);//Math.round
                        
                        // New condition Added by mohit
                        if(acsc.Total_Spend_Impact_12_Month__c!=null && acsc.Item_12_Month_Sales__c != null && acsc.Item_12_Month_Sales__c != 0)
                            c.TOTALSPENDIMPACT = ((acsc.Total_Spend_Impact_12_Month__c/acsc.Item_12_Month_Sales__c)*100).setScale(2);//Math.round
                        
                        if((acsc.Total_Spend_Impact_12_Month__c!=null && acsc.Total_Spend_Impact_12_Month__c!=0.00) && (acsc.Item_12_Month_Sales__c!=null && acsc.Item_12_Month_Sales__c!=0.00))
                            c.AVGCHANGE = ((acsc.Total_Spend_Impact_12_Month__c/acsc.Item_12_Month_Sales__c)*100).setScale(2);  
                        else
                            c.AVGCHANGE = 0.00;                                  
                        //Headers
                        AnnualUsage_header = 'Impacted SKU Usage';
                        AnnualSKUSpend_header = 'Impacted SKU Spend';
                        AnnualSpendChangeAmt_header = 'Estimated Total Spend Change';
                    }
                    if(range == '9-Months'){                            
                        c.ANNUALUSAGE = acsc.Item_9_Month_Qty__c;
                        c.ANNUALSKUSPEND = acsc.Item_9_Month_Sales__c;
                        c.ANNUALSPENDCHANGEAMT = acsc.Total_Spend_Impact_9_Month__c;
                        
                        
                        // Below line commented by mohit
                        //if(acsc.Total_Spend_Impact_9_Month__c!=null && Customer_Spend != null && Customer_Spend != 0)
                        //    c.TOTALSPENDIMPACT = ((acsc.Total_Spend_Impact_9_Month__c/Customer_Spend)*100).setScale(2);//Math.round
                            
                        // New condition Added by mohit
                        if(acsc.Total_Spend_Impact_9_Month__c!=null && acsc.Item_9_Month_Sales__c != null && acsc.Item_9_Month_Sales__c != 0)
                            c.TOTALSPENDIMPACT = ((acsc.Total_Spend_Impact_9_Month__c/acsc.Item_9_Month_Sales__c)*100).setScale(2);//Math.round
                            
                        if((acsc.Total_Spend_Impact_9_Month__c!=null && acsc.Total_Spend_Impact_9_Month__c!=0.00) && (acsc.Item_9_Month_Sales__c!=null && acsc.Item_9_Month_Sales__c!=0.00))
                            c.AVGCHANGE = ((acsc.Total_Spend_Impact_9_Month__c/acsc.Item_9_Month_Sales__c)*100).setScale(2);  
                        else
                            c.AVGCHANGE = 0.00;
                            //Headers                        
                        AnnualUsage_header = '9-Months Impacted SKU Usage';
                        AnnualSKUSpend_header = '9-Months Impacted SKU Spend';
                        AnnualSpendChangeAmt_header = '9-Months Estimated Total Spend Change';                        
                    }
                    if(range == '6-Months'){                            
                        c.ANNUALUSAGE = acsc.Item_6_Month_Qty__c;
                        c.ANNUALSKUSPEND = acsc.Item_6_Month_Sales__c;
                        c.ANNUALSPENDCHANGEAMT = acsc.Total_Spend_Impact_6_Month__c;
                        
                        // Below line commented by mohit
                        // if(acsc.Total_Spend_Impact_6_Month__c!=null && Customer_Spend != null && Customer_Spend != 0)
                        //    c.TOTALSPENDIMPACT = ((acsc.Total_Spend_Impact_6_Month__c/Customer_Spend)*100).setScale(2);//Math.round
                            
                        // New condition Added by mohit
                        if(acsc.Total_Spend_Impact_6_Month__c!=null && acsc.Item_6_Month_Sales__c != null && acsc.Item_6_Month_Sales__c != 0)
                            c.TOTALSPENDIMPACT = ((acsc.Total_Spend_Impact_6_Month__c/acsc.Item_6_Month_Sales__c)*100).setScale(2);//Math.round
                                 
                        if((acsc.Total_Spend_Impact_6_Month__c!=null && acsc.Total_Spend_Impact_6_Month__c!=0.00) && (acsc.Item_6_Month_Sales__c!=null && acsc.Item_6_Month_Sales__c!=0.00))
                            c.AVGCHANGE = ((acsc.Total_Spend_Impact_6_Month__c/acsc.Item_6_Month_Sales__c)*100).setScale(2);  
                        else
                            c.AVGCHANGE = 0.00;
                            //Headers 
                        AnnualUsage_header = '6-Months Impacted SKU Usage';
                        AnnualSKUSpend_header = '6-Months Impacted SKU Spend';
                        AnnualSpendChangeAmt_header = '6-Months Estimated Total Spend Change';
                    }
                    if(range == '3-Months'){                           
                        c.ANNUALUSAGE = acsc.Item_3_Month_Qty__c;
                        c.ANNUALSKUSPEND = acsc.Item_3_Month_Sales__c;
                        c.ANNUALSPENDCHANGEAMT = acsc.Total_Spend_Impact_3_Month__c;
                        
                        // Below line commented by mohit
                        // if(acsc.Total_Spend_Impact_3_Month__c!=null && Customer_Spend != null && Customer_Spend != 0)
                        //    c.TOTALSPENDIMPACT = ((acsc.Total_Spend_Impact_3_Month__c/Customer_Spend)*100).setScale(2);//Math.round
                        
                        // New condition Added by mohit
                        if(acsc.Total_Spend_Impact_3_Month__c!=null && acsc.Item_3_Month_Sales__c != null && acsc.Item_3_Month_Sales__c != 0)
                            c.TOTALSPENDIMPACT = ((acsc.Total_Spend_Impact_3_Month__c/acsc.Item_3_Month_Sales__c)*100).setScale(2);//Math.round
                            
                        if((acsc.Total_Spend_Impact_3_Month__c!=null && acsc.Total_Spend_Impact_3_Month__c!=0.00) && (acsc.Item_3_Month_Sales__c!=null && acsc.Item_3_Month_Sales__c!=0.00))
                            c.AVGCHANGE = ((acsc.Total_Spend_Impact_3_Month__c/acsc.Item_3_Month_Sales__c)*100).setScale(2);  
                        else
                            c.AVGCHANGE = 0.00;
                            //Headers
                        AnnualUsage_header = '3-Months Impacted SKU Usage';
                        AnnualSKUSpend_header = '3-Months Impacted SKU Spend';
                        AnnualSpendChangeAmt_header = '3-Months Estimated Total Spend Change';                        
                    }
                    
                    oCustCoreDataResponse.add(c);
                }        
                generateSummaryRow(csku, range);
            }    
        }catch(Exception e) {
            System.debug('The following exception has occurred: ' + e.getMessage());
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.WARNING,'Exception Occured. Request Cannot be processed:'));
        }   
    }
    
    
    public void generateSummaryRow(List<Ace_Customer_Core_Changes__c > lst_sku, String range){
       Decimal Count = 0; 
       Decimal AU = 0;
       Decimal ASKUSpend = 0.00;
       Decimal AnnualSpendChangeAmt = 0.00;  
       Decimal AvgChange = 0.00;             
       for(Ace_Customer_Core_Changes__c sku: lst_sku){
            
            if(range == '12-Months'){                
                if(sku.Item_12_Month_Qty__c != null)
                    AU = AU+ sku.Item_12_Month_Qty__c;
                if(sku.Item_12_Month_Sales__c != null)
                    ASKUSpend= ASKUSpend + sku.Item_12_Month_Sales__c;
                if(sku.Total_Spend_Impact_12_Month__c != null)
                    AnnualSpendChangeAmt = AnnualSpendChangeAmt+sku.Total_Spend_Impact_12_Month__c;   
                if((sku.Item_12_Month_Sales__c!=null && sku.Item_12_Month_Sales__c!=0.00) && (sku.Total_Spend_Impact_12_Month__c!=null && sku.Total_Spend_Impact_12_Month__c!=0.00)){
                    AvgChange = AvgChange + ((sku.Total_Spend_Impact_12_Month__c/sku.Item_12_Month_Sales__c)*100).setScale(2);                                       
                    
                } 
                Count = Count+1;                   
             }   
            if(range == '9-Months'){                
                if(sku.Item_9_Month_Qty__c != null)
                    AU = AU+ sku.Item_9_Month_Qty__c;
                if(sku.Item_9_Month_Sales__c != null)
                    ASKUSpend= ASKUSpend + sku.Item_9_Month_Sales__c;
                if(sku.Total_Spend_Impact_9_Month__c != null)
                    AnnualSpendChangeAmt = AnnualSpendChangeAmt+sku.Total_Spend_Impact_9_Month__c;     
                if((sku.Item_9_Month_Sales__c!=null && sku.Item_9_Month_Sales__c!=0.00) && (sku.Total_Spend_Impact_9_Month__c!=null && sku.Total_Spend_Impact_9_Month__c!=0.00)){
                    AvgChange = AvgChange + ((sku.Total_Spend_Impact_9_Month__c/sku.Item_9_Month_Sales__c)*100).setScale(2);  
                }
                Count = Count+1;
            }
            if(range == '6-Months'){                
                if(sku.Item_6_Month_Qty__c != null)
                    AU = AU+ sku.Item_6_Month_Qty__c;
                if(sku.Item_6_Month_Sales__c != null)
                    ASKUSpend= ASKUSpend + sku.Item_6_Month_Sales__c;
                if(sku.Total_Spend_Impact_6_Month__c != null)
                    AnnualSpendChangeAmt = AnnualSpendChangeAmt+sku.Total_Spend_Impact_6_Month__c; 
                if((sku.Item_6_Month_Sales__c!=null && sku.Item_6_Month_Sales__c!=0.00) && (sku.Total_Spend_Impact_6_Month__c!=null && sku.Total_Spend_Impact_6_Month__c!=0.00)){
                    AvgChange = AvgChange + ((sku.Total_Spend_Impact_6_Month__c/sku.Item_6_Month_Sales__c)*100).setScale(2);  
            }
            Count = Count+1;
            }
            if(range == '3-Months'){
                if(sku.Item_3_Month_Qty__c != null)
                    AU = AU+ sku.Item_3_Month_Qty__c;
                if(sku.Item_3_Month_Sales__c != null)
                    ASKUSpend= ASKUSpend + sku.Item_3_Month_Sales__c;
                if(sku.Total_Spend_Impact_3_Month__c != null)
                    AnnualSpendChangeAmt = AnnualSpendChangeAmt+sku.Total_Spend_Impact_3_Month__c; 
                if((sku.Item_3_Month_Sales__c!=null && sku.Item_3_Month_Sales__c!=0.00) && (sku.Total_Spend_Impact_3_Month__c!=null && sku.Total_Spend_Impact_3_Month__c!=0.00)){
                    AvgChange = AvgChange + ((sku.Total_Spend_Impact_3_Month__c/sku.Item_3_Month_Sales__c)*100).setScale(2);  
            }
            Count = Count+1;
            }
        }    
        if (AU != null)     
         Annual_Usage = AU;
        Annual_SKU_Spend = ASKUSpend;//Util_Numbers.CurrencyToString(ASKUSpend,'$');        
        Annual_Spend_Change_Amt = AnnualSpendChangeAmt;
        // if (Customer_Spend != null && Customer_Spend != 0)
        //    Total_Spend_Impact = (Annual_Spend_Change_Amt/Customer_Spend)*100;
        
        if (Annual_SKU_Spend != null && Annual_SKU_Spend != 0)
            Total_Spend_Impact = (Annual_Spend_Change_Amt/Annual_SKU_Spend)*100;
            
        
      if(Count != 0)   
        Avg_Change = (AvgChange/Count).setScale(2);            
    }
    
    public PageReference calcRange(){
        generateDataforRange(period);
        return null;
    }
    
    
    public List<Ace_Customer_Core_Changes__c> getskusforCustomer(String aId)
    {
        total_size = [select count() from Ace_Customer_Core_Changes__c where ACE_Customer_Price_Changes__c =:aId ];
    
        return [select id, CoreID__c,//Core ID
                SRM_Differential__c,//SRM Impact
                Proposed_SRM_with_Cap1__c, //Proposed Price With Cap
                //Proposed_New_List_Less_Disc_Without_Cap__c, //Proposed Price Without Cap
                core_description__c,Item_12_Month_Qty__c,Item_9_Month_Qty__c,Item_6_Month_Qty__c,Item_3_Month_Qty__c, //Annual Usage 
                Item_12_Month_Sales__c,Item_9_Month_Sales__c,Item_6_Month_Sales__c,Item_3_Month_Sales__c, // Annual Spend
                Total_Spend_Impact_12_Month__c,Total_Spend_Impact_9_Month__c,Total_Spend_Impact_6_Month__c,Total_Spend_Impact_3_Month__c //Annual Impact
                from Ace_Customer_Core_Changes__c 
                where ACE_Customer_Price_Changes__c =:aId limit :List_size OFFSET :counter];         
         }
     
     public class CustomerCoreDataResponse{
        public String COREID{get;set;}
        public Boolean RENDERCORE{get;set;}
        public Integer SKUCOUNT{get;set;}
        public String CoreDescription{get;set;}
        public String SalesforceCOREID{get;set;}
        public Decimal NEWPRICE{get;set;}
        public Decimal AVGCHANGE{get;set;}
        public Decimal ANNUALUSAGE{get;set;}
        public Decimal ANNUALSKUSPEND{get;set;}
        public Decimal ANNUALSPENDCHANGEAMT{get;set;}
        public Decimal TOTALSPENDIMPACT{get;set;}
        public Decimal SRMIMPACT{get;set;}
    }   
    
     public void nextPage(){
        counter = counter+List_size; 
          
        generateDataforRange(period);
        
    }
    
    public void prevPage(){
        counter = counter-List_size;
        
        generateDataforRange(period);
        
    }
    
    public Boolean getDisablePrevious() {
     
      if (counter>0) return true; else return false;
    }
    
    public Boolean getDisableNext() { 
      if (counter + list_size < total_size) return true; else return false;
    }
    
    

}