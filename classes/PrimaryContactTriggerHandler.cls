/**@@
#TRIGGER NAME  :  PrimaryContactTriggerHandler(Related classes:ContactBusinessProUtils, PrimaryContactTrigger(trigger), PrimaryContactTriggerHelper, PrimaryContactTrigger_Test)
#DESCRIPTION :  Created by Rajendra Shahane for ticket 02831117 - Contact trigger conversion to Lightning
#CREATEDDDATE :  02-06-2020 (DD-MM-YYYY) 
@@**/
public class PrimaryContactTriggerHandler  extends TriggerHandler
{
    List<Contact> newContactList;
    List<Contact> oldContactList;
    Map<Id, Contact> oldContactMap;
    Map<Id, Contact> newContactMap;
    private Boolean bypassTrigger;
    
    public PrimaryContactTriggerHandler()
    {
        this.newContactList = (List<Contact>) Trigger.New;
        this.oldContactList = (List<Contact>) Trigger.Old;
        this.oldContactMap = (Map<Id, Contact>) Trigger.OldMap;
        this.newContactMap = (Map<Id, Contact>) Trigger.NewMap;        
        bypassTrigger = isTriggerBypassed();
        system.debug('bypassTrigger PrimaryContactTriggerHandler ' + bypassTrigger);
    }
    
    override public void beforeInsert()
    {
        if(!bypassTrigger)
        {
            //Start:code added for DoNotDeleteContact before insert
            skipBizBoxRTIdsForContact();
            PrimaryContactTriggerHelper.setMailingStreet2(newContactList);
            //End: code added for DoNotDeleteContact before insert
            
            //Start:code added for BusinessProTrigger before insert 
            ContactBusinessProUtils.setBusinessProContact(newContactList);
            //End: code added for BusinessProTrigger before insert
            
            //Start:code added for checkDuplicateContacts before insert
            PrimaryContactTriggerHelper.checkDuplicateContacts(newContactList);
            //End:code added for checkDuplicateContacts before insert
        }
    }
    
    override public void beforeUpdate()
    {
        if(!bypassTrigger)
        {
            //Start:code added for DoNotDeleteContact before Update
            skipBizBoxRTIdsForContact();
            PrimaryContactTriggerHelper.setMailingStreet2(newContactList);
            //End: code added for DoNotDeleteContact before Update
        }
    }
    
    override public void beforeDelete()
    {
        if(!bypassTrigger)
        {
            //Start:code added for DoNotDeleteContact before Delete
            skipBizBoxRTIdsForContact();
            PrimaryContactTriggerHelper.checkNotesTaskForDelete(oldContactList,oldContactMap);
            //End: code added for DoNotDeleteContact before Delete
        }
    }
    
    override public void afterInsert()
    {
        if(!bypassTrigger)
        {
            //Start:code added for primaryCheck after insert
            skipBizBoxRTIdsForContact();
            PrimaryContactTriggerHelper.doPrimaryCheck(newContactList,newContactMap);
            //End: code added for primaryCheck after insert
            
            //Start:code added for checkDuplicateContacts after insert
            PrimaryContactTriggerHelper.createNewSiteContacts(newContactList);
            //End: code added for checkDuplicateContacts after insert
        }
        // New Community contact creation should not create community users. Only updates are allowed thru sync.
        //PrimaryContactTriggerHelper.setCommunityUsers(newContactList);
    }
    
    override public void afterUpdate()
    {
        if(!bypassTrigger)
        {
            //Start:code added for primaryCheck after Update
            skipBizBoxRTIdsForContact();
            PrimaryContactTriggerHelper.doPrimaryCheck(newContactList,newContactMap);
            //End: code added for primaryCheck after Update
            
            //Start:code added for GT_DeleteRelatedContactOnAccountChange after Update
            PrimaryContactTriggerHelper.resetAccountPrimaryAndSiteContacts(newContactList,newContactMap,oldContactMap);
            //End: code added for GT_DeleteRelatedContactOnAccountChange after Update
        }
        PrimaryContactTriggerHelper.setCommunityUsers(newContactList);
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
    
    public void skipBizBoxRTIdsForContact()
    {
        //Story#01514722 - Below Piece of code is used to skip RecordType (Tech Zone) 
        // added for ticket 01474559
        list<Contact> lstContacts = newContactList;
        if(lstContacts == null) lstContacts = oldContactList;
        for(Contact c: lstContacts)
        {
            if(util.checkRT('Contact').contains(c.recordtypeId) || Util.bizBoxRTIdsByObject('Contact').contains(c.RecordTypeId))
                return;
        }
    }
}