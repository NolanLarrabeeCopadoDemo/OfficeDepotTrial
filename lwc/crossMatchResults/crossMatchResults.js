import {
    LightningElement,
    api,
    track,
    wire
} from 'lwc';
import {
    ShowToastEvent
} from 'lightning/platformShowToastEvent';
import {
    NavigationMixin
} from 'lightning/navigation';
import {
    updateRecord
} from 'lightning/uiRecordApi';
import {
    refreshApex
} from '@salesforce/apex';
import getAllResults from '@salesforce/apex/RetrieveCrossMatchResults.getJSONData';
import addRecc from '@salesforce/apex/RetrieveCrossMatchResults.addRecommendations';
import updateRecc from '@salesforce/apex/RetrieveCrossMatchResults.updateRecommendations';
import getStatusForFile from '@salesforce/apex/RetrieveCrossMatchResults.getStatus';
import getHitRate from '@salesforce/apex/RetrieveCrossMatchResults.getHitRateData';
import getAuthToken from '@salesforce/apex/CrossRefGetAccessToken.getAccessToken';
import { loadScript, loadStyle } from 'lightning/platformResourceLoader';
import myResource from '@salesforce/resourceUrl/rowRemovalCSS';
import workbook from "@salesforce/resourceUrl/xlsx";
import getNetCostVisibility from '@salesforce/apex/RetrieveCrossMatchResults.getNetCostVisibilityFlag';
import getFilteredRecordsData from '@salesforce/apex/RetrieveCrossMatchResults.getFilteredRecordsData';


const actions = [{
    label: 'Edit',
    name: 'edit'
}, ];

const columns = [
    
    {
        label: 'RowNumber',
        initialWidth: 100,
        fieldName: 'stg_rownum',
        type: 'number',
        sortable: "true",
        cellAttributes: {
            alignment: 'left'
        }
    },

    {
        label: 'ReferenceId',
        initialWidth: 100,
        fieldName: 'reference_id',
        type: 'number',
        sortable: "true",
        cellAttributes: {
            alignment: 'left'
        }
    },
    {
        label: 'COMPETITOR_PRODUCT_ID',
        fieldName: 'competitor_product_id',
        initialWidth: 200,
        type: 'string',
        sortable: "true",
        wrapText: true,
        cellAttributes: {
            alignment: 'left'
        }
    },
    {
        label: 'COMPETITOR_DESCRIPTION',
        initialWidth: 200,
        fieldName: 'competitor_description',
        type: 'string',
        sortable: true,
        cellAttributes: {
            alignment: 'left'
        }
    },
    {
        label: 'ORIG_COMPETITOR_UOM',
        initialWidth: 200,
        fieldName: 'orig_competitor_uom',
        type: 'string',
        sortable: true,
        cellAttributes: {
            alignment: 'left'
        }
    },
    {
        label: 'ORIG_CUSTOMER_QPU',
        initialWidth: 200,
        fieldName: 'orig_customer_qpu',
        type: 'string',
        sortable: true,
        cellAttributes: {
            alignment: 'left'
        }
    },
    {
        label: 'COMPETITOR_UOM',
        initialWidth: 200,
        fieldName: 'competitor_uom',
        type: 'string',
        sortable: true,
        cellAttributes: {
            alignment: 'left'
        },
        editable: true
    },
    //{ label: 'Results', fieldName: 'results', type: 'url', sortable: true, cellAttributes: { alignment: 'left' }},
    {
        label: 'CUSTOMER_QPU',
        initialWidth: 200,
        fieldName: 'customer_qpu',
        type: 'string',
        sortable: true,
        cellAttributes: {
            alignment: 'left'
        },
        editable: true
    },
    {
        label: 'CUSTOMER_USAGE',
        initialWidth: 200,
        fieldName: 'customer_usage',
        type: 'number',
        sortable: true,
        cellAttributes: {
            alignment: 'left'
        }
    },
    {
        label: 'COMPETITOR_PRICE',
        initialWidth: 200,
        fieldName: 'competitor_price',
        type: 'number',
        sortable: true,
        cellAttributes: {
            alignment: 'left'
        }
    },
    /*{
        label: 'XREF_NOTES',
        fieldName: 'xref_notes',
        type: 'string',
        sortable: true,
        cellAttributes: {
            alignment: 'left'
        }
    },*/
    {
        label: 'COMPETITOR_SOURCE',
        initialWidth: 200,
        fieldName: 'competitor_source',
        type: "string",
        sortable: true,
        cellAttributes: {
            alignment: 'left'
        }
    },
    {
        label: 'XREF_TYPE',
        initialWidth: 200,
        fieldName: 'xref_type',
        type: "string",
        sortable: true,
        cellAttributes: {
            alignment: 'left'
        }
    },
    {
        label: 'OD_SKU',
        initialWidth: 200,
        fieldName: 'od_sku',
        type: "string",
        sortable: true,
        cellAttributes: {
            alignment: 'left'
        }
    },
    {
        label: 'OD_SKU_DESCRIPTION',
        initialWidth: 200,
        fieldName: 'od_sku_description',
        type: "string",
        sortable: true,
        cellAttributes: {
            alignment: 'left'
        }
    },
    {
        label: 'OD_SKU_UOM',
        initialWidth: 200,
        fieldName: 'od_sku_uom',
        type: "string",
        sortable: true,
        cellAttributes: {
            alignment: 'left'
        },
        editable: true
    },
    //changed od_sku_qpu from string to number as it is causing error while updating. Also removed str conversion in the update endpoint.
    {
        label: 'OD_SKU_QPU',
        initialWidth: 200,
        fieldName: 'od_sku_qpu',
        type: "number",
        sortable: true,
        cellAttributes: {
            alignment: 'left'
        },
        editable: true
    },
    {
        label: 'Dept Code',
        initialWidth: 200,
        fieldName: 'department_code',
        type: "number",
        sortable: "true",
        cellAttributes: {
            alignment: 'left'
        },
    },
    {
        label: 'Dept Name',
        initialWidth: 200,
        fieldName: 'department_name',
        type: "string",
        sortable: "true",
        cellAttributes: {
            alignment: 'left'
        },
    },
    {
        label: 'OD_SKU_VPN',
        initialWidth: 200,
        fieldName: 'od_sku_vpn',
        type: "string",
        sortable: true,
        cellAttributes: {
            alignment: 'left'
        }
    },
    {
        label: 'Vendor Source',
        initialWidth: 200,
        fieldName: 'vendor_source',
        type: "string",
        sortable: true,
        cellAttributes: {
            alignment: 'left'
        }
    },

    {
        label: 'UOM Multiplier',
        initialWidth: 200,
        fieldName: 'uom_multiplier',
        type: "number",
        sortable: true,
        default:0,
        cellAttributes: {
            alignment: 'left'
        }
    },
   /* {
        label: 'OD_SKU_MFG',
        fieldName: 'od_sku_mfg',
        type: "string",
        sortable: true,
        cellAttributes: {
            alignment: 'left'
        }
    },*/
    {
        label: 'Wtd Net Cost',
        initialWidth: 200,
        fieldName: 'wtd_net_cost',
        type: "number",
        sortable: "true",
        cellAttributes: {
            alignment: 'left'
        },
    },
    {
        label: 'Wtd Tdc Cost',
        initialWidth: 200,
        fieldName: 'wtd_tdc_cost',
        type: "number",
        sortable: "true",
        cellAttributes: {
            alignment: 'left'
        },
    },
    {
        label: 'Converted Cost',
        initialWidth: 200,
        fieldName: 'converted_cost',
        type: "number",
        sortable: "true",
        cellAttributes: {
            alignment: 'left'
        },
    },
    {
        label: 'Sku Availability Flag',
        initialWidth: 200,
        fieldName: 'sku_availability_flag',
        type: "string",
        sortable: "true",
        cellAttributes: {
            alignment: 'left'
        },
    },
    {
        label: 'Sku Availability Flag Reason',
        initialWidth: 200,
        fieldName: 'sku_availability_flag_reason',
        type: "string",
        sortable: "true",
        cellAttributes: {
            alignment: 'left'
        },
    },
    {
        label: 'Stocking Strategy',
        initialWidth: 200,
        fieldName: 'stocking_strategy',
        type: "string",
        sortable: "true",
        cellAttributes: {
            alignment: 'left'
        },
    },
    {
        label: 'Recommendations',
        initialWidth: 200,
        fieldName: 'recommendations',
        type: "string",
        sortable: "true",
        cellAttributes: {
            alignment: 'left'
        },
        editable: true
    },
    {   
        initialWidth: 50,
    }

];

