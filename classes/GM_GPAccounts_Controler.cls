public with sharing class GM_GPAccounts_Controler{
    
   
    public Map<String,List<ExtendedAcc>> MapOfRegionAndAccount{get;set;}
    public Map<String,Map<String,List<ExtendedAcc>>> MapRegion_Magager_Accounts{get;set;}
    public Map<String, Integer >MapOfRegionAndAccount_size{get;set;}
    public integer count{get;set;}
    public String selectedRegion{get;set;}
    public List<selectOption>lstOption{get;set;}
    public Set<String> u_region = new Set<String>();
    public Integer SS{get;set;}
    public Set<String> getu_region(){
        return this.u_region;
    }
    public void setu_region(Set<String> lst){
        this.u_region=lst;
    }
//ApexPages.StandardController controller
    public GM_GPAccounts_Controler() {         
       ReportData();  
       
    
    }
    

    public void ReportData(){
        MapRegion_Magager_Accounts = new Map<String,Map<String,List<ExtendedAcc>>>();
       List<Account> lst_GPID = [select ID from account where GP_ID__C!=null];
       List<AccountTeamMember> act= [Select id, accountid,userid,User.region__c,User.Name,User.Manager.Name from AccountteamMember 
       where (user.Manager.ID =:userinfo.getuserid() or user.Manager.Manager.ID =:userinfo.getuserid() or 
       user.Manager.Manager.Manager.ID =:userinfo.getuserid() or 
       user.Manager.Manager.Manager.Manager.ID =:userinfo.getuserid() or userid =:userinfo.getuserid() )
       and Accountid=:lst_GPID];

       
       Map<Id,Account> MapOfIdAndAccount = new Map<Id,Account>([Select Id,Name,Cust_ID__c,
       YTD_Sales_TY__c,YTD_Sales_LY__c,YTD_Sales_Diff__c,Open_Opp_Amt__c,Customer_Lifecycle__c,Last_Order_Date__c,
       OwnerId,Owner.name,owner.Region__c,Owner.Manager.Name From Account where GP_Id__c!=null ]);
        
       // sushma

       set<id> accntid = new set<id>();
       user current_user = [select id,name,region__c,Manager.name from user where id=:userinfo.getuserid()];

       for(account Primary_GP : [select Id,Name,Cust_ID__c,OwnerId,Owner.name,owner.Region__c,Owner.Manager.Name,YTD_Sales_TY__c,YTD_Sales_LY__c,YTD_Sales_Diff__c,Open_Opp_Amt__c,Customer_Lifecycle__c,Last_Order_Date__c from account where ownerid =:userinfo.getuserid() and GP_ID__C!=null]){
        
        accntid.add(Primary_GP.id);
       
       }
       //sushma
       
       for(AccountTeamMember AccountTeam:act)
       {
        
        accntid.add(AccountTeam.accountid);
        
       }
       
       
        for(id accid : accntid){
        Account Accou = new Account();
        Accou = MapOfIdAndAccount.get(accid);
        //////////////////////////////////////////////////////////
            ExtendedAcc b = new ExtendedAcc();
            b.AccId = Accou.Id;
            b.AccName = Accou.Name;
            b.Cust_ID = Accou.Cust_ID__c;
            b.YTD_Sales_TY = Accou.YTD_Sales_TY__c;
          
            b.YTD_Sales_LY=Accou.YTD_Sales_LY__c;
           
            b.YTD_Sales_Diff =Accou.YTD_Sales_Diff__c;
            b.Customer_Lifecycle = Accou.Customer_Lifecycle__c;
            if(Accou.Last_Order_Date__c!= null)
            {
                Date s =Date.valueof(Accou.Last_Order_Date__c);
                string s1=s.month()+'/'+s.day()+'/'+s.year();           
                b.Last_Order_Date = s1;
            }
            b.Region = current_user.Region__c;
            b.RepName = current_user.name;
            b.RepManager = current_user.Manager.Name;
        //////////////////////////////////////////////////////////
       
        if(MapRegion_Magager_Accounts.get(current_user.Region__c) != null){
                if((MapRegion_Magager_Accounts.get(current_user.Region__c).get(current_user.Manager.Name))!= null){
                    MapRegion_Magager_Accounts.get(current_user.Region__c).get(current_user.Manager.Name).add(b);
                }else{
                    
                    List<ExtendedAcc> set_account_alias = new List<ExtendedAcc>();
                    set_account_alias.add(b);
                    MapRegion_Magager_Accounts.get(current_user.Region__c).put(current_user.Manager.Name,set_account_alias);
                }
            
            }//OuterMap
            else{
                //Map<String,Map<String,List<ExtendedAcc>>> iMapRegion_Magager_Accounts = new Map<String,Map<String,List<ExtendedAcc>>>();
                Map<String, List<ExtendedAcc>> imanagerMap = new Map<String, List<ExtendedAcc>>();
                List<ExtendedAcc> iset_account_alias = new List<ExtendedAcc>();
                iset_account_alias.add(b);
                imanagerMap.put(current_user.Manager.Name,iset_account_alias);
                MapRegion_Magager_Accounts.put(current_user.Region__c,imanagerMap);
            
            
            }
        }
       
       SS = MapRegion_Magager_Accounts.size();
    
    }
    
    

    
    class ExtendedAcc{
        public String AccId{get;set;}
        public String AccName{get;set;}
        public String Cust_ID{get;set;}
        public Double YTD_Sales_TY{get;set;}
        public Double YTD_Sales_LY{get;set;}
        public Double YTD_Sales_Diff{get;set;}
        public String Customer_Lifecycle{get;set;}
        public String Last_Order_Date{get;set;}
        public String Region{get;set;}
        public String RepName{get;set;}
        public String RepManager{get;set;}
        
    }

}