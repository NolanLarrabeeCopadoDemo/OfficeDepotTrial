global class GNT_Contact_Batch implements database.Batchable<Sobject>, Schedulable
{
    public String strQuery;
    //CurrencyIsoCode - Need to add when Currency is Enabled
     
     private String DEFAULT_QUERY  = 'SELECT Id, Name,Contact_OMX_primary_key__c, '+
     'LastActivityDate, Title__c, MailingCountry__c, MailingState__c, '+
     'MailingCity__c, Street__c, MailingPostalCode__c, Email__c, Phone__c, Phone_Ext__c, Fax__c, First_Name__c, Legacy_LastModifiedDate__c, '+
     'Legacy_CreatedDate__c, Account_OMX_Primary_Key__c, Contact_Source__c,  Last_Order_Date_Of_Contact__c, Salutation__c, language__c, Role__c, '+
     'Email_Permission_Flag_c__c, SFDC_Id__c, Error_Message__c, ContactStatus__c, Processed_Status__c, SITE_OMX_Primary_Key__c from GTContact_Delta__c '+
     'where Processed_Status__c =\'Open\'   and createddate >= yesterday ';
     //Default Constructor
    global GNT_Contact_Batch(){}
    
    //Costructor to be called from the Batch Schedule method
    global GNT_Contact_Batch(String query){
        if(query != null && query != '')
            this.strQuery = query;
        else
            this.strQuery = DEFAULT_QUERY;
    }
    
    
    global Database.QueryLocator start(Database.BatchableContext BC){
         return Database.getQueryLocator(strQuery);
    }
     
    global void execute(Database.BatchableContext BC, SObject[] scope){
    
 
        List<GTContact_Delta__c> lstScopeContacts = scope; 
        List<GTContact_Delta__c> UpdatetheScopeBack = new List<GTContact_Delta__c>(); 
        Set<String> AccountId = new Set<String>();
        // Below List is used to check and eliminate duplicates for Duplicates
        Map<String, List<Contact>> lstSFDCContacts = new Map<String, List<Contact>>();
        Map<String, Contact> lstSFDCContacts_HFAID = new Map<String, Contact>();//<CONTACTHFAID, CONTACTS>
        list<Contact> c = new list<Contact>();
        List<Contact> ContactsToCreateinSFDC = new List<Contact>();
         List<Contact> ContactsToCreateinSFDCMAX = new List<Contact>();
        List<Contact> ContactsToUpdateinSFDC = new List<Contact>();
        Map<String,String>AccountKeys = new Map<String,String>();//<Acc.OMX_primaryKey,Acc.ID> 
        List<GTContact_Delta__c> Success_Error_tracking_update = new List<GTContact_Delta__c>();
        for(GTContact_Delta__c sc: lstScopeContacts){
            if(sc.Account_OMX_Primary_Key__c != ''){
                AccountId.add(sc.Account_OMX_Primary_Key__c);
            }
        }
       
        
        
        
        if(AccountId !=null && !AccountId .isEmpty()) { 

         //check if the Accounts are Existing
         list<Account> al = new List<Account>();
         try{
            al = [select Id,OMX_Primary_Key__c from account where OMX_Primary_Key__c in :AccountId ];}
            
            catch(Exception e){System.Debug('***********Error Occured'+e);}
               if(al!=null && !al.isEmpty()) {
                for(Account a : al){
                    AccountKeys.put(a.OMX_Primary_Key__c, a.Id); 
                }}
              
              if(lstScopeContacts!=null && !lstScopeContacts.isEmpty()) {  
            for(GTContact_Delta__c GTC :lstScopeContacts){
                if(!(AccountKeys.containsKey(GTC.Account_OMX_Primary_Key__c))){
                    GTC.Processed_Status__c = 'Error';
                    GTC.Error_Message__c = 'Account Not Found in SFDC';
                    UpdatetheScopeBack.add(GTC);
                }
            } 
            }
            //End check if the Accounts are Existing     
            
            //Get all the Contacts for those Account to Check for Duplicates
            try{
             c = [ SELECT Id, Account.OMX_primary_Key__c,OMX_primary_key__c, LastName, FirstName,Name, Phone, Email from contact where Account.OMX_primary_Key__c in :AccountId];
        }
        catch(Exception e){
        System.Debug('Error Occured..........'+e);
        }
        }
        
        //Get all the existing Contacts for the Accounts in Scope
        if(c!=null && !c.isEmpty()) { 

            for(Contact sfdc_c :c){
                lstSFDCContacts_HFAID.put(sfdc_c.OMX_primary_key__c,sfdc_c);
                if(lstSFDCContacts.containsKey(sfdc_c.Account.OMX_primary_Key__c)){
                    lstSFDCContacts.get(sfdc_c.Account.OMX_primary_Key__c).add(sfdc_c);
                }else{
                    List<Contact> mc = new List<Contact>();
                    mc.add(sfdc_c);
                    lstSFDCContacts.put(sfdc_c.Account.OMX_primary_Key__c, mc);
                }
                
            }
        }
        
        //Dealing with the creation of New Contacts and duplicateUpdates(which does not have SFDC ID in HFA System) : - All records that does not have SFDC ID meaning ready for Creation
        List<GTContact_Delta__c> Success_Error_tracking = new List<GTContact_Delta__c>();
        if(lstScopeContacts!=null && !lstScopeContacts.isEmpty()) { 



        for(GTContact_Delta__c GTC :lstScopeContacts){
            if(((GTC.SFDC_Id__c == '') || (GTC.SFDC_Id__c == null)) && (GTC.Processed_Status__c == 'Open')  && ((GTC.Contact_OMX_primary_key__c!= '') && (GTC.Contact_OMX_primary_key__c != null))      ){
                //check if the contact is already existing to avoid duplicate creation
                String res = isContactDuplicate(lstSFDCContacts, GTC);
                if(res == null){ // GO ahead and create the Contact 
                 Contact toc = new Contact();
                    toc.LastName = GTC.Name;
                    toc.OMX_Primary_Key__c = GTC.Contact_OMX_primary_key__c;
                    toc.AccountId = AccountKeys.get(GTC.Account_OMX_Primary_Key__c);
                    toc.Email=GTC.Email__c;
                    toc.Email_permission_flag__c=GTC.Email_Permission_Flag_c__c;
                    toc.Fax=GTC.Fax__c;
                    toc.FirstName=GTC.First_Name__c;
                    toc.Contact_Source__c=GTC.Contact_Source__c;
                    toc.Language__c=GTC.Language__c;
                    toc.Last_Order_Date_Of_Contact__c=GTC.Last_Order_Date_Of_Contact__c;
                    toc.Legacy_CreatedDate__c=GTC.Legacy_CreatedDate__c;
                    toc.Legacy_LastModifiedDate__c=GTC.Legacy_LastModifiedDate__c;
                    toc.MailingCity=GTC.MailingCity__c;
                    toc.MailingCountry=GTC.MailingCountry__c;
                    toc.MailingPostalCode=GTC.MailingPostalCode__c;
                    toc.MailingState=GTC.MailingState__c;
                    toc.Phone=GTC.Phone__c;
                    toc.Phone_Ext__c= GTC.Phone_Ext__c;
                    toc.Role__c=GTC.Role__c;
                    toc.Salutation=GTC.Salutation__c;
                    toc.SITE_OMX_Primary_Key__c=GTC.SITE_OMX_Primary_Key__c;
                   // toc. =GTC.SFDC_Id__c;
                    toc.MailingStreet= GTC.Street__c;
                    toc.Title=GTC.Title__c;
                    toc.Status__c= GTC.ContactStatus__c;
                    
                    ContactsToCreateinSFDC.add(toc);
                    Success_Error_tracking.add(GTC);
                    
                }
                
                else{ // Contact is Existing as duplicate either with Last Name or HFAID in SFDC
                    //IF the HFA ID is Existing in SFDC then update the contact
                    
                    if(lstSFDCContacts_HFAID.containsKey(GTC.Contact_OMX_primary_key__c)){ // Update the contact with HFA Key
                    
                    Id Contact_ID = lstSFDCContacts_HFAID.get(GTC.Contact_OMX_primary_key__c).ID;
                    if(Contact_ID  != null){
                        Contact toc = new Contact(Id=Contact_ID  );
                        toc.LastName = GTC.Name;
                        //toc.OMX_Primary_Key__c = GTC.Contact_OMX_primary_key__c;
                        //toc.AccountId = AccountKeys.get(GTC.Account_OMX_Primary_Key__c);
                        toc.Email=GTC.Email__c;
                        toc.Email_permission_flag__c=GTC.Email_Permission_Flag_c__c;
                        toc.Fax=GTC.Fax__c;
                        toc.FirstName=GTC.First_Name__c;
                        toc.Language__c=GTC.Language__c;
                        toc.Contact_Source__c=GTC.Contact_Source__c;
                        toc.Last_Order_Date_Of_Contact__c=GTC.Last_Order_Date_Of_Contact__c;
                        toc.Legacy_CreatedDate__c=GTC.Legacy_CreatedDate__c;
                        toc.Legacy_LastModifiedDate__c=GTC.Legacy_LastModifiedDate__c;
                        toc.MailingCity=GTC.MailingCity__c;
                        toc.MailingCountry=GTC.MailingCountry__c;
                        toc.MailingPostalCode=GTC.MailingPostalCode__c;
                        toc.MailingState=GTC.MailingState__c;
                        toc.Phone=GTC.Phone__c;
                        toc.Phone_Ext__c=GTC.Phone_Ext__c;
                        toc.Role__c=GTC.Role__c;
                        toc.Salutation=GTC.Salutation__c;
                               toc.SITE_OMX_Primary_Key__c=GTC.SITE_OMX_Primary_Key__c;
                       // toc. =GTC.SFDC_Id__c;
                        toc.MailingStreet= GTC.Street__c;
                        toc.Title=GTC.Title__c;
                        toc.Status__c= GTC.ContactStatus__c;
                        
                        ContactsToUpdateinSFDC.add(toc);
                        Success_Error_tracking_update.add(GTC);
                    }

                    }
                    
                    else{ // Contact is existing in SFDC with same last Name under the same account
                        GTC.Processed_Status__c = 'Error - Duplicate';
                        GTC.Error_Message__c = res;
                        UpdatetheScopeBack.add(GTC);
                    }}
                }
            }
        }
        
        Database.upsertResult[] srList;
        Integer i = 0;     
        
          System.debug('&&&&&&&&&&&&&&&&&&&entered'+ContactsToCreateinSFDC); 
        
        if(ContactsToCreateinSFDC.size()>0){
            srlist = database.upsert(ContactsToCreateinSFDC, Contact.Fields.OMX_primary_key__c, false);
           // upsert ContactsToCreateinSFDC OMX_primary_key__c;   //updated 10th sep        
        //Error Handling with the create - response 
       for (Database.upsertResult sr : srList) {
            if (sr.isSuccess()) {
            // Operation was successful, so get the ID of the record that was processed
                Success_Error_tracking[i].Processed_Status__c = 'Processed';
                Success_Error_tracking[i].Error_Message__c = 'CreatedID : '+sr.getId();                
                //System.debug('Successfully inserted account. Account ID: ' + sr.getId());
            }
            else {
            // Operation failed, so get all errors  
                Success_Error_tracking[i].Processed_Status__c = 'Error';                                                             
                for(Database.Error err : sr.getErrors()) {
                    Success_Error_tracking[i].Error_Message__c = Success_Error_tracking[i].Error_Message__c + err.getStatusCode() + ': ' + err.getMessage();
                    Success_Error_tracking[i].Error_Message__c = Success_Error_tracking[i].Error_Message__c +', fields that affected this error: ' + err.getFields();
                }
            }
           UpdatetheScopeBack.add(Success_Error_tracking[i]);
            
            i++;
        }
        //End error Handling with the create - response 
         }
      
        
        
        
             //Dealing with the create of contacts from maximizer
        
        for(GTContact_Delta__c GTC :lstScopeContacts){


            if(((GTC.SFDC_Id__c == '') || (GTC.SFDC_Id__c == null)) && (GTC.Processed_Status__c == 'Open')  && ((GTC.Contact_OMX_primary_key__c == '') || (GTC.Contact_OMX_primary_key__c == null))){


                System.debug('create IS CALLED');           
                    Contact toc = new Contact();
                    toc.LastName = GTC.Name;
                    toc.OMX_Primary_Key__c = GTC.Contact_OMX_primary_key__c;
                    toc.AccountId = AccountKeys.get(GTC.Account_OMX_Primary_Key__c);
                    toc.Email=GTC.Email__c;
                    toc.Email_permission_flag__c=GTC.Email_Permission_Flag_c__c;
                    toc.Fax=GTC.Fax__c;
                    toc.FirstName=GTC.First_Name__c;
                    toc.Language__c=GTC.Language__c;
                    toc.Contact_Source__c=GTC.Contact_Source__c;
                    toc.Last_Order_Date_Of_Contact__c=GTC.Last_Order_Date_Of_Contact__c;
                    toc.Legacy_CreatedDate__c=GTC.Legacy_CreatedDate__c;
                    toc.Legacy_LastModifiedDate__c=GTC.Legacy_LastModifiedDate__c;
                    toc.MailingCity=GTC.MailingCity__c;
                    toc.MailingCountry=GTC.MailingCountry__c;
                    toc.MailingPostalCode=GTC.MailingPostalCode__c;
                    toc.MailingState=GTC.MailingState__c;
                    toc.Phone=GTC.Phone__c;
                    toc.Phone_Ext__c=GTC.Phone_Ext__c;
                    toc.Role__c=GTC.Role__c;
                    toc.Salutation=GTC.Salutation__c;
                           toc.SITE_OMX_Primary_Key__c=GTC.SITE_OMX_Primary_Key__c;
                   // toc. =GTC.SFDC_Id__c;
                   toc.MailingStreet= GTC.Street__c;
                    toc.Title=GTC.Title__c;
                   toc.Status__c= GTC.ContactStatus__c;
                    
                    ContactsToCreateinSFDCMAX.add(toc);
                    Success_Error_tracking_update.add(GTC);
                    
                
            }
        }
        
        Database.SaveResult[] srList_createMAX;
        Integer p1 = 0;       
        if(ContactsToCreateinSFDCMAX.size()>0){
            srList_createMAX = Database.insert(ContactsToCreateinSFDCMAX, false);    

      
        //Error Handling with the create - response 
        for (Database.SaveResult sr : srList_createMAX) {
            if (sr.isSuccess()) {
            // Operation was successful, so get the ID of the record that was processed
                Success_Error_tracking_update[p1].Processed_Status__c = 'Processed';
                Success_Error_tracking_update[p1].Error_Message__c = 'createdID : '+sr.getId();                
                //System.debug('Successfully inserted account. Account ID: ' + sr.getId());
            }
            else {
            // Operation failed, so get all errors  
                Success_Error_tracking_update[p1].Processed_Status__c = 'Error';                                                             
                for(Database.Error err : sr.getErrors()) {
                    Success_Error_tracking_update[p1].Error_Message__c = Success_Error_tracking_update[p1].Error_Message__c + err.getStatusCode() + ': ' + err.getMessage();
                    Success_Error_tracking_update[p1].Error_Message__c = Success_Error_tracking_update[p1].Error_Message__c +', fields that affected this error: ' + err.getFields();
                }
            }
            UpdatetheScopeBack.add(Success_Error_tracking_update[p1]);
            
            p1++;
        }
        //End error Handling with the create - response 
         }
         
        
        
        
        
        
        
        
        //Dealing with the Update of existing Contacts: - All records that have SFDC ID meaning ready for update.       
 
        
        for(GTContact_Delta__c GTC :lstScopeContacts){
            if((GTC.SFDC_Id__c != '') && (GTC.SFDC_Id__c != null) && (GTC.Processed_Status__c == 'Open')){ 
                System.debug('UPDATE IS CALLED');           
                    Contact toc = new Contact(id = GTC.SFDC_Id__c);
                    toc.LastName = GTC.Name;
                    toc.OMX_Primary_Key__c = GTC.Contact_OMX_primary_key__c;
                    toc.AccountId = AccountKeys.get(GTC.Account_OMX_Primary_Key__c);
                    toc.Email=GTC.Email__c;
                    toc.Email_permission_flag__c=GTC.Email_Permission_Flag_c__c;
                    toc.Fax=GTC.Fax__c;
                    toc.FirstName=GTC.First_Name__c;
                    toc.Language__c=GTC.Language__c;
                    toc.Contact_Source__c=GTC.Contact_Source__c;
                    toc.Last_Order_Date_Of_Contact__c=GTC.Last_Order_Date_Of_Contact__c;
                    toc.Legacy_CreatedDate__c=GTC.Legacy_CreatedDate__c;
                    toc.Legacy_LastModifiedDate__c=GTC.Legacy_LastModifiedDate__c;
                    toc.MailingCity=GTC.MailingCity__c;
                    toc.MailingCountry=GTC.MailingCountry__c;
                    toc.MailingPostalCode=GTC.MailingPostalCode__c;
                    toc.MailingState=GTC.MailingState__c;
                    toc.Phone=GTC.Phone__c;
                    toc.Phone_Ext__c=GTC.Phone_Ext__c;
                    toc.Role__c=GTC.Role__c;
                    toc.Salutation=GTC.Salutation__c;
                           toc.SITE_OMX_Primary_Key__c=GTC.SITE_OMX_Primary_Key__c;
                   // toc. =GTC.SFDC_Id__c;
                   toc.MailingStreet= GTC.Street__c;
                    toc.Title=GTC.Title__c;
                   toc.Status__c= GTC.ContactStatus__c;
                    
                    ContactsToUpdateinSFDC.add(toc);
                    Success_Error_tracking_update.add(GTC);
                    
                
            }
        }
        
        Database.SaveResult[] srList_update;
        Integer p = 0;       
        if(ContactsToUpdateinSFDC.size()>0){
            srList_update = Database.update(ContactsToUpdateinSFDC, false);          
        //Error Handling with the create - response 
        for (Database.SaveResult sr : srList_update) {
            if (sr.isSuccess()) {
            // Operation was successful, so get the ID of the record that was processed
                Success_Error_tracking_update[p].Processed_Status__c = 'Processed';
                Success_Error_tracking_update[p].Error_Message__c = 'UpdatedID : '+sr.getId();                
                //System.debug('Successfully inserted account. Account ID: ' + sr.getId());
            }
            else {
            // Operation failed, so get all errors  
                Success_Error_tracking_update[p].Processed_Status__c = 'Error';                                                             
                for(Database.Error err : sr.getErrors()) {
                    Success_Error_tracking_update[p].Error_Message__c = Success_Error_tracking_update[p].Error_Message__c + err.getStatusCode() + ': ' + err.getMessage();
                    Success_Error_tracking_update[p].Error_Message__c = Success_Error_tracking_update[p].Error_Message__c +', fields that affected this error: ' + err.getFields();
                }
            }
            UpdatetheScopeBack.add(Success_Error_tracking_update[p]);
            
            p++;
        }
        //End error Handling with the create - response 
         }
         
         
         
         
       try{
        //Update the Success/Error into the Staging
           update UpdatetheScopeBack;
        }catch(Exception e){}
        
    
    
    }
    global String isContactDuplicate(Map<String, List<Contact>> mapC, GTContact_Delta__c currentContact ){
       String a = null;
        list<Contact> mlc = new list<Contact>();
        if(mapC.containsKey(currentContact.Account_OMX_Primary_Key__c)){
            mlc = mapC.get(currentContact.Account_OMX_Primary_Key__c);
            if(mlc.size()>0){
                for(Contact mlc_c : mlc){
                    // Check if the HFA ID Matches
                    if(mlc_c.OMX_primary_key__c == currentContact.Contact_OMX_primary_key__c){
                        a =  mlc_c.id +' - Matched with Contact HFA ID';
                        return a;
                    }
                    //Check if the Last-name Matches 
                    
                    String F_Name;
                    String F_Name_execCon;
                    String L_Name = currentContact.Name.trim();
                    String L_Name_execCon = mlc_c.LastName.trim();
                    if(currentContact.First_Name__c!=null)
                    F_Name = currentContact.First_Name__c.trim();
                    if(mlc_c.FirstName!=null)
                    F_Name_execCon = mlc_c.FirstName.trim();
                                                          
                    if((L_Name == L_Name_execCon) && (currentContact.Phone__c == mlc_c.Phone || currentContact.Email__c == mlc_c.Email)) {                    
                       a = mlc_c.id +' -  Matched with Last Name';
                        return a;
                    }
                }
            }else{
             a = null; //No Contacts to check across, so its not duplicate
            }
        }else{
            a = null; //No Contacts to check across, so its not duplicate
        }
        return a;
 
    }
      
    global void finish(Database.BatchableContext BC){
        
    }
    
     global void execute(SchedulableContext sc){ 
      String strquery = 'SELECT Id, Name,Contact_OMX_primary_key__c, '+
     'LastActivityDate, Title__c, MailingCountry__c, MailingState__c, '+
     'MailingCity__c, Street__c, MailingPostalCode__c, Email__c, Phone__c, Phone_Ext__c, Fax__c, First_Name__c, Legacy_LastModifiedDate__c, '+
     'Legacy_CreatedDate__c, Account_OMX_Primary_Key__c, Contact_Source__c,  Last_Order_Date_Of_Contact__c, Salutation__c,language__c, Role__c, '+
     'Email_Permission_Flag_c__c, SFDC_Id__c, Error_Message__c, ContactStatus__c, Processed_Status__c, SITE_OMX_Primary_Key__c from GTContact_Delta__c '+
     'where Processed_Status__c =\'Open\'  and createddate >= yesterday ';
     GNT_Contact_Batch assignBatch1 = new GNT_Contact_Batch (strQuery);
        database.executebatch(assignBatch1, 100);

     }

}