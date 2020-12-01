/**@@
#TRIGGER NAME  :  PrimaryAccountTrigger(Related classes: AccountTriggerHandler, AccountTriggerHelper, PrimaryAccountTrigger_Test)
#DESCRIPTION :  Modified by Rajendra Shahane for ticket 02831114 - Account triggers conversion to Lightning
#MODIFIEDDDATE :  22-05-2020 (DD-MM-YYYY) 
@@**/
trigger PrimaryAccountTrigger on Account (before insert, before update,before delete,after insert, after update,after delete,after undelete)
{
    new AccountTriggerHandler().run();
}