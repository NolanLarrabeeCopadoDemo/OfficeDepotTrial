@IsTest
private Class ACE_SKU_Page_Controller_TC{
    static testMethod void Test_ACE_SKU_Page_Controller_Method(){
        Test.startTest();
        Account acc = new Account (name = 'SUN Test Account',AOPS_Seq_ID__c = '123456',AOPS_Cust_Id__c = '123456',Oracle_Party_Id__c = '123456',Billingcountry = 'USA',BillingState = 'UT',BillingStreet = '1040 N 326 W',billingcity = 'Orem');
        insert acc;
        ACE_Settings__c aset = new ACE_Settings__c(trigger_by_pass__c = '123');
        insert aset;
        ACE_Customer_Price_Changes__c ace1 = new ACE_Customer_Price_Changes__c(name='test',SRM_Differential__c=5,Item_12_Month_Qty__c = 50,Total_Spend_Impact_12_Month__c=5,Customer__c = acc.id, Owning_Customer_ID__c ='123456');
        insert ace1;
        
        Ace_Customer_Core_Changes__c ace2 = new Ace_Customer_Core_Changes__c(name = 'Test1',CoreID__c = '123456', ACE_Customer_Price_Changes__c = ace1.id);
        insert ace2;
        
        Ace_Customer_SKU_Changes__c ace3 = new Ace_Customer_SKU_Changes__c(SKU__c = '123456',status__c='Active',batchId__c='abc',Item_3_Month_Qty__c=12.12,Item_6_Month_Qty__c=12.12,Item_9_Month_Qty__c=12.12,Item_6_Month_Sales__c=12.12,Item_3_Month_Sales__c=12.12,
        Item_9_Month_Sales__c=12.12,Total_Spend_Impact_3_Month__c=12.12,Total_Spend_Impact_6_Month__c=12.12,Total_Spend_Impact_9_Month__c=12.12,Item_12_Month_Qty__c = 50,Item_12_Month_Sales__c=12.12,Total_Spend_Impact_12_Month__c=123.12,name='test', 
        Ace_Customer_Core_Changes__c = ace2.id,Core_s_SKU_Vendor_Name__c ='vendor1');
        insert ace3;
        ApexPages.currentPage().getParameters().Put('batch','batch1');
        ApexPages.currentPage().getParameters().Put('skuid','123456');
        ApexPages.currentPage().getParameters().Put('ownerValue','All');
        ApexPages.currentPage().getParameters().Put('Vendor','vendor1');
        ACE_SKU_Page_Controller SKUPageController = new ACE_SKU_Page_Controller();
        SKUPageController.getURL();
        ApexPages.currentPage().getParameters().Put('ownerValue','Owned by me');
        SKUPageController.Refresh_rec();
        SKUPageController.nextPage();
        SKUPageController.getDisableNext();
        SKUPageController.prevPage();
        SKUPageController.getDisablePrevious();
        
        ApexPages.currentPage().getParameters().Put('ownerValue','Owned by others');
        ApexPages.currentPage().getParameters().Put('Vendor','');
        SKUPageController = new ACE_SKU_Page_Controller();
        SKUPageController.status = '';
        SKUPageController.getURL();
        
        ApexPages.currentPage().getParameters().Put('ownerValue','');
        ApexPages.currentPage().getParameters().Put('Vendor','vendor1');
        SKUPageController = new ACE_SKU_Page_Controller();
        SKUPageController.status = '';
        SKUPageController.getURL();
        Test.StopTest();
     }
}