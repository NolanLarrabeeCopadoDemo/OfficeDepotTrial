/**************************************************************
*Name           : FieldMgr_AcctCustSalesHistExt_AccTeam_TC 
*Created By     : Wipro Offshore
*Created Date   : 26th Sept,2012
*Purpose        : To test FieldMgr_AcctCustSalesHistoryExt_AccTeam
********************************************************************/
@isTest(SeeAllData = false)
private class FieldMgr_AcctCustSalesHistExt_AccTeam_TC {

    @isTest 
    private static void FieldMgr_AcctCustSalesHistExt_AccTeam_TC() { 
        
        UserRole ContractDivisionRoleId = [SELECT Id from UserRole WHERE Name = 'Contract Division' limit 1];
        User userWithContractDivisionRole = [SELECT Id, Name FROM User WHERE UserRoleId = :ContractDivisionRoleId.Id AND isActive = true limit 1];
        
        System.runAs(userWithContractDivisionRole){
            Account account =  Test_Utils.CreateAccountForSalesHistory();
            
            Account acc2 = new Account();
            acc2.GP_ID__c='1234';
            acc2.name='Abcs';
            insert acc2;
            
            AccountteamMember AccteamMember=new AccountteamMember();
            AccteamMember.accountid=acc2.id;
            AccteamMember.userid=userWithContractDivisionRole.id;
            insert AccteamMember;
            
            FieldMgr_AcctCustSalesHistoryExt_AccTeam extension = new FieldMgr_AcctCustSalesHistoryExt_AccTeam();
            
            Test.startTest(); 
            List<AggregateResult> aggregateResult =  extension.getAggregateResult();
            
            extension.refresh();          
           // extension.getAllSubOrdinateRoleID(set_userRole);
            Test.stopTest();
            
        }
    }
}