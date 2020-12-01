({
    doInit : function(component, event, helper) {
        helper.helperdoInit(component, event, helper);
    },
    handleApproval : function(component, event, helper) {
        helper.handleApprovalHelper(component, event, helper);
    },
    handleRejection : function(component, event, helper) {
        helper.handleRejectionHelper(component, event, helper);
    },
    handleRequestingInformation : function(component, event, helper) {
        helper.handleRequestingInformationHelper(component, event, helper);   
    }
})