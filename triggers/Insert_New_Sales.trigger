//Covered by BizBoxNewSales_TC
trigger Insert_New_Sales on BizBox_Sales__c(before insert, before update , after insert, after update ) {
     recordtype getLeadRTs = [
                SELECT Id
                from recordtype
                where SobjectType = 'Lead'
                and developername = 'Lead_BizBox'
                limit 1
        ]; 
    if (trigger.isBefore && trigger.isInsert ) {
        List < BizBox_Sales__c > newSales = Trigger.New;
        List < String > emailsInSales = new List < String >();
   
        for (BizBox_Sales__c sales : newSales) {
        if(sales.Name!=sales.Business_Name__c)
            {
                sales.Name = sales.Business_Name__c;
            }
            if (sales.Email__c != null  && sales.Potential_Lead__c ==null && sales.Account__c == null  ) {                
                emailsInSales.add(sales.Email__c);
            }
        }
 
        
        
        recordtype getProsRTs = [
                SELECT Id
                from recordtype
                where SobjectType = 'Account'
                and developername = 'Prospect_BizBox'
                limit 1
        ];
        ID prospectBizBox = getProsRTs.id;
        RecordType getCustRTs = [
                SELECT Id
                from recordtype
                where SobjectType = 'Account'
                and developername = 'Customer_BizBox'
                limit 1
        ];
        
    
        ID customerBizBox = getCustRTs.Id;
         List < Account > accountsToUpdate = new List < Account >();
         List < BizBox_Sales__c > bbsToUpdate = new List < BizBox_Sales__c >();
        Set < ID > BBRT = Util.bizBoxRTIdsByObject('Account');
        Set < ID > BBLRT = Util.bizBoxRTIdsByObject('Lead');
        List < Account > relatedAccounts = new List < Account >();
          List < Lead > relatedLeads = new List < Lead >();
        if (emailsInSales.size() > 0) {
            relatedAccounts = [Select ID, BizBox_Email__c, Lastmodifieddate, RecordTypeId from Account where RecordTypeID in :BBRT and BizBox_Email__c in :emailsInSales];
            relatedLeads= [Select ID, email, Lastmodifieddate, RecordTypeId from lead where RecordTypeID in :BBLRT and Email in :emailsInSales];
        }
        System.debug('related');
        System.debug(relatedAccounts);

        Map < String, List < Account >> emailAccMap = new Map < String, List < Account >>();

        if (relatedAccounts.size() > 0 && emailsInSales.size() > 0) {
            for (String iEmail : emailsInSales) {
                if (iEmail != null) {
                    List < Account > mappedList = new List < Account >();
                    for (Account iAccount : relatedAccounts) {
                        if (iAccount.BizBox_Email__c == iEmail)
                            mappedList.add(iAccount);
                    }
                    if (mappedList.size() > 0) {
                        emailAccMap.put(iEmail, mappedList);
                    }
                }
            }
        }
        System.debug('accmap');
        System.debug(emailAccMap);
        
        Map < String, List < Lead >> emailLeadMap = new Map < String, List < Lead >>();

        if (relatedLeads.size() > 0 && emailsInSales.size() > 0) {
            
            for (String iEmail : emailsInSales) {
                if (iEmail != null && !emailAccMap.containsKey(iEmail)) {
                    List < Lead > mappedList = new List < Lead >();
                    for (Lead Ilead : relatedLeads) {
                        if (Ilead.Email == iEmail)
                            mappedList.add(Ilead);
                    }
                    if (mappedList.size() > 0) {
                        emailLeadMap.put(iEmail, mappedList);
                    }
                }
            }
        }
        for (BizBox_Sales__c sales : newSales) {
            //Go through each new sales, grab email map, if more than one acc grab recent, attach lookup. update record type on acc if needed.
            //
            List < Account > accountFromEmail = emailAccMap.get(sales.Email__c);
            if (accountFromEmail != null) {
                System.debug('Im in account from mail loop');
                Account recentAccount = accountFromEmail[0];
                for (Account iAccount : accountFromEmail) {
                    if (iAccount.LastModifiedDate >= recentAccount.LastModifiedDate) {
                        recentAccount = iAccount;
                    }
                }
                System.debug(recentAccount);
                sales.Account__c = recentAccount.id;

                if (recentAccount.RecordTypeId != customerBizBox) {
                    recentAccount.RecordTypeId = customerBizBox;
                    accountsToUpdate.add(recentAccount);
                }
            }
            
            List < Lead > leadFromEmail = emailleadMap.get(sales.Email__c);
            if (leadFromEmail != null) {
                Lead recentLead = leadFromEmail[0];
                for (Lead iLead : leadFromEmail) {
                    if (iLead.LastModifiedDate >= recentLead.LastModifiedDate) {
                        recentLead = iLead;
                    }
                }
                sales.Potential_Lead__c = recentLead.id;

                  }
        }
        update accountsToUpdate;
        }
        
        if(trigger.isAfter && trigger.isInsert  ) {
        
        
        
          List < Lead > LeadsToAdd = new List < Lead >();
          
           Group getBbbuyqueue = [ SELECT Id from Group where  Type = 'Queue' and developername ='BizBox_Buying_Queue' limit 1];
             ID BQxx = getBbbuyqueue.id;
        
             for (BizBox_Sales__c sales :  Trigger.New) {
                system.debug('sales.Email__c ' +sales.Email__c + ' sales.Potential_Lead__c ' +sales.Potential_Lead__c  +' sales.Account__c ' + sales.Account__c );
                if (sales.Email__c != null  && sales.Potential_Lead__c == null && sales.Account__c == null  ) {      
                 
                Lead nlead  = new Lead();
                nLead.email = sales.Email__c;
                nLead.Company =  sales.Business_Name__c;
                nLead.LastName =  sales.Business_Name__c;
                nLead.ownerid =  BQxx;
                nLead.recordtypeid= getLeadRTs.id;
                nLead.leadSource = 'BizBox Order';
                LeadsToAdd.add(nLead);
              
            }
            
            
        }
        
         insert LeadsToAdd;
       

        
        
        
    }
    
   
    else if (trigger.isBefore && trigger.isUpdate)
    {
        Set < ID > BBRT = Util.bizBoxRTIdsByObject('Account');
        recordtype getProsRTs = [
                SELECT Id
                from recordtype
                where SobjectType = 'Account'
                and developername = 'Prospect_BizBox'
                limit 1
        ];
        ID prospectBizBox = getProsRTs.id;
        RecordType getCustRTs = [
                SELECT Id
                from recordtype
                where SobjectType = 'Account'
                and developername = 'Customer_BizBox'
                limit 1
        ];
        ID customerBizBox = getCustRTs.Id;
        List < BizBox_Sales__c > salesList = Trigger.New;
        List < ID > accIDs = new List < ID >();
        for (BizBox_Sales__c sales : salesList) {
            if (sales.Account__c != null)
            {
                accIDs.add(sales.Account__c);
            }
        }
        List < Account > relatedAccounts = new List < Account >();
        List < Account > accountsToUpdate = new List < Account >();
        
        if (salesList.size() > 0) {
            relatedAccounts = [Select ID, BizBox_Email__c, Lastmodifieddate, RecordTypeId from Account where RecordTypeID in :BBRT and ID in  :accIDs];
        }
        
        for(Account myAcc : relatedAccounts)
        {
            if (myAcc.RecordTypeId != customerBizBox) {
                    myAcc.RecordTypeId = customerBizBox;
                    accountsToUpdate.add(myAcc);
                }            
        }
        
        Update accountsToUpdate;
        
    }
    
}