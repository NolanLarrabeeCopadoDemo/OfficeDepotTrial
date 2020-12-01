trigger CT_OnDeck_WRF_trg on Customer_Transition__c (after update) {
if(executeoncetest.CT_OnDeck_WRF_trg_check){
List<Customer_Transition__c> nonWA = new List<Customer_Transition__c>();
List<Customer_Transition__c> WA = new List<Customer_Transition__c>();
List<Customer_Transition__c> ctrecs = new List<Customer_Transition__c>();

//Variable for Contract Extension Complete
Set<ID> closeWrfSetCon = new Set<ID>();
Map<String,String> closeWAmapCon = new Map<String,String>();
Set<ID> ctWRFCloseSetCon = new Set<ID>();
system.debug('trigger');


for (Customer_Transition__c CT : Trigger.new) 
{
    if((!CT.Ready_for_Mod1__c) && (!executeoncetest.isMod5Launch)){
        /*  start of 00660321
    IF( Trigger.oldmap.get(CT.ID).Status__c  != CT.Status__c && CT.Status__c == 'On Deck' && CT.Related_WRF_Case__c == NULL)
    {
        executeoncetest.CT_OnDeck_WRF_trg_check=false;
        IF((CT.Written_Agreement_Customer_No__c == NULL) || (CT.Written_Agreement_Customer_No__c == '' ))
        {
        nonWA.add(CT);
        }
        else
        {
        WA.add(CT);
        }
    }
    else*/
    // end of 00660321
 if(CT.Status__c != 'On Deck' && Trigger.oldmap.get(CT.ID).Status__c  != CT.Status__c && ((ct.Agreement_Development__c == true) || (ct.Agreement_Complete__c== true) || (ct.Extension_in_Development__c==true)) && CT.Written_Agreement_Customer_No__c!=null && ct.Related_WRF_Case__c!=null)
        ctrecs.add(CT);
    
    }
}

//Method call for Contract Extension Complete
if(((!closeWrfSetCon.isEmpty()) && closeWrfSetCon.size() > 0) &&((!closeWAmapCon.isEmpty()) && closeWAmapCon.size() > 0) && ((!ctWRFCloseSetCon.isEmpty()) && ctWRFCloseSetCon.size() > 0))
CT_OnDeck_WRF_cls.closeWrf(closeWrfSetCon,closeWAmapCon,ctWRFCloseSetCon);

if((!nonWA.isEmpty()) && nonWA.size() > 0)
{
CT_OnDeck_WRF_cls.initial(nonWA,'nonWA');
}
if((!WA.isEmpty()) && WA.size() > 0)
{
CT_OnDeck_WRF_cls.initial(WA,'WA');
}
if((!ctrecs.isEmpty()) && ctrecs.size() > 0)
{
system.debug('Call Initial@@@'+ctrecs);
CT_OnDeck_WRF_cls.initial(ctrecs,'Status');
}
    if((!CT_OnDeck_WRF_cls.updatedCT.isEmpty()) && CT_OnDeck_WRF_cls.updatedCT.size() > 0)
    {
    
    System.debug('&&&&&&&&&&&&&&Inside Method  DECK'+CT_OnDeck_WRF_cls.updatedCT.size());
    //List of CT that need to be updated in Hierarchy
    List<Customer_Transition__c> updatedCT = CT_OnDeck_WRF_cls.updatedCT;

        try
        {
        executeoncetest.CT_OnDeck_WRF_trg_check=false;
        update updatedCT;
        }
        catch(Exception e)
        {
            for(Customer_Transition__c CTs : Trigger.new) 
            {
            CTs.addError('Record cannot be saved due to exception in hierarchy.');
            }
        }
    }
}
}