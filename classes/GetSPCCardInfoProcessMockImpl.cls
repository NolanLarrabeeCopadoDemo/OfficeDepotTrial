@isTest
global class GetSPCCardInfoProcessMockImpl Implements WebServiceMock{
     global void doInvoke(
      Object stub,
      Object request,
      Map < String, Object > response,
      String endpoint,
      String soapAction,
      String requestName,
      String responseNS,
      String responseName,
      String responseType){
         GetSPCCardInfoProcess.SendCustomerReportInput er= New  GetSPCCardInfoProcess.SendCustomerReportInput();
         er.custID='test';
         er.emailAddress='test';
         er.from_source='test';
         GetSPCCardInfoProcess.getCustomerCardInfoInput ef= New GetSPCCardInfoProcess.getCustomerCardInfoInput();
         GetSPCCardInfoProcess.faultmessage fmess= New GetSPCCardInfoProcess.faultmessage();
            GetSPCCardInfoProcess.ContactInfo contactinfo = New  GetSPCCardInfoProcess.ContactInfo();
             GetSPCCardInfoProcess.CardLimitDetails cardlimits= New GetSPCCardInfoProcess.CardLimitDetails();
             GetSPCCardInfoProcess.CardDetails carddetail= New GetSPCCardInfoProcess.CardDetails();
          List<GetSPCCardInfoProcess.SPCCardInfoOutput> spccard= New List<GetSPCCardInfoProcess.SPCCardInfoOutput>();
          GetSPCCardInfoProcess.SPCCardInfoOutput singlespc = New GetSPCCardInfoProcess.SPCCardInfoOutput();
          spccard.add(singlespc);
          GetSPCCardInfoProcess.SPCCardInfoOutput[] respElement=new List<GetSPCCardInfoProcess.SPCCardInfoOutput>();
          Map<String,GetSPCCardInfoProcess.CustomerInfoOutput> mp =new Map<String,GetSPCCardInfoProcess.CustomerInfoOutput>();
          GetSPCCardInfoProcess.CustomerInfoOutput s=new GetSPCCardInfoProcess.CustomerInfoOutput();
          //respElement.
           response.put('response_x', s);
   
     }


}