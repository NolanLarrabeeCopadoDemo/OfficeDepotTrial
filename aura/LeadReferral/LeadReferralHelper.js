({
    doinithelper : function(component,event) {
        //Get the record Id and send to apex controller
        var rec =window.location.search.substring('conc=');
        var recordId= rec.substring(6,21);
        var action=component.get("c.initHelperMeth"); 
        action.setParams({'recordId':recordId});
        action.setCallback(this,function(response) {
            if(response.getState() == "SUCCESS") {
                var res = response.getReturnValue();
                // If return map contains message, a refferal already exists by that account and to that third [arty]
                if(res.message != null || res.message!= undefined) {
                    component.set("v.displaymessage",true); 
                    component.set("v.showPicklist" , false);
                } else {
                    //Prepoulate fields with values retirved from apex controller
                    component.set("v.showPicklist" , true);
                    //Populating Account Name
                    if(res.customer != null || res.customer!= undefined) {
                        component.set("v.objRef.Customer_Name__c",res.customer);  
                    }
                    //Populating Contact Name
                    if(res.contactname != null || res.contactname != undefined) {
                        component.set("v.objRef.Contact_Name__c",res.contactname);  
                    }
                    //Populating contact phone
                    if(res.contactphone != null || res.contactphone != undefined) {
                        component.set("v.objRef.Customer_Phone__c",res.contactphone); 
                    }
                    //Popualting Contact email
                    if(res.contactemail != null || res.contactemail != undefined) {
                        component.set("v.objRef.Contact_Email__c",res.contactemail);  
                    }
                    //Populating Referrers name 
                    if(res.employeename != null || res.employeename != undefined) {
                        component.set("v.objRef.Employee_Name__c",res.employeename); 
                    }
                    // Populating Referrers Phone
                    if(res.emplyeephone != null || res.emplyeephone != undefined) {
                        component.set("v.objRef.Employee_Phone__c",res.emplyeephone);   
                    }
                    // Populating Referrers Id
                    if(res.employeeid != null || res.employeeid != undefined) {
                        component.set("v.objRef.Referrers_Employee_ID__c",res.employeeid);   
                    }
                    // Populating cust id retrived from Account
                    if(res.custid != null || res.custid != undefined) {
                        component.set("v.objRef.Cust_Id__c",res.custid);   
                    }
                }
            }
        });
        $A.enqueueAction(action); 
    },
    // submitting the Referal
    handleSubmitHelper : function(component,event) {
        var rec =window.location.search.substring('conc=');
        var recordId= rec.substring(6,21);
        component.set("v.showPicklist" , false); 
        component.set("v.Spinner" , true);
        var action=component.get("c.saveReferral");     
        action.setParams({
            ref : component.get("v.objRef"), recordId:recordId
        });
        action.setCallback(this,function(response) {
            component.set("v.Spinner" , false);
            if(response.getState() == "SUCCESS") {
                var res = response.getReturnValue();
                component.set("v.message" , true);
            }
        });
        $A.enqueueAction(action); 
    },
    // Next Button after selecting the Referral
    handleNextHelper : function(component,event) {
        var slctdVal=component.find("select1").get("v.value");    
        if(slctdVal == '1') {
            component.set("v.showFields" , true);  
            component.set("v.showPicklist" , false);
        }
    }   
})