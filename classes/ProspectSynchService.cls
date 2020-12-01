global class ProspectSynchService  {
  public static boolean prospectSynchServiceRunning = false;
  public class ProspectSynchServiceException extends Exception {}

  global class SalesCustomerProspectSynch {
    webservice List<ServiceProspectSynch> customers;
    webservice List<ServiceProspectSynchMessageId> messageIds; 
  }
  
  global class ServiceProspectSynchMessageId{
    webservice String messageId;
  }
  
  global class ServiceProspectSynch {
    webservice String SFDC_Id;
    webservice String ORACLE_PARTY_ID;
    webservice List<ServiceProspectSiteSynch> site;
  }
  
  global class ServiceProspectSiteSynch {
    webservice String SFDC_Id;
    webservice String ORACLE_PARTY_SITE_ID;
  }
  
  webservice static boolean SynchProspects(SalesCustomerProspectSynch scps) {
  
  /// 12-02-2019   02252364 Modifying code to Incude parent account recordtype
    RecordType prospectRecType = [select id from recordtype where name = 'Prospect'];
    RecordType ParentRecType = [select id from recordtype where name = 'Parent'];

    RecordType siteRecType = [select id from recordtype where name = 'Site'];
     RecordType omxProspectRecType = [select id from recordtype where name = 'Customer (OfficeMax)'];
    RecordType omxSiteRecType = [select id from recordtype where name = 'Site (OfficeMax)'];
    prospectSynchServiceRunning = true;
    
    //Get the salesforce id's to check if oracle id exist.  If the oracle id is there we don't want
    //to update the account
    List<Id> oraclePartyListIds = new List<Id>();
    Map<Id,String> passedIdOracleIdMap = new Map<Id,String>();
      List<String> oraclePartyOListIds = new List<String>();
    Map<String,String> passedIdOracleIdOMap = new Map<String,String>();
    if(scps.customers.size() > 0){
      for(ServiceProspectSynch synchAcct : scps.customers){
       // if (synchAcct.SFDC_Id.endsWith('-OMX'))
        if (synchAcct.SFDC_Id.contains('-OMX'))
        { 
        String val=synchAcct.SFDC_Id;             
        if (synchAcct.SFDC_Id.endsWith('-OMX'))
        val=  val.substring(0,val.lastIndexOf('-OMX'));
        
         oraclePartyOListIds.add(val);
        passedIdOracleIdOMap.put(val,synchAcct.ORACLE_PARTY_ID);
        }
      else
        {
        oraclePartyListIds.add(synchAcct.SFDC_Id);
        passedIdOracleIdMap.put(synchAcct.SFDC_Id,synchAcct.ORACLE_PARTY_ID);
        }
        if((synchAcct.site != null) && (synchAcct.site.size() > 0)){
          for(ServiceProspectSiteSynch synchSite : synchAcct.site){
          
          
          System.debug('&&&&&entered here'+synchSite.SFDC_Id);
          if(synchSite.SFDC_Id.contains('-OMX'))
          {
            String val=synchSite.SFDC_Id;            
            if (synchSite.SFDC_Id.endsWith('-OMX'))
            val=  val.substring(0,val.lastIndexOf('-OMX'));
        
            oraclePartyOListIds.add(val);
            passedIdOracleIdOMap.put(val,synchSite.ORACLE_PARTY_SITE_ID);
          }
            else
            {
            oraclePartyListIds.add(synchSite.SFDC_Id);
            passedIdOracleIdMap.put(synchSite.SFDC_Id,synchSite.ORACLE_PARTY_SITE_ID);
            }
            
          }
        }            
      }
    }
    
    List <Account> oraclePartyList = [select id, oracle_party_id__c, oracle_party_site_id__c,
                                             recordtypeid ,OMX_Primary_Key__c ,related_account__c
                                      from account where id in :oraclePartyListIds or OMX_Primary_Key__c in :oraclePartyOListIds];
    List <Account> accountSynch = new List <Account>();
    
    for(Account lclAcct : oraclePartyList){
     System.Debug('Inside of the list'+lclAcct.Id  );
      
      /// 12-02-2019   02252364 Modifying code to Incude parent account recordtype
      if((lclAcct.RecordTypeId == prospectRecType.Id      ||   lclAcct.RecordTypeId == ParentRecType.Id  )&& 
        (lclAcct.Oracle_Party_ID__c == null || lclAcct.Oracle_Party_ID__c.equals(''))){
        lclAcct.Oracle_Party_ID__c = passedIdOracleIdMap.get(lclAcct.id);
        System.Debug(lclAcct.Oracle_Party_ID__c +'Prospect id');
        accountSynch.add(lclAcct);
      }
      else if(lclAcct.RecordTypeId == siteRecType.Id &&
             (lclAcct.Oracle_Party_Site_ID__c == null || lclAcct.Oracle_Party_Site_ID__c.equals(''))){
        lclAcct.Oracle_Party_Site_ID__c = passedIdOracleIdMap.get(lclAcct.id);
          System.Debug(lclAcct.Oracle_Party_Site_ID__c +'Prospect Site id');
        accountSynch.add(lclAcct);
      }
      else   if((lclAcct.RecordTypeId == omxProspectRecType.Id )
      //&&   (lclAcct.Oracle_Party_ID__c == null || lclAcct.Oracle_Party_ID__c.equals(''))
        ){
        lclAcct.Oracle_Party_ID__c = passedIdOracleIdOMap.get(lclAcct.OMX_Primary_Key__c );
        System.Debug(lclAcct.Oracle_Party_ID__c +'OMX Prospect id');
          oraclePartyListIds.add(lclAcct.id);
        accountSynch.add(lclAcct);
        
      }
      else if(lclAcct.RecordTypeId == omxSiteRecType.Id
             
             // &&(lclAcct.Oracle_Party_Site_ID__c == null || lclAcct.Oracle_Party_Site_ID__c.equals(''))
             
             ){
        lclAcct.Oracle_Party_Site_ID__c = passedIdOracleIdOMap.get(lclAcct.OMX_Primary_Key__c );
       // oraclePartyListIds.add(lclAcct.id);
        oraclePartyListIds.add(lclAcct.related_account__c);
        System.Debug(lclAcct.Oracle_Party_Site_ID__c +'Omx Prospect Site id');
        accountSynch.add(lclAcct);
      }
      
    }
    
    update(accountSynch);
    
    List <Prospect_Message__c> lclProspMsgList = [select Message_Complete__c 
                                                  from prospect_message__c 
                                                  where (account__c in :oraclePartyListIds )and
                                                        Message_Complete__c = 'IP'];
    
    for(Prospect_Message__c lclMsg : lclProspMsgList){
      lclMsg.Message_Complete__c = 'P';
    }
    
    update(lclProspMsgList);
     List <Prospect_Message__c> lclProspMsgList1 = [select Message_Complete__c 
                                                  from prospect_message__c 
                                                  where (account__c in :oraclePartyListIds )and
                                                        Message_Complete__c = 'AP'];
                                                        
       for(Prospect_Message__c lclMsg : lclProspMsgList1){
      lclMsg.Message_Complete__c = 'NP';
    }                                                   
           update(lclProspMsgList1);                                              
    return true;
  }
  
  @isTest
  private static void Test_ProspectSynchService() {
    
    ProspectSynchService.ServiceProspectSynch sps = new ProspectSynchService.ServiceProspectSynch();
    Account acc = Test_Utils.CreateAccount();
    acc.Oracle_Party_ID__c = '123xyz';
    upsert acc;
    recordtype rec1=[select id from recordtype where name='Prospect'];
    recordtype rec2=[select id from recordtype where name='Site (OfficeMax)'];
    
    Account acc1 = Test_Utils.CreateAccount();
    acc1.Oracle_Party_ID__c = '123abc';
    upsert acc1;
    
    Account acc2 = Test_Utils.CreateAccount();
    acc2.recordtypeid= rec1.id;
    acc2.Oracle_Party_ID__c = '';
    acc2.OMX_Primary_Key__c = acc.Id;
    upsert acc2;
    
    Account acc3 = Test_Utils.CreateAccount();
    acc3.recordtypeid= rec2.id;
    acc3.Oracle_Party_Site_ID__c = '';
    acc3.OMX_Primary_Key__c = acc1.Id;
    upsert acc3;
    
    Prospect_Message__c pm1 = new Prospect_Message__c(account__c = acc.Id, Message_Complete__c ='IP');
    Prospect_Message__c pm2 = new Prospect_Message__c(account__c = acc1.Id, Message_Complete__c ='AP');
    List<Prospect_Message__c> pmList = new List<Prospect_Message__c>();
    
    pmList.add(pm1);
    pmList.add(pm2);
    insert pmList;  
    
    
    sps.SFDC_Id=acc.Id;
    sps.ORACLE_PARTY_ID= acc.Oracle_Party_ID__c;
    ProspectSynchService.ServiceProspectSynchMessageId spsmId = new ProspectSynchService.ServiceProspectSynchMessageId();
    spsmId.messageId = 'ad3msg';
    ProspectSynchService.SalesCustomerProspectSynch scps = new ProspectSynchService.SalesCustomerProspectSynch();
    List<ServiceProspectSynch> spsLst = new List<ServiceProspectSynch>();
    spsLst.add(sps);
    scps.customers = spsLst;
    
    ProspectSynchService.ServiceProspectSiteSynch pSite = new ProspectSynchService.ServiceProspectSiteSynch();
    pSite.ORACLE_PARTY_SITE_ID = '1234';
    pSite.SFDC_Id = acc1.id;
    List<ServiceProspectSiteSynch> pSites = new List<ServiceProspectSiteSynch>();
    pSites.add(pSite);
    sps.site= pSites;
    
    List<ServiceProspectSynchMessageId> spsmIdLst = new List<ServiceProspectSynchMessageId>();
    spsmIdLst.add(spsmId);
    scps.messageIds = spsmIdLst;
     
    scps.messageIds = new List<ServiceProspectSynchMessageId>();
    ProspectSynchService.SynchProspects(scps);
    new ProspectSynchService();

    ProspectSynchService.ServiceProspectSynch sps1 = new ProspectSynchService.ServiceProspectSynch();

    sps1.SFDC_Id= acc.Id+'-OMX';
    sps1.ORACLE_PARTY_ID= '1234867';
    ProspectSynchService.ServiceProspectSynchMessageId spsmId3 = new ProspectSynchService.ServiceProspectSynchMessageId();
    spsmId3.messageId = 'ad3msg';
    ProspectSynchService.SalesCustomerProspectSynch scps3 = new ProspectSynchService.SalesCustomerProspectSynch();
    List<ServiceProspectSynch> spsLst3 = new List<ServiceProspectSynch>();
    spsLst3.add(sps1);
    scps3.customers = spsLst3;

    ProspectSynchService.ServiceProspectSiteSynch pSite1 = new ProspectSynchService.ServiceProspectSiteSynch();
    pSite1.ORACLE_PARTY_SITE_ID = '1232';
    pSite1.SFDC_Id = acc1.Id+'-OMX';
    List<ServiceProspectSiteSynch> pSites1 = new List<ServiceProspectSiteSynch>();
    pSites1.add(pSite1);
    sps1.site= pSites1;
    
    List<ServiceProspectSynchMessageId> spsmIdLst1 = new List<ServiceProspectSynchMessageId>();
    spsmIdLst1.add(spsmId3);
    scps3.messageIds = spsmIdLst1;
     
    scps3.messageIds = new List<ServiceProspectSynchMessageId>();
    ProspectSynchService.SynchProspects(scps3);
    new ProspectSynchService();
  }
}