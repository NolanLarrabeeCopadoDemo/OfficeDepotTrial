import { LightningElement, track,api,wire} from 'lwc';
import getCrossRefRecords from '@salesforce/apex/CrossRefMaster.getCrossRefRecords';
import saveFile from '@salesforce/apex/CrossRefMaster.saveFile';
import getControlRecords from '@salesforce/apex/CrossRefMaster.getControlRecords';
import sendRefIdToProcessMaster from '@salesforce/apex/CrossRefMaster.sendRefIdToProcessMaster';
import getErrorRecords from '@salesforce/apex/CrossRefMaster.getErrorRecords';
import addCrossRefRecords from '@salesforce/apex/CrossRefMaster.addCrossRefRecords';
import updateCrossRefRecords from '@salesforce/apex/CrossRefMaster.updateCrossRefRecords';
import deleteCrossRefRecords from '@salesforce/apex/CrossRefMaster.deleteCrossRefRecords';
import {refreshApex} from '@salesforce/apex';
import { ShowToastEvent } from 'lightning/platformShowToastEvent'
const columns = [
    { label: 'Competitor Product Id', fieldName: 'orig_item',editable: true },
    { label: 'Competitor Name', fieldName: 'competitor',editable: true },
    { label: 'Competitor UOM', fieldName: 'customer_uom',editable: true },
    { label: 'Customer QPU', fieldName: 'customer_qpu',editable: true },
    { label: 'Source', fieldName: 'vendor_source',editable: true },
    { label: 'Type', fieldName: 'cross_match_type',editable: true},
    { label: 'OD Sku', fieldName: 'od_xref',type: 'string',cellAttributes: { alignment: 'left' },editable: true},
    { label: 'OD Sku UOM', fieldName: 'corr_uom',editable: true},
    { label: 'OD Sku QPU', fieldName: 'corr_qpu',editable: true},
    { label: 'Cross Notes Details', fieldName: 'cross_notes_detail',editable: true},
    { label: 'Modified By', fieldName: 'last_updated_id',editable: true},
    { label: 'Modified Date', fieldName: 'sys_modified_date',editable: true},
];
//File Upload Grid Columns
const filecolumns = [
    { label: 'File Name', fieldName: 'file_name', type: 'string', sortable: true, cellAttributes: { alignment: 'left' }},
    { label: 'Created By', fieldName: 'created_by_id', type: 'string', sortable: true, cellAttributes: { alignment: 'left' }},
    { label: 'Uploaded Date', fieldName: 'sys_created_date', type: 'string', sortable: true, cellAttributes: { alignment: 'left' }},
    { label: 'Status', fieldName: 'status', type: 'string', sortable: true, cellAttributes: { alignment: 'left' }},
    { label: 'Reason', fieldName: 'reason', type: 'string', sortable: true, cellAttributes: { alignment: 'left' }},
    { label: 'Reference Id',fieldName: 'reference_id', type: 'string', sortable: true, cellAttributes: { alignment: 'left', disabled : false }},
    { label: 'Display Errors', fieldName: 'resultLink', type: 'button', typeAttributes: {label: 'View Errors'}, sortable: true, cellAttributes: { alignment: 'left', disabled : false }}
];
//Error Message Columns
const errorColumns = [
    {label: 'Reference Id', fieldName: 'reference_id', type: 'number', sortable: "true", cellAttributes: {alignment: 'left'}},
    {label: 'Status',fieldName: 'status',type: 'string',sortable: "true",cellAttributes: {alignment: 'left'}},
    {label: 'Error Message',fieldName: 'message',type: "string",sortable: "true",cellAttributes: {alignment: 'left'}}
];


export default class CrossRefMaster extends LightningElement {
    @track columns = columns;
    //Hardcoded for Testing purposes.
    @track crossRefMasterRecords = [];
    @track dataLoaded = true;
    @track draftValues = [];
    @track ProductId;
    @track Competitor;
    @track ODsku;
    @track isOpenModal = false;
    @track CompetitorProductId;
    @track CompetitorName;
    @track CompetitorUOM;
    @track CustomerQPU;
    @track CrossNotesDetails;
    @track Type;
    @track SourceValue;
    @track ODSku;
    @track AlwaysTrue = true;
    @track ModByValue;
    @track ModDateValue;
    @track ODSkuUOM;
    @track ODSkuQPU;
    @track ToastToBeDisplayed = false;
    @track MessageToBeDisplayed;
    @track autoCloseTime = 5000;
    @track isAdd = false;
    @track recordToBeDeleted = [];
    @track searchCriteria = {
        "competitor_product_id" : "",
        "competitor_source" : "",
        "od_sku" : "",
        "date_modified" : "",
        "changed_by" : ""
    }

