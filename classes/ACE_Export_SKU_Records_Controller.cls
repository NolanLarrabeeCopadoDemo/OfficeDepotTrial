public class ACE_Export_SKU_Records_Controller 
{
    public ID CustomerID{get;set;}    
    
    public List<Ace_Customer_SKU_Changes__c> SKU_List{get;set;}
    
    public ACE_Export_SKU_Records_Controller() 
    {
        CustomerID = ApexPages.currentPage().getParameters().get('id');

        SKU_List= new List<Ace_Customer_SKU_Changes__c>();
        
        List<ACE_Customer_Price_Changes__c> lPriceChanges = [SELECT id,Customer__c FROM ACE_Customer_Price_Changes__c WHERE id =: CustomerID ];

        List<Ace_Customer_Core_Changes__c> lCustomerCoreChanges = [Select id,CoreID__c, name, ACE_Customer_Price_Changes__c from Ace_Customer_Core_Changes__c where ACE_Customer_Price_Changes__c =:lPriceChanges ];
        Set<ID> sIDs = new Set<ID>();
        for(Ace_Customer_Core_Changes__c l: lCustomerCoreChanges)
        {  
            sIDs.add(l.id);
        }
        
        SKU_List = [select id,Current_Price_Method__c,Approved_Proposed_Price__c ,
                            Current_Sell_Price__c ,UOM__c ,
                            Sales_Price_Change_Effective_Date__c,
                            Sales_Price_Change_Effective_Date_Approv__c,
                            SKU__c,SKU_Description__c,
                            Ace_Customer_Core_Changes__c,
                            Total_Spend_Impact_12_Month__c,
                            Item_12_Month_Qty__c,
                            SRM_Differential__c,
                            Item_12_Month_Sales__c,
                            ChangeAmount_per__c,
                            Core_s_SKU_Vendor_Name__c,
                            price_Changes_Type__c,
                            Name,SFDC_Contract_Object_ID__c,
                            Proposed_SRM_with_Cap__c,
                            Proposed_SRM_with_Cap1__c,                          
                            Annual_SKU_Spend__c,
                            Old_WATD_SRM__c,
                            Margin_Play__c,
                            Pricing_Method_Percentage__c,
                            Annual_Usage__c,
                            New_WATD_Cost__c,
                            Current_List_Price__c,
                            Dept_Id__c,
                            Status__c,
                            Change_Amount__c,
                            SKU_Last_Update__c,
                            Class_Id__c,CoreList_ID__c,
                            Alt_SKU__c,SKU_Alt__c,
                            Approval__c,QPU__c,New_List_Price__c,  //Added for ROM Item 3C
                            Retail_Price__c,SKU_Governed_By_Active_Written_Agreement__c,Change_Type__c, //Added for ROM Item 32B
                            New_WAPO_Cost__c,Old_WAPO__c,Vendor_OEM_Letters_Required__c,Cap_Amount__c, //Additional fields ROM Item 32B
                            batchId__c from Ace_Customer_SKU_Changes__c where Ace_Customer_Core_Changes__c in: sIDs and Status__c != 'Inactive'
                   			and update_timing_action__c = 'T'];//ROM 10B
        lSKUClass_wrap = new List<SKUClass>();
                
        Set<String> sSKUIDs = new Set<String>();
        map<String,Ace_Customer_SKU_Changes__c> map_Alt_SKU = new map<String,Ace_Customer_SKU_Changes__c>();
        for(Ace_Customer_SKU_Changes__c s : SKU_List)
        {
            sSKUIDs.add(s.SKU__c);
            if(s.Alt_SKU__c){
                map_Alt_SKU.put(s.SKU__c,s);
            }
        }

        for(Ace_Customer_SKU_Changes__c s : SKU_List)
        {
           
            SKUClass sw = new SKUClass();
            sw.sku = s;
            sw.actionValue = 'test';
            String skudesc = s.SKU_Description__c;
            system.debug('<<<<<<<s.SKU_Last_Update__c>>>>>>>>'+s.SKU_Last_Update__c);
            
            if(s.SKU_Last_Update__c!=null){
            system.debug('<<<<<<<<<<<<Date format>>>>>>>>>>>>'+s.SKU_Last_Update__c.format());
            sw.SKULastUpdate = s.SKU_Last_Update__c.format();
            }
            if (s.Item_12_Month_Qty__c != null)                                        
             sw.ANNUALUSAGE = math.abs(s.Item_12_Month_Qty__c);
            if (s.Item_12_Month_Sales__c != null)
             sw.ANNUALSKUSPEND = math.abs(s.Item_12_Month_Sales__c);
            if (s.Total_Spend_Impact_12_Month__c != null)
             sw.ANNUALSPENDCHANGEAMT = math.abs(s.Total_Spend_Impact_12_Month__c);
            if (s.Item_12_Month_Sales__c != null && s.Item_12_Month_Sales__c != 0 && s.Total_Spend_Impact_12_Month__c != null)
             sw.TOTALSPENDIMPACT = math.abs(((s.Total_Spend_Impact_12_Month__c/s.Item_12_Month_Sales__c)*100).setScale(2));
            
            system.debug('@@@@@skudesc '+skudesc );
            if(skudesc.contains(',')){
                sw.MSKUDESC = '"'+s.SKU_Description__c+'"';
                system.debug('@@@@@'+sw.MSKUDESC);
            }
            else{
                sw.MSKUDESC = skudesc;
            }
            if (s.Sales_Price_Change_Effective_Date_Approv__c != null)
             sw.EffDate = s.Sales_Price_Change_Effective_Date_Approv__c.format(); 
            
            //ROM Item 3C           
            if (s.QPU__c != null && s.QPU__c != '')
             sw.QPU = decimal.valueof(s.QPU__c);
            
            sw.APPRV = s.Approval__c;
            sw.NEWCURRLISTPRICE = s.New_List_Price__c;
            //ROM Item 3C
            sw.RETAILPRICE = s.Retail_Price__c;  //ROM Item 32
            
            if(s.price_Changes_Type__c != null)
            {
                if(s.price_Changes_Type__c == 'C')
                    sw.ChangeType = 'Cost';
                else if(s.price_Changes_Type__c == 'M' && s.Margin_Play__c == 'S'){
                    sw.ChangeType = 'Margin Swap';
                }
                else if(s.price_Changes_Type__c == 'M' && s.Margin_Play__c == 'L'){
                    sw.ChangeType = 'Margin Lift';
                }    
                else if(s.price_Changes_Type__c == 'A')
                    sw.ChangeType = 'Alternate';
                else if(s.price_Changes_Type__c == 'D')
                    sw.ChangeType = 'Discontinued';
            }            
            
            if(s.SKU_Alt__c != null && map_Alt_SKU.get(s.SKU_Alt__c) != null){
               
                //lines for alt sku             
                sw.SKUID = map_Alt_SKU.get(s.SKU_Alt__c).SKU__c;
                sw.SKUDESC = '"'+map_Alt_SKU.get(s.SKU_Alt__c).SKU_Description__c+'"'; 
                sw.PROPIMUPER = map_Alt_SKU.get(s.SKU_Alt__c).Proposed_SRM_with_Cap__c;
                sw.PROPPRICE  = map_Alt_SKU.get(s.SKU_Alt__c).Approved_Proposed_Price__c;
                sw.PROPIMU = map_Alt_SKU.get(s.SKU_Alt__c).Proposed_SRM_with_Cap1__c;
                sw.ANNSPNDINC = map_Alt_SKU.get(s.SKU_Alt__c).Total_Spend_Impact_12_Month__c;
                sw.WATDCOST = map_Alt_SKU.get(s.SKU_Alt__c).New_WATD_Cost__c;
                sw.ALTCURRRETPRICE = 0;//map_Alt_SKU.get(s.SKU_Alt__c).Current_List_Price__c;
                sw.ALTCURRLISTPRICE = map_Alt_SKU.get(s.SKU_Alt__c).Current_List_Price__c;
                sw.ALTUOM = map_Alt_SKU.get(s.SKU_Alt__c).UOM__c;
                
                if (map_Alt_SKU.get(s.SKU_Alt__c).QPU__c != null && map_Alt_SKU.get(s.SKU_Alt__c).QPU__c != '')
                 sw.ALTQPU = decimal.valueof(map_Alt_SKU.get(s.SKU_Alt__c).QPU__c);  //mm
                
                sw.ALTCURRPUR = 0; //map_Alt_SKU.get(s.SKU_Alt__c).UOM__c;
                sw.ALTPRICEMETHOD = map_Alt_SKU.get(s.SKU_Alt__c).Current_Price_Method__c;
                sw.ALTMETHODID = map_Alt_SKU.get(s.SKU_Alt__c).Current_Price_Method__c;
                sw.ALTPBSKU = map_Alt_SKU.get(s.SKU_Alt__c).Current_Price_Method__c;
                sw.ALTRMSCODE = map_Alt_SKU.get(s.SKU_Alt__c).Current_Price_Method__c;
                sw.AltPrimaryVendor = map_Alt_SKU.get(s.SKU_Alt__c).Core_s_SKU_Vendor_Name__c;
                //sw.AltPrice = map_Alt_SKU.get(s.SKU_Alt__c).Current_Sell_Price__c;
                sw.AltPrice = map_Alt_SKU.get(s.SKU_Alt__c).Approved_Proposed_Price__c;
                sw.AltChangeAmount = map_Alt_SKU.get(s.SKU_Alt__c).Change_Amount__c;
                sw.AltperIncrease = map_Alt_SKU.get(s.SKU_Alt__c).ChangeAmount_per__c;
                if(map_Alt_SKU.get(s.SKU_Alt__c).Total_Spend_Impact_12_Month__c!= null)
                sw.AltANNUALSPENDCHANGEAMT = math.abs(map_Alt_SKU.get(s.SKU_Alt__c).Total_Spend_Impact_12_Month__c);
                if (map_Alt_SKU.get(s.SKU_Alt__c).Sales_Price_Change_Effective_Date_Approv__c != null)
                 sw.AEffDate = map_Alt_SKU.get(s.SKU_Alt__c).Sales_Price_Change_Effective_Date_Approv__c.format();
             
                sw.ALTNEWLISTPRICE = map_Alt_SKU.get(s.SKU_Alt__c).New_List_Price__c; //ROM Item 3C   
   
                sw.ALTRETAILPRICE = map_Alt_SKU.get(s.SKU_Alt__c).Retail_Price__c;  //ROM Item 32   
            }           
             
            if(s.Price_Changes_Type__c !='A')
                lSKUClass_wrap.add(sw);
        }
    }
     
    public List<SKUClass> lSKUClass_wrap {get;set;}
    public Class SKUClass
    {
        public Ace_Customer_SKU_Changes__c sku{get;set;}
        public Decimal QPU{get;set;}
        public String actionValue{get;set;}
        
        public string ChangeType {get;set;}
        public String EffDate {get;set;}
        public string SKULastUpdate {get;set;}
        public String CURRPRICEMETHOD {get;set;}
        public String CONTRACTID {get;set;}
        public String SKUID {get;set;}
        public String SKUDESC {get;set;}
        public Decimal PROPIMUPER {get;set;}
        public Decimal PROPPRICE {get;set;}
        public Decimal PROPIMU {get;set;}
        public Decimal ANNSPNDINC{get;set;}
        public Decimal WATDCOST{get;set;}
        public Decimal ALTCURRRETPRICE{get;set;}
        public Decimal ALTCURRLISTPRICE{get;set;}
        public String ALTUOM{get;set;}
        public Decimal ALTQPU{get;set;}
        public Decimal ALTCURRPUR{get;set;}
        public String ALTPRICEMETHOD{get;set;}
        public String ALTMETHODID{get;set;}
        public String ALTPBSKU{get;set;}
        public String ALTRMSCODE{get;set;}
        public String AltPrimaryVendor {get;set;}
        public Decimal AltPrice {get;set;}
        public Decimal AltChangeAmount {get;set;}
        public Decimal AltperIncrease {get;set;}
        public Decimal AltANNUALSPENDCHANGEAMT {get;set;}
        public String AEffDate {get;set;}
        public string MSKUDESC {get;set;}
        public Decimal ANNUALUSAGE {get;set;}
        public Decimal ANNUALSKUSPEND {get;set;}
        public Decimal ANNUALSPENDCHANGEAMT {get;set;}
        public Decimal TOTALSPENDIMPACT {get;set;}

        public Decimal ALTNEWLISTPRICE {get;set;}   //mm   Added for ROM Item 3C
        public Decimal NEWCURRLISTPRICE {get;set;}  //mm   Added for ROM Item 3C
        public String APPRV {get;set;}              //mm   Added for ROM Item 3C
        
        public String SKUGovernedByActiveWrittenAgreement {get;set;}  //ROM Item 32
        public Decimal RETAILPRICE {get;set;}                         //ROM Item 32
        public Decimal ALTRETAILPRICE {get;set;}                      //ROM Item 32                 
         
    }        
    
}