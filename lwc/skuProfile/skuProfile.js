import { LightningElement, api, track, wire } from 'lwc';
import searchBySku from '@salesforce/apex/SkuProfile.searchBySku';
import { refreshApex } from '@salesforce/apex';

const recordId = '1';

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
    { label: 'OD Stock Number', fieldName: 'sku' },
    { label: 'Description', fieldName: 'item_desc' },
    { label: 'Final Response', fieldName: 'contract_item_response_ind' },
    { label: 'Selling UOM', fieldName: 'package_units_of_measure' },
    { label: 'UOM QTY', fieldName: 'package_size'},
    { label: 'List Price', fieldName: 'list_price'},
    { label: 'Web Price', fieldName: 'web_price'},
    { label: 'OD TDC', fieldName: 'wtd_tdc_cost'},
    { label: 'UPC', fieldName: 'upc'},
    { label: 'Vendor Produc Cd', fieldName: 'vendor_product_number'},
    { label: 'Dept Id', fieldName: 'department'},
    { label: 'Dept Name', fieldName: 'department_name'},
];

export default class SkuProfile extends LightningElement {
    @track columns = columns;
    @track skuSearchRecords = {};
    @track searchCriteria = {
        "sku_num" : ""
    };
    sku_num = 999999;
    @track isLoading = false;


    searchBy(event) {
        if (this.SkuNum !== '') {
          this.SkuNum = event.target.value;
          console.log(this.SkuNum);
        }
    
      }

    refreshData() {
        return refreshApex(this._wiredResult);
    }


    handleSearch() {
       
        this.isLoading = true;

        this.searchCriteria.sku_num=this.SkuNum;      
        console.log('Inside-->'+this.SkuNum);

        this.skuSearchRecords = {};

        searchBySku({sku_num: this.searchCriteria.sku_num})
        .then(data => {
            console.log('Data ' + data);
            console.log('Sku Profile ' + JSON.parse(data));
            this.skuSearchRecords = JSON.parse(data);
            this.isLoading = false;
        })
        .catch(error => {
            console.log(error);
            this.isLoading = false;
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
        console.log('rendered this.data' + this.skuSearchRecords);
    }

    handleRowAction(event) {
        const row = event.detail.row;
        this.record = row;
        console.log(this.record);
        this.sku_num = this.record.sku;
        this.template.querySelector("c-sku-details").refresh(this.record);
    }

    download() {
        this.template.querySelector("c-sku-details").download();
    }

}