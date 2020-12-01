@isTest
private class SplitRecordsValidator_TC 
{
    static testMethod void Test1()
    {

        Account pacc = new Account ();
        pacc.name = 'SUN Test Account1';
        pacc.recordtypeid=Schema.SObjectType.Account.getRecordTypeInfosByName().get('Customer (OfficeMax)').getRecordTypeId(); 
        pacc.BillingStreet = '1040 N 326 W';
        pacc.billingcity = 'Orem';
        pacc.BillingState = 'UT';
        pacc.Billingcountry = 'USA';
        pacc.Oracle_Party_Id__c = '543456';
        pacc.omx_primary_key__c = '0123452';
        insert pacc;
        
        Account acc = new Account ();
        acc.name = 'SUN Test Account';
        acc.BillingStreet = '1040 N 326 W';
        acc.billingcity = 'Orem';
        acc.BillingState = 'UT';
        acc.Billingcountry = 'USA';
        acc.Oracle_Party_Id__c = '123456';
        acc.omx_primary_key__c = '0123456';
        insert acc;   

        Account accSite = new Account ();
        accSite.name = 'SUN Test Account';
        accSite.BillingStreet = '1040 N 326 W';
        accSite.billingcity = 'Orem';
        accSite.BillingState = 'UT';
        accSite.recordtypeid= Schema.SObjectType.Account.getRecordTypeInfosByName().get('Site (OfficeMax)').getRecordTypeId();
        accSite.Billingcountry = 'USA';
        accSite.Oracle_Party_Site_Id__c = '12345678';
        accSite.Related_Account__c = acc.id;
        accSite.omx_primary_key__c = '012billto';
        insert accSite;
         Test.startTest();
        
        Customer_Transition__c ctRec = new Customer_Transition__c(name='Customer Transition of Test_Acc', 
        Account__c = acc.id, Cascade_down__c = true,OMX_Primary_Key__c='123458' );
        ctRec.Final_Split_Decision__c = 'Yes';
        ctRec.Ready_For_Mod_5__c = true;
        ctRec.Ready_for_Mod1__c = true;
        insert ctRec;
      
        List<Split_Account_Detail__c>  SplitAccDetailList = new List<Split_Account_Detail__c>();
        Split_Account_Detail__c sad =new Split_Account_Detail__c(
                                        name = 'test',status__c='Load');
        sad.Customer_Transition__c = ctRec.Id; 
        sad.status__c = 'Uploaded';
        sad.Master_Account__c='0123456';
        sad.NEW_BILL_TO_OMX_CONSIGNEE__c = '012billto';
        sad.NEW_MAIN_ACCT_ADDRESS__c = '012billto'; 
        insert sad;
        SplitAccDetailList.add(sad);
        
        Split_Account_Detail__c sad1 =new Split_Account_Detail__c(
                                        name = 'test',status__c='Load',Original_Account__c=pacc.id);
        sad1.status__c = 'Uploaded';
        sad1.NEW_BILL_TO_OMX_CONSIGNEE__c = '012billto';
        sad1.NEW_MAIN_ACCT_ADDRESS__c = '012billto';
        sad1.Master_Account__c='0123456';                               
                                        
        insert sad1;
        SplitAccDetailList.add(sad1);
        
        Split_Account_Detail__c sad2 =new Split_Account_Detail__c(
                                        name = 'test',status__c='Load');
        sad2.status__c = 'Uploaded';
        sad2.Master_Account__c='0123456';
        sad2.NEW_BILL_TO_OMX_CONSIGNEE__c = '011billto';                                
        insert sad2;        
        SplitAccDetailList.add(sad2);
    
        try{
          
         
          SplitRecordsValidator srv = new SplitRecordsValidator();
          srv.createSplitDetails(SplitAccDetailList);
          Test.stopTest();
          
        }
        catch(exception e){}
    }
    
    
}