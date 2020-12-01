import { LightningElement,api,wire, track } from 'lwc';
import getContractHistoryList from '@salesforce/apex/ContractHistoryCompareController.getContractHistoryList'; 
import getContractHistoryCompareData from '@salesforce/apex/ContractHistoryCompareController.getContractHistoryCompareData';
import getContractFieldsData from '@salesforce/apex/ContractHistoryCompareController.getContractFieldsData';
import reportLink from '@salesforce/label/c.Contract_history_audit_lightning_link';
export default class ContractHistoryCompare extends LightningElement {
    @api recordId = '8001k000000QHBKAA4';
    contractHistoryList;
    @track options=[];
    @track value1;
    @track value2;
    @track data = [];
    @track v1createddate;
    @track v2createddate;
    @track v1modifiedby;
    @track v2modifiedby;   
    @track defaultSortDirection = 'asc';
    @track sortDirection = 'asc';
    @track sortedBy;
    //@track showSpinner = true;
    @track changed =false;
    @track listOptions = [];
    @track defaultOptions = [     
    'most_favored_contract_language__c',
    'x3rd_party_required_to_provide_a_securit__c',
    'account_extension_name__c',       
    'account_name__c',
    'account_org__c',
    'account_recordtype__c',
    //'agreement_respon_based_on_cat_prod_assor__c',
    'agreement_allow_for_custom_cores__c',
    'agreement_provide_disco_on_spec_orders__c',
    'call_out_cost_plus_floor__c',        
    'any_other_callouts_from_legal__c',
    'aops_cust_id__c',
    //'apply_child_core_written_agree_lang__c',
    //'apply_parent_cust_core_agreement_lang__c',
    //'aprimo_id__c',
    'call_out_auto_force_sub__c',
    //'are_there_child_sku_count_limits__c',
    'are_there_gp_sku_count_limitations__c',
    //'are_there_parent_sku_count_limitations__c',
    'are_there_rebates_incentives__c',
    //'are_there_standalone_sku_count_limit__c',
    'call_out_sub_language__c',
    'basis_level_for_customer_agreement__c',
    //'catalog_product_assortment__c',       
    //'child_account_name__c',
    //'child_account_number__c',
    //'child_annual_spend_description__c',       
    //'child_annual_spend_requirement_amount__c',
    //'child_bid_agreement_number__c',
    //'child_core_have_capped_price_increase__c',
    //'child_core_list_capped_price_increase__c',
    //'child_core_sku_level_capped_price_incr__c',
    //'child_cust_core_update_notice_type__c',
    //'child_cust_core_upd_notice_period__c',
    //'child_cust_core_upd_notice_period_other__c',
    //'child_custom_core_discount_basis__c',
    //'child_custom_core_discount_percent__c',
    //'child_decr_req_to_be_applied_to_cus_core__c',
    //'child_floor_structure_description__c',
    //'child_man_ven_letter_req_for_increase__c',
    //'child_pricing_update_frequency__c',
    //'child_pricing_update_frequency_other__c',
    //'child_sku_cap_dollar_amount__c',
    //'child_sku_cap_percent_amount__c',
    //'child_sku_count_limitation__c',
    'clawback_provision_language__c',       
    'contract_admin__c',
    'contract_allow_for_dependent_pricing_rel__c',
    'contract_cover_noncore_cat_setup_pricing__c',
    'contract_data_verified__c',
    'contract_development_negotiation_mgr__c',
    //'contract_extension_authorization_type__c',
    'contract_extensions__c',
    'contract_lifecycle_manager__c',                
    'contract_state_minimum_order__c',
    'contract_state_a_furniture_delivery_fee__c',
    'contract_state_a_small_order_fee_charge__c',
    'contract_state_restocking_fees_excluded__c',
    'contract_status__c',
    //'contract_term__c',
    'contract_type__c',
    'core_of_annual_volume__c'];
    //@track requiredOptions = ['2', '7'];

    columns = [
        { label: 'Field Name', fieldName: 'fieldname', sortable: true }, 
        { label: 'API Name ', fieldName: 'name' },
        { label: 'Version ', fieldName: 'version1', type: 'text' },
        { label: 'Version ', fieldName: 'version2', type: 'text' },
    ];

