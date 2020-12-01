@isTest
private class PriceCalc_TC {
    @isTest static void testPriceCalc() {    
        Test.startTest();          
        // This causes a fake response to be generated
        Test.setMock(WebServiceMock.class, new PriceCalcMockImpl());
        
        pricecalc pc = new pricecalc();
        pc.picst = '30900737';
        pc.piadrseq = '1';
        pc.piadrkey = '0';
        pc.piloc = '0';
        pc.pisk = '1';
        pc.piqty =  '10';
        
        pc.selected_option = 'Inventory Location'; 
        pc.selected_value = '0';

        // Call the method that invokes a callout
        pc.process_price_calc();

        pc.selected_option = 'Address Key'; 
        pc.selected_value = '0';

        // Call the method that invokes a callout
        pc.process_price_calc();

        pc.selected_option = 'Address Sequence'; 
        pc.selected_value = '1';
 
        // Call the method that invokes a callout
        pc.process_price_calc();
        
        Test.stopTest();
        
        // Verify that a fake result is returned
        //System.assertEquals('Mock response', respElement.poerror); 
    }
}