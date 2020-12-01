/*
Description: To find duplicate leads and close/merge the selected duplicate leads. 
            Test coverage of this class is covered from DuplicateLeadsExtension_TC apex test class
Created By: Sunil Bansal
Created Date: 08-Nov-2012

Modified By:
Modified Date:
Modify Reason:
 
*/
public with sharing class DuplicateLeadsExtension 
{ 
        public Lead currentLead {get;set;}
        public Boolean isLeadValidationSuccessful {get;set;}
        public List<Lead> duplicateLeads = new List<Lead>();
        public List<DuplicateLead> lstDuplicateLeads = new List<DuplicateLead>();
        List<Contact> listContacts = new List<Contact>();
        List<Account> listAccounts = new List<Account>();
        public String selectedAccountId {get; set;} 
        public String strName {get;set;}
        public String strLastName {get;set;}
        public String strCompany {get;set;}
        public String strEmail {get;set;}
        public String strEmailDomain {get;set;}
        public String strPhone {get;set;}
        public String strZip {get;set;}
        public String strState {get;set;}
        public Boolean blName {get;set;}
        public Boolean blLastName {get;set;}
        public Boolean blCompany {get;set;}
        public Boolean blEmail {get;set;}
        public Boolean blEmailDomain {get;set;}
        public Boolean blPhone {get;set;}
        public Boolean blZip {get;set;}
        public Boolean blState {get;set;}
        public Boolean matchingContactsFound {get; set;}
        public Boolean matchingAccountsFound {get; set;}
        public Boolean matchingLeadsFound {get; set;}
        
        public DuplicateLeadsExtension(ApexPages.StandardController controller)
        {
                blName = true;
                blLastName = false;
                blCompany = true;
                blEmail = true;
                blEmailDomain = false;
                blPhone = true;
                blZip = true;
                blState = true;
                selectedAccountId = 'Sunil';
                isLeadValidationSuccessful = true;
            
                matchingAccountsFound = false;
                matchingContactsFound = false;
                matchingLeadsFound = false;
                
                currentLead = (Lead)controller.getRecord();
                currentLead = [Select Id, Name, Account__c, FirstName, LastName, Company, Email, Phone, Zip__c, State__c from Lead where Id = :currentLead.Id];
                strName = currentLead.Name;
                strLastName = currentLead.LastName;
                strCompany = currentLead.Company;
                strEmail = currentLead.Email;
                if(strEmail != null && strEmail != '')
                    strEmailDomain = strEmail.substring(strEmail.indexOf('@'));
                strPhone = currentLead.Phone;
                strZip = currentLead.Zip__c;
                strState = currentLead.State__c;
                searchLeads();
        }
        
        private String orCondition(String orClause, String fieldName, String fieldValue)
        {
                String retValue = '';
                if(orClause != '')
                    retValue = orClause + ' OR ' + fieldName + ' = \'' + String.escapeSingleQuotes(fieldValue.trim()) + '\'';
                else
                    retValue = fieldName + ' = \'' + String.escapeSingleQuotes(fieldValue.trim()) + '\'';
                return retValue;
        }

/*
        // not used as of now
        private String andCondition(String andClause, String fieldName, String fieldValue)
        {
                String retValue = '';
                if(andClause != '')
                        retValue = andClause + ' AND ' + fieldName + ' = \'' + fieldValue.trim() + '\'';
                else
                        retValue = fieldName + ' = \'' + fieldValue.trim() + '\'';
                
                return retValue;
        }
*/       
        public PageReference searchLeads()
        {
            matchingLeadsFound = false;
            String strQuery = 'Select Id, Name,recordtype.name, LastName, Account__c, Account__r.Id, Account__r.Name, Status, Company, EMail, Phone, Zip__c, City__c, State__c, OwnerId from Lead where ';
            String orClause = '';
            String andClause = '';
            String whereClause = '';
                
            if(blName && strName != null && strName.trim() != '')
                orClause = orCondition(orClause, 'Name', strName);
                        
            if(blLastName)
                orClause = orCondition(orClause, 'LastName', strLastName);

            if(blCompany && strCompany != null && strCompany.trim() != '')
                orClause = orCondition(orClause, 'Company', strCompany);
                        
            if(blEmail && strEmail != null && strEmail.trim() != '')
                orClause = orCondition(orClause, 'Email', strEmail);

            if(blEmailDomain && strEmailDomain != null && strEmailDomain.trim() != '')
            {
                if(orClause != '')
                    orClause = orClause + ' OR Email LIKE \'%' + strEmailDomain.trim() + '\'';
                else
                    orClause = ' Email LIKE \'%' + strEmailDomain.trim() + '\'';
            }

            if(blPhone && strPhone != null && strPhone.trim() != '')
                orClause = orCondition(orClause, 'Phone', strPhone);

            if(orClause != '')
                orClause = '(' + orClause + ')';
            else
            {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR , 'Please select and provide value for at least one attribute from Name, Last Name, Company, Email, Email Domain or Phone to find duplicate leads'));
                return null;
            }
                        
            if(blZip && strZip != null && strZip.trim() != '')
                andClause = ' Zip__c = \'' + String.escapeSingleQuotes(strZip.trim()) + '\'';

            if(blState && strState != null && strState.trim() != '')
                andClause = orCondition(andClause, 'State__c', strState); // it should be OR between Zip and State, so function orCondition()

            if(andClause != '')
                andClause = '(' + andClause + ')';
            else
            {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR , 'Please select and provide value for at least one attribute from Zip or State to find duplicate leads'));
                return null;
            }
                        
            if(orClause != '' && andClause != '')
                whereClause = orClause + ' AND ' + andClause;
            else if(orClause != '' && andClause == '')
                whereClause = orClause;
            else if(orClause == '' && andClause != '')
                whereClause = andClause;
                        
            if(whereClause == '')
            {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR , 'Please select at least one attribute to find duplicate leads'));
            }
            else
            {
                System.debug('MY LEAD WHERE CLAUSE == '+whereClause);
                strQuery = strQuery + whereClause + ' LIMIT 100';
                duplicateLeads = Database.query(strQuery);
                lstDuplicateLeads.clear();
                for(Lead ld: duplicateLeads)
                {
                    if(ld.Id != currentLead.Id)// remove the duplicate lead from duplicate list for display
                        lstDuplicateLeads.add(new DuplicateLead(ld));
                }
                if(lstDuplicateLeads.size() > 0)
                    matchingLeadsFound = true;
            }
            searchAccounts();
            searchContacts();
            return null;
        }
        
        // this method is called from VF page
        public List<Account> getMatchingAccounts() 
        {   
            return listAccounts;
        }
        
        //==============================================================================//
        // Get matching accounts list
        //==============================================================================//
        private void searchAccounts() 
        {   
            matchingAccountsFound = false;
            listAccounts.clear();
            String strQuery = 'Select Id, Status__c, State__c, Stage__c, Zip__c, RecordType.Name, RecordTypeId, OwnerId, Name, LastActivityDate, City__c, Address1__c, AOPS_Cust_Id__c From Account where ';
            String whereClause = '';
            String andClause = '';
            System.debug('blCompany == '+ blCompany + '   strCompany ===  '+strCompany);
            if(blCompany && strCompany != null && strCompany.trim() != '')
            {
                whereClause = ' Name LIKE \'' + String.escapeSingleQuotes(strCompany.trim()) + '%\'';
            }
                
            if(blZip && strZip != null && strZip.trim() != '')
                andClause = ' Zip__c = \'' + String.escapeSingleQuotes(strZip.trim()) + '\'';
            System.debug('blState == '+ blState + '   strState ===  '+strState);
            
            if(blState && strState != null && strState.trim() != '')
                andClause = orCondition(andClause, 'State__c', strState); // it should be OR between Zip and State, so function orCondition()
            
            if(andClause != '')
                andClause = '(' + andClause + ')';
                    
            if(whereClause != '' && andClause != '')
                whereClause = whereClause + ' AND ' + andClause;
            else if(whereClause == '' && andClause != '')
                    whereClause = andClause;
                        
            System.debug('MY ACCOUNT WHERE CLAUSE == '+whereClause);
            if(whereClause != '')
            {
                //matchingAccountsFound = true;
                strQuery = strQuery + whereClause + ' LIMIT 100';
                listAccounts = Database.query(strQuery);
                System.debug('MY ACCOUNT LIST SIZE == '+ listAccounts.size());
                if(listAccounts.size() > 0)
                {
                    matchingAccountsFound = true;
                }
            }
            
            System.debug('matchingAccountsFound == '+ matchingAccountsFound);
       
        } 
        
        // this method is called from VF page
        public List<contact> getMatchingContacts() 
        {
            return listContacts;
        }
        
        //==============================================================================//
        // Get matching contacts list
        //==============================================================================//
        private void searchContacts() 
        {
            matchingContactsFound = false;
            listContacts.clear();
            String strQuery = 'Select Id, OwnerId, Name,FirstName,LastName, MobilePhone, MailingStreet, MailingState, MailingCity, Email, Phone, Account_Recordtype__c, Account.RecordTypeId, Account.Name, AccountId From Contact where ';
            String whereClause = '';
            String whereClause1 = '';
            String whereClause2 = '';
            String andClause = '';
            
            if(currentLead.FirstName != null && currentLead.FirstName != '')
                whereClause1 = orCondition(whereClause1, 'FirstName', currentLead.FirstName);
            if(blLastName)
                whereClause1 = orCondition(whereClause1, 'LastName', strLastName);

            if(blEmail && strEmail != null && strEmail.trim() != '')
               // andClause = orCondition(andClause, 'Email', strEmail);
               whereClause2 =orCondition(whereClause2 , 'Email', strEmail);
            if(blPhone && strPhone != null && strPhone.trim() != '')
               // andClause = orCondition(andClause,
               whereClause2 =orCondition(whereClause2 ,  'Phone', strPhone);
            if(whereClause1!= '')
            {
               whereClause =whereClause + '( ' +whereClause1 +' )';
               if(whereClause2!= '')
                   whereClause = whereClause + ' AND (' +whereClause2 +')';
            }
            else  if(whereClause2!= '') 
                whereClause = whereClause + '( ' +whereClause2 +' )';
              
            if(whereClause != '')
            {
                //matchingContactsFound = true;
                System.debug('MY CONTACT WHERE CLAUSE == '+whereClause);
                strQuery = strQuery + whereClause + ' LIMIT 100';
                listContacts = Database.query(strQuery);
                if(listContacts.size() > 0)
                    matchingContactsFound = true;
            }
        }
        
        // this method is to link current lead (from where VF page is called) to selected one account by radio button
        public PageReference linkLead()
        {
            try
            {
                System.debug('SELECTED selectedAccountId = '+selectedAccountId);
                currentLead.Account__c = selectedAccountId;
                update currentLead;
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.CONFIRM , 'Lead successfuly linked to the Account.'));
            }
            catch(Exception ex)
            {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR , 'Was not able to link lead to Account \'' + selectedAccountId + '\''));
            }
            return null;
        }
        
        // thsi method called form VF page
        public List<DuplicateLead> getMatchedLeads()
        {
            System.debug('MY MATCHED LEADS SIZE === '+lstDuplicateLeads.size());
            return lstDuplicateLeads;
        }
        
        // this method is to validate lead if least values (like company, zip and phone) are populated on lead to go and find duplicate leads
        public PageReference ValidateLead() 
        {               
            String message = '';
            if(currentLead.company == null && currentLead.zip__c == null && currentLead.phone == null) 
            {
                message = 'In order to check for existing matches in the system the following fields need to be completed:  Company Name, Phone & Zip';
                ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.FATAL,message));
                isLeadValidationSuccessful = false;
            }       
            return null;
        }
        
        // Thsi method is to update states of selected leads to 'Closed'
        public PageReference closeLeads()
        {
            List<Lead> updateLeads = new List<Lead>();
            for(DuplicateLead dup: lstDuplicateLeads)
            {
                if(dup.leadChecked)
                {
                    dup.leadChecked = false;
                    Lead ld = dup.dupLead;
                    // if a selected lead is already closed, no need to fire DML statement on that lead
                    if(ld.Status != 'Closed')
                    {
                        ld.Status = 'Closed';
                        system.debug('Lead going to close'+ld);
                        if(ld.recordtype.name == 'Lead (US)'){
                        ld.Closed_Date__c = Date.Today();
                        ld.Close_Reason__c = 'Duplicate Record';
                        system.debug('Lead close reason'+ld);
                        }
                        system.debug('Lead fully updated'+ld);
                        updateLeads.add(ld);
                    }
                        
                }
            }
            update updateLeads;
            return null;
        }
        
        // this method is to take back to teh current Lead from where teh VF page is opened 
        public PageReference BackToLead() 
        {        
            return new PageReference('/'+currentLead.Id);
        }
        
        // this wrapper class helps in rendreing duplicate results with Check Box in first column
        public class DuplicateLead
        {
            public Lead dupLead {get; set;}
            public Boolean leadChecked {get; set;}
            public DuplicateLead()
            {
            }
            public DuplicateLead(Lead ld)
            {
                this.leadChecked = false;
                this.dupLead = ld;
            }
        } 

}