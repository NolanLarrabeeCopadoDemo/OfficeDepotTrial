import { LightningElement, wire, track, api } from 'lwc';
import { getRecord  } from 'lightning/uiRecordApi';
import getLeads from '@salesforce/apex/RelatedLeads.getLeads';

// Declaring the columns in the datatable
const columns = [
    {
        label: 'View',
        type: 'button-icon',
        initialWidth: 75,
        typeAttributes: {
            iconName: 'action:preview',
            title: 'Preview',
            variant: 'border-filled',
            alternativeText: 'View'
        }
    },
    {
        label: 'Company',
        fieldName: 'Record_Page_Link__c',
        type: 'url',
        typeAttributes: { label: {fieldName: 'Company'}},
    },
    {
        label: 'Email',
        fieldName: 'Email'
    },
    {
        label: 'Phone',
        fieldName: 'Phone'
    }
];

const FIELDS = ['Lead.Master_Lead__c'];

// declare class to expose the component
export default class RelatedLeads extends LightningElement {
    @track columns = columns;
    @track record = {};
    @track rowOffset = 0;
    @track data = {};
    @track bShowModal = false;

    @api recordId;
    @api leadList; //Doesn't work without @api
    MasterLeadId;
    @track error;

    renderedCallback() {
        console.log('rendered');
        console.log(this.recordId);
    }

    @wire(getRecord, { recordId: '$recordId', fields: FIELDS })
    wiredRecord({ error, data }) {
        if (error) {
            let message = 'Unknown error';
            if (Array.isArray(error.body)) {
                message = error.body.map(e => e.message).join(', ');
            } else if (typeof error.body.message === 'string') {
                message = error.body.message;
            }
            console.log('Error: ' + message);
        } else if (data) {
            this.lead = data;
            console.log('record data : ' + JSON.stringify(data, null, 4));
            this.MasterLeadId = this.lead.fields.Master_Lead__c.value;
        }
    }

    @wire(getLeads, {recId: '$recordId' , masterLead: '$MasterLeadId' })
    getLeads({ error, data }) {
       if (data) {
           console.log('Data: ' + JSON.stringify(data, null, 4));
           this.leadList = data;
           this.error = undefined;
       } else if (error) {
           console.log('error: ' +  JSON.stringify(error, null, 4));
           this.error = error;
           this.leadList = undefined;
       }
    }

    // Row Action event to show the details of the record
    handleRowAction(event) {
        const row = event.detail.row;
        this.record = row;
        console.log("Row: " + JSON.stringify(row, null, 4));
        this.bShowModal = true; // display modal window
    }
 
    // to close modal window set 'bShowModal' tarck value as false
    closeModal() {
        this.bShowModal = false;
    }
}