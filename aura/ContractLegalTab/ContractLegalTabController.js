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
    
 /**   recordLoaded : function(component,event,helper)
    {
        
        if(component.find("OtherRowCheckbox1").get("v.value") == true)
        {
            component.find("OtherRowCustFee1").set("v.disabled",false);
            component.find("OtherRowFeeLang1").set("v.disabled",false);
        }
        if(component.find("OtherRowCheckbox2").get("v.value") == true)
        {
            component.find("OtherRowCustFee2").set("v.disabled",false);
            component.find("OtherRowFeeLang2").set("v.disabled",false);
        }
        if(component.find("OtherRowCheckbox3").get("v.value") == true)
        {
            component.find("OtherRowCustFee3").set("v.disabled",false);
            component.find("OtherRowFeeLang3").set("v.disabled",false);
        }
    },
    
    makeItEditable : function(component,event,helper)
    {
        console.log("Test"+component.find("OtherRowCheckbox1").get("v.value"));
        var callingComponent = event.getSource().getLocalId();
        if(callingComponent == 'OtherRowCheckbox1')
        {
            if(component.find("OtherRowCheckbox1").get("v.value") == true)
            {
                component.find("OtherRowCustFee1").set("v.disabled",false);
                component.find("OtherRowFeeLang1").set("v.disabled",false); 
            }
            else
            {
                component.find("OtherRowCustFee1").set("v.disabled",true);
                component.find("OtherRowFeeLang1").set("v.disabled",true);
                component.find("OtherRowCustFee1").set("v.value",'');
                component.find("OtherRowFeeLang1").set("v.value",'');
            }
        }
        
        else if(callingComponent == 'OtherRowCheckbox2')
        {
            if(component.find("OtherRowCheckbox2").get("v.value") == true)
            {
                component.find("OtherRowCustFee2").set("v.disabled",false);
                component.find("OtherRowFeeLang2").set("v.disabled",false); 
            }
            else
            {
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
            else
            {
                component.find("OtherRowCustFee3").set("v.disabled",true);
                component.find("OtherRowFeeLang3").set("v.disabled",true);
                component.find("OtherRowCustFee3").set("v.value",'');
                component.find("OtherRowFeeLang3").set("v.value",'');
            }
        }
    }, **/
})