@isTest
public with sharing class OrgManagement_Test {

    @TestSetup
    static void makeData(){
        
        List<Potential_Band__c> potential_bands = new List<Potential_Band__c>{
            new Potential_Band__c(
                High_Level_Industry__c = 'Accomodation and Food Services',
                CBFS_Industry_Potential__c = 100.00,
                Core_Industry_Potential__c = 100.00,
                CPD_Industry_Potential__c = 100.00,
                Furniture_Industry_Potential__c = 100.00,
                Tech_Industry_Potential__c = 100.00,
                Total_Industry_Potential__c = 100.00,
                Revenue_Band__c = 1,
                Employee_Count_Band__c = 1
            ),
            new Potential_Band__c(
                High_Level_Industry__c = 'Accomodation and Food Services',
                CBFS_Industry_Potential__c = 1000.00,
                Core_Industry_Potential__c = 1000.00,
                CPD_Industry_Potential__c = 1000.00,
                Furniture_Industry_Potential__c = 1000.00,
                Tech_Industry_Potential__c = 1000.00,
                Total_Industry_Potential__c = 1000.00,
                Revenue_Band__c = 2,
                Employee_Count_Band__c = 2
            )
        };
    
        insert potential_bands;

        List<Industry_Rollup__c> my_rollups = new List<Industry_Rollup__c>{
            new Industry_Rollup__c(
                Low_Level_Industry__c = 'Hotels and Accommodation',
                High_level_Industry__c = 'Accomodation and Food Services'
            )
        };

        insert my_rollups;

        // TODO: Add data for null cases.
        List<Org__c> my_org_list = new List<Org__c>{
            new Org__c(
                Business_Name__c='Foo Bar',
                Address_1__c = '123 6541 N Meter St',
                City__c='Boca Raton',
                State__c='FL',
                Zip__c='33425',
                LOB__c = 'Hotels and Accommodation',
                Global_Ultimate_Employee_Count__c = '5000', // Reference Employee Count Band on Org for Formula. -> 2
                // High_Level_Industry__c='Accomodation and Food Services',
                GLOBAL_ULTIMATE_SALES_AMT__c = 23123123.00 // Reference Revenue Band on Org for Formula. -> 2
                // Banding_Key__c = 'accomodationandfoodservices22'
            ),
            new Org__c(
                Business_Name__c='142 Foo Bar',
                Address_1__c = '123 N Meter St',
                City__c='Orlando',
                State__c='FL',
                Zip__c='33496',
                LOB__c = 'Hotels and Accommodation',
                Global_Ultimate_Employee_Count__c = '200', // Reference Employee Count Band on Org for Formula. -> 1
                // High_Level_Industry__c='Accomodation and Food Services',
                GLOBAL_ULTIMATE_SALES_AMT__c = 133123.00  // Reference Revenue Band on Org for Formula. -> 1
                // Banding_Key__c = 'accomodationandfoodservices11'
            )
        };

        insert my_org_list;
    }

    @Istest
    static void test_setupData(){
        List<Org__c> created_orgs = new List<Org__c>([
            SELECT 
                Business_Name__c,
                Address_1__c ,
                City__c,
                State__c,
                Zip__c,
                Global_Ultimate_Employee_Count__c , // Reference Employee Count Band on Org for Formula. -> 2
                High_Level_Industry__c,
                GLOBAL_ULTIMATE_SALES_AMT__c, // Reference Revenue Band on Org for Formula. -> 2
                Banding_Key__c
            FROM Org__c LIMIT 2
        ]);
        for(Org__c org: created_orgs)
            System.assertNotEquals(org.Banding_Key__c, null);

        List<Potential_Band__c> potential_bands = new List<Potential_Band__c>([
            SELECT 
                Id, 
                High_Level_Industry__c, 
                CBFS_Industry_Potential__c, 
                Core_Industry_Potential__c,
                CPD_Industry_Potential__c,
                Furniture_Industry_Potential__c,
                Tech_Industry_Potential__c,
                Total_Industry_Potential__c,
                Revenue_Band__c,
                Employee_Count_Band__c,
                Banding_Key__c
            FROM Potential_Band__c LIMIT 2
        ]);
        for(Potential_Band__c band: potential_bands)
            System.assertNotEquals(band.Banding_Key__c, null);

        System.debug('Created Orgs: ' + created_orgs);
        System.debug('Potential Bands: ' + potential_bands);
    }

    @IsTest
    public static void test_getPotentialBands(){


        List <Potential_Band__c> band_list = [SELECT Id, Banding_Key__c FROM Potential_Band__c];
        List <Org__c> org_list = [SELECT Id, Potential_Band__c, Banding_Key__c FROM Org__c];
        for(Org__c my_org: org_list)
            my_org.Potential_Band__c = null;
        Test.startTest();
        OrgTriggerHandler.bypass('OrgTriggerHandler'); // Bypasses trigger functionality so we only test the function, not trigger functionality. 
        UPDATE org_list;
        List <Org__c> potental_bands = OrgManagement.getPotentialBands(org_list, band_list);
        for(Org__c my_org: potental_bands)
            System.assertNotEquals(my_org.Potential_Band__c, null);

        OrgTriggerHandler.clearBypass('OrgTriggerHandler');
        Test.stopTest();
        
    }


    @IsTest
    public static void test_mapLowLevelToHighLevelIndustry(){
        List <Org__c> org_list = [SELECT Id, High_Level_Industry__c, LOB__c FROM Org__c];

        for(Org__c my_org: org_list) 
            my_org.High_Level_Industry__c = null;

        List<Industry_Rollup__c> my_rollups = new List<Industry_Rollup__c>{
            new Industry_Rollup__c(
                Low_Level_Industry__c = 'Hotels and Accommodation',
                High_level_Industry__c = 'Accomodation and Food Services'
            )
        };
        Test.startTest();
        OrgTriggerHandler.bypass('OrgTriggerHandler'); // Bypasses trigger functionality so we only test the function, not trigger functionality. 
        UPDATE org_list;
        List <Org__c> with_high_level_industry = OrgManagement.mapLowLevelToHighLevelIndustry(org_list, my_rollups);
        for(Org__c my_org: org_list)
            System.assertNotEquals(my_org.High_Level_Industry__c, null);

        OrgTriggerHandler.clearBypass('OrgTriggerHandler');
        Test.stopTest();
    }


    @IsTest
    public static void test_mapLowLevelToHighLevelIndustryTrigg(){
        List <Org__c> org_list = [SELECT Id, High_Level_Industry__c, LOB__c FROM Org__c];

        for(Org__c my_org: org_list) 
            my_org.High_Level_Industry__c = null;

        Test.startTest();
        OrgTriggerHandler.bypass('OrgTriggerHandler'); // Bypasses trigger functionality so we only test the function, not trigger functionality. 
        UPDATE org_list;
        List <Org__c> with_high_level_industry = OrgManagement.mapLowLevelToHighLevelIndustryTrigg(org_list);
        for(Org__c my_org: org_list)
            System.assertNotEquals(my_org.High_Level_Industry__c, null);

        OrgTriggerHandler.clearBypass('OrgTriggerHandler');
        Test.stopTest();
    }

}