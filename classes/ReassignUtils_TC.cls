@isTest(seealldata=true)
public class ReassignUtils_TC
{

    public static testMethod void myUnitTest()
    {
        list<Account> acclist = new list<Account>();
        Profile pf = [Select Id from Profile where Name = 'System Administrator'];
        User u1 = new User();
        u1.FirstName = 'Test';
        u1.LastName = 'User';
        u1.Email = 'testuser@officedepot.com';
        u1.CompanyName = 'test.com';
        u1.Title = 'Test User';
        u1.Username = 'nitishuser1@officedepot.com';
        u1.Alias = 'testuser';
        u1.CommunityNickname = 'Test User';
        u1.TimeZoneSidKey = 'America/Mexico_City';
        u1.LocaleSidKey = 'en_US';
        u1.EmailEncodingKey = 'ISO-8859-1';
        u1.ProfileId = pf.Id;
        //u.Default_Group__c='All';
        u1.LanguageLocaleKey = 'en_US';
        u1.isActive = true;
        insert u1;


        system.runAs(u1)
        {
            org__c  org = new org__c();
            org.business_name__c='office depot';
            org.address_1__c='6600 N Military Trl';
            org.city__c='Boca Raton';
            org.state__c='FL';
            org.zip__c ='33487-2434';
            insert org;
            
            Account acc = new Account();
            acc.OwnerId=u1.id;
            acc.name='test1';
            acc.Primary_Site__c = true;
            acc.org__c  = org.id;
            acclist.add(acc);


            Account acc1 = new Account();
            acc1.OwnerId=u1.id;
            acc1.name='test2';
            acc1.AccountNumber = '112233';
            acc1.related_account__c = acc.id;
            acc1.Primary_Site__c = true;
            acc1.org__c  = org.id;
            acclist.add(acc1);
            insert acclist;


            Reassignment_Queue__c rq = new Reassignment_Queue__c();
            rq.Account__c = acc.id;
            rq.Requestor__c = u1.id;
            rq.New_Owner__c = u1.id;
            rq.Approver__c = u1.id;
            rq.Status__c = 'Failed';
            rq.Approve_Reject_Date__c= system.now();
            insert rq;

            test.starttest();
            PageReference pgRef = Page.ReassignProspect;
            Test.setCurrentPage(pgRef);
            ApexPages.StandardController sc = new ApexPages.StandardController(acc);
            ApexPages.currentPage().getParameters().put('id', acc.id);
            ReassignAccount Resacc = new ReassignAccount(sc);
            Resacc.createAssignment();
            Resacc.SaveRecord();
            Resacc.CancelRec();
            Resacc.getaccList();
            ReassignUtils resnUtlObj = new ReassignUtils();
            resnUtlObj.getIsAdmin();
            resnUtlObj.ReassignAllowed();
            resnUtlObj.getUserHier();
            test.stoptest();
        }
    }
    /*public static testMethod void myUnitTest1()
    {
        RecordType rcd = [select id from recordtype where recordtype.name = 'Customer'];
        RecordType rcd1 = [select id from recordtype where recordtype.name = 'Site'];

        Map<ID,ID> currentOwnerMap = new Map<ID,ID>();
        Profile pf = [Select Id from Profile where Name = 'System Administrator'];
        User u = new User();
        u.FirstName = 'Test';
        u.LastName = 'User';
        u.Email = 'testuser@officedepot.com';
        u.CompanyName = 'test.com';
        u.Title = 'Test User';
        u.Username = 'user1234@officedepot.com';
        u.Alias = 'testuser';
        u.CommunityNickname = 'UserNickName';
        u.TimeZoneSidKey = 'America/Mexico_City';
        u.LocaleSidKey = 'en_US';
        u.EmailEncodingKey = 'ISO-8859-1';
        u.ProfileId = pf.Id;
        u.LanguageLocaleKey = 'en_US';
        u.isActive = true;
        insert u;
        //currentOwnerMap.put(u.id);

        System.runAs(u)
        {
        Group grpObj = new Group();
        grpObj.name = 'ReAssignment Admin';
        insert grpObj;

        groupMember grpMbrObj = new groupMember();
        grpMbrObj.UserOrGroupId = u.id;
        grpMbrObj.GroupId = grpObj.id;
        insert grpMbrObj;


        list<Account> acclist = new list<Account>();
        Account acc = new Account();
        acc.OwnerId=u.id;
        acc.name='test1';
        acc.AccountNumber = '112233';
        acc.recordtypeid = rcd1.id;
        acclist.add(acc);
        insert acc;

        Account acc1 = new Account();
        acc1.OwnerId=u.id;
        acc1.name='test2';
        acc1.AccountNumber = '112233';
        //acc1.related_account__c = acc.id;
        acc1.Primary_Site__c = true;
        acc1.recordtypeid = rcd.id;
        acclist.add(acc1);

         Account acc2 = new Account();
        acc2.OwnerId=u.id;
        acc2.name='test2';
        acc2.AccountNumber = '112233';
        //acc2.related_account__c = acc.id;
        acc2.Primary_Site__c = false;
        acc2.recordtypeid = rcd.id;
        acclist.add(acc2);

        insert acclist;

        list<Database.saveResult> aResult = Database.Update(acclist,false);
        for (Database.SaveResult result : aResult) {
        if (!result.isSuccess()){
        for (Database.Error err : result.getErrors()){
        System.debug('Error: '+ err.getStatusCode() + ' ' + err.getMessage());
        }}
}
        Reassignment_Queue__c rq = new Reassignment_Queue__c();
        rq.Account__c = acc1.id;
        rq.Requestor__c = u.id;
        rq.New_Owner__c = u.id;
        rq.Approver__c = u.id;
        rq.Status__c = 'Failed';
        rq.Approve_Reject_Date__c= system.now();
        insert rq;


        sales_person__c slsPersonObj = new sales_person__c();
        slsPersonObj.user__c = u.id;
        slsPersonObj.isactive__c = true;
        slsPersonObj.primary__c = true;
        insert slsPersonObj;

        test.starttest();
        PageReference pgRef = Page.ReassignProspect;
        Test.setCurrentPage(pgRef);
        ApexPages.StandardController sc = new ApexPages.StandardController(acc);
        ApexPages.currentPage().getParameters().put('id', acc.id);
        ReassignAccount Resacc = new ReassignAccount(sc);
        Resacc.createAssignment();
        Resacc.SaveRecord();
        Resacc.CancelRec();
        Resacc.getaccList();

        ReassignUtils.ReassignData reAsgnUtlReAsnDataObj = new ReassignUtils.ReassignData();
        reAsgnUtlReAsnDataObj.AccountID = acc.id;
        reAsgnUtlReAsnDataObj.toUserID = u.id;
        reAsgnUtlReAsnDataObj.status_code = 'Code';
        reAsgnUtlReAsnDataObj.status_msg = 'Message';
        List<ReassignUtils.ReassignData> reAsgnUtlReAsnDataList = new List<ReassignUtils.ReassignData>();
        reAsgnUtlReAsnDataList.add(reAsgnUtlReAsnDataObj);
        ReassignUtils.AppRejData reAsgnUtlAppRejDtObj = new ReassignUtils.AppRejData();
        reAsgnUtlAppRejDtObj.QueueID = rq.id;
        List<Id> reAsgnUtlAppRejDtLst = new List<Id>();
        reAsgnUtlAppRejDtLst.add(reAsgnUtlAppRejDtObj.QueueID);
        ReassignUtils resnUtlObj = new ReassignUtils();
        resnUtlObj.getIsAdmin();
        resnUtlObj.ReassignAllowed();
        resnUtlObj.getUserHier();
        resnUtlObj.appRejAllowed(rq.Approver__c);
        resnUtlObj.ReassignAccounts(reAsgnUtlReAsnDataList);
        resnUtlObj.AutoApprove(reAsgnUtlReAsnDataList);
        String type = 'A';
        resnUtlObj.ApproveRej(reAsgnUtlAppRejDtLst,type);
        String type1 = 'R';
        resnUtlObj.ApproveRej(reAsgnUtlAppRejDtLst,type1);
        String type2 = 'C';
        resnUtlObj.ApproveRej(reAsgnUtlAppRejDtLst,type2);
        resnUtlObj.submitApproval(reAsgnUtlReAsnDataList,currentOwnerMap);
        test.stoptest();

        }
    }*/
    public static testMethod void myUnitTest2()
    {
        Map<ID,ID> currentOwnerMap = new Map<ID,ID>();
        Profile pf = [Select Id from Profile where Name = 'System Administrator'];
        User us = new User();
        us.FirstName = 'Tes1';
        us.LastName = 'Use1';
        us.Email = 'tesuse1@officedepot.com';
        us.CompanyName = 'tes1.com';
        us.Title = 'Tes1 Use1';
        us.Username = 'use0123@officedepot.com';
        us.Alias = 'tesuse';
        us.CommunityNickname = 'UseNicNam';
        us.TimeZoneSidKey = 'America/Mexico_City';
        us.LocaleSidKey = 'en_US';
        us.EmailEncodingKey = 'ISO-8859-1';
        us.ProfileId = pf.Id;
        us.LanguageLocaleKey = 'en_US';
        us.isActive = true;
        insert us;

        User u = new User();
        u.FirstName = 'Test';
        u.LastName = 'User';
        u.Email = 'testuser@officedepot.com';
        u.CompanyName = 'test.com';
        u.Title = 'Test User';
        u.Username = 'user1234@officedepot.com';
        u.Alias = 'testuser';
        u.CommunityNickname = 'UserNickName';
        u.TimeZoneSidKey = 'America/Mexico_City';
        u.LocaleSidKey = 'en_US';
        u.EmailEncodingKey = 'ISO-8859-1';
        u.ProfileId = pf.Id;
        u.LanguageLocaleKey = 'en_US';
        u.isActive = true;
        u.managerid=us.id;
        insert u;
        //currentOwnerMap.put(u.id);

        System.runAs(u)
        {
         org__c  org = new org__c();
            org.business_name__c='office depot';
            org.address_1__c='6600 N Military Trl';
            org.city__c='Boca Raton';
            org.state__c='FL';
            org.zip__c ='33487-2434';
            insert org;
            
        Account acc = new Account();
        acc.OwnerId=u.id;
        acc.name='test1';
        acc.AccountNumber = '112233';
        acc.org__c  = org.id;
        insert acc;

        Account acc1 = new Account();
        acc1.OwnerId=u.id;
        acc1.name='test2';
        acc1.AccountNumber = '112233';
        acc1.related_account__c = acc.id;
        acc1.Primary_Site__c=true;
        acc1.org__c  = org.id;
        insert acc1;

        Reassignment_Queue__c rq = new Reassignment_Queue__c();
        rq.Account__c = acc1.id;
        rq.Requestor__c = u.id;
        rq.New_Owner__c = u.id;
        rq.Approver__c = u.id;
        rq.Status__c = 'Pending Approval';
        rq.Approve_Reject_Date__c= system.now();
        insert rq;

        sales_person__c slsPersonObj = new sales_person__c();
        slsPersonObj.user__c = u.id;
        slsPersonObj.isactive__c = true;
        slsPersonObj.primary__c = true;
        insert slsPersonObj;

        test.starttest();
        ReassignUtils.AppRejData reAsgnUtlAppRejDtObj = new ReassignUtils.AppRejData();
        reAsgnUtlAppRejDtObj.QueueID = rq.id;
        List<Id> reAsgnUtlAppRejDtLst = new List<Id>();
        reAsgnUtlAppRejDtLst.add(reAsgnUtlAppRejDtObj.QueueID);
        ReassignUtils resnUtlObj = new ReassignUtils();
        String type = 'A';
        resnUtlObj.ApproveRej(reAsgnUtlAppRejDtLst,type);
        List<ReassignUtils.ReassignData> reAsgnUtlReAsnDataList = new List<ReassignUtils.ReassignData>();
        test.stoptest();

        }
    }
    public static testMethod void myUnitTest3()
    {
        Map<ID,ID> currentOwnerMap = new Map<ID,ID>();
        Profile pf = [Select Id from Profile where Name = 'System Administrator'];
        User u = new User();
        u.FirstName = 'Test';
        u.LastName = 'User';
        u.Email = 'testuser@officedepot.com';
        u.CompanyName = 'test.com';
        u.Title = 'Test User';
        u.Username = 'user12@officedepot.com';
        u.Alias = 'testuser';
        u.CommunityNickname = 'UserNickNameComm';
        u.TimeZoneSidKey = 'America/Mexico_City';
        u.LocaleSidKey = 'en_US';
        u.EmailEncodingKey = 'ISO-8859-1';
        u.ProfileId = pf.Id;
        u.LanguageLocaleKey = 'en_US';
        u.isActive = true;
        insert u;

        User u1 = new User();
        u1.FirstName = 'Test';
        u1.LastName = 'User';
        u1.Email = 'testuser@officedepot.com';
        u1.CompanyName = 'test.com';
        u1.Title = 'Test User';
        u1.Username = 'userTest0987@officedepot.com';
        u1.Alias = 'testuser';
        u1.CommunityNickname = 'UTest12NickName';
        u1.TimeZoneSidKey = 'America/Mexico_City';
        u1.LocaleSidKey = 'en_US';
        u1.EmailEncodingKey = 'ISO-8859-1';
        u1.ProfileId = pf.Id;
        u1.LanguageLocaleKey = 'en_US';
        u1.isActive = true;
        insert u1;


        System.runAs(u)
        {
         org__c  org = new org__c();
            org.business_name__c='office depot';
            org.address_1__c='6600 N Military Trl';
            org.city__c='Boca Raton';
            org.state__c='FL';
            org.zip__c ='33487-2434';
            insert org;
        
        Account acc = new Account();
        acc.OwnerId=u.id;
        acc.name='test1';
        acc.AccountNumber = '112233';
        acc.org__c  = org.id;
        insert acc;

        Account acc1 = new Account();
        acc1.OwnerId=u.id;
        acc1.name='test2';
        acc1.AccountNumber = '112233';
        //acc1.related_account__c = acc.id;
        //acc1.Primary_Site__c=true;
        acc1.org__c  = org.id;
        insert acc1;

        Reassignment_Queue__c rq = new Reassignment_Queue__c();
        rq.Account__c = acc1.id;
        rq.Requestor__c = u.id;
        rq.New_Owner__c = u.id;
        rq.Approver__c = u.id;
        rq.Status__c = 'Pending Approval';
        rq.Approve_Reject_Date__c= system.now();
        insert rq;



        sales_person__c slsPersonObj = new sales_person__c();
        slsPersonObj.user__c = u1.id;
        slsPersonObj.isactive__c = true;
        slsPersonObj.primary__c = true;
        insert slsPersonObj;

        test.starttest();
        ReassignUtils.AppRejData reAsgnUtlAppRejDtObj = new ReassignUtils.AppRejData();
        reAsgnUtlAppRejDtObj.QueueID = rq.id;
        List<Id> reAsgnUtlAppRejDtLst = new List<Id>();
        reAsgnUtlAppRejDtLst.add(reAsgnUtlAppRejDtObj.QueueID);
        ReassignUtils resnUtlObj = new ReassignUtils();
        String type = 'A';
        resnUtlObj.ApproveRej(reAsgnUtlAppRejDtLst,type);
        test.stoptest();

        }
    }
     public static testMethod void myUnitTest4()
    {
        RecordType rcd = [select id from recordtype where recordtype.name = 'Customer'];
        RecordType rcd1 = [select id from recordtype where recordtype.name = 'Site'];

        Map<ID,ID> currentOwnerMap = new Map<ID,ID>();
        Profile pf = [Select Id from Profile where Name = 'System Administrator'];
        User u = new User();
        u.FirstName = 'Test';
        u.LastName = 'User';
        u.Email = 'testuser@officedepot.com';
        u.CompanyName = 'test.com';
        u.Title = 'Test User';
        u.Username = 'user1234@officedepot.com';
        u.Alias = 'testuser';
        u.CommunityNickname = 'UserNickName';
        u.TimeZoneSidKey = 'America/Mexico_City';
        u.LocaleSidKey = 'en_US';
        u.EmailEncodingKey = 'ISO-8859-1';
        u.ProfileId = pf.Id;
        u.LanguageLocaleKey = 'en_US';
        u.isActive = true;
        insert u;

        System.runAs(u)
        {
        
         org__c  org = new org__c();
            org.business_name__c='office depot';
            org.address_1__c='6600 N Military Trl';
            org.city__c='Boca Raton';
            org.state__c='FL';
            org.zip__c ='33487-2434';
            insert org;
            
        list<Account> acclist = new list<Account>();
        Account acc = new Account();
        acc.OwnerId=u.id;
        acc.name='test1';
        acc.AccountNumber = '112233';
        //acc.recordtypeid = rcd1.id;
        acc.org__c  = org.id;
        acclist.add(acc);

        Account acc1 = new Account();
        acc1.OwnerId=u.id;
        acc1.name='test2';
        acc1.AccountNumber = '112233';
        //acc1.related_account__c = acc.id;
        //acc1.Primary_Site__c = true;
        //acc1.recordtypeid = rcd.id;
        acc1.org__c  = org.id;
        acclist.add(acc1);

        insert acclist;

        Reassignment_Queue__c rq = new Reassignment_Queue__c();
        rq.Account__c = acc1.id;
        rq.Requestor__c = u.id;
        rq.New_Owner__c = u.id;
        rq.Approver__c = u.id;
        rq.Status__c = 'Pending Approval';
        rq.Approve_Reject_Date__c= system.now();
        insert rq;


        test.starttest();
        ReassignUtils.ReassignData reAsgnUtlReAsnDataObj = new ReassignUtils.ReassignData();
        reAsgnUtlReAsnDataObj.AccountID = acc.id;
        reAsgnUtlReAsnDataObj.toUserID = u.id;
        reAsgnUtlReAsnDataObj.status_code = 'Code';
        reAsgnUtlReAsnDataObj.status_msg = 'Message';
        List<ReassignUtils.ReassignData> reAsgnUtlReAsnDataList = new List<ReassignUtils.ReassignData>();
        reAsgnUtlReAsnDataList.add(reAsgnUtlReAsnDataObj);
        ReassignUtils resnUtlObj = new ReassignUtils();
        resnUtlObj.ReassignAccounts(reAsgnUtlReAsnDataList);
        resnUtlObj.AutoApprove(reAsgnUtlReAsnDataList);
        test.stoptest();
        }

    }
    //Added Below test Method By Vipul Jain for story#442656 (00771958 - Prospect Reassignment- Open Permission for Unassigned Prospects) on 4 October,2016
    public static testMethod void myUnitTest5()
    {
        RecordType rcd = [select id from recordtype where recordtype.name = 'Customer'];
        RecordType rcd1 = [select id from recordtype where recordtype.name = 'Site'];

        Map<ID,ID> currentOwnerMap = new Map<ID,ID>();
        Profile pf = [Select Id from Profile where Name = 'System Administrator'];
        User u = new User();
        u.FirstName = '';
        u.LastName = 'Dataloader';
        u.Email = 'testuser@officedepot.com';
        u.CompanyName = 'test.com';
        u.Title = 'Test User';
        u.Username = 'user1234@officedepot.com';
        u.Alias = 'testuser';
        u.CommunityNickname = 'UserNickName';
        u.TimeZoneSidKey = 'America/Mexico_City';
        u.LocaleSidKey = 'en_US';
        u.EmailEncodingKey = 'ISO-8859-1';
        u.ProfileId = pf.Id;
        u.LanguageLocaleKey = 'en_US';
        u.isActive = true;
        insert u;
        //currentOwnerMap.put(u.id);

        System.runAs(u)
        {
            Group grpObj = new Group();
            grpObj.name = 'ReAssignment Admin';
            insert grpObj;

            groupMember grpMbrObj = new groupMember();
            grpMbrObj.UserOrGroupId = u.id;
            grpMbrObj.GroupId = grpObj.id;
            insert grpMbrObj;

            org__c  org = new org__c();
            org.business_name__c='office depot';
            org.address_1__c='6600 N Military Trl';
            org.city__c='Boca Raton';
            org.state__c='FL';
            org.zip__c ='33487-2434';
            insert org;
            
            list<Account> acclist = new list<Account>();
            Account acc = new Account();
            acc.OwnerId=u.id;
            acc.name='test1';
            acc.AccountNumber = '112233';
            //acc.recordtypeid = rcd1.id;
            acc.org__c  = org.id;
            acclist.add(acc);
            //insert acc;

            Account acc1 = new Account();
            acc1.OwnerId=u.id;
            acc1.name='test2';
            acc1.AccountNumber = '112233';
            //acc1.related_account__c = acc.id;
            //acc1.Primary_Site__c = true;
            //acc1.recordtypeid = rcd.id;
            acc1.org__c  = org.id;
            acclist.add(acc1);

             Account acc2 = new Account();
            acc2.OwnerId=u.id;
            acc2.name='test2';
            acc2.AccountNumber = '112233';
            //acc2.related_account__c = acc.id;
            //acc2.Primary_Site__c = false;
            //acc2.recordtypeid = rcd.id;
            acc2.org__c  = org.id;
            acclist.add(acc2);

            insert acclist;

            list<Database.saveResult> aResult = Database.Update(acclist,false);
            for (Database.SaveResult result : aResult) {
            if (!result.isSuccess()){
            for (Database.Error err : result.getErrors()){
            System.debug('Error: '+ err.getStatusCode() + ' ' + err.getMessage());
            }}
            }
            Reassignment_Queue__c rq = new Reassignment_Queue__c();
            rq.Account__c = acc1.id;
            rq.Requestor__c = u.id;
            rq.New_Owner__c = u.id;
            rq.Approver__c = u.id;
            rq.Status__c = 'Failed';
            rq.Approve_Reject_Date__c= system.now();
            insert rq;


            sales_person__c slsPersonObj = new sales_person__c();
            slsPersonObj.user__c = u.id;
            slsPersonObj.isactive__c = true;
            slsPersonObj.primary__c = true;
            insert slsPersonObj;

            test.starttest();
            PageReference pgRef = Page.ReassignProspect;
            Test.setCurrentPage(pgRef);
            ApexPages.StandardController sc = new ApexPages.StandardController(acc);
            ApexPages.currentPage().getParameters().put('id', acc.id);
            ReassignAccount Resacc = new ReassignAccount(sc);
            Resacc.createAssignment();
            Resacc.SaveRecord();
            Resacc.CancelRec();
            Resacc.getaccList();

            ReassignUtils.ReassignData reAsgnUtlReAsnDataObj = new ReassignUtils.ReassignData();
            reAsgnUtlReAsnDataObj.AccountID = acc.id;
            reAsgnUtlReAsnDataObj.toUserID = u.id;
            reAsgnUtlReAsnDataObj.status_code = 'Code';
            reAsgnUtlReAsnDataObj.status_msg = 'Message';
            List<ReassignUtils.ReassignData> reAsgnUtlReAsnDataList = new List<ReassignUtils.ReassignData>();
            reAsgnUtlReAsnDataList.add(reAsgnUtlReAsnDataObj);
            ReassignUtils.AppRejData reAsgnUtlAppRejDtObj = new ReassignUtils.AppRejData();
            reAsgnUtlAppRejDtObj.QueueID = rq.id;
            List<Id> reAsgnUtlAppRejDtLst = new List<Id>();
            reAsgnUtlAppRejDtLst.add(reAsgnUtlAppRejDtObj.QueueID);
            ReassignUtils resnUtlObj = new ReassignUtils();
            resnUtlObj.getIsAdmin();
            resnUtlObj.ReassignAllowed();
            resnUtlObj.getUserHier();
            resnUtlObj.appRejAllowed(rq.Approver__c);
            resnUtlObj.ReassignAccounts(reAsgnUtlReAsnDataList);
            resnUtlObj.AutoApprove(reAsgnUtlReAsnDataList);
            String type = 'A';
            resnUtlObj.ApproveRej(reAsgnUtlAppRejDtLst,type);
            String type1 = 'R';
            resnUtlObj.ApproveRej(reAsgnUtlAppRejDtLst,type1);
            String type2 = 'C';
            resnUtlObj.ApproveRej(reAsgnUtlAppRejDtLst,type2);
            resnUtlObj.submitApproval(reAsgnUtlReAsnDataList,currentOwnerMap);
            test.stoptest();

        }
    }
}