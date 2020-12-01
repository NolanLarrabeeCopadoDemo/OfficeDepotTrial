({
    doInit : function(component, event, helper) {
        helper.doInitHelper(component,event);
        
    },
    
    handleBlur: function(component, event, helper){
        var phoneNumber = component.find("phone_id").get("v.value");
        var x = phoneNumber;
        var ph =  myUtil.phoneFormat(x);
        component.find("phone_id").set("v.value", ph);
    },
    savepartnercontact : function(component, event, helper) {
        if (helper.isInputDataValid(component, event)) {
            helper.savecontact(component,event);       
        }  
    }
})