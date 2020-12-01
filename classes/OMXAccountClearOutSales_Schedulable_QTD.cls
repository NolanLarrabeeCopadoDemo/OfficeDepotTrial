global class OMXAccountClearOutSales_Schedulable_QTD implements Schedulable {
	
    global void execute(SchedulableContext sc)
    {
    	System.debug('******* OMXAccountClearOutSales execute: QTD *************');
        OMXAccountClearOutSales accBatch = new OMXAccountClearOutSales('QTD');
        database.executebatch(accBatch,2000);    
    }
}