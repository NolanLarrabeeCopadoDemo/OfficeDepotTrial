/*
//   **************OLD ONE 
// (c) 2015 Appirio, Inc.
//
//
// 23 September 2016     Connor Flynn S-440218 (OD 00816644)
@isTest
private class ACE_Summary_Grid_New_TC
{
    static testMethod void ACE_Summary_Grid_New_method_Bucket3()
    {
         ACE_Settings__c desettings = new ACE_Settings__c(BatchName__c='Q2-2014');
         insert desettings; 
         Account acc = new Account (name = 'SUN Test Account',AOPS_Seq_ID__c = '123456',AOPS_Cust_Id__c = '123456',Oracle_Party_Id__c = '123456',Billingcountry = 'USA',BillingState = 'UT',BillingStreet = '1040 N 326 W',billingcity = 'Orem');
         insert acc;
         
         ACE_Customer_Price_Changes__c ace1 = new ACE_Customer_Price_Changes__c(name='Q2-2014',batchID__c = 'Q2-2014', SRM_Differential__c=5,Item_12_Month_Qty__c = 50,Total_Spend_Impact_12_Month__c=5,Customer__c = acc.id, Owning_Customer_ID__c ='123456', SFDC_Notification_Flag__c = '3');
         insert ace1;
         
         Ace_Customer_Core_Changes__c ace2 = new Ace_Customer_Core_Changes__c(name = 'Test',CoreID__c = '123456', ACE_Customer_Price_Changes__c = ace1.id);
         insert ace2;
        
         Ace_Customer_SKU_Changes__c ace3 = new Ace_Customer_SKU_Changes__c(SKU__c = '123456',name='test', Ace_Customer_Core_Changes__c = ace2.id);
         insert ace3;
         
         ApexPages.currentPage().getParameters().put('batch','Q2-2014');
         ACE_Summary_Grid_New aceSummaryGrid = new ACE_Summary_Grid_New();
         
         test.startTest();
         aceSummaryGrid.doExpand();
         aceSummaryGrid.Notify_doExpand();
         aceSummaryGrid.Noreq_doExpand();
         aceSummaryGrid.setOwnerTypeSel('All');
         aceSummaryGrid.getOwnerTypeSel();
         aceSummaryGrid.SearchText = 'T';
         aceSummaryGrid.SearchRecords();
         aceSummaryGrid.searchWord = 'T';
         aceSummaryGrid.TOTCORE = 0;   //mm
         aceSummaryGrid.TotSKU = 0;    //mm
         aceSummaryGrid.total_size_notify = 0;  //mm
         //aceSummaryGrid.perIncrease = null;  //mm
       //  aceSummaryGrid.SearchRecords();
         aceSummaryGrid.nextPage();
         aceSummaryGrid.prevPage(); 
         aceSummaryGrid.getDisablePrevious();
         aceSummaryGrid.getDisableNext();
         aceSummaryGrid.getDisablePrevious_noreq();
         aceSummaryGrid.getDisableNext_noreq();
         aceSummaryGrid.showCustList();
         //aceSummaryGrid.SubmitRelease();
         aceSummaryGrid.SubmitRelease_noreq();
         aceSummaryGrid.renderNotConfirm = true; //mm
         aceSummaryGrid.renderBothConfirm = true; //mm
         //***********aceSummaryGrid.renderRelConfirm = true;
         aceSummaryGrid.Total_SRM = 'test';  //mm
         aceSummaryGrid.RenderIGM = true;  //mm
         aceSummaryGrid.renderTable = false; //mm
         //aceSummaryGrid.perIncrease = 0;
         aceSummaryGrid.getURL();  //mm
        
         //aceSummaryGrid.expandLabel = '[-] Approval Required Per Written Agreement';
         //aceSummaryGrid.doExpand();
        
         //New_Gross_IGM__c
         aceSummaryGrid.Notify_searchText.trim();
         aceSummaryGrid.Notify_searchText = null;
         aceSummaryGrid.sortCust();
                ACE_Settings__c ob1 = new ACE_Settings__c();
                ob1.Level2Access__c='VBDM';
         Test.stopTest();          
    }
    
    static testMethod void ACE_Summary_Grid_New_method_Bucket2()
    {
         //Connor Flynn S-440218 (OD 00816644) Start
         Profile p4 = [SELECT Id FROM profile WHERE name='System Administrator']; 
         List<User> insertuser= new List<User>();  
         User u1 = new User(alias = 'test123 ', short_Title__c = 'Test', email='proxy@proxy456.officedepot.com',OD_Employee_ID__c='appr1',emailencodingkey='UTF-8', lastname='test123',languagelocalekey='en_US',localesidkey='en_US', profileid = p4.Id,timezonesidkey='America/Los_Angeles',username='proxy@proxy456.com',isactive=true);
         insertuser.add(u1);
         insert insertuser;
         System.runas(u1){
         //Connor Flynn S-440218 (OD 00816644) End
        
         ACE_Settings__c desettings = new ACE_Settings__c(BatchName__c='Q2-2014', level3Access__c = 'test');//CF
         insert desettings; 
         Account acc = new Account (name = 'SUN Test Account',AOPS_Seq_ID__c = '123456',AOPS_Cust_Id__c = '123456',Oracle_Party_Id__c = '123456',Billingcountry = 'USA',BillingState = 'UT',BillingStreet = '1040 N 326 W',billingcity = 'Orem');
         insert acc;
         
         ACE_Customer_Price_Changes__c ace1 = new ACE_Customer_Price_Changes__c(name='Q2-2014',batchID__c = 'Q2-2014', SRM_Differential__c=5,Item_12_Month_Qty__c = 50,Total_Spend_Impact_12_Month__c=5,Customer__c = acc.id, Owning_Customer_ID__c ='123456', SFDC_Notification_Flag__c = '2');
         insert ace1;
         
         Ace_Customer_Core_Changes__c ace2 = new Ace_Customer_Core_Changes__c(name = 'Test',CoreID__c = '123456', ACE_Customer_Price_Changes__c = ace1.id);
         insert ace2;
        
         Ace_Customer_SKU_Changes__c ace3 = new Ace_Customer_SKU_Changes__c(SKU__c = '123456',name='test', Ace_Customer_Core_Changes__c = ace2.id);
         insert ace3;
         
         ApexPages.currentPage().getParameters().put('batch','Q2-2014');
         ACE_Summary_Grid_New aceSummaryGrid = new ACE_Summary_Grid_New();
         
         
         test.startTest();
         aceSummaryGrid.doExpand();
         aceSummaryGrid.Notify_doExpand();
         aceSummaryGrid.Noreq_doExpand();
         aceSummaryGrid.setOwnerTypeSel('All');
         aceSummaryGrid.getOwnerTypeSel();
         aceSummaryGrid.SearchText = 'T';
         aceSummaryGrid.SearchRecords_sec();
         aceSummaryGrid.searchWord = 'T';
         aceSummaryGrid.showCustList();
        // aceSummaryGrid.SearchRecords();
         aceSummaryGrid.nextPage_notify();
         aceSummaryGrid.prevPage_notify(); 
         aceSummaryGrid.getDisablePrevious_notify();
         aceSummaryGrid.getDisableNext_notify();
         aceSummaryGrid.SubmitRelease_notify();   
         //aceSummaryGrid.perIncrease = 0;
         //aceSummaryGrid.perIncrease_notify = 0;
         aceSummaryGrid.RenderIGM = false;  //mm
         aceSummaryGrid.renderTable = true;  //mm
         //************aceSummaryGrid.renderRelConfirm = false;
         aceSummaryGrid.TotCore = 0;   //mm
         aceSummaryGrid.TotSKU = 0;   //mm
         aceSummaryGrid.total_size_notify = 0;  //mm
         //aceSummaryGrid.perIncrease = null;  //mm
         aceSummaryGrid.getURL();  //mm   
         aceSummaryGrid.nextPage();   //mm
         aceSummaryGrid.prevPage();  //mm
         aceSummaryGrid.SubmitRelease();
             
         //aceSummaryGrid.getFieldName='Customer';
         //aceSummaryGrid.sortCust();
         //aceSummaryGrid.FieldName='Customer__r.name';
         //ceSummaryGrid.sortCust();
             
         Test.stopTest();          
       
         aceSummaryGrid.getFieldName_notify = 'Customer';
         aceSummaryGrid.sortCust_notify();
         aceSummaryGrid.getFieldName_notify = 'Cores';
         aceSummaryGrid.sortCust_notify();
         aceSummaryGrid.getFieldName_notify = 'SKU';
         aceSummaryGrid.sortCust_notify();
         aceSummaryGrid.getFieldName_notify = 'Reps';
         aceSummaryGrid.sortCust_notify();             
         aceSummaryGrid.getFieldName_notify = 'NoOfSKUGovernedByActiveWrittenAgreement';
         aceSummaryGrid.sortCust_notify();  
         aceSummaryGrid.getFieldName_notify = 'annualspend';
         aceSummaryGrid.sortCust_notify();
         aceSummaryGrid.getFieldName_notify = 'annualspndchange';
         aceSummaryGrid.sortCust_notify();
         aceSummaryGrid.getFieldName_notify = 'srmimpact';
         aceSummaryGrid.sortCust_notify();
         aceSummaryGrid.getFieldName_notify = 'effectiveDate';
         aceSummaryGrid.sortCust_notify();
         aceSummaryGrid.getFieldName_notify = 'notifydate';
         aceSummaryGrid.sortCust_notify();
         
         aceSummaryGrid.getFieldName_noreq='Customer';
         aceSummaryGrid.sortCust_noreq();
         aceSummaryGrid.getFieldName_noreq='Cores';
         aceSummaryGrid.sortCust_noreq();
         aceSummaryGrid.getFieldName_noreq='SKU';
         aceSummaryGrid.sortCust_noreq();
         aceSummaryGrid.getFieldName_noreq = 'NoOfSKUGovernedByActiveWrittenAgreement__c';
         aceSummaryGrid.sortCust_noreq();  
         aceSummaryGrid.getFieldName_noreq='annualspend';
         aceSummaryGrid.sortCust_noreq();
         aceSummaryGrid.getFieldName_noreq='annualspndchange';
         aceSummaryGrid.sortCust_noreq();
         aceSummaryGrid.getFieldName_noreq='srmimpact';
         aceSummaryGrid.sortCust_noreq();
         aceSummaryGrid.getFieldName_noreq='effectiveDate';
         aceSummaryGrid.sortCust_noreq();
         aceSummaryGrid.getFieldName_noreq='notifydate';
         aceSummaryGrid.sortCust_noreq();
        
         aceSummaryGrid.getFieldName = 'Customer';
         aceSummaryGrid.sortCust();
         aceSummaryGrid.getFieldName = 'Cores';
         aceSummaryGrid.sortCust();
         aceSummaryGrid.getFieldName = 'SKU';
         aceSummaryGrid.sortCust();
         aceSummaryGrid.getFieldName = 'NoOfSKUGovernedByActiveWrittenAgreement';
         aceSummaryGrid.sortCust();  
         aceSummaryGrid.getFieldName = 'Reps';
         aceSummaryGrid.sortCust();      
         aceSummaryGrid.getFieldName = 'annualspend';
         aceSummaryGrid.sortCust();
         aceSummaryGrid.getFieldName = 'annualspndchange';
         aceSummaryGrid.sortCust();
         aceSummaryGrid.getFieldName = 'srmimpact';
         aceSummaryGrid.sortCust();
         aceSummaryGrid.getFieldName = 'effectiveDate';
         aceSummaryGrid.sortCust();
         aceSummaryGrid.getFieldName = 'notifydate';
         aceSummaryGrid.sortCust();          
         }//Connor Flynn S-440218 (OD 00816644)
    }
    
    static testMethod void ACE_Summary_Grid_New_method_Bucket1()
    {
    
         //Connor Flynn S-440218 (OD 00816644) Start
         Profile p4 = [SELECT Id FROM profile WHERE name='System Administrator']; 
         List<User> insertuser= new List<User>();  
         User u1 = new User(alias = 'test123 ', short_Title__c = 'Test', email='proxy@proxy456.officedepot.com',OD_Employee_ID__c='appr1',emailencodingkey='UTF-8', lastname='test123',languagelocalekey='en_US',localesidkey='en_US', profileid = p4.Id,timezonesidkey='America/Los_Angeles',username='proxy@proxy456.com',isactive=true);
         insertuser.add(u1);
         insert insertuser;
         System.runas(u1){
         //Connor Flynn S-440218 (OD 00816644) End
         ACE_Settings__c desettings = new ACE_Settings__c(BatchName__c='Q2-2014', level2Access__c = 'Test');//cf
         insert desettings; 
         Account acc = new Account (name = 'SUN Test Account',AOPS_Seq_ID__c = '123456',AOPS_Cust_Id__c = '123456',Oracle_Party_Id__c = '123456',Billingcountry = 'USA',BillingState = 'UT',BillingStreet = '1040 N 326 W',billingcity = 'Orem');
         insert acc;
         
         ACE_Customer_Price_Changes__c ace1 = new ACE_Customer_Price_Changes__c(name='Q2-2014',batchID__c = 'Q2-2014', SRM_Differential__c=5,Item_12_Month_Qty__c = 50,Total_Spend_Impact_12_Month__c=5,Customer__c = acc.id, Owning_Customer_ID__c ='123456', SFDC_Notification_Flag__c = '1');
         insert ace1;
         
         Ace_Customer_Core_Changes__c ace2 = new Ace_Customer_Core_Changes__c(name = 'Test',CoreID__c = '123456', ACE_Customer_Price_Changes__c = ace1.id);
         insert ace2;
        
         Ace_Customer_SKU_Changes__c ace3 = new Ace_Customer_SKU_Changes__c(SKU__c = '123456',name='test', Ace_Customer_Core_Changes__c = ace2.id);
         insert ace3;
         
         ApexPages.currentPage().getParameters().put('batch','Q2-2014');
         ACE_Summary_Grid_New aceSummaryGrid = new ACE_Summary_Grid_New();
         
         
         
         test.startTest();
         aceSummaryGrid.doExpand();
             
         aceSummaryGrid.renderNotConfirm = true; //mm
         aceSummaryGrid.renderNotConfirm = false; //mm
         aceSummaryGrid.renderBothConfirm = true; //mm
         aceSummaryGrid.renderBothConfirm = false; //mm
         aceSummaryGrid.renderRelConfirm = true;
         aceSummaryGrid.Total_SRM = 'test';  //mm
         aceSummaryGrid.RenderIGM = false;  //mm
         aceSummaryGrid.renderTable = false; //mm
         aceSummaryGrid.getURL();  //mm    
         aceSummaryGrid.TOTCORE = 0;   //mm
         aceSummaryGrid.TotSKU = 0;    //mm 
         aceSummaryGrid.total_size_notify = 0;  //mm
         aceSummaryGrid.perIncrease = null;  //mm
         aceSummaryGrid.showCustList();  //mm
         aceSummaryGrid.setOwnerTypeSel('All');
         aceSummaryGrid.getOwnerTypeSel();
         aceSummaryGrid.SubmitRelease();
             
         //Connor Flynn S-440218 (OD 00816644) Start
         aceSummaryGrid.expandLabel = '[-] Approval Required Per Written Agreement';
         aceSummaryGrid.doExpand();
         aceSummaryGrid.Notify_doExpand();
         aceSummaryGrid.Notify_expandLabel = '[-] Notification Required Per Written Agreement';
         aceSummaryGrid.Notify_doExpand();
         aceSummaryGrid.Noreq_doExpand();
         aceSummaryGrid.Noreq_expandLabel = '[-] No Requirements';
         aceSummaryGrid.Noreq_doExpand();
         aceSummaryGrid.OwnerValue = 'All';
         aceSummaryGrid.constructDataList();
         aceSummaryGrid.OwnerValue = 'Owned by others';
         aceSummaryGrid.constructDataList();
         aceSummaryGrid.OwnerValue = 'Else';
         aceSummaryGrid.constructDataList();
         //Connor Flynn S-440218 (OD 00816644) End
         aceSummaryGrid.SearchText = 'T';
         aceSummaryGrid.SearchRecords();
         aceSummaryGrid.searchWord = 'T';
        // aceSummaryGrid.SearchRecords();
         aceSummaryGrid.nextPage_noreq();
         aceSummaryGrid.prevPage_noreq(); 
         aceSummaryGrid.SubmitRelease_noreq();
         aceSummaryGrid.perIncrease_noreq = 0;
         Test.stopTest();    
         
         aceSummaryGrid.getFieldName_noreq='Customer';
         aceSummaryGrid.sortCust_noreq();
         aceSummaryGrid.getFieldName_noreq='Cores';
         aceSummaryGrid.sortCust_noreq();
         aceSummaryGrid.getFieldName_noreq='SKU';
         aceSummaryGrid.sortCust_noreq();
         aceSummaryGrid.getFieldName_noreq='Reps';
         aceSummaryGrid.sortCust_noreq();    
         aceSummaryGrid.getFieldName_noreq='NoOfSKUGovernedByActiveWrittenAgreement';
         aceSummaryGrid.sortCust_noreq();    
         aceSummaryGrid.getFieldName_noreq='annualspend';
         aceSummaryGrid.sortCust_noreq();
         aceSummaryGrid.getFieldName_noreq='annualspndchange';
         aceSummaryGrid.sortCust_noreq();
         aceSummaryGrid.getFieldName_noreq='srmimpact';
         aceSummaryGrid.sortCust_noreq();
         aceSummaryGrid.getFieldName_noreq='effectiveDate';
         aceSummaryGrid.sortCust_noreq();
         aceSummaryGrid.getFieldName_noreq='notifydate';
         aceSummaryGrid.sortCust_noreq();
         aceSummaryGrid.getFieldName_noreq='TOTSKU';
         aceSummaryGrid.sortCust_noreq();
         } //Connor Flynn S-440218 (OD 00816644)
    }
    
    
}                    ***********END OLD ONE                  
*/



