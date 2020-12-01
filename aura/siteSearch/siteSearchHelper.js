({
	getdata : function(cmp) {
        
		var action = cmp.get('c.searchSites');
        
        action.setParams({
         acctID : cmp.get("v.aopsID")
        });
        
        action.setCallback(this,$A.getCallback(function (response) {
            var state = response.getState();
            if (state == "SUCCESS") {
                cmp.set('v.sdata',response.getReturnValue());
            } else if (status == "ERROR") {
                var errors = response.getError();
                console.error(errors);
            }
        }
  
        ));
        
        $A.enqueueAction(action);
	},
    
    
    getRowActions: function (cmp, row, doneCallback) {
        var actions = [];
        if (row['GPO_Site_Status__c'] == 'Active') {
          actions.push({
        	'label': 'Deactivate',
			'name': 'deactivate'
		  });
        } else {
			actions.push({
				'label': 'Activate',
				'name': 'activate'
			});
		}

        setTimeout($A.getCallback(function () {
        doneCallback(actions);
        }), 200)
    },
    
    activateRow: function(cmp,row) {
        var action = cmp.get("c.ActivateSite");
        action.setParams({
           "acct":row
        });
        
        action.setCallback(this, function(response) {
           
		var state = response.getState();
		if (state === "SUCCESS") {
                 
			var rows = cmp.get('v.sdata');
			var rowIndex = rows.indexOf(row);
			rows[rowIndex]['GPO_Site_Status__c'] = 'Active';
			cmp.set('v.sdata', rows);
		}
		else if (state === "ERROR") {
			 alert('error');
		}
	});
	 $A.enqueueAction(action);
    },

    
    updateRows : function(cmp,controllerAction) {               
        var action = cmp.get("c.UpdateMSites");
        var sites = cmp.get("v.selectedSites");
        action.setParams({
           "accts":sites,
            "action":controllerAction 
        });        
        
        

        action.setCallback(this, function(response) {           
		var state = response.getState();
		if (state === "SUCCESS") {
            var tbrows = cmp.get('v.sdata');
            var rows = cmp.get('v.selectedSites');
            

            var selectedrow = [];
            for (var i=0;i<rows.length; i++) {
                var rowindex = tbrows.indexOf(rows[i]);
                tbrows[rowindex]['GPO_Site_Status__c'] = controllerAction;
                //tbrows[rowindex]['GPO_Site_Status__c'] = controllerAction; 
                
               // var indexOfStevie = tbrows.findIndex(j =〉 j.id == rows[i].id);
                //console.log('〉〉〉Indexxx.. '+ JSON.stringify(tbrows[rowindex]));
                //tbrows[rowindex] = tbrows.splice(0,1);
                
                //var indexOfStevie = arr.findIndex(j =〉 j.id == selectedRows[i].id);
            	//console.log('〉〉〉Indexxx.. '+JSON.stringify(arr.splice(indexOfStevie,1)));
                
            }
            cmp.set('v.sdata',tbrows);
            
            
		}
		else if (state === "ERROR") {
			 var errors = response.getError();
                console.error(errors);
		}
	});
	 $A.enqueueAction(action);
    },
    
    
    DeactivateRow: function(cmp,row) {
        var action = cmp.get("c.DeactivateSite");
        action.setParams({
           "acct":row
        });
        
        action.setCallback(this, function(response) {
           
		var state = response.getState();
		if (state === "SUCCESS") {
                 
			var rows = cmp.get('v.sdata');
			var rowIndex = rows.indexOf(row);
			rows[rowIndex]['GPO_Site_Status__c'] = 'Inactive';
			cmp.set('v.sdata', rows);
		}
		else if (state === "ERROR") {
            var errors = response.getError();
                console.error(errors);
		}
	});
	 $A.enqueueAction(action);
    },
    
    getsearchdata : function(cmp) {
        var action = cmp.get("c.searchsdata");
        action.setParams({
         name : cmp.get("v.acName"),
         seq : cmp.get("v.sseq"),
         status : cmp.get("v.sstatus"),
         addKey : cmp.get("v.adrKey"),
         acctID : cmp.get("v.aopsID")
        });

        action.setCallback(this,$A.getCallback(function (response) {
            var state = response.getState();
            if (state == "SUCCESS") {
                cmp.set('v.sdata',response.getReturnValue());
            } else if (status == "ERROR") {
                var errors = response.getError();
                console.error(errors);
            }
        } 
         ));        
        $A.enqueueAction(action);
    }
    
})