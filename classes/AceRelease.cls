public class AceRelease {

  Public String responseSelection {get;set;}
  public Ace_Customer_Price_Changes__c acepricechanges {get;set;}
  public PageReference pref;
  public boolean datesectionDisplay {get;set;}
  public boolean NotifysectionDisplay {get;set;}
  public static String FUTUREDATEERROR = 'Effective Date Cannot be Modified Beyond The Current Date, Please Go Through Date Exception Process';
  public String earliestReleaseDate {get;set;}
  public String currentReleaseDate {get;set;}
  public class  custException extends exception {}
  public AceRelease() {
    acepricechanges = [SELECT ID,IsRemediation__c,customer__r.Remediation_Required__c,customer__r.Name,customer__r.Cust_ID__c,customer_notification_date_approved__c,Customer_Notification_Date__c,Record_Lock__c,remedy_status__c,customer__r.ownerid,Sales_Price_Change_Effective_Date_Rep__c,sfdc_notification_flag__c,customer_notification_date_rep__c,exception_date_lock__c,requirement_window__c,Sales_Price_Change_Effective_Date_Approv__c,Sales_Price_Change_Effective_Date__c,Sales_Price_Change_Effective_Date_Min__c from Ace_Customer_Price_Changes__c where ID = :ApexPages.currentPage().getParameters().get('pchangeid')];
    pref = new PageReference('/' + acepricechanges.id);
    datesectionDisplay = false;
    NotifysectionDisplay = false;
    //calculateEarliestReleaseDate();
    //if (acepricechanges.Sales_Price_Change_Effective_Date_Approv__c != null)
    //  currentReleaseDate = acepricechanges.Sales_Price_Change_Effective_Date_Approv__c.format();
    if (acepricechanges.Customer_Notification_Date_Approved__c != null )
       currentReleaseDate = acepricechanges.Customer_Notification_Date_Approved__c.format();
    else if (acepricechanges.Sales_Price_Change_Effective_Date_Min__c != null)
       currentReleaseDate = acepricechanges.Sales_Price_Change_Effective_Date_Min__c.format();
  }
  
  /*  public void calculateEarliestReleaseDate() {
      Date earliestdate = Date.Today();
    if (acepricechanges.sfdc_notification_flag__c != '1') {
        if (acepricechanges.requirement_window__c != null) {
         Integer window = Integer.valueOf(acepricechanges.requirement_window__c);
         earliestDate = earliestdate.adddays(window);
       }
    }
       
       earliestReleaseDate = earliestDate.format();
    }*/


  
  public list<SelectOption> getReleaseOptions (){
 
         list<SelectOption> releaseOptions = new list<SelectOption>();
         
         releaseOptions.add(new SelectOption('Immediate','Release Today'));
         releaseOptions.add(new SelectOption('Scheduled','Schedule Release'));

         return releaseOptions;
     }
     
  public PageReference cancel() {
    return pref;
  }
  
  public void rerenderDateSection() {
    if ('Scheduled'.equals(responseSelection) && acePriceChanges.SFDC_Notification_Flag__c == '1') {
      datesectionDisplay = true;
      NotifysectionDisplay = false;
    }
    else if ('Scheduled'.equals(responseSelection) && acePriceChanges.SFDC_Notification_Flag__c != '1') {
     datesectionDisplay = false;
     NotifysectionDisplay = true;
    }
    else {
        datesectionDisplay = false;
        NotifysectionDisplay = false;
    }
  }
  
  public PageReference save() {
    try
    {
    AceReleaseCommon rel = new AceReleaseCommon();
    AceReleaseCommon.releaseRequest relreq = new  AceReleaseCommon.releaseRequest();
    //throw new custException ('checkpoint 1' + relreq);
    list<ace_customer_sku_changes__c> skus = [select id,Requirement_Window__c,Sales_Price_Change_Effective_Date__c,Sales_Price_Change_Effective_Date_Approv__c,Customer_Notification_Date__c from ace_customer_sku_changes__c where ace_customer_core_changes__r.ace_customer_price_changes__r.id = :acepricechanges.id];
    List<AceReleaseCommon.releaseResponse> relrespList = new list<AceReleaseCommon.releaseResponse> ();
    Set<AceReleaseCommon.releaseRequest> relreqList = new Set<AceReleaseCommon.releaseRequest>();
    
    if ('Immediate'.equals(responseSelection)) {
      if (acepricechanges.Customer_Notification_Date_Approved__c != null && acePriceChanges.SFDC_Notification_Flag__c != '1')
        acepricechanges.customer_notification_date_rep__c = date.Today();
      else
        acepricechanges.Sales_Price_Change_Effective_Date_Rep__c = date.Today();
    }
    

    Date trueEffectiveDate;
    Decimal requirementWindow;
    
    if (acepricechanges.Customer_Notification_Date_Approved__c != null && acePriceChanges.SFDC_Notification_Flag__c != '1')
       trueEffectiveDate = acepricechanges.Customer_Notification_Date_Rep__c;
    else 
       trueEffectiveDate = acepricechanges.Sales_Price_Change_Effective_Date_Rep__c;
    
    
    relreq.acp = acepricechanges;
    relReqList.add(relreq);
    relrespList = rel.Release(relReqList);
    if (relrespList.size() > 0) {
      if (relrespList[0].returnstatus)
       return pref;
      else {
        System.debug('Error During Release:' + relrespList[0].errorMessage);
        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,relrespList[0].errorMessage));
      }
    }
    else {
      ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Unexpected Error'));
    }
     return null;
    }
    catch (custException ce) {
         ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,ce.getMessage()));
         return null;
    }
    catch (Exception e) {
        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Unexpected Error:' + e));
        return null;
    }
  }
   
}