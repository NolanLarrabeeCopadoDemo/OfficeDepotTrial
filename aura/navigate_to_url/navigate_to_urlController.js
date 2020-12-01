({
    invoke : function(component, event, helper) {
        var record = component.get("v.recordId");


        let url = window.location.protocol + '//' + window.location.hostname + '/' + record;
        window.location.replace(url);
    }
})