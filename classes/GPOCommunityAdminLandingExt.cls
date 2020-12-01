/**
 * Extention for GPO Admin Functions
 * Logic in this Controller should general and not contain any template specific details
 * Template details should be contained in a template specific Extention
 */
public without sharing class GPOCommunityAdminLandingExt {
	
	// TODO - This class should be consolidated in the controller.  And this class will be removed.  This will enable one save from the template ext
	
	public Map<Id,GPO_Group__c> activeNodesMap {get; set;} //Map of active nodes below the grandparent, three levels down
	public List<Account> childGPOAccounts {get; set;}
	public Attachment brandImage {get; set;}
	public Set<ID> enabledAccountIDs {get; set;}
	public GPO_Group__c ultimateparentgroup {get; set;}
	public List<ChildAccountDetail> childAccountDetails {get; set;}
	public List<ChildAccountDetail> childAccountDetails2 {get; set;}
	
	
	//TODO push back to the controller, these function should not be done here
	private GPOCommunityAuthLandingController conValues;
	
	/*
	 * Class used to hold Child Account Details
	 * This details are used to display the account hierarchy
	 */
	public class ChildAccountDetail
    {
	    public String childAccountName {get; set;}
	    public String childAccountId  {get; set;}
	    public list<ChildAccountDetail> grandChildren {get; set;}
	    public boolean enabled {get; set;}
	
	    public ChildAccountDetail(Account anAccount, list<ChildAccountDetail> grandchildrendetails, boolean isenabled)
	    {
	        childAccountName = anAccount.Name;
	        childAccountId = anAccount.Id;
	        enabled = isenabled;
	        grandChildren = grandchildrendetails;        
	    }
	}
	
	// Returns GPO_Group values from active Nodes Map
	public List<GPO_Group__c> getActiveNodes() {
		return activeNodesMap.values();
	}
		
	// Default constructor
    public GPOCommunityAdminLandingExt(GPOCommunityAuthLandingController con) {
        conValues = con; 
        
        enabledAccountIDs = new Set<ID>();
        childAccountDetails = new List<ChildAccountDetail>();
        //Added for case#00123471
		childAccountDetails2 = new List<ChildAccountDetail>();
		// end case#00123471
        // Pulls brand image to be used for admin updated
    	brandImage = [SELECT id, Name, Body from Attachment where id =: con.selectedGroup.Community_Image__c ];
    	
    	// Identifies the grandparent
        ultimateparentgroup = [SELECT id, Community_Name__c from GPO_Group__c where  Account__c =: con.selectedGroup.Ultimate_Parent2__c and Activated__c = true];
        
        // List of all enabled GPO Communities under the ultimateparentgroup (grandparent)
        activeNodesMap =  new Map<ID, GPO_Group__c>([Select id, Community_Name__c, Account__c from GPO_Group__c where Ultimate_Parent2__c =: con.selectedGroup.Ultimate_Parent2__c]);
        
        // Collection of all enabled GPO communities 
        For(GPO_Group__c thenode: activeNodesMap.values() ){ 
        	enabledAccountIDs.add(thenode.Account__c);
        }   
       
        // remove the selected group from the active nodes map (which will remove from the site switcher drop down)
        activeNodesMap.remove(con.selectedGroup.ID);
        // remove the grandparent from the active nodes map (which will remove from the site switcher drop down)
        activeNodesMap.remove(ultimateparentgroup.ID);
        
        // Get grandchildern for each parent
        // TODO - this will not scale and needs to be updated to relect the UI selected to show the account hierarchy
        childGPOAccounts = [Select id, Name, (select name,id from ChildAccounts) from Account where id IN :con.gpoAccount.ChildAccounts];
        
        // Construct the Account Details Object
        For(Account a: childGPOAccounts){
        	List<ChildAccountDetail> gcAccountDetails = new List<ChildAccountDetail>();
        	For(Account gc: a.ChildAccounts){
        		ChildAccountDetail gcAccountDetail = new ChildAccountDetail(gc, new List<ChildAccountDetail>(), enabledAccountIDs.contains(gc.id));
        		gcAccountDetails.add(gcAccountDetail);
        	}
        	childAccountDetails.add(new ChildAccountDetail(a, gcAccountDetails, enabledAccountIDs.contains(a.id)));  	
        }
        
       
             
    }
    
   
    //Each should have it's own save and be but at the right controller or extension which ownes it
    public  PageReference save() {
       update brandImage;
       update conValues.selectedGroup;
      
       return null;
    }
    
    
     public ApexPages.StandardSetController setCon {
        get {
            if(setCon == null) {
                setCon = new ApexPages.StandardSetController(Database.getQueryLocator(
                    [Select id, Name, (select name,id from ChildAccounts) from Account where id IN :conValues.gpoAccount.ChildAccounts]));
            }
            return setCon;
        }
        set;
    }

    // Initialize setCon and return a list of records
    public List<ChildAccountDetail> getPagedAccounts() {
    	  List<Account >currentAccountSet = setCon.getRecords();
    	  
    	   // Construct the Account Details Object
	        For(Account a: currentAccountSet){
	        	List<ChildAccountDetail> gcAccountDetails = new List<ChildAccountDetail>();
	        	For(Account gc: a.ChildAccounts){
	        		ChildAccountDetail gcAccountDetail = new ChildAccountDetail(gc, new List<ChildAccountDetail>(), enabledAccountIDs.contains(gc.id));
	        		gcAccountDetails.add(gcAccountDetail);
	        	}
	        	childAccountDetails2.add(new ChildAccountDetail(a, gcAccountDetails, enabledAccountIDs.contains(a.id)));  	
	        }
    	
       		return childAccountDetails2;
    }
    

    
     
    
    

}