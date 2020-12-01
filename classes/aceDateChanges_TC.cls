@isTest
private class aceDateChanges_TC 
{

 static testMethod void aceDateChanges_method(){
 
 Account acc = new Account (name = 'SUN Test Account',AOPS_Seq_ID__c = '123456',AOPS_Cust_Id__c = '123456',Oracle_Party_Id__c = '123456',Billingcountry = 'USA',BillingState = 'UT',BillingStreet = '1040 N 326 W',billingcity = 'Orem');
 insert acc;
 
 Account acc2 = new Account (name = 'SUN Test Account2',AOPS_Seq_ID__c = '1234562',AOPS_Cust_Id__c = '1234562',Oracle_Party_Id__c = '1234562',Billingcountry = 'USA',BillingState = 'UT',BillingStreet = '1040 N 326 W',billingcity = 'Orem');
 insert acc2;
 
 ACE_Settings__c ASE = new ACE_Settings__c();
 ASE.trigger_by_pass__c='qwerty';
 insert ASE;
 
 List <ACE_Customer_Price_Changes__c> ACPC = new List<ACE_Customer_Price_Changes__c>();

 ACE_Customer_Price_Changes__c ace1 = new ACE_Customer_Price_Changes__c(Sales_Price_Change_Effective_Date_Rep__c=Date.newInstance(1980, 10 ,20),name='test',Customer_Notification_Date_Approved__c=Date.newInstance(2013 , 10 ,20),Customer_Notification_Date__c=Date.newInstance(2013 , 12 ,20),Sales_Price_Change_Effective_Date_Approv__c=Date.newInstance(2013 , 12 ,20),OD_Revenue_Impact__c= 8989,Customer_Notification_Date_Rep__c=Date.newInstance(2012 , 10 ,20),SRM_Differential__c=5,record_unlock_Status__c='open',Item_12_Month_Qty__c = 50,Total_Spend_Impact_12_Month__c=80000,Sales_Price_Change_Effective_Date_Min__c=Date.newInstance(2020 , 12 ,20),Customer__c = acc.id, Owning_Customer_ID__c ='123456', SFDC_Notification_Flag__c = '3');
 ace1.Previous_Exception_Impact__c=10000;
ace1.Previous_Exception_Days__c=100;
 
 
 ACE_Customer_Price_Changes__c ace2 = new ACE_Customer_Price_Changes__c(Sales_Price_Change_Effective_Date_Rep__c=Date.newInstance(2080, 10 ,20),name='test',Customer_Notification_Date_Approved__c=Date.newInstance(2013 , 10 ,20),Customer_Notification_Date__c=Date.newInstance(2013 , 12 ,20),Sales_Price_Change_Effective_Date_Approv__c=Date.newInstance(2013 , 12 ,20),OD_Revenue_Impact__c= 8989,Customer_Notification_Date_Rep__c=Date.newInstance(2012 , 10 ,20),SRM_Differential__c=5,record_unlock_Status__c='open',Item_12_Month_Qty__c = 50,Total_Spend_Impact_12_Month__c=80000,Sales_Price_Change_Effective_Date_Min__c=Date.newInstance(2020 , 12 ,20),Customer__c = acc2.id, Owning_Customer_ID__c ='123456', SFDC_Notification_Flag__c = '3');
 ace2.Sales_Price_Change_Effective_Date__c=Date.newInstance(2013 , 12 ,19);
 ace2.Previous_Exception_Impact__c=10000;
ace2.Previous_Exception_Days__c=100;

 ACE_Customer_Price_Changes__c ace3 = new ACE_Customer_Price_Changes__c(Sales_Price_Change_Effective_Date_Rep__c=Date.newInstance(2080, 10 ,20),name='test',Customer_Notification_Date_Approved__c=Date.newInstance(2013 , 10 ,20),Customer_Notification_Date__c=Date.newInstance(2013 , 12 ,20),Sales_Price_Change_Effective_Date_Approv__c=Date.newInstance(2013 , 12 ,20),OD_Revenue_Impact__c= 8989,Customer_Notification_Date_Rep__c=Date.newInstance(2012 , 10 ,20),SRM_Differential__c=5,record_unlock_Status__c='open',Item_12_Month_Qty__c = 50,Total_Spend_Impact_12_Month__c=80000,Sales_Price_Change_Effective_Date_Min__c=Date.newInstance(2020 , 12 ,20),Customer__c = acc2.id, Owning_Customer_ID__c ='123456', SFDC_Notification_Flag__c = '3');
 ace3.Exception_Date_Request_Reason__c = 'Other';
 ace3.Date_Exception_Additional_Comments__c = null;
 ace3.Date_Exception_Additional_Comments__c='';
 ace3.Previous_Exception_Impact__c=10000;
ace3.Previous_Exception_Days__c=100;
 
ACE_Customer_Price_Changes__c ace4 = new ACE_Customer_Price_Changes__c(Sales_Price_Change_Effective_Date_Rep__c=Date.newInstance(2080, 10 ,20),name='test',Customer_Notification_Date_Approved__c=Date.newInstance(2013 , 10 ,20),Customer_Notification_Date__c=Date.newInstance(2013 , 12 ,20),Sales_Price_Change_Effective_Date_Approv__c=Date.newInstance(2013 , 12 ,20),OD_Revenue_Impact__c= 8989,Customer_Notification_Date_Rep__c=Date.newInstance(2012 , 10 ,20),SRM_Differential__c=5,record_unlock_Status__c='open',Item_12_Month_Qty__c = 50,Total_Spend_Impact_12_Month__c=80000,Sales_Price_Change_Effective_Date_Min__c=Date.newInstance(2020 , 12 ,20),Customer__c = acc2.id, Owning_Customer_ID__c ='123456', SFDC_Notification_Flag__c = '3');
ace4.Sales_Price_Change_Effective_Date__c=Date.newInstance(2013 , 12 ,21);
ace4.Sales_Price_Change_Effective_Date_Rep__c=Date.newInstance(2013 , 12 ,20);
ace4.Previous_Exception_Impact__c=10000;
ace4.Previous_Exception_Days__c=100;

ACE_Customer_Price_Changes__c ace5 = new ACE_Customer_Price_Changes__c(Sales_Price_Change_Effective_Date_Rep__c=Date.newInstance(2080, 12 ,21),name='test',Customer_Notification_Date_Approved__c=Date.newInstance(2013 , 10 ,20),Customer_Notification_Date__c=Date.newInstance(2013 , 12 ,20),Sales_Price_Change_Effective_Date_Approv__c=Date.newInstance(2013 , 12 ,20),OD_Revenue_Impact__c= 8989,Customer_Notification_Date_Rep__c=Date.newInstance(2012 , 10 ,20),SRM_Differential__c=5,record_unlock_Status__c='open',Item_12_Month_Qty__c = 50,Total_Spend_Impact_12_Month__c=80000,Sales_Price_Change_Effective_Date_Min__c=Date.newInstance(2020 , 12 ,20),Customer__c = acc.id, Owning_Customer_ID__c ='123456', SFDC_Notification_Flag__c = '3');
ace5.Sales_Price_Change_Effective_Date__c=Date.newInstance(2013 , 12 ,20); 
ace5.Previous_Exception_Impact__c=10000;
ace5.Previous_Exception_Days__c=100;
ace5.OD_Revenue_Impact__c= 8989;

ACE_Customer_Price_Changes__c ace6 = new ACE_Customer_Price_Changes__c(Sales_Price_Change_Effective_Date_Rep__c=Date.newInstance(2080, 10 ,20),name='test',Customer_Notification_Date_Approved__c=Date.newInstance(2013 , 10 ,20),Customer_Notification_Date__c=Date.newInstance(2013 , 12 ,20),Sales_Price_Change_Effective_Date_Approv__c=Date.newInstance(2013 , 12 ,20),OD_Revenue_Impact__c= 8000,Customer_Notification_Date_Rep__c=Date.newInstance(2012 , 10 ,20),SRM_Differential__c=5,record_unlock_Status__c='open',Item_12_Month_Qty__c = 50,Total_Spend_Impact_12_Month__c=80000,Sales_Price_Change_Effective_Date_Min__c=Date.newInstance(2020 , 12 ,20),Customer__c = acc.id, Owning_Customer_ID__c ='123456', SFDC_Notification_Flag__c = '3');
ace6.Sales_Price_Change_Effective_Date__c=Date.newInstance(2013 , 12 ,22); 
 ace6.Previous_Exception_Impact__c=10000;
ace6.Previous_Exception_Days__c=100;

 
 ACPC.add(ace1);
 ACPC.add(ace2);
 ACPC.add(ace3);
 ACPC.add(ace4);
 ACPC.add(ace5);
 ACPC.add(ace6);
 insert ACPC ;
 
 //ApexPages.currentPage().getParameters().Put('id',ace1.id);
 ApexPages.currentPage().getParameters().Put('pid',ace1.id);
 Ace_Customer_Core_Changes__c CCCC = new Ace_Customer_Core_Changes__c();
 CCCC.ACE_Customer_Price_Changes__c=ace1.id;
 CCCC.CoreID__c='alpha';
 insert CCCC;
 ApexPages.currentPage().getParameters().Put('pid',ace2.id);
 Ace_Customer_Core_Changes__c CCCC2 = new Ace_Customer_Core_Changes__c();
 CCCC2.ACE_Customer_Price_Changes__c=ace2.id;
 CCCC2.CoreID__c='alpha';
 insert CCCC2;
 
 
 
 ApexPages.StandardController con = new ApexPages.StandardController(ace1);
  
 aceDateChanges controller1 = new aceDateChanges(); 
 aceDateChanges controller = new aceDateChanges(con); 
 
 controller.CalculateRevenueImpact();
 controller.saveChanges();
 ace1.OD_Revenue_Impact__c= 8989;
 update ace1;
 controller.saveChanges();
 controller.cancelChanges();
 

 
 
 ApexPages.StandardController con2 = new ApexPages.StandardController(ace2);
 
 aceDateChanges controller12 = new aceDateChanges(); 
 aceDateChanges controller2 = new aceDateChanges(con2); 
 
 controller2.CalculateRevenueImpact();
 controller2.saveChanges();
 ace2.OD_Revenue_Impact__c= 8989;
 update ace2;
 controller2.saveChanges();
 controller2.cancelChanges();
 
  ApexPages.currentPage().getParameters().Put('pid',ace6.id);
 Ace_Customer_Core_Changes__c CCCC6 = new Ace_Customer_Core_Changes__c();
 CCCC6.ACE_Customer_Price_Changes__c=ace6.id;
 CCCC6.CoreID__c='alpha';
 insert CCCC6;
 
 ApexPages.StandardController con6 = new ApexPages.StandardController(ace6);
  
 aceDateChanges controller6 = new aceDateChanges(); 
 aceDateChanges controller66 = new aceDateChanges(con6); 
 
 //controller66.CalculateRevenueImpact();
 controller66.saveChanges();
 ace6.Previous_Exception_Impact__c=null;
 ace6.Previous_Exception_Days__c=null;
 update ace6;
 controller66.saveChanges();
 controller.cancelChanges();
 
 
 
 
 ApexPages.currentPage().getParameters().Put('pid',ace5.id);
 Ace_Customer_Core_Changes__c CCCC5 = new Ace_Customer_Core_Changes__c();
 CCCC5.ACE_Customer_Price_Changes__c=ace5.id;
 CCCC5.CoreID__c='alpha';
 insert CCCC5;
 
 ApexPages.StandardController con5 = new ApexPages.StandardController(ace5);
 
 aceDateChanges controller5 = new aceDateChanges(); 
 aceDateChanges controller55 = new aceDateChanges(con5); 

 //controller5.CalculateRevenueImpact();
 controller5.saveChanges();
 controller5.cancelChanges();
 
 ApexPages.currentPage().getParameters().Put('pid',ace4.id);
 Ace_Customer_Core_Changes__c CCCC4 = new Ace_Customer_Core_Changes__c();
 CCCC4.ACE_Customer_Price_Changes__c=ace4.id;
 CCCC4.CoreID__c='alpha';
 insert CCCC4;
 
 ApexPages.StandardController con4 = new ApexPages.StandardController(ace4);
  
 aceDateChanges controller4 = new aceDateChanges(); 
 aceDateChanges controller44 = new aceDateChanges(con4); 
 
 controller44.CalculateRevenueImpact();
  controller44.saveChanges();
 ace4.Sales_Price_Change_Effective_Date_Rep__c=Date.newInstance(2013 , 12 ,20);
 ace4.Sales_Price_Change_Effective_Date__c=Date.newInstance(2013 , 12 ,20);
 ace4.OD_Revenue_Impact__c= 8989;
 update ace4;
 controller44.saveChanges();
 controller44.cancelChanges();
 
 ApexPages.currentPage().getParameters().Put('pid',ace3.id);
 Ace_Customer_Core_Changes__c CCCC3 = new Ace_Customer_Core_Changes__c();
 CCCC3.ACE_Customer_Price_Changes__c=ace3.id;
 CCCC3.CoreID__c='alpha';
 insert CCCC3;
 
 ApexPages.StandardController con3 = new ApexPages.StandardController(ace3);
  
 aceDateChanges controller3 = new aceDateChanges(); 
 aceDateChanges controller33 = new aceDateChanges(con3); 
 
 controller33.CalculateRevenueImpact();
 
 controller33.saveChanges();
 ace4.OD_Revenue_Impact__c= 8989;
 update ace4;
 controller33.saveChanges();
 controller33.cancelChanges();
 }
 }