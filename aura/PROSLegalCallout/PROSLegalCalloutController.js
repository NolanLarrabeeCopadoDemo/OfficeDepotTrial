({
    myAction : function(component, event, helper) {
        
    }, 
    
    
    recordLoaded: function(component,event,helper)
    {
        document.getElementById("spinnerDiv").style.display = 'none';
        
        // component.find("IssueType").set("v.value",component.get("v.fields").Issue_Type__c);  
        // component.find("IssueTerm").set("v.value",component.get("v.fields").Issue_Term__c);  
    },
    
    IssueTypeEntered: function(component, event, helper)
    {
        document.getElementById("spinnerDiv").style.display = 'none';
        
    },
    
    activateButton: function(component, event, helper)
    {
        console.log('=>',component.find("IssueType").get("v.value"));
        component.set("v.approvers",[]);                                    
        component.set("v.isButtonActive",false);
        if(component.find("IssueType").get("v.value") != ''){
            document.getElementById("spinnerDiv").style.display = 'block';
            var action = component.get("c.getIssueTerms");
            action.setParams({Types:  component.find("IssueType").get("v.value")});
            action.setCallback(this, function(response) {
                var state = response.getState();
                //alert(state);
                if (state === "SUCCESS") {                
                    console.log(response.getReturnValue());
                    var newOptions = [];
                    var options = response.getReturnValue();
                    for(var i = 0; i < options.length; i++) {
                        newOptions.push({'label': options[i], 'value': options[i]});
                    }
                    component.set("v.options",newOptions);
                    document.getElementById("spinnerDiv").style.display = 'none';
                }
                else if (state === "ERROR") {
                    document.getElementById("spinnerDiv").style.display = 'none';
                    alert('An Error Occurred, please consult your browser console.');               
                }
            });       
            $A.enqueueAction(action);
        }else{
            component.set("v.options",[]);
        }      
    },
    
    handleChange: function(component, event, helper) {
        /*console.log("Quote Id is : " + component.get("v.fields").Id);
        */
    },
    
    onRecordSubmit: function(component, event, helper) {
        
        document.getElementById("spinnerDiv").style.display = 'block';
        var IssueTerm = '';
        var IssueTermValue = component.get("v.value");
        for(var i=0;i<IssueTermValue.length;i++){
            if(i==0){
                IssueTerm = IssueTermValue[i];
            }else{
                IssueTerm = IssueTerm+';'+IssueTermValue[i];
            }
            
        }
        console.log(IssueTerm);
        
        var action2 = component.get("c.getApprovalUsers");
        action2.setParams({ quoteId : component.get("v.recordId"),
                           Type:component.find("IssueType").get("v.value"),
                           IssueTerm: IssueTerm
                          });
        
        action2.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {                
                console.log(response.getReturnValue());
                var approverOptions = [];
                var approvers = response.getReturnValue();
                for(var i = 0; i < approvers.length; i++) {
                    console.log(approvers[i]);
                    approverOptions.push( approvers[i]);
                }
                component.set("v.approvers",approverOptions);                    
                component.set("v.approvalCount",(4 - approverOptions.length));
                component.set("v.isButtonActive",true);
                document.getElementById("spinnerDiv").style.display = 'none';
            }
            else if (state === "ERROR") {
                document.getElementById("spinnerDiv").style.display = 'none';
                alert('An Error Occurred, please consult your browser console.');               
            }
        });       
        $A.enqueueAction(action2);
        //document.getElementById("ToastMessage").style.display = 'block';
        //document.getElementById("spinnerDiv").style.display = 'block';
    }, 
    
    ClosePage : function(component, event, helper) {
        $A.get("e.force:closeQuickAction").fire();
        //let flowUrl = window.location.protocol + '//' + window.location.hostname + '/'+Id;
        //location.replace(flowUrl);      
    },
    
    handleUser1LookupChange:function(component, event, helper) {
        event.getParam("recordId");
        component.set("v.Approver1",event.getParam("recordId"));  
    },
    
    handleUser2LookupChange:function(component, event, helper) {
        event.getParam("recordId");
        component.set("v.Approver2",event.getParam("recordId")); 
    },
    
    handleUser3LookupChange:function(component, event, helper) {
        event.getParam("recordId");
        component.set("v.Approver3",event.getParam("recordId"));
    },
    
    handleUser4LookupChange:function(component, event, helper) {
        event.getParam("recordId");
        component.set("v.Approver4",event.getParam("recordId"));
    },
    
    submitForApproval:function(component, event, helper) {
        //component.get("v.recordId");
        document.getElementById("spinnerDiv").style.display = 'block';
        var approvers = component.get("v.approvers");
        var approverIds =[];
        for(var i = 0; i < approvers.length; i++) {
            console.log(approvers[i]);
            approverIds.push( approvers[i].Id);
        }
        if(component.get("v.Approver1")){
            approverIds.push(component.get("v.Approver1"));
        }
        if(component.get("v.Approver2")){
            approverIds.push(component.get("v.Approver2"));
        }
        if(component.get("v.Approver3")){
            approverIds.push(component.get("v.Approver3"));
        }
        if(component.get("v.Approver4")){
            approverIds.push(component.get("v.Approver4"));
        }
        console.log('approverIds=>',approverIds);
        var action2 = component.get("c.CreateSCOECaseFORApproval");
        action2.setParams({ qouteId :  component.get("v.recordId"),
                            IssueType: component.find("IssueType").get("v.value"),
                           	IssueTerm: JSON.stringify(component.get("v.value")),
                           approverIds: JSON.stringify(approverIds)
                          });
        action2.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {                
                console.log(response.getReturnValue());
		        document.getElementById("spinnerDiv").style.display = 'none';
                $A.get("e.force:closeQuickAction").fire();
            }
            else if (state === "ERROR") {
                document.getElementById("spinnerDiv").style.display = 'none';
                alert('An Error Occurred, please consult your browser console.');               
            }
        });       
        $A.enqueueAction(action2);
    }
    
})