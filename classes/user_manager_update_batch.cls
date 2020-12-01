global class user_manager_update_batch implements database.batchable <sobject> ,schedulable, database.stateful
{
    public string user_query = 'SELECT Name,Last_Name__c, Division__c, Title__c, Local__c, Address__c, City__c, State__c, Postal_Code__c, Country__c, Email__c, Language__c, Federation_Identifier__c, OD_Employee_Number__c, Manager_Employee_Number__c, HireDate__c, TermDate__c, UserName__c, Comapny_Name__c, Phone__c, Fax__c, Cell__c, Status__c, Error_Reason__c from User_Staging__c where status__c=\'Pending Manager\'';
    
    global Set<User_Staging__c> Set_UpdateCust = new Set<User_Staging__c>();
    
    global user_manager_update_batch()
    {
        
    }
    
    global user_manager_update_batch(string query)
    {
        if(query != null||query != '')
        {
            user_query = query;
        }
    }
    
    global database.querylocator start (database.batchablecontext BC)
    {
        return database.getquerylocator(user_query);
    }
    
    global void execute (database.batchablecontext BC, Sobject[] scope)
    {
        list <user_staging__c> list_usr_stg = scope;
        Set<String>Set_mng_emplNum = new Set<String>();
        Set<String>Set_usr_emplNum = new Set<String>();
        Set<String>Set_all_emplNum = new Set<String>();
        List <user> List_update_usr = new list <user>();
        map <string,user> map_mngid_user = new map <string,user> ();
        
        for (user_staging__c usr_stg:list_usr_stg)
        {
            if(usr_stg.Manager_Employee_Number__c!='' && usr_stg.Manager_Employee_Number__c!=null)
            Set_mng_emplNum.add(usr_stg.Manager_Employee_Number__c);
            Set_usr_emplNum.add(usr_stg.OD_Employee_Number__c);
        }
        Set_all_emplNum.addall(Set_mng_emplNum);
        Set_all_emplNum.addall(Set_usr_emplNum);
        for(User u:[select id,Street, MobilePhone, city, CompanyName, country, division, email, fax, FederationIdentifier, LanguageLocaleKey, LocaleSidKey, Manager.OD_Employee_ID__c, OD_Employee_ID__c, phone, PostalCode, state, Title, username, ProfileId from user where OD_Employee_ID__c in :Set_all_emplNum ])
        {
            map_mngid_user.put(u.OD_Employee_ID__c,u);
        }
        
        for (user_staging__c usr_stg:list_usr_stg)
        {
            try
            {
                if(map_mngid_user.containskey(usr_stg.OD_Employee_Number__c) || map_mngid_user.containskey(usr_stg.Manager_Employee_Number__c))
                {
                    User usr = map_mngid_user.get(usr_stg.OD_Employee_Number__c);
                    //usr.manager = map_mngid_user.get(usr_stg.Manager_Employee_Number__c);
                    if(map_mngid_user.containskey(usr_stg.Manager_Employee_Number__c))
                    usr.managerid = map_mngid_user.get(usr_stg.Manager_Employee_Number__c).id;
                    usr_stg.status__c='Processed';
                    List_update_usr.add(usr);
                    Set_UpdateCust.add(usr_stg);
                    
                }else
                {
                    usr_stg.status__c='Manager Error';
                    usr_stg.Error_Reason__c = usr_stg.Error_Reason__c+'Manager Error: Manager does not exist in the system';
                    Set_UpdateCust.add(usr_stg);
                }    
            }catch(exception e)
            {
                usr_stg.status__c='Manager Error';
                usr_stg.Error_Reason__c = usr_stg.Error_Reason__c+'Manager Error: '+e.getMessage();
                System.debug('**********EXCEPTION*****'+e.getMessage());
                //set_UpdateCustom.add(u.id);
                Set_UpdateCust.add(usr_stg);
            }
        }
        if(List_update_usr.size()>0)
        {
            update List_update_usr;
            //System.debug('***********Updated'+List_update_usr);
        }    
    }
    
    global void  finish (database.batchablecontext BC)
    {
    
        If(Test.isRunningTest())
        {
                User u = [select id from user where profile.name='System Administrator' and isActive =true limit 1 ];
                System.runAs(u)
                {
                            List<User_Staging__c> List_cust = new List<User_Staging__c>();
                            if(Set_UpdateCust.size()>0)
                            {
                                List_cust.addAll(Set_UpdateCust);
                                update List_cust;
                            }
                }
        }
        else
        {
                List<User_Staging__c> List_cust = new List<User_Staging__c>();
                if(Set_UpdateCust.size()>0)
                {
                    List_cust.addAll(Set_UpdateCust);
                    update List_cust;
                    //System.debug('****UPDATE CUSTOM********'+List_cust);
                }
        }
    }
    
    global void execute (schedulablecontext SC)
    {
        user_manager_update_batch assignBatch1 = new user_manager_update_batch();
        database.executebatch(assignBatch1,1);
    }

}