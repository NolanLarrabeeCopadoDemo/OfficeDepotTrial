@isTest
private class GT_DeleteContacts_TC 
{
      static testMethod void GT_DeleteContactsUnitTest()
        {
        test.startTest();
        List<recordtype> accSetupGTRecId= [select id from recordtype where name ='Account Setup Requested GT'];
        List<recordtype> custGTRecId= [select id from recordtype where name ='Customer (GT)'];
        Account acc1 = new Account();
        //acc1.RecordtypeId = accSetupGTRecId[0].id;
        acc1.RecordtypeId =Label.Account_Setup_Record_Type;
        acc1.AOPS_Seq_ID__c = '658387';
        acc1.OMX_Primary_Key__c='123654';
        acc1.Name='Test Account';
        insert acc1;
        
        System.debug('&&&&&&Label.Account_Setup_Record_Type'+Label.Account_Setup_Record_Type);
        System.debug('&&&&&&insert'+acc1.RecordtypeId );

        Contact c1 = new Contact();
        c1.LastName='LastNametest1';
        c1.email='testemail1@test.com';
        c1.AccountId = acc1.id;
        c1.firstname='first';
        c1.OMX_primary_key__c='1234';
        c1.title = 'Manager';
        c1.Primary_Contact__c = true;
        
        insert c1;
        
        Contact c2 = new Contact();
        c2.LastName='LastNametest2';
        c2.email='testemail2@test.com';
        c2.AccountId = acc1.id;
        c2.firstname='Second';
        c2.OMX_primary_key__c='1235';
        c2.title = 'Rep';
        c2.Primary_Contact__c = false;
        
        insert c2;
        
        acc1.RecordtypeId = Label.Customer_GT_Record_Type;
        //custGTRecId[0].id;
        update acc1;
        System.debug('&&&&&&Label.Customer_GT_Record_Type'+Label.Customer_GT_Record_Type);
        System.debug('&&&&&&update'+acc1.RecordtypeId );


        
        test.stopTest();
        }
}