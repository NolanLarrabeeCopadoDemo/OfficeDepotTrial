trigger Pr_AProf_Creation on Prospect_Staging_Area__c (before insert, after insert) {
    if(Trigger.isbefore) {
        System.Debug('Pr_AProf_Creation - Is Before');
        List<Prospect_Staging_Area__c> eAc = [Select ID from Prospect_Staging_Area__c Where DUNS_Enrichment__c = :Trigger.New[0].DUNS_Enrichment__c LIMIT 1];

    iF (eAc.size() > 0) 
       	{
           	Trigger.New[0].addError('Duplicate DUNS Number found.');
            System.Debug('Duplicate DUNS Number found.');
       	}
    }

    if(Trigger.isafter) {
		System.Debug('Pr_AProf_Creation - Is After');
			User Usr = [Select ID from User where LastName = 'Dataloader' LIMIT 1];
                ID Usr_ID = Trigger.New[0].OwnerId;
                if (Trigger.New[0].Auto_Assign__c != TRUE ) 
                    {
                      IF (Trigger.New[0].User_Owner__c == NULL) 
                      	{
                          Usr_ID = Usr.Id;
                        } ELSE 
                        {
                          Usr_ID = Trigger.New[0].User_Owner__c;
                        }
                    } 
        system.debug('Before Insert -> Prospect Owner is set to: ' + Usr_ID);
        Id ProspectRecordTypeID = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Prospect').getRecordTypeId();
        Id SiteRecordTypeID = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Site').getRecordTypeId();
        id APid = Schema.SObjectType.Account_Profile__c.getRecordTypeInfosByName().get('HealthCare').getRecordTypeId();
       	String APName = 'Healthcare';
        
//Insert Prospect
            Account NA = New Account(
                Name = Trigger.New[0].Name,
                Auto_Assign__c = Trigger.New[0].Auto_Assign__c,
                OwnerID = Usr_ID,
                Sic = Trigger.New[0].SIC_Code__c,
                DNB_Year_Started__c = Trigger.New[0].DNB_Year_Started__c,
                DNB_Minority_Business__c = Trigger.New[0].Minority_Business_IND__c,
                Address1__c = Trigger.New[0].Address_1__c,
                Address2__c = Trigger.New[0].Address_2__c,
                Customer_Lifecycle__c = Trigger.New[0].Customer_Lifecycle__c,
                City__c = Trigger.New[0].City__c,
                State__c = Trigger.New[0].State__c,
                Status__c = 'Active',
                Zip__c = Trigger.New[0].Zip__c,
                AccountSource = Trigger.New[0].Source__c,
                Website = Trigger.New[0].URL__c,
                NumberOfEmployees = integer.valueof(Trigger.New[0].FTEs__c),
                Duns_Enrichment__c = Trigger.New[0].Duns_Enrichment__c,
				DNBI_Credit_Outcome__c = 'ByPass',
                Phone = Trigger.New[0].Phone__c,
                Org_WCW_Count_Rep__c = Trigger.New[0].WCW__c,
                RecordtypeID = ProspectRecordTypeID
                );

            Insert NA;
        
        system.debug(NA.id);   
        system.debug('Prospect Inserted Auto_Assign__c is set to: ' + NA.Auto_Assign__c);
        system.debug('Prospect Inserted Prospect Owner is set to: ' + NA.OwnerId);
//Insert Account Profile, and assign to the prospect
        IF(Trigger.New[0].Source__c == 'DNB Acquisition') 
        {
            APID =  Schema.SObjectType.Account_Profile__c.getRecordTypeInfosByName().get('Acquisition').getRecordTypeId();
            APName = 'Acquisition';
        }
        
            Account_Profile__c AP = New Account_Profile__c(
                    Account__c = NA.ID,
                    RecordTypeId = APID,
                    Name = APName,
                    Number_of_Beds__c = Trigger.New[0].Number_of_Beds__c,
                    GPO_Company__c = Trigger.New[0].GPO__c,
                    GPO_Relationship__c = Trigger.New[0].GPO_Relationship__c,
                    ACO__c = Trigger.New[0].ACO__c,
                    Parent_Company_Name__c = Trigger.New[0].Parent_Company_Name__c,
                	DNB_Propensity_Score__c = Trigger.New[0].DNB_Propensity_Score__c,
					DNB_Dollar_Amount__c = Trigger.New[0].DNB_Dollar_Amount__c,
                	DNB_Dollar_Deciles_Overall__c = Trigger.New[0].DNB_Dollar_Deciles_Overall__c,
                	DNB_Propensity_Segment__c = Trigger.New[0].DNB_Propensity_Segment__c
                    );
            Insert AP;
            system.debug(AP.id);    
        
List<Account> pOs = [Select OwnerId from Account Where ID = :NA.Id ];           
//Insert Primary Site, and assign to the prospect
    Account PSi = New Account(
            Name = Trigger.New[0].Name,
			Sic = Trigger.New[0].SIC_Code__c,
            OwnerID = pOs[0].OwnerID,
        	Auto_Assign__c = Trigger.New[0].Auto_Assign__c,
            Status__c = 'Active',
            Related_Account__c = NA.ID,
            Address1__c = Trigger.New[0].Address_1__c,
            Address2__c = Trigger.New[0].Address_2__c,
            City__c = Trigger.New[0].City__c,
            State__c = Trigger.New[0].State__c,
            Zip__c = Trigger.New[0].Zip__c,
            AccountSource = Trigger.New[0].Source__c,
            RecordtypeID = SiteRecordTypeID,
            Primary_Site__c = True,
            Org_WCW_Count_Rep__c = Trigger.New[0].WCW__c,
			DNBI_Credit_Outcome__c = 'ByPass',
        	Duns_Enrichment__c = Trigger.New[0].Duns_Enrichment__c
            );

    Insert PSi;
	System.Debug('Pr_AProf_Creation - Updating Records');
	System.debug('Site Owner is set to: ' + PSi.OwnerId);
    List<Prospect_Staging_Area__c> pS = [Select ID, Account_Profile_Instance__c, Prospect_Instance__c, Site_Instance__c from Prospect_Staging_Area__c Where ID = :Trigger.New[0].Id ];   
    List<Prospect_Staging_Area__c> upS = New List<Prospect_Staging_Area__c>();
//Update the Prospect Staging Area with the newly created Prospect ID and Account Profile ID
    For (Prospect_Staging_Area__c fPS: pS)
        {
                fPS.Account_Profile_Instance__c = AP.ID;
            	fps.Site_Instance__c = PSI.ID;
                fPS.Prospect_Instance__c = NA.Id;
                upS.Add(fPS);
        }
    Update upS;

    }
}