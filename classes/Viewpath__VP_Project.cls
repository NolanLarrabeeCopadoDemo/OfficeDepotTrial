public without sharing class VP_Project {
    /*Members*/
    private VP_Web_Services_API.VP31Soap API = new VP_Web_Services_API.VP31Soap();
    public VP_Project__c Project;
    public string Email = VP_Utils.GetEmail();
    public boolean isApexTest;
    public static boolean isApexTestStatic;
    /*End Members*/
    
    /*Constructor*/
    
    public VP_Project(){
        if (isApexTest != null) {
            API.isApexTest = isApexTest;    
        } else {
            API.isApexTest = false;
        }
    }
    
    public VP_Project(VP_Project__c project){
        this.Project = project;
        if (isApexTest != null) {
            API.isApexTest = isApexTest;    
        } else {
            API.isApexTest = false;
        }
    }
    
    //Update this classes record with API fetched
    public VP_Project__c UpdateProjectFromAPI(VP_Web_Services_API.VPProject VPProject){
        system.debug('VPPROJECT::' + VPProject);
        system.debug('PROJECT::' + project);
        
        Project.Name = (VPProject.Name == null) ? Project.Name : VPProject.Name;
        Project.Complete__c = (VPProject.Complete == null) ? Project.Complete__c : VPProject.Complete;
        Project.Start__c = (VPProject.Start == null) ? Project.Start__c : VPProject.Start;
        Project.Finish__c = (VPProject.Finish == null) ? Project.Finish__c : VPProject.Finish;
        return Project;
    }
    /*
    public VP_Project(string projectId){
        //get project from id
        API.isApexTest = isApexTest;        
    }
    */
    
    /*End Constructor*/
    
    /*Static Trigger Methods*/
    @Future(callout=true)    
    public static void Trigger_DeleteProjects(Set<String> pIds){
        system.debug(pIds + '; size::' + pIds.size());
        string email = VP_Utils.getEmail();
        
        VP_Web_Services_API.VP31Soap API = new VP_Web_Services_API.VP31Soap();
        system.debug(' In VP_Project.Trigger_DeleteProjects - IsApexTestMode=' + Vp_Utils.IsApexTestMode);
        API.isApexTest = VP_Utils.IsApexTestMode;   // RW>  Bug fix: test mode wasn't being recognized, new Utils Static way used
        
        for(String pId : pIds) {
            API.DeleteProject(email,pId);
        }
    }

    public static void Trigger_UpdateProjects(Set<ID> ids){
        List<VP_Project__c> projects = [SELECT Id,Name,ProjectId__c FROM VP_Project__c WHERE Id in :ids];
        List<String> newProjects = new List<String>(); //List of IDs
        
        if (projects.size() > 0) {
            for (VP_Project__c project : projects) {
                if (project.ProjectId__c != null && project.ProjectId__c != '') { 
                    system.debug('Inside ProjectId :: ' + project.ProjectId__c);
                    newProjects.add(project.Id); //Provision to only run the future method if the id is null; this should prevent 'future cannot call future method'
                }
            }
        }
        if (newProjects.size() > 0) {
            Trigger_UpdateProjects(newProjects);
        }
    }

    @Future(callout=true)
    public static void Trigger_UpdateProjects(List<String> ids){
        
        VP_Web_Services_API.VP31Soap API = new VP_Web_Services_API.VP31Soap();  
        system.debug(' In VP_Project.Trigger_DeleteProjects - IsApexTestMode=' + Vp_Utils.IsApexTestMode);
        API.isApexTest = VP_Utils.IsApexTestMode;   // RW>  Bug fix: test mode wasn't being recognized, new Utils Static way used
          
        string email = VP_Utils.GetEmail();
        /*Test Provisions*/
        if (isApexTestStatic != null)        
            API.isApexTest = isApexTestStatic;
        /*End Test Provisions*/
        
        List<VP_Project__c> projects = [SELECT Id, Name, ProjectId__c, Owner.Email FROM VP_Project__c WHERE Id in :ids];
        
        if (projects != null) {
            if (projects.size() > 0) {
                for (VP_Project__c project : projects) {
                    if (project.Owner.Email != null && email != null && project.Name != null && project.ProjectId__c != null) {
                        API.UpdateProject(email, project.ProjectId__c, project.Name, project.Owner.Email);
                    } else {
                        System.debug('null values in trigger');
                    }
                }
            }
        }
    }
    
    @Future(callout=true)
    public static void Trigger_CreateProjects(Set<ID> ids){
        
        VP_Web_Services_API.VP31Soap API = new VP_Web_Services_API.VP31Soap();
        system.debug(' In VP_Project.Trigger_DeleteProjects - IsApexTestMode=' + Vp_Utils.IsApexTestMode);
        API.isApexTest = Vp_Utils.IsApexTestMode;   // RW>  Bug fix: test mode wasn't being recognized, new Utils Static way used
                
        string email = VP_Utils.GetEmail();
        
        /*Test Provisions*/
        if (isApexTestStatic != null)
            API.isApexTest = isApexTestStatic;
        /*End Test Provisions*/

        List<VP_Project__c> projects = [SELECT Id,Name,ProjectId__c, Owner.Name, Owner.Email FROM VP_Project__c WHERE Id in :ids];
        List<VP_Project__c> newProjects = new List<VP_Project__c>();
        
        if (projects != null) {
            if (projects.size() > 0) { 
                for (VP_Project__c project : projects){

                    if (project.ProjectId__c == '' || project.ProjectId__c == null) {
                        string newId = API.CreateProject(email, project.Name, project.Owner.Email, project.Owner.Name);
                        project.ProjectId__c = newId;
                        project.Name = project.Name; //This seems to trick the trigger into working on GE and PE..? wtf?                        
                    }
                    
                    if (VP_Utils.isOrgChatterEnabled()){
                        API.EnableProjectNotifications(project.Id, project.ProjectId__c); //This by default enables the project to be added to the viewpath project DB enabled for chatter. 
                        project.ChatterEnabled__c = true;
                    }
                    newProjects.add(project);
                }
            }
        }
        
        if (newProjects.size() > 0) {
            VP_Trigger_Validator.SetTriggerExecuted();
            update(newProjects);
        }
    }
    
    
    
    
    
    /*  **** TEST METHODS BEGIN *****  */    
    
    public static testMethod void testVP_Project(){
        
        system.debug(' TEST> testVP_Project begins:');
        
        // Set the static variable IsApexTestMode, required to prevent API calls in tests, must do before any of the Extension controllers are created.
        VP_Utils.IsApexTestMode = true; 
        
        VP_Project.isApexTestStatic = true;
        VP_Project__c proj = new VP_Project__c();

        proj.name = 'New Test Project';

        insert(proj);
        
        proj.ProjectId__c = '123456';

        update(proj);

        VP_Project__c p = [SELECT Name FROM VP_Project__c WHERE Id = :proj.id];

        System.AssertEquals(p.name, proj.name);
        
        // Test Contructors
        VP_Project vpprj1 = new VP_Project();
        VP_Project vpprj2 = new VP_Project(proj);
        
        system.debug(' TEST> testVP_Project ends');
    }
      
    
    
}