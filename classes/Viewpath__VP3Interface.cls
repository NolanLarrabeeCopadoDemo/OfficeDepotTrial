public with sharing class VP3Interface {

    /////////////////////////////////
    //Test Provisions
    public Boolean isApexTest = false;
    public String currentTestMethod;
    /////////////////////////////////
    
    public VP_Web_Services_API.VP31Soap Stub;
    public String jsonOutput {get; set;}

    public String ProjectId;
    public String Method;
    Map<string,string> Params;
    
    public void ExecuteDml(){
        string jsonString;
        Params = ApexPages.currentPage().getParameters();
        ProjectId = Params.get('ProjectId');       
        Method = Params.get('Method');
      
        Stub = new VP_Web_Services_API.VP31Soap();
        Stub.isApexTest = isApexTest;

        if (Method == 'getTasks') {
            jsonString = Stub.getTasks(VP_Utils.GetEmail(), ProjectId);
        } else if (Method == 'getAssignedTasks') {
            jsonString = GetAssignedTasks();
        } else if (Method == 'getProjects') {
            jsonString = stub.getProjects(VP_Utils.GetEmail());
        } else if (Method == 'getResources') {
            jsonString = GetResources();
        } else if (Method == 'getSFUsers') {
            jsonString = getSFUsers();   
        } else if (Method == 'getSFProjects') {
            jsonString = getSFProjects();
        } else if (method == 'getAccountContacts') {
            jsonString = getAccountContacts();            
        } else if (method == 'getContacts') {
            jsonString = getContacts();
        } else if (Method == 'getChatterGroups') {
            jsonString = getChatterGroups();   
        }  else if (Method == 'addResources') {
            jsonString = AddResources();
        } else if (Method== 'updateTask'){
            jsonString = UpdateTask();
        } else if (Method== 'GetTips') {     
            jsonString = GetTips();        
        } else if (Method== 'EnableProjectNotifications') {
            jsonString = SetProjectNotifications(ProjectId, true);
        } else if (Method== 'DisableProjectNotifications'){
            jsonString = SetProjectNotifications(ProjectId, false);        
        } else if (Method== 'SelectChatterGroup'){
            jsonString = SelectChatterGroup(Params.get('groupId'), ProjectId);
        } else {
            jsonString = '';
        }
        
        //testMethod provisions embedded in logic
        if (jsonString == '' || jsonString == null) { 
            jsonString = '{"message":"EMPTY"}';
            this.jsonOutput = jsonString; return;
        }
        
        this.jsonOutput = '(' + jsonString + ')';
        return;
    }
    
    
    public String GetSFProjects(){   
        List<VP_Project__c> projectList = new List<VP_Project__c>();
               
        for(VP_Project__c proj : [select Id, Name, ProjectId__c from VP_Project__c LIMIT 500]){ //TODO: Install a realistic limit here
                projectList.add(proj);
        }
        
        return JSON.serialize(projectList);
    }
    
    public String GetAccountContacts(){
        Id accountId = params.get('accId');

        List<contact> contactList = new List<contact>();
        string json;
               
        for(Contact c : [select Id, Name, Email, Account.Name from Contact WHERE AccountId = :accountId AND Email != null LIMIT 500]){ //TODO: Install a realistic limit here
                contactList.add(c);
        }
        
        integer total = contactList.size();
        json = '{total:' + total + ', values:[';
        
        for(Contact c : contactList) {
            json += '{Id:' + writeVal(c.Id) + ',';
            json += 'Name:' + writeVal(c.Name) + ',';
            json += 'Email:' + writeVal(c.Email) + ',';
            json += 'AccountName:' + writeVal(c.Account.Name) + '},';
        }

        if (total >0) json = json.substring(0, (json.length()-1)); //Remove trailing comma
        json += ']}'; //close json string
        return json;
    }
    
    public String GetContacts(){
        List<contact> contactList = new List<contact>();
        string json;
        
        for(Contact c : [select Id, Name, Email from Contact WHERE Email != null LIMIT 500]){ //TODO: Install a realistic limit here
                contactList.add(c);
        }
        
        integer total = contactList.size();
        json = '{total:"' + total + '", values:[';
        
        for(Contact c : contactList) {
            json += '{Id:"' + c.Id + '",';
        }

        if (total > 0) json = json.substring(0, (json.length()-1)); //Remove trailing comma
        json += ']}'; //close json string
        return json;
    }
    
    public string GetAssignedTasks(){
        return Stub.getAssignedTasks();
    }
    
    public string GetResources(){
        return Stub.getResources(VP_Utils.GetEmail(), ProjectId);
    }
    
    public string AddResources(){
        return Stub.addResources(VP_Utils.GetEmail(),Params.get('resources'),ProjectId);
    }
    
    public string UpdateTask(){
        string jsonString;
        string taskId = Params.get('taskId');
        string taskName = Params.get('taskName');
        integer taskComplete = Params.get('taskComplete') == null ? null : integer.valueOf(Params.get('taskComplete'));
        
        jsonString = Stub.updateTask(VP_Utils.GetEmail(),taskId, taskName, taskComplete, null, null, null, null);
        return jsonString;
    }
    
    public string GetTips(){
    	HttpRequest req = new HttpRequest(); 
        string jsonString;
        //Set HTTPRequest Method
        req.setMethod('GET');
        
        //Set HTTPRequest header properties
        req.setEndpoint(VP_Utils.ViewpathUrl + 'Partners/SFAppEx/Service/ViewpathTips.ashx');
        
        //Set the HTTPRequest body    
        req.setbody('GetTips');
        Http http = new Http();
        
        try {            
            //Execute web service call here     
            HTTPResponse res; 
            if (!isApexTest) {
                res = http.send(req);  
            } else {
                res = new HTTPResponse();
                res.setStatusCode(500);
            }
        
            //Helpful debug messages
            System.debug(res.toString());
            System.debug('STATUS:'+res.getStatus());
            System.debug('STATUS_CODE:'+res.getStatusCode());
            if (res.getStatusCode() > 304) {
                jsonString = '[{tip: \'You can add as many resources as you like to a project for free? Click the resources tab to try it!\'},{tip: \'To add or edit tasks, open Viewpath in a new window by clicking the "Open Viewpath Project" button.\'}]';
            } else {
                jsonString = res.GetBody();                
            }
        } catch(System.CalloutException e) {
            //Exception handling goes here....
            jsonString = '[{tip: \'You can add as many resources as you like to a project for free? Click the resources tab to try it!\'},{tip: \'To add or edit tasks, open Viewpath in a new window by clicking the "Open Viewpath Project" button.\'}]';
        }       
        return jsonString;
    }
    
    //TODO: Check owner privileges
    public string SetProjectNotifications(string projectId, boolean enable) {
        VP_Project__c project = GetProject(projectId);
        if (project != null) {
            try{
                if (enable){
                    Stub.EnableProjectNotifications(string.valueOf(project.Id), project.ProjectId__c);
                } else {
                    Stub.DisableProjectNotifications(string.valueOf(project.Id), project.ProjectId__c);
                }
                project.ChatterEnabled__c = enable;
                //update(project); //TODO: currently chatter implementation is broken, so this isn't an issue, but we need to change this model to command button and not GET rest endpoint
                return string.valueOf(!enable);
            } catch (exception ex){
                return string.valueOf(enable);
            }
        }
        return string.valueOf(enable);
    }
    

    //Validate projectid for sql injection
    public VP_Project__c GetProject(string projectId){
            VP_Project__c project = [SELECT Name, Id, ProjectId__c, ChatterEnabled__c, ChatterGroupId__c FROM VP_Project__c WHERE ProjectId__c = :projectId LIMIT 1];
            return project;
    }
    
    public String getSFUsers(){
        List<user> userList = new List<user>();
        String json;
        
        //Put all users in a list
        for(User u : [select Id, Name, Email, Department from User WHERE isActive = true LIMIT 500]){ //TODO: Install a realistic limit here
                userList.add(u);
        }
        
        json = '{ total: "' + userList.size() + '", values:[';        //Open JSON string with totals value for ext
        
        //Add all users into a JSON String
        for(User u : userList) {
            json += '{Id:"' + u.Id + '",';        
            json += 'Name:"' + u.Name + '",';
            json += 'Email:"' + u.Email + '",';
            json += 'Department:"' + u.Department + '"},';                        
        }

        json = json.substring(0, (json.length()-1)); //Remove trailing comma
        json += ']}'; //close json string
        return json;
    }
    
    public String getChatterGroups(){
        List<CollaborationGroup> groupList = [SELECT Name, Description, CollaborationType, OwnerId from CollaborationGroup LIMIT 500];
        string json;
        json = '{ total: "' + groupList.size() + '", values:[';        //Open JSON string with totals value for ext
        
        //Add all users into a JSON String
        for(CollaborationGroup g : groupList) {
            json += '{Id:"' + g.Id + '",';        
            json += 'Name:"' + g.Name + '",';
            json += 'Description:"' + g.Description + '",';
            json += 'OwnerId:"' + g.OwnerId + '",';
            json += 'CollaborationType:"' + g.CollaborationType + '"},';                        
        }

        json = json.substring(0, (json.length()-1)); //Remove trailing comma
        json += ']}'; //close json string
        return json;
    }
    
    public string selectChatterGroup(string groupId, string projectId){
        VP_Project__c project = getProject(projectId);
        if (project != null) {
            if (VP_Utils.isValidId(groupId)) {
                try{
                    Stub.UpdateSalesforceProject(project.Id, project.ProjectId__c, groupId, project.ChatterEnabled__c);
                    project.ChatterGroupId__c = groupId;
                    //update(project); //see previous todo above
                    return '{success: true, groupId: "'+ groupId +'"}';
                }
                catch (exception ex) {
                    return '{success: false, message: "Unable to communicate with Viewpath API. Please try again."}';
                }
            }
        }
        return '';
    }
    
    private String writeVal(string val){
        if (val == null)
            return String.valueOf(val);
        return '"' + val + '"';
    }
    
    
    
    
    
    /*  **** TEST METHODS BEGIN *****  */    
    
    public static testMethod void testVP3Interface_ChatterGroups(){
    	
    	system.debug(' TEST> testVP3Interface_ChatterGroups begins:');
    	
		// Set the static variable IsApexTestMode, required to prevent API calls in tests, must do before any of the Extension controllers are created.
        VP_Utils.IsApexTestMode = true; 
        
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
        //ApexPages.currentPage().getParameters().put('method', 'selectChatterGroup');
        //ApexPages.currentPage().getParameters().put('ProjectId', proj.ProjectId__c);
        //ApexPages.currentPage().getParameters().put('GroupId', cg.Id);
        //controller.ExecuteDML();
        
        proj = Controller.GetProject(proj.projectId__c);
        System.AssertEquals('100.100.100', proj.ProjectId__c);
        
        //Test getProjects
        ApexPages.currentPage().getParameters().put('method', 'getProjects');
        controller.ExecuteDML();
        
        //Test GetChatterGroups
        ApexPages.currentPage().getParameters().put('method', 'getChatterGroups');
        controller.ExecuteDML();
        System.Assert(controller.jsonOutput != '{"message":"EMPTY"}');
        
        //Test GetTasks
        ApexPages.currentPage().getParameters().put('method', 'getTasks');
        controller.ExecuteDML();
        
        //Test GetAssignedTasks
        ApexPages.currentPage().getParameters().put('method', 'getAssignedTasks');
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
        
        //Test getSFProjects
        ApexPages.currentPage().getParameters().put('method', 'getSFProjects');
        controller.ExecuteDML();
        
        //Test getAccountContacts
        ApexPages.currentPage().getParameters().put('method', 'getAccountContacts');
        // ToDo:  Create an Account, then Contacts on it, send getAccountContacts the accId parameter 
        //        The above will add coverage to writeVal which is called from getAccountContacts
        Account acnt = new Account(name='UnitTestAccount');
        insert acnt;
        Contact contact1 = new Contact();
        contact1.firstName = 'C1_FN';
        contact1.lastName = 'C1_LN';
        contact1.AccountId = acnt.Id;
        contact1.email = 'testcontact@test.com';
        insert contact1;
        ApexPages.currentPage().getParameters().put('accId', acnt.Id);
        controller.ExecuteDML();
        //system.debug(' TEST> GetAccountContacts JSON=' + controller.jsonOutput);
        
        //Test getContacts
        ApexPages.currentPage().getParameters().put('method', 'getContacts');
        controller.ExecuteDML();

        
        //Test GetTips
        ApexPages.currentPage().getParameters().put('method', 'GetTips');
        controller.ExecuteDML();

        //Test EnableProjectNotifications
        ApexPages.currentPage().getParameters().put('ProjectId', proj.ProjectId__c);
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
        
    	system.debug(' TEST> testVP3Interface_ChatterGroups ends');        
    }
    
}