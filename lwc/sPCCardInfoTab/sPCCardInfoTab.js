import { LightningElement, api,track } from 'lwc';
import GetSPCCardInfoProcessService from '@salesforce/apex/GetSPCCardInfoProcessService.processMethod';
export default class SPCCardInfoTab extends LightningElement {
    @api recordId;
    @track errormessage = false;
    @api spccardinfoObj=[];
    connectedCallback() {
        this.handleCallOut();
    }  
    handleCallOut() {
        //alert(this.recordId);
           const params = {
             "recordId": this.recordId
          };   
    GetSPCCardInfoProcessService ({params})
   .then(result => {
    if(result!= null){
        this.spccardinfoObj=result.SPCCardInfoOutput.CardDetails;
    this.errormessage= false;
              }
              else {
    this.errormessage= true;
              }
           })
       }
    
}