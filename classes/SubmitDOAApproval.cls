public without sharing class SubmitDOAApproval {
    
    private CameleonCPQ__QxQuote__c accountRecord;
    Id recordId;
    String errorMessage = '';
    public boolean isApproval {set; get;}
    public boolean isEditable {set; get;}
    public string syncStatus {set; get;}
    public string doaStatus {set; get;}
    public CameleonCPQ__QxQuote__c quoteRecord {set; get;}
    public boolean isInvalidProduct{set; get;}
    
    private User managingDirector;
    private User vp;
    private User seniorDirector;
    //private User cpdDirector;
    private User svp;
    private User evp;
    private User cdm;
   // private User cbfsDirector;
    private User cfo;
    private User cbfsvp;
    
    private Decimal salesThreshold1;
    private Decimal salesThreshold2;
    private Decimal salesThreshold3;
    private Decimal salesThreshold4;
    
    private Decimal hardstop1;
    private Decimal hardstop2;
    private Boolean Override_violation;
    public Boolean disabl {get;set;}
    
    public SubmitDOAApproval (ApexPages.StandardController controller)
    {
        this.accountRecord = (CameleonCPQ__QxQuote__c)controller.getRecord();
        recordId = accountRecord.Id;
        quoteRecord = [SELECT Id, Primary_Quote__c,DOA_Program_Update__c,DOA_CPC_Update__c,Existing_Forced_inheritance_no_custom_co__c,Hist_Total_Contract_Sales_Gross__c,CPD_Core_Sales__c,CBFS_Core_Sales__c,PricingAnalyst__c,Senior_Director__c,
                       Managing_Director__c,CameleonCPQ__SyncStatus__c,SVP__c,CPD_Director__c,CBFS_VP__c,CDM__c,CBFS_Director__c,
                       CPM_Cash_Rebate__c,CPM_Cashflow_Test__c,CPM_Contribution_Margin_Perc__c,CPM_Total_Contract_Sales_Gross__c,
                       BSD_Queue__c,Finance_Queue__c,B2B_Integration_Queue__c,VP__c,EVP__c,SVP_OPS__c,DOA_Approval_Status__c,CPM_Perf_Rebate__c,Amendment_Addendum__c,
                       Non_standard_callout_comment_box__c,MFN__c,ownerId,Current_Customer__c,Compliance__c,Customer_Id__c,
                       New_Contract_Amendment_DOA__c,Is_Written_Agreement__c,DOA_Forced_Inheritance_Flag__c, CheckBox_Forced_inheritance__c,
                       DOA_Custom_Price_More_Inherited_Flag__c,DOA_Custom_Price_Less_Inherited_Flag__c,DOA_Item_Count_Violation__c,
                       DOA_Price_Freeze_Violation__c,DOA_Custom_Price_Increase_Flag__c,DOA_Custom_Price_Decrease_Flag__c,
                       DOA_SKU_Below_Floor_Flag__c,Price_Change_Impact_Current_Only__c,Default_Account__c,
                       Default_Account__r.Legal_Flag__c,CameleonCPQ__AccountId__c,CameleonCPQ__AccountId__r.Legal_Flag__c,
                       Default_Parent__c,Default_Parent__r.Legal_Flag__c,Parent__c,Parent__r.Legal_Flag__c,
                       Default_Grandparent__c,Default_Grandparent__r.Legal_Flag__c,Grandparent__c,Annual_Contract_Sales_Gross__c,
                       Grandparent__r.Legal_Flag__c,Default_Great_Grandparent__c, Default_Great_Grandparent__r.Legal_Flag__c,
                       Great_Grandparent__c,Great_Grandparent__r.Legal_Flag__c,No_customization_on_inherited_core_sku__c,Sales_Rep__c,
                       Account_Hosted_Flag__c,CDM_Approver__c,CFO__c,Agreement_Term__c,Documentation_required_to_participate__c,Core_Duplicate__c,
                       LF_Count_Hard_Stop_Follower__c,LF_Count_Hard_Stop_NCC__c,LF_Count_BSD_Pricing__c FROM CameleonCPQ__QxQuote__c
                       WHERE Id = :recordId];
        syncStatus = quoteRecord.CameleonCPQ__SyncStatus__c;
        doaStatus = quoteRecord.DOA_Approval_Status__c ;
        hardstop1 = quoteRecord.LF_Count_Hard_Stop_Follower__c;
        hardstop2 = quoteRecord.LF_Count_Hard_Stop_NCC__c;
    }
    
    public void OnloadPage()
    {
        Decimal finalPrice;
        isApproval = true;
        List<DOA_Approval__mdt> DAM = [SELECT MasterLabel
                                       FROM DOA_Approval__mdt
                                       WHERE MasterLabel = :[SELECT Name FROM Profile WHERE Id = : userInfo.getProfileId()].Name];
        isEditable = DAM.size() > 0;
        system.debug('this keeps the quote non editable'+isEditable);
        //
        List<CameleonCPQ__QxQuoteLine__c> lstQuoteLine = [Select id, Error_Message__c,Sync_Proposed__c From CameleonCPQ__QxQuoteLine__c Where CameleonCPQ__QuoteId__c =: recordId];
        isInvalidProduct = false; 
        if(!lstQuoteLine.isEmpty() && lstQuoteLine.size() >0){
            for(CameleonCPQ__QxQuoteLine__c qli : lstQuoteLine ){
                if(qli.Error_Message__c != null){
                    system.debug('the QLI is'+qli);
                    finalPrice = qli.Sync_Proposed__c ;
                    isInvalidProduct = true;
                    break;
                }
            }
        }
        //
        if (accountRecord.DOA_Approval_Status__c == 'Approval Submitted')
        {
            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.Info, 'Already Submited DOA Approval');
            ApexPages.addMessage(myMsg);
        }
        else if (syncStatus != 'COMPLETE')
        {
            disabl = true;
            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.Info, 'Synchronization status need to be Completed.');
            ApexPages.addMessage(myMsg);
        }
        //
        else if(isInvalidProduct){
            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.Info, 'Unable to Submit for Internal Approval due to core price below 0.01');
            ApexPages.addMessage(myMsg);
        }else if(quoteRecord.Core_Duplicate__c > 0){
            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.Info, 'Unable to submit. Duplicate cores in Pricing Construct not allowed.');
            ApexPages.addMessage(myMsg);
            isInvalidProduct = true;
        }
        //added by Mohit - NAIT-112302
        else if(hardstop1 > 0 || hardstop2 > 0){
            disabl = true;
            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.Info, 'There is a follower flag violation on the quote. Please submit a Leader/Follower sku/NCC change WRF for review.');
            ApexPages.addMessage(myMsg);
        }
        ///
        else{
            // If we have a PROS Quote for this page. Theoretically, this should always be true.
            if (recordId != null)
            {
                // Retrieve the relevant users and load them into their respective instance variables.
                setPotentialApproverValues();
                // Based on some extensive logic, set the proper approvers using the instance variables.
                setQuoteApproverValues();
            }
            isApproval = !shouldAutoApprove();
            if (isApproval == false) {
                quoteRecord.DOA_Approval_Status__c = 'Approved';
                quoteRecord.Approval_Rejection_Comments__c = 'Auto Approved';
                quoteRecord.DOA_Approval_Rejection_Date__c = System.today();
                quoteRecord.Approved_By_Rejected_By__c = userInfo.getUserId() ;
                quoteRecord.Validity_Start__c = System.today();
                SubmitApproval();
            } 
            if (quoteRecord.Finance_Queue__c == false &&
                quoteRecord.CDM_Approver__c != null &&
                quoteRecord.Managing_Director__c != null &&
                quoteRecord.CPD_Director__c != null &&
                quoteRecord.CBFS_Director__c     != null &&
                quoteRecord.Senior_Director__c != null &&
                quoteRecord.VP__c != null &&
                quoteRecord.SVP__c != null &&
                quoteRecord.EVP__c != null &&
                quoteRecord.CFO__c != null) {
                    quoteRecord.DOA_Approval_Status__c = 'Approved';
                    quoteRecord.Approval_Rejection_Comments__c = 'There are no DOA Approvals';
                    quoteRecord.DOA_Approval_Rejection_Date__c = System.today();
                    quoteRecord.Approved_By_Rejected_By__c = userInfo.getUserId() ;
                    quoteRecord.Validity_Start__c = System.today();
                    updateQuoteDOA(quoteRecord);
                }
        }
    }
    
    public static void updateQuoteDOA(CameleonCPQ__QxQuote__c quoteRecord) {
        update quoteRecord;  
    }
    // Returns true if no approvers have been set.
    private boolean shouldAutoApprove() {
        if(quoteRecord.CDM_Approver__c == null &&
           quoteRecord.Managing_Director__c == null &&
           quoteRecord.CPD_Director__c == null &&
           quoteRecord.CBFS_VP__c == null &&
           quoteRecord.Senior_Director__c == null &&
           quoteRecord.VP__c == null &&
           quoteRecord.SVP__c == null &&
           quoteRecord.EVP__c == null &&
           quoteRecord.CFO__c == null &&
           quoteRecord.BSD_Queue__c == false &&
           quoteRecord.Compliance__c == false &&
           quoteRecord.Finance_Queue__c == false &&
           quoteRecord.B2B_Integration_Queue__c == false && quoteRecord.Primary_Quote__c == true) {
               system.debug('Auto Approved123');
               return true;
               
           } 
        return false;
    }
    
    // Populates instance variables representing possible approvers. Logic to
    // determine which of these should actually be an approver is handled elsewhere.
    private void setPotentialApproverValues()
    {
        managingDirector = null;
        vp = null;
        seniorDirector = null;
        //cpdDirector = null;
        svp = null;
        evp = null;
        cdm = null;
       // cbfsDirector = null;
        system.debug('Potential Approvers');
        setConstantApproverValues();
        setUserManagersApproverValues();
    }
    
    // These values are retrieved from the configuration object or from the quote directly.
    private void setConstantApproverValues() {
        DOA_Approval_Paremeters__c ConstantApprovers = [SELECT CPD_Director__c,CBFS_VP__c, CBFS_Director__c, EVP__c, CFO__c,
                                                        Sales_Threshold_1__c, Sales_Threshold_2__c, Sales_Threshold_3__c, Sales_Threshold_4__c
                                                        FROM DOA_Approval_Paremeters__c];
        
        try
        {
           // cpdDirector      = [SELECT Id FROM User WHERE Id = :ConstantApprovers.CPD_Director__c];
          //  cbfsDirector     = [SELECT Id FROM User WHERE Id = :ConstantApprovers.CBFS_Director__c];
            evp              = [SELECT Id FROM User WHERE Id = :ConstantApprovers.EVP__c];
            cfo              = [SELECT Id FROM User WHERE Id = :ConstantApprovers.CFO__c];
            cdm              = [SELECT Id FROM User WHERE Id = :quoteRecord.CDM__c];
            cbfsvp           = [SELECT Id FROM User WHERE Id = :ConstantApprovers.CBFS_VP__c];
        }
        catch (QueryException ex)
        { }
        system.debug('Constant Approvers');
        salesThreshold1 = ConstantApprovers.Sales_Threshold_1__c;
        salesThreshold2 = ConstantApprovers.Sales_Threshold_2__c;
        salesThreshold3 = ConstantApprovers.Sales_Threshold_3__c;
        salesThreshold4 = ConstantApprovers.Sales_Threshold_4__c;
    }
    
    // These values are retrieved from the PROS Quote's Sales Rep.
    private void setUserManagersApproverValues() {
        User currentUser;
        try
        {
            currentUser = [SELECT Id, ManagerId FROM User WHERE Id = :quoteRecord.Sales_Rep__c];
        }
        catch (QueryException ex)
        { }
        system.debug('Manager Approvers');
        managingDirector = findManagerOfUser(currentUser, 'Director');
        seniorDirector   = findManagerOfUser(currentUser, 'Senior Director');
        vp               = findManagerOfUser(currentUser, 'VP');
        svp              = findManagerOfUser(currentUser, 'SVP');
    }
    
    // Goes through the specified User's management hierarchy and finds a
    // User with the specified job code level (Director, Senior Director, etc.)
    User findManagerOfUser(User currentUser, String neededJobCode) {
        // We want to traverse a maximum of 7 times to prevent infinite loops or too many queries
        Integer MAX_TRAVERSAL = 7;
        Integer counter = 1;
        try
        {
            // Get the manager of the first user
            User currentManager = [SELECT Id, Job_Code_Level__c, ManagerId FROM User WHERE Id = :currentUser.ManagerId];
            while (counter < MAX_TRAVERSAL)
            {
                if (currentManager.Job_Code_Level__c != null &&
                    currentManager.Job_Code_Level__c == neededJobCode)
                {
                    // Return this manager if it is the one we need
                    
                    return currentManager;
                }
                // Otherwise get this manager's manager to see if theyre the one
                currentManager = [SELECT Id, Job_Code_Level__c, ManagerId FROM User WHERE Id = :currentManager.ManagerId];
                counter++;
            }
            // Return null if nothing is returned from within the loop
            return null;
        }
        // Catches the exception whenever the Manager field is empty (heirarchy is broken)
        catch (QueryException ex)
        {
            return null;
        }
    }
    
    // Implements logic to set specifiec Users as approvers.
    private void setQuoteApproverValues() {
        system.debug('Quote Approvers');
        // Clearing all Approvers' values
        quoteRecord.CDM_Approver__c = null;
        quoteRecord.Managing_Director__c = null;
        quoteRecord.CPD_Director__c = null;
        quoteRecord.CBFS_VP__c = null;
        quoteRecord.Senior_Director__c = null;
        quoteRecord.VP__c = null;
        quoteRecord.SVP__c = null;
        quoteRecord.EVP__c = null;
        quoteRecord.CFO__c = null;
        
        quoteRecord.BSD_Queue__c = false;
        quoteRecord.Compliance__c = false;
        quoteRecord.Finance_Queue__c = false;
        quoteRecord.B2B_Integration_Queue__c = false;
        
        // Approver values are set, divided into the following three functions.
        setCpmApprovers();
        setMaintenanceApprovers();
        setPricingAndComplianceApproverValues();
    }
    
    // Sets CPM approver values. The logic is split into 5 different sets of approvers.
    private void setCpmApprovers() {
        if(quoteRecord.New_Contract_Amendment_DOA__c != true) return;
        
        if(cdm != null)  quoteRecord.CDM_Approver__c = cdm.Id;
       
        
        if(quoteRecord.CPM_Total_Contract_Sales_Gross__c / quoteRecord.Agreement_Term__c >= 0) {
            system.debug('the conditions are trigger 1 : CPM');
            setCpmApproversType1();
        }
        if(
            quoteRecord.CPM_Cashflow_Test__c == 'FAILS CASHFLOW' ) {
                system.debug('the conditions are trigger 2:CPM');
                setCpmApproversType2();
            }
        if(quoteRecord.CBFS_Core_Sales__c >= 500000) {
            system.debug('the conditions are trigger 3:CPM');
            setCpmApproversType3();
        }
        
        if(quoteRecord.MFN__c == true ) {
            system.debug('the conditions are trigger 4:CPM');
            setCpmApproversType4();
        }
        
        
    }
    
    // Set CPM approvers. How high up the management chain the approvals go is based on the sales amount.
    private void setCpmApproversType1() {
        switch on getCpmBracket() {
            when 1 {
                
                if(cdm != null) quoteRecord.CDM_Approver__c = cdm.Id;
                
                quoteRecord.Finance_Queue__c = true ;
                if(managingDirector != null) quoteRecord.Managing_Director__c = managingDirector.Id;
                if(seniorDirector != null) quoteRecord.Senior_Director__c = seniorDirector.Id;
                
                
            } when 2 {
                
                if(cdm != null) quoteRecord.CDM_Approver__c = cdm.Id;
                quoteRecord.Finance_Queue__c = true;
                if(managingDirector != null) quoteRecord.Managing_Director__c = managingDirector.Id;
                if(seniorDirector != null) quoteRecord.Senior_Director__c = seniorDirector.Id;
                if(vp != null) quoteRecord.VP__c = vp.Id;
                
            } when 3 {
                
                if(cdm != null) quoteRecord.CDM_Approver__c = cdm.Id;
                quoteRecord.Finance_Queue__c = true;
                if(managingDirector != null) quoteRecord.Managing_Director__c = managingDirector.Id;
                if(seniorDirector != null) quoteRecord.Senior_Director__c = seniorDirector.Id;
                if(vp != null) quoteRecord.VP__c = vp.Id;
                if(svp != null) quoteRecord.SVP__c = svp.Id;
                
                
            } when 4 {
                if(cdm != null) quoteRecord.CDM_Approver__c = cdm.Id;
                quoteRecord.Finance_Queue__c = true;
                if(managingDirector != null) quoteRecord.Managing_Director__c = managingDirector.Id;
                if(seniorDirector != null) quoteRecord.Senior_Director__c = seniorDirector.Id;
                if(vp != null) quoteRecord.VP__c = vp.Id;
                if(svp != null) quoteRecord.SVP__c = svp.Id;
                if(evp != null) quoteRecord.EVP__c = evp.Id;
                
                
            } when 5 {
                
                if(cdm != null) quoteRecord.CDM_Approver__c = cdm.Id;
                quoteRecord.Finance_Queue__c = true;
                if(managingDirector != null) quoteRecord.Managing_Director__c = managingDirector.Id;
                if(seniorDirector != null) quoteRecord.Senior_Director__c = seniorDirector.Id;
                if(vp != null) quoteRecord.VP__c = vp.Id;
                if(svp != null) quoteRecord.SVP__c = svp.Id;
                if(evp != null) quoteRecord.EVP__c = evp.Id;
                if(cfo != null) quoteRecord.CFO__c = cfo.Id;
                
                
            }
        }
    }
    private void setCpmApproversType2() {
        switch on getCpmBracket() {
            when 1 {
                if(cdm != null) quoteRecord.CDM_Approver__c = cdm.Id;
                quoteRecord.Finance_Queue__c = true;
                if(managingDirector != null) quoteRecord.Managing_Director__c = managingDirector.Id;
                if(seniorDirector != null) quoteRecord.Senior_Director__c = seniorDirector.Id;
                if(vp != null) quoteRecord.VP__c = vp.Id;
                if(svp != null) quoteRecord.SVP__c = svp.Id;
            } when 2 {
                if(cdm != null) quoteRecord.CDM_Approver__c = cdm.Id;
                quoteRecord.Finance_Queue__c = true;
                if(managingDirector != null) quoteRecord.Managing_Director__c = managingDirector.Id;
                if(seniorDirector != null) quoteRecord.Senior_Director__c = seniorDirector.Id;
                if(vp != null) quoteRecord.VP__c = vp.Id;
                if(svp != null) quoteRecord.SVP__c = svp.Id;
            } when 3 {
                if(cdm != null) quoteRecord.CDM_Approver__c = cdm.Id;
                quoteRecord.Finance_Queue__c = true;
                if(managingDirector != null) quoteRecord.Managing_Director__c = managingDirector.Id;
                if(seniorDirector != null) quoteRecord.Senior_Director__c = seniorDirector.Id;
                if(vp != null) quoteRecord.VP__c = vp.Id;
                if(svp != null) quoteRecord.SVP__c = svp.Id;
            } when 4 {
                if(cdm != null) quoteRecord.CDM_Approver__c = cdm.Id;
                quoteRecord.Finance_Queue__c = true;
                if(managingDirector != null) quoteRecord.Managing_Director__c = managingDirector.Id;
                if(seniorDirector != null) quoteRecord.Senior_Director__c = seniorDirector.Id;
                if(vp != null) quoteRecord.VP__c = vp.Id;
                if(svp != null) quoteRecord.SVP__c = svp.Id;
                if(evp != null) quoteRecord.EVP__c = evp.Id;
            } when 5 {
                if(cdm != null) quoteRecord.CDM_Approver__c = cdm.Id;
                quoteRecord.Compliance__c = true;
                if(managingDirector != null) quoteRecord.Managing_Director__c = managingDirector.Id;
                if(seniorDirector != null) quoteRecord.Senior_Director__c = seniorDirector.Id;
                if(vp != null) quoteRecord.VP__c = vp.Id;
                if(svp != null) quoteRecord.SVP__c = svp.Id;
                if(evp != null) quoteRecord.EVP__c = evp.Id;
                if(cfo != null) quoteRecord.CFO__c = cfo.Id;
            }
        }
    }
    
    private void setCpmApproversType3() {
        switch on getCpmBracket() {
            when 1 {
                if(cdm != null) quoteRecord.CDM_Approver__c = cdm.Id;
                quoteRecord.Finance_Queue__c = true;
                if(managingDirector != null) quoteRecord.Managing_Director__c = managingDirector.Id;
                if(seniorDirector != null) quoteRecord.Senior_Director__c = seniorDirector.Id;
                
            } when 2 {
                if(cdm != null) quoteRecord.CDM_Approver__c = cdm.Id;
                quoteRecord.Finance_Queue__c = true;
                if(cbfsvp != null) quoteRecord.CBFS_VP__c = cbfsvp.id;
                if(managingDirector != null) quoteRecord.Managing_Director__c = managingDirector.Id;
                if(seniorDirector != null) quoteRecord.Senior_Director__c = seniorDirector.Id;
                if(vp != null) quoteRecord.VP__c = vp.Id;
                if(svp != null) quoteRecord.SVP__c = svp.Id;
            } when 3 {
                if(cdm != null) quoteRecord.CDM_Approver__c = cdm.Id;
                quoteRecord.Finance_Queue__c = true;
                 if(cbfsvp != null) quoteRecord.CBFS_VP__c = cbfsvp.id;
                
                if(managingDirector != null) quoteRecord.Managing_Director__c = managingDirector.Id;
                if(seniorDirector != null) quoteRecord.Senior_Director__c = seniorDirector.Id;
                if(vp != null) quoteRecord.VP__c = vp.Id;
                if(svp != null) quoteRecord.SVP__c = svp.Id;
            } when 4 {
                if(cdm != null) quoteRecord.CDM_Approver__c = cdm.Id;
                quoteRecord.Finance_Queue__c = true;
                if(cbfsvp != null) quoteRecord.CBFS_VP__c = cbfsvp.id;
                if(managingDirector != null) quoteRecord.Managing_Director__c = managingDirector.Id;
                if(seniorDirector != null) quoteRecord.Senior_Director__c = seniorDirector.Id;
                if(vp != null) quoteRecord.VP__c = vp.Id;
                if(svp != null) quoteRecord.SVP__c = svp.Id;
                if(evp != null) quoteRecord.EVP__c = evp.Id;
            } when 5 {
                if(cdm != null) quoteRecord.CDM_Approver__c = cdm.Id;
                quoteRecord.Finance_Queue__c = true;
                if(cbfsvp != null) quoteRecord.CBFS_VP__c = cbfsvp.id;
                if(managingDirector != null) quoteRecord.Managing_Director__c = managingDirector.Id;
                if(seniorDirector != null) quoteRecord.Senior_Director__c = seniorDirector.Id;
                if(vp != null) quoteRecord.VP__c = vp.Id;
                if(svp != null) quoteRecord.SVP__c = svp.Id;
                if(evp != null) quoteRecord.EVP__c = evp.Id;
                if(cfo != null) quoteRecord.CFO__c = cfo.Id;
            }
        }
    }
    
    
    private void setCpmApproversType4() {
        switch on getCpmBracket() {
            when 1 {
                if(cdm != null) quoteRecord.CDM_Approver__c = cdm.Id;
                quoteRecord.Compliance__c = true;
                quoteRecord.Finance_Queue__c = true;
                if(managingDirector != null) quoteRecord.Managing_Director__c = managingDirector.Id;
                if(seniorDirector != null) quoteRecord.Senior_Director__c = seniorDirector.Id;
            } when 2 {
                if(cdm != null) quoteRecord.CDM_Approver__c = cdm.Id;
                quoteRecord.Compliance__c = true;
                quoteRecord.Finance_Queue__c = true;
                if(managingDirector != null) quoteRecord.Managing_Director__c = managingDirector.Id;
                if(seniorDirector != null) quoteRecord.Senior_Director__c = seniorDirector.Id;
                if(vp != null) quoteRecord.VP__c = vp.Id;
            } when 3 {
                if(cdm != null) quoteRecord.CDM_Approver__c = cdm.Id;
                quoteRecord.Compliance__c = true;
                quoteRecord.Finance_Queue__c = true;
                if(managingDirector != null) quoteRecord.Managing_Director__c = managingDirector.Id;
                if(seniorDirector != null) quoteRecord.Senior_Director__c = seniorDirector.Id;
                if(vp != null) quoteRecord.VP__c = vp.Id;
                if(svp != null) quoteRecord.SVP__c = svp.Id;
            } when 4 {
                if(cdm != null) quoteRecord.CDM_Approver__c = cdm.Id;
                quoteRecord.Compliance__c = true;
                quoteRecord.Finance_Queue__c = true;
                if(managingDirector != null) quoteRecord.Managing_Director__c = managingDirector.Id;
                if(seniorDirector != null) quoteRecord.Senior_Director__c = seniorDirector.Id;
                if(vp != null) quoteRecord.VP__c = vp.Id;
                if(svp != null) quoteRecord.SVP__c = svp.Id;
                if(evp != null) quoteRecord.EVP__c = evp.Id;
            } when 5 {
                if(cdm != null) quoteRecord.CDM_Approver__c = cdm.Id;
                quoteRecord.Compliance__c = true;
                quoteRecord.Finance_Queue__c = true;
                if(managingDirector != null) quoteRecord.Managing_Director__c = managingDirector.Id;           
                if(seniorDirector != null) quoteRecord.Senior_Director__c = seniorDirector.Id;
                if(vp != null) quoteRecord.VP__c = vp.Id;
                if(svp != null) quoteRecord.SVP__c = svp.Id;
                if(evp != null) quoteRecord.EVP__c = evp.Id;
                if(cfo != null) quoteRecord.CFO__c = cfo.Id;
            }
        }
    }
    
    // Figure out what bracket a quote belongs in based on they're sales amount.
    private Integer getCpmBracket() {        
        if(quoteRecord.Annual_Contract_Sales_Gross__c <= salesThreshold1) {
            system.debug('CPM Bracket is 0-250k');
            return 1;
        } else if(quoteRecord.Annual_Contract_Sales_Gross__c > salesThreshold1 && quoteRecord.Annual_Contract_Sales_Gross__c <= salesThreshold2) {
                        system.debug('CPM Bracket is 250k-3M');

            return 2;
        } else if(quoteRecord.Annual_Contract_Sales_Gross__c > salesThreshold2 && quoteRecord.Annual_Contract_Sales_Gross__c <= salesThreshold3) {
                        system.debug('CPM Bracket is 3M-5m');

            return 3;
        } else if(quoteRecord.Annual_Contract_Sales_Gross__c > salesThreshold3 && quoteRecord.Annual_Contract_Sales_Gross__c <= salesThreshold4) {
            system.debug('CPM Bracket is 5M-10m');
            return 4;
        } else if(quoteRecord.Annual_Contract_Sales_Gross__c > salesThreshold4) {
            system.debug('CPM Bracket is greater than 10M');
            return 5;
        }
        return 0;
    }
    private void setMaintenanceApprovers() {
        if(quoteRecord.New_Contract_Amendment_DOA__c == true) return;
        if(hasWrittenAgreementInHierarchy() != true){
             //system.debug('Mohitttt'+managingDirector.Id);
            if((quoteRecord.Price_Change_Impact_Current_Only__c >= 50000 || quoteRecord.Price_Change_Impact_Current_Only__c <= -50000) && (quoteRecord.Price_Change_Impact_Current_Only__c <= 100000 || quoteRecord.Price_Change_Impact_Current_Only__c >= -100000 )) {
                if(managingDirector != null) quoteRecord.Managing_Director__c = managingDirector.Id;
                system.debug('Maintenance approvals tab:1'+ managingDirector.Id);
            }
            if(quoteRecord.Price_Change_Impact_Current_Only__c > 100000 || quoteRecord.Price_Change_Impact_Current_Only__c < -100000) {
                if(managingDirector != null) quoteRecord.Managing_Director__c = managingDirector.Id;
                if(vp != null) quoteRecord.VP__c = vp.Id;
                system.debug('Maintenance approvals tab:2');
                
            }
            if(quoteRecord.DOA_SKU_Below_Floor_Flag__c == true) {
                if(managingDirector != null) quoteRecord.Managing_Director__c = managingDirector.Id;
                system.debug('Maintenance approvals tab:3');
                
            }
            //add by Mohit
            if(quoteRecord.DOA_CPC_Update__c == true) {
                if(managingDirector != null) quoteRecord.Managing_Director__c = managingDirector.Id;
                
                
            }
        }
        else{  system.debug('MohittttBen');          
            if((quoteRecord.Price_Change_Impact_Current_Only__c >= 50000.00 && quoteRecord.Price_Change_Impact_Current_Only__c <= 100000.00 && quoteRecord.Price_Change_Impact_Current_Only__c != 0.00 ) 
               ||
               
               (quoteRecord.Price_Change_Impact_Current_Only__c <= -50000.00 && quoteRecord.Price_Change_Impact_Current_Only__c >= -100000.00 && quoteRecord.Price_Change_Impact_Current_Only__c != 0.00 ) 
               
               ||
               
               quoteRecord.DOA_SKU_Below_Floor_Flag__c == true
              ) {
                  if(managingDirector != null) quoteRecord.Managing_Director__c = managingDirector.Id;
                  
              }
            if(quoteRecord.Price_Change_Impact_Current_Only__c > 100000 ||quoteRecord.Price_Change_Impact_Current_Only__c < -100000) {
                
                if(managingDirector != null) quoteRecord.Managing_Director__c = managingDirector.Id;
                if(vp != null) quoteRecord.VP__c = vp.Id;
                system.debug('Maintenance approvals tab:5');
                
            }
            if(quoteRecord.DOA_Forced_Inheritance_Flag__c == true || quoteRecord.DOA_Custom_Price_Less_Inherited_Flag__c == true ||
               quoteRecord.DOA_Custom_Price_More_Inherited_Flag__c == true || quoteRecord.DOA_Item_Count_Violation__c == true ||
               quoteRecord.DOA_Price_Freeze_Violation__c == true || quoteRecord.DOA_CPC_Update__c == true || quoteRecord.DOA_Custom_Price_Increase_Flag__c == true) {
                   if(managingDirector != null) quoteRecord.Managing_Director__c = managingDirector.Id;
                   
                   system.debug('Maintenance approvals tab:6'+managingDirector);
                   
               }
            if(quoteHasHierarchyMismatch()) {
                if(managingDirector != null) quoteRecord.Managing_Director__c = managingDirector.Id;
                system.debug('Maintenance approvals tab:7');
                
            }
        }
    }
    private void setPricingAndComplianceApproverValues()
    {
        if(quoteRecord.Account_Hosted_Flag__c) {
            quoteRecord.BSD_Queue__c = true;
            quoteRecord.B2B_Integration_Queue__c = true;    
            system.debug('BSD PRICING TRIGGER 1 ');
            
        } 
        if(quoteRecord.New_Contract_Amendment_DOA__c) {
            quoteRecord.Compliance__c = true;
            system.debug('Pricing compliance trigger 1 - Post Approvals');
            
        }
        if(quoteRecord.Documentation_required_to_participate__c == 'Member enrollment' && quoteRecord.DOA_Program_Update__c == true) {
            quoteRecord.Compliance__c = true;
            system.debug('Pricing compliance trigger 2 -Post Approvals');
            
            
        }
        if(quoteRecord.DOA_Forced_Inheritance_Flag__c && quoteRecord.New_Contract_Amendment_DOA__c == false) {
            quoteRecord.Compliance__c = true;
            system.debug('Pricing compliance trigger 3-Pre Approval');
            
        }
        
        if((quoteRecord.DOA_Custom_Price_Decrease_Flag__c ||  quoteRecord.DOA_Custom_Price_Increase_Flag__c  )&& quoteRecord.New_Contract_Amendment_DOA__c ==false) {
            quoteRecord.Compliance__c = true;
            system.debug('Pricing compliance trigger 4 and 5-Pre Approval');
            
        }
        
        if(quoteHasHierarchyMismatch() && hasWrittenAgreementInHierarchy()) {
            quoteRecord.Compliance__c = true;
            quoteRecord.BSD_Queue__c =true;
            system.debug('PRICING COMPLIANCE TRIGGER 6 Pre Approval');
            
        }
        if(quoteHasHierarchyMismatch() && hasWrittenAgreementInHierarchy() && quoteRecord.DOA_CPC_Update__c) {
            quoteRecord.BSD_Queue__c =true;
            quoteRecord.Compliance__c = true;
            system.debug('PRICING COMPLIANCE TRIGGER 7 and 8 Pre Approval');
            
        }
        
        if(quoteRecord.DOA_CPC_Update__c && hasWrittenAgreementInHierarchy()) {
            quoteRecord.Compliance__c = true;
            //quoteRecord.BSD_Queue__c =true;                //Changes done by Asif Khan as part of NAIT-150418
            system.debug('PRICING COMPLIANCE TRIGGER 9 Pre Approval');
            
        }
        //Changes done by Asif Khan as part of NAIT-150418
       /* if(quoteRecord.DOA_CPC_Update__c && hasNonWrittenAgreementInHierarchy()) {
            quoteRecord.BSD_Queue__c =true;
            system.debug('PRICING COMPLIANCE TRIGGER 10 Pre Approval');
        }*/
         if(quoteHasHierarchyMismatch() && hasNonWrittenAgreementInHierarchy()) {
            quoteRecord.BSD_Queue__c =true;
            }
        if(quoteRecord.LF_Count_BSD_Pricing__c > 0){
            quoteRecord.BSD_Queue__c =true;
        }
    }
    
    private boolean quoteHasHierarchyMismatch()
    {
        if (quoteRecord.Default_Parent__c != quoteRecord.Parent__c ||
            quoteRecord.Default_Grandparent__c != quoteRecord.Grandparent__c ||
            quoteRecord.Default_Great_Grandparent__c != quoteRecord.Great_Grandparent__c)
        {
            return true;
        }
        return false;
    }
    
    public PageReference SubmitApproval()
    {
        update quoteRecord;
        if (quoteRecord.New_Contract_Amendment_DOA__c == true && quoteRecord.CDM__c == null)
        {
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR, 'CDM field must have a value.'));
            return null;
        }
        if (isApproval == true && quoteRecord.New_Contract_Amendment_DOA__c == false )
        {
            Approval.ProcessSubmitRequest approvalRequest = new Approval.ProcessSubmitRequest();
            approvalRequest.setComments('Submitting request for approval.Maintenance');
            approvalRequest.setObjectId(quoteRecord.Id);
            approvalRequest.setSubmitterId(quoteRecord.ownerId);
            approvalRequest.setProcessDefinitionNameOrId('Non_CPM_Approvals');
            approvalRequest.setSkipEntryCriteria(true);
            Approval.ProcessResult approvalResult = Approval.process(approvalRequest);
            System.assert(approvalResult.isSuccess());
            if (approvalResult.isSuccess())
            {
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.INFO, 'Submitted for Approval.'));
            }
        } else if(quoteRecord.New_Contract_Amendment_DOA__c == true && isApproval == true) {
            Approval.ProcessSubmitRequest approvalRequest = new Approval.ProcessSubmitRequest();
            approvalRequest.setComments('Submitting request for approval.Non Maintenance');
            approvalRequest.setObjectId(quoteRecord.Id);
            approvalRequest.setSubmitterId(quoteRecord.ownerId);
            approvalRequest.setProcessDefinitionNameOrId('CPM_Approvals_LF');
            approvalRequest.setSkipEntryCriteria(true);
            Approval.ProcessResult approvalResult = Approval.process(approvalRequest);
            System.assert(approvalResult.isSuccess());
            if (approvalResult.isSuccess())
            {
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.INFO, 'Submitted for Approval.'));
            }
        }
        else if (isApproval == false)
        {
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.INFO, 'Auto Approved.'));
        }
        
        return null;
    }
    public PageReference Cancel()
    {
        PageReference pr = new PageReference('/' + recordId);
        pr.setRedirect(true);
        return pr;
    }
    
    // Check if there is a written agreement in either the quote or inheritance hierarchy.
    public boolean hasWrittenAgreementInHierarchy()
    {
        if (quoteRecord.Default_Account__r.Legal_Flag__c == 'Y' ||
            quoteRecord.CameleonCPQ__AccountId__r.Legal_Flag__c == 'Y' ||
            quoteRecord.Default_Parent__r.Legal_Flag__c == 'Y' ||
            quoteRecord.Parent__r.Legal_Flag__c == 'Y' ||
            quoteRecord.Default_Grandparent__r.Legal_Flag__c == 'Y' ||
            quoteRecord.Grandparent__r.Legal_Flag__c == 'Y' ||
            quoteRecord.Default_Great_Grandparent__r.Legal_Flag__c == 'Y' ||
            quoteRecord.Great_Grandparent__r.Legal_Flag__c == 'Y')
        {
            
            return true;
        }
       
        return false;
    }
    // Check if there is a Non written agreement in either the quote or inheritance hierarchy.
    public boolean hasNonWrittenAgreementInHierarchy()
    {
        if (quoteRecord.Default_Account__r.Legal_Flag__c == 'N' ||
            quoteRecord.CameleonCPQ__AccountId__r.Legal_Flag__c == 'N' ||
            quoteRecord.Default_Parent__r.Legal_Flag__c == 'N' ||
            quoteRecord.Parent__r.Legal_Flag__c == 'N' ||
            quoteRecord.Default_Grandparent__r.Legal_Flag__c == 'N' ||
            quoteRecord.Grandparent__r.Legal_Flag__c == 'N' ||
            quoteRecord.Default_Great_Grandparent__r.Legal_Flag__c == 'N' ||
            quoteRecord.Great_Grandparent__r.Legal_Flag__c == 'N')
        {
            return true;
        }
        return false;
    }
}