    //File upload variables
    @api recordId;
    @api totalNumberOfRows; 
    @track filecolumns = filecolumns;
    @track data;
    @track fileName = '';
    @track UploadFile = 'Upload Master Maintenance';
    @track showLoadingSpinner = false;
    @track data = [];
    @track sortedBy = 'sys_created_date';
    @track sortedDirection = 'asc';
    @track isTrue = false;
    @track recordsCount = 0;
    @track Refresh = 'Refresh';
    @track refreshDateTime;
    loadMoreStatus;
    filesUploaded = [];
    file;
    fileContents;
    fileReader;
    content;
    MAX_FILE_SIZE = 2097152;
    selectedRecords = [];
    error;
    @track fetchData;
    @track error;
    data = [];

    //Error Message Variables
    @api referenceId;
    @api fileName;
    @track errorColumns = errorColumns;
    @track errorData;
    @track isErrorMessageOpenModal = false;
   // @track isMasterMaintAllowed = false;
   // @track isMasterMaintButtonsDisabled = false;
    

    productKey(event) {
        
        if (this.ProductId !== '' || this.ProductId !== null) {
            console.log("test produ-->"+this.ProductId);
          this.ProductId = event.target.value;
        }
    
      }

    competitorKey(event) {
        if (this.Competitor !== '' || this.Competitor !== null) {
            console.log("test comkey-->"+this.Competitor);
          this.Competitor = event.target.value;
        }
    
      }
      
    odskuKey(event) {
        if (this.ODsku !== '' || this.ODsku !== null) {
            console.log("test odsku-->"+this.ODSku);
          this.ODsku = event.target.value;
        }
    
      }
    
    modByChange(event) {
        if (this.ModByValue !== '' || this.ModByValue !== null) {
            console.log("test odsku-->"+this.ModByValue);
        this.ModByValue = event.target.value;
        }
    
    }

    modDateChange(event) {
        if (this.ModDateValue !== '' || this.ModDateValue !== null) {
            console.log("test odsku-->"+this.ModDateValue);
          this.ModDateValue = event.target.value;
        }
    
      }
    
    IDChange(event) {
        if (this.CompetitorProductId !== '') {
          this.CompetitorProductId = event.target.value;
        }
    }    
    NameChange(event) {
        if (this.CompetitorName !== '') {
            this.CompetitorName = event.target.value;
        }    
    }
    UOMChange(event) {
        if (this.CompetitorUOM !== '') {
            this.CompetitorUOM = event.target.value;
        }    
    }
    QPUChange(event) {
        if (this.CustomerQPU !== '') {
            this.CustomerQPU = event.target.value;
        }    
    }
    SourceChange(event) {
        if (this.SourceValue !== '') {
            this.SourceValue = event.target.value;
        }
    }
    CrossNotesChange(event) {
        if (this.CrossNotesDetails !== '') {
            this.CrossNotesDetails = event.target.value;
        }
    }          
    TypeChange(event) {
        if (this.Type !== '') {
            this.Type = event.target.value;
        }
    }    
    ODSkuChange(event) {
        if (this.ODSku !== '') {
            this.ODSku = event.target.value;
        }
    }    
    ODSkuUOMChange(event) {
        if (this.ODSkuUOM !== '') {
            this.ODSkuUOM = event.target.value;
        }
    }    
    ODSkuQPUChange(event) {
        if (this.ODSkuQPU !== '') {
            this.ODSkuQPU = event.target.value;
        }
    }    

