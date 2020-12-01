/**@@
#CLASS NAME  :  AccountTriggerHandler(Related classes: AccountTriggerHandler, AccountTriggerHelper, PrimaryAccountTrigger_Test)
#DESCRIPTION :  Modified by Rajendra Shahane for ticket 02831114 - Account triggers conversion to Lightning
#MODIFIEDDDATE :  22-05-2020 (DD-MM-YYYY)
public with sharing class AccountTriggerHandler extends TriggerHandler {
@@**/
public class AccountTriggerHandler extends TriggerHandler
{
    List<Account> newAccountList;
    List<Account> oldAccountList;
    Map<Id, Account> oldAccountMap;
    Map<Id, Account> newAccountMap;
    private Boolean bypassTrigger;
    //Map<Id, String> mapOfRecordTypes = new Map<Id, String>();
    
    public AccountTriggerHandler()
    {
        this.newAccountList = (List<Account>) Trigger.New;
        this.oldAccountList = (List<Account>) Trigger.Old;
        this.oldAccountMap = (Map<Id, Account>) Trigger.OldMap;
        this.newAccountMap = (Map<Id, Account>) Trigger.NewMap;
        //mapOfRecordTypes = ODCommonUtilityMethods.getRecordTypeIdToName('Account');
        
        bypassTrigger = isTriggerBypassed();
        system.debug('bypassTrigger AccountTriggerHandler ' + bypassTrigger);
    }
    
    override public void beforeInsert()
    {
        if(!bypassTrigger)
        {
            //Start:code added for AccountEvents before insert
            AccountTriggerHelper.updateGPorGGPOwnerOnInsert(newAccountList);
            executeoncetest.notTriggered_AccountEvents_before = false;
            //End: code added for AccountEvents before insert
            
            //Start:code added for AccountTriggers before insert
            skipBizBoxRTIdsForAccount();
            AccountTriggerHelper.setGPorGGPidandAOPSId(newAccountList);
            
            if(!(System.isFuture() || System.isBatch()))
            {
                AccountTriggerHelper.setOwnerForCustomerGTAndSiteGt(newAccountList);
             //   if (!ProspectSynchService.prospectSynchServiceRunning)
               // {
                   AccountManagement.BeforeAccountInsertAndUpdate();
                    AccountTriggerHelper.setBuyingAccount(newAccountList);
                    AccountTriggerHelper.setDSMandRSD(newAccountList);
               // }
            }
            //End: code added for AccountTriggers before insert
            executeoncetest.notTriggered_AccountTriggers_before = false;
            
            
        }
    }
    
    override public void beforeUpdate()
    {
        if(!bypassTrigger)
        {
            //Start:code added for OrgUpdates before Update
            AccountTriggerHelper.setOrgChildUpdate(newAccountList,oldAccountMap);
            //End: code added for OrgUpdates before Update
            
            //Start:code added for GT_SoldToChange before Update
            skipBizBoxRTIdsForAccount();
            AccountTriggerHelper.setGTSoldToChange(newAccountList, newAccountMap, oldAccountMap);
            //End: code added for GT_SoldToChange before Update
            
            //Start:code added for AccountEvents before Update
            if (executeoncetest.notTriggered_AccountEvents_before || executeoncetest.notTriggered_AccountEvents_after || Test.isRunningTest())
            {
                executeoncetest.notTriggered_AccountEvents_before = false;
                AccountTriggerHelper.setProspectCreationFailure(newAccountList,oldAccountMap);
            }
            //End: code added for AccountEvents before Update
            
            //Start:code added for AccountTriggers before Update
            if(!(System.isFuture() || System.isBatch()))
            {
                AccountTriggerHelper.setOwnerForCustomerGTAndSiteGt(newAccountList);
            //    if (!ProspectSynchService.prospectSynchServiceRunning)
              //  {
                  AccountManagement.BeforeAccountInsertAndUpdate();
                    AccountTriggerHelper.setBuyingAccount(newAccountList);
                    AccountTriggerHelper.setDSMandRSD(newAccountList);
               // }
            }
            //End: code added for AccountTriggers before Update
            executeoncetest.notTriggered_AccountTriggers_before = false;
        }
    }
    
    override public void beforeDelete()
    {
        if(!bypassTrigger)
        {
            //Start:code added for  before delete
            
            //End: code added for  before delete
        }
    }
    
