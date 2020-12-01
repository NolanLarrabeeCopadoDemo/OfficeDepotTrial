({
    validate  : function(component, event, helper) {
        var inp1 = component.find('AopsAccId').get("v.value");
        var inp2 = component.find('addSeq').get("v.value");       
        if(inp1 > 99999999)
        {
            component.set("v.AOPSAccID","");
            var toastEvent = $A.get("e.force:showToast");
            toastEvent.setParams({
                title : 'Warning',
                message: 'AOPSAccountId Shall have maximum length of 8 digits only',
                duration:' 1000',
                key: 'info_alt',
                type: 'warning',
                mode: 'sticky'
            });
            toastEvent.fire();
        }
    },
    /*------Logic for consuming the input the AddSequence and AOPSAccountId--------*/
    ResyncAccountsetup : function(component, event, helper) {
        var addseq=component.find("addSeq").get("v.value");
        var AopsAccountid=component.find("AopsAccId").get("v.value");
        var action=component.get("c.ResyncAccount");
        var outName = component.find("nameOutput");
        action.setParams({addressSeq:addseq,AOPSAccountId:AopsAccountid});
        action.setCallback(this,function(response){
            var state=response.getState();
            if(state=="SUCCESS")
            {
                component.set("v.AOPSAccID","");
                component.set("v.AddSeq",0);
                var res =JSON.parse(response.getReturnValue());
                if(res.status == ''){
                    var toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams({
                        title : 'Success',
                        message: 'SUCCESS - Request sent successfully.',
                        duration:' 5000',
                        key: 'info_alt',
                        type: 'success',
                        mode: 'pester'
                    });
                    toastEvent.fire();
                }
                else{
                    component.set("v.AOPSAccID","");
                    component.set("v.AddSeq",0);
                    var toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams({
                        title : 'Error',
                        message:'Fail - Request failed. Account Not Found in AOPS',
                        duration:' 5000',
                        key: 'info_alt',
                        type: 'error',
                        mode: 'pester'
                    });
                    toastEvent.fire();
                }
            }	
            else{
                component.set("v.AOPSAccID","");
                component.set("v.AddSeq",0);
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    title : 'Error',
                    message:'Fail - Request failed. Account Not Found in AOPS',
                    duration:' 5000',
                    key: 'info_alt',
                    type: 'error',
                    mode: 'pester'
                });
                toastEvent.fire();
            }
        });
        $A.enqueueAction(action);
    }
    
})