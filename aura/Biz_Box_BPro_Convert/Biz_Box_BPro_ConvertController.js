({
    myInit : function(component, event, helper){
        helper.GetLead(component);
    },
    startConvert : function(component, event, helper){
        helper.ConvertLead(component);

    },
    showModal : function(component, event, helper){
        component.set("v.ConvertStartButtonPressed", true);
    },
    hideModal : function(component, event, helper){
        component.set("v.ConvertStartButtonPressed", false);
        component.set("v.ErrorMessage", null);
        //$A.get('e.force:refreshView').fire();
    },
    waiting: function(component, event, helper) {
        document.getElementById("Accspinner").style.display = "block";
    },
    doneWaiting: function(component, event, helper) {
        document.getElementById("Accspinner").style.display = "none";
    }
})