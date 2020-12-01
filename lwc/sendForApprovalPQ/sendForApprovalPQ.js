import {
  LightningElement,
  api,
  wire,
  track
} from 'lwc';
import {
  getRecord,
  getFieldValue
} from 'lightning/uiRecordApi';

import {
  NavigationMixin
} from 'lightning/navigation';
import getCustomerCommunication from '@salesforce/apex/SendforCustomerApprovalCtrl.getCustomerCommunication';
import doa_approval_field from '@salesforce/schema/CameleonCPQ__QxQuote__c.DOA_Appoval__c'; 
import getDocuments from '@salesforce/apex/SendforCustomerApprovalCtrl.getDocuments';
import getContacts from '@salesforce/apex/SendforCustomerApprovalCtrl.getContacts';
import sendEmail from '@salesforce/apex/SendforCustomerApprovalCtrl.sendEmail';
import searchForContacts from '@salesforce/apex/SendforCustomerApprovalCtrl.searchForContacts';
import savecontact from '@salesforce/apex/SendforCustomerApprovalCtrl.savecontact';
//Setting columns for default contact list
const COLS = [{
    label: 'First Name',
    fieldName: 'FirstName',
    editable: false
  },
  {
    label: 'Last Name',
    fieldName: 'LastName',
    editable: false
  },
  {
    label: 'Role',
    fieldName: 'Role__c',
    editable: false
  },
  {
    label: 'Title',
    fieldName: 'Title',
    editable: false
  },
  {
    label: 'Phone',
    fieldName: 'Phone',
    type: 'phone',
    editable: false
  },
  {
    label: 'Email',
    fieldName: 'Email',
    type: 'email',
    editable: false
  }
];
//Setting Columns for Searched contact List
const columnsSearchCon = [{
    label: 'First Name',
    fieldName: 'FirstName',
    editable: false
  },
  {
    label: 'Last Name',
    fieldName: 'LastName',
    editable: false
  },
  {
    label: 'Title',
    fieldName: 'Title'
  },
  {
    label: 'Phone',
    fieldName: 'Phone',
    type: 'phone'
  },
  {
    label: 'Email',
    fieldName: 'Email',
    type: 'email'
  },
  {
    label: 'Role',
    fieldName: 'Role__c',
    type: 'Multi-Select'
  }
];



export default class customerApproval extends NavigationMixin(LightningElement) {
  //boolena values for HTML
  @track defaultScreenforReps;
  @track repSatisfactionWithCustomers;
  @track isTrue;
  @track showLoadingSpinner;
  @track showthankYouMessage;
  @track quotesWithcontacts;
  @track searchResultsFound;
  @track nosearchResultsFound;
  @track allowingSearchContactForReps;
  @track noDefaultsSelected;
  @track finalcontactID;
  @track contactsuccessful;
  @track contactErrorMsg;
  @track searchForContactsBoolean;
  @track backToProsButton;
  @track createContactsBoolean;
  @track sendEmailBoolean;
  @track backToMainScreenBoolean;
  @track quotesWithNoContacts;
  @track editSelectedContactBoolean;
  @track rowSelected;
  @track contactEditsuccessful;
  @track noDefaultForEditSelected;
  @track noDocs;
  // List of documents and contacts
  @track contactList;
  @track defaultcontactsdata;
  // Columns for three data tables
  @track columnsSearchCon = columnsSearchCon;
  @track columns = COLS;
  // contact id selected
  @api sitecontactrowId;
  @api recordId;
  @api selectedContactId;
  @api allowCreatCon;
  // Contact fields are stored in the below variables
  @track frstName;
  @track lstName;
  @track email;
  @track phone;
  @track role;
  @track emailIdCheck;
  @track firstNameEnteredEdit;
  @track lastNameEnteredEdit;
  @track emailEnteredEdit;
  @track phoneEnteredEdit;
  @track roleEnteredEdit;
  @track firstNameEditedBoolean = false;
  @track lastNameEditedBoolean = false;
  @track phoneEditedBoolean = false;
  @track emailEditedBoolean = false;
  @track roleEditedBoolean = false;
  @track contactID;
  @api firstNameCreation;
  @api lastNameCreation;
  @api emailCreation;
  @api phoneCreation;
  @track backButtonLabel = 'Back';
  @track customerCommunication;

