@IsTest
public class GetSPCCardInfoProcess_Test {

	public static testMethod void testPrimaryAccountToTrue()
	{
		Account acc = new Account();
		acc.Name = 'Test Account';
		acc.AOPS_Cust_ID__c = '33168058';
		insert acc;
		Test.StartTest();
		Test.setMock(WebServiceMock.class, new GetSPCCardInfoProcessMockImpl());
		Map <String, Object> mp = new Map <String, Object> ();
		mp.put('recordId', acc.Id);
		GetSPCCardInfoProcessService.SendCustomerReportInput er = New GetSPCCardInfoProcessService.SendCustomerReportInput();
		er.custID = 'test';
		er.emailAddress = 'test';
		er.from_source = 'test';
		GetSPCCardInfoProcessService.getCustomerCardInfoInput ef = New GetSPCCardInfoProcessService.getCustomerCardInfoInput();
		GetSPCCardInfoProcessService.faultmessage fmess = New GetSPCCardInfoProcessService.faultmessage();
		GetSPCCardInfoProcessService.ContactInfo contactinfo = New GetSPCCardInfoProcessService.ContactInfo();
		GetSPCCardInfoProcessService.CustomerInfoOutput cusInfo = New GetSPCCardInfoProcessService.CustomerInfoOutput();
		GetSPCCardInfoProcessService.CardLimitDetails cardlimits = New GetSPCCardInfoProcessService.CardLimitDetails();
		GetSPCCardInfoProcessService.CardDetails carddetail = New GetSPCCardInfoProcessService.CardDetails();
		GetSPCCardInfoProcessService.SPCCardInfoOutput output = New GetSPCCardInfoProcessService.SPCCardInfoOutput();
		GetSPCCardInfoProcessService.processMethod(mp);
		GetSPCCardInfoProcessService.CardDetails crd = new GetSPCCardInfoProcessService.CardDetails();
		crd.CardNumber = 'test';
		crd.CreateDate = 'test';
		List<GetSPCCardInfoProcessService.CardDetails> lstcrd = new List<GetSPCCardInfoProcessService.CardDetails>();
		lstcrd.add(crd);
		GetSPCCardInfoProcessService.ContactInfo crd1 = new GetSPCCardInfoProcessService.ContactInfo();
		crd1.SPCCardHolderName = 'test';
		crd1.CardholderPhone = 'test';
		List<GetSPCCardInfoProcessService.ContactInfo> lstcrd1 = new List<GetSPCCardInfoProcessService.ContactInfo>();
		lstcrd1.add(crd1);
		GetSPCCardInfoProcessService.CardLimitDetails crd2 = new GetSPCCardInfoProcessService.CardLimitDetails();
		crd2.DailyDollarLimit = 'test';
		crd2.OrderLimit = 'test';
		List<GetSPCCardInfoProcessService.CardLimitDetails> lstcrd2 = new List<GetSPCCardInfoProcessService.CardLimitDetails>();
		lstcrd2.add(crd2);
		GetSPCCardInfoProcessService.SPCCardInfoOutput spcout = new GetSPCCardInfoProcessService.SPCCardInfoOutput();
		spcout.CardDetails = lstcrd;
		spcout.ContactInfo = lstcrd1;
		spcout.CardLimitDetails = lstcrd2;
		List<GetSPCCardInfoProcessService.SPCCardInfoOutput> lstou = new List<GetSPCCardInfoProcessService.SPCCardInfoOutput>();
		lstou.add(spcout);
		GetSPCCardInfoProcessService.SendEmailMessage(lstou, 'test');
		Test.stopTest();
	}
}