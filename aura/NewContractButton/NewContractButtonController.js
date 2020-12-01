({
    
    /* On the component Load this function call the apex class method, 
    * which is return the list of RecordTypes of object 
    * and set it to the lstOfRecordType attribute to display record Type values
    * on ui:inputSelect component. */
    
    fetchListOfRecordTypes: function(component, event, helper) {
        //component.set("v.isStandardFlow",false);
        //console.log('inside init'+component.get("v.isStandardFlow"));
        var action = component.get("c.fetchRecordTypeValues");
        var opts=[];
        var recordTypesList = component.find("selectedRecordType");
        action.setCallback(this, function(response) {
            
            opts.push({
                class: "optionClass",
                label: "--- None ---",
                value: ""
            });
            for(var i=0;i< response.getReturnValue().length;i++){
                opts.push({"class": "optionClass", label: response.getReturnValue()[i], value: response.getReturnValue()[i]});
            }
            recordTypesList.set("v.options", opts);
            //component.set("v.lstOfRecordType", response.getReturnValue());
            //console.log("PickList-->"+component.get("v.lstOfRecordType"));
        });
        $A.enqueueAction(action);
    },
    
    /* In this "createRecord" function, first we have call apex class method 
    * and pass the selected RecordType values[label] and this "getRecTypeId"
    * apex method return the selected recordType ID.
    * When RecordType ID comes, we have call  "e.force:createRecord"
    * event and pass object API Name and 
    * set the record type ID in recordTypeId parameter. and fire this event
    * if response state is not equal = "SUCCESS" then display message on various situations.
    */
    createRecord: function(component, event, helper) {
        
        var valueSelected = component.find("selectedRecordType").get("v.value");
        console.log('value-->'+valueSelected);
        if(valueSelected != '')
        {
            if(valueSelected == 'Standard')
            {
                
                // In that component, start your flow. Reference the flow's API Name.
                component.set("v.isStandardFlow",true);
                var flow = component.find("flowData");
                var inputVariables = [
                    {
                        name : 'recordId',
                        type : 'String',
                        value : component.get("v.recordId")
                    }
                ]
                flow.startFlow("Create_Standard_Contract",inputVariables);
                
                
            }
            else
            {
                component.set("v.isOpen", true);
                
                var action = component.get("c.getRecTypeId");
                var recordTypeLabel = component.find("selectedRecordType").get("v.value");
                action.setParams({
                    "recordTypeLabel": recordTypeLabel
                });
                action.setCallback(this, function(response) {
                    var state = response.getState();
                    if (state === "SUCCESS") {
                        var createRecordEvent = $A.get("e.force:createRecord");
                        var RecTypeID  = response.getReturnValue();
                        console.log('RECId-->'+RecTypeID);
                        createRecordEvent.setParams({
                            "entityApiName": 'Contract',
                            "recordTypeId": RecTypeID
                        });
                        createRecordEvent.fire();
                        
                    } else if (state == "INCOMPLETE") {
                        var toastEvent = $A.get("e.force:showToast");
                        toastEvent.setParams({
                            "title": "Oops!",
                            "message": "No Internet Connection"
                        });
                        toastEvent.fire();
                        
                    } else if (state == "ERROR") {
                        var toastEvent = $A.get("e.force:showToast");
                        toastEvent.setParams({
                            "title": "Error!",
                            "message": "Please contact your administrator"
                        });
                        toastEvent.fire();
                    }
                });
                $A.enqueueAction(action);
            }
        }
        else
        {
            var toastEvent = $A.get("e.force:showToast");
            toastEvent.setParams({
                title : 'Warning',
                message: 'Please Select a Record Type',
                duration:' 5000',
                key: 'info_alt',
                type: 'warning',
                mode: 'dismissible'
            });
            toastEvent.fire();
        }
    },
    
    
    
})