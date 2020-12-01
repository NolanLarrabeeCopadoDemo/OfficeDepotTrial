public class Log_Object_Methods {
    
    Private static Datetime Now = System.now();
    // Related - 00485655 
    Private static Id Log_Tax_Type = Schema.SObjectType.Log_Object__c.getRecordTypeInfosByName().get('Tax Exempt Email Notification').getRecordTypeId();
    
    Public Log_Object__c CreateLog(string ProcessFired, string GenericStr2, string GenericStr3, date Lg_Date, id account, id Rcdtyp) 
    	{
          //  System.debug( ProcessFired + ' - ' +  GenericStr2 + ' - ' +  GenericStr3 + ' - ' +  Lg_Date + ' - ' +  account + ' - ' + Rcdtyp );
         Log_Object__c Log = New Log_Object__c
            (
         		Name = ProcessFired + GenericStr3 + ' - ' + Now.format('MM-DD-yyyy'),
                Recordtypeid = Rcdtyp,
                Activity_DateTime__c = Now,
                Profile_Unique_Name__c = Rcdtyp == Log_Tax_Type ? GenericStr2 : '',
                Log_Date__c = Lg_Date,
                Process_Fired__c = ProcessFired,
                Related_Account__c = account
         	);   

            Return Log;
        }
        
    
    
}