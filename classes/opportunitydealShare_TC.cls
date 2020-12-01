@isTest
public class opportunitydealShare_TC {
    public static testMethod void opportunitydealShare_TC(){
        List<user> users = new list<user>();
         Map<ID,Opportunity> oldOpp = new Map<ID,Opportunity>();
        List<Account> accounts = new list<Account>();
        List<Contact> contacts = new list<Contact>();
         List<Opportunity> opportunities = new list<Opportunity>();
        List<RecordType> OpportunityRecordTypeIds = new List<RecordType>();
        OpportunityRecordTypeIds = [SELECT Id FROM RecordType Where SobjectType='Opportunity' AND (DeveloperName='Tech_Zone' OR DeveloperName='Opportunity_BizBox')];
        List<Id> myRecordTypeIds = new List<Id>();
        
        // Get the List of record Ids we want.
        for(RecordType rec: OpportunityRecordTypeIds){
            myRecordTypeIds.add(rec.Id);
        }
        
        
       // UserRole portalRole = [Select Id From UserRole name = 'HQ' Limit 1];
        UserRole userRole_1 = [SELECT Id FROM UserRole WHERE DeveloperName = 'support' LIMIT 1];
        Profile profileObj = [select id from profile where name='System Administrator'];
        String profId = profileObj.id;
        
        
        
         string userName = 'aaab@officedepot.com';
        string email = userName;
        string[] name = userName.split('@');
        user u2 = new user(Username=userName,FirstName =name[1], LastName=name[0], Alias=name[0], CommunityNickname=userName, LocaleSidKey='en_US', EmailEncodingKey='UTF-8', Profileid = profId, LanguageLocaleKey='en_US');
        u2.email=email;
        u2.UserRoleId=userRole_1.id;
        u2.IsActive=true;
       insert u2;
        
        System.runAs ( u2 ){
        
        Recordtype rtPartner = [Select id,Sobjecttype from recordtype where  name='Partner' and Sobjecttype='Account'];
        Account acc1 = new Account ();
        acc1.name = 'SUN';
        acc1.OMX_Primary_Key__c = '123456';
        acc1.Oracle_Party_Id__c = '123456' ;
        acc1.AOPS_Cust_Id__c = '123456' ;
        acc1.AOPS_Seq_ID__c = '123456' ;
        acc1.OwnerID = u2.id;
        acc1.Address1__c = 'address';
        acc1.RecordTypeid = rtPartner.id;
        //insert acc1;
        accounts.add(acc1);
        
      /*  Account acc2 = new Account ();
        acc2.name = 'SUN1';
        acc2.OMX_Primary_Key__c = '123654';
        acc2.Oracle_Party_Id__c = '123654' ;
        acc2.AOPS_Cust_Id__c = '123654' ;
        acc2.AOPS_Seq_ID__c = '123654' ;
        acc2.OwnerID = u2.id;
        acc2.Address1__c = 'address';
       
        accounts.add(acc2);*/
        insert accounts;
        
        Contact con1 = new Contact();
        
        con1.LastName='Test1';
        con1.Decision_Maker__c='No';
        con1.AccountId=acc1.id;
        contacts.add(con1);
        
        /*Contact con2 = new Contact();
        con2.LastName='Test2';
        con2.Decision_Maker__c='Yes';
        con2.AccountId=acc2.id;
        contacts.add(con2);*/
        insert contacts;
        
        Profile p = [select Id,name from Profile where UserType='PowerPartner' limit 1];
        userName = 'aaa@officedepot.com';
        email = userName;
        name = userName.split('@');
        user u = new user(Username=userName,FirstName =name[1], LastName=name[0], Alias=name[0], CommunityNickname=userName, LocaleSidKey='en_US', EmailEncodingKey='UTF-8', Profileid = p.id, LanguageLocaleKey='en_US');
        u.email=email;
        u.ContactId=con1.id;
        u.IsActive=true;
        u.TimeZoneSidKey='America/Los_Angeles';
        u.Token_Market_Builder__c ='xyz';
        users.add(u);
        insert users;
 
       Opportunity opp1=new opportunity();
       opp1.name='Opportunity 2 ';
       opp1.StageName = '100%-Won';
        opp1.ownerId = acc1.ownerId;
       
       opp1.CloseDate = system.today();
       opp1.Partner_Sub_Agent_Contact__c = con1.Id;
       opp1.Partner_Sub_Agent_Account__c = acc1.id;
       opp1.RecordTypeId = OpportunityRecordTypeIds[0].Id;
        //is the opportunity of record type BizBox or TechZone
        myRecordTypeIds.contains(opp1.recordtypeid);
        insert opp1;
       /*opp1.ownerId = acc2.ownerId;
        opp1.Partner_Sub_Agent_Contact__c = con2.Id;
         opp1.Partner_Sub_Agent_Account__c = acc2.id;
       
        update opp1;*/
      
        
        } 
        
    }

}