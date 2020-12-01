// (c) 2015 Appirio, Inc.
//
// 17 July 2015     Ryan Marquardt     Added Test Coverage for S-335200
@isTest
private class ACEReporting_RevMarg_WaterFall_TC 
{
      
    private static ACEReporting_RevMarg_WaterFall arw;
    private static ACE_Customer_Price_Changes__c ace1;
    private static ACE_Customer_sku_Changes__c sku1;
    
    private static String reportType;
    private static String SegmentName;
    private static String SegmentType;
    private static String ReportName;
    private static String ErosionType;
    private static String quarter;
    private static String ColumnVal;
    private static String rowname;
    private static String listType;
    
    ////Added by Lalit for S-399112 START Start
    static testMethod void ExceptionReportCustList_testMethod1()
    {
    User runAsUser = loadChangeTypeData_User();
    System.runAs(runAsUser)
    {
        initialVal();   
        reportType = 'Remediation';
        SegmentName = null;
        listType = 'Date-Requested';
        ErosionType = null;
        ApexPages.CurrentPage().getParameters().put('ErosionType',ErosionType);
        ApexPages.CurrentPage().getParameters().put('reportType',reportType);       
        ApexPages.CurrentPage().getParameters().put('Segment',SegmentName);
        ApexPages.CurrentPage().getParameters().put('listtype',listtype);
        Test.startTest();
        ACE_User_Cust_Hierarchy_Controller_method();
        arw = new ACEReporting_RevMarg_WaterFall();
        arw.ExceptionReportCustList();
        System.assert(arw.lExceptionReportCustList.size() == 0);
        //arw.lExceptionReportCustList;
        Test.stopTest();
    }   
    }
    //Added by Lalit for S-399112 END
    static testMethod void TestACEReporting_RevMarg_WaterFall() 
    {
        initialVal();   
        Test.startTest();
        ACE_User_Cust_Hierarchy_Controller_method();
        arw = new ACEReporting_RevMarg_WaterFall();
        
        arw.Searchtype = 'Customer';
        arw.searchWord = '123' ;
    
        ACEReporting_RevMarg_WaterFall.changeTypeData cTypeData = new ACEReporting_RevMarg_WaterFall.changeTypeData();
        cTypeData.formatType = 'testFormatType';
        cTypeData.UrlType = 'testUrlType';
        cTypeData.dataType = 'testDataType';
             
        cTypeData.Proposed = 1.1;
        cTypeData.MargProp = 2.2;
        cTypeData.Executed = 3.3;
        cTypeData.MargExecuted = 4.4;
        cTypeData.AltSelected = 5.5;
        cTypeData.MargIncAlt = 6.6;
        cTypeData.TotMargInc = 7.7;
    
        ErosionType = 'Price';
        reportType = 'Vendavo';
        quarter = null;
        
        ApexPages.CurrentPage().getParameters().put('reportType',reportType);
        ApexPages.CurrentPage().getParameters().put('ErosionType',ErosionType);
        ApexPages.CurrentPage().getParameters().put('quarter',quarter);
        
        ACEReporting_RevMarg_WaterFall arw1 = new ACEReporting_RevMarg_WaterFall();
        
        Test.stopTest();

        
    }
    
    static testMethod void TestACEReporting_RevMarg_WaterFall_1() 
    {
        initialVal();   
        Test.startTest();
        ACE_User_Cust_Hierarchy_Controller_method();
        arw = new ACEReporting_RevMarg_WaterFall();
        
        arw.Searchtype = 'Customer';
        arw.searchWord = '123' ;
    
        ACEReporting_RevMarg_WaterFall.changeTypeData cTypeData = new ACEReporting_RevMarg_WaterFall.changeTypeData();
        cTypeData.formatType = 'testFormatType';
        cTypeData.UrlType = 'testUrlType';
        cTypeData.dataType = 'testDataType';
             
        cTypeData.Proposed = 1.1;
        cTypeData.MargProp = 2.2;
        cTypeData.Executed = 3.3;
        cTypeData.MargExecuted = 4.4;
        cTypeData.AltSelected = 5.5;
        cTypeData.MargIncAlt = 6.6;
        cTypeData.TotMargInc = 7.7;
    
        ErosionType = 'Pricee';
        reportType = 'Vendavo';
        quarter = null;
        
        ApexPages.CurrentPage().getParameters().put('reportType',reportType);
        ApexPages.CurrentPage().getParameters().put('ErosionType',ErosionType);
        ApexPages.CurrentPage().getParameters().put('quarter',quarter);
        
        ACEReporting_RevMarg_WaterFall arw1 = new ACEReporting_RevMarg_WaterFall();
        arw1.AccessLevel = 'General';
        arw1.VendSKUListReportData_1();
        Test.stopTest();

        
    }
    
    static testMethod void vendavoRep_searchBtnclick()
    {
    initialVal();
    ErosionType = 'Price';
    reportType = 'Vendavo';
    ApexPages.CurrentPage().getParameters().put('reportType',reportType);
    ApexPages.CurrentPage().getParameters().put('ErosionType',ErosionType);
   
    
    ACE_User_Cust_Hierarchy_Controller_method();
    ace1.hosted_catalog__c=false;
    upsert ace1;
    arw = new ACEReporting_RevMarg_WaterFall();
    arw.Searchtype = 'Customer';
    arw.searchWord = '12' ;
    arw.vendavoRep_searchBtnclick();
    
    ErosionType = 'Price';
    reportType = 'Vendavo';
    ApexPages.CurrentPage().getParameters().put('reportType',reportType);
    ApexPages.CurrentPage().getParameters().put('ErosionType',ErosionType);
    
    Test.startTest();
    ACEReporting_RevMarg_WaterFall arw1 = new ACEReporting_RevMarg_WaterFall();
    arw1.Searchtype = 'SKU';
    arw1.searchWordSKU = '12' ;
    arw1.vendavoRep_searchBtnclick();
    
    ErosionType = 'Price';
    reportType = 'Vendavo';
    ApexPages.CurrentPage().getParameters().put('reportType',reportType);
    ApexPages.CurrentPage().getParameters().put('ErosionType',ErosionType);
    
    ACEReporting_RevMarg_WaterFall arw2 = new ACEReporting_RevMarg_WaterFall();
    arw2.Searchtype = 'SKU1';
    arw2.searchWord = '12' ;
    arw2.vendavoRep_searchBtnclick();
    Test.stopTest();
    }
    
    
    static testMethod void loadNotificationData()
    {
    initialVal();   
    reportType = 'Notification';
    ApexPages.CurrentPage().getParameters().put('reportType',reportType);
    Test.startTest();
    ACE_User_Cust_Hierarchy_Controller_method();
    arw = new ACEReporting_RevMarg_WaterFall();
    arw.loadNotificationData();
    
    reportType = 'Response';
    ApexPages.CurrentPage().getParameters().put('reportType',reportType);

    ACEReporting_RevMarg_WaterFall arw1 = new ACEReporting_RevMarg_WaterFall();
    arw1.loadNotificationData();
    arw1.SearchRecords();
    Test.stopTest();
    }
    
    static testMethod void loadErosionDataSector()
    {
    reportType='ChangeType';
    User runAsUser = loadChangeTypeData_User();
    System.runAs(runAsUser)
    {
        initialVal();   
        Test.startTest();
        ACE_User_Cust_Hierarchy_Controller_method();
        arw = new ACEReporting_RevMarg_WaterFall();
        arw.loadErosionData();
        ACEReporting_RevMarg_WaterFall arw1 = new ACEReporting_RevMarg_WaterFall();
        arw1.SearchRecords();
        //start Ryan Marquardt - July 17, 2015 - S-335200 (code coverage)
        reportType = 'Vendor Cost Increase-Proposed';
        ApexPages.CurrentPage().getParameters().put('reportType',reportType);
        //end Ryan Marquardt - July 17, 2015 - S-335200 (code coverage)


        arw1.loadChangeTypeDataCustomerList();
        Test.stopTest();
    }   
    }
    
   /* static testMethod void loadErosionDataRegion()
    {
    User runAsUser = loadChangeTypeData_User();
    System.runAs(runAsUser)
    {
        initialVal();   
        reportType ='Summary by Region';//madhavi
        //SegmentName = null;     
        ErosionType = null;
        ApexPages.CurrentPage().getParameters().put('ErosionType',ErosionType);
        ApexPages.CurrentPage().getParameters().put('reportType',reportType);
        ApexPages.CurrentPage().getParameters().put('Segment',SegmentName);
        Test.startTest();
        ACE_User_Cust_Hierarchy_Controller_method();
        arw = new ACEReporting_RevMarg_WaterFall();
        arw.loadErosionData();
        Test.stopTest();
    }   
    }*/
    
    static testMethod void loadErosionDataByParticipation()
    {
    User runAsUser = loadChangeTypeData_User();
    System.runAs(runAsUser)
    {
        initialVal();   
        reportType ='Summary by Participation (Buying Group/GPO)';//madhavi
        //SegmentName = null;       
        ErosionType = null;
        ApexPages.CurrentPage().getParameters().put('ErosionType',ErosionType);
        ApexPages.CurrentPage().getParameters().put('reportType',reportType);
        ApexPages.CurrentPage().getParameters().put('Segment',SegmentName);
        Test.startTest();
        ACE_User_Cust_Hierarchy_Controller_method();
        arw = new ACEReporting_RevMarg_WaterFall();
        arw.loadErosionData();
        Test.stopTest();
    }   
    }
    
    static testMethod void loadErosionDataByIndustry()
    {
    User runAsUser = loadChangeTypeData_User();
    System.runAs(runAsUser)
    {
        initialVal();   
        reportType ='Summary by Industry/Vertical Market';//madhavi
        //SegmentName = null;       
        ErosionType = null;
        ApexPages.CurrentPage().getParameters().put('ErosionType',ErosionType);
        ApexPages.CurrentPage().getParameters().put('reportType',reportType);
        ApexPages.CurrentPage().getParameters().put('Segment',SegmentName);
        Test.startTest();
        ACE_User_Cust_Hierarchy_Controller_method();
        arw = new ACEReporting_RevMarg_WaterFall();
        arw.loadErosionData();
        Test.stopTest();
    }   
    }
    
    static testMethod void nextPage()
    {
    User runAsUser = loadChangeTypeData_User();
    System.runAs(runAsUser)
    {
        initialVal();   
        Test.startTest();
        ACE_User_Cust_Hierarchy_Controller_method();
        arw = new ACEReporting_RevMarg_WaterFall();
        arw.nextPage();
        Test.stopTest();
    }   
    }
    
    static testMethod void nextPageNotification()
    {
    User runAsUser = loadChangeTypeData_User();
    System.runAs(runAsUser)
    {
        initialVal();   
        reportType = 'Notification';
        ApexPages.CurrentPage().getParameters().put('reportType',reportType);
        Test.startTest();
        ACE_User_Cust_Hierarchy_Controller_method();
        arw = new ACEReporting_RevMarg_WaterFall();
        arw.nextPage();
        Test.stopTest();
    }   
    }
    
    static testMethod void nextPagePrivateSector()
    {
    User runAsUser = loadChangeTypeData_User();
    System.runAs(runAsUser)
    {
        initialVal();   
        reportType = 'Summary by Sector/Segment';//madhavi
        SegmentName = 'Private';
        ErosionType = 'Price';
        ApexPages.CurrentPage().getParameters().put('ErosionType',ErosionType);
        ApexPages.CurrentPage().getParameters().put('reportType',reportType);
        ApexPages.CurrentPage().getParameters().put('Segment',SegmentName);
        Test.startTest();
        ACE_User_Cust_Hierarchy_Controller_method();
        arw = new ACEReporting_RevMarg_WaterFall();
        arw.nextPage();
        Test.stopTest();
    }   
    }
    
    static testMethod void nextPageRegion()
    {
    User runAsUser = loadChangeTypeData_User();
    System.runAs(runAsUser)
    {
        initialVal();   
        reportType ='Summary by Region';//madhavi
        SegmentName = null;     
        ErosionType = null;
        ApexPages.CurrentPage().getParameters().put('ErosionType',ErosionType);
        ApexPages.CurrentPage().getParameters().put('reportType',reportType);
        ApexPages.CurrentPage().getParameters().put('Segment',SegmentName);
        Test.startTest();
        ACE_User_Cust_Hierarchy_Controller_method();
        arw = new ACEReporting_RevMarg_WaterFall();
        arw.nextPage();
        Test.stopTest();
    }   
    }
    
    static testMethod void nextPageByParticipation()
    {
    User runAsUser = loadChangeTypeData_User();
    System.runAs(runAsUser)
    {
        initialVal();   
        reportType ='Summary by Participation (Buying Group/GPO)';//madhavi
        SegmentName = null;     
        ErosionType = null;
        ApexPages.CurrentPage().getParameters().put('ErosionType',ErosionType);
        ApexPages.CurrentPage().getParameters().put('reportType',reportType);
        ApexPages.CurrentPage().getParameters().put('Segment',SegmentName);
        Test.startTest();
        ACE_User_Cust_Hierarchy_Controller_method();
        arw = new ACEReporting_RevMarg_WaterFall();
        arw.nextPage();
        Test.stopTest();
    }   
    }
    
    static testMethod void nextPageByIndustry()
    {
    User runAsUser = loadChangeTypeData_User();
    System.runAs(runAsUser)
    {
        initialVal();   
        reportType ='Summary by Industry/Vertical Market';//madhavi
        SegmentName = null;     
        ErosionType = null;
        ApexPages.CurrentPage().getParameters().put('ErosionType',ErosionType);
        ApexPages.CurrentPage().getParameters().put('reportType',reportType);
        ApexPages.CurrentPage().getParameters().put('Segment',SegmentName);
        Test.startTest();
        ACE_User_Cust_Hierarchy_Controller_method();
        arw = new ACEReporting_RevMarg_WaterFall();
        arw.nextPage();
        Test.stopTest();
    }   
    }
    
    
    static testMethod void nextPageCustomerNotReceivingFullIncrease()
    {
    User runAsUser = loadChangeTypeData_User();
    System.runAs(runAsUser)
    {
        initialVal();   
        reportType = 'Customer Not Receiving Full Increase';
        SegmentName = null;
        ErosionType = null;
        ApexPages.CurrentPage().getParameters().put('ErosionType',ErosionType);
        ApexPages.CurrentPage().getParameters().put('reportType',reportType);
        ApexPages.CurrentPage().getParameters().put('Segment',SegmentName);
        Test.startTest();
        ACE_User_Cust_Hierarchy_Controller_method();
        arw = new ACEReporting_RevMarg_WaterFall();
        arw.SearchRecords();
        arw.nextPage();
        Test.stopTest();
    }   
    }

