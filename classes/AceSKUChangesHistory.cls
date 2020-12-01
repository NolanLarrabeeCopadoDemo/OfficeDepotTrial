public with sharing class AceSKUChangesHistory {
public ID custSKUChangesID {get;set;}
public String pageval {get;set;}
public Boolean skuRender {get;set;}
public Integer List_size = 5;
public Integer total_size{get;set;}
public Integer counter = 0;
public class AceSKUHist {
    public String SKU{get;set;}
    public DateTime changeDate {get;set;}
    public String ApprovalStatus {get;set;}
    public String ModifiedBy {get;set;}
    public String changes {get;set;}
    
}

public list<AceSKUHist> AceSKUHistList {get;set;}

public AceSKUChangesHistory() {            
    generateList();
}
    public void generateList(){
        custSKUChangesID = ApexPages.currentPage().getParameters().get('id');//controller.getId();    
        list<Audit_History__c> aHist = new list<Audit_History__c>();        
        skuRender = false;        
        aHist = [select New_Approval_status__c, Old_Approval_status__c, 
                                        New_User_Proposed_Price__c, Old_User_Proposed_Price__c,
                                        New_Approval_Price__c, Old_Approval_Price__c,
                                        lastmodifieddate, lastmodifiedby.name
                                        from Audit_History__c 
                                        where Ace_Customer_SKU_Changes__c = :custSKUChangesID                                   
                                        order by createddate desc limit :List_size OFFSET :counter];  // query for sku level
        total_size = [select count() from Audit_History__c where Ace_Customer_SKU_Changes__c = :custSKUChangesID ];                                    
        if(aHist.size() <= 0) { //loop for price change obj level        
            skuRender = true;
            pageval = '1';
            // below lines to pull out  core under the price change record                
            List<Ace_Customer_Core_Changes__c> lCustomerCoreChanges = [Select id,CoreID__c, ACE_Customer_Price_Changes__c from Ace_Customer_Core_Changes__c where ACE_Customer_Price_Changes__c =:custSKUChangesID   ];            
            Set<ID> sIDs = new Set<ID>();       
            for(Ace_Customer_Core_Changes__c l: lCustomerCoreChanges)
                {
                    sIDs.add(l.id);
                }
                
            // below line to pull out all the skus under each core in the above list    
            List<Ace_Customer_SKU_Changes__c> skuList = new List<Ace_Customer_SKU_Changes__c>();
            skuList = [select id, SKU__c from Ace_Customer_SKU_Changes__c where Ace_Customer_Core_Changes__c in :sIDs];
            Set<ID> skuIDs= new Set<ID>();
            for(Ace_Customer_SKU_Changes__c s: skuList)
                {
                    skuIDs.add(s.id);
                }
            
            //query to pull out history records matching the sku list    
            aHist = [select SKU__c, New_Approval_status__c, Old_Approval_status__c, 
                                            New_User_Proposed_Price__c, Old_User_Proposed_Price__c,
                                            New_Approval_Price__c, Old_Approval_Price__c,
                                            lastmodifieddate, lastmodifiedby.name
                                            from Audit_History__c 
                                            where Ace_Customer_SKU_Changes__c in :skuIDs
                                            order by createddate desc limit :List_size OFFSET :counter]; //query for price change level
            total_size = [select count() from Audit_History__c where Ace_Customer_SKU_Changes__c in :skuIDs];                                        
        }
                                    
        AceSKUHistList = new list<AceSKUHist>();
        For (Audit_History__c ah : aHist) {
            if(ah.Old_Approval_Price__c == null)
                    ah.Old_Approval_Price__c = 0.0;
                if(ah.New_User_Proposed_Price__c == null)
                     ah.New_User_Proposed_Price__c = 0.0;
                if(ah.new_Approval_Price__c == null)
                     ah.new_Approval_Price__c = 0.0;  
                     
            if (ah.Old_Approval_status__c != ah.New_Approval_status__c) 
            {            
                AceSKUHist SKUhist = new AceSKUHist();            
                if(pageval == '1') //only for price change level
                    SKUhist.SKU = ah.SKU__c;
                
                SKUhist.changeDate = ah.lastmodifieddate;
                SKUhist.ModifiedBy = ah.lastmodifiedby.name;
                  
                    
                if (ah.Old_Approval_status__c == null || ah.Old_Approval_status__c == ''){
                   // SKUhist.changes = 'A new Sales Price Exception Request has been submitted, change requested from <b><font color="Black"/>$' +ah.Old_Approval_Price__c+ ' </font></b> to <b><font color="Black"/>$'+ ah.New_User_Proposed_Price__c +'.</font></b>';
                   SKUhist.changes = 'A request to change the Sales Price';
                   if(pageval == '1')
                       SKUhist.changes = SKUhist.changes + ' for ' +  ah.SKU__c+ ' has been submitted - request to change sales price from $' +ah.Old_Approval_Price__c+ ' to $'+ ah.New_User_Proposed_Price__c;
                   else
                       SKUhist.changes = SKUhist.changes + ' has been submitted - request to change sales price from $' +ah.Old_Approval_Price__c+ ' to $'+ ah.New_User_Proposed_Price__c;     
                }
                
                else if (ah.New_Approval_status__c == 'Pending')
                {
                    // SKUhist.changes = 'A request to change the Sales Price for ' + ah.SKU__c+ ' has been submitted - request to change sales price from $' +ah.Old_Approval_Price__c+ ' to $'+ ah.New_User_Proposed_Price__c;
                    SKUhist.changes = 'A request to change the Sales Price';
                    if(pageval == '1')
                       SKUhist.changes = SKUhist.changes + ' for ' +  ah.SKU__c+ ' has been submitted - request to change sales price from $' +ah.Old_Approval_Price__c+ ' to $'+ ah.New_User_Proposed_Price__c;
                    else
                       SKUhist.changes = SKUhist.changes + ' has been submitted - request to change sales price from $' +ah.Old_Approval_Price__c+ ' to $'+ ah.New_User_Proposed_Price__c;     
                
                } 
                else if(ah.New_Approval_status__c == 'Approved'){//
                    // SKUhist.changes = 'A new Sales Price Exception Request has been approved, changed from <b><font color="Black">$' + ah.Old_Approval_Price__c + ' </font></b> to <b><font color="Black"/>$' + ah.New_Approval_Price__c+ '.</font></b>';
                    // SKUhist.changes = 'A request to change the Sales Price for ' + ah.SKU__c+ ' has been <b>approved<b> - price changed from $' +ah.Old_Approval_Price__c+ ' to $'+ ah.New_Approval_Price__c;
                    SKUhist.changes = 'A request to change the Sales Price';
                    if(pageval == '1')
                       SKUhist.changes = SKUhist.changes + ' for ' +  ah.SKU__c+ ' has been <b>approved<b> - price changed from $' +ah.Old_Approval_Price__c+ ' to $'+ ah.New_Approval_Price__c;
                    else
                       SKUhist.changes = SKUhist.changes + ' has been <b>approved<b> - price changed from $' +ah.Old_Approval_Price__c+ ' to $'+ ah.New_Approval_Price__c;
                
                }
                
                else if(ah.New_Approval_status__c == 'Rejected'){
                   // SKUhist.changes = 'New Price Exception Request has been rejected and there is no changes made to the Apprved proposed price <b><font color="Black"/>$' + ah.Old_Approval_Price__c+ '.</font></b>';
                   // SKUhist.changes = 'A request to change the Sales Price for ' + ah.SKU__c+ ' has been <b>rejected<b> - price remains $' +ah.Old_Approval_Price__c;
                    SKUhist.changes = 'A request to change the Sales Price';
                    if(pageval == '1')
                       SKUhist.changes = SKUhist.changes + ' for ' +  ah.SKU__c+ ' has been <b>rejected<b> - price remains $' +ah.Old_Approval_Price__c;
                    else
                       SKUhist.changes = SKUhist.changes + ' has been <b>rejected<b> - price remains $' +ah.Old_Approval_Price__c;
                 
                }
                else if(ah.New_Approval_status__c == 'Modification'){
                    // SKUhist.changes = 'The Approver has Modified the price exception to <b><font color="Black"/>$' + ah.New_User_Proposed_Price__c+ '.</font></b>';
                     // SKUhist.changes = 'A request to change the Sales Price for ' + ah.SKU__c+ ' has been <b>modified</b> - price changed from  $' +ah.Old_Approval_Price__c+ ' to $'+ ah.New_User_Proposed_Price__c;
                     SKUhist.changes = 'A request to change the Sales Price';
                     if(pageval == '1')
                       SKUhist.changes = SKUhist.changes + ' for ' +  ah.SKU__c+ ' has been <b>modified</b> - price changed from  $' +ah.Old_User_Proposed_Price__c+ ' to $'+ ah.New_User_Proposed_Price__c;
                     else
                       SKUhist.changes = SKUhist.changes + ' has been <b>modified</b> - price changed from  $' +ah.Old_User_Proposed_Price__c+ ' to $'+ ah.New_User_Proposed_Price__c;
                 
                }
                
                AceSKUHistList.add(SKUhist);
            }    
            else if (ah.Old_Approval_Price__c != ah.new_Approval_Price__c)   
            {
                                    
                AceSKUHist SKUhist = new AceSKUHist(); 
                if(pageval == '1') //only for price change level
                    SKUhist.SKU = ah.SKU__c;
                SKUhist.changeDate = ah.lastmodifieddate;
                SKUhist.ModifiedBy = ah.lastmodifiedby.name;
              //  SKUhist.changes = 'A new Sales Price change request has been auto-approved, changed from <b><font color="Blue"/>$' + ah.Old_Approval_Price__c + '</font></b> to <b><font color="Green"/>$' + ah.new_Approval_Price__c + '</font></b>.';
               //  SKUhist.changes = 'A request to change the Sales Price for ' + ah.SKU__c+ ' has been <b>accepted</b> - price changed from $' + ah.Old_Approval_Price__c + ' to $' + ah.new_Approval_Price__c;
                SKUhist.changes = 'A request to change the Sales Price';
                     if(pageval == '1')
                       SKUhist.changes = SKUhist.changes + ' for ' +  ah.SKU__c+ ' has been <b>accepted</b> - price changed from $' + ah.Old_Approval_Price__c + ' to $' + ah.new_Approval_Price__c;
                     else
                       SKUhist.changes = SKUhist.changes + ' has been <b>accepted</b> - price changed from $' + ah.Old_Approval_Price__c + ' to $' + ah.new_Approval_Price__c;
                 
                AceSKUHistList.add(SKUhist);
            }                  
        }
    }
    
    public String formatCurrency(Decimal d) {
        List<String> args = new String[]{'0','number','###,###,###.##'};
        if (d != null)
         return String.format(d.format(), args);
        else
         return '';
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