Public class AceReleaseCommon
{

public class releaseResponse {
 public ACE_Customer_Price_Changes__c acp;
 public Boolean returnStatus;
 public String  errorMessage; 
}

  public STATIC String DATEVIOLATION = 'The Customer Cannot be Released on the Specified Date.';
  public String earliestDateSelection;
  public static integer PROCESSINGWINDOW = 0;
  
public class releaseRequest {
 public ACE_Customer_Price_Changes__c acp;
}

public list<ReleaseResponse> Notify (Set<releaseRequest> notifications) {
    try
    {system.debug('@@@@$$$$notifications: '+notifications);//
    // This function will be called for 'No Requirements' customers only, as a result this function will not reset any Effective Dates
    list<ReleaseResponse> resp = new list<ReleaseResponse> ();
    list <Ace_Customer_Price_Changes__c> acpcUpd = new list<Ace_Customer_Price_Changes__c> ();
    for (ReleaseRequest rq : notifications) {
        ReleaseResponse rsp = new ReleaseResponse();
        rsp.acp = rq.acp;
        rsp.returnStatus = true;
        rsp.acp.Customer_Notification_Date_Approved__c = Date.today();
        rsp.acp.Notification_Status_Code__c = 'NOTIFY-SCH';
        acpcUpd.add(rsp.acp);  
        //system.debug('@@@@$$$$rsp.acp: '+rsp.acp); //     
    }
    update acpcUpd;
    system.debug('@@@@$$$$acpcUpd: '+acpcUpd);
    return resp;
    }
    catch (Exception e) {
        list<ReleaseResponse> resp = new list<ReleaseResponse> ();
        ReleaseResponse rsp = new ReleaseResponse();
        rsp.returnStatus = false;
        rsp.errorMessage = e.getMessage();
        resp.add(rsp);
        return resp;
    }
}

  public class custexception extends exception {}

  public list<releaseResponse> Release (Set<releaseRequest> req) {
    try
    {
        
    list<ReleaseResponse> resp = new list<ReleaseResponse> ();
    list<ACE_Customer_Price_Changes__c> acpUpdates = new List<ACE_Customer_Price_Changes__c> ();
    Map<ID,Date> custtoDate = new Map<ID,Date> ();
    Set<String> custPriceIDs = new Set<String> ();
    
    //Fetch All SKUs for the Customer - Starts
    for (releaseRequest r : req) 
    {
      custPriceIDs.add(String.valueof(r.acp.id));
      if (r.acp.customer_Notification_Date_Approved__c != null && r.acp.sfdc_notification_flag__c != '1') {
        custtoDate.put(r.acp.id,r.acp.customer_notification_date_Rep__c);
      }
      else {
        custtoDate.put(r.acp.id,r.acp.Sales_Price_Change_Effective_Date_Rep__c);
        
      }
    }
   
    //Fetch All SKUs for the Customer - Ends
    for (releaseRequest r : req) {
      ReleaseResponse rsp = new ReleaseResponse();
      rsp.acp = r.acp;
      Boolean isreleaseallowed;
      if (r.acp.customer_Notification_Date_Approved__c != null && r.acp.SFDC_Notification_Flag__c != '1')
        isreleaseallowed = ReleaseAllowed(r.acp,r.acp.customer_notification_date_Rep__c);
      else 
        isreleaseallowed = ReleaseAllowed(r.acp,r.acp.Sales_Price_Change_Effective_Date_Rep__c);
      System.debug('ReleaseAllowed?' + isreleaseAllowed);
      
      if (!isreleaseAllowed) {
        rsp.returnStatus = false;
        rsp.errorMessage = DATEVIOLATION;
        resp.add(rsp);
      }
      else {
        rsp.returnStatus = true;
        resp.add(rsp);
        ACE_Customer_Price_Changes__c acpU = new ACE_Customer_Price_Changes__c();
        acpU = r.acp;
        
        /*Integer rwindow = 0;
        
        if (acpU.requirement_window__c != null && acpU.sfdc_notification_flag__c != '1') {
         rwindow  = Integer.valueof(acpU.requirement_window__c);
         system.debug('test:' + rwindow);
        }*/
        if (acpU.customer_Notification_Date_Approved__c != null && acpU.sfdc_notification_flag__c != '1') {
         Integer datediff = acpU.customer_notification_date_approved__c.daysBetween(acpU.customer_Notification_Date_Rep__c);
         system.debug('Date Diff:' + datediff);
         
         acpU.Customer_Notification_Date_Approved__c = acpU.customer_Notification_Date_Rep__c;
         if (datediff != null) {
          acpU.Sales_Price_Change_Effective_Date_Approv__c = acpU.Sales_Price_Change_Effective_Date_Approv__c.addDays(datediff);
          acpU.Sales_Price_Change_Effective_Date_Min__c = acpU.Sales_Price_Change_Effective_Date_Min__c.addDays(datediff);
          acpU.effective_date_difference__c = datediff;
         }
        }
        else {
            //acpU.Customer_Notification_Date_Approved__c = acpU.Sales_Price_Change_Effective_Date_Rep__c;
            //acpU.Customer_Notification_Date_Rep__c = acpU.Sales_Price_Change_Effective_Date_Rep__c;
            acpU.Sales_Price_Change_Effective_Date_Approv__c = acpU.Sales_Price_Change_Effective_Date_Rep__c;
            acpU.Sales_Price_Change_Effective_Date_min__c = acpU.Sales_Price_Change_Effective_Date_Rep__c;
        }
        
            acpU.Implementation_Status_Code__c = 'SCH';
            if (acpU.sfdc_notification_flag__c != '1')
              acpU.Notification_Status_Code__c = 'NOTIFY-SCH';

        acpUpdates.add(acpU);
        System.debug('acpU?' + acpU);
      }
    }
    System.debug('acpupdates?' + acpupdates);
    
    // Logic To Update SKU Dates - Starts
      list<ace_customer_sku_changes__c> skuUpd = new list<ace_customer_sku_changes__c> ();
      system.debug(custPriceIDs.size());
      
     //Commented By Deepak Due to Performance Issues, replaces by Batch - ACESKULevelUpdate
   /*  Map <string,ace_customer_price_changes__c> PIDS = new Map<String,ace_customer_price_changes__c>();
     
     For(ace_customer_price_changes__c s : [select id,customer_notification_date__c,customer_notification_date_approved__c,sfdc_notification_flag__c from ace_customer_price_changes__c where ID = :custPriceIDs]) {
        PIDS.put(string.valueof(s.id),s);
     }
     // String sq = 'select id,price_change_id__c,Requirement_Window__c,Sales_Price_Change_Effective_Date__c,Sales_Price_Change_Effective_Date_Approv__c,Customer_Notification_Date__c from ace_customer_sku_changes__c where price_change_id__c IN :custPriceIDs';
     // list<ace_customer_sku_changes__c> slist = Database.query(sq);
      For(ace_customer_sku_changes__c s : [select id,price_change_id__c,Requirement_Window__c,Sales_Price_Change_Effective_Date__c,Sales_Price_Change_Effective_Date_Approv__c,Customer_Notification_Date__c from ace_customer_sku_changes__c where price_change_id__c IN :custPriceIDs]) {
       
       if (PIDS.get(s.price_change_id__c).customer_notification_date_approved__c != null && PIDS.get(s.price_change_id__c).sfdc_notification_flag__c != '1') {
            
            Date effdate = custtoDate.get(PIDS.get(s.price_change_id__c).id);

            Integer datediff = PIDS.get(s.price_change_id__c).customer_notification_date_approved__c.daysBetween(effdate);
            
            if (s.Sales_Price_Change_Effective_Date_Approv__c != null && datediff != null) {
             s.Sales_Price_Change_Effective_Date_Approv__c = s.Sales_Price_Change_Effective_Date_Approv__c.adddays(datediff);
             
            }
            s.Customer_Notification_Date__c = effdate;
             skuUpd.add(s);
            
        }
        else {
            
            if (custtoDate.containsKey(PIDS.get(s.price_change_id__c).id)) {
               s.Sales_Price_Change_Effective_Date_Approv__c = custtoDate.get(PIDS.get(s.price_change_id__c).id);
               skuUpd.add(s);
              }
            }
      }
       decimal d=1/0;*/
      
      if (skuUpd.size() > 0) {
        update skuUpd;
      }
      
      if (acpupdates.size() > 0)
        update acpupdates;
      
    // Logic To Update SKU Dates - Ends
    //As part of optimization fix - This logic should not be required.
    /*
    list<ace_customer_price_changes__c> custUpd = new list<ace_customer_price_changes__c>();
    For (AggregateResult ar : [SELECT ace_customer_core_changes__r.ace_customer_price_changes__r.id custid,MIN(Sales_Price_Change_Effective_Date_Approv__c) PriceMin,MAX(Sales_Price_Change_Effective_Date_Approv__c) PriceMax,MIN(Customer_Notification_Date__c) NotifyMIN,MAX(Customer_Notification_Date__c) NotifyMAX from ace_customer_sku_changes__c where ace_customer_core_changes__r.ace_customer_price_changes__r.id = :custPriceIDs group by ace_customer_core_changes__r.ace_customer_price_changes__r.id]) {
        ace_customer_price_changes__c cust = new ace_customer_price_changes__c(ID=(ID)ar.get('custid'));
        //throw new custException ('ID:' + cust.id + ':' + ar.get('PriceMax'));
        if (ar.get('PriceMax') != null)
         cust.sales_Price_Change_Effective_Date_Approv__c = (Date)ar.get('PriceMax');
        if (ar.get('PriceMin') != null)
         cust.sales_Price_Change_Effective_Date_Min__c = (Date)ar.get('PriceMin');
         
         custUpd.add(cust);
         
    } 
    if (custUpd.size() > 0)
      update custUpd;
      */
    //Update the effective date
    return resp;
    
    }
    catch (custException ce) {
      ReleaseResponse rsperror2 = new ReleaseResponse();
      rsperror2.returnstatus = false;
      rsperror2.errorMessage = string.valueof(ce);
      list<ReleaseResponse> resp2 = new list<ReleaseResponse> ();
      resp2.add(rsperror2);
      return resp2;
    }
    catch (Exception e) {
      system.debug('Unhandled Exception in Method Release:' + e);
      ReleaseResponse rsperror = new ReleaseResponse();
      rsperror.returnstatus = false;
      rsperror.errorMessage = string.valueof(e);
      list<ReleaseResponse> resp = new list<ReleaseResponse> ();
      resp.add(rsperror);
      return resp;
    }
  }
  
  public Boolean ReleaseAllowed(Ace_Customer_Price_Changes__c acp, Date proposedDate) {
   
   Date currentDate = Date.Today();
   Decimal requirementwindow;
   Date effectiveDate;
   
   Date releaseDt;
   System.debug('>>>>>>>>>>>>>>>>>>>>>value of ownerID' +  acp.customer__r.ownerid);
    //if (acp.isRemediation__c || acp.customer__r.ownerid != userInfo.getUserId() || acp.Record_Lock__c || acp.Exception_Date_Lock__c || acp.remedy_status__c == 'Pending') {
    if (acp.isRemediation__c || acp.Record_Lock__c || acp.Exception_Date_Lock__c || acp.remedy_status__c == 'Pending') {
      System.debug('Validation failed - Not Owner or Record Locked or Date exception lock:' + acp.id + ':' + acp.Record_Lock__c + acp.Exception_Date_Lock__c+acp.customer__r.ownerid+userInfo.getUserId());
      return false;
   }
   
   // Validation on User Entered Date - Starts 
       if (acp.Customer_Notification_Date_Approved__c != null && acp.sfdc_notification_flag__c != '1') {
         
         if (acp.Customer_Notification_Date__c > acp.Customer_Notification_Date_Approved__c)
            releaseDt = acp.Customer_Notification_Date__c;
         else
            releaseDt = acp.Customer_Notification_Date_Approved__c;
            
         if ((proposedDate >= releaseDt.adddays(PROCESSINGWINDOW) && date.today() <= releaseDt) || (date.today() > releaseDt && ProposedDate > date.today()+2)) {
           system.debug('Validation failed for notification Date Check'); 
           
           if (date.today() <= releaseDt)
            DATEVIOLATION = 'You must select a date prior to or equal to '+ releaseDt.format() +' for early release. To choose a later date for release, please use the date exception process.';
           else
            DATEVIOLATION = 'You must select a date prior to or equal to '+ (date.today()+2).format() +' for early release. To choose a later date for release, please use the date exception process.';
           
           return false;
         }
       }
       else if (acp.Sales_Price_Change_Effective_Date_Min__c != null ) {
          releaseDt = acp.Sales_Price_Change_Effective_Date_Min__c;
         if (proposedDate >= releaseDt.adddays(PROCESSINGWINDOW) && date.today() <= releaseDt) {
           DATEVIOLATION = 'You must select a date prior to or equal to '+ releaseDt.format() +' for early release. To choose a later date for release, please use the date exception process.';
           system.debug('Validation failed for Effective Date Check');
           return false;
         }
       }
       
       if (proposedDate < currentDate)
          return false;
       
    // Validation on User Entered Date - Ends
   
   
   //Ace_Customer_Price_Changes__c acpL = [Select Record_Lock__c,customer__r.ownerid from ace_customer_price_changes__c where id = :acp.Id];
   //Profile p = [SELECT Id,name from profile where name = 'System Administrator'];
   
  // if (p.id == userInfo.getProfileId())
    // return true; || 
        
    return true;
  }
  
 
  }