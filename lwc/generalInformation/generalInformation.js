import { LightningElement, api,track } from 'lwc';
import Id from '@salesforce/user/Id';
import createCustomerRequest from '@salesforce/apex/CustomerRequestFormCtrl.createCustomerRequest';
export default class GeneralInformation extends LightningElement
{
	@api aopsCustMasterDetails;
	@api aopsCustPreferences;
	@api itemRestrictionCode;
	//Sandesh Ganjare NAIT-150754 - Start
    @track updateShipTo;
    @track addWebUser;
    @track showButton = false;
    @track userId = Id;
    @track fileName;
    @track fileContents;
    @track showSpinner = false;
    @track customerDetails = {
        Agent_Name:'',
        Agent_Email:'',
        Sales_CSR_ID:'',
        Contact_First_Name:'',
        Contact_Last_Name:'',
        Contact_Email_Address:'',
        Preferred_Call_Back_Number:'',
        ANI_Incident_Number:'',
        Contact_Type:'',
        Business_Name:'',
        Address:'',
        City:'',
        State:'',
        Zip:'',
        Address_ID:'',
        First_Name:'',
        Last_Name:'',
        Email_address:'',
        Ship_To_ID:'',
        Comments_Action_Requested:''
    }

    get options() {
        return [
            { label: 'Yes', value: true },
            { label: 'No', value: false }
        ];
    }
    get contactTypeOption() {
        return [
            { label: 'Phone', value: 'Phone' },
            { label: 'Email', value: 'Email' },
            { label: 'Chat', value: 'Chat' },
            //Aniket Bende NAIT-157600 - Start 
            { label: 'Text', value: 'Text' }
           //Aniket Bende NAIT-157600 - End 
        ];
    }
    //Sandesh Ganjare NAIT-150754 - End
	get hasData ()
	{
		return !!this.aopsCustMasterDetails === true;
	}
	get isHoldReturn ()
	{
		if (!this.aopsCustMasterDetails.HOLD_RETRN_IND)
			return false;
		return true;
	}
	get isHoldReturn2 ()
	{
		if (!this.aopsCustMasterDetails.TECH_BLOCK)
			return false;
		return true;
	}

	//Sandesh Ganjare NAIT-150754 - Start
    handleCreateClick(event){
        this.customerDetails = {
            Agent_Name:'',
            Agent_Email:'',
            Sales_CSR_ID:'',
            Contact_First_Name:'',
            Contact_Last_Name:'',
            Contact_Email_Address:'',
            Preferred_Call_Back_Number:'',
            ANI_Incident_Number:'',
            Contact_Type:'',
            Business_Name:'',
            Address:'',
            City:'',
            State:'',
            Zip:'',
            Address_ID:'',
            First_Name:'',
            Last_Name:'',
            Email_address:'',
            Ship_To_ID:'',
            Comments_Action_Requested:''
        }
        this.template.querySelector("section").classList.remove("slds-hide");
        this.template.querySelector("div.modalBackdrops").classList.remove("slds-hide");
    }

    handleCloseClick(event){
        this.template.querySelector("section").classList.add("slds-hide");
        this.template.querySelector("div.modalBackdrops").classList.add("slds-hide");
    }