    static testMethod void nextPageRemediation_Auto_Routes()
    {
    User runAsUser = loadChangeTypeData_User();
    System.runAs(runAsUser)
    {
        initialVal();   
        reportType = 'Remediation';
        SegmentName = null;
        listType = 'Pre-Quals';//Auto-Routes';
        ErosionType = null;
        ApexPages.CurrentPage().getParameters().put('ErosionType',ErosionType);
        ApexPages.CurrentPage().getParameters().put('reportType',reportType);       
        ApexPages.CurrentPage().getParameters().put('Segment',SegmentName);
        ApexPages.CurrentPage().getParameters().put('listtype',listtype);
        Test.startTest();
        ACE_User_Cust_Hierarchy_Controller_method();
        arw = new ACEReporting_RevMarg_WaterFall();
        arw.SearchRecords();
        arw.nextPage();

//start Ryan Marquardt - July 17, 2015 - S-335200 (code coverage)
/*
listType = 'Completed-Auto-Routes';
        ErosionType = null;
        ApexPages.CurrentPage().getParameters().put('ErosionType',ErosionType);
        ApexPages.CurrentPage().getParameters().put('reportType',reportType);       
        ApexPages.CurrentPage().getParameters().put('Segment',SegmentName);
        ApexPages.CurrentPage().getParameters().put('listtype',listtype);
        //Test.startTest();
        ACE_User_Cust_Hierarchy_Controller_method();
        arw = new ACEReporting_RevMarg_WaterFall();
        arw.SearchRecords();
        arw.nextPage();

listType = 'Sales-Support';
        ErosionType = null;
        ApexPages.CurrentPage().getParameters().put('ErosionType',ErosionType);
        ApexPages.CurrentPage().getParameters().put('reportType',reportType);       
        ApexPages.CurrentPage().getParameters().put('Segment',SegmentName);
        ApexPages.CurrentPage().getParameters().put('listtype',listtype);
        //Test.startTest();
        ACE_User_Cust_Hierarchy_Controller_method();
        arw = new ACEReporting_RevMarg_WaterFall();
        arw.SearchRecords();
        arw.nextPage();
*/
//ryanstop

        Test.stopTest();
    }   
    }
    
    static testMethod void nextPageProcessProgress_PipeLine()
    {
    User runAsUser = loadChangeTypeData_User();
    System.runAs(runAsUser)
    {
        initialVal();   
        reportType = 'Process Progress/PipeLine';
        SegmentName = null;
        ErosionType = null;
        listType = 'Customers with Increases';
        ApexPages.CurrentPage().getParameters().put('ErosionType',ErosionType);
        ApexPages.CurrentPage().getParameters().put('reportType',reportType);       
        ApexPages.CurrentPage().getParameters().put('Segment',SegmentName);
        ApexPages.CurrentPage().getParameters().put('listtype',listtype);
        Test.startTest();
        ACE_User_Cust_Hierarchy_Controller_method();
        arw = new ACEReporting_RevMarg_WaterFall();
        arw.SearchRecords();
        arw.nextPage();
        Test.stopTest();
    }   
    }
    
    static testMethod void nextPageErosionTypePrice()
    {
    User runAsUser = loadChangeTypeData_User();
    System.runAs(runAsUser)
    {
        initialVal();   
        reportType = 'Summary by Region';//madhavi
        SegmentName = null;
        ErosionType = 'Price';
        ApexPages.CurrentPage().getParameters().put('ErosionType',ErosionType);
        ApexPages.CurrentPage().getParameters().put('reportType',reportType);       
        ApexPages.CurrentPage().getParameters().put('Segment',SegmentName);
        Test.startTest();
        ACE_User_Cust_Hierarchy_Controller_method();
        ACEReporting_RevMarg_WaterFall arw1 = new ACEReporting_RevMarg_WaterFall();
        arw1.nextPage();
        
        reportType = 'Summary by Industry/Vertical Market';
        SegmentName = null;
        ErosionType = 'Price';
        ApexPages.CurrentPage().getParameters().put('ErosionType',ErosionType);
        ApexPages.CurrentPage().getParameters().put('reportType',reportType);       
        ApexPages.CurrentPage().getParameters().put('Segment',SegmentName);
        ACEReporting_RevMarg_WaterFall arw2 = new ACEReporting_RevMarg_WaterFall();
        arw2.nextPage();
        
        reportType = 'Summary by Participation (Buying Group/GPO)';//madhavi
        SegmentName = null;
        ErosionType = 'Price';
        ApexPages.CurrentPage().getParameters().put('ErosionType',ErosionType);
        ApexPages.CurrentPage().getParameters().put('reportType',reportType);       
        ApexPages.CurrentPage().getParameters().put('Segment',SegmentName);
        ACEReporting_RevMarg_WaterFall arw3 = new ACEReporting_RevMarg_WaterFall();
        arw3.nextPage();
                
        Test.stopTest();
    }   
    }
        
    
    static testMethod void prevPage()
    {
    User runAsUser = loadChangeTypeData_User();
    System.runAs(runAsUser)
    {
        initialVal();   
        Test.startTest();
        ACE_User_Cust_Hierarchy_Controller_method();
        arw = new ACEReporting_RevMarg_WaterFall();
        arw.counter=25;
        arw.prevPage();
        Test.stopTest();
    }   
    }
    
    static testMethod void prevPageNotification()
    {
    User runAsUser = loadChangeTypeData_User();
    System.runAs(runAsUser)
    {
        initialVal();   
        reportType = 'Notification';
        ApexPages.CurrentPage().getParameters().put('reportType',reportType);
        Test.startTest();
        ACE_User_Cust_Hierarchy_Controller_method();
        arw = new ACEReporting_RevMarg_WaterFall();
        arw.counter=25;
        arw.prevPage();
        Test.stopTest();
    }   
    }

    //start Ryan Marquardt - July 17, 2015 - S-335200 (code coverage)
    static testMethod void prevPageNotification2()
    {
    User runAsUser = loadChangeTypeData_User();
    System.runAs(runAsUser)
    {
        initialVal();   
        reportType = 'Vendavo';
        ApexPages.CurrentPage().getParameters().put('reportType',reportType);
        Test.startTest();
        ACE_User_Cust_Hierarchy_Controller_method();
        arw = new ACEReporting_RevMarg_WaterFall();
        arw.counter=25;
       // arw.prevPage();
        Test.stopTest();
    }   
    }
    //ryanstop
    
    static testMethod void prevPagePrivateSector()
    {
    User runAsUser = loadChangeTypeData_User();
    System.runAs(runAsUser)
    {
        initialVal();   
        reportType = 'Summary by Sector/Segment';//madhavi
        SegmentName = 'Private';
        ErosionType = 'Price';
        ApexPages.CurrentPage().getParameters().put('ErosionType',ErosionType);
        ApexPages.CurrentPage().getParameters().put('reportType',reportType);
        ApexPages.CurrentPage().getParameters().put('Segment',SegmentName);
        Test.startTest();
        ACE_User_Cust_Hierarchy_Controller_method();
        arw = new ACEReporting_RevMarg_WaterFall();
        arw.counter=25;
        arw.prevPage();
        Test.stopTest();
    }   
    }
    
    static testMethod void prevPageRegion()
    {
    User runAsUser = loadChangeTypeData_User();
    System.runAs(runAsUser)
    {
        initialVal();   
        reportType ='Summary by Region';//madhavi
        SegmentName = null;     
        ErosionType = null;
        ApexPages.CurrentPage().getParameters().put('ErosionType',ErosionType);
        ApexPages.CurrentPage().getParameters().put('reportType',reportType);
        ApexPages.CurrentPage().getParameters().put('Segment',SegmentName);
        Test.startTest();
        ACE_User_Cust_Hierarchy_Controller_method();
        arw = new ACEReporting_RevMarg_WaterFall();
        arw.counter=25;
        arw.prevPage();
        Test.stopTest();
    }   
    }
    
    static testMethod void prevPageByParticipation()
    {
    User runAsUser = loadChangeTypeData_User();
    System.runAs(runAsUser)
    {
        initialVal();   
        reportType ='Summary by Participation (Buying Group/GPO)';//madhavi
        SegmentName = null;     
        ErosionType = null;
        ApexPages.CurrentPage().getParameters().put('ErosionType',ErosionType);
        ApexPages.CurrentPage().getParameters().put('reportType',reportType);
        ApexPages.CurrentPage().getParameters().put('Segment',SegmentName);
        Test.startTest();
        ACE_User_Cust_Hierarchy_Controller_method();
        arw = new ACEReporting_RevMarg_WaterFall();
        arw.counter=25;
        arw.prevPage();
        Test.stopTest();
    }   
    }
    
    static testMethod void prevPageByIndustry()
    {
    User runAsUser = loadChangeTypeData_User();
    System.runAs(runAsUser)
    {
        initialVal();   
        reportType ='Summary by Industry/Vertical Market';//madhavi
        SegmentName = null;     
        ErosionType = null;
        ApexPages.CurrentPage().getParameters().put('ErosionType',ErosionType);
        ApexPages.CurrentPage().getParameters().put('reportType',reportType);
        ApexPages.CurrentPage().getParameters().put('Segment',SegmentName);
        Test.startTest();
        ACE_User_Cust_Hierarchy_Controller_method();
        arw = new ACEReporting_RevMarg_WaterFall();
        arw.counter=25;
        arw.prevPage();
        Test.stopTest();
    }   
    }
    
    
    static testMethod void prevPageCustomerNotReceivingFullIncrease()
    {
    User runAsUser = loadChangeTypeData_User();
    System.runAs(runAsUser)
    {
        initialVal();   
        reportType = 'Customer Not Receiving Full Increase';
        SegmentName = null;
        ErosionType = null;
        ApexPages.CurrentPage().getParameters().put('ErosionType',ErosionType);
        ApexPages.CurrentPage().getParameters().put('reportType',reportType);
        ApexPages.CurrentPage().getParameters().put('Segment',SegmentName);
        Test.startTest();
        ACE_User_Cust_Hierarchy_Controller_method();
        arw = new ACEReporting_RevMarg_WaterFall();
        arw.counter=25;
        arw.prevPage();
        Test.stopTest();
    }   
    }

    static testMethod void prevPageRemediation_Auto_Routes()
    {
    User runAsUser = loadChangeTypeData_User();
    System.runAs(runAsUser)
    {
        initialVal();   
        reportType = 'Remediation';
        SegmentName = null;
        listType = 'Pre-Quals';//Auto-Routes';
        ErosionType = null;
        ApexPages.CurrentPage().getParameters().put('ErosionType',ErosionType);
        ApexPages.CurrentPage().getParameters().put('reportType',reportType);       
        ApexPages.CurrentPage().getParameters().put('Segment',SegmentName);
        ApexPages.CurrentPage().getParameters().put('listtype',listtype);
        Test.startTest();
        ACE_User_Cust_Hierarchy_Controller_method();
        arw = new ACEReporting_RevMarg_WaterFall();
        arw.counter=25;
        arw.prevPage();
        Test.stopTest();
    }   
    }
    
    static testMethod void prevPageProcessProgress_PipeLine()
    {
    User runAsUser = loadChangeTypeData_User();
    System.runAs(runAsUser)
    {
        initialVal();   
        reportType = 'Process Progress/PipeLine';
        SegmentName = null;
        ErosionType = null;
        listType = 'Customers with Increases';
        ApexPages.CurrentPage().getParameters().put('ErosionType',ErosionType);
        ApexPages.CurrentPage().getParameters().put('reportType',reportType);       
        ApexPages.CurrentPage().getParameters().put('Segment',SegmentName);
        ApexPages.CurrentPage().getParameters().put('listtype',listtype);
        Test.startTest();
        ACE_User_Cust_Hierarchy_Controller_method();
        arw = new ACEReporting_RevMarg_WaterFall();
        arw.counter=25;
        arw.prevPage();
        Test.stopTest();
    }   
    }
    
    static testMethod void prevPageErosionTypePrice()
    {
    User runAsUser = loadChangeTypeData_User();
    System.runAs(runAsUser)
    {
        initialVal();   
        reportType = 'Summary by Region';//madhavi
        SegmentName = null;
        ErosionType = 'Price';
        ApexPages.CurrentPage().getParameters().put('ErosionType',ErosionType);
        ApexPages.CurrentPage().getParameters().put('reportType',reportType);       
        ApexPages.CurrentPage().getParameters().put('Segment',SegmentName);
        Test.startTest();
        ACE_User_Cust_Hierarchy_Controller_method();
        ACEReporting_RevMarg_WaterFall arw1 = new ACEReporting_RevMarg_WaterFall();
        arw1.SearchRecords();
        arw1.counter=25;
        arw1.prevPage();
        
        reportType = 'Summary by Industry/Vertical Market';//madhavi
        SegmentName = null;
        ErosionType = 'Price';
        ApexPages.CurrentPage().getParameters().put('ErosionType',ErosionType);
        ApexPages.CurrentPage().getParameters().put('reportType',reportType);       
        ApexPages.CurrentPage().getParameters().put('Segment',SegmentName);
        ACEReporting_RevMarg_WaterFall arw2 = new ACEReporting_RevMarg_WaterFall();
        arw2.counter=25;
        arw2.prevPage();
        arw2.SearchRecords();
        
        reportType = 'Summary by Participation (Buying Group/GPO)';//madhavi
        SegmentName = null;
        ErosionType = 'Price';
        ApexPages.CurrentPage().getParameters().put('ErosionType',ErosionType);
        ApexPages.CurrentPage().getParameters().put('reportType',reportType);       
        ApexPages.CurrentPage().getParameters().put('Segment',SegmentName);
        ACEReporting_RevMarg_WaterFall arw3 = new ACEReporting_RevMarg_WaterFall();
        arw3.counter=25;
        arw3.prevPage();
        arw3.SearchRecords();        
        Test.stopTest();
    }   
    }
    
    
        static testMethod void sortCust()
    {
    initialVal();   
    Test.startTest();
    ACE_User_Cust_Hierarchy_Controller_method();
    arw = new ACEReporting_RevMarg_WaterFall();
    arw.sortCust();
    Test.stopTest();
    }
    
