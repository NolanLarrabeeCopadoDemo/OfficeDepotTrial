@isTest
public class com2SPCCardController_TC {
    @TestSetup
    static void makeData(){
        TechDepotSetting__c my_data = new TechDepotSetting__c(
            Crypto_Key__c='Sz3oFf2pAWtdogFgIfN5nmQ1Jsz3L3muo/68QJYPKjw=',
            Name='Key'
        );
        insert my_data;
    }
    @isTest()
    static void testClass() {
        User user = getTestUser('System Administrator','aaab@officedepot.com','227112');
        System.runAs(user){
            //Data Setup
            Account account1 = Test_Utils.getTestAccount(user,'123456');
            update account1;
            ApexPages.currentPage().getParameters().put('id',account1.AOPS_Cust_ID__c);
            GPO_Template__c gpoTemp = Test_Utils.createGPOTemplate('Sample Template',false);
            insert gpoTemp;
            GPO_Community_Setup__c gpoCommunitySetup = Test_Utils.createGPOCommunitySetUp(gpoTemp,false);
            gpoCommunitySetUp.defaultRecordType__c = Schema.SObjectType.GPO_Group__c.getRecordTypeInfosByName().get('Enabled GPO Community').getRecordTypeId();
            gpoCommunitySetUp.SPC_Service_URL__c = 'x';
            gpoCommunitySetUp.URL_Insert__c = '/';
            gpoCommunitySetUp.SOA_Connection__c = 'asdf:asdfs';
            gpoCommunitySetUp.SOA_User__c='SVC-SFDCWS:SVC4sfd3';
            gpoCommunitySetUp.Name = 'com2Settings';
            insert gpoCommunitySetUp;
            GPO_Group__c gpoGroup = Test_Utils.createGPOGroup(gpoTemp, account1, false);
            gpoGroup.ExpireLink__c = System.now() + 1;
            gpoGroup.Token__c = 'XYZ';
            gpoGroup.Welcome_Title__c = 'Test GPO Group Title';
            gpoGroup.Community_Name__c = 'test';
            gpoGroup.Community_Image__c = null;
            gpoGroup.RecordTypeId = Schema.SObjectType.GPO_Group__c.getRecordTypeInfosByName().get('Enabled GPO Community').getRecordTypeId();
            gpoGroup.Community_Name__c = 'Default Group';
            insert gpoGroup;

            //End Data Setup
            com2SPCCardController cntrl = new com2SPCCardController();
            cntrl.getSPCNumber(gpogroup.AOPS_Cust_ID__c, gpoGroup.Welcome_Title__c);
            cntrl.getCurrentYear();
            cntrl.check();
        }
    }
    public static User getTestUser(String profileName,String userName,String empId){
        Profile profileObj = [select id from profile where name=: profileName];
        String profId = profileObj.id;
        UserRole ContractDivisionRoleId = [SELECT Id from UserRole WHERE Name = 'Contract Division' limit 1];
        string email = userName;
        string[] name = userName.split('@');
        user u = new user(Username=userName,FirstName =name[1], LastName=name[0], Alias=name[0], CommunityNickname=userName, LocaleSidKey='en_US', EmailEncodingKey='UTF-8',
                          Profileid = profId, LanguageLocaleKey='en_US');
        u.email=email;
        u.MB_Expiration_Date__c = System.now().addminutes(1);
        u.OD_Employee_ID__c =empId;
        u.GT_Employee_ID__c =empId;
        u.IsActive=true;
        u.TimeZoneSidKey='America/Los_Angeles';
        u.Token_Market_Builder__c ='xyz';
        u.UserRoleId = ContractDivisionRoleId.Id;
        u.System_user__c = true;
        u.IsActive = true;
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

}