public class ACECustomerPriceChangesButtons { 

  public String redirectURL {get;set;}
  public boolean Redirect {get;set;}
  public boolean recordLockRender {get;set;}
  public boolean recordReLockRender {get;set;}
  public Ace_Customer_Price_Changes__c aceCustPriceChanges {get;set;}
  public Map<String,Boolean> renderMap {get;set;}
  //public String skuContractId{get;set;}
  public ID accountOwnerID {get;set;}
  public String accountCustID{get;set;}
  public String batch {get;set;}
  public boolean checkowner{get;set;}
    
  public boolean allowremediation{get;set;}
  public boolean cancelremediation{get;set;}               //MM ROM Item 23B Code to Cancel Remediation
  public ID aceCustomerPriceChangesID{get;set;}            //MM ROM Item 23B Code to Cancel Remediation
  public ACE_Customer_Price_Changes__c custRec{get;set;}   //MM ROM Item 23B Code to Cancel Remediation
 
  public boolean ownerCheck() {
    if (Userinfo.getUserId() == accountOwnerID)
      return true;
    else
      return false;
  }
  public Boolean AceAccess(){
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
  
  public ACECustomerPriceChangesButtons(ApexPages.StandardController controller) 
  {
    Redirect = false;
    checkowner =ownerCheck();
    recordLockRender = false;
    recordReLockRender = false;
    aceCustPriceChanges = (Ace_Customer_Price_Changes__c)controller.getRecord();
    list<ACE_Settings__c> desettings =[SELECT Id, Name, BatchName__c,LevelxAccess__c,Level1Access__c,Level2Access__c,Level3Access__c,processing_window__c,EsclationDays__c from ACE_Settings__c limit 1];
    user u = [select id,Short_Title__c from user where id=:Userinfo.getUserId() limit 1];

    //batch = ApexPages.currentPage().getParameters().get('batch');
    Ace_Customer_Price_Changes__c ap = [SELECT price_not_calculated__c,Implementation_Status_Code__c,Owning_Customer_Legal__c,Customer_Notification_Date_Approved__c,Owning_Customer_ID__c,customer__r.name,customer__r.rolling_3_month_sales__c,customer__r.rolling_6_month_sales__c,customer__r.rolling_9_month_sales__c,customer__r.rolling_12_month_sales__c,isRemediation__c,Remediation_Hold__c,sales_price_change_effective_date_approv__c,sales_price_change_effective_date_min__c,record_unlock__c,record_unlock_status__c,Remedy_Status__c,customer__r.ownerid,Record_Lock__c,batchId__c, sfdc_notification_flag__c,Exception_Date_Lock__c,Sales_Price_Change_Effective_Date__c from Ace_Customer_Price_Changes__c where ID = :aceCustPriceChanges.ID];
    batch = ap.batchid__c;
    accountOwnerID = ap.customer__r.ownerid;
    accountCustId = ap.Owning_Customer_ID__c;
    System.debug('>>>>>>1>>>>>>>>>'  + ownerCheck());
    System.debug('>>>>>>>2>>>>>>>>'  + ap.Record_Lock__c);
    System.debug('>>>>>>>>3>>>>>>>'  + ap.Exception_Date_Lock__c);
    
    decimal AnnualRevenue = 0;
              
              if (ap.customer__r.rolling_12_month_sales__c != null && ap.customer__r.rolling_12_month_sales__c != 0)
                AnnualRevenue = ap.customer__r.rolling_12_month_sales__c;
              else if (ap.customer__r.rolling_9_month_sales__c != null && ap.customer__r.rolling_9_month_sales__c != 0)
                 AnnualRevenue = ap.customer__r.rolling_9_month_sales__c * (4/3);
              else if (ap.customer__r.rolling_6_month_sales__c != null && ap.customer__r.rolling_6_month_sales__c != 0)
                 AnnualRevenue = ap.customer__r.rolling_9_month_sales__c * 2;
              else if (ap.customer__r.rolling_3_month_sales__c != null && ap.customer__r.rolling_3_month_sales__c != 0)
                 AnnualRevenue = ap.customer__r.rolling_3_month_sales__c * 4;
    
    //Unlock Button Visible when record is locked
    //For CR - STD Crore Customer
    
    if ((ownerCheck() || (accountCustId.contains('99999ACE') && AceAccess())) && ap.Record_Lock__c && ap.record_unlock_Status__c != 'Pending' && ap.Implementation_Status_Code__c != 'DATA-SENT' && ap.Implementation_Status_Code__c != 'DATA-SUCCESS' && ap.Implementation_Status_Code__c != 'DATA-FAILED') { //ownerCheck() && 
      recordLockRender = true;
       
    }
    //For CR - STD Crore Customer
    if ((ownerCheck() || (accountCustId.contains('99999ACE') && AceAccess())) && ap.record_unlock__c) //
      recordReLockRender = true;

    
    if (!ownerCheck() || ap.Record_Lock__c || 'Pending'.equals(ap.Remedy_Status__c) || ap.isRemediation__c || ap.price_not_calculated__c) 
    {
        System.debug('>>>>>>>>4>>>>>>>');
        defaultRendering(false);
        
        //ROM-25 Added price_not_calculated__c in the below line -- If remediation or compliance (price_not_calculated flag = true) WRF is created-- we should restrict the functonalities to salesRep.
        /*if(ap.Record_Lock__c || 'Pending'.equals(ap.Remedy_Status__c) || ap.isRemediation__c || ap.price_not_calculated__c){
            defaultRendering(false);
            recordLockRender = false;//ROM-25
            recordReLockRender = false;//ROM-25
        }*/
        
        if( 'Pending'.equals(ap.Remedy_Status__c) || ap.isRemediation__c || ap.Record_Lock__c || ap.price_not_calculated__c){
        defaultRendering(false);
        recordReLockRender = false;//ROM-25
        }
        if('Pending'.equals(ap.Remedy_Status__c) || ap.isRemediation__c || ap.price_not_calculated__c){
        recordLockRender = false;
        }
                
        
        //For CR - STD Crore Customer
        else if(accountCustId.contains('99999ACE') && AceAccess()){
                renderMap.put('NOTIFY',false); 
                renderMap.put('DATEEXCEP', true); 
                renderMap.put('RELEASE',true); 
        }
    }
    else {
        System.debug('>>>>>>>>5>>>>>>>');
        
        defaultRendering(true);
        
                
         
        if (ap.Exception_Date_Lock__c) {
         renderMap.put('DATEEXCEP', false);
         renderMap.put('RELEASE',false);
        }
        else{ 
             renderMap.put('DATEEXCEP', true);            
             renderMap.put('RELEASE',true);   
             if (ap.Owning_Customer_Legal__c != 'T' && AnnualRevenue < 75000)   
                 renderMap.put('DATEEXCEP', false);  
        }
    }
    
    if (ap.record_unlock__c)
      renderMap.put('RELEASE',false);
     
    if (ap.sfdc_notification_flag__c != '1') { 
     
      //if ((ownerCheck() && ap.Record_Lock__c && !accountCustId.contains('99999ACE')) || (ap.isRemediation__c && ap.Remediation_Hold__c == false && !accountCustId.contains('99999ACE')))
      if ((ownerCheck() && ap.Record_Lock__c && !accountCustId.contains('99999ACE')) && !ap.isRemediation__c && !ap.PRICE_NOT_CALCULATED__c)//ROM-25 COMMENTED ABOVE LINE ---- If remediation(isRemediation__c) or compliance (price_not_calculated flag = true) WRF is created-- we should restrict the functonalities to salesRep.
        renderMap.put('NOTIFY',true);
      else
        renderMap.put('NOTIFY',false);
    }
    else {
      if (ap.Remedy_Status__c == 'Pending' || accountCustId.contains('99999ACE') || !ownerCheck() || ap.record_lock__c == true || ap.Customer_Notification_Date_Approved__c == Date.Today() || ap.isRemediation__c || ap.price_not_calculated__c) //ROM-25 ---- If remediation or compliance (price_not_calculated flag = true) WRF is created-- we should restrict the functonalities to salesRep.
        renderMap.put('NOTIFY',false);
      else
        renderMap.put('NOTIFY',true);
    }
    
    // New code for remediation - 2/26
        boolean allowremediation = false;
        if (desettings[0].LevelxAccess__c != null) {
          String[] titles = desettings[0].LevelxAccess__c.split(';');
          for (integer i=0;i<titles.size();i++) {
            if (u.Short_Title__c == titles[i])
              allowremediation = true;
          }
        }
    // ends 
      
    if(desettings[0]!= null && !ap.Record_Lock__c && !'Pending'.equals(ap.Remedy_Status__c) && !ap.isRemediation__c && !ap.Exception_Date_Lock__c) {
              
              if ((allowremediation || u.Short_Title__c == desettings[0].Level1Access__c || u.Short_Title__c == desettings[0].Level2Access__c || u.Short_Title__c == desettings[0].Level3Access__c) && AnnualRevenue >= 150000) {
               renderMap.put('REMEDIATION',true);
               system.debug('Remediation true');
              }
              else {
               renderMap.put('REMEDIATION',false);
               system.debug('Remediation false');
              }
    }
    //ROM Item 23B Code to Cancel Remediation      
        boolean cancelremediation = false;
        if (desettings[0].LevelxAccess__c != null) {
          String[] titles = desettings[0].LevelxAccess__c.split(';');
          for (integer i=0;i<titles.size();i++) {
            if (u.Short_Title__c == titles[i])
              cancelremediation = true;
          }
        }           
        
    //if(desettings[0]!= null && !ap.Record_Lock__c && 'Pending'.equals(ap.Remedy_Status__c) && !ap.isRemediation__c && !ap.Exception_Date_Lock__c && ap.sales_price_change_effective_date_min__c >= system.Today()-2)  {  
    if(desettings[0]!= null && !ap.Record_Lock__c && 'Pending'.equals(ap.Remedy_Status__c) && !ap.isRemediation__c && !ap.Exception_Date_Lock__c && ap.Implementation_Status_Code__c != 'DATA-SENT' && ap.Implementation_Status_Code__c != 'DATA-SUCCESS' && ap.Implementation_Status_Code__c != 'DATA-FAILED' && ap.sales_price_change_effective_date_min__c -2 >= system.Today())  {      
              if ((cancelremediation || u.Short_Title__c == desettings[0].Level1Access__c || u.Short_Title__c == desettings[0].Level2Access__c || u.Short_Title__c == desettings[0].Level3Access__c) && AnnualRevenue >= 150000) {
               renderMap.put('CANCELREMEDIATION',true);
               system.debug('Cancel Remediation true');
              }
             else {
              renderMap.put('CANCELREMEDIATION',false);
               system.debug('Cancel Remediation false');
              } 
            }
    //ROM Item 23B Code to Cancel Remediation Ends
    
    }
    
    //Ace_Customer_SKU_Changes__c sku = [Select id,SFDC_Contract_Object_ID__c from Ace_Customer_SKU_Changes__c where Ace_Customer_Core_Changes__r.Ace_Customer_Price_Changes__r.id = :aceCustPriceChanges.ID];   
    //skuContractId =  sku.SFDC_Contract_Object_ID__c;   
  
  public void defaultRendering(Boolean val) 
  {
     renderMap = new Map<String,Boolean> ();
     renderMap.put('RELEASE',val);
     renderMap.put('NOTIFY',val);
     renderMap.put('RESPONSE',false); // Replaced by Customer Approval from Sites Page
     renderMap.put('REMEDIATION',false);
     renderMap.put('CANCELREMEDIATION',false); 
     renderMap.put('DATEEXCEP',val);
  }
  
  public void reLock() {
    system.debug('Record reLock');
    ace_customer_price_changes__c p = new ace_customer_price_changes__c(ID = aceCustPriceChanges.ID);
    p.record_unlock__c = false;
    p.record_lock__c = true;
    
    update p; 
    
    Redirect = true;
    redirectURL = '/'+aceCustPriceChanges.id;
  }

  public void releaseButton() {
    Redirect = true;
    redirectURL = '/apex/AceRelease?pchangeid=' + aceCustPriceChanges.id;
  }
  
  public void ReqRemediation(){
      Redirect = true;
      redirectURL = '/apex/ACE_Request_Remediation?pid=' + aceCustPriceChanges.id;
  }
 
//ROM Item 23B Code to Cancel Remediation   
  public void CancelRemediation(){   
                
        ace_customer_price_changes__c custRec = new ace_customer_price_changes__c(ID = aceCustPriceChanges.ID);
         
        custRec.Remedy_Status__c = null;
        custRec.L1_Mgr_Approval_Start_Date__c = null;
        custRec.Remediation_Request_User__c = null;
        update custRec;
      
        Redirect = true;
        redirectURL = '/'+aceCustPriceChanges.id;
  }
//ROM Item 23B Code to Cancel Remediation

  public void DateExceptionButton() {      
    Redirect = true;
    redirectURL = '/apex/AceDateChanges?pid=' + aceCustPriceChanges.id;
  }
  
  public void customerNotificationButton() {
    system.debug('Notification set');
    ace_customer_price_changes__c p = new ace_customer_price_changes__c(ID = aceCustPriceChanges.ID);
    p.Notification_Status_Code__c = 'NOTIFY-SCH';
    p.Customer_Notification_Date_Approved__c = date.today();
    p.Customer_Notification_Date_Rep__c = date.today();
    
    update p; 
    
    Redirect = true;
    redirectURL = '/'+aceCustPriceChanges.id;
  }
  
  public void customerResponseButton() {
    Redirect = true;
    redirectURL = '/apex/apex/AceCustomerResponseLoad?pchangeid=' + aceCustPriceChanges.id;
  }
  
  public void summaryGridRedirect() { 
    Redirect = true;
    redirectURL = '/apex/ACE_Summary_Grid_New?batch=' + batch;
  }  
  
  public void exportSKU() 
  {
    Redirect = true;
    redirectURL = '/apex/apex/ACE_Export_SKU_Records?pchangeid=' + aceCustPriceChanges.id;
  }

  public String comments{get;set;}
  public void triggerApproval()
  {
        System.debug('>>>>>>>>>>>>>>> Trigger Approval');
        if(!Test.isRunningTest()){ 
            Approval.ProcessSubmitRequest req = new Approval.ProcessSubmitRequest();
            req.setComments(comments);
            req.setObjectId(aceCustPriceChanges.Id);
            Approval.ProcessResult result = Approval.process(req);
            system.debug('>>>>>>>'+result);
        }
        Redirect = true;
        redirectURL = '/'+aceCustPriceChanges.id;
        //PageReference pg = new PageReference('/' + aceCustPriceChanges.id);
        //pg.setRedirect(true);
        //return pg;
  }   

}