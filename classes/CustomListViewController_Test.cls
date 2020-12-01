/***************************************************************************
 Name         : CustomListViewController_Test 
 Created By   : Lalit Malav
 Description  : Test class for CustomListViewController for  S-410488(00687615)
 Created Date : May  5, 2016                 

 Modified 23 September 2016     Connor Flynn S-440218 (OD 00816644)
****************************************************************************/
@isTest
private class CustomListViewController_Test {
    //constants, variables
    private static Integer NO_OF_RECORDS = 20 ;
    static User testUser, portalUser;
    static Contact testContact;
    //static User testAdminUser2 = [Select Name, contactId from user where Profile.Name = 'System Administrator' and isActive = true limit 1];
    //--------------------------------------------------------------------------------
     //Test Method to check Custom List View functionality
    //--------------------------------------------------------------------------------
    static testmethod void testFilterActions(){  
        //Connor Flynn S-440218 (OD 00816644) Start
        CustomListViewAccount__c tmpCustomListView = new CustomListViewAccount__c (Name='Test setting', FielApiName__c = 'Name',objectName__c = 'Account', viewType__c = 'AccountView', ColumnOrder__c =1, referenceField__c = 'OwnerId', isDefaultsortField__c = true);
        insert tmpCustomListView; 
        //Connor Flynn S-440218 (OD 00816644) End
         List<CustomListView__c> lstCustomSettings = createAccountCustomSetting();
        //Creating dummy Accounts for testing
        List<Account> accounts = new List<Account>();
        for(Integer i=0; i<NO_OF_RECORDS; i++) {
            accounts.add(new Account(Name = 'Test' + i));
        }
        insert accounts;
        String filter = EncodingUtil.urlEncode(' Name like \'Test%\'', 'UTF-8');
        PageReference pageRef = new PageReference('/apex/LeadsAccountsListView?objectType=Account&filter='+filter+'&viewType=MyAccount');
        Test.setCurrentPage(pageRef);
        //Creating Controller instance for calling methods
        CustomListViewController ctrl = new CustomListViewController();
        ctrl.getFieldListSTR();
        String[] charList = ctrl.getCharList();
        
        //Testing sorting method
        ctrl.doSort();
        //Story S-437501 Starts
        // Calling functions of class CustomListViewController
        ctrl.doSortAccount();  // Added by Jasvinder for Story S-437501 OD- 00800276
        ctrl.nextPageAccount();    // Added by Jasvinder for Story S-437501 OD- 00800276
        ctrl.previousPageAccount();    // Added by Jasvinder for Story S-437501 OD- 00800276
        ctrl.lastPageAccount();     // Added by Jasvinder for Story S-437501 OD- 00800276
         //Story S-437501 Ends
        
        system.assertEquals('Name', ctrl.sortField);
        //Filtering the result list
        ctrl.currentChar = 'C';
        ctrl.charFilter();
        //Connor Flynn S-440218 (OD 00816644) Start
        CustomListViewController.FieldSettingWrapper fsw = new CustomListViewController.FieldSettingWrapper();
        fsw.getFieldLabel();
        fsw.getMakeLink();
        fsw.getReferenceField();
        fsw.getMakeVisible();
        fsw.getEscapeOutput();
        fsw.getSortByFieldAPI();
        
        CustomListViewController.FieldSettingWrapperAccount fswa = new CustomListViewController.FieldSettingWrapperAccount();
        fswa.getFieldLabel();
        fswa.getEnableCharFilter();
        fswa.getMakeLink();
        fswa.getReferenceField();
        fswa.getmakeVisible();
        fswa.getEscapeOutput();
        fswa.getSortByFieldAPI();
        Account tmpAccount = new Account(Name = 'test');
        Map<string, CustomListViewController.FieldSettingWrapper> mapColumnsWrapper = new Map<string, CustomListViewController.FieldSettingWrapper>();
        mapColumnsWrapper.put('Name', fsw);
        CustomListViewController.ObjectWrapper tmpOW = new CustomListViewController.ObjectWrapper(tmpAccount,mapColumnsWrapper);
        tmpOw.getFieldMap();
        CustomListViewController.getValue(tmpAccount, 'Owner.Name');   
        //Connor Flynn S-440218 (OD 00816644) END
    }
    
    //--------------------------------------------------------------------------------
    //Method to Test page navigation
    //--------------------------------------------------------------------------------
    static testmethod void testPageNavigations() { 
         List<CustomListView__c> lstCustomSettings = createAccountCustomSetting();
        //Creating dummy Accounts for testing
        List<Account> accounts = new List<Account>();
        for(Integer i=0; i<NO_OF_RECORDS; i++) {
            accounts.add(new Account(Name = 'Test' + i));
        }
        insert accounts;
        String filter = EncodingUtil.urlEncode(' Name like \'Test%\'', 'UTF-8');
        PageReference pageRef = new PageReference('/apex/LeadsAccountsListView?objectType=Account&filter='+filter+'&viewType=MyAccount');
        Test.setCurrentPage(pageRef);
        //Creating Controller instance for calling methods
        CustomListViewController ctrl = new CustomListViewController();
        CustomListViewController.PAGESIZE = 10;
        //testing pagination methods
        ctrl.nextPage();
        system.assertEquals(false, ctrl.paginator.isNextPageAvailable);
        
        system.assertEquals(true, ctrl.paginator.isPreviousPageAvailable);
        ctrl.previousPage();
                    
        ctrl.lastPage();
        ctrl.firstPage();
             
    } 
    
        //Method to create Case custom settings for testing
    public static List<CustomListView__c> createAccountCustomSetting() {
        List<CustomListView__c> lstCLV = new List<CustomListView__c>();
        
        CustomListView__c c1 = new CustomListView__c();
        c1.ColumnOrder__c = 1;
        c1.FielApiName__c = 'Name';
        c1.ObjectName__c = 'Account';
        c1.FieldName__c = 'Name';
        c1.IsDefaultSortField__c = true;
        c1.Name = 'AccName';
        c1.makeLink__c = true;
        c1.referenceField__c = 'Id';
        c1.ViewType__c = 'MyAccount';
        lstCLV.add(c1);
        
       insert lstCLV;
       return lstCLV;
    }
    
    
}