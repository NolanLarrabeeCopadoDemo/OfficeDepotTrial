import { LightningElement, track, api,wire } from 'lwc';
import OD_LOGO from '@salesforce/resourceUrl/ODHorizontalLogoRed';
import approveReject from '@salesforce/apex/ProsApprovalController.approveReject';
import approvalStatus from '@salesforce/apex/ProsApprovalController.approvalStatus';
export default class PROSApprovalPage extends LightningElement {
    @api recordId;
    @api userId;
    @track fileName='';
    @track fileContents='';
    @track comments='';
    @track action ='';
    @track isApprovalSubmitted = false;
    @track showSpinner = false;
    // Expose the static resource URL for use in the template
    odLogoUrl = OD_LOGO;

    @wire(approvalStatus, {  caseId: '$recordId', userId: '$userId'})
    wiredGetApprovalStatus(value) {
        this.showSpinner = true;
        const { data, error } = value;
        if (error) {
            this.showSpinner = false;
            console.log(error);
        }else{
            console.log('data=>',data);
            this.isApprovalSubmitted = data;
            this.showSpinner = false;
        }
    }


    handleApproveRejectClick(event){
        this.action = event.target.label;
        console.log('action:',this.action);
        approveReject({ caseId: this.recordId, 
            userId: this.userId,
            comments: this.comments,
            action: this.action,
            file: encodeURIComponent(this.fileContents),  
            fileName: this.fileName })
        .then(result => {
            let data = result;
            console.log('data=>',data);
            if(data){
                alert('Response submitted sucessfully.');
            }else{
                alert('Something went wrong contact admin.');
            }
            this.showSpinner = false;
            this.isApprovalSubmitted = data;
        
        })
        .catch(error => {
            alert('Something went wrong contact admin.');
            this.showSpinner = false;
            console.log(error);
        });
    }
    connectedCallback() {
        console.log('recordId:',this.recordId);
        console.log('userId:',this.userId);
    }

    handleCommentChange(event){
        this.comments = event.target.value;
    }
    handleFileChange(event){
        //var files = event.detail.files.name;
        //alert(files.length + ' files !!');
        if (event.target.files.length > 0) { 
            var filesUploaded = event.target.files;
            this.fileName = event.target.files[0].name;
            this.fileContents = filesUploaded[0];
            this.uploadHelper(filesUploaded[0]); 
            if (this.fileContents.size > this.MAX_FILE_SIZE) {
                this.fileName = 'File Size is to long. File size should be less then 5MB';
            } 
        }
    }

    uploadHelper(file) {
        this.showSpinner = true;
        var file = file;
        // create a FileReader object 
        this.fileReader= new FileReader();
        // set onload function of FileReader object  
        this.fileReader.onloadend = (() => {
            this.fileContents = this.fileReader.result;
            let base64 = 'base64,';
            let content = this.fileContents.indexOf(base64) + base64.length;
            this.fileContents = this.fileContents.substring(content);
            this.showSpinner = false;
        });
    
        this.fileReader.readAsDataURL(file);
    }
}