/*************************************************************
*Name           : FieldMgr_AccountCustProductDataExtension
*Created By     : Dheeraj (Appirio Off)
*Created Date   : 08 Feb 2012
*Updated On     : 20 March 2012
*Purpose        : To calculate sum of product data based on selected user (default is logged-in user)
****************************************************************/
public with sharing class FieldMgr_AccountCustProductDataExtension extends FieldRep_AccountCustProductDataExtension {
  
  public override List<AggregateResult> getAggregateResult() {          
    Set<Id> siteRecordTypeID = new Set<Id>();
    siteRecordTypeID.add(getRecordTypeId('Customer'));
    siteRecordTypeID.add(getRecordTypeId('Customer (OfficeMax)'));
    return [SELECT
             sum(Paper_TY__c) Paper_TY,
             //sum(Paper_IMU_TY__c) Paper_IMU_TY,
             sum(Paper_LY__c) Paper_LY,
             //sum(paper_IMU_LY__c) paper_IMU_LY,
             //sum(Paper_Diff__c) Paper_Diff,
             //sum(Paper_Pot__c) Paper_Pot__c,
             //sum(Paper_Last_Order_amt__c) Paper_Last_Order_amt__c,
             //max(Paper_Last_Order__c) Paper_Last_Order__c,
             sum(Ink_Toner_TY__c) Ink_Toner_TY__c,
             //sum(Ink_Toner_IMU_TY__c) Ink_Toner_IMU_TY__c,
             sum(Ink_Toner_LY__c) Ink_Toner_LY__c,
             //sum(Ink_Toner_IMU_LY__c) Ink_Toner_IMU_LY__c,
             //sum(Ink_Toner_Diff__c) Ink_Toner_Diff__c,
             //sum(Ink_Toner_Pot__c) Ink_Toner_Pot__c,
             //max(Ink_Toner_Last_Order__c) Ink_Toner_Last_Order__c,
             //sum(Ink_Toner_Last_Order_amt__c) Ink_Toner_Last_Order_amt,
             sum(Furniture_TY__c) Furniture_TY__c,
             //sum(Furniture_IMU_TY__c) Furniture_IMU_TY__c,
             sum(Furniture_LY__c) Furniture_LY__c,
             //sum(Furniture_IMU_LY__c) Furniture_IMU_LY__c,
             // sum(Furniture_Diff__c) Furniture_Diff__c,
             sum(Furniture_Pot__c) Furniture_Pot__c,
             //max(Furniture_Last_Order__c) Furniture_Last_Order__c,
             //sum(Furniture_last_order_amt__c) Furniture_last_order_amt,
             sum(CBS_TY__c) CBS_TY__c,
             //sum(CBS_IMU_TY__c) CBS_IMU_TY__c,
             sum(CBS_LY__c) CBS_LY__c,
             //sum(CBS_IMU_LY__c) CBS_IMU_LY__c,
             //sum(CBS_Diff__c) CBS_Diff__c,
             //sum(CBS_Pot__c) CBS_Pot__c,
             //max(CBS_Last_Order__c) CBS_Last_Order__c,
             //sum(CBS_Last_order_amt__c) CBS_Last_order_amt__c,
             sum(CPD_TY__c) CPD_TY__c,
             //sum(CPD_IMU_TY__c) CPD_IMU_TY__c,
             sum(CPD_LY__c) CPD_LY__c,
             //sum(CPD_IMU_LY__c) CPD_IMU_LY__c,
             //sum(CPD_Diff__c) CPD_Diff__c,
             //sum(CPD_Pot__c) CPD_Pot__c,
             //max(CPD_Last_Order__c) CPD_Last_Order__c,
             //sum(CPD_Last_order_amt__c) CPD_Last_order_amt__c,
             sum(Tech_TY__c) Tech_TY__c,
             //sum(Tech_IMU_TY__c) Tech_IMU_TY__c,
             sum(Tech_LY__c) Tech_LY__c,
             //sum(Tech_IMU_LY__c) Tech_IMU_LY__c,
             //sum(Tech_Diff__c) Tech_Diff__c,
             //sum(Tech_Pot__c) Tech_Pot__c,
             //max(Tech_Last_Order__c) Tech_Last_Order__c,
             //sum(Tech_Last_Order_amt__c) Tech_Last_Order_amt__c,
             sum(Filing_Binding_TY__c) Filing_Binding_TY__c, 
             //sum(Filing_Binding_IMU_TY__c) Filing_Binding_IMU_TY__c,
             sum(Filing_Binding_LY__c) Filing_Binding_LY__c,
             //sum(Filing_Binding_IMU_LY__c) Filing_Binding_IMU_LY__c,
             //sum(Filing_Binding_Diff__c) Filing_Binding_Diff__c,
             //sum(Filing_Binding_Pot__c) Filing_Binding_Pot__c,
             //max(Filing_Binding_Last_Order__c) Filing_Binding_LO,
             //sum(Filing_Binding_Last_Order_amt__c) Filing_Binding_LO_amt,
             sum(Labels_Forms_TY__c) Labels_Forms_TY__c,
             //sum(Labels_Forms_IMU_TY__c) Labels_Forms_IMU_TY__c,
             sum(Labels_Forms_LY__c) Labels_Forms_LY__c,
             //sum(Labels_Forms_IMU_LY__c) Labels_Forms_IMU_LY__c,
             //sum(Labels_Forms_Diff__c) Labels_Forms_Diff__c ,
             //sum(Labels_Forms_Pot__c) Labels_Forms_Pot__c,
             //max(Labels_Forms_Last_Order__c) Labels_Forms_LO__c,
             //sum(Labels_Forms_Last_Order_amt__c) Labels_Forms_LO_amt,
             sum(Writing_Drafting_TY__c) Writing_Drafting_TY__c,
             //sum(nvl(Writing_Drafting_IMU_TY__c,0)) Writing_Drafting_IMU_TY,
             // sum(Writing_Drafting_IMU_LY__c) Writing_Drafting_IMU_TY,
             sum(Writing_Drafting_LY__c) Writing_Drafting_LY__c,
             //sum(Writing_Drafting_IMU_LY__c) Writing_Drafting_IMU_LY,
             //sum(Writing_Drafting_Diff__c) Writing_Drafting_Diff__c,
             //sum(Writing_Drafting_Pot__c) Writing_Drafting_Pot__c,
             //max(Writing_Drafting_Last_Order__c) Writing_Drafting_LO,
             //sum(Writing_Drafting_Last_Order_amt__c) Writing_Drafting_LO_amt,
             sum(Office_Essentials_TY__c) Office_Essentials_TY__c,
             //sum(Office_Essentials_IMU_TY__c) Office_Essentials_IMU_TY,
             sum(Office_Essentials_LY__c) Office_Essentials_LY,
             //sum(Office_Essentials_IMU_LY__c) Office_Essentials_IMU_LY,
             //sum(Office_Essentials_Diff__c) Office_Essentials_Diff__c,
             //sum(Office_Essentials_Pot__c) Office_Essentials_Pot__c,
             //max(Office_Essentials_Last_Order__c) Office_Essentials_LO,
             //sum(Office_Essentials_Last_Order_amt__c) Office_Essentials_LO_amt,
             sum(MPS_TY__c) MPS_TY__c,
             //sum(MPS_IMU_TY__c) MPS_IMU_TY__c,
             sum(MPS_LY__c) MPS_LY__c,
             //sum(MPS_IMU_LY__c) MPS_IMU_LY__c,
             //sum(MPS_Diff__c) MPS_Diff__c,
             //sum(MPS_Pot__c) MPS_Pot__c,
             //max(MPS_Last_Order__c) MPS_Last_Order__c,
             //sum(MPS_Last_order_amt__c) MPS_Last_order_amt__c,
             sum(Miscellaneous_TY__c) Miscellaneous_TY__c,
             //sum(Miscellaneous_IMU_TY__c) Miscellaneous_IMU_TY__c,
             sum(Miscellaneous_LY__c) Miscellaneous_LY__c,
             //sum(Miscellaneous_IMU_LY__c) Miscellaneous_IMU_LY__c,
             //sum(Miscellaneous_Diff__c) Miscellaneous_Diff__c,
             //sum(Miscellaneous_Pot__c) Miscellaneous_Pot__c,
             //max(Miscellaneous_Last_Order__c) Miscellaneous_LO ,
             //sum(Miscellaneous_Last_Order_amt__c)  Miscellaneous_LO_amt,
             sum(Total_TY_Sales_to_Date__c) Total_TY_Sales_to_Date__c ,
             //sum(YTD_Sales_TY_IMU__c) Total_TY_IMU_per__c ,
             sum(Total_LY_Sales_to_Date__c) Total_LY_Sales_to_Date__c,
             //sum(Year_LY_IMU__c)  Total_LY_IMU_Per__c,
             sum(Total_Sales_Diff__c) Total_Sales_Diff__c ,
             sum(Total_Potential_to_Date__c) Total_Potential_to_Date
             FROM Account WHERE RecordTypeId IN: siteRecordTypeID 
             AND (OwnerID = :dummyAccount.OwnerId OR owner.UserRoleID In :getAllSubOrdinateRoleID(new Set<ID>{userRoleID}))];
             // AND (ownerId=:UserInfo.getUserId() OR owner.UserRoleID In :getAllSubOrdinateRoleID(new Set<ID>{UserInfo.getUserRoleId()})) ];
             //AND (ownerId=:userId /*OR owner.UserRoleID In :getAllSubOrdinateRoleID(new Set<ID>{UserInfo.getUserRoleId()})*/) ];
  }
  
   //-------------------------------------------------------------------------------------------//
   //Recursively iterate through the Role hierarchy, to retrieve all roles reporting this role
   //-------------------------------------------------------------------------------------------//
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
   
  //---------------------------------------------------------//
  // To populate data based on selected user
  //---------------------------------------------------------//   
  public PageReference Refresh() {
    User user = [Select UserRoleId From User Where Id = :dummyAccount.OwnerId];
    userRoleID = user.UserRoleId;
    RefreshAccounts();
    return null;
  }    
     
}