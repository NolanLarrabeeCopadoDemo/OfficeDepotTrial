({
    init : function (component) {
        console.log("TEst");
        var action = component.get("c.getData");
        action.setParams({ recId : component.get("v.recordId") });

        action.setCallback(this, function(response){
            var state = response.getState();
            if (state === "SUCCESS") {
			var accInstance = response.getReturnValue();
               
                if(accInstance.message !=''){
                    
                    component.set( "v.errorMessage", accInstance.message);
                    component.set( "v.inputError", true);
                     
                }
                else{
                    
                component.set("v.inputError", false);
                   
                component.set("v.AccRecord",accInstance.accRec);
                   
				component.set("v.OppRecord",accInstance.oppRec);
                    
				component.set("v.type",accInstance.type);
                    
				component.set("v.Casetype",accInstance.casetypevar);
                    
				
				var flow = component.find("flowData");
                   
                    if(!$A.util.isEmpty(component.get("v.AccRecord.Id"))){
                        if(component.get("v.AccRecord.Account_Owner_Manager_Name__c") == undefined)
                            var managingDirector = '';
                        else
                            var managingDirector = component.get("v.AccRecord.Account_Owner_Manager_Name__c");
                        if(component.get("v.AccRecord.Sales_PersonID__r.User__r.Name") == undefined)
                            var salesRep = '';
                        else
                            var salesRep = component.get("v.AccRecord.Sales_PersonID__r.User__r.Name");
				var inputVariables = [
                    { name : "acctid", type : "String", value:component.get("v.AccRecord.Id")},
					{ name : "Totalannualsales", type : "Number", value: component.get("v.AccRecord.YTD_Sales_LY__c") },
					{ name : "ActualIMU", type : "Number", value: component.get("v.AccRecord.YTD_Sales_TY_IMU2__c") },
					{ name : "IMUlastyear", type : "Number", value: component.get("v.AccRecord.YTD_Sales_LY_IMU2__c") },
					{ name : "ManagingDirector", type : "String", value: managingDirector },
					{ name : "SalesRep", type : "String", value: salesRep },
					{ name : "accountnamevar", type : "String", value: component.get("v.AccRecord.Name") },
					{ name : "Casetype", type : "String", value: component.get("v.Casetype") },
					{ name : "rectype", type : "String", value: component.get("v.type") },];
                    }
                    
                    if(!$A.util.isEmpty(component.get("v.OppRecord.Id"))){
                    var opId =component.get("v.OppRecord.Id");
                    var acId =component.get("v.OppRecord.AccountId");
                    var nme = component.get("v.OppRecord.Account.Name");
                    var Ctype = component.get("v.Casetype");
                    var tpe = component.get("v.type");
                    var inputVariables = [
                    { name : "oppid", type : "String", value:opId},
                	{ name : "acctid", type : "String", value:acId},
                	{ name : "accountnamevar", type : "String", value:nme},
                	{ name : "Casetype", type : "String", value:Ctype},
                	{ name : "rectype", type : "String", value:tpe},];
                    }
                    
					console.log('Test-->'+JSON.stringify(component.get("v.AccRecord.Account_Owner_Manager_Name__c")));
					flow.startFlow("WRF_latest", inputVariables);
                    
                               
                }
               
            }  
			
           
        });
		$A.enqueueAction(action);
    },
    
    handleStatusChange: function (component,event){
        
            if(event.getParam("status") === "FINISHED") {
            console.log('Runing');
            var urlEvent = $A.get("e.force:navigateToSObject");
                if(!$A.util.isEmpty(component.get("v.AccRecord.Id"))){
                    urlEvent.setParams({
                        "recordId": component.get("v.AccRecord.Id"),
                    });
                }
                if(!$A.util.isEmpty(component.get("v.OppRecord.Id"))){
                    urlEvent.setParams({
                        "recordId": component.get("v.OppRecord.Id"),
                    });
                }
                    
                    urlEvent.fire();
            
        }
    }
})