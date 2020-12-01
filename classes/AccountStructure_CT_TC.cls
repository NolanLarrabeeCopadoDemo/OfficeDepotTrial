@isTest
private class AccountStructure_CT_TC 
{
    static testMethod void TestAccountStructure_CT(){
        
        executeoncetest.bypassAccountExtension = true;

        Schema.DescribeSObjectResult d1 = Schema.SObjectType.Account; 
        Map<String,Schema.RecordTypeInfo> rtMapByName = d1.getRecordTypeInfosByName(); 
        
        Profile profileObj = [select id from profile where name='System Administrator'];

        String profId = profileObj.id;
        user usrObj = new user(Username='abc@officedepot.com.uat',FirstName ='Fname', LastName='Lname', Alias='abc', CommunityNickname='abc', LocaleSidKey='en_US', EmailEncodingKey='UTF-8', Profileid = profId, LanguageLocaleKey='en_US', email='abc@officedepot.com.uat',TimeZoneSidKey='America/New_York');
        usrObj.Short_Title__c='';
        Insert usrObj;
        
        Account pacc = new Account ();
        pacc.name = 'SUN Test Account1';
        pacc.recordtypeid=rtMapByName.get('Customer (OfficeMax)').getRecordTypeId(); 
        pacc.BillingStreet = '1040 N 326 W';
        pacc.billingcity = 'Orem';
        pacc.BillingState = 'UT';
        pacc.Billingcountry = 'USA';
        pacc.Oracle_Party_Id__c = '543456';
        pacc.omx_primary_key__C = '003456';
        pacc.Split_Record__c = false;
        pacc.status__c='Inactive';
        pacc.address1__C='test';
        pacc.OMX_Mainframe_Account_Number__c = '003456';
        system.runas(usrObj){
            insert pacc;
        }
        
        Test.startTest();
        Account acc = new Account ();
        acc.name = 'SUN Test Account';
        acc.BillingStreet = '1040 N 326 W';
        acc.billingcity = 'Orem';
        acc.BillingState = 'UT';
        acc.Billingcountry = 'USA';
        acc.Oracle_Party_Id__c = '123456';
        acc.Split_Record__c = false;
        acc.omx_primary_key__C = '123456';
        acc.parentid=pacc.id;
        acc.recordtypeid=rtMapByName.get('Customer (OfficeMax)').getRecordTypeId();
        acc.address1__C='testing records address 25';
        acc.OMX_Mainframe_Account_Number__c = '123456';
        system.runas(usrObj){
        insert acc;   
        }
        pacc.status__c='Active';
        system.runas(usrObj){
        update pacc;
        }
        Customer_Transition__c parentCT = new Customer_Transition__c(name='parenttest',account__c = pacc.id,Status__c='Scheduled');
       system.runas(usrObj){
        insert parentCT;
       }
        
        Customer_Transition__c CT = new Customer_Transition__c(name='test',account__c = acc.id,Status__c='Scheduled');
        system.runas(usrObj){
        insert CT;
        }
        
        Test.setCurrentPage(Page.Account_Hierarchy_Page_CT);
        ApexPages.CurrentPage().getParameters().put('EL','Y');
        ApexPages.CurrentPage().getParameters().put('id',acc.id);
        ApexPages.StandardController controller1 = new ApexPages.StandardController(acc);
        
        AccountStructure_CT asct = new AccountStructure_CT();
        AccountStructure_CT asct1 = new AccountStructure_CT(controller1);
        
        asct.userEmailCc='xyz@officedepot.com.uat';
        asct1.userEmailCc='xyz@officedepot.com.uat;abc@officedepot.com.uat';
        asct1.getObjectStructure();
        asct1.setcurrentId(String.valueOf(acc.id));
        asct1.IdTreeNodeForAction='0';
        asct1.NodeStatus='';
        asct1.updateTree();
        List<String> cn1 = new List<String>();
        List<String> nn1 = new List<String>();
        cn1.add('0');
        cn1.add('1');
        nn1.add('0');
        nn1.add('1');
        
        String nodeType ='child';
        asct1.setlevelFlag( nn1,nodeType);
        asct1.setcloseFlag(cn1,nn1,nodeType);
        asct1.isLastNode( nn1);
        asct1.ExclusionList=false;
        asct1.GetTopElement(String.valueOf(acc.id));
        asct1.ExclusionList=true;
        asct1.getEmailList(0,1);
        asct1.createNewBody();
        
        asct1.accountMap.put(pacc.id,pacc);
        PageReference pf = asct1.sendEmail();
        asct1.CreateActivity();
        PageReference pf1 = asct1.selectedAccounts();
        PageReference pf2 = asct1.LaunchSelected();
        PageReference pf3 = asct1.BackToAccountHierarchy();
        List<SelectOption> ops =  asct1.getUsers();
        String str = asct1.getSelectedUsers();
        asct1.setSelectedUsers(str);
        
        List<Boolean> bn= new List<Boolean>();
        bn.add(true);
        AccountStructure_CT.ObjectStructureMap wrap = new AccountStructure_CT.ObjectStructureMap( '0', bn,bn ,'child', true, true, CT );
        wrap.getnodeId();
        wrap.getlevelFlag();
        wrap.getcloseFlag();
        wrap.getnodeType();
        wrap.getcurrentNode();
        Customer_Transition__c ctt = wrap.getaccount();
        wrap.setnodeId('test');
        wrap.setlevelFlag(true);
        wrap.setlcloseFlag(true);
        wrap.setnodeType('test');
        wrap.setcurrentNode(true);
        wrap.setaccount(ctt);
        
        AccountStructure_CT.WrapErrors wrapError = new AccountStructure_CT.WrapErrors('123456@@:@@SUN Test Account@@:@@Account Owner is not Active');
        wrapError.getomxPrimaryKey();
        wrapError.getaccName();
        wrapError.getreason();

		//Test.startTest() ; // Added for the story #S-355233
		
        Test.setCurrentPage(Page.Account_Hierarchy_Page_CT);
        ApexPages.CurrentPage().getParameters().put('EL','Y');
        ApexPages.CurrentPage().getParameters().put(pacc.id,'1');
        asct1.accountMap.put(pacc.id,pacc);
        PageReference pf5 = asct1.LaunchSelected();
        
        Test.stopTest(); // Added for the story #S-355233
        
    }
    
