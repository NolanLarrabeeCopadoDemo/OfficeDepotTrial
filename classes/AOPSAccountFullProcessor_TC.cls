@IsTest
public class AOPSAccountFullProcessor_TC {
    
    @IsTest
    static void runProcessor() {
        Test.startTest();
        AOPSAccountFullProcessor processor = new AOPSAccountFullProcessor(null);
        System.enqueueJob(processor);
        Test.stopTest();
    }
}