    static testMethod void sortCustResponse()
    {
    initialVal();   
    reportType = 'Response';
    ApexPages.CurrentPage().getParameters().put('reportType',reportType);
    Test.startTest();
    ACE_User_Cust_Hierarchy_Controller_method();
    arw = new ACEReporting_RevMarg_WaterFall();
    arw.sortCust();
    Test.stopTest();
    }
    
    static testMethod void sortCustPrivateSector()
    {
    initialVal();   
    reportType = 'Summary by Sector/Segment';//madhavi
    SegmentName = 'Private';        
    ErosionType = '';
    ApexPages.CurrentPage().getParameters().put('reportType',reportType);
    ApexPages.CurrentPage().getParameters().put('Segment',SegmentName);
    ApexPages.CurrentPage().getParameters().put('ErosionType',ErosionType);
    Test.startTest();
    ACE_User_Cust_Hierarchy_Controller_method();
    arw = new ACEReporting_RevMarg_WaterFall();
    arw.sortCust();
    Test.stopTest();
    }
    
    static testMethod void sortCustRegion()
    {
    initialVal();   
    reportType ='Summary by Region';//madhavi
    SegmentName = null;     
    ApexPages.CurrentPage().getParameters().put('reportType',reportType);
    ApexPages.CurrentPage().getParameters().put('Segment',SegmentName);
    Test.startTest();
    ACE_User_Cust_Hierarchy_Controller_method();
    arw = new ACEReporting_RevMarg_WaterFall();
    arw.sortCust();
    Test.stopTest();
    }
    
    static testMethod void sortCustByParticipation()
    {
    initialVal();   
    reportType = 'Summary by Participation (Buying Group/GPO)';//madhavi
    SegmentName = null;
    ApexPages.CurrentPage().getParameters().put('reportType',reportType);
    ApexPages.CurrentPage().getParameters().put('Segment',SegmentName);
    Test.startTest();
    ACE_User_Cust_Hierarchy_Controller_method();
    arw = new ACEReporting_RevMarg_WaterFall();
    arw.sortCust();
    Test.stopTest();
    }
    
    static testMethod void sortCustByIndustry()
    {
    initialVal();   
    reportType = 'Summary by Industry/Vertical Market';
    SegmentName = null;
    ApexPages.CurrentPage().getParameters().put('reportType',reportType);       
    ApexPages.CurrentPage().getParameters().put('Segment',SegmentName);
    Test.startTest();
    ACE_User_Cust_Hierarchy_Controller_method();
    arw = new ACEReporting_RevMarg_WaterFall();
    arw.sortCust();
    Test.stopTest();
    }  
    
    static testMethod void sortCustPrice()
    {
    initialVal();   
    Test.startTest();
    ACE_User_Cust_Hierarchy_Controller_method();
    arw = new ACEReporting_RevMarg_WaterFall();
    arw.sortCustPrice();
    Test.stopTest();
    }
    
  
    static testMethod void loadChangeTypeData()
    {
    User runAsUser = loadChangeTypeData_User();
    System.runAs(runAsUser)
    {
    initialVal();
    Test.startTest();
    ACE_User_Cust_Hierarchy_Controller_method();
    arw = new ACEReporting_RevMarg_WaterFall();
    arw.loadChangeTypeData();
    Test.stopTest();
    }
    }
    
    static testMethod void loadData()
    {
    User runAsUser = loadChangeTypeData_User();
    System.runAs(runAsUser)
    {
        initialVal();   
        Test.startTest();
        ACE_User_Cust_Hierarchy_Controller_method();
        arw = new ACEReporting_RevMarg_WaterFall();
        arw.loadData();
        Test.stopTest();
    }
    }
    
    static testMethod void loadDataPrivateSector()
    {
    User runAsUser = loadChangeTypeData_User();
    System.runAs(runAsUser)
    {
        initialVal();   
        reportType = 'Summary by Sector/Segment';//madhavi;
        SegmentName = 'Private';
        ApexPages.CurrentPage().getParameters().put('reportType',reportType);
        ApexPages.CurrentPage().getParameters().put('Segment',SegmentName);
        Test.startTest();
        ACE_User_Cust_Hierarchy_Controller_method();
        arw = new ACEReporting_RevMarg_WaterFall();
        arw.loadData();
        Test.stopTest();
    }
    }
    
    static testMethod void loadDataSectorWithNull()
    {
    User runAsUser = loadChangeTypeData_User();
    System.runAs(runAsUser)
    {
        initialVal();   
        reportType = 'Summary by Sector/Segment';//madhavi
        SegmentName = null;
        ApexPages.CurrentPage().getParameters().put('reportType',reportType);
        ApexPages.CurrentPage().getParameters().put('Segment',SegmentName);
        Test.startTest();
        ACE_User_Cust_Hierarchy_Controller_method();
        arw = new ACEReporting_RevMarg_WaterFall();
        arw.loadData();
        Test.stopTest();
    }
    }  
    
  
    
   /* static testMethod void loadDataRegion()
    {
    User runAsUser = loadChangeTypeData_User();
    System.runAs(runAsUser)
    {
        initialVal();   
        reportType ='Summary by Region';//madhavi
        SegmentName = null;     
        ApexPages.CurrentPage().getParameters().put('reportType',reportType);
        ApexPages.CurrentPage().getParameters().put('Segment',SegmentName);
        Test.startTest();
        ACE_User_Cust_Hierarchy_Controller_method();
        arw = new ACEReporting_RevMarg_WaterFall();
        arw.loadData();
        Test.stopTest();
    }
    }*/
       
    static testMethod void loadDataByParticipation()
    {
    User runAsUser = loadChangeTypeData_User();
    System.runAs(runAsUser)
    {
        initialVal();   
        reportType = 'Summary by Participation (Buying Group/GPO)';//madhavi
        SegmentName = null;
        ApexPages.CurrentPage().getParameters().put('reportType',reportType);
        ApexPages.CurrentPage().getParameters().put('Segment',SegmentName);
        Test.startTest();
        ACE_User_Cust_Hierarchy_Controller_method();
        arw = new ACEReporting_RevMarg_WaterFall();
        arw.loadData();
        Test.stopTest();
    }
    }  
    
    static testMethod void loadDataByIndustry()
    {
    User runAsUser = loadChangeTypeData_User();
    System.runAs(runAsUser)
    {
        initialVal();   
        reportType = 'Summary by Industry/Vertical Market';//madhavi
        SegmentName = null;
        ApexPages.CurrentPage().getParameters().put('reportType',reportType);       
        ApexPages.CurrentPage().getParameters().put('Segment',SegmentName);
        Test.startTest();
        ACE_User_Cust_Hierarchy_Controller_method();
        arw = new ACEReporting_RevMarg_WaterFall();
        arw.loadData();
        Test.stopTest();
    }
    }
    
    static testMethod void initialValOverviewReportData1()
    {
        
        ACE_Batches__c aceBatch = new ACE_Batches__c();
        aceBatch.Name = 'Q4-2014';
        aceBatch.Batch__c = 'Q4-2014';
        
        insert aceBatch;

        reportType = 'Summary';//madhavi
        SegmentName = 'Public';
        SegmentType = '';
        ReportName = 'Summary';
        ErosionType = 'Date';
        quarter = 'Q4-2014';
        ColumnVal = 'callme';
        rowname = 'Customers with Increases';
        listType = 'Initial';
        
        

        Test.setCurrentPage(Page.ACEReportHomePage);
        ApexPages.CurrentPage().getParameters().put('reportType',reportType);
        ApexPages.CurrentPage().getParameters().put('Segment',SegmentName);
        ApexPages.CurrentPage().getParameters().put('SegmentType',SegmentType);
        ApexPages.CurrentPage().getParameters().put('Val',ReportName);
        ApexPages.CurrentPage().getParameters().put('ErosionType',ErosionType);
        ApexPages.CurrentPage().getParameters().put('quarter',quarter);
        ApexPages.CurrentPage().getParameters().put('Column',ColumnVal);
        ApexPages.CurrentPage().getParameters().put('rowName',rowName);
        ApexPages.CurrentPage().getParameters().put('listtype',listtype);
        
        
        system.debug('SegmentName:'+SegmentName+' reportType:'+reportType);
    }
    
     static testMethod void initialValOverviewReportData2()
    {
        
        ACE_Batches__c aceBatch = new ACE_Batches__c();
        aceBatch.Name = 'Q4-2014';
        aceBatch.Batch__c = 'Q4-2014';
        
        insert aceBatch;

        reportType = 'Summary';//madhavi
        SegmentName = 'Public';
        SegmentType = '';
        ReportName = 'Summary';
        ErosionType = 'Date';
        quarter = 'Q4-2014';
        ColumnVal = 'callme';
        rowname = 'Revenue Pass Through (Cost Increase)';
        listType = 'Initial';
        

        Test.setCurrentPage(Page.ACEReportHomePage);
        ApexPages.CurrentPage().getParameters().put('reportType',reportType);
        ApexPages.CurrentPage().getParameters().put('Segment',SegmentName);
        ApexPages.CurrentPage().getParameters().put('SegmentType',SegmentType);
        ApexPages.CurrentPage().getParameters().put('Val',ReportName);
        ApexPages.CurrentPage().getParameters().put('ErosionType',ErosionType);
        ApexPages.CurrentPage().getParameters().put('quarter',quarter);
        ApexPages.CurrentPage().getParameters().put('Column',ColumnVal);
        ApexPages.CurrentPage().getParameters().put('rowName',rowName);
        ApexPages.CurrentPage().getParameters().put('listtype',listtype);
        
        system.debug('SegmentName:'+SegmentName+' reportType:'+reportType);
    }
    
        static testMethod void initialValOverviewReportData3()
    {
        
        ACE_Batches__c aceBatch = new ACE_Batches__c();
        aceBatch.Name = 'Q4-2014';
        aceBatch.Batch__c = 'Q4-2014';
        
        insert aceBatch;

        reportType = 'Summary';//madhavi
        SegmentName = 'Public';
        SegmentType = '';
        ReportName = 'Summary';
        ErosionType = 'Date';
        quarter = 'Q4-2014';
        ColumnVal = 'callme';
        rowname = 'Revenue Pass Through (Margin Play)';
        listType = 'Initial';
        

        Test.setCurrentPage(Page.ACEReportHomePage);
        ApexPages.CurrentPage().getParameters().put('reportType',reportType);
        ApexPages.CurrentPage().getParameters().put('Segment',SegmentName);
        ApexPages.CurrentPage().getParameters().put('SegmentType',SegmentType);
        ApexPages.CurrentPage().getParameters().put('Val',ReportName);
        ApexPages.CurrentPage().getParameters().put('ErosionType',ErosionType);
        ApexPages.CurrentPage().getParameters().put('quarter',quarter);
        ApexPages.CurrentPage().getParameters().put('Column',ColumnVal);
        ApexPages.CurrentPage().getParameters().put('rowName',rowName);
        ApexPages.CurrentPage().getParameters().put('listtype',listtype);
        
        system.debug('SegmentName:'+SegmentName+' reportType:'+reportType);
    }
    
    static testMethod void initialValOverviewReportData4()
    {
        
        ACE_Batches__c aceBatch = new ACE_Batches__c();
        aceBatch.Name = 'Q4-2014';
        aceBatch.Batch__c = 'Q4-2014';
        
        insert aceBatch;

        reportType = 'Summary';//madhavi
        SegmentName = 'Public';
        SegmentType = '';
        ReportName = 'Summary';
        ErosionType = 'Date';
        quarter = 'Q4-2014';
        ColumnVal = 'callme';
        rowname = '100PercentPricePassThru (Cost Increase)';
        listType = 'Initial';
        

        Test.setCurrentPage(Page.ACEReportHomePage);
        ApexPages.CurrentPage().getParameters().put('reportType',reportType);
        ApexPages.CurrentPage().getParameters().put('Segment',SegmentName);
        ApexPages.CurrentPage().getParameters().put('SegmentType',SegmentType);
        ApexPages.CurrentPage().getParameters().put('Val',ReportName);
        ApexPages.CurrentPage().getParameters().put('ErosionType',ErosionType);
        ApexPages.CurrentPage().getParameters().put('quarter',quarter);
        ApexPages.CurrentPage().getParameters().put('Column',ColumnVal);
        ApexPages.CurrentPage().getParameters().put('rowName',rowName);
        ApexPages.CurrentPage().getParameters().put('listtype',listtype);
        
        system.debug('SegmentName:'+SegmentName+' reportType:'+reportType);
    }
    
    static testMethod void initialValOverviewReportData5()
    {
        
        ACE_Batches__c aceBatch = new ACE_Batches__c();
        aceBatch.Name = 'Q4-2014';
        aceBatch.Batch__c = 'Q4-2014';
        
        insert aceBatch;

        reportType = 'Summary';//madhavi
        SegmentName = 'Public';
        SegmentType = '';
        ReportName = 'Summary';
        ErosionType = 'Date';
        quarter = 'Q4-2014';
        ColumnVal = 'callme';
        rowname = '100PercentPricePassThru (Margin Play)';
        listType = 'Initial';
        

        Test.setCurrentPage(Page.ACEReportHomePage);
        ApexPages.CurrentPage().getParameters().put('reportType',reportType);
        ApexPages.CurrentPage().getParameters().put('Segment',SegmentName);
        ApexPages.CurrentPage().getParameters().put('SegmentType',SegmentType);
        ApexPages.CurrentPage().getParameters().put('Val',ReportName);
        ApexPages.CurrentPage().getParameters().put('ErosionType',ErosionType);
        ApexPages.CurrentPage().getParameters().put('quarter',quarter);
        ApexPages.CurrentPage().getParameters().put('Column',ColumnVal);
        ApexPages.CurrentPage().getParameters().put('rowName',rowName);
        ApexPages.CurrentPage().getParameters().put('listtype',listtype);
        
        system.debug('SegmentName:'+SegmentName+' reportType:'+reportType);
    }
    