    @wire(getContractHistoryList, { Id: '$recordId' })
    wiredContractHistory({ error, data }) {      
        if (data) { 
            this.contractHistoryList = data;
            let tempOptions = [];
            //alert(this.contractHistoryList.length);
            for (let i = 0; i < this.contractHistoryList.length; i++) {
                let date = this.contractHistoryList[i].LastModifiedDate.split("T");
                //alert(date[0]);
                tempOptions.push({ label: this.contractHistoryList[i].Name+' '+date[0]+' '+this.contractHistoryList[i].LastModifiedBy.Name, value: this.contractHistoryList[i].Name });
              }
              tempOptions.sort(function(a, b){               
                return parseInt(a.value)-parseInt(b.value)
               })
              tempOptions.reverse();
              tempOptions.unshift({label:'Current', value:'current'});  
              this.options = tempOptions;
            //alert(this.options);
            //this.showSpinner = false;
        }
        else if (error) { 

        }   
    }
   
    handleChange1(event) {
        this.value1 = event.detail.value;
    }

    handleChange2(event) {       
        this.value2 = event.detail.value;
    }

    handleChange3(event){     
        this.changed =  event.target.checked;        
    }

    handleClick(){
        //this.showSpinner = true;      
        getContractHistoryCompareData({ version1: this.value1, version2: this.value2, contractId:this.recordId, changed: this.changed, fields: JSON.stringify(this.defaultOptions) })
        .then(result => {
            let tempdata = result;
            this.data = tempdata;
            for(let i = 0; i <tempdata.length ; i++) {                
                if(tempdata[i].name =='LastModifiedDate'){
                    this.v1createddate = tempdata[i].version1;
                    this.v2createddate = tempdata[i].version2;
                }
                if(tempdata[i].name =='LastModifiedBy'){
                    this.v1modifiedby = tempdata[i].version1;
                    this.v2modifiedby = tempdata[i].version2;
                }
            }
            let columnsNew = [
                { label: 'Field Name', fieldName: 'fieldname', sortable: true },
                { label: 'API Name ', fieldName: 'name' },
                { label: 'Version '+this.value1, fieldName: 'version1', type: 'text' },
                { label: 'Version '+this.value2, fieldName: 'version2', type: 'text' },
            ];
            this.columns = columnsNew;
            //alert(result);
            //this.showSpinner = false;
        })
        .catch(error => {
            //this.error = error;
            //this.showSpinner = false;
        });
    }

    handleClearClick(){
        this.value1='';
        this.value2='';
        this.data = [];
        this.v1createddate='';
        this.v2createddate='';
        this.v1modifiedby='';
        this.v2modifiedby=''; 
        this.changed = false;
    }

    // Used to sort the 'Field' column
    sortBy(field, reverse, primer) {
        const key = primer
            ? function(x) {
                  return primer(x[field]);
              }
            : function(x) {
                  return x[field];
              };

        return function(a, b) {
            a = key(a);
            b = key(b);
            return reverse * ((a > b) - (b > a));
        };
    }

    onHandleSort(event) {
        const { fieldName: sortedBy, sortDirection } = event.detail;
        const cloneData = [...this.data];

        cloneData.sort(this.sortBy(sortedBy, sortDirection === 'asc' ? 1 : -1));
        this.data = cloneData;
        this.sortDirection = sortDirection;
        this.sortedBy = sortedBy;
    }
 
    handlePopup() {
        this.template.querySelector("section").classList.remove("slds-hide");
        this.template
          .querySelector("div.modalBackdrops")
          .classList.remove("slds-hide");
      }

    handleSkip() {
        this.template.querySelector("section").classList.add("slds-hide");
        this.template
        .querySelector("div.modalBackdrops")
        .classList.add("slds-hide");
    }

    handleChange(event) {
        // Get the list of the "value" attribute on all the selected options
        let selectedOptionsList = event.detail.value;
        //alert('Options selected: ${selectedOptionsList}');
        this.defaultOptions = selectedOptionsList;
        ///alert('Updated picklist successfully.');
    }


    connectedCallback() {
        getContractFieldsData()
        .then(result => {
            let tempdata = [];            
            var r = Object.keys(result).map(function (key) { 
                tempdata.push({ value: key, label: result[key] });                
                return [key, result[key]]; 
            });
            tempdata.sort(function(a, b){               
                var x = a.label.toLowerCase();
                var y = b.label.toLowerCase();
                if (x < y) {return -1;}
                if (x > y) {return 1;}
                return 0;
               })             
            this.listOptions = tempdata;          
        })
        .catch(error => {
           
        });
    }

    handleReportClick(){
        window.open(reportLink+'?fv0='+this.recordId,'_blank');
    }
}