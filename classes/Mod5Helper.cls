public class Mod5Helper{
    
//Declare variables
public static List<AccountStructure_CT.WrapErrors> allErrors = new List<AccountStructure_CT.WrapErrors>();
//public static AccountStructure_CT as_CT = new AccountStructure_CT();
public static String error;
public static Map<id,Customer_Transition__c> mapCTrec = new Map<id,Customer_Transition__c>();
public static Boolean launcherror;


// Method to Validate if all records for Transition details are loaded or not If not Throw error while doing Ready for Mod 5
public List<Customer_Transition__c> mod5ListValidate;
public void validateList(List<Customer_Transition__c> mod5ListValidate) {
     List<Customer_Transition__c> updatedMod5List = new List<Customer_Transition__c>();
          List<Customer_Transition__c> splitrecsupdate = new List<Customer_Transition__c>();

        //getting split Account details Data
        List<Split_Account_Detail__c> sadtls= [Select Id,Master_Account__c,Status__c,Customer_Transition__c,New_Header_Billing_Account_Code__c 
                                                from Split_Account_Detail__c 
                                                WHERE Customer_Transition__c IN :mod5ListValidate]; 
         
          for(Customer_Transition__c cust:mod5ListValidate){
          integer flag=0;  
               for(Split_Account_Detail__c sad :sadtls){
                     if(cust.Id==sad.Customer_Transition__c)  {
                        if (sad.Master_Account__c  ==null || sad.Master_Account__c  ==''){
                          flag=flag+1;
                        }
                     }
               }
               if(flag>0){
               cust.addError('Split Records are not completely Loaded');               
               }
               else{
               // Roting the records with >800 consignees to Batch Class
               
                               Integer batchscope=Integer.valueof(Label.BatchScope);

                   if(cust.No_of_Active_Sites__c >batchscope){
                   Customer_Transition__c  custnew= new Customer_Transition__c (Id=cust.Id);
                   custnew.Mod5_Process__C=true ;
                   custnew.Mod4FlowStatus__c= 'SplitSubmitted';
                   splitrecsupdate.add(custnew);

                   }
                   else
                   updatedMod5List.add(cust);
               }
               
       }
        
        //Call the mod 5 Method for splitting 
       
        if(updatedMod5List.size() > 0)
        executemod5(updatedMod5List);
        
                 
                 if(splitrecsupdate .size()>0)
                 update splitrecsupdate ;
                 
                

}



// Method to Process Split Object Records when Mo5 checked
    public List<Customer_Transition__c> mod5List;
    //mod5List will contain all the List of Transition recs whose MOD5 is checked
    public void executemod5(List<Customer_Transition__c> mod5List) {
    
    ///System.debug('&&&&&&&&&&&&Inside Mod 5 Method');
        map<id,Customer_Transition__c> mapct = new map<id,Customer_Transition__c>();
        map<id,Account> dtlmap = new map<id,Account>();
        map<id,List<Split_Account_Detail__c>> mapcustsite = new map<id,List<Split_Account_Detail__c>>();
        map<id,Split_Account_Detail__c> mapsplitcust = new map<id,Split_Account_Detail__c>();
        List<Customer_Transition__c> launchCT = new List<Customer_Transition__c>();
        List<Split_Account_Detail__c> reassigndtl = new List<Split_Account_Detail__c>();
        List<Split_Account_Detail__c> resad = new List<Split_Account_Detail__c>();
        List<Account> accinsertlist = new List<Account>();
        Set<String> setnewacc = new Set<String>();
        Set<ID> cnsgAcc = new set<ID>();
        map<id,string> mapusrTitle = new map<id,string>();
        set<Id> accHdrOwner = new set<id>();
        List<Split_Account_Detail__c> sadtls = new List<Split_Account_Detail__c>();
        Set<String> setNewMainAccAdd = new Set<String>();
        Map<String, Account> mapAccAdd = new Map<String, Account>();
        Set<Id> billUpList= new    Set<Id>();
        
        //getting split Account details Data
        for(Split_Account_Detail__c sadrec : [Select Id, Customer_Transition__r.omx_primary_key__c,Main_Account_Name__c, Status__c,
                                                    Error_Message__c,
                                                    Master_Account__c, 
                                                    Original_Account__c, Original_Account__r.ownerId,
                                                    Original_Account__r.Address1__c,Original_Account__r.Address2__c,
                                                    Original_Account__r.city__C,Original_Account__r.zip__C,
                                                    Original_Account__r.state__c,Original_Account__r.country__C,
                                                    Original_Account__r.parentId,Original_Account__r.status__c,
                                                    Original_Account__r.Sales_PersonID__c,Customer_Transition_Detail_Id__c,
                                                    SALES_REP_ID__c, Ship_To_Account__c, SHIP_TO_NAME__c, Billing_Account__c, Customer_Transition__c, 
                                                    OMX_ACCOUNT__c, OMX_ACCT_NAME__c, SHIP_TO_CONSIGNEE__c, SHIPTO_ADDRESS_1__c, SHIPTO_ADDRESS_2__c, 
                                                    SHIP_TO_CITY__c, SHIP_TO_STATE__c, SHIP_TO_ZIP__c, BILL_TO_CONSIGNEE__c, BILL_TO_NAME__c, 
                                                    BILL_TO_ADDRESS_1__c, BILL_TO_ADDRESS_2__c, BILL_TO_CITY__c, BILL_TO_STATE__c, BILL_TO_ZIP__c, 
                                                    NEW_BILL_TO_OMX_CONSIGNEE__c, NEW_BILLING_TYPE_AT_HEADER_LEVEL__c,New_Header_Billing_Account_Code__c,
                                                    Ship_To_Account__r.Sales_PersonID__c, Ship_To_Account__r.owneriD,NEW_MAIN_ACCT_ADDRESS__c ,
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
                                                    WHERE Customer_Transition__c IN :mod5List]){    
            sadtls.add(sadrec);
            if(!accHdrOwner.contains(sadrec.Original_Account__r.ownerId))
            accHdrOwner.add(sadrec.Original_Account__r.ownerId);
            
          if(sadrec.NEW_BILL_TO_OMX_CONSIGNEE__c ==sadrec.SHIP_TO_CONSIGNEE__c){
          
                  if(!billUpList.contains(sadrec.Billing_Account__c))
                  billUpList.add(sadrec.Billing_Account__c);          

          
          }
        }
        
        if(billUpList.size()>0){
        List<Account >AccBillList= new List<Account >();
        //for( integer i=0;i<billUpList.size();i++){
        for (Id i : billUpList) {

          Account accnew= new Account(Id=i,Primary_BillTo__C=true);
          AccBillList.add(accnew);
        }
        update AccBillList;
        }
      
      for(User usrTitle : [Select ID,Short_Title__c from User where Id=:accHdrOwner]){
        mapusrTitle.put(usrTitle.id,usrTitle.Short_Title__c);
      }
      
      /// System.debug('&&&&&&&&&&&& got Title');  
      
             //Looping over the selected Records to create Account Map
      for(Customer_Transition__c cust:mod5List){           
           for(Split_Account_Detail__c sad :sadtls){
                    if(sad.Customer_Transition__c==cust.Id){
                    // if the current Omx Key not equal given Master Omx key create new Main accounts
                       if(sad.Customer_Transition__r.omx_primary_key__C!=sad.Master_Account__c )  {                                  
                          if(!setnewacc.contains(sad.Master_Account__c)){                            
                           setnewacc.add(sad.Master_Account__c);

                           if(sad.NEW_MAIN_ACCT_ADDRESS__c!=null){
                            setNewMainAccAdd.add(sad.NEW_MAIN_ACCT_ADDRESS__c);
                           }
                          } 
                        }
                    }
                }
           }
    
        setnewacc.clear();
           
           
          /// System.debug('&&&&&&&&&&&& Before loop'+setNewMainAccAdd);  
           
      if((!setNewMainAccAdd.isEmpty()) && (setNewMainAccAdd.size() > 0)){
            try{
            List<Account> accAddressList=[Select  omx_primary_key__c ,Address1__c,Address2__c,City__c,State__c,Zip__c,country__C
                               from account
                               where omx_primary_key__c in :setNewMainAccAdd];
            for(Account eachAcc : accAddressList)
            mapAccAdd.put(eachAcc.omx_primary_key__c,eachAcc);
            } catch(Exception e) {
          ///  System.debug('&&&&&&&&&&&& exception +e');
            }
        }
       /// System.debug('&&&&&&&&&&&& Before adding account'+mapAccAdd);
        
             //Looping over the selected Records 
        for(Customer_Transition__c cust:mod5List){           
           for(Split_Account_Detail__c sad :sadtls){
                    if(sad.Customer_Transition__c==cust.Id){
                    // if the current Omx Key not equal given Master Omx key create new Main accounts
                       if(sad.Customer_Transition__r.omx_primary_key__C!=sad.Master_Account__c )  {                                  
                          if(!setnewacc.contains(sad.Master_Account__c)){                            
                           setnewacc.add(sad.Master_Account__c);
                           
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
                           
                          /// System.debug('&&&&&&&&&&&&&&&&Address'+sad.NEW_MAIN_ACCT_ADDRESS__c);

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
                           
                            Account acc = new Account(name=sad.Main_Account_Name__c,
                                                    omx_primary_key__c = sad.Master_Account__c,
                                                    OMX_Mainframe_Account_Number__c = sad.Master_Account__c,
                                                    ownerId=acctOwner,
                                                    parentId=sad.Original_Account__r.parentId, 
                                                    Sales_PersonID__c=salesperson,
                                                    status__C=sad.Original_Account__r.status__c,
                                                    OMX_Mainframe_Account_Level__c = 'Main Account',
                                                    Split_Record__c=true,address1__C=address1,
                                                    address2__C=address2,
                                                    city__C=city,
                                                    country__C=country,
                                                    state__c=state,
                                                    zip__C=zip,
                                                    recordtypeid= Schema.SObjectType.Account.getRecordTypeInfosByName().get('Customer (OfficeMax)').getRecordTypeId(),
                                                    // Start - Story #00888275
                                                    Segment__c = sad.Original_Account__r.Segment__c);
                                                    // End - Story #00888275
                                                    
                            accinsertlist.add(acc);
                           /// System.debug('&&&&&&&&&&&&&&acc'+sad.Master_Account__c);
                           ///system.debug('Executing Account to Insert');
                           } 
                        }
                    }
                }
           }
      
        
       // Inserting the new Main accounts
           if(accinsertlist.size()>0){
          /// system.debug('>>>>>>accinsertlist>>>>>>'+accinsertlist);
           insert accinsertlist;
           ///system.debug('>>>>accinsertlist returned>>>>>'+accinsertlist);
           }
           
  
     
     //Variable Declarations
      Map<Id,Id> custMap= new Map<Id,Id>(); 
      Map<String,Id> custMapList= new Map<String,Id>(); 
      Map<String,Id> accMapList= new Map<String,Id>(); 

      List<Account> SiteList= new  List<Account>();
      List<Customer_Transition_Dtls__c > detailList= new  List<Customer_Transition_Dtls__c >();
      Set<Id> SiteListId= new Set<Id>();
      Set<Id> detailListId= new Set<Id>();
      
     //getting the transition Records of newly created accounts        
     List<Customer_transition__C > custNewList=[Select Id , omx_primary_key__C,account__r.Id, 
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
            custMap.put(cst.account__r.Id, cst.Id);
            custMapList.put(cst.omx_primary_key__C, cst.Id);
            accMapList.put(cst.omx_primary_key__C, cst.account__r.Id);
            
            // Start - Story #00888275
            newOmxKeyToCT.put(cst.OMX_Primary_Key__c, cst);
            // End - Story #00888275
         }
         System.debug('***** newOmxKeyToCT = ' + newOmxKeyToCT);
          
 
          
    // Looping Records to Reassign the Related Accounts for Sites of New Groups      
       /// system.debug('>>>sadtls>>>>'+sadtls);
       Set<String> accountsProcessed = new Set<String>();
       
        for(Split_Account_Detail__c sad : sadtls){
        
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
                        Id transId= custMap.get(relatedaccountId);                        
                       /// System.debug('&&&&&&&&&&&&&&here1'+relatedaccountId);
                        ///System.debug('&&&&&&&&&&&&&&here2'+transId);
                   
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
            
        }       
            
            
            
            
            
     ///system.debug('>>>>>SiteList>>>>>>'+SiteList);
     if(SiteList.size()>0)
     update  SiteList; 
     
     ////system.debug('>>>>>detailList>>>>>>'+detailList);
     if(detailList.size()>0)
     update  detailList;
     
     // Start - Story #00888275
     if (newOmxKeyToCT.size() > 0) {
         update newOmxKeyToCT.values();
     }
     // End - Story #00888275
       
       
     // call the Method to Populate Related Linked transition details
       if(executeoncetest.mod5extnhlpr){
       Mod5HelperExtension modExt = new     Mod5HelperExtension ();
       modExt .updateLinkedTransition(mod5List,custMapList,accMapList);
       
   
       }        
       
       
                  
    }
}