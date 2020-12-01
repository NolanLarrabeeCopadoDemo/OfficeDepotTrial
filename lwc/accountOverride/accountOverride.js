import { LightningElement,api,track,wire } from 'lwc';
import getRecordTypeData from '@salesforce/apex/AccountOverrideController.getRecordTypeData';
import { NavigationMixin } from 'lightning/navigation';
export default class AccountOverride extends NavigationMixin(LightningElement) {
    @api recordid;
    areDetailsVisible=false;
    recordTypeId='';
    recordTypeName = '';
    @track value = '';
    options = [];
    action = '';
    showSpinner = false;

    @wire(getRecordTypeData)
    wiredRecordTypeData({ error, data }) {
        this.showSpinner = true;     
        if (data) {      
            //alert('=>',this.recordid);     
            if(this.recordid){
                this.action = 'Edit Account: ';
                this.showSpinner = false;  
                this.areDetailsVisible=true;
            }else{
                this.action = 'New Account: '+this.recordTypeName;
                this.areDetailsVisible= false;
                if(data.shouldRedirect){
                    debugger;
                    //Prospect Creation flow
                    //let flowUrl = window.location.protocol + '//' + window.location.hostname + '/flow/Prospect_Creation_2?flowLayout=twoColumn';
                    // window.location.replace(flowUrl);
                    if(data.redirectPage){
                        let flowUrl = window.location.protocol + '//' + window.location.hostname + '/apex/' +data.redirectPage;
                        window.location.replace(flowUrl)

                        /*let flowUrl = window.location.protocol + '//' + window.location.hostname + '/flow/Prospect_Creation_2?flowLayout=twoColumn';
                        component.find("navigationService").navigate({
                            type: "standard__webPage",
                            attributes: {
                                url: flowUrl
                            }
                        });*/
                    }else{
                        const flowLaunchEvent = new CustomEvent('flowLaunch');
                        this.dispatchEvent(flowLaunchEvent);
                    }
                    
                }
                let record = [];
                if(data.recordTypes.length > 0){
                    for(let i=0;i<data.recordTypes.length;i++){
                        record.push({ label: data.recordTypes[i].label, value: data.recordTypes[i].Id });
                    }
                    this.options = record;
                    console.log(this.options);
                    this.showSpinner = false;                 
                }
            }
            
            if(this.template.querySelector("section")){
                if(!data.shouldRedirect || this.recordid){
                    this.template.querySelector("section").classList.remove("slds-hide");
                    if(this.template.querySelector("div.modalBackdrops")){
                        this.template.querySelector("div.modalBackdrops").classList.remove("slds-hide");
                    }
                }
            }else{
                location.reload();
            }
           
        }
        else if (error) { 
            this.showSpinner = false;
        }   
    }
    
    connectedCallback() {

    }

    disconnectedCallback() {
        //window.removeEventListener('test', this.handleTest);
        this.areDetailsVisible=false;
        this.recordTypeId='';
        this.recordTypeName = '';
        this.value = '';
        this.options = [];
    }

    handleChange(event){
        this.recordTypeId = event.detail.value;
        let data = this.options;
        let type='';
        for(let i=0;i<data.length;i++){
            if(data[i].value === this.recordTypeId){
                type = data[i].label;
                break;
            }
        } 
        this.recordTypeName=type;
    }
    
    handleNext(){
        let recType = (this.recordTypeName).toLocaleLowerCase();
        if(recType){
            if(recType === 'prospect'){
                // this.template.querySelector("div.modalBackdrops").classList.add("slds-hide");
                // this.template.querySelector("section").classList.add("slds-hide");
                // let flowUrl = window.location.protocol + '//' + window.location.hostname + '/flow/Prospect_Creation_2?flowLayout=twoColumn';
                // window.alert(flowUrl);
                // window.location.replace(flowUrl);
                const flowLaunchEvent = new CustomEvent('flowLaunch');
                // Fire the custom event
                this.dispatchEvent(flowLaunchEvent);
            }
            if(recType === 'parent'){
                let flowUrl = `${window.location.protocol}//${window.location.hostname}/flow/Parent_Account_Info?flowLayout=oneColumn`;
                window.location.replace(flowUrl)
                //const flowLaunchEvent = new CustomEvent('flowLaunch');
                // Fire the custom event
                //this.dispatchEvent(flowLaunchEvent);
            }
            else{
                this.action = 'New Account: '+this.recordTypeName;
                this.areDetailsVisible=true;
            } 
        }              
    }

    handleSuccess(event) {
       // alert(event.detail.id);
    }

    handleClick(event){
        this.template.querySelector("section").classList.add("slds-hide");
        this.template.querySelector("div.modalBackdrops").classList.add("slds-hide");
        this.navigateToListView();
    }

    navigateToListView() {
        // Navigate to the Account object's Recent list view.
        this[NavigationMixin.Navigate]({
            type: 'standard__objectPage',
            attributes: {
                objectApiName: 'Account',
                actionName: 'list'
            },
            state: {
                // 'filterName' is a property on the page 'state'
                // and identifies the target list view.
                // It may also be an 18 character list view id.
                filterName: 'Recent' // or by 18 char '00BT0000002TONQMA4'
            }
        });
    }

}