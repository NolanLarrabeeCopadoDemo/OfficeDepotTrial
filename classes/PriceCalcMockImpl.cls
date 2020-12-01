@isTest
global class PriceCalcMockImpl implements WebServiceMock {
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
       xmlnsOracleComGetaopsnetpricer.GetAOPSNetPricerProcessResponse_element  respElement = 
           new xmlnsOracleComGetaopsnetpricer.GetAOPSNetPricerProcessResponse_element();
       respElement.poerror = 'Mock response';
       response.put('response_x', respElement); 
   }
}