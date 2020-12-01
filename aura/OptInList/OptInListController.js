({
  doInit: function(component, event, helper) {      
    // Fetch Contact OptInList from the Apex controller   
    helper.getOptInList(component);
    helper.getOptInListp(component);
    helper.getOptInListm(component);
    helper.getOptInListn(component);
    helper.getOptInListCPref(component);
    helper.getOptInListsocial(component);
  }
})