    // Added for the story #S-355233 #START
     static testMethod void TestAccountStructure_CT1(){
        
        executeoncetest.bypassAccountExtension = true;
        
        Schema.DescribeSObjectResult d1 = Schema.SObjectType.Account; 
        Map<String,Schema.RecordTypeInfo> rtMapByName = d1.getRecordTypeInfosByName(); 
        
        Profile profileObj = [select id from profile where name='System Administrator'];
        

        String profId = profileObj.id;
        user usrObj = new user(Username='abc@officedepot.com.uat',FirstName ='Fname', LastName='Lname', Alias='abc', CommunityNickname='abc', LocaleSidKey='en_US', EmailEncodingKey='UTF-8', Profileid = profId, LanguageLocaleKey='en_US', email='abc@officedepot.com.uat',TimeZoneSidKey='America/New_York');
        usrObj.Short_Title__c='';
        Insert usrObj;
        
        Sales_Person__c s= new Sales_Person__c();
        s.name = 'Awaiting SalesID';
        s.IsActive__c=true;
        s.Role_Relate_Id__c ='333333';
        s.Primary__c =true;
        s.user__c=usrObj.id;
          system.runas(usrObj){
        insert s;
          }
        
        Account pacc = new Account ();
        pacc.name = 'SUN Test Account1';
        pacc.recordtypeid=rtMapByName.get('Customer (OfficeMax)').getRecordTypeId(); 
        pacc.BillingStreet = '1040 N 326 W';
        pacc.billingcity = 'Orem';
        pacc.BillingState = 'UT';
        pacc.Billingcountry = 'USA';
        pacc.Oracle_Party_Id__c = '543456';
        pacc.omx_primary_key__C = '003456';
        pacc.Split_Record__c = false;
        pacc.status__c='Inactive';
        pacc.address1__C='test';
        pacc.OMX_Mainframe_Account_Number__c = '003456';
        pacc.Segment__c = 'Other';
        pacc.Sales_PersonID__c = s.id;
          system.runas(usrObj){
        insert pacc;
          }
        Test.startTest();
        Account acc = new Account ();
        acc.name = 'SUN Test Account';
        acc.BillingStreet = '1040 N 326 W';
        acc.billingcity = 'Orem';
        acc.BillingState = 'UT';
        acc.Billingcountry = 'USA';
        acc.Oracle_Party_Id__c = '123456';
        acc.Split_Record__c = false;
        acc.omx_primary_key__C = '123456';
        acc.parentid=pacc.id;
        acc.recordtypeid=rtMapByName.get('Customer (OfficeMax)').getRecordTypeId();
        acc.address1__C='testing records address 25';
        acc.OMX_Mainframe_Account_Number__c = '123456';
          system.runas(usrObj){
        insert acc;
          }
        
        pacc.status__c='Active';
          system.runas(usrObj){
        update pacc;
          }
        
        Customer_Transition__c parentCT = new Customer_Transition__c(name='parenttest',account__c = pacc.id,Status__c='Scheduled');
          system.runas(usrObj){
        insert parentCT;
          }
        
        Customer_Transition__c CT = new Customer_Transition__c(name='test',account__c = acc.id,Status__c='Scheduled');
          system.runas(usrObj){
        insert CT;
          }
        
        //Test.startTest();
        
        Test.setCurrentPage(Page.Account_Hierarchy_Page_CT);
        ApexPages.CurrentPage().getParameters().put('EL','N');
        ApexPages.CurrentPage().getParameters().put('id',acc.id);
        ApexPages.StandardController controller1 = new ApexPages.StandardController(acc);
        
        AccountStructure_CT asct = new AccountStructure_CT();
        AccountStructure_CT asct1 = new AccountStructure_CT(controller1);
        AccountStructure_CT asct2 = new AccountStructure_CT('test'); 
        
        system.assertEquals(asct.ExclusionList, false);
        
        asct.userEmailCc='xyz@officedepot.com.uat';
        asct1.userEmailCc='xyz@officedepot.com.uat;abc@officedepot.com.uat';
        
        asct1.asm = null;
        asct1.getObjectStructure();
        
        system.assertnotEquals(asct1.asm, null);
        
        asct1.setcurrentId(String.valueOf(acc.id));
        asct1.IdTreeNodeForAction='0';
        asct1.NodeStatus='';
        asct1.updateTree();
        List<String> cn1 = new List<String>();
        List<String> nn1 = new List<String>();
        cn1.add('0');
        cn1.add('1');
        nn1.add('0');
        nn1.add('1');
        
        String nodeType ='child';
        asct1.setlevelFlag( nn1,nodeType);
        asct1.setcloseFlag(cn1,nn1,nodeType);
        asct1.isLastNode( nn1);
        asct1.ExclusionList=false;
        asct1.GetTopElement(String.valueOf(acc.id));
        asct1.ExclusionList=true;
        asct1.getEmailList(0,1);
        asct1.createNewBody();
        
        asct1.accountMap.put(pacc.id,pacc);
        PageReference pf = asct1.sendEmail();
        asct1.CreateActivity();
        PageReference pf1 = asct1.selectedAccounts();
        PageReference pf2 = asct1.LaunchSelected();
        
        system.assertEquals(pf2, null);
        
        PageReference pf3 = asct1.BackToAccountHierarchy();
        List<SelectOption> ops =  asct1.getUsers();
        String str = asct1.getSelectedUsers();
        asct1.setSelectedUsers(str);
        
        List<Boolean> bn= new List<Boolean>();
        bn.add(true);
        AccountStructure_CT.ObjectStructureMap wrap = new AccountStructure_CT.ObjectStructureMap( '0', bn,bn ,'child', true, true, CT );
        wrap.getnodeId();
        wrap.getlevelFlag();
        wrap.getcloseFlag();
        wrap.getnodeType();
        wrap.getcurrentNode();
        Customer_Transition__c ctt = wrap.getaccount();
        wrap.setnodeId('test');
        wrap.setlevelFlag(true);
        wrap.setlcloseFlag(true);
        wrap.setnodeType('test');
        wrap.setcurrentNode(true);
        wrap.setaccount(ctt);
        
        AccountStructure_CT.WrapErrors wrapError = new AccountStructure_CT.WrapErrors('123456@@:@@SUN Test Account@@:@@Account Owner is not Active');
        wrapError.getomxPrimaryKey();
        wrapError.getaccName();
        wrapError.getreason();

        Test.setCurrentPage(Page.Account_Hierarchy_Page_CT);
        ApexPages.CurrentPage().getParameters().put('EL','Y');
        ApexPages.CurrentPage().getParameters().put(pacc.id,'1');
        asct1.accountMap.put(pacc.id,pacc);
        PageReference pf5 = asct1.LaunchSelected();
        
        system.assertNotEquals(pf5, null);
        
        Test.stopTest();
        
    }
    
