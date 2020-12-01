({
    init : function (component,event) {
        component.set("v.isModalOpen", true);
        // Find the component whose aura:id is "flowData"
        var flow = component.find("flowData");
        // In that component, start your flow. Reference the flow's API Name.
        flow.startFlow("New_GPO_Group_Button");
    },
    closeFlowModal: function(component, event, helper) {
      // Set isModalOpen attribute to false  
      component.set("v.isModalOpen", false);
   },
})