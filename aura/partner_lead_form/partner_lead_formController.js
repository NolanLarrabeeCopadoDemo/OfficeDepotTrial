({
	init : function(component, event, helper) {
		helper.hinit(component);
    },
    waiting: function(component, event, helper) {
      document.getElementById("Accspinner").style.display = "block";
    },

   doneWaiting: function(component, event, helper) {
     document.getElementById("Accspinner").style.display = "none";
    },
    
    submitLead : function(component, event, helper) {
        var fname = component.find("fnameid");
        var lname = component.find("lnameid");
        var cname = component.find("cnameid");
        var email = component.find("emailid");
        var phone = component.find("phoneid");
        var website = component.find("websiteid");
        var title = component.find("titleid");
        
        if (fname.get("v.validity").valid &&
            lname.get("v.validity").valid &&
            cname.get("v.validity").valid &&
            email.get("v.validity").valid &&
            phone.get("v.validity").valid &&
            website.get("v.validity").valid &&
            title.get("v.validity").valid) {
            	helper.hsubmitLead(component);    
        } else {
            $A.createComponent("ui:message",
                                 {"title": "Please Enter Valid Information",
                                  "severity":"error"
                                 },
                           function(cmp) {
                               component.set("v.messages", [cmp]);
                           });
        }
            
           
    }
})