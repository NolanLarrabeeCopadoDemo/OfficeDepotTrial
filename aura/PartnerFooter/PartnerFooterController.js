({
	init : function(component, event, helper) {
    var today = new Date();
    var monthDigit = today.getMonth() + 1;
    if (monthDigit <= 9) {
        monthDigit = '0' + monthDigit;
    }
    component.set('v.today', today.getFullYear());
}
})