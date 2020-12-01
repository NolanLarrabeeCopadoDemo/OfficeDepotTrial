public class SendforCustomerApprovalCtrl {
    @AuraEnabled
    public static boolean getCustomerCommunication(String prosquoteId) {
        boolean customerCommunicationNotRequired;
        List<CameleonCPQ__QxQuote__c> lstOfQuote = new List<CameleonCPQ__QxQuote__c> ();
        CameleonCPQ__QxQuote__c pq= [SELECT Id,Customer_Approval_Received_Date__c,New_Contract_Amendment_DOA__c,Customer_Response__c,Customer_communication_requirements__c,CameleonCPQ__AccountId__r.Name,OwnerId,Send_for_Customer_Approval__c, Customer_Approval_Status__c,Send_Date_for_Customer_Approval__c ,Send_for_Customer_Notification__c ,Customer_approval_is_received__c,Customer_Doc_ID__c,Core_Id__c FROM CameleonCPQ__QxQuote__c WHERE id =: prosquoteId];
        if(pq.Customer_communication_requirements__c == 'None' || pq.New_Contract_Amendment_DOA__c == true) {
            system.debug('the customer communication req:'+pq.Customer_communication_requirements__c);
            customerCommunicationNotRequired = true;  
            pq.Customer_Approval_Status__c = 'Approved';
            pq.Customer_Approval_Received_Date__c = system.TODAY();
            pq.Customer_Response__c = 'Auto Approved ';
            lstOfQuote.add(pq);
             updateQuoteCustomerReq(lstOfQuote);
        }else {
                        system.debug('the customer communication req not none:'+pq.Customer_communication_requirements__c);
            customerCommunicationNotRequired = false ;   
        }
       
        return customerCommunicationNotRequired;
    }
    @AuraEnabled(cacheable=true)
    public static boolean getDocuments(String prosquoteId) {
        Boolean noDocs;
        CameleonCPQ__QxQuote__c pq= [SELECT Id,Customer_communication_requirements__c,CameleonCPQ__AccountId__r.Name,OwnerId,Send_for_Customer_Approval__c, Customer_Approval_Status__c,Send_Date_for_Customer_Approval__c ,Send_for_Customer_Notification__c ,Customer_approval_is_received__c,Customer_Doc_ID__c FROM CameleonCPQ__QxQuote__c WHERE id =: prosquoteId];
        List<ContentDistribution> cdLst = new List<ContentDistribution>();
        List<ContentDocumentLink> contnDocLnkLst= new List<ContentDocumentLink>();
        if(pq.Customer_Doc_ID__c != null) {
            cdLst= [select contentversionid,contentdocumentid,ContentDownloadUrl,DistributionPublicUrl,Name from ContentDistribution where contentdocumentid = :pq.Customer_Doc_ID__c ];
            system.debug('the content doc list is:'+cdLst);  
            
        } else {
            contnDocLnkLst = [select ContentDocumentId,LinkedEntityId from ContentDocumentLink where LinkedEntityId = :pq.Id order by SystemModstamp desc limit 1];
            system.debug('the contentlink list is:'+contnDocLnkLst);            
        }
        if(contnDocLnkLst.size() > 0 || cdLst.size() > 0) {
            noDocs = false;
        } else
        {
            noDocs = true;
        }
        system.debug('there are no docs:'+noDocs);
        return noDocs;
    }
    
    @AuraEnabled(cacheable=true)
    public static List<Contact> getContacts(String prosquoteId) {
        List<contact> contactsLst = new List<contact> ();
        List<String> contactRtrnLst = new List<String> ();
        Map<string,string> mapOfContactsRoles = new Map<string,string> ();
        try {
            CameleonCPQ__QxQuote__c ProsQuoRec =[SELECT Id,CameleonCPQ__AccountId__c FROM CameleonCPQ__QxQuote__c WHERE id =: prosquoteId];
            for(contact c: [select id, Role__c, firstName , LastName , title , Phone, email , Account.Name from contact where AccountId =: ProsQuoRec.CameleonCPQ__AccountId__c and Role__c includes('Price Change Approver' , 'Price Change Notification/Viewer') Limit 200]) {
                contactsLst.add(c);  
            }
        }
        catch(Exception e) {
            throw new AuraHandledException('An error ocurred while fetching the contacts.');   
        }
        system.debug('the contact list is:'+contactsLst);
        return contactsLst;
    }
    @AuraEnabled
    public static String sendEmail(String slctdId,String prosquoteId) {
        List<SObject> recs = new List<SObject> ();
        List<Orion_Customer_MailOut__c> lstOFOrionRecords = new List<Orion_Customer_MailOut__c> ();
        List<CameleonCPQ__QxQuote__c> QuotesToBUpdtd = new List<CameleonCPQ__QxQuote__c> ();
        List<SiteContacts__c> lstOfSitecons= new List<SiteContacts__c>();
        ContentDistribution cd = new ContentDistribution();
        ContentDocumentLink cl= new ContentDocumentLink();
        CameleonCPQ__QxQuote__c pq= [SELECT Id,Customer_communication_requirements__c,CameleonCPQ__AccountId__r.Name,OwnerId,Send_for_Customer_Approval__c, Customer_Approval_Status__c,Send_Date_for_Customer_Approval__c ,Send_for_Customer_Notification__c ,Customer_approval_is_received__c,Customer_Doc_ID__c FROM CameleonCPQ__QxQuote__c WHERE id =: prosquoteId];
        String accName= '%' +  pq.CameleonCPQ__AccountId__r.Name + '%';
        if(pq.Customer_Doc_ID__c != null) {
            cd= [select contentversionid,contentdocumentid,ContentDownloadUrl,DistributionPublicUrl,Name from ContentDistribution where contentdocumentid = :pq.Customer_Doc_ID__c and Name like : accName ];
            system.debug('the contentdisti is:'+cd);
        } else {
            cl = [select ContentDocumentId,LinkedEntityId from ContentDocumentLink where LinkedEntityId = :pq.Id order by SystemModstamp desc limit 1];
            cd= [select contentversionid,contentdocumentid,DistributionPublicUrl,ContentDownloadUrl,Name from ContentDistribution where contentdocumentid = :cl.contentdocumentid and Name like : accName ];
            system.debug('the contentdisti is:'+cd);
            
        }
        
        User u= [select id, firstname,lastname ,Email from user where id= : pq.OwnerId];
        contact c= [select id,email,AccountID from contact where id= : slctdId.replaceAll('[^a-zA-Z0-9\\s+]', '')];
        lstOFOrionRecords.add(new Orion_Customer_MailOut__c(Contact__c = c.Id,
                                                            PROS_Quote__c = prosquoteId,
                                                            Customer_Approval_Status__c = pq.Customer_Approval_Status__c,
                                                            Rep_First_Name__c = u.FirstName,
                                                            Rep_Last_Name__c = u.LastName,
                                                            Rep_Email__c = u.Email,
                                                            Email__c = c.Email,
                                                            URL__c = cd.DistributionPublicUrl) );
        for(CameleonCPQ__QxQuote__c prosquo: [SELECT Id,Customer_communication_requirements__c,Send_for_Customer_Approval__c, Customer_Approval_Status__c,Send_Date_for_Customer_Approval__c ,Send_for_Customer_Notification__c ,Customer_approval_is_received__c FROM CameleonCPQ__QxQuote__c WHERE id =: prosquoteId]) {            
            if(pq.Customer_communication_requirements__c == 'Notification' ) {
                QuotesToBUpdtd.add(new CameleonCPQ__QxQuote__c(id=prosquo.Id ,Send_for_Customer_Approval__c = true
                                                               ,Send_Date_for_Customer_Approval__c = System.today(),
                                                               Send_for_Customer_Notification__c = true,
                                                               Customer_approval_is_received__c = 'Auto Approved',
                                                               Customer_Response__c = 'Auto Approved',
                                                               Customer_Approval_Status__c = 'Approved',Customer_email__c = c.Email));   
            }
            else if(pq.Customer_communication_requirements__c == 'Notification & Approval' ) {
                QuotesToBUpdtd.add(new CameleonCPQ__QxQuote__c(id=prosquo.Id ,Send_for_Customer_Approval__c = true
                                                               ,Send_Date_for_Customer_Approval__c = System.today(),
                                                               Send_for_Customer_Notification__c = true,
                                                               //Customer_approval_is_received__c = 'Auto Approved',
                                                               Customer_Approval_Status__c = 'Submitted',Customer_email__c = c.Email));   
            }
        }
        createOrion(lstOFOrionRecords);
        update QuotesToBUpdtd;
        return 'success';    
    }
    
    @AuraEnabled(cacheable=true)
    public static List<contact> searchForContacts(String FName,String LName,String Email,String Phone,String Role,String prosquoteId) {
        List<contact> contactList = new List<Contact> ();
        try {
            CameleonCPQ__QxQuote__c prosQuote= [select id,CameleonCPQ__AccountId__c from CameleonCPQ__QxQuote__c where id=:prosquoteId];
            if ((fName != null && fName != '') || (LName != null && LName != '')  || (Email != null && Email != '') || (Phone != null && Phone != '') || (Role != null && Role != '') ) {
                for( Contact x: [Select id,firstname,lastname,email,phone,Role__c,Account.Name from contact where  AccountID = : prosQuote.CameleonCPQ__AccountId__c and Role__c includes('Price Change Approver' , 'Price Change Notification/Viewer') limit 100]) {
                    if(fName != null  && x.firstname != null) {
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
                    if(Role!=null && x.Role__c != null) {
                        if(x.Role__c.containsIgnoreCase(Role))
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
        Set<Id> contactIds = new Set<Id>();
        for(contact con: contactList){
            contactIds.add(con.Id);
        }
        List<contact> conList = [Select id,firstname,lastname,email,phone,Role__c,Account.Name from contact where Id in: contactIds];
        return conList;
    }
    @AuraEnabled
    public static string savecontact(String prosquoteId,String conID) {
        string strSuccessMsg = 'success';
        List<Contact> conLst = new List<contact> ();
        String recType= label.TechSalesContactRecordtype;
        try {
            CameleonCPQ__QxQuote__c prosQuote= [select id,CameleonCPQ__AccountId__c from CameleonCPQ__QxQuote__c where id=:prosquoteId];
            Recordtype r=[SELECT Id, Name, DeveloperName FROM RecordType WHERE DeveloperName =: recType];
            conLst.add(new Contact(id=conID,
                                   accountId =prosQuote.CameleonCPQ__AccountId__c)); 
            update conLst;
        }
        catch(Exception e) {
            //throw new AuraHandledException('An error ocurred when you are trying to save a contact. Please contact your administrator.');
            strSuccessMsg = 'An error ocurred when you are trying to save a contact. Please contact your administrator. Error: ' + e.getMessage();
        }
        return strSuccessMsg;
    }
    public static void createOrion(List<Orion_Customer_MailOut__c> lstToBInsrtd) {
        insert lstToBInsrtd;
    }
    public static void updateQuoteCustomerReq(List<CameleonCPQ__QxQuote__c> lstToBUpdtd) {
        system.debug('the method is being called'+lstToBUpdtd);
        update lstToBUpdtd;
    }
}