global class cpmDataLoad_Batch implements database.Batchable<Sobject>, Schedulable
{ 
    public String cpm_query = 'select attribute1__c,attribute2__c,attribute3__c,attribute4__c,attribute5__c,attribute6__c,attribute7__c,'
                              +'attribute8__c,attribute9__c,attribute10__c,attribute11__c,attribute12__c,attribute13__c,attribute14__c,'
                              +'attribute15__c,attribute16__c,attribute17__c,attribute18__c,attribute19__c,attribute20__c,attribute21__c,'
                              +'attribute22__c,attribute23__c,attribute24__c,attribute25__c,attribute26__c,attribute27__c,attribute28__c '
                              +'from data_load__c'
                              ;
    global cpmDataLoad_Batch ()
    {
    }
 
 global Database.QueryLocator start(Database.BatchableContext BC)
    {            
        System.debug('CPM Data Load Query ===== = '+cpm_query);
        return Database.getQueryLocator(cpm_query);
    } 
    
 global void execute(Database.BatchableContext BC, SObject[] scope)
    {
       List<data_load__c> dataload = scope;
       Map<id,id> acctProfiles = new Map<id,id>();
       Set<String> wrnumbers = new Set<String>();
       List<Account_Profile__c> aprofile_add = new List<Account_Profile__c> ();
       Map<String,ID> caseNumberMap = new Map<String,ID>();
       Recordtype r = [select id from recordtype where name = 'CPM Data' and sobjecttype = 'Account_Profile__c'];
       Set<ID> sfAcctId = new Set<ID> ();
        For (data_load__c d: dataload) {
          sfAcctid.add(d.attribute3__c);
          wrnumbers.add(d.attribute4__c);
        }
        for (case c : [select id,casenumber from case where casenumber = :wrnumbers]) 
             caseNumberMap.put(c.casenumber,c.id);
           
        For (Account_Profile__c p: [select id,account__c from account_profile__c where recordtype.name = 'CPM Data' and account__c = :sfAcctid])
            acctProfiles.put(p.account__c,p.id);
        // Creating Profiles
        For (ID d : sfAcctid) {
            if (!acctProfiles.containskey(d)) {
                Account_Profile__c ap = new Account_Profile__c ();
                ap.name = 'CPM Data';
                ap.RecordTypeId = r.id;
                ap.profile_unique_name__c = d + '-' + r.id;
                ap.account__c = d;
                system.debug('Profile Unique Name:' + ap.profile_unique_name__c);
                aprofile_add.add(ap);
            }
        }
        insert aprofile_add;
        // Reprocess the profiles map
        For (Account_Profile__c p: [select id,account__c from account_profile__c where recordtype.name = 'CPM Data' and account__c = :sfAcctid])
            acctProfiles.put(p.account__c,p.id);
        
        // Create CPM Data
        list<CPM_Data__c> cpmData_add = new list<CPM_Data__c> ();
        for (data_load__c d: dataload) {
            if (acctProfiles.containskey(d.attribute3__c)) {
              CPM_Data__c c = new CPM_Data__c ();
                c.Account_Profile__c = acctProfiles.get(d.attribute3__c);
                c.Account_Name__c = d.attribute3__c;
                
                if (d.attribute1__c != null && d.attribute1__c != '')
                  c.cpm_version__c = decimal.valueof(d.attribute1__c);
                
                    c.Analyst_Notes__c = d.Attribute23__c;
                    c.Current_Vendor__c = d.Attribute6__c;
                    c.Customer_Size__c = d.Attribute8__c;
                    c.Pricing_Contact__c = d.Attribute22__c;
                    if (d.Attribute25__c != null && d.Attribute25__c != '')
                     c.Projected_on_Core__c = decimal.valueof(d.Attribute25__c);
                    if (d.Attribute9__c != null && d.Attribute9__c != '')
                      c.Projected_Annual_Spend__c = decimal.valueof(d.Attribute9__c);
                    if (d.Attribute12__c != null && d.Attribute12__c != '')
                      c.Projected_AOV__c = decimal.valueof(d.Attribute12__c);
                    if (d.Attribute10__c != null && d.Attribute10__c != '')
                     c.Projected_Contract_Term__c = decimal.valueof(d.Attribute10__c);
                    if (d.Attribute16__c != null && d.Attribute16__c != '')
                     c.Projected_Conversion_Rebate__c = decimal.valueof(d.Attribute16__c);
                    if (d.Attribute26__c != null && d.Attribute26__c != '')
                     c.Projected_Core_IMU__c = decimal.valueof(d.Attribute26__c);
                    if (d.Attribute24__c != null && d.Attribute24__c != '')
                     c.Projected_Core_Items_Count__c = decimal.valueof(d.Attribute24__c);
                    if (d.Attribute21__c != null && d.Attribute21__c != '')
                     c.Projected_Cost_of_Credit__c = decimal.valueof(d.Attribute21__c);
                    if (d.Attribute20__c != null && d.Attribute20__c != '')
                     c.Projected_Delivery_Expense__c = decimal.valueof(d.Attribute20__c);
                    if (d.Attribute18__c != null && d.Attribute18__c != '')
                     c.Projected_Desktop_Delivery__c = decimal.valueof(d.Attribute18__c);
                    if (d.Attribute28__c != null && d.Attribute28__c != '')
                     c.Projected_Gross_IMU__c = decimal.valueof(d.Attribute28__c);
                    if (d.Attribute13__c != null && d.Attribute13__c != '')
                     c.Projected_Net_IMU__c = decimal.valueof(d.Attribute13__c);
                    if (d.Attribute27__c != null && d.Attribute27__c != '')
                     c.Projected_Non_Core_IMU__c = decimal.valueof(d.Attribute27__c);
                    if (d.Attribute15__c != null && d.Attribute15__c != '')
                     c.Projected_Operating_Profit__c = decimal.valueof(d.Attribute15__c);
                    
                     c.Projected_Payment_Terms__c = d.Attribute11__c;
                
                    if (d.Attribute17__c != null && d.Attribute17__c != '')
                     c.Projected_Performance_Rebate__c = decimal.valueof(d.Attribute17__c);
                    if (d.Attribute14__c != null && d.Attribute14__c != '')
                     c.Projected_Pocket_Margin__c = decimal.valueof(d.Attribute14__c);
                    if (d.Attribute19__c != null && d.Attribute19__c != '')
                     c.Projected_Program_Dollars__c = decimal.valueof(d.Attribute19__c);
                    if (caseNumberMap.containskey(d.attribute4__c))
                      c.Support_Number__c = caseNumberMap.get(d.Attribute4__c);
                    
                if (d.attribute2__c != null && d.Attribute2__c != '') {
                   String[] day = d.attribute2__c.split(' ');
                   String dtime,d3; 
                   if (day != null) {
                    String [] d2 = day[0].split('/');
                    d3 = d2[2] + '-' + d2[0] + '-' + d2[1];
                    dtime = d3 + ' ' + day[1]+':00';
                    c.cpm_date_time__c = Datetime.valueof(dtime);
                   }
                    
                }
                
                cpmData_add.add(c);
            }
        }
        
        insert cpmData_add;
    }
    
    global void execute(SchedulableContext sc)
    {
     //Batch size set for each iteration
     integer batch_size = 1;
     cpmDataLoad_Batch cpmBatch = new cpmDataLoad_Batch();
     database.executebatch(cpmBatch,batch_size);
    }
    
 global void finish(Database.BatchableContext BC)
    {
        
    }
}