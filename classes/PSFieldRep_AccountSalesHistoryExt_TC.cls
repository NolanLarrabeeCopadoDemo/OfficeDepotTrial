/***
Description: Test class for 'PSFieldRep_AccountSalesHistoryExtension' apex controller
Created By: Subhrajyoti Chakraborty
Created Date: 13-Aug-2012

Modified By:
Modified Date:

Modify Reason:
**/

@Istest
public class PSFieldRep_AccountSalesHistoryExt_TC
{
    public static testMethod void PSFieldRep_AccountSalesHistoryExt_TC() 
    {
        PSFieldRep_AccountSalesHistoryExtension psf=new PSFieldRep_AccountSalesHistoryExtension();
        psf.getAllSiteAccountsForCurrentUser();
        List<AggregateResult> lacc= new List<AggregateResult>();
        
        
    }
}