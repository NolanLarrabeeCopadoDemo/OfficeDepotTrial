@isTest
global class officedepotComSendnotificationservice_TC implements WebServiceMock{
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
           // officedepotComSendnotificationservice.Client client = new officedepotComSendnotificationservice.Client('');
     officedepotComSendnotificationservice.sendEmailResponse SER= new officedepotComSendnotificationservice.sendEmailResponse();
    
       response.put('response_x', SER);
   }
  static testMethod void coverMainClient() {
        // This causes a fake response to be generated
        Test.setMock(WebServiceMock.class, new officedepotComSendnotificationservice_TC());
         officedepotComSendnotificationservice.recipientAddress RA = new officedepotComSendnotificationservice.recipientAddress ();
     officedepotComSendnotificationservice.sendEmail SE = new officedepotComSendnotificationservice.sendEmail ();
     officedepotComSendnotificationservice.EmailBindingQSPort EBQ =new officedepotComSendnotificationservice.EmailBindingQSPort ();
   officedepotComSendnotificationservice.senderAddress SA=new officedepotComSendnotificationservice.senderAddress ();
   EBQ.sendEmail(SA,RA,'subject','format','message','disclaimerMessage');   
       // MainClient.Client client = new MainClient.Client('');
}
}