@isTest
private class CT_UpdatingODSWA_TC 
{

    static testMethod void myUnitTest() 
    {
    Account acc1= new Account();
    acc1.name = 'xyz';
    acc1.OMX_Primary_Key__c='14567';
    insert acc1;
    
    
    Set<Id> CTSet = new Set<Id>() ;
    Account acc= new Account();
    acc.name='test';
    acc.OMX_Primary_Key__c = '14568';
    acc.Parent = acc1;
    insert acc;
    
    Customer_Transition__c CusTrans = new Customer_Transition__c();    
    CusTrans.name='test';
    CusTrans.Status__c='On Deck';
    CusTrans.Billing_Frequency_Excptn__c=true;
    CusTrans.AOPS_Flag__c='Y';
    CusTrans.OMX_Primary_Key__c='12340';
    CusTrans.Transition_Status__c='Active';
    CusTrans.ODS_WA_EXECUTED__c=false;
    CusTrans.Account__c=acc.id;
    //insert CusTrans;
    //CTSet.add(CusTrans.id);
    List<Customer_Transition__c> ct1=new List<Customer_Transition__c>(); // Added by Jasvinder for Story S-437501
   ct1.add(CusTrans);   // Added by Jasvinder for Story S-437501
    Customer_Transition__c CusTrans0 = new Customer_Transition__c();    
    CusTrans0.name='test';
    CusTrans0.Status__c='On Deck';
    CusTrans0.Billing_Frequency_Excptn__c=true;
    CusTrans0.AOPS_Flag__c='Y';
    CusTrans0.OMX_Primary_Key__c='14568';
    CusTrans0.Transition_Status__c='Active';
    CusTrans0.Written_Agreement__c =true;
    CusTrans0.ODS_WA_EXECUTED__c=false;
    CusTrans0.Written_Agreement_ID__c=CusTrans.id;
    CusTrans0.Account__c=acc.id;
    CusTrans0.AOPS_Flag__c='Y';
    CusTrans0.Transition_status__c='Active';
    CusTrans0.Retrigger_Mod_5__c=false;
     ct1.add(CusTrans0);  // Added by Jasvinder for Story S-437501
     insert ct1;           // Added by Jasvinder for Story S-437501
     //insert CusTrans;
    CTSet.add(ct1[0].id);    // Added by Jasvinder for Story S-437501
   // insert CusTrans0;
    CTSet.add(ct1[1].id);        // Added by Jasvinder for Story S-437501
    
   Split_Account_Detail__c  Sad = new Split_Account_Detail__c();
   sad.Customer_Transition__c = CusTrans0.id;
   sad.Original_Account__c=acc.id;
  // sad.Customer_Transition__r.AOPS_Flag__c=CusTrans0.AOPS_Flag__c;
   sad.Linked_Customer_Transition__c=CusTrans0.id;
  //sad.Customer_Transition__r.Transition_status__c=CusTrans0.Transition_status__c;
   sad.Status__c='Active';
   sad.Master_Account__c='abc';
 // sad.Original_Account__r.parent.omx_primary_key__c=acc1.OMX_Primary_Key__c;
   insert sad;
   
   Split_Account_Detail__c  Sad1 = new Split_Account_Detail__c();
   sad1.Customer_Transition__c = CusTrans0.id;
   sad1.Original_Account__c=acc.id;
  // sad.Customer_Transition__r.AOPS_Flag__c=CusTrans0.AOPS_Flag__c;
   sad1.Linked_Customer_Transition__c=CusTrans0.id;
  //sad.Customer_Transition__r.Transition_status__c=CusTrans0.Transition_status__c;
   sad1.Status__c='Error';
   sad1.Master_Account__c='abc';
 // sad.Original_Account__r.parent.omx_primary_key__c=acc1.OMX_Primary_Key__c;
   insert sad1;
   
    
    CusTrans0.Retrigger_Mod_5__c=true;
    CusTrans0.Split_Launching_Status__c='Submitted';
    CusTrans0.ODS_WA_EXECUTED__c=True;
    CTSet.add(CusTrans0.id);
    try{
    update CusTrans0;
       }
   catch(Exception e ){}
  
   
   
    
    CT_UpdatingODSWA CTUpdate = new CT_UpdatingODSWA();
    CTUpdate.updatingODSWA(CTSet);
    
  }  
    
 }