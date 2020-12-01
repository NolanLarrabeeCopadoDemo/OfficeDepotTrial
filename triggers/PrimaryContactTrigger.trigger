/**@@
#TRIGGER NAME  :  PrimaryContactTrigger(Related classes:ContactBusinessProUtils, PrimaryContactTriggerHandler, PrimaryContactTriggerHelper, PrimaryContactTrigger_Test)
#DESCRIPTION :  Created by Rajendra Shahane for ticket 02831117 - Contact trigger conversion to Lightning
#CREATEDDDATE :  02-06-2020 (DD-MM-YYYY)
@@**/
trigger PrimaryContactTrigger on Contact (before insert,before update,before delete,after insert,after update,after delete,after undelete) {
	new PrimaryContactTriggerHandler().run();
}