const columns1 = [
    
    {
        label: 'RowNumber',
        initialWidth: 100,
        fieldName: 'stg_rownum',
        type: 'number',
        sortable: "true",
        cellAttributes: {
            alignment: 'left'
        }
    },

    {
        label: 'ReferenceId',
        initialWidth: 100,
        fieldName: 'reference_id',
        type: 'number',
        sortable: "true",
        cellAttributes: {
            alignment: 'left'
        }
    },
    {
        label: 'COMPETITOR_PRODUCT_ID',
        initialWidth: 200,
        fieldName: 'competitor_product_id',
        type: 'string',
        sortable: "true",
        wrapText: true,
        cellAttributes: {
            alignment: 'left'
        }
    },
    {
        label: 'COMPETITOR_DESCRIPTION',
        initialWidth: 200,
        fieldName: 'competitor_description',
        type: 'string',
        sortable: true,
        cellAttributes: {
            alignment: 'left'
        }
    },
    {
        label: 'ORIG_COMPETITOR_UOM',
        initialWidth: 200,
        fieldName: 'orig_competitor_uom',
        type: 'string',
        sortable: true,
        cellAttributes: {
            alignment: 'left'
        }
    },
    {
        label: 'ORIG_CUSTOMER_QPU',
        initialWidth: 200,
        fieldName: 'orig_customer_qpu',
        type: 'string',
        sortable: true,
        cellAttributes: {
            alignment: 'left'
        }
    },
    {
        label: 'COMPETITOR_UOM',
        initialWidth: 200,
        fieldName: 'competitor_uom',
        type: 'string',
        sortable: true,
        cellAttributes: {
            alignment: 'left'
        },
        editable: true
    },
    //{ label: 'Results', fieldName: 'results', type: 'url', sortable: true, cellAttributes: { alignment: 'left' }},
    {
        label: 'CUSTOMER_QPU',
        initialWidth: 200,
        fieldName: 'customer_qpu',
        type: 'number',
        sortable: true,
        cellAttributes: {
            alignment: 'left'
        },
        editable: true
    },
    {
        label: 'CUSTOMER_USAGE',
        initialWidth: 200,
        fieldName: 'customer_usage',
        type: 'number',
        sortable: true,
        cellAttributes: {
            alignment: 'left'
        }
    },
    {
        label: 'COMPETITOR_PRICE',
        initialWidth: 200,
        fieldName: 'competitor_price',
        type: 'number',
        sortable: true,
        cellAttributes: {
            alignment: 'left'
        }
    },
    /*{
        label: 'XREF_NOTES',
        fieldName: 'xref_notes',
        type: 'string',
        sortable: true,
        cellAttributes: {
            alignment: 'left'
        }
    },*/
    {
        label: 'COMPETITOR_SOURCE',
        initialWidth: 200,
        fieldName: 'competitor_source',
        type: "string",
        sortable: true,
        cellAttributes: {
            alignment: 'left'
        }
    },
    {
        label: 'XREF_TYPE',
        initialWidth: 200,
        fieldName: 'xref_type',
        type: "string",
        sortable: true,
        cellAttributes: {
            alignment: 'left'
        }
    },
    {
        label: 'OD_SKU',
        initialWidth: 200,
        fieldName: 'od_sku',
        type: "string",
        sortable: true,
        cellAttributes: {
            alignment: 'left'
        }
    },
    {
        label: 'OD_SKU_DESCRIPTION',
        initialWidth: 200,
        fieldName: 'od_sku_description',
        type: "string",
        sortable: true,
        cellAttributes: {
            alignment: 'left'
        }
    },
    {
        label: 'OD_SKU_UOM',
        initialWidth: 200,
        fieldName: 'od_sku_uom',
        type: "string",
        sortable: true,
        cellAttributes: {
            alignment: 'left'
        },
        editable: true
    },
    {
        label: 'OD_SKU_QPU',
        initialWidth: 200,
        fieldName: 'od_sku_qpu',
        type: "number",
        sortable: true,
        cellAttributes: {
            alignment: 'left'
        },
        editable: true
    },
    {
        label: 'Dept Code',
        initialWidth: 200,
        fieldName: 'department_code',
        type: "number",
        sortable: "true",
        cellAttributes: {
            alignment: 'left'
        },
    },
    {
        label: 'Dept Name',
        initialWidth: 200,
        fieldName: 'department_name',
        type: "string",
        sortable: "true",
        cellAttributes: {
            alignment: 'left'
        },
    },
    {
        label: 'OD_SKU_VPN',
        initialWidth: 200,
        fieldName: 'od_sku_vpn',
        type: "string",
        sortable: true,
        cellAttributes: {
            alignment: 'left'
        }
    },
    {
        label: 'Vendor Source',
        initialWidth: 200,
        fieldName: 'vendor_source',
        type: "string",
        sortable: true,
        cellAttributes: {
            alignment: 'left'
        }
    },

    {
        label: 'UOM Multiplier',
        initialWidth: 200,
        fieldName: 'uom_multiplier',
        type: "number",
        sortable: true,
        default:0,
        cellAttributes: {
            alignment: 'left'
        }
    },
   /* {
        label: 'OD_SKU_MFG',
        fieldName: 'od_sku_mfg',
        type: "string",
        sortable: true,
        cellAttributes: {
            alignment: 'left'
        }
    },*/
    
    {
        label: 'Wtd Tdc Cost',
        initialWidth: 200,
        fieldName: 'wtd_tdc_cost',
        type: "number",
        sortable: "true",
        cellAttributes: {
            alignment: 'left'
        },
    },
    {
        label: 'Converted Cost',
        initialWidth: 200,
        fieldName: 'converted_cost',
        type: "number",
        sortable: "true",
        cellAttributes: {
            alignment: 'left'
        },
    },
    {
        label: 'Sku Availability Flag',
        initialWidth: 200,
        fieldName: 'sku_availability_flag',
        type: "string",
        sortable: "true",
        cellAttributes: {
            alignment: 'left'
        },
    },
    {
        label: 'Sku Availability Flag Reason',
        initialWidth: 200,
        fieldName: 'sku_availability_flag_reason',
        type: "string",
        sortable: "true",
        cellAttributes: {
            alignment: 'left'
        },
    },
    {
        label: 'Stocking Strategy',
        initialWidth: 200,
        fieldName: 'stocking_strategy',
        type: "string",
        sortable: "true",
        cellAttributes: {
            alignment: 'left'
        },
    },
    {
        label: 'Recommendations',
        initialWidth: 200,
        fieldName: 'recommendations',
        type: "string",
        sortable: "true",
        cellAttributes: {
            alignment: 'left'
        },
        editable: true
    },

];


const errorColumns = [{
        label: 'Reference_Id',
        fieldName: 'reference_id',
        type: 'number',
        sortable: "true",
        cellAttributes: {
            alignment: 'left'
        }
    },
    {
        label: 'Status',
        fieldName: 'status',
        type: 'string',
        sortable: "true",
        cellAttributes: {
            alignment: 'left'
        }
    },
    {
        label: 'Error Message',
        fieldName: 'message',
        type: "string",
        sortable: "true",
        cellAttributes: {
            alignment: 'left'
        }
    },
];

/*const requestApprovalColumns = [
{ label: 'Competitor Product Sku',fieldName:'COMPETITOR_PRODUCT_ID', type: 'string', sortable: true, cellAttributes: { alignment: 'left' }},
{ label: 'OD Sku',fieldName:'OD_SKU', type: 'string', sortable: true, cellAttributes: { alignment: 'left' }},
{ label: 'Cross Match Type',fieldName:'CrossMatch', type: "string",cellAttributes: { alignment: 'left' }},
{ label: 'Recommendation',fieldName:'Recommendation', type: "text",cellAttributes: { alignment: 'left' },editable:true},

];

const submitForApprovalColumns = [
{ label: 'Competitor Product Sku',fieldName:'COMPETITOR_PRODUCT_ID', type: 'string', sortable: true, cellAttributes: { alignment: 'left' }},
{ label: 'OD Sku',fieldName:'OD_SKU', type: 'string', sortable: true, cellAttributes: { alignment: 'left' }},
{ label: 'Approval',fieldName:'Approval', type: "checkbox",cellAttributes: { alignment: 'left'},editable:true},
{ label: 'Disapprove',fieldName:'Disapprove', type: "checkbox",cellAttributes: { alignment: 'left' },editable:true},

];*/



export default class CrossMatchResults extends LightningElement {

@track spring20Logo = myResource;
librariesLoaded = false;
renderedCallback() {
    if (this.librariesLoaded) return;
    this.librariesLoaded = true;
    Promise.all([
        loadStyle(this, myResource),
    ])
        .then(() => {
        })
        .catch(error => {
            alert(error.body.message);
        });

        
        Promise.all([loadScript(this, workbook + "/xlsx/filexlsx.full.min.js")])
      .then(() => {
        console.log("success");
      })
      .catch(error => {
        console.log("failure");
      });
}




    @api refID;
    @api fileName;
    @track pageNum;
    @track pageType;
    @track columns = columns;
    //@track columns1 = columns1;
    @track errorColumns = errorColumns;
    @track sortBy;
    @track sortDirection;
    @track accessToken;
    @track DataForDownload = [];
    @track DataForDownloadAll = [];

    //@track submitForApprovalColumns = submitForApprovalColumns;
    @track requestApprovalScreen = false;
    @track requestDraftValues = [];
    @track numberColumn = false;
    @track draftValues = [];
    @track submitDraftValues = []
    @track ResultScreen = true;
    @track submitApprovalScreen = false;
    @track sentforapprovaldata = [];
    @track approvalData = [];
    @track totalRowCounts;
    @track data = [];
    @track ToastToBeDisplayed = false;
    @track MessageToBeDisplayed;
    @track autoCloseTime = 5000;
    @track hrefdata;
    @track hrefdata1;
    @track statusReceived = '';
    @track dataLoaded = false;
    @track NoErrors = true;
    @track errorData = [];
    @track createdTimeStamp;
    @track currentPage;
    @track isPreviousAvailable = false;
    @track isNextAvailable = false;
    @track noOfMatches = 0;
    @track noOfNoMatches = 0;
    @track hitRate = 0;
    @track dataFromFetch = [];
    @track filteredList = [];
    @track netCostVisibilityFlag = false;
    @track isALLSelected = true;
    @track selectedFilter;
    @track filterApplied = false;


