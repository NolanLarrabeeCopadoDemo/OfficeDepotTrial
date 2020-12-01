({
	EditCPT : function(component, event, helper) {
     
		helper.EditCPThelper(component, event, helper);
	},
    DeleteCPT: function(component, event, helper) {
		helper.DeleteCPThelper(component, event, helper);
    },
    BacktoContract: function(component, event, helper) {
		helper.BacktoContracthelper(component, event, helper);
    },
    CloneCPT: function(component, event, helper) {
		helper.CloneCPThelper(component, event, helper);
    },
    myInit : function(component, event, helper){
       
        var val=component.get("v.Contract_Pricing_Terms__c.Comm_Req_CC_Price_Chg__c");
        if(val=='Notification and customer approval'||val=='Notification only'){
           component.set("v.NoticePeriod", true); 
        }
        
        //helper.Getrec(component);
        	var recId = component.get("v.recordId");
      // alert('recId'+recId);

		
   
        
    },
   
      sectionOne : function(component, event, helper) {
       helper.helperFun(component,event,'articleOne');
    },
    
   sectionTwo : function(component, event, helper) {
      helper.helperFun(component,event,'articleTwo');
    },
   
   sectionThree : function(component, event, helper) {
      helper.helperFun(component,event,'articleThree');
   },
   
  editRecordHandler1 : function(component, event, helper) {
    
     // component.find("forceRecordCmp1").set("v.fields.Name", null);
      //alert(component.get("v.fields.Name"));
       //component.set("v.ClonePage","True");
      component.set("v.curView","Clone");
	//component.set("v.fields.Name",null);
      // component.find("forceRecordCmp1").set("v.fields.Name", null);
    },
    
    editRecordHandler : function(component, event, helper) {
	component.set("v.curView", "editView");
    },
    BacktoContract:function(component, event, helper) {
        helper.BacktoContract_helper(component, event, helper);
    },
    DeleteRecord :function(component, event, helper) {
       helper.DeleteContract_helper(component, event, helper); 
        	
    },
    openModel: function(component, event, helper) {
      component.set("v.isOpen", true);
   },
 
   closeModel: function(component, event, helper) {
      component.set("v.isOpen", false);
   },
})