    override public void afterInsert()
    {
        if(!bypassTrigger)
        {
            //Start:code added for AccountAfterUpdateTrigger after insert
            AccountTriggerHelper.setRelatedAccountPrimarySiteID(newAccountList);
            //End: code added for AccountAfterUpdateTrigger after insert
            
            //Start:code added for AccountEvents after insert
            AccountTriggerHelper.createDMLRelationship(newAccountList);
            executeoncetest.notTriggered_AccountEvents_after = false;
            //End: code added for AccountEvents after insert
                
            //Start:code added for BusinessPro after insert
            skipBizBoxRTIdsForAccount();
            AccountTriggerHelper.createBusinessProOwnerHistory(newAccountList);
            //End: code added for BusinessPro after insert
            
            //Start:code added for AccountTriggers after insert
            AccountTriggerHelper.createGPGGPHistory(newAccountList,null);
            if(!(System.isFuture() || System.isBatch()))
            {
                AccountTriggerHelper.getDNBIDUNSNumber(newAccountList);
                AccountTriggerHelper.setAccountSetupRequestandOwnerId(newAccountList,null);
                AccountTriggerHelper.setAccountPrimarySiteID(newAccountList,null);
          //      if(!ProspectSynchService.prospectSynchServiceRunning)
            //    {
                    if (executeoncetest.onceprospectmsg == true)
                    {
                        AccountTriggerHelper.processMessage(newAccountList);
                    }
              //  }
            }
            //End:code added for AccountTriggers after insert
            
            //executeoncetest.notTriggered_AccountTriggers_after = false;
        }
    }
    
    override public void afterUpdate()
    {
        if(!bypassTrigger)
        {
            system.debug('inside after update');
          //  AccountTriggerHelper.populate_GPO_Flag(newAccountList,oldAccountMap);

            //Start:code added for AccountAfterUpdateTrigger after update
            AccountTriggerHelper.updateDMLRelationshipAOPSId(newAccountList, newAccountMap,oldAccountMap);
            //End: code added for AccountAfterUpdateTrigger after update
            
            //Start:code added for AccountEvents after update
            system.debug('before acct setup call');
            AccountTriggerHelper.createAccountSetupOnUpdate(newAccountList,oldAccountMap);
            system.debug('after acct setup call');
            executeoncetest.notTriggered_AccountEvents_after = false;
            //End: code added for AccountEvents after update 
                
            //Start:code added for GT_DeleteContacts after update
            skipBizBoxRTIdsForAccount();
            AccountTriggerHelper.deletePrimaryContactsForAccountSetupReqGT(newAccountList,newAccountMap, oldAccountMap);
            //End: code added for GT_DeleteContacts after update
            
            //Start:code added for AccountTriggers after update
            AccountTriggerHelper.createGPGGPHistory(newAccountList,oldAccountMap);
            if(!(System.isFuture() || System.isBatch()))
            {
                AccountTriggerHelper.syncAccountowner(newAccountList);
                AccountTriggerHelper.setAccountSetupRequestandOwnerId(newAccountList,oldAccountMap);
                AccountTriggerHelper.setAccountPrimarySiteID(newAccountList,oldAccountMap);
       //         if(!ProspectSynchService.prospectSynchServiceRunning)
         //       {
                    if (executeoncetest.onceprospectmsg == true)
                    {
                        AccountTriggerHelper.processMessage(newAccountList);
                    }
           //     }
            }
            //End:code added for AccountTriggers after update
            
            executeoncetest.notTriggered_AccountTriggers_after = false;
        }
    }
    
    override public void afterDelete()
    {
        if(!bypassTrigger)
        {
            //Start:code added for  after Delete
            
            //End: code added for  after Delete
        }
    }
    
    override public void afterUnDelete()
    {
        if(!bypassTrigger)
        {
            //Start:code added for  after unDelete
            
            //End: code added for  after unDelete
        }
    }
    
    public void skipBizBoxRTIdsForAccount()
    {
        //Account Service Production Fix
        Set<ID> resp = new Set<ID>();
        resp = Util.bizBoxRTIdsByObject('Account');        
        if (newAccountList != null) {
            for (Account myAccount: newAccountList)
            {
                
                if (resp.contains(myAccount.RecordTypeId)) {
                    return;
                }
            }
        }
    }
    
    /* Commented as part of trigger framework and below logic is not required
        override public void afterUpdate(){
        Set<Id> new_customers = AccountTriggerMethods.getUpdatedAccounts(this.oldAccountMap, this.newAccountMap);//AccountTriggerMethods is renamed to AccountTriggerHelper
        
        if(!Test.isRunningTest()) {
        // Callout
        AggroService.postUpdatedAccounts(new_customers);
        }
        }
        
        override public void afterInsert(){
        if(!Test.isRunningTest()) {
        // Callout
        AggroService.postUpdatedAccounts(this.newAccountMap.keySet());
        }
        }*/
}