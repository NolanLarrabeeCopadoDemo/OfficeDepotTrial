public class AccountRestore {
    
    public Map<ID,ID> relatedAcctsMap;
    public Map<ID,ID> parentAcctsMap;
    public Map<String,ID> recTypeMapAcct;
    public Map<String,ID> recTypeMapExtn;
    public Set<ID> newAccountIDs;
    public Map<ID,ID> allExtntoAccount; 
    public Map<ID,ID> allDormanttoAccount;
    public list<Account_Dormant__c> DormantRecordstoRemove;
    public String systemAccount;
    
    public AccountRestore() {
        relatedAcctsMap = new Map<ID,ID>();
        parentAcctsMap  = new Map<ID,ID>();
        recTypeMapAcct = new Map<String,ID>();
        recTypeMapExtn = new Map<String,ID>(); 
        newAccountIDs = new Set<ID>();
        allExtntoAccount = new Map<ID,ID>();
        allDormanttoAccount = new Map<ID,ID>();
        DormantRecordstoRemove = new list<Account_Dormant__c>();
        
        for (RecordType r:[select id,name,sobjectType,DeveloperName from recordtype where sobjectType in ('Account','Account_Extension__c')]) {
            if (r.sobjectType=='Account_Extension__c')
                recTypeMapExtn.put(r.DeveloperName,r.id);
            else
                recTypeMapAcct.put(r.DeveloperName,r.id);
        }
    }
    
    public String RestoreAccount(list<Account_Dormant__c> acctDormant, String reasonCode, String comments) {
    
        Set<ID> acctExtns = new Set<ID>();
        list<Account> createAcctsLstH = new list<Account>();
        list<Account> createAcctsLstC = new list<Account>();
        list<Account> createAcctsLstPS = new list<Account>();
        String retString='Success';
        Set<ID> headersOnly = new Set<ID>();
        systemAccount = [SELECT id,system_account__c from Data_Cleansing_Settings__c].system_account__c;
        
        for (Account_Dormant__c a:acctDormant) {
            acctExtns.add(a.AccountExtension__c);  
            
        }
        
    
        
        list <Account_Extension__c> acctExtensionList = fetchAccountExtension(acctExtns);
        
        //Collect all Header Information

        Map<ID,Account_Extension__c> extensionAcctCreate = new Map<ID,Account_Extension__c>();
        set<id> extensionHeaderIDs = new set<id>();
        
        //Check Headers Exists in Dormant
        list<ID> hIDs = new list<ID>();
        Map<ID,Account_Dormant__c> headerExistsinDormant = new Map<ID,Account_Dormant__c>();
        
        for (Account_Extension__c e: acctExtensionList) {
            if (e.Related_OD_Account_Extension__c != null)
                hIDs.add(e.Related_OD_Account_Extension__c);
            if (e.Account_ParentId__c != null)
                hIDs.add(e.Account_ParentId__c);
        } 
        
        for (Account_Dormant__c ad:[select id,AccountExtension__c from account_dormant__c where AccountExtension__c=:hIDs])
            headerExistsinDormant.put(ad.AccountExtension__c,ad);
        
        for (Account_Extension__c e: acctExtensionList) {
           
            if (e.Related_OD_Account_Extension__c != null && headerExistsinDormant.containsKey(e.Related_OD_Account_Extension__c)) {
                    extensionHeaderIDs.add(e.Related_OD_Account_Extension__c);
            }
                
            if (e.Account_ParentId__c != null && headerExistsinDormant.containsKey(e.Account_ParentId__c)) 
                    extensionHeaderIDs.add(e.Account_ParentId__c);

        }
        
        list <Account_Extension__c> acctExtensionListH = new list<Account_Extension__c>();
        headersOnly = extensionHeaderIDs.clone();
        
        if (extensionHeaderIDs.size() > 0)
          acctExtensionListH = fetchAccountExtension(extensionHeaderIDs);
        
        for (Account_Extension__c ae : acctExtensionListH) {
              createAcctsLstH.add(createAcctRecord(ae,reasonCode,comments));
        }
        
        Database.UpsertResult[] acctHeaderCreateResults;
          if (!createAcctsLstH.isEmpty()) {
           acctHeaderCreateResults = Database.upsert(createAcctsLstH,false);
              for (Database.UpsertResult r: acctHeaderCreateResults) {
                  system.debug('Header Upsert Result:' + r.getId() + ':'+r.isSuccess()+':'+ r.getErrors());
                  if (r.isSuccess())
                      newAccountIDs.add(r.getid());

              }
          }
        
        
        list<ID> createdAccount = new list<ID>();
        
        if (acctHeaderCreateResults != null) {
          for (Database.UpsertResult dr : acctHeaderCreateResults) {
            createdAccount.add(dr.getId()); 
            
          }
        }
        
        acctExtensionList.clear();
        
        acctExtensionList=fetchAccountExtension(acctExtns);
            
        
        for (Account_Extension__c ae:acctExtensionList) {
            if (ae.recordtype.DeveloperName == 'Customer' || ae.recordtype.DeveloperName == 'Customer_OfficeMax' || ae.recordtype.DeveloperName == 'Prospect')
                headersOnly.add(ae.id);
            Account a = createAcctRecord(ae,reasonCode,comments);
            createAcctsLstC.add(a);
        }

          Database.UpsertResult[] acctChildCreateResults = Database.upsert(createAcctsLstC,false);
        
        for (Database.UpsertResult r: acctChildCreateResults) {
            system.debug('Child Upsert Result:' + r.getId() + ':'+r.isSuccess()+':'+ r.getErrors());
        }
          
        for (Database.UpsertResult r: acctChildCreateResults) {
                  if (r.isSuccess())
                      newAccountIDs.add(r.getid());
                  else if (!r.isSuccess())
                    system.debug('Error in Child Update:'+r.getErrors());
                       

        }
        
        //Create Headers Primary Sites - Starts
        list<Account_Dormant__C> AcctPSDormantIDs = new list<Account_Dormant__c>();
        set<ID> primarySiteExtensionIDs = new set<ID>();
        for (Account_Dormant__c d : [select id,AccountExtension__c from account_dormant__c where AccountExtension__r.Related_OD_Account_Extension__c = :headersOnly 
                                  and AccountExtension__r.recordtype.DeveloperName in ('Site','Site_OfficeMax')
                                  and (AccountExtension__r.AOPS_Seq_ID__c like '%-00001' or AccountExtension__r.AOPS_Seq_ID__c like '%-00002' or AccountExtension__r.omx_primary_key__c like '%OMX001' or AccountExtension__r.omx_primary_key__c like '%OMX002' or AccountExtension__r.Primary_Site__c = true)])
        {
           primarySiteExtensionIDs.add(d.AccountExtension__c);
           AcctPSDormantIDs.add(d);
        }
        
        list <Account_Extension__c> acctExtensionListPS = new list<Account_Extension__c>();
        if (primarySiteExtensionIDs.size() > 0) {
            acctExtensionListPS = fetchAccountExtension(primarySiteExtensionIDs);
        }
        
        for (Account_Extension__c ae:acctExtensionListPS) {
            createAcctsLstPS.add(createAcctRecord(ae,reasonCode,comments));
        }
        
        Database.UpsertResult[] acctPSCreateResults;
          if (!createAcctsLstPS.isEmpty()) {
           acctPSCreateResults = Database.upsert(createAcctsLstPS,false);
           
           for (Database.UpsertResult r: acctPSCreateResults) {
                  system.debug('PrimarySite Upsert Result:' + r.getId() + ':'+r.isSuccess()+':'+ r.getErrors());
                  if (r.isSuccess())
                      newAccountIDs.add(r.getid());
        }   
              
          }
        
        // Create Headers Primary Sites - Ends

          
          for (Account_Dormant__c d: [select id,AccountExtension__c,AccountExtension__r.account__c from Account_Dormant__c where AccountExtension__r.account__c=:newAccountIDs]) {
              System.debug('&&&&&&&&&&&&&extension'+d.AccountExtension__c);
              allExtntoAccount.put(d.AccountExtension__c,d.AccountExtension__r.account__c);
              allDormanttoAccount.put (d.id,d.AccountExtension__r.account__c);
          }
    
          
          if (acctDormant.size() == 1) {
              for(Account a:[select id from account where Account_Extension__c=:acctDormant[0].AccountExtension__c])
              {
                retString = a.id;  
              }
           
          }
        
         //list<Account_Dormant__c> DormantRecordstoRemove = new list<Account_Dormant__c>();
         for (Account_Dormant__c d: acctDormant) {
          if (allDormanttoAccount.containsKey(d.id))
             DormantRecordstoRemove.add(d);
         }
         for (Account_Dormant__c d: headerExistsinDormant.values()) {
          if (allDormanttoAccount.containsKey(d.id))
             DormantRecordstoRemove.add(d);
         }
         for (Account_Dormant__c d: AcctPSDormantIDs) {
           if (allDormanttoAccount.containsKey(d.id))
             DormantRecordstoRemove.add(d);
         }
         
         copyAccountProfile(); 
         relinkOpportunities();
         relinkCase();
         relinkdeviatedCost();
         relinkPriceChanges();
         relinkContact();
         relinkCPM();
         createAttachment();
         createNotes();
         relinkTask();
         relinkEvent();
         reLinksiteContact();
         reLinkDupJunction();
         relinktransitionDtls();
         
        
        
        database.delete(DormantRecordstoRemove,false);
        executeoncetest.bypassAccountExtension = true;
        
        return retString;
     /* }
        Catch(Exception e) {
            system.debug('Unexpected Exception:' + e);
            return 'Error';
        }*/
     
    }

    public void relinktransitionDtls() {
        list<Customer_Transition_Dtls__c> tDtls = new list<Customer_Transition_Dtls__c>();
        for (Customer_Transition_Dtls__c t: [select id, Account_Extension_ID__r.Account__c,Account_Extension_ID__c, Account_ID__c from Customer_Transition_Dtls__c where Account_Extension_ID__c=:allExtntoAccount.keySet()]) {
                t.Account_ID__c = t.Account_Extension_ID__r.Account__c;
                tdtls.add(t);
         }
        if (tdtls.size() > 0)
          database.upsert(tdtls,false);
    }
        
        
    public void relinkOpportunities() {
        list<Opportunity> oppUpd = new list<Opportunity>();
        for (Opportunity o: [select id, Account_Extension_Name__r.Account__c,Account_Extension_Name__c, AccountId from Opportunity where Account_Extension_Name__c=:allExtntoAccount.keySet()]) {
            //if (allExtntoAccount.containsKey(o.Account_Extension_Name__c)) {
                //o.AccountId = allExtntoAccount.get(o.Account_Extension_Name__c);
                o.AccountId = o.Account_Extension_Name__r.Account__c;
                oppUpd.add(o);
            //}  
         }
        
        for (Opportunity o: [select id, Account_Extension_Related_Site__r.Account__c,Account_Extension_Name__r.Account__c,Account_Extension_Related_Site__c, Related_Site__c from Opportunity where Account_Extension_Related_Site__c=:allExtntoAccount.keySet()]) {
           // if (allExtntoAccount.containsKey(o.Account_Extension_Related_Site__c)) {
              //  o.Related_Site__c = allExtntoAccount.get(o.Account_Extension_Related_Site__c);
                o.Related_Site__c = o.Account_Extension_Related_Site__r.Account__c;
                o.AccountId = o.Account_Extension_Name__r.Account__c;
                oppUpd.add(o);
            //}  
         }
        
         if (oppUpd.size() > 0)
             database.Upsert(oppUpd,false); 
                
    }    

public void relinkCase() {
        list<Case> caseUpd = new list<Case>();
        for (Case c: [select id,Account_Extension_Id__r.Account__c, Account_Extension_Id__c, AccountId from Case where Account_Extension_Id__c=:allExtntoAccount.keySet()]) {
            //if (allExtntoAccount.containsKey(c.Account_Extension_Id__c)) {
              //  c.AccountId = allExtntoAccount.get(c.Account_Extension_Id__c);
                c.AccountId = c.Account_Extension_Id__r.Account__c;
                caseUpd.add(c);
            //}  
         }
        
         if (caseUpd.size() > 0)
             database.Upsert(caseUpd,false);
 }  
    
public void relinkTask() {
        list<Task> taskUpd = new list<Task>();
        for (Task c: [select id, whatId,Event_Account_Extension__r.Account__c,AccountId,Event_Account_Extension__c from Task where Event_Account_Extension__c=:allExtntoAccount.keySet()]) {
           // if (allExtntoAccount.containsKey(c.Event_Account_Extension__c)) {
              //  c.WhatId =  allExtntoAccount.get(c.Event_Account_Extension__c);
                c.WhatId =  c.Event_Account_Extension__r.Account__c;
                taskUpd.add(c);
            //}  
         }
        
         if (taskUpd.size() > 0)
             database.Upsert(taskUpd,false);
 } 

public void relinkEvent() {
        list<Event> eventUpd = new list<Event>();
        for (Event c: [select id, whatId,Event_Account_Extension__r.Account__c,Event_Account_Extension__c from Event where Event_Account_Extension__c=:allExtntoAccount.keySet()]) {
           // if (allExtntoAccount.containsKey(c.Event_Account_Extension__c)) {
               // c.WhatId =  allExtntoAccount.get(c.Event_Account_Extension__c);
               if (c.Event_Account_Extension__r.Account__c != null) {
                 c.WhatId = c.Event_Account_Extension__r.Account__c;
                 eventUpd.add(c);
               }
            //}  
         }
        
         if (eventUpd.size() > 0)
             database.Upsert(eventUpd,false);
 } 
    
public void createNotes() {
        list<Note> noteUpd = new list<Note>();
        list<ID> dIDs = new list<ID>();
        for (Account_Dormant__c d: DormantRecordstoRemove)
            dIDs.add(d.id);
        for (Note n: [select id,ParentId,Body,Title from Note where ParentId=:dIDs]) {
            if (allExtntoAccount.containsKey(n.ParentId)) {
               note nc = new note();
               nc.Parentid = allExtntoAccount.get(n.ParentId);
               nc.Title = n.Title;
               nc.Body = n.Body;
               noteUpd.add(nc);
            }  
         }
        
         if (noteUpd.size() > 0)
             database.Upsert(noteUpd,false);
 }
    
public void createAttachment() {
        list<Attachment> attachmentUpd = new list<Attachment>();
        list<ID> dIDs = new list<ID>();
        for (Account_Dormant__c d: DormantRecordstoRemove)
            dIDs.add(d.id);
        for (Attachment a: [select id,ParentId,Body,ContentType,IsPartnerShared,Name from attachment where ParentId=:dIDs]) {
            if (allExtntoAccount.containsKey(a.ParentId)) {
               attachment ac = new attachment();
               ac.Parentid = allExtntoAccount.get(a.ParentId);
               ac.Name = a.Name;
               ac.ContentType = a.ContentType;
               //ac.isPartnerShared = a.isPartnerShared;
               ac.Body = a.Body;
               attachmentUpd.add(ac);
            }  
         }
        
         if (attachmentUpd.size() > 0)
             database.Upsert(attachmentUpd,false);
 }  

 
    
public void relinkdeviatedCost() {
        list<deviated_cost__c> dcUpd = new list<deviated_cost__c>();
        for (deviated_cost__c c: [select id,Account_Extension_Name__r.Account__c, Account_Extension_Name__c, Account_Name__c from deviated_cost__c where Account_Extension_Name__c=:allExtntoAccount.keySet()]) {
           // if (allExtntoAccount.containsKey(c.Account_Extension_Name__c)) {
             //   c.Account_Name__c = allExtntoAccount.get(c.Account_Extension_Name__c);
               if (c.Account_Extension_Name__r.Account__c != null) {
                  c.Account_Name__c = c.Account_Extension_Name__r.Account__c;
                  dcUpd.add(c);
                }
           // }  
         }
        
         if (dcUpd.size() > 0)
             database.Upsert(dcUpd,false);
 }  
    
 public void relinkPriceChanges() {
        list<ace_customer_price_changes__c> aPriceUpd = new list<ace_customer_price_changes__c>();
        for (ace_customer_price_changes__c c: [select id,Account_Extension__r.Account__C, Account_Extension__c, Customer__c from ace_customer_price_changes__c where Account_Extension__c=:allExtntoAccount.keySet()]) {
            //if (allExtntoAccount.containsKey(c.Account_Extension__c)) {
              if (c.Account_Extension__r.Account__c != null) {
                 //c.Customer__c = allExtntoAccount.get(c.Account_Extension__c);
                 c.Customer__c = c.Account_Extension__r.Account__c;
                 aPriceUpd.add(c);
               }
            //}  
         }
        
         if (aPriceUpd.size() > 0)
             database.Upsert(aPriceUpd,false);
 }  

public void relinkContact() {
        list<Contact> ContactUpd = new list<Contact>();
        for (Contact c: [select id,Account_Extension_Name__r.Account__c, Account_Extension_Name__c, AccountId from Contact where Account_Extension_Name__c=:allExtntoAccount.keySet()]) {
           // if (allExtntoAccount.containsKey(c.Account_Extension_Name__c)) {
              //  c.AccountId = allExtntoAccount.get(c.Account_Extension_Name__c);
                if (c.Account_Extension_Name__r.Account__c != null) {
                  c.AccountId = c.Account_Extension_Name__r.Account__c;
                  ContactUpd.add(c);
                }
            //}  
         }
        
         if (ContactUpd.size() > 0)
             database.Upsert(ContactUpd,false);
 }    
    
     public void relinkCPM() {
        list<cpm_data__c> cpmDataUpd = new list<cpm_data__c>();
        for (cpm_data__c c: [select id,Account_Extension__r.Account__c, Account_Extension__c, Account_Name__c from cpm_data__c where Account_Extension__c=:allExtntoAccount.keySet()]) {
           // if (allExtntoAccount.containsKey(c.Account_Extension__c)) {
             //   c.Account_Name__c = allExtntoAccount.get(c.Account_Extension__c);
               if (c.Account_Extension__r.Account__c != null) {
                   c.Account_Name__c = c.Account_Extension__r.Account__c;
                   cpmDataUpd.add(c);
                }  
           // }  
         }
        
         if (cpmDataUpd.size() > 0)
             database.Upsert(cpmDataUpd,false);
         
        list<cpm__c> cpmUpd = new list<cpm__c>();
        for (cpm__c c: [select id,Extension_Account_Name__r.Account__c, Extension_Account_Name__c, Account_Name__c from cpm__c where Extension_Account_Name__c=:allExtntoAccount.keySet()]) {
            //if (allExtntoAccount.containsKey(c.Extension_Account_Name__c)) {
              if (c.Extension_Account_Name__r.Account__c != null) {  
                 //c.Account_Name__c = allExtntoAccount.get(c.Extension_Account_Name__c);
                 c.Account_Name__c = c.Extension_Account_Name__r.Account__c;
                 cpmUpd.add(c);
               }
            //}  
         }
        
         if (cpmUpd.size() > 0)
             database.Upsert(cpmUpd,false);
         
         
    } 
    
    public void reLinkDupJunction() {
        list<account_duplicate_junction__c> djUpd = new list<account_duplicate_junction__c>();
        list<ID> dIDs = new list<ID>();
        for (Account_Dormant__c d: DormantRecordstoRemove)
            dIDs.add(d.id);
        for (Account_Duplicate_Junction__c dj : [select id,Account_Dormant_Dup__r.AccountExtension__r.Account__c,Account_Dormant_Dup__c,Account_Extension_Dup__c,Account_Dup__c from Account_Duplicate_junction__c where account_dormant_dup__c = :dIDs]) {
            //if (allExtntoAccount.containsKey(dj.Account_Extension_Dup__c)) {
                //dj.Account_Dup__c = allExtntoAccount.get(dj.Account_Extension_Dup__c);
                if (dj.Account_Dormant_Dup__r.AccountExtension__r.Account__c != null) {
                 dj.Account_Dup__c = dj.Account_Dormant_Dup__r.AccountExtension__r.Account__c;
                 djUpd .add(dj);
                }
            //}
            
        }
        
        database.upsert(djUpd,false);        
    }
    
    public void reLinksiteContact() {
        list<SiteContacts__c> sConUpd = new list<SiteContacts__c>();
        for (SiteContacts__c c : [select id,Account__c,Account_Extension__r.Account__c,Account_Extension__c from SiteContacts__c where Account_Extension__c = :allExtntoAccount.keySet()]) {
            //if (allExtntoAccount.containsKey(c.Account_Extension__c )) {
              if (c.Account_Extension__r.Account__c != null) {
                 //c.Account__c = allExtntoAccount.get(c.Account_Extension__c );
                 c.Account__c = c.Account_Extension__r.Account__c;
                 sConUpd.add(c);
               }
            //}
            
        }
        
        database.upsert(sConUpd ,false);        
    }
    
public void copyAccountProfile() {
       Decimal counter = 0;
       list<Account_Profile__c> acProfileUpds = new list<Account_Profile__c>();
       System.debug('&&&&&insideprofile'+allExtntoAccount.keySet());
for(Account_Profile__c o: [select Id, IsDeleted, Name, RecordTypeId, CreatedDate, CreatedById, LastModifiedDate, LastModifiedById, SystemModstamp, LastActivityDate, ConnectionReceivedId, ConnectionSentId, Account__c, Account_Owner__c, CustID__c, Profile_Unique_Name__c, Copier_Fleet_Expiration_Date__c, Copiers__c, Printers__c, Test_Account_Number_EDI__c, Ship_To_EDI__c, GPO_EDI__c, Tier_1_Partner_EDI__c, X3rd_Party_EDI__c, Additional_3rd_Party_EDI__c, cXML_Version_EDI__c, xCBL_Version_EDI__c, Integration_Type_EDI__c, Integration_Status_EDI__c, EI_Type_EDI__c, Customer_Platform_EDI__c, EDI_Communication_Method_EDI__c, EDI_Version_EDI__c, EDI_VAN_EDI__c, Plug_Play_EDI__c, SSL_Certificates_Used_EDI__c, eCommerce_Analyst_EDI__c, eCommerce_Consultant_EDI__c, Implementation_Manager_EDI__c, Custom_Catalog_EDI__c, Catalog_Type_EDI__c, Punchout_Type_EDI__c, User_Level_EDI__c, Custom_Punchout_Map_EDI__c, CPD_Punchout_Enabled_EDI__c, Custom_Shopping_Cart_Map_EDI__c, Invoice_Type_EDI__c, Invoice_Frequency_EDI__c, Invoice_Rejection_Type_EDI__c, Invoice_Go_Live_Date_EDI__c, Custom_Invoice_Map_EDI__c, Soft_Header_Fields_EDI__c, Line_Level_Fields_EDI__c, PO_Type_EDI__c, PO_Go_Live_Date_EDI__c, MOV_EDI__c, Custom_PO_Map_EDI__c, PO_Ack_997_Required_EDI__c, Ship_Notice_Type_EDI__c, Ship_Notice_URL_EDI__c, ASN_Go_Live_Date_EDI__c, Custom_ASN_Map_EDI__c, POR_Type_EDI__c, POR_Go_Live_Date_EDI__c, Custom_POR_Map__c, Analyst_Comments_EDI__c, Consultant_Comments__c, PIDz__c, ParentPID__c, District_Name__c, AOPS_SEQ_ID__c, ProfileURL__c, Contract_Expiration_Date__c, Anticipated_RFP_Date__c, Anticipated_Decision_Date__c, Anticipated_Implementation_Date__c, Strategic_Focus_Plan_1__c, Strategic_Focus_Plan_2__c, Strategic_Focus_Plan_3__c, Strategic_Focus_Plan_4__c, Current_Supplier__c, Contract_Extension_Terms__c, Last_12mo_Purchase__c, Prinname__c, Prinjob__c, Open__c, International_Opportunities__c, BOT_Leverage__c, Global_Leverage__c, International_Existing__c, Business_Type_EDI__c, Tax_Exempt_EDI__c, Parent_Profile__c, FileType__c, Phone__c, IT_Budget__c, Cloud_Providers__c, Enrollment__c, NumSchools__c, NAMESUPT__c, LowGrade__c, HighGrade__c, NamePrincipal__c, PO__c, Close__c, Charter__c, Cost_Center__c, DistenRollup__c, Current_Service_Provider__c, Services_Currently_delivered__c, Details_for_install_removal_of_devices__c, Top_IT_Issue_1__c, Top_IT_Issue_2__c, Top_IT_Issue_3__c, Desktop__c, Release__c, PO_Cross_Reference__c, PO_Notes__c, Invoice_Cross_Reference__c, Invoice_Notes__c, Prod_Invoice_URL__c, Test_Invoice_URL__c, POR_Cross_Reference__c, Order_Confirmation_Notes__c, Prod_Order_Confirmation__c, Test_Order_Confirmation__c, ASN_Cross_Reference__c, ASN_Notes__c, Test_Ship_Notice_URL__c, Line_Level_Cost_Center__c, Line_Item_Comments__c, eCommerce_Analyst_EDI_L__c, eCommerce_Consultant_EDI_L__c, Number_of_Beds__c, GPO_Company__c, GPO_Relationship__c, Parent_Company_Name__c, ACO__c, DNB_Propensity_Score__c, DNB_Propensity_Segment__c, DNB_Dollar_Amount__c, DNB_Dollar_Deciles_Overall__c, Account_Owner_Manager_lvl_3__c, Address_State__c, Country_Code__c, Expiration_Date__c, Tax_Status__c, Certification_Expired_Rating__c, Account_Owner_Manager_Lvl_2__c, Account_Owner_Manager__c, Days_Until_Tax_Cert_Expires__c, Tax_Day_Exp_Date__c, Tax_Day__c, Tax_Email_Required__c, WF_Fired__c, MDR_CMO__c, MDR_Link__c, MDR_Parent__c,Deployment_Type__c, Account_Profile_Extension_Account__c, Classification__c,  Resource_Type__c, Account_Customer_ID__c, Owner_Manager_Lvl_2__c, Owner_Manager__c, Account_Owner_Short_Title__c FROM Account_Profile__c where Account_Profile_Extension_Account__c=:allExtntoAccount.keySet() ]) 
{
    
    Account_Profile__c ap = new Account_Profile__c();
            
ap.Name=o.Name;
ap.RecordTypeId=o.RecordTypeId;
ap.CreatedDate=o.CreatedDate;
ap.CreatedById=o.CreatedById;
ap.LastModifiedDate=o.LastModifiedDate;
ap.LastModifiedById=o.LastModifiedById;
ap.Account__c=allExtntoAccount.get(o.Account_Profile_Extension_Account__c);
ap.Account_Owner__c=o.Account_Owner__c;
ap.Profile_Unique_Name__c=o.Profile_Unique_Name__c + counter;
ap.Copier_Fleet_Expiration_Date__c=o.Copier_Fleet_Expiration_Date__c;
ap.Copiers__c=o.Copiers__c;
ap.Printers__c=o.Printers__c;
ap.Test_Account_Number_EDI__c=o.Test_Account_Number_EDI__c;
ap.Ship_To_EDI__c=o.Ship_To_EDI__c;
ap.GPO_EDI__c=o.GPO_EDI__c;
ap.Tier_1_Partner_EDI__c=o.Tier_1_Partner_EDI__c;
ap.X3rd_Party_EDI__c=o.X3rd_Party_EDI__c;
ap.Additional_3rd_Party_EDI__c=o.Additional_3rd_Party_EDI__c;
ap.cXML_Version_EDI__c=o.cXML_Version_EDI__c;
ap.xCBL_Version_EDI__c=o.xCBL_Version_EDI__c;
ap.Integration_Type_EDI__c=o.Integration_Type_EDI__c;
ap.Integration_Status_EDI__c=o.Integration_Status_EDI__c;
ap.EI_Type_EDI__c=o.EI_Type_EDI__c;
ap.Customer_Platform_EDI__c=o.Customer_Platform_EDI__c;
ap.EDI_Communication_Method_EDI__c=o.EDI_Communication_Method_EDI__c;
ap.EDI_Version_EDI__c=o.EDI_Version_EDI__c;
ap.EDI_VAN_EDI__c=o.EDI_VAN_EDI__c;
ap.Plug_Play_EDI__c=o.Plug_Play_EDI__c;
ap.SSL_Certificates_Used_EDI__c=o.SSL_Certificates_Used_EDI__c;
ap.eCommerce_Analyst_EDI__c=o.eCommerce_Analyst_EDI__c;
ap.eCommerce_Consultant_EDI__c=o.eCommerce_Consultant_EDI__c;
ap.Implementation_Manager_EDI__c=o.Implementation_Manager_EDI__c;
ap.Custom_Catalog_EDI__c=o.Custom_Catalog_EDI__c;
ap.Catalog_Type_EDI__c=o.Catalog_Type_EDI__c;
ap.Punchout_Type_EDI__c=o.Punchout_Type_EDI__c;
ap.User_Level_EDI__c=o.User_Level_EDI__c;
ap.Custom_Punchout_Map_EDI__c=o.Custom_Punchout_Map_EDI__c;
ap.CPD_Punchout_Enabled_EDI__c=o.CPD_Punchout_Enabled_EDI__c;
ap.Custom_Shopping_Cart_Map_EDI__c=o.Custom_Shopping_Cart_Map_EDI__c;
ap.Invoice_Type_EDI__c=o.Invoice_Type_EDI__c;
ap.Invoice_Frequency_EDI__c=o.Invoice_Frequency_EDI__c;
ap.Invoice_Rejection_Type_EDI__c=o.Invoice_Rejection_Type_EDI__c;
ap.Invoice_Go_Live_Date_EDI__c=o.Invoice_Go_Live_Date_EDI__c;
ap.Custom_Invoice_Map_EDI__c=o.Custom_Invoice_Map_EDI__c;
ap.Soft_Header_Fields_EDI__c=o.Soft_Header_Fields_EDI__c;
ap.Line_Level_Fields_EDI__c=o.Line_Level_Fields_EDI__c;
ap.PO_Type_EDI__c=o.PO_Type_EDI__c;
ap.PO_Go_Live_Date_EDI__c=o.PO_Go_Live_Date_EDI__c;
ap.MOV_EDI__c=o.MOV_EDI__c;
ap.Custom_PO_Map_EDI__c=o.Custom_PO_Map_EDI__c;
ap.PO_Ack_997_Required_EDI__c=o.PO_Ack_997_Required_EDI__c;
ap.Ship_Notice_Type_EDI__c=o.Ship_Notice_Type_EDI__c;
ap.Ship_Notice_URL_EDI__c=o.Ship_Notice_URL_EDI__c;
ap.ASN_Go_Live_Date_EDI__c=o.ASN_Go_Live_Date_EDI__c;
ap.Custom_ASN_Map_EDI__c=o.Custom_ASN_Map_EDI__c;
ap.POR_Type_EDI__c=o.POR_Type_EDI__c;
ap.POR_Go_Live_Date_EDI__c=o.POR_Go_Live_Date_EDI__c;
ap.Custom_POR_Map__c=o.Custom_POR_Map__c;
ap.Analyst_Comments_EDI__c=o.Analyst_Comments_EDI__c;
ap.Consultant_Comments__c=o.Consultant_Comments__c;
ap.PIDz__c=o.PIDz__c;
ap.ParentPID__c=o.ParentPID__c;
ap.District_Name__c=o.District_Name__c;
ap.Account_Profile_Extension_Account__c = o.Account_Profile_Extension_Account__c;
ap.ProfileURL__c=o.ProfileURL__c;
ap.Contract_Expiration_Date__c=o.Contract_Expiration_Date__c;
ap.Anticipated_RFP_Date__c=o.Anticipated_RFP_Date__c;
ap.Anticipated_Decision_Date__c=o.Anticipated_Decision_Date__c;
ap.Anticipated_Implementation_Date__c=o.Anticipated_Implementation_Date__c;
ap.Strategic_Focus_Plan_1__c=o.Strategic_Focus_Plan_1__c;
ap.Strategic_Focus_Plan_2__c=o.Strategic_Focus_Plan_2__c;
ap.Strategic_Focus_Plan_3__c=o.Strategic_Focus_Plan_3__c;
ap.Strategic_Focus_Plan_4__c=o.Strategic_Focus_Plan_4__c;
ap.Current_Supplier__c=o.Current_Supplier__c;
ap.Contract_Extension_Terms__c=o.Contract_Extension_Terms__c;
ap.Last_12mo_Purchase__c=o.Last_12mo_Purchase__c;
ap.Prinname__c=o.Prinname__c;
ap.Prinjob__c=o.Prinjob__c;
ap.Open__c=o.Open__c;
ap.International_Opportunities__c=o.International_Opportunities__c;
ap.BOT_Leverage__c=o.BOT_Leverage__c;
ap.Global_Leverage__c=o.Global_Leverage__c;
ap.International_Existing__c=o.International_Existing__c;
ap.Business_Type_EDI__c=o.Business_Type_EDI__c;
ap.Tax_Exempt_EDI__c=o.Tax_Exempt_EDI__c;
ap.Parent_Profile__c=o.Parent_Profile__c;
ap.FileType__c=o.FileType__c;
ap.Phone__c=o.Phone__c;
ap.IT_Budget__c=o.IT_Budget__c;
ap.Cloud_Providers__c=o.Cloud_Providers__c;
ap.Enrollment__c=o.Enrollment__c;
ap.NumSchools__c=o.NumSchools__c;
ap.NAMESUPT__c=o.NAMESUPT__c;
ap.LowGrade__c=o.LowGrade__c;
ap.HighGrade__c=o.HighGrade__c;
ap.NamePrincipal__c=o.NamePrincipal__c;
ap.PO__c=o.PO__c;
ap.Close__c=o.Close__c;
ap.Charter__c=o.Charter__c;
ap.Cost_Center__c=o.Cost_Center__c;
ap.DistenRollup__c=o.DistenRollup__c;
ap.Current_Service_Provider__c=o.Current_Service_Provider__c;
ap.Services_Currently_delivered__c=o.Services_Currently_delivered__c;
ap.Details_for_install_removal_of_devices__c=o.Details_for_install_removal_of_devices__c;
ap.Top_IT_Issue_1__c=o.Top_IT_Issue_1__c;
ap.Top_IT_Issue_2__c=o.Top_IT_Issue_2__c;
ap.Top_IT_Issue_3__c=o.Top_IT_Issue_3__c;
ap.Desktop__c=o.Desktop__c;
ap.Release__c=o.Release__c;
ap.PO_Cross_Reference__c=o.PO_Cross_Reference__c;
ap.PO_Notes__c=o.PO_Notes__c;
ap.Invoice_Cross_Reference__c=o.Invoice_Cross_Reference__c;
ap.Invoice_Notes__c=o.Invoice_Notes__c;
ap.Prod_Invoice_URL__c=o.Prod_Invoice_URL__c;
ap.Test_Invoice_URL__c=o.Test_Invoice_URL__c;
ap.POR_Cross_Reference__c=o.POR_Cross_Reference__c;
ap.Order_Confirmation_Notes__c=o.Order_Confirmation_Notes__c;
ap.Prod_Order_Confirmation__c=o.Prod_Order_Confirmation__c;
ap.Test_Order_Confirmation__c=o.Test_Order_Confirmation__c;
ap.ASN_Cross_Reference__c=o.ASN_Cross_Reference__c;
ap.ASN_Notes__c=o.ASN_Notes__c;
ap.Test_Ship_Notice_URL__c=o.Test_Ship_Notice_URL__c;
ap.Line_Level_Cost_Center__c=o.Line_Level_Cost_Center__c;
ap.Line_Item_Comments__c=o.Line_Item_Comments__c;
ap.eCommerce_Analyst_EDI_L__c=o.eCommerce_Analyst_EDI_L__c;
ap.eCommerce_Consultant_EDI_L__c=o.eCommerce_Consultant_EDI_L__c;
ap.Number_of_Beds__c=o.Number_of_Beds__c;
ap.GPO_Company__c=o.GPO_Company__c;
ap.GPO_Relationship__c=o.GPO_Relationship__c;
ap.Parent_Company_Name__c=o.Parent_Company_Name__c;
ap.ACO__c=o.ACO__c;
ap.DNB_Propensity_Score__c=o.DNB_Propensity_Score__c;
ap.DNB_Propensity_Segment__c=o.DNB_Propensity_Segment__c;
ap.DNB_Dollar_Amount__c=o.DNB_Dollar_Amount__c;
ap.DNB_Dollar_Deciles_Overall__c=o.DNB_Dollar_Deciles_Overall__c;
ap.Address_State__c=o.Address_State__c;
ap.Country_Code__c=o.Country_Code__c;
ap.Expiration_Date__c=o.Expiration_Date__c;
ap.Tax_Status__c=o.Tax_Status__c;
ap.Account_Owner_Manager_Lvl_2__c=o.Account_Owner_Manager_Lvl_2__c;
ap.Account_Owner_Manager__c=o.Account_Owner_Manager__c;
ap.Tax_Email_Required__c=o.Tax_Email_Required__c;
ap.WF_Fired__c=o.WF_Fired__c;
ap.MDR_Link__c=o.MDR_Link__c;
//ap.Segment__c=o.Segment__c;
ap.Deployment_Type__c=o.Deployment_Type__c;
ap.Account_Profile_Extension_Account__c=o.Account_Profile_Extension_Account__c;
ap.Classification__c=o.Classification__c;
ap.Resource_Type__c=o.Resource_Type__c;
    
            acProfileUpds.add(ap);
            counter++;
}
        database.upsert(acProfileUpds,false);
    }
    

    
public Account createAcctRecord(Account_Extension__c e,String reason, String Comments) {
                  Account a = new Account();
           A.Account_Legal_Name__c=E.Account_Legal_Name__c;
           A.Account_level_email_permission_flag__c=E.Account_level_email_permission_flag__c;
A.Account_Page_Source__c=E.Account_Page_Source__c;
A.Account_Setup_Request_Status__c=E.Account_Setup_Request_Status__c;
A.Pot_Disposition_Reason__c = reason;
A.Pot_Other_Disposition_Reason__c = comments;
A.Account_Type__c=E.Account_Type__c;
//A.Acct_Hqtrs__c=E.Acct_Hqtrs__c;
A.Address_Key__c=E.Address_Key__c;
A.Address_Validated__c=E.Address_Validated__c;
A.Address_Validation_Error__c=E.Address_Validation_Error__c;
A.Address1__c=E.Address1__c;
A.Address2__c=E.Address2__c;
A.ADS_Current_Month__c=E.ADS_Current_Month__c;
A.ADS_Current_Qtr__c=E.ADS_Current_Qtr__c;
A.ADS_Current_Yr__c=E.ADS_Current_Yr__c;
A.ADS_Last_Month__c=E.ADS_Last_Month__c;
A.ADS_Last_Qtr__c=E.ADS_Last_Qtr__c;
A.ADS_Last_Yr__c=E.ADS_Last_Yr__c;
A.AOPS_Cust_Id__c=E.AOPS_Cust_Id__c;
A.AOPS_Seq_ID__c=E.AOPS_Seq_ID__c;
A.AOV_Current_Month__c=E.AOV_Current_Month__c;
A.AOV_Current_Qtr__c=E.AOV_Current_Qtr__c;
A.AOV_Current_Yr__c=E.AOV_Current_Yr__c;
A.AOV_Last_Month__c=E.AOV_Last_Month__c;
A.AOV_Last_Qtr__c=E.AOV_Last_Qtr__c;
A.AOV_Last_Yr__c=E.AOV_Last_Yr__c;
A.Assign_Specific_Owner__c=E.Assign_Specific_Owner__c;
A.Auto_Assign__c=E.Auto_Assign__c;
//A.Back_to_School__c=E.Back_to_School__c;
//A.Business_Usage_Type__c=E.Business_Usage_Type__c;
A.Buying_Account__c=E.Buying_Account__c;
A.Buying_Group__c=E.Buying_Group__c;
A.Cadence_Call_Date__c=E.Cadence_Call_Date__c;
A.Cadence_Call_Date_Override__c=E.Cadence_Call_Date_Override__c;
A.Cadence_Call_Date_Override_Value__c=E.Cadence_Call_Date_Override_Value__c;
//A.Campaign__c=E.Campaign__c;
A.CBS_IMU_LY__c=E.CBS_IMU_LY__c;
A.CBS_IMU_TY__c=E.CBS_IMU_TY__c;
A.CBS_Last_Order__c=E.CBS_Last_Order__c;
A.CBS_Last_order_amt__c=E.CBS_Last_order_amt__c;
A.CBS_LY__c=E.CBS_LY__c;
A.CBS_Pot__c=E.CBS_Pot__c;
A.CBS_Total_LY__c=E.CBS_Total_LY__c;
A.CBS_TY__c=E.CBS_TY__c;
A.City__c=E.City__c;
//A.Click_Tools_Qual_Survey__c=E.Click_Tools_Qual_Survey__c;
A.Consolidated_DUNS_ID__c=E.Consolidated_DUNS_ID__c;
A.Contract_Furniture_IMU_LY__c=E.Contract_Furniture_IMU_LY__c;
A.Contract_Furniture_IMU_TY__c=E.Contract_Furniture_IMU_TY__c;
A.Contract_Furniture_Last_Order__c=E.Contract_Furniture_Last_Order__c;
A.Contract_Furniture_Last_Order_amt__c=E.Contract_Furniture_Last_Order_amt__c;
A.Contract_Furniture_LY__c=E.Contract_Furniture_LY__c;
A.Contract_Furniture_TY__c=E.Contract_Furniture_TY__c;
A.CONTRACT_RETAIL_CUST_CODE__c=E.CONTRACT_RETAIL_CUST_CODE__c;
A.Copier_Fleet_Expiration_Date__c=E.Copier_Fleet_Expiration_Date__c;
A.Copiers__c=E.Copiers__c;
A.Cost_Centre_Dept__c=E.Cost_Centre_Dept__c;
A.Country__c=E.Country__c;
A.County__c=E.County__c;
A.Coupon_flag__c=E.Coupon_flag__c;
A.CPD_IMU_LY__c=E.CPD_IMU_LY__c;
A.CPD_IMU_TY__c=E.CPD_IMU_TY__c;
A.CPD_Last_Order__c=E.CPD_Last_Order__c;
A.CPD_Last_order_amt__c=E.CPD_Last_order_amt__c;
A.CPD_LY__c=E.CPD_LY__c;
A.CPD_Pot__c=E.CPD_Pot__c;
A.CPD_Total_LY__c=E.CPD_Total_LY__c;
A.CPD_TY__c=E.CPD_TY__c;
A.Customer_Lifecycle__c=E.Customer_Lifecycle__c;
A.Customer_Setup_Completed__c=E.Customer_Setup_Completed__c;
A.Customer_Setup_Requested__c=E.Customer_Setup_Requested__c;
A.Customer_Source__c=E.Customer_Source__c;
A.Deliver_Charge__c=E.Deliver_Charge__c;
A.Delivery__c=E.Delivery__c;
//A.Disposition__c=E.Disposition__c;
A.Duns_Number__c=E.Duns_Number__c;
A.Duplicate_Disposition__c=E.Duplicate_Disposition__c;
A.EIN__c=E.EIN__c;
//A.Enrichment__c=E.Enrichment__c;
A.Est_Spend__c=E.Est_Spend__c;
A.Est_Spend_CAD__c=E.Est_Spend_CAD__c;
A.Existing_OMax_Account__c=E.Existing_OMax_Account__c;
A.Failed_Reason__c=E.Failed_Reason__c;
A.Filing_Binding_IMU_LY__c=E.Filing_Binding_IMU_LY__c;
A.Filing_Binding_IMU_TY__c=E.Filing_Binding_IMU_TY__c;
A.Filing_Binding_Last_Order__c=E.Filing_Binding_Last_Order__c;
A.Filing_Binding_Last_Order_amt__c=E.Filing_Binding_Last_Order_amt__c;
A.Filing_Binding_LY__c=E.Filing_Binding_LY__c;
A.Filing_Binding_Pot__c=E.Filing_Binding_Pot__c;
A.Filing_Binding_Total_LY__c=E.Filing_Binding_Total_LY__c;
A.Filing_Binding_TY__c=E.Filing_Binding_TY__c;
A.First_Order_Date__c=E.First_Order_Date__c;
A.Follow_Up_Note__c=E.Follow_Up_Note__c;
A.Freight_Charge__c=E.Freight_Charge__c;
A.Fuel_Surcharge__c=E.Fuel_Surcharge__c;
A.Furniture_IMU_LY__c=E.Furniture_IMU_LY__c;
A.Furniture_IMU_TY__c=E.Furniture_IMU_TY__c;
A.Furniture_Last_Order__c=E.Furniture_Last_Order__c;
A.Furniture_last_order_amt__c=E.Furniture_last_order_amt__c;
A.Furniture_LY__c=E.Furniture_LY__c;
A.Furniture_Pot__c=E.Furniture_Pot__c;
A.Furniture_Total_LY__c=E.Furniture_Total_LY__c;
A.Furniture_TY__c=E.Furniture_TY__c;
//A.GGPId__c=E.GGPId__c;
A.GP_Id__c=E.GP_Id__c;
A.GParent_GPID__c=E.GParent_GPID__c;
A.Grand_Siloe__c=E.Grand_Siloe__c;
//A.Grandparent_Type__c=E.Grandparent_Type__c;
A.GT_Account_Type__c=E.GT_Account_Type__c;
A.GT_Description__c=E.GT_Description__c;
A.GT_Max_Perks_Eligible__c=E.GT_Max_Perks_Eligible__c;
A.GT_Max_Perks_Enrolled__c=E.GT_Max_Perks_Enrolled__c;
A.GT_Max_Perks_Enrolled_Date__c=E.GT_Max_Perks_Enrolled_Date__c;
A.GT_Segment__c=E.GT_Segment__c;
A.Header_Record_Access__c=E.Header_Record_Access__c;
A.Hide__c=E.Hide__c;
A.Hierarchy__c=E.Hierarchy__c;
A.Hosted_Catalog_Flag__c=E.Hosted_Catalog_Flag__c;
A.Implementation_Manager__c=E.Implementation_Manager__c;
A.Industry_OD_SIC_DB__c=E.Industry_OD_SIC_DB__c;
A.Industry_OD_SIC_Rep__c=E.Industry_OD_SIC_Rep__c;
A.Initial_Site_Flag__c=E.Initial_Site_Flag__c;
A.Ink_Toner_IMU_LY__c=E.Ink_Toner_IMU_LY__c;
A.Ink_Toner_IMU_TY__c=E.Ink_Toner_IMU_TY__c;
A.Ink_Toner_Last_Order__c=E.Ink_Toner_Last_Order__c;
A.Ink_Toner_Last_Order_amt__c=E.Ink_Toner_Last_Order_amt__c;
A.Ink_Toner_LY__c=E.Ink_Toner_LY__c;
A.Ink_Toner_Pot__c=E.Ink_Toner_Pot__c;
A.Ink_Toner_Total_LY__c=E.Ink_Toner_Total_LY__c;
A.Ink_Toner_TY__c=E.Ink_Toner_TY__c;
A.Labels_Forms_IMU_LY__c=E.Labels_Forms_IMU_LY__c;
A.Labels_Forms_IMU_TY__c=E.Labels_Forms_IMU_TY__c;
A.Labels_Forms_Last_Order__c=E.Labels_Forms_Last_Order__c;
A.Labels_Forms_Last_Order_amt__c=E.Labels_Forms_Last_Order_amt__c;
A.Labels_Forms_LY__c=E.Labels_Forms_LY__c;
A.Labels_Forms_Pot__c=E.Labels_Forms_Pot__c;
A.Labels_Forms_Total_LY__c=E.Labels_Forms_Total_LY__c;
A.Labels_Forms_TY__c=E.Labels_Forms_TY__c;
A.Last_Order_Date__c=E.Last_Order_Date__c;
A.Legacy_CreatedBy__c=E.Legacy_CreatedBy__c;
A.Legacy_CreatedDate__c=E.Legacy_CreatedDate__c;
A.Legacy_LastModifiedBy__c=E.Legacy_LastModifiedBy__c;
A.Legacy_LastModifiedDate__c=E.Legacy_LastModifiedDate__c;
A.Legal_Flag__c=E.Legal_Flag__c;
A.Location_Type__c=E.Location_Type__c;
A.Loyalty_Type__c=E.Loyalty_Type__c;
A.Max_Order_Limit__c=E.Max_Order_Limit__c;
A.Min_Order_Charge__c=E.Min_Order_Charge__c;
A.Minimum_Discount__c=E.Minimum_Discount__c;
A.Miscellaneous_IMU_LY__c=E.Miscellaneous_IMU_LY__c;
A.Miscellaneous_IMU_TY__c=E.Miscellaneous_IMU_TY__c;
A.Miscellaneous_Last_Order__c=E.Miscellaneous_Last_Order__c;
A.Miscellaneous_Last_Order_amt__c=E.Miscellaneous_Last_Order_amt__c;
A.Miscellaneous_LY__c=E.Miscellaneous_LY__c;
A.Miscellaneous_Pot__c=E.Miscellaneous_Pot__c;
A.Miscellaneous_Total_LY__c=E.Miscellaneous_Total_LY__c;
A.Miscellaneous_TY__c=E.Miscellaneous_TY__c;
A.Mod_5_EBS_Sync_Error__c=E.Mod_5_EBS_Sync_Error__c;
A.Mod_5_EBS_Sync_Status__c=E.Mod_5_EBS_Sync_Status__c;
A.Modified_Price_Value__c=E.Modified_Price_Value__c;
A.Monthly_LY__c=E.Monthly_LY__c;
A.Monthly_LY_IMU__c=E.Monthly_LY_IMU__c;
A.Monthly_Sales__c=E.Monthly_Sales__c;
A.MPS_IMU_LY__c=E.MPS_IMU_LY__c;
A.MPS_IMU_TY__c=E.MPS_IMU_TY__c;
A.MPS_Last_Order__c=E.MPS_Last_Order__c;
A.MPS_Last_order_amt__c=E.MPS_Last_order_amt__c;
A.MPS_LY__c=E.MPS_LY__c;
A.MPS_Pot__c=E.MPS_Pot__c;
A.MPS_Total_LY__c=E.MPS_Total_LY__c;
A.MPS_TY__c=E.MPS_TY__c;
A.MTD_Sales_LY__c=E.MTD_Sales_LY__c;
A.MTD_Sales_LY_IMU__c=E.MTD_Sales_LY_IMU__c;
A.MTD_Sales_TY__c=E.MTD_Sales_TY__c;
A.MTD_Sales_TY_IMU__c=E.MTD_Sales_TY_IMU__c;
A.Num_of_Categories__c=E.Num_of_Categories__c;
A.Num_of_Orders_Since_Start__c=E.Num_of_Orders_Since_Start__c;
A.Number_of_Categories_Check__c=E.Number_of_Categories_Check__c;
A.Number_of_Orders__c=E.Number_of_Orders__c;
A.Number_of_Orders_Check__c=E.Number_of_Orders_Check__c;
A.Off_Contract_Percent__c=E.Off_Contract_Percent__c;
A.Off_Contract_Price_Code__c=E.Off_Contract_Price_Code__c;
A.Office_Essentials_IMU_LY__c=E.Office_Essentials_IMU_LY__c;
A.Office_Essentials_IMU_TY__c=E.Office_Essentials_IMU_TY__c;
A.Office_Essentials_Last_Order__c=E.Office_Essentials_Last_Order__c;
A.Office_Essentials_Last_Order_amt__c=E.Office_Essentials_Last_Order_amt__c;
A.Office_Essentials_LY__c=E.Office_Essentials_LY__c;
A.Office_Essentials_Pot__c=E.Office_Essentials_Pot__c;
A.Office_Essentials_Total_LY__c=E.Office_Essentials_Total_LY__c;
A.Office_Essentials_TY__c=E.Office_Essentials_TY__c;
A.OMX_Account__c=E.OMX_Account__c;
A.OMX_Do_Not_Call__c=E.OMX_Do_Not_Call__c;
A.OMX_GPO__c=E.OMX_GPO__c;
A.OMX_Mainframe_Account_Level__c=E.OMX_Mainframe_Account_Level__c;
A.OMX_Mainframe_Account_Number__c=E.OMX_Mainframe_Account_Number__c;
A.OMX_Mainframe_Consignee_ID__c=E.OMX_Mainframe_Consignee_ID__c;
A.OMX_Mainframe_National_Acct_Number__c=E.OMX_Mainframe_National_Acct_Number__c;
A.OMX_Mainframe_Owning_Rep_Number__c=E.OMX_Mainframe_Owning_Rep_Number__c;
A.OMX_Primary_Key__c=E.OMX_Primary_Key__c;
A.OMX_Tier_1_Type__c=E.OMX_Tier_1_Type__c;
A.OMXIsUpdated__c=E.OMXIsUpdated__c;
A.Opportunity_Amt__c=E.Opportunity_Amt__c;
A.Opt_Date__c=E.Opt_Date__c;
A.Oracle_Party_ID__c=E.Oracle_Party_ID__c;
A.Oracle_Party_Number__c=E.Oracle_Party_Number__c;
A.Oracle_Party_Site_ID__c=E.Oracle_Party_Site_ID__c;
A.Oracle_Party_Site_Number__c=E.Oracle_Party_Site_Number__c;
A.Orders_Current_Month__c=E.Orders_Current_Month__c;
A.Orders_Current_Qtr__c=E.Orders_Current_Qtr__c;
A.Orders_Current_Yr__c=E.Orders_Current_Yr__c;
A.Orders_Last_Month__c=E.Orders_Last_Month__c;
A.Orders_Last_Qtr__c=E.Orders_Last_Qtr__c;
A.Orders_Last_Yr__c=E.Orders_Last_Yr__c;
A.Org_Number_of_Locations__c=E.Org_Number_of_Locations__c;
A.Org_WCW_Count_DB__c=E.Org_WCW_Count_DB__c;
A.Org_WCW_Count_Rep__c=E.Org_WCW_Count_Rep__c;
A.Original_System__c=E.Original_System__c;
A.Paper_IMU_LY__c=E.Paper_IMU_LY__c;
A.Paper_IMU_TY__c=E.Paper_IMU_TY__c;
A.Paper_Last_Order__c=E.Paper_Last_Order__c;
A.Paper_Last_Order_amt__c=E.Paper_Last_Order_amt__c;
A.Paper_LY__c=E.Paper_LY__c;
A.Paper_Pot__c=E.Paper_Pot__c;
A.Paper_Total_LY__c=E.Paper_Total_LY__c;
A.Paper_TY__c=E.Paper_TY__c;
A.Payment_Term__c=E.Payment_Term__c;
A.Phone_Ext__c=E.Phone_Ext__c;
A.Pot_Disposition__c=E.Pot_Disposition__c;
A.Potential_Amount__c=E.Potential_Amount__c;
A.Potential_DeDuplicate__c=E.Potential_DeDuplicate__c;
A.Potential_Duplicate__c=E.Potential_Duplicate__c;
A.Potential_Duplicate_of_ID__c=E.Potential_Duplicate_of_ID__c;
A.Potential_Printers__c=E.Potential_Printers__c;
A.Predictive_Purchase__c=E.Predictive_Purchase__c;
A.Previous_Owner_ID__c=E.Previous_Owner_ID__c;
A.Price_As__c=E.Price_As__c;
A.Pricing_Flip_Effective_Date__c=E.Pricing_Flip_Effective_Date__c;
A.Pricing_template_cd__c=E.Pricing_template_cd__c;
A.Primary_BillTo__c=E.Primary_BillTo__c;
A.Primary_Competitor__c=E.Primary_Competitor__c;
A.Primary_Product__c=E.Primary_Product__c;
A.Primary_Site__c=E.Primary_Site__c;
A.Primary_Site_ID__c=E.Primary_Site_ID__c;
A.Processing__c=E.Processing__c;
A.Prospect_Creation_Failure__c=E.Prospect_Creation_Failure__c;
A.QTD_Sales_LY__c=E.QTD_Sales_LY__c;
A.QTD_Sales_LY_IMU__c=E.QTD_Sales_LY_IMU__c;
A.QTD_Sales_TY__c=E.QTD_Sales_TY__c;
A.QTD_Sales_TY_IMU__c=E.QTD_Sales_TY_IMU__c;
A.Quarter_LY__c=E.Quarter_LY__c;
A.Quarter_LY_IMU__c=E.Quarter_LY_IMU__c;
A.Ranking__c=E.Ranking__c;
A.Recurring_Request_Enabled__c=E.Recurring_Request_Enabled__c;
A.Related_Parent_Account__c=E.Related_Parent_Account__c;
A.Remediation_Required__c=E.Remediation_Required__c;
A.Rep_Call_Date__c=E.Rep_Call_Date__c;
A.Request_Account_Billing__c=E.Request_Account_Billing__c;
A.Revenue_Band__c=E.Revenue_Band__c;
A.Rolling_12_month_sales__c=E.Rolling_12_month_sales__c;
A.Rolling_3_month_sales__c=E.Rolling_3_month_sales__c;
A.Rolling_6_month_sales__c=E.Rolling_6_month_sales__c;
A.Rolling_9_month_sales__c=E.Rolling_9_month_sales__c;
A.RSD_User__c=E.RSD_User__c;
A.Sales__c=E.Sales__c;
A.Sales_Check__c=E.Sales_Check__c;
A.Sales_PersonID__c=E.Sales_PersonID__c;
A.Sector__c=E.Sector__c;
A.Segment__c=E.Segment__c;
A.Setup_URL1__c=E.Setup_URL1__c;
A.SIC_Description_FR__c=E.SIC_Description_FR__c;
A.Silo__c=E.Silo__c;
A.Site_Contact2__c=E.Site_Contact2__c;
A.Site_Contact3__c=E.Site_Contact3__c;
A.Site_Contact4__c=E.Site_Contact4__c;
A.Site_Contact5__c=E.Site_Contact5__c;
A.Site_Contact6__c=E.Site_Contact6__c;
A.Site_Primary_Contact__c=E.Site_Primary_Contact__c;
A.Source_System__c=E.Source_System__c;
A.Source_System_that_has_the_latest_opt_de__c=E.Source_System_that_has_the_latest_opt_de__c;
A.Split_Flag__c=E.Split_Flag__c;
A.Split_Record__c=E.Split_Record__c;
A.Stage__c=E.Stage__c;
A.State__c=E.State__c;
A.Status__c=E.Status__c;
A.Tax_Exempt__c=E.Tax_Exempt__c;
A.Tech_IMU_LY__c=E.Tech_IMU_LY__c;
A.Tech_IMU_TY__c=E.Tech_IMU_TY__c;
A.Tech_Last_Order__c=E.Tech_Last_Order__c;
A.Tech_Last_Order_amt__c=E.Tech_Last_Order_amt__c;
A.Tech_LY__c=E.Tech_LY__c;
A.Tech_Pot__c=E.Tech_Pot__c;
A.Tech_Total_LY__c=E.Tech_Total_LY__c;
A.Tech_TY__c=E.Tech_TY__c;
A.Tier_1_Partner__c=E.Tier_1_Partner__c;
A.Total_Order__c=E.Total_Order__c;
A.Transition_Calender_Date__c=E.Transition_Calender_Date__c;
A.Transition_Customer__c=E.Transition_Customer__c;
A.Ultimate_Duns_Number__c=E.Ultimate_Duns_Number__c;
A.Verticals__c=E.Verticals__c;
A.Weekly_Sales__c=E.Weekly_Sales__c;
A.Weeks_Since_1st_Order__c=E.Weeks_Since_1st_Order__c;
A.Weeks_Since_Last_Order__c=E.Weeks_Since_Last_Order__c;
A.Wholesaler__c=E.Wholesaler__c;
A.Wholesaler_Discount_Percent__c=E.Wholesaler_Discount_Percent__c;
A.WLR_Enrolled__c=E.WLR_Enrolled__c;
A.Writing_Drafting_IMU_LY__c=E.Writing_Drafting_IMU_LY__c;
A.Writing_Drafting_IMU_TY__c=E.Writing_Drafting_IMU_TY__c;
A.Writing_Drafting_Last_Order__c=E.Writing_Drafting_Last_Order__c;
A.Writing_Drafting_Last_Order_amt__c=E.Writing_Drafting_Last_Order_amt__c;
A.Writing_Drafting_LY__c=E.Writing_Drafting_LY__c;
A.Writing_Drafting_Pot__c=E.Writing_Drafting_Pot__c;
A.Writing_Drafting_Total_LY__c=E.Writing_Drafting_Total_LY__c;
A.Writing_Drafting_TY__c=E.Writing_Drafting_TY__c;
A.Year_LY__c=E.Year_LY__c;
A.Year_LY_IMU__c=E.Year_LY_IMU__c;
A.YTD_Sales_LY__c=E.YTD_Sales_LY__c;
A.YTD_Sales_LY_IMU__c=E.YTD_Sales_LY_IMU__c;
A.YTD_Sales_TY__c=E.YTD_Sales_TY__c;
A.YTD_Sales_TY_IMU__c=E.YTD_Sales_TY_IMU__c; 
A.Zip__c=E.Zip__c;
///A.Related_Account__c= e.Parent_Account__r.Account__c;
A.Related_Account__c= e.Related_OD_Account_Extension__r.account__C;
if(E.Account_Owner__c!=null)
A.OwnerID=E.Account_Owner__c;
else
A.OwnerID=E.Account_Owner_ID__c;

A.Related_Pricing_Template_Account__c=e.Related_Pricing_Template_Dormant_Account__c;
A.ParentId = E.Account_ParentId__r.Account__c;
A.Account_Extension__c =E.id;
A.Name=E.name;
//A.Name=E.Account_Name__c;
A.RecordTypeId= recTypeMapAcct.get(e.recordtype.DeveloperName);
//A.Account_Record_Type_Id__c = E.recordtypeid;
return a;
    }
    
    public list<Account_Extension__c> fetchAccountExtension(Set<ID> extIDs) { 
        return [select Id, OwnerId, IsDeleted, Name, RecordTypeId,RecordType.name,RecordType.DeveloperName, CreatedDate, CreatedById, LastModifiedDate, LastModifiedById, SystemModstamp, 
                ConnectionReceivedId, ConnectionSentId, ADS_Current_Month__c, ADS_Current_Qtr__c, ADS_Current_Yr__c, ADS_Last_Month__c, ADS_Last_Qtr__c, 
                ADS_Last_Yr__c, AOPS_Cust_Id__c, AOPS_Seq_ID__c, AOV_Current_Month__c, AOV_Current_Qtr__c, AOV_Current_Yr__c, AOV_Last_Month__c, AOV_Last_Qtr__c, 
                AOV_Last_Yr__c, Account_Legal_Name__c, Account_Page_Source__c, Account_Setup_Request_Status__c, Account_Type__c, Account_level_email_permission_flag__c, 
                Acct_Hqtrs__c, Address1__c, Address2__c, Address_Key__c, Address_Validated__c, Address_Validation_Error__c, Assign_Specific_Owner__c, Auto_Assign__c, 
                Back_to_School__c, Buying_Account__c, Buying_Group__c, CBS_IMU_LY__c, CBS_IMU_TY__c, CBS_LY__c, CBS_Last_Order__c, 
                CBS_Last_order_amt__c, CBS_Pot__c, CBS_TY__c, CBS_Total_LY__c, CONTRACT_RETAIL_CUST_CODE__c, CPD_IMU_LY__c, CPD_IMU_TY__c, CPD_LY__c, CPD_Last_Order__c, 
                CPD_Last_order_amt__c, CPD_Pot__c, CPD_TY__c, CPD_Total_LY__c, Cadence_Call_Date_Override_Value__c, Cadence_Call_Date_Override__c, Cadence_Call_Date__c, 
                Campaign__c, City__c, Click_Tools_Qual_Survey__c, Consolidated_DUNS_ID__c, Contract_Furniture_IMU_LY__c, Contract_Furniture_IMU_TY__c, Contract_Furniture_LY__c, 
                Contract_Furniture_Last_Order__c, Contract_Furniture_Last_Order_amt__c, Contract_Furniture_Pot__c, Contract_Furniture_TY__c, Copier_Fleet_Expiration_Date__c, 
                Copiers__c, Cost_Centre_Dept__c, Country__c, County__c, Coupon_flag__c, Customer_Lifecycle__c, Customer_Setup_Completed__c, Customer_Setup_Requested__c, 
                Customer_Source__c, DNBI_Application_ID__c, DNBI_CREDIT_OUTCOME__c, DNBI_FSS_Score__c, DNBI_MatchScore__c, DNB_Block_Group_Code__c, DNB_Division__c, 
                DNB_Duns__c, DNB_Employee_Total__c, DNB_Employees_Here__c, DNB_Family_Updated_Date__c, DNB_Global_Ult_Duns__c, DNB_Hier_Code__c, DNB_Hqtr_Duns__c, 
                DNB_Legal_Status__c, DNB_Minority_Business__c, DNB_Parent_Duns__c, DNB_Phone__c, DNB_Private__c, DNB_SIC__c, DNB_Sales__c, DNB_Small_Business__c, 
                DNB_Status__c, DNB_Subsidiary__c, DNB_Total_Family_Member__c, DNB_Ultimate_Name__c, DNB_Vertical_Markets__c, DNB_WCW_Here__c, DNB_WCW_Total__c, 
                DNB_Year_Started__c, DSM_User__c, Deliver_Charge__c, Delivery__c, Duns_Enrichment__c, Duns_Number__c, Duplicate_Disposition__c, 
                EIN__c, Est_Spend_CAD__c, Est_Spend__c, Failed_Reason__c, Filing_Binding_IMU_LY__c, Filing_Binding_IMU_TY__c, Filing_Binding_LY__c, Filing_Binding_Last_Order__c, 
                Filing_Binding_Last_Order_amt__c, Filing_Binding_Pot__c, Filing_Binding_TY__c, Filing_Binding_Total_LY__c, First_Order_Date__c, Follow_Up_Note__c, 
                Freight_Charge__c, Fuel_Surcharge__c, Furniture_IMU_LY__c, Furniture_IMU_TY__c, Furniture_LY__c, Furniture_Last_Order__c, Furniture_Pot__c, 
                Furniture_TY__c, Furniture_Total_LY__c, Furniture_last_order_amt__c, GGPId__c, GP_Id__c, GParent_GPID__c, GT_Account_Type__c, GT_Description__c, 
                GT_Max_Perks_Eligible__c, GT_Max_Perks_Enrolled_Date__c, GT_Max_Perks_Enrolled__c, GT_Segment__c, Grand_Siloe__c, Grandparent_Type__c, Header_Record_Access__c, 
                Hide__c, Hierarchy__c, Hosted_Catalog_Flag__c, Industry_OD_SIC_DB__c, Industry_OD_SIC_Rep__c, Initial_Site_Flag__c, Ink_Toner_IMU_LY__c, Ink_Toner_IMU_TY__c, 
                Ink_Toner_LY__c, Ink_Toner_Last_Order__c, Ink_Toner_Last_Order_amt__c, Ink_Toner_Pot__c, Ink_Toner_TY__c, Ink_Toner_Total_LY__c, Labels_Forms_IMU_LY__c, 
                Labels_Forms_IMU_TY__c, Labels_Forms_LY__c, Labels_Forms_Last_Order__c, Labels_Forms_Last_Order_amt__c, Labels_Forms_Pot__c, Labels_Forms_TY__c, 
                Labels_Forms_Total_LY__c, Last_Order_Date__c, Legacy_CreatedBy__c, Legacy_CreatedDate__c, Legacy_LastModifiedBy__c, Legacy_LastModifiedDate__c, 
                Legal_Flag__c, Location_Type__c, Loyalty_Type__c, MPS_IMU_LY__c, MPS_IMU_TY__c, MPS_LY__c, MPS_Last_Order__c, MPS_Last_order_amt__c, MPS_Pot__c, 
                MPS_TY__c, MPS_Total_LY__c, MTD_Sales_LY_IMU__c, MTD_Sales_LY__c, MTD_Sales_TY_IMU__c, MTD_Sales_TY__c, Max_Order_Limit__c, Min_Order_Charge__c, 
                Minimum_Discount__c, Miscellaneous_IMU_LY__c, Miscellaneous_IMU_TY__c, Miscellaneous_LY__c, Miscellaneous_Last_Order__c, Miscellaneous_Last_Order_amt__c, 
                Miscellaneous_Pot__c, Miscellaneous_TY__c, Miscellaneous_Total_LY__c, Mod_5_EBS_Sync_Error__c, Mod_5_EBS_Sync_Status__c, Modified_Price_Value__c, Monthly_LY_IMU__c, 
                Monthly_LY__c, Monthly_Sales__c, Num_of_Categories__c, Num_of_Orders_Since_Start__c, Number_of_Categories_Check__c, Number_of_Orders_Check__c, Number_of_Orders__c, 
                OMXIsUpdated__c, OMX_Account__c, OMX_Do_Not_Call__c, OMX_GPO__c, OMX_Mainframe_Account_Level__c, OMX_Mainframe_Account_Number__c, OMX_Mainframe_Consignee_ID__c, 
                OMX_Mainframe_National_Acct_Number__c, OMX_Mainframe_Owning_Rep_Number__c, OMX_Primary_Key__c, OMX_Tier_1_Type__c, Off_Contract_Percent__c, Off_Contract_Price_Code__c, 
                Office_Essentials_IMU_LY__c, Office_Essentials_IMU_TY__c, Office_Essentials_LY__c, Office_Essentials_Last_Order__c, Office_Essentials_Last_Order_amt__c, 
                Office_Essentials_Pot__c, Office_Essentials_TY__c, Office_Essentials_Total_LY__c, Opportunity_Amt__c, Opt_Date__c, Oracle_Party_ID__c, Oracle_Party_Number__c, 
                Oracle_Party_Site_ID__c, Oracle_Party_Site_Number__c, Orders_Current_Month__c, Orders_Current_Qtr__c, Orders_Current_Yr__c, Orders_Last_Month__c, Orders_Last_Qtr__c, 
                Orders_Last_Yr__c, Org_Number_of_Locations__c, Org_WCW_Count_DB__c, Org_WCW_Count_Rep__c, Original_System__c, Override_Duplicate_Check_ownerid__c, Paper_IMU_LY__c, 
                Paper_IMU_TY__c, Paper_LY__c, Paper_Last_Order__c, Paper_Last_Order_amt__c, Paper_Pot__c, Paper_TY__c, Paper_Total_LY__c, Payment_Term__c, Phone_Ext__c, 
                Pot_Disposition_Reason__c, Pot_Disposition__c, Potential_Amount__c, Potential_DeDuplicate__c, Potential_Duplicate__c, Potential_Duplicate_of_ID__c, Potential_Printers__c, 
                Predictive_Purchase__c, Previous_Owner_ID__c, Price_As__c, Pricing_Flip_Effective_Date__c, Pricing_template_cd__c, Primary_BillTo__c, Primary_Competitor__c, 
                Primary_Product__c, Primary_Site_ID__c, Primary_Site__c, Processing__c, Prospect_Creation_Failure__c, QTD_Sales_LY_IMU__c, QTD_Sales_LY__c, QTD_Sales_TY_IMU__c, 
                QTD_Sales_TY__c, Quarter_LY_IMU__c, Quarter_LY__c, RSD_User__c, Ranking__c, Recurring_Request_Enabled__c, Related_Parent_Account__c, Remediation_Required__c, 
                Rep_Call_Date__c, Request_Account_Billing__c, Revenue_Band__c, Rolling_12_month_sales__c, Rolling_3_month_sales__c, Rolling_6_month_sales__c, Rolling_9_month_sales__c,
                SIC_Description_FR__c, Sales_Check__c, Sales__c, Sector__c, Segment__c, Setup_URL1__c, Silo__c, Source_System__c, Source_System_that_has_the_latest_opt_de__c, Split_Flag__c, 
                Split_Record__c, Stage__c, State__c, Status__c, Tax_Exempt__c, Tech_IMU_LY__c, Tech_IMU_TY__c, Tech_LY__c, Tech_Last_Order__c, Tech_Last_Order_amt__c, Tech_Pot__c, Tech_TY__c, 
                Tech_Total_LY__c, Test__c, Total_Order__c, Transition_Calender_Date__c, Transition_Customer__c, Ultimate_Duns_Number__c, Verticals__c, WLR_Enrolled__c, Weekly_Sales__c, 
                Weeks_Since_1st_Order__c, Weeks_Since_Last_Order__c, Wholesaler_Discount_Percent__c, Wholesaler__c, Writing_Drafting_IMU_LY__c, Writing_Drafting_IMU_TY__c, 
                Writing_Drafting_LY__c, Writing_Drafting_Last_Order__c, Writing_Drafting_Last_Order_amt__c, Writing_Drafting_Pot__c, Writing_Drafting_TY__c, Writing_Drafting_Total_LY__c, 
                YTD_Sales_LY_IMU__c, YTD_Sales_LY__c, YTD_Sales_TY_IMU__c, YTD_Sales_TY__c, Year_LY_IMU__c, Year_LY__c, Zip__c, Implementation_Manager__c, Site_Primary_Contact__c, 
                Related_Account__c, Extension_Related_Account__c,Related_OD_Dormant_Account__c, Related_Pricing_Template_Dormant_Account__c, 
                Sales_PersonID__c, Site_Contact2__c, Site_Contact3__c, Site_Contact4__c, Site_Contact5__c, Site_Contact6__c, Account_Owner__c, Account_Record_Type__c, 
                Account_Parent_Id__c, Extended_Zip_Code__c, Match_Grade__c, Match_Score__c, Primary_Address__c, Secondary_Address__c, ZIP_PLUS4__c, Account_Name__c, Account_Number__c, 
                Annual_Revenue__c, Billing_Address__c, Customer_Portal_Account__c, Data_com_Key__c, Description__c, Employees__c, Fax__c, Industry__c, Ownership__c, 
                Parent_Account__c, Phone__c, Rating__c, Type__c, Website__c, Cust_ID__c, Number_of_Sites__c, Tier_1_Partner__c, Opt_in_Date__c, Opt_out_Date__c, Existing_OMax_Account__c, 
                Account_Owner_ID__c, Related_OD_Account_Extension__c, Account__c, Original_Account_ID__c, Account_Record_Type_Id__c, Account_ParentId__c, Sic__c, Current_Account_ID__c,
                Related_OD_Account_Extension__r.Original_Account_ID__c,Related_OD_Account_Extension__r.Account__c,Account_ParentId__r.Original_Account_ID__c,
                Account_ParentId__r.Account__c,Existing_OMax_Account__r.Original_Account_ID__c,Existing_OMax_Account__r.Account__c,Parent_Account__r.Account__c 
                from account_extension__c where id=:extIDs ];
    }
    
}