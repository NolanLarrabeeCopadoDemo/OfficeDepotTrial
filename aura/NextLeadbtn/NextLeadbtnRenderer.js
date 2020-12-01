({
    rerender : function(component, helper, event){
        this.superRerender();
        // do custom rerendering here
        //alert('in rerender');
        helper.getNextLead(component, event);
    },
})