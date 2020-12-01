({

    onSelectChange : function(component, event, helper) {
        var sEnt = event.getSource();
        var ent = sEnt.get("v.value");

        var selectCat = component.find("Cat_Pck");

        component.set("v.catOptions",
            selectCat.optionsByControllingValue[ent]);

        //helper.getDirectory(component);
        
        var action = component.get("c.getDir");
    	    action.setParams({
        	    "ent" : ent
        	});
	    action.setCallback(component, function(a) {
        component.set("v.directory", a.getReturnValue());
    	});
    		$A.enqueueAction(action);        

	},

    onSelectCategory : function(component, event, helper) {
        var sCat = event.getSource();
        var cat = sCat.get("v.value");
        
        component.set("v.cat", cat);
        
		var ent = component.find("Ent_Pck").get("v.value");
        
        if(cat != 'All'){
            var action = component.get("c.getDirEC");
    	    action.setParams({
        	    "ent" : ent,
                "cat" : cat
                });

	    action.setCallback(component, function(a) {
        component.set("v.directory", a.getReturnValue());
        });  
        } else {
        	var action = component.get("c.getDir");
    	    action.setParams({
        	    "ent" : ent
        	});
	    action.setCallback(component, function(a) {
            component.set("v.directory", a.getReturnValue());
    	});
            }
    		$A.enqueueAction(action); 
	},

    doInit : function(component, event, helper) {
        var self = this;
		
        var getCategories = component.get("c.getCat");
        getCategories.setCallback(self, function(a) {

        var category = a.getReturnValue();  // Array<Object>

            var entOptions = [];

            var categoryOptionsByEntId = new Object();

            category.forEach(function(element, index, array) {
                var entity = element.Entity__c;

                if (categoryOptionsByEntId[entity] === undefined) {


                    var entityOption = new Object();
                    entityOption.value = element.Entity__c;
                    entityOption.label = element.Entity_Name__c;
                    entOptions.push(entityOption);

                    categoryOptionsByEntId[entity] = [];
                }

                var categoryOption = new Object();
                categoryOption.value = element.Category__c;
                categoryOption.label = element.Category__c;
                categoryOptionsByEntId[entity].push(categoryOption);
            });

            component.set("v.entOptions", entOptions);

            var selectCategory = component.find("Cat_Pck");
            selectCategory.optionsByControllingValue = categoryOptionsByEntId;


        });

        $A.enqueueAction(getCategories);  

        var selectEnt = component.find("Ent_Pck");
        var selectCat = component.find("Cat_Pck");

        component.set("v.ent", selectEnt.get("v.value"));
		component.set("v.cat", selectCat.get("v.value"));

    	}

})