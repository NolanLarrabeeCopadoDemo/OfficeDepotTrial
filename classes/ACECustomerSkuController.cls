public class ACECustomerSkuController
{

    private final ACE_Customer_Price_Changes__c aceCPC;
    public String DataRange{get;set;}
    public String aId {get;set;}
    public String aName {get;set;}
    public List<CustomerSKUDataResponse> oCustSkuDataResponse {get;set;}
    public List<Ace_Customer_SKU_Changes__c> csku {get;set;}
    public boolean showPageBlockTable {get;set;}
    public Integer NoOfCores {get;set;} 
    public String Annual_Usage{get;set;}
    public Decimal Annual_SKU_Spend{get;set;}
    public Decimal Annual_Spend_Change_Amt{get;set;}
    public Decimal Customer_12_spend{get;set;}
    public Decimal Customer_9_spend{get;set;}
    public Decimal Customer_6_spend{get;set;}
    public Decimal Customer_3_spend{get;set;}
    public Decimal Per_change_Amount{get;set;}
    public Decimal Total_Spend_Impact{get;set;}
    public String AnnualUsage_header{get;set;}
    public String AnnualSKUSpend_header{get;set;}
    public String AnnualSpendChangeAmt_header{get;set;}
    public Decimal Customer_Spend{get;set;}
    public String Customer_Spend_label{get;set;}
    
    
    

    //Controller
    public ACECustomerSkuController(ApexPages.StandardController stdController){
         this.aceCPC = (ACE_Customer_Price_Changes__c)stdController.getRecord();
        if(this.aceCPC.id != null){
            aId = this.aceCPC.id;
        }else{
            aId = ApexPages.currentPage().getParameters().get('aId');
        }
        
        DataRange = '12-Months';
       
        showPageBlockTable = false;
        
        list<ACE_Customer_Price_Changes__c> cpc;
        if(aId != null){
           cpc = [select id,Customer__r.name,customer__r.rolling_12_month_sales__c,customer__r.rolling_9_month_sales__c,customer__r.rolling_6_month_sales__c,customer__r.rolling_3_month_sales__c from ACE_Customer_Price_Changes__c where id= :aId];
            if((cpc != null)&&(cpc.size()>0)){
                aName = cpc[0].Customer__r.name;
                Customer_12_spend = cpc[0].customer__r.rolling_12_month_sales__c;
                Customer_9_spend = cpc[0].customer__r.rolling_9_month_sales__c;
                Customer_6_spend = cpc[0].customer__r.rolling_6_month_sales__c;
                Customer_3_spend = cpc[0].customer__r.rolling_3_month_sales__c;
            }   
        }
        
        if(aId == null || cpc == null || !(cpc.size()>0)){          
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.WARNING,'Id is invalid'));                
        }else{
            generateDataforRange(DataRange);
        }
 
    }//end of the controller
    
    

    
    public void generateDataforRange(String range){
        oCustSkuDataResponse = new List<CustomerSKUDataResponse>();
        List<Ace_Customer_SKU_Changes__c > csku = getskusforCustomer(aId);
        if(range == '12-Months'){
            Customer_Spend = Customer_12_spend; 
            Customer_Spend_label = 'Customer Annual Spend';
        }
        if(range == '9-Months'){
            Customer_Spend = Customer_9_spend;
            Customer_Spend_label = 'Customer 9-Months Spend';
        }
        if(range == '6-Months'){
            Customer_Spend = Customer_6_spend;
            Customer_Spend_label = 'Customer 6-Months Spend';
        }
        if(range == '3-Months'){
         Customer_Spend = Customer_3_spend;
            Customer_Spend_label = 'Customer 3-Months Spend';
        }
        
        
        
        if(csku.size()>0){
         showPageBlockTable = true;// This is to render the table
        for(Ace_Customer_SKU_Changes__c acsc : csku){               
                   CustomerSKUDataResponse c = new CustomerSKUDataResponse();
                        c.SKUID = acsc.SKU__c;
                        c.COREID = acsc.Ace_Customer_Core_Changes__r.name;
                        c.VENDOR  = acsc.Core_s_SKU_Vendor_Name__c;
                        c.CURRENTPRICE = acsc.Current_Sell_Price__c;
                        c.NEWPRICE = acsc.Approved_Proposed_Price__c ;
                        c.CHANGEAMOUNT = acsc.Change_Amount__c;
                        c.CHANGEAMOUTPER = acsc.ChangeAmount_per__c;
                        c.SRMIMPACT = acsc.SRM_Differential__c;
                    // Data from the Range 12 Months
                    if(range == '12-Months'){                                             
                        c.ANNUALUSAGE = acsc.Item_12_Month_Qty__c;
                        c.ANNUALSKUSPEND = acsc.Item_12_Month_Sales__c;
                        c.ANNUALSPENDCHANGEAMT = acsc.Total_Spend_Impact_12_Month__c;
                        if (Customer_Spend != null && Customer_Spend != 0)
                         c.TOTALSPENDIMPACT = ((acsc.Total_Spend_Impact_12_Month__c/Customer_Spend)*100).setScale(2);
                        //Math.round
                                                
                        //Headers
                        AnnualUsage_header = 'Annual Usage';
                        AnnualSKUSpend_header = 'Annual SKU Spend';
                        AnnualSpendChangeAmt_header = 'Annual Spend Change Amt';
                    }
                    if(range == '9-Months'){
                        
                        c.ANNUALUSAGE = acsc.Item_9_Month_Qty__c;
                        c.ANNUALSKUSPEND = acsc.Item_9_Month_Sales__c;
                        c.ANNUALSPENDCHANGEAMT = acsc.Total_Spend_Impact_9_Month__c;
                        if (Customer_Spend != null && Customer_Spend != 0)
                         c.TOTALSPENDIMPACT = ((acsc.Total_Spend_Impact_9_Month__c/Customer_Spend)*100).setScale(2);
                    //Headers                        
                        AnnualUsage_header = '9-Months Usage';
                        AnnualSKUSpend_header = '9-Months SKU Spend';
                        AnnualSpendChangeAmt_header = '9-Months Spend Change Amt';
                    
                    }
                    if(range == '6-Months'){
                        
                        c.ANNUALUSAGE = acsc.Item_6_Month_Qty__c;
                        c.ANNUALSKUSPEND = acsc.Item_6_Month_Sales__c;
                        c.ANNUALSPENDCHANGEAMT = acsc.Total_Spend_Impact_6_Month__c;
                        if (Customer_Spend != null && Customer_Spend != 0)
                         c.TOTALSPENDIMPACT = ((acsc.Total_Spend_Impact_6_Month__c/Customer_Spend)*100).setScale(2);
                    //Headers 
                        AnnualUsage_header = '6-Months Usage';
                        AnnualSKUSpend_header = '6-Months SKU Spend';
                        AnnualSpendChangeAmt_header = '6-Months Spend Change Amt';
                    }
                    if(range == '3-Months'){
                       
                        c.ANNUALUSAGE = acsc.Item_3_Month_Qty__c;
                        c.ANNUALSKUSPEND = acsc.Item_3_Month_Sales__c;
                        c.ANNUALSPENDCHANGEAMT = acsc.Total_Spend_Impact_3_Month__c;
                        if (Customer_Spend != null && Customer_Spend != 0)
                         c.TOTALSPENDIMPACT = ((acsc.Total_Spend_Impact_3_Month__c/Customer_Spend)*100).setScale(2);
                    //Headers
                        AnnualUsage_header = '3-Months Usage';
                        AnnualSKUSpend_header = '3-Months SKU Spend';
                        AnnualSpendChangeAmt_header = '3-Months Spend Change Amt';
                    
                    }
                            
                oCustSkuDataResponse.add(c);
        }
    
            generateSummaryRow(csku, range);
        }
    
    
    }

    public List<Ace_Customer_SKU_Changes__c > getskusforCustomer(Id Accid){
         return [select Id,
                 SKU__c, //SKU
                 Ace_Customer_Core_Changes__r.name, //CORE
                 Core_s_SKU_Vendor_Name__c, //Vendor
                 Current_Sell_Price__c,//Current Price
                 Approved_Proposed_Price__c ,//Proposed_Price__c,// New Price
                 Change_Amount__c,//Change Amount
                 ChangeAmount_per__c, //Chnage Amount %
                 Item_12_Month_Qty__c,Item_9_Month_Qty__c,Item_6_Month_Qty__c,Item_3_Month_Qty__c,//Annual_Usage__c,//Annual Usage
                 Item_12_Month_Sales__c,Item_9_Month_Sales__c,Item_6_Month_Sales__c,Item_3_Month_Sales__c,//Annual SKU Spend
                 Total_Spend_Impact_12_Month__c,Total_Spend_Impact_9_Month__c,Total_Spend_Impact_6_Month__c,Total_Spend_Impact_3_Month__c,//Annual Spend Change Amt
                 SRM_Differential__c //SRM_Impact
                 
                 //Total Spend Impact
                 //SRM Impact
                 from Ace_Customer_SKU_Changes__c where Ace_Customer_Core_Changes__r.ACE_Customer_Price_Changes__c =:Accid  ];
   
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
        
        Annual_Usage = String.valueof(AU); //Util_Numbers.ToString(AU);
        Annual_SKU_Spend = ASKUSpend;//Util_Numbers.CurrencyToString(ASKUSpend,'$');        
        Annual_Spend_Change_Amt = AnnualSpendChangeAmt;
        if (Customer_Spend != null && Customer_Spend != 0)
         Total_Spend_Impact = (Annual_Spend_Change_Amt/Customer_Spend)*100;
        Per_change_Amount = ((AnnualSpendChangeAmt/ASKUSpend)*100).setScale(2);
         
        NoOfCores = lst_sku.size();
    
    }
    
    public PageReference calcRange(){
        generateDataforRange(DataRange);
        return null;
    }
    
        public class CustomerSKUDataResponse{
            public String SKUID{get;set;}
            public String COREID{get;set;}
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
    
        }
   

}