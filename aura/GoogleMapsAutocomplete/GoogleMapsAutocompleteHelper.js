({
    displayOptionsLocation: function (component, searchKey) {
        var action = component.get("c.getAddressAutoComplete");
        action.setParams({
            "input": searchKey,
            "types": 'geocode'
        });

        action.setCallback(this, function (response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var options = JSON.parse(response.getReturnValue());
                console.log(options);
                var predictions = options.predictions;
                console.log(predictions);
                var addresses = [];
                if (predictions.length > 0) {
                    for (var i = 0; i < predictions.length; i++) {
                        console.log(predictions[i]);
                        console.log(predictions[i].place_id);
                        addresses.push(
                            {
                                value: predictions[i].types[0],
                                label: predictions[i].description,
                                placeid: predictions[i].place_id
                            });
                    }
                    console.log('addresses...'+addresses);
                    component.set("v.filteredOptions", addresses);
                }
            }
        });
        $A.enqueueAction(action);
    },

    placeidquery: function (component, searchKey) {
           console.log('Inside place query');
           var action = component.get("c.getAddressPlaceInfo");
            action.setParams({
                "input": searchKey
            });
            var placeidresponse = '';
            var respresults = '';

            action.setCallback(this, function (response) {
                    var state = response.getState();
                    if (state === "SUCCESS") {
                        placeidresponse = JSON.parse(response.getReturnValue());
                        respresults = placeidresponse.result;
                        console.log(respresults);
                        component.set("v.placeResponse", JSON.stringify(respresults));
                        var addressEvent = component.getEvent("addressComponentEvent");
                        addressEvent.setParams({"addressString": component.get("v.placeResponse")});
                        addressEvent.fire();
                    }
                    });

           $A.enqueueAction(action);
        },

    openListbox: function (component, searchKey) {
        var searchLookup = component.find("searchLookup");

        if (typeof searchKey === 'undefined' || searchKey.length < 3)
        {
            $A.util.addClass(searchLookup, 'slds-combobox-lookup');
            $A.util.removeClass(searchLookup, 'slds-is-open');
            return;
        }

        $A.util.addClass(searchLookup, 'slds-is-open');
        $A.util.removeClass(searchLookup, 'slds-combobox-lookup');
    },

    clearComponentConfig: function (component) {
        var searchLookup = component.find("searchLookup");
        $A.util.addClass(searchLookup, 'slds-combobox-lookup');

        component.set("v.selectedOption", null);
        component.set("v.searchKey", null);

        var iconDirection = component.find("iconDirection");
        $A.util.removeClass(iconDirection, 'slds-input-has-icon_right');
        $A.util.addClass(iconDirection, 'slds-input-has-icon_left');
    },

})