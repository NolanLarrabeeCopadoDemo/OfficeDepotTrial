/************************************************************
*Name           : PSFieldMgr_AccountSalesHistoryExtension
*Created By     : Suneil Moonasar (Office Depot)
*Created Date   : 20 Apr 2012
*Purpose        : To Show Accont Sales History - Public Sector
****************************************************************/
public with sharing class PSFieldMgr_AccountSalesHistoryExtension extends FieldRep_AccountSalesHistoryExtension{
  
    public override List<AggregateResult> getAggregateResult() {
        System.debug('------------ '+ dummyAccount.OwnerId);
    Set<Id> siteRecordTypeID = new Set<Id>();
    siteRecordTypeID.add(getRecordTypeId('Site'));
    siteRecordTypeID.add(getRecordTypeId('Site (OfficeMax)'));
    return [SELECT 
            sum(MTD_Sales_TY__c) MTD_Sales_TY__c,
            sum(MTD_Sales_TY_IMU__c) MTD_Sales_TY_IMU2__c,
            sum(MTD_Sales_LY__c) MTD_Sales_LY__c,
            sum(MTD_Sales_LY_IMU__c) MTD_Sales_LY_IMU2__c,
            sum(MTD_Sales_Diff__c) MTD_Sales_Diff__c, 
            sum(Monthly_LY__c) Monthly_LY__c,
            sum(Monthly_LY_IMU__c) Monthly_LY_IMU_Per__c,
            sum(Month_Goal__c) Month_Goal__c,
            sum(ADS_Current_Month__c) ADS_Current_Month__c,
            sum(ADS_Last_Month__c) ADS_Last_Month__c,
            sum(QTD_Sales_TY__c) QTD_Sales_TY__c,
            sum(QTD_Sales_TY_IMU__c) QTD_Sales_TY_IMU2__c,
            sum(QTD_Sales_LY__c) QTD_Sales_LY__c,
            sum(QTD_Sales_LY_IMU__c) QTD_Sales_LY_IMU2__c,
            sum(QTD_Sales_Diff__c) QTD_Sales_Diff__c,
            sum(Quarter_LY__c) Quarter_LY__c,
            sum(Quarter_LY_IMU__c) Quarter_LY_IMU_per__c,
            sum(Quarter_Goal__c) Quarter_Goal__c,
            sum(ADS_Current_Qtr__c) ADS_Current_Qtr__c,
            sum(ADS_Last_Qtr__c) ADS_Last_Qtr__c,
            sum(YTD_Sales_TY__c) YTD_Sales_TY__c,
            sum(YTD_Sales_TY_IMU__c) YTD_Sales_TY_IMU2__c,
            sum(YTD_Sales_LY__c) YTD_Sales_LY__c,
            sum(YTD_Sales_LY_IMU__c) YTD_Sales_LY_IMU2__c,
            sum(YTD_Sales_Diff__c) YTD_Sales_Diff__c,
            sum(Year_LY__c) Year_LY__c,
            sum(Year_LY_IMU__c) Year_LY_IMU_per__c,
            sum(Year_Goal__c) Year_Goal__c,
            sum(ADS_Current_Yr__c) ADS_Current_Yr__c,
            sum(ADS_Last_Yr__c) ADS_Last_Yr__c
            FROM Account WHERE RecordTypeId IN: siteRecordTypeID and Sector__c = 'Public' and Segment__c != 'Federal'
            //AND (ownerId=:UserInfo.getUserId() OR owner.UserRoleID In :getAllSubOrdinateRoleID(new Set<ID>{UserInfo.getUserRoleId()})) ];
            AND (OwnerID = :dummyAccount.OwnerId OR owner.UserRoleID In :getAllSubOrdinateRoleID(new Set<ID>{userRoleID}))];
  }
  
   //------------------------------------------------------------------------------------------//
   //Recursively iterate through the Role hierarchy, to retrieve all roles reporting this role
   //------------------------------------------------------------------------------------------//
   private Set<ID> getAllSubOrdinateRoleID(Set<ID> parentRoleIds) {
     Set<ID> currentRoleIds = new Set<ID>();
     for(UserRole userRole :[SELECT Id FROM UserRole WHERE ParentRoleId IN :parentRoleIds AND ParentRoleID != null]) {
       currentRoleIds.add(userRole.Id);
     }
     if(currentRoleIds.size() > 0) {
       currentRoleIds.addAll(getAllSubOrdinateRoleID(currentRoleIds));
     }
     return currentRoleIds;
   }
   
   
   //------------------------------------------------------------------------------------------//
   // To get data according to selected user
   //------------------------------------------------------------------------------------------//  
   public PageReference Refresh() {
        User user = [Select UserRoleId From User Where Id = :dummyAccount.OwnerId]; 
        userRoleID = user.UserRoleId;
        RefreshAccounts();
        return null;
   }
   
   @isTest 
    private static void testAccountSalesHistoryForManager() { 
        
        UserRole ContractDivisionRoleId = [SELECT Id from UserRole WHERE Name = 'Contract Division' limit 1];
        User userWithContractDivisionRole = [SELECT Id, Name FROM User WHERE UserRoleId = :ContractDivisionRoleId.Id AND isActive = true limit 1];
        
        System.runAs(userWithContractDivisionRole){
            Account siteAccount =  Test_Utils.CreateAccountForSalesHistory();
            siteAccount.Sector__c = 'Public';
            siteAccount.Segment__c = 'Local'; 
            update siteAccount; 
            
            PSFieldMgr_AccountSalesHistoryExtension extension = new PSFieldMgr_AccountSalesHistoryExtension();
            Test.startTest(); 
            List<AggregateResult> aggregateResult =  extension.getAggregateResult();
            
            extension.refresh();
            System.assertEquals((Double)aggregateResult[0].get('Year_Goal__c'), 10);
            System.assertEquals((Double)aggregateResult[0].get('YTD_Sales_LY__c'), 15);
            System.assertEquals((Double)aggregateResult[0].get('MTD_Sales_TY__c'), 2);
            System.assertEquals((Double)aggregateResult[0].get('Month_Goal__c'), 05);
            System.assertEquals((Double)aggregateResult[0].get('ADS_Last_Qtr__c'), 10);
            System.assertEquals((Double)aggregateResult[0].get('Quarter_Goal__c'), 8);
            System.assertEquals((Double)aggregateResult[0].get('ADS_Current_Month__c'), 6);
            
            Test.stopTest();
        }
    }

}