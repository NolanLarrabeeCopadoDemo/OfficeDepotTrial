({
    keyPressController: function (component, event, helper) {

        var searchKey = component.get("v.searchKey");

        helper.openListbox(component, searchKey);
        helper.displayOptionsLocation(component, searchKey);
    },

    selectOption: function (component, event, helper) {
        var selectedItem = event.currentTarget.dataset.record;
        console.log(event.currentTarget.dataset);
        console.log(selectedItem);
        var selectedValue = event.currentTarget.dataset.value;
        console.log(selectedValue);
        var placeidValue = event.currentTarget.dataset.placeid;
        console.log(placeidValue);

        component.set("v.selectedOption", selectedItem);

        var searchLookup = component.find("searchLookup");
        $A.util.removeClass(searchLookup, 'slds-is-open');

        var iconDirection = component.find("iconDirection");
        $A.util.removeClass(iconDirection, 'slds-input-has-icon_left');
        $A.util.addClass(iconDirection, 'slds-input-has-icon_right');

        component.set("v.searchKey", selectedItem);
        console.log('Helper about to be called');

        helper.placeidquery(component, placeidValue,event);

    },

    clear: function (component, event, helper) {
        helper.clearComponentConfig(component);
    }

})