    static testMethod void initialValOverviewReportData6()
    {
        
        ACE_Batches__c aceBatch = new ACE_Batches__c();
        aceBatch.Name = 'Q4-2014';
        aceBatch.Batch__c = 'Q4-2014';
        
        insert aceBatch;

        reportType = 'Summary';//madhavi
        SegmentName = 'Public';
        SegmentType = '';
        ReportName = 'Summary';
        ErosionType = 'Date';
        quarter = 'Q4-2014';
        ColumnVal = 'callme';
        rowname = '100PercentTimePassThru';
        listType = 'Initial';
        

        Test.setCurrentPage(Page.ACEReportHomePage);
        ApexPages.CurrentPage().getParameters().put('reportType',reportType);
        ApexPages.CurrentPage().getParameters().put('Segment',SegmentName);
        ApexPages.CurrentPage().getParameters().put('SegmentType',SegmentType);
        ApexPages.CurrentPage().getParameters().put('Val',ReportName);
        ApexPages.CurrentPage().getParameters().put('ErosionType',ErosionType);
        ApexPages.CurrentPage().getParameters().put('quarter',quarter);
        ApexPages.CurrentPage().getParameters().put('Column',ColumnVal);
        ApexPages.CurrentPage().getParameters().put('rowName',rowName);
        ApexPages.CurrentPage().getParameters().put('listtype',listtype);
        
        system.debug('SegmentName:'+SegmentName+' reportType:'+reportType);
    }
    
    static testMethod void initialValOverviewReportData7()
    {
        
        ACE_Batches__c aceBatch = new ACE_Batches__c();
        aceBatch.Name = 'Q4-2014';
        aceBatch.Batch__c = 'Q4-2014';
        
        insert aceBatch;

        reportType = 'Summary';//madhavi
        SegmentName = 'Public';
        SegmentType = '';
        ReportName = 'Summary';
        ErosionType = 'Date';
        quarter = 'Q4-2014';
        ColumnVal = 'callme';
        rowname = 'Customers with Increases';
        listType = 'ErosionDuetoContractTerms';
        

        Test.setCurrentPage(Page.ACEReportHomePage);
        ApexPages.CurrentPage().getParameters().put('reportType',reportType);
        ApexPages.CurrentPage().getParameters().put('Segment',SegmentName);
        ApexPages.CurrentPage().getParameters().put('SegmentType',SegmentType);
        ApexPages.CurrentPage().getParameters().put('Val',ReportName);
        ApexPages.CurrentPage().getParameters().put('ErosionType',ErosionType);
        ApexPages.CurrentPage().getParameters().put('quarter',quarter);
        ApexPages.CurrentPage().getParameters().put('Column',ColumnVal);
        ApexPages.CurrentPage().getParameters().put('rowName',rowName);
        ApexPages.CurrentPage().getParameters().put('listtype',listtype);
        
        system.debug('SegmentName:'+SegmentName+' reportType:'+reportType);
    }
    
        static testMethod void initialValOverviewReportData8()
    {
        
        ACE_Batches__c aceBatch = new ACE_Batches__c();
        aceBatch.Name = 'Q4-2014';
        aceBatch.Batch__c = 'Q4-2014';
        
        insert aceBatch;

        reportType = 'Summary';//madhavi
        SegmentName = 'Public';
        SegmentType = '';
        ReportName = 'Summary';
        ErosionType = 'Date';
        quarter = 'Q4-2014';
        ColumnVal = 'callme';
        rowname = 'Revenue Pass Through (Cost Increase)';
        listType = 'ErosionDuetoContractTerms';
        

        Test.setCurrentPage(Page.ACEReportHomePage);
        ApexPages.CurrentPage().getParameters().put('reportType',reportType);
        ApexPages.CurrentPage().getParameters().put('Segment',SegmentName);
        ApexPages.CurrentPage().getParameters().put('SegmentType',SegmentType);
        ApexPages.CurrentPage().getParameters().put('Val',ReportName);
        ApexPages.CurrentPage().getParameters().put('ErosionType',ErosionType);
        ApexPages.CurrentPage().getParameters().put('quarter',quarter);
        ApexPages.CurrentPage().getParameters().put('Column',ColumnVal);
        ApexPages.CurrentPage().getParameters().put('rowName',rowName);
        ApexPages.CurrentPage().getParameters().put('listtype',listtype);
        
        system.debug('SegmentName:'+SegmentName+' reportType:'+reportType);
    }
    
        static testMethod void initialValOverviewReportData9()
    {
        
        ACE_Batches__c aceBatch = new ACE_Batches__c();
        aceBatch.Name = 'Q4-2014';
        aceBatch.Batch__c = 'Q4-2014';
        
        insert aceBatch;

        reportType = 'Summary';//madhavi
        SegmentName = 'Public';
        SegmentType = '';
        ReportName = 'Summary';
        ErosionType = 'Date';
        quarter = 'Q4-2014';
        ColumnVal = 'callme';
        rowname = 'Revenue Pass Through (Margin Play)';
        listType = 'ErosionDuetoContractTerms';
        

        Test.setCurrentPage(Page.ACEReportHomePage);
        ApexPages.CurrentPage().getParameters().put('reportType',reportType);
        ApexPages.CurrentPage().getParameters().put('Segment',SegmentName);
        ApexPages.CurrentPage().getParameters().put('SegmentType',SegmentType);
        ApexPages.CurrentPage().getParameters().put('Val',ReportName);
        ApexPages.CurrentPage().getParameters().put('ErosionType',ErosionType);
        ApexPages.CurrentPage().getParameters().put('quarter',quarter);
        ApexPages.CurrentPage().getParameters().put('Column',ColumnVal);
        ApexPages.CurrentPage().getParameters().put('rowName',rowName);
        ApexPages.CurrentPage().getParameters().put('listtype',listtype);
        
        system.debug('SegmentName:'+SegmentName+' reportType:'+reportType);
    }
    
    static testMethod void initialValOverviewReportData10()
    {
        
        ACE_Batches__c aceBatch = new ACE_Batches__c();
        aceBatch.Name = 'Q4-2014';
        aceBatch.Batch__c = 'Q4-2014';
        
        insert aceBatch;

        reportType = 'Summary';//madhavi
        SegmentName = 'Public';
        SegmentType = '';
        ReportName = 'Summary';
        ErosionType = 'Date';
        quarter = 'Q4-2014';
        ColumnVal = 'callme';
        rowname = '100PercentPricePassThru (Cost Increase)';
        listType = 'ErosionDuetoContractTerms';
        

        Test.setCurrentPage(Page.ACEReportHomePage);
        ApexPages.CurrentPage().getParameters().put('reportType',reportType);
        ApexPages.CurrentPage().getParameters().put('Segment',SegmentName);
        ApexPages.CurrentPage().getParameters().put('SegmentType',SegmentType);
        ApexPages.CurrentPage().getParameters().put('Val',ReportName);
        ApexPages.CurrentPage().getParameters().put('ErosionType',ErosionType);
        ApexPages.CurrentPage().getParameters().put('quarter',quarter);
        ApexPages.CurrentPage().getParameters().put('Column',ColumnVal);
        ApexPages.CurrentPage().getParameters().put('rowName',rowName);
        ApexPages.CurrentPage().getParameters().put('listtype',listtype);
        
        system.debug('SegmentName:'+SegmentName+' reportType:'+reportType);
    }
    
        static testMethod void initialValOverviewReportData11()
    {
        
        ACE_Batches__c aceBatch = new ACE_Batches__c();
        aceBatch.Name = 'Q4-2014';
        aceBatch.Batch__c = 'Q4-2014';
        
        insert aceBatch;

        reportType = 'Summary';//madhavi
        SegmentName = 'Public';
        SegmentType = '';
        ReportName = 'Summary';
        ErosionType = 'Date';
        quarter = 'Q4-2014';
        ColumnVal = 'callme';
        rowname = '100PercentPricePassThru (Margin Play)';
        listType = 'ErosionDuetoContractTerms';
        

        Test.setCurrentPage(Page.ACEReportHomePage);
        ApexPages.CurrentPage().getParameters().put('reportType',reportType);
        ApexPages.CurrentPage().getParameters().put('Segment',SegmentName);
        ApexPages.CurrentPage().getParameters().put('SegmentType',SegmentType);
        ApexPages.CurrentPage().getParameters().put('Val',ReportName);
        ApexPages.CurrentPage().getParameters().put('ErosionType',ErosionType);
        ApexPages.CurrentPage().getParameters().put('quarter',quarter);
        ApexPages.CurrentPage().getParameters().put('Column',ColumnVal);
        ApexPages.CurrentPage().getParameters().put('rowName',rowName);
        ApexPages.CurrentPage().getParameters().put('listtype',listtype);
        
        system.debug('SegmentName:'+SegmentName+' reportType:'+reportType);
    }
    
        static testMethod void initialValOverviewReportData12()
    {
        
        ACE_Batches__c aceBatch = new ACE_Batches__c();
        aceBatch.Name = 'Q4-2014';
        aceBatch.Batch__c = 'Q4-2014';
        
        insert aceBatch;

        reportType = 'Summary';//madhavi
        SegmentName = 'Public';
        SegmentType = '';
        ReportName = 'Summary';
        ErosionType = 'Date';
        quarter = 'Q4-2014';
        ColumnVal = 'callme';
        rowname = '100PercentTimePassThru';
        listType = 'ErosionDuetoContractTerms';
        

        Test.setCurrentPage(Page.ACEReportHomePage);
        ApexPages.CurrentPage().getParameters().put('reportType',reportType);
        ApexPages.CurrentPage().getParameters().put('Segment',SegmentName);
        ApexPages.CurrentPage().getParameters().put('SegmentType',SegmentType);
        ApexPages.CurrentPage().getParameters().put('Val',ReportName);
        ApexPages.CurrentPage().getParameters().put('ErosionType',ErosionType);
        ApexPages.CurrentPage().getParameters().put('quarter',quarter);
        ApexPages.CurrentPage().getParameters().put('Column',ColumnVal);
        ApexPages.CurrentPage().getParameters().put('rowName',rowName);
        ApexPages.CurrentPage().getParameters().put('listtype',listtype);
        
        system.debug('SegmentName:'+SegmentName+' reportType:'+reportType);
    }
    
      static testMethod void initialValOverviewReportData13()
    {
        
        ACE_Batches__c aceBatch = new ACE_Batches__c();
        aceBatch.Name = 'Q4-2014';
        aceBatch.Batch__c = 'Q4-2014';
        
        insert aceBatch;

        reportType = 'Summary';//madhavi
        SegmentName = 'Public';
        SegmentType = '';
        ReportName = 'Summary';
        ErosionType = 'Date';
        quarter = 'Q4-2014';
        ColumnVal = 'callme';
        rowname = 'Customers with Increases';
        listType = 'EligibleCustomers';
        

        Test.setCurrentPage(Page.ACEReportHomePage);
        ApexPages.CurrentPage().getParameters().put('reportType',reportType);
        ApexPages.CurrentPage().getParameters().put('Segment',SegmentName);
        ApexPages.CurrentPage().getParameters().put('SegmentType',SegmentType);
        ApexPages.CurrentPage().getParameters().put('Val',ReportName);
        ApexPages.CurrentPage().getParameters().put('ErosionType',ErosionType);
        ApexPages.CurrentPage().getParameters().put('quarter',quarter);
        ApexPages.CurrentPage().getParameters().put('Column',ColumnVal);
        ApexPages.CurrentPage().getParameters().put('rowName',rowName);
        ApexPages.CurrentPage().getParameters().put('listtype',listtype);
        
        system.debug('SegmentName:'+SegmentName+' reportType:'+reportType);
    }
    
        static testMethod void initialValOverviewReportData14()
    {
        
        ACE_Batches__c aceBatch = new ACE_Batches__c();
        aceBatch.Name = 'Q4-2014';
        aceBatch.Batch__c = 'Q4-2014';
        
        insert aceBatch;

        reportType = 'Summary';//madhavi
        SegmentName = 'Public';
        SegmentType = '';
        ReportName = 'Summary';
        ErosionType = 'Date';
        quarter = 'Q4-2014';
        ColumnVal = 'callme';
        rowname = 'Revenue Pass Through (Cost Increase)';
        listType = 'EligibleCustomers';
        

        Test.setCurrentPage(Page.ACEReportHomePage);
        ApexPages.CurrentPage().getParameters().put('reportType',reportType);
        ApexPages.CurrentPage().getParameters().put('Segment',SegmentName);
        ApexPages.CurrentPage().getParameters().put('SegmentType',SegmentType);
        ApexPages.CurrentPage().getParameters().put('Val',ReportName);
        ApexPages.CurrentPage().getParameters().put('ErosionType',ErosionType);
        ApexPages.CurrentPage().getParameters().put('quarter',quarter);
        ApexPages.CurrentPage().getParameters().put('Column',ColumnVal);
        ApexPages.CurrentPage().getParameters().put('rowName',rowName);
        ApexPages.CurrentPage().getParameters().put('listtype',listtype);
        
        system.debug('SegmentName:'+SegmentName+' reportType:'+reportType);
    }
    
        static testMethod void initialValOverviewReportData15()
    {
        
        ACE_Batches__c aceBatch = new ACE_Batches__c();
        aceBatch.Name = 'Q4-2014';
        aceBatch.Batch__c = 'Q4-2014';
        
        insert aceBatch;

        reportType = 'Summary';//madhavi
        SegmentName = 'Public';
        SegmentType = '';
        ReportName = 'Summary';
        ErosionType = 'Date';
        quarter = 'Q4-2014';
        ColumnVal = 'callme';
        rowname = 'Revenue Pass Through (Margin Play)';
        listType = 'EligibleCustomers';
        

        Test.setCurrentPage(Page.ACEReportHomePage);
        ApexPages.CurrentPage().getParameters().put('reportType',reportType);
        ApexPages.CurrentPage().getParameters().put('Segment',SegmentName);
        ApexPages.CurrentPage().getParameters().put('SegmentType',SegmentType);
        ApexPages.CurrentPage().getParameters().put('Val',ReportName);
        ApexPages.CurrentPage().getParameters().put('ErosionType',ErosionType);
        ApexPages.CurrentPage().getParameters().put('quarter',quarter);
        ApexPages.CurrentPage().getParameters().put('Column',ColumnVal);
        ApexPages.CurrentPage().getParameters().put('rowName',rowName);
        ApexPages.CurrentPage().getParameters().put('listtype',listtype);
        
        system.debug('SegmentName:'+SegmentName+' reportType:'+reportType);
    }
    
