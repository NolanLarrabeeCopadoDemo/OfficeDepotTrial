({
    /* Added By aravind Events Tab helper starts here*/
    // Fetch the accounts from the Apex controller
    getEvents: function(component) {
        var action = component.get('c.getEvents');
        // Set up the callback
        var self = this;
        action.setCallback(this, function(actionResult) {
            component.set('v.calEvents', actionResult.getReturnValue());
        });
        $A.enqueueAction(action);
    }, 
    /* Added By aravind Events Tab helper Ends here*/
    fetchPickListVal: function(component, sObject, fieldName, listName) {
        var action = component.get("c.getPicklistValues");
        action.setParams({
            "objObject": sObject,
            "fieldName": fieldName
        });
        var opts = [];
        action.setCallback(this, function(response) {
            if (response.getState() == "SUCCESS") {
                var allValues = response.getReturnValue();
                for (var cnt = 0; cnt < allValues.length; cnt++) {
                    opts.push({
                        label: allValues[cnt],
                        value: allValues[cnt]
                    });
                }
                component.set(listName, opts);
            }
        });
        $A.enqueueAction(action);
    },
    hinit : function(component) {
        var urlparams=window.location.search.substring('code=');
        if(window.location.href.indexOf('state=2313') > -1) {
            var check='linkedin';
        } else if (window.location.href.indexOf('state=') > -1) {
            var check='google';  
        } else {
            var check='facebook';  
        }
        console.log('==>button clicked is:'+check);
        if(urlparams != null && urlparams != '') {
            component.set("v.isOpenDesk", true);
            document.body.setAttribute('style','overflow:hidden;');
            var indx=urlparams.length-0;
            var tempcode=urlparams.substring(6,indx);
            console.log('==>tempcode looks like:'+tempcode);
            var action=component.get("c.initLead");
            action.setParams({tempcode: tempcode,check:check});
            action.setCallback(this, function(response) {
                var state = response.getState();
                if (state === "SUCCESS") {
                    var res= response.getReturnValue(); 
                    if(res.FirstName != undefined || res.FirstName != null) {
                        component.set("v.li_lead.FirstName",res.FirstName);  
                    }
                    if(res.LastName != undefined || res.LastName != null) {
                        component.set("v.li_lead.LastName",res.LastName); 
                    }
                    if(res.Email != undefined || res.Email!= null) {
                        component.set("v.li_lead.Email",res.Email);
                    }
                    if(res.Title != undefined || res.Title != null) {
                        component.set("v.li_lead.Title",res.Title);  
                    }
                    if(res.CompanyName != undefined || res.CompanyName != null) {
                        component.set("v.li_lead.Company",res.CompanyName);  
                    }
                }
                else if (state === "ERROR") {
                    if(response.getError()[0].message == 'Attempt to de-reference a null object') {
                        component.set("v.isOpenDesk", true);
                        document.body.setAttribute('style','overflow:hidden;');   
                    } else 
                    {
                        var toastEvent = $A.get("e.force:showToast");
                        toastEvent.setParams({
                            "title": '"Error"',
                            "type": '"error"',
                            "message": response.getError()[0].message
                        });
                        toastEvent.fire(); 
                    }
                }
            });
            $A.enqueueAction(action);
        }      
    },
    hsubmitLead : function(component) {
        console.log('Did it get called');
        var action=component.get("c.saveLead");
        component.set("v.Spinner" , true);
        action.setParams({
            l : component.get("v.li_lead")
        });
        action.setCallback(this,function(response) {
            component.set("v.Spinner" , false);
            var state = response.getState();
            console.log('Am i getting '+state);
            if (state === "SUCCESS") {
                if (response.getReturnValue() == 'S') {
                    // alert('success');
                    component.set("v.leadSubmitted" , true);
                }
            }
            else {
            }
        });
        $A.enqueueAction(action);    
    },
    isInputDataValid : function(component, event) {
        var isValid = true;
        if(component.find("fnameid").reportValidity() == false) {
            isValid = false;
        }
        if (component.find("lnameid").reportValidity() == false)  {
            isValid = false;
        } 
        if (component.find("emailid").reportValidity() == false) {
            isValid = false;
        }
        if (component.find("titleid").reportValidity() == false) {
            isValid = false;
        }
        if (component.find("phoneid").reportValidity() == false) {
            isValid = false;
        } 
        if (component.find("cnameid").reportValidity() == false) {
            isValid = false;
        } 
        if (component.find("zip").reportValidity() == false) {
            isValid = false;
        } 
        if (component.find("stateId").get("v.value") == null || component.find("stateId").get("v.value") =="") {
            component.find("stateId").showHelpMessageIfInvalid() ;
            isValid  = false;
        } 
        
        if(!this.validatePhone(component, event)) {
            isValid  = false;
        }
        if(!this.validateEmail(component, event)) {
            isValid  = false;
        }
        if(!this.validateFirstName(component, event)) {
            isValid  = false;
        }
        if(!this.validateLastName(component, event)) {
            isValid  = false;
        }
        if(!this.validateZipCode(component, event)) {
            isValid  = false;
        }
        
        if(!this.validateBenifited(component, event)) {
            isValid  = false;
        }
        if(!this.validateHearUs(component, event)) {
            isValid  = false;
        }
        
        return isValid;
    },
    validateEmail : function(component, event) {
        var emailField = component.find("emailid");
        var emailFieldValue = emailField.get("v.value");
        var regExpEmailformat = /^(([^<>()\[\]\\.,;:\s@"]+(\.[^<>()\[\]\\.,;:\s@"]+)*)|(".+"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$/;  
        if(!$A.util.isEmpty(emailFieldValue)) {   
            if(emailFieldValue.match(regExpEmailformat)) {
                emailField.setCustomValidity("");  
            } else {
                emailField.setCustomValidity("Invalid email format.");
            }
        }
        return component.find("emailid").reportValidity();
    },
    validateFirstName : function(component, event) {
        var fnameField = component.find("fnameid");
        var fnameFieldValue = fnameField.get("v.value");
        if(!$A.util.isEmpty(fnameFieldValue)) {   
            if (isNaN(fnameFieldValue)) {
                fnameField.setCustomValidity("");
            }else
            {
                fnameField.setCustomValidity("First Name cannot contain numbers");
            }
        }
        return component.find("fnameid").reportValidity();
    },  
    
    
    validatePhone : function(component, event) {
        var phoneField = component.find("phoneid");
        var phoneValue = phoneField.get("v.value");
        if(!$A.util.isEmpty(phoneValue)) {   
            if (isNaN(phoneValue)) {
                phoneField.setCustomValidity("");
            }else
            {
                phoneField.setCustomValidity("Your entry does not match the allowed pattern.");
            }
        }
        return component.find("phoneid").reportValidity();
    },
    
    
    
    
    validateLastName : function(component, event) {
        var lnameField = component.find("lnameid");
        var lnameFieldValue = lnameField.get("v.value");
        if(!$A.util.isEmpty(lnameFieldValue)) {   
            if (isNaN(lnameFieldValue)) {
                lnameField.setCustomValidity("");
            }else
            {
                lnameField.setCustomValidity("Last Name cannot contain numbers");
            }
        }
        return component.find("lnameid").reportValidity();
    },
    validateZipCode : function(component, event) {
        var zipCodeField = component.find("zip");
        var zipCodeFieldValue = zipCodeField.get("v.value");
        if(!$A.util.isEmpty(zipCodeFieldValue)) {   
            if (isNaN(zipCodeFieldValue) || zipCodeFieldValue.length != 5 ) {
                zipCodeField.setCustomValidity("Invalid Zip Format");
            }else
            {
                zipCodeField.setCustomValidity("");
            }
        }
        return component.find("zip").reportValidity();
    },
    validateBenifited : function(component, event) {
        var benifitField = component.find("benfits");
        var benifitFieldValue = benifitField.get("v.value");
        if(!$A.util.isEmpty(benifitFieldValue)) {   
            if (benifitFieldValue.length >= 150 ) {
                benifitField.setCustomValidity("Too many characters");
            }else
            {
                benifitField.setCustomValidity("");
            }
        }
        return component.find("benfits").reportValidity();
    },
    validateHearUs : function(component, event) {
        var hearUsField = component.find("hearus");
        var hearUsFieldValue = hearUsField.get("v.value");
        if(!$A.util.isEmpty(hearUsFieldValue)) {   
            if (hearUsFieldValue.length >= 150 ) {
                hearUsField.setCustomValidity("Too many characters");
            }else
            {
                hearUsField.setCustomValidity("");
            }
        }
        return component.find("hearus").reportValidity();
    },
    /* Added by Aravind for header part */
    ApplyBottomBorder: function(component, event)
    {
        var NodeId = event.target.innerText;
        var Currentnode = component.find(NodeId);
        var CurrentnodeLi = component.find(NodeId + "Li");   
        $A.util.addClass(Currentnode, 'UnderClass');
        $A.util.addClass(CurrentnodeLi, 'UnderClassLi');
        component.set("v.PreviousNode", NodeId);  
        component.set("v.PreviousNodeLi", NodeId + "Li");   
    },
    RemoveBottomBorder: function(component, event)
    {
        var previousNodeId = component.get("v.PreviousNode");
        var previousNodeIdLi = component.get("v.PreviousNodeLi");
        if(previousNodeId != null)
        {
            var previousNode = component.find(previousNodeId);
            var previousNodeLi = component.find(previousNodeIdLi);
            $A.util.removeClass(previousNode, 'UnderClass');
            $A.util.removeClass(previousNodeLi, 'UnderClassLi');
        }
    },
    ScrollMethod : function(component, event, helper) {
        var device = $A.get("$Browser.formFactor");            
        if(device == 'DESKTOP')
        {
            var elTop = document.getElementById('topSection');
            var el = document.getElementById('overView');
            var elbenefits = document.getElementById('benefits');
            var elsolutions = document.getElementById('solutions');
            var elprocess = document.getElementById('process');
            var elevents = document.getElementById('events');
            var elpartners = document.getElementById('partners');
            var elcontact = document.getElementById('contact');
            var rect = el.getBoundingClientRect(), top = rect.top,bottom = rect.bottom, height = rect.height;
            var rectbenefits = elbenefits.getBoundingClientRect(), topbenefits = rectbenefits.top,bottombenefits = rectbenefits.bottom, heightbenefits = rectbenefits.height;
            var rectsolutions = elsolutions.getBoundingClientRect(), topsolutions = rectsolutions.top,bottomsolutions = rectsolutions.bottom, heightsolutions = rectsolutions.height;
            var rectprocess = elprocess.getBoundingClientRect(), topprocess = rectprocess.top,bottomprocess = rectprocess.bottom, heightprocess = rectprocess.height;
            var rectevents = elevents.getBoundingClientRect(), topevents = rectevents.top,bottomevents = rectevents.bottom, heightevents = rectevents.height;
            var rectpartners = elpartners.getBoundingClientRect(), toppartners = rectpartners.top,bottompartners = rectpartners.bottom, heightpartners = rectpartners.height;
            var rectcontact = elcontact.getBoundingClientRect(), topcontact = rectcontact.top,bottomcontact = rectcontact.bottom, heightcontact = rectcontact.height;
            var rectTop = elTop.getBoundingClientRect(), topTop = rectTop.top,bottomTop = rectTop.bottom, heightTop = rectTop.height;
            document.getElementById("RegisterDiv").style.display = 'block';       
            var divsToHide = document.getElementsByClassName("UnderClass");
            
            for(var i = 0; i < divsToHide.length; i++)
            {
                divsToHide[i].classList.remove("UnderClass");;
            }
            if(topTop <= document.documentElement.clientHeight && bottomTop >= document.documentElement.clientHeight) 
            {
                //Show Register
                document.getElementById("RegisterDiv").style.display = 'none';
                var divsToHide = document.getElementsByClassName("UnderClass");
                
                for(var i = 0; i < divsToHide.length; i++)
                {
                    divsToHide[i].classList.remove("UnderClass");;
                }
                
            }
            else if(top <= document.documentElement.clientHeight && bottom >= document.documentElement.clientHeight) 
            {
                //Show Register
                document.getElementById("RegisterDiv").style.display = 'block';
                this.handleNavBarEvent(component, event,'Overview');
            }
                else if(topbenefits <= document.documentElement.clientHeight && bottombenefits >= document.documentElement.clientHeight) 
                {
                    //Show Register
                    document.getElementById("RegisterDiv").style.display = 'block';
                    this.handleNavBarEvent(component, event,'Benefits');
                }
                    else if(topsolutions <= document.documentElement.clientHeight && bottomsolutions >= document.documentElement.clientHeight) 
                    {
                        //Show Register
                        document.getElementById("RegisterDiv").style.display = 'block';
                        this.handleNavBarEvent(component, event,'Solutions');
                    }
                        else if(topprocess <= document.documentElement.clientHeight && bottomprocess >= document.documentElement.clientHeight) 
                        {
                            //Show Register
                            document.getElementById("RegisterDiv").style.display = 'block';
                            this.handleNavBarEvent(component, event,'Process');
                        }
                            else if(topevents <= document.documentElement.clientHeight && bottomevents >= document.documentElement.clientHeight) 
                            {
                                //Show Register
                                document.getElementById("RegisterDiv").style.display = 'block';
                                this.handleNavBarEvent(component, event,'Events');
                            }
                                else if(toppartners <= document.documentElement.clientHeight && bottompartners >= document.documentElement.clientHeight) 
                                {
                                    //Show Register
                                    document.getElementById("RegisterDiv").style.display = 'block';
                                    this.handleNavBarEvent(component, event,'Partners');
                                }
                                    else if(topcontact <= document.documentElement.clientHeight && bottomcontact >= document.documentElement.clientHeight) 
                                    {
                                        //Show Register
                                        document.getElementById("RegisterDiv").style.display = 'block';
                                        this.handleNavBarEvent(component, event,'Contact');
                                    }
            /*else
                        {
                            //Show Register
                            document.getElementById("RegisterDiv").style.display = 'none';
                            this.handleNavBarEvent(component, event,'abc');
                            //Show Navbar
                            
                        }*/
        }
    },
    handleNavBarEvent : function(component, event, BarName) {
        //Remove Underline
        var previousNodeId = component.get("v.PreviousNode");
        var previousNodeIdLi = component.get("v.PreviousNodeLi");
        if(previousNodeId != null)
        {
            var previousNode = component.find(previousNodeId);
            var previousNodeLi = component.find(previousNodeIdLi);
            $A.util.removeClass(previousNode, 'UnderClass');
            $A.util.removeClass(previousNodeLi, 'UnderClassLi');
        }
        //Put Underline
        var Currentnode = component.find(BarName);
        var CurrentnodeLi = component.find(BarName + "Li");
        $A.util.addClass(Currentnode, 'UnderClass');
        $A.util.addClass(CurrentnodeLi, 'UnderClassLi');
        component.set("v.PreviousNode", BarName);  
        component.set("v.PreviousNodeLi", BarName + "Li");  
    },
    hideHam : function(component, event, helper) {
        var device = $A.get("$Browser.formFactor");
        console.log("You are using a " + device);
        if(device != 'DESKTOP')
        {
            document.getElementById("HamburgerMenu_list").style.display = "none";
            document.getElementById("ham_menu_register").style.visibility = "visible";
        }
    },
    
    /*
    This function returns the list of matching addresses from Google API.
    searchKey: Input address provided by the user.
    filterField: The name of the field in the component that displays the Google provided address predictions.
    */
    displayGoogleProvidedAddresses: function (component, searchKey, addressPredictionsField) {
        var action = component.get("c.getAddressAutoComplete");
        action.setParams({
            "input": searchKey,
            "types": 'geocode'
        });
        
        action.setCallback(this, function (response) {
            
            var state = response.getState();
            if (state === "SUCCESS") {
                var options = JSON.parse(response.getReturnValue());
                //alert(JSON.stringify(options) + '>>>Test' );
                var predictions = options.predictions;
                //alert(JSON.stringify(predictions) + '<<<<<<<<<<<<<420');
                var addresses = [];
                if (predictions.length > 0) {
                    for (var i = 0; i < predictions.length; i++) {
                        addresses.push({
                            value: predictions[i].types[0],
                            label: predictions[i].description,
                            placeid: predictions[i].place_id
                            
                        });
                    }
                    component.set("v." + addressPredictionsField, addresses);
                }
            }
        });
        $A.enqueueAction(action);
    },
    
    placeidquery: function (component, searchKey) {
        //console.log('Inside place query');
        var action = component.get("c.getAddressPlaceInfo");
        action.setParams({
            "input": searchKey
        });
        var placeidresponse = '';
        var respresults = '';
        
        action.setCallback(this, function (response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                placeidresponse = JSON.parse(response.getReturnValue());
                respresults = placeidresponse.result;
                console.log(JSON.stringify(respresults) + 'Place');
                var street_number = '', route = '', administrative_area_level_1 = '';
                var administrative_area_level_2 = '', country = '', postal_code = '',locality='';
                var GAddr_Flag= false;
                var componentForm = {
                    name: 'long_name',
                    international_phone_number: 'long_name',
                    locality: 'long_name',
                    postal_town: 'long_name',
                    administrative_area_level_1: 'short_name',
                    administrative_area_level_2: 'short_name',
                    country: 'short_name',
                    postal_code: 'short_name',
                    route: 'long_name',
                    street_number: 'long_name',
                    street: 'long_name',
                    website: 'long_name',
                };
                
                for (var i = 0; i < respresults.address_components.length; i++) {
                    
                    var addressType = respresults.address_components[i].types[0]; 
                    if (addressType === 'street_number')// get the street number
                    {                    
                        if(respresults.address_components[i][componentForm[addressType]] === 'undefined')
                            street_number = '';
                        else
                            street_number = respresults.address_components[i][componentForm[addressType]];
                        //alert('street_number: ' + street_number);
                    }
                    else if (addressType === 'route') // get the street name
                    {   
                        if(respresults.address_components[i][componentForm[addressType]] === 'undefined')
                            route = '';
                        
                        else
                            route = respresults.address_components[i][componentForm[addressType]];
                        //alert('route: ' + route);
                    }
                        else if(addressType === 'locality')//city
                        {
                            if(respresults.address_components[i][componentForm[addressType]] === 'undefined')
                                locality = '';
                            else
                                locality = respresults.address_components[i][componentForm[addressType]];
                            //alert('locality: ' + locality);
                        }
                    
                            else if (addressType === 'administrative_area_level_1')// get the state
                            {
                                if(respresults.address_components[i][componentForm[addressType]] === 'undefined')
                                    administrative_area_level_1 = '';
                                else
                                    administrative_area_level_1 = respresults.address_components[i][componentForm[addressType]];
                                //alert('administrative_area_level_1: ' + administrative_area_level_1);
                            }                
                                else if (addressType === 'country') // get the country
                                {
                                    if(respresults.address_components[i][componentForm[addressType]] === 'undefined')
                                        country = '';
                                    else
                                        country = respresults.address_components[i][componentForm[addressType]];
                                    //alert('country: ' + country);
                                }
                                    else if (addressType === 'postal_code') // get the postal code
                                    {
                                        if(respresults.address_components[i][componentForm[addressType]] === 'undefined')
                                            postal_code = '';
                                        else
                                            postal_code = respresults.address_components[i][componentForm[addressType]];
                                        //alert('postal_code: ' + postal_code);
                                    }                            
                    
                    
                    
                }
                component.find("stateId").set("v.value", administrative_area_level_1);
                component.find("cityid").set("v.value", locality);
                component.find("addid").set("v.value", street_number +" "+ route);
                component.find("zip").set("v.value", postal_code);  
                
                component.set("v.placeResponse", JSON.stringify(respresults));
                var addressEvent = component.getEvent("addressComponentEvent");
                addressEvent.setParams({
                    "addressString": component.get("v.placeResponse")
                });
                addressEvent.fire();
            }
        });
        
        $A.enqueueAction(action);
    },
    
    openListbox: function (component, searchKey) {
        var searchLookup = component.find("searchLookup");
        
        if (typeof searchKey === 'undefined' || searchKey.length < 3) {
            $A.util.addClass(searchLookup, 'slds-combobox-lookup');
            $A.util.removeClass(searchLookup, 'slds-is-open');
            return;
        }
        
        $A.util.addClass(searchLookup, 'slds-is-open');
        $A.util.removeClass(searchLookup, 'slds-combobox-lookup');
    },
    
    clearComponentConfig: function (component) {
        var searchLookup = component.find("searchLookup");
        $A.util.addClass(searchLookup, 'slds-combobox-lookup');
        
        component.set("v.selectedOption", null);
        component.set("v.searchKey", null);
        
        var iconDirection = component.find("iconDirection");
        $A.util.removeClass(iconDirection, 'slds-input-has-icon_right');
        $A.util.addClass(iconDirection, 'slds-input-has-icon_left');
    }
    /* Addition Ends*/
})