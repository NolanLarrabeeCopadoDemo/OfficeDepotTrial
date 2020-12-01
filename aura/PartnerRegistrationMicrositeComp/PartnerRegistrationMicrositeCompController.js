({
    /* Added by aravind Events tab starts here */
    top: function(component, event, helper){
        window.scrollTo(0, 0);
    },
    
    /* Added by Faraz auto format phone number */
    handleBlur: function(component, event, helper){
        var phoneNumber = component.find("phoneid").get("v.value");
        var x = phoneNumber;
        var ph =  myUtil.phoneFormat(x);
        component.find("phoneid").set("v.value", ph);
    },
    
    handleValueChange : function(component, event, helper) {
        helper.ScrollMethod(component, event, helper)
    },
    /* Added by aravind Events tab ends here */
    doInit : function(component, event, helper) {
        
        var url = $A.get('$Resource.microsite');
        component.set('v.backgroundImageURL', url); 
        var ovimg = $A.get('$Resource.overview');
        component.set('v.image1', ovimg);
        var url = $A.get('$Resource.microsite');
        component.set('v.obackgroundImageURL', url); 
        var ovimg = $A.get('$Resource.overview');
        component.set('v.image1', ovimg);
        var bpimg = $A.get('$Resource.Becomepartner');
        component.set('v.becomepartnerImageURL', bpimg);
        var fontFile = $A.get('$Resource.OpenSansFont');
        component.set('v.opensansFontURL', fontFile);
        var testimonyImg = $A.get('$Resource.PartnerRegBubble');
        component.set('v.testimonialImageURL', testimonyImg); 
        var url1 = $A.get('$Resource.PartnerRegistrationProcessBubble');
        component.set('v.backgroundImageURL1', url1);
        helper.fetchPickListVal(component, component.get("v.li_lead"), 'State__c', 'v.StatePicklist');
        helper.hinit(component);
        //shravya code ends here NAIT-81536
        /* Added by aravind Events tab starts here */
        // Fetch the account list from the Apex controller
        helper.getEvents(component);
        /* Added by aravind Events tab ends here */
        /* Added by aravind Footer starts here */
        var today = new Date();
        var monthDigit = today.getMonth() + 1;
        if (monthDigit <= 9) {
            monthDigit = '0' + monthDigit;
        }
        component.set('v.today', today.getFullYear());
        /* Added by aravind Fotter tab ends here */ 
        
        
    },
    toggle : function(component, event, helper) {
        var divId = event.currentTarget.id;
        component.set("v." + divId, !component.get("v." + divId));
        if (divId != 'One') { 
            component.set("v.One", false);
            document.getElementById("oneActive").setAttribute("style", "border-top: 0x solid white;");
        }else{
            
            document.getElementById("oneActive").setAttribute("style", "border-top: 2px solid red;"); 
            
        }
        if (divId != 'Two') { component.set("v.Two", false); document.getElementById("twoActive").setAttribute("style", "border-top: 0x solid white;");}else{document.getElementById("twoActive").setAttribute("style", "border-top: 2px solid red;");}
        if (divId != 'Three') { component.set("v.Three", false); document.getElementById("threeActive").setAttribute("style", "border-top: 0x solid white;");}else{ document.getElementById("threeActive").setAttribute("style", "border-top: 2px solid red;"); 
                                                                                                                                                                  }
        if (divId != 'Four') { component.set("v.Four", false);  document.getElementById("fourActive").setAttribute("style", "border-top: 0x solid white;");}else{ document.getElementById("fourActive").setAttribute("style", "border-top: 2px solid red;"); 
                                                                                                                                                                }
        if (divId != 'Five') { component.set("v.Five", false);  document.getElementById("fiveActive").setAttribute("style", "border-top: 0x solid white;");}else{ document.getElementById("fiveActive").setAttribute("style", "border-top: 2px solid red;"); 
                                                                                                                                                                }
        if (divId != 'Six') { component.set("v.Six", false);  document.getElementById("sixActive").setAttribute("style", "border-top: 0x solid white;");}else{ document.getElementById("sixActive").setAttribute("style", "border-top: 2px solid red;"); 
                                                                                                                                                             } 
    },
    //shravya code starts here NAIT-81536
    closeModal:function(component,event,helper){    
        var callBackUrl = $A.get("$Label.c.PRM");
        window.open(callBackUrl,'_self');
    },
    openmodal:function(component,event,helper) {
        component.set("v.isOpenDesk", true);
        document.body.setAttribute('style','overflow:hidden;');
    },
    getAccessTokenLnkdn: function(component, event, helper)	{
        var action = component.get("c.linkedinCred");
        var burl = $A.get("$Label.c.PRM");
        console.log('--> am i getting here');
        action.setCallback(this, function(response) {
            console.log('--> am i getting response for linkedin'+ response.getReturnValue());
            component.set("v.allLinkedin", response.getReturnValue());  
            window.open(component.get('v.allLinkedin.codeURL__c') + component.get('v.allLinkedin.ClientId__c')+'&redirect_uri='+component.get('v.allLinkedin.AuthURL__c')+'&state=2313&scope=r_emailaddress+r_basicprofile','_self');             
        });
        $A.enqueueAction(action);
    },
    getAccessTokenFB: function(component, event, helper) {
        var action = component.get("c.facebookCred");
        var burl = $A.get("$Label.c.PRM");
        action.setCallback(this, function(response){
            component.set("v.allFacebook", response.getReturnValue());                  
            window.open(component.get('v.allFacebook.Token_Url__c') + component.get('v.allFacebook.Facebook_ClientId__c')+'&redirect_uri='+burl+' &scope=email','_self');             
        });
        $A.enqueueAction(action);   
    },
    getAccessTokenGoogle: function(component, event, helper) {
        var action = component.get("c.googleCred");
        var Gurl = $A.get("$Label.c.PRM");
        action.setCallback(this, function(response){
            component.set("v.allGoogle", response.getReturnValue());
            window.open(component.get('v.allGoogle.Auth_URL__c') + '?scope=https://www.googleapis.com/auth/userinfo.email https://www.googleapis.com/auth/userinfo.profile&state=/profile&redirect_uri=' + Gurl + '&response_type=code&client_id=' + component.get('v.allGoogle.ClientId__c') + '&approval_prompt=force', '_self');
        });
        $A.enqueueAction(action);
    },
    submitLead : function(component, event, helper) {
        if (helper.isInputDataValid(component, event)) {
            helper.hsubmitLead(component);
        }
    },
    /*  Added by Aravind for header part*/
    handleClick : function (cmp, event, helper) {
        alert("You clicked: " + event.getSource().get("v.label"));
    },
    HoverIn : function(component, event, helper){
        //document.getElementById("RegisterImage").src =  $A.get('$Resource.Navigation_Images') + '/assets/HoverRegisterButton.svg';      
    },
    HoverOut : function(component, event, helper){
        //document.getElementById("RegisterImage").src =  $A.get('$Resource.Navigation_Images') + '/assets/RegisterButton.svg';      
    },
    HamburgerMenu : function(component, event, helper){ 
        document.getElementById("HamburgerMenu_list").style.display = "block";
        document.getElementById("ham_menu_register").style.visibility = "hidden";
    },
    HamburgerMenu_close : function(component, event, helper){ 
        console.log("Called");
        helper.hideHam(component, event, helper);
    },
    ScrollOverview : function(component, event, helper){ 
        helper.RemoveBottomBorder(component, event);
        helper.ApplyBottomBorder(component, event);
        helper.hideHam(component, event, helper);
        document.getElementById("RegisterDiv").style.display = "block";
    },
    ScrollBenefits : function(component, event, helper){ 
        helper.RemoveBottomBorder(component, event);
        helper.ApplyBottomBorder(component, event);
        helper.hideHam(component, event, helper);
        document.getElementById("RegisterDiv").style.display = "block";
    },
    ScrollSolutions : function(component, event, helper){ 
        helper.RemoveBottomBorder(component, event);
        helper.ApplyBottomBorder(component, event);
        helper.hideHam(component, event, helper);
        document.getElementById("RegisterDiv").style.display = "block";
    },
    ScrollProcess : function(component, event, helper){ 
        helper.RemoveBottomBorder(component, event);
        helper.ApplyBottomBorder(component, event);
        helper.hideHam(component, event, helper);
        document.getElementById("RegisterDiv").style.display = "block";
    },
    ScrollEvents : function(component, event, helper){ 
        helper.RemoveBottomBorder(component, event);
        helper.ApplyBottomBorder(component, event);
        helper.hideHam(component, event, helper);
        document.getElementById("RegisterDiv").style.display = "block";
    },
    ScrollPartners : function(component, event, helper){ 
        helper.RemoveBottomBorder(component, event);
        helper.ApplyBottomBorder(component, event);
        helper.hideHam(component, event, helper);
        document.getElementById("RegisterDiv").style.display = "block";
    },
    ScrollContact : function(component, event, helper){ 
        helper.RemoveBottomBorder(component, event);
        helper.ApplyBottomBorder(component, event);
        helper.hideHam(component, event, helper);
        document.getElementById("RegisterDiv").style.display = "block";
    },
    ScrollOthers : function(component, event, helper){
        helper.RemoveBottomBorder(component, event);
        helper.ApplyBottomBorder(component, event);
        helper.hideHam(component, event, helper);
        document.getElementById("RegisterDiv").style.display = "none";
    },
    handleValueChange : function(component, event, helper) {
        helper.ScrollMethod(component, event, helper)
    },
    
    keyPressController: function (component, event, helper) {
        
        var searchKey = component.get("v.searchKey");
        var addressPredictionsField  = "filteredOptions";
        helper.openListbox(component, searchKey);
        helper.displayGoogleProvidedAddresses(component, searchKey, addressPredictionsField);
    },
    
    selectOption: function (component, event, helper) {
        var selectedItem = event.currentTarget.dataset.record;
        //console.log(event.currentTarget.dataset);
        //console.log(selectedItem);
        var selectedValue = event.currentTarget.dataset.value;
        //console.log(selectedValue);
        var placeidValue = event.currentTarget.dataset.placeid;
        component.set("v.selectedOption", selectedItem);
        var searchLookup = component.find("searchLookup");
        $A.util.removeClass(searchLookup, 'slds-is-open');
        var iconDirection = component.find("iconDirection");
        $A.util.removeClass(iconDirection, 'slds-input-has-icon_left');
        $A.util.addClass(iconDirection, 'slds-input-has-icon_right');
        component.set("v.searchKeyAddress", selectedItem);
        //console.log('Helper about to be called');
        helper.placeidquery(component, placeidValue, event);
        component.find("clearLoc").set("v.value","");
    },
    
    clear: function (component, event, helper) {
        helper.clearComponentConfig(component);
    } 
})