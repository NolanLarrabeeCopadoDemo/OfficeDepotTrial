({
    // Save the edited record.
    doSave : function(component, event, helper) {
        component.find("edit").get("e.recordSave").fire();
    },
    // On Save redirect to view.
    doCloseWindow : function(component, event, helper){
        var address = window.location.href;
        window.location.href = address.replace("/edit", "/view");
        component.find("edit").get("e.recordSave").fire();

    },
    // Do we have a valid record ID
    hasRecordID : function(component, event, helper) {
            console.log("Record ID is " + component.get("v.recordId"));
            console.log("Name is " + component.get("v.sObjectName"));
        if(typeof component.get("v.recordId") === "undefined"){
            var urlParams = helper.getURLParams();
            console.log("Params is " +urlParams);
            if(urlParams === "undefined") {
                helper.createRecord(component, event, helper);
                return;
            }
            var paramMap = helper.parseParams(component, event, helper, urlParams);
            var recordTypeID = paramMap.get("recordTypeId");
            helper.createTypedRecord(component, event, helper, recordTypeID);
            return;
        }else {
            component.set("v.validRecordId", true);
            return;
        }
        $A.get('e.force:refreshView').fire();
    },
    // Refresh the view
    refresh: function (component, event, helper){
        $A.get('e.force:refreshView').fire();
    }
})