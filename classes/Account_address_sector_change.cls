/***
Description: The Scope of this Class is Account Object(prospect/customer & Site).This will update prospect/customer addresses
based on primary site address & update Sites with their parent customer's Sector,Segment, Buying_group values.
Functionality of the Batch program is:
1. Records will processed to check if the site address is changed. 
2. If the address is changed then the Parent address will be updated with the primary site address.
                            OR
1. Records will processed to check if the Customer/Prospect Sector,Segment, Buying_group values is changed.
2. If the Sector,Segment, Buying_group values is changed then the Sites will be updated with the Parent Sector,Segment, Buying_group values.

Created By: Ankur Pradhan
Created Date: 03-May-2012

Modified By:
Modified Date:

Modify Reason:
**/
global class Account_address_sector_change
{
   
   global void Account_addr_Sect_change (List <Account> triggernewacc)
   {    
        
        Map <id,Account>  sitesid_cust_map  = new Map <id,Account> ();
        List<Account> lstcustomer = new List <account> (); // Customers or prospects related to Sites
        List<Account> lstsites = new List <account> (); // Sites related to Customers or prospects
        List<Account> listAccount_cust = new List <account> (); // Customers or prospects to be updated
        List<Account> listAccount_sites = new List <account> (); // sites to be updated
        Account acs = new Account();
        Set<ID> setacc_add_custIds = new Set<ID>(); // customer or prospects ids for address change
        Set<ID> setacc_sect_custIds = new Set<ID>(); // customer or prospects ids for sector change
        
        //For getting the set of customer or prospects ID related to the sites 
        for(account a: triggernewacc)
        {
            if(a.Primary_Site__c == true)
             {
                 system.debug('a.Related_Account__c============'+ a.Related_Account__c);
                 setacc_add_custIds.add(a.Related_Account__c);
             }
             else
             {
                 setacc_sect_custIds.add(a.id);
             }
        }
        
        if(setacc_add_custIds.size()>0)
        { 
            
                lstcustomer = [Select Id, Name, RecordTypeId , Address1__c, Address2__c, City__c, State__c, zip__c, Country__c, County__c,Primary_Site__c  from Account where id in: setacc_add_custIds];
        }
        if(setacc_sect_custIds.size()>0)
        {
            lstsites = [Select Id, Name, RecordTypeId ,  Related_Account__c, Buying_Group__c, Sector__c, Segment__c, Primary_Site__c  from Account where  Related_Account__c in: setacc_sect_custIds];
        }
        
        if(lstcustomer.size()>0)
        {
            for (Account ac:triggernewacc)
            {
               for(account acust: lstcustomer)
                {
                    if(ac.Related_Account__c==acust.id)
                    {
                        sitesid_cust_map.put(ac.id,acust);
                        break;
                    }
                }
           }
        }
        
        for(account a: triggernewacc)
        {
            if(sitesid_cust_map.size()>0)
            {
                ID aid =a.id;
                acs=sitesid_cust_map.get(aid);
                system.debug('acs'+acs);
                system.debug('a'+a);
                if(acs.Address1__c!=a.Address1__c||acs.Address2__c!=a.Address2__c||acs.City__c!=a.City__c||acs.State__c!=a.State__c||acs.zip__c!=a.zip__c||acs.County__c!=a.County__c||acs.Country__c!=a.Country__c)
                {
                    acs.Address1__c=a.Address1__c;
                    acs.Address2__c=a.Address2__c;
                    acs.City__c=a.City__c;
                    acs.State__c=a.State__c;
                    acs.zip__c=a.zip__c;
                    acs.Country__c=a.Country__c;
                    acs.County__c=a.County__c;
                    listAccount_cust.add(acs);
                }
            }
            else
            {
                for(account asite: lstsites)
                {
                    if(asite.Related_Account__c==a.id)
                    {
                        if(asite.Buying_Group__c!=a.Buying_Group__c||asite.Sector__c!=a.Sector__c||asite.Segment__c!=a.Segment__c)
                        {
                            asite.Buying_Group__c=a.Buying_Group__c;
                            asite.Sector__c=a.Sector__c;
                            asite.Segment__c=a.Segment__c;
                            listAccount_sites.add(asite);
                        }
                    }
                }
            }
        }
        
        if(listAccount_cust.size()>0)
        {
            //update listAccount_cust;
            List <Database.SaveResult> SR = database.update(listAccount_cust,false);
            list<Log__c> log_2b_Inserted = new list<Log__c> ();
            Log__c log = new Log__c();
            for(Database.SaveResult Srr: SR)
            {
                  // process any errors here
                 for(Database.Error err: Srr.getErrors())
                 {
                   log.service_name__c = 'Account_Addrr_Change';
                   log.status__c = 1;
                   log.message__c = err.getmessage();
                   log_2b_Inserted.add(log); 
                 } 
            }
            if(log_2b_Inserted.size()>0)
            {
                database.insert(log_2b_Inserted,false);
            }    
            listAccount_cust.clear();
            sitesid_cust_map.clear();
        }
        if(listAccount_sites.size()>0)
        {
            //update listAccount_sites;
            List <Database.SaveResult> SR = database.update(listAccount_sites,false);
            list<Log__c> log_2b_Inserted = new list<Log__c> ();
            Log__c log = new Log__c();
            for(Database.SaveResult Srr: SR)
            {
                 for(Database.Error err: Srr.getErrors())
                 {
                   log.service_name__c = 'Account_sector_Change';
                   log.status__c = 1;
                   log.message__c = err.getmessage();
                   log_2b_Inserted.add(log); 
                  }
            }
            if(log_2b_Inserted.size()>0)
            {
                database.insert(log_2b_Inserted,false);
            }
            listAccount_sites.clear();
        }
   }
}