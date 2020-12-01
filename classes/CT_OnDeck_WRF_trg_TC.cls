@istest

public class CT_OnDeck_WRF_trg_TC{
    static testMethod void Method1(){
        //try{
            List<Account> accList = new List<Account>();
            List<Customer_Transition__c> custList = new List<Customer_Transition__c>();     
            Map<String,Schema.RecordTypeInfo> CaseRecType = Schema.SObjectType.Case.getRecordTypeInfosByName();

            Profile profileObj = [select id from profile where name='System Administrator']; 

            String profId = profileObj.id;
            user usrObj = new user(Username='abc@officedepot.com.uat',FirstName ='Fname', LastName='Lname', Alias='abc', CommunityNickname='abc', LocaleSidKey='en_US', EmailEncodingKey='UTF-8', Profileid = profId, LanguageLocaleKey='en_US', email='abc@officedepot.com.uat',TimeZoneSidKey='America/New_York');
            usrObj.Short_Title__c='';
            Insert usrObj;   
        system.runas(usrobj){
            Sales_Person__c sales= new Sales_Person__c();
            sales.IsActive__c=true;
            sales.Role_Relate_Id__c ='333333';
            sales.Primary__c =true;
            sales.user__c=usrObj.id;
            insert sales;
            
            Account acc = new Account ();
            acc.name = 'SUN Test Account';
            acc.BillingStreet = '1040 N 326 W';
            acc.billingcity = 'Orem';
            acc.BillingState = 'UT';
            acc.Billingcountry = 'USA';
            acc.OMX_Primary_Key__c = '123457';
            acc.Oracle_Party_Id__c = '123457';
            acc.AOPS_Cust_Id__c = '123457';
            acc.status__c='Active';
            acc.Split_Record__c = true;
            acc.Segment__c='Federal';
            accList.add(acc);
            insert accList; 
            
            ACE_Settings__c desettings = new ACE_Settings__c(Expiry_Days__c=2,EsclationDays__c=1,processing_window__c=2,BatchName__c='Q4-2014',Vendavo_Update_Start_Date__c = system.today(), Vendavo_Update_End_Date__c = system.today()+5);
            insert desettings; 
         
            ACE_Customer_Price_Changes__c ace1 = new ACE_Customer_Price_Changes__c(name='test',SRM_Differential__c=5,Item_12_Month_Qty__c = 50,Total_Spend_Impact_12_Month__c=5,Customer__c = acc.id, Owning_Customer_ID__c ='123456',
                                          sfdc_notification_flag__c='2',Customer_Notification_Date_Approved__c  = date.today().AddDays(-2), Remediation_Hold__c = false , Reschduled_For_Reminder__c = false,
                                          Exception_Date_Lock__c = true, Hosted_Catalog__c = true);
            insert ace1;
            Case WRFCase = new Case();
            WRFCase.RecordTypeId = CaseRecType.get('Work Request').getRecordTypeId();
            WRFCase.Status='New';
            WRFCase.WRF_Submission_Issue__c='Complete and Accurate';
            WRFCase.WRF_Request_Type__c='Automatic Toner Replenishment (ATR)';
            WRFCase.Customer_Core_Price_Changes__c=ace1.id;
            WRFCase.WRF_Request_Type__c = 'BSD Pricing';
            WRFCase.accountId = accList[0].id;		//Case#00175758-------Hitesh [Aug 11, 2016]
            insert WRFCase;

         
                Test.startTest();        
               
                           
                Customer_Transition__c CusTrans = new Customer_Transition__c();
                CusTrans.name='test';
                CusTrans.Account__c=acc.id;
                CusTrans.Status__c='On Deck';
                CusTrans.Billing_Frequency_Excptn__c=true;
                CusTrans.AOPS_Flag__c='Y';
                CusTrans.OMX_Primary_Key__c='123457';
                CusTrans.Transition_Status__c='Active';
                CusTrans.Written_Agreement_ID__c = null;
                
                //  CusTrans.Written_Agreement_Customer_No__c= acc.OMX_Primary_Key__c;
                       
                custList.add(CusTrans); 

                Customer_Transition__c CusTrans1 = new Customer_Transition__c();
                CusTrans1.name='test1';
                CusTrans1.Account__c=acc.id;
                CusTrans1.Status__c='On Deck';
                CusTrans1.Billing_Frequency_Excptn__c=true;
                CusTrans1.AOPS_Flag__c='Y';
                CusTrans1.OMX_Primary_Key__c='123456';
                CusTrans1.Transition_Status__c='Active';
                
                //CusTrans1.Written_Agreement_Customer_No__c= acc.OMX_Primary_Key__c;
                CusTrans1.Written_Agreement__c = true;        
                custList.add(CusTrans1);
                
                
                Customer_Transition__c CusTrans2 = new Customer_Transition__c();
                CusTrans2.name='test2';
                CusTrans2.Account__c=acc.id;
                CusTrans2.Status__c='test1';
                CusTrans2.Billing_Frequency_Excptn__c=true;
                CusTrans2.AOPS_Flag__c='Y';
                CusTrans2.OMX_Primary_Key__c='';
                CusTrans2.Transition_Status__c='Active';
                CusTrans2.Written_Agreement_ID__c = null;
                CusTrans2.Written_Agreement__c = true;     
                custList.add(CusTrans2);
                
                insert custList;

                CusTrans.OMX_Primary_Key__c='';
                CusTrans.Status__c='On Deck';
                CusTrans.Related_WRF_Case__c = NULL;
                //CusTrans.Customer_Disposition__c='Extend current OMX Agreement'; 
                CusTrans1.Customer_Disposition__c='Customer RFP Received';
                CusTrans2.OMX_Primary_Key__c = '123458';
                CusTrans2.Status__c = 'On Deck';
                custList.clear();
                custList.add(CusTrans); 
                CusTrans1.Status__c = 'Test';
                CusTrans1.Extension_in_Development__c = true;
                CusTrans1.Related_WRF_Case__c = WRFCase.Id;
                custList.add(CusTrans1);
                custList.add(CusTrans2);
                
                system.debug('custList>>>>>>>>>'+custList);
                update custList;


                test.stoptest();
            }
        //}
        //catch(Exception e){}

    }
}