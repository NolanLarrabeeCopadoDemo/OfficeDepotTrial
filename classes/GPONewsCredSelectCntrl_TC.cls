/**********************************************************

Class Name : GPONewsCredSelectCntrl_TC
Created Date : May 21st, 2015
Created By : Mohit Batwada
Purpoae : Test Class for GPONewsCredSelectCntrl

***********************************************************/
@isTest
private class GPONewsCredSelectCntrl_TC {


    static testMethod void testGPONewsCredSelct() {

        //User user = Test_Utils.getTestUser('System Administrator','aaa@officedepot.com','227112');

        //Account account = Test_Utils.getTestAccount(user,'123456');

         //accOtherId for example 123654
         Account account = new Account ();
         account.name = 'SUN';
        //acc.BillingStreet = '1040 N 326 W';
        account.OMX_Primary_Key__c = '123456';
        //acc.billingcity = 'Orem';
        //acc.BillingState = 'UT';
        //acc.Billingcountry = 'USA';
        account.Oracle_Party_Id__c = '123456' ;
        account.AOPS_Cust_Id__c = '123456' ;
        account.AOPS_Seq_ID__c = '123456' ;
        //acc.OwnerID = u.id;// This is the salesforce User ID
        account.Address1__c = 'address';

        insert account;

        Contact contact = new Contact(LastName = 'TEST',AccountId = account.Id);
        contact.MailingCountry = 'US';
        contact.GPO_Community__c =account.Id;
        insert contact;

        string email = 'aaa@officedepot.com';
        String profileName = 'Customer Community Login User - GPO User';
        String empId = '227112';
        Profile profileObj = [select id from profile where name=: profileName];
        String profId = profileObj.id;
        string[] name = email.split('@');

        user user = new user(Username=email,FirstName =name[1], LastName=name[0], Alias=name[0], CommunityNickname=email, LocaleSidKey='en_US', EmailEncodingKey='UTF-8', Profileid = profId, LanguageLocaleKey='en_US');
        user.email=email;
        user.MB_Expiration_Date__c = System.now().addminutes(1);
        user.OD_Employee_ID__c =empId;
        user.GT_Employee_ID__c =empId;
        user.IsActive=true;
        user.contactId = contact.id;
        user.TimeZoneSidKey='America/Los_Angeles';
        user.Token_Market_Builder__c ='xyz';
        //user.IsPortalEnabled=true;

        insert user;

         //user.contactid = contact.id;
         //update user;

        GPO_Template__c gpoTemp = Test_Utils.createGPOTemplate('Sample Template',true);

         //Modified for Story S-371041
            GPO_Community_Setup__c gpoCommunitySetup = Test_Utils.createGPOCommunitySetUp(gpoTemp,false);
            insert gpoCommunitySetup ;
         //end S-371041

          GPO_Community_Setup__c gpoCommunitySetUp1 = new GPO_Community_Setup__c();
            gpoCommunitySetUp1.Name = 'com2Settings';
            gpoCommunitySetup1.signin_link__c = 'https://oduat-officedepotcorp.cs78.force.com/gpo/GPOMember';
            insert gpoCommunitySetup1;
        
        GPO_Group__c gpoGroup = Test_Utils.createGPOGroup(gpoTemp, account, false);
            gpoGroup.Welcome_Title__c = 'Test GPO Group Title';
            Recordtype rg = [select id from recordtype where sobjecttype='GPO_Group__c' and name = 'Template Default'];
            gpoGroup.RecordTypeId = rg.id;
           gpoGroup.Community_Name__c = 'Default Group';
        insert gpoGroup;
 
         Attachment attach=new Attachment();
            attach.Name='Unit Test Attachment';
            Blob bodyBlob=Blob.valueOf('Unit Test Attachment Body');
            attach.body=bodyBlob;
            attach.parentId=gpoGroup.id;
            insert attach;

         gpoGroup.Community_Image__c = attach.Id;
         update gpoGroup;
         //GPO_Group__c gpoGroupData = [select id, name from GPO_Group__c where name = 'Default Group' limit 1];
         
      try{
         GPO_Group__c gpoGroupData = [select id, name from GPO_Group__c where Id =: gpoGroup.Id limit 1];

        GPO_Group_Detail__c gpoGrpDetail = Test_Utils.createGPOGroupDetail(gpoGroupData,'Test Detail', false);
            gpoGrpDetail.Type__c = 'NEWSCRED';
            gpoGrpDetail.Value1__c = 'qwerty123';
            gpoGrpDetail.Value2__c = '1';
        insert gpoGrpDetail;
            
                GPONewsCredSelectCntrl gpoNewsCred = new GPONewsCredSelectCntrl();
                gpoNewsCred.preNewsCredHdrs = null;
                gpoNewsCred.postNewsCredHdrs = null;
            }
            catch(exception ex){}

    }
}