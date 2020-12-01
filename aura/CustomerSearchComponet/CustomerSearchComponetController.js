({
    doInit : function(component, event, helper) {
        
       helper.doInitValidate(component);
        
       //component.set("v.showAccSearch",true);        
       //helper.initRecords(component);
    },
    // Start: Added by Rajendra Shahane for NAIT-146087 - Implement SFDC Out of the Box Address Search for Prospects
    assignAddress : function(component, event, helper){
        var inputAddress = component.find("billingAddress"); //finding Input Address by aura:id
        var countryOptions = [
        { label: 'USA', value: 'USA' },
            { label: 'CAN', value: 'CAN' },
            { label: 'MEX', value: 'MEX' },
            
    ];
        component.set("v.accCountryList",countryOptions);
        var CANstateOptions = [{label: 'AB', value: 'AB'}, { label: 'BC', value: 'BC'}, { label: 'MB', value: 'MB'}, 
                              { label: 'NB', value: 'NB'}, { label: 'NL', value: 'NL'}, { label: 'NT', value: 'NT'}, 
                              { label: 'NS', value: 'NS'}, { label: 'NU', value: 'NU'}, { label: 'ON', value: 'ON'}, 
                              { label: 'PE', value: 'PE'}, { label: 'QC', value: 'QC'}, { label: 'SK', value: 'SK'}, 
                              { label: 'YT', value: 'YT'}];
        var USAstateOptions = [{label: 'AK', value:'AK'},{ label: 'AL', value:'AL'},{ label: 'AR', value:'AR'},
                               { label: 'AZ', value:'AZ'},{ label: 'CA', value:'CA'},{ label: 'CO', value:'CO'},
                               { label: 'CT', value:'CT'},{ label: 'DC', value:'DC'},{ label: 'DE', value:'DE'},
                               { label: 'FL', value:'FL'},{ label: 'GA', value:'GA'},{ label: 'HI', value:'HI'},
                               { label: 'IA', value:'IA'},{ label: 'ID', value:'ID'},{ label: 'IL', value:'IL'},
                               { label: 'IN', value:'IN'},{ label: 'KS', value:'KS'},{ label: 'KY', value:'KY'},
                               { label: 'LA', value:'LA'},{ label: 'MA', value:'MA'},{ label: 'MD', value:'MD'},
                               { label: 'ME', value:'ME'},{ label: 'MI', value:'MI'},{ label: 'MN', value:'MN'},
                               { label: 'MO', value:'MO'},{ label: 'MS', value:'MS'},{ label: 'MT', value:'MT'},
                               { label: 'NC', value:'NC'},{ label: 'ND', value:'ND'},{ label: 'NE', value:'NE'},
                               { label: 'NH', value:'NH'},{ label: 'NJ', value:'NJ'},{ label: 'NM', value:'NM'},
                               { label: 'NV', value:'NV'},{ label: 'NY', value:'NY'},{ label: 'OH', value:'OH'},
                               { label: 'OK', value:'OK'},{ label: 'OR', value:'OR'},{ label: 'PA', value:'PA'},
                               { label: 'PR', value:'PR'},{ label: 'RI', value:'RI'},{ label: 'SC', value:'SC'},
                               { label: 'SD', value:'SD'},{ label: 'TN', value:'TN'},{ label: 'TX', value:'TX'},
                               { label: 'UT', value:'UT'},{ label: 'VA', value:'VA'},{ label: 'VI', value:'VI'},
                               { label: 'VT', value:'VT'},{ label: 'WA', value:'WA'},{ label: 'WI', value:'WI'},
                               { label: 'WV', value:'WV'},{ label: 'WY', value:'WY'}];
        var MEXstateOptions = [];
        
        
        if(component.get("v.accRec.Country__c") === 'United States' || component.get("v.accRec.Country__c") === 'US' || component.get("v.accRec.Country__c") === 'USA')
        {
            component.set("v.accStateList",USAstateOptions);
            component.set("v.accRec.Country__c","USA");            
            component.set("v.accRec.State__c",inputAddress.get("v.province"));
        }
        else if(component.get("v.accRec.Country__c") === 'Canada' || component.get("v.accRec.Country__c") === 'CA' || component.get("v.accRec.Country__c") === 'CAN')
        {
            component.set("v.accStateList",CANstateOptions);
            component.set("v.accRec.Country__c","CAN");      
             component.set("v.accRec.State__c",inputAddress.get("v.province"));
        }
        else if(component.get("v.accRec.Country__c") === 'Mexico' || component.get("v.accRec.Country__c") === 'MX' || component.get("v.accRec.Country__c") === 'MEX')
        {
            component.set("v.accStateList",MEXstateOptions);
            component.set("v.accRec.Country__c","MEX");            
        }
        console.log('Street => ' + component.get("v.accRec.Address1__c"));  
        console.log('City => ' + component.get("v.accRec.City__c"));
        
		console.log('Zip => ' + component.get("v.accRec.Zip__c"));
        console.log('State => ' + component.get("v.accRec.State__c"));
		console.log('Country => ' + component.get("v.accRec.Country__c"));        
    },
    // End: Added by Rajendra Shahane for NAIT-146087 - Implement SFDC Out of the Box Address Search for Prospects
    searchCustData : function(component, event, helper) {
    
        if(!$A.util.isEmpty(component.get("v.accRec.Name"))){
            if(component.get("v.accRec.Name").trim() == ''){
                component.set("v.requiredError", true);
                return false;
            }
         
            
        }
        if(!$A.util.isEmpty(component.get("v.accRec.City__c"))){
            if(component.get("v.accRec.City__c").trim() == ''){
                component.set("v.requiredError", true);
                return false;
            }
            
        } 
        if(!$A.util.isEmpty(component.get("v.accRec.Zip__c"))){
            if(component.get("v.accRec.Zip__c").trim() == ''){
                component.set("v.requiredError", true);
                return false;
            }   
        }
        if(!$A.util.isEmpty(component.get("v.accRec.Address1__c"))){
            if(component.get("v.accRec.Address1__c").trim() == ''){
                component.set("v.requiredError", true);
                return false;
            }
            if(component.get("v.accRec.Address1__c").trim().length>25){
                component.set("v.AddressError", true);
                return false;
            } 
        }
        
       
        
        
        if($A.util.isEmpty(component.get("v.accRec.Country__c"))){
                component.set("v.requiredError", true);
                return false;
        }
        if(component.get("v.accRec.Country__c") != 'MEX' && ($A.util.isEmpty(component.get("v.accRec.Name")) || $A.util.isEmpty(component.get("v.accRec.Country__c")) ||
                                                             $A.util.isEmpty(component.get("v.accRec.State__c")) ||  $A.util.isEmpty(component.get("v.accRec.City__c")) ||
                                                             $A.util.isEmpty(component.get("v.accRec.Zip__c")) || $A.util.isEmpty(component.get("v.accRec.Address1__c"))))
        {
            component.set("v.requiredError", true); 
        }else if(component.get("v.accRec.Country__c") == 'MEX' && ($A.util.isEmpty(component.get("v.accRec.Name")) || $A.util.isEmpty(component.get("v.accRec.Country__c")) ||
                                                                   $A.util.isEmpty(component.get("v.accRec.City__c")) ||
                                                                   $A.util.isEmpty(component.get("v.accRec.Zip__c")) || $A.util.isEmpty(component.get("v.accRec.Address1__c")))){
            component.set("v.requiredError", true);
            return false;
            
        }
            else{
                component.set("v.requiredError", false);
                component.set("v.AddressError", false);
                component.set("v.Spinner",true);
                helper.searchCustDataHelper(component);
            }
    },
    /*onCountryChange : function(component, event, helper) {
         component.set("v.accRec.State__c",'');
         helper.getStateValues(component);
    },*/
    handleAddressAutoCompleteEvent : function(component, event, helper) {
        var addressString = event.getParam("addressString");
        //console.log('addressString....'+addressString);
        var parsed = JSON.parse(addressString);
        var city_val ='';
        var sate_val='';
        var country_val='';
        var zip_val ='';
        var street_val = '';
        var address2 = '';
        var addList = parsed.address_components;
        for (var i = 0; i < addList.length; i++) { 
            var typeList = addList[i].types;
            //console.log('typeList.....'+typeList);
            if((typeList.indexOf("administrative_area_level_1") > -1)){
                if(addList[i].short_name != undefined){
                    //sate_val = addList[i].long_name;
                    sate_val = addList[i].short_name;
                }
            }
            if((typeList.indexOf("postal_code") > -1) || (typeList.indexOf("postal_code_suffix") > -1)){
                if(addList[i].long_name != undefined){
                    if(zip_val != ''){
                        zip_val = zip_val +'-'+ addList[i].long_name;  
                    }else{
                        zip_val = addList[i].long_name;  
                    }
                }
            }
            if((typeList.indexOf("locality") > -1)){
                if(addList[i].long_name != undefined){
                    city_val = addList[i].short_name;
                }
            }
            if(typeList.indexOf("route") > -1 || typeList.indexOf("street_number") > -1){
                if(addList[i].long_name != undefined){
                    if(street_val != ''){
                        street_val = street_val +' '+ addList[i].short_name;  
                    }else{
                        street_val = addList[i].short_name;  
                    }
                }
            }
            if((typeList.indexOf("administrative_area_level_2") > -1)){
                if(addList[i].long_name != undefined){
                    address2 = addList[i].short_name;
                }
            }
            if((typeList.indexOf("country") > -1)){
                if(addList[i].long_name != undefined){
                    country_val = addList[i].short_name;
                    if(country_val == 'CA'){
                        country_val='CAN'
                    }
                    if(country_val == 'US'){
                        country_val='USA'
                    }
                    if(country_val == 'MX'){
                        country_val='MEX'
                    }
                    component.set("v.accRec.Country__c",country_val);
                    helper.getStateValues(component);
                }
            }
            
        }
        //helper.getStateValues(component);
        component.set("v.accRec.Country__c",country_val);
        component.set("v.accRec.City__c",city_val);
        component.set("v.accRec.State__c",sate_val);
        component.set("v.accRec.Address1__c",street_val);
        component.set("v.accRec.Zip__c",zip_val);
        //component.set("v.accRec.Address2__c",address2);
    },
    handleProspectBackToCustSearch : function(component, event, helper) {
        component.set("v.showAccSearch",true);
        //To retain the Record Type
        component.find('accRTId').set('v.value',component.get("v.accRec").RecordTypeId); 
        //To retain the values from prospect info section
        var accRec = event.getParam("prospectRec");
        component.set("v.accRec",accRec);
    },
    setAccRT : function(component, event, helper) {
        var accRT = component.find("accRTId").get("v.value");
        component.set("v.accRec.RecordTypeId",accRT);
    }
})