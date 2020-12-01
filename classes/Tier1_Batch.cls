global class Tier1_Batch implements Database.Batchable<sObject>,Database.Stateful,Schedulable  {

    global Database.QueryLocator start(Database.BatchableContext bc)
    { 
        String query =  'SELECT ID, Diversity_Manager__c,MTD_Sales_TY__c,MTD_Sales_TY_IMU__c,MTD_Sales_LY__c,MTD_Sales_LY_IMU__c,QTD_Sales_TY__c, '
            + 'QTD_Sales_TY_IMU__c,QTD_Sales_LY__c,QTD_Sales_LY_IMU__c,YTD_Sales_TY__c,YTD_Sales_TY_IMU__c,YTD_Sales_LY__c, '
            + 'YTD_Sales_LY_IMU__c,Paper_LY__c,Paper_TY__c,Ink_Toner_LY__c,Ink_Toner_TY__c,Furniture_LY__c,Furniture_TY__c, '
            + 'CBS_LY__c,CBS_TY__c,CPD_TY__c,CPD_LY__c,Tech_LY__c,Tech_TY__c,Filing_Binding_LY__c,Filing_Binding_TY__c, '
            + 'Labels_Forms_LY__c,Labels_Forms_TY__c,Writing_Drafting_LY__c,Writing_Drafting_TY__c,Office_Essentials_LY__c, '
            + 'Office_Essentials_TY__c,MPS_LY__c,MPS_TY__c,Miscellaneous_LY__c,Miscellaneous_TY__c,Customer_Count__c, '
            + 'Opportunity_Count__c,Opportunity_Amount__c '
            + 'from Partner__c ';   
        return  Database.getQueryLocator(query);
    }
    global void execute(SchedulableContext sc){
        //Batch size set for each iteration
        integer batch_size = 3;
        Tier1_Batch Tier1Batch = new Tier1_Batch();
        database.executebatch(Tier1Batch,batch_size);
    }
    global void execute(Database.BatchableContext BC, List<sObject> scope){
        List<Partner__c> Part_Upds = New List<Partner__c>();  
        set<ID> iPRT = new Set<ID>();
        set<ID> iDMs = new Set<ID>();
        For (SObject s1 : Scope ) {
            Partner__c p = (Partner__c)s1;
            iPRT.add(p.id);
            iDMs.add(p.Diversity_Manager__c);
        }
        Map<ID, AggregateResult> salesAgg = new Map<id, AggregateResult>([SELECT Tier_1_Partner__r.ID, SUM(MTD_Sales_TY__c) MTD_Sales_TY,SUM(MTD_Sales_TY_IMU__c ) MTD_Sales_TY_IMU,
                                                                          SUM(MTD_Sales_LY__c) MTD_Sales_LY,SUM(MTD_Sales_LY_IMU__c ) MTD_Sales_LY_IMU,SUM(QTD_Sales_TY__c) QTD_Sales_TY,
                                                                          SUM(QTD_Sales_TY_IMU__c ) QTD_Sales_TY_IMU,SUM(QTD_Sales_LY__c) QTD_Sales_LY,SUM(QTD_Sales_LY_IMU__c ) QTD_Sales_LY_IMU,
                                                                          SUM(YTD_Sales_TY__c) YTD_Sales_TY,SUM(YTD_Sales_TY_IMU__c ) YTD_Sales_TY_IMU,SUM(YTD_Sales_LY__c) YTD_Sales_LY,
                                                                          SUM(YTD_Sales_LY_IMU__c ) YTD_Sales_LY_IMU,SUM(Paper_LY__c)  Paper_LY,SUM(Paper_TY__c)  Paper_TY,
                                                                          SUM(Ink_Toner_LY__c)  Ink_Toner_LY,SUM(Ink_Toner_TY__c)  Ink_Toner_TY,SUM(Furniture_LY__c)  Furniture_LY,
                                                                          SUM(Furniture_TY__c)  Furniture_TY,SUM(CBS_LY__c)  CBS_LY,SUM(CBS_TY__c)  CBS_TY,SUM(CPD_TY__c)  CPD_TY,
                                                                          SUM(CPD_LY__c)  CPD_LY,SUM(Tech_LY__c)  Tech_LY,SUM(Tech_TY__c)  Tech_TY,SUM(Filing_Binding_LY__c)  Filing_Binding_LY,
                                                                          SUM(Filing_Binding_TY__c)  Filing_Binding_TY,SUM(Labels_Forms_LY__c)  Labels_Forms_LY,SUM(Labels_Forms_TY__c)  Labels_Forms_TY,
                                                                          SUM(Writing_Drafting_LY__c)  Writing_Drafting_LY,SUM(Writing_Drafting_TY__c)  Writing_Drafting_TY,
                                                                          SUM(Office_Essentials_LY__c)  Office_Essentials_LY,SUM(Office_Essentials_TY__c)  Office_Essentials_TY,
                                                                          SUM(MPS_LY__c)  MPS_LY,SUM(MPS_TY__c)  MPS_TY,SUM(Miscellaneous_LY__c)  Miscellaneous_LY,SUM(Miscellaneous_TY__c)  Miscellaneous_TY,
                                                                          Count(ID) Cust_Cnt 
                                                                          FROM account 
                                                                          Where Tier_1_Partner__r.id in :iPRT
                                                                          Group by Tier_1_Partner__r.ID]); // Sales Aggregate
        
        Map<ID, AggregateResult> oppAgg = new Map<id, AggregateResult>([SELECT Account.Tier_1_Partner__r.ID, Count(ID) Opp_Cnt, SUM(Opportunity_Amount__c) Opp_Amt
                                                                        FROM opportunity 
                                                                        Where Account.Tier_1_Partner__r.id = :iPRT and isClosed  = False
                                                                        Group by Account.Tier_1_Partner__r.ID]); //Opportunity Aggregate
        For (SObject s : Scope ) {
            Partner__c lp = (Partner__c)s;
            IF(salesAgg.get(lP.ID) != null) {
                lP.MTD_Sales_TY__c = salesAgg.get(lP.ID).get('MTD_Sales_TY') == null ? 0 : (decimal)salesAgg.get(lP.ID).get('MTD_Sales_TY');
                lP.MTD_Sales_TY_IMU__c = salesAgg.get(lP.ID).get('MTD_Sales_TY_IMU') == null ? 0 : (decimal)salesAgg.get(lP.ID).get('MTD_Sales_TY_IMU');
                lP.MTD_Sales_LY__c = salesAgg.get(lP.ID).get('MTD_Sales_LY') == null ? 0 : (decimal)salesAgg.get(lP.ID).get('MTD_Sales_LY');
                lP.MTD_Sales_LY_IMU__c = salesAgg.get(lP.ID).get('MTD_Sales_LY_IMU') == null ? 0 : (decimal)salesAgg.get(lP.ID).get('MTD_Sales_LY_IMU');
                lP.QTD_Sales_TY__c = salesAgg.get(lP.ID).get('QTD_Sales_TY') == null ? 0 : (decimal)salesAgg.get(lP.ID).get('QTD_Sales_TY');
                lP.QTD_Sales_TY_IMU__c = salesAgg.get(lP.ID).get('QTD_Sales_TY_IMU') == null ? 0 : (decimal)salesAgg.get(lP.ID).get('QTD_Sales_TY_IMU');                  
                lP.QTD_Sales_LY__c = salesAgg.get(lP.ID).get('QTD_Sales_LY') == null ? 0 : (decimal)salesAgg.get(lP.ID).get('QTD_Sales_LY');
                lP.QTD_Sales_LY_IMU__c = salesAgg.get(lP.ID).get('QTD_Sales_LY_IMU') == null ? 0 : (decimal)salesAgg.get(lP.ID).get('QTD_Sales_LY_IMU');              
                lP.YTD_Sales_TY__c = salesAgg.get(lP.ID).get('YTD_Sales_TY') == null ? 0 : (decimal)salesAgg.get(lP.ID).get('YTD_Sales_TY');
                lP.YTD_Sales_TY_IMU__c = salesAgg.get(lP.ID).get('YTD_Sales_TY_IMU') == null ? 0 : (decimal)salesAgg.get(lP.ID).get('YTD_Sales_TY_IMU');                  
                lP.YTD_Sales_LY__c = salesAgg.get(lP.ID).get('YTD_Sales_LY') == null ? 0 : (decimal)salesAgg.get(lP.ID).get('YTD_Sales_LY');
                lP.YTD_Sales_LY_IMU__c = salesAgg.get(lP.ID).get('YTD_Sales_LY_IMU') == null ? 0 : (decimal)salesAgg.get(lP.ID).get('YTD_Sales_LY_IMU');
                lP.Paper_LY__c = salesAgg.get(lP.ID).get('Paper_LY') == null ? 0 : (decimal)salesAgg.get(lP.ID).get('Paper_LY');
                lP.Paper_TY__c = salesAgg.get(lP.ID).get('Paper_TY') == null ? 0 : (decimal)salesAgg.get(lP.ID).get('Paper_TY');
                lP.Ink_Toner_LY__c = salesAgg.get(lP.ID).get('Ink_Toner_LY') == null ? 0 : (decimal)salesAgg.get(lP.ID).get('Ink_Toner_LY');
                lP.Ink_Toner_TY__c = salesAgg.get(lP.ID).get('Ink_Toner_TY') == null ? 0 : (decimal)salesAgg.get(lP.ID).get('Ink_Toner_TY');
                lP.Furniture_LY__c = salesAgg.get(lP.ID).get('Furniture_LY') == null ? 0 : (decimal)salesAgg.get(lP.ID).get('Furniture_LY');
                lP.Furniture_TY__c = salesAgg.get(lP.ID).get('Furniture_TY') == null ? 0 : (decimal)salesAgg.get(lP.ID).get('Furniture_TY');
                lP.CBS_LY__c = salesAgg.get(lP.ID).get('CBS_LY') == null ? 0 : (decimal)salesAgg.get(lP.ID).get('CBS_LY');
                lP.CBS_TY__c = salesAgg.get(lP.ID).get('CBS_TY') == null ? 0 : (decimal)salesAgg.get(lP.ID).get('CBS_TY');
                lP.CPD_TY__c = salesAgg.get(lP.ID).get('CPD_TY') == null ? 0 : (decimal)salesAgg.get(lP.ID).get('CPD_TY');
                lP.CPD_LY__c = salesAgg.get(lP.ID).get('CPD_LY') == null ? 0 : (decimal)salesAgg.get(lP.ID).get('CPD_LY');
                lP.Tech_LY__c = salesAgg.get(lP.ID).get('Tech_LY') == null ? 0 : (decimal)salesAgg.get(lP.ID).get('Tech_LY');
                lP.Tech_TY__c = salesAgg.get(lP.ID).get('Tech_TY') == null ? 0 : (decimal)salesAgg.get(lP.ID).get('Tech_TY');
                lP.Filing_Binding_LY__c = salesAgg.get(lP.ID).get('Filing_Binding_LY') == null ? 0 : (decimal)salesAgg.get(lP.ID).get('Filing_Binding_LY');
                lP.Filing_Binding_TY__c = salesAgg.get(lP.ID).get('Filing_Binding_TY') == null ? 0 : (decimal)salesAgg.get(lP.ID).get('Filing_Binding_TY');
                lP.Labels_Forms_LY__c = salesAgg.get(lP.ID).get('Labels_Forms_LY') == null ? 0 : (decimal)salesAgg.get(lP.ID).get('Labels_Forms_LY');
                lP.Labels_Forms_TY__c = salesAgg.get(lP.ID).get('Labels_Forms_TY') == null ? 0 : (decimal)salesAgg.get(lP.ID).get('Labels_Forms_TY');
                lP.Writing_Drafting_LY__c = salesAgg.get(lP.ID).get('Writing_Drafting_LY') == null ? 0 : (decimal)salesAgg.get(lP.ID).get('Writing_Drafting_LY');
                lP.Writing_Drafting_TY__c = salesAgg.get(lP.ID).get('Writing_Drafting_TY') == null ? 0 : (decimal)salesAgg.get(lP.ID).get('Writing_Drafting_TY');
                lP.Office_Essentials_LY__c = salesAgg.get(lP.ID).get('Office_Essentials_LY') == null ? 0 : (decimal)salesAgg.get(lP.ID).get('Office_Essentials_LY');
                lP.Office_Essentials_TY__c = salesAgg.get(lP.ID).get('Office_Essentials_TY') == null ? 0 : (decimal)salesAgg.get(lP.ID).get('Office_Essentials_TY');
                lP.MPS_LY__c = salesAgg.get(lP.ID).get('MPS_LY') == null ? 0 : (decimal)salesAgg.get(lP.ID).get('MPS_LY');
                lP.MPS_TY__c = salesAgg.get(lP.ID).get('MPS_TY') == null ? 0 : (decimal)salesAgg.get(lP.ID).get('MPS_TY');
                lP.Miscellaneous_LY__c = salesAgg.get(lP.ID).get('Miscellaneous_LY') == null ? 0 : (decimal)salesAgg.get(lP.ID).get('Miscellaneous_LY');
                lP.Miscellaneous_TY__c = salesAgg.get(lP.ID).get('Miscellaneous_TY') == null ? 0 : (decimal)salesAgg.get(lP.ID).get('Miscellaneous_TY');
                lP.Customer_Count__c = salesAgg.get(lP.ID).get('Cust_Cnt') == null ? 0 : (integer)salesAgg.get(lP.ID).get('Cust_Cnt');
                IF(oppAgg.get(lP.ID) != null) {
                    lP.Opportunity_Count__c = oppAgg.get(lP.ID).get('Opp_Cnt') == null ? 0 : (integer)oppAgg.get(lP.ID).get('Opp_Cnt');
                    lP.Opportunity_Amount__c = oppAgg.get(lP.ID).get('Opp_Amt') == null ? 0 : (decimal)oppAgg.get(lP.ID).get('Opp_Amt');
                } ELSE {
                    lP.Opportunity_Count__c = 0;
                    lP.Opportunity_Amount__c = 0;
                }
                System.Debug('Has Customers: ' + lP.ID);
            } ELSE {
                lP.MTD_Sales_TY__c = 0;
                lP.MTD_Sales_TY_IMU__c = 0;
                lP.MTD_Sales_LY__c = 0;
                lP.MTD_Sales_LY_IMU__c = 0;
                lP.QTD_Sales_TY__c = 0;
                lP.QTD_Sales_TY_IMU__c = 0;
                lP.QTD_Sales_LY__c = 0;
                lP.QTD_Sales_LY_IMU__c = 0;
                lP.YTD_Sales_TY__c = 0;
                lP.YTD_Sales_TY_IMU__c = 0;                  
                lP.YTD_Sales_LY__c = 0;
                lP.YTD_Sales_LY_IMU__c = 0;
                lP.Paper_LY__c = 0;
                lP.Paper_TY__c = 0;
                lP.Ink_Toner_LY__c = 0;
                lP.Ink_Toner_TY__c = 0;
                lP.Furniture_LY__c = 0;
                lP.Furniture_TY__c = 0;
                lP.CBS_LY__c = 0;
                lP.CBS_TY__c = 0;
                lP.CPD_TY__c = 0;
                lP.CPD_LY__c = 0;
                lP.Tech_LY__c = 0;
                lP.Tech_TY__c = 0;
                lP.Filing_Binding_LY__c = 0;
                lP.Filing_Binding_TY__c = 0;
                lP.Labels_Forms_LY__c = 0;
                lP.Labels_Forms_TY__c = 0;
                lP.Writing_Drafting_LY__c = 0;
                lP.Writing_Drafting_TY__c = 0;
                lP.Office_Essentials_LY__c = 0;
                lP.Office_Essentials_TY__c = 0;
                lP.MPS_LY__c = 0;
                lP.MPS_TY__c = 0;
                lP.Miscellaneous_LY__c = 0;
                lP.Miscellaneous_TY__c = 0;
                lP.Customer_Count__c = 0;
                IF(oppAgg.get(lP.ID) != null) {
                    lP.Opportunity_Count__c = oppAgg.get(lP.ID).get('Opp_Cnt') == null ? 0 : (integer)oppAgg.get(lP.ID).get('Opp_Cnt');
                    lP.Opportunity_Amount__c = oppAgg.get(lP.ID).get('Opp_Amt') == null ? 0 : (decimal)oppAgg.get(lP.ID).get('Opp_Amt');
                } ELSE {
                    lP.Opportunity_Count__c = 0;
                    lP.Opportunity_Amount__c = 0;
                }
                System.Debug('Not One Customer: ' + lP.ID);
            }
            Part_Upds.add(lP);
        }
        Update Part_Upds;
    }
    global void finish(Database.BatchableContext info){
        set<ID> iDMs = new Set<ID>();
        String oVal;
        String nVal;
        List<Customer_Transition__c> CTs_Upds = New List<Customer_Transition__c>();
        For(Partner__c DMs : [SELECT Diversity_Manager__c from Partner__c where Diversity_Manager__c != null]){
            iDMs.add(DMs.Diversity_Manager__c);
        }
        For(User usrs : [SELECT id, Name from User where ID in (SELECT OwnerID from Account Where Tier_1_Partner__c != null)]){
            iDMs.add(usrs.id);
        }
        For(GroupMember Ques : [Select UserOrGroupId From GroupMember where GroupId in (Select Id from Group where type='Queue' and Name='Diversity Solutions Ops')]){
            iDMs.add(Ques.UserOrGroupId);
        }
        //CollaborationGroup cGset = [Select Id, OwnerId from CollaborationGroup where Name = 'Tier 1 Owners' Limit 1];

        //Modified By Vipul Jain for Story#S-457173 (00615193 - Tier 1: Story 05b Account Owner Chatter Group - Addition of Sales Diversity Managers and Ops) on December 27,2016
        for (Diversity_Team_Members__mdt diversityTeamMemberId : [SELECT MasterLabel FROM Diversity_Team_Members__mdt]) {
          iDMs.add(diversityTeamMemberId.MasterLabel);

        }

        CollaborationGroup cGset = [Select Id, OwnerId from CollaborationGroup where Name =: Constants.TIER1_ACCOUNT_OWNERS_GROUP_NAME Limit 1];
        //END - Vipul


        List<User> allUs = New List<User>([SELECT id, Name from User where ID in :iDMs and IsActive = true]);
        Map<ID, User> CG_Users = new Map<ID, User>([SELECT id, Name from User where ID in (Select MemberId from CollaborationGroupMember where CollaborationGroup.Id = :cGset.Id)]);
        Map<ID, CollaborationGroupMember> CGs = new Map<ID, CollaborationGroupMember>();
        For(CollaborationGroupMember tyh : [Select MemberId from CollaborationGroupMember where CollaborationGroup.Id = :cGset.Id]){
            cGs.put(tyh.MemberId, tyh);
        }
        List<string> AG_Users = New List<string>();
        List<CollaborationGroupMember> insCGMs = New List<CollaborationGroupMember>();
        List<CollaborationGroupMember> delCGMs = New List<CollaborationGroupMember>();
        For(User t1Users : allUs){
            IF(CG_Users.get(t1Users.ID) == null){
                CollaborationGroupMember nCGMu = New CollaborationGroupMember(
                    CollaborationGroupId = cGset.Id,
                    MemberId = t1Users.Id,
                    NotificationFrequency = 'D'
                );
                insCGMs.add(nCGMu);
            } ELSE {
                CG_Users.remove(t1Users.id);
            }
        }
//Support Ticket: 00713450 & 00713466 & 838698  Start
        For(Customer_Transition__c CTs : [select id, Account__r.Tier_1_Partner__r.Partner_Migration_Status__c, Partner_Migration_Readiness__c, 
                                          Diversity_Manager__c, Account__r.Tier_1_Partner__r.Diversity_Manager__c,  //Support Ticket: 00713466
                                          Diversity_Partner__c, Account__r.Tier_1_Partner__c, Tier_1__c //Support Ticket: 00713466
                                          from Customer_TRansition__c 
                                          Where Account__r.Tier_1_Partner__c != null  or 
                                          (Account__r.Tier_1_Partner__c = null and 
                                           (Diversity_Partner__c != null or 
                                            Diversity_Manager__c != null or 
                                            Partner_Migration_Readiness__c != null))
                                         ]) {
        oVal = (CTs.Partner_Migration_Readiness__c + CTs.Diversity_Manager__c + CTs.Diversity_Partner__c);                                              
        nVal = (CTs.Account__r.Tier_1_Partner__r.Partner_Migration_Status__c + CTs.Account__r.Tier_1_Partner__r.Diversity_Manager__c + CTs.Account__r.Tier_1_Partner__c);                                              
                                             System.Debug('Old Value: ' + oVal);
                                             System.Debug('New Value: ' + nVal);
        IF (CTs.Tier_1__c == True ) {
            IF(oVal != nVal) {
                CTs.Partner_Migration_Readiness__c = CTs.Account__r.Tier_1_Partner__r.Partner_Migration_Status__c;
                CTs.Diversity_Manager__c = CTs.Account__r.Tier_1_Partner__r.Diversity_Manager__c; //Support Ticket: 00713466
                CTs.Diversity_Partner__c = CTs.Account__r.Tier_1_Partner__c; //Support Ticket: 00713466
                CTs_Upds.add(CTs);
            }
        } Else {
            CTs.Partner_Migration_Readiness__c = null;
            CTs.Diversity_Manager__c = null; //Support Ticket: 00713466
            CTs.Diversity_Partner__c = null; //Support Ticket: 00713466
            CTs_Upds.add(CTs);
            }
        
        }
     // End of 838698    
        IF(CTs_Upds.size() > 0) {
              update CTs_Upds;
        }
//Support Ticket: 00713450 & 00713466  End
        
        IF(insCGMs.size() > 0) {
            IF(!Test.isRunningTest()) {
              insert insCGMs;
            }
        }
        
       
        System.Debug('Finish Method');
        IF(CG_Users.size() > 0){
            For(User fUsr : CG_Users.values()){
                IF(cGset.OwnerId != fUsr.ID) {
                    delCGMs.add(CGs.get(fUsr.ID));
                }
            }
            delete delCGMs;
        }
        
        
        
        Map<ID,String> TcT1Map = new Map<ID,String>();

        string tCstr = '';
        ID tCiD;
        string CertList = '';
        integer i = -1;
        List<Tier_1_Certificates__c> tc = new List<Tier_1_Certificates__c>([Select Tier_1_Partner__c, Certificate__c, Certificate_Text__c  from Tier_1_Certificates__c Order by Tier_1_Partner__c]);
        integer g = tc.size();
        For (Tier_1_Certificates__c ltC : tc) {
            i = i + 1;
            tCstr = i == 0 ? ltc.Tier_1_Partner__c : tCstr ;
            IF(tCstr == ltc.Tier_1_Partner__c){
                CertList = ltC.Certificate__c == null ? CertList + ltC.Certificate_Text__c + ', ' : CertList + ltC.Certificate__c + ', ' ;
                tCiD = ltc.Tier_1_Partner__c;
            } Else {
                CertList = CertList.left(CertList.length() - 2);
                TcT1Map.put(tCiD,CertList);
                CertList = '';
                CertList = ltC.Certificate__c == null ? CertList + ltC.Certificate_Text__c + ', ' : CertList + ltC.Certificate__c + ', ' ;
                tCstr = ltC.Tier_1_Partner__c;
            }
            IF(i + 1 == g ){
                CertList = CertList.left(CertList.length() - 2);
                TcT1Map.put(tCiD,CertList);
            }
        }        
    }
    
}