/**
 * Created by Najma Ateeq for Story #S-386202(OD Case Number - 00617674) 
 */
@isTest
private class ResourceDirectoryController_TC {

    static testMethod void myUnitTest() {
    	createTestData();
        ResourceDirectoryController.getDir('123');
        ResourceDirectoryController.getDirEC('123','Account Maintenance');
        ResourceDirectoryController.getCat();
    }
    static void createTestData(){
    	Resource_Directory__c rd = new Resource_Directory__c();
        //rd.Name = 'test';
        rd.Entity_code__c = '123';
        rd.Category__c = 'Account Maintenance';
        insert rd;
        
        RD_CS__c rdcs = new RD_CS__c();
        rdcs.Name =  'test';
        insert rdcs;
    }
}