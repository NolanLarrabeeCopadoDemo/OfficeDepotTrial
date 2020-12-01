global class ACEWRFCreation_Batch implements database.Batchable<Sobject>
{
    public String acequery ;
    global String batchId = '1';

    global ACEWRFCreation_Batch(){

        list<ACE_Batches__c> BatchName =[SELECT Id,Batch__c from ACE_Batches__c order by CreatedDate desc limit 5];
        if(BatchName[0]!= null)
            this.batchId = BatchName[0].Batch__c;

        //this.acequery  = 'SELECT Id,customer__r.Remediation_Required__c,Hosted_Catalog__c,PRICE_NOT_CALCULATED__c from ACE_Customer_Price_Changes__c where Name= \''+batchId +'\' '+ ' and (Customer__r.Remediation_Required__c = true OR Hosted_Catalog__c = true OR PRICE_NOT_CALCULATED__c = true)';
        // Updated the query for Case-00152641 //
        this.acequery  = 'SELECT Id,customer__c,customer__r.ownerID,Customer__r.Grandparent__c,Customer__r.Parent.Grandparent__c,' ;
        this.acequery += 'Customer__r.Parent.parent.Grandparent__c,Customer__r.Parent.id,Customer__r.Parent.Parent.Id,' ;
        //this.acequery += 'Owning_Customer_Legal__c,Customer__r.Primary_Product__c,customer__r.Remediation_Required__c,Hosted_Catalog__c,PRICE_NOT_CALCULATED__c,Update_Timing_Action__c from ACE_Customer_Price_Changes__c where Name= \''+batchId +'\' '+ ' and (Customer__r.Remediation_Required__c = true OR PRICE_NOT_CALCULATED__c = true)';
        this.acequery += 'Owning_Customer_Legal__c,Customer__r.Primary_Product__c,customer__r.Remediation_Required__c,Hosted_Catalog__c,PRICE_NOT_CALCULATED__c,Update_Timing_Action__c from ACE_Customer_Price_Changes__c where Name= \''+batchId +'\' '+ ' and ((Customer__r.Remediation_Required__c = true and PRICE_NOT_CALCULATED__c = false) OR (Customer__r.Remediation_Required__c = false and PRICE_NOT_CALCULATED__c = true))'; 
        this.acequery += 'and Update_Timing_Action__c = \'T\'';//ROM-37 - to not create WRFs for Update_Timing_Action__c = 'F'
    }

    global Database.QueryLocator start(Database.BatchableContext BC)
    {
        return Database.getQueryLocator(acequery);
    }
     // Start : Added by Mohit for Story S-353024 //
    global void execute(Database.BatchableContext BC, SObject[] scope) {
      List<ACE_Customer_Price_Changes__c> custRecords= scope;
      ACEWRFCreation wrf = new ACEWRFCreation();
      wrf.createWRFFromBatch(custRecords);
    }
    // End

    /* Comment by Mohit for Story S-353024 //
    global void execute(Database.BatchableContext BC, SObject[] scope)
    {
      List<ACE_Customer_Price_Changes__c> custRecords= scope;

      List<ID> custRemIDs = new List<ID>();
      List<ID> custHostIDs = new List<ID>();
      List<ID> custPriceIDs = new List<ID>();

      List<case> caseList = new List<case>();
      Set<ID> caseSet = new Set<ID>();
      caseList = [select Customer_Core_Price_Changes__r.id from case where Customer_Core_Price_Changes__c!=null and WRF_Request_Type__c = 'BSD Pricing'];
      for(case cs:caseList){
          caseSet.add(cs.Customer_Core_Price_Changes__r.id);
      }


      for(ACE_Customer_Price_Changes__c cus:custRecords){
          if(cus.PRICE_NOT_CALCULATED__c && cus.customer__r.Remediation_Required__c && cus.Hosted_Catalog__c)
              custPriceIDs.add(cus.id);
          else if(cus.PRICE_NOT_CALCULATED__c && !cus.Hosted_Catalog__c && !cus.customer__r.Remediation_Required__c)
              custPriceIDs.add(cus.id);
          else if(cus.PRICE_NOT_CALCULATED__c && cus.Hosted_Catalog__c && !cus.customer__r.Remediation_Required__c)
              custPriceIDs.add(cus.id);
          else if(cus.PRICE_NOT_CALCULATED__c && !cus.Hosted_Catalog__c && cus.customer__r.Remediation_Required__c)
              custPriceIDs.add(cus.id);
          else if(!cus.PRICE_NOT_CALCULATED__c && cus.Hosted_Catalog__c && cus.customer__r.Remediation_Required__c)
              custRemIDs.add(cus.id);
          else if(!cus.PRICE_NOT_CALCULATED__c && !cus.Hosted_Catalog__c && cus.customer__r.Remediation_Required__c)
              custRemIDs.add(cus.id);
          else if(!cus.PRICE_NOT_CALCULATED__c && cus.Hosted_Catalog__c && !cus.customer__r.Remediation_Required__c && !caseSet.contains(cus.id))
              custHostIDs.add(cus.id);
      }


      system.debug('$$$$$$$$$$$custRemIDs'+custRemIDs);
      system.debug('$$$$$$$$$$$custHostIDs'+custHostIDs);
      system.debug('$$$$$$$$$$$custPriceIDs'+custPriceIDs);
      ACEWRFCreation wrf = new ACEWRFCreation();

      if(custRemIDs.size()>0)
          wrf.createWRF(custRemIDs,'Remediation');

      if(custHostIDs.size()>0){
        wrf.createWRF(custHostIDs,'BSD Pricing');
      }

      if(custPriceIDs.size()>0)
          wrf.createWRF(custPriceIDs,'Compliance');

    }
    */
    global void finish(Database.BatchableContext BC)
    {
       System.debug('Completed Processing.... ACE WRF Case Batch for :'+batchId) ;
    }
}