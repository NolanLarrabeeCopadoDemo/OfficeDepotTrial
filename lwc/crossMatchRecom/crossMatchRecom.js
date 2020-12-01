import { LightningElement, api, track, wire } from 'lwc';
import getPendingRecommendations from '@salesforce/apex/ProcessRecommendations.getAllRecommendations';
import processRecommendations from '@salesforce/apex/ProcessRecommendations.processRecommendations';
import getControlRecordsByQuoteId from '@salesforce/apex/ItemCrossRef.getControlRecordsByQuoteId';

import {
    ShowToastEvent
} from 'lightning/platformShowToastEvent';
import { refreshApex } from '@salesforce/apex';

const actions = [
    { label: 'Approve', name: 'approve' },
    { label: 'Decline', name: 'decline' },
];

const recordId = '1';

const columns = [
    { label: 'Competitor Product Id',sortable: true, fieldName: 'competitor_product_id' },
    { label: 'Competitor Description',sortable: true, fieldName: 'competitor_description' },
    { label: 'Competitor UOM',sortable: true, fieldName: 'competitor_uom' },
    { label: 'Customer QPU',sortable: true, fieldName: 'customer_qpu' },
    { label: 'Competitor Usage',sortable: true, fieldName: 'competitor_usage'},
    { label: 'Competitor Price',sortable: true, fieldName: 'competitor_price'},
    { label: 'Type',sortable: true, fieldName: 'xref_type'},
    { label: 'OD Sku',sortable: true, fieldName: 'od_sku'},
    { label: 'OD Sku Description',sortable: true, fieldName: 'od_sku_description'},
    { label: 'OD Sku UOM',sortable: true, fieldName: 'od_sku_uom'},
    { label: 'OD Sku QPU',sortable: true, fieldName: 'od_sku_qpu'},
    { label: 'Modified By',sortable: true,fieldName: 'last_updated_id'},
    { label: 'Modified Date',sortable: true, fieldName: 'sys_modified_date'},
    { label: 'Approved',sortable: true, fieldName: 'status'},
    {
        type: 'action',
        typeAttributes: { rowActions: actions },
    },
];

export default class CrossMatchRecom extends LightningElement {
    @track columns = columns;
    @track recoms;
    @track sortBy;
    @track sortDirection;
    @track record = {};
    @track selectedTypeValue;
    @track SelectedRecordForUpdate = [];
    //@wire(getPendingRecommendations, {recordId})

    _wiredResult;

    @wire(getPendingRecommendations)
    recommendations({error, data}){
        if (error) {
            console.log(error);
        } else if (data) {
            this.recoms = JSON.parse(data);
            console.log('this.recoms' + JSON.stringify(this.recoms));
        }
    }

    refreshData() {
        return refreshApex(this._wiredResult);
    }

    getSelectedRecords(event)
    {
        const selectedRows = event.detail.selectedRows;
        console.log('selectedRecords set ====> ' +JSON.stringify(selectedRows));

        for (let row of selectedRows) {
            if(row.xref_type !== this.selectedTypeValue && row.xref_type !== '')
            {
                
            const id = row.recommendation_id;
            //row.xref_type = this.selectedTypeValue;
            const index = this.findRowIndexById(id);
            this.recoms[index] = row;
            this.recoms = [...this.recoms];

            }
        }

    }

    handleRowAction(event) {
        const actionName = event.detail.action.name;
        const row = event.detail.row;
        switch (actionName) {
            case 'approve':
                this.approve(row);
                break;
            case 'decline':
                this.decline(row);
                break;
            default:
        }
    }

    handlexRefTypeSelect(event) {
        const field = event.target.name;
        if (field === 'optionSelect') {
            this.selectedTypeValue = event.target.value;
            this.selectedOption = event.target.value;
            var el = this.template.querySelector('lightning-datatable');
            var selected = el.getSelectedRows();
            for (let row of selected) {
                const id = row.recommendation_id;
                row.xref_type = event.target.value;
                const index = this.findRowIndexById(id);
                this.recoms[index] = row;
                this.recoms = [...this.recoms];
            }
        } 
    }

    handleApproveButton() {
        var el = this.template.querySelector('lightning-datatable');
        var selected = el.getSelectedRows();
        for (let row of selected) {
            this.approve(row);
        }
    }

    handleDeclineButton() {
        var el = this.template.querySelector('lightning-datatable');
        var selected = el.getSelectedRows();
        for (let row of selected) {
            this.decline(row);
        }
    }

    async handleSave(event) {
        console.log('Save clicked');
        this.processRecoms();
        for (let row of this.recoms) {
            console.log(row.reference_id);
        }
    }

    approve(row) {
        const id = row.recommendation_id;
        row.status = 'Approved';
        const index = this.findRowIndexById(id);
        this.recoms[index] = row;
        this.SelectedRecordForUpdate = [];
        this.SelectedRecordForUpdate.push(this.recoms[index]);
        this.recoms = [...this.recoms];
    } 

    findRowIndexById(id) {
        let ret = -1;
        this.recoms.some((row, index) => {
            if (row.recommendation_id === id) {
                ret = index;
            }
        });
        return ret;
    }

    decline(row) {
        const id = row.recommendation_id;
        row.status = 'Declined';
        const index = this.findRowIndexById(id);
        this.recoms[index] = row;
        this.SelectedRecordForUpdate = [];
        this.SelectedRecordForUpdate.push(this.recoms[index]);
        this.recoms = [...this.recoms];
    }

    processRecoms() {
        console.log('Testing-->'+JSON.stringify(this.SelectedRecordForUpdate));
        processRecommendations({recommendations: JSON.stringify(this.SelectedRecordForUpdate)})
        .then(data => {
           console.log('New data' + data);
           this.recoms = JSON.parse(data);
        })
        .catch(error => {
            this.dispatchEvent(
                new ShowToastEvent({
                    title: 'Error!!',
                    message: error.message,
                    variant: 'error',
                }),
            );
        });
    }

    connectedCallback() {
        //const data = this.recoms;
        //this.recoms = data;
    }

    renderedCallback() {
        console.log('rendered this.data' + this.recoms);
    }

    handleSortdata(event) {
        // field name
        this.sortBy = event.detail.fieldName;

        // sort direction
        this.sortDirection = event.detail.sortDirection;

        // calling sortdata function to sort the data based on direction and selected field
        this.sortData(event.detail.fieldName, event.detail.sortDirection);
    }

    sortData(fieldname, direction) {
        // serialize the data before calling sort function
        console.log('Testing-->'+JSON.stringify(this.recoms));
        let parseData = JSON.parse(JSON.stringify(this.recoms));

        // Return the value stored in the field
        let keyValue = (a) => {
            return a[fieldname];
        };

        // cheking reverse direction 
        let isReverse = direction === 'asc' ? 1: -1;

        // sorting data 
        parseData.sort((x, y) => {
            x = keyValue(x) ? keyValue(x) : ''; // handling null values
            y = keyValue(y) ? keyValue(y) : '';

            // sorting values based on direction
            return isReverse * ((x > y) - (y > x));
        });

        // set the sorted data to data table data
        this.recoms = parseData;

    }
}