import { LightningElement,track,api,wire } from 'lwc';
import { getPicklistValues } from 'lightning/uiObjectInfoApi';
import ROLE_FIELD from '@salesforce/schema/Contact.Role__c';
import PRODUCT_FOCUS_FIELD from '@salesforce/schema/Contact.Product_Focus__c';
import commitProspects from '@salesforce/apex/BulkProspectUploadController.commitProspects';
import { getPicklistValuesByRecordType } from 'lightning/uiObjectInfoApi';
import { getObjectInfo } from 'lightning/uiObjectInfoApi';
import ACCOUNT_OBJECT from '@salesforce/schema/Account';
const actions = [
    { label: 'Prospect Information', name: 'show_details' },
    
];
const columns = [
    { label: 'Name', fieldName: 'Name',type: 'text' },
    { label: 'Address1', fieldName: 'Address1__c', type: 'text' },
    { label: 'Address2', fieldName: 'Address2__c', type: 'text' },
    { label: 'City', fieldName: 'City__c', type: 'text' },
    { label: 'Country', fieldName: 'Country__c', type: 'text' },
    { label: 'State', fieldName: 'State__c', type: 'text' },
    { label: 'Zip', fieldName: 'Zip__c', type: 'text' },
    {
        type: 'action',
        typeAttributes: { rowActions: actions },
    },
];

export default class BulkProspectEDITInsert extends LightningElement {
    columns = columns;
    @track roleOptions=[];
    @track productFocusOptions =[];
    @track index=0; 
    @track prospect ={
      "Index":"0",
      "Name": "",
      "Address1__c": "",
      "Address2__c": "",
      "City__c": "",
      "Country__c": "",
      "State__c": "",
      "Zip__c": "",

      "FirstName": "",
      "LastName": "",
      "Email": "",
      "Title": "",
      "Department": "",
      "Phone1_Rep__c": "",
      "Phone_Type1__c": "",
      "Decision_Maker__c":"",
      "Phone_Ext__c":"",
      "Role__c":"",
      "Product_Focus__c":"",

      "Phone":"",
      "Sector__c":"",
      "Segment__c":"",
      "Buying_Group__c":"",
      "Pricing_template_cd__c":"",
      "Industry_OD_SIC_Rep__c":"",
      "Website":"",
      "Org_WCW_Count_Rep__c":"",
      "Est_Spend__c":"",
      "Payment_Term__c":"",
      "Primary_Product__c":"",
      "Rep_Call_Date__c":new Date(),
      "Location_Type__c":"",
      "Related_Pricing_Template_Account__c":"",
      "MPS_Parent_Account__c":""     
    };
    @api jsonorg =[];
    @api jsondata = [];
    @track prospectjson=[];
    @track showSpinner= false;
    

    handleRowAction(event) {
        const actionName = event.detail.action.name;
        const row = event.detail.row;
        switch (actionName) {
            case 'edit':
                this.deleteRow(row);
                break;
            case 'show_details':
                this.showRowDetails(row);
                break;
            default:
        }
    }

    findRowIndexById(Index) {
        let ret = -1;
        this.jsondata.some((row, index) => {
            if (row.Index === Index) {
                ret = index;
                return true;
            }
            return false;
        });
        return ret;
    }

    showRowDetails(row) {
        //this.record = row;
        const { Index } = row;
        this.index = this.findRowIndexById(Index);
        this.prospect = {};
        if(this.prospectjson === undefined || this.prospectjson.length == 0){
            this.prospectjson = JSON.parse(JSON.stringify(this.jsondata));
        }
        this.prospect = this.prospectjson[this.index];
        if(this.prospect){
            if(this.prospect.Segment__c === undefined || this.prospect.Segment__c === ''){
                this.disable_Segment = true;
                this.disable_Buying_Group= true;
                this.disable_Pricing_template= true;
                this.disable_Industry_OD_SIC_Rep= true;
            }
            if(this.prospect.Buying_Group__c === undefined || this.prospect.Buying_Group__c === ''){
                this.disable_Buying_Group= true;
                this.disable_Pricing_template= true;
                this.disable_Industry_OD_SIC_Rep= true;
            }
            if(this.prospect.Pricing_template_cd__c === undefined || this.prospect.Pricing_template_cd__c === ''){
                this.disable_Pricing_template= true;
            }
            if(this.prospect.Industry_OD_SIC_Rep__c === undefined || this.prospect.SeIndustry_OD_SIC_Rep__cgment__c === ''){
                this.disable_Industry_OD_SIC_Rep= true;
            }
        }
        
        this.template.querySelector("section").classList.remove("slds-hide");
        this.template.querySelector("div.modalBackdrops").classList.remove("slds-hide");
    }

