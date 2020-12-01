({  

    doAction : function(cmp, event,helper) { 
        //https://officedepot--oduat.cs78.my.salesforce.com/a7U1k0000009Hbe
        cmp.set('v.DMLColumns', [
            {label: 'DML Name', fieldName: 'Decision_Maker_Name__c', type: 'text'},
            //{label: 'New DML ID', fieldName: 'New_DML_ID__c', type: 'text'},
            {label: 'DML ID',fieldName: 'DMLLink__c',type: 'url', typeAttributes: { label: { fieldName: 'DML_ID__c' }}},
            {label: 'Customer ID', fieldName: 'CUSTOMERID__c', type: 'text'},
            {label: 'Customer Name', fieldName: 'Customer_Name__c', type: 'text'},
            {label: 'DML Segment Description', fieldName: 'DML_Segment__c', type: 'text'},
            {label: 'DML RepID', fieldName: 'DML_RepID__c', type: 'text'},
            {label: 'DML Rep Name', fieldName: 'DML_Rep_Name__c', type: 'text'}
           //{label: 'DMLUrl', fieldName: 'DMLLink__c', type: 'url'},
           /*  {type: "button", typeAttributes: {
                label: 'View DML',
                name: 'View',
                title: 'View',
                disabled: false,
                value: 'view',
                iconPosition: 'left'
            }}*/
            
           
        ]);
            helper.loadDMLData(cmp,event);
        
    },
    showDML : function (cmp, event, helper) {
        cmp.set("v.showModel",true);
        cmp.set("v.showDMLInfo",true);      
    },
    closeModel : function (cmp, event, helper) {
        cmp.set("v.showModel",false);
        document.body.style.overflow = "auto";
    },
     /*viewRecord : function(component, event, helper) {
           var actionName = event.getParam('action').name;
          var recId = event.getParam('row').Id;
         //alert(recId);
        var row = event.getParam('row');
         var link = row.DML__c;
         alert(link);
 if ( actionName == 'View') {
            alert('view');
           var urlEvent = $A.get("e.force:navigateToURL");
    urlEvent.setParams({
                "url": 'https://officedepot--oduat.cs78.my.salesforce.com/' + link
            });
            urlEvent.fire();
        }
    }*/

    
    
})