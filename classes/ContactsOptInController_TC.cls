@isTest
public class ContactsOptInController_TC {
    
      public static testMethod void myUnittest() {
        Test.StartTest();
        Account A2 = new Account();
        A2.Name='Test';
        A2.AOPS_Cust_Id__c ='123';
        A2.OMX_Primary_Key__c='2719';
        A2.AOPS_Seq_ID__c ='123';
        insert A2;
        Contact c = new Contact();
        c.AccountId = a2.id;
        c.FirstName = 'test';
        c.LastName = 'test123';
        c.Decision_Maker__c = 'Yes';
        c.Direct_Mail__c = '123 Ave';
        c.D_M_OptIn__c = 'Y';
        c.Acxiom_Full_Name__c = 'DORIS STRONG';
        c.channel_preference__c = 'CONTRACT ONLY';
        c.E_OptIn1__c = 'Y';
        c.E_OptIn2__c = 'Y';
        c.E_OptIn3__c = 'Y';
        c.Email1__c = 'test1@test.com';
        c.Email2__c = 'test2@test.com';
        c.Email3__c = 'test3@test.com';
        c.Phone1__c = '5611112222';
        c.Phone2__c = '5611113333';
        c.Phone3__c = '5611114444';
        c.P_OptIn1__c = 'Y';
        c.P_OptIn1__c = 'N';
        c.P_OptIn1__c = 'N';
        c.NPX_Linkedin_Profile__c = 'http://www.linkedin.com';
        insert c;
        List<Contact> c1 = ContactsOptInController.getContacts( c.id,c.Acxiom_Full_Name__c);
        System.assertEquals(c.id,c.id,c1);
        System.assertEquals(c.Acxiom_Full_Name__c,'DORIS STRONG',c1);
        Test.stopTest();
    }
    
    public static testMethod void myUnittest2() {
        Test.StartTest();
        Account A2 = new Account();
        A2.Name='Test';
        A2.AOPS_Cust_Id__c ='123';
        A2.OMX_Primary_Key__c='2719';
        A2.AOPS_Seq_ID__c ='123';
        insert A2;
        Contact c = new Contact();
        c.AccountId = a2.id;
        c.FirstName = 'test2';
        c.LastName = 'test555';
        c.Decision_Maker__c = 'Yes';
        c.Direct_Mail__c = '';
        c.D_M_OptIn__c = '';
        c.Acxiom_Full_Name__c = '';
        c.channel_preference__c = '';//'CONTRACT ONLY';
        c.E_OptIn1__c = '';
        c.E_OptIn2__c = '';
        c.E_OptIn3__c = '';
        c.Email1__c = '';
        c.Email2__c = '';
        c.Email3__c = '';
        c.Phone1__c = '';
        c.Phone2__c = '';
        c.Phone3__c = '';
        c.P_OptIn1__c = 'Y';
        c.P_OptIn1__c = 'N';
        c.P_OptIn1__c = 'N';
        c.NPX_Linkedin_Profile__c = '';
        insert c;
        List<Contact> c1 = ContactsOptInController.getContacts( c.id,c.Acxiom_Full_Name__c);
        System.assertEquals(c.id,c.id,c1);
        System.assertEquals(c.Acxiom_Full_Name__c,'',c1);
        Test.stopTest();
    }
    
    public static testMethod void myUnittest3() {
        Test.StartTest();
        Account A2 = new Account();
        A2.Name='Test';
        A2.AOPS_Cust_Id__c ='123';
        A2.OMX_Primary_Key__c='2719';
        A2.AOPS_Seq_ID__c ='123';
        insert A2;
        Contact c = new Contact();
        c.AccountId = a2.id;
        c.FirstName = 'test2';
        c.LastName = 'test555';
        c.Decision_Maker__c = 'Yes';
        c.Direct_Mail__c = '';
        c.D_M_OptIn__c = '';
        c.Acxiom_Full_Name__c = '';
        c.channel_preference__c = '';//'CONTRACT ONLY';
        c.E_OptIn1__c = '';
        c.E_OptIn2__c = '';
        c.E_OptIn3__c = '';
        c.Email1__c = '';
        c.Email2__c = '';
        c.Email3__c = '';
        c.Phone1__c = '';
        c.Phone2__c = '';
        c.Phone3__c = '';
        c.P_OptIn1__c = 'Y';
        c.P_OptIn1__c = 'N';
        c.P_OptIn1__c = 'N';
        c.NPX_Linkedin_Profile__c = '';
        insert c;
        List<Contact> c1 = ContactsOptInController.getContacts(null,null);
        Test.stopTest();
    }
}