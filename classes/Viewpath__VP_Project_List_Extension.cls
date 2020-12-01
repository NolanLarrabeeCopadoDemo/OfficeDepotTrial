public with sharing class VP_Project_List_Extension {
    
    public Boolean isApexTest = false;
    public Boolean AccountActivated {get; private set;}
   
    private final ApexPages.StandardSetController controller;
    
/*
    /// Begin of code added in attempt to get a Launch button on the VP Projects tab
    public Double AccessLevel {get; private set;}
    public String AccessLevelText {
        get {      
            if (this.AccessLevel == 0) return 'are a guest on';        
            if (this.AccessLevel == 1) return 'are an observer on';
            if (this.AccessLevel == 2) return 'are an editor on';
            if (this.AccessLevel == 2.5) return 'are a manager on';
            if (this.AccessLevel == 3) return 'are an owner on';
            return 'have no access to';
        }
        private set;
    }
    
    public string getLocalAPIUrl(){ return Page.VP_SFAPI.getUrl(); }
    public string getViewpathAPIUrl(){ return Page.vp3API.getUrl(); }    
    public string getViewpathLaunchAppUrl(){ return Page.VP_Launch_Application.getUrl(); }
    public string AppUrl {get {return VP_Utils.AppUrl; } }
    /// End of code added in attempt to get a Launch button on the VP Projects tab
*/
            
    public VP_Project_List_Extension(ApexPages.StandardSetController c){
        controller = c;        
        
        isApexTest = VP_Utils.IsApexTestMode;
        
        AccountActivated = VP_Utils.IsAccountActivated();
    }
    
    
    
    
    
    
    /*  **** TEST METHODS BEGIN *****  */
        
    public static testMethod void testVPProjectListExtension(){
    	
    	system.debug(' TEST> testVPProjectListExtension begins:');
    	    	
        // Set the static variable IsApexTestMode, required to prevent API calls in tests, must do before any of the Extension controllers are created.
        VP_Utils.IsApexTestMode = true; 
    	
    	system.debug(' TEST> Creating 3 new projects');
        VP_Project__c p1 = new VP_Project__c();
        VP_Project__c p2 = new VP_Project__c();
        VP_Project__c p3 = new VP_Project__c();
        
        p1.Name = 'p1';
        p2.Name = 'p2';
        p3.Name = 'p3';
    
        VP_Project__c[] projects = new List<VP_Project__c>();
        
        system.debug(' TEST> Adding projects to List');
        projects.add(p1);
        projects.add(p2);
        projects.add(p3);

    	system.debug(' TEST> Inserting Projects into page');
        insert(projects);
        
        //projects = [SELECT Id, Name, ProjectId__c FROM VP_Project__c];
        PageReference pageRef = Page.VP_Project_List;
        Test.setCurrentPage(pageRef);
        
        system.debug(' TEST> Creating new VP_Project_List_Extension');
        //Open Custom Controller
        ApexPages.StandardSetController sc = new ApexPages.StandardSetController(projects);
        VP_Project_List_Extension ce = new VP_Project_List_Extension(sc);
        
        system.debug(' TEST> Testing for projects.size > 0');
        system.assert(projects.size() > 0, 'No Projects Found');
        
        // To test the Trigger on Delete we need a way to Delete a project
        // projects.delete();    // this didn't build.
        // VP_Project__c.Trigger_UpdateProjects(p1.id);
        
        system.debug('TEST> testVPProjectListExtension ends');
    }
    
}