@Istest
private class ContactAssignments_Batch_TC
{
        static testMethod void ContactAssignments_Batch_TC()
        {
        
        
            List<Account> List_Acc = new List<Account>();
            List<Contact> List_Con = new List<Contact>();
            
            Account A2 = new Account();
            A2.Name='Test';
            A2.AOPS_Cust_Id__c ='123';
            // Added by Mohit for Story S-350564 //
            A2.OMX_Primary_Key__c='2719';
            A2.AOPS_Seq_ID__c ='123';
            List_Acc.add(a2);

            Contact c1 = new Contact();
            c1.LastName='LastNametest';
            c1.email='testemail@test.com';
            c1.AccountId = a2.id;
            c1.OMX_Primary_Key__c='1234';
            List_Con.add(c1);
            /*
            List<Contact_Assignment__c> List_contactAss = new List<Contact_Assignment__c>();


            Contact_Assignment__c ca1 = new Contact_Assignment__c();
            ca1.Contact_First_name__c ='Test1';
            ca1.Contact_Last_Name__c ='Testcontact';
            ca1.Email__c ='testmail@officedepot.com';
            ca1.CustomerID__c ='123';
            ca1.Site_ID__c='321';
            ca1.Contact_SFDC_ID__c='';
            ca1.OMX_Contact_Primary_Key__c='1234';
            ca1.OMX_Site_PrimaryKey__c='2719';
            ca1.OMX_Header_PrimaryKey__c='2719';
            ca1.Status__c='open';
            ca1.Legacy_CreatedDate__c=system.now();
            ca1.Legacy_LastModifiedDate__c=system.now();
            ca1.Role__c='Support';
            ca1.pin__c='650703';
            ca1.Legacy_Createdby__c='';

            //insert ca1;
            List_contactAss.add(ca1);

            Contact_Assignment__c ca2 = new Contact_Assignment__c();
            ca2.Contact_First_name__c ='Test2';
            ca2.Contact_Last_Name__c ='bbbbb';
            ca2.CustomerID__c ='123';
            ca2.Site_ID__c='321';
            ca1.OMX_Contact_Primary_Key__c='1234';
            ca1.OMX_Header_PrimaryKey__c='2719';
            ca2.OMX_Site_PrimaryKey__c='271995';
            //insert ca2;
            List_contactAss.add(ca2);

            Contact_Assignment__c ca3 = new Contact_Assignment__c();
            ca3.Contact_First_name__c ='Test3';
            ca3.Contact_Last_Name__c ='cccccc';
            ca3.CustomerID__c ='123';
            ca3.Site_ID__c='321';
            //insert ca3;
            List_contactAss.add(ca3);

            Contact_Assignment__c ca4 = new Contact_Assignment__c();
            ca4.Contact_First_name__c ='Test4';
            ca4.Contact_Last_Name__c ='dddddd';
            ca4.CustomerID__c ='123';
            ca4.Site_ID__c='321';
            //insert ca4;
            List_contactAss.add(ca4);


            Contact_Assignment__c ca5 = new Contact_Assignment__c();
            ca5.Contact_First_name__c ='Test4';
            ca5.Contact_Last_Name__c ='dddddd';
            ca5.CustomerID__c ='123';
            ca5.Site_ID__c='321';
            //insert ca5;
            List_contactAss.add(ca5);
            insert List_Acc;
            insert List_contactAss;
            insert List_Con;
            */
            insert List_Acc;
            insert List_Con;

            test.starttest();
            
            
            ContactAssignments_Batch cab = new ContactAssignments_Batch();
            /*String qry='Select Id,Error__c,CustomerID__c,Site_ID__c,Contact_First_name__c,Contact_Last_Name__c,Contact_SFDC_ID__c,Sequence_ID__c,Legacy_Createdby__c,Legacy_CreatedDate__c,Legacy_LastModifiedby__c,Legacy_LastModifiedDate__c,OMX_Header_PrimaryKey__c,OMX_Site_PrimaryKey__c,OMX_Contact_Primary_Key__c,' 
                +' Pin__c,Role__c,Status__c,MailingStreet__c,MailingCity__c,MailingState__c,MailingPostalCode__c,MailingCountry__c,Phone__c,Fax__c,Email__c,Title__c,Department__c from Contact_Assignment__c where Contact_SFDC_ID__c = null and Contact_Last_Name__c!= null';

            ContactAssignments_Batch cab1 = new ContactAssignments_Batch(qry);
            database.executebatch(cab1);*/
            
            String qry='Select Id from Contact Limit 10';
            ContactAssignments_Batch cab1 = new ContactAssignments_Batch(qry);
            database.executebatch(cab1);
            test.stoptest();
           ///// String CRON_EXP = '0 0 0 3 9 ? 2022';    
           ///// System.schedule('Assignment Batch',CRON_EXP , cab1 );
        }
}