@isTest
public class DealRegistrationControllerTest {

    @isTest
    public static void testLeadDealSave() {
        Lead lead =  new Lead(Company = 'Lead Company', FirstName = 'firstname', LastName = 'lastname', Email = 'some@gmail.com');
        DealRegistrationController.saveLeadDeal(lead);
        DealRegistrationController.getPicklistValues(lead, 'State__c');
    }
}