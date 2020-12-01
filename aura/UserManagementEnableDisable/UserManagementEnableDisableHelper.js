({
    doinithelper : function (component,event) 
    {
        var userid=component.get("v.userid");
        var recordId = component.get("v.recordId");
        var action=component.get("c.initHelperMeth"); 
        action.setParams({
            'recordId': recordId
        });
        action.setCallback(this,function(response) {
            if(response.getState() == "SUCCESS") {
            var res = response.getReturnValue();
                console.log('==>Return values from response are:'+res[0]+' '+res[1]);
            if(res[0]== 'TRUE')
            {
                console.log('==>response is'+res[0]+'then disable should fire as user is Active');
                component.set("v.contactSubmitted" , true);
            } else
            {
                console.log('==>response is'+res[0]+'then enable should fire as user is inactive');
                component.set("v.ocontactSubmitted" , true);   
            }
            if(res[1] != undefined)
            {
                userid=res[1];        
            }
                console.log('==>The user Id is being set to Varibale'+userid);
            component.set("v.userid",userid);
            }
            else {
                
                component.set("v.useractivation" , true);
            }
        });
        $A.enqueueAction(action); 
    },
    
    disablepartnerhelper : function(component,event) {
        var recordId = component.get("v.recordId");
        component.set("v.Spinner" , true);
        var ouserid=component.get("v.userid");
        console.log('==>The user Id retireved from variable to deactivate user'+ouserid);
        var action=component.get("c.deactivateUser"); 
        action.setParams({
            'ouserid': ouserid
        });
        action.setCallback(this,function(response) {
            component.set("v.Spinner" , false);  
            if(response.getState() == "SUCCESS") {
                var res = response.getReturnValue(); 
                var msg = 'Thank you, your user has been disabled ';
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "title": "Success!",
                    "message": msg,
                    "type" : 'success'
                });
                toastEvent.fire();  
                var navEvt = $A.get("e.force:navigateToSObject");
                navEvt.setParams({
                    "recordId": recordId,
                    "slideDevName": "related"
                });
                navEvt.fire();
            }
        });
        $A.enqueueAction(action);  
    },
    
    enablepartnerhelper : function (component,event)
    {
        var recordId = component.get("v.recordId");
        component.set("v.Spinner" , true);
        var oouserid=component.get("v.userid"); 
        console.log('==>The user Id retireved from variable to activate user'+oouserid);
        var action=component.get("c.enableUser"); 
        action.setParams({
            'oouserid': oouserid
        });
        
        action.setCallback(this,function(response) {
            component.set("v.Spinner" , false);  
            if(response.getState() == "SUCCESS") {
                var res = response.getReturnValue(); 
                var msg = 'Thank you, your user has been enabled ';
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "title": "Success!",
                    "message": msg,
                    "type" : 'success'
                });
                toastEvent.fire();
                var navEvt = $A.get("e.force:navigateToSObject");
                navEvt.setParams({
                    "recordId": recordId,
                    "slideDevName": "related"
                });
                navEvt.fire();
            }
        });
        $A.enqueueAction(action); 
    }
})