// 
// (c) 2015 Appirio, Inc.
//
//
// 23 September 2016     Connor Flynn S-440218 (OD 00816644)
@isTest
private class ACE_Summary_Grid_New_TC
{
    static testMethod void ACE_Summary_Grid_New_method_Bucket3()
    {
         ACE_Settings__c desettings = new ACE_Settings__c(BatchName__c='Q2-2014');
         insert desettings; 
         Account acc = new Account (name = 'SUN Test Account',AOPS_Seq_ID__c = '123456',AOPS_Cust_Id__c = '123456',Oracle_Party_Id__c = '123456',Billingcountry = 'USA',BillingState = 'UT',BillingStreet = '1040 N 326 W',billingcity = 'Orem');
         insert acc;
         
         ACE_Customer_Price_Changes__c ace1 = new ACE_Customer_Price_Changes__c(name='Q2-2014',batchID__c = 'Q2-2014', SRM_Differential__c=5,Item_12_Month_Qty__c = 50,Total_Spend_Impact_12_Month__c=5,Customer__c = acc.id, Owning_Customer_ID__c ='123456', SFDC_Notification_Flag__c = '3');
         insert ace1;
         
         Ace_Customer_Core_Changes__c ace2 = new Ace_Customer_Core_Changes__c(name = 'Test',CoreID__c = '123456', ACE_Customer_Price_Changes__c = ace1.id);
         insert ace2;
        
         Ace_Customer_SKU_Changes__c ace3 = new Ace_Customer_SKU_Changes__c(SKU__c = '123456',name='test', Ace_Customer_Core_Changes__c = ace2.id);
         insert ace3;
         
         ApexPages.currentPage().getParameters().put('batch','Q2-2014');
         ACE_Summary_Grid_New aceSummaryGrid = new ACE_Summary_Grid_New();
         
         test.startTest();
         aceSummaryGrid.doExpand();
         aceSummaryGrid.Notify_doExpand();
         aceSummaryGrid.Noreq_doExpand();
         aceSummaryGrid.setOwnerTypeSel('All');
         aceSummaryGrid.getOwnerTypeSel();
         aceSummaryGrid.SearchText = 'T';
         aceSummaryGrid.SearchRecords();
         aceSummaryGrid.searchWord = 'T';
       //  aceSummaryGrid.SearchRecords();
         aceSummaryGrid.nextPage();
         aceSummaryGrid.prevPage(); 
         aceSummaryGrid.getDisablePrevious();
         aceSummaryGrid.getDisableNext();
         aceSummaryGrid.showCustList();
         aceSummaryGrid.SubmitRelease();
         aceSummaryGrid.sortCust();
                ACE_Settings__c ob1 = new ACE_Settings__c();
                ob1.Level2Access__c='VBDM';
         Test.stopTest();          
    }
    
