public with sharing class OrgTriggerHandler extends TriggerHandler{
    private List<Org__c> new_org_list;
    private List<Org__c> old_org_list;
    private Map<Id, Org__c> old_org_map;
    private Map<Id, Org__c> new_org_map;


    public OrgTriggerHandler() {
        this.new_org_list = (List<Org__c>) Trigger.new;
        this.old_org_list = (List<Org__c>) Trigger.old;
        this.old_org_map = (Map<Id, Org__c>) Trigger.oldMap;
        this.new_org_map = (Map<Id, Org__c>) Trigger.newMap;
    }

    public override void beforeInsert(){
        OrgManagement.mapLowLevelToHighLevelIndustryTrigg(this.new_org_list);
        OrgManagement.getPotentialBandsTrigg(this.new_org_list);
        
    }

    public override void beforeUpdate(){
        OrgManagement.mapLowLevelToHighLevelIndustryTrigg(this.new_org_list);
        OrgManagement.getPotentialBandsTrigg(this.new_org_list);
        
    }
}