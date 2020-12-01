({
    //Handle Next button on Bill To section
    doNextBillTo: function (cmp) {
        var inputData = cmp.get("v.accRec");
        var formattedData = JSON.stringify(inputData);
        var action = cmp.get("c.commitAccountSetupRequest");
        action.setParams({
            updatedRecords: formattedData
        });
        action.setCallback(this, function (response) {
            var spinner = cmp.find("mySpinner");
            var state = response.getState();

            if (state === 'SUCCESS'){
                $A.util.addClass(spinner, "slds-hide");
                var appEvent = $A.get("e.c:ProcessIndicatorEvent");
                appEvent.setParams({
                    currentStep: "Ship To Information"
                });
                appEvent.fire();
                cmp.set("v.showBillTo", false);
                cmp.set("v.showShipTo", true);
            } else if (state === "INCOMPLETE") {
            }
            else if (state === "ERROR") {
                cmp.set("v.Spinner", false);
                cmp.set("v.validationError", true);
                var errors = response.getError();
                
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        console.error("Error message: " + 
                                 errors[0].message);
                    }
                    cmp.set("v.errorMessages", errors[0].message);
                } else {
                    console.error("Unknown error");
                    cmp.set("v.errorMessages", 'Looks like an error occurred while saving the Account Setup Request. If the error persists, please put in a Support Ticket with the subject: Request customer setup is not functioning');

                }
            }
        });
        $A.enqueueAction(action);
    },

    //Handle Next button on Ship To section
    doNextShipTo: function (cmp) {
        var inputData = cmp.get("v.accRec");
        var formattedData = JSON.stringify(inputData);
        var action = cmp.get("c.commitAccountSetupRequest");
        action.setParams({
            updatedRecords: formattedData
        });
        action.setCallback(this, function (response) {
            var state = response.getState();
            if (state === 'SUCCESS'){
                var appEvent = $A.get("e.c:ProcessIndicatorEvent");
                appEvent.setParams({
                    currentStep: "Primary Contact Information"
                });
                appEvent.fire();
                cmp.set("v.showBillTo", false);
                cmp.set("v.showShipTo", false);
                cmp.set("v.showPrimaryContact", true);

            } else if (state === "INCOMPLETE") {
            }
            else if (state === "ERROR") {
                cmp.set("v.Spinner", false);
                cmp.set("v.validationError", true);
                var errors = response.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        console.error("Error message: " + 
                                 errors[0].message);
                    }
                    cmp.set("v.errorMessages", errors[0].message);
                } else {
                    console.error("Unknown error");
                    cmp.set("v.errorMessages", 'Looks like an error occurred while saving the Account Setup Request. If the error persists, please put in a Support Ticket with the subject: Request customer setup is not functioning');

                }
            }
        });
        $A.enqueueAction(action);
    },

    //Handle Back button on Ship To section
    doBackShipTo: function (cmp) {
        var appEvent = $A.get("e.c:ProcessIndicatorEvent");
        appEvent.setParams({
            currentStep: "Bill To Information"
        });
        appEvent.fire();
        cmp.set("v.showBillTo", true);
        cmp.set("v.showShipTo", false);
        cmp.set("v.showPrimaryContact", false);
    },

    // Next Button on Contact Section
    doNextContact: function (cmp) {
        var inputData = cmp.get("v.accRec");
        var formattedData = JSON.stringify(inputData);
        var action = cmp.get("c.commitAccountSetupRequest");
        action.setParams({
            updatedRecords: formattedData
        });
        action.setCallback(this, function (response) {

            var state = response.getState();
            if (state === 'SUCCESS'){
                var appEvent = $A.get("e.c:ProcessIndicatorEvent");
                    appEvent.setParams({
                    currentStep: "Billing Preferences"
                });
                appEvent.fire();
                cmp.set("v.showBillTo", false);
                cmp.set("v.showShipTo", false);
                cmp.set("v.showPrimaryContact", false);
                cmp.set("v.showBillingPref", true);

            } else if (state === "INCOMPLETE") {
            }
            else if (state === "ERROR") {
                cmp.set("v.Spinner", false);
                cmp.set("v.validationError", true);
                var errors = response.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        console.error("Error message: " + 
                                 errors[0].message);
                    }
                    cmp.set("v.errorMessages", errors[0].message);
                } else {
                    console.error("Unknown error");
                    cmp.set("v.errorMessages", 'Looks like an error occurred while saving the Account Setup Request. If the error persists, please put in a Support Ticket with the subject: Request customer setup is not functioning');

                }
            }
        });
        $A.enqueueAction(action);
    },

    // Back  Button on Contact Section
    doBackContact: function (cmp) {
        var appEvent = $A.get("e.c:ProcessIndicatorEvent");
        appEvent.setParams({
            currentStep: "Ship To Information"
        });
        appEvent.fire();
        cmp.set("v.showBillTo", false);
        cmp.set("v.showShipTo", true);
        cmp.set("v.showPrimaryContact", false);
        cmp.set("v.showBillingPref", false);
    },

    //Next Button on Billing Preference
    doNextBillPref: function (cmp) {
        var inputData = cmp.get("v.accRec");
        var formattedData = JSON.stringify(inputData);
        var action = cmp.get("c.commitAccountSetupRequest");
        action.setParams({
            updatedRecords: formattedData
        });
        action.setCallback(this, function (response) {
            var state = response.getState();
            if (state === 'SUCCESS'){
                var appEvent = $A.get("e.c:ProcessIndicatorEvent");
                appEvent.setParams({
                    currentStep: "Tax Section"
                });
                appEvent.fire();
                cmp.set("v.showBillTo", false);
                cmp.set("v.showShipTo", false);
                cmp.set("v.showPrimaryContact", false);
                cmp.set("v.showBillingPref", false);
                cmp.set("v.showTax", true);
            } else if (state === "INCOMPLETE") {
            }
            else if (state === "ERROR") {
                cmp.set("v.Spinner", false);
                cmp.set("v.validationError", true);
                var errors = response.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        console.error("Error message: " + 
                                 errors[0].message);
                    }
                    cmp.set("v.errorMessages", errors[0].message);
                } else {
                    console.error("Unknown error");
                    cmp.set("v.errorMessages", 'Looks like an error occurred while submitting the Account Setup Request. If the error persists, please put in a Support Ticket with the subject: Request customer setup is not functioning');

                }
            }
        });
        $A.enqueueAction(action);
    },

    //Back  Button on Billing Preference
    doBackBillPref: function (cmp) {
        var appEvent = $A.get("e.c:ProcessIndicatorEvent");
        appEvent.setParams({
            currentStep: "Primary Contact Information"
        });
        appEvent.fire();
        cmp.set("v.showBillTo", false);
        cmp.set("v.showShipTo", false);
        cmp.set("v.showPrimaryContact", true);
        cmp.set("v.showBillingPref", false);
        cmp.set("v.showTax", false);
    },
    doNextTax: function (cmp) {
        var inputData = cmp.get("v.accRec");
        var formattedData = JSON.stringify(inputData);
        var action = cmp.get("c.commitAccountSetupRequest");
        action.setParams({
            updatedRecords: formattedData
        });
        action.setCallback(this, function (response) {
            var state = response.getState();
            if (state === 'SUCCESS'){
                var appEvent = $A.get("e.c:ProcessIndicatorEvent");
                appEvent.setParams({
                    currentStep: "Submit Request"
                });
                appEvent.fire();
                cmp.set("v.showBillTo", false);
                cmp.set("v.showShipTo", false);
                cmp.set("v.showPrimaryContact", false);
                cmp.set("v.showBillingPref", false);
                cmp.set("v.showTax", false);
                cmp.set("v.showSubmitRequest", true);
            } else if (state === "INCOMPLETE") {
            }
            else if (state === "ERROR") {
                cmp.set("v.Spinner", false);
                cmp.set("v.validationError", true);
                var errors = response.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        console.error("Error message: " + 
                                 errors[0].message);
                    }
                    cmp.set("v.errorMessages", errors[0].message);
                } else {
                    console.error("Unknown error");
                    cmp.set("v.errorMessages", 'Looks like an error occurred while submitting the Account Setup Request. If the error persists, please put in a Support Ticket with the subject: Request customer setup is not functioning');

                }
            }
        });
        $A.enqueueAction(action);
    },
    dotaxexempt: function (cmp) {
        var inputData = cmp.get("v.accRec");
        var selectedstates = inputData.Tax_Exempt_States__c;
        var allstates = cmp.get('v.States');

        var action = cmp.get("c.getStatesMap");
        action.setParams({
            allStates: JSON.stringify(allstates),
            selectedStates: JSON.stringify(selectedstates)
        });
        action.setCallback(this, function (response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var custs = [];
                var conts = response.getReturnValue();
                for (var key in conts) {
                    custs.push({
                        value: conts[key],
                        key: key
                    });
                }
                cmp.set("v.checkboxValueMap", custs);

            } else if (state === "INCOMPLETE") {
            }
            else if (state === "ERROR") {
                cmp.set("v.Spinner", false);
                cmp.set("v.validationError", true);
                var errors = response.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        console.error("Error message: " + 
                                 errors[0].message);
                    }
                    cmp.set("v.errorMessages", errors[0].message);
                } else {
                    console.error("Unknown error");
                    cmp.set("v.errorMessages", 'Looks like an error occurred while submitting the Account Setup Request. If the error persists, please put in a Support Ticket with the subject: Request customer setup is not functioning');

                }
            }
        });
        $A.enqueueAction(action);
    },
    //Back  Button on Billing Preference
    doBackTax: function (cmp) {
        var appEvent = $A.get("e.c:ProcessIndicatorEvent");
        appEvent.setParams({
            currentStep: "Billing Preferences"
        });
        appEvent.fire();
        cmp.set("v.showBillTo", false);
        cmp.set("v.showShipTo", false);
        cmp.set("v.showPrimaryContact", false);
        cmp.set("v.showBillingPref", true);
        cmp.set("v.showTax", false);
        cmp.set("v.showSubmitRequest", false);
    },
    doBackSubmit: function (cmp) {
        cmp.set("v.dmlRec.DECISION_MAKER_NM__c", '');
        cmp.set("v.dmlRec.Notes__c", '');
        cmp.set("v.dmlRec.Reason_for_Creation__c", '');
        cmp.set("v.dmlRec.DECISION_MAKER_SEGMENT__c", '');
        cmp.set("v.dmlRec.DECISION_MAKER_ZIP_CD__c", '');
        cmp.set("v.ALT", false);
        var appEvent = $A.get("e.c:ProcessIndicatorEvent");
        appEvent.setParams({
            currentStep: "Tax Section"
        });
        appEvent.fire();
        cmp.set("v.showBillTo", false);
        cmp.set("v.showShipTo", false);
        cmp.set("v.showPrimaryContact", false);
        cmp.set("v.showBillingPref", false);
        cmp.set("v.showTax", true);
        cmp.set("v.showSubmitRequest", false);
    },

    doInit: function (cmp) {
        cmp.set("v.showBillTo", true);
        cmp.set("v.showShipTo", false);
        cmp.set("v.showPrimaryContact", false);
        cmp.set("v.showBillingPref", false);
        cmp.set("v.showSubmitRequest", false);

        var spinner = cmp.find("mySpinner");
        $A.util.removeClass(spinner, "slds-hide");

        var action = cmp.get("c.getAccountData");

        var OppId = cmp.get("v.subrecordIdLocator");

        if(OppId === null || OppId === '' || OppId ==='undefined'){
            console.error('Opportunity Id from Subrecord Id is invalid.');
            console.error('Opportunity Id: ' + OppId);
            return;
        }

        action.setParams({
            OppId: OppId
        });

        action.setCallback(this, function (response) {
            var state = response.getState();

            if (state === "SUCCESS") {
                cmp.set("v.accRec", response.getReturnValue());
                var spinner = cmp.find("mySpinner");
                $A.util.addClass(spinner, "slds-hide");
            }else if (state === "INCOMPLETE") {
            }
            else if (state === "ERROR") {
                cmp.set("v.Spinner", false);
                cmp.set("v.validationError", true);
                var errors = response.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        console.error("Error message: " + 
                                 errors[0].message);
                    }
                    cmp.set("v.errorMessages", errors[0].message);
                } else {
                    console.error("Unknown error");
                    cmp.set("v.errorMessages", 'Looks like an error occurred while preparing the Account Setup Request. If the error persists, please put in a Support Ticket with the subject: Request customer setup is not functioning');

                }
            }
        });
        $A.enqueueAction(action);
    },
     /*doConvProsCheck: function (cmp) {

        var OppId = cmp.get("v.subrecordIdLocator");
        if(OppId === null || OppId === '' || OppId ==='undefined'){
            console.error('Opportunity Id from Subrecord Id is invalid.');
            console.error('Opportunity Id: ' + OppId);
            return;
        }
        var action = cmp.get("c.getSpclOppCheck");

        action.setParams({
            OppId: OppId
        });

        action.setCallback(this, function (response) {
            var spinner = cmp.find("mySpinner");
            var state = response.getState();
            if (state === "SUCCESS") {
               this.doInitValidate(cmp);
                $A.util.addClass(spinner, "slds-hide");
            } else if (state === "INCOMPLETE") {
            }
            else if (state === "ERROR") {
                cmp.set("v.Spinner", false);
                var errors = response.getError();
                if (errors) {
                    ///*if (errors[0] && errors[0].message) {
                    //    console.error("Error message: " + 
                    //             errors[0].message);
                    //}
                    //cmp.set("v.errorMessages", errors[0].message);
                } else {
                    console.error("Unknown error");
                    cmp.set("v.errorMessages", 'Looks like an error occurred while Converting PPE to Prospect the Account Setup Request. If the error persists, please put in a Support Ticket with the subject: Request customer setup is not functioning');

                }
            }
        });
        $A.enqueueAction(action);
    },*/


    doInitValidate: function (cmp) {

        var OppId = cmp.get("v.subrecordIdLocator");
        if(OppId === null || OppId === '' || OppId ==='undefined'){
            console.error('Opportunity Id from Subrecord Id is invalid.');
            console.error('Opportunity Id: ' + OppId);
            return;
        }
        var action = cmp.get("c.getDataValidate");

        action.setParams({
            OppId: OppId
        });

        action.setCallback(this, function (response) {
            var spinner = cmp.find("mySpinner");
            var state = response.getState();
            if (state === "SUCCESS") {
                this.doInit(cmp);
                $A.util.addClass(spinner, "slds-hide");
            } else if (state === "INCOMPLETE") {
            }
            else if (state === "ERROR") {
                cmp.set("v.Spinner", false);
                var errors = response.getError();
                if (errors) {
                } else {
                    console.error("Unknown error");
                    cmp.set("v.errorMessages", 'Looks like an error occurred while validating the Account Setup Request. If the error persists, please put in a Support Ticket with the subject: Request customer setup is not functioning');

                }
            }
        });
        $A.enqueueAction(action);
    },

    //Submit Account Request Button
    sendProspect: function (cmp) {
        cmp.set("v.showBillTo", false);
        cmp.set("v.showShipTo", false);
        cmp.set("v.showPrimaryContact", false);
        cmp.set("v.showBillingPref", false);
        cmp.set("v.showSubmitRequest", false);
        cmp.set("v.accRec.Survey_Complete__c", true);
        var inputData = cmp.get("v.accRec");
        var formattedData = JSON.stringify(inputData);
        cmp.set("v.requiredError", true);

        var action = cmp.get("c.SubmitProspect");
        action.setParams({
            updatedRecords: formattedData,
            fileName: cmp.get("v.fileName"),
            base64Data: cmp.get("v.base64Data"),
            contentType: cmp.get("v.contentType")
        });
        action.setCallback(this, function (response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var result = response.getReturnValue();
                cmp.set("v.Spinner", false);
                var appEvent = $A.get("e.c:ProcessIndicatorEvent");
                appEvent.setParams({
                    currentStep: "Submitted"
                });
                appEvent.fire();
                cmp.set("v.isRecordCreated", true);
                var recid = cmp.get("v.subrecordIdLocator")
                window.open('/' + recid, '_self');
                
            } else if (state === "INCOMPLETE") {
            }
            else if (state === "ERROR") {
                cmp.set("v.Spinner", false);
                cmp.set("v.validationError", true);
                var errors = response.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        console.error("Error message: " + 
                                 errors[0].message);
                    }
                    cmp.set("v.errorMessages", errors[0].message);
                } else {
                    console.error("Unknown error");
                    cmp.set("v.errorMessages", 'Looks like an error occurred while submitting the Account Setup Request. If the error persists, please put in a Support Ticket with the subject: Request customer setup is not functioning');

                }
            }
        });
        $A.enqueueAction(action);
    },
    EmailValid: function (cmp) {
        var val = cmp.get("v.accRec.Primary_Contact_Email__c");
        var val2 = cmp.get("v.accRec.AP_Contact_Email__c");
        var re = /^(([^<>()\[\]\\.,;:\s@"]+(\.[^<>()\[\]\\.,;:\s@"]+)*)|(".+"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$/
        if (!$A.util.isEmpty(val)) {
            if (val.match(re)) {
                var splitArray = val.split('@');
                if (val.indexOf('@officedepot.com') !== -1) {
                    $A.util.addClass(cmp.find("fteError"), "show");
                    cmp.set("v.ODEmailError", false);
                } else {
                    cmp.set("v.ODEmailError", true);
                }
            } else {
                $A.util.removeClass(cmp.find("fteError"), "show");
                cmp.set("v.ODEmailError", false);
            }
        } else {
            $A.util.addClass(cmp.find("fteError"), "show");
            cmp.set("v.ODEmailError", false);
        }
    },

    PhoneValid: function (cmp) {
        var val = cmp.get("v.accRec.Account_Phone__c");
        var re = '^\\([0-9]{3}\\) [0-9]{3}-[0-9]{4}$'
        if (!$A.util.isEmpty(val)) {
            if (val.match(re)) {
                cmp.set("v.BillToError", true);

            } else {
                $A.util.addClass(cmp.find("fteErrorP1"), "show");
                cmp.set("v.BillToError", false);
            }
        } else {
            $A.util.addClass(cmp.find("fteErrorP"), "show");
            cmp.set("v.BillToError", false);
        }
    },
    formatPhoneNumber: function (component, phone) {
        var s2 = ("" + phone).replace(/\D/g, '');
        var l = s2.length;
        // Trim the remaining input to ten characters, to preserve phone number format
        s2 = s2.substring(l - 10, l);
        // Based upon the length of the string, we add formatting as necessary
        var size = s2.length;
        if (size === 0) {
            s2 = s2;
        } else if (size < 4) {
            s2 = '(' + s2;
        } else if (size < 7) {
            s2 = '(' + s2.substring(0, 3) + ') ' + s2.substring(3, 6);
        } else {
            s2 = '(' + s2.substring(0, 3) + ') ' + s2.substring(3, 6) + '-' + s2.substring(6, 10);
        }
        return s2;
    },
    PhoneValid1: function (cmp) {
        var val = cmp.get("v.accRec.Primary_Contact_Phone__c");
        var re = '^\\([0-9]{3}\\) [0-9]{3}-[0-9]{4}$'
        if (!$A.util.isEmpty(val)) {
            if (val.match(re)) {
                cmp.set("v.BillToError1", true);
            } else {
                $A.util.addClass(cmp.find("fteErrorP2"), "show");
                cmp.set("v.BillToError1", false);
            }
        } else {
            $A.util.addClass(cmp.find("fteErrorPCon"), "show");
            cmp.set("v.BillToError1", false);
        }
    },
    PhoneValidBill1: function (cmp) {
        var val = cmp.get("v.accRec.AP_Contact_Phone__c");
        var re = '^\\([0-9]{3}\\) [0-9]{3}-[0-9]{4}$'

        if (!$A.util.isEmpty(val)) {
            if (val.match(re)) {
                cmp.set("v.BillToErrorAP", true);
            } else {
                $A.util.addClass(cmp.find("fteErrorP3"), "show");
                cmp.set("v.BillToErrorAP", false);
            }
        } else {
            $A.util.addClass(cmp.find("fteErrorPCon"), "show");
            cmp.set("v.BillToErrorAP", false);
        }
    },
    PhoneValidBill2: function (cmp) {
        var val = cmp.get("v.accRec.eBilling_Contact_Phone__c");
        var re = '^\\([0-9]{3}\\) [0-9]{3}-[0-9]{4}$'
        if (!$A.util.isEmpty(val)) {
            if (val.match(re)) {
                cmp.set("v.BillToErrorE1", true);
            } else {
                $A.util.addClass(cmp.find("fteErrorP4"), "show");
                cmp.set("v.BillToErrorE1", false);
            }
        } else {
            $A.util.addClass(cmp.find("fteErrorPCon"), "show");
            cmp.set("v.BillToErrorE1", false);
        }
    },
    PhoneValidBill3: function (cmp) {
        var val = cmp.get("v.accRec.eBilling_Contact_Phone2__c");
        var re = '^\\([0-9]{3}\\) [0-9]{3}-[0-9]{4}$'

        if (!$A.util.isEmpty(val)) {
            if (val.match(re)) {
                cmp.set("v.BillToErrorE2", true);
            } else {
                $A.util.addClass(cmp.find("fteErrorP5"), "show");
                cmp.set("v.BillToErrorE2", false);
            }
        } else {
            $A.util.addClass(cmp.find("fteErrorPCon"), "show");
            cmp.set("v.BillToErrorE2", false);
        }
    },

    FaxValid: function (cmp) {
        var val = cmp.get("v.accRec.AP_Contact_Fax__c");
        var re = '^\\([0-9]{3}\\) [0-9]{3}-[0-9]{4}$'

        if (!$A.util.isEmpty(val)) {
            if (val.match(re)) {
                cmp.set("v.BillToErrorFax", true);
            } else {
                $A.util.addClass(cmp.find("fteErrorFax"), "show");
                cmp.set("v.BillToErrorFax", false);
            }
        } else {
            cmp.set("v.BillToErrorFax", true);
        }
    },
    FaxValid1: function (cmp) {
        var val = cmp.get("v.accRec.Primary_Contact_Fax__c");
        var re = '^\\([0-9]{3}\\) [0-9]{3}-[0-9]{4}$'

        if (!$A.util.isEmpty(val)) {
            if (val.match(re)) {
                cmp.set("v.BillToErrorFax1", true);
            } else {
                $A.util.addClass(cmp.find("fteErrorFax1"), "show");
                cmp.set("v.BillToErrorFax1", false);
            }
        } else {
            cmp.set("v.BillToErrorFax1", true);
        }
    },

    selectDML: function (cmp) {
        var OppId = cmp.get("v.subrecordIdLocator");
        var action = cmp.get("c.getDMLData");
        if(OppId === null || OppId === '' || OppId ==='undefined'){
            console.error('Opportunity Id from Subrecord Id is invalid.');
            console.error('Opportunity Id: ' + OppId);
            return;
        }
        action.setParams({
            OppId: OppId
        });
        action.setCallback(this, function (response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var custs = [];
                var conts = response.getReturnValue();
                for (var key in conts) {
                    custs.push({
                        value: key,
                        key: conts[key]
                    });
                }
                cmp.set("v.DML", custs);

            } else if (state === "INCOMPLETE") {
            }
            else if (state === "ERROR") {
                cmp.set("v.Spinner", false);
                cmp.set("v.validationError", true);
                var errors = response.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        console.error("Error message: " + 
                                 errors[0].message);
                    }
                    cmp.set("v.errorMessages", errors[0].message);
                } else {
                    console.error("Unknown error");
                    cmp.set("v.errorMessages", 'Looks like an error occurred while saving the DML. If the error persists, please put in a Support Ticket with the subject: Request customer setup is not functioning');

                }
            }
        });
        $A.enqueueAction(action);
    },
    SubmitDMLs: function (component, event, helper) {
        var dmlData = component.get("v.dmlRec");

        var formattedData = JSON.stringify(dmlData);
        var OppId = component.get("v.subrecordIdLocator");
        if(OppId === null || OppId === '' || OppId ==='undefined'){
            console.error('Opportunity Id from Subrecord Id is invalid.');
            console.error('Opportunity Id: ' + OppId);
            return;
        }
        
        var action = component.get("c.CreateDMLOption");
        action.setParams({
            OppId: OppId,
            jsonDMLRecord: formattedData
        });

        action.setCallback(this, function (response) {
            var state = response.getState();
            var spinner = component.find("mySpinner");
            if (state === "SUCCESS") {
                if (response.getReturnValue() != "") {
                    component.set("v.DMLs", false);

                    var custsmap = [];
                    var conts = response.getReturnValue();
                    for (var key in conts) {
                        custsmap.push({
                            value: key,
                            key: conts[key]
                        });
                    }
                    var custs = [];
                    custs = component.get("v.DML");
                    for (var key in conts) {
                        custs.push({
                            value: key,
                            key: conts[key]
                        });
                    }
                    component.set("v.DML", custs);
                    component.set("v.selectedDML", conts[key]);
                    component.set("v.accRec.DML__c", key);
                    component.set("v.DMLs", false);
                    component.set("v.ALT", false);
                    component.set("v.requiredError", false);
                }
            }
            else if (state === "INCOMPLETE") {
            }
            else if (state === "ERROR") {
                component.set("v.validationErrordml", true);
                var errors = response.getError();
                if (errors) {
                    
                    // If we have an error, send the log event
                    var logErrorEvent = component.getEvent("logError");
                    logErrorEvent.setParams({
                        "criticality": "ERROR",
                        "message": errors[0].message,
                        "full_error": JSON.stringify({
                            "function": "helper.SubmitDMLs",
                            "objects": {
                                "OpportunityId": OppId,
                                "dmlData": dmlData
                            }
                        })
                    });
                    logErrorEvent.fire();
                    if (errors[0] && errors[0].message) {
                        console.error("Error message: " +
                          errors[0].message);
                          component.set("v.DML_Error", errors[0].message);
                    }
                } else {
                    console.error("Unknown error");
                }
            }

            $A.util.addClass(spinner, "slds-hide");
        });
        $A.enqueueAction(action);
    },
    selectAltDML: function (cmp) {
        var OppId = cmp.get("v.subrecordIdLocator");
        var action = cmp.get("c.getAltDML");
        if(OppId === null || OppId === '' || OppId ==='undefined'){
            console.error('Opportunity Id from Subrecord Id is invalid.');
            console.error('Opportunity Id: ' + OppId);
            return;
        }
        action.setParams({
            OppId: OppId
        });
        action.setCallback(this, function (response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var custs = [];
                var conts = response.getReturnValue();
                for (var key in conts) {
                    custs.push({
                        value: key,
                        key: conts[key]
                    });
                }
                cmp.set("v.AltDML", custs);
            }
            else if (state === "INCOMPLETE") {
            }
            else if (state === "ERROR") {
                cmp.set("v.Spinner", false);
                cmp.set("v.validationError", true);
                var errors = response.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        console.error("Error message: " + 
                                 errors[0].message);
                    }
                    cmp.set("v.errorMessages", errors[0].message);
                } else {
                    console.error("Unknown error");
                    cmp.set("v.errorMessages", 'Looks like an error occurred while saving the DML. If the error persists, please put in a Support Ticket with the subject: Request customer setup is not functioning');

                }
            }
        });
        $A.enqueueAction(action);
    },
    SubmitAltDMLs: function (cmp) {
        var inputData = cmp.get("v.AltDMLs");
        if (inputData != null && inputData != '') {
            var action = cmp.get("c.CreateSugAltDML");
            action.setParams({
                AltDMLId: inputData
            });

            action.setCallback(this, function (response) {
                var state = response.getState();
                if (state === "SUCCESS") {
                    if (response.getReturnValue() != "") {
                        var createdVal = response.getReturnValue();
                        cmp.set("v.AltdmlRec", createdVal);
                        cmp.set("v.dmlRec.DECISION_MAKER_NM__c", cmp.get("v.AltdmlRec.BUSINESS_NAME__c"));
                        cmp.set("v.dmlRec.Notes__c", '');
                        cmp.set("v.dmlRec.DML_City__c", cmp.get("v.AltdmlRec.STREET_ADDR__c"))
                        cmp.set("v.dmlRec.DECISION_MAKER_SEGMENT__c", '');
                        cmp.set("v.dmlRec.DECISION_MAKER_ZIP_CD__c", cmp.get("v.AltdmlRec.ZIP_CODE__c"));
                        cmp.set("v.dmlRec.Alternate_DML__c", cmp.get("v.AltdmlRec.Id"));

                        cmp.set("v.ALT", true);
                    }
                }else if (state === "INCOMPLETE") {
                }
                else if (state === "ERROR") {
                    cmp.set("v.Spinner", false);
                    cmp.set("v.validationError", true);
                    var errors = response.getError();
                    if (errors) {
                        if (errors[0] && errors[0].message) {
                            console.error("Error message: " + 
                                     errors[0].message);
                        }
                        cmp.set("v.errorMessages", errors[0].message);
                    } else {
                        console.error("Unknown error");
                        cmp.set("v.errorMessages", 'Looks like an error occurred while saving the DML. If the error persists, please put in a Support Ticket with the subject: Request customer setup is not functioning');
    
                    }
                }
            });
            $A.enqueueAction(action);
        } else {
            cmp.set("v.dmlRec.DECISION_MAKER_NM__c", cmp.get("v.accRec.BillTo_Name__c"));
            cmp.set("v.dmlRec.Notes__c", '');
            cmp.set("v.dmlRec.Reason_for_Creation__c", '');
            cmp.set("v.dmlRec.DECISION_MAKER_SEGMENT__c", cmp.get("v.accRec.Segment__c"));
            cmp.set("v.dmlRec.DECISION_MAKER_ZIP_CD__c", cmp.get("v.accRec.Zip_Bill__c"));
            cmp.set("v.ALT", true);
        }
    },

    SubmitAltDMLnew: function (cmp) {
        if (cmp.get("v.AltDMLs") === null || cmp.get("v.AltDMLs") === '' || cmp.get("v.AltDMLs") === undefined) {
            cmp.set("v.dmlRec.DECISION_MAKER_NM__c", cmp.get("v.accRec.BillTo_Name__c"));
            cmp.set("v.dmlRec.Notes__c", '');
            cmp.set("v.dmlRec.Reason_for_Creation__c", '');
            cmp.set("v.dmlRec.DECISION_MAKER_SEGMENT__c", cmp.get("v.accRec.Segment__c"));
            cmp.set("v.dmlRec.DECISION_MAKER_ZIP_CD__c", cmp.get("v.accRec.Zip_Bill__c"));
            cmp.set("v.dmlRec.DML_State__c", cmp.get("v.accRec.State_Bill__c"));
            cmp.set("v.dmlRec.DML_City__c", cmp.get("v.accRec.City_Bill__c"));
            cmp.set("v.dmlRec.Duns_Number__c", cmp.get("v.AltDMLs"));
            cmp.set("v.ALT", true);
        } else {
            var re = "^\\s+$";
            var input = cmp.get("v.AltDMLkey");
            if (input !== null || input !== '' || input !== undefined || !input.match(re)) {
                var fields = input.split('--');
                var name = fields[0];
                var street = fields[1];
                var zip = fields[2];
                var city = fields[3];
                var state = fields[4];
                var duns = fields[5];

                cmp.set("v.dmlRec.DML_State__c", '');

                cmp.set("v.dmlRec.DECISION_MAKER_NM__c", name);

                cmp.set("v.dmlRec.Notes__c", '');

                if (duns !== undefined) {
                    cmp.set("v.dmlRec.Duns_Number__c", duns);
                } else {
                    cmp.set("v.dmlRec.Duns_Number__c", '');
                }

                if (street !== undefined) {
                    cmp.set("v.dmlRec.DML_Street__c", street);
                } else {
                    cmp.set("v.dmlRec.DML_Street__c", '');
                }

                cmp.set("v.dmlRec.DECISION_MAKER_SEGMENT__c", '');
                
                if (zip !== undefined) {
                    cmp.set("v.dmlRec.DECISION_MAKER_ZIP_CD__c", zip);
                } else {
                    cmp.set("v.dmlRec.DECISION_MAKER_ZIP_CD__c", '');
                }

                if (state !== undefined) {
                    cmp.set("v.dmlRec.DML_State__c", state);
                } else {
                    cmp.set("v.dmlRec.DML_State__c", '');
                }

                if (city !== undefined) {
                    cmp.set("v.dmlRec.DML_City__c", city);
                } else {
                    cmp.set("v.dmlRec.DML_City__c", '');
                }

                cmp.set("v.dmlRec.Alternate_DML__c", cmp.get("v.AltDMLvalue"));

                cmp.set("v.ALT", true);
            }
        }
    }


});