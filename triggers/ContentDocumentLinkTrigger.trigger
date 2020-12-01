trigger ContentDocumentLinkTrigger on ContentDocumentLink (after insert, before insert) {
    if(Trigger.isInsert && Trigger.isAfter){
        ContentDocumentLinkTrigerHandler.afterInsert(Trigger.new);
    }
    if (Trigger.isBefore && Trigger.isInsert) {
        ContentDocumentLinkTrigerHandler.beforeInsert(Trigger.new);
    }
}