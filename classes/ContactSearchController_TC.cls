@IsTest(SeeAllData=true)


private class ContactSearchController_TC
{
/**
    static testMethod Void ContactSearchController_TC()
    {
        Profile p = [SELECT Id FROM profile WHERE name='System Administrator'];
         
        User usr = [select id,Username,OD_Employee_ID__C from user where profileid=:p.id and isActive=True and OD_Employee_ID__C!=null limit 1];
       
       System.runAs(usr )
       {
        ContactSearchController insta1 = new ContactSearchController();
        
        ContactSearchController.ContactData insta2 = new ContactSearchController.ContactData();
        
        ContactSearchController.AccountData inst3 = new ContactSearchController.AccountData ();
        insta1.getMyPic();
        insta1.createMyAccount();

        insta1.saveAcct();
         EmailTemplate et = new EmailTemplate();
       
            Folder f = [select id from folder where AccessType='Public' and Type='Email' limit 1];
            System.debug('-------------'+f.id);
            et.name='Test Email template';
            et.DeveloperName='Test_Template';
            et.HtmlValue ='txt';
            et.TemplateType = 'text';
            //et.BrandTemplateId = '';
            et.folderid = f.id;
            et.IsActive=True;
            insert et;  
        insta1.slctedTemplate  = et.id;
         
        insta1.previewET(); 
        
        Apexpages.currentPage().getParameters().put('searchAcctItm','');
        
        insta1.runSearchAcct(); 
        insta1.fileBody  = blob.valueof('Test Data');
        insta1.fileName ='Test file';
        insta1.UploadFile();
        insta1.EditMyEvent();
        insta1.createMyEvent();
        insta1.createMyContact();
        insta1.editmycontact();
        insta1.editMyAcct();
        
        OD_Foundation_User__c fu = new OD_Foundation_User__c();
        fu.user__c = usr.id;
        insert fu;
        
        Map<String,Id> rec_type_map = new Map<String,Id>();
        For (Recordtype r : [SELECT Id, Name from recordtype where name in ('Contact','Account')])
        rec_type_map.put(r.name,r.id);  
        insta1.rec_type_map = rec_type_map;
        od_foundation_contact__c fc = new od_foundation_contact__c();
        
        fc.FirstName__c = 'John';
        fc.Phone__c = '1234567890';
        fc.LastName__c = 'Tacker';
        fc.Email__c = 'johny.tacker@officedepot.com';
        fc.OD_Foundation_User__c= fu.id;
        fc.Accountname__C='Test';
        fc.recordtypeid = '012E000000090g0IAA';
        insta1.ODFusr = fu;
        insert fc;
        ContactSearchController.ContactData cd = new ContactSearchController.ContactData();
       
        Contact con = new Contact();
        con.lastName='Test Contact';
        con.Email='test23@officedepot.com';
        //insert con;
        cd.contactid = con.id;
        //cd.email = 'test23@officedepot.com';
        cd.firstName='Test';
        cd.lastName ='Test';
        cd.accountName='Test Account';
        cd.isCntSelected =true;
        cd.foundationContactId = fc.id;
        insta1.slctedTemplate = et.id;
        insta1.dataContacts.add(cd);
        insta1.sendmail(); 
        insta1.preview() ;
        insta1.associate() ;
        insta1.toggleSort();
        insta1.sendAdminMail();
        insta1.runQuery() ;
        insta1.addToList();
       
        od_foundation_contact__c fc1 = new od_foundation_contact__c();
        
        fc1.FirstName__c = 'John';
        fc1.Phone__c = '1234567890';
        fc1.LastName__c = 'Tacker';
        fc1.Email__c = 'johny.tacker@officedepot.com';
        fc1.OD_Foundation_User__c= fu.id;
        fc1.Accountname__C='Test';

        insert fc1;
        insta1.odf_acct = fc1;
        ApexPages.currentPage().getParameters().put('acctid',fc.id);
        insta1.DelMyAcct();
        //insta1.saveAcct();
         ApexPages.currentPage().getParameters().put('contactid',fc1.id);
        insta1.DelMyContact();
        
        insta1.odf_contact = fc;
       
        OD_Foundation_User_Preferences__c fe = new OD_Foundation_User_Preferences__c();
        fe.user__c = UserInfo.getUserId();
        fe.Event_Type__c='Bass Fishing';
        insert fe;
        ApexPages.currentPage().getParameters().put('eventid',fe.id);
        ApexPages.currentPage().getParameters().put('id',fe.id);
        insta1.save();
        insta1.DelMyEvent();
        insta1.savePref();
        insta1.event_change_listener();  
        insta1.toggleSort();
        insta1.sendAdminMail();
        insta1.distconts.add(fc);
        insta1.distaccts.add(fc);
        insta1.addToList();
        insta1.addAcctToList();
        insta1.userSetup();
        Apexpages.currentPage().getParameters().put('searchItm','');
        Apexpages.currentPage().getParameters().put('srch','');
        insta1.runSearch();
        ApexPages.currentPage().getparameters().put('createMode','from test class');
        ContactSearchController insta4 = new ContactSearchController();
        ContactSearchController.toDelIdent =1;
        ContactSearchController.addCount =2;
        OD_Foundation_User_Preferences__c fe1 = new OD_Foundation_User_Preferences__c();
        fe1.Event_Type__c='Bass Fishing';
        insert fe1;
        ContactSearchController insta11 = new ContactSearchController();
        fe1.Event_Type__c='Cooking';
        update fe1;
        ContactSearchController insta5 = new ContactSearchController();
        fe1.Event_Type__c='Deep Sea Fishing';
        update fe1;
       
        List<ContactSearchController.ContactData> conData = insta5.Contacts;
        insta5.Contacts=conData ;
         List<ContactSearchController.AccountData> accData = insta5.accts;
        insta5.accts=accData ;
        String sfield = insta5.sortField;
        List<SelectOption> selOptns = insta5.TemplateList;
      
        
        
        }
        
        }
        
        static testMethod Void ContactSearchController_TC1()
    {
        Profile p = [SELECT Id FROM profile WHERE name='System Administrator'];
         
        User usr = [select id,Username,OD_Employee_ID__C from user where profileid=:p.id and isActive=True and OD_Employee_ID__C!=null limit 1];
       
       System.runAs(usr )
       {
        ContactSearchController insta1 = new ContactSearchController();
        
        ContactSearchController.ContactData insta2 = new ContactSearchController.ContactData();
        
        ContactSearchController.AccountData inst3 = new ContactSearchController.AccountData ();
        insta1.getMyPic();
        insta1.createMyAccount();

        insta1.saveAcct();
         EmailTemplate et = new EmailTemplate();
       
            Folder f = [select id from folder where AccessType='Public' and Type='Email' limit 1];
            System.debug('-------------'+f.id);
            et.name='Test Email template';
            et.DeveloperName='Test_Template';
            et.HtmlValue ='txt';
            et.TemplateType = 'text';
            //et.BrandTemplateId = '';
            et.folderid = f.id;
            et.IsActive=True;
            insert et;  
        insta1.slctedTemplate  = et.id;
         
        insta1.previewET(); 
        
        ContactSearchController.ContactData cd = new ContactSearchController.ContactData();
       
        Contact con = new Contact();
        con.lastName='Test Contact';
        con.Email='test@officedepot.com';
        //insert con;
        cd.contactid = con.id;
        //cd.Email = 'test@officedepot.com';
        cd.firstName='Test';
        cd.lastName ='Test';
        cd.accountName='Test Account';
        cd.isCntSelected =true;
        insta1.slctedTemplate = et.id;
        //insta1.dataContacts.add(cd);
        insta1.sendmail(); 
        insta1.preview() ;
        insta1.associate() ;
        insta1.toggleSort();
        insta1.sendAdminMail();
        insta1.runQuery() ;
        insta1.addToList();
        
        Apexpages.currentPage().getParameters().put('searchAcctItm','');
        
        insta1.runSearchAcct(); 
        insta1.fileBody  = blob.valueof('Test Data');
        //insta1.fileName ='Test file';
        insta1.UploadFile();
        insta1.EditMyEvent();
        insta1.createMyEvent();
        insta1.createMyContact();
        insta1.editmycontact();
        insta1.editMyAcct();
        
        /*OD_Foundation_User__c fu = new OD_Foundation_User__c();
        fu.user__c = usr.id;
        insert fu;
        *//*
        Map<String,Id> rec_type_map = new Map<String,Id>();
        For (Recordtype r : [SELECT Id, Name from recordtype where name in ('Contact','Account')])
        rec_type_map.put(r.name,r.id);  
        */
       /* od_foundation_contact__c fc = new od_foundation_contact__c();
        
        fc.FirstName__c = 'John';
        fc.Phone__c = '1234567890';
        fc.LastName__c = 'Tacker';
        fc.Email__c = 'johny.tacker@officedepot.com';
        fc.OD_Foundation_User__c= fu.id;
        fc.Accountname__C='Test';

        insert fc;
        insta1.odf_contact = fc;
        insta1.odf_acct = fc;
        
        ApexPages.currentPage().getParameters().put('contactid',fc.id);
        //insta1.saveAcct();
        insta1.DelMyContact();
        ApexPages.currentPage().getParameters().put('acctid',fc.id);
        //insta1.DelMyAcct();*/
        /*
        OD_Foundation_User_Preferences__c fe = new OD_Foundation_User_Preferences__c();
        fe.Event_Type__c='Bass Fishing';
        insert fe;
        ApexPages.currentPage().getParameters().put('eventid',fe.id);
        insta1.save();
        insta1.DelMyEvent();
        insta1.savePref();
        insta1.event_change_listener();  
        insta1.toggleSort();
        insta1.sendAdminMail();
        //insta1.distconts.add(fc);
        //insta1.distaccts.add(fc);
        insta1.addToList();
        insta1.addAcctToList();
        insta1.userSetup();
        Apexpages.currentPage().getParameters().put('searchItm','');
        Apexpages.currentPage().getParameters().put('srch','');
        insta1.runSearch();
        ApexPages.currentPage().getparameters().put('createMode','from test class');
        ContactSearchController insta4 = new ContactSearchController();
        ContactSearchController.toDelIdent =1;
        ContactSearchController.addCount =2;
        OD_Foundation_User_Preferences__c fe1 = new OD_Foundation_User_Preferences__c();
        fe1.Event_Type__c='Bass Fishing';
        insert fe1;
        ContactSearchController insta11 = new ContactSearchController();
        fe1.Event_Type__c='Cooking';
        update fe1;
        ContactSearchController insta5 = new ContactSearchController();
        fe1.Event_Type__c='Deep Sea Fishing';
        update fe1;
       
        List<ContactSearchController.ContactData> conData = insta5.Contacts;
        insta5.Contacts=conData ;
         List<ContactSearchController.AccountData> accData = insta5.accts;
        insta5.accts=accData ;
        String sfield = insta5.sortField;
        List<SelectOption> selOptns = insta5.TemplateList;
        soapOdfoundationContactWS.LogInfo  ws1 = new soapOdfoundationContactWS.LogInfo ();
        soapOdfoundationContactWS.AllowFieldTruncationHeader_element ws2 = new  soapOdfoundationContactWS.AllowFieldTruncationHeader_element();
        soapOdfoundationContactWS.DebuggingHeader_element ws3 = new soapOdfoundationContactWS.DebuggingHeader_element();
        soapOdfoundationContactWS.CallOptions_element ws4 = new soapOdfoundationContactWS.CallOptions_element();
        soapOdfoundationContactWS.DebuggingInfo_element ws5 = new soapOdfoundationContactWS.DebuggingInfo_element();
        
        }
        
        }
        */
}