    connectedCallback() {
        this.getNetCostVisibility();
        this.totalRowCounts = this.data.totalRowCount;
        this.getStatus();


    }


    getNetCostVisibility() {

        getNetCostVisibility()
            .then(result => {
                this.netCostVisibilityFlag = result;
                if(this.netCostVisibilityFlag === true)
                    this.columns = columns;
                else
                    this.columns = columns1;    
                //alert(this.netCostVisibilityFlag);           
                });
            
            
    }

    getStatus() {

        getStatusForFile({
                referenceId: this.refID
            })
            .then(result => {
                this.statusReceived = result;
                console.log('this.status-->'+this.statusReceived);
                if (this.statusReceived !== null) {
                    this.NoErrors = false;
                    this.errorData = result;
                    this.dataLoaded = true;

                } else {
                    getAllResults({
                            Reference_Id: this.refID,
                            PageNumber: 0,
                            Page: 'FirstPage'
                        })
                        .then(result => {
                            this.data = result;
                            this.pageNum = 0
                            this.pageType = 'FirstPage'
                            this.filteredList = result;
                            this.dataLoaded = true;
                            this.currentPage = 0;
                            this.createdTimeStamp = this.data[0]['sys_created_date'];
                            this.calculateUOM();
                            getHitRate({
                                Reference_Id: this.refID
                            })
                            .then(result => {
                               this.hitRate  = result[0].hitrate;
                               this.noOfMatches = result[0].noOfMatches;
                               this.noOfNoMatches = result[0].noOfNoMatches;
                               
                               
                            this.selectedFilter = 'All';
                            this.getAuthTokenMethod()

                            })
                            .catch(error => {
                                console.log('error-->' + JSON.stringify(error));
    
                            });
                             
                        })
                        .catch(error => {
                            console.log('error-->' + JSON.stringify(error));

                        });

                }
            })
            .catch(error => {
                console.log('error-->' + JSON.stringify(error));

            });
    }

    calculateUOM()
    {
        let testList = [];
        testList = JSON.parse(JSON.stringify(this.data));
        for(let i = 0;i<testList.length;i++)
        {
            
            let uomMultiplier = 0;
            let convertedCost = 0;
            uomMultiplier = testList[i].customer_qpu / testList[i].od_sku_qpu;
            
            if(isFinite(uomMultiplier))
                testList[i]['uom_multiplier'] = uomMultiplier.toFixed(3);
            else
                testList[i]['uom_multiplier'] = 0;
            
            if(this.netCostVisibilityFlag === true)    
                convertedCost = testList[i].customer_usage * (testList[i].customer_qpu / testList[i].od_sku_qpu) * testList[i].wtd_net_cost;
            else
                convertedCost = testList[i].customer_usage * (testList[i].customer_qpu / testList[i].od_sku_qpu) * testList[i].wtd_tdc_cost;
            if(isFinite(convertedCost))
                testList[i]['converted_cost'] = convertedCost.toFixed(2);
            else
                testList[i]['converted_cost'] = 0;    

            var table = this.template.querySelector('lightning-datatable');
            table.data = testList;   
            this.data = testList;
                
            
        }
    }

    getData(event){

        let callingComponent = event.target.name;
        console.log('calling component-->'+callingComponent);
        if(callingComponent == 'PreviousPage')
        {
            if(this.currentPage == 0)
            {   
                this.isPreviousAvailable = false;
                console.log('sorry no previous'+this.currentPage);
            
            }
            else
            {
                this.pageNum = this.currentPage;
                this.pageType = 'PreviousPage';
                this.currentPage--;   
            }
            
        }
        else if(callingComponent == 'NextPage')
        {

            this.pageType = 'NextPage';
            this.pageNum = this.currentPage;
            this.currentPage++;
            this.isPreviousAvailable = true;
        }

        if(this.isPreviousAvailable == true)
        {
            this.dataLoaded = false; 
        if(this.filterApplied === false){
            getAllResults({
                Reference_Id: this.refID,
                PageNumber: this.pageNum,
                Page: this.pageType
            })
            .then(result => {
                this.data = result;
                this.filteredList = result;// new line 10/13
                this.dataLoaded = true;
                this.createdTimeStamp = this.data[0]['sys_created_date'];
                this.calculateUOM();
                console.log(this.fileName);
            })
            .catch(error => {
                console.log('error-->' + JSON.stringify(error));
                this.MessageToBeDisplayed = 'Next Page not available to Display'
                            this.ToastToBeDisplayed = true;
                            this.dataLoaded = true;
                            this.delayTimeout = setTimeout(() => {
                                this.ToastToBeDisplayed = false;
                            }, this.autoCloseTime);
    
            });
        }
        else{
            this.getFilteredRecords();
        }    
        
        }
        else
        {
            this.MessageToBeDisplayed = 'Data not available to Display'
                        this.ToastToBeDisplayed = true;
                        this.dataLoaded = true;
                        this.delayTimeout = setTimeout(() => {
                            this.ToastToBeDisplayed = false;
                        }, this.autoCloseTime);

        }
    }

    handleSortdata(event) {
        // field name
        this.sortBy = event.detail.fieldName;
        console.log('fieldName-->'+this.sortBy);
        
        // sort direction
        this.sortDirection = event.detail.sortDirection;
        console.log('sortDirection-->'+this.sortDirection);

        // calling sortdata function to sort the data based on direction and selected field
        this.sortData(event.detail.fieldName, event.detail.sortDirection);
        this.calculateUOM();
    }

    sortData(fieldname, direction) {
        // serialize the data before calling sort function
        console.log('Testing-->'+JSON.stringify(this.filteredList));
        let parseData = JSON.parse(JSON.stringify(this.filteredList));

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
        this.data = parseData;

    }

    downloadSortData(fieldname, direction, dataToSort) {
        // serialize the data before calling sort function
        console.log('Testing-->'+JSON.stringify(dataToSort));
        let parseData = JSON.parse(JSON.stringify(dataToSort));

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
        return parseData;

    }


    getFilteredRecords(){
        //alert('Test-->>>>'+this.selectedFilter);
        getFilteredRecordsData({
            Reference_Id: this.refID,
            PageNumber: this.pageNum,
            Page: this.pageType,
            selectedFilter: this.selectedFilter,
        })
        .then(result => {
            this.data = result;
            this.filteredList = result;
            this.sortData('stg_rownum','asc');
            this.dataLoaded = true;
            this.createdTimeStamp = this.data[0]['sys_created_date'];
            this.calculateUOM();
            console.log(this.fileName);
        })
        .catch(error => {
            //alert('error-->' + JSON.stringify(error));
            this.MessageToBeDisplayed = 'Next Page not available to Display'
                        this.ToastToBeDisplayed = true;
                        this.dataLoaded = true;
                        this.delayTimeout = setTimeout(() => {
                            this.ToastToBeDisplayed = false;
                        }, this.autoCloseTime);

        });
    }

    MatchType(event) {

        //const field = event.target.name;
        let selectedOption = event.target.value;
        //alert('selected-->'+selectedOption);
        let filteredDataList = [];

        if(selectedOption === 'ExactMatch')
        {
            this.selectedFilter = selectedOption;
            this.isALLSelected = false;
            this.filterApplied = true;
            this.dataLoaded = false;
            this.pageNum = 0;
            this.pageType = 'FirstPage';
            this.getFilteredRecords();
            
        }
        else if(selectedOption === 'FunctionalMatch')
        {
            this.selectedFilter = selectedOption;
            this.isALLSelected = false;
            this.dataLoaded = false;
            this.filterApplied = true;
            this.pageNum = 0;
            this.pageType = 'FirstPage';
            this.getFilteredRecords();
            
        }
        else if(selectedOption === 'Bulk')
        {
            this.selectedFilter = selectedOption;
            this.isALLSelected = false;
            this.dataLoaded = false;
            this.filterApplied = true;
            this.pageNum = 0;
            this.pageType = 'FirstPage';
            this.getFilteredRecords();
            
        }
        else if(selectedOption === 'PreferredMatch')
        {
            this.selectedFilter = selectedOption;
            this.isALLSelected = false;
            this.dataLoaded = false;
            this.filterApplied = true;
            this.pageNum = 0;
            this.pageType = 'FirstPage';
            this.getFilteredRecords();
            
        }
        else if(selectedOption === 'NoMatch')
        {
            this.selectedFilter = selectedOption;
            this.isALLSelected = false;
            this.dataLoaded = false;
            this.filterApplied = true;
            this.pageNum = 0;
            this.pageType = 'FirstPage';
            this.getFilteredRecords();
            
        }
        else if(selectedOption === 'All')
        {
            this.selectedFilter = selectedOption;
            this.isALLSelected = true;
            this.filterApplied = true;
            this.dataLoaded = false;
            this.pageNum = 0;
            this.pageType = 'FirstPage';
            this.getFilteredRecords();
            
        }

        if(selectedOption !== 'All')
            this.getAuthTokenMethod(); 

        //this.template.template.querySelector("lightning-datatable[data]").value = filteredDataList;
        var table = this.template.querySelector('lightning-datatable');
        table.data = filteredDataList;
        this.filteredList = filteredDataList;
        //alert("test not all-->" + JSON.stringify(filteredDataList));
        //this.data = filteredDataList;

    }