    DeleteRecord(event){
        if(this.recordToBeDeleted.length <= 1 && this.recordToBeDeleted.length > 0)
        {
        console.log('Record to be deleted -->'+JSON.stringify(this.recordToBeDeleted));
        deleteCrossRefRecords({payLoad: JSON.stringify(this.recordToBeDeleted[0])})
        .then(data => {
           if(data !== null && data === 'Success')
           {
               let removeDeletedRecord = [];
            for(let i=0; i<this.crossRefMasterRecords.length;i++)
            {
                if(this.crossRefMasterRecords[i] === this.recordToBeDeleted[0])
                {}
                else
                    removeDeletedRecord.push(this.crossRefMasterRecords[i])
            }
            var table = this.template.querySelector('lightning-datatable');
            table.data = JSON.parse(JSON.stringify(removeDeletedRecord));
            this.crossRefMasterRecords = removeDeletedRecord;
            console.log('testing delete-->'+JSON.stringify(this.crossRefMasterRecords));
            this.ToastToBeDisplayed = true;
            this.MessageToBeDisplayed = 'Record Deleted Successfully.' 
            this.delayTimeout = setTimeout(() => {
            this.ToastToBeDisplayed = false;
        }, this.autoCloseTime);
            this.isOpenModal = false;

           }
           else
           {
               
            this.isOpenModal = false;
            this.ToastToBeDisplayed = true;
            this.MessageToBeDisplayed = 'Record Deleted Unsuccessfully.'; 
            this.delayTimeout = setTimeout(() => {
            this.ToastToBeDisplayed = false;
        }, this.autoCloseTime);

           }

        })
    }
    else{
        this.isOpenModal = false;
            this.ToastToBeDisplayed = true;
            this.MessageToBeDisplayed = 'Select a record to be deleted.' 
            this.delayTimeout = setTimeout(() => {
                this.ToastToBeDisplayed = false;
            }, this.autoCloseTime);
    }
    }

    /*EditRecord(event) {
        
        if(this.recordToBeDeleted.length <= 1 && this.recordToBeDeleted.length > 0)
        {
            this.isAdd = false;
            this.isOpenModal = true;
            this.CompetitorProductId = this.recordToBeDeleted[0].orig_item;
            this.CompetitorName = this.recordToBeDeleted[0].competitor;
            this.CompetitorUOM = this.recordToBeDeleted[0].customer_uom;
            this.CustomerQPU = this.recordToBeDeleted[0].customer_qpu;
            this.CompetitorUsage = this.recordToBeDeleted[0].competitor_usage;
            this.CompetitorPrice = this.recordToBeDeleted[0].competitor_price;
            this.Type = this.recordToBeDeleted[0].cross_match_type;
            this.ODSku = this.recordToBeDeleted[0].od_xref;
            this.ODSkuQPU = this.recordToBeDeleted[0].corr_qpu;
            this.ODSkuUOM = this.recordToBeDeleted[0].corr_uom;
            
        }
        else
        {
            this.isOpenModal = false;
            this.ToastToBeDisplayed = true;
            this.MessageToBeDisplayed = 'Select a record to be edited.' 
            this.delayTimeout = setTimeout(() => {
                this.ToastToBeDisplayed = false;
            }, this.autoCloseTime);
        }

    }*/

    AddRecord(event) {
        this.isAdd = true;
        this.isOpenModal = true;
        this.CompetitorProductId = null;
        this.CompetitorName = null;
        this.CompetitorUOM = null;
        this.CustomerQPU = null;
        this.SourceValue = null;
        this.CrossNotesDetails = null;
        this.Type = null;
        this.ODSku = null;
        this.ODSkuQPU = null;
        this.ODSkuUOM = null;


    }

    SaveEditedRecord(){

        //let filteredDataList = [];
        if(this.isAdd === false)
        {
        /*const index = this.findRowIndexById(this.CompetitorProductId);
        this.crossRefMasterRecords[index].orig_item = this.CompetitorProductId;
        this.crossRefMasterRecords[index].competitor = this.CompetitorName;
        this.crossRefMasterRecords[index].customer_uom = this.CompetitorUOM;
        this.crossRefMasterRecords[index].customer_qpu = this.CustomerQPU;
        this.crossRefMasterRecords[index].competitor_usage = this.CompetitorUsage;
        this.crossRefMasterRecords[index].competitor_price = this.CompetitorPrice;
        this.crossRefMasterRecords[index].cross_match_type = this.Type;
        this.crossRefMasterRecords[index].od_xref = this.ODSku;
        this.crossRefMasterRecords[index].corr_qpu = this.ODSkuQPU;
        this.crossRefMasterRecords[index].corr_uom = this.ODSkuUOM;

        
        
        */
        
    }
        
        if(this.isAdd === true)
        {
            
        let recordToBeAdded = {"orig_item":this.CompetitorProductId,"competitor":this.CompetitorName,"customer_uom":this.CompetitorUOM,"customer_qpu":this.CustomerQPU,"vendor_source":this.SourceValue,"competitor_price":this.CompetitorPrice,"competitor_usage":this.CompetitorUsage,"cross_match_type":this.Type,"od_xref":this.ODSku,"corr_uom":this.ODSkuUOM,"corr_qpu":this.ODSkuQPU,"cross_notes_detail":this.CrossNotesDetails};
        console.log('record to be added-->'+JSON.stringify(recordToBeAdded));
        addCrossRefRecords({payLoad: JSON.stringify(recordToBeAdded)})
        .then(data => {
           if(data !== null && data === 'Success')
           {
            this.crossRefMasterRecords.push(recordToBeAdded);
            console.log('testing-->');
            var table = this.template.querySelector('lightning-datatable');
            table.data = JSON.parse(JSON.stringify(this.crossRefMasterRecords));

            this.ToastToBeDisplayed = true;
            this.MessageToBeDisplayed = 'Record Added Successfully.' 
            this.delayTimeout = setTimeout(() => {
            this.ToastToBeDisplayed = false;
        }, this.autoCloseTime);
            this.isOpenModal = false;

           }
           else
           {
               
            this.isOpenModal = false;
            this.ToastToBeDisplayed = true;
            this.MessageToBeDisplayed = data; 
            this.delayTimeout = setTimeout(() => {
            this.ToastToBeDisplayed = false;
        }, this.autoCloseTime);

           }

        })
        
        }
    }

