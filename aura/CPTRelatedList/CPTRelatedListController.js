({
    doInit: function(component, event, helper) {
        // Fetch the account list from the Apex controller
        helper.getAccountList(component);
    },
    
    goToCPT: function(component, event, helper) {
        var navigateEvent = $A.get("e.force:navigateToComponent");
        navigateEvent.setParams({
            componentDef: "c:ContractPricingTermsEditPage",
            componentAttributes :{
                parentrecordId : component.get("v.recordId"),
                Displaymode: 'View',
                recordId: event.target.id
                
            }
        });
        navigateEvent.fire();
    },
    createNewCPT: function(component, event, helper) {
        
        var navigateEvent = $A.get("e.force:navigateToComponent");
        navigateEvent.setParams({
            componentDef: "c:ContractPricingTermsEditPage",
            componentAttributes :{
                parentrecordId : component.get("v.recordId"),
                Displaymode: 'Edit'
            }
        });
        navigateEvent.fire();
    },
    handleMenuSelect: function(component, event, helper) {
        var selectedMenu = event.detail.menuItem.get("v.value");
        var tempid = event.getSource().get("v.class");
        
        switch(selectedMenu) {
            case "EDIT":
                var navigateEvent = $A.get("e.force:navigateToComponent");
                navigateEvent.setParams({
                    componentDef: "c:ContractPricingTermsEditPage",
                    componentAttributes :{
                        parentrecordId : component.get("v.recordId"),
                        Displaymode: 'Edit',
                        recordId: tempid,
                        Newsave: 'exist'
                        
                    }
                });
                navigateEvent.fire();
                break;
            case "delete":
                alert("Do you want to delete this CPT");
                var action = component.get('c.deleteCPT');
                
                action.setParams({ cptId : tempid });
                
                action.setCallback(this, function(response) {
                    var state = response.getState();
                    
                    if(state == 'SUCCESS'){
                        window.location.reload();
                    }
                }); 
                $A.enqueueAction(action);
                break;
        }
    }
})