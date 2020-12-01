({  

    doAction : function(cmp, event,helper) {  
        
          cmp.set('v.NoteColumns', [
            {label: 'Title', fieldName: 'Title', type: 'text'}

        ]);
            helper.loadNoteData(cmp,event);        
    },
    showNote : function (cmp, event, helper) {
        cmp.set("v.showModel",true);
        cmp.set("v.showNoteInfo",true);      
    },
    closeModel : function (cmp, event, helper) {
        cmp.set("v.showModel",false);
        document.body.style.overflow = "auto";
    }
    
    
})