    handleSaveForEdit(event) {

        const recordInputs = event.detail.draftValues;
        let tempPickList = JSON.parse(JSON.stringify(this.crossRefMasterRecords));


        for (let i = 0; i < recordInputs.length; i++) {

            for (let j = 0; j < this.crossRefMasterRecords.length; j++) {
                let rowNumber = 'row-' + j;


                if (recordInputs[i].competitor_product_id === rowNumber) {
                    if(recordInputs[i]['competitor'] !== undefined)
                    {
                        
                    tempPickList[j].competitor = recordInputs[i].competitor;

                    }
                    if(recordInputs[i]['orig_item'] !== undefined)
                    {
                        
                    tempPickList[j].orig_item = recordInputs[i].orig_item;

                    }
                    if(recordInputs[i]['customer_uom'] !== undefined)
                    {
                        
                    tempPickList[j].customer_uom = recordInputs[i].customer_uom;

                    }
                    if(recordInputs[i]['customer_qpu'] !== undefined)
                    {
                        
                    tempPickList[j].customer_qpu = recordInputs[i].customer_qpu;

                    }
                    if(recordInputs[i]['competitor_usage'] !== undefined)
                    {
                        
                    tempPickList[j].competitor_usage = recordInputs[i].competitor_usage;

                    }
                    if(recordInputs[i]['competitor_price'] !== undefined)
                    {
                        
                    tempPickList[j].competitor_price = recordInputs[i].competitor_price;

                    }
                    if(recordInputs[i]['cross_match_type'] !== undefined)
                    {
                        
                    tempPickList[j].cross_match_type = recordInputs[i].cross_match_type;

                    }
                    if(recordInputs[i]['od_xref'] !== undefined)
                    {
                        
                    tempPickList[j].od_xref = Number(recordInputs[i].od_xref);

                    }
                    if(recordInputs[i]['corr_qpu'] !== undefined)
                    {
                        
                    tempPickList[j].corr_qpu = recordInputs[i].corr_qpu;

                    }
                    if(recordInputs[i]['corr_uom'] !== undefined)
                    {
            
                    tempPickList[j].corr_uom = recordInputs[i].corr_uom;

                    }
                }

            }

        }

        
        console.log('Edited Values-->'+ JSON.stringify(tempPickList));

        updateCrossRefRecords({payLoad: JSON.stringify(tempPickList[0])})
        .then(data => {
           if(data !== null && data !== 'Error')
           {
            tempPickList[0].od_xref = String(tempPickList[0].od_xref);
            this.crossRefMasterRecords = tempPickList;
            this.ToastToBeDisplayed = true;
            this.MessageToBeDisplayed = 'Record Edited Successfully.' 
            this.delayTimeout = setTimeout(() => {
            this.ToastToBeDisplayed = false;
        }, this.autoCloseTime);

            this.isOpenModal = false;

           }
           else
           {
            this.isOpenModal = false;
            this.ToastToBeDisplayed = true;
            this.MessageToBeDisplayed = 'Record Edited Unsuccessfully.' 
            this.delayTimeout = setTimeout(() => {
            this.ToastToBeDisplayed = false;
        }, this.autoCloseTime);
        

           }

        })

        this.draftValues = [];

    }
    
