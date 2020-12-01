/***********************************************************************************************
Name    : RepQueueAssignmentController
VF Page : RepQueueAssignment
Created : 8/31/2015 [Hemant]
Story   : S-346407
Desc    : To manage the priority for Rep Queue assignment uisng custom object - Rep Queue Assignment
***********************************************************************************************/
public class RepQueueAssignmentController {

  //Constants
  public String SAVE_ASSIGNMENT_MSG = 'The priorities are saved successfully for the Rep Queue Assignments.';
  public Set<String> allowedProfileSet = new Set<String>{'Inside Sales', 'System Administrator'};

  //Variables
  public transient List<User> SubordinateUsersLst;
  public List<String> leadQueueLst {get;set;}
  public transient List<RepQueueAssignmentCls> rqaClsLst {get;set;}
  private transient Map<Id, Map<String, Rep_Queue_Assignment__c>> existingRepQueueAssignMap;

  //Added for S-429672 (OD 00757398)
   public List<RepQueueAssignmentCls> repAssignWrapper{get; set;} //used on vf page
   public PaginationUtility con {get; set;}
   public Integer selectedPageNumber {get; set;}
   public Map<String, Boolean> repAssignmentExist{get;set;}
   public Boolean isValid {get;set;}
  //End S-429672 (OD 00757398)

  //contructor
  public RepQueueAssignmentController(){
    //added for S-429672 (OD 00757398)
    repAssignWrapper = new List<RepQueueAssignmentCls>();
    con = new PaginationUtility();
    selectedPageNumber = 1;
    repAssignmentExist = new Map<String, Boolean>();
    //end S-429672 (OD 00757398)
    init();
  }

  //Method to initiaze the variables and data collections
  private void init(){
    SubordinateUsersLst = new List<User>();
    //get exitsing lead queues
    leadQueueLst = getLeadQueues();

    //added for  S-429672 (OD 00757398)
    for(String st: leadQueueLst){
        repAssignmentExist.put(st, false);
    }//end  S-429672 (OD 00757398)

    rqaClsLst = new List<RepQueueAssignmentCls>();

    //get Subordinate Users for the logged in user
    //Modified By Vipul Jain for story#S-442661 (00826393 - Rep Queue Assignment Table Enhancement) on 03, October, 2016
    SubordinateUsersLst = getUserSubordinateUsers(UserInfo.getUserId());
	//END- Vipul

    //set the map from the existing data
    setRQADataMap();

    //populate the data in the wrapper cls list
    populateWrapClsData();
  }

  //added for  S-429672 (OD 00757398)
  public List<Boolean> populateQueueAssignmentMap(){

             repAssignmentExist.clear();
             for(String st: leadQueueLst){
                repAssignmentExist.put(st, false);
             }
             for(Rep_Queue_Assignment__c rqA : [Select Priority__c, id, Queue_Name__c
                                                from Rep_Queue_Assignment__c
                                                Where  Queue_Name__c in:leadQueueLst
                                                and Priority__c != null]){
                                                    if(repAssignmentExist.containsKey(rqA.Queue_Name__c)){
                                                        if(!repAssignmentExist.get(rqA.Queue_Name__c)){
                                                            repAssignmentExist.put(rqA.Queue_Name__c, true);
                                                        }
                                                    }
                                                }
         return   repAssignmentExist.values();

  } //end S-429672 (OD 00757398)

  /* Method to populate the data in the wrapper cls list*/
  private void populateWrapClsData(){
    Map<String, Rep_Queue_Assignment__c> queueRQAMap;
    List<Rep_Queue_Assignment__c> repQueLst;

    //loop over Subordinate Users found
    for(User usr : SubordinateUsersLst){

      repQueLst = new List<Rep_Queue_Assignment__c>();

      if(existingRepQueueAssignMap.containsKey(usr.Id)){
        queueRQAMap = existingRepQueueAssignMap.get(usr.Id);
      }else{
        queueRQAMap = new Map<String, Rep_Queue_Assignment__c>();
      }

      //loop over existing lead queues
      for(String ldQName : leadQueueLst){

        if(queueRQAMap.containsKey(ldQName)){
          repQueLst.add(queueRQAMap.get(ldQName));
        }else{
          repQueLst.add(new Rep_Queue_Assignment__c(Sales_Rep__c = usr.Id, Manager__c = UserInfo.getUserId(), Queue_Name__c = ldQName));
        }
      }

      rqaClsLst.add(new RepQueueAssignmentCls(usr.Name, usr.Id, repQueLst));

      //Added for S-429672 (OD 00757398)
         con.pageSize = 50;
         List<Object> tempList = con.setPagination(rqaClsLst);
         if(tempList != null) {
            repAssignWrapper = getWrapperList(tempList);
         } //End S-429672 (OD 00757398)


    }
  }


