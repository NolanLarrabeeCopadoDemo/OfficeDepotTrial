({  

    doAction : function(cmp, event,helper) { 
        
        cmp.set('v.caseColumns', [
            {label: 'Case Number',initialWidth:'100px' ,fieldName: 'CaseNumber', type: 'text'},
            {label: 'Subject', initialWidth:'350px' ,fieldName: 'Subject', type: 'text'},
            {label: 'RecordTypeName',initialWidth:'100px' , fieldName: 'RecordtypeName__c', type: 'text'},
            {label: 'Status', initialWidth:'50px' ,fieldName: 'Status', type: 'text'},
            {label: 'Owner', initialWidth:'100px' ,fieldName: 'OwnerName', type: 'text'},
            {label: 'Date Opened',initialWidth:'200px' , fieldName: 'CreatedDate', type: 'date',typeAttributes: {
                    year: 'numeric',
                    month: '2-digit',
                 day: '2-digit'}},
             {label: 'Last Modified', initialWidth:'150px' ,fieldName: 'LastModifiedDate', type: 'date', typeAttributes: {
                    year: 'numeric',
                    month: '2-digit',
                 day: '2-digit'}},
            {label: 'Created By',initialWidth:'150px' , fieldName: 'IT_Created_By__c', type: 'text'}
            
        ]); 
       
            helper.loadCaseData(cmp,event);

        
    },
    showCases : function (cmp, event, helper) {
        cmp.set("v.showModel",true);
        cmp.set("v.showCaseInfo",true);      
    },
    closeModel : function (cmp, event, helper) {
        cmp.set("v.showModel",false);
        document.body.style.overflow = "auto";
    }
    
    
})