    static testMethod void initialValOverviewReportData16()
    {
        
        ACE_Batches__c aceBatch = new ACE_Batches__c();
        aceBatch.Name = 'Q4-2014';
        aceBatch.Batch__c = 'Q4-2014';
        
        insert aceBatch;

        reportType = 'Summary';//madhavi
        SegmentName = 'Public';
        SegmentType = '';
        ReportName = 'Summary';
        ErosionType = 'Date';
        quarter = 'Q4-2014';
        ColumnVal = 'callme';
        rowname = '100PercentPricePassThru (Cost Increase)';
        listType = 'EligibleCustomers';
        

        Test.setCurrentPage(Page.ACEReportHomePage);
        ApexPages.CurrentPage().getParameters().put('reportType',reportType);
        ApexPages.CurrentPage().getParameters().put('Segment',SegmentName);
        ApexPages.CurrentPage().getParameters().put('SegmentType',SegmentType);
        ApexPages.CurrentPage().getParameters().put('Val',ReportName);
        ApexPages.CurrentPage().getParameters().put('ErosionType',ErosionType);
        ApexPages.CurrentPage().getParameters().put('quarter',quarter);
        ApexPages.CurrentPage().getParameters().put('Column',ColumnVal);
        ApexPages.CurrentPage().getParameters().put('rowName',rowName);
        ApexPages.CurrentPage().getParameters().put('listtype',listtype);
        
        system.debug('SegmentName:'+SegmentName+' reportType:'+reportType);
    }
    
        static testMethod void initialValOverviewReportData17()
    {
        
        ACE_Batches__c aceBatch = new ACE_Batches__c();
        aceBatch.Name = 'Q4-2014';
        aceBatch.Batch__c = 'Q4-2014';
        
        insert aceBatch;

        reportType = 'Summary';//madhavi
        SegmentName = 'Public';
        SegmentType = '';
        ReportName = 'Summary';
        ErosionType = 'Date';
        quarter = 'Q4-2014';
        ColumnVal = 'callme';
        rowname = '100PercentPricePassThru (Margin Play)';
        listType = 'EligibleCustomers';
        

        Test.setCurrentPage(Page.ACEReportHomePage);
        ApexPages.CurrentPage().getParameters().put('reportType',reportType);
        ApexPages.CurrentPage().getParameters().put('Segment',SegmentName);
        ApexPages.CurrentPage().getParameters().put('SegmentType',SegmentType);
        ApexPages.CurrentPage().getParameters().put('Val',ReportName);
        ApexPages.CurrentPage().getParameters().put('ErosionType',ErosionType);
        ApexPages.CurrentPage().getParameters().put('quarter',quarter);
        ApexPages.CurrentPage().getParameters().put('Column',ColumnVal);
        ApexPages.CurrentPage().getParameters().put('rowName',rowName);
        ApexPages.CurrentPage().getParameters().put('listtype',listtype);
        
        system.debug('SegmentName:'+SegmentName+' reportType:'+reportType);
    }
    
        static testMethod void initialValOverviewReportData18()
    {
        
        ACE_Batches__c aceBatch = new ACE_Batches__c();
        aceBatch.Name = 'Q4-2014';
        aceBatch.Batch__c = 'Q4-2014';
        
        insert aceBatch;

        reportType = 'Summary';//madhavi
        SegmentName = 'Public';
        SegmentType = '';
        ReportName = 'Summary';
        ErosionType = 'Date';
        quarter = 'Q4-2014';
        ColumnVal = 'callme';
        rowname = '100PercentTimePassThru';
        listType = 'EligibleCustomers';
        

        Test.setCurrentPage(Page.ACEReportHomePage);
        ApexPages.CurrentPage().getParameters().put('reportType',reportType);
        ApexPages.CurrentPage().getParameters().put('Segment',SegmentName);
        ApexPages.CurrentPage().getParameters().put('SegmentType',SegmentType);
        ApexPages.CurrentPage().getParameters().put('Val',ReportName);
        ApexPages.CurrentPage().getParameters().put('ErosionType',ErosionType);
        ApexPages.CurrentPage().getParameters().put('quarter',quarter);
        ApexPages.CurrentPage().getParameters().put('Column',ColumnVal);
        ApexPages.CurrentPage().getParameters().put('rowName',rowName);
        ApexPages.CurrentPage().getParameters().put('listtype',listtype);
        
        system.debug('SegmentName:'+SegmentName+' reportType:'+reportType);
    }
    
    static testMethod void initialValOverviewReportData19()
    {
        
        ACE_Batches__c aceBatch = new ACE_Batches__c();
        aceBatch.Name = 'Q4-2014';
        aceBatch.Batch__c = 'Q4-2014';
        
        insert aceBatch;

        reportType = 'Summary';//madhavi
        SegmentName = 'Public';
        SegmentType = '';
        ReportName = 'Summary';
        ErosionType = 'Date';
        quarter = 'Q4-2014';
        ColumnVal = 'callme';
        rowname = 'Customers with Increases';
        listType = 'ErosionduetoSalesDecisions';
        

        Test.setCurrentPage(Page.ACEReportHomePage);
        ApexPages.CurrentPage().getParameters().put('reportType',reportType);
        ApexPages.CurrentPage().getParameters().put('Segment',SegmentName);
        ApexPages.CurrentPage().getParameters().put('SegmentType',SegmentType);
        ApexPages.CurrentPage().getParameters().put('Val',ReportName);
        ApexPages.CurrentPage().getParameters().put('ErosionType',ErosionType);
        ApexPages.CurrentPage().getParameters().put('quarter',quarter);
        ApexPages.CurrentPage().getParameters().put('Column',ColumnVal);
        ApexPages.CurrentPage().getParameters().put('rowName',rowName);
        ApexPages.CurrentPage().getParameters().put('listtype',listtype);
        
        system.debug('SegmentName:'+SegmentName+' reportType:'+reportType);
    }
    
        static testMethod void initialValOverviewReportData20()
    {
        
        ACE_Batches__c aceBatch = new ACE_Batches__c();
        aceBatch.Name = 'Q4-2014';
        aceBatch.Batch__c = 'Q4-2014';
        
        insert aceBatch;

        reportType = 'Summary';//madhavi
        SegmentName = 'Public';
        SegmentType = '';
        ReportName = 'Summary';
        ErosionType = 'Date';
        quarter = 'Q4-2014';
        ColumnVal = 'callme';
        rowname = 'Revenue Pass Through (Cost Increase)';
        listType = 'ErosionduetoSalesDecisions';
        

        Test.setCurrentPage(Page.ACEReportHomePage);
        ApexPages.CurrentPage().getParameters().put('reportType',reportType);
        ApexPages.CurrentPage().getParameters().put('Segment',SegmentName);
        ApexPages.CurrentPage().getParameters().put('SegmentType',SegmentType);
        ApexPages.CurrentPage().getParameters().put('Val',ReportName);
        ApexPages.CurrentPage().getParameters().put('ErosionType',ErosionType);
        ApexPages.CurrentPage().getParameters().put('quarter',quarter);
        ApexPages.CurrentPage().getParameters().put('Column',ColumnVal);
        ApexPages.CurrentPage().getParameters().put('rowName',rowName);
        ApexPages.CurrentPage().getParameters().put('listtype',listtype);
        
        system.debug('SegmentName:'+SegmentName+' reportType:'+reportType);
    }
    
        static testMethod void initialValOverviewReportData21()
    {
        
        ACE_Batches__c aceBatch = new ACE_Batches__c();
        aceBatch.Name = 'Q4-2014';
        aceBatch.Batch__c = 'Q4-2014';
        
        insert aceBatch;

        reportType = 'Summary';//madhavi
        SegmentName = 'Public';
        SegmentType = '';
        ReportName = 'Summary';
        ErosionType = 'Date';
        quarter = 'Q4-2014';
        ColumnVal = 'callme';
        rowname = 'Revenue Pass Through (Margin Play)';
        listType = 'ErosionduetoSalesDecisions';
        

        Test.setCurrentPage(Page.ACEReportHomePage);
        ApexPages.CurrentPage().getParameters().put('reportType',reportType);
        ApexPages.CurrentPage().getParameters().put('Segment',SegmentName);
        ApexPages.CurrentPage().getParameters().put('SegmentType',SegmentType);
        ApexPages.CurrentPage().getParameters().put('Val',ReportName);
        ApexPages.CurrentPage().getParameters().put('ErosionType',ErosionType);
        ApexPages.CurrentPage().getParameters().put('quarter',quarter);
        ApexPages.CurrentPage().getParameters().put('Column',ColumnVal);
        ApexPages.CurrentPage().getParameters().put('rowName',rowName);
        ApexPages.CurrentPage().getParameters().put('listtype',listtype);
        
        system.debug('SegmentName:'+SegmentName+' reportType:'+reportType);
    }
    
    static testMethod void initialValOverviewReportData22()
    {
        
        ACE_Batches__c aceBatch = new ACE_Batches__c();
        aceBatch.Name = 'Q4-2014';
        aceBatch.Batch__c = 'Q4-2014';
        
        insert aceBatch;

        reportType = 'Summary';//madhavi
        SegmentName = 'Public';
        SegmentType = '';
        ReportName = 'Summary';
        ErosionType = 'Date';
        quarter = 'Q4-2014';
        ColumnVal = 'callme';
        rowname = '100PercentPricePassThru (Cost Increase)';
        listType = 'ErosionduetoSalesDecisions';
        

        Test.setCurrentPage(Page.ACEReportHomePage);
        ApexPages.CurrentPage().getParameters().put('reportType',reportType);
        ApexPages.CurrentPage().getParameters().put('Segment',SegmentName);
        ApexPages.CurrentPage().getParameters().put('SegmentType',SegmentType);
        ApexPages.CurrentPage().getParameters().put('Val',ReportName);
        ApexPages.CurrentPage().getParameters().put('ErosionType',ErosionType);
        ApexPages.CurrentPage().getParameters().put('quarter',quarter);
        ApexPages.CurrentPage().getParameters().put('Column',ColumnVal);
        ApexPages.CurrentPage().getParameters().put('rowName',rowName);
        ApexPages.CurrentPage().getParameters().put('listtype',listtype);
        
        system.debug('SegmentName:'+SegmentName+' reportType:'+reportType);
    }
    
        static testMethod void initialValOverviewReportData23()
    {
        
        ACE_Batches__c aceBatch = new ACE_Batches__c();
        aceBatch.Name = 'Q4-2014';
        aceBatch.Batch__c = 'Q4-2014';
        
        insert aceBatch;

        reportType = 'Summary';//madhavi
        SegmentName = 'Public';
        SegmentType = '';
        ReportName = 'Summary';
        ErosionType = 'Date';
        quarter = 'Q4-2014';
        ColumnVal = 'callme';
        rowname = '100PercentPricePassThru (Margin Play)';
        listType = 'ErosionduetoSalesDecisions';
        

        Test.setCurrentPage(Page.ACEReportHomePage);
        ApexPages.CurrentPage().getParameters().put('reportType',reportType);
        ApexPages.CurrentPage().getParameters().put('Segment',SegmentName);
        ApexPages.CurrentPage().getParameters().put('SegmentType',SegmentType);
        ApexPages.CurrentPage().getParameters().put('Val',ReportName);
        ApexPages.CurrentPage().getParameters().put('ErosionType',ErosionType);
        ApexPages.CurrentPage().getParameters().put('quarter',quarter);
        ApexPages.CurrentPage().getParameters().put('Column',ColumnVal);
        ApexPages.CurrentPage().getParameters().put('rowName',rowName);
        ApexPages.CurrentPage().getParameters().put('listtype',listtype);
        
        system.debug('SegmentName:'+SegmentName+' reportType:'+reportType);
    }
    
        static testMethod void initialValOverviewReportData24()
    {
        
        ACE_Batches__c aceBatch = new ACE_Batches__c();
        aceBatch.Name = 'Q4-2014';
        aceBatch.Batch__c = 'Q4-2014';
        
        insert aceBatch;

        reportType = 'Summary';//madhavi
        SegmentName = 'Public';
        SegmentType = '';
        ReportName = 'Summary';
        ErosionType = 'Date';
        quarter = 'Q4-2014';
        ColumnVal = 'callme';
        rowname = '100PercentTimePassThru';
        listType = 'ErosionduetoSalesDecisions';
        

        Test.setCurrentPage(Page.ACEReportHomePage);
        ApexPages.CurrentPage().getParameters().put('reportType',reportType);
        ApexPages.CurrentPage().getParameters().put('Segment',SegmentName);
        ApexPages.CurrentPage().getParameters().put('SegmentType',SegmentType);
        ApexPages.CurrentPage().getParameters().put('Val',ReportName);
        ApexPages.CurrentPage().getParameters().put('ErosionType',ErosionType);
        ApexPages.CurrentPage().getParameters().put('quarter',quarter);
        ApexPages.CurrentPage().getParameters().put('Column',ColumnVal);
        ApexPages.CurrentPage().getParameters().put('rowName',rowName);
        ApexPages.CurrentPage().getParameters().put('listtype',listtype);
        
        system.debug('SegmentName:'+SegmentName+' reportType:'+reportType);
    }
    
