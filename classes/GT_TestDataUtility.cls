public class GT_TestDataUtility {

    public static User getTestUser(String profileName,String userName,String empId){
        //profileName for example System Administrator
        //username for example abc@officedepot.com.uat
        //empId for example 612207'
        Profile profileObj = [select id from profile where name=: profileName];
        String profId = profileObj.id;
        
        string email = userName;
        string[] name = userName.split('@');
        user u = new user(Username=userName,FirstName =name[1], LastName=name[0], Alias=name[0], CommunityNickname=userName, LocaleSidKey='en_US', EmailEncodingKey='UTF-8', Profileid = profId, LanguageLocaleKey='en_US');
        u.email=email;
        u.MB_Expiration_Date__c = System.now().addminutes(1);
        u.OD_Employee_ID__c =empId;
        u.GT_Employee_ID__c =empId;
        u.IsActive=true;
        u.TimeZoneSidKey='America/Los_Angeles';
        u.Token_Market_Builder__c ='xyz';
        try{ 
            Insert u;
            system.debug('@@@User@@@ : '+u);
            return u;
        }
        catch(Exception e) {
            system.debug('Exception'+e);
        }
        return u;
    }
    
    public static Sales_Person__c getSalesPerson(User u, string roleID) {
        //roleID for example 333333
        Sales_Person__c s= new Sales_Person__c();
        s.IsActive__c=true;
        s.Role_Relate_Id__c =roleID;
        s.Primary__c =true;
        s.user__c=u.id;
        insert s;
        system.debug('@@@SalesPerson@@@ : '+s);
        return s;
    }
    
    public static Account getTestAccount(User u, string accOtherId){
        //accOtherId for example 123654
        Account acc = new Account ();
        acc.name = 'SUN'+u.name;
        //acc.BillingStreet = '1040 N 326 W';
        acc.OMX_Primary_Key__c = accOtherId;
        //acc.billingcity = 'Orem';
        //acc.BillingState = 'UT';
        //acc.Billingcountry = 'USA';
        acc.Oracle_Party_Id__c = accOtherId ;
        acc.AOPS_Cust_Id__c = accOtherId ;
        acc.AOPS_Seq_ID__c = accOtherId ;
        acc.OwnerID = u.id;// This is the salesforce User ID
        acc.Address1__c = 'address';
        
        insert acc;
        system.debug('@@@Account@@@ : '+acc);
        return acc;
    }
    /*
    public static Account getSalesPersonAccount(User u, Sales_Person__c s){
        Account acc = new Account ();
        acc.name = 'SUN'+s.name;
        //acc.BillingStreet = '1040 N 326 W';
        acc.OMX_Primary_Key__c='654321';
        //acc.billingcity = 'Orem';
        //acc.BillingState = 'UT';
        //acc.Billingcountry = 'USA';
        acc.Oracle_Party_Id__c = '654321';
        acc.AOPS_Cust_Id__c = '654321';
        acc.AOPS_Seq_ID__c = '654321';
        acc.OwnerID = u.id;// This is the salesforce User ID
        //acc.Sales_PersonID__c = 'a0AE0000000GGMn'; //Sales person Id for the Salesforce USer
        acc.Sales_PersonID__c =s.id;
        insert acc;
        return acc;
    }
    
    public static AccountAssignments__c getAccountAssignment(){
        
        AccountAssignments__c assign2 = new AccountAssignments__c();
        Id GTRT = Schema.SObjectType.AccountAssignments__c.getRecordTypeInfosByName().get('GT').getRecordTypeId();
        assign2.RecordTypeid=GTRT;
        assign2.AccountId__c = '654321';
        assign2.AccountType__c = 'S';
        assign2.Entity_Type__c = 'CUSTOMER';
        assign2.Entity_Id__c = '654321';
        assign2.PrimaryEmpId__c = '622207';
        assign2.PrimaryEmpRole__c = '654321';
        assign2.OverlayEmpID1__c = '104344';
        assign2.OverlayEmpRole1__c = '111111';
        assign2.OverlayEmpID2__c = '595673';
        assign2.OverlayEmpRole2__c = '222222';
        assign2.OverlayEmpID3__c = '600980';
        assign2.OverlayEmpRole3__c = '333333';
        assign2.OverlayEmpID4__c = '652207';
        assign2.OverlayEmpRole4__c = '';
        assign2.OverlayEmpID5__c = '234567';
        assign2.OverlayEmpRole5__c = '44444';
        assign2.OverlayEmpID6__c = '234567';
        assign2.OverlayEmpRole6__c = '44444';
        assign2.OverlayEmpID7__c = '234567';
        assign2.OverlayEmpRole7__c = '44444';
        assign2.OverlayEmpID8__c = '234567';
        assign2.OverlayEmpRole8__c = '44444';
        assign2.OverlayEmpID9__c = '234567';
        assign2.OverlayEmpRole9__c = '44444';
        assign2.OverlayEmpID10__c = '234567';
        assign2.OverlayEmpRole10__c = '44444';
        assign2.OverlayEmpID11__c = '234567';
        assign2.OverlayEmpRole11__c = '44444';
        assign2.OverlayEmpID12__c = '234567';
        assign2.OverlayEmpRole12__c = '44444';
        assign2.OverlayEmpID13__c = '234567';
        assign2.OverlayEmpRole13__c = '44444';
        assign2.OverlayEmpID14__c = '234567';
        assign2.OverlayEmpRole14__c = '44444';
        assign2.OverlayEmpID15__c = '234567';
        assign2.OverlayEmpRole15__c = '44444';
        assign2.OverlayEmpID16__c = '179556';
        assign2.OverlayEmpRole16__c = '11111';
        assign2.OverlayEmpID17__c = '595673';
        assign2.OverlayEmpRole17__c = '22222';
        assign2.OverlayEmpID18__c = '601832';
        assign2.OverlayEmpRole18__c = '333333';
        assign2.OverlayEmpID19__c = '234567';
        assign2.OverlayEmpRole19__c = '44444';
        assign2.OverlayEmpID20__c = '234567';
        assign2.OverlayEmpRole20__c = '44444';
        assign2.OverlayEmpID21__c = '234567';
        assign2.OverlayEmpRole21__c = '44444';
        assign2.OverlayEmpID22__c = '234567';
        assign2.OverlayEmpRole22__c = '44444';
        assign2.OverlayEmpID23__c = '234567';
        assign2.OverlayEmpRole23__c = '44444';
        assign2.OverlayEmpID24__c = '234567';
        assign2.OverlayEmpRole24__c = '44444';
        assign2.OverlayEmpID25__c = '234567';
        assign2.OverlayEmpRole25__c = '44444';
        assign2.OverlayEmpID26__c = '234567';
        assign2.OverlayEmpRole26__c = '44444';
        assign2.OverlayEmpID27__c = '234567';
        assign2.OverlayEmpRole27__c = '44444';
        assign2.OverlayEmpID28__c = '234567';
        assign2.OverlayEmpRole28__c = '44444';
        assign2.OverlayEmpID29__c = '234567';
        assign2.OverlayEmpRole29__c = '44444';
        assign2.OverlayEmpID30__c = '234567';
        assign2.OverlayEmpRole30__c = '44444';
        assign2.Status__c = 'Open';
        insert assign2;
        return assign2;
    }
    
    public static List<AccountTeamMember> getAccountTeamMembersRecord(Id accountId,List<User> lstUser) {
        List<AccountTeamMember> insertAccountTeamMember= new List<AccountTeamMember>();
         AccountTeamMember objmember;
       for(User usr : lstUser) {
            objmember = new AccountTeamMember ();
            objmember.UserId = usr.id;
            objmember.AccountId =accountId;
            objmember.teammemberrole = 'Account Manager';
            insertAccountTeamMember.add(objmember);
        }    
        return insertAccountTeamMember;
  
      }*/
}