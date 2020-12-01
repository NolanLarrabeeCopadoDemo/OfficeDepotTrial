({
	doInit: function(component, event, helper) {
        var getList = component.get('v.items'); 
        var getElement = component.get('v.element');
        //var getSales = component.get('v.RollingSales');
       //alert("hi"+getList);
       //alert("hi"+getElement);
        var getElementIndex;
        if(getElement!='' &&  getElement!=null)
        getElementIndex = getList.indexOf(getElement);
       
       // if getElementIndex is not equal to -1 it's means list contains this element. 
       
        getList=getList.replace(getElement,'');
        component.set("v.items",getList);

        if(getElement=="-Site" ){             
          component.set("v.conditionSite",true);
        }
        if(getElement=="-Org" ){
        component.set("v.conditionOrg",true);                 
        }
        if(getElement=="-Global" ){
            //alert("Inside");
        component.set("v.conditionOrgMaster",true);                 
        }   
        
        if(getElement=="-Prospect" ){
        component.set("v.conditionProspect",true);                 
        }
        if(getElement=="-Customer" ){
        component.set("v.conditionCustomer",true);                 
        } 
        /*if(getSales>0 ){
        component.set("v.conditionSales",true);                 
        }*/
    }
})