public with sharing class VP_Project_New_Extension {
    // public Boolean IsApexTest = false;    // This was impractical as couldn't set via constructor.  Instead we use Vp_Utils.IsApexTestMode
    public Boolean AccountActivated {get; private set;}
    public VP_Project__c Project {get; set;}
    public String ClientToken {get; private set;}
    public string Mode = 'NEW';

    public string getMode(){
        return Mode;
    }
    public void setMode(string Mode) {
        this.Mode = Mode;
    }
    
    private string retUrl;
    private string objType;
    private string refId;
    private string refName;

    public string getLocalAPIUrl(){ return Page.VP_SFAPI.getUrl(); }
    public string getViewpathAPIUrl(){ return Page.vp3API.getUrl(); }    
    public string getViewpathLaunchAppUrl(){ return Page.VP_Launch_Application.getUrl(); }
    public string AppUrl {get {return VP_Utils.AppUrl; } }
	
	
	public string ExistingProjectsJson {get; private set;}
    
    public VP_Project_New_Extension(ApexPages.StandardController c){
         if (c != null) {
            Project = (VP_Project__c)c.getRecord();
         }
         AccountActivated = VP_Utils.IsAccountActivated();

         if(AccountActivated || Vp_Utils.IsApexTestMode){
            VP_Web_Services_API.VP31Soap api = new VP_Web_Services_API.VP31Soap();
            system.debug(' In VP_Project_New_Extension constructor - IsApexTestMode=' + Vp_Utils.IsApexTestMode);
            api.isApexTest = Vp_Utils.IsApexTestMode;   // RW>  Bug fix: test mode wasn't being recognized, new Utils Static way used
            ClientToken = api.GetToken();
         }
         
         GetExistingProjects();
         GetName();
    }
    
    public void GetExistingProjects(){
    	List<VP_Project__c> projectList = new List<VP_Project__c>();
               
        for(VP_Project__c proj : [select Id, Name, ProjectId__c from VP_Project__c LIMIT 500]){ //TODO: Install a realistic limit here
                projectList.add(proj);
        }
        
        this.ExistingProjectsJson = JSON.serialize(projectList);
    }
    
    public List<SelectOption> getItems() {
        List<SelectOption> options = new List<SelectOption>(); 
        options.add(new SelectOption('NEW','New project'));
        options.add(new SelectOption('EXISTING','Connect to existing')); 

        return options; 
    }
    
    public PageReference save() {
        system.debug('ext test: saving publicproject');
        String projectName;
        String newProjectId;
        
        if (Mode != 'NEW') {
            VP_Web_Services_API.VP31Soap API = new VP_Web_Services_API.VP31Soap();
            //project.ProjectId__c = ProjectId;
            system.debug(' In VP_Project_New_Extension save() - IsApexTestMode=' + Vp_Utils.IsApexTestMode);
            API.isApexTest = Vp_Utils.IsApexTestMode;   // RW>  Bug fix: test mode wasn't being recognized, new Utils Static way used
            string newName = API.ConnectToProject(VP_Utils.GetEmail(), Project.ProjectId__c);
            system.debug('Connecting ' + VP_Utils.GetEmail() + ' to existing project ' + Project.ProjectId__c + '--name is ' + newName);            
            project.Name = newName;
        }
        
        upsert(project);
        system.debug('upserted project');

        PageReference returnPage;
        if (ApexPages.currentPage().getParameters().get('retURL') != null && ApexPages.currentPage().getParameters().get('retURL') != '') 
        {
            returnPage = new PageReference(ApexPages.currentPage().getParameters().get('retURL'));
        } else {
            returnPage = new ApexPages.StandardController(Project).view();
        }
        returnPage.setRedirect(true);
        return returnPage;
    }
    
    public void GetName(){
        //Get objID
        Map<string, string> query_parameters = ApexPages.currentPage().getParameters();
        
        string nameParam;
        // find this querystring key / value: CF00NS0000000eZs4_lkid=500S00000014ccK
        for(String key : query_parameters.keySet()) {
            if (key.contains('_lkid')) {
                refId = EncodingUtil.urlEncode(query_parameters.get(key), 'UTF-8');  // Oct 2013: Security Change to prevent XSS
                objType = refId.subString(0,3);
                nameParam = key.substring(0,key.indexOf('_lkid', 0));
                Project.Name = query_parameters.get(nameParam);
                system.debug('Deduced the project name to be: ' + Project.Name);
            }
        }   
    }
    
    
    
    
    
    
    /*  **** TEST METHODS BEGIN *****  */
    
    public static testMethod void testVP_Project_New_Extension(){
    	
    	system.debug(' TEST> testVP_Project_New_Extension begins:');
    	
		// Set the static variable IsApexTestMode, required to prevent API calls in tests, must do before any of the Extension controllers are created.
        VP_Utils.IsApexTestMode = true; 
    	
    	system.debug(' TEST> Creating new project');
        //VP_Project.isApexTestStatic = true;
        VP_Project__c proj = new VP_Project__c();    

        proj.ProjectId__c = 'New_Test_Project';
        proj.Name = 'New_Test_Project';
        
        system.debug(' TEST> Creating new Account');
        Account acc = new Account();
        acc.Name = 'New Account';
        insert(acc);

        system.debug(' TEST> Creating new Opportunity');
        Opportunity opp = new Opportunity();
        opp.Name = 'New Opp';
        opp.StageName = 'New Stage Name';
        opp.CloseDate = Date.Today();
        insert(opp);
                
        insert(proj);
        proj = [SELECT Name, Id, ProjectId__c, ChatterGroupId__c, ChatterEnabled__c, Owner.Id, Owner.Name FROM VP_Project__c WHERE Id = :proj.Id];
        
        system.assertEquals(proj.Name, 'New_Test_Project');
        system.debug(' TEST> Project Name Was Tested');
                
        PageReference pageRef = Page.VP_Project_New;
        Test.setCurrentPage(pageRef);

        system.debug(' TEST> About to create Standard Controller');
        ApexPages.StandardController sc = new ApexPages.StandardController(proj);

        system.debug(' TEST> About to test creation of VP_Project_New_Extension');
        VP_Project_New_Extension nce = new VP_Project_New_Extension(sc);

       
        system.debug(' TEST> About to test Opportunity Referer ');        
        ApexPages.currentPage().getParameters().put('CF00NA0000000l3I6_lkid', opp.Id);//try with '001' as well
        ApexPages.currentPage().getParameters().put('CF00NA0000000l3I6', opp.Name);
        ApexPages.currentPage().getParameters().put('retUrl', '/'+opp.Id);
        nce.save();                               

        
        system.debug(' TEST> About to test Account Referer');    
        nce = new VP_Project_New_Extension(sc);
        ApexPages.currentPage().getParameters().put('CF00NA0000000l3I6_lkid', acc.Id);//try with '001' as well
        ApexPages.currentPage().getParameters().put('CF00NA0000000l3I6', acc.Name);
        ApexPages.currentPage().getParameters().put('retUrl', '/'+acc.Id);
        // Open Custom Controller
        nce.save();
        
        
        // Test Mode string, set / get
        system.debug(' TEST> About to test Property setMode/getMode');
        nce = new VP_Project_New_Extension(sc);   
        nce.setMode('Test');
        //system.debug(' TEST> Value of getMode=' + nce.getMode());
        system.assertEquals('Test', nce.getMode());
        
        
        // Test calls to Public String Metods
        system.debug(' TEST> About to test Public String Methods');
        
        //system.debug('     TEST>value of getLocalAPIURL=' + nce.getLocalAPIUrl());
        system.assertEquals('/apex/viewpath__vp_sfapi', nce.getLocalAPIUrl());
        
        //system.debug('     TEST>value of getViewpathAPIUrl=' + nce.getViewpathAPIUrl()); 
        system.assertEquals('/apex/viewpath__vp3api', nce.getViewpathAPIUrl());
        
        //system.debug('     TEST>value of getViewpathLaunchAppUrl=' + nce.getViewpathLaunchAppUrl());
        system.assertEquals('/apex/viewpath__vp_launch_application', nce.getViewpathLaunchAppUrl());        
        
       
        // Test the getItems method()
        system.debug(' TEST> About to test Method getItems()');
        system.debug('      TEST>value of getItems=' + nce.getItems());
        

        system.debug(' TEST> About to test VP_Project_New_Extension - CONNECT');                      
        nce = new VP_Project_New_Extension(sc);   
        nce.setMode('CONNECT');
        nce.save();


        system.debug(' TEST> About to test VP_Project_New_Extension - NEW');
        nce = new VP_Project_New_Extension(sc);
        nce.setMode('NEW');
        nce.save();
        
        
        system.debug(' TEST> About to test - No Return URL');
        ApexPages.currentPage().getParameters().put('retUrl',null);
        nce.save();
        
        
        // Note: To complete the test usage of the Trigger, we'd have to delete the project, however no easy way was found.

        
        system.debug('TEST> testVP_Project_New_Extension ends');
	}
    
}