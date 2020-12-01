/**************************************************************
*Name : LeadManagement
*Created By : Virendra(Appirio Off)
*Created Date : 9th Nov,2011
*Purpose : Consolidate Lead_RoutingTo_ProperOwner into a single class for better maintainence
Assumes trigger context is avaliable, will *NOT* work, when invoked outside of trigger

Modified By: Sunil Bansal
Modified Date: 18-Oct-2012
Modifed reason: Case # 9011, to route the new lead to store owner for CPD products

Modified By: Wipro Offshore
Modified Date: 7-Nov-2012
Modifed reason: Case # 9465, If a batch of records get uploaded and few records got failed in the batch,
then the remaining records will be uploaded.

11.16.15   NSHARP      MODIFIED    S-364612
7 July 2016 JSCHILLING  MODIFIED   C-173252     Added logic to assign additional leads to specific queue

********************************************************************/

public with sharing class LeadManagement
{
    private static Boolean isBeforeExecuted = false;
    private static Integer BATCH_COUNT = 0;
    private static string DEFAULT_USER = 'salesforce';
    private static List<User> lstDefaultUser = new List<User>();
    private static String spId = null;
    //START S-343742 [Hemant 8/28/2015]
    //START NSHARP S-364612 11.16.15
    //private static String QUEUE_GOVT_LEADS = 'Government Leads';
    //private static String QUEUE_CENTRAL_ZONE = 'Central Time Zone';
    //private static String QUEUE_EASTERN_ZONE = 'Eastern Time Zone';
    //private static String QUEUE_MOUNTAIN_ZONE = 'Mountain Time Zone';
    //private static String QUEUE_PACIFIC_ZONE = 'Pacific Time Zone';
    //END NSHARP S-364612 11.16.15
    private static String EMAIL_DOMAIN_GOV = '.gov';
    private static String EMAIL_DOMAIN_MIL = '.mil';
    //END S-343742

    public static void BeforeLeadCreate()
    {
        /////////// Logic Begins : Handled the upload of batch for partial success (if few records get failed from batch).
        Integer newCount = Trigger.New.size();
        System.debug('TRIGGER BATCH SIZE === '+newCount);
        if(isBeforeExecuted && BATCH_COUNT != newCount)
            isBeforeExecuted  = false;
        BATCH_COUNT = newCount ;
        ///////// Logic Ends

        //If the code has already been executed once, don't run it again
        if(isBeforeExecuted) return;
        List<Id> leadStoreIds = new List<Id>();
        Set<String> leadsZipCode = new Set<String>();
        List<Lead> updateLeadsOwner = new List<Lead>();
        List<Lead> updateAutoassignLeads = new List<Lead>();
        List<Lead> ownerChangedUpdateSalesRep = new List<Lead>();
        Set<Id> ownerIds = new Set<Id>();
        List<QueueSobject> assigntoQueue= new List<QueueSobject>();
        // Added by Rahul for S-346404 - extract Lead queue record bases
        Map<String,Id> timeZoneQueueMap =  new Map<String,Id>();
        assigntoQueue= [Select Id, SobjectType, QueueId, Queue.Name, Queue.email from QueueSobject where SobjectType = 'Lead' and Queue.Name='Lead Triage']; //S-343742 [Hemant 8/28/2015] - Commented as not used
        
        //START NSHARP S-364612 11.16.15 
        Map<String, Queue_Zones__c> queueMap = Queue_Zones__c.getAll();
        List<String> queueZones = new List<String>();
        queueZones.addAll(queueMap.keySet());

        //for(QueueSobject timeZoneQueue : [select Id,SobjectType, QueueId, Queue.Name, Queue.email from QueueSobject where SobjectType = 'Lead' and
        //                                        (Queue.Name=:QUEUE_CENTRAL_ZONE or
        //                                        Queue.Name=:QUEUE_EASTERN_ZONE or
        //                                        Queue.Name=:QUEUE_MOUNTAIN_ZONE or
        //                                        Queue.Name=:QUEUE_PACIFIC_ZONE OR
        //                                        Queue.Name =: QUEUE_GOVT_LEADS)]){
        for(QueueSobject timeZoneQueue : [select Id,SobjectType, QueueId, Queue.Name, Queue.email from QueueSobject where SobjectType = 'Lead' and Queue.Name IN: queueZones]){
        //END NSHARP S-364612 11.16.15

         timeZoneQueueMap.put(timeZoneQueue.Queue.Name, timeZoneQueue.QueueId);
         System.debug('-- map rahul;'+timeZoneQueueMap);
        }
        // End S-346404
        for(Lead newLead :(List<Lead>)Trigger.New)
        {
            /*
            If lead.store__c is not null AND Lead.product__c = CPD AND lead.auto_assign__c is TRUE then update lead.owner to
            store__c.CPD_Sales_Rep__c (user) WHERE lead.store__c = store__c.id
            */
            Id oldOwnerId = null;
            if(newLead.storewebid__c!= null)
            {
                //auto map storeid from storewebid (lead in weblead)
                for(Store__c storeid :[select id from store__c where ID_Number__c=:newLead.storewebid__c])
                {
                    newLead.Store__c= storeid.id;
                    newLead.storewebid__c= null;
                }

            }
            if(newLead.Cust_ID__c!= null)
            {
                //  auto map account__C from cust_id (lead in weblead)
                for(Account acc :[select id from account where AOPS_Cust_Id__c =:newLead.Cust_ID__c])
                {
                    newLead.Account__c = acc .id;
                    newLead.Cust_ID__c= null;
                }

            }


            if(newLead.User__C != null)
            {
                System.debug('AA GAYA 0');
                //   decimal d=1/0;
                newLead.OwnerId = newLead.User__C;
                ownerIds.add(newLead.User__C);
                oldOwnerId = newLead.User__C;
                ownerChangedUpdateSalesRep.add(newLead);
                newLead.User__C = null;
            }

            if(Trigger.oldmap != null)
            {
                Lead tlead = (Lead)Trigger.oldmap.get(newLead.Id);
                oldOwnerId = tlead.OwnerId;
                System.debug('KKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKK'+oldOwnerId );
                System.debug('HHHAAAAAAAAHHHHHHHHHHHHHHHHH'+tlead.Owner.Name);
                //System.debug('OOOOOOOOOOOOOOOOOOOOOOOOOO'+newLead.LastModifiedById);
                //Salesforce ID
                if(oldOwnerId   == '005E0000000lNbVIAU' && newLead.OwnerId!=oldOwnerId){
                list<user> triage_user = [SELECT ID FROM USER WHERE id = :Userinfo.getUserId() and profile.name = 'Lead Triage'];
                if(triage_user.size() > 0) // 'Salesforce' user
                {
                     newLead.contractor__c = Userinfo.getUserId();//newLead.LastModifiedById;
                }
                }


            }
            system.debug('newLead.Auto_Assign__c-->'+newLead.Auto_Assign__c+' newLead.product__c-->'+newLead.product__c+' is insert-->'+Trigger.IsInsert);
            System.debug('newLead.LeadSource@@@@@@@@@@@@@@@@@@@'+newLead.LeadSource);

          /*  if (Trigger.IsInsert  && newLead.LeadSource=='BSD NET' && newLead.Lead_Page_Source__c=='atd_promo')
            {
                newLead.OwnerId = '005E0000000nASD';
            } */


           if(Trigger.IsInsert && newLead.Potential_Duplicate__c && (newLead.LeadSource=='Web Lead' || newLead.LeadSource=='Store Lead' || newLead.LeadSource=='BSD NET' || newLead.LeadSource=='Customer Service')) // Added as per Case # 00227686
            {
                system.debug('1st if');
                assignDefaultOwner(newLead);
            }
            //Added newLead.Recordtypeid != system.label.Lead_Business_Pro for Case 761003 
            //Modified below line JSCHILLING C-173252 7/7/2016 Added 'Web Lead' and 'BSD Auto Account Creation' below so these leads will also get assigned to the queue
            if(Trigger.IsInsert && (newLead.LeadSource=='Store Lead' || newLead.LeadSource=='BSD NET' || newLead.LeadSource=='Customer Service' || newLead.LeadSource=='Web Lead' || newLead.LeadSource=='BSD Auto Account Creation') && !newLead.Potential_Duplicate__c  && newLead.Recordtypeid != system.label.Lead_Business_Pro) // As per case 00227686
            {
                system.debug('2nd if');
                newLead.OwnerId = assigntoQueue[0].QueueId;
                newLead.Sales_Person_ID__c = null;
                newLead.Auto_assign__c = false;
            }




            else if(oldOwnerId != null && oldOwnerId != newLead.OwnerId)
            {
                system.debug('3rd if');
                ownerChangedUpdateSalesRep.add(newLead);
                ownerIds.add(newLead.OwnerId);
            }
            // for CPD Lead
            /*
            else if(Trigger.isInsert && newLead.Auto_Assign__c && newLead.Store__c !=null && (newLead.product__c == 'CPD-Promo' ||newLead.product__c == 'CPD-Print'))
            {
                System.debug('AA GAYA 1');
                leadStoreIds.add(newLead.Store__c);
                updateLeadsOwner.add(newLead);
            }
            */
            else if(newLead.Auto_Assign__c && ((newLead.product__c != 'CPD-Promo' && newLead.product__c != 'CPD-Print' && Trigger.isInsert)||!Trigger.isInsert ))
            {
              if(newLead.WCW_Count__c < 150){
                if(newLead.Time_Zone__c == 'Pacific')
                  //START NSHARP S-364612 11.16.15
                  //newLead.OwnerId = timeZoneQueueMap.get(QUEUE_PACIFIC_ZONE);
                  newLead.OwnerId = timeZoneQueueMap.get('Pacific Time Zone');
                if(newLead.Time_Zone__c == 'Mountain')
                  //newLead.OwnerId = timeZoneQueueMap.get('QUEUE_MOUNTAIN_ZONE');
                  newLead.OwnerId = timeZoneQueueMap.get('Mountain Time Zone');
                if(newLead.Time_Zone__c == 'Eastern')
                  //newLead.OwnerId = timeZoneQueueMap.get(QUEUE_EASTERN_ZONE);
                  newLead.OwnerId = timeZoneQueueMap.get('Eastern Time Zone');
                if(newLead.Time_Zone__c == 'Central')
                  //newLead.OwnerId = timeZoneQueueMap.get(QUEUE_CENTRAL_ZONE);
                  newLead.OwnerId = timeZoneQueueMap.get('Central Time Zone');
                  //END NSHARP S-364612 11.16.15
              }
              else {
                //Added newLead.Recordtypeid != system.label.Lead_Business_Pro for Case 761003 
                    if(newLead.Recordtypeid != system.label.Lead_Business_Pro)
                    {
                System.debug('AA GAYA 1 NOT');
                if(newLead.zip__c != null)
                {
                    String zipCode = newLead.zip__c;
                    if(zipCode.length()>5) {
                        leadsZipCode.add(zipCode.substring(0,5));
                        //changes to handle 9 digit zip codes -- modified by ivarada
                        newLead.zip__c = zipCode;
                    }
                    else
                        leadsZipCode.add(zipCode);
                    System.debug('Set of zip code=='+leadsZipCode);
                }
                updateAutoassignLeads.add(newLead);
                //System.debug('List of Auto assign leads=='+updateAutoassignLeads);
            }
            }
          }
            else if(Trigger.isInsert)
            {
                system.debug('last if');
                system.debug('newLead rec>>>>>>>>>>'+newLead);
                ownerChangedUpdateSalesRep.add(newLead);
                if(newLead.OwnerId!= null)
                ownerIds.add(newLead.OwnerId);
                else
                ownerIds.add(UserInfo.getUserId());
                system.debug('<<<<ownerIds>>>>>'+ownerIds);
            }




        }

        //4 - SET THE LEAD.SALES_PERSON_ID__C
        // Set the lead.sales_person_id__c field to the Sales_Person__c.ExtIDSalesperson__c value based on where
        //Sales_Person__c.isactive__c = true and Sales_Person__c.primary__c and Sales_Person__c.user__c = lead.owner.
        // If no valid sales_person__c record exists then give user error message that advises "Owner being assigned does not have valid Sales Rep ID"
        if(!ownerIds.isEmpty())
        {
            //START S-350562 [Hemant 9/15/2015] - Assign to Mgr if active Sales_Person__c record not found
                    //Store mappings of User to its Mgr ID
                    Map<Id, Id> userMgrIdMap = new Map<Id, Id>();
                    for(User usr : [Select Id, ManagerId from User Where Id IN: ownerIds
                                    AND ManagerId != null]){
                      userMgrIdMap.put(usr.Id, usr.ManagerId);
                    }
                    ownerIds.addAll(userMgrIdMap.values());
                    //END S-350562

            Map<Id,Sales_Person__c> ownerSalesPerson = new Map<Id,Sales_Person__c>();
            list<Sales_Person__c> listspids = [SELECT Id,User__c,ExtIDSalesPerson__c FROM Sales_Person__c 
                                               WHERE Primary__c = true AND IsActive__c = true
                                             AND User__c IN :ownerIds];
            for(Sales_Person__c salesPerson :listspids)
            {
                ownerSalesPerson.put(salesPerson.User__c, salesPerson);
                System.debug('-----------added---------'+ ownerIds);
            }

            for(Lead updOwnLead:ownerChangedUpdateSalesRep)
            {
                System.debug('-----------added1---------');
                if(ownerSalesPerson.containsKey(updOwnLead.OwnerId))
                {
                    System.debug('-----------added2---------');
                    updOwnLead.Sales_Person_ID__c = ownerSalesPerson.get(updOwnLead.OwnerId).Id;

                 updOwnLead.Auto_Assign__c = false;

                }
                //START S-350562 [Hemant 9/15/2015] - Assign to Mgr if active Sales_Person__c record not found
                else if(ownerSalesPerson.containsKey(userMgrIdMap.get(updOwnLead.OwnerId))){
                    updOwnLead.Sales_Person_ID__c = ownerSalesPerson.get(userMgrIdMap.get(updOwnLead.OwnerId)).Id; //set SP for mgr if salesperson is null
                    updOwnLead.Auto_Assign__c = false;
                }//END S-350562
                else
                {
                    if(ownerSalesPerson != null && ownerSalesPerson.containsKey(UserInfo.getUserId()) ){
                    updOwnLead.Sales_Person_ID__c = ownerSalesPerson.get(UserInfo.getUserId()).Id;
                    }
                    //updOwnLead.addError('Owner being assigned does not have valid Sales Rep ID');
                }
            }
        }

        /*

        //Commented to remove the logic for assignment rules related to stores//.


        // CASE # 9011, Below block is for CPD Lead Owner assignment
        if(Trigger.isInsert) // this condition put on 06-Dec-2012, CPD Auto assignment whousld work during Lead Creation only, not for update
        {
            Map<Id, Assignment_Rule__c> storeTrackerList = new Map<Id,Assignment_Rule__c>([SELECT Effective_Start_Date__c, Effective_End_Date__c, Store__c, User__c FROM Assignment_Rule__c WHERE Store__c IN :leadStoreIds and Effective_Start_Date__c <= :System.Today() and ( Effective_End_Date__c = NULL OR Effective_End_Date__c >= :System.Today() ) ]);
            Map<Id, Assignment_Rule__c> storeRepList = new Map<Id, Assignment_Rule__c>(); // store Id and Assignment Rule object map
            Map<Id, List<Lead>> updateLeadOwnerIdRepId = new Map<Id, List<Lead>>(); // Map of User (Rep) Id as Key value as List of Leads to be assigned to this one Rep.

            for(Assignment_Rule__c srTrackker: storeTrackerList.values())
            {
                storeRepList.put(srTrackker.Store__c, srTrackker);
            }

            if(updateLeadsOwner.size() > 0)
            {
                for(Lead updateLead:updateLeadsOwner)
                {
                    Id storeRepId;
                    Assignment_Rule__c currentStore = storeRepList.get(updateLead.Store__c);
                    if(currentStore != NULL)
                    {
                        if(currentStore.User__c != NULL)
                        {
                            storeRepId = currentStore.User__c; // Store Rep to be assigned as Lead Owner
                            //updateLead.OwnerId = storeRepList.get(updateLead.Store__c).User__c;
                            //updateLead.Auto_Assign__c = false; // so that same process not executed again
                        }
                    }

                    // if Assignment Rule (store) record not found, set it to default Rep from custom settings.
                    if(storeRepId == null)
                    {
                        // set default Rep  from Custom setting ('salesforce' user)
                        Map<String, Keyvalue_Map_CS__c> keyValueMap = Keyvalue_Map_CS__c.getAll();
                        storeRepId = keyValueMap.get('DefaultLeadOwner').Data_Value__c;
                    }

                    List<Lead> repLeadList = new List<Lead>();
                    if(updateLeadOwnerIdRepId.containsKey(storeRepId))
                    {
                        repLeadList = updateLeadOwnerIdRepId.get(storeRepId);
                    }
                    // add Leads to be assigned to this one Rep 'storeRepId'
                    repLeadList.add(updateLead);
                    updateLeadOwnerIdRepId.put(storeRepId, repLeadList);
                }

                // finally update Lead Owner and Sales Rep Id on the Lead
                if(!updateLeadOwnerIdRepId.isEmpty())
                {
                    System.debug('updateLeadOwnerIdRepId.keyset() KEY SET == '+updateLeadOwnerIdRepId.keyset());
                    for(Sales_Person__c salesPerson :[SELECT Id, User__c, ExtIDSalesPerson__c FROM Sales_Person__c WHERE Primary__c = true AND IsActive__c = true
                                                     AND User__c IN :updateLeadOwnerIdRepId.keyset()])
                    {
                        System.debug('salesPerson USER == '+salesPerson.User__c);
                        for(Lead ld: updateLeadOwnerIdRepId.get(salesPerson.User__c))
                        {
                            //System.debug('AA GAYA ASSIGNMENT ME ');
                            ld.OwnerId = salesPerson.User__c;
                            ld.Sales_Person_ID__c = salesPerson.Id;
                            ld.Auto_Assign__c = false;
                        }
                    }
                }
            }
        }
        */
        // END OF CASE # 9011, UPDATE CODE FOR LEAD OWNER

        /*
        // Use Case 1
        //==========================================================================================================================
        // 1.Store Leads > route to cooresponding store cpd rep
        //on create only: if lead.store__c is not null AND lead.auto_assign__c is false then update lead.owner to store__c.CPD_Sales_Rep__c (user) WHERE lead.store__c = store__c.id
        // Map<Id,Store__c> leadStores = new Map<Id,Store__c>([Select ID__c, CPD_Sales_Rep__c From Store__c where CPD_Sales_Rep__c <> null and id in:leadStoreIds]);
        Map<Id,Store__c> leadStores = new Map<Id,Store__c>([Select ID__c, CPD_Sales_Rep__c From Store__c where id in:leadStoreIds]);
        Map<Id,Lead> updateSalesPersonOfStore = new Map<Id,Lead>();
        if(!leadStores.isEmpty())
        {
            for(Lead updateLead:updateLeadsOwner)
            {
                Store__c leadStore = leadStores.get(updateLead.Store__c);
                if(leadStore.CPD_Sales_Rep__c != null)
                {
                    updateSalesPersonOfStore.put(leadStore.CPD_Sales_Rep__c, updateLead);
                }
                else
                {
                    if(updateLead.zip__c != null)
                    {
                        String zipCode = updateLead.zip__c;
                        if(zipCode.length()>5)
                            leadsZipCode.add(zipCode.substring(0,5));
                        else
                            leadsZipCode.add(zipCode);
                    }
                    updateAutoassignLeads.add(updateLead);
                }
            }
        }

        // Update Leads SalesPerson Id if Owner Setted using Lead Store
        if(!updateSalesPersonOfStore.isEmpty())
        {
            for(Sales_Person__c salesPerson :[SELECT Id,User__c,ExtIDSalesPerson__c FROM Sales_Person__c WHERE Primary__c = true AND IsActive__c = true
                                                AND User__c IN :updateSalesPersonOfStore.keyset()])
            {
                updateSalesPersonOfStore.get(salesPerson.User__c).OwnerId = salesPerson.User__c;
                updateSalesPersonOfStore.get(salesPerson.User__c).Sales_Person_ID__c = salesPerson.Id;
                updateSalesPersonOfStore.get(salesPerson.User__c).Auto_Assign__c = false;
            }
        }
        */
        // Use Case 2
        //==========================================================================================================================
        // on create if lead.auto_assign__c is true then
        // Auto-Assign > route according to assignment rules table


        // non-CPD Lead Owner assignment based on Zip Code and/or Industry and/or WCW Count
        if(!leadsZipCode.isEmpty())
        {
            //System.debug('AA GAYA ZIP CODE ==== ');
            // this map to store zip/Industry/WCW count key
            Map<String,Assignment_Rule__c> mpTerritoryKey = new Map<String,Assignment_Rule__c>();
            // below method call will populate above map with Keys generated and Assignment Rule against Key
            QueryAssignmentRule(mpTerritoryKey,leadsZipCode);
            //Map<Id,List<Account>> mpRelatedAccount = PopulateRelatedAccount(lstAccount);
            // below map will store 'sales Person Id' and Sales Person record, by iterating over Assignment Rules
            Map<id,Sales_Person__c> mpSalesRep = LoadSalesPersonById(mpTerritoryKey.values());
            // below map will store employee Id and user record in map, by iterating over Assignment Rules
            //Map<String,User> mpOwnerUser = LoadOwnerUserId(mpTerritoryKey.values());

            // iterate over non-CPD leads to make Owner assignment
            for(Lead uLead : updateAutoassignLeads)
            {
                System.debug('AA GAYA ZIP CODE 2 ==== ');
                if(uLead.zip__c != null)
                {
                    System.debug('Territory key=== ');
                    System.debug('Territory key 1 === '+ mpTerritoryKey);
                    // first try with Key combination of all three 1. Zip, 2. WCW Count, 3. Industry
                    if(mpTerritoryKey.containsKey(generateZipWCWIndustryKey(uLead)))
                    {
                        System.debug('generateZipWCWIndustryKey 1=== ');
                        assignOwner(uLead,mpTerritoryKey.get(generateZipWCWIndustryKey(uLead)),mpSalesRep);
                        continue;
                    }
                    // then try with Key combination of two 1. Zip, 2. WCW Count
                    if(mpTerritoryKey.containsKey(generateZipWCWKey(uLead)))
                    {
                        System.debug('generateZipWCWKey 2=== ');
                        System.debug('Territory key 2 === '+ mpTerritoryKey.get(generateZipWCWKey(uLead)));
                        System.debug('salesrep key 2 === '+ mpSalesRep);
                        //System.debug('salesrep key 2 === '+ mpOwnerUser);

                        assignOwner(uLead,mpTerritoryKey.get(generateZipWCWKey(uLead)),mpSalesRep);


                        continue;
                    }
                    // then try with Key combination of two 1. Zip, 2. Industry
                    if(mpTerritoryKey.containsKey(generateZipIndustryKey(uLead)))
                    {
                        System.debug('generateZipIndustryKey 3=== ');
                        assignOwner(uLead,mpTerritoryKey.get(generateZipIndustryKey(uLead)),mpSalesRep);
                        continue;
                    }
                    // then last try with Key of Zip only
                    if(mpTerritoryKey.containsKey(uLead.zip__c))
                    {
                        System.debug('generateZipIndustryKey 4=== ');
                        assignOwner(uLead,mpTerritoryKey.get(uLead.zip__c),mpSalesRep);
                        continue;
                    }
                }
                // if it reaches  here, mean 'continue' statement above do nto take to begining of loop then asisgn default Owner 'salesforce'
                //Assign Default User as Lead Owner
                System.debug('BEFORE assignDefaultOwner ME ');
                assignDefaultOwner(uLead);
            }
        }
        // Added by Rahul S-346404 - Assigned Lead according to time zone
        for(Lead newLead : (List<Lead>)Trigger.New){
            if(Trigger.isInsert  && (newLead.LeadSource=='Web Lead' || newLead.LeadSource=='BSD NET' || newLead.LeadSource=='Customer Service' ||  newLead.LeadSource== 'Store Lead'))
            {
              system.debug('inside timezone if');
            /*  if(newLead.WCW_Count__c < 150){
                if(newLead.Time_Zone__c == 'Pacific')
                    newLead.OwnerId = timeZoneQueueMap.get(QUEUE_PACIFIC_ZONE);
                if(newLead.Time_Zone__c == 'Mountain')
                    newLead.OwnerId = timeZoneQueueMap.get(QUEUE_MOUNTAIN_ZONE);
                if(newLead.Time_Zone__c == 'Eastern')
                    newLead.OwnerId = timeZoneQueueMap.get(QUEUE_EASTERN_ZONE);
                if(newLead.Time_Zone__c == 'Central')
                    newLead.OwnerId = timeZoneQueueMap.get(QUEUE_CENTRAL_ZONE);
              } */
              //START S-343742 [Hemant 8/28/2015] - Assign lead to Govt Queue
              //START NSHARP S-364612 11.16.15
              //if(newLead.Email != null  && (newLead.Email.endsWithIgnoreCase(EMAIL_DOMAIN_GOV) || newLead.Email.endsWithIgnoreCase(EMAIL_DOMAIN_MIL)) && timeZoneQueueMap.containsKey(QUEUE_GOVT_LEADS)){
              //Removed Grand and Toy web leads from Goverment Email searches  Story: 00627181
              if(newLead.Email != null  && (newLead.Email.endsWithIgnoreCase(EMAIL_DOMAIN_GOV) || newLead.Email.endsWithIgnoreCase(EMAIL_DOMAIN_MIL)) && newLead.LeadSource != 'Grand and Toy Web Lead' && timeZoneQueueMap.containsKey('Government Leads')){
                //newLead.OwnerId = timeZoneQueueMap.get(QUEUE_GOVT_LEADS);
                newLead.OwnerId = timeZoneQueueMap.get('Government Leads');
                //END NSHARP S-364612 11.16.15
              }
              //END S-343742
            }
            // End Rahul story - S-346404

        }



        //Mark the static variable as true, so that trigger is not executed again for any workflow updates
        isBeforeExecuted = true;

    }


    //Assign Owner to Default user
    private static void assignDefaultOwner(Lead uLead)
    {
        // I beleive below one query can be reduced by hard coding SFDC User Id of 'salesforce' user, as at line no. 93
        lstDefaultUser = [select Id from User where lastname = :DEFAULT_USER AND IsActive = true Limit 1];
        for(Sales_Person__c salesPerson :[SELECT Id,User__c,ExtIDSalesPerson__c FROM Sales_Person__c WHERE Primary__c = true AND IsActive__c = true
                                        AND User__c =:lstDefaultUser[0].Id])
        {
            spId = salesPerson.Id;
            break;
        }
        system.debug('lstDefaultUser -->'+lstDefaultUser+' Size()-->'+lstDefaultUser.size());
        if(lstDefaultUser.size() > 0)
        {
            System.debug('AA GAYA assignDefaultOwner ME ==== ');
            uLead.OwnerId = lstDefaultUser[0].Id ;
            if(spId != null)
                uLead.Sales_Person_ID__c = spId;
            else
                uLead.Sales_Person_ID__c = null;
            uLead.Auto_Assign__c = false;
        }
    }

    //======================================================================================================//
    //Load Sales Reps based on external Sales Rep Id
    //======================================================================================================//
    private static Map<Id,Sales_Person__c> LoadSalesPersonById(List<Assignment_Rule__c> lstAssignmentRule)
    {
        Map<id,Sales_Person__c> mpSalesPerson = new Map<id,Sales_Person__c>();
        for(Assignment_Rule__c assignmentRule :lstAssignmentRule)
        {
            mpSalesPerson.put(assignmentRule.User__c,null);
            //START S-350562 [Hemant 9/15/2015] - Query Mgr of Sales_Person__c user record
            if(assignmentRule.User__c != null && assignmentRule.User__r.ManagerId != null){
              mpSalesPerson.put(assignmentRule.User__r.ManagerId,null);

            }
            //END S-350562
            System.debug('SalespersonMap 1======'+mpSalesPerson);
        }
        for(Sales_Person__c salesPerson :[SELECT Id,User__c,ExtIDSalesPerson__c FROM Sales_Person__c WHERE Primary__c = true AND IsActive__c = true
                                        AND User__c IN :mpSalesPerson.keyset()])
        {
            mpSalesPerson.put(salesPerson.User__c,salesPerson);
            System.debug('SalespersonMap 2======'+mpSalesPerson);
        }
        System.debug('SalespersonMap======'+mpSalesPerson);
        return mpSalesPerson;
    }

    //============================================================//
    //Query and Populate Assignment Rules
    //============================================================//
    // Thsi method is to prepare all key combinations from Assignment Rule and populate the map with generated Key and Assignment Rule
    private static void QueryAssignmentRule(Map<String,Assignment_Rule__c> mpTerritoryKey,Set<String> zipCodes)
    {
        System.debug('QueryAssignmentRule Method==== ');
        // for(Assignment_Rule__c rule : [select Zip_Code__c,Industry_Group__c,WCW_Count__c ,Sales_Rep_ID__c,Emp_ID__c FROM Assignment_Rule__c where Sales_Rep_ID__c != null AND Zip_Code__c != null And Zip_Code__c IN :zipCodes]) {
        //for(Assignment_Rule__c rule : [select Zip_Code__c,Industry_Group__c,WCW_Count__c ,Sales_Rep_ID__c,Emp_ID__c FROM Assignment_Rule__c where Zip_Code__c != null And Zip_Code__c IN :zipCodes])
        //S-350562 [Hemant 9/15/2015] - add field User__r.ManagerId in query
        for(Assignment_Rule__c rule : [select Zip_Code__c,Industry_Group__c,WCW_Count__c ,User__c, User__r.ManagerId, User__r.IsActive FROM Assignment_Rule__c where Zip_Code__c != null And Zip_Code__c IN :zipCodes])
        {
            System.debug('QueryAssignmentRule==== '+rule);
            String ZipRangeGroup= null;
            // Case# 11041: Added a condition to generate the unique key where WCW count,zip and Industry group is not null.
            if((rule.WCW_Count__c!=null && rule.WCW_Count__c !='') && (rule.Industry_Group__c != null && rule.Industry_Group__c !=''))
            {
                System.debug('WCW Count condition==== ');
                mpTerritoryKey.put(rule.Zip_Code__c+rule.WCW_Count__c+rule.Industry_Group__c,rule);
                System.debug('mpTerritoryKey + WCW count ==== '+mpTerritoryKey);
                //ZipRangeGroup = rule.Zip_Code__c+rule.WCW_Count__c;
            }
            else if(rule.WCW_Count__c!=null && rule.WCW_Count__c !='')
            {
                System.debug('WCW Count condition==== ');
                mpTerritoryKey.put(rule.Zip_Code__c+rule.WCW_Count__c,rule);
                System.debug('mpTerritoryKey + WCW count ==== '+mpTerritoryKey);
                ZipRangeGroup = rule.Zip_Code__c+rule.WCW_Count__c;
            }

            else if(rule.Industry_Group__c != null && rule.Industry_Group__c !='')
            {
                System.debug('Industry group condition==== ');
                mpTerritoryKey.put(rule.Zip_Code__c+rule.Industry_Group__c,rule);
                System.debug('mpTerritoryKey + IndustryGroup ==== '+mpTerritoryKey);
                if(ZipRangeGroup != null)
                {
                    ZipRangeGroup += rule.Industry_Group__c;
                    mpTerritoryKey.put(ZipRangeGroup,rule);
                    System.debug('mpTerritoryKey + zipRangeGroup ==== '+mpTerritoryKey);
                }
            }
            else
            {
                    mpTerritoryKey.put(rule.Zip_Code__c,rule);
                    System.debug('mpTerritoryKey + zip code ==== '+mpTerritoryKey);
            }
        }
    }

    // Assignment Rule object?s employee ID for that record and then look at user object and find matching record
    // on User. OD_Employee_ID__c then set the Lead.Owner to the user.id found

   /* private static Map<String,User> LoadOwnerUserId(List<Assignment_Rule__c> lstAssignmentRule)
    {
        Map<String,User> mpUsers = new Map<String,User>();
        for(Assignment_Rule__c assignmentRule :lstAssignmentRule)
        {
            mpUsers.put(assignmentRule.Emp_ID__c,null);
        }
        for(User usrOwner :[SELECT Id,OD_Employee_ID__c FROM User WHERE IsActive = true AND OD_Employee_ID__c IN :mpUsers.keyset()])
        {
            mpUsers.put(usrOwner.OD_Employee_ID__c,usrOwner);
        }
        return mpUsers;
    } */

    //============================================================================================================//
    //Assign Owner to Account and the related Site Accounts according to Assignment Rule
    //===========================================================================================================//
    //private static void AssignOwner(Lead uLead, Assignment_Rule__c rule, Map<String,Sales_Person__c> mpSalesRep, Map<String,User> mpUsers)
    private static void AssignOwner(Lead uLead, Assignment_Rule__c rule, Map<id,Sales_Person__c> mpSalesRep)
    {
        System.debug('SalesPerson inside assign owner===='+ mpSalesRep);
        Sales_Person__c salesPerson = mpSalesRep.get(rule.User__c);

        //START S-350562 [Hemant 9/15/2015] - Assign to Mgr if active Sales_Person__c record not found
        if(rule.user__r.IsActive == false && rule.User__r.ManagerId != null){

          salesPerson = mpSalesRep.get(rule.User__r.ManagerId); //get SP for mgr if salesperson is null

            system.debug('MGR==> ' + rule.User__r.ManagerId);
        }
        //END S-350562

        if(salesPerson == null)
        {
            //logLeadFailures.logfailure(JSON.serialize(ulead),'Owner being assigned does not have valid Sales Rep ID');
            //uLead.addError('Owner being assigned does not have valid Sales Rep ID');
            assignDefaultOwner(uLead);
            uLead.Error_Message__c = 'Owner:' + rule.User__c +  ' being assigned does not have valid Sales Rep ID';
            return;
        }
        else
        {
            //User usrOwner = mpUsers.get(rule.Emp_ID__c);
              system.debug('User==> ' + rule.user__c);
            if(rule.User__c != null)
            {
                if(salesPerson.User__c == rule.User__c)
                {
                    uLead.OwnerId = rule.User__c;
                    uLead.Sales_Person_ID__c = salesPerson.Id;
                    uLead.Auto_assign__c = false;
                }
                //START S-350562 [Hemant 9/15/2015] - Assign to Mgr if active Sales_Person__c record not found
                else if(salesPerson.User__c == rule.User__r.ManagerId){
                    uLead.OwnerId = rule.User__r.ManagerId;
                    uLead.Sales_Person_ID__c = salesPerson.Id;
                    uLead.Auto_assign__c = false;
                }//END S-350562
                else
                {
                    //logLeadFailures.logfailure(JSON.serialize(ulead),'Owner being assigned does not have valid Sales Rep ID');
                    //uLead.addError('Owner being assigned does not have valid Sales Rep ID');
                    assignDefaultOwner(uLead);
                    uLead.Error_Message__c = 'Owner:' + rule.User__c +  ' being assigned does not have valid Sales Rep ID';
                }
            }
            else
            {
                //If no match is found in assignment rules table based on step 3 above please set to default ?Salesforce? user
                //Assign Default User as Lead Owner
                assignDefaultOwner(uLead);
            }
        }
    }



    //--------------------------------------------------------//
    //return key based on only postal and wcw count
    //--------------------------------------------------------//
    private static string generateZipWCWKey(Lead uLead)
    {
        String key='';
        String zipCode = uLead.zip__c;
        if(zipCode.length()>5)
            zipCode = zipCode.substring(0,5);
        key += uLead.zip__c == NULL?'':zipCode ;
        key += uLead.AssignRulesWCWLookup__c == NULL?'-':uLead.AssignRulesWCWLookup__c;
        System.debug('Zip+WCW key===='+key);
        return key;

    }

    //--------------------------------------------------------//
    //return key based on only postal and wcw count
    //--------------------------------------------------------//
    private static string generateZipIndustryKey(Lead uLead)
    {
        String key='';
        String zipCode = uLead.zip__c;
        if(zipCode.length()>5)
        zipCode = zipCode.substring(0,5);
        key += uLead.zip__c == NULL?'':zipCode ;
        key += uLead.Industry_Code__c == NULL?'-':uLead.Industry_Code__c ;
        System.debug('Zip+Industry Key===='+key);
        return key;

    }

    //----------------------------------------------------------------//
    //return key based on postal code, wcw count and industry sic code//
    //----------------------------------------------------------------//
    private static string generateZipWCWIndustryKey(Lead uLead)
    {
        String key='';
        String zipCode = uLead.zip__c;
        if(zipCode.length()>5)
        zipCode = zipCode.substring(0,5);
        key += uLead.zip__c == NULL?'':zipCode;
        //key += uLead.AssignRulesWCWLookup__c == NULL?'-':uLead.AssignRulesWCWLookup__c;
        //key += uLead.Industry_Code__c == NULL?'-':uLead.Industry_Code__c ;
        key += uLead.AssignRulesWCWLookup__c == NULL?'':uLead.AssignRulesWCWLookup__c;
        if ((uLead.Industry_Code__c == 'GV' || uLead.Industry_Code__c == 'ES') && uLead.AssignRulesWCWLookup__c == '20to999999')
          key += uLead.Industry_Code__c == NULL?'':uLead.Industry_Code__c ;
        System.debug('Zip+WCW+Industry key===='+key);
        return key;

    }

}