({
    doinit : function(component, event, helper) {
        var action = component.get("c.quoteapp");
        action.setParams({quo : component.get("v.recordId")});
        action.setCallback(this, function(response){
            var state=response.getState();
            if(state =="SUCCESS")
            {  
                component.set("v.quotqQx",response.getReturnValue().quotqQx);
                component.set("v.violationList",JSON.stringify(response.getReturnValue().quotlineQxList));
                component.set("v.appList",JSON.stringify(response.getReturnValue().pisList));
                component.set("v.ComplianceList",JSON.stringify(response.getReturnValue().compList));
                component.set("v.MaintennaceList",JSON.stringify(response.getReturnValue().mainList));
                component.set("v.BusinessList",JSON.stringify(response.getReturnValue().busList));
                console.log(JSON.stringify(response.getReturnValue().quotlineQxList));
                component.set("v.appList",JSON.parse(component.get("v.appList")));
                     console.log('the list is'+component.get("v.violationList"));                  
                component.set("v.violationList",JSON.parse(component.get("v.violationList")));
                component.set("v.ComplianceList",JSON.parse(component.get("v.ComplianceList")));
                component.set("v.MaintennaceList",JSON.parse(component.get("v.MaintennaceList")));
                component.set("v.BusinessList",JSON.parse(component.get("v.BusinessList")));
            }
        });
        $A.enqueueAction(action);
    }
})