public without sharing class PotentialBandTriggerHandler extends TriggerHandler{

    private List<Potential_Band__c> new_potential_band_list;
    private List<Potential_Band__c> old_potential_band_list;
    private Map<Id, Potential_Band__c> old_potential_band_map;
    private Map<Id, Potential_Band__c> new_potential_band_map;

    public PotentialBandTriggerHandler() {
        this.new_potential_band_list = (List<Potential_Band__c>) Trigger.new;
        this.old_potential_band_list = (List<Potential_Band__c>) Trigger.old;
        this.old_potential_band_map = (Map<Id, Potential_Band__c>) Trigger.oldMap;
        this.new_potential_band_map = (Map<Id, Potential_Band__c>) Trigger.newMap;
    }

    // Make Banding Key Lowercase No Space, No Non-AlphaNumeric

    public override void beforeInsert(){
        PotentialBandManagment.getBandingKeys(this.new_potential_band_list);
        PotentialBandManagment.setSegment(this.new_potential_band_list);
    }

    public override void beforeUpdate(){
        PotentialBandManagment.getBandingKeys(this.new_potential_band_list);
        PotentialBandManagment.setSegment(this.new_potential_band_list);
    }
}