import { LightningElement, api, track } from "lwc";
import getDmlIdFromAccount from "@salesforce/apex/DmlDisplay.getDmlIdFromAccount";
export default class DmlDisplayComponent extends LightningElement {
  @api recordId;
  @api field_list;
  @track dml_id;
  @track isLoaded = false;
  @track error = false;
  
  get_dml_id = async () => {
    try {
      let dml_id = await getDmlIdFromAccount({
        account_id: this.recordId,
      });
      this.dml_id = dml_id;
    } catch (error) {
      console.error("No DML records found.");
      this.error = error;
    } finally {
      this.isLoaded = true;
    }
  };

  connectedCallback() {
    this.get_dml_id();
  }
}