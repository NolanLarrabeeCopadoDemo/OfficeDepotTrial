// 
// (c) 2015 Appirio, Inc.
//
//
// 23 September 2016     Connor Flynn S-440218 (OD 00816644)

@isTest
public Class QuoteUpdate_TC{

    static testMethod void Test_Quote2(){
        
        Profile p4 = [SELECT Id FROM profile WHERE name='System Administrator'];   
        User u1 = new User(alias = 'testre', email='proxyre@proxy456.officedepot.com',OD_Employee_ID__c='123886',emailencodingkey='UTF-8', lastname='testre123',languagelocalekey='en_US',localesidkey='en_US', profileid = p4.Id,timezonesidkey='America/Los_Angeles',short_title__c ='TSR',username='proxy@7895.com',isactive=true);
        insert u1;
  System.runAs(u1)
    {      
        Admin_Config__c ad= new Admin_Config__c();
        ad.name ='Default';
        ad.Tech_Depot_Title__c = 'TSR';
        ad.Tech_Depot_Auto_Assign_Opp__c =true;
        ad.Tech_Depot_User__c ='salesforce';
        ad.BatchSize__c ='100';
        insert ad;
        
        Account acc = new Account();
        acc.Aops_seq_id__c='12345';
        acc.Name='Realted';
        insert acc;
        
        Account acc1 = new Account();
        acc1.Name='TestAcc';
        acc1.Aops_seq_id__c='12345-111';
        acc1.Related_account__c = acc.Id;
        acc1.Name='Test';
        insert acc1;               
        
        
        
        AccountTeamMember atm = new AccountTeamMember();
        atm.UserId = u1.Id;
        atm.AccountId = acc1.Id;
        insert atm;
        //CF
        SOA_Exception__c soa = new SOA_Exception__c();
        soa.Exceptions_Msg__c = 'Exc';
        soa.SOAFeed__c = 'Exception';
        soa.Quote_ID__c = '112233';
        insert soa; 
       //END 
       
        QuoteUpdate qup= new QuoteUpdate();    
        QuoteUpdate.ServiceQuote sq = new QuoteUpdate.ServiceQuote();
        sq.AOPS_CUSTOMER_ID = '12345';
        sq.QUOTE_NAME ='testing';
        sq.QUOTE_ID = '112233';
        sq.STATUS = 'test';
        sq.CREATION_DATE ='1/2/2013';
        sq.LAST_UPDATE_DATE ='1/2/2013';
        sq.CLOSE_DATE ='1/2/2013';
        sq.QUANTITY ='1/2/2013';
        sq.TOTAL_AMOUNT ='1234';
        sq.TOTAL_COST='1234';
        sq.COMMENT ='testing';
        sq.CONTACT_FNAME ='conta';
        sq.CONTACT_LNAME ='tester';
        sq.CONTACT_PHONE ='1234567890';
        sq.CONTACT_EMAIL ='contact@g.com';
        sq.A0PS_CONTACT_NUMBER ='5678';
        sq.TOTAL_RETAIL ='100';
        sq.SUBMITTER_FNAME='conta1';
        sq.SUBMITTER_LNAME='tester1';
        //sq.SUBMITTER_ROLE;
        sq.SUBMITTER_PHONE='1234567690';
        sq.SUBMITTER_EMAIL= 'contact1@g.com';
        sq.SUBMITTER_USERNAME ='sales' ;
        sq.CUSTOMER_SHIP_ID ='111';
        //sq.LINK_TO_BSD_SITE;
        sq.REMARKS ='QUOTECUSOR';
        //sq.DELIVERY_CHARGE;
        sq.STATUS_DESC='no';
        sq.TOTAL_REBATE ='11';
        sq.MISC='10';
        String qUpdate_json = JSON.serialize(sq);
        SOA_Exception__c se = new SOA_Exception__c();
        se.Exceptions_Msg__c = 'error';
        se.SOAFeed__c = qUpdate_json;
        se.Quote_ID__c = '112233';
        insert se;
        
        Test.startTest();
        Id retId = QuoteUpdate.QuoteOperation(sq);
        
        //CF
        Opportunity opp = new Opportunity();
        opp.AccountId =acc.Id;
        opp.name = 'testOpp';
        //opp.Quote_Id__c ='112233';
        opp.status__c = 'open';
        opp.stagename = 'Qualify';
        opp.CloseDate = System.today().adddays(100);
        insert opp;
        
        
        Quote q=new Quote();
        q.name = 'testQ';
        q.OpportunityId= opp.Id;
        q.Quote_Id__c = '112233';
        insert q;
        //END
        //
        
        
        Id retId2 = QuoteUpdate.QuoteOperation(sq);
        Test.StopTest();
        
    }
        
}
    
    
    static testMethod void Test_Quote(){
        
         
        Profile p4 = [SELECT Id FROM profile WHERE name='System Administrator'];   
        User u1 = new User(alias = 'testre', email='proxyre@proxy456.officedepot.com',OD_Employee_ID__c='123886',emailencodingkey='UTF-8', lastname='testre123',languagelocalekey='en_US',localesidkey='en_US', profileid = p4.Id,timezonesidkey='America/Los_Angeles',short_title__c ='TSR',username='proxy@7895.com',isactive=true);
        insert u1;
        
    System.runAs(u1)
    {
        
        
        Admin_Config__c ad= new Admin_Config__c();
        ad.name ='Default';
        ad.Tech_Depot_Title__c = 'TSR';
        ad.Tech_Depot_Auto_Assign_Opp__c =true;
        ad.Tech_Depot_User__c ='salesforce';
        ad.BatchSize__c ='100';
        insert ad;
        
        Account acc = new Account();
        acc.Aops_seq_id__c='12345';
        acc.Name='Realted';
        insert acc;
        
        Account acc1 = new Account();
        acc1.Name='TestAcc';
        acc1.Aops_seq_id__c='12345-111';
        acc1.Related_account__c = acc.Id;
        acc1.Name='Test';
        insert acc1;
        
        AccountTeamMember atm = new AccountTeamMember();
        atm.UserId = u1.Id;
        atm.AccountId = acc1.Id;
        insert atm;
       
        
        SOA_Exception__c soa = new SOA_Exception__c();
        soa.Exceptions_Msg__c = 'Exc';
        soa.SOAFeed__c = 'Exception';
        soa.Quote_ID__c = '112233';
        insert soa;
        
        Test.startTest();
        QuoteUpdate qup = new QuoteUpdate();    
        QuoteUpdate.ServiceQuote sq = new QuoteUpdate.ServiceQuote();
        sq.AOPS_CUSTOMER_ID = '12345';
        sq.QUOTE_NAME ='testing';
        sq.QUOTE_ID = '112233';
        sq.STATUS = 'test';
        sq.CREATION_DATE ='1/2/2013';
        sq.LAST_UPDATE_DATE ='1/2/2013';
        sq.CLOSE_DATE ='1/2/2013';
        sq.QUANTITY ='1/2/2013';
        sq.TOTAL_AMOUNT ='1234';
        sq.TOTAL_COST='1234';
        sq.COMMENT ='testing';
        sq.CONTACT_FNAME ='conta';
        sq.CONTACT_LNAME ='tester';
        sq.CONTACT_PHONE ='1234567890';
        sq.CONTACT_EMAIL ='contact@g.com';
        sq.A0PS_CONTACT_NUMBER ='5678';
        sq.TOTAL_RETAIL ='100';
        sq.SUBMITTER_FNAME='conta1';
        sq.SUBMITTER_LNAME='tester1';
        //sq.SUBMITTER_ROLE;
        sq.SUBMITTER_PHONE='1234567690';
        sq.SUBMITTER_EMAIL= 'contact1@g.com';
        sq.SUBMITTER_USERNAME ='sales' ;
        sq.CUSTOMER_SHIP_ID ='111';
        //sq.LINK_TO_BSD_SITE;
        sq.REMARKS ='QUOTECUSOR';
        //sq.DELIVERY_CHARGE;
        sq.STATUS_DESC='no';
        sq.TOTAL_REBATE ='11';
        sq.MISC='10';
       
        
        Id retId = QuoteUpdate.QuoteOperation(sq);
        
   
        //CF
        Opportunity opp = new Opportunity();
        opp.AccountId =acc.Id;
        opp.name = 'testOpp';
        //opp.Quote_Id__c ='112233';
        opp.status__c = 'open';
        opp.stagename = 'Qualify';
        opp.CloseDate = System.today().adddays(100);
        insert opp;
        
        Quote q=new Quote();
        q.name = 'testQ';
        q.OpportunityId= opp.Id;
        q.Quote_Id__c = '112233';
        insert q;
        //END
        
        Id retId2 = QuoteUpdate.QuoteOperation(sq);
        Test.StopTest();
        
     }
        
    }
}