   /*static testMethod void TestAccountStructure_CT2(){
       
        executeoncetest.bypassAccountExtension = true;

        Schema.DescribeSObjectResult d1 = Schema.SObjectType.Account; 
        Map<String,Schema.RecordTypeInfo> rtMapByName = d1.getRecordTypeInfosByName(); 
        
        Profile profileObj = [select id from profile where name='System Administrator'];
		
        String profId = profileObj.id;
        user usrObj = new user(Username='abc@officedepot.com.uat',FirstName ='Fname', LastName='Lname', Alias='abc', CommunityNickname='abc', LocaleSidKey='en_US', EmailEncodingKey='UTF-8', Profileid = profId, LanguageLocaleKey='en_US', email='abc@officedepot.com.uat',TimeZoneSidKey='America/New_York');
        usrObj.Short_Title__c='';
        Insert usrObj;
        Test.startTest();
        Sales_Person__c s= new Sales_Person__c();
        s.name = 'D7873';
        s.IsActive__c=true;
        s.Role_Relate_Id__c ='333333';
        s.Primary__c =true;
        s.user__c=usrObj.id;
        insert s;
        
        Account pacc = new Account ();
        pacc.name = 'SUN Test Account1';
        pacc.recordtypeid=rtMapByName.get('Customer (OfficeMax)').getRecordTypeId(); 
        pacc.BillingStreet = '1040 N 326 W';
        pacc.billingcity = 'Orem';
        pacc.BillingState = 'UT';
        pacc.Billingcountry = 'USA';
        pacc.Oracle_Party_Id__c = '543456';
        pacc.omx_primary_key__C = '003456';
        pacc.Split_Record__c = false;
        pacc.status__c='Inactive';
        pacc.address1__C='test';
        pacc.OMX_Mainframe_Account_Number__c = '003456';
        pacc.Segment__c = 'Other';
        pacc.Sales_PersonID__c = s.id;
        pacc.ownerId = usrObj.id;
        pacc.OMX_Mainframe_Account_Level__c = 'Main Account';
        insert pacc;
       Test.stopTest();
        Account acc = new Account ();
        acc.name = 'SUN Test Account';
        acc.BillingStreet = '1040 N 326 W';
        acc.billingcity = 'Orem';
        acc.BillingState = 'UT';
        acc.Billingcountry = 'USA';
        acc.Oracle_Party_Id__c = '123456';
        acc.Split_Record__c = false;
        acc.omx_primary_key__C = '123456';
        acc.parentid=pacc.id;
        acc.recordtypeid=rtMapByName.get('Customer (OfficeMax)').getRecordTypeId();
        acc.address1__C='testing records address 25';
        acc.OMX_Mainframe_Account_Number__c = '123456';
        acc.ownerId = usrObj.id;
        insert acc;
       
        
        Customer_Transition__c parentCT = new Customer_Transition__c(name='parenttest',account__c = pacc.id,Status__c='Scheduled', Transition_Status__c = 'Inactive');
        insert parentCT;
        
        Customer_Transition__c CT = new Customer_Transition__c(name='test',account__c = acc.id,Status__c='Scheduled');
        insert CT;
        
        //Test.startTest();
        
        Test.setCurrentPage(Page.Account_Hierarchy_Page_CT);
        ApexPages.CurrentPage().getParameters().put('EL','N');
        ApexPages.CurrentPage().getParameters().put('id',acc.id);
        ApexPages.StandardController controller1 = new ApexPages.StandardController(acc);
        
        AccountStructure_CT asct = new AccountStructure_CT();
        AccountStructure_CT asct1 = new AccountStructure_CT(controller1);
        AccountStructure_CT asct2 = new AccountStructure_CT('test'); 
        
        system.assertEquals(asct.ExclusionList, false);
        
        asct.userEmailCc='xyz@officedepot.com.uat';
        asct1.userEmailCc='xyz@officedepot.com.uat;abc@officedepot.com.uat';
        
        asct1.asm = null;
        asct1.getObjectStructure();
        
        system.assertnotEquals(asct1.asm, null);
        
        asct1.setcurrentId(String.valueOf(acc.id));
        asct1.IdTreeNodeForAction='0';
        asct1.NodeStatus='';
        asct1.updateTree();
        List<String> cn1 = new List<String>();
        List<String> nn1 = new List<String>();
        cn1.add('0');
        cn1.add('1');
        nn1.add('0');
        nn1.add('1');
        
        String nodeType ='child';
        asct1.setlevelFlag( nn1,nodeType);
        asct1.setcloseFlag(cn1,nn1,nodeType);
        asct1.isLastNode( nn1);
        asct1.ExclusionList=false;
        asct1.GetTopElement(String.valueOf(acc.id));
        asct1.ExclusionList=true;
        asct1.getEmailList(0,1);
        asct1.createNewBody();
        
        asct1.accountMap.put(pacc.id,pacc);
        PageReference pf = asct1.sendEmail();
        asct1.CreateActivity();
        
        ApexPages.currentPage().getParameters().put(pacc.id, '1');
        asct1.accountMap.put(pacc.id,pacc);
        PageReference pf0 = asct1.selectedAccounts();
        asct1.CreateActivity();
        asct1.getEmailList(0,1);
        
        Account accountInfo = new Account();
        accountInfo = (new List<Account>([select id, owner.email,name, recordtypeid, BillingStreet, billingcity, BillingState, Billingcountry, Oracle_Party_Id__c, omx_primary_key__C, Split_Record__c, status__c, address1__C, OMX_Mainframe_Account_Number__c, Segment__c, Sales_PersonID__c  from Account where id =:pacc.id]))[0];
        
        ApexPages.currentPage().getParameters().put(pacc.id, '1');
        asct1.accountMap.put(pacc.id,accountInfo);
        PageReference pf1 = asct1.selectedAccounts();
        List<SelectOption> ops1 =  asct1.getUsers();
        asct1.CreateActivity();
        asct1.getEmailList(0,1);
        
        asct1.getEmailList(0,2);
        
        PageReference pf2 = asct1.LaunchSelected();
        
        system.assertNotEquals(pf2, null);
        
        PageReference pf3 = asct1.BackToAccountHierarchy();
        List<SelectOption> ops =  asct1.getUsers();
        String str = asct1.getSelectedUsers();
        asct1.setSelectedUsers(str);
        
        List<Boolean> bn= new List<Boolean>();
        bn.add(true);
        AccountStructure_CT.ObjectStructureMap wrap = new AccountStructure_CT.ObjectStructureMap( '0', bn,bn ,'child', true, true, CT );
        wrap.getnodeId();
        wrap.getlevelFlag();
        wrap.getcloseFlag();
        wrap.getnodeType();
        wrap.getcurrentNode();
        Customer_Transition__c ctt = wrap.getaccount();
        wrap.setnodeId('test');
        wrap.setlevelFlag(true);
        wrap.setlcloseFlag(true);
        wrap.setnodeType('test');
        wrap.setcurrentNode(true);
        wrap.setaccount(ctt);
        
        AccountStructure_CT.WrapErrors wrapError = new AccountStructure_CT.WrapErrors('123456@@:@@SUN Test Account@@:@@Account Owner is not Active');
        wrapError.getomxPrimaryKey();
        wrapError.getaccName();
        wrapError.getreason();

        Test.setCurrentPage(Page.Account_Hierarchy_Page_CT);
        ApexPages.CurrentPage().getParameters().put('EL','Y');
        ApexPages.CurrentPage().getParameters().put(pacc.id,'1');
        asct1.accountMap.put(pacc.id,pacc);
        PageReference pf5 = asct1.LaunchSelected();
        
        system.assertNotEquals(pf5, null);
        
        
        
    }*/
    // Added for the story #S-355233 #END
}