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
import internal_approval_field from '@salesforce/schema/Quote.If_the_Rep_can_send_Email_to_customer__c';
import getContacts from '@salesforce/apex/sendForApproval.getContacts';
import getDocuments from '@salesforce/apex/sendForApproval.getDocuments';
import sendEmail from '@salesforce/apex/sendForApproval.sendEmail';
import searchForContacts from '@salesforce/apex/sendForApproval.searchForContacts';
import savecontact from '@salesforce/apex/sendForApproval.savecontact';
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
  }
];
//Setting columns for default document list
const COLSQD = [{
    label: 'Name',
    fieldName: 'Name'
  },
  {
    label: 'Doc ID',
    fieldName: 'ContentDownloadUrl',
    type: 'url',
    typeAttributes: {
      label: 'Link to Document',
      target: '_blank'
    }
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
  }
];

export default class customerApproval extends LightningElement {
  //boolena values for HTML
  @track defaultScreenforReps;
  @track repSatisfactionWithCustomers;
  @track isTrue;
  @track showLoadingSpinner;
  @track showthankYouMessage;
  @track displayContentDocs;
  @track quotesWithcontacts;
  @track searchResultsFound;
  @track nosearchResultsFound;
  @track allowingSearchContactForReps;
  @track noDefaultsSelected;
  @track finalcontactID;
  @track contactsuccessful;
  @track searchForContactsBoolean;
  @track createContactsBoolean;
  @track sendEmailBoolean;
  @track backToMainScreenBoolean;
  @track quotesWithNoContacts;
  @track noQuoteMessage;
  // List of documents and contacts
  @track contactList;
  @track quotedocs;
  @track defaultcontactsdata;
  // Columns for three data tables
  @track columnsSearchCon = columnsSearchCon;
  @track columns = COLS;
  @track columnsQD = COLSQD;
  // document id and contact id selected
  @api docId;
  @api sitecontactrowId;
  @api recordId;
  @api selectedContactId;

  // Contact fields are stored in the below variables
  @track frstName;
  @track lstName;
  @track email;
  @track phone;

  //Fetching the fields to see if the Quote is valid to send to customer
  @wire(getRecord, {
    recordId: '$recordId',
    fields: [internal_approval_field]
  }) Quotedetails;
  get internal() {
    console.log('the value is', JSON.stringify(this.Quotedetails.data));
    return getFieldValue(this.Quotedetails.data, internal_approval_field);
  }
  //Getting contacts from apex method by sending QuoteID
  @wire(getContacts, {
    quoteId: '$recordId'
  })
  wiredContatc({
    data
  }) {
    if (data) {
      this.defaultcontactsdata = data;
      this.noQuoteMessage = false;
      if (JSON.stringify(this.defaultcontactsdata).length >= 3) {
        console.log('there are contacts for this Quote', this.quotedocs);
        this.quotesWithcontacts = true;
        this.searchForContactsBoolean = true;
      } else {
        console.log('there are no contacts for this Quote');
        this.quotesWithcontacts = false;
        this.searchForContactsBoolean = true;
        this.quotesWithNoContacts = true;
      }
    }
  }
  //Getting documents from apex method by sending QuoteID
  @wire(getDocuments, {
    quoteId: '$recordId'
  })
  wireddocuments({
    data
  }) {
    if (data) {
      this.quotedocs = data;
      if (JSON.stringify(this.quotedocs).length >= 3) {
        console.log('there are quote documents for this Quote', this.quotedocs);
        this.displayContentDocs = true;
        this.searchForContactsBoolean = true;
        this.sendEmailBoolean = true;
        this.showLoadingSpinner = false;
      } else {
        console.log('there are no quote documents for this Quote');
        this.displayContentDocs = false;
        this.sendEmailBoolean = false;
        this.noQuoteMessage = true;
        this.showLoadingSpinner = false;
      }
    }
  }

