({
	doInit : function(component, event, helper) {
		helper.getAccountInfo(component);
        helper.getAccountIds(component);
          //var selectedRec = component.get('!v.acct.Org__c');        
    
     
       
	},
      handleActive: function (cmp, event, helper) {
        helper.handleActive(cmp, event);
    },
      handleSelect: function (cmp, event, helper) { 
      helper.handleSelect(cmp, event);
    },
    orghierarchy: function (component, event, helper) {
          var recordId = component.get('v.oid');
        var orgIdvalue=component.get('v.oid');
        if(orgIdvalue!=null || orgIdvalue != undefined)
        var orgId=orgIdvalue.substring(0,15);
if(orgId !=null && orgId!=''){ 
var accId; 
var siteId=component.get('v.acct.Related_Account__c');
       //alert(siteId);
if(siteId=='') 
{ 
    alert(siteId);
accId=siteId; 
} 
else{ 
accId=component.get('v.subrecordId');
} 
var url ='/apex/OrganizationHierarchyTilesPageTree?OrgId='+orgId+'&AccId='+accId; 
window.open(url); 
} 

else{ 
alert('There is No Org associated'); 
}
      //  var recordId = component.get('v.oid');
       // var url =
    //   window.open('/apex/OrganizationHierarchyTilesPage?id=' + recordId,'_blank');
 }
})