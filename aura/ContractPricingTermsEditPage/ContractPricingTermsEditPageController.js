({
    doInit : function(component, event, helper) {
        
        helper.doInithelper(component, event, helper);
       
        
    },
    handlestatic: function (component, event, helper) {
       
        
    },
       
    saveRecord : function(component, event, helper) {     
        
        component.set("v.SaveNewFlag",true);
       
        var re = "^\\s+$";   
        if(    
            (component.get("v.fields.Name")==null||component.get("v.fields.Name")==''||component.get("v.fields.Name")==undefined)
            ||(component.get("v.fields.Relevant_Customer_Level__c")==null||component.get("v.fields.Relevant_Customer_Level__c")==''||component.get("v.fields.Relevant_Customer_Level__c")==undefined)
            ||(component.get("v.fields.CC_Initial_Freeze_Period_in_days__c")==null||component.get("v.fields.CC_Initial_Freeze_Period_in_days__c")===''||component.get("v.fields.CC_Initial_Freeze_Period_in_days__c")==undefined) 
           ||(component.get("v.fields.How_frequently_can_we_pass_increases__c")==null||component.get("v.fields.How_frequently_can_we_pass_increases__c")==''||component.get("v.fields.How_frequently_can_we_pass_increases__c")==undefined)
            ||(component.get("v.fields.Required_Timing_Of_CC_Updates__c")==null||component.get("v.fields.Required_Timing_Of_CC_Updates__c")==''||component.get("v.fields.Required_Timing_Of_CC_Updates__c")==undefined)
            ||(component.get("v.fields.Vendor_Letter_Required_For_CC_Increase__c")==null||component.get("v.fields.Vendor_Letter_Required_For_CC_Increase__c")==''||component.get("v.fields.Vendor_Letter_Required_For_CC_Increase__c")==undefined)
          ||(component.find("currentdate").get("v.value")==null||component.find("currentdate").get("v.value")==''||component.find("currentdate").get("v.value")==undefined)
            ||(component.get("v.fields.Comm_Req_CC_Price_Chg__c")=="")
            || (component.get("v.fields.Are_obligated_to_pass_on_cost_decreases__c")=="")
            || (component.get("v.fields.How_frequently_must_we_pass_decreases__c")=="")
            ||(component.get("v.fields.CC_Price_Incr_Capped__c")=="") 
            || (component.get("v.fields.Notification_process_for_disco_items__c")=="")
            || (component.get("v.fields.Notification_process_for_disco_items__c")=="Yes"&&component.get("v.fields.Notification_time_disco_items_Other__c")=="")
            || (component.get("v.fields.Action_requirements_for_deleted_or_disco__c")=="")
            || (component.get("v.fields.Price_requirements_for_added_or_alternat__c")=="")
            || (component.get("v.fields.Is_notification_required_to_delete_a_cus__c")=="")
            || (component.get("v.fields.What_type_of_customer_communication_is_r__c")=="")
       
            || (component.get("v.defaultOptions")==null)
        	|| (component.get("v.defaultOptions")==''))
        {   
            component.set("v.requiredError", true);
             console.log('Hi1');
        }
        
     else if(((component.get("v.fields.Comm_Req_CC_Price_Chg__c")=='Notification only'||component.get("v.fields.Comm_Req_CC_Price_Chg__c")=='Notification and customer approval')&&(component.get("v.fields.CC_Prc_Chg_Notice_Reqd_days__c")==undefined||component.get("v.fields.CC_Prc_Chg_Notice_Reqd_days__c")===''||component.get("v.fields.CC_Prc_Chg_Notice_Reqd_days__c")==null))){
                                   
            component.set("v.requiredError", true);   
             console.log('Hi2');
        } else{
            component.set("v.requiredError", false);
             helper.saveRecordhelper(component, event, helper);
             }
        
        
    },
    savenewRecord: function(component, event, helper) {
        helper.savenewRecordhelper(component, event, helper);
    },
    CancelRecord: function(component, event, helper) {
        helper.CancelRecordhelper(component, event, helper);
    },
    handleComponentEvent : function(component, event, helper) {
        console.log('in handleComponentEvent==== ');
        helper.handleComponentEventhandler(component, event, helper);
    },
    handleOnload : function(component, event, helper) {
          component.set("v.loaderror",true);
        console.log('Hi Mohit');
        debugger;
        helper.setCPTdepartmenthelper(component, event, helper);
        console.log('Hi Mohit2');
        
     
    },
    sectionOne : function(component, event, helper) {
        helper.helperFun(component,event,'articleOne');
    },
    
    sectionTwo : function(component, event, helper) {
        helper.helperFun(component,event,'articleTwo');
    },
    
    sectionThree : function(component, event, helper) {
        helper.helperFun(component,event,'articleThree');
    },
    update : function(component,event,helper) {
        component.find("editForm").submit();
    },
    onSuccess : function(component, event, helper) {
        var recid= component.find("Contractlookup").get("v.value");
        window.open('/' + recid, '_self');
        
    },
    showSpinner: function(component, event, helper) {
        // make Spinner attribute true for display loading spinner 
        component.set("v.Spinner", true); 
    },
    
    // this function automatic call by aura:doneWaiting event 
    hideSpinner : function(component,event,helper){
        // make Spinner attribute to false for hide loading spinner    
        component.set("v.Spinner", false);
    },
    
    notification : function(component,event,helper){
     
        component.set("v.notifications", component.find("notificationfield").get("v.value"));
    },
    pricecapped : function(component,event,helper){
           
       component.set("v.fields.Price_cap_language__c",'');
       component.set("v.fields.Price_cap_language__c","");
      component.set("v.fields.CC_Price_Incr_Capped__c",component.find("pricecappedfield").get("v.value"))
        
    },
    CalendarChange : function(component,event,helper){
        var val = component.get("v.fields.Calendar_period__c");
        console.log('===val 239==='+val);
        if(val !='Other')
           component.set("v.fields.Other_calendar_period__c","");
        if(val!='Specific date'){
            component.set("v.fields.Date_1__c","");
            component.set("v.fields.Date_2__c","");
            component.set("v.fields.Date_3__c","");
            component.set("v.fields.Date_4__c","");
        }
    },
   
   
    setCPTdepartment:function(component, event, helper){
        debugger;
        helper.setCPTdepartmenthelper(component, event, helper);
    },
    handleChange: function (cmp, event) {
        // Get the list of the "value" attribute on all the selected options
        var selectedOptionsList = event.getParam("value");
        console.log('selectedOptionsList---'+selectedOptionsList);
        cmp.set("v.defaultOptions",selectedOptionsList);
        
    },
    setPrivateBrand :function(component, event, helper){
        //alert('======PrivateBrand====='+component.find("PrivateBrand1").get("v.value"));
        var ch = component.find("PrivateBrand1").get("v.value");
        console.log('===PrivateBrand1==='+ch);
        component.set("v.fields.Private_Brand__c",ch);
        if(ch==true)
            helper.setCPTdepartmenthelper(component, event, helper);
        
    },
    setComplexCap :function(component, event, helper){
        
        var ch = component.find("complexCap").get("v.value");
        component.set("v.fields.Complex_cap__c",ch);
        
        
    },
    
    
    handledate: function (component, event, helper) {
        // alert('============PrivateBrand1===='+ component.get("v.fields.Effective_Date_of_this_language__c"));
        helper.helperdate(component, event, helper);
    },
    handlelang: function (component, event, helper) {
        component.set("v.fields.Price_cap_language__c",component.find("pricecapf").get("v.value"));
      
    },
    
    
   
    handleRecordUpdated: function(component, event,helper) {
        
        
        if(component.get("v.Newsave")=='exist') {
            var eventParams = event.getParams();
            if(eventParams.changeType === "LOADED") {
                if(component.get("v.load")==true){
                    if(component.get("v.fields.Name")==null){
                        component.find('CPTRecordCreator').reloadRecord(true)
                      
                    }
                }
                // record is loaded (render other component which needs record data value)
                console.log("Record is loaded successfully.");
                console.log("You loaded a record in " + 
                            component.get("v.fields.Name"));
               // alert(component.get("v.fields.Price_cap_language__c"));
            } else if(eventParams.changeType === "CHANGED") {
                // record is changed
            } else if(eventParams.changeType === "REMOVED") {
                // record is deleted
            } else if(eventParams.changeType === "ERROR") {
                // there’s an error while loading, saving, or deleting the record
            }
        }
            
        
    },
     freqinc: function (component, event, helper) {
        // alert('============PrivateBrand1===='+ component.get("v.fields.Effective_Date_of_this_language__c"));
        component.set("v.fields.In_days__c",'');
        component.set("v.fields.Calendar_period__c","");
        component.set("v.fields.Other_calendar_period__c",'');
        component.set("v.fields.Date_1__c",'');
         component.set("v.fields.Date_2__c",'');
         component.set("v.fields.Date_3__c",'');
         component.set("v.fields.Date_4__c",'');
    },
    handleOnError: function (component, event, helper) {
        var errors = event.getParams();
        
    },
    
    freezelength: function(component,event,helper)
    {
      var val = component.find("FreezePeriod").get('v.value');
        if(val.length > 3){
          
           component.set("v.lengtherrormessg",'Initial Price Freeze Period (in days): Number is too large');
              component.set("v.lengtherror",true);
        }   
        
    }
})