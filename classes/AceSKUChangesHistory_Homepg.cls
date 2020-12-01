public with sharing class AceSKUChangesHistory_Homepg {

public ID custSKUChangesID {get;set;}
public String pageval {get;set;}
public Boolean skuRender {get;set;}
public Integer List_size = 15;
public Integer total_size{get;set;}
public Integer counter = 0;
public list<AceSKUHist> AceSKUHistList {get;set;}
public string currentQuarter {get;set;}

    public class AceSKUHist {
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


    public AceSKUChangesHistory_Homepg() {  
        list<ACE_Settings__c> desettings =[SELECT Id, Name, Current_Quarter__c from ACE_Settings__c limit 1];
        if(desettings[0]!= null)
            currentQuarter = desettings[0].Current_Quarter__c;             
        generateList();
    }
    
    public void generateList(){
        
         
        list<Audit_History__c> aHist = new list<Audit_History__c>();        
              
            aHist = [select SKU__c, Ace_Customer_SKU_Changes__r.Ace_Customer_Core_Changes__r.ACE_Customer_Price_Changes__r.customer__r.owner.name,
                                Ace_Customer_SKU_Changes__r.Ace_Customer_Core_Changes__r.ACE_Customer_Price_Changes__r.customer__r.name,
                                Ace_Customer_SKU_Changes__r.Ace_Customer_Core_Changes__r.ACE_Customer_Price_Changes__r.customer__r.cust_ID__c,
                                            New_Approval_status__c, Old_Approval_status__c, HomePage_Approval_Price__c,
                                            New_User_Proposed_Price__c, Old_User_Proposed_Price__c,
                                            New_Approval_Price__c, Old_Approval_Price__c,
                                            lastmodifieddate, lastmodifiedby.name
                                            from Audit_History__c 
                                            where SKU__c != null 
                                            and Ace_Customer_SKU_Changes__r.Ace_Customer_Core_Changes__r.ACE_Customer_Price_Changes__r.name = :currentQuarter
                                            AND CreatedByID =:UserInfo.getUserId()
                                            and New_Approval_status__c in ('Approved','Rejected','Modification')
                                            order by createddate desc limit :List_size OFFSET :counter]; 
            total_size = [select count() from Audit_History__c where SKU__c != null AND Ace_Customer_SKU_Changes__r.Ace_Customer_Core_Changes__r.ACE_Customer_Price_Changes__r.name = :currentQuarter and New_Approval_status__c in ('Approved','Rejected','Modification') and CreatedByID =:UserInfo.getUserId()];                                        
                                    
        AceSKUHistList = new list<AceSKUHist>();
        For (Audit_History__c ah : aHist) {
            if (ah.SKU__c != null || ah.SKU__c != '') {            
                AceSKUHist SKUhist = new AceSKUHist();            
                SKUhist.SKU = ah.SKU__c;             
                SKUhist.changeDate = ah.lastmodifieddate;
                SKUhist.ModifiedBy = ah.lastmodifiedby.name;
                
                 SKUhist.CustName = ah.Ace_Customer_SKU_Changes__r.Ace_Customer_Core_Changes__r.ACE_Customer_Price_Changes__r.customer__r.name;
                SKUhist.CustID = ah.Ace_Customer_SKU_Changes__r.Ace_Customer_Core_Changes__r.ACE_Customer_Price_Changes__r.customer__r.cust_ID__c;
                SKUhist.Cust_ownerName = ah.Ace_Customer_SKU_Changes__r.Ace_Customer_Core_Changes__r.ACE_Customer_Price_Changes__r.customer__r.owner.name;
                              
                if (ah.New_Approval_status__c == 'Pending'){
                   // SKUhist.changes = 'The Approver has submitted a New Price Exception Request for<b><font color="black"/>$ '+ ah.New_User_Proposed_Price__c +'</font></b> and Approval Status is <b><font color="Orange"/>' + ah.New_Approval_status__c+ '</font></b>';
                    SKUhist.changes = 'A request to change the Sales Price ' + SKUhist.CustName + ' - ' + SKUhist.CustID + ' has been submitted - request to change sales price from $'+  ah.Old_Approval_Price__c + ' to $' + ah.New_User_Proposed_Price__c;
                }
                
                else if(ah.New_Approval_status__c == 'Approved'){
                   // SKUhist.changes = 'The Price exception is <b><font color="black">$ ' + ah.New_User_Proposed_Price__c + '</font></b> and has been <b><font color="Green">Approved</font></b>';
                    SKUhist.changes = 'A request to change the Sales Price ' + SKUhist.CustName + ' - ' + SKUhist.CustID + ' has been <b>approved</b> - price changed from $'+  ah.Old_Approval_Price__c + ' to $' + ah.New_User_Proposed_Price__c;
                }
                
                else if(ah.New_Approval_status__c == 'Rejected'){
                    // SKUhist.changes = 'The Approver has <b><font color="Red">Rejected</font></b> the price exception and There is no changes made to the Approved proposed price <b><font color="black"/>$ ' + ah.Old_Approval_Price__c+ '</font></b>';
                    SKUhist.changes = 'A request to change the Sales Price ' + SKUhist.CustName + ' - ' + SKUhist.CustID + ' has been <b>rejected</b> - price remains  $'+  ah.Old_Approval_Price__c;
                }
                else if(ah.New_Approval_status__c == 'Modification'){
                    SKUhist.changes = 'The Approver has <b><font color="Green">Modified</font></b> the price exception to <b><font color="black"/>$ ' + ah.New_User_Proposed_Price__c+ '</font></b>';
                    SKUhist.changes = 'A request to change the Sales Price ' + SKUhist.CustName + ' - ' + SKUhist.CustID + '  has been <b>modified</b> - price changed from $'+  ah.Old_Approval_Price__c + ' to $' + ah.New_User_Proposed_Price__c;
                }
                
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
     
      if (counter>0) return true; 
      else return false;
    }
    
    public Boolean getDisableNext() { 
      if (counter + list_size < total_size) return true; else return false;
    }

}