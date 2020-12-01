import { LightningElement, api, track, wire } from 'lwc';
import findAlternates from '@salesforce/apex/SkuProfile.findAlternates';
import getStockingStrategy from '@salesforce/apex/SkuProfile.getStockingStrategy';
import getCompPricing from '@salesforce/apex/SkuProfile.getCompPricing';
import searchBySku from '@salesforce/apex/SkuProfile.searchBySku';
import { refreshApex } from '@salesforce/apex';
import { loadScript, loadStyle } from 'lightning/platformResourceLoader';
import workbook from "@salesforce/resourceUrl/xlsx";

const skuColumns = [
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

const columns = [
    { label: 'OD Stock Number', fieldName: 'sku_num' },
    { label: 'Original Yield', fieldName: 'original_yield' },
    { label: 'General Alt Sku', fieldName: 'general_alt_sku' },
    { label: 'General Alt Sku Desc', fieldName: 'general_alt_sku_desc'},
    { label: 'General Alt Yield', fieldName: 'general_alt_yield' },
    { label: 'Gen Match Score', fieldName: 'general_matchscore'},
    { label: 'Pb Alt Sku', fieldName: 'pb_alt_sku'},
    { label: 'Pb Alt Sku Desc', fieldName: 'pb_alt_sku_desc'},
    { label: 'Pb Alt Yield', fieldName: 'pb_alt_yield'},
    { label: 'Pb Match Score', fieldName: 'pb_matchscore'},
    { label: 'Green Alt Sku', fieldName: 'green_alt_sku'},
    { label: 'Green Alt Sku Desc', fieldName: 'green_alt_sku_desc'},
    { label: 'Green Alt Yield', fieldName: 'green_alt_yield'},
    { label: 'Green Match Score', fieldName: 'green_matchscore'},
    { label: 'Hub Alt Sku', fieldName: 'hub_alt_sku'},
    { label: 'Hub Alt Item Desc', fielsName: 'hub_alt_sku_desc'},
    { label: 'Hub Alt Yield', fieldName: 'hub_alt_yield'},
    { label: 'Hub Match Score', fieldName: 'hub_matchscore'},
];

const stockingStregyColumns = [
    { label: 'Sku', fieldName: 'sku_num' },
    { label: 'Description', fieldName: 'item_desc' },
    { label: 'Disco Date', fieldName: 'discontinue_dt' },
    { label: 'Item Instock Desc', fieldName: 'item_instock_decision_desc' },
    { label: 'Stocking Strategy', fieldName: 'stocking_strategy_desc'},
    { label: 'Final Response', fieldName: 'contract_item_response_ind'},
    { label: 'Contract Comment', fieldName: 'contract_item_comment_txt'},
    { label: 'Dept Id', fieldName: 'item_department_id'},
    { label: 'Dept Name', fieldName: 'item_department_nm'},
    { label: 'Sku Type', fieldName: 'sku_type_cd'},
    { label: 'Web Availability', fieldName: 'web_availability_cd'},
    { label: 'Procurement Code', fieldName: 'procurement_method_cd'},
    { label: 'Avalilable for Delivery', fieldName: 'available_for_delivery_ind'},
    { label: 'Proprietary Code', fieldName: 'proprietory_ind'},
    { label: 'Virtual Flag', fieldName: 'virtual_ind'},
    { label: 'Wholesaler Flag', fieldName: 'sku_type_cd'},
    { label: 'Private Brand Flag', fieldName: 'whslr_ind'},
];

const compPricingColumns = [
    { label: 'Sku', fieldName: 'sku_num' },
    { label: 'Source', fieldName: 'source_ref' },
    { label: 'Pricing Extract Date', fieldName: 'price_extract_dt' },
    { label: 'Comp Product Id', fieldName: 'competitor_product_id' },
    { label: 'Competitor', fieldName: 'competitor_name'},
    { label: "Comp. Product Desc", fielsName: 'product_desc'},
    { label: 'Comp. Price', fieldName: 'price'},
    { label: 'Shipping', fieldName: 'shipping'},
    { label: 'Final Shipping Amt', fieldName: 'final_price_shipping_amt'},
    { label: 'Standard Pack Size Desc', fieldName: 'standard_pack_size_desc'},
    { label: 'Match Type Desc', fieldName: 'match_type_desc'}
];

export default class SkuDetails extends LightningElement {
    @track sku = {};
    @api sku_num = '';
    @track skuColumns = skuColumns;
    @track columns = columns;
    @track stockingStregyColumns = stockingStregyColumns;
    @track compPricingColumns = compPricingColumns;
    @track skuAlternateRecords = [];
    @track skuStockingStrategy = [];
    @track skuCompPricing = [];

    @track xlsHeader = new Array(4); // store all the headers of the the tables
    @track workSheetNameList = new Array(4) // store all the sheets name of the the tables
    @track xlsData = new Array(4); // store all tables data
    @track filename = "sku360_export.xlsx"; 

    librariesLoaded = false;

    // formating the data to send as input to  xlsxMain component
    xlsFormatter(index, data, sheetName) {
        let Header = [];
        if (data.length > 0) {
            Header = Object.keys(data[0]);
        }
        this.xlsHeader[index] = Header;
        this.workSheetNameList[index] = sheetName;
        this.xlsData[index] = data;
    }

    xlsDataFormatter(jsonData, columns) {
        let jsonDataNew = [];
        jsonData.forEach(row=>{
            let data = [];
            columns.forEach(column=> {
                let key = column.fieldName;
                let header = column.label;
                data[header] = data.key;
            })
            jsonDataNew.push(data);
        })
        jsonData = jsonDataNew;
    }

    @api download() {
        this.template.querySelector("c-sku-details-xl").download();
    }

    

    @api refresh(sku){
        //__showComponentLoader(this, '.pageLoader');
        this.skuAlternateRecords = []
        this.skuCompPricing = []
        this.skuStockingStrategy = []

        console.log("CCC" + sku.sku_num);
        this.sku = sku;
        searchBySku({sku_num: this.sku.sku})
        .then(data=> {
            console.log('Sku Details ' + data);
            let jsonData = JSON.parse(data);
            if (jsonData.length > 0) {
                this.sku = jsonData[0];
                this.xlsFormatter(0, jsonData, "Sku");
                this.xlsDataFormatter(jsonData, this.skuColumns);
            } else {
                this.xlsFormatter(0, [], 'Sku');
            }
        })
        //
        findAlternates({sku_num: this.sku.sku})
        .then(data => {
            console.log('Alternates ' + data);
            let jsonData = JSON.parse(data);
            if (jsonData.length > 0) {
                this.skuAlternateRecords = jsonData;
                this.xlsFormatter(1, this.skuAlternateRecords, "Alternates");
            } else {
                this.xlsFormatter(1, [], 'Alternates');
            }
        })
        .catch(error => {
            console.log(error);
            this.dispatchEvent(
                new ShowToastEvent({
                   title: 'Error!!',
                    message: error.message,
                    variant: 'error',
                }),
           );
        });
        //
        getStockingStrategy({sku_num: this.sku.sku})
        .then(data => {
            console.log('Stocking Strategy ' + data);
            let jsonData = JSON.parse(data);
            if (jsonData.length > 0) {
                this.skuStockingStrategy = jsonData;
                this.xlsFormatter(2, this.skuStockingStrategy, "Stocking Strategy");
            } else {
                this.xlsFormatter(2, [], 'Stocking Strategy');
            }
        })
        .catch(error => {
            console.log(error);
            this.dispatchEvent(
                new ShowToastEvent({
                   title: 'Error!!',
                    message: error.message,
                    variant: 'error',
                }),
           );
        });
        //
        getCompPricing({sku_num: this.sku.sku})
        .then(data => {
            console.log('Comp Pricing ' + data);
            let jsonData = JSON.parse(data);
            if (jsonData.length > 0) {
                this.skuCompPricing = jsonData;
                this.xlsFormatter(3, this.skuCompPricing, "Competitor Pricing");
            }  else {
                this.xlsFormatter(3, [], 'Competitor Pricing');
            }

        })
        .catch(error => {
            console.log(error);
            this.dispatchEvent(
                new ShowToastEvent({
                   title: 'Error!!',
                    message: error.message,
                    variant: 'error',
                }),
           );
        });                 
        //__hideComponentLoader(this, '.pageLoader');
    }

    connectedCallback() {
        let sku = {"sku" : this.sku_num, "sku.item_short_desc" : ""};
        this.refresh(sku);
    }

}