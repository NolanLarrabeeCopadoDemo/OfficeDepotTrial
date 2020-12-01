import { LightningElement, track, api } from 'lwc';
const MAX_FILE_SIZE = 100000000; //10mb 
import createSCOETicket from '@salesforce/apex/AccountSetUpController.CreateSCOETicket';
import AnnualRevenue from '@salesforce/schema/Account.AnnualRevenue';
export default class AccountSetupRequestChecklist extends LightningElement {
    @track input1 = false;
    @track input2 = false;
    @track input3 = false;
    @track input4 = false;
    @track input5 = false;
    @track input6 = false;
    @track isSubmitted = false;
    @track newrequest='';
    @api opportunityid='';
    @api recordId;
    @track showSpinner = false;
    /*Abhishek Jain NAIT-151586 - Start*/

    @track isChecked = false;
    @track Comments ;
    @track isValid = false;
    @track input10 ;
    @track input9;
    @track input8 ;
    @track input7 = false;
    /*Abhishek Jain NAIT-151586 - End*/
    uploadedFiles = []; file; fileContents; fileReader; content; fileName; 

    onFileUpload(event) {
        // Get the list of uploaded files
        if (event.target.files.length > 0) {  
            this.uploadedFiles = event.target.files;  
            this.fileName = event.target.files[0].name;  
            this.file = this.uploadedFiles[0];  
            if (this.file.size > this.MAX_FILE_SIZE) {  
              alert("File size can not exceed" + MAX_FILE_SIZE);  
            }
            if(this.file.size === 0){
                alert("Empty file is not allowed."); 
            }  
        }
    }
    handleChange(event){

        if(event.target.name === 'input1'){
            this.input1 = event.target.checked;
            if(this.input1){
                this.isChecked = true;
            }else{
                this.isChecked = false;
            }
           
        }else if(event.target.name === 'input2'){
            this.input2 = event.target.checked;
        }else if(event.target.name === 'input3'){
            this.input3 = event.target.checked;
        }else if(event.target.name === 'input4'){
            this.input4 = event.target.checked;   
        }else if(event.target.name === 'input5'){
            this.input5 = event.target.checked;
        }else if(event.target.name === 'input6'){
            this.input6 = event.target.checked;
        }
        /*Abhishek Jain NAIT-151586 - Start*/ 
        else if(event.target.name === 'input10'){
            this.input10 = event.target.value;
        }
        else if(event.target.name === 'input7'){ 
            this.input7 = event.target.checked;
        }else if(event.target.name === 'input8'){
            this.input8 = event.target.value; 
        }else if(event.target.name === 'input9'){
            this.input9 = event.target.value;       
        }
        if(this.input1 || this.input2 || this.input3 || this.input4 || 
            this.input5 || this.input6 || this.input7){
                
                    this.isValid = true;
                    
        }else{
            this.isValid = false;
        }

    }

     
    get options() {
        return [
                 { label: 'OP', value: 'OP' },
                 { label: 'CBFS', value: 'CBFS' },
                 { label: 'CPD', value: 'CPD' },
                 { label: 'MPS', value: 'MPS' },
                 { label: 'TECH', value: 'TECH' },
                 { label: 'FURN', value: 'FURN' },
               ];
    }
    /*Abhishek Jain NAIT-151586 - End*/

    handleSubmitClick(event){
        this.showSpinner = true;
        if(this.input1 || this.input2 || this.input3 || this.input4 || this.input5 || this.input6 || this.input7 || this.input9 || this.input8){
            var newrequest1 = 'Is the annual revenue greater than $500K?: '+ (this.input1 ? 'Yes' : 'No');
                newrequest1 = newrequest1 +'\n Anticipated annual revenue: '+(this.input9); // NAIT-151586 - Abhishek
                newrequest1 = newrequest1 +'\n Does this Customer require EDI or 3rd Party?: '+ (this.input2 ? 'Yes' : 'No');
                newrequest1 = newrequest1 +'\n Does the Customer have Desktop/Special Delivery requirements?: '+ (this.input3 ? 'Yes' : 'No');
                newrequest1 = newrequest1 +'\n Does the Customer require Custom Billing?: '+ (this.input4 ? 'Yes' : 'No');
                newrequest1 = newrequest1 +'\n Does the Customer require any additional customization?: '+ (this.input5 ? 'Yes' : 'No');            
                newrequest1 = newrequest1 +'\n If you answered ‘No’ to the above questions, would you still like to request an Implementation specialist?: '+ (this.input6 ? 'Yes' : 'No');
                newrequest1 = newrequest1 +'\n Comments: '+(this.input8); // NAIT-151586 - Abhishek
                newrequest1 = newrequest1 +'\n Type of Project: '+(this.input10); // NAIT-151586 - Abhishek
                newrequest1 = newrequest1 +'\n Is this Customer Tier One?: '+ (this.input7 ? 'Yes' : 'No'); // NAIT-151586 - Abhishek
            console.log('newrequest:',newrequest1);
            this.newrequest = newrequest1;
            if(this.file && this.file !== '' &&  this.file.size > 0){
                this.fileReader = new FileReader();  
                this.fileReader.onloadend = (() => {  
                    this.fileContents = this.fileReader.result;  
                    let base64 = 'base64,';  
                    this.content = this.fileContents.indexOf(base64) + base64.length;  
                    this.fileContents = this.fileContents.substring(this.content);  
                    this.saveRecord();  
                });  
                this.fileReader.readAsDataURL(this.file);
            }else{
                this.saveRecord();
            }
        }else{
            this.showSpinner = false;
             // Prevents the anchor element from navigating to a URL.
            event.preventDefault();
            // Creates the event with the contact ID data.
            const fireEvent = new CustomEvent('fireevent', { detail: true });
            // Dispatches the event.
            this.dispatchEvent(fireEvent);
        }

    }


    saveRecord(event){
        createSCOETicket({ newrequest: this.newrequest, 
                           oppId: this.opportunityid,
                           file: encodeURIComponent(this.fileContents),  
                           fileName: this.fileName })
        .then(result => {
            let data = result;
            console.log('data=>',data);
            this.isSubmitted = true;
            //alert('Create SCOE ticket.');
            this.showSpinner = false;
        })
        .catch(error => {
            this.showSpinner = false;
            console.log(error);
            alert(error.body.message);
        });
    }
}