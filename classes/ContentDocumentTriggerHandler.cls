public class ContentDocumentTriggerHandler extends TriggerHandler {
    private List<ContentDocument> cntntVrsnList;
    public ContentDocumentTriggerHandler() {
        this.cntntVrsnList = (List<ContentDocument>)Trigger.New;
    }
     public override void afterInsert(){
         Database.executeBatch(new ContentDistributionGeneratorBatch());
     }
}