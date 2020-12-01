@isTest
(seealldata=false)
private class GT_MassReassignmentController_TC 
{

    static testMethod void GT_MassReassignmentController_Test() 
    {
    
    
        Profile profileObj = [select id from profile where name='System Administrator'];
        String profId = profileObj.id;
        
        
        
        String userName = 'ccc@officedepot.com';
        string email = userName;
        string[] name = userName.split('@');
        user u1 = new user(Username=userName,FirstName =name[1], LastName=name[0], Alias=name[0], CommunityNickname=userName, LocaleSidKey='en_US', EmailEncodingKey='UTF-8', Profileid = profId, LanguageLocaleKey='en_US');
        u1.email=email;
        u1.MB_Expiration_Date__c = System.now().addminutes(1);
        //LSLEVIN 2.10.16 S-376887 Updated below line to include OD
        //Updated below line by Najma Ateeq for successful run 
        u1.OD_Employee_ID__c ='xxyyOD2271';
        u1.GT_Employee_ID__c ='xxyy227111';
        u1.IsActive=true;
        u1.TimeZoneSidKey='America/Los_Angeles';
        u1.Token_Market_Builder__c ='xyz';
        insert u1;
       
    System.Runas(u1)
    {
    
    RecordType prospectGTrectypeID = [select id, name from recordtype where name = 'Prospect (GT)' limit 1];
    RecordType opptGTrectypeID = [SELECT Id, Name,  SobjectType from recordtype where name='GT Field Sales' and SobjectType ='Opportunity' limit 1];
    
        List<user> users = new list<user>();
        List<Sales_Person__c> salesPersons = new list<Sales_Person__c>();
        List<Account> accounts = new list<Account>();
        List<Opportunity> opportunities = new list<Opportunity>();
        List<Task> tasks = new list<task>();
        List<Event> events = new list<Event>();
        
        userName = 'aaa@officedepot.com';
        email = userName;
        name = userName.split('@');
        user u = new user(Username=userName,FirstName =name[1], LastName=name[0], Alias=name[0], CommunityNickname=userName, LocaleSidKey='en_US', EmailEncodingKey='UTF-8', Profileid = profId, LanguageLocaleKey='en_US');
        u.email=email;
        u.MB_Expiration_Date__c = System.now().addminutes(1);
        u.OD_Employee_ID__c ='xxyy227112';
        u.GT_Employee_ID__c ='xxyy227112';
        u.IsActive=true;
        u.TimeZoneSidKey='America/Los_Angeles';
        u.Token_Market_Builder__c ='xyz';
        //insert u;
        users.add(u);
        
        userName = 'aaab@officedepot.com';
        email = userName;
        name = userName.split('@');
        user u2 = new user(Username=userName,FirstName =name[1], LastName=name[0], Alias=name[0], CommunityNickname=userName, LocaleSidKey='en_US', EmailEncodingKey='UTF-8', Profileid = profId, LanguageLocaleKey='en_US');
        u2.email=email;
        u2.MB_Expiration_Date__c = System.now().addminutes(1);
        u2.OD_Employee_ID__c ='xxyy227113';
        u2.GT_Employee_ID__c ='xxyy227113';
        u2.IsActive=true;
        u2.TimeZoneSidKey='America/Los_Angeles';
        u2.Token_Market_Builder__c ='xyz';
        //insert u2;
        users.add(u2);
        insert users;
        
        Sales_Person__c s= new Sales_Person__c();
        s.IsActive__c=true;
        s.Role_Relate_Id__c ='333333';
        s.Primary__c =true;
        s.user__c=u.id;
        system.debug('@@@SalesPerson@@@ : '+s);
        //insert s;
        salesPersons.add(s);
        
        Sales_Person__c s1= new Sales_Person__c();
        s1.IsActive__c=true;
        s1.Role_Relate_Id__c ='444444';
        s1.Primary__c =true;
        s1.user__c=u2.id;
        system.debug('@@@SalesPerson@@@ : '+s1);
        //insert s1;
        salesPersons.add(s1);
        insert salesPersons;
        
        Account acc1 = new Account ();
        acc1.name = 'SUN'+u.name;
        acc1.OMX_Primary_Key__c = '123456';
        acc1.Oracle_Party_Id__c = '123456' ;
        acc1.AOPS_Cust_Id__c = '123456' ;
        acc1.AOPS_Seq_ID__c = '123456' ;
        acc1.OwnerID = u.id;
        acc1.Address1__c = 'address';
        acc1.RecordTypeid = prospectGTrectypeID.id;
        //insert acc1;
        accounts.add(acc1);
        
        Account acc2 = new Account ();
        acc2.name = 'SUN'+u.name;
        acc2.OMX_Primary_Key__c = '123654';
        acc2.Oracle_Party_Id__c = '123654' ;
        acc2.AOPS_Cust_Id__c = '123654' ;
        acc2.AOPS_Seq_ID__c = '123654' ;
        acc2.OwnerID = u2.id;
        acc2.Address1__c = 'address';
        acc2.RecordTypeid = prospectGTrectypeID.id;
        //insert acc2;
        accounts.add(acc2);
        insert accounts;
        
        
    
    opportunity opp = new Opportunity();
    opp.accountid=  acc2.id;
    opp.Name= acc2.name;
    opp.ownerId = acc2.ownerId;
    opp.StageName='90%-Execute';
    opp.recordtypeid=opptGTrectypeID.id;
    opp.CloseDate=System.today();
    //insert opp;
    opportunities.add(opp);
        
    opportunity opp1 = new Opportunity();
    opp1.accountid=  acc1.id;
    opp1.Name= acc1.name;
    opp1.ownerId = acc1.ownerId;
    opp1.StageName='90%-Execute';
    opp1.CloseDate=System.today();
    opp1.recordtypeid=opptGTrectypeID.id;
    //insert opp1;
    opportunities.add(opp1);
    insert opportunities;
    
    
    Task task1 = new Task();
    task1.whatid = opp.id;
    task1.ownerId = acc2.ownerid;
    task1.Status='Open';
    //insert task1;
    tasks.add(task1);
    
    Task task2 = new Task();
    task2.whatid = opp1.id;
    task2.ownerId = acc1.ownerid;
    task2.Status='Open';
    //insert task2;
    tasks.add(task2);
    
     Task task3 = new Task();
    task3.whatid = opp1.id;
    task3.ownerId = acc2.ownerid;
    task3.Status='Open';
    //insert task1;
    tasks.add(task3);
    
    Task task4 = new Task();
    task4.whatid = opp.id;
    task4.ownerId = acc1.ownerid;
    task4.Status='Open';
    //insert task2;
    tasks.add(task4);
    
    Test.startTest(); 
        
    Datetime myDateTime = Datetime.now();
    Datetime newDateTime = myDateTime.addDays(2);
    
    Event event1 = new Event();
    event1.whatid = opp.id ;
    event1.ownerid = acc1.ownerid ;
    event1.EndDateTime = newDateTime;
    event1.DurationInMinutes = 2880;
    event1.ActivityDateTime = myDateTime;
    //insert event1;
    events.add(event1);
    
    Event event2 = new Event();
    event2.whatid = opp1.id ;
    event2.ownerid = acc2.ownerid ;
    event2.EndDateTime = newDateTime;
    event2.DurationInMinutes = 2880;
    event2.ActivityDateTime = myDateTime;
    //insert event12;
    events.add(event2);
    
     Event event3 = new Event();
    event3.whatid = opp1.id ;
    event3.ownerid = acc1.ownerid ;
    event3.EndDateTime = newDateTime;
    event3.DurationInMinutes = 2880;
    event3.ActivityDateTime = myDateTime;
    //insert event1;
    events.add(event3);
   
    Event event4 = new Event();
    event4.whatid = opp.id ;
    event4.ownerid = acc2.ownerid ;
    event4.EndDateTime = newDateTime;
    event4.DurationInMinutes = 2880;
    event4.ActivityDateTime = myDateTime;
    //insert event12;
    events.add(event4);
    
    Event event5 = new Event();
    event5.whatid = opp.id ;
    event5.ownerid = acc2.ownerid ;
    event5.EndDateTime = newDateTime;
    event5.DurationInMinutes = 2880;
    event5.ActivityDateTime = myDateTime;
    //insert event12;
    events.add(event5);
    
    //insert tasks;
    insert events;
    
    GT_MassReassignmentController gtMassReCon = new GT_MassReassignmentController();
    gtMassReCon.prospectToUpdate = acc1;
    gtMassReCon.prospectToBeUpdated = acc2;
    //gtMassReCon.prospectToBeUpdated = acc3;
    
    gtMassReCon.getProspectWrapperList();
    gtMassReCon.setProspectWrapperList();
    gtMassReCon.getOpportunityWrapperList();
    gtMassReCon.setOpportunityWrapperList();
    List<SelectOption> selectOptions = gtMassReCon.getRecordOptions();
    
    gtMassReCon.getRadioButtonInput();
    
    gtMassReCon.setRadioButtonInput('pros');
    gtMassReCon.queryRecords();
    Account acc= new Account();
    acc.name='Harshita';
    insert acc;
    
    GT_MassReassignmentController.DisplayWrapperClass wrapperClassObjForProspect = new GT_MassReassignmentController.DisplayWrapperClass(true,acc1,acc1.owner.name);
    GT_MassReassignmentController.DisplayWrapperClass wrapperClassObjForOpp = new GT_MassReassignmentController.DisplayWrapperClass(true,opp,acc2,acc1.owner.name);
    GT_MassReassignmentController.DisplayWrapperClass wrapperClassObjForOpp1 = new GT_MassReassignmentController.DisplayWrapperClass(true,opp1,acc1,acc2.owner.name);
    //GT_MassReassignmentController.DisplayWrapperClass wrapperClassObjForOpp2 = new GT_MassReassignmentController.DisplayWrapperClass(true,opp,acc3,acc3.owner.name);
    gtMassReCon.setOpportunityWrapperList(wrapperClassObjForOpp);
    gtMassReCon.setOpportunityWrapperList(wrapperClassObjForOpp1);
    //gtMassReCon.setOpportunityWrapperList(wrapperClassObjForOpp2);
    gtMassReCon.setProspectWrapperList(wrapperClassObjForProspect);
    gtMassReCon.setRadioButtonInput('pros');
    gtMassReCon.updateProspectOwners();
     gtMassReCon.setRadioButtonInput('opp');
     
     gtMassReCon.updateOpportunityOwner();
    gtMassReCon.setRadioButtonInput('opp');
    gtMassReCon.queryRecords();
    gtMassReCon.updateOpportunityOwner();
    gtMassReCon.reset();
    
    gtMassReCon.setRadioButtonInput('pros');
    gtMassReCon.queryRecords();
    gtMassReCon.updateProspectOwners();
 
         test.stopTest();
    
    
    }
 
    }
    
    
}