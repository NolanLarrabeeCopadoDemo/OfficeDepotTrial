//
// (c) 2015 Appirio, Inc.
//
//
// 15 August 2015     Ryan Marquardt     Story S-335198
//
@isTest
private class ACEUpload_File_TC
{
    static testMethod void myUnitTest()
    {
        String inputval='100';
        ACE_Settings__c desettings = new ACE_Settings__c();
        insert desettings;
        Account acc = new Account (name = 'SUN Test Account',AOPS_Seq_ID__c = '123456',AOPS_Cust_Id__c = '123456',Oracle_Party_Id__c = '123456',Billingcountry = 'USA',BillingState = 'UT',BillingStreet = '1040 N 326 W',billingcity = 'Orem');
        insert acc;

        ACE_Customer_Price_Changes__c ace1 = new ACE_Customer_Price_Changes__c(name='Q2-2014',batchID__c = 'Q2-2014', SRM_Differential__c=5,Item_12_Month_Qty__c = 50,Total_Spend_Impact_12_Month__c=5,Customer__c = acc.id, Owning_Customer_ID__c ='123456', SFDC_Notification_Flag__c = '3');
        insert ace1;

        Ace_Customer_Core_Changes__c ace2 = new Ace_Customer_Core_Changes__c(name = 'Test',CoreID__c = '123456', ACE_Customer_Price_Changes__c = ace1.id);
        insert ace2;

        Ace_Customer_SKU_Changes__c ace3 = new Ace_Customer_SKU_Changes__c(SKU__c = '478518',CoreList_ID__c = 'CL-9615525', name='test', Ace_Customer_Core_Changes__c = ace2.id); //S-407207 [OD Case # 00678706] - Hemant 5/6/2016
        insert ace3;

         //RMarquardt S-335198 7.17.2015 Start
         Ace_Customer_Core_Changes__c ace4 = new Ace_Customer_Core_Changes__c(name = 'Test',CoreID__c = '123456', ACE_Customer_Price_Changes__c = ace1.id);
         insert ace4;

         Ace_Customer_SKU_Changes__c ace5 = new Ace_Customer_SKU_Changes__c(SKU__c = '123456',name='test', Ace_Customer_Core_Changes__c = ace2.id,Price_Changes_Type__c = 'A');
         insert ace5;
         //RMarquardt S-335198 7.17.2015 Stop

         //S-434786 (OD 00777602) Connor Flynn 
         Ace_Customer_SKU_Changes__c ace6 = new Ace_Customer_SKU_Changes__c(SKU__c = '478519',name='test', CoreList_ID__c = 'CL-9615525', Ace_Customer_Core_Changes__c = ace2.id,Price_Changes_Type__c = 'A');
         insert ace6;
        //S-434786 (OD 00777602) Connor Flynn End

        ApexPages.currentPage().getParameters().put('selectedCustomer',ace1.id);

        ACEUpload_File ACuploadfile=new ACEUpload_File();
        /*//RMarquardt S-335198 7.17.2015 Start
        ACuploadfile.contentFile=Blob.valueOf('Action,Current Price Method,Contract Id,SKU,SKU Description,Proposed IMU %,Proposed Price With Cap,Estimated Annual Spend,Proposed IMU %,Current Sell Price,Current IMU $,Annual Spend Increase,Pricing Method Percentage,Items 12 Month Quantity,Effective Date,Sold,SVT,UOM,SKU QPU,New WA TD Cost,Current Retail Price,Current List Price,Dept ID,Class Id,Private Brand,RMS Procurement Code,Items 12 Month Sales,History Total Cost,Hist IMU Dollars,Hist IMU Percentage,Core ID,Alt SKU,Alt SKU Description,Alt Proposed IMU %,Alt Proposed Price With Cap,Alt Proposed IMU %,Alt Annual Spend Increase,Alt New WA TD Cost,Alt Current Retail Price,Alt Current List Price,Alt UOM,Alt Effective Date,Alt SKU QPU,Alt SKU Currently Purchased,Alt Current Price Method,Alt Method ID,Alt Private Brand,Alt RMS Procurement Code'+ ',Fixed Price,,560483,"PAPER,COLOR LASER,HP,REAM",0.00,6.79,0.00,0.00,7.00,-3.00,0.00,0.00,0,9/13/2014,,,RM,,0.00,,18.70,5,503,,,0.00,,,,CL-9615525,,,,,,,,,,,,,,,,,'+
        ',Fixed Price,,478518,"chairmat,hrdflr,45x53,wide lip",0.00,17.30,0.00,0.00,17.00,-36.00,0.00,0.00,0,9/13/2014,,,EA,,0.00,,109.99,25,169,,,0.00,,,,CL-9615525,,,,,,,,,,,,,,,,,'+
        'Alt,Fixed Price,,477986,"chairmat,cleatmat,46x60,utilty",0.00,27.13,0.00,0.00,27.00,-61.00,0.00,0.00,0,9/13/2014,,,EA,,0.00,,169.99,25,169,,,0.00,,,,CL-9615525,,,,,,,,,,,,,,,,,'
        );             */
        // Modified by Mohit for Story S-S-350563 //
       /* ACuploadfile.contentFile=Blob.valueOf('Action,Current Price Method,Contract Id,SKU,SKU Description,Proposed IMU %,Proposed Price With Cap,Estimated Annual Spend,Proposed IMU %,Current Sell Price,Current IMU $,Annual Spend Increase,Pricing Method Percentage,Items 12 Month Quantity,Sold,SVT,UOM,SKU QPU,New WA TD Cost,Current Retail Price,Current List Price,Dept ID,Class Id,Private Brand,RMS Procurement Code,Items 12 Month Sales,History Total Cost,Hist IMU Dollars,Hist IMU Percentage,Core ID,Alt SKU,Alt SKU Description,Alt Proposed IMU %,Alt Proposed Price With Cap,Alt Proposed IMU %,Alt Annual Spend Increase,Alt New WA TD Cost,Alt Current Retail Price,Alt Current List Price,Alt UOM,Alt Effective Date,Alt SKU QPU,Alt SKU Currently Purchased,Alt Current Price Method,Alt Method ID,Alt Private Brand,Alt RMS Procurement Code,,,,,,,'+ ',Fixed Price,,560483,"PAPER,COLOR LASER,HP,REAM",0.00,6.79,0.00,0.00,7.00,-3.00,0.00,0.00,0,9/13/2014,,,RM,,0.00,,18.70,5,503,,,0.00,,,,CL-9615525,,,,,,,,,,,,,,,,,,,,,,,,\n'+
        'Alt,Fixed Price,,478518,"chairmat,hrdflr,45x53,wide lip",0.00,17.30,0.00,0.00,17.00,-36.00,0.00,0.00,0,9/13/2014,test,test,EA,test,0.00,0,109.99,25,169,11,12,0.00,13,14,15,CL-9615525,16,17,18,19,20,21,22,23,24,25,9/15/2015,26,27,28,29,30,"stringText,stringText,\n'+//S-407207 [OD Case # 00678706] - Hemant 5/6/2016
        'Alt,Fixed Price,,477986,"chairmat,cleatmat,46x60,utilty",0.00,27.13,0.00,0.00,27.00,-61.00,0.00,0.00,0,9/14/2014,test,test,EA,test,0.00,0,109.99,25,169,11,12,0.00,13,14,15,CL-9615525,16,17,18,19,20,21,22,23,24,25,9/16/2015,26,27,28,29,30,"stringText,stringText,\n' +//S-407207 [OD Case # 00678706] - Hemant 5/6/2016
        //S-434786 (OD 00777602) Connor Flynn  Adding another row without action
        ',Fixed Price,,123456,"chairmat,cleatmat,46x60,utilty",0.00,27.13,0.00,0.00,27.00,-61.00,0.00,0.00,0,9/14/2014,test,test,EA,test,0.00,0,109.99,25,169,11,12,0.00,13,14,15,,16,17,18,19,20,21,22,23,24,25,9/16/2015,26,27,28,29,30,"stringText,stringText,\n'
        //S-434786 (OD 00777602) Connor Flynn 
        );*/
        ACuploadfile.contentFile=Blob.valueOf('Action,Current Price Method,Contract Id,SKU,SKU Description,List Price,Target QPU,Alt QPU,Change Type,SKU Governed By Active Written Agreement,New WAPO Cost,Old WAPO Cost,Vendor Letter Requirement,Customer SKU Cap %,SKU Last Change Date,Proposed IMU %,Proposed Price With Cap,Estimated Annual Spend,Proposed IMU %,Current Sell Price,Current IMU $,Annual Spend Increase,Pricing Method Percentage,Items 12 Month Quantity,Effective Date,Sold,SVT,UOM,New WA TD Cost,Current Retail Price,Current List Price,Dept ID,Class Id,Private Brand,RMS Procurement Code,Items 12 Month Sales,History Total Cost,Hist IMU Dollars,Hist IMU Percentage,Core ID,Alt SKU,Alt SKU Description,Alt Proposed IMU %,Alt Proposed Price With Cap,Alt Proposed IMU %,Alt Annual Spend Increase,Alt New WA TD Cost,Alt Current Retail Price,Alt Current List Price,Alt UOM,Alt Effective Date,Alt SKU Currently Purchased,Alt Current Price Method,Alt Method ID,Alt Private Brand,Alt RMS Procurement Code\n'+',DFZ,800E000000097SpIAI,433377,"INK,DUAL PACK,EPSON,BLACK",34.99,,,M,,23.15,23.15,1,5,Fri Aug 01 00:00:00 GMT 2014,0,29.74,0,0,29.74,18,0,15,0,4/27/2017,,,PK,24.49,,34.99,14,872,,,0,,,,CL-9019079,,,,,,,,,,,,,,,,\n'
        +',DFZ,800E000000097SpIAI,397429,"TONER,C748,HY,BLACK",228.51,,,M,,153.1,153.1,1,5,Fri Aug 01 00:00:00 GMT 2014,0,167.01,0,0,167.01,4,0,15,0,4/27/2017,,,EA,160.39,,228.51,65,144,,,0,,,,CL-9019079,,,,,,,,,,,,,,,,\n'
        +',DFZ,800E000000097SpIAI,320434,"TONER,HP 42A/42X,EXTENDED LIFE",331.5,,,M,,99.75,99.75,1,5,Fri Aug 01 00:00:00 GMT 2014,0,263.49,0,0,263.49,59,0,15,0,4/27/2017,,,EA,108.37,,331.5,65,144,,,0,,,,CL-9019079,,,,,,,,,,,,,,,,\n'
        );
        //RMarquardt S-335198 7.17.2015 Stop
        ACEUpload_File.CSVWrapper csvwrapper=new ACEUpload_File.CSVWrapper();
        ACEUpload_File.csvErrList csverrlist=new ACEUpload_File.csvErrList();
        ACuploadfile.doublevalue(inputval);
        ACuploadfile.Remedy_ReadFile();

    //RMarquardt S-335198 7.17.2015 Start
        ACuploadfile.fileToUpload = 'test';
        ACuploadfile.content = Blob.valueOf('test');
        ACuploadfile.IsRemedy = true;
        ACuploadfile.renderErrTable = false;
        ACuploadfile.fileNameRem = 'test';
        ACuploadfile.fileNameHost = 'test';
        ACuploadfile.content1 = Blob.valueOf('test');

        //strings
        csvwrapper.Action='stringText';
        csvwrapper.CurrentMethod='stringText';
        csvwrapper.ContractId='stringText';
        csvwrapper.SKU='stringText';
        csvwrapper.SKUDesc='stringText';
        csvwrapper.Sold='stringText';
        csvwrapper.SVT='stringText';
        csvwrapper.UOM='stringText';
        csvwrapper.SKUQPU='stringText';
        csvwrapper.DeptId='stringText';
        csvwrapper.ClassId='stringText';
        csvwrapper.PrivateBand='stringText';
        csvwrapper.RMSProcCode='stringText';
        csvwrapper.AddToCore='stringText';
        csvwrapper.ASKU='stringText';
        csvwrapper.ASKUDesc='stringText';
        csvwrapper.AUOM='stringText';
        csvwrapper.APriceMethod='stringText';
        csvwrapper.AMethodId='stringText';
        csvwrapper.APrivateBand='stringText';
        csvwrapper.AProcFlag='stringText';
        csvwrapper.Identifier ='9615525';
        csvwrapper.AIdentifier ='9615525';

        //decimals
        csvwrapper.PropIMU=0.01;
        csvwrapper.PropPrice=0.01;
        csvwrapper.EstAnnualSpend=0.01;
        csvwrapper.PropIMUDoll=0.01;
        csvwrapper.CurrSellPrice=0.01;
        csvwrapper.CurrSKUIMU=0.01;
        csvwrapper.AnnSpendInc=0.01;
        csvwrapper.PriceMethodPer=0.01;
        csvwrapper.Item12MonthQnty=0.01;
        csvwrapper.NewWATDCost=0.01;
        csvwrapper.CurrRetPrice=0.01;
        csvwrapper.CurrListPrice=0.01;
        csvwrapper.Item12MonthSale=0.01;
        csvwrapper.HisTotCost=0.01;
        csvwrapper.HisIMUPer=0.01;
        csvwrapper.HisIMUDoll=0.01;
        csvwrapper.APropIMU=0.01;
        csvwrapper.APropPrice=0.01;
        csvwrapper.APropPriceIMUDoll=0.01;
        csvwrapper.AAnnSpndInc=0.01;
        csvwrapper.ANewWATDCost=0.01;
        csvwrapper.ACurrRetPrice=0.01;
        csvwrapper.ACurrListPrice=0.01;
        csvwrapper.ASKUQPU=0.01;
        csvwrapper.ASKUCurrPurch=0.01;

        //dates
        csvwrapper.AEffDate=Date.today();
        csvwrapper.EffDate=Date.today();


        csverrlist.SKU='stringText';
        csverrlist.ErrorMsg='stringText';
    //RMarquardt S-335198 7.17.2015 Stop

    }
      // Added for Story S-374379
        static testMethod void myUnitTest2()
    {
        String inputval='100';
        ACE_Settings__c desettings = new ACE_Settings__c();
        insert desettings;
        Account acc = new Account (name = 'SUN Test Account',AOPS_Seq_ID__c = '123456',AOPS_Cust_Id__c = '123456',Oracle_Party_Id__c = '123456',Billingcountry = 'USA',BillingState = 'UT',BillingStreet = '1040 N 326 W',billingcity = 'Orem');
        insert acc;

        ACE_Customer_Price_Changes__c ace1 = new ACE_Customer_Price_Changes__c(name='Q2-2014',batchID__c = 'Q2-2014', SRM_Differential__c=5,Item_12_Month_Qty__c = 50,Total_Spend_Impact_12_Month__c=5,Customer__c = acc.id, Owning_Customer_ID__c ='123456', SFDC_Notification_Flag__c = '3');
        insert ace1;

        Ace_Customer_Core_Changes__c ace2 = new Ace_Customer_Core_Changes__c(name = 'Test',CoreID__c = '123456', ACE_Customer_Price_Changes__c = ace1.id);
        insert ace2;

        Ace_Customer_SKU_Changes__c ace3 = new Ace_Customer_SKU_Changes__c(SKU__c = '123456',name='test', Ace_Customer_Core_Changes__c = ace2.id);
        insert ace3;

         Ace_Customer_Core_Changes__c ace4 = new Ace_Customer_Core_Changes__c(name = 'Test',CoreID__c = '123456', ACE_Customer_Price_Changes__c = ace1.id);
         insert ace4;

         Ace_Customer_SKU_Changes__c ace5 = new Ace_Customer_SKU_Changes__c(SKU__c = '123456',CoreList_ID__c='123456',name='test', Ace_Customer_Core_Changes__c = ace2.id,Price_Changes_Type__c = 'A');
         insert ace5;

        ApexPages.currentPage().getParameters().put('selectedCustomer',ace1.id);

        ACEUpload_File ACuploadfile=new ACEUpload_File();

       /* ACuploadfile.contentFile=Blob.valueOf('Action,Current Price Method,Contract Id,SKU,SKU Description,Proposed IMU %,Proposed Price With Cap,Estimated Annual Spend,Proposed IMU %,Current Sell Price,Current IMU $,Annual Spend Increase,Pricing Method Percentage,Items 12 Month Quantity,Effective Date,Sold,SVT,UOM,SKU QPU,New WA TD Cost,Current Retail Price,Current List Price,Dept ID,Class Id,Private Brand,RMS Procurement Code,Items 12 Month Sales,History Total Cost,Hist IMU Dollars,Hist IMU Percentage,Core ID,Alt SKU,Alt SKU Description,Alt Proposed IMU %,Alt Proposed Price With Cap,Alt Proposed IMU %,Alt Annual Spend Increase,Alt New WA TD Cost,Alt Current Retail Price,Alt Current List Price,Alt UOM,Alt Effective Date,Alt SKU QPU,Alt SKU Currently Purchased,Alt Current Price Method,Alt Method ID,Alt Private Brand,Alt RMS Procurement Code'+ ',Fixed Price,,560483,"PAPER,COLOR LASER,HP,REAM",0.00,6.79,0.00,0.00,7.00,-3.00,0.00,0.00,0,9/13/2014,,,RM,,0.00,,18.70,5,503,,,0.00,,,,CL-9615525,,,,,,,,,,,,,,,,,\n'+
        'New,Fixed Price,,478518,"chairmat,hrdflr,45x53,wide lip",0.00,17.30,0.00,0.00,17.00,-36.00,0.00,0.00,0,9/13/2014,,,EA,,0.00,,109.99,25,169,,,0.00,,,,CL-9615525,,,,,,,,,,,,,,,"stringText,stringText,\n'+
        'New,Fixed Price,,477986,"chairmat,cleatmat,46x60,utilty",0.00,27.13,0.00,0.00,27.00,-61.00,0.00,0.00,0,9/13/2014,,,EA,,0.00,,169.99,25,169,,,0.00,,,,CL-9615525,,,,,,,,,,,,,,,,,\n'
        );*/
         ACuploadfile.contentFile=Blob.valueOf('Action,Current Price Method,Contract Id,SKU,SKU Description,List Price,Target QPU,Alt QPU,Change Type,SKU Governed By Active Written Agreement,New WAPO Cost,Old WAPO Cost,Vendor Letter Requirement,Customer SKU Cap %,SKU Last Change Date,Proposed IMU %,Proposed Price With Cap,Estimated Annual Spend,Proposed IMU %,Current Sell Price,Current IMU $,Annual Spend Increase,Pricing Method Percentage,Items 12 Month Quantity,Effective Date,Sold,SVT,UOM,New WA TD Cost,Current Retail Price,Current List Price,Dept ID,Class Id,Private Brand,RMS Procurement Code,Items 12 Month Sales,History Total Cost,Hist IMU Dollars,Hist IMU Percentage,Core ID,Alt SKU,Alt SKU Description,Alt Proposed IMU %,Alt Proposed Price With Cap,Alt Proposed IMU %,Alt Annual Spend Increase,Alt New WA TD Cost,Alt Current Retail Price,Alt Current List Price,Alt UOM,Alt Effective Date,Alt SKU Currently Purchased,Alt Current Price Method,Alt Method ID,Alt Private Brand,Alt RMS Procurement Code\n'+',DFZ,800E000000097SpIAI,123456,"INK,DUAL PACK,EPSON,BLACK",34.99,,,M,,23.15,23.15,1,5,Fri Aug 01 00:00:00 GMT 2014,0,29.74,0,0,29.74,18,0,15,0,4/27/2017,,,PK,24.49,,34.99,14,872,,,0,,,123456,123456,,,,,,,,,,,,,,,,\n'
        +'Alt,DFZ,800E000000097SpIAI,123456,"TONER,C748,HY,BLACK",228.51,,,M,,153.1,153.1,1,5,Fri Aug 01 00:00:00 GMT 2014,0,167.01,0,0,167.01,4,0,15,0,4/27/2017,,,EA,160.39,,228.51,65,144,,,0,,,,123456,123456,"testAltDesc",0,0,0,0,0,0,0,0,4/27/2017,0,A,A,A,A\n'
        +'New,DFZ,800E000000097SpIAI,320434,"TONER,HP 42A/42X,EXTENDED LIFE",331.5,,,M,,99.75,99.75,1,5,Fri Aug 01 00:00:00 GMT 2014,0,263.49,0,0,263.49,59,0,15,0,4/27/2017,,,EA,108.37,,331.5,65,144,,,0,,,,CL-9019079,,,,,,,,,,,,,,,,\n'
        );
        ACEUpload_File.CSVWrapper csvwrapper=new ACEUpload_File.CSVWrapper();
        ACEUpload_File.csvErrList csverrlist=new ACEUpload_File.csvErrList();
        ACuploadfile.doublevalue(inputval);
        ACuploadfile.Remedy_ReadFile();

        ACuploadfile.fileToUpload = 'test';
        ACuploadfile.content = Blob.valueOf('test');
        ACuploadfile.IsRemedy = true;
        ACuploadfile.renderErrTable = false;
        ACuploadfile.fileNameRem = 'test';
        ACuploadfile.fileNameHost = 'test';
        ACuploadfile.content1 = Blob.valueOf('test');

        //strings
        csvwrapper.Action='stringText';
        csvwrapper.CurrentMethod='stringText';
        csvwrapper.ContractId='stringText';
        csvwrapper.SKU='stringText';
        csvwrapper.SKUDesc='stringText';
        csvwrapper.Sold='stringText';
        csvwrapper.SVT='stringText';
        csvwrapper.UOM='stringText';
        csvwrapper.SKUQPU='stringText';
        csvwrapper.DeptId='stringText';
        csvwrapper.ClassId='stringText';
        csvwrapper.PrivateBand='stringText';
        csvwrapper.RMSProcCode='stringText';
        csvwrapper.AddToCore='stringText';
        csvwrapper.ASKU='stringText';
        csvwrapper.ASKUDesc='stringText';
        csvwrapper.AUOM='stringText';
        csvwrapper.APriceMethod='stringText';
        csvwrapper.AMethodId='stringText';
        csvwrapper.APrivateBand='stringText';
        csvwrapper.AProcFlag='stringText';
        csvwrapper.Identifier ='9615525';
        csvwrapper.AIdentifier ='9615525';

        //decimals
        csvwrapper.PropIMU=0.01;
        csvwrapper.PropPrice=0.01;
        csvwrapper.EstAnnualSpend=0.01;
        csvwrapper.PropIMUDoll=0.01;
        csvwrapper.CurrSellPrice=0.01;
        csvwrapper.CurrSKUIMU=0.01;
        csvwrapper.AnnSpendInc=0.01;
        csvwrapper.PriceMethodPer=0.01;
        csvwrapper.Item12MonthQnty=0.01;
        csvwrapper.NewWATDCost=0.01;
        csvwrapper.CurrRetPrice=0.01;
        csvwrapper.CurrListPrice=0.01;
        csvwrapper.Item12MonthSale=0.01;
        csvwrapper.HisTotCost=0.01;
        csvwrapper.HisIMUPer=0.01;
        csvwrapper.HisIMUDoll=0.01;
        csvwrapper.APropIMU=0.01;
        csvwrapper.APropPrice=0.01;
        csvwrapper.APropPriceIMUDoll=0.01;
        csvwrapper.AAnnSpndInc=0.01;
        csvwrapper.ANewWATDCost=0.01;
        csvwrapper.ACurrRetPrice=0.01;
        csvwrapper.ACurrListPrice=0.01;
        csvwrapper.ASKUQPU=0.01;
        csvwrapper.ASKUCurrPurch=0.01;

        //dates
        csvwrapper.AEffDate=Date.today();
        csvwrapper.EffDate=Date.today();


        csverrlist.SKU='stringText';
        csverrlist.ErrorMsg='stringText';

    }
    // Added for Story S-374379
            static testMethod void myUnitTest3()
    {
        String inputval='100';
        ACE_Settings__c desettings = new ACE_Settings__c();
        insert desettings;
        Account acc = new Account (name = 'SUN Test Account',AOPS_Seq_ID__c = '123456',AOPS_Cust_Id__c = '123456',Oracle_Party_Id__c = '123456',Billingcountry = 'USA',BillingState = 'UT',BillingStreet = '1040 N 326 W',billingcity = 'Orem');
        insert acc;

        ACE_Customer_Price_Changes__c ace1 = new ACE_Customer_Price_Changes__c(name='Q2-2014',batchID__c = 'Q2-2014', SRM_Differential__c=5,Item_12_Month_Qty__c = 50,Total_Spend_Impact_12_Month__c=5,Customer__c = acc.id, Owning_Customer_ID__c ='123456', SFDC_Notification_Flag__c = '1');
        insert ace1;

        Ace_Customer_Core_Changes__c ace2 = new Ace_Customer_Core_Changes__c(name = 'Test',CoreID__c = '123456', ACE_Customer_Price_Changes__c = ace1.id);
        insert ace2;

        Ace_Customer_SKU_Changes__c ace3 = new Ace_Customer_SKU_Changes__c(SKU__c = '123456',name='test', status__c = 'Active', Change_Type__c = 'A', Ace_Customer_Core_Changes__c = ace2.id);
        insert ace3;

         Ace_Customer_Core_Changes__c ace4 = new Ace_Customer_Core_Changes__c(name = 'Test',CoreID__c = '123456', ACE_Customer_Price_Changes__c = ace1.id);
         insert ace4;

         Ace_Customer_SKU_Changes__c ace5 = new Ace_Customer_SKU_Changes__c(SKU__c = '123456',SKU_ALT__C = '123457', name='test', status__c = 'Deleted', Ace_Customer_Core_Changes__c = ace2.id,Price_Changes_Type__c = 'A');
         insert ace5;

        ApexPages.currentPage().getParameters().put('selectedCustomer',ace1.id);

        ACEUpload_File ACuploadfile=new ACEUpload_File();

       /* ACuploadfile.contentFile=Blob.valueOf('Action,Current Price Method,Contract Id,SKU,SKU Description,Proposed IMU %,Proposed Price With Cap,Estimated Annual Spend,Proposed IMU %,Current Sell Price,Current IMU $,Annual Spend Increase,Pricing Method Percentage,Items 12 Month Quantity,Effective Date,Sold,SVT,UOM,SKU QPU,New WA TD Cost,Current Retail Price,Current List Price,Dept ID,Class Id,Private Brand,RMS Procurement Code,Items 12 Month Sales,History Total Cost,Hist IMU Dollars,Hist IMU Percentage,Core ID,Alt SKU,Alt SKU Description,Alt Proposed IMU %,Alt Proposed Price With Cap,Alt Proposed IMU %,Alt Annual Spend Increase,Alt New WA TD Cost,Alt Current Retail Price,Alt Current List Price,Alt UOM,Alt Effective Date,Alt SKU QPU,Alt SKU Currently Purchased,Alt Current Price Method,Alt Method ID,Alt Private Brand,Alt RMS Procurement Code'+ ',Fixed Price,,560483,"PAPER,COLOR LASER,HP,REAM",0.00,6.79,0.00,0.00,7.00,-3.00,0.00,0.00,0,9/13/2014,,,RM,,0.00,,18.70,5,503,,,0.00,,,,CL-9615525,,,,,,,,,,,,,,,,,\n'+
        'null,Fixed Price,,478518,"chairmat,hrdflr,45x53,wide lip",0.00,17.30,0.00,0.00,17.00,-36.00,0.00,0.00,0,9/13/2014,,,EA,,0.00,,109.99,25,169,,,0.00,,,,CL-9615525,,,,,,,,,,,,,,,"stringText,stringText,\n'+
        'null,Fixed Price,,477986,"chairmat,cleatmat,46x60,utilty",0.00,27.13,0.00,0.00,27.00,-61.00,0.00,0.00,0,9/13/2014,,,EA,,0.00,,169.99,25,169,,,0.00,,,,CL-9615525,,,,,,,,,,,,,,,,,\n'
        );
       
          ACuploadfile.contentFile=Blob.valueOf('Action,Current Price Method,Contract Id,SKU,SKU Description,List Price,Target QPU,Alt QPU,Change Type,SKU Governed By Active Written Agreement,New WAPO Cost,Old WAPO Cost,Vendor Letter Requirement,Customer SKU Cap %,SKU Last Change Date,Proposed IMU %,Proposed Price With Cap,Estimated Annual Spend,Proposed IMU %,Current Sell Price,Current IMU $,Annual Spend Increase,Pricing Method Percentage,Items 12 Month Quantity,Effective Date,Sold,SVT,UOM,New WA TD Cost,Current Retail Price,Current List Price,Dept ID,Class Id,Private Brand,RMS Procurement Code,Items 12 Month Sales,History Total Cost,Hist IMU Dollars,Hist IMU Percentage,Core ID,Alt SKU,Alt SKU Description,Alt Proposed IMU %,Alt Proposed Price With Cap,Alt Proposed IMU %,Alt Annual Spend Increase,Alt New WA TD Cost,Alt Current Retail Price,Alt Current List Price,Alt UOM,Alt Effective Date,Alt SKU Currently Purchased,Alt Current Price Method,Alt Method ID,Alt Private Brand,Alt RMS Procurement Code\n'+',DFZ,800E000000097SpIAI,433377,"INK,DUAL PACK,EPSON,BLACK",34.99,,,M,,23.15,23.15,1,5,Fri Aug 01 00:00:00 GMT 2014,0,29.74,0,0,29.74,18,0,15,0,4/27/2017,,,PK,24.49,,34.99,14,872,,,0,,,,CL-9019079,,,,,,,,,,,,,,,,\n'
        +'null,DFZ,800E000000097SpIAI,397429,"TONER,C748,HY,BLACK",228.51,,,M,,153.1,153.1,1,5,Fri Aug 01 00:00:00 GMT 2014,0,167.01,0,0,167.01,4,0,15,0,4/27/2017,,,EA,160.39,,228.51,65,144,,,0,,,,CL-9019079,,,,,,,,,,,,,,,,\n'
        +'null,DFZ,800E000000097SpIAI,320434,"TONER,HP 42A/42X,EXTENDED LIFE",331.5,,,M,,99.75,99.75,1,5,Fri Aug 01 00:00:00 GMT 2014,0,263.49,0,0,263.49,59,0,15,0,4/27/2017,,,EA,108.37,,331.5,65,144,,,0,,,,CL-9019079,,,,,,,,,,,,,,,,\n'
        );
         */
        ACuploadfile.contentFile=Blob.valueOf('Action,Current Price Method,Contract Id,SKU,SKU Description,List Price,Target QPU,Alt QPU,Change Type,SKU Governed By Active Written Agreement,New WAPO Cost,Old WAPO Cost,Vendor Letter Requirement,Customer SKU Cap %,SKU Last Change Date,Proposed IMU %,Proposed Price With Cap,Estimated Annual Spend,Proposed IMU %,Current Sell Price,Current IMU $,Annual Spend Increase,Pricing Method Percentage,Items 12 Month Quantity,Effective Date,Sold,SVT,UOM,New WA TD Cost,Current Retail Price,Current List Price,Dept ID,Class Id,Private Brand,RMS Procurement Code,Items 12 Month Sales,History Total Cost,Hist IMU Dollars,Hist IMU Percentage,Core ID,Alt SKU,Alt SKU Description,Alt Proposed IMU %,Alt Proposed Price With Cap,Alt Proposed IMU %,Alt Annual Spend Increase,Alt New WA TD Cost,Alt Current Retail Price,Alt Current List Price,Alt UOM,Alt Effective Date,Alt SKU Currently Purchased,Alt Current Price Method,Alt Method ID,Alt Private Brand,Alt RMS Procurement Code\n'+',DFZ,800E000000097SpIAI,433377,"INK,DUAL PACK,EPSON,BLACK",34.99,,,M,,23.15,23.15,1,5,Fri Aug 01 00:00:00 GMT 2014,0,29.74,0,0,29.74,18,0,15,0,,,,PK,24.49,,34.99,14,872,,,0,,,,CL-9019079,,,,,,,,,,,,,,,,\n'
        +',DFZ,800E000000097SpIAI,,"TONER,C748,HY,BLACK",228.51,,,M,,153.1,153.1,1,5,Fri Aug 01 00:00:00 GMT 2014,0,,0,0,167.01,4,0,15,0,,,,EA,160.39,,228.51,65,144,,,0,,,,CL-9019079,,,,,,,,,,,,,,,,\n'
        +',DFZ,800E000000097SpIAI,320434,"TONER,HP 42A/42X,EXTENDED LIFE",331.5,,,M,,99.75,99.75,1,5,Fri Aug 01 00:00:00 GMT 2014,0,263.49,0,0,263.49,59,0,15,0,,,,EA,108.37,,331.5,65,144,,,0,,,,CL-9019079,,,,,,,,,,,,,,,,\n'
        +',DFZ,800E000000097SpIAI,,,228.51,,,M,,153.1,153.1,1,5,Fri Aug 01 00:00:00 GMT 2014,0,,0,0,167.01,4,0,15,0,,,,EA,160.39,,228.51,65,144,,,0,,,,CL-9019079,,,,,,,,,,,,,,,,\n'
        +',DFZ,800E000000097SpIAI,123456,"TONER,C748,HY,BLACK",228.51,,,M,,153.1,153.1,1,5,Fri Aug 01 00:00:00 GMT 2014,0,,0,0,167.01,4,0,15,0,,,,EA,160.39,,228.51,65,144,,,0,,,,123456,123457,"test",0,0,0,0,0,0,0,0,0,0,0,0,0,0\n'                                      
        +'Alt,DFZ,800E000000097SpIAI,123456,"TONER,C748,HY,BLACK",228.51,,,M,,153.1,153.1,1,5,Fri Aug 01 00:00:00 GMT 2014,0,167.01,0,0,167.01,4,0,15,0,4/27/2017,,,EA,160.39,,228.51,65,144,,,0,,,,123456,,"testAltDesc",0,0,0,0,0,0,0,0,4/27/2017,0,A,A,A,A\n'
        +'Alt,DFZ,800E000000097SpIAI,,"TONER,C748,HY,BLACK",228.51,,,M,,153.1,153.1,1,5,Fri Aug 01 00:00:00 GMT 2014,0,167.01,0,0,167.01,4,0,15,0,4/27/2017,,,EA,160.39,,228.51,65,144,,,0,,,,123457,123457,"testAltDesc",0,,0,0,0,0,0,0,,0,A,A,A,A\n'  
        +',DFZ,800E000000097SpIAI,,"TONER,C748,HY,BLACK",228.51,,,M,,153.1,153.1,1,5,Fri Aug 01 00:00:00 GMT 2014,0,167.01,0,0,167.01,4,0,15,0,4/27/2017,,,EA,160.39,,228.51,65,144,,,0,,,,123457,123457,"testAltDesc",0,,0,0,0,0,0,0,,0,A,A,A,A\n'     
        +'New,DFZ,800E000000097SpIAI,123456,"TONER,C748,HY,BLACK",228.51,,,M,,153.1,153.1,1,5,Fri Aug 01 00:00:00 GMT 2014,0,167.01,0,0,167.01,4,0,15,0,4/27/2017,,,EA,160.39,,228.51,65,144,,,0,,,,123457,123457,"testAltDesc",0,,0,0,0,0,0,0,,0,A,A,A,A\n'    
        +'Del,DFZ,800E000000097SpIAI,123458,"TONER,C748,HY,BLACK",228.51,,,M,,153.1,153.1,1,5,Fri Aug 01 00:00:00 GMT 2014,0,167.01,0,0,167.01,4,0,15,0,4/27/2017,,,EA,160.39,,228.51,65,144,,,0,,,,123457,123457,"testAltDesc",0,,0,0,0,0,0,0,,0,A,A,A,A\n'                                                                                                                                                        
        );
        
        ACEUpload_File.CSVWrapper csvwrapper=new ACEUpload_File.CSVWrapper();
        ACEUpload_File.csvErrList csverrlist=new ACEUpload_File.csvErrList();
        ACuploadfile.doublevalue(inputval);
        ACuploadfile.Remedy_ReadFile();
        
        ACuploadfile.AccessLevel = 'Remediation';

        ACuploadfile.fileToUpload = 'test';
        ACuploadfile.content = Blob.valueOf('test');
        ACuploadfile.IsRemedy = true;
        ACuploadfile.renderErrTable = true;
        ACuploadfile.fileNameRem = 'test';
        ACuploadfile.fileNameHost = 'test';
        ACuploadfile.content1 = Blob.valueOf('test');

        csvwrapper.Action='stringText';
        csvwrapper.CurrentMethod='stringText';
        csvwrapper.ContractId='stringText';
        csvwrapper.SKU='stringText';
        csvwrapper.SKUDesc='stringText';
        csvwrapper.Sold='stringText';
        csvwrapper.SVT='stringText';
        csvwrapper.UOM='stringText';
        csvwrapper.SKUQPU='stringText';
        csvwrapper.DeptId='stringText';
        csvwrapper.ClassId='stringText';
        csvwrapper.PrivateBand='stringText';
        csvwrapper.RMSProcCode='stringText';
        csvwrapper.AddToCore='stringText';
        csvwrapper.ASKU='stringText';
        csvwrapper.ASKUDesc='stringText';
        csvwrapper.AUOM='stringText';
        csvwrapper.APriceMethod='stringText';
        csvwrapper.AMethodId='stringText';
        csvwrapper.APrivateBand='stringText';
        csvwrapper.AProcFlag='stringText';
        csvwrapper.Identifier ='9615525';
        csvwrapper.AIdentifier ='';

        //decimals
        csvwrapper.CurrListPrice=0.01;
        csvwrapper.PropIMU=0.01;
        csvwrapper.PropPrice=0.01;
        csvwrapper.EstAnnualSpend=0.01;
        csvwrapper.PropIMUDoll=0.01;
        csvwrapper.CurrSellPrice=0.01;
        csvwrapper.CurrSKUIMU=0.01;
        csvwrapper.AnnSpendInc=0.01;
        csvwrapper.PriceMethodPer=0.01;
        csvwrapper.Item12MonthQnty=0.01;
        csvwrapper.NewWATDCost=0.01;
        csvwrapper.CurrRetPrice=0.01;
        csvwrapper.CurrListPrice=0.01;
        csvwrapper.Item12MonthSale=0.01;
        csvwrapper.HisTotCost=0.01;
        csvwrapper.HisIMUPer=0.01;
        csvwrapper.HisIMUDoll=0.01;
        csvwrapper.APropIMU=0.01;
        csvwrapper.APropPrice=0.01;
        csvwrapper.APropPriceIMUDoll=0.01;
        csvwrapper.AAnnSpndInc=0.01;
        csvwrapper.ANewWATDCost=0.01;
        csvwrapper.ACurrRetPrice=0.01;
        csvwrapper.ACurrListPrice=0.01;
        csvwrapper.ASKUQPU=0.01;
        csvwrapper.ASKUCurrPurch=0.01;

        //dates
        csvwrapper.AEffDate=Date.today();
        csvwrapper.EffDate=Date.today();


        csverrlist.SKU='stringText';
        csverrlist.ErrorMsg='stringText';

    }
    /*

            static testMethod void myUnitTest4()
    {
        String inputval='100';
        ACE_Settings__c desettings = new ACE_Settings__c();
        insert desettings;
        Account acc = new Account (name = 'SUN Test Account',AOPS_Seq_ID__c = '123456',AOPS_Cust_Id__c = '123456',Oracle_Party_Id__c = '123456',Billingcountry = 'USA',BillingState = 'UT',BillingStreet = '1040 N 326 W',billingcity = 'Orem');
        insert acc;

        ACE_Customer_Price_Changes__c ace1 = new ACE_Customer_Price_Changes__c(name='Q2-2014',batchID__c = 'Q2-2014', SRM_Differential__c=5,Item_12_Month_Qty__c = 50,Total_Spend_Impact_12_Month__c=5,Customer__c = acc.id, Owning_Customer_ID__c ='123456', SFDC_Notification_Flag__c = '1');
        insert ace1;

        Ace_Customer_Core_Changes__c ace2 = new Ace_Customer_Core_Changes__c(name = 'Test',CoreID__c = '123456', ACE_Customer_Price_Changes__c = ace1.id);
        insert ace2;

        Ace_Customer_SKU_Changes__c ace3 = new Ace_Customer_SKU_Changes__c(SKU__c = '123456',name='test', status__c = 'Active', Change_Type__c = 'A', Ace_Customer_Core_Changes__c = ace2.id);
        insert ace3;

         Ace_Customer_Core_Changes__c ace4 = new Ace_Customer_Core_Changes__c(name = 'Test',CoreID__c = '123456', ACE_Customer_Price_Changes__c = ace1.id);
         insert ace4;

         Ace_Customer_SKU_Changes__c ace5 = new Ace_Customer_SKU_Changes__c(SKU__c = '123456',SKU_ALT__C = '123457', name='test', status__c = 'Deleted', Ace_Customer_Core_Changes__c = ace2.id,Price_Changes_Type__c = 'A');
         insert ace5;

        ApexPages.currentPage().getParameters().put('selectedCustomer',ace1.id);

        ACEUpload_File ACuploadfile=new ACEUpload_File();

       /* ACuploadfile.contentFile=Blob.valueOf('Action,Current Price Method,Contract Id,SKU,SKU Description,Proposed IMU %,Proposed Price With Cap,Estimated Annual Spend,Proposed IMU %,Current Sell Price,Current IMU $,Annual Spend Increase,Pricing Method Percentage,Items 12 Month Quantity,Effective Date,Sold,SVT,UOM,SKU QPU,New WA TD Cost,Current Retail Price,Current List Price,Dept ID,Class Id,Private Brand,RMS Procurement Code,Items 12 Month Sales,History Total Cost,Hist IMU Dollars,Hist IMU Percentage,Core ID,Alt SKU,Alt SKU Description,Alt Proposed IMU %,Alt Proposed Price With Cap,Alt Proposed IMU %,Alt Annual Spend Increase,Alt New WA TD Cost,Alt Current Retail Price,Alt Current List Price,Alt UOM,Alt Effective Date,Alt SKU QPU,Alt SKU Currently Purchased,Alt Current Price Method,Alt Method ID,Alt Private Brand,Alt RMS Procurement Code'+ ',Fixed Price,,560483,"PAPER,COLOR LASER,HP,REAM",0.00,6.79,0.00,0.00,7.00,-3.00,0.00,0.00,0,9/13/2014,,,RM,,0.00,,18.70,5,503,,,0.00,,,,CL-9615525,,,,,,,,,,,,,,,,,\n'+
        'null,Fixed Price,,478518,"chairmat,hrdflr,45x53,wide lip",0.00,17.30,0.00,0.00,17.00,-36.00,0.00,0.00,0,9/13/2014,,,EA,,0.00,,109.99,25,169,,,0.00,,,,CL-9615525,,,,,,,,,,,,,,,"stringText,stringText,\n'+
        'null,Fixed Price,,477986,"chairmat,cleatmat,46x60,utilty",0.00,27.13,0.00,0.00,27.00,-61.00,0.00,0.00,0,9/13/2014,,,EA,,0.00,,169.99,25,169,,,0.00,,,,CL-9615525,,,,,,,,,,,,,,,,,\n'
        );
       
          ACuploadfile.contentFile=Blob.valueOf('Action,Current Price Method,Contract Id,SKU,SKU Description,List Price,Target QPU,Alt QPU,Change Type,SKU Governed By Active Written Agreement,New WAPO Cost,Old WAPO Cost,Vendor Letter Requirement,Customer SKU Cap %,SKU Last Change Date,Proposed IMU %,Proposed Price With Cap,Estimated Annual Spend,Proposed IMU %,Current Sell Price,Current IMU $,Annual Spend Increase,Pricing Method Percentage,Items 12 Month Quantity,Effective Date,Sold,SVT,UOM,New WA TD Cost,Current Retail Price,Current List Price,Dept ID,Class Id,Private Brand,RMS Procurement Code,Items 12 Month Sales,History Total Cost,Hist IMU Dollars,Hist IMU Percentage,Core ID,Alt SKU,Alt SKU Description,Alt Proposed IMU %,Alt Proposed Price With Cap,Alt Proposed IMU %,Alt Annual Spend Increase,Alt New WA TD Cost,Alt Current Retail Price,Alt Current List Price,Alt UOM,Alt Effective Date,Alt SKU Currently Purchased,Alt Current Price Method,Alt Method ID,Alt Private Brand,Alt RMS Procurement Code\n'+',DFZ,800E000000097SpIAI,433377,"INK,DUAL PACK,EPSON,BLACK",34.99,,,M,,23.15,23.15,1,5,Fri Aug 01 00:00:00 GMT 2014,0,29.74,0,0,29.74,18,0,15,0,4/27/2017,,,PK,24.49,,34.99,14,872,,,0,,,,CL-9019079,,,,,,,,,,,,,,,,\n'
        +'null,DFZ,800E000000097SpIAI,397429,"TONER,C748,HY,BLACK",228.51,,,M,,153.1,153.1,1,5,Fri Aug 01 00:00:00 GMT 2014,0,167.01,0,0,167.01,4,0,15,0,4/27/2017,,,EA,160.39,,228.51,65,144,,,0,,,,CL-9019079,,,,,,,,,,,,,,,,\n'
        +'null,DFZ,800E000000097SpIAI,320434,"TONER,HP 42A/42X,EXTENDED LIFE",331.5,,,M,,99.75,99.75,1,5,Fri Aug 01 00:00:00 GMT 2014,0,263.49,0,0,263.49,59,0,15,0,4/27/2017,,,EA,108.37,,331.5,65,144,,,0,,,,CL-9019079,,,,,,,,,,,,,,,,\n'
        );
         
        ACuploadfile.contentFile=Blob.valueOf('Action,Current Price Method,Contract Id,SKU,SKU Description,List Price,Target QPU,Alt QPU,Change Type,SKU Governed By Active Written Agreement,New WAPO Cost,Old WAPO Cost,Vendor Letter Requirement,Customer SKU Cap %,SKU Last Change Date,Proposed IMU %,Proposed Price With Cap,Estimated Annual Spend,Proposed IMU %,Current Sell Price,Current IMU $,Annual Spend Increase,Pricing Method Percentage,Items 12 Month Quantity,Effective Date,Sold,SVT,UOM,New WA TD Cost,Current Retail Price,Current List Price,Dept ID,Class Id,Private Brand,RMS Procurement Code,Items 12 Month Sales,History Total Cost,Hist IMU Dollars,Hist IMU Percentage,Core ID,Alt SKU,Alt SKU Description,Alt Proposed IMU %,Alt Proposed Price With Cap,Alt Proposed IMU %,Alt Annual Spend Increase,Alt New WA TD Cost,Alt Current Retail Price,Alt Current List Price,Alt UOM,Alt Effective Date,Alt SKU Currently Purchased,Alt Current Price Method,Alt Method ID,Alt Private Brand,Alt RMS Procurement Code\n'+',DFZ,800E000000097SpIAI,433377,"INK,DUAL PACK,EPSON,BLACK",34.99,,,M,,23.15,23.15,1,5,Fri Aug 01 00:00:00 GMT 2014,0,29.74,0,0,29.74,18,0,15,0,,,,PK,24.49,,34.99,14,872,,,0,,,,CL-9019079,,,,,,,,,,,,,,,,\n'
        +',DFZ,800E000000097SpIAI,,"TONER,C748,HY,BLACK",228.51,,,M,,153.1,153.1,1,5,Fri Aug 01 00:00:00 GMT 2014,0,,0,0,167.01,4,0,15,0,,,,EA,160.39,,228.51,65,144,,,0,,,,CL-9019079,,,,,,,,,,,,,,,,\n'
        +',DFZ,800E000000097SpIAI,320434,"TONER,HP 42A/42X,EXTENDED LIFE",331.5,,,M,,99.75,99.75,1,5,Fri Aug 01 00:00:00 GMT 2014,0,263.49,0,0,263.49,59,0,15,0,,,,EA,108.37,,331.5,65,144,,,0,,,,CL-9019079,,,,,,,,,,,,,,,,\n'
        +',DFZ,800E000000097SpIAI,,,228.51,,,M,,153.1,153.1,1,5,Fri Aug 01 00:00:00 GMT 2014,0,,0,0,167.01,4,0,15,0,,,,EA,160.39,,228.51,65,144,,,0,,,,CL-9019079,,,,,,,,,,,,,,,,\n'
        +',DFZ,800E000000097SpIAI,123456,"TONER,C748,HY,BLACK",228.51,,,M,,153.1,153.1,1,5,Fri Aug 01 00:00:00 GMT 2014,0,,0,0,167.01,4,0,15,0,,,,EA,160.39,,228.51,65,144,,,0,,,,123456,123457,"test",0,0,0,0,0,0,0,0,0,0,0,0,0,0\n'                                      
        +'Alt,DFZ,800E000000097SpIAI,123456,"TONER,C748,HY,BLACK",228.51,,,M,,153.1,153.1,1,5,Fri Aug 01 00:00:00 GMT 2014,0,167.01,0,0,167.01,4,0,15,0,4/27/2017,,,EA,160.39,,228.51,65,144,,,0,,,,123456,,"testAltDesc",0,0,0,0,0,0,0,0,4/27/2017,0,A,A,A,A\n'
        +'Alt,DFZ,800E000000097SpIAI,,"TONER,C748,HY,BLACK",228.51,,,M,,153.1,153.1,1,5,Fri Aug 01 00:00:00 GMT 2014,0,167.01,0,0,167.01,4,0,15,0,4/27/2017,,,EA,160.39,,228.51,65,144,,,0,,,,123457,123457,"testAltDesc",0,,0,0,0,0,0,0,,0,A,A,A,A\n'  
        +',DFZ,800E000000097SpIAI,,"TONER,C748,HY,BLACK",228.51,,,M,,153.1,153.1,1,5,Fri Aug 01 00:00:00 GMT 2014,0,167.01,0,0,167.01,4,0,15,0,4/27/2017,,,EA,160.39,,228.51,65,144,,,0,,,,123457,123457,"testAltDesc",0,,0,0,0,0,0,0,,0,A,A,A,A\n'     
        +'New,DFZ,800E000000097SpIAI,123459,"TONER,C748,HY,BLACK",228.51,,,M,,153.1,153.1,1,5,Fri Aug 01 00:00:00 GMT 2014,0,167.01,0,0,167.01,4,0,15,0,4/27/2017,,,EA,160.39,,228.51,65,144,,,0,,,,123457,123457,"testAltDesc",0,,0,0,0,0,0,0,,0,A,A,A,A\n'    
        +'Del,DFZ,800E000000097SpIAI,123459,"TONER,C748,HY,BLACK",228.51,,,M,,153.1,153.1,1,5,Fri Aug 01 00:00:00 GMT 2014,0,167.01,0,0,167.01,4,0,15,0,4/27/2017,,,EA,160.39,,228.51,65,144,,,0,,,,123457,123457,"testAltDesc",0,,0,0,0,0,0,0,,0,A,A,A,A\n'                                                                                                                                                        
        );
        
        ACEUpload_File.CSVWrapper csvwrapper=new ACEUpload_File.CSVWrapper();
        ACEUpload_File.csvErrList csverrlist=new ACEUpload_File.csvErrList();
        ACuploadfile.doublevalue(inputval);
        ACuploadfile.Remedy_ReadFile();
        
        ACuploadfile.AccessLevel = 'Remediation';

        ACuploadfile.fileToUpload = 'test';
        ACuploadfile.content = Blob.valueOf('test');
        ACuploadfile.IsRemedy = true;
        ACuploadfile.renderErrTable = true;
        ACuploadfile.fileNameRem = 'test';
        ACuploadfile.fileNameHost = 'test';
        ACuploadfile.content1 = Blob.valueOf('test');

        csvwrapper.Action='stringText';
        csvwrapper.CurrentMethod='stringText';
        csvwrapper.ContractId='stringText';
        csvwrapper.SKU='stringText';
        csvwrapper.SKUDesc='stringText';
        csvwrapper.Sold='stringText';
        csvwrapper.SVT='stringText';
        csvwrapper.UOM='stringText';
        csvwrapper.SKUQPU='stringText';
        csvwrapper.DeptId='stringText';
        csvwrapper.ClassId='stringText';
        csvwrapper.PrivateBand='stringText';
        csvwrapper.RMSProcCode='stringText';
        csvwrapper.AddToCore='stringText';
        csvwrapper.ASKU='stringText';
        csvwrapper.ASKUDesc='stringText';
        csvwrapper.AUOM='stringText';
        csvwrapper.APriceMethod='stringText';
        csvwrapper.AMethodId='stringText';
        csvwrapper.APrivateBand='stringText';
        csvwrapper.AProcFlag='stringText';
        csvwrapper.Identifier ='9615525';
        csvwrapper.AIdentifier ='9615525';

        //decimals
        csvwrapper.CurrListPrice=0.01;
        csvwrapper.PropIMU=0.01;
        csvwrapper.PropPrice=0.01;
        csvwrapper.EstAnnualSpend=0.01;
        csvwrapper.PropIMUDoll=0.01;
        csvwrapper.CurrSellPrice=0.01;
        csvwrapper.CurrSKUIMU=0.01;
        csvwrapper.AnnSpendInc=0.01;
        csvwrapper.PriceMethodPer=0.01;
        csvwrapper.Item12MonthQnty=0.01;
        csvwrapper.NewWATDCost=0.01;
        csvwrapper.CurrRetPrice=0.01;
        csvwrapper.CurrListPrice=0.01;
        csvwrapper.Item12MonthSale=0.01;
        csvwrapper.HisTotCost=0.01;
        csvwrapper.HisIMUPer=0.01;
        csvwrapper.HisIMUDoll=0.01;
        csvwrapper.APropIMU=0.01;
        csvwrapper.APropPrice=0.01;
        csvwrapper.APropPriceIMUDoll=0.01;
        csvwrapper.AAnnSpndInc=0.01;
        csvwrapper.ANewWATDCost=0.01;
        csvwrapper.ACurrRetPrice=0.01;
        csvwrapper.ACurrListPrice=0.01;
        csvwrapper.ASKUQPU=0.01;
        csvwrapper.ASKUCurrPurch=0.01;

        //dates
        csvwrapper.AEffDate=Date.today();
        csvwrapper.EffDate=Date.today();


        csverrlist.SKU='stringText';
        csverrlist.ErrorMsg='stringText';

    }
    */
}