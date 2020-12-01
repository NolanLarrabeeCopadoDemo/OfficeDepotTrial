public with sharing class AceCustDateChangesHistory_Homepg {

public ID custSKUChangesID {get;set;}
public String pageval {get;set;}
public Boolean skuRender {get;set;}
public Integer List_size = 16;
public Integer total_size{get;set;}
public Integer counter = 0;
public list<AceSKUHist> AceSKUHistList {get;set;}
public string currentQuarter {get;set;}

    public class AceSKUHist 
    {
        public String SKU{get;set;}
        public DateTime changeDate {get;set;}
        public String ApprovalStatus {get;set;}
        public String ModifiedBy {get;set;}
        public String changes {get;set;}
        public String CustName{get;set;}
        public String CustID{get;set;}
        public String Cust_Sal_ID{get;set;}
        public String Cust_ownerName{get;set;}
    }

    public Map<ID,ACE_Customer_Price_Changes__c> m_acePriceChangeRec{get;set;}
    public AceCustDateChangesHistory_Homepg() 
    {     
        list<ACE_Settings__c> desettings =[SELECT Id, Name, Current_Quarter__c from ACE_Settings__c limit 1];
        if(desettings[0]!= null)
            currentQuarter = desettings[0].Current_Quarter__c;          
        
        m_acePriceChangeRec = new Map<ID,ACE_Customer_Price_Changes__c>();
           
        generateList();
    }
    
    public void generateList()
    {
        list<Audit_History__c> aHist = new list<Audit_History__c>();        
        aHist = [select SKU__c,ACE_Customer_Price_Changes__r.customer__r.owner.name,
                                            ACE_Customer_Price_Changes__r.customer__r.name,
                                            ACE_Customer_Price_Changes__r.customer__r.cust_ID__c, 
                                            ACE_Customer_Price_Changes__r.Customer_Comments_Submitter__c,
                                            ACE_Customer_Price_Changes__r.batchID__c,
                                            New_Approval_status__c, Old_Approval_status__c, HomePage_Approval_Date__c,
                                            NewSales_Price_Change_Effective_Date_Rep__c,
                                            Old_SalesPrice_Change_Effective_Date_Rep__c,
                                            New_User_Proposed_Price__c, Old_User_Proposed_Price__c,                                            
                                            New_Approval_Price__c, 
                                            Old_Approval_Price__c,
                                            new_SalesPrice_ChangeEffectiveDateApprov__c,
                                            Old_SalesPriceChangeEffectiveDateApprov__c , 
                                            lastmodifieddate, lastmodifiedby.name,
                                            Record_Unlock_Status__c, Customer_Name__c, Customer_Response__c
                                            from Audit_History__c 
                                            where SKU__c = null AND//HomePage_Approval_Date__c = true AND 
                                            CreatedByID =:UserInfo.getUserId()
                                            AND ace_customer_price_changes__r.name = :currentQuarter
                                            order by createddate desc limit :List_size OFFSET :counter]; 
            total_size = [select count() from Audit_History__c where SKU__c = null AND CreatedByID =:UserInfo.getUserId() AND ace_customer_price_changes__r.name = :currentQuarter];                                        
                                    
        AceSKUHistList = new list<AceSKUHist>();
        String effDateNewApprov,effDateOldRep,effDateNewRep,effDateOldApprov;
        
        
        
        For (Audit_History__c ah : aHist) {
            if (ah.SKU__c == null || ah.SKU__c =='') 
            {            
                AceSKUHist SKUhist = new AceSKUHist();            
                                
                SKUhist.changeDate = ah.lastmodifieddate;
                SKUhist.ModifiedBy = ah.lastmodifiedby.name;
                SKUhist.CustName = ah.ACE_Customer_Price_Changes__r.customer__r.name;
                SKUhist.CustID = ah.ACE_Customer_Price_Changes__r.customer__r.cust_ID__c;
                SKUhist.Cust_ownerName = ah.ACE_Customer_Price_Changes__r.customer__r.owner.name;
                
            if (ah.new_SalesPrice_ChangeEffectiveDateApprov__c != null)
                  effdateNewApprov = ah.new_SalesPrice_ChangeEffectiveDateApprov__c.month() + '/' + ah.new_SalesPrice_ChangeEffectiveDateApprov__c.day() + '/' + ah.new_SalesPrice_ChangeEffectiveDateApprov__c.year();
            if (ah.Old_SalesPrice_Change_Effective_Date_Rep__c != null)
                  effDateOldRep = ah.Old_SalesPrice_Change_Effective_Date_Rep__c.month() + '/' + ah.Old_SalesPrice_Change_Effective_Date_Rep__c.day() + '/' + ah.Old_SalesPrice_Change_Effective_Date_Rep__c.year();
            if (ah.NewSales_Price_Change_Effective_Date_Rep__c != null)
                  effDateNewRep = ah.NewSales_Price_Change_Effective_Date_Rep__c.month() + '/' + ah.NewSales_Price_Change_Effective_Date_Rep__c.day() + '/' + ah.NewSales_Price_Change_Effective_Date_Rep__c.year();
            if (ah.Old_SalesPriceChangeEffectiveDateApprov__c != null)
                  effDateOldApprov = ah.Old_SalesPriceChangeEffectiveDateApprov__c.month() + '/' + ah.Old_SalesPriceChangeEffectiveDateApprov__c.day() + '/' + ah.Old_SalesPriceChangeEffectiveDateApprov__c.year();
               
                Boolean modified = false;
                
                if (ah.Old_SalesPrice_Change_Effective_Date_Rep__c != ah.NewSales_Price_Change_Effective_Date_Rep__c) {               
                    //SKUhist.changes = 'A New Sales Price Effective Date Proposed, Change Requested From <b><font color="black">' + effdateNewApprov + '</font></b> To <b><font color="black"/>' + effDateNewRep + '</font></b>';
                     SKUhist.changes = 'A request to change the Sales Price Effective Date has been submitted - request to change effective date from ' + effdateNewApprov + ' to ' + effDateNewRep;
                    //modified = true;
                    modified = false;
                }
                
                if (ah.Old_SalesPriceChangeEffectiveDateApprov__c != ah.new_SalesPrice_ChangeEffectiveDateApprov__c) 
                {
                   // SKUhist.changes = 'A New Sales Price Effective Date Has Been <b><font color="Green"> Approved </b></font>, New Effective Date <b><font color="black">' + effdateNewApprov + '</font></b>';
                    SKUhist.changes = 'A request to change the Sales Price Effective Date has been <b>approved</b> - effective date changed from ' + effDateOldApprov + ' to ' + effdateNewApprov;                
                    modified = true;
                }
                
                if (ah.NewSales_Price_Change_Effective_Date_Rep__c == null) {
                    // SKUhist.changes = 'The New Sales Price Effective Date Has Been <b><font color="Red"> Rejected </b></font>, There is no Changes to<b><font color="black">' + effDateOldApprov + '</font></b>';
                    SKUhist.changes = 'A request to change the Sales Price Effective Date has been <b>rejected</b> - effective date remains ' + effDateOldApprov;  
                    modified = true;
                }              
                
                if(ah.Old_Approval_Status__c == 'mod_Pending' && ah.New_Approval_Status__c == 'Modification'){
                    // SKUhist.changes = 'The New Sales Price Effective Date Proposed has been Changed to <b><font color="black">' + effDateNewRep + '</font></b>';
                     SKUhist.changes = 'A request to change the Sales Price Effective Date has been <b>modified</b> - effective date changed from ' + effDateOldApprov + ' to ' + effDateNewRep;
                    //modified = true;
                    modified = false;
                }              
                              
                //if (ah.New_Approval_status__c == 'Pending'){
                //    SKUhist.changes = 'The Approver has submitted a New Date Exception Request for<b><font color="blue"/>$ '+ ah.NewSales_Price_Change_Effective_Date_Rep__c +'</font></b> and Approval Status is <b><font color="Orange"/>' + ah.New_Approval_status__c+ '</font></b>';
                //}
                
                //else if(ah.New_Approval_status__c == 'Approved'){
                //    SKUhist.changes = 'Approver has modified the Date exception to <b><font color="Blue">$ ' + ah.NewSales_Price_Change_Effective_Date_Rep__c + '</font></b> and has been <b><font color="Green">Approved</font></b>';
                //}
                
                //else if(ah.New_Approval_status__c == 'Rejected'){
                //    SKUhist.changes = 'The Approver has <b><font color="Red">Rejected</font></b> the price exception and There is no changes made to the Apprved proposed price <b><font color="Blue"/>$ ' + ah.Old_SalesPrice_Change_Effective_Date_Rep__c+ '</font></b>';
                //}
                //Code added by GUHA [04/05/2014] - Record Unlock/Lock History tracking.
              /*  if(ah.Record_Unlock_Status__c == 'Pending'){
                    // SKUhist.changes = 'The customer <b><font color="blue">'+ah.Customer_Name__c+'</b></font> is <b><font color="orange">Submitted</b></font> for record unlock.';
                    SKUhist.changes = 'A request to unlock '+ah.Customer_Name__c + ' - ' + ah.ACE_Customer_Price_Changes__r.customer__r.cust_ID__c + ' has been submitted';    
                     
                    //modified = true;
                    modified = false;
                }
                if(ah.Record_Unlock_Status__c == 'Approved'){
                    // SKUhist.changes = 'The customer  <b><font color="blue">'+ah.Customer_Name__c+'</b></font> is <b><font color="Green">Unlocked</b></font>.';
                    SKUhist.changes = 'A request to unlock '+ah.Customer_Name__c + ' - ' + ah.ACE_Customer_Price_Changes__r.customer__r.cust_ID__c + ' has been <b>approved</b>';    
                    modified = true;
                }
                if(ah.Record_Unlock_Status__c == 'Rejected' || ah.Record_Unlock_Status__c == 'Recalled'){
                   // SKUhist.changes = 'The customer <b><font color="blue">'+ah.Customer_Name__c+'</b></font> is submitted for record unlock and has been <b><font color="Red">Rejected</b></font> by manager';
                   SKUhist.changes = 'A request to unlock '+ah.Customer_Name__c + ' - ' + ah.ACE_Customer_Price_Changes__r.customer__r.cust_ID__c + ' has been <b>rejected</b>';    
                    modified = true;
                }    
                //Code added by GUHA [04/05/2014] - Record Unlock/Lock History tracking Ends.
                */
                
                if(ah.Customer_Response__c == 'Approved'){
                    SKUhist.changes = ''+ah.Customer_Name__c + ' - ' + ah.ACE_Customer_Price_Changes__r.customer__r.cust_ID__c + ' has approved the ' +  ah.ACE_Customer_Price_Changes__r.BatchID__c + ' price changes - approved by ' +  ah.ACE_Customer_Price_Changes__r.Customer_Comments_Submitter__c;
                    modified = true;
                }
                if(ah.Customer_Response__c == 'Call Me'){
                    //  SKUhist.changes = 'The Customer <b><font color="blue">'+ah.Customer_Name__c+'</b></font> has requested to <b><font color="Red">call back</b></font> him.';
                 SKUhist.changes =  ah.ACE_Customer_Price_Changes__r.Customer_Comments_Submitter__c + ' at ' +ah.Customer_Name__c + ' - ' + ah.ACE_Customer_Price_Changes__r.customer__r.cust_ID__c + ' has <b>requested to be contacted</b> regarding ' +  ah.ACE_Customer_Price_Changes__r.BatchID__c + ' price changes';
                    //modified = true;
                    modified = false;
                }
                
                if (modified)
                 AceSKUHistList.add(SKUhist);
            }                        
        }
    }
    public void nextPage(){
        counter = counter+List_size; 
          
        generateList();
        
    }
    public void prevPage(){
        counter = counter-List_size;
        generateList();
       
    }
    
    public Boolean getDisablePrevious() {
     
      if (counter>0) return true; else return false;
    }
    
    public Boolean getDisableNext() { 
      if (counter + list_size < total_size) return true; else return false;
    }

}