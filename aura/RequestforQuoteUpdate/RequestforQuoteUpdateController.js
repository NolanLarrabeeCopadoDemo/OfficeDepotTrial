({
    doInit : function(component, event, helper) {
       //component.set("v.Message");
      // component.set("v.Message",'');
        var opts = [];
          var action = component.get("c.Onload");
          var quoteId = component.get("v.recordId");
        	//alert(quoteId);
          action.setParams({ RecId : quoteId });        
          action.setCallback(this, function(response) {
          var state = response.getState();
              var res=response.getReturnValue();
               var re = "^\\s+$";
              //alert(state);
         if (state === "SUCCESS") 
         {
         // component.set("v.Message",res);
             if (res.Message.indexOf("Can Request") > -1 ){
        component.set("v.Message1",'');
                 //alert(res);
              var allValues = res.Picklst;
 
                if (allValues != undefined && allValues.length > 0) {
                    opts.push({
                        class: "optionClass",
                        label: "--- None ---",
                        value: ""
                    });
                }
                for (var i = 0; i < allValues.length; i++) {
                    opts.push({
                        class: "optionClass",
                        label: allValues[i],
                        value: allValues[i]
                    });
                }
                component.find("quopicklistid").set("v.options", opts);
            
             }
             else
             {
                 component.set("v.Message",res.Message); 
             
             }
         } 
         else 
         {

         }
             
  });
        $A.enqueueAction(action);
    },
        
     handleSubmit : function(component, event, helper)  {
           var notes = component.find('CommentsId').get("v.value");
       
         if(notes===null||notes===''||notes===undefined){
             //  alert(notes);
            component.set("v.validationError",true);
          component.set("v.errorMessages",'Notes Field is Required');
            }
         else{
          var quopicklist = component.find('quopicklistid').get("v.value");
        var action = component.get("c.RequestforQuoteUpdate");         
        var quoteId = component.get("v.recordId");
         action.setParams({ "notes" : notes , 
                           "quoteId" : quoteId,
                           "quopicklist" : quopicklist
                          });
         action.setCallback(this, function(response) {
          var state = response.getState();
         if (state === "SUCCESS") 
         {
                 var result = response.getReturnValue();
             //alert(result.StatusCode);
                if(result.StatusCode === -1){
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
             if(result.StatusCode === 1){
                   if(decodeURIComponent(window.location.search.substring(1)).indexOf("sfdcIFrameHost=web") > -1) {
           // alert('hi1');
            window.open('https://officedepot.lightning.force.com/lightning/r/CameleonCPQ__QxQuote__c/'+component.get("v.recordId")+'/view',"_self");
    }
       else if (decodeURIComponent(window.location.search.substring(1)).indexOf("scontrolCaching=1") > -1) {
          // alert('hi2');
            window.open('/'+component.get("v.recordId"),"_self");
        }
        else
        {
           // alert('hi');
            sforce.one.navigateToURL('one/one.app#/sObject/'+component.get("v.recordId")+'/view');
             //window.open(salesforce1://sObject/a8B1k0000008dLS/view);
            // Fire the event to navigate to the contact record
       
        }
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
         });
        
          $A.enqueueAction(action);
         }
        },
    navigatetohomepage : function(component, event, helper) {
     if(decodeURIComponent(window.location.search.substring(1)).indexOf("sfdcIFrameHost=web") > -1) {
           // alert('hi1');
            window.open('https://officedepot.lightning.force.com/lightning/r/CameleonCPQ__QxQuote__c/'+component.get("v.recordId")+'/view',"_self");
    }
       else if (decodeURIComponent(window.location.search.substring(1)).indexOf("scontrolCaching=1") > -1) {
          // alert('hi2');
            window.open('/'+component.get("v.recordId"),"_self");
        }
        else
        {
           // alert('hi');
            sforce.one.navigateToURL('one/one.app#/sObject/'+component.get("v.recordId")+'/view');
             //window.open(salesforce1://sObject/a8B1k0000008dLS/view);
            // Fire the event to navigate to the contact record
       
        }
      
	}
    
})