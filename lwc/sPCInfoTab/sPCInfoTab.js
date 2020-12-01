import { LightningElement, api,track } from 'lwc';
import GetSPCCardInfoProcessService from '@salesforce/apex/GetSPCCardInfoProcessService.processMethod';
import SendEmailMessage from '@salesforce/apex/GetSPCCardInfoProcessService.SendEmailMessage';
export default class SPCInfoTab extends LightningElement {
    @api recordId;
    @track articleTwo = true;
@track input1;
@track emailsent=false;
    @track errormessage = false;
    @api spccardinfoObj=[];
    connectedCallback() {

        this.handleCallOut();
    }  
    sectionTwo() {
        if(this.articleTwo===false){
        this.articleTwo=true;
        }
        else{
            this.articleTwo=false;   
        }
    }
    handleCallOut() {
        //alert(this.recordId);
           const params = {
             "recordId": this.recordId
          };   
    GetSPCCardInfoProcessService ({params})
   .then(result => {
    if(result!= null){
        //console.log(result);
        this.spccardinfoObj=result;
    this.errormessage= false;
              }
              else {
    //this.errormessage= true;
              }
           })
       }
       handleEmailCallout() {
        //alert(this.recordId);
       // console.log(this.spccardinfoObj);
        SendEmailMessage ({spclist: this.spccardinfoObj,emailString:this.input1})
   .then(result => {
    if(result!= null){
       //console.log(result);
       this.emailsent=true;
    
              }
            
           })
       }
       changeHandler(event) {
        // alert(event.target.value);
        if (event.target.name === 'input1') {
            this.input1 = event.target.value;
        }
    }
    

}