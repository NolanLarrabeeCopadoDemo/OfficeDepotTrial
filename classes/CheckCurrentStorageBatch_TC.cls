@isTest(SeeAllData=true)
public class CheckCurrentStorageBatch_TC {

    public static testmethod void testAccountCallout() {
        // Set mock callout class
        Test.setMock(HttpCalloutMock.class, new SingleRequestMock());
        String strQuery = '';
        SchedulableContext sc = null;
        CheckCurrentStorageBatch cbs = new CheckCurrentStorageBatch(strQuery);
        CheckCurrentStorageBatch cbs2 = new CheckCurrentStorageBatch();
		cbs.execute(sc);
    }
}