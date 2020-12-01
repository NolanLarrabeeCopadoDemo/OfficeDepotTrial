public with sharing class AceCustomerPriceChangesHistory {
    public Integer List_size = 5;
    public Integer total_size{get;set;}
    public Integer counter = 0;
    public ID custPriceChangesID;

public class AceCustomerHist {
    public dateTime changeDate {get;set;}
    public String ModifiedBy {get;set;}
    public String changes {get;set;}
}

public list<AceCustomerHist> AceCustomerHistList {get;set;}
public ACE_Customer_Price_Changes__c acePriceChangeRec{get;set;}
public AceCustomerPriceChangesHistory(ApexPages.StandardController controller) {
    //ID custPriceChangesID = ApexPages.currentPage().getParameters().get('ID');
    custPriceChangesID = controller.getId();
    total_size = [select count() from Audit_History__c 
                                        where ACE_Customer_Price_Changes__c = :custPriceChangesID];
    acePriceChangeRec = [select batchID__c,Customer_Comments_Submitter__c from ACE_Customer_Price_Changes__c 
                                        where id = :custPriceChangesID];
                                        
    generateHistory();
}

    public void generateHistory()
    {
        list<Audit_History__c> aHist = [select New_Customer_Notification_Date_Approved__c,
                                               old_Customer_Notification_Date_Approved__c,
                                               new_SalesPrice_ChangeEffectiveDateApprov__c,
                                               Old_SalesPriceChangeEffectiveDateApprov__c,
                                               NewSales_Price_Change_Effective_Date_Rep__c,
                                               Old_SalesPrice_Change_Effective_Date_Rep__c,
                                               Old_Approval_Status__c,
                                               New_Approval_Status__c,
                                               lastmodifieddate,
                                               lastmodifiedby.name,
                                               Record_Unlock_Status__c, Customer_Name__c,Customer_Response__c
                                        from Audit_History__c 
                                        where ACE_Customer_Price_Changes__c = :custPriceChangesID 
                                        order by createddate desc
                                        limit :List_size OFFSET :counter];
        
        AceCustomerHistList = new list<AceCustomerHist> ();
         String effDateNewApprov,effDateOldRep,effDateNewRep,effDateOldApprov;
         String CustomerName;
        For (Audit_History__c ah : aHist) {
            
            effDateNewApprov = null; effDateOldRep = null; effDateNewRep = null; effDateOldApprov = null;
            
            if (ah.new_SalesPrice_ChangeEffectiveDateApprov__c != null)
                  effdateNewApprov = ah.new_SalesPrice_ChangeEffectiveDateApprov__c.month() + '/' + ah.new_SalesPrice_ChangeEffectiveDateApprov__c.day() + '/' + ah.new_SalesPrice_ChangeEffectiveDateApprov__c.year();
            if (ah.Old_SalesPrice_Change_Effective_Date_Rep__c != null)
                  effDateOldRep = ah.Old_SalesPrice_Change_Effective_Date_Rep__c.month() + '/' + ah.Old_SalesPrice_Change_Effective_Date_Rep__c.day() + '/' + ah.Old_SalesPrice_Change_Effective_Date_Rep__c.year();
            if (ah.NewSales_Price_Change_Effective_Date_Rep__c != null)
                  effDateNewRep = ah.NewSales_Price_Change_Effective_Date_Rep__c.month() + '/' + ah.NewSales_Price_Change_Effective_Date_Rep__c.day() + '/' + ah.NewSales_Price_Change_Effective_Date_Rep__c.year();
            if (ah.Old_SalesPriceChangeEffectiveDateApprov__c != null)
                  effDateOldApprov = ah.Old_SalesPriceChangeEffectiveDateApprov__c.month() + '/' + ah.Old_SalesPriceChangeEffectiveDateApprov__c.day() + '/' + ah.Old_SalesPriceChangeEffectiveDateApprov__c.year();
            AceCustomerHist custhist = new AceCustomerHist();
            boolean modified = false;
            
              custhist.changeDate = ah.lastmodifieddate;
              if(ah.lastmodifiedby.name == 'ACEMyPriceChanges Site Guest User')
                 custhist.ModifiedBy = acePriceChangeRec.Customer_Comments_Submitter__c;
              else
                 custhist.ModifiedBy = ah.lastmodifiedby.name;
            
            if (ah.Old_SalesPrice_Change_Effective_Date_Rep__c != ah.NewSales_Price_Change_Effective_Date_Rep__c && ah.NewSales_Price_Change_Effective_Date_Rep__c != null) 
            {
                custhist.changeDate = ah.lastmodifieddate;
                if(ah.lastmodifiedby.name == 'ACEMyPriceChanges Site Guest User')
                    custhist.ModifiedBy = acePriceChangeRec.Customer_Comments_Submitter__c;
                else
                    custhist.ModifiedBy = ah.lastmodifiedby.name;
                custhist.changes = 'A request to change the Sales Price Effective Date has been submitted - request to change effective date from ' + effdateNewApprov + ' to ' + effDateNewRep;
                modified = true;
            }
            
            else if (ah.Old_SalesPriceChangeEffectiveDateApprov__c != ah.new_SalesPrice_ChangeEffectiveDateApprov__c) {
                
                //AceCustomerHist custhist = new AceCustomerHist();
                custhist.changeDate = ah.lastmodifieddate;
                // custhist.ModifiedBy = ah.lastmodifiedby.name;
                if(ah.lastmodifiedby.name == 'ACEMyPriceChanges Site Guest User')
                    custhist.ModifiedBy = acePriceChangeRec.Customer_Comments_Submitter__c;
                else
                    custhist.ModifiedBy = ah.lastmodifiedby.name;
                    
                // custhist.changes = 'A new Sales Price change request has been <b><font color="Green"> approved </b></font>, changed from ' + effDateOldApprov + ' to <b><font color="Black">' + effdateNewApprov + '</font></b>';
                custhist.changes = 'A request to change the Sales Price Effective Date has been <b>approved</b> - effective date changed from ' + effDateOldApprov + ' to ' + effdateNewApprov;                
                // AceCustomerHistList.add(custhist);
                modified = true;
            }
            else if(ah.Old_Approval_Status__c == 'mod_Pending' && ah.New_Approval_Status__c == 'Modification'){
                custhist.changeDate = ah.lastmodifieddate;
                //custhist.ModifiedBy = ah.lastmodifiedby.name;
                if(ah.lastmodifiedby.name == 'ACEMyPriceChanges Site Guest User')
                    custhist.ModifiedBy = acePriceChangeRec.Customer_Comments_Submitter__c;
                else
                    custhist.ModifiedBy = ah.lastmodifiedby.name;
                // custhist.changes = 'The New Sales Price Effective Date Proposed has been Changed to <b><font color="Red">' + effDateNewRep + '</font></b>';
                custhist.changes = 'A request to change the Sales Price Effective Date has been <b>modified</b> - effective date changed from ' + effDateOldApprov + ' to ' + effDateNewRep;
                modified = true;
            } 
            //Code added by GUHA [04/05/2014] - Record Unlock/Lock History tracking.
            else if(ah.Record_Unlock_Status__c == 'Pending'){
                CustomerName = ah.Customer_Name__c;
                // custhist.changes = 'The customer <b><font color="blue">'+CustomerName+'</b></font> is <b><font color="orange">Submitted</b></font> for record unlock.';
                // custhist.changes = 'The customer <b><font color="black">'+CustomerName+'</b></font> is <b><font color="Black">Submitted</b></font> for record unlock.';
                custhist.changes = 'A request to unlock has been submitted'; 
                modified = true;
            }
            else if(ah.Record_Unlock_Status__c == 'Approved'){
                CustomerName = ah.Customer_Name__c;
                // custhist.changes = 'The customer  <b><font color="blue">'+CustomerName+'</b></font> is <b><font color="Green">Unlocked</b></font>.';
                // custhist.changes = 'The customer  <b><font color="black">'+CustomerName+'</b></font> is <b><font color="black">Unlocked</b></font>.';
                custhist.changes = 'A request to unlock has been <b><font color="black">approved</font></b>'; 
                modified = true;
            }
            else if(ah.Record_Unlock_Status__c == 'Rejected' || ah.Record_Unlock_Status__c == 'Recalled'){
                CustomerName = ah.Customer_Name__c;
                // custhist.changes = 'The customer <b><font color="blue">'+CustomerName+'</b></font> is submitted for record unlock and has been <b><font color="Red">Rejected</b></font> by manager';
                // custhist.changes = 'The customer <b><font color="black">'+CustomerName+'</b></font> is submitted for record unlock and has been <b><font color="black">Rejected</b></font> by manager';
                custhist.changes = 'A request to unlock has been <b><font color="black">rejected</font></b>'; 
                modified = true;
            }    
            //Code added by GUHA [04/05/2014] - Record Unlock/Lock History tracking Ends.
            
            else if(ah.Customer_Response__c == 'Approved'){
                // custhist.changes = 'The Customer <b><font color="blue">'+ah.Customer_Name__c+'</b></font> has <b><font color="Green">Approved</b></font>.';
                custhist.changes = 'Customer has <b>approved</b> the ' + acePriceChangeRec.batchID__c + ' price changes - approved by '+ acePriceChangeRec.Customer_Comments_Submitter__c;
                modified = true;
            }
            else if(ah.Customer_Response__c == 'Call Me'){
               // custhist.changes = 'The Customer <b><font color="blue">'+ah.Customer_Name__c+'</b></font> has requested for a <b><font color="Red">call back</b></font>';
                custhist.changes = acePriceChangeRec.Customer_Comments_Submitter__c + ' has <b>requested to be contacted</b> regarding ' + acePriceChangeRec.batchID__c + ' price changes';
                modified = true;
            }
            else if (ah.NewSales_Price_Change_Effective_Date_Rep__c == null) {   
                //AceCustomerHist custhist = new AceCustomerHist();
                custhist.changeDate = ah.lastmodifieddate;
                if(ah.lastmodifiedby.name == 'ACEMyPriceChanges Site Guest User')
                    custhist.ModifiedBy = acePriceChangeRec.Customer_Comments_Submitter__c;
                else
                    custhist.ModifiedBy = ah.lastmodifiedby.name;
                //custhist.ModifiedBy = ah.lastmodifiedby.name;                 
                // custhist.changes = 'A new Sales Price change request has been <b><font color="Red"> Rejected </b></font>, There is no Change to <b><font color="Green">' + effDateOldApprov + '</font></b>';                    
                custhist.changes = 'A request to change the Sales Price Effective Date has been <b>rejected</b> - effective date remains ' + effDateOldApprov;                    
                modified = true;
            }
                
            if (modified)
              AceCustomerHistList.add(custhist);
        }
        
    }
    
    public void nextPage(){
        counter = counter+List_size; 
        generateHistory();  
       
    }
    
    public void prevPage(){
        counter = counter-List_size;
        generateHistory();
       
    }
    
    public Boolean getDisablePrevious() {
     
      if (counter>0) return true; else return false;
    }
    
    public Boolean getDisableNext() { 
      if (counter + list_size < total_size) return true; else return false;
    }

}