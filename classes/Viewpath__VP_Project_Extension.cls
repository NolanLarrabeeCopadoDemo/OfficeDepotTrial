public with sharing class VP_Project_Extension {
    public Boolean IsApexTest = false;
    
    public Boolean AccountActivated {get; private set;}
    public User ProjectOwner {get; private set;}
    public VP_Project__c Project {get;set;}
    public Final VP_Web_Services_API.VPProject VPProject {get; private set;}
    private Final ApexPages.StandardController Controller;    
    
    public string ProjectId {get; set;}
    public Date ProjectStart {get; set;}
    
    public String rType{get; set;}
    public String refererId{get; set;}
    public String userEmail {get; set;}



    public String ChatterButtonLabel { 
        get {
            return Project.ChatterEnabled__c ? 'Disable Chatter Notifications' : 'Enable Chatter Notifications';
        }
    }

    // IDSI.DG.1.14.2014
    // modified the private set method to public, otherwise test scripts will not compile
    // based on requirements from Salesforce 2013 API Changes of test code must be in
    // it's own test class. See test class: testVP_Project_Extension()
    //
    public Double AccessLevel {get; set;}
    
    public String AccessLevelText {
        get {      
            if (this.AccessLevel == 0) return ' are a guest on ';
            if (this.AccessLevel == 1) return ' are an observer on ';
            if (this.AccessLevel == 2) return ' are an editor on ';
            if (this.AccessLevel == 2.5) return ' are a manager on ';
            if (this.AccessLevel == 3) return ' are an owner on ';
            return ' have no access to ';
        }
        private set;
    }
    
    public String ClientToken {get; private set;}
    public CollaborationGroup ChatterGroup {get; private set;}
    
    //Helper Properties
    public Boolean IsChatterEnabled { get { 
            if (Project.ChatterEnabled__c){
                return true;
            } else {
                return false;
            }
        } 
    }
    public Boolean IsOrgChatterEnabled { get { return VP_Utils.isOrgChatterEnabled(); } }
    public Boolean IsSfProjectOwner { get { return Project.Owner.Id == UserInfo.getUserId(); } }
      
    public String debug{get; set;}
        
    public string getLocalAPIUrl(){ return Page.VP_SFAPI.getUrl(); }
    public string getViewpathAPIUrl(){ return Page.vp3API.getUrl(); }    
    public string getViewpathLaunchAppUrl(){ return Page.VP_Launch_Application.getUrl(); }
    public string AppUrl {get {return VP_Utils.AppUrl; } }


    public string displayFollowButton{
        get {
            return (UserInfo.getUserId() == Project.Owner.Id) && (VP_Utils.getVPConfig().ChatterEnabled__c) && !Project.ChatterEnabled__c ? 'inline-block' : 'none';
        }
    }
    public string displayUnfollowButton{
        get {
            return (UserInfo.getUserId() == Project.Owner.Id) && (VP_Utils.getVPConfig().ChatterEnabled__c) && Project.ChatterEnabled__c ? 'inline-block' : 'none';
        }
    }

    
    public void UpdateProject(){
        // Manually update the project summary info from VP source
        system.debug('UPDATING PROJECT VIA COMMAND BUTTON');
        VP_Web_Services_API.VP31Soap api = new VP_Web_Services_API.VP31Soap();
        VP_Project projectCls = new VP_Project(Project);
        Project = projectCls.UpdateProjectFromAPI(api.GetProject(userEmail,Project.ProjectId__c));
        system.debug('Project complete value:');
        system.debug(Project.Complete__c);
        Update(Project);  // Update the SOQL Object with new values.
    }
    
    /*Constructors*/  
    public VP_Project_Extension(ApexPages.StandardController c){
        system.debug(' In VP_Project_Extension constructor - IsApexTestMode=' + Vp_Utils.IsApexTestMode);

        //Init api, set test mode
        VP_Web_Services_API.VP31Soap api = new VP_Web_Services_API.VP31Soap();
        api.isApexTest = Vp_Utils.IsApexTestMode;   // RW>  Bug fix: test mode wasn't being recognized, new Utils Static way used

        //Every time object is referenced, update from Viewpath API
        userEmail = VP_Utils.GetEmail();    

        if (c != null) {
            Project = (VP_Project__c)c.getRecord();
            Controller = c;
        }

        if (Project != null) {
            VP_Project projectCls = new VP_Project(Project);
            
            AccessLevel = api.GetProjectAccessLevel(Project.ProjectId__c);
            VPProject = api.GetProject(userEmail, Project.ProjectId__c);
            
            //Auto-update the project on load from API
            if (VPProject != null) {
                projectCls.UpdateProjectFromAPI(VPProject);
            }
        }

        AccountActivated = VP_Utils.IsAccountActivated();
        if (VP_Utils.isOrgChatterEnabled() && Project.ChatterGroupId__c != null) {
            ChatterGroup = [SELECT Id, Name FROM CollaborationGroup WHERE Id = :Project.ChatterGroupId__c LIMIT 1];
        }
        if (ChatterGroup == null) {
            ChatterGroup = new CollaborationGroup();
            ChatterGroup.Name = 'No Group Selected';
        }
        
        
        
        
        

        //I still hate that this is an additional request every goddamn time.
        ClientToken = api.GetToken();
       
    }
    
    /*End Constructors*/
    
    
    
     
    
    
    
    
}