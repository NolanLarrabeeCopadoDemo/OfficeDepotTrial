import { LightningElement, api, track } from "lwc";
import Search_Or_Create_Site_Contact_Title from '@salesforce/label/c.Search_Or_Create_Site_Contact_Title';
export default class CollapsibleSearchCreateSiteContact extends LightningElement {
  @api recordId;
  @api startCollapsed;
  @api isCollapsible;
  @track active_section = "";

  @track labels = {
    Search_Or_Create_Site_Contact_Title
  };

  connectedCallback() {
    if (this.startCollapsed) this.active_section = "SearchCreateSite";
  }
}