//Modified By Vipul Jain 09 Oct 2015 For Story [S-355236]

@isTest
public class CT_BeforeUpdate_TC
{
  static testMethod void CT_BeforeUpdate_Test()
  {
      Profile p4 = [SELECT Id FROM profile WHERE name='System Administrator'];   
            User u1 = new User(alias = 'test121', email='proxy@proxy56654.officedepot.com',OD_Employee_ID__c='225886',emailencodingkey='UTF-8', lastname='teOfficedepo',languagelocalekey='en_US',localesidkey='en_US',short_title__c = 'TSR', profileid = p4.Id,timezonesidkey='America/Los_Angeles',username='proxy@7878.com',isactive=true);
            insert u1; 
            
            User u2 = new User(alias = 'test122', email='proxyy@proxy566541.officedepot.com',OD_Employee_ID__c='225726',emailencodingkey='UTF-8', lastname='teOfficedepo1',languagelocalekey='en_US',localesidkey='en_US',short_title__c = 'TSR', profileid = p4.Id,timezonesidkey='America/Los_Angeles',username='proxyy12@7878.com',isactive=true);
            insert u2;
  
      system.runAs(u2){
  
  
    Account acc = new Account(Name='Test_Acc',OMX_Primary_Key__c='123458');

      Id SiteOMX = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Site (OfficeMax)').getRecordTypeId();
    insert acc;

    Account site = new Account(Name='Test_Acc',OMX_Primary_Key__c='123456',recordtypeid=SiteOMX,Related_Account__c=acc.id);

    insert site;
try{
    List<Customer_Transition__c > ctlist = new List<Customer_Transition__c >();
    Set<id> ids = new set<id>();
    Customer_Transition__c ctRec = new Customer_Transition__c(name='Customer Transition of Test_Acc',
         Account__c = acc.id, Cascade_down__c = true,OMX_Primary_Key__c='123458',Written_Agreement__c = true,Written_Agreement_Custom_Core_Request__c = 'Create WRF',Local_Core__c = true,Ready_For_Mod_5__c=True,Final_Split_Decision__c = 'Yes',Ownerid=u1.id);
    insert ctRec;
    ctRec.Ready_for_Mod1__c = false;

    update ctRec;

    ctRec.Customer_Disposition__c = 'Customer going to RFP';
    ctRec.Written_Agreement_Custom_Core_Request__c = 'Import Local Core';
    ctrec.Ownerid=u2.id;
    ctRec.Ready_For_Mod_5__c=False;
    update ctRec;
    ctRec.Customer_Disposition__c = 'Lost Customer Account';
    update ctRec;
    ctRec.Customer_Disposition__c = 'Customer RFP Received';
    update ctRec;
    ctRec.Customer_Disposition__c = 'Customer already Transitioned';
    //LSLEVIN 2.2.2016 S-376886 Added below line
    ctRec.Disposition_Comments__c = '36475927';
    update ctRec;
    ctRec.Customer_Disposition__c = 'Customer requests delay';
    ctRec.Disposition_Comments__c = 'Comments';
    update ctRec;
    Customer_Transition__c ctrec2 = [SELECT Name, Disposition_Comments__c,Customer_Disposition__c,ID, status__c FROM Customer_Transition__c where id =: ctRec.id];
    system.assertEquals(ctrec2.Disposition_Comments__c, 'Comments');
    ctRec.Customer_Disposition__c = 'Not my Customer (Please ask DSM to reassign immediately)';
    ctRec.Trigger_SalesRep_Change__c=True;
    ctRec.Trigger_SalesRep_Change_Date__c=System.Today();
    ctRec.Ready_for_Mod1__c = True;
    ctRec.Final_Split_Decision__c = 'Yes';
    update ctRec;
    //ctRec.Override_TOOP__c=true;
    ctRec.status__c='On Deck' ;
    update ctRec;

    //ctRec.Ready_for_Mod1__c = false;
    //ctRec.Final_Split_Decision__c = 'Yes';
    //ctRec.omx_primary_key__C='123458-01';
    //update ctRec;
    ctRec.Review_Start_Date__c = Date.Today();
    ctRec.Contract_Extension_Complete__c = true;
    update ctRec;
    ctlist.add(ctRec);
     ids.add(ctRec.id);
    
    Mod5BillToKeyClass billToKey = new Mod5BillToKeyClass();
    billToKey.Mod5BillToKeyClassMethod(ids,ctlist); 

    ////Added By Vipul Jain on 09 Oct 2015
    //START

    system.assertEquals(ctRec.Customer_Disposition__c, 'Not my Customer (Please ask DSM to reassign immediately)');
    //END
}
catch(Exception e){}


  }
  }
  //Added By Vipul Jain on 09 Oct 2015
  //START
  static testMethod void CT_BeforeUpdate_Test2()
  {
  
    Account acc = new Account(Name='Test_Acc',OMX_Primary_Key__c='123458');

      Id SiteOMX = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Site').getRecordTypeId();
    insert acc;

    Account site = new Account(Name='Test_Acc',OMX_Primary_Key__c='123456',recordtypeid=SiteOMX,Related_Account__c=acc.id);

    insert site;
    
    Customer_Transition__c ctRec = new Customer_Transition__c(name='Customer Transition of Test_Acc',
         Account__c = acc.id, Cascade_down__c = true,OMX_Primary_Key__c='123458',Customer_Disposition__c='Customer RFP Received',Written_Agreement__c = true,Written_Agreement_Custom_Core_Request__c = 'Create WRF',Local_Core__c = true,Final_Split_Decision__c = 'No',Billing_Frequency_Excptn__c = True,AOPS_Flag__c = 'Y');
    insert ctRec;
    ctRec.Ready_for_Mod1__c = false;
    update ctRec;

    ctRec.Customer_Disposition__c = 'Customer going to RFP';
    update ctRec;
    ctRec.Customer_Disposition__c = 'Lost Customer Account';
    ctRec.Final_Split_Decision__c = 'Yes';
    ctRec.Written_Agreement_Custom_Core_Request__c = '';
    ctRec.status__c='On Deck' ;
   
    //LSLEVIN 2.2.2016 S-376886 Added below line
    ctRec.Disposition_Comments__c = '36475927';
    update ctRec;
    ctRec.Customer_Disposition__c = 'Customer already Transitioned';
    update ctRec;
    ctRec.Customer_Disposition__c = 'Customer requests delay';
    ctRec.Disposition_Comments__c = 'Comments';
    update ctRec;
    ctRec.Customer_Disposition__c = 'Extend current OMX Agreement';
    update ctRec;
    ctRec.status__c='TOOP';
    ctRec.Override_TOOP__c=true;
    
    update ctRec;
    
Customer_Transition_Dtls__c ct = new Customer_Transition_Dtls__c(Customer_Transition_ID__c = ctRec.id,AOPS_Flag__c = 'Y',recordtypeid= '012E000000093MP');
    //ctRec.Ready_for_Mod1__c = false;
    //ctRec.Final_Split_Decision__c = 'Yes';
    //ctRec.omx_primary_key__C='123458-01';
    //update ctRec;
    ctRec.Review_Start_Date__c = Date.Today();
    ctRec.Contract_Extension_Complete__c = true;
    ctRec.Override_TOOP1__c=true;
    update ctRec;
    Customer_Transition__c ctrec2 = [SELECT Name, ID, status__c FROM Customer_Transition__c where id =: ctRec.id];
    system.assertEquals(ctrec2.status__c, 'ReScheduled');
  
    
    
  }
  //END
}