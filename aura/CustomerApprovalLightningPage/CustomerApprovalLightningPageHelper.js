({
    helperdoInit : function(component, event, helper) {
        component.set("v.customerQuote",true);
        var nameOfQuote;
        var specialChars = '"';
        var action =  component.get("c.getInitHelper");
        var action2 =  component.get("c.getProsDetails");
        action.setParams ({recordId : component.get("v.recordId")});
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var res= response.getReturnValue();
                component.set("v.currentQuote.Customer_communication_requirements__c",res.Customer_communication_requirements__c);
                component.set("v.currentQuote.OpportunityId__c",res.OpportunityId__c);  
                component.set("v.currentQuote.Document_Downloadable_URL__c",res.Document_Downloadable_URL__c);  
                if(res.CameleonCPQ__AccountId__r.Cust_ID__c != null && res.CameleonCPQ__AccountId__r.Name!=null && res.Quote_Number__c != null) {
                    nameOfQuote =res.CameleonCPQ__AccountId__r.Cust_ID__c +'-'+ res.CameleonCPQ__AccountId__r.Name +'-' +res.Quote_Number__c
                    
                }
                component.set("v.quoteAccountName",nameOfQuote);
                console.log('the formatted name is'+nameOfQuote);
                if(res.Count_Line_For_Customer_Copy__c == 0) {
                    component.set("v.QuoteWithNoProducts",false);
                } else {
                    component.set("v.QuoteWithNoProducts",true);
                }
            }
        });
        action2.setParams ({recordId : component.get("v.recordId")});
        action2.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var res= response.getReturnValue();
                
                if(res.DOA_Custom_Price_Increase_Flag__c == false && res.DOA_Custom_Price_More_Inherited_Flag__c == false && res.DOA_Price_Freeze_Violation__c == false && res.Customer_communication_requirements__c == "Notification" && res.Documentation_required_to_participate__c !="Written confirmation") {
                    component.set("v.customerQuoteNotificationWritten",false);   
                } else 
                {
                    component.set("v.customerQuoteNotificationWritten",true);   
                }
                if(res.Customer_Approval_Status__c =='Submitted') {
                    component.set("v.customerApprovalRequired",true);
                } 
                else if(res.Customer_approval_is_received__c == 'Auto Approved'){
                    
                    component.set("v.messageForResponse",false); 
                    //component.set("v.customerQuote",false);
                }
                else    
                {
                                         
                    component.set("v.customerQuote",false);
                    component.set("v.messageForResponse",true); 
                    component.set("v.customerApprovalRequired",false); 
                }
                if(res.Documentation_required_to_participate__c =="Written confirmation" && (res.Customer_communication_requirements__c == "Contract silent" || res.Customer_communication_requirements__c == "Notification & Approval" )) { 	
                    component.set("v.writtenAgreement",true);
                } else 
                {
                    component.set("v.writtenAgreement",false);
                }
                if(res.Grandparent__c != null && res.Grandparent__r.Name != null) {
                    var prcsdRspns = res.Grandparent__r.Name.replace('"', ' ');
                    console.log('the value is'+prcsdRspns);
                    component.set("v.currentQuote.Grandparent__r.Name",prcsdRspns);
                }
                if(res.Default_Grandparent__c != null && res.Default_Grandparent__r.Name != null) {
                    var prcsdRspns = res.Default_Grandparent__r.Name.replace('"', ' ');
                    
                    component.set("v.currentQuote.Default_Grandparent__r.Name",res.Default_Grandparent__r.Name);
                }
                if(res.Default_Great_Grandparent__c != null && res.Default_Great_Grandparent__r.Name != null) {
                    var prcsdRspns = res.Default_Great_Grandparent__r.Name.replace('"', ' ');
                    
                    component.set("v.currentQuote.Default_Great_Grandparent__r.Name",res.Default_Great_Grandparent__r.Name);
                }
                if(res.Default_Parent__c != null && res.Default_Parent__r.Name != null) {
                    var prcsdRspns =res.Default_Parent__r.Name.replace('"', ' ');
                    component.set("v.currentQuote.Default_Parent__r.Name",prcsdRspns);
                    
                }
                if(res.Great_Grandparent__c != null && res.Great_Grandparent__r.Name  != null) {
                    var prcsdRspns =res.Great_Grandparent__r.Name.replace('"', ' ');
                    
                    component.set("v.currentQuote.Great_Grandparent__r.Name ",prcsdRspns );
                }
                if(res.Parent__c != null && res.Parent__r.Name != null) {
                    var prcsdRspns =res.Parent__r.Name.replace('"', ' ');
                    
                    component.set("v.currentQuote.Parent__r.Name",prcsdRspns);
                }
                if(res.CameleonCPQ__AccountId__c != null && res.CameleonCPQ__AccountId__r.Name!= null) {
                    var prcsdRspns =res.CameleonCPQ__AccountId__r.Name.replace('"', ' ');
                    
                    component.set("v.currentQuote.CameleonCPQ__AccountId__r.Name",prcsdRspns);
                }
                if(res.CameleonCPQ__AccountId__r.AOPS_Cust_Id__c != null) {
                    var prcsdRspns =res.CameleonCPQ__AccountId__r.AOPS_Cust_Id__c.replace('"', ' ');
                    
                    component.set("v.currentQuote.CameleonCPQ__AccountId__r.AOPS_Cust_Id__c",prcsdRspns);
                }
            }
        });
        $A.enqueueAction(action); 
        $A.enqueueAction(action2); 
        
    },
    handleApprovalHelper : function(component, event, helper) {
        var action = component.get("c.Save");
        action.setParams ({recordId : component.get("v.recordId"),
                           CustResp :component.get("v.currentQuote.Customer_Response__c")
                          });
        action.setCallback(this, function(response) {
            var state = response.getState();
            var res= response.getReturnValue();
            if (state === "SUCCESS") {
                component.set("v.writtenAgreementOnApproval",true);
                component.set("v.ThankYouMessage",true); 
                component.set("v.customerQuote",false);
                console.log('Here111');
            } else{
                console.log('Failed');
            }
        });
        $A.enqueueAction(action); 
    },
    handleRejectionHelper : function(component, event, helper) {
        var action = component.get("c.reject");
        action.setParams ({recordId : component.get("v.recordId"),
                           CustResp :component.get("v.currentQuote.Customer_Response__c")
                          });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                component.set("v.ThankYouMessage",true);
                                component.set("v.customerQuote",false);

            }
        });
        $A.enqueueAction(action);         
    },
    handleRequestingInformationHelper : function(component, event, helper) { 
        var action = component.get("c.requestInformation");
        action.setParams ({recordId : component.get("v.recordId"),
                           CustResp :component.get("v.currentQuote.Customer_Response__c")
                          });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                component.set("v.ThankYouMessage",true);
                                component.set("v.customerQuote",false);

            }
        });
        $A.enqueueAction(action);        
    }
})