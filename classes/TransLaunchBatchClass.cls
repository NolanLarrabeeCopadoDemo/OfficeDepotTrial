// This class is to Auto Launch the list of Records Loaded in the Transition Launch Object
Global class TransLaunchBatchClass   implements database.Batchable<Sobject>,Database.Stateful,Schedulable
{

    global String strQuery; //this variable used to set query from test class or from shceduler if required

      public Integer countParent=0;
      public String DEFAULT_QUERY;

    /* Default Constructor*/
    global TransLaunchBatchClass   ()
    {
    // Parents are Launched first and then the child
    countParent=  [select count() from Transition_Launch__c where TYpe__c = 'Parent' and
    (Status__c = 'Submit' or Status__c = 'ReSubmit')];

    System.debug('&&&&&&&&&&&&&&countParent'+countParent);
    if(countParent>0){

     DEFAULT_QUERY ='Select OMX_Key__c'
                                   +' FROM Transition_Launch__c'
                                   +' WHERE TYpe__c = \'Parent\'  and   (Status__c = \'Submit\' or Status__c = \'ReSubmit\' ) Limit 500';
    }

    else{
         DEFAULT_QUERY ='Select OMX_Key__c'
                                   +' FROM Transition_Launch__c'
                                   +' WHERE TYpe__c = null  and   (Status__c = \'Submit\' or Status__c = \'ReSubmit\' ) Limit 500';

    }


        this.strQuery = DEFAULT_QUERY;
    }
    /*This costructor is called from the Batch Schedule method*/
    global TransLaunchBatchClass   (String query)
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
        List<Transition_Launch__c> splitrecs = scope;
        List<String> accomxid= new List<String>();
         Set<String> accomxidChild= new Set<String>();
          System.debug('&&&&&&&&&&'+splitrecs);
          if(splitrecs.size()>0){
                  for(Transition_Launch__c sad : splitrecs){
                    accomxid.add(sad.OMX_Key__c);
                  }
           }

                  String ParentError=' ';
                  String OriginalAccountError=' ';

               List<Customer_transition__C > custList= new   List<Customer_transition__C >();
               List<Transition_Launch__c  > transList = new List<Transition_Launch__c  >();
 // Processing the errors
                         for(Transition_Launch__c  sadtls : [Select Id,
                                                Customer_Transition__r.Parent_Transition_ID__c,
                                                Customer_Transition__r.Parent_Transition_ID__r.Customer_Transition_Type__c,
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
                                                Customer_Transition__r.Parent_Transition_ID__r.account__R.split_record__C,
                                                Customer_Transition__r.Parent_Transition_ID__r.Override_Loss_of_Customer__c ,               // case number 00658908
                                                Customer_Transition__r.Parent_Transition_ID__r.Customer_Transition_Type2__c,                //Added for Case# 00674130
                                                Customer_Transition__r.Parent_Transition_ID__r.Written_Agreement__c,                        //Added for Case# 00674130
                                                Customer_Transition__r.Parent_Transition_ID__r.Local_Core__c,                               //Added for Case# 00674130
                                                Customer_Transition__r.Parent_Transition_ID__r.Written_Agreement_Custom_Core_Request__c,    //Added for Case# 00674130
                                                Customer_Transition__r.Parent_Transition_ID__r.Override_Administrative_close__c,
                                                Customer_Transition__r.Override_Administrative_close__c,
                                              
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
                                                Customer_Transition__r.account__R.split_record__C,
                                                Customer_Transition__r.Override_Loss_of_Customer__c ,                   // case number 00658908
                                                Customer_Transition__r.Customer_Transition_Type2__c,                     //Added for Case# 00674130
                                                Customer_Transition__r.Written_Agreement__c,                            //Added for Case# 00674130
                                                Customer_Transition__r.Local_Core__c,                                   //Added for Case# 00674130
                                                Customer_Transition__r.Written_Agreement_Custom_Core_Request__c,       //Added for Case# 00674130
                                               OMX_Key__c,status__c
                                               FROM Transition_Launch__c
                                               WHERE OMX_Key__c in  :accomxid]){


                          ParentError=' ';
                          OriginalAccountError=' ';


                                  // For Checking Parent
                                                if(sadtls.Customer_Transition__r.Parent_Transition_ID__c !=null && sadtls.Customer_Transition__r.Parent_Transition_ID__r.Ready_for_Mod1__c==false && ParentError  ==' '  &&  sadtls.Customer_Transition__r.Parent_Transition_ID__r.Customer_Transition_Type__c=='Parent'){


                                                        if(  (sadtls.Customer_Transition__r.Parent_Transition_ID__r.Status__c !='On Deck'   &&  sadtls.Customer_Transition__r.Parent_Transition_ID__r.Written_Agreement_Customer_No__c==null)
                                                             ||
                                                          (sadtls.Customer_Transition__r.Parent_Transition_ID__r.Written_Agreement_Customer_No__c!=null &&

                                                                  sadtls.Customer_Transition__r.Parent_Transition_ID__r.status__c != 'ODP Agreement in Development'
                                                                  && sadtls.Customer_Transition__r.Parent_Transition_ID__r.status__c != 'OMX Extension in Development'
                                                                  && sadtls.Customer_Transition__r.Parent_Transition_ID__r.status__c != 'ODP Agreement Complete'
                                                                   && sadtls.Customer_Transition__r.Parent_Transition_ID__r.status__c != 'On Deck'
                                                                  ) &&
                                                                  (!(sadtls.Customer_Transition__r.Parent_Transition_ID__r.Status__c =='Administrative Close'  && sadtls.Customer_Transition__r.Parent_Transition_ID__r.Override_Administrative_close__c == true))
                                                                   //Start Changes for Case No 00658908
                                                                  &&(!(sadtls.Customer_Transition__r.Parent_Transition_ID__r.status__c == 'Loss of Customer' && sadtls.Customer_Transition__r.Parent_Transition_ID__r.Override_Loss_of_Customer__c == true))
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


                                                         if ((sadtls.Customer_Transition__r.Parent_Transition_ID__r.Final_Split_Decision__c =='Yes'   ||  sadtls.Customer_Transition__r.Parent_Transition_ID__r.account__R.split_record__C==true) )
                                                        ParentError  =ParentError  +sadtls.Customer_Transition__r.Parent_Transition_ID__r.omx_primary_key__C+'Split Record can be Launched only through Mod 5 process'+' , ' ;


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

                                                        //Added for Case# 00674130
                                                        if((sadtls.Customer_Transition__r.Parent_Transition_ID__r.Customer_Transition_Type2__c == 'Standalone' || sadtls.Customer_Transition__r.Parent_Transition_ID__r.Customer_Transition_Type2__c == 'Child') && sadtls.Customer_Transition__r.Parent_Transition_ID__r.Written_Agreement__c == true && sadtls.Customer_Transition__r.Parent_Transition_ID__r.Local_Core__c == true && (sadtls.Customer_Transition__r.Parent_Transition_ID__r.Written_Agreement_Custom_Core_Request__c == '' || sadtls.Customer_Transition__r.Parent_Transition_ID__r.Written_Agreement_Custom_Core_Request__c == null) )
                                                        ParentError=ParentError+'Written Agreement Custom Core Request is required' + ' , ' ;


                                                  }


                                             System.debug('&&&&&&&&ParentError  '+ParentError  );

                                               // for Original Account

                                               if(sadtls.Customer_Transition__c !=null && sadtls.Customer_Transition__r.Ready_for_Mod1__c==false && OriginalAccountError  ==' '){




                                                                        if( (sadtls.Customer_Transition__r.Status__c !='On Deck'   &&  sadtls.Customer_Transition__r.Written_Agreement_Customer_No__c==null)
                                                                             ||
                                                                          (sadtls.Customer_Transition__r.Written_Agreement_Customer_No__c!=null &&

                                                                                  sadtls.Customer_Transition__r.status__c != 'ODP Agreement in Development'
                                                                                  && sadtls.Customer_Transition__r.status__c != 'OMX Extension in Development'
                                                                                  && sadtls.Customer_Transition__r.status__c != 'ODP Agreement Complete'
                                                                                  && sadtls.Customer_Transition__r.status__c != 'On Deck'
                                                                                  ) &&

                                                                                 (!(sadtls.Customer_Transition__r.Status__c =='Administrative Close'  && sadtls.Customer_Transition__r.Override_Administrative_close__c == true))
                                                                                 //Start Changes for Case No 00658908
                                                                               &&
                                                                                (!(sadtls.Customer_Transition__r.status__c == 'Loss of Customer' && sadtls.Customer_Transition__r.Override_Loss_of_Customer__c == true))
                                                                                //End Changes for Case No 00658908


                                                                         )
                                                                        OriginalAccountError  =OriginalAccountError  +sadtls.Customer_Transition__r.omx_primary_key__C+ ' Not in Valid status for Launching' + ' , ' ;


                                                                        if(sadtls.Customer_Transition__r.account__r.Sales_PersonID__c==null)
                                                                        OriginalAccountError  =OriginalAccountError  +sadtls.Customer_Transition__r.omx_primary_key__C+ ' Sales Person ID is \'NULL\'' + ' , ' ;


                                                                        if(sadtls.Customer_Transition__r.account__r.Sales_PersonID__r.name=='Awaiting SalesID' || sadtls.Customer_Transition__r.account__r.Sales_PersonID__r.name=='D7873'   )
                                                                        OriginalAccountError  =OriginalAccountError  +sadtls.Customer_Transition__r.omx_primary_key__C+ ' Sales Person ID is \'INVALID\'' + ' , ' ;


                                                                        if(sadtls.Customer_Transition__r.account__r.status__c !='Active')
                                                                        OriginalAccountError  =OriginalAccountError  +sadtls.Customer_Transition__r.omx_primary_key__C+' Account is not Active' + ' , ' ;

                                                                         System.debug('&&&&&&&&&&&sadtls.Customer_Transition__r.account__r.owner.IsActive'+sadtls.Customer_Transition__r.account__r.owner.IsActive);

                                                                        if(sadtls.Customer_Transition__r.account__r.owner.IsActive !=true)
                                                                        OriginalAccountError  =OriginalAccountError  +sadtls.Customer_Transition__r.omx_primary_key__C+ ' Account Owner is not Active' + ' , ' ;


                                                                        if((sadtls.Customer_Transition__r.account__r.OMX_Mainframe_Account_Level__c == 'Main Account')
                                                                        &&(sadtls.Customer_Transition__r.Transition_Status__c !='Active'))
                                                                        OriginalAccountError  =OriginalAccountError  +sadtls.Customer_Transition__r.omx_primary_key__C+ ' Transition Status is not Active' + ' , ' ;


                                                                        if ((sadtls.Customer_Transition__r.Final_Split_Decision__c ==''  || sadtls.Customer_Transition__r.Final_Split_Decision__c ==null ) &&   sadtls.Customer_Transition__r.Account_Splitting_Required_frmla__c=='Yes')
                                                                        OriginalAccountError  =OriginalAccountError  +sadtls.Customer_Transition__r.omx_primary_key__C+' Final Split Decision is \'Blank\''+' , ' ;


                                                                         if ((sadtls.Customer_Transition__r.Final_Split_Decision__c =='Yes'   ||  sadtls.Customer_Transition__r.account__R.split_record__C==true) )
                                                                         ParentError  =ParentError  +sadtls.Customer_Transition__r.omx_primary_key__C+'Split Record can be Launched only through Mod 5 process'+' , ' ;



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

                                                                         //Added for Case# 00674130
                                                                        if((sadtls.Customer_Transition__r.Customer_Transition_Type2__c == 'Standalone' || sadtls.Customer_Transition__r.Customer_Transition_Type2__c == 'Child') && sadtls.Customer_Transition__r.Written_Agreement__c == true && sadtls.Customer_Transition__r.Local_Core__c == true && (sadtls.Customer_Transition__r.Written_Agreement_Custom_Core_Request__c == '' || sadtls.Customer_Transition__r.Written_Agreement_Custom_Core_Request__c == null) )
                                                                        OriginalAccountError=OriginalAccountError+'Written Agreement Custom Core Request is required' + ' , ' ;


                                                  }



                                if(  ParentError==' ' &&  OriginalAccountError==' '){
                                       Customer_transition__C custNew= new Customer_transition__C ();
                                       custNew.Id=sadtls.Customer_Transition__c;
                                       custNew.Ready_for_Mod1__c=true;
                                       //custNew.EBS_Populated_Date__c=System.Today();
                                       custList.add(custNew);
                                       Transition_Launch__c  trans = new Transition_Launch__c ();
                                       trans.Id= sadtls.Id;
                                       trans.Status__c='Success';
                                       trans.Error_Message__c=null;
                                       transList.add(trans );
                               }
                               else{

                               System.debug('&&&&&&&&&&&ParentError'+ParentError);
                                System.debug('&&&&&&&&&&&OriginalAccountError'+OriginalAccountError);
                                       Transition_Launch__c  trans = new Transition_Launch__c ();
                                       trans.Id= sadtls.Id;
                                       trans.Status__c='Fail';
                                       trans.Error_Message__c=ParentError+OriginalAccountError;
                                       transList.add(trans );
                               }




                     }
                                      // end of loop



                   if(custList.size()>0)
                   update custList;
                   if(transList.size()>0)
                   update transList;


        }


      /* This method is to execute to relase some resources if any*/
    global void finish(Database.BatchableContext BC)
    {
    }

    global void execute(SchedulableContext sc)
    {
        String strQuery = '';
        TransLaunchBatchClass  Mod5LaunchBatchObj = new TransLaunchBatchClass   ();
        database.executebatch(Mod5LaunchBatchObj, 1);

    }

}