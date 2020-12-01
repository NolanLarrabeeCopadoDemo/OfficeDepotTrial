/**************************************************************************
* Created By :
* Created Date :
* Purpose :
   SOA calls this class via web service call to get prospects for insert or update
   into E-Business Suite.

   Last Modified       : 05/19/2012
   Last Modified By    : Phil Price
   Last Modified Reason: Add Oracle party_id to party_site_id to message.


**************************************************************************/

global class ProspectServicewithID {

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

    webservice static SalesCustomerProspectCreation GetSubmittedProspects(String prospectId) {

        System.debug('&&&&&&&&&&&&&prospectId'+prospectId);
        SalesCustomerProspectCreation retProspList = new SalesCustomerProspectCreation();

/// 12-02-2019   02252364 Modifying code to Incude parent account recordtype
        RecordType recType = [SELECT id FROM recordtype WHERE name = 'Prospect'];
        RecordType recTypeParent = [SELECT id FROM recordtype WHERE name = 'Parent'];

        RecordType recType1 = [SELECT id FROM recordtype WHERE name = 'Customer (OfficeMax)'];
        RecordType recTypeomxs = [SELECT id FROM recordtype WHERE name = 'Site (OfficeMax)'];
        ID custrectype = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Customer').getRecordTypeId();

        List<Prospect_Message__c> prosMsgs =
        [SELECT id,
         account__c FROM prospect_message__c WHERE (message_complete__c = 'NP' or message_complete__c = 'IP' ) and id =
             :prospectId];
        List<Account> acctsUptd = new List<Account>();
        List<Id> acctsToProc = new List<Id>();
        List<Id> userids = new List<Id>();
        Map<Id, ServiceProspect> spMap = new Map<Id, ServiceProspect>();
        Map<ID,String> ownertoRelate = new Map<ID,String> ();
        Map<ID,String> usertoRelate = new Map<ID,String> ();
        Map<String,String> repIdtoRelate = new Map<String,String> ();
        Map<String,String>  oRepIdtoRelate  = new Map<String,String> ();
        Map<String,String>  HoverideMap  = new Map<String,String> ();
        Map<String,Id>  RepIdtoUserId  = new Map<String,Id> ();
        Map<String,String> roleRelatetoSPID = new Map<String,String>();
        Set<ID> ownerIDs = new Set<ID>();
        Set<String> oRepIDs = new Set<String>();
        Set<String> hRepIDs = new Set<String>();

        For (Sales_Person__c s:[SELECT Role_Relate_Id__c,ExtIDSalesPerson__c FROM Sales_Person__c WHERE isactive__c=true])
        roleRelatetoSPID.put(s.Role_Relate_Id__c,s.ExtIDSalesPerson__c);

        for(Prospect_Message__c lclPm : prosMsgs)
            acctsToProc.add(lclPm.account__c);

        /// 12-02-2019   02252364 Modifying code to Incude parent account recordtype
        Map<Id, Account> prospectAccounts = new Map<Id,Account>(
            [SELECT Duns_Number__c, Industry_OD_SIC_DB__c, Name, Org_WCW_Count_Rep__c, cust_id__C,
             Id, Status__c, Org_WCW_Count_DB__c, Segment_code__c, sales_personid__r.name,Sales_PersonID__r.role_relate_id__c,
             Oracle_Party_ID__c,ownerid,OMX_Primary_Key__c,recordtype.name,OMX_Mainframe_Owning_Rep_Number__c
             FROM account
             WHERE (recordtypeid = : recType.id OR recordtypeid = : recTypeParent.id OR recordtypeid =
                        : recType1.id OR recordtypeid =: custrectype)
             and id in: acctsToProc]);
        System.debug('ProspectServicewithID'+prospectAccounts);
        ID aid;
        for(Account a : prospectAccounts.values()) {

            ownerIDs.add(a.ownerid);
            aid =a.id;
            oRepIDs.add(a.OMX_Mainframe_Owning_Rep_Number__c);
            Account acupdt = new Account(Id =a.id,OMXIsUpdated__c=false);
            acctsUptd.add(acupdt);

        }
        Integer reqsize= 10;
        try
        {
            Map<String, Keyvalue_Map_CS__c> keyValueMap = Keyvalue_Map_CS__c.getAll();
            reqsize= Integer.valueOf(keyValueMap.get('reqsize').Data_Value__c);
        }
        catch(Exception e)
        {
            System.debug('&&&&&&&&&&&&&Inside Catch');
            reqsize= 10;
            // do nothing
        }

        System.debug('&&&&&&&&&&&&&reqsize'+reqsize);

/// 12-02-2019   02252364 Modifying code to Incude parent account recordtype
        Map<Id, Account> prospectSiteAccounts = new Map<Id, Account>(
            [SELECT split_record__C, related_account__c, Name, Org_WCW_Count_Rep__c, Id, cust_id__C,status__c,
             sales_personid__r.name,Sales_PersonID__r.role_relate_id__c,
             address1__c, address2__c, city__c, country__c, state__c, zip__c, Oracle_Party_Site_Id__c,ownerid,OMX_Primary_Key__c,
             recordtype.name,recordtypeid,OMX_Mainframe_Owning_Rep_Number__c
             FROM account
             WHERE related_account__r.id in: prospectAccounts.keySet() and (OMXIsUpdated__c=
                                                                                true or related_account__r.recordtypeid = :recType.id or related_account__r.recordtypeid = :recTypeParent.id ) LIMIT :reqsize]);
        List<Prospect_Message__c> insertProsMess= new List<Prospect_Message__c>();
        
        
        if(prospectSiteAccounts.size() == reqsize)
        {
            for(Id my_site_id: prospectSiteAccounts.keySet()){
            	Prospect_Message__c myMessage = new Prospect_Message__c();
            	myMessage.Work_Indicator__c = 'Get Stuff';
            	myMessage.Account__c = my_site_id;
            	myMessage.message_complete__c ='AP';
            	insertProsMess.add(myMessage);
            }
            if(insertProsMess.size()>0)
            	insert insertProsMess;
        }
        


        for (account a:prospectSiteAccounts.values())
        {
            ownerIDs.add(a.ownerid);
            oRepIDs.add(a.OMX_Mainframe_Owning_Rep_Number__c);
            Account acupdt = new Account(Id =a.id,OMXIsUpdated__c=false);
            acctsUptd.add(acupdt);

        }
        for (XREFHSE__c h: [SELECT ODNID__c,ODS_ID__c FROM XREFHSE__c])
        {
            hRepIDs.add(h.ODS_ID__c);
            HoverideMap.put(h.ODNID__c,h.ODS_ID__c);
        }
        for (sales_person__c s:
             [SELECT user__c,Role_Relate_Id__c,
              ExtIDSalesPerson__c FROM sales_person__c WHERE ExtIDSalesPerson__c in :hRepIDs and isactive__c=true] )
            for (String omxid: HoverideMap.keySet()) {
                if(HoverideMap.get(omxid)  == s.ExtIDSalesPerson__c)
                {
                    system.debug('inside ' +omxid +' ' +s.Role_Relate_Id__c );
                    oRepIdtoRelate.put(omxid,s.Role_Relate_Id__c);
                }
            }

        for (sales_person__c s:
             [SELECT user__c,
              Role_Relate_Id__c FROM sales_person__c WHERE user__c in :ownerIDs and isactive__c=true and Primary__c=true])
            ownertoRelate.put(s.user__c,s.Role_Relate_Id__c);

        for (sales_person__c s:
             [SELECT user__c,Role_Relate_Id__c,
              OMX_Override_Rep_ID__c FROM sales_person__c WHERE OMX_Override_Rep_ID__c in :oRepIDs and isactive__c=true] )
            oRepIdtoRelate.put(s.OMX_Override_Rep_ID__c,s.Role_Relate_Id__c);

        for (sales_person__c s:
             [SELECT user__c,Role_Relate_Id__c,
              OMX_Rep_ID__c FROM sales_person__c WHERE OMX_Rep_ID__c in :oRepIDs and isactive__c=true] )
        {
            RepIdtoUserId.put(s.OMX_Rep_ID__c,s.user__c);
            userids.add(s.user__c);
        }

        for (sales_person__c s:
             [SELECT user__c,
              Role_Relate_Id__c FROM sales_person__c WHERE user__c in :userids and isactive__c=true and Primary__c=true])
            usertoRelate.put(s.user__c,s.Role_Relate_Id__c);


        for(String key:RepIdtoUserId.keySet())
        {
            repIdtoRelate.put(key, usertoRelate.get(RepIdtoUserId.get(key)));


        }

        System.debug('&&&&&&&&&&&&&before loop');

        for (Account lclAcct : prospectAccounts.values() ) {
            System.debug('Inside header for loop');
            ServiceProspect sp      = new ServiceProspect();
            sp.Duns_Number          = lclAcct.Duns_Number__c;
            sp.Industry             = lclAcct.Industry_OD_SIC_DB__c;
            sp.Organization_Name    = lclAcct.Name;
            //sp.Rep                  = lclAcct.Sales_PersonID__r.role_relate_id__c;
            if (oRepIdtoRelate.containskey(lclAcct.OMX_Mainframe_Owning_Rep_Number__c))
                sp.Rep = oRepIdtoRelate.get(lclAcct.OMX_Mainframe_Owning_Rep_Number__c);
            else
            if (repIdtoRelate.containskey(lclAcct.OMX_Mainframe_Owning_Rep_Number__c))
                sp.Rep = repIdtoRelate.get(lclAcct.OMX_Mainframe_Owning_Rep_Number__c);
            else
            if (ownertoRelate.containskey(lclAcct.ownerid))
                sp.Rep = ownertoRelate.get(lclAcct.ownerid);
            else
                sp.Rep                  = lclAcct.Sales_PersonID__r.role_relate_id__c;

            if (roleRelatetoSPID.containskey(sp.Rep))
                sp.Rep = roleRelatetoSPID.get(sp.Rep);

            if(lclAcct.recordtype.name=='Customer (OfficeMax)')
                sp.Organization_SFDC_Id= lclAcct.OMX_Primary_Key__c+ '-' + 'OMX'; //not cust_id__C
            else
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
                if (oRepIdtoRelate.containskey(lclSite.OMX_Mainframe_Owning_Rep_Number__c) &&
                    lclSite.recordtypeid == recTypeomxs.id  )
                    lclSps.Rep = oRepIdtoRelate.get(lclSite.OMX_Mainframe_Owning_Rep_Number__c );
                else
                if (repIdtoRelate.containskey(lclSite.OMX_Mainframe_Owning_Rep_Number__c) &&
                    lclSite.recordtypeid == recTypeomxs.id )
                    lclSps.Rep = repIdtoRelate.get(lclSite.OMX_Mainframe_Owning_Rep_Number__c);
                else
                if (ownertoRelate.containskey(lclSite.ownerid))
                    lclSps.Rep = ownertoRelate.get(lclSite.ownerid);
                else
                    lclSps.Rep                  = lclSite.Sales_PersonID__r.role_relate_id__c;
                    lclSps.Address_Line1        = lclSite.Address1__c;
                    lclSps.Address_Line2        = lclSite.Address2__c;
                    lclSps.City                 = lclSite.City__c;
                    lclSps.Country              = lclSite.Country__c;

                if (lclSite.recordtype.name=='Site (OfficeMax)') {
                    if(lclSite.split_record__C==true) {
                        lclSps.Party_Site_SFDC_Id = lclSite.OMX_Primary_Key__c;
                    }
                    else
                        lclSps.Party_Site_SFDC_Id = lclSite.OMX_Primary_Key__c+ '-' + 'OMX'; //cust_id__C
                }
                else {
                    lclSps.Party_Site_SFDC_Id   = lclSite.id;
                }

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
        List <Prospect_Message__c> lclProspMsgList = [SELECT Message_Complete__c
                                                      FROM prospect_message__c
                                                      WHERE id in :prosMsgs];

        for(Prospect_Message__c lclMsg : lclProspMsgList) {
            lclMsg.Message_Complete__c = 'IP';
        }

        try{
            upsert(lclProspMsgList);
        }
        catch(Exception e) {}
        try{
            System.debug('&&&&&&&&&&&&&&&&&&&&&&acctsUptd'+acctsUptd);
            update(acctsUptd);
        }
        catch(Exception e)
        {}

        return retProspList;
    }
}