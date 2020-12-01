public class CreateProspectCmpController {
    @AuraEnabled
    public static Map < String, Object > getProspectAndOpp() {
        Map < String, Object > objMap = new Map < String, Object > ();
        objMap.put('orgRec', new Org__c());
        objMap.put('contactRec', new Contact());
        return objMap;
    }

    @AuraEnabled
    public static Map < String, Object > onLoadData(String leadId) {
        Map < String, Object > onloadDataMap = new Map < String, Object > ();
        Lead leadRec = new Lead();
        User oUser = [SELECT Id, Name, TimeZoneSidKey, Username, Alias, Country, Email, FirstName, LastName, IsActive, IsPortalEnabled
            FROM User WHERE Id =: userInfo.getUserId()
        ];

        if (String.isNotBlank(leadId)) {
            leadRec = [SELECT Id, Name, FirstName, LastName, Email, RecordType.Name, Company, LeadSource, Lead_Page_Source__c,
                Current_Supplier__c, Account__c, Products__c, Business_Pro_Loyalty_Account_Number__c, RecordTypeId, OwnerId,
                IsConverted, address1__c, Address2__c, city__c, state__c, zip__c, Decision_Maker__c, Sales_Person_ID__c,
                Industry, Country__c, Product__c, Amount__c, Store__c, WCW_Count__c, Phone FROM Lead WHERE Id =: leadId
            ];
        }
        onloadDataMap.put('leadData', leadRec);
        onloadDataMap.put('userData', oUser);
        return onloadDataMap;
    }

    @AuraEnabled
    public static Map < String, Object > getAssignSpecificOwnerName(String AssignSpecOwnerName) {
        User oUser = [SELECT Id, Name, FirstName, LastName
            FROM User WHERE Id =: AssignSpecOwnerName
        ];
        Map < String, Object > AssignSpecOwnerNameMap = new Map < String, Object > ();
        AssignSpecOwnerNameMap.put('userData', oUser);
        return AssignSpecOwnerNameMap;


    }
    @AuraEnabled
    public static Map < String, List < String >> onloadAccPicklistVaues(String leadId) {
        Map < String, List < String >> accPiklistMap = new Map < String, List < String >> ();
        List < String > duplicateDispositionList = new List < String > ();
        List < String > accIndustryRepList = new List < String > ();

        Schema.DescribeFieldResult ddFieldResult = Schema.getGlobalDescribe().get('Account').getDescribe().fields.getMap().get('Duplicate_Disposition__c').getDescribe();
        List < Schema.PicklistEntry > ddple = ddFieldResult.getPicklistValues();
        for (Schema.PicklistEntry f: ddple) {
            duplicateDispositionList.add(f.getValue());
        }

        //Get Industry Rep Picklist values for GT when Lead avialable
        if (String.isNotBlank(leadId)) {
            Schema.DescribeFieldResult industryRepResult = Schema.getGlobalDescribe().get('Account').getDescribe().fields.getMap().get('Industry_OD_SIC_Rep__c').getDescribe();
            List < Schema.PicklistEntry > industryRep = industryRepResult.getPicklistValues();
            for (Schema.PicklistEntry f: industryRep) {
                accIndustryRepList.add(f.getValue());
            }
            accPiklistMap.put('industryRepList', accIndustryRepList);
        }

        accPiklistMap.put('duplicateDispositionList', duplicateDispositionList);
        return accPiklistMap;
    }

    @AuraEnabled
    public static List < String > getAccVericalPickValues(String pObjName, String pControllingFieldName, String pDependentFieldName, String ctrlPicklistVal) {
        return InputDependantSelectController.getDependentValForCtrlPickVal(pObjName, pControllingFieldName, pDependentFieldName, ctrlPicklistVal);
    }

    @AuraEnabled
    public static Map < String, String > setCtAndOppRT(String accRecordType) {
        return getRecordTypeNamesAndIds(accRecordType);
    }
    
    @AuraEnabled
    public static Map < String, String > getRecordTypeNamesAndIds(String accRecordType) {
        String accRecTypeName = Schema.SObjectType.Account.getRecordTypeInfosById().get(accRecordType).getname();
        String contactRTId;
        String ctRTName;
       

        if (accRecTypeName == 'Prospect (BizBox)') {
            contactRTId = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('Contact(BizBox)').getRecordTypeId();
            ctRTName = 'Contact(BizBox)';
            

        } else if (accRecTypeName == 'Prospect (Tech-Zone)') {
            contactRTId = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('Contact (Tech-Zone)').getRecordTypeId();
            ctRTName = 'Contact (Tech-Zone)';
           
        } else if (accRecTypeName == 'Prospect (GT)') {
            contactRTId = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('GT Contact').getRecordTypeId();
            ctRTName = 'GT Contact';
           
        } else if (accRecTypeName == 'Prospect') {
            contactRTId = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('Contact(US)').getRecordTypeId();
            ctRTName = 'Contact(US)';
           
        } else if (accRecTypeName == 'Customer (Business Pro)') {
            contactRTId = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('Contact (Business Pro)').getRecordTypeId();
            ctRTName = 'Contact (Business Pro)';
            
        }

        Map < String, String > recorsTypeMap = new Map < String, String > ();
        recorsTypeMap.put('contactRecordTypeId', contactRTId);
        recorsTypeMap.put('contactRecordTypeName', ctRTName);
        recorsTypeMap.put('accRecTypeName', accRecTypeName);
        System.debug('recorsTypeMap....' + recorsTypeMap);
        return recorsTypeMap;
    }

    @AuraEnabled
    public static Map < String, Object > populateparentaccount(String PricingTemplate, String prospectData) {
        System.debug('in apex!!!!!!!!!!---');
        String RelPricingTempAcc;
        String RelParentAcc;
        Map < String, Object > AccMap = new Map < String, Object > ();
        Account currentProspect = (Account) JSON.deserialize(prospectData, Account.class);
        if (PricingTemplate != null) {
            list < Pricing_Template__c > PTList = [SELECT Name, Parent_Id__c FROM Pricing_Template__c WHERE Name =: PricingTemplate];
            if (!PTList.isEmpty() && PTList[0].Parent_Id__c != null) {
                String removezeros = PTList[0].Parent_Id__c.replaceFirst('^0+', '');
                System.debug('The String is' + removezeros);
                list < Account > accs = [SELECT Id, name, Hierarchy__c, AOPS_Cust_Id__c, grandParent__c FROM Account WHERE AOPS_Cust_Id__c =: removezeros];

                if (!accs.isEmpty()) {
                    List < Account > parentforGP = [SELECT Id FROM Account WHERE Parent.Parentid =: accs[0].Id];
                    if (parentforGP.size() > 0 && accs[0].GrandParent__c == 'Yes') {
                        //recordCatergory = 'GP';
                        currentProspect.Related_Pricing_Template_Account__c = null;
                        currentProspect.Related_Parent_Account__c = null;
                    } else {
                        //recordCatergory = 'P';
                        currentProspect.Related_Pricing_Template_Account__c = accs[0].Id;
                        currentProspect.Related_Parent_Account__c = accs[0].AOPS_Cust_Id__c;
                    }
                }
                // pricingTempNotMatching = false;
            } else {
                if (PTList.isEmpty()) {
                    //customerid=true;
                    //pricingTempNotMatching = true;
                    currentProspect.Related_Pricing_Template_Account__c = null;
                    currentProspect.Related_Parent_Account__c = null;
                } else {
                    //customerid=false;
                    //recordCatergory = 'No Account';
                    currentProspect.Related_Pricing_Template_Account__c = null;
                    currentProspect.Related_Parent_Account__c = null;
                    //pricingTempNotMatching = false;
                }
            }
        } else {
            //pricingTempNotMatching = false;
            currentProspect.Related_Pricing_Template_Account__c = null;
            currentProspect.Related_Parent_Account__c = null;
        }
        AccMap.put('accData', currentProspect);
        return AccMap;
    }


    @AuraEnabled
    public static Map < String, Object > saveProspect(String prospectData, String contactData, String parentOrgData,
        String newOrFamiliyOrgRecData, String decisionMaking, String parentOrgSFId,
         String leadId, String leadData) {

        Map < String, Object > MyMap = new Map < String, Object > ();
        //Lead Convert Process
        Lead lead = new Lead();
        Database.LeadConvert leadConvert;

        if (String.isNotBlank(leadId)) {
            lead = (Lead) JSON.deserialize(leadData, Lead.class);
            leadConvert = getLeadConvert(lead);
        }

        List < Org__c > parentOrgDataList = new List < Org__c > ();
        Org__c newOrFamiliyOrgRec;
        System.debug('prospectData......Save.............' + prospectData);
        Account currentProspect = (Account) JSON.deserialize(prospectData, Account.class);
        //Get Record Type Names AND Id
        Map < String, String > recTypeMap = getRecordTypeNamesAndIds(currentProspect.RecordtypeId);
        Id SiteId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Site').getRecordTypeId();
        if (parentOrgData != 'null') {
            parentOrgDataList = (List < Org__c > ) JSON.deserialize(parentOrgData, List < Org__c > .class);
            //System.debug('======parentOrgDataList=======' + parentOrgDataList[0]);
        }
        // By Anand 
        if (!parentOrgDataList.isEmpty()) {
            newOrFamiliyOrgRec = parentOrgDataList[0];
            System.debug('====if 202=========');

            if (String.isEmpty(newOrFamiliyOrgRec.Id)) {
                if (String.isNotEmpty(newOrFamiliyOrgRec.DUNS_Number__c)) {
                    //Check the DUNS_Number__c Exist or not in database, if it is exists prospect map to Org 
                    List < Org__c > ExistDunsNumber = [SELECT Id
                        FROM Org__c
                        WHERE DUNS_Number__c =: newOrFamiliyOrgRec.DUNS_Number__c
                        LIMIT 1
                    ];

                    if (!ExistDunsNumber.isEmpty())
                        newOrFamiliyOrgRec.Id = ExistDunsNumber[0].Id;
                    System.debug('====else 219=========' + newOrFamiliyOrgRec.Id);
                    //check the DUNS_Number__c  is 9 digit format or not 
                    Integer DunsNumberformatSize = newOrFamiliyOrgRec.DUNS_Number__c.length();


                    System.debug('=====DunsNumberformatSize=====' + DunsNumberformatSize);
                    if (DunsNumberformatSize < 9) {
                        String Duns = '0';
                        for (integer i = 1; i < 9 - DunsNumberformatSize; i++)
                            Duns = Duns + '0';

                        newOrFamiliyOrgRec.DUNS_Number__c = Duns + newOrFamiliyOrgRec.DUNS_Number__c;
                    }

                }

                //check the D_B_ID__c  is 9 digit format or not 
                if (String.isNotEmpty(newOrFamiliyOrgRec.D_B_ID__c)) {
                    Integer DBIdformatSize = newOrFamiliyOrgRec.D_B_ID__c.length();

                    if (DBIdformatSize < 9) {
                        String DBid = '0';
                        for (integer i = 1; i < 9 - DBIdformatSize; i++)
                            DBid = DBid + '0';

                        newOrFamiliyOrgRec.D_B_ID__c = DBid + newOrFamiliyOrgRec.D_B_ID__c;
                    }

                }
            }
        } else {
            System.debug('====else 202=========');
            newOrFamiliyOrgRec = (Org__c) JSON.deserialize(newOrFamiliyOrgRecData, Org__c.class);


        }


        System.debug('contactData....' + contactData);
        System.debug('currentProspect....' + currentProspect);
        Contact contactRec = new Contact();
        contactRec.Primary_Contact__c = true;
        String accRecTypeName = Schema.SObjectType.Account.getRecordTypeInfosById().get(currentProspect.RecordtypeId).getname();
        if (!contactData.equals('{}')) {
            contactRec = (Contact) JSON.deserialize(contactData, Contact.class);
            //contactRec.AccountId = currentProspect.Id; 
            if (recTypeMap.containsKey('contactRecordTypeId')) {
                contactRec.RecordTypeId = recTypeMap.get('contactRecordTypeId');
            }
            if (String.isNotBlank(leadId)) {
                contactRec.OwnerId = lead.OwnerId;
                contactRec.mailingstreet = lead.address1__c;
                contactRec.mailingcity = lead.city__c;
                contactRec.mailingstate = lead.state__c;
                contactRec.mailingpostalcode = lead.zip__c;
                contactRec.Decision_Maker__c = lead.Decision_Maker__c;
                contactRec.Phone = lead.Phone;
                contactRec.Primary_Contact__c = true;
            } else {
                contactRec.mailingstreet = currentProspect.address1__c;
                contactRec.mailingcity = currentProspect.city__c;
                contactRec.mailingstate = currentProspect.state__c;
                contactRec.MailingCountry = currentProspect.Country__c;
                contactRec.mailingpostalcode = currentProspect.zip__c;
                contactRec.Primary_Contact__c = true;
            }
        }

        Account newSite = new Account();
        newSite.name = currentProspect.name;
        newSite.Phone = currentProspect.Phone;
        newSite.recordtypeId = SiteId;
        if (String.isNotBlank(leadId)) {
            newSite.OwnerId = lead.OwnerId;
            newSite.Sales_PersonID__c = lead.Sales_Person_ID__c;
            newSite.Status__c = 'Active';
            newSite.Primary_Site__c = true;
            newSite.Industry_OD_SIC_Rep__c = lead.Industry;
            newSite.address1__C = lead.address1__C;
            newSite.Address2__c = lead.Address2__c;
            newSite.city__c = lead.city__C;
            newSite.state__c = lead.state__C;
            newSite.zip__c = lead.zip__c;
            newSite.Country__c = lead.Country__c;
            newSite.Org_WCW_Count_Rep__c = lead.WCW_Count__c;
        } else {
            newSite.address1__C = currentProspect.address1__C;
            newSite.Address2__c = currentProspect.Address2__c;
            newSite.city__c = currentProspect.city__C;
            newSite.state__c = currentProspect.state__C;
            newSite.zip__c = currentProspect.zip__c;
            newSite.Country__c = currentProspect.Country__c;
            newSite.Industry_OD_SIC_Rep__c = currentProspect.Industry_OD_SIC_Rep__c;
            newSite.Primary_Site__c = true;
            newSite.Status__c = 'Active';
            newSite.Sales_PersonID__c = currentProspect.Sales_PersonID__c;
        }

        //Opportunity Information
        
        //Ends here
        Savepoint sp;
        try {
            sp = Database.setSavepoint(); // set save point
            System.debug('newOrFamiliyOrgRec----' + newOrFamiliyOrgRec);
            if (newOrFamiliyOrgRec != null) {
                if (String.isEmpty(newOrFamiliyOrgRec.Id)) {
                    newOrFamiliyOrgRec.IsCustomerExist__c = true;
                    Insert newOrFamiliyOrgRec;

                }
                else 
                {
                    if(!newOrFamiliyOrgRec.IsCustomerExist__c)
                    {
                        newOrFamiliyOrgRec.IsCustomerExist__c = true;
                        update newOrFamiliyOrgRec;
                    }
                    
                }

                currentProspect.org__C = newOrFamiliyOrgRec.Id;
                if (newOrFamiliyOrgRec.DUNS_Number__c != null && newOrFamiliyOrgRec.DUNS_Number__c.trim() != '' )
                {
                    currentProspect.Duns_Enrichment__c = newOrFamiliyOrgRec.DUNS_Number__c;
                    currentProspect.DNBI_MatchScore__c = 10;
                }
            }
            User current_user = [SELECT Id, profile.Name FROM User WHERE Id =: Userinfo.getuserid()];
            Id specowner = currentProspect.Assign_Specific_Owner__c;

            Id specSalesRep;
            if (currentProspect.Auto_Assign__c) {

                currentProspect.OwnerId = Label.Dataloader_Id_Trigger;
                List < Sales_Person__c > salesPersonList1 = new List < Sales_Person__c > ();
                salesPersonList1 = [SELECT Id, name, user__r.name FROM Sales_Person__c WHERE user__r.Id =: currentProspect.OwnerId AND Primary__c = true AND IsActive__c = true ORDER BY lastmodifieddate desc limit 1];

                if (!salesPersonList1.isEmpty()) {

                    currentProspect.Sales_PersonID__c = salesPersonList1[0].Id;
                }
            } else if (currentProspect.Assign_Specific_Owner__c != null) {
                currentProspect.OwnerId = currentProspect.Assign_Specific_Owner__c;
                List < Sales_Person__c > salesPersonList = new List < Sales_Person__c > ();
                salesPersonList = [SELECT Id, name, user__r.name FROM Sales_Person__c WHERE user__r.Id =: specowner AND Primary__c = true AND IsActive__c = true ORDER BY lastmodifieddate desc limit 1];
                if (!salesPersonList.isEmpty()) {
                    currentProspect.Sales_PersonID__c = salesPersonList[0].Id;
                    specSalesRep = salesPersonList[0].Id;
                }
            }

            currentProspect.Products__c = lead.Products__c;
            String owId = currentProspect.OwnerId;
            if (!String.isNotBlank(owId)) {
                currentProspect.OwnerId = current_user.Id;
            }
            //if(currentProspect.Assign_Specific_Owner__c != null  && specSalesRep==null){
            if (String.isNotBlank(specowner) && !String.isNotBlank(specSalesRep)) {
                Database.rollback(sp); // roll back , it will roll back all DML that 
                MyMap.put('Status', 'No Sales Rep Id for Assigned User');
                MyMap.put('StatusCode', -1);

            } else {
                System.debug('currentProspect.OwnerId--####-' + currentProspect.OwnerId);
                Insert currentProspect;
                if (currentProspect.Id != null) {
                    contactRec.AccountId = currentProspect.Id;
                    //if(parentOrgSFId != null || parentOrgSFId != ''){
                    if (String.isNotBlank(parentOrgSFId)) {
                        newSite.org__C = parentOrgSFId;
                    } else {
                        //if (newOrFamiliyOrgRec.Id != null) {
                            //newSite.Org__c = newOrFamiliyOrgRec.Id;
                        //}
                    }
                    newSite.Related_Account__c = currentProspect.Id;
                    contactRec.Primary_Contact__c = true;
                    ///Added by Ramalakshmi
                    contactRec.mailingstreet = currentProspect.address1__c;
                    contactRec.mailingcity = currentProspect.city__c;
                    contactRec.mailingstate = currentProspect.state__c;
                    contactRec.MailingCountry = currentProspect.Country__c;
                    contactRec.mailingpostalcode = currentProspect.zip__c;
                    if (currentProspect.Assign_Specific_Owner__c != null) {
                        contactRec.OwnerId = currentProspect.Assign_Specific_Owner__c;
                    }
                    if (currentProspect.Auto_Assign__c) {
                        contactRec.OwnerId = currentProspect.OwnerId;
                    }
                    String CnId = contactRec.OwnerId;
                    if (!String.isNotBlank(CnId)) {
                        contactRec.OwnerId = current_user.Id;
                    }
                    Insert contactRec;

                    contact test = [SELECT Primary_Contact__c FROM contact WHERE Id =: contactRec.Id];
                    System.debug('&&&&&&&&&&&&&&val' + test.Primary_Contact__c);



                    if (accRecTypeName != 'Customer (Business Pro)') {
                        newSite.Site_Primary_Contact__c = contactRec.Id;
                    }
                    ///////Added by Raji
                    newSite.address1__C = currentProspect.address1__C;
                    newSite.Address2__c = currentProspect.Address2__c;
                    newSite.city__c = currentProspect.city__C;
                    newSite.state__c = currentProspect.state__C;
                    newSite.zip__c = currentProspect.zip__c;
                    newSite.Country__c = currentProspect.Country__c;
                    newSite.Industry_OD_SIC_Rep__c = currentProspect.Industry_OD_SIC_Rep__c;
                    newSite.Primary_Site__c = true;
                    newSite.Status__c = 'Active';
                    newSite.Sales_PersonID__c = currentProspect.Sales_PersonID__c;
                    newSite.IsProspectLightning__C = true;
                    if (currentProspect.Assign_Specific_Owner__c != null) {
                        newSite.OwnerId = currentProspect.Assign_Specific_Owner__c;
                    }
                    if (currentProspect.Auto_Assign__c) {
                        newSite.OwnerId = currentProspect.OwnerId;
                    }
                }
                String SiteOwId = newSite.OwnerId;
                if (!String.isNotBlank(SiteOwId)) {
                    newSite.OwnerId = current_user.Id;
                }
                Insert newSite;
                

                if (leadConvert != null) {
                    leadConvert.setAccountId(currentProspect.Id);
                    leadConvert.setContactId(contactRec.Id);
                    leadConvert.setDoNotCreateOpportunity(true);
                    

                    Database.LeadConvertResult leadConvertResult = Database.ConvertLead(leadConvert);
                    MyMap.put('Id', currentProspect.Id);
                }
                MyMap.put('Id', currentProspect.Id);
            }
        } catch (Exception e) {
            Database.rollback(sp); // roll back , it will roll back all DML that 
            MyMap.put('Status', e.getMessage());
            MyMap.put('StatusCode', -1);
            System.debug('ee****' + e.getStackTraceString());
            System.debug('ee**' + e.getMessage());
        }

        //return currentProspect.Id;
        System.debug('MyMap........' + MyMap);
        return MyMap;
    }

    //Lead Convert
    @TestVisible
    private static Database.LeadConvert getLeadConvert(Lead lead) {
        Database.LeadConvert leadConvert = new Database.LeadConvert();
        leadConvert.setLeadId(lead.Id);

        List < LeadStatus > lstLeadStatus = [SELECT Id, MasterLabel FROM LeadStatus WHERE IsConverted = true];
        if (lstLeadStatus.size() > 0) {
            leadConvert.setConvertedStatus(lstLeadStatus[0].MasterLabel);
        }
        return leadConvert;

    }

}