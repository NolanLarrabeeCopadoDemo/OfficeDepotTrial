({
    doInit : function(component, event, helper) {

    },

    navigate: function(component, event, helper) {
        // this function call on click on the previous page button  
        var page = component.get("v.page") || 1;
        var name = component.get("v.label");
        // get the previous button label  
        var direction = event.getSource().get("v.label");               
        // set the current page,(using ternary operator.)  
        page = direction === "Previous Page" ? (page - 1) : (page + 1);
               
        var compEvent = component.getEvent("PaginationEvent");
        // Optional: set some data for the event (also known as event shape)
        // A parameter’s name must match the name attribute
        // of one of the event’s <aura:attribute> tags
        compEvent.setParams({"page" : page });
        compEvent.setParams({"name" : name });
        compEvent.fire();
   
     },
})