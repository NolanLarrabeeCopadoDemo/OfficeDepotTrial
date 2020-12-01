/***
Description: Test class for 'Pricing_csv_read' apex controller
Created By: Sunil Bansal
Created Date: 09-Mar-2012

Modified By:
Modified Date:

Modify Reason:
**/

@isTest
public class Pricing_csv_read_TC
{

    /*
    This method is to test PricingPDF apex controller and VF page
    */
    public static testMethod void testPricing_CSV_Read() 
    {
        Pricing_csv_read objPCR = new Pricing_csv_read();
        objPCR.contentFile = Blob.valueOf('Entering some test data\n to test this test class \n some data for blob');
        objPCR.ReadFile();
        objPCR.getsku();    
    }
}