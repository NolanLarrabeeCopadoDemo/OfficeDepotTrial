/***********************************************************************************************
Name    : LeadRepQueueAssignment
Created : 9/1/2015 [Hemant]
Story   : S-346406
Desc    : It contains WebService method invoked by the Custom Button 'Next Lead' on Lead object
          It assigns the lead based on the priority from the Queue uisng custom object - Rep Queue Assignment
***********************************************************************************************/
global class LeadRepQueueAssignment {
  
  public static String NO_LEAD_FOUND = 'No lead found for assignment.';
  public static String NO_REP_QUEUE_ASSIGN_RECORD_FOUND = 'No lead to be assigned as queue prirority is not assigned to you.';
  public static Lead ldToBeAssigned; // Get lead to be assigned (to cover code - as owner filed not visible in SOQL)

  /* Method to get the next lead with Newest lead with the highest Lattice lead score using
  priority from the Queue uisng custom object - Rep Queue Assignment */ 
    WebService static String getNextLead(String[] leadIds) {

    List<String> assignedQueuesLst = new List<String>(); 
    for(Rep_Queue_Assignment__c repQ : [Select Id, Queue_Name__c, Sales_Rep__c, Priority__c 
                From Rep_Queue_Assignment__c
                        WHERE Sales_Rep__c != null
                        AND Queue_Name__c != null
                        AND Priority__c != null
                        AND Sales_Rep__c =: UserInfo.getUserId()
                        order by Priority__c asc]){ 
      assignedQueuesLst.add(repQ.Queue_Name__c);
    }
    
    if(assignedQueuesLst.size() > 0){
      boolean ldFound = false;
      
      //Used query in for loop since we need to get the lead on first found basis i.e. if lead found in first queue, then
      //the query will not be fired 
      for(String queName : assignedQueuesLst){
        if(!ldFound){
            for(Lead ld : [select Id, Name 
                                    From Lead
                                    Where Owner.Name =: queName 
                                    order by CreatedDate desc, Lattice_Lead_Score__c desc limit 1]){
              ldToBeAssigned = ld;
                ldFound = true;
                break;
            }
        }else{
            break;
        }
      }
      
      //assign lead to logged in user   
      if(ldToBeAssigned != null){
        ldToBeAssigned.OwnerId = UserInfo.getUserId();
          update ldToBeAssigned;
          //return('The lead ' + ldToBeAssigned.Name + ' is assigned to you.'); //S-418605 [Hemant 6/10/2016] - Return Lead Id
          return(ldToBeAssigned.Id);
        }else{
            return(NO_LEAD_FOUND);
      }
          
    }else{
      return (NO_REP_QUEUE_ASSIGN_RECORD_FOUND);
    }
  }
  

   /* Method to get the next lead with Newest lead with the highest Lattice lead score using
  priority from the Queue uisng custom object - Rep Queue Assignment */
  @AuraEnabled
  WebService static String getNextLeadLightning() {

    List<String> assignedQueuesLst = new List<String>(); 
    for(Rep_Queue_Assignment__c repQ : [Select Id, Queue_Name__c, Sales_Rep__c, Priority__c 
                From Rep_Queue_Assignment__c
                        WHERE Sales_Rep__c != null
                        AND Queue_Name__c != null
                        AND Priority__c != null
                        AND Sales_Rep__c =: UserInfo.getUserId()
                        order by Priority__c asc]){ 
      assignedQueuesLst.add(repQ.Queue_Name__c);
    }
    
    if(assignedQueuesLst.size() > 0){
      boolean ldFound = false;
      
      //Used query in for loop since we need to get the lead on first found basis i.e. if lead found in first queue, then
      //the query will not be fired 
      for(String queName : assignedQueuesLst){
        if(!ldFound){
            for(Lead ld : [select Id, Name 
                                    From Lead
                                    Where Owner.Name =: queName 
                                    order by CreatedDate desc, Lattice_Lead_Score__c desc limit 1]){
              ldToBeAssigned = ld;
                ldFound = true;
                break;
            }
        }else{
            break;
        }
      }
      
      //assign lead to logged in user   
      if(ldToBeAssigned != null){
        ldToBeAssigned.OwnerId = UserInfo.getUserId();
          update ldToBeAssigned;
          //return('The lead ' + ldToBeAssigned.Name + ' is assigned to you.'); //S-418605 [Hemant 6/10/2016] - Return Lead Id
          return(ldToBeAssigned.Id);
        }else{
            return(NO_LEAD_FOUND);
      }
          
    }else{
      return (NO_REP_QUEUE_ASSIGN_RECORD_FOUND);
    }
  }
}