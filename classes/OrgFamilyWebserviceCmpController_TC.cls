@isTest
public class OrgFamilyWebserviceCmpController_TC {
    
    Public static testmethod void test(){
        
        Test.setMock(HttpCalloutMock.class, new OrgFamilyWebserviceCmpController_mock_TC());
        
        OrgFamilyWebserviceCmpController.familyTree_WB('[{"Business_Name__c" : "M Gibson Hotels LLC", "Type__c" : "Branch", "LOB__c" : "Hotels and Accommodation", "Website__c" : "http://www.mgibsonhotels.com", "D_B_ID__c" : "104564636",  "City__c" : "Myrtle Beach", "State__c" :"SC"}]');
            }

}