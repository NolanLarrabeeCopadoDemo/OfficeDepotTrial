/**
* @author Sandesh Ganjare, sandesh.ganjare@officedepot.com
* @date 15/1/2020
*
* 
* @description This class having the logic for Qualifying Lead conversion flow.
*              This class used for 'convertQualifyingLead' LWC component.
* 02716516 : Qualifying Lead Conversion
*/
global without sharing class QualifyingLeadController {

 
    /*******************************************************************************************************
    * @description Lead Convert standard method.
    */
    @TestVisible
    private static Database.LeadConvert getLeadConvert(Lead lead) {
        Database.LeadConvert leadConvert = new Database.LeadConvert();
        leadConvert.setLeadId(lead.Id);
        
        List < LeadStatus > lstLeadStatus = [SELECT Id, MasterLabel FROM LeadStatus WHERE IsConverted = true];
        if (lstLeadStatus.size() > 0) {
            leadConvert.setConvertedStatus(lstLeadStatus[0].MasterLabel);
        }
        return leadConvert;
        
    }
    
    /*******************************************************************************************************
    * @description Copying Notes and Attachments to Opportunity from Lead when it is converted.
    * 
    */
    private static void copyNotesAttachmentToOpportunity(List<Attachment> LeadattachmentsToBeCloned,List<Note> LeadnotesToBeCloned,String OppId)
    {
        List<Attachment> OppAttachmentList = new List<Attachment>();
        List<Note> OppNotesList = new List<Note>();
        system.debug('LeadattachmentsToBeCloned'+LeadattachmentsToBeCloned);
        if(LeadattachmentsToBeCloned != null && LeadattachmentsToBeCloned.size()>0){
            for(Attachment att : LeadattachmentsToBeCloned){
                Attachment a = att.clone();
                a.ParentId = OppId;
                OppAttachmentList.add(a); 
            }
        }
        
        if(LeadnotesToBeCloned != null && LeadnotesToBeCloned.size()>0){
            for(Note notesOflead : LeadnotesToBeCloned){
                Note n = notesOflead.clone();
                n.ParentId = OppId;
                OppNotesList.add(n); 
            }
        }
        
        
        if(OppAttachmentList != null)
            insert OppAttachmentList;
        
        if(OppNotesList != null)
            insert OppNotesList;
    }
    
    /*******************************************************************************************************
    * @description Create new Site from the Lead information and attached to respective Account. 
    
    private static Id createNewSite(Lead Lead, Id AccountId, Id ContactId){
        Id SiteId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Site').getRecordTypeId();
        Account newSite = new Account();
        newSite.name = Lead.Company;
        //newSite.Phone = currentProspect.Phone;
        newSite.recordtypeId = SiteId;
        if (String.isNotBlank(Lead.Id)) {
            newSite.OwnerId = Lead.OwnerId;
            newSite.Sales_PersonID__c = Lead.Sales_Person_ID__c;
            newSite.Status__c = 'Active';
            newSite.Primary_Site__c = true;
            newSite.Industry_OD_SIC_Rep__c = Lead.Industry;
            newSite.address1__C = Lead.address1__C;
            newSite.Address2__c = Lead.Address2__c;
            newSite.city__c = Lead.city__C;
            newSite.state__c = Lead.state__C;
            newSite.zip__c = Lead.zip__c;
            newSite.Country__c = Lead.Country__c;
            newSite.Org_WCW_Count_Rep__c = Lead.WCW_Count__c;
        } 

        newSite.Related_Account__c = AccountId;//CReated new Account currentProspect.Id;
        newSite.Site_Primary_Contact__c = ContactId;
        Insert newSite;

        return newSite.Id;
    }*/

    /*******************************************************************************************************
    * @description Update the respective Opportunity with respctive fields of Lead.
    */
    private static void UpdateOpportunity(Lead lead, Id accountId, Id opportunityId, Id siteAccountId ){
        if(opportunityId != null){
            Opportunity opportunity = new Opportunity(Id = opportunityId);            
            opportunity.accountId = accountId;      
            if(siteAccountId != null){
                opportunity.related_site__c = siteAccountId;               
            }
           
           
            opportunity.OwnerId= lead.OwnerId;
            /*opportunity.Product__c = lead.Product__c;
            opportunity.Product_Subtype__c = lead.ProductSubtype__c;
            opportunity.Supplier__c = lead.Current_Supplier__c;          
            opportunity.Primary_Competitor1__c = lead.PrimaryCompetitor__c;
            
            opportunity.Customer_Lifecycle__c = lead.LeadLifecycle__c;
            opportunity.Initiatives__c = lead.Initiatives__c;          
            opportunity.Current_Provider__c = lead.CurrentProvider__c;              
            opportunity.SystemLeadSource__c = lead.SystemLeadSource__c;
            opportunity.DevicesAnnuityPlacements__c = lead.DevicesAnnuityPlacements__c;
            opportunity.Project_Ongoing__c = lead.ProjectOngoing__c;
            opportunity.RepLeadSource__c = lead.Rep_Lead_Source__c;
            opportunity.Store__c = lead.Store__c;            
            opportunity.Watson_Notes__c = lead.Notes__c;
            opportunity.StageName = 'Exploring';*/

            //Other fields are mapped under Standard Lead mapping
            opportunity.Status__c = 'Open';
            opportunity.CloseDate = lead.Estimated_Close_Date__c;
            opportunity.Amount = lead.amount__c;
            opportunity.NextStep = lead.NextStep__c;
            opportunity.Supplier__c = lead.Current_Supplier__c;
            opportunity.Current_Provider__c = lead.CurrentProvider__c;
            opportunity.Primary_Competitor1__c = lead.PrimaryCompetitor__c;
            opportunity.StageName = 'Discovery';
            update opportunity;
            system.debug('Opportunity Updated');
        }
    }


    /*******************************************************************************************************
    * @description Lead conversion logic. Create or update Account, Contact, Site and Opportunity. 
    */
    @AuraEnabled
    public static Map<String, String> convertQualifyingLead(String LeadId){
         System.debug('LeadId=>'+LeadId);
        List<Lead> lstLead = [SELECT Id, Name, OwnerId,Owner.Name, Product__c, Current_Supplier__c, Status, Email, Account__c, Account__r.Name,Store__r.Name,PrimaryCompetitor__r.Name,
                CurrentProvider__c, Store__c,Notes__c, Company, IsConverted, RecordTypeId, ConvertedAccountId, Related_Site__c, Related_Site__r.Name,
                ConvertedContactId, Sales_Person_ID__c, Industry, address1__C, Address2__c, city__C, state__C,
                zip__c, Country__c, WCW_Count__c,Amount__c, LeadLifecycle__c,Estimated_Close_Date__c,PrimaryCompetitor__c, ProductSubtype__c,ProjectOngoing__c,
                Initiatives__c,SystemLeadSource__c,Rep_Lead_Source__c,DevicesAnnuityPlacements__c,NextStep__c,Contact__c FROM Lead WHERE Id=:LeadId LIMIT 1];
        System.debug('lstLead=>'+lstLead);
        Lead lead = lstLead[0];
       System.debug('Lead=>'+Lead);
        Map<String, String> MyMap = new Map<String, String>(); 
        Id OpportunityId;     
        Savepoint sp;
        try{
            sp = Database.setSavepoint();          
            Database.LeadConvert leadConvert = getLeadConvert(Lead);
            List<Attachment> LeadattachmentsToBeCloned = new List<Attachment>();
            LeadattachmentsToBeCloned = [Select Id, Name, ParentId, Body From Attachment Where ParentId =: Lead.Id];
            
            List<Note> LeadnotesToBeCloned = new List<Note>();
            LeadnotesToBeCloned = [Select Id,Title,Body From Note Where ParentId =: Lead.Id];
            Lead.Override_Duplicate_Check__c = true;
            update Lead;
            if(Lead.Account__c != null){                
                  leadConvert.setAccountId(Lead.Account__c);
                  if(Lead.Contact__c != null ){
                     System.debug('Contacts=>'+Lead.Contact__c);
                     leadConvert.setContactId(Lead.Contact__c);
                  }
            }           
            Database.LeadConvertResult leadConvertResult = Database.ConvertLead(leadConvert);            
            MyMap.put('Status', 'Success');
            System.debug('leadConvertResult.getOpportunityId()=>'+leadConvertResult.getOpportunityId());
            MyMap.put('Id', leadConvertResult.getOpportunityId());
            OpportunityId = leadConvertResult.getOpportunityId();
            //Clone the attachment
            copyNotesAttachmentToOpportunity(LeadattachmentsToBeCloned,LeadnotesToBeCloned,leadConvertResult.getOpportunityId());
            
            //Create the Site
            Id AccountSite;
            if(Lead.Account__c == null){
                //AccountSite = createNewSite(Lead, leadConvertResult.getAccountId(), leadConvertResult.getContactId());
                //Update the Opporunity 
                UpdateOpportunity(Lead, leadConvertResult.getAccountId(), leadConvertResult.getOpportunityId(), AccountSite); 
            }else{
                //Account siteAccount = [Select Id,Related_Account__c from Account  where Related_Account__c =: Lead.Account__c and RecordType.Name='Site' Limit 1];
                //Update the Opporunity 
                UpdateOpportunity(Lead, leadConvertResult.getAccountId(), leadConvertResult.getOpportunityId(), Lead.Related_Site__c); 
            }

                      
            
        }catch(Exception e){
            System.debug('Exception=>'+e.getMessage());
            Database.rollback(sp);
            MyMap.put('Status', e.getMessage());
            MyMap.put('Id', '');
        }
        System.debug('MyMap=>'+MyMap);
        return MyMap;
                                     
    }
    
}