    handleChange(event) {
        //this.value = event.detail.value;
        this.customerDetails[event.target.name] = event.target.value;
    }
    handleShipToChange(event){
        if(event.detail.value === 'false'){
            this.updateShipTo = false;
        }else{
            this.updateShipTo = true;
        }
    }
    handleWebUserChange(event){
        if(event.detail.value === 'false'){
            this.addWebUser = false;
        }else{
            this.addWebUser = true;
        }
    }
    handleSubmitClick(event) {
        this.showSpinner = true;
        this.newrequest = 'Account Maitainance Information: \n';
        this.newrequest = this.newrequest + 'Agent Name :'+ this.customerDetails.Agent_Name+'\n';
        this.newrequest = this.newrequest + 'Agent Email :'+this.customerDetails.Agent_Email+'\n';
        this.newrequest = this.newrequest + 'Sales/CSR ID# :'+this.customerDetails.Sales_CSR_ID+'\n';
        this.newrequest = this.newrequest + 'Contact First Name :'+this.customerDetails.Contact_First_Name+'\n';
        this.newrequest = this.newrequest + 'Contact Last Name :'+this.customerDetails.Contact_Last_Name+'\n';
        this.newrequest = this.newrequest + 'Contact Email Address :'+ this.customerDetails.Contact_Email_Address+'\n';
        this.newrequest = this.newrequest + 'Preferred Call Back Number :' +this.customerDetails.Preferred_Call_Back_Number+'\n';
        this.newrequest = this.newrequest + 'ANI/Incident_Number :' +this.customerDetails.ANI_Incident_Number+'\n';
        this.newrequest = this.newrequest + 'Contact Type :' +this.customerDetails.Contact_Type+'\n';
        this.newrequest = this.newrequest + ' Do you need to update a Ship To?:' + (this.updateShipTo ? 'Yes':'No') +'\n';
        this.newrequest = this.newrequest + 'Business Name :' +this.customerDetails.Business_Name+'\n';
        this.newrequest = this.newrequest + 'Address :' +this.customerDetails.Address+'\n';
        this.newrequest = this.newrequest + 'City :' +this.customerDetails.City+'\n';
        this.newrequest = this.newrequest + 'State :' +this.customerDetails.State+'\n';
        this.newrequest = this.newrequest + 'Zip :' +this.customerDetails.Zip+'\n';
        this.newrequest = this.newrequest + 'Address ID :' +this.customerDetails.Address_ID+'\n';
        this.newrequest = this.newrequest + 'Do you need to add a web user? :' + (this.addWebUser ? 'Yes':'No') +'\n';
        this.newrequest = this.newrequest + 'First Name :' +this.customerDetails.First_Name+'\n';
        this.newrequest = this.newrequest + 'Last Name :' +this.customerDetails.Last_Name+'\n';
        this.newrequest = this.newrequest + 'Email address :' +this.customerDetails.Email_address+'\n';
        this.newrequest = this.newrequest + 'Ship To ID :' +this.customerDetails.Ship_To_ID+'\n';
        this.newrequest = this.newrequest + 'Comments Action Requested :' +this.customerDetails.Comments_Action_Requested;
        console.log('newrequest==>',this.newrequest);
        if(this.customerDetails.Agent_Name != null && this.customerDetails.Agent_Name != '' && this.customerDetails.Agent_Email!=null && this.customerDetails.Agent_Email!='' && this.customerDetails.Sales_CSR_ID!=null && this.customerDetails.Sales_CSR_ID!='' && this.customerDetails.Contact_First_Name!=null && this.customerDetails.Contact_First_Name!='' && this.customerDetails.Contact_Last_Name!=null && this.customerDetails.Contact_Last_Name!='' && this.customerDetails.Preferred_Call_Back_Number!=null && this.customerDetails.Preferred_Call_Back_Number!='' && this.customerDetails.Contact_Type!=null && this.customerDetails.Contact_Type!='' ){
        createCustomerRequest({ newrequest: this.newrequest, 
            custID: this.aopsCustMasterDetails.CUSTOMER_ID,
            file: encodeURIComponent(this.fileContents),  
            fileName: this.fileName })
        .then(result => {
            let data = result;
            console.log('data=>',data);
            this.showSpinner = false;
            if(data){
                alert('Case Submitted Successfully.');
                this.template.querySelector("section").classList.add("slds-hide");
                this.template.querySelector("div.modalBackdrops").classList.add("slds-hide");
            }else{
                alert('Somthing went wrong contact Salesforce Team.');
            }

        })
        .catch(error => {
            this.showSpinner = false;
            console.log(error);
            alert('Somthing went wrong contact Salesforce Team.');
        });
    }
    else{
        alert('Please fill all required fields.');
    }
    }
    
    
    //Aniket Bende NAIT-157600 - Start 
    connectedCallback(){
        if(this.userId == undefined){
            this.showButton = true;
        }else{
            this.showButton = false;
        }
        //Aniket Bende NAIT-157600 - End 
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
    //Sandesh Ganjare NAIT-150754 - End
}