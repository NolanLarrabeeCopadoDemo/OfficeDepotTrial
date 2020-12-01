@IsTest
public class RouteToScratchpad_TC {
	@TestSetup
	static void dataSetup() {
		Opportunity o = new Opportunity( Name = 'Opportunity1', StageName = 'Qualify', CloseDate = Date.today() );
		insert o;
		Quote q = new Quote( Name = 'Quote1', OpportunityId = o.Id );
		insert q;
		EndlessAisleScratchPad.insertQuoteLineItem( q.Id, '1', '2', 1.0, '3', '4', '5', 1.0, '6', '7', 1, 1.0, '8' ,'9', 1.0, '10', '11', '12', false, 1.0, '13', '14', '15', '16' );
	}
	
	@IsTest
	static void testRoute() {
		Quote q = [SELECT Id FROM Quote WHERE Name = 'Quote1'];
		QuoteLineItem qli = [SELECT Id, QuoteId FROM QuoteLineItem WHERE QuoteId = :q.Id];
		ApexPages.StandardController sc = new ApexPages.StandardController(qli);
		RouteToScratchpad rts = new RouteToScratchpad(sc);
		Test.startTest();
		PageReference returnedReference = rts.onPageLoad();
		System.assert(returnedReference.getUrl().contains('/c/QuoteProducts'));
		Test.stopTest();
	}
}