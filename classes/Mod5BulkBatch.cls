Global class Mod5BulkBatch implements database.Batchable<Sobject>,Database.Stateful,Schedulable
{
    
    global String strQuery; //this variable used to set query from test class or from shceduler if required
    // Below is set a default query in case not set in test class or in scheduler
    private String DEFAULT_QUERY ='Select Id,Customer_Transition__r.omx_primary_key__C,SHIP_TO_CONSIGNEE__c,Billing_Account__c, NEW_BILL_TO_OMX_CONSIGNEE__c,Master_Account__c,Original_Account__r.ownerId,Original_Account__c,NEW_MAIN_ACCT_ADDRESS__c,Customer_Transition__r.Mod4FlowStatus__c,BatchProcessed__c,New_Header_Billing_Account_Code__c FROM Split_Account_Detail__c where  Customer_Transition__r.Mod4FlowStatus__c= \'SplitSubmitted\' and BatchProcessed__c=false order by Original_Account__c asc ,Master_Account__c desc limit 100';
                                                    
    
    /* Default Constructor*/
    global Mod5BulkBatch ()
    {        
        this.strQuery = DEFAULT_QUERY;
    }
    /*This costructor is called from the Batch Schedule method*/
    global Mod5BulkBatch (String query)
    {
        System.debug('QUERY IS---->'+query);
        if(query != null && query != '')
        {    
            this.strQuery = query;
        }   
        else
        {
            this.strQuery = DEFAULT_QUERY;
        }     
    system.debug('strQuery@@@'+strQuery);       
    }
    /* This method prepares the scope of the batch program based on the query result */
    global Database.QueryLocator start(Database.BatchableContext BC)
    {
        system.debug('strQuery@@@'+strQuery);
        return Database.getQueryLocator(strQuery);
    }
     /* This method processes query result in batches */
    global void execute(Database.BatchableContext BC, SObject[] scope)
    {
    
    // Bypass Logics
    executeoncetest.mod5ByPass=false;
    
         List<Split_Account_Detail__c > splitrecs = scope;             
         Set<String>  setnewacc = new Set<String> ();
         Set<String>  setnewaccList = new Set<String> ();
         set<Id> accHdrOwner = new set<id>();
         Set<String> MasterAccounts = new  Set<String>();
         map<id,string> mapusrTitle = new map<id,string>();
         Set<String> setNewMainAccAdd = new Set<String>();
         Map<String, Account> mapAccAdd = new Map<String, Account>();
         List<Account> accinsertlist = new List<Account>();
         Set<Id> billUpList= new    Set<Id>();
         Set<String> OriginalAccSEt = new Set<String>();
         // getting all unique Master Accounts
       
       
     
          for(Split_Account_Detail__c sadRec :splitrecs){                                        
            if(!OriginalAccSEt.contains(sadRec.Customer_Transition__r.omx_primary_key__C))                           
            OriginalAccSEt.add(sadRec.Customer_Transition__r.omx_primary_key__C);         
                     
            if(!MasterAccounts.contains(sadRec.Master_Account__c)){                            
            MasterAccounts.add(sadRec.Master_Account__c);
               System.debug('&&&&&Entered here'+sadRec.Master_Account__c);       
            
            if(sadRec.Customer_Transition__r.omx_primary_key__C  != sadRec.Master_Account__c){                                                                                                                                              
                        if(!setnewacc.contains(sadRec.Master_Account__c)){                            
                          setnewacc.add(sadRec.Master_Account__c);
                          //get Address keys 
                          
                               System.debug('&&&&&Entered here1'+sadRec.Master_Account__c);  
                          if(sadRec.NEW_MAIN_ACCT_ADDRESS__c!=null){
                          setNewMainAccAdd.add(sadRec.NEW_MAIN_ACCT_ADDRESS__c);
                          }
                          
                           
                          if(!accHdrOwner.contains(sadRec.Original_Account__r.ownerId))
                          accHdrOwner.add(sadRec.Original_Account__r.ownerId);                                                    
                        }
                } 
                        
               /* if(sadrec.NEW_BILL_TO_OMX_CONSIGNEE__c ==sadrec.SHIP_TO_CONSIGNEE__c){          
                  if(!billUpList.contains(sadrec.Billing_Account__c))
                  billUpList.add(sadrec.Billing_Account__c);          
                } */                   
          }
        }
      
       
      
      /* if(billUpList.size()>0){
        List<Account >AccBillList= new List<Account >();
        for (Id i : billUpList) {

          Account accnew= new Account(Id=i,Primary_BillTo__C=true);
          AccBillList.add(accnew);
        }
        update AccBillList; 
       }
      */
      //getting owner Details 
      for(User usrTitle : [Select ID,Short_Title__c from User where Id=:accHdrOwner]){
        mapusrTitle.put(usrTitle.id,usrTitle.Short_Title__c);
      }
      
        List<Split_Account_Detail__c > sadtls  = [Select Id, Customer_Transition__r.omx_primary_key__c,Main_Account_Name__c, Status__c,
                                                  Error_Message__c,Master_Account__c, Customer_Transition__r.Mod4FlowStatus__c,BatchProcessed__c,                                                  
                                                  Original_Account__c, Original_Account__r.ownerId,Original_Account__r.Address1__c,
                                                  Original_Account__r.Address2__c,                                                      
                                                  Original_Account__r.city__C,Original_Account__r.zip__C,
                                                  Original_Account__r.state__c,Original_Account__r.country__C, 
                                                  Original_Account__r.parentId,Original_Account__r.status__c, 
                                                  Original_Account__r.Sales_PersonID__c,Customer_Transition_Detail_Id__c, 
                                                  SALES_REP_ID__c, Ship_To_Account__c, SHIP_TO_NAME__c, Billing_Account__c, Customer_Transition__c,  
                                                  OMX_ACCOUNT__c, OMX_ACCT_NAME__c, SHIP_TO_CONSIGNEE__c, SHIPTO_ADDRESS_1__c, SHIPTO_ADDRESS_2__c,  
                                                  SHIP_TO_CITY__c, SHIP_TO_STATE__c, SHIP_TO_ZIP__c, BILL_TO_CONSIGNEE__c, BILL_TO_NAME__c,    
                                                  BILL_TO_ADDRESS_1__c, BILL_TO_ADDRESS_2__c, BILL_TO_CITY__c, BILL_TO_STATE__c, BILL_TO_ZIP__c,
                                                  NEW_BILL_TO_OMX_CONSIGNEE__c, NEW_BILLING_TYPE_AT_HEADER_LEVEL__c,
                                                  Ship_To_Account__r.Sales_PersonID__c, Ship_To_Account__r.owneriD   , NEW_MAIN_ACCT_ADDRESS__c ,                                                  
                                                  AP_CONTACT_FIRST_NAME__c,AP_CONTACT_LAST_NAME__c,AP_CONTACT_TELEPHONE__c,
                                                  Linked_Customer_Transition__c,
                                                  Linked_Customer_Transition__r.account__C,Customer_Transition__r.account__C,
                                                  New_Header_Billing_Account__r.Related_Account__c,
                                                  New_Header_Billing_Account__r.Name,New_Header_Billing_Account__r.address1__c,
                                                  New_Header_Billing_Account__r.address2__c,New_Header_Billing_Account__r.city__c,
                                                  New_Header_Billing_Account__r.state__c,New_Header_Billing_Account__r.recordtypeId,
                                                  New_Header_Billing_Account__r.ownerId,
                                                  New_Header_Billing_Account__r.Sales_PersonID__c,count__C,
                                                  New_Header_Billing_Account_Code__c,
                                                  // Start - Story #00888275
                                                  Original_Account__r.Duns_Number__c, 
                                                  Original_Account__r.Segment__c, 
                                                  Original_Account__r.Sic,
                                                  Original_Account__r.Ultimate_Duns_Number__c, 
                                                  Customer_Transition__r.AR_Flag__c,
                                                  Customer_Transition__r.Back_Order_Cancel_or_Allow__c,
                                                  Customer_Transition__r.Billing_Document_Type__c,
                                                  Customer_Transition__r.Billing_Frequency__c,
                                                  Customer_Transition__r.Billing_Type_Flag__c,
                                                  Customer_Transition__r.Copies_in_Packing_list__c,
                                                  Customer_Transition__r.Cost_Center_Required__c,
                                                  Customer_Transition__r.Drop_Ship_Flag__c,
                                                  Customer_Transition__r.Fax_back_phone_number__c,
                                                  Customer_Transition__r.Freight_Charge_Flag__c,
                                                  Customer_Transition__r.Invoice_Email1__c,
                                                  Customer_Transition__r.MIPAL_alternate_location_flag__c,
                                                  Customer_Transition__r.Mixture_of_exempt_non_exempt__c,
                                                  Customer_Transition__r.PO_Number_Required__c,
                                                  Customer_Transition__r.Pricing_on_packing_list__c,
                                                  Customer_Transition__r.Promo_Catalog__c,
                                                  Customer_Transition__r.Promo_Email__c,
                                                  Customer_Transition__r.Promo_Flyer__c,
                                                  Customer_Transition__r.Promo_Phone__c,
                                                  Customer_Transition__r.Release_Number_Required__c,
                                                  Customer_Transition__r.Retail_Connect__c,
                                                  Customer_Transition__r.Service_Charge_Code__c,
                                                  Customer_Transition__r.Tax_Exemption__c
                                                  // End - Story #00888275                                                                                                                                            
                                                  FROM Split_Account_Detail__c 
                                                  WHERE  Customer_Transition__r.Mod4FlowStatus__c = 'SplitSubmitted' 
                                                  AND BatchProcessed__c=false 
                                                  AND Master_Account__c in  :MasterAccounts];       
          

  // Finding the address Details for the customers
        
      if((!setNewMainAccAdd.isEmpty()) && (setNewMainAccAdd.size() > 0)){
            try{
            List<Account> accAddressList=[Select  omx_primary_key__c ,Address1__c,Address2__c,City__c,State__c,Zip__c,country__C
                               from account
                               where omx_primary_key__c in :setNewMainAccAdd];
            for(Account eachAcc : accAddressList)
            mapAccAdd.put(eachAcc.omx_primary_key__c,eachAcc);
            } catch(Exception e) {}
       } 
        
        
           for(Split_Account_Detail__c sad :sadtls){ 
           
           
                if(sad.NEW_BILL_TO_OMX_CONSIGNEE__c ==sad.SHIP_TO_CONSIGNEE__c){          
                  if(!billUpList.contains(sad.Billing_Account__c))
                  billUpList.add(sad.Billing_Account__c);          
                }                

           
                        
                    // if the current Omx Key not equal given Master Omx key create new Main accounts
                  if(sad.Customer_Transition__r.omx_primary_key__C!=sad.Master_Account__c )  {   
                    
                if(!setnewaccList.contains(sad.Master_Account__c)){                            
                           setnewaccList.add(sad.Master_Account__c);
                           
                           
                    //getting owner of Record   
                        Id accHeaderOwner=sad.Original_Account__r.ownerId;
                           Id acctOwner=null;
                           Id salesperson=null;
                           
                           if(mapusrTitle.get(accHeaderOwner)=='BDM' || mapusrTitle.get(accHeaderOwner)=='TDM'){
                           acctOwner=sad.Original_Account__r.ownerId;
                           salesperson=sad.Original_Account__r.Sales_PersonID__c;
                           }
                           else{                          
                             acctOwner=sad.Ship_To_Account__r.owneriD;
                             salesperson=sad.Ship_To_Account__r.Sales_PersonID__c;
                           }
                           
               // Getting address
                       //getting the address for Main account
                           String address1,address2,city,state,zip,country;
                           if((sad.NEW_MAIN_ACCT_ADDRESS__c!=null) && (mapAccAdd.containsKey(sad.NEW_MAIN_ACCT_ADDRESS__c))){
                           Account accAddress=new Account();
                           accAddress = mapAccAdd.get(sad.NEW_MAIN_ACCT_ADDRESS__c);
                          //// System.debug('&&&&&&&&&&&&&&&&&Acc Address'+accAddress );
                           address1=accAddress.Address1__c;
                           address2=accAddress.Address2__c;
                           city=accAddress.city__c;
                           state=accAddress.State__c;
                           zip=accAddress.zip__c;
                           country=accAddress.country__C;
                           }
                           else{
                           
                           address1=sad.Original_Account__r.Address1__c;
                           address2=sad.Original_Account__r.Address2__c;
                           city=sad.Original_Account__r.city__c;
                           state=sad.Original_Account__r.State__c;
                           zip=sad.Original_Account__r.zip__c;
                           country=sad.Original_Account__r.country__C;
                           
                           }            
                        
                        
                                        //Construct account Insert List
                       Account acc = new Account(name=sad.Main_Account_Name__c,
                                                    omx_primary_key__c = sad.Master_Account__c,
                                                    OMX_Mainframe_Account_Number__c =sad.Master_Account__c,
                                                    ownerId=acctOwner,
                                                    parentId=sad.Original_Account__r.parentId,
                                                    Sales_PersonID__c=salesperson,
                                                    status__C=sad.Original_Account__r.status__c,
                                                    OMX_Mainframe_Account_Level__c = 'Main Account',
                                                    Split_Record__c=true,address1__C=address1,
                                                    address2__C=address2,city__C=city,
                                                    country__C=country,
                                                    state__c=state,zip__C=zip,
                                                    recordtypeid= Schema.SObjectType.Account.getRecordTypeInfosByName().get('Customer (OfficeMax)').getRecordTypeId(),
                                                    // Start - Story #00888275
                                                    Segment__c = sad.Original_Account__r.Segment__c);
                                                    // End - Story #00888275);
                            accinsertlist.add(acc);       
                           
                       }
                       
                      } 

                       
          } // end of for loop             
        
      
         if(billUpList.size()>0){
        List<Account >AccBillList= new List<Account >();
        for (Id i : billUpList) {

          Account accnew= new Account(Id=i,Primary_BillTo__C=true);
          AccBillList.add(accnew);
        }
        update AccBillList; 
       }
     

      
      
      
      
         //Inserting the new Main accounts
           if(accinsertlist.size()>0){
           system.debug('>>>>>>accinsertlist>>>>>>'+accinsertlist);
           insert accinsertlist;    
           }

        
        
        
        //Variable Declarations
      Map<String,Id> custMap= new Map<String,Id>(); 
     // Map<String,Id> custMapList= new Map<String,Id>(); 
      Map<String,Id> accMapList= new Map<String,Id>(); 
      List<Account> SiteList= new  List<Account>();
      List<Customer_Transition_Dtls__c > detailList= new  List<Customer_Transition_Dtls__c >();
      Set<Id> SiteListId= new Set<Id>();
      Set<Id> detailListId= new Set<Id>();
      List<Split_Account_Detail__c >sadupdate= new List<Split_Account_Detail__c >();
      List<Customer_Transition__c > custDetUpdateList= new  List<Customer_Transition__c >();
      Set<String> processingset= new Set<String> ();
      List<Account> accListUpd= new List<Account>();
      
     //getting the transition Records of newly created accounts        
     List<Customer_transition__C > custNewList=[Select Id , omx_primary_key__C,account__r.Id,account__r.omx_primary_key__C,
                                                // Start - Story #00888275
                                                AR_Flag__c,
                                                Back_Order_Cancel_or_Allow__c,
                                                Billing_Document_Type__c,
                                                Billing_Frequency__c,
                                                Billing_Type_Flag__c,
                                                Copies_in_Packing_list__c,
                                                Cost_Center_Required__c,
                                                Drop_Ship_Flag__c,
                                                Fax_back_phone_number__c,
                                                Freight_Charge_Flag__c,
                                                Invoice_Email1__c,
                                                MIPAL_alternate_location_flag__c,
                                                Mixture_of_exempt_non_exempt__c,
                                                PO_Number_Required__c,
                                                Pricing_on_packing_list__c,
                                                Promo_Catalog__c,
                                                Promo_Email__c,
                                                Promo_Flyer__c,
                                                Promo_Phone__c,
                                                Release_Number_Required__c,
                                                Retail_Connect__c,
                                                Service_Charge_Code__c,
                                                Tax_Exemption__c
                                                // End - Story #00888275
                                                from   Customer_Transition__c
                                                where account__C in  :accinsertlist];
                                                
        Map<String, Customer_Transition__c> newOmxKeyToCT = new Map<String, Customer_Transition__c>();
     
         for (Customer_Transition__c cst : custNewList) {
             custMap.put(cst.omx_primary_key__C ,cst.Id);
           // custMapList.put(cst.omx_primary_key__C ,cst.Id);
            accMapList.put(cst.omx_primary_key__C ,cst.account__r.Id);
            
            // Start - Story #00888275
            newOmxKeyToCT.put(cst.OMX_Primary_Key__c, cst);
            // End - Story #00888275
         }
           
          
        // Looping Records to Reassign the Related Accounts for Sites of New Groups      
        Set<String> accountsProcessed = new Set<String>();
  
        for(Split_Account_Detail__c sad :sadtls){        
                    if(sad.Master_Account__c!=sad.OMX_ACCOUNT__c){                      
                    //get the account Id
                    Id relatedaccountId= accMapList.get(sad.Master_Account__c);                   
                    //Updating Related accounts of Newly grouped sites  
                    
                      if(!SiteListId.contains(sad.Ship_To_Account__c)){                      
                         Account accupdate = new Account (Id=sad.Ship_To_Account__c,Site_Primary_Contact__c = null,Site_Contact2__c = null,
                                                            Site_Contact3__c = null,Site_Contact4__c = null,Site_Contact5__c = null,
                                                            Site_Contact6__c = null,Related_Account__c=relatedaccountId,
                                                            OMX_Mainframe_Account_Number__c=sad.Master_Account__c);
                          SiteList.add(  accupdate );  
                          SiteListId.add(sad.Ship_To_Account__c);
                      }                                                    
                         
                   // updating the customer transition details                  
                        Id transId= custMap.get(sad.Master_Account__c);                                           
                        if(!detailListId.contains(sad.Customer_Transition_Detail_Id__c)){   
                         Customer_Transition_Dtls__c custDet= new Customer_Transition_Dtls__c (Id=sad.Customer_Transition_Detail_Id__c,
                         Customer_Transition_ID__c=transId);
                         detailList.add(custDet);
                         detailListId.add(sad.Customer_Transition_Detail_Id__c);
                         }
                         
                         // Start - Story #00888275
                        // Determine if record has been processed yet
                        if (!accountsProcessed.contains(sad.Master_Account__c)) {
                            // Update new Customer Transitions with values from the original CT
                            System.debug('***** sad.Master_Account__c = ' + sad.Master_Account__c);
                            Customer_Transition__c newCT = newOmxKeyToCT.get(sad.Master_Account__c);
                            
                            newCT.Back_Order_Cancel_or_Allow__c = sad.Customer_Transition__r.Back_Order_Cancel_or_Allow__c;
                            newCT.Copies_in_Packing_list__c = sad.Customer_Transition__r.Copies_in_Packing_list__c;
                            newCT.Cost_Center_Required__c = sad.Customer_Transition__r.Cost_Center_Required__c;
                            newCT.Drop_Ship_Flag__c = sad.Customer_Transition__r.Drop_Ship_Flag__c;
                            newCT.Freight_Charge_Flag__c = sad.Customer_Transition__r.Freight_Charge_Flag__c;
                            newCT.MIPAL_alternate_location_flag__c = sad.Customer_Transition__r.MIPAL_alternate_location_flag__c;
                            newCT.PO_Number_Required__c = sad.Customer_Transition__r.PO_Number_Required__c;
                            newCT.Pricing_on_packing_list__c = sad.Customer_Transition__r.Pricing_on_packing_list__c;
                            newCT.Release_Number_Required__c = sad.Customer_Transition__r.Release_Number_Required__c;
                            newCT.Service_Charge_Code__c = sad.Customer_Transition__r.Service_Charge_Code__c;
                            
                            // Defaults for billing fields
                            newCT.AR_Flag__c = 'Y';
                            newCT.Billing_Document_Type__c = 'S';
                            newCT.Billing_Frequency__c = 'W';
                            newCT.Billing_Type_Flag__c = 'P';
                  
                            accountsProcessed.add(sad.Master_Account__c);
                        }
                        // End - Story #00888275
                }                    
         
         Split_Account_Detail__c  sadupdateRec = new Split_Account_Detail__c(Id=sad.Id);  
          sadupdateRec.BatchProcessed__c=true;
          
                    
                          
         if(sad.Master_Account__c !=sad.OMX_ACCOUNT__c){
                sadupdateRec.Linked_Customer_Transition__c= custMap.get(sad.Master_Account__c); 
                  
                
                if(!processingset.contains(sad.Master_Account__c)){
                processingset.add(sad.Master_Account__c);
                
                         Account acc= new Account();
                         acc.omx_primary_key__C=sad.Master_Account__c;
                         acc.OMXIsUpdated__c=true;
                         accListUpd.add(acc);
                
                             
                Customer_transition__C custDetUpdate = new Customer_transition__C();
                custDetUpdate.Id=custMap.get(sad.Master_Account__c);
                custDetUpdate.Original_Customer_Transition__c=sad.Customer_Transition__c;  
                custDetUpdate.AR_Primary_Contact_First_Name__c=sad.AP_CONTACT_FIRST_NAME__c;
                custDetUpdate.AR_Primary_Contact_Last_Name__c=sad.AP_CONTACT_LAST_NAME__c;
                custDetUpdate.AR_Phone__c=sad.AP_CONTACT_TELEPHONE__c;                                                                   
                custDetUpdate.Ship_2_Bill_2_Code__c = 'N'; 
                custDetUpdate.AOPS_Flag__c='Y';
                custDetUpdate.Final_split_Decision__c ='No';
                custDetUpdate.Transition_Status__c ='Active';
                custDetUpdate.status__C='On Deck';
                custDetUpdate.Billing_Type__c=sad.NEW_BILLING_TYPE_AT_HEADER_LEVEL__c ;
                // Start - Story #00888275
                                                                            
                // Commenting out default value assignment
                //custDetUpdate.AR_Flag__c = 'Y';
                //custDetUpdate.Billing_Document_Type__c = 'S';
                //custDetUpdate.Billing_Frequency__c = 'W'; 
                //custDetUpdate.Billing_Type_Flag__c = 'P';
                
                // End - Story #00888275
                custDetUpdateList.add(custDetUpdate); 
                }                        
             }
              sadupdate.add( sadupdateRec);
        }       
                       
     system.debug('>>>>>SiteList>>>>>>'+SiteList);
     if(SiteList.size()>0)
     update  SiteList; 
     
     system.debug('>>>>>detailList>>>>>>'+detailList);
     if(detailList.size()>0)
     update  detailList;   
       
    // Start - Story #00888275
    if (newOmxKeyToCT.size() > 0) {
        update newOmxKeyToCT.values();
    }
    // End - Story #00888275
        

       if(custDetUpdateList.size()>0)
       update  custDetUpdateList;
        
      //Processing Bill to
              
  
                   //get the split details Records
           
           
           List<Split_Account_Detail__c>    splitDetail=[Select Linked_Customer_Transition__c,Master_Account__c,OMX_ACCOUNT__c,
            Linked_Customer_Transition__r.account__C,Customer_Transition__r.account__C,
            Customer_Transition__c,New_Header_Billing_Account__r.Related_Account__c,
            NEW_BILL_TO_OMX_CONSIGNEE__c,Original_Account__c,
            New_Header_Billing_Account__r.Name,New_Header_Billing_Account__r.address1__c,
            New_Header_Billing_Account__r.address2__c,New_Header_Billing_Account__r.city__c,
            New_Header_Billing_Account__r.state__c,New_Header_Billing_Account__r.recordtypeId,
            New_Header_Billing_Account__r.ownerId,
            New_Header_Billing_Account__r.Sales_PersonID__c,count__C,New_Header_Billing_Account_Code__c
            FROM Split_Account_Detail__c where  Customer_Transition__r.Mod4FlowStatus__c= 'SplitSubmitted' and
            BatchProcessed__c=false and 
            Master_Account__c in  :MasterAccounts]; 
            
          //List<Split_Account_Detail__c>    splitDetail=  sadtls   ;    
 
         List<Account> accList= new  List<Account>();
         List<Customer_Transition_Dtls__c > DetailListProc = new List<Customer_Transition_Dtls__c > ();
         Map<String,Id> MapDetail  = new  Map<String,Id>  ();
         Map<String,String> BilltoListMap  = new  Map<String,String>  ();
         Map<String,String> OMXKeyMap= new  Map<String,String>  ();
    
         
         
                     // update The Launched Transition
            for(integer i=0;i<splitDetail.size();i++){              
               if(!accMapList.keyset().contains( splitDetail[i].OMX_ACCOUNT__c))
               accMapList.put(  splitDetail[i].OMX_ACCOUNT__c,splitDetail[i].Original_Account__c ); 
               
               if(!custMap.keyset().contains( splitDetail[i].OMX_ACCOUNT__c))
               custMap.put(  splitDetail[i].OMX_ACCOUNT__c,splitDetail[i].Customer_Transition__c ); 
               
              
               if(!OMXKeyMap.keyset().contains( splitDetail[i].Master_Account__c)){
               OMXKeyMap.put(  splitDetail[i].Master_Account__c,splitDetail[i].Master_Account__c ); 
                                          system.debug('@@@@related' + splitDetail[i].New_Header_Billing_Account__r.Related_Account__c);
                        system.debug('@@@@@master' + accMapList.get(splitDetail[i].Master_Account__c));
                        // Logic to Create New Build to accounts
                      if(splitDetail[i].New_Header_Billing_Account__r.Related_Account__c!=null  &&
                      ( splitDetail[i].New_Header_Billing_Account__r.Related_Account__c!=accMapList.get(splitDetail[i].Master_Account__c)
                      ))
                      {
                                                                
                      if(!BilltoListMap.keyset().contains(splitDetail[i].NEW_BILL_TO_OMX_CONSIGNEE__c)){
                      BilltoListMap.put(splitDetail[i].NEW_BILL_TO_OMX_CONSIGNEE__c,splitDetail[i].NEW_BILL_TO_OMX_CONSIGNEE__c);
                      }
                      
                      String countSeq= String.valueof(splitDetail[i].count__c);                                        
                      String OMXKey=splitDetail[i].NEW_BILL_TO_OMX_CONSIGNEE__c+'-OMX-A'+countSeq;
                
                  
                          Account acc=new Account (                       
                            name=splitDetail[i]. New_Header_Billing_Account__r.Name,
                            Related_Account__c=accMapList.get(splitDetail[i].Master_Account__c),
                            omx_primary_key__C=OMXKey,
                            OMX_Mainframe_Account_Number__c=splitDetail[i].Master_Account__c,
                            OMX_Mainframe_Consignee_ID__c=OMXKey,
                            address1__c=splitDetail[i].New_Header_Billing_Account__r.address1__c,
                            address2__c=splitDetail[i].New_Header_Billing_Account__r.address2__c,
                            city__C=splitDetail[i].New_Header_Billing_Account__r.city__c,
                            ownerId=splitDetail[i].New_Header_Billing_Account__r.ownerId,
                            Sales_PersonID__c=splitDetail[i].New_Header_Billing_Account__r.Sales_PersonID__c,                        
                            state__c=splitDetail[i].New_Header_Billing_Account__r.state__c,Split_Record__c=true,
                            recordtypeId=splitDetail[i].New_Header_Billing_Account__r.recordtypeId, Primary_BillTo__C=true,OMXIsUpdated__c=true);                           
                            accList.add(acc); 
                            
                             Id Site = Schema.SObjectType.Customer_Transition_Dtls__c.getRecordTypeInfosByName().get('Sites').getRecordTypeId();
                            
                            //Creating the records for Tranistion details for New Billing Account
                            Customer_Transition_Dtls__c custNew= new Customer_Transition_Dtls__c (
                            omx_primary_key__C=OMXKey,
                            recordtypeId=Site ,
                            Reference_Account__c=accMapList.get(splitDetail[i].Master_Account__c),
                            aops_flag__c='Y',
                            //Ship_2_Bill_2_Code__c ='B',
                            Ship_2_Bill_2_Code__c =splitDetail[i].New_Header_Billing_Account_Code__C,

                            Status__c='Active',
                            Customer_Transition_ID__c=custMap.get(splitDetail[i].Master_Account__c));  
                            DetailListProc .add( custNew);   
                            
                           
                      }
                   
                  } 
            }
            
            
            
       // Insering the new billing accounts and create Transition Detail Records for them
       if(accList.size()>0){
       executeoncetest.isMod5Launch = true;
       insert accList; 
       System.debug('&&&&&&&&&&&&&&&  accList'+accList);       
       for(integer i=0;i<accList.size();i++){
       MapDetail.put(accList[i].omx_primary_key__C,accList[i].Id);
       } 
       for(integer k=0;k<DetailListProc .size();k++){
       DetailListProc [k].Account_ID__c=  MapDetail.get(DetailListProc [k].omx_primary_key__C);
       } 
       insert  DetailListProc ;   
       }
       
       
       // Marking the Processed Records as completed
       if(sadupdate.size()>0)
       update sadupdate;
        
       
             
       Map<String,Id>MasterMap = new Map<String,Id>();
       List<Customer_Transition__c> splitrecsupdate= new List<Customer_Transition__c>();
     
     
      List<Customer_Transition__c> splitFinal= [select omx_primary_key__C,Id from Customer_Transition__c     
      where Id in (select Customer_Transition__c 
      FROM Split_Account_Detail__c where  Customer_Transition__r.Mod4FlowStatus__c= 'SplitSubmitted' and BatchProcessed__c=false and 
      OMX_ACCOUNT__c in  :OriginalAccSEt)];       
        
     System.debug('&&&&&&&&&  OriginalAccSEt'+OriginalAccSEt); 
        for(Customer_Transition__c  splt:splitFinal){
                         if(!MasterMap.keyset().contains( splt.omx_primary_key__C))
                         MasterMap.put(splt.omx_primary_key__C,splt.Id);
        
        }
        
          for( String omxkey :OriginalAccSEt){
                     if(!MasterMap.keyset().contains( omxkey)){
                     
                         Customer_Transition__c custupdate = new Customer_Transition__c();
                         custupdate.omx_primary_key__C=omxkey;
                         custupdate.Mod4FlowStatus__c='Splitted';
                         custUpdate.Mod5TriggerContact__C=true;
                         splitrecsupdate.add(custupdate);
                         
                    
                     }
          }
        
              if(splitrecsupdate .size()>0)
              upsert splitrecsupdate omx_primary_key__C ;
        
              Id SiteOMX = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Site (OfficeMax)').getRecordTypeId();

        List<Account> accListSite= [select omx_primary_key__c, id, omxisupdated__C from account
        where recordtypeId=:SiteOMX  and OMX_Primary_Key__c like '%OMX00%' and Related_Account__r.omx_primary_key__C
        in :setnewacc];
        
        for(Account acc: accListSite){        
          account accnew = new Account(Id=acc.Id);
          accNew.omxisupdated__C =true;
          accNew.omx_primary_key__C=acc.omx_primary_key__c;
          accListUpd.add(accNew);
        }
        
              if(accListUpd.size()>0)
               upsert accListUpd omx_primary_key__C ;
               
     
        
      }  
        
   
   
      /* This method is to execute to relase some resources if any*/
    global void finish(Database.BatchableContext BC)
    {
                    CustTransParentChildLevel__c PCLevel2 = [select Mod5beforeBatchId__C,Mod5beforeBatchInterval__c from 
            CustTransParentChildLevel__c limit 1];
        integer interval = 100;        
        if (PCLevel2.Mod5beforeBatchId__C<> null) {
            for (CronTrigger existingJob: [SELECT Id FROM CronTrigger where ID=:PCLevel2.Mod5beforeBatchId__C])
            system.abortJob(existingJob.id);
        }
        
        if(PCLevel2.Mod5beforeBatchInterval__c!= null)
            interval = (Integer)PCLevel2.Mod5beforeBatchInterval__c;
        
        DateTime sysTime = System.now().addSeconds(interval);
        String chronExpression = '' + sysTime.second() + ' ' + sysTime.minute() + ' ' + sysTime.hour() + ' ' + sysTime.day() + ' ' + sysTime.month() + ' ? ' + sysTime.year();
        
        Mod5BulkBatch  Mod5LaunchBatchObj = new Mod5BulkBatch  ();
        ID cronid = System.schedule( 'Mod5BulkBatch' + sysTime, chronExpression, Mod5LaunchBatchObj );    
        
        PCLevel2.Mod5beforeBatchId__C= cronid;
        
        update PCLevel2;    


    }     
        
    global void execute(SchedulableContext sc)
    {
        String strQuery = '';
        Mod5BulkBatch  Mod5LaunchBatchObj = new Mod5BulkBatch  (strQuery);
        database.executebatch(Mod5LaunchBatchObj, 100);
    } 
          
}