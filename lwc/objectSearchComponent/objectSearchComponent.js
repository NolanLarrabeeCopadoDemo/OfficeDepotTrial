import { LightningElement, api, track } from "lwc";
import getObjectFields from "@salesforce/apex/ObjectSearchLWC.getObjectFields";
import runSOQLSearch from "@salesforce/apex/ObjectSearchLWC.runSOQLSearch";
import getCurrentUserLocale from "@salesforce/apex/LightningAccountSalesHistory.getCurrentUserLocale";
import Utils_Loading_Text from '@salesforce/label/c.Utils_Loading_Text';
import Object_Search_Component_Friendly_Error from '@salesforce/label/c.Object_Search_Component_Friendly_Error';
import Utils_Search_Text from '@salesforce/label/c.Utils_Search_Text';

export default class ObjectSearchComponent extends LightningElement {
  @api search_fields;
  @api search_object;
  @api search_title;
  @api search_filters;
  @track search_values = {};
  @track field_list;
  @track error;
  @track isLoaded;
  @track search_inprogress = false;
  @track input_valid = false;

  @track search_disabled = this.search_inprogress || !this.input_valid;
  @track englishLabels = {
    loading: Utils_Loading_Text,
    friendlyError: Object_Search_Component_Friendly_Error,
    search: Utils_Search_Text
  }
  @track frenchLabels = {
    loading: Utils_Loading_Text,
    friendlyError: Object_Search_Component_Friendly_Error,
    search: 'Rechercher'
  }
  @track labels = {
  }

  connectedCallback() {
    if (this.search_title === "")
      this.search_title = this.search_object + " " + Utils_Search_Text;
    this.init();
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

  init = async () => {
    let search_object_list = this.search_fields.split(",");
    let search_object = this.search_object;
    try {
      let field_list = await getObjectFields({
        object_api_name: search_object,
        field_list: search_object_list,
      });
      this.field_list = field_list;
    } catch (error) {
      this.error = error;
    } finally {
      this.isLoaded = true;
    }
  };

  do_search = async () => {
    let field_list = this.field_list;
    let search_object = this.search_object;
    let search_filters = this.search_filters;

    console.log(JSON.stringify(search_filters));

    try {
      let search_result = await runSOQLSearch({
        object_api_name: search_object,
        query_fields: JSON.stringify(field_list),
        filter: search_filters,
      });

      let result_header = field_list.map(function (field_entry) {
        return {
          label: field_entry.field_label,
          type: field_entry.field_type,
          fieldName: field_entry.field_name,
        };
      });

      this.dispatchEvent(
        new CustomEvent("search", {
          detail: { header: result_header, data: search_result },
        })
      );
    } catch (error) {
      this.search_error = error;
    } finally {
      this.search_inprogress = false;
      this.isLoaded = true;
      this.search_disabled = this.search_inprogress || !this.input_valid;
      this.dispatchEvent(new CustomEvent("searchend"));
    }
  };

  handleInputChange(event) {
    this.search_values[event.target.name] = event.target.value;

    let input = Object.values(this.search_values).reduce(function (
      accumulator,
      field_entry
    ) {
      return accumulator + field_entry;
    });

    if (input.length === 0) {
      this.input_valid = false;
    } else {
      this.input_valid = true;
    }
    this.search_disabled = this.search_inprogress || !this.input_valid;
  }

  handleSearch() {
    this.dispatchEvent(new CustomEvent("searchstart"));
    this.search_inprogress = true;
    this.search_disabled = this.search_inprogress || !this.input_valid;

    let search_component = this;
    this.field_list = this.field_list.map(function (field_entry) {
      if (search_component.search_values[field_entry.field_name])
        field_entry.value =
          search_component.search_values[field_entry.field_name];
      else field_entry.value = "";
      return field_entry;
    });

    this.do_search();
  }
}