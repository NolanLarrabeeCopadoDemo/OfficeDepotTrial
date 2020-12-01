({
  // Email
  // Fetch the contacts from the Apex controller
  getOptInList: function(component) {
    var action = component.get('c.getContacts');
     action.setParams({
         contId : component.get("v.recordId"),
         Type: "email"
        });
   // Set up the callback
    var self = this;
    action.setCallback(this, function(actionResult) {
     component.set('v.contacts', actionResult.getReturnValue());
    });
    $A.enqueueAction(action);
  },
  
  // PHONE
  // Fetch the contacts from the Apex controller
  getOptInListp: function(component) {
    var action = component.get('c.getContacts');
     action.setParams({
         contId : component.get("v.recordId"),
         Type: "phone"
        });
   // Set up the callback
    var self = this;
    action.setCallback(this, function(actionResult) {
     component.set('v.contactsp', actionResult.getReturnValue());
    });
    $A.enqueueAction(action);
  },
   // DIRECT MAIL 
  // Fetch the contacts from the Apex controller
  getOptInListm: function(component) {
    var action = component.get('c.getContacts');
     action.setParams({
         contId : component.get("v.recordId"),
         Type: "directmail"
        });
   // Set up the callback
    var self = this;
    action.setCallback(this, function(actionResult) {
     component.set('v.contactsm', actionResult.getReturnValue());
    });
    $A.enqueueAction(action);
  },
  
  // NAME  
  // Fetch the contacts from the Apex controller
  getOptInListn: function(component) {
    var action = component.get('c.getContacts');
     action.setParams({
         contId : component.get("v.recordId"),
         Type: "FullName"
        });
   // Set up the callback
    var self = this;
    action.setCallback(this, function(actionResult) {
     component.set('v.contactsn', actionResult.getReturnValue());
    });
    $A.enqueueAction(action);
  },
// Channel Preference 
    getOptInListCPref: function(component) {
    var action = component.get('c.getContacts');
     action.setParams({
         contId : component.get("v.recordId"),
         Type: "channelpreference"
        });
   // Set up the callback
    var self = this;
    action.setCallback(this, function(actionResult) {
     component.set('v.channelpref', actionResult.getReturnValue());
    });
    $A.enqueueAction(action);
  },
    
    
    // Social 
    getOptInListsocial: function(component) {
    var action = component.get('c.getContacts');
     action.setParams({
         contId : component.get("v.recordId"),
         Type: "social"
        });
   // Set up the callback
    var self = this;
    action.setCallback(this, function(actionResult) {
     component.set('v.contactsocial', actionResult.getReturnValue());
    });
    $A.enqueueAction(action);
  },

    
})