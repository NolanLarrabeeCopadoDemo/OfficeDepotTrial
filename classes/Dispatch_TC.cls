@IsTest
public without sharing class Dispatch_TC {

    class DispatchMock implements HttpCalloutMock {
        Integer req_status = 201;
        public DispatchMock(){}
        public DispatchMock(Integer req_status){
            this.req_status = req_status;
        }

        public HTTPResponse respond(HTTPRequest request) {
            HttpResponse response = new HttpResponse();
            response.setStatusCode(this.req_status);
            return response;
        }
    }

    @TestSetup
    static void makeData(){
        insert new Dispatch__c(
            Status__c = 'NEW'
        );
    }

    @IsTest
    static void run_dispatch_validation(){
        Test.startTest();
        try {
            new Dispatch().validate();
        } catch (QueryException e) {
            insert new Dispatch_Setting__c(
                Name='Dispatch',
                Dispatch_Query__c = 'SELECT Id, CreatedDate FROM Dispatch__c WHERE Execution_Mode__c = \'SERIAL\' AND ',
                Remote_URL__c = 'https://localhost',
                Headers__c = '{"Content-Type": "application/json"}',
                Order_By_Field_API_Name__c = 'CreatedDate',
                Order_Direction__c='DESC',
                Status_Field_API_Name__c='Status__c',
                Chain__c=false
            );
            new Dispatch().validate();
        }
        Test.stopTest();
    }

    @IsTest
    static void test_success_response(){

        insert new Dispatch_Setting__c(
            Name='Dispatch',
            Dispatch_Query__c = 'SELECT Id, CreatedDate FROM Dispatch__c WHERE Execution_Mode__c = \'SERIAL\' AND ',
            Remote_URL__c = 'https://localhost',
            Headers__c = '{"Content-Type": "application/json"}',
            Order_By_Field_API_Name__c = 'CreatedDate',
            Order_Direction__c='DESC',
            Status_Field_API_Name__c='Status__c',
            Chain__c=false
        );

        Test.setMock(HttpCalloutMock.class, new DispatchMock());

        Test.startTest();
        System.enqueueJob(new Dispatch());
        Test.stopTest();
        Dispatch__c result = [SELECT Id, Status__c FROM Dispatch__c LIMIT 1];
        System.assert(result.Status__c == 'PROCESSED');
    }

    @IsTest
    static void test_failed_response(){

        insert new Dispatch_Setting__c(
            Name='Dispatch',
            Dispatch_Query__c = 'SELECT Id, CreatedDate FROM Dispatch__c WHERE Execution_Mode__c = \'SERIAL\' AND ',
            Remote_URL__c = 'https://localhost',
            Headers__c = '{"Content-Type": "application/xml"}',
            Order_By_Field_API_Name__c = 'CreatedDate',
            Order_Direction__c='DESC',
            Status_Field_API_Name__c='Status__c',
            Chain__c=false
        );

        Test.setMock(HttpCalloutMock.class, new DispatchMock(400));

        Test.startTest();
        System.enqueueJob(new Dispatch());
        Test.stopTest();
        Dispatch__c result = [SELECT Id, Status__c FROM Dispatch__c LIMIT 1];
        System.assert(result.Status__c == 'FAILED');
    }
}