// Modified  - S-401328- commented code body to remove inactive trigger from coverage class
trigger CPM_Trigger on CPM__c (before insert, after insert, before update) 
{
// CPM_Scenario_GT & Owner Fix  
    /*IF (Trigger.IsBefore && Trigger.IsInsert) 
        {   
            string proceed = 'NoGo';
            set<String> SupNo = new Set<String>();
            set<Decimal> SceNo = new Set<Decimal>();
            set<Decimal> VerNo = new Set<Decimal>();
            for (CPM__c CM : Trigger.new) 
            {
                CM.OwnerId = CM.Pricing_Analyst__c;
                IF(CM.Version__c >= 2) 
                {
                  proceed = 'Go';
                  SupNo.add(cm.Support_Number__c);
                  SceNo.add(integer.valueof(cm.Scenario__c));
                  VerNo.add(integer.valueof(cm.Version__c));
                }
            }
            IF(proceed == 'Go') 
            {
//Capture a list of CPMs that are older versions and set the Approval Status to 'Obsolete'.
            Map<ID,CPM__c> CPUpdMap = new map<ID,CPM__c>();

            CPUpdMap.putall([Select ID, Approval_Status__c, Support_Number__c, Scenario__c, Version__c
                            from CPM__c
                            Where Support_Number__c in : SupNo
                            and Scenario__c in : SceNo
                            and Approval_Status__c != 'Obsolete']);
            
            set<ID> uPiW = new Set<ID>();

                For (CPM__c uC : CPUpdMap.Values()) 
                {
                        uPiW.Add(uC.ID);
                        uC.Approval_Status__c = 'Obsolete';
                }
                
                Update CPUpdMap.values();     
//Capture a list of existing processes that will be invalid
                Map<ID, ProcessInstanceWorkitem> workitem = New Map<ID, ProcessInstanceWorkitem>( [select Id 
                                                 from ProcessInstanceWorkitem 
                                                 where ProcessInstance.TargetObjectId in : uPiW
                                                 and ProcessInstance.Status = 'Pending']);                
                if (workitem.size()>0)
                    {
                        Approval.ProcessWorkItemRequest pwr = new Approval.ProcessWorkItemRequest();     
                        For (ProcessInstanceWorkitem PiW: workitem.values())
                        {
                            pwr.setWorkitemId(PiW.id);
                            pwr.setComments('A newer version for this scenario was created. Set Approval to Recalled and Approval Status to Obsolete');
                            pwr.setAction('Removed'); 
//Submit approval with Removed Status to all the capture in the above list.
                        Approval.ProcessResult pr = Approval.process(pwr); 
                        }
                    }
                
                }
            }
// CPM_Reminder_Email - Fix NextApproverID
    IF (Trigger.IsBefore && Trigger.IsUpdate) 
        {
        for (CPM__c CM : Trigger.new) 
            {
                IF(cM.Next_ApproverId__c != Trigger.oldmap.get(cM.Id).Next_ApproverId__c)
                    {
                        IF(cM.Next_ApproverId__c == 'Finance')
                            {
                                cM.NextApproverIdUser__c = null;
                            } ELSe 
                            {
                                cM.NextApproverIdUser__c = cM.Next_ApproverId__c;
                            }
                    }
            }
        }*/
}
/*
                IF(cM.Send_Reminder__c == true && cM.Next_ApproverId__c != 'Finance' && string.isblank(cM.Next_ApproverId__c) == false)
                    {       
                        messaging.SingleEmailMessage SEM = new Messaging.SingleEmailMessage();
                        SEM.saveAsActivity = false;
                        SEM.setSubject('CPM Approval Reminder - ' + cM.Name + ' submitted by ' + cM.PA_Name__c + ' from ' + cM.Account_Owner_Region__c + ' region');
                        SEM.sethtmlBody('<html><center><table id="topTable" height="150" width="500" cellpadding="0" cellspacing="0"><tbody><tr valign="top"> <img border="0"  src="https://officedepot--c.na9.content.force.com/servlet/servlet.ImageServer?id=015E000000434lM&oid=00DE0000000J4oS"></img></td></tr><tr>' + cM.Name + ' CPM has been sitting in <b>' + cM.Approval_Status__c + '</b> for more than ' + cM.Reminder_Email_Time__c +' hours.</tr><tr> Please click <b><u><a href="https://officedepot--uat--c.cs7.visual.force.com/' + cM.ID + '">here<a/></b></u> to Approve or Reject the CPM.</tr></tbody></table></center></html>');
                        SEM.setTargetObjectId(cM.Next_ApproverId__c); 
            
                        Messaging.sendEmail(new Messaging.SingleEmailMessage[] {SEM});
                    
                        cM.Send_Reminder__c = False;    
                        cM.Remainder_Email_On__c = Date.today();
                    }
            }   
        }
}
*/