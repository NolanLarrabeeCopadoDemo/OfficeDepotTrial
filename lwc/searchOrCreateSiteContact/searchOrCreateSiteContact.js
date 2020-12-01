import { LightningElement, track, api } from "lwc";
import createSiteExistingContact from "@salesforce/apex/SearchOrCreateSiteContact.createSiteExistingContact";
import getSiteInfo from "@salesforce/apex/SearchOrCreateSiteContact.getSiteInfo";
import getSiteContacts from "@salesforce/apex/SearchOrCreateSiteContact.getSiteContacts";
import getCurrentUserLocale from "@salesforce/apex/LightningAccountSalesHistory.getCurrentUserLocale";
import { FlowNavigationNextEvent } from "lightning/flowSupport";

import Search_Or_Create_Site_Contact_Name_Label from "@salesforce/label/c.Search_Or_Create_Site_Contact_Name_Label";
import Search_Or_Create_Site_Contact_Email_Label from "@salesforce/label/c.Search_Or_Create_Site_Contact_Email_Label";
import Search_Or_Create_Site_Contact_Phone_Label from "@salesforce/label/c.Search_Or_Create_Site_Contact_Phone_Label";
import Search_Or_Create_Site_Contact_Phone_Ext_Label from "@salesforce/label/c.Search_Or_Create_Site_Contact_Phone_Ext_Label";
import Search_Or_Create_Site_Contact_Mobile_Label from "@salesforce/label/c.Search_Or_Create_Site_Contact_Mobile_Label";
import Search_Or_Create_Site_Contact_Title_Label from "@salesforce/label/c.Search_Or_Create_Site_Contact_Title_Label";
import Search_Or_Create_Site_Contact_Decision_Maker_Label from "@salesforce/label/c.Search_Or_Create_Site_Contact_Decision_Maker_Label";
import Search_Or_Create_Site_Contact_Role_Label from "@salesforce/label/c.Search_Or_Create_Site_Contact_Role_Label";
import Search_Or_Create_Site_Contact_Last_Activity_Date_Label from "@salesforce/label/c.Search_Or_Create_Site_Contact_Last_Activity_Date_Label";
import Search_Or_Create_Site_Contact_Friendly_Error from "@salesforce/label/c.Search_Or_Create_Site_Contact_Friendly_Error";
import Utils_Cancel_Text from "@salesforce/label/c.Utils_Cancel_Text";
import Search_Or_Create_Site_Contact_Create_From_Selection from "@salesforce/label/c.Search_Or_Create_Site_Contact_Create_From_Selection";
import Search_Or_Create_Site_Contact_Create_From_New_Contact from "@salesforce/label/c.Search_Or_Create_Site_Contact_Create_From_New_Contact";
import Create_Site_Contact_Title from "@salesforce/label/c.Create_Site_Contact_Title";

export default class searchOrCreateSiteContact extends LightningElement {
  @api recordId;
  @api isFlow = false;
  @track search_started = false;
  @track operation_in_progress = false;
  @track result_header;
  @track result_data;
  @track search_error;
  @track friendly_error;
  @track contact_not_selected = true;
  @track selected_contact = {};
  @track create_new_contact = false;
  @track related_account_id;
  @track search_filters;
  @track redirect;
  @track show_result_modal = false;
  @track englishLabels = {
    name: Search_Or_Create_Site_Contact_Name_Label,
    email: Search_Or_Create_Site_Contact_Email_Label,
    phone: Search_Or_Create_Site_Contact_Phone_Label,
    phoneExt: Search_Or_Create_Site_Contact_Phone_Ext_Label,
    mobile: Search_Or_Create_Site_Contact_Mobile_Label,
    title: Search_Or_Create_Site_Contact_Title_Label,
    decisionMaker: Search_Or_Create_Site_Contact_Decision_Maker_Label,
    role: Search_Or_Create_Site_Contact_Role_Label,
    lastActivityDate: Search_Or_Create_Site_Contact_Last_Activity_Date_Label,
    friendlyError: Search_Or_Create_Site_Contact_Friendly_Error,
    cancel: Utils_Cancel_Text,
    createFromSelection: Search_Or_Create_Site_Contact_Create_From_Selection,
    createFromNewContact: Search_Or_Create_Site_Contact_Create_From_New_Contact,
    createSiteContactTitle: Create_Site_Contact_Title
  }
  @track frenchLabels = {
    name: Search_Or_Create_Site_Contact_Name_Label,
    email: Search_Or_Create_Site_Contact_Email_Label,
    phone: Search_Or_Create_Site_Contact_Phone_Label,
    phoneExt: Search_Or_Create_Site_Contact_Phone_Ext_Label,
    mobile: Search_Or_Create_Site_Contact_Mobile_Label,
    title: Search_Or_Create_Site_Contact_Title_Label,
    decisionMaker: Search_Or_Create_Site_Contact_Decision_Maker_Label,
    role: Search_Or_Create_Site_Contact_Role_Label,
    lastActivityDate: Search_Or_Create_Site_Contact_Last_Activity_Date_Label,
    friendlyError: Search_Or_Create_Site_Contact_Friendly_Error,
    cancel: 'Annuler',
    createFromSelection: 'Créer à partir de sélection',
    createFromNewContact: 'Créer à partir de nouveau contact',
    createSiteContactTitle: 'Créer un contact'
  }
  @track contacts;
  @track total_contacts;
  @track contacts_offset = 0;
  @track contacts_incriment = 20;
  @track contacts_limit = 20;
  @track contact_header = [
    // { label: "Id", fieldName: "Id", type: "text" },
    {
      label: Search_Or_Create_Site_Contact_Name_Label,
      fieldName: "Name",
      type: "text",
    },
    {
      label: Search_Or_Create_Site_Contact_Email_Label,
      fieldName: "Email",
      type: "email",
    },
    {
      label: Search_Or_Create_Site_Contact_Phone_Label,
      fieldName: "Phone",
      typeAttributes: { recordId: { fieldName: 'Id' } },
      type: "caller",
    },
    {
      label: Search_Or_Create_Site_Contact_Phone_Ext_Label,
      fieldName: "Phone_Ext__c",
      type: "text",
    },
    {
      label: Search_Or_Create_Site_Contact_Mobile_Label,
      fieldName: "MobilePhone",
      type: "caller",
    },
    {
      label: Search_Or_Create_Site_Contact_Title_Label,
      fieldName: "Title",
      type: "text",
    },
    {
      label: Search_Or_Create_Site_Contact_Decision_Maker_Label,
      fieldName: "Decision_Maker__c",
      type: "text",
    },
    {
      label: Search_Or_Create_Site_Contact_Role_Label,
      fieldName: "Role__c",
      type: "text",
    },
    {
      label: Search_Or_Create_Site_Contact_Last_Activity_Date_Label,
      fieldName: "LastActivityDate",
      type: "date",
    },
  ];

