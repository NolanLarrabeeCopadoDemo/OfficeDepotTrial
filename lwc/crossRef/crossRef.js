/* eslint-disable no-unused-vars */
import { LightningElement, api, track,wire } from 'lwc';
import { NavigationMixin } from 'lightning/navigation';  
//import ItemCrossRef from '@salesforce/apex/ItemCrossRef.getFileStatus';
import saveFile from '@salesforce/apex/ItemCrossRef.saveFile';
import ItemCrossRef from '@salesforce/apex/ItemCrossRef.saveFile';
import getControlRecordsByQuoteId from '@salesforce/apex/ItemCrossRef.getControlRecordsByQuoteId';
import sendRefIdToProcessMatch from '@salesforce/apex/ItemCrossRef.sendRefIdToProcessMatch';
import {ShowToastEvent} from 'lightning/platformShowToastEvent';
import {refreshApex} from '@salesforce/apex';

import { loadScript } from "lightning/platformResourceLoader";
import workbook from "@salesforce/resourceUrl/xlsx";
const columns = [
    { label: 'Ref Id', fieldName: 'reference_id', type: 'string', sortable: true, cellAttributes: { alignment: 'left' }},
    { label: 'File Name', fieldName: 'file_name', type: 'string', sortable: true, cellAttributes: { alignment: 'left' }},
    { label: 'Created By', fieldName: 'created_by_id', type: 'string', sortable: true, cellAttributes: { alignment: 'left' }},
    { label: 'Uploaded Date', fieldName: 'sys_created_date', type: 'string', sortable: true, cellAttributes: { alignment: 'left' }},
    { label: 'Status', fieldName: 'status', type: 'string', sortable: true, cellAttributes: { alignment: 'left' }},
    { label: 'Reason', fieldName: 'reason', type: 'string', sortable: true, cellAttributes: { alignment: 'left' }},
    { label: 'Results', fieldName: 'resultLink', type: 'url', typeAttributes: {label: 'View Result'}, sortable: true, cellAttributes: { alignment: 'left', disabled : true }}
];

export default class ItemXrefFile extends LightningElement {

    librariesLoaded = false;
  renderedCallback() {
    console.log("renderedCallback xlsx");
    if (this.librariesLoaded) return;
    this.librariesLoaded = true;
    Promise.all([loadScript(this, workbook + "/xlsx/filexlsx.full.min.js")])
      .then(() => {
        console.log("success");
      })
      .catch(error => {
        console.log("failure");
      });
  }
    @api recordId;
    @track columns = columns;
    @track data;
    @track fileName = '';
    @track UploadFile = 'Upload Bid File';
    @track Refresh = 'Refresh';
    @track showLoadingSpinner = false;
    @track data = [];
    @track sortedBy = 'sys_created_date'; 
    @track sortedDirection = 'desc';
    @track refreshDateTime;
    @track isTrue = false;
    @track recordsCount = 0;
    filesUploaded = [];
    file;
    fileContents;
    fileReader;
    content;
    MAX_FILE_SIZE = 2097152;//2MB

    // non-reactive variables
    selectedRecords = [];
    refreshTable;
    error;
    @track error;

    

    connectedCallback() {
        this.getControlRecordsByQuoteId();
        this.sortData(this.sortedBy, this.sortedDirection);
    }

    refreshdata(){
        this.getControlRecordsByQuoteId();
        var today = new Date();
        this.refreshDateTime  = 'Refreshed at : ' + today.getHours() + ":" + today.getMinutes() + ":" + today.getSeconds();
    }

    // getting file 
    handleFilesChange(event) {
        if(event.target.files.length > 0) {
            this.filesUploaded = event.target.files;
            this.fileName = event.target.files[0].name;
        }
    }

    handleSave() {
        if(this.filesUploaded.length > 0) {
            this.uploadHelper();
        }
        else {
            this.fileName = 'Please select file to upload!!';
        }
    }

