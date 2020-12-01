public class OMXAccountPrimarySiteFactory {  
/*****************************************************************************************
Description: Since officemax does not have a designated primary site, this trigger will 
create a new primary site account based off the main account for inserts, and update 
the primary site account for updates. this is only for officemax main accounts and national accounts. 

Created By: dave sommer
Created Date: 3/10/2014
******************************************************************************************/    
    //Record Types via Map
    private static Map<String,Schema.RecordTypeInfo> rtMapByName = Schema.SObjectType.Account.getRecordTypeInfosByName();
    public static final string OMX_RECORD_TYPE_NAME_CUSTOMER = 'Customer (OfficeMax)';  
    public static final string OMX_RECORD_TYPE_NAME_SITE = 'Site (OfficeMax)';  

    public static void createPrimarySites(List<Account> listAccounts) {
        System.debug('****** OMX createPrimarySites **********');
        //get main omx account record type
        Id omxRecordTypeIdCustomer = getRecordTypeId(OMX_RECORD_TYPE_NAME_CUSTOMER );
        Id omxRecordTypeIdSite = getRecordTypeId(OMX_RECORD_TYPE_NAME_SITE );
       
        List<Account> PrimarySiteToInsert = new List<Account>();
        List<Account> Site002ToInsert = new List<Account>();

        for (Account oAccount : listAccounts) {
            System.debug('****** Found accounts: ' + listAccounts.size() + ' **********');
            //System.debug('****** Found account RT12: ' + omxRecordTypeIdCustomer  + ' **********');
            System.debug('****** Found account RT: ' + oAccount.RecordTypeID + ' - ' + oAccount.RecordType.developername + ' **********');
//            if ((oAccount.RecordTypeID == omxRecordTypeIdCustomer ) && (oAccount.OMX_Mainframe_Account_Level__c == 'Main Account')) { 
//            if ((oAccount.OMX_Mainframe_Account_Level__c == 'Main Account') || (oAccount.OMX_Mainframe_Account_Level__c == 'National')){ 
            if (oAccount.RecordTypeID == omxRecordTypeIdCustomer){ //this will handle main and national accounts
                  System.debug('****** Found a new OMX customer or site account: ' + oAccount.name + ' **********');
                  //create the new primary site account
                  Account newPrimarySite = new Account();
                  newPrimarySite.Name = oAccount.Name ;
                  newPrimarySite.OMX_Mainframe_Consignee_ID__c =  'OMX001'; //using this as the new standard for omx primary site IDs
                  newPrimarySite.OMX_Mainframe_Account_Number__c =  oAccount.OMX_Mainframe_Account_Number__c ;
                  
                              System.debug('****** Primary: ' + oAccount.OMX_Primary_Key__c + ' **********'+oAccount.OMX_Mainframe_Account_Number__c);

                  newPrimarySite.OMX_Primary_Key__c =  oAccount.OMX_Mainframe_Account_Number__c + 'OMX001' ;
                  newPrimarySite.RecordTypeId =  omxRecordTypeIdSite ;
                  newPrimarySite.Primary_Site__c = true;
                  newPrimarySite.Related_Account__c = oAccount.Id;
                  newPrimarySite.OwnerId = oAccount.OwnerId;
                                    
                  newPrimarySite.Type =  'Site' ;
                  newPrimarySite.OMX_Mainframe_Account_Level__c = 'Site/Consignee' ;
                  newPrimarySite.Original_System__c = 'OfficeMax OMXAccountTrigger' ;
                  
                  newPrimarySite.Segment__c =  oAccount.Segment__c ;
                  newPrimarySite.Phone =  oAccount.Phone ;
                  newPrimarySite.OMX_Mainframe_Owning_Rep_Number__c =  oAccount.OMX_Mainframe_Owning_Rep_Number__c ;
                  newPrimarySite.State__c =  oAccount.State__c ;
                  newPrimarySite.Address1__c =  oAccount.Address1__c ;
                  newPrimarySite.Address2__c =  oAccount.Address2__c ;
                  newPrimarySite.City__c =  oAccount.City__c ;
                  newPrimarySite.Zip__c = oAccount.Zip__c ;
                  newPrimarySite.Country__c = oAccount.Country__c ;
                  newPrimarySite.Status__c = oAccount.Status__c ;
                  newPrimarySite.Sector__c = oAccount.Sector__c ;
                  newPrimarySite.DNB_Duns__c = oAccount.DNB_Duns__c ;
                  newPrimarySite.Industry_OD_SIC_DB__c =  oAccount.Industry_OD_SIC_DB__c ;
                  newPrimarySite.Sic = oAccount.Sic ;
                  
                  newPrimarySite.Legacy_CreatedDate__c = oAccount.Legacy_CreatedDate__c;
                  newPrimarySite.Legacy_LastModifiedDate__c =  oAccount.Legacy_LastModifiedDate__c ;

                  //insert newPrimarySite; //bulkify this !!!!!!!!
                  //add new account to map
                  PrimarySiteToInsert.add(newPrimarySite);
                  
                  
       Account newSite = new Account();
                  NewSite.Name = oAccount.Name ;
                  NewSite.OMX_Mainframe_Consignee_ID__c =  'OMX002'; //using this as the new standard for omx primary site IDs
                  NewSite.OMX_Mainframe_Account_Number__c =  oAccount.OMX_Mainframe_Account_Number__c ;
                                                System.debug('****** Secondary: ' + oAccount.OMX_Primary_Key__c + ' **********'+oAccount.OMX_Mainframe_Account_Number__c);

                  NewSite.OMX_Primary_Key__c =  oAccount.OMX_Mainframe_Account_Number__c + 'OMX002' ;
                  NewSite.RecordTypeId =  omxRecordTypeIdSite ;
                 // NewSite.Primary_Site__c = true;
                  NewSite.Related_Account__c = oAccount.Id;
                  NewSite.OwnerId = oAccount.OwnerId;
                                    
                  NewSite.Type =  'Site' ;
                  NewSite.OMX_Mainframe_Account_Level__c = 'Site/Consignee' ;
                  NewSite.Original_System__c = 'OfficeMax OMXAccountTrigger' ;
                  
                  NewSite.Segment__c =  oAccount.Segment__c ;
                  NewSite.Phone =  oAccount.Phone ;
                  NewSite.OMX_Mainframe_Owning_Rep_Number__c =  oAccount.OMX_Mainframe_Owning_Rep_Number__c ;
                  NewSite.State__c =  oAccount.State__c ;
                  NewSite.Address1__c =  oAccount.Address1__c ;
                  NewSite.Address2__c =  oAccount.Address2__c ;
                  NewSite.City__c =  oAccount.City__c ;
                  NewSite.Zip__c = oAccount.Zip__c ;
                  NewSite.Country__c = oAccount.Country__c ;
                  NewSite.Status__c = oAccount.Status__c ;
                  NewSite.Sector__c = oAccount.Sector__c ;
                  NewSite.DNB_Duns__c = oAccount.DNB_Duns__c ;
                  NewSite.Industry_OD_SIC_DB__c =  oAccount.Industry_OD_SIC_DB__c ;
                  NewSite.Sic = oAccount.Sic ;
                  
                  NewSite.Legacy_CreatedDate__c = oAccount.Legacy_CreatedDate__c;
                  NewSite.Legacy_LastModifiedDate__c =  oAccount.Legacy_LastModifiedDate__c ;

                  //insert NewSite        ; //bulkify this !!!!!!!!
                  //add new account to map
                  Site002ToInsert.add(NewSite);
            }
        }
        //now insert all the new primary site accounts
        system.debug('******** going to insert new accounts: ' + PrimarySiteToInsert.size());
        system.debug('******** going to insert new accounts: ' + PrimarySiteToInsert);
        if (PrimarySiteToInsert.isEmpty() == false) {
            //insert all accounts in map
            database.insert(PrimarySiteToInsert, false);
        }    
        if (Site002ToInsert.isEmpty() == false) {
        System.debug('&&&&&&&&&&& Site0002'+Site002ToInsert);
            //insert all accounts in map
List<String > omxkey= new List<String>();
LIst<Account> recList= new LIst<Account>();
            for(integer i=0;i<  Site002ToInsert.size();i++)
            omxkey.add(Site002ToInsert[i].omx_primary_key__C);
            
            System.debug('&&&&&&&&& Final List omxkey '+omxkey);
            if(omxkey.size()>0){
            recList=[select Id from Account where omx_primary_key__C in :omxkey];
            System.debug('&&&&&&&&& Final List '+recList);} 
            if(recList.size()==0)           
            insert Site002ToInsert;
            
        }    
    }
 
     public static void updatePrimarySites(List<Account> listAccounts) {
        System.debug('****** OMX updatePrimarySites **********');
        //get main omx account record type
        Id omxRecordTypeIdCustomer = getRecordTypeId(OMX_RECORD_TYPE_NAME_CUSTOMER );
        Id omxRecordTypeIdSite = getRecordTypeId(OMX_RECORD_TYPE_NAME_SITE );
       
        List<Account> PrimarySiteToUpsert = new List<Account>();
        List<Account> SiteToUpsert = new List<Account>();
        
        String LoggedINUser = UserInfo.getUserId();
        String LoginInUser_15Dig = LoggedINUser.substring(0,15);
        Boolean isLoggedinUserbyPass = isLoggedinUserByPassUser(LoginInUser_15Dig);

        for (Account oAccount : listAccounts) {
            System.debug('****** Found accounts to update: ' + listAccounts.size() + ' **********');
            //System.debug('****** Found account RT12: ' + omxRecordTypeIdCustomer  + ' **********');
            System.debug('****** Found account RT: ' + oAccount.RecordTypeID + ' - ' + oAccount.RecordType.developername + ' **********');
/*            if ((oAccount.RecordTypeID == omxRecordTypeIdCustomer ) && (oAccount.OMX_Mainframe_Account_Level__c == 'Main Account')) { */
            //if ((oAccount.OMX_Mainframe_Account_Level__c == 'Main Account') || (oAccount.OMX_Mainframe_Account_Level__c == 'National')) {
             if (oAccount.RecordTypeID == omxRecordTypeIdCustomer){ //this will handle main and national accounts
                 System.debug('****** Found an existing OMX customer or site account: ' + oAccount.name + ' **********');
                  //create the new primary site account
                  Account updatePrimarySite = new Account();
                  updatePrimarySite.Name = oAccount.Name ;
                  updatePrimarySite.OMX_Mainframe_Consignee_ID__c =  'OMX001'; //using this as the new standard for omx primary site IDs
                  updatePrimarySite.OMX_Mainframe_Account_Number__c =  oAccount.OMX_Mainframe_Account_Number__c ;
                  updatePrimarySite.OMX_Primary_Key__c =  oAccount.OMX_Mainframe_Account_Number__c + 'OMX001' ;
                  updatePrimarySite.RecordTypeId =  omxRecordTypeIdSite ;
                  updatePrimarySite.Primary_Site__c = true;
                  updatePrimarySite.Related_Account__c = oAccount.Id;
                  if(isLoggedinUserbyPass){ //Dont execute this for the Reps - caase #00268821 
                    //commented to prevent any updates from Mainframe as TOPS is source of truth
                    //updatePrimarySite.OwnerId = oAccount.OwnerId;
                  }
                                    
                  updatePrimarySite.Type =  'Site' ;
                  updatePrimarySite.OMX_Mainframe_Account_Level__c = 'Site/Consignee' ;
                  updatePrimarySite.Original_System__c = 'OfficeMax OMXAccountTrigger' ;
                  
                  updatePrimarySite.Segment__c =  oAccount.Segment__c ;
                  updatePrimarySite.Phone =  oAccount.Phone ;
                  //commented to prevent any updates from Mainframe as TOPS is source of truth
                  //updatePrimarySite.OMX_Mainframe_Owning_Rep_Number__c =  oAccount.OMX_Mainframe_Owning_Rep_Number__c ;
                  updatePrimarySite.State__c =  oAccount.State__c ;
                  updatePrimarySite.Address1__c =  oAccount.Address1__c ;
                  updatePrimarySite.Address2__c =  oAccount.Address2__c ;
                  updatePrimarySite.City__c =  oAccount.City__c ;
                  updatePrimarySite.Zip__c = oAccount.Zip__c ;
                  updatePrimarySite.Country__c = oAccount.Country__c ;
                  updatePrimarySite.Status__c = oAccount.Status__c ;
                  updatePrimarySite.Sector__c = oAccount.Sector__c ;
                  updatePrimarySite.DNB_Duns__c = oAccount.DNB_Duns__c ;
                  updatePrimarySite.Industry_OD_SIC_DB__c =  oAccount.Industry_OD_SIC_DB__c ;
                  updatePrimarySite.Sic = oAccount.Sic ;
                  
                  updatePrimarySite.Legacy_CreatedDate__c = oAccount.Legacy_CreatedDate__c;
                  updatePrimarySite.Legacy_LastModifiedDate__c =  oAccount.Legacy_LastModifiedDate__c ;

                  //add account to map
                  PrimarySiteToUpsert.add(updatePrimarySite);
                  
             Account NewSiteUpdate = new Account();
                  NewSiteUpdate.Name = oAccount.Name ;
                  NewSiteUpdate.OMX_Mainframe_Consignee_ID__c =  'OMX002'; //using this as the new standard for omx primary site IDs
                  NewSiteUpdate.OMX_Mainframe_Account_Number__c =  oAccount.OMX_Mainframe_Account_Number__c ;
                  NewSiteUpdate.OMX_Primary_Key__c =  oAccount.OMX_Mainframe_Account_Number__c + 'OMX002' ;
                  NewSiteUpdate.RecordTypeId =  omxRecordTypeIdSite ;
                 // NewSiteUpdate.Primary_Site__c = true;
                  NewSiteUpdate.Related_Account__c = oAccount.Id;
                   if(isLoggedinUserbyPass){ //Dont execute this for the Reps - caase #00268821 
                      //commented to prevent any updates from Mainframe as TOPS is source of truth
                      //NewSiteUpdate.OwnerId = oAccount.OwnerId;
                  }
                                    
                  NewSiteUpdate.Type =  'Site' ;
                  NewSiteUpdate.OMX_Mainframe_Account_Level__c = 'Site/Consignee' ;
                  NewSiteUpdate.Original_System__c = 'OfficeMax OMXAccountTrigger' ;
                  
                  NewSiteUpdate.Segment__c =  oAccount.Segment__c ;
                  NewSiteUpdate.Phone =  oAccount.Phone ;
                  //commented to prevent any updates from Mainframe as TOPS is source of truth
                  //NewSiteUpdate.OMX_Mainframe_Owning_Rep_Number__c =  oAccount.OMX_Mainframe_Owning_Rep_Number__c ;
                  NewSiteUpdate.State__c =  oAccount.State__c ;
                  NewSiteUpdate.Address1__c =  oAccount.Address1__c ;
                  NewSiteUpdate.Address2__c =  oAccount.Address2__c ;
                  NewSiteUpdate.City__c =  oAccount.City__c ;
                  NewSiteUpdate.Zip__c = oAccount.Zip__c ;
                  NewSiteUpdate.Country__c = oAccount.Country__c ;
                  NewSiteUpdate.Status__c = oAccount.Status__c ;
                  NewSiteUpdate.Sector__c = oAccount.Sector__c ;
                  NewSiteUpdate.DNB_Duns__c = oAccount.DNB_Duns__c ;
                  NewSiteUpdate.Industry_OD_SIC_DB__c =  oAccount.Industry_OD_SIC_DB__c ;
                  NewSiteUpdate.Sic = oAccount.Sic ;
                  
                  NewSiteUpdate.Legacy_CreatedDate__c = oAccount.Legacy_CreatedDate__c;
                  NewSiteUpdate.Legacy_LastModifiedDate__c =  oAccount.Legacy_LastModifiedDate__c ;

                  //insert NewSiteUpdate        ; //bulkify this !!!!!!!!
                  //add new account to map
                  SiteToUpsert.add(NewSiteUpdate);
            }
        }
        //now insert all the new primary site accounts
        system.debug('******** going to UPSERT accounts: ' + PrimarySiteToUpsert.size());
        system.debug('******** going to UPSERT accounts: ' + PrimarySiteToUpsert);
        if (PrimarySiteToUpsert.isEmpty() == false) {
            //insert all accounts in map
            upsert PrimarySiteToUpsert OMX_Primary_Key__c;
        } 
      if (SiteToUpsert.isEmpty() == false) {
            //insert all accounts in map
            upsert SiteToUpsert OMX_Primary_Key__c;
        }           
    }
    
  /***********************************Utils Method************************************************************************/
  public static Boolean isLoggedinUserByPassUser(String LoggedInUserID){
    Boolean retValue = false;
    list<Admin_Config__c> byPassTrigger =  [select Id,Bypass_Triggers__c from Admin_Config__c];
    if(byPassTrigger.size()>0){
        String ByPassUser = byPassTrigger[0].Bypass_Triggers__c;
        If(ByPassUser != null){
        
        list<String> LBU = ByPassUser.Split(';');
        for(String a: LBU){
            if(a == LoggedInUserID){
                retValue = true;
            }
           }
        }
    }
    //User is part of Bypass
    return retValue;
  }
  
  
  //================================================================================//
  //Get Record Type Id from record Type Name
  //================================================================================//
  public static  Id getRecordTypeId(String recordTypeName) {
    RecordTypeInfo siteRecordType = rtMapByName.get(recordTypeName); 
    if(siteRecordType == null) return null;
    
    return siteRecordType.getRecordTypeId();
  }
      
 }