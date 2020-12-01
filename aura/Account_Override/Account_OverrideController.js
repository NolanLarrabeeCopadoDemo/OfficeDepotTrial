({
    doInit : function(component, event, helper) {
        //alert('recordId=',component.get("v.recordId"));
        console.log('recordId=>',component.get("v.recordId"));
        //$A.get('e.force:refreshView').fire();
    },
    
    handleFlowLaunch : function(component, event, helper) {
        component.set("v.isModalOpen", true);    
        /*let flowUrl = window.location.protocol + '//' + window.location.hostname + '/flow/Prospect_Creation_2?flowLayout=twoColumn';
        component.find("navigationService").navigate({
            type: "standard__webPage",
            attributes: {
                url: flowUrl
            }
        });*/
            
        // var flow = component.find("flow");
        // flow.startFlow("Prospect_Creation_2");
    },

    statusChange : function (component, event) {
       // alert('Flow');
    },

    closeModel: function(component, event, helper) {
        // Set isModalOpen attribute to false
        component.set("v.isModalOpen", false);
        //location.reload();
    }
})