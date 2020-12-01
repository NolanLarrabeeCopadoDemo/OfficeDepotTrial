public class ClosingLeads{
    public String strName {get;set;}
    public String strLastName {get;set;}
    public String strCompany {get;set;}
    public String strEmail {get;set;}
    public String strEmailDomain {get;set;}
    public String strPhone {get;set;}
    public String strZip {get;set;}
    public String strState {get;set;}
    public Boolean matchingAccountsFound {get; set;}
    List<Account> listAccounts = new List<Account>();
    Id Cust = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Customer').getRecordTypeId();
    Id Prospect = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Prospect').getRecordTypeId();
    Id ProspectMX = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Prospect (OfficeMax)').getRecordTypeId();
    Id CustMX = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Customer (OfficeMax)').getRecordTypeId();
    //Modified By Vipul Jain for Story#S-440209 [00810890 - Lead & Account De-Duplication Notification] on 7, October, 2016
    //START
    public set<String> LeadSourceSet = new set<String>{'Customer Service', 'BSD NET', 'BSD Auto Account Setup','Store Lead'};
    //END
    //Modified By Vipul Jain for Story#S-445693 [00802435 - BP Enhancement - Digital Lead Form] on 19, October, 2016
    //START
    Map<String,Account> keyAndListAccountMap = new Map<String,Account>();
    Set<String> CompanyNameSet = new Set<String>();
    Set<String> ZipSet = new Set<String>();
    Set<String> StateSet = new Set<String>();
    String whereClause = '';
    String andClause = '';
    String  orClause = '';
    String KeySet='';
    public  void searchAccounts(List<Lead> leads){
        for( Lead leadrec: Leads){
            strName = leadrec.Name;
            strCompany = leadrec.Company;
            strZip = leadrec.Zip_5digit__c;
            strState = leadrec.State__c;
            listAccounts.clear();
            if( strCompany != null && strCompany.trim() != ''){
                strCompany = '\''+String.escapeSingleQuotes(strCompany.trim())+'\'';
                CompanyNameSet.add(strCompany);
            }
            if( strZip != null && strZip.trim() != ''){
                strZip =  '\'' +String.escapeSingleQuotes(strZip.trim())+ '\'' ;
                ZipSet.add(strZip);
             }
            if( strState != null && strState.trim() != ''){
                strState =  '\''+ String.escapeSingleQuotes(strState.trim()) +'\'' ;
                StateSet.add(strState);
             }

        }
        //case#844865 changes - starts
        
        String strQuery = 'Select Id,owner.id,owner.manager.id,owner.manager.isActive,Owner.Name,Owner.Email,Owner.isActive,Owner.Title, Status__c,Zip_5digit__c, State__c, Stage__c, Zip__c, RecordType.Name, RecordTypeId, OwnerId, Name, LastActivityDate, City__c, Address1__c, AOPS_Cust_Id__c,Cust_ID__c From Account where (recordtypeid=:Cust or recordtypeid=:Prospect or recordtypeid=:CustMX or recordtypeid=:ProspectMX)  and ';
        Map<String,list<Account>> keyAccts = new Map<String,List<Account>>();
        Boolean ownerFound = true;
        Map<String,String> sysUsersMap = new Map<String,String> ();
        for (System_Users__mdt u: [select Label,QualifiedApiName,UserID__c from System_Users__mdt]) {
            sysUsersMap.put(u.UserID__c,u.Label);
        }
        //case#844865 changes - ends
        List<String> ZipList = new List<String>();
        ZipList.addAll(ZipSet);
        List<String> CompanyNameList = new List<String>();
        CompanyNameList.addAll(CompanyNameSet);
        List<String> StateList = new List<String>();
        StateList.addAll(StateSet);

        if(ZipSet.size()>0)
            orClause = orCondition(orClause, 'Zip_5digit__c', ZipList );
        if(CompanyNameSet.size()>0)
            orClause = orCondition(orClause, 'Name', CompanyNameList );
        if(StateSet.size()>0)
            orClause = orCondition(orClause, 'State__c', StateList);
        if(orClause != ''){
            strQuery = strQuery + orClause  + ' LIMIT 100';
            listAccounts = Database.query(strQuery);

        }

        for(Lead leadrec: Leads){
        
            if(leadrec!=null){
                strName = leadrec.Name;
            strCompany = leadrec.Company;
            strZip = leadrec.Zip_5digit__c;
            strState = leadrec.State__c;
            String KeyCheck = '';
            KeyCheck = getUniqueKey(leadrec.Company, leadrec.Zip_5digit__c, leadrec.State__c);
            
            for(Account accounts : listAccounts){
                 if( strCompany != null && strCompany.trim() != ''){
                    if( (strZip != null && strZip.trim() != '') && ( strState != null && strState.trim() != '') ){
                        KeySet = getUniqueKey(accounts.Name, accounts.Zip_5digit__c, accounts.State__c);
                    }
                    else if(strZip != null && strZip.trim() != ''){
                        KeySet = getUniqueKey(accounts.Name, accounts.Zip_5digit__c, '');
                    }
                    else if( strState != null && strState.trim() != ''){
                        KeySet = getUniqueKey(accounts.Name, '', accounts.State__c);
                    }
                    else
                        KeySet = 'uncheck';
                 }
                
                //case#844865 changes - starts
                if(!keyAndListAccountMap.containsKey(KeySet))  {
                    keyAndListAccountMap.put(KeySet, accounts);
                    
                    list<account> tmpAccts = new list<account>();
                    tmpAccts.add(accounts);
                    keyAccts.put(keySet,tmpAccts);
                
                } else {
                    keyAccts.get(keySet).add(accounts);
                    
                }
                //case#844865 changes - ends
            }
                Account account = keyAndListAccountMap.get(KeyCheck);
                ownerFound = true;
                
                if(account != null && leadrec.recordtypeid != System.label.Lead_Business_Pro){
                    
                    leadrec.sub_status__c = 'Account Duplicate';
                    leadrec.account__c = account.ID;
                    leadrec.OwnerId = account.OwnerID;
                    //Modified By Vipul Jain for Story#S-440209 [00810890 - Lead & Account De-Duplication Notification] on 7, October, 2016
                    //START
                    
                    //case#844865 changes - starts
                    ID newOwnerID;
                    if (!account.Owner.isActive || sysUsersMap.containsKey(account.OwnerID)) {
                        system.Debug('Current Owner is Inactive');
                        ownerFound = false;
                        if (account.Owner.manager.isActive) {
                            system.debug('Assign manager as owner');
                            leadRec.ownerId=account.owner.manager.ID;
                            ownerFound=true;
                        }
                        else {
                            for (Account a : keyAccts.get(keyCheck)) {
                                if (a.owner.manager.isActive) {
                                    leadRec.ownerId=a.owner.manager.id;
                                    leadrec.account__c = a.id;
                                    ownerFound=true;
                                    break;
                                
                                }
                            }
                        }
                        
                        // if manager is inactive
                        
                        if (!ownerFound) {
                            for (group g: [Select Id,name from Group where Type = 'Queue' and name='Lead Triage']) {
                                leadrec.ownerId=g.Id;
                                break;
                            }
                        }
    
                    }

                    
                    if (ownerFound) {
                      for (sales_person__c s:[select id,ExtIDSalesPerson__c from sales_person__c where user__c=:leadrec.ownerId and IsActive__c=true and Primary__c=true limit 1]) {
                                leadrec.Sales_Person_ID__c = s.id;              
                            }
                    }
                    //case#844865 changes - ends
                    if(account.Owner.IsActive && account.Owner.Title !=''
                                && account.Owner.Title !=null && LeadSourceSet.contains(leadrec.LeadSource)){
                        leadrec.Status = 'Closed';
                        leadrec.Closed_Date__c = system.today();
                        leadrec.Close_Reason__c = 'Current Customer';
                        leadrec.IsDuplicateAccount__c =true;
                    }
                    //END - Vipul
                }
            }
        }

    }
    // This method is to append the where condition for the Query from that account object
    private String orCondition(String orClause, String fieldName, List<String> fieldValue){
        String retValue = '';
        if(orClause != '')
            retValue = orClause + ' AND ' + fieldName + ' IN' + fieldValue ;
        else
            retValue = fieldName + ' IN' + fieldValue;
            return retValue;
    }

    // This method is to populate the key which will help to generate unique key
    private String populateKey(String key, String fieldName){
        String retValue = '';
        if(key != '')
            retValue = key + ' # ' + fieldName;
        else
            retValue = fieldName;
        return retValue;
    }

    // This method is to get an unique Key
    private String getUniqueKey(String strCompany, String strZip, String strState){
      String key = '';

      if(strCompany != null && strCompany.trim() != ''){
        key = populateKey(key, strCompany);
      }

      if(strZip != null && strZip.trim() != ''){
        key = populateKey(key, strZip);
      }

      if( strState != null && strState.trim() != ''){
        key = populateKey(key, strState);
      }
      return key;

    }


    //END Vipul S-445693 [00802435 - BP Enhancement - Digital Lead Form]
    //Modified By Vipul Jain for Story#S-440209 [00810890 - Lead & Account De-Duplication Notification] on 7, October, 2016
    //START
    public void sendEmails(List<Lead> newLead, Map<Id, Lead> leadIdAndLeadMap){
            List<Messaging.SingleEmailMessage> mails =   new List<Messaging.SingleEmailMessage>();
            for(Lead leadrec : newLead){
            String baseUrl = System.URL.getSalesforceBaseUrl().toExternalForm();
            String url = baseUrl+'/' +leadrec.id;
            String startDate=string.valueof(system.now().date());
            String startTime = string.valueof(system.now().time());
            startTime = startTime.substring(0,8);
            Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
            List<String> toAddresses = new List<String>();
            toAddresses.add(leadIdAndLeadMap.get(leadrec.Id).Account__r.Owner.Email);
            mail.setToAddresses(toAddresses);
            String Subject = 'Duplicate Record For :';
            mail.setSubject(Subject + leadIdAndLeadMap.get(leadrec.Id).Account__r.Name);
            String Body= '<html><body>Dear'+'&nbsp;' + leadIdAndLeadMap.get(leadrec.Id).Owner.Name +','+
                        ' <br><br>A lead has attempted to create an account through '+
                        leadrec.LeadSource+' at ' + startTime +
                        ' on '+ startDate+' and has been identified as a duplicate record with the following customer account information:'+
                        ' <br><br>Account Name:'+ leadIdAndLeadMap.get(leadrec.Id).Account__r.Name +
                        ' <br><br>Customer ID:'+ leadIdAndLeadMap.get(leadrec.Id).Account__r.Cust_ID__c +
                        ' <br><br>Account Owner:'+ leadIdAndLeadMap.get(leadrec.Id).Owner.Name +
                        ' <br><br>Please contact this lead as soon as possible for a potential opportunity:'+
                        ' <br><br>Contact First Name:'+ leadrec.FirstName+
                        ' <br><br>Contact Last Name:'+ leadrec.LastName+
                        ' <br><br>Contact Phone:'+ leadrec.Phone +
                        ' <br><br>Contact Email: '+'&nbsp;' + leadrec.Email +
                        ' <br><br>Link to lead:'+url+
                        ' <br><br>Thank you and happy selling,'+
                        ' <br><br>The Office Depot Salesforce Team</body></html>';
            mail.setHTMLBody(Body);
            mails.add(mail);
            }
            if(mails.size()>0)
            Messaging.sendEmail(mails);


    }
    //END
}