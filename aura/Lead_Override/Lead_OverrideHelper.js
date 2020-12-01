/**********************************************************************************************
* @jira             NAIT-65798-01750240 PRM - Lead/Account Issue in Lightning.
* @Version 1.1      Aravind Bandla 
* @date             10/16/2018
************************************************************************************************/

({
    // If the URL contains parameters, it have a ?.
    getURLParams : function(component, event, helper) {
        var url = String(window.location.href);
        if(url.includes("?")) {
            var sub_string_count = url.split("?").length;
            return url.split("?")[sub_string_count-1];
        }
        return "undefined";

    },
    //Parse the URL parameters into a map.
    parseParams : function(component, event, helper, params) {
        var paramList = params.split("&");
        var paramMap = new Map();
        for( var i = 0; i<paramList.length; i++) {
            var temp = paramList[i].split("=");
            paramMap.set(temp[0], temp[1]);
        }
        return paramMap;
    },
    createRecord : function(component, event, helper) {
        var createdObject = $A.get("e.force:createRecord");
        var objectName = component.get("v.sObjectName");
        createdObject.setParams({
            "entityApiName": objectName,
            "panelOnDestroyCallback": function(event) {
          
                window.location.hash = '/sObject/'+ objectName +'/list?filterName=Recent';
            }
        });

        createdObject.fire();
    },
    createTypedRecord : function(component, event, helper, recordTypeID) {
            var createdObject = $A.get("e.force:createRecord");
             var objectName = component.get("v.sObjectName");
            createdObject.setParams({
                "entityApiName": objectName,
                "panelOnDestroyCallback": function(event) {
                    //* @jira NAIT-65798-01750240 PRM - Lead/Account Issue in Lightning.//
                    window.location = location.protocol + "//" + location.host + '/lightning/o/' + objectName + '/list?filterName=Recent';
                },
                "defaultFieldValues" :{
                    'RecordTypeId' : recordTypeID
                }
            });
            createdObject.fire();
    }

})