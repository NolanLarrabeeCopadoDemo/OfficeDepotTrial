global class OMXAccountClearOutSales_Schedulable_MTD implements Schedulable {

    global void execute(SchedulableContext sc)
    {
    	System.debug('******* OMXAccountClearOutSales execute MTD *************');
    	//clear out MTD sales fields on OfficeMax customer and site accounts
        OMXAccountClearOutSales accBatch = new OMXAccountClearOutSales('MTD');
        database.executebatch(accBatch,2000);    
    }
}