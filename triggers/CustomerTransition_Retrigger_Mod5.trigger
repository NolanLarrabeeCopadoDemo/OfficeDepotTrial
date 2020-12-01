// Functionality to Retrigger Mod 5 Launch
trigger CustomerTransition_Retrigger_Mod5 on Customer_Transition__c (Before update,After update) {
set<string> ctomx = new set<string>();
set<string> omxkey = new set<string>();
List<Customer_Transition__c> accset = new List<Customer_Transition__c>();
Map<string,boolean> mapcheckrec = new Map<string,boolean>();
map<string,set<Split_Account_Detail__c>> maphsplit= new map<string,set<Split_Account_Detail__c>>();
    for(Customer_Transition__c ct : Trigger.New){
        if(     trigger.oldMap.get(ct.id).Retrigger_Mod_5__c  != ct.Retrigger_Mod_5__c    &&  ct.Retrigger_Mod_5__c==true){
            if(ct.Ready_for_Mod1__c){ct.adderror('Record cannot be Re-Launched as it has already been launched');
            }
            else{
                ctomx.add(ct.OMX_Primary_Key__c);
                if(Trigger.isbefore)
                ct.Split_Launching_Status__c='Submitted';
            }
        }
    }

    if(ctomx.size()>0){
            for(Split_Account_Detail__c sadtls : [Select Id, Customer_Transition__c, Original_Account__c, OMX_ACCOUNT__c, Customer_Transition__r.AOPS_Flag__c,
                                                    Linked_Customer_Transition__c, Customer_Transition__r.Transition_status__c,Status__c,Master_Account__c,
                                                    Original_Account__r.parent.omx_primary_key__c FROM Split_Account_Detail__c
                                                    WHERE OMX_ACCOUNT__c IN :ctomx]){
                omxkey.add(sadtls.Master_Account__c);
                if(maphsplit.containsKey(sadtls.OMX_ACCOUNT__c))
                {
                    Set<Split_Account_Detail__c> hsplit = maphsplit.get(sadtls.OMX_ACCOUNT__c);
                    hsplit.add(sadtls);
                    maphsplit.put(sadtls.OMX_ACCOUNT__c,hsplit);
                }
                else{
                    Set<Split_Account_Detail__c> hsplit = new Set<Split_Account_Detail__c>(); //maphsplit.get(sadtls.OMX_ACCOUNT__c)
                    hsplit.add(sadtls);
                    maphsplit.put(sadtls.OMX_ACCOUNT__c,hsplit);
                }
            }
            for(string sdtkey:ctomx){
              Customer_Transition__c ct = new Customer_Transition__c();
              ct.omx_primary_key__c = sdtkey;
                for(Split_Account_Detail__c sdt: maphsplit.get(sdtkey)){
                    if(sdt.status__c != 'Error'){
                        mapcheckrec.put(sdt.OMX_ACCOUNT__c,true);
                    }
                    else{
                        mapcheckrec.put(sdt.OMX_ACCOUNT__c,false);
                        ct.MOD5_Ready_To_Launch__c = true;
                        accset.add(ct);
                        break;
                    }
                }
            }

    }
    if(trigger.isbefore){
        for(Customer_Transition__c ct : Trigger.New){
            if(ctomx.size()>0){
                if(mapcheckrec.get(ct.OMX_Primary_Key__c))  ct.Split_Launching_Status__c = 'Success';
                   
                else if(!mapcheckrec.get(ct.OMX_Primary_Key__c))  ct.Split_Launching_Status__c = 'Fail';
                   
            }
        }
    }
    if(trigger.isafter){
        if(accset.size()>0){	upsert accset omx_primary_key__c;
            
            //List<account> mod5launchacc = [Select id,omx_primary_key__c from account where id in: accset OR parentId in: accset or
            //parent.parentid in: accset];
            //mod5launch mod5 = new mod5launch();
            //Mod5.LaunchAccounts(accset);
        }
    }
    
    //Start for the Case 00760186
     if(Trigger.isUpdate && Trigger.isafter){
     Set<Id> ids = new Set<id>();
     for(Customer_Transition__c CT : trigger.new){
        if((Trigger.oldMap.get(CT.Id).ODS_WA_EXECUTED__c!=Trigger.newMap.get(CT.Id).ODS_WA_EXECUTED__c) &&
        CT.ODS_WA_EXECUTED__c==true  &&
         (CT.OMX_Primary_Key__c==CT.Written_Agreement_Customer_No__c)){	ids.add(CT.id);
            
        }
    }
        CT_UpdatingODSWA ctUpdteOSObj = new CT_UpdatingODSWA();
        ctUpdteOSObj.updatingODSWA(ids);
     }
        //End for the Case 00760186

}