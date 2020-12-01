public class ACEUpload_File {
    public string fileToUpload{get;set;}
    public Blob content{get;set;}
    String[] filelines = new String[]{};
    public String AccessLevel {get;set;}
    public Boolean IsRemedy{get;set;}
    Public Boolean renderErrTable{get;set;}
    Public Ace_Customer_Price_Changes__c CustRec;
    public List<csvErrList> ErrList{get;set;}
    public integer val;
    public Boolean disableUpload {get;set;}

    public class custException extends Exception{}    

    public Blob contentFile{get;set;}
    public ID selectedCustomer {get;set;}
    public String selectedCustomerName {get;set;}
    String[] filelines1 = new String[]{};
    public Blob content1{get;set;} 
    public string fileNameRem{get;set;}
    public string fileNameHost{get;set;}
    public class uploadException extends Exception{}
    public static String CURRPRICEMETHODNULL= 'Current Price Method is Null';   
            
    public ACEUpload_File(){    
        //Set AccessLevel - Starts
        disableUpload = false;
          AccessLevel = 'GENERAL';
          selectedCustomer = ApexPages.currentPage().getParameters().get('selectedCustomer');
          selectedCustomerName = ApexPages.currentPage().getParameters().get('selectedCustomerName');
          
          For (Group g : [select id,name from group where name in ('Remediation Team')]) 
             for (groupMember gm : [SELECT id from groupmember where groupid = :g.id and UserOrGroupId = :userinfo.getUserId()])
             {   AccessLevel = 'REMEDIATION'; IsRemedy = true; }
                
          For (Group g : [select id,name from group where name in ('Hosted Catalog Team')]) 
             for (groupMember gm : [SELECT id from groupmember where groupid = :g.id and UserOrGroupId = :userinfo.getUserId()])
             {   AccessLevel = 'HOSTED'; IsRemedy = false;}

        // Set AccessLevel - Ends
        
        CustRec = [select id, Remediation_Hold__c from Ace_Customer_price_Changes__c where id=:selectedCustomer];
        if(CustRec.Remediation_Hold__c == false){
            disableUpload = true; system.debug('~~~~~~~~disableUpload'+CustRec.id+' '+CustRec.Remediation_Hold__c);}
        else{    
            disableUpload = false;system.debug('~~~~~~~~'+CustRec.Remediation_Hold__c);}
        
    }
    
    //Wrapper for Excel columns
    public class CSVWrapper{
        public String Action{get;set;}
        public String CurrentMethod{get;set;}
        public String ContractId{get;set;}
        public String SKU{get;set;}
        public String SKUDesc{get;set;}
        public Decimal PropIMU{get;set;}
        public Decimal PropPrice{get;set;}        
        public Decimal EstAnnualSpend{get;set;}
        public Decimal PropIMUDoll{get;set;}
        public Decimal CurrSellPrice{get;set;}        
        public Decimal CurrSKUIMU{get;set;}
        public Decimal AnnSpendInc{get;set;}
        public Decimal PriceMethodPer{get;set;}
        public Decimal Item12MonthQnty{get;set;}
        public String Sold{get;set;}
        public String SVT{get;set;}
        public String UOM{get;set;}        
        public String SKUQPU{get;set;}
        public Decimal NewWATDCost{get;set;}
        public Decimal CurrRetPrice{get;set;}
        public Decimal CurrListPrice{get;set;}
        public String DeptId{get;set;}        
        public String ClassId{get;set;}
        public String PrivateBand{get;set;}
        public String RMSProcCode{get;set;}
        public Decimal Item12MonthSale{get;set;}
        public Date EffDate{get;set;}
        public Decimal HisTotCost{get;set;}
        public Decimal HisIMUPer{get;set;}
        public Decimal HisIMUDoll{get;set;}
        public String AddToCore{get;set;}
        
        public String ASKU{get;set;}
        public String ASKUDesc{get;set;}
        public Decimal APropIMU{get;set;}
        public Decimal APropPrice{get;set;}
        public Decimal APropPriceIMUDoll{get;set;}
        public Decimal AAnnSpndInc{get;set;}
        public Decimal ANewWATDCost{get;set;}        
        public Decimal ACurrRetPrice{get;set;}
        public Decimal ACurrListPrice{get;set;}
        public String AUOM{get;set;}
        public Decimal ASKUQPU{get;set;}
        public Decimal ASKUCurrPurch{get;set;}
        public String APriceMethod{get;set;}
        public String AMethodId{get;set;}
        public String APrivateBand{get;set;}
        public String AProcFlag{get;set;} 
        public Date AEffDate{get;set;} 
        
        public String Identifier {get;set;}
        public String AIdentifier {get;set;}    
        
        public String ChangeType{get;set;}  //MM ROM Item 32B
        public String SKUGovernedByActiveWrittenAgreement {get;set;}  //MM ROM Item 32
        public Decimal NewWapoCost {get;set;} //MM ROM Item 32
        public Decimal OldWapoCost {get;set;} //MM ROM Item 32
        public String VendorOEMLettersRequired {get;set;} //MM ROM Item 32
        public Decimal CapAmount {get;set;} //MM ROM Item 32
        public String SKULastChangeDate {get;set;}
    }
    
    public class csvErrList{
        public String SKU{get;set;}
        public String ErrorMsg{get;set;}
    }
    
    //decimal check for csv values
    public double doublevalue(String inputval){
        if(inputval != null && inputval != '')
            return double.valueof(inputval);
        else
            return null;
    }
    
    //method for Uploading remedy files    
    public Pagereference Remedy_ReadFile(){
        set<String> skuSet = new set<String>();
        map<String,String> map_CSVWrapperVal = new map<String,String>();
        map<String,String> map_CSVWrapperVal2 = new map<String,String>();
        String requestKey,engineControlID;
        
        List<CSVWrapper> csvList = new List<CSVWrapper>();  
        List<CSVWrapper> csvList2 = new List<CSVWrapper>();
                
        ErrList = new List<csvErrList>();
        
        Map<String,Ace_Customer_SKU_Changes__c > skuMap = new Map<String,Ace_Customer_SKU_Changes__c >();
        Map<String,String> skuMap2 = new Map<String,String>();
        Map<String,String> coreMap = new Map<String,String>();
        List<Ace_Customer_SKU_Changes__c> skuList = new List<Ace_Customer_SKU_Changes__c>();
        //LIST<AggregateResult> SKUCount = new LIST<AggregateResult> (); 
        
                     
        if(contentFile!=null){
        String fileToUpload=contentFile.toString();
        
        if(!''.equals(fileToUpload) && fileToUpload != null){
            filelines = fileToUpload.split('\n');
        }
        filelines.remove(0);
        try{                                                        
            
            //Querying out SKUs for the particular Customer            
            skuList = [Select id, Current_Price_Method__c,
                                     SKU__c,SKU_Description__c,
                                     Proposed_Price_with_Cap__c,Proposed_Price_Without_Cap__c,
                                     Sales_Price_Change_Effective_Date_Approv__c,Sales_Price_Change_Effective_Date__c,
                                     Proposed_SRM_with_Cap__c,Proposed_SRM_with_Cap1__c,
                                     Approved_Proposed_Price__c,Price_Changes_Type__c,
                                     Current_Sell_Price__c,CoreList_ID__c,
                                     Old_WATD_SRM__c,
                                     Total_Spend_Impact_12_Month__c,
                                     Pricing_Method_Percentage__c,
                                     Annual_Usage__c,
                                     UOM__c,New_WATD_Cost__c,
                                     Current_List_Price__c,Alt_SKU__c,
                                     Request_Key__c,
                                     VCC_ENGINE_CONTROL_ID__c,
                                     Dept_Id__c,
                                     Class_Id__c,
                                     Status__c,
                                     Annual_SKU_Spend__c,Ace_Customer_Core_Changes__r.id,Vendavo_Update_Date__c,
                                     SKU_Alt__c,
                                     Change_Type__c,SKU_Governed_By_Active_Written_Agreement__c,  //MM ROM Item 32B
                                     New_WAPO_Cost__c,Old_WAPO__c,                     //MM ROM Item 32B
                                     Vendor_OEM_Letters_Required__c,Cap_Amount__c,SKU_Last_Update__c  //MM ROM Item 32B
                                     from Ace_Customer_SKU_Changes__c where Ace_Customer_Core_Changes__r.ACE_Customer_Price_Changes__r.id=:selectedCustomer];
            Integer SKUCount = [select count() from Ace_Customer_SKU_Changes__c where Ace_Customer_Core_Changes__r.ACE_Customer_Price_Changes__r.id=:selectedCustomer and Alt_SKU__c = false and Status__c != 'Inactive'];                         
            //adding the sku records to the map.
            for(Ace_Customer_SKU_Changes__c sk:skuList){
                String skuIdentifier = sk.SKU__c+sk.CoreList_ID__c;
                requestKey = sk.Request_Key__c;
                engineControlID = sk.VCC_ENGINE_CONTROL_ID__c;
                skuMap.put(skuIdentifier,sk);
                if(sk.Price_Changes_Type__c == 'A'){
                    String AskuIdentifier = sk.SKU__c+sk.CoreList_ID__c;
                    skuMap2.put(AskuIdentifier,sk.Price_Changes_Type__c);
                    
                }
                coreMap.put(sk.CoreList_ID__c,sk.Ace_Customer_Core_Changes__r.id);               
            }
            
            //This is used while adding to wrapperlist
            Integer Row=0;
            //Building Wrapper list for CSV file values
            for (Integer i=0;i<filelines.size();i++){
                
                Row++;
                String[] inputvalues = new String[]{};
                inputvalues = filelines[i].split(',');
                skuSet.add(String.valueof(inputvalues[3]));
                
                //Code for adding csv values to wrapper list
                CSVWrapper csv = new CSVWrapper();
                csv.Action = (String.valueof(inputvalues[0])).trim();
                csv.CurrentMethod = String.valueof(inputvalues[1]);                
                csv.ContractId = String.valueof(inputvalues[2]);
                csv.SKU = String.valueof(inputvalues[3]);                
                
                if(inputvalues[4].startsWith('"'))
                {
                    system.debug('$$$$$'+inputvalues[4]);
                    for (Integer j=4;j<inputvalues.size();j++)
                    {
                        inputvalues[j] = inputvalues[j].replace('""','!@#$%^&*');
                        system.debug('$$$$$');
                        if(inputvalues[4].endsWith('"')&&j==4) {                          
                           csv.SKUDesc = inputvalues[4].replace('"','');
                           val = 5;
                           system.debug('$$$$$csv.SKUDesc'+csv.SKUDesc);
                           break;               
                        }
                       
                        if(inputvalues[j].endsWith('"')&&j!=4)
                        {
                            csv.SKUDesc = csv.SKUDesc+' '+inputvalues[j];
                            val=j+1;
                            system.debug('$$$$$csv.SKUDesc'+csv.SKUDesc);
                            break;
                        }
                        if (csv.SKUDesc!=null)
                        {
                            
                            csv.SKUDesc = csv.SKUDesc+' '+inputvalues[j]+',';
                            system.debug('$$$$$csv.SKUDesc'+csv.SKUDesc);
                        }
                        Else
                        {
                            
                            csv.SKUDesc = ' '+inputvalues[j]+',';
                            system.debug('$$$$$csv.SKUDesc'+csv.SKUDesc);
                        }    
                    }
                }
                else
                {
                    
                    csv.SKUDesc = ' '+inputvalues[4];
                    val=5;
                    system.debug('$$$$$csv.SKUDesc'+csv.SKUDesc);
                }
                if (csv.SKUDesc != null) {
                    
                  csv.SKUDesc = csv.SKUDesc.replace('""','!@#$%^&*');
                  csv.SKUDesc = csv.SKUDesc.replace('"','');
                  csv.SKUDesc = csv.SKUDesc.replace('!@#$%^&*','"');
                  system.debug('$$$$$csv.SKUDesc'+csv.SKUDesc);
                }
                
                string descrp = String.valueof(csv.SKUDesc);
                descrp = descrp.replace('!','');
                descrp = descrp.replace('@','');
                descrp = descrp.replace('#','');
                descrp = descrp.replace('$','');
                descrp = descrp.replace('%','');
                descrp = descrp.replace('^','');
                descrp = descrp.replace('&','');
                descrp = descrp.replace('*','');
                descrp = descrp.replace('(','');
                descrp = descrp.replace(')','');
                descrp = descrp.replace('-','');
                descrp = descrp.replace('_','');
                descrp = descrp.replace('+','');
                descrp = descrp.replace('=','');
                descrp = descrp.replace('{','');
                descrp = descrp.replace('}','');
                descrp = descrp.replace('[','');
                descrp = descrp.replace(']','');
                descrp = descrp.replace('"','');
                descrp = descrp.replace('|','');
                descrp = descrp.replace('.','');
                descrp = descrp.replace(';','');
                descrp = descrp.replace(':','');
                descrp = descrp.replace('?','');
                descrp = descrp.replace('>','');
                descrp = descrp.replace('<','');
                descrp = descrp.replace('/','');
                descrp = descrp.replace('~','');
                descrp = descrp.replace('`','');                
                csv.SKUDesc = descrp;
//MM ROM Item 32B   
                csv.CurrListPrice = doublevalue(inputvalues[val]);
                val++;
                csv.SKUQPU = String.valueof(inputvalues[val]);
                val++;
                csv.ASKUQPU = doublevalue(inputvalues[val]);
                val++;
                csv.ChangeType = String.valueof(inputvalues[val]);
                val++;
                csv.SKUGovernedByActiveWrittenAgreement = String.valueof(inputvalues[val]);
                val++;
                csv.NewWapoCost = doublevalue(inputvalues[val]);
                val++;
                csv.OldWapoCost = doublevalue(inputvalues[val]);
                val++;
                csv.VendorOEMLettersRequired = String.valueof(inputvalues[val]);
                val++;
                csv.CapAmount = doublevalue(inputvalues[val]);
                val++;
                csv.SKULastChangeDate = String.valueof(inputvalues[val]); 
                val++;                
//ROM Item 32B                        
                csv.PropIMU = doublevalue(inputvalues[val]);
                val++;
                csv.PropPrice = doublevalue(inputvalues[val]);
                val++;
                system.debug('???????inputvalues[val]'+csv.PropPrice);
                csv.EstAnnualSpend = doublevalue(inputvalues[val]);
                val++;
                csv.PropIMUDoll = doublevalue(inputvalues[val]);
                val++;
                csv.CurrSellPrice = doublevalue(inputvalues[val]);
                val++;
                csv.CurrSKUIMU = doublevalue(inputvalues[val]);
                val++;
                csv.AnnSpendInc = doublevalue(inputvalues[val]);
                val++;
                csv.PriceMethodPer = doublevalue(inputvalues[val]);
                val++;
                csv.Item12MonthQnty = doublevalue(inputvalues[val]);
                val++;
                if(inputvalues[val] != null && inputvalues[val] != ''){
                    csv.EffDate = Date.parse(String.valueof(inputvalues[val])); 
                    system.debug('??????inputvalues[val]'+csv.EffDate);
                }    
                else{
                    csv.EffDate = null;
                }    
                val++;
                csv.Sold = String.valueof(inputvalues[val]); 
                val++;
                csv.SVT = String.valueof(inputvalues[val]);
                val++;
                csv.UOM = String.valueof(inputvalues[val]);
                val++;
                csv.NewWATDCost = doublevalue(inputvalues[val]);
                val++;
                csv.CurrRetPrice = doublevalue(inputvalues[val]);
                val++;
                csv.CurrListPrice = doublevalue(inputvalues[val]);
                val++;
               // csv.SKUQPU = String.valueof(inputvalues[val]);        **MOVING ROM Item 32B
               // val++;
                //csv.NewWATDCost = doublevalue(inputvalues[val]);     **MOVING ROM Item 32B
                //val++;
                //csv.CurrRetPrice = doublevalue(inputvalues[val]);    **MOVING ROM Item 32B
                //val++;
                //csv.CurrListPrice = doublevalue(inputvalues[val]);      **MOVING ROM Item 32B
                //val++;
                csv.DeptId = String.valueof(inputvalues[val]);
                val++;
                csv.ClassId = String.valueof(inputvalues[val]);
                val++;
                csv.PrivateBand = String.valueof(inputvalues[val]);
                val++;
                csv.RMSProcCode = String.valueof(inputvalues[val]);
                val++;
                csv.Item12MonthSale = doublevalue(inputvalues[val]);                
                val++;
                csv.HisTotCost = doublevalue(inputvalues[val]);
                val++;
                csv.HisIMUDoll = doublevalue(inputvalues[val]);
                val++;
                csv.HisIMUPer = doublevalue(inputvalues[val]);
                val++;
                csv.AddToCore = String.valueof(inputvalues[val]);                                                
                val++;
                
                if(String.valueof(inputvalues[0]) == 'Alt' && (String.valueof(inputvalues[val]) != null || String.valueof(inputvalues[val]) != '')){
                    system.debug('@@@@>>>inputvalues[val]'+inputvalues[val]);
                    csv.ASKU = String.valueof(inputvalues[val]);
                    
                    val++;
                    integer a_val = val;
                    if(inputvalues[a_val].startsWith('"'))
                    {
                        system.debug('$$$$$'+inputvalues[a_val ]);
                        for (Integer j=a_val;j<inputvalues.size();j++)
                        {
                            inputvalues[j] = inputvalues[j].replace('""','!@#$%^&*');
                            system.debug('$$$$$');
                            if(inputvalues[val].endsWith('"')&&j==a_val) {                          
                               csv.ASKUDesc = inputvalues[a_val].replace('"','');
                               val = a_val+1;
                               system.debug('$$$$$csv.ASKUDesc'+csv.ASKUDesc);
                               break;               
                            }
                           
                            if(inputvalues[j].endsWith('"')&&j!=a_val)
                            {
                                csv.ASKUDesc = csv.ASKUDesc+' '+inputvalues[j];
                                val=j+1;
                                system.debug('$$$$$csv.ASKUDesc'+csv.ASKUDesc);
                                break;
                            }
                            if (csv.ASKUDesc!=null)
                            {
                                csv.ASKUDesc = csv.ASKUDesc+' '+inputvalues[j]+',';
                                system.debug('$$$$$csv.ASKUDesc'+csv.ASKUDesc);
                            }
                            Else
                            {
                                csv.ASKUDesc = ' '+inputvalues[j]+',';
                                system.debug('$$$$$csv.ASKUDesc'+csv.ASKUDesc);
                            }    
                        }
                    }
                    else
                    {
                        csv.ASKUDesc = ' '+inputvalues[a_val];
                        val=a_val+1;
                        system.debug('$$$$$csv.ASKUDesc'+csv.ASKUDesc);
                    }
                    if (csv.ASKUDesc != null) {
                      csv.ASKUDesc = csv.ASKUDesc.replace('""','!@#$%^&*');
                      csv.ASKUDesc = csv.ASKUDesc.replace('"','');
                      csv.ASKUDesc = csv.ASKUDesc.replace('!@#$%^&*','"');
                      system.debug('$$$$$csv.ASKUDesc'+csv.ASKUDesc);
                    }
                    
                    
                    system.debug('@@@@>>>inputvalues[val]'+inputvalues[val]);
                    //csv.ASKUDesc = String.valueof(inputvalues[val++]);                  
                    
                    csv.APropIMU = doublevalue(inputvalues[val]);
                    val++;
                    csv.APropPrice = doublevalue(inputvalues[val]);
                    val++;                    
                    csv.APropPriceIMUDoll = doublevalue(inputvalues[val]);
                    val++;
                    csv.AAnnSpndInc = doublevalue(inputvalues[val]);
                    val++;
                    csv.ANewWATDCost = doublevalue(inputvalues[val]);
                    val++;
                    csv.ACurrRetPrice = doublevalue(inputvalues[val]);
                    val++;
                    csv.ACurrListPrice = doublevalue(inputvalues[val]);    
                    val++;
                    csv.AUOM = String.valueof(inputvalues[val]);
                    
                    val++;
                    if(inputvalues[val] != null && inputvalues[val] != '')
                        csv.AEffDate = Date.parse(String.valueof(inputvalues[val]));
                    else
                      csv.AEffDate = null;
                    system.debug('@@@@>>>inputvalues[val]'+inputvalues[val]);
                    val++;
                    system.debug('@@@@>>>inputvalues[val]'+inputvalues[val]);
                    //csv.ASKUQPU = doublevalue(inputvalues[val]);  **MOVING
                    csv.ASKUCurrPurch = doublevalue(inputvalues[val++]);
                    csv.APriceMethod = String.valueof(inputvalues[val++]);
                    csv.AMethodId = String.valueof(inputvalues[val++]);
                    csv.APrivateBand = String.valueof(inputvalues[val++]);
                    csv.AProcFlag = String.valueof(inputvalues[val++]); 
                    //system.debug('@@@@>>>>46'+String.valueof(inputvalues[val]));
                    
                    csv.AIdentifier = csv.ASKU+csv.AddToCore;
                }  
                csv.Identifier = csv.SKU+csv.AddToCore;  
                system.debug('@@@@>>>CSV Values' +csv);
                //To remove Duplicates
                if(!map_CSVWrapperVal.containsKey(csv.Identifier)){ 
                    system.debug('@@@@>>>To remove duplicates');
                    map_CSVWrapperVal.put(csv.Identifier,csv.SKU);
                    
                    if(csv.Action != 'New'){
                        map_CSVWrapperVal2.put(csv.Identifier,csv.SKU);
                    }
                    csvList.add(csv);
                }
                
                //adding to error list
                if(csv.Action == 'Alt' && (csv.ASKU == null || csv.ASKU == '')){
                    system.debug('@@@@>>>adding to error list');
                    csvErrList err = new csvErrList();
                    err.SKU = String.valueof(inputvalues[3]);
                    err.ErrorMsg = 'Alt SKU does not for SKU: '+err.SKU+' .';
                    ErrList.add(err);
                }
                else if(csv.SKU == null && csv.AddToCore == null){
                    system.debug('@@@@>>>adding to error list');
                    csvErrList err = new csvErrList();                    
                    err.ErrorMsg = 'SKU ID / Core ID is Missing';
                    ErrList.add(err);
                }
                else if((csv.Action == 'New' || csv.Action == '' || csv.Action == null) && (csv.EffDate == null || csv.PropPrice == null)){
                        system.debug('@@@@>>>adding to error list'+csv.EffDate +csv.PropPrice);
                        csvErrList err = new csvErrList();
                        err.SKU = String.valueof(inputvalues[3]);
                        err.ErrorMsg = 'Mandatory fields[Effective Date / Proposed Price] missing for SKU: '+err.SKU+' .';
                        ErrList.add(err);
                }
                else if(csv.Action == 'Alt' && (csv.AEffDate == null || csv.APropPrice == null)){
                        system.debug('@@@@>>>adding to error list');
                        csvErrList err = new csvErrList();
                        err.SKU = String.valueof(inputvalues[3]);
                        err.ErrorMsg = 'Mandatory fields[Effective Date / Proposed Price] missing for Alt AKU of SKU: '+err.SKU+' .';
                        ErrList.add(err);
                }
                
                                    
                // grouping skus which already exist in obj to compare with skus from obj
                if(csv.Action != 'New'){
                    
                    if(map_CSVWrapperVal.containsKey(csv.Identifier)){
                        
                        csvList2.add(csv); system.debug('>>>>>csv.SKU:' +csv.SKU);
                    }
                }
                // If new SKU exists in the system. map_CSVWrapperVal2 will contain non new skus.
                else{
                    if(map_CSVWrapperVal2.containsKey(csv.Identifier)){ //changed to map_CSVWrapperVal2 from map_CSVWrapperVal - 09/24
                        csvErrList err = new csvErrList();
                        err.SKU = String.valueof(inputvalues[3]);
                        err.ErrorMsg = 'Action: New - Record Already Exist in the System for SKU -'+err.SKU+' .';
                        ErrList.add(err);
                    }
                }
                
                if(ErrList.size() >= 20){
                    renderErrTable = true;
                    throw new CustException ('Error: Upload Failed due to following errors');
                }
                
            }
            
            //Error Block - Stage 1: General Data Validations -  Starts
            
            if(csvList2.size() > SKUCount){
                system.debug('@@@@>>>>>csvList2:' +csvList2.size());
                system.debug('@@@@>>>>>SKUCount:' +SKUCount);
                csvErrList err = new csvErrList();
                err.ErrorMsg = 'Existing Sku Count does not match with the SKU count under the Customer.';
                ErrList.add(err);
                renderErrTable = true;
                throw new CustException ('Error: SKU count in the customer does not match with the count of existing SKUs from CSV template / Few New SKUs exist in system. Please recheck the CSV Template ');
                
            }
            else if(ErrList.size()>0){
                //system.debug('@@@@>>>>ErrList:'+ErrList.size());                
                //for(csvErrList er:ErrList){
                //    system.debug('@@@@>>>>'+er.ErrorMsg);
                ///}
                renderErrTable = true;    
                throw new CustException ('Error: Upload Failed due to following errors');
                
            }        
            //Error Block - Stage 1: General Data Validations - Ends
            
            
            
            
            
            if(ErrList.size()<1){ 
                List<Date> lEffDateMax = new List<Date>();
                Date EffDateMax;
                Date EffDateMin;
                //Creating 2 list for update and insertion records                                     
                List<Ace_Customer_SKU_Changes__c> lskuUpdate = new List<Ace_Customer_SKU_Changes__c>();
                List<Ace_Customer_SKU_Changes__c> lskuInsert = new List<Ace_Customer_SKU_Changes__c>();
                List<Ace_Customer_Price_Changes__c> lcusUpdate = new List<Ace_Customer_Price_Changes__c>();
                //Looping through the CSV wrapper
                for( CSVWrapper s: csvList){
                                
                    //For Alt Actions
                    if(s.Action == 'Alt'){
                        system.debug('@@@@>>>For Alt Actions');
                        if(skuMap.get(s.AIdentifier) != null){
                            system.debug('@@@@>>>For Alt Actions');
                            Ace_Customer_SKU_Changes__c sku = skuMap.get(s.Identifier);
                            sku.Status__c = 'Deleted';
                            sku.SKU_Alt__c = skuMap.get(s.AIdentifier).SKU__c;
                        
                            Ace_Customer_SKU_Changes__c sku1 = skuMap.get(s.AIdentifier);      
                            sku1.Current_List_Price__c = s.CurrListPrice;  //MM
                            //sku1.Change_Type__c = s.ChangeType; //MM
                            sku1.SKU_Governed_By_Active_Written_Agreement__c = s.SKUGovernedByActiveWrittenAgreement; //MM
                            sku1.New_WAPO_Cost__c = s.NewWapoCost; //MM
                            sku1.Old_WAPO__c = s.OldWapoCost; //MM
                            sku1.Cap_Amount__c = s.CapAmount; //MM
                            //sku1.SKU_Last_Update__c = s.SKULastChangeDate; //MM
                            sku1.status__c = 'Active';
                            sku1.Change_Type__c = 'A';
                            sku1.Approved_Proposed_Price__c = s.APropPrice;
                            sku1.Proposed_Price_with_Cap__c =  s.APropPrice; 
                            sku1.Proposed_Price_Without_Cap__c = s.APropPrice;
                            sku1.Sales_Price_Change_Effective_Date_Approv__c = s.AEffDate;
                            sku1.Sales_Price_Change_Effective_Date__c = s.AEffDate;
                            sku1.Vendavo_Update_Date__c = system.now();
                            sku1.Alt_SKU__c = true;
                            lskuUpdate.add(sku);
                            lskuUpdate.add(sku1); 
                            // to find the max of effective date
                            lEffDateMax.add(s.AEffDate);
                            
                        }
                        else{
                            system.debug('@@@@>>>For Alt Actions');
                            Ace_Customer_SKU_Changes__c sku = skuMap.get(s.Identifier);
                            sku.Status__c = 'Deleted';
                            sku.SKU_Alt__c = s.ASKU;
                            
                                                           
                            if(s.ASKU != null && s.ASKUDesc != null && s.APropPrice != null && s.APropIMU != null && s.APropPriceIMUDoll != null && 
                                s.ANewWATDCost != null && s.AUOM != null && s.ACurrListPrice != null && s.APriceMethod != null && s.DeptId != null && s.ClassId != null &&
                                s.AddToCore != null)
                            { 
                                system.debug('@@@@>>>For Alt Actions');
                                Ace_Customer_SKU_Changes__c sku1 = new Ace_Customer_SKU_Changes__c();                      
                                sku1.SKU__c = s.ASKU;
                                sku1.SKU_Description__c = s.ASKUDesc ;
                                sku1.Current_List_Price__c = s.CurrListPrice;  //MM
                            	sku1.Change_Type__c = s.ChangeType; //MM
                            	sku1.SKU_Governed_By_Active_Written_Agreement__c = s.SKUGovernedByActiveWrittenAgreement; //MM
                            	sku1.New_WAPO_Cost__c = s.NewWapoCost; //MM
                            	sku1.Old_WAPO__c = s.OldWapoCost; //MM
                            	sku1.Cap_Amount__c = s.CapAmount; //MM
                            	//sku1.SKU_Last_Update__c = s.SKULastChangeDate; //MM
                                sku1.Approved_Proposed_Price__c = s.APropPrice;
                                sku1.Proposed_Price_with_Cap__c =  s.APropPrice; 
                                sku1.Proposed_Price_Without_Cap__c = s.APropPrice;
                                sku1.Sales_Price_Change_Effective_Date_Approv__c = s.AEffDate;
                                sku1.Sales_Price_Change_Effective_Date__c = s.AEffDate;
                                sku1.Proposed_SRM_with_Cap__c = s.APropIMU;
                                sku1.Proposed_SRM_with_Cap1__c = s.APropPriceIMUDoll;
                                sku1.New_WATD_Cost__c = s.ANewWATDCost;
                                sku1.UOM__c = s.AUOM;
                                sku1.Current_List_Price__c = s.ACurrListPrice;
                                sku1.Current_Price_Method__c = s.APriceMethod;
                                sku1.Dept_Id__c = s.DeptId;
                                sku1.Class_Id__c = s.ClassId;
                                sku1.status__c = 'Active';
                                sku1.Change_Type__c = 'A';
                                sku1.Alt_SKU__c = true;
                                sku1.Vendavo_Update_Date__c = system.now();
                                sku1.CoreList_ID__c = s.AddToCore; 
                                sku1.Ace_Customer_Core_Changes__c = String.valueof(coreMap.get(s.AddToCore));
                                sku1.Request_Key__c = requestKey;
                                sku1.VCC_ENGINE_CONTROL_ID__c = engineControlId;
                                lskuInsert.add(sku1);
                                lskuUpdate.add(sku);
                                // to find the max of effective date
                                lEffDateMax.add(s.AEffDate); 
                            }
                            else{
                                system.debug('@@@@>>>For Alt Actions');
                                csvErrList err = new csvErrList();
                                err.SKU = s.SKU;
                                err.ErrorMsg = 'Required fields missing for AltSKU of SKU: '+err.SKU+' .';
                                ErrList.add(err);  
                            }
                        }                                        
                    }         
                               
                    //For Blank Actions
                    //S-434786 (OD 00777602) Connor Flynn null actions come in as a string with value 'null'
                    //if(s.Action == '' || s.Action == null){
                    if(s.Action == '' || s.Action == null || s.Action == 'null'){
                        //S-434786 (OD 00777602) Connor Flynn End
                        system.debug('@@@@>>>For Blank Actions' + s.Identifier);
                        system.debug('### skuMap: ' + skuMap);
                        if(skuMap.get(s.Identifier) != null){
                            system.debug('@@@@>>>For Blank Actions'+s.EffDate);
                            if(s.PropPrice != null && s.EffDate != null){
                                system.debug('@@@@>>>For Blank Actions'+s.EffDate);
                                Ace_Customer_SKU_Changes__c sku = skuMap.get(s.Identifier);
                                sku.Current_List_Price__c = s.CurrListPrice;  //MM
                            	sku.Change_Type__c = s.ChangeType; //MM
                            	sku.SKU_Governed_By_Active_Written_Agreement__c = s.SKUGovernedByActiveWrittenAgreement; //MM
                            	sku.New_WAPO_Cost__c = s.NewWapoCost; //MM
                            	sku.Old_WAPO__c = s.OldWapoCost; //MM
                            	sku.Cap_Amount__c = s.CapAmount; //MM
                            	//sku1.SKU_Last_Update__c = s.SKULastChangeDate; //MM
                                sku.Approved_Proposed_Price__c = s.PropPrice;
                                sku.Proposed_Price_with_Cap__c =  s.PropPrice; 
                                sku.Proposed_Price_Without_Cap__c = s.PropPrice;                                
                                sku.Sales_Price_Change_Effective_Date_Approv__c = s.EffDate;
                                sku.Sales_Price_Change_Effective_Date__c = s.EffDate;
                                sku.Vendavo_Update_Date__c = system.now();
                                lskuUpdate.add(sku);
                                // to find the max of effective date
                                lEffDateMax.add(s.EffDate);
                                
                                if(s.AIdentifier != null){
                                    if(skuMap.get(s.AIdentifier) != null){
                                        if(s.APropPrice != null && s.AEffDate != null){
                                            Ace_Customer_SKU_Changes__c sku1 = skuMap.get(s.AIdentifier);                          
                                            sku1.status__c = 'Active';
                                            sku1.Change_Type__c = 'A';
                                            sku1.Approved_Proposed_Price__c = s.APropPrice;
                                            sku1.Proposed_Price_with_Cap__c =  s.APropPrice; 
                                            sku1.Proposed_Price_Without_Cap__c = s.APropPrice;
                                            sku1.Sales_Price_Change_Effective_Date_Approv__c = s.AEffDate;
                                            sku1.Sales_Price_Change_Effective_Date__c = s.AEffDate;
                                            sku1.Alt_SKU__c = true;
                                            sku1.Vendavo_Update_Date__c = system.now();
                                            lskuUpdate.add(sku1);
                                            // to find the max of effective date
                                            lEffDateMax.add(s.AEffDate);
                                        }
                                        else{
                                            system.debug('@@@@>>>For Blank Actions');
                                            csvErrList err = new csvErrList();
                                            err.SKU = s.SKU;
                                            err.ErrorMsg = 'Proposed price/Effective date does not exist for Alt SKU for SKU: '+err.SKU+' .';
                                            ErrList.add(err);
                                        }
                                    }
                                    else{
                                        if(s.ASKU != null && s.ASKUDesc != null && s.APropPrice != null && s.APropIMU != null && s.APropPriceIMUDoll != null && 
                                            s.ANewWATDCost != null && s.AUOM != null && s.ACurrListPrice != null && s.APriceMethod != null && s.DeptId != null && s.ClassId != null &&
                                            s.AddToCore != null){
                                            Ace_Customer_SKU_Changes__c sku1 = new Ace_Customer_SKU_Changes__c();
                                            sku1.SKU__c = s.ASKU;
                                            sku1.SKU_Description__c = s.ASKUDesc ;
                                            //sku1.Current_List_Price__c = s.CurrListPrice;  //MM
                           					sku1.Change_Type__c = s.ChangeType; //MM
                            				sku1.SKU_Governed_By_Active_Written_Agreement__c = s.SKUGovernedByActiveWrittenAgreement; //MM
                            				sku1.New_WAPO_Cost__c = s.NewWapoCost; //MM
                            				sku1.Old_WAPO__c = s.OldWapoCost; //MM
                            				sku1.Cap_Amount__c = s.CapAmount; //MM
                            				//sku1.SKU_Last_Update__c = s.SKULastChangeDate; //MM    
                                            sku1.Approved_Proposed_Price__c = s.APropPrice;
                                            sku1.Proposed_Price_with_Cap__c =  s.APropPrice; 
                                            sku1.Proposed_Price_Without_Cap__c = s.APropPrice;
                                            sku1.Sales_Price_Change_Effective_Date_Approv__c = s.AEffDate;
                                            sku1.Sales_Price_Change_Effective_Date__c = s.AEffDate;
                                            sku1.Vendavo_Update_Date__c = system.now();
                                            sku1.Proposed_SRM_with_Cap__c = s.APropIMU;
                                            sku1.Proposed_SRM_with_Cap1__c = s.APropPriceIMUDoll;
                                            sku1.New_WATD_Cost__c = s.ANewWATDCost;
                                            sku1.UOM__c = s.AUOM;
                                            sku1.Current_List_Price__c = s.ACurrListPrice;
                                            sku1.Current_Price_Method__c = s.APriceMethod;
                                            sku1.Dept_Id__c = s.DeptId;
                                            sku1.Class_Id__c = s.ClassId;
                                            sku1.status__c = 'Active';
                                            sku1.Change_Type__c = 'A';
                                            sku1.Alt_SKU__c = true;
                                            sku1.CoreList_ID__c = s.AddToCore; 
                                            sku1.Ace_Customer_Core_Changes__c = String.valueof(coreMap.get(s.AddToCore));
                                            sku1.Request_Key__c = requestKey;
                                            sku1.VCC_ENGINE_CONTROL_ID__c = engineControlId;
                                            lskuInsert.add(sku1);
                                            // to find the max of effective date
                                            lEffDateMax.add(s.EffDate);
                                        }
                                        else{
                                            system.debug('@@@@>>>For Alt Actions');
                                            csvErrList err = new csvErrList();
                                            err.SKU = s.SKU;
                                            err.ErrorMsg = 'Required fields missing for AltSKU of SKU: '+err.SKU+' .';
                                            ErrList.add(err); 
                                        }
                                    }
                                }                                
                            }
                            else{
                                system.debug('@@@@>>>For Blank Actions');
                                csvErrList err = new csvErrList();
                                err.SKU = s.SKU;
                                err.ErrorMsg = 'Proposed price/Effective date does not exist for SKU: '+err.SKU+' .';
                                ErrList.add(err);
                            }                                                         
                        }
                        else{
                            system.debug('@@@@>>>For Blank Actions');
                            csvErrList err = new csvErrList();
                            err.SKU = s.SKU;
                            err.ErrorMsg = 'Upload Failed because there is no matching record in the system with SKU:'+err.SKU+' .';
                            ErrList.add(err);                            
                        }
                    }
                    
                    //For Del Actions
                    if(s.Action == 'Del'){
                        system.debug('@@@@>>>For Del Actions');
                        if(skuMap.get(s.Identifier) != null){
                            system.debug('@@@@>>>For Del Actions');
                            Ace_Customer_SKU_Changes__c sku = skuMap.get(s.Identifier);
                            sku.Status__c = 'Deleted';
                            sku.Change_Type__c = 'D';
                            lskuUpdate.add(sku);
                        }
                        else{
                            system.debug('@@@@>>>For Del Actions');
                            csvErrList err = new csvErrList();
                            err.SKU = s.SKU;
                            err.ErrorMsg = 'Action: Delete - SKU does not exist for SKU: '+err.SKU+' .';
                            ErrList.add(err);
                        }
                    }   
                    
                    //For New Actions
                    if(s.Action == 'New'){
                        system.debug('@@@@>>>For New Actions');
                        if(skuMap.get(s.Identifier) != null){
                            system.debug('@@@@>>>For New Actions');
                            csvErrList err = new csvErrList();
                            err.SKU = s.SKU;
                            err.ErrorMsg = 'Action:'+s.Action+' - SKU: '+err.SKU+' already Exist in the system.';
                            ErrList.add(err);          
                        }
                        else{
                            system.debug('@@@@>>>For New Actions');
                            Ace_Customer_SKU_Changes__c sku1 = new Ace_Customer_SKU_Changes__c();  
                            sku1.SKU__c = s.SKU;
                            sku1.SKU_Description__c = s.SKUDesc;
                            sku1.Current_List_Price__c = s.CurrListPrice;  //MM
                            sku1.Change_Type__c = s.ChangeType; //MM
                            sku1.SKU_Governed_By_Active_Written_Agreement__c = s.SKUGovernedByActiveWrittenAgreement; //MM
                            sku1.New_WAPO_Cost__c = s.NewWapoCost; //MM
                            sku1.Old_WAPO__c = s.OldWapoCost; //MM
                            sku1.Cap_Amount__c = s.CapAmount; //MM
                            //sku1.SKU_Last_Update__c = s.SKULastChangeDate; //MM
                            sku1.Approved_Proposed_Price__c = s.PropPrice;
                            sku1.Proposed_Price_with_Cap__c =  s.PropPrice; 
                            sku1.Proposed_Price_Without_Cap__c = s.PropPrice;                                
                            sku1.Sales_Price_Change_Effective_Date_Approv__c = s.EffDate;
                            sku1.Sales_Price_Change_Effective_Date__c = s.EffDate;
                            sku1.Vendavo_Update_Date__c = system.now();
                            sku1.Proposed_SRM_with_Cap__c = s.PropIMU;
                            sku1.Proposed_SRM_with_Cap1__c = s.PropIMUDoll;
                            sku1.New_WATD_Cost__c = s.NewWATDCost;
                            sku1.UOM__c = s.UOM;
                            //sku1.Current_List_Price__c = s.CurrListPrice;  **MOVING
                            sku1.Current_Price_Method__c = s.CurrentMethod;
                            sku1.Dept_Id__c = s.DeptId;
                            sku1.Class_Id__c = s.ClassId;
                            sku1.status__c = 'Active';
                            sku1.Change_Type__c = 'M';                            
                            sku1.CoreList_ID__c = s.AddToCore;
                            sku1.Ace_Customer_Core_Changes__c = String.valueof(coreMap.get(s.AddToCore));
                            sku1.Request_Key__c = requestKey;
                            sku1.VCC_ENGINE_CONTROL_ID__c = engineControlId;
                            lskuInsert.add(sku1);
                            // to find the max of effective date
                            lEffDateMax.add(s.EffDate);
                        }
                    }  
                
                    if(ErrList.size() >= 20){
                        renderErrTable = true;
                        throw new CustException ('Error: Upload Failed due to following errors');
                    }                                        
                }
                
                //Error Block Stage 2: Validation errors while data mapping
                if(ErrList.size()>0){
                    system.debug('@@@@>>>Error Block Stage 2: Validation errors while data mapping');
                    system.debug('^^^^^^^^'+ErrList.size());                                        
                    throw new CustException ('Error: Upload Failed due to following errors');
                    renderErrTable = true;
                    
                }
                else{
                    renderErrTable = false;
                    system.debug('@@@@>>>ELSE OF Error Block Stage 2: Validation errors while data mapping');
                    //setting save point for rollback
                    Savepoint sp = Database.setSavepoint();
                    // DML for Update and Insert
                    if(lskuUpdate.size() > 0){
                        //system.debug('@@@@>>>>lskuUpdate'+lskuUpdate);
                        update lskuUpdate;
                        system.debug('@@@@>>>>lskuUpdate completed');
                    }                    
                    if(lskuInsert.size() > 0){
                        //system.debug('@@@@>>>>lskuUpdate'+lskuInsert);
                        insert lskuInsert;
                        system.debug('@@@@>>>>lskuUpdate completed');
                    }
                    
                    //updating the customer with effective date max and Remediation Hold
                    lEffDateMax.sort();
                    EffDateMax = lEffDateMax[lEffDateMax.size()-1]; 
                    EffDateMin = lEffDateMax[0];
                    Ace_Customer_Price_Changes__c cust = new Ace_Customer_Price_Changes__c(id=selectedCustomer);
                    cust.Sales_Price_Change_Effective_Date_Approv__c = EffDateMax;
                    if(ErrList.size()<1)
                        cust.Remediation_hold__c= false;
                    if(cust.SFDC_Notification_Flag__c != '1') {
                        cust.Customer_Notification_Date_Approved__c = system.today();
                        cust.Notification_Status_Code__c = 'NOTIFY-SCH';
                    }
                    update cust;
                }   
            }                        
              
            if(ErrList.size()<1){
                ApexPages.Message SuccessMsg= new ApexPages.Message(ApexPages.severity.INFO,'Upload Successful');
                ApexPages.addMessage(SuccessMsg);
                //disableUpload = true;
            }  
                                                                        
        } 
        catch (CustException ce){           
            ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.ERROR,ce.getMessage()));
            return null;
        }                                
        catch (Exception e){
            ApexPages.Message errormsg = new ApexPages.Message(ApexPages.severity.ERROR,e.getMessage());
            ApexPages.addMessage(errormsg);
            return null;
        }
        finally{
            contentFile = null;    
        }                                          
        
        return null;
    }
    else{
        ApexPages.Message ErrMsg= new ApexPages.Message(ApexPages.severity.ERROR,'No file was selected. Please choose a file to upload.');
        ApexPages.addMessage(ErrMsg);
        return null;
    }
    }
    
    
    
    
              
}