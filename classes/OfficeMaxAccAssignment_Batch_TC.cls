@isTest()
private class OfficeMaxAccAssignment_Batch_TC 
{
     static testMethod void OfficeMaxAccAssignment_Batch_TC()
     {
       Profile p = [SELECT Id FROM profile WHERE name='System Administrator'];
       User us1 = new User(alias = 'us_1',OMX_Rep_Number__c='9876', email='proxy@proxy1456.officedepot.com',OD_Employee_ID__c='113456',emailencodingkey='UTF-8', lastname='lastnam1',languagelocalekey='en_US',localesidkey='en_US', profileid = p.Id,timezonesidkey='America/Los_Angeles',username='12proxy@proxy456.com');
       insert us1;
       User us2 = new User(alias = 'us_2',OMX_Rep_Number__c='3456', email='proxy@proxy1478.officedepot.com',OD_Employee_ID__c='117456',emailencodingkey='UTF-8', lastname='lastname2',languagelocalekey='en_US',localesidkey='en_US', profileid = p.Id,timezonesidkey='America/Los_Angeles',short_title__c='BDM',username='proxy@proxy45698.com');
       insert us2;
       
       system.runas(us2){
       
        Schema.DescribeSObjectResult d1 = Schema.SObjectType.Account; 
        Map<String,Schema.RecordTypeInfo> rtMapByName = d1.getRecordTypeInfosByName(); 
        
        Schema.DescribeSObjectResult d2 = Schema.SObjectType.AccountAssignments__c; 
        Map<String,Schema.RecordTypeInfo> rtMapByName1 = d2.getRecordTypeInfosByName(); 
       
       Sales_Person__c testsalesper= new Sales_Person__c();
       testsalesper.ExtIDSalesPerson__c='9876';
       testsalesper.Primary__c=true;
       testsalesper.IsActive__c=true;
       testsalesper.Name='test';
       insert testsalesper;
       
       Sales_Person__c testsalesper1= new Sales_Person__c();
       testsalesper1.ExtIDSalesPerson__c='3456';
       testsalesper1.Primary__c=true;
       testsalesper1.IsActive__c=true;
       testsalesper1.Name='test';
       insert testsalesper1;

       Account acc= new Account();
       acc.recordtypeid =  rtMapByName.get('Customer (OfficeMax)').getRecordTypeId(); 
       acc.name = 'SUN Test Account';
       acc.OMX_Primary_Key__c = '6789';
       acc.OwnerID = us1.id;
       acc.Sales_PersonID__c =testsalesper.id;
       insert acc;
       
       AccountAssignments__c accass= new AccountAssignments__c();
       accass.recordtypeid = rtMapByName1.get('OfficeMax').getRecordTypeId(); 
       accass.AccountId__c= '6789';
       accass.Entity_Id__c= '6789';
       accass.OverlayEmpID1__c= '3456';
       insert accass;
       
       string CRON_EXP= '0 0 0 3 9 ? 2022'; 
       String s = 'Select Id, AccountId__c,RecordType.Name, AccountType__c, Entity_Type__c, Entity_Id__c, PrimaryEmpId__c, PrimaryEmpRole__c, ' 
                            +' OverlayEmpID1__c, OverlayEmpID2__c, OverlayEmpID3__c, OverlayEmpID4__c, OverlayEmpID5__c, OverlayEmpID6__c, OverlayEmpID7__c, OverlayEmpID8__c,' 
                            +' OverlayEmpID9__c, OverlayEmpID10__c, OverlayEmpID11__c, OverlayEmpID12__c, OverlayEmpID13__c, OverlayEmpID14__c, OverlayEmpID15__c,' 
                            +' OverlayEmpID16__c, OverlayEmpID17__c, OverlayEmpID18__c, OverlayEmpID19__c, OverlayEmpID20__c, OverlayEmpID21__c, OverlayEmpID22__c, OverlayEmpID23__c,' 
                            +' OverlayEmpID24__c, OverlayEmpID25__c, OverlayEmpID26__c, OverlayEmpID27__c, OverlayEmpID28__c, OverlayEmpID29__c, OverlayEmpID30__c,' 
                            +' OverlayEmpRole1__c, OverlayEmpRole2__c, OverlayEmpRole3__c, OverlayEmpRole4__c, OverlayEmpRole5__c, OverlayEmpRole6__c, '
                            +' OverlayEmpRole7__c, OverlayEmpRole8__c, OverlayEmpRole9__c, OverlayEmpRole10__c, OverlayEmpRole11__c, OverlayEmpRole12__c,' 
                            +' OverlayEmpRole13__c, OverlayEmpRole14__c, OverlayEmpRole15__c,OverlayEmpRole16__c, OverlayEmpRole17__c, OverlayEmpRole18__c, OverlayEmpRole19__c, OverlayEmpRole20__c,'
                            +' OverlayEmpRole21__c, OverlayEmpRole22__c, OverlayEmpRole23__c, OverlayEmpRole24__c, OverlayEmpRole25__c, OverlayEmpRole26__c, OverlayEmpRole27__c,'
                            +' OverlayEmpRole28__c, OverlayEmpRole29__c, OverlayEmpRole30__c,Status__c, Error_Message__c'
                            +' from AccountAssignments__c where Status__c != \'Processed\' and RecordType.Name =\'OfficeMax\' and createddate >= yesterday'; 
       Test.startTest();
       OfficeMaxAccAssignment_Batch assignBatch =new OfficeMaxAccAssignment_Batch();
       assignBatch.strQuery =s;
       database.executebatch(assignBatch, 20); 
       System.schedule('AssignmentBatch1',CRON_EXP , assignBatch); 
       OfficeMaxAccAssignment_Batch assignBatch1 = new OfficeMaxAccAssignment_Batch(s);
       System.schedule('Assignment Batch',CRON_EXP , assignBatch1);
       database.executebatch(assignBatch1, 20); 
       Test.stopTest();
                         
       
     }
     }
}