    handleClick(event){
        this.template.querySelector("section").classList.add("slds-hide");
        this.template.querySelector("div.modalBackdrops").classList.add("slds-hide");
    }

    // Account object info
    @wire(getObjectInfo, { objectApiName: ACCOUNT_OBJECT })
    objectInfo;

    @track sectorOptions = [];
    @track segmentOptions = [];
    @track buyingGroupOptions = [];
    @track pricingTemplateOptions = [];
    @track Industry_OD_SIC_RepOptions = [];
    controlValues_Segment;
    controlValues_Buying_Group;
    controlValues_Pricing_template;
    controlValues_Industry_OD_SIC_Rep;
    totalDependentValues_Segment=[];
    totalDependentValues_Buying_Group=[];
    totalDependentValues_Pricing_template=[];
    totalDependentValues_Industry_OD_SIC_Rep=[];
    @track disable_Segment = true;
    @track disable_Buying_Group= true;
    @track disable_Pricing_template= true;
    @track disable_Industry_OD_SIC_Rep= true;

    // Picklist values based on record type
    @wire(getPicklistValuesByRecordType, { objectApiName: ACCOUNT_OBJECT, recordTypeId:'012E00000008dTbIAI' }) //'$objectInfo.data.defaultRecordTypeId'
    countryPicklistValues({error, data}) {
        if(data) {
            this.error = null;

            let sectorOptions = [{label:'--None--', value:''}];
            // Account Country Control Field Picklist values
            data.picklistFieldValues.Sector__c.values.forEach(key => {
                sectorOptions.push({
                    label : key.label,
                    value: key.value
                })
            });
            this.sectorOptions = sectorOptions;

            let segmentOptions = [{label:'--None--', value:''}];
             // Account State Control Field Picklist values
            this.controlValues_Segment = data.picklistFieldValues.Segment__c.controllerValues;
            // Account State dependent Field Picklist values
            this.totalDependentValues_Segment = data.picklistFieldValues.Segment__c.values;
            this.totalDependentValues_Segment.forEach(key => {
                segmentOptions.push({
                    label : key.label,
                    value: key.value
                })
            });
            this.segmentOptions = segmentOptions;

            let buyingGroupOptions = [{label:'--None--', value:''}];
             // Account State Control Field Picklist values
            this.controlValues_Buying_Group = data.picklistFieldValues.Buying_Group__c.controllerValues;
            // Account State dependent Field Picklist values
            this.totalDependentValues_Buying_Group = data.picklistFieldValues.Buying_Group__c.values;
            this.totalDependentValues_Buying_Group.forEach(key => {
                buyingGroupOptions.push({
                    label : key.label,
                    value: key.value
                })
            });
            this.buyingGroupOptions = buyingGroupOptions; 

            let pricingTemplateOptions = [{label:'--None--', value:''}];
             // Account State Control Field Picklist values
            this.controlValues_Pricing_template = data.picklistFieldValues.Pricing_template_cd__c.controllerValues;
            // Account State dependent Field Picklist values
            this.totalDependentValues_Pricing_template = data.picklistFieldValues.Pricing_template_cd__c.values;
            this.totalDependentValues_Pricing_template.forEach(key => {
                pricingTemplateOptions.push({
                    label : key.label,
                    value: key.value
                })
            });
            this.pricingTemplateOptions = pricingTemplateOptions; 

            let Industry_OD_SIC_RepOptions = [{label:'--None--', value:''}];
             // Account State Control Field Picklist values
            this.controlValues_Industry_OD_SIC_Rep = data.picklistFieldValues.Industry_OD_SIC_Rep__c.controllerValues;
            // Account State dependent Field Picklist values
            this.totalDependentValues_Industry_OD_SIC_Rep = data.picklistFieldValues.Industry_OD_SIC_Rep__c.values;
            this.totalDependentValues_Industry_OD_SIC_Rep.forEach(key => {
                Industry_OD_SIC_RepOptions.push({
                    label : key.label,
                    value: key.value
                })
            });
            this.Industry_OD_SIC_RepOptions = Industry_OD_SIC_RepOptions;
        }
        else if(error) {
            this.error = JSON.stringify(error);
        }
    }

