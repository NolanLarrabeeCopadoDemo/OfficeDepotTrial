@isTest
private class Opportunity_Insert_TC
{
    /*
    static testMethod void Opportunity_Insert_TC()
    {

        Schema.DescribeSObjectResult WR = Schema.SObjectType.WRF_Task__c;
        Map<String,Schema.RecordTypeInfo> WRFMapByName = WR.getRecordTypeInfosByName();

        Schema.DescribeSObjectResult CR = Schema.SObjectType.Case;
        Map<String,Schema.RecordTypeInfo> CRFMapByName = CR.getRecordTypeInfosByName();
        Profile p4 = [SELECT Id FROM profile WHERE name='System Administrator'];
        User u1 = new User(alias = 'test123 ', email='proxy@proxy456.officedepot.com',OD_Employee_ID__c='123886',emailencodingkey='UTF-8', lastname='test123',languagelocalekey='en_US',localesidkey='en_US', profileid = p4.Id,timezonesidkey='America/Los_Angeles',username='proxy@7895.com',isactive=true);
        insert u1;


        Account acc = new Account();
        acc.Name='Test';
        insert acc;

        Test.StartTest();
        Case cs = new Case();
        cs.RecordTypeId = CRFMapByName.get('Work Request').getRecordTypeId();
        cs.status='New';
        cs.WRF_Request_Type__c='Core Review';
        cs.accountid = acc.id;
        insert cs;

        WRF_Task__C parentWRF = new WRF_Task__C();
        parentWRF.RecordTypeId = WRFMapByName.get('WRF Task').getRecordTypeId();
        parentWRF.Task_Type__c='Pricing Implementation';
        parentWRF.status__c='Not Started';
        parentWRF.Disposition_Code__c='Bids';
        parentWRF.Due_Date__c = System.today();
        parentWRF.Assigned_To__c = u1.id;
        parentWRF.priority__c='Normal';
        parentWRF.Assignment_Group__c='Public/GPO';
        parentWRF.WRF__c=cs.id;
        insert parentWRF;
        Test.StopTest();


            WRF_Task__C subWRF = new WRF_Task__C();
            subWRF.RecordTypeId = WRFMapByName.get('WRF Sub Task').getRecordTypeId();
            subWRF.Task_Type__c='Pricing Implementation';
            subWRF.status__c='Not Started';
            subWRF.Disposition_Code__c='Bids';
            subWRF.Due_Date__c = System.today();
            subWRF.Assigned_To__c = u1.id;
            subWRF.priority__c='Normal';
            subWRF.Assignment_Group__c='Public/GPO';
            subWRF.WRF__c=cs.id;
            subWRF.Parent_WRF_Task__c=parentWRF.id;
            insert subWRF;
            System.debug('+++++++++++++++1'+executeoncetest.oppemailsend);
            executeoncetest.oppemailsend=true;
            opportunity opp = new Opportunity();
            opp.accountid=  acc.id;
            opp.Name='Test';
            opp.StageName='Verbal Win' ;
            opp.CloseDate=System.today();
            insert opp;
            executeoncetest.oppemailsend=true;
            List<Sobject> Update_List = new List<Sobject>();
            cs.WRF_Opportunity__c = opp.id;
            Update_List.add(cs);
            //update cs;

            opp.stageName='Close';
            //update opp;
            Update_List.add(opp);
            System.debug('+++++++++++++++2'+executeoncetest.oppemailsend);
            update Update_List;
            opp.stageName='Lost' ;
            //update opp;

    }*/
    //Added by Nisha for Story S-374376 [Case#00589591]
    static testMethod void Opportunity_Insert_TC1()
    {


        Profile p4 = [SELECT Id FROM profile WHERE name='System Administrator'];
        Profile p3 = [SELECT Id FROM profile WHERE name='Developer'];
       /// PLOC_Opp_Stage_Access__c pSet = new PLOC_Opp_Stage_Access__c(name='System Administrator');
       /// insert pSet;
        User u1 = new User(alias = 'test123 ', email='proxy@proxy456.officedepot.com',OD_Employee_ID__c='123886',emailencodingkey='UTF-8', lastname='test123',languagelocalekey='en_US',localesidkey='en_US', profileid = p4.Id,timezonesidkey='America/Los_Angeles',username='proxy@7895.com',isactive=true);
        insert u1;

        User u2 = new User(alias = 'test1234 ', email='proxy1@proxy456.officedepot.com',OD_Employee_ID__c='123887',emailencodingkey='UTF-8', lastname='test1234',languagelocalekey='en_US',localesidkey='en_US', profileid = p3.Id,timezonesidkey='America/Los_Angeles',username='proxy@7896.com',isactive=true);
        insert u2;
        
        //system.runAs(u2){
        system.runAs(u1){
        
        Account acc = new Account();
        acc.Name='Test';
        insert acc;
        test.startTest();
        //system.runAs(u1){
        system.runAs(u2){
            opportunity opp = new Opportunity();
            opp.accountid=  acc.id;
            opp.Name='Test';
            opp.StageName='Verbal Win' ;
            opp.CloseDate=System.today();
            opp.Product_Subtype__c = 'PLOC (Assigned)';
            try{
                insert opp;
            }
            catch(Exception e){
                System.assertNotEquals(null, e);
            }
        }
        system.runAs(u2){
            opportunity opp1 = new Opportunity();
            opp1.accountid=  acc.id;
            opp1.Name='Test1';
            opp1.StageName='Verbal Win' ;
            opp1.CloseDate=System.today();
            opp1.Product_Subtype__c = 'PLOC (Assigned)';
            try{
                insert opp1;
            }
            catch(Exception e){
                System.assertNotEquals(null, e);
            }
        }
        test.stopTest();
        
        }
        }
    

    //END Story S-374376 [Case#00589591]

}