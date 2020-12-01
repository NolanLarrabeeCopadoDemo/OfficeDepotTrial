import { LightningElement, api, track } from "lwc";

export default class ObjectDisplayComponent extends LightningElement {
  @api field_list; // The list of fields to display in order from left to right as a comma seperated string.
  @api object_api_name; // The api name odf the object to display.
  @api object_record_id; // The record id of the object to display.
  @track actual_field_list = [];
  @track isLoaded = false;

  connectedCallback() {
    this.actual_field_list = this.field_list.split(",");
    this.isLoaded = true;
  }
}