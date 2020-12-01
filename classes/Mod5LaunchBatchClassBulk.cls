Global class Mod5LaunchBatchClassBulk implements database.Batchable<Sobject>,Database.Stateful,Schedulable
{

    global String strQuery; //this variable used to set query from test class or from shceduler if required
    // Below is set a default query in case not set in test class or in scheduler
    private String DEFAULT_QUERY ='Select Id,Parent_Transition_ID__c, Parent_Transition_ID__r.Ready_for_Mod1__c,Parent_Transition_ID__r.Customer_Transition_Type__c,Parent_Transition_ID__r.omx_primary_key__C,omx_primary_key__C,No_of_Active_Sites__c,CountLaunchError__c'
                                   +' FROM Customer_Transition__c '
                                   +'WHERE MOD5_Ready_To_Launch__c = true  and BulkSplit__C=true Limit 1';
    /* Default Constructor*/
    global Mod5LaunchBatchClassBulk ()
    {
        this.strQuery = DEFAULT_QUERY;
    }
    /*This costructor is called from the Batch Schedule method*/
    global Mod5LaunchBatchClassBulk (String query)
    {
        System.debug('QUERY IS---->'+query);
        if(query != null && query != '')
        {
            this.strQuery = query;
        }
        else
        {
            this.strQuery = DEFAULT_QUERY;
        }
    system.debug('strQuery@@@'+strQuery);
    }
    /* This method prepares the scope of the batch program based on the query result */
    global Database.QueryLocator start(Database.BatchableContext BC)
    {
        system.debug('strQuery@@@'+strQuery);
        return Database.getQueryLocator(strQuery);
    }
     /* This method processes query result in batches */
    global void execute(Database.BatchableContext BC, SObject[] scope)
    {
        List<Customer_Transition__c > splitrecs = scope;
        system.debug('>>>scope Count>>>>'+splitrecs.size());
        system.debug('>>>scope>>>>'+scope);
        List<String> accomxid= new List<String>();
         Set<String> accomxidChild= new Set<String>();

          if(splitrecs.size()>0){
                  for(Customer_Transition__c  sad : splitrecs){
                    accomxid.add(sad.omx_primary_key__c);
                  }

                  String currentKey=accomxid[0];

                  integer activesites= [select count() from Split_Account_Detail__c
                                               WHERE OMX_ACCOUNT__c = :currentKey ];


                                    integer currenterror=0;
                  if(splitrecs[0].CountLaunchError__c!=null)
                  currenterror=Integer.valueOf(splitrecs[0].CountLaunchError__c);

                  String ParentError=' ';
                  String OriginalAccountError=' ';
                  String childAccountError=' ';
                  String childError=' ';
                  integer countError=0;
                  String FinalError=' ';

                 List<Id> Launchlist = new List<Id>();
                 Map< Id,Id> transitionMap= new Map< Id,Id>();
                 List<Split_Account_Detail__c > splitRecUpdate  = new List<Split_Account_Detail__c > ();
                  Map< String,String> errorMap= new Map< String,String>();


                         for(Split_Account_Detail__c sadtls : [Select Id,
                                               Customer_Transition__r.Parent_Transition_ID__c,
                                               Customer_Transition__r.Parent_Transition_ID__r.omx_primary_key__C,
                                                Customer_Transition__r.Parent_Transition_ID__r.Ready_for_Mod1__c,
                                                Customer_Transition__r.Parent_Transition_ID__r.Final_Split_Decision__c,
                                                Customer_Transition__r.Parent_Transition_ID__r.account__r.ownerId,
                                                Customer_Transition__r.Parent_Transition_ID__r.account__r.owner.IsActive,
                                                Customer_Transition__r.Parent_Transition_ID__r.Account_Splitting_Required_frmla__c,
                                                Customer_Transition__r.Parent_Transition_ID__r.account__r.status__c,
                                                Customer_Transition__r.Parent_Transition_ID__r.account__r.Sales_PersonID__c,
                                                Customer_Transition__r.Parent_Transition_ID__r.Account__r.Segment__c,
                                                Customer_Transition__r.Parent_Transition_ID__r.account__r.Sales_PersonID__r.name,
                                                Customer_Transition__r.Parent_Transition_ID__r.account__r.OMX_Mainframe_Account_Level__c,
                                                Customer_Transition__r.Parent_Transition_ID__r.AOPS_Flag__c,
                                                Customer_Transition__r.Parent_Transition_ID__r.status__C,
                                                Customer_Transition__r.Parent_Transition_ID__r.transition_status__C,
                                                Customer_Transition__r.Parent_Transition_ID__r.Written_Agreement_Customer_No__c,
                                                Customer_Transition__r.Parent_Transition_ID__r.Customer_Transition_Type__c,
                                                Customer_Transition__r.Parent_Transition_ID__r.Customer_Go_Live_Target_Date__c,
                                                Customer_Transition__r.Parent_Transition_ID__r.Override_Administrative_close__c,
                                                Customer_Transition__r.Parent_Transition_ID__r.Override_Loss_of_Customer__c, // case number 00658908
                                                Customer_Transition__r.Parent_Transition_ID__r.Customer_Transition_Type2__c,                //Added for Case# 00674130
                                                Customer_Transition__r.Parent_Transition_ID__r.Written_Agreement__c,                        //Added for Case# 00674130
                                                Customer_Transition__r.Parent_Transition_ID__r.Local_Core__c,                               //Added for Case# 00674130
                                                Customer_Transition__r.Parent_Transition_ID__r.Written_Agreement_Custom_Core_Request__c,    //Added for Case# 00674130


                                                Customer_Transition__c,Customer_Transition__r.omx_primary_key__C,
                                                Customer_Transition__r.Ready_for_Mod1__c, Customer_Transition__r.Final_Split_Decision__c,
                                                Customer_Transition__r.account__r.ownerId,
                                                Customer_Transition__r.account__r.owner.IsActive,
                                                Customer_Transition__r.Account_Splitting_Required_frmla__c,Customer_Transition__r.account__r.status__c,
                                                Customer_Transition__r.account__r.Sales_PersonID__c,
                                                Customer_Transition__r.Account__r.Segment__c,
                                                Customer_Transition__r.account__r.Sales_PersonID__r.name,
                                                Customer_Transition__r.account__r.OMX_Mainframe_Account_Level__c,
                                                Customer_Transition__r.AOPS_Flag__c,
                                                Customer_Transition__r.status__C,
                                                Customer_Transition__r.transition_status__C,
                                                Customer_Transition__r.Written_Agreement_Customer_No__c,
                                                Customer_Transition__r.Customer_Go_Live_Target_Date__c,
                                                Customer_Transition__r.Override_Administrative_close__c,
                                                Customer_Transition__r.Override_Loss_of_Customer__c , // case number 00658908
                                                Customer_Transition__r.Customer_Transition_Type2__c,                //Added for Case# 00674130
                                                Customer_Transition__r.Written_Agreement__c,                        //Added for Case# 00674130
                                                Customer_Transition__r.Local_Core__c,                               //Added for Case# 00674130
                                                Customer_Transition__r.Written_Agreement_Custom_Core_Request__c,    //Added for Case# 00674130


                                               Linked_Customer_Transition__c,
                                               Linked_Customer_Transition__r.omx_primary_key__C,
                                               Linked_Customer_Transition__r.Ready_for_Mod1__c,
                                               Linked_Customer_Transition__r.Final_Split_Decision__c,
                                               Linked_Customer_Transition__r.account__r.ownerId,
                                               Linked_Customer_Transition__r.account__r.owner.IsActive,
                                               Linked_Customer_Transition__r.Account_Splitting_Required_frmla__c,
                                               Linked_Customer_Transition__r.account__r.status__c,
                                               Linked_Customer_Transition__r.account__r.Sales_PersonID__c,
                                               Linked_Customer_Transition__r.Account__r.Segment__c,
                                               Linked_Customer_Transition__r.account__r.Sales_PersonID__r.name,
                                               Linked_Customer_Transition__r.account__r.OMX_Mainframe_Account_Level__c,
                                               Linked_Customer_Transition__r.AOPS_Flag__c,
                                               Linked_Customer_Transition__r.status__C,
                                               Linked_Customer_Transition__r.transition_status__C,
                                               Linked_Customer_Transition__r.Written_Agreement_Customer_No__c,
                                               Linked_Customer_Transition__r.Customer_Go_Live_Target_Date__c,
                                               Linked_Customer_Transition__r.Override_Administrative_close__c,
                                               Linked_Customer_Transition__r.Override_Loss_of_Customer__c , // case number 00658908
                                               Linked_Customer_Transition__r.Customer_Transition_Type2__c,                //Added for Case# 00674130
                                               Linked_Customer_Transition__r.Written_Agreement__c,                        //Added for Case# 00674130
                                               Linked_Customer_Transition__r.Local_Core__c,                               //Added for Case# 00674130
                                               Linked_Customer_Transition__r.Written_Agreement_Custom_Core_Request__c,    //Added for Case# 00674130

                                               Master_Account__c,status__c
                                               FROM Split_Account_Detail__c
                                               WHERE OMX_ACCOUNT__c = :currentKey and BulkLaunchProcessed__c=false Limit 1000]){


                                                                                   system.debug('Inside Loop&&&&&&&&&&&&&');



               childError=' ';

                                  // For Checking Parent
                                                system.debug('^^^^^'+sadtls.Customer_Transition__r.Parent_Transition_ID__c+'~~~~~'+sadtls.Customer_Transition__r.Parent_Transition_ID__r.Ready_for_Mod1__c+'????'+ParentError);
                                                if(sadtls.Customer_Transition__r.Parent_Transition_ID__c !=null && sadtls.Customer_Transition__r.Parent_Transition_ID__r.Ready_for_Mod1__c==false && ParentError  ==' '  &&  sadtls.Customer_Transition__r.Parent_Transition_ID__r.Customer_Transition_Type__c=='Parent'){

                                                 system.debug('>>>>transitionMap>>>>'+transitionMap);
                                                 if(!transitionMap.containsKey(sadtls.Customer_Transition__r.Parent_Transition_ID__c)){
                                                           transitionMap.put(sadtls.Customer_Transition__r.Parent_Transition_ID__c,sadtls.Customer_Transition__r.Parent_Transition_ID__c);
                                                           Launchlist.add(sadtls.Customer_Transition__r.Parent_Transition_ID__c);


                                                        //Adding Override Administrative close for Case No 00574414
                                                        system.debug('>>>>>parentacc>>>>>'+sadtls.Customer_Transition__r.Parent_Transition_ID__r.Account__c);
                                                        if( ( (sadtls.Customer_Transition__r.Parent_Transition_ID__r.Status__c !='On Deck'   &&  sadtls.Customer_Transition__r.Parent_Transition_ID__r.Written_Agreement_Customer_No__c==null)
                                                             ||
                                                          (sadtls.Customer_Transition__r.Parent_Transition_ID__r.Written_Agreement_Customer_No__c!=null &&

                                                                  sadtls.Customer_Transition__r.Parent_Transition_ID__r.status__c != 'ODP Agreement in Development'
                                                                  && sadtls.Customer_Transition__r.Parent_Transition_ID__r.status__c != 'OMX Extension in Development'
                                                                  && sadtls.Customer_Transition__r.Parent_Transition_ID__r.status__c != 'ODP Agreement Complete'
                                                                   && sadtls.Customer_Transition__r.Parent_Transition_ID__r.status__c != 'On Deck'
                                                                  ) )&&
                                                                  (!(sadtls.Customer_Transition__r.Parent_Transition_ID__r.Status__c =='Administrative Close'  && sadtls.Customer_Transition__r.Parent_Transition_ID__r.Override_Administrative_close__c == true))
                                                                   //Start Changes for Case No 00658908
                                                                  && (!(sadtls.Customer_Transition__r.Parent_Transition_ID__r.status__c == 'Loss of Customer' && sadtls.Customer_Transition__r.Parent_Transition_ID__r.Override_Loss_of_Customer__c == true))
                                                                  //End Changes for Case No 00658908

                                                         )
                                                        ParentError  =ParentError  +sadtls.Customer_Transition__r.Parent_Transition_ID__r.omx_primary_key__C+ ' Not in Valid status for Launching' + ' , ' ;


                                                        if(sadtls.Customer_Transition__r.Parent_Transition_ID__r.account__r.Sales_PersonID__c==null)
                                                        ParentError  =ParentError  +sadtls.Customer_Transition__r.Parent_Transition_ID__r.omx_primary_key__C+ ' Sales Person ID is \'NULL\'' + ' , ' ;


                                                        if(sadtls.Customer_Transition__r.Parent_Transition_ID__r.account__r.Sales_PersonID__r.name=='Awaiting SalesID' || sadtls.Customer_Transition__r.Parent_Transition_ID__r.account__r.Sales_PersonID__r.name=='D7873'   )
                                                        ParentError  =ParentError  +sadtls.Customer_Transition__r.Parent_Transition_ID__r.omx_primary_key__C+ ' Sales Person ID is \'INVALID\'' + ' , ' ;


                                                        if(sadtls.Customer_Transition__r.Parent_Transition_ID__r.account__r.status__c !='Active')
                                                        ParentError  =ParentError  +sadtls.Customer_Transition__r.Parent_Transition_ID__r.omx_primary_key__C+' Account is not Active' + ' , ' ;

                                                        if(sadtls.Customer_Transition__r.Parent_Transition_ID__r.account__r.owner.IsActive !=true)
                                                        ParentError  =ParentError  +sadtls.Customer_Transition__r.Parent_Transition_ID__r.omx_primary_key__C+ ' Account Owner is not Active' + ' , ' ;


                                                        if((sadtls.Customer_Transition__r.Parent_Transition_ID__r.account__r.OMX_Mainframe_Account_Level__c == 'Main Account')
                                                        &&(sadtls.Customer_Transition__r.Parent_Transition_ID__r.Transition_Status__c !='Active'))
                                                        ParentError  =ParentError  +sadtls.Customer_Transition__r.Parent_Transition_ID__r.omx_primary_key__C+ ' Transition Status is not Active' + ' , ' ;


                                                        if ((sadtls.Customer_Transition__r.Parent_Transition_ID__r.Final_Split_Decision__c ==''  || sadtls.Customer_Transition__r.Parent_Transition_ID__r.Final_Split_Decision__c ==null ) &&   sadtls.Customer_Transition__r.Parent_Transition_ID__r.Account_Splitting_Required_frmla__c=='Yes')
                                                        ParentError  =ParentError  +sadtls.Customer_Transition__r.Parent_Transition_ID__r.omx_primary_key__C+' Final Split Decision is \'Blank\''+' , ' ;



                                                        if((sadtls.Customer_Transition__r.Parent_Transition_ID__r.account__r.OMX_Mainframe_Account_Level__c == 'Main Account')
                                                        &&(sadtls.Customer_Transition__r.Parent_Transition_ID__r.AOPS_Flag__c!='Y'))
                                                        ParentError  =ParentError  +sadtls.Customer_Transition__r.Parent_Transition_ID__r.omx_primary_key__C+ ' AOPS Flag is not \'Y\'' + ' , ' ;


                                                        if(sadtls.Customer_Transition__r.Parent_Transition_ID__r.Account__r.Segment__c==null)
                                                        ParentError  =ParentError  +sadtls.Customer_Transition__r.Parent_Transition_ID__r.omx_primary_key__C+' Segment is \'NULL\'' + ' , ' ;


                                                        if(sadtls.Customer_Transition__r.Parent_Transition_ID__r.Account__r.Segment__c=='Other')
                                                        ParentError  =ParentError  +sadtls.Customer_Transition__r.Parent_Transition_ID__r.omx_primary_key__C+' Segment is \'Other\'' + ' , ' ;


                                                        if(string.valueof(sadtls.Customer_Transition__r.Parent_Transition_ID__r.Account__r.ownerid).substring(0,15)==System.Label.salesforce)
                                                        ParentError  =ParentError  +sadtls.Customer_Transition__r.Parent_Transition_ID__r.omx_primary_key__C+' Owner is \'Salesforce\'' + ' , ' ;

                                                        if(string.valueof(sadtls.Customer_Transition__r.Parent_Transition_ID__r.Account__r.ownerid).substring(0,15)==System.Label.SalesforceDataloaderNorth)
                                                        ParentError  =ParentError  +sadtls.Customer_Transition__r.Parent_Transition_ID__r.omx_primary_key__C+' Owner is \'Salesforce DataLoader North\'' + ' , ' ;

                                                        // start changes for case No 00674130
                                                        if((sadtls.Customer_Transition__r.Parent_Transition_ID__r.Customer_Transition_Type2__c == 'Standalone' || sadtls.Customer_Transition__r.Parent_Transition_ID__r.Customer_Transition_Type2__c == 'Child') && sadtls.Customer_Transition__r.Parent_Transition_ID__r.Written_Agreement__c == true && sadtls.Customer_Transition__r.Parent_Transition_ID__r.Local_Core__c == true && (sadtls.Customer_Transition__r.Parent_Transition_ID__r.Written_Agreement_Custom_Core_Request__c == '' || sadtls.Customer_Transition__r.Parent_Transition_ID__r.Written_Agreement_Custom_Core_Request__c == null) )
                                                        ParentError=ParentError+'Written Agreement Custom Core Request is required' + ' , ' ;
                                                        //End Changes for Case No 00674130

                                                  }

                                                  }


                                             System.debug('&&&&&&&&ParentError  '+ParentError  );

                                               // for Original Account

                                               if(sadtls.Customer_Transition__c !=null && sadtls.Customer_Transition__r.Ready_for_Mod1__c==false && OriginalAccountError  ==' '){


                                                                  if(!transitionMap.containsKey(sadtls.Customer_Transition__c)){
                                                                           transitionMap.put(sadtls.Customer_Transition__c,sadtls.Customer_Transition__c);
                                                                           Launchlist.add(sadtls.Customer_Transition__c);


                                                                    //Adding Override Administrative close for Case No 00574414
                                                                        if(  ((sadtls.Customer_Transition__r.Status__c !='On Deck'   &&  sadtls.Customer_Transition__r.Written_Agreement_Customer_No__c==null)
                                                                             ||
                                                                          (sadtls.Customer_Transition__r.Written_Agreement_Customer_No__c!=null &&

                                                                                  sadtls.Customer_Transition__r.status__c != 'ODP Agreement in Development'
                                                                                  && sadtls.Customer_Transition__r.status__c != 'OMX Extension in Development'
                                                                                  && sadtls.Customer_Transition__r.status__c != 'ODP Agreement Complete'
                                                                                  && sadtls.Customer_Transition__r.status__c != 'On Deck'
                                                                                  ) )
                                                                                  && (!(sadtls.Customer_Transition__r.Status__c =='Administrative Close'  && sadtls.Customer_Transition__r.Override_Administrative_close__c == true))
                                                                                   //Start Changes for Case No 00658908
                                                                  &&(! (sadtls.Customer_Transition__r.status__c == 'Loss of Customer' && sadtls.Customer_Transition__r.Override_Loss_of_Customer__c == true))
                                                                  //End Changes for Case No 00658908

                                                                         )
                                                                        OriginalAccountError  =OriginalAccountError  +sadtls.Customer_Transition__r.omx_primary_key__C+ ' Not in Valid status for Launching' + ' , ' ;


                                                                        if(sadtls.Customer_Transition__r.account__r.Sales_PersonID__c==null)
                                                                        OriginalAccountError  =OriginalAccountError  +sadtls.Customer_Transition__r.omx_primary_key__C+ ' Sales Person ID is \'NULL\'' + ' , ' ;


                                                                        if(sadtls.Customer_Transition__r.account__r.Sales_PersonID__r.name=='Awaiting SalesID' || sadtls.Customer_Transition__r.account__r.Sales_PersonID__r.name=='D7873'   )
                                                                        OriginalAccountError  =OriginalAccountError  +sadtls.Customer_Transition__r.omx_primary_key__C+ ' Sales Person ID is \'INVALID\'' + ' , ' ;


                                                                        if(sadtls.Customer_Transition__r.account__r.status__c !='Active')
                                                                        OriginalAccountError  =OriginalAccountError  +sadtls.Customer_Transition__r.omx_primary_key__C+' Account is not Active' + ' , ' ;

                                                                        if(sadtls.Customer_Transition__r.account__r.owner.IsActive !=true)
                                                                        OriginalAccountError  =OriginalAccountError  +sadtls.Customer_Transition__r.omx_primary_key__C+ ' Account Owner is not Active' + ' , ' ;


                                                                        if((sadtls.Customer_Transition__r.account__r.OMX_Mainframe_Account_Level__c == 'Main Account')
                                                                        &&(sadtls.Customer_Transition__r.Transition_Status__c !='Active'))
                                                                        OriginalAccountError  =OriginalAccountError  +sadtls.Customer_Transition__r.omx_primary_key__C+ ' Transition Status is not Active' + ' , ' ;


                                                                        if ((sadtls.Customer_Transition__r.Final_Split_Decision__c ==''  || sadtls.Customer_Transition__r.Final_Split_Decision__c ==null ) &&   sadtls.Customer_Transition__r.Account_Splitting_Required_frmla__c=='Yes')
                                                                        OriginalAccountError  =OriginalAccountError  +sadtls.Customer_Transition__r.omx_primary_key__C+' Final Split Decision is \'Blank\''+' , ' ;



                                                                        if((sadtls.Customer_Transition__r.account__r.OMX_Mainframe_Account_Level__c == 'Main Account')
                                                                        &&(sadtls.Customer_Transition__r.AOPS_Flag__c!='Y'))
                                                                        OriginalAccountError  =OriginalAccountError  +sadtls.Customer_Transition__r.omx_primary_key__C+ ' AOPS Flag is not \'Y\'' + ' , ' ;


                                                                        if(sadtls.Customer_Transition__r.Account__r.Segment__c==null)
                                                                        OriginalAccountError  =OriginalAccountError  +sadtls.Customer_Transition__r.omx_primary_key__C+' Segment is \'NULL\'' + ' , ' ;


                                                                        if(sadtls.Customer_Transition__r.Account__r.Segment__c=='Other')
                                                                        OriginalAccountError  =OriginalAccountError  +sadtls.Customer_Transition__r.omx_primary_key__C+' Segment is \'Other\'' + ' , ' ;


                                                                        if(string.valueof(sadtls.Customer_Transition__r.Account__r.ownerid).substring(0,15)==System.Label.salesforce)
                                                                        OriginalAccountError  =OriginalAccountError  +sadtls.Customer_Transition__r.omx_primary_key__C+' Owner is \'Salesforce\'' + ' , ' ;

                                                                        if(string.valueof(sadtls.Customer_Transition__r.Account__r.ownerid).substring(0,15)==System.Label.SalesforceDataloaderNorth)
                                                                        OriginalAccountError  =OriginalAccountError  +sadtls.Customer_Transition__r.omx_primary_key__C+' Owner is \'Salesforce DataLoader North\'' + ' , ' ;

                                                                        // start changes for case No 00674130
                                                                       if((sadtls.Customer_Transition__r.Customer_Transition_Type2__c == 'Standalone' || sadtls.Customer_Transition__r.Customer_Transition_Type2__c == 'Child') && sadtls.Customer_Transition__r.Written_Agreement__c == true && sadtls.Customer_Transition__r.Local_Core__c == true && (sadtls.Customer_Transition__r.Written_Agreement_Custom_Core_Request__c == '' || sadtls.Customer_Transition__r.Written_Agreement_Custom_Core_Request__c == null) )
                                                                        OriginalAccountError = OriginalAccountError  +'Written Agreement Custom Core Request is required' + ' , ' ;
                                                                        // End changes for case No 00674130
                                                                  }
                                                  }
                                              System.debug('&&&&&&&&OriginalAccountError  '+OriginalAccountError  );

                                           //for Individual accounts
                                           if(sadtls.Linked_Customer_Transition__c!=null){

                                                   if(!accomxidChild.contains(sadtls.Master_Account__c)){
                                                   accomxidChild.add(sadtls.Master_Account__c);



                                                  if( sadtls.Linked_Customer_Transition__r.Ready_for_Mod1__c==false ){


                                                      if(!transitionMap.containsKey(sadtls.Linked_Customer_Transition__c)){
                                                           transitionMap.put(sadtls.Linked_Customer_Transition__c,sadtls.Linked_Customer_Transition__c);
                                                           Launchlist.add(sadtls.Linked_Customer_Transition__c);
                                                           }


                                                        //Adding Override Administrative close for Case No 00574414
                                                        if( ( (sadtls.Linked_Customer_Transition__r.Status__c !='On Deck'   &&  sadtls.Linked_Customer_Transition__r.Written_Agreement_Customer_No__c==null)
                                                             ||
                                                          (sadtls.Linked_Customer_Transition__r.Written_Agreement_Customer_No__c!=null &&

                                                                  sadtls.Linked_Customer_Transition__r.status__c != 'ODP Agreement in Development'
                                                                  && sadtls.Linked_Customer_Transition__r.status__c != 'OMX Extension in Development'
                                                                  && sadtls.Linked_Customer_Transition__r.status__c != 'ODP Agreement Complete'
                                                                   && sadtls.Linked_Customer_Transition__r.Status__c != 'On Deck'
                                                                  ) )
                                                                  && (!(sadtls.Linked_Customer_Transition__r.Status__c =='Administrative Close'  && sadtls.Linked_Customer_Transition__r.Override_Administrative_close__c == true))
                                                                   //Start Changes for Case No 00658908
                                                                  && (!(sadtls.Linked_Customer_Transition__r.status__c == 'Loss of Customer' && sadtls.Linked_Customer_Transition__r.Override_Loss_of_Customer__c == true))
                                                                  //End Changes for Case No 00658908

                                                         ){
                                                      //  childAccountError  =childAccountError  +sadtls.Linked_Customer_Transition__r.omx_primary_key__C+ ' Not in Valid status for Launching' + ' , ' ;
                                                        childError  =childError  +sadtls.Linked_Customer_Transition__r.omx_primary_key__C+ ' Not in Valid status for Launching' + ' , ' ;

                                                        }


                                                        if(sadtls.Linked_Customer_Transition__r.account__r.Sales_PersonID__c==null){
                                                        //childAccountError  =childAccountError  +sadtls.Linked_Customer_Transition__r.omx_primary_key__C+ ' Sales Person ID is \'NULL\'' + ' , ' ;
                                                        childError  =childError  +sadtls.Linked_Customer_Transition__r.omx_primary_key__C+ ' Sales Person ID is \'NULL\'' + ' , ' ;

                                                        }
                                                        if(sadtls.Linked_Customer_Transition__r.account__r.Sales_PersonID__r.name=='Awaiting SalesID' || sadtls.Linked_Customer_Transition__r.account__r.Sales_PersonID__r.name=='D7873'   ){
                                                        //childAccountError  =childAccountError  +sadtls.Linked_Customer_Transition__r.omx_primary_key__C+ ' Sales Person ID is \'INVALID\'' + ' , ' ;
                                                        childError  =childError  +sadtls.Linked_Customer_Transition__r.omx_primary_key__C+ ' Sales Person ID is \'INVALID\'' + ' , ' ;
                                                        }
                                                        if(sadtls.Linked_Customer_Transition__r.account__r.status__c !='Active'){
                                                        //childAccountError  =childAccountError  +sadtls.Linked_Customer_Transition__r.omx_primary_key__C+' Account is not Active' + ' , ' ;
                                                        childError  =childError  +sadtls.Linked_Customer_Transition__r.omx_primary_key__C+' Account is not Active' + ' , ' ;

                                                        }
                                                        if(sadtls.Linked_Customer_Transition__r.account__r.owner.IsActive !=true){
                                                        //childAccountError  =childAccountError  +sadtls.Linked_Customer_Transition__r.omx_primary_key__C+ ' Account Owner is not Active' + ' , ' ;
                                                        childError  =childError  +sadtls.Linked_Customer_Transition__r.omx_primary_key__C+ ' Account Owner is not Active' + ' , ' ;

                                                        }

                                                        if((sadtls.Linked_Customer_Transition__r.account__r.OMX_Mainframe_Account_Level__c == 'Main Account')
                                                        &&(sadtls.Linked_Customer_Transition__r.Transition_Status__c !='Active')){
                                                       // childAccountError  =childAccountError  +sadtls.Linked_Customer_Transition__r.omx_primary_key__C+ ' Transition Status is not Active' + ' , ' ;
                                                        childError  =childError  +sadtls.Linked_Customer_Transition__r.omx_primary_key__C+ ' Transition Status is not Active' + ' , ' ;

                                                        }

                                                        if ((sadtls.Linked_Customer_Transition__r.Final_Split_Decision__c ==''  || sadtls.Linked_Customer_Transition__r.Final_Split_Decision__c ==null ) &&   sadtls.Linked_Customer_Transition__r.Account_Splitting_Required_frmla__c=='Yes'){
                                                        //childAccountError  =childAccountError  +sadtls.Linked_Customer_Transition__r.omx_primary_key__C+' Final Split Decision is \'Blank\''+' , ' ;
                                                        childError  =childError  +sadtls.Linked_Customer_Transition__r.omx_primary_key__C+' Final Split Decision is \'Blank\''+' , ' ;

                                                        }

                                                        if((sadtls.Linked_Customer_Transition__r.account__r.OMX_Mainframe_Account_Level__c == 'Main Account')
                                                        &&(sadtls.Linked_Customer_Transition__r.AOPS_Flag__c!='Y')){
                                                        //childAccountError  =childAccountError  +sadtls.Linked_Customer_Transition__r.omx_primary_key__C+ ' AOPS Flag is not \'Y\'' + ' , ' ;
                                                        childError  =childError  +sadtls.Linked_Customer_Transition__r.omx_primary_key__C+ ' AOPS Flag is not \'Y\'' + ' , ' ;

                                                        }

                                                        if(sadtls.Linked_Customer_Transition__r.Account__r.Segment__c==null){
                                                        //childAccountError  =childAccountError  +sadtls.Linked_Customer_Transition__r.omx_primary_key__C+' Segment is \'NULL\'' + ' , ' ;
                                                        childError  =childError  +sadtls.Linked_Customer_Transition__r.omx_primary_key__C+' Segment is \'NULL\'' + ' , ' ;

                                                        }
                                                        if(sadtls.Linked_Customer_Transition__r.Account__r.Segment__c=='Other'){
                                                        //childAccountError  =childAccountError  +sadtls.Linked_Customer_Transition__r.omx_primary_key__C+' Segment is \'Other\'' + ' , ' ;
                                                        childError  =childError  +sadtls.Linked_Customer_Transition__r.omx_primary_key__C+' Segment is \'Other\'' + ' , ' ;

                                                        }
                                                        if(string.valueof(sadtls.Linked_Customer_Transition__r.Account__r.ownerid).substring(0,15)==System.Label.salesforce){
                                                        //childAccountError  =childAccountError  +sadtls.Linked_Customer_Transition__r.omx_primary_key__C+' Owner is \'Salesforce\'' + ' , ' ;
                                                        childError  =childError  +sadtls.Linked_Customer_Transition__r.omx_primary_key__C+' Owner is \'Salesforce\'' + ' , ' ;

                                                        }
                                                        if(string.valueof(sadtls.Linked_Customer_Transition__r.Account__r.ownerid).substring(0,15)==System.Label.SalesforceDataloaderNorth){
                                                       // childAccountError  =childAccountError  +sadtls.Linked_Customer_Transition__r.omx_primary_key__C+' Owner is \'Salesforce DataLoader North\'' + ' , ' ;
                                                        childError  =childError  +sadtls.Linked_Customer_Transition__r.omx_primary_key__C+' Owner is \'Salesforce DataLoader North\'' + ' , ' ;

                                                        }

                                                        // start changes for case No 00674130
                                                        if((sadtls.Linked_Customer_Transition__r.Customer_Transition_Type2__c == 'Standalone' || sadtls.Linked_Customer_Transition__r.Customer_Transition_Type2__c == 'Child') && sadtls.Linked_Customer_Transition__r.Written_Agreement__c == true && sadtls.Linked_Customer_Transition__r.Local_Core__c == true && (sadtls.Linked_Customer_Transition__r.Written_Agreement_Custom_Core_Request__c == '' || sadtls.Customer_Transition__r.Written_Agreement_Custom_Core_Request__c == null) )
                                                        childError=childError+'Written Agreement Custom Core Request is required' + ' , ' ;
                                                        // End changes for case No 00674130

                                                  }

                                                 if(sadtls.Linked_Customer_Transition__r.omx_primary_key__C!=null)
                                                 errorMap.put(sadtls.Linked_Customer_Transition__r.omx_primary_key__C,childError  );
                                                                      System.debug('&&&&&&&&&&&&&&here4');


                                                   }



                                           }

                                   Split_Account_Detail__c splitRec= new Split_Account_Detail__c (Id=sadtls.Id);
                                   splitRec.BulkLaunchProcessed__c=true;
                                                                      System.debug('&&&&&&&&&&&&&&here1'+childError+'&&&');
                                                                      System.debug('&&&&&&&&&&&&&&here3'+sadtls.Linked_Customer_Transition__r.omx_primary_key__C);

                                   childError=errorMap.get(sadtls.Linked_Customer_Transition__r.omx_primary_key__C);
                                   System.debug('&&&&&&&&&&&&&&here2'+childError);
                                    if(childError!=' '  && childError!=null){
                                    countError=countError+1;
                                    splitRec.Error_Message__c  =childError  ;
                                    }
                                    splitRecUpdate.add(splitRec);
                              }


                                      // end of loop

                        Integer totalerror=0;
                        System.debug('&&&&&&&&&counterror'+counterror);
                        totalerror=currenterror+counterror;
                        System.debug('&&&&&&&&&totalerror'+totalerror);


                        for(     Split_Account_Detail__c sadtls:splitRecUpdate){
                                        if(ParentError!=' ' || OriginalAccountError!=' '  || totalerror>0)
                                        sadtls.status__C='Error';
                                        if( sadtls.Error_Message__c==null || sadtls.Error_Message__c=='')
                                        sadtls.Error_Message__c=' ';
                                        sadtls.BulkLaunchProcessed__c=true;
                                        sadtls.Error_Message__c = ParentError+OriginalAccountError+ sadtls.Error_Message__c ;
                         }

                                       Customer_transition__C CustNewRec= new Customer_transition__C ();
                                       CustNewRec.Id=splitrecs[0].Id;
                                       CustNewRec.CountLaunchError__c=totalerror;
                                       UPDATE CustNewRec;



                        if(splitRecUpdate.size()>0)
                        update splitRecUpdate;


                        integer BulkLaunchProcessed=0;
                        BulkLaunchProcessed=[select count() from Split_Account_Detail__c
                                               WHERE OMX_ACCOUNT__c = :currentKey and
                                               BulkLaunchProcessed__c=true];

                       System.debug('&&&&&&&&&BulkLaunchProcessed'+BulkLaunchProcessed);


                      Boolean Launchstatus=false;
                      integer countprocessed=0;


                                         List<Customer_transition__C > MasterListUpdate= new List<Customer_transition__C > ();


                     if(activesites==BulkLaunchProcessed){

                     List<Customer_transition__C > custFinalupdate = new List<   Customer_transition__C >();
                                       Customer_transition__C custNew= new Customer_transition__C ();
                                       custNew.Id=splitrecs[0].Id;
                                       custNew.omx_primary_key__C=splitrecs[0].omx_primary_key__C;
                                       custNew.MOD5_Ready_To_Launch__c =false;
                                       custNew.Retrigger_Mod_5__c = false;
                                       custNew.CountLaunchError__c=0;
                                       custNew.Update_Launch_Status__c=true;

                               if(splitrecs[0].Parent_Transition_ID__r.Ready_for_Mod1__c ==false &&  splitrecs[0].Parent_Transition_ID__r.Customer_Transition_Type__c=='Parent'){
                                       Customer_transition__C custNewParent= new Customer_transition__C ();
                                       custNewParent.Id=splitrecs[0].Parent_Transition_ID__c;
                                       custNewParent.omx_primary_key__C=splitrecs[0].Parent_Transition_ID__r.omx_primary_key__C;
                                      if(ParentError!=' ' || OriginalAccountError!=' '  || totalerror>0){
                                      custNewParent.Split_Launching_Status__c ='Fail';
                                      }
                                      else{
                                       custNewParent.Split_Launching_Status__c ='Success';
                                       custNewParent.Ready_for_Mod1__c=true;
                                     }
                                  custFinalupdate.add(   custNewParent);
                               }


                                      if(ParentError!=' ' || OriginalAccountError!=' '  || totalerror>0){
                                      custNew.Split_Launching_Status__c ='Fail';
                                      }
                                      else{
                                       custNew.Split_Launching_Status__c ='Success';
                                       custNew.Ready_for_Mod1__c=true;
                                       Launchstatus=true;
                                      }
                                     custFinalupdate.add(   custNew);


                        update custFinalupdate;

                        }







        }

        }


      /* This method is to execute to relase some resources if any*/
    global void finish(Database.BatchableContext BC)
    {

    //code to update Transition to Launch not needed in bulk code


        CustTransParentChildLevel__c PCLevel2 = [select Mod5LaunchBulkBatchID__C,Mod5BulkLaunchBatchInterval__c from
         CustTransParentChildLevel__c limit 1];
        integer interval = 300;
        if (PCLevel2.Mod5LaunchBulkBatchID__C<> null) {
            for (CronTrigger existingJob: [SELECT Id FROM CronTrigger where ID=:PCLevel2.Mod5LaunchBulkBatchID__C])
            system.abortJob(existingJob.id);
        }

        if(PCLevel2.Mod5BulkLaunchBatchInterval__C!= null)
            interval = (Integer)PCLevel2.Mod5BulkLaunchBatchInterval__C;

        DateTime sysTime = System.now().addSeconds(interval);
        String chronExpression = '' + sysTime.second() + ' ' + sysTime.minute() + ' ' + sysTime.hour() + ' ' + sysTime.day() + ' ' + sysTime.month() + ' ? ' + sysTime.year();

        Mod5LaunchBatchClassBulk Mod5LaunchBatchObj = new Mod5LaunchBatchClassBulk ();
        ID cronid = System.schedule( 'Mod5LaunchBulkBatch' + sysTime, chronExpression, Mod5LaunchBatchObj );

        PCLevel2.Mod5LaunchBulkBatchID__C= cronid;

        update PCLevel2;


    }

    global void execute(SchedulableContext sc)
    {
        String strQuery = '';
        Mod5LaunchBatchClassBulk Mod5LaunchBatchObj = new Mod5LaunchBatchClassBulk (strQuery);
        database.executebatch(Mod5LaunchBatchObj, 1);
    }

}