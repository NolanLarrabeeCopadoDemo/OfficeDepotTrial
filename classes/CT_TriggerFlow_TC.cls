@isTest
private class CT_TriggerFlow_TC
{
  static testMethod void TestMethod1()
  {
        //List<Account> accounts = new List<Account>();
        Test.startTest();
            Account acc = new Account();
            acc.name = 'SUN Test Account';
            acc.BillingStreet = '1040 N 326 W';
            acc.billingcity = 'Orem';
            acc.BillingState = 'UT';
            acc.Billingcountry = 'USA';
            acc.OMX_Primary_Key__c = '123457';
            acc.Oracle_Party_Id__c = '123457';
            acc.AOPS_Cust_Id__c = '123457';
            acc.status__c='Active';
            acc.Split_Record__c = true;
            acc.Segment__c='Federal';
            insert acc;
            
            Customer_Transition__c wtCT1 = new Customer_Transition__c(name='test',account__c = acc.id,Status__c='On Deck',Billing_Frequency_Excptn__c = true,AOPS_Flag__c='Y',OMX_Primary_Key__c='123457',Transition_Status__c='Active',Written_Agreement__c =true);
            insert wtCT1;
            
            Customer_Transition__c CT2 = new Customer_Transition__c(name='test1',account__c = acc.id,Status__c='On Deck',Billing_Frequency_Excptn__c = true,AOPS_Flag__c='Y',OMX_Primary_Key__c='123446',Transition_Status__c='Active',Written_Agreement__c=true, Parent_Transition_ID__c=wtCT1.id);
            insert CT2;
            
            Customer_Transition__c CT3 = new Customer_Transition__c(name='test1',account__c = acc.id,Status__c='Rescheduled',Billing_Frequency_Excptn__c = true,AOPS_Flag__c='Y',OMX_Primary_Key__c='123460',Transition_Status__c='Active',Written_Agreement__c=true);
            insert CT3;
            
            //START S-420887 (OD 00716325) [Hemant 6/30/2016]
            CT3.DNS_Status_Confirmed__c = true;
            CT3.DNS_Confirmation__c = true;
            update CT3;
				    Customer_Transition__c ctrec2 = [SELECT Name, Disposition_Comments__c,Customer_Disposition__c,ID, status__c, DNS_Sent_Date__c, DNS_Status_Confirmed_Date__c FROM Customer_Transition__c where id =: CT3.id];
				    System.assertEquals(ctrec2.DNS_Sent_Date__c, Date.today());
				    System.assertEquals(ctrec2.DNS_Status_Confirmed_Date__c, Date.today());
				    //END S-420887 (OD 00716325) [Hemant 6/30/2016]
            
            //Added by Najma Ateeq for Story #S-386202(OD Case Number - 00617674)
            List<Customer_Transition__c > lst = new List<Customer_Transition__c>();
            lst.add(wtCT1);
            lst.add(CT2);
            lst.add(CT3);
            CT_TriggerFlow cttf = new CT_TriggerFlow();
            cttf.CT_TriggerFlow(lst);
             //Added by Najma Ateeq for Story #S-386202(OD Case Number - 00617674)
             
          Test.stopTest();
  }
  
}