public class skuExceptionPageController{
    public String skuID{get;set;}
    public String skuNumber{get;set;}
    public String skuDescription {get;set;}
    public String skuAltDescription {get;set;}
    public String custName{get;set;}
    public String urlID{get;set;}
    public String period{get;set;}
    public String DelSKUALT{get;set;}
    public String viewall{get;set;}//ROM-9
    public Ace_Customer_SKU_Changes__c selectedSKU;
    public Ace_Customer_SKU_Changes__c SKU_ALT;
    public Decimal userProposal{get;set;}
    public Decimal sellPrice{get;set;}
    public Decimal currentPrice {get;set;}
    public String reason{get;set;}
    public String plan{get;set;}
    public String comments{get;set;}
    public String radioOption{get;set;}
    public Decimal result1{get;set;}
    public Decimal result2{get;set;}
    public String SKUALT{get;set;}
    public String CoreList_ID {get;set;}
    public Decimal SKUALTPRICE{get;set;}
    public Decimal annualUsage;
    public boolean altExists {get;set;}
    public boolean delAllowed {get;set;}
    public Boolean renderAltOptions {get;set;}
    public Boolean STDCore{get;set;}
    public static String PRICEEXCEPTIONLOCK = 'LOCK-DATEEXCEPTION';
    
    public class custException extends Exception{}
    
    public skuExceptionPageController(){
        Ace_Customer_SKU_Changes__c selectedSKU = new Ace_Customer_SKU_Changes__c();
        radioOption = 'option1';
        
         //getURL(); // Already called in page action method. Using it in Constructor will decrease the performance of the page so commenting it.
    }
    
    public void getURL(){
        STDCore =false;
        viewall = 'false';//ROM-9
        skuID = ApexPages.currentPage().getParameters().get('skuID');
        custName = ApexPages.currentPage().getParameters().get('custName'); 
        urlID =  ApexPages.currentPage().getParameters().get('ID');  
        period =  ApexPages.currentPage().getParameters().get('period');
        DelSKUALT =  ApexPages.currentPage().getParameters().get('DelSKUALT');
        viewall = ApexPages.currentPage().getParameters().get('viewall');//ROM-9
        delAllowed = true;
        
        if(DelSKUALT == 'true'){
            renderAltOptions = true;
        }    
        selectedSKU = [Select id,name,Ace_Customer_Core_Changes__r.ACE_Customer_Price_Changes__r.id,status__c,IsDeleted__c,User_Proposed_Price__c,
                        Ace_Customer_Core_Changes__r.ACE_Customer_Price_Changes__r.Owning_Customer_ID__c,
                        Approved_Proposed_Price__c,HomePage_Approval_History__c,
                        Proposed_Price__c,
                        Previous_Exception_Impact__c,Margin_Play__c,
                        Current_Sell_Price__c,
                        record_lock_code__c,
                        CoreList_ID__c,
                        Cap_Amount__c,
                        Cap_Calculation_Base__c,
                        sku_description__c,
                        Cap_Format__c,
                        Cap_Scope__c,
                        Cap_Units__c,
                        Price_Changes_Type__c,
                        SKU_Alt__c, Reporting_Price_Modified_By_Approver__c,
                        Approval_Type__c,Alt_SKU__c,Proposed_SRM_with_Cap1__c,
                        Alternate_Chosen_Flag__c, 
                        Ace_Customer_Core_Changes__r.ACE_Customer_Price_Changes__r.Customer__r.Owner.managerid,
                        Ace_Customer_Core_Changes__r.ACE_Customer_Price_Changes__r.Customer__r.Owner.manager.managerid,
                        Ace_Customer_Core_Changes__r.ACE_Customer_Price_Changes__r.Customer__r.Owner.manager.manager.managerid,
                        Item_12_Month_Qty__c,Item_9_Month_Qty__c,Item_6_Month_Qty__c,Item_3_Month_Qty__c from Ace_Customer_SKU_Changes__c where ID =:skuID limit 1];
        SKUALT = selectedSKU.SKU_Alt__c;
        // added by Guha for CR - Standard Core
        if(selectedSKU.Ace_Customer_Core_Changes__r.ACE_Customer_Price_Changes__r.Owning_Customer_ID__c.contains('99999ACE')){
            STDCore = true;
        }
        
        skuNumber = selectedSKU.name;
        skuDescription = selectedSKU.sku_description__c;
        currentPrice = selectedSKU.Current_Sell_Price__c;
        CoreList_ID = selectedSKU.CoreList_ID__c;
        ID CustomerId = selectedSKU.Ace_Customer_Core_Changes__r.ACE_Customer_Price_Changes__r.id;
        
        if (selectedSKU.Price_Changes_Type__c == 'D') {
                renderAltOptions = true;
                delAllowed = false;
        }
        
        //Added for CR - ACE - by Guha
        else if (selectedSKU.Price_Changes_Type__c == 'M' && selectedSKU.Margin_Play__c == 'S') {
                renderAltOptions = true;
                system.debug('@@@@@@');
        }  
        
        if(SKUALT != null){
            
            SKU_ALT = [select id,Proposed_SRM_with_Cap1__c,Proposed_Price_with_Cap__c,Current_Sell_Price__c,sku_description__c from Ace_Customer_SKU_Changes__c where SKU__c=:SKUALT and CoreList_ID__c = :CoreList_ID and Ace_Customer_Core_Changes__r.ACE_Customer_Price_Changes__r.id = :CustomerId LIMIT 1];     
            if(SKU_ALT != null) {
                SKUALTPRICE = SKU_ALT.Proposed_Price_with_Cap__c;
                skuAltDescription = sku_alt.sku_description__c;
                altExists = true;
            }
        }
        
        sellPrice = selectedSKU.Approved_Proposed_Price__c;       
        if (selectedSKU.Item_12_Month_Qty__c != null) 
          annualUsage = selectedSKU.Item_12_Month_Qty__c; 
        else if (selectedSKU.Item_9_Month_Qty__c != null)
          annualUsage = selectedSKU.Item_9_Month_Qty__c * (4/3); 
        else if (selectedSKU.Item_6_Month_Qty__c != null)
          annualUsage = selectedSKU.Item_9_Month_Qty__c * 2; 
        else if (selectedSKU.Item_3_Month_Qty__c != null)
          annualUsage = selectedSKU.Item_9_Month_Qty__c * 4; 
        else
          annualUsage = 0; 
    }
    
