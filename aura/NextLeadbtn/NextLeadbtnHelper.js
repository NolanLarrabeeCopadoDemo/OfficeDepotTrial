({
    getNextLead : function(component, event) {
        component.set("v.showSpinner",true);
        //var listViewName=event.getSource().getFilterName;
        
        var uid = component.get("v.pageReference.state.uid");
        if(component.get("v.uid") != uid){
            //alert('In Method');
            component.set("v.uid",uid);
            console.log('LeadRecord:'+component.get("v.currentUser").Profile.Name);
            component.set("v.ProfileLoggedIn",component.get("v.currentUser").Profile.Name);
            var currentUserProfile = component.get("v.ProfileLoggedIn");
            if((currentUserProfile=='Inside Sales')||(currentUserProfile=='System Administrator'))
            {
                var Action = component.get("c.getNextLeadLightning");
                Action.setCallback(this, function (response) {
                    var state = response.getState();
                    var navLink = component.find("navigationService");
                    if (state === 'SUCCESS'){
                        var strResult=response.getReturnValue();
                        
                        component.set("v.showSpinner",false);
                        if(strResult.length === 18){
                            
                            var pageRef = {
                                type: 'standard__recordPage',
                                attributes: {
                                    actionName: 'view',
                                    objectApiName: 'Lead',
                                    recordId : strResult // change record id. 
                                },
                            };
                            navLink.navigate(pageRef, true);
                            
                        }else{
                            //alert(strResult);
                            
                            var toastEvent = $A.get("e.force:showToast");
                            toastEvent.setParams({
                                title : 'Info',
                                message: strResult,
                                duration:' 5000',
                                key: 'info_alt',
                                type: 'info',
                                mode: 'dismissible'
                            });
                            toastEvent.fire();
                            
                            var pageReference = {
                                type: 'standard__objectPage',
                                attributes: {
                                    objectApiName: 'Lead',
                                    actionName: 'list'
                                },
                                state: {
                                    filterName: 'Recent'
                                }
                            };
                            navLink.navigate(pageReference, true);
                            
                        }
                        
                    }
                });       
                $A.enqueueAction(Action);
            }else{
                component.set("v.showSpinner",false);
            }
        }
    }
    
})