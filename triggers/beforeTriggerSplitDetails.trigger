// Before Trigger for Updating Billing Account
trigger beforeTriggerSplitDetails on Split_Account_Detail__c(before update) {
    //Variable declarations
    List<Split_Account_Detail__c> splitList= new List<Split_Account_Detail__c>();

    // Get the billing OMX Keys
    for (Split_Account_Detail__c eachCTdtls : Trigger.New) {
     // Prevent Reloading file for Mod 5 Initiated or Launched Records  
     
     //checks currentUser is data loader
     Id currentuserId=UserInfo.getUserId();
      if(eachCTdtls.status__c =='Uploaded'  &&  currentuserId=='005E0000000R7xzIAC' 
       &&
      (eachCTdtls.Original_Account_Mod5_Initiate__C==true ||  eachCTdtls.Original_Account_Launch__c==true) )
      {
      eachCTdtls.addError('Cannot Load Data for Already Launched Mod 5 or Mod 1 Record ');
      }
           
      // Remove Error message if loaded successfully    
       if(eachCTdtls.status__c=='Uploaded')
       eachCTdtls.Error_Message__c='';
      // Add for getting split Data
     if( currentuserId=='005E0000000R7xzIAC' &&
     //trigger.oldMap.get(eachCTdtls .id).status__c!= eachCTdtls.status__c 
      eachCTdtls.status__c =='Uploaded'  &&
      eachCTdtls.Original_Account_Mod5_Initiate__C==false &&  eachCTdtls.Original_Account_Launch__c==false ){
      splitList.add(eachCTdtls); }                                
    }
    if(splitList.size()>0){
    SplitRecordsValidator splitObj= new SplitRecordsValidator ();
    splitObj.createSplitDetails(splitList);
    
    }
  }