@IsTest
public class AOPSContactWebUserFinalProcessor_TC {
    @IsTest
    static void insertRecord() {
        List<AOPS_Contact_Web_User__c>  lstToBInsrtd = new List<AOPS_Contact_Web_User__c> ();
        Set<String> contactNumbers = new Set<String>();
        Map<String, Contact_Final_Staging__c> finalStagingMap = new Map<String, Contact_Final_Staging__c>();
        AOPS_Contact_Web_User__c a= new AOPS_Contact_Web_User__c();
        a.CXTCNTW_ACTION__c='D';
        a.CCU330F_CREATE_DT__c =String.ValueOf(system.now());
        a.Unique_Record_ID__c = '37585958599';
        a.CCU330F_CONTACT_ID__c	='9876543210';
        a.CCU330F_CUSTOMER_ID__c='53947394';
        a.CXTCNTW_TIMESTAMP__c = '2020-07-09-11.24.15.980113';
        AOPS_Contact_Web_User__c a1= new AOPS_Contact_Web_User__c();
        a1.CXTCNTW_ACTION__c='U';
        a1.CCU330F_CREATE_DT__c =String.ValueOf(system.now());
        a1.Unique_Record_ID__c = '774488499494';
        a1.CCU330F_CONTACT_ID__c	='1899991933';
        a1.CCU330F_CUSTOMER_ID__c ='85739424';
                a1.CXTCNTW_TIMESTAMP__c = '2020-07-09-11.24.15.980113';

        lstToBInsrtd.add(a);
        lstToBInsrtd.add(a1);
        insert lstToBInsrtd;
        List<Contact_Final_Staging__c> finalStagingRec = new List<Contact_Final_Staging__c>{
            new Contact_Final_Staging__c  (AOPS_Contact_Number__c='9876543210' ,AOPS_Account_Number__c='123455666',Unique_Record_ID__c='9876543210123455666'),
                new Contact_Final_Staging__c   (AOPS_Contact_Number__c='5218999934' ,AOPS_Account_Number__c='75638474949',Unique_Record_ID__c='521899993475638474949')};
                    insert finalStagingRec;
        for(AOPS_Contact_Web_User__c initialStagingRec : lstToBInsrtd) {
            contactNumbers.add(initialStagingRec.CCU330F_CONTACT_ID__c);
        }
        
        List<Contact_Final_Staging__c> finalStagingRecs = [SELECT Id, AOPS_Contact_Number__c, AOPS_Account_Number__c, Unique_Record_ID__c, Web_User_Seq__c
                                                           FROM Contact_Final_Staging__c WHERE AOPS_Contact_Number__c IN: contactNumbers];       
        for(Contact_Final_Staging__c stgndRec : finalStagingRecs) {
            finalStagingMap.put(stgndRec.AOPS_Contact_Number__c, stgndRec);
        }            
        Test.startTest();
        System.enqueueJob(new AOPSContactWebUserFinalProcessor(lstToBInsrtd));
        
        Test.stopTest();
    }
}