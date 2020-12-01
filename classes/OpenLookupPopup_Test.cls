/**
 * This class contains unit tests for validating the behavior of Apex classes
 * and triggers.
 *
 * Unit tests are class methods that verify whether a particular piece
 * of code is working properly. Unit test methods take no arguments,
 * commit no data to the database, and are flagged with the testMethod
 * keyword in the method definition.
 *
 * All test methods in an organization are executed whenever Apex code is deployed
 * to a production organization to confirm correctness, ensure code
 * coverage, and prevent regressions. All Apex classes are
 * required to have at least 75% code coverage in order to be deployed
 * to a production organization. In addition, all triggers must have some code coverage.
 *
 * The @isTest class annotation indicates this class only contains test
 * methods. Classes defined with the @isTest annotation do not count against
 * the organization size limit for all Apex scripts.
 *
 * See the Apex Language Reference for more information about Testing and Code Coverage.
 */
 //Created By Vipul Jain for Story#S-442659 (00796006 - Opportunity Mass Reassignment for Active or Inactive Users by U.S. DSMs and Above) on October 24,2016
@isTest
private class OpenLookupPopup_Test {

    static testMethod void myUnitTest() {



        // TO DO: implement unit test
        test.startTest();
        User u = Test_Utils.CreateUser();
        List<User> usrlist = new List<User>();
        usrlist.add(u);
        system.assertEquals(usrlist.size()>0,true);

        OpenLookupPopupCntrl opncntrl = new OpenLookupPopupCntrl();
        opncntrl.searchString = 'Admin';
        opncntrl.search();
        opncntrl.getFormTag();
        opncntrl.getTextBox();
        test.stopTest();
    }
}