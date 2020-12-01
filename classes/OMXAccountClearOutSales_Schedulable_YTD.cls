global class OMXAccountClearOutSales_Schedulable_YTD implements Schedulable {
	
    global void execute(SchedulableContext sc)
    {
    	System.debug('******* OMXAccountClearOutSales execute: YTD *************');
    	//clear out YTD, QTD and MTD sales fields on OfficeMax customer and site accounts
        OMXAccountClearOutSales accBatch = new OMXAccountClearOutSales('YTD');
        database.executebatch(accBatch,2000);    
    }
}