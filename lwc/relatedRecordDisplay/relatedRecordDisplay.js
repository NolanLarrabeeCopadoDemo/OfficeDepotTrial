import { LightningElement, api } from "lwc";
import getFieldsFromObject from "@salesforce/apex/MyUtils.getFieldsFromObject";
export default class RelatedRecordDisplay extends LightningElement {
  @api field_names = ["Name"];
  @api related_record_field_name;
  @api object_api_name;
  @api objectApiName; // The Record Name
  @api recordId; // The Record Id
  related_record_id;
  ready = false;
  error = null;
  friendly_error = "No records found.";

  connectedCallback() {
    this.get_related_record_data();
  }

  get_related_record_data = async () => {
    try {
      let parent_record_data = await getFieldsFromObject({
        sObjectName: this.objectApiName,
        recordId: this.recordId,
        fields: [this.related_record_field_name],
      });
      if (String(this.related_record_field_name).includes("__r")) {
        let identifiers = this.related_record_field_name.split(".");
        if (parent_record_data.hasOwnProperty(identifiers[0]))
          this.related_record_id =
            parent_record_data[identifiers[0]][identifiers[1]];
      } else {
        this.related_record_id =
          parent_record_data[this.related_record_field_name];
      }

      this.ready = true;

      // TODO: Remove the Comments
      console.log("Field Names:", this.field_names);
      console.log("Related Record Field Name:", this.related_record_field_name);
      console.log("Object API Name:", this.object_api_name);
      console.log("Related Record Id:", this.related_record_id);
      console.log(
        "Parent Data Retrieved: ",
        JSON.stringify(parent_record_data)
      );

      if (!this.related_record_id) {
        this.error = {
          message: `
                Field Names: ${this.field_names}
                Related Record Field Name: ${this.related_record_field_name}
            `,
        };
      }
    } catch (error) {
      console.error(`
      Field Names: ${this.field_names}
      Related Record Field Name: ${this.related_record_field_name}
    `);
      this.error = error;
    }
  };
}