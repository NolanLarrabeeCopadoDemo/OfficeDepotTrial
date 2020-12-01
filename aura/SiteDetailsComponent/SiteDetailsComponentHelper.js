({
    loadSiteData : function(cmp,event) {
        var params = event.getParam('arguments');  
        var selectedRec;
        if (params) {           
            selectedRec = params.param1;
        }
        else{
           selectedRec=cmp.get("v.subrecordId") ;
            
        }
            
            if(selectedRec !=null){
                cmp.set( "v.currentId", selectedRec);  
                cmp.set( "v.accountId", selectedRec);  
                // alert(selectedRec);
                var isAccount = selectedRec.startsWith('001');
                cmp.set("v.isAccountOrOrg",isAccount);  
                //helper.loadOrgorAccountData(cmp);  
                var action = cmp.get("c.getSiteData");
                action.setParams({OrgId : cmp.get("v.currentId")}) ;
                action.setCallback(this, function(response){
                    var state = response.getState(); 
                    //alert("Inside"+state);
                    
                    
                    if (state === "SUCCESS") {        
                        var returnData = response.getReturnValue();
                        var rows =  returnData.sitesList;
                        for (var i = 0; i < rows.length; i++) {
                            var row = rows[i];
                            if (row.Owner) row.OwnerAlias = row.Owner.Alias;
                        }
                        cmp.set("v.sitesList", returnData.sitesList);
                        cmp.set("v.countSites", returnData.countSites);
                        cmp.set("v.recentSite", returnData.recentSite);
                        
                    }
                });
                $A.enqueueAction(action);
            }
    }
})