   //Added for S-429672 (OD 00757398)
     private List<RepQueueAssignmentCls> getWrapperList(List<Object> currentList) {


         if(repAssignWrapper != null)
         repAssignWrapper.clear();

        for(Object obj : currentList) {
            repAssignWrapper.add((RepQueueAssignmentCls)obj);
        }
        return repAssignWrapper;
    }

    public PageReference getList() {

        repAssignWrapper = getWrapperList(con.getPage(selectedPageNumber));
        return null;
    }

    public List<Integer> listOfLinks {
        get {
            return con.listOfLinks;
        }
    }

    public boolean isMorePrevious {
        get {
            return con.isMorePrevious;
        }
    }

    public boolean isMoreNext {
        get {
            return con.isMoreNext;
        }
    }

    public Integer totalPage {
        get {
            return con.totalPage;
        }
    }

    //End S-429672 (OD 00757398)

  /* Method to populate the existingRepQueueAssignMap from existing RQA object data */
  private void setRQADataMap(){

    existingRepQueueAssignMap = new Map<Id, Map<String, Rep_Queue_Assignment__c>>();

    for(Rep_Queue_Assignment__c repQ : [Select Id, Queue_Name__c, Sales_Rep__c, Priority__c
        From Rep_Queue_Assignment__c
        WHERE Sales_Rep__c IN: SubordinateUsersLst
        AND Sales_Rep__c != null
        AND Queue_Name__c != null
        order by Sales_Rep__c]){

      if(!existingRepQueueAssignMap.containsKey(repQ.Sales_Rep__c)){
        existingRepQueueAssignMap.put(repQ.Sales_Rep__c, new Map<String, Rep_Queue_Assignment__c>());
      }
      existingRepQueueAssignMap.get(repQ.Sales_Rep__c).put(repQ.Queue_Name__c, repQ);
    }
  }

  /* Method to return the list of the existing Lead Queues*/
  public List<String> getLeadQueues(){
    List<String> ldqueueLst = new List<String>();

    for(QueueSobject ldQueue : [Select Id, SobjectType, QueueId, Queue.Name, Queue.email from QueueSobject
                        where SobjectType = 'Lead' order by Queue.Name]){
      ldqueueLst.add(ldQueue.Queue.Name);
    }
    return ldqueueLst;
  }


  /* Method to save (upsert) the data in the RQA custom object from the priority assignment done in table on the page
  */
  public PageReference save(){
    Savepoint sp = Database.setSavepoint();

    List<Rep_Queue_Assignment__c> repQueueAssignLst = new List<Rep_Queue_Assignment__c>();


    //Modified below line for S-429672 (OD 00757398)
    for(RepQueueAssignmentCls rqaClsItem :repAssignWrapper){

      for(Integer num=0; num < leadQueueLst.size(); num++){

        String prt = rqaClsItem.repQueAssignmentLst.get(num).Priority__c;

        if((prt != null && prt !='') || rqaClsItem.repQueAssignmentLst.get(num).Id != null){
          repQueueAssignLst.add(rqaClsItem.repQueAssignmentLst.get(num));
        }
      }

    }

     //Modified for S-429672 (OD 00757398)


    try{
      //upsert Rep_Queue_Assignment__c list
      if(repQueueAssignLst.size() > 0){
        upsert repQueueAssignLst;

        isValid = true;
        List<Boolean> isPriorityExist = populateQueueAssignmentMap();

        for( Boolean b: isPriorityExist){
            isValid = b && isValid;
        }

        if(!isValid){
            Database.rollback(sp);
            Apexpages.addMessage(new ApexPages.Message(ApexPages.severity.Error, 'Each queue must have atleat one rep priority assigned.'));
            return null;
        }
        //end S-429672 (OD 00757398)
        Apexpages.addMessage(new ApexPages.Message(ApexPages.severity.INFO, SAVE_ASSIGNMENT_MSG));
      }
    }
    catch(Exception ex){
      Database.rollback(sp);
      Apexpages.addMessages(ex);
    }

    return null;
  }

