// 17 July 2015     Ryan Marquardt

@isTest
private class Create_Edit_Lead_extension_TC 
{

    static testMethod void myUnitTest() 
    {
        
        Lead leadObj= new Lead ();
        leadObj.zip__c = '123';
        leadObj.address1__c = 'abc';
        leadObj.City__c = 'Oklahama';
        leadObj.state__c = 'FL';
        leadObj.Country__c = 'USA';
        leadObj.Company = 'ABC P';
        leadObj.LastName= 'LastName';       
        //leadObj.OwnerID = '005E0000000lNbV';// This is the salesforce User ID
        //leadObj.Sales_PersonID__c = 'a0AE0000000GGMn'; //Sales person Id for the Salesforce USer
        insert leadObj;
        system.debug('Before update'+leadObj.City__c);

        PageReference pageRef = ApexPages.currentPage();
        Test.setCurrentPage(pageRef);
        ApexPages.StandardController con = new ApexPages.StandardController(leadObj);
        ApexPages.currentPage().getParameters().Put('id',leadObj.id);
        ApexPages.currentPage().getParameters().Put('save_new','1');
        Create_Edit_Lead_extension controller = new Create_Edit_Lead_extension(con);

        //controller.validateAddress();// test = new Prospect_Edit_Extension.validateAddress();
        //controller.SaveAllData();
        
        leadObj.zip__c = '123';
        leadObj.address1__c = 'abc';
        leadObj.state__c = 'FL';
        leadObj.Country__c = 'IND';
        leadObj.City__c = 'Ohama';
        controller.SaveAllData();
         
        leadObj.zip__c = '123';
        leadObj.address1__c = 'abc';
        leadObj.state__c = 'FL';
        leadObj.Country__c = 'USA';
        leadObj.City__c = 'Ohama';
        //controller.isTestMode = true;
        controller.SaveAllData();
        
           
        update leadObj;
        system.debug('After update'+leadObj.City__c);

        //start Ryan Marquardt - S-335200 - 7/18
        controller.getStatus_custom();
        controller.validateAddress();
        controller.notvalidadd = false;
        controller.isTestMode = false;
        //end Ryan Marquardt - S-335200 - 7/18
        
        
    }
}