    public PageReference continueProcess(){
        PageReference pr;
        if(radioOption == 'delSku'){ 
            //selectedSKU.IsDeleted__c = true  ;         
            selectedSKU.status__c = 'Deleted';            
            update selectedSKU;
            pr = new PageReference('/'+selectedSKU.Ace_Customer_Core_Changes__r.ACE_Customer_Price_Changes__r.id);        
            pr.setRedirect(true);
                      
        }
        else if(radioOption == 'delSkuWithAlt'){
            //Delete SKU from core but replace with Alt ___ at unit price ___
            selectedSKU.status__c = 'Deleted';   
            selectedSKU.Alternate_Chosen_Flag__c = true; 
            if(SKU_ALT != null){
                selectedSKU.Alternate_Margin__c = SKU_ALT.Proposed_SRM_with_Cap1__c;                   
            }
            
            update selectedSKU;
            if(SKU_ALT != null){
                SKU_ALT.status__c = 'Active';
                SKU_ALT.Alt_SKU__c= true;
                
                update SKU_ALT;
            }
            pr = new PageReference('/'+selectedSKU.Ace_Customer_Core_Changes__r.ACE_Customer_Price_Changes__r.id);        
            pr.setRedirect(true);
            //add logic for replacing alt sku below
            
        }
        else if(radioOption == 'KeepSkuandAlt'){
            //Keep SKU on core and add Alt __ at unit price ___
            selectedSKU.Alternate_Chosen_Flag__c = true; 
            if(SKU_ALT != null){
                selectedSKU.Alternate_Margin__c = SKU_ALT.Proposed_SRM_with_Cap1__c;                   
            }
                                
            update selectedSKU;
            if(SKU_ALT != null){
                SKU_ALT.status__c = 'Active';
                SKU_ALT.Alt_SKU__c= true;
                update SKU_ALT;
                pr = new PageReference('/'+selectedSKU.Ace_Customer_Core_Changes__r.ACE_Customer_Price_Changes__r.id);        
                pr.setRedirect(true);
            }
        }
        else{
            pr = new PageReference('/apex/SKU_Exception_Price?skuID='+skuID+'&custName='+custName+'&ID='+urlID+'&period='+period);        
            pr.setRedirect(true);
           
        }
        
        
        return pr;  
    }
    
