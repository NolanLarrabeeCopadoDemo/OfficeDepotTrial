@isTest
 public class Load_CustTransData_Batch2_TC{
      static testMethod void myTest(){ 

         CustTransParentChildLevel__c  CustParentChild = new CustTransParentChildLevel__c(name='test1',
                                                             Parent_Child_Level__c= 'Parent',
                                                             AddSeconds__c=300,
                                                             AddHours__c=1);
         insert CustParentChild; 

        user u2=[SELECT id,ProfileId,OD_Employee_ID__c,TimeZoneSidKey FROM USER WHERE id =:UserInfo.getUserId()];
        user u = new user(email='abc.xyz@officedepot.com',Username='jasmet@acme.com',FirstName ='test123', LastName='xyz123', Alias='a', CommunityNickname='aa', LocaleSidKey='en_US', EmailEncodingKey='UTF-8', ProfileId=u2.ProfileId, LanguageLocaleKey='en_US');
        //LSLEVIN 2.10.16 S-376887 Updated below line to include OD
        u.OD_Employee_ID__c = 'xxyyOD000000';
        u.isActive = true;
        insert u ;

        Sales_Person__c salesPerson = new Sales_Person__c(User__c = u.id, IsActive__c = true, Primary__c = true);
        salesPerson.Role_Relate_Id__c='000000';
        insert salesPerson ;
        
          Account acc = new Account ();
          acc.name = 'Test Account';
          acc.BillingStreet = '1040 N 326 W';
          acc.billingcity = 'Orem';
          acc.BillingState = 'UT';
          acc.Billingcountry = 'USA';
          acc.Status__c ='Active';
          acc.aops_cust_id__c = null;
          acc.OMX_Primary_key__c = '1234567';
          acc.OMX_Mainframe_Account_Level__c = 'National';
          acc.recordtypeid=Schema.SObjectType.Account.getRecordTypeInfosByName().get('Customer (OfficeMax)').getRecordTypeId();
          acc.Sales_PersonID__c = salesPerson.id; //Sales person Id for the Salesforce USer
          insert acc;
          
          Account acc2 = new Account ();
          acc2.name = 'Test Account2';
          acc2.BillingStreet = '1040 N 326 W';
          acc2.billingcity = 'Orem';
          acc2.BillingState = 'UT';
          acc2.Billingcountry = 'USA';
          acc2.Status__c ='Active';
          acc2.aops_cust_id__c = null;
          acc2.OMX_Primary_key__c = '12345673';
          acc2.OMX_Mainframe_Account_Level__c = 'National';
          acc2.Sales_PersonID__c = salesPerson.id; //Sales person Id for the Salesforce USer
          insert acc2;
          
          Test.startTest();
         
          Customer_Transition__c CT = new Customer_Transition__c(Status__c = 'Launched',
                                                 Ready_for_Mod1__c = true,
                                                 Name='Customer Transition Parent of test',
                                                 AOPS_Flag__c = 'Y',
                                                 Transition_Status__c='Active',
                                                 Ship_2_Bill_2_Code__c='N',
                                                 Error_Code__c ='',
                                                 Freight_Charge_Flag__c='Y',
                                                 Invoice_Email1__c= 'test@email.com',
                                                 AR_Phone__c = '98989898989',
                                                 Account__c = acc.id);
        insert CT;
        
        Customer_Transition__c CT1 = new Customer_Transition__c(Status__c = 'Launched',
                                                 Ready_for_Mod1__c = true,
                                                 Name='Customer Transition of test2',
                                                 AOPS_Flag__c = 'Y',
                                                 Transition_Status__c='Active',
                                                 Error_Code__c ='',
                                                 AR_Phone__c = '98989898989',
                                                 Account__c = acc2.id);
        insert CT1;
        
        Default_Pricing_Template__c DPT = new Default_Pricing_Template__c(name='Standard Web Match Test',Template_Name__c='Standard Web Match Test');
        insert DPT;

        Customer_Transition_Dtls__c ctd = new Customer_Transition_Dtls__c(Customer_Transition_ID__c=CT.id,
                                                Status__c='Active',
                                                AOPS_Flag__c='Y',
                                                Ship_2_Bill_2_Code__c = 'B',
                                                RecordTypeID = Schema.SObjectType.Customer_Transition_Dtls__c.getRecordTypeInfosByName().get('Sites').getRecordTypeId(),
                                                OMX_Primary_Key__c='543456');
        insert ctd;

        Customer_Transition_Dtls__c ctd1 = new Customer_Transition_Dtls__c(Customer_Transition_ID__c=CT1.id,
                                                Status__c='Active',
                                                AOPS_Flag__c='Y',
                                                Ship_2_Bill_2_Code__c = 'B',
                                                RecordTypeID = Schema.SObjectType.Customer_Transition_Dtls__c.getRecordTypeInfosByName().get('Sites').getRecordTypeId(),
                                                OMX_Primary_Key__c='543451');
        insert ctd1;
        
        Pricing_template__c temp = new Pricing_template__c(name = 'Standard Web Match Test' ,
                                    Contract_Number_10__c='1',
                                    Contract_Number_1__c='1',
                                    Contract_Number_2__c='1',
                                    Contract_Number_3__c='1',
                                    Contract_Number_4__c='1',
                                    Contract_Number_5__c='1',
                                    Contract_Number_6__c='1',
                                    Contract_Number_7__c='1',
                                    Contract_Number_8__c='1',
                                    Contract_Number_9__c='1',
                                    Priority_1__c='1',
                                    Priority_2__c='1',
                                    Priority_3__c='1',
                                    Priority_4__c='1',
                                    Priority_5__c='1',
                                    Priority_6__c='1',
                                    Priority_7__c='1',
                                    Priority_8__c='1',
                                    Priority_9__c='1',
                                    Priority_10__c='1',
                                    Cust_Prod_Xref__c='1',
                                    Delivery_Code__c='1',
                                    Exclude_Universal_Pricing__c='1',
                                    GP_Floor_Percernt__c='1',
                                    Loyalty__c='No',
                                    Minimum_Order_Value__c='1',
                                    Off_Contract_Code__c='1',
                                    Off_Contract_Percent__c='1',
                                    Off_Wholesale_Code__c='1',
                                    Off_Wholesale_Percent__c='1',
                                    Price_Plan_Id__c='7200000-300',
                                    Account_Setup_Notes_c__c = 'This account will be auto setup within 10 mins. Comments will not be read.', 
                                    Revenue_Band__c='STANDARD',
                                    Freight_Charge__c = 'Yes',
                                    Parent_Id__c = '123456');
        insert temp;
            
        //Test.startTest();                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            //Tax_Exemption__c                                                                                                                                                                                                                                                                                                                                                                                                                                  
           List<customer_transition__c> CT2 = [SELECT id,Final_Split_Decision__c,account__r.sic,account__r.Split_Record__c,Tax_Exemption__c,Service_Charge_Code__c,Freight_Charge_Flag__c,Pricing_on_packing_list__c,Mixture_of_exempt_non_exempt__c,Release_Number_Required__c,customer_transition_type__c,recordtype.name,recordtypeid,OwnerId,IsDeleted, CreatedById, Createddate,LastModifiedDate, LastModifiedById,Invoice_Email1__c,Fax_back_phone_number__c, Invoice_Email2__c, AR_Primary_Contact_First_Name__c,AR_Primary_Contact_Last_Name__c,AR_Phone__c,Cost_Center_Required__c,Back_Order_Cancel_or_Allow__c,Billing_Type_Flag__c,Billing_Frequency__c,AR_Flag__c,PO_Number_Required__c,Primary_Contact_First_Name__c,Primary_Contact_Last_Name__c,Primary_Contact_Phone__c,Retail_Connect__c,Copies_in_Packing_list__c,Promo_Email__c,Promo_Phone__c,
                                   Promo_Catalog__c,Promo_Flyer__c,Drop_Ship_Flag__c,MIPAL_alternate_location_flag__c,Account__r.OwnerId,Account__r.id,Account__r.ParentId,Account__r.Phone,Account__r.Parent.AOPS_Cust_Id__c,Account__r.Related_Parent_Account__c,Account__r.Duns_Number__c,Account__r.Oracle_Party_ID__c,Account__r.Segment__c,Account__r.Name,Account__r.Ultimate_Duns_Number__c,Account__r.Omx_Primary_Key__c,Account__r.Sales_PersonID__r.name,Account__r.Oracle_Party_Site_ID__c,Account__r.Country__c,Account__r.City__c,Account__r.State__c,Account__r.Address2__c,Account__r.Address1__c,Account__r.Zip__c,AOPS_Flag__c,Primary_Contact_Phone_Extension__c,Billing_Document_Type__c,Error_Code__c,Account__r.Related_Account__c 
                                   FROM Customer_Transition__c where (account__r.sales_personid__c!=null or account__r.sales_personid__c!='') and (Status__c='Launched' or (Error_Message_Level__c='Initial Account Setup Failure' and Error_Message_Type__c='System Failure' and Status__c='Error - Launched')) and AOPS_Flag__c ='Y' and Account__r.Status__c = 'Active' and customer_transition_type__c='Parent'and Account__r.OMX_Mainframe_Account_Level__c = 'National' and Transition_Status__c='Active' and (Account__r.AOPS_Cust_Id__c=null or Account__r.AOPS_Cust_Id__c='') and (Error_Code__c = null or Error_Code__c != 'Processing')];
           system.debug('@@@@@@@@'+CT2.size());
           //Load_CustTransData_Batch2 batch = new Load_CustTransData_Batch2(); 
           //database.executebatch(batch , 10);                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                          //Tax_Exemption__c                                                                                                                                                                                                             
           String DEFAULT_QUERY = 'SELECT id,Final_Split_Decision__c,account__r.sic,account__r.Split_Record__c,Tax_Exemption__c,Service_Charge_Code__c,Freight_Charge_Flag__c,Pricing_on_packing_list__c,Mixture_of_exempt_non_exempt__c,Release_Number_Required__c,customer_transition_type__c,recordtype.name,recordtypeid,OwnerId,IsDeleted, CreatedById, Createddate,LastModifiedDate, LastModifiedById,Invoice_Email1__c,Fax_back_phone_number__c, Invoice_Email2__c, AR_Primary_Contact_First_Name__c,AR_Primary_Contact_Last_Name__c,AR_Phone__c,Cost_Center_Required__c,Back_Order_Cancel_or_Allow__c,Billing_Type_Flag__c,Billing_Frequency__c,AR_Flag__c,PO_Number_Required__c,Primary_Contact_First_Name__c,Primary_Contact_Last_Name__c,Primary_Contact_Phone__c,Retail_Connect__c,Copies_in_Packing_list__c,Promo_Email__c,Promo_Phone__c,'
                                  +' Promo_Catalog__c,Promo_Flyer__c,Drop_Ship_Flag__c,MIPAL_alternate_location_flag__c,Account__r.OwnerId,Account__r.id,Account__r.ParentId,Account__r.Phone,Account__r.Parent.AOPS_Cust_Id__c,Account__r.Related_Parent_Account__c,Account__r.Duns_Number__c,Account__r.Oracle_Party_ID__c,Account__r.Segment__c,Account__r.Name,Account__r.Ultimate_Duns_Number__c,Account__r.Omx_Primary_Key__c,Account__r.Sales_PersonID__r.name,Account__r.Oracle_Party_Site_ID__c,Account__r.Country__c,Account__r.City__c,Account__r.State__c,Account__r.Address2__c,Account__r.Address1__c,Account__r.Zip__c,AOPS_Flag__c,Primary_Contact_Phone_Extension__c,Billing_Document_Type__c,Error_Code__c,Account__r.Related_Account__c '
                                  +' FROM Customer_Transition__c where (account__r.sales_personid__c!=null or account__r.sales_personid__c!=\'\') and (Status__c=\'Launched\' or (Error_Message_Level__c=\'Initial Account Setup Failure\' and Error_Message_Type__c=\'System Failure\' and Status__c=\'Error - Launched\')) and AOPS_Flag__c =\'Y\' and Account__r.Status__c = \'Active\' and customer_transition_type__c=\'Parent\'and Account__r.OMX_Mainframe_Account_Level__c = \'National\' and Transition_Status__c=\'Active\' and (Account__r.AOPS_Cust_Id__c=null or Account__r.AOPS_Cust_Id__c=\'\') and (Error_Code__c = null or Error_Code__c != \'Processing\')';
            //where (account__r.sales_personid__c!=null or account__r.sales_personid__c!=\'\') and (Status__c=\'Launched\' or (Error_Message_Level__c=\'Initial Account Setup Failure\' and Error_Message_Type__c=\'System Failure\' and Status__c=\'Error - Launched\')) and AOPS_Flag__c =\'Y\' and Account__r.Status__c = \'Active\' and customer_transition_type__c=\'Parent\'and Account__r.OMX_Mainframe_Account_Level__c = \'National\' and Transition_Status__c=\'Active\' and (Account__r.AOPS_Cust_Id__c=null or Account__r.AOPS_Cust_Id__c=\'\') and (Error_Code__c = null or Error_Code__c != \'Processing\') limit 1';
           
           
           Load_CustTransData_Batch2 batch2 = new Load_CustTransData_Batch2(DEFAULT_QUERY); 
           batch2.nullcheck(null);
           database.executebatch(batch2 , 1);
        Test.stopTest();
       
      }
      
  // added for the story #S-355234 #START
  static testMethod void myTest1(){ 
        
        CustTransParentChildLevel__c  CustParentChild = new CustTransParentChildLevel__c(name='test1',
                                                             Parent_Child_Level__c= 'Parent',
                                                             AddSeconds__c=300,
                                                             AddHours__c=1);
         insert CustParentChild; 

        user u2=[SELECT id,ProfileId,OD_Employee_ID__c,TimeZoneSidKey FROM USER WHERE id =:UserInfo.getUserId()];
        user u = new user(email='abc.xyz@officedepot.com',Username='jasmet@acme.com',FirstName ='test123', LastName='xyz123', Alias='a', CommunityNickname='aa', LocaleSidKey='en_US', EmailEncodingKey='UTF-8', ProfileId=u2.ProfileId, LanguageLocaleKey='en_US');
        //LSLEVIN 2.10.16 S-376887 updated below line to include OD
        u.OD_Employee_ID__c = 'xxyyOD003570';
        u.isActive = true;
        insert u ;

        Sales_Person__c salesPerson = new Sales_Person__c(User__c = u.id, IsActive__c = true, Primary__c = true);
        salesPerson.Role_Relate_Id__c='000000';
        insert salesPerson ;
        
          Account acc = new Account ();
          acc.name = 'Test Account Account1 Account2 Account3';
          acc.BillingStreet = '1040 N 326 W';
          acc.billingcity = 'Orem';
          acc.BillingState = 'UT';
          acc.Billingcountry = 'USA';
          acc.Status__c ='Active';
          acc.aops_cust_id__c = null;
          acc.OMX_Primary_key__c = '1234567';
          acc.OMX_Mainframe_Account_Level__c = 'National';
          acc.recordtypeid=Schema.SObjectType.Account.getRecordTypeInfosByName().get('Customer (OfficeMax)').getRecordTypeId();
          acc.Sales_PersonID__c = salesPerson.id; //Sales person Id for the Salesforce USer
          acc.Phone = '7016511035';
          insert acc;
          
          Account acc2 = new Account ();
          acc2.name = 'Test Account0 Account1 Account2 Account3';
          acc2.BillingStreet = '1040 N 326 W';
          acc2.billingcity = 'Orem';
          acc2.BillingState = 'UT';
          acc2.Billingcountry = 'USA';
          acc2.Status__c ='Active';
          acc2.aops_cust_id__c = null;
          acc2.OMX_Primary_key__c = '12345673';
          acc2.OMX_Mainframe_Account_Level__c = 'National';
          acc2.Sales_PersonID__c = salesPerson.id; //Sales person Id for the Salesforce USer
          insert acc2;
          
          Test.startTest();
         
        Customer_Transition__c CT = new Customer_Transition__c(Status__c = 'Launched',
                                                 Ready_for_Mod1__c = true,
                                                 Name='Customer Transition Parent of test',
                                                 AOPS_Flag__c = 'Y',
                                                 Transition_Status__c='Active',
                                                 Ship_2_Bill_2_Code__c='N',
                                                 Error_Code__c ='',
                                                 Freight_Charge_Flag__c='Y',
                                                 Invoice_Email1__c= 'test@email.com',
                                                 Release_Number_Required__c = 'Y',
                                                 Back_Order_Cancel_or_Allow__c = 'Y',
                                                 Billing_Type_Flag__c = 'P',
                                                 Billing_Frequency__c = 'D',
                                                 Final_Split_Decision__c = 'Yes',
                                                 Mixture_of_exempt_non_exempt__c = true,
                                                 Cost_Center_Required__c = 'Y',
                                                 Billing_Document_Type__c = 'C',
                                                 Retail_Connect__c = true,
                                                 Primary_Contact_Phone__c = '7016511034',
                                                 AR_Flag__c = 'Y',
                                                 PO_Number_Required__c = 'Y',
                                                 Account__c = acc.id);
        insert CT;
        
        Customer_Transition__c CT1 = new Customer_Transition__c(Status__c = 'Launched',
                                                 Ready_for_Mod1__c = true,
                                                 Name='Customer Transition of test2',
                                                 AOPS_Flag__c = 'Y',
                                                 Transition_Status__c='Active',
                                                 Error_Code__c ='',
                                                 Release_Number_Required__c = 'Y',
                                                 Back_Order_Cancel_or_Allow__c = 'Y',
                                                 Billing_Type_Flag__c = 'P',
                                                 Billing_Frequency__c = 'W',
                                                 Final_Split_Decision__c = 'Yes',
                                                 Mixture_of_exempt_non_exempt__c = true,
                                                 Cost_Center_Required__c = 'Y',
                                                 Billing_Document_Type__c = 'C',
                                                 Retail_Connect__c = true,
                                                 Primary_Contact_Phone__c = '7016511033',
                                                 AR_Flag__c = 'Y',
                                                 PO_Number_Required__c = 'Y',
                                                 Account__c = acc2.id);
        insert CT1;
        
        Default_Pricing_Template__c DPT = new Default_Pricing_Template__c(name='Standard Web Match Test',Template_Name__c='Standard Web Match Test');
        insert DPT;

        Customer_Transition_Dtls__c ctd = new Customer_Transition_Dtls__c(Customer_Transition_ID__c=CT.id,
                                                Status__c='Active',
                                                AOPS_Flag__c='Y',
                                                Ship_2_Bill_2_Code__c = 'B',
                                                RecordTypeID = Schema.SObjectType.Customer_Transition_Dtls__c.getRecordTypeInfosByName().get('Sites').getRecordTypeId(),
                                                OMX_Primary_Key__c='543456');
        insert ctd;

        Customer_Transition_Dtls__c ctd1 = new Customer_Transition_Dtls__c(Customer_Transition_ID__c=CT1.id,
                                                Status__c='Active',
                                                AOPS_Flag__c='Y',
                                                Ship_2_Bill_2_Code__c = 'B',
                                                RecordTypeID = Schema.SObjectType.Customer_Transition_Dtls__c.getRecordTypeInfosByName().get('Sites').getRecordTypeId(),
                                                OMX_Primary_Key__c='543451');
        insert ctd1;
        
        Pricing_template__c temp = new Pricing_template__c(name = 'Standard Web Match Test' ,
                                    Contract_Number_10__c='1',
                                    Contract_Number_1__c='1',
                                    Contract_Number_2__c='1',
                                    Contract_Number_3__c='1',
                                    Contract_Number_4__c='1',
                                    Contract_Number_5__c='1',
                                    Contract_Number_6__c='1',
                                    Contract_Number_7__c='1',
                                    Contract_Number_8__c='1',
                                    Contract_Number_9__c='1',
                                    Priority_1__c='1',
                                    Priority_2__c='1',
                                    Priority_3__c='1',
                                    Priority_4__c='1',
                                    Priority_5__c='1',
                                    Priority_6__c='1',
                                    Priority_7__c='1',
                                    Priority_8__c='1',
                                    Priority_9__c='1',
                                    Priority_10__c='1',
                                    Cust_Prod_Xref__c='1',
                                    Delivery_Code__c='1',
                                    Exclude_Universal_Pricing__c='1',
                                    GP_Floor_Percernt__c='1',
                                    Loyalty__c='No',
                                    Minimum_Order_Value__c='1',
                                    Off_Contract_Code__c='1',
                                    Off_Contract_Percent__c='1',
                                    Off_Wholesale_Code__c='1',
                                    Off_Wholesale_Percent__c='1',
                                    Price_Plan_Id__c='7200000-300',
                                    Account_Setup_Notes_c__c = 'This account will be auto setup within 10 mins. Comments will not be read.', 
                                    Revenue_Band__c='STANDARD',
                                    Freight_Charge__c = 'Yes',
                                    Parent_Id__c = '123456');
        insert temp;
            
        String DEFAULT_QUERY = 'SELECT id,Final_Split_Decision__c,account__r.sic,account__r.Split_Record__c,Tax_Exemption__c,Service_Charge_Code__c,Freight_Charge_Flag__c,Pricing_on_packing_list__c,Mixture_of_exempt_non_exempt__c,Release_Number_Required__c,customer_transition_type__c,recordtype.name,recordtypeid,OwnerId,IsDeleted, CreatedById, Createddate,LastModifiedDate, LastModifiedById,Invoice_Email1__c,Fax_back_phone_number__c, Invoice_Email2__c, AR_Primary_Contact_First_Name__c,AR_Primary_Contact_Last_Name__c,AR_Phone__c,Cost_Center_Required__c,Back_Order_Cancel_or_Allow__c,Billing_Type_Flag__c,Billing_Frequency__c,AR_Flag__c,PO_Number_Required__c,Primary_Contact_First_Name__c,Primary_Contact_Last_Name__c,Primary_Contact_Phone__c,Retail_Connect__c,Copies_in_Packing_list__c,Promo_Email__c,Promo_Phone__c,'
                                  +' Promo_Catalog__c,Promo_Flyer__c,Drop_Ship_Flag__c,MIPAL_alternate_location_flag__c,Account__r.OwnerId,Account__r.id,Account__r.ParentId,Account__r.Phone,Account__r.Parent.AOPS_Cust_Id__c,Account__r.Related_Parent_Account__c,Account__r.Duns_Number__c,Account__r.Oracle_Party_ID__c,Account__r.Segment__c,Account__r.Name,Account__r.Ultimate_Duns_Number__c,Account__r.Omx_Primary_Key__c,Account__r.Sales_PersonID__r.name,Account__r.Oracle_Party_Site_ID__c,Account__r.Country__c,Account__r.City__c,Account__r.State__c,Account__r.Address2__c,Account__r.Address1__c,Account__r.Zip__c,AOPS_Flag__c,Primary_Contact_Phone_Extension__c,Billing_Document_Type__c,Error_Code__c,Account__r.Related_Account__c, Split_AR_Contact_First_Name__C, Split_AR_Contact_Last_Name__C, Split_AR_Phone__c '
                                  +' FROM Customer_Transition__c where (account__r.sales_personid__c!=null or account__r.sales_personid__c!=\'\') and (Status__c=\'Launched\' or (Error_Message_Level__c=\'Initial Account Setup Failure\' and Error_Message_Type__c=\'System Failure\' and Status__c=\'Error - Launched\')) and AOPS_Flag__c =\'Y\' and Account__r.Status__c = \'Active\' and customer_transition_type__c=\'Parent\'and Account__r.OMX_Mainframe_Account_Level__c = \'National\' and Transition_Status__c=\'Active\' and (Account__r.AOPS_Cust_Id__c=null or Account__r.AOPS_Cust_Id__c=\'\') and (Error_Code__c = null or Error_Code__c != \'Processing\')';
            
        //Test.startTest();                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            //Tax_Exemption__c                                                                                                                                                                                                                                                                                                                                                                                                                                  
           List<customer_transition__c> CT2 = [SELECT id,Final_Split_Decision__c,account__r.sic,account__r.Split_Record__c,Tax_Exemption__c,Service_Charge_Code__c,Freight_Charge_Flag__c,Pricing_on_packing_list__c,Mixture_of_exempt_non_exempt__c,Release_Number_Required__c,customer_transition_type__c,recordtype.name,recordtypeid,OwnerId,IsDeleted, CreatedById, Createddate,LastModifiedDate, LastModifiedById,Invoice_Email1__c,Fax_back_phone_number__c, Invoice_Email2__c, AR_Primary_Contact_First_Name__c,AR_Primary_Contact_Last_Name__c,AR_Phone__c,Cost_Center_Required__c,Back_Order_Cancel_or_Allow__c,Billing_Type_Flag__c,Billing_Frequency__c,AR_Flag__c,PO_Number_Required__c,Primary_Contact_First_Name__c,Primary_Contact_Last_Name__c,Primary_Contact_Phone__c,Retail_Connect__c,Copies_in_Packing_list__c,Promo_Email__c,Promo_Phone__c,
                                   Promo_Catalog__c,Promo_Flyer__c,Drop_Ship_Flag__c,MIPAL_alternate_location_flag__c,Account__r.OwnerId,Account__r.id,Account__r.ParentId,Account__r.Phone,Account__r.Parent.AOPS_Cust_Id__c,Account__r.Related_Parent_Account__c,Account__r.Duns_Number__c,Account__r.Oracle_Party_ID__c,Account__r.Segment__c,Account__r.Name,Account__r.Ultimate_Duns_Number__c,Account__r.Omx_Primary_Key__c,Account__r.Sales_PersonID__r.name,Account__r.Oracle_Party_Site_ID__c,Account__r.Country__c,Account__r.City__c,Account__r.State__c,Account__r.Address2__c,Account__r.Address1__c,Account__r.Zip__c,AOPS_Flag__c,Primary_Contact_Phone_Extension__c,Billing_Document_Type__c,Error_Code__c,Account__r.Related_Account__c 
                                   FROM Customer_Transition__c where (account__r.sales_personid__c!=null or account__r.sales_personid__c!='') and (Status__c='Launched' or (Error_Message_Level__c='Initial Account Setup Failure' and Error_Message_Type__c='System Failure' and Status__c='Error - Launched')) and AOPS_Flag__c ='Y' and Account__r.Status__c = 'Active' and customer_transition_type__c='Parent'and Account__r.OMX_Mainframe_Account_Level__c = 'National' and Transition_Status__c='Active' and (Account__r.AOPS_Cust_Id__c=null or Account__r.AOPS_Cust_Id__c='') and (Error_Code__c = null or Error_Code__c != 'Processing')];

           Load_CustTransData_Batch2 batch21 = new Load_CustTransData_Batch2(DEFAULT_QUERY); 
           batch21.nullcheck(null);
           database.executebatch(batch21 , 1);
           
        Test.stopTest();
        
      }
      // added for the story #S-355234 #END
 }