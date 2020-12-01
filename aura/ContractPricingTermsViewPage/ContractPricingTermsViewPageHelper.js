({
	EditCPThelper : function(component, event, helper) {
        component.set("v.Displayviewmode","Edit");
		var cmpEvent = component.getEvent("CPTEvent");
        cmpEvent.setParams({
            "evtCPT" : component.get("v.fields"),
            "CPTId" : component.get("v.recordId")

        });
        cmpEvent.fire();
        
	},
    DeleteCPThelper : function(component, event, helper) {
       
         if (confirm("Do you want to Delete?")) {
                component.find("CPTdata").deleteRecord($A.getCallback(function(deleteResult) {
            if (deleteResult.state === "SUCCESS" || deleteResult.state === "DRAFT") {
                window.open('/' + component.get("v.fields").Contract__c, '_self');
            } 
        }));
         }
    },
    BacktoContracthelper:function(component, event, helper) {
   		  window.open('/' + component.get("v.fields").Contract__c, '_self');
	},
    CloneCPThelper :function(component, event, helper) {
         component.set("v.Displayviewmode","Edit");
		var cmpEvent = component.getEvent("CPTEvent");
        var cloneCPT= component.get("v.fields");
        cloneCPT.Id=null;
        cloneCPT.Name=null;
        cloneCPT.Department_Groups__c=null;
        alert("===Departments__c==="+cloneCPT.Departments__c);
        cloneCPT.Departments__c=null;
        alert("===Departments__c==="+cloneCPT.Departments__c);
        alert("===fields.Departments__c==="+component.get("v.fields.Departments__c"));
         cmpEvent.setParams({
            "evtCPT" : component.get("v.fields"),
            "CPTId" : component.get("v.recordId")

        });
        cmpEvent.fire();
    },
       helperFun : function(component,event,secId) {
        var acc = component.find(secId);
        
        for(var cmp in acc) {
            
            $A.util.toggleClass(acc[cmp], 'slds-hide'); 
            $A.util.toggleClass(acc[cmp], 'slds-show');  
        }
    },
    
    BacktoContract_helper: function(component, event, helper) {
     window.open('/' + component.get("v.fields").Contract__c, '_self');
        
   },
    DeleteContract_helper: function(cmp, event, helper) {
         cmp.find("forceRecordCmp").deleteRecord($A.getCallback(function(deleteResult) {
            if (deleteResult.state === "SUCCESS" || deleteResult.state === "DRAFT") {
                window.open('/' + cmp.get("v.fields").Contract__c, '_self');
            } 
        }));
   },
         
        
    
   
})