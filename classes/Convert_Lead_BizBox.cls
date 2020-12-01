/**
* @author Adam Albright, adam.albright@officedepot.com
* @date 3/2/2018
*
* @group Lead Conversion
* @group-content /ApexDocContent/Index.htm
*
* @description This Class Converts a Lead with a RecordType of 'Lead (BizBox)'. If a Lead with an incorrect
* RecordType is passed, an exception is thrown.
*
*/

public class Convert_Lead_BizBox {



    private static Boolean Tasks = false;
    private static Boolean Opportunities = true;
    private static Id AcceptedRecordType = Schema.SObjectType.Lead.getRecordTypeInfosByName().get('Lead (BizBox)').getRecordTypeId();

    /*******************************************************************************************************
    * @description Specifies whether or not to migrate tasks open after lead conversion.
    * Returns true if enabled.
    *
    public static Boolean MigrateTasks {
        get {return Tasks;}
        set {Tasks = value;}
    } */

    /*******************************************************************************************************
    * @description Specifies whether or not to generate opportunities after lead conversion.
    * returns true if enabled.
    */
    public static Boolean CreateOpportunities {
        get {return Opportunities;}
        set {Opportunities = value;}
    }

    /*******************************************************************************************************
    * @description The RecordTypeID this class will accept.
    * returns RecordTypeID for Biz Box Leads
    */
    public static Id AcceptedRecordTypeId {
        get {return AcceptedRecordType;}
    }

    // TODO: LeadConvertReady Check for required fields
    /*******************************************************************************************************
    * @description Creates the opportunities for a converted lead with a BizBox RecordType.
    * If the passed lead is not converted, an exception is thrown.
    * @param ConvertedLead The Lead used to generate opportunities.
    * @return void
    */

