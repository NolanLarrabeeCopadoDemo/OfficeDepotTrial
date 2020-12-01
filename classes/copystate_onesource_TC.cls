@isTest
private class copystate_onesource_TC 
{
      static testMethod void copystate_onesourceUnitTest()
        {
        test.startTest();
        lead l1 = new Lead ();
        //l1.Name ='Test';
        l1.address1__c='Addr1';
        l1.Address_Validation_Error__c='NO';
        l1.Address_Validated__c = true;
        l1.address2__c='Addr2';
        l1.City__c='NY';
        l1.state_internal__c='UA';
        l1.state__c='KA';
        l1.country__c='USA';
        l1.zip__c='335647';
        l1.Company ='Wipro';
        l1.LastName='Test';
        insert l1;
        
        lead l2 = new Lead();
         
        //l1.Name ='Test';
        l2.address1__c='6600 North Military Trail';
        l2.Address_Validation_Error__c='NO';
        l2.Address_Validated__c = true;
        l2.address2__c='Boca Raton';
        l2.City__c='FL';
        l2.state_internal__c='UB';
        l2.state__c='KA';
        l2.country__c='USA';
        l2.zip__c='33496';
        l2.Company ='XYZ';
        l2.LastName='Comp';
        insert l2;
        test.stopTest();
        }
}