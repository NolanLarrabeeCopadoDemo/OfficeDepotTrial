({
    // If the URL contains parameters, it have a ?.
        getURLParams : function(component, event, helper) {
            var url = String(window.location.href);
            if(url.includes("?")) {
                var sub_string_count = url.split("?").length;
                return url.split("?")[sub_string_count-1];
            }
            return "undefined";

        },
        //Parse the URL parameters into a map.
        parseParams : function(component, event, helper, params) {
            var paramList = params.split("&");
            var paramMap = new Map();
            for( var i = 0; i<paramList.length; i++) {
                var temp = paramList[i].split("=");
                paramMap.set(temp[0], temp[1]);
            }
            return paramMap;
        },
	aggregateInput: function(component, event, helper) {
	    var formData = {
            employee_Location: null,
            biz_Box_Services: [],
            customer_Permission: null,
            marketing_optin: null,
            storenumber: null
	    };

	    // Employee ID
	    // Employee Name
	    // Employee Last Name
         var employee_Info = component.find("employee_Info");

         // Gets all the info for the employee and maps it in the the form data object.
         for(var m in employee_Info) {
            if(!employee_Info[m].get("v.validity").valid) {
                alert(employee_Info[m].get("v.label") + " is a required field.");
                // $A.util.addClass(employee_Info[i], "slds-has-error");
                return null;
            }

            console.log( employee_Info[m].get("v.name") + " " + employee_Info[m].get("v.validity").valid);
            formData[employee_Info[m].get("v.name")] = employee_Info[m].get("v.value");
         }

        if(component.get('v.validStore') == true )
        {
            formData.employee_Location = "Retail Stores";
            formData.storenumber = component.get('v.store');
        }
        else{
	    // Employee Location
        var employee_Location = component.find("employee_location_radio");
        for(var l in employee_Location) {
            if(employee_Location[l].get("v.checked")){
                formData.employee_Location = employee_Location[l].get("v.label");
                break;
            }

        }
        if (formData.employee_Location === null){
            alert("Employee Location is required.");
            return null;
         }
         var storenumber = component.find("storenumber");
                console.log(storenumber);
                if(storenumber.get("v.valueLabel") != null)
                {
                    formData.storenumber = storenumber.get("v.valueLabel");
                    console.log('Store number ' + formData.storenumber);
                }
                else
                {
                    formData.storenumber = storenumber.get("v.lookupInput");
                    console.log('Store number input' + formData.storenumber);
                }
                console.log('Emp Location' + formData.employee_Location);
                if(!formData.storenumber)
                 {
                     if(formData.employee_Location == "Retail Stores")
                     {
                         alert("Store required for Retail Stores location");
                         return null;
                     }
                 }
        }
        // Customer Information
        // BizBox Services
        var biz_Box_Services = component.find("services_checkbox");
        formData.biz_Box_Services = [];

        for(var j in biz_Box_Services) {
            if(biz_Box_Services[j].get("v.checked")){
                formData.biz_Box_Services.push(biz_Box_Services[j].get("v.value"));
            }
        }
        if (formData.biz_Box_Services.length === 0) {
            // alert("Customer BizBox Services is a required field.");
            formData.biz_Box_Services.push("");
        }

        // Business Name
        // Customer State
        // Customer First Name
        // Customer Last Name
        var customer_Info = component.find("customer_Info");

       // Gets all the info for the employee and maps it in the the form data object and make sure it is valid.
        for(var k in customer_Info) {
            formData[customer_Info[k].get("v.name")] = customer_Info[k].get("v.value");
            if(!customer_Info[k].get("v.validity").valid) {
                alert(customer_Info[k].get("v.label") + " is a required field.");
                // $A.util.addClass(customer_Info[i], "slds-has-error");
                return null;
            }
            if(customer_Info[k].get("v.name")=="contact_Time_frame" && customer_Info[k].get("v.value")==""){
                alert("When is the customer looking to take advantage of the service?" + " is a required field.");
                return null;
            }
        }

        var permissionSet = false;
        // Customer Position
        var customer_Permission = component.find("contact_radio");
            for(var n in customer_Permission) {
                if(customer_Permission[n].get("v.checked")){
                    permissionSet = true;
                    formData.customer_Permission = customer_Permission[n].get("v.value") === "true";
                    console.log('Customer Permission ' + formData.customer_Permission);
                    break;
                }
        }



        // Check customer permission
        if (!permissionSet){
            alert("Customer Contact permission status is required.");
            return null;
        }

         var offers = false;
                // Customer Position
                var offers_Permission = component.find("offers_radio");
                    for(var n in offers_Permission) {
                        if(offers_Permission[n].get("v.checked")){
                            offers = true;
                            formData.marketing_optin = offers_Permission[n].get("v.value") === "true";
                            console.log('Offer Permission ' + formData.marketing_optin);
                            break;
                        }
                }

                // Check customer permission
                if (!offers){
                    alert("Customer Offer Marketing permission is required.");
                    return null;
                }

        return formData;
    },
    commitInput: function(component, event, helper, input) {


        if(input == null) {
            console.log("Input is null. Are your input fields filled out correctly?");
            return;
        }
        console.log(input);
        var stringData = JSON.stringify([input]);
        var action = component.get("c.CreateLead");
        action.setParams({data:  stringData});

        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                component.set("v.RequestInProgress", false);
                var result = JSON.parse(response.getReturnValue());

                console.log(result);
                if(result[0].ErrorStatus === 0){
                    alert("Thank you for your submission! A BizBox pro will contact the customer within 24-48 hours.");
                    window.location.reload();
                }
                else {
                    alert("Uh Oh... Something appears to have gone wrong....\n" + result[0].Message);
                }

            }else if (state === "INCOMPLETE") {
                         console.log("Request in Progress");
            }else if(state=== "ERROR") {
                component.set("v.RequestInProgress", false);
                var errors = response.getError();
                if(errors) {
                    if (errors[0] && errors[0].message) {
                        console.log("Error message: " + errors[0].message);
                    }
                }else {
                    console.log("Unknown error occurred.");
                }
            }
        });

        component.set("v.RequestInProgress", true);
        $A.enqueueAction(action);
    }
})