    handleCountryChange(event) {
        // Selected Country Value
        var value = event.target.value;
        var label = event.target.name;

        //this.isEmpty = false;
        let dependValues = [{label:'--None--', value:''}];
        let dependValues2 = [{label:'--None--', value:''}];

        if(label == 'Sector__c'){
            if(value) {
                // if Selected country is none returns nothing
                if(value === '') {
                    this.disable_Segment = true;
                    this.disable_Buying_Group= true;
                    this.disable_Pricing_template= true;
                    this.disable_Industry_OD_SIC_Rep= true;
                    dependValues = [{label:'--None--', value:''}];
                    return;
                }
                this.disable_Segment = false;
                // filter the total dependent values based on selected country value 
                this.totalDependentValues_Segment.forEach(conValues => {
                    for(var i=0;i<conValues.validFor.length;i++){
                        if(conValues.validFor[i] === this.controlValues_Segment[value]) {
                            dependValues.push({
                                label: conValues.label,
                                value: conValues.value
                            })
                        }
                    }
                    
                })
    
                this.segmentOptions = dependValues;
            }
        }
        if(label == 'Segment__c'){
            if(value) {
                // if Selected country is none returns nothing
                if(value === '') {
                   
                    this.disable_Buying_Group= true;
                    this.disable_Pricing_template= true;
                    this.disable_Industry_OD_SIC_Rep= true;
                    dependValues = [{label:'--None--', value:''}];
                    return;
                }
                this.disable_Buying_Group = false;
                // filter the total dependent values based on selected country value 
                this.totalDependentValues_Buying_Group.forEach(conValues => {
                    for(var i=0;i<conValues.validFor.length;i++){
                        if(conValues.validFor[i] === this.controlValues_Buying_Group[value]) {
                            dependValues.push({
                                label: conValues.label,
                                value: conValues.value
                            })
                        }
                    }
                    
                })
    
                this.buyingGroupOptions = dependValues;

                this.disable_Industry_OD_SIC_Rep = false;
                // filter the total dependent values based on selected country value 
                this.totalDependentValues_Industry_OD_SIC_Rep.forEach(conValues => {
                    for(var i=0;i<conValues.validFor.length;i++){
                        if(conValues.validFor[i] === this.controlValues_Industry_OD_SIC_Rep[value]) {
                            dependValues2.push({
                                label: conValues.label,
                                value: conValues.value
                            })
                        }
                    }
                    
                })
    
                this.Industry_OD_SIC_RepOptions = dependValues2;
            }
        }
        if(label == 'Buying_Group__c'){
            if(value) {
                // if Selected country is none returns nothing
                if(value === '') {
                    this.disable_Pricing_template= true;
                    this.disable_Industry_OD_SIC_Rep= true;
                    dependValues = [{label:'--None--', value:''}];
                    return;
                }
                this.disable_Pricing_template = false;
                // filter the total dependent values based on selected country value 
                this.totalDependentValues_Pricing_template.forEach(conValues => {
                    for(var i=0;i<conValues.validFor.length;i++){
                        if(conValues.validFor[i] === this.controlValues_Pricing_template[value]) {
                            dependValues.push({
                                label: conValues.label,
                                value: conValues.value
                            })
                        }
                    }                   
                })    
                this.pricingTemplateOptions = dependValues;
            }
        }

        if(this.prospect)
        this.prospect[event.target.name] = event.target.value;
    }

    @wire(getPicklistValues, { recordTypeId: '012000000000000AAA', fieldApiName: ROLE_FIELD }) //recordTypeId: Provided dummy value as it is required.
    wiredPicklistValues({ error, data }) {
        this.showSpinner =true;
        if (data) {            
            console.log(data.values);
            var temp=[];
            for(let i in data.values){
                temp.push({ label: data.values[i].label, value:  data.values[i].value });
            }
            this.roleOptions = temp;
            this.prospectjson = JSON.parse(JSON.stringify(this.jsondata));
            this.error = undefined;
            this.showSpinner =false;
        } else if (error) {
            this.error = error;
            this.showSpinner =false;
        }
    }

    @wire(getPicklistValues, { recordTypeId: '012000000000000AAA', fieldApiName: PRODUCT_FOCUS_FIELD }) //recordTypeId: Provided dummy value as it is required.
    wiredPicklistValues2({ error, data }) {
        this.showSpinner =true;
        if (data) {            
            console.log(data.values);
            var temp=[];
            for(let i in data.values){
                temp.push({ label: data.values[i].label, value:  data.values[i].value });
            }
            this.productFocusOptions = temp;
            this.error = undefined;
            this.showSpinner =false;
        } else if (error) {
            this.error = error;
            this.showSpinner =false;
        }
    }

