/*
 * Created By : Akash(Appirio Off)
 * Created Date : 11th Oct,2011
 * Purpose : Invoke all trigger logic for the Account object
 */

Trigger AccountTriggers on Account(before insert, before update, after insert, after update)
{
    //Account Service Production Fix
    Set<ID> resp = new Set<ID>();
    resp = Util.bizBoxRTIdsByObject('Account');

    if (Trigger.New != null)
    {
        for (Account newAccount : Trigger.new)
        {
            if (resp.contains(newAccount.RecordTypeId))
            {
                return;
            }
        }
    }

    Id grandParentRecordTypeId      = Schema.SObjectType.Account.getRecordTypeInfosByName().get('GrandParent').getRecordTypeId();
    Id greatGrandParentRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Great Grandparent').getRecordTypeId();
    Id custGTRecordTypeId           = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Customer (GT)').getRecordTypeId();
    Id siteGTRecordTypeId           = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Site (GT)').getRecordTypeId();
    Id prospectRecordTypeId         = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Prospect').getRecordTypeId();
    Id customerRecordTypeId         = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Customer').getRecordTypeId();
    Id siteRecordTypeId             = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Site').getRecordTypeId();
    Id salesPersonId                = Label.GT_Unassigned_SPID;
    Id dataloader                   = Label.Dataloader_Id_Trigger;
    Id unassigneduser               = Label.GT_Unassigned_Lbl;

    Map<ID, ID> accountOwnerMap                     = new Map<ID, ID>();
    Map<ID, ID> spOwnerMap                          = new Map<ID, ID>();
    List<GP_History__c> grandParentHistoryToUpdate  = new List<GP_History__c>();
    List<Decimal> grandParentIds                    = new List<Decimal>();
    List<Decimal> greatGrandParentIds               = new List<Decimal>();
    Decimal currentGrandParentId                    = 0;
    Decimal currentGreatGrandParentId               = 0;
    String currentUserId                            = UserInfo.getUserId().substring(0, 15);
    Boolean currentUserIsDL                         = false;

    if (Trigger.isBefore)
    {
        if (Trigger.isInsert)
        {
            for (Account newAccount : Trigger.new)
            {
                if (newAccount.RecordTypeId == grandParentRecordTypeId)
                {
                    for (Account grandParentAccount :   [SELECT AOPS_Cust_Id__c
                                                        FROM Account
                                                        WHERE RecordTypeId = :grandParentRecordTypeId])
                    {
                        if (grandParentAccount.AOPS_Cust_Id__c != NULL)
                        {
                            grandParentIds.add(Decimal.valueof(grandParentAccount.AOPS_Cust_Id__c));
                        }
                    }
                    if (grandParentIds.size() > 0)
                    {
                        grandParentIds.sort();
                        currentGrandParentId = grandParentIds[grandParentIds.size() - 1];
                    }
                }
                break;
            }

            for (Account newAccount : Trigger.new)
            {
                if (newAccount.RecordTypeId == grandParentRecordTypeId)
                {
                    currentGrandParentId        = currentGrandParentId + 1;
                    newAccount.gp_ID__c         = string.valueof(currentGrandParentId);
                    newAccount.AOPS_Cust_Id__c  = string.valueof(currentGrandParentId);
                }
            }

            for (Account newAccount : Trigger.new)
            {
                if (newAccount.RecordTypeId == greatGrandParentRecordTypeId)
                {
                    for (Account greatGrandParentAccount :  [SELECT AOPS_Cust_Id__c
                                                            FROM Account
                                                            WHERE RecordTypeId = :greatGrandParentRecordTypeId])
                    {
                        if (greatGrandParentAccount.AOPS_Cust_Id__c != NULL)
                        {
                            greatGrandParentIds.add(Decimal.valueof(greatGrandParentAccount.AOPS_Cust_Id__c));
                        }
                    }
                    if (greatGrandParentIds.size() > 0)
                    {
                        greatGrandParentIds.sort();
                        currentGreatGrandParentId = greatGrandParentIds[greatGrandParentIds.size() - 1];
                    }
                }
                break;
            }

            for (Account newAccount : Trigger.new)
            {
                if (newAccount.RecordTypeId == greatGrandParentRecordTypeId)
                {
                    currentGreatGrandParentId = currentGreatGrandParentId + 1;
                    newAccount.ggp_ID__c = string.valueof(currentGreatGrandParentId);
                    newAccount.AOPS_Cust_Id__c = string.valueof(currentGreatGrandParentId);
                }
            }

            for (Account newAccount : Trigger.new)
            {
                if (newAccount.RecordTypeId == grandParentRecordTypeId)
                {
                    if (Trigger.isInsert && newAccount.Sales_PersonID__c != null)
                    {
                        accountOwnerMap.put(newAccount.Id, newAccount.Sales_PersonID__c);
                    }
                    else if (Trigger.isUpdate)
                    {
                        if (newAccount.Sales_PersonID__c != Trigger.oldMap.get(newAccount.Id).Sales_PersonID__c)
                        {
                            accountOwnerMap.put(newAccount.Id, newAccount.Sales_PersonID__c);
                        }
                    }
                }
            }
        }
        if (accountOwnerMap.size() > 0)
        {
            for (Sales_Person__c s: [SELECT Id, User__c
                                    FROM Sales_Person__c
                                    WHERE Id = :accountOwnerMap.values() AND User__c != null])
            {
                spOwnerMap.put(s.Id, s.User__c);
            }

            for (Account newAccount : Trigger.new)
            {
                if (accountOwnerMap.containsKey(newAccount.Id))
                {
                    if (spOwnerMap.containsKey(accountOwnerMap.get(newAccount.Id)))
                    {
                        newAccount.ownerId = spOwnerMap.get(accountOwnerMap.get(newAccount.Id));
                    }
                }
            }
        }
    }

    if (Trigger.isAfter && Trigger.isUpdate)
    {
        for (Account newAccount : Trigger.new)
        {
            if ((newAccount.Status__c    != Trigger.oldMap.get(newAccount.Id).Status__c ||
                newAccount.Legal_Flag__c != Trigger.oldMap.get(newAccount.Id).Legal_Flag__c ||
                newAccount.OwnerId       != Trigger.oldMap.get(newAccount.Id).OwnerId ||
                newAccount.Name          != Trigger.oldMap.get(newAccount.Id).Name ||
                newAccount.Description   != Trigger.oldMap.get(newAccount.Id).Description ||
                newAccount.ParentId      != Trigger.oldMap.get(newAccount.Id).ParentId) &&
                (newAccount.RecordTypeId == grandParentRecordTypeId || newAccount.RecordTypeId == greatGrandParentRecordTypeId))
            {
                GP_History__c grandParentHistory    = new GP_History__c();
                grandParentHistory.Account__c       = newAccount.Id;
                grandParentHistory.Active_Flag__c   = newAccount.Status__c;

                if (newAccount.ParentId != Trigger.oldMap.get(newAccount.Id).ParentId)
                {
                    grandParentHistory.Change_Requestor__c = newAccount.Requestor_Id__c;
                }
                else
                {
                    grandParentHistory.Change_Requestor__c = newAccount.Implementation_Manager__c;
                }

                grandParentHistory.Legal_Flag__c            = newAccount.Legal_Flag__c;
                grandParentHistory.Owner__c                 = newAccount.OwnerId;
                grandParentHistory.Update_Date__c           = dateTime.now();
                grandParentHistory.User_Executing_Change__c = userInfo.getUserId();
                grandParentHistory.Name                     = newAccount.Name;
                grandParentHistory.Description__c           = newAccount.Description;
                grandParentHistory.Parent_Account__c        = Trigger.oldMap.get(newAccount.Id).ParentId;
                grandParentHistoryToUpdate.add(grandParentHistory);
            }
        }
    }

    if (Trigger.isAfter && Trigger.isInsert)
    {
        for (Account newAccount : Trigger.new)
        {
            if (newAccount.RecordTypeId == grandParentRecordTypeId || newAccount.RecordTypeId == greatGrandParentRecordTypeId)
            {
                GP_History__c grandParentHistory            = new GP_History__c();
                grandParentHistory.Account__c               = newAccount.Id;
                grandParentHistory.Active_Flag__c           = newAccount.Status__c;
                grandParentHistory.Change_Requestor__c      = newAccount.Implementation_Manager__c;
                grandParentHistory.Description__c           = newAccount.Description;
                grandParentHistory.Legal_Flag__c            = newAccount.Legal_Flag__c;
                grandParentHistory.Owner__c                 = newAccount.OwnerId;
                grandParentHistory.Update_Date__c           = dateTime.now();
                grandParentHistory.User_Executing_Change__c = userInfo.getUserId();
                grandParentHistory.Name                     = newAccount.Name;
                grandParentHistoryToUpdate.add(grandParentHistory);
            }
        }
    }
    
    if (Trigger.isAfter && (Trigger.isUpdate) && !executeoncetest.bypassAccountExtension)
    {
        executeoncetest.bypassAccountExtension = true;
        new AccountExtensionHelper().copyToExtension(Trigger.New);
    }

    if (Trigger.isAfter && (Trigger.isUpdate || Trigger.isInsert) && grandParentHistoryToUpdate.size() > 0 && executeoncetest.notTriggered_AccountTriggers_after)
    {
        insert grandParentHistoryToUpdate;
    }

    List<Dataloader_User__c> allDataloaderUsers = Dataloader_User__c.getall().values();
    for (Dataloader_User__c dataloaderUser : allDataloaderUsers)
    {
        if (currentUserId == dataloaderUser.User_ID__c)
        {
            currentUserIsDL = true;
        }
    }

    if (System.isFuture() || System.isBatch()) return;


    if (Trigger.isBefore && (Trigger.isInsert || Trigger.isUpdate))
    {
        for (Account newAccount : Trigger.new)
        {
            if ((newAccount.RecordTypeId == custGTRecordTypeId || newAccount.RecordTypeId == siteGTRecordTypeId) && (newAccount.OwnerId == dataloader))
            {
                newAccount.Sales_PersonID__c = salesPersonId;
                newAccount.ownerId = unassigneduser;
            }
        }
    }

    // Execute Trigger once for before AND once for after
    if (executeoncetest.notTriggered_AccountTriggers_before || executeoncetest.notTriggered_AccountTriggers_after || currentUserIsDL)
    {
        if (Trigger.isBefore)
        {
            executeoncetest.notTriggered_AccountTriggers_before = false;
        }
        else {
            executeoncetest.notTriggered_AccountTriggers_after = false;
        }

        if (Trigger.isAfter)
        {
            List<DNBI_Credentials__c> creds = DNBI_Credentials__c.getall().values();

            if (creds.size() > 0 && Trigger.isInsert)
            {
                for (Account newAccount : Trigger.new)
                {
                    DNBIHelper.GetDUNSNumber(newAccount.Id, newAccount.City__c, newAccount.Country__c, newAccount.State__c, newAccount.Address1__c, newAccount.Zip__c, newAccount.Name);
                }
            }

            if (Trigger.isInsert || Trigger.isUpdate)
            {
                AccountManagement.syncAccountowner();
                AccountManagement.PropagateChangesToAccountSetupRequest();

                List<Account> sitesToUpdate = new List<Account>();
                Map<ID, ID> prospectToSiteMap = new Map<ID, ID>();
                Account oldSite;

                for (Account newAccount : Trigger.new)
                {
                    oldSite = null;
                    if (Trigger.oldMap != null)
                    {
                        oldSite = Trigger.oldMap.get(newAccount.Id);
                    }
                    if (oldSite == null)
                    {
                        if (newAccount.Primary_Site__c == true && newAccount.RecordTypeId == '012E00000008dTcIAI')
                        {
                            prospectToSiteMap.put(newAccount.Related_Account__c, newAccount.Id);
                        }
                    }
                    else {
                        if (newAccount.Primary_Site__c == true && newAccount.RecordTypeId == '012E00000008dTcIAI' && (oldSite.Primary_Site__c != newAccount.Primary_Site__c || oldSite.Oracle_Party_Site_Id__c != newAccount.Oracle_Party_Site_Id__c))
                            prospectToSiteMap.put(newAccount.Related_Account__c, newAccount.Id);
                    }
                }
                if (prospectToSiteMap.KeySet() != null && !prospectToSiteMap.isEmpty())
                {
                    for (Account newAccount: [SELECT Id, Primary_Site_Id__C
                                            FROM Account
                                            WHERE Id in :prospectToSiteMap.KeySet()])
                    {
                        newAccount.Primary_Site_ID__C = prospectToSiteMap.get(newAccount.Id);
                        sitesToUpdate.add(newAccount);
                    }
                }
                if (sitesToUpdate.size() > 0)
                {
                    update sitesToUpdate;
                }
            }
        }

        if (Trigger.isBefore && Trigger.isInsert)
        {
            for (Account newAccount : Trigger.new)
            {
                if (newAccount.Override_Duplicate_Check_OwnerId__c != null)
                {
                    newAccount.OwnerId = newAccount.Override_Duplicate_Check_OwnerId__c;
                }
            }
        }

        //Provide code for byPass Trigger logic
        if (executeoncetest.BypassAccountTrigger)
        {
            if (Util.bypassTriggers('AccountTriggers') || ProspectSynchService.prospectSynchServiceRunning)
            {
                Util.DEBUG('Bypassing Trigger AccountTriggers');
                return;
            }
        }

        //Invoke all Before Logic
        if (Trigger.isBefore)
        {
            //Common code, that needs to be executed for both insert AND update
            if (Trigger.isInsert || Trigger.isUpdate)
            {
                AccountManagement.BeforeAccountInsertAndUpdate();
                AccountManagement.Set_Buying_Account();

                Set<Id> newProspectAccountOwnerIds  = new Set<Id>();
                List<User> newProspectOwnerUsers    = new List<User>();
                Map<Id, User> IdToUserMap           = new Map<Id, User>();
                User UserObj;

                for (Account newAccount : Trigger.new)
                {
                    if (newAccount.RecordTypeId == prospectRecordTypeId)
                    {
                        newProspectAccountOwnerIds.add(newAccount.ownerId);
                    }
                }

                if (newProspectAccountOwnerIds != null && !newProspectAccountOwnerIds.isEmpty())
                {
                    newProspectOwnerUsers =     [SELECT Id, Name, ManagerId, Manager.ManagerId
                                                FROM User
                                                WHERE Id in :newProspectAccountOwnerIds
                                                LIMIT 1000];
                }

                for (User usrObj : newProspectOwnerUsers)
                {
                    IdToUserMap.put(usrObj.Id, usrObj);
                }

                for (Account newAccount : Trigger.new)
                {
                    if (IdToUserMap.containsKey(newAccount.OwnerId))
                    {
                        UserObj = IdToUserMap.get(newAccount.OwnerId);
                        newAccount.DSM_User__c = UserObj.ManagerId;
                        newAccount.RSD_User__c = UserObj.Manager.ManagerId;
                    }
                }
            }

            if (Trigger.isUpdate)
            {
                Account oldAccount;
                for (Account newAccount : Trigger.new)
                {
                    if (Trigger.oldMap != null)
                    {
                        oldAccount = Trigger.oldMap.get(newAccount.Id);
                    }
                }
            }
        }
        else if (Trigger.isAfter)
        {
            if (Trigger.isInsert || Trigger.isUpdate)
            {
                if (executeoncetest.BypassAccountTrigger)
                {
                    if (Util.bypassTriggers('AccountTriggers') || ProspectSynchService.prospectSynchServiceRunning)
                    {
                        Util.DEBUG('Bypassing Trigger AccountTriggers');
                        return;
                    }
                }

                if (executeoncetest.onceprospectmsg == true)
                {
                    ProspectMessage.processMessage();
                }
            }
        }
    }
}