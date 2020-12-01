public class WRFTaskManagement
{
    private static Map<String,Schema.RecordTypeInfo> WRFTaskRecType = Schema.SObjectType.WRF_Task__c.getRecordTypeInfosByName();
    private static Map<Id,Case> mapidcase= new Map<Id,Case>();
    private static Map<Id, Case> caseMap = new Map<Id, Case>();
    private static Set<id> CaseIds = new Set<id>();
    private static Set<Id> caseids1= new Set<Id>();
    private static Map<String,List<Case_SLA__c>> maprequestlistcontrolseq= new Map<String,List<Case_SLA__c>>();
    private static Map<String,List<Case_SLA__c>> maprequestlistCaseSLA= new Map<String,List<Case_SLA__c>>();
    private static List<WRF_Task__c> insertinitialtasks= new List<WRF_Task__c>();
    private static Map<String,WRF_Task__c> eachstepsubtasksnum= new Map<String,WRF_Task__c>();
    private static set<Id> parenttaskid= new Set<Id>();
    private static Set<Id> wrfsubtaskid=new Set<Id>();
    private static Map<Id,WRF_Task__c> updateparenttask= new Map<Id,WRF_Task__c>();
    private static Map<Id,Record_History__c> updaterecordhis= new Map<Id,Record_History__c>();
    private static Map<Id,Record_History__c> updaterecordhis1= new Map<Id,Record_History__c>();
    private static Set<Id> setstagewrf=new Set<Id>();
    private static String DefaultBusinessHours_Id;
    private static String BusinessHours_Id;
    private static List<BusinessHours> bh;
    private static Map<String,Record_History__c> mapinsertrecordhistory = new Map<String,Record_History__c>();
    private static Map<String,Record_History__c> mapupdaterecordhistory = new Map<String,Record_History__c>();
    private static List<Record_History__c> deleterecordhistory=new List<Record_History__c>();
    private static Set<Id> alltask=new set<Id>();
    private static Map<id,List<WRF_Task__c>> caseandalltask= new Map<id,List<WRF_Task__c>>();
    private static Datetime latestmodified=System.today()-360;
    private static Boolean bidsforloop;
    private static Boolean Remediationforloop;
    private static Boolean publicgpoforloop;
    private static Boolean MPSPricingforloop;
    private static String casepricinganalyst;
    private static Boolean checkdiscode=false;
    private static Map<Id, WRF_Task__c> Task_Map = new Map<Id, WRF_Task__c>();
    private static List<WRF_Task__c> lstRelatedTasks = new List<WRF_Task__c>();
    private static List<WRF_Task__c> updateparentlist1= new List<WRF_Task__c>();
    private static List<WRF_Task__c> deletesubtask=new List<WRF_Task__c>();
    private static Set<Id> subtaskid= new Set<Id>();
    private static Map<Id,List<WRF_Task__c>> subtaskforparent= new  Map<Id,List<WRF_Task__c>>();
    private static Boolean MPSImplementtionlogic1;
    private static Boolean MPSImplementtionlogic2;
    private static Boolean MPSImplementtionlogic3;
    private static Boolean MPSImplementtionlogic4;
    private static Boolean MPSImplementtionlogic5;
    private static Set<Id> cseIds = new Set<Id>();
    private static Map<Id,Case> IdCaseMap = new Map<Id,Case> () ;

    //Added for S-423432 [Case#00730159]
    public static final String STATUS_COMPLETE = 'Completed';
    public static final String WORK_REQUEST = 'Work Request';
    //END S-423432 [Case#00730159]
	
    public static Boolean RunOnce=false; //Support Ticket: 00660249:
    
    public Static void gBusinessHours()
     {
        bh = [select id,IsDefault from businesshours];

         for(BusinessHours b: bh){
            if(b.IsDefault)
            DefaultBusinessHours_Id = b.id;
            else
            BusinessHours_Id = b.id;
        }
     }
    //Support Ticket: 00660249 Begin:
    public Static void WRF_Dvrsty_Tsk_Create(List<case> C)
     {
         System.Debug('RunOnce:' + RunOnce);
         IF(RunOnce == False) {
             id a2;
             string aG;
             Date TDy = System.today();
             List<WRF_Task__c> lWT = New List<WRF_Task__c>();
             Map<Id, Case> Diversity_Manager_Map = new Map<Id, Case>([SELECT id, Account.Tier_1_Partner__r.Diversity_Manager__c from case Where id in :C]);
             System.Debug('Diversity Map Query:' + Diversity_Manager_Map.size());
             System.Debug('Query ' + C[0]);
             ID wRT = Schema.SObjectType.WRF_Task__c.getRecordTypeInfosByName().get('WRF Task').getRecordTypeId();
             For(Case cC : C) {
                 if( Diversity_Manager_Map.get(cC.id).Account.Tier_1_Partner__r.Diversity_Manager__c != null  )  {
                     a2 = Diversity_Manager_Map.get(cC.id).Account.Tier_1_Partner__r.Diversity_Manager__c;
                     aG = null;
                 } Else {
                     a2 = null;
                     aG = 'Diversity Solution Ops';
                 }
                 System.Debug('a2:' + a2 + ' aG:' + aG );
                 WRF_Task__c wT = New WRF_Task__c (
                     WRF__c = cC.id,
                     Recordtypeid = wRT,
                     Assigned_To__c = a2,
                     Assignment_Group__c = aG,
                     Comments__c = 'Prepare Tier 1 partner and customer for migration',
                     Disposition_Code__c = 'Diversity',
                     Due_Date__c = TDy.addDays(14),
                     Priority__c = 'Normal',
                     Status__c = 'Not Started',
                     WRF_Stage__c = 'Not Started',
                     WRF_Task_Name__c = 'Diversity Manager Transition Task'
                 );
                 
                 WRF_Task__c wT2 = New WRF_Task__c (
                     WRF__c = cC.id,
                     Recordtypeid = wRT,
                     Assignment_Group__c = 'Diversity Solution Ops',
                     Comments__c = 'Prepare Tier 1 partner and customer for migration',
                     Disposition_Code__c = 'Diversity',
                     Due_Date__c = TDy.addDays(14),
                     Priority__c = 'Normal',
                     Status__c = 'Not Started',
                     WRF_Stage__c = 'Not Started',
                     WRF_Task_Name__c = 'Diversity Solution Ops Transition Task'
                 );
                 
                 lWT.Add(wT);
                 lWT.Add(wT2);
             }
             Insert lWT;
             RunOnce = True;
         }
     }
    //Support Ticket: 00660249 End:
    public static void beforeinsertupdatelogic()
    {
        List<Id> parentIds = new List<Id>();

        for(WRF_Task__c wtsk : (List<WRF_Task__c>)Trigger.new)
        {
            cseIds.add(wtsk.WRF__C);

            if (wtsk.Parent_WRF_Task__c != null) {
                parentIds.add(wtsk.Parent_WRF_Task__c);
            }
        }

        if(executeoncetest.querycaseonce)
        {
             System.debug('-------->>>Case Query');
            IdCaseMap = new Map<Id,Case>([Select Id,WRF_Request_Type__c from case where ID in :cseIds]);
            executeoncetest.querycaseonce=false;
        }
        if(Trigger.IsInsert)
        {
            for(WRF_Task__c wrfTaskins:(List<WRF_Task__c>)Trigger.New)
            {
               if(wrfTaskins.recordtypeid==WRFTaskRecType.get('WRF Task').getRecordTypeId())
               {
                 if(    (wrfTaskins.Disposition_Code__c=='Bids') ||(wrfTaskins.Disposition_Code__c=='Tech Depot')   ||   (wrfTaskins.Disposition_Code__c=='Transition')   ||  (wrfTaskins.Disposition_Code__c=='Remediation')  ||(wrfTaskins.Disposition_Code__c=='MPS Implementation') || (wrfTaskins.Disposition_Code__c=='Public/GPO'  )|| (wrfTaskins.Disposition_Code__c== 'OD N Remediation') || (wrfTaskins.Disposition_Code__c== 'OD N Bid'))
                        {
                           // system.debug('wrfTaskins.WRF__R.WRF_Request_Type__c-->'+IdCaseMap.get(wrfTaskins.WRF__c).WRF_Request_Type__c);
                            if(IdCaseMap.containskey(wrfTaskins.WRF__c))
                            {
                                wrfTaskins.WRF_Stage__c='Not Started';
                                /* Commented check for request type - ATR
                                if((IdCaseMap.get(wrfTaskins.WRF__c).WRF_Request_Type__c!='Automatic Toner Replenishment (ATR)'))
                                {
                                    wrfTaskins.WRF_Stage__c='Not Started';
                                }
                                */
                            }
                        }
               }
            }
        }
        if(Trigger.IsUpdate)
        {
            for(WRF_Task__c wrfTaskins:(List<WRF_Task__c>)Trigger.New)
            {
                if(IdCaseMap.containskey(wrfTaskins.WRF__c))
                {
                    if( (IdCaseMap.get(wrfTaskins.WRF__c).WRF_Request_Type__c=='Automatic Toner Replenishment (ATR)') && wrfTaskins.recordtypeid==WRFTaskRecType.get('WRF Task').getRecordTypeId() && wrfTaskins.Disposition_Code__c=='MPS Implementation' && wrfTaskins.status__c=='Completed')
                    {
                        System.debug('UPDATING....');
                        wrfTaskins.WRF_Stage__c='Live';
                    }
                }
            }
            updateWRFStageOpportunity();
        }

        // Update 'initial Pricing Complete' date on parent
        Map<Id, WRF_Task__c> parents = new Map<Id, WRF_Task__c>();

        if(parentIds.size()>0)
        for (WRF_Task__c parent : [SELECT Id, Initial_Pricing_Completed__c FROM WRF_Task__c WHERE Id IN :parentIds]) {
            parents.put(parent.Id, parent);
        }

        for (WRF_Task__c task : (List<WRF_Task__c>)Trigger.New) {
            if (task.Parent_WRF_Task__c != null && task.Task_Type__c == 'Pricing/CPM' && task.Status__c == 'Completed') {
                Id parentId = task.Parent_WRF_Task__c;
                WRF_Task__c parent = parents.get(parentId);

                if (parent.Initial_Pricing_Completed__c == null) {
                    parent.Initial_Pricing_Completed__c = Datetime.now();
                }
            }
        }

        update parents.values();
    }
    public static void afterinsertupdatelogic()
    {
        Autosequenceing();
        KPIStageStatusCal();
        if(Trigger.IsInsert)
        {

        }
        if(Trigger.IsUpdate)
        {
            updateWRFStageOpportunity();
            //Added for story S-423432 [Case#00730159]
            setAllTaskCompleteFlag();
            //End S-423432 [Case#00730159]
        }

        if(Trigger.isafter){ // Case # 00279709
            updateParentStage_upon_Child();
        }
    }

     //Added for S-423432 [Case#00730159]
    public static void setAllTaskCompleteFlag(){

    	Set<ID> cIds = new Set<Id>();
    	List<Case> caseToBeUpdate = new List<Case>();

    	 String WRFRecordType = Schema.SObjectType.Case.getRecordTypeInfosByName().get(WORK_REQUEST).getRecordTypeId();

    	for(WRF_Task__c wtsk:(List<WRF_Task__c>)Trigger.New){
    		Map<Id, WRF_Task__c> oldMap = (Map<Id, WRF_Task__c>) Trigger.oldMap;
    		if((oldMap == null || (oldMap != null && oldMap.get(wtsk.id).Status__c != wtsk.Status__c) ) && wtsk.Status__c == STATUS_COMPLETE){
    			cIds.add(wtsk.WRF__c);
    		}
    	}

    	for(Case c: [Select id, All_Task_Closed__c, (Select id, Status__c
    								from WRF_Tasks__r
    								Where Status__c != :STATUS_COMPLETE)
    					from Case where id in:cIds ]){
    		List<WRF_Task__c> openTasks = c.WRF_Tasks__r;

    		if(openTasks.size() == 0){
    		c.All_Task_Closed__c = true;
    		caseToBeUpdate.add(c);
    		}

    		if(caseToBeUpdate.size() > 0)
    		update caseToBeUpdate;
    	}

    }//END S-423432 [Case#00730159]

    public static void updateParentStage_upon_Child(){
        if(Trigger.isafter){
            set<Id> parentTaskIds = new set<Id>();
            Map<Id,String> mapRec = new  Map<Id,String>();
             for(WRF_Task__c wtsk:(List<WRF_Task__c>)Trigger.New){
                 if(  wtsk.Parent_WRF_Task__c!=null     &&  wtsk.status__C!='Completed'){
                        parentTaskIds.add(wtsk.Parent_WRF_Task__c);
                    mapRec.put(wtsk.Parent_WRF_Task__c,wtsk.Status__c);
                }

            }
            if(parentTaskIds.size()>0){
            list<WRF_Task__c> Parent_WRF_toUpdate = new list<WRF_Task__c>();
                for(Id oid : parentTaskIds){
                    WRF_Task__c w = new WRF_Task__c(Id =oid);
                    w.Status__c = mapRec.get(  oid);
                    if(w.Status__c =='Awaiting Action')
                    w.WRF_Stage__c= 'Awaiting Action';
                    Parent_WRF_toUpdate.add(w);

                }
                update Parent_WRF_toUpdate;

            }
        }
    }


    public static void beforedeletelogic()
    {
         updatepricinganalystonDELETE();
    }
    public static void afterdeletelogic()
    {
        for(WRF_Task__c wrfsubTaskold:(List<WRF_Task__c>)Trigger.Old)
          {
            caseIds.add(wrfsubTaskold.WRF__c);
          }
        caseMap = new Map<Id, Case>([Select id, Total_WRF_Tasks__c, WRF_Tasks_Completed__c, Pricing_Analyst__c, Compliance_Mgr__c, Bid_Writer__c,status
                                 from Case where id in :caseIds and status NOT IN ('Closed', 'Cancelled')]);
        for(WRF_Task__c wrfbothTaskold:(List<WRF_Task__c>)Trigger.Old)
        {
            if(Trigger.IsDelete && Trigger.IsAfter)
                 {
                        Case caseRec = caseMap.get(wrfbothTaskold.WRF__c);
                        system.debug('executeoncetest.casepricinganalyst1'+executeoncetest.casepricinganalyst1);
                        //if(caseRec.status!='Closed' && caseRec.status!='Cancelled')
                        if(caseRec!=null)
                        {
                            caseRec.Pricing_Analyst__c=   executeoncetest.casepricinganalyst1;
                        }
                 }
        }
        List<AggregateResult> resList = [Select WRF__c myReq, SUM(WRF_Task_Count__c) Total_Tasks_Count, SUM(WRF_Task_Complete_Count__c) Completed_Count,MAX(Pricing_Analyst__c) Analyst, MAX(Bid_Writer__c) BidWriter, MAX(Compliance_Legal__c) Compliance
                                     from WRF_Task__c where WRF__c IN :caseIds group by WRF__c];
            system.debug('The aggregate result'+resList);
            for(AggregateResult res: resList)
            {
              Id caseId = String.valueOf(res.get('myReq'));
              Case caseRec = caseMap.get(caseId);
              //List<Case> caseRec = caseMap.get(caseId);
              if(caseRec != null)
              {
                caseRec.Total_WRF_Tasks__c     = Integer.valueOf(res.get('Total_Tasks_Count'));
                caseRec.WRF_Tasks_Completed__c = Integer.valueOf(res.get('Completed_Count'));
                //caseRec.Pricing_Analyst__c     = String.valueOf(res.get('Analyst'));
                caseRec.Compliance_Mgr__c      = String.valueOf(res.get('Compliance'));
                caseRec.Bid_Writer__c          = String.valueOf(res.get('BidWriter'));
              }
            }
            if(executeoncetest.WRFCase && Trigger.IsAfter && Trigger.IsDelete)
            {
                executeoncetest.WRFCase=false;
                update caseMap.values();
            }
    }
  /* public static void workflowrules() //By Nishant : Commenting this method for migration as call of this method is commented.
    {
        for(WRF_Task__c wtskbefore : (List<WRF_Task__c>)Trigger.new)
        {
            if(Trigger.IsUpdate)
            {
               WRF_Task__c oldTask = (WRF_Task__c)Trigger.oldMap.get(wtskbefore.Id);
               if(wtskbefore.Assigned_To__c!=oldTask.Assigned_To__c)
               {
                  wtskbefore.Previously_Assigned_To__c= oldTask.Assigned_To_Name__c;
                  wtskbefore.Previously_Assigned_Date__c=System.now();
               }
            }
        }
    }*/
    public static void updateparentonDispostionType(Map<Id,Case> pass_mapidcase,Map<Id,WRF_Task__c> pass_updateparenttask)
    {

    System.debug('&&&&&&&&&&&&&&&inside function '+pass_updateparenttask);

       if(Trigger.isafter && (Trigger.isInsert || Trigger.IsUpdate))
        {
            for(WRF_Task__c wrfsubTask:(List<WRF_Task__c>)Trigger.New)
            {

                 //****************Update the Parent WRF Task stage based on Sub Task disposition code and type*************//
                 if((wrfsubTask.recordtypeid==WRFTaskRecType.get('WRF Sub Task').getRecordTypeId()) && (wrfsubTask.Parent_WRF_Task__c != null))
                  {
                      // Check if the parent WRF Task is already in the map
                      if (Task_Map.containsKey(wrfsubTask.Parent_WRF_Task__c))
                       WRF_Task__c lclTask = Task_Map.remove(wrfsubTask.Parent_WRF_Task__c);

                      // Add the new key value to the map
                       Task_Map.put(wrfsubTask.Parent_WRF_Task__c,wrfsubTask);
                  }
             }

           System.debug('&&&&&&&&&&&&  Task_Map'+Task_Map);



             //Fetch all the subtasks belonging to the parent in trigger.new
             for(WRF_Task__c parentandalltask_alias:[Select id,Status__c,Assigned_To__c,WRF__c,Disposition_Code__c,Task_Type__c,recordtypeid,Parent_WRF_Task__c,lastmodifieddate from WRF_Task__c where Parent_WRF_Task__c IN :Task_Map.keySet() order by lastmodifieddate desc])
             {
                 List<WRF_Task__c> wrftemlist1= new List<WRF_Task__c>();
                 if(subtaskforparent.containskey(parentandalltask_alias.Parent_WRF_Task__c))
                    {
                       wrftemlist1= subtaskforparent.get(parentandalltask_alias.Parent_WRF_Task__c);
                       subtaskforparent.remove(parentandalltask_alias.Parent_WRF_Task__c);
                       wrftemlist1.add(parentandalltask_alias);
                       subtaskforparent.put(parentandalltask_alias.Parent_WRF_Task__c,wrftemlist1);
                    }
                    else
                    {
                       wrftemlist1.add(parentandalltask_alias);
                       subtaskforparent.put(parentandalltask_alias.Parent_WRF_Task__c,wrftemlist1);
                    }
             }


           System.debug('&&&&&&&&&&&&&&&inside here ');



             // Update the Parent WRF Task stage based on Sub Task disposition code and type
             for(WRF_Task__c wrftask : [select id,WRF_Stage__c,Disposition_Code__c,WRF__c,WRF__r.WRF_Opportunity__r.StageName,Status__c,WRF__r.WRF_Request_Type__c,WRF__r.CPM_Required__c from WRF_Task__c where recordtype.name = 'WRF Task' and Id IN :Task_Map.keySet()  and status__c NOT IN ('Completed', 'Cancelled')])
             {
               system.debug('************'+wrftask);
               system.debug('@@@@'+wrftask.WRF__c);
               system.debug('@@@@'+wrftask.WRF_Stage__c);
               system.debug('@@@@'+wrftask.WRF__r.WRF_Opportunity__r.StageName);
               system.debug('@@@@'+wrftask.WRF__r.WRF_Request_Type__c);
               MPSImplementtionlogic1=false;
               MPSImplementtionlogic2=false;
               MPSImplementtionlogic3=false;
               MPSImplementtionlogic4=false;
               MPSImplementtionlogic5=false;
               List<WRF_Task__c> parentandalltask=subtaskforparent.get(wrftask.id);
               system.debug('parentandalltask'+parentandalltask.size());
               //String CaseRequestType= Task_Map.get(wrftask.id).WRF__r.WRF_Request_Type__c;

               String lclDispositiontype=Task_Map.get(wrftask.id).Disposition_Code__c;

               String lclTaskStatus = Task_Map.get(wrftask.id).Status__c;
               String lclTaskType = Task_Map.get(wrftask.id).Task_Type__c;
               system.debug('CPM Required'+wrftask.WRF__r.CPM_Required__c);
               system.debug('@@lclDispositiontype'+lclDispositiontype+'@lclTaskStatus '+lclTaskStatus+'@lclTaskType '+lclTaskType ) ;
               if(lclDispositiontype=='Bids' || lclDispositiontype=='Tech Depot' ||  lclDispositiontype=='Transition' ||  lclDispositiontype=='Remediation'  ||  lclDispositiontype=='Public/GPO' || lclDispositiontype== 'OD N Remediation' || lclDispositiontype== 'OD N Bid')
               {
                   if (lclTaskType == 'Cross Referencing' && lclTaskStatus!='Not Started' && lclTaskStatus!='Completed'){
                                  system.debug('lclTaskStatus111111-----'+lclTaskStatus);
                                  system.debug('lclTaskType111111-----'+lclTaskType);
                     wrftask.WRF_Stage__c = 'Cross referencing';}
                   else if (lclTaskType == 'Pricing/CPM' && lclTaskStatus!='Not Started' && lclTaskStatus!='Completed') {
                                  system.debug('lclTaskStatus-----'+lclTaskStatus);
                                  system.debug('lclTaskType-----'+lclTaskType);
                     wrftask.WRF_Stage__c = 'Pricing';  }
                   else if ((lclTaskType == 'Cross Referencing Revisit'  || lclTaskType == 'Pricing/CPM Revisit') && lclTaskStatus!='Not Started' && lclTaskStatus!='Completed')
                     wrftask.WRF_Stage__c = 'Revisit';
                   else if ((lclTaskType == 'Pricing Implementation')&&(lclTaskStatus=='Completed')&&(wrftask.WRF__r.WRF_Opportunity__r.StageName=='100%-Won'))
                     {wrftask.WRF_Stage__c = 'Won';
                     system.debug('@'+wrftask.WRF_Stage__c);}
                   else if (lclTaskType == 'Pricing Implementation' && lclTaskStatus!='Not Started' && lclTaskStatus!='Completed')
                     {

                      wrftask.WRF_Stage__c = 'Pricing Implementation';
                      system.debug('@'+wrftask.WRF_Stage__c);
                    }
                   else if (lclTaskType == 'Pricing/CPM' && lclTaskStatus=='Completed' && wrftask.WRF__r.CPM_Required__c==false)
                     wrftask.WRF_Stage__c= 'Pending Award';

                   else if (lclTaskType == 'Data Pull' && lclTaskStatus!='Not Started' && lclTaskStatus!='Completed')
                     {
                     wrftask.WRF_Stage__c= 'Cross referencing';
                     system.debug('@'+wrftask.WRF_Stage__c);
                     }
                   else if (lclTaskType == 'Special Task' && lclTaskStatus!='Not Started' && lclTaskStatus!='Completed')
                     {
                     wrftask.WRF_Stage__c= 'Pricing';
                     system.debug('@'+wrftask.WRF_Stage__c);
                     }
                   else
                   {
                        if(parentandalltask!=null)
                        {
                            for(WRF_Task__c parentandalltask_alias1:parentandalltask)
                            {
                                if(parentandalltask_alias1.Task_Type__c== 'Cross Referencing' && parentandalltask_alias1.Status__c!='Not Started' && parentandalltask_alias1.Status__c!='Completed')
                                {
                                    wrftask.WRF_Stage__c = 'Cross referencing';
                                    break;
                                }
                                else if(parentandalltask_alias1.Task_Type__c== 'Pricing/CPM' && parentandalltask_alias1.Status__c!='Not Started' && parentandalltask_alias1.Status__c!='Completed')
                                {
                                    wrftask.WRF_Stage__c = 'Pricing';
                                    break;
                                }
                                else if((parentandalltask_alias1.Task_Type__c== 'Cross Referencing Revisit' || parentandalltask_alias1.Task_Type__c== 'Pricing/CPM Revisit') && parentandalltask_alias1.Status__c!='Not Started' && parentandalltask_alias1.Status__c!='Completed')
                                {
                                    wrftask.WRF_Stage__c = 'Revisit';
                                    break;
                                }
                                else if(parentandalltask_alias1.Task_Type__c== 'Pricing Implementation' && parentandalltask_alias1.Status__c=='Completed' && wrftask.WRF__r.WRF_Opportunity__r.StageName=='100%-Won')
                                {
                                    wrftask.WRF_Stage__c = 'Won';
                                    break;
                                }
                                else if(parentandalltask_alias1.Task_Type__c== 'Pricing Implementation' && parentandalltask_alias1.Status__c!='Not Started' && parentandalltask_alias1.Status__c!='Completed')
                                {

                                    wrftask.WRF_Stage__c = 'Pricing Implementation';
                                    break;
                                }
                                else if(parentandalltask_alias1.Task_Type__c== 'Pricing/CPM' && parentandalltask_alias1.Status__c=='Completed' && wrftask.WRF__r.CPM_Required__c==false)
                                {
                                        wrftask.WRF_Stage__c= 'Pending Award';
                                        break;
                                }
                            }
                        }
                   }
              }
              system.debug('wrftask.Disposition_Code__c-->'+wrftask.Disposition_Code__c);
              system.debug('wrftask.WRF_Stage__c-->'+wrftask.WRF_Stage__c);
              system.debug('lclTaskType-->'+lclTaskType);
              system.debug('lclTaskStatus-->'+lclTaskStatus);
              //MPS Implementation functionality
              if(wrftask.WRF__r.WRF_Request_Type__c=='Automatic Toner Replenishment (ATR)' && wrftask.Disposition_Code__c=='MPS Implementation')
              {
                  if(lclTaskType=='Software Install / DCA' && lclTaskStatus!='Not Started')
                  {
                      wrftask.WRF_Stage__c='Created & Sent DCA';
                  }
                  if(lclTaskType=='AVF/Labels' && lclTaskStatus!='Not Started')
                  {
                      wrftask.WRF_Stage__c='AVF/Labels';
                  }
                  if(parentandalltask!=null)
                  {
                      for(WRF_Task__c parentandalltask_alias:parentandalltask)
                      {
                          if(parentandalltask_alias.Task_Type__c=='AVF' && parentandalltask_alias.Status__c!='Completed')
                          {
                              system.debug('MPSImplementtionlogic1');
                              MPSImplementtionlogic1=true;
                          }
                          if(parentandalltask_alias.Task_Type__c=='AVF/Labels' && parentandalltask_alias.Status__c=='Completed')
                          {
                              system.debug('MPSImplementtionlogic2');
                              MPSImplementtionlogic2=true;
                          }
                          if(parentandalltask_alias.Task_Type__c=='MARS Upload' && parentandalltask_alias.Status__c!='Completed')
                          {
                              system.debug('MPSImplementtionlogic3');
                              MPSImplementtionlogic3=true;
                          }
                          if(parentandalltask_alias.Task_Type__c=='AVF' && parentandalltask_alias.Status__c=='Completed')
                          {
                              system.debug('MPSImplementtionlogic4');
                              MPSImplementtionlogic4=true;
                          }
                          if(parentandalltask_alias.Task_Type__c=='MARS Upload' && parentandalltask_alias.Status__c=='Completed')
                          {
                              system.debug('MPSImplementtionlogic5');
                              MPSImplementtionlogic5=true;
                          }
                      }
                  }
                  if(MPSImplementtionlogic1 && MPSImplementtionlogic2 && MPSImplementtionlogic3)
                  {
                      wrftask.WRF_Stage__c='AVF Complete/Labels placed';
                  }
                  if(MPSImplementtionlogic2 && MPSImplementtionlogic4 && MPSImplementtionlogic3)
                  {
                     wrftask.WRF_Stage__c='Account Setup Complete';
                  }
                  if(MPSImplementtionlogic2 && MPSImplementtionlogic4 && MPSImplementtionlogic5)
                  {
                      wrftask.WRF_Stage__c='Loaded into Mars';
                  }
              }
              if(lclTaskStatus !='Not Started')
              {
                 if(wrftask.Status__c=='Not Started')
                 {
                     wrftask.Status__c='In Progress';
                 }
              }

               lstRelatedTasks.add(wrftask);
             }
         }

         System.debug('&&&&&&&&&&&&&&&&&&lstRelatedTasks'+  executeoncetest.Tasktypeupdate);
                  System.debug('&&&&&&&&&&&&&&&&&&variable'+  lstRelatedTasks);

         if(lstRelatedTasks.size() > 0 && executeoncetest.Tasktypeupdate)
         {
             system.debug('@@in update');
             executeoncetest.Tasktypeupdate=false;
             try{
             Database.update( lstRelatedTasks, false);
             }catch(Exception e){
                 system.debug('Exception'+e);
             }
         }

    }
    public static void Autosequenceing()
    {
        //***********Making sets of data from trigger.new to query later.***********//
        system.debug('Auto sequencing method called---->');
        for(WRF_Task__c wrfTask:(List<WRF_Task__c>)Trigger.New)
        {
            if(wrfTask.WRF__c!=null)
            {
                caseids1.add(wrfTask.WRF__c);
            }
            if(wrfTask.recordtypeid==WRFTaskRecType.get('WRF Sub Task').getRecordTypeId())
            {
                 parenttaskid.add(wrfTask.Parent_WRF_Task__c);
            }
            if(Trigger.IsUpdate)
            {
                wrfsubtaskid.add(wrftask.id);
            }
        }
        //*************End of set Population*************//
        //*********************Query relevant data*****************//
        if(executeoncetest.querycaseonce1)
        {
            mapidcase = new Map<Id,Case>([Select id,WRF_Request_Type__c from case where id in:caseids1]);
            executeoncetest.querycaseonce1=false;
        }
        if(parenttaskid.size()>0)
        updateparenttask= new Map<Id,WRF_Task__c>([Select id,Status__c,WRF_Stage__c,Disposition_Code__c from WRF_Task__c where id in:parenttaskid]);
        List<Case_SLA__c> caserequesttype=[Select id,Request_Type__c,Routed_to__c,Parent_Task_Dis_Code__c,Turnaround_Time__c,Task_Disp_Code__c,Task_Type__c,Task_Status__c,Task_Sequence__c,Control_Task_Sequence__c,Automatic__c from Case_SLA__c where recordtype.name=:'WRF Task'];
        List<Case_SLA__c> caserequesttype1=caserequesttype;
         for(Case_SLA__c SLAalias:caserequesttype)
         {
            //mapcontrolseqcaseSLA.put(SLAalias.Control_Task_Sequence__c,SLAalias);
            List<Case_SLA__c> templist1 = new List<Case_SLA__c>();
            if(maprequestlistCaseSLA.containskey(SLAalias.Request_Type__c)){
                templist1 = maprequestlistCaseSLA.get(SLAalias.Request_Type__c);
                maprequestlistCaseSLA.remove(SLAalias.Request_Type__c);
                templist1.add(SLAalias);
                maprequestlistCaseSLA.put(SLAalias.Request_Type__c,templist1);
            }else{
                templist1.add(SLAalias);
                maprequestlistCaseSLA.put(SLAalias.Request_Type__c,templist1);
            }
        }
        for(Case_SLA__c SLAalias:caserequesttype)
        {
            //mapcontrolseqcaseSLA.put(SLAalias.Control_Task_Sequence__c,SLAalias);
            List<Case_SLA__c> templist1 = new List<Case_SLA__c>();
            for(Case_SLA__c SLAalias1:caserequesttype1){
                if(SLAalias1.Control_Task_Sequence__c!=null){
                    if(SLAalias1.Control_Task_Sequence__c.contains(string.valueof(SLAalias.Task_Sequence__c))){
                        templist1.add(SLAalias1);
                        maprequestlistcontrolseq.put(string.valueof(SLAalias.Task_Sequence__c),templist1);
                        system.debug('maprequestlistcontrolseq**'+maprequestlistcontrolseq);
                    }
                }
            }

        }
        if(parenttaskid.size()>0)
        for(WRF_Task__c wrfalias:[Select id,Control_Task_Sequence__c,Task_Sequence__c,Status__c from WRF_Task__c where Parent_WRF_Task__c in:parenttaskid and id not in:wrfsubtaskid])
        {
            List<WRF_Task__c> wrftemlist = new List<WRF_Task__c>();
            eachstepsubtasksnum.put(string.valueof(wrfalias.Task_Sequence__c),wrfalias);

        }
        //***********************End of required data from query***************//
        if(Trigger.IsInsert)
        {
            //****************Auto Sequencing of Sub Tasks for Insert of Parent Task**************//
            for(WRF_Task__c wrfparentTask:(List<WRF_Task__c>)Trigger.New)
            {
                       if(wrfparentTask.recordtypeid==WRFTaskRecType.get('WRF Task').getRecordTypeId())
                       {
                            Case Casealias=mapidcase.get(wrfparentTask.WRF__c);
                            system.debug('The case is'+Casealias);
                            if(Casealias!=null)
                            {
                              List<Case_SLA__c> CaseSLAalias=maprequestlistCaseSLA.get(Casealias.WRF_Request_Type__c);
                              //Case_SLA__c CaseSLAalias=maprequestCaseSLA.get(Casealias.WRF_Request_Type__c);
                              system.debug('The SLA is'+CaseSLAalias);
                              //if(!CaseSLAalias.isempty())
                              if (CaseSLAalias != null)
                              {
                                  for(Case_SLA__c CaseSLAalias1:CaseSLAalias)
                                  {
                                      if(CaseSLAalias1.Control_Task_Sequence__c==null && CaseSLAalias1.Parent_Task_Dis_Code__c==wrfparentTask.Disposition_Code__c && CaseSLAalias1.Automatic__c==true)
                                      {
                                          system.debug('Prepare sub tasks');
                                          WRF_Task__c initialwrfsubtask= new WRF_Task__c();
                                          initialwrfsubtask.recordtypeid=WRFTaskRecType.get('WRF Sub Task').getRecordTypeId();
                                          initialwrfsubtask.Parent_WRF_Task__c=wrfparentTask.id;
                                          initialwrfsubtask.WRF__c=wrfparentTask.WRF__c;
                                          initialwrfsubtask.Disposition_Code__c=CaseSLAalias1.Task_Disp_Code__c;
                                          initialwrfsubtask.Status__c=CaseSLAalias1.Task_Status__c;
                                          initialwrfsubtask.Task_Sequence__c = CaseSLAalias1.Task_Sequence__c;
                                          initialwrfsubtask.Due_Date__c = system.Today() + integer.valueof(CaseSLAalias1.Turnaround_Time__c);
                                          initialwrfsubtask.Control_Task_Sequence__c = CaseSLAalias1.Control_Task_Sequence__c;
                                          initialwrfsubtask.Task_Type__c=CaseSLAalias1.Task_Type__c;
                                          initialwrfsubtask.Assignment_Group__c=CaseSLAalias1.Routed_to__c;
                                          insertinitialtasks.add(initialwrfsubtask);
                                          //wrftask2.Status__c = 'In Progress';
                                      }
                                  }
                              }
                            }

                       }
             }
        }
        if(Trigger.IsUpdate)
        {
            for(WRF_Task__c wrfsubTask:(List<WRF_Task__c>)Trigger.New)
            {
                //**********************Auto Sequencing of subtasks on completion on another subtask**************//
                        if(wrfsubTask.recordtypeid==WRFTaskRecType.get('WRF Sub Task').getRecordTypeId())
                        {

                            if(wrfsubTask.Status__c=='Completed')
                            {
                                system.debug('The sub task here1234');
                                Case Casealias=mapidcase.get(wrfsubTask.WRF__c);
                                WRF_Task__c parenttaskalias=updateparenttask.get(wrfsubTask.Parent_WRF_Task__c);
                                list<string> seqNum= new list<string>();
                                integer caseSLACount = 0;
                                list<Case_SLA__c> caseS = maprequestlistcontrolseq.get(string.valueof(wrfsubTask.Task_Sequence__c));
                                System.debug('888888888>>'+maprequestlistcontrolseq);
                                System.debug('------->>>>>'+string.valueof(wrfsubTask.Task_Sequence__c));
                                system.debug('maprequestlistcontrolseq**'+maprequestlistcontrolseq.get(string.valueof(wrfsubTask.Task_Sequence__c)));
                                if(caseS!=null){
                                    for(Case_SLA__c caseSALControlseq :caseS)
                                    {
                                        seqNum= caseSALControlseq.Control_Task_Sequence__c.split(';');
                                        system.debug('controlseq details**'+seqNum);
                                        if(caseSALControlseq.Control_Task_Sequence__c==string.valueof(wrfsubTask.Task_Sequence__c)){
                                            caseSLACount++;
                                        }
                                    }
                                }
                                if(Casealias!=null && parenttaskalias!=null)
                                {
                                    List<WRF_Task__c> paralleltask= new List<WRF_Task__c>();
                                    system.debug('The sub task here+the case');
                                    Integer countcompletedtask=0;
                                    //system.debug('parallel task boolean-->'+bolparalleltask);
                                    /*if(wrftask2.Control_Task_Sequence__c!=null)
                                    {
                                        paralleltask=eachstepsubtasks.get(wrftask2.Control_Task_Sequence__c);
                                    } */
                                    if(!seqNum.isempty()){
                                        for(string taskN:seqNum){
                                        system.debug('eachstepsubtasksnum**'+eachstepsubtasksnum);
                                            WRF_Task__c WRFT = eachstepsubtasksnum.get(taskN);
                                            if(WRFT!=null)
                                                paralleltask.add(WRFT);
                                        }
                                    }

                                    if(paralleltask==null){
                                        paralleltask = new List<WRF_Task__c>();
                                    }

                                    //integer caseSLACount = [select count() from Case_SLA__c where recordtypeid=:'012M00000004aVw' and Control_Task_Sequence__c =:string.valueof(wrftask2.Task_Sequence__c)];//taskSeq];//Control_Task_Sequence__c];
                                    system.debug('paralleltask**'+paralleltask);
                                    if(!paralleltask.isempty() && caseSLACount==0 ){
                                        Integer Sizeoflist= paralleltask.size();
                                        String controlsequence='';
                                        //List<String> controlsequence= new List<String>();
                                        system.debug('The sub task parallel');
                                        for(WRF_Task__c wrf1:paralleltask)
                                        {
                                        system.debug('wrf1**'+wrf1);
                                            if(wrf1!=null && wrf1.Status__c=='Completed')
                                            {
                                                //controlsequence.add(wrf1.Task_Sequence__c);
                                                controlsequence=controlsequence+wrf1.Task_Sequence__c+';';
                                                system.debug('controlsequence**'+controlsequence);
                                                countcompletedtask++;
                                            }
                                        }
                                        controlsequence=controlsequence+wrfsubTask.Task_Sequence__c;
                                        system.debug('The string'+controlsequence+'countcompletedtask**'+countcompletedtask);
                                        // To sort the sequence
                                        List<string> part = new List<string>();
                                        part = controlsequence.split(';');
                                        part.sort();
                                        controlsequence = null;
                                        for(string val:part){
                                            if(controlsequence!=null){
                                                controlsequence =controlsequence+';'+val;
                                            }else{
                                                controlsequence = val;
                                            }
                                        }
                                        //---End---
                                        system.debug('The string'+controlsequence+'Sizeoflist'+Sizeoflist);
                                        if(Sizeoflist==countcompletedtask)
                                        {
                                            system.debug('List matches');
                                            List<Case_SLA__c> CaseSLAalias2=maprequestlistCaseSLA.get(Casealias.WRF_Request_Type__c);
                                            if(!CaseSLAalias2.isempty())
                                            {
                                                for(Case_SLA__c CaseSLAalias3:CaseSLAalias2)
                                                {
                                                    if(CaseSLAalias3.Control_Task_Sequence__c==controlsequence && CaseSLAalias3.Automatic__c==true && CaseSLAalias3.Parent_Task_Dis_Code__c==parenttaskalias.Disposition_Code__c)
                                                    {
                                                        system.debug('The fetched case sla1-->'+CaseSLAalias3);
                                                          WRF_Task__c initialwrfsubtask= new WRF_Task__c();
                                                          initialwrfsubtask.recordtypeid=WRFTaskRecType.get('WRF Sub Task').getRecordTypeId();
                                                          initialwrfsubtask.Parent_WRF_Task__c=wrfsubTask.Parent_WRF_Task__c;
                                                          initialwrfsubtask.WRF__c=wrfsubTask.WRF__c;
                                                          initialwrfsubtask.Disposition_Code__c=CaseSLAalias3.Task_Disp_Code__c;
                                                          initialwrfsubtask.Status__c=CaseSLAalias3.Task_Status__c;
                                                          initialwrfsubtask.Task_Sequence__c = CaseSLAalias3.Task_Sequence__c;
                                                          initialwrfsubtask.Due_Date__c = system.Today() + integer.valueof(CaseSLAalias3.Turnaround_Time__c);
                                                          initialwrfsubtask.Control_Task_Sequence__c = CaseSLAalias3.Control_Task_Sequence__c;
                                                          initialwrfsubtask.Task_Type__c=CaseSLAalias3.Task_Type__c;
                                                          initialwrfsubtask.Assignment_Group__c=CaseSLAalias3.Routed_to__c;
                                                          insertinitialtasks.add(initialwrfsubtask);
                                                    }
                                                }
                                            }
                                        }

                                    }
                                    else if(!paralleltask.isempty() && caseSLACount!=0 )
                                    {
                                        Integer Sizeoflist= paralleltask.size();
                                        String controlsequence='';
                                        //List<String> controlsequence= new List<String>();
                                        system.debug('The sub task parallel');
                                        for(WRF_Task__c wrf1:paralleltask)
                                        {

                                            if(wrf1!=null && wrf1.Status__c=='Completed')
                                            {
                                                //controlsequence.add(wrf1.Task_Sequence__c);
                                                controlsequence=controlsequence+wrf1.Task_Sequence__c+';';
                                                countcompletedtask++;
                                            }
                                        }
                                        controlsequence=controlsequence+wrfsubTask.Task_Sequence__c;
                                        system.debug('The string'+controlsequence);
                                        // To sort the sequence
                                        List<string> part = new List<string>();
                                        part = controlsequence.split(';');
                                        part.sort();
                                        controlsequence = null;
                                        for(string val:part){
                                            if(controlsequence!=null){
                                                controlsequence =controlsequence+';'+val;
                                            }else{
                                                controlsequence = val;
                                            }
                                        }
                                        //---End---
                                        system.debug('The string'+controlsequence);
                                        if(Sizeoflist==countcompletedtask)
                                        {
                                            system.debug('List matches');
                                            List<Case_SLA__c> CaseSLAalias2=maprequestlistCaseSLA.get(Casealias.WRF_Request_Type__c);
                                            if(!CaseSLAalias2.isempty())
                                            {
                                                for(Case_SLA__c CaseSLAalias3:CaseSLAalias2)
                                                {
                                                    if(CaseSLAalias3.Control_Task_Sequence__c==controlsequence && CaseSLAalias3.Automatic__c==true && CaseSLAalias3.Parent_Task_Dis_Code__c==parenttaskalias.Disposition_Code__c)
                                                    {
                                                        system.debug('The fetched case sla2-->'+CaseSLAalias3);
                                                          WRF_Task__c initialwrfsubtask= new WRF_Task__c();
                                                          initialwrfsubtask.recordtypeid=WRFTaskRecType.get('WRF Sub Task').getRecordTypeId();
                                                          initialwrfsubtask.Parent_WRF_Task__c=wrfsubTask.Parent_WRF_Task__c;
                                                          initialwrfsubtask.WRF__c=wrfsubTask.WRF__c;
                                                          initialwrfsubtask.Disposition_Code__c=CaseSLAalias3.Task_Disp_Code__c;
                                                          initialwrfsubtask.Status__c=CaseSLAalias3.Task_Status__c;
                                                          initialwrfsubtask.Task_Sequence__c = CaseSLAalias3.Task_Sequence__c;
                                                          initialwrfsubtask.Due_Date__c = system.Today() + integer.valueof(CaseSLAalias3.Turnaround_Time__c);
                                                          initialwrfsubtask.Control_Task_Sequence__c = CaseSLAalias3.Control_Task_Sequence__c;
                                                          initialwrfsubtask.Task_Type__c=CaseSLAalias3.Task_Type__c;
                                                          initialwrfsubtask.Assignment_Group__c=CaseSLAalias3.Routed_to__c;
                                                          insertinitialtasks.add(initialwrfsubtask);
                                                    }
                                                }
                                            }
                                        }

                                        List<Case_SLA__c> CaseSLAalias4=maprequestlistCaseSLA.get(Casealias.WRF_Request_Type__c);
                                        if(!CaseSLAalias4.isempty())
                                        {
                                            for(Case_SLA__c CaseSLAalias5:CaseSLAalias4)
                                            {
                                                if(CaseSLAalias5.Control_Task_Sequence__c==string.valueOf(wrfsubTask.Task_Sequence__c) && CaseSLAalias5.Automatic__c==true && CaseSLAalias5.Parent_Task_Dis_Code__c==parenttaskalias.Disposition_Code__c)
                                                {
                                                    system.debug('The sub task make12');
                                                          WRF_Task__c initialwrfsubtask= new WRF_Task__c();
                                                          initialwrfsubtask.recordtypeid=WRFTaskRecType.get('WRF Sub Task').getRecordTypeId();
                                                          initialwrfsubtask.Parent_WRF_Task__c=wrfsubTask.Parent_WRF_Task__c;
                                                          initialwrfsubtask.WRF__c=wrfsubTask.WRF__c;
                                                          initialwrfsubtask.Disposition_Code__c=CaseSLAalias5.Task_Disp_Code__c;
                                                          initialwrfsubtask.Status__c=CaseSLAalias5.Task_Status__c;
                                                          initialwrfsubtask.Due_Date__c = system.Today() + integer.valueof(CaseSLAalias5.Turnaround_Time__c);
                                                          initialwrfsubtask.Task_Sequence__c = CaseSLAalias5.Task_Sequence__c;
                                                          initialwrfsubtask.Control_Task_Sequence__c = CaseSLAalias5.Control_Task_Sequence__c;
                                                          initialwrfsubtask.Task_Type__c=CaseSLAalias5.Task_Type__c;
                                                          initialwrfsubtask.Assignment_Group__c=CaseSLAalias5.Routed_to__c;
                                                          insertinitialtasks.add(initialwrfsubtask);
                                                }
                                            }
                                        }
                                    }
                                    else
                                    {
                                        List<Case_SLA__c> CaseSLAalias4=maprequestlistCaseSLA.get(Casealias.WRF_Request_Type__c);

                                        if (CaseSLAalias4 != null)
                                        {
                                            for(Case_SLA__c CaseSLAalias5:CaseSLAalias4)
                                            {
                                                if(CaseSLAalias5.Control_Task_Sequence__c==string.valueOf(wrfsubTask.Task_Sequence__c) && CaseSLAalias5.Automatic__c==true && CaseSLAalias5.Parent_Task_Dis_Code__c==parenttaskalias.Disposition_Code__c)
                                                {
                                                    system.debug('The sub task make34');
                                                          WRF_Task__c initialwrfsubtask= new WRF_Task__c();
                                                          initialwrfsubtask.recordtypeid=WRFTaskRecType.get('WRF Sub Task').getRecordTypeId();
                                                          initialwrfsubtask.Parent_WRF_Task__c=wrfsubTask.Parent_WRF_Task__c;
                                                          initialwrfsubtask.WRF__c=wrfsubTask.WRF__c;
                                                          initialwrfsubtask.Disposition_Code__c=CaseSLAalias5.Task_Disp_Code__c;
                                                          initialwrfsubtask.Status__c=CaseSLAalias5.Task_Status__c;
                                                          initialwrfsubtask.Due_Date__c = system.Today() + integer.valueof(CaseSLAalias5.Turnaround_Time__c);
                                                          initialwrfsubtask.Task_Sequence__c = CaseSLAalias5.Task_Sequence__c;
                                                          initialwrfsubtask.Control_Task_Sequence__c = CaseSLAalias5.Control_Task_Sequence__c;
                                                          initialwrfsubtask.Task_Type__c=CaseSLAalias5.Task_Type__c;
                                                          initialwrfsubtask.Assignment_Group__c=CaseSLAalias5.Routed_to__c;
                                                          insertinitialtasks.add(initialwrfsubtask);
                                                }
                                            }
                                        }
                                    }


                                }
                            }
                        }
            }
        }
        if(insertinitialtasks.size()>0 && executeoncetest.insertinitialtask)
        {
            executeoncetest.insertinitialtask=false;
            insert insertinitialtasks;
        }
        updateWRFCaseonINSERTUPDATE();
        updateparentonDispostionType(mapidcase,updateparenttask);

    }
    public static void KPIStageStatusCal()
    {
        if(Trigger.IsInsert)
        {
            for(WRF_Task__c wrfbothTask:(List<WRF_Task__c>)Trigger.New)
            {
                  if(wrfbothTask.Status__c!='Completed')
                  {
                      Record_History__c CaseStatusRecHistory12 = new Record_History__c();
                      CaseStatusRecHistory12.WRF_Task__c = wrfbothTask.id;
                      CaseStatusRecHistory12.Case__c= wrfbothTask.WRF__c;
                      CaseStatusRecHistory12.Status__c= wrfbothTask.Status__c;
                      CaseStatusRecHistory12.Start_Date__c= System.Now();
                      //insertrecordhistory.add(CaseStatusRecHistory12);
                      mapinsertrecordhistory.put(CaseStatusRecHistory12.WRF_Task__c+CaseStatusRecHistory12.Status__c+CaseStatusRecHistory12.Stage__c,CaseStatusRecHistory12);
                  }

                      if(wrfbothTask.WRF_Stage__c!=null && wrfbothTask.recordtypeid==WRFTaskRecType.get('WRF Task').getRecordTypeId())
                      {
                          Record_History__c CaseStatusRecHistory = new Record_History__c();
                          CaseStatusRecHistory.WRF_Task__c = wrfbothTask.id;
                          CaseStatusRecHistory.Case__c= wrfbothTask.WRF__c;
                          CaseStatusRecHistory.Stage__c= wrfbothTask.WRF_Stage__c;
                          CaseStatusRecHistory.Start_Date__c= System.now();
                          //CaseStatusRecHistory.No_of_Hours__c = (Businesshours.diff(bh.id,oldTask.Stage_Date_Time_Assigned__c, System.Now())/(1000*60*60));
                          system.debug('CaseStatusRecHistory--->'+CaseStatusRecHistory);
                          //insertrecordhistory.add(CaseStatusRecHistory);
                          mapinsertrecordhistory.put(CaseStatusRecHistory.WRF_Task__c+CaseStatusRecHistory.Status__c+CaseStatusRecHistory.Stage__c,CaseStatusRecHistory);
                          //wrfTask.Stage_Date_Time_Assigned__c=System.now();
                      }
            }
        }
        if(Trigger.IsUpdate)
        {
            // Added by Mohit for Story S-353024 to resolve soql 101 //
            DefaultBusinessHours_Id = Label.Default_BusinessHours_Id;
            BusinessHours_Id = Label.BusinessHours_Id;
            //gBusinessHours();//commented by Mohit for Story S-353024 to resolve soql 101 //
            for(WRF_Task__c wrfbothTaskput:(List<WRF_Task__c>)Trigger.New)
            {
                setstagewrf.add(wrfbothTaskput.id);
            }
            for(Record_History__c rec:[Select id,End_Date__c,WRF_Task__c,Start_Date__c,No_of_Hours__c,Stage__c,Status__c from Record_History__c where WRF_Task__c in:setstagewrf and Start_Date__c!=null and End_Date__c=null])
            {
                if(rec.Stage__c!=null) {// STAGE NOT NULL
                    updaterecordhis.put(rec.WRF_Task__c, rec);
                }
                if(rec.Status__c!=null){ // STATUS NOT NULL
                    updaterecordhis1.put(rec.WRF_Task__c, rec);
                }
            }
            for(WRF_Task__c wrfbothTask:(List<WRF_Task__c>)Trigger.New)
            {
              // Get the old Snapshot
              WRF_Task__c oldTask = (WRF_Task__c)Trigger.oldMap.get(wrfbothTask.Id);
              // Set WRF KPI Fields
              //Track the KPI in a custom object named Related History.
              if(wrfbothTask.recordtypeid==WRFTaskRecType.get('WRF Task').getRecordTypeId())
              {
                  if (wrfbothTask.WRF_Stage__c != oldTask.WRF_Stage__c && oldTask.WRF_Stage__c!=null)
                  {
                      system.debug('!!!!!!!'+wrfbothTask.Status_Date_Time_Assigned__c);
                            Record_History__c CaseStatusRecHistory32=updaterecordhis.get(wrfbothTask.id);
                            if(CaseStatusRecHistory32!=null)
                            {
                                CaseStatusRecHistory32.End_Date__c= System.now();
                                CaseStatusRecHistory32.No_of_Hours__c = (Businesshours.diff(DefaultBusinessHours_Id,CaseStatusRecHistory32.Start_Date__c, System.Now())/(1000*60*60));
                                //updaterecordhistory.add(CaseStatusRecHistory);
                                mapupdaterecordhistory.put(CaseStatusRecHistory32.WRF_Task__c+CaseStatusRecHistory32.Status__c+CaseStatusRecHistory32.Stage__c,CaseStatusRecHistory32);

                                if(wrfbothTask.WRF_Stage__c!=null)
                                {
                                    Record_History__c CaseStatusRecHistory1 = new Record_History__c();
                                    CaseStatusRecHistory1.WRF_Task__c = wrfbothTask.id;
                                    CaseStatusRecHistory1.Case__c= wrfbothTask.WRF__c;
                                    CaseStatusRecHistory1.Stage__c= wrfbothTask.WRF_Stage__c;
                                    CaseStatusRecHistory1.Start_Date__c= System.Now();
                                    //insertrecordhistory.add(CaseStatusRecHistory1);
                                    mapinsertrecordhistory.put(CaseStatusRecHistory1.WRF_Task__c+CaseStatusRecHistory1.Status__c+CaseStatusRecHistory1.Stage__c,CaseStatusRecHistory1);
                                }
                            }

                 }
                 else
                 {
                      if(wrfbothTask.WRF_Stage__c!=null && oldTask.WRF_Stage__c==null)
                      {
                          Record_History__c CaseStatusRecHistory43 = new Record_History__c();
                          CaseStatusRecHistory43.WRF_Task__c = wrfbothTask.id;
                          CaseStatusRecHistory43.Case__c= wrfbothTask.WRF__c;
                          CaseStatusRecHistory43.Stage__c= wrfbothTask.WRF_Stage__c;
                          CaseStatusRecHistory43.Start_Date__c= System.now();
                          //insertrecordhistory.add(CaseStatusRecHistory);
                          mapinsertrecordhistory.put(CaseStatusRecHistory43.WRF_Task__c+CaseStatusRecHistory43.Status__c+CaseStatusRecHistory43.Stage__c,CaseStatusRecHistory43);
                      }
                 }
              }
              if(wrfbothTask.recordtypeid==WRFTaskRecType.get('WRF Sub Task').getRecordTypeId() || wrfbothTask.recordtypeid==WRFTaskRecType.get('WRF Task').getRecordTypeId())
              {
                  if (wrfbothTask.Status__c != oldTask.Status__c)
                  {
                      system.debug('******'+wrfbothTask.Status_Date_Time_Assigned__c);
                      Record_History__c CaseStatusRecHistory111=updaterecordhis1.get(wrfbothTask.id);
                       if(CaseStatusRecHistory111!=null)
                            {
                                CaseStatusRecHistory111.End_Date__c= System.now();
                                CaseStatusRecHistory111.No_of_Hours__c = (Businesshours.diff(DefaultBusinessHours_Id,CaseStatusRecHistory111.Start_Date__c, System.Now())/(1000*60*60));
                                //updaterecordhistory.add(CaseStatusRecHistory11);
                                mapupdaterecordhistory.put(CaseStatusRecHistory111.WRF_Task__c+CaseStatusRecHistory111.Status__c+CaseStatusRecHistory111.Stage__c,CaseStatusRecHistory111);

                                if(wrfbothTask.Status__c!='Completed')
                                {
                                    Record_History__c CaseStatusRecHistory122 = new Record_History__c();
                                    CaseStatusRecHistory122.WRF_Task__c = wrfbothTask.id;
                                    CaseStatusRecHistory122.Case__c= wrfbothTask.WRF__c;
                                    CaseStatusRecHistory122.Status__c= wrfbothTask.Status__c;
                                    CaseStatusRecHistory122.Start_Date__c= System.Now();
                                    //insertrecordhistory.add(CaseStatusRecHistory12);
                                    mapinsertrecordhistory.put(CaseStatusRecHistory122.WRF_Task__c+CaseStatusRecHistory122.Status__c+CaseStatusRecHistory122.Stage__c,CaseStatusRecHistory122);
                                }

                            }
                  }
              }
          }

        }
        system.debug('insertrecordhistory-->'+mapinsertrecordhistory);
        system.debug('updaterecordhistory-->'+mapupdaterecordhistory);
        database.insert (mapinsertrecordhistory.values(),false);
        update mapupdaterecordhistory.values();
    }
    public static void updateWRFCaseonINSERTUPDATE()
    {
        //******************Populating sets to query******************//
        if (Trigger.IsInsert || Trigger.Isupdate)
        {
          for(WRF_Task__c wrfTask:(List<WRF_Task__c>)Trigger.New)
          {
            alltask.add(wrftask.id);
            caseIds.add(wrfTask.WRF__c);
            system.debug('!!!!!!'+wrfTask.WRF__c);
          }
        }
        /*Else If (Trigger.isDelete)
        {
          for(WRF_Task__c wrfTask:(List<WRF_Task__c>)Trigger.New)
          {
            caseIds.add(wrfTask.WRF__c);
            system.debug('!!!!!!'+wrfTask.WRF__c);
          }
        }*/
        //*******************End of populating sets*************//
        //*****************Query of WRF case to update************//
        caseMap = new Map<Id, Case>([Select id, Total_WRF_Tasks__c, WRF_Tasks_Completed__c, Pricing_Analyst__c, Compliance_Mgr__c, Bid_Writer__c,status
                                 from Case where id in :caseIds and status NOT IN ('Closed', 'Cancelled')]);
        for(WRF_Task__c alltasks:[Select id,Control_Task_Sequence__c,Task_Sequence__c,lastmodifieddate,Status__c,Assigned_To__c,WRF__c,Disposition_Code__c,Task_Type__c,recordtypeid from WRF_Task__c where WRF__c in:caseids1 and id not in:alltask])
        {
            List<WRF_Task__c> wrftemlist = new List<WRF_Task__c>();
             if(caseandalltask.containskey(alltasks.WRF__c))
             {
               wrftemlist= caseandalltask.get(alltasks.WRF__c);
               caseandalltask.remove(alltasks.WRF__c);
               wrftemlist.add(alltasks);
               caseandalltask.put(alltasks.WRF__c,wrftemlist);
            }
            else
            {
               wrftemlist.add(alltasks);
               caseandalltask.put(alltasks.WRF__c,wrftemlist);
            }
        }
        //Call methods for pricinganalyst logic on insert,update.
        if (Trigger.IsInsert || Trigger.Isupdate)
        {
            updatepricinganalystonINSERTUPDATE(caseMap,caseandalltask);
        }
        /*if(Trigger.IsDelete)
        {
            updatepricinganalystonBEFOREDEL(caseMap);
        } */
        List<AggregateResult> resList = [Select WRF__c myReq, SUM(WRF_Task_Count__c) Total_Tasks_Count, SUM(WRF_Task_Complete_Count__c) Completed_Count,MAX(Pricing_Analyst__c) Analyst, MAX(Bid_Writer__c) BidWriter, MAX(Compliance_Legal__c) Compliance
                                     from WRF_Task__c where WRF__c IN :caseIds group by WRF__c];
            system.debug('The aggregate result'+resList);
            for(AggregateResult res: resList)
            {
              Id caseId = String.valueOf(res.get('myReq'));
              Case caseRec = caseMap.get(caseId);
              //List<Case> caseRec = caseMap.get(caseId);
              if(caseRec != null)
              {
                caseRec.Total_WRF_Tasks__c     = Integer.valueOf(res.get('Total_Tasks_Count'));
                caseRec.WRF_Tasks_Completed__c = Integer.valueOf(res.get('Completed_Count'));
                //caseRec.Pricing_Analyst__c     = String.valueOf(res.get('Analyst'));
                caseRec.Compliance_Mgr__c      = String.valueOf(res.get('Compliance'));
                caseRec.Bid_Writer__c          = String.valueOf(res.get('BidWriter'));
              }
            }
            if(executeoncetest.WRFCase && Trigger.IsAfter && (Trigger.IsInsert || Trigger.IsUpdate))
            {
                executeoncetest.WRFCase=false;
                update caseMap.values();
            }

    }
    public static void updatepricinganalystonINSERTUPDATE(Map<Id, Case> caseMap1,Map<id,List<WRF_Task__c>> caseandalltask1)
    {
        for(WRF_Task__c wrfbothTask:(List<WRF_Task__c>)Trigger.New)
        {

                 //******* And Calculating the Pricing Analyst on Update and Insert*******//
                    bidsforloop=false;
                    Remediationforloop=false;
                    publicgpoforloop=false;
                    MPSPricingforloop=false;
                    casepricinganalyst=null;
                    Case caseRec = caseMap1.get(wrfbothTask.WRF__c);
                    //if(caseRec.status!='Closed' && caseRec.status!='Cancelled')
                    if(caseRec!=null)
                    {
                        if((wrfbothTask.Disposition_Code__c=='Bids'))
                        {
                            system.debug('@@@@@@@@@@@@@@@@@bids');
                            caseRec.Pricing_Analyst__c     = wrfbothTask.Assigned_To__c;
                        }
                        else if(wrfbothTask.Disposition_Code__c=='Remediation')
                        {
                            List<WRF_Task__c> checkalltask= caseandalltask1.get(wrfbothTask.WRF__c);
                            if(checkalltask!= null)
                            {
                                for(WRF_Task__c checkalltask_alias:checkalltask)
                                {
                                    if(((checkalltask_alias.Disposition_Code__c=='Bids')) && checkalltask_alias.lastmodifieddate > latestmodified)
                                    {
                                        latestmodified= checkalltask_alias.lastmodifieddate;
                                        casepricinganalyst=checkalltask_alias.Assigned_To__c;
                                        bidsforloop=true;
                                        checkdiscode=true;
                                        //break;
                                    }
                                }
                            }
                            if(checkdiscode==false)
                            {
                                caseRec.Pricing_Analyst__c= wrfbothTask.Assigned_To__c;
                            }
                            else
                            {
                                caseRec.Pricing_Analyst__c= casepricinganalyst;
                            }
                        }
                        else if(wrfbothTask.Disposition_Code__c=='Public/GPO')
                        {
                            List<WRF_Task__c> checkalltask= caseandalltask1.get(wrfbothTask.WRF__c);
                            if(checkalltask!= null)
                            {
                               for(WRF_Task__c checkalltask_alias:checkalltask)
                                {
                                   if(((checkalltask_alias.Disposition_Code__c=='Bids')) && checkalltask_alias.lastmodifieddate > latestmodified)
                                    {
                                        latestmodified= checkalltask_alias.lastmodifieddate;
                                        casepricinganalyst=checkalltask_alias.Assigned_To__c;
                                        bidsforloop=true;
                                        checkdiscode=true;
                                        //break;
                                    }
                                }
                                if(bidsforloop==false)
                                {
                                    for(WRF_Task__c checkalltask_alias:checkalltask)
                                    {
                                        if(checkalltask_alias.Disposition_Code__c=='Remediation' && checkalltask_alias.lastmodifieddate > latestmodified)
                                        {
                                            latestmodified= checkalltask_alias.lastmodifieddate;
                                            casepricinganalyst=checkalltask_alias.Assigned_To__c;
                                            Remediationforloop=true;
                                            checkdiscode=true;
                                            //break;
                                        }
                                    }
                                }
                            }
                            if(checkdiscode==false)
                                {
                                    caseRec.Pricing_Analyst__c= wrfbothTask.Assigned_To__c;
                                }
                            else
                            {
                                caseRec.Pricing_Analyst__c= casepricinganalyst;
                            }
                        }
                        else if(wrfbothTask.Disposition_Code__c=='MPS Pricing')
                        {
                            List<WRF_Task__c> checkalltask= caseandalltask1.get(wrfbothTask.WRF__c);
                            if(checkalltask!= null)
                            {
                                for(WRF_Task__c checkalltask_alias:checkalltask)
                                {
                                    if(((checkalltask_alias.Disposition_Code__c=='Bids')) && checkalltask_alias.lastmodifieddate > latestmodified)
                                    {
                                        latestmodified= checkalltask_alias.lastmodifieddate;
                                        casepricinganalyst=checkalltask_alias.Assigned_To__c;
                                        bidsforloop=true;
                                        checkdiscode=true;
                                        //break;
                                    }
                                }
                                if(bidsforloop==false)
                                {
                                    for(WRF_Task__c checkalltask_alias:checkalltask)
                                    {
                                        if(checkalltask_alias.Disposition_Code__c=='Remediation' && checkalltask_alias.lastmodifieddate > latestmodified)
                                        {
                                            latestmodified= checkalltask_alias.lastmodifieddate;
                                            casepricinganalyst=checkalltask_alias.Assigned_To__c;
                                            Remediationforloop=true;
                                            checkdiscode=true;
                                            //break;
                                        }
                                    }
                                }
                                if(bidsforloop==false && Remediationforloop==false)
                                {
                                    for(WRF_Task__c checkalltask_alias:checkalltask)
                                    {
                                        if(checkalltask_alias.Disposition_Code__c=='Public/GPO' && checkalltask_alias.lastmodifieddate > latestmodified)
                                        {
                                            latestmodified= checkalltask_alias.lastmodifieddate;
                                            casepricinganalyst=checkalltask_alias.Assigned_To__c;
                                            publicgpoforloop=true;
                                            checkdiscode=true;
                                            //break;
                                        }
                                    }
                                }
                            }
                            if(checkdiscode==false)
                            {
                                caseRec.Pricing_Analyst__c= wrfbothTask.Assigned_To__c;
                            }
                            else
                            {
                                caseRec.Pricing_Analyst__c= casepricinganalyst;
                            }
                        }
                        else if(wrfbothTask.Disposition_Code__c!='Bids' && wrfbothTask.Disposition_Code__c!='Remediation' && wrfbothTask.Disposition_Code__c!='Public/GPO' && wrfbothTask.Disposition_Code__c!='MPS Pricing')
                        {
                            System.Debug('Inside other disposition');
                            List<WRF_Task__c> checkalltask= caseandalltask1.get(wrfbothTask.WRF__c);
                            //WRF_Task__c casepricinganalyst= new WRF_Task__c();

                            if(checkalltask!= null)
                            {
                                for(WRF_Task__c checkalltask_alias:checkalltask)
                                {
                                    if(((checkalltask_alias.Disposition_Code__c=='Bids')) && checkalltask_alias.lastmodifieddate > latestmodified)
                                    {
                                        system.debug('Inside Early bids');
                                        latestmodified= checkalltask_alias.lastmodifieddate;
                                        casepricinganalyst=checkalltask_alias.Assigned_To__c;
                                        bidsforloop=true;
                                    }
                                }
                                if(bidsforloop==false)
                                {
                                   for(WRF_Task__c checkalltask_alias:checkalltask)
                                    {
                                        if(checkalltask_alias.Disposition_Code__c=='Remediation' && checkalltask_alias.lastmodifieddate > latestmodified)
                                        {
                                            latestmodified= checkalltask_alias.lastmodifieddate;
                                            casepricinganalyst=checkalltask_alias.Assigned_To__c;
                                            Remediationforloop=true;
                                        }
                                    }
                                }
                                 if(bidsforloop==false && Remediationforloop==false)
                                {
                                   for(WRF_Task__c checkalltask_alias:checkalltask)
                                    {
                                        if(checkalltask_alias.Disposition_Code__c=='Public/GPO' && checkalltask_alias.lastmodifieddate > latestmodified)
                                        {
                                            latestmodified= checkalltask_alias.lastmodifieddate;
                                            casepricinganalyst=checkalltask_alias.Assigned_To__c;
                                            publicgpoforloop=true;
                                        }
                                    }
                                }
                                if(bidsforloop==false && Remediationforloop==false && publicgpoforloop==false)
                                {
                                   for(WRF_Task__c checkalltask_alias:checkalltask)
                                    {
                                        if(checkalltask_alias.Disposition_Code__c=='MPS Pricing' && checkalltask_alias.lastmodifieddate > latestmodified)
                                        {
                                            latestmodified= checkalltask_alias.lastmodifieddate;
                                            casepricinganalyst=checkalltask_alias.Assigned_To__c;
                                            MPSPricingforloop=true;
                                        }
                                    }
                                }
                                if(bidsforloop==false && Remediationforloop==false && publicgpoforloop==false && MPSPricingforloop==false)
                                {
                                    casepricinganalyst=null;
                                }
                            }
                            system.debug('casepricinganalyst'+casepricinganalyst);
                            caseRec.Pricing_Analyst__c=   casepricinganalyst;
                        }
                    }

             }
    }
    public static void updatepricinganalystonDELETE()
    {
        if(executeoncetest.deletesubtask && Trigger.IsBefore && Trigger.IsDelete)
        {
            for(WRF_Task__c wrfsubTaskold:(List<WRF_Task__c>)Trigger.Old)
             {
                if(wrfsubTaskold.recordtypeid==WRFTaskRecType.get('WRF Task').getRecordTypeId())
                {
                     subtaskid.add(wrfsubTaskold.id);
                }
             }
             for(WRF_Task__c wrfbothTaskold1:(List<WRF_Task__c>)Trigger.Old)
             {
                 alltask.add(wrfbothTaskold1.id);
                 if(wrfbothTaskold1.WRF__c!=null)
                 {
                     caseids1.add(wrfbothTaskold1.WRF__c);
                 }
             }
            //*****************Delete Subtasks when Parent Task is deleted*************//
            deletesubtask = [Select id from WRF_Task__c where Parent_WRF_Task__c in:subtaskid];
                for(WRF_Task__c removesubtask:deletesubtask)
                {
                    alltask.add(removesubtask.id);
                }
             system.debug('All task ids'+alltask);
             deleterecordhistory=[Select id from Record_History__c where WRF_Task__c in:alltask];
             for(WRF_Task__c alltasks:[Select id,Control_Task_Sequence__c,Task_Sequence__c,lastmodifieddate,Status__c,Assigned_To__c,WRF__c,Disposition_Code__c,Task_Type__c,recordtypeid from WRF_Task__c where WRF__c in:caseids1 and id not in:alltask])
                        {
                            List<WRF_Task__c> wrftemlist = new List<WRF_Task__c>();
                             if(caseandalltask.containskey(alltasks.WRF__c))
                             {
                               wrftemlist= caseandalltask.get(alltasks.WRF__c);
                               caseandalltask.remove(alltasks.WRF__c);
                               wrftemlist.add(alltasks);
                               caseandalltask.put(alltasks.WRF__c,wrftemlist);
                            }
                            else
                            {
                               wrftemlist.add(alltasks);
                               caseandalltask.put(alltasks.WRF__c,wrftemlist);
                            }
                        }
            for(WRF_Task__c wrfbothTaskold:(List<WRF_Task__c>)Trigger.Old)
             {
                 if(Trigger.IsDelete && Trigger.IsBefore)
                 {
                        bidsforloop=false;
                        Remediationforloop=false;
                        publicgpoforloop=false;
                        MPSPricingforloop=false;
                        casepricinganalyst=null;

                     //**************Resetting the Pricing Analyst on Case when sub task is deleted******************//
                     if(wrfbothTaskold.Disposition_Code__c=='Bids' || wrfbothTaskold.Disposition_Code__c=='Remediation' || wrfbothTaskold.Disposition_Code__c=='Public/GPO' || wrfbothTaskold.Disposition_Code__c=='MPS Pricing')
                    {
                        System.Debug('Inside other dispositiondel'+wrfbothTaskold.WRF__c);
                        List<WRF_Task__c> checkalltask= caseandalltask.get(wrfbothTaskold.WRF__c);

                        if(checkalltask!= null)
                        {
                            system.debug('checkalltask'+checkalltask);
                            for(WRF_Task__c checkalltask_alias:checkalltask)
                            {
                                 if(((checkalltask_alias.Disposition_Code__c=='Bids')) && checkalltask_alias.lastmodifieddate > latestmodified)
                                {
                                    system.debug('Inside Early bids');
                                    latestmodified= checkalltask_alias.lastmodifieddate;
                                    executeoncetest.casepricinganalyst1=checkalltask_alias.Assigned_To__c;
                                    bidsforloop=true;
                                }
                            }
                            if(bidsforloop==false)
                            {
                               for(WRF_Task__c checkalltask_alias:checkalltask)
                                {
                                    if(checkalltask_alias.Disposition_Code__c=='Remediation' && checkalltask_alias.lastmodifieddate > latestmodified)
                                    {
                                        latestmodified= checkalltask_alias.lastmodifieddate;
                                        executeoncetest.casepricinganalyst1=checkalltask_alias.Assigned_To__c;
                                        Remediationforloop=true;
                                    }
                                }
                            }
                             if(bidsforloop==false && Remediationforloop==false)
                            {
                               for(WRF_Task__c checkalltask_alias:checkalltask)
                                {
                                    if(checkalltask_alias.Disposition_Code__c=='Public/GPO' && checkalltask_alias.lastmodifieddate > latestmodified)
                                    {
                                        latestmodified= checkalltask_alias.lastmodifieddate;
                                        executeoncetest.casepricinganalyst1=checkalltask_alias.Assigned_To__c;
                                        publicgpoforloop=true;
                                    }
                                }
                            }
                            if(bidsforloop==false && Remediationforloop==false && publicgpoforloop==false)
                            {
                               for(WRF_Task__c checkalltask_alias:checkalltask)
                                {
                                    if(checkalltask_alias.Disposition_Code__c=='MPS Pricing' && checkalltask_alias.lastmodifieddate > latestmodified)
                                    {
                                        latestmodified= checkalltask_alias.lastmodifieddate;
                                        executeoncetest.casepricinganalyst1=checkalltask_alias.Assigned_To__c;
                                        MPSPricingforloop=true;
                                    }
                                }
                            }
                            if(bidsforloop==false && Remediationforloop==false && publicgpoforloop==false && MPSPricingforloop==false)
                            {
                                system.debug('Inside Early nothing');
                                executeoncetest.casepricinganalyst1=null;
                            }
                        }
                        system.debug('casepricinganalyst'+executeoncetest.casepricinganalyst1);
                        //caseRec.Pricing_Analyst__c=   executeoncetest.casepricinganalyst1;
                    }
                 }
             }
             executeoncetest.deletesubtask=false;
             if(deletesubtask.size()>0)
            {
                system.debug('delete list');
                //executeoncetest.deletesubtask=false;
                delete deletesubtask;
            }
            if(deleterecordhistory.size()>0)
            {
                delete deleterecordhistory;
            }
        }
    }
    public static void updateWRFStageOpportunity()
    {
        if(executeoncetest.wrftaskupdate && (Trigger.isBefore||Trigger.isafter) && Trigger.isupdate)
           {

            set<Id> parentTaskIds = new set<Id>();
            Map<Id,List<WRF_Task__c>> MapParentChilds = new Map<Id,List<WRF_Task__c>>();
            Map<Id,WRF_Task__c> MapParentTask = new Map<Id,WRF_Task__c>();
            for(WRF_Task__c wtsk:(List<WRF_Task__c>)Trigger.New)
              {

                if(wtsk.Parent_WRF_Task__c!=null)
                {
                    //Creating a list of parent task ids
                    parentTaskIds.add(wtsk.Parent_WRF_Task__c);
                }
                else if(!MapParentTask.containsKey(wtsk.Id) &&Trigger.isBefore )
                {
                    //Creating a map of parent task ids and set of parent tasks
                    MapParentTask.put(wtsk.Id,wtsk);
                    parentTaskIds.add(wtsk.Id);
                }
              }

            //List<WRF_Task__c> lstAllTask = new List<WRF_Task__c>();
            //Query all the tasks
            List<WRF_Task__c> lstAllTask = [Select status__c,Parent_WRF_Task__r.WRF__r.WRF_Opportunity__r.StageName,Parent_WRF_Task__c,Task_Type__c,WRF_Stage__c,recordtype.name from Wrf_Task__C where (Parent_WRF_Task__c in :parentTaskIds or id in :parentTaskIds)];
            Map<Id,WRF_Task__c> MapParentUpdate = new Map<Id,WRF_Task__c>();
            Map<Id,WRF_Task__c> MapNoParentUpdate = new Map<Id,WRF_Task__c>();

            for(WRF_Task__c tsk: lstAllTask)
            {
                if((tsk.Parent_WRF_Task__c==null)&&(!MapParentTask.containsKey(tsk.id)))
                {
                    //Populating the map for parent tasks
                    MapParentTask.put(tsk.id,tsk);
                }
                if(tsk.Parent_WRF_Task__c!=null)
                {
                    //Populating the map for parent and list of childs
                    if(MapParentChilds.containsKey(tsk.Parent_WRF_Task__c))
                    {
                        List<WRF_Task__c> tasks = MapParentChilds.get(tsk.Parent_WRF_Task__c);
                        MapParentChilds.remove(tsk.Parent_WRF_Task__c);
                        tasks.add(tsk);
                        MapParentChilds.put(tsk.Parent_WRF_Task__c,tasks);
                    }
                    else
                    {

                    System.debug('&&&&&&&&&&&&&&&&&&&&&&&&&&&&there');
                        List<WRF_Task__c> tasks = new List<WRF_Task__c>();
                        tasks.add(tsk);
                        MapParentChilds.put(tsk.Parent_WRF_Task__c,tasks);
                    }
                }
            }
            if(Trigger.isBefore)
            {
                for(WRF_Task__C wtsk: MapParentTask.values())
                {


                System.debug('&&&&&&&&&&&&&MapParentChilds'+MapParentChilds);
                    //If the parentchild map of tasks doen't contain the WRF Task ids, then default the parent task status field to Not started.
                    if(!MapParentChilds.containsKey(wtsk.id))
                    {
                        //wtsk.status__c='Not Started';

                                        System.debug('&&&&&&&&&&&&&inside looping');

                        if((wtsk.Disposition_Code__c =='Bids')|| (wtsk.Disposition_Code__c =='Tech Depot') ||  (wtsk.Disposition_Code__c =='Transition')||  (wtsk.Disposition_Code__c =='MPS Implementation')||(wtsk.Disposition_Code__c =='Public/GPO' )  ||   (wtsk.Disposition_Code__c =='Remediation')  ||  (wtsk.Disposition_Code__c =='OD N Bid')  ||  (wtsk.Disposition_Code__c =='OD N Remediation'))
                        {
                            wtsk.WRF_Stage__c='Not Started';
                        }//MapParentUpdate.put(wtsk.id,wtsk);

                    }
                }
            }
            if(Trigger.isafter)
            {
                //Update the WRF stage field of parent task based on Opportunity stage and all sub task status.
                for(WRF_Task__c tsk: lstAllTask)
                {
                    if((!MapNoParentUpdate.containsKey(tsk.Parent_WRF_Task__c))&&(tsk.Parent_WRF_Task__r.WRF__r.WRF_Opportunity__r.StageName=='100%-Won')&&(tsk.recordtype.name=='WRF Sub Task') && (tsk.status__c=='Completed') &&(tsk.Task_Type__c=='Pricing Implementation'))
                    {
                        Wrf_Task__C ts = MapParentTask.get(tsk.Parent_WRF_Task__c);
                        ts.WRF_Stage__c='Won';
                        MapParentUpdate.put(ts.id,ts);
                    }
                    else if((!MapNoParentUpdate.containsKey(tsk.id))&&(tsk.recordtype.name=='WRF Sub Task') && (tsk.status__c!='Completed') &&(tsk.Task_Type__c=='Pricing Implementation'))
                    {
                        MapNoParentUpdate.put(tsk.Parent_WRF_Task__c,MapParentTask.get(tsk.Parent_WRF_Task__c));
                        if(MapParentUpdate.containsKey(tsk.Parent_WRF_Task__c))
                            MapParentUpdate.remove(tsk.Parent_WRF_Task__c);
                    }
                }
                executeoncetest.wrftaskupdate=false;
                if(MapParentUpdate.values().size()>0)
                {
                    update MapParentUpdate.values();
                }
            }

           }
    }

}