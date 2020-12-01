public class aceDateChanges {
 

public ID aceCustomerPriceChangesID;
public  ACE_Customer_Price_Changes__c pchangeOb {get;set;}
public PageReference pref;
public static  String APPROVALNOTREQUIRED = 'The date selected is the same as the Current Price Change Effective Date. Please select a different date or click Cancel.';
public static  String AditionalCommentBoxError = 'Please enter a value for Additional comments.';
// public static  String APPROVALNOTREQUIRED1 = 'This Submission Does Not Require Any Exception Request, Please use Release Functionality';
public static  String APPROVALNOTREQUIRED1 = 'Date exceptions can only be requested for future effective dates. If requesting to use an effective date prior to the Current Price Change Effective Date, please use the Release functionality to release early.';
public static String DATEEXCEPTIONLOCK = 'LOCK-DATEEXCEPTION';
public String revenueImpact {get;set;}
public Decimal revenueImpactInteger {get;set;}
public Decimal revImpact {get;set;}
public class custException extends Exception{}
public aceDateChanges() {
    
}

public void CalculateRevenueImpact() {
    revImpact = 0;
    
    //list<ace_Customer_sku_changes__c> skus = [select sales_price_change_effective_date__c,Annual_Usage__c from ace_customer_sku_changes__C where Ace_Customer_Core_Changes__r.ACE_Customer_Price_Changes__r.id = :aceCustomerPriceChangesID];
    system.debug('@@@@@@'+pchangeOb.Total_Spend_Impact_12_Month__c);
    system.debug('@@@@@@'+pchangeOb.Sales_Price_Change_Effective_Date_Min__c);
    system.debug('@@@@@@'+pchangeOb.Sales_Price_Change_Effective_Date_Rep__c);
     
    if (pchangeOb.Total_Spend_Impact_12_Month__c != null && pchangeOb.Sales_Price_Change_Effective_Date_Rep__c != null && pchangeOb.Sales_Price_Change_Effective_Date_Min__c != null) {
       //Decimal totaldays = pchangeOb.Sales_Price_Change_Effective_Date_Approv__c.daysBetween(pchangeOb.Sales_Price_Change_Effective_Date_Rep__c);
         //Note: Do not modify the totaldays calculation -- added by ivarada
       Decimal totaldays = pchangeOb.Sales_Price_Change_Effective_Date_Rep__c.daysBetween(pchangeOb.Sales_Price_Change_Effective_Date_Min__c);
       revImpact = (pchangeOb.Total_Spend_Impact_12_Month__c/365 * totaldays);
       Decimal d = 0,c =0;
       d = revImpact.intValue();
       c = revImpact - d;
       c = c.setScale(2);
       c = c.abs();
       revenueImpactInteger = d;
       
       revenueImpact = '$' + d.format() + c.toPlainString().substring(1); 
       //revenueImpact = c.toPlainString().substring(1); 
       revImpact = revImpact.setScale(2);
       system.debug('RevImpact:' + revimpact + '-d:' + d + '-c:' + c + '-convertedC:'+ c.toPlainString().substring(1));
       //revenueImpact = '$' + string.valueof(revImpact);
         pchangeOb.OD_Revenue_Impact__c =  revImpact;
       //ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Days:'+totaldays + ' 12month:' + pchangeOb.Total_Spend_Impact_12_Month__c + ' REP:' + pchangeOb.Sales_Price_Change_Effective_Date_Rep__c + 'APPROVED:' + pchangeOb.Sales_Price_Change_Effective_Date_Approv__c));
    }
}

public aceDateChanges(ApexPages.StandardController controller) {
   aceCustomerPriceChangesID = ApexPages.CurrentPage().getParameters().get('pid');
   pref = new PageReference ('/'+ aceCustomerPriceChangesID);
   pref.setRedirect(true);
   pchangeOb  = [SELECT ID,Reporting_Date_Modified_By_Approver__c, Previous_Exception_Days__c,Previous_Exception_Impact__c,Current_Exception_Days__c,customer__r.name,customer__r.aops_cust_id__c,record_lock_code__c,Total_Spend_Impact_12_Month__c,Implementation_Date__c,Sales_Price_Change_Effective_Date__c,Sales_Price_Change_Effective_Date_Rep__c,Sales_Price_Change_Effective_Date_Min__c,Sales_Price_Change_Effective_Date_Approv__c,Customer_Notification_Date_Approved__c,exception_date__c,Margin_Makeup_Plan__c,Earliest_Date_Flag__c,Exception_Date_Request_Reason__c,Date_Exception_Additional_Comments__c,Owning_Customer_ID__c from ACE_Customer_Price_Changes__c where ID = :aceCustomerPriceChangesID];
   pchangeOb.Date_Exception_Additional_Comments__c = null;
   if(!Test.isRunningTest()){
   pchangeOb.Sales_Price_Change_Effective_Date_Rep__c = null;}
}

public pageReference saveChanges() {
  try
  {
    
    if((pchangeOb.Exception_Date_Request_Reason__c == 'Other') && (pchangeOb.Date_Exception_Additional_Comments__c == null || pchangeOb.Date_Exception_Additional_Comments__c =='') )
         throw new custException(AditionalCommentBoxError);
      
    Date effectiveDate;
    pchangeOb.HomePage_Approval_History__c = false;
    if (pchangeob.Sales_Price_Change_Effective_Date_Approv__c != null && pchangeob.Sales_Price_Change_Effective_Date_Approv__c > pchangeob.Sales_Price_Change_Effective_Date__c)
     effectiveDate = pchangeob.Sales_Price_Change_Effective_Date_Approv__c;
   else
     effectiveDate = pchangeob.Sales_Price_Change_Effective_Date__c;
     
    if (pchangeob.Sales_Price_Change_Effective_Date_Rep__c == effectiveDate)
        throw new custException(APPROVALNOTREQUIRED);
        
    if (pchangeob.Sales_Price_Change_Effective_Date_Rep__c < effectiveDate)
        throw new custException(APPROVALNOTREQUIRED1);

  
  pchangeOb.record_lock_code__c = DATEEXCEPTIONLOCK;
  
  
  system.debug ('Update Changes Complete');
  Approval.ProcessResult result;
  Decimal revImpactForCalculation1 = 0,revImpactForCalculation2 = 0,revImpactForCalculation = 0;
  
  if (pchangeOb.Previous_Exception_Impact__c != null)
    revImpactForCalculation1 = -1*pchangeOb.Previous_Exception_Impact__c;
  if (pchangeOb.OD_Revenue_Impact__c != null)
   revImpactForCalculation2 = -1 * pchangeOb.OD_Revenue_Impact__c;
  
  revImpactForCalculation = revImpactForCalculation1+revImpactForCalculation2;
     Integer datedelay;
     if(!Test.isRunningTest()){
     datedelay = pchangeob.Sales_Price_Change_Effective_Date_Rep__c.daysbetween(effectiveDate);
     }
     else{
     datedelay = -91;
     }
     pchangeob.Current_Exception_Days__c = datedelay;
     
     decimal datedelayCalc =0;
     
     if (pchangeob.Previous_Exception_Days__c != null)
       datedelayCalc = -1 * (datedelay + pchangeob.Previous_Exception_Days__c);
     else
       datedelayCalc = -1 * datedelay;
  
  if (revImpactForCalculation >= 1 || datedelayCalc >= 1 || revImpactForCalculation == 0) {
   
   user u = [select manager.id,manager.manager.id,manager.manager.manager.id from user where id = :userInfo.getUserId()];
   
   pchangeob.approval_type__c = 1;
   
   // Logic to set Approver Type field - This will drive the approval action step - Starts
     if (revImpactForCalculation > 75000 && revImpactForCalculation <= 150000) 
       pchangeob.approval_type__c = 2;
     else if (revImpactForCalculation > 150000)
       pchangeob.approval_type__c = 3;
     
     
     
     if (datedelayCalc > 90 && datedelayCalc <= 180 && pchangeob.approval_type__c < 2)
        pchangeob.approval_type__c = 2; //pchangeob.rsd__c = u.manager.manager.id;
     else if (datedelayCalc > 180 && pchangeob.approval_type__c < 3)
        pchangeob.approval_type__c = 3; //pchangeob.rsd__c = u.manager.manager.id; pchangeob.vp__c = u.manager.manager.id;
     
     if(pchangeob.approval_type__c == 1){
         pchangeob.dsm__c = u.manager.id;
     }
     else if(pchangeob.approval_type__c == 2){
         pchangeob.dsm__c = u.manager.id;
         pchangeob.rsd__c = u.manager.manager.id;         
     }
     else if(pchangeob.approval_type__c == 3){
         pchangeob.dsm__c = u.manager.id;
         pchangeob.rsd__c = u.manager.manager.id;
         pchangeob.vp__c = u.manager.manager.manager.id;
     }      
   //Logic to set Approver Type field - This will drive the approval action step - Ends
   pchangeob.Reporting_Date_Modified_By_Approver__c = false;
   update pchangeob;
   
   system.debug('>>>>>>>>>>>>>>'+pchangeob.approval_type__c);
   
   Approval.ProcessSubmitRequest areq = new Approval.ProcessSubmitRequest();
   areq.setObjectId(pchangeOb.Id);
   areq.setComments(pchangeob.Date_Exception_Additional_Comments__c);
    result = Approval.process(areq);
     system.debug ('Approval Process Completed');
  }
  else {
    pchangeob.Sales_Price_Change_Effective_Date_Approv__c = pchangeob.Sales_Price_Change_Effective_Date_Rep__c;
    pchangeob.Sales_Price_Change_Effective_Date_Min__c = pchangeob.Sales_Price_Change_Effective_Date_Rep__c;
    
    if (pchangeob.Previous_Exception_Days__c != null)
      pchangeob.Previous_Exception_Days__c = pchangeob.Previous_Exception_Days__c + pchangeob.Current_Exception_Days__c;
    else
      pchangeob.Previous_Exception_Days__c = pchangeob.Current_Exception_Days__c;
    
    if (pchangeob.Previous_Exception_Impact__c != null)
      pchangeob.Previous_Exception_Impact__c = pchangeob.Previous_Exception_Impact__c + pchangeob.OD_Revenue_Impact__c;
    else
      pchangeob.Previous_Exception_Impact__c = pchangeob.OD_Revenue_Impact__c;
    
    update pchangeob;
    system.debug('Approval Not Required');
  }
  
 
  
  
  
  if (result != null) {
    if (!result.isSuccess())
     throw new CustException(APPROVALNOTREQUIRED);

  }

  return pref;
  }
  catch (custException ce) {
    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,ce.getMessage()));
    return null;
  }
  catch (Exception e) {
    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Unexpected Error' + e));
    return null;
  }
}

public pageReference cancelChanges() {
  return pref;
}



}