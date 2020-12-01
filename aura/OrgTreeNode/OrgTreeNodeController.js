({
    
   // Calls the toggle function in Helper.js
    doInit : function(component, event, helper) {
        helper.toggle(component,event);
        component.set("v.lastSelectedRecId",component.get("v.subrecordId"));
    }, 
    
    
    // Calls the toggle function in Helper.js
    getAccount : function(component, event, helper) {
         
                var id= event.target.id;
       var selectedIDval = component.get("v.lastSelectedRecId");
        
              //alert("inside 1"+id);
        if(id=='')
        helper.toggle(component,event);
         if(id != selectedIDval){
             $A.util.addClass(document.getElementById(id), 'current');
             component.set("v.lastSelectedRecId",id);
             $A.util.removeClass(document.getElementById(selectedIDval), 'current');
         }
       
      
    },
    // displays the selected account 
    showDiv: function(component, event) {
           //alert("inside 2");

    	var name = event.currentTarget.dataset.value;
        var id= event.target.id;
        
        console.log('--value--'+name+id);
        var evt = component.getEvent("Result");
         

        evt.setParams({
            name : name,
            id : id
        }).fire();
        
    }
})