  @track contacts_infinite_loading = true;
  @track loading_more_contacts = false;

  @track labels = {
  };

  get_site_contacts = async () => {
    this.contacts_offset += this.contacts_incriment;
    if (this.contacts_offset + this.contacts_limit >= this.total_contacts) {
      this.contacts_infinite_loading = false;
    }

    try {
      let contacts = await getSiteContacts({
        account_id: this.related_account_id,
        site_account_id: this.recordId,
      });

      let new_contacts = contacts.map(function (site) {
        let number = site.Phone;
        let id = site.Id;

        site.Phone = {
          phone: number,
          recordId: id,
        };
        let mobile = site.MobilePhone;

        site.MobilePhone = {
          phone: mobile,
          recordId: id,
        };

        return site;
      });
      console.log(JSON.stringify(new_contacts));
      this.contacts = contacts;
      console.log(JSON.stringify(this.contacts));
    } catch (error) {
      console.error(JSON.stringify(error));
      this.error = error;
      this.friendly_error = Search_Or_Create_Site_Contact_Friendly_Error;
    } finally {
      this.loading_more_contacts = false;
    }
  };

  get_parent_account = async () => {
    try {
      let site_account = await getSiteInfo({
        site_account_id: this.recordId,
      });
      this.related_account_id = site_account.Related_Account__c;
      this.search_filters = "AccountId:Eq:" + this.related_account_id;
      console.log(JSON.stringify(this.search_filters));

      let contacts = await getSiteContacts({
        account_id: this.related_account_id,
        site_account_id: this.recordId,
      });
      console.log(JSON.stringify(contacts));

      this.contacts = contacts;
    } catch (error) {
      console.error(JSON.stringify(error));
      this.error = error;
      this.friendly_error =
        "An error occured while retrieving Parent Account Id.";
    } finally {
    }
  };

  connectedCallback() {
    this.get_parent_account();
    getCurrentUserLocale()
      .then(response => {
        if (response == 'fr') {
          this.labels = this.frenchLabels;
        }
        else if (response == 'en_US') {
          this.labels = this.englishLabels;
        }
      })
      .catch(error => {
        console.error(error);
      })
  }

  onSearch(event) {
    console.log(JSON.stringify(event.detail));
    this.result_header = event.detail.header;
    this.result_data = event.detail.data;
    if (this.result_data.length === 0) {
      this.search_error = true;
      this.friendly_error = "No records found.";
    }
    this.operation_in_progress = false;
  }
  onSearchEnd(event) {
    console.log("Search Ended");
    this.operation_in_progress = false;
  }
  onSearchStart(event) {
    console.log("Search Started");
    this.search_error = false;
    this.search_started = true;
    this.operation_in_progress = true;
    this.contact_not_selected = true;
    this.selected_contact = {};
    this.show_result_modal = true;
  }
  handleSelectedRow(event) {
    console.log(JSON.stringify(event.detail));
    this.selected_contact = event.detail.selectedRows[0];
    this.contact_not_selected = false;
  }

  handleCloseModal(event) {
    this.show_result_modal = false;
  }

  createNewContact() {
    console.log("Create New Contact");
    this.create_new_contact = true;
    this.show_result_modal = false;
  }

  handleCreateContactClose(event) {
    this.create_new_contact = false;
    this.show_result_modal = true;
  }

  create_site_contact = async () => {
    let success = false;
    try {
      let created_site_contact = await createSiteExistingContact({
        site_account_id: this.recordId,
        contact_id: this.selected_contact.Id,
      });
      console.log(JSON.stringify(created_site_contact));
      success = true;
    } catch (error) {
      this.error = error;
      this.friendly_error = "An error occured while creating the site contact!";
    } finally {
      this.operation_in_progress = false;
    }

    if (success && this.isFlow) {
      this.dispatchEvent(new FlowNavigationNextEvent());
    } else if (success) {
      location.reload();
    }
  };

  handleSubmission(event) {
    this.operation_in_progress = true;
    this.create_site_contact();
  }

  load_more_site_contacts() {
    console.log("LOAD MORE");
    this.loading_more_contacts = true;
    this.get_site_contacts();
  }
}