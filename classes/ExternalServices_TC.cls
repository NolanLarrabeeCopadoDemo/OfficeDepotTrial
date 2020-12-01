@IsTest
public with sharing class ExternalServices_TC {
    
    @isTest
    static void test_request_fails_with_bad_auth() {
        Test.setMock(HttpCalloutMock.class, new ExternalServices_Mock('bad'));
        Test.startTest();
        try {
            ExternalServices.GetAuthorizationToken();
        } catch (AuraHandledException e){
            System.debug('Exception Recieved: ' + e);
        }
        Test.stopTest();
    }

    @isTest
    static void test_request_runs_with_good_auth() {
        Test.setMock(HttpCalloutMock.class, new ExternalServices_Mock('good'));
        Test.startTest();
        ExternalServices.GetAuthorizationToken();
        Test.stopTest();
    }

    @isTest
    static void test_job_request_runs_with_good_auth() {
        Test.setMock(HttpCalloutMock.class, new ExternalServices_Mock('job'));
        Test.startTest();
        String token = ExternalServices.GetAuthorizationToken();
        Map<String, String> result  = ExternalServices.startJob(token, 'rms', 'rms_loader');
        Test.stopTest();
    }

    @isTest
    static void test_future_job_request_runs_with_good_auth() {
        Test.setMock(HttpCalloutMock.class, new ExternalServices_Mock('job'));
        Test.startTest();
        ExternalServices.startExternalJob('rms', 'rms_loader');
        Test.stopTest();
    }

    @IsTest
    static void test_scheduled_job_start(){
        Test.setMock(HttpCalloutMock.class, new ExternalServices_Mock('job'));
        Test.startTest();
        System.schedule('Test Echo Job Run', '0 0 23 * * ?', new ExternalServices());
        Test.stopTest();

    }
}