  StartTheSpinner(event) {
    this.showLoadingSpinner = true;
    this.contactsuccessful = false;        
        this.contactErrorMsg = '';
  }

  handleSuccess(event) {

    this.contactID = event.detail.id;
    savecontact({
      prosquoteId: this.recordId,
      conID: this.contactID
    }).then(result => {
      if (result === 'success') {
        this.contactsuccessful = true;
        this.contactErrorMsg = '';
        setTimeout(() => {
          location.reload()
        }, 3000);
      }
      else{
        this.contactsuccessful = false;        
        this.contactErrorMsg = result;
        this.showLoadingSpinner = false;
      }

    })


  }

  handleError(event) {
    this.showLoadingSpinner = false;

  }

  //Fetching the fields to see if the Quote is valid to send to customer
  @wire(getRecord, {
    recordId: '$recordId',
    fields: [doa_approval_field]
  }) PROSQuotedetails;
  get internal() {
    return getFieldValue(this.PROSQuotedetails.data, doa_approval_field);
  }
  connectedCallback(){
    getCustomerCommunication({prosquoteId: this.recordId}) .then(result => { 
      console.log(' the customer comm req is',JSON.stringify(result));
      if(result === true) {
     
this.customerCommunication = true;
this.backToProsButton = true;
      } else {
        this.customerCommunication = false;
        this.backToProsButton = true;
      }
    })
  
}
  //Getting contacts from apex method by sending QuoteID
  @wire(getContacts, {
    prosquoteId: '$recordId'
  })
  wiredContatc({
    data
  }) {
    if (data) {
      this.defaultcontactsdata = data;
      if (JSON.stringify(this.defaultcontactsdata).length >= 3) {
        this.searchForContactsBoolean = true;
        this.backToProsButton = true;
       // this.sendEmailBoolean = true;
        this.editSelectedContactBoolean = true;
        this.quotesWithcontacts = true;
      } else {
        console.log('there are no contacts for this Quote');
        this.quotesWithcontacts = false;
        this.quotesWithNoContacts = true;
        this.searchForContactsBoolean = true;
      }
    }
  }
  @wire(getDocuments, {
    prosquoteId: '$recordId'
  })
  wiredDocument({
    data
  }) {
    if (data === true) {
      this.sendEmailBoolean = false;
      this.noDocs = true;
    } else {
      this.sendEmailBoolean = true;
      this.noDocs = false;
    }
  }
 
  //Search for contact button calls below method
  searchForContact() {
    this.showLoadingSpinner = true;
    this.backToMainScreenBoolean = true;
    this.searchForContactsBoolean = false;
    this.backToProsButton = false;
    this.noDocs = false;
    this.sendEmailBoolean = false;
    this.editSelectedContactBoolean = false;
    this.quotesWithcontacts = false;
    this.quotesWithNoContacts = false;
    this.allowingSearchContactForReps = true;
    this.showLoadingSpinner = false;
  }
  sendEmailTocustomer() {
    this.showLoadingSpinner = true;
    this.sendEmailBoolean = false;
    this.editSelectedContactBoolean = false;
    this.searchForContactsBoolean = false;
    this.backToProsButton = false;
    this.noDocs = false;
    this.quotesWithcontacts = false;
    console.log('test' + this.emailIdCheck);
    if (this.selectedContactId !== undefined) {
      this.finalcontactID = this.selectedContactId;
    } else if (this.sitecontactrowId !== undefined) {
      this.finalcontactID = this.sitecontactrowId;
    }
    if (this.finalcontactID !== undefined && (this.emailIdCheck !== undefined || this.emailIdCheck !== '')) {
      sendEmail({
          slctdId: this.finalcontactID,
          prosquoteId: this.recordId
        })
        .then(result => {
          if (result === 'success') {
            this.allowingSearchContactForReps = false;
            this.searchResultsFound = false;
            this.noDefaultsSelected = false;
            this.noDefaultForEditSelected = false;
            this.noDocs = false;
            this.searchResultsFound = false;
            this.showthankYouMessage = true;
            this.backToProsButton = true;	
            this.backButtonLabel = 'Back to quote';
            this.showLoadingSpinner = false;
          }
        })
    } else {
      console.log('nothing is selected');
      this.allowingSearchContactForReps = false;
      this.searchResultsFound = false;
      this.noDefaultsSelected = true;
      this.noDocs = false;
      this.noDefaultForEditSelected = false;
      this.backToMainScreenBoolean = true;
      this.showLoadingSpinner = false;
    }
  }
 
