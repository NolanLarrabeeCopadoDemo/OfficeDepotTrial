@IsTest
private Class skuExceptionPageController_TC{
    static testMethod void skuExceptionPageController_Method(){

            List<Ace_Customer_SKU_Changes__c > lst_sku = new List<Ace_Customer_SKU_Changes__c >();
 
             Profile p = [select id from Profile where name='System Administrator' limit 1];
                   
             User mgruser = new User(TimeZoneSidKey='America/Los_Angeles',ProfileId = p.id,LastName = 'ACE', FirstName = 'Manager', Email = 'ACE.manager@officedepot.com',Username ='ACE.manager@officedepot.com', Alias='test', CommunityNickname='test Approver', LanguageLocaleKey='en_US', LocaleSidKey='en_US', EmailEncodingKey='UTF-8', OD_Employee_ID__c='653466');
             Insert mgruser;
            
             User user = new User(TimeZoneSidKey='America/Los_Angeles',ProfileId = p.id,LastName = 'Rep', FirstName = 'ACE',Email='Rep.ACE@officedepot.com', Username ='Rep.ACE@officedepot.com', Alias='test12', CommunityNickname='test Approve', LanguageLocaleKey='en_US', EmailEncodingKey='UTF-8', LocaleSidKey='en_US',OD_Employee_ID__c='653486');
             Insert user;
        system.runAs(user){
            
             ACE_Settings__c desettings = new ACE_Settings__c(BatchName__c='Q4-2014',trigger_by_pass__c=string.valueof(user.id));
             insert desettings; 
            
             Account acc = new Account (name = 'SUN Test Account',AOPS_Seq_ID__c = '123456',AOPS_Cust_Id__c = '123456',Oracle_Party_Id__c = '123456',Billingcountry = 'USA',BillingState = 'UT',BillingStreet = '1040 N 326 W',billingcity = 'Orem');
             insert acc;
             
             ACE_Customer_Price_Changes__c ace1 = new ACE_Customer_Price_Changes__c(name='test',batchId__c='Q4-2014',SRM_Differential__c=5,Item_12_Month_Qty__c = 50,Total_Spend_Impact_12_Month__c=5,Customer__c = acc.id, Owning_Customer_ID__c ='123456');
             insert ace1;
             
             Ace_Customer_Core_Changes__c ace2 = new Ace_Customer_Core_Changes__c(name = 'Test1',batchId__c='Q4-2014',CoreID__c = 'CL-123456', ACE_Customer_Price_Changes__c = ace1.id);
             insert ace2;
             
             Ace_Customer_SKU_Changes__c ace3 = new Ace_Customer_SKU_Changes__c(Price_Changes_Type__c = 'D',SKU__c = '123456',status__c='Active',batchId__c='Q4-2014',Item_3_Month_Qty__c=12.12,Item_6_Month_Qty__c=12.12,Item_9_Month_Qty__c=12.12,Item_6_Month_Sales__c=12.12,Item_3_Month_Sales__c=12.12,
             DSM__c = mgruser.id,Price_Change_ID__c=ace1.id,Item_9_Month_Sales__c=12.12,Total_Spend_Impact_3_Month__c=12.12,Total_Spend_Impact_6_Month__c=12.12,Total_Spend_Impact_9_Month__c=12.12,Item_12_Month_Qty__c = 50,Item_12_Month_Sales__c=12.12,Total_Spend_Impact_12_Month__c=123.12,name='test', Ace_Customer_Core_Changes__c = ace2.id);
             insert ace3;
             
             Ace_Customer_SKU_Changes__c ace4 = new Ace_Customer_SKU_Changes__c(SKU_Alt__c='123456',Price_Changes_Type__c = 'A',SKU__c = '1234562',status__c='Active',batchId__c='Q4-2014',Item_3_Month_Qty__c=12.12,Item_6_Month_Qty__c=12.12,Item_9_Month_Qty__c=12.12,Item_6_Month_Sales__c=12.12,Item_3_Month_Sales__c=12.12,
             Cap_Amount__c=0,Approved_Proposed_Price__c=25.00,Current_Sell_Price__c=10.00,Previous_Exception_Impact__c=10000,Price_Exception_revenue_Impact__c=15000,DSM__c = mgruser.id,Price_Change_ID__c=ace1.id,Item_9_Month_Sales__c=12.12,Total_Spend_Impact_3_Month__c=12.12,Total_Spend_Impact_6_Month__c=12.12,Total_Spend_Impact_9_Month__c=12.12,Item_12_Month_Qty__c = 50,Item_12_Month_Sales__c=12.12,Total_Spend_Impact_12_Month__c=123.12,name='test', Ace_Customer_Core_Changes__c = ace2.id);
             insert ace4;
            
            ApexPages.currentPage().getParameters().put('skuID',ace4.id);
            ApexPages.currentPage().getParameters().put('custName',acc.name);
            ApexPages.currentPage().getParameters().put('ID',ace4.id);
            ApexPages.currentPage().getParameters().put('period','test');
            ApexPages.currentPage().getParameters().put('DelSKUALT','true');
        
            system.runas(user){
            Test.startTest();
            skuExceptionPageController aslc = new skuExceptionPageController();            
            aslc.getURL();
            aslc.radioOption = 'KeepSkuandAlt';
            aslc.continueProcess();            
            aslc.radioOption = 'delSku';
            aslc.continueProcess();            
            aslc.radioOption = 'delSkuWithAlt';
            aslc.continueProcess();            
            aslc.radioOption = 'option1';
            aslc.continueProcess();            
            aslc.calcProposed();            
            aslc.Cancel();            
            aslc.approvalStep(); 
            aslc.userProposal=20.00;           
            aslc.submitReq();
            aslc.userProposal=28.00; 
            aslc.submitReq();
            Test.stopTest();
            }
        }
    }
}