  /* Cancel method to return to home page */
  public PageReference Cancel(){
    return new PageReference ('/home/home.jsp');
  }

  //COmmented By Vipul Jain for story#S-442661 (00826393 - Rep Queue Assignment Table Enhancement) on 03, October, 2016
  /* Method to return the list of the Role Subordinate Users for the user Id passed */
  /*public List<User> getRoleSubordinateUsers(Id userId) {

    // get requested user's role
    Id roleId;
    for(User usr : [select UserRoleId from User where Id = :userId]){
      roleId = usr.UserRoleId;
    }
    if(roleId != null){
      // get all of the roles underneath the user
      Set<Id> allSubRoleIds = getAllSubRoleIds(new Set<ID>{roleId});
      // get all of the ids for the users in those roles
      Map<Id,User> users = new Map<Id, User>([Select Id, Name From User where
        UserRoleId IN :allSubRoleIds
        //COmmented By Vipul Jain for story#S-442661 (00826393 - Rep Queue Assignment Table Enhancement) on 03, October, 2016
        //AND UserRole.Name LIKE '%Rep%'
        AND Profile.Name IN: allowedProfileSet
        AND IsActive = true order by Name]);
      // return the ids as a set so you can do what you want with them
      return users.values();
    }
    return (new List<User>());
  }

 /* Method to get all the sub roles ids for passed set of role id */
  /*private Set<ID> getAllSubRoleIds(Set<ID> roleIds) {

    Set<ID> currentRoleIds = new Set<ID>();

    // get all of the roles underneath the passed roles
    for(UserRole userRole :[select Id from UserRole where ParentRoleId
      IN :roleIds AND ParentRoleID != null])
    currentRoleIds.add(userRole.Id);

    // go fetch some more rolls!
    if(currentRoleIds.size() > 0)
      currentRoleIds.addAll(getAllSubRoleIds(currentRoleIds));

    return currentRoleIds;

  }*/
  //END -Vipul
  //Created By Vipul Jain for story#S-442661 (00826393 - Rep Queue Assignment Table Enhancement) on 03, October, 2016
  public List<User> getUserSubordinateUsers(Id userId) {
	   Id userSubordinateId;
	   //get user's Name
	   User loginuser = [Select Id, Name from User where Id=:userId];
	   //Flag to check that User is any one in the Custom Metadata 'Rep_Queue_Assignment_Users__mdt' or not
	   Boolean Flag = true;
	   List<Rep_Queue_Assignment_Users__mdt> repQueueList= new List<Rep_Queue_Assignment_Users__mdt>();
	   // compare the logged user Name with Names is 'Rep_Queue_Assignment_Users__mdt
	   for (Rep_Queue_Assignment_Users__mdt repQueueUser:[SELECT MasterLabel, DeveloperName, Id from Rep_Queue_Assignment_Users__mdt]){
	   		if(repQueueUser.MasterLabel == loginuser.Name){
	   			Flag = false;
	   		}

   		}

		if(userId != null){
	      Set<Id> allSubUsereIds = getAllSubUserIds(new Set<ID>{userId}, Flag);
	      Map<Id,User> users = new Map<Id, User>([Select Id, Name From User where Id IN :allSubUsereIds
	        //AND Profile.Name IN: allowedProfileSet
	        AND IsActive = true order by Name]);

	      return users.values();
	    }
	    return (new List<User>());
  }
  //Method to get the reportees and its heirarchy for a particular User
  private Set<ID> getAllSubUserIds(Set<ID> userIds, Boolean flag) {

	    Set<ID> currentUserIds = new Set<ID>();
	    for(User subUser :[select Id from User where ManagerId =: userIds])
	    	currentUserIds.add(subUser.Id);
	    //Check other levels for User Hierarchy
	    if(currentUserIds.size() > 0 && flag)
	     	currentUserIds.addAll(getAllSubUserIds(currentUserIds, flag));
	    return currentUserIds;

  }
  //END-Vipul


  //Wrapper cls to show the data on the VF page
  public class RepQueueAssignmentCls{

    public String userName{get;set;}
    public String userId {get;set;}
    public List<Rep_Queue_Assignment__c> repQueAssignmentLst{get;set;}

    public RepQueueAssignmentCls(String uName, String uid, List<Rep_Queue_Assignment__c> rqaLst){
      userName = uName;
      userId = uId;
      repQueAssignmentLst = rqaLst;
    }
  }
}