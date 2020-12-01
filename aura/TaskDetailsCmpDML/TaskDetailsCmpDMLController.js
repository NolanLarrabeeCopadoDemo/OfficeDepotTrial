({  

    doAction : function(cmp, event,helper) { 
        
        cmp.set('v.taskColumns', [
            {label: 'Subject', fieldName: 'Subject', type: 'text'},
            {label: 'Status', fieldName: 'Status', type: 'text'},
             {label: 'Disposition', fieldName: 'Call_Disposition__c', type: 'text'},
            {label: 'Disposition Code', fieldName: 'Disposition_Code__c', type: 'text'},
            {label: 'Due Date', fieldName: 'ActivityDate', type: 'text'},
            {label: 'Name', fieldName: 'WhoName', type: 'text'},
            {label: 'AssignedTo', fieldName: 'OwnerName', type: 'text'},            
        ]);

            helper.loadTaskData(cmp,event);

        
    },
    showTasks : function (cmp, event, helper) {
        cmp.set("v.showModel",true);
        cmp.set("v.showTaskInfo",true);      
    },
    closeModel : function (cmp, event, helper) {
        cmp.set("v.showModel",false);
        document.body.style.overflow = "auto";
    }
    
    
})