    static testMethod void ACE_Summary_Grid_New_method_Bucket2()
    {
         //Connor Flynn S-440218 (OD 00816644) Start
         Profile p4 = [SELECT Id FROM profile WHERE name='System Administrator']; 
         List<User> insertuser= new List<User>();  
         User u1 = new User(alias = 'test123 ', short_Title__c = 'Test', email='proxy@proxy456.officedepot.com',OD_Employee_ID__c='appr1',emailencodingkey='UTF-8', lastname='test123',languagelocalekey='en_US',localesidkey='en_US', profileid = p4.Id,timezonesidkey='America/Los_Angeles',username='proxy@proxy456.com',isactive=true);
         insertuser.add(u1);
         insert insertuser;
         System.runas(u1){
         //Connor Flynn S-440218 (OD 00816644) End
        
         ACE_Settings__c desettings = new ACE_Settings__c(BatchName__c='Q2-2014', level3Access__c = 'test');//CF
         insert desettings; 
         Account acc = new Account (name = 'SUN Test Account',AOPS_Seq_ID__c = '123456',AOPS_Cust_Id__c = '123456',Oracle_Party_Id__c = '123456',Billingcountry = 'USA',BillingState = 'UT',BillingStreet = '1040 N 326 W',billingcity = 'Orem');
         insert acc;
         
         ACE_Customer_Price_Changes__c ace1 = new ACE_Customer_Price_Changes__c(name='Q2-2014',batchID__c = 'Q2-2014', SRM_Differential__c=5,Item_12_Month_Qty__c = 50,Total_Spend_Impact_12_Month__c=5,Customer__c = acc.id, Owning_Customer_ID__c ='123456', SFDC_Notification_Flag__c = '2');
         insert ace1;
         
         Ace_Customer_Core_Changes__c ace2 = new Ace_Customer_Core_Changes__c(name = 'Test',CoreID__c = '123456', ACE_Customer_Price_Changes__c = ace1.id);
         insert ace2;
        
         Ace_Customer_SKU_Changes__c ace3 = new Ace_Customer_SKU_Changes__c(SKU__c = '123456',name='test', Ace_Customer_Core_Changes__c = ace2.id);
         insert ace3;
         
         ApexPages.currentPage().getParameters().put('batch','Q2-2014');
         ACE_Summary_Grid_New aceSummaryGrid = new ACE_Summary_Grid_New();
         
         
         test.startTest();
         aceSummaryGrid.doExpand();
         aceSummaryGrid.Notify_doExpand();
         aceSummaryGrid.Noreq_doExpand();
         aceSummaryGrid.SearchText = 'T';
         aceSummaryGrid.SearchRecords_sec();
         aceSummaryGrid.searchWord = 'T';
        // aceSummaryGrid.SearchRecords();
         aceSummaryGrid.nextPage_notify();
         aceSummaryGrid.prevPage_notify(); 
         aceSummaryGrid.getDisablePrevious_notify();
         aceSummaryGrid.getDisableNext_notify();
         aceSummaryGrid.SubmitRelease_notify();         
         Test.stopTest();          
         
         aceSummaryGrid.getFieldName_notify = 'Customer';
         aceSummaryGrid.sortCust_notify();
         aceSummaryGrid.getFieldName_notify = 'Cores';
         aceSummaryGrid.sortCust_notify();
         aceSummaryGrid.getFieldName_notify = 'SKU';
         aceSummaryGrid.sortCust_notify();
         aceSummaryGrid.getFieldName_notify = 'annualspend';
         aceSummaryGrid.sortCust_notify();
         aceSummaryGrid.getFieldName_notify = 'annualspndchange';
         aceSummaryGrid.sortCust_notify();
         aceSummaryGrid.getFieldName_notify = 'srmimpact';
         aceSummaryGrid.sortCust_notify();
         aceSummaryGrid.getFieldName_notify = 'effectiveDate';
         aceSummaryGrid.sortCust_notify();
         aceSummaryGrid.getFieldName_notify = 'notifydate';
         aceSummaryGrid.sortCust_notify();
         aceSummaryGrid.getFieldName_notify='NoOfSKUGovernedByActiveWrittenAgreement';
         aceSummaryGrid.sortCust_notify();      
         aceSummaryGrid.getFieldName_notify='Reps';
         aceSummaryGrid.sortCust_notify(); 
         aceSummaryGrid.getFieldName_noreq='Customer';
         aceSummaryGrid.sortCust_noreq();
         aceSummaryGrid.getFieldName_noreq='Cores';
         aceSummaryGrid.sortCust_noreq();
         aceSummaryGrid.getFieldName_noreq='SKU';
         aceSummaryGrid.sortCust_noreq();
         aceSummaryGrid.getFieldName_noreq='annualspend';
         aceSummaryGrid.sortCust_noreq();
         aceSummaryGrid.getFieldName_noreq='annualspndchange';
         aceSummaryGrid.sortCust_noreq();
         aceSummaryGrid.getFieldName_noreq='srmimpact';
         aceSummaryGrid.sortCust_noreq();
         aceSummaryGrid.getFieldName_noreq='effectiveDate';
         aceSummaryGrid.sortCust_noreq();
         aceSummaryGrid.getFieldName_noreq='notifydate';
         aceSummaryGrid.sortCust_noreq();
         aceSummaryGrid.getFieldName = 'NoOfSKUGovernedByActiveWrittenAgreement';
         aceSummaryGrid.sortCust_noreq();    
         aceSummaryGrid.getFieldName = 'Reps';
         aceSummaryGrid.sortCust_noreq();
         
         aceSummaryGrid.getFieldName = 'Customer';
         aceSummaryGrid.sortCust();
         aceSummaryGrid.getFieldName = 'Cores';
         aceSummaryGrid.sortCust();
         aceSummaryGrid.getFieldName = 'SKU';
         aceSummaryGrid.sortCust();
         aceSummaryGrid.getFieldName = 'annualspend';
         aceSummaryGrid.sortCust();
         aceSummaryGrid.getFieldName = 'annualspndchange';
         aceSummaryGrid.sortCust();
         aceSummaryGrid.getFieldName = 'srmimpact';
         aceSummaryGrid.sortCust();
         aceSummaryGrid.getFieldName = 'effectiveDate';
         aceSummaryGrid.sortCust();
         aceSummaryGrid.getFieldName = 'notifydate';
         aceSummaryGrid.sortCust();
         aceSummaryGrid.getFieldName = 'NoOfSKUGovernedByActiveWrittenAgreement';
         aceSummaryGrid.sortCust();    
         aceSummaryGrid.getFieldName = 'Reps';
         aceSummaryGrid.sortCust();  
         }//Connor Flynn S-440218 (OD 00816644)
    }
    
