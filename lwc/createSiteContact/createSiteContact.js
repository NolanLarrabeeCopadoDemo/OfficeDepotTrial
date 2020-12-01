import { LightningElement, api, track } from "lwc";
import createSiteNewContact from "@salesforce/apex/SearchOrCreateSiteContact.createSiteNewContact";
import getCurrentUserLocale from "@salesforce/apex/LightningAccountSalesHistory.getCurrentUserLocale";
import { FlowNavigationNextEvent } from "lightning/flowSupport";

import Create_Site_Contact_Title from '@salesforce/label/c.Create_Site_Contact_Title';
import Utils_Loading_Text from '@salesforce/label/c.Utils_Loading_Text';
import Utils_Submit_Text from '@salesforce/label/c.Utils_Submit_Text';
import Utils_Cancel_Text from '@salesforce/label/c.Utils_Cancel_Text';
import Create_Site_Contact_First_Name from '@salesforce/label/c.Create_Site_Contact_First_Name';
import Create_Site_Contact_Last_Name from '@salesforce/label/c.Create_Site_Contact_Last_Name';
import Create_Site_Contact_Email from '@salesforce/label/c.Create_Site_Contact_Email';
import Create_Site_Contact_Business_Phone from '@salesforce/label/c.Create_Site_Contact_Business_Phone';
import Create_Site_Contact_Friendly_Error from '@salesforce/label/c.Create_Site_Contact_Friendly_Error';
export default class CreateSiteContact extends LightningElement {
  @api account_id;
  @api backdrop = false;
  @api isFlow = false;
  @track form_data = {};
  @track operation_in_progress;

  @track otherLabels = {
    Create_Site_Contact_Title,
    Utils_Loading_Text,
    Utils_Submit_Text,
    Utils_Cancel_Text,
    Create_Site_Contact_First_Name,
    Create_Site_Contact_Last_Name,
    Create_Site_Contact_Email,
    Create_Site_Contact_Business_Phone,
    Create_Site_Contact_Friendly_Error
  }

  @track error;
  @track englishLabels = {
    createSiteContactTitle: 'Create Site Contact',
    submit: 'Submit',
    cancel: 'Cancel'
  };
  @track frenchLabels = {
    createSiteContactTitle: 'Créer un contact',
    submit: 'Envoyer',
    cancel: 'Annuler'
  };
  @track labels = {};

  connectedCallback() {
    console.log(JSON.stringify(this.account_id));
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

  handleInputChange(event) {
    this.form_data[event.target.name] = event.target.value;
    console.log(JSON.stringify(this.form_data));
  }

  closeNewSiteContact() {
    this.dispatchEvent(new CustomEvent("close"));
  }

  create_contact = async () => {
    let success = false;
    try {
      let result = await createSiteNewContact({
        site_account_id: this.account_id,
        contact_data: this.form_data,
      });
      console.log(JSON.stringify(result));
      success = true;
    } catch (error) {
      this.error = error;
    } finally {
      this.operation_in_progress = false;
    }
    if (success && this.isFlow) {
      this.dispatchEvent(new FlowNavigationNextEvent());
    } else if (success) {
      location.reload();
    }
  };

  handleSubmit() {
    this.operation_in_progress = true;
    this.create_contact();
  }
}