  backtoMainPage() {
    location.reload();
  }
 
  handleContactRowAction(event) {

    this.rowSelected = event.detail.selectedRows[0];

    this.selectedContactId = JSON.stringify(event.detail.selectedRows[0].Id);

    if (JSON.stringify(event.detail.selectedRows[0]).Email !== '' || JSON.stringify(event.detail.selectedRows[0]).Email !== undefined) {
      console.log('test row11-->' + JSON.stringify(event.detail.selectedRows[0].Email));
      this.emailIdCheck = JSON.stringify(event.detail.selectedRows[0]).Email;
    }
    console.log('the contact id is' + this.selectedContactId);
  }
  // fetching the input field values entered by rep starts
  firstNameSearchKey(event) {
    if (this.firstNameEntered !== '') {
      this.frstName = event.target.value;
      console.log('the value entered is', this.frstName);
    }
  }
  lastNameSearchKey(event) {
    if (this.lastNameEntered !== '') {
      this.lstName = event.target.value;

    }
  }
  emailSearchKey(event) {
    if (this.emailEntered !== '') {
      this.email = event.target.value;
    }


  }
  phoneSearchKey(event) {
    if (this.phoneEntered !== '') {
      this.phone = event.target.value;
    }

  }

  roleEntered(event) {
    if (this.roleEntered !== '') {
      this.role = event.target.value;
    }
  }

  firstNameEditKey(event) {
    if (this.firstNameEnteredEdit !== '') {
      this.firstNameEditedBoolean = true;
      this.frstName = event.target.value;

    }
  }
  lastNameEditKey(event) {
    if (this.lastNameEnteredEdit !== '') {
      this.lastNameEditedBoolean = true;
      this.lstName = event.target.value;

    }
  }
  emailEditKey(event) {
    if (this.emailEnteredEdit !== '') {
      this.emailNameEditedBoolean = true;
      this.email = event.target.value;
    }


  }
  phoneEditKey(event) {
    if (this.phoneEnteredEdit !== '') {
      this.phoneEditedBoolean = true;
      this.phone = event.target.value;
    }

  }

  roleEditEntered(event) {
    console.log('the value entered is', event.target.value);
    if (this.roleEnteredEdit !== '') {
      this.roleEditedBoolean = true;
      this.role = event.target.value;

    }
  }
  // fetching the input field values entered by rep ends

  handleSearch() {
    this.showLoadingSpinner = true;
    this.noDefaultsSelected = false;
    this.noDefaultForEditSelected = false;
    this.noDocs = false;
    console.log('the fname is', this.frstName + 'the role name is', this.role);
    if ((this.frstName !== undefined && this.frstName !== '') || (this.lstName !== undefined && this.lstName !== '') || (this.email !== undefined && this.email !== '') || (this.phone !== undefined && this.phone !== '') || (this.role !== undefined && this.role !== '')) {

      searchForContacts({
          FName: this.frstName,
          LName: this.lstName,
          Email: this.email,
          Phone: this.phone,
          Role: this.role,
          prosquoteId: this.recordId
        })
        .then(result => {
          console.log('the search results from contacts are JS:', JSON.stringify(result));
          if (JSON.stringify(result).length >= 3) {

            this.contactList = result;
            this.searchResultsFound = true;
            this.repSatisfactionWithCustomers = true;
            this.allowingSearchContactForReps = false;
            this.searchForContactsBoolean = false;
            this.backToProsButton = false;
            this.sendEmailBoolean = false;
            this.editSelectedContactBoolean = false;
            this.nosearchResultsFound = false;
            this.showLoadingSpinner = false;
          } else {
            this.firstNameCreation = this.frstName;
            this.lastNameCreation= this.lstName;
            this.emailCreation = this.email;
            this.phoneCreation= this.phone;
            this.searchResultsFound = false;
            this.createContactsBoolean = true;
            this.nosearchResultsFound = true;
            this.showLoadingSpinner = false;
          }

        })
    } else {
      alert('Enter atleast one of the fields to search your customer');
      this.showLoadingSpinner = false;
    }
  }
  handleSearchContactRowAction(event) {
    const sitecontactrowId = JSON.stringify(event.detail.selectedRows[0].Id);
    this.sitecontactrowId = sitecontactrowId;
    console.log('row ====> ' + this.sitecontactrowId);
  }
  createContact() {
    this.showLoadingSpinner = true;
    this.allowCreatCon = true;
    this.allowingSearchContactForReps = false;
    this.nosearchResultsFound = false;
    setTimeout(() => {
      this.showLoadingSpinner = false
    }, 1000);
  }
  // 

