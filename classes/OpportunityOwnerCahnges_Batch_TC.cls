/**
 * This class contains unit tests for validating the behavior of Apex classes
 * and triggers.
 *
 * Unit tests are class methods that verify whether a particular piece
 * of code is working properly. Unit test methods take no arguments,
 * commit no data to the database, and are flagged with the testMethod
 * keyword in the method definition.
 *
 * All test methods in an organization are executed whenever Apex code is deployed
 * to a production organization to confirm correctness, ensure code
 * coverage, and prevent regressions. All Apex classes are
 * required to have at least 75% code coverage in order to be deployed
 * to a production organization. In addition, all triggers must have some code coverage.
 * 
 * The @isTest class annotation indicates this class only contains test
 * methods. Classes defined with the @isTest annotation do not count against
 * the organization size limit for all Apex scripts.
 *
 * See the Apex Language Reference for more information about Testing and Code Coverage.
 */
@isTest(SeeAllData=FALSE)
private class OpportunityOwnerCahnges_Batch_TC {

    static testMethod void myUnitTest() {
        Profile p4 = [SELECT Id FROM profile WHERE name='System Administrator'];   
        User u1 = new User(alias = 'test123 ', email='proxy@proxy456.officedepot.com',OD_Employee_ID__c='123446',emailencodingkey='UTF-8', lastname='test123',languagelocalekey='en_US',localesidkey='en_US', profileid = p4.Id,timezonesidkey='America/Los_Angeles',username='proxy@proxy456.com',Reassgin_Opportunity__c='NP',isActive=True);
        insert u1;
        System.runAs(u1)
        {  
        Admin_Config__c ad = new Admin_Config__c();
        ad.BatchSize__c = '200';
        ad.ActivateUserCount__c =20;
        ad.Tech_Depot_Title__c = 'TSR, ISTD';
        ad.Tech_Depot_Auto_Assign_Opp__c =true;
        ad.Tech_Depot_User__c = 'salesforce';
        ad.name = 'Default';
        Insert ad;
        
        }
       
        
        User u2 = new User(alias = 'Off00092', email='proxy@proxy.officedepot.com',OD_Employee_ID__c='413446',emailencodingkey='UTF-8', lastname='Off00092',languagelocalekey='en_US',localesidkey='en_US', profileid = p4.Id,timezonesidkey='America/Los_Angeles',username='proxy@ofc009.com',Reassgin_Opportunity__c='P',isActive=True);
        insert u2; 
        System.runAs(u2)
        {    
            Account acc = new Account ();
            acc.name = 'SUN1 Test Account';  
            acc.BillingStreet = '1040 N 326 W';
            acc.billingcity = 'Orem';
            acc.BillingState = 'UT';
            acc.Billingcountry = 'USA';
            acc.Oracle_Party_Id__c = '023456';
            acc.AOPS_Cust_Id__c = '023456';
            acc.AOPS_Seq_ID__c = '023456';
            acc.ownerid=u1.id;
            acc.owner = u1;
            insert acc;
            
            Account acc1 = new Account ();
            acc1.name = 'SUN1 Test Account';
            acc1.BillingStreet = '1040 N 326 W';
            acc1.billingcity = 'Orem';
            acc1.BillingState = 'UT';
            acc1.Billingcountry = 'USA';       
            acc1.AOPS_Seq_ID__c = '025678';
            acc1.ownerid=u1.id;
            acc1.owner = u1;
            acc1.Related_Account__c = acc.id;
            insert acc1;
            
            Opportunity opp = new Opportunity();
            opp.AccountId= acc.id;
            Opp.Account = acc;
            opp.name='OppTest';
            opp.CloseDate = system.today();
            opp.Product__c = 'All Supplies';
            opp.StageName = '100%-Implement';
            opp.ownerid=u1.id;  
            opp.Related_Site__c = Acc1.id;  
             

            opportunity opp1 = new opportunity();
            opp1.AccountId= acc.id;
            opp1.Account = acc;
            opp1.name='opp1Test';
            opp1.CloseDate = system.today();
            opp1.Product__c = 'MPS';
            opp1.StageName = '100%-Implement';
            opp1.ownerid=u1.id;  
            opp1.Related_Site__c = Acc1.id;  
            
            //Opportunity existingOpp = [SELECT Id,related_site__r.owner.isactive, IsDeleted, AccountId, RecordTypeId, Name, Description, StageName, Amount, Probability, CloseDate, Type, NextStep, LeadSource, IsClosed, IsWon, ForecastCategory, ForecastCategoryName, CampaignId, HasOpportunityLineItem, Pricebook2Id, OwnerId, CreatedDate, CreatedById, LastModifiedDate, LastModifiedById, SystemModstamp, LastActivityDate, SyncedQuoteId, Account_Type__c, Address__c, Agree_Upon_Transition_Plan__c, Amount_Forecast__c, Close_Reason__c, Conduct_Opp_Assessment__c, Conduct_Opp_Planning__c, Confirm_Dialog__c, Create_RFP_w_OD_Differentiators__c, Determine_Eval_Criteria_Next_Steps__c, Diagnose_Admitted_Pain_Create_Vision__c, Engage_Bid_Team__c, Engage_IT_Integration_Mgr__c, Engage_Implementation_Mgr__c, Engage_Overlay__c, Execute_Evaluation_Plan_Steps__c, Execute_Implementation_Plan__c, Expected_Revenue_TY__c, Finalize_T_s_C_s__c, Get_Pain_Admitted__c, IMU_Amount__c, IMU__c, Identify_Success_Criterion__c, Legacy_CreatedBy__c, Legacy_CreatedDate__c, Legacy_LastModifiedBy__c, Legacy_LastModifiedDate__c, Negotiate_Access_to_Power__c, Opportunity_Number__c, Oracle_Entity_Id__c, Overlay_Sales_IDs__c, Potential_Amt__c, Present_Solution__c, Product__c, Refine_Value_Proposition__c, Respond_to_RFP_Bid__c, Sales_Person_ID__c, Secondary_Competitor__c, Source_System__c, Source__c, Status__c, Store__c, Test_Order_Placement_Billing__c, Week_Ending__c, Leads_POC_Opp_Goal__c, DB_Competitor__c, Related_Site__c, Estimated_Revenue_TY__c, Sector__c, Segment__c, Account_Implemented__c, Account_Setup__c, Agree_Upon_Next_Steps1__c, Agree_Upon_Next_Steps2__c, Agree_Upon_Next_Steps__c, Analyze_info_for_Proposal_Dev__c, Ask_for_Business__c, Ask_how_they_will_make_decision__c, Build_Implementation_Plan__c, Call_for_appointment__c, Conduct_First_Appt__c, Conduct_subsequent_Appts__c, Confirm_Decision_Maker__c, Customer_Training_Complete__c, Decision_Postponed_Closed__c, Discover_whats_most_important__c, Find_Pain_Points__c, Gain_Commitmnt_to_move_forward__c, Identify_Research_Qualify__c, Lost__c, Outline_Transition_Plan__c, Prepare_Present_Proposal__c, Prepare_for_Call__c, Prioritize_Prospect_Focus__c, Respond_to_RFP_Bid_team_150k__c, Review_Confirm_Final_Details__c, Uncover_Target_Solutions__c, Understand_bus_procure_process__c, Use_Pricing_Tool_up_to_150k__c, Use_relevant_phone_script__c, Won_Customer_Ordering__c, Won_Legal_Agreement_Execution__c, Won_TCs_Executed__c, Add_Contacts__c, First_Appointment_is_set__c, Info_Qualified_and_Added__c, Prepare_for_appointment__c, Track_Activity__c, Win_amt__c, Lost_Amt__c, Total_Count__c, Appointments_cnt__c, Proposal_cnt__c, Proposal_opp_amt__c, Win__c, Appointment_opp_amt__c, No_Ordering__c, WinAcct__c, Projected_IMU__c, Status_Level__c, Term_Length__c, Extensions_Possible__c, Price_Chane_Notice__c, WRF_Request_Type_Seq__c, Determine_Value_Levers__c, IOWNACCOUNT__c, InProgress__c, Total_Extended_Sale__c, Grandparent__c, Customer_Lifecycle__c, Win_Loss_Amount__c, Networked_Printers__c, Viewpath__VP_Project__c, Current_Provider__c, Product_Subtype__c, Win_Loss_Renewal__c, Preliminary_Research_done__c, Preliminary_conversation_scoping__c, Prospect_has_positive_potential__c, Size_Segment_identified__c, WRF_ACCT_Id__c, Viewpath__Viewpath_Project_Formula__c, Primary_Competitor1__c, Project_Ongoing__c, Committed_Forecast__c, Pot_Disposition_Reason__c, Pot_Disposition__c, Pot_Other_Disposition_Reason__c, Potential_DeDuplicate__c, Potential_Warning_Key__c, Interested_in_Green_Solutions__c, Opportunity_ID_Long__c, Customer_ID__c, Annual_Opportunity__c, OMX_Primary_Key__c, Data_Team_Inactive_Opportunity__c, Lead_Page_Source__c, PushCount__c, Account_Record_Type__c, Amount_CAD__c, Amount_Forecast_CAD__c, Committed_Forecast_CAD__c, Opportunity_Amount__c, Close__c, Win_Loss_Renewal_CAD__c, Support_Value__c from opportunity where id ='006M000000Bp9xD']; //Testing for case 307505
            
            List<Opportunity > list_opp = new List<Opportunity >();
            list_opp.add(opp);
            list_opp.add(opp1);
            
            
            Database.insert(list_opp,false);
            //list_opp.add(existingOpp); //Testing for case 307505
            System.debug('##@@##'+list_opp);
            
            
            Test.startTest();
            OpportunityOwnerChanges_Batch oppBatch = new OpportunityOwnerChanges_Batch();
            
            Database.BatchableContext bc;
            oppBatch.start(bc);
            oppBatch.execute(bc,List_opp);
            oppBatch.finish(bc);
                       
            String sch = '20 30 8 10 2 ?';
            system.schedule('Opp',sch,oppBatch);
            
            Test.stopTest();
        }
    }
}