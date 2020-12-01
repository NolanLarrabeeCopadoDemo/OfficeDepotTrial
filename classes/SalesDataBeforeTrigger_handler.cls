Public class SalesDataBeforeTrigger_handler {

    static List < String > AccountId = new List < String > ();
    static List < Account > OrgData = new List < Account > ();
    static List < Sales_Data__C > orgUpsert = new List < Sales_Data__C > ();
    static Map < String, Account > mapOrg = new Map < String, Account > ();
    static List < Org__C > OrgUpdate = new List < Org__C > ();
    static Set < Id > OrgId = new Set < Id > ();

    public static void beforeinsert(List < Sales_Data__c > SalesDatalist) {

        for (Sales_Data__C rec: SalesDatalist) {
            if (rec.AOPS_Id__C != null)
                AccountId.add(rec.AOPS_Id__C);
        }
        //Get Org Data for the accounts
        if (AccountId.size() > 0) {
            OrgData = [Select Org__C, Id, aops_cust_id__C, AOPS_Seq_ID__c, RecordType_Name__c from Account
                where aops_cust_id__C in: AccountId or AOPS_Seq_ID__c in: AccountId
            ];
        }

        for (Account acc: OrgData) {
            if (acc.aops_cust_id__C != null)
                mapOrg.put(acc.aops_cust_id__C, acc);
            if (acc.AOPS_Seq_ID__c != null)
                mapOrg.put(acc.AOPS_Seq_ID__c, acc);
        }

        for (Sales_Data__C rec: SalesDatalist) {
            if (rec.AOPS_Id__C != null) {
                if (mapOrg.containskey(rec.AOPS_Id__C)) {
                    String recordtypename = mapOrg.get(rec.AOPS_Id__C).RecordType_Name__c;
                    if (recordtypename.contains('Customer'))
                        rec.account_type__C = 'Customer';
                    if (recordtypename.contains('Site'))
                        rec.account_type__C = 'Site';
                }
            }

            if (rec.account_type__C == 'Site' || rec.account_type__C == 'Customer') {
                if (rec.AOPS_Id__C != null && mapOrg.containskey(rec.AOPS_Id__C)) {
                    rec.account__C = mapOrg.get(rec.AOPS_Id__C).Id;
                    rec.org__C = mapOrg.get(rec.AOPS_Id__C).org__C;
                }
            }

            if (rec.account_type__C == 'Site') {
            if(Trigger.isInsert){
                rec.BatchProcessed__c = true;
                if (rec.org__C != null) {
                    if (!OrgId.contains(rec.org__C)) {
                        OrgId.add(rec.Org__C);
                        Org__C recNew = new Org__C();
                        recNew.Id = rec.org__C;
                        recNew.SalesDataBatch__C = true;
                        OrgUpdate.add(recNew);
                    }
                }
             }
            }
        }

        if (OrgUpdate.size() > 0)
            update OrgUpdate;
    }
    public static void beforeupdate(Map < Id, Sales_Data__c > NewSalesData, Map < Id, Sales_Data__c > OldSalesData) {
    
    List < Org__C > OrgUpdate = new List < Org__C > ();
    Set < Id > OrgId = new Set < Id > ();


        for (String recid: NewSalesdata.keyset()) {
            if (  (OldSalesData.get(recid).BatchProcessed__c == NewSalesData.get(recid).BatchProcessed__c)  && NewSalesData.get(recid).account_type__C == 'Site' ){
                NewSalesData.get(recId).BatchProcessed__c = true;
              if (NewSalesData.get(recId).org__C != null) {
                    if (!OrgId.contains(NewSalesData.get(recId).org__C)) {
                        OrgId.add(NewSalesData.get(recId).Org__C);
                        Org__C recNew = new Org__C();
                        recNew.Id = NewSalesData.get(recId).org__C;
                        recNew.SalesDataBatch__C = true;
                        OrgUpdate.add(recNew);
                    }
                }

        }
    }
            if (OrgUpdate.size() > 0)
            update OrgUpdate;

}

}