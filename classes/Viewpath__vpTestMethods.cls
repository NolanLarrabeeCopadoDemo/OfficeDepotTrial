@isTest
private without sharing class vpTestMethods {
    // IDSI.DG.01.14.2014 - This test method moved here to comply with Salesforce requirements test code deployment
    // changes in 2013 (API version 28.0 requires test code to be in their own class
    // Apex code saved using earlier versions isn't affected
    public static testMethod void testVP_Project_Extension(){
        test.startTest();
        system.debug(' TEST> testVP_Project_Extension begins:');
        
        // Set the static variable IsApexTestMode, required to prevent API calls in tests, must do before any of the Extension controllers are created.
        VP_Utils.IsApexTestMode = true; 
                
        PageReference pageRef = Page.VP_Project_Edit;
        VP_Project.isApexTestStatic = true;
        VP_Project__c proj = new VP_Project__c();    

        proj.ProjectId__c = 'New_Test_Project';
        proj.Name = 'New_Test_Project';
        
        system.debug(' TEST> about to create VP_Project_Extension');
        ApexPages.StandardController sc = new ApexPages.StandardController(proj);        
        VP_Project_Extension ce = new VP_Project_Extension(sc);
        ce.isApexTest = false;
        
        // test for No Access 
        ce.AccessLevel = -1;        
        string txtNone = ce.AccessLevelText;        
        system.assertEquals('have no access to', txtNone.Trim());               // idsi.dg


        ce.AccessLevel = 0;
        //system.debug(' Test> Access Level = ' + ce.AccessLevel);
        string txtGuest = ce.AccessLevelText;        
        system.assertEquals('are a guest on', txtGuest.Trim());               // idsi.dg

        //system.assertEquals('are a guest on', txtGuest);
        
        ce.AccessLevel = 1;
        string txtObserver = ce.AccessLevelText;        
        system.assertEquals('are an observer on', txtObserver.Trim());            // idsi.dg

        ce.AccessLevel = 2;
        string txtEditor = ce.AccessLevelText;        
        system.assertEquals('are an editor on', txtEditor.Trim());              // idsi.dg

        ce.AccessLevel = 2.5;
        string txtManager = ce.AccessLevelText;        
        system.assertEquals('are a manager on', txtManager.Trim());             // idsi.dg

        ce.AccessLevel = 3;
        string txtOwner = ce.AccessLevelText;        
        system.assertEquals('are an owner on', txtOwner.Trim());               // idsi.dg
        
        string cblabel = ce.ChatterButtonLabel;        
        system.assertEquals('Enable Chatter Notifications', cblabel.Trim());    // idsi.dg
        
        string apiurl = ce.getLocalAPIUrl();        
        system.assertEquals('/apex/viewpath__vp_sfapi', apiurl.Trim());         // idsi.dg

        string vpapiurl = ce.getViewpathAPIUrl();        
        system.assertEquals('/apex/viewpath__vp3api', vpapiurl.Trim());         // idsi.dg
        
        string launchurl = ce.getViewpathLaunchAppUrl();        
        system.assertEquals('/apex/viewpath__vp_launch_application', launchurl.Trim());         // idsi.dg

        string followbtnlabel = ce.displayFollowButton;        
        system.assertEquals('none', followbtnlabel.Trim());                     // idsi.dg

        string unfollowbtnlabel = ce.displayUnfollowButton;
        system.assertEquals('none', unfollowbtnlabel.Trim());                   // idsi.dg
        
        test.stopTest();
        system.debug('TEST> testVP_Project_Extension ends');
    }



    public static testMethod void testProjectTriggers(){
        test.startTest();                                                       // idsi.dg
    
        boolean trig;
        VP_Trigger_Validator.SetTriggerExecuted();
        System.assert(true,VP_Trigger_Validator.HasTriggerExecuted());
        VP_Trigger_Validator.ResetTriggerExecuted();
        trig = VP_Trigger_Validator.HasTriggerExecuted();    

        VP_Project.isApexTestStatic = true;
        VP_Project__c p = new VP_Project__c();
        p.Name = 'Test Project';

        insert(p);
        
        VP_Project__c np = [SELECT Name from VP_Project__c WHERE Id = :p.Id]; 

        // idsi.dg - regardless what is returned on the SOQL test, we get a call on an
        // assert
        System.assertNotEquals(null, np);                                       // idsi.dg
        
        if (np != null) {
            System.assertEquals(p.Name, np.name);
            System.assertEquals(p.ProjectId__c, null);
        
            np.ProjectId__c = '100.1.1';
            //VP_Trigger_Validator.ResetTriggerExecuted();
            
            
            update(np);
            
            
            VP_Project__c np_new;
            np_new = [SELECT Name, ProjectId__c from VP_Project__c WHERE Id = :np.Id]; 
          
            if (np_new != null) {
                System.assertEquals(np.ProjectId__c, np_new.ProjectId__c);
            }
        }
        delete(p);



        test.stopTest();                                                            // idsi.dg
    }
   
  /* Moved to VP_Project_List_Extensions.cls on 3/4/13
    
    public static testMethod void testVPProjectListExtension(){
        VP_Project__c p1 = new VP_Project__c();
        VP_Project__c p2 = new VP_Project__c();
        VP_Project__c p3 = new VP_Project__c();
        
        p1.Name = 'p1';
        p2.Name = 'p2';
        p3.Name = 'p3';
    
        VP_Project__c[] projects = new List<VP_Project__c>();
        
        projects.add(p1);
        projects.add(p2);
        projects.add(p3);

        insert(projects);
        
        //projects = [SELECT Id, Name, ProjectId__c FROM VP_Project__c];
        PageReference pageRef = Page.VP_Project_List;
        Test.setCurrentPage(pageRef);
        
        //Open Custom Controller
        ApexPages.StandardSetController sc = new ApexPages.StandardSetController(projects);
        VP_Project_List_Extension ce = new VP_Project_List_Extension(sc);
        system.assert(projects.size() > 0, 'No Projects Found');
    }
*/

  /* Moved to VP_Web_Services_Configure.cls on 3/8/13
  
    public static testMethod void testConfigWSDL(){
        VP_Web_Services_Configure.ConfigureSoap conf = new VP_Web_Services_Configure.ConfigureSoap();
        conf.isApexTest = true;
        
        VP_Web_Services_Configure.AuthHeader ah = new VP_Web_Services_Configure.AuthHeader();
        ah.devKey = 'devKey';
        conf.AuthHeader = ah;
        conf.ActivateAccount('devKey','organizationId','organizationName','organizationCountry','adminName','adminEmail','adminPhone');
        
        //VP_Configuration__c[] config = [SELECT apiKey__c FROM VP_Configuration__c LIMIT 1];
        VP_Configuration__c config = VP_Utils.getVPConfig();
        //system.Assert(config != null, 'Config object not created');

        conf.DeactivateAccount();
        conf.UpdateAccount();
        
        
        VP_Web_Services_Configure.OrgConfig orgConfig = conf.GetOrgConfig();
        orgConfig = conf.UpdateOrgConfig(orgConfig);
    }

*/

/*  Moved to VP_Web_Services_API.cls on 3/11/13

    public static testMethod void testWSDL(){
    
    
        VP_Web_Services_API vp3 = new VP_Web_Services_API();
        VP_Web_Services_API.GetGuidPrefix_element gg_el = new VP_Web_Services_API.GetGuidPrefix_element();
        VP_Web_Services_API.GetGuidPrefixResponse_element ggr_el = new VP_Web_Services_API.GetGuidPrefixResponse_element();
        VP_Web_Services_API.AddResource_element ar_el = new VP_Web_Services_API.AddResource_element();
        VP_Web_Services_API.GetResourcesResponse_element grr_el = new VP_Web_Services_API.GetResourcesResponse_element();
        VP_Web_Services_API.CreateTask_element ct_el = new VP_Web_Services_API.CreateTask_element();
        VP_Web_Services_API.GetProjects_element gp_el = new VP_Web_Services_API.GetProjects_element();
        VP_Web_Services_API.GetTasks_element gt_el = new VP_Web_Services_API.GetTasks_element();
        VP_Web_Services_API.GetProjectsResponse_element gpr_el = new VP_Web_Services_API.GetProjectsResponse_element();
        VP_Web_Services_API.CreateTaskResponse_element ctr_el = new VP_Web_Services_API.CreateTaskResponse_element();
        VP_Web_Services_API.GetResources_element gr_el = new VP_Web_Services_API.GetResources_element();
        VP_Web_Services_API.CreateProject_element cp_el = new VP_Web_Services_API.CreateProject_element();
        VP_Web_Services_API.AddResourceResponse_element arr_el = new VP_Web_Services_API.AddResourceResponse_element();
        VP_Web_Services_API.GetTasksResponse_element gtr_el = new VP_Web_Services_API.GetTasksResponse_element();
        VP_Web_Services_API.CreateProjectResponse_element cpr_el = new VP_Web_Services_API.CreateProjectResponse_element();
        
        
        VP_Web_Services_API.VP31Soap stub = new VP_Web_Services_API.VP31Soap();
        system.assert(stub != null, 'Stub is null');
        stub.isApexTest = true;
        
        
        string addResource = stub.addResource('email@email.com','123.3456.2345','Name','resemail@email.com',20,'Comments');
        string addResources = stub.addResources('email@email.com','{json}','PROJECTID');        
        string getGuidPrefix = stub.GetGuidPrefix('email@email.com');
        string updateProject = stub.updateProject('email@email.com','project name', 'create','');
        string createProject = stub.createProject('email@email.com','project name', 'create', 'project');
        string deleteProject = stub.deleteProject('','');
        string getProjects = stub.getProjects('email@email.com');
        string getResources = stub.getResources('email@email.com','123.234.234');
        string createTask = stub.createTask('email@email.com','projectId','taskName','taskAssignedTo','taskParent',20,true);
        string getTasks = stub.getTasks('email@email.com','123.234.234');
        string updateTask = stub.updateTask('email@email.com', 'id','name', 20, 'start', 'edn', 0, 'stuff');
    }
*/
    
  /* Moved to VP_Utils.cls on 3/8/13    
    public static testMethod void testLaunchApplication(){
        VP_Launch_Application la = new VP_Launch_Application();
        PageReference p = la.RedirectToApp();
        System.Assert(p!=null);
    }
    
    public static testMethod void testViewpathConfigure(){
        PageReference p = Page.VP_Configuration;
        Test.setCurrentPage(p);
        
        VP_Configuration vpc = new VP_Configuration();
        vpc.isApexTest = true;
        
        vpc.OrganizationId = '123456';
        vpc.OrganizationName = 'TestOrg';
        vpc.OrganizationCountry = 'US';
        vpc.AdministratorName = 'Admin Name';
        vpc.AdministratorEmail = 'Admin@email.com';
        vpc.AdministratorPhone = '253-632-7823';
        
        vpc.Activate();
        vpc.Deactivate();
        
        vpc.UpdateOrgConfig();
        vpc.GetRemoteConfig();
        
        vpc.getChatterOptions_Destination();
        vpc.getChatterOptions_Enabled();
        
        //system.Assert(config.size() > 0, 'Config object not created');

        system.Assert(p != null);
    }
   
    public static testMethod void testVP_Utils() {
        String email = VP_Utils.GetEmail();
        Organization org = VP_Utils.GetOrganization();
        String phone = VP_Utils.GetPhone();
        
        boolean isAccountActivated = VP_Utils.IsAccountActivated();
        boolean isAdmin = VP_Utils.IsCurrentUserSysAdmin();
        
        VP_Configuration__c config = VP_Utils.getVPConfig();
        
        User currentUser = VP_Utils.getCurrentUser();
        
        string sfEncryptString = VP_Utils.getSFEncryptionKey();
        blob encryptedString = VP_Utils.encrypt(sfEncryptString, 'TEST');
        string decryptedString = VP_Utils.decrypt(sfEncryptString, encryptedString);
        system.assert('TEST' == decryptedString);
        
        string encDevKey = VP_Utils.getEncryptedDevKey();
        
        system.assert(isAdmin != null);
        system.assert(email != null);
        system.assert(org != null);
    }
     
 */
 
 
/* Moved to VP_Project_New_Extension.cls on 2/8/13

    public static testMethod void testVP_Project_New_Extension(){
        VP_Project.isApexTestStatic = true;
        VP_Project__c proj = new VP_Project__c();    

        proj.ProjectId__c = 'New_Test_Project';
        proj.Name = 'New_Test_Project';
        
         Account acc = new Account();
        acc.Name = 'New Account';
        insert(acc);
        
        Opportunity opp = new Opportunity();
        opp.Name = 'New Opp';
        opp.StageName = 'New Stage Name';
        opp.CloseDate = Date.Today();
        insert(opp);
        
        insert(proj);
        proj = [SELECT Name, Id, ProjectId__c, ChatterGroupId__c, ChatterEnabled__c, Owner.Id, Owner.Name FROM VP_Project__c WHERE Id = :proj.Id];
        
        system.assertEquals(proj.Name, 'New_Test_Project');
        
        PageReference pageRef = Page.VP_Project_New;
        Test.setCurrentPage(pageRef);

        ApexPages.StandardController sc = new ApexPages.StandardController(proj);
        VP_Project_New_Extension nce = new VP_Project_New_Extension(sc);
        nce.IsApexTest = true;
       
       //Test Opportunity Referer     
        ApexPages.currentPage().getParameters().put('CF00NA0000000l3I6_lkid', opp.Id);//try with '001' as well
        ApexPages.currentPage().getParameters().put('CF00NA0000000l3I6', opp.Name);
        ApexPages.currentPage().getParameters().put('retUrl', '/'+opp.Id);
        nce.save();                               
        
        
        nce = new VP_Project_New_Extension(sc);
        nce.IsApexTest = true;
        //Test Account Referer
        ApexPages.currentPage().getParameters().put('CF00NA0000000l3I6_lkid', acc.Id);//try with '001' as well
        ApexPages.currentPage().getParameters().put('CF00NA0000000l3I6', acc.Name);
        ApexPages.currentPage().getParameters().put('retUrl', '/'+acc.Id);
        // Open Custom Controller
        nce.save();
                      
        nce = new VP_Project_New_Extension(sc);   
        nce.IsApexTest = true;           
        nce.setMode('CONNECT');
        nce.save();

        nce = new VP_Project_New_Extension(sc);
        nce.IsApexTest = true;
        nce.setMode('NEW');
        nce.save();
        
        //Test No Return URL
        ApexPages.currentPage().getParameters().put('retUrl',null);
        nce.save();
    }
*/

/* Moved to VP_Project_New_Extension.cls on 3/8/13

    public static testMethod void testVP_Project_Extension(){
        PageReference pageRef = Page.VP_Project_Edit;
        VP_Project.isApexTestStatic = true;
        VP_Project__c proj = new VP_Project__c();    

        proj.ProjectId__c = 'New_Test_Project';
        proj.Name = 'New_Test_Project';
        
        ApexPages.StandardController sc = new ApexPages.StandardController(proj);        
        VP_Project_Extension ce = new VP_Project_Extension(sc);
        ce.isApexTest = false;
    }
 */   

/*  Moved to VP3Interface.cls on 3/11/13
    
    public static testMethod void testVP3Interface_ChatterGroups(){
        VP_Project.isApexTestStatic = true;
        PageReference pageRef = Page.vp3API;
        Test.setCurrentPage(pageRef);
        
        //Instantiate and construct the controller class.   
        VP3Interface controller = new VP3Interface();
        controller.isApexTest = true;
        controller.ExecuteDML();
        
        CollaborationGroup cg = new CollaborationGroup();
        cg.Name = 'ChatterTestGroup1532634_20';
        cg.Description = 'Test Description';
        cg.CollaborationType = 'Public';
        insert(cg);
        
        VP_Project__c proj = new VP_Project__c();
        proj.ProjectId__c = '100.100.100';
        proj.Name = 'Test Project';
        proj.ChatterEnabled__c = true;
        insert(proj);

        //Test SelectChatterGroup
        ApexPages.currentPage().getParameters().put('method', 'selectChatterGroup');
        ApexPages.currentPage().getParameters().put('ProjectId', proj.ProjectId__c);
        ApexPages.currentPage().getParameters().put('GroupId', cg.Id);
        controller.ExecuteDML();
        
        proj = Controller.GetProject(proj.projectId__c);
        System.AssertEquals(cg.Id, proj.ChatterGroupId__c);
        
        
        //Test GetChatterGroups
        ApexPages.currentPage().getParameters().put('method', 'getChatterGroups');
        controller.ExecuteDML();
        System.Assert(controller.jsonOutput != '{"message":"EMPTY"}');
        
        //Test GetTasks
        ApexPages.currentPage().getParameters().put('method', 'getTasks');
        controller.ExecuteDML();
        
        //Test GetResources
        ApexPages.currentPage().getParameters().put('method', 'getResources');
        controller.ExecuteDML();
        
        //Test AddResources
        ApexPages.currentPage().getParameters().put('method', 'addResources');
        controller.ExecuteDML();
       
        //Test GetSFUsers
        ApexPages.currentPage().getParameters().put('method', 'getSFUsers');
        controller.ExecuteDML();
        
        //Test GetTips
        ApexPages.currentPage().getParameters().put('method', 'GetTips');
        controller.ExecuteDML();

        //Test EnableProjectNotifications
        ApexPages.currentPage().getParameters().put('method', 'EnableProjectNotifications');
        controller.ExecuteDML();        
        
        //Test DisableProjectNotifications
        ApexPages.currentPage().getParameters().put('method', 'DisableProjectNotifications');
        controller.ExecuteDML();        
        
        //Test UpdateTask
        ApexPages.currentPage().getParameters().put('method', 'updateTask');
        ApexPages.currentPage().getParameters().put('taskId', '100.100.10');
        ApexPages.currentPage().getParameters().put('taskName', 'TaskName');
        ApexPages.currentPage().getParameters().put('taskComplete', '100');
        controller.ExecuteDML();

        ApexPages.currentPage().getParameters().put('taskComplete', null);
        controller.ExecuteDML();
    }
*/

/* Moved to VP_Project_New_Extension.cls on 3/8/13
     
    public static testMethod void testResource(){
        VP_Resource r = new VP_Resource();
        
        r.Email = 'test@email.com';
        r.Name = 'Test Name';
        r.ProjectId = 'testProjectId';
        r.Id = 'testId';
        
        system.AssertEquals(r.Email,'test@email.com');
        system.AssertEquals(r.Name,'Test Name');
        system.AssertEquals(r.ProjectId,'testProjectId');
        system.AssertEquals(r.Id,'testId');                       
    
    }

    public static testMethod void testTask(){
        VP_Task t = new VP_Task();   
        
        system.assert(t != null);
    }

    
    public static testMethod void testVP_Project(){
        VP_Project.isApexTestStatic = true;
        VP_Project__c proj = new VP_Project__c();

        proj.name = 'New Test Project';

        insert(proj);
        
        proj.ProjectId__c = '123456';

        update(proj);

        VP_Project__c p = [SELECT Name FROM VP_Project__c WHERE Id = :proj.id];

        System.AssertEquals(p.name, proj.name);
    }

    
    public static testMethod void testVP_LocalApi() {
       
       //Use the PageReference Apex class to instantiate a page
       PageReference pageRef = Page.VP_SFAPI;
       
       //In this case, the Visualforce page named 'success' is the starting point of this test method. 
       Test.setCurrentPage(pageRef);
       ApexPages.currentPage().getParameters().put('method', 'GetTips');

       //Instantiate and construct the controller class.   
       VP_LocalAPI controller = new VP_LocalAPI();
       controller.setApexTest();
       controller.ExecuteDML();
       system.debug('Get tips::' + controller.JSON);       
     
       ApexPages.currentPage().getParameters().put('method', 'GetProject');
       ApexPages.currentPage().getParameters().put('ProjectId', '99001.626.0');
     
       //Instantiate and construct the controller class.   
       controller = new VP_LocalAPI();
       controller.setApexTest();
       controller.ExecuteDML();
       system.debug('Get project::' + controller.JSON);

       ApexPages.currentPage().getParameters().put('method', 'UpdateProject');
       ApexPages.currentPage().getParameters().put('ProjectId', '99001.626.0');
       ApexPages.currentPage().getParameters().put('ProjectName', 'Proj Name');
     
       //Instantiate and construct the controller class.   
       controller = new VP_LocalAPI();
       controller.setApexTest();
       controller.ExecuteDML();
       system.debug('Update project::' + controller.JSON);
       

       //Example of calling an Action method. Same as calling any other Apex method. 
       //Normally this is executed by a user clicking a button or a link from the Visualforce
       //page, but in the test method, just test the action method the same as any 
       //other method by calling it directly. 

       //The .getURL will return the page url the Save() method returns.
       //String nextPage = controller.save().getUrl();

       //Check that the save() method returns the proper URL.
       //System.assertEquals('/apex/failure?error=noParam', nextPage);

       //Add parameters to page URL
       //ApexPages.currentPage().getParameters().put('qp', 'yyyy');
     
       //Instantiate a new controller with all parameters in the page
       //controller = new thecontroller(); 

       //Example of calling the 'setter' method for several properties. 
       //Normally these setter methods are initiated by a user interacting with the Visualforce page, 
       //but in a test method, just call the setter method directly. 
       //controller.setLastName('lastname');
       //controller.setFirstName('firstname');
       //controller.setCompany('acme');
       //controller.setEmail('firstlast@acme.com');
       //nextPage = controller.save().getUrl();

       //Verify that the success page displays
       //System.assertEquals('/apex/success', nextPage);
       
   }

*/


    
    
}