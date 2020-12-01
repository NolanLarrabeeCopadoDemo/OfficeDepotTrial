@isTest
public with sharing class GPOComingSoonController_TC {
     
    @IsTest
    public static void tester1() {
        test.startTest();
        GPOComingSoonController c = new GPOComingSoonController();
        System.currentPageReference().getParameters().put('source','1232');
        c.insertCounter();
        test.stopTest();
    }
}