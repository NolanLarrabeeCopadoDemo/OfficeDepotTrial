@isTest
public class ProspectReassign_TC
{

     public static testMethod void myUnitTest()
    {

        Recordtype rcd =  [select id from recordtype where name = 'Prospect'];
        Profile pf = [Select Id from Profile where Name = 'System Administrator'];
        User u = new User();
        u.FirstName = 'test';
        u.LastName = 'User';
        u.Email = 'user@wipro.com';
        u.CompanyName = 'test.com';
        u.Title = 'User';
        u.Username = 'user.test@wipro.com';
        u.Alias = 'tuser';
        u.isactive=true;
        u.CommunityNickname = 'Test User';
        u.TimeZoneSidKey = 'America/Mexico_City';
        u.LocaleSidKey = 'en_US';
        u.EmailEncodingKey = 'ISO-8859-1';
        u.ProfileId = pf.Id;
        u.LanguageLocaleKey = 'en_US';
        insert u;
        
        system.runAs(u)
        {
            Sales_Person__c salesPerson = new Sales_Person__c();
            salesPerson.Role_Relate_Id__c='012100';
            salesPerson.OwnerId = u.id;
            insert salesPerson ;

            Account acc = new Account ();
            acc.name = 'SUN Test Account';
            acc.BillingStreet = '1040 N 326 W';
            acc.billingcity = 'Orem';
            acc.BillingState = 'UT';
            acc.Billingcountry = 'USA';
            acc.Oracle_Party_Id__c = '123456';
            acc.AOPS_Cust_Id__c = '123456';
            acc.AOPS_Seq_ID__c = '123456';
            acc.OwnerId=u.id;
            acc.recordtypeid = rcd.id;
            acc.Industry_OD_SIC_Rep__c = 'Accounting';
            acc.ZIP__C = '1111';
            acc.Org_WCW_Count_DB__c =11112234;
            acc.AccountNumber ='223112';
            acc.Sales_PersonID__c = salesPerson.id; //Sales person Id for the Salesforce USer

            insert acc;



        }
        ProspectReassign prospctRsnObj = new ProspectReassign();        
        prospctRsnObj.ReassignAll();
        prospctRsnObj.zipCodes = '1111';//S-414429 (OD 00687413) [Hemant 5/31/2016] - Update Zip Filter
        prospctRsnObj.Search();
        prospctRsnObj.Reassign();
        ProspectReassign.ReassignOut rassgnOutObj = new ProspectReassign.ReassignOut();
        ReassignUtils.ReassignData reAssgnUtilObj = new ReassignUtils.ReassignData();
    }
    public static testMethod void myUnitTest1()
    {
    Recordtype rcd =  [select id from recordtype where name = 'Prospect'];
        List<User> usrList = new List<User>();
        Profile pf = [Select Id from Profile where Name = 'System Administrator'];
        User u = new User();
        u.FirstName = 'Test';
        u.LastName = 'User';
        u.Email = 'testuser@officedepot.com';
        u.CompanyName = 'test.com';
        u.Title = 'Test User';
        u.Username = 'user.test876@officedepot.com';
        u.Alias = 'testuser';
        u.CommunityNickname = 'TestUs';
        u.TimeZoneSidKey = 'America/Mexico_City';
        u.LocaleSidKey = 'en_US';
        u.EmailEncodingKey = 'ISO-8859-1';
        u.ProfileId = pf.Id;
        u.LanguageLocaleKey = 'en_US';
        u.isActive = true;
        usrList.add(u);
        insert usrList;

        System.runAs(u)
        {
            Group grpObj = new Group();
            grpObj.name = 'ReAssignment Admin';
            insert grpObj;

            groupMember grpMbrObj = new groupMember();
            grpMbrObj.UserOrGroupId = u.id;
            grpMbrObj.GroupId = grpObj.id;
            insert grpMbrObj;

            Account acc = new Account();
            acc.OwnerId=u.id;
            acc.name='test1';
            acc.AccountNumber = '112233';
            acc.recordtypeid = rcd.id;
            insert acc;

            Account acc1 = new Account();
            acc1.OwnerId=u.id;
            acc1.name='test2';
            acc1.AccountNumber = '112233';
            acc1.related_account__c = acc.id;
            acc1.Primary_Site__c=true;
            acc1.recordtypeid = rcd.id;

            insert acc1;

            Reassignment_Queue__c rq = new Reassignment_Queue__c();
            rq.Account__c = acc1.id;
            rq.Requestor__c = u.id;
            rq.New_Owner__c = u.id;
            rq.Approver__c = u.id;
            rq.Status__c = 'Pending Approval';
            rq.Approve_Reject_Date__c= system.now();
            insert rq;

            test.starttest();
            PageReference pgRef = Page.ProspectReassign;
            Test.setCurrentPage(pgRef);
            ApexPages.StandardController sc = new ApexPages.StandardController(acc);
            ApexPages.currentPage().getParameters().put('id', acc.id);
            List<ProspectReassign.ReassignOut> prspctResgnOutList = new List<ProspectReassign.ReassignOut>();
            ProspectReassign.ReassignOut prspctResgnOutObj = new ProspectReassign.ReassignOut();
            prspctResgnOutObj.act = acc1;
            prspctResgnOutObj.sbox = true;
            prspctResgnOutObj.newOwner = 'New Owner';
            prspctResgnOutObj.qStatus= 'qStatus';
            prspctResgnOutObj.qStatusMsg= 'qStatusMsg';
            prspctResgnOutObj.qAppReJDt = 'qAppReJDt';
            prspctResgnOutObj.selectDisabled= true;
            prspctResgnOutList.add(prspctResgnOutObj);
            ProspectReassign prospctRsnObj = new ProspectReassign();
            prospctRsnObj.Reassign();
            test.stoptest();
        }
    }
    public static testMethod void myUnitTest2()
    {
        Recordtype rcd =  [select id from recordtype where name = 'Prospect'];
        List<User> usrList = new List<User>();
        Profile pf = [Select Id from Profile where Name = 'System Administrator'];
        User u = new User();
        u.FirstName = 'Test';
        u.LastName = 'User';
        u.Email = 'testuser@officedepot.com';
        u.CompanyName = 'test.com';
        u.Title = 'Test User';
        u.Username = 'user.test86@officedepot.com';
        u.Alias = 'testuser';
        u.CommunityNickname = 'TetUse';
        u.TimeZoneSidKey = 'America/Mexico_City';
        u.LocaleSidKey = 'en_US';
        u.EmailEncodingKey = 'ISO-8859-1';
        u.ProfileId = pf.Id;
        u.LanguageLocaleKey = 'en_US';
        u.isActive = true;
        u.od_employee_id__c = '98706';
        usrList.add(u);
        insert usrList;

        System.runAs(u)
        {
            Account acc = new Account();
            acc.OwnerId=u.id;
            acc.name='test12';
            acc.AccountNumber = '114455';
            acc.recordtypeid = rcd.id;
            insert acc;

            Reassignment_Queue__c rq = new Reassignment_Queue__c();
            rq.Account__c = acc.id;
            rq.Requestor__c = u.id;
            rq.New_Owner__c = u.id;
            rq.Approver__c = u.id;
            rq.Status__c = 'Pending Approval';
            rq.Status_message__c = 'Status Messgae';
            rq.Approve_Reject_Date__c= system.now();
            insert rq;

            Sales_Person__c salesPersonObj = new Sales_Person__c();
            salesPersonObj.Role_Relate_Id__c='02100';
            salesPersonObj.OwnerId = u.id;
            insert salesPersonObj ;
            List<Account> accList = new List<Account>();
            /*Account acc1 = new Account();
            acc1.OwnerId=u.id;
            acc1.name='test2';
            acc1.AccountNumber = '112233';
            acc1.Primary_Site__c=true;
            acc1.Sales_PersonID__c = salesPersonObj.id;
            acc1.Industry_OD_SIC_Rep__c = 'Accounting';
            acc1.status__c = 'Active';
            acc1.zip__C = '1111';
            acc1.Org_WCW_Count_Rep__c = 12344;
            acc1.assignment_status__c = rq.id;
            acc1.recordtypeid = '012E000000093Jp';
            insert acc1;*/

            for(integer i=0; i<150; i++)
            {
             Account acc1 = new Account();
                acc1.OwnerId=u.id;
                acc1.name='test2';
                acc1.AccountNumber = '112233';
                //acc1.Account_Number__c = '11223344';
                acc1.Primary_Site__c=true;
                acc1.Sales_PersonID__c = salesPersonObj.id;
                acc1.Industry_OD_SIC_Rep__c = 'Accounting';
                acc1.status__c = 'Active';
                acc1.zip__C = '';
                acc1.Org_WCW_Count_Rep__c = 12344;
                acc1.assignment_status__c = rq.id;
                acc1.recordtypeid = rcd.id;
                accList.add(acc1);
            }
                insert accList;
                system.debug('@@@@@@@@@@@@@@@@@@accList' + accList);



            test.starttest();
            PageReference pgRef = Page.ProspectReassign;
            Test.setCurrentPage(pgRef);
            ApexPages.StandardController sc = new ApexPages.StandardController(acc);
            ApexPages.currentPage().getParameters().put('id', acc.id);
            List<ProspectReassign.ReassignOut> prspctResgnOutList = new List<ProspectReassign.ReassignOut>();
            ProspectReassign.ReassignOut prspctResgnOutObj = new ProspectReassign.ReassignOut();
            prspctResgnOutObj.act = acc;
            prspctResgnOutObj.sbox = true;
            prspctResgnOutObj.newOwner = 'New Owner';
            prspctResgnOutObj.qStatus= 'qStatus';
            prspctResgnOutObj.qStatusMsg= 'qStatusMsg';
            prspctResgnOutObj.qAppReJDt = 'qAppReJDt';
            prspctResgnOutObj.selectDisabled= true;
            prspctResgnOutList.add(prspctResgnOutObj);



            ProspectReassign prospctRsnObj = new ProspectReassign();
            //pgRef.getParameters().put('customerName', 'test2');
            prospctRsnObj.customerName = 'test2';
            prospctRsnObj.industry = 'Accounting';
            prospctRsnObj.AccountToHoldInput.ownerID = u.id;
            prospctRsnObj.AccountToHoldsp.ownerID = u.id;
            prospctRsnObj.AccountToHoldInput.Org_WCW_Count_DB__c = 12344;
            prospctRsnObj.WCWRangeValue = '500+'; //S-414428 (OD 00687410) [Hemant 5/31/2016] - Add WCW Range
            prospctRsnObj.customerNumber = '11223344';
            prospctRsnObj.SalesRepName = 'test2'; //added for the story S-418599 (00687415)
            prospctRsnObj.state = 'New York'; //added for the story #S-418604 (00715861)
            prospctRsnObj.odEmpId = '98706';
            prospctRsnObj.salesPerson = 'salesPerson';
            prospctRsnObj.ProsposedsalesPerson = 'ProsposedsalesPerson';

            //prospctRsnObj.zip ='1111';
            //prospctRsnObj.AccountRecType ='/'Prospect'/';
            prospctRsnObj.getstateList(); // added for the story #S-418604 (00715861)
            prospctRsnObj.ReassignAll();
            prospctRsnObj.Search();
            prospctRsnObj.Reassign();
            test.stoptest();
        }
    }
     public static testMethod void myUnitTest3()
    {

        Recordtype rcd =  [select id from recordtype where name = 'Prospect'];
        Profile pf = [Select Id from Profile where Name = 'System Administrator'];
        List<User> usList = new List<User>();
        User u = new User();
        u.FirstName = 'test';
        u.LastName = 'User';
        u.Email = 'user@wipro.com';
        u.CompanyName = 'test.com';
        u.Title = 'User';
        u.Username = 'user.test2189@wipro.com';
        u.Alias = 'tuser';
        u.isactive=false;
        u.CommunityNickname = 'TestComm23';
        u.TimeZoneSidKey = 'America/Mexico_City';
        u.LocaleSidKey = 'en_US';
        u.EmailEncodingKey = 'ISO-8859-1';
        u.ProfileId = pf.Id;
        u.LanguageLocaleKey = 'en_US';
        usList.add(u);
        insert usList;
        
      System.runas(new user(ID = UserInfo.getUserID()))
        {

            Sales_Person__c salesPerson = new Sales_Person__c();
            salesPerson.Role_Relate_Id__c='018900';
            salesPerson.OwnerId = u.id;
            insert salesPerson ;

            Account acc = new Account ();
            acc.name = 'SUN Test Account';
            acc.BillingStreet = '1040 N 326 W';
            acc.billingcity = 'Orem';
            acc.BillingState = 'UT';
            acc.Billingcountry = 'USA';
            acc.Oracle_Party_Id__c = '123456';
            acc.AOPS_Cust_Id__c = '123456';
            acc.AOPS_Seq_ID__c = '123456';
            acc.OwnerId=u.id;
            acc.recordtypeid = rcd.id;
            acc.Industry_OD_SIC_Rep__c = 'Accounting';
            acc.ZIP__C = '1111';
            acc.Org_WCW_Count_DB__c =11112234;
            acc.AccountNumber ='223112';
            acc.Sales_PersonID__c = salesPerson.id; //Sales person Id for the Salesforce USer
            insert acc;
        test.starttest();
        ProspectReassign prospctRsnObj = new ProspectReassign();
        prospctRsnObj.ReassignAll();
        prospctRsnObj.Search();
        prospctRsnObj.Reassign();
        ProspectReassign.ReassignOut rassgnOutObj = new ProspectReassign.ReassignOut();
        ReassignUtils.ReassignData reAssgnUtilObj = new ReassignUtils.ReassignData();
        reAssgnUtilObj.AccountId=acc.id;
        reAssgnUtilObj.toUserID=u.id;
        reAssgnUtilObj.status_code='E';
        test.stoptest();
        }

    }
}