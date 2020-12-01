/***
Description: The Scope of this Batch Class is Case Object(prospect/customer & Site).
This will update Case with the related customer or prospect details.

This single class implemnets Batchable interface.


Created By: Ankur Pradhan
Created Date: 16-MAY-2012

Modified By:
Modified Date:

Modify Reason:
**/
Global class Case_AccountDetails_update_Batch implements database.Batchable<Sobject>,Schedulable
{

    public String strQuery;
    public String dt,dt2,date_time_string;// For getting the Lastmodifieddate
    private string DEFAULT_QUERY;
    /*Commented  below line for Case #00827679
    Case_Changes__c  Casemod = Case_Changes__c.getOrgDefaults();*/
    
    map <case,id> Caseid_Accid_map = new map <case,id>();
    list <Case> Case_lst = new list <Case>();

    /*This is default costructor*/
    global Case_AccountDetails_update_Batch()
    {
    }

    /*This costructor is called from the Batch Schedule mathod*/
    global Case_AccountDetails_update_Batch(String query)
    {
        //replaced Casemod.Last_Run_For__c to System.today() for case #00827679
        if(System.today()!=null)
        {
        date_time_string=''+System.today()+'';
        date_time_string.trim();
        dt=date_time_string.substring(11,19);
        dt2=date_time_string.substring(0,10);
        DEFAULT_QUERY = 'Select RecordTypeId, LastModifiedDate, Id, DUP_Requestor_Name__c, DUP_Requestor_ID__c, DUP_Acct_Type__c, DUP_Acct_Name__c, DUP_Acct_ID__c, ContactId, AccountId From Case where RecordType.Name =\'Work Request\' and AccountId = null and DUP_Acct_ID__c != null and LastModifiedDate >'+dt2+'T'+dt+'Z'+'order by LastModifiedDate asc';
        }
        else
        {
            DEFAULT_QUERY = 'Select RecordTypeId, LastModifiedDate, Id, DUP_Requestor_Name__c, DUP_Requestor_ID__c, DUP_Acct_Type__c, DUP_Acct_Name__c, DUP_Acct_ID__c, ContactId, AccountId From Case where RecordType.Name =\'Work Request\' and AccountId = null and DUP_Acct_ID__c != null order by LastModifiedDate asc';
        }
        if(query != null && query != '')
            this.strQuery = query;
        else
            this.strQuery = DEFAULT_QUERY;

    }
    
    global Database.QueryLocator start(Database.BatchableContext BC)
    {
       /* Commented  below line for Case #00827679
        Casemod.Last_Run_For__c=System.now();
        upsert Casemod;*/
        return Database.getQueryLocator(strQuery);
    }
    
    /* */
    global void execute(Database.BatchableContext BC, list<Case> scope)
    {

        List<case> lstcustomer = scope;
        Update_Cust_Prosp_detailsonCase Case_Acc_update = new  Update_Cust_Prosp_detailsonCase ();
        Caseid_Accid_map = Case_Acc_update.Cust_prosp_Updateoncase(lstcustomer);
        for(Case c:Caseid_Accid_map.keyset())
        {

            c.accountid=Caseid_Accid_map.get(c);
            Case_lst.add(c);
            
        }
        
        update Case_lst;    
    }
    
    /* This method is executed to relase some resources if any*/
    global void finish(Database.BatchableContext BC)
    {
       //Not required
    }
  
    /***************************************************************************************
        This method must be there to implement Schedulable interface
    ****************************************************************************************/
    global void execute(SchedulableContext sc)
    {
        String strQuery = '';
        Case_AccountDetails_update_Batch assignBatch = new Case_AccountDetails_update_Batch(strQuery);
        database.executebatch(assignBatch, 200);
    } 
    
}