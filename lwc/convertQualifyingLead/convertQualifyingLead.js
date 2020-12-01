import { LightningElement,api, track } from 'lwc';
import convertQualifyingLead from '@salesforce/apex/QualifyingLeadController.convertQualifyingLead';
export default class ConvertQualifyingLead extends LightningElement {
    @api Id = '';
    @track data;
    @track showSpinner = true; 
    @track oppUrl = '';
    @track url = '';
    
    connectedCallback(){
        this.url = window.location.origin;
        convertQualifyingLead({LeadId:this.Id})
        .then(result => {
            this.data = result;
            this.showSpinner = false;
            if(result.Id !== ''){
                this.oppUrl =  this.url+'/'+result.Id;
                // eslint-disable-next-line no-alert
                window.open(this.oppUrl,'_self');
            }else{
                // eslint-disable-next-line no-alert
                alert('ERROR:'+result.Status);
                window.open(this.url =  this.url+'/'+this.Id,'_self');
            }
            
        })
        .catch(error => {
            this.error = error;
            this.showSpinner = false;
            // eslint-disable-next-line no-alert
            alert('Something went wrong.');
            window.open(this.url =  this.url+'/'+this.Id,'_self');
        });
    }
}