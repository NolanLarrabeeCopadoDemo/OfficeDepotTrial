({
    doInit: function (component, event, helper) {
        helper.selectDML(component);
        helper.selectAltDML(component);
        //helper.doConvProsCheck(component);
        helper.doInitValidate(component);
    },
    
    getDocumentLink: function (component) {
        var getDocumentAction = component.get("c.getDocumentLink");
        getDocumentAction.setCallback(this, function (response) {
            var state = response.getState();
            if (state === 'SUCCESS') {
                var docLink = response.getReturnValue();
                component.set("v.documentLink", docLink);
            } else if (state === "INCOMPLETE") {
            }
                else if (state === "ERROR") {
                    var errors = response.getError();
                    if (errors) {
                        if (errors[0] && errors[0].message) {
                            console.error("Error message: " + errors[0].message);
                        }
                    } else {
                        console.error("Unknown error");
                        
                    }
                }
        });
    },
    reportError: function (component, event) {
        var criticality = event.getParam("criticality");
        var message = event.getParam("message");
        var full_error = event.getParam("full_error");
        var reportAction = component.get("c.makeLog");
        
        reportAction.setParams({
            criticality: criticality,
            message: message,
            full_error: full_error
        });
        
        reportAction.setCallback(this, function (response) {
            var state = response.getState();
            if (state === 'SUCCESS') {
            } else if (state === "INCOMPLETE") {
            }
                else if (state === "ERROR") {
                    var errors = response.getError();
                    if (errors) {
                        if (errors[0] && errors[0].message) {
                            console.error(errors[0].message);
                        }
                    } else {
                    }
                }
        });
        $A.enqueueAction(reportAction);
    },
    handleClickNextBillTo: function (component, event, helper) {
        var re = "^\\s+$";
        if (
            (component.get("v.accRec.BillTo_Name__c") == null || component.get("v.accRec.BillTo_Name__c") == '') ||
            (component.get("v.accRec.Account_Phone__c") == null || component.get("v.accRec.Account_Phone__c") == '') ||
            (component.get("v.accRec.Street_Address_Bill__c") == null || component.get("v.accRec.Street_Address_Bill__c") == '') ||
            (component.get("v.accRec.City_Bill__c") == null || component.get("v.accRec.City_Bill__c") == '') ||
            (component.get("v.accRec.State_Bill__c") == null || component.get("v.accRec.State_Bill__c") == '') ||
            (component.get("v.accRec.Zip_Bill__c") == null || component.get("v.accRec.Zip_Bill__c") == '') ||
            (component.get("v.accRec.BILL_COUNTRY__c") == null || component.get("v.accRec.BILL_COUNTRY__c") == '') ||
            component.get("v.accRec.BILL_COUNTRY__c").match(re) ||
            component.get("v.accRec.BillTo_Name__c").match(re) ||
            component.get("v.accRec.Street_Address_Bill__c").match(re) ||
            component.get("v.accRec.City_Bill__c").match(re) ||
            component.get("v.accRec.State_Bill__c").match(re) ||
            component.get("v.accRec.Zip_Bill__c").match(re)
        ) {
            component.set("v.requiredError", true);
        } else {
            component.set("v.requiredError", false);
            var val = component.get("v.accRec.Account_Phone__c");
            var s2 = ("" + val).replace(/\D/g, '');
            if (s2.length < 10) {
                $A.util.addClass(component.find("fteErrorP1"), "show");
            } else {
                var newPhoneNo = helper.formatPhoneNumber(component, val);
                val = newPhoneNo;
                component.set("v.accRec.Account_Phone__c", val);
                helper.doNextBillTo(component);
                component.set("v.accRec.isaccountsetup__c", true);
            }
        }
    },
    handleClickNextShipTo: function (component, event, helper) {
        var re = "^\\s+$";
        if (
            (component.get("v.accRec.Street_Address_Ship__c") == null || component.get("v.accRec.Street_Address_Ship__c") == '') ||
            (component.get("v.accRec.City_Ship__c") == null || component.get("v.accRec.City_Ship__c") == '') ||
            (component.get("v.accRec.State_Ship__c") == null || component.get("v.accRec.State_Ship__c") == '') ||
            (component.get("v.accRec.Zip_Ship__c") == null || component.get("v.accRec.Zip_Ship__c") == '') ||
            (component.get("v.accRec.SHIP_COUNTRY__c") == null || component.get("v.accRec.SHIP_COUNTRY__c") == '') ||
            component.get("v.accRec.Street_Address_Ship__c").match(re) ||
            component.get("v.accRec.City_Ship__c").match(re) ||
            component.get("v.accRec.State_Ship__c").match(re) ||
            component.get("v.accRec.Zip_Ship__c").match(re) ||
            component.get("v.accRec.SHIP_COUNTRY__c").match(re)
        ) {
            component.set("v.requiredError", true);
        } else {
            component.set("v.requiredError", false);
            if (component.get("v.accRec.Does_your_Customer_have_any_ordering_pr__c") == "Yes") {
                component.set("v.togglePO", true);
            }
            if (component.get("v.accRec.PO__c") == "Yes" ||
                component.get("v.accRec.PO__c") == "Validate") {
                component.set("v.togglePOD", true);
            }
            if (component.get("v.accRec.Desktop__c") == "Yes" ||
                component.get("v.accRec.Desktop__c") == "Validate") {
                component.set("v.togglePODeskTop", true);
            }
            if (component.get("v.accRec.Cost_Center__c") == "Yes" ||
                component.get("v.accRec.Cost_Center__c") == "Validate") {
                component.set("v.togglePOCost", true);
            }
            if (component.get("v.accRec.Release__c") == "Yes" ||
                component.get("v.accRec.Release__c") == "Validate") {
                component.set("v.togglePORelease", true);
            }
            if (component.get("v.accRec.Special_Delivery_Requirements__c") == "Yes") {
                component.set("v.toggleDelivery", true);
            }
            helper.doNextShipTo(component);
        }
    },
    
    //Start : Added by Rajendra Shahane for NAIT-135699 Ability to Auto-Populate eBilling Contact Info From AP Contact Information - Account Setup
    checkboxPrimarySelect: function(component, event, helper) {
        if(event.getSource().get('v.checked')){
            component.set("v.accRec.eBilling_Contact_Salutation__c",component.get("v.accRec.AP_Contact_Salutation__c"));
            component.set("v.accRec.eBilling_Contact_First_Name__c",component.get("v.accRec.AP_Contact_First_Name__c"));
            component.set("v.accRec.eBilling_Contact_Last_Name__c",component.get("v.accRec.AP_Contact_Last_Name__c"));
            component.set("v.accRec.eBilling_Contact_Phone__c",component.get("v.accRec.AP_Contact_Phone__c"));
            component.set("v.accRec.eBilling_Contact_Email__c",component.get("v.accRec.AP_Contact_Email__c"));
        }
        else{
            component.set("v.accRec.eBilling_Contact_Salutation__c","");
            component.set("v.accRec.eBilling_Contact_First_Name__c","");
            component.set("v.accRec.eBilling_Contact_Last_Name__c","");
            component.set("v.accRec.eBilling_Contact_Phone__c","");
            component.set("v.accRec.eBilling_Contact_Email__c}",null);
        }
    },
    
    checkboxSecondarySelect: function(component, event, helper) {
        if(event.getSource().get('v.checked')){
            component.set("v.accRec.eBilling_Contact_Salutation2__c",component.get("v.accRec.AP_Contact_Salutation__c"));
            component.set("v.accRec.eBilling_Contact_First_Name2__c",component.get("v.accRec.AP_Contact_First_Name__c"));
            component.set("v.accRec.eBilling_Contact_Last_Name2__c",component.get("v.accRec.AP_Contact_Last_Name__c"));
            component.set("v.accRec.eBilling_Contact_Phone2__c",component.get("v.accRec.AP_Contact_Phone__c"));
            component.set("v.accRec.eBilling_Contact_Email2__c",component.get("v.accRec.AP_Contact_Email__c"));
        }
        else{
            component.set("v.accRec.eBilling_Contact_Salutation2__c","");
            component.set("v.accRec.eBilling_Contact_First_Name2__c","");
            component.set("v.accRec.eBilling_Contact_Last_Name2__c","");
            component.set("v.accRec.eBilling_Contact_Phone2__c","");
            component.set("v.accRec.eBilling_Contact_Email2__c}",null);
        }
    },
    //End: by Rajendra Shahane for NAIT-135699 Ability to Auto-Populate eBilling Contact Info From AP Contact Information - Account Setup
    
    //Start: by Rajendra Shahane for NAIT-135726 02931356 - Allow Reps to Attach Tax Exemption Form - Account Setup
    
    uploadtaxFile: function(component, event, helper){
        var MAX_FILE_SIZE = 100000000;
        
        console.log("In uploadtaxFile");
        // This will contain the List of File uploaded data and status
        var uploadFile = event.getSource().get("v.files");
        var self = this;
        var file = uploadFile[0]; // getting the first file, loop for multiple files
        var reader = new FileReader();
        reader.onloadend =  $A.getCallback(function()
		{
            var dataURL = reader.result;
            var base64 = 'base64,';
            var dataStart = dataURL.indexOf(base64) + base64.length;
            dataURL= dataURL.substring(dataStart);
            
            component.set("v.fileName", file.name);
        component.set("v.base64Data", dataURL); 
        component.set("v.contentType", file.type);
        console.log("v.fileName " + component.get("v.fileName"));
        console.log("base64Data " + component.get("v.base64Data"));
        console.log("contentType " + component.get("v.contentType"));
            //helper.upload(component, file, dataURL)
        });
        reader.readAsDataURL(file);
        console.log("out uploadtaxFile");
    },
    
    
    //End: by Rajendra Shahane for NAIT-02931356 - Allow Reps to Attach Tax Exemption Form - Account Setup
    
    // Back button in Ship To Section
    handleClickBackShipTo: function (component, event, helper) {
        helper.doBackShipTo(component);
    },
    
    // Next button in Contact Section    
    handleClickNextContact: function (component, event, helper) {
        var re = "^\\s+$";
        var regexPhone = '^\\([0-9]{3}\\) [0-9]{3}-[0-9]{4}$'
        if (
            (component.get("v.accRec.Primary_Contact_First_Name__c") == null || component.get("v.accRec.Primary_Contact_First_Name__c") == '') ||
            (component.get("v.accRec.Primary_Contact_Last_Name__c") == null || component.get("v.accRec.Primary_Contact_Last_Name__c") == '') ||
            (component.get("v.accRec.Primary_Contact_Phone__c") == null || component.get("v.accRec.Primary_Contact_Phone__c") == '') ||
            (component.get("v.accRec.Primary_Contact_Email__c") == null || component.get("v.accRec.Primary_Contact_Email__c") == '') ||
            component.get("v.accRec.Special_Delivery_Requirements__c") == "" ||
            component.get("v.accRec.Does_your_Customer_have_any_ordering_pr__c") == "" ||
            component.get("v.accRec.Primary_Contact_First_Name__c").match(re) ||
            component.get("v.accRec.Primary_Contact_Last_Name__c").match(re) ||
            component.get("v.accRec.Primary_Contact_Phone__c").match(re) ||
            component.get("v.accRec.Primary_Contact_Email__c").match(re)
        ) {
            component.set("v.requiredError", true);
        } else {
            component.set("v.requiredError", false);
            if (component.get("v.accRec.Billing_Delivery_Method_Media_type__c") == "Paper") {
                component.set("v.togglePaper", true);
                
            } else if (component.get("v.accRec.Billing_Delivery_Method_Media_type__c") == "ePDF") {
                component.set("v.toggleePDF", true);
                component.set("v.togglePaper", true);
            } else {
                component.set("v.togglePaper", false);
                component.set("v.toggleePDF", false);
            }
            if (component.get("v.accRec.PD_Incl_Backup_Inc__c") == "Yes") {
                component.set("v.toggle1change", true);
            }
            
            helper.EmailValid(component);
            var val = component.get("v.accRec.Primary_Contact_Phone__c");
            if (val.length < 10) {
                $A.util.addClass(component.find("fteErrorP2"), "show");
                component.set("v.BillToError1", false);
            } else {
                var newPhoneNo = helper.formatPhoneNumber(component, val);
                val = newPhoneNo;
                component.set("v.accRec.Primary_Contact_Phone__c", val);
                component.set("v.BillToError1", true);
            }
            helper.FaxValid1(component);
            if (component.get("v.BillToError1") && component.get("v.ODEmailError") && component.get("v.BillToErrorFax1") && component.get("v.accRec.Primary_Contact_Phone__c").match(regexPhone)) {
                helper.doNextContact(component);
            } else {
                $A.util.addClass(component.find("fteErrorP2"), "show");
                component.set("v.BillToError1", false);
            }
        }
        
    },
    
    // Back button in Contact Section
    handleClickBackContact: function (component, event, helper) {
        helper.doBackContact(component);
    },
    
    handleClickNextBillPref: function (component, event, helper) {
        var re = "^\\s+$";
        component.set("v.accRec.Billing_Frequency__c", 'Weekly');
        if (component.get("v.accRec.Show_Net_20__c") == true) {
            if (component.get("v.ODEmailError")) {
                var selnext = component.find("selectbillingmethod");
                var navnext = selnext.get("v.value");
                var sel1 = component.find("specificchanges");
                var nav1 = sel1.get("v.value");
                if (
                    component.get("v.accRec.EDI_or_Punch_Out__c") == "" ||
                    component.get("v.accRec.Billing_Delivery_Method_Media_type__c") == "" ||
                    (((navnext == "Paper") && (
                        (component.get("v.accRec.AP_Contact_First_Name__c") == null || component.get("v.accRec.AP_Contact_First_Name__c") == '') ||
                        (component.get("v.accRec.AP_Contact_Last_Name__c") == null || component.get("v.accRec.AP_Contact_Last_Name__c") == '') ||
                        (component.get("v.accRec.AP_Contact_Email__c") == null || component.get("v.accRec.AP_Contact_Email__c") == '') ||
                        (component.get("v.accRec.AP_Contact_Phone__c") == null || component.get("v.accRec.AP_Contact_Phone__c") == '') ||
                        component.get("v.accRec.AP_Contact_First_Name__c").match(re) ||
                        component.get("v.accRec.AP_Contact_Last_Name__c").match(re) ||
                        component.get("v.accRec.AP_Contact_Email__c").match(re)
                    )) ||
                     ((navnext == "ePDF") && (
                         (component.get("v.accRec.AP_Contact_First_Name__c") == null || component.get("v.accRec.AP_Contact_First_Name__c") == '') ||
                         (component.get("v.accRec.AP_Contact_Last_Name__c") == null || component.get("v.accRec.AP_Contact_Last_Name__c") == '') ||
                         (component.get("v.accRec.AP_Contact_Email__c") == null || component.get("v.accRec.AP_Contact_Email__c") == '') ||
                         (component.get("v.accRec.AP_Contact_Phone__c") == null || component.get("v.accRec.AP_Contact_Phone__c") == '') ||
                         (component.get("v.accRec.eBilling_Contact_First_Name__c") == null || component.get("v.accRec.eBilling_Contact_First_Name__c") == '') ||
                         (component.get("v.accRec.eBilling_Contact_Last_Name__c") == null || component.get("v.accRec.eBilling_Contact_Last_Name__c") == '') ||
                         (component.get("v.accRec.eBilling_Contact_Email__c") == null || component.get("v.accRec.eBilling_Contact_Email__c") == '') ||
                         (component.get("v.accRec.eBilling_Contact_Phone__c") == null || component.get("v.accRec.eBilling_Contact_Phone__c") == '') ||
                         (component.get("v.accRec.Monthly_eStatement_Email__c") == null || component.get("v.accRec.Monthly_eStatement_Email__c") == '') ||
                         (component.get("v.accRec.eBilling_Contact_First_Name2__c") == null || component.get("v.accRec.eBilling_Contact_First_Name2__c") == '') ||
                         (component.get("v.accRec.eBilling_Contact_Last_Name2__c") == null || component.get("v.accRec.eBilling_Contact_Last_Name2__c") == '') ||
                         (component.get("v.accRec.eBilling_Contact_Email2__c") == null || component.get("v.accRec.eBilling_Contact_Email2__c") == '') ||
                         (component.get("v.accRec.eBilling_Contact_Phone2__c") == null || component.get("v.accRec.eBilling_Contact_Phone2__c") == '') ||
                         component.get("v.accRec.AP_Contact_First_Name__c").match(re) ||
                         component.get("v.accRec.AP_Contact_Last_Name__c").match(re) ||
                         component.get("v.accRec.AP_Contact_Email__c").match(re) ||
                         component.get("v.accRec.eBilling_Contact_First_Name__c").match(re) ||
                         component.get("v.accRec.eBilling_Contact_Last_Name__c").match(re) ||
                         component.get("v.accRec.eBilling_Contact_Email__c").match(re) ||
                         component.get("v.accRec.Monthly_eStatement_Email__c").match(re) ||
                         component.get("v.accRec.eBilling_Contact_First_Name2__c").match(re) ||
                         component.get("v.accRec.eBilling_Contact_Last_Name2__c").match(re) ||
                         component.get("v.accRec.eBilling_Contact_Email2__c").match(re)
                     ))) || component.get("v.accRec.PD_Incl_Backup_Inc__c") == ""
                    
                ) {
                    component.set("v.requiredError", true);
                } else {
                    component.set("v.requiredError", false);
                    if (component.get("v.accRec.Tax_Exempt__c") == "Yes") {
                        component.set("v.toggletax", true);
                    }
                    if (component.get("v.accRec.Why_are_you_tax_exempt__c") == "Government") {
                        component.set("v.togglegov", true);
                    }
                    helper.dotaxexempt(component);
                    if (component.get("v.accRec.Billing_Delivery_Method_Media_type__c") == "Paper") {
                        var val = component.get("v.accRec.AP_Contact_Phone__c");
                        var regexPhone = '^\\([0-9]{3}\\) [0-9]{3}-[0-9]{4}$'
                        if (val.length < 10) {
                            $A.util.addClass(component.find("fteErrorP3"), "show");
                            component.set("v.BillToErrorAP", false);
                        } else {
                            var newPhoneNo = helper.formatPhoneNumber(component, val);
                            val = newPhoneNo;
                            component.set("v.accRec.AP_Contact_Phone__c", val);
                            component.set("v.BillToErrorAP", true);
                        }
                        helper.FaxValid(component);
                        if (component.get("v.BillToErrorFax") && component.get("v.BillToErrorAP") && component.get("v.accRec.AP_Contact_Phone__c").match(regexPhone)) {
                            helper.doNextBillPref(component);
                        } else {
                            $A.util.addClass(component.find("fteErrorP3"), "show");
                        }
                    }
                    if (component.get("v.accRec.Billing_Delivery_Method_Media_type__c") == "ePDF") {
                        var regexPhone = '^\\([0-9]{3}\\) [0-9]{3}-[0-9]{4}$'
                        var val = component.get("v.accRec.eBilling_Contact_Phone__c");
                        if (val.length < 10) {
                            $A.util.addClass(component.find("fteErrorP4"), "show");
                            component.set("v.BillToErrorE1", false);
                        } else {
                            var newPhoneNo = helper.formatPhoneNumber(component, val);
                            val = newPhoneNo;
                            component.set("v.accRec.eBilling_Contact_Phone__c", val);
                            component.set("v.BillToErrorE1", true);
                        }
                        var val = component.get("v.accRec.AP_Contact_Phone__c");
                        if (val.length < 10) {
                            $A.util.addClass(component.find("fteErrorP3"), "show");
                            component.set("v.BillToErrorAP", false);
                        } else {
                            var newPhoneNo = helper.formatPhoneNumber(component, val);
                            val = newPhoneNo;
                            component.set("v.accRec.AP_Contact_Phone__c", val);
                            component.set("v.BillToErrorAP", true);
                        }
                        var val = component.get("v.accRec.eBilling_Contact_Phone2__c");
                        if (val.length < 10) {
                            $A.util.addClass(component.find("fteErrorP5"), "show");
                            component.set("v.BillToErrorE2", false);
                        } else {
                            var newPhoneNo = helper.formatPhoneNumber(component, val);
                            val = newPhoneNo;
                            component.set("v.accRec.eBilling_Contact_Phone2__c", val);
                            component.set("v.BillToErrorE2", true);
                        }
                        helper.FaxValid(component);
                        if (component.get("v.BillToErrorE1") && component.get("v.BillToErrorAP") && component.get("v.BillToErrorE2") && component.get("v.BillToErrorFax") && component.get("v.accRec.eBilling_Contact_Phone__c").match(regexPhone) && component.get("v.accRec.AP_Contact_Phone__c").match(regexPhone) && component.get("v.accRec.eBilling_Contact_Phone2__c").match(regexPhone)) {
                            helper.doNextBillPref(component);
                        } else if (!component.get("v.accRec.eBilling_Contact_Phone__c").match(regexPhone)) {
                            $A.util.addClass(component.find("fteErrorP4"), "show");
                            component.set("v.BillToErrorE1", false);
                        } else if (!component.get("v.accRec.AP_Contact_Phone__c").match(regexPhone)) {
                            $A.util.addClass(component.find("fteErrorP3"), "show");
                            component.set("v.BillToErrorAP", false);
                        } else if (!component.get("v.accRec.eBilling_Contact_Phone2__c").match(regexPhone)) {
                            $A.util.addClass(component.find("fteErrorP5"), "show");
                            component.set("v.BillToErrorE2", false);
                        }
                        
                    }
                    
                }
            }
        } else {
            if (
                component.get("v.accRec.EDI_or_Punch_Out__c") == "") {
                component.set("v.requiredError", true);
            } else {
                component.set("v.requiredError", false);
                if (component.get("v.accRec.Tax_Exempt__c") == "Yes") {
                    component.set("v.toggletax", true);
                }
                if (component.get("v.accRec.Why_are_you_tax_exempt__c") == "Government") {
                    component.set("v.togglegov", true);
                }
                helper.dotaxexempt(component);
                helper.doNextBillPref(component);
                
            }
        }
        
    },
    // Back button in Bill to Preference Section
    handleClickBackBillPref: function (component, event, helper) {
        helper.doBackBillPref(component);
    },
    toggle: function (component, event, helper) {
        var sel = component.find("selectbillingmethod");
        var nav = sel.get("v.value");
        if (nav == "") {
            component.set("v.toggleePDF", false);
            component.set("v.togglePaper", false);
        }
        if (nav == "ePDF") {
            component.set("v.toggleePDF", true);
            component.set("v.togglePaper", true);
        }
        if (nav == "Paper") {
            component.set("v.togglePaper", true);
            component.set("v.toggleePDF", false);
        }
    },
    
    toggle1: function (component, event, helper) {
        var sel1 = component.find("specificchanges");
        var nav1 = sel1.get("v.value");
        if (nav1 == "" || nav1 == "No") {
            component.set("v.toggle1change", false);
            component.set("v.accRec.Billing_Frequency__c", 'Weekly');
        }
        if (nav1 == "Yes") {
            component.set("v.toggle1change", true);
            component.set("v.accRec.Billing_Frequency__c", 'Weekly');
        }
    },
    handleClickNextTax: function (component, event, helper) {
        if (!!(component.get("v.accRec.Employer_TIN__c")) && (component.get("v.TINError") == true))
        {
            component.set("v.requiredError", true);
        } else {
            component.set("v.requiredError", false);
            helper.doNextTax(component);
        }
    },
    // Back button in Bill to Preference Section
    handleClickBackTax: function (component, event, helper) {
        helper.doBackTax(component);
    },
    toggletaxexempt: function (component, event, helper) {
        var taxoption = component.find("EarlyPayDiscount3");
        var val = taxoption.get("v.value");
        if (val == "" || val == "No") {
            component.set("v.toggletax", false);
            component.set("v.taxfiles", []);
        }
        if (val == "Yes") {
            component.set("v.toggletax", true);
            component.set("v.taxfiles", []);
        }
    },
    togglegovt: function (component, event, helper) {
        var exemptoption = component.find("exemption");
        var opt = exemptoption.get("v.value");
        if (opt == "Government") {
            component.set("v.togglegov", true);
        } else {
            component.set("v.togglegov", false);
        }
    },
    
    
    handleClickBackSubmit: function (component, event, helper) {
        helper.doBackSubmit(component);
    },
    
    // Submit Button
    submitProspect: function (component, event, helper) {
        var selectedDML = component.get("v.accRec.DML__c");
        if (selectedDML == "") {
            component.set("v.requiredError", true);
        } else {
            helper.sendProspect(component);
        }
    },
    validatePhoneNo: function (component, event, helper) {
        if ((event.which < 48 || event.which > 57)) {
            event.preventDefault();
        }
    },
    checkValidityOfphone: function (component, event, helper) {
        var inp = event.getSource();
        var val = inp.get('v.value');
        var re = new RegExp("\\([0-9]{3}\\) [0-9]{3}-[0-9]{4}");
        if (!re.test(val)) {
            component.set("v.BillToError", true);
        } else {
            component.set("v.BillToError", false);
        }
    },
    
    TINValid: function (component, event, helper) {
        var inp = event.getSource();
        var val = inp.get('v.value');
        var re = new RegExp("[0-9]{2}-[0-9]{7}$");
        if (!re.test(val)) {
            component.set("v.TINError", true);
        } else {
            component.set("v.TINError", false);
        }
    },
    ODEmailValid: function (component, event, helper) {
        var inp = event.getSource();
        var val = inp.get('v.value');
        var val2 = component.getLocalId();
        var re = /^(([^<>()\[\]\\.,;:\s@"]+(\.[^<>()\[\]\\.,;:\s@"]+)*)|(".+"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$/
        if (!$A.util.isEmpty(val)) {
            if (val.match(re)) {
                var splitArray = val.split('@');
                if (val.indexOf('@officedepot.com') !== -1) {
                    $A.util.addClass(component.find("fteError1"), "show");
                    component.set("v.ODEmailError", false);
                } else {
                    component.set("v.ODEmailError", true);
                }
            } else {
                
                
                $A.util.removeClass(component.find("fteError1"), "show");
                component.set("v.ODEmailError", false);
            }
        } else {
            $A.util.addClass(component.find("fteError1"), "show");
            component.set("v.ODEmailError", false);
        }
    },
    
    ODEmailValid1: function (component, event, helper) {
        var inp = event.getSource();
        var val = inp.get('v.value');
        var val2 = component.getLocalId();
        var re = /^(([^<>()\[\]\\.,;:\s@"]+(\.[^<>()\[\]\\.,;:\s@"]+)*)|(".+"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$/
        if (!$A.util.isEmpty(val)) {
            if (val.match(re)) {
                var splitArray = val.split('@');
                if (val.indexOf('@officedepot.com') !== -1) {
                    $A.util.addClass(component.find("fteError2"), "show");
                    component.set("v.ODEmailError", false);
                } else {
                    component.set("v.ODEmailError", true);
                }
            } else {
                
                
                $A.util.removeClass(component.find("fteError2"), "show");
                component.set("v.ODEmailError", false);
            }
        } else {
            $A.util.addClass(component.find("fteError2"), "show");
            component.set("v.ODEmailError", false);
        }
    },
    
    ODEmailValid2: function (component, event, helper) {
        var inp = event.getSource();
        var val = inp.get('v.value');
        var val2 = component.getLocalId();
        var re = /^(([^<>()\[\]\\.,;:\s@"]+(\.[^<>()\[\]\\.,;:\s@"]+)*)|(".+"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$/
        if (!$A.util.isEmpty(val)) {
            if (val.match(re)) {
                var splitArray = val.split('@');
                if (val.indexOf('@officedepot.com') !== -1) {
                    $A.util.addClass(component.find("fteError3"), "show");
                    component.set("v.ODEmailError", false);
                } else {
                    component.set("v.ODEmailError", true);
                }
            } else {
                $A.util.removeClass(component.find("fteError3"), "show");
                component.set("v.ODEmailError", false);
            }
        } else {
            $A.util.addClass(component.find("fteError3"), "show");
            component.set("v.ODEmailError", false);
        }
    },
    
    ODEmailValid3: function (component, event, helper) {
        var inp = event.getSource();
        var val = inp.get('v.value');
        var val2 = component.getLocalId();
        var re = /^(([^<>()\[\]\\.,;:\s@"]+(\.[^<>()\[\]\\.,;:\s@"]+)*)|(".+"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$/
        if (!$A.util.isEmpty(val)) {
            if (val.match(re)) {
                var splitArray = val.split('@');
                if (val.indexOf('@officedepot.com') !== -1) {
                    $A.util.addClass(component.find("fteError4"), "show");
                    component.set("v.ODEmailError", false);
                } else {
                    component.set("v.ODEmailError", true);
                }
            } else {
                $A.util.removeClass(component.find("fteError4"), "show");
                component.set("v.ODEmailError", false);
            }
        } else {
            $A.util.addClass(component.find("fteError4"), "show");
            component.set("v.ODEmailError", false);
        }
    },
    
    
    togglePO: function (component, event, helper) {
        var PO = component.find("select");
        var opt = PO.get("v.value");
        if (opt == "Yes") {
            component.set("v.togglePO", true);
        } else {
            component.set("v.togglePO", false);
        }
    },
    togglePOD: function (component, event, helper) {
        var PO = component.find("PurchaseOrder");
        var opt = PO.get("v.value");
        if (opt == "Yes" || opt == "Validate") {
            component.set("v.togglePOD", true);
        } else {
            component.set("v.togglePOD", false);
            component.set("v.accRec.Rename_Purchase_Order__c", "");
        }
        
    },
    togglePODeskTop: function (component, event, helper) {
        var PO = component.find("DesktopField");
        var opt = PO.get("v.value");
        if (opt == "Yes" || opt == "Validate") {
            component.set("v.togglePODeskTop", true);
        } else {
            component.set("v.togglePODeskTop", false);
            component.set("v.accRec.Rename_Desktop__c", "");
        }
    },
    togglePOCost: function (component, event, helper) {
        var PO = component.find("CostCenter");
        var opt = PO.get("v.value");
        if (opt == "Yes" || opt == "Validate") {
            component.set("v.togglePOCost", true);
        } else {
            component.set("v.togglePOCost", false);
            component.set("v.accRec.Rename_Cost_Center__c", "");
        }
    },
    togglePORelease: function (component, event, helper) {
        var PO = component.find("ReleaseField");
        var opt = PO.get("v.value");
        if (opt == "Yes" || opt == "Validate") {
            component.set("v.togglePORelease", true);
        } else {
            component.set("v.togglePORelease", false);
            component.set("v.accRec.Rename_Release__c", "");
        }
    },
    toggleDelivery: function (component, event, helper) {
        var PO = component.find("selectDelivery");
        var opt = PO.get("v.value");
        if (opt == "Yes") {
            component.set("v.toggleDelivery", true);
        } else {
            component.set("v.toggleDelivery", false);
        }
    },
    onCheck: function (component, evt) {
        var capturedCheckboxName = evt.getSource().get("v.value");
        var selectedCheckBoxes = component.get("v.checkboxValueMap");
        var strstate = '';
        for (var key in selectedCheckBoxes) {
            if (selectedCheckBoxes[key].value == true) {
                if (strstate == '') {
                    strstate = selectedCheckBoxes[key].key;
                } else {
                    strstate = strstate + ',' + selectedCheckBoxes[key].key;
                }
            }
        }
        component.set("v.accRec.Tax_Exempt_States__c", strstate);
    },
    
    handleClickNextBillPref1: function (component, event, helper) {
        if (
            component.get("v.accRec.EDI_or_Punch_Out__c") == "") {
            component.set("v.requiredError", true);
        } else {
            component.set("v.requiredError", false);
            if (component.get("v.accRec.Tax_Exempt__c") == "Yes") {
                component.set("v.toggletax", true);
            }
            if (component.get("v.accRec.Why_are_you_tax_exempt__c") == "Government") {
                component.set("v.togglegov", true);
            }
            helper.dotaxexempt(component);
            helper.doNextBillPref(component);
        }
        
    },
    dmlselect: function (component, evt) {
        var Dmloption = component.find("DML");
        var DmloptionValue = Dmloption.get("v.value");
        
        component.set("v.disableDMLCreate", true);
        if (DmloptionValue == '') {
            component.set("v.accRec.DML__c", "");
            component.set("v.requiredError", true);
            
        } else if (DmloptionValue == 'New DML') {
            component.set("v.accRec.DML__c", "");
            component.set("v.disableDMLCreate", false);
            component.set("v.requiredError", true);
            
        }
            else {
                component.set("v.accRec.DML__c", DmloptionValue);
            }
    },
    CreateDML: function (component, evt) {
        component.set("v.requiredError", false);
        component.set("v.dmlRec.DECISION_MAKER_NM__c", component.get("v.accRec.BillTo_Name__c"));
        component.set("v.dmlRec.Notes__c", '');
        component.set("v.dmlRec.Reason_for_Creation__c", '');
        component.set("v.dmlRec.DML_State__c", component.get("v.accRec.State_Bill__c"));
        component.set("v.dmlRec.DML_City__c", component.get("v.accRec.City_Bill__c"));
        
        component.set("v.dmlRec.DECISION_MAKER_SEGMENT__c", component.get("v.accRec.Segment__c"));
        component.set("v.dmlRec.DECISION_MAKER_ZIP_CD__c", component.get("v.accRec.Zip_Bill__c"));
        component.set("v.ALT", true);
        
    },
    Cancel: function (component, evt) {
        component.set("v.dmlRec.DECISION_MAKER_NM__c", '');
        component.set("v.dmlRec.Notes__c", '');
        component.set("v.dmlRec.Reason_for_Creation__c", '');
        component.set("v.dmlRec.DECISION_MAKER_SEGMENT__c", '');
        component.set("v.dmlRec.DECISION_MAKER_ZIP_CD__c", '');
        component.set("v.ALT", false);
        component.set("v.DMLs", true);
        component.set("v.validationErrordml", false);
    },
    SelectAltDML: function (component, evt, helper) {
        var AltDmloption = component.find("AltDML");
        var AltDmloptionValue = AltDmloption.get("v.value");
        var capturedCheckboxName = evt.getSource().get("v.value");
        var selectedCheckBoxes = component.get("v.AltDML");
        for (var key in selectedCheckBoxes) {
            if (selectedCheckBoxes[key].value == AltDmloptionValue) {
                component.set("v.AltDMLkey", selectedCheckBoxes[key].key);
                component.set("v.AltDMLvalue", selectedCheckBoxes[key].value);
            }
        }
        component.set("v.AltDMLs", AltDmloptionValue);
        helper.SubmitAltDMLnew(component);
    },
    SubmitDML: function (component, event, helper) {
        var dmlnotes = component.find("notesdml").get("v.value");
        if (dmlnotes !== '') {
            helper.SubmitDMLs(component);
        } else {
            component.set("v.validationErrordml", true);
            component.set("v.DML_Error", "Notes Mandatory");
        }
    },
    showSpinner: function (component, event, helper) {
        // Display spinner when aura:waiting (server waiting)
        if (component.get("v.DMLs") == true || component.get("v.ALT") == true || component.get("v.showBillTo") == true) {
            component.set("v.Spinner", true);
        } else {
            component.set("v.Spinner", false);
        }
    },
    hideSpinner: function (component, event, helper) {
        // Hide when aura:downwaiting
        component.set("v.Spinner", false);
    },
    closeModel: function (component, event, helper) {
        component.set("v.ALT", false);
        component.set("v.validationErrordml", false);
        component.set("v.DMLs", true);
    },
})