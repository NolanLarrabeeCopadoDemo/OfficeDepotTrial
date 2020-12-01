/**@@
#TRIGGER NAME  :ContactBusinessProUtils  (Related classes: PrimaryContactTrigger(trigger),PrimaryContactTriggerHandler, PrimaryContactTriggerHelper, PrimaryContactTrigger_Test)
#DESCRIPTION :  Created by Rajendra Shahane for ticket 02831117 - Contact trigger conversion to Lightning
#CREATEDDDATE :  02-06-2020 (DD-MM-YYYY)
@@**/
public class ContactBusinessProUtils
{
    /*
When a conatct is created/inserted by 'Dataloader' user and account recordtype is Customer (Business Pro) (from BusinessProSetup custom setting) and Loyalty Number field is set on contact then
a) the Account on contact is set to the Account having same Loyalty Number and the recordtype of contact is updated to 'Contact (Business Pro)'
b) if associated Account based on the Loyalty Number is not found then contact record is not created and following error is shown to user:
Related BusinessPro Account Does Not Exist
*/
    public static void setBusinessProContact(List<Contact> newContactList)
    {
        Set<String> loyNum = new Set<String>();
        Map<String,Account> loyAcct = new Map<String,Account>();
        
        list<BusinessProSetup__mdt> bproSetup = [select ContactTriggerUser__c,AccountRecordType__c,AccountRetURL__c,ContactRecordType__c,LeadRecordType__c,noOverrideEditURL__c,OpportunityRecordType__c,PublicGroupName__c from BusinessProSetup__mdt limit 1];
        
        if (bproSetup.size() > 0) { 
            id ContactTriggerUserid = bproSetup[0].ContactTriggerUser__c;
            if (userInfo.getUserID() == ContactTriggerUserid || Test.isRunningTest()) {
                
                RecordType contrecordtype = [select id from recordType where sobjecttype='Contact' and name=:bproSetup[0].ContactRecordType__c];
                
                for (contact con:newContactList) {
                    if (con.loyalty_number__c != null)
                        loyNum.add(con.loyalty_number__c);
                }
                
                if(loyNum.size() > 0)
                {
                    for (account acc:[select id,loyatly_number__c from account where recordtype.name=:bproSetup[0].AccountRecordType__c and loyatly_number__C=:loyNum])
                    {
                        loyAcct.put(acc.loyatly_number__c,acc);
                    }
                }
                for (contact cont:newContactList) {
                    if (cont.loyalty_number__c != null) {
                        if (loyAcct.containskey(cont.loyalty_number__c)) {
                            cont.AccountId=loyAcct.get(cont.loyalty_number__c).id;
                            cont.Recordtypeid = contrecordtype.id; 
                        }
                        else {
                            cont.addError('Related BusinessPro Account Does Not Exist');
                        }
                    }
                } 
            }
        }
    }
}