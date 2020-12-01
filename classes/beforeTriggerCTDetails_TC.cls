//copyright Appirio @2015
//Created By: Vipul Jain ON 9 Oct 2015 for Story [S - S-355236]
//Description :Test Class of beforeTriggerCTDetails

@isTest
public class  beforeTriggerCTDetails_TC {

	static testMethod void Test1()
    {
    	 Account acc = new Account ();
       	 acc = Test_Utils.CreateAccount('Customer (OfficeMax)');
       	 acc.omx_primary_key__C='OMX0019897';
       	 acc.OMXIsUpdated__c = true;
		 acc.Split_Record__c =false;
		 insert acc;

    	Customer_Transition__c CT = new Customer_Transition__c(Error_Message__c='test',name='test',account__c = acc.id,Error_Code__c = 'Error');
        insert CT;
    	Customer_Transition_Dtls__c ctDetail = new Customer_Transition_Dtls__c();
    	//Schema.SObjectType.Account.getRecordTypeInfosByName().get('Site (OfficeMax)').getRecordTypeId();
    	test.startTest();
    	ctDetail= Test_Utils.createCustomerTransDetails('Sites');
    	ctDetail.Customer_Transition_ID__c = CT.id;
    	ctDetail.Bill_To_Reference__c = 'OMX0019897';
    	insert ctDetail;
    	Customer_Transition_Dtls__c ctDetail1 = [SELECT id,Bill_To_Account__c,Bill_To_Reference__c from Customer_Transition_Dtls__c where id =: ctDetail.id];

    	//system.assertEquals(ctDetail1.Bill_To_Account__c,acc.id );

    	test.stopTest();
		}

}