@isTest
private class testAccountHierarchy{
    
    static testMethod void testAccountHierarchy(){

        List<Account> accountList = new List<Account>();
        
        Profile p = [select id from Profile where name='System Administrator' limit 1];
        
        User u = new User(TimeZoneSidKey='America/Los_Angeles',ProfileId = p.id,LastName = 'Rep', FirstName = 'name',Email='Rep.name@officedepot.com', Username ='Rep.name@officedepot.com', Alias='test12', CommunityNickname='test Approve', LanguageLocaleKey='en_US', EmailEncodingKey='UTF-8', LocaleSidKey='en_US',OD_Employee_ID__c='622207');
        insert u;
        
        Sales_Person__c s1= new Sales_Person__c();
        s1.IsActive__c=true;
        s1.Role_Relate_Id__c ='222222';
        s1.Primary__c =true;
        s1.user__c = u.id;
        insert s1;
        
        test.startTest();
         Account topAccount = new Account (name = 'GP SUN Test Account',
                                 AOPS_Seq_ID__c = '123666',
                                 AOPS_Cust_Id__c = '123666',
                                 Oracle_Party_Id__c = '123666',
                                 Billingcountry = 'USA',
                                 BillingState = 'UT',
                                 Ownerid=u.id,
                                 BillingStreet = '1040 N 326 W',
                                 billingcity = 'Orem');
         insert topAccount;
        accountList.add(topAccount);

         Account middleAccount = new Account (name = 'P SUN Test Account',
                                 AOPS_Seq_ID__c = '123466',
                                 AOPS_Cust_Id__c = '123466',
                                 Oracle_Party_Id__c = '123466',
                                 Billingcountry = 'USA',
                                 BillingState = 'UT',
                                 parentid=topAccount.id,
                                 Ownerid=u.id,
                                 BillingStreet = '1040 N 326 W',
                                 billingcity = 'Orem');
         insert middleAccount;
        accountList.add(middleAccount);

         Account bottomAccount = new Account (name = 'SUN Test Account',
                         AOPS_Seq_ID__c = '123456',
                         AOPS_Cust_Id__c = '123456',
                         Oracle_Party_Id__c = '123456',
                         Billingcountry = 'USA',
                         BillingState = 'UT',
                         Ownerid=u.id,
                         BillingStreet = '1040 N 326 W',
                         parentid= middleAccount.id,
                         billingcity = 'Orem');
         insert bottomAccount;      
        accountList.add(bottomAccount);
        
        test.stopTest();
        
        PageReference AccountHierarchyPage = Page.AccountHierarchyPage;
        Test.setCurrentPage( AccountHierarchyPage );
        ApexPages.currentPage().getParameters().put( 'id', topAccount.id );
    
        // Instanciate Controller
        AccountStructure controller = new AccountStructure();
        
        // Call Methodes for top account
        controller.setcurrentId( null );
        AccountStructure.ObjectStructureMap[] smt1 = new AccountStructure.ObjectStructureMap[]{};
        smt1 = controller.getObjectStructure();

        controller.setcurrentId( String.valueOf( topAccount.id ) );
        AccountStructure.ObjectStructureMap[] smt2 = new AccountStructure.ObjectStructureMap[]{};
        smt2 = controller.getObjectStructure();

        //Call ObjectStructureMap methodes
        smt2[0].setnodeId( '1234567890' );
        smt2[0].setlevelFlag( true );
        smt2[0].setlcloseFlag( false );
        smt2[0].setnodeType( 'parent' );
        smt2[0].setcurrentNode( false );
        smt2[0].setaccount( topAccount );
        
        String nodeId       = smt2[0].getnodeId();
        Boolean[] levelFlag = smt2[0].getlevelFlag();
        Boolean[] closeFlag = smt2[0].getcloseFlag();
        String nodeType     = smt2[0].getnodeType();
        Boolean currentName = smt2[0].getcurrentNode();
        Account smbAccount  = smt2[0].getaccount();

        // Call Methodes for middle account
        controller.setcurrentId( String.valueOf( middleAccount.id ) );
        AccountStructure.ObjectStructureMap[] smm = new AccountStructure.ObjectStructureMap[]{};
        smm = controller.getObjectStructure();

        // Call Methodes for bottom account
        controller.setcurrentId( String.valueOf( bottomAccount.id ) );
        AccountStructure.ObjectStructureMap[] smb = new AccountStructure.ObjectStructureMap[]{};
        smb = controller.getObjectStructure();
        
    }
    
