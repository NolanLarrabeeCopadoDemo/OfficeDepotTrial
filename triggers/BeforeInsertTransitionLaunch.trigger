//This code will update the Customer Transition
trigger BeforeInsertTransitionLaunch on Transition_Launch__c (before insert) {

List<String> omx= new List<String>();
List<Transition_Launch__c  > transList = new List<Transition_Launch__c  >();

  for(Transition_Launch__c  rec : Trigger.New){
      omx.add(rec.OMX_Key__c);
  }
  List< Customer_transition__C> cust=[Select OMX_Primary_Key__c ,Id, Parent_Transition_ID__c,Parent_Transition_ID__r.Ready_for_Mod1__c,
  Parent_Transition_ID__r.Customer_Transition_Type__c,Parent_Transition_ID__r.OMX_Primary_Key__c ,
  Customer_Transition_Type__c
  from Customer_transition__C
  where OMX_Primary_Key__c in:omx];
  
  TransitionLaunchCls tranLaunchObj= new TransitionLaunchCls();
  
  transList = tranLaunchObj.tranLaunchMethod(cust,Trigger.New);

  if(transList != null && transList.size()>0)
  upsert transList OMX_Key__c;
  
  system.debug('@@ transList@@@'+transList);
  system.debug('@@Trigger.New@@@'+Trigger.New);
  
}