    //Convert Lead
    /*******************************************************************************************************
    * @description Converts the Lead and Generates the Opportunities. The OwnerId is retrieved from the Lead.
    * @param UnconvertedLead The lead we want to convert.
    * @return The RecordType Id this class will accept.
    */
    public static Map<String, sObject> ConvertLead(Lead UnconvertedLead){
        if(UnconvertedLead.IsConverted)
            throw new MyUtils_Lead.ConvertedLeadException('EXCEPTION,' + UnconvertedLead);

        // TODO: Convert Ready Check Here
        Map<String, sObject> UpdateMap = new Map<String, sObject>();
        List<sObject> UpdateList = new List<sObject>();
        List<sObject> InsertList = new List<sObject>();
        Boolean Converted = false;
        Id LeadId = UnconvertedLead.Id;
        Id OldOwnerId = UnconvertedLead.OwnerId;
        try{
            Converted = ConvertLeadAndGetResult(UnconvertedLead.Id);
        }catch(MyUtils_Lead.LeadConversionException e){
            System.debug(LoggingLevel.ERROR, 'Lead Conversion Failed.');
            throw new MyUtils_Lead.LeadConversionException(e.getMessage(), e);
        }
        Lead ConvertedLead;
        Account GeneratedAccount;
        Contact GeneratedContact;
        if(Converted){

            // TODO: Add the Missing Fields.
            ConvertedLead = [SELECT
                                Id,
                                OwnerId,
                                ConvertedContactId,
                                ConvertedAccountId,
                                Products__c,
                                Email,
                                IsConverted,
                                LeadSource,
                                Decision_Maker__c,
                                Amount__c,
                                Campaign_Source_URL__c,
                                WCW_Count__c,
                                Marketing_Opt_In__c,
                                Address1__c,
                                Address2__c,
                                City__c,
                                State__c,
                                Zip__c,
                                Country__c,
                                Comments__c,
                                Website FROM Lead WHERE Id=:LeadId LIMIT 1];

            GeneratedAccount = [SELECT
                                Id,
                                Name,
                                OwnerId,
                                RecordTypeId,
                                Loyatly_Number__c,
                                Campaign_Source_URL__c,
                                Org_WCW_Count_Rep__c,
                                Address1__c,
                                Address2__c,
                                City__c,
                                State__c,
                                Zip__c,
                                BizBox_Email__c,
                                Country__c, 
                                Status__c, 
                                Contact_Initiation_Type__c,
                                Website FROM Account WHERE Id=:ConvertedLead.ConvertedAccountId LIMIT 1];

            GeneratedContact = [SELECT
                                Id,
                                Name,
                                OwnerId,
                                RecordTypeId,
                                Decision_Maker__c,
                                BizBox_Marketing_OptIn__c,
                                MailingStreet,
                                MailingCity,
                                MailingState,
                                MailingPostalCode,
                                MailingCountry FROM Contact WHERE Id=:ConvertedLead.ConvertedContactId LIMIT 1];

            List<BizBox_Sales__c> MySales = new List<BizBox_Sales__c>();
            Boolean SalesFound = false;
            try{
                // Select the Sales that are associated with the lead and need to have the account updated.
                MySales = [SELECT
                            Id,
                            Name,
                            Potential_Lead__c,
                            Account__c FROM BizBox_Sales__c WHERE
                            Potential_Lead__c =: ConvertedLead.Id AND Account__c!=:ConvertedLead.ConvertedAccountId];
                if(MySales.size() > 0){
                    SalesFound = true;
                }
            } catch(QueryException e){
                System.debug(LoggingLevel.INFO, 'Query Exception: No sales records found. If this is expected, great.');
                System.debug(LoggingLevel.INFO, 'Called From Convert_Lead_BizBox.cls');
                System.debug(LoggingLevel.INFO, 'Exception Message:' + e.getMessage());
                System.debug(LoggingLevel.INFO, 'Line Number:' + e.getLineNumber());
            }

            if(SalesFound){
                for(BizBox_Sales__c sale: MySales){
                    sale.Account__c = ConvertedLead.ConvertedAccountId;
                }
                UpdateList.addAll(MySales);

            }

            // Account
            GeneratedAccount.Opportunity_Amt__c = ConvertedLead.Amount__c;
            GeneratedAccount.Contact_Initiation_Type__c = ConvertedLead.LeadSource;
            GeneratedAccount.OwnerId = OldOwnerId;
            GeneratedAccount.Address1__c = ConvertedLead.Address1__c;
            GeneratedAccount.Address2__c = ConvertedLead.Address2__c;
            GeneratedAccount.City__c = ConvertedLead.City__c;
            GeneratedAccount.State__c = ConvertedLead.State__c;
            GeneratedAccount.Zip__c = ConvertedLead.Zip__c;
            GeneratedAccount.Country__c = ConvertedLead.Country__c;
            GeneratedAccount.BizBox_Email__c = ConvertedLead.Email;
            GeneratedAccount.Status__c = 'Active';
            GeneratedAccount.Website = ConvertedLead.Website;

            GeneratedAccount.Org_WCW_Count_Rep__c = ConvertedLead.WCW_Count__c;
            if(SalesFound){
                GeneratedAccount.RecordTypeId = MyUtils_Account.BizBoxCustomerRecordTypeId;
            }else{
                GeneratedAccount.RecordTypeId = MyUtils_Account.BizBoxProspectRecordTypeId;
            }

            GeneratedAccount.Loyatly_Number__c = null;
            GeneratedAccount.Campaign_Source_URL__c = ConvertedLead.Campaign_Source_URL__c;

            // Contact
            GeneratedContact.Decision_Maker__c = ConvertedLead.Decision_Maker__c;
            GeneratedContact.OwnerId = OldOwnerId;
            GeneratedContact.RecordTypeId = MyUtils_Contact.BizBoxContactRecordTypeId;
            GeneratedContact.MailingStreet = ConvertedLead.Address1__c +', ' + ConvertedLead.Address2__c;
            GeneratedContact.MailingCity = ConvertedLead.City__c;
            GeneratedContact.MailingState = ConvertedLead.State__c;
            GeneratedContact.MailingPostalCode = ConvertedLead.Zip__c;
            GeneratedContact.MailingCountry = ConvertedLead.Country__c;


            Note myNote;
            if(ConvertedLead.Comments__c != null){
                myNote = new Note(
                        Title ='Lead Comment',
                        ParentId = GeneratedAccount.Id,
                        Body = ConvertedLead.Comments__c);

                 InsertList.add(myNote);
            }

            UpdateMap.put('Account', GeneratedAccount);
            UpdateMap.put('Contact', GeneratedContact);

            //InsertList.add(myNote);
            //UpdateList.put('Note', myNote);

            // Create Opportunities
            if(CreateOpportunities){
                List<Opportunity> MyOpportunities = GenerateOpportunities(ConvertedLead, ConvertedLead.Products__c, GeneratedAccount.Id);
                InsertList.addAll(MyOpportunities);
            }

            UpdateList.addAll(UpdateMap.values());
            update UpdateList;
            insert InsertList;

            //UpdateList.put('Note', myNote);

            return UpdateMap;
        }
        return null;
    }

    // TODO: Incorporate This, and make one for use with owner_ID's
    // Figure Out Better Error handling.Lead Conversion Failed.

