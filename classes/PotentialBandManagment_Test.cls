@IsTest
public without sharing class PotentialBandManagment_Test {
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
    }



    @IsTest
    public static void runMakeData(){
        Test.startTest();
        List<Potential_Band__c> potential_bands = [SELECT Id, Banding_Key__c, Segment__c FROM Potential_Band__c];
        for(Potential_Band__c band: potential_bands){
            System.assertNotEquals(band.Banding_Key__c, null);
            System.assertNotEquals(band.Segment__c, null);
            System.debug('Banding Key: ' + band.Banding_Key__c);
            System.debug('Segment: ' + band.Segment__c);
        }
        update potential_bands;
        Test.stopTest();
    }

    @IsTest
    public static void test_getRevenueBand(){
        Test.startTest();
        System.assertEquals(0, PotentialBandManagment.getRevenueBand(null));
        System.assertEquals(5, PotentialBandManagment.getRevenueBand(1000000001));
        System.assertEquals(4, PotentialBandManagment.getRevenueBand(500000001));
        System.assertEquals(3, PotentialBandManagment.getRevenueBand(50000001));
        System.assertEquals(2, PotentialBandManagment.getRevenueBand(10000001));
        System.assertEquals(1, PotentialBandManagment.getRevenueBand(50001));
        System.assertEquals(0, PotentialBandManagment.getRevenueBand(-1));
        Test.stopTest();
    }

    @IsTest
    public static void test_getEmployeeCountBand(){
        Test.startTest();
        System.assertEquals(0, PotentialBandManagment.getEmployeeCountBand(null));
        System.assertEquals(5, PotentialBandManagment.getEmployeeCountBand(50001));
        System.assertEquals(4, PotentialBandManagment.getEmployeeCountBand(10001));
        System.assertEquals(3, PotentialBandManagment.getEmployeeCountBand(5001));
        System.assertEquals(2, PotentialBandManagment.getEmployeeCountBand(201));
        System.assertEquals(1, PotentialBandManagment.getEmployeeCountBand(10));
        System.assertEquals(0, PotentialBandManagment.getEmployeeCountBand(-1));
        Test.stopTest();
    }

    @IsTest
    public static void test_getSegment(){
        Test.startTest();
        System.assertEquals('No Segment Assigned', PotentialBandManagment.getSegment(null));
        System.assertEquals('Strategic', PotentialBandManagment.getSegment(2000001));
        System.assertEquals('Key Accounts 1', PotentialBandManagment.getSegment(500001));
        System.assertEquals('Key Accounts 2', PotentialBandManagment.getSegment(50001));
        System.assertEquals('ISO Accounts', PotentialBandManagment.getSegment(5200));
        Test.stopTest();
    }


}