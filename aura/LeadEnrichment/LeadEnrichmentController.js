({
    doInit: function(component, event, helper) {
        component.set("v.columns", [
            { label: "CEO Name", fieldName: "CEO_Name", type: "text" },
            { label: "Company Name", fieldName: "Ultimate_Name__c", type: "text" },
            { label: "Address", fieldName: "Address_1__c", type: "text" },
            { label: "City", fieldName: "City__c", type: "text" },
            { label: "State", fieldName: "State__c", type: "text" },
            { label: "Zip", fieldName: "Zip__c", type: "text" },
        ]);
            helper.doInitHelper(component, event);
            },
            afterScriptsLoaded: function (component, event, helper) {
            
            }
            });