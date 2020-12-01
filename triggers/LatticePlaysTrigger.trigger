trigger LatticePlaysTrigger on Lattice_Play__c (before insert, after insert) {

    if(Trigger.isBefore && Trigger.isInsert){
        System.debug('Lattice Play beforeInsert call');
        LatticePlaysTriggers.beforeInsert(Trigger.New);
    } 
}