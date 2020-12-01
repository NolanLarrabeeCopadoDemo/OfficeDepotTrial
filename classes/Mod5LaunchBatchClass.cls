Global class Mod5LaunchBatchClass implements database.Batchable<Sobject>,Database.Stateful,Schedulable
{
    
    global String strQuery; //this variable used to set query from test class or from shceduler if required

    
    
    // Below is set a default query in case not set in test class or in scheduler
    private String DEFAULT_QUERY ='Select omx_primary_key__c '
                                   +' FROM Customer_Transition__c '
                                   +'WHERE MOD5_Ready_To_Launch__c = true  and BulkSplit__C=false Limit 1'; 
    /* Default Constructor*/
    global Mod5LaunchBatchClass ()
    {        
        this.strQuery = DEFAULT_QUERY;
    }
    /*This costructor is called from the Batch Schedule method*/
    global Mod5LaunchBatchClass (String query)
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
                  String ParentError=' ';
                  String OriginalAccountError=' ';
                  String childAccountError=' ';
                  String childError=' ';
                  integer countError=0;

                
                  String FinalError=' ';
                  
                 List<Id> Launchlist = new List<Id>();
                 Map< Id,Id> transitionMap= new Map< Id,Id>();
                  Map< String,String> errorMap= new Map< String,String>();

                 
                List<Split_Account_Detail__c > splitRecUpdate  = new List<Split_Account_Detail__c > ();
                 
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
                                                Customer_Transition__r.Parent_Transition_ID__r.Override_Loss_of_Customer__c , // case number 00658908
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
                                               Linked_Customer_Transition__r.Override_Loss_of_Customer__c,  // case number 00658908
                                               Linked_Customer_Transition__r.Customer_Transition_Type2__c,                //Added for Case# 00674130
                                               Linked_Customer_Transition__r.Written_Agreement__c,                        //Added for Case# 00674130
                                               Linked_Customer_Transition__r.Local_Core__c,                               //Added for Case# 00674130
                                               Linked_Customer_Transition__r.Written_Agreement_Custom_Core_Request__c,    //Added for Case# 00674130
                                               Master_Account__c,status__c
                                                
                                               FROM Split_Account_Detail__c 
                                               WHERE OMX_ACCOUNT__c = :currentKey]){   
               
               
             
               
               
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
                                                        //Start Changes for Case No 00549679   
                                                        if(sadtls.Customer_Transition__r.Parent_Transition_ID__r.Written_Agreement_Customer_No__c!=null && sadtls.Customer_Transition__r.Parent_Transition_ID__r.Customer_Go_Live_Target_Date__c == null)
                                                            ParentError = ParentError +sadtls.Customer_Transition__r.Parent_Transition_ID__r.omx_primary_key__C + 'Customer Go Live Target Date is mandatory' + ' , ' ;
                                                        //End Changes for Case No 00549679     
                                                        
                                                        //Added for Case# 00674130
                                                        if((sadtls.Customer_Transition__r.Parent_Transition_ID__r.Customer_Transition_Type2__c == 'Standalone' || sadtls.Customer_Transition__r.Parent_Transition_ID__r.Customer_Transition_Type2__c == 'Child') && sadtls.Customer_Transition__r.Parent_Transition_ID__r.Written_Agreement__c == true && sadtls.Customer_Transition__r.Parent_Transition_ID__r.Local_Core__c == true && (sadtls.Customer_Transition__r.Parent_Transition_ID__r.Written_Agreement_Custom_Core_Request__c == '' || sadtls.Customer_Transition__r.Parent_Transition_ID__r.Written_Agreement_Custom_Core_Request__c == null) )
                                                        ParentError=ParentError+'Written Agreement Custom Core Request is required' + ' , ' ;                                                       
                                                  
                                                  }
                                                  
                                                  }
                                               
                                               
                                             System.debug('&&&&&&&&ParentError  '+ParentError  );  
                                                  
                                               // for Original Account
                                               
                                               if(sadtls.Customer_Transition__c !=null && sadtls.Customer_Transition__r.Ready_for_Mod1__c==false && OriginalAccountError  ==' '){
                                                  
                                                       
                                                                  if(!transitionMap.containsKey(sadtls.Customer_Transition__c)){              
                                                                           transitionMap.put(sadtls.Customer_Transition__c,sadtls.Customer_Transition__c);
                                                                           Launchlist.add(sadtls.Customer_Transition__c);
                                                                   
                                                                  
                                                                  //Adding Override Administrative close for Case No 00574414
                                                                        if( ( (sadtls.Customer_Transition__r.Status__c !='On Deck'   &&  sadtls.Customer_Transition__r.Written_Agreement_Customer_No__c==null)
                                                                             ||
                                                                          (sadtls.Customer_Transition__r.Written_Agreement_Customer_No__c!=null &&
                                                                          
                                                                                  sadtls.Customer_Transition__r.status__c != 'ODP Agreement in Development' 
                                                                                  && sadtls.Customer_Transition__r.status__c != 'OMX Extension in Development'
                                                                                  && sadtls.Customer_Transition__r.status__c != 'ODP Agreement Complete'
                                                                                  && sadtls.Customer_Transition__r.status__c != 'On Deck'
                                                                                  ) )&&
                                                                                 (!(sadtls.Customer_Transition__r.Status__c =='Administrative Close'  && sadtls.Customer_Transition__r.Override_Administrative_close__c == true))
                                                                                 //Start Changes for Case No 00658908
                                                                                && (!(sadtls.Customer_Transition__r.status__c == 'Loss of Customer' && sadtls.Customer_Transition__r.Override_Loss_of_Customer__c == true))
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
                                                                        
                                                                        //Added for Case# 00674130
                                                                        if((sadtls.Customer_Transition__r.Customer_Transition_Type2__c == 'Standalone' || sadtls.Customer_Transition__r.Customer_Transition_Type2__c == 'Child') && sadtls.Customer_Transition__r.Written_Agreement__c == true && sadtls.Customer_Transition__r.Local_Core__c == true && (sadtls.Customer_Transition__r.Written_Agreement_Custom_Core_Request__c == '' || sadtls.Customer_Transition__r.Written_Agreement_Custom_Core_Request__c == null) )
                                                                        OriginalAccountError=OriginalAccountError+'Written Agreement Custom Core Request is required' + ' , ' ;
                                                                        
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
                                                                  ) )&&
                                                                  (!(sadtls.Linked_Customer_Transition__r.Status__c =='Administrative Close'  && sadtls.Linked_Customer_Transition__r.Override_Administrative_close__c == true))
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
                                                        
                                                        //Added for Case# 00674130
                                                        if((sadtls.Linked_Customer_Transition__r.Customer_Transition_Type2__c == 'Standalone' || sadtls.Linked_Customer_Transition__r.Customer_Transition_Type2__c == 'Child') && sadtls.Linked_Customer_Transition__r.Written_Agreement__c == true && sadtls.Linked_Customer_Transition__r.Local_Core__c == true && (sadtls.Linked_Customer_Transition__r.Written_Agreement_Custom_Core_Request__c == '' || sadtls.Customer_Transition__r.Written_Agreement_Custom_Core_Request__c == null) )
                                                        childError=childError+'Written Agreement Custom Core Request is required' + ' , ' ;

                                                        }                                      
                                                  
                                                  }                                                                                                                                                                                                                                 
                                                  errorMap.put(sadtls.Linked_Customer_Transition__r.omx_primary_key__C,childError  );
                                                   } 
                                             
                                             
                                                  
                                           }       
                                      
                                      
                                      if(childError!=' ')
                                      countError=countError+1;                                                    
                                    Split_Account_Detail__c splitRec= new Split_Account_Detail__c (Id=sadtls.Id);
                                    splitRec.Error_Message__c  =errorMap.get(sadtls.Linked_Customer_Transition__r.omx_primary_key__C);
                                    //childError  ;
                                    splitRecUpdate.add(splitRec);
                                              }
                                      // end of loop           
                  
                  
                     // System.debug('&&&&&&&&childAccountError  '+childAccountError  );    
                  
                  
                  List<Customer_transition__C > custList= new   List<Customer_transition__C >();
                  List<Split_Account_Detail__c > splitList= new   List<Split_Account_Detail__c >();
                  
                         if(  ParentError==' ' &&  OriginalAccountError==' '  && countError==0){
                         
                                for(Customer_transition__C cust:[ Select Id,
                                   MOD5_Ready_To_Launch__c, Retrigger_Mod_5__c,Ready_for_Mod1__c,Split_Launching_Status__c 
                                   from Customer_transition__C where Id in :Launchlist]){
                                       Customer_transition__C custNew= new Customer_transition__C ();
                                       custNew.Id=cust.Id;
                                       custNew.MOD5_Ready_To_Launch__c =false;
                                       custNew.Retrigger_Mod_5__c = false;
                                       custNew.Split_Launching_Status__c ='Success';
                                       custNew.Ready_for_Mod1__c=true;
                                       custList.add(custNew);
                                 }
                                 
                               
                                 
                         if(custList.size()>0)
                         update custList;
                         
                                 for(Split_Account_Detail__c sadtls : [Select Id,Status__c,Error_Message__c 
                                  FROM Split_Account_Detail__c 
                                  WHERE OMX_ACCOUNT__c = :currentKey ]){
                                  
                                  Split_Account_Detail__c sad= new Split_Account_Detail__c ();
                                        sad.Id=sadtls.Id;
                                        sad.Status__c = 'Success';
                                        sad.Error_Message__c = '';
                                 splitList.add(sad);
                                 }
                        if(splitList.size()>0)
                        update splitList;
                         
                         
                         }
                         
                         
                         else{
                         FinalError=ParentError+OriginalAccountError+childAccountError;
                         
                            for(Customer_transition__C cust:[ Select Id,
                                   MOD5_Ready_To_Launch__c,Retrigger_Mod_5__c ,Ready_for_Mod1__c,Split_Launching_Status__c 
                                   from Customer_transition__C where Id in :Launchlist]){
                                       Customer_transition__C custNew= new Customer_transition__C ();
                                       custNew.Id=cust.Id;
                                       custNew.MOD5_Ready_To_Launch__c =false;
                                       custNew.Retrigger_Mod_5__c = false;
                                       custNew.Split_Launching_Status__c ='Fail';
                                  
                                       custList.add(custNew);
                                 }
                         if(custList.size()>0)
                         update custList;
                         
                         
                         
                         for(     Split_Account_Detail__c sadtls:splitRecUpdate){
                                        sadtls.Status__c = 'Error';                                                                                
                                        sadtls.Error_Message__c = ParentError+OriginalAccountError+ sadtls.Error_Message__c ;                                                         
                         }
                         
                        if(splitRecUpdate.size()>0)
                        update splitRecUpdate;

                         
                         /*
                                 for(Split_Account_Detail__c sadtls : [Select Id,Status__c,Error_Message__c 
                                  FROM Split_Account_Detail__c 
                                  WHERE OMX_ACCOUNT__c = :currentKey ]){
                                  
                                  Split_Account_Detail__c sad= new Split_Account_Detail__c ();
                                        sad.Id=sadtls.Id;
                                        sad.Status__c = 'Error';
                                        sad.Error_Message__c = FinalError;
                                 splitList.add(sad);
                                 }
                        if(splitList.size()>0)
                        update splitList;
                         
                         */
                         
                         
                         }
             
                   System.debug('&&&&&&&&FinalError'+FinalError);   
                  System.debug('&&&&&&&&custList'+custList);         
               
                    System.debug('&&&&&&&&splitList'+splitList);         
                  
                  
                  
                  
                  
          }
        
        }
   
   
      /* This method is to execute to relase some resources if any*/
    global void finish(Database.BatchableContext BC)
    {
    
    // Update Missing Mod 5 Launch Update
     List <Customer_transition__C > missRecords = new List <Customer_transition__C >();
     Map <String,String> maphiersplit = new Map <String,String> ();
     set <String> accomxid = new set<String>(); 
     list<Customer_Transition__c> mod5accs = new list<Customer_Transition__c>();
             
  system.debug('Entered here');
       Date dt=System.today()-1;
        missRecords=[Select Id,omx_primary_key__C from customer_transition__C where Ready_For_Mod_5__c =true and 
        Split_Launching_Status__c= null and Ready_for_Mod_5_Date__c>=:dt and
        id in (select Customer_Transition__c  from  Split_Account_Detail__c 
        WHERE   
        Linked_Customer_Transition__c !=null)                                                                                                                                                                                                              
        ];
        
       system.debug('Entered here'+missRecords);  
        for(customer_transition__C cust:missRecords)
        accomxid.add(cust.omx_primary_key__C );
        
    
    if(missRecords.size()>0 ){
                    try{
                         for(Split_Account_Detail__c sadtlrec : [Select  Customer_Transition__c,OMX_ACCOUNT__c,
                                                                        Original_Account__r.Mod_5_EBS_Sync_Status__c,
                                                                        Linked_Customer_Transition__r.account__r.Mod_5_EBS_Sync_Status__c, 
                                                                        Customer_Transition__r.account__r.Oracle_Party_ID__c
                                                                        FROM Split_Account_Detail__c 
                                                                         WHERE OMX_ACCOUNT__c IN :accomxid  and                                                                                                                                           
                                                                        Linked_Customer_Transition__r.account__r.Split_Record__c = true
                                                                        //Master_Account__c LIKE '%-%'
                                                                        and Linked_Customer_Transition__r.account__r.Mod_5_EBS_Sync_Status__c != 'SUCCESS']){
                          
                            if(!maphiersplit.containsKey(sadtlrec.OMX_ACCOUNT__c))
                            maphiersplit.put(sadtlrec.OMX_ACCOUNT__c,sadtlrec.OMX_ACCOUNT__c);
                         } 
                      }        
                catch(Exception e){}    
            
                   
    }
    
    
    
                Integer batchscope=Integer.valueof(Label.BatchScope);

                List<Customer_transition__C> custList=[select omx_primary_key__C from
                Customer_transition__C where omx_primary_key__C in: accomxid and
                (  Mod4FlowStatus__c='Splitted'   or  Mod5_Process__C=false)
                and  Ready_for_Mod1__c=false];
                
                          system.debug('>>>maphiersplit>>>>'+maphiersplit);
                                                    
                          
                           for( Customer_transition__C s :custList){
                            System.debug('&&&&&&&&&&Inside loop'+s);                            
                                  Customer_Transition__c ct = new Customer_Transition__c();
                                  ct.omx_primary_key__c = s.omx_primary_key__C ;
                                  if(maphiersplit.size()==0){
                                      system.debug('launching mod5');
                                      ct.MOD5_Ready_To_Launch__c = true;
                                      ct.Split_Launching_Status__c='Submitted';
                                      mod5accs.add(ct);                        
                                  } 
                                  else{                         
                                      if(maphiersplit.get(s.omx_primary_key__C )==null  || maphiersplit.get(s.omx_primary_key__C )=='' ){
                                       system.debug('--launching mod5--');
                                       ct.MOD5_Ready_To_Launch__c = true;
                                       ct.Split_Launching_Status__c='Submitted';
                                       mod5accs.add(ct);                                  
                                       }
                                  }
                           }
       
                          
       
       /*
                    for( String s :accomxid){
                        System.debug('&&&&&&&&&&Inside loop'+s);                            
                              Customer_Transition__c ct = new Customer_Transition__c();
                              ct.omx_primary_key__c = s;
                              if(maphiersplit.size()==0){
                                  system.debug('launching mod5');
                                  ct.MOD5_Ready_To_Launch__c = true;
                                  ct.Split_Launching_Status__c='Submitted';
                                  mod5accs.add(ct);                        
                              } 
                              else{                         
                                  if(maphiersplit.get(s)==null  || maphiersplit.get(s)=='' ){
                                   system.debug('--launching mod5--');
                                   ct.MOD5_Ready_To_Launch__c = true;
                                   ct.Split_Launching_Status__c='Submitted';
                                   mod5accs.add(ct);                                  
                                   }
                              }
                       }
                       
                       */
    
    if(mod5accs.size()>0){
        system.debug(mod5accs);
        upsert mod5accs omx_primary_key__c;
    }
    
    
    
        CustTransParentChildLevel__c PCLevel2 = [select Mod5LaunchBatchID__c,Mod5LaunchBatchInterval__c from CustTransParentChildLevel__c limit 1];
        integer interval = 300;        
        if (PCLevel2.Mod5LaunchBatchID__c <> null) {
            for (CronTrigger existingJob: [SELECT Id FROM CronTrigger where ID=:PCLevel2.Mod5LaunchBatchID__c])
            system.abortJob(existingJob.id);
        }
        
        if(PCLevel2.Mod5LaunchBatchInterval__c != null)
            interval = (Integer)PCLevel2.Mod5LaunchBatchInterval__c;
        
        DateTime sysTime = System.now().addSeconds(interval);
        String chronExpression = '' + sysTime.second() + ' ' + sysTime.minute() + ' ' + sysTime.hour() + ' ' + sysTime.day() + ' ' + sysTime.month() + ' ? ' + sysTime.year();
        
        Mod5LaunchBatchClass Mod5LaunchBatchObj = new Mod5LaunchBatchClass();
        ID cronid = System.schedule( 'Mod5LaunchBatch' + sysTime, chronExpression, Mod5LaunchBatchObj );    
        
        PCLevel2.Mod5LaunchBatchID__c = cronid;
        
        update PCLevel2;    
    }     
        
    global void execute(SchedulableContext sc)
    {
        String strQuery = '';
        Mod5LaunchBatchClass  Mod5LaunchBatchObj = new Mod5LaunchBatchClass (strQuery);
        database.executebatch(Mod5LaunchBatchObj, 1);
    } 
          
}