  //Search for contact button calls below method
  searchForContact() {
    this.showLoadingSpinner = true;
    this.backToMainScreenBoolean = true;
    this.noQuoteMessage = false;
    this.searchForContactsBoolean = false;
    this.sendEmailBoolean = false;
    this.displayContentDocs = false;
    this.quotesWithcontacts = false;
    this.quotesWithNoContacts = false;
    this.allowingSearchContactForReps = true;
    this.showLoadingSpinner = false;
  }
  sendEmailTocustomer() {
    this.showLoadingSpinner = true;
    this.sendEmailBoolean = false;
    this.searchForContactsBoolean = false;
    this.displayContentDocs = false;
    this.quotesWithcontacts = false;
    if (this.selectedContactId !== undefined) {
      this.finalcontactID = this.selectedContactId;
    } else if (this.sitecontactrowId !== undefined) {
      this.finalcontactID = this.sitecontactrowId;
    }
    if (this.finalcontactID !== undefined && this.docId !== undefined) {
      sendEmail({
          slctdId: this.finalcontactID,
          quoteId: this.recordId,
          docId: this.docId
        })
        .then(result => {
          if (result === 'success') {
            this.allowingSearchContactForReps = false;
            this.searchResultsFound = false;
            this.noDefaultsSelected = false;
            this.searchResultsFound = false;
            this.showthankYouMessage = true;
            this.showLoadingSpinner = false;
          }
        })
    } else {
      console.log('nothing is selected');
      this.allowingSearchContactForReps = false;
      this.searchResultsFound = false;
      this.noDefaultsSelected = true;
      this.backToMainScreenBoolean = true;
      this.showLoadingSpinner = false;
    }
  }
  backtoMainPage() {
    location.reload();
  }
  handleDocRowAction(event) {

    if (JSON.stringify(event.detail.selectedRows[0].ContentVersionId !== '')) {
      this.docId = JSON.stringify(event.detail.selectedRows[0].ContentVersionId);
      console.log('the docid is' + this.docId);
    }
  }
  handleContactRowAction(event) {
    this.selectedContactId = JSON.stringify(event.detail.selectedRows[0].Id);
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
  // fetching the input field values entered by rep ends

  handleSearch() {
    this.showLoadingSpinner = true;
    this.noDefaultsSelected = false;
    this.noQuoteMessage = false;
    if (this.frstName !== '' || this.lstName !== '' || this.email !== '' || this.phone !== '') {
      console.log('the fname is', this.frstName + 'the last name is', this.lstName);
      searchForContacts({
          FName: this.frstName,
          LName: this.lstName,
          Email: this.email,
          Phone: this.phone,
          quoteId: this.recordId
        })
        .then(result => {
          console.log('the search results from contacts are JS:', JSON.stringify(result));
          if (JSON.stringify(result).length >= 3) {

            this.contactList = result;
            this.searchResultsFound = true;
            this.repSatisfactionWithCustomers = true;
            this.allowingSearchContactForReps = false;
            this.searchForContactsBoolean = false;
            this.createContactsBoolean = false;
            this.sendEmailBoolean = false;
            this.showLoadingSpinner = false;
          } else {
            this.displayContentDocs = false;
            this.searchResultsFound = false;
            this.createContactsBoolean = true;
            this.nosearchResultsFound = true;
            this.showLoadingSpinner = false;
          }

        })
    }
  }
  handleSearchContactRowAction(event) {
    const sitecontactrowId = JSON.stringify(event.detail.selectedRows[0].Id);
    this.sitecontactrowId = sitecontactrowId;
    console.log('row ====> ' + this.sitecontactrowId);
  }
  createContact() {

    this.isTrue = true;
    console.log('the values are', this.FNVal, this.lstName, this.email, this.phone);
    if (this.frstName !== undefined && this.lstName !== undefined && this.email !== undefined && this.phone !== undefined && !this.email.includes('officedepot')) {
      this.showLoadingSpinner = true;
      savecontact({
        firstName: this.frstName,
        lastName: this.lstName,
        Email: this.email,
        Phone: this.phone,
        QuoId: this.recordId
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

  }
  //Needed
  showDefaultdocuments() {
    this.showLoadingSpinner = true;
    this.allowingSearchContactForReps = false;
    this.sendEmailBoolean = true;
    this.displayContentDocs = true;
    if (this.noQuoteMessage) {
      this.noQuoteMessage = true;
    }
    this.repSatisfactionWithCustomers = false;
    this.showLoadingSpinner = false;
  }
  //Needed
  ShowSearchForContacts() {
    this.showLoadingSpinner = true;
    this.searchResultsFound = false;
    this.repSatisfactionWithCustomers = false;
    this.allowingSearchContactForReps = true;
    this.displayContentDocs = false;
    this.showLoadingSpinner = false;
  }
}