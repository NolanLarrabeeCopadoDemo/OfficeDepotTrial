global class ContactDeltaAssignments_Batch implements database.Batchable<Sobject>, Schedulable
{
    public String strQuery; //this variable used to set query from test class or from shceduler if required
    // below is set a default query in case not set in test class or in scheduler
    private String DEFAULT_QUERY = 'Select Id, OMX_Site_key__c, OMX_Site_Contact1__c, OMX_Site_Contact2__c, OMX_Site_Contact3__c, OMX_Site_Contact4__c, OMX_Site_Contact5__c, OMX_Site_Contact6__c,Status__c,' 
    +' Error__c,OMX_Site_Contact7__c,OMX_Site_Contact8__c,OMX_Site_Contact9__c,OMX_Site_Contact10__c from Contact_Delta_Assignment__c where Status__c != \'Processed\' and CreatedDate = LAST_N_DAYS:7 order by createddate desc ';
    
    /* Default Constructor*/
    global ContactDeltaAssignments_Batch()
    {
    }
    
    global ContactDeltaAssignments_Batch(String query)
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
        List<Contact_Delta_Assignment__c> listAssignment=scope;
        Set<String> OMXSite= new Set<String>();
        Set<String> OMXContacts= new Set<String>();
        Map<String,Account> mapofSite= new Map<String,Account>();
        Map<String,Contact> mapofContact= new Map<String,Contact>();
        List<Account> updatesite= new List<Account>();
        List<Contact_Delta_Assignment__c> updatecondelass= new List<Contact_Delta_Assignment__c>();
        try
        {
            for(Contact_Delta_Assignment__c objAssignments:listAssignment)
            {
                if(objAssignments.OMX_Site_key__c!=null && objAssignments.OMX_Site_key__c!='')
                {
                    OMXSite.add(objAssignments.OMX_Site_key__c);
                }
                if(objAssignments.OMX_Site_Contact1__c!=null && objAssignments.OMX_Site_Contact1__c!='')
                    OMXContacts.add(objAssignments.OMX_Site_Contact1__c);
                if(objAssignments.OMX_Site_Contact2__c!=null && objAssignments.OMX_Site_Contact2__c!='')
                    OMXContacts.add(objAssignments.OMX_Site_Contact2__c);
                if(objAssignments.OMX_Site_Contact3__c!=null && objAssignments.OMX_Site_Contact3__c!='')
                    OMXContacts.add(objAssignments.OMX_Site_Contact3__c);
                if(objAssignments.OMX_Site_Contact4__c!=null && objAssignments.OMX_Site_Contact4__c!='')
                    OMXContacts.add(objAssignments.OMX_Site_Contact4__c);
                if(objAssignments.OMX_Site_Contact5__c!=null && objAssignments.OMX_Site_Contact5__c!='')
                    OMXContacts.add(objAssignments.OMX_Site_Contact5__c);
                if(objAssignments.OMX_Site_Contact6__c!=null && objAssignments.OMX_Site_Contact6__c!='')
                    OMXContacts.add(objAssignments.OMX_Site_Contact6__c);
                if(objAssignments.OMX_Site_Contact7__c!=null && objAssignments.OMX_Site_Contact7__c!='')
                    OMXContacts.add(objAssignments.OMX_Site_Contact7__c);
                if(objAssignments.OMX_Site_Contact8__c!=null && objAssignments.OMX_Site_Contact8__c!='')
                    OMXContacts.add(objAssignments.OMX_Site_Contact8__c);
                if(objAssignments.OMX_Site_Contact9__c!=null && objAssignments.OMX_Site_Contact9__c!='')
                    OMXContacts.add(objAssignments.OMX_Site_Contact9__c);
                if(objAssignments.OMX_Site_Contact10__c!=null && objAssignments.OMX_Site_Contact10__c!='')
                    OMXContacts.add(objAssignments.OMX_Site_Contact10__c);      
            }
            for(Account acc:[Select id,OMX_Primary_Key__c,Related_Account__c,Site_Primary_Contact__c,Site_Contact2__c,Site_Contact3__c,Site_Contact4__c,Site_Contact5__c,Site_Contact6__c,Site_Primary_Contact__r.Pin__c,Site_Contact2__r.Pin__c,Site_Contact3__r.Pin__c,Site_Contact4__r.Pin__c,Site_Contact5__r.Pin__c,Site_Contact6__r.Pin__c from Account where OMX_Primary_Key__c IN:OMXSite])
            {
                mapofSite.put(acc.OMX_Primary_Key__c,acc);
            }
            for(Contact con:[Select id,OMX_Primary_Key__c,accountid from Contact where OMX_Primary_Key__c IN:OMXContacts])
            {
                mapofContact.put(con.OMX_Primary_Key__c,con);
            }
            for(Contact_Delta_Assignment__c objAssignments:listAssignment)
            {
                String errorstr = '';
                List<Id> assignContact= new List<Id>();
                Account siteacc= mapofSite.get(objAssignments.OMX_Site_key__c);
                if(siteacc!=null)
                {
                    //Existing Contacts on Site that should stay.
                    system.debug('Account id-->'+siteacc.id);
                    system.debug('siteacc.Site_Primary_Contact__r.Pin__c-->'+siteacc.Site_Primary_Contact__r.Pin__c+'siteacc.Site_Primary_Contact__c'+siteacc.Site_Primary_Contact__c);
                    if(siteacc.Site_Primary_Contact__r.Pin__c==null && siteacc.Site_Primary_Contact__c!=null)
                    {
                            system.debug('Inside primary');
                            assignContact.add(siteacc.Site_Primary_Contact__c);
                    }
                    if(siteacc.Site_Contact2__r.Pin__c==null && siteacc.Site_Contact2__c!=null)
                            assignContact.add(siteacc.Site_Contact2__c);
                    if(siteacc.Site_Contact3__r.Pin__c==null && siteacc.Site_Contact3__c!=null)
                            assignContact.add(siteacc.Site_Contact3__c);
                    if(siteacc.Site_Contact4__r.Pin__c==null && siteacc.Site_Contact4__c!=null)
                            assignContact.add(siteacc.Site_Contact4__c);
                    if(siteacc.Site_Contact5__r.Pin__c==null && siteacc.Site_Contact5__c!=null)
                            assignContact.add(siteacc.Site_Contact5__c);
                    if(siteacc.Site_Contact6__r.Pin__c==null && siteacc.Site_Contact6__c!=null)
                            assignContact.add(siteacc.Site_Contact6__c);
                    //End
                    system.debug('Existing contacts-->'+assignContact);
                    //New Contacts coming from Delta Records
                    if(objAssignments.OMX_Site_Contact1__c!=null)
                    {
                        Contact con1= mapofContact.get(objAssignments.OMX_Site_Contact1__c);
                        if(con1!=null && con1.accountid==siteacc.Related_Account__c)
                            assignContact.add(con1.id);
                        else
                            errorstr+= ' Not able to find Contact OR Header Contact mismatch.';
                    }
                    if(objAssignments.OMX_Site_Contact2__c!=null)
                    {
                        Contact con2= mapofContact.get(objAssignments.OMX_Site_Contact2__c);
                        if(con2!=null && con2.accountid==siteacc.Related_Account__c)
                            assignContact.add(con2.id);
                        else
                            if(errorstr.trim()=='')
                                errorstr+= ' Not able to find Contact OR Header Contact mismatch.';
                    }
                    if(objAssignments.OMX_Site_Contact3__c!=null)
                    {
                        Contact con3= mapofContact.get(objAssignments.OMX_Site_Contact3__c);
                        if(con3!=null && con3.accountid==siteacc.Related_Account__c)
                            assignContact.add(con3.id);
                        else
                            if(errorstr.trim()=='')
                                errorstr+= ' Not able to find Contact OR Header Contact mismatch.';
                    }
                    if(objAssignments.OMX_Site_Contact4__c!=null)
                    {
                        Contact con4= mapofContact.get(objAssignments.OMX_Site_Contact4__c);
                        if(con4!=null && con4.accountid==siteacc.Related_Account__c)
                            assignContact.add(con4.id);
                        else
                            if(errorstr.trim()=='')
                                errorstr+= ' Not able to find Contact OR Header Contact mismatch.';
                    }
                    if(objAssignments.OMX_Site_Contact5__c!=null)
                    {
                        Contact con5= mapofContact.get(objAssignments.OMX_Site_Contact5__c);
                        if(con5!=null && con5.accountid==siteacc.Related_Account__c)
                            assignContact.add(con5.id);
                        else
                            if(errorstr.trim()=='')
                                errorstr+= ' Not able to find Contact OR Header Contact mismatch.';
                    }
                    if(objAssignments.OMX_Site_Contact6__c!=null)
                    {
                        Contact con6= mapofContact.get(objAssignments.OMX_Site_Contact6__c);
                        if(con6!=null && con6.accountid==siteacc.Related_Account__c)
                            assignContact.add(con6.id);
                        else
                            if(errorstr.trim()=='')
                                errorstr+= ' Not able to find Contact OR Header Contact mismatch.';
                    }
                    if(objAssignments.OMX_Site_Contact7__c!=null)
                    {
                        Contact con7= mapofContact.get(objAssignments.OMX_Site_Contact7__c);
                        if(con7!=null && con7.accountid==siteacc.Related_Account__c)
                            assignContact.add(con7.id);
                        else
                            if(errorstr.trim()=='')
                                errorstr+= ' Not able to find Contact OR Header Contact mismatch.';
                    }
                    if(objAssignments.OMX_Site_Contact8__c!=null)
                    {
                        Contact con8= mapofContact.get(objAssignments.OMX_Site_Contact8__c);
                        if(con8!=null && con8.accountid==siteacc.Related_Account__c)
                            assignContact.add(con8.id);
                        else
                            if(errorstr.trim()=='')
                                errorstr+= ' Not able to find Contact OR Header Contact mismatch.';
                    }
                    if(objAssignments.OMX_Site_Contact9__c!=null)
                    {
                        Contact con9= mapofContact.get(objAssignments.OMX_Site_Contact9__c);
                        if(con9!=null && con9.accountid==siteacc.Related_Account__c)
                            assignContact.add(con9.id);
                        else
                            if(errorstr.trim()=='')
                                errorstr+= ' Not able to find Contact OR Header Contact mismatch.';
                    }
                    if(objAssignments.OMX_Site_Contact10__c!=null)
                    {
                        Contact con10= mapofContact.get(objAssignments.OMX_Site_Contact10__c);
                        if(con10!=null && con10.accountid==siteacc.Related_Account__c)
                            assignContact.add(con10.id);
                        else
                            if(errorstr.trim()=='')
                                errorstr+= ' Not able to find Contact OR Header Contact mismatch.';
                    }
                    system.debug('New Contacts coming-->'+assignContact);
                    //End
                    //Remove duplicate from assignContact and add it to contactsequence
                    List<Id> contactsequence= new List<Id>();
                    Boolean variable;
                    for(Id alias:assignContact)
                    {
                        if(contactsequence.size()==0)
                        {
                            contactsequence.add(alias);
                        }
                        else
                        {
                            for(Id alias1:contactsequence)
                            {
                                variable=false;
                                if(alias1==alias)
                                {
                                    variable=true;
                                    break;
                                }
                            }
                            if(variable==false)
                                contactsequence.add(alias);
                        }
                    }
                    system.debug('Second List'+contactsequence);
                    //Actual Assignment of Contacts to Site record.
                    System.debug('assignContact.size ====='+assignContact.size());
                    if(contactsequence!=null)
                    {
                        if(contactsequence.size()==0)
                        {
                            siteacc.Site_Primary_Contact__c= null;
                            siteacc.Site_Contact2__c= null;
                            siteacc.Site_Contact3__c= null;
                            siteacc.Site_Contact4__c= null;
                            siteacc.Site_Contact5__c= null;
                            siteacc.Site_Contact6__c= null;
                        }
                        if(contactsequence.size()==1)
                        {
                            siteacc.Site_Primary_Contact__c= contactsequence[0];
                            siteacc.Site_Contact2__c= null;
                            siteacc.Site_Contact3__c= null;
                            siteacc.Site_Contact4__c= null;
                            siteacc.Site_Contact5__c= null;
                            siteacc.Site_Contact6__c= null;
                        }
                        if(contactsequence.size()==2) 
                        {
                            siteacc.Site_Primary_Contact__c= contactsequence[0];
                            siteacc.Site_Contact2__c= contactsequence[1];
                            siteacc.Site_Contact3__c= null;
                            siteacc.Site_Contact4__c= null;
                            siteacc.Site_Contact5__c= null;
                            siteacc.Site_Contact6__c= null;
                        }
                        if(contactsequence.size()==3)
                        {
                            siteacc.Site_Primary_Contact__c= contactsequence[0];                            
                            siteacc.Site_Contact2__c= contactsequence[1];
                            siteacc.Site_Contact3__c= contactsequence[2];
                            siteacc.Site_Contact4__c= null;
                            siteacc.Site_Contact5__c= null;
                            siteacc.Site_Contact6__c= null;
                        }   
                        if(contactsequence.size()==4) 
                        {
                            siteacc.Site_Primary_Contact__c= contactsequence[0];
                            siteacc.Site_Contact2__c= contactsequence[1];
                            siteacc.Site_Contact3__c= contactsequence[2];
                            siteacc.Site_Contact4__c= contactsequence[3];
                            siteacc.Site_Contact5__c= null;
                            siteacc.Site_Contact6__c= null;
                        }   
                        if(contactsequence.size()==5) 
                        {
                            siteacc.Site_Primary_Contact__c= contactsequence[0];
                            siteacc.Site_Contact2__c= contactsequence[1];
                            siteacc.Site_Contact3__c= contactsequence[2];
                            siteacc.Site_Contact4__c= contactsequence[3];
                            siteacc.Site_Contact5__c= contactsequence[4];
                            siteacc.Site_Contact6__c= null;
                        }
                        if(contactsequence.size()>=6) 
                        {
                            siteacc.Site_Primary_Contact__c= contactsequence[0];
                            siteacc.Site_Contact2__c= contactsequence[1];
                            siteacc.Site_Contact3__c= contactsequence[2];
                            siteacc.Site_Contact4__c= contactsequence[3];
                            siteacc.Site_Contact5__c= contactsequence[4];
                            siteacc.Site_Contact6__c= contactsequence[5];
                        }
                    }
                    //End   
                    updatesite.add(siteacc);
                    system.debug('site to update-->'+siteacc);
                }
                else
                {
                    errorstr+= ' Not able to find Site Account';
                }
                
                if(errorstr.trim()=='')
                {
                    objAssignments.Status__c='Processed';
                }
                else
                {
                    if(siteacc==null)
                    {
                        objAssignments.Status__c='Error';
                        objAssignments.Error__c= errorstr;
                    }
                    else
                    {
                        objAssignments.Status__c='Partially Processed';
                        objAssignments.Error__c= errorstr;
                    }
                }
                updatecondelass.add(objAssignments);
            }
            if(updatesite.size()>0)
                Database.update(updatesite,false);
            if(updatecondelass.size()>0)
                Database.update(updatecondelass,false);
        }
        catch(Exception e)
        {
            System.debug('The exception-->'+e);
        }
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
        String strquery = 'Select Id,OMX_Site_key__c,OMX_Site_Contact1__c,OMX_Site_Contact2__c,OMX_Site_Contact3__c,OMX_Site_Contact4__c,OMX_Site_Contact5__c,OMX_Site_Contact6__c,Status__c,' 
    +' Error__c,OMX_Site_Contact7__c,OMX_Site_Contact8__c,OMX_Site_Contact9__c,OMX_Site_Contact10__c from Contact_Delta_Assignment__c where Status__c != \'Processed\' and CreatedDate = LAST_N_DAYS:7 order by createddate desc ';
    ContactDeltaAssignments_Batch assignBatch1 = new ContactDeltaAssignments_Batch(strQuery);
    database.executebatch(assignBatch1, 2000);
    }
}