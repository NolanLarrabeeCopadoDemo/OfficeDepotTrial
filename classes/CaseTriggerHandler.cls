public without sharing class CaseTriggerHandler extends TriggerHandler {
    private List<Case> new_case_list;
    private List<Case> old_case_list;
    private Map<Id, Case> old_case_map;
    private Map<Id, Case> new_case_map;
    
    public CaseTriggerHandler() {
        this.new_case_list = (List<Case>) Trigger.new;
        this.old_case_list = (List<Case>) Trigger.old;
        this.old_case_map = (Map<Id, Case>) Trigger.oldMap;
        this.new_case_map = (Map<Id, Case>) Trigger.newMap;
    }
    
    public override void beforeInsert(){
        List<Case> caselsttobeSent = new List<Case> ();
        for(Case c:new_case_list ) {
            if(c.recordtypeid != label.AccountMaintenanceRecordType) {
                system.debug('The recordtype inside is:'+c.recordtypeid+'the record type id'+label.AccountMaintenanceRecordType);
                caselsttobeSent.add(c); 
            }
        }
        if(caselsttobeSent.size() > 0) {
            system.debug('the trigger did not fire for account maintenance'+caselsttobeSent);
            SingleTicketingCaseManagement.update_remote_destination(caselsttobeSent);  
        }
    }
  
    public override void afterInsert(){
        Map<Id,Case> caseMapsTobSent =  new Map<Id,Case> ();
        for(Case c: new_case_list) {
        if(c.recordtypeid != label.AccountMaintenanceRecordType)// need to remove this prasad
            caseMapsTobSent.put(c.id,c);  
        }
        if(caseMapsTobSent.size() > 0) {
            SingleTicketingCaseManagement.createOutboundCaseMessages(new_case_map, 'CREATED');  
        }
        
    }
  
    public override void beforeUpdate(){
        List<Case> caselsttobeSent = new List<Case> ();
        for(Case c:new_case_list ) {
            if(c.recordtypeid != label.AccountMaintenanceRecordType) {
                system.debug('The recordtype inside is:'+c.recordtypeid+'the record type id'+label.AccountMaintenanceRecordType);
                caselsttobeSent.add(c); 
            }
        }
        if(caselsttobeSent.size() > 0) {
            system.debug('the trigger did not fire for account maintenance'+caselsttobeSent);
            SingleTicketingCaseManagement.update_remote_destination(caselsttobeSent);  
        }
    }
   
    public override void afterUpdate(){
        Map<Id,Case> casesTobSent =  new Map<Id,Case> ();
        for(Case c: new_case_list) {
        if(c.recordtypeid != label.AccountMaintenanceRecordType)// need to remove this prasad
            casesTobSent.put(c.id,c);  
        }
        if(casesTobSent.size() > 0) {
            SingleTicketingCaseManagement.updateOutboundCaseMessages(casesTobSent, old_case_map);
        }
    }
}