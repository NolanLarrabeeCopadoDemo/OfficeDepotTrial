/*
Description: The Scope of this Data Staging Table Object.
This batch will create new prospects,Sites,Contacts and Opportunities for Office Max Merger.

Created By: Subhrajyoti
Created Date: 21-Feb-2014

Modified By:
Modified Date:

Modify Reason:
*/
global class ProspectUpload_Batch implements database.Batchable<Sobject>, Schedulable
{
     public String strQuery; //this variable used to set query from test class or from shceduler if required
      
    // below is set a default query in case not set in test class or in scheduler
    private String DEFAULT_QUERY = 'Select Id,OMX_Rep_Number__c,Company_Name__c,Website__c,WCW_Count__c,OMX_Primary_Key__c,Error__c,'+
    'Address_Line_1__c,Address_Line_2__c,City__c,State__c,Zip__c,Contact_First_Name__c,Contact_Last_Name__c,Notes__c,'+
    'Contact_Phone__c,Contact_Email__c,Opportunity_Name__c,Primary_Product__c,Opportunity_Amount__c,Probability__c,Opportunity_Stage__c,'+
    'Primary_Competitor__c,Anticipated_Close_Date__c,Customer_Lifecycle__c,Status__c from Data_Staging_Table__c where Status__c = \'Not Started\' ';
    /* Default Constructor*/
    global ProspectUpload_Batch()
    {
    }
    
    global ProspectUpload_Batch(String query)
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
        return Database.getQueryLocator(strQuery);
    }
    /* This method processes query result in batches */
     global void execute(Database.BatchableContext BC, SObject[] scope)
    {
        Map<String,Schema.RecordTypeInfo> Accountrectype= Schema.SObjectType.Account.getRecordTypeInfosByName();
        List<Data_Staging_Table__c> lstdatastagingtable = scope;
        Set<String> UserandSalesperson=new Set<String>();
        Map<String,User> MapofUser=new Map<String,User>();
        Map<String,Sales_Person__c> MapofSalesperson=new Map<String,Sales_Person__c>();
        List<Account> lstofficemaxprospect = new List<Account>();
        List<Account> lstofficemaxsite = new List<Account>();
        List<Contact> lstofficemaxcontact = new List<Contact>();
        List<Opportunity> lstofficemaxopp = new List<Opportunity>();
        Set<Id> setdatastaging= new Set<Id>();
        Map<Id,Account> MapofProspect= new Map<Id,Account>();
        Map<Id,Opportunity> MapofOpportunity=new Map<Id,Opportunity>();
        List<Note> lstofficemaxoppNotes= new List<Note>();
        List<Data_Staging_Table__c> updatedatastaging= new List<Data_Staging_Table__c>();
        Set<String> Accountidtoupdate= new Set<String>();
        Map<String,Account> MapUpdateAccount= new Map<String,Account>();
        Set<Id> Contactaccid= new Set<Id>();
        Map<Id,List<Contact>> mapcheckdupcontact= new Map<Id,List<Contact>>();
        Boolean donotmakecontact;
        Map<Id,Account> MapofSite= new Map<Id,Account>();
        Map<Id,String> Errormessage = new Map<Id,String>();
        
        for(Data_Staging_Table__c datastaging_alias:lstdatastagingtable)
        {
            if(datastaging_alias.OMX_Rep_Number__c!=null)
            {
                UserandSalesperson.add(datastaging_alias.OMX_Rep_Number__c);
            } 
            if(datastaging_alias.OMX_Primary_Key__c!=null)
            {
                Accountidtoupdate.add(datastaging_alias.OMX_Primary_Key__c);
            }
        }
        
        for(User accowner:[Select id,name,OMX_Rep_Number__c from User where OMX_Rep_Number__c IN:UserandSalesperson])
        {
            MapofUser.put(accowner.OMX_Rep_Number__c,accowner);
        }
        
        for(Sales_Person__c salepersonid:[Select id,IsActive__c,Primary__c,ExtIDSalesPerson__c from Sales_Person__c where ExtIDSalesPerson__c IN:UserandSalesperson and IsActive__c=true and Primary__c=true])
        {
            MapofSalesperson.put(salepersonid.ExtIDSalesPerson__c,salepersonid);
        }
        
        for(Account updateacc:[Select id,Recordtypeid,ownerid,Sales_PersonID__c,Name,Website,Org_WCW_Count_Rep__c,Data_Staging_TableID__c,OMX_Primary_Key__c from Account where OMX_Primary_Key__c IN:Accountidtoupdate])
        {
            MapUpdateAccount.put(updateacc.OMX_Primary_Key__c,updateacc);
        }
          
         for(Data_Staging_Table__c datastaging_alias1:lstdatastagingtable)
         {
            String strerror='';
             User officemaxaccowner= new User();
             officemaxaccowner = MapofUser.get(datastaging_alias1.OMX_Rep_Number__c);
             system.debug('User record-->'+officemaxaccowner);
             Sales_Person__c officemaxsalesperson= new Sales_Person__c();
             officemaxsalesperson= MapofSalesperson.get(datastaging_alias1.OMX_Rep_Number__c);
             system.debug('Salesperson record-->'+officemaxsalesperson);
             if(officemaxaccowner!=null && officemaxsalesperson!=null)
             {
                 setdatastaging.add(datastaging_alias1.id);
                 system.debug('display one--'+datastaging_alias1.OMX_Primary_Key__c);
                 system.debug('display two--'+datastaging_alias1.Company_Name__c);
                 //Skip making records if any mandatory fields are missing.
                 if(datastaging_alias1.OMX_Primary_Key__c==null && datastaging_alias1.Company_Name__c!=null
                 && datastaging_alias1.Address_Line_1__c!=null && datastaging_alias1.City__c!=null && 
                 datastaging_alias1.State__c!=null && datastaging_alias1.Zip__c!=null && datastaging_alias1.Contact_Last_Name__c!=null &&
                 datastaging_alias1.Opportunity_Name__c!=null && datastaging_alias1.Primary_Product__c!=null && 
                 datastaging_alias1.Opportunity_Amount__c!=null && datastaging_alias1.Primary_Competitor__c!=null && 
                 datastaging_alias1.Anticipated_Close_Date__c!=null && datastaging_alias1.Customer_Lifecycle__c!=null && 
                 (datastaging_alias1.Probability__c!=null || datastaging_alias1.Opportunity_Stage__c!=null))
                 {
                     //Insert Prospects
                     Account officemaxPros= new Account();
                     officemaxPros.Recordtypeid= Accountrectype.get('Prospect (OfficeMax)').getRecordTypeId();
                     officemaxPros.ownerid= officemaxaccowner.id; 
                     officemaxPros.Sales_PersonID__c= officemaxsalesperson.id;
                     officemaxPros.Name= datastaging_alias1.Company_Name__c;
                     officemaxPros.Website= datastaging_alias1.Website__c;
                     officemaxPros.Org_WCW_Count_Rep__c= datastaging_alias1.WCW_Count__c;
                     officemaxPros.Data_Staging_TableID__c= datastaging_alias1.id;
                     //Address for prospects
                     officemaxPros.Address1__c= datastaging_alias1.Address_Line_1__c;
                     officemaxPros.Address2__c= datastaging_alias1.Address_Line_2__c;
                     officemaxPros.City__c= datastaging_alias1.City__c;
                     officemaxPros.State__c= datastaging_alias1.State__c;
                     officemaxPros.Zip__c= datastaging_alias1.Zip__c;
                     officemaxPros.Original_System__c='OfficeMax Upload';
                     lstofficemaxprospect.add(officemaxPros);
                 }
                 else
                 {
                    if(strerror.trim()=='' && datastaging_alias1.OMX_Primary_Key__c==null)
                        strerror+= ' '+'Mandatory fields missing. ';
                 }
                 if(datastaging_alias1.OMX_Primary_Key__c!=null)
                 {
                    //Update Prospect
                    Account officemaxprosupdate= MapUpdateAccount.get(datastaging_alias1.OMX_Primary_Key__c);
                    if(officemaxprosupdate!=null)
                    {
                        system.debug('Inside Update prospect');
                        officemaxprosupdate.Data_Staging_TableID__c= datastaging_alias1.id;
                        lstofficemaxprospect.add(officemaxprosupdate);
                    }
                 }
             }
             else
             {
                if(strerror.trim()=='')
                    strerror+= ' '+'Owner or Salesperson record not found. ';
             }
            
            Errormessage.put(datastaging_alias1.id,strerror);
         }
         system.debug('lstofficemaxprospect-->'+lstofficemaxprospect.size());
         if(lstofficemaxprospect.size()>0)
         {
             upsert lstofficemaxprospect;            
         }
         for(Account insertedprosalias:[Select id,name,Data_Staging_TableID__c,ownerid,Sales_PersonID__c from Account where Data_Staging_TableID__c IN:setdatastaging])
         {
             Contactaccid.add(insertedprosalias.id);
             MapofProspect.put(insertedprosalias.Data_Staging_TableID__c,insertedprosalias);
         }
         for(Contact checkdupcontact:[Select id,lastname,Phone,email,accountid from Contact where accountid IN:Contactaccid])
         {
             List<Contact> templist= new List<Contact>();
             if(mapcheckdupcontact.containskey(checkdupcontact.accountid))
             {
                templist= mapcheckdupcontact.get(checkdupcontact.accountid);
                mapcheckdupcontact.remove(checkdupcontact.accountid);
                templist.add(checkdupcontact);
                mapcheckdupcontact.put(checkdupcontact.accountid,templist);
             }
             else
             {
                 templist.add(checkdupcontact);
                 mapcheckdupcontact.put(checkdupcontact.accountid,templist);
             }
         }
         for(Data_Staging_Table__c datastaging_alias2:lstdatastagingtable)
         {
             donotmakecontact=false;
             String strerror1= Errormessage.get(datastaging_alias2.id);
             Account insertedpros= new Account();
             insertedpros= MapofProspect.get(datastaging_alias2.id);
             if(insertedpros!=null)
             {
                 //Insert Sites
                 //Skip making records if any mandatory fields are missing.
                 if(datastaging_alias2.OMX_Primary_Key__c==null && datastaging_alias2.Company_Name__c!=null
                 && datastaging_alias2.Address_Line_1__c!=null && datastaging_alias2.City__c!=null && 
                 datastaging_alias2.State__c!=null && datastaging_alias2.Zip__c!=null && datastaging_alias2.Contact_Last_Name__c!=null &&
                 datastaging_alias2.Opportunity_Name__c!=null && datastaging_alias2.Primary_Product__c!=null && 
                 datastaging_alias2.Opportunity_Amount__c!=null && datastaging_alias2.Primary_Competitor__c!=null && 
                 datastaging_alias2.Anticipated_Close_Date__c!=null && datastaging_alias2.Customer_Lifecycle__c!=null && 
                 (datastaging_alias2.Probability__c!=null || datastaging_alias2.Opportunity_Stage__c!=null))
                 {
                     Account officemaxSite= new Account();
                     officemaxSite.Name= datastaging_alias2.Company_Name__c;
                     officemaxSite.ownerid= insertedpros.ownerid;
                     officemaxSite.Sales_PersonID__c= insertedpros.Sales_PersonID__c;
                     officemaxSite.Recordtypeid= Accountrectype.get('Site (OfficeMax)').getRecordTypeId();
                     officemaxSite.Related_Account__c= insertedpros.id;
                     officemaxSite.Primary_Site__c=true;
                     officemaxSite.Address1__c= datastaging_alias2.Address_Line_1__c;
                     officemaxSite.Address2__c= datastaging_alias2.Address_Line_2__c;
                     officemaxSite.City__c= datastaging_alias2.City__c;
                     officemaxSite.State__c= datastaging_alias2.State__c;
                     officemaxSite.Zip__c= datastaging_alias2.Zip__c;
                     officemaxSite.Original_System__c='OfficeMax Upload';
                     lstofficemaxsite.add(officemaxSite);
                 }
                 else
                 {  
                    if(strerror1.trim()=='' && datastaging_alias2.OMX_Primary_Key__c==null)
                        strerror1+= ' '+'Mandatory fields missing. ';
                 }
                 
                 //Insert Contact
                 //Skip making records if any mandatory fields are missing.
                 if(datastaging_alias2.Company_Name__c!=null
                 && datastaging_alias2.Address_Line_1__c!=null && datastaging_alias2.City__c!=null && 
                 datastaging_alias2.State__c!=null && datastaging_alias2.Zip__c!=null && datastaging_alias2.Contact_Last_Name__c!=null &&
                 datastaging_alias2.Opportunity_Name__c!=null && datastaging_alias2.Primary_Product__c!=null && 
                 datastaging_alias2.Opportunity_Amount__c!=null && datastaging_alias2.Primary_Competitor__c!=null && 
                 datastaging_alias2.Anticipated_Close_Date__c!=null && datastaging_alias2.Customer_Lifecycle__c!=null && 
                 (datastaging_alias2.Probability__c!=null || datastaging_alias2.Opportunity_Stage__c!=null))
                 {
                     //checking duplicate contacts
                     List<Contact> checkdupcon= mapcheckdupcontact.get(insertedpros.id);
                     if(checkdupcon!=null)
                     {
                         for(Contact c:checkdupcon)
                         {
                             if((c.email==datastaging_alias2.Contact_Email__c && datastaging_alias2.Contact_Email__c!=null) || (c.phone==datastaging_alias2.Contact_Phone__c && datastaging_alias2.Contact_Phone__c!=null) || (c.lastname==datastaging_alias2.Contact_Last_Name__c && datastaging_alias2.Contact_Last_Name__c!=null))
                             {
                                 system.debug('duplicate contact check');
                                 donotmakecontact=true;
                                 break;
                             }
                         }
                     }
                     if(donotmakecontact==false)
                     {
                         //Actual insertion
                         Contact officemaxcontact= new Contact();
                         officemaxcontact.FirstName= datastaging_alias2.Contact_First_Name__c;
                         officemaxcontact.LastName= datastaging_alias2.Contact_Last_Name__c;
                         officemaxcontact.Phone= datastaging_alias2.Contact_Phone__c;
                         officemaxcontact.Email= datastaging_alias2.Contact_Email__c;
                         officemaxcontact.Primary_Contact__c=true;
                         officemaxcontact.AccountId= insertedpros.id;
                         officemaxcontact.Source_System__c='OfficeMax Upload';
                         lstofficemaxcontact.add(officemaxcontact);
                     }
                 } 
                 else
                 {
                    if(strerror1.trim()=='')
                        strerror1+= ' '+'Mandatory fields missing. ';
                 }
                 
             }  
             else
             {
                if(strerror1.trim()=='')
                {
                    strerror1+= ' '+'Header Account not found. ';
                }
             }
             Errormessage.put(datastaging_alias2.id,strerror1);
         }
         system.debug('lstofficemaxsite-->'+lstofficemaxsite.size());
         if(lstofficemaxsite.size()>0)
         {
             insert lstofficemaxsite;
         }
         system.debug('lstofficemaxcontact-->'+lstofficemaxcontact.size());
         if(lstofficemaxcontact.size()>0)
         {
             insert lstofficemaxcontact;
         }
         for(Account insertedsite:[Select id,Related_Account__c,Primary_Site__c from Account where Related_Account__c IN:Contactaccid and recordtype.id=:Accountrectype.get('Site (OfficeMax)').getRecordTypeId() and Primary_Site__c=:true])
         {
             MapofSite.put(insertedsite.Related_Account__c,insertedsite);
         }
         
         //added for the story #S-399120 #START
         
         Set<String> setPC = new Set<String>();
         Map<String, OpportunityCompetitor__c> mapNameToOpp = new Map<String, OpportunityCompetitor__c>();
         
         // collect all Primary_Competitor__c field values in a set
         for(Data_Staging_Table__c datastaging_alias4:lstdatastagingtable){
            setPC.add(datastaging_alias4.Primary_Competitor__c);
         }
         
         Id devRecordTypeId = Schema.SObjectType.OpportunityCompetitor__c.getRecordTypeInfosByName().get(Constants.PrimaryCompetitorRT).getRecordTypeId();
          
         for(OpportunityCompetitor__c opp : [select id, name from OpportunityCompetitor__c where name like :setPC and recordTypeID = :devRecordTypeId order by lastModifiedDate desc ]) {
            if(!mapNameToOpp.containsKey(opp.name)) {
                mapNameToOpp.put(opp.name, opp);
            } 
         }
         
         //added for the story #S-399120 #END
         
         for(Data_Staging_Table__c datastaging_alias4:lstdatastagingtable)
         {
             String strerror2= Errormessage.get(datastaging_alias4.id);
             Account insertedpros= new Account();
             insertedpros= MapofProspect.get(datastaging_alias4.id);
            if(insertedpros!=null)
             {
              //Insert Opportunity
              //Skip making records if any mandatory fields are missing.
                 if(datastaging_alias4.Company_Name__c!=null
                 && datastaging_alias4.Address_Line_1__c!=null && datastaging_alias4.City__c!=null && 
                 datastaging_alias4.State__c!=null && datastaging_alias4.Zip__c!=null && datastaging_alias4.Contact_Last_Name__c!=null &&
                 datastaging_alias4.Opportunity_Name__c!=null && datastaging_alias4.Primary_Product__c!=null && 
                 datastaging_alias4.Opportunity_Amount__c!=null && datastaging_alias4.Primary_Competitor__c!=null && 
                 datastaging_alias4.Anticipated_Close_Date__c!=null && datastaging_alias4.Customer_Lifecycle__c!=null && 
                 (datastaging_alias4.Probability__c!=null || datastaging_alias4.Opportunity_Stage__c!=null))
                 {
                     Opportunity officemaxopp= new Opportunity();
                     officemaxopp.Name= datastaging_alias4.Opportunity_Name__c;
                     officemaxopp.Product__c= datastaging_alias4.Primary_Product__c;
                     officemaxopp.Amount= datastaging_alias4.Opportunity_Amount__c;  
                     
                     // commented for story #S-399120           
                     //officemaxopp.Primary_Competitor1__c= datastaging_alias4.Primary_Competitor__c;
                     
                     //added for the story #S-399120 #START
                     
                     if(mapNameToOpp.containsKey(datastaging_alias4.Primary_Competitor__c)) {
                        // Commented For Releaseofficemaxopp.Primary_Competitor1__c = mapNameToOpp.get(datastaging_alias4.Primary_Competitor__c).id;
                     }
                     
                     //added for the story #S-399120 #END
                      
                     officemaxopp.CloseDate= datastaging_alias4.Anticipated_Close_Date__c;
                     officemaxopp.Customer_Lifecycle__c= datastaging_alias4.Customer_Lifecycle__c;
                     officemaxopp.AccountId= insertedpros.id;
                     officemaxopp.ownerid= insertedpros.ownerid;
                    officemaxopp.Source_System__c ='OfficeMax Upload';
                     //Check for Primary Site
                     Account insertedsite= new Account();
                     insertedsite=MapofSite.get(insertedpros.id);
                     if(insertedsite!=null)                     
                      officemaxopp.Related_Site__c= insertedsite.id;
                     //Probability and Stage Logic
                     if((datastaging_alias4.Opportunity_Stage__c!=null && datastaging_alias4.Probability__c!=null) || datastaging_alias4.Opportunity_Stage__c!=null)
                     {
                         officemaxopp.StageName= datastaging_alias4.Opportunity_Stage__c;
                         if(datastaging_alias4.Opportunity_Stage__c=='0%-Lost' || datastaging_alias4.Opportunity_Stage__c=='0%-Walkaway' || datastaging_alias4.Opportunity_Stage__c=='0%-Duplicate/Cancelled')
                             officemaxopp.Probability=0;
                         else if(datastaging_alias4.Opportunity_Stage__c=='1%-Qualifying Prospect')
                             officemaxopp.Probability=1;    
                         else if(datastaging_alias4.Opportunity_Stage__c=='10%-Appointment Secured')
                             officemaxopp.Probability=10;
                         else if(datastaging_alias4.Opportunity_Stage__c=='25%-Initial Approach')
                             officemaxopp.Probability=25;
                         else if(datastaging_alias4.Opportunity_Stage__c=='50%-Presentation')
                             officemaxopp.Probability=50;
                         else if(datastaging_alias4.Opportunity_Stage__c=='75%-Negotiate & Finalize')
                             officemaxopp.Probability=75;
                         else if(datastaging_alias4.Opportunity_Stage__c=='90%-Execute')
                             officemaxopp.Probability=90;
                         else if(datastaging_alias4.Opportunity_Stage__c=='100%-Won')
                             officemaxopp.Probability=100;   
                         else
                             officemaxopp.Probability=10; 
                     }
                     else if(datastaging_alias4.Probability__c!=null)
                     {
                         officemaxopp.Probability= datastaging_alias4.Probability__c;
                         if(datastaging_alias4.Probability__c==0)
                             officemaxopp.StageName='Lost';
                         else if(datastaging_alias4.Probability__c==1)
                             officemaxopp.StageName='Qualify' ;    
                         else if(datastaging_alias4.Probability__c==10)
                             officemaxopp.StageName='10%-Appointment Secured';
                         else if(datastaging_alias4.Probability__c==25)
                             officemaxopp.StageName='25%-Initial Approach';
                         else if(datastaging_alias4.Probability__c==50)
                             officemaxopp.StageName='Pursue' ;
                         else if(datastaging_alias4.Probability__c==75)
                             officemaxopp.StageName='Propose' ;
                         else if(datastaging_alias4.Probability__c==90)
                             officemaxopp.StageName= 'Verbal Win' ;
                         else if(datastaging_alias4.Probability__c==100)                 
                             officemaxopp.StageName='Close';
                         else
                             officemaxopp.StageName='10%-Appointment Secured';
                     }    
                     officemaxopp.Data_Staging_TableID__c = datastaging_alias4.id;
                     lstofficemaxopp.add(officemaxopp);
                 } 
                 else
                 {
                    if(strerror2.trim()=='')
                        strerror2+= ' '+'Mandatory fields missing. ';
                 }
              } 
              Errormessage.put(datastaging_alias4.id,strerror2);
         }
         
         system.debug('lstofficemaxopp-->'+lstofficemaxopp.size());
         if(lstofficemaxopp.size()>0)
         {
             insert lstofficemaxopp;
         }
         for(Opportunity insertedoppalias:[Select id,name,Data_Staging_TableID__c from Opportunity where Data_Staging_TableID__c IN:setdatastaging])
         {
             MapofOpportunity.put(insertedoppalias.Data_Staging_TableID__c,insertedoppalias);
         }
         
         for(Data_Staging_Table__c datastaging_alias3:lstdatastagingtable)
         {
             Opportunity insertedopp= new Opportunity();
             insertedopp= MapofOpportunity.get(datastaging_alias3.id);
             if(insertedopp!=null && datastaging_alias3.Notes__c!=null)
             {
                 //Insert Note to related Opportunity.
                 Note oppnote= new Note();
                 oppnote.parentid= insertedopp.id;
                 oppnote.title='OfficeMax Note for '+insertedopp.Name;
                 oppnote.body= datastaging_alias3.Notes__c;
                 lstofficemaxoppNotes.add(oppnote);
             }
             String strerror3= Errormessage.get(datastaging_alias3.id);
             if(strerror3.trim() =='')
                datastaging_alias3.Status__c='Processed';
             else
             {
                datastaging_alias3.Status__c='Error';
                datastaging_alias3.Error__c=strerror3;
             }  
             updatedatastaging.add(datastaging_alias3);
         }
         if(lstofficemaxoppNotes.size()>0)
         {
             insert lstofficemaxoppNotes;
         }
         if(updatedatastaging.size()>0)
         {
             update updatedatastaging;
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
        String strQuery = '';
        ProspectUpload_Batch assignBatch = new ProspectUpload_Batch(strQuery);
        database.executebatch(assignBatch, 100);
    } 
}