@isTest
public class ODCommonUtilityMethods_TC {
    
 @isTest
    public static void testLeadDealSave() {
        Lead lead =  new Lead(Company = 'Lead Company', FirstName = 'firstname', LastName = 'lastname', Email = 'some@gmail.com');
        DealRegistrationController.saveLeadDeal(lead);
        DealRegistrationController.getPicklistValues(lead, 'State__c');
    }
    
   
    Public static testmethod void test123(){
        ODCommonUtilityMethods.getGoogleMapsAPIKey();
        Test.setMock(HttpCalloutMock.class, new GoogleMapsControllertestclass_T());
        ODCommonUtilityMethods.getAddressAutoComplete('Appleton Avenue, Menomonee Falls, WI, USA','geocode');
       ODCommonUtilityMethods.getAddressPlaceInfo('Appleton Avenue, Menomonee Falls, WI, USA');
    }

}