    static testMethod void initialValOverviewReportData25()
    {
        
        ACE_Batches__c aceBatch = new ACE_Batches__c();
        aceBatch.Name = 'Q4-2014';
        aceBatch.Batch__c = 'Q4-2014';
        
        insert aceBatch;

        reportType = 'Summary';//madhavi
        SegmentName = 'Public';
        SegmentType = '';
        ReportName = 'Summary';
        ErosionType = 'Date';
        quarter = 'Q4-2014';
        ColumnVal = 'callme';
        rowname = 'Customers with Increases';
        listType = 'ErosionduetoRemediationAndSalesPricingDecisions';
        

        Test.setCurrentPage(Page.ACEReportHomePage);
        ApexPages.CurrentPage().getParameters().put('reportType',reportType);
        ApexPages.CurrentPage().getParameters().put('Segment',SegmentName);
        ApexPages.CurrentPage().getParameters().put('SegmentType',SegmentType);
        ApexPages.CurrentPage().getParameters().put('Val',ReportName);
        ApexPages.CurrentPage().getParameters().put('ErosionType',ErosionType);
        ApexPages.CurrentPage().getParameters().put('quarter',quarter);
        ApexPages.CurrentPage().getParameters().put('Column',ColumnVal);
        ApexPages.CurrentPage().getParameters().put('rowName',rowName);
        ApexPages.CurrentPage().getParameters().put('listtype',listtype);
        
        system.debug('SegmentName:'+SegmentName+' reportType:'+reportType);
    }
    
    static testMethod void initialValOverviewReportData26()
    {
        
        ACE_Batches__c aceBatch = new ACE_Batches__c();
        aceBatch.Name = 'Q4-2014';
        aceBatch.Batch__c = 'Q4-2014';
        
        insert aceBatch;

        reportType = 'Summary';//madhavi
        SegmentName = 'Public';
        SegmentType = '';
        ReportName = 'Summary';
        ErosionType = 'Date';
        quarter = 'Q4-2014';
        ColumnVal = 'callme';
        rowname = 'Revenue Pass Through (Cost Increase)';
        listType = 'ErosionduetoRemediationAndSalesPricingDecisions';
        

        Test.setCurrentPage(Page.ACEReportHomePage);
        ApexPages.CurrentPage().getParameters().put('reportType',reportType);
        ApexPages.CurrentPage().getParameters().put('Segment',SegmentName);
        ApexPages.CurrentPage().getParameters().put('SegmentType',SegmentType);
        ApexPages.CurrentPage().getParameters().put('Val',ReportName);
        ApexPages.CurrentPage().getParameters().put('ErosionType',ErosionType);
        ApexPages.CurrentPage().getParameters().put('quarter',quarter);
        ApexPages.CurrentPage().getParameters().put('Column',ColumnVal);
        ApexPages.CurrentPage().getParameters().put('rowName',rowName);
        ApexPages.CurrentPage().getParameters().put('listtype',listtype);
        
        system.debug('SegmentName:'+SegmentName+' reportType:'+reportType);
    }
    
    static testMethod void initialValOverviewReportData27()
    {
        
        ACE_Batches__c aceBatch = new ACE_Batches__c();
        aceBatch.Name = 'Q4-2014';
        aceBatch.Batch__c = 'Q4-2014';
        
        insert aceBatch;

        reportType = 'Summary';//madhavi
        SegmentName = 'Public';
        SegmentType = '';
        ReportName = 'Summary';
        ErosionType = 'Date';
        quarter = 'Q4-2014';
        ColumnVal = 'callme';
        rowname = 'Revenue Pass Through (Margin Play)';
        listType = 'ErosionduetoRemediationAndSalesPricingDecisions';
        

        Test.setCurrentPage(Page.ACEReportHomePage);
        ApexPages.CurrentPage().getParameters().put('reportType',reportType);
        ApexPages.CurrentPage().getParameters().put('Segment',SegmentName);
        ApexPages.CurrentPage().getParameters().put('SegmentType',SegmentType);
        ApexPages.CurrentPage().getParameters().put('Val',ReportName);
        ApexPages.CurrentPage().getParameters().put('ErosionType',ErosionType);
        ApexPages.CurrentPage().getParameters().put('quarter',quarter);
        ApexPages.CurrentPage().getParameters().put('Column',ColumnVal);
        ApexPages.CurrentPage().getParameters().put('rowName',rowName);
        ApexPages.CurrentPage().getParameters().put('listtype',listtype);
        
        system.debug('SegmentName:'+SegmentName+' reportType:'+reportType);
    }
    
    static testMethod void initialValOverviewReportData28()
    {
        
        ACE_Batches__c aceBatch = new ACE_Batches__c();
        aceBatch.Name = 'Q4-2014';
        aceBatch.Batch__c = 'Q4-2014';
        
        insert aceBatch;

        reportType = 'Summary';//madhavi
        SegmentName = 'Public';
        SegmentType = '';
        ReportName = 'Summary';
        ErosionType = 'Date';
        quarter = 'Q4-2014';
        ColumnVal = 'callme';
        rowname = '100PercentPricePassThru (Cost Increase)';
        listType = 'ErosionduetoRemediationAndSalesPricingDecisions';
        

        Test.setCurrentPage(Page.ACEReportHomePage);
        ApexPages.CurrentPage().getParameters().put('reportType',reportType);
        ApexPages.CurrentPage().getParameters().put('Segment',SegmentName);
        ApexPages.CurrentPage().getParameters().put('SegmentType',SegmentType);
        ApexPages.CurrentPage().getParameters().put('Val',ReportName);
        ApexPages.CurrentPage().getParameters().put('ErosionType',ErosionType);
        ApexPages.CurrentPage().getParameters().put('quarter',quarter);
        ApexPages.CurrentPage().getParameters().put('Column',ColumnVal);
        ApexPages.CurrentPage().getParameters().put('rowName',rowName);
        ApexPages.CurrentPage().getParameters().put('listtype',listtype);
        
        system.debug('SegmentName:'+SegmentName+' reportType:'+reportType);
    }
    
        static testMethod void initialValOverviewReportData29()
    {
        
        ACE_Batches__c aceBatch = new ACE_Batches__c();
        aceBatch.Name = 'Q4-2014';
        aceBatch.Batch__c = 'Q4-2014';
        
        insert aceBatch;

        reportType = 'Summary';//madhavi
        SegmentName = 'Public';
        SegmentType = '';
        ReportName = 'Summary';
        ErosionType = 'Date';
        quarter = 'Q4-2014';
        ColumnVal = 'callme';
        rowname = '100PercentPricePassThru (Margin Play)';
        listType = 'ErosionduetoRemediationAndSalesPricingDecisions';
        

        Test.setCurrentPage(Page.ACEReportHomePage);
        ApexPages.CurrentPage().getParameters().put('reportType',reportType);
        ApexPages.CurrentPage().getParameters().put('Segment',SegmentName);
        ApexPages.CurrentPage().getParameters().put('SegmentType',SegmentType);
        ApexPages.CurrentPage().getParameters().put('Val',ReportName);
        ApexPages.CurrentPage().getParameters().put('ErosionType',ErosionType);
        ApexPages.CurrentPage().getParameters().put('quarter',quarter);
        ApexPages.CurrentPage().getParameters().put('Column',ColumnVal);
        ApexPages.CurrentPage().getParameters().put('rowName',rowName);
        ApexPages.CurrentPage().getParameters().put('listtype',listtype);
        
        system.debug('SegmentName:'+SegmentName+' reportType:'+reportType);
    }
    
        static testMethod void initialValOverviewReportData30()
    {
        
        ACE_Batches__c aceBatch = new ACE_Batches__c();
        aceBatch.Name = 'Q4-2014';
        aceBatch.Batch__c = 'Q4-2014';
        
        insert aceBatch;

        reportType = 'Summary';//madhavi
        SegmentName = 'Public';
        SegmentType = '';
        ReportName = 'Summary';
        ErosionType = 'Date';
        quarter = 'Q4-2014';
        ColumnVal = 'callme';
        rowname = '100PercentTimePassThru';
        listType = 'ErosionduetoRemediationAndSalesPricingDecisions';
        

        Test.setCurrentPage(Page.ACEReportHomePage);
        ApexPages.CurrentPage().getParameters().put('reportType',reportType);
        ApexPages.CurrentPage().getParameters().put('Segment',SegmentName);
        ApexPages.CurrentPage().getParameters().put('SegmentType',SegmentType);
        ApexPages.CurrentPage().getParameters().put('Val',ReportName);
        ApexPages.CurrentPage().getParameters().put('ErosionType',ErosionType);
        ApexPages.CurrentPage().getParameters().put('quarter',quarter);
        ApexPages.CurrentPage().getParameters().put('Column',ColumnVal);
        ApexPages.CurrentPage().getParameters().put('rowName',rowName);
        ApexPages.CurrentPage().getParameters().put('listtype',listtype);
        
        system.debug('SegmentName:'+SegmentName+' reportType:'+reportType);
    }
    
    
    static testMethod void initialValOverviewReportData31()
    {
        
        ACE_Batches__c aceBatch = new ACE_Batches__c();
        aceBatch.Name = 'Q4-2014';
        aceBatch.Batch__c = 'Q4-2014';
        
        insert aceBatch;

        reportType = 'Summary';//madhavi
        SegmentName = 'Public';
        SegmentType = '';
        ReportName = 'Summary';
        ErosionType = 'Date';
        quarter = 'Q4-2014';
        ColumnVal = 'callme';
        rowname = 'Customers with Increases';
        listType = 'Implemented';
        

        Test.setCurrentPage(Page.ACEReportHomePage);
        ApexPages.CurrentPage().getParameters().put('reportType',reportType);
        ApexPages.CurrentPage().getParameters().put('Segment',SegmentName);
        ApexPages.CurrentPage().getParameters().put('SegmentType',SegmentType);
        ApexPages.CurrentPage().getParameters().put('Val',ReportName);
        ApexPages.CurrentPage().getParameters().put('ErosionType',ErosionType);
        ApexPages.CurrentPage().getParameters().put('quarter',quarter);
        ApexPages.CurrentPage().getParameters().put('Column',ColumnVal);
        ApexPages.CurrentPage().getParameters().put('rowName',rowName);
        ApexPages.CurrentPage().getParameters().put('listtype',listtype);
        
        system.debug('SegmentName:'+SegmentName+' reportType:'+reportType);
    }
    
    static testMethod void initialValOverviewReportData32()
    {
        
        ACE_Batches__c aceBatch = new ACE_Batches__c();
        aceBatch.Name = 'Q4-2014';
        aceBatch.Batch__c = 'Q4-2014';
        
        insert aceBatch;

        reportType = 'Summary';//madhavi
        SegmentName = 'Public';
        SegmentType = '';
        ReportName = 'Summary';
        ErosionType = 'Date';
        quarter = 'Q4-2014';
        ColumnVal = 'callme';
        rowname = 'Revenue Pass Through (Cost Increase)';
        listType = 'Implemented';
        

        Test.setCurrentPage(Page.ACEReportHomePage);
        ApexPages.CurrentPage().getParameters().put('reportType',reportType);
        ApexPages.CurrentPage().getParameters().put('Segment',SegmentName);
        ApexPages.CurrentPage().getParameters().put('SegmentType',SegmentType);
        ApexPages.CurrentPage().getParameters().put('Val',ReportName);
        ApexPages.CurrentPage().getParameters().put('ErosionType',ErosionType);
        ApexPages.CurrentPage().getParameters().put('quarter',quarter);
        ApexPages.CurrentPage().getParameters().put('Column',ColumnVal);
        ApexPages.CurrentPage().getParameters().put('rowName',rowName);
        ApexPages.CurrentPage().getParameters().put('listtype',listtype);
        
        system.debug('SegmentName:'+SegmentName+' reportType:'+reportType);
    }
    
    static testMethod void initialValOverviewReportData33()
    {
        
        ACE_Batches__c aceBatch = new ACE_Batches__c();
        aceBatch.Name = 'Q4-2014';
        aceBatch.Batch__c = 'Q4-2014';
        
        insert aceBatch;

        reportType = 'Summary';//madhavi
        SegmentName = 'Public';
        SegmentType = '';
        ReportName = 'Summary';
        ErosionType = 'Date';
        quarter = 'Q4-2014';
        ColumnVal = 'callme';
        rowname = 'Revenue Pass Through (Margin Play)';
        listType = 'Implemented';
        

        Test.setCurrentPage(Page.ACEReportHomePage);
        ApexPages.CurrentPage().getParameters().put('reportType',reportType);
        ApexPages.CurrentPage().getParameters().put('Segment',SegmentName);
        ApexPages.CurrentPage().getParameters().put('SegmentType',SegmentType);
        ApexPages.CurrentPage().getParameters().put('Val',ReportName);
        ApexPages.CurrentPage().getParameters().put('ErosionType',ErosionType);
        ApexPages.CurrentPage().getParameters().put('quarter',quarter);
        ApexPages.CurrentPage().getParameters().put('Column',ColumnVal);
        ApexPages.CurrentPage().getParameters().put('rowName',rowName);
        ApexPages.CurrentPage().getParameters().put('listtype',listtype);
        
        system.debug('SegmentName:'+SegmentName+' reportType:'+reportType);
    }
    
    static testMethod void initialValOverviewReportData34()
    {
        
        ACE_Batches__c aceBatch = new ACE_Batches__c();
        aceBatch.Name = 'Q4-2014';
        aceBatch.Batch__c = 'Q4-2014';
        
        insert aceBatch;

        reportType = 'Summary';//madhavi
        SegmentName = 'Public';
        SegmentType = '';
        ReportName = 'Summary';
        ErosionType = 'Date';
        quarter = 'Q4-2014';
        ColumnVal = 'callme';
        rowname = '100PercentPricePassThru (Cost Increase)';
        listType = 'Implemented';
        

        Test.setCurrentPage(Page.ACEReportHomePage);
        ApexPages.CurrentPage().getParameters().put('reportType',reportType);
        ApexPages.CurrentPage().getParameters().put('Segment',SegmentName);
        ApexPages.CurrentPage().getParameters().put('SegmentType',SegmentType);
        ApexPages.CurrentPage().getParameters().put('Val',ReportName);
        ApexPages.CurrentPage().getParameters().put('ErosionType',ErosionType);
        ApexPages.CurrentPage().getParameters().put('quarter',quarter);
        ApexPages.CurrentPage().getParameters().put('Column',ColumnVal);
        ApexPages.CurrentPage().getParameters().put('rowName',rowName);
        ApexPages.CurrentPage().getParameters().put('listtype',listtype);
        
        system.debug('SegmentName:'+SegmentName+' reportType:'+reportType);
    }
    
