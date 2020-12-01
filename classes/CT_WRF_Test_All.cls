@isTest
private class CT_WRF_Test_All{
  static testMethod void Test_Info(){
      Date d = Date.today();
    List<Account> accounts = new List<Account>();
    List<Customer_Transition__c> ctS = new List<Customer_Transition__c>();
    List<Customer_Transition__c> updatdCTS = new List<Customer_Transition__c>();
    List<Customer_Transition__c> updatdCTSparents = new List<Customer_Transition__c>();
    
    Account gPa = new Account(Name='GrandParent_27');
    Account Pa = new Account(Name='Parent_27');
    Account Ca = new Account(Name='Child_27');
    Account CaX = new Account(Name='Child_27_Exc');
    Account aC = new Account(Name='Child_27_Alone');
    Account aP = new Account(Name='Parent_27_Alone');
    Account gPaw = new Account(Name='GrandParent_27_w');
    Account Paw = new Account(Name='Parent_27_w');
    Account Caw = new Account(Name='Child_27_w');
    Account Cawa = new Account(Name='Child_27_w_alone');
     Account Cawb = new Account(Name='Child_28_w_alone');
    
    accounts.add(gPa);
    accounts.add(Pa);
    accounts.add(Ca);
    accounts.add(CaX);
    accounts.add(aC);
    accounts.add(aP); 
    
    accounts.add(gPaw);
    accounts.add(Paw);
    accounts.add(Caw);
    accounts.add(Cawa);
    accounts.add(Cawb);
    
    insert accounts;
      
      
      test.startTest();
      Customer_Transition__c cTgp = new Customer_Transition__c(name='Customer Transition of GrandParent CT_Test_27', 
         Account__c = gPa.id, Cascade_down__c = true );
      ctS.add(cTgp);
      Customer_Transition__c cT = new Customer_Transition__c(name='Customer Transition of Parent CT_Test_27', 
         Account__c = Pa.id, Cascade_down__c = true, Written_Agreement__c = true );
        ctS.add(cT);
      
      Customer_Transition__c wgPa = new Customer_Transition__c(Name='GrandParent_27_Wa', Account__c = gPaw.id, Written_Agreement__c = true);
      ctS.add(wgPa);
    Customer_Transition__c wPa = new Customer_Transition__c(Name='Parent_27_Wa', Account__c = Paw.id, Written_agreement__c = true);
      ctS.add(wPa);
    Customer_Transition__c wCa = new Customer_Transition__c(Name='Child_27_Wa', Account__c = Caw.id, Written_agreement__c = true);
      ctS.add(wCa);
     Customer_Transition__c waC = new Customer_Transition__c(Name='Child_27_Alone_Wa', Account__c = Cawa.id, Written_agreement__c = true);
      ctS.add(waC);   
      
      Customer_Transition__c waCb = new Customer_Transition__c(Name='Child_28_Alone_Wa', Account__c = Cawb.id, Written_agreement__c = false);
      ctS.add(waCb);
    test.stoptest();   

  Customer_Transition__c cTc = new Customer_Transition__c(name='Customer Transition of Child_CT_Test_27', 
         Account__c = Ca.id);
  
  Customer_Transition__c cTch = new Customer_Transition__c(name='Customer Transition of Child CT_Test_27_Alone', 
         Account__c = aC.id );
      
  Customer_Transition__c cTPa = new Customer_Transition__c(name='Customer Transition of Parent CT_Test_27_Alone', 
         Account__c = aP.id );
      
      ctS.add(cTch);
      ctS.add(cTPa);
      ctS.add(cTc);
      
  Customer_Transition__c cTx = new Customer_Transition__c(name='Customer Transition of Child_CT_Test_27_Exc', 
         Account__c = CaX.id, Parent_Transition_ID__C = ctPa.ID);      
     
      ctS.add(cTx);
      insert ctS;
      
      cT.Parent_Transition_ID__C = cTgp.ID;
      wPa.Parent_Transition_ID__c = cTgp.id;
      wPa.Written_Agreement_Id__c = wgPa.id;
      wCa.Parent_Transition_ID__c = cT.id;
      wCa.Written_Agreement_Id__c = wgPa.id;
      waC.Written_Agreement_Id__c = wgPa.id;
      cTc.Parent_Transition_ID__C = ct.ID;
      
      waCb.Written_Agreement_Id__c = wgPa.id;
      
      updatdCTSparents.add(cT);
      updatdCTSparents.add(wPa);
      updatdCTSparents.add(wCa);
      updatdCTSparents.add(waC);
      updatdCTSparents.add(cTc);
      
      update updatdCTSparents;
  
     //ct.Review_Start_Date__c = d.addDays(67);
      ctx.Review_Start_Date__c = d.addDays(12); // Move the Date to activate the Workflow rule to move this CT into "On Deck" status
    updatdCTS.add(cTx);
      waC.Review_Start_Date__c = d.addDays(12);  
    updatdCTS.add(waC);
      ctch.Review_Start_Date__c = d.addDays(11); // Move the Date to activate the Workflow rule to move this CT into "On Deck" status
    updatdCTS.add(cTch);
      //cT.Agreement_Development__c = True;
      

    
      cT.status__c='On Deck';
      cT.Ready_for_Mod1__c = true;
      cT.Manual_Build_Underway__c = True;
    updatdCTS.add(cT);
    //waCb.Agreement_Development__c = True; 
        
         Case WRCase1 = new Case();
         //WRCase1.recordTypeId = CRMapByName get('Work Request').getRecordTypeId();
         WRCase1.DUP_Acct_ID__c = '78906';
         WRCase1.DUP_Requestor_ID__c = '123456';
        //insert WRCase1;
         
    
    waCb.Related_WRF_Case__c =WRCase1.Id;
    updatdCTS.add(waCb);
    update updatdCTS;

    ctch.Customer_Transition_Date_to_OD_Systems__c = d.addDays(11); 
    ctch.Customer_Loss__c=true;
    update cTch;
     /* commented by najma ateeq 
    ctch.Customer_Transition_Date_to_OD_Systems__c = d.addDays(11); 
    ctch.Customer_Loss__c=false;
    ctch.Administrative_Close__c=true;
    update cTch;*/
  } 
}