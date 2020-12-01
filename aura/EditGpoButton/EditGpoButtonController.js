({
    init : function (component) {
        // Find the component whose aura:id is "flowData"
        var flow = component.find("flowData");
        var StrId=component.get("v.recordId");
        var inputVariables = [
         { name : "recordId", type : "String", value: StrId.toString() }, 
       
       ];
        //alert(component.get("v.recordId"));
        
        
        // In that component, start your flow. Reference the flow's API Name.
        flow.startFlow("Edit_GPO_Group_Record",inputVariables);
       
    },
    closeFlowModal: function(component, event, helper) {
        // Set isModalOpen attribute to false  
        component.set("v.isModalOpen", false);
    },
})