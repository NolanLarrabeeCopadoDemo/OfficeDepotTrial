import { LightningElement, api, track } from 'lwc';

export default class Flow_picklist extends LightningElement {

    // Input fields
    @api objectName;
    @api field1Name;
    @api field1Default = null;
    @api field1Required;
    @api field2Name;
    @api field2Default = null;
    @api field2Required;
    @api field3Name;
    @api field3Default = null;
    @api field3Required;
    @api field4Name;
    @api field4Default = null;
    @api field4Required;
    @api field5Name;
    @api field5Default = null;
    @api field5Required;
    @api field6Name;
    @api field6Default = null;
    @api field6Required;

    // Output fields
    @api field1SelectedValue
    @api field2SelectedValue
    @api field3SelectedValue
    @api field4SelectedValue
    @api field5SelectedValue
    @api field6SelectedValue

    @api
    validate() {
        let errorMessage = '';
        if(this.field6Required === true && !this.field6SelectedValue) errorMessage = 'Please fill out all required fields.';
        if(this.field5Required === true && !this.field5SelectedValue) errorMessage = 'Please fill out all required fields.';
        if(this.field4Required === true && !this.field4SelectedValue) errorMessage = 'Please fill out all required fields.';
        if(this.field3Required === true && !this.field3SelectedValue) errorMessage = 'Please fill out all required fields.';
        if(this.field2Required === true && !this.field2SelectedValue) errorMessage = 'Please fill out all required fields.';
        if(this.field1Required === true && !this.field1SelectedValue) errorMessage = 'Please fill out all required fields.';

        if(errorMessage !== '') {
            sessionStorage.setItem('flowField1' + this.field1Name, this.field1SelectedValue);
            sessionStorage.setItem('flowField2' + this.field2Name, this.field2SelectedValue);
            sessionStorage.setItem('flowField3' + this.field3Name, this.field3SelectedValue);
            sessionStorage.setItem('flowField4' + this.field4Name, this.field4SelectedValue);
            sessionStorage.setItem('flowField5' + this.field5Name, this.field5SelectedValue);
            sessionStorage.setItem('flowField6' + this.field6Name, this.field6SelectedValue);
            return {
                isValid: false,
                errorMessage: errorMessage
            };
        } else {
            return {
                isValid: true
            };
        }
    }

    connectedCallback() {
        let field1Value = sessionStorage.getItem('flowField1' + this.field1Name);
        let field2Value = sessionStorage.getItem('flowField2' + this.field2Name);
        let field3Value = sessionStorage.getItem('flowField3' + this.field3Name);
        let field4Value = sessionStorage.getItem('flowField4' + this.field4Name);
        let field5Value = sessionStorage.getItem('flowField5' + this.field5Name);
        let field6Value = sessionStorage.getItem('flowField6' + this.field6Name);

        this.field1SelectedValue = !!field1Value ? field1Value : this.field1Default;
        this.field2SelectedValue = !!field2Value ? field2Value : this.field2Default;
        this.field3SelectedValue = !!field3Value ? field3Value : this.field3Default;
        this.field4SelectedValue = !!field4Value ? field4Value : this.field4Default;
        this.field5SelectedValue = !!field5Value ? field5Value : this.field5Default;
        this.field6SelectedValue = !!field6Value ? field6Value : this.field6Default;
    }

    onChange(event) {
        this[event.target.name] = event.target.value;

        if(event.target.name === 'field1SelectedValue') {
            this.field1SelectedValue = event.target.value;
            sessionStorage.setItem('flowField1' + this.field1Name, this.field1SelectedValue);
        } else if(event.target.name === 'field2SelectedValue') {
            this.field2SelectedValue = event.target.value;
            sessionStorage.setItem('flowField2' + this.field2Name, this.field2SelectedValue);
        } else if(event.target.name === 'field3SelectedValue') {
            this.field3SelectedValue = event.target.value;
            sessionStorage.setItem('flowField3' + this.field3Name, this.field3SelectedValue);
        } else if(event.target.name === 'field4SelectedValue') {
            this.field4SelectedValue = event.target.value;
            sessionStorage.setItem('flowField4' + this.field4Name, this.field4SelectedValue);
        } else if(event.target.name === 'field5SelectedValue') {
            this.field5SelectedValue = event.target.value;
            sessionStorage.setItem('flowField5' + this.field5Name, this.field5SelectedValue);
        } else if(event.target.name === 'field6SelectedValue') {
            this.field6SelectedValue = event.target.value;
            sessionStorage.setItem('flowField6' + this.field6Name, this.field6SelectedValue);
        }
    }
}