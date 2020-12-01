({
	toggle : function(component, event, helper) {
		var spinner = component.find("mySpinner");
        $A.util.toggleClass(spinner, "slds-hide");
	},
    

    init: function (cmp, event, helper) {
        
    helper.getdata(cmp);   
    var actions = helper.getRowActions.bind(this, cmp);
    cmp.set('v.scol', [
        { label:'Action', type: 'action', typeAttributes: { rowActions: actions } },
        {label: 'Site Name', fieldName: 'Name', type: 'text'},
        {label: 'Site Sequence', fieldName: 'AOPS_Seq_ID__c', type: 'text',sortable:'true'},
        {label: 'Address Key', fieldName: 'Address_Key__c', type: 'text'},
        {label: 'Status', fieldName: 'GPO_Site_Status__c', type: 'text'},
        {label: 'Address1', fieldName: 'Address1__c', type: 'text'},
        {label: 'City', fieldName: 'City__c', type: 'text'},
        {label: 'State', fieldName: 'State__c', type: 'text'},
        {label: 'Zip', fieldName: 'Zip__c', type: 'text'}
        
    ]);
    
    },
    
    getSearchResult: function (cmp,event,helper) {
        helper.getsearchdata(cmp);
    },
    
    getSelectedName: function (cmp, event) {
    var selectedRows = event.getParam('selectedRows');
    cmp.set('v.selectedSites',selectedRows);
    
    //for (var i = 0; i < selectedRows.length; i++){
    //alert("You selected: " + selectedRows[i].Name);
    //}
    },
    
    activateSelected: function(cmp, event,helper){
        //alert(event.getParam('selectedRows'));
       
        helper.updateRows(cmp,'Active');

    },
    
    DeactivateSelected: function(cmp, event,helper){
        //alert(event.getParam('selectedRows'));
        helper.updateRows(cmp,'Inactive');
    },
    
    handleRowAction: function (cmp, event, helper) {
         
         var action = event.getParam('action');
         var row = event.getParam('row');
         switch (action.name) {
                 
          case 'activate':
            //alert('Showing Details: ' + JSON.stringify(row));
            helper.activateRow(cmp,row);
            break;
          case 'deactivate':
            helper.DeactivateRow(cmp,row);
            break;
         }
     },
    
	loadMoreData: function (cmp, event, helper) {
		
		event.getSource().set("v.isLoading", true);
        cmp.set('v.loadMoreStatus', 'Loading');
        helper.fetchData(cmp, cmp.get('v.rowsToLoad'))
          .then($A.getCallback(function (data) {
             if (cmp.get('v.sdata').length >= cmp.get('v.totalNumberOfRows')) {
              cmp.set('v.enableInfiniteLoading', false);
              cmp.set('v.loadMoreStatus', 'No more data to load');
             } else {
             var currentData = cmp.get('v.data');
             var newData = currentData.concat(data);
             cmp.set('v.sdata', newData);
             cmp.set('v.loadMoreStatus', '');
           }
        event.getSource().set("v.isLoading", false);
     }));
  	},
    
    waiting: function(component, event, helper) {
      document.getElementById("Accspinner").style.display = "block";
    },

   doneWaiting: function(component, event, helper) {
     document.getElementById("Accspinner").style.display = "none";
    },


    
})