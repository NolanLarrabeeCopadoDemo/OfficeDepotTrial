import { LightningElement,api,track } from 'lwc';
export default class ChildOrgInformation extends LightningElement {
    @api keyItem;
    @api valueItem;// = [{'Business_Name__c':'Office Depot, Inc.','City__c':'33496'},{'Business_Name__c':'Facebook','City__c':'94205'}];
    @track index;
    @track newlist =[];
    connectedCallback(){
        var orgs =  JSON.parse(JSON.stringify(this.valueItem));
        for(var i=0;i<orgs.length;i++){
            var each = orgs[i];
            if(i===0){
                each['Selected'] = true;
            }else{
                each['Selected'] = false;
            }
            
            orgs[i] = each;
        }
        
        this.newlist = orgs;
    }
    onCheckboxChange(event){        
        //console.log(this.template.querySelector('lightning-input').name);
        const fireSpinnerEvent = new CustomEvent('spinnerevent', {
            detail: true
        });
        this.dispatchEvent(fireSpinnerEvent);

        var index = event.target.name;
        var templist = JSON.parse(JSON.stringify(this.newlist));
        console.log(event.target.value);
        for(var i=0;i<templist.length;i++){
            templist[i]['Selected'] = false;
        }
        if(event.target.checked){
            //console.log(JSON.stringify(this.valueItem[i]));
            templist[index]['Selected'] = true;
            let v ={
                key: this.keyItem,
                data: templist[index]            
            };            
            const fireEvent = new CustomEvent('childeventhandler', {
                detail: v
            });
           this.dispatchEvent(fireEvent);
        } 
        this.newlist = templist; 
       

        const fireSpinnerEvent2 = new CustomEvent('spinnerevent', {
         detail: false
        });
        this.dispatchEvent(fireSpinnerEvent2);

    }
}