    //Convert Lead
    /*******************************************************************************************************
    * @description Gets the RecordType Id this will accept for the conversion.
    * @param myLead the Id of the lead we want ot convert.
    * @param OwnerId the Id of the owner for the generated account and contact.
    * @return The RecordType Id this class will accept.
    */
    public static Boolean ConvertLeadAndGetResult(Id myLead, Id OwnerId){

        Database.LeadConvert lc = new Database.LeadConvert();
        lc.setDoNotCreateOpportunity(true);
        lc.setOwnerId(OwnerId);
        lc.setLeadId(myLead);
        LeadStatus convertStatus = [SELECT Id, MasterLabel FROM LeadStatus WHERE IsConverted=true LIMIT 1];
        lc.setConvertedStatus(convertStatus.MasterLabel);
        try{
            Database.LeadConvertResult lcr = Database.convertLead(lc);
            return lcr.isSuccess();
        }catch(DmlException e){
            System.debug('Message: ' + e.getMessage());
            System.debug('Cause: ' + e.getCause());
            System.debug('Line number: ' + e.getLineNumber());
            throw new MyUtils_Lead.LeadConversionException(e.getMessage(), e);
        }

        return false;
    }

    //Convert Lead
    /*******************************************************************************************************
    * @description Gets the RecordType Id this will accept for the conversion.
    * @param myLead the Id of the lead we want ot convert.
    * @return The RecordType Id this class will accept.
    */
    public static Boolean ConvertLeadAndGetResult(Id myLead){

        Database.LeadConvert lc = new Database.LeadConvert();
        lc.setDoNotCreateOpportunity(true);
        lc.setOwnerId(System.UserInfo.getUserId());
        lc.setLeadId(myLead);
        // Might need to switch the lead status.
        LeadStatus convertStatus = [SELECT Id, MasterLabel FROM LeadStatus WHERE IsConverted=true LIMIT 1];
        lc.setConvertedStatus(convertStatus.MasterLabel);
        try{
            Database.LeadConvertResult lcr = Database.convertLead(lc);
            return lcr.isSuccess();
        }catch(DmlException e){
            System.debug('Message: ' + e.getMessage());
            System.debug('Cause: ' + e.getCause());
            System.debug('Line number: ' + e.getLineNumber());
            throw new MyUtils_Lead.LeadConversionException('EXCEPTION,' + e.getMessage(), e);
        }

        return false;
    }

    //Generate Opportunities
    /*******************************************************************************************************
    * @description Generates the opportunities from the converted lead and assigns it to the generated account.
    * @param Products String with the Product__c List from the converted lead.
    * @return The List of Opportunity Objects created.
    */
    public static List<Opportunity> GenerateOpportunities(Lead ConvertedLead, String Products, Id ConvertedAccountId){
        if(!ConvertedLead.IsConverted)
            throw new MyUtils_Lead.NonConvertedLeadException('EXCEPTION,' + ConvertedLead);

        List<Opportunity> GeneratedOpportunities = new List<Opportunity>();
        List<String> ProductList = new List<String>();
        Map<String, String> MySelectOption = MyUtils.GetSelectOptionsMap(ConvertedLead, 'Products__c');
        if(Products == '' || Products == null)
            return GeneratedOpportunities;

        ProductList.addAll(Products.split(';'));

        for(String product: ProductList){
            System.debug(LoggingLevel.INFO, 'The Product is ' + product);
            System.debug(LoggingLevel.INFO, 'The Product name is ' + MySelectOption.get(product));
            Opportunity GeneratedOpportunity = GenerateOpportunity(ConvertedLead, product, MySelectOption.get(product),  ConvertedAccountId);
            if(GeneratedOpportunity != null)
                GeneratedOpportunities.add(GeneratedOpportunity);
        }

        return GeneratedOpportunities;
    }

    //Generate Opportunities
    /*******************************************************************************************************
    * @description Generates a BizBox opportunity from the passed Products string and assigns it to the passed account id.
    * @param Product String with the Product Value from the lead products.
    * @param ConvertedAccountId The Id of the generated Account.
    * @return The generated opportunity.
    */
    public static Opportunity GenerateOpportunity(Lead ConvertedLead, String Product, String ProductLabel, Id ConvertedAccountId){

        if(Product == '' || Product == null)
            return null;

        return new Opportunity(
                AccountId = ConvertedAccountId,
                OwnerId = ConvertedLead.OwnerId,
                Name = ProductLabel,
                Product__c = ProductLabel,
                LeadSource = ConvertedLead.LeadSource,
                RecordTypeId = MyUtils_Opportunity.BizBoxRecordTypeId,
                StageName = 'Qualify',
                CloseDate = (DateTime.now().addDays(30)).date());

    }


}