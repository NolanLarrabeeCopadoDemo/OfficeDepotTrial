trigger CT_BeforeUpdate on Customer_Transition__c (before update) {

    //Variables
     List<Customer_Transition__c> trgCTList = new List<Customer_Transition__c>();
     Set<Id> custTransId= new  Set<Id>();
     Set<String> extAgrmntCTIDs = new  Set<String>();
     Map<Id,String> mapCTidrec= new Map<Id,String>();
     Map<String,String> mapCTdesp= new Map<String,String>();
     date mydate = date.parse('12/01/17');
     List<Id> custId= new  List<Id>();

    //Story 00484614 - Owner Manager's Email related variables
    Map<ID,ID> ownerMap = new Map<ID,ID>();
    Map<ID,User> emailMap = new Map<ID,User>();


   // get the Ids of Split Records
    for (Customer_Transition__c CT : Trigger.New) {


   if ((Trigger.oldMap.get(CT.Id).Written_Agreement_Custom_Core_Request__c != Trigger.newMap.get(CT.Id).Written_Agreement_Custom_Core_Request__c)
        && CT.Written_Agreement_Custom_Core_Request__c=='Create WRF') {
           CT.Written_Core_Request_WRF__c =true;  
        } 




            //start of 00658900
     if (Trigger.oldMap.get(CT.Id).Written_Agreement_Custom_Core_Request__c != Trigger.newMap.get(CT.Id).Written_Agreement_Custom_Core_Request__c){


      //get the person edited and time its edited
      if(CT.Written_Agreement_Custom_Core_Request__c!='')
       CT.Written_Agreement_Custom_Core_Request_By__C= UserInfo.getFirstName()+' '+UserInfo.getLastName()+'   '+ String.valueof( System.Now());
      else
      CT.Written_Agreement_Custom_Core_Request_By__C='';

     }
     //end of 00658900


         //Process Split Creation through batch if no of sites>9999
            if ((Trigger.oldMap.get(CT.Id).Final_Split_Decision__c != Trigger.newMap.get(CT.Id).Final_Split_Decision__c) &&
                CT.Final_Split_Decision__c == 'Yes'  ) {
                    if(CT.No_of_Active_Sites__c  >500){
                      // this will be taken Care by Batch Class
                      CT.BulkSplit__C=true;
                      CT.SplitCreateBatch__C=true;
                    }
               }

    // Cannot remove Ready for Mod 5 Once its set
        if(    (Trigger.oldMap.get(CT.Id).Ready_For_Mod_5__c != CT.Ready_For_Mod_5__c) &&
         Trigger.oldMap.get(CT.Id).Ready_For_Mod_5__c==true && CT.Ready_For_Mod_5__c==false){
         if(!(UserInfo.getUserId()==Label.Salesforce_User_Id))
         CT.Adderror(' Cannot Remove Ready for Mod 5' );
         }

            if (     (CT.Ready_for_Mod1__c == true && !(Trigger.oldMap.get(CT.Id).Ready_for_Mod1__c)) &&
             ( CT.Final_Split_Decision__c == 'Yes' || (CT.omx_primary_key__C != null && CT.omx_primary_key__C.contains('-')) )) {
             custTransId.add(CT.Id);
             trgCTList .add(CT);
        }

    }


  // get the transition detail records where Billing code is B
   if(custTransId.size()>0)
   {
    Mod5BillToKeyClass billToKey = new Mod5BillToKeyClass();
    billToKey .Mod5BillToKeyClassMethod(custTransId,trgCTList );
   }

//By Pass Mod 5
if(executeoncetest.mod5ByPass==true){
    // get the Ids of Split Records
    for (Customer_Transition__c CT : Trigger.New) {

    //Story 00484614 - Owner Manager's Email Update
    if((Trigger.oldMap.get(CT.Id).OwnerID != Trigger.newMap.get(CT.Id).OwnerID) &&
                (CT.OwnerID != null))
        {
        ownerMap.put(CT.ID,CT.OwnerID);
        }

    // Story 00484614
     if (   CT.Customer_Disposition__c !=Trigger.oldMap.get(CT.Id).Customer_Disposition__c &&
      CT.Customer_Disposition__c=='Not my Customer (Please ask DSM to reassign immediately)'
     ){
     CT.Trigger_SalesRep_Change__c=true;
     CT.Trigger_SalesRep_Change_Date__c=System.Today();
     }


        //00498689  Handling RFP Disposition
        if( (CT.Customer_Disposition__c!= Trigger.oldMap.get(CT.Id).Customer_Disposition__c)  &&
        CT.Customer_Disposition__c=='Customer going to RFP'   &&
        CT.Written_Agreement_Customer_No__c==CT.omx_primary_key__C && CT.Ready_for_Mod1__c==false
        ){
        CT.status__c='Awaiting RFP';
        CT.Related_WRF_Case__c=null;
        mapCTidrec.put(CT.Id,CT.Customer_Disposition__c);
        }

        //00498014 Handling OMX Extension Complete Field
        if( (CT.Contract_Extension_Complete__c!= Trigger.oldMap.get(CT.Id).Contract_Extension_Complete__c)  &&
        CT.Contract_Extension_Complete__c==true   &&  CT.Written_Agreement_Customer_No__c==null)
        CT.adderror('OMX Extension Complete can be selected only for Written customer');

        if( (CT.Contract_Extension_Complete__c!= Trigger.oldMap.get(CT.Id).Contract_Extension_Complete__c)  &&
        CT.Contract_Extension_Complete__c==true   &&
        CT.Written_Agreement_Customer_No__c==CT.omx_primary_key__C && CT.Ready_for_Mod1__c==false
        ){
            if(CT.Review_Start_Date__c  == Trigger.oldMap.get(CT.Id).Review_Start_Date__c  ){
             CT.adderror('Please enter a New Review Start Date');
            }
            else{
            CT.status__c='ReScheduled';
            CT.Related_WRF_Case__c=null;
            CT.Customer_Disposition__c=null;
            CT.Customer_Review_Completion_Date__c=System.Today();
            custId.add(CT.Id);
            system.debug('@@@@@IN1');
            }
        }



        //00483547- Driving Lost customer functionality from disposition
        if( (CT.Customer_Disposition__c!= Trigger.oldMap.get(CT.Id).Customer_Disposition__c)  &&
        CT.Customer_Disposition__c=='Lost Customer Account'){
        CT.Customer_Loss__c=true;
        CT.Customer_Transition_Date_to_OD_Systems__c=System.Today();
        }

        //00485560- Driving TOOP
        if( (CT.Customer_Disposition__c!= Trigger.oldMap.get(CT.Id).Customer_Disposition__c)  &&
        CT.Customer_Disposition__c=='Customer already Transitioned'  && CT.Ready_for_Mod1__c==false){
        CT.Review_Start_Date__c=mydate;
        CT.status__c='ReScheduled';
        CT.Related_WRF_Case__c=null;
        system.debug('@@@@IN2');

        }
        // Start of case 00834176 
         if( (CT.Override_TOOP1__c!= Trigger.oldMap.get(CT.Id).Override_TOOP1__c)  &&
         CT.Override_TOOP1__c==true   && CT.status__c=='TOOP'  && CT.Ready_for_Mod1__c==false ){
           executeoncetest.isMod5Launch = true;
           CT.status__c='On Deck';
           CT.On_Deck_Date__C= System.today();
           CT.Customer_Disposition__c='Customer agrees to transition';
           CT.Review_Start_Date__c=system.today();
        }
        
        if( CT.Status__c !='TOOP' && CT.Override_TOOP__c ==true && CT.Override_TOOP1__c==false){
                    CT.adderror( 'You cannot change status from  TOOP ');   

        }
        
        
        /*if(CT.status__c=='TOOP'  &&  (CT.Override_TOOP1__c== Trigger.oldMap.get(CT.Id).Override_TOOP1__c) && 
         !(CT.status__c!= Trigger.oldMap.get(CT.Id).status__c  && CT.status__c=='TOOP')){
            CT.adderror( 'You cannot edit record on TOOP status');   
        }
        */

    // End of case 834176


    // start of 00702909
             if( (CT.status__C!= Trigger.oldMap.get(CT.Id).status__C)  && CT.status__C=='On Deck')
             CT.On_Deck_Date__C= System.today();
             
             //Clear On Deck Date
               if( (CT.status__C!= Trigger.oldMap.get(CT.Id).status__C)  && CT.status__C!='On Deck'  && CT.status__C !='OMX Extension in Development'  && CT.Ready_for_Mod1__c==false)
               CT.On_Deck_Date__C= null;


    //end of 00702909



// Start of Case 00660321

      //Start of 00834176 
           if(   ( CT.Review_Start_Date__c!=  Trigger.oldMap.get(CT.Id).Review_Start_Date__c   ) &&
                 CT.Ready_for_Mod1__c==false  && CT.Review_Start_Date__c!=null  
                 //&& CT.Override_TOOP1__c==false
                 ){                 
                       //end of 00834176 

                   CT.status__c='ReScheduled';
                   system.debug('@@@@IN3');

                 }
          if( CT.status__c=='ReScheduled'  ||   CT.status__c=='Scheduled'  || CT.status__c=='UnScheduled'  )
           CT.Related_WRF_Case__c=null;

// end of Case 00660321

        if(CT.Written_Agreement_Customer_No__c !=null &&  CT.Related_WRF_Case__c==null  && CT.Customer_Disposition__c=='Customer requests delay' &&
                 ( CT.Customer_Disposition__c!=  Trigger.oldMap.get(CT.Id).Customer_Disposition__c )   &&
                 CT.status__c!='UnScheduled'
         ){
            CT.status__c='ReScheduled';
            CT.Review_Start_Date__c= CT.Review_Start_Date__c+60;
            CT.Customer_Disposition__c='';  // Added for the Case 00775618
            system.debug('@@@@IN4');

          }

          if(CT.Written_Agreement_Customer_No__c ==null &&  CT.Customer_Disposition__c=='Customer requests delay' &&
                 ( CT.Customer_Disposition__c!=  Trigger.oldMap.get(CT.Id).Customer_Disposition__c )
         ){
            CT.adderror(' Customer requests delay can be selected only for Written customer');

          }
        if(executeoncetest.extendOMXAgreement)
        {
            executeoncetest.extendOMXAgreement = false;
            //Case#-00498003 & 00511627 - if Rep Customer Disposition change to "Extend current OMX Agreement" Or "Customer RFP Received"
           if((CT.Written_Agreement_Customer_No__c == CT.OMX_Primary_Key__c) && (CT.Customer_Disposition__c=='Extend current OMX Agreement' /*|| CT.Customer_Disposition__c=='Customer RFP Received'*/) &&
                 ( CT.Customer_Disposition__c != Trigger.oldMap.get(CT.Id).Customer_Disposition__c )){
            CT.status__c='OMX Extension in Development';
           /* if(CT.Customer_Disposition__c =='Customer RFP Received')
            {
            CT.status__c='On Deck';
            executeoncetest.isMod5Launch = true;
            }*/
            mapCTdesp.put(CT.OMX_Primary_Key__c,CT.Customer_Disposition__c);
          }
        }
    }

   if(custId.size()>0){
   CT_CascadeStatus ctNewRec= new CT_CascadeStatus();
   ctNewRec.CT_CascadeOMXExtensionComplete(custId);
   }


   //Calling teh RFP Disposition Method
   if(mapCTidrec.size()>0){
   CT_CascadeStatus ctNew= new CT_CascadeStatus();
   ctNew.CT_CascadeStatusmethod (mapCTidrec);
   }



   if((mapCTdesp != null) && (mapCTdesp.size()>0))
   {
    CT_extnsionAgrmnt_cls.setExtAgrmnt(mapCTdesp);
   }
    system.debug('ownerMap@!@'+ownerMap);
   //Story 00484614 - Owner Manager's Email Update
    if(ownerMap != null && ownerMap.size() > 0)
    {
        Set<ID> userIds = new Set<ID>(ownerMap.values());
        system.debug('userIds@!@'+userIds);
        List<User> users = [select id,Manager.Email,Manager.Manager.Email,Manager.Manager.Manager.Email,Manager.Name,Manager.Manager.Name,Manager.Manager.Manager.Name from user where id in :userIds];
        system.debug('users@!@'+users);
        //Preparing Email Map
        for(User eachUser : users)
        {
        emailMap.put(eachUser.ID,eachUser);
        }

        system.debug('emailMap@!@'+emailMap);
        //Updating Email in CT Records
        system.debug('Before-Trigger.New@!@'+Trigger.New);
        for (Customer_Transition__c cust : Trigger.New)
        {
        if(ownerMap.containsKey(cust.ID))
            {
            cust.Account_Manager_Email__c = emailMap.get(ownerMap.get(cust.ID)).Manager.Email ;
            cust.Account_Managers_Manager_Email__c = emailMap.get(ownerMap.get(cust.ID)).Manager.Manager.Email ;
            cust.Account_Managers_Managers_Manager_Email__c = emailMap.get(ownerMap.get(cust.ID)).Manager.Manager.Manager.Email ;

            cust.Account_Manager_Name__c = emailMap.get(ownerMap.get(cust.ID)).Manager.Name ;
            cust.Account_Managers_Manager_Name__c = emailMap.get(ownerMap.get(cust.ID)).Manager.Manager.Name ;
            cust.Account_Managers_Managers_Manager_Name__c = emailMap.get(ownerMap.get(cust.ID)).Manager.Manager.Manager.Name ;
            }
        }
        system.debug('After-Trigger.New@!@'+Trigger.New);
    }


}
}