    public void calcProposed()
    {
        System.debug('>>>>>>>>>>>>>>>>>>>>UserPropsoal:' +userProposal  );
        if(sellPrice != null && (userProposal != null) && (userProposal > 0) ) 
        {
         if (sellPrice > 0 || STDCore)
          result1 = ((userProposal/sellPrice)*100).setScale(2);
         else
          result1 = 0;
        }
        else
         result1 = 0;
        
        if (annualUsage != null && userProposal != null && userProposal > 0 && selectedSKU.Current_Sell_Price__c != null){         
         result2 = (annualUsage*(userProposal-sellPrice)); }
        else{
          result2 = 0; }
    }
    
    public void triggerApproval(){
        Approval.ProcessSubmitRequest req = new Approval.ProcessSubmitRequest();
        req.setComments(comments);
        req.setObjectId(selectedSKU.Id);
        Approval.ProcessResult result = Approval.process(req);
        system.debug('>>>>>>>'+result);
    }
    
    public PageReference Cancel() {
        	PageReference pr;
        
			if(viewall == 'true')
                pr = new  PageReference('/apex/ACE_CustomerSKUList?id='+urlID);            	
            else
                pr = new PageReference('/'+urlID);
        
            pr.setRedirect(true);
            return pr;
    }
    
    public void approvalStep(){
          selectedSKU.Approval_Type__c = null;
          decimal resultForvalidation1=0,resultForvalidation2=0;
          if (selectedSKU.Previous_Exception_Impact__c != null)
            resultForvalidation1 = -1*selectedSKU.Previous_Exception_Impact__c;
          decimal resultForValidation;
          if (result2 != null)
             resultForvalidation2 = -1*result2;
             
          resultForValidation = resultForvalidation1+resultForvalidation2;
             
          if((resultForValidation != null && (resultForValidation > 1 && resultForValidation <= 20000)) || resultForValidation==0){ 
              //selectedSKU.L1_Mgr_Approval_Start_Date__c = System.now();//
              selectedSKU.Approval_Type__c = 1;
              selectedSKU.DSM__c = selectedSKU.Ace_Customer_Core_Changes__r.ACE_Customer_Price_Changes__r.Customer__r.Owner.managerid;              
          }
          else if(resultForValidation != null && (resultForValidation > 20000 && resultForValidation <= 100000)){
              //selectedSKU.L1_Mgr_Approval_Start_Date__c = System.now();
              //selectedSKU.L2_Mgr_Approval_Start_Date__c = System.now();//
              selectedSKU.Approval_Type__c = 2;
              selectedSKU.DSM__c = selectedSKU.Ace_Customer_Core_Changes__r.ACE_Customer_Price_Changes__r.Customer__r.Owner.managerid;
              selectedSKU.RSD__c = selectedSKU.Ace_Customer_Core_Changes__r.ACE_Customer_Price_Changes__r.Customer__r.Owner.manager.managerid;              
          
          }
          else if(resultForValidation != null && resultForValidation > 100000){
              //selectedSKU.L1_Mgr_Approval_Start_Date__c = System.now();
              //selectedSKU.L2_Mgr_Approval_Start_Date__c = System.now();
              selectedSKU.Approval_Type__c = 3;
              //selectedSKU.L3_Mgr_Approval_Start_Date__c = System.now();
              selectedSKU.DSM__c = selectedSKU.Ace_Customer_Core_Changes__r.ACE_Customer_Price_Changes__r.Customer__r.Owner.managerid;
              selectedSKU.RSD__c = selectedSKU.Ace_Customer_Core_Changes__r.ACE_Customer_Price_Changes__r.Customer__r.Owner.manager.managerid;
              selectedSKU.VP__c = selectedSKU.Ace_Customer_Core_Changes__r.ACE_Customer_Price_Changes__r.Customer__r.Owner.manager.manager.managerid;
          
              //
          }
          system.debug('&&&&' +selectedSKU.DSM__c);
          system.debug('&&&&' +selectedSKU.RSD__c);
          system.debug('&&&&' +selectedSKU.VP__c);
    }
    
