({
    doInit : function(component, event) {
        var action = component.get("c.findAll");
        //alert("inside"+component.get("v.subrecordIdList"));
               action.setParams({ OrgId : component.get("v.subrecordIdList") });

                //action.setParams({ OrgId : 'a2v1k0000008uumAAA' });  

        action.setCallback(this, function(a) {
            component.set("v.accounts", a.getReturnValue());
            
           // alert("here"+a.getReturnValue());
            var event = $A.get("e.c:AccountsLoaded");
            event.setParams({"accounts": a.getReturnValue()});
            event.fire();
        });
    $A.enqueueAction(action);
    }
})