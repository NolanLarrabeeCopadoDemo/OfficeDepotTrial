global class ContactAssignments_Batch implements database.Batchable<Sobject>, Schedulable
{
    public String strQuery; //this variable used to set query from test class or from shceduler if required
    // below is set a default query in case not set in test class or in scheduler
    private String DEFAULT_QUERY='Select Id from Contact Limit 10';
    ///////////////////////////////
    /*
    private String DEFAULT_QUERY = 'Select Id,Error__c,CustomerID__c,Site_ID__c,Contact_First_name__c,Contact_Last_Name__c,Contact_SFDC_ID__c,Sequence_ID__c,Legacy_Createdby__c,Legacy_CreatedDate__c,Legacy_LastModifiedby__c,Legacy_LastModifiedDate__c,OMX_Header_PrimaryKey__c,OMX_Site_PrimaryKey__c,OMX_Contact_Primary_Key__c,' 
    +' Pin__c,Role__c,Status__c,MailingStreet__c,MailingCity__c,MailingState__c,MailingPostalCode__c,MailingCountry__c,Phone__c,Fax__c,Email__c,Title__c,Department__c from Contact_Assignment__c where Contact_SFDC_ID__c = null and Contact_Last_Name__c!= null';
    
    
    */
    /* Default Constructor*/
    global ContactAssignments_Batch()
    {
    }
    
    global ContactAssignments_Batch(String query)
    {
        //System.debug('QUEERY IS---->'+query);
        if(query != null && query != '')
            this.strQuery = query;
        else
            this.strQuery = DEFAULT_QUERY;
    }
    
    /* This method prepares the scope of the batch programbased on the query result*/
    
    
    global Database.QueryLocator start(Database.BatchableContext BC)
    {
        System.debug('QUERY IS ====='+strQuery);
        return Database.getQueryLocator(strQuery);
    }
    
    
     /* This method processes query result in batches */
     global void execute(Database.BatchableContext BC, SObject[] scope)
    {
    
    /////////////////////////////////////////
   /*
        List<Contact_Assignment__c> listAssignment=scope;
        Set<String> SetAccount_AOPS_Cust_ID= new Set<String>();
        Set<String> SetAccount_AOPS_Seq_ID= new Set<String>();
        Set<String> SetContact_AOPS_Cust_ID= new Set<String>();
        Set<String> SetHeaderPrimaryKey= new Set<String>();
        Set<String> SetSitePrimaryKey= new Set<String>();
        List<Contact> insertContact= new List<Contact>();
        List<Account> updateSite= new List<Account>();
        List<Contact_Assignment__c> updateContactAss= new List<Contact_Assignment__c>();
        
        try
        {
        //Step 0 - Inster the Existing Contact Id into the Staging table 
        Set<String> OMX_Contact_Primary_Key = new Set<String>();
        Map<String,Contact_Assignment__c> ca = new Map<String,Contact_Assignment__c>();
        list<Contact_Assignment__c> UpdateCA = new list<Contact_Assignment__c>();
        for(Contact_Assignment__c oa:listAssignment)
        {
            if(oa.OMX_Contact_Primary_Key__c != '' && oa.OMX_Contact_Primary_Key__c != null){
                OMX_Contact_Primary_Key.add(oa.OMX_Contact_Primary_Key__c);
                ca.put(oa.OMX_Contact_Primary_Key__c,oa);
            }
        
        }
        Map<String,String> contactkeys_p = new Map<String,String>();
        if(OMX_Contact_Primary_Key.size()>0){
            for(contact c1 :[SELECT id, OMX_primary_key__c from contact where OMX_primary_key__c IN:OMX_Contact_Primary_Key]){
                contactkeys_p.put(c1.OMX_primary_key__c,c1.Id);
            }
            for(Contact_Assignment__c oa_u:listAssignment)
            {
                if(oa_u.OMX_Contact_Primary_Key__c != '' && oa_u.OMX_Contact_Primary_Key__c != null){
                    if(contactkeys_p.containsKey(oa_u.OMX_Contact_Primary_Key__c)){
                        oa_u.Contact_SFDC_ID__c = contactkeys_p.get(oa_u.OMX_Contact_Primary_Key__c);
                        UpdateCA.add(oa_u);
                    }
                }
        
            }
            
            
        }
        if(UpdateCA.size()>0){
                update UpdateCA;
        }
        
        
        
        
        
        
            //Step 1----Insert all Contact assignment data into Contact.
            for(Contact_Assignment__c objAssignments:listAssignment)
            {
                if(objAssignments.CustomerID__c!=null && objAssignments.CustomerID__c!='')
                {
                    SetAccount_AOPS_Cust_ID.add(objAssignments.CustomerID__c);
                }
                if(objAssignments.Sequence_ID__c!=null && objAssignments.Sequence_ID__c!='')
                {
                    SetAccount_AOPS_Seq_ID.add(objAssignments.Sequence_ID__c);
                }
                if(objAssignments.OMX_Header_PrimaryKey__c!=null && objAssignments.OMX_Header_PrimaryKey__c!='')
                {
                    SetHeaderPrimaryKey.add(objAssignments.OMX_Header_PrimaryKey__c);
                }
                if(objAssignments.OMX_Site_PrimaryKey__c!=null && objAssignments.OMX_Site_PrimaryKey__c!='')
                {
                    SetSitePrimaryKey.add(objAssignments.OMX_Site_PrimaryKey__c);
                }
            }
            Map<String,Account> mapofAopsCustIDandAcc= new Map<String,Account>();
            for(Account acc:[Select id,AOPS_Cust_Id__c from Account where AOPS_Cust_Id__c in:SetAccount_AOPS_Cust_ID])
            {
                mapofAopsCustIDandAcc.put(acc.AOPS_Cust_Id__c,acc);
            }
            Map<String,Account> mapofHeaderandAcc= new Map<String,Account>();
            for(Account acc:[Select id,OMX_Primary_Key__c from Account where OMX_Primary_Key__c in:SetHeaderPrimaryKey])
            {
                mapofHeaderandAcc.put(acc.OMX_Primary_Key__c,acc);
            }
            for(Contact_Assignment__c objAssignments1:listAssignment)
            {
                Account acc_Alias= new Account();
                if(objAssignments1.CustomerID__c!=null)
                    acc_Alias=mapofAopsCustIDandAcc.get(objAssignments1.CustomerID__c);
                if(objAssignments1.OMX_Header_PrimaryKey__c!=null)
                    acc_Alias=mapofHeaderandAcc.get(objAssignments1.OMX_Header_PrimaryKey__c);
                Contact NewContactInsert= new Contact();
                if(acc_Alias!=null)
                {                
                    NewContactInsert.FirstName= objAssignments1.Contact_First_name__c;
                    NewContactInsert.LastName= objAssignments1.Contact_Last_Name__c;
                    NewContactInsert.AccountId= acc_Alias.id;              
                    NewContactInsert.Contact_Assignment__c=objAssignments1.id;
                    NewContactInsert.MailingStreet = objAssignments1.MailingStreet__c;
                    NewContactInsert.MailingCity  = objAssignments1.MailingCity__c;
                    NewContactInsert.MailingState = objAssignments1.MailingState__c;
                    NewContactInsert.MailingPostalCode = objAssignments1.MailingPostalCode__c;
                    NewContactInsert.MailingCountry = objAssignments1.MailingCountry__c;
                    NewContactInsert.Phone = objAssignments1.Phone__c;
                    NewContactInsert.Fax = objAssignments1.Fax__c;
                    NewContactInsert.Email =  objAssignments1.Email__c;
                    NewContactInsert.Title = objAssignments1.Title__c;
                    if(objAssignments1.CustomerID__c!=null)
                    {
                        NewContactInsert.Department = objAssignments1.Department__c;
                        NewContactInsert.AOPS_Account_Number__c=objAssignments1.CustomerID__c;
                    }
                    if(objAssignments1.OMX_Header_PrimaryKey__c!=null)
                    {
                        NewContactInsert.Status__c = objAssignments1.Status__c;
                        NewContactInsert.Legacy_CreatedDate__c = objAssignments1.Legacy_CreatedDate__c;
                        NewContactInsert.Legacy_LastModifiedDate__c = objAssignments1.Legacy_LastModifiedDate__c;
                        NewContactInsert.Role__c = objAssignments1.Role__c;
                        NewContactInsert.Pin__c = objAssignments1.pin__c;
                        NewContactInsert.Legacy_CreatedBy__c =objAssignments1.Legacy_Createdby__c;
                        NewContactInsert.Legacy_LastModifiedby__c = objAssignments1.Legacy_LastModifiedby__c;
                        NewContactInsert.OMX_Primary_Key__c = objAssignments1.OMX_Contact_Primary_Key__c;
                        
                    }
                    insertContact.add(NewContactInsert);
                }         
            }
            
            
            
            
            
            if(insertContact.size()>0)
            {
                //insert insertContact;
                //Mohan Changes
                Database.SaveResult[] srList = Database.insert(insertContact, false);
                Integer i = 0;
                Map<String,String> Errorv= new Map<String,String>();
                /////////////////////////////////////////////////////////////////////////////////////////////
                // Iterate through each returned result
                for (Database.SaveResult sr : srList) {
                    if (sr.isSuccess()) {
                        // Operation was successful, so get the ID of the record that was processed
                        Errorv.put(insertContact[i].Contact_Assignment__c, String.valueOf(sr.getId()));
                    }
                    else {
                        // Operation failed, so get all errors                
                        for(Database.Error err : sr.getErrors()) {
                            String ErrorStr = 'E : '+err.getStatusCode() + ': ' + err.getMessage() + 'fields that affected this error: ' + err.getFields();
                            Errorv.put(insertContact[i].Contact_Assignment__c, ErrorStr);
                            System.debug('Error ::::::::::::: '+insertContact[i].Contact_Assignment__c);
                        }
                    }
                    i++;
                }
                /////////////////////////////////////////////////////////////////////////////////////////////
                 for(Contact_Assignment__c objAssignments2:listAssignment){
                    String RecError = Errorv.get(objAssignments2.id);
                    if(RecError.substring(0,1) =='E')
                    {
                        objAssignments2.Error__c = RecError;
                    }
                    else{
                        objAssignments2.Contact_SFDC_ID__c = RecError;
                    }                   
                    updateContactAss.add(objAssignments2);                  
                }
                if(updateContactAss.size()>0)
                {
                    update updateContactAss;
                }
                //End updating the Error
                
                
                
                
                
            }
            // End of Step 1.

            
 
           
            // Step 3------The Sites are populated with the Contacts
            Map<String,List<Contact_Assignment__c>> map_listConAss=new Map<String,List<Contact_Assignment__c>>();
            Map<String,List<Contact_Assignment__c>> map_OMXlistConAss= new Map<String,List<Contact_Assignment__c>>();
            Contact_Assignment__c[] list_ConAss=[Select Id,Contact_SFDC_ID__c,Sequence_ID__c,OMX_Site_PrimaryKey__c from Contact_Assignment__c where (Sequence_ID__c in: SetAccount_AOPS_Seq_ID OR OMX_Site_PrimaryKey__c in:SetSitePrimaryKey) and id in : updateContactAss];
            for(Contact_Assignment__c ConAssignment:list_ConAss)
            {
            System.debug('Came in One::::::::');
                if(ConAssignment.Sequence_ID__c!=null)
                {
                System.debug('Came in 2::::::::');
                    List<Contact_Assignment__c> list_conass1= new List<Contact_Assignment__c>();
                    if(map_listConAss.containskey(ConAssignment.Sequence_ID__c))
                    {
                    System.debug('Came in 3::::::::');
                    
                        list_conass1=map_listConAss.get(ConAssignment.Sequence_ID__c);
                        map_listConAss.remove(ConAssignment.Sequence_ID__c);
                        list_conass1.add(ConAssignment);
                        map_listConAss.put(ConAssignment.Sequence_ID__c,list_conass1);
                    }
                    else
                    {
                    System.debug('Came in 4::::::::');
                        list_conass1.add(ConAssignment);
                        map_listConAss.put(ConAssignment.Sequence_ID__c,list_conass1);
                    }
                }
                if(ConAssignment.OMX_Site_PrimaryKey__c!=null)
                {
                System.debug('Came in 5::::::::');
                    List<Contact_Assignment__c> list_conass2= new List<Contact_Assignment__c>();
                    if(map_OMXlistConAss.containskey(ConAssignment.OMX_Site_PrimaryKey__c))
                    {
                    System.debug('Came in 6::::::::');
                    
                        list_conass2=map_OMXlistConAss.get(ConAssignment.OMX_Site_PrimaryKey__c);
                        map_OMXlistConAss.remove(ConAssignment.OMX_Site_PrimaryKey__c);
                        list_conass2.add(ConAssignment);
                        map_OMXlistConAss.put(ConAssignment.OMX_Site_PrimaryKey__c,list_conass2);
                    }
                    else
                    {
                    System.debug('Came in 7::::::::');
                        list_conass2.add(ConAssignment);
                        map_OMXlistConAss.put(ConAssignment.OMX_Site_PrimaryKey__c,list_conass2);
                    }
                }
            }
            
            List<Account> listAccSites=[Select id,AOPS_Seq_ID__c,OMX_Primary_Key__c,Site_Primary_Contact__c,Site_Contact2__c,Site_Contact3__c,Site_Contact4__c,Site_Contact5__c,Site_Contact6__c from Account where (AOPS_Seq_ID__c in:SetAccount_AOPS_Seq_ID OR OMX_Primary_Key__c IN:SetSitePrimaryKey)];
            System.debug('Came in 8::::::::');
            for(Account sitecontact_alias:listAccSites)
            {
            System.debug('Came in 9::::::::');
                List<Contact_Assignment__c> list_contactAssignment1 = new List<Contact_Assignment__c>();
                if(sitecontact_alias.AOPS_Seq_ID__c!=null)
                    list_contactAssignment1 = map_listConAss.get(sitecontact_alias.AOPS_Seq_ID__c);
                System.debug('Site======='+sitecontact_alias.id);
                System.debug('Site Primary Key======='+sitecontact_alias.OMX_Primary_Key__c);
                System.debug('map_OMXlistConAss'+map_OMXlistConAss.size()); 
                if(sitecontact_alias.OMX_Primary_Key__c!=null)
                    list_contactAssignment1 = map_OMXlistConAss.get(sitecontact_alias.OMX_Primary_Key__c);
                System.debug('map_OMXlistConAss'+map_OMXlistConAss);
                List<Contact_Assignment__c> list_contactAssignment = new List<Contact_Assignment__c>();
               System.debug('Came in 10::::::::'); 
                for(Contact_Assignment__c lc : list_contactAssignment1)
                {
                System.debug('Came in 11::::::::'+lc.Contact_SFDC_ID__c);
                System.debug('sitecontact_alias'+sitecontact_alias.id);
                    Boolean stat = false;
                    
                    if(sitecontact_alias.Site_Primary_Contact__c  == lc.Contact_SFDC_ID__c)
                    {
                        stat = true;           
                    }if(sitecontact_alias.Site_Contact2__c  == lc.Contact_SFDC_ID__c)
                    {
                        stat = true;              
                    }if(sitecontact_alias.Site_Contact3__c  == lc.Contact_SFDC_ID__c)
                    {
                       stat = true;            
                    }if(sitecontact_alias.Site_Contact4__c  == lc.Contact_SFDC_ID__c)
                    {
                        stat = true;            
                    }if(sitecontact_alias.Site_Contact5__c  == lc.Contact_SFDC_ID__c)
                    {
                        stat = true;              
                    }if(sitecontact_alias.Site_Contact6__c  == lc.Contact_SFDC_ID__c)
                    {
                        stat = true;            
                    }
                    
                    if(stat == false)
                        list_contactAssignment.add(lc);
                }
                
                System.debug('>>>>>>list_contactAssignmen>>>>>>>>>>>>>>>' + list_contactAssignment );
                
                Integer count = 0;
                count = list_contactAssignment.size();
                
                Integer countNew = 0;
                if(sitecontact_alias.Site_Primary_Contact__c  != null)
                {
                    countNew = countNew  + 1;            
                }if(sitecontact_alias.Site_Contact2__c  != null)
                {
                    countNew = countNew  + 1;            
                }if(sitecontact_alias.Site_Contact3__c  != null)
                {
                    countNew = countNew  + 1;            
                }if(sitecontact_alias.Site_Contact4__c  != null)
                {
                    countNew = countNew  + 1;            
                }if(sitecontact_alias.Site_Contact5__c  != null)
                {
                    countNew = countNew  + 1;            
                }if(sitecontact_alias.Site_Contact6__c  != null)
                {
                    countNew = countNew  + 1;            
                }
                
              /*
                
                // 31-07-2013
                //////////////////
                
                /*
                if(list_contactAssignment.size()>0)
                {
                     if(countNew == 0)
                     { 
                             if(count == 1 )
                             {
                                 sitecontact_alias.Site_Primary_Contact__c=list_contactAssignment[0].Contact_SFDC_ID__c;
                             } 
                             if(count == 2)
                             {
                                 sitecontact_alias.Site_Primary_Contact__c=list_contactAssignment[0].Contact_SFDC_ID__c;
                                 sitecontact_alias.Site_Contact2__c=list_contactAssignment[1].Contact_SFDC_ID__c;
                             } 
                             if(count==3)
                             {
                                 sitecontact_alias.Site_Primary_Contact__c=list_contactAssignment[0].Contact_SFDC_ID__c;
                                 sitecontact_alias.Site_Contact2__c=list_contactAssignment[1].Contact_SFDC_ID__c;
                                 sitecontact_alias.Site_Contact3__c=list_contactAssignment[2].Contact_SFDC_ID__c;
                             } 
                             if(count==4)
                             {
                                 sitecontact_alias.Site_Primary_Contact__c=list_contactAssignment[0].Contact_SFDC_ID__c;
                                 sitecontact_alias.Site_Contact2__c=list_contactAssignment[1].Contact_SFDC_ID__c;
                                 sitecontact_alias.Site_Contact3__c=list_contactAssignment[2].Contact_SFDC_ID__c;
                                 sitecontact_alias.Site_Contact4__c=list_contactAssignment[3].Contact_SFDC_ID__c;
                             } 
                             if(count==5)
                             {
                                 sitecontact_alias.Site_Primary_Contact__c=list_contactAssignment[0].Contact_SFDC_ID__c;
                                 sitecontact_alias.Site_Contact2__c=list_contactAssignment[1].Contact_SFDC_ID__c;
                                 sitecontact_alias.Site_Contact3__c=list_contactAssignment[2].Contact_SFDC_ID__c;
                                 sitecontact_alias.Site_Contact4__c=list_contactAssignment[3].Contact_SFDC_ID__c;
                                 sitecontact_alias.Site_Contact5__c=list_contactAssignment[4].Contact_SFDC_ID__c;
                             }
                             if(count==6 || count>6)
                             {
                                 sitecontact_alias.Site_Primary_Contact__c=list_contactAssignment[0].Contact_SFDC_ID__c;
                                 sitecontact_alias.Site_Contact2__c=list_contactAssignment[1].Contact_SFDC_ID__c;
                                 sitecontact_alias.Site_Contact3__c=list_contactAssignment[2].Contact_SFDC_ID__c;
                                 sitecontact_alias.Site_Contact4__c=list_contactAssignment[3].Contact_SFDC_ID__c;
                                 sitecontact_alias.Site_Contact5__c=list_contactAssignment[4].Contact_SFDC_ID__c;
                                 sitecontact_alias.Site_Contact6__c=list_contactAssignment[5].Contact_SFDC_ID__c;
                             } 
                         }
                         else if(countNew == 1)
                         { 
                             
                             if(count == 1)
                             {
                                 sitecontact_alias.Site_Contact2__c=list_contactAssignment[0].Contact_SFDC_ID__c;
                             } 
                             if(count==2)
                             {
                                 sitecontact_alias.Site_Contact2__c=list_contactAssignment[0].Contact_SFDC_ID__c;
                                 sitecontact_alias.Site_Contact3__c=list_contactAssignment[1].Contact_SFDC_ID__c;
                             } 
                             if(count==3)
                             {
                                 sitecontact_alias.Site_Contact2__c=list_contactAssignment[0].Contact_SFDC_ID__c;
                                 sitecontact_alias.Site_Contact3__c=list_contactAssignment[1].Contact_SFDC_ID__c;
                                 sitecontact_alias.Site_Contact4__c=list_contactAssignment[2].Contact_SFDC_ID__c;
                             } 
                             if(count==4)
                             {
                                 sitecontact_alias.Site_Contact2__c=list_contactAssignment[0].Contact_SFDC_ID__c;
                                 sitecontact_alias.Site_Contact3__c=list_contactAssignment[1].Contact_SFDC_ID__c;
                                 sitecontact_alias.Site_Contact4__c=list_contactAssignment[2].Contact_SFDC_ID__c;
                                 sitecontact_alias.Site_Contact5__c=list_contactAssignment[3].Contact_SFDC_ID__c;
                             }
                             if(count==5 || count>5)
                             {
                                 sitecontact_alias.Site_Contact2__c=list_contactAssignment[0].Contact_SFDC_ID__c;
                                 sitecontact_alias.Site_Contact3__c=list_contactAssignment[1].Contact_SFDC_ID__c;
                                 sitecontact_alias.Site_Contact4__c=list_contactAssignment[2].Contact_SFDC_ID__c;
                                 sitecontact_alias.Site_Contact5__c=list_contactAssignment[3].Contact_SFDC_ID__c;
                                 sitecontact_alias.Site_Contact6__c=list_contactAssignment[4].Contact_SFDC_ID__c;
                             } 
                         } 
                         else if(countNew == 2)
                         { 
                             if(count == 1)
                             {
                                 sitecontact_alias.Site_Contact3__c=list_contactAssignment[0].Contact_SFDC_ID__c;
                             } 
                             if(count==2)
                             {
                                 sitecontact_alias.Site_Contact3__c=list_contactAssignment[0].Contact_SFDC_ID__c;
                                 sitecontact_alias.Site_Contact4__c=list_contactAssignment[1].Contact_SFDC_ID__c;
                             } 
                             if(count==3)
                             {
                                 sitecontact_alias.Site_Contact3__c=list_contactAssignment[0].Contact_SFDC_ID__c;
                                 sitecontact_alias.Site_Contact4__c=list_contactAssignment[1].Contact_SFDC_ID__c;
                                 sitecontact_alias.Site_Contact5__c=list_contactAssignment[2].Contact_SFDC_ID__c;
                             } 
                             if(count==4 || count > 4)
                             {
                                 sitecontact_alias.Site_Contact3__c=list_contactAssignment[0].Contact_SFDC_ID__c;
                                 sitecontact_alias.Site_Contact4__c=list_contactAssignment[1].Contact_SFDC_ID__c;
                                 sitecontact_alias.Site_Contact5__c=list_contactAssignment[2].Contact_SFDC_ID__c;
                                 sitecontact_alias.Site_Contact6__c=list_contactAssignment[3].Contact_SFDC_ID__c;
                             }
                         }
                         else if(countNew == 3)
                         { 
                             if(count == 1)
                             {
                                 sitecontact_alias.Site_Contact4__c=list_contactAssignment[0].Contact_SFDC_ID__c;
                             } 
                             if(count==2)
                             {
                                 sitecontact_alias.Site_Contact4__c=list_contactAssignment[0].Contact_SFDC_ID__c;
                                 sitecontact_alias.Site_Contact5__c=list_contactAssignment[1].Contact_SFDC_ID__c;
                             } 
                             if(count==3 || count >3)
                             {
                                 sitecontact_alias.Site_Contact4__c=list_contactAssignment[0].Contact_SFDC_ID__c;
                                 sitecontact_alias.Site_Contact5__c=list_contactAssignment[1].Contact_SFDC_ID__c;
                                 sitecontact_alias.Site_Contact6__c=list_contactAssignment[2].Contact_SFDC_ID__c;
                             } 
                             
                         }
                         else if(countNew == 4)
                         { 
                             if(count == 1)
                             {
                                 sitecontact_alias.Site_Contact5__c=list_contactAssignment[0].Contact_SFDC_ID__c;
                             } 
                             if(count==2 || count > 2)
                             {
                                 sitecontact_alias.Site_Contact5__c=list_contactAssignment[0].Contact_SFDC_ID__c;
                                 sitecontact_alias.Site_Contact6__c=list_contactAssignment[1].Contact_SFDC_ID__c;
                             } 
                             
                         }
                         else if(countNew == 5)
                         { 
                             if(count==1 || count > 1)
                             {
                                 sitecontact_alias.Site_Contact6__c=list_contactAssignment[0].Contact_SFDC_ID__c;
                             } 
                         }
                }
                
                */
                    
                // 31-07-2013 Ends
                
                
                
               /* 
                
                updateSite.add(sitecontact_alias);
            }
            if(updateSite.size()>0){
                //update updateSite;
                Database.SaveResult[] srLists = Database.update(updateSite, false);
            }
        }
        catch(Exception e)
        {
            System.debug('The exception-->'+e);
        }
      */        
    }
    
    
    /* This method is to execute to relase some resources if any*/
    
    global void finish(Database.BatchableContext BC)
    {
        
    }
    
    
    /**
        This method must be there to implement Schedulable interface
    **/
    
    global void execute(SchedulableContext sc)
    {
        ///////////////
        /*
        String strquery = 'Select Id,Error__c,CustomerID__c,Site_ID__c,Contact_First_name__c,Contact_Last_Name__c,Contact_SFDC_ID__c,Sequence_ID__c,Legacy_Createdby__c,Legacy_CreatedDate__c,Legacy_LastModifiedby__c,Legacy_LastModifiedDate__c,OMX_Header_PrimaryKey__c,OMX_Site_PrimaryKey__c,OMX_Contact_Primary_Key__c,' 
    +' Pin__c,Role__c,Status__c,MailingStreet__c,MailingCity__c,MailingState__c,MailingPostalCode__c,MailingCountry__c,Phone__c,Fax__c,Email__c,Title__c,Department__c from Contact_Assignment__c where Contact_SFDC_ID__c = null and Contact_Last_Name__c!= null';
    ContactAssignments_Batch assignBatch1 = new ContactAssignments_Batch(strQuery);
    database.executebatch(assignBatch1, 2000);
        */

    }
}