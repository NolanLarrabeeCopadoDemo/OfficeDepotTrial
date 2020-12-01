/* eslint-disable default-case */
/* eslint-disable @lwc/lwc/no-async-operation */
/* eslint-disable radix */
/* eslint-disable no-alert */
/* eslint-disable no-undef */
/* eslint-disable no-irregular-whitespace */
/* eslint-disable vars-on-top */
/* eslint-disable guard-for-in */
/* eslint-disable no-console */
import { LightningElement, track, api } from 'lwc';
import WebCollectCallout from '@salesforce/apex/WebCollectRestRequest.WebCollectCallout';
export default class WebCollectTab extends LightningElement {
@api recordId;
@track errormessage = true;
@track errorMessageContent='';
@track cssDisplay = 'hidemodel';

   @track resultObj={};
   connectedCallback() {
      this.cssDisplay = ''; 
      this.handleCallOut();
   }  
   handleCallOut() {
    //alert(this.recordId);
       const params = {
         "recordId": this.recordId
      };        
      WebCollectCallout({params})
          .then(result => {
              if(result!= null && result.StatusCode===200){
               this.errormessage= false;
                  console.log(result);
                 this.resultObj=result;
                 console.log(this.resultObj.cus_coll_email);
                 this.cssDisplay = 'hidemodel';
              }
              else {
               this.errormessage= true;
               this.errorMessageContent=result.ErrorMessage;
               this.cssDisplay = 'hidemodel';
              }
           })
       }

}