/**************************************************************************
*Created By :
*Created Date :
*Purpose :
SOA calls this class via web service call to get prospects for insert or update
into E-Business Suite.

Last Modified       : 05/19/2012
Last Modified By    : Phil Price
Last Modified Reason: Add Oracle party_id to party_site_id to message.


**************************************************************************/

global class ProspectService  {
  
  public class ProspectServiceException extends Exception {}

  global class SalesCustomerProspectCreation {
    webservice List<ServiceProspect> prospects; 
  }
    
  global class ServiceProspect {
    webservice String Duns_Number;
    webservice String Industry;
    webservice String Organization_Name;
    webservice String Organization_OD_WCW;
    webservice String Organization_SFDC_Id;
    webservice String Organization_Status;
    webservice String Organization_WCW;
    webservice String Segment;
    webservice String Rep;
    webservice String Oracle_Party_Id;
    webservice List<ServiceProspectSite> site;
  }
  
  global class ServiceProspectSite {
    webservice String Address_Line1;
    webservice String Address_Line2;
    webservice String City;
    webservice String Country;
    webservice String Oracle_Party_Site_Id;
    webservice String Party_Site_Name;
    webservice String Party_Site_OD_WCW;
    webservice String Party_Site_SFDC_Id;
    webservice String Party_Site_Status;
    webservice String Party_Site_Use_Type;
    webservice String Party_Site_WCW;
    webservice String State;
    webservice String Zip;
    webservice String Rep;
  }
  
  webservice static SalesCustomerProspectCreation GetSubmittedProspects() {

  SalesCustomerProspectCreation retProspList = new SalesCustomerProspectCreation();

    RecordType recType = [select id from recordtype where name = 'Prospect'];

    List<Prospect_Message__c> prosMsgs = [select id, account__c from prospect_message__c where message_complete__c = 'NP'];

    List<Id> acctsToProc = new List<Id>();
    Map<Id, ServiceProspect> spMap = new Map<Id, ServiceProspect>();
    Map<ID,String> ownertoRelate = new Map<ID,String> ();
    Set<ID> ownerIDs = new Set<ID>();

    for(Prospect_Message__c lclPm : prosMsgs)
      acctsToProc.add(lclPm.account__c);
     
    Map<Id, Account> prospectAccounts = new Map<Id,Account>(
    [select Duns_Number__c, Industry_OD_SIC_DB__c, Name, Org_WCW_Count_Rep__c, 
                Id, Status__c, Org_WCW_Count_DB__c, Segment_code__c, sales_personid__r.name,Sales_PersonID__r.role_relate_id__c,
                Oracle_Party_ID__c,ownerid
       from account 
      where recordtypeid = :recType.id
        and id in :acctsToProc]);
        
  for(Account a : prospectAccounts.values())
   ownerIDs.add(a.ownerid);

  Map<Id, Account> prospectSiteAccounts = new Map<Id, Account>(
    [select related_account__c, Name, Org_WCW_Count_Rep__c, Id, status__c, sales_personid__r.name,Sales_PersonID__r.role_relate_id__c,
                address1__c, address2__c, city__c, country__c, state__c, zip__c, Oracle_Party_Site_Id__c,ownerid
       from account 
      where related_account__r.id in :prospectAccounts.keySet()]);
      
  for (account a:prospectSiteAccounts.values())
      ownerIDs.add(a.ownerid);
      
  for (sales_person__c s:[select user__c,Role_Relate_Id__c from sales_person__c where user__c in :ownerIDs and isactive__c=true and Primary__c=true])
        ownertoRelate.put(s.user__c,s.Role_Relate_Id__c);

  for (Account lclAcct : prospectAccounts.values() ) {
    ServiceProspect sp      = new ServiceProspect();
    sp.Duns_Number          = lclAcct.Duns_Number__c;
    sp.Industry             = lclAcct.Industry_OD_SIC_DB__c;
    sp.Organization_Name    = lclAcct.Name;
    //sp.Rep                  = lclAcct.Sales_PersonID__r.role_relate_id__c;
    if (ownertoRelate.containskey(lclAcct.ownerid))
      sp.Rep = ownertoRelate.get(lclAcct.ownerid);
    else
	  sp.Rep                  = lclAcct.Sales_PersonID__r.role_relate_id__c;
    sp.Organization_SFDC_Id = lclAcct.Id;
    sp.Organization_Status  = lclAcct.Status__c;
    sp.Segment              = lclAcct.Segment_code__c;
    sp.Oracle_Party_Id      = lclAcct.Oracle_Party_ID__c;
        
    try {
      sp.Organization_OD_WCW = lclAcct.Org_WCW_Count_Rep__c.toPlainString();
    } catch(Exception e) {
      sp.Organization_OD_WCW = '';
    }

    try {
      sp.Organization_WCW = lclAcct.Org_WCW_Count_DB__c.toPlainString();
    } catch(Exception e) {
      sp.Organization_WCW = '';
    }
    
    spMap.put(lclAcct.Id, sp);
  }

  for(Account lclSite : prospectSiteAccounts.values()) {

    Id relId = lclSite.related_account__c;

    if (spMap.containsKey(relId)) {

      ServiceProspectSite lclSps = new ServiceProspectSite();
      lclSps.Party_Site_Name      = lclSite.Name;
      //lclSps.Rep                  = lclSite.Sales_PersonID__r.role_relate_id__c;
	  if (ownertoRelate.containskey(lclSite.ownerid))
		 lclSps.Rep = ownertoRelate.get(lclSite.ownerid);
	  else
		 lclSps.Rep                  = lclSite.Sales_PersonID__r.role_relate_id__c;
      lclSps.Address_Line1        = lclSite.Address1__c;
      lclSps.Address_Line2        = lclSite.Address2__c;
      lclSps.City                 = lclSite.City__c;
      lclSps.Country              = lclSite.Country__c;
      lclSps.Party_Site_SFDC_Id   = lclSite.id;
      lclSps.Party_Site_Status    = lclSite.status__c;
      lclSps.State                = lclSite.State__c;
      lclSps.Zip                  = lclSite.zip__c;
      lclSps.Oracle_Party_Site_Id = lclSite.Oracle_Party_Site_ID__c;
      
      try {
        lclSps.Party_Site_OD_WCW = lclSite.Org_WCW_Count_Rep__c.toPlainString();
      } catch(Exception e) {
        lclSps.Party_Site_OD_WCW = '';
      }

      ServiceProspect spRec = new ServiceProspect();
      spRec = spMap.get(relId);
      
      if (spRec.site == null)
        spRec.site = new List<ServiceProspectSite>();

            spRec.site.add(lclSps);
            spMap.put(relId, spRec); // replace entry for this id with new one that includes this site
    }
  }

  retProspList.prospects = spMap.values();

    // Update the Message_complete__c field to 'IP'.
  List <Prospect_Message__c> lclProspMsgList = [select Message_Complete__c 
                                                  from prospect_message__c 
                                                  where id in :prosMsgs];            

  for(Prospect_Message__c lclMsg : lclProspMsgList) {
    lclMsg.Message_Complete__c = 'IP';   
  }

    upsert(lclProspMsgList);
  
  return retProspList;
  }
}