@IsTest
public class AOPSContactFullProcessor_TC {

    @IsTest
    static void runProcessor() {
        Test.startTest();
        AOPSContactFullProcessor processor = new AOPSContactFullProcessor(null);
        System.enqueueJob(processor);
        Test.stopTest();
    }
}