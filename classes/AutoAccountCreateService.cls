//
// (c) 2015 Appirio, Inc.
//
// Webservice to receive auto information from SOA
//
// 20 Aug 2015     Luke Slevin       Original
//
global class AutoAccountCreateService {

    global class AccountInformation {
        webservice String FIRSTNAME;
        webservice String LASTNAME;
        webservice String EMAIL;
        webservice String PHONE;
        webservice String PHONEEXT;
        webservice String ACCOUNTTYPE;
        webservice String COMPANYNAME;
        webservice String EINNUM;
        webservice String TOTALEMPLOYEES;
        webservice String ADDRESS1;
        webservice String ADDRESS2;
        webservice String CITY;
        webservice String STATE;
        webservice String ZIP;
        webservice String WEBSITE;
        webservice String TAXEXEMPT;
        webservice String ACCOUNTBILLING;
        webservice String STATUSMESSAGE;
        webservice String STATUSDESCRIPTION;
    }

    webservice static AccountInformation createAccount(AccountInformation a){
        //Create a savepoint to rollback to in case of error
    Savepoint sp = Database.setSavepoint();
    //Added by ivarada 10/2/2015 AAC Project
    executeoncetest.BypassAccountTrigger = false;
        try{
            //Added by Lalit for S-407235 START
            Integer totalEmployees = getTotalEmployees(a.TOTALEMPLOYEES); 
            String multipleUser = ''; 
            /*DuplicateLeadPotential duplicateLead = new DuplicateLeadPotential();//Added by Lalit for S-407237
            List<Account> returnedduplicateAccounts = duplicateLead.getMatchingAccounts(getNotNullSet(a.COMPANYNAME), getNotNullSet(a.Zip), getNotNullSet(a.STATE));//Added by Lalit for S-407237          
            */
            
            List<Account> returnedduplicateAccounts = [SELECT Id,Name FROM Account WHERE (RecordTypeId =: label.Account_Customer_OfficeMax_Record_Type OR RecordTypeId =: label.Account_Customer_Record_Type)
            AND Status__c = 'Active' AND Name =: a.COMPANYNAME AND Zip__c LIKE: a.Zip+'%' limit 1];
            
            if(totalEmployees >=150 || (returnedduplicateAccounts!=null && returnedduplicateAccounts.size() > 0)){//modified by Lalit for S-407237
                //Create new Lead
            //if(totalEmployees >=150) {
                Lead prospectLead = new Lead();
                prospectLead.FirstName = a.FIRSTNAME;
                prospectLead.LastName = a.LASTNAME;
                prospectLead.Email = a.EMAIL;
                prospectLead.Company = a.COMPANYNAME;
                prospectLead.Phone = a.PHONE;
                prospectLead.Extension__c = a.PHONEEXT;
                if(a.TOTALEMPLOYEES != null && a.TOTALEMPLOYEES != ''){
                    prospectLead.WCW_Count__c = totalEmployees;
                }
                
                prospectLead.Address1__c = a.ADDRESS1;
                prospectLead.Address2__c = a.ADDRESS2;
                prospectLead.City__c = a.CITY;
                prospectLead.State__c = a.STATE;
                prospectLead.Zip__c = a.ZIP;
                prospectLead.Website = a.WEBSITE;
                prospectLead.Auto_Assign__c = true;
                prospectLead.LeadSource = Constants.LEAD_SOURCE;
                if(returnedduplicateAccounts!=null && returnedduplicateAccounts.size() > 0){
                    prospectLead.Potential_Duplicate__c = true;
                }
                if(a.ACCOUNTTYPE == Constants.SINGLE){
                    multipleUser = Constants.SINGLE_USER;  
                }
                else if(a.ACCOUNTTYPE == Constants.MULTIPLE){
                    multipleUser = Constants.MULTI_USER; 
                }
                prospectLead.Description = 'Multiple Users = '+multipleUser +'\n'+ 'Tax Exempt Status = '+a.TAXEXEMPT+'\n'+'Account Billing = '+a.ACCOUNTBILLING;
                a.STATUSMESSAGE = 'SUCCESS';
                prospectLead.Lead_Page_Source__c = Constants.LEAD_FIRST;//Added by Lalit for S-414430
                insert prospectLead;
                if(returnedduplicateAccounts!=null && returnedduplicateAccounts.size() > 0) {//Modified by ivarada for S-407229
                    a.STATUSMESSAGE = 'DUPLICATE_RECORD';
                    system.debug('Duplicate Found');
                }
                System.debug('=======>prospectLead'+prospectLead.id);
                
            }//Added by Lalit for S-407235 END
            else if(totalEmployees <=149){//Added this else block by lalit for S-407235
                
            
            
                Account prospectAccount = new Account();
                Account siteAccount = new Account();
                Contact primaryContact = new Contact();
                Opportunity prospectAccountOpty = new Opportunity();
    
                //Create Prospect Account
                prospectAccount.RecordTypeId = Label.Account_Prospect_Record_Type;
                if(a.ACCOUNTTYPE == 'Single'){
                    prospectAccount.Account_Type__c = 'Single User';  
                }
                else if(a.ACCOUNTTYPE == 'Multiple'){
                    prospectAccount.Account_Type__c = 'Multi-User'; 
                }
    
                prospectAccount.Name = a.COMPANYNAME;
                 //commented by deepak - sfdc will not store EIN as part of phase 1
                prospectAccount.EIN__c = a.EINNUM;
                List<String> range = a.TOTALEMPLOYEES.split('-');
                if(range.size() == 2){
                    if(range[0] > range[1]){
                        prospectAccount.Org_WCW_Count_Rep__c = Integer.valueOf(range[0]);
                    }
                    else{
                        prospectAccount.Org_WCW_Count_Rep__c = Integer.valueOf(range[1]);
                    }
                }
                if (a.TOTALEMPLOYEES.contains('+'))
                   prospectAccount.Org_WCW_Count_Rep__c = Integer.valueOf(a.TOTALEMPLOYEES.substring(0,a.TOTALEMPLOYEES.indexof('+')));
                   
                prospectAccount.Address1__c = a.ADDRESS1;
                prospectAccount.Address2__c = a.ADDRESS2;
                prospectAccount.City__c = a.CITY;
                prospectAccount.State__c = a.STATE;
                prospectAccount.Zip__c = a.ZIP;
                prospectAccount.Phone = a.PHONE;
                //added by Nisha on 01/21/2016 for S-374372
                prospectAccount.Phone_Ext__c = a.PHONEEXT;
                //end S-374372
                prospectAccount.Country__c = 'USA';
                prospectAccount.Website = a.WEBSITE;
                if(a.ACCOUNTBILLING == 'true'){
                   prospectAccount.Request_Account_Billing__c = 'Y'; 
                }
                else if(a.ACCOUNTBILLING == 'false'){
                    prospectAccount.Request_Account_Billing__c = 'N';
                }
                
                if(a.TAXEXEMPT == 'true'){
                    prospectAccount.Tax_Exempt__c = 'Y';
                }
                else if(a.TAXEXEMPT == 'false'){
                    prospectAccount.Tax_Exempt__c = 'N';
                }
                
                //Set Default Values for Prospect Account
                prospectAccount.AccountSource = 'BSD Auto Account Setup';
                prospectAccount.Auto_Assign__c = true;
                prospectAccount.OMX_Account__c = 'No';
                prospectAccount.Payment_Term__c = 'Credit Card';
                prospectAccount.Primary_Product__c = 'All Supplies';
                prospectAccount.Sector__c = 'Private';
                prospectAccount.Segment__c = 'Small < $40K';
                prospectAccount.Buying_Group__c = 'Buying Groups Small <$40K';
                prospectAccount.Pricing_template_cd__c = 'OD Flex 15 / $6K-$24K';
                prospectAccount.Industry_OD_SIC_Rep__c = 'Other';
                prospectAccount.Country__c = 'USA';
                prospectAccount.Status__c = 'Active';
    
                //Perform Duplicate Check on Account
                system.debug('Input Values:'+ a.COMPANYNAME + ',' + a.ADDRESS1 + ',' + a.ADDRESS2 + ',' + a.CITY + ',' + a.STATE + ',' + a.Zip);
               /* List<Account> possibleDuplicateCustomerAccounts = [SELECT Id,Name FROM Account WHERE (RecordTypeId =: label.Account_Customer_OfficeMax_Record_Type OR RecordTypeId =: label.Account_Customer_Record_Type)
                AND Status__c = 'Active' AND Name =: a.COMPANYNAME AND Zip__c LIKE: a.Zip+'%'];*///Commented by Lalit for S-407229
                //Added by lalit for S-407229 START
                boolean isDuplicateCheck = false;
               /* DuplicateLeadPotential duplicateLeadObj = new DuplicateLeadPotential();
                
                //List<Account> duplicateAccounts = duplicateLeadObj.getMatchingAccounts(getNotNullSet(a.COMPANYNAME), getNotNullSet(a.Zip), getNotNullSet(a.STATE));
                //if(duplicateAccounts != null && duplicateAccounts.size() > 0){
                IF(returnedduplicateAccounts != null && returnedduplicateAccounts.size() > 0) {
                    isDuplicateCheck = true;
                }
                if(!isDuplicateCheck){
                    List<Contact> duplicateContacts = duplicateLeadObj.getMatchingContacts(getNotNullSet(a.FIRSTNAME), getNotNullSet(a.LASTNAME), getNotNullSet(a.EMAIL),getNotNullSet(a.PHONE));
                    if(duplicateContacts != null && duplicateContacts.size() > 0){
                        isDuplicateCheck = true;
                    }
                }
                if(!isDuplicateCheck){
                    List<Lead> duplicateLeads = duplicateLeadObj.getMatchingLeads(getNotNullSet(a.FIRSTNAME + ' ' +a.LASTNAME), getNotNullSet(a.COMPANYNAME), getNotNullSet(a.EMAIL), getNotNullSet(a.PHONE), getNotNullSet(a.Zip), getNotNullSet(a.STATE));
                    if(duplicateLeads != null && duplicateLeads.size() > 0){
                        isDuplicateCheck = true;
                    } 
                } */
                
                //System.debug('=======>duplicateAccounts.size '+duplicateAccounts.size());
                //Added by lalit for S-407229 END
    
                if(isDuplicateCheck) {//Modified by lalit for S-407229
                //if(possibleDuplicateCustomerAccounts.size() > 0) {
                    a.STATUSMESSAGE = 'DUPLICATE_RECORD';
                    prospectAccount.Potential_Duplicate__c = true;
                    system.debug('Duplicate Found');
                }
                else {
                    a.STATUSMESSAGE = 'SUCCESS';
                }
                            
                insert prospectAccount;
                System.debug('========>prospectAccount '+prospectAccount.id);
                
                  List<Account> lstAccount = [select ownerId,Sales_PersonID__c from Account where id = :prospectAccount.Id];
                    if(lstAccount.size() > 0) {
                        system.debug('###inside prospect account owner pull');
                    prospectAccount.ownerID = lstAccount[0].OwnerId;
                    prospectAccount.Sales_PersonID__c =  lstAccount[0].Sales_PersonID__c;
                    }  
    
                //Create Primary Contact
                primaryContact.Primary_Contact__c = true;
                primaryContact.Firstname = a.FIRSTNAME;
                primaryContact.LastName = a.LASTNAME;
                primaryContact.Email = a.EMAIL;
                primaryContact.Phone = a.PHONE;
                primaryContact.Phone_Ext__c = a.PHONEEXT;
                primaryContact.AccountId = prospectAccount.Id;
                primaryContact.OwnerId = prospectAccount.OwnerId;
                insert primaryContact;
    
                            //Create Site Account
                            siteAccount.Name = a.COMPANYNAME;
                            siteAccount.RecordTypeId = label.Account_Site_Record_Type;
                            siteAccount.Related_Account__c = prospectAccount.Id;
                            siteAccount.Address1__c = a.ADDRESS1;
                            siteAccount.Address2__c = a.ADDRESS2;
                            siteAccount.City__c = a.CITY;
                            siteAccount.State__c = a.STATE;
                            siteAccount.Zip__c = a.ZIP;
                            siteAccount.Country__c = 'USA';
                            siteAccount.Primary_Site__c = true;
                            siteAccount.OwnerId = prospectAccount.OwnerId;
                            insert siteAccount;
    
                //Create Opportunity
                prospectAccountOpty.RecordTypeId = label.Opportunity_Field_Sales_Record_Type;
                prospectAccountOpty.Name = 'BSD Auto Account Setup ' + a.COMPANYNAME;
                prospectAccountOpty.Product__c = 'All Supplies';
                prospectAccountOpty.StageName = 'Verbal Win';
                prospectAccountOpty.Amount = 1;
                prospectAccountOpty.CloseDate = date.Today();
                prospectAccountOpty.Customer_Lifecycle__c = 'Acquisition';
                prospectAccountOpty.Accountid = prospectAccount.id;
                prospectAccountOpty.OwnerId = prospectAccount.OwnerId;
                insert prospectAccountOpty;
           }
        }
        catch(Exception e){
      Database.rollback(sp);
            a.STATUSMESSAGE = 'FAILURE';
            a.STATUSDESCRIPTION = e.getMessage();
        }
        return a;
    }
    //This method is used to get the not null set of an input string
    //Added by lalit for S-407229
    private static Set<String> getNotNullSet(String inputValue){
        if(inputValue != null && inputValue != ''){
            return new Set<String>{inputValue};
        }
        else{
            return new Set<String>();
        }
    }
    private static Integer getTotalEmployees(String inputValue){
        Integer totalEmplyees = 0;
        if(inputValue != null){
            List<String> range = inputValue.split('-');
            if(range.size() == 2){
                if(range[0] > range[1]){
                    totalEmplyees = Integer.valueOf(range[0]);
                }
                else{
                    totalEmplyees = Integer.valueOf(range[1]);
                }
            }
            if (inputValue.contains('+'))
               totalEmplyees = Integer.valueOf(inputValue.substring(0,inputValue.indexof('+')));
        }       
        return totalEmplyees;
    }
}