// Toggles the view
({
    toggle : function(component,event) {
        var collapseText = component.get("v.collapseText");
        var accName = component.find("collapsedContainer"); 
        if(collapseText){
            $A.util.toggleClass(accName, 'collapsed');
            component.set("v.collapseText", false);
        }
        else{
            $A.util.toggleClass(accName, 'collapsed');
            component.set("v.collapseText", true);
        }
    },
})