    public PageReference submitReq(){
        
        if (userProposal == null) {
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Please Enter A Valid Price'));
            return null;
        }
        if((reason == 'Other') && (comments == null || comments =='') )
        { 
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Please enter a value for Additional Comments '));
            return null;
        }
        
        if(userProposal >= selectedSKU.Current_Sell_Price__c || STDCore){
            PageReference pr;
            selectedSKU.Proposed_Price__c = userProposal;
            //selectedSKU.User_Proposed_Price__c = userProposal;
            //Set Lock Code on Record
            selectedSKU.record_lock_code__c = PRICEEXCEPTIONLOCK;
            update selectedSKU;
            
            selectedSKU.HomePage_Approval_History__c = false; // added because every time the exception is raised for same sku record the earlier home page flag is not removed. so we are removing in tis step.
            system.debug('>>>>>>><<<<<<<<<');
            if (((selectedSKU.Cap_Amount__c == null || selectedSKU.Cap_Amount__c == 0) 
                && userProposal >= selectedSKU.Approved_Proposed_Price__c) || (userProposal >= selectedSKU.Approved_Proposed_Price__c && STDCORE)) {
                
                selectedSKU.Approved_Proposed_Price__c = userProposal;
                selectedSKU.record_lock_code__c = null;
                
                // below added to make the update dml to perform 1st and trigger approval
                selectedSKU.Reason_For_Exception_Request__c = reason;
                selectedSKU.Additional_Comments__c = comments;
                if (result2 != null)
                 selectedSKU.Price_Exception_revenue_Impact__c = result2; 
                approvalStep();
                
                update selectedSKU; 
            }
            else if (selectedSKU.Cap_Amount__c != null && selectedSKU.Cap_Amount__c > 0 && userProposal >= selectedSKU.Approved_Proposed_Price__c  && !STDCORE) {
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'The SKU Has a Cap Limit And The Price Cannot Be Increased'));
                return null;
            }
            else{
              selectedSKU.Reason_For_Exception_Request__c = reason;
             
              selectedSKU.Additional_Comments__c = comments;
              if (result2 != null)
                  selectedSKU.Price_Exception_revenue_Impact__c = result2;
              approvalStep(); // condition check for level of user for approval
              system.debug('Approval Type:' + selectedSKU.Approval_Type__c);
              if (selectedSKU.Approval_Type__c != null) {
               selectedSKU.Record_Locked__c = true;
               selectedSKU.Reporting_Price_Modified_By_Approver__c = false;
               update selectedSKU;
               triggerApproval();
              }
              else {
                selectedSKU.Approved_Proposed_Price__c = userProposal;
                if (result2 != null)
                 selectedSKU.Price_Exception_revenue_Impact__c = result2; 
                if (selectedSKU.Previous_Exception_Impact__c != null && selectedSKU.Price_Exception_revenue_Impact__c != null)
                  selectedSKU.Previous_Exception_Impact__c = selectedSKU.Previous_Exception_Impact__c+selectedSKU.Price_Exception_revenue_Impact__c;
                else
                  selectedSKU.Previous_Exception_Impact__c = selectedSKU.Price_Exception_revenue_Impact__c;
              }
              update selectedSKU; 
            }            
            
            if(viewall == 'true')
                pr = new  PageReference('/apex/ACE_CustomerSKUList?id='+urlID);            	
            else
                pr = new PageReference('/'+urlID); 
            
            pr.setRedirect(true);
            return pr;
        }
        else{
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.WARNING,'The Proposed Sales Price can not be lower than the Current Sales Price.'));
            return null;
        }
    }
    

}