    static testMethod void testEmailSending(){

        List<Account> accountList = new List<Account>();
        
        Profile p = [select id from Profile where name='System Administrator' limit 1];
        
        User u = new User(TimeZoneSidKey='America/Los_Angeles',ProfileId = p.id,LastName = 'Rep', FirstName = 'name',Email='Rep.name@officedepot.com', Username ='Rep.name@officedepot.com', Alias='test12', CommunityNickname='test Approve', LanguageLocaleKey='en_US', EmailEncodingKey='UTF-8', LocaleSidKey='en_US',OD_Employee_ID__c='622207');
        insert u;
        
        Sales_Person__c s1= new Sales_Person__c();
        s1.IsActive__c=true;
        s1.Role_Relate_Id__c ='222222';
        s1.Primary__c =true;
        s1.user__c = u.id;
        insert s1;
        
        test.startTest();
         Account topAccount = new Account (name = 'GP SUN Test Account',
                                 AOPS_Seq_ID__c = '123666',
                                 AOPS_Cust_Id__c = '123666',
                                 Oracle_Party_Id__c = '123666',
                                 Billingcountry = 'USA',
                                 BillingState = 'UT',
                                 Ownerid=u.id,
                                 BillingStreet = '1040 N 326 W',
                                 billingcity = 'Orem');
         insert topAccount;
        accountList.add(topAccount);

         Account middleAccount = new Account (name = 'P SUN Test Account',
                                 AOPS_Seq_ID__c = '123466',
                                 AOPS_Cust_Id__c = '123466',
                                 Oracle_Party_Id__c = '123466',
                                 Billingcountry = 'USA',
                                 BillingState = 'UT',
                                 parentid=topAccount.id,
                                 Ownerid=u.id,
                                 BillingStreet = '1040 N 326 W',
                                 billingcity = 'Orem');
         insert middleAccount;
        accountList.add(middleAccount);

         Account bottomAccount = new Account (name = 'SUN Test Account',
                         AOPS_Seq_ID__c = '123456',
                         AOPS_Cust_Id__c = '123456',
                         Oracle_Party_Id__c = '123456',
                         Billingcountry = 'USA',
                         BillingState = 'UT',
                         Ownerid=u.id,
                         BillingStreet = '1040 N 326 W',
                         parentid= middleAccount.id,
                         billingcity = 'Orem');
         insert bottomAccount;      
        accountList.add(bottomAccount);
        
        test.stopTest();

        // Set parentId
        PageReference AccountHierarchyPage = Page.AccountHierarchyPage;
        Test.setCurrentPage( AccountHierarchyPage );        
        ApexPages.currentPage().getParameters().put( 'id', topAccount.id );
        // Make instance of class
        ApexPages.StandardController controller = new ApexPages.StandardController(topAccount);
        AccountStructure accountStructureController = new AccountStructure(controller);
        //Set class properties
        accountStructureController.formatObjectStructure(''+topAccount.Id) ;
        accountStructureController.subject='Test';
        accountStructureController.body ='Test email';
      //accountStructureController.firstFileName = 'file1';
      //accountStructureController.firstFileLink = 'file1Link';
      //accountStructureController.secondFileName = 'file2';
      //accountStructureController.secondFileLink = 'file2Link';
      //accountStructureController.thirdFileName = 'file3';
      //accountStructureController.thirdFileLink = 'file3Link';
        // Call functions
        accountStructureController.selectedAccounts();        
        //Test email size
        List<String> emailLists = accountStructureController.getEmailList(0, 1);
        accountStructureController.CreateActivity();
        accountStructureController.getUsers();
        String body = accountStructureController.createNewBody();
        String [] modifiedBody  = body.split(':');
        // Test body        
        try{
            accountStructureController.sendEmail();
            
        }catch(Exception e){
            
        }

    }
}