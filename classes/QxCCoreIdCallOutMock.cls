@isTest
global class QxCCoreIdCallOutMock implements WebServiceMock {
    

   global void doInvoke(
           Object stub,
           Object request,
           Map<String, Object> response,
           String endpoint,
           String soapAction,
           String requestName,
           String responseNS,
           String responseName,
           String responseType) {
        // start - specify the response you want to send
               try{
                   webserviceSystemProsrmComXsd.getQueryResultsResponse_element response_x = 
                       new webserviceSystemProsrmComXsd.getQueryResultsResponse_element();
                   
                   response_x.return_x = '<Response uniqueId="JBoss"><DataResponse><RESULT><RESULT>3000045</RESULT></RESULT></DataResponse></Response>';
                   // end
                   response.put('response_x', response_x); 
               }
               catch(Exception e){
                   interfacesPpssProsrmComXsd.putCCOREResponse_element response_x = new interfacesPpssProsrmComXsd.putCCOREResponse_element();
                   interfacesPpssProsrmComXsd.sendCCOREResponse_element element_x = new interfacesPpssProsrmComXsd.sendCCOREResponse_element();
                   interfacesPpssProsrmComXsd.sendCCORE_element element2_x = new interfacesPpssProsrmComXsd.sendCCORE_element();
                   interfacesPpssProsrmComXsd.Return_Status return_status_x = new interfacesPpssProsrmComXsd.Return_Status();
                   response.put('response_x', response_x); 
               }
              
   }
}