    handleUpdateProspect(event){
        var allValid1 = [...this.template.querySelectorAll('lightning-combobox')]
                        .reduce((validSoFar, inputCmp) => {
                                    inputCmp.reportValidity();
                                    return validSoFar && inputCmp.checkValidity();
                        }, true);
                               
        var allValid2 = [...this.template.querySelectorAll('lightning-input')]
                        .reduce((validSoFar, inputCmp) => {
                                    inputCmp.reportValidity();
                                    return validSoFar && inputCmp.checkValidity();
                        }, true); 
        
        var allValid3 =true;                
            if(this.prospect.Phone_Type1__c==undefined || this.prospect.Phone_Type1__c=='' ||
                this.prospect.Decision_Maker__c==undefined || this.prospect.Decision_Maker__c=='' ||
                this.prospect.Payment_Term__c==undefined || this.prospect.Payment_Term__c=='' ||
                this.prospect.Primary_Product__c==undefined || this.prospect.Primary_Product__c==''){
                if(this.prospect.Phone_Type1__c==undefined){
                    //this.prospect.Phone_Type1__c='';
                }
                if(this.prospect.Decision_Maker__c==undefined){
                    //this.prospect.Decision_Maker__c='';
                }
                if(this.prospect.Payment_Term__c==undefined){
                    //this.prospect.Payment_Term__c='';
                }
                if(this.prospect.Primary_Product__c==undefined){
                   // this.prospect.Primary_Product__c='';
                }
                //this.template.querySelector('c-reusepicklistinlwc').reportValidity();
                allValid3 = false;
            }
            
            
        if (allValid1 && allValid2 && allValid3) {
            //alert('All form entries look valid. Ready to submit!');
            this.prospect['isSubmitted'] = true;
           // this.accountSetupJson[this.index] = this.accRec;
            this.prospectjson[this.index] = this.prospect;
            this.template.querySelector("section").classList.add("slds-hide");
            this.template.querySelector("div.modalBackdrops").classList.add("slds-hide");
        } else {
            alert('Please fill all the mandatory fields.');
        }
    }
    handlePicklistChange(event){
        if(this.prospect)
        this.prospect[event.detail.fieldAPIName] = event.detail.selectedValue;
    }
    handleChange( event) {
        console.log('Current value of the input: ' + event.target.value);
        console.log('Current value of the input: ' + event.target.name);
        if(this.prospect)
        this.prospect[event.target.name] = event.target.value;
    }
    handleLookupChange( event) {
        //console.log('Current value of the input: ' + event.target.value);
        //console.log('Current value of the input: ' + event.target.name);
        if(this.prospect)
        this.prospect[event.detail.selectName] = event.detail.currentRecId;
    }
    @api
    saveProspects() {
        //alert('In Account Setup component');
        this.showSpinner=true;
        var isValid = true;
        if(this.prospectjson){
            for(var index in this.prospectjson){
                if(!this.prospectjson[index].isSubmitted){
                    isValid = false;
                    this.showSpinner=false;
                    alert('Some Information is missing for account ',this.prospectjson[index].Name);
                    break;
                }
            }

            for(var index in this.prospectjson){
                delete this.prospectjson[index]['isSubmitted'];
                //delete this.prospectjson[index]['Index'];
            }
        }
        if(isValid){
            //this.showSpinner = true;
            commitProspects({ prospects: JSON.stringify(this.prospectjson), orgs: JSON.stringify(this.jsonorg)})
            .then(result => {
                let data = result;
                console.log('data=>',data);
                for (var key in data) {
                    /*custs.push({
                        value: key,
                        label: data[key]
                    });*/
                    let index = this.findRowIndexById(key);
                    this.prospectjson[index]['Id'] = data[key]; 
                }
                console.log('prospectjson=>',this.prospectjson);
                const fireEvent = new CustomEvent('changejson', {
                    detail: {
                      screen:'PROSPECT',
                      json: this.prospectjson
                    }
                });
                this.dispatchEvent(fireEvent);

                /*const fireEvent = new CustomEvent('changestep', {
                    detail: 'Step4'
                });
                this.dispatchEvent(fireEvent);*/

                this.showSpinner = false;
            })
            .catch(error => {
                this.showSpinner = false;
                console.log(error);
                alert(error.body.message);
            });
        }
        //this.showSpinner = false;
    }

}