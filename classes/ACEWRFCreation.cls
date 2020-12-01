public class ACEWRFCreation {

    private static Map<String,Schema.RecordTypeInfo> CaseRecType = Schema.SObjectType.Case.getRecordTypeInfosByName();
    ACE_Settings__c CS;

    // Start : Added by Mohit for Story S-353024 //
    Date myDate = system.today();
    public list<WRF_Task__c> taskComplianceList = new list<WRF_Task__c>();
    public list<WRF_Task__c> taskRemediationList = new list<WRF_Task__c>();
    public list<WRF_Task__c> taskBSDPricingList = new list<WRF_Task__c>();
    public list<Case> newlyCasesLst = new list<Case>();
    public list<WRF_Task__c> allWRFtaskLst = new list<WRF_Task__c>();

    // End : Added by Mohit for Story S-353024 //
    public ACEWRFCreation(){
        CS = new ACE_Settings__c();
        CS = [select Domain_URL__c from ACE_Settings__c order by CreatedDate Desc limit 1];
    }

    private final String CONST_COMPLIANCE = 'Compliance' ;
    private final String CONST_REMEDIATION = 'Remediation' ;
    private final String CONST_BSD_PRICING = 'BSD Pricing' ;

    private string getRTValue(ACE_Customer_Price_Changes__c cus,Set<ID> caseSet) {
        if(cus.Update_Timing_Action__c == 'T')//ROM-37 - to not create WRFs for Update_Timing_Action__c = 'F'
        {   
           if(cus.PRICE_NOT_CALCULATED__c && cus.customer__r.Remediation_Required__c && cus.Hosted_Catalog__c)
              //return CONST_COMPLIANCE ;
              return CONST_REMEDIATION; //modified as per case#00822941
          else if(cus.PRICE_NOT_CALCULATED__c && !cus.Hosted_Catalog__c && !cus.customer__r.Remediation_Required__c)
              return CONST_COMPLIANCE ;
          else if(cus.PRICE_NOT_CALCULATED__c && cus.Hosted_Catalog__c && !cus.customer__r.Remediation_Required__c)
              return CONST_COMPLIANCE ;
          else if(cus.PRICE_NOT_CALCULATED__c && !cus.Hosted_Catalog__c && cus.customer__r.Remediation_Required__c)
              //return CONST_COMPLIANCE ;
              return CONST_REMEDIATION ; //modified as per case#00822941
          else if(!cus.PRICE_NOT_CALCULATED__c && cus.Hosted_Catalog__c && cus.customer__r.Remediation_Required__c)
              return CONST_REMEDIATION ;
          else if(!cus.PRICE_NOT_CALCULATED__c && !cus.Hosted_Catalog__c && cus.customer__r.Remediation_Required__c)
              return CONST_REMEDIATION ;
          else if(!cus.PRICE_NOT_CALCULATED__c && cus.Hosted_Catalog__c && !cus.customer__r.Remediation_Required__c && !caseSet.contains(cus.id))
              return CONST_BSD_PRICING ;
        }
        return null ;
    }
    // Newly Added method #Mohit
   public void createWRFFromBatch(list<ACE_Customer_Price_Changes__c> custList) {

      List<ID> custRemIDs = new List<ID>();
      List<ID> custHostIDs = new List<ID>();
      List<ID> custPriceIDs = new List<ID>();

      List<case> caseList = new List<case>();
      Set<ID> caseSet = new Set<ID>();
      caseList = [select Customer_Core_Price_Changes__r.id from case where Customer_Core_Price_Changes__c!=null and WRF_Request_Type__c = 'BSD Pricing'];
      for(case cs:caseList){
          caseSet.add(cs.Customer_Core_Price_Changes__r.id); 
      }

      List<case> caseListtoInsert = new list<case>();
      Map<String,List<Case>> reqTypeCaseMap = new Map<String,List<Case>>();

        Map<String, String> map_Str_str = new Map<String, String>();
        for(Ace_Customer_Core_Changes__c cor:[select id,Ace_Customer_Price_Changes__r.id from Ace_Customer_Core_Changes__c where Ace_Customer_Price_Changes__c in: custList])
        {
            if(!map_Str_str.containsKey(cor.Ace_Customer_Price_Changes__r.id))
            {
               map_Str_str.put(cor.Ace_Customer_Price_Changes__r.id, cor.id);
            }
            else
            {
               String temp = map_Str_str.get(cor.Ace_Customer_Price_Changes__r.id);
               temp = temp + ',' + cor.id;
               map_Str_str.remove(cor.Ace_Customer_Price_Changes__r.id);
               map_Str_str.put(cor.Ace_Customer_Price_Changes__r.id, temp);
            }
        }

        for(ACE_Customer_Price_Changes__c cus:custList){
            string REMorHOSTED = getRTValue(cus,caseSet);
            if(REMorHOSTED == null) {
                continue ;
            }
            ID CusID = cus.id;
            case newCase = new case();
            newCase.recordTypeId = CaseRecType.get('Work Request').getRecordTypeId();
            newCase.AccountId = cus.customer__c;
            newCase.WRF_Requestor__c = cus.customer__r.ownerID;
            newCase.WRF_Submission_Issue__c = 'Incorrect/Incomplete information';
            newCase.Priority = '3-Medium';
            newCase.WRF_Written_Agreement__c = cus.Owning_Customer_Legal__c;
            newCase.WRF_Request_Type__c = REMorHOSTED; //This field is a picklist. so what should be the pick list value for this field.
            newCase.WRF_Other_Core_Update__c = 'Automated Price Increase Process';
            newCase.WRF_Core_Update_Descr__c = 'Vendor Cost Increase';
            newCase.Existing_New_Core__c = 'Existing';
            system.debug('>>>>>>>>>>'+map_Str_str.get(cus.id));
            if(map_Str_str.get(cus.id)!=null){
                if(map_Str_str.get(cus.id).length()>255)
                    newCase.Hosted_Cores__c = map_Str_str.get(cus.id).substring(0,255);
                else
                    newCase.Hosted_Cores__c = map_Str_str.get(cus.id);
            }
            else{
                newCase.Hosted_Cores__c = '';
            }
            newCase.Hosted_Core_NCC__c = 'Core(s) ONLY';
            newCase.WRF_RFP_RFQ__c = 'No';
            newCase.WRF_Prod_Type__c = cus.Customer__r.Primary_Product__c;

            if(cus.Customer__r.Parent.id!=null){
                if(cus.Customer__r.Parent.Grandparent__c == 'Yes' || cus.Customer__r.Parent.Parent.Grandparent__c == 'Yes')
                    newCase.WRF_Current_GPO__c =  'Other (GPO)';
                else
                    newCase.WRF_Current_GPO__c =  'Standalone (GPO)';
            }
            else{
                newCase.WRF_Current_GPO__c =  'Standalone (GPO)';
            }
            //newCase.WRF_Current_GPO__c =  // Need discussion with deepak for this logic.

            newCase.Preliminary_Core_Review__c = 'Yes';
            newCase.WRF_3rd_Party_eprocurement__c = '';
            newCase.WRF_eproc_Contact__c = '';
            newCase.WRF_Eproc_Phone__c = '';
            newCase.WRF_Eproc_Email__c = '';
            newCase.Price_Change_Link__c = CS.Domain_URL__c +'/'+CusID;
            newCase.Customer_Core_Price_Changes__c = CusID;
            newCase.Status = 'Open';

           //if(!reqTypeCaseMap.containsKey(REMorHOSTED)) {
            //    reqTypeCaseMap.put(REMorHOSTED, new List<Case>{});
        //    }
         //   reqTypeCaseMap.get(REMorHOSTED).add(newCase);
            caseListtoInsert.add(newCase);
        }
        if(caseListtoInsert.size() > 0 ) {
            insert caseListtoInsert ;

            //for(Case c : caseListtoInsert) {
            for(Case c : [Select Id, ACCT_Market_Sector__c,WRF_Request_Type__c,Customer_Core_Price_Changes__r.name,Customer_Core_Price_Changes__r.id from Case where id in :caseListtoInsert]) {
                if(!reqTypeCaseMap.containsKey(c.WRF_Request_Type__c)) {
                    reqTypeCaseMap.put(c.WRF_Request_Type__c, new List<Case>{});
                }
                reqTypeCaseMap.get(c.WRF_Request_Type__c).add(c);
            }

            if(reqTypeCaseMap.size() > 0) {
                // Start : Added by Mohit for Story S-353024 //
                if((reqTypeCaseMap.get(CONST_COMPLIANCE) != null) && (reqTypeCaseMap.get(CONST_COMPLIANCE)).size()>0)
                    allWRFtaskLst.addAll(taskCompliance(reqTypeCaseMap.get(CONST_COMPLIANCE)));
                if((reqTypeCaseMap.get(CONST_REMEDIATION) != null) && (reqTypeCaseMap.get(CONST_REMEDIATION)).size()>0)
                    allWRFtaskLst.addAll(taskRemediation(reqTypeCaseMap.get(CONST_REMEDIATION)));
                if((reqTypeCaseMap.get(CONST_BSD_PRICING) != null) && (reqTypeCaseMap.get(CONST_REMEDIATION)).size()>0)
                    allWRFtaskLst.addAll(taskBSDPricing(reqTypeCaseMap.get(CONST_BSD_PRICING)));
                system.debug('------------allWRFtaskLst :: '+Limits.getQueries());
                if(allWRFtaskLst.size()>0)
                    upsert allWRFtaskLst;
                    system.debug('------------allWRFtaskLst :: '+Limits.getQueries());
                // End //
            }
        }
   }
   
   public void createWRF(list<ID> custID, String REMorHOSTED){
    //public void createWRF(list<ID> allIds,List<Id> custRemIDs,List<Id> custHostIDs,List<Id> custPriceIDs){
        List<case> caseListtoInsert = new list<case>();

        list<ACE_Customer_Price_Changes__c> custList = [select id,
                                                               customer__c,
                                                               customer__r.ownerID,
                                                               Customer__r.Grandparent__c,
                                                               Customer__r.Parent.Grandparent__c,
                                                               Customer__r.Parent.parent.Grandparent__c,
                                                               Customer__r.Parent.id,
                                                               Customer__r.Parent.Parent.Id,
                                                               Owning_Customer_Legal__c,
                                                               Customer__r.Primary_Product__c
                                                               from ACE_Customer_Price_Changes__c where id in:custID];
        Map<String, String> map_Str_str = new Map<String, String>();
        for(Ace_Customer_Core_Changes__c cor:[select id,Ace_Customer_Price_Changes__r.id from Ace_Customer_Core_Changes__c where Ace_Customer_Price_Changes__c in: custList])
        {
            if(!map_Str_str.containsKey(cor.Ace_Customer_Price_Changes__r.id))
            {
               map_Str_str.put(cor.Ace_Customer_Price_Changes__r.id, cor.id);
            }
            else
            {
               String temp = map_Str_str.get(cor.Ace_Customer_Price_Changes__r.id);
               temp = temp + ',' + cor.id;
               map_Str_str.remove(cor.Ace_Customer_Price_Changes__r.id);
               map_Str_str.put(cor.Ace_Customer_Price_Changes__r.id, temp);
            }
        }
        for(ACE_Customer_Price_Changes__c cus:custList){
            ID CusID = cus.id;
            case newCase = new case();
            newCase.recordTypeId = CaseRecType.get('Work Request').getRecordTypeId();
            newCase.AccountId = cus.customer__c;
            newCase.WRF_Requestor__c = cus.customer__r.ownerID;
            newCase.WRF_Submission_Issue__c = 'Incorrect/Incomplete information';
            newCase.Priority = '3-Medium';
            newCase.WRF_Written_Agreement__c = cus.Owning_Customer_Legal__c;
            newCase.WRF_Request_Type__c = REMorHOSTED; //This field is a picklist. so what should be the pick list value for this field.
            newCase.WRF_Other_Core_Update__c = 'Automated Price Increase Process';
            newCase.WRF_Core_Update_Descr__c = 'Vendor Cost Increase';
            newCase.Existing_New_Core__c = 'Existing';
            system.debug('>>>>>>>>>>'+map_Str_str.get(cus.id));
            if(map_Str_str.get(cus.id)!=null){
                if(map_Str_str.get(cus.id).length()>255)
                    newCase.Hosted_Cores__c = map_Str_str.get(cus.id).substring(0,255);
                else
                    newCase.Hosted_Cores__c = map_Str_str.get(cus.id);
            }
            else{
                newCase.Hosted_Cores__c = '';
            }
            newCase.Hosted_Core_NCC__c = 'Core(s) ONLY';
            newCase.WRF_RFP_RFQ__c = 'No';
            newCase.WRF_Prod_Type__c = cus.Customer__r.Primary_Product__c;

            if(cus.Customer__r.Parent.id!=null){
                if(cus.Customer__r.Parent.Grandparent__c == 'Yes' || cus.Customer__r.Parent.Parent.Grandparent__c == 'Yes')
                    newCase.WRF_Current_GPO__c =  'Other (GPO)';
                else
                    newCase.WRF_Current_GPO__c =  'Standalone (GPO)';
            }
            else{
                newCase.WRF_Current_GPO__c =  'Standalone (GPO)';
            }
            //newCase.WRF_Current_GPO__c =  // Need discussion with deepak for this logic.

            newCase.Preliminary_Core_Review__c = 'Yes';
            newCase.WRF_3rd_Party_eprocurement__c = '';
            newCase.WRF_eproc_Contact__c = '';
            newCase.WRF_Eproc_Phone__c = '';
            newCase.WRF_Eproc_Email__c = '';
            newCase.Price_Change_Link__c = CS.Domain_URL__c +'/'+CusID;
            newCase.Customer_Core_Price_Changes__c = CusID;
            newCase.Status = 'Open';

            caseListtoInsert.add(newCase);
        }
        system.debug('$$$$$$$$$$$caseListtoInsert'+caseListtoInsert);
        insert caseListtoInsert;
        system.debug('------------caseListtoInsert :: '+Limits.getQueries());
        if(caseListtoInsert.size() > 0){
            newlyCasesLst = [Select Id, ACCT_Market_Sector__c,WRF_Request_Type__c,Customer_Core_Price_Changes__r.name,Customer_Core_Price_Changes__r.id from Case where id in :caseListtoInsert];
        }

        // Start : Added by Mohit for Story S-353024 //
        if(newlyCasesLst.size() > 0){
            if(REMorHOSTED == 'Compliance')
                allWRFtaskLst.addAll(taskCompliance(newlyCasesLst));
            if(REMorHOSTED == 'Remediation')
                allWRFtaskLst.addAll(taskRemediation(newlyCasesLst));
            if(REMorHOSTED == 'BSD Pricing')
                allWRFtaskLst.addAll(taskBSDPricing(newlyCasesLst));
        }
        System.debug('====allWRFtaskLst===='+allWRFtaskLst);
        if(allWRFtaskLst.size()>0)
            upsert allWRFtaskLst;
            system.debug('------------allWRFtaskLst :: '+Limits.getQueries());
        // End //

    }

    // Start : Added by Mohit for Story S-353024 //
    public List<WRF_Task__c> taskCompliance(List<case> cases)
    {

        for(Case cs : Cases){

            // Creating WRF Task for Lifecycle
            WRF_Task__c wrf = new WRF_Task__c(WRF__c = cs.id,
            WRF_Task_Name__c = 'ACE Price Increase Issue for Customer',
            Comments__c = 'Please review the customer\'s CSF and Contract Pricing Terms, and determine the cause of the ACE kick-out. Please let the Remediation/Lifecycle analyst know how they need to handle the increases. Thank you!',
            Disposition_Code__c = 'Lifecycle',
            Assignment_Group__c = 'Contract Life Cycle',
           // Assigned_To__c = label.Rich_Mumford,
            Due_Date__c = myDate.addDays(10),
            Priority__c = 'Normal',
            Status__c = 'Not Started');
            taskComplianceList.add(wrf);


            // Creating WRF Task for Pricing

            WRF_Task__c wrf1 = new WRF_Task__c(WRF__c = cs.id,
            WRF_Task_Name__c = 'Price Increases for Customer',
            Comments__c = 'Price Increases for ' + cs.Customer_Core_Price_Changes__r.name + ' - please see "Price Change Link" on WRF for SKU details and work via the "Customer Price Changes" tab interface in SFDC',
            Due_Date__c = myDate.addDays(10),
            Priority__c = 'Normal',
            //Assigned_To__c = label.Rich_Mumford ,
            Status__c = 'Not Started');
            //System.debug('====cs.ACCT_Market_Sector__c==='+cs.ACCT_Market_Sector__c);
            if(cs.ACCT_Market_Sector__c == 'Public'){
                wrf1.Disposition_Code__c = 'Public/GPO';
                wrf1.Assignment_Group__c = 'Public/GPO';
          //      wrf1.Assigned_To__c = label.Stephen_Burger;
            }else{
                wrf1.Disposition_Code__c = 'Remediation';
                wrf1.Assignment_Group__c = 'Lifecycle/Remediation';
            //    wrf1.Assigned_To__c = label.Rich_Mumford;
            }
            System.debug('====wrf1==='+wrf1);
            taskComplianceList.add(wrf1);
        }
        if( taskComplianceList.size() > 0){
            return taskComplianceList;
        }
        return null;
    }

    public List<WRF_Task__c> taskRemediation(List<case> cases)
    {

        for(Case cs : Cases){

            // Creating WRF Task for Lifecycle

            WRF_Task__c wrf = new WRF_Task__c(WRF__c = cs.id,
            WRF_Task_Name__c = 'Price Increases for Pre-Qualified Customer',
            Comments__c = 'Price Increases for ' + cs.Customer_Core_Price_Changes__r.name + ' - please see "Price Change Link" on WRF for SKU details and work via the "Customer Price Changes" tab interface in SFDC',
            Due_Date__c = myDate.addDays(10),
            Priority__c = 'Normal',
            Status__c = 'Not Started');
            if(cs.ACCT_Market_Sector__c == 'Public'){
                wrf.Disposition_Code__c = 'Public/GPO';
                wrf.Assignment_Group__c = 'Public/GPO';
                //wrf.Assigned_To__c = label.Stephen_Burger;
            }else{
                wrf.Disposition_Code__c = 'Remediation';
                wrf.Assignment_Group__c = 'Lifecycle/Remediation';
                //wrf.Assigned_To__c = label.Rich_Mumford;
            }
            taskRemediationList.add(wrf);
        }
        System.debug('===taskRemediationList==='+taskRemediationList);
        if( taskRemediationList.size() > 0){
            return taskRemediationList;
        }
        return null;
    }

    public List<WRF_Task__c> taskBSDPricing(List<case> cases)
    {

        for(Case cs : Cases){
            // Creating WRF Task for Rebates
            WRF_Task__c wrf = new WRF_Task__c(WRF__c = cs.id,
            WRF_Task_Name__c = 'Price Increases for Hosted Catalog',
            Comments__c = 'Price Increases for ' + cs.Customer_Core_Price_Changes__r.name + ' - please see "Price Change Link" on WRF for SKU details',
            Disposition_Code__c = 'BSD Pricing',
            Assignment_Group__c = 'BSD Pricing',
            Due_Date__c = myDate.addDays(10),
            Priority__c = 'Normal',
           // Assigned_To__c = label.John_Clark,
            Status__c = 'Not Started');
            taskBSDPricingList.add(wrf);
        }
        if( taskBSDPricingList.size() > 0){
            return taskBSDPricingList;
        }
        return null ;
    }





    // END //

}