    set data(value) {
        this.privateTitle = value.toUpperCase();
        this.setAttribute('title', this.privateTitle);
    }


    addRecommendations() {

        var competitor_uom;
        var customer_qpu;

        if (this.sentforapprovaldata.length !== 0) {

            for(let i = 0; i < this.sentforapprovaldata.length ; i++)
            {
            let JsonPayload = JSON.parse(JSON.stringify(this.sentforapprovaldata[i]));
            if (JsonPayload.recommendations !== undefined) {
                console.log(JSON.stringify(JsonPayload.recommendations));
                JsonPayload.od_sku = JsonPayload.recommendations;
            }

            if (JsonPayload.recommendations == undefined ){
                console.log(JSON.stringify(JsonPayload.od_sku));
                JsonPayload.od_sku = JsonPayload.od_sku;
            }

            if (JsonPayload.orig_competitor_uom !== undefined) {
                console.log(JSON.stringify(JsonPayload.orig_competitor_uom));
                competitor_uom = JsonPayload.competitor_uom;
                //alert('addRecommendation competitor_uom -->' + competitor_uom);
                
                JsonPayload.competitor_uom = JsonPayload.orig_competitor_uom;
            }
            if (JsonPayload.orig_customer_qpu !== undefined) {
                console.log(JSON.stringify(JsonPayload.orig_customer_qpu));
                customer_qpu = JsonPayload.customer_qpu;
                //alert('addRecommendation customer_qpu -->' + customer_qpu);
                JsonPayload.customer_qpu = JsonPayload.orig_customer_qpu;
            }


            this.ToastToBeDisplayed = false;
            addRecc({
                    payLoad: JSON.stringify(JsonPayload)
                })
                .then(result => {
                    if (result === 'Success') {
                        this.MessageToBeDisplayed = 'Recommendations Added Succesfully'
                        this.ToastToBeDisplayed = true;

                        this.delayTimeout = setTimeout(() => {
                            this.ToastToBeDisplayed = false;
                        }, this.autoCloseTime);


                        //for updating the recommendations to results table, to persists the data.
                       /* alert('After addRec competitor_uom -->' + JsonPayload.competitor_uom);
                        alert('After addRec competitor_qpu -->' + JsonPayload.customer_qpu);
                        JsonPayload.customer_qpu = customer_qpu;
                        JsonPayload.competitor_uom = competitor_uom;
                        alert('Before UpdateRec  competitor_uom -->' + JsonPayload.competitor_uom);
                        alert('Before UpdateRec competitor_qpu -->' + JsonPayload.customer_qpu);*/

                        /*updateRecc({
                            payLoad: JSON.stringify(JsonPayload),
                            refId: JsonPayload.reference_id
                        })
                        .then(result => {
                            if (result === 'Success') {
                                console.log('Updated Recommendations');
                            }
        
        
                        })
                        .catch(error => {
                            console.log('error-->' + JSON.stringify(error));
        
                        });*/



                    } else {
                        this.MessageToBeDisplayed = 'Recommendations not added.'
                        this.ToastToBeDisplayed = true;

                        this.delayTimeout = setTimeout(() => {
                            this.ToastToBeDisplayed = false;
                        }, this.autoCloseTime);
                    }


                })
                .catch(error => {
                    console.log('error-->' + JSON.stringify(error));

                });
            }
        } else {
            this.MessageToBeDisplayed = 'Please Select Data to Request Approval'
            this.ToastToBeDisplayed = true;

            this.delayTimeout = setTimeout(() => {
                this.ToastToBeDisplayed = false;
            }, this.autoCloseTime);


        }
    }


    closeModel() {
        this.ToastToBeDisplayed = false;
    }


    // Getting selected rows 
    getSelectedRecords(event) {
        // getting selected rows

        const selectedRows = event.detail.selectedRows;
        console.log('selectedRecords set ====> ' + JSON.stringify(selectedRows));
        //this.recordsCount = event.detail.selectedRows.length;
        if (selectedRows !== undefined) {
            this.ToastToBeDisplayed = false;
            // this set elements the duplicates if any
            let conIds = new Set();

            // getting selected record id
            for (let i = 0; i < selectedRows.length; i++) {
                conIds.add(selectedRows[i]);
            }


            // coverting to array
            this.sentforapprovaldata = Array.from(conIds);


            window.console.log('selectedRecords ====> ' + JSON.stringify(this.sentforapprovaldata));
        }
    }

 updateRecommendations(recordToBeUpdatedinResults) {

        //alert("u count=>"+ recordToBeUpdatedinResults.length);
        if (recordToBeUpdatedinResults.length !== 0) {
            //alert('Number of records updated ='+ recordToBeUpdatedinResults.length);
            for(let i = 0; i < recordToBeUpdatedinResults.length ; i++)
            {
            let JsonPayload = recordToBeUpdatedinResults[i];
            //alert('in updateRecommendation--->' + JSON.stringify(JsonPayload));

            this.ToastToBeDisplayed = false;
            updateRecc({
                    payLoad: JSON.stringify(JsonPayload),
                    refId: JsonPayload.reference_id
                })
                .then(result => {
                    if (result === 'Success') {
                        this.MessageToBeDisplayed = 'Recommendations updated Succesfully'
                        this.ToastToBeDisplayed = true;

                        this.delayTimeout = setTimeout(() => {
                            this.ToastToBeDisplayed = false;
                        }, this.autoCloseTime);

                    } 
                    else {
                        this.MessageToBeDisplayed = 'Recommendations not updated.'
                        this.ToastToBeDisplayed = true;

                        this.delayTimeout = setTimeout(() => {
                            this.ToastToBeDisplayed = false;
                        }, this.autoCloseTime);
                    }


                })
                .catch(error => {
                    console.log('error-->' + JSON.stringify(error));

                });
            }
        } else {
            this.MessageToBeDisplayed = 'Please Select Data to Request Approval'
            this.ToastToBeDisplayed = true;

            this.delayTimeout = setTimeout(() => {
                this.ToastToBeDisplayed = false;
            }, this.autoCloseTime);


        }
    }
/*
    handleSave(event) {

        let modifiedrowstosave = new Set();
        //const recordInputs = event.detail.draftValues;
        const recordInputs = this.sentforapprovaldata;
        //alert(JSON.stringify(this.data));
        //let tempPickList = JSON.parse(JSON.stringify(this.data));
        let tempPickList = JSON.parse(JSON.stringify(event.detail.draftValues));
        for (let i = 0; i < recordInputs.length; i++) {
            alert("1" + JSON.stringify(recordInputs[i]));
            for (let j = 0; j < this.data.length; j++) {
                alert("2-" + JSON.stringify(this.data[j]));
                let rowNumber = 'row-' + j;
                //alert("2");
                //alert("recordInputs[i].id === rowNumber" + recordInputs[i].results_uid +","+ this.data[j].results_uid);
                if (recordInputs[i].results_uid === this.data[j].results_uid) {
                //if (recordInputs[i].id === rowNumber) {
                    alert("3");
                    console.log("test-->" + JSON.stringify(recordInputs));
                    console.log("test1-->" + this.data[j].recommendations);
                    alert("recordInputs[i].recommendations ="+ recordInputs[i].recommendations);
                    alert("this.data[j].recommendations ="+ this.data[j].recommendations);
                    if(recordInputs[i].recommendations != undefined)
                        tempPickList[j].recommendations = recordInputs[i].recommendations;
                    else
                        tempPickList[j].recommendations = this.data[j].recommendations;   
                    alert("tempPickList[j].recommendations ="+ tempPickList[j].recommendations);
                    //alert('test BEFORE od sku qpu --->' + recordInputs[i].od_sku_qpu);
                    //alert('value = >' + recordInputs[i].od_sku_qpu);
                    //alert('value1 = >' + recordInputs[i].od_sku_qpu === undefined);
                    if(recordInputs[i].od_sku_qpu != undefined) 
                        tempPickList[j].od_sku_qpu = recordInputs[i].od_sku_qpu;
                    else {
                        //alert('in else '+ this.data[j].od_sku_qpu);
                        if (this.data[j].od_sku_qpu == undefined || this.data[j].od_sku_qpu == 'None') {
                            //alert('setting to 0');
                            tempPickList[j].od_sku_qpu = null;
                        } else 
                            tempPickList[j].od_sku_qpu = this.data[j].od_sku_qpu;    
                        //alert('in else 2=>'+ tempPickList[j].od_sku_qpu);
                    }
                    //alert('at the end...'+ tempPickList[j].od_sku_qpu);
                    if(recordInputs[i].od_sku_uom != undefined)
                        tempPickList[j].od_sku_uom = recordInputs[i].od_sku_uom; 
                    else
                        tempPickList[j].od_sku_uom = this.data[j].od_sku_uom;  
                        
                    if(recordInputs[i].competitor_uom != undefined)
                        tempPickList[j].competitor_uom = recordInputs[i].competitor_uom; 
                    else
                        tempPickList[j].competitor_uom = this.data[j].competitor_uom;
                    
                    if(recordInputs[i].customer_qpu != undefined)
                        tempPickList[j].customer_qpu = recordInputs[i].customer_qpu; 
                    else
                        tempPickList[j].customer_qpu = this.data[j].customer_qpu;
                    
                    //tempPickList[j].od_sku = recordInputs[i].Recommendations;
                    alert("4");
                    modifiedrowstosave.add(tempPickList[j]);
                    alert("5");
                }

            }

        }
        console.log('length--->' + tempPickList.length);

        //this.updateRecommendations(tempPickList);
        //this.updateRecommendations(this.sentforapprovaldata);
        alert("6");
        this.updateRecommendations(Array.from(modifiedrowstosave));
        alert("7");
        this.data = tempPickList;
        this.draftValues = [];




    }
*/

handleSave(event) {
    let modifiedrowstosave = new Set();
    const recordInputs = event.detail.draftValues;
        //alert(JSON.stringify(this.data));
        let tempPickList = JSON.parse(JSON.stringify(this.data));
        for (let i = 0; i < recordInputs.length; i++) {
            //alert("1="+ JSON.stringify(recordInputs[i]));
            for (let j = 0; j < this.data.length; j++) {
                let rowNumber = 'row-' + j;
                //alert("2="+ JSON.stringify(this.data[j]));
                
                //alert("recordInputs[i].id === rowNumber=" + recordInputs[i].id +","+ rowNumber);
                if (recordInputs[i].id === rowNumber) {
                    //alert("3="+ JSON.stringify(tempPickList[j]));
                    console.log("test-->" + JSON.stringify(recordInputs));
                    console.log("test1-->" + this.data[j].recommendations);
                    if(recordInputs[i].recommendations != undefined)
                        tempPickList[j].recommendations = recordInputs[i].recommendations;
                    /*else
                        tempPickList[j].recommendations = this.data[j].recommendations;    */
                    if(recordInputs[i].od_sku_qpu != undefined)
                        tempPickList[j].od_sku_qpu = recordInputs[i].od_sku_qpu;
                    else {
                        tempPickList[j].od_sku_qpu = null;
                        //alert('in else '+ this.data[j].od_sku_qpu);
                        if (this.data[j].od_sku_qpu == undefined || this.data[j].od_sku_qpu == 'None') {
                            //alert('setting to 0');
                            tempPickList[j].od_sku_qpu = null;
                        }// else 
                           // tempPickList[j].od_sku_qpu = this.data[j].od_sku_qpu;    
                        //alert('in else 2=>'+ tempPickList[j].od_sku_qpu);
                    }
                        
                    if(recordInputs[i].od_sku_uom != undefined)
                        tempPickList[j].od_sku_uom = recordInputs[i].od_sku_uom; 
                    else
                        tempPickList[j].od_sku_uom = null;
                    //else
                        //tempPickList[j].od_sku_uom = this.data[j].od_sku_uom;
                        
                    if(recordInputs[i].competitor_uom != undefined)
                        tempPickList[j].competitor_uom = recordInputs[i].competitor_uom; 
                    /*else
                        tempPickList[j].competitor_uom = this.data[j].competitor_uom;*/
                    
                    if(recordInputs[i].customer_qpu != undefined)
                        tempPickList[j].customer_qpu = recordInputs[i].customer_qpu; 
                   /* else
                        tempPickList[j].customer_qpu = this.data[j].customer_qpu;*/
                    
                    //tempPickList[j].od_sku = recordInputs[i].Recommendations;
                    modifiedrowstosave.add(tempPickList[j]);
                    //alert('tempPickList[j] ='+JSON.stringify(tempPickList)[j]);
                }

            }

        }
        console.log('length--->' + tempPickList.length);

        this.updateRecommendations(Array.from(modifiedrowstosave));
        this.data = tempPickList;
        this.draftValues = [];

    

}
 

