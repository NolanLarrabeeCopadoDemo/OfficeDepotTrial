@isTest()
private class ProspectUpload_Batch_OD_TC 
{
   static testMethod void ProspectUpload_Batch_OD_TC()
   {
       System.runAs(new user(ID = UserInfo.getUserID())){
   
      Profile p = [SELECT Id FROM profile WHERE name='System Administrator'];
       User us1 = new User(alias = 'us_1',OMX_Rep_Number__c='9876', email='proxy@proxy1456.officedepot.com',OD_Employee_ID__c='113456',emailencodingkey='UTF-8', lastname='lastnam1',languagelocalekey='en_US',localesidkey='en_US', profileid = p.Id,timezonesidkey='America/Los_Angeles',username='12proxy@proxy456.com');
       insert us1;
       
       system.runas(us1)
       {
           
       
      
         Sales_Person__c testsalesper= new Sales_Person__c();
       testsalesper.ExtIDSalesPerson__c='9876';
       testsalesper.Primary__c=true;
       testsalesper.IsActive__c=true;
       testsalesper.Name='271991';
       testsalesper.user__c=us1.id;
       
          
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
      //  acct.Sales_PersonID__c =testsalesper.id;
        insert acct;
           
        Test.startTest();
                
       Data_Staging_Table__c testdata= new Data_Staging_Table__c();
       testdata.SalesRepID__C='271991';
       testdata.name='271991';
       testdata.OMX_Rep_Number__c='9876';
       testdata.Company_Name__c='Office max pros1';
       testdata.Website__c='http://www.test.com';
       testdata.WCW_Count__c=18;
       testdata.Address_Line_1__c='Test add';
       testdata.Address_Line_2__c='test add1';
       testdata.City__c='Test city';
       testdata.State__c='AL';
       testdata.Country__c='CAN';
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
       testdata.Status__c='OD Not Started';
       
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
       
      //List<Data_Staging_Table__c> lstdatastaging = new List<Data_Staging_Table__c>();
       
    //  lstdatastaging 
       
       
     //  Data_Staging_Table__c testdata1 = new Data_Staging_Table__c();
      // testdata.SalesRepID__C='testingtesting';
       //testdata.name='';
      // testdata1.Company_Name__c='';
       //testdata1.OMX_Primary_Key__c=null;
       //lstdatastaging.add(testdata);
       //insert testdata1;
       
      // Data_Staging_Table__c testdata2 = new Data_Staging_Table__c();
      /*Data_Staging_Table__c testdata2 = new Data_Staging_Table__c();

       testdata2.Contact_Last_Name__c='sinha';
       lstdatastaging.add(testdata2);
             
       
       Data_Staging_Table__c testdata3 = new Data_Staging_Table__c();
       testdata3.OMX_Primary_Key__c='twoiu';
       testdata3.OMX_Rep_Number__c='9876';
       lstdatastaging.add(testdata3);*/
          // if(!lstdatastaging.isempty()){
       //update lstdatastaging;
           }
       
       
       
       string CRON_EXP= '0 0 0 3 9 ? 2022'; 
       String s = 'Select Id, SalesRepID__C, Company_Name__c, Website__c, WCW_Count__c, Sector__c, Buying_Group__C, Segment__C, Error__c,'+
    'Address_Line_1__c, Address_Line_2__c, City__c, State__c, Zip__c, Country__c, Contact_First_Name__c, Contact_Last_Name__c, Contact_Title__c,'+
    'Contact_Phone__c,Contact_Email__c, Pricing_template_cd__c, Industry_OD_SIC_Rep__c, Primary_Product__c, Primary_Competitor__c, Anticipated_Close_Date__c,'+
    'Customer_Lifecycle__c, Status__c,ProspectID__c from Data_Staging_Table__c where Status__c = \'OD Not Started\' ';
       
       ProspectUpload_Batch_OD assignBatch = new ProspectUpload_Batch_OD();
       assignBatch.strQuery =s;
       database.executebatch(assignBatch, 1); 
      
       System.schedule('AssignmentBatch1',CRON_EXP , assignBatch);
   
      ProspectUpload_Batch_OD assignBatch1 = new ProspectUpload_Batch_OD(s);
       System.schedule('Assignment Batch',CRON_EXP , assignBatch1);
       database.executebatch(assignBatch1, 1); 
       Test.stopTest();
   } 
   }
                    }