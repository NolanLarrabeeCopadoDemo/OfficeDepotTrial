import { LightningElement,api,wire,track } from 'lwc';
import { getRecord, getFieldValue } from 'lightning/uiRecordApi';
import Notes_field from '@salesforce/schema/Quote.Notes_To_Customer__c';
import getQuoteDocument from '@salesforce/apex/customerQuoteApproval.getQuoteDocument';
import approvalHelper from '@salesforce/apex/customerQuoteApproval.approvalHelper';
import rejectHelper from '@salesforce/apex/customerQuoteApproval.rejectHelper';
import moreInfoHelper from '@salesforce/apex/customerQuoteApproval.moreInfoHelper'; 
import saveFile from '@salesforce/apex/customerQuoteApproval.saveFile';
import od_logo from '@salesforce/resourceUrl/ODHorizontalLogoRed';

export default class CustomerQuoteApproval extends LightningElement {
    @track defaultpage=true;
    @track responseRecived;
    @track customerComments;
    @track fileName = '';
    @track UploadFile = 'Upload File';
    @track showLoadingSpinner;
    @track isTrue = false;
    @track urlrsvd;
    customercomments;
    filesUploaded = [];
    file;
    fileContents;
    fileReader;
    content;
    MAX_FILE_SIZE = 1500000;
    @track docuploaddecision;
    @track showUploadPDF;
    @track showThreeButtons= true;
    @track uploadButton;
    @track docUploaded;
    @track showSubmitButton;
    @api recordId;
    odlogo = od_logo;
    @wire(getQuoteDocument, {custmrApprvlInfrmtnId: '$recordId' }) quotecd;
    @wire(getRecord, { recordId: '$recordId' , fields: [Notes_field]})Quotedetails;
    get Notes() {
        return getFieldValue(this.Quotedetails.data ,Notes_field );
    }
    get acceptedFormats() {
        return ['.pdf', '.png','jpg','docx'];
    } 
    customercommentschange (event) {
        let custmrCmmnts=event.target.value;
        this.customercomments= custmrCmmnts;
    }
    handleClickApproval () {
        this.showLoadingSpinner = true;
        this.showThreeButtons = false;
        this.showUploadPDF = true;
        this.showLoadingSpinner = false;
    } 
    handleClickReject () {
        this.showLoadingSpinner = true;
        if(this.customercomments !== '' & this.customercomments !== undefined) {
            this.showThreeButtons = false;
            rejectHelper({custmrApprvlInfrmtnId: this.recordId , customerComments : this.customercomments });    
            this.showLoadingSpinner = false;
            this.responseRecived = true;
            this.defaultpage = false;
            console.log('this is not bug',this.customercomments);
         } 
         else if(this.customercomments === undefined){
             console.log('this is bug',this.customercomments);
            this.showThreeButtons = true;
            this.showLoadingSpinner = false;
            window.alert('Please enter comments');
        }  
    }
    handleClickMore (){
        this.showLoadingSpinner = true;
        if(this.customercomments !== '' & this.customercomments !== undefined) {
        this.showThreeButtons = false;
        moreInfoHelper({custmrApprvlInfrmtnId: this.recordId ,customerComments : this.customercomments });
        this.showLoadingSpinner = false;
            this.responseRecived = true;
            this.defaultpage = false;
        } 
        else if(this.customercomments === undefined){
            console.log('this is bug',this.customercomments);
           this.showThreeButtons = true;
           this.showLoadingSpinner = false;
           window.alert('Please enter comments');
       }  
    }
    handleUploadDocument () {
        this.docuploaddecision = true;
        this.showUploadPDF = false;
       this.uploadButton = true; 
    }
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
       if (this.file.size > this.MAX_FILE_SIZE) {
            window.console.log('File Size is to long');
            return ;
        }
        this.showLoadingSpinner = true;
        // create a FileReader object 
        this.fileReader= new FileReader();
        // set onload function of FileReader object  
        this.fileReader.onloadend = (() => {
            this.fileContents = this.fileReader.result;
            let base64 = 'base64,';
            this.content = this.fileContents.indexOf(base64) + base64.length;
            this.fileContents = this.fileContents.substring(this.content);
            
            // call the uploadProcess method 
            this.saveToFile();
        });
    
        this.fileReader.readAsDataURL(this.file);
    }
    handleNoUploadDocument () {
        this.docuploaddecision = false;
        this.uploadButton= false;
        this.showSubmitButton = true;
        this.showUploadPDF = false;
    }
    handleSubmit () {
        this.showLoadingSpinner = true;
        approvalHelper({custmrApprvlInfrmtnId: this.recordId , docUploaded : this.docuploaddecision , customerComments : this.customercomments });
        this.showLoadingSpinner = false;
        this.responseRecived = true;
        this.defaultpage= false;
    }
    // Calling apex class to insert the file
    saveToFile() {
        saveFile({ idParent: this.recordId, strFileName: this.file.name, base64Data: encodeURIComponent(this.fileContents) , pouploaded : true})
        .then(result => {
            this.isTrue= false;
            this.responseRecived = true;
            this.showLoadingSpinner = false;
            this.defaultpage= false;
        })
        .catch(error => {
           
        });
    }

}