    exportToCSV() {

        if(this.isALLSelected === false)
        {
        if(this.DataForDownload != undefined && this.DataForDownload.length != 0)
        {
        for(let y = 0; y < this.DataForDownload.length ; y++)
        {
            
            if(this.DataForDownload[y].recommendations == null)
                delete this.DataForDownload[y]['recommendations'];
            if(this.DataForDownload[y].od_sku_vpn == null)
                delete this.DataForDownload[y]['od_sku_vpn'];    
            if(this.DataForDownload[y].od_sku == null)
                delete this.DataForDownload[y]['od_sku'];   
        }
           
        console.log('Tetsing DATA-->'+JSON.stringify(this.DataForDownload));    
            
        let columnHeader;
        let jsonKeys;
        let dataToDownload;
        if (this.NoErrors === true) {
            columnHeader = ["SKU", "SKU[descr]", "Row type", "Row template", "Competitor Usage", "Average Competitor Price", "Cross-Reference"]; // This array holds the Column headers to be displayd
            jsonKeys = ["recommendations", "od_sku_description", "Row type", "Row template", "customer_usage", "competitor_price", "Cross-Reference"]; // This array holds the keys in the json data  
            dataToDownload = this.DataForDownload;
        } else {
            columnHeader = ["Reference_Id", "Status", "Messages"]; // This array holds the Column headers to be displayd
            jsonKeys = ["reference_id", "status", "message"]; // This array holds the keys in the json data
            dataToDownload = this.errorData;

        }
        var jsonRecordsData = dataToDownload;
        var stringformationArray = dataToDownload;
        var rowsWhereSKUisSame = [];

        let CrossReferenceString = '';
        let CrossReferenceStringReccs = '';
        for (let i = 0; i < jsonRecordsData.length; i++) {
            for (let j = 0; j < stringformationArray.length; j++) {
                let test1 = jsonRecordsData[i]['od_sku'];
                let test2 = jsonRecordsData[j]['od_sku'];
                let test3 = jsonRecordsData[i]['recommendations'];
                let test4 = jsonRecordsData[j]['recommendations'];
                if (jsonRecordsData[i]['recommendations'] !== undefined && jsonRecordsData[i]['recommendations'] !== '') {
                    if (test3 !== test4) {

                    } else {
                        if (i !== j) {
                            if(rowsWhereSKUisSame.includes(jsonRecordsData[i]))
                            {}
                            else
                                rowsWhereSKUisSame.push(jsonRecordsData[i]);
                        }
                    }

                    if (test3 !== test2) {

                    } else {
                        if (i !== j) {
                            if(rowsWhereSKUisSame.includes(jsonRecordsData[i]))
                            {}
                            else
                                rowsWhereSKUisSame.push(jsonRecordsData[i]);
                        }
                    }
                } else if (jsonRecordsData[i]['od_sku'] !== undefined) {
                    if (test1 !== test2) {

                    } else {
                        if (i !== j) {
                            if(rowsWhereSKUisSame.includes(jsonRecordsData[i]))
                            {}
                            else
                                rowsWhereSKUisSame.push(jsonRecordsData[i]);
                            
                        }
                    }

                    if (test1 !== test4) {

                    } else {
                        if (i !== j) {
                            if(rowsWhereSKUisSame.includes(jsonRecordsData[i]))
                            {}
                            else
                                rowsWhereSKUisSame.push(jsonRecordsData[i]);
                        }
                    }

                }
            }
        }
        
        console.log('RowswhereSKU-->'+JSON.stringify(rowsWhereSKUisSame));

        let csvIterativeData;

        let csvSeperator
        let newLineCharacter;
        let CrossReferenceStringSingle = '';
        let AverageUsage;
        let AveragePrice;
        let testData;
        let countNoMatches = 0;
        let sameODSKU = false;
        csvSeperator = ",";
        newLineCharacter = "\n";
        csvIterativeData = "";
        csvIterativeData += columnHeader.join(csvSeperator);
        csvIterativeData += newLineCharacter;
        for (let i = 0; i < jsonRecordsData.length; i++) {
            let counter = 0;
            for (let iteratorObj in jsonKeys) {
                let dataKey = jsonKeys[iteratorObj];
                if (counter > 0) {
                    csvIterativeData += csvSeperator;
                }
                
                if (jsonRecordsData[i][dataKey] !== null &&
                    jsonRecordsData[i][dataKey] !== undefined
                ) {
                    
                    if (dataKey === 'recommendations' && (jsonRecordsData[i][dataKey] === '' || jsonRecordsData[i][dataKey] === null)) {

                        if (jsonRecordsData[i]['od_sku'] !== undefined)
                            csvIterativeData += '"' + jsonRecordsData[i]['od_sku'] + '"';
                        else
                            csvIterativeData += '"' + 'No Cross Folder' + '"';

                    } else if (dataKey === 'od_sku_description') {
                        if ((jsonRecordsData[i]['recommendations'] !== undefined && jsonRecordsData[i]['recommendations'] !== '') || jsonRecordsData[i]['od_sku'] !== undefined)
                            csvIterativeData += '""';
                        else
                        {
                            countNoMatches++;
                            testData += jsonRecordsData[i]['stg_rownum'] + '|#|' +jsonRecordsData[i]['reference_id'] + '|#|' + jsonRecordsData[i]['competitor_product_id'] + '|#|' + jsonRecordsData[i]['competitor_description'] + '|#|' + jsonRecordsData[i]['competitor_uom'] + '|#|' + jsonRecordsData[i]['customer_qpu'] + '|#|' + jsonRecordsData[i]['customer_usage'] + '|#|' + jsonRecordsData[i]['competitor_price'] + '|#|' + jsonRecordsData[i]['od_sku'] + '|#|' + jsonRecordsData[i]['od_sku_uom'] + '|#|' + jsonRecordsData[i]['od_sku_qpu'] + '{#}';
                            
                            if(testData.includes('"'))
                                csvIterativeData += '"' + testData.replace(/"/g,'""') + '"';
                            else
                                csvIterativeData += '"' + testData + '"';
                        }
                            
                    } else if (dataKey === 'customer_usage') {
                        if ((jsonRecordsData[i]['recommendations'] !== undefined && jsonRecordsData[i]['recommendations'] !== '') || jsonRecordsData[i]['od_sku'] !== undefined)
                        {
                            

                            if(rowsWhereSKUisSame.includes(jsonRecordsData[i]))
                            {
                                AverageUsage = 0;
                            for(let j in rowsWhereSKUisSame)
                            {
                                if(jsonRecordsData[i].od_sku === rowsWhereSKUisSame[j].od_sku)
                                {
                                    console.log('Same SKUS-->'+AverageUsage + '    ' + rowsWhereSKUisSame[j].competitor_product_id);
                                    console.log('individual Cal-->'+(rowsWhereSKUisSame[j].customer_qpu / rowsWhereSKUisSame[j].od_sku_qpu) * rowsWhereSKUisSame[j].customer_usage)
                                    AverageUsage += (rowsWhereSKUisSame[j].customer_qpu / rowsWhereSKUisSame[j].od_sku_qpu) * rowsWhereSKUisSame[j].customer_usage;
                                    
                                    
                                    
                                }
                            }
                            if(isFinite(AverageUsage))
                                csvIterativeData += '"' + Math.round(AverageUsage) + '"'; 
                            else
                                csvIterativeData += '"' + 0 + '"';   
                        }
                        else
                            {
                                AverageUsage = 0;
                                console.log('Not Same SKUS-->'+AverageUsage + '    ' + jsonRecordsData[i].od_sku);
                                AverageUsage += (jsonRecordsData[i].customer_qpu / jsonRecordsData[i].od_sku_qpu) * jsonRecordsData[i].customer_usage;
                                
                                if(isFinite(AverageUsage))
                                    csvIterativeData += '"' + Math.round(AverageUsage) + '"'; 
                                else
                                    csvIterativeData += '"' + 0 + '"';

                            } 



                            

                        }
                        else
                            csvIterativeData += '"' + '' + '"';

                    } else if (dataKey === 'competitor_price') {
                        if ((jsonRecordsData[i]['recommendations'] !== undefined && jsonRecordsData[i]['recommendations'] !== '') || jsonRecordsData[i]['od_sku'] !== undefined)
                        {


                            if(rowsWhereSKUisSame.includes(jsonRecordsData[i]))
                            {
                                AveragePrice = 0;
                                let countSameSKU = 0;
                            for(let j in rowsWhereSKUisSame)
                            {
                                if(jsonRecordsData[i].od_sku === rowsWhereSKUisSame[j].od_sku)
                                {
                                    AveragePrice = Math.round(rowsWhereSKUisSame[j].competitor_price/(rowsWhereSKUisSame[j].customer_qpu/rowsWhereSKUisSame[j].od_sku_qpu),2)
                                    countSameSKU++;
                                    
                                    
                                }
                            }
                            if(isFinite(AveragePrice))
                                csvIterativeData += '"' + AveragePrice/countSameSKU + '"';
                            else
                                csvIterativeData += '"' + '' + '"';
                            
                        }
                        else
                            {
                                AveragePrice = 0;
                                AveragePrice = Math.round(jsonRecordsData[i].competitor_price/(jsonRecordsData[i].customer_qpu/jsonRecordsData[i].od_sku_qpu),2)
                                if(isFinite(AveragePrice))
                                    csvIterativeData += '"' + AveragePrice + '"';
                                 else
                                    csvIterativeData += '"' + '' + '"';

                            }                                 



                        

                        }
                        else
                            csvIterativeData += '"' + '' + '"';

                    } 
                    else {
                        csvIterativeData += '"' + jsonRecordsData[i][dataKey] + '"';
                    }
                } else {
                    if (dataKey === 'recommendations') {
                        if (jsonRecordsData[i]['od_sku'] !== undefined)
                            csvIterativeData += '"' + jsonRecordsData[i]['od_sku'] + '"';
                        else
                            csvIterativeData += '"' + 'No Cross Folder' + '"';
                    } else if (dataKey === 'Row type') {
                        if ((jsonRecordsData[i]['recommendations'] !== undefined && jsonRecordsData[i]['recommendations'] !== '') || jsonRecordsData[i]['od_sku'] !== undefined)
                            csvIterativeData += '"' + 'PRODUCT' + '"';
                        else
                            csvIterativeData += '"' + 'FOLDER' + '"';
                    } else if (dataKey === 'Row template') {
                        if ((jsonRecordsData[i]['recommendations'] !== undefined && jsonRecordsData[i]['recommendations'] !== '') || jsonRecordsData[i]['od_sku'] !== undefined)
                            csvIterativeData += '""';
                        else
                            csvIterativeData += '"' + 'FolderLineTemplate' + '"';
                    } else if (dataKey === 'od_sku_description') {
                        testData += jsonRecordsData[i]['stg_rownum'] + '|#|' +jsonRecordsData[i]['reference_id'] + '|#|' + jsonRecordsData[i]['competitor_product_id'] + '|#|' + jsonRecordsData[i]['competitor_description'] + '|#|' + jsonRecordsData[i]['competitor_uom'] + '|#|' + jsonRecordsData[i]['customer_qpu'] + '|#|' + jsonRecordsData[i]['customer_usage'] + '|#|' + jsonRecordsData[i]['competitor_price'] + '|#|' + jsonRecordsData[i]['od_sku'] + '|#|' + jsonRecordsData[i]['od_sku_uom'] + '|#|' + jsonRecordsData[i]['od_sku_qpu'] + '{#}';
                        
                        if ((jsonRecordsData[i]['recommendations'] !== undefined && jsonRecordsData[i]['recommendations'] !== '') || jsonRecordsData[i]['od_sku'] !== undefined)
                            csvIterativeData += '""';
                        else
                        {
                            countNoMatches++
                            if(testData.includes('"'))
                                csvIterativeData += '"' + testData.replace(/"/g,'""') + '"';
                            else
                                csvIterativeData += '"' + testData + '"';
                        }
                            
                    } else if (dataKey === 'Cross-Reference') {

                            if(jsonRecordsData[i]['recommendations'] !== undefined && jsonRecordsData[i]['recommendations'] !== '')
                            {
                                
                                if(rowsWhereSKUisSame.includes(jsonRecordsData[i]))
                                {
                                    CrossReferenceStringReccs = '';
                                for(let j in rowsWhereSKUisSame)
                                {
                                    if(jsonRecordsData[i].recommendations === rowsWhereSKUisSame[j].recommendations || jsonRecordsData[i].recommendations === rowsWhereSKUisSame[j].od_sku)
                                    {
                                        
                                        if(CrossReferenceStringReccs.includes(rowsWhereSKUisSame[j]['stg_rownum'] + '|#|' + rowsWhereSKUisSame[j]['reference_id'] + '|#|' + rowsWhereSKUisSame[j]['competitor_product_id'] + '|#|' + rowsWhereSKUisSame[j]['competitor_description'] + '|#|' + rowsWhereSKUisSame[j]['competitor_uom'] + '|#|' + rowsWhereSKUisSame[j]['customer_qpu'] + '|#|' + rowsWhereSKUisSame[j]['customer_usage'] + '|#|' + rowsWhereSKUisSame[j]['competitor_price'] + '|#|' + rowsWhereSKUisSame[j]['od_sku'] + '|#|' + rowsWhereSKUisSame[j]['od_sku_uom'] + '|#|' + rowsWhereSKUisSame[j]['od_sku_qpu'] + '{#}'))
                                        {}
                                        else
                                        {
                                            CrossReferenceStringReccs += rowsWhereSKUisSame[j]['stg_rownum'] + '|#|' + rowsWhereSKUisSame[j]['reference_id'] + '|#|' + rowsWhereSKUisSame[j]['competitor_product_id'] + '|#|' + rowsWhereSKUisSame[j]['competitor_description'] + '|#|' + rowsWhereSKUisSame[j]['competitor_uom'] + '|#|' + rowsWhereSKUisSame[j]['customer_qpu'] + '|#|' + rowsWhereSKUisSame[j]['customer_usage'] + '|#|' + rowsWhereSKUisSame[j]['competitor_price'] + '|#|' + rowsWhereSKUisSame[j]['od_sku'] + '|#|' + rowsWhereSKUisSame[j]['od_sku_uom'] + '|#|' + rowsWhereSKUisSame[j]['od_sku_qpu'] + '{#}';
                                        
                                        }
                                        
                                    }
                                } 
                                CrossReferenceStringReccs = CrossReferenceStringReccs.substring(0, CrossReferenceStringReccs.length - 3);       
                                
                                if(CrossReferenceStringReccs.includes('"'))
                                    csvIterativeData += '"' + CrossReferenceStringReccs.replace(/"/g,'"') + '"';
                                else
                                    csvIterativeData += '"' + CrossReferenceStringReccs + '"';
                            }
                            else
                                {

                                    CrossReferenceStringReccs = '';
                                    
                                            
                                            if(CrossReferenceStringReccs.includes(jsonRecordsData[i]['stg_rownum'] + '|#|' + jsonRecordsData[i]['reference_id'] + '|#|' + jsonRecordsData[i]['competitor_product_id'] + '|#|' + jsonRecordsData[i]['competitor_description'] + '|#|' + jsonRecordsData[i]['competitor_uom'] + '|#|' + jsonRecordsData[i]['customer_qpu'] + '|#|' + jsonRecordsData[i]['customer_usage'] + '|#|' + jsonRecordsData[i]['competitor_price'] + '|#|' + jsonRecordsData[i]['od_sku'] + '|#|' + jsonRecordsData[i]['od_sku_uom'] + '|#|' + jsonRecordsData[i]['od_sku_qpu']))
                                            {}
                                            else
                                            {
                                                CrossReferenceStringReccs = jsonRecordsData[i]['stg_rownum'] + '|#|' + jsonRecordsData[i]['reference_id'] + '|#|' + jsonRecordsData[i]['competitor_product_id'] + '|#|' + jsonRecordsData[i]['competitor_description'] + '|#|' + jsonRecordsData[i]['competitor_uom'] + '|#|' + jsonRecordsData[i]['customer_qpu'] + '|#|' + jsonRecordsData[i]['customer_usage'] + '|#|' + jsonRecordsData[i]['competitor_price'] + '|#|' + jsonRecordsData[i]['od_sku'] + '|#|' + jsonRecordsData[i]['od_sku_uom'] + '|#|' + jsonRecordsData[i]['od_sku_qpu'];
                                            
                                            }
                                         
                                    if(CrossReferenceStringReccs.includes('"'))
                                        csvIterativeData += '"' + CrossReferenceStringReccs.replace(/"/g,'""') + '"';
                                    else
                                        csvIterativeData += '"' + CrossReferenceStringReccs + '"';

                                }
                                
                            }
                            else if(jsonRecordsData[i]['od_sku'] !== undefined)
                            {
                                if(rowsWhereSKUisSame.includes(jsonRecordsData[i]))
                                {
                                CrossReferenceString = '';
                                for(let j in rowsWhereSKUisSame)
                                {
                                    
                                    if(jsonRecordsData[i].od_sku === rowsWhereSKUisSame[j].od_sku || jsonRecordsData[i].od_sku === rowsWhereSKUisSame[j].recommendations)
                                    {
                                        
                                        if(CrossReferenceString.includes(rowsWhereSKUisSame[j]['stg_rownum'] + '|#|' + rowsWhereSKUisSame[j]['reference_id'] + '|#|' + rowsWhereSKUisSame[j]['competitor_product_id'] + '|#|' + rowsWhereSKUisSame[j]['competitor_description'] + '|#|' + rowsWhereSKUisSame[j]['competitor_uom'] + '|#|' + rowsWhereSKUisSame[j]['customer_qpu'] + '|#|' + rowsWhereSKUisSame[j]['customer_usage'] + '|#|' + rowsWhereSKUisSame[j]['competitor_price'] + '|#|' + rowsWhereSKUisSame[j]['od_sku'] + '|#|' + rowsWhereSKUisSame[j]['od_sku_uom'] + '|#|' + rowsWhereSKUisSame[j]['od_sku_qpu'] + '{#}'))
                                        {}
                                        else
                                        {
                                        CrossReferenceString += rowsWhereSKUisSame[j]['stg_rownum'] + '|#|' + rowsWhereSKUisSame[j]['reference_id'] + '|#|' + rowsWhereSKUisSame[j]['competitor_product_id'] + '|#|' + rowsWhereSKUisSame[j]['competitor_description'] + '|#|' + rowsWhereSKUisSame[j]['competitor_uom'] + '|#|' + rowsWhereSKUisSame[j]['customer_qpu'] + '|#|' + rowsWhereSKUisSame[j]['customer_usage'] + '|#|' + rowsWhereSKUisSame[j]['competitor_price'] + '|#|' + rowsWhereSKUisSame[j]['od_sku'] + '|#|' + rowsWhereSKUisSame[j]['od_sku_uom'] + '|#|' + rowsWhereSKUisSame[j]['od_sku_qpu'] + '{#}';
                                        
                                        }
                                        
                                    }
                                } 
                                CrossReferenceString = CrossReferenceString.substring(0, CrossReferenceString.length - 3);
                                if(CrossReferenceString.includes('"'))
                                    csvIterativeData += '"' + CrossReferenceString.replace(/"/g,'""') + '"';   
                                else
                                    csvIterativeData += '"' + CrossReferenceString + '"';
                            }
                            else
                                {

                                    CrossReferenceStringSingle = '';
                                      
                                            
                                            if(CrossReferenceStringSingle.includes(jsonRecordsData[i]['stg_rownum'] + '|#|' + jsonRecordsData[i]['reference_id'] + '|#|' + jsonRecordsData[i]['competitor_product_id'] + '|#|' + jsonRecordsData[i]['competitor_description'] + '|#|' + jsonRecordsData[i]['competitor_uom'] + '|#|' + jsonRecordsData[i]['customer_qpu'] + '|#|' + jsonRecordsData[i]['customer_usage'] + '|#|' + jsonRecordsData[i]['competitor_price'] + '|#|' + jsonRecordsData[i]['od_sku'] + '|#|' + jsonRecordsData[i]['od_sku_uom'] + '|#|' + jsonRecordsData[i]['od_sku_qpu']))
                                            {}
                                            else
                                            {
                                            CrossReferenceStringSingle = jsonRecordsData[i]['stg_rownum'] + '|#|' + jsonRecordsData[i]['reference_id'] + '|#|' + jsonRecordsData[i]['competitor_product_id'] + '|#|' + jsonRecordsData[i]['competitor_description'] + '|#|' + jsonRecordsData[i]['competitor_uom'] + '|#|' + jsonRecordsData[i]['customer_qpu'] + '|#|' + jsonRecordsData[i]['customer_usage'] + '|#|' + jsonRecordsData[i]['competitor_price'] + '|#|' + jsonRecordsData[i]['od_sku'] + '|#|' + jsonRecordsData[i]['od_sku_uom'] + '|#|' + jsonRecordsData[i]['od_sku_qpu'];
                                            
                                            }
                                            
                                            if(CrossReferenceStringSingle.includes('"'))
                                                csvIterativeData += '"' + CrossReferenceStringSingle.replace(/"/g,'""') + '"';   
                                            else
                                                csvIterativeData += '"' + CrossReferenceStringSingle + '"';
                                                

                                }

                            }
                        
                    
                    } else
                        csvIterativeData += '""';
                }
                counter++;
            }
            csvIterativeData += newLineCharacter;
        }


        var universalBOM = "\uFEFF";
        csvIterativeData = csvIterativeData.replace(/undefined/g, '');
        csvIterativeData = csvIterativeData.replace(/null/g, '');
        var x = csvIterativeData;
        var arr = x.split(newLineCharacter);
    
        x = arr.filter(function(value, index, self) { 
            return self.indexOf(value) === index;
        }).join(newLineCharacter);

        if(countNoMatches > 1 && countNoMatches !== 0)
        {
        var array1forNoMatch = []; 
        array1forNoMatch = x.split(newLineCharacter);
        
        var lastElementOfNoMatch =  array1forNoMatch[array1forNoMatch.length - 2];
        console.log('arrayLength111-->'+array1forNoMatch);
        console.log('arrayLength-->'+lastElementOfNoMatch);
        for(let i = 0 ;i<=countNoMatches; i++)
        {
            array1forNoMatch.pop();
        }
        
        array1forNoMatch.push(lastElementOfNoMatch);
        x = array1forNoMatch.join(newLineCharacter);
        }
        
        console.log('countNoMatches-->'+countNoMatches);
        console.log("csvIterativeData--.>", x);
        const XLSX = window.XLSX;
            var wb = XLSX.utils.book_new();
                var workbook = XLSX.read(x, {
                    type: 'binary'
                });
                console.log('WorkBook-->'+JSON.stringify(workbook));
                workbook.SheetNames.push("fields");
                workbook.SheetNames.push("grid");
                var ws_data = [['Reference Currency[ignore]' , 'Local Export[ignore]'],['USD' , 'en_US']];
                var ws = XLSX.utils.aoa_to_sheet(ws_data);
                workbook.Sheets["grid"] = workbook.Sheets['Sheet1'];
                workbook.Sheets["fields"] = ws;
                workbook.SheetNames.splice(0,1);
                XLSX.writeFile(workbook, 'CPQImport.xlsx');
        //this.hrefdata1 = "data:text/csv;charset=utf-8," + encodeURIComponent(universalBOM + x);
    }
    else
        {
            this.MessageToBeDisplayed = 'Please Connect to VPN and try again'
            this.ToastToBeDisplayed = true;

            this.delayTimeout = setTimeout(() => {
                this.ToastToBeDisplayed = false;
            }, this.autoCloseTime);

        }
    }
    else
    {
        this.MessageToBeDisplayed = 'Cannot Download CPQ Import when Filter is Selected as All'
            this.ToastToBeDisplayed = true;

            this.delayTimeout = setTimeout(() => {
                this.ToastToBeDisplayed = false;
            }, this.autoCloseTime);

    }
    }


    getAuthTokenMethod()
    {
        getAuthToken({
        })
        .then(result => {
           this.accessToken = result;
            
                this.getDataForDownloadFunc();
                this.getFilteredDataForCPQImport();
        })
        .catch(error => {
            console.log('error-->' + JSON.stringify(error));

        });
    }

    getDataForDownloadFunc()
    {
        console.log('selected -->'+this.selectedFilter);
        fetch('https://api-internal.officedepot.io/services/sfdc-alternates-service/api/v1/control/getAllFilterResults/'+this.refID+'/'+this.selectedFilter, // Prod End point URL
        //fetch('https://dev-internal.odplabs.com/services/dev-sfdc-alternates-service/api/v1/control/getAllFilterResults/'+this.refID+'/'+this.selectedFilter, // Dev End point URL
            {
                // Request type
                method:"GET",
                
                headers:{
                    // content type
                    "Content-Type": "application/x-www-form-urlencoded",
                    // adding your access token 
                    "Authorization": "Bearer "+this.accessToken,
                }
            }).then(response => response.json())
            .then(data => {
                this.DataForDownloadAll = data;
                let testList = [];
        testList = JSON.parse(JSON.stringify(this.DataForDownloadAll));
        for(let i = 0;i<testList.length;i++)
        {
            
            let uomMultiplier = 0;
            let convertedCost = 0;
            uomMultiplier = testList[i].customer_qpu / testList[i].od_sku_qpu;
            
            if(isFinite(uomMultiplier))
                testList[i]['uom_multiplier'] = uomMultiplier.toFixed(3);
            else
                testList[i]['uom_multiplier'] = 0;
            
            if(this.netCostVisibilityFlag === true)    
                convertedCost = testList[i].customer_usage * (testList[i].customer_qpu / testList[i].od_sku_qpu) * testList[i].wtd_net_cost;
            else
                convertedCost = testList[i].customer_usage * (testList[i].customer_qpu / testList[i].od_sku_qpu) * testList[i].wtd_tdc_cost;
            if(isFinite(convertedCost))
                testList[i]['converted_cost'] = convertedCost.toFixed(2);
            else
                testList[i]['converted_cost'] = 0;    

              
            this.DataForDownloadAll = testList;
        }
            })
            .catch(console.error);
    }

    getFilteredDataForCPQImport()
    {

        fetch('https://api-internal.officedepot.io/services/sfdc-alternates-service/api/v1/control/getAllFilterResults/'+this.refID+'/'+this.selectedFilter, // Prod End point URL
        //fetch('https://dev-internal.odplabs.com/services/dev-sfdc-alternates-service/api/v1/control/getAllFilterResults/'+this.refID+'/'+this.selectedFilter, // Dev End point URL
            {
                // Request type
                method:"GET",
                
                headers:{
                    // content type
                    "Content-Type": "application/x-www-form-urlencoded",
                    // adding your access token 
                    "Authorization": "Bearer "+this.accessToken,
                }
            }).then(response => response.json())
            .then(data => {
                this.DataForDownload = data;
            })
            .catch(console.error);
    }

    downloadAll() 
    {
        if(this.DataForDownloadAll != undefined && this.DataForDownloadAll.length != 0)
        {
            this.DataForDownloadAll = this.downloadSortData('stg_rownum', 'asc', this.DataForDownloadAll);
            let testList = [];
        testList = JSON.parse(JSON.stringify(this.DataForDownloadAll));
        for(let i = 0;i<testList.length;i++)
        {
            
            let uomMultiplier = 0;
            
            //uomMultiplier = Math.round(testList[i].customer_qpu / testList[i].od_sku_qpu);
            uomMultiplier = testList[i].customer_qpu / testList[i].od_sku_qpu;
            
            if(isFinite(uomMultiplier))
                testList[i]['uom_multiplier'] = uomMultiplier;
            else
                testList[i]['uom_multiplier'] = 0;    

             
            this.DataForDownloadAll = testList;
                
            
        }

            let columnHeader;
            let jsonKeys;
            let dataToDownload;
            //alert('Business team---->' + this.netCostVisibilityFlag);
            if (this.NoErrors === true && this.netCostVisibilityFlag === true) {
                columnHeader = ["reference_id", "competitor_product_id", "competitor_description", "orig_competitor_uom", "orig_customer_qpu", "competitor_uom", "customer_qpu", "customer_usage", "competitor_price","competitor_source","xref_type","od_sku","od_sku_description","od_sku_uom","od_sku_qpu","Dept Code","Dept Name","od_sku_vpn","Vendor Source","UOM Multiplier","Wtd Net Cost","Wtd Tdc Cost","Converted Cost","SKU Availability Flag","SKU Availability Flag Reason","Stocking Strategy","Recommendations"]; // This array holds the Column headers to be displayd
                jsonKeys = ["reference_id", "competitor_product_id", "competitor_description", "orig_competitor_uom", "orig_customer_qpu", "competitor_uom", "customer_qpu", "customer_usage", "competitor_price","competitor_source","xref_type","od_sku","od_sku_description","od_sku_uom","od_sku_qpu","department_code","department_name","od_sku_vpn","vendor_source","uom_multiplier","wtd_net_cost","wtd_tdc_cost","converted_cost","sku_availability_flag","sku_availability_flag_reason","stocking_strategy","recommendations"]; // This array holds the keys in the json data  
                dataToDownload = this.DataForDownloadAll;
            }else if (this.NoErrors === true && this.netCostVisibilityFlag === false) {
                 columnHeader = ["reference_id", "competitor_product_id", "competitor_description", "orig_competitor_uom", "orig_customer_qpu", "competitor_uom", "customer_qpu", "customer_usage", "competitor_price","competitor_source","xref_type","od_sku","od_sku_description","od_sku_uom","od_sku_qpu","Dept Code","Dept Name","od_sku_vpn","Vendor Source","UOM Multiplier","Wtd Tdc Cost","Converted Cost","SKU Availability Flag","SKU Availability Flag Reason","Stocking Strategy","Recommendations"]; // This array holds the Column headers to be displayd
                 jsonKeys = ["reference_id", "competitor_product_id", "competitor_description", "orig_competitor_uom", "orig_customer_qpu", "competitor_uom", "customer_qpu", "customer_usage", "competitor_price","competitor_source","xref_type","od_sku","od_sku_description","od_sku_uom","od_sku_qpu","department_code","department_name","od_sku_vpn","vendor_source","uom_multiplier","wtd_tdc_cost","converted_cost","sku_availability_flag","sku_availability_flag_reason","stocking_strategy","recommendations"]; // This array holds the keys in the json data  
                 dataToDownload = this.DataForDownloadAll;
            }else {
                columnHeader = ["Reference_Id", "Status", "Messages"]; // This array holds the Column headers to be displayd
                jsonKeys = ["reference_id", "status", "message"]; // This array holds the keys in the json data
                dataToDownload = this.errorData;
    
            }
            var jsonRecordsData = dataToDownload;
            let csvIterativeData;
    
            let csvSeperator
            let newLineCharacter;
            csvSeperator = ",";
            newLineCharacter = "\n";
            csvIterativeData = "";
            csvIterativeData += columnHeader.join(csvSeperator);
            csvIterativeData += newLineCharacter;
            for (let i = 0; i < jsonRecordsData.length; i++) {
                let counter = 0;
                for (let iteratorObj in jsonKeys) {
                    let dataKey = jsonKeys[iteratorObj];
                    if (counter > 0) {
                        csvIterativeData += csvSeperator;
                    }
                    if (jsonRecordsData[i][dataKey] !== null &&
                        jsonRecordsData[i][dataKey] !== undefined
                    ) {
    
                        if(jsonRecordsData[i][dataKey] !== undefined)
                        {
                            let tempData = jsonRecordsData[i][dataKey];
                            
                            if(String(tempData).includes('"'))
                            {
                                console.log('Data with quotes-->'+ tempData);
                                //jsonRecordsData[i][dataKey] =  String(tempData).replace(/"/g,'\'');
                                csvIterativeData += '"' +  String(tempData).replace(/"/g,'""') + '"';
                            }
                            else
                                csvIterativeData += '"' + jsonRecordsData[i][dataKey] + '"';
                                
                        }
                        else
                            csvIterativeData += '"' + jsonRecordsData[i][dataKey] + '"';
                        
                    } else {
                        csvIterativeData += '"' + '' + '"';
                    }
                    counter++;
                }
                csvIterativeData += newLineCharacter;
            }
    
            var universalBOM = "\uFEFF";
            csvIterativeData = csvIterativeData.replace(/undefined/g, '');
            console.log("csvIterativeData--.>", csvIterativeData);
            const XLSX = window.XLSX;
            var wb = XLSX.utils.book_new();
                var workbook = XLSX.read(csvIterativeData, {
                    type: 'binary'
                });
                console.log('WorkBook-->'+JSON.stringify(workbook));
                
                //XLSX.writeFile(workbook, 'ExportToCSV.xlsx');
            this.hrefdata = "data:text/csv;charset=utf-8," + encodeURIComponent(universalBOM + csvIterativeData);
        }
        else
        {
            this.MessageToBeDisplayed = 'Please Connect to VPN and try again'
            this.ToastToBeDisplayed = true;

            this.delayTimeout = setTimeout(() => {
                this.ToastToBeDisplayed = false;
            }, this.autoCloseTime);

        }       
    }


}