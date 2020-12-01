({
	doInit : function(component, event, helper) {
        
        var action = component.get("c.getselectOptions");
        action.setParams({
            "objObject": component.get("v.objInfo"),
            "fld": 'Customer_fees__c'
        });
        var opts = [];
        action.setCallback(this, function(response) {
            if (response.getState() == "SUCCESS") {
                var allValues = response.getReturnValue();
                var FeeLanguageVal;
                var YesCheckBox;
                 for(var i in allValues)
                 {
                     console.log('Test-->'+allValues[i]);
                    if(allValues[i] == 'Bulk item')
                    {
                        if(component.get("v.fields").Bulk_item_fee_language__c != null)
                            YesCheckBox = true;
                        else
                            YesCheckBox = false;
                            
                        opts.push({
                            PickListVal: allValues[i],
                            YesCheckBox:YesCheckBox,
                            FeeLanguage:component.get("v.fields").Bulk_item_fee_language__c
                        });
                    }
                    if(allValues[i] == 'Customer item warehousing')
                    {
                        if(component.get("v.fields").Customer_item_warehousing_fee_language__c != null)
                            YesCheckBox = true;
                        else
                            YesCheckBox = false;
                        
                        opts.push({
                            PickListVal: allValues[i],
                            YesCheckBox:YesCheckBox,
                            FeeLanguage:component.get("v.fields").Customer_item_warehousing_fee_language__c
                        });
                    }
                    if(allValues[i] == 'Desktop delivery')
                    {
                        if(component.get("v.fields").Desktop_delivery_fee_language__c != null)
                            YesCheckBox = true;
                        else
                            YesCheckBox = false;
                        
                        opts.push({
                            PickListVal: allValues[i],
                            YesCheckBox:YesCheckBox,
                            FeeLanguage:component.get("v.fields").Desktop_delivery_fee_language__c
                        });
                    }
                    if( allValues[i] == 'EDI')
                    {
                        if(component.get("v.fields").EDI_fee_language__c != null)
                            YesCheckBox = true;
                        else
                            YesCheckBox = false;
                        
                        opts.push({
                            PickListVal: allValues[i],
                            YesCheckBox:YesCheckBox,
                            FeeLanguage:component.get("v.fields").EDI_fee_language__c
                        });
                    }
                    if( allValues[i] == 'Hosted catalog')
                    {
                        if(component.get("v.fields").Hosted_catalog_fee_language__c != null)
                            YesCheckBox = true;
                        else
                            YesCheckBox = false;
                        
                        opts.push({
                            PickListVal: allValues[i],
                            YesCheckBox:YesCheckBox,
                            FeeLanguage:component.get("v.fields").Hosted_catalog_fee_language__c
                        });
                    }
                    if(allValues[i] == 'Imports')
                    {
                        if(component.get("v.fields").Imports_fee_language__c != null)
                            YesCheckBox = true;
                        else
                            YesCheckBox = false;
                        
                        opts.push({
                            PickListVal: allValues[i],
                            YesCheckBox:YesCheckBox,
                            FeeLanguage:component.get("v.fields").Imports_fee_language__c
                        });
                    }
                    if(allValues[i] == 'Printed catalog')
                    {
                        if(component.get("v.fields").Printed_catalog_fee_language__c != null)
                            YesCheckBox = true;
                        else
                            YesCheckBox = false;
                        
                        opts.push({
                            PickListVal: allValues[i],
                            YesCheckBox:YesCheckBox,
                            FeeLanguage:component.get("v.fields").Printed_catalog_fee_language__c
                        });
                    }
                    if(allValues[i] == 'Reporting')
                    {
                        if(component.get("v.fields").Reporting_fee_language__c != null)
                            YesCheckBox = true;
                        else
                            YesCheckBox = false;
                        
                        opts.push({
                            PickListVal: allValues[i],
                            YesCheckBox:YesCheckBox,
                            FeeLanguage:component.get("v.fields").Reporting_fee_language__c
                        });
                    }
                    if(allValues[i] == 'Return')
                    {
                        if(component.get("v.fields").Return_fee_language__c != null)
                            YesCheckBox = true;
                        else
                            YesCheckBox = false;
                        
                        opts.push({
                            PickListVal: allValues[i],
                            YesCheckBox:YesCheckBox,
                            FeeLanguage:component.get("v.fields").Return_fee_language__c
                        });
                    }
                    if(allValues[i] == 'Storeroom stocking')
                    {
                        if(component.get("v.fields").Storeroom_stocking_fee_language__c != null)
                            YesCheckBox = true;
                        else
                            YesCheckBox = false;
                        
                        opts.push({
                            PickListVal: allValues[i],
                            YesCheckBox:YesCheckBox,
                            FeeLanguage:component.get("v.fields").Storeroom_stocking_fee_language__c
                        });
                    }
                    if(allValues[i] == 'VW shipping')
                    {
                        if(component.get("v.fields").VW_shipping_fee_language__c != null)
                            YesCheckBox = true;
                        else
                            YesCheckBox = false;
                        
                        opts.push({
                            PickListVal: allValues[i],
                            YesCheckBox:YesCheckBox,
                            FeeLanguage:component.get("v.fields").VW_shipping_fee_language__c
                        });
                    }
                    
                 }
                
                //opts.splice(4,1);
                component.set("v.PicklistOptions", opts);
            }else{
                alert('Callback Failed...');
            }
        });
        $A.enqueueAction(action);
        
        
        
        
		
	},
    
    recordLoaded : function(component,event,helper)
    {
        console.log('Test'+component.find("OtherRowCheckbox2").get("v.value"));
        if(component.find("OtherRowCheckbox1").get("v.value") == true)
        {
            component.find("OtherRowCustFee1").set("v.disabled",false);
            component.find("OtherRowFeeLang1").set("v.disabled",false);
        }
        else
        {
            component.find("OtherRowCustFee1").set("v.disabled",true);
            component.find("OtherRowFeeLang1").set("v.disabled",true);
        }
        if(component.find("OtherRowCheckbox2").get("v.value") == true)
        {
            component.find("OtherRowCustFee2").set("v.disabled",false);
            component.find("OtherRowFeeLang2").set("v.disabled",false);
        }
        else
        {
            component.find("OtherRowCustFee2").set("v.disabled",true);
            component.find("OtherRowFeeLang2").set("v.disabled",true);
        }
        if(component.find("OtherRowCheckbox3").get("v.value") == true)
        {
            component.find("OtherRowCustFee3").set("v.disabled",false);
            component.find("OtherRowFeeLang3").set("v.disabled",false);
        }
        else
        {
            component.find("OtherRowCustFee3").set("v.disabled",true);
            component.find("OtherRowFeeLang3").set("v.disabled",true);
        }
    },
    
    makeItEditable : function(component,event,helper)
    {
        
        var callingComponent = event.getSource().getLocalId();
        var callingComponentName = event.getSource().get("v.name");
        var blankValues = [];
        blankValues = component.get("v.PicklistOptions");
        for(var i=0;i<component.get("v.PicklistOptions").length;i++)
        {
            if(callingComponentName == i && event.getSource().get("v.value") == false)
            {
                blankValues[callingComponentName].FeeLanguage = '';
            }
        }
        
        component.set("v.PicklistOptions",blankValues);
        
        if(callingComponent == 'OtherRowCheckbox1')
        {
            if(component.find("OtherRowCheckbox1").get("v.value") == true)
            {
                component.find("OtherRowCustFee1").set("v.disabled",false);
                component.find("OtherRowFeeLang1").set("v.disabled",false); 
            }
            else if(component.find("OtherRowCheckbox1").get("v.value") == false)
            {
                component.find("OtherRowCustFee1").set("v.disabled",true);
                component.find("OtherRowFeeLang1").set("v.disabled",true);
                component.find("OtherRowCustFee1").set("v.value",'');
                component.find("OtherRowFeeLang1").set("v.value",'');
            }
        }
        
        else if(callingComponent == 'OtherRowCheckbox2')
        {
            console.log("Test true");
            if(component.find("OtherRowCheckbox2").get("v.value") == true)
            {
                component.find("OtherRowCustFee2").set("v.disabled",false);
                component.find("OtherRowFeeLang2").set("v.disabled",false); 
            }
            else if(component.find("OtherRowCheckbox2").get("v.value") == false)
            {
                console.log("Test false");
                component.find("OtherRowCustFee2").set("v.disabled",true);
                component.find("OtherRowFeeLang2").set("v.disabled",true);
                component.find("OtherRowCustFee2").set("v.value",'');
                component.find("OtherRowFeeLang2").set("v.value",'');
            }
        }
        
        else if(callingComponent == 'OtherRowCheckbox3')
        {
            if(component.find("OtherRowCheckbox3").get("v.value") == true)
            {
                component.find("OtherRowCustFee3").set("v.disabled",false);
                component.find("OtherRowFeeLang3").set("v.disabled",false); 
            }
            else if(component.find("OtherRowCheckbox3").get("v.value") == false)
            {
                component.find("OtherRowCustFee3").set("v.disabled",true);
                component.find("OtherRowFeeLang3").set("v.disabled",true);
                component.find("OtherRowCustFee3").set("v.value",'');
                component.find("OtherRowFeeLang3").set("v.value",'');
            }
        }
    },
    
    
    onRecordSubmit: function(component, event, helper) {
        event.preventDefault(); // stop form submission
        var eventFields = event.getParam("fields");
        
        
        for(var i in component.get("v.PicklistOptions"))
        {
            
            if(component.get("v.PicklistOptions")[i].PickListVal == 'Bulk item')
            {
                console.log('Test-->'+JSON.stringify(component.get("v.PicklistOptions")[i].FeeLanguage));
                eventFields["Bulk_item_fee_language__c"] = component.get("v.PicklistOptions")[i].FeeLanguage;
            }
            else if(component.get("v.PicklistOptions")[i].PickListVal == 'Customer item warehousing')
            {
                eventFields["Customer_item_warehousing_fee_language__c"] = component.get("v.PicklistOptions")[i].FeeLanguage;
            }
            else if(component.get("v.PicklistOptions")[i].PickListVal == 'Desktop delivery')
            {
                eventFields["Desktop_delivery_fee_language__c"] = component.get("v.PicklistOptions")[i].FeeLanguage;
            }
            else if(component.get("v.PicklistOptions")[i].PickListVal == 'EDI')
            {
                eventFields["EDI_fee_language__c"] = component.get("v.PicklistOptions")[i].FeeLanguage;
            }
            else if(component.get("v.PicklistOptions")[i].PickListVal == 'Hosted catalog')
            {
                eventFields["Hosted_catalog_fee_language__c"] = component.get("v.PicklistOptions")[i].FeeLanguage;
            }
            else if(component.get("v.PicklistOptions")[i].PickListVal == 'Imports')
            {
                eventFields["Imports_fee_language__c"] = component.get("v.PicklistOptions")[i].FeeLanguage;
            }
            else if(component.get("v.PicklistOptions")[i].PickListVal == 'Printed catalog')
            {
                eventFields["Printed_catalog_fee_language__c"] = component.get("v.PicklistOptions")[i].FeeLanguage;
            }
            else if(component.get("v.PicklistOptions")[i].PickListVal == 'Reporting')
            {
                eventFields["Reporting_fee_language__c"] = component.get("v.PicklistOptions")[i].FeeLanguage;
            }
            else if(component.get("v.PicklistOptions")[i].PickListVal == 'Return')
            {
                eventFields["Return_fee_language__c"] = component.get("v.PicklistOptions")[i].FeeLanguage;
            }
            else if(component.get("v.PicklistOptions")[i].PickListVal == 'Storeroom stocking')
            {
                eventFields["Storeroom_stocking_fee_language__c"] = component.get("v.PicklistOptions")[i].FeeLanguage;
            }
            else if(component.get("v.PicklistOptions")[i].PickListVal == 'VW shipping')
            {
                eventFields["VW_shipping_fee_language__c"] = component.get("v.PicklistOptions")[i].FeeLanguage;
            }
            
        }
        
        
        eventFields["Customer_Fees_Other_1__c"] = component.find("OtherRowCustFee1").get("v.value");
        eventFields["Customer_Fees_Other_2__c"] = component.find("OtherRowCustFee2").get("v.value");
        eventFields["Customer_Fees_Other_3__c"] = component.find("OtherRowCustFee3").get("v.value");
        eventFields["Fee_Language_Other_1__c"] = component.find("OtherRowFeeLang1").get("v.value");
        eventFields["Fee_Language_Other_2__c"] = component.find("OtherRowFeeLang2").get("v.value");
        eventFields["Fee_Language_Other_3__c"] = component.find("OtherRowFeeLang3").get("v.value");
        component.find('myForm').submit(eventFields);
        
        
            var toastEvent = $A.get("e.force:showToast");
            toastEvent.setParams({
                "title": "Success!",
                "message": "Saved Successfully."
            });
            toastEvent.fire();

        
    },
})