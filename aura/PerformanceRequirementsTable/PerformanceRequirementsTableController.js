({
    doInit : function(component, event, helper) {
        
        var action = component.get("c.getselectOptions");
        action.setParams({
            "objObject": component.get("v.objInfo"),
            "fld": 'Performance_Notification_Requirements__c'
        });
        var opts = [];
        action.setCallback(this, function(response) {
            if (response.getState() == "SUCCESS") {
                var allValues = response.getReturnValue();
                
                for (var i = 0; i < allValues.length; i++) {
                    
                    var PenaltyCheckBoxValue = false;
                    var YesCheckBoxValue = false;
                    if(component.get("v.fields").Penalty_for_not_meeting__c != null)
                    {
                        if(component.get("v.fields").Penalty_for_not_meeting__c.includes(allValues[i]))
                        {
                            PenaltyCheckBoxValue = true;
                        }
                        else
                        {
                            PenaltyCheckBoxValue = false;
                        }
                        
                    } 
                    
                    if(component.get("v.fields").Performance_Notification_Requirements__c != null)
                    {
                        if(component.get("v.fields").Performance_Notification_Requirements__c.includes(allValues[i]))
                        {
                            YesCheckBoxValue = true;
                        }
                        else
                        {
                            YesCheckBoxValue = false;
                        }
                        
                    }  
                    
                    
                    
                    opts.push({
                        PickListVal: allValues[i],
                        YesCheckBox:YesCheckBoxValue,
                        PenaltyCheckBox: PenaltyCheckBoxValue
                    });
                }
                opts.splice(4,1);
                component.set("v.PicklistOptions", opts);
                component.set("v.YesCheckBoxValues",component.get("v.fields").Performance_Notification_Requirements__c);
                component.set("v.PenaltyPickListValues",component.get("v.fields").Penalty_for_not_meeting__c);
                var variable1 = JSON.stringify(component.get("v.YesCheckBoxValues"));
                
                variable1 = variable1.slice(0, -1);
                variable1 = variable1.substr(1);
                variable1 = variable1.slice(0, -1);
                variable1 = variable1.substr(1);
                console.log(variable1);
                var variable2 = JSON.stringify(component.get("v.PenaltyPickListValues"));
                variable2 = variable2.slice(0, -1);
                variable2 = variable2.substr(1);
                variable2 = variable2.slice(0, -1);
                variable2 = variable2.substr(1);
                var tempVar1 = variable1.split(';');
                var tempVar2 = variable2.split(';');
                var tempList1 = [];
                var tempList2 = [];
                
                for(var k in tempVar1)
                {
                    tempList1.push(tempVar1[k]);
                }
                for(var j in tempVar2)
                {
                    tempList2.push(tempVar2[j]);
                }
                
                component.set("v.YesCheckBoxValues",tempList1);
                component.set("v.PenaltyPickListValues",tempList2);
                console.log('Test1-->'+component.get("v.YesCheckBoxValues"));
                console.log('Test2-->'+component.get("v.PenaltyPickListValues"));
            }else{
                alert('Callback Failed...');
            }
        });
        $A.enqueueAction(action);
        
        
        
    },
    
    recordLoaded : function(component,event,helper)
    {
        if(component.find("OtherRowCheckbox1").get("v.value") == true)
        {
            component.find("OtherRowText1").set("v.disabled",false);
            component.find("OtherRowPenalty1").set("v.disabled",false);
        }
        if(component.find("OtherRowCheckbox2").get("v.value") == true)
        {
            component.find("OtherRowText2").set("v.disabled",false);
            component.find("OtherRowPenalty2").set("v.disabled",false);
        }
        if(component.find("OtherRowCheckbox3").get("v.value") == true)
        {
            component.find("OtherRowText3").set("v.disabled",false);
            component.find("OtherRowPenalty3").set("v.disabled",false);
        }
    },
    
    saveYesValues : function(component,event,helper)
    {
        var SelectedCheckBox = event.getSource().get("v.name");
        var PerfomancePickListVals = component.get("v.PicklistOptions");
        var PenaltyValues = component.get("v.PenaltyPickListValues");
        var blankValues = [];
        blankValues = component.get("v.PicklistOptions");
        if(component.get("v.YesCheckBoxValues") != null)
            var YesValues = component.get("v.YesCheckBoxValues");
        else
            var YesValues =[];
        
        for(var i=0;i<=PerfomancePickListVals.length;i++)
        {
            if(SelectedCheckBox == i && event.getSource().get("v.value") == true)
            {
                
                var PerfomancePickListValue = component.get("v.PicklistOptions")[SelectedCheckBox].PickListVal;
                console.log("picklistval 1-->"+SelectedCheckBox);
                
                YesValues.push(PerfomancePickListValue);
                
            }
            else if(SelectedCheckBox == i && event.getSource().get("v.value") == false)
            {
                blankValues[SelectedCheckBox].PenaltyCheckBox = false;
                var PerfomancePickListValue = component.get("v.PicklistOptions")[SelectedCheckBox].PickListVal;
                var elementToBeRemovedYesValues = YesValues.indexOf(PerfomancePickListValue);
                var elementToBeRemovedPenaltyValues = PenaltyValues.indexOf(PerfomancePickListValue);
                YesValues.splice(elementToBeRemovedYesValues,1);
                PenaltyValues.splice(elementToBeRemovedPenaltyValues,1);
            }
        }
        console.log('Testng-->'+JSON.stringify(blankValues));
        component.set("v.PicklistOptions",blankValues);
        component.set("v.YesCheckBoxValues",YesValues);
        component.set("v.PenaltyPickListValues",PenaltyValues);
        console.log('YesCheckBoxValues-->'+component.get("v.YesCheckBoxValues"));
        console.log('PenaltyPickListValues-->'+component.get("v.PenaltyPickListValues"));
    },
    
    saveInPenaltyPicklist : function(component,event,helper)
    {
        
        var SelectedCheckBox = event.getSource().get("v.name");
        var PerfomancePickListVals = component.get("v.PicklistOptions");
        // var ListsOf = component.get("v.PicklistOptions");
        console.log("PicklistOptions-->"+PerfomancePickListVals.length);
        
        if(component.get("v.PenaltyPickListValues") != null)
            var penaltyPickListVals = component.get("v.PenaltyPickListValues");
        else
            var penaltyPickListVals =[];
        
        for(var i=0;i<=PerfomancePickListVals.length;i++)
        {
            if(SelectedCheckBox == i && event.getSource().get("v.value") == true)
            {
                var PerfomancePickListValue = component.get("v.PicklistOptions")[SelectedCheckBox].PickListVal;
                console.log("picklistval 1-->"+SelectedCheckBox);
                
                penaltyPickListVals.push(PerfomancePickListValue);
                
            }
            else if(SelectedCheckBox == i && event.getSource().get("v.value") == false)
            {
                var PerfomancePickListValue = component.get("v.PicklistOptions")[SelectedCheckBox].PickListVal;
                var elementToBeRemoved = penaltyPickListVals.indexOf(PerfomancePickListValue);
                penaltyPickListVals.splice(elementToBeRemoved,1);
            }
        }
        
        //component.set("v.PicklistOptions",ListsOf);
        component.set("v.PenaltyPickListValues",penaltyPickListVals);
        console.log('penaltyPickListVals-->'+component.get("v.PenaltyPickListValues"));
    },
    
    makeItEditable : function(component,event,helper)
    {
        var callingComponent = event.getSource().getLocalId();
        
        if(callingComponent == 'OtherRowCheckbox1')
        {
            if(component.find(callingComponent).get("v.value") == true)
            {
                component.find("OtherRowText1").set("v.disabled",false);
                component.find("OtherRowPenalty1").set("v.disabled",false);
            }
            else
            {
                component.find("OtherRowText1").set("v.disabled",true);
                component.find("OtherRowPenalty1").set("v.disabled",true);
                component.find("OtherRowText1").set("v.value",'');
                component.find("OtherRowPenalty1").set("v.value",false);
            }                
        }
        
        
        if(callingComponent == 'OtherRowCheckbox2')
        {
            if(component.find(callingComponent).get("v.value") == true)
            {
                component.find("OtherRowText2").set("v.disabled",false);
                component.find("OtherRowPenalty2").set("v.disabled",false);
            }
            else
            {
                component.find("OtherRowText2").set("v.disabled",true);
                component.find("OtherRowPenalty2").set("v.disabled",true);
                component.find("OtherRowText2").set("v.value",'');
                component.find("OtherRowPenalty2").set("v.value",false);
            }  
        }
        
        if(callingComponent == 'OtherRowCheckbox3')
        {
            if(component.find(callingComponent).get("v.value") == true)
            {
                component.find("OtherRowText3").set("v.disabled",false);
                component.find("OtherRowPenalty3").set("v.disabled",false);
            }
            else
            {
                component.find("OtherRowText3").set("v.disabled",true);
                component.find("OtherRowPenalty3").set("v.disabled",true);
                component.find("OtherRowText3").set("v.value",'');
                component.find("OtherRowPenalty3").set("v.value",false);
            }  
        }
        
    },
    
    insertPickListValues : function(component,event,helper)
    {
        console.log('Test insert');
        var callingComponent = event.getSource().getLocalId();
        if(callingComponent == 'OtherRowText1' && (component.find(callingComponent).get("v.value") != null || component.find(callingComponent).get("v.value") != undefined || component.find(callingComponent).get("v.value") != '' ))
        {
            component.set("v.PerfomanceText1",component.find(callingComponent).get("v.value"));
            component.set("v.PenaltyText1",component.find(callingComponent).get("v.value"));
        }
        
        if(callingComponent == 'OtherRowText2' && (component.find(callingComponent).get("v.value") != null || component.find(callingComponent).get("v.value") != undefined || component.find(callingComponent).get("v.value") != '' ))
        {
            component.set("v.PerfomanceText2",component.find(callingComponent).get("v.value"));
            component.set("v.PenaltyText2",component.find(callingComponent).get("v.value"));
        }
        
        if(callingComponent == 'OtherRowText3' && (component.find(callingComponent).get("v.value") != null || component.find(callingComponent).get("v.value") != undefined || component.find(callingComponent).get("v.value") != '' ))
        {
            component.set("v.PerfomanceText3",component.find(callingComponent).get("v.value"));
            component.set("v.PenaltyText3",component.find(callingComponent).get("v.value"));
        }
    },
    
    onRecordSubmit: function(component, event, helper) {
        event.preventDefault(); // stop form submission
        var eventFields = event.getParam("fields");
        var PenaltyPicklistToBeStored = '';
        var PerfomanceValuesToBeStored = '';
        var listValues = component.get("v.PenaltyPickListValues");
        var PerfomanceValues = component.get("v.YesCheckBoxValues");
        console.log('Test1-->'+component.get("v.PenaltyPickListValues"));
        console.log('Test2-->'+component.get("v.YesCheckBoxValues"));
        
        var validateInput = helper.validateHelper(component,event,helper,listValues,PerfomanceValues)
        
        if(validateInput)
        {
            for(var Str in listValues) {
                
                //PenaltyPicklistToBeStored = listValues[Str];
                
                PenaltyPicklistToBeStored = PenaltyPicklistToBeStored + ';' + listValues[Str];
                
            }
            
            for(var Str1 in PerfomanceValues) {
                
                //PenaltyPicklistToBeStored = listValues[Str];
                
                PerfomanceValuesToBeStored = PerfomanceValuesToBeStored + ';' + PerfomanceValues[Str1];
                
            }
            
            console.log("values before saving-->"+PenaltyPicklistToBeStored);
            console.log("values before saving-->"+PerfomanceValuesToBeStored);
            eventFields["Penalty_for_not_meeting__c"] = PenaltyPicklistToBeStored;
            eventFields["Performance_Notification_Requirements__c"] = PerfomanceValuesToBeStored;
            eventFields["TextBox_1__c"] = component.get("v.PerfomanceText1");
            eventFields["TextBox_2__c"] = component.get("v.PerfomanceText2");
            eventFields["TextBox_3__c"] = component.get("v.PerfomanceText3");
            eventFields["TextBox_3_Penalty__c"] = component.find("OtherRowPenalty3").get("v.value");
            eventFields["TextBox_2_Penalty__c"] = component.find("OtherRowPenalty2").get("v.value");
            eventFields["TextBox_1_Penalty__c"] = component.find("OtherRowPenalty1").get("v.value");
            eventFields["TextBox_1_Yes__c"] = component.find("OtherRowCheckbox1").get("v.value");
            eventFields["TextBox_2_Yes__c"] = component.find("OtherRowCheckbox2").get("v.value");;
            eventFields["TextBox_3_Yes__c"] = component.find("OtherRowCheckbox3").get("v.value");
            //eventFields["Lang_in_contract_for_Perf_Notif_Requirem__c"] = PenaltyPicklistToBeStored;
            component.find('myForm11').submit(eventFields);
            
            
            var toastEvent = $A.get("e.force:showToast");
            toastEvent.setParams({
                "title": "Success!",
                "message": "Saved Successfully."
            });
            toastEvent.fire();
            
            
            
        }
        else{
            var toastEvent = $A.get("e.force:showToast");
            toastEvent.setParams({
                "title": "Error!",
                "message": "Please enter correct Inputs."
            });
            toastEvent.fire();
        }
    }
})