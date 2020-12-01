({  
    validate_search_input: function(component, helper, event){
        var grandparent_id_list = component.get("v.grandparent_id_list");
        var parent_id_list = component.get("v.parent_id_list");
        var customer_id_list = component.get("v.customer_id_list");
        var salesrep_id_list = component.get("v.salesrep_id_list");
        var dml_id_list = component.get("v.dml_id_list");
        var dml_name = component.get("v.dml_name");
        var duns_number_list = component.get("v.duns_number_list");
        var segment_overide_reason=component.get("v.segment_overide_reason");
        var segmentoveridepicklist=component.find('segmentoverride');
		var pickvar = component.get("c.getPickListValuesIntoList");
        pickvar.setCallback(this, function(response) {
            var state = response.getState();
            if(state === 'SUCCESS'){
                var list = response.getReturnValue();
                component.set("v.picvalue", list);
            }
            else if(state === 'ERROR'){
                //var list = response.getReturnValue();
                //component.set("v.picvalue", list);
                alert('ERROR OCCURED.');
            }
        })
        $A.enqueueAction(pickvar);
		var picvalue=component.get('v.picvalue');
        
        var selectedvalue=component.get("v.DML.segmentoverride");
		//alert(selectedvalue);
        
        if (grandparent_id_list.trim() !== ""){
            component.set("v.search_input_valid", true);
            return true;
        }
        if (parent_id_list.trim() !== ""){
            component.set("v.search_input_valid", true);
            return true;
        }
        if (customer_id_list.trim() !== ""){
            component.set("v.search_input_valid", true);
            return true;
        }
        if (salesrep_id_list.trim() !== ""){
            component.set("v.search_input_valid", true);
            return true;
        }
        if (dml_id_list.trim() !== ""){
            component.set("v.search_input_valid", true);
            return true;
        }
        if (dml_name.trim() !== ""){
            component.set("v.search_input_valid", true);
            return true;
        }
        if (duns_number_list.trim() !== ""){
            component.set("v.search_input_valid", true);
            return true;
        }
        
        console.log("Input is not valid.");
        component.set("v.search_input_valid", false);
        return false;
    },

    setup_results_table: function(component, event, helper){
        component.set("v.DMLColumns", [
            {
                label: "DML ID",
                fieldName: "DMLFormula__c",
                type: "text",
                sortable: true
            },
            {
                label: "DML Name",
                fieldName: "Decision_Maker_Name__c",
                type: "text",
                sortable: true
            },
            {
                label: "Customer ID",
                fieldName: "CUSTOMERID__c",
                type: "text",
                sortable: true
            },
            {
                label: "Name",
                fieldName: "Customer_Name__c",
                type: "text",
                sortable: true
            },
            {
                label: "RecordType",
                fieldName: "RecordType__c",
                type: "text",
                sortable: true
            },
            {
                label: "Start Date",
                fieldName: "DateFormula__c",
                type: "text",
                sortable: true
            },
            
            {
                label: "Org",
                fieldName: "Org_Name__c",
                type: "text",
                sortable: true
            },
            {
                label: "Parent",
                fieldName: "Parent_Id__c",
                type: "text",
                sortable: true
            },
            {
                label: "Parent Name",
                fieldName: "Parent_Name__c",
                type: "text",
                sortable: true
            },
            {
                label: "Grand Parent",
                fieldName: "GrandParent_Id__c",
                type: "text",
                sortable: true
            },
            {
                label: "Grand Parent Name",
                fieldName: "GrandParent_Name__c",
                type: "text",
                sortable: true
            },
            {
                label: "Sales Rep",
                fieldName: "SalesRepFormula__c",
                type: "text",
                sortable: true
            },
            {
                label: "Teaming Sales Rep",
                fieldName: "Teaming_SalesRepFormula__c",
                type: "text",
                sortable: true
            },
            {
                label: "Segment",
                fieldName: "DML_Segment_Formula__c",
                type: "text",
                sortable: true
            },
            {
                type: "button",
                typeAttributes: {
                    label: "View History",

                    disabled: false,
                    value: "test"
                }
            }
        ]);
    },
    load_dml_relation_data: function (component, event) {
        component.set("v.Spinner", true);
        component.set("v.showSearchData", false);
        component.set("v.showNewData", false);
        component.set("v.showSearch", false);
        component.set("v.showError", false);
        

        var grandparent_id_list = component.get("v.grandparent_id_list");
        var parent_id_list = component.get("v.parent_id_list");
        var customer_id_list = component.get("v.customer_id_list");
        var salesrep_id_list = component.get("v.salesrep_id_list");
        var dml_id_list = component.get("v.dml_id_list");
        var dml_name = component.get("v.dml_name");
        var duns_number_list = component.get("v.duns_number_list");
        
        var grandparent_id_list_json = [],parent_id_list_json = [], customer_id_list_json =[],salesrep_id_list_json =[],dml_id_list_json =[],duns_number_list_json=[];

        if(grandparent_id_list != "")
        grandparent_id_list_json = grandparent_id_list.split(",").map(function(item) {
            return item.trim();
          });
        if(parent_id_list != "")
        parent_id_list_json = parent_id_list.split(",").map(function(item) {
            return item.trim();
          });
        if(customer_id_list != "")
        customer_id_list_json = customer_id_list.split(",").map(function(item) {
            return item.trim();
          });
        if(salesrep_id_list != "")  
        salesrep_id_list_json = salesrep_id_list.split(",").map(function(item) {
            return item.trim();
          });
        if(dml_id_list != "")  
        dml_id_list_json = dml_id_list.split(",").map(function(item) {
            return item.trim();
          });
        //var dml_name = dml_name.split(",").map(function(item) {
            //return item.trim();
          //});
        if(duns_number_list != "")  
        duns_number_list_json = duns_number_list.split(",").map(function(item) {
            return item.trim();
          });


        var action = component.get("c.getDMLRelationData");


		// String customer_id_list_json, 
		// String parent_id_list_json, 
		// String dml_id_list_json,
		// String dml_name, 
		// String sales_rep_id_list_json, 
		// String grandparent_id_list_json,
		// String duns_number_list_json

        action.setParams({
            customer_id_list: customer_id_list_json,
            parent_id_list: parent_id_list_json,
            dml_id_list: dml_id_list_json,
            dml_name: dml_name,
            sales_rep_id_list: salesrep_id_list_json,
            grandparent_id_list: grandparent_id_list_json,
            duns_number_list: duns_number_list_json,
            pageNumber : JSON.stringify(component.get("v.pageDMLUpdate")),
            recordToDisply : JSON.stringify(component.get("v.recordToDisply"))
            
        });

        action.setCallback(this, function (response) {
            var state = response.getState();


            if (state === "SUCCESS") {
                var returnData = response.getReturnValue();

                component.set("v.showSearchData", true);
                component.set("v.showError", true);
                component.set("v.DMLList", returnData.DMLList);
                component.set("v.countDml", returnData.countDml);
                component.set("v.pageDMLUpdate", returnData.page);
                component.set("v.pagesDMLUpdate", Math.ceil(returnData.countDml / component.get("v.recordToDisply")));
                component.set("v.Spinner", false);
            }
            else if (state === "INCOMPLETE") {
                // do something
            }
            else if (state === "ERROR") {
                var errors = response.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        console.log("Error message: " +
                            errors[0].message);
                    }
                } else {
                    console.log("Unknown error");
                }
                component.set("v.Spinner", false);
            }
        });
        $A.enqueueAction(action);
    },

    processData: function (component, event) {
        component.set("v.validationError", false);
        component.set("v.validationErrors", "");
        component.set("v.showSearchData", false);
        component.set("v.showError", false);

        var obj = component.get("v.rowsSelected");
        var action = component.get("c.processDMLRelationData");
        action.setParams({
            InputData: JSON.stringify(obj),
            newDMLId: component.get("v.NewDMLId.Id")
        });

        action.setCallback(this, function (response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var returnData = response.getReturnValue();
                component.set("v.showNewData", true);
                var custs = [];
                var custsmsg;

                for (var key in returnData) {
                    custs.push(returnData[key]);
                    custsmsg = key;
                }
                var ErrorMessage;
                if (custsmsg !== "null") {

                    if (custsmsg.includes("The following error has occurred")) {

                        ErrorMessage = custsmsg;

                    }
                    component.set("v.validationErrorfinal", true);
                    component.set("v.errorMessages", ErrorMessage);
                    component.set("v.showNewData", true);
                    component.set("v.DMLNewList", custs[0]);
                }

                else if (custsmsg == "null") {
                    component.set("v.validationErrorfinal", false);
                    component.set("v.showNewData", true);
                    component.set("v.DMLNewList", custs[0]);
                    component.set("v.NewDMLId", "");
                }
            } else if (state === "INCOMPLETE") {
                // do something
            }
            else if (state === "ERROR") {
                var errors = response.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        console.log("Error message: " +
                            errors[0].message);
                    }
                } else {
                    console.log("Unknown error");
                }
            }
        });
        $A.enqueueAction(action);
    },
    processDML: function (component, event) {
        component.set("v.showError", false);
        var action = component.get("c.processDMLData");
        action.setParams({

            newDMLId: component.get("v.NewDMLId.Id")
        });

        action.setCallback(this, function (response) {
            var state = response.getState();
            var self = this;

            if (state === "SUCCESS") {
                var returnData = response.getReturnValue();
                component.set("v.validationErrors", returnData);
                if (component.get("v.validationErrors") === "SUCCESS") {
                    self.processData(component, event);
                } else if (component.get("v.validationErrors") === "ERROR") {
                    component.set("v.validationError", true);
                    component.set("v.NewDMLId", "");
                }
            } else if (state === "INCOMPLETE") {
                // do something
            }
            else if (state === "ERROR") {
                var errors = response.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        console.log("Error message: " +
                            errors[0].message);
                    }
                } else {
                    console.log("Unknown error");
                }
            }

        });
        $A.enqueueAction(action);
    },

    loadDMLApprovalData: function (component, event, pageNumber) {
        var action = component.get("c.getDMLApprovalData");
        action.setParams({
            pageNumber : JSON.stringify(pageNumber),
            recordToDisply : JSON.stringify(component.get("v.recordToDisply"))
        });
        action.setCallback(this, function (response) {
            var state = response.getState();

            if (state === "SUCCESS") {
                var returnData = response.getReturnValue();
                var caseData =  returnData.cases;
                component.set("v.page", returnData.page);
                component.set("v.total", returnData.total);
                component.set("v.pages", Math.ceil(returnData.total / component.get("v.recordToDisply")));

                if(caseData != undefined && caseData.length >0){
                    caseData.forEach(function (record) {
                        record.CaseId = "/" + record.Id;
                        record.AccountId = "/" + record.Account.Id;
                        record.CustomerId = record.Account.AOPS_Cust_Id__c;
                        record.Account.Related_DML__c != null ? record.RelatedDMLNumberId = "/" + record.Account.Related_DML__r.Id:record.RelatedDMLNumberId="";
                        record.Account.Related_DML__c != null ? record.RelatedDMLName = record.Account.Related_DML__r.DECISION_MAKER_NM__c:record.RelatedDMLName ="";
                        record.Support_Requester__c != null ? record.supportRequestorName = record.Support_Requester__r.Name: record.supportRequestorName ="";
                    });
                }   

                component.set("v.DMLApprovalList", caseData);
            } else if (state === "INCOMPLETE") {
                // do something
            }
            else if (state === "ERROR") {
                var errors = response.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        console.log("Error message: " +
                            errors[0].message);
                    }
                } else {
                    console.log("Unknown error");
                }
            }
        });
        $A.enqueueAction(action);
    },

    processApprovalData: function (component, event) {
        var obj = component.get("v.rowsApprovalSelected");
        var action = component.get("c.processDMLApproval");
        action.setParams({
            InputData: JSON.stringify(obj),
            pageNumber : JSON.stringify(component.get("v.page")),
            recordToDisply : JSON.stringify(component.get("v.recordToDisply"))
        });

        action.setCallback(this, function (response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var returnData = response.getReturnValue();               
                var caseData =  returnData.cases;
                component.set("v.page", returnData.page);
                component.set("v.total", returnData.total);
                component.set("v.pages", Math.ceil(returnData.total / component.get("v.recordToDisply")));

                if(caseData != undefined && caseData.length >0){

                        caseData.forEach(function (record) {
                        record.CaseId = "/" + record.Id;
                        record.AccountId = "/" + record.Account.Id;
                        record.RelatedDMLNumberId = "/" + record.Account.Related_DML__r.Id;
                        record.CustomerId = record.Account.AOPS_Cust_Id__c;
                        record.supportRequestorName = record.Support_Requester__r.Name;
                        record.RelatedDMLName =
                            record.Account.Related_DML__r.DECISION_MAKER_NM__c;
                    });
                }
                component.set("v.DMLApprovalList", caseData);
            } else if (state === "INCOMPLETE") {
                // do something
            }
            else if (state === "ERROR") {
                var errors = response.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        console.log("Error message: " +
                            errors[0].message);
                    }
                } else {
                    console.log("Unknown error");
                }
            }
        });
        $A.enqueueAction(action);
    },

    processRejectedData: function (component, event) {

        var obj1 = component.get("v.rowsApprovalSelected");
        var Notes1 = component.find("notes");
        var Notes = Notes1.get("v.value");
        var action = component.get("c.processDMLRejection");
        action.setParams({
            InputData: JSON.stringify(obj1),
            Notes: Notes,
            pageNumber : JSON.stringify(component.get("v.page")),
            recordToDisply : JSON.stringify(component.get("v.recordToDisply"))
        });

        action.setCallback(this, function (response) {
            var state = response.getState();
            if (state === "SUCCESS") {              
                var returnData = response.getReturnValue();               
                var caseData =  returnData.cases;
                component.set("v.page", returnData.page);
                component.set("v.total", returnData.total);
                component.set("v.pages", Math.ceil(returnData.total / component.get("v.recordToDisply")));

                if(caseData != undefined && caseData.length >0){
                    caseData.forEach(function (record) {
                    record.CaseId = "/" + record.Id;
                    record.AccountId = "/" + record.Account.Id;
                    record.RelatedDMLNumberId = "/" + record.Account.Related_DML__r.Id;
                    record.CustomerId = record.Account.AOPS_Cust_Id__c;
                    record.supportRequestorName = record.Support_Requester__r.Name;
                    record.RelatedDMLName =
                        record.Account.Related_DML__r.DECISION_MAKER_NM__c;
                });
            }
            component.set("v.DMLApprovalList", caseData);
            } else if (state === "INCOMPLETE") {
                // do something
            }
            else if (state === "ERROR") {
                var errors = response.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        console.log("Error message: " +
                            errors[0].message);
                    }
                } else {
                    console.log("Unknown error");
                }
            }
        });
        $A.enqueueAction(action);
    },

    sortData: function (component, fieldName, sortDirection) {
        var data = component.get("v.DMLList");
        var reverse = sortDirection !== "asc";
        data.sort(this.sortBy(fieldName, reverse));
        component.set("v.DMLList", data);
    },
    sortBy: function (field, reverse, primer) {
        var key = primer
            ? function (x) {
                return primer(
                    x.hasOwnProperty(field)
                        ? typeof x[field] === "string"
                            ? x[field].toLowerCase()
                            : x[field]
                        : "aaa"
                );
            }
            : function (x) {
                return x.hasOwnProperty(field)
                    ? typeof x[field] === "string"
                        ? x[field].toLowerCase()
                        : x[field]
                    : "aaa";
            };
        reverse = !reverse ? 1 : -1;
        return function (a, b) {
            return (
                (a = key(a) ? key(a) : ""),
                (b = key(b) ? key(b) : ""),
                reverse * ((a > b) - (b > a))
            );
        };
    },
    processSalesData: function (component, event) {
        component.set("v.Spinner", true);
        component.set("v.validationError", false);
        component.set("v.validationErrors", "");
        component.set("v.showSearchData", false);
        component.set("v.showSalesRep", false);
        component.set("v.showError", false);
        component.set("v.segmentoverridereasonerror", false);
        component.set("v.requiredinputError", false);

        var obj = component.get("v.rowsSelected");
        var newid = component.get("v.segment");
        if (newid == "" || newid == null || newid == undefined || newid == "")
            newid = null;

        var action = component.get("c.processDMLRelationDataSalesRep");
        action.setParams({
            InputData: JSON.stringify(obj),
            newDMLId: component.get("v.NewSalesId.Id"),
            Segment: newid,
            newDMLIdVal: component.get("v.NewSalesIdVal.Id"),
            ProposedDate: component.get("v.myupdateDate"),
			Segmentoverride:component.get("v.DML.segmentoverride"),
			segmentoverridereason:component.get("v.segment_overide_reason")
			
        });
		
        action.setCallback(this, function (response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var returnData = response.getReturnValue();

                component.set("v.showNewData", true);
                component.set("v.DMLNewList", returnData);
                component.set("v.NewSalesId", "");
                component.set("v.NewSalesIdVal", "");
                component.set("v.segment", "");

                this.sortData(component, component.get("v.sortedBy"), component.get("v.sortedDirection"));
                component.set("v.Spinner", false);
            } else if (state === "INCOMPLETE") {
                // do something
            }
            else if (state === "ERROR") {
                var errors = response.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        console.log("Error message: " +
                            errors[0].message);
                    }
                } else {
                    console.log("Unknown error");
                }
                component.set("v.Spinner", false);
            }
        });
        $A.enqueueAction(action);
    },

    processDMLDateData: function (component, event) {
        //component.set("v.Spinner", true);
        component.set("v.validationError", false);
        component.set("v.validationErrors", "");
        component.set("v.showSearchData", false);
        component.set("v.showError", false);

        var obj = component.get("v.rowsSelected");
        var action = component.get("c.processDMLRelationDate");

        action.setParams({
            InputData: JSON.stringify(obj),
            newDMLId: component.get("v.NewDMLIdVal.Id"),
            DateVal: component.get("v.myDate")
        });

        action.setCallback(this, function (response) {
            var state = response.getState();


            if (state === "SUCCESS") {
                var returnData = response.getReturnValue();

                component.set("v.showNewData", true);
                var custs = [];
                var custsmsg;

                for (var key in returnData) {
                    if(returnData[key] && returnData[key].length >0){
                        custs.push(returnData[key]);
                        custsmsg = key;
                    }                    
                }

                var ErrorMessage;
                if (custsmsg === "error") {
                    if (custsmsg.includes("The following error has occurred")) {
                        ErrorMessage = custsmsg;
                    }
                    component.set("v.validationErrorfinal", true);
                    component.set("v.errorMessages", ErrorMessage);
                    component.set("v.showNewData", true);
                    component.set("v.DMLNewList", custs[0]);
                    component.set("v.showDate", false);
                    component.set("v.Spinner", false);
                }
                else if (custsmsg === "success") {
                    component.set("v.validationErrorfinal", false);
                    component.set("v.showNewData", true);
                    component.set("v.DMLNewList", custs[0]);
                    component.set("v.showDate", false);
                    component.set("v.NewDMLIdVal", "");
                    component.set("v.myDate", "");
                    component.set("v.Spinner", false);
                }
               
            } else if (state === "INCOMPLETE") {
                // do something
            }
            else if (state === "ERROR") {
                var errors = response.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        console.log("Error message: " +
                            errors[0].message);
                    }
                } else {
                    console.log("Unknown error");
                }
                component.set("v.Spinner", false);
            }
        });
        $A.enqueueAction(action);
    },

    processDateData: function (component, event) {
        component.set("v.Spinner", true);
        var action = component.get("c.processDMLData");
        action.setParams({
            newDMLId: component.get("v.NewDMLIdVal.Id")
        });

        action.setCallback(this, function (response) {
            var state = response.getState();
            var self = this;

            if (state === "SUCCESS") {
                var returnData = response.getReturnValue();
                component.set("v.validationErrors", returnData);
                if (component.get("v.validationErrors") === "SUCCESS") {
                    self.processDMLDateData(component, event);
                } else if (component.get("v.validationErrors") === "ERROR") {
                    component.set("v.Spinner", false);
                    component.set("v.validationError", true);
                    component.set("v.NewDMLIdVal", "");
                    component.set("v.myDate", "");
                }
                
            } else if (state === "INCOMPLETE") {
                // do something
            }
            else if (state === "ERROR") {
                var errors = response.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        console.log("Error message: " +
                            errors[0].message);
                    }
                } else {
                    console.log("Unknown error");
                }
                component.set("v.Spinner", false);
            }
        });
        $A.enqueueAction(action);
    },

    processHistoryData: function (component, event) {
        var selectedRec = component.get("v.selectedRelationId");
        if (selectedRec != null) {
            var action = component.get("c.getDMLRelationHistory");
            action.setParams({ DMLRelId: component.get("v.selectedRelationId") });
            action.setCallback(this, function (response) {
                var state = response.getState();
                if (state == "SUCCESS") {
                    var returnData = response.getReturnValue();
                    component.set("v.relationColumns", [
                        {
                            label: "DML ID",
                            initialWidth: "100px",
                            fieldName: "DML_ID__c",
                            type: "text"
                        },
                        {
                            label: "Customer ID",
                            initialWidth: "350px",
                            fieldName: "CUSTOMERID__c",
                            type: "text"
                        },
                        {
                            label: "Start Date",
                            initialWidth: "200px",
                            fieldName: "Effective_Start_Date__c",
                            type: "date",
                            typeAttributes: {
                                year: "numeric",
                                month: "2-digit",
                                day: "2-digit"
                            }
                        },
                        {
                            label: "End Date",
                            initialWidth: "150px",
                            fieldName: "Effective_End_Date__c",
                            type: "date",
                            typeAttributes: {
                                year: "numeric",
                                month: "2-digit",
                                day: "2-digit"
                            }
                        }
                    ]);
                    component.set("v.showModel", true);
                    component.set("v.dmlRelationList", returnData);
                } else if (state === "INCOMPLETE") {
                    // do something
                }
                else if (state === "ERROR") {
                    var errors = response.getError();
                    if (errors) {
                        if (errors[0] && errors[0].message) {
                            console.log("Error message: " +
                                errors[0].message);
                        }
                    } else {
                        console.log("Unknown error");
                    }
                }
            });
            $A.enqueueAction(action);
        }
    }
});