    static testMethod void initialValOverviewReportData35()
    {
        
        ACE_Batches__c aceBatch = new ACE_Batches__c();
        aceBatch.Name = 'Q4-2014';
        aceBatch.Batch__c = 'Q4-2014';
        
        insert aceBatch;

        reportType = 'Summary';//madhavi
        SegmentName = 'Public';
        SegmentType = '';
        ReportName = 'Summary';
        ErosionType = 'Date';
        quarter = 'Q4-2014';
        ColumnVal = 'callme';
        rowname = '100PercentPricePassThru (Margin Play)';
        listType = 'Implemented';
        

        Test.setCurrentPage(Page.ACEReportHomePage);
        ApexPages.CurrentPage().getParameters().put('reportType',reportType);
        ApexPages.CurrentPage().getParameters().put('Segment',SegmentName);
        ApexPages.CurrentPage().getParameters().put('SegmentType',SegmentType);
        ApexPages.CurrentPage().getParameters().put('Val',ReportName);
        ApexPages.CurrentPage().getParameters().put('ErosionType',ErosionType);
        ApexPages.CurrentPage().getParameters().put('quarter',quarter);
        ApexPages.CurrentPage().getParameters().put('Column',ColumnVal);
        ApexPages.CurrentPage().getParameters().put('rowName',rowName);
        ApexPages.CurrentPage().getParameters().put('listtype',listtype);
        
        system.debug('SegmentName:'+SegmentName+' reportType:'+reportType);
    }
    
    static testMethod void initialValOverviewReportData36()
    {
        
        ACE_Batches__c aceBatch = new ACE_Batches__c();
        aceBatch.Name = 'Q4-2014';
        aceBatch.Batch__c = 'Q4-2014';
        
        insert aceBatch;

        reportType = 'Summary';//madhavi
        SegmentName = 'Public';
        SegmentType = '';
        ReportName = 'Summary';
        ErosionType = 'Date';
        quarter = 'Q4-2014';
        ColumnVal = 'callme';
        rowname = '100PercentTimePassThru';
        listType = 'Implemented';
        

        Test.setCurrentPage(Page.ACEReportHomePage);
        ApexPages.CurrentPage().getParameters().put('reportType',reportType);
        ApexPages.CurrentPage().getParameters().put('Segment',SegmentName);
        ApexPages.CurrentPage().getParameters().put('SegmentType',SegmentType);
        ApexPages.CurrentPage().getParameters().put('Val',ReportName);
        ApexPages.CurrentPage().getParameters().put('ErosionType',ErosionType);
        ApexPages.CurrentPage().getParameters().put('quarter',quarter);
        ApexPages.CurrentPage().getParameters().put('Column',ColumnVal);
        ApexPages.CurrentPage().getParameters().put('rowName',rowName);
        ApexPages.CurrentPage().getParameters().put('listtype',listtype);
        
        system.debug('SegmentName:'+SegmentName+' reportType:'+reportType);
    }
    
    
    
    
    
    static testMethod void ACE_User_Cust_Hierarchy_Controller_method_1()
    {
         ACE_Settings__c desettings = new ACE_Settings__c();
         insert desettings; 
         
         Account acc = new Account (name = 'SUN Test Account',AOPS_Seq_ID__c = '123456',AOPS_Cust_Id__c = '123456',Oracle_Party_Id__c = '123456',Billingcountry = 'USA',BillingState = 'UT',BillingStreet = '1040 N 326 W',billingcity = 'Orem', type='Customer');
         acc.Industry_OD_SIC_Rep__c = 'Public';
         insert acc; 
         
          ace1 = new ACE_Customer_Price_Changes__c(name='Q4-2014',SRM_Differential__c=5,record_unlock_Status__c='open',Item_12_Month_Qty__c = 50,Total_Spend_Impact_12_Month__c=5,Customer__c = acc.id, Owning_Customer_ID__c ='123456', SFDC_Notification_Flag__c = '3',Hosted_Catalog__c=true);
          ace1.CallMeRequest__c = true;
          ace1.Customer_Response__c = 'Call Me';
          ace1.PRICE_NOT_CALCULATED__c = false;
          ace1.Report_isSKU_Exception__c=false;
          ace1.Report_SKU_Count__c =3;
         insert ace1;
        
        Ace_Customer_Core_Changes__c ace2 = new Ace_Customer_Core_Changes__c(name = 'Test1',CoreID__c = 'CL-123456', ACE_Customer_Price_Changes__c = ace1.id);
        insert ace2;
             
        Ace_Customer_SKU_Changes__c ace3 = new Ace_Customer_SKU_Changes__c(price_changes_type__c='B',SKU__c = '123456',status__c='Active',batchId__c='Q4-2014',PRICE_NOT_CALCULATED__c = false,Item_3_Month_Qty__c=12.12,Item_6_Month_Qty__c=12.12,Item_9_Month_Qty__c=12.12,Item_6_Month_Sales__c=12.12,Item_3_Month_Sales__c=12.12,
        Price_Change_ID__c=ace1.id,Item_9_Month_Sales__c=12.12,Total_Spend_Impact_3_Month__c=12.12,Total_Spend_Impact_6_Month__c=12.12,Total_Spend_Impact_9_Month__c=12.12,Item_12_Month_Qty__c = 50,Item_12_Month_Sales__c=12.12,Total_Spend_Impact_12_Month__c=123.12,name='test', Ace_Customer_Core_Changes__c = ace2.id);
        insert ace3;
        
         ApexPages.currentPage().getParameters().Put('id',ace1.id);
        
        
     }
    
    
    static testMethod void CustListOverviewReportData1()
    {
    initialValOverviewReportData1();   
    Test.startTest();
    ACE_User_Cust_Hierarchy_Controller_method_1();
    arw = new ACEReporting_RevMarg_WaterFall();
    arw.CustListOverviewReportData1();
    Test.stopTest();
    }
    
    static testMethod void CustListOverviewReportData2()
    {
    initialValOverviewReportData2();   
    Test.startTest();
    ACE_User_Cust_Hierarchy_Controller_method_1();
    arw = new ACEReporting_RevMarg_WaterFall();
    arw.CustListOverviewReportData1();
    Test.stopTest();
    }
    
    static testMethod void CustListOverviewReportData3()
    {
    initialValOverviewReportData3();   
    Test.startTest();
    ACE_User_Cust_Hierarchy_Controller_method_1();
    arw = new ACEReporting_RevMarg_WaterFall();
    arw.CustListOverviewReportData1();
    Test.stopTest();
    }
    
    static testMethod void CustListOverviewReportData4()
    {
    initialValOverviewReportData4();   
    Test.startTest();
    ACE_User_Cust_Hierarchy_Controller_method_1();
    arw = new ACEReporting_RevMarg_WaterFall();
    arw.CustListOverviewReportData1();
    Test.stopTest();
    }
    
    static testMethod void CustListOverviewReportData5()
    {
    initialValOverviewReportData5();   
    Test.startTest();
    ACE_User_Cust_Hierarchy_Controller_method_1();
    arw = new ACEReporting_RevMarg_WaterFall();
    arw.CustListOverviewReportData1();
    Test.stopTest();
    }
    
    static testMethod void CustListOverviewReportData6()
    {
    initialValOverviewReportData6();   
    Test.startTest();
    ACE_User_Cust_Hierarchy_Controller_method_1();
    arw = new ACEReporting_RevMarg_WaterFall();
    arw.CustListOverviewReportData1();
    Test.stopTest();
    }
    
      static testMethod void CustListOverviewReportData7()
    {
    initialValOverviewReportData7();   
    Test.startTest();
    ACE_User_Cust_Hierarchy_Controller_method_1();
    arw = new ACEReporting_RevMarg_WaterFall();
    arw.CustListOverviewReportData1();
    Test.stopTest();
    }
    
    static testMethod void CustListOverviewReportData8()
    {
    initialValOverviewReportData8();   
    Test.startTest();
    ACE_User_Cust_Hierarchy_Controller_method_1();
    arw = new ACEReporting_RevMarg_WaterFall();
    arw.CustListOverviewReportData1();
    Test.stopTest();
    }
    
    static testMethod void CustListOverviewReportData9()
    {
    initialValOverviewReportData9();   
    Test.startTest();
    ACE_User_Cust_Hierarchy_Controller_method_1();
    arw = new ACEReporting_RevMarg_WaterFall();
    arw.CustListOverviewReportData1();
    Test.stopTest();
    }
    
    static testMethod void CustListOverviewReportData10()
    {
    initialValOverviewReportData10();   
    Test.startTest();
    ACE_User_Cust_Hierarchy_Controller_method_1();
    arw = new ACEReporting_RevMarg_WaterFall();
    arw.CustListOverviewReportData1();
    Test.stopTest();
    }
    
    static testMethod void CustListOverviewReportData11()
    {
    initialValOverviewReportData11();   
    Test.startTest();
    ACE_User_Cust_Hierarchy_Controller_method_1();
    arw = new ACEReporting_RevMarg_WaterFall();
    arw.CustListOverviewReportData1();
    Test.stopTest();
    }
    
    static testMethod void CustListOverviewReportData12()
    {
    initialValOverviewReportData12();   
    Test.startTest();
    ACE_User_Cust_Hierarchy_Controller_method_1();
    arw = new ACEReporting_RevMarg_WaterFall();
    arw.CustListOverviewReportData1();
    Test.stopTest();
    }
    
       
    static testMethod void CustListOverviewReportData13()
    {
    initialValOverviewReportData13();   
    Test.startTest();
    ACE_User_Cust_Hierarchy_Controller_method_1();
    arw = new ACEReporting_RevMarg_WaterFall();
    arw.CustListOverviewReportData1();
    Test.stopTest();
    }
    
    static testMethod void CustListOverviewReportData14()
    {
    initialValOverviewReportData14();   
    Test.startTest();
    ACE_User_Cust_Hierarchy_Controller_method_1();
    arw = new ACEReporting_RevMarg_WaterFall();
    arw.CustListOverviewReportData1();
    Test.stopTest();
    }
    
    static testMethod void CustListOverviewReportData15()
    {
    initialValOverviewReportData15();   
    Test.startTest();
    ACE_User_Cust_Hierarchy_Controller_method_1();
    arw = new ACEReporting_RevMarg_WaterFall();
    arw.CustListOverviewReportData1();
    Test.stopTest();
    }
    
    static testMethod void CustListOverviewReportData16()
    {
    initialValOverviewReportData16();   
    Test.startTest();
    ACE_User_Cust_Hierarchy_Controller_method_1();
    arw = new ACEReporting_RevMarg_WaterFall();
    arw.CustListOverviewReportData1();
    Test.stopTest();
    }
    
    static testMethod void CustListOverviewReportData17()
    {
    initialValOverviewReportData17();   
    Test.startTest();
    ACE_User_Cust_Hierarchy_Controller_method_1();
    arw = new ACEReporting_RevMarg_WaterFall();
    arw.CustListOverviewReportData1();
    Test.stopTest();
    }
    
    static testMethod void CustListOverviewReportData18()
    {
    initialValOverviewReportData18();   
    Test.startTest();
    ACE_User_Cust_Hierarchy_Controller_method_1();
    arw = new ACEReporting_RevMarg_WaterFall();
    arw.CustListOverviewReportData1();
    Test.stopTest();
    }
    
    static testMethod void CustListOverviewReportData19()
    {
    initialValOverviewReportData19();   
    Test.startTest();
    ACE_User_Cust_Hierarchy_Controller_method_1();
    arw = new ACEReporting_RevMarg_WaterFall();
    arw.CustListOverviewReportData1();
    Test.stopTest();
    }
    
    static testMethod void CustListOverviewReportData20()
    {
    initialValOverviewReportData20();   
    Test.startTest();
    ACE_User_Cust_Hierarchy_Controller_method_1();
    arw = new ACEReporting_RevMarg_WaterFall();
    arw.CustListOverviewReportData1();
    Test.stopTest();
    }
    
    static testMethod void CustListOverviewReportData21()
    {
    initialValOverviewReportData21();   
    Test.startTest();
    ACE_User_Cust_Hierarchy_Controller_method_1();
    arw = new ACEReporting_RevMarg_WaterFall();
    arw.CustListOverviewReportData1();
    Test.stopTest();
    }
    
    static testMethod void CustListOverviewReportData22()
    {
    initialValOverviewReportData22();   
    Test.startTest();
    ACE_User_Cust_Hierarchy_Controller_method_1();
    arw = new ACEReporting_RevMarg_WaterFall();
    arw.CustListOverviewReportData1();
    Test.stopTest();
    }
    
    static testMethod void CustListOverviewReportData23()
    {
    initialValOverviewReportData23();   
    Test.startTest();
    ACE_User_Cust_Hierarchy_Controller_method_1();
    arw = new ACEReporting_RevMarg_WaterFall();
    arw.CustListOverviewReportData1();
    Test.stopTest();
    }
    
    static testMethod void CustListOverviewReportData24()
    {
    initialValOverviewReportData24();   
    Test.startTest();
    ACE_User_Cust_Hierarchy_Controller_method_1();
    arw = new ACEReporting_RevMarg_WaterFall();
    arw.CustListOverviewReportData1();
    Test.stopTest();
    }
    
     static testMethod void CustListOverviewReportData25()
    {
    initialValOverviewReportData25();   
    Test.startTest();
    ACE_User_Cust_Hierarchy_Controller_method_1();
    arw = new ACEReporting_RevMarg_WaterFall();
    arw.CustListOverviewReportData1();
    Test.stopTest();
    }
    
    static testMethod void CustListOverviewReportData26()
    {
    initialValOverviewReportData26();   
    Test.startTest();
    ACE_User_Cust_Hierarchy_Controller_method_1();
    arw = new ACEReporting_RevMarg_WaterFall();
    arw.CustListOverviewReportData1();
    Test.stopTest();
    }
    
