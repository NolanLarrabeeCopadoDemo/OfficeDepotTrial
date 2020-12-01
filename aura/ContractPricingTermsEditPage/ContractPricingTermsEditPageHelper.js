({
    doInithelper : function(component, event, helper) {
        
        var recordId = component.get("v.recordId");//LINE 4
        //alert(recordId);
        
        component.find("CPTRecordCreator").getNewRecord(
            "Contract_Pricing_Terms__c",
            null,
            false,
            $A.getCallback(function() {
                component.set("v.newCPT.Contract__c",component.get("v.parentrecordId"));
                component.set("v.fields.Contract__c", component.get("v.parentrecordId"));
                var rec = component.get("v.newCPT");
                //alert(component.find("currentdate").get("v.value"));
                
            })
            
        );
        // Department Group and Department logic
        if(!$A.util.isEmpty(component.get("v.recordId")))
            this.initialize(component, event, helper);
        else
            this.initialize_New(component, event, helper);
    },
    initialize_New : function(component, event, helper){
        var action = component.get("c.startInit_New");
        var opts = [];
        action.setCallback(this, function(response) {
            var state = response.getState();
            // alert(state);
            if (state === "SUCCESS") {
                var result = response.getReturnValue();
                console.log('result---'+result);
                console.log('result.length---'+result.length);
                //alert(response.getReturnValue());
                for (var i = 0; i < result.length; i++) {
                    opts.push({
                        "label": result[i],
                        "value": result[i]
                    });
                }
                console.log('opts---'+opts);
                component.set("v.listOptions",opts);
                console.log('listOptions---'+component.get("v.listOptions"));
            }
            else if (state === "ERROR") {
                alert('error in edit page An Error Occurred, please consult your browser console.');
                var errors = response.getError();
                for( var i = 0; i < errors.length; i++){
                    console.log(errors[i].message);
                }
            }
        });
        $A.enqueueAction(action);
    },
    
    initialize : function(component, event, helper) {
        var recId = component.get("v.recordId");
        console.log('in initialize-----');
        //alert('recId'+recId);
        //alert('hi===='+component.get("v.recordId"));
        
        var action = component.get("c.startInit");
        
        action.setParams({RecordId:  recId});
        
        var opts = [];
        action.setCallback(this, function(response) {
            var state = response.getState();
            // alert(state);
            if (state === "SUCCESS") {
                var result = response.getReturnValue();
                console.log('result---'+result);
                var dep = result.CompDepList;
                console.log('dep---'+dep);
                var selDep = result.onloadDepList;
                console.log('selDep---'+selDep);
                //alert(response.getReturnValue());
                for (var i = 0; i < dep.length; i++) {
                    
                    opts.push({
                        "label": dep[i],
                        "value": dep[i]
                    });
                }
                
                var depval=[];
                component.set("v.listOptions",opts);
                console.log('listOptions---'+component.get("v.listOptions"));
                var optsSelected = [];
                for (var i = 0; i < selDep.length; i++) {
                    
                    optsSelected.push({
                        "label": selDep[i],
                        "value": selDep[i]
                    });
                }
                console.log('optsSelected.length----'+optsSelected.length);
                for (var i = 0; i < optsSelected.length; i++){
                    depval.push(
                        optsSelected[i].value
                    )
                }
                component.set("v.defaultOptions",depval);
                console.log('defaultOptions--123-'+ component.get("v.defaultOptions"));
                
            }
            else if (state === "ERROR") {
                alert('edit page An Error Occurred, please consult your browser console.');
                var errors = response.getError();
                for( var i = 0; i < errors.length; i++){
                    console.log(errors[i].message);
                }
            }
        });
        
        $A.enqueueAction(action);
    },
    saveRecordhelper : function(component, event, helper) {
      
        component.set("v.fields.Contract__c", component.get("v.parentrecordId"));
        //alert('============PrivateBrand1===='+component.find("PrivateBrand1").get("v.checked"));
        // alert('============PrivateBrand2===='+component.find("PrivateBrand2").get("v.checked"));
        //component.set("v.fields.Private_Brand__c",true);
        //  alert('============PrivateBrand1===='+ component.get("v.fields.Private_Brand__c"));
        
        // Departments 
        var vals=component.get("v.defaultOptions");
        console.log('==vals=='+vals);
        var str = String(vals);
        //str = arr.join([separator = ','])
       // alert(component.get("v.defaultOptions").join(';'));
        var res = component.get("v.defaultOptions").join(';');
       //ert('==res=='+res);
        component.set("v.fields.Departments__c", res);
        console.log('==v.fields.Departments__c=='+component.get("v.fields.Departments__c"));
       // component.set("v.fields.Private_Brand__c", true);
        var depgrps = component.find("DepGroup").get("v.value");
        console.log('depgrps--'+depgrps);
        var str2 = JSON.stringify(depgrps);
        console.log('str2--'+str2);
        if(!$A.util.isEmpty(depgrps) && depgrps.includes("Select All")){
            component.set("v.fields.Department_Groups__c", "Select All");
        }
        
       var action = component.get("c.upsert_CPT");
        // var fields = event.getParam("fields");
       // alert(fields);
         //console.log(JSON.stringify(component.get("v.fields")));
        action.setParams({ CPT : component.get("v.fields") });
        action.setCallback(this, function(response) {
            var state = response.getState();
            //alert(state);
            var result = response.getReturnValue();
           // alert(result);
            if (state === "SUCCESS") {
                 var result = response.getReturnValue();
                if(result.StatusCode === -1){
                     component.find("edit").submit();
                     var recordLoader = component.find("CPTRecordCreator");
        recordLoader.saveRecord($A.getCallback(function(saveResult) {
            if (saveResult.state === "ERROR") {
                var errMsg = "";
                // saveResult.error is an array of errors, 
                // so collect all errors into one message
                for (var i = 0; i < saveResult.error.length; i++) {
                    errMsg += saveResult.error[i].message + "\n";
                }
                //alert("Hi1");
               // component.set("v.error", errMsg);
            } else {
                component.set("v.error", "");
                alert("Hi2");
            }
       }));
                    component.set("v.validationError",true);
                    console.log(result);
                    var ErrorStatus;
                    var ErrorMessage
                    if(result.Status.includes("VALIDATION_EXCEPTION,")){
                        ErrorStatus = result.Status.split("VALIDATION_EXCEPTION,");
                        ErrorMessage = ErrorStatus[1].replace(/&quot;/g, '"');
                    } else if(result.Status.includes("UNKNOWN_EXCEPTION,")){
                        ErrorStatus = result.Status.split("UNKNOWN_EXCEPTION,");
                        ErrorMessage = ErrorStatus[1].replace(/&quot;/g, '"');
                    } else if(result.Status.includes("REQUIRED_FIELD_MISSING, ")){
                        ErrorStatus = result.Status.split("REQUIRED_FIELD_MISSING,");
                        ErrorMessage = ErrorStatus[1].replace(/&quot;/g, '"');
                    } else if(result.Status.includes("FIELD_INTEGRITY_EXCEPTION, ")){
                        ErrorStatus = result.Status.split("FIELD_INTEGRITY_EXCEPTION,");
                        ErrorMessage = ErrorStatus[1].replace(/&quot;/g, '"');
                    } else {
                        ErrorMessage = result.Status;
                    }
                    //alert(ErrorMessage);
                    component.set("v.errorMessages", ErrorMessage);
                }
                else if(result == null){
                   
                } else{
                     var loadrec = "true";
                      
                }   
            }
            else if (state === "ERROR") {
                var errors = response.getError();
                 console.log("error"+response.getError());
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        console.log("Error message: " + errors[0].message);
                        alert("error"+errors[0].message);
                    }
                } else {
                    console.log("Unknown error");
                }
            }
      if(loadrec=="true"){
            if(component.get("v.SaveNewFlag")==false)
                //alert(component.get("v.SaveNewFlag"));
                window.open('/apex/ContractPricingTermsPage?ParentId='+component.get("v.parentrecordId")+'&mode=Edit', '_self');
            if(component.get("v.SaveNewFlag")==true)
                //alert(component.get("v.SaveNewFlag"));
                //window.open('/apex/springcmContract2?id='+component.get("v.parentrecordId"),'_self');
               window.open('/' + component.get("v.parentrecordId"), '_self');
            }
        });
        $A.enqueueAction(action);
           /*    //var result = response.getReturnValue();
                //cmp.set("v.Spinner", false);               
               //cmp.set("v.isRecordCreated", true);
                var loadrec = "true";
                
            } 
                     else if (state === "INCOMPLETE") {
                // do something
            }
            else if (state === "ERROR") {
                //cmp.set("v.Spinner", false);
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
                    cmp.set("v.errorMessages", 'Looks like an error occurred while submitting the CPT.');

                }
            }
            if(loadrec=="true"){
            if(component.get("v.SaveNewFlag")==false)
                //alert(component.get("v.SaveNewFlag"));
                window.open('/apex/ContractPricingTermsPage?ParentId='+component.get("v.parentrecordId")+'&mode=Edit', '_self');
            if(component.get("v.SaveNewFlag")==true)
                //alert(component.get("v.SaveNewFlag"));
                window.open('/apex/springcmContract2?id='+component.get("v.parentrecordId"),'_self');
            }
        });
        
        
        */
    },
    savenewRecordhelper: function(component, event, helper) {
       //  component.set("v.loads",true);
        //component.set("v.load",false);
        component.set("v.SaveNewFlag",true);
       // alert('4'+component.get("v.SaveNewFlag"));
        this.saveRecordhelper(component, event, helper);
        component.set("v.SaveNewFlag",false);
        window.location.reload();
        //window.location.href();
        //commented by Ramalakshmi 4/3/19
        //window.open('/' +'mode=Edit&ParentId='+ component.get("v.parentrecordId"), '_self');
    },
    CancelRecordhelper : function(component, event, helper) {
        window.open('/' + component.get("v.parentrecordId"), '_self');
    },
    handleComponentEventhandler : function(component, event, helper) {
        var CPTrecord = event.getParam("evtCPT");
        console.log(' departments from view page==== '+CPTrecord.Departments__c);
        console.log(' departments from view page==== '+component.get("v.recordId"));
        //component.set("v.defaultOptions", null);
        component.set("v.fields", CPTrecord);
        component.set("v.recordId",event.getParam("CPTId"));
      
      /*  if(!$A.util.isEmpty(component.get("v.recordId"))){
          component.set("v.defaultOptions", CPTrecord.Departments__c);  
        }  
        else
          component.set("v.defaultOptions", null);  */
    },
    helperFun : function(component,event,secId) {
        var acc = component.find(secId);
        
        for(var cmp in acc) {
            
            $A.util.toggleClass(acc[cmp], 'slds-hide'); 
            $A.util.toggleClass(acc[cmp], 'slds-show');  
        }
    },
    setCPTdepartmenthelper:function(component, event, helper){
        console.log('==hi==setCPTdepartmenthelper==');
        var recId = component.get("v.recordId");
        console.log('===recId==='+recId);
        
        var action = component.get("c.deparments");
        if(!$A.util.isEmpty(recId)){
        action.setParams({dep:component.get("v.fields.Department_Groups__c"),
                          RecordId: recId,
                          PrivateBand: component.find("PrivateBrand1").get("v.value"),
                       CustLevel:component.get("v.fields.Relevant_Customer_Level__c"),
                          Parentid: component.get("v.parentrecordId")
                         });
        }
        else{
            action.setParams({dep:component.get("v.fields.Department_Groups__c"),
                          //RecordId: recId,
                          PrivateBand: component.find("PrivateBrand1").get("v.value"),
                     CustLevel:component.get("v.fields.Relevant_Customer_Level__c"), 
                          Parentid: component.get("v.parentrecordId")
                         });
        }
        var opts2 = [];
        action.setCallback(this, function(response) {
            var state = response.getState();
            console.log('==state1==='+state);
            if (state === "SUCCESS") {
                var result = response.getReturnValue();
                var dep2 = result.availableOptions;
                var selDep = result.SelectedValues;
                //alert(response.getReturnValue());
                //alert('dep2'+dep2);
                //alert('Dep group-->'+JSON.stringify(component.get("v.fields")));
                for (var i = 0; i < dep2.length; i++) {
                    
                    opts2.push({
                        "label": dep2[i],
                        "value": dep2[i]
                    });
                }
                if(component.find("DepGroup").get("v.value") == null)
                    component.find("DepGroup").set("v.value",'');
                if(component.find("DepGroup").get("v.value").includes('Select All'))
                {
                    component.find("DepGroup").set("v.value",'Select All');
                }
                
                component.set("v.listOptions",opts2);
                console.log("listOptions-->"+opts2);
                
                var depval2=[];
                var optsSelected = [];
                for (var i = 0; i < selDep.length; i++){
                    optsSelected.push({
                        "label": selDep[i],
                        "value": selDep[i]
                    });
                }
                for (var i = 0; i < optsSelected.length; i++){
                    depval2.push(
                        optsSelected[i].value
                    )
                }
                component.set("v.defaultOptions",depval2);
                console.log("defaultOptions-->"+depval2);
                
              //  alert('==v.defaultOptions=='+component.get("v.defaultOptions"));
                //for total options
                /*var action_3;
                if(!$A.util.isEmpty(recId)){
                    console.log('startInit==');
                    action_3 = component.get("c.startInit");
                    action_3.setParams({RecordId:  recId});
                }
                else{
                    action_3 = component.get("c.startInit_New");
                }
                var totalopts = [];
                action_3.setCallback(this, function(response) {
                    var state = response.getState();
                    console.log('===state2==='+state);
                    if (state === "SUCCESS") 
                    {
                        var cmpdep;
                        var result_3 = response.getReturnValue();
                        if(!$A.util.isEmpty(recId))
                            cmpdep = result_3.CompDepList;
                        else
                            cmpdep = result_3;
                        console.log('===cmpdep==='+cmpdep);
                        for (var i = 0; i < cmpdep.length; i++) {
                            
                            totalopts.push({
                                "label": cmpdep[i],
                                "value": cmpdep[i]
                            });
                        }
                        component.set("v.listOptions",totalopts);
                        console.log('listOptions-3--'+component.get("v.listOptions"));
                    }
            
                });
                $A.enqueueAction(action_3);
                //ending of total options*/
                
            }
            else if (state === "ERROR") {
                alert('An Error Occurred, please consult your browser console.');
                var errors = response.getError();
                for( var i = 0; i < errors.length; i++){
                    console.log(errors[i].message);
                }
            }
        });
        
        $A.enqueueAction(action);
    },
    helperdate :function(component,event,helper){
        //  alert(component.find("currentdate").get("v.value"));
        //  var todays = $A.localizationService.formatDate(component.find("currentdate").get("v.value"), "YYYY-MM-DD");
        // alert(todays);
        // component.set("v.dates",todays);
        component.set("v.dates",component.find("currentdate").get("v.value"));
             // alert(component.get("v.dates"));
        component.set("v.fields.Effective_Date_of_this_language__c",component.find("currentdate").get("v.value"));
       //alert(component.get("v.fields.Effective_Date_of_this_language__c"));
        // alert(component.get("v.dates"));
    }
})