    closeModel() {
        this.ToastToBeDisplayed = false;
    }

    handleCloseModal() {
        this.isOpenModal = false;
    }
    
    getSelectedRecords(event) {
        const selectedRows = event.detail.selectedRows;
        console.log('selectedRecords set ====> ' +JSON.stringify(selectedRows));
        //this.recordsCount = event.detail.selectedRows.length;
        if(selectedRows.length <= 1)
        {        
            this.ToastToBeDisplayed = false;   
            // this set elements the duplicates if any
            let conIds = new Set();
            
            // getting selected record id
            for (let i = 0; i < selectedRows.length; i++) {
                conIds.add(selectedRows[i]);
            }
            
            
            // coverting to array
            this.recordToBeDeleted = Array.from(conIds);
        }
        else
        {
            this.dispatchEvent(
                new ShowToastEvent({
                    title: 'Error!!',
                    message: 'Only one record can be edited at a time.',
                    variant: 'error',
                }),
            );
        }

    }

    findRowIndexById(id) {
        let ret = -1;
        this.crossRefMasterRecords.some((row, index) => {
            if (row.orig_item === id) {
                ret = index;
            }
        });
        console.log("test index-->"+ret);
        return ret;
    }

    handleSearch() {
        this.dataLoaded = false;
       
        if(this.ProductId === undefined || this.ProductId === "")
            this.searchCriteria.competitor_product_id="";
        else
            this.searchCriteria.competitor_product_id=this.ProductId; 

        if(this.Competitor === undefined || this.Competitor === "")
            this.searchCriteria.competitor_source="";
        else
            this.searchCriteria.competitor_source=this.Competitor;
            
        if(this.ODsku === undefined || this.ODsku === "")
            this.searchCriteria.od_sku="";
        else
            this.searchCriteria.od_sku=this.ODsku; 
            
        if(this.ModByValue === undefined || this.ModByValue === "")
            this.searchCriteria.changed_by="";
        else
            this.searchCriteria.changed_by=this.ModByValue;
        
        if(this.ModDateValue === undefined || this.ModDateValue === "")
            this.searchCriteria.date_modified="";
        else
            this.searchCriteria.date_modified=this.ModDateValue;
        
        console.log('Test-->'+JSON.stringify(this.searchCriteria));

        getCrossRefRecords({searchCriteria: JSON.stringify(this.searchCriteria)})
        .then(data => {
        this.dataLoaded = true;
           this.crossRefMasterRecords = JSON.parse(JSON.stringify(data));
        })
        .catch(error => {
            this.dataLoaded = true;
           console.log('Error-->'+error);
           this.ToastToBeDisplayed = true;
            this.MessageToBeDisplayed = 'Please Enter More Details in Search Criteria.' 
            this.delayTimeout = setTimeout(() => {
            this.ToastToBeDisplayed = false;
        }, this.autoCloseTime);
        });
    }

    //File Upload
    get acceptedFormats() {
        return '.csv';
    }

    connectedCallback() {
       // if (this.isMasterMaintAllowed == true) { 
       //     this.isMasterMaintButtonsDisabled = false;
            this.getControlRecords();
            this.sortData(this.sortedBy, this.sortedDirection);
       // } else {
       //     this.isMasterMaintButtonsDisabled = true;
       //     alert('Sorry, you do not have permission to access this page.');
       // }
    }

    refreshdata(){
        this.getControlRecords();
        var today = new Date();
        this.refreshDateTime  = 'Refreshed at : ' + today.getHours() + ":" + today.getMinutes() + ":" + today.getSeconds();
    }

    handleSave() {
        if(this.filesUploaded.length > 0) {
            this.uploadHelper();
        }
        else {
            this.fileName = 'Please select file to upload!!';
        }
    }
    handleFilesChange(event) {
        if(event.target.files.length > 0) {
            this.filesUploaded = event.target.files;
            this.fileName = event.target.files[0].name;
        }
    }
    get acceptedFormats() {
        return '.csv';
    }
    handleUploadFinished(event) {
    const uploadedFiles = event.detail.files;
    }  
    
