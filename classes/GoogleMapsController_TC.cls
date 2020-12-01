@Istest
public class GoogleMapsController_TC {

    Public static testmethod void test(){
        GoogleMapsController.getGoogleMapsAPIKey();
        Test.setMock(HttpCalloutMock.class, new GoogleMapsControllertestclass_T());
        GoogleMapsController.getAddressAutoComplete('Appleton Avenue, Menomonee Falls, WI, USA','geocode');
        GoogleMapsController.getAddressPlaceInfo('Appleton Avenue, Menomonee Falls, WI, USA');
    }
    
}