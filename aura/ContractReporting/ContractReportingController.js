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
                component.find("OtherRowText1").set("v.value",component.get("v.fields").TextBox_1__c);
                
                console.log('Test2-->'+component.get("v.PenaltyPickListValues"));
            }else{
                alert('Callback Failed...');
            }
        });
        $A.enqueueAction(action);
		
	}
})