    callRowAction( event ) {
        //alert('In Call Row Action');
        const row = event.detail.row;
        //alert(row.reference_id);
        this.referenceId = row.reference_id;
        this.getErrorRecords1();
        this.isErrorMessageOpenModal = true;
        
        //alert(row.reference_id + 'geterrorrecords');
       
        /*var strList = row.resultLink.split('=');
        sendRefIdToProcessMaster({referenceId:strList[1]})
        .then(data =>{
            this.dispatchEvent(
                new ShowToastEvent({
                   // title: 'Success!!',
                    message: ' Requested to start processing ' + row.file_name,
                    variant: 'success',
                }),
            );
            
        })
        
        .catch(error => {
            alert(error.message);
            this.error = error.message;
        });*/
  
    }

    getErrorRecords1() {
        //alert('hereis geterror records....1');
        getErrorRecords({referenceId:this.referenceId})
        .then(data => {
            this.errorData = data;
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
    
    handleErrorCloseModal() {
        this.isErrorMessageOpenModal = false;
    }
   

    uploadHelper() {
        this.file = this.filesUploaded[0];
        if (this.file.size > this.MAX_FILE_SIZE) {
            window.console.log('File Size is too long');
            alert('File size is too long. Make sure file size is up to 2MB');
            return ;
        }
        //alert(this.file.size);
        if (this.file.size <= 188 ) {
            window.console.log('File is empty');
            alert('File is empty');
            return ;
        }
        this.fileReader= new FileReader();
        this.fileReader.onloadend = (() => {
        if (this.fileName.endsWith('.csv') == false) {
                this.dispatchEvent(
                    new ShowToastEvent({
                        title: '',
                        message: 'Please Upload csv file only',
                        variant: 'error',
                    }),
                );
        return;
            }
            if(this.fileName.search(" ") >= 0){
                alert('Space in the file name has been replaced with hypen');
            }    
            this.showLoadingSpinner = true;
            this.fileContents = this.fileReader.result;
            let base64 = 'base64,';
            this.content = this.fileContents.indexOf(base64) + base64.length;
            this.fileContents = this.fileContents.substring(this.content);
            // call the uploadProcess method 
            this.saveToFile();
        });
        this.fileReader.readAsDataURL(this.file);
    }
    saveToFile() {
        saveFile({ strFileName: this.file.name, base64Data: encodeURIComponent(this.fileContents)})
            .then(result => {
            window.console.log('result ====> ' +result);
            this.getControlRecords();
            this.fileName = this.fileName + ' - Uploaded Successfully';
            this.UploadFile = this.UploadFile//'File Uploaded Successfully';
            this.isTrue = true;
            this.showLoadingSpinner = false;
            this.dispatchEvent(
                    new ShowToastEvent({
                    title: 'Success!!',
                    message: this.file.name + ' - Uploaded Successfully!!!',
                    variant: 'success',
                    }),
            );
            })
            .catch(error => {
            window.console.log(error);
            this.dispatchEvent(
                new ShowToastEvent({
                    title: 'Error while uploading File',
                    message: error.message,
                    variant: 'error',
                }),
            );
        });
    }
    getControlRecords() {
        getControlRecords()
        .then(data => {
            this.data = data;
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
    
    @wire (getControlRecords, {recordId:'$recordId'}) wiredFileUploadStatus({error,data }) {
        if (data) {
                this.data =[];
        for (let fileStatusRow of data)
            {
            this.data.push(fileStatusRow);
            }
        }
    }
    sortData(sortedBy, sortedDirection) {
        this.data.sort((a, b) => {
            return a[sortedBy] > b[sortedBy] ? 1 : -1;
        });
        if (sortedDirection === 'asc') {
            this.data.reverse();
        }
        this.data = JSON.parse(JSON.stringify(this.data));
    }
    updateColumnSorting(event) {
        this.sortedBy = event.detail.fieldName;
        this.sortedDirection = event.detail.sortDirection;
        this.sortData(this.sortedBy, this.sortedDirection);
    }
    loadMoreData(event) {
        //Display a spinner to signal that data is being loaded
        event.target.isLoading = true;// if it is false scroll bar disappears
        //Display "Loading" when more data is being loaded
        /*this.loadMoreStatus = 'Loading'; //fix it
        fetchData(1)
            .then((data) => {
                if (data.length >= this.totalNumberOfRows) {
                    event.target.enableInfiniteLoading = true;//false;
                    this.loadMoreStatus = 'No more data to load';
                } else {
                    const currentData = this.data;
                    //Appends new data to the end of the table
                    const newData = currentData.concat(data);
                    this.data = newData;
                    this.loadMoreStatus = '';
                }
                event.target.isLoading = false; //true;
            });*/
    }

}