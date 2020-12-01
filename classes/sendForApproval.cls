public class sendForApproval {
    /*Recieve quote ID , query Quote to get Bill to Account and ship to Account
* Add accouts to a set and get the site contacts attached to the sites in the SiteContact object and add it to a list
* Query the contact object to retrieve individual fields
* Return contacts
*/
    @AuraEnabled(cacheable=true)
    public static List<Contact> getContacts(String quoteId) {
        List<Id> contactIds = new List<Id> ();
        List<contact> contactRtrnLst = new List<contact> ();
        Set<Id> setOfSiteAccontIDs = new Set<ID> ();
        system.debug('the quote id is while fetching contacts is:'+quoteId);
        try {
            Quote q= [select id,AccountId,Bill_To_Account__c,Ship_To_Account__c from quote where id=:quoteId];
           // setOfSiteAccontIDs.add(q.Bill_To_Account__c);
            setOfSiteAccontIDs.add(q.Ship_To_Account__c);
            system.debug(' the set of accounts is:-step 1'+setOfSiteAccontIDs);
            List<SiteContacts__c> siteContactLst = new List<SiteContacts__c> ([select id,Contact__c from SiteContacts__c where Account__c IN : setOfSiteAccontIDs limit 200]);
            for(SiteContacts__C sc:siteContactLst) {
                contactIds.add(sc.Contact__c);
            }
            for(contact c: [select id, firstName , LastName , title , Phone, email , Account.Name from contact where Id IN : contactIds Limit 200]) {
                contactRtrnLst.add(c);
            }
            system.debug(' the list of site contacts attached to sites are:'+contactRtrnLst);  
        }
        catch(Exception e) {
            throw new AuraHandledException('An error ocurred while fetching the contacts.');   
        }
        return contactRtrnLst;
    }
    /*Recieve quote ID , query Quote to get contentversion Id of the Quote Document
* Add it to a list and query on ContentDistribution object 
* Return ContentDistribution
*/
    @AuraEnabled(cacheable=true)
    public static List<ContentDistribution> getDocuments(String quoteId) {
        List<Id> lstOfIds = new List<Id> ();
        List<ContentDistribution> cntndstrbtn = new List<ContentDistribution> ();
        try {
            for(QuoteDocument q:[select ContentVersionDocumentId,Name from quotedocument where quoteid =:quoteId]) {
                lstOfIds.add(q.ContentVersionDocumentId);
            }
            cntndstrbtn =[select id,contentversionid,Name,ContentDownloadUrl from ContentDistribution where contentversionid IN : lstOfIds];
        } 
        catch(Exception e) {
            throw new AuraHandledException('An error ocurred while fetching the Documents');
        }
        return cntndstrbtn; 
    }
    /* Recieves selected contact id , quote id and selected document id
* Query on contentdistribution and create a customer approval information record 
* Update the quote with all the backend fields and contact information of selected customer
* If site contact doesnt exist for the contact selected by rep, create it in a future method
* */
    @AuraEnabled
    public static String sendEmail(String slctdId,String quoteId, String docId) {
        system.debug('For sending email:the selected document id is:'+slctdId+'Quote id is:'+quoteId+'docid '+docId);
        List<Quote> QuotesToBUpdtd = new List<Quote> ();
        List<SiteContacts__c> lstOfSitecons= new List<SiteContacts__c>();
        try {
            contentdistribution cd= [select id,ContentDownloadUrl,DistributionPublicUrl from Contentdistribution where contentversionid=:docId.replaceAll('[^a-zA-Z0-9\\s+]', '')];
            Customer_Approval_EA__c custmrapprvlinfrmtn= new Customer_Approval_EA__c();
            custmrapprvlinfrmtn.Customer_Approval_Status__c = label.customerApprovalInfoStatus;
            custmrapprvlinfrmtn.ParentQuote__c = quoteId;
            custmrapprvlinfrmtn.Content_Document_URL__c = cd.DistributionPublicUrl ;
            insert custmrapprvlinfrmtn;
            system.debug('the inserted customer approval information record is:'+custmrapprvlinfrmtn);
            contact c= [select id,email,AccountID from contact where id= : slctdId.replaceAll('[^a-zA-Z0-9\\s+]', '')];
            for(Quote q: [select id,Email,Sent_For_Customer_ApprovalDate__c,ContactId,Sent_For_Customer_Approval__c,Customer_Doc_ID__c,Id_Of_CAI_when_Email_Sent__c from Quote where id= :quoteId] ){
                q.ContactId = c.ID;
                q.Sent_For_Customer_ApprovalDate__c = system.today();
                q.Sent_For_Customer_Approval__c = true;
                q.Email  = c.email;
                q.Customer_Doc_ID__c = docId.replaceAll('[^a-zA-Z0-9\\s+]', '');
                q.Id_Of_CAI_when_Email_Sent__c = custmrapprvlinfrmtn.Id;
                q.Status = System.Label.Status_of_Techquote;
                QuotesToBUpdtd.add(q);
            }
            system.debug('Updating the List of quotes'+QuotesToBUpdtd);
            update QuotesToBUpdtd;
            lstOfSitecons= [select id,Account__c,Contact__c from SiteContacts__c where Contact__c =: c.Id and Account__c =: c.AccountId];
            if(lstOfSitecons.isEmpty()) {
                system.debug('there is no sitecontact,so call the saveSitecontact method');
                saveSitecon(c.Id,c.AccountId);
            }
        } catch (Exception e) {
            throw new AuraHandledException('An error ocurred when you are trying to send an email. Please contact your administrator.');  
        }
        return 'success';    
    }
    /*Recieves the fields entered for searching a contact
* Query on Quote to get the Account Id
* Query contact object for the value entered firstname/lastname and should be tied to account retrieved in second step
* List of contacts are returned
* */
    @AuraEnabled(cacheable=true)
    public static List<contact> searchForContacts(String FName,String LName,String Email,String Phone,String quoteId) {
        system.debug('Searching Contacts:the first name recieved is:'+fName +'the last name is:'+LName+'the email entered is'+Email+'the phone entered is'+Phone+'the quote Id is:'+quoteId);
        List<contact> contactList = new List<Contact> ();
        Set<Id> setOfAccontIDs = new Set<ID> ();
        try {
            Quote q= [select id,AccountId from quote where id=:quoteId];
            setOfAccontIDs.add(q.AccountId);
            if ((fName != null && fName != '') || (LName != null && LName != '')  || (Email != null && Email != '') || (Phone != null && Phone != '') ) {
                for( Contact x: [Select id,firstname,lastname,email,phone,Account.Name from contact where  AccountID In : setOfAccontIDs ]) {
                    if(fName != null  && x.firstname != null) {
                        system.debug('the firstname from query is'+x.firstname.toUpperCase()+'the first name from rep is:'+fName.toUpperCase());
                        if(x.firstname.toUpperCase().trim().indexOf(fName.toUpperCase().trim()) != -1) {
                            contactList.add(x);
                        }
                    }
                    if(LName!= null && x.lastname != null ) {
                        if( LName!= null && x.lastname.toUpperCase().trim().indexOf(LName.toUpperCase().trim()) != -1) {
                            contactList.add(x);
                        } 
                    }
                    if(Email!=null && x.email != null) {
                        if( x.email.toUpperCase().trim().indexOf(Email.toUpperCase().trim()) != -1){
                            contactList.add(x);
                        } 
                    }
                    if(Phone!=null && x.phone != null) {
                        if( x.phone.trim().indexOf(Phone.trim()) != -1)
                        {
                            contactList.add(x);
                        }
                    }
                }
                system.debug('Search contacts:the size of list is'+contactList.size());
            } 
            
        } 
        Catch(Exception e) {
            throw new AuraHandledException('An error ocurred when you are trying to search for a contact. Please contact your administrator.');    
        }
        return contactList;
    }
    /* Recieve quote id and all the fields entered by rep to create contact
* fetch recordtype name for contact from custom labe;
* query on recordtype object to get recordtype id
* query on quote to get the ship to account
* create a contact and site contact attached customer account and to the ship to account
* */
    @AuraEnabled
    public static string savecontact(String firstName,String lastName,String Email,String Phone,String QuoId) {
        system.debug('Add contact:the firstname'+firstName+'the last name'+lastName+'the email entered is'+Email+'the phone entered is:'+Phone);
        String recType= label.TechSalesContactRecordtype;
        try {
            Quote q= [select id,AccountId,Ship_To_Account__c from quote where id=:QuoId];
            Recordtype r=[SELECT Id, Name, DeveloperName FROM RecordType WHERE DeveloperName =: recType];
            contact c = new Contact();
            c.recordtypeid = r.Id;
            c.firstName = firstName;
            c.LastName = lastName;
            c.Email = Email;
            c.Phone = phone;
            c.accountId = q.AccountId;
            insert c;
            saveSitecon(c.Id,q.Ship_To_Account__c);
        }
        catch(Exception e) {
            throw new AuraHandledException('An error ocurred when you are trying to search for a contact. Please contact your administrator.');       
        }
        
        return 'success';
    }
    /* save contact to SiteContact object
* 
* */
    @future
    public static void saveSitecon(String conID,String AccId) {
        String contID=label.TechSalesCon;
        String AcctId=label.TechSalesAcc;
        SiteContacts__c s = new SiteContacts__c();
        if(AccId.startsWith(AcctId)) {
            s.Account__c = AccId; 
        } 
        if(conID.startsWith(contID)) {
            s.Contact__c =  conID;  
        }
        system.debug('site contact inserted'+s);
        insert s; 
    }
}