@isTest
global class Lead_AddValidation_Batch_TC implements WebServiceMock{ //modified line for S-357929
    
    
    //Added for the story S-357929 #Start
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
           G1AddressValidation.AddressValidationServiceResponse_element client = new G1AddressValidation.AddressValidationServiceResponse_element();
           G1AddressValidation.CustomerResponseType CRT = new G1AddressValidation.CustomerResponseType();
           CRT.Address = new G1AddressValidation.AddressType();
           CRT.AddressReturnCode = 0;
           CRT.ErrorMessage = new G1AddressValidation.ErrorMessagesType();           
           client.CustomerInformation = CRT;
          response.put('response_x', client);
   }//S-357929 #End

public static testMethod void Lead_AddValidation_Batch_TC()
{
    System.test.startTest();
    //added below line for S-357929
     Test.setMock(WebServiceMock.class, new Lead_AddValidation_Batch_TC());
    lead l1 = new Lead ();
    //l1.Name ='Test';
    l1.address1__c='Addr1';
    l1.Address_Validation_Error__c='NO';
    l1.Address_Validated__c = true;
    l1.address2__c='Addr2';
    l1.City__c='NY';
    l1.state__c='KA';
    l1.country__c='USA';
    l1.zip__c='335647';
    l1.Company ='Wipro';
    l1.LastName='Test';
    insert l1;
    
    lead l2 = new Lead();
     
    //l1.Name ='Test';
    l2.address1__c='6600 North Military Trail';
    l2.Address_Validation_Error__c='NO';
    l2.Address_Validated__c = true;
    l2.address2__c='Boca Raton';
    l2.City__c='FL';
    l2.state__c='KA';
    l2.country__c='USA';
    l2.zip__c='33496';
    l2.Company ='XYZ';
    l2.LastName='Comp';
    insert l2;
    
    l1.city='BN';
    //l1.lastmodifieddate=Date.today().addDays(-1);
    update l1;
    
    
    
    
    //Lead_Batch_Execution_Details__c lbatch = new Lead_Batch_Execution_Details__c();
    //lbatch.Lead_Batch_Execution_Date__c = system.today();
    //insert lbatch;
    
    String q ='select id, Name,address1__c,Address_Validation_Error__c,Address_Validated__c,address2__c,City__c,state__c,country__c,zip__c from Lead Where Company =\'Wipro\' limit 10';
    System.debug('********'+l1.lastmodifieddate);
    Lead_AddValidation_Batch obj = new  Lead_AddValidation_Batch();
    //Lead_AddValidation_Batch obj = new  Lead_AddValidation_Batch(q);
    Database.executeBatch(obj,10);    
    String CRON_EXP = '0 0 0 3 9 ? 2022';  
    System.schedule('Assignment Batch',CRON_EXP , obj );
   Test.stoptest();
}

    //Added for the story S-357929 #Start
    public static testMethod void Lead_AddValidation_Batch_TC1()
    {
        System.test.startTest();
        
         Test.setMock(WebServiceMock.class, new Lead_AddValidation_Batch_TC());
        lead l1 = new Lead ();
        //l1.Name ='Test';
        l1.address1__c='Addr1';
        l1.Address_Validation_Error__c='NO';
        l1.Address_Validated__c = true;
        l1.address2__c='Addr2';
        l1.City__c='NY';
        l1.state__c='KA';
        l1.country__c='USA';
        l1.zip__c='335647';
        l1.Company ='Wipro';
        l1.LastName='Test';
        insert l1;
        
        lead l2 = new Lead();
         
        //l1.Name ='Test';
        l2.address1__c='6600 North Military Trail';
        l2.Address_Validation_Error__c='NO';
        l2.Address_Validated__c = true;
        l2.address2__c='Boca Raton';
        l2.City__c='FL';
        l2.state__c='KA';
        l2.country__c='USA';
        l2.zip__c='33496';
        l2.Company ='XYZ';
        l2.LastName='Comp';
        insert l2;
        
        l1.city='BN';
        update l1;
        
        //Lead_Batch_Execution_Details__c lbatch = new Lead_Batch_Execution_Details__c();
        //lbatch.Lead_Batch_Execution_Date__c = system.today();
        //insert lbatch;
        
        String q ='select id, Name,address1__c,Address_Validation_Error__c,Address_Validated__c,address2__c,City__c,state__c,country__c,zip__c from Lead Where Company =\'Wipro\' limit 10';
        System.debug('********'+l1.lastmodifieddate);
        Lead_AddValidation_Batch obj = new  Lead_AddValidation_Batch(q);
        Database.executeBatch(obj,10);    
        String CRON_EXP = '0 0 0 3 9 ? 2022';  
        System.schedule('Assignment Batch',CRON_EXP , obj );
        Test.stoptest();
    }
    //Added for the story S-357929 #End
}