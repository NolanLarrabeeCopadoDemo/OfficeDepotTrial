({
    doInit : function(component, event, helper) {
        helper.getContractList(component);
    },
    
   //Code for EDIT and DELETE MENU Actions
    handleMenuSelect: function(component, event, helper) {
        var selectedMenu = event.detail.menuItem.get("v.value");
        var indexVar = event.getSource().get("v.class");
        var tempid = component.get("v.ContractList")[indexVar].WrapContract;
        switch(selectedMenu) {
            case "EDIT":
                if(tempid.RecordType.Name == 'Standard')
                {
                    component.set("v.isOpenFlow",true);
                    var flow = component.find("flowData");
                    var inputVariables = [
                        {
                            name : 'recordId',
                            type : 'String',
                            value : tempid.Id
                        }
                    ]
                    // In that component, start your flow. Reference the flow's API Name.
                    flow.startFlow("Contract_Edit_Tab_wise",inputVariables);
                }
                else
                {
                    
                    var urlEvent = $A.get("e.force:navigateToURL");
                    urlEvent.setParams({
                        "url": 'https://officedepot.lightning.force.com/lightning/r/Contract/'+tempid.Id+'/view'
                    });
                    urlEvent.fire();
                }
                break;
            case "delete":
                alert("Do you want to delete this Contract...");
                var action = component.get('c.deleteContractRecord');
                console.log('Test-->'+tempid.Id);
                action.setParams({ contractToDelete : tempid.Id });
                
                action.setCallback(this, function(response) {
                    var state = response.getState();
                    
                    if(state == 'SUCCESS'){
                        window.location.reload();
                    }
                }); 
                $A.enqueueAction(action);
                break;
        }
    },
    
    //Code for Opening New Contract Creation Component
    OpenNewContractComponent : function(component,event,helper)
    {
        console.log('Test-->');
        
        $A.createComponent(
            "c:NewContractButton",
            {
                "recordId": component.get("v.recordId"),
                
                
            },
            function(newButton, status, errorMessage){
                //Add the new button to the body array
                if (status === "SUCCESS") {
                    var body = component.get("v.body");
                    body.push(newButton);
                    component.set("v.isOpen",true);
                    component.set("v.body", body);
                }
                else if (status === "INCOMPLETE") {
                    console.log("No response from server or client is offline.")
                    // Show offline error
                }
                    else if (status === "ERROR") {
                        console.log("Error: " + errorMessage);
                        // Show error message
                    }
            }
        );
        
    },
    
    //Code to redirect to Archive Contract Reports
    OpenArchiveContractsReport : function(component,event,helper)
    {
        var AllData = component.get("v.ContractList");
        var AlltheAccounts = '';
        if(AllData != null)
        for(var i = 0;i<=AllData.length;i++)
        {
            console.log('account-->'+AllData[i]);
            if(AllData[i] == undefined)
                console.log('Failure');
            else
            {
                if(AlltheAccounts.includes(toString(AllData[i].WrapAccount.Id)))
                {
                    
                }
                else
                {
                    AlltheAccounts = AlltheAccounts + AllData[i].WrapAccount.Id + ',';
                }
            }
            
            
        }
        window.open(
            $A.get("$Label.c.Archive_Contracts")+AlltheAccounts,
            '_blank' // <- This is what makes it open in a new window.
        );
    },
    
  
   //Code for closing the New Contract Creation Component and reloading the Page. 
    closeModel : function(component,event,helper)
    {
        component.set("v.isOpen",false);
        component.set("v.isOpenFlow",false);
        window.location.reload();
    }
})