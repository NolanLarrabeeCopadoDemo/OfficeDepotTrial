import { LightningElement, api, track } from 'lwc';

export default class Prospect_creation_display_orgs extends LightningElement {
    @track showTable = false;
    @track showNoOrgsMessage = true;
    @track keyField;
    @track _matchingOrgs;
    @track defaultSelected;

    @api selectedOrg;

    @api
    get matchingOrgs() {
        return this._matchingOrgs;
    }
    set matchingOrgs(val) {
        if(val.length > 0 && val[0].Id && val[0].Id !== '') {
            this.keyField = 'Id';
        } else {
            this.keyField = 'D_B_ID__c';
        }
        if(val.length > 0) {
            this.showNoOrgsMessage = false;
            this.showTable = true;
            this.defaultSelected = [val[0].Id];
            this.selectedOrg = val[0];
        }
        this._matchingOrgs = val;
    }

    @track cols = [
        { label: 'Org Name', fieldName: 'Business_Name__c', type: 'text' },
        { label: 'Street', fieldName: 'Address_1__c', type: 'text' },
        { label: 'City', fieldName: 'City__c', type: 'text' },
        { label: 'State', fieldName: 'State__c', type: 'text' },
        { label: 'Web Site', fieldName: 'Website__c', type: 'text' },
        { label: 'Line of Business', fieldName: 'LOB__c', type: 'text' },
        { label: 'DUNS Number', fieldName: 'D_B_ID__c', type: 'text' }
    ];

    rowSelected(event) {
        const selectedRows = event.detail.selectedRows;

        this.selectedOrg = selectedRows[0];
    }
}