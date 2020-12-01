@isTest()
private class ProspectUpload_Batch_TC 
{
   static testMethod void ProspectUpload_Batch_TC()
   {
       Profile p = [SELECT Id FROM profile WHERE name='System Administrator'];
       User us1 = new User(alias = 'us_1',OMX_Rep_Number__c='9876', email='proxy@proxy1456.officedepot.com',OD_Employee_ID__c='113456',emailencodingkey='UTF-8', lastname='lastnam1',languagelocalekey='en_US',localesidkey='en_US', profileid = p.Id,timezonesidkey='America/Los_Angeles',username='12proxy@proxy456.com');
       insert us1;
       system.runas(us1)
       {
       
       Sales_Person__c testsalesper= new Sales_Person__c();
       testsalesper.ExtIDSalesPerson__c='9876';
       testsalesper.Primary__c=true;
       testsalesper.IsActive__c=true;
       testsalesper.Name='test';
       insert testsalesper;
       
      

       
       Account acct = new Account ();
        acct.name = 'SUN Test Account';
        acct.BillingStreet = '1040 N 326 W';
        acct.billingcity = 'Orem';
        acct.BillingState = 'UT';
        acct.Billingcountry = 'USA';
        acct.Oracle_Party_Id__c = '1234563456';
        acct.Oracle_Party_Site_Id__c = '1234563456';
        acct.AOPS_Cust_Id__c = '123456';
        acct.AOPS_Seq_ID__c = '127456';
        acct.OwnerID = us1.id;// This is the salesforce User ID
        //acc.Sales_PersonID__c = 'a0AE0000000GGMn'; //Sales person Id for the Salesforce USer
        acct.Sales_PersonID__c =testsalesper.id;
        insert acct;
        
         note nt=new note();
       nt.parentid=acct.id;
       nt.title='abc';
       nt.body='nrty';
       insert nt;
       
       Contact c = new Contact();
       c.Lastname='Sinha';
       c.Email='niraj.sinha@wipro.com';
       c.Phone='(999)999-9999';
       insert c;

       
                
       Data_Staging_Table__c testdata= new Data_Staging_Table__c();
       testdata.name='Test batch';
       testdata.OMX_Rep_Number__c='9876';
       testdata.Company_Name__c='Office max pros1';
       testdata.Website__c='http://www.test.com';
       testdata.WCW_Count__c=18;
       testdata.Address_Line_1__c='Test add';
       testdata.Address_Line_2__c='test add1';
       testdata.City__c='Test city';
       testdata.State__c='AL';
       testdata.Zip__c='76543';
       testdata.Contact_First_Name__c='Office max First name1';
       testdata.Contact_Last_Name__c='office max last name1';
       testdata.Contact_Phone__c='8765456765';
       testdata.Contact_Email__c='abc@abc.com';
       testdata.Opportunity_Name__c='office max opp1';
       testdata.Primary_Product__c='CBS';
       testdata.Opportunity_Amount__c=25345;
       testdata.Probability__c=75;
       testdata.Opportunity_Stage__c='25%-Initial Approach';
       testdata.Primary_Competitor__c='Office depot1';
       testdata.Anticipated_Close_Date__c=System.now().date();
       testdata.Customer_Lifecycle__c='Acquisition';
       testdata.OMX_Primary_Key__c='test';
       testdata.Notes__c='This is to test if the note gets related to the opportunity that is inserted from here.';
       testdata.Status__c='Not Started';
       
       insert testdata;
      /* List <Data_Staging_Table__c> lstdatastaging = new List<Data_Staging_Table__c>();
       for(Data_Staging_Table__c test2:lstdatastaging)
       {
       test2.OMX_Primary_Key__c=null;
       test2.Company_Name__c='Wipro';
       test2.Address_Line_1__c='bhyter';
       test2.City__c='noida';
       test2.State__c='UP';
       test2.Zip__c='uty';
       }
       lstdatastaging.add(test2) ;
       */
       
       List<Data_Staging_Table__c> lstdatastaging = new List<Data_Staging_Table__c>();
       
    //  lstdatastaging 
       
       
       Data_Staging_Table__c testdata1 = new Data_Staging_Table__c();
       
       testdata1.Company_Name__c='Office max pros2';
       //testdata1.OMX_Primary_Key__c=null;
       lstdatastaging.add(testdata1);
       //insert testdata1;
     /*  
      // Data_Staging_Table__c testdata2 = new Data_Staging_Table__c();
      Data_Staging_Table__c testdata2 = new Data_Staging_Table__c();

       testdata2.Contact_Last_Name__c='sinha';
       lstdatastaging.add(testdata2);
       
       
       
       Data_Staging_Table__c testdata4 = new Data_Staging_Table__c();
       testdata4 .OMX_Primary_Key__c='';
       testdata4 .Company_Name__c='Wipro';
       testdata4.OMX_Rep_Number__c='9876';
       testdata4 .Address_Line_1__c='bhyter';
       testdata4 .City__c='noida';
       testdata4 .State__c='UP';
       testdata4 .Zip__c='uty';
        testdata4.Contact_Last_Name__c='sinha';
        testdata4.Contact_Email__c='niraj.sinha@wipro.com';
        testdata4.Opportunity_Name__c='Eureka';
         testdata4.Primary_Product__c='filter';
         testdata4.Opportunity_Amount__c=100;
         testdata4.Primary_Competitor__c='tata';
         testdata4.Anticipated_Close_Date__c=System.now().date();
         testdata4.Customer_Lifecycle__c='legend';
         testdata4.Probability__c=75;
         testdata4.Opportunity_Stage__c='0%-Lost';
       lstdatastaging.add(testdata4) ;
       
         
       Data_Staging_Table__c testdata5 = new Data_Staging_Table__c();
       testdata5 .OMX_Primary_Key__c='';
       testdata5 .Company_Name__c='Wipro';
       testdata5.OMX_Rep_Number__c='9876';
       testdata5 .Address_Line_1__c='bhyter';
       testdata5 .City__c='noida';
       testdata5 .State__c='UP';
       testdata5 .Zip__c='uty';
        testdata5.Contact_Last_Name__c='sinha';
        testdata5.Contact_Email__c='niraj.sinha@wipro.com';
        testdata5.Opportunity_Name__c='Eureka';
         testdata5.Primary_Product__c='filter';
         testdata5.Opportunity_Amount__c=100;
         testdata5.Primary_Competitor__c='tata';
         testdata5.Anticipated_Close_Date__c=System.now().date();
         testdata5.Customer_Lifecycle__c='legend';
         testdata5.Probability__c=75;
         testdata5.Opportunity_Stage__c='1%-Qualifying Prospect';
         lstdatastaging.add(testdata5) ;
         
          Data_Staging_Table__c testdata6 = new Data_Staging_Table__c();
       testdata6.OMX_Primary_Key__c='';
       testdata6.Company_Name__c='Wipro';
       testdata6.OMX_Rep_Number__c='9876';
       testdata6.Address_Line_1__c='bhyter';
       testdata6.City__c='noida';
       testdata6.State__c='UP';
       testdata6.Zip__c='uty';
        testdata6.Contact_Last_Name__c='sinha';
        testdata6.Contact_Email__c='niraj.sinha@wipro.com';
        testdata6.Opportunity_Name__c='Eureka';
         testdata6.Primary_Product__c='filter';
         testdata6.Opportunity_Amount__c=100;
         testdata6.Primary_Competitor__c='tata';
         testdata6.Anticipated_Close_Date__c=System.now().date();
         testdata6.Customer_Lifecycle__c='legend';
         testdata6.Probability__c=75;
         testdata6.Opportunity_Stage__c='10%-Appointment Secured';
       
       lstdatastaging.add(testdata6) ;
       
        Data_Staging_Table__c testdata7 = new Data_Staging_Table__c();
       testdata7.OMX_Primary_Key__c='';
       testdata7.Company_Name__c='Wipro';
       testdata7.OMX_Rep_Number__c='9876';
       testdata7.Address_Line_1__c='bhyter';
       testdata7.City__c='noida';
       testdata7.State__c='UP';
       testdata7.Zip__c='uty';
        testdata7.Contact_Last_Name__c='sinha';
        testdata7.Contact_Email__c='niraj.sinha@wipro.com';
        testdata7.Opportunity_Name__c='Eureka';
         testdata7.Primary_Product__c='filter';
         testdata7.Opportunity_Amount__c=100;
         testdata7.Primary_Competitor__c='tata';
         testdata7.Anticipated_Close_Date__c=System.now().date();
         testdata7.Customer_Lifecycle__c='legend';
         testdata7.Probability__c=50;
         testdata7.Opportunity_Stage__c='25%-Initial Approach';
       
       lstdatastaging.add(testdata7) ;
       
         Data_Staging_Table__c testdata8 = new Data_Staging_Table__c();
       testdata8.OMX_Primary_Key__c='';
       testdata8.Company_Name__c='Wipro';
       testdata8.OMX_Rep_Number__c='9876';
       testdata8.Address_Line_1__c='bhyter';
       testdata8.City__c='noida';
       testdata8.State__c='UP';
       testdata8.Zip__c='uty';
        testdata8.Contact_Last_Name__c='sinha';
        testdata8.Contact_Email__c='niraj.sinha@wipro.com';
        testdata8.Opportunity_Name__c='Eureka';
         testdata8.Primary_Product__c='filter';
         testdata8.Opportunity_Amount__c=100;
         testdata8.Primary_Competitor__c='tata';
         testdata8.Anticipated_Close_Date__c=System.now().date();
         testdata8.Customer_Lifecycle__c='legend';
         testdata8.Probability__c=75;
         testdata8.Opportunity_Stage__c='75%-Negotiate & Finalize';
       
       lstdatastaging.add(testdata8) ;
       
       Data_Staging_Table__c testdata9 = new Data_Staging_Table__c();
       testdata9.OMX_Primary_Key__c='';
       testdata9.Company_Name__c='Wipro';
       testdata9.OMX_Rep_Number__c='9876';
       testdata9.Address_Line_1__c='bhyter';
       testdata9.City__c='noida';
       testdata9.State__c='UP';
       testdata9.Zip__c='uty';
        testdata9.Contact_Last_Name__c='sinha';
        testdata9.Contact_Email__c='niraj.sinha@wipro.com';
        testdata9.Contact_Phone__c='(999)999-9999';
        testdata9.Opportunity_Name__c='Eureka';
         testdata9.Primary_Product__c='filter';
         testdata9.Opportunity_Amount__c=100;
         testdata9.Primary_Competitor__c='tata';
         testdata9.Anticipated_Close_Date__c=System.now().date();
         testdata9.Customer_Lifecycle__c='legend';
         testdata9.Probability__c=10;
         testdata9.Opportunity_Stage__c='90%-Execute';
          testdata9.notes__C='90%-Execute';
       
       lstdatastaging.add(testdata9) ;
       
       Data_Staging_Table__c testdata10 = new Data_Staging_Table__c();
       testdata10.OMX_Primary_Key__c='';
       testdata10.Company_Name__c='Wipro';
       testdata10.OMX_Rep_Number__c='9876';
       testdata10.Address_Line_1__c='bhyter';
       testdata10.City__c='noida';
       testdata10.State__c='UP';
       testdata10.Zip__c='uty';
        testdata10.Contact_Last_Name__c='sinha';
        testdata10.Contact_Email__c='niraj.sinha@wipro.com';
        testdata10.Opportunity_Name__c='Eureka';
         testdata10.Primary_Product__c='filter';
         testdata10.Opportunity_Amount__c=100;
         testdata10.Primary_Competitor__c='tata';
         testdata10.Anticipated_Close_Date__c=System.now().date();
         testdata10.Customer_Lifecycle__c='legend';
         testdata10.Probability__c=35;
         testdata10.Opportunity_Stage__c='100%-Won';
       
       lstdatastaging.add(testdata10) ;
       
       Data_Staging_Table__c testdata11 = new Data_Staging_Table__c();
       testdata11.OMX_Primary_Key__c='';
       testdata11.Company_Name__c='Wipro';
       testdata11.OMX_Rep_Number__c='9876';
       testdata11.Address_Line_1__c='bhyter';
       testdata11.City__c='noida';
       testdata11.State__c='UP';
       testdata11.Zip__c='uty';
        testdata11.Contact_Last_Name__c='sinha';
        testdata11.Contact_Email__c='niraj.sinha@wipro.com';
        testdata11.Opportunity_Name__c='Eureka';
         testdata11.Primary_Product__c='filter';
         testdata11.Opportunity_Amount__c=1;
         testdata11.Primary_Competitor__c='tata';
         testdata11.Anticipated_Close_Date__c=System.now().date();
         testdata11.Customer_Lifecycle__c='legend';
         testdata11.Probability__c=50;
         testdata11.Opportunity_Stage__c='';
       
       lstdatastaging.add(testdata11) ;
       
         Data_Staging_Table__c testdata12 = new Data_Staging_Table__c();
       testdata12.OMX_Primary_Key__c='';
       testdata12.Company_Name__c='Wipro';
       testdata12.OMX_Rep_Number__c='9876';
       testdata12.Address_Line_1__c='bhyter';
       testdata12.City__c='noida';
       testdata12.State__c='UP';
       testdata12.Zip__c='uty';
        testdata12.Contact_Last_Name__c='sinha';
        testdata12.Contact_Email__c='niraj.sinha@wipro.com';
        testdata12.Opportunity_Name__c='Eureka';
         testdata12.Primary_Product__c='filter';
         testdata12.Opportunity_Amount__c=1;
         testdata12.Primary_Competitor__c='tata';
         testdata12.Anticipated_Close_Date__c=System.now().date();
         testdata12.Customer_Lifecycle__c='legend';
         testdata12.Probability__c=25;
         testdata12.Opportunity_Stage__c='';
       
       lstdatastaging.add(testdata12) ;
       
            Data_Staging_Table__c testdata13 = new Data_Staging_Table__c();
       testdata13.OMX_Primary_Key__c='';
       testdata13.Company_Name__c='Wipro';
       testdata13.OMX_Rep_Number__c='9876';
       testdata13.Address_Line_1__c='bhyter';
       testdata13.City__c='noida';
       testdata13.State__c='UP';
       testdata13.Zip__c='uty';
        testdata13.Contact_Last_Name__c='sinha';
        testdata13.Contact_Email__c='niraj.sinha@wipro.com';
        testdata13.Opportunity_Name__c='Eureka';
         testdata13.Primary_Product__c='filter';
         testdata13.Opportunity_Amount__c=1;
         testdata13.Primary_Competitor__c='tata';
         testdata13.Anticipated_Close_Date__c=System.now().date();
         testdata13.Customer_Lifecycle__c='legend';
         testdata13.Probability__c=100;
         testdata13.Opportunity_Stage__c='';
       
       lstdatastaging.add(testdata13) ;
       
        Data_Staging_Table__c testdata14 = new Data_Staging_Table__c();
       testdata14.OMX_Primary_Key__c='';
       testdata14.Company_Name__c='Wipro';
       testdata14.OMX_Rep_Number__c='9876';
       testdata14.Address_Line_1__c='bhyter';
       testdata14.City__c='noida';
       testdata14.State__c='UP';
       testdata14.Zip__c='uty';
        testdata14.Contact_Last_Name__c='sinha';
        testdata14.Contact_Email__c='niraj.sinha@wipro.com';
        testdata14.Opportunity_Name__c='Eureka';
         testdata14.Primary_Product__c='filter';
         testdata14.Opportunity_Amount__c=1;
         testdata14.Primary_Competitor__c='tata';
         testdata14.Anticipated_Close_Date__c=System.now().date();
         testdata14.Customer_Lifecycle__c='legend';
         testdata14.Probability__c=100;
         testdata14.Opportunity_Stage__c='';
       
       lstdatastaging.add(testdata14) ;
       
       
       Data_Staging_Table__c testdata3 = new Data_Staging_Table__c();
       testdata3.OMX_Primary_Key__c='twoiu';
       testdata3.OMX_Rep_Number__c='9876';
       lstdatastaging.add(testdata3);*/
       
       insert lstdatastaging;
       
       string CRON_EXP= '0 0 0 3 9 ? 2022'; 
       String s = 'Select Id,OMX_Rep_Number__c,Company_Name__c,Website__c,WCW_Count__c,'+
       'Address_Line_1__c,Address_Line_2__c,City__c,State__c,Zip__c,Contact_First_Name__c,Contact_Last_Name__c,Notes__c,'+
       'Contact_Phone__c,Contact_Email__c,Opportunity_Name__c,Primary_Product__c,Opportunity_Amount__c,Probability__c,Opportunity_Stage__c,'+
       'Primary_Competitor__c,Anticipated_Close_Date__c,Customer_Lifecycle__c,OMX_Primary_Key__c,Status__c from Data_Staging_Table__c where Status__c = \'Not Started\' ';
       Test.startTest();
       ProspectUpload_Batch assignBatch = new ProspectUpload_Batch();
       assignBatch.strQuery =s;
       database.executebatch(assignBatch, 20); 
       System.schedule('AssignmentBatch1',CRON_EXP , assignBatch);
       ProspectUpload_Batch assignBatch1 = new ProspectUpload_Batch(s);
       System.schedule('Assignment Batch',CRON_EXP , assignBatch1);
       database.executebatch(assignBatch1, 20); 
       Test.stopTest();
   } 
   }
}