public with sharing class VP_Resource { 
 
/* UNUSED */
 
    public String Name {get;set;}
    public String Email {get;set;}
    public String ProjectId {get;set;}
    public String Id {get;set;}




    /*  **** TEST METHODS BEGIN *****  */
         
    public static testMethod void testResource(){
    	
    	system.debug(' TEST> testResource begins:');
    	    	
        VP_Resource r = new VP_Resource();
        
        r.Email = 'test@email.com';
        r.Name = 'Test Name';
        r.ProjectId = 'testProjectId';
        r.Id = 'testId';
        
        system.AssertEquals(r.Email,'test@email.com');
        system.AssertEquals(r.Name,'Test Name');
        system.AssertEquals(r.ProjectId,'testProjectId');
        system.AssertEquals(r.Id,'testId');                       
    
        system.debug(' TEST> testResource ends');
    }
 
}