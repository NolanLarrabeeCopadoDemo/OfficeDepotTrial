public with sharing class VP_Task { 
 
 
/* UNUSED */
 
 
    public String Name {get;set;}
    public String Id {get;set;}
    public Integer Complete {get;set;}
    public String Start {get;set;}
    public String Finish {get;set;}
     




    /*  **** TEST METHODS BEGIN *****  */
         
    public static testMethod void testTask(){
    	
    	system.debug(' TEST> testTask begins:');
    	
        VP_Task t = new VP_Task();   
        
        system.assert(t != null);
        
    	system.debug(' TEST> testTask ends');
        
    }
     
}