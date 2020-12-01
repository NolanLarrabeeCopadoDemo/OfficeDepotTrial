@isTest
private class CoachingBatch_TC {
    
    static testMethod void myUnittest() {
        Test.StartTest();
        Profile p = [select id from Profile where name='System Administrator' limit 1];
        User user = new User(TimeZoneSidKey='America/Los_Angeles',ProfileId = p.id,LastName = 'Rep', FirstName = 'ACE',Email='Rep.ACE@officedepot.com', Username ='Rep.ACE@officedepot.com', Alias='test12', CommunityNickname='test Approve', LanguageLocaleKey='en_US', EmailEncodingKey='UTF-8', LocaleSidKey='en_US',OD_Employee_ID__c='653486');
        Insert user;
        List<Account> List_Acc = new List<Account>();
        
        Coaching__c c = new Coaching__c();
        c.Sales_Rep__c = '005E0000000nAq1';// This is the salesforce User ID
        c.Yearly_Goal__c = 5000;
        c.Sales_Advancing_Event_Target__c = 1;
        c.Contacts_Expansion_Target__c = 1;
        c.Positive_Prism_Plays_Target__c = 0;
        c.Retention_Cadence_Task_Target__c = 1;
        c.Contacts_Expansion_Target__c = 1;
        c.Attainment_of_Contacts_Expansion_Target__c = 1;
        c.Attainment_of_Positive_Prism_Plays_Targe__c = 1;
        c.Attainment_of_Retention_Cadence_Task_Tar__c = 1;
        c.Attainment_of_Pursue_Event_Target__c = 1;
        c.Attainment_of_Propose_Event_Target__c = 1;
        c.Attainment_of_Sales_Advancing_Event_Targ__c = 1;
        c.Target_Verbal_Wins__c = 1;
        c.Attainment_of_Propose_Target__c = 1;
        c.Attainment_of_Pursue_Target__c = 1;
        c.Attainment_of_Qualify_Event_Target__c = 1;
        c.Qualify_Monthly_Target__c = 0;
        c.Pursuit_Presentation_Monthly_Target__c = 0;
        c.Proposal_Presentation_Monthly_Target__c = 1;
        c.Attainment_of_Verbal_Win_Target__c = 1;
        c.Goal_YTD__c = 50000;
        c.Sales_YTD__c = 50000;
        insert c;
       
       Opportunity op = new Opportunity();
       op.Name = 'Test1';
       op.CloseDate = date.parse('12/27/2009');
       op.OwnerID = c.Sales_Rep__c; //'005E0000000lNbV';
       op.StageName = 'Pursue';
       op.Coaching__c = c.id; //'a1of0000000KUmtAAG';
       op.Amount_CAD__c = 10000.00;
       insert op;
       
       Opportunity op1 = new Opportunity();
       op1.Name = 'Test1';
       op1.CloseDate = date.parse('12/27/2017');
       op1.OwnerID = c.Sales_Rep__c; //'005E0000000lNbV';
       op1.StageName = 'Propose';
       op1.Coaching__c = c.id; //'a1of0000000KUmtAAG';
       op1.Amount_CAD__c = 20000.00;
       insert op1;
       
       Opportunity op2 = new Opportunity();
       op2.Name = 'Test1';
       op2.CloseDate = date.parse('12/27/2017');
       op2.OwnerID = c.Sales_Rep__c; //'005E0000000lNbV';
       op2.StageName = 'Verbal Win';
       op2.Coaching__c = c.id; //'a1of0000000KUmtAAG';
       op2.Amount_CAD__c = 20000.00;
       insert op2;
       
       Opportunity op3 = new Opportunity();
       op3.Name = 'Test1';
       op3.CloseDate = date.parse('12/27/2017');
       op3.OwnerID = c.Sales_Rep__c; //'005E0000000lNbV';
       op3.StageName = 'Qualify';
       op3.Coaching__c = c.id; //'a1of0000000KUmtAAG';
       op3.Amount_CAD__c = 20000.00;
       insert op3;
       
       Event ev = new Event();
       ev.OwnerId = c.Sales_Rep__c;
       ev.WhatId = op.id;
       ev.DurationInMinutes = 30;
       ev.ActivityDateTime = Date.newinstance(2016,02,02);
       ev.Call_Disposition__c = 'Advancing Opportunity';
       ev.CreatedDate  = Date.newinstance(2017,04,04);//< LAST_N_DAYS:30
       insert ev;
       
       Task ts = new Task();
       ts.WhatId = op.id;
       ts.OwnerId = c.Sales_Rep__c;
       ts.Task_Type__c = 'SalesPRISM Play';
       ts.Disposition_Code__c = 'salesPRISM - Unqualified';
       ts.CreatedDate  = Date.newinstance(2017,04,04);
       //ts.Call_Disposition__c = 'CBFS Portal Piece';
       insert ts;

      // Account a = [Select id from Account where Recordtype.Name = 'Customer' Limit 1];
       Account A2 = new Account();
       A2.Name='Test';
       A2.AOPS_Cust_Id__c ='123';
       A2.OMX_Primary_Key__c='2719';
       A2.AOPS_Seq_ID__c ='123';
       List_Acc.add(a2);
       
       Contact c1 = new Contact();
       c1.CreatedById = c.Sales_Rep__c;
       c1.CreatedDate = date.parse('12/27/2007');
       c1.LastName='LastNametest';
       c1.email='testemail@test.com';
       c1.AccountId = a2.id;
       c1.OMX_Primary_Key__c='1234';
       insert c1;
       

       /*Test.startTest();
         system.runas(user){
         CoachingBatch batch = new CoachingBatch();
         database.executeBatch(batch,10);
         }
       Test.stopTest();*/
       
      SchedulableContext sc = null;
      CoachingBatch tsc = new CoachingBatch();
      tsc.execute(sc);       
      Test.stopTest();
        
    }

}