  /*
    this.isTrue = true;
    console.log('the values are', this.FNVal, this.lstName, this.email, this.phone);
    if (this.frstName !== undefined && this.lstName !== undefined && this.email !== undefined && this.phone !== undefined && !this.email.includes('officedepot') && this.role !== undefined) {
      this.showLoadingSpinner = true;
      savecontact({
        firstName: this.frstName,
        lastName: this.lstName,
        Email: this.email,
        Phone: this.phone,
        Role: this.role,
        prosquoteId: this.recordId
      }).then(result => {
        if (result === 'success') {
          this.contactsuccessful = true;
          setTimeout(() => {
            location.reload()
          }, 3000);
        }

      })
    } else {
      alert('Please fill all the fields below and make sure your email address doesnt belong to office depot');
    }
*/

  saveContact() {
    this.isTrue = true;
    if (this.firstNameEditedBoolean === false) {
      this.frstName = this.rowSelected.FirstName;
    }

    if (this.lastNameEditedBoolean === false) {
      this.lstName = this.rowSelected.LastName;
    }

    if (this.emailEditedBoolean === false) {
      this.email = this.rowSelected.Email;
    }

    if (this.phoneEditedBoolean === false) {
      this.phone = this.rowSelected.Phone;
    }

    if (this.roleEditedBoolean === false) {
      this.role = this.rowSelected.Role__c;
    }
    console.log('the values are', this.frstName, this.lstName, this.email, this.phone, this.role);

    this.showLoadingSpinner = true;
  }
  //Needed
  showDefaultdocuments() {
    this.showLoadingSpinner = true;
    this.allowingSearchContactForReps = false;
    this.sendEmailBoolean = true;
    this.editSelectedContactBoolean = true;
    this.repSatisfactionWithCustomers = false;
    this.showLoadingSpinner = false;
  }
  //Needed
  ShowSearchForContacts() {
   /* this.showLoadingSpinner = true;
    this.searchResultsFound = false;
    this.backToProsButton = false;
    this.repSatisfactionWithCustomers = false;
    this.allowingSearchContactForReps = true;
    this.createContactsBoolean = true;
    this.frstName = undefined;
    this.lstName = undefined;
    this.email = undefined;
    this.phone = undefined;
    this.role = undefined;
    this.showLoadingSpinner = false; */

    this.firstNameCreation = this.frstName;
            this.lastNameCreation= this.lstName;
            this.emailCreation = this.email;
            this.phoneCreation= this.phone;
            this.searchResultsFound = false;
            this.createContactsBoolean = true;
            this.nosearchResultsFound = true;
            this.showLoadingSpinner = false;
  }

  //redirecting Back to Pros Quote Detail Page
  backToProsQuote() {
    console.log('Test-->');
    this.showLoadingSpinner = true;	
    let Url = window.location.protocol + '//' + window.location.hostname + '/lightning/r/CameleonCPQ__QxQuote__c/'+ this.recordId+'/view';	
    window.location.replace(Url)	
    /*if (document.referrer.indexOf(".lightning.force.com") > 0) {	
      this[NavigationMixin.Navigate]({	
        type: 'standard__recordPage',	
        attributes: {	
          recordId: this.recordId,	
          objectApiName: 'CameleonCPQ__QxQuote__c',	
          actionName: 'view'	
        }	
      });	
    } else {	
      window.location.assign('/' + this.recordId);	
    }*/
  }
}