// Functionality  Sales Data
trigger SalesDataAfterTrigger  on Sales_Data__c (after insert) 
{
    SalesData_handler.SaleDataAfter(trigger.new);
}