@istest
private class PotentialDuplicateDispositionUpdate_TC
{


    static testMethod void PotentialDuplicateDispositionUpdate_Method()
    { /*

        Profile p = [select id from profile where name='Standard User'];
        User user=new User(alias = 'tester1', email='test135@wipro.com',emailencodingkey='UTF-8', lastname='Tester1', languagelocalekey='en_US',localesidkey='en_US', profileid = p.Id, country='United States',timezonesidkey='America/Los_Angeles', username='test157@sample.com');
        insert user;


        boolean b = true;
        String s = 'test';
        String n = UserInfo.getName();//'test';
        //System.runAs(user) {
        lead l1 = new lead(LastName = 'test', firstname = 'test', company = 'test', status = 'open');
        insert l1;
        Map<String,Schema.RecordTypeInfo> AccRecType = Schema.SObjectType.Account.getRecordTypeInfosByName();

        Account acc = new Account ();
        acc.name = 'SUN Test Account';
        acc.BillingStreet = '1040 N 326 W';
        acc.billingcity = 'Orem';
        acc.BillingState = 'UT';
        acc.Billingcountry = 'USA';
        acc.Oracle_Party_Id__c = '123456';
        acc.AOPS_Cust_Id__c = '123456';
        acc.RecordtypeId = AccRecType.get('Prospect').getRecordTypeId();
        acc.AOPS_Seq_ID__c = '123456';
       // acc.OwnerID = '005E0000000lNbV';// This is the salesforce User ID
        //acc.Sales_PersonID__c = 'a0AE0000000GGMn'; //Sales person Id for the Salesforce USer
        insert acc;

        contact cnt = new contact(lastname= 'test',AccountId = acc.id);
        insert cnt;

        Opportunity opp = new Opportunity(name= 'test',AccountId = acc.id,Close_Reason__c = 'test', CloseDate = system.today(), Status__c = 'new', StageName = '0%-Lost');
        insert opp;

        DMND_Potential_Warning__c pdw = new DMND_Potential_Warning__c(Warning_Key__c = 'test');
        insert pdw;
        DMND_Duplicate__c dup = new DMND_Duplicate__c(Potential_Duplicate_Warning__c = pdw.id, Disposition__c = '', Account__c = acc.id);
        insert dup;
        DMND_Duplicate__c dup1 = new DMND_Duplicate__c(Potential_Duplicate_Warning__c = pdw.id, Disposition__c = 'Keep', Dispostion_Reason__c = 'Others', Other_Disposition_Reason__c = 'Test', Lead__c = l1.id);
        insert dup1;
        DMND_Duplicate__c dup2 = new DMND_Duplicate__c(Potential_Duplicate_Warning__c = pdw.id, Disposition__c = 'Merge', Contact__c = cnt.id);
        insert dup2;
        DMND_Duplicate__c dup3 = new DMND_Duplicate__c(Potential_Duplicate_Warning__c = pdw.id, Disposition__c = 'Delete', Opportunity__c = opp.id);
        insert dup3;



        apexpages.currentpage().getparameters().put('id',dup1.id);
        ApexPages.StandardController ext = new ApexPages.StandardController(dup1);
        PotentialDuplicateDispositionUpdate_Ext dedup=new PotentialDuplicateDispositionUpdate_Ext(ext);
        dedup.currentUserCheck = true;
        dedup.next();
        dedup.Beginning();
        dedup.Previous();
        dedup.End();
        dedup.getDisablePrevious();
        dedup.getDisableNext();
        PotentialDuplicateDispositionUpdate_Ext.WrapperClass PW = new PotentialDuplicateDispositionUpdate_Ext.WrapperClass(b,s,n,dup1);
        dedup.potentialdup = dup1;//[Select id,lastmodifiedby.name,Account__r.Name,Contact__r.Name,Lead__r.Name,Opportunity__r.Name,Disposition__c,Dispostion_Reason__c,Object_Type__c,Related_Object_ID__c,Related_Object_OwnerID__c,Other_Disposition_Reason__c,Potential_Duplicate_Warning__r.Name from DMND_Duplicate__c where id=:dup1.id];
        dedup.potentialdup.Disposition__C='Inactive';
        pw.checked = true;
        dedup.wrapperlist.add(pw);
        Test.StartTest();
        dedup.disableCloseDateInput();
        dedup.enableCloseDateInput();
        dedup.populatelist();
        dedup.saveRecord();
        dedup.cancelRecord();
        dedup.getwrapperlist();
        Test.StopTest();
       /* ApexPages.StandardController ext1 = new ApexPages.StandardController(dup);
        PotentialDuplicateDispositionUpdate_Ext dedup1=new PotentialDuplicateDispositionUpdate_Ext(ext1);
        PotentialDuplicateDispositionUpdate_Ext.WrapperClass PW1 = new PotentialDuplicateDispositionUpdate_Ext.WrapperClass(b,s,n,dup);
        dedup1.potentialdup = [Select id,lastmodifiedby.name,Account__r.Name,Contact__r.Name,Lead__r.Name,Opportunity__r.Name,Disposition__c,Dispostion_Reason__c,Object_Type__c,Related_Object_ID__c,Related_Object_OwnerID__c,Other_Disposition_Reason__c,Potential_Duplicate_Warning__r.Name from DMND_Duplicate__c where id=:dup.id];
        dedup1.potentialdup.Disposition__C='Inactive';
        pw1.checked = true;
        dedup1.saveRecord();
        dedup1.potentialdup.Disposition__C='Keep';
        pw1.checked = true;
        dedup1.saveRecord();
        dedup1.wrapperlist.add(pw1);
        Test.StartTest();
        dedup1.enableCloseDateInput();
        dedup1.populatelist();
        Test.StopTest();
        dedup1.saveRecord();
        */

    }


}