    uploadHelper() {
        this.file = this.filesUploaded[0];
        console.log('Test-->'+this.file);
        if (this.file.size > this.MAX_FILE_SIZE) {
            window.console.log('File Size is too long. ');
            alert('File size is too long. Make sure file size is up to 2MB');
            return ;
        }
        this.fileReader= new FileReader();
        this.fileReader.onloadend = (() => {
            if (this.fileName.endsWith('.xlsx') == false) {
                this.dispatchEvent(
                    new ShowToastEvent({
                        title: '',
                        message: 'Please Upload xlsx file only',
                        variant: 'error',
                    }),
                );
            return;
            }
            
            if(this.fileName.search(" ") >= 0){
                alert('Space in the file name has been replaced with hypen');
            }
            this.showLoadingSpinner = true;
                var data = this.fileReader.result;
                const XLSX = window.XLSX;
                var workbook = XLSX.read(data, {
                    type: 'binary'
                });
                console.log('WorkBook-->'+workbook.Sheets['Sheet1']);
                var sheetNameContent;
                workbook.SheetNames.forEach(function(sheetName) {
                    // Here is your object
                    //var XL_row_object = XLSX.utils.sheet_to_csv(workbook.Sheets[sheetName]);
                    //var json_object = JSON.stringify(XL_row_object);
                    //console.log('Test111-->'+XL_row_object);
                    sheetNameContent = sheetName;
                  })
            this.fileName = this.fileName.substring(0, this.fileName.length - 4);
            this.fileName = this.fileName + 'csv';
            console.log('FileName-->'+this.fileName); 
            this.fileContents = btoa(XLSX.utils.sheet_to_csv(workbook.Sheets[sheetNameContent]));
            //let base64 = 'base64,';
            //console.log('Testing-->'+this.fileContents.indexOf(base64))
            //this.content = this.fileContents.indexOf(base64) + base64.length;
            //this.fileContents = this.fileContents.substring(this.content);
            console.log('Tetsing-->'+encodeURIComponent(this.fileContents));
            console.log('Testing-->'+this.fileContents);
            this.saveToFile();
        });
    
        this.fileReader.readAsBinaryString(this.file)//readAsDataURL(this.file);
    }

    // Calling apex class to insert the file
    saveToFile() {
        saveFile({ idParent: this.recordId, strFileName: this.fileName, base64Data: encodeURIComponent(this.fileContents)})
        .then(result => {
            window.console.log('result ====> ' +result);
            this.getControlRecordsByQuoteId();
            this.fileName = this.fileName + ' - Uploaded Successfully';
            this.UploadFile = 'Upload Bid File';
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
            console.error(JSON.stringify(error));//window.log
            this.dispatchEvent(
                new ShowToastEvent({
                    title: 'Error while uploading File',
                    message: error.message,
                    variant: 'error',
                }),
            );
        });
    }
// Getting releated files of the current record
    getControlRecordsByQuoteId() {
        getControlRecordsByQuoteId({quoteId: this.recordId})
        .then(data => {
            this.data = data;
        })
        
        .catch(error => {
            this.dispatchEvent(
                new ShowToastEvent({
                    title: 'Error while getting file uploaded results',
                    message: error.message,
                    variant: 'error',
                }),
            );
        });
        
        }
// Getting selected rows to perform any action
    getSelectedRecords(event) {
        let conDocIds;
        const selectedRows = event.detail.selectedRows;
        conDocIds = new Set();
        for (let i = 0; i < selectedRows.length; i++){
            conDocIds.add(selectedRows[i].ContentDocumentId);
        }

        this.selectedRecords = Array.from(conDocIds).join(',');

        window.console.log('selectedRecords =====> '+this.selectedRecords);
    }

    get acceptedFormats() {
        return '.xlsx';
    }

    handleUploadFinished(event) {
        // Get the list of uploaded files
        const uploadedFiles = event.detail.files;
    }

    callRowAction( event ) {
        const row = event.detail.row;
        var strList = row.resultLink.split('=');
        sendRefIdToProcessMatch({referenceId:strList[1]})
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
        });
  
    } 
    @wire (ItemCrossRef, {quoteId:'$recordId'}) wiredFileUploadStatus({error,data }) {
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
}