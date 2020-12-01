import { LightningElement,track,wire,api } from 'lwc';
// Import apex methods
import getAccessAllowed from '@salesforce/apex/ProspectReassignmentController.getAccessAllowed'; 
// Import custom labels
import reportlink from '@salesforce/label/c.ProspectReassignAdminReport';
export default class ProspectReassignment extends LightningElement {
    @track pageAccess = false;
    @track adminAccess = false;
    // Expose the labels to use in the template.
    label = {
        reportlink
    };

    @wire(getAccessAllowed)
    wiredGetAccess({ error, data }) {      
        if (data) { 
            this.pageAccess = data.pageAccess;
            this.adminAccess = data.adminAccess;
        }
        else if (error) { 

        }   
    }

    
}