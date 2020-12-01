({
	
    ToggleCollapse : function(component, event, helper) { 
		helper.ToggleCollapseHandler(component, event);
	},
    toggleCollapseBackToGreen : function(component, event, helper) { 
        
	  $A.util.addClass(document.getElementById('decisionInfoId'),'sucessAlert');
	  $A.util.addClass(document.getElementById('ctInfoId'),'sucessAlert');
	  $A.util.addClass(document.getElementById('prospectInfoId'),'sucessAlert');
	}
    
})