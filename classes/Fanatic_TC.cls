@isTest
private class Fanatic_TC {
    @isTest static void testFanaticWS() {    
        Test.startTest();          
        FanaticnetWS ws = new FanaticnetWS ();
        FanaticnetWS.DispatchSaveOperationResponse_element dis = new  FanaticnetWS.DispatchSaveOperationResponse_element();
        FanaticnetWS.FanaticOperationResultTransport inst1   =new FanaticnetWS.FanaticOperationResultTransport();
        FanaticnetWS.DispatchLoadOperation_element  inst2   =new FanaticnetWS.DispatchLoadOperation_element();
        FanaticnetWS.ArrayOfFanaticOperationResultTransport     inst3   =new FanaticnetWS.ArrayOfFanaticOperationResultTransport();
        FanaticnetWS.FanaticSaveOperationList inst4   =new FanaticnetWS.FanaticSaveOperationList();
        FanaticnetWS.FanaticBaseOperationList inst5   =new FanaticnetWS.FanaticBaseOperationList();
        FanaticnetWS.DispatchSaveOperation_element inst7   =new FanaticnetWS.DispatchSaveOperation_element();
        FanaticnetWS.ArrayOfString inst8   =new FanaticnetWS.ArrayOfString();
        FanaticnetWS.DispatchLoadOperationResponse_element inst10  =new FanaticnetWS.DispatchLoadOperationResponse_element();
        FanaticnetWS.FanaticOperationResultsTransport inst11  =new FanaticnetWS.FanaticOperationResultsTransport();
        FanaticnetWS.ArrayOfFanaticOperation af =  new FanaticnetWS.ArrayOfFanaticOperation();
        FanaticnetWS.FanaticOperation o = new FanaticnetWS.FanaticOperation();
        String pvar='';
        o.OperationName='GETCOMPANY';
        o.OperationKey='704784272';
        //o.OperationKey='03114000';
        o.OperationKey=pvar;
        o.OperationKeyType ='BGECUSTOMERNUMBER';
        //o.OperationKeyType ='CUSTORDERNO';
        o.DataType='eLiveData';
 FanaticnetWS.FanaticOperation[]  ao= new  FanaticnetWS.FanaticOperation[1];
     ao[0]=o;
        af.FanaticOperation=ao;
        FanaticnetWS.FanaticOperationList ol = new  FanaticnetWS.FanaticOperationList();
        ol.OperationList = af;
        ol.ModuleName='LPTA';
        ol.OperationType='eLoad';
        ol.Compressed=false;
        ol.Guid=' ' ;
        ol.ServResult=' ';
        FanaticProcessWS.FanaticTechDepotProcess_pt y =  new FanaticProcessWS.FanaticTechDepotProcess_pt();
        String rawData=y.process(ol);
        Test.setCurrentPageReference(new PageReference('Page.Fanatic')); 
        System.currentPageReference().getParameters().put('fid', '03114000');
        fanaticUtil fu = new fanaticUtil();
        fu.picst = '03114000'; 
        fu.process_data();
        fu.getOrderDetails();
        fu.getChartData();
        fu.getData();
        fu.getDatag();
        
        List<FanaticXmlReader.Address> addresses =fu.addresses;
         
        FanaticXmlReader.Customer customer =fu.customer ;
   
        List<FanaticXmlReader.Contact> Contact = fu.Contacts;
        FanaticnetWS.FanaticSaveOperationList Oplist = new FanaticnetWS.FanaticSaveOperationList();
        FanaticnetWS.DispatchSaveOperationResponse_element ds1 = y.DispatchSave(Oplist);
       // FanaticProcessWS.FanaticTechDepotProcess_pt y =  new FanaticProcessWS.FanaticTechDepotProcess_pt();
       // String rawData = '<test/>';
       // FanaticnetWS.DispatchSaveOperationResponse_element dis1 = y.DispatchSave(Oplist);
        
      
      // FanaticProcessWS .DispatchSave(inst4);
        Test.stopTest();
        
       
    }
}