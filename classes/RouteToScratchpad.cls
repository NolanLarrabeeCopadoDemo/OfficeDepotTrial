public class RouteToScratchpad
{
    public String quoteId;
    public String scratchpadUrl;
    PageReference scratchpadPageReference;
    
    public RouteToScratchpad(ApexPages.StandardController controller)
    {
        String quoteLineItemId = controller.getId();
        this.quoteId = [SELECT Id, QuoteId FROM QuoteLineItem WHERE Id = :quoteLineItemId].QuoteId;
        scratchpadUrl = '/c/QuoteProducts.app?recordId=' + quoteId;
        scratchpadPageReference = new PageReference(scratchpadUrl);
    }

	public RouteToScratchpad()
    {
        
    }
    
    public PageReference onPageLoad()
    {
        System.debug(quoteId);
        return scratchpadPageReference;
    }
}