@isTest

private class cpmDataLoad_Batch_TC
{

    static testMethod Void cpmDataLoad_Batch_TC()
    {
            Case cs = new Case();
            cs.Description='Test case';
            cs.Subject='Test';
            cs.Status='New';
            insert cs;
            
            Account acc = new Account();
            acc.Name='Test Account';
            insert acc;
            
            Schema.DescribeSObjectResult des = Schema.SObjectType.account_profile__c; 
            Map<String,Schema.RecordTypeInfo> accProRecMap= des.getRecordTypeInfosByName(); 
            Schema.RecordTypeInfo accProrecrdinfo = accProRecMap.get('CPM Data');
            Id CPMRecTypeId = accProrecrdinfo.getRecordTypeId();
            
            account_profile__c accPro = new account_profile__c();
            accPro.Account__c = acc.id;
            accPro.RecordTypeId = CPMRecTypeId;
            insert accPro;
            
            
            Data_Load__c DL = new   Data_Load__c();
            DL.Attribute1__c='3';
            DL.Attribute10__c='3';
            DL.Attribute11__c='3';
            DL.Attribute12__c='3';
            DL.Attribute13__c='3';
            DL.Attribute14__c='3';
            DL.Attribute15__c='3';
            DL.Attribute16__c='3';
            DL.Attribute17__c='3';
            DL.Attribute18__c='3';
            DL.Attribute19__c='3';
            DL.Attribute2__c='1/1/2013 05:08:37';
            DL.Attribute20__c='3';
            DL.Attribute21__c='3';
            DL.Attribute25__c='3';
            DL.Attribute26__c='3';
            DL.Attribute27__c='3';
            DL.Attribute28__c='3';
            DL.Attribute29__c='3';
            DL.Attribute3__c=acc.id;
            DL.Attribute4__c=cs.casenumber;
            DL.Attribute24__c='3';
            DL.Attribute9__c='3';
            insert DL;
            
            Account acc1 = new Account();
            acc1.Name='Test Account';
            insert acc1;
            
            Data_Load__c DL1 = new   Data_Load__c();
            DL1.Attribute3__c=acc1.id;
            DL1.Attribute2__c='1/1/2013 05:08:37';
            insert DL1;
            
            cpmDataLoad_Batch batch1 = new cpmDataLoad_Batch();
            database.executeBatch(batch1 );
            String expr = '0 0 0 4 5 ? 2020';  
            System.schedule('Batch',expr , batch1 );
            
    }

}