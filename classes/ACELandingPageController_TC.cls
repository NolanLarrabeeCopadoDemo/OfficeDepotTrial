@isTest
private class ACELandingPageController_TC 
{
    	@testSetup static void setUpData(){
            
            ACE_Settings__c ASE;
            Account acc;
            Account acc2;
            group gp;
            groupmember gpmbr;
            
            User thisUser = [ select Id from User where Id = :UserInfo.getUserId() ];
            System.runAs ( thisUser ) {
                             	
            ASE = new ACE_Settings__c();
     		ASE.trigger_by_pass__c='qwerty';
     		insert ASE;
     
     		Ace_Batches__c AB = new Ace_Batches__c();
     		AB.Name = 'test';
     		AB.Batch__c = 'Q2-2017';
     		insert AB;
            
            gp = new group(name = 'Remediation Team');
            insert gp;
            
            gpmbr = new groupmember(groupid = gp.id,UserOrGroupId = userinfo.getUserId());
            //gpmbr.groupid = gp.id;
            //gpmbr.UserOrGroupId = userinfo.getUserId(); 
            insert gpmbr;                      
     
     		acc = new Account (name = 'SUN Test Account',AOPS_Seq_ID__c = '123456',AOPS_Cust_Id__c = '123456',Oracle_Party_Id__c = '123456',Billingcountry = 'USA',BillingState = 'UT',BillingStreet = '1040 N 326 W',billingcity = 'Orem');
     		insert acc;
                
            acc2 = new Account (name = 'SUN Test Account2',AOPS_Seq_ID__c = '1234567',AOPS_Cust_Id__c = '1234567',Oracle_Party_Id__c = '1234567',Billingcountry = 'USA',BillingState = 'UT',BillingStreet = '1040 N 326 W',billingcity = 'Orem');
     		insert acc2;
            
     		ACE_Customer_Price_Changes__c ace1 = new ACE_Customer_Price_Changes__c(name='Q2-2017',SRM_Differential__c=5,Item_12_Month_Qty__c = 50,Current_Sell_Price__c=2,Total_Spend_Impact_12_Month__c=5,Customer__c = acc.id, Owning_Customer_ID__c ='123456', SFDC_Notification_Flag__c = '3');
     		insert ace1;
                
            ACE_Customer_Price_Changes__c ace2 = new ACE_Customer_Price_Changes__c(name='Q2-2017',SRM_Differential__c=null,Item_12_Month_Qty__c = null,Current_Sell_Price__c=null,Total_Spend_Impact_12_Month__c=null,Customer__c = acc.id, Owning_Customer_ID__c ='1234567', SFDC_Notification_Flag__c = '2');
     		insert ace2;
                
            }
      
        }    
   
    	static testMethod void ACELandingPageController_testmethod() 
 		{
       		system.debug('Query----'+[select name,Owning_Customer_ID__c,SFDC_Notification_Flag__c FROM ACE_Customer_Price_Changes__c where Name ='Q2-2017' and Customer__r.OwnerId = :Userinfo.getUserId() and sfdc_notification_flag__c <> null]);
       		system.debug('madhavi:userid:'+Userinfo.getUserId());
       		Test.startTest();
       		ACELandingPageController ALPC =new ACELandingPageController(); 
       		Test.stopTest();
    	} 
    
    	static testMethod void ACELandingPageController_testmethod2() 
 		{
       		system.debug('Query2----'+[select name,Owning_Customer_ID__c,SFDC_Notification_Flag__c FROM ACE_Customer_Price_Changes__c where Name ='Q2-2017' and Customer__r.OwnerId = :Userinfo.getUserId() and sfdc_notification_flag__c <> null]);
       		system.debug('madhavi:userid:'+Userinfo.getUserId());
       		Test.startTest();
       		ACELandingPageController ALPC =new ACELandingPageController(); 
            ALPC.ListSize = 5;
       		Test.stopTest();
    	}        
    
}
/*private class ACELandingPageController_TC 
{
 static testMethod void ACELandingPageController_testmethod() 
 {
     ACE_Settings__c ASE = new ACE_Settings__c();
     ASE.trigger_by_pass__c='qwerty';
     insert ASE;
     
     Ace_Batches__c AB = new Ace_Batches__c();
     AB.Name = 'test';
     AB.Batch__c = 'Q4-2014';
     insert AB;
     
     Account acc = new Account (name = 'SUN Test Account',AOPS_Seq_ID__c = '123456',AOPS_Cust_Id__c = '123456',Oracle_Party_Id__c = '123456',Billingcountry = 'USA',BillingState = 'UT',BillingStreet = '1040 N 326 W',billingcity = 'Orem');
     insert acc;
     ACE_Customer_Price_Changes__c ace1 = new ACE_Customer_Price_Changes__c(name='test',SRM_Differential__c=5,Item_12_Month_Qty__c = 50,Total_Spend_Impact_12_Month__c=5,Customer__c = acc.id, Owning_Customer_ID__c ='123456', SFDC_Notification_Flag__c = '3');
     insert ace1;
     ACELandingPageController ALPC =new ACELandingPageController(); 
 }
 }*/