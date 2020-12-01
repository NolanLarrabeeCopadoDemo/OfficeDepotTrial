public with sharing class FieldMgr_AccountCustPrdctDataExt
{
  
      public List<AggregateResult> accounts1 = null;
      public Account dummyAccount {get;set;}
      public Set<Id> AccOwners {get;set;}
      public Integer teamSize{get;set;}
      //public Id userRoleID {get;set;}
      public SiteAccounts siteAccount {get;set;}
      private static Map<String,Schema.RecordTypeInfo> rtMapByName = Schema.SObjectType.Account.getRecordTypeInfosByName();
      
      public FieldMgr_AccountCustPrdctDataExt ()
      {
          dummyAccount = new Account();
          dummyAccount.OwnerId = UserInfo.getUserId();
         // userRoleID = UserInfo.getUserRoleId();      
          accounts1 =   getAllLAccountsForCurrentUser();
      }
      
      public List<AggregateResult> getAggregateResult() 
      {
      
         /*  //Get Account Team members of an account of the logged in user 
          List<AccountteamMember> lst_AccountTeam = new List<AccountteamMember>();
          //List<Account> lst_GPID = [select ID from account where GP_ID__C!=null];
          List<Account> lst_GPID = [select ID from account where Hierarchy__c=''];
          Set<Id> set_AccountTeam =new Set<Id>();
          lst_AccountTeam = [Select id, accountid,userid from AccountteamMember where (user.ManagerID =:dummyAccount.OwnerId or user.Manager.ManagerID =:dummyAccount.OwnerId or user.Manager.Manager.ManagerID =:dummyAccount.OwnerId or user.Manager.Manager.Manager.ManagerID =:dummyAccount.OwnerId or userid =:dummyAccount.OwnerId or userid=:dummyAccount.OwnerId)and Accountid=:lst_GPID  ];
          for(AccountteamMember lst_Accountteam1:lst_AccountTeam)
          {
                set_AccountTeam.add(lst_Accountteam1.AccountId);
          }
          Id CustomerRecordTypeID = getRecordTypeId('Customer');
          if(test.isrunningtest())
          {
                Set<ID> currentRoleIds = getAllSubOrdinateRoleID(new Set<ID>{userRoleID});
          }*/
          //Id CustomerRecordTypeID = getRecordTypeId('Customer');
          Set<Id> siteRecordTypeID = new Set<Id>();
          siteRecordTypeID.add(getRecordTypeId('Customer'));
          siteRecordTypeID.add(getRecordTypeId('Customer (OfficeMax)'));
          AccOwners = UserUtils.getAllmyReportees(dummyAccount.OwnerId);
          teamSize = AccOwners.size();
          return [SELECT
                     sum(Paper_TY__c) Paper_TY,
                     sum(Paper_LY__c) Paper_LY,             
                     sum(Ink_Toner_TY__c) Ink_Toner_TY__c,
                     sum(Ink_Toner_LY__c) Ink_Toner_LY__c,             
                     sum(Furniture_TY__c) Furniture_TY__c,
                     sum(Furniture_LY__c) Furniture_LY__c,             
                     sum(Furniture_Pot__c) Furniture_Pot__c,             
                     sum(CBS_TY__c) CBS_TY__c,
                     sum(CBS_LY__c) CBS_LY__c,             
                     sum(CPD_TY__c) CPD_TY__c,
                     sum(CPD_LY__c) CPD_LY__c,             
                     sum(Tech_TY__c) Tech_TY__c,
                     sum(Tech_LY__c) Tech_LY__c,            
                     sum(Filing_Binding_TY__c) Filing_Binding_TY__c, 
                     sum(Filing_Binding_LY__c) Filing_Binding_LY__c,            
                     sum(Labels_Forms_TY__c) Labels_Forms_TY__c,
                     sum(Labels_Forms_LY__c) Labels_Forms_LY__c,             
                     sum(Writing_Drafting_TY__c) Writing_Drafting_TY__c,             
                     sum(Writing_Drafting_LY__c) Writing_Drafting_LY__c,             
                     sum(Office_Essentials_TY__c) Office_Essentials_TY__c,
                     sum(Office_Essentials_LY__c) Office_Essentials_LY,            
                     sum(MPS_TY__c) MPS_TY__c,
                     sum(MPS_LY__c) MPS_LY__c,            
                     sum(Miscellaneous_TY__c) Miscellaneous_TY__c,
                     sum(Miscellaneous_LY__c) Miscellaneous_LY__c,             
                     sum(Total_TY_Sales_to_Date__c) Total_TY_Sales_to_Date__c ,             
                     sum(Total_LY_Sales_to_Date__c) Total_LY_Sales_to_Date__c,             
                     sum(Total_Sales_Diff__c) Total_Sales_Diff__c ,
                     sum(Total_Potential_to_Date__c) Total_Potential_to_Date
                     FROM Account WHERE OwnerId in: AccOwners And RecordTypeId IN:siteRecordTypeID AND (Hierarchy__c = 'C' or Hierarchy__c='S')];
                    
       }
      
      //================================================================================//
      //Get Record Type Id from record Type Name
      //================================================================================//
      public static  Id getRecordTypeId(String recordTypeName) 
      {
            RecordTypeInfo siteRecordType = rtMapByName.get(recordTypeName); 
            if(siteRecordType == null) return null;
            
            return siteRecordType.getRecordTypeId();
      }   
      
       //-------------------------------------------------------------------------------------------//
       //Recursively iterate through the Role hierarchy, to retrieve all roles reporting this role
       //-------------------------------------------------------------------------------------------//
       private Set<ID> getAllSubOrdinateRoleID(Set<ID> parentRoleIds) 
       {
             Set<ID> currentRoleIds = new Set<ID>();
             for(UserRole userRole :[SELECT Id FROM UserRole WHERE ParentRoleId IN :parentRoleIds AND ParentRoleID != null]) 
             {
                   currentRoleIds.add(userRole.Id);
             }
             if(currentRoleIds.size() > 0) 
             {
                   currentRoleIds.addAll(getAllSubOrdinateRoleID(currentRoleIds));
             }
             return currentRoleIds;
             
       }
       
      //---------------------------------------------------------//
      // To populate data based on selected user
      //---------------------------------------------------------//   
      public PageReference Refresh() 
      {
           // User user = [Select UserRoleId From User Where Id = :dummyAccount.OwnerId];
           // userRoleID = user.UserRoleId;
            accounts1 =   getAllLAccountsForCurrentUser();
            return null;
      } 
      
      
      
      //---------------------------------------------------//
      //  To calculate the difference
      //---------------------------------------------------//
      public Double calculate_diff_per(Double tysales, Double lysales )
      { 
            Decimal diff=0;
            if(tysales != null && lysales != null)
            {
                   diff = (tysales-lysales);
            }   
            return diff; 
      } 
      
       public List<AggregateResult> getAllLAccountsForCurrentUser()
       {
               siteAccount = new SiteAccounts();  
               Id CustomerRecordTypeID = getRecordTypeId('Customer');
               List<AggregateResult> results =  getAggregateResult();
               for (AggregateResult ar : results)
               { 
                
                    siteAccount.Paper_TY = (Double)ar.get('Paper_TY');
                    siteAccount.Paper_LY  = (Double)ar.get('Paper_LY');
                    siteAccount.Ink_Toner_TY  = (Double)ar.get('Ink_Toner_TY__c');
                    siteAccount.Ink_Toner_LY  = (Double)ar.get('Ink_Toner_LY__c');
                    siteAccount.Furniture_TY  = (Double)ar.get('Furniture_TY__c');
                    siteAccount.Furniture_LY  = (Double)ar.get('Furniture_LY__c');
                    siteAccount.CBS_TY  = (Double)ar.get('CBS_TY__c');
                    siteAccount.CBS_LY  = (Double)ar.get('CBS_LY__c');
                    siteAccount.CPD_TY  = (Double)ar.get('CPD_TY__c');
                    siteAccount.CPD_LY  = (Double)ar.get('CPD_LY__c');
                    siteAccount.Tech_TY  = (Double)ar.get('Tech_TY__c');    
                    siteAccount.Tech_LY  = (Double)ar.get('Tech_LY__c');
                    siteAccount.Filing_Binding_TY  = (Double)ar.get('Filing_Binding_TY__c');
                    siteAccount.Filing_Binding_LY  = (Double)ar.get('Filing_Binding_LY__c');
                    siteAccount.Labels_Forms_TY  = (Double)ar.get('Labels_Forms_TY__c');
                    siteAccount.Labels_Forms_LY  = (Double)ar.get('Labels_Forms_LY__c');
                    siteAccount.Writing_Drafting_TY  = (Double)ar.get('Writing_Drafting_TY__c');
                    siteAccount.Writing_Drafting_LY  = (Double)ar.get('Writing_Drafting_LY__c');
                    siteAccount.Office_Essentials_TY  = (Double)ar.get('Office_Essentials_TY__c');
                    siteAccount.Office_Essentials_LY  = (Double)ar.get('Office_Essentials_LY');
                    siteAccount.MPS_TY  = (Double)ar.get('MPS_TY__c');
                    siteAccount.MPS_LY  = (Double)ar.get('MPS_LY__c');
                    siteAccount.Miscellaneous_TY  = (Double)ar.get('Miscellaneous_TY__c');
                    siteAccount.Miscellaneous_LY  = (Double)ar.get('Miscellaneous_LY__c');
                    siteAccount.Total_TY_Sales_to_Date  = (Double)ar.get('Total_TY_Sales_to_Date__c');
                    siteAccount.Total_LY_Sales_to_Date  = (Double)ar.get('Total_LY_Sales_to_Date__c');
                    siteAccount.Total_Sales_Diff  = (Double)ar.get('Total_Sales_Diff__c');
                    
               }
              
            
              //Caculate Diff for all Products  
              siteAccount.Total_Sales_Diff = calculate_diff_per(siteAccount.Total_TY_Sales_to_Date,siteAccount.Total_LY_Sales_to_Date);
              siteAccount.Paper_Diff = calculate_diff_per(siteAccount.Paper_TY,siteAccount.Paper_LY);
              siteAccount.Ink_Toner_Diff = calculate_diff_per(siteAccount.Ink_Toner_TY,siteAccount.Ink_Toner_LY);
              siteAccount.Furniture_Diff = calculate_diff_per(siteAccount.Furniture_TY,siteAccount.Furniture_LY);
              siteAccount.CBS_Diff = calculate_diff_per(siteAccount.CBS_TY,siteAccount.CBS_LY);
              siteAccount.CPD_Diff = calculate_diff_per(siteAccount.CPD_TY,siteAccount.CPD_LY);
              siteAccount.Tech_Diff = calculate_diff_per(siteAccount.Tech_TY,siteAccount.Tech_LY);
              siteAccount.Filing_Binding_Diff = calculate_diff_per(siteAccount.Filing_Binding_TY,siteAccount.Filing_Binding_LY);
              siteAccount.Labels_Forms_Diff = calculate_diff_per(siteAccount.Labels_Forms_TY,siteAccount.Labels_Forms_LY);
              siteAccount.Writing_Drafting_Diff = calculate_diff_per(siteAccount.Writing_Drafting_TY,siteAccount.Writing_Drafting_LY);
              siteAccount.MPS_Diff = calculate_diff_per(siteAccount.MPS_TY,siteAccount.MPS_LY);    
              siteAccount.Office_Essentials_Diff = calculate_diff_per(siteAccount.Office_Essentials_TY,siteAccount.Office_Essentials_LY);
              siteAccount.Miscellaneous_Diff = calculate_diff_per(siteAccount.Miscellaneous_TY,siteAccount.Miscellaneous_LY);
            
               
                  
               return results;            
      }  
      public class SiteAccounts
      {
              public SiteAccounts()
              {
                    Paper_TY = 0.0; 
                    Paper_LY = 0.0; 
                    Paper_Diff = 0.0; 
                    Ink_Toner_TY = 0.0;
                    Ink_Toner_LY = 0.0;
                    Ink_Toner_Diff = 0.0;
                    Furniture_TY = 0.0;
                    Furniture_LY = 0.0;
                    Furniture_Diff = 0.0;   
                    CBS_TY = 0.0;
                    CBS_LY = 0.0;
                    CBS_Diff = 0.0; 
                    CPD_TY = 0.0;
                    CPD_LY = 0.0;
                    CPD_Diff = 0.0;
                    Tech_TY = 0.0;
                    Tech_LY = 0.0;
                    Tech_Diff = 0.0;  
                    Filing_Binding_TY = 0.0;
                    Filing_Binding_LY = 0.0;
                    Filing_Binding_Diff = 0.0; 
                    Labels_Forms_TY = 0.0;
                    Labels_Forms_LY = 0.0;
                    Labels_Forms_Diff = 0.0; 
                    Writing_Drafting_TY = 0.0;
                    Writing_Drafting_LY = 0.0;
                    Writing_Drafting_Diff = 0.0;
                    Office_Essentials_TY = 0.0;
                    Office_Essentials_LY = 0.0;
                    Office_Essentials_Diff = 0.0;
                    MPS_TY = 0.0;
                    MPS_LY = 0.0;
                    MPS_Diff = 0.0;
                    Miscellaneous_TY = 0.0;
                    Miscellaneous_LY = 0.0;
                    Miscellaneous_Diff = 0.0;
                    Total_TY_Sales_to_Date = 0.0;
                    Total_LY_Sales_to_Date = 0.0;
                    Total_Sales_Diff = 0.0;
             }
             public Double Paper_TY{get;set;}
             public Double Paper_LY{get;set;}
             public Double Paper_Diff{get;set;}
             public Double Ink_Toner_TY{get;set;}
             public Double Ink_Toner_LY{get;set;}
             public Double Ink_Toner_Diff{get;set;}
             public Double Furniture_TY{get;set;}
             public Double Furniture_LY{get;set;}
             public Double Furniture_Diff{get;set;}   
             public Double CBS_TY{get;set;}
             public Double CBS_LY{get;set;}
             public Double CBS_Diff{get;set;} 
             public Double CPD_TY{get;set;}
             public Double CPD_LY{get;set;}
             public Double CPD_Diff{get;set;}
             public Double Tech_TY{get;set;}
             public Double Tech_LY{get;set;}
             public Double Tech_Diff{get;set;}  
             public Double Filing_Binding_TY{get;set;}
             public Double Filing_Binding_LY{get;set;}
             public Double Filing_Binding_Diff{get;set;} 
             public Double Labels_Forms_TY{get;set;}
             public Double Labels_Forms_LY{get;set;}
             public Double Labels_Forms_Diff{get;set;} 
             public Double Writing_Drafting_TY{get;set;}
             public Double Writing_Drafting_LY{get;set;}
             public Double Writing_Drafting_Diff{get;set;}
             public Double Office_Essentials_TY{get;set;}
             public Double Office_Essentials_LY{get;set;}
             public Double Office_Essentials_Diff{get;set;}
             public Double MPS_TY{get;set;}
             public Double MPS_LY{get;set;}
             public Double MPS_Diff{get;set;}
             public Double Miscellaneous_TY{get;set;}
             public Double Miscellaneous_LY{get;set;}
             public Double Miscellaneous_Diff{get;set;}
             public Double Total_TY_Sales_to_Date{get;set;}
             public Double Total_LY_Sales_to_Date{get;set;}
             public Double Total_Sales_Diff{get;set;}
             
         
      }   
}