import { LightningElement, wire,track} from 'lwc';
import cst from '@salesforce/apex/customItemToApproveController.cst';
//import getWrapperClassList from '@salesforce/apex/wrapperController.getWrapperClassList';
 
const columns = [
 { label: 'Action', fieldName: 'name' },
 { label: 'Request Type', fieldName: 'website', type: 'url' },
 { label: 'Related To', fieldName: 'phone', type: 'phone' },
 { label: 'Account #', fieldName: 'amount', type: 'currency' },
 { label: 'Account Name', fieldName: 'closeAt', type: 'date' },
 { label: 'Date Submitted', fieldName: 'closeAt', type: 'date' },
];
 
export default class Custom_Item_To_Approve extends LightningElement {
 data = [];
 sfdcBaseURL;
 columns = columns;
 @track hrefdata;

 redirectToReassign(event){

   let targetId = event.target.dataset.targetId;
  
    console.log(targetId);
   this.hrefdata=window.location.origin+"/"+targetId;

 }

 
    @wire(cst) items_to_approve;
 

}