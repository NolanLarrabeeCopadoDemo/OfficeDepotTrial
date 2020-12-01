@isTest
public class GPO_Update_Guid_Batch_TC {
    @isTest(SeeAllData=true) 
    public static void GPO_Update_Guid_Batch_TM() {
        Database.BatchableContext bc = (Database.BatchableContext) null;
        SObject[] scope = (SObject[]) null;
        SchedulableContext sc = (SchedulableContext) null;
            
        GPO_Update_Guid_Batch gpo = new GPO_Update_Guid_Batch();
    	gpo.start(bc);
        gpo.execute(bc, scope);
        gpo.finish(bc);
        gpo.execute(sc);
	}
}