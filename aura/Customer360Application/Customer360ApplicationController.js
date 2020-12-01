({
	 doInit : function(component, event) {
         //alert(component.get("v.recordId"));
         console.log(component.get("v.recordId"));
         component.set("v.recordShow",true);
          document.title = "Customer 360 View";
         
     }
})