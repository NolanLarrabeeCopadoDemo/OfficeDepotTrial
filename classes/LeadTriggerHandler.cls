/* CreatedBy: Adam Albright
* Date: 15- Feb-2019
* ModifiedBy: Shravya channamadhavuni and Joseph Tocco
* LastModifedDate: 22-April-2019
* Description: This class calls the trigger functionalit for lead object.
* Classes called: ODCommonUtilityMethods,leadAllHelperMeths and LeadReferralSourceHandler
*
* */
public class LeadTriggerHandler extends TriggerHandler {
    private List<Lead> newLeadList;
    private Map<Id, Lead> oldLeadMap;
    private Map<Id, Lead> newLeadMap;
    Map<Id, String> mapOfRecordTypes = new Map<Id, String>();
    @TestVisible static Boolean bypassTrigger = True;
    
    public LeadTriggerHandler() {
        this.newLeadList = (List<Lead>) Trigger.New;
        this.oldLeadMap = (Map<Id, Lead>) Trigger.OldMap;
        this.newLeadMap = (Map<Id, Lead>) Trigger.NewMap;
        mapOfRecordTypes = ODCommonUtilityMethods.getRecordTypeIdToName('Lead');
    }
    public override void beforeInsert(){
        List<Lead> leadCanadaRecsToBUptd = new List<Lead>();
        List<Lead> leadUSRecsToBUptd = new List<Lead>();
        
        List<String> zipCodes = new List<String> ();
        List<Lead> leadRecsToBInvkd = new List<Lead>();
        Set<String> nameSet = new Set<String>();
        Set<String> fNameSet = new Set<String>();
        Set<String> lNameSet = new Set<String>();
        Set<String> companySet = new Set<String>();
        Set<String> emailSet = new Set<String>();
        Set<String> phoneSet = new Set<String>();
        Set<String> zipSet = new Set<String>();
        Set<String> stateSet = new Set<String>();
        for (Lead myLead: newLeadList) {
            if(Test.isRunningTest())
                System.debug('Record Type is:'+mapOfRecordTypes.get(myLead.RecordTypeId));
            // TODO: Find a better way to do this stuff.....
            //For all Leads(All Record Types) , when Zip is not null , time zone has to be populated(Before Inserting Record) , when not null(add)
            if (myLead.Zip__c != null) {
                zipCodes.add(myLead.Zip__c);
                leadRecsToBInvkd.add(myLead);
            }
            
            switch on mapOfRecordTypes.get(myLead.RecordTypeId) {
                when 'Lead_Canada' {
                    //For Leads(Canada) , Amount should be populated with Amount CAD
                    if (myLead.isConverted == false) {
                        leadCanadaRecsToBUptd.add(myLead);
                    }
                }
                when 'Lead_US' {
                    leadUSRecsToBUptd.add(myLead);
                }
            }
        }
        if (leadCanadaRecsToBUptd.size() > 0) {
            leadAllHelperMeths.funcGT(leadCanadaRecsToBUptd);
            leadAllHelperMeths.funcLegacyDuplicateCheck(leadCanadaRecsToBUptd);
        }
        if (leadRecsToBInvkd.size() > 0 && zipCodes.size() > 0) {
            leadAllHelperMeths.funcTimeZone(leadRecsToBInvkd, zipCodes);
        }
        if (leadUSRecsToBUptd.size() > 0) {
            leadAllHelperMeths.funcLegacyDuplicateCheck(leadUSRecsToBUptd);
        }
		
		//Start: Added by Rajendra Shahane for NAIT-142492 02994463 - ISO: Create Lead Process in Lightning
		//Below method updates Sales_Person_ID__c and Owner on current lead based on Sales_Rep_Name__c
		leadAllHelperMeths.updateSalesrepAndOwner(null, newLeadList);
		//End: Added by Rajendra Shahane for NAIT-142492 02994463 - ISO: Create Lead Process in Lightning
    }
    public override void beforeUpdate(){
        List<String> zipCodes = new List<String> ();
        List<Lead> leadRecsToBInvkd = new List<Lead>();
        List<Lead> leadRecsToBInvkdRT = new List<Lead>();
        List<Lead> leadCanadaRecsToBUptd = new List<Lead>();
        List<Id> leadIds = new List<Id>();
        for (Lead myLead: newLeadList) {
            //For all Leads(All Record Types) , when Zip is not null , time zone has to be populated(Before Updating Record)
            if (oldLeadMap != null &&
                oldLeadMap.get(myLead.Id).Zip__c != myLead.Zip__c ) {
                    zipCodes.add(myLead.Zip__c);
                    leadRecsToBInvkd.add(myLead);
                }
            //For Lead(All Record Types) - calculating the lead age
            leadRecsToBInvkdRT.add(myLead);
            switch on mapOfRecordTypes.get(myLead.RecordTypeId) {
                when 'Lead_Canada' {
                    //For Leads(Canada) , Amount should be populated with Amount CAD before changing the reocrd
                    if (oldLeadMap != null &&
                        oldLeadMap.get(myLead.Id).Amount_CAD__c !=
                        myLead.Amount_CAD__c ) {
                            if (myLead.isConverted == false) {
                                leadCanadaRecsToBUptd.add(myLead);
                            }
                        }
                }
            }
        }
		
        if (leadRecsToBInvkd.size() > 0 && zipCodes.size() > 0) {
            leadAllHelperMeths.funcTimeZone(leadRecsToBInvkd, zipCodes);
        }
        if (leadCanadaRecsToBUptd.size() > 0) {
            leadAllHelperMeths.funcGT(leadCanadaRecsToBUptd);
        }
        if (leadRecsToBInvkdRT.size() > 0) {
            leadAllHelperMeths.funcResponseTime(leadRecsToBInvkdRT);
        }
		
		//Start: Added by Rajendra Shahane for NAIT-142492 02994463 - ISO: Create Lead Process in Lightning
		//Below method updates Sales_Person_ID__c and Owner on current lead based on Sales_Rep_Name__c
		leadAllHelperMeths.updateSalesrepAndOwner(oldLeadMap, newLeadList);
		//End: Added by Rajendra Shahane for NAIT-142492 02994463 - ISO: Create Lead Process in Lightning
    }
    public override void afterInsert () {
        if (bypassTrigger) {
            List<Lead> leadBizBoxRecsToBUptd = new List<Lead>();
            List<Lead> leadUsRecsToBUptd = new List<Lead>();
            for (Lead myLead: newLeadList) {
                switch on mapOfRecordTypes.get(myLead.RecordTypeId) {
                    when 'Lead_US' {
                        leadUsRecsToBUptd.add(myLead);
                    }
                }
            }
            if (leadUsRecsToBUptd.size() > 0) {
                leadAllHelperMeths.funcLeadAssgnmnt(leadUsRecsToBUptd);
                //leadAllHelperMeths.funcDuplicateCheck(leadUsRecsToBUptd); // 6/13/19: Commented out until account search is working properly.
            }
        }
    }
    public override void afterUpdate(){
        if (bypassTrigger) {
            List<Lead> leadUsRecsToBUptd = new List<Lead>();
            List<Lead> leadRecsToBUptd = new List<Lead>();
            System.debug('--> record type is:'+mapOfRecordTypes);
            for (Lead myLead:newLeadList) {
                switch on mapOfRecordTypes.get(myLead.RecordTypeId) {
                    when 'Lead_US' {
                        leadUsRecsToBUptd.add(myLead);
                    }
                }
            }
            if (leadUsRecsToBUptd.size() > 0) {
                leadAllHelperMeths.funcLeadAssgnmnt(leadUsRecsToBUptd);
            }
            if (oldLeadMap.size() > 0 && newLeadMap.size() > 0) {
                LeadReferralSourceHandler handler =
                    new LeadReferralSourceHandler();
                handler.processLeads(oldLeadMap, newLeadMap);
            }
        }
    }
}