    static testMethod void ACE_Summary_Grid_New_method_Bucket1()
    {
    
         //Connor Flynn S-440218 (OD 00816644) Start
         Profile p4 = [SELECT Id FROM profile WHERE name='System Administrator']; 
         List<User> insertuser= new List<User>();  
         User u1 = new User(alias = 'test123 ', short_Title__c = 'Test', email='proxy@proxy456.officedepot.com',OD_Employee_ID__c='appr1',emailencodingkey='UTF-8', lastname='test123',languagelocalekey='en_US',localesidkey='en_US', profileid = p4.Id,timezonesidkey='America/Los_Angeles',username='proxy@proxy456.com',isactive=true);
         insertuser.add(u1);
         insert insertuser;
         System.runas(u1){
         //Connor Flynn S-440218 (OD 00816644) End
         ACE_Settings__c desettings = new ACE_Settings__c(BatchName__c='Q2-2014', level2Access__c = 'Test');//cf
         insert desettings; 
         Account acc = new Account (name = 'SUN Test Account',AOPS_Seq_ID__c = '123456',AOPS_Cust_Id__c = '123456',Oracle_Party_Id__c = '123456',Billingcountry = 'USA',BillingState = 'UT',BillingStreet = '1040 N 326 W',billingcity = 'Orem');
         insert acc;
         
         ACE_Customer_Price_Changes__c ace1 = new ACE_Customer_Price_Changes__c(name='Q2-2014',batchID__c = 'Q2-2014', SRM_Differential__c=5,Item_12_Month_Qty__c = 50,Total_Spend_Impact_12_Month__c=5,Customer__c = acc.id, Owning_Customer_ID__c ='123456', SFDC_Notification_Flag__c = '1');
         insert ace1;
         
         Ace_Customer_Core_Changes__c ace2 = new Ace_Customer_Core_Changes__c(name = 'Test',CoreID__c = '123456', ACE_Customer_Price_Changes__c = ace1.id);
         insert ace2;
        
         Ace_Customer_SKU_Changes__c ace3 = new Ace_Customer_SKU_Changes__c(SKU__c = '123456',name='test', Ace_Customer_Core_Changes__c = ace2.id);
         insert ace3;
         
         ApexPages.currentPage().getParameters().put('batch','Q2-2014');
         ACE_Summary_Grid_New aceSummaryGrid = new ACE_Summary_Grid_New();
         
         
         
         test.startTest();
         aceSummaryGrid.doExpand();
         //Connor Flynn S-440218 (OD 00816644) Start
         aceSummaryGrid.expandLabel = '[-] Approval Required Per Written Agreement';
         aceSummaryGrid.doExpand();
         aceSummaryGrid.Notify_doExpand();
         aceSummaryGrid.Notify_expandLabel = '[-] Notification Required Per Written Agreement';
         aceSummaryGrid.Notify_doExpand();
         aceSummaryGrid.Noreq_doExpand();
         aceSummaryGrid.Noreq_expandLabel = '[-] No Requirements';
         aceSummaryGrid.Noreq_doExpand();
         aceSummaryGrid.OwnerValue = 'All';
         aceSummaryGrid.constructDataList();
         aceSummaryGrid.OwnerValue = 'Owned by others';
         aceSummaryGrid.constructDataList();
         aceSummaryGrid.OwnerValue = 'Else';
         aceSummaryGrid.constructDataList();
         //Connor Flynn S-440218 (OD 00816644) End
         aceSummaryGrid.SearchText = 'T';
         aceSummaryGrid.SearchRecords();
         aceSummaryGrid.searchWord = 'T';
        // aceSummaryGrid.SearchRecords();
         aceSummaryGrid.nextPage_noreq();
         aceSummaryGrid.prevPage_noreq(); 
         aceSummaryGrid.getDisablePrevious_noreq();
         aceSummaryGrid.getDisableNext_noreq();
         aceSummaryGrid.SubmitRelease_noreq();
         Test.stopTest();          
         
         aceSummaryGrid.getFieldName_noreq='Customer';
         aceSummaryGrid.sortCust_noreq();
         aceSummaryGrid.getFieldName_noreq='Cores';
         aceSummaryGrid.sortCust_noreq();
         aceSummaryGrid.getFieldName_noreq='SKU';
         aceSummaryGrid.sortCust_noreq();
         aceSummaryGrid.getFieldName_noreq='annualspend';
         aceSummaryGrid.sortCust_noreq();
         aceSummaryGrid.getFieldName_noreq='annualspndchange';
         aceSummaryGrid.sortCust_noreq();
         aceSummaryGrid.getFieldName_noreq='srmimpact';
         aceSummaryGrid.sortCust_noreq();
         aceSummaryGrid.getFieldName_noreq='effectiveDate';
         aceSummaryGrid.sortCust_noreq();
         aceSummaryGrid.getFieldName_noreq='notifydate';
         aceSummaryGrid.sortCust_noreq();
         } //Connor Flynn S-440218 (OD 00816644)
    }
    
    
}