    static testMethod void CustListOverviewReportData27()
    {
    initialValOverviewReportData27();   
    Test.startTest();
    ACE_User_Cust_Hierarchy_Controller_method_1();
    arw = new ACEReporting_RevMarg_WaterFall();
    arw.CustListOverviewReportData1();
    Test.stopTest();
    }
    
    static testMethod void CustListOverviewReportData28()
    {
    initialValOverviewReportData28();   
    Test.startTest();
    ACE_User_Cust_Hierarchy_Controller_method_1();
    arw = new ACEReporting_RevMarg_WaterFall();
    arw.CustListOverviewReportData1();
    Test.stopTest();
    }
    
    static testMethod void CustListOverviewReportData29()
    {
    initialValOverviewReportData29();   
    Test.startTest();
    ACE_User_Cust_Hierarchy_Controller_method_1();
    arw = new ACEReporting_RevMarg_WaterFall();
    arw.CustListOverviewReportData1();
    Test.stopTest();
    }
    
    static testMethod void CustListOverviewReportData30()
    {
    initialValOverviewReportData30();   
    Test.startTest();
    ACE_User_Cust_Hierarchy_Controller_method_1();
    arw = new ACEReporting_RevMarg_WaterFall();
    arw.CustListOverviewReportData1();
    Test.stopTest();
    }
    
     static testMethod void CustListOverviewReportData31()
    {
    initialValOverviewReportData31();   
    Test.startTest();
    ACE_User_Cust_Hierarchy_Controller_method_1();
    arw = new ACEReporting_RevMarg_WaterFall();
    arw.CustListOverviewReportData1();
    Test.stopTest();
    }
    
    static testMethod void CustListOverviewReportData32()
    {
    initialValOverviewReportData32();   
    Test.startTest();
    ACE_User_Cust_Hierarchy_Controller_method_1();
    arw = new ACEReporting_RevMarg_WaterFall();
    arw.CustListOverviewReportData1();
    Test.stopTest();
    }
    
    static testMethod void CustListOverviewReportData33()
    {
    initialValOverviewReportData33();   
    Test.startTest();
    ACE_User_Cust_Hierarchy_Controller_method_1();
    arw = new ACEReporting_RevMarg_WaterFall();
    arw.CustListOverviewReportData1();
    Test.stopTest();
    }
    
    static testMethod void CustListOverviewReportData34()
    {
    initialValOverviewReportData34();   
    Test.startTest();
    ACE_User_Cust_Hierarchy_Controller_method_1();
    arw = new ACEReporting_RevMarg_WaterFall();
    arw.CustListOverviewReportData1();
    Test.stopTest();
    }
    
    static testMethod void CustListOverviewReportData35()
    {
    initialValOverviewReportData35();   
    Test.startTest();
    ACE_User_Cust_Hierarchy_Controller_method_1();
    arw = new ACEReporting_RevMarg_WaterFall();
    arw.CustListOverviewReportData1();
    Test.stopTest();
    }
    
    static testMethod void CustListOverviewReportData36()
    {
    initialValOverviewReportData36();   
    Test.startTest();
    ACE_User_Cust_Hierarchy_Controller_method_1();
    arw = new ACEReporting_RevMarg_WaterFall();
    arw.CustListOverviewReportData1();
    Test.stopTest();
    }
    
    static testMethod void loadDataRemediation()
    {
    initialVal();   
    Test.startTest();
    ACE_User_Cust_Hierarchy_Controller_method();
    arw = new ACEReporting_RevMarg_WaterFall();
    arw.loadDataRemediation();
    Test.stopTest();
    }
    
     static testMethod void loadDataHostedCatalog()
    {
    initialVal();   
    loadDataHostedCatalog_Case();
    reportType = 'Hosted Catalog';
    ApexPages.CurrentPage().getParameters().put('reportType',reportType);
    Test.startTest();
//    ACE_User_Cust_Hierarchy_Controller_method();
    ACEReporting_RevMarg_WaterFall arw1 = new ACEReporting_RevMarg_WaterFall();
    
    arw1.loadDataHostedCatalog();
    
    Test.stopTest();
    }
    
     static testMethod void loadDataHostedCatalog_SalesOpsUser()
    {
    User runAsUser = loadChangeTypeData_User();
    System.runAs(runAsUser)
    {
    initialVal();   
    loadDataHostedCatalog_Case();
    reportType = 'Hosted Catalog';
    ApexPages.CurrentPage().getParameters().put('reportType',reportType);
    Test.startTest();
 //   ACE_User_Cust_Hierarchy_Controller_method();
    ACEReporting_RevMarg_WaterFall arw1 = new ACEReporting_RevMarg_WaterFall();
    arw1.loadDataHostedCatalog();
    Test.stopTest();
    }
    
    }
    
    static testMethod void loadDataProcessPipeline()
    {
    initialVal();   
    Test.startTest();
    ACE_User_Cust_Hierarchy_Controller_method();
    arw = new ACEReporting_RevMarg_WaterFall();
    arw.loadDataProcessPipeline();
    Test.stopTest();
    }
    
    static testMethod void doExpand()
    {
    initialVal();   
    Test.startTest();
    ACE_User_Cust_Hierarchy_Controller_method();
    arw = new ACEReporting_RevMarg_WaterFall();
    arw.doExpand();
    Test.stopTest();
    }
    
    static testMethod void getQtrs()
    {
    initialVal();   
    Test.startTest();
    ACE_User_Cust_Hierarchy_Controller_method();
    arw = new ACEReporting_RevMarg_WaterFall();
    List<selectOption> opt = arw.getQtrs();
    Test.stopTest();
    }
    
    static testMethod void getDisablePrevious()
    {
    initialVal();   
    Test.startTest();
    ACE_User_Cust_Hierarchy_Controller_method();
    arw = new ACEReporting_RevMarg_WaterFall();
    Boolean check1 = arw.getDisablePrevious();
    Test.stopTest();
    }
    
    static testMethod void getDisableNext()
    {
    initialVal();   
    Test.startTest();
    ACE_User_Cust_Hierarchy_Controller_method();
    arw = new ACEReporting_RevMarg_WaterFall();
    Boolean check2 = arw.getDisableNext();
    Test.stopTest();
    }
    
    static testMethod void loadExceptionData()
    {
    initialVal();   
    reportType = 'Exception';
    ApexPages.CurrentPage().getParameters().put('reportType',reportType);
    Test.startTest();
    
    ACE_User_Cust_Hierarchy_Controller_method();
    arw = new ACEReporting_RevMarg_WaterFall();
    
    arw.loadExceptionData();
    
    Test.stopTest();
    }
    
    static testMethod void HostedCatalogReportCustList()
    {
    initialVal();   
    loadDataHostedCatalog_Case();
    Test.startTest();
    //ACE_User_Cust_Hierarchy_Controller_method();
    listType = 'ImpactedCustomer';
    ApexPages.CurrentPage().getParameters().put('listType',listType);
    arw = new ACEReporting_RevMarg_WaterFall();
    arw.HostedCatalogReportCustList();
    /*
    listType = 'WRFCaseCount';
    ApexPages.CurrentPage().getParameters().put('listType',listType);
    ACE_User_Cust_Hierarchy_Controller_method();
    ACEReporting_RevMarg_WaterFall arw1 = new ACEReporting_RevMarg_WaterFall();
    arw1.HostedCatalogReportCustList();
    
    listType = 'WRFCompletedCaseCount';
    ApexPages.CurrentPage().getParameters().put('listType',listType);
    ACE_User_Cust_Hierarchy_Controller_method();
    ACEReporting_RevMarg_WaterFall arw2 = new ACEReporting_RevMarg_WaterFall();
    arw2.HostedCatalogReportCustList();
    
    listType = 'RevenueCount';
    ApexPages.CurrentPage().getParameters().put('listType',listType);
    ACE_User_Cust_Hierarchy_Controller_method();
    ACEReporting_RevMarg_WaterFall arw3 = new ACEReporting_RevMarg_WaterFall();
    arw3.HostedCatalogReportCustList();
    */
    Test.stopTest();
    }
    
    
    static testMethod void initialVal()
    {
        
        ACE_Batches__c aceBatch = new ACE_Batches__c();
        aceBatch.Name = 'Q4-2014';
        aceBatch.Batch__c = 'Q4-2014';
        
        insert aceBatch;

        reportType = 'Summary by Sector/Segment';//madhavi
        SegmentName = 'Public';
        SegmentType = '';
        ReportName = 'Erosion';
        ErosionType = 'Date';
        quarter = 'Q4-2014';
        ColumnVal = 'callme';
        rowname = '100PercentPricePassThru';
        listType = 'Implemented';
        

        Test.setCurrentPage(Page.ACEReportHomePage);
        ApexPages.CurrentPage().getParameters().put('reportType',reportType);
        ApexPages.CurrentPage().getParameters().put('Segment',SegmentName);
        ApexPages.CurrentPage().getParameters().put('SegmentType',SegmentType);
        ApexPages.CurrentPage().getParameters().put('Val',ReportName);
        ApexPages.CurrentPage().getParameters().put('ErosionType',ErosionType);
        ApexPages.CurrentPage().getParameters().put('quarter',quarter);
        ApexPages.CurrentPage().getParameters().put('Column',ColumnVal);
        ApexPages.CurrentPage().getParameters().put('rowName',rowName);
        ApexPages.CurrentPage().getParameters().put('listtype',listtype);
        
        system.debug('SegmentName:'+SegmentName+' reportType:'+reportType);
    }
    
    static testMethod void ACE_User_Cust_Hierarchy_Controller_method()
    {
         ACE_Settings__c desettings = new ACE_Settings__c();
         insert desettings; 
         
         Account acc = new Account (name = 'SUN Test Account',AOPS_Seq_ID__c = '123456',AOPS_Cust_Id__c = '123456',Oracle_Party_Id__c = '123456',Billingcountry = 'USA',BillingState = 'UT',BillingStreet = '1040 N 326 W',billingcity = 'Orem', type='Customer');
         acc.Industry_OD_SIC_Rep__c = 'Public';
         insert acc; 
         
          ace1 = new ACE_Customer_Price_Changes__c(name='Q4-2014',SRM_Differential__c=5,record_unlock_Status__c='open',Item_12_Month_Qty__c = 50,Total_Spend_Impact_12_Month__c=5,Customer__c = acc.id, Owning_Customer_ID__c ='123456', SFDC_Notification_Flag__c = '3',Hosted_Catalog__c=true);
          ace1.CallMeRequest__c = true;
          ace1.Customer_Response__c = 'Call Me';
          ace1.PRICE_NOT_CALCULATED__c = false;
          ace1.Report_isSKU_Exception__c=false;
          ace1.Report_SKU_Count__c =3;
         insert ace1;      
       
        
         ApexPages.currentPage().getParameters().Put('id',ace1.id);
         Ace_Customer_Core_Changes__c CCCC = new Ace_Customer_Core_Changes__c();
         CCCC.name='Name';
         CCCC.ACE_Customer_Price_Changes__c=ace1.id;
         CCCC.CoreID__c='alpha';
         insert CCCC;
         
         
         sku1 = new ACE_Customer_sku_Changes__c(name='test',SKU__c='123456',Ace_Customer_Core_Changes__c = CCCC.id);
         sku1.batchid__c = quarter;
         sku1.PRICE_NOT_CALCULATED__c = false;
         sku1.price_changes_type__c = 'B';
         sku1.status__c = 'Active';
         insert sku1;
         
        ACE_Customer_MailOut__c aceCMO = new ACE_Customer_MailOut__c();
        aceCMO.Notification_Date__c = Date.today();
        aceCMO.Reporting_Accepted_Date__c = datetime.now(); 
        aceCMO.Customer_Core_Price_Changes__c = ace1.id;
        aceCMO.Customer_SKU_Changes__c = sku1.id;
        aceCMO.Email_Template_Code__c ='3';
        insert aceCMO;
        
        //ACEPublicSegments__c acePubSeg = new ACEPublicSegments__c();
        //acePubSeg.Name = 'Public';
        //acePubSeg.Segment_Name__c = 'Public';
        //insert acePubSeg;
        
        //ACEPrivateSegments__c acePriSeg = new ACEPrivateSegments__c();
        //acePriSeg.Name = 'Private';
        //acePriSeg.Segment_Name__c = 'Private';
        //insert acePriSeg;
        
     }
     static testMethod User loadChangeTypeData_User()
     {
         Profile profileObj = [select id from profile where name='System Administrator'];

         String profId = profileObj.id;
         user usrObj = new user(Username='abc@officedepot.com.uat',FirstName ='Fname', LastName='Lname', Alias='abc', CommunityNickname='abc', LocaleSidKey='en_US', EmailEncodingKey='UTF-8', Profileid = profId, LanguageLocaleKey='en_US', email='abc@officedepot.com.uat',TimeZoneSidKey='America/New_York');
         Insert usrObj;

         Group grpObj = [select id,name from group where name in ('Sales Ops Team')];
         groupMember gmObj = new groupMember();
         gmObj.groupid = grpObj.Id;
         gmObj.UserOrGroupId = usrObj.Id;
         insert gmObj;
         
         return usrObj;

     }
     static testMethod void loadDataHostedCatalog_Case()
     {
     
        ACE_Settings__c aceSE = new ACE_Settings__c();
        aceSE.Domain_URL__c = 'https://officedepot--uat.cs7.my.salesforce.com';
        insert aceSE;
        
        List<case> cases = new List<case>();
        
        Case case1 = new Case();
        case1.Price_Change_Link__c = aceSE.Domain_URL__c;
        case1.WRF_Request_Type__c = 'BSD Pricing';
        case1.Status = 'Open';
        cases.add(case1);
        
        
        Case case2 = new Case();
        case2.Price_Change_Link__c = aceSE.Domain_URL__c;
        case2.WRF_Request_Type__c = 'BSD Pricing';
        case2.IT_Action_Taken__c='Completed';
        case2.Status = 'Closed';
        cases.add(case2);
        
        Case case3 = new Case();
        case3.Price_Change_Link__c = aceSE.Domain_URL__c;
        case3.WRF_Request_Type__c = 'BSD Pricing';
        case3.IT_Action_Taken__c='Completed';
        case3.Status = 'Closed';
        cases.add(case3);
        
        insert cases;
        
     }
         
    
}