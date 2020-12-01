({
    doInit: function (component, event, helper) {
        component.set("v.DMLApprovalColumns", [
            {
                label: "Date/Time Opened",
                fieldName: "CreatedDate",
                type: "date",
                typeAttributes: {
                    year: "numeric",
                    month: "2-digit",
                    day: "2-digit"
                }
            },
            {
                label: "Support Number",
                fieldName: "CaseId",
                type: "url",
                typeAttributes: { label: { fieldName: "CaseNumber" } }
            },
            { label: "Subject", fieldName: "Subject", type: "text" },
            { label: "Status", fieldName: "Status", type: "text" },
            {
                label: "Support Requestor",
                fieldName: "supportRequestorName",
                type: "text"
            },
            {
                label: "Support Requestor Manager",
                fieldName: "Support_Requestor_Manager__c",
                type: "text"
            },
            {
                label: "L1 Support Rep",
                fieldName: "L1_Support_Rep_Name__c",
                type: "text"
            },
            { label: "Customer ID", fieldName: "CustomerId", type: "text" },
            {
                label: "Account Name",
                fieldName: "AccountId",
                type: "url",
                typeAttributes: { label: { fieldName: "Account__c" } }
            },
            {
                label: "DML ID",
                fieldName: "RelatedDMLNumberId",
                type: "url",
                typeAttributes: { label: { fieldName: "Related_DML_Number__c" } }
            },
            { label: "DML Name", fieldName: "RelatedDMLName", type: "text" }
        ]);

        helper.setup_results_table(component, helper, event);
        helper.validate_search_input(component, helper, event);
        helper.loadDMLApprovalData(component, event, 1);
    },
   
    handle_search_input_change: function(component, event, helper){
        helper.validate_search_input(component, event, helper);
    },
    UpdateSelectedAppRows: function (component, event, helper) {
        var selectedRows = event.getParam("selectedRows");
        var setRows = [];
        for (var i = 0; i < selectedRows.length; i++) {
            setRows.push(selectedRows[i].Id);
        }
        // alert("here"+setRows);
        component.set("v.rowsApprovalSelected", setRows);
    },

    UpdateSelectedRows: function (component, event, helper) {
        component.set("v.requiredRowError", false);
        component.set("v.requiredinputError", false);
        //   component.set("v.validationError",false);
        var selectedRows = event.getParam("selectedRows");
        var setRows = [];
        for (var i = 0; i < selectedRows.length; i++) {
            setRows.push(selectedRows[i].Id);
        }
        // alert("here"+setRows);
        component.set("v.rowsSelected", setRows);
    },

    ReassignSelectedRows: function (component, event, helper) {
        //alert("Inside ReassignSelectedRows");

        if (component.get("v.NewDMLId") == "") {
            component.set("v.requiredinputError", true);
        } else {
            helper.processDML(component, event);
        }
    },
    ReassignDML: function (component, event, helper) {
        if (component.get("v.rowsSelected") == "") {
            component.set("v.requiredRowError", true);
        } else {
            component.set("v.showSearch", true);
            component.set("v.requiredinputError", false);
            component.set("v.validationError", false);
        }
    },
    closeModel: function (cmp, event, helper) {
        cmp.set("v.showSearch", false);
        cmp.set("v.shownotes", false);
        cmp.set("v.validationError", false);
    },

    search_for_dml_data: function (component, event, helper) {
        if (!helper.validate_search_input(component, event, helper))
            return;

        
        component.set("v.validationErrorfinal", false);
        helper.load_dml_relation_data(component, event);
        
    },
    ApproveDML: function (component, event, helper) {
        helper.processApprovalData(component, event);
    },

    handleRowAction: function (component, event, helper) {
        var action = event.getParam("action");
        var row = event.getParam("row");

        component.set("v.selectedRelationId", row.Id);
        helper.processHistoryData(component, event);
    },

    handleRowActionResult: function (component, event, helper) {
        var action = event.getParam("action");
        var row = event.getParam("row");
        component.set("v.selectedRelationId", row.Id);
        helper.processHistoryData(component, event);
    },

    closeModelDML: function (component, event, helper) {
        component.set("v.showModel", false);
        document.body.style.overflow = "auto";
    },

    RejectDML: function (component, event, helper) {
        component.set("v.shownotes", true);
    },

    RejectDMLOK: function (component, event, helper) {
        helper.processRejectedData(component, event);
        component.set("v.shownotes", false);
    },

    showSpinner: function (component, event, helper) {
        if (
            component.get("v.showSearch") == true ||
            component.get("v.showDate") == true
        )
            component.set("v.Spinner", false);
        else component.set("v.Spinner", true);
    },
    hideSpinner: function (component, event, helper) {
        component.set("v.Spinner", false);
    },
    closeModel: function (cmp, event, helper) {
        cmp.set("v.showSearch", false);
        cmp.set("v.shownotes", false);
        cmp.set("v.validationError", false);
        cmp.set("v.showSalesRep", false);
        cmp.set("v.NewDMLIdVal", "");
        cmp.set("v.myDate", "");
        cmp.set("v.showDate", false);
        cmp.set("v.NewSalesId", "");
        cmp.set("v.NewSalesIdVal", "");
        cmp.set("v.segment", false);
        cmp.set("v.myupdateDate", "");
		cmp.set("v.DML.segmentoverride", "");
        cmp.set("v.segment_overide_reason", "")
    },

    updateColumnSorting: function (cmp, event, helper) {
        var fieldName = event.getParam("fieldName");
        var sortDirection = event.getParam("sortDirection");
        cmp.set("v.sortedBy", fieldName);
        cmp.set("v.sortedDirection", sortDirection);
        helper.sortData(cmp, fieldName, sortDirection);
    },
    ReassignSalesRep: function (component, event, helper) {
        if (component.get("v.rowsSelected") == "") {
            component.set("v.requiredRowError", true);
        } else {
            component.set("v.showSalesRep", true);
            component.set("v.requiredinputError", false);
        }
    },
    ReassignSelectedSalesRows: function (component, event, helper) {
           var allValid = [].concat(component.find('inputfield')).reduce(function (validSoFar, inputCmp) {
            	inputCmp.showHelpMessageIfInvalid();
            	return validSoFar && inputCmp.get('v.validity').valid;
        	}, true);
        
           if (allValid) {
            alert('All form entries look valid. Ready to submit!');
            helper.processSalesData(component, event);
            component.set("v.NewSalesId", "");
            component.set("v.NewSalesIdVal", "");
            component.set("v.segment", "");
            component.set("v.DML.segmentoverride", "");
            component.set("v.segment_overide_reason", "");
            component.set("v.myupdateDate", "");
        } else {
            alert('Please update the invalid form entries and try again.');
        }
        /*else {
            helper.processSalesData(component, event);
            component.set("v.NewSalesId", "");
            component.set("v.NewSalesIdVal", "");
            component.set("v.segment", "");
            component.set("v.DML.segmentoverride", "");
            component.set("v.segment_overide_reason", "");
            component.set("v.myupdateDate", "");
            //component.set("v.showErrorsegoverreason",false);
            }*/
    },
    validateSegmentOverrideReason: function(component,event,helper){
        //var selectedValue=component.get("v.DML.segmentoverride");
        var selectedValue=component.find("segmentoverride").get("v.value");
        if(selectedValue== null ||
            selectedValue=="" || 
            selectedValue==undefined )
        {
			//alert(selectedValue);
            //alert("Inside If");
            component.set("v.segmentoverridereasonerror", false);
        }
        else{
           // alert("Inside Else");
            component.set("v.segmentoverridereasonerror", true);
        }
    },
     ReassignDMLDate: function (component, event, helper) {
        if (component.get("v.rowsSelected") == "") {
            component.set("v.requiredRowError", true);
        } else {
            component.set("v.showDate", true);
            component.set("v.requiredinputError", false);
        }
    },
    ReassignSelectedDateRows: function (component, event, helper) {
        if (
            component.get("v.NewDMLIdVal") == "" ||
            component.get("v.myDate") == null ||
            component.get("v.myDate") == undefined ||
            component.get("v.myDate") == ""
        ) {
            component.set("v.requiredinputError", true);
        } else {
            helper.processDateData(component, event);
        }
    },
    navigatetohomepage: function (component, event, helper) {
        window.location =
            "https://officedepot--oduat--c.cs78.visual.force.com/apex/Administration?sfdc.tabName=01rE0000000DB5s";
    },

    handlePaginationEvent: function (component, event, helper) {
        var pageNumber =  event.getParam("page");
        if(event.getParam("name") === 'DML Approvals'){
            component.set("v.page", pageNumber);
            helper.loadDMLApprovalData(component, event, pageNumber);

        }else if(event.getParam("name") === 'DML Update'){
            component.set("v.pageDMLUpdate", pageNumber);
            helper.load_dml_relation_data(component, event);
        }
        
    }
});